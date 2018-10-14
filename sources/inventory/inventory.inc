#if defined _inventory_included
  #endinput
#endif

#define _inventory_included

#define MAX_THROW_THINGS		200		//	Максимальное количество выброшеных на карту предметов
#define MAX_WEIGHT				10.0	//	Максимальный вес без улучшений в инвентаре

forward Float:GetThingWeight(thing);
forward Float:GetPlayerInventoryWeight(playerid);
forward Float:GetPlayerMaxWeight(playerid);

enum
{
	SOURCE_PLAYER,
	SOURCE_VEHICLE
}

enum
{
	INV_ACTION_USE = 1,
	INV_ACTION_GIVE,
	INV_ACTION_DROP
}

enum
{
	TH_TYPE_WEAPON,
	TH_TYPE_DEFAULT,
	TH_TYPE_ACSR
}

enum
{
	THING_NONE,
	// Usual
	THING_WATCH,
	THING_GASCAN,
	THING_CHOCOLATE,
	THING_FIREWORK,
	THING_PICKLOCK,
	THING_FIRSTAID,
	THING_CIGARETTE,
	THING_METALL,
	THING_GUN_MATS,
	THING_DRUGS_MATS,
	THING_DRUGS,
	THING_CHIPS,
	//	Other
	THING_PRESENTBOX,
	THING_HELPREWARD,
	//	Clothes
	THING_MUSIC,
	THING_GLASS,
	THING_MASK,
	THING_HELMET,
	THING_HAT,
}

enum
{
	USE_ONEOFF,     // Автоматически забирать после использования
	USE_FULLY,		// Забирать все количество при использовании
	USE_REUSABLE,   // Не забирать предмет после использования (может забираться в ручную)
}

enum THING_INFO
{
	T_TITLE[32],
	T_DESCRIP[64],
	T_TYPE,
	Float:T_WEIGHT,	//	Вес предмета
	T_OBJECTID,
	T_USETYPE,
	bool:T_LEGALLY,
	T_FUNC[32],
}
new const thingData[][THING_INFO] =
{
	{	"No-one",					"",	TH_TYPE_DEFAULT,	0.000,	0,		USE_REUSABLE,	true,	""	},
	{	"Часы", 					"Наручные часы, чтобы всегда знать точное время",					TH_TYPE_DEFAULT,	0.100,	19043,	USE_REUSABLE,	true,	"" 	},
	{	"Канистра с бензином", 		"Канистра с бензином, позволяет заправить авто если вы обсохли",	TH_TYPE_DEFAULT,	5.000,	1650,	USE_ONEOFF,		true,	"" 	},
	{	"Гамбургер", 				"Гамбургер позволяет немного утолить голод",	TH_TYPE_DEFAULT,	0.200,	19811,	USE_ONEOFF,		true,	""	},
	{	"Фейерверк",				"Текст...",	TH_TYPE_DEFAULT,	1.000,	3786,	USE_ONEOFF,		true,	"" 	},
	{	"Отмычка",			 		"Текст...",	TH_TYPE_DEFAULT,	0.010,	1279,	USE_REUSABLE,	true,	""	},
	{	"Бинты",			 		"Текст...",	TH_TYPE_DEFAULT,	0.100,	11736,	USE_ONEOFF,		true,	""	},
	{	"Сигареты",			 		"Текст...",	TH_TYPE_DEFAULT,	0.010,	19897,	USE_ONEOFF,		true,	"" 	},	// 3044
	{	"Металл",					"Текст...",	TH_TYPE_DEFAULT,	0.500,	1575,	USE_FULLY,		true,	""	},
	{	"Материалы",				"Текст...",	TH_TYPE_DEFAULT,	0.005,	1578,	USE_ONEOFF,		false,	""	},
	{	"Трава",					"Текст...",	TH_TYPE_DEFAULT,	0.100,	1577,	USE_FULLY,		false,	""	},
	{   "Наркотики",                "Текст...",	TH_TYPE_DEFAULT,	0.050,	1576,	USE_ONEOFF,		false,	"" 	},
	{	"Фишки казино (чипы)",		"Текст...",	TH_TYPE_DEFAULT,	0.001,	1904,	USE_REUSABLE,	true,	""	},
	{	"Первооткрыватель", 		"Текст...",	TH_TYPE_DEFAULT,	1.000,	19055,	USE_ONEOFF,		true,	""	},
	{	"Награда за помощь", 		"Текст...",	TH_TYPE_DEFAULT,	1.000,	902,	USE_REUSABLE,	true,	""	},
//	Одежда	
	{	"Наушники",					"Текст...",	TH_TYPE_ACSR,		0.50,	19421,	USE_REUSABLE,	true,	"Wear"	},
	{	"Очки",						"Текст...",	TH_TYPE_ACSR,		0.10,	19006,	USE_REUSABLE,	true,	"Wear"	},
	{	"Бандана",					"Текст...",	TH_TYPE_ACSR,		0.10,	18911,	USE_REUSABLE,	true,	"Wear"	},
	{	"Мото-шлем",				"Текст...",	TH_TYPE_ACSR,		0.50,	18645,	USE_REUSABLE,	true,	"Wear"	},
	//	Шапки
	{	"Панама",					"Текст...",	TH_TYPE_ACSR,		0.10,	19107,	USE_REUSABLE,	true,	"Wear"	}
	/*{	"Каска (красная)",			2,	0.10,	19117,	USE_REUSABLE,	true,	"WearPlayerHat"	},
	{	"Каска (зеленая)",			2,	0.10,	19118,	USE_REUSABLE,	true,	"WearPlayerHat"	},
	{	"Каска (синия)",			2,	0.10,	19119,	USE_REUSABLE,	true,	"WearPlayerHat"	},
	{	"Каска (желтая)",			2,	0.10,	19120,	USE_REUSABLE,	true,	"WearPlayerHat"	},
	{	"Шапка (черная)",			2,	0.10,	18953,	USE_REUSABLE,	true,	"WearPlayerHat"	},
	{	"Шапка (светлая)",			2,	0.10,	18954,	USE_REUSABLE,	true,	"WearPlayerHat"	},
	{	"Строительная каска",		2,	0.10,	18638,	USE_REUSABLE,	true,	"WearPlayerHat"	},*/
		//	в другую категорию
	//{	"Панама (оранжевая)",		2,	0.10,	18967,	USE_REUSABLE,	true,	"WearPlayerHat"	},
	//{	"Панама (черная)",			2,	0.10,	18968,	USE_REUSABLE,	true,	"WearPlayerHat"	},
	//{	"Панама (клетчатая)",		2,	0.10,	18969,	USE_REUSABLE,	true,	"WearPlayerHat"	},
};

