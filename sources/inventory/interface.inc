#if defined _inventory_interface_included
	#endinput
#endif

#define _inventory_interface_included

#define INV_RIGHT_BASE_POS_X				509.5
#define INV_RIGHT_BASE_POS_Y				160.0

#define INV_LEFT_BASE_POS_X					100.0
#define INV_LEFT_BASE_POS_Y					160.0

#define INV_PREVIEW_POS_X 					100.0
#define INV_PREVIEW_POS_Y					275.0

#define INV_BACKGROUND_COLOR 				0x181B2055
#define INV_WINDOW_COLOR					INTERFACE_MAIN_COLOR
#define INV_BUTTON_COLOR					INTERFACE_BUTTON_COLOR
#define INV_BUTTON_TEXT_BACKGROUND_COLOR	0x751C1AFF
#define INV_USED_ITEM_BACKGROUND_COLOR		0x2E3035FF
#define INV_ITEM_BACKGROUND_COLOR			0x212429FF
#define INV_ITEM_SELECTED_BACKGROUND_COLOR	0x4E5561FF

#define MAX_TABS 							4
#define MAX_ACTION_BUTTONS					5
#define MAX_INV_SLOTS						36

enum IFace.E_INV_TD
{
	Text:inv_Td_Background,
	Text:inv_Td_Window[2],
	Text:selectedWindow,
}

enum IFace.E_INV_PTD
{
	PlayerText:inv_PTd_Title,
	PlayerText:inv_PTd_Items[MAX_INV_SLOTS],
	PlayerText:itemsCount[MAX_INV_SLOTS],
	PlayerText:inv_PTd_Skin,

	PlayerText:SelectedItemTitle,
	PlayerText:SelectedItem,
	PlayerText:SelectedItemInfo,
}

//	Text-Draws
static IFace.Inv_TD[IFace.E_INV_TD];

//	Player Text-Draws
static 
	PlayerText:IFace.Inv_tabs[MAX_PLAYERS][MAX_TABS],
	PlayerText:IFace.Inv_buttonsAction[MAX_PLAYERS][MAX_ACTION_BUTTONS],
	PlayerText:IFace.Inv_AcsrSlots[4],
	PlayerText:IFace.Inv_InHandSlot;
static IFace.Inv_PTD[IFace.E_INV_PTD];

static 
	Inventory_Models[MAX_PLAYERS][MAX_INV_SLOTS],
	bool:Inventory_SlotUsed[MAX_PLAYERS][MAX_INV_SLOTS];

//	Tabs
enum E_TAB_INFO
{
	ti_Title[12],
	E_INV_TABS:ti_tabType,
	ti_sourceID,
	ti_maxSlots,
}
static	Tabs[MAX_PLAYERS][4][E_TAB_INFO],
		TabsCount[MAX_PLAYERS];

//	Buttons
static 	buttonsCount[MAX_PLAYERS],
		buttonAction[MAX_PLAYERS][MAX_ACTION_BUTTONS];

//	Acsr
static acsrModels[MAX_PLAYERS][4];

//////////////////////////////////////////////////////

Public: IFace.Inv_OnPlayerClickTD(playerid, Text:clickedid)
{
	if(IFace.GetGroupToggle(playerid, IFace.INVENTORY))
	{
		if(clickedid == Text:INVALID_TEXT_DRAW)
		{
			HidePlayerInventory(playerid);
			return true;
		}
	}
	return CONTINUE;
}

Public: IFace.Inv_OnPlayerClickPTD(playerid, PlayerText:playertextid)
{
	if(IFace.GetGroupToggle(playerid, IFace.INVENTORY))
	{
		if(playertextid == IFace.Inv_PTD[inv_PTd_Skin])
		{
			Inv.ClickSkin(playerid);
			return true;
		}

	    for(new i = 0; i < TabsCount[playerid]; i++)
	    {
	    	if(playertextid == IFace.Inv_tabs[playerid][i])
	    	{
	    		//IFace.Inv_UpdateTab(playerid, GetPVarInt(playerid, "Inv:IFace:SelectedTab"), false);

	    		//SetPVarInt(playerid, "Inv:IFace:SelectedTab", i);
	    		//IFace.Inv_ClearItems(playerid);
	    		//return Inv.SelectTab(playerid, i);
	    		return IFace.Inv_SelectTab(playerid, i);
	    	}
	    }

	    for(new i = 0; i < 4; i++)
	    {
	    	if(playertextid == IFace.Inv_buttonsAction[playerid][i])
	    	{
	    		return Inv.ActionItem(playerid, GetPVarInt(playerid, "Inv:IFace:SelectedItem"), buttonAction[playerid][i]);
	    	}
	    }

	    for(new item = 0; item < 4; item++)
	    {
	    	if(playertextid == IFace.Inv_AcsrSlots[item])
			{
				return Inv.ClickItem(playerid, item, true);
			}
	    }

		for(new item = 0; item < sizeof IFace.Inv_PTD[inv_PTd_Items]; item++)
		{
			if(playertextid == IFace.Inv_PTD[inv_PTd_Items][item])
			{
				return Inv.ClickItem(playerid, item);
			}
		}
	}
    return CONTINUE;
}

