#if defined _gang_gang_zones_included
  #endinput
#endif

#define _gang_gang_zones_included

#define GZ_WAIT_TIME    		600		// Время захвата зоны (сек)
#define GZ_WAR_TIME     		600		// Время захвата зоны (сек)
#define GANGZONE_PROFIT			25.0 	// Количество денег с одной территории участнику банды

new GangZoneID[sizeof(GangZones)],
	GangZoneNum[sizeof(GangZones)],         // Идентификатор ганг зоны
	GangZoneTime[sizeof(GangZones)],        // Счетчик времени для захвата
	GangZoneStatus[sizeof(GangZones)],		// 0 - waiting, 1 - in war
	GangZoneOwner[sizeof(GangZones)],       // Владелец зоны
	GangZoneEnemy[sizeof(GangZones)],		// Нападающие (больше 0 - война)
	GangZoneOwKill[sizeof(GangZones)],      // Счетчик убийств владельцами
	GangZoneEnKill[sizeof(GangZones)],      // Счетчик убийств нападающими
	GangZoneTimer[sizeof(GangZones)],       // Таймер захвата
	GangZoneMapIcon[sizeof(GangZones)];

new GangWarKills[MAX_PLAYERS],
	GangWarDeath[MAX_PLAYERS],
	GangZoneLeaving[MAX_PLAYERS],
	InGangZone[MAX_PLAYERS];        // Идентификатор zoneid (по умолчанию -1)

new GraffitiCP[sizeof(Graffiti)];

static
	GraffitiNum[sizeof(Graffiti)],
	GangRescue[sizeof(Faction)] = {0,...},		// 	Время восстановления (только для банд)
	GangBaseZone[sizeof(Faction)];				//  Номер зоны, которая считается базой

Public: Gang.GZ_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if((PRESSED(KEY_FIRE) || PRESSED(KEY_SECONDARY_ATTACK | KEY_HANDBRAKE)))
	{
		if(GetPlayerComb(playerid) == COMB_NONE && playerBenchUsed{playerid} == 0 && gPlayerRing[playerid] == (-1)
		&& playerSmokeCount{playerid} == 0)
		{
			if(InGangZone[playerid] >= 0 && GangZoneStatus[InGangZone[playerid]] == 0)
			{
				new zone = InGangZone[playerid];
			    if(PlayerInfo[playerid][pFaction] == GangZoneOwner[zone] || PlayerInfo[playerid][pFaction] == GangZoneEnemy[zone])
			    {
			        if(!(22 <= GetPlayerWeapon(playerid) <= 33))
			        {
						BlockPlayerAggression(playerid);
						ShowPlayerHint(playerid, "Во время ожидания~n~нападение ~r~запрещено");
					}
					return true;
			    }
			}
		}
	}

	if(PRESSED(KEY_FIRE))
    {
    	// Рисование граффити
        new weaponid = GetPlayerWeapon(playerid);
		if(weaponid == 41 && IsGang(PlayerInfo[playerid][pFaction]) && IsPlayerInGetto(playerid))
        {
            new zone = GetPlayerGangZone(playerid);
            if(zone != -1)
            {
	            new Float:ang, Float:Fault = 45.0;
	            GetPlayerFacingAngle(playerid, ang);
				for(new g = 0; g < sizeof(Graffiti); g++)
				{
					if(IsPlayerInRangeOfPoint(playerid, 3.0, Graffiti[g][0], Graffiti[g][1], Graffiti[g][2] - 0.4) && floatdif(Graffiti[g][3] + 270, ang) < Fault)
					{

						//--- Антифлуд
						new tick = GetTickCount();
						if(tick - StartupAntiflood[playerid] < 500)
						{
						    StartupAntiflood[playerid] = tick;
						    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Не так быстро.");
						    return false;
						}
						StartupAntiflood[playerid] = tick;
						//-------------

			            if(PlayerInfo[playerid][pRank] == 1)
			                return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас слишком низкий ранг для нападения на территорию.");
					    new const owner = GangZoneOwner[zone];
		                if(owner > 0)
		                {
		                	new string[128];
				            if(owner == PlayerInfo[playerid][pFaction])
				                return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете напасть на свою же территорию.");
			                if(GangZoneEnemy[zone] > 0)
			                    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете напасть на эту зону, за нее уже идет война.");
							if(GangBaseZone[owner] == zone && getGangZoneCount(owner) > 1)
			                    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете напасть на главную территорию банды, пока есть другие.");
			                new hour, nowtime = gettime(hour, _, _);
							if((10 <= hour <= 23) == false)
							{
			    				return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Нападения на зоны происходят с 10:00 до 23:00.");
							}
			                if(GangRescue[PlayerInfo[playerid][pFaction]] > nowtime)
			                {
			                    SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "Ваша банда еще не восстановилась после поражения, осталось: %d мин.", 1 + floatround(float(GangRescue[PlayerInfo[playerid][pFaction]] - nowtime) / 60));
			                    return true;
			                }
			                for(new z; z < sizeof(GangZones); z++)
			                {
			                    if(GangZoneEnemy[z] > 0 && (GangZoneOwner[z] == owner || GangZoneEnemy[z] == owner))
			                        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Владельцы этой территории уже участвуют в войне в данный момент.");
			                }
			                new owners, enemies;
							foreach(LoginPlayer, i)
							{
				                if(PlayerInfo[i][pFaction] == owner && IsPlayerAFK(i) == false) 							owners++;
				                if(PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction] && IsPlayerAFK(i) == false)	enemies++;
							}
							if(enemies < 2)
							{
							    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Требуется как минимум 2 игрока онлайн из вашей банды.");
							    return true;
							}
							if(owners < 2)
							{
							    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Требуется как минимум 2 игрока онлайн во вражеской банде.");
							    return true;
							}
			                if(GangRescue[owner] > nowtime)
			                {
			                    SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "Вражеская банда еще не восстановилась после поражения, осталось: %d мин.", 1 + floatround(float(GangRescue[owner] - nowtime) / 60));
			                    return true;
			                }
		                }
		                new wdata[2];
		                GetPlayerWeaponData(playerid, 9, wdata[0], wdata[1]);
		                SetPVarInt(playerid, "SprayCount", wdata[1]);
						graffiti_timer[playerid] = SetTimerEx("MakePlayerGraffiti", 3000, 0, "ii", playerid, g);
						GameTextForPlayer(playerid, "Painting...", 5000, 3);
						return true;
					}
				}
			}
        }
    }

    return CONTINUE;
}