enum E_THROW_INFO
{
	TH_TYPE,
	TH_THING,
	TH_OPTION,
	TH_COUNT,
	TH_OBJECTID,
	Text3D:TH_TEXT3D,
}
new gThrowThings[MAX_THROW_THINGS][E_THROW_INFO];
new playerNearThings[MAX_PLAYERS][32];

new oldThrowSlot = 0;

IsThing(thing)
{
	return (0 <= thing < sizeof(thingData)) ? true : false;
}

GetThingName(thing)	
{
	new title[32] = "undefined";
	if(IsThing(thing))	strput(title, thingData[thing][T_TITLE]);
	return title;
}

GetThingDescrip(thing)
{
	new descrip[32];
	if(IsThing(thing))	strput(descrip, thingData[thing][T_DESCRIP]);
	return descrip;
}

GetThingType(thing)	
{
	if(IsThing(thing))	return thingData[thing][T_TYPE];
	return 0;
}

GetThingObject(thing)	
{
	if(IsThing(thing))	return thingData[thing][T_OBJECTID];
	return 0;
}

GetThingUseType(thing)
{
	if(IsThing(thing))	return thingData[thing][T_USETYPE];
	return 0;
}

GetThingLegally(thing)
{
	if(IsThing(thing))	return thingData[thing][T_LEGALLY];
	return false;
}

GetThingFunc(thing)	
{
	new func[32] = "";
	if(IsThing(thing))	strput(func, thingData[thing][T_FUNC]);
	return func;
}

stock Float:GetThingWeight(thing)
{
	if(IsThing(thing))	return thingData[thing][T_WEIGHT];
	return 0.0;
}

stock Float:GetPlayerInventoryWeight(playerid)
{
	if(!IsPlayerLogged(playerid))	return 0.0;

	new stmp[128], Float:weight;
	mysql_format(g_SQL, stmp, sizeof(stmp), "SELECT `thing`, `count` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d'", PlayerInfo[playerid][pUserID], SOURCE_PLAYER);
	new Cache:result = mysql_query(g_SQL, stmp);
	for(new i = 0, thing, count; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i, "thing", thing);
		cache_get_value_name_int(i, "count", count);
		weight += GetThingWeight(thing) * count;
	}
	cache_delete(result);
	return weight;
}

stock Float:GetPlayerMaxWeight(playerid)
{
	#pragma unused playerid
	return MAX_WEIGHT;
}

