#if defined _inventory_included
	#endinput
#endif

#define _inventory_included

#include "../sources/inventory/model"
#include "../sources/inventory/acsr"
#include "../sources/inventory/weapon"
#include "../sources/inventory/interface"
#include "../sources/inventory/dialogs"
#include "../sources/inventory/things"
#include "../sources/inventory/throw"
#include "../sources/inventory/in_hands"
#include "../sources/inventory/trashcan"

//////////	Callbacks	//////////
Public: Inv.OnGameModeInit()
{
	#if defined _inventory_throw_included
		Inv.LoadThrowThings();
	#endif

	#if defined _inventory_trashcan_included
		Inv.LoadTrashcan();
	#endif

	return CONTINUE;
}

//////////	Functions 	//////////
stock ShowPlayerInventory(playerid, E_INV_TABS:startTab = TAB_INVENTORY)
{
	new nearVehicle = GetNearVehicles(playerid);
	if(nearVehicle && GetVehicleBoot(nearVehicle) && CarInfo[nearVehicle][cID]) {
		//	перекладываем в багажник
	} else {
		if(Inv.GetPlayerThingIDInHand(playerid)) {
			Inv.ThrowThingOutHand(playerid);
			return false;
		}
	}

	new bool:tabSelected;

	//	Show base inventory text draws
	IFace.ToggleGroup(playerid, IFace.INVENTORY, true);

	//	Set params
	Streamer_ToggleAllItems(playerid, STREAMER_TYPE_3D_TEXT_LABEL, false);
	//Streamer_ToggleItemUpdate(playerid, STREAMER_TYPE_3D_TEXT_LABEL, false);
	//SelectTextDraw(playerid, INTERFACE_SELECT_COLOR);
	FadeColorForPlayer(playerid, 0, 0, 0, 0, 24, 27, 32, 55, 10);

	//	Add tabs
		//	Inventory
	IFace.Inv_AddTab(playerid, "INV", TAB_INVENTORY, PlayerInfo[playerid][pUserID], 12);
		//	Vehicle trunk
	if(nearVehicle && GetVehicleBoot(nearVehicle) && CarInfo[nearVehicle][cID])
	{
		new trunkTabNum = IFace.Inv_AddTab(playerid, "VEHICLE", TAB_VEHICLE_TRUNK, CarInfo[nearVehicle][cID], 6);
		if(startTab == TAB_VEHICLE_TRUNK)	IFace.Inv_SelectTab(playerid, trunkTabNum),		tabSelected = true;
	}
		//	Thing in hand
	/*#if defined _inventory_in_hands_included
		new thingInHand = Inv.GetPlayerThingIDInHand(playerid);
		if(thingInHand)
		{
			new boxTabNum = IFace.Inv_AddTab(playerid, "BOX", TYPE_INSIDE, thingInHand, 6);
			if(startTab == TYPE_INSIDE)			IFace.Inv_SelectTab(playerid, boxTabNum),		tabSelected = true;
		}
	#endif*/	

		//	Trashcan
	#if defined _inventory_trashcan_included	
		new trashcanType;
		new nearTrashcan = Inv.GetPlayerNearTrashcan(playerid, trashcanType);
		if(nearTrashcan != INVALID_DATA)
		{
			new trashcanTabNum = IFace.Inv_AddTab(playerid, "TRASHCAN", TYPE_TRASHCAN, nearTrashcan, Inv.GetTrashcanSlotCount(trashcanType));
			if(startTab == TYPE_TRASHCAN)		IFace.Inv_SelectTab(playerid, trashcanTabNum),	tabSelected = true;
		}
	#endif	

	//	Update the selected tab
	if(!tabSelected)	IFace.Inv_SelectTab(playerid, 0);

	//	Update acsr slots
	new model, thing;
	for(new i = 0; i < 4; i++)
	{
		model = Acsr.GetPlayerAcsrObject(playerid, i);
		thing = Acsr.GetObjectThing(model);
		if(i >= 2 && !PlayerInfo[playerid][pVip])
		{
			IFace.Inv_SetItem(playerid, i, (model == INVALID_DATA) ? 0 : model, 0, -1,	true, Arr4<thingData[thing][T_VISUAL_POS]>);
		}
		else 		
		{
			IFace.Inv_SetItem(playerid, i, (model == INVALID_DATA) ? 0 : model, 0, 0,	true, Arr4<thingData[thing][T_VISUAL_POS]>);
		}
	}
	return true;
}