Public: Gang.GZ_OnPlayerDeath(playerid, killerid, reason)
{
	if(IsPlayerLogged(killerid))
	{
		if(reason != WEAPON_COLLISION)
		{
			if(IsGang(PlayerInfo[killerid][pFaction]) && IsGang(PlayerInfo[playerid][pFaction]))
			{
			    if(PlayerInfo[killerid][pFaction] != PlayerInfo[playerid][pFaction])
			    {
					if(InGangZone[playerid] >= 0)
					{	// Война банд за территории
					    new zone = InGangZone[playerid];
						if(InGangZone[killerid] == zone && GangZoneStatus[zone] == 1)
						{
						    if(GangZoneOwner[zone] == PlayerInfo[killerid][pFaction])
						    {
						        GangZoneOwKill[zone] += 1;
						    }
						    else if(GangZoneEnemy[zone] == PlayerInfo[killerid][pFaction])
						    {
						        GangZoneEnKill[zone] += 1;
						    }
						    new string[32];
						    format(string, sizeof(string), "%d", GangZoneOwKill[zone]);
						    TextDrawSetString(GangZoneTextDraw[zone][4], string);
						    format(string, sizeof(string), "%d", GangZoneEnKill[zone]);
						    TextDrawSetString(GangZoneTextDraw[zone][5], string);

							GangWarKills[killerid]++;
							GangWarDeath[playerid]++;
						}
					}
				}
			}
		}
	}

	return CONTINUE;
}

Public: Gang.GZ_OnPlayerPause(playerid, pausestate)
{
	if(pausestate)
	{	//  Вошел в АФК
		if(IsGang(PlayerInfo[playerid][pFaction]) && InGangZone[playerid] >= 0)
		{
		    new zone = InGangZone[playerid];
		    if(GangZoneStatus[zone] != 0)
		    {
		    	if(GangZoneEnemy[zone] == PlayerInfo[playerid][pFaction])		GangZoneOwKill[zone]++;
				else if(GangZoneOwner[zone] == PlayerInfo[playerid][pFaction])	GangZoneEnKill[zone]++;
				GangWarDeath[playerid]++;
				
				new string[32];
				format(string, sizeof(string), "%d", GangZoneOwKill[zone]);
			    TextDrawSetString(GangZoneTextDraw[zone][4], string);
			    format(string, sizeof(string), "%d", GangZoneEnKill[zone]);
			    TextDrawSetString(GangZoneTextDraw[zone][5], string);
			    format(string, sizeof(string), "[Gang Zone]: Противникам добавлено очко за уход %s в АФК.", ReturnPlayerName(playerid));
			    SendFactionMessage(PlayerInfo[playerid][pFaction], COLOR_LIGHTRED, string);
		    }
		}
	}

	return CONTINUE;
}