stock ShowPlayerInventory(playerid)
{
	Inv_IFace_Inventory_Show(playerid);

	new string[128];
	mysql_format(g_SQL, string, sizeof(string), "SELECT `slot`, `thing`, `count`, `used` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d'", PlayerInfo[playerid][pUserID], SOURCE_PLAYER);
	new Cache:result = mysql_query(g_SQL, string);
	
	new rows = cache_num_rows();
	new slot, thing;

	//	Обновляем слоты предметов
	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name_int(i, "slot",		slot);
		cache_get_value_name_int(i, "thing",	thing);
		//cache_get_value_name_int(count_item, "count", count);
		//cache_get_value_name_int(count_item, "used", used);

		Inv_IFace_SetItem(playerid, slot, GetThingObject(thing));

		/*if(count_item < rows)
		{
			
		}
		else
		{
			model = 0;
			//	Оружие
			for(; slot < 13; slot++)
			{
				if(!MyGetPlayerWeaponID(playerid, slot)
				|| !MyGetPlayerWeaponAmmo(playerid, slot))
				{
					continue;
				}
				model = GetWeaponModel(MyGetPlayerWeaponID(playerid, slot));
				slot++;
				break;
			}
		}*/
	}
	cache_delete(result);

	//	Обновляем слоты аксессуаров
	new model;
	for(new i = 0; i < 4; i++)
	{
		model = GetPlayerAcsrObject(playerid, i);
		Inv_IFace_SetAcsrItem(playerid, i, (model == INVALID_DATA) ? 0 : model);
	}

	SelectTextDraw(playerid, 0xB7BBC499);
	SetPVarInt(playerid, "Inv:Show", true);

	/*HidePlayerInventory(playerid);

	TextDrawShowForPlayer(playerid, tdInvBackground);
	TextDrawShowForPlayer(playerid, tdInvUpLine);
	TextDrawShowForPlayer(playerid, tdInvDownLine);
	TextDrawShowForPlayer(playerid, tdInvClose);

	new count_item;
	tdInvModel[count_item] = CreatePlayerTextDraw(playerid, 166.0 + count_item % 8 * 39, 132.0 + count_item / 8 * 48, "_");
	PlayerTextDrawBackgroundColor(playerid,tdInvModel[count_item], 0x00000077);
	PlayerTextDrawFont(playerid,tdInvModel[count_item], TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawLetterSize(playerid,tdInvModel[count_item], -2.3, -71.0);
	PlayerTextDrawTextSize(playerid,tdInvModel[count_item], 35.0, 42.0);
	PlayerTextDrawSetPreviewModel(playerid, tdInvModel[count_item], 2684);
	//PlayerTextDrawSetPreviewRot(playerid, tdInvModel[count_item], -16.000000, 0.000000, -55.000000, 1.000000); // RotX, RotY, RotZ
	PlayerTextDrawSetSelectable(playerid, tdInvModel[count_item], 1);
	PlayerTextDrawShow(playerid, tdInvModel[count_item]);
	count_item++;
	
	tdInvModel[count_item] = CreatePlayerTextDraw(playerid, 166.0 + count_item % 8 * 39, 132.0 + count_item / 8 * 48, "_");
	PlayerTextDrawBackgroundColor(playerid,tdInvModel[count_item], 0x00000077);
	PlayerTextDrawFont(playerid,tdInvModel[count_item], TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawLetterSize(playerid,tdInvModel[count_item], -2.3, -71.0);
	PlayerTextDrawTextSize(playerid,tdInvModel[count_item], 35.0, 42.0);
	PlayerTextDrawSetPreviewModel(playerid, tdInvModel[count_item], 18875);
	//PlayerTextDrawSetPreviewRot(playerid, tdInvModel[count_item], -16.000000, 0.000000, -55.000000, 1.000000); // RotX, RotY, RotZ
	PlayerTextDrawSetSelectable(playerid, tdInvModel[count_item], 1);
	PlayerTextDrawShow(playerid, tdInvModel[count_item]);
	count_item++;

	for(new i = 0, thing, count, use; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i, "thing", thing);
		cache_get_value_name_int(i, "count", count);
		cache_get_value_name_int(i, "used", use);

		tdInvModel[count_item] = CreatePlayerTextDraw(playerid, 166.0 + count_item % 8 * 39, 132.0 + count_item / 8 * 48, "_");
		if(use)	PlayerTextDrawBackgroundColor(playerid,tdInvModel[count_item], 0x9ACD3277);
		else 	PlayerTextDrawBackgroundColor(playerid,tdInvModel[count_item], 0x00000077);
		PlayerTextDrawFont(playerid,tdInvModel[count_item], TEXT_DRAW_FONT_MODEL_PREVIEW);
		PlayerTextDrawLetterSize(playerid,tdInvModel[count_item], -2.3, -71.0);
		PlayerTextDrawTextSize(playerid,tdInvModel[count_item], 35.0, 42.0);
		PlayerTextDrawSetPreviewModel(playerid, tdInvModel[count_item], GetThingObject(thing));
		//PlayerTextDrawSetPreviewRot(playerid, tdInvModel[count_item], -16.000000, 0.000000, -55.000000, 1.000000); // RotX, RotY, RotZ
		PlayerTextDrawSetSelectable(playerid, tdInvModel[count_item], 1);

		format(string, sizeof(string), "x%d", count);
		tdInvCount[count_item] = CreatePlayerTextDraw(playerid, 200.0 + count_item % 8 * 39, 164.0  + count_item / 8 * 48, string);
		PlayerTextDrawAlignment(playerid,tdInvCount[count_item], 3);
		PlayerTextDrawFont(playerid,tdInvCount[count_item], 1);
		PlayerTextDrawLetterSize(playerid,tdInvCount[count_item], 0.34, 1.0);
		PlayerTextDrawColor(playerid,tdInvCount[count_item], -1);
		PlayerTextDrawSetShadow(playerid,tdInvCount[count_item], 1);

		PlayerTextDrawShow(playerid, tdInvModel[count_item]);
		PlayerTextDrawShow(playerid, tdInvCount[count_item]);

		count_item++;
	}
	cache_delete(result);

	//	Оружие
	for(new s = 0; s < 13; s++)
	{
		if(p_Protect[playerid][prWeaponID][s] == 0)							continue;
		if(p_Protect[playerid][prWeaponAmmo][s] == 0)						continue;
		
		tdInvModel[count_item] = CreatePlayerTextDraw(playerid, 166.0 + count_item % 8 * 39, 132.0 + count_item / 8 * 48, "_");
		if(GetPlayerWeapon(playerid) == p_Protect[playerid][prWeaponID][s])
		{
			PlayerTextDrawBackgroundColor(playerid,tdInvModel[count_item], 0x9ACD3277);
		}
		else
		{
			PlayerTextDrawBackgroundColor(playerid,tdInvModel[count_item], 0x00000077);
		}
		PlayerTextDrawFont(playerid,tdInvModel[count_item], TEXT_DRAW_FONT_MODEL_PREVIEW);
		PlayerTextDrawLetterSize(playerid,tdInvModel[count_item], -2.3, -71.0);
		PlayerTextDrawTextSize(playerid,tdInvModel[count_item], 35.0, 42.0);
		PlayerTextDrawSetPreviewModel(playerid, tdInvModel[count_item], GetWeaponModel(p_Protect[playerid][prWeaponID][s]));
		//PlayerTextDrawSetPreviewRot(playerid, tdInvModel[count_item], -16.000000, 0.000000, -55.000000, 1.000000); // RotX, RotY, RotZ
		PlayerTextDrawSetSelectable(playerid, tdInvModel[count_item], 1);

		format(string, sizeof(string), "x%d", p_Protect[playerid][prWeaponAmmo][s]);
		tdInvCount[count_item] = CreatePlayerTextDraw(playerid, 200.0 + count_item % 8 * 39, 164.0  + count_item / 8 * 48, string);
		PlayerTextDrawAlignment(playerid,tdInvCount[count_item], 3);
		PlayerTextDrawFont(playerid,tdInvCount[count_item], 1);
		PlayerTextDrawLetterSize(playerid,tdInvCount[count_item], 0.34, 1.0);
		PlayerTextDrawColor(playerid,tdInvCount[count_item], -1);
		PlayerTextDrawSetShadow(playerid,tdInvCount[count_item], 1);

		PlayerTextDrawShow(playerid, tdInvModel[count_item]);
		PlayerTextDrawShow(playerid, tdInvCount[count_item]);

		count_item++;
	}

	format(string, sizeof(string), "INVENTORY [%d/%d]", count_item - 2, 10);
	tdInvTitle = CreatePlayerTextDraw(playerid, 169.0, 112.0, string);
	PlayerTextDrawLetterSize(playerid, tdInvTitle, 0.4, 1.0);
	PlayerTextDrawSetShadow(playerid, tdInvTitle, 1);
	PlayerTextDrawShow(playerid, tdInvTitle);
	
	SelectTextDraw(playerid, 0x22FF2299);*/
	return true;
}

