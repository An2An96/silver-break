#include "house/header"

Police_GetPlayerMissionType(playerid)
{
	return PM_Type[playerid];
}

Police_GetPlayerMissionPlace(playerid)
{
	return PM_Place[playerid];
}

stock PoliceMissionCreate(type = -1)
{
	new string[128];
	for(new x; x < sizeof(PoliceMission); x++)
	{
	    if(PoliceMission[x][pmNum] == 0)
	    {
		    PoliceMission[x][pmNum] = ++PoliceCallNum;
		    PoliceMission[x][pmType] = (type == -1) ? (random(3) + 1) : type;
		    PoliceMission[x][pmPlace] = random(MaxHouses);
		    PoliceMission[x][pmUNIX] = gettime() + 5 * 60;// 5 минут
		    format(string, 128, GetPointArea(HouseInfo[ PoliceMission[x][pmPlace] ][hX], HouseInfo[ PoliceMission[x][pmPlace] ][hY]));
			format(string, 128, "[R] Диспетчер HQ: {FFFFFF}Срочное сообщение, вызов #%d: прибыть по %s, %d {8D8DFF}(Подробнее: /hq)",
				PoliceMission[x][pmNum],
				string,
				HouseInfo[ PoliceMission[x][pmPlace] ][hID]);
			SendPoliceMessage(COLOR_BLUE, string);
			return true;
	    }
	}
	return false;
}

stock PoliceMissionRemove(mission)
{
	PoliceMission[mission][pmNum] = 0;
    for(new x = mission; x < sizeof(PoliceMission) - 1; x++)
    {
        if(PoliceMission[x + 1][pmNum] == 0) break;
        PoliceMission[x][pmNum] = PoliceMission[x+1][pmNum];
        PoliceMission[x][pmType] = PoliceMission[x+1][pmType];
        PoliceMission[x][pmPlace] = PoliceMission[x+1][pmPlace];
        PoliceMission[x][pmUNIX] = PoliceMission[x+1][pmUNIX];
		PoliceMission[x + 1][pmNum] = 0;
	}
}

PoliceMissionAccept(playerid, mission = -1)
{
    new bool:last;
    if(mission == -1)
    {
	    for(new x = sizeof(PoliceMission)-1; x >= 0; x--)
	    {
	        if(PoliceMission[x][pmNum] > 0)
	        {
	            mission = x;
	            last = true;
	            break;
	        }
		}
	}
	if(mission != -1 && PoliceMission[mission][pmNum] > 0)
	{
		if(!IsPoliceDuty(playerid))
		{
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не на дежурстве.");
		}
		if(PM_Type[playerid] > 0)
		{
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы выполняете задание, подробнее в /hq.");
		}
	    new string[128];
		if(last == true)
			SendFormatMessage(playerid, COLOR_BLUE, string, "[R] %s %s: {FFFFFF}Вас понял, 10-4, конец связи.", GetPlayerRank(playerid), ReturnPlayerName(playerid));
		else
			SendFormatMessage(playerid, COLOR_BLUE, string, "[R] %s %s: {FFFFFF}10-4 по вызову #%d, конец связи.", GetPlayerRank(playerid), ReturnPlayerName(playerid), PoliceMission[mission][pmNum]);
		// Фактический прием вызова
		PM_Step[playerid] = 0;
		PM_Type[playerid] = PoliceMission[mission][pmType];
		PM_Place[playerid] = PoliceMission[mission][pmPlace];
		PM_UNIX[playerid] = gettime()+5*60;// + 5 минут
	    new h = PoliceMission[mission][pmPlace];
		MySetPlayerCheckpoint(playerid, CPPOLICE_MISSION, HouseInfo[h][hX], HouseInfo[h][hY], HouseInfo[h][hZ], 2.0);
		PoliceMissionRemove(mission);
		PoliceMissionTimer(playerid);
		return 1;
	}
	return 0;
}