//////////	Functions 	//////////
stock GetPlayerWarGangZone(playerid)
{
	return InGangZone[playerid];
}

stock ClearPlayerWarGangZone(playerid)
{
	if(InGangZone[playerid] >= 0)
	{
		Streamer_RemoveArrayData(STREAMER_TYPE_MAP_ICON, GangZoneMapIcon[ InGangZone[playerid] ], E_STREAMER_PLAYER_ID, playerid);
		HideGangZoneTextDraw(playerid, InGangZone[playerid]);
		InGangZone[playerid] = -1;
	}
}

stock getGangZoneCount(gangid)
{
	if(!IsGang(gangid)) return 0;

	new count = 0;
	for(new x = 0; x < sizeof(GangZones); x++)
	{
	    if(GangZoneOwner[x] == gangid) count++;
	}
	return count;
}

stock GetGangZone(Float:X, Float:Y, Float:Z)
{
	for(new x; x < sizeof(GangZones); x++)
	{
		if(GangZones[x][2] >= X >= GangZones[x][0] && GangZones[x][3] >= Y >= GangZones[x][1] && Z < 530.0)
		    return x;
	}
	return -1;
}

stock GetPlayerGangZone(playerid)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	return GetGangZone(X, Y, Z);
}

stock UpdatePlayerGraffitiCP(playerid)
{
/*
	Функция открывает для игрока доступные ЧП на вражеских граффити.
	И закрывает для игрока недоступные ЧП на своих граффити.
	По результатам войны за территорию требуется обновлять всем участникам банды.
*/
    if(IsGang(PlayerInfo[playerid][pFaction]))
    {
		for(new zone, g = 0; g < sizeof(Graffiti); g++)
		{
		    zone = GetGangZone(Arr3<Graffiti[g]>);
		    if(zone != -1 && PlayerInfo[playerid][pFaction] == GangZoneOwner[zone])
				TogglePlayerDynamicCP(playerid, GraffitiCP[g], false);
		    else
				TogglePlayerDynamicCP(playerid, GraffitiCP[g], true);
		}
	}
	else
	    for(new g = 0; g < sizeof(Graffiti); g++)
			TogglePlayerDynamicCP(playerid, GraffitiCP[g], false);
	return true;
}

stock UpdateGangZone(zone = -1, playerid = -1)
{
	if(zone == -1 && playerid == -1) return;

	if(zone == -1)
	{
		for(zone = 0; zone < sizeof(GangZones); zone++)
		{
			UpdateGangZone(zone, playerid);
		}
	}
	else
	{
		if(playerid == -1)
		{
			foreach(LoginPlayer, i)
			{
				UpdateGangZone(zone, i);
			}
		}
		else
		{
			if(/*IsGang(PlayerInfo[playerid][pFaction])*/PlayerInfo[playerid][pToggleZone])
			{
				GangZoneShowForPlayer(playerid, GangZoneNum[zone], GetGangColor(GangZoneOwner[zone]));
				if(GangZoneEnemy[zone] > 0)	GangZoneFlashForPlayer(playerid, GangZoneNum[zone], GetGangColor(GangZoneEnemy[zone]));
			}
			else
			{
				GangZoneHideForPlayer(playerid, GangZoneNum[zone]);
			}
		}
	}
}

