#if defined _interface_repbar_included
	#endinput
#endif

#define _interface_repbar_included

static 
	Text:g_RepBar_Background,
	Text:g_RepBar_BackgroundLine,
	Text:g_RepBar_ScaleText,

	PlayerText:RepBar_Title,
	PlayerText:RepBar_ActiveLine,
	PlayerText:RepBar_GreenLine[MAX_PLAYERS],	

	RepBarTimer[MAX_PLAYERS];

flags:reptest(CMD_DEVELOPER);
CMD:reptest(playerid, params[])
{	// [BT]
	new title[32], oldval, newval, maxval;
	if (sscanf(params, "s[32]ddd", title, oldval, newval, maxval))
	    return SendClientMessage(playerid, -1,
			"Используйте: /reptest [текст] [старое знач.] [новое знач.] [макс. знач.]");
    return IFace.RepBarShow(playerid, title, oldval, newval, maxval);
}

Public: IFace.RepBar_Toggle(playerid, bool:toggle)
{
	if(toggle)
	{
		if (RepBarTimer[playerid])
			IFace.RepBar_Toggle(playerid, false);
		TextDrawShowForPlayer(playerid, g_RepBar_Background);
		TextDrawShowForPlayer(playerid, g_RepBar_BackgroundLine);
		TextDrawShowForPlayer(playerid, g_RepBar_ScaleText);
	}
	else
	{
		TextDrawHideForPlayer(playerid, g_RepBar_Background);
		TextDrawHideForPlayer(playerid, g_RepBar_BackgroundLine);
		TextDrawHideForPlayer(playerid, g_RepBar_ScaleText);

		PlayerTextDrawHide(playerid, RepBar_Title);
		PlayerTextDrawHide(playerid, RepBar_ActiveLine);
		PlayerTextDrawDestroy(playerid, RepBar_GreenLine[playerid]);
		KillTimer(RepBarTimer[playerid]);
		RepBarTimer[playerid] = 0;
	}
}

IFace.RepBarShow(playerid, title[], oldval, newval, maxval = 100, time = 5000)
{
	IFace.ToggleGroup(playerid, IFace.REPBAR, true);	

	PlayerTextDrawSetString(playerid, RepBar_Title,
		RusText(title, isRus(playerid)));
	PlayerTextDrawShow(playerid, RepBar_Title);

	new Float:tmp1, Float:tmp2;
	if(oldval <= newval)
	{
		if(newval > maxval)
			maxval = newval;
		tmp1 = 100.0 * newval / maxval;
		tmp2 = 100.0 * oldval / maxval;
		RepBar_GreenLine[playerid] =
			CreatePlayerTextDraw(playerid, 512.0 + 0.89 * tmp2, 185.0, "4");
		PlayerTextDrawBoxColor(playerid,
			RepBar_GreenLine[playerid], COLOR_GREEN);
	}
	else
	{
	    if(oldval > maxval)
			maxval = oldval;
		tmp1 = 100.0 * oldval / maxval;
		tmp2 = 100.0 * newval / maxval;
		RepBar_GreenLine[playerid] =
			CreatePlayerTextDraw(playerid, 512.0 + 0.89 * tmp2, 185.0, "4");
		PlayerTextDrawBoxColor(playerid, RepBar_GreenLine[playerid], COLOR_RED);
	}
	PlayerTextDrawTextSize(playerid, RepBar_ActiveLine, 508.0 + 0.89 * tmp1, 85.0);
	PlayerTextDrawShow(playerid, RepBar_ActiveLine);

	PlayerTextDrawBackgroundColor(playerid, RepBar_GreenLine[playerid], 255);
	PlayerTextDrawFont(playerid, RepBar_GreenLine[playerid], 1);
	PlayerTextDrawLetterSize(playerid, RepBar_GreenLine[playerid], 0.0, 0.599999);
	PlayerTextDrawColor(playerid, RepBar_GreenLine[playerid], -1);
	PlayerTextDrawSetOutline(playerid, RepBar_GreenLine[playerid], 0);
	PlayerTextDrawSetProportional(playerid, RepBar_GreenLine[playerid], 1);
	PlayerTextDrawSetShadow(playerid, RepBar_GreenLine[playerid], 1);
	PlayerTextDrawUseBox(playerid, RepBar_GreenLine[playerid], 1);
	PlayerTextDrawTextSize(playerid, RepBar_GreenLine[playerid], 508.0 + 0.89 * tmp1, 85.0);
	PlayerTextDrawShow(playerid, RepBar_GreenLine[playerid]);

	RepBarTimer[playerid] = SetTimerEx("_RepBarHide", time, false, "d", playerid);
	return (1);
}

Public: _RepBarHide(playerid)
{
    IFace.ToggleGroup(playerid, IFace.REPBAR, false);
	return true;
}

