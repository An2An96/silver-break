#if defined _interface_selecter_included
	#endinput
#endif

#define _interface_selecter_included

forward OnPlayerClickSelecter(playerid, selecter, action);

enum
{
	ACTION_BACK,
	ACTION_NEXT,
	ACTION_SELECT,
	ACTION_CANCEL
}

static
	Text:backgroundTD,
	Text:buttonBackTD,
	Text:buttonNextTD,
	Text:buttonSelectTD,
	Text:buttonCancelTD,
	pSelecterID[MAX_PLAYERS];

Public: IFace.Selecter_OnPlayerClickTD(playerid, Text:clickedid)
{
	if(IFace.GetGroupToggleAndVisible(playerid, IFace.SELECTER))
	{
		if(clickedid == buttonCancelTD || clickedid == Text:INVALID_TEXT_DRAW)
		{
			HidePlayerSelecter(playerid);
			CallLocalFunction("OnPlayerClickSelecter", "ddd", playerid, pSelecterID[playerid], ACTION_CANCEL);
			return true;
		}
		else if(clickedid == buttonBackTD)
		{
			CallLocalFunction("OnPlayerClickSelecter", "ddd", playerid, pSelecterID[playerid], ACTION_BACK);
			PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
			return true;
		}
		else if(clickedid == buttonNextTD)
		{
			CallLocalFunction("OnPlayerClickSelecter", "ddd", playerid, pSelecterID[playerid], ACTION_NEXT);
			PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
			return true;
		}
		else if(clickedid == buttonSelectTD)
		{
			CallLocalFunction("OnPlayerClickSelecter", "ddd", playerid, pSelecterID[playerid], ACTION_SELECT);
			return true;
		}
	}

	return CONTINUE;
}

//////////	Functions	//////////
stock ShowPlayerSelecter(playerid, selecterid)
{
	pSelecterID[playerid] = selecterid;
	IFace.ToggleGroup(playerid, IFace.SELECTER, true);
	return true;
}

stock HidePlayerSelecter(playerid)
{
	IFace.ToggleGroup(playerid, IFace.SELECTER, false);
	return true;
}

//////////	IFace 	//////////
Public: IFace.Selecter_Toggle(playerid, bool:toggle)
{
	if(toggle)
	{
		TextDrawShowForPlayer(playerid, backgroundTD);
		TextDrawShowForPlayer(playerid, buttonBackTD);
		TextDrawShowForPlayer(playerid, buttonNextTD);
		TextDrawShowForPlayer(playerid, buttonSelectTD);
		TextDrawShowForPlayer(playerid, buttonCancelTD);
	}
	else
	{
		TextDrawHideForPlayer(playerid, backgroundTD);
		TextDrawHideForPlayer(playerid, buttonBackTD);
		TextDrawHideForPlayer(playerid, buttonNextTD);
		TextDrawHideForPlayer(playerid, buttonSelectTD);
		TextDrawHideForPlayer(playerid, buttonCancelTD);
	}
	return true;
}

IFace.Selecter_Create_Base()
{
	// In OnGameModeInit prefferably, we procced to create our textdraws:
	backgroundTD = TextDrawCreate(320.0, 350.0, "back");
	TextDrawAlignment(backgroundTD, 2);
	TextDrawBackgroundColor(backgroundTD, 255);
	TextDrawFont(backgroundTD, 1);
	TextDrawLetterSize(backgroundTD, 0.0, 4.0);
	TextDrawColor(backgroundTD, -1);
	TextDrawSetOutline(backgroundTD, 0);
	TextDrawSetProportional(backgroundTD, 1);
	TextDrawSetShadow(backgroundTD, 1);
	TextDrawUseBox(backgroundTD, 1);
	TextDrawBoxColor(backgroundTD, INTERFACE_MAIN_COLOR);
	TextDrawTextSize(backgroundTD, 0.0, 115.0);

	buttonBackTD = TextDrawCreate(265.0, 355.0, "back");
	TextDrawAlignment(buttonBackTD, 2);
	TextDrawBackgroundColor(buttonBackTD, 556018175);
	TextDrawFont(buttonBackTD, 5);
	TextDrawLetterSize(buttonBackTD, 1.0, 7.0);
	TextDrawColor(buttonBackTD, -1);
	TextDrawSetOutline(buttonBackTD, 0);
	TextDrawSetProportional(buttonBackTD, 1);
	TextDrawSetShadow(buttonBackTD, 1);
	TextDrawUseBox(buttonBackTD, 1);
	TextDrawBoxColor(buttonBackTD, 556018175);
	TextDrawTextSize(buttonBackTD, 25.0, 25.0);
	TextDrawSetPreviewModel(buttonBackTD, 19133);
	TextDrawSetPreviewRot(buttonBackTD, -16.0, -90.0, 40.0, 1.0);
	TextDrawSetSelectable(buttonBackTD, true);

	buttonNextTD = TextDrawCreate(350.0, 355.0, "next");
	TextDrawAlignment(buttonNextTD, 2);
	TextDrawBackgroundColor(buttonNextTD, 556018175);
	TextDrawFont(buttonNextTD, 5);
	TextDrawLetterSize(buttonNextTD, 1.0, 7.0);
	TextDrawColor(buttonNextTD, -1);
	TextDrawSetOutline(buttonNextTD, 0);
	TextDrawSetProportional(buttonNextTD, 1);
	TextDrawSetShadow(buttonNextTD, 1);
	TextDrawUseBox(buttonNextTD, 1);
	TextDrawBoxColor(buttonNextTD, 556018175);
	TextDrawTextSize(buttonNextTD, 25.0, 25.0);
	TextDrawSetPreviewModel(buttonNextTD, 19133);
	TextDrawSetPreviewRot(buttonNextTD, -16.0, 90.0, -40.0, 1.0);
	TextDrawSetSelectable(buttonNextTD, true);

	buttonSelectTD = TextDrawCreate(320.0, 355.0, "SELECT");
	TextDrawAlignment(buttonSelectTD, 2);
	TextDrawBackgroundColor(buttonSelectTD, 255);
	TextDrawFont(buttonSelectTD, 2);
	TextDrawLetterSize(buttonSelectTD, 0.25, 1.0);
	TextDrawColor(buttonSelectTD, -1);
	TextDrawSetOutline(buttonSelectTD, 0);
	TextDrawSetProportional(buttonSelectTD, 1);
	TextDrawSetShadow(buttonSelectTD, 0);
	TextDrawTextSize(buttonSelectTD, 10.0, 30.0);
	TextDrawSetSelectable(buttonSelectTD, true);

	buttonCancelTD = TextDrawCreate(320.0, 370.0, "CANCEL");
	TextDrawAlignment(buttonCancelTD, 2);
	TextDrawBackgroundColor(buttonCancelTD, 255);
	TextDrawFont(buttonCancelTD, 2);
	TextDrawLetterSize(buttonCancelTD, 0.25, 1.0);
	TextDrawColor(buttonCancelTD, -1);
	TextDrawSetOutline(buttonCancelTD, 0);
	TextDrawSetProportional(buttonCancelTD, 1);
	TextDrawSetShadow(buttonCancelTD, 0);
	TextDrawTextSize(buttonCancelTD, 10.0, 30.0);
	TextDrawSetSelectable(buttonCancelTD, true);
}