GangZone_Load()
{
	new MaxFreeGZ;
	new query[256];
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `gang_zones`");
	new Cache:result = mysql_query(g_SQL, query);

	new Float:x, Float:y;
	for(new i = 0; i < cache_num_rows(); i++)
	{
		if(i >= MAX_WAR_GANG_ZONES)
		{
			break;
		}
		cache_get_value_name_int(i, "id", 			GangZoneID[i]);
		cache_get_value_name_int(i, "owner", 		GangZoneOwner[i]);
		cache_get_value_name_float(i, "min_x", 		GangZones[i][0]);
		cache_get_value_name_float(i, "min_y", 		GangZones[i][1]);
		cache_get_value_name_float(i, "max_x", 		GangZones[i][2]);
		cache_get_value_name_float(i, "max_y", 		GangZones[i][3]);

		cache_get_value_name_float(i, "graffiti_x",	Graffiti[i][0]);
		cache_get_value_name_float(i, "graffiti_y",	Graffiti[i][1]);
		cache_get_value_name_float(i, "graffiti_z",	Graffiti[i][2]);
		cache_get_value_name_float(i, "graffiti_a",	Graffiti[i][3]);

		GangZoneNum[i] = GangZoneCreate(Arr4<GangZones[i]>);
		if(GangZoneOwner[i] == 0)	MaxFreeGZ++;
		else						GraffitiUpdate(i);

		x = Graffiti[i][0] + (0.9 * floatsin(-Graffiti[i][3] - 90, degrees));
		y = Graffiti[i][1] + (0.9 * floatcos(-Graffiti[i][3] - 90, degrees));
		GraffitiCP[i] = CreateDynamicCP(x, y, Graffiti[i][2], 2.0, 0);
	}
	cache_delete(result);

	printf("  Gangzones occupied: %d/%d.", sizeof(GangZones) - MaxFreeGZ, sizeof(GangZones));

	//  Базы банд
	GangBaseZone[F_GROVE]	= GetGangZone(2492.1, -1686.2, 13.5);
	GangBaseZone[F_BALLAS]	= GetGangZone(1990.9, -1118.6, 26.7);
	GangBaseZone[F_VAGOS]	= GetGangZone(2805.4, -1177.7, 25.4);
	GangBaseZone[F_AZTECAS]	= GetGangZone(1781.3, -2101.5, 14.0);
	GangBaseZone[F_RIFA]	= GetGangZone(2153.5, -1794.0, 13.5);

	/*new cntr;
	for(new i = 0; i < sizeof(Graffiti); i++)
	{
		for(new j = 0; j < sizeof(GangZones); j++)
		{
			if(IsCoordInSquare(Graffiti[i][0], Graffiti[i][1], Arr4<GangZones[j]>))
			{
				mysql_format(g_SQL, query, sizeof query, "UPDATE `gang_zones` SET `graffiti_x` = '%f', `graffiti_y` = '%f', `graffiti_z` = '%f', `graffiti_a` = '%f' WHERE `id` = '%d'", Arr4<Graffiti[i]>, GangZoneID[j]);
				mysql_query_ex(query);
				cntr++;
			}
		}
	}
	printf("  Save graffiti: %d", cntr);*/

}

GangZone_Update(gz = -1)
{
	if(gz == -1)
	{

	}
	else
	{
		new query[128];
		mysql_format(g_SQL, query, sizeof query, "UPDATE `gang_zones` SET `owner` = '%d' WHERE `id` = '%d'", GangZoneOwner[gz], GangZoneID[gz]);
		mysql_query_ex(query);
	}
}