stock HidePlayerInventory(playerid)
{
	if(IFace.GetGroupToggle(playerid, IFace.INVENTORY))
	{
		IFace.ToggleGroup(playerid, IFace.INVENTORY, false);
		Streamer_ToggleAllItems(playerid, STREAMER_TYPE_3D_TEXT_LABEL, true);
		//Streamer_ToggleItemUpdate(playerid, STREAMER_TYPE_3D_TEXT_LABEL, true);
		//CancelSelectTextDraw(playerid);
		FadeColorForPlayer(playerid, 24, 27, 32, 55, 0, 0, 0, 0, 10);
	}
	return true;
}

stock Inv.ClickSkin(playerid)
{
	callcmd::menu(playerid, "");
	return true;
}

stock Inv.UpdateVisualItem(playerid, item)
{
	new tabNum = GetPVarInt(playerid, "Inv:IFace:SelectedTab");
	new E_INV_TABS:selectedTab 	= IFace.Inv_GetTabType(playerid, tabNum),
		sourceID 				= IFace.Inv_GetTabSourceID(playerid, tabNum);

	new string[128];
	mysql_format(g_SQL, string, sizeof(string), 
		"SELECT `thing`, `option`, `count`, `used` \
			FROM `inventory` \
			WHERE `source` = '%d' AND `source_type` = '%d' AND `slot` = '%d'", sourceID, _:selectedTab, item);
	new Cache:result = mysql_query(g_SQL, string);
	new thing, option, count, used;
	for(new i = 0; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i, "thing",	thing);
		cache_get_value_name_int(i, "option",	option);
		cache_get_value_name_int(i, "count",	count);
		cache_get_value_name_int(i, "used",		used);
		cache_delete(result);
	
		if(GetThingType(thing) == TH_TYPE_ACSR && used)	continue;
		if(GetThingType(thing) == TH_TYPE_IN_HAND)
		{
			count = 1;
		}
		IFace.Inv_SetItem(playerid, item, GetThingVisualObject(thing, option), count, used, false, Arr4<thingData[thing][T_VISUAL_POS]>);
		return true;
	}
	IFace.Inv_ClearItem(playerid, item);
	return false;
}

stock Inv.SelectTab(playerid, tabNum = 0)
{
	new string[128];
	IFace.Inv_ClearItems(playerid);
	Inv.SavePlayerWeapon(playerid);

	new sourceID = IFace.Inv_GetTabSourceID(playerid, tabNum);
	new E_INV_TABS:selectedTab = IFace.Inv_GetTabType(playerid, tabNum);
	mysql_format(g_SQL, string, sizeof(string), "SELECT `slot`, `thing`, `option`, `count`, `used` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d'", sourceID, _:selectedTab);
	mysql_tquery(g_SQL, string, "Inv_LoadTabData", "dd", playerid, tabNum);
	

	IFace.Inv_UpdateTab(playerid, tabNum, true);
	if(GetPVarType(playerid, "Inv:IFace:SelectedItem") != PLAYER_VARTYPE_NONE)
	{
		new selectedItemTab = GetPVarInt(playerid, "Inv:IFace:SelectedItemTab");
		if(selectedItemTab != ACSR_TAB_NUM)
		{
			if(selectedItemTab == tabNum)
			{
				IFace.Inv_ShowButtons(playerid);
				new selectedItem = GetPVarInt(playerid, "Inv:IFace:SelectedItem");
				DeletePVar(playerid, "Inv:IFace:SelectedItem");
				Inv.SelectItem(playerid, selectedItem);
			}
			else
			{
				IFace.Inv_HideButtons(playerid);
			}
		}
	}
	return true;
}

Public: Inv.LoadTabData(playerid, tabNum)
{
	if(GetPVarInt(playerid, "Inv:IFace:SelectedTab") != tabNum)
	{
		return false;
	}
	new slot, thing, option, count, used;
	//	Обновляем слоты предметов
	for(new i = 0; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i, "slot",		slot);
		cache_get_value_name_int(i, "thing",	thing);
		cache_get_value_name_int(i, "option",	option);
		cache_get_value_name_int(i, "count",	count);
		cache_get_value_name_int(i, "used",		used);

		if(GetThingType(thing) == TH_TYPE_ACSR && used)
		{
			continue;
		}
		if(GetThingType(thing) == TH_TYPE_IN_HAND)
		{
			count = 1;
		}
		IFace.Inv_SetItem(playerid, slot, GetThingVisualObject(thing, option), count, used, false, Arr4<thingData[thing][T_VISUAL_POS]>);
	}
	return true;
}