stock HidePlayerInventory(playerid)
{
	if(GetPVarInt(playerid, "Inv:Show"))
	{
		/*PlayerTextDrawDestroy(playerid, tdInvTitle);
		
		TextDrawHideForPlayer(playerid, tdInvBackground);
		TextDrawHideForPlayer(playerid, tdInvUpLine);
		TextDrawHideForPlayer(playerid, tdInvDownLine);
		TextDrawHideForPlayer(playerid, tdInvClose);
		for(new i = 0; i < GetPVarInt(playerid, "tdINV_OPEN"); i++)
		{
			PlayerTextDrawDestroy(playerid, tdInvModel[i]);
			PlayerTextDrawDestroy(playerid, tdInvCount[i]);
		}*/

		Inv_IFace_Inventory_Hide(playerid);
		DeletePVar(playerid, "Inv:Show");
		CancelSelectTextDraw(playerid);
	}
}

stock SelectItem(playerid, item, action)
{	
	/*if(item == 0)
	{
		//	записи
	}
	else if(item == 1)
	{
		callcmd::gps(playerid, "");
	}
	else
	{*/
	//item -= 2;

	if(PlayerInfo[playerid][pJailTime])
	{
		return true;
	}
	//new action = GetPVarInt(playerid, "Inv:Thing:Action");

	new string[256];
	new bool:flag = false;
	mysql_format(g_SQL, string, sizeof(string), "SELECT `id`, `thing`, `option`, `used`, `count` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `slot` = '%d'", PlayerInfo[playerid][pUserID], SOURCE_PLAYER, item);
	new Cache:result = mysql_query(g_SQL, string);
	if(cache_num_rows())
	{
		new id, thing, option, used, count;
		cache_get_value_name_int(0, "id",			id);
		cache_get_value_name_int(0, "thing",		thing);
		cache_get_value_name_int(0, "option",		option);
		cache_get_value_name_int(0, "used",			used);
		cache_get_value_name_int(0, "count",		count);
		SetPVarInt(playerid, "Inv:Thing:Type",		GetThingType(thing));
		SetPVarInt(playerid, "Inv:Thing:ID",		id);
    	SetPVarInt(playerid, "Inv:Thing:Thing",		thing);
    	SetPVarInt(playerid, "Inv:Thing:Option",	option);
    	SetPVarInt(playerid, "Inv:Thing:Used",		used);
    	SetPVarInt(playerid, "Inv:Thing:Count",		count);
    	flag = true;
	}
	/*else 	//	Оружие
	{
		item -= GetPVarInt(playerid, "Inv:ShowItems");
    	for(new s = 0, i = 0; s < 13; s++)
    	{
    		if(!MyGetPlayerWeaponID(playerid, s)
    		|| !MyGetPlayerWeaponAmmo(playerid, s))
    		{
    			continue;
    		}

    		new used;
    		if(GetPlayerWeapon(playerid) == MyGetPlayerWeaponID(playerid, s))	used = 1;
    		if(item == i)
    		{
    			SetPVarInt(playerid, "Inv:Thing:Type",	TH_TYPE_WEAPON);
				SetPVarInt(playerid, "Inv:Thing:Thing", s);
				SetPVarInt(playerid, "Inv:Thing:Used",	used);
				SetPVarInt(playerid, "Inv:Thing:Count", MyGetPlayerWeaponAmmo(playerid, s));
				flag = true;
				break;
    		}
    		else i++;
    	}
	}*/
	cache_delete(result);
	if(flag)
	{
		//if(action)
    	//{
		Dialogid[playerid] = DINV_ACTION;
		CallLocalFunction("OnDialogResponse", "iiiis", playerid, DINV_ACTION, 1, action, " ");
		//}
		//else
		//{
		//	ShowDialog(playerid, DINV_ACTION);
		//}
	}
	return true;
}