//////////	Functions	//////////
Public: IFace.Inv_Toggle(playerid, bool:toggle, bool:changeVisibility)
{
	if(toggle)
	{
		//TextDrawShowForPlayer(playerid, IFace.Inv_TD[inv_Td_Background]);
		TextDrawShowForPlayer(playerid, IFace.Inv_TD[inv_Td_Window][0]);
		TextDrawShowForPlayer(playerid, IFace.Inv_TD[inv_Td_Window][1]);

		new string[32];
		format(string, sizeof(string), "%s [%d]", ReturnPlayerName(playerid), playerid);
		PlayerTextDrawSetString(playerid, IFace.Inv_PTD[inv_PTd_Title], string);
		PlayerTextDrawShow(playerid, IFace.Inv_PTD[inv_PTd_Title]);

		PlayerTextDrawShow(playerid, IFace.Inv_InHandSlot);

		IFace.Inv_UpdateSkin(playerid);

		//printf("iface selecttextdraw");
		//SelectTextDraw(playerid, INTERFACE_SELECT_COLOR);
	}
	else
	{
		//TextDrawHideForPlayer(playerid, IFace.Inv_TD[inv_Td_Background]);
		TextDrawHideForPlayer(playerid, IFace.Inv_TD[inv_Td_Window][0]);
		TextDrawHideForPlayer(playerid, IFace.Inv_TD[inv_Td_Window][1]);
		PlayerTextDrawHide(playerid, IFace.Inv_PTD[inv_PTd_Title]);
		PlayerTextDrawHide(playerid, IFace.Inv_PTD[inv_PTd_Skin]);

		for(new i = 0; i < sizeof IFace.Inv_AcsrSlots;	i++)	PlayerTextDrawHide(playerid, IFace.Inv_AcsrSlots[i]);
		for(new i = 0; i < MAX_TABS;	i++)					PlayerTextDrawHide(playerid, IFace.Inv_tabs[playerid][i]);
		for(new i = 0; i < MAX_INV_SLOTS; i++)
		{
			PlayerTextDrawHide(playerid, IFace.Inv_PTD[inv_PTd_Items][i]);
			PlayerTextDrawHide(playerid, IFace.Inv_PTD[itemsCount][i]);
		}
		PlayerTextDrawHide(playerid, IFace.Inv_InHandSlot);

		IFace.Inv_HideSelectedItem(playerid);
		IFace.Inv_DestroyButtons(playerid);

		TabsCount[playerid] = 0;
		DeletePVar(playerid, "Inv:IFace:SelectedItem");
		DeletePVar(playerid, "Inv:IFace:SelectedTab");

		//printf("iface cancel selecttextdraw");
		//CancelSelectTextDraw(playerid);
	}
}

stock IFace.Inv_ClearItem(playerid, item)
{
	new tabNum 		= GetPVarInt(playerid, "Inv:IFace:SelectedTab");
	new maxSlots 	= IFace.Inv_GetTabMaxSlots(playerid, tabNum);
	if(item >= maxSlots)	IFace.Inv_SetItem(playerid, item, 0, 0, -1);
	else 					IFace.Inv_SetItem(playerid, item, 0);
}

stock IFace.Inv_ClearItems(playerid)
{
	new tabNum 		= GetPVarInt(playerid, "Inv:IFace:SelectedTab");
	new maxSlots 	= IFace.Inv_GetTabMaxSlots(playerid, tabNum);
	for(new i = 0; i < sizeof(IFace.Inv_PTD[inv_PTd_Items]); i++)
	{
		if(i >= maxSlots)	IFace.Inv_SetItem(playerid, i, 0, 0, -1);
		else 				IFace.Inv_SetItem(playerid, i, 0);
	}
}

stock IFace.Inv_UpdateListItems(playerid)
{
	if(!IFace.GetGroupToggle(playerid, IFace.INVENTORY))	return false;
	IFace.Inv_ClearItems(playerid);
    Inv.SelectTab(playerid, GetPVarInt(playerid, "Inv:IFace:SelectedTab"));
    return true;
}

stock IFace.Inv_UpdateSkin(playerid)
{
	if(!IFace.GetGroupToggle(playerid, IFace.INVENTORY))	return false;
	PlayerTextDrawSetPreviewModel(playerid, IFace.Inv_PTD[inv_PTd_Skin], GetPlayerSkin(playerid));
	PlayerTextDrawShow(playerid, IFace.Inv_PTD[inv_PTd_Skin]);
	return true;
}

//	Tabs
IFace.Inv_AddTab(playerid, title[], E_INV_TABS:tabType, id, maxSlots = MAX_INV_SLOTS)
{
	if(!IFace.GetGroupToggleAndVisible(playerid, IFace.INVENTORY))	return INVALID_DATA;
	if(TabsCount[playerid] >= MAX_TABS)								return INVALID_DATA;
	
	strput(Tabs[playerid][ TabsCount[playerid] ][ti_Title], title);
	Tabs[playerid][ TabsCount[playerid] ][ti_tabType]	= tabType;
	Tabs[playerid][ TabsCount[playerid] ][ti_sourceID]	= id;
	Tabs[playerid][ TabsCount[playerid] ][ti_maxSlots]	= maxSlots;
	
	IFace.Inv_UpdateTab(playerid, TabsCount[playerid]);
	return TabsCount[playerid]++;
}

IFace.Inv_DeleteTab(playerid, E_INV_TABS:tabType, id)
{
	new bool:finded;
	for(new i = 0; i < TabsCount[playerid]; i++)
	{
		if(finded)
		{
			strput(Tabs[playerid][i - 1][ti_Title], Tabs[playerid][i][ti_Title]);
			Tabs[playerid][i - 1][ti_tabType] = Tabs[playerid][i][ti_tabType];
			Tabs[playerid][i - 1][ti_sourceID] = Tabs[playerid][i][ti_sourceID];
			Tabs[playerid][i - 1][ti_maxSlots] = Tabs[playerid][i][ti_maxSlots];
			IFace.Inv_UpdateTab(playerid, i - 1);
		}
		else if(Tabs[playerid][i][ti_tabType] == tabType && Tabs[playerid][i][ti_sourceID] == id)
		{
			finded = true;
		}
		if(i == TabsCount[playerid] - 1)
		{
			PlayerTextDrawHide(playerid, IFace.Inv_tabs[playerid][i]);
		}
	}
	if(finded)	TabsCount[playerid]--;
	return finded;
}

