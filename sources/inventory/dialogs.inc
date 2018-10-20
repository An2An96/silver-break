#if defined _inventory_dialogs_included
  #endinput
#endif

#define _inventory_dialogs_included

#include "player/ask"
#include "faction/police/header"

static string[256];

DialogCreate:Inv_Drop(playerid)
{
	new thing 	= GetPVarInt(playerid, "Inv:Thing:Thing"),
		count 	= GetPVarInt(playerid, "Inv:Thing:Count");
	if(count == 1 || GetThingMaxStack(thing) == 1)
	{
		Dialog_CallResponse(playerid, Dialog:Inv.Drop, true, 0, "1");
	}
	else
	{
		new option 	= GetPVarInt(playerid, "Inv:Thing:Option");
		format(string, sizeof(string), "Выбросить - "MAIN_COLOR"%s, %dшт.", GetThingName(thing, option), count);
		Dialog_Open(playerid, Dialog:Inv_Drop, DIALOG_STYLE_INPUT, string, 
			"{FFFFFF}Введите количество, которое хотите выкинуть:\n\n\
    		Подсказка: Оставьте поле пустым чтобы выкинуть все", "Выбрать", "Назад");
	}
	return true;
}

DialogResponse:Inv_Drop(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new title[32], format_title[32];
		new type	= GetPVarInt(playerid, "Inv:Thing:Type"),
			thingid	= GetPVarInt(playerid, "Inv:Thing:ID"),
			thing	= GetPVarInt(playerid, "Inv:Thing:Thing"),
			option	= GetPVarInt(playerid, "Inv:Thing:Option"),
			count 	= GetPVarInt(playerid, "Inv:Thing:Count"),
			slot 	= GetPVarInt(playerid, "Inv:Thing:Slot");
		
		new inputCount 	= IsNull(inputtext) ? count : strval(inputtext);
		if(inputCount < 1 || inputCount > count)
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас нет такого количества этих предметов.");
			return Dialog_Show(playerid, Dialog:Inv.Drop);
		}

		if(type == TH_TYPE_WEAPON)	//	Оружие
		{
			if(PlayerInfo[playerid][pGunLic] == 0)
			{
				foreach(Cop, c)
				{
					if(GetDistanceBetweenPlayers(playerid, c) < 30.0)
					{
						CrimePlayer(playerid, CRIME_HAVE_GUN);
						break;
					}
				}
			}
		}
		else
		{
			if(GetThingLegally(thing) == 0)
			{
				foreach(Cop, c)
				{
					if(GetDistanceBetweenPlayers(playerid, c) < 30.0)
					{
						CrimePlayer(playerid, CRIME_THINGS);
						break;
					}
				}
			}
		}

		//	Если выкидывает из коробки
		/*format(string, sizeof(string), "SELECT `source`, `source_type` FROM `inventory` WHERE `id` = '%d'", thingid);
		new Cache:result = mysql_query(g_SQL, string);
		if(cache_num_rows())
		{
			new sourceID, selectedTab;
			cache_get_value_name_int(0, "source",		sourceID);
			cache_get_value_name_int(0, "source_type",	selectedTab);
			//if(selectedTab == _:TAB_IN_HAND)
			//{
				//	Уменьшаем значение вложенных вещей на единицу
			//	format(string, sizeof(string), "UPDATE `inventory` SET `count` = `count` - 1 WHERE `id` = '%d'", sourceID);	
			//	mysql_query_ex(string);
			//}
			cache_delete(result);
		}*/

		strput(title, GetThingName(thing, option));
		strput(format_title, GetThingName(thing, option, true));

		new Float:pos[3];
		GetPlayerPos(playerid, Arr3<pos>);
		pos[2] -= 1.0 - GetThingObjectHeight(thing);

		Inv.CreateThrowThing(thing, option, thingid, inputCount, Arr3<pos>);
		Inv.ThrowThing(thingid, Arr3<pos>);

		format(string, sizeof(string), "выбрасывает %s на землю.", format_title);
		PlayerAction(playerid, string);
		MyApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 0, 1, 1, 0, 0);

		Inv.UpdateVisualItem(playerid, slot);
	}
	return true;
}