SelectAcsrItem(playerid, slot, item)
{
	new string[256];
	mysql_format(g_SQL, string, sizeof(string), "SELECT `id`, `thing` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `slot` = '%d'", PlayerInfo[playerid][pUserID], SOURCE_PLAYER, item);
	new Cache:result = mysql_query(g_SQL, string);
	if(cache_num_rows())
	{
		new id, thing;
		cache_get_value_name_int(0, "id", id);
		cache_get_value_name_int(0, "thing", thing);

    	//	Если выбран аксессуар
    	if(GetThingType(thing) == TH_TYPE_ACSR)
    	{
			WearEx(playerid, slot, id);
    	}
	}
	cache_delete(result);
}

/*
	ifmax -	0 - возвратит 0, как ошибку; 
			1 - выдаст столько сколько влезет;
			2 - выдаст сколько надо (независимо влезает или нет)
*/
stock inv_addThing(playerid, thing, value, option = 0, ifmax = 0)
{	//---	Add thing in inventory
    
    #pragma unused ifmax
    if(!IsThing(thing) || value <= 0 || !IsPlayerLogged(playerid))	
    {
    	return false;
    }
	
    /*new maxcount = GetThingMaxCount(thing);
	if((count + value) > maxcount)
	{
		if(ifmax)	value = maxcount - count; // Нормировка
		else 		return false;
	}*/
	
	if(ifmax != 2)
	{
		new Float:weight = GetThingWeight(thing);
		new Float:inventory_weight = GetPlayerInventoryWeight(playerid);
		if((inventory_weight + (weight * value)) > MAX_WEIGHT)
		{
			SendClientMessage(playerid, COLOR_GREY, "Ошибка: В ваш инвентарь не поместиться этот предмет");
			return false;
		}	
	}
	
	new string[256];
    
    //	Поиск свободного слота
    new minslot;
	mysql_format(g_SQL, string, sizeof(string), "SELECT MIN(slot) AS `minslot` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d'", PlayerInfo[playerid][pUserID], SOURCE_PLAYER);
	new Cache:result = mysql_query(g_SQL, string);
	cache_get_value_name_int(0, "minslot", minslot);
	cache_delete(result);
	if (minslot != 1)
	{
	    minslot = 1;
	}
	else
	{
	    mysql_format(g_SQL, string, sizeof(string), 
	    	"SELECT MIN(inventory.slot + 1) AS freeslot\
	    	FROM `inventory`\
	    	LEFT JOIN `inventory` tf1\
	    	ON inventory.slot + 1 = tf1.slot\
	    	WHERE tf1.slot AND `source` = '%d' AND `source_type` = '%d' IS NULL", PlayerInfo[playerid][pUserID], SOURCE_PLAYER);
	    result = mysql_query(g_SQL, string);
		cache_get_value_name_int(0, "freeslot", minslot);
		cache_delete(result);
	}

	mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `inventory` SET `source` = '%d', `source_type` = '%d', `slot` = '%d', `thing` = '%d', `option` = '%d', `count` = '%d'", PlayerInfo[playerid][pUserID], SOURCE_PLAYER, minslot, thing, option, value);


    /*new count = inv_getThing(playerid, thing, option);
	if(count)	mysql_format(g_SQL, string, sizeof(string), "UPDATE `inventory` SET `count` = `count` + '%d' WHERE `source` = '%d' AND `source_type` = '%d' AND `thing` = '%d' AND `option` = '%d'", value, PlayerInfo[playerid][pUserID], SOURCE_PLAYER, thing, option);
	else 		mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `inventory` SET `source` = '%d', `source_type` = '%d', `thing` = '%d', `option` = '%d', `count` = '%d'", PlayerInfo[playerid][pUserID], SOURCE_PLAYER, thing, option, value);
    */
    mysql_query_ex(string);

	PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
	Inv_IFace_AddThing_Show(playerid, GetThingName(thing), GetThingObject(thing));
	return true;
}