IFace.Inv_UpdateTab(playerid, tabNum, bool:selected = false)
{
	if(!IFace.GetGroupToggleAndVisible(playerid, IFace.INVENTORY))	return false;
	if(tabNum < 0 || tabNum >= MAX_TABS)							return false;
	if(IFace.Inv_tabs[playerid][tabNum])
	{
		PlayerTextDrawDestroy(playerid, IFace.Inv_tabs[playerid][tabNum]);
		IFace.Inv_tabs[playerid][tabNum] = PlayerText:0;
	}

	if(selected)
	{
		IFace.Inv_tabs[playerid][tabNum] = CreatePlayerTextDraw(playerid, INV_RIGHT_BASE_POS_X - 84.75 + (56.5 * tabNum), INV_RIGHT_BASE_POS_Y - 15.5, Tabs[playerid][tabNum][ti_Title]);
		PlayerTextDrawLetterSize(playerid, IFace.Inv_tabs[playerid][tabNum], 0.31, 1.25);
		PlayerTextDrawTextSize(playerid, IFace.Inv_tabs[playerid][tabNum], 10.0, 51.0);
	}
	else
	{
		IFace.Inv_tabs[playerid][tabNum] = CreatePlayerTextDraw(playerid, INV_RIGHT_BASE_POS_X - 84.75 + (56.5 * tabNum), INV_RIGHT_BASE_POS_Y - 13.0, Tabs[playerid][tabNum][ti_Title]);
		PlayerTextDrawLetterSize(playerid, IFace.Inv_tabs[playerid][tabNum], 0.31, 1.0);
		PlayerTextDrawTextSize(playerid, IFace.Inv_tabs[playerid][tabNum], 10.0, 51.0);
	}
	PlayerTextDrawAlignment(playerid, IFace.Inv_tabs[playerid][tabNum], 2);
	PlayerTextDrawBackgroundColor(playerid, IFace.Inv_tabs[playerid][tabNum], INV_BUTTON_TEXT_BACKGROUND_COLOR);
	PlayerTextDrawFont(playerid, IFace.Inv_tabs[playerid][tabNum], 1);
	PlayerTextDrawColor(playerid, IFace.Inv_tabs[playerid][tabNum], 0xFFFFFFFF);
	PlayerTextDrawSetOutline(playerid, IFace.Inv_tabs[playerid][tabNum], false);
	PlayerTextDrawSetProportional(playerid, IFace.Inv_tabs[playerid][tabNum], true);
	PlayerTextDrawSetShadow(playerid, IFace.Inv_tabs[playerid][tabNum], true);
	PlayerTextDrawUseBox(playerid, IFace.Inv_tabs[playerid][tabNum], true);
	PlayerTextDrawBoxColor(playerid, IFace.Inv_tabs[playerid][tabNum], INV_BUTTON_COLOR);
	PlayerTextDrawSetSelectable(playerid, IFace.Inv_tabs[playerid][tabNum], true);
	PlayerTextDrawShow(playerid, IFace.Inv_tabs[playerid][tabNum]);
	return true;
}

E_INV_TABS:IFace.Inv_GetTabType(playerid, tabNum)
{
	return Tabs[playerid][tabNum][ti_tabType];
}

IFace.Inv_GetTabSourceID(playerid, tabNum)
{
	return Tabs[playerid][tabNum][ti_sourceID];
}

IFace.Inv_GetTabMaxSlots(playerid, tabNum)
{
	return Tabs[playerid][tabNum][ti_maxSlots];
}

stock IFace.Inv_SelectTab(playerid, tabNum)
{
	IFace.Inv_UpdateTab(playerid, GetPVarInt(playerid, "Inv:IFace:SelectedTab"), false);

	SetPVarInt(playerid, "Inv:IFace:SelectedTab", tabNum);
	IFace.Inv_ClearItems(playerid);
	return Inv.SelectTab(playerid, tabNum);
}

//	Items
IFace.Inv_SetItem(playerid, item, model, count = 0, used = false, leftWindow = false, Float:x = -16.0, Float:y = 0.0, Float:z = -55.0, Float:zoom = 1.0)
{
	if(!IFace.GetGroupToggleAndVisible(playerid, IFace.INVENTORY))	return false;
	if(leftWindow)
	{
		if(!(0 <= item <= sizeof IFace.Inv_AcsrSlots))
		{
			return false;
		}

		acsrModels[playerid][item] = model;
		if(used == -1)	PlayerTextDrawBackgroundColor(playerid, IFace.Inv_AcsrSlots[item], 0x2c2429FF);
		else 			PlayerTextDrawBackgroundColor(playerid, IFace.Inv_AcsrSlots[item], INV_ITEM_BACKGROUND_COLOR);
		PlayerTextDrawSetPreviewModel(playerid, IFace.Inv_AcsrSlots[item], model);
		PlayerTextDrawSetPreviewRot(playerid, IFace.Inv_AcsrSlots[item], x, y, z, model ? 1.0 : 100.0);
		PlayerTextDrawShow(playerid, IFace.Inv_AcsrSlots[item]);
	}
	else
	{
		if(!(0 <= item < sizeof(IFace.Inv_PTD[inv_PTd_Items])))
		{
			return false;
		}
		Inventory_Models[playerid][item] 	= model;
		Inventory_SlotUsed[playerid][item] 	= (used == 1) ? true : false;

		if(used == -1)		PlayerTextDrawBackgroundColor(playerid, IFace.Inv_PTD[inv_PTd_Items][item], 0x2c2429FF);
		else if(used == 0)	PlayerTextDrawBackgroundColor(playerid, IFace.Inv_PTD[inv_PTd_Items][item], INV_ITEM_BACKGROUND_COLOR);
		else 				PlayerTextDrawBackgroundColor(playerid, IFace.Inv_PTD[inv_PTd_Items][item], INV_USED_ITEM_BACKGROUND_COLOR);
		PlayerTextDrawSetPreviewModel(playerid, IFace.Inv_PTD[inv_PTd_Items][item], Inventory_Models[playerid][item]);
		PlayerTextDrawSetPreviewRot(playerid, IFace.Inv_PTD[inv_PTd_Items][item], x, y, z, Inventory_Models[playerid][item] ? zoom : 100.0);
		PlayerTextDrawShow(playerid, IFace.Inv_PTD[inv_PTd_Items][item]);

		if(count > 1)
		{
			new string[8];
			format(string, 8, "x%d", count);
			PlayerTextDrawSetString(playerid, IFace.Inv_PTD[itemsCount][item], string);
			PlayerTextDrawShow(playerid, IFace.Inv_PTD[itemsCount][item]);
		}
		else
		{
			PlayerTextDrawHide(playerid, IFace.Inv_PTD[itemsCount][item]);
		}
	}
	return true;
}