PoliceMissionComplete(playerid, amount, reason[] = "")
{
	new string[128] = "~g~Миссия выполнена";
    if(amount > 0)
    {
		//GivePlayerEXP(playerid, floatround(amount / 2));
		new bonus = 1 + (PlayerInfo[playerid][pRank]-1) * 15 / 100;
		Job.GivePlayerWage(playerid, amount * bonus);
        PlayerInfo[playerid][pCopCases] += 1;
	}
	if(strlen(reason)) format(string, 128, "%s~n~~w~%s", string, reason);
    GameTextForPlayer(playerid, RusText(string, isRus(playerid)), 5000, 4);
    PoliceMissionCancel(playerid, "quit"); // Обнуление миссии
}

PoliceMissionCancel(playerid, const reason[] = "")
{
	if(PM_Type[playerid] == 3)
	{// Поиск угнанного авто
	    new vehid = PM_Place[playerid];
	    MyDestroyVehicle(vehid);
	    MyCreateVehicle(GetRandomModel(), Arr4<VehInfo[vehid][vPos]>, -1, -1);
	    GangZoneDestroy(PM_SearchZone[playerid]);
		DestroyDynamicArea(PM_SearchZone2[playerid]);
		HideWorkInfo(playerid);
		//PlayerTextDrawHide(playerid, InWantedTD);
		//PlayerTextDrawHide(playerid, InWantedInfo);
	}
	else if(PM_Type[playerid] == 10)
	{	// Преследование преступника
	   Mission_CancelPursuit(playerid);
	}
	if(strcmp(reason,"quit",true))
	{
		new string[64];
		format(string, 64, "~r~Миссия провалена~n~~w~%s", reason);
	    GameTextForPlayer(playerid, RusText(string, isRus(playerid)), 5000, 4);
    }

	// Обнуление (строго в конце!)
    PM_Type[playerid] = 0;
    HidePlayerVisualTimer(playerid);
	HideMissionMessage(playerid);
	MyDisablePlayerCheckpoint(playerid);
}

Public: PoliceMissionTimer(playerid)
{
	if(PM_Type[playerid] > 0 && PM_UNIX[playerid] <= gettime())
	{
	    PoliceMissionCancel(playerid, "Время вышло");
	    return 1;
	}
    if(PM_Type[playerid] == 3 && PM_Step[playerid] == 1)
    {
	    new Float:X, Float:Y, Float:Z;
	    new vehid = PM_Place[playerid];
	    GetVehiclePos(vehid, X, Y, Z);
	    if(GetDistanceFromMeToPoint(playerid, X, Y, Z) < 25)
	    {
	        PM_Step[playerid] = 2;
		    MyDisablePlayerCheckpoint(playerid);
		    GangZoneDestroy(PM_SearchZone[playerid]);
		    DestroyDynamicArea(PM_SearchZone2[playerid]);
			HideWorkInfo(playerid);
			//PlayerTextDrawHide(playerid, InWantedTD);
			//PlayerTextDrawHide(playerid, InWantedInfo);
			MySetPlayerCheckpoint(playerid, CPPOLICE_MISSION, X, Y, Z, 5.0);
		    UpdateVehicleParamsEx(vehid, 1);
		    setVehicleAlarm(vehid, false);
	    }
    }
    if(PM_Type[playerid] > 0)
        SetTimerEx("PoliceMissionTimer", 1000, false, "d", playerid);
	return 1;
}

//////////	Dialogs 	//////////


//////////	Commands	//////////
COMMAND:hq(playerid, params[])
{	// HeadQuarters // Штаб-квартира
	if(PlayerInfo[playerid][pFaction] != F_POLICE)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете использовать эту команду.");
	}
	if(PM_Type[playerid] == 0 && (GetPlayerState(playerid) != 2 || IsCopCar(GetPlayerVehicleID(playerid)) == 0))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы можете использовать эту команду только за рулем полицейской машины.");
	}
	return ShowDialog(playerid, DMODE_POLICE_HQ);
}

flags:pmc(CMD_DEVELOPER);
COMMAND:pmc(playerid, params[])
{// [BT]
	new missionid;
	if(sscanf(params, "i", missionid))
		return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /pmc [number]");
	return PoliceMissionCreate(missionid);
}