DialogCreate:Inv_Throw(playerid)
{
	new lstring[1024];
	if(NearThings(playerid))
	{
    	format(lstring, sizeof(lstring), "Предмет\tКоличество\n");
    	for(new i = 0; i < 32; i++)
		{
			new item = playerNearThings[playerid][i];
			if(item != INVALID_DATA)
			{
				new data[7];
				Streamer_GetArrayData(STREAMER_TYPE_OBJECT, item, E_STREAMER_EXTRA_ID, data);
				if(GetThingType(data[3]) == TH_TYPE_IN_HAND)	data[4] = 1;
				format(lstring, sizeof(lstring), "%s" MAIN_COLOR "• {FFFFFF}%s\t%d шт.\n",
					lstring, GetThingName(data[3], data[4]), data[5]);
			}
		}
		Dialog_Open(playerid, Dialog:Inv_Throw, DIALOG_STYLE_TABLIST_HEADERS, "Предметы на земле:", lstring, "Поднять", "Закрыть");
	}
	return true;
}

DialogResponse:Inv_Throw(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(playerNearThings[playerid][listitem] != INVALID_DATA)
		{
			SetPVarInt(playerid, "Inv:PickupThing:Item", listitem);
			Dialog_Show(playerid, Dialog:Inv.PickupThing);
		}
	}
	return true;
}

DialogCreate:Inv_PickupThing(playerid)
{
	new i = GetPVarInt(playerid, "Inv:PickupThing:Item");

	if(playerNearThings[playerid][i] == INVALID_DATA)
	{
		return Dialog_Show(playerid, Dialog:Inv.Throw);
	}
	new item = playerNearThings[playerid][i];

	new data[7];
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, item, E_STREAMER_EXTRA_ID, data);

	if(data[3] == 0 || data[5] == 0)
	{
		return Dialog_Show(playerid, Dialog:Inv.Throw);
	}

	if(data[5] == 1)
	{
		return Dialog_CallResponse(playerid, Dialog:Inv_PickupThing, true, 0, "1");
	}
	format(string, sizeof(string), "Подобрать - " MAIN_COLOR "%s, %d шт.", 
			GetThingName(data[3], data[4]), data[5]);
	
	Dialog_Open(playerid, Dialog:Inv_PickupThing, DIALOG_STYLE_INPUT, string, 
			"{FFFFFF}Введите количество, которое хотите поднять:\n\n\
    		Подсказка: Оставьте поле пустым чтобы поднять все", "Выбрать", "Назад");
	return true;
}

DialogResponse:Inv_PickupThing(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new i = GetPVarInt(playerid, "Inv:PickupThing:Item");
    	if(playerNearThings[playerid][i] == INVALID_DATA)
		{
			return Dialog_Show(playerid, Dialog:Inv.PickupThing);
		}
		new item = playerNearThings[playerid][i];

		new data[7];
		Streamer_GetArrayData(STREAMER_TYPE_OBJECT, item, E_STREAMER_EXTRA_ID, data);

		new inputCount 	= IsNull(inputtext) ? data[5] : strval(inputtext);
		if(!Inv.RaiseThing(playerid, item, inputCount))
		{
			Dialog_Show(playerid, Dialog:Inv.Throw);
		}
	}
	else
	{
		Dialog_Show(playerid, Dialog:Inv.Throw);
	}
	return true;
}

DialogCreate:Inv_InputPlayer(playerid)
{
	Dialog_Open(playerid, Dialog:Inv_InputPlayer, DIALOG_STYLE_INPUT, "Инвентарь - Передача предмета", "{FFFFFF}Введите id или имя игрока, которому хотите передать предмет:", "Ввод", "Назад");
	return true;
}

DialogResponse:Inv_InputPlayer(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new giveplayerid;
		if(sscanf(inputtext, "r", giveplayerid))
		{
			return Dialog_Show(playerid, Dialog:Inv.InputPlayer);
		}
		if(giveplayerid == playerid)
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете передать вещи самому себе.");
			return Dialog_Show(playerid, Dialog:Inv.InputPlayer);
		}
	 	if(IsPlayerLogged(giveplayerid) == 0)
	 	{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого игрока нет на сервере.");
			return Dialog_Show(playerid, Dialog:Inv.InputPlayer);
	    }
		if(IsPlayerNearPlayer(playerid, giveplayerid, 4.0) == 0)
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этот игрок слишком далеко от вас.");
			return Dialog_Show(playerid, Dialog:Inv.InputPlayer);
		}
		gTargetid[playerid] = giveplayerid;
		Dialog_Show(playerid, Dialog:Inv.GiveThing);
	}
	return true;
}