//	Call when player click any item in inventory
stock Inv.ClickItem(playerid, item, leftWindow = false)
{
	new tabNum 					= leftWindow ? ACSR_TAB_NUM : GetPVarInt(playerid, "Inv:IFace:SelectedTab");
	//new E_INV_TABS:selectedTab	= IFace.Inv_GetTabType(playerid, tabNum);
	new model					= IFace.Inv_GetItemModel(playerid, item, leftWindow);
	new selectedItemTab 		= GetPVarInt(playerid, "Inv:IFace:SelectedItemTab");
	new selectedItem 			= GetPVarInt(playerid, "Inv:IFace:SelectedItem");
		
	if(GetPVarType(playerid, "Inv:IFace:SelectedItem") == PLAYER_VARTYPE_NONE)
	{
		if(model)
		{
			Inv.SelectItem(playerid, item, leftWindow);
		}
	}
	else
	{
		if(model == 0)
		{
			if(IFace.Inv_isActionButtonsToggle(playerid))
			{
				IFace.Inv_ClearSelectItem(playerid);		//	Cancel select object
			}
			else
			{
				Inv.ShiftThing(playerid, selectedItemTab, selectedItem, tabNum, item);		//	Shift selected item in another slot
			}
		}
		else
		{
			Inv.SelectItem(playerid, item, leftWindow);
		}
	}
	return true;
}

stock Inv.SelectItem(playerid, item, leftWindow = false)
{
	if(leftWindow)
	{
		//	Reclick
		if(GetPVarType(playerid, "Inv:IFace:SelectedItem") != PLAYER_VARTYPE_NONE && GetPVarInt(playerid, "Inv:IFace:SelectedItem") == item)
		{
			//	If action buttons is activated
			if(IFace.Inv_isActionButtonsToggle(playerid))
			{
				IFace.Inv_ClearSelectItem(playerid);		//	Cancel select object
			}
			//	If not
			else
			{
				//	Create action buttons
				IFace.Inv_CreateButton(playerid, item, "EDIT", ACT_SETTING, leftWindow);
			}
		}
		//	Click
		else
		{
			IFace.Inv_ClearSelectItem(playerid);		//	Cancel select object
			//	If action buttons is activated
			if(!IFace.Inv_isActionButtonsToggle(playerid))
			{
				IFace.Inv_SelectItem(playerid, item, leftWindow);		//	Select item
			}
		}
	}
	else
	{
		new tabNum 					= GetPVarInt(playerid, "Inv:IFace:SelectedTab");
		new E_INV_TABS:selectedTab	= IFace.Inv_GetTabType(playerid, tabNum);
		new source 					= IFace.Inv_GetTabSourceID(playerid, tabNum);

		new string[128];
		mysql_format(g_SQL, string, sizeof(string), "SELECT `thing`, `option`, `count` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `slot` = '%d' LIMIT 1", source, _:selectedTab, item);
		new Cache:result = mysql_query(g_SQL, string);
		new thing, option, count;
		cache_get_value_name_int(0, "thing", thing);
		cache_get_value_name_int(0, "option", option);
		cache_get_value_name_int(0, "count", count);
		cache_delete(result);

		if(GetPVarType(playerid, "Inv:IFace:SelectedItem") != PLAYER_VARTYPE_NONE)
		{	
			//	Reclick
			if(GetPVarInt(playerid, "Inv:IFace:SelectedItem") == item 
			&& GetPVarInt(playerid, "Inv:IFace:SelectedItemTab") == GetPVarInt(playerid, "Inv:IFace:SelectedTab"))
			{
				//	If action buttons is activated
				if(IFace.Inv_isActionButtonsToggle(playerid))
				{
					IFace.Inv_ClearSelectItem(playerid);		//	Cancel select object
				}
				//	If not
				else
				{
					//	Create action buttons
					new E_INV_TABS:type = IFace.Inv_GetTabType(playerid, GetPVarInt(playerid, "Inv:IFace:SelectedItemTab"));
					if(type == TAB_INVENTORY) {
						IFace.Inv_CreateButton(playerid, item, "USE", ACT_USE);
						IFace.Inv_CreateButton(playerid, item, "GIVE", ACT_GIVE);
					} 
					else if(GetThingType(thing) == TH_TYPE_IN_HAND) {
						IFace.Inv_CreateButton(playerid, item, "USE", ACT_USE);
					}
					IFace.Inv_CreateButton(playerid, item, "DROP", ACT_DROP);
					IFace.Inv_CreateButton(playerid, item, "SPLIT", ACT_SPLIT);
					if(!isRus(playerid))
					{
						IFace.Inv_CreateButton(playerid, item, "INFO", ACT_INFO);
					}
				}
				return true;
			}
			//	Click item when another item selected
			else
			{
				if(Inv.UniteThings(playerid, item))
				{
					return true;
				}
				else
				{
					IFace.Inv_ClearSelectItem(playerid);		//	Cancel select object
				}
			}
		}

		//	If action buttons is activated
		if(IFace.Inv_isActionButtonsToggle(playerid))
		{
			IFace.Inv_ClearSelectItem(playerid);		//	Cancel select object
		}
		IFace.Inv_SelectItem(playerid, item);		//	Select item

		format(string, sizeof(string), "%s~n~Количество: %d", GetThingDescrip(thing), count);
		IFace.Inv_ShowSelectedItem(playerid, GetThingName(thing, option), string, GetThingVisualObject(thing, option), Arr4<thingData[thing][T_VISUAL_POS]>);
	}
	return true;
}