Public: MakePlayerGraffiti(playerid, g)
{
	graffiti_timer[playerid] = 0;
	if(IsGang(PlayerInfo[playerid][pFaction]) && GetPlayerWeapon(playerid) == 41
	&& IsPlayerInRangeOfPoint(playerid, 3.0, Graffiti[g][0], Graffiti[g][1], Graffiti[g][2]))
	{
        new zone = GetPlayerGangZone(playerid);
        if(zone == -1) return true;
		new enemy = PlayerInfo[playerid][pFaction];
        if(GangZoneOwner[zone] == enemy) return true;

        new string[128];
        if(GangZoneOwner[zone] == 0)
        {
			GangZoneOwner[zone] = enemy;
			UpdateGangZone(zone);
            GraffitiUpdate(zone);
			GangZone_Update(zone);
			format(string, 128, "[Gang Zone]: Банда %s захватывает нейтральную территорию", GetFactionName(enemy));
			SendGangMessageToAll(GetGangColor(enemy), string);

			// Graffiti update
			foreach(LoginPlayer, i)
			    if(IsGang(PlayerInfo[i][pFaction]))
			        UpdatePlayerGraffitiCP(i);
        }
        else
        {
			if(GangZoneEnemy[zone] > 0)
			    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "За эту территорию уже идет война.");

			new owner = GangZoneOwner[zone],
				Float:MinX = GangZones[zone][0],
				Float:MinY = GangZones[zone][1],
				Float:MaxX = GangZones[zone][2],
				Float:MaxY = GangZones[zone][3];

			GangZoneEnemy[zone] = enemy;
	    	GangZoneTime[zone] = GZ_WAIT_TIME;
	    	GangZoneStatus[zone] = 0;// waiting
	    	DestroyDynamicObject(GraffitiNum[g]);
			GraffitiNum[g] = CreateDynamicObject(GetGangGraffiti(g), Graffiti[g][0], Graffiti[g][1], Graffiti[g][2], 0.0,0.0, Graffiti[g][3], 0);
			GangZoneMapIcon[zone] = CreateDynamicMapIcon((MinX+MaxX)/2, (MinY+MaxY)/2, 0.0, 19, 0, -1, -1, 999, 3000.0, MAPICON_GLOBAL);
			UpdateGangZone(zone);
			GraffitiUpdate(zone);
			format(string, 128, "[Gang Zone]: %s забивает стрелку банде %s", GetFactionName(enemy), GetFactionName(owner));
			SendGangMessageToAll(GetGangColor(enemy), string);

			CreateGangZoneTextDraw(zone);
			TextDrawColor(GangZoneTextDraw[zone][2], GetGangColor(owner));
			TextDrawColor(GangZoneTextDraw[zone][4], GetGangColor(owner));
		    TextDrawSetString(GangZoneTextDraw[zone][2], GetFactionName(owner));
			TextDrawColor(GangZoneTextDraw[zone][3], GetGangColor(enemy));
			TextDrawColor(GangZoneTextDraw[zone][5], GetGangColor(enemy));
		    TextDrawSetString(GangZoneTextDraw[zone][3], GetFactionName(enemy));

		    foreach(LoginPlayer, i)
		    {
		        if(PlayerInfo[i][pFaction] == owner || PlayerInfo[i][pFaction] == enemy)
		        {
					GangWarKills[i] = 0;
					GangWarDeath[i] = 0;
					Streamer_AppendArrayData(STREAMER_TYPE_MAP_ICON, GangZoneMapIcon[zone], E_STREAMER_PLAYER_ID, i);
					Streamer_Update(i, STREAMER_TYPE_MAP_ICON);
		            PlayerPlaySound(i, 1058, 0.0, 0.0, 0.0);
			        //ShowMissionInfo(i, "Отправляйтесь на захват! ~r~(Красный Флаг - 10:00)");
		        }
		    }

			GangZoneTimer[zone] = SetTimerEx("GangZoneWar", 1000, true, "i", zone);
		}
		GameTextForPlayer(playerid, "Graffiti Done!", 3000, 3);
		PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);

		// Трата балончика
		new wdata[3];
		GetPlayerWeaponData(playerid, 9, wdata[0], wdata[1]);
		wdata[2] = GetPVarInt(playerid, "SprayCount");
		if(wdata[0] == 41 && wdata[2] >= wdata[1] && wdata[2] - wdata[1] < 170)
		{
			wdata[1] -= 170 - (wdata[2] - wdata[1]);
			if(wdata[1] < 0)	wdata[1] = 0;
			MySetPlayerWeapon(playerid, 41, wdata[1]);
		}
		DeletePVar(playerid, "SprayCount");
	}
	return true;
}