public	OnTextDrawInit()
{
	g_RepBar_Background = TextDrawCreate(555.0, 170.0, "1");
	TextDrawAlignment(g_RepBar_Background, 2);
	TextDrawBackgroundColor(g_RepBar_Background, 255);
	TextDrawFont(g_RepBar_Background, 1);
	TextDrawLetterSize(g_RepBar_Background, 0.0, 2.599999);
	TextDrawColor(g_RepBar_Background, -1);
	TextDrawSetOutline(g_RepBar_Background, 0);
	TextDrawSetProportional(g_RepBar_Background, 1);
	TextDrawSetShadow(g_RepBar_Background, 1);
	TextDrawUseBox(g_RepBar_Background, 1);
	TextDrawBoxColor(g_RepBar_Background, 136);
	TextDrawTextSize(g_RepBar_Background, 0.0, 110.0);

	g_RepBar_BackgroundLine = TextDrawCreate(555.0, 185.0, "2");
	TextDrawAlignment(g_RepBar_BackgroundLine, 2);
	TextDrawBackgroundColor(g_RepBar_BackgroundLine, 255);
	TextDrawFont(g_RepBar_BackgroundLine, 1);
	TextDrawLetterSize(g_RepBar_BackgroundLine, 0.0, 0.599999);
	TextDrawColor(g_RepBar_BackgroundLine, -1);
	TextDrawSetOutline(g_RepBar_BackgroundLine, 0);
	TextDrawSetProportional(g_RepBar_BackgroundLine, 1);
	TextDrawSetShadow(g_RepBar_BackgroundLine, 1);
	TextDrawUseBox(g_RepBar_BackgroundLine, 1);
	TextDrawBoxColor(g_RepBar_BackgroundLine, -1347440862);
	TextDrawTextSize(g_RepBar_BackgroundLine, 0.0, 85.0);

	g_RepBar_ScaleText = TextDrawCreate(502.0, 178.0, "-                       +");
	TextDrawBackgroundColor(g_RepBar_ScaleText, -1263159297);
	TextDrawFont(g_RepBar_ScaleText, 1);
	TextDrawLetterSize(g_RepBar_ScaleText, 0.45, 2.0);
	TextDrawColor(g_RepBar_ScaleText, -1347440675);
	TextDrawSetOutline(g_RepBar_ScaleText, 0);
	TextDrawSetProportional(g_RepBar_ScaleText, 1);
	TextDrawSetShadow(g_RepBar_ScaleText, 0);

	#if defined RepBar_OnTextDrawInit
		return (RepBar_OnTextDrawInit());
	#else
		return (1);
	#endif
}
#if defined _ALS_OnTextDrawInit
	#undef OnTextDrawInit
#else
	#define _ALS_OnTextDrawInit
#endif
#define OnTextDrawInit	RepBar_OnTextDrawInit
#if defined RepBar_OnTextDrawInit
	forward RepBar_OnTextDrawInit();
#endif

public	OnPlayerTextDrawInit(playerid)
{
	RepBar_Title = CreatePlayerTextDraw(playerid, 500.0, 167.0, "Title:");
	PlayerTextDrawBackgroundColor(playerid, RepBar_Title, -1263159297);
	PlayerTextDrawFont(playerid, RepBar_Title, 1);
	PlayerTextDrawLetterSize(playerid, RepBar_Title, 0.3, 1.5);
	PlayerTextDrawColor(playerid, RepBar_Title, -1347440675);
	PlayerTextDrawSetOutline(playerid, RepBar_Title, 0);
	PlayerTextDrawSetProportional(playerid, RepBar_Title, 1);
	PlayerTextDrawSetShadow(playerid, RepBar_Title, 0);

	RepBar_ActiveLine = CreatePlayerTextDraw(playerid, 512.0, 185.0, "3");
	PlayerTextDrawBackgroundColor(playerid, RepBar_ActiveLine, 255);
	PlayerTextDrawFont(playerid, RepBar_ActiveLine, 1);
	PlayerTextDrawLetterSize(playerid, RepBar_ActiveLine, 0.0, 0.6);
	PlayerTextDrawColor(playerid, RepBar_ActiveLine, -1);
	PlayerTextDrawSetOutline(playerid, RepBar_ActiveLine, 0);
	PlayerTextDrawSetProportional(playerid, RepBar_ActiveLine, 1);
	PlayerTextDrawSetShadow(playerid, RepBar_ActiveLine, 1);
	PlayerTextDrawUseBox(playerid, RepBar_ActiveLine, 1);
	PlayerTextDrawBoxColor(playerid, RepBar_ActiveLine, -1347440743);
	PlayerTextDrawTextSize(playerid, RepBar_ActiveLine, 508.0, 85.0);

	#if defined RepBar_OnPlayerTextDrawInit
		return (RepBar_OnPlayerTextDrawInit(playerid));
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerTextDrawInit
	#undef OnPlayerTextDrawInit
#else
	#define _ALS_OnPlayerTextDrawInit
#endif
#define OnPlayerTextDrawInit	RepBar_OnPlayerTextDrawInit
#if defined RepBar_OnPlayerTextDrawInit
	forward RepBar_OnPlayerTextDrawInit(playerid);
#endif
