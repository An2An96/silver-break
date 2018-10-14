#if defined _interface_buy_menu_included
	#endinput
#endif

#define _interface_buy_menu_included

forward OnBuyMenuResponse(playerid, id, button);

static
	Text:buyBackgroundTD,
	PlayerText:buyInfoPTD,
	PlayerText:buyButtonPTD;

Public: IFace.BuyMenu_Toggle(playerid, bool:toggle)
{
	if(toggle)
	{
		TextDrawShowForPlayer(playerid, buyBackgroundTD);
		PlayerTextDrawShow(playerid, buyInfoPTD);
		PlayerTextDrawShow(playerid, buyButtonPTD);
	}
	else
	{
		TextDrawHideForPlayer(playerid, buyBackgroundTD);
		PlayerTextDrawHide(playerid, buyInfoPTD);
		PlayerTextDrawHide(playerid, buyButtonPTD);
	}
	return true;
}

stock ShowPlayerBuyMenu(playerid, id, const text[], const button[])
{
	TogglePlayerControllable(playerid, false);
	SetPVarInt(playerid, "GUI:OInfo:ID", id);

	PlayerTextDrawSetString(playerid, buyInfoPTD, RusText(text, isRus(playerid)));
	PlayerTextDrawSetString(playerid, buyButtonPTD, RusText(button, isRus(playerid)));
	IFace.ToggleGroup(playerid, IFace.BUY_MENU, true);
	return true;
}

stock HidePlayerBuyMenu(playerid)
{
	TogglePlayerControllable(playerid, true);
	DeletePVar(playerid, "GUI:OInfo:ID");
	IFace.ToggleGroup(playerid, IFace.BUY_MENU, false);
	return true;
}

Public: IFace.BuyMenu_OnPlayerClickTD(playerid, Text:clickedid)
{
	if(clickedid == Text:INVALID_TEXT_DRAW)
	{
		if(IFace.GetGroupToggleAndVisible(playerid, IFace.BUY_MENU))
		{
			HidePlayerBuyMenu(playerid);
			CallLocalFunction("OnBuyMenuResponse", "iii", playerid, GetPVarInt(playerid, "GUI:OInfo:ID"), false);
			return true;
		}
	}
	return CONTINUE;
}

Public: IFace.BuyMenu_OnPlayerClickPTD(playerid, PlayerText:playertextid)
{
	if(playertextid == buyButtonPTD)
	{
		CallLocalFunction("OnBuyMenuResponse", "iii", playerid, GetPVarInt(playerid, "GUI:OInfo:ID"), true);
		return true;
	}

	return CONTINUE;
}

//////////////////////////////
IFace.BuyMenu_Load_Base()
{
	buyBackgroundTD = TextDrawCreate(200.0, 210.0, "box");
	TextDrawAlignment(buyBackgroundTD, 2);
	TextDrawLetterSize(buyBackgroundTD, 0.0, 5.0);
	TextDrawUseBox(buyBackgroundTD, 1);
	TextDrawBoxColor(buyBackgroundTD, INTERFACE_MAIN_COLOR);
	TextDrawTextSize(buyBackgroundTD, 0.0, 100.0);
}

IFace.BuyMenu_Load_Player(playerid)
{
	buyInfoPTD = CreatePlayerTextDraw(playerid, 155.0, 215.0, "text");
	PlayerTextDrawBackgroundColor(playerid, buyInfoPTD, 255);
	PlayerTextDrawFont(playerid, buyInfoPTD, 1);
	PlayerTextDrawLetterSize(playerid, buyInfoPTD, 0.3, 1.0);
	PlayerTextDrawColor(playerid, buyInfoPTD, -1);	//	572662273
	PlayerTextDrawSetOutline(playerid, buyInfoPTD, 0);
	PlayerTextDrawSetProportional(playerid, buyInfoPTD, 1);
	PlayerTextDrawSetShadow(playerid, buyInfoPTD, 0);

	buyButtonPTD = CreatePlayerTextDraw(playerid, 200.0, 240.0, "BUTTON");
	PlayerTextDrawAlignment(playerid, buyButtonPTD, 2);
	PlayerTextDrawBackgroundColor(playerid, buyButtonPTD, 255);
	PlayerTextDrawFont(playerid, buyButtonPTD, 2);
	PlayerTextDrawLetterSize(playerid, buyButtonPTD, 0.2, 1.1);
	PlayerTextDrawColor(playerid, buyButtonPTD, -1);
	PlayerTextDrawSetOutline(playerid, buyButtonPTD, 0);
	PlayerTextDrawSetProportional(playerid, buyButtonPTD, 1);
	PlayerTextDrawSetShadow(playerid, buyButtonPTD, 0);
	PlayerTextDrawUseBox(playerid, buyButtonPTD, 1);
	PlayerTextDrawBoxColor(playerid, buyButtonPTD, INTERFACE_BUTTON_COLOR);
	PlayerTextDrawTextSize(playerid, buyButtonPTD, 10.0, 90.0);
	PlayerTextDrawSetSelectable(playerid, buyButtonPTD, true);
}