stock StopGangWar(zone, winer, loser)
{
	new string[128];

	// Обновление и сохранение переменных
	GangZoneOwner[zone] = winer;
	GangZoneEnemy[zone] = 0;
    GangZoneOwKill[zone] = 0;
    GangZoneEnKill[zone] = 0;
	GangZone_Update(zone);

	// Обновление миганий и раскрасок
	GangZoneStopFlashForAll(GangZoneNum[zone]);
	UpdateGangZone(zone);
	GraffitiUpdate(zone);

	// Уведомление и восстановление
	GangRescue[loser] = gettime() + RESCUE_TIME * 60;
	SendFactionMessage(winer, GetGangColor(winer), "[Gang Zone]: Ваша банда одержала победу в битве за территорию");
	SendFactionMessage(loser, GetGangColor(loser), "[Gang Zone]: Ваша банда потерпела поражение в битве за территорию");

	foreach(LoginPlayer, i)
	{
	    if(PlayerInfo[i][pFaction] != winer && PlayerInfo[i][pFaction] != loser) continue;
	    if(GangWarKills[i] != 0 || GangWarDeath[i] != 0)
	    {
	        format(string, 128, "[Gang Zone]: Ваша статистика войны: Убийств [%d], Смертей [%d]", GangWarKills[i], GangWarDeath[i]);
	        SendClientMessage(i, GetGangColor(PlayerInfo[i][pFaction]), string);
	    }
	    InGangZone[i] = -1;
	    HideMissionInfo(i);
	    HideGangZoneTextDraw(i, zone);
		UpdatePlayerGraffitiCP(i); // Graffiti update
		//Streamer_RemoveArrayData(STREAMER_TYPE_MAP_ICON, GangZoneMapIcon[zone], E_STREAMER_PLAYER_ID, playerid);
	}

	// Удаление общих элементов захвата
	DestroyGangZoneTextDraw(zone);
	KillTimer(GangZoneTimer[zone]), GangZoneTimer[zone] = 0;
	DestroyDynamicMapIcon(GangZoneMapIcon[zone]), GangZoneMapIcon[zone] = INVALID_STREAMER_ID;
}

