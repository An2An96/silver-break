#if defined _interface_select_menu_included
	#endinput
#endif

#define _interface_select_menu_included

#define SELECT_MENU_X				115.0
#define SELECT_MENU_Y				160.0
#define MAX_SELECT_MENU_ITEMS		10

forward OnPlayerSelectMenuSelect(playerid, reponse, menuid, item);

static
	pMenuID[MAX_PLAYERS],
	pItemCount[MAX_PLAYERS],

	Text:backgroundTD,

	PlayerText:pItemsPTD[MAX_PLAYERS][MAX_SELECT_MENU_ITEMS],
	PlayerText:pTitlePTD[MAX_PLAYERS];

Public: IFace.Select_OnPlayerClickTD(playerid, Text:clickedid)
{
	if(IFace.GetGroupToggleAndVisible(playerid, IFace.SELECT_MENU))
	{
		if(clickedid == Text:INVALID_TEXT_DRAW)
		{
			if(CallLocalFunction("OnPlayerSelectMenuSelect", "dddd", playerid, false, pMenuID[playerid], 0))
			{
				HidePlayerSelectMenu(playerid);
				return true;
			}
		}
	}

	return CONTINUE;
}

Public: IFace.Select_OnPlayerClickPTD(playerid, PlayerText:playertextid)
{
	if(IFace.GetGroupToggleAndVisible(playerid, IFace.SELECT_MENU))
	{
		for(new i = 0; i < MAX_SELECT_MENU_ITEMS; i++)
		{
			if(playertextid == pItemsPTD[playerid][i])
			{
				if(CallLocalFunction("OnPlayerSelectMenuSelect", "dddd", playerid, true, pMenuID[playerid], i))
				{
					HidePlayerSelectMenu(playerid);
					return true;
				}
			}
		}
	}

	return CONTINUE;
}

//////////	Functions	//////////
stock ShowPlayerSelectMenu(playerid, menuid, title[], string[][], size = sizeof(string))
{
	pMenuID[playerid] = menuid;
	pItemCount[playerid] = size;
	IFace.ToggleGroup(playerid, IFace.SELECT_MENU, true);

	PlayerTextDrawSetString(playerid, pTitlePTD[playerid], title);
	PlayerTextDrawShow(playerid, pTitlePTD[playerid]);

	for(new i = 0; i < size; i++)
	{
		if(i >= MAX_SELECT_MENU_ITEMS)	break;
		PlayerTextDrawSetString(playerid, pItemsPTD[playerid][i], string[i]);
		PlayerTextDrawShow(playerid, pItemsPTD[playerid][i]);
	}

	//SelectTextDraw(playerid, INTERFACE_SELECT_COLOR);
}

stock HidePlayerSelectMenu(playerid)
{
	pItemCount[playerid] = 0;
	IFace.ToggleGroup(playerid, IFace.SELECT_MENU, false);
	return true;
}

//////////	IFace 	//////////
Public: IFace.SelectMenu_Toggle(playerid, bool:toggle, bool:changeVisibility)
{
	if(toggle)
	{
		TextDrawShowForPlayer(playerid, backgroundTD);
		if(changeVisibility)
		{
			PlayerTextDrawShow(playerid, pTitlePTD[playerid]);

			for(new i = 0; i < pItemCount[playerid]; i++)
			{
				if(i >= MAX_SELECT_MENU_ITEMS)	break;
				PlayerTextDrawShow(playerid, pItemsPTD[playerid][i]);
			}
		}

		//printf("selectmenu selecttextdraw");
		//SelectTextDraw(playerid, INTERFACE_SELECT_COLOR);
	}
	else
	{
		TextDrawHideForPlayer(playerid, backgroundTD);
		PlayerTextDrawHide(playerid, pTitlePTD[playerid]);
		for(new i = 0; i < MAX_SELECT_MENU_ITEMS; i++)
		{
			PlayerTextDrawHide(playerid, pItemsPTD[playerid][i]);
		}

		//printf("selectmenu cancel selecttextdraw");
		//CancelSelectTextDraw(playerid);
	}
	return true;
}

IFace.SelectMenu_Create_Base()
{
	backgroundTD = TextDrawCreate(SELECT_MENU_X, SELECT_MENU_Y - 13.5, "back");
	TextDrawAlignment(backgroundTD, 2);
	TextDrawBackgroundColor(backgroundTD, 255);
	TextDrawFont(backgroundTD, 1);
	TextDrawLetterSize(backgroundTD, 0.0, 1.0);
	TextDrawColor(backgroundTD, -1);
	TextDrawSetOutline(backgroundTD, 0);
	TextDrawSetProportional(backgroundTD, 1);
	TextDrawSetShadow(backgroundTD, 1);
	TextDrawUseBox(backgroundTD, 1);
	TextDrawBoxColor(backgroundTD, INTERFACE_CO_MAIN_COLOR);
	TextDrawTextSize(backgroundTD, 0.0, 120.0);
}

IFace.SelectMenu_Create_Player(playerid)
{
	for(new i = 0; i < MAX_SELECT_MENU_ITEMS; i++)
	{
		pItemsPTD[playerid][i] = CreatePlayerTextDraw(playerid, SELECT_MENU_X - 60.0, SELECT_MENU_Y + (i * 13.6), "asd___________________________________________100$");
		PlayerTextDrawBackgroundColor(playerid, pItemsPTD[playerid][i], 0x0E0F12FF);
		PlayerTextDrawFont(playerid, pItemsPTD[playerid][i], 1);
		PlayerTextDrawLetterSize(playerid, pItemsPTD[playerid][i], 0.2, 1.0);
		PlayerTextDrawColor(playerid, pItemsPTD[playerid][i], -1);
		PlayerTextDrawSetOutline(playerid, pItemsPTD[playerid][i], 0);
		PlayerTextDrawSetProportional(playerid, pItemsPTD[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, pItemsPTD[playerid][i], 1);
		PlayerTextDrawUseBox(playerid, pItemsPTD[playerid][i], 1);
		PlayerTextDrawBoxColor(playerid, pItemsPTD[playerid][i], INTERFACE_MAIN_COLOR);
		PlayerTextDrawTextSize(playerid, pItemsPTD[playerid][i], 175.0, 10.0);
		PlayerTextDrawSetSelectable(playerid, pItemsPTD[playerid][i], true);
	}

	pTitlePTD[playerid] = CreatePlayerTextDraw(playerid, SELECT_MENU_X - 60.0, SELECT_MENU_Y - 22.0, "Select Menu");
	PlayerTextDrawBackgroundColor(playerid, pTitlePTD[playerid], 1964776191);
	PlayerTextDrawFont(playerid, pTitlePTD[playerid], 0);
	PlayerTextDrawLetterSize(playerid, pTitlePTD[playerid], 0.5, 2.0);
	PlayerTextDrawColor(playerid, pTitlePTD[playerid], -1);
	PlayerTextDrawSetOutline(playerid, pTitlePTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, pTitlePTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, pTitlePTD[playerid], 1);
}