IFace.Inv_GetItemModel(playerid, item, leftWindow = false)
{
	return leftWindow ? acsrModels[playerid][item] : Inventory_Models[playerid][item];
}

IFace.Inv_SelectItem(playerid, item, leftWindow = false)
{
	if(leftWindow)
	{
		if(!acsrModels[playerid][item])	return false;
		new oldSelected = GetPVarInt(playerid, "Inv:IFace:SelectedItem");

		if(GetPVarType(playerid, "Inv:IFace:SelectedItem") != PLAYER_VARTYPE_NONE)
		{
			if(GetPVarInt(playerid, "Inv:IFace:SelectedItemTab") != ACSR_TAB_NUM)
			{
				PlayerTextDrawBackgroundColor(playerid, IFace.Inv_PTD[inv_PTd_Items][oldSelected], INV_ITEM_BACKGROUND_COLOR);
				PlayerTextDrawShow(playerid, IFace.Inv_PTD[inv_PTd_Items][oldSelected]);
			}
			else
			{
				PlayerTextDrawBackgroundColor(playerid, IFace.Inv_AcsrSlots[oldSelected], INV_ITEM_BACKGROUND_COLOR);
				PlayerTextDrawShow(playerid, IFace.Inv_AcsrSlots[oldSelected]);
			}
		}
		SetPVarInt(playerid, "Inv:IFace:SelectedItem", item);
		SetPVarInt(playerid, "Inv:IFace:SelectedItemTab", ACSR_TAB_NUM);
		PlayerTextDrawBackgroundColor(playerid, IFace.Inv_AcsrSlots[item], INV_ITEM_SELECTED_BACKGROUND_COLOR);	
		PlayerTextDrawShow(playerid, IFace.Inv_AcsrSlots[item]);
	}
	else
	{
		if(!Inventory_Models[playerid][item])	return false;
		new oldSelected = GetPVarInt(playerid, "Inv:IFace:SelectedItem");

		if(GetPVarType(playerid, "Inv:IFace:SelectedItem") != PLAYER_VARTYPE_NONE)
		{
			if(GetPVarInt(playerid, "Inv:IFace:SelectedItemTab") == GetPVarInt(playerid, "Inv:IFace:SelectedTab"))
			{
				PlayerTextDrawBackgroundColor(playerid, IFace.Inv_PTD[inv_PTd_Items][oldSelected], INV_ITEM_BACKGROUND_COLOR);
				PlayerTextDrawShow(playerid, IFace.Inv_PTD[inv_PTd_Items][oldSelected]);
			}
		}
		SetPVarInt(playerid, "Inv:IFace:SelectedItem", item);
		SetPVarInt(playerid, "Inv:IFace:SelectedItemTab", GetPVarInt(playerid, "Inv:IFace:SelectedTab"));
		PlayerTextDrawBackgroundColor(playerid, IFace.Inv_PTD[inv_PTd_Items][item], INV_ITEM_SELECTED_BACKGROUND_COLOR);	
		PlayerTextDrawShow(playerid, IFace.Inv_PTD[inv_PTd_Items][item]);
	}
	return true;
}

IFace.Inv_ClearSelectItem(playerid)
{
	if(GetPVarType(playerid, "Inv:IFace:SelectedItem") == PLAYER_VARTYPE_NONE)
	{
		return false;
	}
	new selectedTab 	= GetPVarInt(playerid, "Inv:IFace:SelectedItemTab");
	new selectedItem 	= GetPVarInt(playerid, "Inv:IFace:SelectedItem");
	if(selectedTab == ACSR_TAB_NUM)
	{
		PlayerTextDrawBackgroundColor(playerid, IFace.Inv_AcsrSlots[selectedItem], INV_ITEM_BACKGROUND_COLOR);
		PlayerTextDrawShow(playerid, IFace.Inv_AcsrSlots[selectedItem]);
	}
	else if(selectedTab == GetPVarInt(playerid, "Inv:IFace:SelectedTab"))
	{
		if(Inventory_SlotUsed[playerid][selectedItem])	
		{
			PlayerTextDrawBackgroundColor(playerid, IFace.Inv_PTD[inv_PTd_Items][selectedItem], INV_USED_ITEM_BACKGROUND_COLOR);
		}
		else
		{
			PlayerTextDrawBackgroundColor(playerid, IFace.Inv_PTD[inv_PTd_Items][selectedItem], INV_ITEM_BACKGROUND_COLOR);
		}
		PlayerTextDrawShow(playerid, IFace.Inv_PTD[inv_PTd_Items][selectedItem]);
	}
	IFace.Inv_DestroyButtons(playerid);
	IFace.Inv_HideSelectedItem(playerid);
	DeletePVar(playerid, "Inv:IFace:SelectedItem");
	DeletePVar(playerid, "Inv:IFace:SelectedItemTab");
	return true;
}

//	Selected item
IFace.Inv_ShowSelectedItem(playerid, title[], info[], model, Float:x = -16.0, Float:y = 0.0, Float:z = -55.0, Float:zoom = 1.0)
{
	TextDrawShowForPlayer(playerid, IFace.Inv_TD[selectedWindow]);

	PlayerTextDrawSetString(playerid, IFace.Inv_PTD[SelectedItemTitle], title);
	PlayerTextDrawShow(playerid, IFace.Inv_PTD[SelectedItemTitle]);

	PlayerTextDrawSetPreviewModel(playerid, IFace.Inv_PTD[SelectedItem], model);
	PlayerTextDrawSetPreviewRot(playerid, IFace.Inv_PTD[SelectedItem], x, y, z, zoom);
	PlayerTextDrawShow(playerid, IFace.Inv_PTD[SelectedItem]);

	PlayerTextDrawSetString(playerid, IFace.Inv_PTD[SelectedItemInfo], info);
	PlayerTextDrawShow(playerid, IFace.Inv_PTD[SelectedItemInfo]);
}