Public: GangZoneWar(zone)
{
	new string[128], misname[128],
		owners, enemyes, time = GangZoneTime[zone],
    	Float:MinX = GangZones[zone][0],
		Float:MinY = GangZones[zone][1],
		Float:MaxX = GangZones[zone][2],
		Float:MaxY = GangZones[zone][3];

	GangZoneTime[zone] -= 1; // Отсчет

	// Обновление времени
	if(time < 30) string = "~r~"; else string = "~w~";
    format(string, 32, "%s%02d:%02d",string,time/60,time%60);
    TextDrawSetString(GangZoneTextDraw[zone][6], string);
    format(misname, sizeof(misname), "Отправляйтесь на захват! ~r~(Красный Флаг - %02d:%02d)", time/60,time%60);

	//------------ waiting -----------
    if(GangZoneStatus[zone] == 0)
    {
		if(GangZoneTime[zone] <= 0)// Переход на войну
		{
			foreach(LoginPlayer, i)
			{
		        if(InGangZone[i] != zone || IsPlayerAFK(i) == true)     continue;
			    if(PlayerInfo[i][pFaction] == GangZoneOwner[zone])		owners++;
			    else if(PlayerInfo[i][pFaction] == GangZoneEnemy[zone])	enemyes++;
	            PlayerPlaySound(i, 1058, 0.0, 0.0, 0.0);
			}
			if(enemyes < 1)
			{
				format(string, 128, "[Gang Zone]: %s испугались нападать на территорию банды %s", GetFactionName(GangZoneEnemy[zone]), GetFactionName(GangZoneOwner[zone]));
				SendGangMessageToAll(GetGangColor(GangZoneEnemy[zone]), string);
				StopGangWar(zone, GangZoneOwner[zone], GangZoneEnemy[zone]); // Территория остается
			}
			else if(owners < 1)
			{
				format(string, 128, "[Gang Zone]: %s не дождались и забрали территорию у бедных %s", GetFactionName(GangZoneEnemy[zone]), GetFactionName(GangZoneOwner[zone]));
				SendGangMessageToAll(GetGangColor(GangZoneEnemy[zone]), string);
				StopGangWar(zone, GangZoneEnemy[zone], GangZoneOwner[zone]); // Территория переходит
			}
			else
			{
			    GangZoneStatus[zone] = 1; // in war
			    GangZoneTime[zone] = GZ_WAR_TIME;
				TextDrawSetString(GangZoneTextDraw[zone][1], "~r~in war");
				SendFactionMessage(GangZoneOwner[zone], GetGangColor(GangZoneOwner[zone]), "[Gang Zone]: Война за вашу территорию началась! Вы оборонятесь!");
				SendFactionMessage(GangZoneEnemy[zone], GetGangColor(GangZoneEnemy[zone]), "[Gang Zone]: Война за чужую территорию началась! Вы нападаете!");
			}
		}
		else 	// Ожидание войны
		{
			foreach(LoginPlayer, i)
			{
			    if(PlayerInfo[i][pFaction] != GangZoneOwner[zone] && PlayerInfo[i][pFaction] != GangZoneEnemy[zone]) continue;
				if(IsPlayerInSquare(i, MinX, MinY, MaxX, MaxY))
				{
				    if(InGangZone[i] == -1)
					{
						InGangZone[i] = zone;
						ShowGangZoneTextDraw(i, zone);
						HideMissionInfo(i);
					}
				}
				else
				{
				    if(InGangZone[i] == zone)
					{
						InGangZone[i] = -1;
						HideGangZoneTextDraw(i, zone);
					}
			        ShowMissionInfo(i, misname);
				}
			}
		}
    }
	//------------ in war -----------
    else if(GangZoneStatus[zone] == 1)
    {
		foreach(LoginPlayer, i)
		{
		    if(PlayerInfo[i][pFaction] != GangZoneOwner[zone] && PlayerInfo[i][pFaction] != GangZoneEnemy[zone]) continue;
			if(IsPlayerInSquare(i, MinX, MinY, MaxX, MaxY))
			{
			    if(InGangZone[i] == -1)
				{
					InGangZone[i] = zone;
					ShowGangZoneTextDraw(i, zone);
					HideMissionInfo(i);
				}
				if(GangZoneLeaving[i] > 0)
				{
					GangZoneLeaving[i] = 0;
					GameTextForPlayer(i, " ", 1000, 4);
				}
			}
			else
			{
		        if(InGangZone[i] == zone)
		        {
		            if(GangZoneLeaving[i] == 0) GangZoneLeaving[i] = 10;
		            if(GangZoneLeaving[i] > 0 && IsPlayerAFK(i) == false)
		            {
		                if(--GangZoneLeaving[i] == 0)
		                {
					        InGangZone[i] = -1;
					        HideGangZoneTextDraw(i, zone);
					        ShowMissionInfo(i, misname);
					        continue;
		                }
		                else
		                {
		                    format(string, 128, RusText("~r~Вернитесь!~n~~w~%d sec", isRus(i)), GangZoneLeaving[i]);
							GameTextForPlayer(i, string, 2000, 4);
		                }
		            }
		        }
		        else
				{
					ShowMissionInfo(i, misname);
					continue;
				}
			}
		    if(PlayerInfo[i][pFaction] == GangZoneOwner[zone]) owners++;
		    else if(PlayerInfo[i][pFaction] == GangZoneEnemy[zone]) enemyes++;
		}
	    if(enemyes == 0)
	    {	// Нападающие сбежали
			format(string, 128, "[Gang Zone]: %s убегают с захвата, оставляя территорию у банды %s", GetFactionName(GangZoneEnemy[zone]), GetFactionName(GangZoneOwner[zone]));
			SendGangMessageToAll(GetGangColor(GangZoneEnemy[zone]), string);
			StopGangWar(zone, GangZoneOwner[zone], GangZoneEnemy[zone]); // Территория остается
	    }
	    else if(owners == 0)
		{	// Защитники сбежали
			format(string, 128, "[Gang Zone]: %s захватывают территорию, смотря в след убегающим %s", GetFactionName(GangZoneEnemy[zone]), GetFactionName(GangZoneOwner[zone]));
			SendGangMessageToAll(GetGangColor(GangZoneEnemy[zone]), string);
			StopGangWar(zone, GangZoneEnemy[zone], GangZoneOwner[zone]); // Территория переходит
	    }
		else if(GangZoneTime[zone] <= 0)
		{   // Время вышло
			if(GangZoneEnKill[zone] > GangZoneOwKill[zone])
			{// Победили нападающие
				format(string, 128, "[Gang Zone]: %s выигрывают со счетом %d:%d в нападении на %s", GetFactionName(GangZoneEnemy[zone]), GangZoneEnKill[zone], GangZoneOwKill[zone], GetFactionName(GangZoneOwner[zone]));
				SendGangMessageToAll(GetGangColor(GangZoneEnemy[zone]), string);
			    StopGangWar(zone, GangZoneEnemy[zone], GangZoneOwner[zone]); // Территория переходит
			}
			else
			{// Победили защитники
				format(string, 128, "[Gang Zone]: %s проигрывают со счетом %d:%d в нападении на %s", GetFactionName(GangZoneEnemy[zone]), GangZoneEnKill[zone], GangZoneOwKill[zone], GetFactionName(GangZoneOwner[zone]));
				SendGangMessageToAll(GetGangColor(GangZoneEnemy[zone]), string);
			    StopGangWar(zone, GangZoneOwner[zone], GangZoneEnemy[zone]); // Территория остается
			}
		}
    }
    else // Неизвестный статус войны
	{
		StopGangWar(zone, GangZoneOwner[zone], GangZoneEnemy[zone]); // Территория остается
	}
	return true;
}