inv_getThing(playerid, thing, option = 0)
{
    if(IsPlayerLogged(playerid) == 0)	return false;
	new stmp[128], count = 0;
	format(stmp, sizeof(stmp), "SELECT `count` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `thing` = '%d' AND `option` = '%d'", PlayerInfo[playerid][pUserID], SOURCE_PLAYER, thing, option);
	new Cache:result = mysql_query(g_SQL, stmp);
	if(cache_num_rows() > 0)	cache_get_value_name_int(0, "count", count);
	cache_delete(result);
	return count;
}

ItemStockPlayer(playerid, thing)	
{
	new stmp[128], id = 0;
	format(stmp, sizeof(stmp), "SELECT `id` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `thing` = '%d'", PlayerInfo[playerid][pUserID], SOURCE_PLAYER, thing);
	new Cache:result = mysql_query(g_SQL, stmp);
	if(cache_num_rows() > 0)	cache_get_value_name_int(0, "id", id);
	cache_delete(result);
	return id;	
}

DeleteThing(playerid, thing, count = -1)
{
	new thingid = ItemStockPlayer(playerid, thing);
	if(thingid == 0)	return false;

	return DeleteItem(thingid, count);
}

DeleteItem(thingid, count = -1)	
{
	new stmp[128], _cnt;
	format(stmp, sizeof(stmp), "SELECT `count` FROM `inventory` WHERE `id` = '%d'", thingid);
	new Cache:result = mysql_query(g_SQL, stmp);
	if(cache_num_rows())
	{
		cache_get_value_name_int(0, "count", _cnt);
	}
	cache_delete(result);
	if(count == -1)	count = _cnt;
	if(_cnt <= count)	
	{
		format(stmp, sizeof(stmp), "DELETE FROM `inventory` WHERE `id` = '%d'", thingid);
		mysql_query_ex(stmp);
		return true;
	}
	else 
	{
		format(stmp, sizeof(stmp), "UPDATE `inventory` SET `count` = '%d' WHERE `id` = '%d'", _cnt - count, thingid);	
		mysql_query_ex(stmp);
		return false;	
	}	
}

ShiftThing(playerid, sourceSlot, destSlot)
{
	new string[192];
	format(string, sizeof(string), "SELECT COUNT(*) AS `count` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `slot` = '%d'", PlayerInfo[playerid][pUserID], SOURCE_PLAYER, destSlot);
	new Cache:result = mysql_query(g_SQL, string);
	new _cnt;
	cache_get_value_name_int(0, "count", _cnt);
	if(_cnt)
	{
		return false;
	}
	cache_delete(result);

	format(string, sizeof(string), "SELECT `id`, `thing` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `slot` = '%d'", PlayerInfo[playerid][pUserID], SOURCE_PLAYER, sourceSlot);
	result = mysql_query(g_SQL, string);
	if(!cache_num_rows())
	{
		return false;
	}
	new id, sourceThing;
	cache_get_value_name_int(0, "id", id);
	cache_get_value_name_int(0, "thing", sourceThing);
	cache_delete(result);

	format(string, sizeof(string), "UPDATE `inventory` SET `slot` = '%d' WHERE `id` = '%d'", destSlot, id);	
	mysql_query_ex(string);

	//	Обновляем интерфейс
	Inv_IFace_SetItem(playerid, sourceSlot, 0);
	Inv_IFace_SetItem(playerid, destSlot,	GetThingObject(sourceThing));
	return true;
}

NearThings(playerid)
{
    for(new j = 0; j < 32; j++)	
    	playerNearThings[playerid][j] = INVALID_DATA;
	new count, Float:X, Float:Y, Float:Z;
    for(new i = 0; i < MAX_THROW_THINGS; i++)
    {
    	if(gThrowThings[i][TH_OBJECTID])	
    	{
    		Streamer_GetFloatData(STREAMER_TYPE_OBJECT, gThrowThings[i][TH_OBJECTID], E_STREAMER_X, X);
			Streamer_GetFloatData(STREAMER_TYPE_OBJECT, gThrowThings[i][TH_OBJECTID], E_STREAMER_Y, Y);
			Streamer_GetFloatData(STREAMER_TYPE_OBJECT, gThrowThings[i][TH_OBJECTID], E_STREAMER_Z, Z);
	        if(IsPlayerInRangeOfPoint(playerid, 1.5, X, Y, Z))
	        	playerNearThings[playerid][count++] = i;
    	}
    }
    return count ? true : false; 
}

playerUseThing(playerid, thing)
{
	new thingid = ItemStockPlayer(playerid, thing);
	if(thingid == 0)	return false;

	return PlayerUseItem(playerid, thingid);
}

