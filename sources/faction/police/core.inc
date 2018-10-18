#if defined	FACTION_POLICE_CORE_INCLUDED
	#endinput
#endif
#define FACTION_POLICE_CORE_INCLUDED

#include "faction/police/header"

#include "faction/police/mission"	
#include "faction/police/pursuit"

Public: Police_OnPlayerDeath(playerid, killerid, reason)
{
	if(IsPlayerLogged(killerid))
	{
		if(reason != WEAPON_COLLISION)
		{
			if(PlayerInfo[killerid][pFaction] == F_POLICE)
			{
				if(CriminalDanger[playerid] == false)
				{	// Неправомерное убийство
					GivePoliceWarn(killerid, 180, "Неправомерное убийство");
					if(GetPlayerWantedLevel(playerid) > 0)
					{
						MySetPlayerWantedLevel(playerid, GetPlayerWantedLevel(playerid) - 1);
						ShowPlayerHint(playerid, "Вам был понижен уровень розыска за неправомерные действия полицейского.");
					}
				}
				else if(Police_GetPlayerMissionType(killerid) == 10 && Police_GetPlayerMissionPlace(killerid) == playerid)
				{	// Убит во время погони
					new string[128];
					SendFormatMessageToAll(COLOR_DBLUE, string, "[Госдепартамент]: %s {FFFFFF}%s[%d] {2641FE}обезвредил преступника {FFFFFF}%s[%d]", GetPlayerRank(killerid), ReturnPlayerName(killerid), killerid, ReturnPlayerName(playerid), playerid);
					StopPursuit(playerid, 5);
					//ShowWasted = false;
				}
				else
				{	// Убит вне рамках погони
				    PlayerInfo[playerid][pCopCases]++;
				}
			}
			else
			{
			    if(PlayerInfo[playerid][pFaction] == F_POLICE && GetPlayerWarGangZone(killerid) >= 0) { }
				else 
				{
					if(GetPVarInt(playerid, "Player:Attack:Attacker") == _:false)
					{
						CrimePlayer(killerid, CRIME_KILL);
					}
				}
			}
		}
	}

	PoliceMissionCancel(playerid, "quit");	// Обнуление полицейской миссии
	StopPursuit(playerid, 1);				// Очистка погони по причине смерти
	CopList_REMOVE(playerid);				// Удаление дежурства копа
	return CONTINUE;
}

//	IFace
Public: IFace.Wanted_Toggle(playerid, bool:toggle)
{
	if(toggle)
	{
		IFace.UpdatePlayerWanted(playerid);
		PlayerTextDrawShow(playerid, PTD_WantedLevel);
		PlayerTextDrawShow(playerid, PTD_WantedStatus);
	}
	else
	{
		PlayerTextDrawHide(playerid, PTD_WantedLevel);
		PlayerTextDrawHide(playerid, PTD_WantedStatus);
	}
}

IFace.UpdatePlayerWanted(playerid)
{
    if(PlayerInfo[playerid][pWantedLvl])
    {
    	new string[24];
		for(new i = 8 - PlayerInfo[playerid][pWantedLvl]; i > 0; i--)
		{
			strcat(string, "]");
		}
		strcat(string, "~w~");
		for(new i = PlayerInfo[playerid][pWantedLvl]; i > 0; i--)	
		{
			strcat(string, "]");
		}
		PlayerTextDrawSetString(playerid, PTD_WantedLevel, string);

    	if(isRus(playerid))
    	{
    		if(CriminalDanger[playerid])					string = "~r~СОПРОТИВЛЕНИЕ";
        	else if(PlayerInfo[playerid][pWantedLvl] < 4)	string = "~r~ШТРАФ";
			else											string = "~r~АРЕСТ";
    	}
       	else
       	{
       		if(CriminalDanger[playerid])					string = "~r~RESISTANCE";
        	else if(PlayerInfo[playerid][pWantedLvl] < 4)	string = "~r~FINE";
			else											string = "~r~ARREST";
       	}
        PlayerTextDrawSetString(playerid, PTD_WantedStatus, RusText(string, isRus(playerid)));
    }
}