stock Inv.UniteThings(playerid, item)
{
	new destTabNum 				= GetPVarInt(playerid, "Inv:IFace:SelectedTab"),
		E_INV_TABS:destTab		= IFace.Inv_GetTabType(playerid, destTabNum),
		destID 					= IFace.Inv_GetTabSourceID(playerid, destTabNum);

	new sourceTabNum 			= GetPVarInt(playerid, "Inv:IFace:SelectedItemTab"),
		E_INV_TABS:sourceTab 	= sourceTabNum == ACSR_TAB_NUM ? TAB_ACSR : IFace.Inv_GetTabType(playerid, sourceTabNum),
		sourceID 				= sourceTabNum == ACSR_TAB_NUM ? PlayerInfo[playerid][pUserID] : IFace.Inv_GetTabSourceID(playerid, sourceTabNum),
		sourceItem 				= GetPVarInt(playerid, "Inv:IFace:SelectedItem");

	new string[128];
	mysql_format(g_SQL, string, sizeof(string), "SELECT `thing`, `option`, `count` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `slot` = '%d' LIMIT 1", destID, _:destTab, item);
	new Cache:result = mysql_query(g_SQL, string);
	new destThing, destOption, destCount;
	cache_get_value_name_int(0, "thing", 	destThing);
	cache_get_value_name_int(0, "option", 	destOption);
	cache_get_value_name_int(0, "count", 	destCount);
	cache_delete(result);

	mysql_format(g_SQL, string, sizeof(string), "SELECT `thing`, `option`, `count` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `slot` = '%d' LIMIT 1", sourceID, _:sourceTab, sourceItem);
	result = mysql_query(g_SQL, string);
	new sourceThing, sourceOption, sourceCount;
	cache_get_value_name_int(0, "thing", 	sourceThing);
	cache_get_value_name_int(0, "option", 	sourceOption);
	cache_get_value_name_int(0, "count", 	sourceCount);
	cache_delete(result);

	if(destThing == sourceThing && destOption == sourceOption)
	{
		new maxStack = GetThingMaxStack(sourceThing);
		if(destCount >= maxStack)
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этот слот полностью заполнен.");
			return true;
		}

		new diff = maxStack - destCount;
		if(sourceCount > diff)
		{
			destCount 	+= diff;
			sourceCount -= diff;
		}
		else
		{
			destCount 	+= sourceCount;
			sourceCount = 0;
		}

		//	Update dest slot
		mysql_format(g_SQL, string, sizeof(string), "UPDATE `inventory` SET `count` = '%d' WHERE `source` = '%d' AND `source_type` = '%d' AND `slot` = '%d'", destCount, destID, _:destTab, item);
		mysql_query_ex(string);

		//	Update source slot
		if(sourceCount > 0)
		{
			mysql_format(g_SQL, string, sizeof(string), "UPDATE `inventory` SET `count` = '%d' WHERE `source` = '%d' AND `source_type` = '%d' AND `slot` = '%d'", sourceCount, sourceID, _:sourceTab, sourceItem);
		}
		else
		{
			mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `slot` = '%d'", sourceID, _:sourceTab, sourceItem);
		}
		mysql_query_ex(string);

		IFace.Inv_ClearSelectItem(playerid);		//	Cancel select object
		//IFace.Inv_UpdateListItems(playerid);

		/*if(sourceTab == TAB_IN_HAND)
		{
			//	Увеличиваем значение вложенных вещей на единицу
			format(string, sizeof(string), "UPDATE `inventory` SET `count` = `count` - 1 WHERE `id` = '%d'", sourceID);	
			mysql_query_ex(string);
		}*/

		Inv.UpdateVisualItem(playerid, item);
		if(destTabNum == sourceTabNum)
		{
			Inv.UpdateVisualItem(playerid, sourceItem);
		}
		return true;
	}
	return false;
}