stock GraffitiUpdate(zone)
{
	for(new g = 0; g < sizeof(Graffiti); g++)
	{
		if(GangZones[zone][0] <= Graffiti[g][0] <= GangZones[zone][2] && GangZones[zone][1] <= Graffiti[g][1] <= GangZones[zone][3])
		{
	    	DestroyDynamicObject(GraffitiNum[g]);
	    	if(GangZoneOwner[zone] > 0)
	    	{
				GraffitiNum[g] = CreateDynamicObject(GetGangGraffiti(GangZoneOwner[zone]), Arr3<Graffiti[g]>, 0.0, 0.0, Graffiti[g][3], 0);
			}
			else GraffitiNum[g] = 0;
		}
	}
	return true;
}	

static GetGangGraffiti(faction)
{
	if(0 < faction < sizeof(Faction))
	{
	    switch(Faction[faction][F_ID])
	    {
	        case F_GROVE:	return 18659;
			case F_BALLAS:	return 18662;
			case F_VAGOS:	return 18665;
			case F_AZTECAS:	return 18661;
			case F_RIFA:	return 18663;
	    }
	}
	return 0;
}

//////////	Commands	//////////
flags:setowner(CMD_DEVELOPER);
CMD:setowner(playerid, params[])
{// [BT]
	new zone = GetPlayerGangZone(playerid);
	if(zone == -1)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы должны находиться в одной из гангзон.");
	new gangid;
	if(sscanf(params, "i", gangid))
	{
	    SendClientMessage(playerid, COLOR_WHITE, "Используйте: /setowner [gangid]");
		return ShowDialog(playerid, DMODE_CHOOSEGANG);
	}
	if(gangid > 0 && !IsGang(gangid))
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Владельцем ганг зоны может быть только банда.");

	if(GangZoneEnemy[zone] > 0)
	{// Была война
		StopGangWar(zone, GangZoneOwner[zone], GangZoneEnemy[zone]);
	}
	new oldgangid = GangZoneOwner[zone];
	GangZoneOwner[zone] = gangid;
	GangZone_Update(zone);
	UpdateGangZone(zone);
	GraffitiUpdate(zone);

	foreach(LoginPlayer, i)
	{
	    if(!IsGang(PlayerInfo[i][pFaction])) continue;
	    if(PlayerInfo[i][pFaction] == gangid || PlayerInfo[i][pFaction] == oldgangid)
			UpdatePlayerGraffitiCP(i); // Graffiti update
	}
	return 1;
}

flags:gotogz(CMD_DEVELOPER);
COMMAND:gotogz(playerid, params[])
{
	new string[128];
	new gz;
	if(sscanf(params, "i", gz))
	{
	    SendFormatMessage(playerid, COLOR_WHITE, string, "Используйте: /gotogz [gang zone(0-%d)]", sizeof(GangZones) - 1);
	    return true;
	}
	if(gz < 0 || gz >= sizeof(GangZones))
	{
		SendFormatMessage(playerid, COLOR_WHITE, string, "Используйте: /gotogz [gang zone(0-%d)]", sizeof(GangZones) - 1);
		return true;
	}
	new Float:pos[3];
	pos[0] = GangZones[gz][0] + (GangZones[gz][2] - GangZones[gz][0]) / 2.0;
	pos[1] = GangZones[gz][1] + (GangZones[gz][3] - GangZones[gz][1]) / 2.0;
	MapAndreas_FindZ_For2DCoord(Arr3<pos>);
	MySetPlayerPos(playerid, Arr3<pos>);
	return true;
}

flags:rescue(CMD_DEVELOPER);
COMMAND:rescue(playerid, params[])
{
	new string[128];
	for(new g = 1; g < sizeof(Faction); g++) GangRescue[g] = 0;
	format(string, 128, "[AdmCmd]: %s %s[%d] восстановил все банды после поражения",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
	SendAdminMessage(COLOR_ADMIN, string);
	return 1;
}