//////////	Functions	//////////
public MySetPlayerWantedLevel(playerid, level)
{
	if(IsPlayerNPC(playerid)) return true;
	PlayerInfo[playerid][pWantedLvl] = level;
    if(level > 0)
    {
		if(PlayerInfo[playerid][pJailTime] > 0) 	return true;
		if(IsForce(PlayerInfo[playerid][pFaction])) return true;
        if(level > 8) level = 8;

		if(criminal_timer[playerid] == 0)
		    criminal_timer[playerid] = SetTimerEx("CriminalTimer", 1000, true, "i", playerid);
		WantedTime[playerid] = 20;// мин
		IFace.ToggleGroup(playerid, IFace.WANTED, true);
    }
    else
	{
        if(level < 0) level = 0;
		if(GetPlayerPursuit(playerid) > PS_NONE)			StopPursuit(playerid, 0);
		if(GetPVarInt(playerid, "Police:Pursuit:Handsup"))	PursuitHandsupClear(playerid);
	    if(criminal_timer[playerid] > 0)
	    {
		    KillTimer(criminal_timer[playerid]);
			FlashPoliceZone(playerid, false);
			DestroyCriminalMarker(playerid);
		    foreach(Cop, i)	MySetPlayerMarkerForPlayer(i, playerid, GetPlayerColor(playerid));
		    criminal_timer[playerid] = 0;
	   	}
		WantedTime[playerid] = 0;
		ToggleCriminalDanger(playerid, false);
		IFace.ToggleGroup(playerid, IFace.WANTED, false);
	}
	return true;
}

stock GivePlayerWantedLevel(playerid, level, maxlvl, reason[], show_again = true)
{// level - на сколько прибавляется; maxlvl - верхняя граница;
	if(level > 0 && !IsForce(PlayerInfo[playerid][pFaction]))
	{
		// Корректировка значений
		new oldlevel = GetPlayerWantedLevel(playerid), glevel = 0;
		if(!(1 <= maxlvl <= 8)) maxlvl = 8;	// Если максимальный не соответствует
		if(oldlevel < maxlvl) // Если старый меньше максимального
		{
			level = oldlevel + level;			// level становится значением нового розыска
			if(level > maxlvl) level = maxlvl;  // Если новый больше максимального
			MySetPlayerWantedLevel(playerid, level);
			glevel = level - oldlevel;
		}
		else if(show_again == 0)
		{
			return true;
		}
		// Звук радиопереговоров для копов

		new sound = GetZoneSound(GetPlayerZone(playerid));
        foreach(Cop, i)
        {
        	PlayerPlaySound(i, sound, 0, 0, 0);
        	PlayCrimeReportForPlayer(i, i, 3);
       	}	

		new string[128];
		PlayerPlaySound(playerid, sound, 0, 0, 0);
        PlayCrimeReportForPlayer(playerid, playerid, 3);
        
		format(string, sizeof(string), "[Розыск]: Вы совершили преступление: {FFFFFF}%s.", reason);
		SendClientMessage(playerid, COLOR_LIGHTRED, string);
        format(string, sizeof(string), "[R] Диспетчер HQ: {FFFFFF}%s - %s {8D8DFF}| Район: {FFFFFF}%s", ReturnPlayerName(playerid), reason, GetPlayerArea(playerid));
		SendPoliceMessage(COLOR_BLUE, string);
		return glevel;
	}
	return 0;
}

public CrimePlayer(playerid, crimeid)
{
	if(0 <= crimeid < sizeof(CrimesList))
	{
		if(GetPlayerWantedLevel(playerid) < CrimesList[crimeid][E_START_WL])
		{
			GivePlayerWantedLevel(playerid, CrimesList[crimeid][E_START_WL], CrimesList[crimeid][E_MAX_WL], CrimesList[crimeid][E_TITLE], CrimesList[crimeid][E_SHOW_AGAIN]);
		}
		else
		{
			GivePlayerWantedLevel(playerid, CrimesList[crimeid][E_WL], CrimesList[crimeid][E_MAX_WL], CrimesList[crimeid][E_TITLE], CrimesList[crimeid][E_SHOW_AGAIN]);
		}
	}
}