//	This function call when item shifting from sourceSlot (sourceTabNum) in destSlot (destTabNum)
//	Exception:	sourceTabNum = ACSR_TAB_NUM -- sourceSlot is on acsr tab
stock Inv.ShiftThing(playerid, sourceTabNum, sourceSlot, destTabNum, destSlot)
{
	new E_INV_TABS:sourceTab,
		sourceID;
	if(sourceTabNum == ACSR_TAB_NUM)
	{
		sourceTab 	= TAB_ACSR;
		sourceID	= PlayerInfo[playerid][pUserID];
	}
	else
	{
		sourceTab 	= IFace.Inv_GetTabType(playerid, sourceTabNum);
		sourceID	= IFace.Inv_GetTabSourceID(playerid, sourceTabNum);
	}
	
	if(destTabNum == ACSR_TAB_NUM)
	{
		//	Слоты только для VIP-аккаунта
		if(destSlot >= 2 && !PlayerInfo[playerid][pVip])
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Эти слоты доступны только с Премиум аккаунтом.");
			return false;
		}

		if(sourceTab == TAB_ACSR)
		{
			if(Acsr.ShiftAcsr(playerid, sourceSlot, destSlot))
			{
				new model = Acsr.GetPlayerAcsrObject(playerid, sourceSlot);
				new thing = Acsr.GetObjectThing(model);
				IFace.Inv_SetItem(playerid, sourceSlot, (model == INVALID_DATA) ? 0 : model, 0, 0, true, Arr4<thingData[thing][T_VISUAL_POS]>);

				model = Acsr.GetPlayerAcsrObject(playerid, destSlot);
				thing = Acsr.GetObjectThing(model);
				IFace.Inv_SetItem(playerid, destSlot, (model == INVALID_DATA) ? 0 : model, 0, 0, true, Arr4<thingData[thing][T_VISUAL_POS]>);

				IFace.Inv_ClearSelectItem(playerid);
			}
		}
		else
		{
			new string[256];
			mysql_format(g_SQL, string, sizeof(string), "SELECT `id`, `thing` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `slot` = '%d'", sourceID, _:sourceTab, sourceSlot);
			new Cache:result = mysql_query(g_SQL, string);
			if(cache_num_rows())
			{
				new id, thing;
				cache_get_value_name_int(0, "id", 		id);
				cache_get_value_name_int(0, "thing", 	thing);

		    	if(GetThingType(thing) == TH_TYPE_ACSR)
		    	{
					if(Inv.WearAcsr(playerid, id, destSlot))
					{
						IFace.Inv_ClearSelectItem(playerid);
						//IFace.Inv_UpdateListItems(playerid);
						Inv.UpdateVisualItem(playerid, sourceSlot);
					}
		    	}
		    	else
		    	{
		    		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Эти слоты предназначены для аксессуаров.");
		    	}
			}
			cache_delete(result);
		}
		
	}
	else
	{
		new E_INV_TABS:destTab 	= IFace.Inv_GetTabType(playerid, destTabNum),
			destID 				= IFace.Inv_GetTabSourceID(playerid, destTabNum);

		if(destSlot >= IFace.Inv_GetTabMaxSlots(playerid, destTabNum))
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете положить предмет в этот слот.");
			return false;
		}

		new string[192];
		format(string, sizeof(string), "SELECT COUNT(*) AS `count` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `slot` = '%d'", destID, _:destTab, destSlot);
		new Cache:result = mysql_query(g_SQL, string);
		new _cnt;
		cache_get_value_name_int(0, "count", _cnt);
		cache_delete(result);
		if(_cnt)
		{
			return false;
		}

		format(string, sizeof(string), "SELECT `id`, `thing`, `option`, `count`, `used` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `slot` = '%d'", sourceID, _:sourceTab, sourceSlot);
		result = mysql_query(g_SQL, string);
		if(!cache_num_rows())
		{
			return false;
		}
		new id, sourceThing, option, count, used;
		cache_get_value_name_int(0, "id", 		id);
		cache_get_value_name_int(0, "thing", 	sourceThing);
		cache_get_value_name_int(0, "option",	option);
		cache_get_value_name_int(0, "count", 	count);
		cache_get_value_name_int(0, "used", 	used);
		cache_delete(result);

		if(sourceTabNum != destTabNum)
		{
			if(used)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете переложить используемые вещи.");
				return false;
			}
		}
		if(destTab == TAB_INVENTORY) {
			if(GetThingType(sourceThing) == TH_TYPE_IN_HAND) {
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете переложить эту вещь сюда.");
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_HINT "Используйте USE чтобы взять в руки.");
				return false;
			}
		}
		/*if(destTab == TYPE_INSIDE)//TAB_IN_HAND)
		{
			if(GetThingType(sourceThing) == TH_TYPE_IN_HAND)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете переложить эту вещь сюда.");
				return false;
			}
			
			//	Увеличиваем значение вложенных вещей на единицу
			//format(string, sizeof(string), "UPDATE `inventory` SET `count` = `count` + 1 WHERE `id` = '%d'", destID);	
			//mysql_query_ex(string);
		}*/
		/*if(sourceTab == TAB_IN_HAND)
		{
			//	Уменьшаем значение вложенных вещей на единицу
			format(string, sizeof(string), "UPDATE `inventory` SET `count` = `count` - 1 WHERE `id` = '%d'", sourceID);	
			mysql_query_ex(string);
		}*/

		format(string, sizeof(string), "UPDATE `inventory` SET `source` = '%d', `source_type` = '%d', `slot` = '%d' WHERE `id` = '%d'", destID, _:destTab, destSlot, id);	
		mysql_query_ex(string);

		if(sourceTab == TAB_ACSR)
		{
			Acsr.RemovePlayerAcsr(playerid, sourceSlot);
			IFace.Inv_SetItem(playerid, sourceSlot, 0, 0, 0, true);	
		}
		else
		{
			//	Update interface
			if(sourceTabNum == destTabNum)
			{
				IFace.Inv_SetItem(playerid, sourceSlot, 0);
			}
		}

		if(GetThingType(sourceThing) == TH_TYPE_IN_HAND)
		{
			count = 1;
		}
		IFace.Inv_SetItem(playerid, destSlot, GetThingVisualObject(sourceThing, option), count, used, false, Arr4<thingData[sourceThing][T_VISUAL_POS]>);
		IFace.Inv_ClearSelectItem(playerid);

		if(sourceTab == TAB_VEHICLE_TRUNK || destTab == TAB_VEHICLE_TRUNK)
		{
			if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
			{
				MyApplyAnimation(playerid, "GANGS","shake_cara", 4.1, 0, 0, 0, 0, 0, 1);
				SetPlayerTimerEx(playerid, "Inv_SetPlayerAnim", 1700, false, "d", playerid);
			}
		}

		if(sourceTabNum != destTabNum)
		{
			new tabName[24];
			strput(tabName, tabNames[destTab]);
			string_tolow(tabName);
			ChangeStringCase(tabName, 3);
			format(string, sizeof string, "перекладывает %s в %s.", GetThingName(sourceThing, option, true), tabName);
			PlayerAction(playerid, string);
		}
	}
	return true;
}