Public: PlayerUseItem(playerid, thingid)
{
	new stmp[128];
	format(stmp, sizeof(stmp), "SELECT `thing`, `option`, `count` FROM `inventory` WHERE `id` = '%d'", thingid);
	new Cache:result = mysql_query(g_SQL, stmp);
	if(!cache_num_rows())	return cache_delete(result);
	
	new thing, option, count;
	cache_get_value_name_int(0, "thing", thing);
	cache_get_value_name_int(0, "option", option);
	cache_get_value_name_int(0, "count", count);
	cache_delete(result);

	new func[32];
	strput(func, GetThingFunc(thing));
	if(IsNull(func) == false)
	{
		if(CallLocalFunction(func, "ii", playerid, thingid) == 0)
		{
			return false;
		}
	}
	else
	{
		switch(thing)
		{
			case THING_WATCH:	
			{
				callcmd::time(playerid, "");	// Часы
			}
			case THING_GASCAN:
			{	// Канистра с бензином
				if(IsPlayerInAnyVehicle(playerid))
				{
					return SendClientMessage(playerid, COLOR_GREY, "Ошибка: Невозможно использовать эту команду из машины");
				}
				new v = GetNearVehicles(playerid);
				if(!v)
				{
					return SendClientMessage( playerid, COLOR_GREY, "Ошибка: Поблизости нет ни одной машины" );
				}
			    if(GetVehicleEngine(v))
			    {
			    	return SendClientMessage(playerid, COLOR_GREY, "Ошибка: Для заправки необходимо заглушить двигатель");
			    }
			    new const Float:add = 10.0;
			    if(VehInfo[v][vFuel] + add > GetVehicleMaxFuel(v))
			    {
			    	return SendClientMessage(playerid, COLOR_GREY, "Ошибка: В бак этого транспорта не поместиться столько бензина");
			    }
			    VehInfo[v][vFuel] += add;
			   	PlayerAction(playerid, "заливает топливо из канистры.");
			}
			case THING_CHOCOLATE:
			{	// Шоколадный батончик
				if(!EatPlayer(playerid, 35, "ест гамбургер"))
				{
					return SendClientMessage(playerid, COLOR_GREY, "Ошибка: В данный момент вы не можете есть");
				} 
		    }
		    case THING_FIREWORK:
		    {
				if(IsPlayerInAnyVehicle(playerid))
					return SendClientMessage(playerid, COLOR_GREY, "Ошибка: Запуск фейерверка недоступен из машины");
				if(GetPlayerInterior(playerid))
					return SendClientMessage(playerid, COLOR_GREY, "Ошибка: Запуск фейерверка в зданиях запрещен");
				if(GetPVarInt(playerid, "Player:InGreenZone"))
					return SendClientMessage(playerid, COLOR_GREY, "Ошибка: Запуск фейерверка недоступен в зеленой зоне");
				if(FW_Missile[playerid])
					return SendClientMessage(playerid, COLOR_GREY, "Ошибка: Вы уже поставили фейерверк");
				if(MyApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0))
				{
					new Float:X, Float:Y, Float:Z, Float:angle;
					MyGetPlayerPos(playerid, X, Y, Z, angle);
					X += floatsin(-angle, degrees);
					Y += floatcos(-angle, degrees);
					FW_Missile[playerid] = CreateObject(3786, X, Y, Z-1.5, 0.0, 90.0, 0.0);
					FW_Smoke[playerid] = CreateObject(18704, X, Y, Z-2.6, 0.0, 0.0, 0.0);
					SetTimerEx("Firework1", 6000, false, "d", playerid);
				}
		    }
		    case THING_PICKLOCK:
		    {   //  отмычка
		        if(PlayerInfo[playerid][pJob] != JOB_THEFT)
		        {
		            return SendClientMessage(playerid, COLOR_GREY, "Ошибка: Только угонщик может использовать отмычку");
		        }
		        if(GetPlayerComb(playerid) == COMB_THEFT_AUTO)
		        {
			        return SendClientMessage(playerid, COLOR_GREY, "Ошибка: Вы уже взламываете машину");
		        }
	            new v = GetNearVehicles(playerid, 1);
	            if(!v)
	            {
	                return SendClientMessage(playerid, COLOR_GREY, "Ошибка: Поблизости нет ни одной закрытой машины");
	            }
	            if(IsAvailableVehicle(v, playerid))
	            {
	                return SendClientMessage(playerid, COLOR_GREY, "Ошибка: У вас есть ключи от машины, похлопайте по карманам");
	            }
	            if(CarInfo[v][cType] == C_TYPE_PLAYER)
	            {
	            	return SendClientMessage(playerid, COLOR_GREY, "Ошибка: Вы не можете угонять личные автомобили");
	            }
			    if(VehInfo[v][vPlayers] > 0)
			    {
			    	return SendClientMessage(playerid, COLOR_GREY, "Ошибка: В машине кто-то есть");
			    }
				SetPVarInt(playerid, "LastLockCar", v);
			    BreakCar(playerid, BREAK_CAR_HACKING, 0);
		    }
		    case THING_FIRSTAID:
		    {
		        new Float:Health;
		        GetPlayerHealth(playerid, Health);
		        if(Health >= 100.0)
		        {
		            return SendClientMessage(playerid, COLOR_GREY, "Ошибка: Вам не требуется аптечка");
		        }
		        Health += 10.0;
		        if(Health > 100.0)	Health = 100.0;
		        MySetPlayerHealth(playerid, Health);
		        PlayerAction(playerid, "перевязывает рану.");
		    }
		    case THING_CIGARETTE:
		    {
		    	if(MyApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0, 1))
		    	{
		    		if(playerDrink{playerid})	ClearPlayerDrink(playerid);	
					playerSmokeCount{playerid} = 5;
			 		MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
			        PlayerAction(playerid, "закуривает сигарету.");
			        ShowPlayerHint(playerid, "~y~ЛКМ~w~ - Затянуться сигаретой.~n~~y~Enter~w~ - Закончить курить.______");
		    	}
		    }
		    case THING_METALL:
		    {
		    	if(PlayerInfo[playerid][pJob] != JOB_GUNDEAL)
		    	{
		    		return SendClientMessage(playerid, COLOR_GREY, "Ошибка: Вы не торговец оружием");
		    	}
		    	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -616.3, -478.1, 25.7))	
		    	{
					return SendClientMessage(playerid, COLOR_GREY, "Ошибка: Вы не на месте переработки металла");
		    	}
				inv_addThing(playerid, THING_GUN_MATS, (count * 100), 0, 2);
		    	PlayerAction(playerid, "изготавливает материалы");
			    SendFormatMessage(playerid, COLOR_LIGHTBLUE, stmp, "Вы переработали %d металла и получили %d материалов", count, count * 100);
		    }
		    case THING_GUN_MATS:
		    {
		    	if(PlayerInfo[playerid][pJob] != JOB_GUNDEAL)
		    	{
		    		return SendClientMessage(playerid, COLOR_GREY, "Ошибка: Вы не торговец оружием");
		    	}
		    	return ShowDialog(playerid, DJOB_GUNDEAL_GUN);
		    }
		    case THING_DRUGS_MATS:
		    {
		    	if(PlayerInfo[playerid][pJob] != JOB_DRUGDEAL)
		    	{
		    		return SendClientMessage(playerid, COLOR_GREY, "Ошибка: Вы не наркодиллер");
		    	}
		    	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2164.1, -249.25, 36.51))	
		    	{
					return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не на месте переработки");
		    	}
				if(MyApplyAnimation(playerid, "INT_SHOP", "shop_cashier", 4.1, 1, 0, 0, 1, 11000))
				{
					new bool:comb[5];
					_GenerateComb(sizeof(comb), comb);
					return SetPlayerComb(playerid, COMB_CREATE_DRUG, sizeof(comb), comb, true);
				}
		    }
			case THING_DRUGS:
			{	// Наркотики
				if(DrugsCrack[playerid])
				{	
					return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас передозировка, вы не можете принять дозу.");
				}
			    new Float:Health = MyGetPlayerHealth(playerid) + 20.0;
			    if(Health > 160.0)	Health = 160.0;
			    MySetPlayerHealth(playerid, Health);
			    
			    PlayerAction(playerid, "употребляет наркотики");
			    SetPlayerWeather(playerid, -68);
				SetPlayerDrunkLevel(playerid, GetPlayerDrunkLevel(playerid) + 1000);
			    
			    UseDrugsTime[playerid] += 60;
			    if(UseDrugsTime[playerid] > 120)
				{
				    SendClientMessage(playerid, COLOR_RED, "У вас произошла передозировка!");
				    MyApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 1, 1, 1, 1, 0, 1);
				    DrugsCrack[playerid] = true;
				}
				else
				{
					if(!IsPlayerInAnyVehicle(playerid)) MyApplyAnimation(playerid, "SMOKING", "M_smk_drag", 4.1, 0, 0, 0, 0, 0, 1);
				}
			}
		    case THING_PRESENTBOX:
		    {
		        new Float:X, Float:Y, Float:Z;
		        GetPlayerPos(playerid, X, Y, Z);
		        DestroyObject(gPresentBoxObject);
		        gPresentBoxObject = CreateObject(18678, X, Y, Z - 2.0, 0.0, 0.0, 0.0);
		        PlayerAction(playerid, "вскрывает коробку с подарком.");
		        //
		        inv_addThing(playerid, THING_FIRSTAID, 2);	// Аптечка
		        MyGivePlayerMoney(playerid, 5000);			// Конверт
		        ShowPlayerHint(playerid, "~g~Коробка с подарком~w~~n~~n~- Аптечка [2 шт]______~n~- Конверт [$5000]~n~", 8000);
	            PlayerPlaySound(playerid, 17200, 0.0, 0.0, 0.0);
		    }
		    case THING_HELPREWARD:
		    {
		        ShowPlayerHint(playerid, "~b~Награда 'За помощь!'~w~~n~~n~Выдана в знак благодарности за активную помощь серверу.~n~");
		    }
		}
	}

	new use_type = GetThingUseType(thing);
	if(use_type == USE_ONEOFF)
	{
		if(--count > 0)	format(stmp, sizeof(stmp), "UPDATE `inventory` SET `count` = '%d' WHERE `id` = '%d'", count, thingid);
		else 			format(stmp, sizeof(stmp), "DELETE FROM `inventory` WHERE `id` = '%d'", thingid);
		mysql_query(g_SQL, stmp);
	}
	else if(use_type == USE_FULLY)
	{
		DeleteThing(playerid, thing);
		format(stmp, sizeof(stmp), "DELETE FROM `inventory` WHERE `id` = '%d'", thingid);
		mysql_query(g_SQL, stmp);	
	}

	if(GetThingLegally(thing) == 0)	
	{
		foreach(Cop, c)
		{
			if(GetDistanceBetweenPlayers(playerid, c) < 30.0)
				GivePlayerWantedLevel(playerid, 4, 4, "ношение запрещенных предметов");	
		}
	}
	return true;
}