DestroyCriminalMarker(playerid)
{
	DestroyDynamicMapIcon(CriminalMarkers[playerid]), CriminalMarkers[playerid] = INVALID_STREAMER_ID;
}

Public: CriminalTimer(playerid)
{	// Подсветка преступников для полицейских
	if(GetPlayerWarGangZone(playerid) == -1 || GetPlayerPursuit(playerid) > 0)
	{
	    new Float:dist, vehicleid = GetPlayerVehicleID(playerid), cop_vmodel;
	    new Float:pos[3], Float:mapZ, Float:cop_pos[3], Float:cop_mapZ;

        GetPlayerPos(playerid, Arr3<pos>);
        MapAndreas_FindZ_For2DCoord(pos[0], pos[1], mapZ);

	    foreach(Cop, copid)
	    {
	        if(GetPlayerState(copid) == PLAYER_STATE_SPECTATING)	continue;

	        GetPlayerPos(copid, Arr3<cop_pos>);
	        MapAndreas_FindZ_For2DCoord(cop_pos[0], cop_pos[1], cop_mapZ);
			cop_vmodel = GetVehicleModel(GetPlayerVehicleID(copid));
	        if(vehicleid > 0 && GetVehicleSpeed(vehicleid) > 0)		dist += 100.0;		//	Игрок едет на машине
	        else 													dist += 35.0;		//	Игрок пешком
	        if(cop_vmodel == 497 && cop_pos[2] > cop_mapZ + 15.0)	dist = dist * 1.5;	//	Копы на вертолете
	        
			if(GetDistanceBetweenPlayers(playerid, copid, true) <= dist)
			{	// В зоне видимости
		        if(cop_vmodel == 497 && mapZ > pos[2])	continue;	//	если игрок под землей
	        	if(CriminalMarked[playerid] == 0)
				{	// Если не видели до этого, теперь видим
				    PlayCrimeReportForPlayer(playerid, playerid, 3);
					FlashPoliceZone(playerid, true);
			        CriminalMarkers[playerid] = CreateDynamicMapIconEx(Arr3<pos>, 0, 0xFF0000FF, MAPICON_GLOBAL, 10000.0);
				}
				new cops[MAX_PLAYERS] = { INVALID_PLAYER_ID, ... }, count = 0;
		        foreach(Cop, j)
				{
					MySetPlayerMarkerForPlayer(j, playerid, 0xFF0000FF, true);
					if(GetDistanceBetweenPlayers(playerid, j) > 290.0) cops[count++] = j;
				}
				Streamer_SetArrayData(STREAMER_TYPE_MAP_ICON, CriminalMarkers[playerid], E_STREAMER_PLAYER_ID, cops, count);
		        Streamer_SetFloatData(STREAMER_TYPE_MAP_ICON, CriminalMarkers[playerid], E_STREAMER_X, pos[0]);
		        Streamer_SetFloatData(STREAMER_TYPE_MAP_ICON, CriminalMarkers[playerid], E_STREAMER_Y, pos[1]);
		        Streamer_SetFloatData(STREAMER_TYPE_MAP_ICON, CriminalMarkers[playerid], E_STREAMER_Z, pos[2]);
				return true;
			}
		}
	}
	// Вне зоны видимости
    if(CriminalMarked[playerid])
    {	// Если видели до этого, теперь не видим
		FlashPoliceZone(playerid, false);
		DestroyCriminalMarker(playerid);
        foreach(Cop, copid)	MySetPlayerMarkerForPlayer(copid, playerid, (GetPlayerColor(playerid) & 0xFFFFFF00));
	}
	return true;
}

