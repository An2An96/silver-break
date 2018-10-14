#if defined _interface_mission_included
	#endinput
#endif

#define _interface_mission_included

static 
	PlayerText:MissionMessage,
	PlayerText:MissionInfo,

	missionmessage_timer[MAX_PLAYERS],
	pSaveTime[MAX_PLAYERS]		= { INVALID_DATA, ... },
	pSaveShowInfo[MAX_PLAYERS]	= { INVALID_DATA, ... };

new MissionInfoTimer[MAX_PLAYERS],
	gMissionInfo[MAX_PLAYERS][256];

Public: IFace.Mission_Message_Toggle(playerid, bool:toggle)
{
	if(missionmessage_timer[playerid] > 0)
	{
	    KillTimer(missionmessage_timer[playerid]);
	    missionmessage_timer[playerid] = 0;
	}
	if(toggle)
	{
		PlayerTextDrawShow(playerid, MissionMessage);
		if(pSaveTime[playerid] != INVALID_DATA && pSaveTime[playerid] > 0)
		{
			missionmessage_timer[playerid] = SetPlayerTimerEx(playerid, "HideMissionMessage", pSaveTime[playerid], false, "i", playerid);
		}
		//if(pSaveShowInfo[playerid])	
		//{
			//ShowMissionInfo(playerid, string, pSaveTime[playerid] - 500);
		//}
		pSaveTime[playerid]		= INVALID_DATA;
		pSaveShowInfo[playerid]	= INVALID_DATA;
	}
	else
	{
		PlayerTextDrawHide(playerid, MissionMessage);
	}
}

stock SendMissionMessage(playerid, string[], time = 5000, show_info = false)
{
	pSaveTime[playerid] = time;
	pSaveShowInfo[playerid] = show_info;
	PlayerTextDrawSetString(playerid, MissionMessage, RusText(string, isRus(playerid)));
	IFace.ToggleGroup(playerid, IFace.MISSION_MES, true);
	return 1;
}

Public: HideMissionMessage(playerid)
{
	IFace.ToggleGroup(playerid, IFace.MISSION_MES, false);
}

stock ShowMissionInfo(playerid, text[], time = 0)
{
	strmid(gMissionInfo[playerid], text, 0, strlen(text), 255);
	KillTimer(MissionInfoTimer[playerid]);
	if(time > 0)	MissionInfoTimer[playerid] = SetPlayerTimerEx(playerid, "_showMissionInfo", time, false, "i", playerid);
	else 			_showMissionInfo(playerid);
	return true;
}

Public: _showMissionInfo(playerid)
{
	PlayerTextDrawSetString(playerid, MissionInfo, RusText(gMissionInfo[playerid], isRus(playerid)));
	PlayerTextDrawShow(playerid, MissionInfo);
}

stock HideMissionInfo(playerid)
{
	KillTimer(MissionInfoTimer[playerid]);
	PlayerTextDrawHide(playerid, MissionInfo);
	gMissionInfo[playerid] = "";
	return true;
}

IFace.Mission_Create_Player(playerid)
{
	MissionMessage = CreatePlayerTextDraw(playerid, 320.0, 340.0, "_");
	PlayerTextDrawAlignment(playerid, MissionMessage, 2);
	PlayerTextDrawBackgroundColor(playerid, MissionMessage, 255);
	PlayerTextDrawFont(playerid, MissionMessage, 1);
	PlayerTextDrawLetterSize(playerid, MissionMessage, 0.45, 1.5);
	PlayerTextDrawColor(playerid, MissionMessage, -1);
	PlayerTextDrawSetOutline(playerid, MissionMessage, 0);
	PlayerTextDrawSetProportional(playerid, MissionMessage, 1);
	PlayerTextDrawSetShadow(playerid, MissionMessage, 1);
	PlayerTextDrawUseBox(playerid, MissionMessage, 1);
	PlayerTextDrawBoxColor(playerid, MissionMessage, 0);
	PlayerTextDrawTextSize(playerid, MissionMessage, 450.0, 356.0);
	
	MissionInfo = CreatePlayerTextDraw(playerid, 320.0, 430.0, "~y~]~w~ Tyt bydet kakoe to zadanie dlya igroka~y~]");
	PlayerTextDrawAlignment(playerid, MissionInfo, 2);
	PlayerTextDrawBackgroundColor(playerid, MissionInfo, 85);
	PlayerTextDrawFont(playerid, MissionInfo, 2);
	PlayerTextDrawLetterSize(playerid, MissionInfo, 0.2, 1.0);
	PlayerTextDrawColor(playerid, MissionInfo, -1);
	PlayerTextDrawSetOutline(playerid, MissionInfo, 1);
	PlayerTextDrawSetProportional(playerid, MissionInfo, 1);
}