stock Inv.ActionItem(playerid, item, action)
{	
	IFace.Inv_ClearSelectItem(playerid);		//	Cancel select object

	if(PlayerInfo[playerid][pJailTime])
	{
		return false;
	}

	new tabNum 					= GetPVarInt(playerid, "Inv:IFace:SelectedTab"),
		E_INV_TABS:selectedTab 	= IFace.Inv_GetTabType(playerid, tabNum),
		sourceID 				= IFace.Inv_GetTabSourceID(playerid, tabNum);

	new string[256];
	mysql_format(g_SQL, string, sizeof(string), "SELECT `id`, `thing`, `option`, `used`, `count` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `slot` = '%d'", sourceID, _:selectedTab, item);
	new Cache:result = mysql_query(g_SQL, string);
	if(!cache_num_rows())
	{
		cache_delete(result);
		return false;
	}

	new id, thing, option, used, count;
	cache_get_value_name_int(0, "id",			id);
	cache_get_value_name_int(0, "thing",		thing);
	cache_get_value_name_int(0, "option",		option);
	cache_get_value_name_int(0, "used",			used);
	cache_get_value_name_int(0, "count",		count);
	cache_delete(result);

	new type = GetThingType(thing);
	SetPVarInt(playerid, "Inv:Thing:Type",		type);
	SetPVarInt(playerid, "Inv:Thing:ID",		id);
	SetPVarInt(playerid, "Inv:Thing:Thing",		thing);
	SetPVarInt(playerid, "Inv:Thing:Option",	option);
	SetPVarInt(playerid, "Inv:Thing:Used",		used);
	SetPVarInt(playerid, "Inv:Thing:Count",		count);
	SetPVarInt(playerid, "Inv:Thing:Slot",		item);

	switch(action)
	{
		case ACT_USE:
		{
			PlayerUseItem(playerid, id);
		}
		case ACT_GIVE:
		{
			if(used)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете передать используемые вещи.");
				return false;
			}
			Dialog_Show(playerid, gTargetid[playerid] == INVALID_PLAYER_ID ? (Dialog:Inv.InputPlayer) : (Dialog:Inv.GiveThing));
		}
		case ACT_DROP:
		{
			if(used)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете выкинуть используемые вещи.");
				return false;
			}
			Dialog_Show(playerid, Dialog:Inv.Drop);
		}
		case ACT_SPLIT:
		{
			if(used)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете разделить используемые вещи.");
				return false;
			}
			if(!Inv.SplitItem(id))
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете разделить эту вещь.");
				return false;
			}

			//if(selectedTab == TAB_IN_HAND)
			//{
				//	Увеличиваем значение вложенных вещей на единицу
			//	format(string, sizeof(string), "UPDATE `inventory` SET `count` = `count` + 1 WHERE `id` = '%d'", sourceID);	
			//	mysql_query_ex(string);
			//}

			IFace.Inv_UpdateListItems(playerid);		
		}
		case ACT_INFO:
		{
			Dialog_Message(playerid, "Информация о предмете", GetThingDescrip(thing), "Закрыть");
		}
		case ACT_SETTING:
		{
			HidePlayerInventory(playerid);
			Acsr.StartEdit(playerid, item);
		}
	}
	return true;
}