IFace.Wanted_Create_Player(playerid)
{
	PTD_WantedLevel = CreatePlayerTextDraw(playerid, 610.0, 100.0, "]]]]]]]]");
	PlayerTextDrawAlignment(playerid, PTD_WantedLevel, 3);
	PlayerTextDrawBackgroundColor(playerid, PTD_WantedLevel, 255);
	PlayerTextDrawFont(playerid, PTD_WantedLevel, 0);
	PlayerTextDrawLetterSize(playerid, PTD_WantedLevel, 0.43, 1.5);
	PlayerTextDrawColor(playerid, PTD_WantedLevel, 255);
	PlayerTextDrawSetOutline(playerid, PTD_WantedLevel, 0);
	PlayerTextDrawSetProportional(playerid, PTD_WantedLevel, 1);
	PlayerTextDrawSetShadow(playerid, PTD_WantedLevel, 1);

    PTD_WantedStatus = CreatePlayerTextDraw(playerid, 608.0, 115.0, "~r~COHPOTUBLEHUE");
	PlayerTextDrawAlignment(playerid, PTD_WantedStatus, 3);
	PlayerTextDrawBackgroundColor(playerid, PTD_WantedStatus, 255);
	PlayerTextDrawFont(playerid, PTD_WantedStatus, 1);
	PlayerTextDrawLetterSize(playerid, PTD_WantedStatus, 0.3, 1.0);
	PlayerTextDrawColor(playerid, PTD_WantedStatus, -1);
	PlayerTextDrawSetOutline(playerid, PTD_WantedStatus, 0);
	PlayerTextDrawSetProportional(playerid, PTD_WantedStatus, 1);
	PlayerTextDrawSetShadow(playerid, PTD_WantedStatus, 1);
}

stock SendPoliceMessage(color, string[])
{
	foreach(Cop, i)
		SendClientMessage(i, color, string);
	return true;
}

//////////	Commands	////////////
COMMAND:wanted(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] != F_POLICE)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете использовать эту команду.");
	}
	if(GetPlayerState(playerid) != 2 || IsCopCar(GetPlayerVehicleID(playerid)) == 0)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы можете использовать эту команду только за рулем полицейской машины.");
	}
	new string[1024] = "{FFFFFF}", count;
	foreach(Player, i)
	{
		if(GetPlayerWantedLevel(i) == 0)	continue;
		format(string, sizeof(string), "%s%s[%d] - %d ур. розыска\n", string, ReturnPlayerName(i), i, GetPlayerWantedLevel(i));
		count++;
	}
	if(count == 0)	format(string, sizeof(string), "%sСписок подозреваемых пуст.", string);
	MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "Список подозреваемых", string, "Закрыть", "");
	return true;
}

COMMAND:spike(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] != F_POLICE)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете использовать эту команду.");
	}
    if(GetPVarInt(playerid, "Police:Spikes"))	callcmd::dspike(playerid, "");
    if(MyApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0))
	{
		SetPVarInt(playerid, "Police:Spikes:Timer", SetTimerEx("SetPlayerSpike", 2000, false, "d", playerid));
	}
    return true;
}

Public: SetPlayerSpike(playerid)
{
	new Float:pos[4];
    GetPlayerPos(playerid, Arr3<pos>);
    GetPlayerFacingAngle(playerid, pos[3]);
	SetPVarInt(
		playerid,
		"Police:Spikes",
    	CreateDynamicObject(2899, pos[0], pos[1], pos[2] - 0.83, 0.0, 0.0, pos[3] + 90)
    );
    Streamer_Update(playerid);
    GameTextForPlayer(playerid, "~w~Spikes ~g~installed", 3000, 3);
	DeletePVar(playerid, "Police:Spikes:Timer");
    return true;
}

COMMAND:dspike(playerid, params[])
{
    if(GetPVarInt(playerid, "Police:Spikes") == 0)
    {
    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не устанавливали шипов.");
    }
    if(GetPVarInt(playerid, "Police:Spikes:Timer"))
    {
    	KillTimer(GetPVarInt(playerid, "Police:Spikes:Timer"));
    	DeletePVar(playerid, "Police:Spikes:Timer");
    }
    GameTextForPlayer(playerid, "~w~Spikes ~r~removed", 3000, 3);
	DestroyDynamicObject(GetPVarInt(playerid, "Police:Spikes"));
	DeletePVar(playerid, "Police:Spikes");
    return true;
}
