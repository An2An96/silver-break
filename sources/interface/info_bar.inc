#if defined _interface_info_bar_included
	#endinput
#endif
#define _interface_info_bar_included

static
	PlayerText:InfoBar;

IFace.ShowPlayerInfoBar(playerid, const string[])
{
	PlayerTextDrawSetString(playerid, InfoBar,
		RusText(string, PlayerInfo[playerid][pRusifik]));
	PlayerTextDrawShow(playerid, InfoBar);
	return (1);
}

IFace.HidePlayerInfoBar(playerid)
{
	PlayerTextDrawHide(playerid, InfoBar);
	return (1);
}

IFace.InfoBar_CreatePlayerTD(playerid)
{
	InfoBar = CreatePlayerTextDraw(playerid, 608.0, 140.0, "_");
	PlayerTextDrawAlignment(playerid, InfoBar, 3);
	PlayerTextDrawBackgroundColor(playerid, InfoBar, 255);
	PlayerTextDrawFont(playerid, InfoBar, 2);
	PlayerTextDrawLetterSize(playerid, InfoBar, 0.25, 1.5);
	PlayerTextDrawColor(playerid, InfoBar, 0xB1C8FBFF);
	PlayerTextDrawSetOutline(playerid, InfoBar, 1);
	PlayerTextDrawSetProportional(playerid, InfoBar, 1);
	return (1);
}