stock Inv.WearAcsr(playerid, thingid, slot)
{
	new string[256];
	format(string, sizeof(string), "SELECT * FROM `inventory` WHERE `id` = '%d'", thingid);
	new Cache:result = mysql_query(g_SQL, string);
	if(!cache_num_rows())
	{ 
		cache_delete(result);
		return false;
	}
	
	new source_type;
	cache_get_value_name_int(0, "source_type", source_type);
	if(source_type == _:TAB_ACSR)
	{
		cache_delete(result);
		return false;
	}

	new thing, option, count, used, Float:attach[6];
	cache_get_value_name_int(0, "thing", thing);
	cache_get_value_name_int(0, "option", option);
	cache_get_value_name_int(0, "count", count);
	cache_get_value_name_int(0, "used", used);
	cache_get_value_name_float(0, "attach_x", attach[0]);
	cache_get_value_name_float(0, "attach_y", attach[1]);
	cache_get_value_name_float(0, "attach_z", attach[2]);
	cache_get_value_name_float(0, "attach_rx", attach[3]);
	cache_get_value_name_float(0, "attach_ry", attach[4]);
	cache_get_value_name_float(0, "attach_rz", attach[5]);
	cache_delete(result);

	new type;
	new object = Acsr.GetAcsrObject(thing, option);		//	Find game object for attach
	if(!attach[0] && !attach[1] && !attach[2])
	{
		type = Acsr.GetAttachPosition(thing, Arr6<attach>);	//	Find about position for attach to current skin
		//	Save position in database
		mysql_format(g_SQL, string, sizeof(string), 
			"UPDATE `inventory`\
				SET `attach_x` = '%f', `attach_y` = '%f', `attach_z` = '%f',\
					`attach_rx` = '%f', `attach_ry` = '%f', `attach_rz` = '%f'\
				WHERE `id` = '%d'", Arr6<attach>, thingid);
		mysql_query_ex(string);
	}
	else
	{
		type = Acsr.GetAttachType(thing);
	}
	mysql_query_ex(string);
	
	switch(Acsr.SetPlayerAcsr(playerid, slot, thingid, type, object, true, 2, Arr6<attach>))	//	Attach object with animantion
	{
		case true:
		{
			mysql_format(g_SQL, string, sizeof(string), "UPDATE `inventory` SET `source` = '%d', `source_type` = '%d', `slot` = '%d' WHERE `id` = '%d'", PlayerInfo[playerid][pUserID], _:TAB_ACSR, slot, thingid);
			mysql_query_ex(string);

			//	Update IFace
			new model = Acsr.GetPlayerAcsrObject(playerid, slot);
			IFace.Inv_SetItem(playerid, slot, (model == INVALID_DATA) ? 0 : model, 0, 0, true, Arr4<thingData[thing][T_VISUAL_POS]>);
			return true;
		}
		case ERROR_TYPE_ALREADY_USE:
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Аксессуар этого типа уже одет на вас.");
		}
		case ERROR_INVALID_SLOT:
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Не удалось одеть аксессуар, так как указан неверный слот.");
		}
		case ERROR_ALREADY_PUTS:
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы уже одеваете какой-то аксессуар.");
		}
	}
	return false;
}

