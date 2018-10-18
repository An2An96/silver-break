#include "faction/header"

#include "faction/police/core"
#include "faction/gang/core"
#include "faction/commands"

stock SetPlayerFaction(playerid, faction, rank = 1)
{
	// Нормировка ранга
	if(rank < 1 || rank > GetRankMax(faction)) rank = 1;

	//--- Проверка лидерства ---//
	if(0 < faction < sizeof(FactionRankMax) && rank == FactionRankMax[faction])
	{
	    PlayerInfo[playerid][pLeader] = gettime();
	    #if defined _system_ucp_news_included
			PushNews(playerid, NEWS_TYPE_LEADERSHIP, faction);
		#endif
	}
	else
	{
	    PlayerInfo[playerid][pLeader] = 0;
	}

	//--- Если фракция не менялась ---//
	if(PlayerInfo[playerid][pFaction] == faction)
	{
		PlayerInfo[playerid][pRank] = rank;
		UpdatePlayerSkin(playerid);
		UpdatePlayerStatics(playerid);
		return 1;
	}

	//--- Откат привелегий ---//
    if(PlayerInfo[playerid][pFaction] == F_POLICE)
    {// Если бывшая фракция Полиция

		// Убрать подсведку преступников
        foreach(Player, i) MySetPlayerMarkerForPlayer(playerid, i, GetPlayerColor(i));

        DeletePlayerAcsr(playerid, ACSR_HAT);
	    PoliceMissionCancel(playerid, "quit");
	    MySetPlayerArmour(playerid, 0.0);
	    MyResetPlayerWeapons(playerid);
		CopList_REMOVE(playerid);
    }
    else if(IsGang(PlayerInfo[playerid][pFaction]))
    {
        ClearPlayerWarGangZone(playerid);
	    HideMissionInfo(playerid);
    }

    //--- Изменение фракции ---//
    if(faction == F_NONE)
    {   // Вышел из фракции
		PlayerInfo[playerid][pFaction] = 0;
		PlayerInfo[playerid][pRank] = 0;
    }
    else
    {	// Вступил во фракцию
	    new string[128];
		mysql_format(g_SQL, string, sizeof(string), "UPDATE `players` SET `teamunix` = '%d' WHERE `id` = '%d'", gettime(), PlayerInfo[playerid][pUserID]);
		mysql_query_ex(string);

		PlayerInfo[playerid][pFaction] = faction;
		PlayerInfo[playerid][pSpawn] = SPAWN_FACTION;
		PlayerInfo[playerid][pRank] = rank;

		// Сбросить работу, если она не разрешена
	    if(!IsAvailableJob(playerid, Job.GetPlayerJob(playerid)))
		{
			Job.SetPlayerJob(playerid, JOB_NONE);
		}

		if(faction == F_POLICE)
		{
			MySetPlayerWantedLevel(playerid, 0);
		}

		#if defined _system_ucp_news_included
			PushNews(playerid, NEWS_TYPE_MEMBERSHIP, faction);
		#endif
    }
    UpdatePlayerSkin(playerid);

    // Запрет огня по своим для некоторых фракций
    if(IsGang(faction) || IsMafia(faction))	SetPlayerTeam(playerid, faction);
    else if(faction == F_POLICE)			SetPlayerTeam(playerid, F_POLICE);
    else 									SetPlayerTeam(playerid, NO_TEAM);

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid && CarInfo[vehicleid][cType] == C_TYPE_FACTION && !IsAvailableVehicle(vehicleid, playerid))
    {
    	RemovePlayerFromVehicle(playerid);
    }
	UpdatePlayerColor(playerid);
  	UpdatePlayerGraffitiCP(playerid);
  	UpdateGangZone(-1, playerid);
	UpdatePlayerStatics(playerid);
	return false;
}

stock IsForce(faction)
{// Сотрудники органов, которые не могут получить розыск
	if(0 < faction < sizeof(Faction))
	{
	    switch(Faction[faction][F_ID])
	    {
       		case F_POLICE, F_FBI: return true;
	    }
	}
	return false;
}

stock IsGover(faction)
{
	if(0 < faction < sizeof(Faction))
	{
	    switch(Faction[faction][F_ID])
	    {
       		case F_POLICE, F_FBI, F_ARMY, F_EMERGY, F_MAYOR: return true;
	    }
	}
	return false;
}

stock IsMafia(faction)
{
	if(0 < faction < sizeof(Faction))
	{
	    switch(Faction[faction][F_ID])
	    {
	        case F_RUSMAF, F_LCN, F_YAKUZA: return true;
	    }
	}
	return false;
}

stock IsAvailableJob(playerid, jobid)
{
	if(PlayerInfo[playerid][pFaction] == 0) return true;
	else if(!IsLegalJob(jobid) && (IsMafia(PlayerInfo[playerid][pFaction]) || IsGang(PlayerInfo[playerid][pFaction]))) return true;
	return false;
}

stock GetFactionName(faction)
{
	new fname[32] = "Unknown";
	if(0 < faction < sizeof(Faction))
	{
	    strput(fname, Faction[faction][F_NAME]);
	}
	return fname;
}

stock IsPlayerLeader(playerid)
{
	if(0 < PlayerInfo[playerid][pFaction] < sizeof(Faction))
	{
	    //if(PlayerInfo[playerid][pRank] == FactionRankMax[PlayerInfo[playerid][pFaction]])
	    if(PlayerInfo[playerid][pLeader] > 0)
	        return PlayerInfo[playerid][pFaction];
	}
	return false;
}

stock GetRankName(faction, rank)
{
	new rname[32] = "Unknown";
	if(0 < faction < sizeof(Faction))
	{
	    if(1 <= rank <= FactionRankMax[faction])
	    {
            strput(rname, FactionRank[faction][rank-1]);
	    }
	}
	return rname;
}

stock GetRankMax(faction)
{
	if(0 < faction < sizeof(Faction)) return FactionRankMax[faction];
	return 0;
}

stock SendFactionMessage(faction, color, const string[])
{
	foreach(LoginPlayer, i)
		if(PlayerInfo[i][pFaction] == faction)
			SendClientMessage(i, color, string);
	return true;
}