DialogCreate:Inv_GiveThing(playerid)
{
	new string2[256];
	format(string2, sizeof(string2),
		"{FFFFFF}Вы собираетесь передать предмет "MAIN_COLOR"%s{FFFFFF}'у\n\n\
		{FFFFFF}Введите количество и стоимость через пробел.\n\
		Чтобы отдать бесплатно, оставьте стоимость пустой",
			ReturnPlayerName(gTargetid[playerid]));

	format(string, sizeof(string), "Передача - "MAIN_COLOR"%s, %d шт.", 
		GetThingName(GetPVarInt(playerid, "Inv:Thing:Thing"), GetPVarInt(playerid, "Inv:Thing:Option")), GetPVarInt(playerid, "Inv:Thing:Count"));

	Dialog_Open(playerid, Dialog:Inv_GiveThing, DIALOG_STYLE_INPUT, string, string2, "Ввод", "Назад");
	return true;
}

DialogResponse:Inv_GiveThing(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new inputCount, price = 0;
		if(sscanf(inputtext, "d", inputCount))
		{
			return Dialog_Show(playerid, Dialog:Inv.GiveThing);
		}
		if(inputCount <= 0)
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Неверно введено количество.");
			return Dialog_Show(playerid, Dialog:Inv.GiveThing);
		}
		sscanf(inputtext, "{d}d", price);
		if(price < 0)
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Неверно введена стоимость.");
			return Dialog_Show(playerid, Dialog:Inv.GiveThing);
		}
		new giveplayerid = gTargetid[playerid];
		new thing 	= GetPVarInt(playerid, "Inv:Thing:Thing"),
			option 	= GetPVarInt(playerid, "Inv:Thing:Option"),
			count 	= GetPVarInt(playerid, "Inv:Thing:Count");
    	if(count)
    	{
    		if(count < inputCount)
    		{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас столько нет.");
				return Dialog_Show(playerid, Dialog:Inv.GiveThing);
			}
			if(AskPlayer(playerid, giveplayerid, ASK_GIVE_THING, 30, price, inputCount, thing, option))
			{
				// AskAmount[giveplayerid] = price;
				// AskAmount2[giveplayerid] = inputCount;
				// AskAmount3[giveplayerid] = thing;
				// AskAmount4[giveplayerid] = option;
				if(price)
				{
					SendFormatMessage(giveplayerid, COLOR_WHITE, string, "%s хочет продать вам '%s' (%d шт.) за %d$ "ASK_CONFIRM_INFO,  ReturnPlayerName(playerid), GetThingName(thing, option), inputCount, price);
					SendFormatMessage(playerid, COLOR_WHITE, string, "Вы предложили %s купить у вас '%s' (%d шт.) за %d$", ReturnPlayerName(giveplayerid), GetThingName(thing, option), inputCount, price);
				}
				else
				{
					SendFormatMessage(giveplayerid, COLOR_WHITE, string, "%s хочет передать вам '%s' (%d шт.) "ASK_CONFIRM_INFO,  ReturnPlayerName(playerid), GetThingName(thing, option), inputCount);
					SendFormatMessage(playerid, COLOR_WHITE, string, "Вы предложили %s взять от вас '%s' (%d шт.)", ReturnPlayerName(giveplayerid), GetThingName(thing, option), inputCount);
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У игрока есть не принятый запрос, попробуйте позже.");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас уже нет этого предмета.");
			return true;
		}
		DeletePVar(playerid, "Inv:Thing:ID");
		DeletePVar(playerid, "Inv:Thing:Thing");
		DeletePVar(playerid, "Inv:Thing:Option");
		DeletePVar(playerid, "Inv:Thing:Type");
		gTargetid[playerid] = INVALID_PLAYER_ID;
	}
	return true;
}

DialogResponse:GiveThing(playerid, response, listitem, inputtext[])
{
	new targetid = GetPVarInt(playerid, "sdfsdfsdffd"), amount = GetPVarInt(playerid, "sdfsdfsdffd2"), thing = listitem + 1;
	if (response && IsPlayerLogged(targetid))
	{
		Inv.AddPlayerThing(targetid, thing, amount);
		format(string, sizeof(string), "[AdmCmd]: %s %s[%d] выдал %s[%d]: %s (%d шт.)",
			GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid, GetThingName(thing), amount);
		SendAdminMessage(COLOR_ADMIN, string);
		SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] выдал вам: %s (%d шт.)", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, GetThingName(thing), amount);
	}
	DeletePVar(playerid, "sdfsdfsdffd");
	DeletePVar(playerid, "sdfsdfsdffd2");
	return 1;
}