stock Inv.GetPlayerUsingItem(playerid)
{
	new stmp[128];
	//	Загрузка используемого оружия
	mysql_format(g_SQL, stmp, sizeof(stmp), "SELECT `id`, `thing`, `option`, `count` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `used` = '1'", PlayerInfo[playerid][pUserID], _:TAB_INVENTORY);
	new Cache:result = mysql_query(g_SQL, stmp);
	for(new i = 0, thingid, thing, option, count; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i, "id",		thingid);
		cache_get_value_name_int(i, "thing",	thing);
		switch(GetThingType(thing))
		{
			case TH_TYPE_WEAPON:
			{
				cache_get_value_name_int(i, "option",	option);
				cache_get_value_name_int(i, "count",	count);
				if(!UseItem_Weapon(playerid, thingid, option, count))
				{
					Inv.SetItemFlag(thingid, false);
				}
			}
		}
	}
	cache_delete(result);

	#if defined _inventory_in_hands_included
		Inv.LoadPlayrerThingInHand(playerid);
	#endif

	#if defined _inventory_acsr_included
		Acsr.LoadPlayerAcsr(playerid);
	#endif

	return true;
}

Public: PlayerUseThing(playerid, thing)
{
	new thingid = ItemStockPlayer(playerid, thing);
	if(thingid == 0)	return false;

	return PlayerUseItem(playerid, thingid);
}

Public: PlayerUseItem(playerid, thingid)
{
	new stmp[128];
	format(stmp, sizeof(stmp), "SELECT `thing`, `option`, `count`, `used`, `slot` FROM `inventory` WHERE `id` = '%d'", thingid);
	new Cache:result = mysql_query(g_SQL, stmp);
	if(!cache_num_rows())	return cache_delete(result);
	
	new thing, option, count, used, slot;
	cache_get_value_name_int(0, "thing",	thing);
	cache_get_value_name_int(0, "option",	option);
	cache_get_value_name_int(0, "count",	count);
	cache_get_value_name_int(0, "used",		used);
	cache_get_value_name_int(0, "slot",		slot);
	cache_delete(result);

	//	Test
	if(GetThingType(thing) == TH_TYPE_IN_HAND) {
		Inv.GiveThingInHand(playerid, thingid);
		return true;
	}

	new func[32];
	strput(func, GetThingFunc(thing));
	if(strlen(func) > 0)
	{
		format(stmp, sizeof stmp, "UseItem_%s", func);
		if(CallLocalFunction(stmp, "iiii", playerid, thingid, option, count) == 0)
		{
			return false;
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
		Inv.DeleteItem(thingid);	
	}

	if(GetThingLegally(thing) == 0)	
	{
		foreach(Cop, c)
		{
			if(GetDistanceBetweenPlayers(playerid, c) < 30.0)
				return GivePlayerWantedLevel(playerid, 4, 4, "ношение запрещенных предметов");	
		}
	}

	//IFace.Inv_UpdateListItems(playerid);
	Inv.UpdateVisualItem(playerid, slot);
	return true;
}

//////////	Commands	//////////
COMMAND:i(playerid, params[])
{
	return ShowPlayerInventory(playerid);
}

flags:givething(CMD_DEVELOPER);
CMD:givething(playerid, params[]) 
{
	new targetid, amount;
	if (sscanf(params, "rD(-1)", targetid, amount)) return SendClientMessage(playerid, -1, "Использование: /givething [id игрока] [количество]");
	if (!IsPlayerLogged(targetid)) return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого игрока нет на сервере.");
	
	if (amount == -1) amount = 1;
	
	new string[1024] = "Предмет\n";
	for (new i = 1; i < sizeof thingData; i++)
	{
		format(string, sizeof string, "%s%s\n", string, thingData[i][T_TITLE]);
	}
	Dialog_Open(playerid, Dialog:GiveThing, DIALOG_STYLE_TABLIST_HEADERS, "Шмотки", string, "Выдать", "Закрыть");
	SetPVarInt(playerid, "sdfsdfsdffd", targetid);
	SetPVarInt(playerid, "sdfsdfsdffd2", amount);	
	return 1;
}