IFace.Inv_HideSelectedItem(playerid)
{
	TextDrawHideForPlayer(playerid, IFace.Inv_TD[selectedWindow]);
	PlayerTextDrawHide(playerid, IFace.Inv_PTD[SelectedItemTitle]);
	PlayerTextDrawHide(playerid, IFace.Inv_PTD[SelectedItem]);
	PlayerTextDrawHide(playerid, IFace.Inv_PTD[SelectedItemInfo]);
}

//	Buttons
IFace.Inv_CreateButton(playerid, item, titel[], action, leftWindow = false)
{
	if(buttonsCount[playerid] >= MAX_ACTION_BUTTONS)
	{
		return false;
	}

	new i = buttonsCount[playerid];
	buttonAction[playerid][i] = action;

	if(leftWindow)
	{
		new Float:x = (INV_LEFT_BASE_POS_X - 71.5) + ((item % 2) ? 108.0 : 0.0) + 35.0,
			Float:y = (INV_LEFT_BASE_POS_Y + 3.00) + ((item / 2) ? 41.00 : 0.0) + 20.0;
		IFace.Inv_buttonsAction[playerid][i] = CreatePlayerTextDraw(playerid, x, y + (11.0 * i), titel);
		PlayerTextDrawAlignment(playerid, IFace.Inv_buttonsAction[playerid][i], 2);
		PlayerTextDrawBackgroundColor(playerid, IFace.Inv_buttonsAction[playerid][i], 255);
		PlayerTextDrawFont(playerid, IFace.Inv_buttonsAction[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, IFace.Inv_buttonsAction[playerid][i], 0.15, 0.6);
		PlayerTextDrawColor(playerid, IFace.Inv_buttonsAction[playerid][i], -1);
		PlayerTextDrawSetOutline(playerid, IFace.Inv_buttonsAction[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, IFace.Inv_buttonsAction[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, IFace.Inv_buttonsAction[playerid][i], 0);
		PlayerTextDrawUseBox(playerid, IFace.Inv_buttonsAction[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, IFace.Inv_buttonsAction[playerid][i], -1557715457);
		PlayerTextDrawTextSize(playerid, IFace.Inv_buttonsAction[playerid][i], 7.0, 25.0);
		PlayerTextDrawSetSelectable(playerid, IFace.Inv_buttonsAction[playerid][i], true);
		PlayerTextDrawShow(playerid, IFace.Inv_buttonsAction[playerid][i]);
	}
	else
	{
		new column = item % 6,
			line = item / 6;

		new Float:x = INV_RIGHT_BASE_POS_X - 107.5 + (36.0 * column) + 35.0,
			Float:y = INV_RIGHT_BASE_POS_Y + 3.0 + (41.0 * line) + 20.0;
		IFace.Inv_buttonsAction[playerid][i] = CreatePlayerTextDraw(playerid, x, y + (11.0 * i), titel);
		PlayerTextDrawAlignment(playerid, IFace.Inv_buttonsAction[playerid][i], 2);
		PlayerTextDrawBackgroundColor(playerid, IFace.Inv_buttonsAction[playerid][i], 255);
		PlayerTextDrawFont(playerid, IFace.Inv_buttonsAction[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, IFace.Inv_buttonsAction[playerid][i], 0.15, 0.6);
		PlayerTextDrawColor(playerid, IFace.Inv_buttonsAction[playerid][i], -1);
		PlayerTextDrawSetOutline(playerid, IFace.Inv_buttonsAction[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, IFace.Inv_buttonsAction[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, IFace.Inv_buttonsAction[playerid][i], 0);
		PlayerTextDrawUseBox(playerid, IFace.Inv_buttonsAction[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, IFace.Inv_buttonsAction[playerid][i], -1557715457);
		PlayerTextDrawTextSize(playerid, IFace.Inv_buttonsAction[playerid][i], 7.0, 25.0);
		PlayerTextDrawSetSelectable(playerid, IFace.Inv_buttonsAction[playerid][i], true);
		PlayerTextDrawShow(playerid, IFace.Inv_buttonsAction[playerid][i]);
	}
	

	buttonsCount[playerid]++;
	return true;
}

IFace.Inv_DestroyButtons(playerid)
{
	for(new i = 0; i < MAX_ACTION_BUTTONS; i++)
	{
		if(!IFace.Inv_buttonsAction[playerid][i])	continue;
		PlayerTextDrawDestroy(playerid, IFace.Inv_buttonsAction[playerid][i]);
		IFace.Inv_buttonsAction[playerid][i] = PlayerText:0;
	}
	buttonsCount[playerid] = 0;
}

IFace.Inv_HideButtons(playerid)
{
	if(!buttonsCount[playerid])	return false;
	for(new i = 0; i < MAX_ACTION_BUTTONS; i++)
	{
		if(!IFace.Inv_buttonsAction[playerid][i])	continue;
		PlayerTextDrawHide(playerid, IFace.Inv_buttonsAction[playerid][i]);
	}
	return true;
}

IFace.Inv_ShowButtons(playerid)
{
	if(!buttonsCount[playerid])	return false;
	for(new i = 0; i < MAX_ACTION_BUTTONS; i++)
	{
		if(!IFace.Inv_buttonsAction[playerid][i])	continue;
		PlayerTextDrawShow(playerid, IFace.Inv_buttonsAction[playerid][i]);
	}
	return true;
}

IFace.Inv_isActionButtonsToggle(playerid)
{
	return buttonsCount[playerid] ? true : false;
}

////////////////////////////////////////////////////////

IFace.Inv_Create_Base()
{
	IFace.AddWantHide(IFace.INVENTORY,	IFace.HACK_LOCK);
	IFace.AddWantHide(IFace.INVENTORY,	IFace.MISSION_MES);
	IFace.AddWantHide(IFace.INVENTORY,	IFace.VISUAL_TIMER);
	IFace.AddWantHide(IFace.INVENTORY,	IFace.WORK_INFO);
	IFace.AddWantHide(IFace.INVENTORY,	IFace.PHONE);
	IFace.AddWantHide(IFace.INVENTORY,	IFace.HOUSE_ENTER_MENU);
	IFace.AddWantHide(IFace.INVENTORY,	IFace.HOUSE_FUR);
	IFace.AddWantHide(IFace.INVENTORY,	IFace.SPEEDO);
	IFace.AddWantHide(IFace.INVENTORY,	IFace.BUY_MENU);
	IFace.AddWantHide(IFace.INVENTORY,	IFace.SELECT_MENU);
	IFace.AddWantHide(IFace.INVENTORY,	IFace.SELECTER);
	
	//	Общий фон
	IFace.Inv_TD[inv_Td_Background] = TextDrawCreate(640.0, 0.0, "~g~");
	TextDrawAlignment(IFace.Inv_TD[inv_Td_Background], 3);
	TextDrawUseBox(IFace.Inv_TD[inv_Td_Background], 1);
	TextDrawBoxColor(IFace.Inv_TD[inv_Td_Background], INV_BACKGROUND_COLOR);
	TextDrawLetterSize(IFace.Inv_TD[inv_Td_Background], 0.0, 50.0);
	TextDrawTextSize(IFace.Inv_TD[inv_Td_Background], 640.0, 480.0);

	//	Правое окно
	IFace.Inv_TD[inv_Td_Window][0] = TextDrawCreate(INV_RIGHT_BASE_POS_X, INV_RIGHT_BASE_POS_Y, "_");
	TextDrawAlignment(IFace.Inv_TD[inv_Td_Window][0], 2);
	TextDrawLetterSize(IFace.Inv_TD[inv_Td_Window][0], 0.0, 27.85);
	TextDrawUseBox(IFace.Inv_TD[inv_Td_Window][0], true);
	TextDrawBoxColor(IFace.Inv_TD[inv_Td_Window][0], INV_WINDOW_COLOR);
	TextDrawTextSize(IFace.Inv_TD[inv_Td_Window][0], 0.0, 220.0);

	//	Левое окно
	IFace.Inv_TD[inv_Td_Window][1] = TextDrawCreate(INV_LEFT_BASE_POS_X, INV_LEFT_BASE_POS_Y, "_");
	TextDrawAlignment(IFace.Inv_TD[inv_Td_Window][1], 2);
	TextDrawLetterSize(IFace.Inv_TD[inv_Td_Window][1], 0.0, 9.7);
	TextDrawUseBox(IFace.Inv_TD[inv_Td_Window][1], true);
	TextDrawBoxColor(IFace.Inv_TD[inv_Td_Window][1], INV_WINDOW_COLOR);
	TextDrawTextSize(IFace.Inv_TD[inv_Td_Window][1], 1.0, 146.0);

	//	Selected item window
	IFace.Inv_TD[selectedWindow] = TextDrawCreate(INV_PREVIEW_POS_X, INV_PREVIEW_POS_Y, "_background");
	TextDrawAlignment(IFace.Inv_TD[selectedWindow], 2);
	TextDrawBackgroundColor(IFace.Inv_TD[selectedWindow], 255);
	TextDrawFont(IFace.Inv_TD[selectedWindow], 1);
	TextDrawLetterSize(IFace.Inv_TD[selectedWindow], 0.0, 5.2);
	TextDrawColor(IFace.Inv_TD[selectedWindow], -1);
	TextDrawSetOutline(IFace.Inv_TD[selectedWindow], 0);
	TextDrawSetProportional(IFace.Inv_TD[selectedWindow], 1);
	TextDrawSetShadow(IFace.Inv_TD[selectedWindow], 1);
	TextDrawUseBox(IFace.Inv_TD[selectedWindow], 1);
	TextDrawBoxColor(IFace.Inv_TD[selectedWindow], INV_WINDOW_COLOR);
	TextDrawTextSize(IFace.Inv_TD[selectedWindow], 35.0, 146.0);
}

IFace.Inv_Create_Player(playerid)
{
	//	Слоты
	for(new y = 0; y < 6; y++)
	{
		for(new x = 0; x < 6; x++)
		{
			new i = (6 * y) + x;
			IFace.Inv_PTD[inv_PTd_Items][i] = CreatePlayerTextDraw(playerid, INV_RIGHT_BASE_POS_X - 107.5 + (36.0 * x), INV_RIGHT_BASE_POS_Y + 3.0 + (41.0 * y), "item");
			PlayerTextDrawAlignment(playerid, IFace.Inv_PTD[inv_PTd_Items][i], 2);
			PlayerTextDrawBackgroundColor(playerid, IFace.Inv_PTD[inv_PTd_Items][i], INV_ITEM_BACKGROUND_COLOR);
			PlayerTextDrawFont(playerid, IFace.Inv_PTD[inv_PTd_Items][i], 5);
			PlayerTextDrawLetterSize(playerid, IFace.Inv_PTD[inv_PTd_Items][i], 0.5, 1.0);
			PlayerTextDrawColor(playerid, IFace.Inv_PTD[inv_PTd_Items][i], -1);
			PlayerTextDrawUseBox(playerid, IFace.Inv_PTD[inv_PTd_Items][i], 1);
			PlayerTextDrawBoxColor(playerid, IFace.Inv_PTD[inv_PTd_Items][i], 0); 			// Без этого мигает модель
			PlayerTextDrawTextSize(playerid, IFace.Inv_PTD[inv_PTd_Items][i], 35.0, 40.0);
			PlayerTextDrawSetPreviewModel(playerid, IFace.Inv_PTD[inv_PTd_Items][i], 0);
			PlayerTextDrawSetPreviewRot(playerid, IFace.Inv_PTD[inv_PTd_Items][i], -16.0, 0.0, -55.0, 1.0);
			PlayerTextDrawSetSelectable(playerid, IFace.Inv_PTD[inv_PTd_Items][i], true);
		
			IFace.Inv_PTD[itemsCount][i] = CreatePlayerTextDraw(playerid, INV_RIGHT_BASE_POS_X - 74.5 + (36.0 * x), INV_RIGHT_BASE_POS_Y + 33.0 + (41.0 * y), "x1");
			PlayerTextDrawAlignment(playerid, IFace.Inv_PTD[itemsCount][i], 3);
			PlayerTextDrawBackgroundColor(playerid, IFace.Inv_PTD[itemsCount][i], 255);
			PlayerTextDrawFont(playerid, IFace.Inv_PTD[itemsCount][i], 1);
			PlayerTextDrawLetterSize(playerid, IFace.Inv_PTD[itemsCount][i], 0.18, 0.8);
			PlayerTextDrawColor(playerid, IFace.Inv_PTD[itemsCount][i], -1);
			PlayerTextDrawSetOutline(playerid, IFace.Inv_PTD[itemsCount][i], 0);
			PlayerTextDrawSetProportional(playerid, IFace.Inv_PTD[itemsCount][i], 1);
			PlayerTextDrawSetShadow(playerid, IFace.Inv_PTD[itemsCount][i], 0);
		}
	}

//	*** LEFT WINDOW ***
	IFace.Inv_PTD[inv_PTd_Title] = CreatePlayerTextDraw(playerid, INV_LEFT_BASE_POS_X, INV_LEFT_BASE_POS_Y - 14.0, "Name");
	PlayerTextDrawAlignment(playerid, IFace.Inv_PTD[inv_PTd_Title], 2);
	PlayerTextDrawBackgroundColor(playerid, IFace.Inv_PTD[inv_PTd_Title], INV_BUTTON_TEXT_BACKGROUND_COLOR);
	PlayerTextDrawFont(playerid, IFace.Inv_PTD[inv_PTd_Title], 1);
	PlayerTextDrawLetterSize(playerid, IFace.Inv_PTD[inv_PTd_Title], 0.23, 1.1);
	PlayerTextDrawColor(playerid, IFace.Inv_PTD[inv_PTd_Title], -1);
	PlayerTextDrawSetOutline(playerid, IFace.Inv_PTD[inv_PTd_Title], 0);
	PlayerTextDrawSetProportional(playerid, IFace.Inv_PTD[inv_PTd_Title], 1);
	PlayerTextDrawSetShadow(playerid, IFace.Inv_PTD[inv_PTd_Title], 1);
	PlayerTextDrawUseBox(playerid, IFace.Inv_PTD[inv_PTd_Title], 1);
	PlayerTextDrawBoxColor(playerid, IFace.Inv_PTD[inv_PTd_Title], INV_BUTTON_COLOR);
	PlayerTextDrawTextSize(playerid, IFace.Inv_PTD[inv_PTd_Title], 1.0, 146.0);

	IFace.Inv_PTD[inv_PTd_Skin] = CreatePlayerTextDraw(playerid, INV_LEFT_BASE_POS_X - 35.0, INV_LEFT_BASE_POS_Y + 3.0, "_");
	PlayerTextDrawAlignment(playerid, IFace.Inv_PTD[inv_PTd_Skin], 2);
	PlayerTextDrawBackgroundColor(playerid, IFace.Inv_PTD[inv_PTd_Skin], INV_ITEM_BACKGROUND_COLOR);
	PlayerTextDrawFont(playerid, IFace.Inv_PTD[inv_PTd_Skin], 5);
	PlayerTextDrawLetterSize(playerid, IFace.Inv_PTD[inv_PTd_Skin], 0.5, 1.0);
	PlayerTextDrawColor(playerid, IFace.Inv_PTD[inv_PTd_Skin], -1);
	PlayerTextDrawUseBox(playerid, IFace.Inv_PTD[inv_PTd_Skin], 1);
	PlayerTextDrawBoxColor(playerid, IFace.Inv_PTD[inv_PTd_Skin], 0);					// Без этого мигает модель
	PlayerTextDrawTextSize(playerid, IFace.Inv_PTD[inv_PTd_Skin], 70.25, 81.0);
	PlayerTextDrawSetPreviewModel(playerid, IFace.Inv_PTD[inv_PTd_Skin], 23);
	PlayerTextDrawSetPreviewRot(playerid, IFace.Inv_PTD[inv_PTd_Skin], -16.0, 0.0, 0.0, 1.0);
	PlayerTextDrawSetSelectable(playerid, IFace.Inv_PTD[inv_PTd_Skin], true);

	//	Слоты под аксессуары
	for(new i = 0; i < 4; i++)
	{
		new Float:x = (INV_LEFT_BASE_POS_X - 71.5) + ((i % 2) ? 108.0 : 0.0);
		new Float:y = (INV_LEFT_BASE_POS_Y + 3.00) + ((i / 2) ? 41.00 : 0.0);
		IFace.Inv_AcsrSlots[i] = CreatePlayerTextDraw(playerid, x, y, "_");
		PlayerTextDrawAlignment(playerid, IFace.Inv_AcsrSlots[i], 2);
		PlayerTextDrawBackgroundColor(playerid, IFace.Inv_AcsrSlots[i], INV_ITEM_BACKGROUND_COLOR);
		PlayerTextDrawFont(playerid, IFace.Inv_AcsrSlots[i], 5);
		PlayerTextDrawLetterSize(playerid, IFace.Inv_AcsrSlots[i], 0.5, 1.0);
		PlayerTextDrawColor(playerid, IFace.Inv_AcsrSlots[i], -1);
		PlayerTextDrawUseBox(playerid, IFace.Inv_AcsrSlots[i], 1);
		PlayerTextDrawBoxColor(playerid, IFace.Inv_AcsrSlots[i], 0); 			// Без этого мигает модель
		PlayerTextDrawTextSize(playerid, IFace.Inv_AcsrSlots[i], 35.0, 40.0);
		PlayerTextDrawSetPreviewModel(playerid, IFace.Inv_AcsrSlots[i], 19421);
		PlayerTextDrawSetPreviewRot(playerid, IFace.Inv_AcsrSlots[i], 180.0, 10.0, 0.0, 1.0);
		PlayerTextDrawSetSelectable(playerid, IFace.Inv_AcsrSlots[i], true);
	}

	//	Слот под предмет в руках
	IFace.Inv_InHandSlot = CreatePlayerTextDraw(playerid, 115.0, 164.0, "_");
	PlayerTextDrawBackgroundColor(playerid, IFace.Inv_InHandSlot, 0x16191DFF);
	PlayerTextDrawFont(playerid, IFace.Inv_InHandSlot, 5);
	PlayerTextDrawLetterSize(playerid, IFace.Inv_InHandSlot, 0.5, 1.0);
	PlayerTextDrawColor(playerid, IFace.Inv_InHandSlot, -1);
	PlayerTextDrawSetOutline(playerid, IFace.Inv_InHandSlot, 0);
	PlayerTextDrawSetProportional(playerid, IFace.Inv_InHandSlot, 1);
	PlayerTextDrawSetShadow(playerid, IFace.Inv_InHandSlot, 1);
	PlayerTextDrawUseBox(playerid, IFace.Inv_InHandSlot, 1);
	//PlayerTextDrawBoxColor(playerid, IFace.Inv_InHandSlot, 404431018);
	PlayerTextDrawTextSize(playerid, IFace.Inv_InHandSlot, 20.0, 20.0);
	PlayerTextDrawSetPreviewModel(playerid, IFace.Inv_InHandSlot, 1271);
	PlayerTextDrawSetPreviewRot(playerid, IFace.Inv_InHandSlot, -16.0, 0.0, -55.0, 1.0);
	PlayerTextDrawSetSelectable(playerid, IFace.Inv_InHandSlot, true);

	//	Selected item
	IFace.Inv_PTD[SelectedItemTitle] = CreatePlayerTextDraw(playerid, INV_PREVIEW_POS_X, INV_PREVIEW_POS_Y - 14.0, "_title");
	PlayerTextDrawAlignment(playerid, IFace.Inv_PTD[SelectedItemTitle], 2);
	PlayerTextDrawBackgroundColor(playerid, IFace.Inv_PTD[SelectedItemTitle], INV_BUTTON_TEXT_BACKGROUND_COLOR);
	PlayerTextDrawFont(playerid, IFace.Inv_PTD[SelectedItemTitle], 1);
	PlayerTextDrawLetterSize(playerid, IFace.Inv_PTD[SelectedItemTitle], 0.23, 1.1);
	PlayerTextDrawColor(playerid, IFace.Inv_PTD[SelectedItemTitle], -1);
	PlayerTextDrawSetOutline(playerid, IFace.Inv_PTD[SelectedItemTitle], 0);
	PlayerTextDrawSetProportional(playerid, IFace.Inv_PTD[SelectedItemTitle], 1);
	PlayerTextDrawSetShadow(playerid, IFace.Inv_PTD[SelectedItemTitle], 1);
	PlayerTextDrawUseBox(playerid, IFace.Inv_PTD[SelectedItemTitle], 1);
	PlayerTextDrawBoxColor(playerid, IFace.Inv_PTD[SelectedItemTitle], INV_BUTTON_COLOR);
	PlayerTextDrawTextSize(playerid, IFace.Inv_PTD[SelectedItemTitle], 35.0, 146.0);

	IFace.Inv_PTD[SelectedItem] = CreatePlayerTextDraw(playerid, INV_PREVIEW_POS_X - 71.0, INV_PREVIEW_POS_Y + 3.0, "_item");
	PlayerTextDrawAlignment(playerid, IFace.Inv_PTD[SelectedItem], 2);
	PlayerTextDrawBackgroundColor(playerid, IFace.Inv_PTD[SelectedItem], INV_ITEM_BACKGROUND_COLOR);
	PlayerTextDrawFont(playerid, IFace.Inv_PTD[SelectedItem], 5);
	PlayerTextDrawLetterSize(playerid, IFace.Inv_PTD[SelectedItem], 0.5, 1.0);
	PlayerTextDrawColor(playerid, IFace.Inv_PTD[SelectedItem], -1);
	PlayerTextDrawUseBox(playerid, IFace.Inv_PTD[SelectedItem], 1);
	PlayerTextDrawBoxColor(playerid, IFace.Inv_PTD[SelectedItem], 0); 			// Без этого мигает модель
	PlayerTextDrawTextSize(playerid, IFace.Inv_PTD[SelectedItem], 35.0, 40.0);
	PlayerTextDrawSetPreviewModel(playerid, IFace.Inv_PTD[SelectedItem], 0);
	PlayerTextDrawSetPreviewRot(playerid, IFace.Inv_PTD[SelectedItem], -16.0, 0.0, -55.0, 1.0);

	IFace.Inv_PTD[SelectedItemInfo] = CreatePlayerTextDraw(playerid, INV_PREVIEW_POS_X - 30.0, INV_PREVIEW_POS_Y + 5.0, "_info");
	PlayerTextDrawAlignment(playerid, IFace.Inv_PTD[SelectedItemInfo], 1);
	PlayerTextDrawBackgroundColor(playerid, IFace.Inv_PTD[SelectedItemInfo], 1583243007);
	PlayerTextDrawFont(playerid, IFace.Inv_PTD[SelectedItemInfo], 1);
	PlayerTextDrawLetterSize(playerid, IFace.Inv_PTD[SelectedItemInfo], 0.2, 1.0);
	PlayerTextDrawColor(playerid, IFace.Inv_PTD[SelectedItemInfo], -1);
	PlayerTextDrawSetOutline(playerid, IFace.Inv_PTD[SelectedItemInfo], 0);
	PlayerTextDrawSetProportional(playerid, IFace.Inv_PTD[SelectedItemInfo], 1);
	PlayerTextDrawSetShadow(playerid, IFace.Inv_PTD[SelectedItemInfo], 0);
	PlayerTextDrawUseBox(playerid, IFace.Inv_PTD[SelectedItemInfo], true);
	PlayerTextDrawBoxColor(playerid, IFace.Inv_PTD[SelectedItemInfo], 0x00000000);
	PlayerTextDrawTextSize(playerid, IFace.Inv_PTD[SelectedItemInfo], 170.0, 40.0);
}