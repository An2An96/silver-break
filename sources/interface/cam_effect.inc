#if defined _interface_cam_effect_included
  #endinput
#endif

#define _interface_cam_effect_included

static Text:TD_CamEffects[3];
static CamEffect_Timer[MAX_PLAYERS];

Public: IFace.CamEffect_Toggle(playerid, bool:toggle)
{
	if(toggle)
	{
		TextDrawShowForPlayer(playerid, TD_CamEffects[0]);
		TextDrawShowForPlayer(playerid, TD_CamEffects[1]);
		TextDrawShowForPlayer(playerid, TD_CamEffects[2]);

		IFace.CamEffect_Tick(playerid, true);
	}
	else
	{
		KillTimer(CamEffect_Timer[playerid]);
		
		TextDrawHideForPlayer(playerid, TD_CamEffects[0]);
		TextDrawHideForPlayer(playerid, TD_CamEffects[1]);
		TextDrawHideForPlayer(playerid, TD_CamEffects[2]);
	}
}

Public: IFace.CamEffect_Tick(playerid, bool:tick)
{
	if(IFace.GetGroupToggleAndVisible(playerid, IFace.CAM_EFFECT))
	{
		if(tick)	TextDrawShowForPlayer(playerid, TD_CamEffects[0]);
		else 		TextDrawHideForPlayer(playerid, TD_CamEffects[0]);
		CamEffect_Timer[playerid] = SetPlayerTimerEx(playerid, "IFace_CamEffect_Tick", 1000, false, "ii", playerid, !tick);
	}
	return true;
}

IFace.CamEffect_Update(playerid)
{
	if(IFace.GetGroupToggleAndVisible(playerid, IFace.CAM_EFFECT))
	{
		TextDrawShowForPlayer(playerid, TD_CamEffects[2]);
	}
}

IFace.CamEffect_UpdateTime()
{
	new string[24];
	new hour, minute, second;
	gettime(hour, minute, second);
	format(string, sizeof(string), "%02d:%02d:%02d.%03d", hour, minute, second, GetTickCount() % 1000);
	TextDrawSetString(TD_CamEffects[2], string);
}

IFace.CamEffect_Load_Base()
{
	IFace.AddWantShow(IFace.CAM_EFFECT,		IFace.TV_EFFECT);
	
	TD_CamEffects[0] = TextDrawCreate(528.0, 261.0, ".");
	TextDrawBackgroundColor(TD_CamEffects[0], 255);
	TextDrawFont(TD_CamEffects[0], 1);
	TextDrawLetterSize(TD_CamEffects[0], 1.560000, 8.000000);
	TextDrawColor(TD_CamEffects[0], -16776961);
	TextDrawSetOutline(TD_CamEffects[0], 0);
	TextDrawSetProportional(TD_CamEffects[0], 1);
	TextDrawSetShadow(TD_CamEffects[0], 0);
	TextDrawSetSelectable(TD_CamEffects[0], 0);

	TD_CamEffects[1] = TextDrawCreate(545.0, 304.0, "REC");
	TextDrawBackgroundColor(TD_CamEffects[1], 255);
	TextDrawFont(TD_CamEffects[1], 1);
	TextDrawLetterSize(TD_CamEffects[1], 0.659999, 2.399998);
	TextDrawColor(TD_CamEffects[1], -16776961);
	TextDrawSetOutline(TD_CamEffects[1], 0);
	TextDrawSetProportional(TD_CamEffects[1], 1);
	TextDrawSetShadow(TD_CamEffects[1], 0);
	TextDrawSetSelectable(TD_CamEffects[1], 0);

	TD_CamEffects[2] = TextDrawCreate(80.0, 302.0, "00:01:50.173");
	TextDrawAlignment(TD_CamEffects[2], 2);
	TextDrawBackgroundColor(TD_CamEffects[2], 255);
	TextDrawFont(TD_CamEffects[2], 2);
	TextDrawLetterSize(TD_CamEffects[2], 0.3, 2.5);
	TextDrawColor(TD_CamEffects[2], -1);
	TextDrawSetOutline(TD_CamEffects[2], 0);
	TextDrawSetProportional(TD_CamEffects[2], 0);
	TextDrawSetShadow(TD_CamEffects[2], 1);
	TextDrawSetSelectable(TD_CamEffects[2], 0);
}