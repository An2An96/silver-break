/*
 * Copyright (C) 2011-2018 Borog25 & Impereal
 *
 * Silver Break RPG
 * Last edit:	17/10/2018
 * Version:		3.5.0
 *
 * System requirements:
 *      - Microsoft Visual C++ 2015 Redistributable Package (x86)
 *      - Microsoft Visual C++ 2010 Redistributable Package (x86)
 *
 * Featured files:
 *		.../npcmodes/recordings/%RECORD_LIST%	- NPC recordings
 *		.../scriptfiles/gm_data/settings.cfg 	- Gamemode settings
 *		.../scriptfiles/gm_data/houses.cfg 		- Default Houses
 *		.../scriptfiles/admin_log/				- Admin logs
 *		.../scriptfiles/log/					- Logs
 *
 * Notes:
 *		������������ ���������, ���� �� ������������ �����-�� �������� � PreloadAnimLibs
 *		SetPlayerAttachedObject(playerid, 0, 19816, 1, 0.125, -0.17, 0.0, 0.0, 87.899978, 0.0, 1.317, 1.221, 1.2);
 */

#pragma dynamic 8192

//	Basis
#include <a_samp>
#include <a_http>

//	Sampctl dependencies
	//	Libs for plugins
#include <a_mysql>
#include <sscanf2>
#include <streamer>
#include <rustext>
#include <Pawn.CMD>
#include <crashdetect>
#include <timerfix>
#include <mapandreas>
	//	Utils
#include <mxINI>
#include <foreach>
#include <easy_keys>

//	Utils
#include "utils/extend_mdialog"
#include "utils/fixes"
#include "utils/t_time"
#include "utils/world_text"
#include "utils/point_utils"

//	Core
#include "core/timers"
#include "core/interface"
#include "core/colors"
#include "core/const_data"
#include "core/utils"
#include "core/sa_zones"
#include "core/vw_list"
#include "core/config"
#include "core/global_scope"
#include "core/actors"

//	Modules
#include "anticheat/core"
#include "admin/core"

//	System
#include "system/gates"
#include "system/buttons"
#include "system/enterexit"
#include "system/combinations"
#include "system/attach"
#tryinclude "system/ucp_news"

//	NPC
#include "npc/core"

//	Player
#include "player/core"
#include "player/chat/core"
#include "player/phone/core"
#tryinclude "player/achieve"

#include "inventory/core"	//	Inventory
#include "job/core"			//	Jobs
#include "faction/core"		//	Factions
#include "businesses/core"	//	Businesses
#include "house/core"		//	House
#include "vehicle/core"		//	Vehicle

//	Service
#tryinclude "service/casino"

//	Events
#include "events/races/core"

#include "interface/core"	//	Interface

stock MySetPlayerMarkerForPlayer(playerid, showplayerid, color, bool:oversee = false)
{
	if(InMask[showplayerid])
	{
		if(oversee)
			SetPlayerMarkerForPlayer(playerid, showplayerid, color);				// ����� ����������, �� ��� �����
		else
			SetPlayerMarkerForPlayer(playerid, showplayerid, color & 0xFFFFFF00);	// ����� ���������� � ��� �� �����
	}
	else
		SetPlayerMarkerForPlayer(playerid, showplayerid, color);		// ����� �� ���������� � ��� �����
}

Public: MyGivePlayerParachute(playerid)
{
	MyGivePlayerWeapon(playerid, 46, 1);
}

//  ��������� �������� ������
stock generateCode(size = MAX_CODE_SIZE)
{
	new stmp[MAX_CODE_SIZE];
	for(new i = 0; i < size; i++)
	{
		if(!random(2))	stmp[i] = '0' + random(10);
		else			stmp[i] = 'A' + random(26);
	}
	return stmp;
}

stock BlockPlayerAction(playerid, block)
{
	if(block == BLOCK_NONE)	gBlockAction[playerid] = BLOCK_NONE;
	else 					gBlockAction[playerid] |= block;
}

//	FIX
Public: MyFreezePlayer(playerid)
{
	return TogglePlayerControllable(playerid, false);
}

Public: MyUnfreezePlayer(playerid)
{
	// PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
	return TogglePlayerControllable(playerid, true);
}

Public: FixPlayerFreeze(playerid)
{
	if(IsPlayerControllable(playerid))
	{
		TogglePlayerControllable(playerid, true);
		ClearAnimations(playerid);
	}
	return true;
}

stock GetPlayerUsername(plid)
{
    new query[128], plname[MAX_PLAYER_NAME];
    format(query, sizeof(query), "SELECT `username` FROM `players` WHERE `id` = '%d'", plid);
	new Cache:result = mysql_query(g_SQL, query);
	cache_get_value_index(0, 0, plname);
	cache_delete(result);
	return plname;
}

GetPlayerCoins(playerid)
{
	new query[128],
		Cache:result,
		coins;

	mysql_format(g_SQL, query, sizeof query, "SELECT `coins` FROM %s.`ucp_account_links` WHERE `id` = '%d'", MAIN_DB, PlayerInfo[playerid][pUserID]);
	result = mysql_query(g_SQL, query);
	cache_get_value_name_int(0, "coins", coins);
	cache_delete(result);
	return (coins);
}

stock SetPlayerCoins(playerid, coins)
{
    new query[128];
	
	mysql_format(g_SQL, query, sizeof query, "UPDATE %s.`ucp_account_links` SET `coins` = '%d' WHERE `id` = '%d'", MAIN_DB, coins, PlayerInfo[playerid][pUserID]);
	mysql_query(g_SQL, query);
	return (cache_affected_rows() ? true : false);
}

stock GivePlayerCoins(playerid, coins)
{
	new query[128];

	if(coins > 0)
		format(query, 32, "~y~+%d coins", coins);
	else
		format(query, 32, "~r~%d coins", coins);
	GameTextForPlayer(playerid, query, 3000, 4);
	mysql_format(g_SQL, query, sizeof query, "UPDATE %s.`ucp_account_links` SET `coins` = `coins` + '%d' WHERE `id` = '%d'", MAIN_DB, coins, PlayerInfo[playerid][pUserID]);
	mysql_query(g_SQL, query);
	PlayerPlaySound(playerid, 30801, 0.0, 0.0, 0.0);
	return (cache_affected_rows() ? true : false);
}

stock UpdatePlayerCoins(playerid)
{
	new string[32];
	format(string, sizeof(string), "Coins: %d", GetPlayerCoins(playerid));
	return PlayerTextDrawSetString(playerid, StatusCoins, string);
}

GetPlayerHunger(playerid)
{
	return PlayerInfo[playerid][pHunger];
}

SetPlayerHunger(playerid, hunger)
{
	if(0 <= hunger <= 100)
	{
		PlayerInfo[playerid][pHunger] = hunger;
		IFace.HungerUpdate(playerid);
	}
	return true;
}

GivePlayerHunger(playerid, hunger)
{
	if(PlayerInfo[playerid][pHunger] + hunger > 100)	PlayerInfo[playerid][pHunger] = 100;
	else if(PlayerInfo[playerid][pHunger] + hunger < 0)	PlayerInfo[playerid][pHunger] = 0;
	else PlayerInfo[playerid][pHunger] += hunger;
	IFace.HungerUpdate(playerid);
	return true;
}

//	���������� 1 - ���� ������ ����, -1 - ���� ������, 0 - ���� �� ���� ��� ��� ������������� �������� (�������� � ����������)
EatPlayer(playerid, count, const msg[] = "")
{
	new hunger = GetPlayerHunger(playerid);
	if(hunger < 100)
	{
		if(MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0))
		{
			if(strlen(msg))
				PlayerAction(playerid, msg);
			GivePlayerHunger(playerid, count);
			count -= (100 - hunger);
		}
		else return 0;
	}
	if(count > 0)
	{
		if(MyApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 0, 0, 0, 0))
		{
			PlayerAction(playerid, "������ �� ���������.");
			return -1;
		}
		else return 0;
	}
	return 1;
}

//	Money
stock GivePlayerBank(playerid, Float:amount)
{
	PlayerInfo[playerid][pBank] += amount;
}

stock GivePlayerCrimeWage(playerid, Float:amount)
{
	PlayerInfo[playerid][pCrimeWage] += amount;
}

//	============================================

stock RestartServer(time = 0)
{
	if(time == 0)
	{
		foreach(Player, i)
		{
			SetPlayerInterior(i, 0);
			SetPlayerCameraPos(i, 1887.5, -1457.5, 42.0);
			SetPlayerCameraLookAt(i, 1678.7, -1283.2, 139.5);
			GameTextForPlayer(i, RusText("~b~�������", isRus(i)), 3000, 3);

		    if(RESTSPAWNDROP)
		    {
		    	PlayerInfo[i][pPosX] = 0.0;
		    	PlayerInfo[i][pPosY] = 0.0;
	        }
	        gPlayerDisconnecting[i] = true;
		    UpdatePlayerStatics(i);
		    gPlayerLogged[i] = false;
		    StopAudioStreamForPlayer(i);
		    MyHidePlayerDialog(i);
		    MyDisablePlayerCheckpoint(i);
		}
		foreach(Vehicle, v)
		{
		    if(CarInfo[v][cID] > 0)
		    	UpdateVehicleStatics(v);
		}
		print("\nServer is restarting...");
		SendRconCommand("gmx");
	}
	else RestTime = time;
}

stock GetWeekDay(day = 0, month = 0, year = 0)
{
	if(day == 0 && month == 0 && year == 0) getdate(year, month, day);
	if(day == 0 || month == 0 || year == 0) return 0;
	//-
	new dayM = 2, monthM = 1, yearM = 2012;
	new days = GetDaysFromDate(dayM, monthM, yearM, day, month, year);
	return days % 7 + 1;
}

stock GetDaysFromDate(dayM, monthM, yearM, day = 0, month = 0, year = 0)
{
	new days, bool:change;
	new DaysInMonth[] = {31,28,31,30,31,30,31,31,30,31,30,31};
	//-
	if(!(0 < dayM <= DaysInMonth[monthM-1]) || !(0 < monthM < 12) || !(1989 <= yearM <= 2099)) return -1;
	if(day == 0 && month == 0 && year == 0) getdate(year, month, day);
	//-
	if(yearM > year) change = true;
	else if(yearM == year)
	{
	    if(monthM > month) change = true;
	    else if(monthM == month)
	    {
	        if(dayM > day) change = true;
	    }
	}
	//-
	if(change)
	{
	    new x;
	    x = day;
	    day = dayM;
	    dayM = x;
	    //
	    x = month;
	    month = monthM;
	    monthM = x;
	    //
	    x = year;
	    year = yearM;
	    yearM = x;
	}
	//-
	for(new a = yearM; a < year; a++)// Code 3
	{
	    if(a == (a/4)*4) days++;
	    days += 365;
	}
	for(new b = monthM; b < month; b++)
	{
	    if(b == 2 && year == (year/4)*4) days++;
	    days += DaysInMonth[b-1];
	}
	days += day-dayM;
	return days;
}

//  Warehouses  //
LoadWarehouses()
{
	new count = 0;

	// �������� ������ //
	new Cache:result = mysql_query(g_SQL, "SELECT * FROM `warehouses`");
	for(new i = 0; i < cache_num_rows(); i++)
	{
		new faction;
		cache_get_value_index_int(i, 0, faction);// faction (primary key)
		if(0 < faction < sizeof(Faction))
		{
		    new field = 1;
		    cache_get_value_index_int(i, field++, Warehouse[faction][WH_MONEY]);
		    cache_get_value_index_int(i, field++, Warehouse[faction][WH_DRUGS]);
		    cache_get_value_index_int(i, field++, Warehouse[faction][WH_MATS]);
		    for(new s = 0; s < WH_GUN_MAX; s++)
		    {
		        cache_get_value_index_int(i, field++, Warehouse[faction][WH_GUN][s]);
		    }
		    Warehouse[faction][WH_LOADED] = true; count++;
		}
		else
		{
			printf( "  WARNING! Unknown faction(%d) from `warehouses` (database)!", i);
			continue;
		}
	}
	cache_delete(result);

	return count;
}

stock GetWarehouseWeaponid(slot)
{
	switch(slot)
	{
	    case 0: return 23; // Silenced 9mm
	    case 1: return 24; // Desert Eagle
	    case 2: return 25; // Shotgun
	    case 3: return 29; // MP5
	    case 4: return 30; // AK-47
	    case 5: return 31; // M4
	    case 6: return 33; // Connty Rifle
	    case 7: return 34; // Sniper Rifle
	    case 8: return 35; // RPG
	}
	return 0;
}
stock GetWarehouseWeaponSlot(weaponid)
{
	switch(weaponid)
	{
	    case 23: return 0; // Silenced 9mm
	    case 24: return 1; // Desert Eagle
	    case 25: return 2; // Shotgun
	    case 29: return 3; // MP5
	    case 30: return 4; // AK-47
	    case 31: return 5; // M4
	    case 33: return 6; // Connty Rifle
	    case 34: return 7; // Sniper Rifle
	    case 35: return 8; // RPG
	}
	return -1;
}

SaveWarehouse(faction)
{
	if(0 < faction < sizeof(Faction))
	{
		new query[512];

		// ������� ������ (��� ����������) //
	    if(Warehouse[faction][WH_LOADED] == false)
	    {
			format(query, sizeof(query), "INSERT INTO `warehouses` SET `faction` = '%d'", faction);
			mysql_query_ex(query);
			Warehouse[faction][WH_LOADED] = true;
	    }

		// �������� ������ //
		format(query, sizeof(query), "UPDATE `warehouses` SET `money` = '%d', `drugs` = '%d', `mats` = '%d',\
									 `gun_23` = '%d', `gun_24` = '%d', `gun_25` = '%d', `gun_29` = '%d',\
									 `gun_30` = '%d', `gun_31` = '%d', `gun_33` = '%d', `gun_34` = '%d',\
									 `gun_35` = '%d' WHERE `faction` = '%d'",
								  	 Warehouse[faction][WH_MONEY], Warehouse[faction][WH_DRUGS], Warehouse[faction][WH_MATS],
									 Warehouse[faction][WH_GUN][0], Warehouse[faction][WH_GUN][1], Warehouse[faction][WH_GUN][2], Warehouse[faction][WH_GUN][3],
									 Warehouse[faction][WH_GUN][4], Warehouse[faction][WH_GUN][5], Warehouse[faction][WH_GUN][6], Warehouse[faction][WH_GUN][7],
									 Warehouse[faction][WH_GUN][8], faction);
		mysql_query_ex(query);

		// ������������� ���������� ��������
		UpdateWarehouse(faction);
	}
	return true;
}

stock UpdateWarehouse(faction)
{// � ���������� [BT]
	return faction;
}

stock GetFactionMoney(faction)
{
	if(0 < faction < sizeof(Faction))
	{
	    return Warehouse[faction][WH_MONEY];
	}
	return 0;
}

stock GiveFactionMoney(faction, money)
{
	if(0 < faction < sizeof(Faction))
	{
	    Warehouse[faction][WH_MONEY] += money;
	    SaveWarehouse(faction);
	}
}

//----
SetPlayerInJail(playerid, spawn = true)
{
	PlayerInfo[playerid][pJailTime] = -GetPlayerWantedLevel(playerid);
	if(CriminalDanger[playerid]) PlayerInfo[playerid][pJailTime] -= 1;
	MySetPlayerWantedLevel(playerid, 0);
	MySetPlayerSpawnPos(playerid, 264.6, 77.6, 1001.0, 270.0, 6, VW_LSPD);
	UpdatePlayerStatics(playerid);
	if(spawn) MySpawnPlayer(playerid);	// Spawn player right now!
	return true;
}

ShowPlayerPrisonTime(playerid)
{
	p_PrisonTimer{playerid} = true;
}

HidePlayerPrisonTime(playerid)
{
	p_PrisonTimer{playerid} = false;
	HidePlayerVisualTimer(playerid);
}

Public: PrisonCycle(playerid, step)
{
	switch(step)
	{
	    case 0:
	    {	// ��� �� ����
	    	SetPVarInt(playerid, "PrisonCycle", 1);
	        TogglePlayerSpectating(playerid, 1);
			SetPlayerInterior(playerid, 0);
			GameTextForPlayer(playerid, " ", 1000, 4);
			MySetPlayerPos(playerid,1506.7561,-1668.6215,14.0469,270.0);
			IFace.ToggleTVEffect(playerid, true);
			TogglePlayerControllable(playerid, false);
			SetPlayerCameraPos(playerid, 1545.2393, -1676.6, 19.4898);
			SetPlayerCameraLookAt(playerid, 1546.2374, -1676.6, 19.3147);
			SetPVarInt(playerid, "Prison:FlyCamera:Timer", SetTimerEx("PrisonCycle", 1000, false, "dd", playerid, step + 1));
	    }
	    case 1:
	    {	// ��������� �� �������
		    TogglePlayerControllable(playerid, true);
			InterpolateCameraPos(playerid, 1545.2393, -1676.6, 19.4898, 1510.4630, -1676.6, 29.02, 4000);
			InterpolateCameraLookAt(playerid, 1546.2374, -1676.6, 19.3147, 1511.4611, -1676.6, 28.72, 4000);
			SetPVarInt(playerid, "Prison:FlyCamera:Timer", SetTimerEx("PrisonCycle", 5000, false, "dd", playerid, step+1));
	    }
	    case 2:
	    {	// ����� �� ����
			InterpolateCameraPos(playerid, 1510.4630, -1676.6162, 29.0200, 2842.2944, -2374.2776, 48.3854, 15000);
			InterpolateCameraLookAt(playerid, 1511.4611, -1676.6133, 28.7200, 2841.7234, -2375.0947, 48.1456, 15000);
			SetPVarInt(playerid, "Prison:FlyCamera:Timer", SetTimerEx("PrisonCycle", 17000, false, "dd", playerid, step+1));
	    }
	    case 3:
	    {	// ����� �� ���������
			InterpolateCameraPos(playerid, 2842.2944, -2374.2776, 48.3854, 734.5543, -2735.6038, 12.0833, 15000);
			InterpolateCameraLookAt(playerid, 2841.7234, -2375.0947, 48.1456, 733.6075, -2735.9241, 11.8982, 15000);
			SetPVarInt(playerid, "Prison:FlyCamera:Timer", SetTimerEx("PrisonCycle", 17000, false, "dd", playerid, step+1));
	    }
	    case 4:
	    {
	    	MySetPlayerSkin(playerid, JailSkins[ random( sizeof JailSkins - 1 )]);	//	���� �������� ����
	    	SetPlayerPrisonPos(playerid, 0);
	    	TogglePlayerSpectating(playerid, 0); // �����
		}
		case 5:
		{
			FadeColorForPlayer(playerid, 255, 255, 255, 255, 255, 255, 255, 0, 10);
			SetPVarInt(playerid, "Prison:FlyCamera:Timer", SetTimerEx("PrisonCycle", 2000, false, "dd", playerid, step+1));
		}
		case 6:
		{
			SetPlayerFacingAngle(playerid, 180.0);
			SetPVarInt(playerid, "Prison:FlyCamera:Timer", SetTimerEx("PrisonCycle", 1000, false, "dd", playerid, step+1));
		}
		case 7:
		{
			FadeColorForPlayer(playerid, 255, 255, 255, 255, 255, 255, 255, 0, 10);
			SetPVarInt(playerid, "Prison:FlyCamera:Timer", SetTimerEx("PrisonCycle", 2000, false, "dd", playerid, step+1));
		}
		case 8:
		{
			SetPVarInt(playerid, "PrisonCycle", 2);
			FadeColorForPlayer(playerid, 0, 0, 0, 0, 0, 0, 0, 255, 20);
		}
	}
}

stock IsPlayerInPaynSpray(playerid)
{
    for(new p = 0; p < sizeof(paynspray); p++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 10.0, paynspray[p][0], paynspray[p][1], paynspray[p][2])) return true;
    }
    return false;
}

//---
ReturnDate()
{
	new string[16];
	new year,month,day;
	getdate(year,month,day);
	format(string,16,"%02d/%02d/%04d",day,month,year);
	return string;
}

ReturnTime()
{
	new string[10];
	new hour,minute,second;
	gettime(hour,minute,second);
	format(string,10,"%02d:%02d",hour,minute);
	return string;
}

stock MySetPlayerPosFade(playerid, fadeid, Float:x, Float:y, Float:z, Float:a = 0.0, bool:freeze = false, interior = 0, virt = 0)
{
    fade_Teleporting[playerid] = 1;
	fade_TPToPos[playerid][0] = x;	fade_TPToPos[playerid][1] = y;	fade_TPToPos[playerid][2] = z;
	if(a == -1)	GetPlayerFacingAngle(playerid, fade_TPToPos[playerid][3]);
	else		fade_TPToPos[playerid][3] = a;
	fade_Freeze[playerid] = freeze;
	fade_Interior[playerid] = interior;
	fade_VirtualWorld[playerid] = virt;
	Fade_TeleportID[playerid] = fadeid;
	TogglePlayerControllable(playerid, false);
	return FadeColorForPlayer(playerid, 0, 0, 0, 0, 0, 0, 0, 255, 10, FADE_TELEPORT);
}

stock UpdatePlayerRadio(playerid)
{
	new string[128];
	new radio = GetPVarInt(playerid, "Thing:RadioID");
	if(radio == 0)
	{
		// ���� � ������ ������ �����
		new vehicleid = GetPlayerVehicleID(playerid);
		if(vehicleid > 0 && VehInfo[vehicleid][vRadio] > 0)
		{
			PlayAudioStreamForPlayer(playerid, RadioList[ VehInfo[vehicleid][vRadio] - 1 ][RADIO_URL]);
			PlayerPlaySound(playerid, 1069, 0.0, 0.0, 0.0);// fix
		}
		else
		{
			StopAudioStreamForPlayer(playerid);
			GameTextForPlayer(playerid, "~r~Radio OFF", 5000, 6);
		}
    }
    else
    {
		PlayAudioStreamForPlayer(playerid, RadioList[radio - 1][RADIO_URL]);
		PlayerPlaySound(playerid, 1069, 0.0, 0.0, 0.0);	// fix
		format(string, 128, "~g~%s", RadioList[radio - 1][RADIO_NAME]);
		GameTextForPlayer(playerid, string, 5000, 6);
    }
	return true;
}

//	Offline Server Messages
stock SendOfflineMessage(userid, const text[])
{
	new query[256];
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO `offline_message` (`user_id`, `message`, `date`) VALUES('%d', '%s', UNIX_TIMESTAMP())", userid, text);
	mysql_query_ex(query);
}

Admin_Log(string[])
{
	new day, month, year;
	getdate(year, month, day);
	new hour, minute, second;
	gettime(hour, minute, second);
	new message[256];
	format(message, 256, "admin_log/%02d.%02d.%04d.log", day, month, year);
	new File:hFile = fopen(message, io_append);
	format(message, 256, "[%02d:%02d:%02d] %s\r\n", hour, minute, second, string);
	fwriterus(hFile, message);
	fclose(hFile);
	return true;
}

IsPlayerInJail(playerid)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(261.0 <= X <= 266.7 && 74.5 <= Y <= 89.5 && 999.4 <= Z < 1003.85)
		return (1);
	return (0);
}

SendRemainingBanTime(playerid, banunix)
{
	new string[128];
	new days, hours, minutes;
	new bantime = banunix - gettime();
	format(string, 128, "�� ������� ��������:");
	// ���
    new dayunix = 24*60*60;
	if(bantime >= dayunix)
	{
		days = bantime / dayunix;
		bantime -= days * dayunix;
		format(string, 128, "%s %d ����", string, days);
	}
	// ����
    new hourunix = 60*60;
	if(bantime >= hourunix)
	{
		hours = bantime / hourunix;
		bantime -= hours * hourunix;
		format(string, 128, "%s %d �����", string, hours);
	}
	// ������
	new minuteunix = 60;
	if(bantime >= minuteunix)
	{
		minutes = bantime / minuteunix;
		bantime -= minutes * minuteunix;
		format(string, 128, "%s %d �����", string, minutes);
	}
	SendClientMessage(playerid, COLOR_SERVER, string);
}

Public: UpdatePlayerWeather(playerid)
{
	if(FirstSpawn[playerid] == false && UseDrugsTime[playerid] <= 0)
 	{
 		new vw = GetPlayerVirtualWorld(playerid);
 		if(GetPlayerInterior(playerid) || vw == VW_AIRPORT)
 				SetPlayerWeather(playerid, 3);
	    else 	SetPlayerWeather(playerid, NowWeather);
    	return false;
    }
    return true;
}

UpdateWeather(weatherid = 0)
{
	if(weatherid == 0)
	{
		if(random(100) < 10)
		{
			new const wlist[] = { 8, 9, 16, 19, 20 };
			NowWeather = wlist[random(sizeof(wlist))];
		}
		else
		{
			new const wlist[] = { 1, 2, 3, 4 , 5, 6 , 7, 10, 11, 12, 13, 14, 15, 17, 18 };
			NowWeather = wlist[random(sizeof(wlist))];
		}
	}
    else NowWeather = weatherid;
	foreach(Player, i)	UpdatePlayerWeather(i);
	return true;
}

Public: MyMoveObject(objectid, Float:X, Float:Y, Float:Z, Float:Speed, Float:RotX, Float:RotY, Float:RotZ)
{
	return MoveObject(objectid, X, Y, Z, Speed, RotX, RotY, RotZ);
}

Public: MyMoveDynamicObject(objectid, Float:X, Float:Y, Float:Z, Float:Speed, Float:RotX, Float:RotY, Float:RotZ)
{
	return MoveDynamicObject(objectid, X, Y, Z, Speed, RotX, RotY, RotZ);
}

Public: RerotObject(objectid, Float:RotX, Float:RotY, Float:RotZ, Float:Speed)
{
	new Float:X, Float:Y, Float:Z;
	GetDynamicObjectPos(objectid, X, Y, Z);
	return MoveDynamicObject(objectid, X, Y, Z - 0.1, Speed, RotX, RotY, RotZ);
}

Public: PrisonGateMove(gateid, bool:status)
{
	new const Float:Speed = 2.4;
    switch(gateid)
    {
        case 0:
        {	// ������ � ��������
            if(status) 	MoveDynamicObject(PrisonGate[gateid], 550.359, -2748.300, 14.600, Speed);
            else 		MoveDynamicObject(PrisonGate[gateid], 540.359, -2748.300, 14.600, Speed);
        }
        case 1:
        {	// ������ � �������� ������
            if(status) 	MoveDynamicObject(PrisonGate[gateid], 551.429, -2721.300, 14.600, Speed);
            else 		MoveDynamicObject(PrisonGate[gateid], 551.429, -2731.300, 14.600, Speed);
        }
        case 2:
        {	// ������ � ��������
            if(status) 	MoveDynamicObject(PrisonGate[gateid], 530.580, -2714.209, 14.600, Speed);
            else 		MoveDynamicObject(PrisonGate[gateid], 540.580, -2714.209, 14.600, Speed);
        }
        case 3:
        {	// ������ � ����.��������
            if(status) 	MoveDynamicObject(PrisonGate[gateid], 537.320, -2818.209, 14.600, Speed);
            else 		MoveDynamicObject(PrisonGate[gateid], 547.320, -2818.209, 14.600, Speed);
        }
        case 4:
        {	// ������ � ������� ������
            if(status) 	MoveDynamicObject(PrisonGate[gateid], 590.169, -2666.679, 14.600, Speed);
            else 		MoveDynamicObject(PrisonGate[gateid], 590.169, -2676.679, 14.600, Speed);
        }
        case 5:
        {	// ������ � ������
            if(status) 	MoveDynamicObject(PrisonGate[gateid], 638.150, -2704.229, 6.219, Speed);
            else 		MoveDynamicObject(PrisonGate[gateid], 628.150, -2704.229, 6.219, Speed);
        }
        default: return true;
    }
	if(status)
		SetTimerEx("PrisonGateMove", 30 * 1000, false, "ib", gateid, false);
    return 1;
}

Public: JailDoorsMove(bool: status)
{
	if(status)
		for(new i = 0; i < sizeof JailDoors; i++)
		    if(i < 14)	MoveDynamicObject(JailDoors[i], JailDoorsPos[i][0], JailDoorsPos[i][1] + 2.4, JailDoorsPos[i][2], 1.0);
	    	else		MoveDynamicObject(JailDoors[i], JailDoorsPos[i][0], JailDoorsPos[i][1] - 2.4, JailDoorsPos[i][2], 1.0);
    else
    	for(new i = 0; i < sizeof JailDoors; i++)
	   	 MoveDynamicObject(JailDoors[i], Arr3<JailDoorsPos[i]>, 1.0);
	return true;
}

Public: ClearJailFall(playerid)
{
    SetTimerEx("ClearFell", 1200, false, "i", playerid);
	return MyApplyAnimation(playerid, "PED", "getup_front", 4.1, 0, 0, 0, 0, 0);
}
Public: ClearFell(playerid) return p_FellAnim[playerid] = false;

stock BlockPlayerAggression(playerid)
{
	p_FellAnim[playerid] = true;
    SetTimerEx("ClearFell", 600, false, "i", playerid);
    ClearAnimations(playerid);
    MyApplyAnimation(playerid, "FIGHT_C", "HitC_2", 4.1, 0, 1, 1, 0, 0);
    SetPlayerArmedWeapon(playerid, 0);
    return true;
}

Public: AntiBunnyHop(playerid)
{
	new Float:ST[4];
    GetPlayerVelocity(playerid, Arr3<ST>);
	SetPlayerVelocity(playerid, ST[0] * 0.3, ST[1] * 0.3, ST[2] * 0.3);
	p_FellAnim[playerid] = false;
	return true;
}

Public: OnPrisonStatusChange(newstate)
{
 	new string[128],
		statusname[20];
	if(PrisonersTP_Timer)
	{
		KillTimer(PrisonersTP_Timer);
	}
    switch(newstate)
    {
        case 1:
		{
			statusname = "������";
			PrisonGateMove(1, true);
			PrisonGateMove(2, true);
			JailDoorsMove(true);
			PrisonersTP_Timer = SetTimerEx("PrisonersTP", 32000, false, "d", newstate);
		}
        case 2:
        {
        	statusname = "��������";
        	PrisonersTP_Timer = SetTimerEx("PrisonersTP", 32000, false, "d", newstate);
		}
		case 3:
		{
			statusname = "��������";
			PrisonGateMove(0, true);
			PrisonGateMove(2, true);
			PrisonersTP_Timer = SetTimerEx("PrisonersTP", 32000, false, "d", newstate);
		}
        case 4:
		{
			statusname = "�����";
			PrisonGateMove(0, true);
			PrisonGateMove(1, true);
			JailDoorsMove(false);
			PrisonersTP_Timer = SetTimerEx("PrisonersTP", 1000, false, "d", newstate);
		}
    }
	if(newstate != 1)	DestroyDynamicPickup(j_lFinishPickup), j_lFinishPickup = INVALID_STREAMER_ID;
	else if(j_lFinishPickup == 0)	j_lFinishPickup = CreateDynamicPickup(1239, 1, 576.1, -2674.1, 13.2);//  ����� ��� ���������
    LastPrisonStatus = newstate;
    PrisonStatusTime = JailPeriod[newstate - 1];
    foreach(Prisoners, i)
	{
		JailJobClear(i);
		format(string, sizeof(string), "~y~%s", RusText(statusname, isRus(i)));
    	PlayerTextDrawSetString(i, p_JailPeriod, string);
    	PlayerPlaySound(i, 41800, 0.0, 0.0, 0.0);
    }
    SetTimer("PrisonEndSound", 2000, false);
	return true;
}

Public: PrisonEndSound()
{
	foreach(Prisoners, i)
	{
    	PlayerPlaySound(i, 0, 0.0, 0.0, 0.0);
    }
}

Public: PrisonersTP(newstate)
{
	foreach(Prisoners, i)
    {
    	SetPlayerPrisonPos(i, newstate);
    	if((newstate == 1 && IsPlayerInDynamicArea(i, JailZone[1]) == 0 && IsPlayerInRangeOfPoint(i, 30, 2550.5, -1293.5, 1044.2) == 0)
    	|| (newstate == 2 && IsPlayerInDynamicArea(i, JailZone[1]) == 0)
    	|| (newstate == 3 && IsPlayerInDynamicArea(i, JailZone[2]) == 0)
    	|| (newstate == 4))
	    {
	    	MySpawnPlayer(i);
	    }
    }
    PrisonersTP_Timer = 0;
    return true;
}

SetPlayerPrisonPos(playerid, newstate)
{
	if(newstate == 0)
	{	//	������ ��������� (����)
		MySetPlayerSpawnPos(playerid, 691.6, -2917.4, 1700.4, 270.0, 1, VW_JAIL + playerid);
	}
	if(newstate == 1 || newstate == 2 || newstate == 3)
    {
    	MySetPlayerSpawnPos(playerid, Arr4<PeriodPos[newstate - 1]>);
    }
    else if(newstate == 4)
    {
    	if(p_JailOccupied[playerid] == INVALID_PLAYER_ID)
    	{
    		for(new j = 0, c = 0; j < 36; j++)
            {
                for(new p = 0; p < sizeof JailPos; p++)
                {
                    if(g_JailOccupied[p] == c)
					{
                        g_JailOccupied[p]++;
                        p_JailOccupied[playerid] = p;
						break;
					}
                }
                c++;
            }
    	}
    	MySetPlayerSpawnPos(playerid, Arr4<JailPos[ p_JailOccupied[playerid] ]>, 1, VW_JAIL);
    }
    return true;
}

DeleteJailNumber(playerid)
{
	DestroyDynamic3DTextLabel(jail_number_3dtext[playerid]);
	strdel(jail_numer[playerid], 0, sizeof(jail_numer[]));
}

JailDelivery(playerid, spawn = true)
{
	MySetPlayerSpawnPos(playerid, 244.2467, 70.0835, 1003.6406, 180.0, 6, VW_LSPD);
	if(PlayerInfo[playerid][pJailTime] > 0)
	{
		DeleteJailNumber(playerid);
		UpdatePlayerSkin(playerid, false);
		PlayerInfo[playerid][pJailTime] = 1;
		if(spawn)	MySpawnPlayer(playerid);
	}
	else if(PlayerInfo[playerid][pJailTime] < 0)
	{
		PlayerInfo[playerid][pJailTime] = 0;
		JailTime[playerid] = 1;
	}
	return true;
}

public OnPlayerEnterReceived(playerid, enterid)
{
   	//if(!EnterInfo[e][enX] && !EnterInfo[e][enY])
	//	return false;
	if(enterid != E_NONE)
	{
		switch(enterid)
		{
			case E_DIVER:
			{
				SendClientMessage(playerid, COLOR_WHITE, "�� � ���������");
			}
		}

		// ������������� ���� ����
		new gangid = 0;
		if (enterid == E_GROOVE)
			gangid = F_GROVE;
		else if (enterid == E_BALLAS)
			gangid = F_BALLAS;
		else if (enterid == E_VAGOS)
			gangid = F_VAGOS;
		else if (enterid == E_AZTECAS || enterid == E_AZTECAS2)
			gangid = F_AZTECAS;
		else if (enterid == E_RIFA)
			gangid = F_RIFA;
		if (gangid > 0 && PlayerInfo[playerid][pFaction] != gangid)
		{
			new string[64]; // ~g~Grove Street~n~~w~only
			format(string, 128, "~%c~%s~n~~w~only", GetGangColorChart(gangid), GetFactionName(gangid));
			GameTextForPlayer(playerid, string, 4000, 4);
			return (0);
		}
		//	LSPD
		if (PlayerInfo[playerid][pFaction] != F_POLICE)
		{
			if(enterid == E_LSPD_GARAGE || enterid == E_LSPD_ROOF || enterid == E_LSPD_AMMO)
			{
				GameTextForPlayer(playerid, "~r~Access denied", 3000, 4);
				return (0);
			}
		}
		//	PRISON
		if(PlayerInfo[playerid][pJailTime] > 0)
		{
			if(enterid == E_PRISON_EAT && LastPrisonStatus != 2)
			{
				GameTextForPlayer(playerid, "~r~Close", 1000, 1);
				return (0);
			}
			else if(enterid == E_PRISON2 && LastPrisonStatus != 4)
			{
				GameTextForPlayer(playerid, "~r~Close", 1000, 1);
				return (0);
			}
		}
	}
	return (1);
}

public OnPlayerExitReceived(playerid, exitid)
{
    //if(!EnterInfo[e][exX] && !EnterInfo[e][exY])
	//	return false;
	if(exitid != E_NONE)
	{
		//	LSPD
	    if(PlayerInfo[playerid][pFaction] != F_POLICE)
		{
			if(exitid == E_LSPD_GARAGE || exitid == E_LSPD_ROOF)
			{
				GameTextForPlayer(playerid, "~r~Access denied", 3000, 4);
	        	return false;
			}
		}
		//	PRISON
	    if(PlayerInfo[playerid][pJailTime] > 0)
	    {
			if(exitid == E_PRISON2 && LastPrisonStatus == 4)
			{
	            GameTextForPlayer(playerid, "~r~Close", 1000, 1);
	        	return false;
			}
	    }
	}
	return true;
}

public OnPlayerEnterExitFinish(playerid, enterid, bool:side)
{
	if(enterid != E_NONE)
	{
		if(side)
		{
			if(enterid == E_LSPD)
		    {	// ����������� �������
		        if(GetPlayerWantedLevel(playerid) > 3)
		        {
			        SendClientMessage(playerid, COLOR_WHITE, "- ������: ���� �����! �� ���������� �� ���������� � ���������� ������������!");
			        SetPlayerInJail(playerid);
		        }
		    }
			else if(enterid == E_GROOVE || enterid == E_BALLAS || enterid == E_VAGOS || enterid == E_AZTECAS || enterid == E_RIFA)
			{
				RobberyFinish(playerid, 1, true);
			}
		}
		else
		{
			if(enterid == E_HOTEL_JEF)
			{
				if(gMissionProgress[playerid][MIS_SOURCE_TRAINING] == 1)
				{
					ShowPlayerHint(playerid, "���� ����� ������������ �� ������ ������� ~y~�������");
				}
				else if(gMissionProgress[playerid][MIS_SOURCE_TRAINING] == 2 && mission_id[playerid] != MIS_START_WORK)
				{
					StoryMissionStart(playerid, MIS_SOURCE_TRAINING);
				}
			}
			else if(enterid == E_AUTOSCHOOL)
			{
				if(gMissionProgress[playerid][MIS_SOURCE_TRAINING] == 4)
				{
					MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "����������",
						"{FFFFFF}����������, �� ������ ��������� ������ ���� �� �������!\n\n\
						������� �������� �� ��������, �� ������ " MAIN_COLOR "���������� �� ������{FFFFFF} � �����.\n\
						� �����, ������ �������, �� ������� �������� � ���� �� " MAIN_COLOR "�������{FFFFFF}.\n\
						��������� ������ �����, �� ������� " MAIN_COLOR "������ ������{FFFFFF} (��� ��� ����� �� ���������)\n\n\
						���� � ��� �������� �������, ������ ������ ���������� � " MAIN_COLOR "/ask{FFFFFF}\n\
						����� ������ �����: " MAIN_COLOR "" SITE_ADRESS, "�������", "");
					gMissionProgress[playerid][MIS_SOURCE_TRAINING]++;
				}
			}
		}
	}
	return true;
}

CreatePlayerClotheMenu(playerid)
{
	new items[6][32];
	if(isRus(playerid))
	{
		items[0] = "������";
		items[1] = "��������";
		items[2] = "����";
		items[3] = "�����";
		items[4] = "�����";
		items[5] = "�������� �����";
	}
	else
	{
		items[0] = "Skins";
		items[1] = "Earflaps";
		items[2] = "Glass";
		items[3] = "Mask";
		items[4] = "Helmet";
		items[5] = "Hat";
	}
	ShowPlayerSelectMenu(playerid, SM_CLOTHE, "Clothes", items);
	return true;
}

ChoosePlayerClothes(playerid, mode)
{
	switch(mode)
	{
	    case 0:
	    {	// Stop choosing
			ClothesShopSel[playerid] = 0;
			//HidePlayerSelecter(playerid);
			//TextDrawHideForPlayer(playerid, tdChooseButton1);
			//TextDrawHideForPlayer(playerid, tdChooseButton2);
			//PlayerTextDrawHide(playerid, tdChoosePrice);
			//PlayerTextDrawHide(playerid, tdChooseItemL);
			//PlayerTextDrawHide(playerid, tdChooseItemR);
			ReloadPlayerSkin(playerid);
			Acsr.CancelTryPlayerAcsr(playerid);

			if(ClothesItem[playerid] > 0)
			{
				InterpolateCameraPos(playerid, Arr3<ClothesShopData[ ClothesShopID[playerid] ][csd_FaceCamPos]>, Arr3<ClothesShopData[ ClothesShopID[playerid] ][csd_StartCamPos]>, 2000);
				InterpolateCameraLookAt(playerid, Arr3<ClothesShopData[ ClothesShopID[playerid] ][csd_FaceCamLookAt]>, Arr3<ClothesShopData[ ClothesShopID[playerid] ][csd_StartCamLookAt]>, 2000);
			}

			CreatePlayerClotheMenu(playerid);
	    }
	    case 1:
	    {	// Start choosing
	        ClothesShopSel[playerid] = 0;
			TogglePlayerControllable(playerid, false);
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(playerid) + playerid);

			new Float:PlayerCameraPos[3],
				Float:PlayerCameraVector[3];
			GetPlayerCameraPos(playerid, Arr3<PlayerCameraPos>);
			GetPlayerCameraFrontVector(playerid, Arr3<PlayerCameraVector>);
			PlayerCameraVector[0] = PlayerCameraPos[0] + floatmul(PlayerCameraVector[0], 5.0);
			PlayerCameraVector[1] = PlayerCameraPos[1] + floatmul(PlayerCameraVector[1], 5.0);
			PlayerCameraVector[2] = PlayerCameraPos[2] + floatmul(PlayerCameraVector[2], 5.0);

			MySetPlayerPos(playerid, Arr4<ClothesShopData[ ClothesShopID[playerid] ][csd_Pos]>);
			InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, Arr3<ClothesShopData[ ClothesShopID[playerid] ][csd_StartCamPos]>, 2000);
			InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, Arr3<ClothesShopData[ ClothesShopID[playerid] ][csd_StartCamLookAt]>, 2000);

			CreatePlayerClotheMenu(playerid);

	        /*switch(ClothesShopID[playerid])
	        {
				case 1:
				{	// Binco
					//price = 150;
				}
				case 2:
				{	// DS
					//price = 50;
				}
				case 3:
				{	// Prolaps
					//price = 150;
				}
				case 4:
				{	// Suburban
					//price = 150;
				}
				case 5:
				{	// Victim
					//price = 200;
				}
				case 6:
				{	// ZIP
					//price = 650;
				}
			}*/
	    } 
	    case 2:
	    {	// Prev skin
	        new sel = ClothesShopSel[playerid] - 1;
	        if(sel < 0)		return false;
	        ClothesShopSel[playerid] = sel;
	        ChoosePlayerClothes(playerid, 4);
	    }
	    case 3:
	    {	// Next skin
	    	new sel = ClothesShopSel[playerid] + 1;
	    	switch(ClothesItem[playerid])
	    	{
	    		case 0:
				{
			        switch(ClothesShopID[playerid])
			        {
						case 1:	if(sel >= sizeof(Binco_Skin)) 		return false;
						case 2:	if(sel >= sizeof(DS_Skin))			return false;
						case 3:	if(sel >= sizeof(Prolaps_Skin))		return false;
						case 4:	if(sel >= sizeof(Suburban_Skin))	return false;
						case 5:	if(sel >= sizeof(Victim_Skin))		return false;
						case 6:	if(sel >= sizeof(ZIP_Skin))			return false;
					}
	    		}
	    		case 1:	if(sel >= sizeof(Earflaps))					return false;
	    		case 2:	if(sel >= sizeof(Glasses))					return false;
	    		case 3:	if(sel >= sizeof(Bandanas))					return false;
	    		case 4:	if(sel >= sizeof(Helmets))					return false;
	    		case 5:	if(sel >= sizeof(Hats))						return false;
	    	}
	        ClothesShopSel[playerid] = sel;
	        ChoosePlayerClothes(playerid, 4);
	    }
	    case 4:
	    {	// Show skin
			new skin[3] = {-1,...}, sel = ClothesShopSel[playerid];
	    	switch(ClothesItem[playerid])
	    	{
	    		case 0:
				{
			        switch(ClothesShopID[playerid])
			        {
						case 1:
						{
							skin[0] = Binco_Skin[sel];
							if(sel > 0) skin[1] = Binco_Skin[sel-1];
							if(sel < sizeof(Binco_Skin)-1) skin[2] = Binco_Skin[sel+1];
						}
						case 2:
						{
							skin[0] = DS_Skin[sel];
							if(sel > 0) skin[1] = DS_Skin[sel-1];
							if(sel < sizeof(DS_Skin)-1) skin[2] = DS_Skin[sel+1];
						}
						case 3:
						{
							skin[0] = Prolaps_Skin[sel];
							if(sel > 0) skin[1] = Prolaps_Skin[sel-1];
							if(sel < sizeof(Prolaps_Skin)-1) skin[2] = Prolaps_Skin[sel+1];
						}
						case 4:
						{
							skin[0] = Suburban_Skin[sel];
							if(sel > 0) skin[1] = Suburban_Skin[sel-1];
							if(sel < sizeof(Suburban_Skin)-1) skin[2] = Suburban_Skin[sel+1];
						}
						case 5:
						{
							skin[0] = Victim_Skin[sel];
							if(sel > 0) skin[1] = Victim_Skin[sel-1];
							if(sel < sizeof(Victim_Skin)-1) skin[2] = Victim_Skin[sel+1];
						}
						case 6:
						{
							skin[0] = ZIP_Skin[sel];
							if(sel > 0) skin[1] = ZIP_Skin[sel-1];
							if(sel < sizeof(ZIP_Skin)-1) skin[2] = ZIP_Skin[sel+1];
						}
						case 7:
						{
							skin[0] = FC_Skin[sel];
							if(sel > 0) skin[1] = FC_Skin[sel-1];
							if(sel < sizeof(FC_Skin)-1) skin[2] = FC_Skin[sel+1];
						}
					}
			        MySetPlayerSkin(playerid, skin[0], false);
	    		}
	    		case 1:
	    		{
	    			skin[0] = Earflaps[sel];
					if(sel > 0)						skin[1] = Earflaps[sel - 1];
					if(sel < sizeof(Earflaps) - 1)	skin[2] = Earflaps[sel + 1];
			        Acsr.TryPlayerAcsr(playerid, skin[0]);
	    		}
	    		case 2:
	    		{
	    			skin[0] = Glasses[sel];
					if(sel > 0)						skin[1] = Glasses[sel - 1];
					if(sel < sizeof(Glasses) - 1)	skin[2] = Glasses[sel + 1];
			        Acsr.TryPlayerAcsr(playerid, skin[0]);
	    		}
	    		case 3:
	    		{
	    			skin[0] = Bandanas[sel];
					if(sel > 0)						skin[1] = Bandanas[sel - 1];
					if(sel < sizeof(Bandanas) - 1)	skin[2] = Bandanas[sel + 1];
			        Acsr.TryPlayerAcsr(playerid, skin[0]);
	    		}
	    		case 4:
	    		{
	    			skin[0] = Helmets[sel];
					if(sel > 0)						skin[1] = Helmets[sel - 1];
					if(sel < sizeof(Helmets) - 1)	skin[2] = Helmets[sel + 1];
			        Acsr.TryPlayerAcsr(playerid, skin[0]);
	    		}
	    		case 5:
	    		{
	    			skin[0] = Hats[sel];
					if(sel > 0)						skin[1] = Hats[sel - 1];
					if(sel < sizeof(Hats) - 1)		skin[2] = Hats[sel + 1];
			        Acsr.TryPlayerAcsr(playerid, skin[0]);
	    		}
	    	}

	        //PlayerTextDrawHide(playerid, tdChooseItemL);
			//PlayerTextDrawHide(playerid, tdChooseItemR);
			if(skin[1] > -1)
			{
				//PlayerTextDrawSetPreviewModel(playerid, tdChooseItemL, skin[1]);
				//PlayerTextDrawShow(playerid, tdChooseItemL);
			}
			if(skin[2] > -1)
			{
				//PlayerTextDrawSetPreviewModel(playerid, tdChooseItemR, skin[2]);
				//PlayerTextDrawShow(playerid, tdChooseItemR);
			}
	    }
	    case 5:
	    {	
			new b = GetPVarInt(playerid, "Player:MenuBizID");
	        if(b != 0 && BizInfo[b][bType] == BUS_CLOTHING)
	        {
	        	new price;
				switch(ClothesItem[playerid])
		    	{
		    		case 0:
					{
				        switch(ClothesShopID[playerid])
				        {
							case 1: price = 150;	// Binco
							case 2: price = 50;		// DS (donate)
							case 3: price = 150;	// Prolaps
							case 4: price = 150;	// Suburban
							case 5: price = 200;	// Victim
							case 6: price = 650;	// ZIP
							case 7: price = 100;	// Fort Carson
						}
						if(ClothesShopID[playerid] == 2)
						{	// Donate Shop
						    if(GetPlayerCoins(playerid) < price)
						    {
							    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �� ������� ����� ��� �������.");
						    }
						}
						else
						{
						    if(MyGetPlayerMoney(playerid) < price)
						    {
							    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �� ������� ����� ��� �������.");
						    }
						}
				        if(Inv.AddPlayerThing(playerid, THING_SKIN, 1, GetPlayerSkin(playerid)))
				        {
				        	if(ClothesShopID[playerid] == 2)
							{	// Donate Shop
							    GivePlayerCoins(playerid, -price);
							    price = price * MoneyForCoin;
							}
							else
							{
							    MyGivePlayerMoney(playerid, -price);
							}
							BizSaleProds(b, price, 1);
				        	//UpdatePlayerSkin(playerid, false);
				        }
				    }
				    case 1:
				    {
				    	if(Inv.AddPlayerThing(playerid, THING_MUSIC, 1, ClothesShopSel[playerid]))
				    	{
				    		BizSaleProds(b, price, 1);
				    	}
				    }
				    case 2:
				    {
				    	if(Inv.AddPlayerThing(playerid, THING_GLASS, 1, ClothesShopSel[playerid]))
				    	{
				    		BizSaleProds(b, price, 1);
				    	}
				    }
				    case 3:
				    {
				    	if(Inv.AddPlayerThing(playerid, THING_MASK, 1, ClothesShopSel[playerid]))
				    	{
				    		BizSaleProds(b, price, 1);
				    	}
				    }
				    case 4:
				    {
				    	if(Inv.AddPlayerThing(playerid, THING_HELMET, 1, ClothesShopSel[playerid]))
				    	{
				    		BizSaleProds(b, price, 1);
				    	}
				    }
				    case 5:
				    {
				    	if(Inv.AddPlayerThing(playerid, THING_HAT, 1, ClothesShopSel[playerid]))
				    	{
				    		BizSaleProds(b, price, 1);
				    	}
				    }
				}
	    	}
	    }
	}
	return 1;
}

ChoosePlayerVehicle(playerid, mode)
{
	switch(mode)
	{
	    case 0:
	    {// Stop choosing
	        gPickupTime[playerid] = 3;
	        ChooseVehicleID[playerid] = 0;
			ChooseVehicleSel[playerid] = 0;
			ChooseVehicleModel[playerid] = 0;
			CancelSelectTextDraw(playerid);
			SetCameraBehindPlayer(playerid);
			IFace.ToggleTVEffect(playerid, false);
			TogglePlayerControllable(playerid, true);
			GameTextForPlayer(playerid, " ", 1000, 4);
			TextDrawHideForPlayer(playerid, tdChooseButton1);
			TextDrawHideForPlayer(playerid, tdChooseButton2);
			PlayerTextDrawHide(playerid, tdChoosePrice);
			PlayerTextDrawHide(playerid, tdChooseItemL);
			PlayerTextDrawHide(playerid, tdChooseItemR);
	    }
	    case 1:
	    {// Start choosing
	        ChooseVehicleSel[playerid] = 0;
			IFace.ToggleTVEffect(playerid, true);
			SelectTextDraw(playerid, COLOR_SERVER);
			TogglePlayerControllable(playerid, false);
			TextDrawShowForPlayer(playerid, tdChooseButton1);
			TextDrawShowForPlayer(playerid, tdChooseButton2);
			PlayerTextDrawShow(playerid, tdChoosePrice);
			ChoosePlayerVehicle(playerid, 4);
	    }
	    case 2:
	    {// Next vehicle
	        ChooseVehicleSel[playerid]++;
	        ChoosePlayerVehicle(playerid, 4);
	        PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
	    }
	    case 3:
	    {// Prev vehicle
	        ChooseVehicleSel[playerid]--;
	        ChoosePlayerVehicle(playerid, 4);
	        PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
	    }
	    case 4:
	    {// Show vehicle
	        new Float:X, Float:Y, Float:Z, Float:A;
	        new veh[3], v = ChooseVehicleSel[playerid];
	        switch(ChooseVehicleID[playerid])
	        {
				case 1: GetSalonVehParams(SalonCars1, sizeof(SalonCars1), veh, v);
				case 2: GetSalonVehParams(SalonCars2, sizeof(SalonCars2), veh, v);
				case 3: GetSalonVehParams(SalonCars3, sizeof(SalonCars3), veh, v);
				case 4: GetSalonVehParams(SalonCars4, sizeof(SalonCars4), veh, v);
			}
	        GetVehicleZAngle(veh[0], A);
	        GetVehiclePos(veh[0], X, Y, Z);
			PlayerTextDrawHide(playerid, tdChooseItemL);
			PlayerTextDrawHide(playerid, tdChooseItemR);
			if(veh[1] > 0)
			{
				PlayerTextDrawSetPreviewModel(playerid, tdChooseItemL, GetVehicleModel(veh[1]));
				PlayerTextDrawSetPreviewVehCol(playerid, tdChooseItemL, CarInfo[veh[1]][cColor1], CarInfo[veh[1]][cColor2]);
				PlayerTextDrawSetPreviewRot(playerid, tdChooseItemL, 0.0, 0.0, 30.0);
				PlayerTextDrawShow(playerid, tdChooseItemL);
			}
			if(veh[2] > 0)
			{
				PlayerTextDrawSetPreviewModel(playerid, tdChooseItemR, GetVehicleModel(veh[2]));
				PlayerTextDrawSetPreviewVehCol(playerid, tdChooseItemR, CarInfo[veh[2]][cColor1], CarInfo[veh[2]][cColor2]);
				PlayerTextDrawSetPreviewRot(playerid, tdChooseItemR, 0.0, 0.0, 30.0);
				PlayerTextDrawShow(playerid, tdChooseItemR);
			}
			new string[20];
			new Float:distance = 8.0;
		    new Float:X2 = X + (distance * floatsin(30-A, degrees));
		    new Float:Y2 = Y + (distance * floatcos(30-A, degrees));
			SetPlayerCameraLookAt(playerid, X, Y, Z);
			SetPlayerCameraPos(playerid, X2, Y2, Z+0.75);
			ChooseVehicleModel[playerid] = GetVehicleModel(veh[0]);
			new price = VehParams[ChooseVehicleModel[playerid]-400][VEH_PRICE];
			if(MyGetPlayerMoney(playerid) < price) string = "~r~"; else string = "~g~";
			format(string, 20, "%s%d$", string, price);
			PlayerTextDrawSetString(playerid, tdChoosePrice, string);
	    }
	    case 5:
	    {// Save vehicle
	    	new modelid = ChooseVehicleModel[playerid];
			if(!IsPlayerHaveLicThisVehicle(playerid, modelid)) //PlayerInfo[playerid][pCarLic] == 0)
			{
			    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� �������� �� ���� ���������.");
			    return 1;
			}
            new string[256];
	        new price = VehParams[modelid - 400][VEH_PRICE];
			format(string, sizeof(string), "SELECT COUNT(*) AS count FROM `cars` WHERE `type` = '1' AND `ownerid` = '%d'", PlayerInfo[playerid][pUserID]);
			new Cache:result = mysql_query(g_SQL, string);
			new cars;
			cache_get_value_name_int(0, "count", cars);
			cache_delete(result);
			if(cars >= 1)
			{
			    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ���� ������ ���������.");
			    return true;
			}
            if(MyGetPlayerMoney(playerid) < price)
				return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
            new vehicleid;
	        switch(ChooseVehicleID[playerid])
	        {
				case 1: vehicleid = MyCreateVehicle(modelid, 2127.473, -1149.66, 23.942, 345.0, 1, 1);
				case 2: vehicleid = MyCreateVehicle(modelid, 542.7104, -1281.82, 17.044, 270.0, 1, 1);
				case 3: vehicleid = MyCreateVehicle(modelid, -1642.71, 1210.973, 6.8011, 225.0, 1, 1);
				case 4: vehicleid = MyCreateVehicle(modelid, -1970.56, 302.4297, 34.796, 180.0, 1, 1);
			}
		    new Float:X, Float:Y, Float:Z;
			result = mysql_query(g_SQL, "INSERT INTO `cars`() VALUES()");
			MyGivePlayerMoney(playerid, -price);
			GetVehiclePos(vehicleid, X, Y, Z);
			CarInfo[vehicleid][cID] = cache_insert_id();
			CarInfo[vehicleid][cType] = C_TYPE_PLAYER;
			CarInfo[vehicleid][cOwnerID] = PlayerInfo[playerid][pUserID];
			CarInfo[vehicleid][cModel] = modelid;
			CarInfo[vehicleid][cMileage] = random(150)/10;
			CarInfo[vehicleid][cX] = 0.0;
			CarInfo[vehicleid][cY] = 0.0;
			UpdateVehicleStatics(vehicleid);

			cache_delete(result);

			SendClientMessage(playerid, COLOR_SAYING, "- �������� �������: ��� ��������� ����������� � �����. �� �������� ������������� ��� (/veh park)");
			ShowPlayerGPSPoint(playerid, X, Y, Z);
			ChoosePlayerVehicle(playerid, 0);

			#if defined _system_ucp_news_included
			    PushNews(playerid, NEWS_TYPE_CAR_PURCHASE, modelid);
			#endif
	    }
	}
	return 1;
}

MyShowPlayerDialog(playerid, dialogid, style, caption[], info[], button1[], button2[] = "", dtl = 60)
{
	if(dialogid != INVALID_DIALOGID && Dialogid[playerid] != INVALID_DIALOGID)
	{
		return true;
	}
	if(!strlen(caption) || !strlen(info))
	{
		return true;
	}
	Dialogid[playerid] = dialogid;
	DialogTimeleft[playerid] = dtl;
	return ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2);
}

MyHidePlayerDialog(playerid)
{
	Dialogid[playerid] = INVALID_DIALOGID;
	DialogTimeleft[playerid] = 0;
	ShowPlayerDialog(playerid, Dialogid[playerid], DIALOG_STYLE_MSGBOX, " ", " ", " ", " ");
}

//////
Public: gzgodmode(playerid, time)
{
	new string[128];
	if(time != 0)
	{
		gzGodMode[playerid] = time+1;
		MySetPlayerHealth(playerid, 100000);
	}
	if(--gzGodMode[playerid] > 0)
	{
		format(string, 128, "~r~Spawn protect~n~off");
		MySetPlayerHealth(playerid, 100.0);
	}
	else
	{
	    gzGodMode[playerid] = 0;
		format(string, 128, "~r~Spawn protect~n~~w~%d", gzGodMode[playerid]);
		SetTimerEx("gzgodmode", 900, false, "ii", playerid, 0);
	}
	GameTextForPlayer(playerid, string, 3000, 4);
}

ColorMenuShow(playerid)
{
	for(new i = 0; i <= 66; i++)	TextDrawShowForPlayer(playerid, PayNSprayColorMenu[i]);
    SelectTextDraw(playerid, COLOR_SERVER);
	PlayerSelectVCFM[playerid] = true;
	return true;
}

ColorMenuHide(playerid)
{
    for(new i = 0; i <= 66; i++)	TextDrawHideForPlayer(playerid, PayNSprayColorMenu[i]);
    CancelSelectTextDraw(playerid);
    PlayerSelectVCFM[playerid] = false;
	return true;
}

//---
stock	IsPlayerInGreenZoneVW(playerid)
{
	new vw = GetPlayerVirtualWorld(playerid);
	switch(vw)
	{
		case VW_AIRPORT,VW_LSPD, VW_FBI, VW_BANK, VW_CNN, VW_CITYHALL,
			VW_HOSPITAL, VW_HOTEL, VW_AUTOSCHOOL:	return true;
	}
	return false;
}

//---
Public: PlayerCameraBehind(playerid)
{
	SetCameraBehindPlayer(playerid);
	return true;
}

stock TogglePlayerNickname(playerid, toggle)
{
	if(toggle)
	{
		foreach(LoginPlayer, i)
		{
			MySetPlayerMarkerForPlayer(i, playerid, GetPlayerColor(playerid));
			if(pNameTags[i] == true) ShowPlayerNameTagForPlayer(i, playerid, true);
		}
	}
	else
	{
		foreach(LoginPlayer, i)
		{
			MySetPlayerMarkerForPlayer(i, playerid, (GetPlayerColor(playerid) & 0xFFFFFF00));
			ShowPlayerNameTagForPlayer(i, playerid, false);                          // ������! �������� ���!
		}
	}
	return true;
}

//  Inventory
Public: OnPlayerWearAcsr(playerid, thing)
{
	switch(thing)
	{
		case THING_GLASS:	//	����
		{
			PlayerAction(playerid, "�������� ����.");
		}
		case THING_MASK:	//	������� �� ����
		{
			TogglePlayerNickname(playerid, false);
			InMask[playerid] = true;
			PlayerAction(playerid, "�������� ������� �� ����.");
		}
		case THING_MUSIC:	//	��������
		{
			callcmd::radio(playerid, "");
			PlayerAction(playerid, "�������� ��������.");
			ShowPlayerHint(playerid, "��� ������ ������������ ����������� ~y~/radio");
		}
		case THING_HELMET:	//	����
		{
			TogglePlayerNickname(playerid, false);
			InMask[playerid] = true;
			PlayerAction(playerid, "�������� ����.");
		}
		case THING_HAT:		//	������
		{
			PlayerAction(playerid, "�������� ������.");
		}
	}
	return true;
}

Public: OnPlayerRemoveAcsr(playerid, thing)
{
	switch(thing)
	{
		case THING_GLASS:	//	����
		{
			//PlayerAction(playerid, "������� ����.");
		}
		case THING_MASK:	//	������� �� ����
		{
			TogglePlayerNickname(playerid, true);
			InMask[playerid] = false;
			//PlayerAction(playerid, "������� ������� � ����.");
		}
		case THING_MUSIC:	//	��������
		{
			//PlayerAction(playerid, "������� ��������.");
			DeletePVar(playerid, "Thing:RadioID");
			UpdatePlayerRadio(playerid);
		}
		case THING_HELMET:	//	����
		{
			TogglePlayerNickname(playerid, true);
			InMask[playerid] = false;
			//PlayerAction(playerid, "������� ����.");
		}
		case THING_HAT:		//	������
		{
			//PlayerAction(playerid, "������� ������.");
		}
	}
	return true;
}

stock MySetPlayerCheckpoint(playerid, type, Float:X, Float:Y, Float:Z, Float:size)
{
	MyDisablePlayerCheckpoint(playerid);
	gCheckpoint[playerid] = CreateDynamicCP(X, Y, Z, size, -1, -1, playerid, 150.0);
	gMapIcon_CP[playerid] = CreateDynamicMapIcon(X, Y, Z, 0, 0xAA0000FF, -1, -1, playerid, 10000.0, MAPICON_GLOBAL);
	gType_CP[playerid] = type;
	return gCheckpoint[playerid];
}

stock MyGetPlayerCheckpointPos(playerid, &Float:X, &Float:Y, &Float:Z)
{
	if(IsValidDynamicCP(gCheckpoint[playerid]))
	{
		Streamer_GetFloatData(STREAMER_TYPE_CP, gCheckpoint[playerid], E_STREAMER_X, X);
		Streamer_GetFloatData(STREAMER_TYPE_CP, gCheckpoint[playerid], E_STREAMER_Y, Y);
		Streamer_GetFloatData(STREAMER_TYPE_CP, gCheckpoint[playerid], E_STREAMER_Z, Z);
		return true;
	}
	return false;
}

stock GetDynamicPickupPos(pickupid, &Float:X, &Float:Y, &Float:Z)
{
	if(IsValidDynamicPickup(pickupid))
	{
		Streamer_GetFloatData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_X, X);
		Streamer_GetFloatData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_Y, Y);
		Streamer_GetFloatData(STREAMER_TYPE_PICKUP, pickupid, E_STREAMER_Z, Z);
		return true;
	}
	return false;
}

stock MyDisablePlayerCheckpoint(playerid)
{
	DestroyDynamicCP(gCheckpoint[playerid]), gCheckpoint[playerid] = INVALID_STREAMER_ID;
	DestroyDynamicMapIcon(gMapIcon_CP[playerid]), gMapIcon_CP[playerid] = INVALID_STREAMER_ID;
	gType_CP[playerid] = CPMODE_NONE;
	return true;
}

stock IsPlayerActiveGPS(playerid)
{
	return (gps_Data[playerid][GPS_CP] ? true : false);
}

stock ShowPlayerGPSPoint(playerid, Float:X, Float:Y, Float:Z, Float:size = 3.0)
{
	HidePlayerGPSPoint(playerid);
	gps_Data[playerid][GPS_POS][0] = X;	gps_Data[playerid][GPS_POS][1] = Y;	gps_Data[playerid][GPS_POS][2] = Z;
	gps_Data[playerid][GPS_CP] = CreateDynamicCircle(X, Y, size, -1, -1, playerid);
	gps_Data[playerid][GPS_MAP] = CreateDynamicMapIcon(X, Y, Z, 0, COLOR_GPS, -1, -1, playerid, 10000.0, MAPICON_GLOBAL_CHECKPOINT);
	return gps_Data[playerid][GPS_CP];
}

stock HidePlayerGPSPoint(playerid)
{
	DestroyDynamicArea(gps_Data[playerid][GPS_CP]), 	gps_Data[playerid][GPS_CP] = INVALID_STREAMER_ID;
	DestroyDynamicMapIcon(gps_Data[playerid][GPS_MAP]), gps_Data[playerid][GPS_MAP] = INVALID_STREAMER_ID;
	DestroyDynamicObject(gps_Data[playerid][GPS_OBJ]), 	gps_Data[playerid][GPS_OBJ] = INVALID_STREAMER_ID;
	return true;
}

Public: StopVehicleFire(playerid)
{
	new Float:A,
		vehicleid = GetPlayerVehicleID(playerid);
	burning_timer[playerid] = 0;
	MySetVehicleHealth(vehicleid, 300.0);
	GetVehicleZAngle(vehicleid, A);
	SetVehicleZAngle(vehicleid, A);
	PlayerPlaySound(playerid, 30800, 0.0, 0.0, 0.0);
	GameTextForPlayer(playerid, "~g~!!!FIRE FIRE FIRE!!!~n~Puted out!", 3000, 4);
	return true;
}

stock GetPlayeridToUserID(userid)
{
	foreach(LoginPlayer, i)
	{
		if(PlayerInfo[i][pUserID] == userid)
		{
			return i;
		}
	}
	return INVALID_PLAYER_ID;
}

SendConfirmMail(playerid, mail[])
{
	new buffer[256];
	format(buffer, sizeof buffer, "code="SECRET_CODE"&userid=%d&mail=%s", PlayerInfo[playerid][pUserID], mail);
	HTTP(playerid, HTTP_POST, CONFIRM_MAIL_URL, buffer, "OnSendConfirmMailResponse");
}

Public: OnSendConfirmMailResponse(index, response_code, data[])
{
	return true;
}

GetPlayerEmail(playerid)
{
	new query[128];
	format(query, 128, "SELECT `email` FROM `players` WHERE `id` = '%d'", PlayerInfo[playerid][pUserID]);
	new Cache:result = mysql_query(g_SQL, query);
	cache_get_value_index(0, 0, query);
	cache_delete(result);
	if(!strcmp(query, "NULL", true))	query = "";
	return query;
}

//	---
CreateGotoSmoke(playerid)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	DeletePVar(playerid, "Player:GotoSmoke:Timer");
	DestroyDynamicObject(GotoObject[playerid]);
	GotoObject[playerid] = CreateDynamicObject(18737, X, Y, Z - 2.6, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid));
	SetPVarInt(playerid, "Player:GotoSmoke:Timer", SetTimerEx("DestroyGotoSmoke", 3000, false, "i", playerid));
}

Public: DestroyGotoSmoke(playerid)
{
	DestroyDynamicObject(GotoObject[playerid]);
	GotoObject[playerid] = INVALID_STREAMER_ID;
	return 1;
}

KickEx(playerid)
{
	Iter_Remove(LoginPlayer, playerid);
	return SetTimerEx("KickPlayer", 1000, 0, "d", playerid);  //	Fix kick
}

Public: KickPlayer(playerid)
{
	return Kick(playerid);
}

///////	WEAPON SYSTEM
GetWeaponSlot(weaponid)
{
    if(0 <= weaponid < sizeof(GunParams) && GunParams[weaponid][GUN_EXIST])
    {
        return GunParams[weaponid][GUN_SLOT];
    }
    return 255;
}

stock MyChangePlayerWeapon(playerid, bool:status)
{	//	status: true - ��������� � ���������, false - ������� � ��������
	if(gWeaponStatus{playerid} == status)
	{
		return false;	//	������ ��� ������� ���������� ��� ������������ ������
	}
	gWeaponStatus{playerid} = status;
	/*if(gWeaponStatus{playerid})
	{
		for(new i = 0; i < 13; i++)
		{
			gWeaponID[playerid][i]		= MyGetPlayerWeaponID(playerid, i);
			gWeaponAmmo[playerid][i]	= MyGetPlayerWeaponAmmo(playerid, i);
		}
		MyResetPlayerWeapons(playerid);
	}
	else
	{
		MyResetPlayerWeapons(playerid);
		for(new i = 0; i < 13; i++)
		{
			if(gWeaponID[playerid][i] == 0)	continue;
			MyGivePlayerWeapon(playerid, gWeaponID[playerid][i], gWeaponAmmo[playerid][i]);
			gWeaponID[playerid][i] = 0,	gWeaponAmmo[playerid][i] = 0;
		}
	}*/
	SetPlayerArmedWeapon(playerid, 0);
	return true;
}

//---
Public: SyncRopeAnim(playerid)
{
	if(GetPVarInt(playerid, "Roped") == 0) return 0;
	ApplyAnimation(playerid, "ped", "abseil", 4.0, 0, 0, 0, 1, 0);
	SetTimerEx("SyncRopeAnim", 250, false, "i", playerid);
	return true;
}

//  breaking system
Public: BreakCar(playerid, type, step)
{
	if(Job.GetPlayerJob(playerid) != JOB_THEFT)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ������� ����� ���������� ������.");
	}
	new v = GetPVarInt(playerid, "LastLockCar");
	if(v == 0)	return false;
	if(type == BREAK_CAR_B_GLASS) //  �������� ���� ����� �������� ������
	{
		if(step == 0)
		{
			DeletePVar(playerid, "StartLockTimer");
			new Float:carX, Float:carY, Float:carZ;
			GetVehiclePos(v, carX, carY, carZ);
	        if(IsPlayerInRangeOfPoint(playerid, 3, carX, carY, carZ) && VehInfo[v][vLocked] == 1)
			{
				new Float:plX, Float:plY, Float:plZ, Float:carA;
				GetVehicleZAngle(v, carA);
				GetPlayerPos(playerid, plX, plY, plZ);
			    new A = floatround(floatabs(atan2(carX - plX, carY - plY) + carA));
				if(A > 360) A -= 360;
				if((A >= 65 && A <= 120) || (A >= 235 && A <= 285))
				{
					if(MyApplyAnimation(playerid, "FIGHT_D", "FightD_3", 10.0, 0, 1, 0, 0, BREAK_CAR_GLASS_TIME, 1))
					{
						SetPVarInt(playerid, "BreakCarTimer", SetTimerEx("BreakCar", BREAK_CAR_GLASS_TIME, 0, "ddd", playerid, BREAK_CAR_B_GLASS, 1 ));
						SetPVarInt(playerid, "BreakCarGlass", 1);
					}
				}
				else    ShowPlayerHint(playerid, "~w~��� ������ ��������� � ����� �� ������");
			}
			else	DeletePVar(playerid, "LastLockCar");
			return true;
		}
		else if(step == 1)
		{
			if(!GetPVarInt(playerid, "BreakCarGlass"))
			    return false;
			PlayerPlaySound(playerid, 1009, 0.0, 0.0, 0.0);  // 1095, 1140
			setVehicleAlarm(v, true, 30);
		 	switch(random(10))
		 	{
		 	    case 0..6:
				{//	�� ���������
					if(MyApplyAnimation(playerid, "FIGHT_D", "FightD_3", 4.1, 0, 1, 1, 0, BREAK_CAR_GLASS_TIME, 1))
					{
						SetPVarInt(playerid, "BreakCarTimer", SetTimerEx( "BreakCar", BREAK_CAR_GLASS_TIME, 0, "ddd", playerid, BREAK_CAR_B_GLASS, 1));
					}
					return true;
				}
				default:
				{//	���������
		            CrimePlayer(playerid, CRIME_HOOLIGAN);
					clearBreakGlassCar(playerid);
				}
		 	}
		}
	}
	else if(type == BREAK_CAR_HACKING) //  ����� ���� � ��������
	{
	    if(step == 0 && GetPlayerComb(playerid) == COMB_NONE)
	    {   //  ������ ������
			DeletePVar(playerid, "StartLockTimer");
			new Float:carX, Float:carY, Float:carZ;
			GetVehiclePos(v, carX, carY, carZ);
	        if(IsPlayerInRangeOfPoint(playerid, 3, carX, carY, carZ) && VehInfo[v][vLocked] == 1)
			{
				new Float:plX, Float:plY, Float:plZ, Float:carA;
				GetVehicleZAngle(v, carA);
				GetPlayerPos(playerid, plX, plY, plZ);
			    new A = floatround(floatabs(atan2(carX - plX, carY - plY) + carA));
				if(A > 360) A -= 360;
				if((A >= 65 && A <= 120) || (A >= 235 && A <= 285))
				{
					//stmp = "~r~";
					//new bool:comb[BREAK_CAR_CODE_LEN];
					//for(new i; i < BREAK_CAR_CODE_LEN; i++)
					//{
					//	if((VehInfo[v][vBitHack] >> i ^ 0) & 1) comb[i] = false;
					//	else 									comb[i] = true;
					//}
					
					new start[6], len[6];
					for(new i = 0; i < 6; i++)
					{
						len[i] = 10 + random(30);
						start[i] = random(100 - len[i]);
					}
					SetPlayerHackLock(playerid, start, len);

					//ShowPlayerHint(playerid, "~w~��� ������ ������������� ������� ����� � ������~n~(~y~Num 4~w~ � ~y~Num 6~w~)");
				}
				else    ShowPlayerHint(playerid, "~w~��� ������ ��������� � ����� �� ������");
			}
			else	DeletePVar(playerid, "LastLockCar");
			return true;
	    }
		else if(step == 1)
		{   //  ������
			clearHackCar(playerid);
			SuccesAnim(playerid);
		}
	}
	else if(type == BREAK_CAR_ENGINE) //  ����� ��������� ����������
	{
		if(step == 0)
		{
		    new time = 700 + (random(5) + 1) * 100;
		    SetPVarInt( playerid, "BreakEngineTimer", SetTimerEx("BreakCar", time, false, "ddd", playerid, BREAK_CAR_ENGINE, 1));
			GameTextForPlayer(playerid, "~w~Breaking engine...", time, 4);
		}
		else if(step == 1)
		{
		    if(random(4) == 0)
			{
                PlayerAction(playerid, "��������� ������� ����� ���������.");
                StartEngine(v, true);	//  ��������
			}
      		else
      		{
				switch(random(5))
				{
					case 1:	callcmd::lights(playerid, "");	//  ���������/���������� ����
					case 2:
					{	//  ������ ����� (��-10, ���� �������������, ������� ����� ��� ��� ������������)
						MySetPlayerHealth(playerid, MyGetPlayerHealth(playerid) - 10.0);
						FadeColorForPlayer(playerid, 255, 0, 0, 100, 255, 0, 0, 0, 10);
						PlayerPlaySound(playerid, 6402, 0.0, 0.0, 0.0);
					}
					case 3:
					{	//  ���������/���������� ������������
						if(getVehicleAlarm(v))	setVehicleAlarm(v, false);
						else
						{
						    foreach(Cop, copid)
						    {
								if(GetDistanceBetweenPlayers(playerid, copid) <= 50 && GetPlayerState(copid) != PLAYER_STATE_SPECTATING)
								{
								    CrimePlayer(playerid, CRIME_THEFT_AUTO);
								    ShowPlayerHint(playerid, "������������ ��������� �������� ������������ ������ �������");
									break;
								}
							}
							setVehicleAlarm(v, true, 30);
						}
					}
					case 4:
					{	//  ��������� ��������
				        if(GetVehicleBoot(v) == false)
						{
							SetVehicleBoot(v, true);
						}
					}
				}
				GameTextForPlayer(playerid, "~r~Failed...", 1000, 4);
		    }
		    DeletePVar(playerid, "LastLockCar");
		    DeletePVar(playerid, "BreakEngineTimer");
		}
		return true;
	}
	else	
	{
		return false;
	}
	//  ������� �������/������ ������
	GameTextForPlayer(playerid, "~w~Vehicle ~g~Unlocked", 3000, 4);
	VehInfo[v][vLocked] = 0;
    UpdateVehicleParamsEx(v);
	return true;
}

stock clearBreakGlassCar(playerid)
{
	DeletePVar(playerid, "BreakCarGlass");
	DeletePVar(playerid, "LastLockCar");
	return true;
}

stock clearHackCar(playerid)
{
 	//ClearAnimations(playerid);
    DeletePVar(playerid, "LastLockCar");
	return true;
}

public	OnActorReaction(playerid, targetid)
{
	new string[128];
	// �� ������� �� ������ //
	if(targetid == ACTOR[A_EMMET])
	{
	    if(IsGang(PlayerInfo[playerid][pFaction]))
	    {
		    return ShowDialog(playerid, DNPC_EMMET);
	    }
	}

#if defined	_job_job_theft_included
	else if(targetid == ACTOR[A_AUTOTHEFT])
	{
		return Dialog_Show(playerid, Dialog:Theft_Main);
	}
#endif	

	/*else if(targetid == ACTOR[A_GUNDEAL])
	{
		//if(PlayerInfo[playerid][pGunDealLic] == 0)
		//{// [BT] �������� ���������, ���� ��� �����
		//	SendLocalMessage(targetid, playerid, "��� ������ ������ ��� ���������� ������� ����� �� ������ �����");
		//	return true;
		//}
		if(!IsAvailableJob(playerid, JOB_GUNDEAL))
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ���������� �� ������ �������� � ���� �������.");
			return true;
		}
		if(PlayerInfo[playerid][pLevel] < 4)
		{
	        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������ �������� ������ � 4 ������.");
			return true;
		}
		//if(Job.GetPlayerJob(playerid) != JOB_NONE)
		//{// ����� ������ ���� �������� �� ��������
		//	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��� ��������� ���-��.");
		//}
		if(Job.GetPlayerJob(playerid) == JOB_GUNDEAL)
		{
			SendLocalMessage(targetid, playerid, "������ ������ � ������������� ��� �� ������. ��� ����������� ������� � ���������� (/gps)");
			return true;
		}
		if(MyGetPlayerMoney(playerid) < 500)
		{
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �� ������� ����� ��� ������� ���� ������ (500$).");
		}
		if(AskPlayer(INVALID_PLAYER_ID, playerid, ASK_INVITE_JOB, 60))
		{
			AskAmount[playerid] = JOB_GUNDEAL;
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "�� ��������� ���������� {FFFFFF}��������� ������ "ASK_CONFIRM_INFO);
			SendClientMessage(playerid, COLOR_LIGHTRED, "��� ���������� �� ������� ����� ��������� ���������� $500!");	//	��������
			if(Job.GetPlayerJob(playerid) != JOB_NONE) SendClientMessage(playerid, COLOR_LIGHTRED, "���� �������� ������ ���������, ���� �� �����������!");
			return 1;
		}
		else
		{
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������� ��� ��������� ������� ������.");
		}
	}
	else if(targetid == ACTOR[A_DRUGDEAL])
	{
		//if(PlayerInfo[playerid][pDrugDealLic] == 0)
		//{// [BT] �������� ���������, ���� ��� �����
		//	SendLocalMessage(targetid, playerid, "��� ������ ������ ��� ���������� Yakuza �� ������ �����");
		//	return true;
		//}
		if(!IsAvailableJob(playerid, JOB_DRUGDEAL))
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ���������� �� ������ �������� � ���� �������.");
			return true;
		}
		if(PlayerInfo[playerid][pLevel] < 4)
		{
	        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������ �������� ������ � 4 ������.");
			return true;
		}
		//if(Job.GetPlayerJob(playerid) != JOB_NONE)
		//{
		//	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��� ��������� ���-��.");
		//}
		if(Job.GetPlayerJob(playerid) == JOB_DRUGDEAL)
		{
			SendLocalMessage(targetid, playerid, "������ �������� � ������������� �� �� ������. ��� ����������� ������� � ���������� (/gps).");
			return true;
		}
		if(MyGetPlayerMoney(playerid) < 500)
		{
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �� ������� ����� ��� ������� ���� ������ (500$).");
		}
		if(AskPlayer(INVALID_PLAYER_ID, playerid, ASK_INVITE_JOB, 60))
		{
			AskAmount[playerid] = JOB_DRUGDEAL;
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "�� ��������� ���������� {FFFFFF}������������� "ASK_CONFIRM_INFO);
			SendClientMessage(playerid, COLOR_LIGHTRED, "��� ���������� �� Yakuza ��������� ���������� $500!");	//	��������
			if(Job.GetPlayerJob(playerid) != JOB_NONE) SendClientMessage(playerid, COLOR_LIGHTRED, "���� �������� ������ ���������, ���� �� �����������!");
			return 1;
		}
		else
		{
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������� ��� ��������� ������� ������.");
		}
	}*/

	else if(targetid == ACTOR[A_AUTOSCHOOL])
	{
		return true;
	}
	else if(targetid == ACTOR[A_BANK])	//	������
	{
		return ShowDialog(playerid, DMODE_BANK);
	}
	else if(targetid == ACTOR[A_CITYHALL2])	//	���������������
	{
	    return ShowDialog(playerid, DMODE_JOBLIST);
	}
	else if(targetid == ACTOR[A_POLICE_DUTY])
	{
		if(PlayerInfo[playerid][pFaction] == F_POLICE)
		{
		    if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DRINK_SPRUNK)
		    {
		        SendLocalMessage(targetid, playerid, "���� �� ������� �����������, ��������� �����");
		        return true;
		    }

	        if(random(2)) 	SendLocalMessage(targetid, playerid, "������� ����� ���� ����� �������, ������");
	        else 			SendLocalMessage(targetid, playerid, "������ �� ��� ����� �������� ����?");

			playerDrink{playerid} = 5;
			playerDrinkCount{playerid} = 5;
			MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
			return true;
		}
		else
		{
			return ShowDialog(playerid, DMODE_POLICE_DUTY);
		}
	}
	else if(targetid == ACTOR[A_POLICE_DUTY2] || targetid == ACTOR[A_POLICE_DUTY3])
	{
		return true;
	}
	else if(targetid == ACTOR[A_HOSPITAL])
	{
		return ShowDialog(playerid, DMODE_HOSPITAL);
	}
	else if(targetid == ACTOR[A_HOTDOGER] || targetid == ACTOR[A_HOTDOGER2] || targetid == ACTOR[A_HOTDOGER3])
	{
		if(AskPlayer(INVALID_PLAYER_ID, playerid, ASK_BUY_HOTDOG, 30, targetid))
		{
			//AskAmount[playerid] = targetid;
			SendFormatMessage(playerid, COLOR_WHITE, string, "�������� ���������� ��� ������ ��� ��� �� 5$ "ASK_CONFIRM_INFO, ReturnPlayerName(playerid));
			return true;
		}
		else
		{
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ���� �� �������� ������, ���������� �����.");
		}
	}
	else if(targetid == ACTOR[A_NEWBIE])
	{
		if(mission_id[playerid] == MIS_HOTEL)
		{
			return SendLocalMessage(targetid, playerid, "���� ���� ����� �����, �� ���� � ���� �����������");
		}
		else if(mission_id[playerid] == MIS_TRAINING)
		{
			if(mission_step[playerid] == 0)			return ShowDialog(playerid, DMIS_TRAINING1);
			else if(mission_step[playerid] == 2)	return ShowDialog(playerid, DMIS_TRAINING2);
		}
	}

#if defined	_job_part_loader_included
	else if(targetid == ACTOR[A_DEREK])
	{
	    return Dialog_Show(playerid, Dialog:Loader_Main);
	}
#endif	

	else
	{
		for(new b = 0; b < MaxBiz; b++)
		{
			if(targetid == BizInfo[b][bActor])
			{
				if(BizInfo[b][bRobbery] != INVALID_PLAYER_ID)
				{
					return ShowPlayerHint(playerid, "���������� �� ����� ����������");
				}
				return ShowBizMenu(playerid, b);
			}
		}

		for(new i = 0; i < sizeof(ACTOR); i++)
		{
			if(ACTOR[i] == targetid && !ActorInfo[i][a_Hint])
			{
				return true;
			}
		}
	}
	// ��� ������� ������ //
	if(mission_id[playerid] == 0)
	{
		SendLocalMessage(targetid, playerid, "���� ��� ������ ���� �������, ������� �����");
	}
	else
	{
		switch(random(3))
	    {
			case 0: SendLocalMessage(targetid, playerid, "� ���� ���� ���� ��������");
			case 1: SendLocalMessage(targetid, playerid, "���� � ��� ����, ��� ��������");
			case 2: SendLocalMessage(targetid, playerid, "�������, ����� ����������� �� ������ ������");
		}
	}
	return true;
}

Public: MissionTimer(playerid)
{
	switch(mission_id[playerid])
	{
		case MIS_NONE: return 1;
		default:
		{
			if(mission_timer[playerid] > 0)
			{
				KillTimer(mission_timer[playerid]);
				mission_timer[playerid] = 0;
			}
		}
	}
	return 1;
}

//	Combs System
public OnPlayerSelectComb(playerid, source, bool:comb)
{
	switch(source)
	{
		case COMB_JAILJOB:
		{
			GameTextForPlayer(playerid, RusText("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~������...", isRus(playerid)), 1500, 3);
			return 1500;
		}
		case COMB_CREATE_GUN:
		{
			GameTextForPlayer(playerid, RusText("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~������...", isRus(playerid)), 1500, 3);
			return 2000;
		}
		case COMB_CREATE_DRUG:
		{
			GameTextForPlayer(playerid, RusText("~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~�����������...", isRus(playerid)), 1500, 3);
			return 2000;
		}
	}
	return 0;
}

public OnPlayerCombFinish(playerid, source, bool:fail)
{
	new string[128];
	switch(source)
	{
		case COMB_JAILJOB:
		{
			JailJobFinish(playerid, fail ? false : true);
		}
		case COMB_CREATE_GUN:
		{
			new mats = GetPVarInt(playerid, "GunDealMats"); DeletePVar(playerid, "GunDealMats");
  			new weapon = GetPVarInt(playerid, "GunDealWeapon"); DeletePVar(playerid, "GunDealWeapon");
  			new ammo = GetPVarInt(playerid, "GunDealAmmo"); DeletePVar(playerid, "GunDealAmmo");
  			ClearAnimations(playerid);
			if(fail)
			{
				GameTextForPlayer(playerid, "~r~ failed", 2000, 1);
				LoseAnim(playerid);
			}
			else
			{
	  			if(IsMafia(PlayerInfo[playerid][pFaction]))//Job.GetPlayerJob(playerid) != JOB_GUNDEAL)
	  			{
		    		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �������� ������.");
		    		LoseAnim(playerid);
		    		return false;
		    	}
				new count = Inv.GetThing(playerid, THING_GUN_MATS);
				if(count < mats)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������ ����������.");
					LoseAnim(playerid);
					return false;
				}
				Inv.PlayerDeleteThing(playerid, THING_GUN_MATS, 0, mats);
	    		format(string, sizeof(string), "������ ������ (%s)", ReturnWeaponName(weapon));
	    		PlayerAction(playerid, string);
				Inv.GivePlayerWeapon(playerid, weapon, ammo);
				SuccesAnim(playerid);
			}
			foreach(Cop, c)
			{
				if(GetDistanceBetweenPlayers(playerid, c) < 30.0)
				{
					CrimePlayer(playerid, CRIME_CREATE_GUN);
					break;
				}
			}
		}
		case COMB_CREATE_DRUG:
		{
			if(fail)
			{
				GameTextForPlayer(playerid, "~r~ failed", 2000, 1);
				LoseAnim(playerid);
			}
			else
			{
				if(IsMafia(PlayerInfo[playerid][pFaction]))//Job.GetPlayerJob(playerid) != JOB_DRUGDEAL)
				{
		    		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �����������.");
		    		LoseAnim(playerid);
		    		return false;
		    	}
		    	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2164.1, -249.25, 36.51))
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �� ����� �����������.");
					LoseAnim(playerid);
					return false;
		    	}
				new count = Inv.GetThing(playerid, THING_DRUGS_MATS);
		    	if(Inv.AddPlayerThing(playerid, THING_DRUGS, count * 10) == 0)
				{
					LoseAnim(playerid);
					return false;
				}
				Inv.PlayerDeleteThing(playerid, THING_DRUGS_MATS, 0, count);
				PlayerAction(playerid, "������������� ���������.");
			    SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "�� ������������ %d ����� � �������� %d ����������", count, count * 10);
			    SuccesAnim(playerid);
			}
			foreach(Cop, c)
			{
				if(GetDistanceBetweenPlayers(playerid, c) < 30.0)
				{
					CrimePlayer(playerid, CRIME_CREATE_DRUGS);
					break;
				}
			}
		}
	}
	return false;
}

//	Hospital
CancelPlayerBerth(playerid)
{
	if(GetPVarType(playerid, "Player:Hospital:Berth") == PLAYER_VARTYPE_INT)
	{
		new berth = GetPVarInt(playerid, "Player:Hospital:Berth");
		UpdateDynamic3DTextLabelText(Berth3DText[berth], COLOR_ACTION, "����� ��������\n" ACTION_TEXT);
		BerthStatus[berth] = false;
		if(IsPlayerLive(playerid))
		{
			ClearAnimations(playerid);
			MySetPlayerPos(playerid, Arr4<HospitalBerth[berth][1]>);
		}
		TogglePlayerStreamerAllItem(playerid, true);
		DeletePVar(playerid, "Player:Hospital:Berth");
		BlockPlayerAnimation(playerid, false);
	}
}

//---

stock UpdatePlayerGPSZone(playerid)
{
	PlayerTextDrawSetString(playerid, StatusGPS, GetPlayerArea(playerid));
}

//	Carry System
stock IsPlayerCarry(playerid)
{
	return IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_SLOT_IN_HAND);
}

stock CarryUP(playerid, objectid, Float:x, Float:y, Float:z, Float:rx = 0.0, Float:ry = 0.0, Float:rz = 0.0, Float:sx = 1.0, Float:sy = 1.0, Float:sz = 1.0)
{
	if(IsPlayerCarry(playerid))
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ���� ��� ������ ������ ���������.");
		return false;
	}
	KillTimer(CarryTimer[playerid]);
	MyApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0);
	CarryTimer[playerid] = SetPlayerTimerEx(playerid, "_CarryUP", 800, false, "iifffffffff", playerid, objectid, x, y, z, rx, ry, rz, sx, sy, sz);
	return true;
}

stock CarryUPEx(playerid, objectid, Float:x, Float:y, Float:z, Float:rx = 0.0, Float:ry = 0.0, Float:rz = 0.0, Float:sx = 1.0, Float:sy = 1.0, Float:sz = 1.0)
{
	if(IsPlayerCarry(playerid))
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ���� ��� ������ ������ ���������.");
		return false;
	}
	KillTimer(CarryTimer[playerid]);
	_CarryUP(playerid, objectid, x, y, z, rx, ry, rz, sx, sy, sz);
	return true;
}

Public: _CarryUP(playerid, objectid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:sx, Float:sy, Float:sz)
{
	MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	SetPlayerAttachedObjectEx(playerid, ATTACH_SLOT_IN_HAND, objectid, 1, x, y, z, rx, ry, rz, sx, sy, sz);
	return true;
}

stock CarryDown(playerid)
{
	KillTimer(CarryTimer[playerid]);
	MyApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);
	CarryTimer[playerid] = SetPlayerTimerEx(playerid, "_CarryDown", 500, false, "i", playerid);

	#if defined	_job_part_loader_included
		if(Job.GetPlayerNowWork(playerid) && GetTickCount() - LoaderTick[playerid] < 1000)
		{
			new string[128];
			format(string, 128, "[AdmCmd]: ������ ������ ������ %s[%d] �� ������� ������������� �� ����������", ReturnPlayerName(playerid), playerid);
			MySendClientMessageToAll(COLOR_LIGHTRED, string);
			format(string, sizeof(string), " (%d ��)", string, GetTickCount() - LoaderTick[playerid]), Admin_Log(string);
			KickEx(playerid);
		}
	#endif
}

Public: _CarryDown(playerid)
{
	KillTimer(CarryTimer[playerid]);
	MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND);

	#if defined	_job_part_loader_included
		if(LoaderStatus[playerid] && LoaderInfo[LE_STAGE] == 2)
	    {
	    	DestroyDynamicObject(LoaderObject[playerid]), LoaderObject[playerid] = INVALID_STREAMER_ID;
	        LoaderObject[playerid] = CreateDynamicObject(1271, 2144.89990, -2266.10010, 13.57710, 0.0, 0.0, 45.0);
	        MoveDynamicObject(LoaderObject[playerid], 2151.39990, -2272.60010, 13.57710, 1.0, 0.0, 0.0, 45.0);
			Loader_GiveMoney(playerid, 3);
			LoaderStatus[playerid] = false;
			Loader_UpdateMission(playerid);
	        //Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
		}
	#endif
	return true;
}

CarryClear(playerid)
{
	_CarryDown(playerid);
    ClearAnimations(playerid);
}

//	Jail job
JailJobClear(playerid)
{
	if(j_jobstep{playerid} == 0)
	{
		return false;
	}
	else if(j_jobstep{playerid} == 2)
	{
		IFace.ProgressBarHide(playerid);
		DestroyDynamicObject(j_JobObj[playerid]), j_JobObj[playerid] = INVALID_STREAMER_ID;
		RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND);

		new cp = GetPVarInt(playerid, "jail_job_cp");
		DeletePVar(playerid, "jail_job_cp");
		j_jobcp[cp] = CreateDynamicCP(Arr3<j_fJobPos[cp]>, 0.3, -1, 2, -1, 3.0);
	}
	else if(j_jobstep{playerid} == 11){
		DestroyDynamicMapIcon(j_MapIcon[playerid]), j_MapIcon[playerid] = INVALID_STREAMER_ID;
	}
	if(IsPlayerLive(playerid))	CarryClear(playerid);
	j_jobstep{playerid} = 0;
	return true;
}

Public: JailJobFinish(playerid, success)
{
    IFace.ProgressBarHide(playerid);
	RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND);
	DestroyDynamicObject(j_JobObj[playerid]), j_JobObj[playerid] = INVALID_STREAMER_ID;
	MyApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
	RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1);
    if(success == 1)
	{
		j_jobstep{playerid}++;
		SetPlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND, 2969, 1, 0.009, 0.344, -0.024, 0.0, 90.0, 0.0);
		MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		GameTextForPlayer(playerid, "~g~ successfully", 1000, 1);
		ShowPlayerHint(playerid, "~w~�������� ���� �� �����~n~(~y~������ ����� i~w~)");
	}
	else
	{
		j_jobstep{playerid} = 0;
		RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND);
		GameTextForPlayer(playerid, "~r~ failed", 1000, 1);
		SendClientMessage(playerid, COLOR_WHITE, "�� ������� ����������� �����, �������� ��� ��������� � ���������� �����!");
		LoseAnim(playerid);
	}
	new cp = GetPVarInt(playerid, "jail_job_cp");
	DeletePVar(playerid, "jail_job_cp");
	j_jobcp[cp] = CreateDynamicCP(Arr3<j_fJobPos[cp]>, 0.3, -1, 2, -1, 3.0);
	return true;
}

stock UpdateJailStorage()
{
    new stmp[128];
    format(stmp, sizeof stmp, "�����: %d ��.", j_Storage);
    UpdateDynamic3DTextLabelText(j_f3DText, 0xFF8300FF, stmp);
    UpdateDynamic3DTextLabelText(j_l3DText, 0xFF8300FF, stmp);
    return true;
}

Public: FineparkTimer()
{
	new Float:X, Float:Y, Float:Z;
	GetVehiclePos(FineparkVehicle, X, Y, Z);
	if(GetDistanceFromPointToPoint(X, Y, Z, 1576.9026, -1608.4280, 13.5) > 10)
	{// �����
	    if(IsVehicleWithEngine(FineparkVehicle) && GetVehicleEngine(FineparkVehicle) || !IsVehicleWithEngine(FineparkVehicle))
	    {// �������
		    KillTimer(finepark_timer), finepark_timer = 0;
		    DestroyDynamic3DTextLabel(Finepark3DText), Finepark3DText = Text3D:INVALID_STREAMER_ID;
		    if(VehInfo[ FineparkVehicle ][vDriver] != -1)
				ShowPlayerHint(VehInfo[ FineparkVehicle ][vDriver], "����������� ���������~n~�������� ~y~/veh park");
		    FineparkVehicle = 0;
		    return true;
	    }
	}
    if(FineparkCount <= 0)
    {	// ����� �������
        MySetVehicleToRespawn(FineparkVehicle);
        return true;
    }
    new string[32];
	format(string, 32, "��������: {FFFFFF}%d ���", FineparkCount);
	UpdateDynamic3DTextLabelText(Finepark3DText, 0x2641FEFF, string);
	FineparkCount--;
	return true;
}

Public: RecreateRepairPickup(p)
{
	if(0 <= p < sizeof(AutoRepairPos))
	{
		DestroyDynamicPickup(RepairPickup[p]), RepairPickup[p] = INVALID_STREAMER_ID;
		RepairPickup[p] = CreateDynamicPickup(3096, 14, Arr3<AutoRepairPos[p]>, 0);
	}
}

stock CreateSalon3DText(saloncars[], size, salonname[])
{
	new string[256], vehicleid, modelid;
	for(new x; x < size; x++)
	{
	    vehicleid = saloncars[x];
	    modelid = GetVehicleModel(vehicleid);
	    format(string, 256, "%s\n{8D8DFF}������: {FFFFFF}%s(%d)\n{8D8DFF}���������: {FFFFFF}%d$\n{8D8DFF}��������: {FFFFFF}��������", salonname, VehParams[modelid-400][VEH_NAME], modelid, VehParams[modelid-400][VEH_PRICE]);
		CreateDynamic3DTextLabel(string, 0x8D8DFFFF, 0.0, 0.0, 1.0, 100.0, INVALID_PLAYER_ID, vehicleid, 1, 0, -1, -1, 5.0);
		VehInfo[vehicleid][vLocked] = 999;
		VehInfo[vehicleid][vBlockMove] = true;
		UpdateVehicleParamsEx(vehicleid);
	}
}

GetSalonVehParams(saloncars[], size, veh[3], v)
{
	veh[0] = saloncars[v];
	veh[1] = (v > 0) ? saloncars[v - 1] : 0;
	veh[2] = (v < size - 1) ? saloncars[v + 1] : 0;
}

//---	TIR
CreateTirTarget(playerid, Float:x, Float:y, Float:z, Float:rx = 88.75)
{
	if(p_ShootingTargetObjects[playerid][0])
	{
		DestroyTirTarget(playerid);
	}
	p_ShootingTargetObjects[playerid][0] = CreatePlayerObject(playerid, 3025, x, y, z, rx, 0.0, 0.0, 70.0);
	z += 0.1;
	for(new i = 1; i < 8; i++)
		p_ShootingTargetObjects[playerid][i] = CreatePlayerObject(playerid, (3017 + i), x, y, z, rx, 0.0, 0.0, 70.0);	//	3018-3024
	return true;
}

MoveTirTarget(playerid, Float:x, Float:y, Float:z, Float:rx = 88.75, Float:speed = 0.05)
{
	if(p_ShootingTargetObjects[playerid][0])
	{
		MovePlayerObject(playerid, p_ShootingTargetObjects[playerid][0], x, y, z, speed, rx, 0.0, 0.0);
		z += 0.1;
		MovePlayerObject(playerid, p_ShootingTargetObjects[playerid][1], x, y, z, speed, rx, 0.0, 0.0);
		MovePlayerObject(playerid, p_ShootingTargetObjects[playerid][2], x, y, z, speed, rx, 0.0, 0.0);
		MovePlayerObject(playerid, p_ShootingTargetObjects[playerid][3], x, y, z, speed, rx, 0.0, 0.0);
		MovePlayerObject(playerid, p_ShootingTargetObjects[playerid][4], x, y, z, speed, rx, 0.0, 0.0);
		MovePlayerObject(playerid, p_ShootingTargetObjects[playerid][5], x, y, z, speed, rx, 0.0, 0.0);
		MovePlayerObject(playerid, p_ShootingTargetObjects[playerid][6], x, y, z, speed, rx, 0.0, 0.0);
		MovePlayerObject(playerid, p_ShootingTargetObjects[playerid][7], x, y, z, speed, rx, 0.0, 0.0);
		return true;
	}
	return false;
}

DestroyTirTarget(playerid)
{
	if(p_ShootingTargetObjects[playerid][0])
	{
		for(new i = 0; i < 8; i++)
		{
			DestroyPlayerObject(playerid, p_ShootingTargetObjects[playerid][i]);
			p_ShootingTargetObjects[playerid][i] = 0;
		}
		return true;
	}
	return false;
}

Public: MovePlayerTarget(playerid)
{
	if(PlayerInfo[playerid][pShooting] == 2)
	{
		MoveTirTarget(playerid, 293.2, -14.0, 1004.0, -1000.0, 1.0);
	}
	else if(PlayerInfo[playerid][pShooting] == 3)
	{
		if(p_ShootingWave{playerid} == 0)
			MoveTirTarget(playerid, 287.0, -6.0, 1004.0, -1000.0, 1.0);
		else if(p_ShootingWave{playerid} == 1)
			MoveTirTarget(playerid, 297.0, -10.0, 1004.0, -1000.0, 1.0);
		else if(p_ShootingWave{playerid} == 2)
			MoveTirTarget(playerid, 287.0, -14.0, 1004.0, -1000.0, 1.0);
	}
	return true;
}

StartPlayerTirShooting(playerid)
{
	if(PlayerInfo[playerid][pShooting] < 1 || PlayerInfo[playerid][pShooting] > 3)
		return false;
	new element = PlayerInfo[playerid][pShooting] - 1;
	p_ShootingWave{playerid} = -1;
	NextShootingTarget(playerid);
	SetPlayerVisualTimer(playerid, TirMissionInfo[element][TIR_TIME], true);
	IFace.ShowPlayerProgress(playerid, ((PlayerInfo[playerid][pShooting] - 1) * 3 * 7), (3 * 3 * 7), "Progress");
	GameTextForPlayer(playerid, "~g~Fire!", 1000, 6);
	return true;
}

Public: NextShootingTarget(playerid)
{
	if(++p_ShootingWave{playerid} < 3)
	{
		new element = PlayerInfo[playerid][pShooting] - 1;
		p_ShootingHits{playerid} = 0;
		CreateTirTarget(playerid, Arr3<TirTargetsPos[element][ p_ShootingWave{playerid} ]>);
		MoveTirTarget(playerid,	TirTargetsPos[element][ p_ShootingWave{playerid} ][0] + TIR_MODIFY_POS,
								TirTargetsPos[element][ p_ShootingWave{playerid} ][1],
								TirTargetsPos[element][ p_ShootingWave{playerid} ][2], 360.0);
		SetTimerEx("MovePlayerTarget", 1300, false, "d", playerid);
	}
	else
	{
		if(++PlayerInfo[playerid][pShooting] == 4)
			FinishPlayerShooting(playerid);
		else
		{
			DestroyTirTarget(playerid);
			p_ShootingCountdown{playerid} = 0;
			p_ShootingHits{playerid} = 0;
			p_ShootingWave{playerid} = 0;
			p_isShooting{playerid} = false;
			HidePlayerVisualTimer(playerid);
			IFace.ProgressBarHide(playerid);
			MySetPlayerPosFade(playerid, FT_TIR, 293.7, -24.6, 1001.5, 0.0, false, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
		}
	}
}

FinishPlayerShooting(playerid, bool:fail = false)
{
	DestroyTirTarget(playerid);
	IFace.ProgressBarHide(playerid);
	HidePlayerVisualTimer(playerid);
	MyChangePlayerWeapon(playerid, false);

	p_ShootingCountdown{playerid} = 0;
	p_ShootingHits{playerid} = 0;
	p_ShootingWave{playerid} = 0;
	p_isShooting{playerid} = false;
	PlayerBusy{playerid} = false;
	if(fail)
	{
		GameTextForPlayer(playerid, "~r~Mission Failed", 5000, 4);
		MySetPlayerPosFade(playerid, FT_NONE, 286.23, -30.22, 1001.51, 0.0, false, GetPlayerInterior(playerid), (GetPlayerVirtualWorld(playerid) - playerid - 1000));
		PlayerInfo[playerid][pShooting] = 1;
	}
	else
		MySetPlayerPosFade(playerid, FT_TIR_COMPLETE, 285.6, -32.9, 1001.5, 180.0, false, GetPlayerInterior(playerid), (GetPlayerVirtualWorld(playerid) - playerid - 1000));
	return true;
}

ClearPlayerShooting(playerid, bool:disconnect = false)
{	//	Call only OnPlayerDeath and OnPlayerDisconnect
	if(p_isShooting{playerid})
	{
		if(!disconnect)
		{	//	Change pos
			MyResetPlayerWeapons(playerid);
			HidePlayerVisualTimer(playerid);
		}
		DestroyTirTarget(playerid);
		p_ShootingCountdown{playerid} = 0;
		p_ShootingHits{playerid} = 0;
		p_ShootingWave{playerid} = 0;
		p_isShooting{playerid} = false;
		PlayerBusy{playerid} = false;
	}
	return true;
}

Public: ClearFreezeAnim(playerid)
{
	MyApplyAnimation(playerid, "MISC", "Idle_Chat_02", 4.1, 0, 0, 0, 0, 100);
}

//	Drink
Public: ClearPlayerDrink(playerid)
{
	playerDrink{playerid} = 0;
	playerDrinkCount{playerid} = 0;
	PlayerDrunkTime{playerid} = 0;
	MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
}

Public: ClearPlayerSmoke(playerid)
{
	playerSmokeCount{playerid} = 0;
	MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
}

//---	Missions
StoryMissionStart(playerid, source)
{
	new string[128];
	if(source == MIS_SOURCE_TRAINING)
	{
		switch(gMissionProgress[playerid][source])
		{
			case 0:
			{
				mission_id[playerid] = MIS_HOTEL;
				mission_step[playerid] = 0;
				mission_pickup[playerid] = CreateDynamicPickup(19624, 1, 1701.78, -2348.02, 13.50, VW_AIRPORT, 0, playerid);
				TogglePlayerMapIcon(playerid, false);
				if(!isRus(playerid))
				{
					MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "�������",
						"{FFFFFF}�������� ���� ������� � ����� ������ ������.", "�������", "", 0);
				}
				else
				{
					SendMissionMessage(playerid, "�������� ���� ������� � ����� ������ ������", 5000, true);
				}
			}
			case 1:
			{
				mission_id[playerid] = MIS_TRAINING;
				if(!isRus(playerid))
				{
					format(string, sizeof(string),
						"{FFFFFF}���������� � %s�� � �����\n\n\
						��� �������������� � ��������, ������, ��������\n\
						"MAIN_COLOR"����������� �� ��� � ������� H", ActorInfo[A_NEWBIE][a_Name]);
					MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "�������", string, "�������", "", 0);
				}
				else
				{
					ShowPlayerHint(playerid, "��� ~g~��������������~w~ � ��������, ������, �������� ~y~�����������~w~ � ������� ~y~H", 10000);
					format(string, sizeof(string), "���������� � ~y~%s��~w~ � �����", ActorInfo[A_NEWBIE][a_Name]);
					SendMissionMessage(playerid, string, 5000, true);
				}
			}
			case 2:
			{
				mission_id[playerid] = MIS_START_WORK;
				mission_cpnum[playerid] = MySetPlayerCheckpoint(playerid, CPMODE_MISSION, 2178.2883,-2255.1680,14.77, 2.0);
				if(MyGetPlayerMoney(playerid) < 300)
				{
					format(string, sizeof(string), "~n~~n~~n~����������� �� �����. ��������� ~g~%d/300$", MyGetPlayerMoney(playerid));
					SendMissionMessage(playerid, string, 5000);
				}
				if(!isRus(playerid))
				{
					MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "�������",
						"{FFFFFF}��� ������������ ��������� ��� ����� �����!\n\
						� ���� ���, �� ������ ����������� �� �������� ������.\n\
						"MAIN_COLOR"��������� ����� �� ���������� ��������� ��� ������", "�������", "", 0);
				}
				else
				{
					ShowPlayerHint(playerid, "~y~��� ������������ ��������� ��� ����� �����!~w~~n~~n~���� ��� �� ������ �������� �� ~r~�������� ������", 15000);
				}
			}
			case 3:
			{
			    if(PlayerInfo[playerid][pCarLic] == 0)
			    {
					mission_id[playerid] = MIS_GET_LICENSE;
					mission_cpnum[playerid] = MySetPlayerCheckpoint(playerid, CPMODE_MISSION, 725.65, -1440.13, 13.53, 2.0);
					if(!isRus(playerid))
					{
						MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "�������",
							"{FFFFFF}���������� �� ��������� � �������� �����", "�������", "", 0);
					}
					else
					{
						SendMissionMessage(playerid, "���������� �� ��������� � �������� �����", 5000, true);
					}
				}
				else
				{
					gMissionProgress[playerid][source] += 2;
				}
			}
		}
	}
}

Public: StoryMissionComplete(playerid, source, money, exp)
{
	new string[128];
    gMissionProgress[playerid][source]++;
    format(string, 128, "Mission Passed~n~~w~");
    if(exp > 0)
	{
		format(string, 128, "%s+%d exp", string, exp);
	    GivePlayerEXP(playerid, exp);
	}
	if(money > 0)
	{
		format(string, 128, "%s   +%d$", string, money);
	    MyGivePlayerMoney(playerid, money);
	}
    GameTextForPlayer(playerid, string, 8000, 4);
    PlayAudioStreamForPlayer(playerid, AUDIOFILE_PATH "/complete.mp3");
    StoryMissionCancel(playerid);
    UpdatePlayerStatics(playerid);
}

stock StoryMissionCancel(playerid)
{
	if(mission_id[playerid] > 0)
	{
		DestroyDynamicMapIcon(mission_mapicon[playerid][0]), 		mission_mapicon[playerid][0] = INVALID_STREAMER_ID;
		DestroyDynamicMapIcon(mission_mapicon[playerid][1]), 		mission_mapicon[playerid][1] = INVALID_STREAMER_ID;
		DestroyDynamicMapIcon(mission_mapicon[playerid][2]), 		mission_mapicon[playerid][2] = INVALID_STREAMER_ID;
		DestroyPlayerObject(playerid, mission_pobject[playerid]), 	mission_pobject[playerid] = INVALID_STREAMER_ID;
		DestroyDynamicPickup(mission_pickup[playerid]), 			mission_pickup[playerid] = INVALID_STREAMER_ID;
		if(mission_veh[playerid] > 0)								MyDestroyVehicle(mission_veh[playerid]), mission_veh[playerid] = 0;
		if(mission_timer[playerid] > 0)								KillTimer(mission_timer[playerid]), mission_timer[playerid] = 0;
		if(gType_CP[playerid] == CPMODE_MISSION)					MyDisablePlayerCheckpoint(playerid);
		RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND);
		IFace.ProgressBarHide(playerid);
		IFace.HidePlayerInfoBar(playerid);
		//PlayerTextDrawHide(playerid, InfoBar);
		HideMissionMessage(playerid);
		HideMissionInfo(playerid);
		TogglePlayerMapIcon(playerid, true);
		//
		mission_id[playerid] = 0;
		mission_step[playerid] = 0;
		mission_count[playerid] = 0;
		mission_cpnum[playerid] = 0;
	}
}

stock MySetActorPos(slot, Float:x, Float:y, Float:z, Float:a)
{
	if(slot < 0 || slot >= sizeof(ACTOR))	return false;

	SetActorPos(ACTOR[slot], x, y, z);
	SetActorFacingAngle(ACTOR[slot], a);

	Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ActorNametag[slot], E_STREAMER_X, x);
	Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ActorNametag[slot], E_STREAMER_X, y);
	Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ActorNametag[slot], E_STREAMER_X, z + 1.0);
	return true;
}

stock TogglePlayerMapIcon(playerid, bool:toggle)
{
	g_TogleMapIcon[playerid] = toggle;
	if(g_TogleMapIcon[playerid])
	{
		for(new i; i < sizeof(StaticMapIcon); i++)
			Streamer_AppendArrayData(STREAMER_TYPE_MAP_ICON, static_MapIconID[i], E_STREAMER_PLAYER_ID, playerid);
		for(new b; b < MaxBiz; b++)
			Streamer_AppendArrayData(STREAMER_TYPE_MAP_ICON, BizInfo[b][bMapIcon], E_STREAMER_PLAYER_ID, playerid);
	}
	else
	{
		for(new i; i < sizeof(StaticMapIcon); i++)
			Streamer_RemoveArrayData(STREAMER_TYPE_MAP_ICON, static_MapIconID[i], E_STREAMER_PLAYER_ID, playerid);
		for(new b; b < MaxBiz; b++)
			Streamer_RemoveArrayData(STREAMER_TYPE_MAP_ICON, BizInfo[b][bMapIcon], E_STREAMER_PLAYER_ID, playerid);
	}
	Streamer_Update(playerid, STREAMER_TYPE_MAP_ICON);
}

stock UpdatePlayerColor(playerid)
{
	if(!IsPlayerLogged(playerid))
	{
		SetPVarString(playerid, "color", "AFAFAF");
		SetPlayerColor(playerid, COLOR_GREY);
	}
	else if(PlayerInfo[playerid][pFaction] == F_POLICE && IsPoliceDuty(playerid))
	{
		//new vehicleid = GetPlayerVehicleID(playerid);
		//if(vehicleid > 0 && VehInfo[vehicleid][vSiren])	SetPlayerColor(playerid, 0x2641FEFF);
		//else 											SetPlayerColor(playerid, 0x2641FEFF & 0xFFFFFF00);
		SetPlayerColor(playerid, 0x2641FEFF);
		SetPVarString(playerid, "color", "2641FE");
	}
	else if(IsGang(PlayerInfo[playerid][pFaction]))
	{
		SetPVarString(playerid, "color", GetGangColorRGB(PlayerInfo[playerid][pFaction]));
		SetPlayerColor(playerid, GetGangColor(PlayerInfo[playerid][pFaction]));
	}
	else if(Job.GetPlayerNowWork(playerid) == JOB_TAXI)
	{
		SetPlayerColor(playerid, COLOR_YELLOW);
	}
	else
	{
		SetPVarString(playerid, "color", "");
		SetPlayerColor(playerid, COLOR_DEFAULT);
	}

	//else if(PlayerInfo[playerid][pFaction] == F_ARMY)	{ SetPVarString(playerid, "color", "704214"); SetPlayerColor(playerid, 0x704214FF);  }
	//else if(PlayerInfo[playerid][pFaction] == F_MAYOR)	{ SetPVarString(playerid, "color", "E6FB01"); SetPlayerColor(playerid, 0xE6FB01FF);  }
	//else if(PlayerInfo[playerid][pFaction] == F_EMERGY)	{ SetPVarString(playerid, "color", "FF52A4"); SetPlayerColor(playerid, 0xFF52A4FF);  }
	//else if(PlayerInfo[playerid][pFaction] == F_NEWS)	{ SetPVarString(playerid, "color", "FF4F00"); SetPlayerColor(playerid, 0xFF4F00FF);  }
}

stock FormatSkill(prefix[], skillname[], level, skill, next)
{
	new string[164];
	if(level == 0)
		format(string, sizeof(string), "%s{AFAFAF}%s\t{AFAFAF}�� �������\n", prefix, skillname);
	else if(next == -1)
		format(string, sizeof(string), "%s{FFFFFF}%s\t%d ��.\t{33AA33}��������\n", prefix, skillname, level);
	else
		format(string, sizeof(string), "%s{FFFFFF}%s\t%d ��.\t%d/%d\n", prefix, skillname, level, skill, next);
	return string;
}

stock ReloadEmmetStore()
{
	for(new weaponid, i; i < sizeof(EmmetStore); i++)
	{
	    weaponid = 0;
	    if(EmmetStore[i][1] == 0)
		{// ���� ����� ��������
			EmmetStore[i][0] = 0;
			EmmetStore[i][2] = 0;
		}
	    switch(i)
	    {
	        // ��������
	        case 0: if(random(100) < 95) weaponid = EmmetAmmuList[0][random(2)];
	        // ��������
	        case 1: if(random(100) < 90) weaponid = EmmetAmmuList[2][random(3)];
	        // �����������
	        case 2: if(random(100) < 80) weaponid = EmmetAmmuList[1][0];
	        // �������
	        case 3: if(random(100) < 75) weaponid = EmmetAmmuList[4][random(2)];
	        // ��������
	        case 4: if(random(100) < 50) weaponid = EmmetAmmuList[5][random(2)];
	        // �������
	        case 5: if(random(100) < 66) weaponid = 16;
	        // ����������
	        case 6: if(random(100) < 95) weaponid = 99;
	    }
	    if(weaponid != 0)
	    {
	        EmmetStore[i][0] = weaponid;
	        if(weaponid == 99) EmmetStore[i][1] = 25 + random(76);
	        else EmmetStore[i][1] = (25 + random(76)) * GunParams[weaponid][GUN_AMMO];
	        if(weaponid == 99) EmmetStore[i][2] = 200;
	        else EmmetStore[i][2] = floatround((1 + (random(15) + 10)/100) * GunParams[weaponid][GUN_PRICE]);
	    }
	}
}

stock FlashPoliceZone(playerid, bool:toggle)
{
	if(toggle && (InGangZone[playerid] == -1 || PursuitStatus[playerid] > 0)) 
	{
		SetPVarInt(playerid, "Player:FlashPoliceZone", true); 
	}
	else 
	{
		DeletePVar(playerid, "Player:FlashPoliceZone");
	}
	UpdatePlayerRadarColor(playerid);
}

stock UpdatePlayerRadarColor(playerid)
{
	if(GetPVarInt(playerid, "Player:FlashPoliceZone"))
	{
		GangZoneShowForPlayer(playerid, GlobalGZ, 0x1560BDBB);	// Blue
		GangZoneFlashForPlayer(playerid, GlobalGZ, 0x9B2D30BB);	// Red
	}
	else if(GetPVarInt(playerid, "Player:InGreenZone"))
	{
		GangZoneShowForPlayer(playerid, GlobalGZ, 0x33AA33BB);	//	Green
	}
	else
	{
		GangZoneHideForPlayer(playerid, GlobalGZ);
	}
}

stock log(const filename[], const message[])
{
	new string[128], lstring[512],
    	year, month, day, hour, minuite, second;

	gettime(hour,minuite,second);
	getdate(year, month, day);

	format(string, sizeof(string), "log/%s.log", filename);
	new File:file = fopen(string, io_append);
	format(lstring, sizeof(lstring), "[%02d/%02d/%04d][%02d:%02d:%02d] %s\r\n", day, month, year, hour, minuite, second, message);
	fwriterus(file, lstring);
	fclose(file);
}

Public: UpdatePlayerTime(playerid)
{
    if(FirstSpawn[playerid] == false)
    {
    	new vw	= GetPlayerVirtualWorld(playerid);
    	new int	= GetPlayerInterior(playerid);
    	if(!vw && !int)
    	{
			new hour, minute;
			gettime(hour, minute, _);
			SetPlayerTime(playerid, hour, minute);
		}
    	else if(vw == VW_CITYHALL)	SetPlayerTime(playerid, 22, 00);
    	else if(vw || int)			SetPlayerTime(playerid, 12, 0);
	}
	return true;
}

stock MoveVehicleTrap(playerid, vehicleid)
{
    if(VehInfo[vehicleid][vTrapState] == false)
    {
        VehInfo[vehicleid][vTrapState] = true;
		MoveDynamicObject(VehInfo[vehicleid][vObject][0], 314.20001, 1044.58472, 1946.69995, 1.0, 2.0, 90.0, 0.0);
		MoveDynamicObject(VehInfo[vehicleid][vObject][1], 317.70001, 1044.58472, 1946.69995, 1.0, 2.0, 90.0, 0.0);
		UpdateDynamic3DTextLabelText(VehInfo[vehicleid][vText3D], 0x00FF00FF, "������ ��������!");

		foreach(LoginPlayer, i)
		    if(IsPlayerInRangeOfPoint(i, 35.0, 315.8, 1026.1, 1950.0) && GetPlayerVirtualWorld(i) == vehicleid)
				PlayerPlaySound(i, 30800, 0.0, 0.0, 0.0);

		if(VehInfo[vehicleid][vDriver] != -1) SendMissionMessage(VehInfo[vehicleid][vDriver], "~b~�������� ���: ~w~������");
		if(VehInfo[vehicleid][vDriver] != playerid) SendClientMessage(playerid, COLOR_WHITE, "> �� "MAIN_COLOR"�������{FFFFFF} �������� ��� ��������� �����");
    }
    else
    {
        VehInfo[vehicleid][vTrapState] = false;
		MoveDynamicObject(VehInfo[vehicleid][vObject][0], 314.20001, 1034.81970, 1946.90002, 1.0, -4.5, 90.0, 0.0);
		MoveDynamicObject(VehInfo[vehicleid][vObject][1], 317.70001, 1034.81970, 1946.90002, 1.0, -4.5, 90.0, 0.0);
		UpdateDynamic3DTextLabelText(VehInfo[vehicleid][vText3D], 0xFF0000FF, "������ ��������!");

		foreach(LoginPlayer, i)
		    if(IsPlayerInRangeOfPoint(i, 35.0, 315.8, 1026.1, 1950.0) && GetPlayerVirtualWorld(i) == vehicleid)
				PlayerPlaySound(i, 30802, 0.0, 0.0, 0.0);

		if(VehInfo[vehicleid][vDriver] != -1) SendMissionMessage(VehInfo[vehicleid][vDriver], "~b~�������� ���: ~w~������");
		if(VehInfo[vehicleid][vDriver] != playerid) SendClientMessage(playerid, COLOR_WHITE, "> �� {FF0000}�������{FFFFFF} �������� ��� ��������� �����");
    }
}

stock GMError(playerid, const msg[])
{
	new string[128];
	format(string, sizeof(string), "[Gamemode Error]: %s", msg);
	SendClientMessage(playerid, COLOR_RED, string);
	print(string);
	SendClientMessage(playerid, COLOR_WHITE, "����������, �������� �� ���� �������������, ������ �������� � ������ �������� ��������� ������! �������!");
	return true;
}

//----------
public OnRuntimeError(code, &bool:suppress)
{
	new string[128];
	format(string, sizeof(string), PREFIX_ADMIN "��������� ������ � ������� ���� [code: %d | suppress: %i]", code, suppress);
	SendAdminMessage(COLOR_LIGHTRED, string);
	return true;
}

main()
{
	print("---------------");
	new sec, minute, hour;
	new day, month, year;
	gettime(hour, minute, sec);
	getdate(year, month, day);

	j_Storage 		= 1000 + random(4000);
	OldMinute 		= minute; OldHour = hour;
	PoliceCallNum 	= (hour * 60 + minute) / 2;// ��������� ��������
    GameModeStatus 	= true;

	SendRconCommand("mapname San Andreas");
	printf("Ready! %02d/%02d/%04d", day, month, year);
	printf("Gamemode load time: %dms\n", GetTickCount() - StartUNIXTime);
	
	MODE_TEST();
	return true;
}// end of main()

/*main_ERROR(bool:reboot = false)
{
	print(" ");
	if(reboot == true)
	{
		SetTimer("main_RELOAD", 5000, 0);
		print("Founded error! Trying connection in 5 sec...");
	}
	else print("Founded fatal error! Not possible to load gamemode!");
	return 0;
}

Public: main_RELOAD() main();*/

MODE_TEST()
{
#if defined TESTING_MODE
	CreateTests();
#endif

	/*
	�������� �������� ( ?: ) - ������������ �������� � PAWN, ������� �������� ����� � ����� ����������. ��������� ��������� ���������:
	(���������1) ? (���������2) : (���������3)
	��� �������� ��������� �������: ���� ���������1 ���������� true, �� ����������� ���������2, � ��������� ������ ����������� ���������3.
	������ ������������ �������� ������������� ��������� ����������. ������:
	z = (x > y) ? x : y; // ��� ��������� �������� ���������� z ������� ��������
	*/
	// ��������� ���������� �� �������� �����, ��� "DESC" - �� �����������
	// SELECT `id`, `name`, `money` FROM `players` ORDER BY `money` DESC;
}

CreateStaticMenu()
{
	//	KingRing
	KingRingMenu = CreateMenu("King Ring", 0, 29.0, 145.0, 143.0, 80.0);
	AddMenuItem(KingRingMenu, 0, RusText("Large donuts (10$)"));
	AddMenuItem(KingRingMenu, 0, RusText("Average donuts (5$)"));
	AddMenuItem(KingRingMenu, 0, RusText("Small donuts (2$)"));
	AddMenuItem(KingRingMenu, 0, RusText("Water (2$)"));

	//	Burger Shot
	BurgerShotMenu = CreateMenu("Burger Shot", 0, 29.0, 145.0, 143.0, 80.0);
	AddMenuItem(BurgerShotMenu, 0, RusText("Moo Kids Meal (2$)"));
	AddMenuItem(BurgerShotMenu, 0, RusText("Beef Tower (5$)"));
	AddMenuItem(BurgerShotMenu, 0, RusText("Meat Stack (10$)"));
	AddMenuItem(BurgerShotMenu, 0, RusText("Salad Meal (5$)"));

	//	Pizza
	PizzaMenu = CreateMenu("Pizza", 0, 29.0, 145.0, 143.0, 80.0);
	AddMenuItem(PizzaMenu, 0, RusText("Mini Pizza (2$)"));
	AddMenuItem(PizzaMenu, 0, RusText("Big Pizza (5$)"));
	AddMenuItem(PizzaMenu, 0, RusText("Double Pizza (10$)"));
	AddMenuItem(PizzaMenu, 0, RusText("Water (2$)"));

	//	Cluckin Bell
	CluckinBellMenu = CreateMenu("Cluckin Bell", 0, 29.0, 145.0, 143.0, 80.0);
	AddMenuItem(CluckinBellMenu, 0, RusText("Little Meal (2$)"));
	AddMenuItem(CluckinBellMenu, 0, RusText("Big Meal (5$)"));
	AddMenuItem(CluckinBellMenu, 0, RusText("Huge Meal (10$)"));
	AddMenuItem(CluckinBellMenu, 0, RusText("Salad Meal (10$)"));
}

CreatePlayerDrinkMenu(playerid)
{
	new items[][32] = {
		"Beer\t6$",
		"Vodka\t10$",
		"Whiskey\t10$",
		"Champagne\t15$",
		"Water\t2$"
	};
	ShowPlayerSelectMenu(playerid, SM_DRINK, "Bar", items);
	return true;
}

CMD:movelift(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 20.0, -1456.70349, 552.28198, 13.0))
	{
	    if(IsDynamicObjectMoving(AirGate1))
	    {
	        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������, ���� ��� ��������� � ��������.");
	        return 1;
	    }
	    if(AirGate1Open)    MoveDynamicObject(AirGate1, -1456.70349, 552.28198, 16.9, 1.4);
	    else                MoveDynamicObject(AirGate1, -1456.70349, 552.28198, 9.85, 1.4);
	    AirGate1Open = !AirGate1Open;
	}
	else if(IsPlayerInRangeOfPoint(playerid, 20.0, -1414.46997, 567.45001, 11.68))
	{
	    if(IsDynamicObjectMoving(AirGate2))
	    {
	        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������, ���� ��� ��������� � ��������.");
	        return 1;
	    }
	    if(AirGate2Open)    MoveDynamicObject(AirGate2, -1414.46997, 567.45001, 16.68, 1.4);
	    else                MoveDynamicObject(AirGate2, -1414.46997, 567.45001, 9.64, 1.4);
	    AirGate2Open = !AirGate2Open;
	}
	else
	{
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���������� ��� �� ������ �����.");
        return 1;
	}
	return 1;
}

CMD:test13(playerid, params[])
{
	new a = strval(params);
	if(a == 1)
	{
		SetPlayerCameraPos(playerid, 243.67886352539, 366.575, 858.1);
		SetPlayerCameraLookAt(playerid, 244.77876281738, 366.575, 857.22467041016);
	}
	else if(a == 2)
	{
		SetPlayerCameraPos(playerid, 243.67886352539, 266.575, 858.1);
		SetPlayerCameraLookAt(playerid, 244.77876281738, 266.575, 857.22467041016);
	}
	else if(a == 3)
	{
		SetPlayerCameraPos(playerid, 143.67886352539, 266.575, 858.1);
		SetPlayerCameraLookAt(playerid, 144.77876281738, 266.575, 857.22467041016);
	}
	else if(a == 4)
	{
		SetPlayerCameraPos(playerid, 43.67886352539, 266.575, 858.1);
		SetPlayerCameraLookAt(playerid, 44.77876281738, 266.575, 857.22467041016);
	}
	else if(a == 5)
	{
		SetPlayerCameraPos(playerid, 543.67886352539, 266.575, 858.1);
		SetPlayerCameraLookAt(playerid, 544.77876281738, 266.575, 857.22467041016);
	}
	else if(a == 6)
	{
		SetPlayerCameraPos(playerid, 643.67886352539, 266.575, 858.1);
		SetPlayerCameraLookAt(playerid, 644.77876281738, 266.575, 857.22467041016);
	}
	else
	{
		SetCameraBehindPlayer(playerid);
	}
	return true;
}

new buttonCrimeFactory[4],
	buttonLSPD[4];
new gateCrimeFactory[4],
	gateLSPD[2];

CreateStaticObject()
{
//	������������ �����
	CreateDynamicObject(2952, -2175.882, -207.800, 34.705, 0.2, -65.1, 00.00);	//	������ ���� ����� ���� ������� �� ������ ������
	CreateDynamicObject(2952, -2163.925, -225.572, 35.215, 0.0, 00.00, 90.00);	//	����� ����������� ��������� ������ 
	
	gateCrimeFactory[0]		= CreateGate(3055, -2180.611, -209.688, 36.755, 0.0, 0.0, -90.0, -2180.611, -209.688, 32.625);	//	������ ��� ������ �� ������� (�������� z = 32.625)
	buttonCrimeFactory[0]	= CreateButton(-2180.304, -212.513, 36.945, 0.0, 0.0, 90.00);	//	������
	buttonCrimeFactory[1]	= CreateButton(-2181.110, -212.513, 36.945, 0.0, 0.0, -90.0);	//	������

	gateCrimeFactory[1]		= CreateGate(6400, -2149.680, -240.730, 37.385, 0.0, 0.0, 90.00,	-2145.15, -240.730, 37.385);	//	������ ������ 1/2	(�������� x = -2145.15)
	gateCrimeFactory[2]		= CreateGate(6400, -2154.190, -240.770, 37.385, 0.0, 0.0, -90.00,	-2158.27, -240.770, 37.385);	//	������ ������ 2/2	(�������� x = -2154.27)
	buttonCrimeFactory[2]	= CreateButton(-2156.192, -240.291, 36.985, 0.0, 0.0, -180.0);	//	������
	buttonCrimeFactory[3]	= CreateButton(-2156.292, -240.890, 36.985, 0.0, 0.0, 00.000);	//	������

//	����� � ���������
	AirportDoor[0] = CreateDynamicObject(1495, 1684.27, -2335.98, 12.56, 0.00, 0.00, 0.00, VW_AIRPORT); //object (Gen_doorEXT01) (1)
	SetDynamicObjectMaterial(AirportDoor[0], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(AirportDoor[0], 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(AirportDoor[0], 2, 18632, "fishingrod", "plastic", 0xFFFFFFFF);

	AirportDoor[1] = CreateDynamicObject(1495, 1687.27, -2335.94, 12.56, 0.00, 0.00, 180, VW_AIRPORT); //object (Gen_doorEXT01) (2)
	SetDynamicObjectMaterial(AirportDoor[1], 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(AirportDoor[1], 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(AirportDoor[1], 2, 18632, "fishingrod", "plastic", 0xFFFFFFFF);

//	����
	buttonLSPD[0]	= CreateButton(1584.417, -1637.853, 13.962, 0.0, 0.0, 180.0); 	// ������� ����� �� ������� ���� �������
	buttonLSPD[1]	= CreateButton(1584.396, -1638.303, 13.962, 0.0, 0.0, 00.00); 	// ������� ����� �� ������� ���� ������

	buttonLSPD[2]	= CreateButton(245.11, 72.37, 1003.99, 0.00, 0.00, 00.00);		// ������ (��)
	buttonLSPD[3]	= CreateButton(244.84, 73.48, 1003.99, 0.00, 0.00, 90.00);		// ������ (��)

	gateLSPD[0]		= CreateGate(985, 1588.55, -1638.33, 13.200, 0.00, 0.00, 0.00,	1595.55, -1638.33, 13.200, 1.9, 5000);	// ������ � ������ (����)
	gateLSPD[1]		= CreateGate(1535, 245.46, 72.53000, 1002.6, 0.00, 0.00, 0.00,	244.210, 72.53000, 1002.6, 1.0, 2000);	// ����� ��� (����)
	LSPDbarr = CreateDynamicObject(968, 1544.69, -1630.85, 13.10, 0.00, 90.00, 90.00);// �������� � ������� (����)

//	��������� ���� �� �������� ������
	Crane = CreateDynamicObject(5126, 2197.18, -2325.039, 27.53, 0.0, 0.0, 135.0);

// ��������� ��������� (������ ������ "������ �������")
	new obj = CreateDynamicObject(19464, 1954.22339, 919.79791, 991.70001, 0.0, 90.0, 35.0);
	Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT, obj, true);

	//------------------------------[Objects]-----------------------------------
	KassGate[0] = CreateDynamicObject(986, 2497.41, 2769.11, 11.53, 0.00, 0.00, 90.00);// �� ���� ������ 1
	KassGate[1] = CreateDynamicObject(985, 2497.41, 2777.07, 11.53, 0.00, 0.00, 90.00);// �� ���� ������ 2

	// CreateObject(1535, 244.21, 72.53, 1002.60, 0.00, 0.00, 0.00);// ����� ��� (����)
	AreaGate[0] = CreateDynamicObject(19313, 134.91, 1941.52, 21.78, 0.00, 0.00, 0.00); // �������� ������ (����� �����)
	//CreateObject(19313, 120.39, 1941.52, 21.78, 0.00, 0.00, 0.00); // �������� ������ (����� �����)
	AreaGate[1] = CreateDynamicObject(19313, 285.99, 1822.31, 20.00, 0.00, 0.00, 270.00); // �������� ������ (����� ��������)
	//CreateObject(19313, 285.99, 1834.09, 20.00, 0.00, 0.00, 90.00); // �������� ������ (����� ��������)
	AreaGate[2] = CreateDynamicObject(2929, 211.88, 1875.65, 13.90, 0.00, 0.00, 0.00);// ����51 ������ � ������
	//CreateObject(2929, 208.18, 1875.65, 13.90, 0.00, 0.00, 0.00);// �������� ������ � ������
	AreaGate[3] = CreateDynamicObject(2927, 215.97, 1875.65, 13.90, 0.00, 0.00, 0.00);// ����51 ������ � ������
	//CreateObject(2927, 219.57, 1875.65, 13.90, 0.00, 0.00, 0.00);// �������� ������ � ������
	ASbarr = CreateDynamicObject(968, -2043.6, -80.58, 35.0, 0.0, -90.0, 0.0);	//	�������� � ���������

// Aircraft Carrier
	AirGate1Open = false; AirGate2Open = false;
	AirGate1 = CreateDynamicObject(3115, -1456.70349, 552.28198, 16.90, 0.0, 0.0, 0.0);
	AirGate2 = CreateDynamicObject(3114, -1414.46997, 567.45001, 16.68, 0.0, 0.0, 0.0);

// Fort Carson
	FC_Gate[0] = CreateDynamicObject(2988, -236.49400, 1208.37000, 18.38710, 0.0, 0.0, 270.0);
	FC_Gate[1] = CreateDynamicObject(2988, -244.88930, 1208.37000, 18.38710, 0.0, 0.0, 70.0);

// Alcatraz (���������)
	PrisonGate[0] = CreateDynamicObject(2990, 540.359, -2748.300, 14.600, 0.00, 0.00, 180.00); // ������ � ��������
	//CreateDynamicObject(2990, 550.359, -2748.300, 14.600, 0.00, 0.00, 180.00);
	PrisonGate[1] = CreateDynamicObject(2990, 551.429, -2731.300, 14.600, 0.00, 0.00, 270.00); // ������ � �������� ������
	//CreateDynamicObject(2990, 551.429, -2721.300, 14.600, 0.00, 0.00, 270.00);
	PrisonGate[2] = CreateDynamicObject(2990, 540.580, -2714.209, 14.600, 0.00, 0.00, 180.00); // ������ � ��������
	//CreateDynamicObject(2990, 530.580, -2714.209, 14.600, 0.00, 0.00, 180.00);
	PrisonGate[3] = CreateDynamicObject(2990, 547.320, -2818.209, 14.600, 0.00, 0.00, 0.00); // ������ � ����.��������
	//CreateDynamicObject(2990, 537.320, -2818.209, 14.600, 0.00, 0.00, 0.00);
	PrisonGate[4] = CreateDynamicObject(2990, 590.169, -2676.679, 14.600, 0.00, 0.00, 90.00); // ������ � ������� ������
	//CreateDynamicObject(2990, 590.169, -2666.679, 14.600, 0.00, 0.00, 90.00);
	PrisonGate[5] = CreateDynamicObject(2990, 628.150, -2704.229, 6.219, 0.00, 0.00, 0.00); // ������ � ������
	//CreateDynamicObject(2990, 638.150, -2704.229, 6.219, 0.00, 0.00, 0.00);
	for(new i = 0; i < sizeof(JailDoorsPos); i++)
	{
		JailDoors[i] = CreateDynamicObject(2930, Arr3<JailDoorsPos[i]>, 0.0, 0.0, 0.46);
	}

// Los Santos Prison
	// Outside gates
	LS_PrisonGate[0] = CreateDynamicObject(19795, 1822.52832, -1540.94080, 14.26770,   0.00000, 0.00000, 164.80000); // To close: Z = 10.8
	LS_PrisonGate[1] = CreateDynamicObject(19795, 1824.32483, -1534.69763, 14.26770,   0.00000, 0.00000, -16.80000);
	LS_PrisonGate[2] = CreateDynamicObject(19796, 1756.92969, -1592.31470, 14.27910,   0.00000, 0.00000, 257.00000); // To close: Z = 10.7
	LS_PrisonGate[3] = CreateDynamicObject(19796, 1752.02393, -1591.19116, 14.27910,   0.00000, 0.00000, 77.00000);
	// Inside gates
	LS_PrisonGate[4] = CreateDynamicObject(19795, 1813.87659, -1533.16516, 13.93400,   0.00000, 0.00000, -1.50000); // To close: Z = 10.4
	LS_PrisonGate[5] = CreateDynamicObject(19795, 1813.72278, -1539.64246, 13.93400,   0.00000, 0.00000, 178.50000);
	LS_PrisonGate[6] = CreateDynamicObject(19796, 1756.62097, -1583.20007, 13.27910,   0.00000, 0.00000, 257.00000); // To close: Z = 9.7
	LS_PrisonGate[7] = CreateDynamicObject(19796, 1751.71716, -1582.06445, 13.27910,   0.00000, 0.00000, 77.00000);
	LS_PrisonGate[8] = CreateDynamicObject(19795, 1781.21533, -1530.76758, 10.20000,   0.00000, 0.00000, -2.00000); // To close: Z = 6.6
	LS_PrisonGate[9] = CreateDynamicObject(19795, 1780.97607, -1537.21082, 10.20000,   0.00000, 0.00000, 178.00000);

//	���� ���
	FBIGate = CreateDynamicObject(971, 1790.7, -1136.0, 25.50, 0.0, 0.0, 270.0);	//	������ �� ���� ���
}
// end of CreateStaticObject()

public OnPlayerPressedButton(playerid, button)
{
	//	Crime Factory
	if(button == buttonCrimeFactory[0] || button == buttonCrimeFactory[1])
	{
        if(IsMafia(PlayerInfo[playerid][pFaction]))
        {
        	OpenGate(gateCrimeFactory[0]);
		}
		else
		{
		    return false;
		}
	}
	else if(button == buttonCrimeFactory[2] || button == buttonCrimeFactory[3])
	{
        if(IsMafia(PlayerInfo[playerid][pFaction]))
        {
        	OpenGate(gateCrimeFactory[1]);
        	OpenGate(gateCrimeFactory[2]);
		}
		else
		{
		    return false;
		}
	}
	//	LSPD
	else if(button == buttonLSPD[0] || button == buttonLSPD[1])
	{
		
		if(PlayerInfo[playerid][pFaction] == F_POLICE)
        {
    		OpenGate(gateLSPD[0]);
		}
		else
		{
		    return false;
		}
	}
	else if(button == buttonLSPD[2] || button == buttonLSPD[3])
	{
		new Float:Y;
		MyGetPlayerPos(playerid, _, Y);
		if(Y > 72.53 || PlayerInfo[playerid][pFaction] == F_POLICE)
        {	// ������ ��� ���
        	OpenGate(gateLSPD[1]);
		}
		else
		{
		    return false;
		}
	}
	return true;
}

GameModeInit_Error(bool:reboot = false)
{
	print(" ");
	if(reboot == true)
	{
		SetTimer("GameModeInit_Reload", 5000, 0);
		print("Founded error! Trying connection in 5 sec...");
	}
	else print("Founded fatal error! Not possible to load gamemode!");
	return 0;
}

MySQL_Load()
{
	mysql_log(MYSQL_LOG);
	g_SQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MAIN_DB);
	if(mysql_errno())
	{
		print("  Connection to MySQL... ERROR!");
		return false;
	}
	print("  Connection to MySQL... SUCCESSFUL!");

	new query[128], server_db[32];
	mysql_format(g_SQL, query, sizeof query, "SELECT `db` FROM `servers` WHERE `id` = '%d'", SERVER_ID);
	new Cache:result = mysql_query(g_SQL, query);
	if(cache_num_rows() == 0)
	{
		printf("  The `servers` table no data on the server with the id %d...", SERVER_ID);
		return false;
	}
	cache_get_value_index(0, 0, server_db);
	cache_delete(result);
	mysql_close(g_SQL);

	g_SQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, server_db);
	printf("  Connection to server db: %s...", server_db);
	if(mysql_errno())
	{
		print("  Connection ERROR!");
		return false;
	}
	print("  Connection SUCCESSFUL!\n");
	mysql_set_charset("cp1251", g_SQL);
	//mysql_query_ex("/*!40101 SET NAMES 'cp1251' */");
	//mysql_query_ex("SET CHARACTER SET 'cp1251'");
	mysql_query_ex("UPDATE `players` SET `online` = '-1' WHERE `online` > '-1'");

	////////////////////
	mysql_format(g_SQL, query, sizeof(query), "SELECT `record_online` FROM %s.`servers` WHERE `id` = '%d' LIMIT 1", MAIN_DB, SERVER_ID);
	result = mysql_query(g_SQL, query);
	cache_get_value_name_int(0, "record_online", CurrentPlayerRecords);
	cache_delete(result);
	////////////////////
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM `banips` WHERE `time` < '%d'", gettime());
	result = mysql_query(g_SQL, query);
	new deleted = cache_affected_rows();
	if(deleted)	printf("  Unbanned ip: %d.", deleted);
	cache_delete(result);
	////////////////////
	result = mysql_query(g_SQL, "SELECT `ip`, `time` FROM `banips`");
	new row = cache_num_rows();
	for(new i = 0, ip[16], time; i < row; i++)
	{
		cache_get_value_name(i, "ip", ip);
		cache_get_value_name_int(i, "time", time);
		BlockIpAddress(ip, (gettime() - time) * 1000);
	}
	printf("  Banned ip: %d.", row);
	cache_delete(result);
	return true;
}

Public: GameModeInit_Reload()	OnGameModeInit();
public OnGameModeInit()
{
	StartUNIXTime = GetTickCount();
	printf("\nGamemode: [%s]", GAMEMODE_NAME);
	print("   by Borog25 & Impereal");
	print("---------------");

	//////////	Settings 	//////////
	if(!LoadSettings())
	{
		print("  File settings.ini not found");
		return GameModeInit_Error(true);
	}
	if(SERVER_ID == INVALID_DATA)
	{
		print("  In the settings.cfg file does not indicate the number of server");
		return GameModeInit_Error(true);
	}

	new maxslots = GetConsoleVarAsInt("maxplayers");
    if(maxslots != MAX_PLAYERS)
    {
		printf("  ERROR! MAX_PLAYERS(%d) isn't accord with maxplayers(%d) from server.cfg!", MAX_PLAYERS, maxslots);
	    if(maxslots > MAX_PLAYERS) return GameModeInit_Error();
	}

	SetGameModeText("Role Play (RP)");
	SendRconCommand("hostname The Silver Break Role Play");
	SendRconCommand("mapname loading...");

	EnableStuntBonusForAll(0);
	EnableVehicleFriendlyFire();
	ManualVehicleEngineAndLights();
	DisableNameTagLOS(); // ���� ������� �� ����� ����� �����
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);
	MapAndreas_Init(MAP_ANDREAS_MODE_FULL);

	Anticheat.Toggle(ANTICHEAT);
	UpdateWeather();

	//////////		MySQL 	//////////
	if(!MySQL_Load())
	{
		return GameModeInit_Error(true);
	}
	////////////////////////////////////////

	#if defined _vehicle_core_included
		Callback: Vehicle.OnGameModeInit();
	#endif	
	#if defined _interface_core_included
		Callback: IFace.OnGameModeInit();
	#endif
	#if defined	_job_job_theft_included
		Callback: Theft_OnGameModeInit();
	#endif
	#if defined	_job_job_busdriver_included
		Callback: BusDriver_OnGameModeInit();
	#endif	
	#if defined	_job_job_trucker_included
		Callback: Trucker_OnGameModeInit();
	#endif
	#if defined	_job_part_farmer_included
		Callback: Farmer_OnGameModeInit();
	#endif
	#if defined	_job_part_loader_included
		Callback: Loader_OnGameModeInit();
	#endif
	#if defined	_job_part_delivery_included
		Callback: Delivery_OnGameModeInit();
	#endif
	#if defined _service_casino_included
		Callback: Casino_OnGameModeInit();
	#endif
	#if defined _player_achieve_included
		Callback: Achieve_OnGameModeInit();
	#endif
	#if defined _gang_core_included
		Callback: Gang.OnGameModeInit();
	#endif
	#if defined _inventory_included
		Callback: Inv.OnGameModeInit();
	#endif
	#if defined _npc_core_included
		NPC.Init();
	#endif
	new warehouses = LoadWarehouses();
	printf("  Loaded warehouses: %d.", warehouses);

	new houses = LoadHouses();
	if(houses == -1)
	{
	    print("  Houses not found. Try to restore default houses...");
		RestoreDefaultHouses();
		houses = LoadHouses();
	}
	printf("  Houses has owner: %d/%d.", houses, MaxHouses);

	new biz = LoadBiz();
	if(biz == -1)	print("  Businesses not found.");
	else 			printf("  Businesses have owners: %d/%d.", biz, MaxBiz);

	//---	Objects
	printf("  Load objects:");
	SendRconCommand("loadfs objects");

	OnPrisonStatusChange(LastPrisonStatus);	//  start jail period
	ReloadEmmetStore();

	// ������� ������������� ����� �������
	for(new i = 1; i < sizeof(Faction); i++)
	{
		for(new r; r < sizeof(FactionRank[]); r++)
		{
		    if(strlen(FactionRank[i][r]) > 0)
		    {
		    	FactionRankMax[i]++;
		    }
		}
	}

	//	Add Classes
	for(new i = 1; i < sizeof(Faction); i++)
	{
		AddPlayerClass(FactionSkins[i][ FactionRankMax[i] - 1 ], 1958.3783, 1343.1572, 1100.3746, 269.1425, -1, -1, -1, -1, -1, -1);
	}

	//-----------------------------[Vehicles]-----------------------------------
	new t = GetTickCount();

	//----------------------[Only Blocked Server Cars]--------------------------
	new car1, car2; //tmpcar;
	// ������ ����������
	TruthCar = MyCreateVehicle(483, -1111.1207, -1637.3865, 76.3624, 90.0, 1, 1);
	SetVehicleNumberPlate(TruthCar, "EREHTTUO");
	MySetVehicleToRespawn(TruthCar);
	VehInfo[TruthCar][vLocked] = 999;
	VehInfo[TruthCar][vBlockMove] = true;
	UpdateVehicleParamsEx(TruthCar);

		// ������ ���� �������
	car1 = MyCreateVehicle(599,-210.7,999.6,19.8453,90.0,20,1); // Police Rancher
	MyCreateVehicle(599,-210.7,994.6,19.7573,90.0,20,1); // Police Rancher 2
	MyCreateVehicle(599,-210.7,989.6,19.7573,90.0,20,1); // Police Rancher 3
	MyCreateVehicle(416,-304.2692,1032.0936,19.7431,270.0,1,3); // Ambulance
	MyCreateVehicle(442,-304.4656,1023.9050,19.4257,270.0,0,15); // Romero (��������)
	MyCreateVehicle(491, -232.9827,1220.8879,19.4931,180.0,0,1);// ������ �����������
	MyCreateVehicle(511, -31.6397,1083.8129,21.1027,0.0);// �������
	MyCreateVehicle(442, -639.1992, 1459.3405, 13.3384, 88.7888, 0, 0);	// �������� �� �������� ��
	//MyCreateVehicle(583, 243.0994,1845.1360,8.3017,270.1920,1,0);// Tug �� ���� 69

	// ������ ������
	MyCreateVehicle(577, 1585.8, 1189.499, 10.7676, 180.0, 48, 45); // AT400 (Andromeda in LV)
	MyCreateVehicle(544, -2020.061, 84.3924, 28.1641, 270.0, 3, 1); // �������� �������� (��)
	MyCreateVehicle(407, -2020.699, 92.7917, 28.2111, 270.0, 3, 1); // �������� ������ (��)
	//MyCreateVehicle(544, 1219.794, -1312.515, 13.598, 90.0, 3, 1);	// �������� ������ (��)
	//MyCreateVehicle(407, 1221.078, -1303.867, 13.596, 90.0, 3, 1); 	// �������� ������ (��)
	//MyCreateVehicle(407, 1221.223, -1321.018, 13.603, 90.0, 3, 1); 	// �������� ������ (��)

	// ������ ����������
	MyCreateVehicle(430, 700.9841, -2761.6611, 0.3639, 0.0, 34, 246); // Police Predator
	MyCreateVehicle(472, 709.2700, -2761.5857, 0.4229, 0.0, 246, 34); // Coastguard
	MyCreateVehicle(497, 565.2260, -2832.5356, 15.7825, 0.0, 246, 34); // Police Maverick
	MyCreateVehicle(433, 582.1, -2674.3, 13.6, 268.1);	// �������� ��� ���������
	car2 = MyCreateVehicle(499, 641.7137, -2674.9958, 7.2809, 125.0, 246, 34); // Benson
	// ���������� ��������� �����
	for(new x = car1; x <= car2; x++)
	{
		VehInfo[x][vLocked] = 999;
		VehInfo[x][vBlockMove] = true;
		UpdateVehicleParamsEx(x);
	}

	// MyCreateVehicle(525, 1564.5, -1710.5, 5.6, 0.0, 0, 90);// Towtrack
	/*MyCreateVehicle(599, 1545.0, -1684.4, 5.8, 90.0, 0, 90);// Rancher
	MyCreateVehicle(599, 1545.0, -1680.3, 5.8, 90.0, 0, 90);// Rancher
	MyCreateVehicle(599, 1545.0, -1676.3, 5.8, 90.0, 0, 90);// Rancher
	MyCreateVehicle(599, 1545.0, -1672.1, 5.8, 90.0, 0, 90);// Rancher
	MyCreateVehicle(599, 1545.0, -1668.0, 5.8, 90.0, 0, 90);// Rancher
	MyCreateVehicle(599, 1545.0, -1663.0, 5.8, 90.0, 0, 90);// Rancher
	MyCreateVehicle(599, 1545.0, -1659.0, 5.8, 90.0, 0, 90);// Rancher
	MyCreateVehicle(599, 1545.0, -1655.1, 5.8, 90.0, 0, 90);// Rancher
	MyCreateVehicle(599, 1545.0, -1651.1, 5.8, 90.0, 0, 90);// Rancher
	MyCreateVehicle(427, 1529.1, -1684.0, 5.8, 270.0, 0, 90);// Enforcer
	MyCreateVehicle(427, 1529.1, -1688.0, 5.8, 270.0, 0, 90);// Enforcer
	MyCreateVehicle(497, 1550.0, -1612.0, 13.5, 180.0, 0, 90);// Helicopter
	MyCreateVehicle(497, 1564.4, -1612.0, 13.5, 180.0, 0, 90);// Helicopter*/

	// ����� 'Coutt And Shoutz' (�������������)
	SalonCars1[0] = MyCreateVehicle(412,2135.0000,-1128.5000,25.3222,60.0,-1,-1);
	SalonCars1[1] = MyCreateVehicle(534,2135.0000,-1134.0000,25.2462,60.0,-1,-1);
	SalonCars1[2] = MyCreateVehicle(535,2135.0000,-1139.5000,25.2090,60.0,-1,-1);
	SalonCars1[3] = MyCreateVehicle(536,2135.0000,-1145.0000,24.7014,60.0,-1,-1);
	SalonCars1[4] = MyCreateVehicle(566,2120.0000,-1145.0000,24.3514,300.0,-1,-1);
	SalonCars1[5] = MyCreateVehicle(567,2120.0000,-1139.5000,24.9053,300.0,-1,-1);
	SalonCars1[6] = MyCreateVehicle(575,2120.0000,-1134.0000,24.9734,300.0,-1,-1);
	SalonCars1[7] = MyCreateVehicle(576,2120.0000,-1128.5000,25.0052,300.0,-1,-1);

	// ����� 'Grotti' (���������)
	SalonCars2[0] = MyCreateVehicle(526,562.2294,-1270.7886,16.9400,60.0,-1,-1);
	SalonCars2[1] = MyCreateVehicle(419,562.3832,-1278.1786,16.9400,60.0,-1,-1);
	SalonCars2[2] = MyCreateVehicle(600,562.0000,-1288.0000,16.8900,30.0,-1,-1);
	SalonCars2[3] = MyCreateVehicle(517,557.0000,-1288.0000,17.0000,30.0,-1,-1);
	SalonCars2[4] = MyCreateVehicle(492,552.0000,-1288.0000,16.9100,30.0,-1,-1);
	SalonCars2[5] = MyCreateVehicle(422,547.0000,-1288.0000,17.1200,30.0,-1,-1);
	SalonCars2[6] = MyCreateVehicle(540,537.0000,-1288.0000,17.0200,330.0,-1,-1);
	SalonCars2[7] = MyCreateVehicle(500,532.0000,-1288.0000,17.2190,330.0,-1,-1);
	SalonCars2[8] = MyCreateVehicle(400,527.0000,-1288.0228,17.1900,330.0,-1,-1);
	SalonCars2[9] = MyCreateVehicle(550,536.9458,-1275.9215,16.9900,240.0,-1,-1);
	SalonCars2[10] = MyCreateVehicle(475,542.4854,-1270.8151,16.9010,240.0,-1,-1);
	SalonCars2[11] = MyCreateVehicle(439,548.6223,-1266.3193,16.9900,240.0,-1,-1);

	// ����� 'Ottos Autos' (����������)
	SalonCars3[0] = MyCreateVehicle(562,-1666.6287,1216.1102,6.9124,270.0,-1,-1);
	SalonCars3[1] = MyCreateVehicle(560,-1668.5402,1205.7271,6.8326,360.0,-1,-1);
	SalonCars3[2] = MyCreateVehicle(558,-1662.5000,1221.5000,13.4485,270.0,-1,-1);
	SalonCars3[3] = MyCreateVehicle(559,-1648.4945,1206.9895,13.3491,90.0,-1,-1);
	SalonCars3[4] = MyCreateVehicle(561,-1668.7797,1206.7297,13.3739,270.0,-1,-1);
	SalonCars3[5] = MyCreateVehicle(565,-1661.4327,1219.8186,20.7290,210.0,-1,-1);
	SalonCars3[6] = MyCreateVehicle(477,-1655.5438,1212.4526,20.8581,120.0,-1,-1);
	SalonCars3[7] = MyCreateVehicle(496,-1651.1085,1207.7632,20.7081,120.0,-1,-1);
	SalonCars3[8] = MyCreateVehicle(506,-1662.2345,1205.8899,20.7981,30.0,-1,-1);
	SalonCars3[9] = MyCreateVehicle(587,-1671.3536,1205.9240,20.8365,300.0,-1,-1);

	// ����� 'Wang Cars' (�������)
	SalonCars4[0] = MyCreateVehicle(468,-1962.7000,300.0200,35.0400,220.0,-1,-1);
	SalonCars4[1] = MyCreateVehicle(463,-1959.8000,303.1381,34.9339,200.0,-1,-1);
	SalonCars4[2] = MyCreateVehicle(581,-1956.0000,302.9111,34.9479,160.0,-1,-1);
	SalonCars4[3] = MyCreateVehicle(461,-1953.0000,300.0000,34.9926,140.0,-1,-1);
	SalonCars4[4] = MyCreateVehicle(445,-1947.0000,274.0000,35.2532,120.0,-1,-1);
	SalonCars4[5] = MyCreateVehicle(426,-1947.0000,269.0000,35.1384,120.0,-1,-1);
	SalonCars4[6] = MyCreateVehicle(405,-1947.0000,264.0000,35.2388,120.0,-1,-1);
	SalonCars4[7] = MyCreateVehicle(551,-1947.0000,259.0000,35.2479,120.0,-1,-1);
	SalonCars4[8] = MyCreateVehicle(474,-1961.5000,260.0000,35.1647,315.0,-1,-1);
	SalonCars4[9] = MyCreateVehicle(533,-1961.5000,272.0000,35.1171,315.0,-1,-1);
	SalonCars4[10] = MyCreateVehicle(589,-1947.5000,271.3100,40.6463,90.0,-1,-1);
	SalonCars4[11] = MyCreateVehicle(466,-1947.5000,265.5336,40.7164,90.0,-1,-1);
	SalonCars4[12] = MyCreateVehicle(554,-1949.0000,259.0000,41.0307,45.0,-1,-1);
	SalonCars4[13] = MyCreateVehicle(489,-1955.5000,257.0000,41.0994,360.0,-1,-1);
	SalonCars4[14] = MyCreateVehicle(518,-1953.5000,293.0000,40.6296,130.0,-1,-1);
	SalonCars4[15] = MyCreateVehicle(491,-1953.5000,301.0000,40.7742,130.0,-1,-1);

	printf("Time to load static vehicle: %d", GetTickCount() - t);

	// Create 3d text and locked cars
	CreateSalon3DText(SalonCars1, sizeof(SalonCars1), "* [Coutt And Shoutz] *");
	CreateSalon3DText(SalonCars2, sizeof(SalonCars2), "* [GROTTI] *");
	CreateSalon3DText(SalonCars3, sizeof(SalonCars3), "* [Ottos Autos] *");
	CreateSalon3DText(SalonCars4, sizeof(SalonCars4), "* [Wang Cars] *");

	//-----------------------------[ModeInit/Pickups]------------------------------------
	PoliceDutyPickup	= CreateDynamicPickup(1275, 1, 254.1684, 77.638, 1003.64);
	HospitalDutyPickup	= CreateDynamicPickup(1275, 1, -2628.83, 621.83, 1274.26);
	LawbookPickup		= CreateDynamicPickup(2894, 2, 249.65,69.35,1003.5);
	CopGuidePickup		= CreateDynamicPickup(2894, 2, 235.41,72.17,1004.9);
	FineParkPickup		= CreateDynamicPickup(2485, 1, 1573.0726, -1605.7681, 13.2);
	StuffBankEnter		= CreateDynamicPickup(1318, 1, 2155.4836,1612.1664,993.6882, 1);	// ���� � ���� ��������� � �����
	StuffBankExit		= CreateDynamicPickup(1318, 1, 2148.3372,1605.5266,1001.7789, 1);	// ����� �� ���� ��������� � �����
	StuffBankExit2		= CreateDynamicPickup(1318, 1, 2134.1162,1609.4934,993.6882, 1);	// ����� �� ���� ��������� � ����� (2)
	VentBankPickup		= CreateDynamicPickup(1239, 1, 2143.1941,1619.9510,1001.4, 1);	// ���� � ���������� � �����
	PrisonEatPickup		= CreateDynamicPickup(1239, 2, 598.9, -2848.9, 1032.7);
	RingInfoPickup[0]	= CreateDynamicPickup(1314, 1, 511.0, -2749.0, 13.15);
	RingInfoPickup[1]	= CreateDynamicPickup(1314, 1, 760.6, 5.7, 1000.7);
	GYMPickup[0]		= CreateDynamicPickup(19555, 1, 769.87, 13.24, 1000.70);
	GYMPickup[1]		= CreateDynamicPickup(19555, 1, 770.36, -23.1, 1000.58);
	MotelPickup			= CreateDynamicPickup(PICKUPID_ENTRY, 1, 2228.06, -1150.4, 1030.0);
	MRoomPickup[0]		= CreateDynamicPickup(PICKUPID_ENTRY, 1, 2282.93, -1140.05, 1051.0);
	MRoomPickup[1]		= CreateDynamicPickup(PICKUPID_ENTRY, 1, 2259.65, -1136.00, 1051.0);
	MRoomPickup[2]		= CreateDynamicPickup(PICKUPID_ENTRY, 1, 2255.01, -1139.83, 1051.0);
	MechanicPickup 		= CreateDynamicPickup(1275, 1, 1110.350, -1225.08, 15.82);
	NewbiePickup 		= CreateDynamicPickup(1314, 1, 1691.34, -2328.56, 13.54, VW_NONE);
	AirportPickup 		= CreateDynamicPickup(PICKUPID_ENTRY2, 1, 1685.7, -2335.0, 14.0, VW_NONE);
	BoardPickup[0]		= CreateDynamicPickup(1239, 1, 929.10, -1620.339, 13.5);
	BoardPickup[1]		= CreateDynamicPickup(1239, 1, 2160.11, -2297.52, 13.5);

	//	������
	WarehousePickup[0] = CreateDynamicPickup(19605, 1, 2493.2795,-1710.4559,1014.49); // ����� ����� Grove Street
	WarehousePickup[1] = CreateDynamicPickup(19605, 1, 487.6515,1414.9171,1080.0);	// ����� ����� Ballas
	WarehousePickup[2] = CreateDynamicPickup(19605, 1, 2811.8481,-1166.9017,1025.32); // ����� ����� Vagos
	WarehousePickup[3] = CreateDynamicPickup(19605, 1, 1787.2050,-2095.6160,1021.18); // ����� ����� Aztecas
	WarehousePickup[4] = CreateDynamicPickup(19605, 1, 300.7873,310.1714,1003.05); 	// ����� ����� Rifa
	WarehousePickup[5] = CreateDynamicPickup(19605, 1, 2551.264, -1346.444, 1060.0);	// ����� ����� ��
	WarehousePickup[6] = CreateDynamicPickup(19605, 1, 162.1590, 1384.7449, 1087.6); 	// ����� ����� ���
	WarehousePickup[7] = CreateDynamicPickup(19605, 1, -2162.67, 678.71, 1049.6); 		// ����� ����� ������

	CrimebankPickup[0] = CreateDynamicPickup(1274, 1, 2492.68, -1701.17, 1014.76);	//	Groove Street
	CrimebankPickup[1] = CreateDynamicPickup(1274, 1, 482.096, 1400.174, 1080.25);	//	Ballas
	CrimebankPickup[2] = CreateDynamicPickup(1274, 1, 2816.39, -1173.36, 1025.57);	//	Vagos
	CrimebankPickup[3] = CreateDynamicPickup(1274, 1, 1777.20, -2090.75, 1021.42);	//	Aztecas
	CrimebankPickup[4] = CreateDynamicPickup(1274, 1, 302.038, 301.5905, 1003.53);	//	Rifa

	// ����� ������� ����
	for(new p; p < sizeof(AutoRepairPos); p++)	RecreateRepairPickup(p);

	// ������ ���� �������
	// CreateDynamicPickup(1239, 1, -217.0,1211.8094,19.9450, 0);
	CarSalonPickup_F = CreateDynamicPickup(1239, 1, 2131.8499,-1150.9371,24.1029, 0);
	CreateDynamicPickup(1239, 1, 541.3572,-1293.3917,17.2422, 0);
	CreateDynamicPickup(1239, 1, -1649.2346,1209.3027,7.2500, 0);
	CarSalonPickup_L = CreateDynamicPickup(1239, 1, -1961.7168,288.5224,35.4688, 0);

	//	������ ��� ������ � ������
	j_fFinalPickup = CreateDynamicPickup(1239, 1, 2549.3, -1283.9, 1044.1, VW_JAIL, 2);
	j_lStartPickup = CreateDynamicPickup(1239, 1, 505.3, -2677.2, 13.1);
	j_matpickup[0] = CreateDynamicPickup(1279, 2, Arr3<j_fMatPos[0]>, VW_JAIL, 2);
	for(new i = 1; i < sizeof(j_fMatPos) - 1; i++)
		CreateDynamicPickup(1279, 2, Arr3<j_fMatPos[i]>, VW_JAIL, 2);
    j_matpickup[1] = CreateDynamicPickup(1279, 2, Arr3<j_fMatPos[ sizeof(j_fMatPos) - 1 ]>, VW_JAIL, 2);

	//	������ ����������
	GunDealPickup = CreateDynamicPickup(1239, 1, 2744.7, -2453.7, 13.8);
	//	������ ������������
	DrugDealPickup[0] = CreateDynamicPickup(1239, 1, -1066.5, -1154.5, 129.2);
	DrugDealPickup[1] = CreateDynamicPickup(1239, 1, -2164.1, -249.25, 36.51);

	//--------------------------------[Map Icons]-------------------------------
	for(new i; i < sizeof(StaticMapIcon); i++)
	{
		static_MapIconID[i] = CreateDynamicMapIcon(StaticMapIcon[i][smp_x], StaticMapIcon[i][smp_y], StaticMapIcon[i][smp_z], StaticMapIcon[i][smp_type], StaticMapIcon[i][smp_color], -1, -1, -1);
	}

	//-------------------------------[Checkpoints]------------------------------
    CP_AUTOSCHOOL		=	CreateDynamicCP(-2026.8,-114.5,1035.2, 1.0, -1,-1,-1, 35.0);		// ���������
	CP_BANK				=	CreateDynamicCP(2144.3699,1620.7753,993.6882, 1.0, -1,-1,-1, 35.0);	// Bank
	CP_SEXSHOP 			=	CreateDynamicCP(-104.7,-10.7,1000.7, 1.0, -1,-1,-1, 35.0);			// Sex Shop
	CP_MOTEL			=	CreateDynamicCP(2217.4, -1147.0, 1025.8, 1.0, -1, -1, -1, 35.0);
	CP_SHOOTING			=	CreateDynamicCP(286.3, -30.1, 1001.5, 1.0, -1, -1, -1, 35.0);		// Shooting-Range
	CP_EXIT_TIR			=	CreateDynamicCP(286.1, -29.1, 1001.5, 1.0, -1, -1, -1, 35.0);
	CP_DRUGSTORE		=	CreateDynamicCP(325.5470,1123.4585,1083.9, 1.0, -1,-1,-1, 20.0);	// ����� � �������
	CP_GUNDEAL			=	CreateDynamicCP(-615.85, -477.75, 25.68, 1.0, -1, -1, -1, 10.0);	// ����������� ����������

	for(new i = 0; i < sizeof(j_fJobPos); i++){	j_jobcp[i] = CreateDynamicCP(Arr3<j_fJobPos[i]>, 0.3, -1, 2, -1, 3.0);	}	//	������ �� ����

	//------------------------------[Dynamic Zone]------------------------------
	StripZone[0]	= CreateDynamicRectangle(1212.9, -9.8, 1218.0, -3.1);
	StripZone[1]	= CreateDynamicRectangle(1218.4, 10.5, 1223.1, 5.63);
	PoliceGateZone	= CreateDynamicSphere(1589.1691,-1637.8145,13.4521, 10.0); // ������� ����� ����
	GateInfoZone[0] = CreateDynamicSphere(1544.3156,-1627.3094,13.3828, 10.0); // ������� ��������� ����
	GateInfoZone[1] = CreateDynamicSphere(-2047.1804,-80.8768,35.1641, 12.0); // ������� ��������� ���������
	RaceZone 		= CreateDynamicSphere(2695.63, -1704.69, 11.84, 2.0);	//	���� � ����� �� ��������� ��
	AirportZone[0]	= CreateDynamicSphere(1685.80, -2336.10, 13.56, 5.0, VW_AIRPORT);
	AirportZone[1]	= CreateDynamicRectangle(1684.13, -2335.92, 1687.35, -2334.25, VW_AIRPORT);
	AirportZone[2]	= CreateDynamicRectangle(1646.0074,-2369.5378,1710.7339,-2336.3240, VW_AIRPORT); // ��� ������

	//	Armour Zone
	//	LSPD
	AmmoZone[0] = CreateDynamicRectangle(309.1, -164.1, 310.7, -162.4);
	AmmoZone[1] = CreateDynamicRectangle(310.7, -164.1, 312.5, -162.3);
	AmmoZone[2] = CreateDynamicRectangle(310.7, -162.3, 312.4, -160.7);
	AmmoZone[3] = CreateDynamicRectangle(309.1, -162.4, 310.7, -160.7);
	AmmoZone[4] = CreateDynamicRectangle(313.4, -164.0, 315.0, -162.3);
	AmmoZone[5] = CreateDynamicRectangle(315.0, -164.0, 316.6, -162.3);
	AmmoZone[6] = CreateDynamicRectangle(315.0, -162.3, 316.6, -160.7);
	AmmoZone[7] = CreateDynamicRectangle(313.4, -162.3, 315.0, -160.7);
	AmmoZone[8] = CreateDynamicRectangle(308.4, -159.9, 310.3, -158.5);
	AmmoZone[9] = CreateDynamicRectangle(312.6, -159.4, 314.9, -158.2);
	AmmoZone[10] = CreateDynamicRectangle(317.7, -161.1, 319.4, -158.4);
	//	Ammo 1
	AmmoZone[11] = CreateDynamicRectangle(288.9, -36.2, 290.4, -34.8);
	AmmoZone[12] = CreateDynamicRectangle(288.9, -34.5, 290.5, -32.7);
	AmmoZone[13] = CreateDynamicRectangle(290.4, -36.2, 291.9, -34.5);
	AmmoZone[14] = CreateDynamicRectangle(290.5, -34.5, 291.9, -32.7);
	AmmoZone[15] = CreateDynamicRectangle(294.4, -34.4, 292.9, -32.7);
	AmmoZone[16] = CreateDynamicRectangle(294.4, -36.2, 292.9, -34.4);
	AmmoZone[17] = CreateDynamicRectangle(295.9, -36.2, 294.4, -34.5);
	AmmoZone[18] = CreateDynamicRectangle(295.9, -34.4, 294.4, -32.7);
	AmmoZone[19] = CreateDynamicRectangle(294.7, -38.2, 292.3, -40.4);
	AmmoZone[20] = CreateDynamicRectangle(300.6, -37.2, 299.2, -35.2);
	AmmoZone[21] = CreateDynamicRectangle(298.7, -39.5, 296.6, -37.2);
	//	Ammo Getto
	AmmoZone[22] = CreateDynamicRectangle(291.334, -105.523, 289.034, -106.713);	//	�4
	AmmoZone[23] = CreateDynamicRectangle(293.594, -106.933, 291.334, -105.523);	//	��
	AmmoZone[24] = CreateDynamicRectangle(289.034, -106.713, 287.664, -105.453);
	AmmoZone[25] = CreateDynamicRectangle(287.664, -107.658, 285.936, -105.348);

	AmmoZone[26] = CreateDynamicRectangle(290.155, -109.658, 289.055, -110.738);	//	���������
	AmmoZone[27] = CreateDynamicRectangle(291.315, -110.908, 290.155, -109.658);	//	����
	AmmoZone[28] = CreateDynamicRectangle(289.055, -110.738, 287.325, -109.618);	//	�����
	AmmoZone[29] = CreateDynamicRectangle(293.575, -109.808, 291.315, -110.908);	//	��5

	AmmoZone[30] = CreateDynamicRectangle(298.632, -105.749, 296.872, -108.009);
	AmmoZone[31] = CreateDynamicRectangle(296.822, -103.309, 298.632, -105.749);
	AmmoZone[32] = CreateDynamicRectangle(287.325, -108.288, 286.005, -110.608);	//	�����

	TrainingZone[0] = CreateDynamicRectangle(2225.4, -1143.0, 2216.27, -1155.16, VW_HOTEL);	//	��������� ��� ��������

	GlobalGZ = GangZoneCreate(-20000.0, -20000.0, 20000.0, 20000.0);
	//------------------------------[3D Text Labels]----------------------------
	// testLOS: 0 - ����� ����� �������, 1 - �� �����
	//for(new x = 0; x <= 2; x++)	CreateDynamic3DTextLabel("�������������������", COLOR_ORANGE, 358.6, 168.0, 1008.9, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, x);
	//for(new x = 3; x <= 5; x++)	CreateDynamic3DTextLabel("������� ������������", COLOR_ORANGE, 354.4488, 170.0939, 1026.2964, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, x);
	// CreateDynamic3DTextLabel("����� ����", COLOR_ORANGE, -1714.8666, -63.7032, 4.0547, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	CreateDynamic3DTextLabel("���������� ���\n��������", 0x007CADFF, 1691.34,-2328.56, 14.1, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, VW_NONE);
	CreateDynamic3DTextLabel("�������� ����� ���", 0x007CADFF, 769.87, 13.24, 1001.40, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	CreateDynamic3DTextLabel("�������� ����� ���", 0x007CADFF, 770.36, -23.1, 1001.30, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	CreateDynamic3DTextLabel(ACTION_TEXT, COLOR_ACTION, 245.1, 72.75, 1004.5, 8.0);
	CreateDynamic3DTextLabel("���� �������", 0x000CFFFF, 249.65,69.35,1004.25, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);// LawbookPickup
	CreateDynamic3DTextLabel("����������", 0xFFFFFFFF, 235.41, 72.17, 1005.4, 14.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);// CopGuidePickup
	CreateDynamic3DTextLabel("����������� �������\n{FFFFFF}** �����-������� **", 0x000CFFFF, 1573.0726, -1605.7681, 14.0, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	CreateDynamic3DTextLabel("��������� ������\n" ACTION_TEXT, COLOR_ACTION, 320.41678,1023.88660,1951.0, 1.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0);
	CreateDynamic3DTextLabel("����������� /dance ����� ���������", 0xFF6347FF, 487.7, -14.5, 1001.3, 10.0);
	CreateDynamic3DTextLabel("���������� / ����", 0xCFB53BFF, -1060.89, -1195.5, 130.2, 15.0);
	CreateDynamic3DTextLabel("�����", 0xCFB53BFF, -1060.82, -1205.38, 130.1, 15.0);
	Drug3DText = CreateDynamic3DTextLabel(" ", 0x000000FF, 325.5470,1123.4585,1084.5, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	j_f3DText = CreateDynamic3DTextLabel("�����: 0 ��.", 0xFF8300FF, 2549.3, -1283.9, 1044.1, 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, VW_JAIL, 2);
	j_l3DText = CreateDynamic3DTextLabel("�����: 0 ��.", 0xFF8300FF, 505.3, -2677.2, 13.1, 50);
	UpdateJailStorage();

	//	����� ��������
	for(new i = 0; i < sizeof(HospitalBerth); i++)
	{
		Berth3DText[i] = CreateDynamic3DTextLabel("����� ��������\n" ACTION_TEXT, COLOR_ACTION, Arr3<HospitalBerth[i][0]>, 4.0);
	}
	// ��������
	for(new p = 0; p < sizeof(FillPos); p++)
	{
		CreateDynamicPickup(1244, 1, Arr3<FillPos[p]>);
		CreateDynamic3DTextLabel("* �������� *\n��������� ��������� � �����������", 0xFFFFFFFF, Arr3<FillPos[p]>, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0);
	}

	//	���������
	for(new i = 0; i < sizeof(ATM); i++)
	{
		new Float:X = ATM[i][0], Float:Y = ATM[i][1];
		CreateDynamicObject(2754, Arr6<ATM[i]>);
		GetXYInFrontOfPoint(X, Y, ATM[i][5] + 90.0, 0.7);
		ATM_Zone[i] = CreateDynamicCircle(X, Y, 0.5);
		CreateDynamic3DTextLabel("��������", COLOR_3DTEXT, ATM[i][0], ATM[i][1], ATM[i][2] + 1.25, 8.0);
	}

	// ���� ��� ������
	new Float:zone1[] =
	{//  ���� ������/���
		581.6240, -2713.8054,	487.4910, -2714.1001,	491.8114, -2635.4983,
		524.9461, -2626.6062,	568.9939, -2632.0305,	591.7875, -2645.3855,
		589.7308, -2683.8643
	};
	new Float:zone2[] =
	{//  ���� ��������
		529.0114, -2714.6077,	495.7836, -2714.5776,	494.9553, -2740.1665,
		494.6679, -2754.9326,	493.9542, -2774.7085,	493.7699, -2790.3254,
		495.1075, -2804.2351,	496.9479, -2813.5596,	505.2875, -2817.8433,
		552.6281, -2817.8599,	553.6650, -2793.2856,	553.6649, -2756.8457,
		551.9862, -2748.7175,	535.3809, -2748.7798,	529.1923, -2738.6130,
		529.0114, -2714.6077
	};
	JailGZ = GangZoneCreate(440.2, -3035.7, 826.3, -2565.9);
	JailZone[0] = CreateDynamicRectangle(440.2, -3035.7, 826.3, -2565.9);
	JailZone[1] = CreateDynamicPolygon(zone1, -FLOAT_INFINITY, FLOAT_INFINITY, sizeof(zone1), 0, 0);
	JailZone[2] = CreateDynamicPolygon(zone2, -FLOAT_INFINITY, FLOAT_INFINITY, sizeof(zone2), 0, 0);

	//  GreenZones
	for(new i = 0; i < sizeof GreenZones; i++)
	{
	    area_GreenZones[i] = CreateDynamicRectangle(Arr4<GreenZones[i]>, 0, 0);
	}

	//////////	Timers 	//////////
	SetTimer("AnticheatTimer", 950, true);

	//------------------------------[Others]------------------------------------
	CreateStaticMenu();     //	����
	CreateStaticObject();   //	�������
	CreateCutSceneDecor();	//	��������� ���-����
	return true;
}// end of OnGameModeInit()

public OnGameModeExit()
{
	mysql_query_ex("UPDATE `players` SET `online` = '-1' WHERE `online` > '-1'");

	SaveHouse();
	SaveBiz();

	mysql_close(g_SQL);
	return true;
}

IsPlayerAimingAt(playerid, Float:x, Float:y, Float:z, Float:radius)
{
	new Float:camera_x, Float:camera_y, Float:camera_z,
		Float:vector_x, Float:vector_y, Float:vector_z;
	GetPlayerCameraPos(playerid, camera_x, camera_y, camera_z);
	GetPlayerCameraFrontVector(playerid, vector_x, vector_y, vector_z);

	new Float:vertical, Float:horizontal;
	switch (GetPlayerWeapon(playerid))
	{
		case 34, 35, 36:
		{
			if (DistanceCameraTargetToLocation(camera_x, camera_y, camera_z, x, y, z, vector_x, vector_y, vector_z) < radius)
				return (1);
			return (0);
		}
		case 30, 31:
		{
			vertical = 4.0;
			horizontal = -1.6;
		}
		case 33:
		{
			vertical = 2.7;
			horizontal = -1.0;
		}
		default:
		{
			vertical = 6.0;
			horizontal = -2.2;
		}
	}

	new Float:angle = GetPointAngleToPoint(0, 0, floatsqroot(vector_x * vector_x + vector_y * vector_y), vector_z) - 270.0;
	new Float:resize_x, Float:resize_y, Float:resize_z = floatsin(angle+vertical, degrees);
	GetXYInFrontOfPoint(resize_x, resize_y, GetPointAngleToPoint(0, 0, vector_x, vector_y)+horizontal, floatcos(angle+vertical, degrees));

	if (DistanceCameraTargetToLocation(camera_x, camera_y, camera_z, x, y, z, resize_x, resize_y, resize_z) < radius)
		return (1);
	return (0);
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(GetWeaponSlot(weaponid) == 255)	return false;
	if(!gPlayerLogged[playerid])		return false;
	if(IsPlayerNPC(playerid))			return true;

	new string[128];
	if(showDebug[playerid])
	{
		SendFormatMessage(playerid, -1, string, "OnPlayerWeaponShot [weaponod = %d, hittype = %d, hitid = %d, %f %f %f]", weaponid, hittype, hitid, fX, fY, fZ);
	}

	SetPVarInt(playerid, "Player:LastShotTime", GetTickCount());

	if(hittype == BULLET_HIT_TYPE_PLAYER && hitid != INVALID_PLAYER_ID)
	{
		// ������ ���
		if(InGangZone[playerid] >= 0 && GangZoneStatus[InGangZone[playerid]] == 0)
		{
			new zone = InGangZone[playerid];
		    if((PlayerInfo[playerid][pFaction] == GangZoneOwner[zone] && PlayerInfo[hitid][pFaction] == GangZoneEnemy[zone])
		    || (PlayerInfo[hitid][pFaction] == GangZoneOwner[zone] && PlayerInfo[playerid][pFaction] == GangZoneEnemy[zone]))
		    {
				SetPlayerArmedWeapon(playerid, 0);
				ShowPlayerHint(playerid, "�� ����� ��������~n~��������� ~r~���������");
				return false;
		    }
		}
		// ������
		if(IsPlayerNPC(hitid) == 0)
		{
			if(GetPVarInt(playerid, "Player:InGreenZone") || GetPVarInt(hitid, "Player:InGreenZone")
			|| IsPlayerInGreenZoneVW(playerid) || IsPlayerInGreenZoneVW(hitid))	// Green Zone
			{
				if(!(GetPlayerWantedLevel(playerid)	&& PlayerInfo[hitid][pFaction] == F_POLICE)
				&& !(GetPlayerWantedLevel(hitid)	&& PlayerInfo[playerid][pFaction] == F_POLICE))
			    {	// ���� playerid � hitid �� ����������� � ����������
					return false;
				}
			}
		}
	}
	else if(hittype == BULLET_HIT_TYPE_VEHICLE)
	{
	    new driverid = VehInfo[hitid][vDriver];
	    if(driverid != (-1))
	    {
			if(PlayerInfo[playerid][pFaction] == F_POLICE)
			{
			    if(CriminalDanger[driverid] == false)
			    {
					GivePoliceWarn(playerid, 50, "������������� ���������");
					SetPlayerArmedWeapon(playerid, 0);
				}
			}
			else if(PlayerInfo[driverid][pFaction] == F_POLICE)
			{
			    if(InGangZone[playerid] == -1)
			    {
					ToggleCriminalDanger(playerid, true);
					CrimePlayer(playerid, CRIME_COP_KILL);
				}
			}
			// ������ ���
			if(InGangZone[playerid] >= 0 && GangZoneStatus[InGangZone[playerid]] == 0)
			{
				new zone = InGangZone[playerid];
			    if((PlayerInfo[playerid][pFaction] == GangZoneOwner[zone] && PlayerInfo[driverid][pFaction] == GangZoneEnemy[zone])
			    || (PlayerInfo[driverid][pFaction] == GangZoneOwner[zone] && PlayerInfo[playerid][pFaction] == GangZoneEnemy[zone]))
			    {
					SetPlayerArmedWeapon(playerid, 0);
					ShowPlayerHint(playerid, "�� ����� ��������~n~��������� ~r~���������");
					return false;
			    }
			}
	    }
	}
	else if(hittype == BULLET_HIT_TYPE_PLAYER_OBJECT)
	{
 		if(p_isShooting{playerid})
		{
			for(new i = 1; i < 8; i++)
			{
				if(hitid == p_ShootingTargetObjects[playerid][i])
				{
					p_ShootingHits{playerid}++;
					new max_progress = (3 * 3 * 7);
					new cur_progress =
						(((PlayerInfo[playerid][pShooting] - 1) * 3 * 7)
						+ (p_ShootingWave{playerid} * 7)
						+ p_ShootingHits{playerid});
					IFace.ShowPlayerProgress(playerid,
						cur_progress, max_progress, "Progress");
					if (p_ShootingHits{playerid} == 7)
					{
						new Float:obj_pos[3];
						GetPlayerObjectPos(playerid, p_ShootingTargetObjects[playerid][0], Arr3<obj_pos>);
						MoveTirTarget(playerid,	obj_pos[0] - TIR_MODIFY_POS, obj_pos[1], obj_pos[2]);
						SetTimerEx("NextShootingTarget", 1500, false, "d", playerid);
						return true;
					}
				}
			}
		}
	}
	// �������������
	if(PS_NONE < PursuitStatus[playerid] < PS_CRIMINAL)
	{
		ToggleCriminalDanger(playerid, true);
		CrimePlayer(playerid, CRIME_RESIST);
		if(PursuitCrimTransit[playerid])	CrimePlayer(playerid, CRIME_CARRY_CRIMINAL);
	}
	return true;
}

stock GivePlayerDamage(playerid, Float:amount)
{
    new Float:health = MyGetPlayerHealth(playerid);
    new Float:armour = MyGetPlayerArmour(playerid);
    if(armour > 0.0)
    {
        if(amount >= armour)
        {
            health = health - (amount - armour);
            MySetPlayerArmour(playerid, 0.0);
            MySetPlayerHealth(playerid, health);
        }
        else MySetPlayerArmour(playerid, armour-amount);
    }
    else MySetPlayerHealth(playerid, health-amount);
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	// Float:amount (�������������)
	// bodypart: 9 - ������, 8 - ������ ����, 7 - ����� ����, 6 - ������ ����, 5 - ����� ����, 4 - ����, 3 - ������
	if(issuerid == INVALID_PLAYER_ID)
		return (0);
	if (IsPlayerNPC(playerid) || !gPlayerLogged[playerid])
		return (1);

	new string[128];
	if(showDebug[playerid])
	{
		SendFormatMessage(playerid, -1, string, "OnPlayerTakeDamage [issuerid = %d, amount = %f, weaponid = %d, bodypart = %d]", issuerid, amount, weaponid, bodypart);
	}

	if (issuerid != INVALID_PLAYER_ID)
	{
		//	������� �����������
		if (!IsPlayerBoxing(issuerid) && gPlayerBoxEnemy[issuerid] != playerid)
		{
			new gtc = GetPVarInt(issuerid, "Player:Attack:LastAttack");
			new Float:dmg = GetPVarFloat(issuerid, "Player:Attack:GiveDmg") + amount;
			if (GetTickCount() > gtc + 60000)
				dmg = amount;
			if (dmg > 5.0)
			{
				if (!IsForce(PlayerInfo[issuerid][pFaction]))
				{
					//	������ ���� ���������
					SetPVarInt(issuerid, "Player:Attack:Attacker", true);
					SetPVarInt(issuerid, "Player:Attack:GTC", GetTickCount());
					foreach(LoginPlayer, i)
					{
						if (PlayerInfo[i][pFaction] != F_POLICE)
						{
							MySetPlayerMarkerForPlayer(i, issuerid, 0xFF0000FF);
						}
					}
				}
			}
			SetPVarFloat(issuerid,	"Player:Attack:GiveDmg",	dmg);
			SetPVarInt(issuerid,	"Player:Attack:LastAttack",	GetTickCount());
		}

	    if (weaponid == 50 && amount < 1.0)
	    {
	        new vehid = GetPlayerVehicleID(issuerid);
	        if (vehid > 0)
	        {
		        new Float:X, Float:Y, Float:Z;
		        GetVehiclePos(vehid, X, Y, Z);
		        MySetPlayerPos(playerid, X, Y, Z + 2.0);
		        ClearAnimations(playerid);
	        }
	        return false;
	    }
	
		new weap = GetPlayerWeapon(issuerid);
		if (weap != weaponid || GetPlayerState(issuerid) != PLAYER_STATE_ONFOOT)
			return (0);
		else if (weaponid >= 0 && weaponid <= 15 || weaponid == 37
			|| weaponid == 41 || weaponid == 42)
		{
			if(GetDistanceBetweenPlayers(playerid, issuerid) > 4.0)
				return (0);
			if(GetTickCount() - GetPVarInt(issuerid, "Player:LastAttack") > 500 + GetPlayerPing(playerid))
				return (0);
		}

//		GivePlayerDamage(playerid, amount);
//		gDamageUnix[issuerid] = gettime();
//		gDamageSum[issuerid] = amount);
		/*if(22 <= weaponid <= 34)
		{
			PlayerPlaySound(issuerid, 6401, 0.0, 0.0, 0.0);
		}*/
		if(PlayerInfo[issuerid][pFaction] == F_POLICE)
		{	// ����� �����������
			if(PLAYER_STATE_ONFOOT <= GetPlayerState(playerid) <= PLAYER_STATE_PASSENGER)
			{
				if(robbery_step[playerid] == 1)	robbery_money[playerid] -= 50;
				if(CriminalDanger[playerid] == false)
				{// ������������� ���������� ����
				    GivePoliceWarn(issuerid, 50, "������������� ���������");
				    SetPlayerArmedWeapon(issuerid, 0);
				}
				else
				{
					if(GetPlayerWeapon(issuerid) == WEAPON_NITESTICK)
					{
						if(PlayerCuffedTime[playerid])
						{
							SendClientMessage(issuerid, COLOR_WHITE, PREFIX_ERROR "����� ��� �������.");
						}
						else
						{
							FadeColorForPlayer(playerid, 0, 168, 107, 255, 0, 0, 255, 0, 50);
							amount = 0;
							format(string, sizeof(string), "������� %s'�.", ReturnPlayerName(playerid));
							PlayerAction(issuerid, string);
							SendClientMessage(issuerid, COLOR_WHITE, "���������� �������� �������, ������� ALT ��� ���������� ������");
							if(GetPVarInt(playerid, "Police:Pursuit:Handsup"))	PursuitHandsupClear(playerid);
							GameTextForPlayer(playerid, "~r~Tazed", 3000, 3);
							ApplyAnimation(playerid, "CRACK", "crckdeth4", 4.0, 0, 1, 1, 1, 0);
							BlockPlayerAnimation(playerid, true);
							PlayerCuffedTime[playerid] = 20;
						}
					}
				}
			}
		}
		else if(PlayerInfo[playerid][pFaction] == F_POLICE)
		{	// ������ �� ������������
			if(IsPlayerNPC(issuerid) == 0)
			{
				if(weaponid != 50 || bodypart != 3 || GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
				{
				    if(InGangZone[issuerid] == -1)
				    {
						ToggleCriminalDanger(issuerid, true);
			        	CrimePlayer(issuerid, CRIME_COP_KILL);
		        	}
				}
			}
		}
		if(HEADSHOT && bodypart == 9)
		{
			MySetPlayerHealth(playerid, 0.0);
			GameTextForPlayer(playerid, "Head shot!", 3000, 4);
			GameTextForPlayer(issuerid, "Head shot!", 3000, 4);
		}
		//if(weaponid == 3) MyApplyAnimation(playerid, "PED", "GETUP_FRONT", 4.0, 0, 1, 1, 0, 0);
	}

	/*if(1 <= GetPlayerState(playerid) <= 3)
	{
	    new Float:health = MyGetPlayerHealth(playerid);
	    new Float:armour = MyGetPlayerArmour(playerid);
	    if(0 <= weaponid <= 15)
	    {
			new string[128], Float:effect;
	        if(armour)
	        {
	            switch(random(6))
	            {
	                case 0: effect = amount*Power[issuerid];
	                case 1,2,3: effect = amount*(Power[issuerid]/2);
	                case 4: effect = amount*(Power[issuerid]/3);
	                case 5:
	                {
	                    if(weaponid == 0)
	                    {
						    new Float:health2 = MyGetPlayerHealth(issuerid);
						    MySetPlayerHealth(issuerid, health2-2.0);
		                    SendClientMessage(issuerid, COLOR_GREY, "�� ��������� ���� �� �����");
	                    }
	                }
	            }
	        }
	        else effect = amount*Power[issuerid];
			MySetPlayerArmour(playerid, armour);
			MySetPlayerHealth(playerid, health-effect);
		    format(string, 128, "%s[%d] got %0.2f damage (h: %0.2f | %0.2f)",ReturnPlayerName(playerid),playerid, effect, health,health-effect);
		    MySendClientMessageToAll(COLOR_WHITE, string);
	    }
	    else
	    {
		    if(armour)
		    {
		        if(amount >= armour)
		        {
		            health = health - (amount - armour);
		            MySetPlayerArmour(playerid, 0.0);
		            MySetPlayerHealth(playerid, health);
		        }
		        else MySetPlayerArmour(playerid, armour-amount);
		    }
		    else MySetPlayerHealth(playerid, health-amount);
	    }
    }*/

    // ������ �����������
    if(amount > 4)
    {
		FadeColorForPlayer(playerid, 255, 0, 0, floatround(amount, floatround_ceil) * 10, 255, 0, 0, 0, floatround(amount, floatround_ceil));
    }
    return true;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	if(IsPlayerNPC(playerid))
	{
		return true;
	}
	GivePlayerDamage(damagedid, amount);
	if(22 <= weaponid <= 34)
	{
		PlayerPlaySound(playerid, 6401, 0.0, 0.0, 0.0);
	}
	return true;
}

public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{
    /*if(ANTICHEAT)
	{
		new string[128];

		if(VehInfo[vehicleid][vPlayers] == 0 && IsPlayerInRangeOfPoint(playerid, 20.0, Arr3<oldpos>) == 0 && GetDistanceFromPointToPoint(new_x, new_y, new_z, Arr3<oldpos>) > 10.0)
		{
			if(oldpos[2] > 0.0) MySetVehiclePos(vehicleid, Arr3<oldpos>);
			format(string, sizeof(string), "[AdmWrn]: %s[%d] ������������� � ������������ ����������� (vehicleid = %d)", ReturnPlayerName(playerid), playerid, vehicleid);
			SendAdminMessage(COLOR_LIGHTRED, string);
			GiveAnticheatWarn(playerid, VEHICLE_TELEPORT);
			return false;
		}
	}*/
	if(VehInfo[vehicleid][vBlockMove] && GetDistanceFromPointToPoint(new_x, new_y, new_z, Arr3<VehInfo[vehicleid][vPos]>) > 1.0)
	{
		MySetVehiclePos(vehicleid, Arr4<VehInfo[vehicleid][vPos]>);
		return false;
	}
	// ���������� ���� ��� ��������� � ���
	if(passenger_seat) return false; // [BT]
	return true;
}

Public: OnPlayerPauseStateChange(playerid, pausestate)
{
	#if defined _gang_gang_zones_included
		Gang.GZ_OnPlayerPause(playerid, pausestate);
	#endif

	new string[128];
	if(pausestate)
	{	//  ����� � ���
		OldSpeed[playerid] = 0;	//	fix ������ ����� ������ �� ���

		StopPursuit(playerid, 3);
	}
	else
	{	
		if(gPlayerLogged[playerid])
		{
			//  ����� � ���
			new afk_time = GetPlayerAFKTime(playerid);
			format(string, sizeof(string), "�� ���� � AFK {CFB53B}%02d:%02d.", afk_time / 60, afk_time % 60);
			SendClientMessage(playerid, COLOR_WHITE, string);
			SetPlayerChatBubble(playerid, " ", COLOR_WHITE, 30.0, 1);
		}

		// ������������ �� ������
		if(0 < PlayerInfo[playerid][pJailTime] < gettime())
		{
			//JailDelivery(playerid);
		}

		//---	Spectate
		if(SpectateID[playerid] != INVALID_PLAYER_ID)
		{
			UpdatePlayerSpectate(playerid, SpectateID[playerid]);
			//Timer_UpdatePlayerSpectate(playerid, SpectateID[playerid]);
		}
	}
	return true;
}

TogglePlayerStreamerAllItem(playerid, toggle)
{
	if(toggle)
	{
		//	�������� ������ �������� ��������
		Streamer_ToggleItemUpdate(playerid, STREAMER_TYPE_PICKUP, true);
		Streamer_ToggleItemUpdate(playerid, STREAMER_TYPE_RACE_CP, true);
	  	Streamer_ToggleItemUpdate(playerid, STREAMER_TYPE_AREA, true);
	  	Streamer_ToggleItemUpdate(playerid, STREAMER_TYPE_CP, true);
	}
	else
	{
		//	��������� ������ �������� ��������
	  	Streamer_ToggleItemUpdate(playerid, STREAMER_TYPE_PICKUP, false);
	  	Streamer_ToggleItemUpdate(playerid, STREAMER_TYPE_RACE_CP, false);
	  	Streamer_ToggleItemUpdate(playerid, STREAMER_TYPE_AREA, false);
	  	Streamer_ToggleItemUpdate(playerid, STREAMER_TYPE_CP, false);
	}
	return true;
}

public OnPlayerEverySecondTimer(playerid)
{
	new i = playerid;
 	if(gPlayerLogged[i] == false)
    {
    	if(LOGTIMEOUT && ++gLoggedTime[i] == MAX_LOGGED_TIME)
    	{
    		SendClientMessage(i, COLOR_SERVER, "�������� ������� �����������, �� ���� �������.");
    		KickEx(i);
    	}
    	return true;
    }
    // Only for Logged Players

    //	--- vars
    new string[128];
    new hour, minute, second;
	new timeUNIX = gettime(hour, minute, second);
	new vehicleid = GetPlayerVehicleID(i),
		inter = GetPlayerInterior(i),
		vw = GetPlayerVirtualWorld(i),
		pState = GetPlayerState(i),
		targetid = GetPlayerTargetPlayer(i),
		targetactor = GetPlayerTargetActor(i),
		money = MyGetPlayerMoney(i),
		Float:X, Float:Y, Float:Z, Float:A,
		biz = GetBizWhichPlayer(i);
    if(vehicleid == 0)	MyGetPlayerPos(i, X, Y, Z, A);
    else				MyGetVehiclePos(vehicleid, X, Y, Z, A);
	new Float:pHealth = MyGetPlayerHealth(i);
	new Float:Dist = floatsqroot(floatpower(X - PlayerInfo[i][pPosX], 2) + floatpower(Y - PlayerInfo[i][pPosY], 2) + floatpower(Z - PlayerInfo[i][pPosZ], 2));

	//---	Protection Dialogs
	if(Dialogid[i] != INVALID_DIALOGID && DialogTimeleft[i] > 0 && --DialogTimeleft[i] == 0)
	{
		GameTextForPlayer(i, "~r~Dialog canceled", 3000, 4);
		DialogTimeleft[i] = INVALID_DATA;
		CallLocalFunction(
			"OnDialogResponse","iiiis",i, Dialogid[i], 0, 0, " ");
		// E��� � OnDialogResponse �� �������� ������ �������, ��������� �������
		if(DialogTimeleft[i] == INVALID_DATA)
			MyHidePlayerDialog(i);	
	}
	//	--- Counters
	if(p_PrisonTimer{i})					SetPlayerVisualTimer(i, PrisonStatusTime, false);	//	Update Prison Timer
	if(EffectCheck{i} > 0)					EffectCheck{i}--;									//  Effect
	if(gPickupTime[i] > 0)					gPickupTime[i]--;									// ������� ���������� ����������� �����/������
	if(p_ShootingCountdown{i} > 0 && --p_ShootingCountdown{i} == 0)	StartPlayerTirShooting(i);	//	������ �������� � ����
	if(PlayerInfo[i][pMuteTime] > 0 && --PlayerInfo[i][pMuteTime] <= 0)	// ������� ��������
	{
	    PlayerInfo[i][pMuteTime] = 0;
	    SendClientMessage(i, COLOR_WHITE, "����� �������� �����������, �� ����� ������ ��������");
	}
	if(gExpTime[i] > 0 && --gExpTime[i] == 0)	// ������� ������ ����� ����� �����
	{
	    if(gExpCount[i] > 0.5)	GivePlayerEXP(i, floatround(gExpCount[i]));
	    gExpCount[i] = 0.0, gExpTime[i] = 0;
	}
	if(PlayerCuffedTime[i] > 0)
	{
	    if(--PlayerCuffedTime[i] <= 0)
	    {
	    	BlockPlayerAnimation(i, false);
			ClearAnimations(i);
	        PlayerCuffedTime[i] = 0;
	    }
	}
	if(GetPVarInt(i, "Player:Attack:Attacker"))
	{
		if(GetTickCount() > GetPVarInt(i, "Player:Attack:GTC") + (5 * 60 * 1000))
		{
			DeletePVar(i, "Player:Attack:Attacker");
			foreach(LoginPlayer, j)
			{
				if(PlayerInfo[j][pFaction] != F_POLICE)
				{
					MySetPlayerMarkerForPlayer(j, i, GetPlayerColor(i));
				}
			}
		}
	}

	//---	Missions
	if(mission_id[i] == MIS_START_WORK)
	{
		if(money < 300)
		{
			format(string, sizeof(string), "����������� �� �����. ��������� ~g~%d/300$", MyGetPlayerMoney(i));
			ShowMissionInfo(i, string);
		}
		else
		{
			StoryMissionComplete(i, MIS_SOURCE_TRAINING, 0, 0);
			StoryMissionStart(i, MIS_SOURCE_TRAINING);
		}
	}

	//---	����������� ����� ���� ��� ���������
	#if defined	_job_job_theft_included	
		if(PlayerInfo[i][pTheftTime] != 0 && PlayerInfo[i][pTheftTime] + THEFT_RELOAD_TIME < timeUNIX)
		{
			PlayerInfo[i][pTheftTime] = 0;
			if(Job.GetPlayerJob(i) == JOB_THEFT) ShowPlayerHint(i, "�� ����� ������ ���������� �������� ���� � �����!");
		}
	#endif	

	#if defined _police_pursuit_included
		UpdateIconReinforce(i);
	#endif

	//	---
	if(PLAYER_STATE_ONFOOT <= pState <= PLAYER_STATE_PASSENGER)
	{
		#if defined _player_phone_included	
			Phone_CallTimer(i);
		#endif
		#if defined	_job_job_taxi_included
			Taxi_PlayerEverySecondTimer(i, Dist);
		#endif

		// ���������� ������� ������
        if(PlayerBusy{i} == false && X != 0.0 && Y != 0.0)
        {
        	if(vehicleid == 0 || (VehInfo[vehicleid][vModelType] != MTYPE_BOAT && VehInfo[vehicleid][vModelType] != MTYPE_HELIC && VehInfo[vehicleid][vModelType] != MTYPE_PLANE))
	        {
	        	PlayerInfo[i][pPosX] = X;
		        PlayerInfo[i][pPosY] = Y;
		        PlayerInfo[i][pPosZ] = Z;
		        PlayerInfo[i][pPosA] = A;
			    PlayerInfo[i][pPosINT] = inter;
			    PlayerInfo[i][pPosVW] = vw;
	        }
	    }
        IFace.HealthUpdate(i, pHealth);
		if(second % 5 == 0)	
		{
			UpdatePlayerZone(i);
			UpdatePlayerGPSZone(i);		// GPS ���������
		}

		if(0 < PlayerInfo[i][pAJailTime] < gettime())
		{
			SetPlayerSpawn(i);
			MySpawnPlayer(i);
		}

		//	AFK
		if(IsPlayerAFK(i))
		{
			new afk_time = GetPlayerAFKTime(i);
			format(string, sizeof(string), "� AFK {CFB53B}(%02d:%02d)", afk_time / 60, afk_time % 60);
			SetPlayerChatBubble(i, string, COLOR_WHITE, 30.0, 2000);
		}
		//---	OnPlayerAimVehicle
        new VehicleTarget = GetPlayerCameraTargetVehicle(i);
		if(VehicleTarget != gTargetVehicle[i])
		{
			gTargetVehicle[i] = VehicleTarget;
			if(gTargetVehicle[i] != INVALID_VEHICLE_ID && gPressedKeyAIM[i])
			{
				OnPlayerAimVehicle(i, gTargetVehicle[i]);
			}
		}

		//	hint
		if(GetPVarInt(i, "Player:HintPressH"))
		{
			if(targetid == INVALID_PLAYER_ID && targetactor == INVALID_ACTOR_ID)
			{
				if(GetPVarType(i, "Player:InAmmoZone") == PLAYER_VARTYPE_NONE)
				{
					TextDrawHideForPlayer(i, TD_PressH);
				}
				DeletePVar(i, "Player:HintPressH");
			}
		}
		else if(!(22 <= GetPlayerWeapon(i) <= 33))
		{
			if(targetid != INVALID_PLAYER_ID)
			{
				TextDrawShowForPlayer(i, TD_PressH);
				SetPVarInt(i, "Player:HintPressH", 1);
			}
			else if(targetactor != INVALID_ACTOR_ID)
			{
				new bool:find = false;
				for(new a = 0; a < sizeof(ACTOR); a++)
				{
					if(ACTOR[a] == targetactor)
					{
						find = true;
						if(ActorInfo[a][a_Hint])
						{
							TextDrawShowForPlayer(i, TD_PressH);
							SetPVarInt(i, "Player:HintPressH", 1);
						}
						break;
					}
				}
				if(!find)
				{
					TextDrawShowForPlayer(i, TD_PressH);
					SetPVarInt(i, "Player:HintPressH", 1);
				}
			}
		}
		//---	����� �� ������� (� ����� ��������)
		//if(IsPlayerInSquare(i, 1706.45, -1926.98, 1726.52, -1907.03))
		//{
		//    if(second % 15 == 0) MyGivePlayerMoney(i, 1);	// 3600 / 15 = 240$/���
		//}
		//---	Hospital
		if(GetPVarType(i, "Player:Hospital:Berth") == PLAYER_VARTYPE_INT)
		{
			if(second % 3 == 0)
			{
			    if(GetPlayerSpeed(i) > 1.0)
			    {
					CancelPlayerBerth(i);
			    }
			    else
			    {
					new Float:health = MyGetPlayerHealth(i);
					if(health < 100.0)
					{
						MySetPlayerHealth(i, health + 1.0);
					}
					else
					{
						SendClientMessage(i, COLOR_GREEN, "�� ��������� �������!");
						CancelPlayerBerth(i);
					}
				}
			}
			GameTextForPlayer(i, "~w~HEALING~n~Press ~r~N~w~ to stop", 1200, 4);
		}
		//	���������
		if(DrugsCrack[i])
		{
			if(IsPlayerInAnyVehicle(i)) RemovePlayerFromVehicle(i);
			else 						MyApplyAnimation(i, "CRACK", "crckdeth2", 4.1, 0, 1, 1, 1, 0, 1);
		}
		if(UseDrugsTime[i] > 0)
		{
		    if(--UseDrugsTime[i] <= 120)
		    {
		        if(DrugsCrack[i])
		        {
		            DrugsCrack[i] = false;
		            ClearAnimations(i);
		        }
		        if(!UseDrugsTime[i])	UpdatePlayerWeather(i);
		    }
		}
		//---   Robbery
		if(robbery_biz[i] == (-1))
		{
			if(biz != INVALID_DATA
				&& targetactor == BizInfo[biz][bActor]
				&& 22 <= GetPlayerWeapon(i) <= 33
				&& IsGang(PlayerInfo[i][pFaction]))
			{
				RobberyStart(i);
			}
		}
		else if(robbery_step[i] == 1)
		{
			if(robbery_money[i] > 0)
			{
				format(string, sizeof(string), "��������� ������ �� ���� �����: %d$", robbery_money[i]);
				SendMissionMessage(i, string, 1300);
			}
			else	RobberyFinish(i, 1, false);
		}
        //	---
        if(PlayerCuffedTime[i] > 0)
        {
			new animlib[32],  animname[32];
	        GetAnimationName(GetPlayerAnimationIndex(i), animlib, 32, animname, 32);
	        if(!strcheck(animlib, "CRACK") && !strcheck(animname, "crckdeth4"))
	        {
	        	ApplyAnimation(i, "CRACK", "crckdeth4", 4.0, 0, 1, 1, 1, 0);
	        	//format(string, sizeof(string), "[AdmWrn]: %s[%d] �������� ��� �������� �� ����� ���������", ReturnPlayerName(i), i);
				//SendAdminMessage(COLOR_LIGHTRED, string);
	        }
		}
        //	---	hunger
    	if(second % 40 == 0)
    	{
			if(PlayerInfo[i][pHunger] > 0)
            {
            	PlayerInfo[i][pHunger]--;
            	IFace.HungerUpdate(i);
            }
            else if(IsPlayerAFK(i) == false)
			{
				pHealth -= 1.0;
				MySetPlayerHealth(i, pHealth);
			}
    	}
    	if(pHealth < 100 && second % 15 == 0)
    	{
    		if(PlayerInfo[i][pHunger] > 80)
    		{
    			pHealth += 1.0;
				MySetPlayerHealth(i, pHealth);
    		}
    	}
		//	---	achievements
	#if defined _player_achieve_included	
		if(GetPlayerDistanceFromPoint(i, -2300.22, -1649.94, 483.5) < 50.0)
		{
			GivePlayerAchieve(i, ACHIEVE_RESEARCHER);	//	���������� '�������������'
		}
	#endif
		if(BB_Time > 0)
		{
			new Float:pos[3];
			GetVehiclePos(BB_Car, Arr3<pos>);
			if(GetPlayerDistanceFromPoint(i, Arr3<pos>) < 30.0)
			{
			#if defined _player_achieve_included	
				GivePlayerAchieve(i, ACHIEVE_WALTER);	//	���������� '����� ���'
			#endif
				if(BB_Time > 2)	BB_Time = 2;            //  ���� ����� ����� �������, ������ ��������� ����� 2 ������
			}
		}
		//	--- drink
		if(pState == PLAYER_STATE_ONFOOT && GetPlayerDrunkLevel(i) && ++PlayerDrunkTime{i} == 8)
		{
			if(GetPlayerDrunkLevel(i) > 25000)
			{
				if(random(10) == 0)					MyApplyAnimation(i, "FOOD","EAT_Vomit_P", 4.0, 0, 1, 0, 0, 0);
				else 								MyApplyAnimation(i, "PED", "WALK_DRUNK", 4.0, 0, 1, 0, 0, 0);
			}
			else if(GetPlayerDrunkLevel(i) > 15000)	MyApplyAnimation(i, "PED", "WALK_DRUNK", 4.0, 0, 1, 0, 0, 0);
			PlayerDrunkTime{i} = 0;
		}
		//	--- car break check
		//if(GetPlayerComb(i) == COMB_THEFT_AUTO)
		//{   // ����� ����� ����� ���
			//new keys, ud, lr;
		    //GetPlayerKeys(i, keys, ud, lr);
		    //if(ud || lr || (keys && keys != KEY_ANALOG_LEFT && keys != KEY_ANALOG_RIGHT && keys != KEY_WALK))
		    //{	//  ���� ����� ����� �� ����� ������ �������� �����
			//	clearHackCar(i);
		    //}
			//else 
		//	if(VehInfo[ GetPVarInt(i, "LastLockCar") ][vLocked] == 0)
		//	{
		//		GameTextForPlayer(i, "~w~Vehicle already ~g~open", 3000, 4);
		//		clearHackCar(i);
		//	}
		//}
	    // ������ � ��������� Cargobob
	    if(GetPlayerInterior(i) == 9 && GetVehicleModel(vw) == 548 && Z < 1925.0)
	    {
			new Float:anX, Float:anY, Float:anZ, Float:anA;
			MyGetVehiclePos(vw, anX, anY, anZ, anA);
			anX += (6.0 * floatsin(-anA + 180.0, degrees));
			anY += (6.0 * floatcos(-anA + 180.0, degrees));

			MyClearPlayerWeaponSlot(i, 11);
	        SetTimerEx("MyGivePlayerParachute", 1000, false, "i", i);

	        MySetPlayerPos(i, anX, anY, anZ);
	        SetPlayerVirtualWorld(i, 0);
	        SetPlayerInterior(i, 0);
	        PlayerBusy{i} = false;
	    }
	    //---	fix furniture
		if(GetPVarType(i, "Fur:HouseID") != PLAYER_VARTYPE_NONE)
		{
			new h = GetPVarInt(i, "Fur:HouseID");
			new Class = HouseInfo[h][hClass] - 1,
        		Int = HouseInfo[h][hInt] - 1;
			if(IsPlayerInRangeOfPoint(i, 50.0, Arr3<InterCoords[Class][Int]>) == 0)
			{
				MySetPlayerPos(i, Arr3<InterCoords[Class][Int]>, InterCoords[Class][Int][3] + 180.0);
				CancelEditHomeObject(i);
			}
		}
		// ������������� ������ (������ ������������ return)
	#if defined _police_pursuit_included
		if(PlayerInfo[i][pFaction] == F_POLICE && 22 <= GetPlayerWeapon(i) <= 33)
		{
			if(targetid != INVALID_PLAYER_ID)
			{
				StartPursuit(i, targetid);
			}
		}
	#endif		
		//---	���
		if(p_isShooting{i})
		{
			new weapon, ammo;
			GetPlayerWeaponData(i, 2, weapon, ammo);
			if(weapon != 22 || ammo == 0)	FinishPlayerShooting(i, true);
		}
		//---	�������� ����������� � ������
		if(PlayerInfo[i][pJailTime] > 0)
		{
		    if(second % 3 == 2 && !IsPlayerAFK(i))
		    {
				if(!IsPlayerInRangeOfPoint(i, 350.0, 570.2847, -2772.5239, 33.7913)		//	���������� ������
				&& !(VW_JAIL <= GetPlayerVirtualWorld(i) < VW_JAIL + 1000))				//	��������� ������
				{
				    PlayerInfo[i][pJailTime] = 0;
					Iter_Remove(Prisoners, i);
					JailJobClear(i);
					UpdatePlayerSkin(i);
					DeleteJailNumber(i);
					PlayerTextDrawHide(i, p_JailPeriod);
					HidePlayerPrisonTime(i);
				    CrimePlayer(i, CRIME_RUNAWAY);
				    GameTextForPlayer(i, "~r~!!!WARNING!!!~n~~w~You are wanted", 5000, 4);
				}
		    }
		    if(IsPlayerSwiming(i))	MySetPlayerHealth(i, pHealth - 4.0);
		}
		else if(PlayerInfo[i][pJailTime] == 0)
		{
		    if(PlayerInfo[i][pFaction] != F_POLICE && IsPlayerInSquare(i, 440.2, -3035.7, 826.3, -2565.9) && GetPlayerWantedLevel(i) < 8)
		    {
				if(InJailTimer[i] > 0)
				{
					if(--InJailTimer[i] == 0)
					{
						CrimePlayer(i, CRIME_IN_JAIL);
					}
					else
					{
					    format(string, sizeof(string), "~r~WARNING!~n~~r~%d sec~n~~w~Leave the prison!", InJailTimer[i]);
						GameTextForPlayer(i, string, 2000, 4);
					}
				}
				else
				{
			        InJailTimer[i] = 20;
					SendClientMessage(i, COLOR_WHITE, PREFIX_HINT "��� �������� ���������� ������! �������� �� ��� ��� ������� � ������!");
				}
			}
			else if(InJailTimer[i] > 0)
			{
			    InJailTimer[i] = 0;
			    GameTextForPlayer(i, "~g~allright", 3000, 4);
			}
		}
		// ������� ����������
		if(JailTime[i]-- > 0)
		{
		    if(second % 5 == 0 && IsPlayerInJail(i) == 0)
		    {
				SetPlayerInterior(i, 6);
				MySetPlayerPos(i, 264.6288, 77.5742, 1001.0391, 270.0);
				format(string, 128, "[AdmWrn]: %s[%d] ��������� ������� �� ������ �����.����������", ReturnPlayerName(i), i);
				SendAdminMessage(COLOR_LIGHTRED, string);
		    }
		    if(JailTime[i] == 55)	ShowDialog(i, DMODE_LAWYER);
		    else if(JailTime[i] <= 0)
		    {
		    	if(Dialogid[i] == DMODE_LAWYER)	MyHidePlayerDialog(i);
		        new wantedlvl = -PlayerInfo[i][pJailTime];
		        GameTextForPlayer(i, "_", 1000, 4);
		        switch(wantedlvl)
		        {
		            case 0:
		            {
				        PlayerInfo[i][pJailTime] = 0;
		                MySetPlayerPos(i, 244.2467, 70.0835, 1003.6406, 180.0);
		                SendClientMessage(i, COLOR_GREEN, "��� ������� ��� ����������, �� ��������");
		                PlayerPlaySound(i, 36201, 0.0, 0.0, 0.0);
		            }
		            case 1..3:
		            {
		                new price = wantedlvl * FINE_PER_WANTED;
		                MySetPlayerPos(i, 244.2467, 70.0835, 1003.6406, 180.0);
		                SendFormatMessage(i, COLOR_DBLUE, string, "��� ������� ��� �������� � ���� � ��� ����� � ������� $%d", price);
				        PlayerInfo[i][pJailTime] = 0;
		                MyGivePlayerMoney(i, -price);
		                if(PlayerInfo[i][pLaw] > (-50))
		                {
		                	if(PlayerInfo[i][pLaw] - wantedlvl < (-50))
						        wantedlvl = 50 - PlayerInfo[i][pLaw];
							PlayerInfo[i][pLaw] -= wantedlvl;
		                	SendFormatMessage(i, COLOR_DBLUE, string, "� ��� ��������� �����������������: %d (-%d)", PlayerInfo[i][pLaw], wantedlvl);
		                }
		                PlayerPlaySound(i, 31202, 0.0, 0.0, 0.0);
		            }
		            case 4..9:
		            {
		                new stmp[512], days = wantedlvl - 3;
				        PlayerInfo[i][pJailTime] = timeUNIX + days * TIME_PER_WANTED * 60;
				        format(stmp, sizeof stmp, "{FFFFFF}��� ������� ��� �������� � �������� {FF6347}%d{FFFFFF} ����� � �������{AA3333}\n\n\n", days * TIME_PER_WANTED);
						//if(PlayerInfo[i][pGunLic])
						//{
						//    PlayerInfo[i][pGunLic] = 0;
						//    format(stmp, sizeof stmp, "%s� � ��� ������ �������� �� ������� ������.\n\n", stmp);
						//}
						if(PlayerInfo[i][pLaw] > (-50))
						{
						    if(PlayerInfo[i][pLaw] - wantedlvl < (-50))
						        wantedlvl = 50 - PlayerInfo[i][pLaw];
							PlayerInfo[i][pLaw] -= wantedlvl;
							format(stmp, sizeof stmp, "%s� � ��� ��������� ����������������� �� -%d, �����: %d\n\n", stmp, wantedlvl, PlayerInfo[i][pLaw]);
						}
						format(stmp, sizeof(stmp), "%s� � ��� ������ ��� ������ � �������.", stmp);
						MyShowPlayerDialog(i, DMODE_NONE, DIALOG_STYLE_MSGBOX, "����������", stmp, "�������");
						for(new w = 0; w < 13; w++)
						{
							gWeaponID[i][w] = 0;
							gWeaponAmmo[i][w] = 0;
						}
						MyResetPlayerWeapons(i);
						PrisonCycle(i, 0); // �������� � �������
		            }
		            default:
		            {
						JailDelivery(i);
						format(string, 128, "[AdmWrn]: ����� %s[%d] ���������� �� ��� ��-�� ������ [wantedlvl: %d]", ReturnPlayerName(i), i, wantedlvl);
						SendAdminMessage(COLOR_LIGHTRED, string);
		            }
		        }
		    }
		    else
		    {
			    format(string, 128, "~r~%d ~w~sec", JailTime[i]);
			    GameTextForPlayer(i, string, 2000, 4);
		    }
		}
		//---
		if(pState == PLAYER_STATE_DRIVER)
		{
			// �������� �������� ����������
			if(burning_timer[i] == 0 && vehicleid == PlayerVehicle[i] && Z > 0.0)
			{
				new Float:vHealth;
				GetVehicleHealth(vehicleid, vHealth);
				if(IsVehicleWithEngine(vehicleid) && vHealth < 250.0)
				{
				    if(GetVehicleEngine(vehicleid)) StartEngine(vehicleid, false);
					GameTextForPlayer(i, "~r~!!!FIRE FIRE FIRE!!!~n~~w~Hold ~y~~k~~VEHICLE_FIREWEAPON~", 1000, 4);
				}
			}

	        if(IsVehicleWithEngine(vehicleid) && Dist < 110.0)
	        {	// ������� ������� ����
	            PlayerInfo[i][pRunCar] += Dist * 0.001;

	        #if defined _player_achieve_included
	            if(PlayerInfo[i][pRunCar] >= 1000.0)
	            {
					GivePlayerAchieve(i, ACHIEVE_CARRIER);	//	���������� '������'
            	}
            #endif

	            CarInfo[vehicleid][cMileage] += Dist * 0.001;
	            if(GetVehicleEngine(vehicleid))
	            {	// ������� ������� �������
		            VehInfo[vehicleid][vFuel] -= CONSUM_FUEL * Dist * 0.001;
		            IFace.Veh_Update(i, 0);
				}
	        }
		}
		// ������ ��������� ��������
	#if defined	_job_job_busdriver_included
		if(BusDriverStatus[i] > 0 && BusDriverLeave[i] > 0)
		{
		    if(--BusDriverLeave[i] <= 0)	Job.ClearPlayerNowWork(i, Job.REASON_TIMEOUT);
		    else
		    {
                format(string, sizeof(string), "��������� � �������! ��������: ~r~%02d:%02d", BusDriverLeave[i]/60, BusDriverLeave[i]%60);
                SendMissionMessage(i, string, 0);
		    }
		}
	#endif
		// ������ �������������
	#if defined	_job_job_trucker_included	
        if(TruckerStatus[i] > 1 && TruckerLeave[i] > 0)
        {
            if(--TruckerLeave[i] <= 0)		Job.ClearPlayerNowWork(i, Job.REASON_TIMEOUT);
            else
            {
                if(TruckerStatus[i] == 2)
                {	// ������� �����
                    format(string, sizeof(string), "�� �������� �����! ��������: ~r~%02d:%02d", TruckerLeave[i]/60, TruckerLeave[i]%60);
                    SendMissionMessage(i, string, 0);
                }
                else if(TruckerStatus[i] == 3)
                {	// ������� ������
                    format(string, sizeof(string), "�� �������� ������! ��������: ~r~%02d:%02d", TruckerLeave[i]/60, TruckerLeave[i]%60);
                    SendMissionMessage(i, string, 0);
                }
            }
        }
    #endif 
		if(MechanicStatus[i] == 1 && MechanicClientid[i] != INVALID_PLAYER_ID)
		{// ���������� ������� �������� � �������
		    new clientid = MechanicClientid[i];
		    DestroyDynamicMapIcon(MechanicMapIcon[i]), 			MechanicMapIcon[i]			=	INVALID_STREAMER_ID;
		    DestroyDynamicMapIcon(MechanicMapIcon[clientid]),	MechanicMapIcon[clientid]	=	INVALID_STREAMER_ID;
		    if(IsPlayerLogged(clientid) == 0)
		    {
		    	MechanicClientid[i] = INVALID_PLAYER_ID;
		    	SendClientMessage(i, COLOR_LIGHTRED, "��� ������ ����� � �������, ����� �������!");
		    	HideMissionMessage(i);
		    }
		    else if(MechanicStatus[i] < 2)
		    {
				if(GetDistanceBetweenPlayers(i, MechanicClientid[i]) > 10.0)
				{
				    new Float:ClientPos[3];
				    GetPlayerPos(clientid, Arr3<ClientPos>);
					MechanicMapIcon[i] = CreateDynamicMapIcon(Arr3<ClientPos>, 55, 0, -1, -1, i, 20000.0, MAPICON_GLOBAL);
					MechanicMapIcon[clientid] = CreateDynamicMapIcon(X, Y, Z, 55, 0, -1, -1, clientid, 20000.0, MAPICON_GLOBAL);
					Streamer_Update(i, STREAMER_TYPE_MAP_ICON);
					Streamer_Update(clientid, STREAMER_TYPE_MAP_ICON);
				}
				else
				{
				    SendMissionMessage(i, "~n~~n~~n~�� ��������� �� �������.");
				    MechanicClientid[i] = INVALID_PLAYER_ID;
					MechanicStatus[i] = 0;
				}
			}
		}
	}
	return true;
}

public	OnEverySecondTimer()
{
	new string[128];
	new hour, minute, second;
	new timeUNIX = gettime(hour, minute, second);
	//new Float:pHealth;

	if (OldMinute != minute)
		EveryMinuteTimer();
	//  ����� �������� � ������
	if (--PrisonStatusTime == 0)
	{
		if(++LastPrisonStatus == 5)	LastPrisonStatus = 1;
		OnPrisonStatusChange(LastPrisonStatus);
	}
	// ����������� ������
	if (Iter_Count(Cop) > 0 && random(8 * 60 / Iter_Count(Cop)) == 0)//&& PoliceMission[sizeof(PoliceMission) - 1][pmNum] == 0)
	{
	    PoliceMissionCreate();
	}
	if((second % 2) == 0)	// �������� �����
	{
	    for(new x; x < sizeof(PoliceMission); x++)
	        if(PoliceMission[x][pmUNIX] <= timeUNIX)
		        PoliceMissionRemove(x);
	}
    // ������� ��������
	if(RestTime > 0)
	{
	    RestTime -= 1;
		IFace.UpdateRestartInfo(RestTime);
		switch(RestTime)
		{
		    case 0: { RestartServer(); }
			case 1..5, 15, 30, 45, 60:
			{
			    // �������
			    if(RestTime == 5) 			foreach(Player, i) { PlayerPlaySound(i, 7416, 0.0, 0.0, 0.0); }
			    else if(1 <= RestTime <= 3) foreach(Player, i) { PlayerPlaySound(i, 7420 - RestTime, 0.0, 0.0, 0.0); }
	        }
	    }
	}
	// ������� ����� � �������
	if(second % 3 == 0 && DrugStore < 1000)
	{
	    DrugStore += 1;
	    format(string, sizeof(string), "����������\n{FFFFFF}%d �����", DrugStore);
	    UpdateDynamic3DTextLabelText(Drug3DText, 0xFFFF00FF, string);
	}

	// �������� ������ ��������������
	#if defined	_job_job_trucker_included
		Trucker_TrailersTimer();
	#endif
	#if defined	_job_job_taxi_included
		Taxi_EverySecondTimer();
	#endif

	//	�������� ��������
	if(MechanicCall != -1 && MechanicCallTime > 0)
	{
		if(--MechanicCallTime <= 0)
		{
		    SendMissionMessage(MechanicCall, "~n~~n~~n~~r~�� ��������� ������, ���������� �����.");
		    MechanicCall = -1; MechanicCallTime = 0;
		}
		else
		{
		    format(string, 128, "~n~~n~~n~�� ������� ��������, ��������: ~y~%d ���", MechanicCallTime);
		    SendMissionMessage(MechanicCall, string, 0);
		}
	}
	//����������
	if(gAdvertTime > 0) gAdvertTime--;
	for(new i = 0; i < MAX_ADVERT_COUNT; i++)
	{
		if(gAdvert[i][adTime] > 0)	gAdvert[i][adTime]--;
		else if(gAdvert[i][adStatus] == 0)
		{
			strdel(gAdvert[i][adSender], 0, 24);
			strdel(gAdvert[i][adText], 0, 100);
			strdel(gAdvert[i][adCheker], 0, 24);
			gAdvert[i][adPhone] = 0;
			gAdvert[i][adBusy] = false;
			gAdvert[i][adStatus] = 0;
			gAdvert[i][adTime] = 0;
			gAdvertCount--;
		}
		else if(gAdvert[i][adStatus] == 2)
		{
			new checkerid;
			SendFormatMessageToAll(COLOR_AD, string, "%s | �����������: %s (���: %d)", gAdvert[i][adText], gAdvert[i][adSender], gAdvert[i][adPhone]);
			if(gAdvert[i][adEdit])	format(string, 128, "  ���������� ��������������:");
			else 					format(string, 128, "  ���������� ��������:");
			if(sscanf(gAdvert[i][adCheker], "r", checkerid))	format(string, 128, "%s %s %s", string, gAdvert[i][adRang], gAdvert[i][adCheker]);
			else 												format(string, 128, "%s %s %s [%d]", string, gAdvert[i][adRang], gAdvert[i][adCheker], checkerid);
			SendClientMessageToAll(COLOR_GREEN, string);
			strdel(gAdvert[i][adSender], 0, 24);
			strdel(gAdvert[i][adText], 0, 100);
			strdel(gAdvert[i][adCheker], 0, 24);
			gAdvert[i][adPhone] = 0;
			gAdvert[i][adBusy] = false;
			gAdvert[i][adStatus] = 0;
			gAdvert[i][adTime] = 0;
			gAdvert[i][adEdit] = false;
			gAdvertCount--;
		}
	}
	//	����������� ���������� ���������
	for(new f = 1; f < sizeof(Faction); f++)
	{
		if(GangRobberyReload[f] > 0 && --GangRobberyReload[f] == 0)
			SendFactionMessage(f, COLOR_GREEN, "[����������]: ���� ����� ������ � ����� �����������!");
	}
	// ��������
	if(BB_Time > 0)
	{
		if(BB_Text == 0 && (second % 20) == 0 && (random(10) % 3) == 0)
		{
			BB_Text = random(10) + 1;
			BB_TextNum = 0;
		}
		else if(BB_Text && (second % 4) == 0)
		{
			new Float:pos[3];
			GetVehiclePos(BB_Car, Arr3<pos>);
	    	switch(BB_Text)
	    	{
	    		case 1:
	    		{
					SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Jessie: ��� ��� ������ ������������, � � �� ��� ���� ����������, ������!");
					BB_Text = 0;
	    		}
	    		case 2:
	    		{
	    			switch(BB_TextNum)
	    			{
	    				case 0:	SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Walter: ������, �� ������ ���������, � �� ��� ��� �����? �� � ����� ���� �� ������?");
	    				case 1:
	    				{
	    					SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Jessie: � ����, ��� ���, ��� ������� ����������, �� ������� ������� � ����.");
	    					BB_Text = 0;
	    				}
	    			}
	    		}
	    		case 3:
	    		{
	    			switch(BB_TextNum)
	    			{
	    				case 0:	SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Jessie: � ���� �����.");
	    				case 1:
	    				{
	    					SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Walter: ������ ���������, ����� ������ � ������� �� �������� ��� ����������� �������.");
	    					BB_Text = 0;
	    				}
	    			}
	    		}
	    		case 4:
	    		{
	    			switch(BB_TextNum)
	    			{
	    				case 0:	SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Walter: ���� ������?");
	    				case 1:	SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Jessie: ��.");
	    				case 2:
	    				{
	    					SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Walter: ��� ��� ������ ����� � ������� �� �����������.");
	    					BB_Text = 0;
	    				}
	    			}
	    		}
	    		case 5:
	    		{
	    			switch(BB_TextNum)
	    			{
	    				case 0:	SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Jessie: �� �����... ��� ����������? ������?");
	    				case 1:	SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Walter: ����� ������.");
	    				case 2:	SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Jessie: ����� ������? ��, ���, �����, � ��������� ���������? ����!");
	    				case 3:	SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Walter: ���� ������ � ��� ��� ��������. � �� �������, ��� ��, ������, ������ ������ ����� �������.");
	    				case 4:
	    				{
	    					SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Jessie: ���������. ����� ����� � ����, ��� ����?");
	    					BB_Text = 0;
	    				}
	    			}
	    		}
	    		case 6:
	    		{
	    			switch(BB_TextNum)
	    			{
	    				case 0:	SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Walter: �� ���������, ��� � ���� ����������� ������� ���������������� �� ��������� � ���� �������?");
	    				case 1:	SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Walter: ���, ��������, ���������� ��������, ��� ���� �������, ������ ����������� ����?");
	    				case 2:	SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Jessie: ����� �� ���?");
	    				case 3:
	    				{
	    					SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Jessie: ������� �� ���. ������ � ������ �����. ����� ���� �������.");
	    					BB_Text = 0;
	    				}
	    			}
	    		}
	    		case 7:
	    		{
	    			SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Jessie: ���� ������� ����. ���� ������� ���. ���������, �� ������� ����-�� ������� ����� ��������� � ��� �� ����!");
	    			BB_Text = 0;
	    		}
	    		case 8:
	    		{
	    			switch(BB_TextNum)
	    			{
	    				case 0:	SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Walter: ���� ������ �������: �� ���� ������ ����.");
	    				case 1:
	    				{
	    					SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Jessie: �� ���� �� ������ ���������� ��� � ���� � �������� ����� �����������?");
	    					BB_Text = 0;
	    				}
	    			}
	    		}
	    		case 9:
	    		{
	    			SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Walter: �� ������� �� �������������� � ��������?!");
	    			BB_Text = 0;
	    		}
	    		case 10:
	    		{
	    			switch(BB_TextNum)
	    			{
	    				case 0:	SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Jessie: ��� ���������� � ������� �������� ����� ����������, �� ����� � �� �����.");
	    				case 1:	SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Walter: ����������?!");
	    				case 2:	SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Jessie: ���. �� ��� ��� �����, ������. �� �����, ������! �� ��, ����, ����� �����?");
	    				case 3:
	    				{
	    					SendRadiusMessageEx(Arr3<pos>, 20.0, 0xC8C8C8C8, "- Walter: ����������. �������, ������");
	    					BB_Text = 0;
	    				}
	    			}
	    		}
	    		default:	BB_Text = 0;
	    	}
	    	BB_TextNum++;
		}
	}

	// ���� �� ��������� (EverySecondTimer())
	foreach(Vehicle, v)
	{
		//	Custom ������� ������
		if(VehInfo[v][vRespawnTime] && --VehInfo[v][vRespawnTime] == 0)
	    {
			MySetVehicleToRespawn(v);
	    }
	    //---	rent
	    if(VehInfo[v][vRentTime] && --VehInfo[v][vRentTime] == 0)
	    {
    		new owner = GetPlayeridToUserID(VehInfo[v][vRentOwner]);
	    	if(owner == INVALID_PLAYER_ID)
	    	{
	    		MySetVehicleToRespawn(v);
	    	}
	    	else
	    	{
	    		TogglePlayerControllable(owner, false);
	    		ShowDialog(owner, DMODE_EXTEND_RENTCAR);
	    	}
	    }
	    //---
	    if(second % 30 == 0)
	    {
	    	if(CarInfo[v][cType] == C_TYPE_JOB && CarInfo[v][cOwnerID] == JOB_MECHANIC)
			{
				UpdateVehicleLabel(v);
			}
	    }
		if((second % 5) == 0)
		{
            // ������� ������� �������
            if(IsVehicleWithEngine(v))
            {
				if(GetVehicleEngine(v))
				{
				    VehInfo[v][vFuel] -= CONSUM_ENGINE * 5;
				    if(VehInfo[v][vFuel] <= 0)
					{
				        VehInfo[v][vFuel] = 0;
						StartEngine(v, false);
				    }
				}
			}
		}
		if(VehInfo[v][vAlarm])	// ������������
		{
		    if(VehInfo[v][vAlarm] > 0)
		    {
				if(--VehInfo[v][vAlarm] == 0)	setVehicleAlarm(v, false);
				else
				{
					VehInfo[v][vAlarmLight] = !VehInfo[v][vAlarmLight];
					UpdateVehicleParamsEx(v);
				}
		    }
		}
		if(VehInfo[v][vTrailerID] != GetVehicleTrailer(v))
		{
		    if(VehInfo[v][vTrailerID] == 0)
			{
				VehInfo[v][vTrailerID] = GetVehicleTrailer(v);
				CallLocalFunction("OnVehicleAttachTrailer", "dd", v, VehInfo[v][vTrailerID]);
			}
		    else
			{
				CallLocalFunction("OnVehicleDetachTrailer", "dd", v, VehInfo[v][vTrailerID]);
				VehInfo[v][vTrailerID] = GetVehicleTrailer(v);
			}
		}
	}

	// ���� �� ������������
	foreach(Spectators, s)
	{
		Interface_SpecPanel_Update(s, SpectateID[s]);
	}
	return true;
}// end of EverySecondTimer

CreateVanWalter()
{
	if(BB_Car)	DestroyVanWalter();
	new pos = random(sizeof(BreakingBad));
	BB_Car = MyCreateVehicle(508, Arr4<BreakingBad[pos]>, 1, 1);
	VehInfo[BB_Car][vLocked] = 999;
	UpdateVehicleParamsEx(BB_Car);
	BB_Object = CreateDynamicObject(18748, Arr3<BreakingBad[pos]>, 0.0, 0.0, 0.0);
	AttachDynamicObjectToVehicle(BB_Object, BB_Car, 0.0, -1.0, 0.5, 0.0, 0.0, 0.0);
	BB_MapIcon = CreateDynamicMapIcon(Arr3<BreakingBad[pos]>, 23, -1, -1, -1, -1, 40.0);
	BB_Time = 5 + random(10);
	//SendAdminMessage(COLOR_ADMIN, "������ ������� � �������.", ADMIN_DEVELOPER);
	return true;
}

DestroyVanWalter()
{
	if(!BB_Car) return false;
	MyDestroyVehicle(BB_Car),			BB_Car = 0;
	DestroyDynamicObject(BB_Object), 	BB_Object = INVALID_STREAMER_ID;
	DestroyDynamicMapIcon(BB_MapIcon), 	BB_MapIcon = INVALID_STREAMER_ID;
	BB_Time = 0, BB_Text = 0;
	//SendAdminMessage(COLOR_ADMIN, "������ ����� �� �������.", ADMIN_DEVELOPER);
	return true;
}

EveryMinuteTimer()
{
	//new string[128],
	new	hour, minute, second,
		timeUNIX = gettime(hour, minute, second);
	OldMinute = minute;
	if(OldHour != hour)
		EveryHourTimer();
	// ���������� ������
    if(minute % 15 == 0)
		UpdateWeather();

	//	�������� ����� �� �������� ������
	if(minute % 2 == 0)
	{
		if(CranePos)	MoveDynamicObject(Crane, 2197.18, -2325.039, 27.53, 0.7);
		else 			MoveDynamicObject(Crane, 2216.68, -2305.539, 27.53, 0.7);
		CranePos = !CranePos;
	}

	//	��������: ������ �� �� ��� ������
	if(BB_Time > 0 && --BB_Time <= 0)		DestroyVanWalter();
	else if(minute % 5 == 0 && random(2))	CreateVanWalter();

    // ������ �����������
    if(hour == 3 && minute == 45)
    {
        RestartServer(30 * 60);
    }

    // ������������� ��������� (��� ������ ��������������)
    #if defined	_job_job_trucker_included
   		Trucker_UpdateTrailers();
   	#endif

    // ���� �� �������
	foreach(LoginPlayer, i)
	{
	    if(++PlayerInfo[i][pGametime] > 60)	PlayerInfo[i][pGametime] = 60;
	    if(Job.GetPlayerContract(i))		Job.SetPlayerContract(i, Job.GetPlayerContract(i) - 1);

	    // ���������� ��������
		if(minute % 5 == 0)	UpdatePlayerStatics(i);
	    UpdatePlayerTime(i);
		// ������������ �� ������
		if(0 < PlayerInfo[i][pJailTime] < timeUNIX
			&& !IsPlayerAFK(i) && !IsPlayerBoxing(i))
		{
			JailDelivery(i);
		}
		if(PlayerInfo[i][pVip])
		{
			if(PlayerInfo[i][pVipUNIX] <= unixtime())
			{
				PlayerInfo[i][pVip] = 0;
				PlayerInfo[i][pVipUNIX] = 0;
				SendClientMessage(i, COLOR_LIGHTGREEN, "��� ������� ������� ����������, ��� ��������� ����������� ����.");
			}
		}
		// ������� ������ �������
		if(WantedTime[i] > 0)
		{
		    if(PursuitStatus[i] > PS_NONE)	WantedTime[i] = 20;
		    else if(--WantedTime[i] == 0 && GetPlayerWantedLevel(i) > 0)
		    {
		    	new bool:found;
		    	foreach(Cop, copid)
				{
					if(IsPlayerStreamedIn(copid, i))
					{
						found = true;
					}
				}
				if(!found)
				{
					ToggleCriminalDanger(i, false);
				    MySetPlayerWantedLevel(i, GetPlayerWantedLevel(i) - 1);
				    ShowPlayerHint(i, "������� �������� � ���~n~������ ��� �������");
				}
		    }
		}
	}

	// ���� �� �������
	if(minute + 1 % 5 == 0)
	{
		foreach(Vehicle, v)
		{
		    if(CarInfo[v][cID] > 0)
		    {
		    	UpdateVehicleStatics(v);
		    }
		}
	}

	// �������� �������������� ���������
	if(minute % 10 == 0)
	{
	    for(new rand, i; i < 10; i++)
	    {
	        rand = random(sizeof(InfoText));
	        if(rand == lastinfotext)	continue;
	        foreach(LoginPlayer, p)		ShowPlayerHint(p, InfoText[rand], 15000);
			//SendFormatMessageToAll(COLOR_WHITE, string, PREFIX_HINT "%s", InfoText[rand]);
			lastinfotext = rand;
			break;
		}
	}

	// ���� ������
#if defined _player_chat_game_included
	if ((minute - 1) % 20 == 0)
		StartRandomChatGame();
#endif
	return true;
}

EveryHourTimer() // PayDay()
{
	new string[128];
	static Float:oldbank, Float:proc, Float:tax, Float:wage, Float:benefit, exp, Float:salary;
	foreach(LoginPlayer, i)
	{
	    proc = 0.0; tax = 0.0; wage = 0.0; benefit = 0.0; exp = 0, salary = 0.0;

	    //	������ � ���������� ������
	    if(IsGang(PlayerInfo[i][pFaction]))
	    {
			new gangzones = getGangZoneCount(PlayerInfo[i][pFaction]);
	        GiveFactionMoney(PlayerInfo[i][pFaction], floatround(gangzones * GANGZONE_PROFIT * 0.1));
	        GivePlayerCrimeWage(i, gangzones * GANGZONE_PROFIT * 0.9);
	    }

		// ���������� �������
	    oldbank = PlayerInfo[i][pBank];
	    if(oldbank > 0)
		{
			proc = oldbank / 1000;
			if(PlayerInfo[i][pVip]) proc *= 2;
			GivePlayerBank(i, proc);
		}

	    SendClientMessage(i, COLOR_WHITE, "");
	    SendClientMessage(i, COLOR_WHITE, "");
	    SendClientMessage(i, COLOR_WHITE, "");
		SendClientMessage(i, COLOR_GREEN, "|___ ��������� �� ����� ___|");

		if(PlayerInfo[i][pFaction] > 0 && PlayerInfo[i][pRank] > 0)
		{
			if(FactionSalary[ PlayerInfo[i][pFaction] ][ PlayerInfo[i][pRank] - 1 ] > 0)
			{
				salary = float(FactionSalary[ PlayerInfo[i][pFaction] ][ PlayerInfo[i][pRank] - 1 ]) * ((PlayerInfo[i][pVip]) ? 1.25 : 1.0);
				if(PlayerInfo[i][pVip])	SendFormatMessage(i, COLOR_WHITE, string, "  ������: $%.2f {33AA33}(x1.25){FFFFFF}", salary);
				else 					SendFormatMessage(i, COLOR_WHITE, string, "  ������: $%.2f", salary);
			}
		}
		if(Job.GetPlayerWage(i))
		{
			wage += Job.GetPlayerWage(i) * ((PlayerInfo[i][pVip]) ? 1.25 : 1.0);
	   		tax += (salary + wage) / 10;	// �����
	   		if(PlayerInfo[i][pVip])	SendFormatMessage(i, COLOR_WHITE, string, "  ��������: $%.2f {33AA33}(x1.25){FFFFFF}   �����: {FF6347}$%.2f", wage, tax);
			else 					SendFormatMessage(i, COLOR_WHITE, string, "  ��������: $%.2f   �����: {FF6347}$%.2f", wage, tax);
		}
		if(PlayerInfo[i][pFaction] == F_NONE && Job.GetPlayerJob(i) == JOB_NONE)
		{
			benefit += BENEFIT * ((PlayerInfo[i][pVip]) ? 1.25 : 1.0);
			if(PlayerInfo[i][pVip])	SendFormatMessage(i, COLOR_WHITE, string, "  ������� �� �����������: $%.2f {33AA33}(x1.25)", benefit);
			else 					SendFormatMessage(i, COLOR_WHITE, string, "  ������� �� �����������: $%.2f", benefit);
		}
		//---
		SendFormatMessage(i, COLOR_GRAD2, string, "  ����������:     $%.2f (0.1%s)", proc, "%%");
	    //---	������ ��������
	    if(wage > 10000.0 || wage < 0.0)
	    {
	    	//	������������
	    	wage = 0.0;
	    	format(string, sizeof(string), "[AdmWrn]: %s[%d] ������ � �������� $%.2f [������: %d | �������: %d]", ReturnPlayerName(i), i, wage, Job.GetPlayerJob(i), PlayerInfo[i][pFaction]);
			SendAdminMessage(COLOR_LIGHTRED, string);
			printf("ERROR #113: Player %s got wage $%.2f [job: %d | faction: %d]", ReturnPlayerName(i), wage, Job.GetPlayerJob(i), PlayerInfo[i][pFaction]);
	    }
	    else
	    {
	    	GivePlayerBank(i, wage + benefit - tax);
	    }
		//---
		SendFormatMessage(i, COLOR_WHITE, string, "  ����� ������: $%.2f %s($%.2f)", PlayerInfo[i][pBank], ((PlayerInfo[i][pBank] > oldbank) ? ("{33AA33}") : ("{FF6347}")), PlayerInfo[i][pBank] - oldbank);
		
		// ��������� �����������������
		if(GetPlayerWantedLevel(i) == 0)
		{
			PlayerInfo[i][pLaw]++;
			if(PlayerInfo[i][pLaw] > 50) 			PlayerInfo[i][pLaw] = 50;
			else if(PlayerInfo[i][pLaw] < -50) 		PlayerInfo[i][pLaw] = -50;
			else
			{
				SendFormatMessage(i, COLOR_WHITE, string, "  �����������������: +1 (%d)\n", PlayerInfo[i][pLaw]);
			}
		}

		SendClientMessage(i, COLOR_GREEN, "|-----------------------------------------------|");

	#if defined _player_achieve_included
		if(Job.GetPlayerWage(i) > 0)
		{
			GivePlayerAchieve(i, ACHIEVE_PAYDAY);	//	���������� '��������� ������'
		}
	#endif
		
		// ����� �������������� � �������
		if(PlayerInfo[i][pCopWarn] > 100)	PlayerInfo[i][pCopWarn] -= 100;
		else 								PlayerInfo[i][pCopWarn] = 0;

		// ������ �����
		exp = floatround(((PlayerInfo[i][pVip] ? 150 : 100) / 100) * (PlayerInfo[i][pGametime] / (60.0 / 100.0)));
		GivePlayerEXP(i, exp);
	
	    Job.SetPlayerWage(i, 0.0);	// ��������� ��������
		PlayerInfo[i][pGametime] = 0;
		PlayerInfo[i][pTraining] = 0;

		PlayerPlaySound(i, 6400, 0.0, 0.0, 0.0);
		GameTextForPlayer(i, "~y~PayDay~n~~w~Paycheck", 5000, 1);
	}

	//---------	�������� ������� � ������������, ��������, ������ ------------
	new message[128];
	//	�������� ���� ���������� �������� ������
	mysql_format(g_SQL, string, sizeof(string), "SELECT payment_day FROM %s.servers WHERE id = '%d'", MAIN_DB, SERVER_ID);
	new Cache:result = mysql_query(g_SQL, string);
	new payment_day;
	cache_get_value_name_int(0, "payment_day", payment_day);
	cache_delete(result);

	new cur_day = gettime(OldHour, _, _) / 86400;	//	���������� ����� ��� ��� ���������
	if(payment_day < cur_day)	//	��������� ��������
	{
	//	�������� ���� ������
		//	��������� ��� ��� ������
		foreach(LoginPlayer, i)
		{
			if(PlayerInfo[i][pRent])
			{
				PlayerInfo[i][pPaymentDays]--;
				//	���� ���������� �����, � �� �����
				if(PlayerInfo[i][pRent] > 0)
				{
					new h = FoundHouse(PlayerInfo[i][pRent]);
					if(h >= 0)
					{

						new owner = GetPlayeridToUserID(HouseInfo[h][hOwnerID]);
						if(owner == INVALID_PLAYER_ID)
						{
							//	��������� ������ ����� ����
							mysql_format(g_SQL, string, sizeof(string), "UPDATE `players` SET `bank` = `bank` + '%d' WHERE `id` = '%d'", HouseInfo[h][hRentPrice], HouseInfo[h][hOwnerID]);
							mysql_query_ex(string);
						}
						else
						{
							//	���� � ����, ��������� � ���� � ����
							GivePlayerBank(owner, HouseInfo[h][hRentPrice]);
						}
					}
				}
				if(PlayerInfo[i][pPaymentDays] <= 0)
				{
					PlayerInfo[i][pRent] = 0;
					PlayerInfo[i][pPaymentDays] = 0;
					format(message, sizeof(message), "[������]: �� ���� �������� �� ����������� ����� �� ��������");
					SendClientMessage(i, COLOR_LIGHTRED, message);
				}
				else if(PlayerInfo[i][pPaymentDays] <= 3)
				{
					format(message, sizeof(message), "[������]: � ��� �������� %d ������������� ���� ������ �����", PlayerInfo[i][pPaymentDays]);
					SendClientMessage(i, COLOR_LIGHTRED, message);
				}
			}
		}

		//	��������� ��� ��� ������
		mysql_tquery(g_SQL, "SELECT `id`, `rent`, `payment_days` FROM `players` WHERE `rent` <> 0 AND `online` = -1", "PaymentPlayers", "");

		new owner, i;
	//	��������� ��� ������ �����
		for(new h = 0; h < MaxHouses; h++)
		{
			if(HouseInfo[h][hOwnerID] > 0)
			{
				HouseInfo[h][hPaymentDays]--;
				owner = HouseInfo[h][hOwnerID];
				i = GetPlayeridToUserID(owner);

				if(HouseInfo[h][hPaymentDays] < (-3))
				{
					//	���� ���� ������ 3 ����, �������
					format(message, sizeof(message), "[����]: ��� ��� ��� ������ ����������� �� �����");
					SellHouse(h, false);
				}
				else if(HouseInfo[h][hPaymentDays] <= 0)
				{
					format(message, sizeof(message), "[����]: �������� ��� ���, ����� �� ����� ������ �� �����");
					SaveHouse(h);
				}
				else
				{
					SaveHouse(h);
					continue;
				}
				if(i == INVALID_PLAYER_ID)	SendOfflineMessage(owner, message);
				else 						SendClientMessage(i, COLOR_LIGHTRED, message);
			}
		}

	//	��������� ��� ������ ��������
		for(new b = 0; b < MaxBiz; b++)
		{
			if(BizInfo[b][bOwnerID] > 0)
			{
				BizInfo[b][bPaymentDays]--;
				owner = BizInfo[b][bOwnerID];
				i = GetPlayeridToUserID(owner);

				if(BizInfo[b][bPaymentDays] < (-3))
				{
					//	���� ���� ������ 3 ����, �������
					format(message, sizeof(message), "[����]: ��� ������ ��� ������ ����������� �� �����");
					SellBiz(b, false);
				}
				else if(BizInfo[b][bPaymentDays] <= 0)
				{
					format(message, sizeof(message), "[����]: �������� ��� ������, ����� �� ����� ������ �� �����");
					SaveBiz(b);
				}
				else
				{
					SaveBiz(b);
					continue;
				}
				if(i == INVALID_PLAYER_ID)
					SendOfflineMessage(BizInfo[b][bOwnerID], message);
				else
					SendClientMessage(i, COLOR_LIGHTRED, message);
			}
		}

	//	��������� ���� ��������
		mysql_format(g_SQL, string, sizeof(string), "UPDATE %s.servers SET payment_day = '%d' WHERE id = '%d'", MAIN_DB, cur_day, SERVER_ID);
		mysql_query_ex(string);
	}

	/////////	Analytics of Online 	//////////
	format(string, sizeof(string), "INSERT INTO `analytics_online` SET `players` = '%d', `time` = UNIX_TIMESTAMP()", Iter_Count(LoginPlayer));
	mysql_query_ex(string);
	//////////////////////////////////////////////

	ReloadEmmetStore(); // ���������� ������� � ������
	//	���������� �����
	if(GetSVarInt("Race:AutoStart:Timer"))	KillTimer(GetSVarInt("Race:AutoStart:Timer"));
	SetSVarInt("Race:AutoStart:Timer", SetTimer("AutoStartRace", (15 * 60 * 1000), false));
	return true;
}

Public: PaymentPlayers()
{
	new string[128], message[128];
	new id, rent, days;
	for(new i = 0; i < cache_num_rows(); i++)
	{
		cache_get_value_index_int(i, 0, id);
		cache_get_value_index_int(i, 1, rent);
		cache_get_value_index_int(i, 2, days);

		days--;

		//	���� ���������� �����, � �� �����
		if(rent > 0)
		{
			new h = FoundHouse(rent);
			if(h >= 0)
			{
				new owner = GetPlayeridToUserID(HouseInfo[h][hOwnerID]);	
				if(owner == INVALID_PLAYER_ID)
				{
					//	��������� ������ ����� ����
					mysql_format(g_SQL, string, sizeof(string), "UPDATE `players` SET `bank` = `bank` + '%d' WHERE `id` = '%d'", HouseInfo[h][hRentPrice], HouseInfo[h][hOwnerID]);
					mysql_query_ex(string);
				}
				else
				{
					//	���� � ����, ��������� � ���� � ����
					GivePlayerBank(owner, HouseInfo[h][hRentPrice]);
				}
			}
		}

		if(days <= 0)
		{
			format(message, sizeof(message), "[������]: �� ���� �������� �� ����������� ����� �� ��������");
			mysql_format(g_SQL, string, sizeof(string), "UPDATE `players` SET `rent` = 0, `payment_days` = 0 WHERE `id` = '%d'", id);
		}
		else if(days <= 3)
		{
			format(message, sizeof(message), "[������]: � ��� �������� %d ������������� ���� ������ �����", days);
			mysql_format(g_SQL, string, sizeof(string), "UPDATE `players` SET `payment_days` = '%d' WHERE `id` = '%d'", days, id);
		}
		mysql_query_ex(string);
		if(strlen(message))	SendOfflineMessage(id, message);
	}
	return true;
}

// source(0 - disconnect, 1 - connect)
ZeroVars(playerid, source = 0)
{	
	new nowtick = GetTickCount();

	//	It's vars will be zeroing only when player disconnects
	if(source == 0)
	{
		//	Timers
		if(LoginCameraTimer[playerid])	
		{
			KillTimer(LoginCameraTimer[playerid]);
			LoginCameraTimer[playerid] = 0;
		}

		//	Iterators
		Iter_Remove(LoginPlayer, playerid);
		Iter_Remove(Prisoners, playerid);
		Iter_Remove(Cop, playerid);
		Iter_Remove(Racer, playerid);
		Iter_Remove(Spectators, playerid);

		//////////		Vars		//////////
		gPlayerRegged[playerid] 		= REG_STATE_UNDEFINED;
		gPlayerShowLoginCam[playerid] 	= false;
		gPlayerLogged[playerid] 		= false;
		gPlayerDisconnecting[playerid] 	= false;
		gPlayerDeath[playerid]			= false;
		gLoggedTime[playerid] 			= 0;
		gPlayerLogTries{playerid} 		= 0;
		gInModShop[playerid] 			= 0;
		gLastVehicle[playerid] 			= 0;
		gEnteringVehicle[playerid] 		= 0;
		gLeavingGang[playerid] 			= false;
		gPickupTime[playerid] 			= 0;
		gMapIcon_CP[playerid] 			= 0;
		////////////////////////////////////////
		openWithInv[playerid]	 		= false;
		openWithATM[playerid] 			= false;
		openWithMenu[playerid] 			= false;
		////////////////////////////////////////
		playerDrink{playerid} 			= 0;
		playerDrinkCount{playerid} 		= 0;
		PlayerDrunkTime{playerid} 		= 0;
		playerSmokeCount{playerid} 		= 0;
	    ////////////////////////////////////////
		mission_id[playerid] 			= 0;
		mission_pobject[playerid] 		= 0;
		mission_veh[playerid] 			= 0;
		mission_timer[playerid] 		= 0;
		mission_count[playerid] 		= 0;
		////////////////////////////////////////
		PM_Type[playerid] 				= 0;
		PursuitReinforcReload[playerid] = 0;
		PursuitReinforc[playerid] 		= 0;
		PursuitStatus[playerid] 		= PS_NONE;
		PursuitTickcount[playerid] 		= 0;
		PursuitLamp[playerid] 			= false;
		PursuitCrimTransit[playerid] 	= false;
		PursuitAllowArrest[playerid] 	= false;
		PursuitIllegalItem[playerid] 	= false;
		PursuitLastUNIX[playerid] 		= 0;
		pursuit_timer[playerid] 		= 0;
		PursuitArest[playerid] 			= 0;
		PursuitCancelHandsup[playerid] 	= 0;
		CriminalMarkers[playerid] 		= 0;
		criminal_timer[playerid] 		= 0;
		////////////////////////////////////////
		redit_id[playerid] 				= 0;
		PlayerFoodHands[playerid] 		= 0;
		gWeaponStatus{playerid} 		= false;
		////////////////////////////////////////
		Mark[playerid][0] 				= 0.0;
		Mark[playerid][1] 				= 0.0;
		Mark[playerid][2] 				= 0.0;
		Mark[playerid][3] 				= 0.0;
		MarkINT[playerid] 				= 0;
		MarkVW[playerid] 				= 0;
		////////////////////////////////////////
		HouseNum[playerid]				= 0;
		HouseZone[playerid] 			= 0;
		HouseClass[playerid] 			= 0;
		////////////////////////////////////////
		GangWarKills[playerid] 			= 0;
		GangWarDeath[playerid] 			= 0;
		GangZoneLeaving[playerid] 		= 0;
		////////////////////////////////////////
		MechanicStatus[playerid] 		= 0;
		////////////////////////////////////////
		robbery_money[playerid] 		= 0;
		robbery_timer[playerid] 		= 0;
		////////////////////////////////////////
		InMask[playerid] 				= false;
		OldSpeed[playerid] 				= 0;
		AdminDuty[playerid] 			= false;
		RegBizIdx[playerid] 			= 0;
		graffiti_timer[playerid]	 	= 0;
		burning_timer[playerid] 		= 0;
		MembersPage[playerid] 			= 0;
		MembersNum[playerid] 			= 0;
		PlayerVehicle[playerid] 		= 0;
		pAdverReload[playerid] 			= 0;
		j_jobstep{playerid} 			= 0;
		engine_timer[playerid] 			= 0;
		showDebug[playerid] 			= false;
		FW_Missile[playerid] 			= 0;
		CarryTimer[playerid] 			= 0;
		MissionInfoTimer[playerid] 		= 0;
		p_PrisonTimer{playerid} 		= false;
		DialogTimeleft[playerid] 		= 0;
		JailTime[playerid] 				= 0;
		PlayerBusy{playerid} 			= false;
		weaponid_new[playerid] 			= 0;
		gExpTime[playerid] 				= 0;
	    gExpCount[playerid] 			= 0;
	    WantedTime[playerid] 			= 0;
	    gBlockAction[playerid] 			= BLOCK_NONE;

		strdel(jail_numer[playerid], 0, sizeof(jail_numer[]));

		//////////	Enumerations	//////////
			//	Player info
    	for(new E_PLAYER:e; e < E_PLAYER; e++)
		    PlayerInfo[playerid][e] = 0;
	
			//	Mission info
		for(new i; i < MISSION_SOURCE; i++)
		    gMissionProgress[playerid][i] = 0;
		
			//	Spawn info
		for(new E_SPAWN:e; e < E_SPAWN; e++)
			g_SpawnInfo[playerid][e] = 0;

		//////////		Modules		//////////
		#if defined _player_achieve_included
			Achieve_ZeroVars(playerid);
		#endif
	}

	#if defined _ac_core_included
  		AC_ClearVars(playerid);
	#endif

	#if defined _inventory_weapon_included
		Inv.ClearWeaponData(playerid);
	#endif

	#if defined _interface_hint_included
		Hint_ZeroVars(playerid);
	#endif

	#if defined _player_phone_included
		Phone_ZeroVars(playerid);
    #endif

	#if defined _player_ask_included
		StopAsking(playerid);
	#endif

	FirstSpawn[playerid] 			= true;
	pNameTags[playerid] 			= true;
	gPickupID[playerid] 			= -1;
	PickupedHouse[playerid] 		= -1;
	InGangZone[playerid] 			= -1;
	robbery_biz[playerid] 			= -1;
	robbery_offerid[playerid] 		= -1;
	gTickPushed[playerid] 			= nowtick;
	gTickEngine[playerid] 			= nowtick;
	StartupAntiflood[playerid] 		= nowtick;
	SpectateID[playerid] 			= INVALID_PLAYER_ID;
	gTargetid[playerid] 			= INVALID_PLAYER_ID;
	PursuitArestPlayer[playerid]	= INVALID_PLAYER_ID;
	MechanicClientid[playerid] 		= INVALID_PLAYER_ID;
	//////////		GPS 	////////////////
	gps_Data[playerid][GPS_CP] 		= INVALID_STREAMER_ID;
	gps_Data[playerid][GPS_MAP] 	= INVALID_STREAMER_ID;
	gps_Data[playerid][GPS_OBJ] 	= INVALID_STREAMER_ID;
	////////////////////////////////////////
	TestObject[playerid] 			= INVALID_STREAMER_ID;
	GotoObject[playerid] 			= INVALID_STREAMER_ID;
	gCheckpoint[playerid] 			= INVALID_STREAMER_ID;
	PickupedBiz[playerid] 			= INVALID_DATA;
	Dialogid[playerid] 				= INVALID_DIALOGID;

	//	Clear Game Functions
	for(new i = 0; i < 11; i++)
		SetPlayerSkillLevel(playerid, i, 500);
	for(new i = 0; i < 10; i++)
		RemovePlayerAttachedObject(playerid, i);
	return true;
}
// End ZeroVars()

Public: OnPlayerLogged(playerid)
{
	new string[256];

	#if defined _player_achieve_included
		Achieve_LoadPlayer(playerid);
	#endif

	// ������ ���� �� ����� ��� ��������� �������
	new faction = PlayerInfo[playerid][pFaction];
	if(IsGang(faction) || IsMafia(faction))	SetPlayerTeam(playerid, faction);
	else if(faction == F_POLICE)			SetPlayerTeam(playerid, faction);
	else 									SetPlayerTeam(playerid, NO_TEAM);

	//
	Iter_Add(LoginPlayer, playerid);
	UpdatePlayerData(playerid, "online", playerid);

	//Check
	new h = FoundHouse(PlayerInfo[playerid][pHousing]);
	if(h >= 0 && HouseInfo[h][hOwnerID] != PlayerInfo[playerid][pUserID])
	{
		PlayerInfo[playerid][pHousing] = 0;
	}
	//---
	gPlayerLogTries{playerid} = 0;
	gPlayerLogged[playerid] = true;
	gWeaponStatus{playerid} = true;
	if(AUTOADMIN && PlayerInfo[playerid][pAdmin] > 0) AdminDuty[playerid] = true;
	if(PlayerInfo[playerid][pBanUNIX] > 0) PlayerInfo[playerid][pBanUNIX] = 0;
	//	����� ���������� ����
	foreach(Vehicle, v)
	{
		if(VehInfo[v][vRentOwner] == PlayerInfo[playerid][pUserID])
		{
			SetPVarInt(playerid, "RentCar", v);
		}
	}
	//	in game params
	CallLocalFunction("OnPlayerTextDrawInit", "d", playerid);

	EnablePlayerCameraTarget(playerid, true);
	UpdatePlayerColor(playerid);
	SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
	UpdatePlayerGraffitiCP(playerid); 	//  toggle graffiti
	UpdateGangZone(-1, playerid);		//	toggle gang zones
	ToggleHouseIcons(playerid, PlayerInfo[playerid][pHouseIcon]);
	UpdatePlayerHouseMapIcon(playerid);
	Job.UpdatePlayerMapIcon(playerid);
	GangZoneShowForPlayer(playerid, JailGZ, 0x8B4513BB);
	SetPlayerFightingStyle(playerid, FightStyles[ PlayerInfo[playerid][pFightStyle] ]);
	SetPlayerWalkingStyle(playerid, PlayerInfo[playerid][pWalk]);
	// ������ ��� ��� ���, � ���� ��� ������ � ����������
	foreach(LoginPlayer, i)
	{
		if(!pNameTags[i])	ShowPlayerNameTagForPlayer(i, playerid, false);
	}

	new enterObject = CreatePlayerObject(playerid, 2912, 0.0, 0.0, -100.0, 0, 0, 0);
	SetPlayerObjectMaterial(playerid, enterObject, 0, 18646, "MatColours", "green", 0x10FFFFFF);
	SetPlayerObjectMaterial(playerid, enterObject, 1, 18646, "MatColours", "green", 0x10FFFFFF);
	SetPVarInt(playerid, "System:Player:EnterObject", enterObject);
		
	//	�������� ����������� ��������
	CallRemoteFunction("RemoveStaticObjects", "d", playerid);

	// ���������
	SendFormatMessageToAll(COLOR_GRAD6, string, "[Connect]: %s �������������� �� ������ ", ReturnPlayerName(playerid));
	format(string, sizeof(string), "%s (ip: %s, money: $%d, bank: $%.2f)", string, ReturnPlayerIP(playerid), MyGetPlayerMoney(playerid), PlayerInfo[playerid][pBank]);
	Admin_Log(string);

	//	Players Online Recorder
	new players = Iter_Count(LoginPlayer);
	if(CurrentPlayerRecords < players)
	{
		new date[3];
		getdate(Arr3<date>);
		CurrentPlayerRecords = players;
		SendFormatMessageToAll(COLOR_ORANGE, string, "[NEWS]: ������ ��� ��� ������������ ����� ������ �������: %d �����(��) (%02d/%02d/%04d)", CurrentPlayerRecords, date[2], date[1], date[0]);
		mysql_format(g_SQL, string, sizeof(string), "UPDATE %s.`servers` SET `record_online` = '%d', `date_record` = UNIX_TIMESTAMP() WHERE `id` = '%d'", MAIN_DB, CurrentPlayerRecords, SERVER_ID);
		mysql_query_ex(string);
	}

	PreloadAnimLibs(playerid);
	SetPlayerSpawn(playerid);
	UpdatePlayerSkin(playerid);
	MySpawnPlayer(playerid);
	return true;
}

//	Callbacks: Players
public OnPlayerConnect(playerid)
{
	if(IsPlayerNPC(playerid))	return true;
	if(GameModeStatus == false)
	{
		SendClientMessage(playerid, COLOR_SERVER, "Sorry, gamemode is not loaded yet. Reconnect 5 second...");
		SetTimerEx("OnPlayerConnect", 5000, false, "d", playerid);
		return true;
	}

	new string[256], same_ips;
	for(new i = 0; i < GetPlayerPoolSize(); i ++)
	{
		if(playerid == i) continue;
		if(strcheck(ReturnPlayerIP(i), ReturnPlayerIP(playerid)))
		{
			format(string, sizeof(string), "IP ������ %s[%d] ��������� IP ������ %s[%d] [IP: %s]", ReturnPlayerName(playerid), playerid, ReturnPlayerName(i), i, ReturnPlayerIP(playerid));
			SendAdminMessage(COLOR_LIGHTRED, string);
			same_ips++;
		}
	}
	if(same_ips >= 5)
	{
  		printf("������������� �����! IP: %s", ReturnPlayerIP(playerid));
  		format(string, sizeof(string), "������ ��� ���� ������ ����� ������! [IP: %s]", ReturnPlayerIP(playerid));
  		SendAdminMessage(COLOR_LIGHTRED, string);
  		Kick(playerid);
  		format(string, sizeof(string), "banip %s", ReturnPlayerIP(playerid));
  		SendRconCommand(string);
	}

	mysql_format(g_SQL, string, sizeof(string), "SELECT `id`, `exitunix`, `banunix` FROM `players` WHERE `username` = '%s'", ReturnPlayerName(playerid));
	mysql_pquery(g_SQL, string, "OnPlayerGetRegister", "d", playerid);

	SendClientMessage(playerid, COLOR_SERVER, "Gamemode data loading...");
	PreloadAnimLib(playerid, "MISC");			//	����� ����������� ������ ������
	PreloadAnimLib(playerid, "COP_AMBIENT");	//	����� ����������� ������ � ��� ������

	#if defined _interface_core_included
		Callback: IFace.OnPlayerConnect(playerid);
	#endif

	//	Set settings
	new hour, minute;
	gettime(hour, minute, _);
	SetPlayerTime(playerid, hour, minute);
	ClearChatbox(playerid, 20);
	SetPlayerColor(playerid, 0xAFAFAFFF);
	ZeroVars(playerid, true);

	//---	Set MySQL ORM
    new ORM:ormid = PlayerInfo[playerid][ORM_ID] = orm_create("players", g_SQL);
	orm_addvar_int(ormid, PlayerInfo[playerid][pUserID], "id");
	orm_setkey(PlayerInfo[playerid][ORM_ID], "id");

	orm_addvar_int(ormid, PlayerInfo[playerid][pLevel], "level");
	orm_addvar_int(ormid, PlayerInfo[playerid][pExp], "exp");
	orm_addvar_int(ormid, PlayerInfo[playerid][pVip], "vip");
	orm_addvar_int(ormid, PlayerInfo[playerid][pVipUNIX], "vipunix");
	// `online`
	orm_addvar_int(ormid, PlayerInfo[playerid][pSex], "sex");
	orm_addvar_int(ormid, PlayerInfo[playerid][pSkin], "skin");
	orm_addvar_int(ormid, PlayerInfo[playerid][pMoney], "money");
	orm_addvar_int(ormid, PlayerInfo[playerid][pWantedLvl], "wantedlvl");
	orm_addvar_int(ormid, CriminalDanger[playerid], "danger");
	// `teamunix`
	orm_addvar_int(ormid, PlayerInfo[playerid][pLeader], "leader");
	orm_addvar_int(ormid, PlayerInfo[playerid][pFaction], "faction");
	orm_addvar_int(ormid, PlayerInfo[playerid][pRank], "rank");
	orm_addvar_int(ormid, PlayerInfo[playerid][pCopWarn], "copwarn");
	orm_addvar_int(ormid, PlayerInfo[playerid][pCopCases], "copcases");
	orm_addvar_int(ormid, PlayerInfo[playerid][pSpawn], "spawn");
	orm_addvar_float(ormid, PlayerInfo[playerid][pPosX], "posx");
	orm_addvar_float(ormid, PlayerInfo[playerid][pPosY], "posy");
	orm_addvar_float(ormid, PlayerInfo[playerid][pPosZ], "posz");
	orm_addvar_float(ormid, PlayerInfo[playerid][pPosA], "posa");
	orm_addvar_int(ormid, PlayerInfo[playerid][pPosINT], "posint");
	orm_addvar_int(ormid, PlayerInfo[playerid][pPosVW], "posvw");
	// `regdate`
	orm_addvar_int(ormid, PlayerInfo[playerid][pExitUNIX], "exitunix");
	orm_addvar_int(ormid, PlayerInfo[playerid][pJailTime], "jailtime");
	orm_addvar_int(ormid, PlayerInfo[playerid][pWarns], "warns");
	orm_addvar_int(ormid, PlayerInfo[playerid][pWarnUNIX], "warnunix");
	orm_addvar_int(ormid, PlayerInfo[playerid][pMuteTime], "mutetime");
	orm_addvar_int(ormid, PlayerInfo[playerid][pAskMute], "askmute");
	orm_addvar_int(ormid, PlayerInfo[playerid][pAdmin], "admin");
	orm_addvar_int(ormid, PlayerInfo[playerid][pBanUNIX], "banunix");
	orm_addvar_int(ormid, PlayerInfo[playerid][pHousing], "house");
	orm_addvar_int(ormid, PlayerInfo[playerid][pRent], "rent");
	orm_addvar_int(ormid, PlayerInfo[playerid][pPaymentDays], "payment_days");
	orm_addvar_int(ormid, PlayerInfo[playerid][pCensored], "censored");
	orm_addvar_int(ormid, PlayerInfo[playerid][pLaw], "law");
	orm_addvar_float(ormid, PlayerInfo[playerid][pBank], "bank");
	orm_addvar_float(ormid, PlayerInfo[playerid][pCrimeWage], "crime_wage");
	orm_addvar_int(ormid, PlayerInfo[playerid][pUpgrade], "upgrade");
	orm_addvar_float(ormid, PlayerInfo[playerid][pRunCar], "runcar");
	orm_addvar_float(ormid, PlayerInfo[playerid][pSaveHealth], "health");
	orm_addvar_float(ormid, PlayerInfo[playerid][pSaveArmour], "armour");
	orm_addvar_int(ormid, PlayerInfo[playerid][pHunger], "hunger");
	orm_addvar_int(ormid, PlayerInfo[playerid][pPhoneNumber], "p_number");
	orm_addvar_float(ormid, PlayerInfo[playerid][pPhoneBalance], "p_balance");
	orm_addvar_int(ormid, PlayerInfo[playerid][pPhoneEnable], "p_enable");
	orm_addvar_int(ormid, PlayerInfo[playerid][pCarLic], "carlic");
	orm_addvar_int(ormid, PlayerInfo[playerid][pGunLic], "gunlic");
	//orm_addvar_int(ormid, PlayerInfo[playerid][pGunDealLic], "gundeal_lic");
	//orm_addvar_int(ormid, PlayerInfo[playerid][pTheftLic], "theft_lic");
	orm_addvar_int(ormid, PlayerInfo[playerid][pTheftTime], "theft_time");
	//orm_addvar_int(ormid, PlayerInfo[playerid][pDrugDealLic], "drugdeal_lic");
	orm_addvar_int(ormid, PlayerInfo[playerid][pTaxiLevel], "taxi_level");
	orm_addvar_int(ormid, PlayerInfo[playerid][pTaxiSkill], "taxi_skill");
	orm_addvar_int(ormid, PlayerInfo[playerid][pBusLevel], "bus_level");
	orm_addvar_int(ormid, PlayerInfo[playerid][pBusSkill], "bus_skill");
	orm_addvar_int(ormid, PlayerInfo[playerid][pTruckLevel], "truck_level");
	orm_addvar_int(ormid, PlayerInfo[playerid][pTruckSkill], "truck_skill");
	orm_addvar_int(ormid, PlayerInfo[playerid][pNewsUnix], "news_unix");
	orm_addvar_int(ormid, PlayerInfo[playerid][pNewsCount], "news_count");
	orm_addvar_int(ormid, PlayerInfo[playerid][pKills], "kills");
	orm_addvar_int(ormid, PlayerInfo[playerid][pDeaths], "deaths");
	orm_addvar_int(ormid, PlayerInfo[playerid][pExpsum], "expsum");
	orm_addvar_int(ormid, PlayerInfo[playerid][pInterface], "interface");
	orm_addvar_int(ormid, PlayerInfo[playerid][pLowerPanel], "lower_panel");
	orm_addvar_int(ormid, PlayerInfo[playerid][pRusifik], "rusifik");
	orm_addvar_int(ormid, PlayerInfo[playerid][pHouseIcon], "house_icons");
	orm_addvar_int(ormid, PlayerInfo[playerid][pToggleZone], "toggle_zone");
	orm_addvar_float(ormid, PlayerInfo[playerid][pPower], "power");
	orm_addvar_int(ormid, PlayerInfo[playerid][pTraining], "training");
	orm_addvar_int(ormid, PlayerInfo[playerid][pShooting], "shooting");
	orm_addvar_int(ormid, PlayerInfo[playerid][pWalk], "walk");
	orm_addvar_int(ormid, PlayerInfo[playerid][pAnim], "anim");
	orm_addvar_int(ormid, PlayerInfo[playerid][pFightStyle], "fight_style");
	orm_addvar_int(ormid, PlayerInfo[playerid][pGametime], "gametime");
	//	missions:
	orm_addvar_int(ormid, gMissionProgress[playerid][MIS_SOURCE_TRAINING], "mission_training");
	#if defined _job_core_included
		Job.SetORM(ormid, playerid);
	#endif
	return true;
}// end of OnPlayerConnect(playerid)

public	OnPlayerRequestClass(playerid, classid)
{
	if (IsPlayerNPC(playerid))
		return (1);

	TogglePlayerSpectating(playerid, true);
	if (gPlayerLogged[playerid])
	{
		UpdatePlayerSkin(playerid);
		TogglePlayerSpectating(playerid, false);
	}
	return (1);
}

public OnPlayerRequestSpawn(playerid)
{
    return false;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(IsPlayerNPC(playerid))
		return (1);

	gPlayerDisconnecting[playerid] = true;

	// #if defined _job_core_included
	// 	Job.ClearPlayerNowWork(playerid, Job.REASON_DISCONNECT);
	// #endif
	 #if defined _player_phone_included
		Phone_CancelCall(playerid);
	#endif

	new string[128];
	UpdatePlayerStatics(playerid);
	//---
	CancelSelectTextDraw(playerid);
	Streamer_ToggleAllItems(playerid, STREAMER_TYPE_3D_TEXT_LABEL, true);
	MyDisablePlayerCheckpoint(playerid);

	//HidePlayerInventory(playerid);
	//	update vehicle
	new v = GetPlayerVehicleID(playerid);
	if(v > 0)	UpdateVehInfo(v);
	CancelPlayerBerth(playerid);					// ������� ���������� �����
    CancelEditHomeObject(playerid);					// ������� �������������� ������
    StopPursuit(playerid, 2);       				// ������� ������ (���� ����) �� ������� ������
	CopList_REMOVE(playerid);						// ������� ���� �� ������
    PoliceMissionCancel(playerid, "quit");			// ������� ����������� ������
    HidePlayerGPSPoint(playerid);					// ������� GPS
	DestroyCriminalMarker(playerid);
	BenchpressClear(playerid);						// ������ ���� ������
	JailJobClear(playerid);							// ������ �� ����
	AS_ClearVars(playerid);							// ���������
	ClearPlayerShooting(playerid, true);			// ������ �������� � ����
	FinishBox(playerid, 0);							// ������ ����������� ��������
	RaceLeave(playerid);							// ����� �� �����
	StoryMissionCancel(playerid);					// ������� ������
	RobberyClear(playerid, 1);						// ������� ���������� ��������
	
	DeleteJailNumber(playerid);						// �������� ������ ��� ������� �����������
	CancelMechanicDuty(playerid);					// ������� ������ ���������

	DestroyDynamic3DTextLabel(criminal_3d[playerid]), criminal_3d[playerid] = Text3D:INVALID_STREAMER_ID;

	DestroyDynamicObject(GotoObject[playerid]), GotoObject[playerid] = INVALID_STREAMER_ID;
	DestroyDynamicObject(TestObject[playerid]), TestObject[playerid] = INVALID_STREAMER_ID;

	KillTimer(MissionInfoTimer[playerid]);
	KillTimer(criminal_timer[playerid]);
				
	if(PlayerVehicle[playerid])					BlockVehicleEffect(PlayerVehicle[playerid]);						//	FIX: ���� ��� ������ ������ ���� � ���� (������ ���������)
	if(PlayerInfo[playerid][pJailTime])			Iter_Remove(Prisoners, playerid);									// ������� ���� �� ������
	if(PlayerVehicle[playerid])					ExitVehicle(playerid);												// ������� �������� ����
    
	// ����� � ������������ ����������
	if(GetPlayerAsk(playerid) == ASK_POLICE_FINE)
		PlayerInfo[playerid][pJailTime] = -GetPlayerWantedLevel(playerid);
	
    if(GetPVarInt(playerid, "EditAdID"))		gAdvert[GetPVarInt(playerid, "EditAdID") - 1][adStatus] = 0;
    if(GetPVarType(playerid, "Admin:InTicket") != PLAYER_VARTYPE_NONE)
    {
    	gAsk[GetPVarInt(playerid, "Admin:InTicket")][askStatus] = false;
    }
    //	���������� ���������
	foreach(Spectators, i)	
	{	
		if(SpectateID[i] == playerid)
		{
			callcmd::specoff(i, "");	
		}
	}	
	//---	RentCar
	new rentcar = GetPVarInt(playerid, "RentCar");
	if(rentcar)
	{
		if(VehInfo[rentcar][vRentTime] <= 0)
		{
			MySetVehicleToRespawn(rentcar);
		}
	}
	if(GetPVarInt(playerid, "Roped"))
    {
        for(new i = 0; i < ROPE_LENGTH; i++)
        	DestroyDynamicObject(RopeObjects[playerid][i]);
	}
	//	�������� ����� � ���������
	if(GetPVarInt(playerid, "Player:NearAirportDoor") == 1 && NearAirportDoorPlayers > 0)
    {
        if(--NearAirportDoorPlayers == 0)
        {
        	MyMoveDynamicObject(AirportDoor[0], 1684.27, -2335.98, 12.56, 1.5, -1000.0, -1000.0, -1000.0);
			MyMoveDynamicObject(AirportDoor[1], 1687.27, -2335.94, 12.56, 1.5, -1000.0, -1000.0, -1000.0);
        }
    }

	if(FirstSpawn[playerid] == false)
	{
		if(reason == 0)
		{
			format(string, sizeof(string), "[Disconnect]: %s[%d] ���������� �� ������� (����� �����)", ReturnPlayerName(playerid), playerid);
			MySendClientMessageToAll(COLOR_GRAD2, string);
		}
		else if(reason == 1)
		{
			format(string, sizeof(string), "[Disconnect]: %s[%d] ���������� �� ������� (�������)", ReturnPlayerName(playerid), playerid);
			SendAdminMessage(COLOR_GRAD2, string); // for admin
		}
		else if(reason == 2)
		{
			format(string, sizeof(string), "[Disconnect]: %s[%d] ���������� �� ������� (������/�������)", ReturnPlayerName(playerid), playerid);
			MySendClientMessageToAll(COLOR_GRAD2, string);
		}
	}
	ZeroVars(playerid);
	return true;
}

stock SetPlayerSpawn(playerid)
{
	//	change spawn points
	if(PlayerInfo[playerid][pSpawn] == SPAWN_HOUSE)
	{
		if(PlayerInfo[playerid][pHousing] == 0 && PlayerInfo[playerid][pRent] == 0)
		{
			if(PlayerInfo[playerid][pFaction])	PlayerInfo[playerid][pSpawn] = SPAWN_FACTION;
			else 								PlayerInfo[playerid][pSpawn] = SPAWN_NEWBIE;
		}
	}
	else if(PlayerInfo[playerid][pSpawn] == SPAWN_FACTION)
	{
		if(PlayerInfo[playerid][pFaction] == 0)
		{
			if(PlayerInfo[playerid][pHousing] != 0 || PlayerInfo[playerid][pRent] != 0)
					PlayerInfo[playerid][pSpawn] = SPAWN_HOUSE;
			else 	PlayerInfo[playerid][pSpawn] = SPAWN_NEWBIE;
		}
	}
	/////
	new Float:pos[4];

	if(PlayerInfo[playerid][pAJailTime])
	{
		if(PlayerInfo[playerid][pAJailTime] > gettime())
		{
			PlayerBusy{playerid} = true;
			TogglePlayerStreamerAllItem(playerid, false);
			pos[0] = -181.5, pos[1] = 3301.5, pos[2] = 24.5, pos[3] = 90.0;
			SetRandPos(pos[0], pos[1], 3.0);
			MySetPlayerSpawnPos(playerid, Arr4<pos>, 10, VW_AJAIL);
			PlayerInfo[playerid][pSaveHealth] = 100.0;
		    SetPlayerHunger(playerid, 100);
		}
		else
		{
			PlayerBusy{playerid} = false;
			TogglePlayerStreamerAllItem(playerid, true);
			MySetPlayerSpawnPos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ] + 0.2, PlayerInfo[playerid][pPosA], PlayerInfo[playerid][pPosINT], PlayerInfo[playerid][pPosVW]);
			PlayerInfo[playerid][pAJailTime] = 0;
			SendClientMessage(playerid, COLOR_LIGHTRED, "�� �������� ���� ������ ���������, ������ �� ���������!");
		}
	}
	else if(PlayerInfo[playerid][pJailTime] > 0)
	{
		if(PlayerInfo[playerid][pJailTime] < unixtime())
		{
			JailDelivery(playerid, false);
		}
		else
		{
			SetPlayerPrisonPos(playerid, LastPrisonStatus);
		}
		PlayerInfo[playerid][pSaveHealth] = 50.0;
	    SetPlayerHunger(playerid, 50);
	}
	else if(PlayerInfo[playerid][pJailTime] < 0)
	{
		MySetPlayerSpawnPos(playerid, 264.6, 77.6, 1001.0, 270.0, 6, VW_LSPD);
	}
	else if(AS_ElementNumber[playerid] > 0)
	{
		MySetPlayerSpawnPos(playerid, -2026.77, -114.345, 1035.172, 1.0, 3, VW_AUTOSCHOOL);
	}
	else if(IsGang(PlayerInfo[playerid][pFaction]) && InGangZone[playerid] >= 0)
	{	//	������� ������� ���
		new zone = InGangZone[playerid];
		pos[0] = GangZones[zone][0] + random(floatround(GangZones[zone][2] - GangZones[zone][0]));
		pos[1] = GangZones[zone][1] + random(floatround(GangZones[zone][3] - GangZones[zone][1]));
		MapAndreas_FindZ_For2DCoord(Arr3<pos>);
		MySetPlayerSpawnPos(playerid, pos[0], pos[1], pos[2] + 2.0, 0.0);
	}

	//	���� �� ������ ������ � ������ - ������� ��� ����� � ����
	/*else if(gMissionProgress[playerid][MIS_SOURCE_TRAINING] < 1)
	{
		pos[0] = SpawnCoord[0], pos[1] = SpawnCoord[1], pos[2] = SpawnCoord[2], pos[3] = SpawnCoord[3];
		SetRandPos(pos[0], pos[1], 2.0);
		MySetPlayerSpawnPos(playerid, Arr4<pos>);
		PlayerInfo[playerid][pSaveHealth] = 50.0;
	    SetPlayerHunger(playerid, 100);
	}*/

	else if(GetPVarInt(playerid, "Player:SpawnHospital"))
	{
		new const Float:HospitalPos[2][4] =
		{
			{ -2673.0, 642.0, 1275.3, 270.0 },
			{ -2661.0, 642.0, 1275.2, 270.0 }
		};
		new rand = random(2);
		pos[0] = HospitalPos[rand][0], pos[1] = HospitalPos[rand][1], pos[2] = HospitalPos[rand][2], pos[3] = HospitalPos[rand][3];
		SetRandPos(pos[0], pos[1], 1.5);
		MySetPlayerSpawnPos(playerid, Arr4<pos>, 1, VW_HOSPITAL);
		if(PlayerInfo[playerid][pVip])
	    {
			PlayerInfo[playerid][pSaveHealth] = 100.0;
			PlayerInfo[playerid][pSaveArmour] = 100.0;
			SetPlayerHunger(playerid, 100);
	    }
	    else
	    {
	    	PlayerInfo[playerid][pSaveHealth] = 10.0;
	    	SetPlayerHunger(playerid, 50);
	    }
	    DeletePVar(playerid, "Player:SpawnHospital");
	}
	else
	{
		if(FirstSpawn[playerid] && PlayerInfo[playerid][pExitUNIX] + MAX_ABSENCE_TIME * 60 > unixtime() && PlayerInfo[playerid][pPosX] && PlayerInfo[playerid][pPosY])
		{	//	��������� ������ ��� ����� 15 �����
			MySetPlayerSpawnPos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ], PlayerInfo[playerid][pPosA], PlayerInfo[playerid][pPosINT], PlayerInfo[playerid][pPosVW]);
		}
		else
		{
			if(PlayerInfo[playerid][pSpawn] == SPAWN_HOUSE)
			{
				new h = (-1);
				if(PlayerInfo[playerid][pHousing] > 0)		h = FoundHouse(PlayerInfo[playerid][pHousing]);	//  �������� � ����
				else if(PlayerInfo[playerid][pRent] > 0)	h = FoundHouse(PlayerInfo[playerid][pRent]);	//	�������� ���
				if(h != (-1))
				{
					new Class = HouseInfo[h][hClass] - 1;
					new Int = HouseInfo[h][hInt] - 1;
					new Float:A = InterCoords[Class][Int][3] + 180;
					new Float:X = InterCoords[Class][Int][0] + (2.0 * floatsin(-A, degrees));
					new Float:Y = InterCoords[Class][Int][1] + (2.0 * floatcos(-A, degrees));
					MySetPlayerSpawnPos(playerid, X, Y, InterCoords[Class][Int][2], InterCoords[Class][Int][3], 1, VW_HOUSE + HouseInfo[h][hID]);
				}
				//	������� � ����� Jefferson
				else if(PlayerInfo[playerid][pRent] < 0)
				{
					new hotel_roow = PlayerInfo[playerid][pRent] * (-1) - 1; // = {0, 1, 2}
					MySetPlayerSpawnPos(playerid, Arr4<HotelRooms[hotel_roow][H_POS]>, HotelRooms[hotel_roow][H_INT], playerid);
				}
			}
			else if(PlayerInfo[playerid][pSpawn] == SPAWN_FACTION)
			{
				MySetPlayerSpawnPos(playerid, Arr4<Faction[PlayerInfo[playerid][pFaction]][F_SPAWN]>, Faction[PlayerInfo[playerid][pFaction]][F_INT], Faction[PlayerInfo[playerid][pFaction]][F_VW]);
			}
			else
			{
				pos[0] = SpawnCoord[0], pos[1] = SpawnCoord[1], pos[2] = SpawnCoord[2], pos[3] = SpawnCoord[3];
				SetRandPos(pos[0], pos[1], 2.0);
				MySetPlayerSpawnPos(playerid, Arr4<pos>);
			}

			/*if(PlayerInfo[playerid][pVip])
		    {
				PlayerInfo[playerid][pSaveHealth] = 100.0;
				PlayerInfo[playerid][pSaveArmour] = 100.0;
				SetPlayerHunger(playerid, 100);
		    }
		    else
		    {
		    	PlayerInfo[playerid][pSaveHealth] = 10.0;
	    		SetPlayerHunger(playerid, 50);
		    }*/
		}
	}
	return true;
}

public OnPlayerSpawn(playerid)
{
	if (IsPlayerNPC(playerid))
		return (1);

	gPlayerDeath[playerid] = false;

	new string[128];
	new hour;
	new timeUNIX = gettime(hour, _, _);

	//TogglePlayerControllable(playerid, false);	//	fix

	new Float:pos[4], int, vw;
	GetSpawnPos(playerid, Arr4<pos>, int, vw);
	Streamer_UpdateEx(playerid, Arr3<pos>, vw, int);

	//---	Set game params
	if(PlayerInfo[playerid][pSaveHealth] > 160.0)		PlayerInfo[playerid][pSaveHealth] = 160.0;
	else if(PlayerInfo[playerid][pSaveHealth] < 10.0)	PlayerInfo[playerid][pSaveHealth] = 10.0;
	MySetPlayerHealth(playerid, 	PlayerInfo[playerid][pSaveHealth]);
	MySetPlayerArmour(playerid, 	PlayerInfo[playerid][pSaveArmour]);
	MySetPlayerMoney(playerid,		PlayerInfo[playerid][pMoney]);
	SetPlayerInterior(playerid,		int);
	SetPlayerVirtualWorld(playerid,	vw);

	if(GetPVarInt(playerid, "RegCutSceneState"))
	{
		return true;
	}
	
	//FirstSpawnCam(playerid, 0);
	GameTextForPlayer(playerid, " ", 1000, 4);
	PlayerPlaySound(playerid, 1188, 0.0, 0.0, 0.0);

	//---	First spawn (OnPlayerSpawn)
	if(FirstSpawn[playerid])
	{
		//	Set Settings
		StopAudioStreamForPlayer(playerid);

		ClearChatbox(playerid, 10);
		new timename[20];
		switch(hour)
		{
		    case 0..5: 		timename = "� ������ �����";
		    case 6..11: 	timename = "������ ����";
		    case 12..17: 	timename = "������ ����";
		    case 18..23: 	timename = "������ �����";
		}
		//SendClientMessage(playerid, COLOR_GREEN, "===============================");
		SendFormatMessage(playerid, COLOR_WHITE, string, "%s, "MAIN_COLOR"%s{FFFFFF}", timename, ReturnPlayerName(playerid));
		SendClientMessage(playerid, COLOR_WHITE, "����� ���������� �� "MAIN_COLOR"S{FFFFFF}ilver "MAIN_COLOR"B{FFFFFF}reak");
		if(PlayerInfo[playerid][pAdmin] > 0)
		{
			SendClientMessage(playerid, COLOR_WHITE, "�� ��������� ��� �����-���������");
			if(!Anticheat.GetToggle()) SendClientMessage(playerid, COLOR_LIGHTRED, "�����, ������� ��������, ���� ����������");
		}
		SendClientMessage(playerid, COLOR_WHITE, "����� ������ �����: " MAIN_COLOR SITE_ADRESS);
		SendClientMessage(playerid, COLOR_WHITE, "");
		//SendClientMessage(playerid, COLOR_GREEN, "===============================");
		// Email check
		if(strlen(GetPlayerEmail(playerid)) == 0)
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "������� ���� email ����� {FFFFFF}(/mm > ������������)");
		    SendClientMessage(playerid, COLOR_LIGHTRED, "��� ���� ����������� ������������ ��������� ������");
		}
		if(PlayerInfo[playerid][pVip] && PlayerInfo[playerid][pVipUNIX] < unixtime())
		{
			PlayerInfo[playerid][pVip] = 0, PlayerInfo[playerid][pVipUNIX] = 0;
			SendClientMessage(playerid, COLOR_LIGHTRED, "��� ������� ������� ����������, ��� ��������� ����������� ����.");
		}
		
		// ���������� ����� ������
		if(IsPlayerLeader(playerid))
		{
		    PlayerInfo[playerid][pRank] = FactionRankMax[PlayerInfo[playerid][pFaction]];
		}
		// ������� ��������������
		if(PlayerInfo[playerid][pWarns] > 0 && PlayerInfo[playerid][pWarnUNIX] + 7 * 24 * 60 * 60 <= timeUNIX)
		{
		    if(--PlayerInfo[playerid][pWarns] > 0) PlayerInfo[playerid][pWarnUNIX] = timeUNIX;
		    SendClientMessage(playerid, COLOR_LIGHTRED, "[WARN]: ������ ������ ������ ���������� �����, ������� ��� ��� �������");
		}
		// ������������ �� �����������
		if(PlayerInfo[playerid][pFaction] == -1)
		{
		    SetPlayerFaction(playerid, F_NONE);
		    SendClientMessage(playerid, COLOR_LIGHTRED, "��������! ��� ��������� �� �����������, ���� �� ���� ������");
		}
	
		if(Job.GetPlayerPartWage(playerid) > 0)
		{
		    SendFormatMessage(playerid, COLOR_LIGHTRED, string, "�� ������ �� ���� �� ����������: {FFFFFF}%d$", Job.GetPlayerPartWage(playerid));
		    MyGivePlayerMoney(playerid, Job.GetPlayerPartWage(playerid)), Job.SetPlayerPartWage(playerid, 0);
		}
		// ���������� ������ � �������
		if(IsGang(PlayerInfo[playerid][pFaction]))
		{
	        for(new z; z < sizeof(GangZones); z++)
	        {
	            if(GangZoneEnemy[z] > 0 && (PlayerInfo[playerid][pFaction] == GangZoneOwner[z] || PlayerInfo[playerid][pFaction] == GangZoneEnemy[z]))
	            {
					Streamer_AppendArrayData(STREAMER_TYPE_MAP_ICON, GangZoneMapIcon[z], E_STREAMER_PLAYER_ID, playerid);
					Streamer_Update(playerid, STREAMER_TYPE_MAP_ICON);
	                break;
	            }
			}
		}
		//	��������� � ����� ������������ ������ ���������
		mysql_format(g_SQL, string, sizeof(string), "SELECT `message`, `date` FROM `offline_message` WHERE `user_id` = '%d'", PlayerInfo[playerid][pUserID]);
		new Cache:result = mysql_query(g_SQL, string);
		if(cache_num_rows() > 0)
		{
			new lstring[512], date, m_date[6];
			lstring = "{FFFFFF}���� �� ���� ������, ��� ������ ���������:\n";
			for(new m = 0; m < cache_num_rows(); m++)
			{
				cache_get_value_name(m, "message", string);
				cache_get_value_name_int(m, "date", date);
				gmtime(date, Arr6<m_date>);
				format(lstring, sizeof(lstring), "%s\n"MAIN_COLOR"[%02d/%02d/%04d %02d:%02d]{FFFFFF}\n%s\n", lstring, m_date[1], m_date[2], m_date[0], m_date[3], m_date[4], string);
			}
			MyShowPlayerDialog(playerid, DMODE_OFFLINE_MESSAGE, DIALOG_STYLE_MSGBOX, "����������", lstring, "�������", "", 0);
		}
		cache_delete(result);
	}
	else
	{
		//////////		Clear 		//////////
		BlockPlayerAnimation(playerid, false);
		PlayerCuffedTime[playerid] = 0;
		Iter_Remove(Spectators, playerid);
		BenchpressClear(playerid);	//	������� ���� ������
		AS_ClearVars(playerid);		//	������� ���������
		if(GetPVarInt(playerid, "Thing:RadioID"))
		{
			DeletePVar(playerid, "Thing:RadioID");
			StopAudioStreamForPlayer(playerid);
		}
		//////////////////////////////////////
		//	IFace
		TextDrawHideForPlayer(playerid, Busted);
		TextDrawHideForPlayer(playerid, Wasted);
		IFace.ToggleTVEffect(playerid, false);
		IFace.ToggleGroup(playerid, IFace.SPEEDO, false);
		StopPlayerFade(playerid);

		#if defined _job_core_included
			if(Jobs[ Job.GetPlayerNowWork(playerid) ][J_CLEAR_TYPE])
			{
				Job.ClearPlayerNowWork(playerid, Job.REASON_DEATH);
			}
		#endif
	}

	if(PlayerInfo[playerid][pJailTime] < 0)
	{	// ���� � ���
		JailTime[playerid] = 60;
		SendClientMessage(playerid, COLOR_LIGHTRED, "��� �������� � ������ ���������������� ���������� �� ��������� ���������");
	}
	else if(PlayerInfo[playerid][pJailTime] > 0)	// ���� � ������
	{
		if(PlayerInfo[playerid][pJailTime] < timeUNIX)
		{	// ������������ �� ������
		    PlayerInfo[playerid][pJailTime] = 0;
			GameTextForPlayer(playerid, "~w~You are ~r~Free", 5000, 4);
			SendClientMessage(playerid, COLOR_LIGHTRED, "�� ��������� ���� ��������, ������ �� ��������");
			PlayerTextDrawHide(playerid, p_JailPeriod);
			Iter_Remove(Prisoners, playerid);
			HidePlayerPrisonTime(playerid);
			JailJobClear(playerid);
			if(p_JailOccupied[playerid] != INVALID_PLAYER_ID)
			{
				g_JailOccupied[ p_JailOccupied[playerid] ]--;
				p_JailOccupied[playerid] = INVALID_PLAYER_ID;
			}
		}
		else
		{
			if(GetPVarInt(playerid, "PrisonCycle"))
			{
				IFace.ToggleTVEffect(playerid, true);
				SetPlayerCameraPos(playerid, 693.5, -2917.4, 1701.3);
				SetPlayerCameraLookAt(playerid, 690.0, -2917.4, 1700.8);
				SetTimerEx("MyFreezePlayer", 1000, false, "d", playerid);
				SetPVarInt(playerid, "Prison:FlyCamera:Timer", SetTimerEx("PrisonCycle", 2000, false, "dd", playerid, 5));
			}
			else
			{
				new statusname[20];
				if(LastPrisonStatus == 1)		statusname = "~y~������";
			    else if(LastPrisonStatus == 2)	statusname = "~y~��������";
			    else if(LastPrisonStatus == 3)	statusname = "~y~��������";
			    else if(LastPrisonStatus == 4)	statusname = "~y~�����";
				Iter_Add(Prisoners, playerid);
				ShowPlayerPrisonTime(playerid);
				PlayerTextDrawSetString(playerid, p_JailPeriod, RusText(statusname, isRus(playerid)));
				PlayerTextDrawShow(playerid, p_JailPeriod);
				if(strlen(jail_numer[playerid]) == 0)
				{
					format(jail_numer[playerid], sizeof(jail_numer[]), "#%03d-%04d", random(999), random(9999));
					jail_number_3dtext[playerid] = CreateDynamic3DTextLabel(jail_numer[playerid], COLOR_LIGHTYELLOW, 0.0, 0.0, 0.3, 20.0, playerid, INVALID_VEHICLE_ID, 1);
				}
			}
		}
	}
	return true;
}// end of OnPlayerSpawn

//////	���������� ����� ������� ������ ������, � �� � ��������
stock OnPlayerSpawnFinish(playerid)
{
	if(GetPVarInt(playerid, "RegCutSceneState") == 0)
	{
		// if(PlayerInfo[playerid][pJailTime] == 0)
		//	Inv.LoadPlayerUsedWeapon(playerid);	//	MyChangePlayerWeapon(playerid, false);
		Inv.GetPlayerUsingItem(playerid);

	#if defined _player_achieve_included	
		if(PlayerInfo[playerid][pDeaths] >= 100)
		{
			GivePlayerAchieve(playerid, ACHIEVE_DEATH);	//	���������� '��������'
		}
	#endif
		//if(gMissionProgress[playerid][MIS_SOURCE_TRAINING] < 4)	StoryMissionStart(playerid, MIS_SOURCE_TRAINING);
		if(FirstSpawn[playerid])
		{
			if(IsPlayerInDynamicArea(playerid, AirportZone[2]))
			{
				PlayAudioStreamForPlayer(playerid, AUDIOFILE_PATH "/airport.mp3");
			}
			MySetPlayerWantedLevel(playerid, PlayerInfo[playerid][pWantedLvl]);
			ToggleCriminalDanger(playerid, CriminalDanger[playerid]);
			IFace.ToggleGroup(playerid, IFace.INTERFACE, PlayerInfo[playerid][pInterface]);

			#if defined _player_achieve_included
				Achieve_Check(playerid);
			#endif
			FirstSpawn[playerid] = false;
		}
		else
		{
			#if defined _inventory_in_hands_included
				Inv.UpdateThingInHand(playerid);
			#endif

			#if defined _inventory_acsr_included
				Acsr.UpdatePlayerAcsr(playerid);
			#endif

		//	money
			if(GetPVarInt(playerid, "DeathMoney"))
			{
				MySetPlayerMoney(playerid, GetPVarInt(playerid, "DeathMoney"));
				DeletePVar(playerid, "DeathMoney");
			}
		//	������� ������� ���
			if(IsGang(PlayerInfo[playerid][pFaction]) && InGangZone[playerid] >= 0)
			{
				SetTimerEx("gzgodmode", 500, false, "ii", playerid, 8);
			}
			SetTimerEx("MyUnfreezePlayer", 1500, false, "i", playerid);
		}
		PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
		UpdatePlayerWeather(playerid);
		UpdatePlayerTime(playerid);
	}
	else
	{
		MyUnfreezePlayer(playerid);
		SetTimerEx("FixRegAnim", 500, false, "i", playerid);
	}
	DeletePVar(playerid, "AC:Spawn:BlockCheck");
	return true;
}

/*flags:testcam(CMD_DEVELOPER);
CMD:testcam(playerid, params[])
{
	FirstSpawnCam(playerid, 0);
	return true;
}

Public: FirstSpawnCam(playerid, step)
{
	new Float:pos[3];
	GetPlayerPos(playerid, Arr3<pos>);
	switch(step)
	{
		case 0:
		{
			FadeColorForPlayer(playerid, 34, 139, 34, 150, 34, 139, 34, 40, 10);
			InterpolateCameraPos(playerid, pos[0], pos[1], pos[2] + 500.0, pos[0], pos[1], pos[2] + 5.0, 1000 * 30);
			InterpolateCameraLookAt(playerid, pos[0], pos[1], pos[2] - 50.0, pos[0], pos[1], pos[2] - 50.0, 1000 * 30);
			SetTimerEx("FirstSpawnCam", 2000, false, "dd", playerid, 1);
		}
		case 1:
		{
			FadeColorForPlayer(playerid, 34, 139, 34, 150, 34, 139, 34, 40, 10);
			InterpolateCameraPos(playerid, pos[0], pos[1], pos[2] + 200.0, pos[0], pos[1], pos[2] + 5.0, 1000 * 15);
			InterpolateCameraLookAt(playerid, pos[0], pos[1], pos[2] - 50.0, pos[0], pos[1], pos[2] - 50.0, 1000 * 15);
			SetTimerEx("FirstSpawnCam", 2000, false, "dd", playerid, 2);
		}
		case 2:
		{
			new Float:x = pos[0], Float:y = pos[1], Float:a;
			GetPlayerFacingAngle(playerid, a);
			GetXYInFrontOfPoint(x, y, a - 180.0, 3.0);

			FadeColorForPlayer(playerid, 34, 139, 34, 150, 34, 139, 34, 40, 10);
			InterpolateCameraPos(playerid, pos[0], pos[1], pos[2] + 30.0, x, y, pos[2] + 0.7, 1000 * 5);
			InterpolateCameraLookAt(playerid, pos[0], pos[1], pos[2] - 20.0, pos[0], pos[1], pos[2] + 0.7, 1000 * 5);
			SetTimerEx("FirstSpawnCam", 5000, false, "dd", playerid, 3);
		}
		case 3:
		{
			StopPlayerFade(playerid);
			SetCameraBehindPlayer(playerid);

			ToggleCriminalDanger(playerid, CriminalDanger[playerid]);
			if(RestTime > 0)	IFace.ToggleGroup(playerid, IFace.RESTART, true);
			MySetPlayerWantedLevel(playerid, PlayerInfo[playerid][pWantedLvl]);
			#if defined _player_achieve_included
				Achieve_Check(playerid);
			#endif

			MyUnfreezePlayer(playerid);
		}
	}
	return true;
}*/

Public: FixRegAnim(playerid)
{
	MyApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 1, 0, 0, 1, 0);
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if (IsPlayerNPC(playerid))
		return (1);

	gPlayerDeath[playerid] = true;

	#if defined _gang_gang_zones_included
		Gang.GZ_OnPlayerDeath(playerid, killerid, reason);
	#endif
	#if defined _police_core_included
		Police_OnPlayerDeath(playerid, killerid, reason);
	#endif
	// #if defined _job_core_included
	// 	Job.OnPlayerDeath(playerid, killerid, reason);
	// #endif

	#if defined _player_phone_included
		Phone_CancelCall(playerid);
	#endif
	#if defined	_job_job_taxi_included
		CancelUseTaxi(playerid);	// ������� ������������� �����
	#endif

	new string[256];
	new ShowWasted = true;
	if(AS_ElementNumber[playerid] == 0)	ShowWasted = false;
	if(IsPlayerLogged(killerid))
	{
		if(reason != WEAPON_COLLISION)
		{
			if(Anticheat.GetToggle())
			{
				if(GetDistanceBetweenPlayers(playerid, killerid) > 280)
				{
					format(string, sizeof(string), "������������� � ������ ������ �� %s[%d]", ReturnPlayerName(killerid), killerid);
					AC_PlayerMessage(playerid, string);
				    GiveAnticheatWarn(playerid, FAKE_KILL);
				}
			}
			PlayerInfo[killerid][pKills]++;
			FadeColorForPlayer(killerid, 65, 105, 225, 70, 255, 0, 0, 0, 5);	//	������ ������ ������ ��� ��������
		}

		//	achievements
	#if defined _player_achieve_included	
		if(PlayerInfo[killerid][pKills] >= 100)			GivePlayerAchieve(killerid, ACHIEVE_KILLER);	//	���������� '������'
		if(PlayerInfo[killerid][pAdmin] >= ADMIN_ADMIN)	GivePlayerAchieve(playerid, ACHIEVE_ADMINKILL);	//	���������� '����� �����'
	#endif

	}

	//---	Clear game params
	MyChangePlayerWeapon(playerid, true);
	SetPlayerDrunkLevel(playerid, 0);
	MyHidePlayerDialog(playerid);
	Dialog_Close(playerid);
	MyDisablePlayerCheckpoint(playerid);
	IFace.HealthUpdate(playerid, 0.0);

	//---	set gamemode params
	if(PlayerInfo[playerid][pJailTime] < unixtime())
	{
		UpdatePlayerSkin(playerid, false);
	}

	//---	clear
	PlayerInfo[playerid][pSaveArmour] = 0.0; // [BT]
	PlayerInfo[playerid][pDeaths]++;
	gExpTime[playerid] = 0; gExpCount[playerid] = 0;
	PM_Type[playerid] = 0;	PM_Place[playerid] = 0;	// ������� ����������� ������
	DeletePVar(playerid, "Player:Attack:Attacker");
	DeletePVar(playerid, "Player:JobPartner");

	_CarryDown(playerid);	//CarryClear(playerid);
	IFace.HidePlayerInfoBar(playerid);
	// PlayerTextDrawHide(playerid, InfoBar);
	FlashPoliceZone(playerid, false);
	HideMissionInfo(playerid);
	CancelPlayerBerth(playerid);		// ������� ���������� �����
	CancelEditHomeObject(playerid);		// ������� �������������� ������ (���� �������������)
	JailJobClear(playerid);				// ������ �� ����
	BenchpressClear(playerid);			// ������ ���� ������
	ClearPlayerShooting(playerid);		// ������ �������� � ����
	RaceLeave(playerid);				// ����� �� �����
	StoryMissionCancel(playerid);		// ����� �� ��������
	RobberyClear(playerid, 2);			// ������� ���������� ��������
	CancelMechanicDuty(playerid);		// ������� ������ ���������
	
	if(GetPVarInt(playerid, "Roped"))
    {
		DeletePVar(playerid, "Roped");
        for(new i = 0; i < ROPE_LENGTH; i++)
        	DestroyDynamicObject(RopeObjects[playerid][i]);
	}
	//---	Spawn
	if(ShowWasted)	TextDrawShowForPlayer(playerid, Wasted);
	SetPVarInt(playerid, "DeathMoney", MyGetPlayerMoney(playerid));
	SetPVarInt(playerid, "Player:SpawnHospital", true);
	SetPlayerSpawn(playerid);
	return true;
}

//	Callbacks: Vehicles
public OnVehicleSirenStateChange(playerid, vehicleid, newstate)
{
	new model = GetVehicleModel(vehicleid);
	switch(model)
	{
		case 416, 523, 427, 490, 528, 407, 544, 596, 597, 598, 599, 601:
		{
			if(newstate)
			{
		    	VehInfo[vehicleid][vSiren] = true;
		    	SetVehicleFlasher(vehicleid, 3);
		    }
		    else
		    {
		    	VehInfo[vehicleid][vSiren] = false;
		    	SetVehicleFlasher(vehicleid, 0);
		    }
		    //UpdatePlayerColor(playerid);
		}
	}
    return true;
}

public OnVehicleSpawn(vehicleid)
{
	if(VehInfo[vehicleid][vSpawnDestroy])
	{
		MyDestroyVehicle(vehicleid);
		return 1;
	}

	setVehicleAlarm(vehicleid, false);
	SetVehicleEngine(vehicleid, false);
	SetVehicleBonnet(vehicleid, false);
	SetVehicleBoot(vehicleid, false);
	MySetVehicleHealth(vehicleid, 999);
    VehInfo[vehicleid][vRadio] = 0;
    VehInfo[vehicleid][vPlayers] = 0;
	VehInfo[vehicleid][vLights] = false;
	if(CarInfo[vehicleid][cType] != C_TYPE_PLAYER)
	{
		if(VehInfo[vehicleid][vLocked] == 1)	VehInfo[vehicleid][vLocked] = 0;
		VehInfo[vehicleid][vFuel] = GetVehicleMaxFuel(vehicleid);
	}
	UpdateVehicleParamsEx(vehicleid);

	// ������
	AddVehicleComponent(vehicleid, CarInfo[vehicleid][cSpoiler]);
	AddVehicleComponent(vehicleid, CarInfo[vehicleid][cHood]);
	AddVehicleComponent(vehicleid, CarInfo[vehicleid][cRoof]);
	AddVehicleComponent(vehicleid, CarInfo[vehicleid][cSideskirt]);
	AddVehicleComponent(vehicleid, CarInfo[vehicleid][cNitro]);
	AddVehicleComponent(vehicleid, CarInfo[vehicleid][cLamps]);
	AddVehicleComponent(vehicleid, CarInfo[vehicleid][cExhaust]);
	AddVehicleComponent(vehicleid, CarInfo[vehicleid][cWheels]);
	AddVehicleComponent(vehicleid, CarInfo[vehicleid][cHydraulics]);
	AddVehicleComponent(vehicleid, CarInfo[vehicleid][cFrontBumper]);
	AddVehicleComponent(vehicleid, CarInfo[vehicleid][cRearBumper]);
	AddVehicleComponent(vehicleid, CarInfo[vehicleid][cVentR]);
	AddVehicleComponent(vehicleid, CarInfo[vehicleid][cVentL]);
	ChangeVehiclePaintjob(vehicleid, CarInfo[vehicleid][cPaintJob]);
	MyChangeVehicleColor(vehicleid, CarInfo[vehicleid][cColor1], CarInfo[vehicleid][cColor2]);

	//---	��������� ������
	if(VehInfo[vehicleid][vRentOwner] != 0)
	{
		new owner = GetPlayeridToUserID(VehInfo[vehicleid][vRentOwner]);
		if(owner != INVALID_PLAYER_ID && GetPVarInt(owner, "RentCar") == vehicleid)
			DeletePVar(VehInfo[vehicleid][vRentOwner], "RentCar");
		VehInfo[vehicleid][vRentOwner] = 0;
		UpdateVehicleLabel(vehicleid);
	}

	#if defined	_job_part_farmer_included
		//---	�������� ����� �� ����������� ������
		if(g_FarmVehicleGrass[vehicleid])
		{
			for(new o = 0; o < MAX_VEHICLE_GRASS; o++)
			{
			    DestroyDynamicObject(g_FarmVGrassObjects[vehicleid][o]), g_FarmVGrassObjects[vehicleid][o] = 0;
			}
			g_FarmVehicleGrass[vehicleid] = 0;
		}
	#endif

	//--- ������ ����
	if(CarInfo[vehicleid][cID] > 0)
	{
		if(CarInfo[vehicleid][cX] == 0.0 && CarInfo[vehicleid][cY] == 0.0)
		{	// �����-�������
		    if(vehicleid == FineparkVehicle)
		    {	// FineparkTimer()
		        if(finepark_timer == 0)
		        {
					FineparkCount = 60;
					Finepark3DText = CreateDynamic3DTextLabel(" ", -1, 0.0, 0.0, 1.0, 15.0, INVALID_PLAYER_ID, vehicleid, 1, 0);
					finepark_timer = SetTimer("FineparkTimer", 1000, true);
					return 1;
				}
			    else
			    {
			        KillTimer(finepark_timer), finepark_timer = 0;
			        DestroyDynamic3DTextLabel(Finepark3DText), Finepark3DText = Text3D:INVALID_STREAMER_ID;
			        FineparkVehicle = 0;
			    }
		    }
		    new string[128];
			mysql_format(g_SQL, string, sizeof(string), "UPDATE `cars` SET `fine_park` = 1 WHERE `id` = '%d'", CarInfo[vehicleid][cID]);
			mysql_query_ex(string);
		    MyDestroyVehicle(vehicleid);// � �����
		    return 1;
		}
		else MySetVehiclePos(vehicleid, CarInfo[vehicleid][cX], CarInfo[vehicleid][cY], CarInfo[vehicleid][cZ], CarInfo[vehicleid][cA]);
	}
	//--- ���������� ������
	if(VehInfo[vehicleid][vLocked] != 999 && IsVehicleWithEngine(vehicleid) && VehInfo[vehicleid][vModelType] != MTYPE_NODOOR && VehInfo[vehicleid][vModelType] != MTYPE_MOTO)
	{
	    if(CarInfo[vehicleid][cType] == C_TYPE_PLAYER || (CarInfo[vehicleid][cType] == C_TYPE_DEFAULT && CarInfo[vehicleid][cOwnerID] == INVALID_PLAYER_ID))
	    {
			VehInfo[vehicleid][vLocked] = 1;
			UpdateVehicleParamsEx(vehicleid);
		}
	}

	#if defined	_job_part_delivery_included
		if(DeliveryVehLoadCount[vehicleid] > 0)
		{
			Delivery_Unload(vehicleid);
		}
	#endif

	// ������ ����������, ��������
	if(vehicleid == TruthCar)
		ChangeVehiclePaintjob(TruthCar, 0);
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	if(CarInfo[vehicleid][cID] != -1)
	{
		Inv.DeleteThing(CarInfo[vehicleid][cID], TAB_VEHICLE_TRUNK);
	}

	if(VehParams[GetVehicleModel(vehicleid) - 400][VEH_MTYPE] == MTYPE_HELIC)
	{
		foreach(LoginPlayer, i)
	    {
			if(GetPVarInt(i, "Roped") == vehicleid)
			{
				MyDisablePlayerCheckpoint(i);
				DeletePVar(i, "Roped");
				ClearAnimations(i);
				TogglePlayerControllable(i, true);
				for(new z = 0; z < ROPE_LENGTH; z++)
					DestroyDynamicObject(RopeObjects[i][z]);
			}
		}
	}
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	if(!gInModShop[playerid])
	{
		new string[128];
		format(string, 128, "[AdmWrn]: ���������� %s[%d] � ����������� ������� ����", ReturnPlayerName(playerid), playerid);
		SendAdminMessage(COLOR_LIGHTRED, string);
		return RemoveVehicleComponent(vehicleid, componentid);
	}
	switch(GetVehicleComponentType(componentid))
	{
		case CARMODTYPE_SPOILER: 		CarInfo[vehicleid][cSpoiler] = componentid;
		case CARMODTYPE_HOOD: 			CarInfo[vehicleid][cHood] = componentid;
		case CARMODTYPE_ROOF: 			CarInfo[vehicleid][cRoof] = componentid;
		case CARMODTYPE_SIDESKIRT: 		CarInfo[vehicleid][cSideskirt] = componentid;
		case CARMODTYPE_LAMPS: 			CarInfo[vehicleid][cLamps] = componentid;
		case CARMODTYPE_NITRO: 			CarInfo[vehicleid][cNitro] = componentid;
		case CARMODTYPE_EXHAUST: 		CarInfo[vehicleid][cExhaust] = componentid;
		case CARMODTYPE_WHEELS: 		CarInfo[vehicleid][cWheels] = componentid;
		case CARMODTYPE_HYDRAULICS: 	CarInfo[vehicleid][cHydraulics] = componentid;
		case CARMODTYPE_FRONT_BUMPER: 	CarInfo[vehicleid][cFrontBumper] = componentid;
		case CARMODTYPE_REAR_BUMPER: 	CarInfo[vehicleid][cRearBumper] = componentid;
		case CARMODTYPE_VENT_RIGHT: 	CarInfo[vehicleid][cVentR] = componentid;
		case CARMODTYPE_VENT_LEFT: 		CarInfo[vehicleid][cVentL] = componentid;
	}
	return true;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	if(!gInModShop[playerid])
	{
		AC_PlayerMessage(playerid, "������������� � ����.���������� ����");
	}
	CarInfo[vehicleid][cPaintJob] = paintjobid;
	UpdateVehicleStatics(vehicleid);
	return true;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	if(!gInModShop[playerid] && GetPVarInt(playerid, "AC:ChangePos:GTC") == 0)
	{
		if(!GetPlayerInterior(playerid))
		{
			new Float:pos[3];
			GetVehiclePos(vehicleid, Arr3<pos>);
			MySetPlayerPos(playerid, pos[0], pos[1], pos[2] + 1.0);
		}
		return AC_PlayerMessage(playerid, "������������� � ���������� ����");
	}
	MyChangeVehicleColor(vehicleid, color1, color2);
	UpdateVehicleStatics(vehicleid);
	return true;
}

Public: OnEnterPaynspray(playerid, vehicleid)
{
	MyChangeVehicleColor(vehicleid, CarInfo[vehicleid][cColor1], CarInfo[vehicleid][cColor2]);
    return 1;
}

public OnEnterExitModShop(playerid, enterexit, interiorid)
{
    SetPVarInt(playerid, "AC:ChangePos:GTC", GetTickCount());
	if(enterexit == 1)
	{
		gInModShop[playerid] = 1;
		switch(interiorid)
		{
		    case 1:
		    {// Transfender
		        OldPlayerPos[playerid][0] = 617.5303;
				OldPlayerPos[playerid][1] = -1.9892;
				OldPlayerPos[playerid][2] = 1000.5622;
		    }
		    case 2:
		    {// Lowrider
		        OldPlayerPos[playerid][0] = 616.7833;
				OldPlayerPos[playerid][1] = -74.8150;
				OldPlayerPos[playerid][2] = 997.8661;
		    }
		    case 3:
		    {// Wheel Arch Angels
		        OldPlayerPos[playerid][0] = 615.2839;
				OldPlayerPos[playerid][1] = -124.2390;
				OldPlayerPos[playerid][2] = 997.5825;
		    }
		}
		MyGetPlayerPos(playerid, Arr3<gInModShopPos[playerid]>);
	}
	else
	{
		gInModShop[playerid] = 0;
		new vehicleid = GetPlayerVehicleID(playerid);
		if(vehicleid > 0 && CarInfo[vehicleid][cID] > 0)
		{
			UpdateVehicleStatics(vehicleid);
			SendClientMessage(playerid, COLOR_GREEN, "[VEHICLE]: ������ ��� ������� ��������");
		}
        OldPlayerPos[playerid][0] = gInModShopPos[playerid][0];
		OldPlayerPos[playerid][1] = gInModShopPos[playerid][1];
		OldPlayerPos[playerid][2] = gInModShopPos[playerid][2];
	}
    /*if(enterexit)
    {
		new string[128];
		format(string, 128, "[AdmWrn]: ���������� %s[%d] � ����������� ������ � ������", ReturnPlayerName(playerid), playerid);
		SendAdminMessage(COLOR_LIGHTRED, string);
    }*/
    return 1;
}

//------
public OnPlayerText(playerid, text[])
{
	if(IsPlayerLogged(playerid) == 0)
	{
	    return false;
	}
	if((gBlockAction[playerid] >> 2 & 1))
	{
		return false;
	}

	//--- ��������
	new tick = GetTickCount();
	if(tick - StartupAntiflood[playerid] < 800)
	{
	    StartupAntiflood[playerid] = tick;
	    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��� ������.");
	    return false;
	}
	StartupAntiflood[playerid] = tick;

	new string[164];
	// �������� �� ��������
	if(PlayerInfo[playerid][pMuteTime] > 0)
	{
	    SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "�� �������� � ����, ��������: %d ���.", PlayerInfo[playerid][pMuteTime]);
	    if(!random(2)) SetPlayerChatBubble(playerid, "�������� ���-�� �������...", COLOR_LIGHTRED, 20.0, 5000);
	    else		   SetPlayerChatBubble(playerid, "�����...", COLOR_LIGHTRED, 20.0, 5000);
	    return false;
	}
	
	// ���� ���� � ����
	if(ChatGameTick && !strcmp(ChatGameRes, text, true))
	{
	    if(GetTickCount() - ChatGameTick < 800)
		{
			GivePlayerWarn(-1, playerid, "��������� � ���-������");
			return false;
		}
	    new Float:time = float(GetTickCount() - ChatGameTick - GetPlayerPing(playerid)) / 1000;
	    new money = 60 + random(31) - floatround(1.2 * time);
	    //
	    SendFormatMessageToAll(COLOR_WHITE, string, PREFIX_GAME "%s ��� ���������� ����� '{33AA33}%s{FFFFFF}' �� %0.3f ��� � ������� $%d.", ReturnPlayerName(playerid), ChatGameRes, time, money);
	#if defined _player_achieve_included
	    if(time <= 2.0)
	    {
	    	GivePlayerAchieve(playerid, ACHIEVE_METEOR);	//	���������� '������'
	    }
	#endif
	    //
	    MyGivePlayerMoney(playerid, money);
	    KillTimer(ChatGameTimer);
		ChatGameTick = 0;
		return false;
	}

	// �������� � ����
	if(strlen(text) == 2)
	{
		for(new x = 0; x < sizeof Smiles; x++)
		{
		    if(strcmp(text, Smiles[x][0], true) == 0)
		    {
				PlayerAction(playerid, Smiles[x][1]);
		        return false;
		    }
		}
	}

	// Binds
	if(SendBindMessage(playerid, text))
	{
		return false;
	}

	/*switch(text[0])
	{	//	return false - ����������� (����� � ����� ��� ���� �������), true - ���������
	    case '!':
	    {
	    	callcmd::s(playerid, text[1]);	// ���������� �����
	    	return false;
	    }
	    case '*':
	    {
	    	callcmd::o(playerid, text[1]);	// ����� ���
	    	return false;
	    }
	    case '@', '"':
	    {
	    	if(GetPlayerAdmin(playerid) > 0)
	    	{
	    		format(string, 128, "@ | %s %s[%d]: %s", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, text[1]);
				SendAdminMessage(COLOR_ADMIN, string, 1);
				return false;
	    	}
	    }
	    case '#','�':
	    {	// ��������� ���
	    	if(IsGover(PlayerInfo[playerid][pFaction]))
	    	{
	    		callcmd::r(playerid, text[1]);
    			return false;
    		}
    		else
    		{
    			callcmd::f(playerid, text[1]);
    			return false;
    		}
	    }
	}*/
	//	�������� �� �����
	if(TalkingLive[playerid] != INVALID_PLAYER_ID)
	{
		SendFormatMessageToAll(COLOR_LIGHTGREEN, string, "[������ ����] %s: %s", ReturnPlayerName(playerid), text);
		return false;
	}

	SendLocalMessage(playerid, -1, text);	// ��������� ���
	if(GetPVarInt(playerid, "Player:Call911") == 1)
	{
		if(strfind(text, "�����", true) != -1)
		{
			new bool:find;
			foreach(LoginPlayer, p)
			{
				if(IsPoliceDuty(p))
				{
					find = true;
					break;
				}
			}
			//	�������� �������
			if(find)
			{
				SendClientMessage(playerid, COLOR_BLUE, "�������� 911 �������: ������, ��� ����� �������, ������� ���������� ���� ���������� �����������.");

				SetPVarInt(playerid, "Player:Service:Police", 1);
				format(string, sizeof(string), "[R] ��������� HQ: {FFFFFF}%s[%d]{8D8DFF} �������� ������� {FFFFFF}(������� /acceptcall ����� ������� �����)", ReturnPlayerName(playerid), playerid);
				SendPoliceMessage(COLOR_BLUE, string);
			}
			else
			{
				SendClientMessage(playerid, COLOR_BLUE, "�������� 911 �������: � ���������, ������ ��� �� ������ ������������ �� ���������.");
			}

			DeletePVar(playerid, "Player:Call911");
		}
		else if(strfind(text, "����", true) != -1 || strfind(text, "������", true) != -1 || strfind(text, "����", true) != -1)
		{
			//	�������� �������
			new bool:find;
			foreach(LoginPlayer, p)
			{
				if(GetPVarInt(p, "Player:EmergyDuty"))
				{
					find = true;
					break;
				}
			}

			if(find)
			{
				SendClientMessage(playerid, COLOR_BLUE, "�������� 911 �������: ������, ��� ����� ������, ������� ��� ����� ����������� ������.");
			
				SetPVarInt(playerid, "Player:Service:Medic", 1);
				format(string, sizeof(string), "[R] ��������� HQ: {FFFFFF}%s[%d]{AA3333} �������� ������ ������ {FFFFFF}(������� /acceptcall ����� ������� �����)", ReturnPlayerName(playerid), playerid);
				SendFactionMessage(F_EMERGY, COLOR_RED, string);
			}
			else
			{
				SendClientMessage(playerid, COLOR_BLUE, "�������� 911 �������: � ���������, ������ ��� �� ������ ������ �� ���������.");
			}
			
			DeletePVar(playerid, "Player:Call911");
		}
		else
		{
			SendClientMessage(playerid, COLOR_BLUE, "�������� 911 �������: � �� ������� ��� �� ��������, ������� ��� ��� �����: ������� ��� ������?");
		}
	}
	//printf("[chat] %s", string);
	return false;
}

stock StopEnterVehicle(playerid, bool:push = false)
{
	new Float:pos[3];
	GetPlayerPos(playerid, Arr3<pos>);
	if(push) SetPlayerPos(playerid, pos[0] + 2.0, pos[1] + 2.0, pos[2]);
	else SetPlayerPos(playerid, Arr3<pos>);
	gEnteringVehicle[playerid] = 0;
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	OldSpeed[playerid] = 0;
	gEnteringVehicle[playerid] = GetTickCount();

	// ������� ����� � ��������� �������� (������)
	/*new Float:MyPos[4], Float:CarPos[3], Float:Dist;
	MyGetPlayerPos(playerid, Arr4<MyPos>);
	GetVehiclePos(vehicleid, Arr3<CarPos>);
	Dist = GetDistanceFromPointToPoint(Arr3<MyPos>, Arr3<CarPos>);
	if(Dist > 15.0)
	{
	    new string[128];
		format(string, sizeof(string), "[AdmWrn]: %s[%d] ��������� ����� � ������ (#%d) � �������� ���������� (%.1f �.)", ReturnPlayerName(playerid), playerid, vehicleid, Dist);
		SendAdminMessage(COLOR_LIGHTRED, string);
		MySetPlayerPos(playerid, Arr4<MyPos>);
		return 1;
	}*/

	// ������� ����� � ��������� � ����������
	if(PlayerCuffedTime[playerid])
	{
		ApplyAnimation(playerid, "CRACK", "crckdeth4", 4.0, 0, 1, 1, 1, 0);
		return StopEnterVehicle(playerid);
	}

	// ������� ����� � �������� ���������
	if(VehInfo[vehicleid][vLocked] == 999
		|| (CarInfo[vehicleid][cType] == C_TYPE_DEFAULT && 0 <= CarInfo[vehicleid][cOwnerID] < INVALID_PLAYER_ID && CarInfo[vehicleid][cOwnerID] != playerid)
		|| (IsVehicleWithEngine(vehicleid) && VehInfo[vehicleid][vLocked] == 1 && ispassenger == 0))
	{
		GameTextForPlayer(playerid, RusText("~r~������ �������!", PlayerInfo[playerid][pRusifik]), 3000, 4);
		return StopEnterVehicle(playerid);
	}

	// ������� ����� � ������� ������ � ������
	else if(BusVehicle[0] <= vehicleid <= BusVehicle[2] && GetPlayerPursuit(playerid))
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������ �� ������������ ���������� �� ����� ������.");
		return StopEnterVehicle(playerid);
	}

	// ������� ����� �� ���� ����������� ������
	if(!ispassenger && !IsAvailableVehicle(vehicleid, playerid))
	{
	    new string[128];
		if(CarInfo[vehicleid][cType] == C_TYPE_FACTION)
		{
			SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "���� ��������� ����������� ������� %s.", GetFactionName(CarInfo[vehicleid][cOwnerID]));
			return StopEnterVehicle(playerid);
		}
		else if(CarInfo[vehicleid][cType] == C_TYPE_JOB)
		{
			SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "���� ��������� ����������� ������ %s.", GetJobName(CarInfo[vehicleid][cOwnerID]));
			return StopEnterVehicle(playerid);
		}
		else if(CarInfo[vehicleid][cType] == C_TYPE_PARTJOB)
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ��������� �������� ������ �������.");
			return StopEnterVehicle(playerid);
		}
	}

	// �������� ��� �������
	if(GetVehicleModel(vehicleid) == 548)
	{
	    if(PlayerInfo[playerid][pFaction] != F_ARMY)
	    {
	        new string[128];
		    SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "���� ��������� ����������� ������� %s.", GetFactionName(F_ARMY));
	        return StopEnterVehicle(playerid);
	    }
	    if(ispassenger)
	    {
			MySetPlayerPos(playerid, 315.9227,973.8602,1961.4672,360.0);
			SetPlayerVirtualWorld(playerid, vehicleid);
			SetPlayerInterior(playerid, 9);
			SetCameraBehindPlayer(playerid);

			MyGivePlayerWeapon(playerid, 46, 1);
			PlayerBusy{playerid} = true;
		}
	}
	return true;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	// ����� �� �����
	if(InRace[playerid])
	{
		RaceLeave(playerid);
		GameTextForPlayer(playerid, RusText("~r~����� ���������~n~~w~������� ���������", isRus(playerid)), 3000, 4);
	}
	return true;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	new string[128], vehicleid = GetPlayerVehicleID(playerid);

	#if defined	_job_job_theft_included
		Callback: Theft_OnPlayerStateChange(playerid, newstate, oldstate);
	#endif
	#if defined	_job_job_taxi_included
		Callback: Taxi_OnPlayerStateChange(playerid, newstate, oldstate);
	#endif

	//---	spawn
	if(oldstate == PLAYER_STATE_SPAWNED && PLAYER_STATE_ONFOOT <= newstate <= PLAYER_STATE_PASSENGER)
	{
		OnPlayerSpawnFinish(playerid);
	}
	// �������� ����
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
		if(Anticheat.GetToggle())
		{
			if(oldstate != PLAYER_STATE_ONFOOT && SpectateID[playerid] == INVALID_PLAYER_ID)
		    {
				format(string, sizeof(string), "[AdmWrn]: %s[%d] ������ � ���������� �� ��� AutoDriver", ReturnPlayerName(playerid), playerid);
				SendAdminMessage(COLOR_LIGHTRED, string);
			    UpdateVehInfo();
			    return 1;
		    }
		    if(gEnteringVehicle[playerid] != -1 && VehInfo[vehicleid][vModelType] != MTYPE_BOAT && VehInfo[vehicleid][vModelType] != MTYPE_TRAIN)
		    {
			    new const diftime = GetTickCount() - gEnteringVehicle[playerid];
			    if(diftime < 500)
			    {
					//StopEnterVehicle(playerid, true);
					format(string, sizeof(string), "��������� ����������� (%d ��) ����� � ������ (#%d)", diftime, vehicleid);
					AC_PlayerMessage(playerid, string);
					return 1;
			    }
			    else if(diftime > 10000)
			    {	// EnterVehicle �� ����������
					StopEnterVehicle(playerid, true);
					//format(string, sizeof(string), "��������� ����������� ����� � ������ (#%d)", vehicleid);
					//AC_PlayerMessage(playerid, string);
					return 1;
			    }
		    }
		    if(VehInfo[vehicleid][vLocked] == 999)
		    {
				if(VehInfo[vehicleid][vModelType] != MTYPE_TRAIN)
				{
					StopEnterVehicle(playerid, true);
					format(string, sizeof(string), "[AdmWrn]: %s[%d] ���������� ��� � ��������������� ������ (#%d)", ReturnPlayerName(playerid), playerid, vehicleid);
					SendAdminMessage(COLOR_LIGHTRED, string);
				}
				return 1;
		    }
		}
		//---	���� ������� �������� - �������� �.�. ���-�� ���
		if(VehInfo[vehicleid][vRespawnTime])	VehInfo[vehicleid][vRespawnTime] = 0;
	    //---
	    gEnteringVehicle[playerid] = 0;
	    gLastVehicle[playerid] = vehicleid;
		PlayerVehicle[playerid] = vehicleid;
		VehInfo[vehicleid][vPlayers]++;
		new radio = VehInfo[vehicleid][vRadio];
		new seat = GetPlayerVehicleSeat(playerid);
		if(seat == 0)		VehInfo[vehicleid][vDriver] = playerid;
		else if(seat == 1)	VehInfo[vehicleid][vCoDriver] = playerid;
		else if(seat == 2)	VehInfo[vehicleid][vLeftSeat] = playerid;
		else if(seat == 3)	VehInfo[vehicleid][vRightSeat] = playerid;
		if(radio > 0 && GetPVarInt(playerid, "Thing:RadioID") == 0)
		{
			PlayAudioStreamForPlayer(playerid, RadioList[radio - 1][RADIO_URL]);
			PlayerPlaySound(playerid, 1069, 0.0, 0.0, 0.0);// Fix
		}
		//if(VehInfo[vehicleid][vSiren])	UpdatePlayerColor(playerid);

		//---	Spectate
		foreach(Spectators, i)
		{
			if(SpectateID[i] == playerid) UpdatePlayerSpectate(i, SpectateID[i]);
		}

	}
	else
	{
		if(PlayerVehicle[playerid])
		{
			ExitVehicle(playerid);
			#if defined	_job_part_farmer_included
				KillTimer(g_FarmSpeedLimiter[playerid]);
			#endif	
		}

		//---	Spectate
		foreach(Spectators, i)
		{
			if(SpectateID[i] == playerid) UpdatePlayerSpectate(i, SpectateID[i]);
		}
	}

	///////////////////////////////////

    if(newstate == PLAYER_STATE_ONFOOT)
	{
		if(oldstate == PLAYER_STATE_DRIVER)
		{
		    // ����� � �������
		    if(gInModShop[playerid])
		    {
		        MyPutPlayerInVehicle(playerid, gLastVehicle[playerid], 0);
				return 1;
		    }

			//	���������
		    if(AS_ElementNumber[playerid])
		    {
		    	GameTextForPlayer(playerid, RusText("~r~Mission Failed~n~~w~���������� �������", isRus(playerid)), 5000, 4);
		    	AS_ReturnInAS(playerid);
			}

			//	����������
		#if defined	_job_part_delivery_included
			Delivery_StartUnload(playerid, oldstate);
		#endif

		#if defined	_job_job_busdriver_included
			// ������ ��������� ��������
			if(BusDriverStatus[playerid] > 0 && gLastVehicle[playerid] == BusDriverVeh[playerid])
			{
			    BusDriverLeave[playerid] = 45;
			}
		#endif
		#if defined	_job_job_trucker_included	
		    // ������ �������������
		    if(TruckerStatus[playerid] == 1 && gLastVehicle[playerid] == TruckerVeh[playerid])
		    {
		        TruckerStatus[playerid] = 2;
		        TruckerLeave[playerid] = 90;
		    }
		#endif

		#if defined	_job_job_theft_included
		    // ������ ������������
		    if(TheftStatus[playerid] == 2 && gLastVehicle[playerid] == TheftVehicle[playerid])
		    {
				TheftTimeOut[playerid] = 60;
		    }
		#endif
	        IFace.ToggleGroup(playerid, IFace.SPEEDO, false);
		}
	    gEnteringVehicle[playerid] = 0;
	}
	else if(newstate == PLAYER_STATE_DRIVER)
	{
		if(CarInfo[vehicleid][cType] == C_TYPE_FACTION
		|| CarInfo[vehicleid][cType] == C_TYPE_JOB
		|| CarInfo[vehicleid][cType] == C_TYPE_PARTJOB)
		{
			if(!IsAvailableVehicle(vehicleid, playerid))
			{
				return StopEnterVehicle(playerid, true);
			}
		}
	    SetPlayerArmedWeapon(playerid, 0);	// ������� ���� DriveBy
	    OldSpeed[playerid] = 0;
		if(IsVehicleWithEngine(vehicleid) == false)
		{	// ��������� ����������
			SetVehicleEngine(vehicleid, true);
		}
		else if(GetVehicleEngine(vehicleid))
		{
			IFace.ToggleGroup(playerid, IFace.SPEEDO, true);	
		}
		// ������ ������ �� ����������
		#if defined	_job_part_loader_included
	    	if(IsPlayerInDynamicArea(playerid, LoaderInfo[LE_AREAID]))
	    	{
				MySetVehiclePos(vehicleid, 2185.4512,-2261.8936,12.9963, 225.0);
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_WARNING "���� ��������� �������� �� ����������");
				SetCameraBehindPlayer(playerid);
	    	}
    	#endif
		// ��������� ��� ������ ���������
	    if(GetVehicleEngine(vehicleid) == false)
	    {
	    	ShowPlayerHint(playerid, "������� � ����������� ~g~Space~w~ ��� ~g~L.Shift~w~, ����� ������� ���������");
	    	ShowPlayerHint(playerid, "��� ��������� ��� ������� ~g~Ctrl");
	        //SendClientMessage(playerid, COLOR_WHITE, PREFIX_HINT "������� � ����������� "SCOLOR_HINT"Space"SCOLOR_WHITE" ��� "SCOLOR_HINT"L.Shift"SCOLOR_WHITE", ����� ������� ���������.");
	    	//SendClientMessage(playerid, COLOR_WHITE, PREFIX_HINT "��� ��������� ��� ������� "SCOLOR_HINT"Ctrl"SCOLOR_WHITE".");
	    }
		//	���� ������ ������� ������
		if(VehInfo[vehicleid][vRentPrice] > 0 && !VehInfo[vehicleid][vRentOwner])
		{
			TogglePlayerControllable(playerid, false);
			return ShowDialog(playerid, DMODE_RENTCAR);
		}
		// ������ ��������� �������
		if(CarInfo[vehicleid][cID] > 0 && CarInfo[vehicleid][cType] == C_TYPE_PLAYER)
		{
            if(CarInfo[vehicleid][cOwnerID] == PlayerInfo[playerid][pUserID])
            {
			    if(CarInfo[vehicleid][cX] == 0.0 && CarInfo[vehicleid][cY] == 0.0)
			    {
					ShowPlayerHint(playerid, "����������� ���������~n~�������� ~y~/veh park");
			    }
				GameTextForPlayer(playerid, RusText("~g~��� ���������", isRus(playerid)), 3000, 4);
			}
            else GameTextForPlayer(playerid, RusText("~r~����� ���������", isRus(playerid)), 3000, 4);
		}
		// ����������� ������
		else if(CarInfo[vehicleid][cType] == C_TYPE_FACTION)
		{
		    if(CarInfo[vehicleid][cRank] > PlayerInfo[playerid][pRank])
		    {
			    SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "���� ���������� ������� ����: %s (%d).", GetRankName(CarInfo[vehicleid][cOwnerID], CarInfo[vehicleid][cRank]), CarInfo[vehicleid][cRank]);
		        return RemovePlayerFromVehicle(playerid);
		    }
			new model = GetVehicleModel(vehicleid);
		    switch(CarInfo[vehicleid][cOwnerID])
		    {
		        case F_POLICE:
		        {
					if(PM_Type[playerid] == 0)
					{
			   			ShowPlayerHint(playerid, "~w~������� ~y~~k~~TOGGLE_SUBMISSIONS~ ~w~��� ��������� ����������� �� ��������", 5000);
					}
		        }
		        case F_ARMY:
		        {
		            if(model == 548)
		            {	// �������� ��� �������
						ShowPlayerHint(playerid, "������� ~y~~k~~TOGGLE_SUBMISSIONS~~w~, ����� ��������� �������� ����� ��� �������");
						if(VehInfo[vehicleid][vTrapState])	SendMissionMessage(playerid, "~b~�������� ���: ~w~������");
						else								SendMissionMessage(playerid, "~b~�������� ���: ~w~������");
		            }
		        }
		    }
		}
		//	������� ������
		else if(CarInfo[vehicleid][cType] == C_TYPE_JOB)
		{
		    switch(CarInfo[vehicleid][cOwnerID])
		    {	
		    	// ������ ��������� ���������
		    	#if defined	_job_job_busdriver_included
			    	case JOB_BUSDRIVER:
			    	{
			    		if(BusDriverStatus[playerid] > 0)
					    {
					        if(BusDriverVeh[playerid] == vehicleid)
					        {
					            if(BusDriverStatus[playerid] == 1) Dialog_Show(playerid, Dialog:BusDriver_Route);

								HideMissionMessage(playerid);
								BusDriverLeave[playerid] = 0;
								return ShowPlayerHint(playerid, "������� ~y~~k~~TOGGLE_SUBMISSIONS~ ~w~����� ��������� ������ � �������� ������", 10000);
					        }
					        else
					        {
							    SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "�� ��� ��������� ������ �������.");
							    return RemovePlayerFromVehicle(playerid);
					        }
					    }
			    	}
		    	#endif
		    	// ������ �������������
		    	#if defined	_job_job_trucker_included
			    	case JOB_TRUCKER:
			    	{
					    if(TruckerStatus[playerid] == 2 && vehicleid == TruckerVeh[playerid])
					    {	// ��� � ���������� �����
					        TruckerStatus[playerid] = 1;
					        TruckerLeave[playerid] = 0;
							HideMissionMessage(playerid);
							return 1;
					    }
			    	}
			    #endif	
		    }
		}
		//	����������
		else if(CarInfo[vehicleid][cType] == C_TYPE_PARTJOB)
		{
			switch(CarInfo[vehicleid][cOwnerID])
		    {
		    	#if defined	_job_part_farmer_included
			    	case PART_FARMER:
			    	{
		    		 	new model = GetVehicleModel(vehicleid);
						if(model == 531 || model == 532)
						{
							//  ����������� �������� �� ��������� � ��������� ����
							g_FarmSpeedLimiter[playerid] = SetPlayerTimerEx(playerid, "FarmSpeedVehicleLimit", 100, 1, "df", playerid, 20.0);
						}
						else if(model == 478)
						{
		                    ShowPlayerHint(playerid, "~w~��� ��������/��������� ������ ���������� ������� ����� (������ ~y~2~w~)", 5000);
						}
			    	}
		    	#endif

		    	#if defined	_job_part_delivery_included
			    	case PART_DELIVERY:
			    	{
			    		// ������ �����������
						if(DeliveryVehLoadCount[vehicleid] > 0)
				    	{
							IFace.ShowPlayerProgress(playerid,
								DeliveryVehLoadDamage[vehicleid], 100,
								isRus(playerid) ? RusText("�����") : "Damage");
				    	}
			    	}
		    	#endif
		    }
		}

		// ���������� ����������
		if(IsAvailableVehicle(vehicleid, playerid) < VEH_AVAILABLE_CONTROL)
		{
			SendClientMessage(playerid, COLOR_YELLOW, "� ��� ��� ���������� �� ��� ������ - ����� ���� �������� � ��������!");
		}
		// ��������� � ����������, �� ������ ��������� � �� ��������
		if(IsVehicleWithEngine(vehicleid) && VehInfo[vehicleid][vModelType] != MTYPE_NODOOR)
		{
		    // ���������� ��������
		    if(!IsPlayerHaveLicThisVehicle(playerid, GetVehicleModel(vehicleid)))
		    {
		    	SendClientMessage(playerid, COLOR_YELLOW, "� ��� ����� ���� �������� � �������� ��-�� ���������� ���� �� �������� ����� ����������!");
		    }
			//if(PlayerInfo[playerid][pCarLic] == 0 && AS_ElementNumber[playerid] == 0)
			//{
			//	SendClientMessage(playerid, COLOR_YELLOW, "� ��� ����� ���� �������� � �������� ��-�� ���������� �������� �� ��������!");
			//}
		}
	}
	else if(newstate == PLAYER_STATE_PASSENGER)
	{
		RearmedPlayerWeapon(playerid);	// ������� ���� DriveBy

		new driverid = VehInfo[vehicleid][vDriver];
		// ��������� �����������
		if(CarInfo[vehicleid][cType] == C_TYPE_JOB)
		{
			// ������ ��������� ��������
			#if defined	_job_job_busdriver_included
				if(CarInfo[vehicleid][cOwnerID] == JOB_BUSDRIVER && driverid != -1)
				{
				    if(MyGetPlayerMoney(playerid) < BusDriverPrice[driverid])
				    {
				        PlayerAction(playerid, "���������� ��������� ��������.");
				    }
				    else
				    {
					    MyGivePlayerMoney(playerid, -BusDriverPrice[driverid]);
					    MyGivePlayerMoney(driverid, BusDriverPrice[driverid]);
				    }
				}
			#endif
		}
		//	������
		if(mission_id[playerid] == MIS_HOTEL && mission_step[playerid] == 1)
		{
			if(BusVehicle[0] <= vehicleid <= BusVehicle[3])
			{
				mission_step[playerid]++;
				mission_cpnum[playerid] = MySetPlayerCheckpoint(playerid, CPMODE_MISSION, 2232.9, -1159.8, 25.9, 2.0);
				if(!isRus(playerid))
				{
					MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "�������",
						"{FFFFFF}���������� �� ����� � ����������� � ���", "�������", "", 0);
				}
				else
				{
					SendMissionMessage(playerid, "���������� �� ����� � ����������� � ���", 5000, true);
				}
			}
		}
	}
	else if(newstate == PLAYER_STATE_SPECTATING)
	{
		IFace.ToggleGroup(playerid, IFace.INTERFACE, false);
	}
	else if(oldstate == PLAYER_STATE_SPECTATING)
	{
		if(!FirstSpawn[playerid])
		{
			IFace.ToggleGroup(playerid, IFace.INTERFACE, PlayerInfo[playerid][pInterface]);
		}
	}
	return true;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(IsPlayerNPC(playerid))
		return (1);
	if (SpectateID[playerid] != INVALID_PLAYER_ID)
		return (1);

	#if defined	_job_job_theft_included
		Callback: Theft_OnPlayerEnterDynamicArea(playerid, areaid);
	#endif
	#if defined	_job_part_farmer_included
		Callback: Farmer_OnPlayerEnterDynamicArea(playerid, areaid);
	#endif
	#if defined	_job_part_loader_included
		Callback: Loader_OnPlayerEnterDynamicArea(playerid, areaid);
	#endif

	new string[128];
	new pState = GetPlayerState(playerid);
	if(areaid == TrainingZone[0])
	{
		if(gMissionProgress[playerid][MIS_SOURCE_TRAINING] == 1)
		{
			if(mission_step[playerid] == 0)
			{
				ApplyActorAnimation(ACTOR[A_NEWBIE], "ON_LOOKERS", "wave_loop", 4.0, 0, 0, 0, 0, 0);
				SendFormatMessage(playerid, COLOR_WHITE, string, "- %s ������: ��, ������! � %s, ��� ����, ���� ����..", ActorInfo[A_NEWBIE][a_Name], ActorInfo[A_NEWBIE][a_Name]);
				StoryMissionStart(playerid, MIS_SOURCE_TRAINING);
			}
		}
	}
	else if(areaid == gps_Data[playerid][GPS_CP])
	{	//	GPS
		HidePlayerGPSPoint(playerid);
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "��������� ����� ����������");
	}
	else if(areaid == RaceZone)
	{
		if(pState == PLAYER_STATE_ONFOOT && !InRace[playerid])
		{
			if(RaceInfo[rStatus] == 0)
			{
				ShowPlayerHint(playerid, "� ������ ������ ����� �� ��������, ��������� �����!");
			}
	    	else if(RaceInfo[rStatus] == 1)
			{	// ������� ������� �������
			    TogglePlayerControllable(playerid, false);
			    ShowDialog(playerid, DRACE_JOIN);
			}
			else
			{
				ShowPlayerHint(playerid, "����� ��� ��������, ��������� �����!");
			}
		}
	}

#if defined	_job_part_delivery_included
    else if(areaid == DeliveryLoadZone)
    {
    	Dialog_Show(playerid, Dialog:Delivery_Load);
    }
#endif

    //	Airport
    else if(areaid == AirportZone[0])
    {
    	if(NearAirportDoorPlayers == 0)
    	{
    		SetPVarInt(playerid, "Player:NearAirportDoor", 1);
    		MoveDynamicObject(AirportDoor[0], 1682.80, -2335.98, 12.56, 1.5);
    		MoveDynamicObject(AirportDoor[1], 1688.77, -2335.94, 12.56, 1.5);
    	}
    	NearAirportDoorPlayers++;
    }
    else if(areaid == AirportZone[1])
    {
    	MySetPlayerPosFade(playerid, FT_NONE, 1685.67, -2332.31, 13.55);
    }
    else if(areaid == AirportZone[2])
    {
    	if(GetPVarInt(playerid, "RegCutSceneState") == 0)
    	{
    		PlayAudioStreamForPlayer(playerid, AUDIOFILE_PATH "/airport.mp3");
    	}
    }

    //	Ammo Zones
    else if(AmmoZone[0] <= areaid <= AmmoZone[10])
    {
    	if(IsPoliceDuty(playerid))
    	{
    		SetPVarInt(playerid, "Player:InAmmoZone", areaid - AmmoZone[0]);
    		TextDrawShowForPlayer(playerid, TD_PressH);
    	}
    }
    else if(AmmoZone[11] <= areaid <= AmmoZone[ sizeof(AmmoZone) - 1 ])
    {
    	SetPVarInt(playerid, "Player:InAmmoZone", areaid - AmmoZone[0]);
		TextDrawShowForPlayer(playerid, TD_PressH);
    }

	else if(areaid == StripZone[0] || areaid == StripZone[1])
	{
		ShowPlayerHint(playerid, "������� ~y~Enter~w~ ����� ������ $50");
	}
	else if(areaid == PoliceGateZone)
	{
		if(pState == PLAYER_STATE_DRIVER && PlayerInfo[playerid][pFaction] == F_POLICE)
		{
			ShowPlayerHint(playerid, "����������� ~y~����� ~w~����� ������� ������");
		}
	}
	else if(GateInfoZone[0] <= areaid <= GateInfoZone[sizeof(GateInfoZone) - 1])
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			ShowPlayerHint(playerid, "����������� ~y~����� ~w~����� ������� ������");
		}
	}
	else if(areaid == PM_SearchZone2[playerid])
	{   // ����������� ������ - ���� ����
	    MyDisablePlayerCheckpoint(playerid);
	    DestroyDynamicArea(PM_SearchZone2[playerid]), PM_SearchZone2[playerid] = INVALID_STREAMER_ID;
		SendClientMessage(playerid, COLOR_BLUE, "[R] ��������� HQ: {FFFFFF}�� ���������� � ���� ���������� ��������� ����, ����������� ������");
	}
	else if(ATM_Zone[0] <= areaid <= ATM_Zone[ sizeof(ATM_Zone) - 1 ])
	{
		SetPlayerFacingAngle(playerid, ATM[ areaid - ATM_Zone[0] ][5] - 90.0);
		ShowDialog(playerid, DMODE_ATM);
	}
	else if(GetPVarInt(playerid, "Player:InGreenZone") == 0 && area_GreenZones[0] <= areaid <= area_GreenZones[sizeof(area_GreenZones) - 1])
	{	//  Check player in Green Zone
		SetPVarInt(playerid, "Player:InGreenZone", true);
		UpdatePlayerRadarColor(playerid);
	}
	return true;
}

public	OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if (IsPlayerNPC(playerid))
		return (1);
	if (SpectateID[playerid] != INVALID_PLAYER_ID)
		return (1);
    if(areaid == AirportZone[0])
    {
    	if(NearAirportDoorPlayers > 0)
    	{
    		NearAirportDoorPlayers--;
	    	if(NearAirportDoorPlayers == 0)
	    	{
	    		MyMoveDynamicObject(AirportDoor[0], 1684.27, -2335.98, 12.56, 1.5, -1000.0, -1000.0, -1000.0);
				MyMoveDynamicObject(AirportDoor[1], 1687.27, -2335.94, 12.56, 1.5, -1000.0, -1000.0, -1000.0);
	    	}
    	}
    	DeletePVar(playerid, "Player:NearAirportDoor");
    }

#if defined	_job_part_loader_included
    else if(areaid == LoaderInfo[LE_ZONE])
	{
		if(Job.GetPlayerNowWork(playerid) == PART_LOADER)
		{
			new v = GetPlayerVehicleID(playerid);
			if(v)	MySetVehiclePos(v, 2179.59, -2275.98, 13.22, 315.0);
			else 	MySetPlayerPos(playerid, 2187.02, -2263.53, 13.45, 45.0);
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_WARNING "����� ������ - ������� ��������� ������");
		}
	}
#endif

#if defined	_job_part_farmer_included
	else if(areaid == FarmZone)
	{
		if(Job.GetPlayerNowWork(playerid) == PART_FARMER)
		{
			new v = GetPlayerVehicleID(playerid);
			if(v)	MySetVehiclePos(v, -1050.24, -1194.91, 128.78, 180.0);
			else 	MySetPlayerPos(playerid, -1053.72, -1195.09, 129.05, 93.98);
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_WARNING "����� ������ - ������� ��������� ������");
		}
	}
#endif

    else if(areaid == AirportZone[2])
    {
	    StopAudioStreamForPlayer(playerid);
    }
    else if(area_GreenZones[0] <= areaid <= area_GreenZones[sizeof(GreenZones) - 1])
    {
	    if(GetPVarInt(playerid, "Player:InGreenZone"))
	    {
	    	new bool:in_gz = false;
	    	for(new z = 0; z < sizeof(area_GreenZones); z++)
	    	{
	    		if(IsPlayerInDynamicArea(playerid, area_GreenZones[z]))
	    		{
	    			in_gz = true;
	    			break;
	    		}
	    	}
	    	if(in_gz == false)
	    	{
	    		DeletePVar(playerid, "Player:InGreenZone");
	    		UpdatePlayerRadarColor(playerid);
	    	}
    	}
	}

	else if(AmmoZone[0] <= areaid <= AmmoZone[ sizeof(AmmoZone) - 1 ])
    {
    	if(!GetPVarInt(playerid, "Player:HintPressH"))
    	{
    		TextDrawHideForPlayer(playerid, TD_PressH);
    	}
    	DeletePVar(playerid, "Player:InAmmoZone");
    }
	return true;
}

// public OnPlayerEnterRaceCheckpoint(playerid)
public OnPlayerEnterDynamicRaceCP(playerid, checkpointid)
{
	if(IsPlayerNPC(playerid) || SpectateID[playerid] != INVALID_PLAYER_ID)
	{
		return true;
	}

	#if defined	_job_job_busdriver_included
		Callback: BusDriver_OnPlayerEnterDRaceCP(playerid, checkpointid);
	#endif

	return 1;
}

// public OnPlayerEnterCheckpoint(playerid)
public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	if(IsPlayerNPC(playerid) || SpectateID[playerid] != INVALID_PLAYER_ID)
	{
		return true;
	}
	new string[128];
	if(showDebug[playerid])
	{
		SendFormatMessage(playerid, -1, string, "checkpointid = %d, gCheckpoint = %d", checkpointid, gCheckpoint[playerid]);
	}

	// OnPlayerEnterCheckpoint(playerid) // OnPlayerEnterDynamicCP(playerid, checkpointid)
	//------------------------[������ ���������]--------------------------------
	if(checkpointid == gCheckpoint[playerid])
	{
		//	���� �� ������� �� ����� ������� - return true, ���� ��� ������� - ����� ���������
		switch(gType_CP[playerid])
		{
			case CPPOLICE_MISSION:
			{	// ����������� ������
				if(PM_Type[playerid] > 0)
		        {
					if(PM_Type[playerid] == 2 && PM_Step[playerid] == 1)
					{
					    new vehicleid = GetPlayerVehicleID(playerid);
					    if(IsCopCar(vehicleid) == 0)
					    {
					        return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "�� ������ ���� � ����������� ������.");
					    }
						TogglePlayerControllable(playerid, false);
						SetTimerEx("MyUnfreezePlayer", 500, false, "i", playerid);
						SendFormatMessage(playerid, COLOR_BLUE, string, "[R] %s %s: {FFFFFF}����������: ������������� ���������, 10-8.", GetPlayerRank(playerid), ReturnPlayerName(playerid));
						PoliceMissionComplete(playerid, COST_PER_WANTED * 2);
					}
					else if(PM_Type[playerid] == 3 && PM_Step[playerid] == 2)
					{
						SendFormatMessage(playerid, COLOR_BLUE, string, "[R] %s %s: {FFFFFF}�������� ������ �������, ��������� ���������.", GetPlayerRank(playerid), ReturnPlayerName(playerid));
						PoliceMissionComplete(playerid, COST_PER_WANTED * 4);
					}
					else
					{
				        gPickupTime[playerid] = 5;
						ShowDialog(playerid, DMODE_POLICE_MISSION);
					}
				}
			}
			case CPPOLICE_ROPE:
			{	//	����� �� ������� � ���������
				if(GetPVarInt(playerid, "Roped") == 1)
			    {
					DeletePVar(playerid, "Roped");
			        ClearAnimations(playerid);
			        TogglePlayerControllable(playerid, 1);
			        for(new i = 0; i < ROPE_LENGTH; i++)
			        	DestroyDynamicObject(RopeObjects[playerid][i]);
				}
			}
			case CPMODE_MISSION:
			{
				if(mission_id[playerid] == MIS_NONE)
				{
					return 1;
		        }
		        else if(mission_id[playerid] == MIS_HOTEL)
		        {
		        	if(mission_step[playerid] == 1)
		        	{
		        		if(!isRus(playerid))
						{
							MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "�������",
								"{FFFFFF}������� ����� �����!", "�������", "", 0);
						}
						else
						{
							ShowPlayerHint(playerid, "������� ����� �����!");
						}
		        	}
		        }
		        else if(mission_id[playerid] == MIS_TRAINING)
		        {
		        	if(mission_step[playerid] == 1)
		        	{
		        		mission_step[playerid] = 2;
						mission_cpnum[playerid] = MySetPlayerCheckpoint(playerid, CPMODE_MISSION, 2232.9, -1159.8, 25.9, 2.0);
		        		if(!isRus(playerid))
		        		{
							format(string, sizeof(string), "{FFFFFF}����� �������!\n��������� � %s�", ActorInfo[A_NEWBIE][a_Name]);
		        			MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "�������", string, "�������", "", 0);
		        		}
		        		else
		        		{
		        			ShowPlayerHint(playerid, "~g~����� �������");
		        			format(string, sizeof(string), "��������� � ~y~%s�", ActorInfo[A_NEWBIE][a_Name]);
		        			SendMissionMessage(playerid, string, 5000, true);
		        		}
		        		return true;
		        	}
		        }
			}

			#if defined	_job_job_trucker_included
				case CPJOB_TRUCKER:
				{
					new const vehicleid = GetPlayerVehicleID(playerid);
				    if(vehicleid != TruckerVeh[playerid])
				    {
				        return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "�� ������ ������ � ����� ������.");
				    }
				    if(GetVehicleTrailer(vehicleid) != TruckerTrailer[playerid])
				    {
				       	return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "�� ������ �������� ��������� ������.");
				    }
					Trucker_Complete(playerid);
			    }
			#endif

		    #if defined	_job_part_loader_included
		       	case CPJOB_LOADER:
		       	{	// ���������� ���������
	       		 	if(LoaderStatus[playerid])
			        {
			        	CarryDown(playerid);
			        }
				}
			#endif

			#if defined	_job_job_theft_included
				case CPJOB_AUTOTHEFT:
				{   // ������ ������������
					Theft_EnterCP(playerid);
				    return true;
				}
			#endif
		}
		MyDisablePlayerCheckpoint(playerid);
	}
	//------------------------[������������ ���������]--------------------------
    else if(checkpointid == CP_AUTOSCHOOL)			return ShowDialog(playerid, DMODE_AUTOSCHOOL);
    else if(checkpointid == CP_SHOOTING)			return ShowDialog(playerid, DMODE_SHOOTING);
    else if(checkpointid == CP_SEXSHOP)				return ShowDialog(playerid, DMODE_SEXSHOP);
    else if(checkpointid == CP_BANK)				return ShowDialog(playerid, DMODE_BANK);
    else if(checkpointid == CP_MOTEL)				return ShowDialog(playerid, DMODE_HOTEL);
    else if(checkpointid == CP_EXIT_TIR)
    {
    	if(p_isShooting{playerid})
    	{
			FinishPlayerShooting(playerid, true);
    	}
		else
		{
			MySetPlayerPosFade(playerid, FT_NONE, 286.23, -30.22, 1001.51, 0.0, false, GetPlayerInterior(playerid), (GetPlayerVirtualWorld(playerid) - playerid - 1000));
		}
    }
    else if(checkpointid == CP_DRUGSTORE)
    {
        if(IsGang(PlayerInfo[playerid][pFaction]))
		{	// ������ ��� ����
			ShowDialog(playerid, DMODE_DRUGSTORE);
		}
    }
    else if(checkpointid == CP_GUNDEAL)
    {
    	if(IsMafia(PlayerInfo[playerid][pFaction]))//Job.GetPlayerJob(playerid) == JOB_GUNDEAL)
		{
			ShowPlayerHint(playerid, "~w~��� ����������� ������� �������� ��� � ~y~���������~w~ � ������� ~y~������������");
		}
    }
	else if(GraffitiCP[0] <= checkpointid <= GraffitiCP[sizeof GraffitiCP - 1])	// ������� ��������
	{
	    new zone = GetPlayerGangZone(playerid);
   		if(GangZoneOwner[zone] != PlayerInfo[playerid][pFaction])
   		{
   		    ShowPlayerHint(playerid, "������� ������������� ������ �� ��������� �� �����");
   		}
	}
	///////	��������� ���������
	else
	{
		//  ������ �� ������ ����
		if(j_jobstep{playerid} == 1)
		{
			for(new i = 0; i < sizeof j_fJobPos; ++i)
			{
			    if(checkpointid == j_jobcp[i])
			    {
    	 			SetPVarInt(playerid, "jail_job_cp", i);
	                DestroyDynamicCP(j_jobcp[i]), j_jobcp[i] = INVALID_STREAMER_ID;

					j_jobstep{playerid}++;
					MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	                SetPlayerFacingAngle(playerid, j_fJobPos[i][3]);

					new object;
					switch(random(3))
					{
					    case 0: object = 2226;
					    case 1: object = 2103;
					    case 2: object = 2028;
					    default: object = 1718;
					}
					if(j_fJobPos[i][3] == 0.0)
					{
						j_JobObj[playerid] = CreateDynamicObject(object, j_fJobPos[i][0], j_fJobPos[i][1] + 0.6, j_fJobPos[i][2] - 0.05, 0.0, 0.0, 0.0);
					}
					else
					{
						j_JobObj[playerid] = CreateDynamicObject(object, j_fJobPos[i][0], j_fJobPos[i][1] - 0.6, j_fJobPos[i][2] - 0.05, 0.0, 0.0, 0.0);
					}
					RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND);
					SetPlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND, 18635, 14, 0.264531, 0.121060, 0.022172, 279.757507, 164.484985, 184.886245);
					SetPlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1, 18644, 13, 0.334366, 0.015833, -0.035214, 294.913085, 188.347946, 235.000213);

					MyApplyAnimation(playerid, "INT_SHOP", "shop_cashier", 4.1, 1, 0, 0, 1, 11000);

					new bool:comb[5];
					_GenerateComb(sizeof(comb), comb);
					SetPlayerComb(playerid, COMB_JAILJOB, sizeof(comb), comb, true);
					return true;
			    }
			}
		}
	}
	return true;
}

public OnDynamicObjectMoved(objectid)
{
	#if defined	_job_part_loader_included
		Callback: Loader_OnDynamicObjectMoved(objectid);
	#endif

	#if defined	_job_part_farmer_included
   		Callback: Farmer_OnDynamicObjectMoved(objectid);
	#endif
	return true;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	if(IsPlayerNPC(playerid) || SpectateID[playerid] != INVALID_PLAYER_ID)
	{
		return true;
	}
	return true;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if(IsPlayerNPC(playerid) || SpectateID[playerid] != INVALID_PLAYER_ID)
	{
		return true;
	}
	if(InRace[playerid])
	{
	    new string[128];
	    if(RaceCP[ pRaceCP[playerid] ][cp_Type] == 0)
	    {
	        pRaceCP[playerid] += 1;
		    //DisablePlayerRaceCheckpoint(playerid);
			ShowNextRaceCP(playerid, pRaceCP[playerid]);

			//format(string, 128, "~g~Checkpoint: ~w~%d/%d", pRaceCP[playerid], RaceInfo[cp_cache]);
			//GameTextForPlayer(playerid, string, 3000, 5);
	    }
	    else
	    {// �����
	    	SetVehicleSpeed(GetPlayerVehicleID(playerid), 5.0);

	        new bool:record = false;
			new result = GetTickCount() - RaceInfo[rtick];

			RaceInfo[rFinisher] += 1;
	        RaceLeave(playerid, true);
			ShowRaceResult(playerid, RaceInfo[rFinisher], result);

            if(1 <= RaceInfo[rFinisher] <= 3)
            {
				new finishname[20], prize;
                switch(RaceInfo[rFinisher])
                {
                    case 1:
					{
						finishname = "������"; prize = RACE_PRIZE;
						if(RaceInfo[rRecord] == 0 || RaceInfo[rRecord] > result)
						{
						    record = true;
						    RaceInfo[rRecord] = result;
						    strput(RaceInfo[rRecordBy], ReturnPlayerName(playerid));

						    new query[128];
							mysql_format(g_SQL, query, sizeof query, "UPDATE `races` SET `record` = '%d', `recordby` = '%e' WHERE `id` = '%d'", RaceInfo[rRecord], RaceInfo[rRecordBy], RaceInfo[rID]);
							mysql_query_ex(query);
						}
					}
                    case 2: { finishname = "������"; prize = floatround(RACE_PRIZE / 2); }
                    case 3: { finishname = "�������"; prize = floatround(RACE_PRIZE / 5); }
                }
                if(prize > 0)	format(string, 128, "WINNER!~n~~w~%d$", prize);
                else 			string = "LOSER!";
                GameTextForPlayer(playerid, string, 5000, 3);
				format(string, 128, "[�����]: ������ %s ����������� %s � ������� %d$", ReturnPlayerName(playerid), finishname, prize);
				if(record == true) strcat(string, " (����� ������!)");
				MySendClientMessageToAll(COLOR_EVENT, string);
                MyGivePlayerMoney(playerid, prize);
            }
	        format(string, 128, "[�����]: ���� ����� � �����: %d/%d", RaceInfo[rFinisher], RaceInfo[rAllPlayers]);
	        SendClientMessage(playerid, COLOR_SERVER, string);
            if(RaceInfo[rPlayers] <= 0)
            {
				MySendClientMessageToAll(COLOR_EVENT, "[�����]: ����� �����������!");
				RaceStop();
            }
	    }
	}
	return true;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
    if(redit_act[playerid] == 3)
    {
        if(redit_curid[playerid] > 0)
        {
	        new string[32];
	        format(string, 32, "Checkpoint: ~w~%d", redit_num[playerid]);
	        GameTextForPlayer(playerid, string, 3000, 4);
	        PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
        	redit_previd[playerid] = redit_curid[playerid];
	        redit_curid[playerid] = ShowPlayerEditCP(playerid, ++redit_num[playerid]);
        }
    }
	return true;
}
public OnObjectMoved(objectid)
{
	return true;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return true;
}

//public OnPlayerPickUpPickup(playerid, pickupid)
public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    if(IsPlayerNPC(playerid) || SpectateID[playerid] != INVALID_PLAYER_ID || fade_Teleporting[playerid])
    {
    	return true;
    }
    if(gPickupTime[playerid] > 0 && (gPickupID[playerid] == (-1) || gPickupID[playerid] == pickupid))
    {
    	return true;
    }

	#if defined	_job_part_farmer_included
		Callback:Farmer_OnPlayerPickUpDPickup(playerid, pickupid);
	#endif
	#if defined	_job_part_delivery_included
		Callback:Delivery_OnPlayerPickUpDPickup(playerid, pickupid);
	#endif

    gPickupID[playerid] = pickupid;
    new vw = GetPlayerVirtualWorld(playerid);
    if(pickupid == TestPickup[playerid])
    {
        return SendClientMessage(playerid, COLOR_WHITE, "�������� �������� �����!");
    }

#if defined	_job_part_delivery_included
    else if(pickupid == BoardPickup[1])
    {
    	Dialog_Show(playerid, Dialog:Delivery_Board);
    }
#endif

    else if(pickupid == AirportPickup)
    {
    	MySetPlayerPosFade(playerid, FT_NONE, 1685.67, -2340.74, 13.55, 180.0, true, 0, VW_AIRPORT);
    }
    else if(pickupid == NewbiePickup)
    {
    	if(Dialogid[playerid] == INVALID_DIALOGID)
    	{
    		ShowDialog(playerid, DMODE_NEWBIE);
    	}
    }
    else if(pickupid == MotelPickup)
    {
    	if(PlayerInfo[playerid][pRent] == -1)
    	{
    		MySetPlayerPosFade(playerid, FT_NONE, 2284.7, -1136.6, 1050.90, 90.0, false, 11, VW_HOUSE + playerid);
    	}
    	else if(PlayerInfo[playerid][pRent] == -2)
    	{
    		MySetPlayerPosFade(playerid, FT_NONE, 2264.0, -1140.6, 1050.63, 360.0, false, 10, VW_HOUSE + playerid);
    	}
    	else if(PlayerInfo[playerid][pRent] == -3)
    	{
    		MySetPlayerPosFade(playerid, FT_NONE, 2250.6, -1135.1, 1050.63, 178.5, false, 9, VW_HOUSE + playerid);
    	}
    	else
    	{
    		SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "�� �� ��������� ����� � ���� �����.");
    		gPickupTime[playerid] = 5;
    	}
    }
    else if(MRoomPickup[0] <= pickupid <= MRoomPickup[2])
    {
    	MySetPlayerPosFade(playerid, FT_HROOM_EXIT, 2227.24, -1148.64, 1029.8, 0.0, false, 15, VW_HOTEL);
    }
    else if(pickupid == WarehousePickup[0])
    {
        if(PlayerInfo[playerid][pFaction] == F_GROVE)
        {
	        SetPVarInt(playerid, "WH:faction", F_GROVE);
			ShowDialog(playerid, DWAREHOUSE_MAIN);
        }
    }
    else if(pickupid == WarehousePickup[1])
    {
        if(PlayerInfo[playerid][pFaction] == F_BALLAS)
        {
	        SetPVarInt(playerid, "WH:faction", F_BALLAS);
			ShowDialog(playerid, DWAREHOUSE_MAIN);
        }
    }
    else if(pickupid == WarehousePickup[2])
    {
        if(PlayerInfo[playerid][pFaction] == F_VAGOS)
        {
	        SetPVarInt(playerid, "WH:faction", F_VAGOS);
			ShowDialog(playerid, DWAREHOUSE_MAIN);
        }
    }
    else if(pickupid == WarehousePickup[3])
    {
        if(PlayerInfo[playerid][pFaction] == F_AZTECAS)
        {
	        SetPVarInt(playerid, "WH:faction", F_AZTECAS);
			ShowDialog(playerid, DWAREHOUSE_MAIN);
        }
    }
    else if(pickupid == WarehousePickup[4])
    {
        if(PlayerInfo[playerid][pFaction] == F_RIFA)
        {
	        SetPVarInt(playerid, "WH:faction", F_RIFA);
			ShowDialog(playerid, DWAREHOUSE_MAIN);
        }
    }
    else if(pickupid == WarehousePickup[5])
    {
        if(PlayerInfo[playerid][pFaction] == F_RUSMAF)
        {
	        SetPVarInt(playerid, "WH:faction", F_RUSMAF);
			ShowDialog(playerid, DWAREHOUSE_MAIN);
        }
    }
    else if(pickupid == WarehousePickup[6])
    {
        if(PlayerInfo[playerid][pFaction] == F_LCN)
        {
	        SetPVarInt(playerid, "WH:faction", F_LCN);
			ShowDialog(playerid, DWAREHOUSE_MAIN);
        }
    }
    else if(pickupid == WarehousePickup[7])
    {
        if(PlayerInfo[playerid][pFaction] == F_YAKUZA)
        {
	        SetPVarInt(playerid, "WH:faction", F_YAKUZA);
			ShowDialog(playerid, DWAREHOUSE_MAIN);
        }
    }
    else if(pickupid == CrimebankPickup[0])
    {
    	if(PlayerInfo[playerid][pFaction] == F_GROVE)
    	{
    		MyGivePlayerMoney(playerid, floatround(PlayerInfo[playerid][pCrimeWage]));
    		PlayerInfo[playerid][pCrimeWage] = 0.0;
    	}
    }
    else if(pickupid == CrimebankPickup[1])
    {
    	if(PlayerInfo[playerid][pFaction] == F_BALLAS)
    	{
    		MyGivePlayerMoney(playerid, floatround(PlayerInfo[playerid][pCrimeWage]));
    		PlayerInfo[playerid][pCrimeWage] = 0.0;
    	}
    }
    else if(pickupid == CrimebankPickup[2])
    {
    	if(PlayerInfo[playerid][pFaction] == F_VAGOS)
    	{
    		MyGivePlayerMoney(playerid, floatround(PlayerInfo[playerid][pCrimeWage]));
    		PlayerInfo[playerid][pCrimeWage] = 0.0;
    	}
    }
    else if(pickupid == CrimebankPickup[3])
    {
    	if(PlayerInfo[playerid][pFaction] == F_AZTECAS)
    	{
    		MyGivePlayerMoney(playerid, floatround(PlayerInfo[playerid][pCrimeWage]));
    		PlayerInfo[playerid][pCrimeWage] = 0.0;
    	}
    }
    else if(pickupid == CrimebankPickup[4])
    {
    	if(PlayerInfo[playerid][pFaction] == F_RIFA)
    	{
    		MyGivePlayerMoney(playerid, floatround(PlayerInfo[playerid][pCrimeWage]));
    		PlayerInfo[playerid][pCrimeWage] = 0.0;
    	}
    } 
    else if(pickupid == MechanicPickup)
    {
    	ShowDialog(playerid, DJOB_MECHANIC);
    }

#if defined	_job_part_delivery_included
    else if(pickupid == DeliveryPickup)
    {
    	Dialog_Show(playerid, Dialog:Delivery_Main);
    }
#endif

    else if(pickupid == PoliceDutyPickup)
	{
	    if(PlayerInfo[playerid][pFaction] == F_POLICE)
	    {
	    	new string[128];
	    	if(IsPoliceDuty(playerid))
	    	{
	    		UpdatePlayerSkin(playerid);
	    		DeletePlayerAcsr(playerid, ACSR_HAT);
	    		MyChangePlayerWeapon(playerid, false);
	    		PlayerAction(playerid, "������� ������ � ������ � �������");
	    		format(string, sizeof(string), "[R] %s %s: {FFFFFF}����� � ���������, �����.", GetPlayerRank(playerid), ReturnPlayerName(playerid));
	    		SendPoliceMessage(COLOR_BLUE, string);
	    		CopList_REMOVE(playerid);
	    	}
	    	else
	    	{
	    		new skins[] = { 71, 280, 281, 266, 265, 282, 283, 288 };
	    		MySetPlayerSkin(playerid, skins[ PlayerInfo[playerid][pRank] - 1 ]);
	    		//	����������� �������/�����
	    		DeletePlayerAcsr(playerid, ACSR_HELMET);
	    		/*if(2 <= PlayerInfo[playerid][pRank] <= 3)
	    		{
	    			//SetPlayerAcsr(playerid, ACSR_HAT, 18636, false);
	    			SetPlayerAcsrEx(playerid, ACSR_HAT, 18636, false, 2, 0.132, 0.048, 0.001999, 93.4, 94.400108, 0.0, 0.986, 1.054, 1.0);
	    		}
	    		else if(4 <= PlayerInfo[playerid][pRank] <= 5)
	    		{
	    			//SetPlayerAcsr(playerid, ACSR_HAT, 19521, false);
	    			SetPlayerAcsrEx(playerid, ACSR_HAT, 19521, false, 2, 0.149, -0.009, 0.0, 0.0, 0.0, 0.0, 1.0, 1.164, 1.144);
	    		}
	    		else if(PlayerInfo[playerid][pRank] == 6)
	    		{
	    			//SetPlayerAcsr(playerid, ACSR_HAT, 19520, false);
	    			SetPlayerAcsrEx(playerid, ACSR_HAT, 19520, false, 2, 0.148999, 0.006, 0.001, 0.0, 0.0, 0.0, 1.0, 1.096999, 1.182);
	    		}*/
				// ������
				//MyChangePlayerWeapon(playerid, true);
				MySetPlayerWeapon(playerid, 3, 1);
				/*if(PlayerInfo[playerid][pRank] == 1)
				{
					MyGivePlayerWeapon(playerid, 24, (GunParams[24][GUN_AMMO] * 2));
				}
				else if(PlayerInfo[playerid][pRank] == 2)
				{
					MyGivePlayerWeapon(playerid, 24, (GunParams[24][GUN_AMMO] * 4));
				}
				else if(PlayerInfo[playerid][pRank] == 3)
				{
					MyGivePlayerWeapon(playerid, 24, (GunParams[24][GUN_AMMO] * 4));
					MyGivePlayerWeapon(playerid, 25, (GunParams[25][GUN_AMMO] * 1));
				}
				else if(PlayerInfo[playerid][pRank] == 4)
				{
					MyGivePlayerWeapon(playerid, 24, (GunParams[24][GUN_AMMO] * 5));
					MyGivePlayerWeapon(playerid, 25, (GunParams[25][GUN_AMMO] * 2));
				}
				else if(PlayerInfo[playerid][pRank] == 5)
				{
					MyGivePlayerWeapon(playerid, 24, (GunParams[24][GUN_AMMO] * 5));
					MyGivePlayerWeapon(playerid, 25, (GunParams[25][GUN_AMMO] * 2));
					MyGivePlayerWeapon(playerid, 31, (GunParams[31][GUN_AMMO] * 1));
				}
				else if(PlayerInfo[playerid][pRank] == 6)
				{
					MyGivePlayerWeapon(playerid, 24, (GunParams[24][GUN_AMMO] * 5));
					MyGivePlayerWeapon(playerid, 25, (GunParams[25][GUN_AMMO] * 2));
					MyGivePlayerWeapon(playerid, 31, (GunParams[31][GUN_AMMO] * 2));
				}
				else if(PlayerInfo[playerid][pRank] == 7)
				{
					MyGivePlayerWeapon(playerid, 24, (GunParams[24][GUN_AMMO] * 5));
					MyGivePlayerWeapon(playerid, 25, (GunParams[25][GUN_AMMO] * 2));
					MyGivePlayerWeapon(playerid, 31, (GunParams[31][GUN_AMMO] * 2));
					MySetPlayerArmour(playerid, 100);
				}
				else if(PlayerInfo[playerid][pRank] == 8)
				{
					MyGivePlayerWeapon(playerid, 24, (GunParams[24][GUN_AMMO] * 5));
					MyGivePlayerWeapon(playerid, 25, (GunParams[25][GUN_AMMO] * 2));
					MyGivePlayerWeapon(playerid, 31, (GunParams[31][GUN_AMMO] * 2));
					MySetPlayerArmour(playerid, 100);
				}*/
				CopList_ADD(playerid);
				PlayerAction(playerid, "���� ������ �� ��������");
				format(string, sizeof(string), "[R] %s %s: {FFFFFF}�������� �� ���������, �����.", GetPlayerRank(playerid), ReturnPlayerName(playerid));
				SendPoliceMessage(COLOR_BLUE, string);
	    	}
	    	UpdatePlayerColor(playerid);
		    gPickupTime[playerid] = 3;
		}
	}
	else if(pickupid == HospitalDutyPickup)
	{
		if(PlayerInfo[playerid][pFaction] == F_EMERGY)
	    {
	    	if(GetPVarInt(playerid, "Player:EmergyDuty"))
	    	{
	    		DeletePVar(playerid, "Player:EmergyDuty");
	    		RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1);
	    	}
	    	else
	    	{
	    		SetPVarInt(playerid, "Player:EmergyDuty", 1);
	    		SetPlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1, 11738, 6, 0.288, 0.014, 0.039, 0.0, -98.2, 0.0, 1.27, 0.82, 1.139);
	    	}
	    }
	    gPickupTime[playerid] = 3;
	}
	else if(pickupid == LawbookPickup)
	{
        new lstring[] =
			"{8D8DFF}����������������:{FFFFFF}\n\
			\t* �������� ��� ��������� (� 20� �� 6�)\n\
			\t* �����������\n\
			\t* �������� ��� ��������\n\
			\t* �������� � ������ ����\n\
			{8D8DFF}���������:{FFFFFF}\n\
			\t* ���������� ��������\n\
			\t* �������� �������������\n\
			\t* ���� ��������������\n\
			\t* ��������� �����������\n\
			\t* ��������\n\
			\t* ����� �� ������\n\
			\t* ������������� � ������\n";
		MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_LIST, "{000CFF}���� ������� San Andreas", lstring, "�������", "", 0);
	    return true;
	}
	else if(pickupid == CopGuidePickup)
	{
		new lstring[1536];
		// ���� �������� � ���� lstring, �� pawno ��������
	    strcat(lstring,
			"{8D8DFF}�����������:{FFFFFF}\n\
			\t� ������ ������ ������������ ������ �������������� � �������� �����������\n\
			\t����� �� ������� ��������� �������� � �������, ������� �� ������ ���������\n\
			\t��� ����������� �������� � ��������� ���� ��� �������, ���� ��� ��������� �����\n");
		strcat(lstring,
			"{8D8DFF}���������:{FFFFFF}\n\
			\t� ������ ���������� �������������� �������� (������������, ����� ��� ��������)\n\
			\t� ������, ����� �� �� �������� ������� ��� ����� ���������� �� �������������\n\
			\t��� ����� ������ ������� - �������� ��� � ��� �������, ��� ������, ���� �� �����\n");
		strcat(lstring,
			"{8D8DFF}�������� � ������:{FFFFFF}\n\
			\t����������� �������� ������������ ����������� � ������� �� ������ �����\n\
			\t����� �������� ������ ������������� ������ - ���������� ����������� ������\n\
			\t������ �������� ��� ���� ���� � �������� ����� �����������\n");
		strcat(lstring,
			"{8D8DFF}�������������:{FFFFFF}\n\
			\t����������� ����������� ���������, ����� �� ������ 2 � ������� �������� � ������� 30 ������\n\
			\t����� �� ������ ������� � �������������� ��� ��������, ������� ��������� ��� ������\n\
			\t���� ������������� ��������������, �� ����� �������� ������ �� ������ 2, ������ ������\n\
			\t����� ������������� ������ ������� ������������, �� ��������� �������� ������� �����\n\
			\t������ ����������� ��� �� ����� �������������� � ������ � ������ ������������� ��������������\n");
/*
		strcat(lstring,
			"{8D8DFF}������� �� ��������:{FFFFFF}\n\
			\t* ������ �������� ����� ���������� ������ ������ �������, �� �� �������� ����������!");
*/
		MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "���������� ������������", lstring, "�������", "", 0);
	    return true;
	}
	else if(pickupid == FineParkPickup)
	{
	    ShowDialog(playerid, DMODE_FINEPARK);
	    gPickupTime[playerid] = 3;
	}
	else if(CarSalonPickup_F <= pickupid <= CarSalonPickup_L)
	{
	    if(ChooseVehicleID[playerid] == 0)
	    {
	        ChooseVehicleID[playerid] = pickupid - CarSalonPickup_F + 1;
		    ChoosePlayerVehicle(playerid, 1);
	    }
	}
	else if(pickupid == StuffBankEnter)
	{
		gPickupID[playerid] = (-1);
	    gPickupTime[playerid] = 3;
	    if(!IsMafia(PlayerInfo[playerid][pFaction]))
	    {// [BT]
	        return ShowPlayerHint(playerid, "~r~����� ������� �� ����");
	    }
	    MySetPlayerPos(playerid, 2148.3372,1605.5266,1001.4789,0.0);
	}
	else if(pickupid == StuffBankExit)
	{
		gPickupID[playerid] = (-1);
	    gPickupTime[playerid] = 3;
	    MySetPlayerPos(playerid, 2155.4954,1611.9150,993.6882,180.0);
	}
	else if(pickupid == StuffBankExit2)
	{
		gPickupID[playerid] = (-1);
	    gPickupTime[playerid] = 3;
	    MySetPlayerPos(playerid, 2136.6282,1609.4617,993.6882,270.0);
	}
	else if(pickupid == VentBankPickup)
	{
	    MySetPlayerPos(playerid, 2156.2219,1624.7319,996.6882,90.0);
	    SetCameraBehindPlayer(playerid);
	}
	else if(pickupid == GunDealPickup)
	{
		if(Dialogid[playerid] == INVALID_DIALOGID && IsMafia(PlayerInfo[playerid][pFaction]))//Job.GetPlayerJob(playerid) == JOB_GUNDEAL)
		{
			ShowDialog(playerid, DJOB_GUNDEAL_MATS);
		}
	}
	else if(pickupid == DrugDealPickup[0])
	{
		if(Dialogid[playerid] == INVALID_DIALOGID && IsMafia(PlayerInfo[playerid][pFaction]))//Job.GetPlayerJob(playerid) == JOB_DRUGDEAL)
		{
			ShowDialog(playerid, DJOB_DRUGDEAL_MATS);
		}
	}
	else if(pickupid == DrugDealPickup[1])
	{
		if(IsMafia(PlayerInfo[playerid][pFaction]))//Job.GetPlayerJob(playerid) == JOB_DRUGDEAL)
		{
			ShowPlayerHint(playerid, "~w~��� ����������� ����� �������� �� � ~y~���������~w~ � ������� ~y~������������");
		}
	}
	else if(pickupid == PrisonEatPickup)
	{
		if(PlayerInfo[playerid][pJailTime] <= 0)
			return true;
		if(LastPrisonStatus != 2)
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ �� ��������� �����.");
		SetPlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND, 2216, 5, 0.032, 0.017, 0.413999, -105.70021, 23.399978, -1.100097);
		PlayerFoodHands[playerid] = 1;
		MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_HINT "������� "SCOLOR_HINT"/eat"SCOLOR_WHITE", ����� ������ ��� � �������.");
	}
	else if(RingInfoPickup[0] <= pickupid <= RingInfoPickup[ sizeof(RingInfoPickup) - 1 ])
	{
		ShowDialog(playerid, DMODE_BOXINFO);
	}
	else if(GYMPickup[0] <= pickupid <= GYMPickup[1])
	{
		ShowDialog(playerid, DMODE_FSTYLE);
	}
	else if(j_matpickup[0] <= pickupid <= j_matpickup[1])
	{
	    if(PlayerInfo[playerid][pJailTime] <= 0 || j_jobstep{playerid})
			return true;

		if(LastPrisonStatus != 1)
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ �� ������� �����.");

	    //  ����� ���������
	   	if(CarryUP(playerid, 2060, 0.044, 0.36, -0.049, 0.0, 90.0, 0.0))
	   	{
	   		j_jobstep{playerid} = 1;
	    	ShowPlayerHint(playerid, "~w~�������� ��������� � ������ �� ������� ������");
	   	}
		gPickupTime[playerid] = 3;
	}
	else if(pickupid == j_fFinalPickup) //  ������ �� ���� (�����)
	{
		gPickupTime[playerid] = 3;
	    if(PlayerInfo[playerid][pJailTime] <= 0)
	    {
		    return true;
	    }
        if(LastPrisonStatus != 1)
        {
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ �� ������� �����.");
        }
		if(j_jobstep{playerid} != 3 && j_jobstep{playerid} != 11)
		{
		    return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "���� �������� ������� ���������.");
		}
        j_jobstep{playerid} = 0;
        j_Storage++;
        UpdateJailStorage();
	    CarryDown(playerid);
	    if(PlayerInfo[playerid][pJailTime] > 30)
	    {
			PlayerInfo[playerid][pJailTime] -= 10;
			GameTextForPlayer(playerid, "-10 sec", 2000, 4);
		}
	}
	else if(pickupid == j_lStartPickup)	//  ������ �� ���� (�������)
	{
		gPickupTime[playerid] = 3;

	    if(PlayerInfo[playerid][pJailTime] <= 0 || j_jobstep{playerid})
	    {
			return true;
	    }
        if(LastPrisonStatus != 1)
        {
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ �� ������� �����.");
        }
		if(j_Storage > 0)
		{
			if(CarryUP(playerid, 2969, 0.009, 0.344, -0.024, 0.0, 90.0, 0.0))
			{
				j_jobstep{playerid} = 11;
	            j_Storage--;
	            UpdateJailStorage();
				ShowPlayerHint(playerid, "�������� ���� � �������� � �����");

	            j_MapIcon[playerid] = CreateDynamicMapIcon(576.1, -2674.1, 13.2, 0, 0xAA0000FF, -1, -1, playerid, 10000.0);
	            j_jobcp[playerid] = CreateDynamicCP(576.1, -2674.1, 13.2, 0.3, -1, 2, -1, 3.0);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "����� ����.");
		}
	}
	else if(pickupid == j_lFinishPickup)
	{
		gPickupTime[playerid] = 3;
		if(PlayerInfo[playerid][pJailTime] <= 0)
		{
		    return true;
		}
        if(LastPrisonStatus != 1)
        {
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ �� ������� �����.");
        }
		if(j_jobstep{playerid} != 3 && j_jobstep{playerid} != 11)
		{
		    return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "������� �������� ���� �� ������.");
		}
        j_jobstep{playerid} = 0;
        DestroyDynamicMapIcon(j_MapIcon[playerid]), j_MapIcon[playerid] = INVALID_STREAMER_ID;
	    CarryDown(playerid);
	    if(PlayerInfo[playerid][pJailTime] > 30)
	    {
			PlayerInfo[playerid][pJailTime] -= 10;
			GameTextForPlayer(playerid, "-10 sec", 2000, 4);
		}
	}
	else if(pickupid == mission_pickup[playerid])
	{
		if(mission_id[playerid] == MIS_HOTEL && mission_step[playerid] == 0)
		{
			DestroyDynamicPickup(mission_pickup[playerid]), mission_pickup[playerid] = INVALID_STREAMER_ID;
			MyApplyAnimation(playerid, "MISC", "Case_pickup", 4.1, 0, 0, 0, 0, 0);
			SetPlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND, 19624, 6, 0.071, 0.015, 0.022, 0.0, -99.0, -4.4, 1.0, 0.737, 1.0);
			mission_step[playerid]++;
			mission_cpnum[playerid] = MySetPlayerCheckpoint(playerid, CPMODE_MISSION, 1693.20, -2312.80, 13.55, 2.0);
			if(!isRus(playerid))
			{
				MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "�������",
					"{FFFFFF}������������� �� ��������� � ����� ������� �� ������\n\
					�������� ����� ������ ���� �����!", "�������", "", 0);
			}
			else
			{
				SendMissionMessage(playerid, "������������� �� ��������� � ����� ������� �� ������", 5000, true);
			}
		}
		return true;
	}
	//  ============
	else
	{
		//	������� ��������
		for(new b = 0; b < MAX_BUSINESSES; b++)
		{
			new Float:angle;
			GetPlayerFacingAngle(playerid, angle);
			if(pickupid == BizInfo[b][bPickup] && floatdif(BizInfo[b][bPos][3], angle) < 90.0)
			{
				#if defined	_job_part_delivery_included	
					if(Delivery_BringInBiz(playerid, b))
			    	{
						return true;
			       	}
			    #endif   	

	       		if(PickupedBiz[playerid] == b)
			    {
			        gPickupTime[playerid] = 3;
			        return true;
			    }
			    PickupedBiz[playerid] = b;
				ShowDialog(playerid, DBIZ_MAIN);
				return true;
			}
			else if(pickupid == BizInfo[b][bExPickup])
			{
				new query[128], Float:a;
			    format(query, sizeof(query), "SELECT `a` FROM %s.`locations` WHERE `id` = '%d'", MAIN_DB, BizInfo[b][bLocation]);
				new Cache:result = mysql_query(g_SQL, query);
				cache_get_value_name_float(0, "a", a);
				if(floatdif(a, angle) < 90.0)
				{
					//MySetPlayerPosFade(playerid, FT_NONE, Arr3<BizInfo[b][bPos]>, BizInfo[b][bPos][3] + 180, false, 0, 0);
					MySetPlayerPos(playerid, Arr3<BizInfo[b][bPos]>, BizInfo[b][bPos][3] + 180, 0, 0);
					gPickupTime[playerid] = 3;
				}
				cache_delete(result);
				RobberyFinish(playerid, 0, true);
				return true;
			}
		}
		// ������� �����
		for(new h = 0; h < MAX_HOUSES; h++)
		{
		    if(pickupid == HousePickups[h])
		    {
		    	if(PickupedHouse[playerid] != (-1))
			    {
			        gPickupTime[playerid] = 3;
			        return true;
			    }
			    PickupedHouse[playerid] = h;
		        if(HouseInfo[h][hOwnerID])
				{
					IFace.ToggleGroup(playerid, IFace.HOUSE_ENTER_MENU, true);
					if(HouseInfo[h][hOwnerID] == PlayerInfo[playerid][pUserID])
					{
						TextDrawShowForPlayer(playerid, tdHouseButton1);
						TextDrawShowForPlayer(playerid, tdHouseButton4);
					}
					else
					{
						if(PlayerInfo[playerid][pRent] == HouseInfo[h][hID])
						{
							TextDrawShowForPlayer(playerid, tdHouseButton3);
						}
						else if(HouseInfo[h][hRentPrice] > 0)
						{
							TextDrawShowForPlayer(playerid, tdHouseButton2);
						}
						TextDrawShowForPlayer(playerid, tdHouseRob);
					}
					SelectTextDraw(playerid, COLOR_SERVER);
				}
				else
				{
					ShowDialog(playerid, DMODE_HOUSE);
				}
				return true;
			}
		}
		if(vw > 0 && GetPVarType(playerid, "Fur:HouseID") == PLAYER_VARTYPE_NONE)
		{
			for(new cl; cl < sizeof(InterCoords); cl++)
			{
			    for(new in; in < sizeof(InterCoords[]); in++)
			    {
			        if(pickupid == InterPickups[cl][in])
			        {
					    new Float:angle;
						GetPlayerFacingAngle(playerid, angle);
			            if(floatdif(InterCoords[cl][in][3], angle) < 90.0)
			            {
				            new h = FoundHouse(vw - VW_HOUSE);
				            gPickupID[playerid] = (-1);
				            gPickupTime[playerid] = 4;
				            MySetPlayerPos(playerid, HouseInfo[h][hX], HouseInfo[h][hY], HouseInfo[h][hZ], HouseInfo[h][hA] + 180.0, 0, 0);
				            //MySetPlayerPosFade(playerid, FT_NONE, HouseInfo[h][hX], HouseInfo[h][hY], HouseInfo[h][hZ], HouseInfo[h][hA] + 180.0, false, 0, 0);
				            SetCameraBehindPlayer(playerid);
			            }
			            return true;
			        }
				}
			}
		}
	// part of OnPlayerPickUpDynamicPickup
		//	������� ������������
		for(new p = 0; p < sizeof(AutoRepairPos); p++)
		{
			if(pickupid == RepairPickup[p])
			{
			    new vehicleid = GetPlayerVehicleID(playerid);
			    if(GetPlayerState(playerid) == 2 && IsVehicleWithEngine(vehicleid))
				{
				    new Float:Health;
				    GetVehicleHealth(vehicleid, Health);
					if(Health <= 250.0)
					{
						MySetVehicleHealth(vehicleid, 350.0);
			    		SendClientMessage(playerid, COLOR_SAYING, "- �����������: �������!!! �������!!!");
			    		PlayerPlaySound(playerid, 7053, 0.0, 0.0, 0.0);
					}
					pRepair[playerid] = p;
				    TogglePlayerControllable(playerid, false);
				    ShowDialog(playerid, DMODE_REPAIR);
			    }
			    return true;
		    }
		}
    }
	return true;	// end of OnPlayerPickUpPickup
}

public OnBuyMenuResponse(playerid, id, button)
{
	switch(id)
	{
		case OBJECT_WEAPON:
		{
			if(button)
			{
				if(GetPVarType(playerid, "Player:InAmmoZone") == PLAYER_VARTYPE_INT)
				{
					if(!PlayerInfo[playerid][pGunLic])
					{
						return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "� ��� ��� �������� �� ������.");
					}
					new ammo_zone = GetPVarInt(playerid, "Player:InAmmoZone");
					new item = ((ammo_zone >= sizeof(AmmuList)) ? (ammo_zone % sizeof(AmmuList)) : ammo_zone);
					new vw = GetPlayerVirtualWorld(playerid);
					new price;
					if(AmmuList[item] == 99)
					{
						if(MyGetPlayerArmour(playerid) >= 100)
						{
							return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "�� ��� ��� ����� ����������.");
						}
						price = floatround(200 * ((vw == VW_LSPD) ? 0.2 : 1.0));
						if(MyGetPlayerMoney(playerid) < price)
						{
						    return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "� ��� �� ������� ����� ��� ������� �����������.");
						}
						MySetPlayerArmour(playerid, 100.0);
						return MyGivePlayerMoney(playerid, -price);
					}
					else
					{
						price = floatround(GunParams[ AmmuList[item] ][GUN_PRICE] * ((vw == VW_LSPD) ? 0.2 : 1.0));
						if(MyGetPlayerMoney(playerid) < price)
						{
						    return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "� ��� �� ������� ����� ��� ������� ����� ������.");
						}
						new weapons, ammo;
					    GetPlayerWeaponData(playerid, GunParams[ AmmuList[item] ][GUN_SLOT], weapons, ammo);
						if(weapons > 0 && weapons != AmmuList[item] && ammo > 0)
						{
						    weaponid_new[playerid] = AmmuList[item];
						    SetPVarInt(playerid, "Player:WaponBuy:Price", price);
						    return ShowDialog(playerid, DMODE_GUNDEL);
						}
						if(ammo + GunParams[ AmmuList[item] ][GUN_AMMO] >= 1000)
						{
						    return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "�� ������ ������������ ���������� ������.");
						}
						//MyGivePlayerWeapon(playerid, AmmuList[item], GunParams[ AmmuList[item] ][GUN_AMMO]);
						Inv.GivePlayerWeapon(playerid, AmmuList[item], GunParams[ AmmuList[item] ][GUN_AMMO]);
					}
					if(vw != VW_LSPD)
					{
						new b = GetBizWhichPlayer(playerid);
				        if(b != INVALID_DATA && BizInfo[b][bType] == BUS_AMMO)
				        {
				        	BizSaleProds(b, price, 1);
				        }
					}
			        return MyGivePlayerMoney(playerid, -price);
				}
			}
			else
			{
				SetCameraBehindPlayer(playerid);
				if(GetPVarInt(playerid, "Player:HintPressH") || GetPVarType(playerid, "Player:InAmmoZone"))
				{
					TextDrawShowForPlayer(playerid, TD_PressH);
				}
			}
		}
	}
	HidePlayerBuyMenu(playerid);

	return true;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	new Menu:Current = GetPlayerMenu(playerid);
	if(Current == KingRingMenu)
	{
		ShowMenuForPlayer(Current, playerid);
		new b = GetBizWhichPlayer(playerid);
        if(b != INVALID_DATA && BizInfo[b][bType] == BUS_EATERY)
        {
			new Float:health, nHealth, price;
			GetPlayerHealth(playerid, health);
			switch(row)
			{
				case 0: //	������� ($5)
				{
					price = 10;
					if(MyGetPlayerMoney(playerid) < price)
						return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "� ��� ������������ �����.");
					nHealth = 50;
					//MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				}
				case 1: //	������� ($5)
				{
					price = 5;
					if(MyGetPlayerMoney(playerid) < 5)
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
					nHealth = 25;
					//MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				}
				case 2: //	������� ($5)
				{
					price = 5;
					if(MyGetPlayerMoney(playerid) < price)
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
					nHealth = 20;
					//MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				}
				case 3:	//	��������� ($2)
				{
					price = 2;
					if(MyGetPlayerMoney(playerid) < price)
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
					nHealth = 10;
					//MyApplyAnimation(playerid, "BAR", "dnk_stndM_loop", 4.1, 0, 0, 0, 0, 0);
				}
			}
			new eat = EatPlayer(playerid, nHealth);
			if(eat != 0)
			{
				if(eat == -1)
				{
					HideMenuForPlayer(Current, playerid);
					TogglePlayerControllable(playerid, true);
				}
				else MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				BizSaleProds(b, price, 1);
				MyGivePlayerMoney(playerid, -price);
			}
		}
	}
	else if(Current == BurgerShotMenu)
	{
		ShowMenuForPlayer(Current, playerid);
		new b = GetBizWhichPlayer(playerid);
        if(b != INVALID_DATA && BizInfo[b][bType] == BUS_EATERY)
        {
			new Float:health, nHealth, price;
			GetPlayerHealth(playerid, health);
			switch(row)
			{
				case 0: //	Moo Kids Meal (2$)
				{
					price = 2;
					if(MyGetPlayerMoney(playerid) < price){
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
					}
					nHealth = 10;
					//MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				}
				case 1: //	Beef Tower (5$)
				{
					price = 5;
					if(MyGetPlayerMoney(playerid) < price){
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
					}
					nHealth = 25;
					//MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				}
				case 2: //	Meat Stack (10$)
				{
					price = 10;
					if(MyGetPlayerMoney(playerid) < price){
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
					}
					nHealth = 50;
					//MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				}
				case 3:	//	Salad Meal (5$)
				{
					price = 5;
					if(MyGetPlayerMoney(playerid) < price){
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
					}
					nHealth = 20;
					//MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				}
			}
			new eat = EatPlayer(playerid, nHealth);
			if(eat != 0)
			{
				if(eat == -1)
				{
					HideMenuForPlayer(Current, playerid);
					TogglePlayerControllable(playerid, true);
				}
				else MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				BizSaleProds(b, price, 1);
				MyGivePlayerMoney(playerid, -price);
			}
		}
	}
	else if(Current == PizzaMenu)
	{
		ShowMenuForPlayer(Current, playerid);
		new b = GetBizWhichPlayer(playerid);
        if(b != INVALID_DATA && BizInfo[b][bType] == BUS_EATERY)
        {
			new Float:health, nHealth, price;
			GetPlayerHealth(playerid, health);
			switch(row)
			{
				case 0:	//	Mini Pizza (2$)
				{
					price = 2;
					if(MyGetPlayerMoney(playerid) < price)
					{
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
					}
					nHealth = 10;
					//MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				}
				case 1:	//	Big Pizza (5$)
				{
					price = 5;
					if(MyGetPlayerMoney(playerid) < price)
					{
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
					}
					nHealth = 20;
					//MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				}
				case 2:	//	Double Pizza (10$)
				{
					price = 10;
					if(MyGetPlayerMoney(playerid) < price)
					{
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
					}
					nHealth = 50;
					//MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				}
				case 3:	//	Water (2$)
				{
					price = 2;
					if(MyGetPlayerMoney(playerid) < price)
					{
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
					}
					nHealth = 10;
					//MyApplyAnimation(playerid, "BAR", "dnk_stndM_loop", 4.1, 0, 0, 0, 0, 0);
				}
			}
			new eat = EatPlayer(playerid, nHealth);
			if(eat != 0)
			{
				if(eat == -1)
				{
					HideMenuForPlayer(Current, playerid);
					TogglePlayerControllable(playerid, true);
				}
				else MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				BizSaleProds(b, price, 1);
				MyGivePlayerMoney(playerid, -price);
			}
		}
	}
	else if(Current == CluckinBellMenu)
	{
		ShowMenuForPlayer(Current, playerid);
		new b = GetBizWhichPlayer(playerid);
        if(b != INVALID_DATA && BizInfo[b][bType] == BUS_EATERY)
        {
			new Float:health, nHealth, price;
			GetPlayerHealth(playerid, health);
			switch(row)
			{
				case 0:	//	Little Meal (2$)
				{
					price = 2;
					if(MyGetPlayerMoney(playerid) < price){
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
					}
					nHealth = 10;
					//MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				}
				case 1:	//	Big Meal (5$)
				{
					price = 5;
					if(MyGetPlayerMoney(playerid) < price){
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
					}
					nHealth = 20;
					//MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				}
				case 2:	//	Huge Meal (10$)
				{
					price = 10;
					if(MyGetPlayerMoney(playerid) < price){
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
					}
					nHealth = 50;
					//MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				}
				case 3:	//	Salad Meal (10$)
				{
					price = 10;
					if(MyGetPlayerMoney(playerid) < price){
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
					}
					nHealth = 45;
					//MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				}
			}
			new eat = EatPlayer(playerid, nHealth);
			if(eat != 0)
			{
				if(eat == -1)
				{
					HideMenuForPlayer(Current, playerid);
					TogglePlayerControllable(playerid, true);
				}
				else MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
				BizSaleProds(b, price, 1);
				MyGivePlayerMoney(playerid, -price);
			}
		}
	}
	return true;
}

public OnPlayerExitedMenu(playerid)
{
	TogglePlayerControllable(playerid, true);
	return true;
}

public OnPlayerSelectMenuSelect(playerid, reponse, menuid, item)
{
	switch(menuid)
	{
		case SM_DRINK:
		{
			if(reponse)
			{
				new b = GetBizWhichPlayer(playerid);
		        if(b != INVALID_DATA && (BizInfo[b][bType] == BUS_CLUB || BizInfo[b][bType] == BUS_BAR || BizInfo[b][bType] == BUS_STRIP || BizInfo[b][bType] == BUS_CASINO))
		        {
			        new price;
			        if(playerSmokeCount{playerid})	ClearPlayerSmoke(playerid);
					switch(item)
					{
						case 0: //	���� ($6)
						{
							price = 6;
							if(MyGetPlayerMoney(playerid) < price)
							{
								SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "� ��� ������������ �����.");
								return false;
							}
							MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);
							PlayerAction(playerid, "�������� ������� ����.");
						}
						case 1:	//	����� ($10)
						{
							price = 10;
							if(MyGetPlayerMoney(playerid) < price)
							{
								SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "� ��� ������������ �����.");
								return false;
							}
							MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);
							PlayerAction(playerid, "�������� ������� �����.");
						}
						case 2:	//	����� ($10)
						{
							price = 10;
							if(MyGetPlayerMoney(playerid) < price)
							{
								SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "� ��� ������������ �����.");
								return false;
							}
							MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);
							PlayerAction(playerid, "�������� ������� �����.");
						}
						case 3:	//	���������� ($15)
						{
							price = 15;
							if(MyGetPlayerMoney(playerid) < price)
							{
								SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "� ��� ������������ �����.");
								return false;
							}
							MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);
							PlayerAction(playerid, "�������� ������� �����������.");
						}
						case 4:	//	��������� ($2)
						{
							price = 2;
							if(MyGetPlayerMoney(playerid) < price)
							{
								SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "� ��� ������������ �����.");
								return false;
							}
							MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
							PlayerAction(playerid, "�������� ����� ���������.");
						}
					}
					BizSaleProds(b, price, 1);
					MyGivePlayerMoney(playerid, -price);
					playerDrink{playerid} = item + 1;
					playerDrinkCount{playerid} = 5;
					return false;
				}
			}
			else
			{
				CancelSelectTextDraw(playerid);
			}
		}
		case SM_CLOTHE:
		{
			if(reponse)
			{
				ClothesItem[playerid] = item;

				if(item > 0)
				{
					InterpolateCameraPos(playerid, Arr3<ClothesShopData[ ClothesShopID[playerid] ][csd_StartCamPos]>, Arr3<ClothesShopData[ ClothesShopID[playerid] ][csd_FaceCamPos]>, 2000);
					InterpolateCameraLookAt(playerid, Arr3<ClothesShopData[ ClothesShopID[playerid] ][csd_StartCamLookAt]>, Arr3<ClothesShopData[ ClothesShopID[playerid] ][csd_FaceCamLookAt]>, 2000);
				}

				ShowPlayerSelecter(playerid, SELECTER_CLOTHE_SHOP);
				//TextDrawShowForPlayer(playerid, tdChooseButton1);
				//TextDrawShowForPlayer(playerid, tdChooseButton2);
				//PlayerTextDrawShow(playerid, tdChoosePrice);
				
				ChoosePlayerClothes(playerid, 4);

				new string[20];
				new price = 0;
				if(ClothesShopID[playerid] == 2)
				{	// donate shop
					if(GetPlayerCoins(playerid) < price)	format(string, 20, "~r~%d_coins", price);
					else 									format(string, 20, "~y~%d_coins", price);
				}
				else
				{
					if(MyGetPlayerMoney(playerid) < price)	format(string, 20, "~r~%d$", price);
					else 									format(string, 20, "~g~%d$", price);
				}
				//PlayerTextDrawSetString(playerid, tdChoosePrice, string);
			}
			else
			{
				ClothesShopID[playerid] = 0;
				ClothesShopSel[playerid] = 0;
				CancelSelectTextDraw(playerid);
				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, true);
				//ReloadPlayerSkin(playerid);
				SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(playerid) - playerid);
				DeletePVar(playerid, "Player:MenuBizID");
			}
		}
	}
	return true;
}

public OnPlayerClickSelecter(playerid, selecter, action)
{
	switch(selecter)
	{
		case SELECTER_CLOTHE_SHOP:
		{
			if(action == ACTION_SELECT)
			{
				ChoosePlayerClothes(playerid, 5);
			}
			else if(action == ACTION_CANCEL)
			{
				ChoosePlayerClothes(playerid, 0);
			}
			else if(action == ACTION_BACK)
			{
				ChoosePlayerClothes(playerid, 2);
			}
			else if(action == ACTION_NEXT)
			{
				ChoosePlayerClothes(playerid, 3);
			}
		}
	}
	return true;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	//---	Spectate
	foreach(Spectators, i)
	{
		if(SpectateID[i] == playerid)
		{
			UpdatePlayerSpectate(i, playerid);
			Timer_UpdatePlayerSpectate(i, playerid);
		}
	}
	return true;
}

Public: OnPlayerAimVehicle(playerid, vehicleid)
{
	if(PlayerInfo[playerid][pFaction] == F_POLICE && 22 <= GetPlayerWeapon(playerid) <= 33)
	{
		new targetid = VehInfo[vehicleid][vDriver];
		if(targetid != (-1))
		{
			StartPursuit(playerid, targetid);
		}
	}
	return true;
}

//	Keys
public OnPlayerClickSubmission(playerid)
{
	#if defined	_job_job_taxi_included
		Callback: Taxi_OnPlayerClickSubmission(playerid);
	#endif

	new pState = GetPlayerState(playerid);
	new vehicleid = GetPlayerVehicleID(playerid);
	if(pState == PLAYER_STATE_ONFOOT)	//	�������� �����
	{
		/*if(GetPVarInt(playerid, "Police:Pursuit:Handsup") == 0 && PursuitStatus[playerid] > PS_NONE && PlayerCuffedTime[playerid] == 0)
		{
			if(GetPlayerWeapon(playerid) != 0)
			{
				ShowPlayerHint(playerid, "����� ������� ���� �������� ������");
			}
			else
			{
				PursuitHandsup(playerid);
			}
		}
		else
		{*/
		if(PlayerInfo[playerid][pAnim] > 0)
		{
			MyApplyAnimation(playerid, PlayerAnims[ PlayerInfo[playerid][pAnim] ][PANIM_LIB], PlayerAnims[ PlayerInfo[playerid][pAnim] ][PANIM_NAME], 4.1, 0, 0, 0, 0, 0);
		}
		//}
	}
    else if(pState == PLAYER_STATE_DRIVER) // KEY_2
	{
		// ������ ������������
	#if defined	_job_job_theft_included
		if(Job.GetPlayerJob(playerid) == JOB_THEFT && TheftStatus[playerid] == 0 && !IsAvailableVehicle(vehicleid, playerid)
		&& CarInfo[vehicleid][cType] == C_TYPE_DEFAULT && (VehInfo[vehicleid][vModelType] == MTYPE_NONE || VehInfo[vehicleid][vModelType] == MTYPE_MOTO || VehInfo[vehicleid][vModelType] == MTYPE_TRUCK))
		{
			Job.SetPlayerNowWork(playerid, JOB_THEFT);
			return true;
		}
	#endif

		
		if(CarInfo[vehicleid][cType] == C_TYPE_FACTION && CarInfo[vehicleid][cOwnerID] == PlayerInfo[playerid][pFaction])
	    {
			// ������������� �� ����������
			/*if(CarInfo[vehicleid][cOwnerID] == F_POLICE)
			{
				if(!IsPoliceDuty(playerid))
	    		{
	    			return ShowPlayerHint(playerid, "��� ��������� ���������� �� ������ ���� �� ~b~���������");
	    		}
				new model = GetVehicleModel(GetPlayerVehicleID(playerid));
				if(PM_Type[playerid] == 0)
				{// �� ��������� �������
					new bool:founded, Float:curdist, Float:mindist, suspectid, vehid, mtype;
					foreach(LoginPlayer, i)
					{
						if(IsForce(PlayerInfo[i][pFaction]) || GetPlayerState(i) != 2) continue;
						//
						if(model == 497)
						{
							curdist = GetDistanceBetweenPlayers(playerid, i, true);
							if(curdist > 100)	continue;
						}
						else
						{
							curdist = GetDistanceBetweenPlayers(playerid, i);
							if(curdist > 50)	continue;
						}
						//
						vehid = GetPlayerVehicleID(i);
						//if(VehInfo[vehid][vWithEngine] == false) continue;
						mtype = VehInfo[vehid][vModelType];
						if(mtype == MTYPE_RC || mtype == MTYPE_TRAIN || mtype == MTYPE_BOAT || mtype == MTYPE_HELIC || mtype == MTYPE_PLANE) continue;
						//
						if(curdist < mindist || founded == false)
						{
							suspectid = i;
							mindist = curdist;
							founded = true;
						}
					}
					if(founded)
					{
						if(InGangZone[suspectid] >= 0 && PursuitStatus[suspectid] == PS_NONE)
						{
							return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ��������� ��������� ����� ����� �� ����� ������� ����������.");
						}
						if(IsPlayerAFK(suspectid))
						{
							return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������� ��������� � AFK, ��� ������ ����������.");
						}
						new bool:wl_veh = false;
						foreach(LoginPlayer, i)
						{
						    if(IsPlayerInVehicle(i, vehid) && GetPlayerWantedLevel(i) > 0)
						    {
						        wl_veh = true; // � ������ ������ ����� � ��������
						        break;
						    }
						}
						if(!wl_veh && PursuitLastUNIX[suspectid] > gettime())
						{
						    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ������� ���� ���������� ��� ���������.");
						}
						if(PS_NONE < PursuitStatus[suspectid] < PS_CRIMINAL)
						{
							return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ � ���������� ���� �� ���������, �� ������ �� ����.");
						}
						// ��������� �������
						if(!PursuitStatus[suspectid])
						{
							if(model == 497)
							{
								return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��������� ����� ������ ������������ � ������.");
							}
							PursuitTimer(suspectid);
							new sound = 15800;
							format(string, 128, "[%s %s:o< ��� ��������� ������� ���-������. ����������� �� �����!]", GetPlayerRank(playerid), ReturnPlayerName(playerid));
							//format(string, 128, "[%s %s:o< �������� %s, ���������� � ������� � ������������]", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(suspectid));
							SendRadiusMessage(playerid, 60.0, COLOR_YELLOW, string);
							PlayerPlaySound(playerid, sound, 0, 0, 0);
							PlayerPlaySound(suspectid, sound, 0, 0, 0);
						}
						else
						{
							format(string, 128, "[R] %s %s: {FFFFFF}����������� � ������ �� %s, �����.", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(suspectid));
							SendPoliceMessage(COLOR_BLUE, string);
						}
						if(CriminalDanger[suspectid])	format(string, 128, "~n~~n~���������� ~r~%s ~w~����� �����!", ReturnPlayerName(suspectid));
						else 							format(string, 128, "~n~~n~��������� ~b~%s ~w~�� �������� ����.", ReturnPlayerName(suspectid));
						// ���������� ���� ����� � ������, �� ������� �������� ������
						foreach(Cop, copid)
						{
						    if(PM_Type[copid] == 0 && GetPlayerVehicleID(copid) == vehicleid)
						    {
								PM_Type[copid] = 10;// ����� ������ (10 - �������������)
								PM_Place[copid] = suspectid;// �� ��������������
								PM_UNIX[copid] = gettime();// ����� ������ ������
								SendMissionMessage(copid, string, 0);// ����� �������
							}
						}
					}
					else
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���������� �� ������� �� ������ ������.");
					}
					return true;
				}
				else if(PM_Type[playerid] == 10)
				{	// ����� ������������� ��������������
					new suspectid = PM_Place[playerid];
					if(GetDistanceBetweenPlayers(playerid, suspectid) > 50)
					{
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������� ������� ������, ��������� �����.");
					}
					if(PursuitStatus[suspectid] == PS_WAIT)
					{
						return ShowPlayerHint(playerid, "���������� ���������, ��������� ��������������");
					}
					if(IsPlayerInAnyVehicle(suspectid) == 0)
					{
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������� ����� �� ������, ��������� ���.");
					}
					new nowtick = GetTickCount();
					if(PursuitTickcount[suspectid] > nowtick)
					{
						format(string, 128, "��������� ��� �����������, �� ���������� ����: ~y~%d ���", 1+(PursuitTickcount[suspectid]-nowtick)/1000);
						return ShowPlayerHint(playerid, string);
					}
					new sound = 15800;
					format(string, 128, "[%s %s:o< ��� ��������� ������� ���-������. ����������� �� �����!]", GetPlayerRank(playerid), ReturnPlayerName(playerid));
					//if(!random(2))	format(string, 128, "[%s %s:o< ���������� � ������� ��� �� ����� ��������� ��������� ����]", GetPlayerRank(playerid), ReturnPlayerName(playerid));
					//else 			format(string, 128, "[%s %s:o< �������� %s, ��������� �������������� � �� ��������� �����]", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(suspectid));
					SendRadiusMessage(playerid, 60.0, COLOR_YELLOW, string);
					PlayerPlaySound(playerid, sound, 0, 0, 0);
					PlayerPlaySound(suspectid, sound, 0, 0, 0);
					PursuitTickcount[suspectid] = nowtick + 15000;
				}
				else
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ���������� �������, ��������� � /hq.");
				}
				return true;
			}*/
			if(CarInfo[vehicleid][cOwnerID] == F_ARMY)
			{
			    if(GetVehicleModel(vehicleid) == 548)
			    {	// �������� ��� �������
					MoveVehicleTrap(playerid, vehicleid);
					return true;
			    }
			}
		}
		else if(CarInfo[vehicleid][cType] == C_TYPE_JOB)
		{
			switch(CarInfo[vehicleid][cOwnerID])
			{
			#if defined	_job_job_busdriver_included
				case JOB_BUSDRIVER:
				{
					if(Job.GetPlayerNowWork(playerid) == JOB_BUSDRIVER)
					{
						return Dialog_Show(playerid, Dialog:BusDriver_End);
					}
				}
			#endif
			#if defined	_job_job_trucker_included	
				case JOB_TRUCKER:
				{
				    if(Job.GetPlayerJob(playerid) == JOB_TRUCKER)
				    {
				    	return Dialog_Show(playerid, Dialog:Trucker_TrailerList);
					}
				}
			#endif

				case JOB_MECHANIC:
			    {
			    	if(Job.GetPlayerNowWork(playerid) != JOB_MECHANIC)
			        {
			            return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� �� ���������, ����� ��������� �����.");
			        }
			        if(MechanicCall == (-1))
			        {
			            return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��������� ������ ����� �� ������� ��������.");
			        }
			        if(MechanicStatus[playerid] > 0 || MechanicClientid[playerid] != INVALID_PLAYER_ID)
			        {
			            return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��� ������� �����.");
			        }
			        new string[128];
					format(string, sizeof(string), "* ������� {FFFFFF}%s[%d]{44B2FF} ������ ����� ������� %s", ReturnPlayerName(playerid), playerid, ReturnPlayerName(MechanicCall));
					SendJobMessage(JOB_MECHANIC, COLOR_LIGHTBLUE, string);
				    format(string, sizeof(string), "~n~~n~~n~������ ~y~%s~w~ ������� ���.", ReturnPlayerName(MechanicCall));
				    SendMissionMessage(playerid, string, 0);

			    	SendFormatMessage(MechanicCall, COLOR_LIGHTBLUE, string, "������� {FFFFFF}%s{44B2FF} ������ ��� �����. ����������� �� �����!", ReturnPlayerName(playerid));
				    format(string, sizeof(string), "~n~~n~~n~������� ~y~%s~w~ ������ ��� �����.", ReturnPlayerName(playerid));
			    	SendMissionMessage(MechanicCall, string);

					MechanicStatus[playerid] = 1;
					MechanicClientid[playerid] = MechanicCall;
			        MechanicCall = -1; MechanicCallTime = 0;
			        return true;
			    }
			}
		}
		else if(CarInfo[vehicleid][cType] == C_TYPE_PARTJOB)
		{
		#if defined	_job_part_farmer_included
			if(CarInfo[vehicleid][cOwnerID] == PART_FARMER)
			{
				//new farmid = FarmPlayer[playerid];
				new model = GetVehicleModel(vehicleid);
		        /*if(model == 531)
				{	//  �������
				    if(gType_CP[playerid] != CPJOB_FARM)
				    {
						if(FarmInfo[farmid][fStatus] == FSTATUS_GROWTH)
						{
                   			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� �������, �������� ���� �������� ��������.");
						}
						else if(FarmInfo[farmid][fStatus] == FSTATUS_GATHER)
						{
							SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ��� �������, ����������� ������� � ����� ��� ����� �������.");
						}
						else if(FarmInfo[farmid][fWork] != (-1))
						{
						    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ��� �������������� ������ �������.");
						}
						else
						{
							if(GetVehicleModel(GetVehicleTrailer(vehicleid)) != 610)
							{
								SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ���������� ���������� ������ � �������� (NUM 2 ��� /tow)");
							}
							else
							{
								SendMissionMessage(playerid, "������� ~r~����~w~ ��������.", 5000, true);
		                		MySetPlayerCheckpoint(playerid, CPJOB_FARM, Arr3<FarmGrassPos[farmid][ FarmInfo[farmid][fCount] ]>, 5.0);
							}
						}
						return true;
					}
				}
				else if(model == 532)
				{	//  �������
			     	if(gType_CP[playerid] != CPJOB_FARM)
				    {
					    if(FarmInfo[farmid][fStatus] == FSTATUS_GROWTH)
					    {
                   			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� �������, �������� ���� �������� ��������.");
					    }
					    else if(FarmInfo[farmid][fStatus] == FSTATUS_PLANTED)
					    {
					    	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ��� �� �������.");
					    }
					    else if(FarmInfo[farmid][fWork] != (-1))
					    {
						    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ��� �������������� ������ �������.");
					    }
                        else
						{
							if(FarmInfo[farmid][fCount] < FarmInfo[farmid][fMaxCount])
							{
                        		SendMissionMessage(playerid, "������� ������ �� ~r~����~w~.", 5000, true);
                        		MySetPlayerCheckpoint(playerid, CPJOB_FARM, Arr3<FarmGrassPos[farmid][ FarmInfo[farmid][fCount] ]>, 5.0);
                                FarmInfo[farmid][fWork] = playerid;
							}
							else
							{
								SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ��� ������, ����������� ����� ��� �����.");
							}
						}
					}
				}
				else */
				if(model == 478)
				{	//  �����
				    if(g_FarmPlayerVID[playerid] == vehicleid && g_FarmVehiclePoint[playerid])
				    {
						FarmDeleteVPoint(playerid);
				    }
				    else
				    {
				    	FarmCreateVPoint(playerid, vehicleid);
				    }
				}
				return true;
			}
		#endif		
		#if defined	_job_part_delivery_included
			if(CarInfo[vehicleid][cOwnerID] == PART_DELIVERY)
			{
				if(DeliveryVehLoadCount[vehicleid] > 0)
				{
					return Dialog_Show(playerid, Dialog:Delivery_Biz);
				}
			}
		#endif	
		}

		new mtype = VehInfo[vehicleid][vModelType];
		if(mtype != MTYPE_RC && mtype != MTYPE_TRAIN && mtype != MTYPE_BOAT && mtype != MTYPE_HELIC && mtype != MTYPE_PLANE)
		{
			ShowDialog(playerid, DMODE_GPS);
		}
	}
	else if(pState == PLAYER_STATE_PASSENGER)
	{
		if(GetPVarInt(playerid, "Roped") == 0 && VehParams[GetVehicleModel(vehicleid) - 400][VEH_MTYPE] == MTYPE_HELIC)
		{
			GetPlayerPos(playerid, Arr3<RopePos[playerid]>);
			MapAndreas_FindZ_For2DCoord(RopePos[playerid][0], RopePos[playerid][1], RopePos[playerid][3]);
			RopePos[playerid][4] = floatsub(RopePos[playerid][2], RopePos[playerid][3]);
			if(RopePos[playerid][4] >= ROPE_LENGTH)	ShowPlayerHint(playerid, "� ���� ������ ������ ���������� �� �������");
			else if(RopePos[playerid][4] <= 2)		RemovePlayerFromVehicle(playerid);
			else
			{
				for(new z = 0; z <= RopePos[playerid][4]; z++)
				    RopeObjects[playerid][z] = CreateDynamicObject(3004, RopePos[playerid][0], RopePos[playerid][1], floatsub(RopePos[playerid][2], z), 87.64, 342.135, 350.075);
				SetPVarInt(playerid, "Roped", vehicleid);
				SetPlayerPos(playerid, RopePos[playerid][0], RopePos[playerid][1], floatsub(RopePos[playerid][2], 2));
				SetPlayerVelocity(playerid, 0, 0, 0);
				ApplyAnimation(playerid, "ped", "abseil", 4.0, 0, 0, 0, 1, 0);
				SetTimerEx("SyncRopeAnim", 250, 0, "i", playerid);
				MySetPlayerCheckpoint(playerid, CPPOLICE_ROPE, RopePos[playerid][0], RopePos[playerid][1], floatsub(RopePos[playerid][3], 12), 20.0);
			}
		}
		//	����������� � ������ ����������-������
		/*else if(PlayerInfo[playerid][pFaction] == F_POLICE && PM_Type[playerid] == 0 && VehInfo[vehicleid][vDriver] >= 0)
		{
			new driver = VehInfo[vehicleid][vDriver];
			if(PlayerInfo[driver][pFaction] == F_POLICE && PM_Type[driver] == 10)
			{
				if(!IsPoliceDuty(playerid))
	    		{
	    			return ShowPlayerHint(playerid, "��� ������������� � ������ �� ������ ���� �� ~b~���������");
	    		}
	    		new suspectid = PM_Place[driver];
	    		if(PS_NONE < PursuitStatus[suspectid] < PS_CRIMINAL)
	    		{
	    			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ � ���������� ���� �� ���������, �� ������ �� ����.");
	    		}
				// ��������� �������
				format(string, 128, "[R] %s %s: {FFFFFF}����������� � ������ �� %s, �����.", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(suspectid));
				SendPoliceMessage(COLOR_BLUE, string);
				PM_Type[playerid] = 10;			// ����� ������ (10 - �������������)
				PM_Place[playerid] = suspectid;	// �� ��������������
				PM_UNIX[playerid] = gettime();	// ����� ������ ������
				if(CriminalDanger[suspectid])	format(string, 128, "~n~~n~���������� ~r~%s ~w~����� �����!", ReturnPlayerName(suspectid));
				else 							format(string, 128, "~n~~n~��������� ~b~%s ~w~�� �������� ����.", ReturnPlayerName(suspectid));
				SendMissionMessage(playerid, string, 0);	// ����� �������
			}
		}*/
	}
	return true;
}

public	OnPlayerClickY(playerid)
{
	new newkeys, tmp;
	GetPlayerKeys(playerid, newkeys, tmp, tmp);
	// if(HOLDING(KEY_SPRINT))		//	������ + Y
	// {
	// 	// ������� �������
	// 	// if(AskWhat[playerid])
	// 	// {
	// 	// 	OnPlayerYNStateChange(playerid, AskWhat[playerid], true);
	// 	// 	return true;
	// 	// }
	// }
	// else 
	if(HOLDING(KEY_AIM))	//	������ + Y
	{
		// ���� ��������������
		new targetid = GetPlayerTargetPlayer(playerid);
		if(IsPlayerLogged(targetid))
		{	// Reaction with Players
			new _str[4];
			valstr(_str, targetid);
			return callcmd::action(playerid, _str);
		}

		// targetid = GetPlayerTargetActor(playerid);
		// if(targetid != INVALID_ACTOR_ID)
		// {
		// 	return OnActorReaction(playerid, targetid);
		// }

		new tick = GetTickCount();
		if(tick - StartupAntiflood[playerid] < 800)
		{
		    StartupAntiflood[playerid] = tick;
		    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��� ������.");
		    return false;
		}
		else
		{
			targetid = GetNearVehicles(playerid);
			if(targetid > 0)	PlayerOpenVehicle(playerid, targetid);
		}
		StartupAntiflood[playerid] = tick;
		return true;
	}
	else
	{
		new pState = GetPlayerState(playerid);
		if(pState == PLAYER_STATE_ONFOOT)
		{	
			if(GetPVarType(playerid, "Player:InAmmoZone") == PLAYER_VARTYPE_INT)
			{
				new str[32];
				new vw = GetPlayerVirtualWorld(playerid);
				new ammo_zone = GetPVarInt(playerid, "Player:InAmmoZone");
				new item = ((ammo_zone >= sizeof(AmmuList)) ? (ammo_zone % sizeof(AmmuList)) : ammo_zone);
				new price;
				new Float:PlayerCameraPos[3],
					Float:PlayerCameraVector[3];
				GetPlayerCameraPos(playerid, Arr3<PlayerCameraPos>);
				GetPlayerCameraFrontVector(playerid, Arr3<PlayerCameraVector>);
				PlayerCameraVector[0] = PlayerCameraPos[0] + floatmul(PlayerCameraVector[0], 5.0);
				PlayerCameraVector[1] = PlayerCameraPos[1] + floatmul(PlayerCameraVector[1], 5.0);
				PlayerCameraVector[2] = PlayerCameraPos[2] + floatmul(PlayerCameraVector[2], 5.0);
				TextDrawHideForPlayer(playerid, TD_PressH);
				//	LSPD Ammo
				if(AmmuList[item] == 99)
				{
					price = floatround(200 * ((vw == VW_LSPD) ? 0.2 : 1.0));
					format(str, sizeof(str), "����������");
				}
				else
				{
					price = floatround(GunParams[ AmmuList[item] ][GUN_PRICE] * ((vw == VW_LSPD) ? 0.2 : 1.0));
					format(str, sizeof(str), "%s (%d ��)", GunParams[ AmmuList[item] ][GUN_NAME], GunParams[ AmmuList[item] ][GUN_AMMO]);
				}
				new string[64];
				format(string, sizeof(string), "%s~n~����: $%d", str, price);
				ShowPlayerBuyMenu(playerid, OBJECT_WEAPON, string, "������");
				if(ammo_zone == 0)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 310.00, -163.73, 1000.32, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 310.96, -160.33, 996.78, 1000);
				}
				else if(ammo_zone == 1)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 311.55, -163.67, 1000.36, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 310.00, -160.49, 996.83, 1000);
				}
				else if(ammo_zone == 2)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 311.74, -160.81, 1000.32, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 310.23, -164.37, 997.15, 1000);
				}
				else if(ammo_zone == 3)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 309.82, -161.10, 1000.31, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 311.72, -164.08, 996.77, 1000);
				}
				else if(ammo_zone == 4)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 314.39, -163.76, 1000.39, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 315.31, -160.35, 996.85, 1000);
				}
				else if(ammo_zone == 5)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 316.01, -163.69, 1000.39, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 314.55, -160.48, 996.85, 1000);
				}
				else if(ammo_zone == 6)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 315.98, -160.98, 1000.39, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 314.42, -164.17, 996.88, 1000);
				}
				else if(ammo_zone == 7)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 314.16, -161.06, 1000.39, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 316.10, -164.01, 996.86, 1000);
				}
				else if(ammo_zone == 8)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 310.02, -159.82, 1000.04, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 307.75, -156.32, 997.29, 1000);
				}
				else if(ammo_zone == 9)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 314.18, -159.41, 1000.72, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 312.01, -156.03, 997.75, 1000);
				}
				else if(ammo_zone == 10)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 317.93, -160.50, 1000.16, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 322.24, -157.50, 999.49, 1000);
				}
				//----
				else if(ammo_zone == 11)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 289.50, -35.35, 1002.19, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 292.54, -32.85, 999.11, 1000);
				}
				else if(ammo_zone == 12)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 289.47, -33.47, 1002.19, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 292.82, -35.58, 999.13, 1000);
				}
				else if(ammo_zone == 13)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 291.47, -34.45, 1002.19, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 288.29, -36.74, 999.08, 1000);
				}
				else if(ammo_zone == 14)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 291.62, -34.38, 1002.25, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 288.36, -32.55, 998.93, 1000);
				}
				else if(ammo_zone == 15)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 293.41, -34.34, 1002.27, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 296.62, -32.35, 999.00, 1000);
				}
				else if(ammo_zone == 16)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 293.42, -34.70, 1002.27, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 296.88, -35.43, 998.74, 1000);
				}
				else if(ammo_zone == 17)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 295.57, -34.53, 1002.36, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 292.52, -36.40, 998.87, 1000);
				}
				else if(ammo_zone == 18)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 295.63, -34.18, 1002.20, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 291.99, -33.04, 998.96, 1000);
				}
				else if(ammo_zone == 19)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 293.74, -38.50, 1002.46, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 293.71, -42.04, 998.92, 1000);
				}
				else if(ammo_zone == 20)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 299.43, -36.26, 1002.54, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 303.39, -35.73, 999.54, 1000);
				}
				else if(ammo_zone == 21)
				{
					InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 297.00, -37.70, 1002.21, 1000);
					InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 301.27, -39.86, 1000.77, 1000);
				}
				return true;
			}
		}

		#if defined _player_phone_included
			if(Phone_GetStatus(playerid) == PHONE_CALL)
			{
				return callcmd::p(playerid, "");	//  accept call
			}
		#endif

		#if defined	_job_job_taxi_included
			Callback: Taxi_OnPlayerClickY(playerid);
		#endif

		// ����������� ������
		/*if(PlayerInfo[playerid][pFaction] == F_POLICE)
	    {
	    	if(!IsPoliceDuty(playerid))
	    	{
	    		return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "��� �������� ������ �� ������ ���� �� ���������.");
	    	}
	        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || IsCopCar(vehicleid) == 0)
			{
			    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ����������� ������ �� ����� ����������� ������.");
			}
	        PoliceMissionAccept(playerid);
	    }
	    
	    else
	    {*/
	    //	inventory
	    callcmd::i(playerid, "");
	    //}
	}
	return true;
}

public	OnPlayerClickN(playerid)
{
	new newkeys, tmp;
	GetPlayerKeys(playerid, newkeys, tmp, tmp);
	// if(HOLDING(KEY_SPRINT))	//	������+N
	// {
	// 	// if(AskWhat[playerid])
	// 	// {	// ������� �������
	// 	// 	OnPlayerYNStateChange(playerid, AskWhat[playerid], false);
	// 	// }
	// }
	// else
	// {
	#if defined _player_phone_included
		if(Phone_GetStatus(playerid) != PHONE_OFF)
		{
			return callcmd::h(playerid, "");	//  cancel call
		}
	#endif

	CancelPlayerBerth(playerid);
	// }
	return true;
}

public	OnPlayerClickH(playerid)
{
	new pState = GetPlayerState(playerid);
	if(pState == PLAYER_STATE_ONFOOT)
	{	// ���� ��������������
		new house = GetPlayerHouseID(playerid);
		new biz = GetBizWhichPlayer(playerid);
		if(house != (-1) && HouseInfo[house][hOwnerID] == PlayerInfo[playerid][pUserID])
		{
			ShowDialog(playerid, DHOME_MAIN);	// Reaction with House
	    }
	    else if(biz != INVALID_DATA && BizInfo[biz][bOwnerID] == PlayerInfo[playerid][pUserID])
	    {
	    	ShowDialog(playerid, DBIZ_MANAGE);	// Reaction with Biz
	    }
	    else
	    {
			ShowDialog(playerid, DMENU_MAIN);	// Reaction with youself
	    }
	}
	else if(pState == PLAYER_STATE_DRIVER)
	{
        if(IsVehicleWithEngine(GetPlayerVehicleID(playerid)))
		{
        	/*if(CarInfo[vehicleid][cType] == C_TYPE_FACTION && CarInfo[vehicleid][cOwnerID] == PlayerInfo[playerid][pFaction])
	    	{
	    		if(CarInfo[vehicleid][cOwnerID] == F_POLICE)
				{
					if(PM_Type[playerid] == 10)
					{	// ����� ������������� ��������������
						new suspectid = PM_Place[playerid];
						if(PS_NONE < PursuitStatus[suspectid] < PS_CRIMINAL)
						{
							return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ � ���������� ���� �� ���������.");
						}
						if(PursuitReinforcReload[playerid])
						{
							return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������ ������� ��� �������������.");
						}
						PursuitReinforc[playerid] = 1;
						return true;
					}
				}
	    	}*/
	    	ShowDialog(playerid, DMODE_RADIO);
        }
    }
    return true;
}

public	OnPlayerClickAlt(playerid)
{
	new pState = GetPlayerState(playerid);
	if(pState == PLAYER_STATE_ONFOOT)
	{
		if(PlayerCuffedTime[playerid] == 0)
    	{
    		/*if(GetPVarInt(playerid, "Police:Pursuit:Handsup") && PursuitStatus[playerid] > PS_NONE && PlayerCuffedTime[playerid] == 0)
			{
				PursuitCancelHandsup[playerid] = 1;
				return true;
			}*/
			if(Job.GetPlayerJob(playerid) == JOB_THEFT)
        	{	//	������ ������ ����� �����
				new vehicleid = GetNearVehicles(playerid, 1);
	            if(vehicleid != 0)
	            {
		            if(IsAvailableVehicle(vehicleid, playerid) && CarInfo[vehicleid][cType] == C_TYPE_PLAYER) return true;
		            if(VehInfo[vehicleid][vPlayers] > 0)	return true;
	            	if(ItemStockPlayer(playerid, THING_PICKLOCK) == 0)
				    	return GameTextForPlayer(playerid, RusText("~y~� ��� ��� �������", isRus(playerid)), 2000, 4);
				    SetPVarInt(playerid, "StartLockTimer", SetPlayerTimerEx(playerid, "PlayerUseThing", 1000, 0, "dd", playerid, THING_PICKLOCK));
				    return true;
	            }
            }
          
			//	�����
    		/*if(PlayerInfo[playerid][pFaction] == F_POLICE && IsPoliceDuty(playerid))
    		{
				foreach(LoginPlayer, i)
				{
		    		if(GetDistanceBetweenPlayers(playerid, i) < 2.0 && GetPlayerState(i) == PLAYER_STATE_ONFOOT)
		    		{
		    			if(CriminalDanger[i] || (PM_Type[playerid] == 10 && PM_Place[playerid] == i && (GetPlayerWantedLevel(i) > 3 || PursuitAllowArrest[i])))
		    			{
			    			if(GetPVarInt(i, "Police:Arrest") == 1)
			    			{
			    				return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "������ ��� ������������ ������ �����������.");
			    			}
							if(GetPVarInt(i, "Police:Pursuit:Handsup"))
							{
								MyApplyAnimation(playerid, "INT_SHOP", "shop_loop", 4.1, 1, 0, 0, 0, 0);
							}
							else if(PlayerCuffedTime[i])
							{
								MyApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 0, 1, 1, 1, 0);
							}
							else
							{
								return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "����� ������ ������� ���� ��� ���� �������.");
							}
							PursuitArest[playerid] = 1;
							PursuitArestPlayer[playerid] = i;
							SetPVarInt(i, "Police:Arrest", 1);
							GameTextForPlayer(i, "~r~A ~b~r ~r~r ~b~e ~r~s ~b~t", 500, 3);
							GameTextForPlayer(playerid, "~r~A ~b~r ~r~r ~b~e ~r~s ~b~t", 500, 3);
							return true;
						}
					}
		    	}
	    	}*/
    	}
	}
	return true;
}

public	OnPlayerClickEnter(playerid)
{
	new pState = GetPlayerState(playerid);
	if(pState == PLAYER_STATE_ONFOOT)
    {
    	// ������ ����� � �����
    	if(callcmd::throw(playerid, "999"))	
        {
        	return true;
        }
        if(Inv.GetPlayerNearTrashcan(playerid) != INVALID_DATA)
        {
        	ShowPlayerInventory(playerid, TYPE_TRASHCAN);
        	return true;
        }

    	//  ������� ����� � �������� ����
        if(GetPlayerComb(playerid) == COMB_NONE)
        {
			new v = GetNearVehicles(playerid, 1);// ������ ���� ��� ������ (��������, � �.�.)
            if(v)
            {
				if(!IsAvailableVehicle(v, playerid) && CarInfo[v][cType] != C_TYPE_PLAYER && Job.GetPlayerJob(playerid) == JOB_THEFT)
				{
					if(VehInfo[v][vPlayers] == 0)
					{
	            		SetPVarInt(playerid, "StartLockTimer", SetPlayerTimerEx(playerid, "BreakCar", 1000, 0, "ddd", playerid, BREAK_CAR_B_GLASS, 0));
						SetPVarInt(playerid, "LastLockCar", v);
					}
				}
				else
				{
					GameTextForPlayer(playerid, RusText("~r~������ �������!", PlayerInfo[playerid][pRusifik]), 3000, 4);
				}
				return true;
            }
		}

		if(Button_OnPlayerClickEnter(playerid))
		{
			return true;
		}

        // �������� ������
		if(IsPlayerInRangeOfPoint(playerid, 1.5, 320.41678,1023.88660,1951.0))
		{	// ��������� ������ � ��������� ��������� (�����)
			if(MyApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 8.0, 0, 0, 0, 0, 0))
			{
		    	MoveVehicleTrap(playerid, GetPlayerVirtualWorld(playerid));
			}
			return true;
			//PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
		}

        if(robbery_biz[playerid] >= 0)// && robbery_offerid[playerid] == playerid) // [bt]
        {	// ���������� ��������
        	new b = robbery_biz[playerid], Float:pos[4];
        	GetActorPos(BizInfo[b][bActor], Arr3<pos>);
        	GetActorFacingAngle(BizInfo[b][bActor], pos[3]);
        	if(IsPlayerInRangeOfPoint(playerid, 3.0, Arr3<pos>))
        	{
        		robbery_timer[playerid] = SetTimerEx("Robbering", 900, 1, "i", playerid);
        		SetPlayerFacingAngle(playerid, pos[3] - 180.0);
				SetPlayerArmedWeapon(playerid, 0);
				TogglePlayerControllable(playerid, false);

				// ������ ������
				new string[128];
				mysql_format(g_SQL, string, sizeof(string), "SELECT `cam_x`, `cam_y`, `cam_z` FROM %s.`locations` WHERE `id` = '%d'", MAIN_DB, BizInfo[b][bLocation]);
				new Cache:result = mysql_query(g_SQL, string);
				new Float:cam_x, Float:cam_y, Float:cam_z;
			  	cache_get_value_index_float(0, 0, cam_x);
			   	cache_get_value_index_float(0, 1, cam_y);
			   	cache_get_value_index_float(0, 2, cam_z);
			    if(cam_x != 0.0 && cam_y != 0.0 && cam_z != 0.0)
			    {
			    	SetPlayerCameraPos(playerid, cam_x, cam_y, cam_z);
					GetPlayerPos(playerid, Arr3<pos>);
					SetPlayerCameraLookAt(playerid, Arr3<pos>);

					IFace.ToggleGroup(playerid, IFace.CAM_EFFECT, true);
			    }
			    cache_delete(result);
			    return true;
        	}
        }

        //	������ �������������
        if(IsPlayerInDynamicArea(playerid, StripZone[0]) || IsPlayerInDynamicArea(playerid, StripZone[1]))
    	{
    	    if(MyGetPlayerMoney(playerid) < 50)
    	    {
    	        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
    	        return 1;
    	    }
    		if(random(2))	MyApplyAnimation(playerid, "STRIP", "PLY_CASH", 4.1, 0, 1, 1, 0, 0);
    		else 			MyApplyAnimation(playerid, "STRIP", "PUN_CASH", 4.1, 0, 1, 1, 0, 0);
    		MyGivePlayerMoney(playerid, -50);
    		new b = GetBizWhichPlayer(playerid);
    		if(b != INVALID_DATA && BizInfo[b][bType] == BUS_STRIP)
    		{
    			BizSaleProds(b, 50, 1);
    		}
    		return true;
    	}

    	//	�����
	 	if(GetPVarType(playerid, "pkrTableID") == 0)
		{
			for(new t = 0; t < MAX_POKERTABLES; t++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 1.5, PokerTable[t][pkrX], PokerTable[t][pkrY], PokerTable[t][pkrZ]))
				{
					if(PokerTable[t][pkrPass][0] != EOS)
					{
						/*if(!strcmp(params, PokerTable[t][pkrPass], false, 32))
						{
							JoinPokerTable(playerid, t);
						}
						else
						{
							//return SendClientMessage(playerid, COLOR_WHITE, "Usage: /jointable (password)");
							JoinPokerTable(playerid, t);
						}*/
					}
					else JoinPokerTable(playerid, t);
					return true;
				}
			}
		}
		for(new i = 0; i < MAX_CHIPMACHINES; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 5.0, ChipMachine[i][cmX], ChipMachine[i][cmY], ChipMachine[i][cmZ]))
			{
				GlobalPlaySound(6400, ChipMachine[i][cmX], ChipMachine[i][cmY], ChipMachine[i][cmZ]);
				return ShowDialog(playerid, DCHIPS_MENU);
			}
		}

		// ���������
		if(GetPlayerVirtualWorld(playerid) == VW_HOSPITAL && GetPVarType(playerid, "Player:Hospital:Berth") == PLAYER_VARTYPE_NONE)
		{
			for(new i = 0; i < sizeof(HospitalBerth); i++)
	    	{
	    		if(IsPlayerInRangeOfPoint(playerid, 2.5, Arr3<HospitalBerth[i][0]>))
	    		{
	    			if(MyGetPlayerHealth(playerid) >= 100)
	    			{
	    				return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "�� ��������� �������.");
	    			}
	    			if(BerthStatus[i] == true)
	    			{
	    				return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "��� ����� ������, �������� ������.");
	    			}
	    			TogglePlayerStreamerAllItem(playerid, false);
	    			UpdateDynamic3DTextLabelText(Berth3DText[i], 0x007CADFF, " ");
	    			MySetPlayerPos(playerid, Arr4<HospitalBerth[i][0]>);
	    			MyApplyAnimation(playerid, "CRACK", "crckidle2", 4.1, 1, 0, 0, 1, 0);
					SetPVarInt(playerid, "Player:Hospital:Berth", i);
					BlockPlayerAnimation(playerid, true);
					BerthStatus[i] = true;
					return true;
	    		}
	    	}
		}
	}
	return true;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	new string[128];
	if(showDebug[playerid])
	{	
		SendFormatMessage(playerid, COLOR_WHITE, string, "Key Pressed: newkeys[%d], oldkeys[%d]", newkeys, oldkeys);	
	}

	Callback:Walk_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#if defined	_job_part_loader_included
		Callback:Loader_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#endif
	#if defined _system_combinations_included
		Callback:Comb_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#endif
	#if defined _interface_hack_lock_included
		Callback:HackLock_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#endif	
	#if defined _gang_gang_zones_included
		Callback:Gang.GZ_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#endif
	// #if defined _police_pursuit_included
	// 	Callback:Pursuit_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	// #endif

	// ������� �������������� �����
	if(redit_act[playerid] > 0)
	{
	    if(redit_act[playerid] == 2)
	    {// ����� �����
		    new vehicleid = GetPlayerVehicleID(playerid);
		    if((vehicleid == 0 && PRESSED(KEY_AIM)) || (vehicleid > 0 && PRESSED(KEY_FIRE)))
		    {// �������� ����� �����
		        new Float:X, Float:Y, Float:Z, Float:A;
		        if(vehicleid == 0)  MyGetPlayerPos(playerid, X, Y, Z, A);
				else				MyGetVehiclePos(vehicleid, X, Y, Z, A);
				mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `race_spawn` SET `raceid` = '%d', `x` = '%.2f', `y` = '%.2f', `z` = '%.2f', `a` = '%.2f'", redit_id[playerid], X, Y, Z, A);
				mysql_query_ex(string);
				format(string, 128, "����� #%d: ��������� ����� ����� ����� [#%d]. {FFFFFF}/race - ���������", redit_id[playerid], redit_num[playerid]);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
				redit_num[playerid] += 1;

		        if(redit_num[playerid] >= sizeof(RaceSpawn)-1)
		        {
					format(string, 128, "����� #%d: ��������� ����� ����� �����", redit_id[playerid]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
		            callcmd::race(playerid, "");
		        }
		        return true;
		    }
	    }
	    else if(redit_act[playerid] == 3)
	    {// ���������
		    new vehicleid = GetPlayerVehicleID(playerid);
		    if((vehicleid == 0 && PRESSED(KEY_AIM)) || (vehicleid > 0 && PRESSED(KEY_FIRE)))
		    {// ������� ��������
		        new Float:X, Float:Y, Float:Z;
		        if(vehicleid == 0)  GetPlayerPos(playerid, X, Y, Z);
				else				GetVehiclePos(vehicleid, X, Y, Z);
				//---
				if(redit_curid[playerid] == 0)
				{// ������� ���������� ���
				    new Float:X2, Float:Y2, Float:Z2, Float:size;
				    if(redit_previd[playerid] > 0)
				    {
						mysql_format(g_SQL, string, sizeof(string), "SELECT `x`, `y`, `z`, `size` FROM `race_cp` WHERE `id` = '%d'", redit_previd[playerid]);
						new Cache:result = mysql_query(g_SQL, string);
						if(cache_num_rows() > 0)
						{
						    cache_get_value_index_float(0, 0, X2);
						    cache_get_value_index_float(0, 1, Y2);
						    cache_get_value_index_float(0, 2, Z2);
						    cache_get_value_index_float(0, 3, size);
					    }
					    cache_delete(result);
				    }
					//---
					if(X2 && Y2 && IsPlayerInRangeOfPoint(playerid, size+10.0, X2, Y2, Z2))
			        {// ��������� ����������
						mysql_format(g_SQL, string, sizeof(string), "UPDATE `race_cp` SET `x` = '%0.2f', `y` = '%0.2f', `z` = '%0.2f' WHERE `id` = '%d'", X, Y, Z, redit_previd[playerid]);
						mysql_query_ex(string);
						SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "����� #%d: �������� ������� �������� [#%d | %.1f]. {FFFFFF}/race - ���������", redit_id[playerid], redit_num[playerid]-1, size);
				        ShowPlayerEditCP(playerid, redit_num[playerid]-1);
			        }
			        else
			        {// ��������� �����
				        if(redit_num[playerid] >= sizeof(RaceCP) - 1)
				        {
							SendFormatMessage(playerid, COLOR_YELLOW, string, "����� #%d: ��������� ����� ����������", redit_id[playerid]);
				            return callcmd::race(playerid, "");
				        }
						mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `race_cp` SET `raceid` = '%d', `x` = '%.2f', `y` = '%.2f', `z` = '%.2f', `size` = '%.2f'", redit_id[playerid], X, Y, Z, redit_size[playerid]);
						mysql_query_ex(string);
						SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "����� #%d: �������� ����� �������� [#%d | %.1f]. {FFFFFF}/race - ���������", redit_id[playerid], redit_num[playerid], redit_size[playerid]);
			        	redit_previd[playerid] = ShowPlayerEditCP(playerid, redit_num[playerid]++);
				        redit_curid[playerid] = 0;
			        }
				}
				else
				{// ������� ��������� ����
				    new Float:X2, Float:Y2, Float:Z2;
					mysql_format(g_SQL, string, sizeof(string), "SELECT `x`, `y`, `z` FROM `race_cp` WHERE `id` = '%d'", redit_curid[playerid]);
					new Cache:result = mysql_query(g_SQL, string);
					if(cache_num_rows() > 0)
					{
					    cache_get_value_index_float(0, 0, X2);
					    cache_get_value_index_float(0, 1, Y2);
					    cache_get_value_index_float(0, 2, Z2);
				    }
				    cache_delete(result);
					//
					if(X2 && Y2 && IsPlayerInRangeOfPoint(playerid, redit_size[playerid]+10.0, X2, Y2, Z2))
			        {// ��������� �������
						mysql_format(g_SQL, string, sizeof(string), "UPDATE `race_cp` SET `x` = '%0.2f', `y` = '%0.2f', `z` = '%0.2f' WHERE `id` = '%d'", X, Y, Z, redit_curid[playerid]);
						mysql_query_ex(string);
						SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "����� #%d: �������� ������� �������� [#%d | %.1f]. {FFFFFF}/race - ���������", redit_id[playerid], redit_num[playerid], redit_size[playerid]);
			        	redit_previd[playerid] = redit_curid[playerid];
				        redit_curid[playerid] = ShowPlayerEditCP(playerid, redit_num[playerid]);
			        }
			        else
			        {// ���������� ������� ������
			            ShowDialog(playerid, DRACE_DELCP);
			        }
		        }
		        return true;
		    }
		    if(PRESSED(KEY_ANALOG_LEFT) || PRESSED(KEY_ANALOG_RIGHT))
		    {	// ��������� ������
		        new cpnum, cpid = 0;
		        if(redit_curid[playerid] > 0)
				{
					cpid = redit_curid[playerid];
					cpnum = redit_num[playerid];
				}
		        else if(redit_previd[playerid] > 0)
				{
					cpid = redit_previd[playerid];
					cpnum = redit_num[playerid]-1;
				}
		        else
		        {
		            return ShowPlayerHint(playerid, "������: �������� ��������");
		        }
		        if(PRESSED(KEY_ANALOG_LEFT)) redit_size[playerid] -= 0.5;
		        else redit_size[playerid] += 0.5;
				mysql_format(g_SQL, string, sizeof(string), "UPDATE `race_cp` SET `size` = '%0.2f' WHERE `id` = '%d'", redit_size[playerid], cpid);
				mysql_query_ex(string);
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "����� #%d: �������� ������� �������� [#%d | %.1f]. {FFFFFF}/race - ���������", redit_id[playerid], cpnum, redit_size[playerid]);
				ShowPlayerEditCP(playerid, cpnum);
		        return true;
		    }
	    }
	}

	// OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
	new pState = GetPlayerState(playerid);
	new vehicleid = GetPlayerVehicleID(playerid);
	if(pState == PLAYER_STATE_SPECTATING)
	{
		if(SpectateID[playerid] != INVALID_PLAYER_ID)
		{
		    SelectTextDraw(playerid, 0xFCEC3AFF);
		}
	}
	else if(pState == PLAYER_STATE_ONFOOT) //  ������
	{
		if(newkeys & KEY_FIRE || (newkeys & KEY_HANDBRAKE && newkeys & KEY_SECONDARY_ATTACK))
		{
			SetPVarInt(playerid, "Player:LastAttack", GetTickCount());
		}

		if(newkeys & KEY_JUMP && GetPlayerSpeed(playerid, true) > 10)
		{
			new gtc = GetTickCount();
			if(gtc > GetPVarInt(playerid, "Player:BunnyHop:GTC") + 5000)
			{
				SetPVarInt(playerid, "Player:BunnyHop:GTC", gtc);
			}
			else
			{
				SetPVarInt(playerid, "Player:BunnyHop:GTC", gtc + 5000);
				DeletePVar(playerid, "Player:AntiBunnyHop:Timer");
				SetPVarInt(playerid, "Player:AntiBunnyHop:Timer", SetTimerEx("AntiBunnyHop", 400, 0, "d", playerid));
			}
		}
		//	�������� �� ����������� �������� � ������ � ������� ����
		if(p_FellAnim[playerid] == false)
		{
			if(PRESSED(KEY_JUMP))
			{
				if(PlayerInfo[playerid][pJailTime] && GetPlayerComb(playerid) == COMB_NONE)
				{
					new Keys, ud, lr;
   	 				GetPlayerKeys(playerid, Keys, ud, lr);
   	 				if(ud || lr)
   	 				{
   	 					p_FellAnim[playerid] = true;
					    ClearAnimations(playerid);
			        	MyApplyAnimation(playerid, "PED", "KO_SKID_BACK", 4.1, 0, 0, 0, 0, 0);
			        	SetTimerEx("ClearJailFall", 600, 0, "d", playerid);
						ShowPlayerHint(playerid, "� ������ ~r~���������~w~: ~n~������� � �������");
						return true;
   	 				}
				}
			}
			if((PRESSED(KEY_FIRE) || PRESSED(KEY_SECONDARY_ATTACK | KEY_HANDBRAKE)))
			{
				if(GetPlayerComb(playerid) == COMB_NONE
					&& !IsPlayerTraining(playerid)
					&& !IsPlayerBoxing(playerid)
					&& playerSmokeCount{playerid} == 0)
				{
					if(PlayerInfo[playerid][pJailTime])
					{
			            BlockPlayerAggression(playerid);
			            ShowPlayerHint(playerid, "� ������ ~r~���������~w~ ������� � �������");
			            return true;
					}
					/*else if(InGangZone[playerid] >= 0 && GangZoneStatus[InGangZone[playerid]] == 0)
					{
						new zone = InGangZone[playerid];
					    if(PlayerInfo[playerid][pFaction] == GangZoneOwner[zone] || PlayerInfo[playerid][pFaction] == GangZoneEnemy[zone])
					    {
					        if(!(22 <= GetPlayerWeapon(playerid) <= 33))
					        {
								//p_FellAnim[playerid] = true;
							    //SetTimerEx("ClearFell", 600, false, "i", playerid);
							    //ClearAnimations(playerid);
					            //MyApplyAnimation(playerid, "FIGHT_C", "HitC_2", 4.1, 0, 1, 1, 0, 0);
					            //SetPlayerArmedWeapon(playerid, 0);
					            BlockPlayerAggression(playerid);
								ShowPlayerHint(playerid, "�� ����� ��������~n~��������� ~r~���������");
							}
							return true;
					    }
					}*/
					else if(GetPVarInt(playerid, "Player:InGreenZone") || IsPlayerInGreenZoneVW(playerid))
					{
						if(!(22 <= GetPlayerWeapon(playerid) <= 33) && PlayerInfo[playerid][pFaction] != F_POLICE
						&& GetPVarType(playerid, "Player:Hospital:Berth") == PLAYER_VARTYPE_NONE
						&& GetPVarInt(playerid, "RegCutSceneState") == 0)
					    {
				            BlockPlayerAggression(playerid);
				            ShowPlayerHint(playerid, "����� ~r~���������~w~ ������� � ��������");
				            return true;
						}
					}
				}
			}
		}
	}
	else if(pState == PLAYER_STATE_DRIVER)
	{
	    if(newkeys == 1 || newkeys == 9 || newkeys == 33 && oldkeys != 1 || oldkeys != 9 || oldkeys != 33)
		{
		    new nitroslot = GetVehicleComponentInSlot(vehicleid, CARMODTYPE_NITRO);
			if(1008 <= nitroslot <= 1010)
			{
		        switch(GetVehicleModel(vehicleid))
		        {
		            case 446, 432, 448, 452, 424, 453, 454, 461..463, 468, 471, 430, 472, 449, 473, 481, 484, 493, 509, 510, 521, 538, 522, 523, 532, 537, 570, 581, 586, 590, 569, 595, 604, 611: { }
		            default: AddVehicleComponent(vehicleid, nitroslot);
		        }
		    }
	    }
    }
    //---
    // if(PRESSED(KEY_WALK))
    // {
    // 	OnPlayerClickAlt(playerid);
    // 	return true;
    // }
    if(RELEASED(KEY_WALK))
	{
		/*if(PursuitArest[playerid])
		{
        	DeletePVar(PursuitArestPlayer[playerid], "Police:Arrest");
        	PursuitArest[playerid] = 0;
        	PursuitArestPlayer[playerid] = INVALID_PLAYER_ID;
        	GameTextForPlayer(playerid, "~r~arrest failure", 3000, 3);
        	ClearAnimations(playerid);
        	IFace.ProgressBarHide(playerid);
        }
		if(PursuitCancelHandsup[playerid])
		{
			PursuitCancelHandsup[playerid] = 0;
			IFace.ProgressBarHide(playerid);
		}*/
	    if(GetPVarInt(playerid, "StartLockTimer"))
   		{
   		    KillTimer(GetPVarInt(playerid, "StartLockTimer"));
            DeletePVar(playerid, "LastLockCar");
			DeletePVar(playerid, "StartLockTimer");
		}
	}
    else if(PRESSED(KEY_SPRINT))
	{
	 	if(GetPVarInt(playerid, "RegCutSceneState"))
	 	{
			RegisterCutScene(playerid, 22, 0, 0);	//	������ ��������
        }
    }
    else if(PRESSED(KEY_ACTION))
	{
		if(pState == PLAYER_STATE_DRIVER && IsVehicleWithEngine(vehicleid))
		{
			callcmd::lights(playerid, ""); // ����
		}
	}
	else if(RELEASED(KEY_FIRE))
    {
        if(burning_timer[playerid] > 0)
        {
            new Float:Z;
            KillTimer(burning_timer[playerid]);
            burning_timer[playerid] = 0;
            MyGetPlayerPos(playerid, _, _, Z, _);
            if(pState == 2 && Z > 0.0)
				GameTextForPlayer(playerid, "~r~!!!FIRE FIRE FIRE!!!~n~~w~Hold ~y~~k~~VEHICLE_FIREWEAPON~", 5000, 4);
        }
        else if(graffiti_timer[playerid] > 0)
        {
			KillTimer(graffiti_timer[playerid]);
			graffiti_timer[playerid] = 0;
			GameTextForPlayer(playerid, "Failed!", 1000, 3);
        }
        else if(GetPVarInt(playerid, "BreakEngineTimer"))
		{	//  ����� ���������
			GameTextForPlayer(playerid, "~w~Breaking engine~n~Stoped", 1000, 4);
		    KillTimer(GetPVarInt(playerid, "BreakEngineTimer"));
		    DeletePVar(playerid, "BreakEngineTimer");
		}
    }
    else if(PRESSED(KEY_FIRE))
    {
        if(pState == 2 && IsVehicleWithEngine(vehicleid))
        {	// ������� ������ � ������
	        new Float:vHealth, Float:Z;
	        MyGetPlayerPos(playerid, _, _, Z, _);
	        GetVehicleHealth(vehicleid, vHealth);
	        if(vHealth < 250.0 && Z > 0.0)
	        {
				burning_timer[playerid] = SetTimerEx( "StopVehicleFire", 1500, 0, "i", playerid);
				GameTextForPlayer(playerid, "~r~!!!FIRE FIRE FIRE!!!~n~~w~Puting out...", 3000, 4);
				if(GetVehicleEngine(vehicleid)) StartEngine(vehicleid, false);
			}
			else if(Job.GetPlayerJob(playerid) == JOB_THEFT && GetVehicleEngine(vehicleid) == false && !IsAvailableVehicle(vehicleid, playerid) && VehInfo[vehicleid][vLocked] != 999)
			{	//	����� ���������
			    SetPVarInt(playerid, "LastLockCar", vehicleid);
				BreakCar(playerid, BREAK_CAR_ENGINE, 0);
			}
			return true;
        }

        // ��������� ��������
        new weaponid = GetPlayerWeapon(playerid);
		/*if(weaponid == 41 && IsGang(PlayerInfo[playerid][pFaction]) && IsPlayerInGetto(playerid))
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
						//--- ��������
						new tick = GetTickCount();
						if(tick - StartupAntiflood[playerid] < 500)
						{
						    StartupAntiflood[playerid] = tick;
						    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��� ������.");
						    return false;
						}
						StartupAntiflood[playerid] = tick;
						//-------------
			            if(PlayerInfo[playerid][pRank] == 1)
			                return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������� ������ ���� ��� ��������� �� ����������.");
					    new const owner = GangZoneOwner[zone];
		                if(owner > 0)
		                {
				            if(owner == PlayerInfo[playerid][pFaction])
				                return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������� �� ���� �� ����������.");
			                if(GangZoneEnemy[zone] > 0)
			                    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������� �� ��� ����, �� ��� ��� ���� �����.");
							if(GangBaseZone[owner] == zone && getGangZoneCount(owner) > 1)
			                    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������� �� ������� ���������� �����, ���� ���� ������.");
			                new hour, nowtime = gettime(hour, _, _);
							if((10 <= hour <= 23) == false)
							{
			    				return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��������� �� ���� ���������� � 10:00 �� 23:00.");
							}
			                if(GangRescue[PlayerInfo[playerid][pFaction]] > nowtime)
			                {
			                    SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "���� ����� ��� �� �������������� ����� ���������, ��������: %d ���.", 1 + floatround(float(GangRescue[PlayerInfo[playerid][pFaction]] - nowtime) / 60));
			                    return true;
			                }
			                for(new z; z < sizeof(GangZones); z++)
			                {
			                    if(GangZoneEnemy[z] > 0 && (GangZoneOwner[z] == owner || GangZoneEnemy[z] == owner))
			                        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��������� ���� ���������� ��� ��������� � ����� � ������ ������.");
			                }
			                new owners, enemies;
							foreach(LoginPlayer, i)
							{
				                if(PlayerInfo[i][pFaction] == owner && IsPlayerAFK(i) == false) owners++;
				                if(PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction] && IsPlayerAFK(i) == false) enemies++;
							}
							if(enemies < 2)
							{
							    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��������� ��� ������� 2 ������ ������ �� ����� �����.");
							    return 1;
							}
							if(owners < 2)
							{
							    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��������� ��� ������� 2 ������ ������ �� ��������� �����.");
							    return 1;
							}
			                if(GangRescue[owner] > nowtime)
			                {
			                    SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "��������� ����� ��� �� �������������� ����� ���������, ��������: %d ���.", 1 + floatround(float(GangRescue[owner] - nowtime) / 60));
			                    return true;
			                }
		                }
		                new wdata[2];
		                GetPlayerWeaponData(playerid, 9, wdata[0], wdata[1]);
		                SetPVarInt(playerid, "SprayCount", wdata[1]);
						graffiti_timer[playerid] = SetTimerEx("MakePlayerGraffiti", 3000, 0, "ii", playerid, g);
						GameTextForPlayer(playerid, "Painting...", 5000, 3);
						break;
					}
				}
			}
        }*/
		if(22 <= weaponid <= 33 && IsGang(PlayerInfo[playerid][pFaction]))
		{	//	���������� ��������
			if(robbery_biz[playerid] == (-1))
			{
				new biz = GetBizWhichPlayer(playerid);
				if(biz != INVALID_DATA)
				{
					RobberyStart(playerid);
				}
			}
		}
		else if(playerDrink{playerid} > 0)
		{	//	Drink
			if(playerDrinkCount{playerid} > 0)
			{
				if(--playerDrinkCount{playerid} == 0)	SetTimerEx("ClearPlayerDrink", 2600, false, "d", playerid);
				else
				{
					if(playerDrink{playerid} == 1)		SetPlayerDrunkLevel(playerid, GetPlayerDrunkLevel(playerid) + 1000);
					else if(playerDrink{playerid} == 2)	SetPlayerDrunkLevel(playerid, GetPlayerDrunkLevel(playerid) + 5000);
					else if(playerDrink{playerid} == 3)	SetPlayerDrunkLevel(playerid, GetPlayerDrunkLevel(playerid) + 4000);
					else if(playerDrink{playerid} == 4)	SetPlayerDrunkLevel(playerid, GetPlayerDrunkLevel(playerid) + 2000);
					else if(playerDrink{playerid} == 5)
					{
						SetPlayerDrunkLevel(playerid, GetPlayerDrunkLevel(playerid) - 1000);
						if(MyGetPlayerHealth(playerid) + 5.0 < 100.0)	MySetPlayerHealth(playerid, MyGetPlayerHealth(playerid) + 5.0);
					}
				}
			}
		}
		else if(playerSmokeCount{playerid} > 0)
		{
			if(--playerSmokeCount{playerid} == 0)	SetTimerEx("ClearPlayerSmoke", 2600, false, "d", playerid);
			if(MyGetPlayerHealth(playerid) + 1.0 < 100.0)	MySetPlayerHealth(playerid, MyGetPlayerHealth(playerid) + 1.0);
		}
    }
	else if(RELEASED(KEY_SECONDARY_ATTACK))
    {
        if(robbery_timer[playerid] > 0)
        {
			KillTimer(robbery_timer[playerid]), robbery_timer[playerid] = 0;
			TogglePlayerControllable(playerid, true);
			IFace.ToggleGroup(playerid, IFace.CAM_EFFECT, false);
			SetCameraBehindPlayer(playerid);
        }
        //  ������� ����� � ���� / �������� �����
        if(GetPVarInt(playerid, "LastLockCar") && GetPlayerComb(playerid) == COMB_NONE)
        {
            if(GetPVarInt(playerid, "StartLockTimer"))
            {
                PlayerPlaySound(playerid, 24600, 0.0, 0.0, 0.0);
			    GameTextForPlayer(playerid, RusText("~r~������ �������!", isRus(playerid)), 3000, 4);
	            KillTimer(GetPVarInt(playerid, "StartLockTimer"));
			    new v = GetPVarInt(playerid, "LastLockCar");
				if(!IsAvailableVehicle(v, playerid) && CarInfo[v][cType] != C_TYPE_PLAYER && VehInfo[v][vPlayers] == 0)
					ShowPlayerHint(playerid, "~w~�� ������ ������ ������ ���������� ����� ~y~ENTER~w~, �� ��� ��������� �������� �����");

	            DeletePVar(playerid, "LastLockCar");
				DeletePVar(playerid, "StartLockTimer");
			}
			else if(GetPVarInt(playerid, "BreakCarGlass"))
			{
				KillTimer(GetPVarInt(playerid, "BreakCarTimer"));
				DeletePVar(playerid, "BreakCarTimer");
				DeletePVar(playerid, "BreakCarGlass");
			}
        }
    }
    else if(PRESSED(KEY_HANDBRAKE))	// KEY_AIM // Space[128]
    {
        if(pState == PLAYER_STATE_ONFOOT)
        {
			gPressedKeyAIM[playerid] = true;
			gTargetVehicle[playerid] = INVALID_VEHICLE_ID;
        }
	    else if(pState == PLAYER_STATE_DRIVER && IsVehicleWithEngine(vehicleid))
	    {
			new tick = GetTickCount();
	        if(GetVehicleEngine(vehicleid) == false || (tick - gTickEngine[playerid] < 500 && GetVehicleSpeed(vehicleid) == 0))
	        {
		        callcmd::engine(playerid, "");
	        }
			gTickEngine[playerid] = tick;
	    }
    }
    else if(RELEASED(KEY_HANDBRAKE)) // KEY_AIM
    {
		if(engine_timer[playerid] > 0)
		{
            if(AS_ElementNumber[playerid])
            {
                SendClientMessage(playerid, COLOR_SAYING, "- ����������: ��, �� ���, �� ������ ���� ������ �������?");
            }
			GameTextForPlayer(playerid, "~w~Starting engine~n~Stoped", 1000, 4);
		    KillTimer(engine_timer[playerid]);
			engine_timer[playerid] = 0;
		}
		if(GetPVarInt(playerid, "Player:HintPressH"))
		{
			TextDrawHideForPlayer(playerid, TD_PressH);
			DeletePVar(playerid, "Player:HintPressH");
		}
       	gPressedKeyAIM[playerid] = false;
    }
    else if(PRESSED(KEY_CROUCH))// KEY_HORN
    {
		// UnDriveBy
		if(pState == PLAYER_STATE_ONFOOT)
		{
			//	Fix +C
			if(GetTickCount() - GetPVarInt(playerid, "Player:LastShotTime") < 750)
	        {
	            new weaponid = GetPlayerWeapon(playerid);
	            if(weaponid == WEAPON_DEAGLE || weaponid == WEAPON_SHOTGUN || weaponid == WEAPON_RIFLE || weaponid == WEAPON_SNIPER)
	            {
	                new Float:pPos[3];
	                GetPlayerPos(playerid, Arr3<pPos>);
	                SetPlayerPos(playerid, pPos[0], pPos[1], pPos[2] + 0.5);

	                SetPlayerArmedWeapon(playerid, 0);
	                ClearAnimations(playerid, 1);
	            }
	        }
		}
		else if(pState == PLAYER_STATE_PASSENGER)
		{
			new tick = GetTickCount();
            if(tick - gTickPushed[playerid] < 500)
			{
				SetTimerEx("RearmedPlayerWeapon", 500, false, "i", playerid);
				MyApplyAnimation(playerid, "PED", "facanger", 4.1, 0, 1, 1, 1, 1);
				SetPlayerArmedWeapon(playerid, 0);
			}
			gTickPushed[playerid] = tick;
		}
		else if(pState == PLAYER_STATE_DRIVER)
		{
			// �������� ��������
		    if(IsVehicleWithEngine(vehicleid) && IsPlayerAtGasStation(playerid))
		    {
	         	if(GetVehicleEngine(vehicleid)){
	         		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �������� ���������� ��������� ���������.");
	         	}
	         	return ShowDialog(playerid, DMODE_GAS_REFILL);
		    }
		    // �������� ����� �������
			else if(IsPlayerInRangeOfPoint(playerid, 15.0, 1544.69, -1630.85, 13.04) && IsDynamicObjectMoving(LSPDbarr) == 0)
			{
				MoveDynamicObject(LSPDbarr, 1544.69, -1630.85, 13.10+0.1, 0.07, 0.0, 0.0, 90.0);
				SetTimerEx("RerotObject", 4000, 0, "iffff", LSPDbarr, 0.0, 90.0, 90.0, 0.07);
				return true;
			}
			//	������ � ���������
			else if(IsPlayerInRangeOfPoint(playerid, 15.0, -2047.1, -80.5, 35.2) && IsDynamicObjectMoving(ASbarr) == 0)
			{
				MoveDynamicObject(ASbarr, -2043.6, -80.58, 35.0 + 0.1, 0.07, 0.0, 0.0, 0.0);
				SetTimerEx("RerotObject", 4000, 0, "iffff", ASbarr, 0.0, -90.0, 0.0, 0.07);
				return true;
			}
			else if(IsPlayerInRangeOfPoint(playerid, 15.0, 1592.0, -1638.33, 13.20))//&& !IsDynamicObjectMoving(LSPDgate))
		    {
				if(PlayerInfo[playerid][pFaction] == F_POLICE)
				{
					OpenGate(gateLSPD[0]);
					//MoveDynamicObject(LSPDgate, 1595.55, -1638.33, 13.20, 1.9);
					//SetTimerEx("MyMoveDynamicObject", 5000, 0, "ifffffff", LSPDgate, 1588.55, -1638.33, 13.20, 1.9, -1000.0, -1000.0, -1000.0);
				}
		    }
		    else if(IsPlayerInRangeOfPoint(playerid, 15.0, 1790.7, -1136.0, 26.50) && !IsDynamicObjectMoving(FBIGate))
		    {
			    if(PlayerInfo[playerid][pFaction] == F_FBI)
				{
					MoveDynamicObject(FBIGate, 1790.7, -1136.0, 18.5, 5.0);
					SetTimerEx("MyMoveDynamicObject", 3000, 0, "ifffffff", FBIGate, 1790.7, -1136.0, 25.50, 3.0, -1000.0, -1000.0, -1000.0);
				}
			}
		    // ������ ���� �������
		    else if(IsPlayerInRangeOfPoint(playerid, 15.0, -240.6978, 1208.1520, 19.3440))
		    {
		        if(!IsDynamicObjectMoving(FC_Gate[0]) && !IsDynamicObjectMoving(FC_Gate[1]))
		        {
					MoveDynamicObject(FC_Gate[0], -236.494, 1208.37, 18.387+0.1, 0.025, 0.0, 0.0, 60.0);
					SetTimerEx("RerotObject", 6000, 0, "iffff", FC_Gate[0], 0.0, 0.0, 270.0, 0.025);

					MoveDynamicObject(FC_Gate[1], -244.889, 1208.37, 18.387+0.1, 0.025, 0.0, 0.0, 300.0);
					SetTimerEx("RerotObject", 6000, 0, "iffff", FC_Gate[1], 0.0, 0.0, 70.0, 0.025);
				}
		    }
		    // �������� �����
			else if(GetPlayerAdmin(playerid) > ADMIN_MODER)
			{
			    // ������ ���� 51
				if(IsPlayerInRangeOfPoint(playerid, 10.0, 134.91, 1941.52, 21.78))
				{
					if(!IsDynamicObjectMoving(AreaGate[0])){
						MoveDynamicObject(AreaGate[0], 120.39, 1941.52, 21.78, 1.9);
						SetTimerEx("MyMoveDynamicObject", 9000, 0, "ifffffff", AreaGate[0], 134.91, 1941.52, 21.78, 1.9, -1000.0, -1000.0, -1000.0);
					}
				}
				else if(IsPlayerInRangeOfPoint(playerid, 10.0, 285.99, 1822.31, 20.00))
				{
					if(!IsDynamicObjectMoving(AreaGate[1])){
						MoveDynamicObject(AreaGate[1], 285.99, 1834.09, 20.00, 1.9);
						SetTimerEx("MyMoveDynamicObject", 9000, 0, "ifffffff", AreaGate[1], 285.99, 1822.31, 20.00, 1.9, -1000.0, -1000.0, -1000.0);
					}
				}
				else if(IsPlayerInRangeOfPoint(playerid, 10.0, 213.88, 1875.65, 13.90))
				{
					if(!IsDynamicObjectMoving(AreaGate[2]) && !IsDynamicObjectMoving(AreaGate[3])){
						MoveDynamicObject(AreaGate[2], 208.18, 1875.65, 13.90, 0.8);
						SetTimerEx("MyMoveDynamicObject", 8000, 0, "ifffffff", AreaGate[2], 211.88, 1875.65, 13.90, 0.8, -1000.0, -1000.0, -1000.0);
						MoveDynamicObject(AreaGate[3], 219.57, 1875.65, 13.90, 0.8);
						SetTimerEx("MyMoveDynamicObject", 8000, 0, "ifffffff", AreaGate[3], 215.97, 1875.65, 13.90, 0.8, -1000.0, -1000.0, -1000.0);
					}
				}
				// ������ ����
				else if(IsPlayerInRangeOfPoint(playerid, 10.0, 2497.41, 2773.5, 11.53))
				{
					if(!IsDynamicObjectMoving(KassGate[0]) && !IsDynamicObjectMoving(KassGate[1]))
					{
						MoveDynamicObject(KassGate[0], 2497.41, 2763.80, 11.53, 1.4);
						SetTimerEx("MyMoveDynamicObject", 8000, 0, "ifffffff", KassGate[0], 2497.41, 2769.11, 11.53, 1.4, -1000.0, -1000.0, -1000.0);
						MoveDynamicObject(KassGate[1], 2497.41, 2782.57, 11.53, 1.4);
						SetTimerEx("MyMoveDynamicObject", 8000, 0, "ifffffff", KassGate[1], 2497.41, 2777.07, 11.53, 1.4, -1000.0, -1000.0, -1000.0);
					}
				}
				// ������ ������ � ��� �������
				else if(IsPlayerInRangeOfPoint(playerid, 5.0, 1826.4875,-1538.6104,13.5469))
				{
					if(IsDynamicObjectMoving(LS_PrisonGate[0]) || IsDynamicObjectMoving(LS_PrisonGate[4])) return 1;
					MoveDynamicObject(LS_PrisonGate[0], 1822.52832, -1540.94080, 10.8, 1.4);
					MoveDynamicObject(LS_PrisonGate[1], 1824.32483, -1534.69763, 10.8, 1.4);
					SetTimerEx("MyMoveDynamicObject", 7000, 0, "ifffffff", LS_PrisonGate[0], 1822.52832, -1540.94080, 14.26770, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 7000, 0, "ifffffff", LS_PrisonGate[1], 1824.32483, -1534.69763, 14.26770, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 11000, 0, "ifffffff", LS_PrisonGate[4], 1813.87659, -1533.16516, 10.4, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 11000, 0, "ifffffff", LS_PrisonGate[5], 1813.72278, -1539.64246, 10.4, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 16000, 0, "ifffffff", LS_PrisonGate[4], 1813.87659, -1533.16516, 13.93400, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 16000, 0, "ifffffff", LS_PrisonGate[5], 1813.72278, -1539.64246, 13.93400, 1.4, -1000.0, -1000.0, -1000.0);
				}
				else if(IsPlayerInRangeOfPoint(playerid, 5.0, 1809.9653,-1536.2758,12.7081))
				{
					if(IsDynamicObjectMoving(LS_PrisonGate[0]) || IsDynamicObjectMoving(LS_PrisonGate[4])) return 1;
					MoveDynamicObject(LS_PrisonGate[4], 1813.87659, -1533.16516, 10.4, 1.4);
					MoveDynamicObject(LS_PrisonGate[5], 1813.72278, -1539.64246, 10.4, 1.4);
					SetTimerEx("MyMoveDynamicObject", 7000, 0, "ifffffff", LS_PrisonGate[4], 1813.87659, -1533.16516, 13.93400, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 7000, 0, "ifffffff", LS_PrisonGate[5], 1813.72278, -1539.64246, 13.93400, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 11000, 0, "ifffffff", LS_PrisonGate[0], 1822.52832, -1540.94080, 10.8, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 11000, 0, "ifffffff", LS_PrisonGate[1], 1824.32483, -1534.69763, 10.8, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 16000, 0, "ifffffff", LS_PrisonGate[0], 1822.52832, -1540.94080, 14.26770, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 16000, 0, "ifffffff", LS_PrisonGate[1], 1824.32483, -1534.69763, 14.26770, 1.4, -1000.0, -1000.0, -1000.0);
				}
				else if(IsPlayerInRangeOfPoint(playerid, 5.0, 1753.8889,-1594.3204,13.5375))
				{
					if(IsDynamicObjectMoving(LS_PrisonGate[2]) || IsDynamicObjectMoving(LS_PrisonGate[6])) return 1;
					MoveDynamicObject(LS_PrisonGate[2], 1756.92969, -1592.31470, 10.7, 1.4);
					MoveDynamicObject(LS_PrisonGate[3], 1752.02393, -1591.19116, 10.7, 1.4);
					SetTimerEx("MyMoveDynamicObject", 7000, 0, "ifffffff", LS_PrisonGate[2], 1756.92969, -1592.31470, 14.27910, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 7000, 0, "ifffffff", LS_PrisonGate[3], 1752.02393, -1591.19116, 14.27910, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 11000, 0, "ifffffff", LS_PrisonGate[6], 1756.62097, -1583.20007, 9.7, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 11000, 0, "ifffffff", LS_PrisonGate[7], 1751.71716, -1582.06445, 9.7, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 16000, 0, "ifffffff", LS_PrisonGate[6], 1756.62097, -1583.20007, 13.27910, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 16000, 0, "ifffffff", LS_PrisonGate[7], 1751.71716, -1582.06445, 13.27910, 1.4, -1000.0, -1000.0, -1000.0);
				}
				else if(IsPlayerInRangeOfPoint(playerid, 5.0, 1754.7020,-1579.8577,12.1113))
				{
					if(IsDynamicObjectMoving(LS_PrisonGate[2]) || IsDynamicObjectMoving(LS_PrisonGate[6])) return 1;
					MoveDynamicObject(LS_PrisonGate[6], 1756.62097, -1583.20007, 9.7, 1.4);
					MoveDynamicObject(LS_PrisonGate[7], 1751.71716, -1582.06445, 9.7, 1.4);
					SetTimerEx("MyMoveDynamicObject", 7000, 0, "ifffffff", LS_PrisonGate[6], 1756.62097, -1583.20007, 13.27910, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 7000, 0, "ifffffff", LS_PrisonGate[7], 1751.71716, -1582.06445, 13.27910, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 11000, 0, "ifffffff", LS_PrisonGate[2], 1756.92969, -1592.31470, 10.7, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 11000, 0, "ifffffff", LS_PrisonGate[3], 1752.02393, -1591.19116, 10.7, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 16000, 0, "ifffffff", LS_PrisonGate[2], 1756.92969, -1592.31470, 14.27910, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 16000, 0, "ifffffff", LS_PrisonGate[3], 1752.02393, -1591.19116, 14.27910, 1.4, -1000.0, -1000.0, -1000.0);
				}
				else if(IsPlayerInRangeOfPoint(playerid, 10.0, 1781.0, -1533.76758, 10.20))
				{
					if(IsDynamicObjectMoving(LS_PrisonGate[8])) return 1;
					MoveDynamicObject(LS_PrisonGate[8], 1781.21533, -1530.76758, 10.2, 1.4);
					MoveDynamicObject(LS_PrisonGate[9], 1780.97607, -1537.21082, 10.2, 1.4);
					SetTimerEx("MyMoveDynamicObject", 6000, 0, "ifffffff", LS_PrisonGate[8], 1781.21533, -1530.76758, 6.6, 1.4, -1000.0, -1000.0, -1000.0);
					SetTimerEx("MyMoveDynamicObject", 6000, 0, "ifffffff", LS_PrisonGate[9], 1780.97607, -1537.21082, 6.6, 1.4, -1000.0, -1000.0, -1000.0);
				}
				// ������ ����������
				else if(IsPlayerInRangeOfPoint(playerid, 10.0, 540.359, -2748.300, 14.600)){
					PrisonGateMove(0, true);
				}
				else if(IsPlayerInRangeOfPoint(playerid, 10.0, 551.429, -2731.300, 14.600)){
					PrisonGateMove(1, true);
				}
				else if(IsPlayerInRangeOfPoint(playerid, 10.0, 540.580, -2714.209, 14.600)){
					PrisonGateMove(2, true);
				}
				else if(IsPlayerInRangeOfPoint(playerid, 10.0, 547.320, -2818.209, 14.600)){
					PrisonGateMove(3, true);
				}
				else if(IsPlayerInRangeOfPoint(playerid, 10.0, 590.169, -2676.679, 14.600)){
					PrisonGateMove(4, true);
				}
				else if(IsPlayerInRangeOfPoint(playerid, 10.0, 628.150, -2704.229, 6.219)){
					PrisonGateMove(5, true);
				}
			}
			return true;
		}
    }
	else if(RELEASED(KEY_CTRL_BACK))
	{
		/*if(PursuitReinforc[playerid])
		{
			PursuitReinforc[playerid] = 0;
			IFace.ProgressBarHide(playerid);
		}*/
	}
	else if(PRESSED(KEY_ANALOG_DOWN))
	{
		new model = GetVehicleModel(vehicleid);
		if(GetPlayerState(playerid) == 2 && (model == 525 || model == 531 || model == 583))
			return callcmd::tow(playerid, "");
	}
	return true;
}

public	OnPlayerAskResponse(playerid, offerid, askid, const amount[], response)
{
	new string[256];
	if (response == OFFER_RESPONSE_DISCONNECT)
	{
		SendFormatMessage(playerid, COLOR_LIGHTRED, string, "%s ������� ������, ����������� ���������.", ReturnPlayerName(offerid));
	}
	else if (response == OFFER_RESPONSE_YES)	// KEY_YES
	{
		//new ammount = amount[0]; //AskAmount[playerid];
		if(offerid == INVALID_PLAYER_ID || IsPlayerLogged(offerid))
		{
		    switch(askid)
		    {
		        case ASK_INVITE:
		        {
					SetPlayerFaction(playerid, amount[0]);

					SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "�� ������� � ����������� %s", GetFactionName(PlayerInfo[playerid][pFaction]));
					SendFormatMessage(offerid, COLOR_LIGHTBLUE, string, "%s ��� ������ � ����������� %s", ReturnPlayerName(playerid), GetFactionName(PlayerInfo[playerid][pFaction]));

					format(string, sizeof(string), "%s invite %s : %s", ReturnPlayerName(offerid), ReturnPlayerName(playerid), GetFactionName(PlayerInfo[playerid][pFaction]));
					log("Faction", string);
		        }
		        case ASK_INVITE_JOB:
				{
				    switch(amount[0])
				    {
						/*case JOB_GUNDEAL: // �������� �������
						{
							if(MyGetPlayerMoney(playerid) < 500)
							{
								SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �� ������� ����� ��� ������� ���� ������ (500$).");
								goto no_ask;
							}
							if(PlayerInfo[playerid][pGunDealLic] == 0)
				        	{
				        		MyGivePlayerMoney(playerid, -500);	//	��������, ������ ����������
				        	}
				        	else PlayerInfo[playerid][pGunDealLic] = 0;
				        }
				        case JOB_THEFT: // �����������
				        {
							if(MyGetPlayerMoney(playerid) < 500)
							{
								SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �� ������� ����� ��� ������� ���� ������ (500$).");
								goto no_ask;
							}
				        	if(PlayerInfo[playerid][pTheftLic] == 0)
				        	{
				        		MyGivePlayerMoney(playerid, -500);	//	��������, ������ ����������
				        	}
				        	else PlayerInfo[playerid][pTheftLic] = 0;
						}
						case JOB_DRUGDEAL:	// �����������
						{
							if(MyGetPlayerMoney(playerid) < 500)
							{
								SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �� ������� ����� ��� ������� ���� ������ (500$).");
								goto no_ask;
							}
							if(PlayerInfo[playerid][pDrugDealLic] == 0)
				        	{
				        		MyGivePlayerMoney(playerid, -500);	//	��������, ������ ����������
				        	}
				        	else PlayerInfo[playerid][pDrugDealLic] = 0;
						}*/
				    }
					SendFormatMessage(playerid, COLOR_WHITE, string, "�����������, �� ���������� �� ������: {44B2FF}%s.", GetJobName(amount[0]));
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_HINT "����� ������ ���������� �� ����� ����� � ���� ����������.");
	        		Job.SetPlayerJob(playerid, amount[0], CONTRACT_TIME);
				}
				case ASK_POLICE_FINE:
				{
					if(MyGetPlayerMoney(playerid) < amount[0])
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
						goto no_ask;
					}
				    MyGivePlayerMoney(playerid, -amount[0]);
					CancelPlayerPursuit(playerid, 2);
					MySetPlayerWantedLevel(playerid, 0);
					SendFormatMessage(playerid, COLOR_DBLUE, string, "�� �������� ����� � ������� %d$, ����������� ����", amount[0]);
					SendFormatMessage(offerid, COLOR_DBLUE, string, "%s ������� �����, ������ �� ��������", ReturnPlayerName(playerid));
				}
				case ASK_CAR_SELLTO:
				{
					new vehicleid = amount[1]; //AskAmount2[playerid];
					//if(PlayerInfo[playerid][pCarLic] == 0)
					if(IsPlayerHaveLicThisVehicle(playerid, GetVehicleModel(vehicleid)))
					{
					    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� �������� �� ���� ���������.");
					    goto stop_ask;
					}
				    if(MyGetPlayerMoney(playerid) < amount[0])
				    {
				        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� �� ������� ����� ��� �������.");
				        goto stop_ask;
				    }
					if(CarInfo[vehicleid][cType] != C_TYPE_PLAYER)
					{
				        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ��������� �� �������� �����������.");
				        goto stop_ask;
					}
					if(IsAvailableVehicle(vehicleid, offerid) != VEH_AVAILABLE_OWNER)
					{
				        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������� ����� �� ����� ����� �� ���� ���������.");
				        goto stop_ask;
					}
  					// ������������ ������
				    MyGivePlayerMoney(playerid, -amount[0]);
				    MyGivePlayerMoney(offerid, amount[0]);
					// �������������� ���������
					CarInfo[vehicleid][cOwnerID] = PlayerInfo[playerid][pUserID];
					UpdateVehicleStatics(vehicleid);
					// ������ ������� �����
					RemovePlayerFromVehicle(playerid);
					RemovePlayerFromVehicle(offerid);
					// ���������� ������� � ����������
					PlayerAction(playerid, "����������� ������� �� ������� ����������.");
					format(string, 128, "* �� ������� ����������� �� {B1C8FB}%s{88AA88}, ��������� ���!", ReturnPlayerName(offerid));
					SendClientMessage(playerid, COLOR_SPECIAL, string);
					format(string, 128, "* {B1C8FB}%s{88AA88} ������ ���� �����������", ReturnPlayerName(playerid));
					SendClientMessage(offerid, COLOR_SPECIAL, string);
				}
				case ASK_HI:
				{
			    	callcmd::hi(playerid, ReturnPlayerName(offerid));
				}
				case ASK_GIVE_MONEY:
				{
					if(IsPlayerNearPlayer(playerid, offerid, 5.0) == 0)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ������� ������ �� ���.");
						goto stop_ask;
					}
					if(amount[0] > 0 && MyGetPlayerMoney(offerid) < amount[0])
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ������ ��� ������� �����.");
						goto stop_ask;
					}
					if(amount[0] > 10000)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ���������� �� ��� ����� $10.000.");
						goto stop_ask;
					}
					if (GetPlayerState(playerid) == 1)
						MyApplyAnimation(playerid, "GANGS", "Invite_Yes", 4.1, 0, 0, 0, 0, 0);

					MyGivePlayerMoney(offerid, -amount[0]);
					MyGivePlayerMoney(playerid, amount[0]);
					SendFormatMessage(offerid, COLOR_GREEN, string, "�� �������� %d$ ������ %s[%d]", amount[0], ReturnPlayerName(playerid), playerid);
					SendFormatMessage(playerid, COLOR_GREEN, string, "�� �������� %d$ �� %s[%d]", amount[0], ReturnPlayerName(offerid), offerid);
					format(string, sizeof(string), "�������� ������ %s'�.", ReturnPlayerName(playerid));
					PlayerAction(offerid, string);
					format(string, sizeof(string), "%s -> %s : %d$", ReturnPlayerName(offerid), ReturnPlayerName(playerid), amount[0]);
					log("Pay", string);
				}
				case ASK_GIVE_THING:
				{
					if(IsPlayerNearPlayer(playerid, offerid, 5.0) == 0)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ������� ������ �� ���.");
						goto stop_ask;
					}
					if(amount[0] > 0 && MyGetPlayerMoney(playerid) < amount[0])
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� �����.");
						goto stop_ask;
					}
					new count = amount[1]; // AskAmount2[playerid];
					new thing = amount[2]; // AskAmount3[playerid];
					new option = amount[3]; // AskAmount4[playerid];
					if(Inv.GetThing(offerid, thing, option) < count)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ������ ��� ��� ����� ��������.");
						goto stop_ask;
					}
					if(Inv.AddPlayerThing(playerid, thing, count, option) == 0)
					{
						goto stop_ask;
					}
					Inv.PlayerDeleteThing(offerid, thing, option, count);
					if(amount[0])
					{
						SendFormatMessage(offerid, COLOR_GREEN, string, "�� �������� %s (%d ��.) ������ %s[%d] �� %d$", GetThingName(thing, option), count, ReturnPlayerName(playerid), playerid, amount[0]);
						SendFormatMessage(playerid, COLOR_GREEN, string, "�� �������� %s (%d ��.) �� %s[%d] �� %d$", GetThingName(thing, option), count, ReturnPlayerName(offerid), offerid, amount[0]);

						MyGivePlayerMoney(playerid, -amount[0]);
						MyGivePlayerMoney(offerid, amount[0]);
					}
					else
					{
						SendFormatMessage(offerid, COLOR_GREEN, string, "�� �������� %s (%d ��.) ������ %s[%d]", GetThingName(thing, option), count, ReturnPlayerName(playerid), playerid);
						SendFormatMessage(playerid, COLOR_GREEN, string, "�� �������� %s (%d ��.) �� %s[%d]", GetThingName(thing, option), count, ReturnPlayerName(offerid), offerid);
					}
					if(GetPlayerState(playerid) == 1)	MyApplyAnimation(playerid, "GANGS", "Invite_Yes", 4.1, 0, 0, 0, 0, 0);
					format(string, sizeof(string), "�������� ���-�� %s'�.", ReturnPlayerName(playerid));
					PlayerAction(offerid, string);

					IFace.Inv_UpdateListItems(offerid);
					IFace.Inv_UpdateListItems(playerid);
				}
				case ASK_INTERVIEW:
				{
					if(IsPlayerNearPlayer(playerid, offerid, 5.0) == 0)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ������� ������ �� ���.");
						goto stop_ask;
					}
					SendFormatMessage(playerid, COLOR_GREEN, string, "�� ����������� ���� �������� %s'� � ������ �����", ReturnPlayerName(offerid));
					SendFormatMessage(offerid, COLOR_GREEN, string, "%s ���������� ���� ��� �������� � ������ �����", ReturnPlayerName(playerid));
				    SendClientMessage(playerid, COLOR_LIGHTBLUE, "�� ���������� �� ��������� ��������.");
					SendClientMessage(offerid, COLOR_LIGHTBLUE, "�� ���������� �� ��������� �������� (�����������: /live ��������).");
					TogglePlayerControllable(playerid, 0);
					TogglePlayerControllable(offerid, 0);
					TalkingLive[playerid] = offerid;
					TalkingLive[offerid] = playerid;
				}
				case ASK_BOX:
				{
					if (StartBox(playerid, offerid))
					{
						SendFormatMessage(playerid, COLOR_GREEN, string, "�� ����������� �� ���������� �������� ������ %s'�", ReturnPlayerName(offerid));
						SendFormatMessage(offerid, COLOR_GREEN, string, "%s ���������� �� ���������� �������� ������ ���", ReturnPlayerName(playerid));
					}
				}
				case ASK_BUY_HOTDOG:
				{
					if(MyGetPlayerMoney(playerid) < 5)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
						goto stop_ask;
					}
					if(GetPlayerHunger(playerid) >= 100)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �������.");
						goto stop_ask;
					}
					new actor = amount[0];
					new Float:pos[3];
					GetActorPos(actor, Arr3<pos>);
					if(GetDistanceFromMeToPoint(playerid, Arr3<pos>) > 5.0)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������� ������ �� ������.");
						goto stop_ask;
					}
					new eat = EatPlayer(playerid, 30, "��� ���-���");
					if(eat)
					{
						if(eat != -1)	MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
						MyGivePlayerMoney(playerid, -5);
						ApplyActorAnimation(actor, "BAR", "Barcustom_get", 4.1, 0, 0, 0, 0, 0);
					}
				}
				case ASK_SHOWPASS:
				{
					if(IsPlayerNearPlayer(playerid, offerid, 5.0) == 0)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ������� ������ �� ���.");
						goto stop_ask;
					}
					ShowPass(playerid, offerid);
					PlayerAction(offerid, "���������� ���� ���������.");
				}
				case ASK_JOB_PARTNER:
				{
					if(IsPlayerNearPlayer(playerid, offerid, 5.0) == 0)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ������� ������ �� ���.");
						goto stop_ask;
					}
					SetPVarInt(playerid, "Player:JobPartner", PlayerInfo[offerid][pUserID]);
					SendFormatMessage(playerid, COLOR_GREEN, string, "�� ����������� ���������� � %s'��", ReturnPlayerName(offerid));
					SendFormatMessage(offerid, COLOR_GREEN, string, "%s ���������� ���������� � ����", ReturnPlayerName(playerid));
				}
				case ASK_REPAIR:
				{
					if(Job.GetPlayerNowWork(offerid) != JOB_MECHANIC)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ��� �� �������� ��������� ��� ���� � ���������.");
						goto stop_ask;
					}

			    	new v = GetPlayerVehicleID(playerid);
			    	if(!v || VehInfo[v][vDriver] != playerid)
			    	{
			    		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���� �� ����� ����������.");
						goto stop_ask;
			    	}

					if(MyGetPlayerMoney(playerid) < amount[0])
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� �����.");
						goto stop_ask;
					}

					new dif = 20,
						Float:carX, Float:carY, Float:carZ,
						Float:carA, Float:plX, Float:plY, Float:plZ;

					GetVehiclePos(v, carX, carY, carZ);
					GetVehicleZAngle(v, carA);
					GetPlayerPos(offerid, plX, plY, plZ);
					new A = floatround(atan2(carX - plX, carY - plY) + carA);
					if(A > 360)	A -= 360;
					if(180 - dif < A < 180 + dif)
				    {	// �����
						if(!GetVehicleBonnet(v))
						{
							SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ����� ������ ������ ���� ������.");
							goto stop_ask;
						}
					    new Float:Health;
					    GetVehicleHealth(v, Health);
					    if(Health < 400.0)
					    {
							SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ����� ������ �������� ������ � �������.");
							goto stop_ask;
					    }
						MySetVehicleHealth(v, 999.0);
						PlayerAction(offerid, "���������� ��� �������.");
						MyApplyAnimation(offerid, "GANGS","shake_cara", 4.1, 0, 0, 0, 0, 0, 1);

						Job.GivePlayerWage(offerid, amount[0]);
						MyGivePlayerMoney(playerid, -amount[0]);

						SendFormatMessage(playerid, COLOR_GREEN, string, "�� ����������� �� ������ %s'�", ReturnPlayerName(offerid));
						SendFormatMessage(offerid, COLOR_GREEN, string, "%s ���������� �� ������ ������ ����", ReturnPlayerName(playerid));
				    }
				}
				case ASK_REFILL:
				{
					if(Job.GetPlayerNowWork(offerid) != JOB_MECHANIC)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ��� �� �������� ��������� ��� ���� � ���������.");
						goto stop_ask;
					}

					new vehicleid = gLastVehicle[offerid];
		    		if(CarInfo[vehicleid][cType] != C_TYPE_JOB || CarInfo[vehicleid][cOwnerID] != JOB_MECHANIC)
			    	{
			    		goto stop_ask;
			    	}
			    	new Float:pos[3];
			    	new v = GetPlayerVehicleID(playerid);
			    	if(v == 0 || VehInfo[v][vDriver] != playerid)
			    	{
			    		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, �� ������ ���� �� ����� ����������.");
						goto stop_ask;
			    	}
					GetVehiclePos(v, Arr3<pos>);
					if(GetVehicleDistanceFromPoint(vehicleid, Arr3<pos>) > 10)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, ���� �������� ������ ���� ����� � �����.");
						goto stop_ask;
			    	}
			    	if(GetPlayerDistanceFromPoint(offerid, Arr3<pos>) > 10)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, ������� ������ ���� ����� � ����� �����������.");
						goto stop_ask;
			    	}
					if(VehInfo[vehicleid][vFuel] < amount[0])
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� �������� ��� ��� ������� �������.");
						goto stop_ask;
					}
					if(VehInfo[v][vFuel] + amount[0] > GetVehicleMaxFuel(v))
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� �� ������ ������� �������.");
						goto stop_ask;
					}

					if(MyGetPlayerMoney(playerid) < amount[1])
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
						goto stop_ask;
					}
					VehInfo[v][vFuel] += float(amount[0]);
					VehInfo[vehicleid][vFuel] -= float(amount[0]);
					Job.GivePlayerWage(offerid, amount[1]);
					MyGivePlayerMoney(playerid, -amount[1]);

					IFace.Veh_Update(VehInfo[v][vDriver], 0);
					UpdateVehicleLabel(vehicleid);

					SendFormatMessage(playerid, COLOR_GREEN, string, "�� ����������� �� �������� �� %s'�", ReturnPlayerName(offerid));
					SendFormatMessage(offerid, COLOR_GREEN, string, "%s ���������� �� �������� ������ ����", ReturnPlayerName(playerid));
					format(string, sizeof(string), "���������� ���������� %s'�.", ReturnPlayerName(playerid));
					PlayerAction(offerid, string);
				}
			}
		}
		else
		{
			SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "%s ����� � ������� - ������ �� ��������.", ReturnPlayerName(offerid));
		}
	}
	else if (response == OFFER_RESPONSE_NO || response == OFFER_RESPONSE_TIMEOUT) // KEY_NO // OnPlayerYNStateChange
	{
	no_ask:
        if(GetPlayerAsk(playerid) != 0)
		{
			if(offerid == INVALID_PLAYER_ID || IsPlayerLogged(offerid))
			{
				switch(GetPlayerAsk(playerid))
				{
					case ASK_INVITE_JOB:
					{
						SendClientMessage(playerid, COLOR_LIGHTRED, "�� ���������� ������������ �� ������");
					}
					case ASK_POLICE_FINE:
					{
						SendClientMessage(playerid, COLOR_LIGHTRED, "�� ���������� �� ������ ������");
						SendFormatMessage(offerid, COLOR_LIGHTRED, string, "%s ��������� �� ������ ������. {FFFFFF}��������� ���!", ReturnPlayerName(playerid));
						if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
						{
							format(string, sizeof(string), "- %s %s �������: ������� �� ������ � ��������� ������! (( %s ))", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(offerid));
							ProxDetector(playerid, 30.0, string, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, 0xE6E6E6E6, 0xC8C8C8C8);
							PlayerPlaySound(playerid, 34403, 0, 0, 0);
							PlayerPlaySound(offerid, 34403, 0, 0, 0);
							ShowPlayerHint(playerid, "_~b~�����������~w~ ������ ��� ����� �� ����������");
							PursuitStatus[playerid] = PS_WAIT_OUT_VEH;
							PursuitCount[playerid] = 15;
				    	}
				    	PursuitAllowArrest[playerid] = true;
				    }
				    default:
				    {
				    	if(offerid == INVALID_PLAYER_ID)
				    	{
				    		SendClientMessage(playerid, COLOR_LIGHTRED, "����������� ���������");
				    	}
				    	else
				    	{
				    		SendFormatMessage(playerid, COLOR_LIGHTRED, string, "�� ��������� ����������� �� %s", ReturnPlayerName(offerid));
							SendFormatMessage(offerid, COLOR_LIGHTRED, string, "%s �������� ���� �����������", ReturnPlayerName(playerid));
				    	}

				    }
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "����� ����� � ������� - ������ �� ��������");
			}
		}
	}
stop_ask:
	return (1);
}

public OnIncomingConnection(playerid, ip_address[], port)
{
	printf("Incoming connection for player ID %i [%s: %i]", playerid, ip_address, port);
	return true;
}

public OnRconLoginAttempt(ip[], password[], success)
{
    if(!success)
    {
    	printf("FAILED RCON LOGIN BY IP %s USING PASSWORD %s", ip, password);

    	new string[128];
        foreach(Player, i)
        {
            if(!strcmp(ip, ReturnPlayerIP(i), true))
            {
                format(string, sizeof(string), "[AdmWrn]: %s[%d] �������� �������������� ��� rcon � �������� �������", ReturnPlayerName(i), i);
				SendAdminMessage(COLOR_LIGHTRED, string);
                if(PlayerInfo[i][pAdmin] < ADMIN_DEVELOPER || !AdminDuty[i])
                {
                	Kick(i);
                }
                return true;
            }
        }
    	format(string, sizeof(string), "[AdmWrn]: ������� rcon-����������� � �������� ������� [IP: %s]", ip);
		SendAdminMessage(COLOR_LIGHTRED, string);
        //BlockIpAddress(ip, 3600 * 1000);// 1 hour
    }
	return 1;
}

Public: OnPlayerVehicleCrash(playerid, Float:damage)
{
	new tmp = floatround(damage / DAMAGE_COEFFICIENT);
	new vehicleid = GetPlayerVehicleID(playerid);
	FadeColorForPlayer(playerid, 255, 0, 0, tmp, 255, 0, 0, 0, tmp);
	MySetPlayerHealth(playerid, MyGetPlayerHealth(playerid) - damage);

	// ������ �������������
#if defined	_job_job_trucker_included
	if(TruckerStatus[playerid] > 0 && IsPlayerInVehicle(playerid, TruckerVeh[playerid]))
	{
	    TruckerDmg[playerid] += damage * 10.0;
	}
#endif	
#if defined	_job_part_delivery_included
	if(DeliveryVehLoadCount[vehicleid] > 0)
	{
		DeliveryVehLoadDamage[vehicleid] -= floatround(damage);
		IFace.ShowPlayerProgress(playerid,
			DeliveryVehLoadDamage[vehicleid], 100);
	}
#endif	
	return true;
}

/*public OnTrailerUpdate(playerid, vehicleid)
{// Every millisecond
    return 1;
}*/

stock GetWeaponModel(weaponid)
{
	switch(weaponid)
	{
	    case 1:			return 331;
		case 2..8:		return weaponid + 331;
        case 9:			return 341;
		case 10..15:	return weaponid + 311;
		case 16..18:	return weaponid + 326;
		case 22..29:	return weaponid + 324;
		case 30, 31:	return weaponid + 325;
		case 32:		return 372;
		case 33..45:	return weaponid + 324;
		case 46:		return 371;
	}
	return 0;
}

public	OnEveryMillisecondTimer()
{	//	WARNING! ������ ���������� 10 ��� � �������, �� ��������� ������
    new panelsx, doorsx, lightsx, tiresx;
    foreach(Vehicle, v)
    {
        if(VehInfo[v][vFlashMode])
        {
        	GetVehicleDamageStatus(v, panelsx, doorsx, lightsx, tiresx);
			switch(VehInfo[v][vFlashMode])
			{
				case 1:
				{   //  ������ �������� �� �����, �� ������ �����
				    switch(VehInfo[v][vFlashState])
					{
				        case 0:	UpdateVehicleDamageStatus(v, panelsx, doorsx, 2, tiresx);
					    case 5:	UpdateVehicleDamageStatus(v, panelsx, doorsx, 8, tiresx);
						case 9:
							VehInfo[v][vFlashState] = -1;
					}
				}
				case 2:
				{//  3 �������� �� �����, �� ������ �����
				    switch(VehInfo[v][vFlashState])
					{
				        case 0, 2, 6, 8, 14:				UpdateVehicleDamageStatus(v, panelsx, doorsx, 2, tiresx);
						case 1, 3, 5, 7, 9, 11, 13, 15, 17:	UpdateVehicleDamageStatus(v, panelsx, doorsx, 5, tiresx);
						case 4, 10, 12, 16, 18:				UpdateVehicleDamageStatus(v, panelsx, doorsx, 8, tiresx);
						case 19:
						{
						    UpdateVehicleDamageStatus(v, panelsx, doorsx, 5, tiresx);
							VehInfo[v][vFlashState] = -1;
						}
					}
				}
				case 3:
				{
	                switch(VehInfo[v][vFlashState])
					{//  2 �����, 2 ������ (������)
				        case 0, 2:		UpdateVehicleDamageStatus(v, panelsx, doorsx, 2, tiresx);
						case 1, 3, 5:	UpdateVehicleDamageStatus(v, panelsx, doorsx, 5, tiresx);
						case 4, 6:		UpdateVehicleDamageStatus(v, panelsx, doorsx, 8, tiresx);
						case 7:
						{
						    UpdateVehicleDamageStatus(v, panelsx, doorsx, 5, tiresx);
							VehInfo[v][vFlashState] = -1;
						}
					}
				}
				case 4:
				{   //  ������� �������� 2 ������
	                switch(VehInfo[v][vFlashState])
					{
						case 0, 2, 4, 6:	UpdateVehicleDamageStatus(v, panelsx, doorsx, 0, tiresx);
						case 1, 3, 5, 7:	UpdateVehicleDamageStatus(v, panelsx, doorsx, 5, tiresx);
						case 10:
							VehInfo[v][vFlashState] = -1;
					}
				}
				case 5:
				{   //  ������� �������� �� ����� �� ������
					if(VehInfo[v][vFlashState] == 0)
						UpdateVehicleDamageStatus(v, panelsx, doorsx, 2, tiresx);
					else
					{
					   	UpdateVehicleDamageStatus(v, panelsx, doorsx, 8, tiresx);
						VehInfo[v][vFlashState] = -1;
					}
				}
			}
			VehInfo[v][vFlashState]++;
        }
    }
    #if defined _interface_cam_effect_included
   		IFace.CamEffect_UpdateTime();
   	#endif
    foreach(LoginPlayer, i)
    {
    	#if defined _interface_cam_effect_included
	    	IFace.CamEffect_Update(i);
    	#endif
    	// #if defined _police_pursuit_included	
    	// 	Police.Pursuit_QuickTimer(i);
    	// #endif	
    }
    return true;
}

public OnPlayerChangeArmour(playerid, Float:oldArmour, Float:armour)
{
	PlayerInfo[playerid][pSaveArmour] = armour;

	if((oldArmour <= 0 && armour > 0) || (oldArmour > 0 && armour <= 0))	
	{
		IFace.ToggleGroup(playerid, IFace.INTERFACE, true);
	}
	return true;
}

public OnPlayerUpdate(playerid)
{
	if (IsPlayerNPC(playerid))
		return (1);
	
	if(IsPlayerLogged(playerid) == 0)
	{
		//	Login Cam
		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && gPlayerRegged[playerid] != REG_STATE_UNDEFINED && gPlayerShowLoginCam[playerid] == false)
		{
			ShowPlayerLogin(playerid);
		}
	}
	else
	{
		new string[512];
		new pstate = GetPlayerState(playerid);
		new Float:X, Float:Y, Float:Z, Float:A,
			Float:health,
			vehicleid = GetPlayerVehicleID(playerid);

		//	������� GPS ��� ����
		if(pstate != PLAYER_STATE_DRIVER && gps_Data[playerid][GPS_OBJ])
		{
			DestroyDynamicObject(gps_Data[playerid][GPS_OBJ]), gps_Data[playerid][GPS_OBJ] = INVALID_STREAMER_ID;
		}
		else if(pstate == PLAYER_STATE_DRIVER)
		{
			// ���������
			IFace.Veh_Update(playerid, 1);

			if(gps_Data[playerid][GPS_CP] > 0)
			{
				if(gps_Data[playerid][GPS_OBJ] == 0)
					gps_Data[playerid][GPS_OBJ] = CreateDynamicObject(19132, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1, -1, playerid);//1318,19130
				//	���� ��������
				new Float:lX = floatabs(X - gps_Data[playerid][GPS_POS][0]);
				new Float:lY = floatabs(Y - gps_Data[playerid][GPS_POS][1]);
				new Float:angle = atan2(lX, lY);
				if(X > gps_Data[playerid][GPS_POS][0]
					&& Y > gps_Data[playerid][GPS_POS][1])
					angle = 180.0 + (90.0 - angle);
				else if(X > gps_Data[playerid][GPS_POS][0]
					&& Y < gps_Data[playerid][GPS_POS][1])
					angle += 90.0;
				else if(X < gps_Data[playerid][GPS_POS][0]
					&& Y > gps_Data[playerid][GPS_POS][1])
					angle += 270.0;
				else if(X < gps_Data[playerid][GPS_POS][0]
					&& Y < gps_Data[playerid][GPS_POS][1])
					angle = (90 - angle);
				angle -= A;
				AttachDynamicObjectToVehicle(gps_Data[playerid][GPS_OBJ], vehicleid, 0.0, 0.0, 2.0, 0.0, -100.0, angle);
			}
			
			foreach(LoginPlayer, i)
			{
				if(GetPVarInt(i, "Police:Spikes"))
				{
					Streamer_GetFloatData(STREAMER_TYPE_OBJECT, GetPVarInt(i, "Police:Spikes"), E_STREAMER_X, X);
					Streamer_GetFloatData(STREAMER_TYPE_OBJECT, GetPVarInt(i, "Police:Spikes"), E_STREAMER_Y, Y);
					Streamer_GetFloatData(STREAMER_TYPE_OBJECT, GetPVarInt(i, "Police:Spikes"), E_STREAMER_Z, Z);
					if(IsPlayerInRangeOfPoint(playerid, 3.0, X, Y, Z))
					{
				        new panels, doors, lights, tires;
				        GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
				        tires = encode_tires(1, 1, 1, 1);
				        UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, 15);
					}
				}
			}
		}

		if(pstate == PLAYER_STATE_DRIVER || pstate == PLAYER_STATE_PASSENGER)
		{
			new modelid = GetVehicleModel(vehicleid);
	        new Speed = GetVehicleSpeed(vehicleid);
	        MyGetVehiclePos(vehicleid, X, Y, Z, A);
	        GetVehicleHealth(vehicleid, health);

	        if(VehInfo[vehicleid][vModelType] != MTYPE_BIKE && modelid != 432)
			{	
				if(EffectCheck{playerid} == 0 && OldSpeed[playerid] - Speed > 20)
				{	//  crash
					new Float:damage = (floatround(OldSpeed[playerid] - Speed) - 20) * DAMAGE_COEFFICIENT;
					CallLocalFunction("OnPlayerVehicleCrash", "if", playerid, damage);
				}
				OldSpeed[playerid] = Speed;
			}
		}
		else
		{
			MyGetPlayerPos(playerid, X, Y, Z, A);
		}
		//---
		if(GetPVarInt(playerid, "Police:Pursuit:Handsup") && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_HANDSUP)
		{
			MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);
		}
		//	---	Attach weapon
		if(GetTickCount() - armedbody_pTick[playerid] > 113)
		{
			new slots[] = { 3, 5 }, weapon, ammo, pArmedWeapon = GetPlayerWeapon(playerid);
			for(new i = 0; i < sizeof(slots); i++)
			{
				GetPlayerWeaponData(playerid, slots[i], weapon, ammo);
				if(weapon && ammo && pArmedWeapon != weapon)
				{
					if(IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_SLOT_WEAPON + i) == 0)
					{
						SetPlayerAttachedObject(playerid, ATTACH_SLOT_WEAPON + i, GetWeaponModel(weapon), attachWeaponPos[i][WA_BONE], Arr6<attachWeaponPos[i][WA_POS]>, 1.0, 1.0, 1.0);
					}
				}
				else if(IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_SLOT_WEAPON + i))
				{
					RemovePlayerAttachedObject(playerid, ATTACH_SLOT_WEAPON + i);
				}
			}
			//---
			armedbody_pTick[playerid] = GetTickCount();
		}
		// Debug TextDraw
		if(showDebug[playerid])
		{
		    new Float:mapZ, status[32] = "~r~flying";
			MapAndreas_FindZ_For2DCoord(X, Y, mapZ);
			if(GetPlayerInterior(playerid) > 0)				status = "~y~inter";
			else if(Z < 0.1 && IsPlayerSwiming(playerid))	status = "~b~swiming";
			else if(Z < mapZ + 2.5)							status = "~g~ground";

			GetPlayerHealth(playerid, health);
			format(string, 512, "~y~DEBUG:~n~\
								~w~x: %.1f, y: %.1f, z: %.1f, angel: %.0f~n~\
								~w~mapZ: %.2f   %s~w~~n~\
								Interior: %02d, Virt.World: %02d~n~\
								Dialogid: %d~n~\
								pState: %d, pSpeed: %d~n~\
								InGangZone: %d~n~\
								PickupedBiz: %d",
								X, Y, Z, A,
								mapZ, status,
								GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid),
								Dialogid[playerid], pstate, GetPlayerSpeed(playerid), InGangZone[playerid], PickupedBiz[playerid]);
			PlayerTextDrawSetString(playerid, debugTD, string);
		}
	}
	return true;
}

public OnPlayerStreamIn(playerid, forplayerid)
{// playerid �������� � ���� ��� forplayerid
	if(InMask[forplayerid])
		ShowPlayerNameTagForPlayer(playerid, forplayerid, false);
	else
		ShowPlayerNameTagForPlayer(playerid, forplayerid, pNameTags[playerid]);
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{// playerid ������� �� ���� forplayerid
	/*if(SpectateID[forplayerid] == playerid)
	{
		UpdatePlayerSpectate(forplayerid, playerid);
		Timer_UpdatePlayerSpectate(forplayerid, playerid);
	}*/
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	if(VehInfo[vehicleid][vModelType] == MTYPE_TRAIN || VehInfo[vehicleid][vLocked] > 0)
		SetVehicleParamsForPlayer(vehicleid, forplayerid, 0, true);
	else
		SetVehicleParamsForPlayer(vehicleid, forplayerid, 0, false);
	return true;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return true;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(playerid != clickedplayerid)
	{
	    //  Phone system
	    if(IsPlayerLogged(clickedplayerid))
		{
	        SetPVarInt(playerid, "Phone:ClickPlayer", clickedplayerid);
            Dialog_Show(playerid, Dialog:Phone_Main);
		}
	}
	else
	{
		ShowDialog(playerid, DMENU_MAIN);
	}
	return true;
}

stock ShowLicenses(giveplayerid, playerid)
{
	new lstring[1024];
	format(lstring, sizeof(lstring),	MAIN_COLOR "� {FFFFFF}����� ��������� A:\t%s\n\
									"	MAIN_COLOR "� {FFFFFF}����� ��������� B:\t%s\n\
									"	MAIN_COLOR "� {FFFFFF}����� ��������� C:\t%s\n\
									"	MAIN_COLOR "� {FFFFFF}����� ��������� D:\t%s\n\
									"	MAIN_COLOR "� {FFFFFF}�������� �� ������:\t%s",
									(PlayerInfo[playerid][pCarLicA]) ? (SCOLOR_GREEN "[�������]") : ("{FF6347}[�����������]"),
									(PlayerInfo[playerid][pCarLicB]) ? (SCOLOR_GREEN "[�������]") : ("{FF6347}[�����������]"),
									(PlayerInfo[playerid][pCarLicC]) ? (SCOLOR_GREEN "[�������]") : ("{FF6347}[�����������]"),
									(PlayerInfo[playerid][pCarLicD]) ? (SCOLOR_GREEN "[�������]") : ("{FF6347}[�����������]"),
									(PlayerInfo[playerid][pGunLic])	? (SCOLOR_GREEN "[�������]") : ("{FF6347}[�����������]"));

	new string[64];
    if(playerid == giveplayerid) string = "������ ��������";
	else format(string, sizeof(string), "%s[%d]: ��������", ReturnPlayerName(playerid), playerid);
	return MyShowPlayerDialog(giveplayerid, DMODE_NONE, DIALOG_STYLE_TABLIST, string, lstring, "�������", "", 0);
}

stock ShowPass(giveplayerid, playerid)
{
	new string[512], jobname[32] = "{FF6347}�����������";
    if(PlayerInfo[playerid][pFaction] > 0)
	{
		format(string, sizeof(string),	MAIN_COLOR "� {FFFFFF}�������:\t" MAIN_COLOR "%s\n\
									"	MAIN_COLOR "� {FFFFFF}����:\t" MAIN_COLOR "%s\n",
										GetFactionName(PlayerInfo[playerid][pFaction]),
										GetPlayerRank(playerid));
	}
    else
	{
		new job = Job.GetPlayerJob(playerid);
		if(job > 0 && IsLegalJob(job)) format(jobname, 32,	MAIN_COLOR "%s", GetJobName(job));
		format(string, sizeof(string), "%s" MAIN_COLOR "� {FFFFFF}����� ������:\t%s\n", string, jobname);
	}
    /*format(string, sizeof(string), "%s"MAIN_COLOR"� {FFFFFF}�����������������:\t%s%d\n\n\
    								"MAIN_COLOR"� {FFFFFF}�������� �� ��������:\t%s\n\
									"MAIN_COLOR"� {FFFFFF}�������� �� ������:\t%s",
									string,
									PlayerInfo[playerid][pLaw] > 0 ? (""MAIN_COLOR"") : ("{FF6347}"),
									PlayerInfo[playerid][pLaw],
									PlayerInfo[playerid][pCarLic] ? (""MAIN_COLOR"�������") : ("{FF6347}�����������"),
    								PlayerInfo[playerid][pGunLic] ? (""MAIN_COLOR"�������") : ("{FF6347}�����������"));*/
	new title[48];
	if(playerid == giveplayerid) title = "���������";
	else format(title, 48, "%s[%d]: ���������", ReturnPlayerName(playerid), playerid);
	return MyShowPlayerDialog(giveplayerid, DMODE_NONE, DIALOG_STYLE_TABLIST, title, string, "�������", "");
}

stock ShowStats(giveplayerid, playerid)
{
	new string[128], lstring[1792], account[64];

	if(PlayerInfo[playerid][pVip])
	{
		mysql_format(g_SQL, string, sizeof(string), "SELECT FROM_UNIXTIME(`vipunix`) FROM `players` WHERE `id` = '%d'", PlayerInfo[playerid][pUserID]);
		new Cache:result = mysql_query(g_SQL, string);
		cache_get_value_index(0, 0, string);
		cache_delete(result);
		format(account, sizeof(account), "�������\n{FFFFFF}������� ��:\t\t\t{B1C8FB}%s", string);
	}
	else account = "�����������";
	//new IPadress[16];
	//GetPlayerIp(playerid, IPadress, sizeof(IPadress));

	//	�����
	format(lstring, sizeof(lstring), "{FFFFFF}���:\t\t\t\t{B1C8FB}%s\n\
	                                {FFFFFF}�������:\t\t\t{B1C8FB}%s\n\
	                                {FFFFFF}����� ��������:\t\t{B1C8FB}%d\n\
									\n\
									{FFFFFF}�������:\t\t\t{B1C8FB}%d\n\
									{FFFFFF}����:\t\t\t\t{B1C8FB}%d/%d\n\
									{FFFFFF}��������:\t\t\t{B1C8FB}%d\n\
									{FFFFFF}��������������:\t\t{B1C8FB}%d/3\n\
									\n\
									{FFFFFF}���� ID:\t\t\t{B1C8FB}%d\n\
									{FFFFFF}����������.:\t\t\t{B1C8FB}%d\n\
									{FFFFFF}������:\t\t\t{B1C8FB}%d\n",
													ReturnPlayerName(playerid),
													account,
													PlayerInfo[playerid][pUserID],
													PlayerInfo[playerid][pLevel],
													PlayerInfo[playerid][pExp], getNextLevelExp(playerid),
													PlayerInfo[playerid][pUpgrade],
													PlayerInfo[playerid][pWarns],
													PlayerInfo[playerid][pSkin],
													PlayerInfo[playerid][pLaw],
													GetPlayerWantedLevel(playerid));
	format(lstring, sizeof(lstring), "%s\
									{FFFFFF}�������:\t\t\t{B1C8FB}%d\n\
									{FFFFFF}�������:\t\t\t{B1C8FB}%d\n\
									\n\
									{FFFFFF}������:\t\t\t{B1C8FB}$%d.00\n\
									{FFFFFF}� �����:\t\t\t{B1C8FB}$%.2f\n\
									{FFFFFF}������:\t\t\t{B1C8FB}%d ��\n",
													lstring,
													PlayerInfo[playerid][pDeaths],
													PlayerInfo[playerid][pKills],
													PlayerInfo[playerid][pMoney],
													PlayerInfo[playerid][pBank],
													GetPlayerCoins(playerid));

	//	������
	format(lstring, sizeof(lstring), "%s\n{FFFFFF}������:\t\t\t{B1C8FB}%s\n", lstring, GetJobName(Job.GetPlayerJob(playerid)));
	if(Job.GetPlayerJob(playerid))
	{
		format(lstring, sizeof(lstring), "%s{FFFFFF}��������:\t\t\t{B1C8FB}%d �����\n", lstring, Job.GetPlayerContract(playerid));
	}

	//	�����������
	new fname[32] = "�����������";
	if(PlayerInfo[playerid][pFaction] > 0)
	{
		strput(fname, GetFactionName(PlayerInfo[playerid][pFaction]));
	}
	format(lstring, sizeof(lstring), "%s\n{FFFFFF}�����������:\t\t\t{B1C8FB}%s\n", lstring, fname);
	if(PlayerInfo[playerid][pFaction] > 0)
	{
		format(lstring, sizeof(lstring),
			"%s{FFFFFF}���������:\t\t\t{B1C8FB}%s\n\
			{FFFFFF}����:\t\t\t\t{B1C8FB}%d\n",
				lstring, GetPlayerRank(playerid), PlayerInfo[playerid][pRank]);
	}

	//	�����
	new h = FoundHouse(GetPlayerHouse(playerid));
	if(h != (-1))
	{
		format(lstring, sizeof lstring, "%s\n{FFFFFF}���:\t\t\t\t{B1C8FB}%s, %d", lstring, GetPointArea(HouseInfo[h][hX], HouseInfo[h][hY]), HouseInfo[h][hID]);
	}
	if(PlayerInfo[playerid][pRent] > 0)
	{
		h = FoundHouse(PlayerInfo[playerid][pRent]);
		if(h != (-1))
		{
			format(lstring, sizeof lstring, "%s\n{FFFFFF}����������:\t\t\t{B1C8FB}%s, %d\n", lstring, GetPointArea(HouseInfo[h][hX], HouseInfo[h][hY]), HouseInfo[h][hID]);
		}
	}
	else if(PlayerInfo[playerid][pRent] < 0)
	{
		format(lstring, sizeof lstring, "%s\n{FFFFFF}����������:\t\t\t{B1C8FB}Los Santos, Jefferson\n", lstring);
	}
	else if(PlayerInfo[playerid][pHousing] > 0)
	{
		h = FoundHouse(PlayerInfo[playerid][pHousing]);
		if(h != (-1))
		{
			format(lstring, sizeof lstring, "%s\n{FFFFFF}����������:\t\t\t{B1C8FB}%s, %d\n", lstring, GetPointArea(HouseInfo[h][hX], HouseInfo[h][hY]), HouseInfo[h][hID]);
		}
	}
	else
	{
		strcat(lstring, "\n{FFFFFF}����������:\t\t\t{B1C8FB}�����������\n");
	}

	//	������
	new b = FoundBiz(GetPlayerBiz(playerid));
	if(b != (-1))
	{
		format(lstring, sizeof(lstring),
			"%s\n{FFFFFF}������:\t\t\t{B1C8FB}%s\n\
			{FFFFFF}��������:\t\t\t{B1C8FB}'%s'\n\
			{FFFFFF}�����:\t\t\t\t{B1C8FB}%s\n",
				lstring, BizTypeData[ BizInfo[b][bType] ][btName], BizInfo[b][bName],
				GetPointArea(BizInfo[b][bPos][0], BizInfo[b][bPos][1]));
	}

	strcat(lstring, "                  "MAIN_COLOR"________________________________\n\
						\t\t       Silver Break � 2016\n\
						\t\t\t "SITE_ADRESS);

    if(playerid == giveplayerid) string = "������ ����������";
	else format(string, sizeof(string), "%s[%d]: ����������", ReturnPlayerName(playerid), playerid);
	return MyShowPlayerDialog(giveplayerid, DMENU_STATS, DIALOG_STYLE_MSGBOX, string, lstring, "��", ((openWithMenu[playerid]) ? ("�����") : ("�������")), 0);
}

stock ShowDialog(playerid, dialogid, action = INVALID_DIALOGID)
{
	if(dialogid != -1 && Dialogid[playerid] != INVALID_DIALOGID) return true;

	new string[128], lstring[1024];
	if(action == INVALID_DIALOGID) action = dialogid;
	switch(dialogid)
	{
	    case INVALID_DIALOGID:	// ������ ���������� ����
	    {
	        MyHidePlayerDialog(playerid);
	    }
	    case DMODE_EMAIL:	// ���� �����
	    {
		    strcat(lstring, "������� email ����� ����� ����� � ������ � ������� '������'\n\
		    				��� ���� ����������� �������� ������ � ������ ����� ��� ������");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "������� email �����", lstring, "������", "�����", 0);
	    }
	    case DMODE_NEWBIE:
	    {
	    	strcat(lstring, ""MAIN_COLOR"� {FFFFFF}��� ��� ������?\n\
	    	"MAIN_COLOR"� {FFFFFF}��� ���������� �����?\n\
	    	"MAIN_COLOR"� {FFFFFF}��� �������� �������?\n\
	    	"MAIN_COLOR"� {FFFFFF}����� ������� ���� �� �������?\n\
	    	"MAIN_COLOR"� {FFFFFF}��� �������� �������?\n\
	    	"MAIN_COLOR"� {FFFFFF}��� �� ������� ������� ������\n\
	    	"MAIN_COLOR"� {FFFFFF}������ ������");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "����������", lstring, "�������", "�����", 0);
	    }
	    case DMODE_ADMINS:// ������ ������
	    {
	        new bool:found;
			foreach(LoginPlayer, i)
			{
	            if(GetPlayerAdmin(i))
	            {
	                format(lstring, sizeof lstring, "%s%s %s[%d]\n", lstring, GetPlayerAdminStatus(i), ReturnPlayerName(i), i);
	                found = true;
	            }
	        }
	        if(!found)
				return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������� ��� ��������������� ������.");
	        MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_LIST, "������ �������������", lstring, "��");
	    }
	    case DMODE_ANIMLIST:
	    {
			for(new i; i < sizeof(AnimList); i++)
			{
			    format(lstring, sizeof(lstring), "%s[%d] %s\n", lstring, i+1, AnimList[i][ANIM_TITLE]);
			}
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "������ ��������", lstring, "���������", "�������");
	    }
	    case DMODE_LAWYER:
	    {
	        if(PlayerInfo[playerid][pJailTime] > 0) return 1;
	        new wl = -PlayerInfo[playerid][pJailTime];
	        new wl2 = wl-1;
	        // ��� ����� ��������
	        strcat(lstring, "{FFFFFF}��� ��������:\t\t[0$]\t\t");
	        if(wl == 0)			format(lstring, sizeof lstring, "%s{33AA33}[������������]\n", lstring);
	        else if(wl < 4)		format(lstring, sizeof lstring, "%s{8D8DFF}[�����: %d$]\n", lstring, wl * FINE_PER_WANTED);
	        else 				format(lstring, sizeof lstring, "%s{FF6347}[������: %d ��.]\n", lstring, wl - 3);
			// � �������� ��������
			format(lstring, sizeof lstring, "%s{FFFFFF}� ���������:\t\t[%d$]\t\t", lstring, floatround(wl * FINE_PER_WANTED * 1.5));
	        if(wl2 <= 0)		format(lstring, sizeof lstring, "%s{33AA33}[������������]\n", lstring);
	        else if(wl2 < 4)	format(lstring, sizeof lstring, "%s{8D8DFF}[�����: %d$]\n", lstring, wl2 * FINE_PER_WANTED);
	        else 				format(lstring, sizeof lstring, "%s{FF6347}[������: %d ��.]\n", lstring, wl2 - 3);
	        // �������� �����
			format(lstring, sizeof lstring, "%s{FFFFFF}�������� �����:\t[%d coins]\t{33AA33}[������������]", lstring, wl*5);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "��� ������������ ��������", lstring, "�������", "�������");
	    }
	    case DMODE_POLICE_HQ:
	    {
	    	if(PM_Type[playerid] == 0)
	    	{
	    		if(PoliceMission[0][pmNum] == 0)
	    		{
	    			lstring = "{AFAFAF}��� �� ������ ���������� �������.";
	    		}
	    		else
	    		{
			 		for(new x = 0; x < sizeof(PoliceMission); x++)
				    {
				        if(PoliceMission[x][pmNum] == 0)	break;
				        new lefttime = PoliceMission[x][pmUNIX] - gettime();
				        new leftmin = lefttime / 60;
				        new leftsec = lefttime % 60;
				        strput(string, GetPointArea(HouseInfo[ PoliceMission[x][pmPlace] ][hX], HouseInfo[ PoliceMission[x][pmPlace] ][hY]));
				        format(lstring, sizeof(lstring), "%s{8D8DFF}#%d: {FFFFFF}������� �� %s, %d {8D8DFF}(��������: %02d:%02d)\n",lstring, PoliceMission[x][pmNum],
																																	string,
																																	HouseInfo[ PoliceMission[x][pmPlace] ][hID],
																																	leftmin, leftsec);
					}
	    		}
				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "Los Santos Police Dept.", lstring, "�������", "�������");
			}
			else
			{
		        new lefttime = PM_UNIX[playerid] - gettime();
		        if(PM_Type[playerid] == 10) lefttime *= -1;
		        new leftmin = lefttime / 60;
		        new leftsec = lefttime % 60;
			    strcat(lstring, "{B1C8FB}������� �������:\n");
			    if(PM_Type[playerid] == 2 && PM_Step[playerid] == 1)
			    {
				    strcat(lstring, "{FFFFFF}������� �������������� � �������\n");
			    }
			    else if(PM_Type[playerid] == 3)
			    {
			    	if(PM_Step[playerid] == 1)
			    	{
			   			format(lstring, sizeof(lstring), "%s{FFFFFF}����� %s � ��������� ���� ������\n", lstring, ReturnVehicleName(PM_Place[playerid]));
			    	}
			   		else if(PM_Step[playerid] == 2)
			   		{
			   			strcat(lstring, "{FFFFFF}���������� �������� ������, ������� � ���\n");
			   		}
			    }
			    else if(PM_Type[playerid] == 10)
			    {
			   		format(lstring, sizeof(lstring), "%s{FFFFFF}���������� � ��������� �������������� %s[%d]\n", lstring, ReturnPlayerName(PM_Place[playerid]), PM_Place[playerid]);
			    }
			    else
			    {
			    	format(lstring, sizeof(lstring), "%s{FFFFFF}�������� ����� �� ���� %d �� Los Santos\n", lstring, HouseInfo[PM_Place[playerid]][hID]);
			    }
			    format(lstring, sizeof(lstring), "%s{B1C8FB}��������: {FFFFFF}%02d:%02d\n", lstring, leftmin, leftsec);
		 		strcat(lstring, "\n{FF6347}��� ������ ������� ������� 'cancel' ��� '������':");
				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "{000CFF}Los Santos Police Dept.", lstring, "������", "�������");
			}
	    }
	    case DMODE_POLICE_MISSION:
	    {
			switch(PM_Type[playerid])
			{
			    case 1:// ������ �����
			    {
			        if(random(2) == 0)
			        {
				        strcat(lstring, "����������: '������������, ������. ��, ��� � ��� ��������...\n\
										� �������� �����-�� ��� �� ������ ����� � ��������������.\n\
										���������, ��� ��� ���� ���-�� ������. �������� �� ������������.'");
			        }
			        else
			        {
				        strcat(lstring, "����������: '����� ��������, ������.\n\
										� ������� �������� � ���������� �������� � �������!\n\
										��� ��� ������� ������ � ���� ���������. ��� ��� ��������.'");
			        }
			    }
			    case 2:// ������ �������
			    {
			        strcat(lstring, "����������: '� ��� �������� �����-�� ������� � ����� ��������!\n\
									� ���� ��� ������ ��� � �����. �������� ���-������, ����������!'\n\
			        				(����� �� �������): '����� �������! � ��� ��� ��� �������!'");
			    }
			    case 3:// ���� ������
			    {
			        strcat(lstring, "����������: '��� ������� ������ ��� ������ ����� �� ��� ����!\n\
			        				�� ������ � �� �������! ������� ��� ������, ����������! ��� ��� ������.'" );
			    }
			    case 4:// ������ �������
			    {
			    }
			}
			format(string, sizeof(string), "��� #%d", HouseInfo[ PM_Place[playerid] ][hID]);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, string, lstring, "�������", "", 0);
	    }
	    case DMODE_POLICE_DUTY:
	    {
	    	new str[2][32];
	    	if(GetPlayerWantedLevel(playerid))	format(str[0], 32, "[-$%d]", GetPlayerWantedLevel(playerid) * FINE_PER_WANTED);
	    	else 								strcat(str[0], "{AFAFAF}[��� �������]");

	    	if(PlayerInfo[playerid][pGunLic])	strcat(str[1], "{AFAFAF}[����������]");
	    	else
	    	{
	    		if(PlayerInfo[playerid][pShooting] >= 4)	strcat(str[1], "[-$350]");
		    	else 										strcat(str[1], "{AFAFAF}[����������]");
	    	}
	    	format(lstring, sizeof(lstring),
	    		""MAIN_COLOR"� {FFFFFF}�������� ������\t%s\n\
	    		"MAIN_COLOR"� {FFFFFF}�������� �������� �� ������\t%s", str[0], str[1]);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST, "����������� �������", lstring, "�������", "�������");
	    }
	    case DMODE_POLICE_WANTED:
	    {
		    format(lstring, sizeof(lstring), "\n{FFFFFF}�� ������ �������� ����� � ������� {44B2FF}$%d{FFFFFF}?\n\t", (GetPlayerWantedLevel(playerid) * FINE_PER_WANTED));
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "������ ������", lstring, "��������", "�����");
	    }
	    case DMODE_POLICE_STOPMENU:
	    {
	    	new target = PM_Place[playerid];
	    	new hour; gettime(hour, _, _);
	    	new wl = GetPlayerWantedLevel(target);
	    	//new vehicleid = GetPlayerVehicleID(target);
	    	//if(vehicleid == 0)
	    	new vehicleid = gLastVehicle[target];
	    	new _wlstr[24];
	    	if(wl == 0)	format(_wlstr, sizeof(_wlstr), "{33AA33}[��� �������]");
	    	else 		format(_wlstr, sizeof(_wlstr), "{FF6347}[������: %d]", wl);
	    	format(string, sizeof(string), "%s %s", ReturnPlayerName(target), _wlstr);
	    	if(wl < 4)
	    	{
	    		if(GetPlayerState(target) == PLAYER_STATE_DRIVER)
	    		{
	    			strcat(lstring, ""MAIN_COLOR"� {FFFFFF}����������� �����\n");
	    		}
	    		else
	    		{
	    			strcat(lstring, ""MAIN_COLOR"� {FFFFFF}��������������\n\n");
	    		}
	    		if(vehicleid > 0 && GetPVarInt(target, "Pursuit:CheckDoc") == 0)
	    		{
	    			strcat(lstring, ""MAIN_COLOR"� {FFFFFF}��������� ���������\n");
	    		}
	    		else
	    		{
	    			strcat(lstring, "{AFAFAF}� ��������� ���������\t{AFAFAF}[����������]\n");
	    		}
	    		if(vehicleid > 0 && GetPVarInt(target, "Pursuit:CheckDrunk") == 0)
	    		{
	    			strcat(lstring, ""MAIN_COLOR"� {FFFFFF}��������� �� ���������\n");
	    		}
	    		else
	    		{
	    			strcat(lstring, "{AFAFAF}� ��������� �� ���������\t{AFAFAF}[����������]\n");
	    		}
	    		if(vehicleid > 0 && GetPVarInt(target, "Pursuit:CheckLight") == 0 && IsVehicleWithEngine(vehicleid) && (hour <= 5 || hour >= 20))
	    		{
	    			strcat(lstring, ""MAIN_COLOR"� {FFFFFF}��������� ��������� ���\n");
	    		}
	    		else
	    		{
	    			strcat(lstring, "{AFAFAF}� ��������� ��������� ���\t{AFAFAF}[����������]\n");
	    		}
		    	if(wl > 0)	strcat(lstring, ""MAIN_COLOR"� {CFB53B}�������� �����");
		    	else 		strcat(lstring, ""MAIN_COLOR"� {CFB53B}��������� ��������");
	    	}
	    	else
	    	{
	    		strcat(lstring, ""MAIN_COLOR"� {CFB53B}����������� �����");
	    	}
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, string, lstring, "�������", "");
	    }
	    case DMODE_SHOP:
	    {
			format(lstring, sizeof(lstring),
				"�����\t����\n\
				" MAIN_COLOR "� {FFFFFF}�������� ����\t$%d\n\
				" MAIN_COLOR "� {FFFFFF}�������� � �������\t$%d\n\
				" MAIN_COLOR "� {FFFFFF}��������� �������\t$%d\n\
				" MAIN_COLOR "� {FFFFFF}���������\t$%d\n\
				" MAIN_COLOR "� {FFFFFF}����� �������\t$%d\n\
				" MAIN_COLOR "� {FFFFFF}���������\t$%d\n\
				" MAIN_COLOR "� {FFFFFF}�������\t$%d\n\
				" MAIN_COLOR "� {FFFFFF}����\t$%d\n\
				" MAIN_COLOR "� {FFFFFF}�������\t$%d\n\
				" MAIN_COLOR "� {FFFFFF}�����\t$%d\n\
				" MAIN_COLOR "� {FFFFFF}������\t$%d", GetThingCost(THING_WATCH), 
													80, 
													150, 
													GetThingCost(THING_FIREWORK), 
													GetThingCost(THING_CIGARETTE) * 10,
													GetThingCost(THING_CHOCOLATE),
													GetThingCost(THING_BOX),
													GetThingCost(THING_SUITCASE),
													GetThingCost(THING_SUITCASE2),
													GetThingCost(THING_BAG),
													GetThingCost(THING_BAG2));
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST_HEADERS, "������ 24/7", lstring, "������", "�������");
	    }
	    case DMODE_SEXSHOP:
	    {
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "���� ��� (��� �� $35)", 	MAIN_COLOR "� {FFFFFF}������� �������������\n\
																								" MAIN_COLOR "� {FFFFFF}�������������\n\
																		        				" MAIN_COLOR "� {FFFFFF}��������\n\
																		        				" MAIN_COLOR "� {FFFFFF}���������� ��������\n", "������", "�������");
	    }
	    case DMODE_HOUSE:
	    {
	        if(PickupedHouse[playerid] >= 0)
	        {
		        new h = PickupedHouse[playerid];
		        new Class = HouseInfo[h][hClass] + 64;
		        if(!HouseInfo[h][hOwnerID])
		        {
					if(HouseInfo[h][hDonate] == 0)
					{
					    format(lstring, sizeof(lstring),
							"{FFFFFF}�����: "MAIN_COLOR"%c\n{FFFFFF}��������: " MAIN_COLOR "%d\n{FFFFFF}���������: " MAIN_COLOR "%d$", Class, HouseInfo[h][hInt], HouseInfo[h][hPrice]);
					}
					else
					{
					    format(lstring, sizeof(lstring),
							"{CFB53B}�����: {FFFFFF}%c (�������)\n{CFB53B}��������: {FFFFFF}%d\n{CFB53B}���������: {FFFFFF}%d �����", Class, HouseInfo[h][hInt], HouseInfo[h][hPrice]);
					}
					format(string, sizeof(string), "��� #%d", HouseInfo[h][hID]);
					MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, string, lstring, "������", "�������");
		        }
	        }
	    }
	    case DMODE_HOUSE_SELL:
	    {
		    strcat(lstring, 	"{B1C8FB}�� ��������� ������� ���� ���\n\
								��� ������������� ������� 'sell' ��� '�������'\n\
		    					��� ������ ������� ������� �� ������ '������'\n");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "��������������", lstring, "������", "������");
			GameTextForPlayer(playerid, "~r~Warning!~n~", 5000, 4);
	    }
	    case DMODE_RADIO:
	    {
	        new vehicleid = GetPlayerVehicleID(playerid);
	        if(vehicleid > 0 && GetPlayerState(playerid) == 2)
	        {
	        	if(VehInfo[vehicleid][vRadio] > 0)	strcat(lstring, "{FF6347}[!] ");
				else 								strcat(lstring, "{6E6E6E}");
		        strcat(lstring, "��������� �����\n");
		        for(new r; r < sizeof(RadioList); r++)
		        {
					if(VehInfo[vehicleid][vRadio] == r+1)	strcat(lstring, "{33AA33}");
					else 									strcat(lstring, "{FFFFFF}");
		            format(string, 128, "%s\n", RadioList[r][RADIO_NAME]);
		            strcat(lstring, string);
		        }
				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "��������: ������������", lstring, "�������", "�������");
	        }
	    }
	    case DMODE_RADIO_PLEER:
	    {
	        if(Acsr.GetSlotToType(playerid, ACSR_EARFLAPS) == INVALID_DATA)
	        {
	        	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���� � ���������.");
	        }
        	if(GetPVarInt(playerid, "Thing:RadioID"))	strcat(lstring, "{FF6347}[!] ");
			else 										strcat(lstring, "{6E6E6E}");
	        strcat(lstring, "��������� �����\n");
	        for(new r; r < sizeof(RadioList); r++)
	        {
				if(GetPVarInt(playerid, "Thing:RadioID") == r+1)	strcat(lstring, "{33AA33}");
				else 												strcat(lstring, "{FFFFFF}");
	            format(string, 128, "%s\n", RadioList[r][RADIO_NAME]);
	            strcat(lstring, string);
	        }
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "�����: ������������", lstring, "�������", "�������");
	    }
	    case DMODE_VMENU:
	    {
	    	new vehicleid = GetPVarInt(playerid, "VehicleMenu:VehicleID"),
	    		driverid = VehInfo[vehicleid][vDriver];
	    	if(PlayerInfo[playerid][pFaction] == F_POLICE && IsPoliceDuty(playerid))
			{
				if(PM_Type[playerid] == 10)
				{
					if(driverid >= 0 && PM_Place[playerid] == driverid && PursuitStatus[driverid] == PS_WAIT)
					{
						return ShowDialog(playerid, DMODE_POLICE_STOPMENU);
					}
				}
				else if(PM_Type[playerid] == 0)
				{
					if(driverid >= 0 && PursuitStatus[driverid] == PS_NONE)
					{
						format(lstring, sizeof(lstring), "����������� ����� %s'�\n", ReturnPlayerName(VehInfo[vehicleid][vDriver]));
					}
					if(VehInfo[vehicleid][vCoDriver] >= 0 && PursuitStatus[ VehInfo[vehicleid][vCoDriver] ] == PS_NONE)
					{
						format(lstring, sizeof(lstring), "%s����������� ����� %s'�\n", lstring, ReturnPlayerName(VehInfo[vehicleid][vCoDriver]));
					}
					if(VehInfo[vehicleid][vLeftSeat] >= 0 && PursuitStatus[ VehInfo[vehicleid][vLeftSeat] ] == PS_NONE)
					{
						format(lstring, sizeof(lstring), "%s����������� ����� %s'�\n", lstring, ReturnPlayerName(VehInfo[vehicleid][vLeftSeat]));
					}
					if(VehInfo[vehicleid][vRightSeat] >= 0 && PursuitStatus[ VehInfo[vehicleid][vRightSeat] ] == PS_NONE)
					{
						format(lstring, sizeof(lstring), "%s����������� ����� %s'�\n", lstring, ReturnPlayerName(VehInfo[vehicleid][vRightSeat]));
					}
				}
		    }
			else if(Job.GetPlayerNowWork(playerid) == JOB_MECHANIC)
			{
				if(VehInfo[vehicleid][vDriver] >= 0)
				{
					strcat(lstring, "���������� ��������\n");
				}
			}
			format(lstring, sizeof(lstring), "%s%s ������\n", lstring, VehInfo[vehicleid][vLocked] ? ("�������") : ("�������"));
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "���� ����", lstring, "�������", "�������");
	    }
	    case DMODE_REFILL:
	    {
	    	new vehicleid = gLastVehicle[playerid];
	    	if(CarInfo[vehicleid][cType] != C_TYPE_JOB || CarInfo[vehicleid][cOwnerID] != JOB_MECHANIC)
	    	{
	    		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, ��� ��������� ��������� ������ ���� �������.");
	    	}
	    	new Float:pos[3];
	    	new v = GetPVarInt(playerid, "Mechanic:Refill:VehicleID");
			GetVehiclePos(v, Arr3<pos>);
			if(GetVehicleDistanceFromPoint(vehicleid, Arr3<pos>) > 10)
			{
				return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, ��� ������� ���� ������ ���� ����� � ������������.");
	    	}
	    	if(GetPlayerDistanceFromPoint(playerid, Arr3<pos>) > 10)
			{
				return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, �� ������ ���� ����� � ������������ �����������.");
	    	}
	    	if(VehInfo[v][vDriver] < 0)
			{
				return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, � ���������� ������ ������ ��������.");
			}
	    	format(lstring, sizeof(lstring), "{FFFFFF}������� ���������� ������ ��� �������� ����\n\
	    		� ���� %d/%d ������\n\
	    		� ��� %d ������", floatround(VehInfo[v][vFuel]), GetVehicleMaxFuel(v), floatround(VehInfo[vehicleid][vFuel]));
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "��������", lstring, "����", "�������");
	    }
	    case DMODE_REFILL2:
	    {
	    	new vehicleid = gLastVehicle[playerid];
	    	if(CarInfo[vehicleid][cType] != C_TYPE_JOB || CarInfo[vehicleid][cOwnerID] != JOB_MECHANIC)
	    	{
	    		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, ��� ��������� ��������� ������ ���� �������.");
	    	}
	    	new Float:pos[3];
	    	new v = GetPVarInt(playerid, "Mechanic:Refill:VehicleID");
			GetVehiclePos(v, Arr3<pos>);
			if(GetVehicleDistanceFromPoint(vehicleid, Arr3<pos>) > 10)
			{
				return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, ��� ������� ���� ������ ���� ����� � ������������.");
	    	}
	    	if(GetPlayerDistanceFromPoint(playerid, Arr3<pos>) > 10)
			{
				return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, �� ������ ���� ����� � ������������ �����������.");
	    	}
	    	if(VehInfo[v][vDriver] < 0)
			{
				return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, � ���������� ������ ������ ��������.");
			}
			new count = GetPVarInt(playerid, "Mechanic:Refill:Count");
	    	format(lstring, sizeof(lstring), "{FFFFFF}������� ��������� �������� ����:\n\
	    		(�� $0 �� $%d)", floatround(PRICE_FUEL * count * 5));
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "��������", lstring, "����", "�����");
	    }
	    case DMODE_VFIND:
	    {
	        lstring = "������� �������� ���� ��������� ��� ��������:";
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "����� ����", lstring, "�����", "�������");
	    }
	    case DMODE_GOTOLIST:
	    {
	        for(new g = 0; g < sizeof GotoList; g++)
	            format(lstring, sizeof lstring, "%s[%d] %s\n", lstring, g + 1, GotoList[g][G_NAME]);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "����� ���������", lstring, "��������", "�������");
	    }
	    case DMODE_REPAIR:
		{
		    new item[4], price = 0, Float:health,
				v = GetPlayerVehicleID(playerid);
			GetVehicleDamageStatus(v, Arr4<item>);
			GetVehicleHealth(v, health);
			//printf("Vehicle Status : [Panels] : %d - [Doors] : %d - [Lights] : %d - [Tires] : %d", Arr4<item>);

			//	������
			if(item[0]) price += 25;
			//	����
			if(item[2]) price += 10;
		    //	�����
			new door_price = 0;
			if(item[1] & 0x4 || item[1] & 0x2)				door_price += 10;	//  ����� ���������
		    if(item[1] >> 8 & 0x4 || item[1] >> 8 & 0x2)	door_price += 10;	//  �������� ���������
		 	if(item[1] >> 16 & 0x4 || item[1] >> 16 & 0x2)  door_price += 10;	//  ����� �������� ����������
			if(item[1] >> 24 & 0x4 || item[1] >> 24 & 0x2)	door_price += 10;	//  ����� �������� ����������
			//	������
			new tire_price = 0;
			if(item[3] & 0x1)   tire_price += 10;
			if(item[3] & 0x2)   tire_price += 10;
			if(item[3] & 0x4)   tire_price += 10;
			if(item[3] & 0x8)   tire_price += 10;
			//  price
		    price = price + door_price + tire_price;
			SetPVarInt(playerid, "repair_body_price", price);

		// 	�������� ������
			if(price) 		format(lstring, sizeof(lstring), "%s"MAIN_COLOR"[1] {FFFFFF}�������� ������\t\t[%d$]\n", lstring, price);
			else 			strcat(lstring, "{AFAFAF}[1] �������� ������\t\t[�� ���������]\n" );
			if(item[0])		strcat(lstring, "{FFFFFF}   - ������ �������\t\t[25$]\n");
			else			strcat(lstring, "{AFAFAF}   - ������ �������\t\t[�� ���������]\n");
			if(door_price)	format(lstring, sizeof(lstring), "%s{FFFFFF}   - ������ ������\t\t[%d$]\n", lstring, door_price);
			else 			strcat(lstring, "{AFAFAF}   - ������ ������\t\t[�� ���������]\n");
			if(item[2])		strcat(lstring, "{FFFFFF}   - ������ ���\t\t\t[10$]\n");
			else 			strcat(lstring, "{AFAFAF}   - ������ ���\t\t\t[�� ���������]\n");
			if(tire_price)	format(lstring, sizeof(lstring), "%s{FFFFFF}   - ������ �����\t\t[%d$]\n", lstring, tire_price);
			else 			strcat(lstring, "{AFAFAF}   - ������ �����\t\t[�� ���������]\n");
		//  ���������
			if(health < 900.0)
			{
			    new e_price = floatround((1000.0 - health) / 7.5);
			    format(lstring, sizeof(lstring), "%s"MAIN_COLOR"[2] {FFFFFF}������� ���������\t\t[%d$]\n", lstring, e_price);
			    price += e_price;
			}
			else strcat(lstring, "{AFAFAF}[2] ������� ���������\t\t[�� ���������]\n");
			strcat(lstring,
				""MAIN_COLOR"[3] {FFFFFF}����������\t\t\t[100$]\n\
				"MAIN_COLOR"[4] {FFFFFF}����������� ������\n");
			SetPVarInt(playerid, "repair_all_price", floatround(price * 0.9));
			if(price)	format(lstring, sizeof(lstring), "%s"MAIN_COLOR"[5] {FFFFFF}������ ������\t\t[%d$]", lstring, floatround(price * 0.9));
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "��������������", lstring, "�������", "�������");
		}
		case DMODE_TUNING:
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			//	����
			lstring = "{FFFFFF}[1] ����\n";
			if(CarInfo[vehicleid][cNeon] != 1)	strcat(lstring, "{BA0A0A}- �������\t\t[30 coins]\n");
			else 								strcat(lstring, "{AFAFAF}- �������\t\t[��������]\n");
			if(CarInfo[vehicleid][cNeon] != 2)	strcat(lstring, "{0A0ABA}- �����\t\t[30 coins]\n");
			else 								strcat(lstring, "{AFAFAF}- �����\t\t[��������]\n");
			if(CarInfo[vehicleid][cNeon] != 3)	strcat(lstring, "{10BA0A}- �������\t\t[30 coins]\n");
			else 								strcat(lstring, "{AFAFAF}- �������\t\t[��������]\n");
			if(CarInfo[vehicleid][cNeon] != 4)	strcat(lstring, "{C9C00C}- ������\t\t[30 coins]\n");
			else 								strcat(lstring, "{AFAFAF}- ������\t\t[��������]\n");
			if(CarInfo[vehicleid][cNeon] != 5)	strcat(lstring, "{7A0CC9}- ����������\t\t[30 coins]\n");
			else 								strcat(lstring, "{AFAFAF}- ����������\t\t[��������]\n");
			if(CarInfo[vehicleid][cNeon] != 6)	strcat(lstring, "{FFFFFF}- �����\t\t[30 coins]\n");
			else 								strcat(lstring, "{AFAFAF}- �����\t\t[��������]\n");
			//	�����������
			if(CarInfo[vehicleid][cFlash])		strcat(lstring, "{AFAFAF}[2] �����������\t[��������]\n");
			else 								strcat(lstring, "{FFFFFF}[2] �����������\t[50 coins]\n");
			//  ������� ������
			strcat(lstring, "{FFFFFF}[3] ����� ������");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "�������������� - ����������� ������", lstring, "�������", "�����");
		}
		case DMODE_CARPLATE:
		{
		    format(lstring, sizeof(lstring), ""MAIN_COLOR"��������� ������: {FFFFFF}50 coins\n\
											  "MAIN_COLOR"������� �������: {FFFFFF}s-break, wanted, hunter\n\n\
											  "MAIN_COLOR"������� �������� �����: {FFFFFF}(�� 1 �� 9 ��������)");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "�������������� - ����������� ������", lstring, "������", "�����");
		}
		case DMODE_JOBLIST:
		{
			if(IsLegalJob(Job.GetPlayerJob(playerid)))
			{
				lstring = ""MAIN_COLOR"� ��������� � ������\n\
						{AFAFAF}� �������\t{AFAFAF}(2 ���)\n\
						{AFAFAF}� �������� ��������\t{AFAFAF}(2 ���)\n\
						{AFAFAF}� ������������\t{AFAFAF}(3 ���)\n\
						{AFAFAF}� �������\t{AFAFAF}(4 ���)";
			}
			else
			{
				lstring = ""MAIN_COLOR"�{FFFFFF} �������\t"MAIN_COLOR"(2 ���)\n\
						"MAIN_COLOR"�{FFFFFF} �������� ��������\t"MAIN_COLOR"(2 ���)\n\
						"MAIN_COLOR"�{FFFFFF} ������������\t"MAIN_COLOR"(3 ���)\n\
						"MAIN_COLOR"�{FFFFFF} �������\t"MAIN_COLOR"(4 ���)";
			}
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST, "��������� ������", lstring, "�������", "�������");
	    }
	    case DMODE_GAS:
	    {
			new vehicleid = gLastVehicle[playerid];
			new price = floatround(VehInfo[vehicleid][vWishFuel] * PRICE_FUEL, floatround_ceil);
			strcat(lstring, "[1] ������� �����������\n\
							[2] ������ �������");
			if(price > 0)	format(lstring, sizeof lstring, "%s(%d$)\n", lstring, price);
			else 			strcat(lstring, "(N/A)\n");

			format(lstring, sizeof lstring, "%s[3] ������� �������� (%d$)\n", lstring, floatround(PRICE_FUEL * 20));

			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "����������� �������", lstring, "�������", "�������");
	    }
	    case DMODE_GAS_REFILL:
	    {
	        new vehicleid = GetPlayerVehicleID(playerid);
	        if(vehicleid)
	        {
	        	new Float:price = PRICE_FUEL;
	        	if(Job.GetPlayerNowWork(playerid) == JOB_MECHANIC && CarInfo[vehicleid][cType] == C_TYPE_JOB && CarInfo[vehicleid][cOwnerID] == JOB_MECHANIC)
				{
					price *= 0.5;
				}
		        format(lstring, sizeof(lstring), "{FFFFFF}���������: "MAIN_COLOR"%0.1f$\n", price);
		        format(lstring, sizeof(lstring), "%s{FFFFFF}� ����� ����: "MAIN_COLOR"%d/%d�.\n", lstring, floatround(VehInfo[vehicleid][vFuel]), GetVehicleMaxFuel(vehicleid));
		        format(lstring, sizeof(lstring), "%s"MAIN_COLOR"������� �������� ���������� ������:\n", lstring);
		        format(lstring, sizeof(lstring), "%s\n{FFFFFF}(��������� ����� ��������� ����� ��������)", lstring);
				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "����������� �������", lstring, "������", "�������");
			}
	    }
	    case DMODE_GAS_RULES:
	    {
	        strcat(lstring, ""MAIN_COLOR"[������� �����������]\n\
	        				{FFFFFF}1. ��������� ��������� ����������\n\
	        				2. �����������, ����� � ��� ������� ���������\n\
	        				3. ������� ���, ������� ������� ��� ����������\n\
	        				4. �������� �� ����� ��� ������, ���� ��� ��������� ����� ��� ����������\n\
	        				\n���������� ��� ���������� �������� � ��������\n\
	        				� ������� ��� �� ������� ����������� ��� ��������� � ������\n\
	        				� �������� ��������� ����� 20% ������� ������ ���������\n");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "��������: ������� �����������", lstring, "��", "�����");
	    }
		case DMODE_AUTOSCHOOL:
		{
			if(PlayerInfo[playerid][pASElement] == 0xA98AC7 && PlayerInfo[playerid][pCarLic])
			{
				return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��� ��������� ������ ���������.");
			}
            else if(!PlayerInfo[playerid][pASElement])
			{	// �����������
				format(lstring, sizeof(lstring), "{FFFFFF}������������, ������������ ��� � ����� "MAIN_COLOR"���������{FFFFFF}!\n\n\
					�� ������ �������������� ������� ��� ������ ��������,\n\
					� ������ ����� �� �������� ����������!\n\
					��� ����� ��� ���������� ����� ��������� ��������� ��������� �� ��������!\n\n\
					��������� �������� � �����: "MAIN_COLOR"$%d\n\
					��������� �������� �� ������� � ����� �����!", PRICE_AUTOSCHOOL);
				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "���������", lstring, "��������", "�������");
			}
			else
			{	// ����������� ���������
				lstring = "{33AA33}< ��������� ��� �������� >{FFFFFF}\n";
				new count = 0;
			    for(new i = 1; i <= sizeof(AS_Mission); i++)
				{
					if((PlayerInfo[playerid][pASElement] >> i) & 0x1)
					{
						format(lstring, sizeof(lstring), "%s{33AA33}� ������� #%d: {FFFFFF}%s\n", lstring, i, AS_Mission[i - 1][AS_Name]);
						count++;
					}
					else
					{
					    format(lstring, sizeof(lstring), "%s{FF6347}� ������� #%d: {FFFFFF}%s\n", lstring, i, AS_Mission[i - 1][AS_Name]);
					}
				}
			    if(!PlayerInfo[playerid][pCarLic] && count > 1)	strcat(lstring, "{33AA33}> �������� �����");
                MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "���������", lstring, "�������", "�������");
			}
		}
		case DMODE_SHOOTING:
		{
			if(PlayerInfo[playerid][pGunLic] == 0)
			{
				if(PlayerInfo[playerid][pShooting] == 0)
				{
					lstring = "{FFFFFF}������������, ������ �������� �������� �� ������?\n\n\
								�����, ������ ��� ����� �������������� � ������� ����� ��������.\n\
								��� ����� ��� ����� ������ ��������� ������� � ����� ����,\n\
								���� ��� �������� ��� ������� - �� ������� ��� �������� �� ������!\n\n\
								��������� ����������� ����:\t\t"MAIN_COLOR"700${FFFFFF}\n\
								�������:\t\t\t\t\t"MAIN_COLOR"������������{FFFFFF}\n\n\
								���� �� ������ �������� � ���������� � ���������� - ������� '"MAIN_COLOR"��������{FFFFFF}'.";
					MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "���", lstring, "��������", "�������");
				}
				else if(PlayerInfo[playerid][pShooting] == 4)
				{
					return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��� ������ ��� �������.");
				}
				else
				{
					format(lstring, sizeof lstring, ""MAIN_COLOR"� {FFFFFF}���������� � ����������� ����\n\
													"MAIN_COLOR"� {FFFFFF}������ ���������� �������\n\
													{33AA33}< ����� �����������? [%d coins] >", CoinForShooting);
	                MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "���", lstring, "������", "�������");
				}
			}
		    else
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ���� �������� �� ������.");
				gPickupTime[playerid] = 5;
			}
		}
		case DMODE_SHOOTING_INFO:
		{
		 	lstring = "{88AA88}� ����� ������ 3 �����:{FFFFFF}\n\
				    	\t"MAIN_COLOR"� {FFFFFF} �������� �� ����������� ������� �� �������,\n\
						\t������� � ������� ���������. (Glock 9mm; 30 ��������; 30 ���.)\n\
						\t"MAIN_COLOR"� {FFFFFF} �������� �� ���������� �� ��� �������. (Glock 9mm; 35 ��������; 45 ���.)\n\
						\t"MAIN_COLOR"� {FFFFFF} �������� �� ���������� ���������� ��� �������. (Glock 9mm; 40 ��������; 60 ���.)\n\n\
						* ��� ������� - ��� ����� ���������� �������.";
        	MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "���: ����������", lstring, "�����", "");
		}
		case DMODE_BUYELEMENT:
		{
		    format(lstring, sizeof(lstring),
		    	"{FFFFFF}�� ������������� ������ ��������� ��� �������� ���������?\n\
		    	��� ������������� ������� 'skip' ��� '����������'\n\
		    	\n{33AA33}��������� ������: {FFFFFF}40 �����");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "��������������", lstring, "������", "�����");
		}
		case DMODE_REACTION:
		{
			new targetid = gTargetid[playerid];
		    if(PM_Type[playerid] == 10 && PM_Place[playerid] == targetid)
		    {
		    	if(PursuitStatus[targetid] == PS_WAIT || PursuitStatus[targetid] == PS_OUT_COMPLETE)
		    	{
		    		if(PlayerInfo[targetid][pNextFriskTime] > gettime())	strcat(lstring, "{AFAFAF}� ��������\t{AFAFAF}[����������]\n");
		    		else 													strcat(lstring, "{B1C8FB}� ��������\t{B1C8FB}[/frisk]\n");
		    		if(PursuitIllegalItem[targetid])			strcat(lstring, "{B1C8FB}� ������ ����. ��������\n");
		    		else 										strcat(lstring, "{AFAFAF}� ������ ����. ��������\t{AFAFAF}[����������]\n");
			    	if(0 < GetPlayerWantedLevel(targetid) < 4)	strcat(lstring, "{CFB53B}� �������� �����");
					else 										strcat(lstring, "{CFB53B}� ��������� ��������");
		    	}
		    	else
		    	{
		    		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������������� � ������� � ������ ������ ����������.");
		    	}
		    	SetPVarInt(playerid, "Player:Reaction:PursuitMenu", 1);

		    	new _wlstr[24];
		    	new wl = GetPlayerWantedLevel(gTargetid[playerid]);
		    	if(wl == 0)	format(_wlstr, sizeof(_wlstr), "{33AA33}[��� �������]");
		    	else 		format(_wlstr, sizeof(_wlstr), "{FF6347}[������: %d]", wl);
		    	format(string, sizeof(string), "%s %s", ReturnPlayerName(gTargetid[playerid]), _wlstr);
		    }
		    else
		    {
			    lstring = 	""MAIN_COLOR"� {FFFFFF}�������������\t[/hi]\n\
			    			"MAIN_COLOR"� {FFFFFF}�������� ���������\t[/showpass]\n\
			    			"MAIN_COLOR"� {FFFFFF}�������� ��������\t[/pay]";
			    
			    //	###	�������� ��� �����������
				if(PlayerInfo[playerid][pFaction] == F_POLICE)
				{
					if(IsPoliceDuty(playerid))
			    	{
			    		if(GetPlayerState(targetid) != PLAYER_STATE_WASTED)
						{
							if(PM_Type[playerid] == 0
							&& PursuitStatus[targetid] == PS_NONE
							&& !IsForce(PlayerInfo[targetid][pFaction])
							&& InGangZone[targetid] < 0
							&& !IsPlayerAFK(targetid)
							&& (GetPlayerWantedLevel(targetid) > 0 || PursuitLastUNIX[targetid] < gettime()))
							{
								strcat(lstring, "\n"MAIN_COLOR"� {B1C8FB}������ ��������\t{B1C8FB}[ ~ ]");
							}
							else
							{
								strcat(lstring, "\n"MAIN_COLOR"� {AFAFAF}������ ��������\t{AFAFAF}[����������]");
							}
						}
					}
				}
				else if(PlayerInfo[playerid][pFaction] == F_NEWS && PlayerInfo[playerid][pRank] >= 3)
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					if(GetPlayerInterior(playerid) == 18 || (vehicleid > 0 && CarInfo[vehicleid][cType] == C_TYPE_FACTION && CarInfo[vehicleid][cOwnerID] == F_NEWS))
					{
						if(TalkingLive[playerid] != INVALID_PLAYER_ID && TalkingLive[playerid] == targetid)
						{
							strcat(lstring, "\n"MAIN_COLOR"� {B1C8FB}��������� ��������\t{B1C8FB}[/live]");
						}
						else if(TalkingLive[playerid] == INVALID_PLAYER_ID && TalkingLive[targetid] == INVALID_PLAYER_ID)
						{
							strcat(lstring, "\n"MAIN_COLOR"� {B1C8FB}����� ��������\t{B1C8FB}[/live]");
						}
					}
				}

				#if defined	_job_part_delivery_included
					if(GetPVarInt(gTargetid[playerid], "Player:JobPartner") == PlayerInfo[playerid][pUserID])
					{
						strcat(lstring, "\n"MAIN_COLOR"� {FF6347}��������� ������\t{FF6347}[ ~ ]");
					}
					else
					{
						new rentcar = GetPVarInt(playerid, "RentCar");
						if(rentcar > 0 && DeliveryVehLoadCount[rentcar] > 0)
						{
							strcat(lstring, "\n"MAIN_COLOR"� {B1C8FB}���������� ����������\t{B1C8FB}[ ~ ]");
						}
					}
				#endif	

				if(GetNearRing(playerid) != (-1)
					&& !IsPlayerBoxing(gTargetid[playerid]))
					strcat(lstring, "\n"MAIN_COLOR"� {CFB53B}������� �� ��������\t{CFB53B}[/box]");

				//	###	�������� ��� ������ � ����
				if(PlayerInfo[playerid][pFaction] > 0
					&& PlayerInfo[playerid][pRank] >= GetRankMax(PlayerInfo[playerid][pFaction]) - 1)
				{	
				    if(PlayerInfo[ gTargetid[playerid] ][pFaction] == F_NONE)
				    {
						strcat(lstring, "\n"MAIN_COLOR"� {CFB53B}������� � �����������\t{CFB53B}[/invite]");
				    }
					if(PlayerInfo[playerid][pFaction] == PlayerInfo[ gTargetid[playerid] ][pFaction] && PlayerInfo[playerid][pRank] > PlayerInfo[ gTargetid[playerid] ][pRank])
					{
						strcat(lstring, "\n"MAIN_COLOR"� {CFB53B}������� �� �����������\t{CFB53B}[/uninvite]");
						strcat(lstring, "\n"MAIN_COLOR"� {CFB53B}�������� ����\t{CFB53B}[/giverank]");
					}
				}

				format(string, sizeof(string), "%s: ��������", ReturnPlayerName(gTargetid[playerid]));
			}
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST, string, lstring, "�������", "�������");
		}
		case DMODE_PAY_SUMM:
		{
		    MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "�������� �����", "������� ���-�� �����, ������� ������ ��������:", "��������", "�����");
		}
		case DMODE_BONUS_LIST:
		{
			new Cache:result = mysql_query(g_SQL, "SELECT `code`, `type`, `value` FROM `bonuses`");
			if(!cache_num_rows())
			{
			    MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "������ �������", "�� ������ ����� ���� �� �������!", "�������", "", 0);
			}
			else
			{
			    new code[MAX_CODE_SIZE], type, value;
			    for(new r = 0; r < cache_num_rows(); r++)
			    {
			        cache_get_value_index(r, 0, code);
					cache_get_value_index_int(r, 1, type);
					cache_get_value_index_int(r, 2, value);
			        if(type == 0) 		string = "������";
					else if(type == 1) 	string = "������";
					else if(type == 2) 	string = "����";
			        format(lstring, sizeof(lstring), "%s[{33AA33}%s{FFFFFF}]\t����: %s (���-��: %d)\n", lstring, code, string, value);
				}
				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "������ �������", lstring, "�������", "", 0);
			}
			cache_delete(result);
		}
		case DMODE_HOTEL:
		{
		    if(PlayerInfo[playerid][pRent] < 0)
		    {
		    	format(lstring, sizeof(lstring),
		    		"{FFFFFF}��������: "MAIN_COLOR"%d ����\n\
		    		{FFFFFF}____________________\n\
		    		"MAIN_COLOR"� {FFFFFF}������� �����\t[$15]\n\
		    		"MAIN_COLOR"� {FFFFFF}����������", PlayerInfo[playerid][pPaymentDays]);
                MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "�����", lstring, "�������", "�������");
		    }
			else
			{
				if(PlayerInfo[playerid][pRent])	lstring = "{FF6347}�� ��� ���-�� ��������� �����\n\n";
				format(lstring, sizeof(lstring), "%s{FFFFFF}������������, ������ ����� ����� �� "MAIN_COLOR"%d$/����{FFFFFF}?\n������� ���������� ���� ��� ������:", lstring, HOTEL_COST);
				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "�����", lstring, "�����", "�������");
			}
		}
		case DMODE_EX_HOTEL:
		{
			if(PlayerInfo[playerid][pRent] < 0)
			{
				format(lstring, sizeof(lstring), "{FFFFFF}������ �������� ������ ������?\n����������, ��� ��������� ������ "MAIN_COLOR"%d$/����{FFFFFF}\n\n������� ���������� ���� ��� ������:", HOTEL_COST);
				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "�����", lstring, "��������", "�����");
			}
		}
		case DMODE_ATM:
		{
			openWithATM[playerid] = true;
			lstring = ""MAIN_COLOR"� {FFFFFF}���������� ����\n";
			if(PlayerInfo[playerid][pPhoneNumber])	strcat(lstring, ""MAIN_COLOR"� {FFFFFF}������ ��������� �����\n");
			MyApplyAnimation(playerid, "ped", "ATM", 4.1, 1, 1, 1, 0, 0);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "��������", lstring, "�������", "�������");
		}
		case DMODE_BANK:
		{
			lstring = ""MAIN_COLOR"� {FFFFFF}���������� ����\t\n";
			new b = FoundBiz(GetPlayerBiz(playerid));
			if(b != (-1))
			{
				if(BizInfo[b][bPaymentDays] >= 0)	format(string, sizeof(string), ""MAIN_COLOR"��������: {FFFFFF}%d ����", BizInfo[b][bPaymentDays]);
				else 								format(string, sizeof(string), "{FF6347}�����������: {FFFFFF}%d ���", (BizInfo[b][bPaymentDays] * -1));
				format(lstring, sizeof(lstring),
					"%s"MAIN_COLOR"� {FFFFFF}���������� ���� �������\t\n\
					"MAIN_COLOR"� {FFFFFF}������ �������\t[%s]\n", lstring, string);
			}
			new h = FoundHouse(GetPlayerHouse(playerid));
			if(h != (-1))
			{
				if(HouseInfo[h][hPaymentDays] >= 0)	format(string, sizeof(string), ""MAIN_COLOR"��������: {FFFFFF}%d ����", HouseInfo[h][hPaymentDays]);
				else 								format(string, sizeof(string), "{FF6347}�����������: {FFFFFF}%d ���", (HouseInfo[h][hPaymentDays] * -1));
				format(lstring, sizeof(lstring),
					"%s"MAIN_COLOR"� {FFFFFF}������ ����\t[%s]\n", lstring, string);
			}
			if(PlayerInfo[playerid][pPhoneNumber])	strcat(lstring, ""MAIN_COLOR"� {FFFFFF}������ ��������� �����\t\n");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST, "����", lstring, "�������", "�������");
		}
	    case DMODE_BANK_ACTION:
		{
			new type = GetPVarInt(playerid, "Bank:Type");
			if(type == 0)	//	������ ����
			{
				if(PlayerInfo[playerid][pBank] > 0)	format(string, sizeof(string), "�� �����: {33AA33}$%.2f\n", PlayerInfo[playerid][pBank]);
				else								format(string, sizeof(string), "�� �����: {FF6347}$%.2f\n", PlayerInfo[playerid][pBank]);
			}
			else if(type == 1)	//	���� �������
			{
				new b = FoundBiz(GetPlayerBiz(playerid));
				if(b == (-1))	return ShowDialog(playerid, DMODE_ATM);
				if(BizInfo[b][bBank] > 0.0)	format(string, sizeof(string), "�� �����: {33AA33}$%.2f\n", BizInfo[b][bBank]);
				else						format(string, sizeof(string), "�� �����: {FF6347}$%.2f\n", BizInfo[b][bBank]);
			}
			strcat(lstring, string);
	        strcat(lstring, "____________________\n\
	        				"MAIN_COLOR"� {FFFFFF} ����� �� �����\n\
	        				"MAIN_COLOR"� {FFFFFF} �������� �� ����\n");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "���������� ����", lstring, "�������", "�����");
	    }
		case DMODE_BANK_TAKE:
		{
			new type = GetPVarInt(playerid, "Bank:Type");
			if(type == 0)	//	������ ����
			{
				format(lstring, 128, "�� �����: $%.2f\n\n������� �������� ����� � ������: (�������� 1%%)", PlayerInfo[playerid][pBank]);
			}
			else if(type == 1)	//	���� �������
			{
				new b = FoundBiz(GetPlayerBiz(playerid));
				if(b == (-1))	return ShowDialog(playerid, DMODE_ATM);
				format(lstring, 128, "�� �����: $%.2f\n\n������� �������� ����� � ������: (�������� 1%%)", BizInfo[b][bBank]);
			}
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "����� �� �����", lstring, "������", "�����");
		}
		case DMODE_BANK_GIVE:
		{
			new type = GetPVarInt(playerid, "Bank:Type");
			if(type == 0)	//	������ ����
			{
				format(lstring, 128, "�� �����: $%.2f\n\n������� ����� ������ �������� � ������: (�������� 0%%)", PlayerInfo[playerid][pBank]);
			}
			else if(type == 1)	//	���� �������
			{
				new b = FoundBiz(GetPlayerBiz(playerid));
				if(b == (-1))	return ShowDialog(playerid, DMODE_ATM);
				format(lstring, 128, "�� �����: $%.2f\n\n������� ����� ������ �������� � ������: (�������� 0%%)", BizInfo[b][bBank]);
			}
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "�������� �� ����", lstring, "������", "�����");
		}
		case DMODE_PROPERTY_PAY:
		{
			new type = GetPVarInt(playerid, "Bank:Type");
			if(type == 1)	//	������
			{
				new b = FoundBiz(GetPlayerBiz(playerid));
				if(b == (-1))	return ShowDialog(playerid, DMODE_BANK);

				if(BizInfo[b][bPaymentDays] >= 0)	format(string, sizeof(string), ""MAIN_COLOR"%d ��������� ����", BizInfo[b][bPaymentDays]);
				else 								format(string, sizeof(string), "{FF6347}����������� %d ���", BizInfo[b][bPaymentDays]);

				format(lstring, sizeof(lstring), "{FFFFFF}������������, �� ������ �������� ���� ������?\n\n\
				�������, �� ������ ������ � ��� %s{FFFFFF}.\n\
				�������� ��������� ������ ��� ��� ���������� "MAIN_COLOR"$%d{FFFFFF}.\n\n", string, TAX_BIZ);
			}
			else if(type == 2)	//	���
			{
				new h = FoundHouse(GetPlayerHouse(playerid));
				if(h == (-1))	return ShowDialog(playerid, DMODE_BANK);

				if(HouseInfo[h][hPaymentDays] >= 0)	format(string, sizeof(string), ""MAIN_COLOR"%d ��������� ����", HouseInfo[h][hPaymentDays]);
				else 								format(string, sizeof(string), "{FF6347}����������� %d ���", HouseInfo[h][hPaymentDays]);

				format(lstring, sizeof(lstring), "{FFFFFF}������������, �� ������ �������� ���� ���?\n\n\
				�������, �� ������ ������ � ��� %s{FFFFFF}.\n\
				�������� ��������� ������ ���������� "MAIN_COLOR"$%d{FFFFFF}.\n\n", string, TAX_HOUSE);
			}
			strcat(lstring, ""MAIN_COLOR"������� ���������� ���� ��� ������:");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "������ ���������", lstring, "������", "�����");
		}
		case DMODE_FINEPARK:
		{
			mysql_format(g_SQL, string, sizeof(string), "SELECT `model` FROM `cars` WHERE `type` = 1 AND `fine_park` > 0 AND `ownerid` = '%d'", PlayerInfo[playerid][pUserID]);
			new Cache:result = mysql_query(g_SQL, string);
			new veh_num = cache_num_rows();
			if(veh_num == 0)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ����� ������� ��� �� ����� ����� ������.");
			    cache_delete(result);
			    return 1;
			}
			new model;
			cache_get_value_index_int(0, 0, model);
			cache_delete(result);
		    lstring = "{2641FE}�� ����� ������� ������� ���� �������������\n";
		    if(veh_num > 1) format(lstring, sizeof(lstring), "%s{2641FE}����� �������: {FFFFFF}%d{2641FE}, ��� ������ ��������:\n", lstring, veh_num);
			format(lstring, sizeof(lstring), "%s\n{2641FE}������: {FFFFFF}%s[%d]\n{2641FE}����� ������: {FFFFFF}$500", lstring, VehParams[model-400][VEH_NAME], model);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "����������� �������: �����-�������", lstring, "��������", "�������");
		}
		//---
		case DMODE_GPS:
		{
			if(IsPlayerActiveGPS(playerid))	strcat(lstring, ""MAIN_COLOR"� {FF6347}��������� GPS\n");

			strcat(lstring, ""MAIN_COLOR"� {FFFFFF}������ �����\n\
				"MAIN_COLOR"� {FFFFFF}����������\n\
				"MAIN_COLOR"� {FFFFFF}��������� ������\n\
				"MAIN_COLOR"� {FFFFFF}����������� ������\n\
				"MAIN_COLOR"� {FFFFFF}���������\n\
				"MAIN_COLOR"� {FFFFFF}�������� � �������\n\
				"MAIN_COLOR"� {FFFFFF}�����������");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "���������", lstring, "�������", (openWithMenu[playerid] ? ("�����") : ("�������")), 0);
		}
		case DMODE_GPS_VEH:
		{
			strcat(lstring, ""MAIN_COLOR"� {FFFFFF}���������\n\
							"MAIN_COLOR"� {FFFFFF}������ ����\n\
							"MAIN_COLOR"� {FFFFFF}��������������\n\
							"MAIN_COLOR"� {FFFFFF}��������\n\
							"MAIN_COLOR"� {FFFFFF}��������� ����");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "��������� - ���������", lstring, "�������", "�����", 0);
		}
		case DMODE_GPS_SHOPS:
		{
			for(new i = 0; i < sizeof(BizTypeData); i++)
			{
				if(BizTypeData[i][btGPSType] == 0)
				{
					format(lstring, sizeof(lstring), "%s"MAIN_COLOR"� {FFFFFF}%s\n", lstring, BizTypeData[i][btName]);
				}
			}
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "��������� - �������� � �������", lstring, "�������", "�����", 0);
		}
		case DMODE_GPS_REST:
		{
			for(new i = 0; i < sizeof(BizTypeData); i++)
			{
				if(BizTypeData[i][btGPSType] == 1)
				{
					format(lstring, sizeof(lstring), "%s"MAIN_COLOR"� {FFFFFF}%s\n", lstring, BizTypeData[i][btName]);
				}
			}
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "��������� - �����������", lstring, "�������", "�����", 0);
		}
		//---
		case DMODE_GUNDEL:
		{
			if(!weaponid_new[playerid]) return 1;
		    new curgun, ammo, weaponid = weaponid_new[playerid];
		    GetPlayerWeaponData(playerid, GunParams[weaponid][GUN_SLOT], curgun, ammo);
		    if(!curgun || curgun == weaponid) return 1;
		    format(lstring, sizeof(lstring),
		        "{FFFFFF}������� ������ "MAIN_COLOR"%s{FFFFFF} ������� "MAIN_COLOR"%s{FFFFFF}\n\
		        ��� ������������� ������ ������� '"MAIN_COLOR"��{FFFFFF}' ��� '"MAIN_COLOR"yes{FFFFFF}':\n",
		        	GunParams[weaponid][GUN_NAME], GunParams[curgun][GUN_NAME]);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "��������������", lstring, "������", "�����");
		}
		case DMODE_ADLIST:
		{
			lstring = "�\t�����������\t�����\t������\n";
			new data[3][24] = { "{FF6347}�� ���������", "{CFB53B}�����������", "{9ACD32}���������" };
			for(new i = 0; i < MAX_ADVERT_COUNT; i++)
			{
				if(gAdvert[i][adBusy])
				{
					format(lstring, sizeof(lstring), "%s%d\t%s\t%s\t%s\n", lstring, i + 1, gAdvert[i][adSender], gAdvert[i][adText], data[ gAdvert[i][adStatus] ]);
				}
			}
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST_HEADERS, "������ ����������", lstring, "�������", "�������");
		}
		case DMODE_ADMENU:
		{
			new num = GetPVarInt(playerid, "EditAdID") - 1;
			if(gAdvert[num][adBusy] == false || gAdvert[num][adStatus] == 2)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ���������� � ������� ��� ���.");
				return ShowDialog(playerid, DMODE_ADLIST);
			}
			new stmp[64];
			format(lstring, sizeof(lstring), "%s\n1. ���������\n2. �������������\n3. ��������� �������������\n4. �������", gAdvert[num][adText]);
			format(stmp, sizeof(stmp), "���������� [�����������: %s]", gAdvert[num][adSender]);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, stmp, lstring, "�������", "�����");
		}
		case DMODE_ADEDIT:
		{
			new num = GetPVarInt(playerid, "EditAdID") - 1;
			if(gAdvert[num][adBusy] == false || gAdvert[num][adStatus] == 2)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ���������� � ������� ��� ���.");
				return ShowDialog(playerid, DMODE_ADLIST);
			}
			new stmp[128];
			format(stmp, sizeof(stmp), "���������� - �������������� [�����������: %s]", gAdvert[num][adSender]);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, stmp, gAdvert[num][adText], "����", "�����");
		}
		case DMODE_GIVERANK:
		{
		    if(0 < PlayerInfo[playerid][pFaction] < sizeof(Faction))
		    {
		        new faction = PlayerInfo[playerid][pFaction];
		        new targetid = GetPVarInt(playerid, "giverank_targetid");
		        for(new i; i < PlayerInfo[playerid][pRank]-1; i++)
		        {
		            if(strlen(FactionRank[faction][i+1]) <= 0) break;
		            if(PlayerInfo[targetid][pRank] == i+1) strcat(lstring, "{33AA33}");
		            format(lstring, sizeof(lstring), "%s{FFFFFF}[%d] %s\n", lstring, i+1, FactionRank[faction][i]);
		        }
				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "�������� ����", lstring, "��������", "�������");
		    }
		}
		case DMODE_RENTCAR:
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			format(lstring, sizeof(lstring), "\n{FFFFFF}�� ������ ���������� ���������� �� {44B2FF}$%d/���{FFFFFF}?\n\t", VehInfo[vehicleid][vRentPrice]);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "{44B2FF}������ ����������", lstring, "��", "���");
		}
		case DMODE_EXTEND_RENTCAR:
		{
			new vehicleid = GetPVarInt(playerid, "RentCar");
			format(lstring, sizeof(lstring), "\n{FFFFFF}������ ���������� ������� � �����\n�� ������ �������� ������ �� {44B2FF}$%d/���{FFFFFF}?\n\t", VehInfo[vehicleid][vRentPrice]);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "{44B2FF}������ ����������", lstring, "��", "���");
		}
		case DMODE_DRUGSTORE:
		{// FFFF00
		    format(lstring, sizeof(lstring), "{FFFFFF}�� ������: {FFFF00}%d �.\n{FFFFFF}���� �� �����: {FFFF00}%d$\n\n{FFFFFF}������� ����� ���������� �� ������ ������?", DrugStore, PRICE_DRUG);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "{F5DEB3}�����������", lstring, "������", "������");
		}
		case DMODE_MAKELEADER:
		{
		    new color[12] = ""; lstring = "";
			for(new i = 1; i < sizeof(Faction); i++)
			{
			    if(IsGang(i)) color = GetGangColorRGB(i); else color = "FFFFFF";
			    format(lstring, sizeof(lstring), "%s{FFCD00}[%d] {%s}%s\n", lstring, i, color, Faction[i][F_NAME]);
			}
			format(string, 128, "{FFCD00}������� ��� {FFFFFF}%s", ReturnPlayerName(MakeleaderPlayerid[playerid]));
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, string, lstring, "������", "������");
		}
		case DMODE_CHOOSEGANG:
		{
		    new color[12] = ""; lstring = "";
			for(new i = 0; i < sizeof(Faction); i++)
			{

			    if(IsGang(i))	color = GetGangColorRGB(i);
				else if(i == 0) color = "FFFFFF";
				else 			continue;
			    format(lstring, sizeof(lstring), "%s{FFCD00}[%d] {%s}%s\n", lstring, i, color, Faction[i][F_NAME]);
			}
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "{FFCD00}������ ����", lstring, "��������", "������");
		}
		case DMODE_HOSPITAL:
		{
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST_HEADERS, "���������",
				"������\t���������\n\
				{FFFFFF}������ ���� ������������\t"MAIN_COLOR"$100\n\
				{FFFFFF}������ ����\t"MAIN_COLOR"$50", "�������", "�������");
		}
		case DMODE_BOXINFO:
		{
			strcat(lstring, "\t\t\t\t{CFB53B}���������� ��������\n\n\
			{8D8DFF}�� ������ ����� ��������� ���������� ��������.\n\
			��� ����� ����������� ���� �������������� {CFB53B}(����������� + y){8D8DFF} ��� ������� {CFB53B}/box{8D8DFF}.\n\
			���� ����� ������ ���� �����������, � ��� ����� {CFB53B}3 ������ �� ���{8D8DFF}.\n\n\
			��� ������������� ����:\n\
			\t{CFB53B}- � ������ �� ������� ������ 15hp.\n\
			\t- ���� �� ������� ������� ����.\n");
			strcat(lstring, "\t- ����������� ����� (�����).\n\n\
			{8D8DFF}� ������ {CFB53B}������{8D8DFF} ���� ���� ��������� �� {CFB53B}1 �������{8D8DFF}.\n\
			� ������ {CFB53B}���������{8D8DFF} �� {CFB53B}0.5 ������{8D8DFF}.");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "����������", lstring, "�������", "", 0);
		}
		case DMODE_FSTYLE:
		{
			for(new i = 1; i < sizeof(FightStyleNames); i++)
			{
				if((PlayerInfo[playerid][pLearnFStyle] >> (i - 1)) & 0x1)
				{
					format(lstring, sizeof(lstring), "%s"MAIN_COLOR"� {FFFFFF}%s\t" SCOLOR_GREEN "������\n", lstring, FightStyleNames[i]);
				}
				else
				{
					format(lstring, sizeof(lstring), "%s"MAIN_COLOR"� {FFFFFF}%s\t" SCOLOR_LIGHTRED "������� [-1 upgrade]\n", lstring, FightStyleNames[i]);
				}
			}
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST, "�������� ����� ���", lstring, "�������", "�������");
		}
		//---	admin
		case DADMIN_TICKETS:
		{
			lstring = "�\t�����������\t�����\t������\n";
			new const status[2][24] = { "{FF6347}�� ����������", "{CFB53B}���������������" };
			for(new i = 0; i < MAX_ADVERT_COUNT; i++)
			{
				if(gAsk[i][askBusy])
				{
					format(lstring, sizeof(lstring), "%s%d\t%s\t%s\t%s\n", lstring, i + 1, ReturnPlayerName(gAsk[i][askSender]), gAsk[i][askText], status[ gAsk[i][askStatus] ]);
				}
			}
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST_HEADERS, "������", lstring, "�������", "�������");
		}
		case DADMIN_TICKET_MENU:
		{
			new num = GetPVarInt(playerid, "Admin:InTicket");
			if(!gAsk[num][askBusy])
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ������� � ������� ��� ��� ��� ��� ��� �������������.");
				return ShowDialog(playerid, DMODE_ADLIST);
			}
			gAsk[num][askStatus] = true;
			format(lstring, sizeof(lstring), "%s\n1. ��������\n2. �������", gAsk[num][askText]);
			format(string, sizeof(string), "����� [�����������: %s]", ReturnPlayerName(gAsk[num][askSender]));
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, string, lstring, "�������", "�����");
		}
		case DADMIN_TICKET_ANS:
		{
			new num = GetPVarInt(playerid, "Admin:InTicket");
			if(!gAsk[num][askBusy])
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ������� � ������� ��� ��� ��� ��� ��� �������������.");
				return ShowDialog(playerid, DMODE_ADLIST);
			}
			format(string, sizeof(string), "����� - ����� [�����������: %s]", ReturnPlayerName(gAsk[num][askSender]));
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, string, gAsk[num][askText], "��������", "�����");
		}
		//---   server
		case DSERV_MAIN:
		{
		    format(lstring, sizeof(lstring),
		        ""MAIN_COLOR"� {FFFFFF}���������� �������\n\
		         "MAIN_COLOR"� {FFFFFF}������ ���������������\n\
		         "MAIN_COLOR"� {FFFFFF}������ �������\n");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "���������� ��������", lstring, "�������", "�������");
		}
		case DSERV_STATS:
		{
			new uptimename[128], timer = SetTimer("EmptyFunc", 1000, false);
			new players, admins, afk, criminal, police, buses, jobs, noteam, levelsum;

			new tick = GetTickCount()/1000;
			new const days = tick / (24*60*60);
			tick -= days * 24 * 60 * 60;
			new const hours = tick / (60*60);
			tick -= hours * 60 * 60;
			new const minutes = tick / 60;
			tick -= minutes * 60;
			new const seconds = tick % 60;
			format(uptimename, 128, "����[%d] �����[%02d] �����[%02d] ������[%02d]", days, hours, minutes, seconds);

			foreach(LoginPlayer, i)
			{
			    players++;
				if(IsPlayerAFK(i))							afk++;
				if(GetPlayerAdmin(i))  						admins++;
				if(IsForce(PlayerInfo[i][pFaction]))		police++;
				else if(IsGang(PlayerInfo[i][pFaction]))	criminal++;
				else if(PlayerInfo[i][pFaction] > 0)		buses++;
				else if(Job.GetPlayerJob(i) > 0)			jobs++;
				else                                        noteam++;
				levelsum += PlayerInfo[i][pLevel];
			}

			format(lstring, sizeof(lstring),
			"{FFFFFF}��������������:\t{B1C8FB}%d/%d [%d%%]\n\
             {FFFFFF}���������������:\t{B1C8FB}%d [%d%%]\n\
             {FFFFFF}������ � AFK:\t\t{B1C8FB}%d [%d%%]\n\n",
							players, Iter_Count(Player), floatround(100 * players/Iter_Count(Player)),
							admins, floatround(100 * admins / players),
							afk, floatround(100 * afk / players));

			format(lstring, sizeof(lstring),
			"%s{FFFFFF}���.������:\t\t{B1C8FB}%d [%d%%]\n\
			 {FFFFFF}������������:\t{B1C8FB}%d [%d%%]\n\
			 {FFFFFF}�����������:\t\t{B1C8FB}%d [%d%%]\n\
			 {FFFFFF}��������:\t\t{B1C8FB}%d [%d%%]\n\
			 {FFFFFF}�����������:\t\t{B1C8FB}%d [%d%%]\n\n",
							lstring, police, floatround(100 * police / players),
							criminal, floatround(100 * criminal / players),
							buses, floatround(100 * buses / players),
							jobs, floatround(100 * jobs / players),
							noteam, floatround(100 * noteam / players));

			format(lstring, sizeof(lstring),
			"%s{FFFFFF}������ �������:\t{B1C8FB}%d\n\
			 {FFFFFF}������� �������:\t{B1C8FB}%.1f\n\
			 {FFFFFF}������ ��������:\t{B1C8FB}%.4f%%\n\
			 {B1C8FB}Uptime: %s",
							lstring, CurrentPlayerRecords,
							float(levelsum/players),
							100*float(timer)/2147483647,
							uptimename);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "���������� �������", lstring, "�������", "�����");
		}
		case DSERV_ADMINS:
		{
			string = "%d/%m/%Y"; // Date Format
			mysql_format(g_SQL, lstring, sizeof(lstring), "SELECT `username`, `online`, `admin`, FROM_UNIXTIME(`exitunix`, '%s') FROM `players` WHERE `admin` > 0 ORDER BY `admin` DESC, `online` DESC, `exitunix` DESC", string);
			new Cache:result = mysql_query(g_SQL, lstring);
			new row_count = cache_num_rows();
			if(row_count == 0)
			{
				cache_delete(result);
			    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������� �� ������ ��������������.");
			}
		    new name[32], date[20], online, admin;
	    	lstring = "������\t������\t��� ������\n";
		    for(new idx, r = 0; r < row_count; r++)
		    {
		        idx = 0;
				cache_get_value_index(r, idx++, name);
				cache_get_value_index_int(r, idx++, online);
				cache_get_value_index_int(r, idx++, admin);
				cache_get_value_index(r, idx++, date);
				if(online == -1)    format(lstring, sizeof(lstring), "%s{DFDFDF}%s\t{DFDFDF}%s\t{DFDFDF}%s\n", lstring, getAdminStatus(admin), date, name);
				else                format(lstring, sizeof(lstring), "%s{FFFFFF}%s\t{FFFFFF}%d\t{FFFFFF}%s\n", lstring, getAdminStatus(admin), online, name);
			}
			cache_delete(result);
			format(string, sizeof(string), "����������������� ������:");
			if(GetPlayerAdmin(playerid) >= ADMIN_GADMIN)    MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST_HEADERS, string, lstring, "�������", "�����");
			else											MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST_HEADERS, string, lstring, "�������", "�����");
		}
		case DSERV_ADMINS_ACTION:
		{
			new id = GetPVarInt(playerid, "DSERV:ADMINS:ID"); string = "%d/%m/%Y"; // Date Format
			mysql_format(g_SQL, lstring, sizeof(lstring), "SELECT `username`, `online`, `admin`, FROM_UNIXTIME(`exitunix`, '%s') FROM `players` WHERE id = %d", string, id);
			new Cache:result = mysql_query(g_SQL, lstring);
			if(cache_num_rows() == 0)
			{
				cache_delete(result);
				DeletePVar(playerid, "DSERV:ADMINS:ID");
			    return ShowDialog(playerid, DSERV_ADMINS);
			}
			new name[32], online, admin, date[20];
			cache_get_value_index(0, 0, name);
			cache_get_value_index_int(0, 1, online);
			cache_get_value_index_int(0, 2, admin);
			cache_get_value_index(0, 3, date);
			cache_delete(result);

			if(online == -1) format(lstring, sizeof(lstring), "\n"MAIN_COLOR"%s %s [%s]\n\n", getAdminStatus(admin), name, date);
			else             format(lstring, sizeof(lstring), "\n"MAIN_COLOR"%s %s (id: %d)\n\n", getAdminStatus(admin), name, online);
			strcat(lstring, "{FFFFFF}��� ������������ ����� ������ ������� '�������' ��� 'uninvite':");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "������������ ������", lstring, "������", "�����");
		}
		case DSERV_LEADERS:
		{
			new query[512]; string = "%d/%m/%Y"; // Date Format
			mysql_format(g_SQL, query, sizeof(query), "SELECT `username`, `online`, `faction`, FROM_UNIXTIME(`exitunix`, '%s'), FROM_UNIXTIME(`leader`, '%s') FROM `players` WHERE `leader` > 0 ORDER BY `faction` ASC, `online` DESC", string, string);
			new Cache:result = mysql_query(g_SQL, query);
			new row_count = cache_num_rows();
			if(row_count == 0)
			{
				cache_delete(result);
			    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������� �� ������ ������.");
			}
		    new name[32], online, faction, date[20], leader[20];
	    	lstring = "�������\t������\t��� ������\t����� �\n";
		    for(new idx, r = 0; r < row_count; r++)
		    {
		        idx = 0;
				cache_get_value_index(r, idx++, name);
				cache_get_value_index_int(r, idx++, online);
				cache_get_value_index_int(r, idx++, faction);
				cache_get_value_index(r, idx++, date);
				cache_get_value_index(r, idx++, leader);
				if(online == -1)    format(lstring, sizeof(lstring), "%s{DFDFDF}%s\t{DFDFDF}%s\t{DFDFDF}%s\t{DFDFDF}%s\n", lstring, GetFactionName(faction), date, name, leader);
				else                format(lstring, sizeof(lstring), "%s{FFFFFF}%s\t{FFFFFF}%d\t{FFFFFF}%s\t{FFFFFF}%s\n", lstring, GetFactionName(faction), online, name, leader);
			}
			cache_delete(result);
			format(string, sizeof(string), "��������� ������:");
			if(GetPlayerAdmin(playerid) >= ADMIN_GADMIN)    MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST_HEADERS, string, lstring, "�������", "�����");
			else											MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST_HEADERS, string, lstring, "�������", "�����");
		}
		case DSERV_LEADERS_ACTION:
		{
		}
		//---   faction
		case DFACT_MEMBERS:
		{
			new faction = PlayerInfo[playerid][pFaction];
			string = "%d/%m/%Y"; // Date Format
			mysql_format(g_SQL, lstring, sizeof(lstring), "SELECT `username`, `online`, `rank`, `p_number`, FROM_UNIXTIME(`exitunix`, '%s') FROM `players` WHERE `faction` = '%d' ORDER BY `rank` DESC, `online` DESC, `exitunix` DESC", string, PlayerInfo[playerid][pFaction]);
			new Cache:result = mysql_query(g_SQL, lstring);
			new row_count = cache_num_rows();
			if(row_count == 0)
			{
				cache_delete(result);
			    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ����� ����������� �� ������� �� ������ ������.");
			}
		    new name[32], date[20], online, rank, p_number;
			lstring = "����\t��� ������\t������\t�������\n";
		    for(new idx, r = 0; r < row_count; r++)
		    {
				idx = 0;
				cache_get_value_index(r, idx++, name);
				cache_get_value_index_int(r, idx++, online);
				cache_get_value_index_int(r, idx++, rank);
				cache_get_value_index_int(r, idx++, p_number);
				cache_get_value_index(r, idx++, date);
				if(rank < 1 || rank > FactionRankMax[faction]) continue;
				if(online == -1)	format(lstring, sizeof(lstring), "%s{DFDFDF}%s\t{DFDFDF}%s\t{DFDFDF}%s\t{DFDFDF}%d\n", lstring, FactionRank[faction][rank-1], name, date, p_number);
				else				format(lstring, sizeof(lstring), "%s{FFFFFF}%s\t{FFFFFF}%s\t{FFFFFF}%d\t{FFFFFF}%d\n", lstring, FactionRank[faction][rank-1], name, online, p_number);
			}
			cache_delete(result);
			format(string, sizeof(string), "%s: ������ �����������", GetFactionName(PlayerInfo[playerid][pFaction]));
			if(IsPlayerLeader(playerid))	MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST_HEADERS, string, lstring, "�������", "�������");
			else                            MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST_HEADERS, string, lstring, "�������", "");
		}
		case DFACT_MEMBERS_ACTION:
		{
			new id = GetPVarInt(playerid, "DFACT:MEMBERS:ID"); string = "%d/%m/%Y"; // Date Format
			mysql_format(g_SQL, lstring, sizeof(lstring), "SELECT `rank`, `username`, `online`, FROM_UNIXTIME(`exitunix`, '%s') FROM `players` WHERE P.id = %d", string, id);
			new Cache:result = mysql_query(g_SQL, lstring);
			if(cache_num_rows() == 0)
			{
				cache_delete(result);
				DeletePVar(playerid, "DFACT:MEMBERS:ID");
			    return ShowDialog(playerid, DFACT_MEMBERS);
			}
			new rank, name[32], online, date[20];
			new faction = PlayerInfo[playerid][pFaction];
			cache_get_value_index_int(0, 0, rank);
			cache_get_value_index(0, 1, name);
			cache_get_value_index_int(0, 2, online);
			cache_get_value_index(0, 3, date);
			cache_delete(result);
			
			if(online == -1) format(lstring, sizeof(lstring), "\n"MAIN_COLOR"%s %s [%s]\n\n", FactionRank[faction][rank-1], name, date);
			else             format(lstring, sizeof(lstring), "\n"MAIN_COLOR"%s %s (id: %d)\n\n", FactionRank[faction][rank-1], name, online);
			strcat(lstring, "{FFFFFF}��� ���������� ����� ������ ������� '�������' ��� 'uninvite':");

			format(string, sizeof(string), "%s: ����������", GetFactionName(PlayerInfo[playerid][pFaction]));
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, string, lstring, "������", "�����");
		}
		//---	mission
		case DMIS_TRAINING1:
		{
			format(string, sizeof(string), "%s: ������", ActorInfo[A_NEWBIE][a_Name]);
			format(lstring, sizeof(lstring), "{FFFFFF}������, � "MAIN_COLOR"%s{FFFFFF}.\n\
				������ �� �� �������?! ������, � ����� �� ������ ������ ���� �����.\n\
				� ����� ��� ������ ��������, �� ������ ���� � ������ �� ������,\n\
				����� ��� ����� ����� ����� � ��������, ���� ����� ��� ����.\n\
				��� ����� ������� �����, �� �� ���� �������� ��������� �������,\n\
				"MAIN_COLOR"��� ���������� ���� �������� - ������ �� ���� � ������ ��� ���� �����!{FFFFFF}\n\
				������, � ���� �����������!", ActorInfo[A_NEWBIE][a_Name]);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, string, lstring, "������", "");
		}
		case DMIS_TRAINING2:
		{
			format(string, sizeof(string), "%s: ������", ActorInfo[A_NEWBIE][a_Name]);
			lstring = "{FFFFFF}�������� �������, ��� ���� ��������� �������.\n\
				� ���� �� �������� ������, ���� ����� ����� ������ - ���������!";
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, string, lstring, "�������", "");
		}
		//---
		case DWAREHOUSE_MAIN:
		{
		    new const faction = GetPVarInt(playerid, "WH:faction");

		    // �������� �������
		    format(lstring, sizeof(lstring), ""MAIN_COLOR"� �������� �� �����\t\n\
						                      "MAIN_COLOR"� {FFFFFF}������\t[%d$]\n\
											  "MAIN_COLOR"� {FFFFFF}���������\t[%d �.]\n\
											  "MAIN_COLOR"� {FFFFFF}���������\t[%d ��.]",
											  Warehouse[faction][WH_MONEY],
											  Warehouse[faction][WH_DRUGS],
											  Warehouse[faction][WH_MATS]);// FF8300
			// ������
			new weaponid = 0;
			for(new s = 0; s < WH_GUN_MAX; s++)
			{
			    if(Warehouse[faction][WH_GUN][s] != 0)
			    {
				    weaponid = GetWarehouseWeaponid(s);
				    format(lstring, sizeof(lstring), "%s\n{FFFF66}� %s\t{FFFF66}[%d ���.]", lstring, ReturnWeaponName(weaponid), Warehouse[faction][WH_GUN][s]);
			    }
			}

		    // ����� �������
		    format(string, sizeof(string), "����� '%s'", GetFactionName(faction));
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST, string, lstring, "�������", "�������");
		}
		case DWAREHOUSE_TAKE:
		{
		    new const faction = GetPVarInt(playerid, "WH:faction");
		    switch(GetPVarInt(playerid, "WH:takeitem"))
		    {
		        case 1:// ������
		        {
		            format(lstring, sizeof(lstring), ""MAIN_COLOR"� {FFFFFF}������ [%d$]\n\n������� �������� ����������:", Warehouse[faction][WH_MONEY]);
		        }
		        case 2:// ���������
		        {
		            format(lstring, sizeof(lstring), ""MAIN_COLOR"� {FFFFFF}��������� [%d �.]\n\n������� �������� ����������:", Warehouse[faction][WH_DRUGS]);
		        }
		        case 3:// ���������
		        {
		            format(lstring, sizeof(lstring), ""MAIN_COLOR"� {FFFFFF}��������� [%d ��.]\n\n������� �������� ����������:", Warehouse[faction][WH_MATS]);
		        }
		        default:
				{
				    new bool:founded = false;
				    new const item = GetPVarInt(playerid, "WH:takeitem");
				    for(new idx, s = 0; s < WH_GUN_MAX; s++)
				    {
				        if(Warehouse[faction][WH_GUN][s] != 0 && idx++ == item - 4)
				        {
				            new weaponid = GetWarehouseWeaponid(s);
				            format(lstring, sizeof(lstring), ""MAIN_COLOR"� {FFFF66}%s [%d ���.]\n\n{FFFFFF}������� �������� ����������:", ReturnWeaponName(weaponid), Warehouse[faction][WH_GUN][s]);
							founded = true; break;
				        }
				    }
				    if(founded == false)
					{
					    Dialogid[playerid] = INVALID_DIALOGID;
						return ShowDialog(playerid, DWAREHOUSE_MAIN);
					}
				}
		    }
		    format(string, sizeof(string), "����� '%s'", GetFactionName(faction));
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, string, lstring, "������", "�����");
		}
		case DWAREHOUSE_INV:
		{
		    // �������� �������
		    format(lstring, sizeof(lstring), ""MAIN_COLOR"� ������\t[%d$]\n\
											  "MAIN_COLOR"� ���������\t[%d �.]\n\
											  "MAIN_COLOR"� ���������\t[%d ��.]",
											  MyGetPlayerMoney(playerid),
											  Inv.GetThing(playerid, THING_DRUGS),
											  Inv.GetThing(playerid, THING_GUN_MATS));
			// ������
			for(new slot = 2, weaponid, ammo; slot < 8; slot++)
			{   // ����� ������ � ��������� ������
				MyGetPlayerWeapon(playerid, slot, weaponid, ammo);
			    if(weaponid > 0 && ammo > 0)
			    {
			        if(GetWarehouseWeaponSlot(weaponid) != -1)
			        {   // ��������� ����� ������ �� ������ (-1 ���� �� ����� ������)
					    format(lstring, sizeof(lstring), "%s\n{FFFF66}� %s\t{FFFF66}[%d ���.]", lstring, ReturnWeaponName(weaponid), ammo);
					}
			    }
			}

		    // ����� �������
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST, "�������� �� �����", lstring, "�������", "�����");
		}
		case DWAREHOUSE_GIVE:
		{
		    switch(GetPVarInt(playerid, "WH:giveitem"))
		    {
		        case 0:// ������
		        {
		            format(lstring, sizeof(lstring), ""MAIN_COLOR"� ������ [%d$]\n\n������� �������� ����������:", MyGetPlayerMoney(playerid));
		        }
		        case 1:// ���������
		        {
		            format(lstring, sizeof(lstring), ""MAIN_COLOR"� ��������� [%d �.]\n\n������� �������� ����������:", Inv.GetThing(playerid, THING_DRUGS));
		        }
		        case 2:// ���������
		        {
		            format(lstring, sizeof(lstring), ""MAIN_COLOR"� ��������� [%d ��.]\n\n������� �������� ����������:", Inv.GetThing(playerid, THING_GUN_MATS));
		        }
		        default:
				{
					// ������
					new bool:founded = false;
				    new const item = GetPVarInt(playerid, "WH:giveitem");
					for(new idx, slot = 2, weaponid, ammo; slot < 8; slot++)
					{   // ����� ������ � ��������� ������
						MyGetPlayerWeapon(playerid, slot, weaponid, ammo);
					    if(weaponid > 0 && ammo > 0)
					    {
					        if(GetWarehouseWeaponSlot(weaponid) != -1 && idx++ == item - 3)
					        {   // ��������� ����� ������ �� ������ (-1 ���� �� ����� ������)
							    format(lstring, sizeof(lstring), "%s\n{FFFF66}� %s\t{FFFF66}[%d ���.]\n\n������� �������� ����������:", lstring, ReturnWeaponName(weaponid), ammo);
							    founded = true; break;
							}
					    }
					}
				    if(founded == false)
					{
					    Dialogid[playerid] = INVALID_DIALOGID;
						return ShowDialog(playerid, DWAREHOUSE_INV);
					}
				}
		    }
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "�������� �� �����", lstring, "������", "�����");
		}
		//	job
		case DJOB_GUNDEAL_MATS:
		{
			lstring = "{FFFFFF}������� ���-�� ������� ��� �������:\n\n\
			��������� �������: "MAIN_COLOR"$100";
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "������� �������", lstring, "������", "�������");
		}
		case DJOB_GUNDEAL_GUN:
		{
			lstring = "������\t������\t���������\n";
			for(new i = 0, w; i < sizeof(GunDealWeapons); i++)
			{
				w = GunDealWeapons[i];
				format(lstring, sizeof(lstring), "%s"MAIN_COLOR"� {FFFFFF}%s\t%d\t%d\n", lstring, GunParams[w][GUN_NAME], GunParams[w][GUN_AMMO], GunParams[w][GUN_MATS]);
			}
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST_HEADERS, "������������ ������", lstring, "����������", "�����");
		}
		case DJOB_DRUGDEAL_MATS:
		{
			lstring = "{FFFFFF}������� ���-�� ����� ��� �������:\n\n\
			��������� �������: "MAIN_COLOR"$100";
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "������� �����", lstring, "������", "�������");
		}
		case DJOB_MECHANIC:
		{
			if(Job.GetPlayerJob(playerid) != JOB_MECHANIC)
			{
				return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ��������� ���������.");
			}
			if(Job.GetPlayerNowWork(playerid) == JOB_MECHANIC)
			{
				string = "{FFFFFF}�� �������, ��� ������ ���������?\n\
				�� ����������� �������� ������ � �� ������� ������ ����������.";
			}
			else
			{
				string = "{FFFFFF}�� ������ ���������� � ������ ���������?\n\
				��� ����� ������ ������� ������ � ������ ��������� ������.";
			}
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "����� �� ���������", string, "��", "�������");
		}
	    //---
	    case DMENU_MAIN:
	    {
	    	openWithMenu[playerid] = false;
	    	//if(gMissionProgress[playerid][MIS_SOURCE_TRAINING] < 4)	strcat(lstring, ""MAIN_COLOR"� ��� ������\n");
	        strcat(lstring, ""MAIN_COLOR"� {FFFFFF}����������\n\
	        				"MAIN_COLOR"� {FFFFFF}��������\n");
	    #if defined _player_phone_included
	        if(PlayerInfo[playerid][pPhoneNumber])
	        {
	        	strcat(lstring, ""MAIN_COLOR"� {FFFFFF}�������\n");
	        }
	    #endif     
			strcat(lstring, ""MAIN_COLOR"� {FFFFFF}���������\n\
							"MAIN_COLOR"� {FFFFFF}������������\n\
							"MAIN_COLOR"� "MAIN_COLOR"���. ����������� �\n\
							"MAIN_COLOR"� {FFFFFF}������ ����� ���\n\
							"MAIN_COLOR"� {FFFFFF}����� � ��������������");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "������� ����", lstring, "�������", "�������");
	    }
	    case DMENU_TASKS:
	    {
			for(new i = 1; i < sizeof(StartMissionData); i++)
			{
				if(mission_id[playerid] == i)
				{
					format(lstring, sizeof(lstring), "%s"MAIN_COLOR"� {FFFFFF}%s\t{CFB53B}�����������\n", lstring, StartMissionData[i][m_Title]);
				}
				else if(gMissionProgress[playerid][MIS_SOURCE_TRAINING] >= i)
				{
					format(lstring, sizeof(lstring), "%s"MAIN_COLOR"� {FFFFFF}%s\t"MAIN_COLOR"���������\n", lstring, StartMissionData[i][m_Title]);
				}
				else if(gMissionProgress[playerid][MIS_SOURCE_TRAINING] < i)
				{
					format(lstring, sizeof(lstring), "%s"MAIN_COLOR"� {FFFFFF}%s\t{FF6347}�� ���������\n", lstring, StartMissionData[i][m_Title]);
				}
			}
	    	MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST, "������� ������", lstring, "�������", "�����");
	    }
	    case DMENU_LEVELING:
	    {
			strcat(lstring, ""MAIN_COLOR"� {FFFFFF}������\n\
							"MAIN_COLOR"� {FFFFFF}������ ������\n\
							"MAIN_COLOR"� {FFFFFF}���������");
			#if defined _player_achieve_included
				strcat(lstring, "\n"MAIN_COLOR"� {FFFFFF}����������");
			#endif
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "��������", lstring, "�������", (openWithMenu[playerid] ? ("�����") : ("�������")));
	    }
	    case DMENU_SKILL:
	    {
	    	new count = 0;
		    for(new i = 1; i <= sizeof(AS_Mission); i++)
			{
				if((PlayerInfo[playerid][pASElement] >> i) & 0x1)
				{
					count++;
				}
			}
	    	new proc = floatround(count / 0.07);
	    	new PREFIX[] = "{CFB53B}� ";

	    	format(lstring, sizeof(lstring),
	    		"������������\t�������\t��������\n\
	    		{CFB53B}� ����� �{FFFFFF}\n\
	    		{CFB53B}�{FFFFFF} ��������\t�\t%d%%\n\
	    		{CFB53B}�{FFFFFF} ����\t�\t%d%%\n\
	    		{CFB53B}� ��������������� ������ �{FFFFFF}\n",
					proc, floatround(PlayerInfo[playerid][pPower]));
	    	strcat(lstring, FormatSkill(PREFIX, "�������\t", PlayerInfo[playerid][pTaxiLevel], PlayerInfo[playerid][pTaxiSkill], GetTaxiSkill(playerid)));
	    	strcat(lstring, FormatSkill(PREFIX, "�������� ��������\t", PlayerInfo[playerid][pBusLevel], PlayerInfo[playerid][pBusSkill], GetBusSkill(playerid)));
	    	strcat(lstring, FormatSkill(PREFIX, "������������\t", PlayerInfo[playerid][pTruckLevel], PlayerInfo[playerid][pTruckSkill], GetTruckSkill(playerid)));
	    	MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST_HEADERS, "������", lstring, "�����", "");
	    }
	    case DMENU_WEAPON_SKILL:
	    {
	    	strcat(lstring, "������\t��������\n\
	    					{CFB53B}�{FFFFFF} Silenced Pistol\t�\t0%\n\
	    					{CFB53B}�{FFFFFF} Desert Eagle\t�\t0%\n\
	    					{CFB53B}�{FFFFFF} Shotgun\t�\t0%\n\
	    					{CFB53B}�{FFFFFF} Sawnoff Shotgun\t�\t0%\n\
	    					{CFB53B}�{FFFFFF} Combat Shotgun\t�\t0%\n\
	    					{CFB53B}�{FFFFFF} MP5\t�\t0%\n\
	    					{CFB53B}�{FFFFFF} AK47\t�\t0%\n\
	    					{CFB53B}�{FFFFFF} M4\t�\t0%\n\
	    					{CFB53B}�{FFFFFF} Sniper Rifle\t�\t0%");
	    	MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST_HEADERS, "������ ������", lstring, "�����", "");
	    }
	    case DMENU_ADVANCE:
	    {
	    	strcat(lstring, "������������\t�������\t���������\n\
	    					�������� ��� ������\t10hp\t+5hp\n\
	    					������ ���������\t30kg\t��������\n\
	    					�������������\t���");
	    	MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST_HEADERS, "���������", lstring, "������", "�����");
	    }
	    case DMENU_DONATE:
	    {
	        format(lstring, sizeof(lstring),
	            ""MAIN_COLOR"< � �� ����, ��� �������� ������. >\n\
	            "MAIN_COLOR"� {FFFFFF}������� ������� ��������\n\
	            "MAIN_COLOR"� {FFFFFF}������� ������ ��������\n\
	            "MAIN_COLOR"� {FFFFFF}������� ����� �����\n\
	            "MAIN_COLOR"� {FFFFFF}������� ����� � �������\n\
	            "MAIN_COLOR"� {FFFFFF}������� ����� � ���� ��������\n\
	            "MAIN_COLOR"� {FFFFFF}������� ����� � �����������������\n");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "���. �����������", lstring, "�������", (openWithMenu[playerid] ? ("�����") : ("�������")), 0);
	    }
	    case DMENU_HOWGETCOIN:
	    {
	        format(lstring, sizeof(lstring),
	            "{FFFFFF}�������� ������ � ������� ���� ��� �������� ����� ����� � ���� ������:\n\
				1. ������� �� ������: "MAIN_COLOR""DONATE_URL"{FFFFFF}\n\
				2. ������� ����� � ���������� �������� �����\n\
				\n{AFAFAF}������ ������ �������, ��� �� ������� '%s'\n\
				���� � ��� �������� ��������, �� ���������� � ������������� ����� ���� ��� ������� /ask",
				LongWords[random(sizeof(LongWords))]);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "��� �������� ������?", lstring, "�����", "", 0);
	    }
	    case DMENU_COINTOVIP:
	    {
	    	format(lstring, sizeof(lstring),
	            "{FFFFFF}������� �����: "MAIN_COLOR"%d\n\
	            {FFFFFF}��������� ��������� ��������: "MAIN_COLOR"%d �����\n", GetPlayerCoins(playerid), CoinForVIP);
	    	if(PlayerInfo[playerid][pVip])
	    	{
	    		mysql_format(g_SQL, string, sizeof(string), "SELECT FROM_UNIXTIME('%d')", PlayerInfo[playerid][pVipUNIX]);
				new Cache:result = mysql_query(g_SQL, string);
				cache_get_value_index(0, 0, string);
				cache_delete(result);
				format(lstring, sizeof(lstring), "%s{FFFFFF}������� ��: "MAIN_COLOR"%s\n\n\
					{AFAFAF}������� ���������� ������, �� ������� �� ������ �������� �������\n\
					����� �������� (4 ������) ����� ������ %d �����", lstring, string, 4 * CoinForVIP);
	    	}
	    	else
	    	{
	    		format(lstring, sizeof(lstring), "%s{AFAFAF}\n������� ���������� ������, �� ������� �� ������ ������ �������\n\
					����� �������� (4 ������) ����� ������ %d �����", lstring, 4 * CoinForVIP);
	    	}
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "������� ������� ��������", lstring, "���������", "�����", 0);
	    }
	    case DMENU_COINTOMONEY:
	    {
	        format(lstring, sizeof(lstring),
	            "{FFFFFF}������� �����: "MAIN_COLOR"%d\n\
	            {FFFFFF}������� ���� �� ������: "MAIN_COLOR"%d$\n\
	            {AFAFAF}\n������� ���������� �����, ������� �� ������ ��������� � �������\n\
				��������, ���� �� ������� 1000 (�����), �� �������� %d ��������", GetPlayerCoins(playerid), MoneyForCoin, 1000 * MoneyForCoin);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "������� ����� � �������", lstring, "���������", "�����", 0);
	    }
	    case DMENU_COINTOUPGRADE:
	    {
	        format(lstring, sizeof(lstring),
	            "{FFFFFF}������� �����: "MAIN_COLOR"%d\n\
	            {FFFFFF}������� ���� �� �������: "MAIN_COLOR"%d �����\n\
	            {AFAFAF}\n������� ���������� ���������, �� ������� �� ������ �������� ������\n\
		        ��������, ���� �� ������� 5 (���������), �� ��� ����� ������ %d �����", GetPlayerCoins(playerid), CoinForUpgrade, 5 * CoinForUpgrade);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "������� ����� � ���� ��������", lstring, "���������", "�����", 0);
	    }
	    case DMENU_COINTOLAW:
	    {
	        format(lstring, sizeof(lstring),
	            "{FFFFFF}������� �����: "MAIN_COLOR"%d\n\
	            {FFFFFF}������� ���� �� �����������������: "MAIN_COLOR"%d �����\n\
	            {FFFFFF}���� �����������������: "MAIN_COLOR"%d ��.\n\
	            {AFAFAF}\n������� ���������� �����������������, �� ������� �� ������ �������� ������\n\
		        ��������, ���� �� ������� 5 (�����������������), �� ��� ����� ������ %d �����", GetPlayerCoins(playerid), CoinForLaw, PlayerInfo[playerid][pLaw], 5 * CoinForLaw);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "������� ����� � ���� �����������������", lstring, "���������", "�����", 0);
	    }
	    case DMENU_SETTING:
	    {
	    	new curspawn[16];
	    	if(PlayerInfo[playerid][pSpawn] == SPAWN_HOUSE)			curspawn = SCOLOR_GREEN "���";
	    	else if(PlayerInfo[playerid][pSpawn] == SPAWN_FACTION)	curspawn = SCOLOR_GREEN "�������";
	    	else 													curspawn = SCOLOR_GREEN "�����";
	        format(lstring, sizeof(lstring),
				MAIN_COLOR "� {FFFFFF}��������� ����� ��� �����\t\n"\
				MAIN_COLOR "� {FFFFFF}������ ��������:\t%s%s\n"\
				MAIN_COLOR "� {FFFFFF}����� ���:\t"MAIN_COLOR"%s\n"\
				MAIN_COLOR "� {FFFFFF}�����������:\t%s\n"\
				MAIN_COLOR "� {FFFFFF}���������:\t%s\n"\
				MAIN_COLOR "� {FFFFFF}�������:\t%s\n"\
				MAIN_COLOR "� {FFFFFF}���� �������:\t%s\n"\
				MAIN_COLOR "� {FFFFFF}����� ���������:\t%s\n"\
				MAIN_COLOR "� {FFFFFF}������ �����:\t%s\n"\
				MAIN_COLOR "� {FFFFFF}���� �����:\t%s",
					PlayerInfo[playerid][pAnim]			? (SCOLOR_GREEN)				: (SCOLOR_LIGHTRED), PlayerAnims[ PlayerInfo[playerid][pAnim] ][PANIM_TITLE],
					FightStyleNames[ PlayerInfo[playerid][pFightStyle] ],
					PlayerInfo[playerid][pRusifik]		? (SCOLOR_GREEN "����������") 	: (SCOLOR_LIGHTRED "�� ����������"),
					PlayerInfo[playerid][pInterface] 	? (SCOLOR_GREEN "�������") 		: (SCOLOR_LIGHTRED "��������"),
					PlayerInfo[playerid][pCensored] 	? (SCOLOR_GREEN "��������") 	: (SCOLOR_LIGHTRED "���������"),
					pNameTags[playerid]				 	? (SCOLOR_GREEN "��������") 	: (SCOLOR_LIGHTRED "������"),
					curspawn,
					PlayerInfo[playerid][pHouseIcon]	? (SCOLOR_GREEN "������������")	: (SCOLOR_LIGHTRED "�� ������������"),
					PlayerInfo[playerid][pToggleZone]	? (SCOLOR_GREEN "������������")	: (SCOLOR_LIGHTRED "�� ������������"));
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST, "���������", lstring, "�������", "�����");
	    }
	    case DMENU_FSTYLE:
	    {
	    	for(new i = 0; i < sizeof(FightStyleNames); i++)
	    	{
	    		if(PlayerInfo[playerid][pFightStyle] == i)
	    		{
					format(lstring, sizeof(lstring), "%s" MAIN_COLOR "� {FFFFFF}%s\t" SCOLOR_GREEN "����������\n", lstring, FightStyleNames[i]);
	    		}
	    		else if(i == 0 || (PlayerInfo[playerid][pLearnFStyle] >> (i - 1)) & 0x1)
	    		{
	    			format(lstring, sizeof(lstring), "%s" MAIN_COLOR "� {FFFFFF}%s\t" SCOLOR_GREEN "������\n", lstring, FightStyleNames[i]);
	    		}
	    		else
	    		{
	    			format(lstring, sizeof(lstring), "%s" MAIN_COLOR "� {FFFFFF}%s\t" SCOLOR_LIGHTRED "�� ������\n", lstring, FightStyleNames[i]);
	    		}
	    	}
	    	MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST, "����� ���", lstring, "�������", "�����");
	    }
	    case DMENU_PROTECTION:
	    {
	    	format(lstring, sizeof(lstring),
				""MAIN_COLOR"� {FFFFFF}������� email �����\t\n\
				"MAIN_COLOR"� {FFFFFF}������� ���\t\n\
				"MAIN_COLOR"� {FFFFFF}������� ������\t");
	    	MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "������������", lstring, "�������", "�����");
	    }
	    case DMENU_CHANGE_ANIM:
	    {
	    	for(new i = 0; i < sizeof(PlayerAnims); i++)
	    	{
	    		format(lstring, sizeof(lstring), "%s\n"MAIN_COLOR"� {FFFFFF}%s", lstring, PlayerAnims[i][PANIM_TITLE]);
	    	}
	    	MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "��������� - ����� ������ ��������", lstring, "�������", "�����");
	    }
	    case DMENU_CHANGE_SPAWN:
	    {
	    	lstring = ""MAIN_COLOR"� {FFFFFF}���/�����\n\
	    				"MAIN_COLOR"� {FFFFFF}����� �������\n\
	    				"MAIN_COLOR"� {FFFFFF}����� �����";
	    	MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "��������� - ����� ���������", lstring, "�������", "�����");
	    }
	    case DMENU_CHANGE_PASS:
	    {
	    	if(GetPVarInt(playerid, "change_pass") == 0)	lstring = "{FFFFFF}������� ��� "MAIN_COLOR"�������{FFFFFF} ������:";
	    	else 											lstring = "{FFFFFF}������� "MAIN_COLOR"�����{FFFFFF} ������ ��� ��������:";
	    	MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "��������� - ����� ������", lstring, "����", "�����");
	    }
	    case DMENU_BONUS:
	    {
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "���� ����� ����", "{FFFFFF}������� ��� ������:", "������", "�����");
	    }
		case DMENU_CONTACT:
		{
			lstring = "{FFFFFF}����������� "MAIN_COLOR"/ask [���_������]{FFFFFF}, ����� ������ ������ �������������\n\
					   {FFFFFF}����������� "MAIN_COLOR"/report [playerid] [������]{FFFFFF}, ����� ��������� ������\n\n\
					   "MAIN_COLOR"���� ������� ��������� � ������ � ������� '���������':";
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "����� � ��������������", lstring, "���������", (openWithMenu[playerid] ? ("�����") : ("�������")));
		}
	    //---
	    case DBIZ_MAIN:
	    {
	    	new b = PickupedBiz[playerid];
	    	if(b != INVALID_DATA)
	    	{
	    		if(BizInfo[b][bLocation] == 0)		strcat(lstring, ""MAIN_COLOR"� {FFFFFF}������� ����\n");
				else
				{
					if(BizInfo[b][bEnterPrice] > 0)	
					{
						format(lstring, sizeof(lstring), ""MAIN_COLOR"� {FFFFFF}����� � ������\t[$%d]\n", BizInfo[b][bEnterPrice]);
					}
					else 							
					{
						if(BizInfo[b][bPrice] > MyGetPlayerMoney(playerid))
						{
							PickupedBiz[playerid] = INVALID_DATA;
							gPickupTime[playerid] = 5;
							return PlayerEnterBiz(playerid, b);
						}
						else
						{
							strcat(lstring, ""MAIN_COLOR"� {FFFFFF}����� � ������\n");
						}
					}
				}
				if(BizInfo[b][bOwnerID] == 0)
				{
					if(MyGetPlayerMoney(playerid) >= BizInfo[b][bPrice])
					{
						format(lstring, sizeof(lstring), "%s"MAIN_COLOR"� {FFFFFF}������ ������\t[$%d]\n", lstring, BizInfo[b][bPrice]);
					}
				}		
				else if(BizInfo[b][bOwnerID] == PlayerInfo[playerid][pUserID])	strcat(lstring, ""MAIN_COLOR"� {FFFFFF}����������");
				format(string, sizeof(string), "%s %s", BizTypeData[ BizInfo[b][bType] ][btName], BizInfo[b][bName]);
				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, string, lstring, "�������", "�����");
	    	}
	    }
	    case DBIZ_MANAGE:
	    {
	    	new b = GetBizWhichPlayer(playerid, 0);
	    	if(b != INVALID_DATA)
	    	{
	    		format(lstring, sizeof(lstring), ""MAIN_COLOR"� {FFFFFF}�������� ��������:\t%s\n\
		    	"MAIN_COLOR"� {FFFFFF}�������� �����\t[%d/%d]\n\
		    	"MAIN_COLOR"� {FFFFFF}���������\t[����������]\n", BizInfo[b][bName], BizInfo[b][bProduct], BizInfo[b][bMaxProds]);
		    	if(BizTypeData[ BizInfo[b][bType] ][btMaxEnterPrice] > 0)
		    	{
		    		format(lstring, sizeof(lstring), "%s"MAIN_COLOR"� {FFFFFF}���� �� ����\t["MAIN_COLOR"$%d{FFFFFF}]\n", lstring, BizInfo[b][bEnterPrice]);
		    	}
		    	strcat(lstring, ""MAIN_COLOR"� {FFFFFF}������� ������");
		    	MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST, "���������� ��������", lstring, "�������", "�����");
	    	}
	    }
	    case DBIZ_CHANGE_NAME:
	    {
	    	MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "����� ��������", "{FFFFFF}������� ����� �������� �������:", "����", "�����");
	    }
	    case DBIZ_ENTER_PRICE:
	    {
	    	new b = GetBizWhichPlayer(playerid, 0);
	    	if(b != INVALID_DATA)
	    	{
	    		format(string, sizeof(string), "{FFFFFF}������� ���������: "MAIN_COLOR"$%d\n\n\
	    		{FFFFFF}������� ����� ��������� ����� ($0-$%d):", BizInfo[b][bEnterPrice], BizTypeData[ BizInfo[b][bType] ][btMaxEnterPrice]);
	    		MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "��������� �����", string, "����", "�����");
	    	}
	    }
	    case DBIZ_SELL:
	    {
	    	new b = GetBizWhichPlayer(playerid, 0);
	    	if(b != INVALID_DATA)
	    	{
	    		new price = floatround(BizInfo[b][bPrice] * 0.8);
		    	format(lstring, sizeof(lstring), "{FFFFFF}�� ������� ��� ������ ������� ������?\n\n\
		    	{FFFFFF}��������� �������:\t"MAIN_COLOR"$%.2f\n\
		    	{FFFFFF}����� � �����:\t"MAIN_COLOR"$%.2f\n\
		    	{FFFFFF}�����:\t\t\t"MAIN_COLOR"$%.2f", float(price), BizInfo[b][bBank], float(price) + BizInfo[b][bBank]);
		    	MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "������� �������", lstring, "��", "���");
	    	}
	    }
	    //---
	    case DHOME_MAIN:
		{
	        new h = GetPlayerHouseID(playerid);
	        if(h < 0) return true;

	        new price, buff[24];
	        if(HouseInfo[h][hDonate] == 0) price = floatround(HouseInfo[h][hPrice] * 0.75);
	        else price = floatround(HouseInfo[h][hPrice] * MoneyForCoin * 0.75);
	        if(HouseInfo[h][hRentPrice] > 0)	format(string, sizeof(string), ""SCOLOR_GREEN"���������: $%d", HouseInfo[h][hRentPrice]);
	        else 								format(string, sizeof(string), "{FF6347}�������");
	        if(HouseInfo[h][hPaymentDays] >= 0)	buff = "��������";
			else 								buff = "�����������";
	        format(lstring, sizeof(lstring), ""MAIN_COLOR"� {FFFFFF}�����\t[%s{FFFFFF}]\n\
	        								"MAIN_COLOR"� {FFFFFF}%s\t[%s%d ����]\n\
	        								"MAIN_COLOR"� {FFFFFF}������\t["SCOLOR_GREEN"�����: %d/%d{FFFFFF}]\n\
											"MAIN_COLOR"� {FFFFFF}������\t[%s{FFFFFF}]\n\
											"MAIN_COLOR"� {FFFFFF}��������\t[%s{FFFFFF}]\n\
											"MAIN_COLOR"� {FFFFFF}������� ���\t["MAIN_COLOR"$%d{FFFFFF}]", HouseInfo[h][hLock] ? ("{FF6347}�������") : (""SCOLOR_GREEN"�������"),
																					buff, (HouseInfo[h][hPaymentDays] > 0) ? (""SCOLOR_GREEN"") : ("{FF6347}"), HouseInfo[h][hPaymentDays],
																					GetOccupiedFurSlots(h), GetHouseFurSlot(h),
																					string,
																					(PlayerInfo[playerid][pHousing] == HouseInfo[h][hID]) ? (""SCOLOR_GREEN"��������") : ("{FF6347}�� ��������"),
																					price);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST, "���", lstring, "�������", "�����");
	    }
	    case DHOME_ACC_REGISTER:
	    {
	        new h = GetPlayerHouseID(playerid);
	        if(h < 0) return true;
	        if(PlayerInfo[playerid][pHousing] == HouseInfo[h][hID])	lstring = "{FFFFFF}�� ������� ��� ������ ���������� �� ����� ����?";
			else 													lstring = "{FFFFFF}�� ������� ��� ������ ����������� � ���� ����?";
	        MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "��� - ��������", lstring, "��", "�����");
	    }
	    case DHOME_FURNITURE:
		{
			lstring = 	"{33AA33}\t������ ������\n\
						\t������ �������������� �����\n\
						{FFFFFF}������������� ������:\n";
			new query[128];
			new house = GetPlayerHouseID(playerid);
	        mysql_format(g_SQL, query, sizeof query, "SELECT `object_id`, `fur_num`, `set` FROM `furniture` WHERE `house_id` = '%d'", HouseInfo[house][hID]);
			new Cache:result = mysql_query(g_SQL, query);
			if(cache_num_rows())
			{
				new num, set;
			    for(new r = 0; r < cache_num_rows(); r++)
			    {
			    	cache_get_value_index_int(r, 1, num);
			    	cache_get_value_index_int(r, 2, set);
				    format(lstring, sizeof(lstring), "%s%s %s\n", lstring, (set) ? ("{FFFFFF}[+]") : ("{AFAFAF}[-]"), FurnitureList[num][fName]);
			    }
			}
   			cache_delete(result);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "��� - ������", lstring, "�������", "�����");
		}
		case DHOME_BUY_FUR_SLOT:
		{
		    format(lstring, sizeof(lstring), "������� ���-�� ������ ��� �������:\n\n���� ������ ����� %d �����", FUR_SLOT_PRICE);
		    MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "��� - ������", lstring, "�������", "�����");
		}
		case DHOME_RENT:
		{
			new h = GetPlayerHouseID(playerid);
	        if(h < 0 || h >= sizeof(HouseInfo)) return true;
	        if(HouseInfo[h][hRentPrice] > 0)
	        {
				mysql_format(g_SQL, string, sizeof(string), "SELECT `username` FROM `players` WHERE `rent` = '%d'", HouseInfo[h][hID]);
			    new Cache:result = mysql_query(g_SQL, string);
			    if(cache_num_rows() > 0)
			    {
			    	format(lstring, sizeof(lstring), "{33AA33}����������:{FFFFFF}");
			    	new name[MAX_PLAYER_NAME];
			    	for(new i = 0; i < cache_num_rows(); i++)
			    	{
			    		cache_get_value_index(i, 0, name);
			    		format(lstring, sizeof(lstring), "%s\n\t%s", lstring, name);
			    	}
			    }
			    cache_delete(result);
			    format(lstring, sizeof(lstring), "%s\n{33AA33}�������� ���������\n{FF6347}������� ������", lstring);
			    MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "��� - ������", lstring, "�������", "�����");
	        }
	        else
	        {
	        	MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "��� - ������", "������� ��������� ������ � ����� ����:", "�������", "�����");
	        }
		}
		case DHOME_RENT_MOVEOUT:
		{
			new h = GetPlayerHouseID(playerid);
	        if(h < 0) return true;
			new userid = GetPVarInt(playerid, "House:Rent:Playerid");
			format(lstring, sizeof(lstring), "{FFFFFF}�� ������� ��� ������ �������� %s?", GetPlayerUsername(userid));
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "��� - ������", lstring, "��", "���");
		}
		case DHOME_RENT_CHANGE:
		{
			new h = GetPlayerHouseID(playerid);
	        if(h < 0) return true;
	        MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "��� - ������", "{FFFFFF}������� ��������� ������ � ����� ����:", "�������", "�����");
		}
		case DHOME_TAKE_RENT:
		{
			new h = PickupedHouse[playerid];
			if(h >= 0 && HouseInfo[h][hOwnerID] > 0)
    		{
    			if(HouseInfo[h][hRentPrice] > 0)
    			{
    				if(PlayerInfo[playerid][pRent])	lstring = "{FF6347}�� ��� ���-�� ��������� �����\n\n";
    				format(lstring, sizeof(lstring),
    					"%s{FFFFFF}�� ������� ��� ������ ���������� ���� ���?\n\
    					��������� ������: "MAIN_COLOR"$%d/����\n\n\
    					������� ���������� ���� ������:", lstring, HouseInfo[h][hRentPrice]);
    				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "��� - ������", lstring, "����", "������");
    			}
    		}
		}
		case DHOME_CANCEL_RENT:
		{
			new h = PickupedHouse[playerid];
			if(h >= 0)
    		{
    			if(PlayerInfo[playerid][pRent] == HouseInfo[h][hID]){
    				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "��� - ������", "�� ������� ��� ������ ����������� ������?", "��", "���");
    			}
    		}
		}
		//---
		case DNPC_EMMET:
		{
		    new ammoname[48], catname[20], weaponid;
		    lstring = ""MAIN_COLOR"   [���������]\t[��������]\t[����]\t[������/�����]\n";
		    for(new i; i < sizeof(EmmetStore); i++)
		    {
				switch(i)
				{
				    case 0:	catname = "��������";
				    case 1:	catname = "��������";
				    case 2:	catname = "�����������";
				    case 3:	catname = "�������";
				    case 4:	catname = "��������";
				    case 5:
				    {
				        format(lstring, sizeof(lstring), "%s- {C0DCC0}���������� �������\t \t{C0DCC0}[%d$]\t{C0DCC0}[1 / %d]\n", lstring, EmmetStore[i][2], EmmetStore[i][1]);
				        continue;
				    }
				    case 6:
				    {
				        format(lstring, sizeof(lstring), "%s- {C0DCC0}������������� �����\t \t{C0DCC0}[%d$]\t{C0DCC0}[1 / %d]\n", lstring, EmmetStore[i][2], EmmetStore[i][1]);
				        continue;
				    }
				}
				weaponid = EmmetStore[i][0];
				if(weaponid == 0 || EmmetStore[i][1] == 0)
				{
					if(weaponid == 0)	ammoname = "�����";
					format(lstring, sizeof(lstring), "%s{AFAFAF}- %s:\t{AFAFAF}%s\t{AFAFAF}[%d$]\t{AFAFAF}[%d / %d]\n",
						lstring, catname, ammoname, EmmetStore[i][2], GunParams[weaponid][GUN_AMMO], EmmetStore[i][1]);
				}
				else
				{
					strput(ammoname, GunParams[weaponid][GUN_NAME]);
					format(lstring, sizeof(lstring), "%s- %s:\t%s\t[%d$]\t[%d / %d]\n",
						lstring, catname, ammoname, EmmetStore[i][2], GunParams[weaponid][GUN_AMMO], EmmetStore[i][1]);
				}
		    }
		    MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST_HEADERS, "[�������� > Emmet]", lstring, "������", "�������");
		}
		//---
		case DRACE_JOIN:
		{
		    format(lstring, sizeof(lstring),
				"{DABB3E}��������: {FFFFFF}%s\n\
				{DABB3E}��� �����: {FFFFFF}������\n\
				{DABB3E}����������: {FFFFFF}%d/%d\n\
				\n{DABB3E}������: {FFFFFF}",
				RaceInfo[rName], RaceInfo[rPlayers], RaceInfo[sp_cache]);
			if(RaceInfo[rRecord] > 0 && strlen(RaceInfo[rRecordBy]))
			{
			    format(lstring, sizeof(lstring), "%s%s\n{DABB3E}��������: {FFFFFF}%s", lstring, UnixToRaceTime(RaceInfo[rRecord]), RaceInfo[rRecordBy]);
			}
			else strcat(lstring, "--:--.---\n{DABB3E}��������: {FFFFFF}n/a");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "�����: ����������", lstring, "�����", "�������");
		}
		case DRACE_MAIN:
		{
		    format(lstring, sizeof(lstring),
		        ""MAIN_COLOR"� {FFFFFF}������ ���� �����\n\
		         "MAIN_COLOR"� {FFFFFF}��������� ���������\n\
		         "MAIN_COLOR"� {FFFFFF}������� ����� �����\n");
		    if(RaceInfo[rStatus] != 0) strcat(lstring, "{FF6347}[!] {AFAFAF}���������� �����\n");
		    if(RaceInfo[rStatus] == 1) strcat(lstring, "{FF6347}[!] {AFAFAF}���� ����� �����\n");
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "�������� ����", lstring, "�������", "�������", 0);
		}
		case DRACE_LIST:
		{
			// new Cache:result = mysql_query(g_SQL, "SELECT * FROM `races`");
			new Cache:result = mysql_query(g_SQL, "SELECT `id`, `created`, `name`, `record`, `recordby`, (SELECT COUNT(*) FROM `race_spawn` WHERE race_spawn.raceid = races.id) AS count FROM `races`");
			if(!cache_num_rows())
			{
			    cache_delete(result);
			    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �� ������� �� ����� �����.");
			    return ShowDialog(playerid, DRACE_MAIN);
			}
			new id, created, name[32], record, recordby[32], sp_count;
		    for(new r = 0; r < cache_num_rows(); r++)
		    {
		        if(r > 11)
		        {
		            strcat(lstring, "(������ ����������, �������� ��������)");
		            break;
		        }
		        cache_get_value_index_int(r, 0, id);
		        cache_get_value_index_int(r, 1, created);
		        cache_get_value_index(r, 2, name);
		        cache_get_value_index_int(r, 3, record);
		        cache_get_value_index(r, 4, recordby);
		        cache_get_value_index_int(r, 5, sp_count);

				if(RaceInfo[rStatus] != 0 && RaceInfo[rID] == id)
				    format(lstring, sizeof(lstring), "%s{FFFFFF}#%d  | '%s' | Limit: %d | {33AA33}RUNNING NOW\n", lstring, id, name, sp_count);
				else if(created == 1)
				    format(lstring, sizeof(lstring), "%s{FFFFFF}#%d  | '%s' | Limit: %d | Record %s (%s)\n", lstring, id, name, sp_count, UnixToRaceTime(record), recordby);
				else
				    format(lstring, sizeof(lstring), "%s{FF6347}#%d  | '%s' | Limit: %d | NOT READY TO START\n", lstring, id, name, sp_count);
		    }
		    cache_delete(result);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "������ ��������� �����", lstring, "�������", "�����", 0);
		}
		case DRACE_EDIT:
		{
		    mysql_format(g_SQL, string, sizeof(string), "SELECT `created`, `name` FROM `races` WHERE `id` = '%d'", redit_id[playerid]);
			new Cache:result = mysql_query(g_SQL, string);
			if(!cache_num_rows())
			{
			    cache_delete(result);
			    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ����� �� ����������.");
			    ShowDialog(playerid, DRACE_LIST);
			    return 1;
			}
			new name[32], created;
	        cache_get_value_name_int(0, "created", created);
	        cache_get_value_name(0, "name", name);
	        cache_delete(result);
	        //---
			foreach(LoginPlayer, i)
			{
			    if(playerid != i && redit_id[i] == redit_id[playerid])
			    {
			        SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "%s[%d] ��� ����������� ��� �����.", ReturnPlayerName(i), i);
			        redit_id[playerid] = 0;
			        ShowDialog(playerid, DRACE_MAIN);
			        return 1;
			    }
			}
	        //---
	        if(RaceInfo[rStatus] != 0)
	        {
	            if(redit_id[playerid] == RaceInfo[rID])
					 lstring = ""MAIN_COLOR"� {AFAFAF}�������� �����\n";
	            else lstring = ""MAIN_COLOR"� {AFAFAF}��������� ����� [�������� ������]\n";
	        }
	        else	 lstring = ""MAIN_COLOR"� {FFFFFF}��������� �����\n";
		    //---
		    strcat(lstring, ""MAIN_COLOR"� {FFFFFF}��������� �����\n");
		    //---
		    if(created == 0) strcat(lstring, ""MAIN_COLOR"� {FFFFFF}��������� ��������������\n");
		    else             strcat(lstring, ""MAIN_COLOR"� {FFFFFF}����������� ��������������\n");
			//---
			if(created == 0)
			{
				// C���� �����
			    mysql_format(g_SQL, string, sizeof(string), "SELECT COUNT(*) AS count FROM `race_spawn` WHERE `raceid` = '%d'", redit_id[playerid]);
				result = mysql_query(g_SQL, string);
				new spawnpos;
				cache_get_value_index_int(0, 0, spawnpos);
				cache_delete(result);

				// ���������
			    mysql_format(g_SQL, string, sizeof(string), "SELECT COUNT(*) AS count FROM `race_cp` WHERE `raceid` = '%d'", redit_id[playerid]);
				result = mysql_query(g_SQL, string);
				new checkpoints;
				cache_get_value_index_int(0, 0, checkpoints);
				cache_delete(result);

			    strcat(lstring, "{AFAFAF}_______________________________\n");
			    if(!spawnpos) strcat(lstring, ""MAIN_COLOR"� {FFFFFF}������� ����� �����\n");
			    else          strcat(lstring, "{FF6347}� {FFFFFF}������������� ����� �����\n");
			    if(!checkpoints) strcat(lstring, ""MAIN_COLOR"� {FFFFFF}������� ���������\n");
			    else         	 strcat(lstring, "{FF6347}� {FFFFFF}������������� ���������\n");
			    strcat(lstring, "{FF6347}� {FFFFFF}�������� ������ �����\n\
							    {FF6347}� {FFFFFF}��������� ������� �����\n");
			}
	        format(string, 128, "����� #%d: %s", redit_id[playerid], name);
	 		MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, string, lstring, "�������", "�����", 0);
		}
		case DRACE_EDIT_PARAMS:
		{//
		    mysql_format(g_SQL, string, sizeof(string), "SELECT `creater`, `name`, `record`, `recordby`, `vehicle` FROM `races` WHERE `id` = '%d'", redit_id[playerid]);
			new Cache:result = mysql_query(g_SQL, string);
			if(!cache_num_rows())
			{
			    cache_delete(result);
			    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ����� �� ����������.");
			    ShowDialog(playerid, DRACE_LIST);
			    return 1;
			}
			new creater[32], name[32], recordby[32], model;
	        cache_get_value_index(0, 0, creater);
	        cache_get_value_index(0, 1, name);
	        new record;
	        cache_get_value_index_int(0, 2, record);
	        cache_get_value_index(0, 3, recordby);
	        cache_get_value_index_int(0, 4, model);
			cache_delete(result);
			//
			mysql_format(g_SQL, string, sizeof(string), "SELECT COUNT(*) AS count FROM `race_cp` WHERE `raceid` = '%d'", redit_id[playerid]);
			result = mysql_query(g_SQL, string);
			new cp_count;
			cache_get_value_index_int(0, 0, cp_count);
			cache_delete(result);
			//
			mysql_format(g_SQL, string, sizeof(string), "SELECT COUNT(*) AS count FROM `race_object` WHERE `raceid` = '%d'", redit_id[playerid]);
			result = mysql_query(g_SQL, string);
			new object_count;
			cache_get_value_index_int(0, 0, object_count);
			cache_delete(result);
			//
			mysql_format(g_SQL, string, sizeof(string), "SELECT COUNT(*) AS count FROM `race_spawn` WHERE `raceid` = '%d'", redit_id[playerid]);
			result = mysql_query(g_SQL, string);
			new spawn_count;
			cache_get_value_index_int(0, 0, spawn_count);
			cache_delete(result);
			//
		    format(lstring, sizeof(lstring), "����� �����: %s\n", creater);
		    format(lstring, sizeof(lstring), "%s��������: %s\n", lstring, name);
		    format(lstring, sizeof(lstring), "%s���: ������\n", lstring);
		    format(lstring, sizeof(lstring), "%s����������: %s[%d]\n", lstring, VehParams[model - 400][VEH_NAME], model);
		    format(lstring, sizeof(lstring), "%s����� �����: %d\n", lstring, spawn_count);
		    format(lstring, sizeof(lstring), "%s����������: %d\n", lstring, cp_count);
		    format(lstring, sizeof(lstring), "%s��������: %d\n", lstring, object_count);
		    format(lstring, sizeof(lstring), "%s������: %s (%s)\n", lstring, UnixToRaceTime(record), recordby);
		    //
		    format(string, 128, "����� #%d: ��������������", redit_id[playerid]);
	 		MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, string, lstring, "��������", "�����", 0);
		}
		case DRACE_DELCP:
		{
		    format(lstring, sizeof(lstring),
				"�� ��������� ������� ��� ��������� ������� � #%d\n\
		    	 ��� ������������� ������� 'delcp' ��� '��������'\n\
		    	 ��� �������� � ���� ������� ������ '�����'", redit_num[playerid]);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "��������������", lstring, "������", "�����", 0);
		}
		case DRACE_DELETE:
		{
		    format(lstring, sizeof(lstring),
				"{B1C8FB}�� ��������� ������� ����� #%d\n\
		    	 ��� ������ ����� {FF6347}������������ �������{B1C8FB}\n\
		    	 ��� ������������� ������� 'delete' ��� '�������'\n\
		    	 ��� �������� � ���� ������� ������ '�����'", redit_id[playerid]);
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "��������������", lstring, "������", "�����", 0);
		}
		//	casino
			//	poker
		case DPOKER_GAMESCALL:
		{
			if(GetPVarInt(playerid, "pkrChips") > 0)
			{
				SetPVarInt(playerid, "pkrActionChoice", 1);

				new tableid = GetPVarInt(playerid, "pkrTableID") - 1;
				new actualBet = PokerTable[tableid][pkrActiveBet] - GetPVarInt(playerid, "pkrCurrentBet");

				if(actualBet > GetPVarInt(playerid, "pkrChips"))
				{
					format(string, sizeof(string), "{FFFFFF}�� ������� ��� ������ ���������� ������ $%d (All-In)?", actualBet);
					return MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "����� - �������� ������", string, "All-In", "������");
				}
				else
				{
					format(string, sizeof(string), "{FFFFFF}�� ������� ��� ������ ���������� ������ $%d?", actualBet);
					return MyShowPlayerDialog(playerid, action, DIALOG_STYLE_MSGBOX, "����� - �������� ������", string, "��������", "������");
				}
			}
			else
			{
				new noFundsSoundID[] = { 5823, 5824, 5825 };
				new randomNoFundsSoundID = random(sizeof(noFundsSoundID));
				PlayerPlaySound(playerid, noFundsSoundID[randomNoFundsSoundID], 0.0, 0.0, 0.0);
				SendClientMessage(playerid, COLOR_WHITE, "- ������: ��� �� ������� ������� ��� ����������� ������");
			}
		}
		case DPOKER_GAMESRAISE:
		{
			new tableid = GetPVarInt(playerid, "pkrTableID") - 1;
			SetPVarInt(playerid, "pkrActionChoice", 1);

			if(GetPVarInt(playerid, "pkrCurrentBet") + GetPVarInt(playerid, "pkrChips") > PokerTable[tableid][pkrActiveBet] + PokerTable[tableid][pkrBlind] / 2)
			{
				SetPVarInt(playerid, "pkrActionChoice", 1);
				format(string, sizeof(string), "{FFFFFF}�� ������� �� ������ ������� ������? ($%d-$%d):", PokerTable[tableid][pkrActiveBet] + PokerTable[tableid][pkrBlind] / 2, GetPVarInt(playerid, "pkrCurrentBet") + GetPVarInt(playerid, "pkrChips"));
				return MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "����� - ������� ������", string, "�������", "������");
			}
			else if(GetPVarInt(playerid, "pkrCurrentBet") + GetPVarInt(playerid, "pkrChips") == PokerTable[tableid][pkrActiveBet] + PokerTable[tableid][pkrBlind] / 2)
			{
				SetPVarInt(playerid, "pkrActionChoice", 1);
				format(string, sizeof(string), "{FFFFFF}�� ������� �� ������ ������� ������? (All-In):", PokerTable[tableid][pkrActiveBet] + PokerTable[tableid][pkrBlind] / 2, GetPVarInt(playerid, "pkrCurrentBet") + GetPVarInt(playerid, "pkrChips"));
				return MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "����� - ������� ������", string, "All-In", "������");
			}
			else
			{
				new noFundsSoundID[] = { 5823, 5824, 5825 };
				new randomNoFundsSoundID = random(sizeof(noFundsSoundID));
				PlayerPlaySound(playerid, noFundsSoundID[randomNoFundsSoundID], 0.0, 0.0, 0.0);
				SendClientMessage(playerid, COLOR_WHITE, "- ������: ��� �� ������� ������� ��� �������� ������");
			}
		}
		case DPOKER_GAMESBUY:
		{
			format(lstring, sizeof(lstring), "{FFFFFF}������� ��� ��������� ����:\n\n�������/��������: {00FF00}$%d{FFFFFF}/{00FF00}$%d{FFFFFF}", PokerTable[GetPVarInt(playerid, "pkrTableID") - 1][pkrBuyInMin], PokerTable[GetPVarInt(playerid, "pkrTableID") - 1][pkrBuyInMax]);
			return MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "����� - ��������� ����", lstring, "������", "�����");
		}
		case DPOKER_GAMESETUP:
		{
			new tableid = GetPVarInt(playerid, "pkrTableID") - 1;
			if(tableid >= 0)
			{
				if(PokerTable[tableid][pkrPass][0] == EOS)
				{
					format(lstring, sizeof(lstring),
						""MAIN_COLOR"� {FFFFFF}������������ ��������� ����\t("MAIN_COLOR"$%d{FFFFFF})\n\
						"MAIN_COLOR"� {FFFFFF}����������� ��������� ����\t("MAIN_COLOR"$%d{FFFFFF})\n\
						"MAIN_COLOR"� {FFFFFF}������������ ������\t\t("MAIN_COLOR"$%d{FFFFFF}/"MAIN_COLOR"$%d{FFFFFF})\n\
						"MAIN_COLOR"� {FFFFFF}����� ����������\t\t("MAIN_COLOR"%d{FFFFFF})\n\
						"MAIN_COLOR"� {FFFFFF}������\t("MAIN_COLOR"%s{FFFFFF})\n\
						"MAIN_COLOR"� {FFFFFF}�������� �������\t("MAIN_COLOR"%d{FFFFFF})\n\
						"MAIN_COLOR"� {FFFFFF}������ ����",
						PokerTable[tableid][pkrBuyInMax],
						PokerTable[tableid][pkrBuyInMin],
						PokerTable[tableid][pkrBlind],
						PokerTable[tableid][pkrBlind] / 2,
						PokerTable[tableid][pkrLimit],
						"���",
						PokerTable[tableid][pkrSetDelay]
					);
				}
				else
				{
					format(lstring, sizeof(lstring),
						""MAIN_COLOR"� {FFFFFF}������������ ��������� ����\t("MAIN_COLOR"$%d{FFFFFF})\n\
						"MAIN_COLOR"� {FFFFFF}����������� ��������� ����\t("MAIN_COLOR"$%d{FFFFFF})\n\
						"MAIN_COLOR"� {FFFFFF}������������ ������\t("MAIN_COLOR"$%d{FFFFFF}/"MAIN_COLOR"$%d{FFFFFF})\n\
						"MAIN_COLOR"� {FFFFFF}����� ����������\t("MAIN_COLOR"%d{FFFFFF})\n\
						"MAIN_COLOR"� {FFFFFF}������\t("MAIN_COLOR"%s{FFFFFF})\n\
						"MAIN_COLOR"� {FFFFFF}�������� �������\t("MAIN_COLOR"%d{FFFFFF})\n\
						"MAIN_COLOR"� {FFFFFF}������ ����",
						PokerTable[tableid][pkrBuyInMax],
						PokerTable[tableid][pkrBuyInMin],
						PokerTable[tableid][pkrBlind],
						PokerTable[tableid][pkrBlind] / 2,
						PokerTable[tableid][pkrLimit],
						PokerTable[tableid][pkrPass],
						PokerTable[tableid][pkrSetDelay]
					);
				}
				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST, "����� - ��������� �����", lstring, "�������", "�����");
			}
		}
		case DPOKER_GAMESETUP2:
		{
			if(GetPVarType(playerid, "pkrTableID"))
				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "����� - ������������ ��������� ����", "{FFFFFF}������� ������������ ��������� ����:", "��������", "�����");
		}
		case DPOKER_GAMESETUP3:
		{
			if(GetPVarType(playerid, "pkrTableID"))
				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "����� - ����������� ��������� ����", "{FFFFFF}������� ����������� ��������� ����:", "��������", "�����");
		}
		case DPOKER_GAMESETUP4:
		{
			if(GetPVarType(playerid, "pkrTableID"))
				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "����� - ������ ������", "{FFFFFF}������� '������ ������':\n\n���������: ����������� ������ ����� ���������� �� ��������� ������������", "��������", "�����");
		}
		case DPOKER_GAMESETUP5:
		{
			if(GetPVarType(playerid, "pkrTableID"))
				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "����� - ����� �������", "{FFFFFF}������� ����� ������� ��� ���� (2-6):", "��������", "�����");
		}
		case DPOKER_GAMESETUP6:
		{
			if(GetPVarType(playerid, "pkrTableID"))
				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "����� - ��������� ������", "{FFFFFF}������� ������ ��� �����:\n\n< ��������� ������ 100 coins! >", "��������", "�����");
		}
		case DPOKER_GAMESETUP7:
		{
			if(GetPVarType(playerid, "pkrTableID"))
				MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "����� - �������� ����� ��������", "{FFFFFF}������� �������� ����� �������� (15 - 120���):", "��������", "�����");
		}
		//	chips
		case DCHIPS_MENU:
		{
			format(string, sizeof(string), "{FFFFFF}������ �����\t("MAIN_COLOR"%d{FFFFFF})\n������� �����\t("MAIN_COLOR"%d{FFFFFF})", MyGetPlayerMoney(playerid), GetChipAmount(playerid));
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_TABLIST, "������� � �������", string, "�������", "�������");
		}
		case DCHIPS_BUY:
		{
			format(string, sizeof(string), "{FFFFFF}������� ���-�� ����� ��� �������:\n\n���������: "MAIN_COLOR"$1/��.{FFFFFF}\n� ���: "MAIN_COLOR"%d �����\n\n", GetChipAmount(playerid));
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "������� �����", string, "������", "�����");
		}
		case DCHIPS_SELL:
		{
			format(string, sizeof(string), "{FFFFFF}������� ���-�� ����� ��� �������:\n\n���������: "MAIN_COLOR"$1/��{FFFFFF}\n� ���: "MAIN_COLOR"%d �����{FFFFFF}\n\n", GetChipAmount(playerid));
			MyShowPlayerDialog(playerid, action, DIALOG_STYLE_INPUT, "������� �����", string, "�������", "�����");
		}
		//-- case
	}
	// Dialogid[playerid] = action;
	// end of stock ShowDialog
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new string[256];
	if(Anticheat.GetToggle() && dialogid != -1 && Dialogid[playerid] != dialogid)
	{
		format(string, sizeof(string), "[AdmWrn]: %s[%d] ������� ������� �������", ReturnPlayerName(playerid), playerid);
		SendAdminMessage(COLOR_LIGHTRED, string);
	    MyHidePlayerDialog(playerid);
	    return true;
	}
	Dialogid[playerid] = INVALID_DIALOGID;
	switch(dialogid)
	{
	    case DMODE_NONE:
	    {
			return true;
		}
		case DMODE_EMAIL:
		{
			if(response)
			{
			    if(!strlen(inputtext))
			    	return ShowDialog(playerid, dialogid);

			    if(!IsValidEmail(inputtext))
			    {
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��������� email ����� �����������.");
			        return ShowDialog(playerid, dialogid);
			    }
			    new query[256];
			    mysql_format(g_SQL, query, sizeof query, "SELECT COUNT(*) FROM `players` WHERE `email` = '%e'", inputtext);
			    new Cache:result = mysql_query(g_SQL, query);
			    new count;
			    cache_get_value_index_int(0, 0, count);
			    if(count)
			    {
					cache_delete(result);
			    	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��������� email ��� ������������ ������ �������.");
			        return ShowDialog(playerid, dialogid);
			    }
			   	cache_delete(result);
			    SendConfirmMail(playerid, inputtext);
			    SendFormatMessage(playerid, COLOR_WHITE, string, "[���������]: �� ����� %s ���������� ������ ��� �� �������������", inputtext);
			}
			else ShowDialog(playerid, DMENU_PROTECTION);
		}
		case DMODE_NEWBIE:
		{
			if(response)
			{
				new lstring[1024];
				if(listitem == 0)	//	��� ��� ������?
				{
					strcat(lstring,
					"{FFFFFF}�� ������ �� ������ ������ �������� ����\n\
					��� ������ ������� ��������� �������, ������� ������� ���� ���������.\n\
					������ ����� �� ����������� � ����������� ������ - ��� ��������� ���� ��� ������!\n\
					�� ������ � ����� ������ ���������� ��� ��� ��������:\n\
					\t- �������� ���� "MAIN_COLOR"(������� H ��� ������� /mm){FFFFFF}\n\
					\t- �������� ������ ����� "MAIN_COLOR"'��� ������'{FFFFFF}\n\
					� ��� ��������� �������� ������ � ���������� ��� �� ����������.\n\
					"MAIN_COLOR"�� ���������� �� ��������� ����!");
				}
				else if(listitem == 1)	//	��� ���������� �����?
				{
					strcat(lstring, "{FFFFFF}�� ������� ���� ��������� �����.\n\
					��� ��� �������� �� 3 ����: "MAIN_COLOR"����������{FFFFFF}, "MAIN_COLOR"���������{FFFFFF} � "MAIN_COLOR"����������� {FFFFFF}������\n\
					\n\
					"MAIN_COLOR"� {FFFFFF}���������� �������� ����, �� ������� ���������� � �����-�� ������ �������.\n\
					(��� ��������� ���������� ����������� "MAIN_COLOR"/gps > ����������{FFFFFF})\n\
					\n");
					strcat(lstring,
					""MAIN_COLOR"� {FFFFFF}��������� ������ �������� � ����� ������� �� 2 ������ � ������� �������� �� ����.\n\
					(��� ��������� ��������� ������ ����������� "MAIN_COLOR"/gps > ��������� ������{FFFFFF})\n\
					\n\
					"MAIN_COLOR"� {FFFFFF}����������� ������ ������� ���������� �� �����, ������� �������� �� ���������� ������.\n\
					(��� ��������� ����������� ������ ����������� "MAIN_COLOR"/gps > ����������� ������{FFFFFF})\n");
				}
				else if(listitem == 2)	//	��� �������� �������?
				{
					lstring = "{FFFFFF}��� ������� ������� ��������� � �������\n\
					������� ������������ ���������� ������\n\
					����� ����� ������� ���������:\n\n\
					\t"MAIN_COLOR"� {FFFFFF}������� 14+\n\
					\t"MAIN_COLOR"� {FFFFFF}������� ������� 4+\n\
					\t"MAIN_COLOR"� {FFFFFF}���� �� ������� (�� ����� �������)\n\n\
					��������� � ��������� ����� ������ "MAIN_COLOR"�� ������ � '�������������� �������'";
				}
				else if(listitem == 3)	//	����� ������� ���� �� �������?
				{
					lstring = "{FFFFFF}�� ������� ������������: "MAIN_COLOR"�����{FFFFFF}, "MAIN_COLOR"�����{FFFFFF} � "MAIN_COLOR"��������������� �����������{FFFFFF}\n\
					������ ������� ������������ �������� ������\n\
					����� ����� ������ ������� ����������� "MAIN_COLOR"/leaders";
				}
				else if(listitem == 4)	//	��� �������� �������?
				{
					lstring = "{FFFFFF}������ ������������� ������ ������� �������� ���� ������ (������� 5+)\n\
					����� ���� ����� ����������� ������� �� ����� � ������� � ������ ����� � ����������\n\n\
					���������� �� ����� ������, ����� �� ������ ��������, ������ ������� � �������������\n\
					������� ���� � �����-������� �� ����� ������� ���.";
				}
				else if(listitem == 5)	//	��� �� ������� �������
				{
					lstring = "{FFFFFF}������ ������� ���������� ������� ������ ���������.\n\
					����� ��� ��������� - �� ����, ���� �� ��� ����� �� ���� - �� �������.\n\
					����� �� ������� - �� ������� ���� ��������.\n\
					��������� ������� ����� � ����������, ������� � 24/7.";
				}
				else if(listitem == 6)
				{
					return ShowDialog(playerid, DMENU_CONTACT);
				}
				MyShowPlayerDialog(playerid, DMODE_NEWBIE2, DIALOG_STYLE_MSGBOX, "����������", lstring, "�����", "", 0);
			}
			else gPickupTime[playerid] = 3;
		}
		case DMODE_NEWBIE2:
		{
			ShowDialog(playerid, DMODE_NEWBIE);
		}
		case DMODE_ANIMLIST:
		{
		    if(response)
		    {
		        if(listitem >= sizeof(AnimList)) return 1;
		        //
    			LoopingAnim(playerid,
					AnimList[listitem][ANIM_LIB],
					AnimList[listitem][ANIM_NAME],
					AnimList[listitem][ANIM_DELTA],
					AnimList[listitem][ANIM_LOOP],
					AnimList[listitem][ANIM_LOCKX],
					AnimList[listitem][ANIM_LOCKY],
					AnimList[listitem][ANIM_FREEZE],
					AnimList[listitem][ANIM_TIME],
					AnimList[listitem][ANIM_SYNC]);
    			ShowDialog(playerid, dialogid);
		    }
		}
		case DMODE_LAWYER:
		{
	        if(!response || PlayerInfo[playerid][pJailTime] >= 0) return 1;
	        new wl = -PlayerInfo[playerid][pJailTime];
	        switch(listitem)
	        {
	            case 0: return 1; // ��� ��������
	            case 1: // � ���������
	            {
	                new const price = floatround(wl * FINE_PER_WANTED * 1.5);
	                if(MyGetPlayerMoney(playerid) < price)
	                {
	                    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� �� ������� ����� ��� ������ ��������.");
	                    return ShowDialog(playerid, dialogid);
	                }
	                MyGivePlayerMoney(playerid, -price);
	                PlayerInfo[playerid][pJailTime] += 1;
	                JailTime[playerid] = 1;
	            }
	            case 2:// �������� �����
	            {
	                new const price = wl*5;
	                if(GetPlayerCoins(playerid) < price)
	                {
	                    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� �� ������� ����� ��� ���� ��������.");
	                    return ShowDialog(playerid, dialogid);
	                }
	                GivePlayerCoins(playerid, -price);
	                PlayerInfo[playerid][pJailTime] = 0;
	                JailTime[playerid] = 1;
	            }
	        }
		}
		case DMODE_POLICE_HQ:
		{
		    if(response)
		    {
		    	if(PM_Type[playerid] == 0)
		    	{
		  			if(listitem == -1)	return true;
					if(PoliceMission[listitem][pmNum] == 0)
					{
					    if(listitem != 0)	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������� ��� �� ���������.");
					    return ShowDialog(playerid, dialogid);
					}
				    PoliceMissionAccept(playerid, listitem);
			    }
			    else
			    {
					if(strlen(inputtext) == 0 || (strcmp(inputtext, "cancel", true) && strcmp(inputtext, "������", true)))
					{
						return ShowDialog(playerid, dialogid);
					}

					if(PM_Type[playerid] == 10)
					{
					    new bool:founded = false;
				        foreach(Cop, copid)
						{
							if(playerid != copid && PM_Type[copid] == 10 && PM_Place[copid] == PM_Place[playerid])
							{
							    founded = true;
								break;
							}
						}
						if(founded == false)
						{
						    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ���������� �� �������������, ���� ���������� ��� � ��������.");
						}
						format(string, 128, "[R] %s %s: {FFFFFF}�� ���� ���������� ������������� %s'a.", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(PM_Place[playerid]));
						SendPoliceMessage(COLOR_BLUE, string);
					}
					else
					{
						SendFormatMessage(playerid, COLOR_BLUE, string, "[R] %s %s: {FFFFFF}������ �� ������, �� ���� ��������� �������.", GetPlayerRank(playerid), ReturnPlayerName(playerid));
					}
					PoliceMissionCancel(playerid);
			    }
		    }
		}
	    case DMODE_POLICE_MISSION:
	    {
	        gPickupTime[playerid] = 5;
			switch(PM_Type[playerid])
			{
			    case 1:// ������ �����
			    {
					SendFormatMessage(playerid, COLOR_BLUE, string, "[R] %s %s: {FFFFFF}����������: �� ������ ������ �����, 10-8.", GetPlayerRank(playerid), ReturnPlayerName(playerid));
					PoliceMissionComplete(playerid, COST_PER_WANTED);
			    }
			    case 2:// ������ �������
			    {
			        PM_Step[playerid] = 1;
					MySetPlayerCheckpoint(playerid, CPPOLICE_MISSION, 1540.0, -1675.0, 13.5, 15.0);
					SendFormatMessage(playerid, COLOR_BLUE, string, "[R] %s %s: {FFFFFF}����������: �� ������ ������ �������, ���� ��� � �������.", GetPlayerRank(playerid), ReturnPlayerName(playerid));
			    }
			    case 3:// ���� ������
			    {
			        // ������ ����������
					new v = GetRandomVehicle(playerid, 1000.0);
					if(v == 0)
					{
						PoliceMissionCancel(playerid, "��������� �� ������");
						return 1;
					}
				    new Float:X, Float:Y, Float:Z, Float:A;
				    MyGetVehiclePos(v, X, Y, Z, A);
				    MyDestroyVehicle(v);
				    new vehicles[] = {429,402,411,541,415,560,559,603,475,506,451};
				    v = MyCreateVehicle(vehicles[random(sizeof(vehicles))], X, Y, Z, A, -1, -1);
				    PM_Place[playerid] = v;

					// ��������� ����������
					ShowWorkInfo(playerid, "", 0, "", 0, GetVehicleModel(v));
					WorkInfo_SetText(playerid, "In Wanted");
					WorkInfo_SetPreviewVehCol(playerid, CarInfo[v][cColor1], CarInfo[v][cColor2]);
					//PlayerTextDrawSetPreviewModel(playerid, InWantedTD, GetVehicleModel(v));
					//PlayerTextDrawSetPreviewVehCol(playerid, InWantedTD, CarInfo[v][cColor1], CarInfo[v][cColor2]);
					//PlayerTextDrawShow(playerid, InWantedTD);
					//PlayerTextDrawShow(playerid, InWantedInfo);

				    // �������� ���� ������
				    new const ZoneSize = 500;
				    new Float:DoubleX = random(ZoneSize);
				    new Float:DoubleY = random(ZoneSize);
					PM_SearchZone[playerid] = GangZoneCreate(X-DoubleX,Y-DoubleY,X+(ZoneSize-DoubleX),Y+(ZoneSize-DoubleY));
		    	    PM_SearchZone2[playerid] = CreateDynamicRectangle(X-DoubleX,Y-DoubleY,X+(ZoneSize-DoubleX),Y+(ZoneSize-DoubleY), -1, -1, playerid);
					MySetPlayerCheckpoint(playerid, CPPOLICE_MISSION, X - DoubleX + ZoneSize / 2, Y - DoubleY + ZoneSize / 2, 10.0, 0.0);
		    	    GangZoneShowForPlayer(playerid, PM_SearchZone[playerid], 0x000000DD);

			        PM_Step[playerid] = 1;
					SendFormatMessage(playerid, COLOR_BLUE, string, "[R] %s %s: {FFFFFF}����������: ���� ���������� %s, ������� ��������������.", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnVehicleName(PM_Place[playerid]));
			    }
			    case 4:// ������ �������
			    {
			    }
			}
	    }
	    case DMODE_POLICE_DUTY:
	    {
	    	if(response)
	    	{
	    		if(listitem == 0)
	    		{
	    			if(GetPlayerWantedLevel(playerid) == 0)
					{
				        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ���� �� �������� �� ������ �������� ������.");
					}
					else ShowDialog(playerid, DMODE_POLICE_WANTED);
	    		}
	    		else if(listitem == 1)
	    		{
	    			//	�������� ��������
	    			if(PlayerInfo[playerid][pGunLic])
	    			{
	    				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ���� ��������.");
	                    return ShowDialog(playerid, dialogid);
	    			}
	    			if(PlayerInfo[playerid][pLaw] < 0)
	    			{
	    				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������ ���� ������������� �����������������.");
	                    return ShowDialog(playerid, dialogid);
	    			}
	    			if(PlayerInfo[playerid][pShooting] < 4)
	    			{
	    				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ����� ������� � ����.");
	                    return ShowDialog(playerid, dialogid);
	    			}
	    			if(MyGetPlayerMoney(playerid) < 350)
	    			{
	    				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ ��������.");
	                    return ShowDialog(playerid, dialogid);
	    			}
	    			MyGivePlayerMoney(playerid, -350);
					PlayerInfo[playerid][pGunLic] = 1;
					SendClientMessage(playerid, COLOR_GREEN, "����������, �� ��������� �������� �� ������! ������ �� ������ ���������� � ���������!");
					ShowPlayerHint(playerid, "�� ��������:___________________~n~~g~- �������� �� ������");
					SuccesAnim(playerid);
					PlayerPlaySound(playerid, 36205, 0.0, 0.0, 0.0);
	    		}
	    	}
	    }
	    case DMODE_POLICE_WANTED:
	    {
	        if(response)
	        {
				new price = (GetPlayerWantedLevel(playerid) * FINE_PER_WANTED);
				if(MyGetPlayerMoney(playerid) < price)
				{
				    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �� ������� ����� ��� ������ �������.");
					return ShowDialog(playerid, dialogid);
				}
				MySetPlayerWantedLevel(playerid, 0);
				MyGivePlayerMoney(playerid, -price);
	        }
	        else
	        {
	        	ShowDialog(playerid, DMODE_POLICE_DUTY);
	        }
	    }
	    case DMODE_POLICE_STOPMENU:
	    {
	    	new targetid = PM_Place[playerid];
	    	new vehicleid = gLastVehicle[targetid];
	    	if(PursuitStatus[targetid] == PS_WAIT)
	    	{
				switch(listitem)
				{
					case 0:
					{	//	���������� �����
		    			if(GetPlayerState(targetid) == PLAYER_STATE_DRIVER)
		    			{
			    			PursuitStatus[targetid] = PS_WAIT_OUT_VEH;
		    				PursuitCount[targetid] = 15 + 1;
		    				format(string, sizeof(string), "- %s %s �������: ������� �� ������ � ��������� ������! (( %s ))", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(targetid));
							ProxDetector(playerid, 30.0, string, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, 0xE6E6E6E6, 0xC8C8C8C8);
							PlayerPlaySound(playerid, 34403, 0, 0, 0);
							PlayerPlaySound(targetid, 34403, 0, 0, 0);
							ShowPlayerHint(targetid, "_~b~�����������~w~ ������ ��� ����� �� ����������");
						}
						else
						{
				    		PursuitStatus[targetid] = PS_OUT_COMPLETE;
				    		PursuitCount[targetid] = 30;
				    		PursuitHandsup(targetid);
					        SendClientMessage(targetid, COLOR_BLUE, "> ����������� �� ����� ���� ����������� ��� �� ��������.");
						}
						return true;
					}
					case 1:	
					{	//	��������� ���������
						if(GetPVarInt(targetid, "Pursuit:CheckDoc") == 0)
						{
							new check;
							SendFormatMessage(targetid, COLOR_BLUE, string, "%s %s �������� ���� ���������.", GetPlayerRank(playerid), ReturnPlayerName(playerid));
		   	                if(IsAvailableVehicle(vehicleid, targetid) < VEH_AVAILABLE_CONTROL)
		   	                {
		   	                	CrimePlayer(targetid, CRIME_THEFT_AUTO);
		   	                	check++;
		   	                }
		   	                //if(PlayerInfo[targetid][pCarLic] == 0 && VehInfo[vehicleid][vModelType] != MTYPE_NODOOR
							//&& VehInfo[vehicleid][vModelType] != MTYPE_BIKE && VehInfo[vehicleid][vModelType] != MTYPE_RC)
							if(IsPlayerHaveLicThisVehicle(playerid, GetVehicleModel(vehicleid)))
							{
		   	                	CrimePlayer(targetid, CRIME_NOT_LIC);
		   	                	check++;
							}
							if(check == 0)
							{
								SendFormatMessage(playerid, COLOR_BLUE, string, "�� ������� ��������� ��������� %s.", ReturnPlayerName(targetid));
							}
							SetPVarInt(targetid, "Pursuit:CheckDoc", 1); 
						}
					}
					case 2:
					{	//	��������� ���������
						if(GetPVarInt(targetid, "Pursuit:CheckDrunk") == 0)
						{
							if(GetPlayerDrunkLevel(playerid) > 2000)
							{
								CrimePlayer(targetid, CRIME_DRUNK);
							}
		   	            	else
		   	            	{
		   	            		SendFormatMessage(targetid, COLOR_BLUE, string, "%s %s �������� ��� �� ���������", GetPlayerRank(playerid), ReturnPlayerName(playerid));
		   	            		SendFormatMessage(playerid, COLOR_BLUE, string, "��������� ��������: %s �������� �������", ReturnPlayerName(targetid));
		   	            	}
		   	            	SetPVarInt(targetid, "Pursuit:CheckDrunk", 1);
						}
					}
					case 3:
					{	//	�������� ���
						if(GetPVarInt(targetid, "Pursuit:CheckLight") == 0)
						{
							new hour; gettime(hour, _, _);
		   	            	if(IsVehicleWithEngine(vehicleid) && (hour <= 5 || hour >= 20))
		   	            	{
		   	            		if(PursuitLamp[targetid] == false)
		   	            		{
		   	            			CrimePlayer(targetid, CRIME_NOT_LIGHT);
			   	            	}
			   	            	else
			   	            	{
			   	            		SendFormatMessage(targetid, COLOR_BLUE, string, "%s %s �������� ��������� ����� ���", GetPlayerRank(playerid), ReturnPlayerName(playerid));
			   	            		SendFormatMessage(playerid, COLOR_BLUE, string, "��������� ��������: %s ���� � ����������� ������", ReturnPlayerName(targetid));
			   	            	}
			   	            }
							SetPVarInt(targetid, "Pursuit:CheckLight", 1);
						}
					}
					case 4:
					{
						new wl = GetPlayerWantedLevel(targetid);
						if(0 < wl < 4)
						{	//	�������� �����
							new finecash = wl * FINE_PER_WANTED;
							if(AskPlayer(playerid, targetid, ASK_POLICE_FINE, 30, finecash))
							{
								//AskAmount[targetid] = finecash;
								//PursuitCount[targetid] = 40;	//	������� ������ ������
								SendFormatMessage(playerid, COLOR_DBLUE, string, "���������� %s �������� ��������� �� �������, �������� ������!", ReturnPlayerName(targetid));
								SendFormatMessage(targetid, COLOR_DBLUE, string, "%s %s ������� ��� ����� �� %d$. ��������? "ASK_CONFIRM_INFO, GetPlayerRank(playerid), ReturnPlayerName(playerid), finecash);
								return true;
							}
							else
							{
								SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ������ ���� �� �������� ������, ���������.");
							}
			    		}
			    		else if(wl == 0)
			    		{
			    			CancelPlayerPursuit(targetid, 1);
							SendFormatMessage(playerid, COLOR_DBLUE, string, "� �������������� %s �� ���������� ��������������", ReturnPlayerName(targetid));
							SendFormatMessage(targetid, COLOR_DBLUE, string, "%s %s �� ����� ������� ��������������, �� ��������", GetPlayerRank(playerid), ReturnPlayerName(playerid));
			    			return true;
			    		}
					}
				}
				ShowDialog(playerid, dialogid);
	    	}
	    }
	    case DMODE_SHOP:
	    {
	        if(!response) 	return true;
	        new b = GetBizWhichPlayer(playerid);
	        if(b != INVALID_DATA && BizInfo[b][bType] == BUS_SHOP)
	        {
		        new price;
	            switch(listitem)
				{
	                case 0:
					{	// �������� ����
						price = GetThingCost(THING_WATCH);
						if(MyGetPlayerMoney(playerid) < price)
					    {
					        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� �����.");
							return ShowDialog(playerid, dialogid);
					    }
						if(Inv.AddPlayerThing(playerid, THING_WATCH, 1) == 0)
						{
							return ShowDialog(playerid, dialogid);
						}
	                }
					case 1:
					{	// �������� � �������
						price = 80;
					    if(MyGetPlayerMoney(playerid) < price)
					    {
					        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� �����.");
							return ShowDialog(playerid, dialogid);
					    }
					    new weapon, ammo;
					    GetPlayerWeaponData(playerid, 9, weapon, ammo);
					    if(weapon == 41 && ammo > 10000)
					    {
					    	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������� ����� ������.");
							return ShowDialog(playerid, dialogid);
					    }
	                    //MyGivePlayerWeapon(playerid, 41, 150);
	                    Inv.GivePlayerWeapon(playerid, 41, 150);
	                }
					case 2:
					{	// 	��������� �������
					#if defined _player_phone_included
						if(PlayerInfo[playerid][pPhoneNumber] > 0)
						{
	                        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ���� ��������� �������.");
	                        return ShowDialog(playerid, dialogid);
						}
						price = 150;
						if(MyGetPlayerMoney(playerid) < price)
					    {
					        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� �����.");
							return ShowDialog(playerid, dialogid);
					    }
						PlayerInfo[playerid][pPhoneNumber] = CreatePhoneNumber();
						if(PlayerInfo[playerid][pPhoneNumber] == 0)
						{
					        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ����� ������ ��� ���, ���������� ��� ���.");
							return ShowDialog(playerid, dialogid);
						}
						SendFormatMessage(playerid, COLOR_WHITE, string, "��� ����� ��������: %d", PlayerInfo[playerid][pPhoneNumber]);
						PlayerInfo[playerid][pPhoneEnable] = true;
						PlayerInfo[playerid][pPhoneBalance] = 50;
						UpdatePlayerData(playerid, "p_number", PlayerInfo[playerid][pPhoneNumber]);
					#else
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ���������� � ������ ������.");
	                    return ShowDialog(playerid, dialogid);		
					#endif	
					}
					case 3:
					{	// ���������: ������
						price = GetThingCost(THING_FIREWORK);
					    if(MyGetPlayerMoney(playerid) < price)
					    {
					        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� �����.");
							return ShowDialog(playerid, dialogid);
					    }
						if(Inv.AddPlayerThing(playerid, THING_FIREWORK, 1) == 0)
						{
							return ShowDialog(playerid, dialogid);
						}
					}
					case 4:
					{   // ����� �������
						price = GetThingCost(THING_CIGARETTE);
					    if(MyGetPlayerMoney(playerid) < price)
					    {
					        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� �����.");
							return ShowDialog(playerid, dialogid);
					    }
						if(Inv.AddPlayerThing(playerid, THING_CIGARETTE, 10) == 0)
						{
							return ShowDialog(playerid, dialogid);
						}
					}
					case 5:
					{	//	���������� ��������
						price = GetThingCost(THING_CHOCOLATE);
						if(MyGetPlayerMoney(playerid) < price)
					    {
					        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� �����.");
							return ShowDialog(playerid, dialogid);
					    }
						if(Inv.AddPlayerThing(playerid, THING_CHOCOLATE, 1) == 0)
						{
							return ShowDialog(playerid, dialogid);
						}
					}
					case 6:
					{	//	�������
						price = GetThingCost(THING_BOX);
						if(MyGetPlayerMoney(playerid) < price)
					    {
					        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� �����.");
							return ShowDialog(playerid, dialogid);
					    }
						if(Inv.AddPlayerThing(playerid, THING_BOX, 1) == 0)
						{
							return ShowDialog(playerid, dialogid);
						}
					}
					case 7:
					{	//	����
						price = GetThingCost(THING_SUITCASE);
						if(MyGetPlayerMoney(playerid) < price)
					    {
					        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� �����.");
							return ShowDialog(playerid, dialogid);
					    }
						if(Inv.AddPlayerThing(playerid, THING_SUITCASE, 1) == 0)
						{
							return ShowDialog(playerid, dialogid);
						}
					}
					case 8:
					{	//	�������
						price = GetThingCost(THING_SUITCASE2);
						if(MyGetPlayerMoney(playerid) < price)
					    {
					        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� �����.");
							return ShowDialog(playerid, dialogid);
					    }
						if(Inv.AddPlayerThing(playerid, THING_SUITCASE2, 1) == 0)
						{
							return ShowDialog(playerid, dialogid);
						}
					}
					case 9:
					{	//	�����
						price = GetThingCost(THING_BAG);
						if(MyGetPlayerMoney(playerid) < price)
					    {
					        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� �����.");
							return ShowDialog(playerid, dialogid);
					    }
						if(Inv.AddPlayerThing(playerid, THING_BAG, 1) == 0)
						{
							return ShowDialog(playerid, dialogid);
						}
					}
					case 10:
					{	//	������
						price = GetThingCost(THING_BAG2);
						if(MyGetPlayerMoney(playerid) < price)
					    {
					        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� �����.");
							return ShowDialog(playerid, dialogid);
					    }
						if(Inv.AddPlayerThing(playerid, THING_BAG2, 1) == 0)
						{
							return ShowDialog(playerid, dialogid);
						}
					}
	            }
	            BizSaleProds(b, price, 1);
	            MyGivePlayerMoney(playerid, -price);
	            MyApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0);
	            SetPlayerFacingAngle(playerid, 180.0);
	            return ShowDialog(playerid, dialogid);
	        }
	    }
		case DMODE_SEXSHOP:
		{
			if(response)
			{
			    MyGivePlayerMoney(playerid, -35);
			    SendClientMessage(playerid, COLOR_WHITE, "�� ������ ������������� �� $35");
			    switch(listitem)
			    {
			        case 0: Inv.GivePlayerWeapon(playerid, 10, 1); //MyGivePlayerWeapon(playerid, 10, 1);
			        case 1: Inv.GivePlayerWeapon(playerid, 11, 1); //MyGivePlayerWeapon(playerid, 11, 1);
			        case 2: Inv.GivePlayerWeapon(playerid, 12, 1); //MyGivePlayerWeapon(playerid, 12, 1);
			        case 3: Inv.GivePlayerWeapon(playerid, 13, 1); //MyGivePlayerWeapon(playerid, 13, 1);
			    }
			}
		}
		case DMODE_HOUSE:
		{
		    gPickupTime[playerid] = 3;
		    if(response)
		    {
		    	if(GetPlayerHouse(playerid) > 0){
		    		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ����� ������ ������ ����");
		    		return ShowDialog(playerid, dialogid);
		    	}
		        new h = PickupedHouse[playerid];
				PickupedHouse[playerid] = -1;
		        if(h >= 0 && HouseInfo[h][hOwnerID] == 0 && BuyPlayerHouse(playerid, h))
		        {
		            if(HouseInfo[h][hDonate] == 0)
			            format(string, 128, "�� ������� ������ ��� #%d �� %d$", HouseInfo[h][hID], HouseInfo[h][hPrice]);
			        else
			            format(string, 128, "�� ������� ������ ��� #%d �� %d �����", HouseInfo[h][hID], HouseInfo[h][hPrice]);
		            SendClientMessage(playerid, COLOR_WHITE, string);
		            UpdatePlayerStatics(playerid);
		            gPickupTime[playerid] = 0;
		        }
		    }
			else PickupedHouse[playerid] = -1;
		}
		case DMODE_HOUSE_SELL:
		{
		    if(response)
		    {
				if(!strlen(inputtext) || (strcmp(inputtext, "sell", true) && strcmp(inputtext, "�������", true)))
					return ShowDialog(playerid, dialogid);
				new h = PickupedHouse[playerid];
			    if(h != -1 && HouseInfo[h][hOwnerID] == PlayerInfo[playerid][pUserID])
			    {
			        SellHouse(h);
					UpdatePlayerStatics(playerid);
			    }
			}
			//else PickupedHouse[playerid] = -1;
		}
		case DMODE_RADIO:
		{
		    if(response && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
				new vehicleid = GetPlayerVehicleID(playerid);
				VehInfo[vehicleid][vRadio] = listitem;
				UpdateVehRadio(vehicleid);
				PlayerAction(playerid, "����������� ������������.");
	        }
		}
		case DMODE_RADIO_PLEER:
		{
	        if(response)
	        {
				SetPVarInt(playerid, "Thing:RadioID", listitem);
				UpdatePlayerRadio(playerid);
				PlayerAction(playerid, "����������� ������������ � ������.");
	        }
		}
		case DMODE_VMENU:
	    {
	    	if(response)
		    {
		    	new item = 0, targetid = INVALID_PLAYER_ID;
		    	new vehicleid = GetPVarInt(playerid, "VehicleMenu:VehicleID");
		    	if(PlayerInfo[playerid][pFaction] == F_POLICE && IsPoliceDuty(playerid) && PM_Type[playerid] == 0)
				{
					if(VehInfo[vehicleid][vDriver] >= 0 && PursuitStatus[ VehInfo[vehicleid][vDriver] ] == PS_NONE && listitem == item++)
					{
						targetid = VehInfo[vehicleid][vDriver];
					}
					else if(VehInfo[vehicleid][vCoDriver] >= 0 && PursuitStatus[ VehInfo[vehicleid][vCoDriver] ] == PS_NONE && listitem == item++)
					{
						targetid = VehInfo[vehicleid][vCoDriver];
					}
					else if(VehInfo[vehicleid][vLeftSeat] >= 0 && PursuitStatus[ VehInfo[vehicleid][vLeftSeat] ] == PS_NONE && listitem == item++)
					{
						targetid = VehInfo[vehicleid][vLeftSeat];
					}
					else if(VehInfo[vehicleid][vRightSeat] >= 0 && PursuitStatus[ VehInfo[vehicleid][vRightSeat] ] == PS_NONE && listitem == item++)
					{
						targetid = VehInfo[vehicleid][vRightSeat];
					}
					if(targetid != INVALID_PLAYER_ID)
					{
						if(IsForce(PlayerInfo[targetid][pFaction]))
						{
						    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������� �������� � �������, �� �� ������ ���������� ���.");
						}
						else if(IsPlayerAFK(targetid))
						{
							return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������� ��������� � AFK, ��� ������ ����������.");
						}
						else if(GetPlayerWantedLevel(targetid) == 0 && PursuitLastUNIX[targetid] > gettime())
						{
						    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ������� ����� ������ ��� ���������.");
						}
						PursuitStatus[targetid] = PS_WAIT_OUT_VEH;
						PursuitCount[targetid] = 15 + 1;
						pursuit_timer[targetid] = SetTimerEx("PursuitTimer", 1000, true, "i", targetid);
						PM_Type[playerid] = 10, PM_Place[playerid] = targetid;
						format(string, sizeof(string), "- %s %s �������: ������� �� ������ � ��������� ������! (( %s ))", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(targetid));
						ProxDetector(playerid, 30.0, string, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, 0xE6E6E6E6, 0xC8C8C8C8);
						PlayerPlaySound(playerid, 34403, 0, 0, 0);
						PlayerPlaySound(targetid, 34403, 0, 0, 0);
						ShowPlayerHint(targetid, "_~b~�����������~w~ ������ ��� ����� �� ����������");
					}
				}
				else if(Job.GetPlayerNowWork(playerid) == JOB_MECHANIC)
				{
					if(VehInfo[vehicleid][vDriver] >= 0 && listitem == item++)
					{
						SetPVarInt(playerid, "Mechanic:Refill:VehicleID", vehicleid);
						ShowDialog(playerid, DMODE_REFILL);
					}
				}
				if(listitem == item++)
				{
					LockPlayerVehicle(playerid, vehicleid);
				}
		    }
	    }
	    case DMODE_REFILL:
	    {
	    	if(response)
	    	{
	    		new vehicleid = gLastVehicle[playerid];
	    		if(CarInfo[vehicleid][cType] != C_TYPE_JOB || CarInfo[vehicleid][cOwnerID] != JOB_MECHANIC)
		    	{
		    		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, ��� ��������� ��������� ������ ���� �������.");
		    		return ShowDialog(playerid, dialogid);
		    	}
		    	new Float:pos[3];
		    	new v = GetPVarInt(playerid, "Mechanic:Refill:VehicleID");
				GetVehiclePos(v, Arr3<pos>);
				if(GetVehicleDistanceFromPoint(vehicleid, Arr3<pos>) > 10)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, ��� ������� ���� ������ ���� ����� � ������������.");
					return ShowDialog(playerid, dialogid);
		    	}
		    	if(GetPlayerDistanceFromPoint(playerid, Arr3<pos>) > 10)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, �� ������ ���� ����� � ������������ �����������.");
					return ShowDialog(playerid, dialogid);
		    	}
		    	if(VehInfo[v][vDriver] < 0)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, � ���������� ������ ������ ��������.");
					return ShowDialog(playerid, dialogid);
				}

	    		new val = strval(inputtext);
	    		if(val <= 0 || val > VehInfo[vehicleid][vFuel] || (VehInfo[v][vFuel] + val) > GetVehicleMaxFuel(v))
	    		{
	    			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������� �� ������ � ���, ���� � ��� ������� ���.");
		    		return ShowDialog(playerid, dialogid);
	    		}
	    		SetPVarInt(playerid, "Mechanic:Refill:Count", val);
	    		ShowDialog(playerid, DMODE_REFILL2);
	    	}
	    	else
	    	{
	    		DeletePVar(playerid, "Mechanic:Refill:VehicleID");
	    		DeletePVar(playerid, "Mechanic:Refill:Count");
	    	}
	    }
	    case DMODE_REFILL2:
	    {
	    	if(response)
	    	{
	    		new vehicleid = gLastVehicle[playerid];
	    		if(CarInfo[vehicleid][cType] != C_TYPE_JOB || CarInfo[vehicleid][cOwnerID] != JOB_MECHANIC)
		    	{
		    		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, ��� ��������� ��������� ������ ���� �������.");
		    		return ShowDialog(playerid, dialogid);
		    	}
		    	new Float:pos[3];
		    	new v = GetPVarInt(playerid, "Mechanic:Refill:VehicleID");
				GetVehiclePos(v, Arr3<pos>);
				if(GetVehicleDistanceFromPoint(vehicleid, Arr3<pos>) > 10)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, ��� ������� ���� ������ ���� ����� � ������������.");
					return ShowDialog(playerid, dialogid);
		    	}
		    	if(GetPlayerDistanceFromPoint(playerid, Arr3<pos>) > 10)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, �� ������ ���� ����� � ������������ �����������.");
					return ShowDialog(playerid, dialogid);
		    	}
		    	new targetid = VehInfo[v][vDriver];
		    	if(targetid < 0)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������, � ���������� ������ ������ ��������.");
					return ShowDialog(playerid, dialogid);
				}
				new count = GetPVarInt(playerid, "Mechanic:Refill:Count");
	    		new cost = strval(inputtext);
	    		if(cost < 0 || cost > (PRICE_FUEL * count * 5))
	    		{
	    			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��������� ������� �������.");
		    		return ShowDialog(playerid, dialogid);
	    		}
	    		DeletePVar(playerid, "Mechanic:Refill:VehicleID");
	    		DeletePVar(playerid, "Mechanic:Refill:Count");
	    		if(AskPlayer(playerid, targetid, ASK_REFILL, 30, count, cost))
    			{
					// AskAmount[targetid] = count;
					// AskAmount2[targetid] = cost;
					SendFormatMessage(playerid, COLOR_WHITE, string, "�� ���������� %s ��������� ��� ���� �� %d ������ �� $%d", ReturnPlayerName(targetid), count, cost);
					SendFormatMessage(targetid, COLOR_WHITE, string, "%s ��������� ��� ��������� ��� ���� �� %d ������ �� $%d "ASK_CONFIRM_INFO, ReturnPlayerName(playerid), count, cost);
					return true;
				}
				else
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ������ ���� �� �������� ������, ���������� �����.");
				}
	    	}
	    	ShowDialog(playerid, DMODE_REFILL);
	    }
		case DMODE_VFIND:
		{
		    if(response)
		    {
				if(strlen(inputtext) == 0)
					return ShowDialog(playerid, dialogid);
				new results, lstring[256];
				for(new m = 0; m < sizeof VehParams; m++)
				{
				    if(strfind(VehParams[m][VEH_NAME], inputtext, true) != -1)
					{
						format(lstring, sizeof lstring, "%s%d: %s\n", lstring, VehParams[m][VEH_MODEL], VehParams[m][VEH_NAME]);
					    if(++results > 12) break;
					}
				}
				if(results == 0)
				{
				    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ����� ������� �� ������� �� ����� ������.");
					return ShowDialog(playerid, dialogid);
				}
				MyShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, "����� ����", lstring, "�����", "�������");
			}
		}
		case DMODE_GOTOLIST:
		{
		    if(response)
		    {
	            new g = listitem, vehicleid = GetPlayerVehicleID(playerid);
	            CreateGotoSmoke(playerid);
		        if(vehicleid)
				{
					MySetVehiclePos(vehicleid, GotoList[g][G_X], GotoList[g][G_Y], GotoList[g][G_Z], GotoList[g][G_A]);
					LinkVehicleToInterior(vehicleid, 0);
					SetVehicleVirtualWorld(vehicleid, 0);
				}
				else MySetPlayerPos(playerid, GotoList[g][G_X], GotoList[g][G_Y], GotoList[g][G_Z], GotoList[g][G_A]);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerInterior(playerid, 0);
				SetCameraBehindPlayer(playerid);
		    }
		}
		case DMODE_REPAIR:
		{
	        new vehicleid = GetPlayerVehicleID(playerid);
	        TogglePlayerControllable(playerid, true);
		    if(!response || !vehicleid)
		    {
		        DeletePVar(playerid, "repair_body_price");
		        DeletePVar(playerid, "repair_all_price");
				SetTimerEx("RecreateRepairPickup", 3000, false, "i", pRepair[playerid]);
		        return true;
		    }
		    new item[4], Float:health, price, type = 0;
    		GetVehicleHealth(vehicleid, health);
			GetVehicleDamageStatus(GetPlayerVehicleID(playerid), Arr4<item>);
	        switch(listitem)
			{
	            case 0:
				{	//	�������� ������
	                if(!item[0] && !item[1] && !item[2] && !item[3])
						price = 0;
					else	price = GetPVarInt(playerid, "repair_body_price");
	    			item[0] = 0;	item[1] = 0;	item[2] = 0;	item[3] = 0;
	            }
	            case 1:
				{	//	������
				    if(!item[0])	price = 0;
				    else            price = 25;
    				item[0] = 0;
				}
				case 2:
				{	//	�����
					if(item[1] & 0x4 || item[1] & 0x2)				price += 10;	//  ����� ���������
				    if(item[1] >> 8 & 0x4 || item[1] >> 8 & 0x2)	price += 10;	//  �������� ���������
				 	if(item[1] >> 16 & 0x4 || item[1] >> 16 & 0x2)  price += 10;	//  ����� �������� ����������
					if(item[1] >> 24 & 0x4 || item[1] >> 24 & 0x2)	price += 10;	//  ����� �������� ����������
					item[1] = 0;

					UpdateVehicleDamageStatus(vehicleid, Arr4<item>);
				}
				case 3:
				{	//	����
				    if(!item[2])	price = 0;
				    else            price = 10;
                    item[2] = 0;
				}
				case 4:
				{	//	������
					if(item[3] & 0x1)   price += 10;
					if(item[3] & 0x2)   price += 10;
					if(item[3] & 0x4)   price += 10;
					if(item[3] & 0x8)   price += 10;
				    item[3] = 0;
				}
	            case 5:
				{	//	������� ���������
	                if(health >= 900.0) price = 0;
					else				price = floatround((1000.0 - health) / 7.5);
               	 	type = 1;
	            }
	            case 6:
				{	//	����������
					if(item[0] || item[1])
					{
                    	SendClientMessage(playerid, COLOR_SAYING, "- �����������: � �� ���� ��������� ���� �����, ���� ��� ��� �������.");
                    	return ShowDialog(playerid, dialogid);
					}
					if(CarInfo[vehicleid][cType] == C_TYPE_FACTION && IsGang(CarInfo[vehicleid][cOwnerID]))
					{	// ������ ���� (� ������������ �������� ������)
						SendClientMessage(playerid, COLOR_SAYING, "- �����������: ��� �� ����� ����� �����, �� ����� �� ������!");
                    	return ShowDialog(playerid, dialogid);
	                	//SetPVarInt(playerid, "painting_step", 2);
	                	//SetPVarInt(playerid, "repair_color_1", CarInfo[vehicleid][cColor1]);
					}
	                SetPVarInt(playerid, "painting_step", 1);
	                SetPVarInt(playerid, "repair_color_1", -1);
                	SetPVarInt(playerid, "repair_color_2", -1);
                	SendClientMessage(playerid, COLOR_WHITE, PREFIX_HINT "��� ��������� ����� �������� �� ����, ��� ������� ������� ������ "SCOLOR_HINT"BUY"SCOLOR_WHITE".");
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_HINT "��� ������ ������� "SCOLOR_HINT"ESC"SCOLOR_WHITE" ��� �� ������ "SCOLOR_HINT"CANCEL"SCOLOR_WHITE".");
				   	return ColorMenuShow(playerid);
				}
				case 7:
				{	//	����������� ������
					return ShowDialog(playerid, DMODE_TUNING);
				}
				case 8:
				{	//	������ ������
					price = GetPVarInt(playerid, "repair_all_price");
					type = 2;
	            }
	        }
	        if(!price)
			{
			    switch(random(3))
		        {
		            case 0: SendClientMessage(playerid, COLOR_SAYING, "- �����������: ��� ��������, ��� � ������ �� ������?");
		            case 1: SendClientMessage(playerid, COLOR_SAYING, "- �����������: ����� ��� ��������, ����� ����� ���������� ���� ��������?");
		            case 2: SendClientMessage(playerid, COLOR_SAYING, "- �����������: � ���� ��� � �������, ��� ���� �� ��������?");
		        }
                return ShowDialog(playerid, dialogid);
			}
	        if(MyGetPlayerMoney(playerid) < price)
	        {
	       		SendClientMessage(playerid, COLOR_SAYING, "- �����������: � ���� �� ������� �����!");
                return ShowDialog(playerid, dialogid);
			}
		   	MyGivePlayerMoney(playerid, -price);

		   	if(type == 0)
   			{
				//printf("panels - %d  doors - %d  lights - %d  tires - %d", Arr4<item>);
  				UpdateVehicleDamageStatus(vehicleid, Arr4<item>);
			}
			else if(type == 1)	MySetVehicleHealth(vehicleid, 999.0);
		   	else if(type == 2)	MyRepairVehicle(vehicleid);
	        PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
	        UpdateVehicleStatics(vehicleid);
	        switch(random(3))
	        {
	            case 0: SendClientMessage(playerid, COLOR_SAYING, "- �����������: ��� ������! �������� ��������, ���������?");
	            case 1: SendClientMessage(playerid, COLOR_SAYING, "- �����������: �������, ��������! ���-������ ���?");
	            case 2: SendClientMessage(playerid, COLOR_SAYING, "- �����������: ��� ��������! ����� ��� ���� �������?");
	        }
    		ShowDialog(playerid, dialogid);
		}
		case DMODE_TUNING:
		{
			if(response)
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				switch(listitem)
				{
					//	����
					case 0:	ShowDialog(playerid, dialogid);
					case 1..6:
					{
						if(CarInfo[vehicleid][cNeon] == listitem)
						{
						    RemoveNeons(vehicleid);
						    CarInfo[vehicleid][cNeon] = 0;
							PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
							return ShowDialog(playerid, dialogid);
						}
						if(GetPlayerCoins(playerid) < 30)
						{
							SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� �� ���������� �����.");
							return ShowDialog(playerid, dialogid);
						}
						CarInfo[vehicleid][cNeon] = listitem;
						AttachNeons(vehicleid, CarInfo[vehicleid][cNeon] - 1);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						GivePlayerCoins(playerid, -30);
					}
					case 7:// �����������
					{
						if(CarInfo[vehicleid][cFlash])
						{
						    SetVehicleFlasher(vehicleid, 0);
						    CarInfo[vehicleid][cFlash] = 0;
							PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
							return ShowDialog(playerid, dialogid);
						}
						if(GetPlayerCoins(playerid) < 50)
						{
							SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� �� ���������� �����.");
							return ShowDialog(playerid, dialogid);
						}
						CarInfo[vehicleid][cFlash] = 1;
						GivePlayerCoins(playerid, -50);
						PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_HINT "��� ��������� ������������ ����������� "SCOLOR_HINT"/flash"SCOLOR_WHITE".");
					}
					case 8:// ������� ������
					{
						if(IsAvailableVehicle(vehicleid, playerid) != VEH_AVAILABLE_OWNER)
						{
							SendClientMessage(playerid, COLOR_SAYING, "- �����������: ������ ����� ������ ������ ��������");
					        return ShowDialog(playerid, dialogid);
					    }
						ShowDialog(playerid, DMODE_CARPLATE);
					}
				}
				SendClientMessage(playerid, COLOR_SAYING, "- �����������: �������, ��������! ���-������ ���?");
				ShowDialog(playerid, dialogid);
			}
			else
			{
				ShowDialog(playerid, DMODE_REPAIR);
			}
		}
		case DMODE_CARPLATE:
		{
		    if(!response) return ShowDialog(playerid, DMODE_TUNING);
		    new vehicleid = GetPlayerVehicleID(playerid);
		    if(!vehicleid || GetPlayerState(playerid) != 2) return 1;
		    if(!(0 < strlen(inputtext) < 10) || !IsCorrectName(inputtext)) return ShowDialog(playerid, dialogid);
			if(GetPlayerCoins(playerid) < 50)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� �� ���������� �����.");
				return ShowDialog(playerid, dialogid);
			}
			GivePlayerCoins(playerid, -50);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			strput(CarInfo[vehicleid][cPlate], RusText(inputtext));
			SetVehicleNumberPlate(vehicleid, CarInfo[vehicleid][cPlate]);
			SendClientMessage(playerid, COLOR_SAYING, "- �����������: ����� �� ������ ������. ��� �������� ����� ��������� �����");
			ShowDialog(playerid, DMODE_REPAIR);
		}
		case DMODE_GAS:
		{
		    if(response)
			{
				new b = PickupedBiz[playerid];
		        if(b == INVALID_DATA || BizInfo[b][bType] != BUS_GAS_STATION)
		        {
		        	return GMError(playerid, "DMODE_GAS #0");
		        }
				if(listitem == 0) ShowDialog(playerid, DMODE_GAS_RULES); // ������� �����������
				else if(listitem == 1)
				{// ������ �������
				    new vehicleid = gLastVehicle[playerid];
				    if(vehicleid)
				    {
					    new Float:X, Float:Y, Float:Z;
					    GetVehiclePos(vehicleid, X, Y, Z);
						if(!IsPlayerInRangeOfPoint(playerid, 50.0, X, Y, Z))
						{
						    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���������� ��� �����, ������� �� ������ ���������.");
						    return ShowDialog(playerid, dialogid);
						}
						if(GetVehicleEngine(vehicleid))
						{
						    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��������� ������������� ���������� ������ ���� ��������.");
						    return ShowDialog(playerid, dialogid);
						}
						if(VehInfo[vehicleid][vWishFuel] == 0)
						{
						    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������� �������� ����� �������, ���������� ��� ���.");
						    return ShowDialog(playerid, dialogid);
						}
						new Float:maxfuel = float(GetVehicleMaxFuel(vehicleid));
						if(VehInfo[vehicleid][vFuel] + VehInfo[vehicleid][vWishFuel] > maxfuel)
						{
						    VehInfo[vehicleid][vWishFuel] = maxfuel - VehInfo[vehicleid][vFuel];
						}
						new Float:price = VehInfo[vehicleid][vWishFuel] * PRICE_FUEL;
						if(MyGetPlayerMoney(playerid) < price)
						{
						    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� �� ������� ����� �� ������ �������.");
						    return ShowDialog(playerid, dialogid);
						}
						BizSaleProds(b, floatround(price), floatround(VehInfo[vehicleid][vWishFuel]));
						VehInfo[vehicleid][vFuel] += VehInfo[vehicleid][vWishFuel];
						VehInfo[vehicleid][vWishFuel] = 0;
						MyGivePlayerMoney(playerid, -floatround(price));
						if(VehInfo[vehicleid][vDriver] >= 0)	IFace.Veh_Update(VehInfo[vehicleid][vDriver], 0);
						UpdateVehicleStatics(vehicleid);
						UpdateVehicleLabel(vehicleid);
						if(!random(2)) 	SendClientMessage(playerid, COLOR_SAYING, "- ������: ������ �������, ����� �� �������!");
						else 			SendClientMessage(playerid, COLOR_SAYING, "- ������: ��� ���������� ���������, ����� ��������!");
						ShowDialog(playerid, dialogid);
					}
				}
				else if(listitem == 2)
				{	// ������� ��������
					if(MyGetPlayerMoney(playerid) < 20)
					{
	                    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� �� ������� ����� ��� ������� ��������.");
	                    return ShowDialog(playerid, dialogid);
					}
					if(Inv.AddPlayerThing(playerid, THING_GASCAN, 1) == 0)
					{
						return ShowDialog(playerid, dialogid);
					}
					BizSaleProds(b, floatround(PRICE_FUEL), 15);
					MyGivePlayerMoney(playerid, -floatround(15 * PRICE_FUEL));
					ShowDialog(playerid, dialogid);
				}
			}
			else
			{
				gPickupTime[playerid] = 3;
				PickupedBiz[playerid] = INVALID_DATA;
			}
		}
		case DMODE_GAS_REFILL:
		{
			new vehicleid = GetPlayerVehicleID(playerid);
		    if(response && vehicleid)
		    {
				new inputfuel = strval(inputtext);
				if(!(0 < strlen(inputtext) < 10) || inputfuel <= 0)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
		            return ShowDialog(playerid, dialogid);
		        }
				if(VehInfo[vehicleid][vFuel] > GetVehicleMaxFuel(vehicleid))
				{
				    SendClientMessage(playerid, COLOR_SAYING, "- ���������: ��� ��� � ��� �������� �� �����, �� ������ ������ �������� �� �����.");
				    return ShowDialog(playerid, dialogid);
				}
				new maxfuel = GetVehicleMaxFuel(vehicleid) - floatround(VehInfo[vehicleid][vFuel]);
				if(inputfuel > maxfuel)
				{
				    if(inputfuel >= 1000.0) SendClientMessage(playerid, COLOR_SAYING, "- ���������: ��� �� ������������ ���� ��������, ���?");
				    else
				    {
					    if(!random(2)) SendClientMessage(playerid, COLOR_SAYING, "- ���������: ���������� ��, ������� ������!");
						else SendClientMessage(playerid, COLOR_SAYING, "- ���������: ���, ����! ������� ���� �� ����������!");
					}
					return ShowDialog(playerid, dialogid);
				}
				if(inputfuel == maxfuel) format(string, 128, "- ���������: ������ ��� ��� ������! ��������� �� ����� ��� ������.");
				else format(string, 128, "- ���������: �������� �� %d ������, ���� ��������� � �����.", floatround(inputfuel));
				VehInfo[vehicleid][vWishFuel] = float(inputfuel);
				SendClientMessage(playerid, COLOR_SAYING, string);
		    }
		}
		case DMODE_GAS_RULES:
		{
		    if(response) gPickupTime[playerid] = 3;
			else ShowDialog(playerid, DMODE_GAS);
		}
		case DMODE_JOBLIST:
		{
		    if(response)
			{
				if(IsLegalJob(Job.GetPlayerJob(playerid)))
				{	// ���������� � ������
					if(!listitem)
					{
						if(Job.DismissPlayer(playerid))
						{
							SendClientMessage(playerid, COLOR_YELLOW, "�� ���� ������� � ������ �� ������������ �������");
						}
					}
					else
					{
						ShowDialog(playerid, dialogid);
					}
				}
				else
				{
				    if(PlayerInfo[playerid][pFaction] > 0)
				    {
				    	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������� �� ����� ������������ �� ������.");
				        return ShowDialog(playerid, dialogid);
				    }
				    //if(Job.GetPlayerJob(playerid) > 0)
				    //{
				    //    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��� ��������� ���-��, ������� ���������.");
				    //    return ShowDialog(playerid, dialogid);
				    //}
					switch(listitem)
					{
						case 0://	�������
						{
							if(PlayerInfo[playerid][pLevel] < Jobs[JOB_TAXI][J_LEVEL])
					        {
						        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������ �������� ������ � 2 ������.");
						        return ShowDialog(playerid, dialogid);
					        }
							if(AskPlayer(INVALID_PLAYER_ID, playerid, ASK_INVITE_JOB, 30, JOB_TAXI))
							{
								//AskAmount[playerid] = JOB_TAXI;
								SendClientMessage(playerid, COLOR_WHITE, "�� ��������� ���������� {44B2FF}��������� "ASK_CONFIRM_INFO);
								if(Job.GetPlayerJob(playerid) != JOB_NONE) SendClientMessage(playerid, COLOR_LIGHTRED, "���� �������� ������ ���������, ���� �� �����������!");
							}
					        else
					        {
					        	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������� ��� ��������� ������� ������.");
					        }
						}
					    case 1:// �������� ��������
					    {
					        if(PlayerInfo[playerid][pLevel] < Jobs[JOB_BUSDRIVER][J_LEVEL])
					        {
						        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������ �������� ������ � 2 ������.");
						        return ShowDialog(playerid, dialogid);
					        }
							if(AskPlayer(INVALID_PLAYER_ID, playerid, ASK_INVITE_JOB, 30, JOB_BUSDRIVER))
							{
								//AskAmount[playerid] = JOB_BUSDRIVER;
								SendClientMessage(playerid, COLOR_WHITE, "�� ��������� ���������� {44B2FF}��������� �������� "ASK_CONFIRM_INFO);
								if(Job.GetPlayerJob(playerid) != JOB_NONE) SendClientMessage(playerid, COLOR_LIGHTRED, "���� �������� ������ ���������, ���� �� �����������!");
							}
					        else
					        {
					        	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������� ��� ��������� ������� ������.");
					        }
					    }
					    case 2:	// ������������
					    {
					        if(PlayerInfo[playerid][pLevel] < Jobs[JOB_TRUCKER][J_LEVEL])
					        {
						        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������ �������� ������ � 3 ������.");
						        return ShowDialog(playerid, dialogid);
					        }
					        if(AskPlayer(INVALID_PLAYER_ID, playerid, ASK_INVITE_JOB, 30, JOB_TRUCKER))
					        {
								//AskAmount[playerid] = JOB_TRUCKER;
								SendClientMessage(playerid, COLOR_WHITE, "�� ��������� ���������� {44B2FF}�������������� "ASK_CONFIRM_INFO);
								if(Job.GetPlayerJob(playerid) != JOB_NONE) SendClientMessage(playerid, COLOR_LIGHTRED, "���� �������� ������ ���������, ���� �� �����������!");
							}
					        else
					        {
					        	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������� ��� ��������� ������� ������.");
					        }
					    }
					    case 3:	//	�������
					    {
					    	if(PlayerInfo[playerid][pLevel] < Jobs[JOB_MECHANIC][J_LEVEL])
					        {
						        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������ �������� ������ � 4 ������.");
						        return ShowDialog(playerid, dialogid);
					        }
					        if(AskPlayer(INVALID_PLAYER_ID, playerid, ASK_INVITE_JOB, 30, JOB_MECHANIC))
					        {
								//AskAmount[playerid] = JOB_MECHANIC;
								SendClientMessage(playerid, COLOR_WHITE, "�� ��������� ���������� {44B2FF}��������� "ASK_CONFIRM_INFO);
								if(Job.GetPlayerJob(playerid) != JOB_NONE) SendClientMessage(playerid, COLOR_LIGHTRED, "���� �������� ������ ���������, ���� �� �����������!");
							}
					        else
					        {
					        	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������� ��� ��������� ������� ������.");
					        }
					    }
					}
				}
			}
		}
		case DMODE_AUTOSCHOOL:
		{
			if(response)
			{
	            if(!PlayerInfo[playerid][pASElement])
				{	// ������� ����
					if(MyGetPlayerMoney(playerid) < PRICE_AUTOSCHOOL)
					{
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �� ������� ����� ��� ������ ���������.");
					}
					MyGivePlayerMoney(playerid, -PRICE_AUTOSCHOOL);
					PlayerInfo[playerid][pASElement] |= 0x1;
					UpdatePlayerBitData(playerid, "as_element", PlayerInfo[playerid][pASElement]);
					SendClientMessage(playerid, COLOR_SAYING, "- ����������: �������, ������ ��� ���������� ������ �������� �� ��������...");
					SendClientMessage(playerid, COLOR_SAYING, "- ����������: �� ������ ������ � ��������� �� � ����� �����, ������� �� ����������, �����!");
					ShowDialog(playerid, dialogid);
				}
				else
				{	// ���������� ���������
					if(listitem == 0)	ShowDialog(playerid, DMODE_BUYELEMENT);
					else if(1 <= listitem <= sizeof(AS_Mission))
					{	// ������ ���������� ��������
						if((PlayerInfo[playerid][pASElement] >> listitem) & 1)
						{
							ShowDialog(playerid, dialogid);
		                    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��� ��������� ������ �������.");
						}
						else
						{
						    StartASElement(playerid, listitem - 1);
						}
					}
					else if(!PlayerInfo[playerid][pCarLic])
					{	// �������� �����
						PlayerInfo[playerid][pCarLic] = 1;
						UpdatePlayerData(playerid, "carlic", PlayerInfo[playerid][pCarLic]);
						SendClientMessage(playerid, COLOR_GREEN, "����������: ����������, �� ������ ���� ��������� � ��������� ������, ��� ���� �����!");
						if(mission_id[playerid] == MIS_GET_LICENSE)
						{
							StoryMissionComplete(playerid, MIS_SOURCE_TRAINING, 0, 0);
						}
					#if defined _player_achieve_included	
						GivePlayerAchieve(playerid, ACHIEVE_DRIVER);	//	���������� '��������'
					#endif	
						/*if(gAchieves[playerid][ACHIEVE_DRIVER] == 0)
						{

						}
						else
						{
							ShowPlayerHint(playerid, "�� ��������:___________________~n~~g~- �������� �� ��������");
							SuccesAnim(playerid);
							PlayerPlaySound(playerid, 36205, 0.0, 0.0, 0.0);
						}*/
					}
				}
			}
		}
		case DMODE_SHOOTING:
		{
			if(response == 0)
			{
				return true;
			}
			if(PlayerInfo[playerid][pShooting] == 0)
			{
				if(MyGetPlayerMoney(playerid) < 700)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �� ������� ����� ��� ������.");
                    return ShowDialog(playerid, dialogid);
				}
				PlayerInfo[playerid][pShooting] = 1;
				MyGivePlayerMoney(playerid, -500);
				ShowDialog(playerid, dialogid);
			}
			else
			{
				if(listitem == 0)
				{
					ShowDialog(playerid, DMODE_SHOOTING_INFO);
				}
				else if(listitem == 1)
				{
					if(0 < PlayerInfo[playerid][pShooting] <= 3)
				 	{
				 	    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 0);	// ������� ��������� ��� � ����� ��������
						MySetPlayerPosFade(playerid, FT_TIR, 293.7, -24.6, 1001.5, 0.0, false, GetPlayerInterior(playerid), (GetPlayerVirtualWorld(playerid) + playerid + 1000));
				 		PlayerBusy{playerid} = true;
				 	}
				}
			 	else if(listitem == 2)
			 	{
			 		if(GetPlayerCoins(playerid) < CoinForShooting)
			 		{
			 			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� �����.");
			 			return ShowDialog(playerid, dialogid);
			 		}
			 		GivePlayerCoins(playerid, -CoinForShooting);
			 		PlayerInfo[playerid][pShooting] = 4;
					SuccesAnim(playerid);
					PlayerPlaySound(playerid, 36205, 0.0, 0.0, 0.0);
					SendClientMessage(playerid, COLOR_GREEN, "�����������, ������ ������������� � ����������� ������� ��� ������ � ��������� �������� �� ������!");
			 	}
			}
		}
		case DMODE_SHOOTING_INFO:
		{
			return ShowDialog(playerid, DMODE_SHOOTING);
		}
		case DMODE_BUYELEMENT:
		{
		    if(response)
		    {
				if(!strlen(inputtext) || (strcmp(inputtext, "skip", true) && strcmp(inputtext, "����������", true)))
					return ShowDialog(playerid, dialogid);
				if(GetPlayerCoins(playerid) < 40)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �� ������� �����.");
				}
				else
				{
					GivePlayerCoins(playerid, -40);
					PlayerInfo[playerid][pASElement] = 0xFF;
					UpdatePlayerBitData(playerid, "as_element", PlayerInfo[playerid][pASElement]);
					SendClientMessage(playerid, COLOR_GREEN, "����������: ����������, �� ����� ��� ��������!");
				}
		    }
		    ShowDialog(playerid, DMODE_AUTOSCHOOL);
		}
		case DMODE_REACTION:
		{
			new pursuit = GetPVarInt(playerid, "Player:Reaction:PursuitMenu");
		   	DeletePVar(playerid, "Player:Reaction:PursuitMenu");
		    if(response)
		    {
		    	new count = 0;
		    	new vehicleid = GetPlayerVehicleID(playerid);
		    	new targetid = gTargetid[playerid];
		    	valstr(string, targetid);
		    	if(PM_Type[playerid] == 10 && PM_Place[playerid] == targetid)
		    	{
		    		if(pursuit != 1)	return true;
		    		if(PursuitStatus[targetid] == PS_WAIT || PursuitStatus[targetid] == PS_OUT_COMPLETE)
		    		{
		    			if(listitem == 0)
						{
							if(PlayerInfo[targetid][pNextFriskTime] > gettime())
							{
								ShowDialog(playerid, dialogid);
							}
							else
							{
								return callcmd::frisk(playerid, string);
							}
						}
						else if(listitem == 1)
						{
							if(PursuitIllegalItem[targetid])
							{
								mysql_format(g_SQL, string, sizeof(string), "SELECT `id`, `thing` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d'", PlayerInfo[targetid][pUserID], _:TAB_INVENTORY);
						    	new Cache:result = mysql_query(g_SQL, string);
						    	for(new i = 0, id, thing; i < cache_num_rows(); i++)
								{
									cache_get_value_name_int(i, "id", id);
									cache_get_value_name_int(i, "thing", thing);
									new legally = GetThingLegally(thing);
									if(!legally)	
									{
										Inv.DeleteItem(id);
						    		}
						    		else if(thing == THING_WEAPON)
						    		{
						    			if(PlayerInfo[targetid][pGunLic] == 0)
						    			{
						    				Inv.DeleteItem(id);
						    			}
						    		}
						    	}
						    	cache_delete(result);
						    	//	������
						    	/*if(PlayerInfo[targetid][pGunLic] == 0)
						    	{
						    		for(new s = 2; s < 13; s++)
						    		{
						    			if(!MyGetPlayerWeaponID(playerid, s) || 9 <= s <= 11) continue;
	    								MySetPlayerWeapon(targetid, s, 0);
						    		}
						    		MyUpdatePlayerWeapon(targetid);
						    	}*/
						    	PursuitIllegalItem[targetid] = false;
						    	format(string, sizeof(string), "������� ����������� �������� � %s'�.", ReturnPlayerName(targetid));
						    	PlayerAction(playerid, string);
						    	SendFormatMessage(targetid, COLOR_DBLUE, string, "%s %s ����� � ��� ��� ����������� ��������", GetPlayerRank(playerid), ReturnPlayerName(playerid));
					    	}
					    	ShowDialog(playerid, dialogid);
						}
						else if(listitem == 2)
						{
							if(0 < GetPlayerWantedLevel(targetid) < 4)
							{
								new wl = GetPlayerWantedLevel(targetid);
								new finecash = wl * FINE_PER_WANTED;
								if(AskPlayer(playerid, targetid, ASK_POLICE_FINE, 30, finecash))
								{
									//AskAmount[targetid] = finecash;
									PursuitCount[targetid] = 40;	//	������� ������ ������
									SendFormatMessage(playerid, COLOR_DBLUE, string, "���������� %s �������� ��������� �� �������, �������� ������!", ReturnPlayerName(targetid));
									SendFormatMessage(targetid, COLOR_DBLUE, string, "%s %s ������� ��� ����� �� %d$. ��������? "ASK_CONFIRM_INFO, GetPlayerRank(playerid), ReturnPlayerName(playerid), finecash);
								}
								else
								{
									SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ������ ���� �� �������� ������, ���������.");
									ShowDialog(playerid, dialogid);
								}
							}
							else
							{
								CancelPlayerPursuit(targetid, 1);
								SendFormatMessage(playerid, COLOR_DBLUE, string, "� �������������� %s �� ���������� ��������������", ReturnPlayerName(targetid));
								SendFormatMessage(targetid, COLOR_DBLUE, string, "%s %s �� ����� ������� ��������������, �� ��������", GetPlayerRank(playerid), ReturnPlayerName(playerid));
							}
						}
		    		}
					else
					{
						gTargetid[playerid] = INVALID_PLAYER_ID;
					}
		    	}
		    	else if(pursuit == 0)
		    	{
	    		 	if(count++ == listitem)
	    		 	{
				    	// �������������
					    return callcmd::hi(playerid, string);
				    }
				    if(count++ == listitem)
				    {
				    	//	�������� ���������
				    	return callcmd::showpass(playerid, string);
				    }
				    if(count++ == listitem)
				    {
				    	// �������� ������
				    	return ShowDialog(playerid, DMODE_PAY_SUMM);
				    }

					if(PlayerInfo[playerid][pFaction] == F_POLICE && IsPoliceDuty(playerid) && GetPlayerState(targetid) != PLAYER_STATE_WASTED && count++ == listitem)
					{
						if(!StartPursuit(playerid, targetid))
						{
							return ShowDialog(playerid, dialogid);
						}
					}
					else if(PlayerInfo[playerid][pFaction] == F_NEWS && PlayerInfo[playerid][pRank] >= 3
						&& (GetPlayerInterior(playerid) == 18 || (vehicleid > 0 && CarInfo[vehicleid][cType] == C_TYPE_FACTION && CarInfo[vehicleid][cOwnerID] == F_NEWS))
						&& (TalkingLive[playerid] == INVALID_PLAYER_ID || (TalkingLive[playerid] != INVALID_PLAYER_ID && TalkingLive[playerid] == gTargetid[playerid]))
						&& count++ == listitem)
					{	//	����� ��������
					   	return callcmd::live(playerid, string);
					}

					if(GetPVarInt(gTargetid[playerid], "Player:JobPartner") == PlayerInfo[playerid][pUserID] && count++ == listitem)
					{
						SendFormatMessage(gTargetid[playerid], COLOR_LIGHTRED, string, "%s �������� �������� � ����",  ReturnPlayerName(playerid));
						SendFormatMessage(playerid, COLOR_LIGHTRED, string, "�� ��������� �������� � %s'��",  ReturnPlayerName(gTargetid[playerid]));
						DeletePVar(gTargetid[playerid], "Player:JobPartner");
					}
					else
					{
						new rentcar = GetPVarInt(playerid, "RentCar");
						if(rentcar > 0 && DeliveryVehLoadCount[rentcar] > 0 && count++ == listitem)
						{
							if(AskPlayer(playerid, gTargetid[playerid], ASK_JOB_PARTNER))
							{
								SendFormatMessage(gTargetid[playerid], COLOR_WHITE, string, "%s ���������� ��� ���������� ������ "ASK_CONFIRM_INFO,  ReturnPlayerName(playerid));
								SendFormatMessage(playerid, COLOR_WHITE, string, "�� ���������� %s ���������� ������", ReturnPlayerName(gTargetid[playerid]));
							}
							else
							{
								return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ������ ���� �� �������� ������, ���������� �����.");
							}
						}
					}

					if(GetNearRing(playerid) != (-1) && count++ == listitem)
					{
						return callcmd::box(playerid, string);
					}

					// ��� ������� � �����
					if(PlayerInfo[playerid][pFaction] > 0 && PlayerInfo[playerid][pRank] >= GetRankMax(PlayerInfo[playerid][pFaction]) - 1)
					{
						if(PlayerInfo[ gTargetid[playerid] ][pFaction] == F_NONE && count++ == listitem)
						{//	������� � �����������
						    return callcmd::invite(playerid, string);
						}
						else if(PlayerInfo[playerid][pFaction] == PlayerInfo[ gTargetid[playerid] ][pFaction] && PlayerInfo[playerid][pRank] > PlayerInfo[ gTargetid[playerid] ][pRank])
						{
							if(count++ == listitem)
							{	//	������� �� �����������
								return callcmd::uninvite(playerid, string);
							}
						    if(count++ == listitem)	{
						    	return callcmd::giverank(playerid, string);
						    }
						}
					}
		    	}
		    }
		    else
		    {
		    	gTargetid[playerid] = INVALID_PLAYER_ID;
		    }
		}
		case DMODE_PAY_SUMM:
		{
		    if(!response)
		    {
		        return ShowDialog(playerid, DMODE_REACTION);
		    }
			format(string, 128, "%d %d", gTargetid[playerid], strval(inputtext));
			callcmd::pay(playerid, string);
		}
		case DMODE_HOTEL:
		{
		    if(response)
		    {
			    if(PlayerInfo[playerid][pRent] < 0)
				{
					if(listitem == 0)
					{
						ShowDialog(playerid, DMODE_EX_HOTEL);
					}
					else if(listitem == 1)
					{
						ShowDialog(playerid, DMODE_HOTEL);
					}
					else if(listitem == 2)
					{
						PlayerInfo[playerid][pRent]--;// = {-1, -2, -3}
						if(PlayerInfo[playerid][pRent] < (-3))
						{
							PlayerInfo[playerid][pRent] = -1;
						}
						SendClientMessage(playerid, COLOR_GREEN, "[������]: ��� ���������� � ������ �����!");
						MyGivePlayerMoney(playerid, -15);
					}
					else if(listitem == 3)
					{
						PlayerInfo[playerid][pRent] = 0;
				    	PlayerInfo[playerid][pPaymentDays] = 0;
						SendClientMessage(playerid, COLOR_GREEN, "[������]: ��� ����� � ����� ������� � ����� �����!");
					}
				}
				else
				{
					new days = strval(inputtext);
					if(!(0 < strlen(inputtext) < 10) || days <= 0)
			        {
			            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
			            return ShowDialog(playerid, dialogid);
			        }
					new price = HOTEL_COST * days;
					if(MyGetPlayerMoney(playerid) < price)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� ��������.");
						return ShowDialog(playerid, dialogid);
					}
					if(days > 30)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������ ���������� ���� ��� ������ - 30.");
						return ShowDialog(playerid, dialogid);
					}
					MyGivePlayerMoney(playerid, -price);
    				PlayerInfo[playerid][pRent] = -1 - random(3);// = {-1, -2, -3}
    				PlayerInfo[playerid][pPaymentDays] = days;
    				PlayerInfo[playerid][pSpawn] = SPAWN_HOUSE;
					SendFormatMessage(playerid, COLOR_GREEN, string, "[������]: �� ������� ���������� ����� �� %d ����, ��������� ����������!", days);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "[Spawn]: ������ �� ������ ��������� � ������ �����");
					if(mission_id[playerid] == MIS_HOTEL)
					{
						new hotel_roow = PlayerInfo[playerid][pRent] * (-1) - 1; // = {0, 1, 2}
						SetPVarInt(playerid, "Mission:CompleteMission", MIS_HOTEL);
						MySetPlayerPosFade(playerid, FT_NONE, Arr4<HotelRooms[hotel_roow][H_POS]>, true, HotelRooms[hotel_roow][H_INT], VW_HOUSE + playerid);
					}
				}
				UpdatePlayerHouseMapIcon(playerid);
		    }
		}
		case DMODE_EX_HOTEL:
		{
			if(response && PlayerInfo[playerid][pRent] < 0)
		    {
		    	new days = strval(inputtext);
		        if(!(0 < strlen(inputtext) < 10) || days <= 0)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
		            return ShowDialog(playerid, dialogid);
		        }
				new price = HOTEL_COST * days;
				if(MyGetPlayerMoney(playerid) < price)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� ��������.");
					return ShowDialog(playerid, dialogid);
				}
				MyGivePlayerMoney(playerid, -price);
				PlayerInfo[playerid][pPaymentDays] += days;
				SendFormatMessage(playerid, COLOR_GREEN, string, "[������]: �� ������� �������� ������ ������ �� %d ����, ��������� ����������!", days);
		    }
		    else ShowDialog(playerid, DMODE_HOTEL);
		}
		case DMODE_ATM:
		{
			if(response)
			{
				new item = 0;
				if(listitem == item++)
				{
					openWithATM[playerid] = true;
					SetPVarInt(playerid, "Bank:Type", 0);
			        ShowDialog(playerid, DMODE_BANK_ACTION); // ���������� ����
				}
				else if(PlayerInfo[playerid][pPhoneNumber] && listitem == item++)
				{
					Dialog_Show(playerid, Dialog:Phone_Pay);
				}
				else ShowDialog(playerid, dialogid);
			}
			else
			{
				openWithATM[playerid] = false;
				DeletePVar(playerid, "Bank:Type");
				ClearAnimations(playerid);
			}
		}
		case DMODE_BANK:
		{
			if(response)
			{
				new item = 0;
				if(listitem == item++)
				{
					SetPVarInt(playerid, "Bank:Type", 0);
			        ShowDialog(playerid, DMODE_BANK_ACTION); // ���������� ����
				}

				new b = FoundBiz(GetPlayerBiz(playerid));
				if(b != (-1))
				{
					if(listitem == item++)
					{
						SetPVarInt(playerid, "Bank:Type", 1);
						ShowDialog(playerid, DMODE_BANK_ACTION);
					}
					else if(listitem == item++)
					{
						SetPVarInt(playerid, "Bank:Type", 1);
						ShowDialog(playerid, DMODE_PROPERTY_PAY);
					}
				}

				new h = FoundHouse(GetPlayerHouse(playerid));
				if(h != (-1))
				{
					if(listitem == item++)
					{
						SetPVarInt(playerid, "Bank:Type", 2);
						ShowDialog(playerid, DMODE_PROPERTY_PAY);
					}
				}

				if(PlayerInfo[playerid][pPhoneNumber] && listitem == item++)
				{
					Dialog_Show(playerid, Dialog:Phone_Pay);	// ������ ��������
				}
				else ShowDialog(playerid, dialogid);
			}
			else
			{
				DeletePVar(playerid, "Bank:Type");
			}
		}
		case DMODE_BANK_ACTION:
		{
		    if(response)
			{
			    switch(listitem)
			    {
			        case 2: ShowDialog(playerid, DMODE_BANK_TAKE); // ����� �� �����
			        case 3: ShowDialog(playerid, DMODE_BANK_GIVE); // �������� �� ����
			        default: ShowDialog(playerid, dialogid);
			    }
			}
			else
			{
				if(openWithATM[playerid])	ShowDialog(playerid, DMODE_ATM);
				else 						ShowDialog(playerid, DMODE_BANK);
			}
		}
		case DMODE_BANK_TAKE:
		{
		    if(response)
		    {
		        new const money = strval(inputtext);
		        if(!(0 < strlen(inputtext) < 10) || money <= 0)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
		            return ShowDialog(playerid, dialogid);
		        }
		        new type = GetPVarInt(playerid, "Bank:Type");
		        new Float:oldbank, Float:newbank;
		        new Float:proc = float(money) / 100;
		        if(type == 0)	//	������ ����
				{
					if(PlayerInfo[playerid][pBank] < money)
			        {
			            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ����� ������������ ����� �� ����� �������.");
			            return ShowDialog(playerid, dialogid);
			        }
			        oldbank = PlayerInfo[playerid][pBank];
			        GivePlayerBank(playerid, -(float(money) + proc));
			        newbank = PlayerInfo[playerid][pBank];
				}
				else if(type == 1)	//	���� �������
				{
					new b = FoundBiz(GetPlayerBiz(playerid));
					if(b == (-1))	return ShowDialog(playerid, DMODE_ATM);
					if(BizInfo[b][bBank] < float(money))
			        {
			            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ����� ������������ ����� �� ����� �������.");
			            return ShowDialog(playerid, dialogid);
			        }
			        oldbank = BizInfo[b][bBank];
			        BizInfo[b][bBank] -= (float(money) + proc);
			        newbank = BizInfo[b][bBank];
			        SaveBiz(b);
				}
		        MyGivePlayerMoney(playerid, money);

				SendClientMessage(playerid, COLOR_GREEN, "|___ ��������� �� ����� ___|");
				format(string, sizeof(string), "  ������ ������: $%.2f", oldbank);
				SendClientMessage(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "  ����������: -%d$.00", money);
				SendClientMessage(playerid, COLOR_GRAD2, string);
				format(string, sizeof(string), "  ��������: $%.2f (1%s)", proc, "%%");
				SendClientMessage(playerid, COLOR_GRAD2, string);
				format(string, sizeof(string), "  ����� ������: $%.2f", newbank);
				SendClientMessage(playerid, COLOR_WHITE, string);
				SendClientMessage(playerid, COLOR_GREEN, "|-----------------------------------------------|");
		    }
		    if(openWithATM[playerid])	ShowDialog(playerid, DMODE_ATM);
		    else 						ShowDialog(playerid, DMODE_BANK);
		}
		case DMODE_BANK_GIVE:
		{
		    if(response)
		    {
		        new const money = strval(inputtext);
		        if(!(0 < strlen(inputtext) < 10) || money <= 0)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
		            return ShowDialog(playerid, dialogid);
		        }
		        if(MyGetPlayerMoney(playerid) < money)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ ����� �� ����� �������.");
		            return ShowDialog(playerid, dialogid);
		        }
		        new type = GetPVarInt(playerid, "Bank:Type");
		        new Float:oldbank, Float:newbank;
		        if(type == 0)	//	������ ����
				{
			        oldbank = PlayerInfo[playerid][pBank];
			        GivePlayerBank(playerid, money);
			        newbank = PlayerInfo[playerid][pBank];
				}
				else if(type == 1)	//	���� �������
				{
					new b = FoundBiz(GetPlayerBiz(playerid));
					if(b == (-1))	return ShowDialog(playerid, DMODE_ATM);
			        oldbank = BizInfo[b][bBank];
			        BizInfo[b][bBank] += float(money);
			        newbank = BizInfo[b][bBank];
			        SaveBiz(b);
				}
				MyGivePlayerMoney(playerid, -money);

				SendClientMessage(playerid, COLOR_GREEN, "|___ ��������� �� ����� ___|");
				format(string, sizeof(string), "  ������ ������: $%.2f", oldbank);
				SendClientMessage(playerid, COLOR_WHITE, string);
				format(string, sizeof(string), "  ���������: +%d$.00", money);
				SendClientMessage(playerid, COLOR_GRAD2, string);
				format(string, sizeof(string), "  ��������: $0.00 (0%s)", "%%");
				SendClientMessage(playerid, COLOR_GRAD2, string);
				format(string, sizeof(string), "  ����� ������: $%.2f", newbank);
				SendClientMessage(playerid, COLOR_WHITE, string);
				SendClientMessage(playerid, COLOR_GREEN, "|-----------------------------------------------|");
		    }
		    if(openWithATM[playerid])	ShowDialog(playerid, DMODE_ATM);
		    else 						ShowDialog(playerid, DMODE_BANK);
		}
		case DMODE_PROPERTY_PAY:
		{
			if(response)
			{
				new days = strval(inputtext);
				if(!(0 < strlen(inputtext) < 10) || days <= 0)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
		            return ShowDialog(playerid, dialogid);
		        }
				new type = GetPVarInt(playerid, "Bank:Type");
				new cost = 0;
		        if(type == 1)	//	���� �������
				{
					cost = TAX_BIZ * days;
					if(MyGetPlayerMoney(playerid) < cost)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� ��������.");
						return ShowDialog(playerid, dialogid);
					}

					new b = FoundBiz(GetPlayerBiz(playerid));
					if(b == (-1))	return ShowDialog(playerid, DMODE_BANK);
					if(BizInfo[b][bPaymentDays] + days > 30)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������ ���������� ��������� ���� - 30.");
						return ShowDialog(playerid, dialogid);
					}
					BizInfo[b][bPaymentDays] += days;
			        SaveBiz(b);
				}
				if(type == 2)	//	���� ����
				{
					cost = TAX_HOUSE * days;
					if(MyGetPlayerMoney(playerid) < cost)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� ��������.");
						return ShowDialog(playerid, dialogid);
					}

					new h = FoundHouse(GetPlayerHouse(playerid));
					if(h == (-1))	return ShowDialog(playerid, DMODE_BANK);
					if(HouseInfo[h][hPaymentDays] + days > 30)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������ ���������� ��������� ���� - 30.");
						return ShowDialog(playerid, dialogid);
					}
					HouseInfo[h][hPaymentDays] += days;
					SaveHouse(h);
				}
				SendClientMessage(playerid, COLOR_GREEN, "|___ ��������� �� ����� ___|");
				SendFormatMessage(playerid, COLOR_WHITE, string, "  ���������: +%d.00$", cost);
				SendFormatMessage(playerid, COLOR_GRAD2, string, "  ��������: %d ����", days);
				MyGivePlayerMoney(playerid, -cost);
				ShowDialog(playerid, dialogid);
			}
			else ShowDialog(playerid, DMODE_BANK);
		}
		case DMODE_FINEPARK:
		{
		    if(response)
		    {
			    if(MyGetPlayerMoney(playerid) < 500)
			    {
				    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� �� ������� �����. ����� ������ ����� $500.");
				    return 1;
			    }
			    if(FineparkVehicle != 0)
			    {
				    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���������, ���� �����-������� �����������.");
				    return 1;
			    }
			    MyGivePlayerMoney(playerid, -500);

			    // ���������
				mysql_format(g_SQL, string, sizeof(string), "SELECT * FROM `cars` WHERE `type` = 1 AND `fine_park` > 0 AND `ownerid` = '%d' LIMIT 1", PlayerInfo[playerid][pUserID]);
				new Cache:result = mysql_query(g_SQL, string);
				if(!cache_num_rows())
				{
				    cache_delete(result);
				    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ����� ������� ��� �� ����� ����� ������.");
				}
				new Float:Health;
		        new id, modelid, color1, color2;
		        cache_get_value_index_int(0, 0, id);
		       	cache_get_value_index_int(0, 3, modelid);
		        cache_get_value_index_int(0, 8, color1);
		        cache_get_value_index_int(0, 9, color2);
		        new Panels, Doors, Lights, Tires;// Float:Health;
		        new vehid = MyCreateVehicle(modelid, 1576.9026, -1608.4280, 13.5, 180.0, color1, color2);

				mysql_format(g_SQL, string, sizeof(string), "UPDATE `cars` SET `fine_park` = '0' WHERE `id` = '%d'", id);
				mysql_query_ex(string);

				// ������ � ������
				CarInfo[vehid][cID] = id;
				cache_get_value_index_int(0, 1, CarInfo[vehid][cType]);
				cache_get_value_index_int(0, 2, CarInfo[vehid][cOwnerID]);
				CarInfo[vehid][cModel] = modelid;
				cache_get_value_index_float(0, 4, CarInfo[vehid][cX]);
				cache_get_value_index_float(0, 5, CarInfo[vehid][cY]);
				cache_get_value_index_float(0, 6, CarInfo[vehid][cZ]);
				cache_get_value_index_float(0, 7, CarInfo[vehid][cA]);
				CarInfo[vehid][cColor1] = color1;
				CarInfo[vehid][cColor2] = color2;
				cache_get_value_index(0, 10, CarInfo[vehid][cPlate], 10);
				cache_get_value_index_int(0, 11, CarInfo[vehid][cPaintJob]);
				cache_get_value_index_int(0, 12, CarInfo[vehid][cSpoiler]);
				cache_get_value_index_int(0, 13, CarInfo[vehid][cHood]);
				cache_get_value_index_int(0, 14, CarInfo[vehid][cRoof]);
				cache_get_value_index_int(0, 15, CarInfo[vehid][cSideskirt]);
				cache_get_value_index_int(0, 16, CarInfo[vehid][cNitro]);
				cache_get_value_index_int(0, 17, CarInfo[vehid][cLamps]);
				cache_get_value_index_int(0, 18, CarInfo[vehid][cExhaust]);
				cache_get_value_index_int(0, 19, CarInfo[vehid][cWheels]);
				cache_get_value_index_int(0, 20, CarInfo[vehid][cHydraulics]);
				cache_get_value_index_int(0, 21, CarInfo[vehid][cFrontBumper]);
				cache_get_value_index_int(0, 22, CarInfo[vehid][cRearBumper]);
				cache_get_value_index_int(0, 23, CarInfo[vehid][cVentR]);
				cache_get_value_index_int(0, 24, CarInfo[vehid][cVentL]);
				cache_get_value_index_float(0, 25, CarInfo[vehid][cMileage]);
				cache_get_value_index_int(0, 26, Panels);
				cache_get_value_index_int(0, 27, Doors);
				cache_get_value_index_int(0, 28, Lights);
				cache_get_value_index_int(0, 29, Tires);
				//cache_get_value_index_float(0, 30, Health);
				//cache_get_value_index_float(0, 31, VehInfo[vehid][vFuel]);
				VehInfo[vehid][vFuel] = 10.0;
				VehInfo[vehid][vLocked] = 0;
				FineparkVehicle = vehid;

				// ������ ����������
				SetVehicleNumberPlate(vehid, CarInfo[vehid][cPlate]);
				MySetVehicleToRespawn(vehid);// -> OnVehicleSpawn
				UpdateVehicleDamageStatus(vehid, Panels, Doors, Lights, Tires);
				if(Health < 400.0) Health = 400.0;
				MySetVehicleHealth(vehid, Health);
				if(CarInfo[vehid][cNeon])	AttachNeons(vehid, CarInfo[vehid][cNeon] - 1);
				SendClientMessage(playerid, COLOR_DBLUE, "* �����-�������: {FFFFFF}�������� ��������� �� 60 ������, ����� ��� ����� ���������");
			}
		    gPickupTime[playerid] = 3;
		}
		case DMODE_GPS:
		{
			if(response)
			{
				if(IsPlayerActiveGPS(playerid))
				{
					if(listitem == 0)
					{
						HidePlayerGPSPoint(playerid);
						return SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "��������� ��������");
					}
					else listitem--;
				}
				switch(listitem)
				{
					case 0:	//	������ �����
					{
						strcat(string, ""MAIN_COLOR"� {FFFFFF}����������� �������\n\
							"MAIN_COLOR"� {FFFFFF}����� ���-�������\n\
							"MAIN_COLOR"� {FFFFFF}���������\n\
							"MAIN_COLOR"� {FFFFFF}����������� ����\n\
							"MAIN_COLOR"� {FFFFFF}��������\n\
							"MAIN_COLOR"� {FFFFFF}����� Jefferson");
						MyShowPlayerDialog(playerid, DMODE_GPS_MAIN, DIALOG_STYLE_LIST, "��������� - ������ �����", string, "�������", "�����", 0);
					}
					case 1:	//	����������
					{
						strcat(string, ""MAIN_COLOR"� {FFFFFF}�������� �����\n\
						"MAIN_COLOR"� {FFFFFF}�����\n\
						"MAIN_COLOR"� {FFFFFF}������ ��������");
						MyShowPlayerDialog(playerid, DMODE_GPS_PART, DIALOG_STYLE_LIST, "��������� - ����������", string, "�������", "�����", 0);
					}
					case 2:	//	��������� ������
					{
						for(new j = 1; j < sizeof(Jobs); j++)
						{
							if(Jobs[j][J_OFF])
							{
								format(string, sizeof(string), "%s"MAIN_COLOR"� {FFFFFF}%s\n", string, Jobs[j][J_NAME]);
							}
						}
						MyShowPlayerDialog(playerid, DMODE_GPS_OFFJOB, DIALOG_STYLE_LIST, "��������� - ��������� ������", string, "�������", "�����", 0);
					}
					case 3:	//	����������� ������
					{
						new lstring[1024];
						for(new j = 1; j < sizeof(Jobs); j++)
						{
							if(Jobs[j][J_OFF])	continue;
							format(lstring, sizeof(lstring), "%s"MAIN_COLOR"� {FFFFFF}%s\t\n", lstring, Jobs[j][J_NAME]);
						}
						strcat(lstring,
							""MAIN_COLOR"� {FFFFFF}����� ������� �������\t(���������)\n\
							"MAIN_COLOR"� {FFFFFF}����� ������������\t(���������)\n\
							"MAIN_COLOR"� {FFFFFF}����� ������� �����\t(�����������)\n\
							"MAIN_COLOR"� {FFFFFF}����� ������������\t(�����������)");
						MyShowPlayerDialog(playerid, DMODE_GPS_JOB, DIALOG_STYLE_TABLIST, "��������� - ����������� ������", lstring, "�������", "�����", 0);
					}
					case 4:	//	���������
					{
						ShowDialog(playerid, DMODE_GPS_VEH);
					}
					case 5:	//	�������� � �������
					{
						ShowDialog(playerid, DMODE_GPS_SHOPS);
					}
					case 6:	//	�����������
					{
						ShowDialog(playerid, DMODE_GPS_REST);
					}
				}
				//Streamer_Update(playerid);
			}
			else if(openWithMenu[playerid])
			{
				ShowDialog(playerid, DMENU_MAIN);
			}
		}
		case DMODE_GPS_MAIN:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:	//	����������� �������
					{
						ShowPlayerGPSPoint(playerid, 1553.0, -1675.6, 16.2);
				        SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "����������� ������� ������� �� ������ "SCOLOR_GPS"������ ��������");
					}
					case 1:	//	����� ���-�������
					{
						ShowPlayerGPSPoint(playerid, 1480.9, -1769.5, 18.8);
				        SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "����� ���-������� �������� �� ������ "SCOLOR_GPS"������ ��������");
					}
					case 2:	//	���������
					{
						//ShowPlayerGPSPoint(playerid, -2026.5, -99.5, 35.2); // San Fierro
						ShowPlayerGPSPoint(playerid, 725.65, -1440.13, 13.53); // Los Santos
				        SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "��������� �������� �� ������ "SCOLOR_GPS"������ ��������");
					}
					case 3:	//	����
					{
						ShowPlayerGPSPoint(playerid, 1545.99, -1269.10, 17.40);
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "���� ������� �� ������ "SCOLOR_GPS"������ ��������");
					}
					case 4:	//	��������
					{
						ShowPlayerGPSPoint(playerid, 1172.46, -1321.5, 15.4);
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "�������� �������� �� ������ "SCOLOR_GPS"������ ��������");
					}
					case 5:	//	Jefferson
					{
						ShowPlayerGPSPoint(playerid, 2232.67, -1159.71, 25.9);
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "����� Jefferson ������� �� ������ "SCOLOR_GPS"������ ��������");
					}
				}
			}
			else
			{
				ShowDialog(playerid, DMODE_GPS);
			}
		}
		case DMODE_GPS_VEH:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:	//	���������
					{
						new num;
						for(new i = 0, Float:mindist, Float:dist; i < sizeof AutoShowPos; i++)
						{
						    dist = GetDistanceFromMeToPoint(playerid, Arr3<AutoShowPos[i]>);
						    if(mindist == 0 || mindist > dist)	{	num = i;	mindist = dist;	}
						}
						ShowPlayerGPSPoint(playerid, Arr3<AutoShowPos[num]>);
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "��������� ��������� ������� �� ������ "SCOLOR_GPS"������ ��������");
					}
					case 1:	//	������ ����
					{
						ShowPlayerGPSPoint(playerid, 1639.04, -1100.21, 23.9);
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "������ ���� �������� �� ������ "SCOLOR_GPS"������ ��������");
					}
					case 2:	//  ��������������
					{
						new num;
						for(new i = 0, Float:mindist, Float:dist; i < sizeof AutoRepairPos; i++)
						{
						    dist = GetDistanceFromMeToPoint(playerid, Arr3<AutoRepairPos[i]>);
						    if(mindist == 0 || mindist > dist)	{	num = i;	mindist = dist;	}
						}
						ShowPlayerGPSPoint(playerid, Arr3<AutoRepairPos[num]>);
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "��������� �������������� �������� �� ������ "SCOLOR_GPS"������ ��������");
					}
					case 3:	//	��������
					{
						new lstring[512];
						SetPVarInt(playerid, "GPS:BizType", BUS_GAS_STATION);
						for(new b = 0; b < MaxBiz; b++)
						{
							if(BizInfo[b][bType] == BUS_GAS_STATION)
							{
								format(lstring, sizeof(lstring), "%s"MAIN_COLOR"� {FFFFFF}%s\t[%.1f m.]\n", lstring, BizInfo[b][bName], GetDistanceFromMeToPoint(playerid, Arr3<BizInfo[b][bPos]>));
							}
						}
						return MyShowPlayerDialog(playerid, DMODE_GPS_BIZ, DIALOG_STYLE_TABLIST, "��������� - ��������", lstring, "�������", "�����");
					}
					case 4: //  ��������� ����
					{
						new num;
						for(new i = 0, Float:mindist, Float:dist; i < sizeof paynspray; i++)
						{
						    dist = GetDistanceFromMeToPoint(playerid, Arr3<paynspray[i]>);
						    if(mindist == 0 || mindist > dist)	{	num = i;	mindist = dist;	}
						}
						ShowPlayerGPSPoint(playerid, Arr3<paynspray[num]>);
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "��������� ��������� ���� ������� �� ������ "SCOLOR_GPS"������ ��������");

					}
				}
			}
			else
			{
				ShowDialog(playerid, DMODE_GPS);
			}
		}
		case DMODE_GPS_PART:
		{
			if(response)
			{
				if(listitem == 0)
				{
					ShowPlayerGPSPoint(playerid, 2134.51, -2276.57, 20.67);
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "�������� ����� ������� �� ������ "SCOLOR_GPS"������ ��������");
				}
				else if(listitem == 1)
				{
					ShowPlayerGPSPoint(playerid, -1060.58, -1195.65, 129.68);
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "����� �������� �� ������ "SCOLOR_GPS"������ ��������");
				}
				else if(listitem == 2)
				{
					ShowPlayerGPSPoint(playerid, 2176.05, -2282.54, 13.52);
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "������ �������� �������� �� ������ "SCOLOR_GPS"������ ��������");
				}
			}
			else
			{
				ShowDialog(playerid, DMODE_GPS);
			}
		}
		case DMODE_GPS_OFFJOB:
		{
			if(response)
			{
				for(new j = 1, c = 0; j < sizeof(Jobs); j++)
				{
					if(Jobs[j][J_OFF] && c++ == listitem)
					{
						ShowPlayerGPSPoint(playerid, Arr3<Jobs[j][J_POS]>);
						SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_GPS "������ '%s' - �������� �� ������ "SCOLOR_GPS"������ ��������", Jobs[j][J_NAME]);
						SendClientMessage(playerid, COLOR_LIGHTBLUE, "��������! ������ ����� ���������� ����� ������, ���������� ���������� � �����!");
					}
				}
			}
			else
			{
				ShowDialog(playerid, DMODE_GPS);
			}
		}
		case DMODE_GPS_JOB:
		{
			if(response)
			{
				new c = 0;
				for(new j = 1; j < sizeof(Jobs); j++)
				{
					if(!Jobs[j][J_OFF] && c++ == listitem)
					{
						ShowPlayerGPSPoint(playerid, Arr3<Jobs[j][J_POS]>);
						SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_GPS "������ '%s' - �������� �� ������ "SCOLOR_GPS"������ ��������", Jobs[j][J_NAME]);
					}
				}
				if(c++ == listitem)	//	����� ������� ������� (���������)
				{
					ShowPlayerGPSPoint(playerid, 2744.6, -2453.5, 13.8);
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "����� ������� ������� �������� �� ������ "SCOLOR_GPS"������ ��������");
				}
				else if(c++ == listitem)	//	����� ������������ (���������)
				{
					ShowPlayerGPSPoint(playerid, -616.2, -478.0, 25.68);
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "����� ������������ �������� �� ������ "SCOLOR_GPS"������ ��������");
				}
				else if(c++ == listitem)	//	����� ������� ����� (�����������)
				{
					ShowPlayerGPSPoint(playerid, -1066.5, -1154.4, 129.2);
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "����� ������� ����� �������� �� ������ "SCOLOR_GPS"������ ��������");
				}
				else if(c++ == listitem)	//	����� ������������ (�����������)
				{
					ShowPlayerGPSPoint(playerid, -2164.0, -249.27, 36.51);
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "����� ������������ �������� �� ������ "SCOLOR_GPS"������ ��������");
				}
			}
			else
			{
				ShowDialog(playerid, DMODE_GPS);
			}
		}
		case DMODE_GPS_SHOPS:
		{
			if(response)
			{
				for(new i = 0, c = 0; i < sizeof(BizTypeData); i++)
				{
					if(BizTypeData[i][btGPSType] == 0 && c++ == listitem)
					{
						new lstring[512];
						SetPVarInt(playerid, "GPS:BizType", i);
						for(new b = 0; b < MaxBiz; b++)
						{
							if(BizInfo[b][bType] == i)
							{
								format(lstring, sizeof(lstring), "%s"MAIN_COLOR"� {FFFFFF}%s\t[%.1f m.]\n", lstring, BizInfo[b][bName], GetDistanceFromMeToPoint(playerid, Arr3<BizInfo[b][bPos]>));
							}
						}
						format(string, sizeof(string), "��������� - %s", BizTypeData[i][btName]);
						return MyShowPlayerDialog(playerid, DMODE_GPS_BIZ, DIALOG_STYLE_TABLIST, string, lstring, "�������", "�����");
					}
				}
			}
			else
			{
				ShowDialog(playerid, DMODE_GPS);
			}
		}
		case DMODE_GPS_REST:
		{
			if(response)
			{
				for(new i = 0, c = 0; i < sizeof(BizTypeData); i++)
				{
					if(BizTypeData[i][btGPSType] == 1 && c++ == listitem)
					{
						new lstring[512];
						SetPVarInt(playerid, "GPS:BizType", i);
						for(new b = 0; b < MaxBiz; b++)
						{
							if(BizInfo[b][bType] == i)
							{
								format(lstring, sizeof(lstring), "%s"MAIN_COLOR"� {FFFFFF}%s\t[%.1f m.]\n", lstring, BizInfo[b][bName], GetDistanceFromMeToPoint(playerid, Arr3<BizInfo[b][bPos]>));
							}
						}
						format(string, sizeof(string), "��������� - %s", BizTypeData[i][btName]);
						return MyShowPlayerDialog(playerid, DMODE_GPS_BIZ, DIALOG_STYLE_TABLIST, string, lstring, "�������", "�����");
					}
				}
			}
			else
			{
				ShowDialog(playerid, DMODE_GPS);
			}
		}
		case DMODE_GPS_BIZ:
		{
			new type = GetPVarInt(playerid, "GPS:BizType");
			if(response)
			{

				for(new i = 0, c = 0; i < MaxBiz; i++)
				{
					if(BizInfo[i][bType] == type && c++ == listitem)
					{
						ShowPlayerGPSPoint(playerid, Arr3<BizInfo[i][bPos]>);
						SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_GPS "%s '%s' �������(�) �� ������ "SCOLOR_GPS"������ ��������", BizTypeData[type][btName], BizInfo[i][bName]);
					}
				}
				Streamer_Update(playerid);
				DeletePVar(playerid, "GPS:BizType");
			}
			else
			{
				if(BizTypeData[type][btGPSType] == 0)		ShowDialog(playerid, DMODE_GPS_SHOPS);
				else if(BizTypeData[type][btGPSType] == 1)	ShowDialog(playerid, DMODE_GPS_REST);
				else if(BizTypeData[type][btGPSType] == 2)	ShowDialog(playerid, DMODE_GPS_VEH);
			}
		}
		case DMODE_GUNDEL:
		{
		    if(response && weaponid_new[playerid])
		    {
				if(!strlen(inputtext) || (strcmp(inputtext, "yes", true) && strcmp(inputtext, "��", true)))
					return ShowDialog(playerid, dialogid);

				new price = GetPVarInt(playerid, "Player:WaponBuy:Price");
				DeletePVar(playerid, "Player:WaponBuy:Price");
				if(MyGetPlayerMoney(playerid) < price)
				{
					return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� �� ������� ����� ��� ������� ����� ������.");
				}
				new weapons, ammo;
			    GetPlayerWeaponData(playerid, GunParams[ weaponid_new[playerid] ][GUN_SLOT], weapons, ammo);
				if(ammo + GunParams[ weaponid_new[playerid] ][GUN_AMMO] >= 1000)
				{
				    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ������������ ���������� ������.");
				}
				MyGivePlayerMoney(playerid, -price);
				MyClearPlayerWeaponSlot(playerid, GunParams[ weaponid_new[playerid] ][GUN_SLOT]);
		    	//MyGivePlayerWeapon(playerid, weaponid_new[playerid], GunParams[ weaponid_new[playerid] ][GUN_AMMO]);
		    	Inv.GivePlayerWeapon(playerid, weaponid_new[playerid], GunParams[ weaponid_new[playerid] ][GUN_AMMO]);

		        new b = GetBizWhichPlayer(playerid);
	        	if(b != INVALID_DATA && BizInfo[b][bType] == BUS_AMMO)
	        	{
	        		BizSaleProds(b, GunParams[ weaponid_new[playerid] ][GUN_PRICE], 1);
	        	}
		    }
		    if(IsGang(PlayerInfo[playerid][pFaction]) && IsPlayerInRangeOfPoint(playerid, 4.0, Arr3<ActorInfo[A_EMMET][a_Pos]>))
		    {
		        ShowDialog(playerid, DNPC_EMMET);
		    }
		}
		case DMODE_SENDAD:
		{
			if(response)
			{
				new text[100];
				GetPVarString(playerid, "SendADText", text, sizeof(text));

				if(PlayerInfo[playerid][pPhoneNumber] == 0)	{
					return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ����� �������, ����� ��������� ����������.");
				}
				if(gAdvertCount >= MAX_ADVERT_COUNT)	{
					return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� �� ���������� ������, ���������� �����.");
				}
				if(MyGetPlayerMoney(playerid) < SENDAD_PRICE)	{
					return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
				}
				new slot = -1;
				for(new i; i < MAX_ADVERT_COUNT; i++)
				{
					if(gAdvert[i][adBusy] == false)	{
						slot = i;
						break;
					}
				}
				if(slot == -1)	{
					return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� �� ���������� ������, ���������� �����.");
				}
				gAdvertCount++;
				//new price = len * gAdvertPrice;
				format(gAdvert[slot][adSender], 24, "%s", ReturnPlayerName(playerid));
				gAdvert[slot][adPhone] = PlayerInfo[playerid][pPhoneNumber];
				format(gAdvert[slot][adText], 100, "%s", text);
				gAdvert[slot][adBusy] = true;
				gAdvert[slot][adTime] = 60 * 60;

				MyGivePlayerMoney(playerid, -SENDAD_PRICE);
				SendFormatMessage(playerid, COLOR_GREEN, string, "[�������]: ���������� ����������: {FFFFFF}%s", text);
				SendClientMessage(playerid, COLOR_GREEN, "[�������]: ��������� ����� ������������ ����� �������� �����������");
				format(string, sizeof(string), "# | ������ ����� ���������� �� {FFFFFF}%s [id: %d]{33CCFF} | ���������: /edit", ReturnPlayerName(playerid), playerid);
				SendFactionMessage(F_NEWS, COLOR_LIGHTBLUE, string);
				SetPVarInt(playerid, "SendADTime", gettime());
			}
		}
		case DMODE_ADLIST:
		{
			if(response)
			{
				for(new i = 0, j = 0; i < MAX_ADVERT_COUNT; i++)
				{
					if(!gAdvert[i][adBusy])	continue;	
					if(j++ != listitem)	continue;
					if(pAdverReload[playerid] + 60 > gettime())
					{
					    format(string, sizeof(string), "�� ���������� �������������� ����������: ~y~%d ���", pAdverReload[playerid] + 60 - gettime());
					    ShowPlayerHint(playerid, string);
					    return ShowDialog(playerid, dialogid);
					}
					if(gAdvert[i][adStatus] == 1)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ���������� ������������� ������ ����������.");
						return ShowDialog(playerid, dialogid);
					}
					SetPVarInt(playerid, "EditAdID", i + 1);
					gAdvert[i][adStatus] = 1;
					return ShowDialog(playerid, DMODE_ADMENU);
				}
				return ShowDialog(playerid, dialogid);
			}
		}
		case DMODE_ADMENU:
		{
			new num = GetPVarInt(playerid,"EditAdID") - 1;
			if(response)
			{
				if(listitem == 0)
				{
					ShowDialog(playerid, dialogid);
				}
				else if(listitem == 1)
				{	//	���������
					gAdvert[num][adTime] = gAdvertTime;
					gAdvertTime += 30;
					format(gAdvert[num][adCheker], MAX_PLAYER_NAME, "%s", ReturnPlayerName(playerid));
					format(gAdvert[num][adRang], MAX_PLAYER_NAME, "%s", GetPlayerRank(playerid));
					gAdvert[num][adStatus] = 2;
					pAdverReload[playerid] = gettime();
					ShowDialog(playerid, DMODE_ADLIST);
				}
				else if(listitem == 2)
				{	//	�������������
					ShowDialog(playerid, DMODE_ADEDIT);
				}
				else if(listitem == 3)
				{	//	��������� �������������

					format(string, sizeof(string), "[AdmWrn] %s[%d] ����������� �� ���������� �� %s: {FFFFFF}%s", ReturnPlayerName(playerid), playerid, gAdvert[num][adSender], gAdvert[num][adText]);
					SendAdminMessage(COLOR_LIGHTRED, string);
					SendClientMessage(playerid, COLOR_LIGHTRED, "���������� ���������� ������������� � ������� �� �������");

					strdel(gAdvert[num][adSender], 0, 24);
					gAdvert[num][adPhone] = 0;
					strdel(gAdvert[num][adText], 0, 100);
					strdel(gAdvert[num][adCheker], 0, 24);
					strdel(gAdvert[num][adRang], 0, 24);
					gAdvert[num][adBusy] = false;
					gAdvert[num][adStatus] = 0;
					gAdvert[num][adTime] = 0;
					gAdvertCount--;
					ShowDialog(playerid, DMODE_ADLIST);
				}
				else if(listitem == 4)
				{	//	�������
					format(string, sizeof(string), "# | %s %s[%d] ������ ����������: %s", GetPlayerRank(playerid), ReturnPlayerName(playerid), playerid, gAdvert[num][adText]);
					SendFactionMessage(F_NEWS, COLOR_LIGHTRED, string);

					strdel(gAdvert[num][adSender], 0, 24);
					gAdvert[num][adPhone] = 0;
					strdel(gAdvert[num][adText], 0, 100);
					strdel(gAdvert[num][adCheker], 0, 24);
					strdel(gAdvert[num][adRang], 0, 24);
					gAdvert[num][adBusy] = false;
					gAdvert[num][adStatus] = 0;
					gAdvert[num][adTime] = 0;
					gAdvertCount--;
					ShowDialog(playerid, DMODE_ADLIST);
				}
			}
			else
			{
				gAdvert[num][adStatus] = 0;
				ShowDialog(playerid, DMODE_ADLIST);
			}
		}
		case DMODE_ADEDIT:
		{
			if(response)
			{
				new num = GetPVarInt(playerid, "EditAdID") - 1;
				format(gAdvert[num][adText], 100, "%s", inputtext);
				gAdvert[num][adTime] = gAdvertTime;
				gAdvertTime += 30;
				format(gAdvert[num][adCheker], MAX_PLAYER_NAME, "%s", ReturnPlayerName(playerid));
				format(gAdvert[num][adRang], MAX_PLAYER_NAME, "%s", GetPlayerRank(playerid));
				gAdvert[num][adStatus] = 2;
				gAdvert[num][adEdit] = true;
				pAdverReload[playerid] = gettime();
				ShowDialog(playerid, DMODE_ADLIST);
			}
			else
			{
				ShowDialog(playerid, DMODE_ADMENU);
			}
		}
		case DMODE_GIVERANK:
		{
			if(response)
			{
			    if(0 < PlayerInfo[playerid][pFaction] < sizeof(Faction))
			    {
				    new rank = listitem + 1, action[16];
			        new faction = PlayerInfo[playerid][pFaction];
			        new targetid = GetPVarInt(playerid, "giverank_targetid");

				    if(!IsPlayerLogged(targetid)) return 1;
				    if(PlayerInfo[targetid][pRank] == rank) return ShowDialog(playerid, dialogid);
				    else if(PlayerInfo[targetid][pRank] < rank) action = "��������";
				    else if(PlayerInfo[targetid][pRank] > rank) action = "��������";

				    PlayerInfo[targetid][pRank] = rank;
				    UpdatePlayerData(targetid, "rank", rank);
				    //MySetPlayerSkin(targetid, FactionSkins[faction][rank - 1]);
				    UpdatePlayerSkin(targetid);
					SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "�� %s� ������ %s �� ����� %s", action, ReturnPlayerName(targetid), FactionRank[faction][rank-1]);
					SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s %s ��� �� ����� %s", GetPlayerRank(playerid), ReturnPlayerName(playerid), action, FactionRank[faction][rank-1]);

					format(string, sizeof(string), "%s giverank %s : %s (%d)", ReturnPlayerName(playerid), ReturnPlayerName(targetid), FactionRank[faction][rank-1], rank);
					log("Faction", string);

			    	if(gTargetid[playerid] != INVALID_PLAYER_ID)	{
			        	gTargetid[playerid] = INVALID_PLAYER_ID;
					}
			    }
			}
			else
			{
				if(gTargetid[playerid] != INVALID_PLAYER_ID)	{
		        	return ShowDialog(playerid, DMODE_REACTION);
				}
			}
		}
		case DMODE_RENTCAR:
		{
			if(response)
			{
			    new vehicleid = GetPlayerVehicleID(playerid);
			    if(vehicleid > 0 && VehInfo[vehicleid][vRentOwner] == 0)
			    {
				    if(MyGetPlayerMoney(playerid) < VehInfo[vehicleid][vRentPrice])
				    {
				        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �� ������� ����� �� ������ ����������.");
				        return ShowDialog(playerid, dialogid);
				    }
				    if(GetPVarInt(playerid, "RentCar"))
				    {
				    	MySetVehicleToRespawn(GetPVarInt(playerid, "RentCar"));
				    }
			        VehInfo[vehicleid][vRentOwner] = PlayerInfo[playerid][pUserID];
			        VehInfo[vehicleid][vRentTime] = 3600;	//	������ �� ���
			        SetPVarInt(playerid, "RentCar", vehicleid);
			        MyGivePlayerMoney(playerid, -VehInfo[vehicleid][vRentPrice]);
					TogglePlayerControllable(playerid, true);
					UpdateVehicleLabel(vehicleid);

			        if(CarInfo[vehicleid][cType] == C_TYPE_JOB)
			        {
			        	switch(CarInfo[vehicleid][cOwnerID])
			        	{
						#if defined	_job_job_busdriver_included
				        	case JOB_BUSDRIVER:
					        {
					        	BusDriverStatus[playerid] = 1;
								BusDriverVeh[playerid] = vehicleid;
					        	Dialog_Show(playerid, Dialog:BusDriver_Route);
					        }
					    #endif
					        case JOB_TRUCKER:
					        {
					        	ShowPlayerHint(playerid, "������� ~y~~k~~TOGGLE_SUBMISSIONS~ ~w~����� ������� ������ �������", 10000);
					        }
					        case JOB_TAXI:
					        {
					        	ShowPlayerHint(playerid, "~w~������� ~y~~k~~TOGGLE_SUBMISSIONS~ ~w~����� ����� �� ��������� ���������", 5000);
					        }
					    }
			        }
			    }
			}
			else
			{
				TogglePlayerControllable(playerid, true);
				RemovePlayerFromVehicle(playerid);
			}
		}
		case DMODE_EXTEND_RENTCAR:
		{
			new v = GetPVarInt(playerid, "RentCar");
			TogglePlayerControllable(playerid, true);
			if(v)
			{
				if(response)
				{
					//	���������� �� ���
					if(MyGetPlayerMoney(playerid) < VehInfo[v][vRentPrice])
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �������.");
					}
					else
					{
						MyGivePlayerMoney(playerid, -VehInfo[v][vRentPrice]);
						VehInfo[v][vRentTime] = 3600;
						SendFormatMessage(playerid, COLOR_GREEN, string, "[������]: �� �������� ������ %s �� 1 ���, ��������� �����������!", VehParams[GetVehicleModel(v)-400][VEH_NAME]);
						return true;
					}

				}
				//	������ ������
				MySetVehicleToRespawn(v);
				SendFormatMessage(playerid, COLOR_LIGHTRED, string, "[������]: �� ��������� ������ %s, ����������� ���!", VehParams[GetVehicleModel(v)-400][VEH_NAME]);
			}
		}
		case DMODE_DRUGSTORE:
		{
		    if(response)
		    {
		        new const amount = strval(inputtext);
		        if(!(0 < strlen(inputtext) < 10) || amount <= 0)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
		            return ShowDialog(playerid, dialogid);
		        }
			    if(DrugStore < amount)
			    {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ��� ������� ����������.");
		            return ShowDialog(playerid, dialogid);
			    }
		        new const price = amount * PRICE_DRUG;
		        if(MyGetPlayerMoney(playerid) < price)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
		            return ShowDialog(playerid, dialogid);
		        }
				if(Inv.AddPlayerThing(playerid, THING_DRUGS, amount) == 0)
				{
					return ShowDialog(playerid, dialogid);
				}
		        DrugStore -= amount;
			    format(string, sizeof(string), "����������\n{FFFFFF}%d �����", DrugStore);
			    UpdateDynamic3DTextLabelText(Drug3DText, 0xFFFF00FF, string);
		        MyGivePlayerMoney(playerid, -price);
		        ShowDialog(playerid, dialogid);
	        }
		}
		case DMODE_MAKELEADER:
		{
			if(response)
			{
			    format(string, 128, "%d %d", MakeleaderPlayerid[playerid], listitem + 1);
	            callcmd::makeleader(playerid, string);
			}
		}
		case DMODE_CHOOSEGANG:
		{
			if(!response) return 1;
			for(new idx, i = 0; i < sizeof(Faction); i++)
			{
			    if(i == 0 || IsGang(i)) idx++; else continue;
			    if(listitem == idx-1)
			    {
				    format(string, 4, "%d", i);
			    	callcmd::setowner(playerid, string);
			        break;
			    }
			}
		}
		case DMODE_OFFLINE_MESSAGE:
		{
			mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `offline_message` WHERE `user_id` = '%d'", PlayerInfo[playerid][pUserID]);
			mysql_query_ex(string);
		}
		case DMODE_HOSPITAL:
		{
			if(response)
			{
				if(listitem == 0)
				{
					if(MyGetPlayerMoney(playerid) < 100)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� ��������.");
						return ShowDialog(playerid, dialogid);
					}
					if(MyGetPlayerHealth(playerid) >= 100)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ���������� � ����������� �������.");
						return ShowDialog(playerid, dialogid);
					}
					MySetPlayerHealth(playerid, 100);
					MyGivePlayerMoney(playerid, -100);
					SendClientMessage(playerid, COLOR_GREEN, "��� ���� ������� ����������� ������!");
				}
				else if(listitem == 1)
				{
					if(MyGetPlayerMoney(playerid) < 50)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� ��������.");
						return ShowDialog(playerid, dialogid);
					}
					if(Inv.AddPlayerThing(playerid, THING_FIRSTAID, 1) == 0)
					{
		                return ShowDialog(playerid, dialogid);
					}
					MyGivePlayerMoney(playerid, -50);
				}
			}
		}
		case DMODE_BOXINFO:
		{
			gPickupTime[playerid] = 3;
		}
		case DMODE_FSTYLE:
		{
			if(response)
			{
				if((PlayerInfo[playerid][pLearnFStyle] >> listitem) & 0x1)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������ ���� ����� ���.");
					return ShowDialog(playerid, dialogid);
				}
				if(PlayerInfo[playerid][pUpgrade] < 1)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� �� ������� ����� �������.");
					return ShowDialog(playerid, dialogid);
				}
				PlayerInfo[playerid][pUpgrade]--;
				PlayerInfo[playerid][pLearnFStyle] |= (0x1 << listitem);
				UpdatePlayerBitData(playerid, "learn_fstyle", PlayerInfo[playerid][pLearnFStyle]);
				SendFormatMessage(playerid, COLOR_WHITE, string, "[����� ���]: �� ������� ������� ����� ���: %s", FightStyleNames[listitem + 1]);
				SuccesAnim(playerid);
				ShowDialog(playerid, dialogid);
			}
			else gPickupTime[playerid] = 3;
		}
		//---	admin
		case DADMIN_TICKETS:
		{
			if(response)
			{
				for(new i = 0, j = 0; i < MAX_ASK_COUNT; i++)
				{
					if(!gAsk[i][askBusy])	continue;
					if(j++ != listitem)		continue;
					if(gAsk[i][askStatus])
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������ ��� ���������������.");
						return ShowDialog(playerid, dialogid);
					}
					SetPVarInt(playerid, "Admin:InTicket", i);
					return ShowDialog(playerid, DADMIN_TICKET_MENU);
				}
				return ShowDialog(playerid, dialogid);
			}
		}
		case DADMIN_TICKET_MENU:
		{
			new num = GetPVarInt(playerid, "Admin:InTicket");
			if(response)
			{
				if(listitem == 0)
				{
					return ShowDialog(playerid, dialogid);
				}
				else if(listitem == 1)
				{	//	��������
					return ShowDialog(playerid, DADMIN_TICKET_ANS);
				}
				else if(listitem == 2)
				{	//	�������
					format(string, sizeof(string), "%s %s[%d] ������ ������ %s: %s", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(gAsk[num][askSender]), gAsk[num][askText]);
					SendAdminMessage(COLOR_ADMIN, string);

					gAsk[num][askSender] 	= 0;
					strdel(gAsk[num][askText], 0, 100);
					gAsk[num][askBusy]		= false;
					gAsk[num][askStatus]	= false;
					gAskCount--;
					ShowDialog(playerid, DADMIN_TICKETS);
				}
			}
			else
			{
				gAsk[num][askStatus] = false;
				DeletePVar(playerid, "Admin:InTicket");
				ShowDialog(playerid, DADMIN_TICKETS);
			}
		}
		case DADMIN_TICKET_ANS:
		{
			if(response)
			{
				new num = GetPVarInt(playerid, "Admin:InTicket");
				new giveplayerid = gAsk[num][askSender];
			    if(!IsPlayerLogged(giveplayerid))
			    {
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
			    }
			    else
			    {
					SendFormatMessage(giveplayerid, COLOR_ANSWER, string, "%s %s ��������: {FFFFFF}%s", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), inputtext);
					format(string, sizeof(string), "%s %s[%d]: {FFFFFF}%s[%d], %s", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, inputtext);
					SendAdminMessage(COLOR_ANSWER, string, 1);
					PlayerPlaySound(giveplayerid, 6401, 0, 0, 0);
			    }
				gAsk[num][askSender] 	= 0;
				strdel(gAsk[num][askText], 0, 100);
				gAsk[num][askBusy]		= false;
				gAsk[num][askStatus]	= false;
				gAskCount--;
				DeletePVar(playerid, "Admin:InTicket");
				ShowDialog(playerid, DADMIN_TICKETS);
			}
			else
			{
				ShowDialog(playerid, DADMIN_TICKET_MENU);
			}
		}
		//---   server
		case DSERV_MAIN:
		{
		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0: ShowDialog(playerid, DSERV_STATS);	// ���������� �������
		            case 1: ShowDialog(playerid, DSERV_ADMINS); // ������ ���������������
		            case 2: ShowDialog(playerid, DSERV_LEADERS);// ������ �������
		        }
		    }
		}
		case DSERV_STATS:
		{
		    if(!response) ShowDialog(playerid, DSERV_MAIN);
		}
		case DSERV_ADMINS:
		{
		    if(!response) return ShowDialog(playerid, DSERV_MAIN);
		    else if(GetPlayerAdmin(playerid) >= ADMIN_GADMIN)
		    {
				mysql_format(g_SQL, string, sizeof(string), "SELECT `id`,`admin` FROM `players` WHERE `admin` > 0 ORDER BY `admin` DESC, `online` DESC, `exitunix` DESC LIMIT %d,1", listitem);
				new Cache:result = mysql_query(g_SQL, string);
				if(cache_num_rows())
				{
				    new id, admin;
				    cache_get_value_index_int(0, 0, id);
				    cache_get_value_index_int(0, 1, admin);
				    if(GetPlayerAdmin(playerid) <= admin)
				    {
				        ShowDialog(playerid, dialogid);
				        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������� ������ ������ ������ ��� ����.");
				    }
				    else
				    {
						SetPVarInt(playerid, "DSERV:ADMINS:ID", id);
						ShowDialog(playerid, DSERV_ADMINS_ACTION);
					}
				}
				cache_delete(result);
		    }
		}
		case DSERV_ADMINS_ACTION:
		{
		    if(response && GetPlayerAdmin(playerid) >= ADMIN_GADMIN)
		    {
				if(!strlen(inputtext) || (strcmp(inputtext, "uninvite", true) && strcmp(inputtext, "�������", true)))
				{
					return ShowDialog(playerid, dialogid);
				}
			    new id = GetPVarInt(playerid, "DSERV:ADMINS:ID");
				mysql_format(g_SQL, string, sizeof(string), "SELECT `username`, `online`, `admin` FROM `players` WHERE `id` = '%d'", id);
				new Cache:result = mysql_query(g_SQL, string);
				if(cache_num_rows() == 0)
				{
					cache_delete(result);
					DeletePVar(playerid, "DSERV:ADMINS:ID");
				    return ShowDialog(playerid, DSERV_ADMINS);
				}
				new name[32], online, admin;
				cache_get_value_index(0, 0, name);
				cache_get_value_index_int(0, 1, online);
				cache_get_value_index_int(0, 2, admin);
				cache_delete(result);

			    if(GetPlayerAdmin(playerid) <= admin)
			    {
			        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ����������� ����� ������.");
					DeletePVar(playerid, "DSERV:ADMINS:ID");
				    return ShowDialog(playerid, DSERV_ADMINS);
			    }
				if(IsPlayerLogged(online))
				{
			    	format(string, sizeof(string), "%d 0", online);
					return callcmd::makeadmin(playerid, string);
				}
				else
				{
					format(string, sizeof(string), "UPDATE `players` SET `admin` = '0' WHERE `id` = '%d'", id);
					mysql_query_ex(string);

	    			format(string, sizeof(string), "[������]: %s %s ���� � ��� �������", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid));
	    			SendOfflineMessage(id, string);

					format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ���������� %s� %s (offline)", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, getAdminStatus(admin), name);
					SendAdminMessage(COLOR_ADMIN, string);
				}
		    }
		    ShowDialog(playerid, DSERV_ADMINS);
			DeletePVar(playerid, "DSERV:ADMINS:ID");
		}
		case DSERV_LEADERS:
		{
		    if(!response) return ShowDialog(playerid, DSERV_MAIN);
		    else if(GetPlayerAdmin(playerid) >= ADMIN_GADMIN)
		    {
		    }
		}
		case DSERV_LEADERS_ACTION:
		{
		}
		//---   faction
		case DFACT_MEMBERS:
		{
		    if(response && IsPlayerLeader(playerid))
		    {
				mysql_format(g_SQL, string, sizeof(string), "SELECT `id` FROM `players` WHERE `faction` = '%d' ORDER BY `rank` DESC, `online` DESC, `exitunix` DESC LIMIT %d,1", PlayerInfo[playerid][pFaction], listitem);
				new Cache:result = mysql_query(g_SQL, string);
				if(cache_num_rows())
				{
				    new id;
				    cache_get_value_index_int(0, 0, id);
				    if(PlayerInfo[playerid][pUserID] == id)
				    {
				        ShowDialog(playerid, dialogid);
				    }
				    else
				    {
						SetPVarInt(playerid, "DFACT:MEMBERS:ID", id);
						ShowDialog(playerid, DFACT_MEMBERS_ACTION);
					}
				}
				cache_delete(result);
			}
		}
		case DFACT_MEMBERS_ACTION:
		{
		    new id = GetPVarInt(playerid, "DFACT:MEMBERS:ID");
		    if(response && IsPlayerLeader(playerid))
		    {
				if(!strlen(inputtext) || (strcmp(inputtext, "uninvite", true) && strcmp(inputtext, "�������", true)))
				{
					return ShowDialog(playerid, dialogid);
				}
				mysql_format(g_SQL, string, sizeof(string), "SELECT `username`, `online` FROM `players` WHERE `id` = '%d'", id);
				new Cache:result = mysql_query(g_SQL, string);
				if(cache_num_rows() == 0)
				{
					cache_delete(result);
					DeletePVar(playerid, "DFACT:MEMBERS:ID");
				    return ShowDialog(playerid, DFACT_MEMBERS);
				}
				new name[32], online;
				cache_get_value_index(0, 0, name);
				cache_get_value_index_int(0, 1, online);
				cache_delete(result);
				
				if(IsPlayerLogged(online))
				{
			    	valstr(string, online);
					return callcmd::uninvite(playerid, string);
				}
				else
				{
					format(string, sizeof(string), "UPDATE `players` SET `faction` = '0' AND `rank` = '0' WHERE `id` = '%d'", id);
					mysql_query_ex(string);

	    			format(string, sizeof(string), "[�������]: %s %s ������ ��� �� �������", GetPlayerRank(playerid), ReturnPlayerName(playerid));
	    			SendOfflineMessage(id, string);

					SendFormatMessage(playerid, COLOR_LIGHTRED, string, "�� ������� %s �� �����������", name);
					format(string, sizeof(string), "%s uninvite %s (offline): %s", ReturnPlayerName(playerid), name, GetFactionName(PlayerInfo[playerid][pFaction]));
					log("Faction", string);
				}
		    }
		    ShowDialog(playerid, DFACT_MEMBERS);
			DeletePVar(playerid, "DFACT:MEMBERS:ID");
		}
		//---	mission
		case DMIS_TRAINING1:
		{
			mission_cpnum[playerid] = MySetPlayerCheckpoint(playerid, CPMODE_MISSION, 2166.36, -1155.36, 24.86, 2.0);
			mission_step[playerid] = 1;
			if(!isRus(playerid))
			{
				format(string, sizeof(string), "{FFFFFF}�������� �� �������� � �������� ����� ��� %s�", ActorInfo[A_NEWBIE][a_Name]);
				MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "�������", string, "�������", "", 0);
			}
			else
			{
				format(string, sizeof(string), "�������� �� �������� � �������� ����� ��� ~y~%s�", ActorInfo[A_NEWBIE][a_Name]);
				SendMissionMessage(playerid, string, 5000, true);
			}
		}
		case DMIS_TRAINING2:
		{
			StoryMissionComplete(playerid, MIS_SOURCE_TRAINING, 200, 0);
		}
		//---
		case DWAREHOUSE_MAIN:
		{
		    if(!response)
		    {
			    DeletePVar(playerid, "WH:faction");
			    DeletePVar(playerid, "WH:takeitem");
			    gPickupTime[playerid] = 3;
			    return 1;
		    }
		    if(listitem == 0)
		    {// �������� �� �����
				ShowDialog(playerid, DWAREHOUSE_INV);
		        return 1;
		    }
		    new const faction = GetPVarInt(playerid, "WH:faction");
		    if(listitem == 1 && PlayerInfo[playerid][pRank] < FactionRankMax[faction] - 1)
	        {// ������
			    SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "������ � ������� ������� ���� %s (%d).", FactionRank[faction][ FactionRankMax[faction] - 1-1 ], FactionRankMax[faction] - 1);
	            return ShowDialog(playerid, dialogid);
	        }
		    else if(PlayerInfo[playerid][pRank] < 3)
		    {
			    SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "���� ������� ������� ���� %s (3).", FactionRank[faction][3-1]);
	            return ShowDialog(playerid, dialogid);
		    }
	        SetPVarInt(playerid, "WH:takeitem", listitem);
	        ShowDialog(playerid, DWAREHOUSE_TAKE);
		}
		case DWAREHOUSE_TAKE:
		{
		    if(!response) return ShowDialog(playerid, DWAREHOUSE_MAIN);

			new const faction = GetPVarInt(playerid, "WH:faction");
			if(PlayerInfo[playerid][pFaction] != faction) return 1;

	        new const value = strval(inputtext);
	        if(!(0 < strlen(inputtext) < 10) || value <= 0)
	        {
	            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
	            return ShowDialog(playerid, dialogid);
	        }
	        new color = COLOR_LIGHTPURPLE, colorRGB[] = "D24A9C";
            if(IsGang(faction))
			{
				color = GetGangColor(faction);
				strput(colorRGB, GetGangColorRGB(faction));
			}
		    switch(GetPVarInt(playerid, "WH:takeitem"))
		    {
		        case 1:// ������
		        {
			        if(PlayerInfo[playerid][pRank] < FactionRankMax[faction] - 1)
			        {
					    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� � ������.");
			            return ShowDialog(playerid, DWAREHOUSE_MAIN);
			        }
		            if(Warehouse[faction][WH_MONEY] < value)
		            {
		                SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ��� ������� �����.");
		                return ShowDialog(playerid, dialogid);
		            }
		            MyGivePlayerMoney(playerid, value);
		            Warehouse[faction][WH_MONEY] -= value;
		            format(string, sizeof(string), "# | %s {FFFFFF}%s[%d]{%s} �������� �� ������ {FFFFFF}%d$", GetPlayerRank(playerid), ReturnPlayerName(playerid), playerid, colorRGB, value);
		            SendFactionMessage(faction, color, string);
					format(string, sizeof(string), "%s from %s : %d$", ReturnPlayerName(playerid), GetFactionName(PlayerInfo[playerid][pFaction]), value);
					log("Warehouses", string);
		        }
		        case 2:// ���������
		        {
				    if(PlayerInfo[playerid][pRank] < 3)
				    {
					    SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "���� ������� ������� ���� %s (3).", FactionRank[faction][3-1]);
			            return ShowDialog(playerid, DWAREHOUSE_MAIN);
				    }
		            if(Warehouse[faction][WH_DRUGS] < value)
		            {
		                SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ��� ������� ����������.");
		                return ShowDialog(playerid, dialogid);
		            }
			    	if(Inv.AddPlayerThing(playerid, THING_DRUGS, value) == 0)
					{
						return ShowDialog(playerid, dialogid);
					}
		            Warehouse[faction][WH_DRUGS] -= value;
		            format(string, sizeof(string), "# | %s {FFFFFF}%s[%d]{%s} �������� �� ������ {FFFFFF}%d �.{%s} ����������", GetPlayerRank(playerid), ReturnPlayerName(playerid), playerid, colorRGB, value, colorRGB);
		            SendFactionMessage(faction, color, string);
					format(string, sizeof(string), "%s from %s : %d drugs", ReturnPlayerName(playerid), GetFactionName(PlayerInfo[playerid][pFaction]), value);
					log("Warehouses", string);
		        }
		        case 3:// ���������
		        {
				    if(PlayerInfo[playerid][pRank] < 3)
				    {
					    SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "���� ������� ������� ���� %s (3).", FactionRank[faction][3-1]);
			            return ShowDialog(playerid, DWAREHOUSE_MAIN);
				    }
		            if(Warehouse[faction][WH_MATS] < value)
		            {
		                SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ��� ������� ����������.");
		                return ShowDialog(playerid, dialogid);
		            }
			    	if(Inv.AddPlayerThing(playerid, THING_GUN_MATS, value) == 0)
					{
						return ShowDialog(playerid, dialogid);
					}
		            Warehouse[faction][WH_MATS] -= value;
		            format(string, sizeof(string), "# | %s {FFFFFF}%s[%d]{%s} �������� �� ������ {FFFFFF}%d ��.{%s} ����������", GetPlayerRank(playerid), ReturnPlayerName(playerid), playerid, colorRGB, value, colorRGB);
		            SendFactionMessage(faction, color, string);
					format(string, sizeof(string), "%s from %s : %d mats", ReturnPlayerName(playerid), GetFactionName(PlayerInfo[playerid][pFaction]), value);
					log("Warehouses", string);
		        }
		        default:
				{
				    if(PlayerInfo[playerid][pRank] < 3)
				    {
					    SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "���� ������� ������� ���� %s (3).", FactionRank[faction][3-1]);
			            return ShowDialog(playerid, DWAREHOUSE_MAIN);
				    }
				    new bool:founded = false;
				    new const item = GetPVarInt(playerid, "WH:takeitem");
				    for(new idx, s = 0; s < WH_GUN_MAX; s++)
				    {
				        if(Warehouse[faction][WH_GUN][s] != 0 && idx++ == item - 4)
				        {
				            if(Warehouse[faction][WH_GUN][s] < value)
				            {
				                SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ��� ������� ������ ��� ����� ������.");
				                return ShowDialog(playerid, dialogid);
				            }
				            new weaponid = GetWarehouseWeaponid(s);
				            Warehouse[faction][WH_GUN][s] -= value;
				            Inv.GivePlayerWeapon(playerid, weaponid, value);
				            //MyGivePlayerWeapon(playerid, weaponid, value);
				            format(string, sizeof(string), "# | %s {FFFFFF}%s[%d]{%s} �������� �� ������ {FFFFFF}%s (%d ���.)", GetPlayerRank(playerid), ReturnPlayerName(playerid), playerid, colorRGB, ReturnWeaponName(weaponid), value);
				            SendFactionMessage(faction, color, string);
							format(string, sizeof(string), "%s from %s : %s (%d patr.)", ReturnPlayerName(playerid), GetFactionName(PlayerInfo[playerid][pFaction]), ReturnWeaponName(weaponid), value);
							log("Warehouses", string);

							founded = true; break;
				        }
				    }
				    if(founded == false) return ShowDialog(playerid, DWAREHOUSE_MAIN);
				}
		    }
		    SaveWarehouse(faction);
		    ShowDialog(playerid, DWAREHOUSE_MAIN);
		}
		case DWAREHOUSE_INV:
		{
		    if(!response)
		    {
		        DeletePVar(playerid, "WH:giveitem");
		        return ShowDialog(playerid, DWAREHOUSE_MAIN);
		    }
	        SetPVarInt(playerid, "WH:giveitem", listitem);
	        ShowDialog(playerid, DWAREHOUSE_GIVE);
		}
		case DWAREHOUSE_GIVE:
		{
		    if(!response) return ShowDialog(playerid, DWAREHOUSE_INV);

	        new const value = strval(inputtext);
	        if(!(0 < strlen(inputtext) < 10) || value <= 0)
	        {
	            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
	            return ShowDialog(playerid, dialogid);
	        }
	        new color = COLOR_LIGHTPURPLE, colorRGB[] = "D24A9C";
			new const faction = GetPVarInt(playerid, "WH:faction");
            if(IsGang(faction))
			{
				color = GetGangColor(faction);
				strput(colorRGB, GetGangColorRGB(faction));
			}
		    switch(GetPVarInt(playerid, "WH:giveitem"))
		    {
		        case 0:// ������
		        {
		            if(MyGetPlayerMoney(playerid) < value)
		            {
		                SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� �����.");
		                return ShowDialog(playerid, dialogid);
		            }
			    	if(Warehouse[faction][WH_MONEY] + value > 500000)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ����� �� ���������� ������� �����.");
		                return ShowDialog(playerid, DWAREHOUSE_MAIN);
					}
		            MyGivePlayerMoney(playerid, -value);
		            Warehouse[faction][WH_MONEY] += value;
		            format(string, sizeof(string), "# | %s {FFFFFF}%s[%d]{%s} ������ �� ����� {FFFFFF}%d$", GetPlayerRank(playerid), ReturnPlayerName(playerid), playerid, colorRGB, value);
		            SendFactionMessage(faction, color, string);
					format(string, sizeof(string), "%s to %s : %d$", ReturnPlayerName(playerid), GetFactionName(PlayerInfo[playerid][pFaction]), value);
					log("Warehouses", string);
		        }
		        case 1:// ���������
		        {
		            if(Inv.GetThing(playerid, THING_DRUGS) < value)
		            {
		                SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� ����������.");
		                return ShowDialog(playerid, dialogid);
		            }
			    	if(Warehouse[faction][WH_DRUGS] + value > 10000)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ����� �� ���������� ������� ����������.");
		                return ShowDialog(playerid, DWAREHOUSE_MAIN);
					}
					Inv.PlayerDeleteThing(playerid, THING_DRUGS, 0, value);
		            Warehouse[faction][WH_DRUGS] += value;
		            format(string, sizeof(string), "# | %s {FFFFFF}%s[%d]{%s} ������ �� ����� {FFFFFF}%d �.{%s} ����������", GetPlayerRank(playerid), ReturnPlayerName(playerid), playerid, colorRGB, value, colorRGB);
		            SendFactionMessage(faction, color, string);
					format(string, sizeof(string), "%s to %s : %d drugs", ReturnPlayerName(playerid), GetFactionName(PlayerInfo[playerid][pFaction]), value);
					log("Warehouses", string);
		        }
		        case 2:// ���������
		        {
		            if(Inv.GetThing(playerid, THING_GUN_MATS) < value)
		            {
		                SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� ����������.");
		                return ShowDialog(playerid, dialogid);
		            }
			    	if(Warehouse[faction][WH_MATS] + value > 10000)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ����� �� ���������� ������� ����������.");
		                return ShowDialog(playerid, DWAREHOUSE_MAIN);
					}
					Inv.PlayerDeleteThing(playerid, THING_GUN_MATS, 0, value);
		            Warehouse[faction][WH_MATS] += value;
		            format(string, sizeof(string), "# | %s {FFFFFF}%s[%d]{%s} ������ �� ����� {FFFFFF}%d ��.{%s} ����������", GetPlayerRank(playerid), ReturnPlayerName(playerid), playerid, colorRGB, value, colorRGB);
		            SendFactionMessage(faction, color, string);
					format(string, sizeof(string), "%s to %s : %d mats", ReturnPlayerName(playerid), GetFactionName(PlayerInfo[playerid][pFaction]), value);
					log("Warehouses", string);
		        }
		        default:
				{
					// ������
					new bool:founded = false;
				    new const item = GetPVarInt(playerid, "WH:giveitem");
					for(new idx, slot = 2, weaponid, ammo; slot < 8; slot++)
					{   // ����� ������ � ��������� ������
						MyGetPlayerWeapon(playerid, slot, weaponid, ammo);
					    if(weaponid == 0 && ammo == 0)	continue;

				        new s = GetWarehouseWeaponSlot(weaponid);
				        if(s != -1 && idx++ == item - 3)
				        {   // ��������� ����� ������ �� ������ (-1 ���� �� ����� ������)
				            if(ammo < value)
				            {
				                SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� ������ ��� ����� ������.");
				                return ShowDialog(playerid, dialogid);
				            }
					    	if(Warehouse[faction][WH_GUN][s] + value > 10000)
							{
								SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ����� �� ���������� ������� ����������.");
				                return ShowDialog(playerid, DWAREHOUSE_MAIN);
							}
				            Warehouse[faction][WH_GUN][s] += value;
							MySetPlayerWeapon(playerid, weaponid, (ammo - value));
				            format(string, sizeof(string), "# | %s {FFFFFF}%s[%d]{%s} ������ �� ����� {FFFFFF}%s (%d ���.)", GetPlayerRank(playerid), ReturnPlayerName(playerid), playerid, colorRGB, ReturnWeaponName(weaponid), value);
				            SendFactionMessage(faction, color, string);
							format(string, sizeof(string), "%s to %s : %s (%d patr.)", ReturnPlayerName(playerid), GetFactionName(PlayerInfo[playerid][pFaction]), ReturnWeaponName(weaponid), value);
							log("Warehouses", string);

							founded = true; break;
				        }
					}
				    if(founded == false) return ShowDialog(playerid, DWAREHOUSE_INV);
				}
		    }
		    SaveWarehouse(faction);
		    ShowDialog(playerid, DWAREHOUSE_MAIN);
		}
	    //	job
	    case DJOB_GUNDEAL_MATS:
	    {
	    	if(response)
			{
				if(IsMafia(PlayerInfo[playerid][pFaction]))//Job.GetPlayerJob(playerid) != JOB_GUNDEAL)
				{
					return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �������� �������.");
				}
				new count = strval(inputtext);
				if(!(0 < strlen(inputtext) < 10) || count <= 0)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
		            return ShowDialog(playerid, dialogid);
		        }
				new price = count * 50;
				if(MyGetPlayerMoney(playerid) < price)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
                	return ShowDialog(playerid, dialogid);
				}
				if(Inv.AddPlayerThing(playerid, THING_METALL, count))
				{
					SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "�� ������ %d ������� � �������� �� $%d", count, price);
		    		MyGivePlayerMoney(playerid, -price);
		    	}
		    	else
		    	{
		            return ShowDialog(playerid, dialogid);
				}
			}
			gPickupTime[playerid] = 3;
	    }
	    case DJOB_GUNDEAL_GUN:
	    {
	    	if(response)
	    	{
	    		if(IsMafia(PlayerInfo[playerid][pFaction]))//Job.GetPlayerJob(playerid) != JOB_GUNDEAL)
	    		{
	    			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �������� �������.");
	    		}
	    		if(!(0 <= listitem < sizeof(GunDealWeapons)))
	    		{
	    			return false;
	    		}
	    		new weapon = GunDealWeapons[listitem];
	    		if(Inv.GetThing(playerid, THING_GUN_MATS) < GunParams[weapon][GUN_MATS])
	    		{
	    			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������ ����������.");
	    			return ShowDialog(playerid, dialogid);
	    		}
	  			SetPVarInt(playerid, "GunDealMats", GunParams[weapon][GUN_MATS]);
	  			SetPVarInt(playerid, "GunDealWeapon", weapon);
	  			SetPVarInt(playerid, "GunDealAmmo", GunParams[weapon][GUN_AMMO]);

				new bool:comb[5];
				_GenerateComb(sizeof(comb), comb);
				SetPlayerComb(playerid, COMB_CREATE_GUN, sizeof(comb), comb, true);
				MyApplyAnimation(playerid, "INT_SHOP", "shop_cashier", 4.1, 1, 0, 0, 1, 11000);
				HidePlayerInventory(playerid);
	    	}
	    }
	    case DJOB_DRUGDEAL_MATS:
	    {
	    	if(response)
			{
				if(IsMafia(PlayerInfo[playerid][pFaction]))//Job.GetPlayerJob(playerid) != JOB_DRUGDEAL)	{
				{
					return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �����������.");
				}
				new count = strval(inputtext);
				if(!(0 < strlen(inputtext) < 10) || count <= 0)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
		            return ShowDialog(playerid, dialogid);
		        }
				new price = count * 100;
				if(MyGetPlayerMoney(playerid) < price)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
                	return ShowDialog(playerid, dialogid);
				}
				if(Inv.AddPlayerThing(playerid, THING_DRUGS_MATS, count))
				{
					SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "�� ������ %d ������� ����� �� $%d", count, price);
		    		MyGivePlayerMoney(playerid, -price);
		    	}
		    	else
		    	{
		            return ShowDialog(playerid, dialogid);
				}
			}
			gPickupTime[playerid] = 3;
	    }
	    case DJOB_MECHANIC:
	    {
	    	if(response)
	    	{
	    		if(Job.GetPlayerJob(playerid) != JOB_MECHANIC)
				{
					return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ��������� ���������.");
				}
				if(Job.GetPlayerNowWork(playerid) == JOB_MECHANIC)
				{
					Job.ClearPlayerNowWork(playerid);
					ReloadPlayerSkin(playerid);
					format(string, sizeof(string), "������� %s[%d] ������ � ���������", ReturnPlayerName(playerid), playerid);
    				SendJobMessage(JOB_MECHANIC, COLOR_LIGHTBLUE, string);
				}
				else
				{
					if(Job.SetPlayerNowWork(playerid, JOB_MECHANIC))
					{
						MySetPlayerSkin(playerid, 50, false);
						format(string, sizeof(string), "[������]: ������� {FFFFFF}%s[%d]{F5DEB3} ����� �� ��������� {FFFFFF}(/call 600)", ReturnPlayerName(playerid), playerid);
						MySendClientMessageToAll(COLOR_YELLOW2, string);
					}
				}
	    	}
	    	gPickupTime[playerid] = 3;
	    }
		//---
		case DMENU_MAIN:
		{
			if(response)
			{
				openWithMenu[playerid] = true;
				new item = 0;
				//if(gMissionProgress[playerid][MIS_SOURCE_TRAINING] < 4 && listitem == item++)
				//{
				//	ShowDialog(playerid, DMENU_TASKS);		// ������
				//}
				if(listitem == item++)	ShowStats(playerid, playerid);			// ����������
				if(listitem == item++)	ShowDialog(playerid, DMENU_LEVELING);	// ��������
			#if defined _player_phone_included
				if(PlayerInfo[playerid][pPhoneNumber] && listitem == item++)
				{
					callcmd::phone(playerid, "");
				}
			#endif	
			    if(listitem == item++)	ShowDialog(playerid, DMENU_SETTING);	// ���������
			    if(listitem == item++)	ShowDialog(playerid, DMENU_PROTECTION);	// ������������
			    //if(listitem == item++)  ShowDialog(playerid, dialogid);		// ��������� (�� �����������)
			    if(listitem == item++)	ShowDialog(playerid, DMENU_DONATE);		// ���. ������
				if(listitem == item++)  // ���� ����� ����
				{
				    if(PlayerInfo[playerid][pLevel] < 4)
				    {
				        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ��� ����� ������� ������ � 4�� ������.");
				        return ShowDialog(playerid, dialogid);
				    }
					ShowDialog(playerid, DMENU_BONUS);
				}
				if(listitem == item++)	ShowDialog(playerid, DMENU_CONTACT);    // ����� � ��������������
			}
			else openWithMenu[playerid] = false;
		}
		case DMENU_TASKS:
		{
			if(response)
			{
				for(new i = 1; i < sizeof(StartMissionData); i++)
				{
					if(listitem + 1 == i)
					{
						return MyShowPlayerDialog(playerid, DMENU_TASKS_INFO, DIALOG_STYLE_MSGBOX, StartMissionData[i][m_Title], StartMissionData[i][m_Desc], "�����", "", 0);
					}
				}
			}
			else
			{
				return ShowDialog(playerid, DMENU_MAIN);
			}
		}
		case DMENU_TASKS_INFO:
		{
			return ShowDialog(playerid, DMENU_TASKS);
		}
		case DMENU_STATS:
		{
		    if(response == 0 && openWithMenu[playerid])
		    {
		    	return ShowDialog(playerid, DMENU_MAIN);
			}
		}
		case DMENU_LEVELING:
		{
			if(response)
			{
				if(listitem == 0)		// ������
				{
					ShowDialog(playerid, DMENU_SKILL);
				}
				else if(listitem == 1)	// �������� �������
				{
					ShowDialog(playerid, DMENU_WEAPON_SKILL);
				}
				else if(listitem == 2)	// ���������
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ����������.");
					ShowDialog(playerid, dialogid);
					//ShowDialog(playerid, DMENU_ADVANCE);
				}

			#if defined _player_achieve_included
				else if(listitem == 3)	// ����������
				{
					Dialog_Show(playerid, Dialog:Achieve_Main);
				}
			#endif	
			}
		    else if(openWithMenu[playerid])
		    {
		    	ShowDialog(playerid, DMENU_MAIN);
			}
		}
		case DMENU_SKILL:
		{
			ShowDialog(playerid, DMENU_LEVELING);
		}
		case DMENU_WEAPON_SKILL:
		{
			ShowDialog(playerid, DMENU_LEVELING);
		}
		case DMENU_ADVANCE:
		{
			if(response)
			{
				ShowDialog(playerid, DMENU_LEVELING);
			}
			else
			{
				ShowDialog(playerid, DMENU_LEVELING);
			}
		}
		case DMENU_DONATE:
		{
		    if(response)
		    {
				switch(listitem)
				{
				    case 0: ShowDialog(playerid, DMENU_HOWGETCOIN);     // ��� �������� ������
				    case 1: ShowDialog(playerid, DMENU_COINTOVIP);		// ������ ������� �������
				    case 2:	//	������� ������
				    {
				    	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ����������.");
				    	return ShowDialog(playerid, DMENU_DONATE);
				    }
				    case 3:	//	������� exp
				    {
				    	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ����������.");
				    	return ShowDialog(playerid, DMENU_DONATE);
				    }
				    case 4: ShowDialog(playerid, DMENU_COINTOMONEY);	// ������ � �������
				    case 5: ShowDialog(playerid, DMENU_COINTOUPGRADE);	// ������ � ���� ��������
				    case 6: ShowDialog(playerid, DMENU_COINTOLAW);		// ������ � �����������������
				}
		    }
		    else if(openWithMenu[playerid])
		    {
		    	ShowDialog(playerid, DMENU_MAIN);
			}
		}
		case DMENU_COINTOVIP:
		{
			if(response)
	        {
		        new const week = strval(inputtext);
				if(!(0 < strlen(inputtext) < 10) || week <= 0)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.a");
		            return ShowDialog(playerid, dialogid);
		        }
				new coins = week * CoinForVIP;
		        if(coins > GetPlayerCoins(playerid))
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �� ������� ����� ��� �������.");
		            return ShowDialog(playerid, dialogid);
		        }
		        PlayerInfo[playerid][pVip] = 1;
		        if(PlayerInfo[playerid][pVipUNIX] > unixtime())
		        {
		        	PlayerInfo[playerid][pVipUNIX] += 604800 * week;
		        	SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_DONATE "�� ������� �������� ������� �� {33AA33}%d {FFFFFF}������", week);
		        }
		        else
		        {
		        	PlayerInfo[playerid][pVipUNIX] = unixtime() + 604800 * week;
		        	SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_DONATE "�� ������� �������� ������� �� {33AA33}%d {FFFFFF}������", week);
		        }
		        mysql_format(g_SQL, string, sizeof(string), "SELECT DATE_FORMAT(FROM_UNIXTIME('%d'), '%d.%m.%Y %H:%i')", PlayerInfo[playerid][pVipUNIX]);
				new Cache:result = mysql_query(g_SQL, string);
				cache_get_value_index(0, 0, string);
				cache_delete(result);

		        SendFormatMessage(playerid, COLOR_WHITE, string, "���� ��������� ������� �������: {9ACD32}%s", string);
		        GivePlayerCoins(playerid, -coins);
		        UpdatePlayerStatics(playerid);
		        PlayerPlaySound(playerid, 36205, 0.0, 0.0, 0.0);
		        SuccesAnim(playerid);
	        }
	        else ShowDialog(playerid, DMENU_DONATE);
		}
		case DMENU_HOWGETCOIN:
		{
		    ShowDialog(playerid, DMENU_DONATE);
		}
	    case DMENU_COINTOMONEY:
	    {
	        if(response)
	        {
		        new const coins = strval(inputtext);
				if(!(0 < strlen(inputtext) < 10) || coins <= 0)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
		            return ShowDialog(playerid, dialogid);
		        }
		        if(coins > GetPlayerCoins(playerid))
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������ �������� ��� �� ������� �����.");
		            return ShowDialog(playerid, dialogid);
		        }
		        new const money = coins * MoneyForCoin;
		        GivePlayerCoins(playerid, -coins);
		        MyGivePlayerMoney(playerid, money);
		        UpdatePlayerStatics(playerid);
		        SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_DONATE "�� ������� �������� {33AA33}%d{FFFFFF} ����� �� {33AA33}%d$", coins, money);
		        ShowDialog(playerid, dialogid);
	        }
	        else ShowDialog(playerid, DMENU_DONATE);
	    }
	    case DMENU_COINTOUPGRADE:
	    {
	        if(response)
	        {
		        new const upgrades = strval(inputtext);
				if(!(0 < strlen(inputtext) < 10) || upgrades <= 0)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
		            return ShowDialog(playerid, dialogid);
		        }
		        new const coins = upgrades * CoinForUpgrade;
		        if(coins > GetPlayerCoins(playerid))
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������ �������� ��� �� ������� �����.");
		            return ShowDialog(playerid, dialogid);
		        }
		        GivePlayerCoins(playerid, -coins);
				PlayerInfo[playerid][pUpgrade] += upgrades;
		        UpdatePlayerStatics(playerid);
		        SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_DONATE "�� ������� �������� {33AA33}%d{FFFFFF} ����� �� {33AA33}%d{FFFFFF} ����� ��������", coins, upgrades);
		        ShowDialog(playerid, dialogid);
	        }
	        else ShowDialog(playerid, DMENU_DONATE);
	    }
	    case DMENU_COINTOLAW:
	    {
	    	if(response)
	        {
	        	new const law = strval(inputtext);
				if(!(0 < strlen(inputtext) < 10) || law <= 0)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
		            return ShowDialog(playerid, dialogid);
		        }
				if(PlayerInfo[playerid][pLaw] + law > 50)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �������� �������� ����� �����������������.");
		            return ShowDialog(playerid, dialogid);
				}
		        new const coins = law * CoinForLaw;
		        if(coins > GetPlayerCoins(playerid))
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������ �������� ��� �� ������� �����.");
		            return ShowDialog(playerid, dialogid);
		        }
		        GivePlayerCoins(playerid, -coins);
				PlayerInfo[playerid][pLaw] += law;
		        UpdatePlayerStatics(playerid);
		        SendFormatMessage(playerid, COLOR_GREEN, string, "[�������]: {FFFFFF}�� ������� �������� {33AA33}%d{FFFFFF} ����� �� {33AA33}%d{FFFFFF} ����� �����������������", coins, law);
		        ShowDialog(playerid, dialogid);
	        }
	        else ShowDialog(playerid, DMENU_DONATE);
	    }
		case DMENU_SETTING:
		{
		    if(response)
		    {
		        switch(listitem)
		        {
		        	case 0:
		        	{
		        		callcmd::binds(playerid, "");
		        	}
					case 1:
					{
						ShowDialog(playerid, DMENU_CHANGE_ANIM);
					}
					case 2:
					{
						ShowDialog(playerid, DMENU_FSTYLE);
					}
					case 3:
					{
					    PlayerInfo[playerid][pRusifik] = !PlayerInfo[playerid][pRusifik];
					    ShowDialog(playerid, dialogid);
					}
					case 4:
					{
					    PlayerInfo[playerid][pInterface] = !PlayerInfo[playerid][pInterface];
					    IFace.ToggleGroup(playerid, IFace.INTERFACE, PlayerInfo[playerid][pInterface]);
					    ShowDialog(playerid, dialogid);
					}
					case 5:
					{
					    callcmd::censore(playerid, "");
					    ShowDialog(playerid, dialogid);
					}
					case 6:
					{
					    ToggleNameTags(playerid, !pNameTags[playerid]);
						ShowDialog(playerid, dialogid);
					}
					case 7:
					{
						ShowDialog(playerid, DMENU_CHANGE_SPAWN);
					}
					case 8:
					{
						PlayerInfo[playerid][pHouseIcon] = !PlayerInfo[playerid][pHouseIcon];
						ToggleHouseIcons(playerid, PlayerInfo[playerid][pHouseIcon]);
						ShowDialog(playerid, dialogid);
					}
					case 9:
					{
						PlayerInfo[playerid][pToggleZone] = !PlayerInfo[playerid][pToggleZone];
						UpdateGangZone(-1, playerid);
						ShowDialog(playerid, dialogid);
					}
		        }
		    }
		    else ShowDialog(playerid, DMENU_MAIN);
		}
		case DMENU_FSTYLE:
		{
			if(response)
			{
				if(!listitem || (PlayerInfo[playerid][pLearnFStyle] >> (listitem - 1)) & 0x1)
				{
					SetPlayerFightingStyle(playerid, FightStyles[listitem]);
					PlayerInfo[playerid][pFightStyle] = listitem;
					SendFormatMessage(playerid, COLOR_WHITE, string, "[����� ���]: ������ �� �������� � �����: %s", FightStyleNames[listitem]);
				}
				else
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �������� ����� ����� ��� ������������� � ��������.");
					ShowDialog(playerid, dialogid);
				}
			}
			else
			{
				ShowDialog(playerid, DMENU_SETTING);
			}
		}
		case DMENU_PROTECTION:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
					    strput(string, GetPlayerEmail(playerid));
						if(strlen(string) > 0)
						{
						    SendFormatMessage(playerid, COLOR_WHITE, string, "[���������]: ����� ����� ����� ��� ������: %s", string);
						    return ShowDialog(playerid, dialogid);
						}
						ShowDialog(playerid, DMODE_EMAIL);
					}
					case 1:
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������� ����������.");
						return ShowDialog(playerid, dialogid);
					}
					case 2:
					{
						ShowDialog(playerid, DMENU_CHANGE_PASS);
					}
				}
			}
			else ShowDialog(playerid, DMENU_MAIN);
		}
		case DMENU_CHANGE_ANIM:
		{
			if(response)
			{
				if(listitem == 0)
				{
					PlayerInfo[playerid][pAnim] = 0;
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "�� ��������� ������ ��������");
				}
				else
				{
					PlayerInfo[playerid][pAnim] = listitem;
					SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "������ ���� ������ ��������: {FFFFFF}%s", PlayerAnims[listitem][PANIM_TITLE]);
					ShowPlayerHint(playerid, "����� ��������� �������� ������� ~y~�������� ����");
				}
			}
			ShowDialog(playerid, DMENU_SETTING);
		}
		case DMENU_CHANGE_SPAWN:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						if(PlayerInfo[playerid][pHousing] == 0 && PlayerInfo[playerid][pRent] == 0)	{
							SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ����� �� ���������.");
							return ShowDialog(playerid, dialogid);
						}
						PlayerInfo[playerid][pSpawn] = SPAWN_HOUSE;
						SendClientMessage(playerid, COLOR_LIGHTBLUE, "[Spawn]: ������ �� ������ ��������� �� ����� ����� ��������");
					}
					case 1:
					{
						if(PlayerInfo[playerid][pFaction] == 0)	{
							SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �������� �� �������.");
							return ShowDialog(playerid, dialogid);
						}
						PlayerInfo[playerid][pSpawn] = SPAWN_FACTION;
						SendClientMessage(playerid, COLOR_LIGHTBLUE, "[Spawn]: ������ �� ������ ��������� �� ������ �������");
					}
					case 2:
					{
						PlayerInfo[playerid][pSpawn] = SPAWN_NEWBIE;
						SendClientMessage(playerid, COLOR_LIGHTBLUE, "[Spawn]: ������ �� ������ ��������� �� ����� ������ (���� ��)");
					}
				}
			}
			ShowDialog(playerid, DMENU_SETTING);
		}
		case DMENU_CHANGE_PASS:
		{
			new clear_pass[128];
			if(GetPVarInt(playerid, "change_pass") == 0)
			{
				if(response)
				{
					mysql_escape_string(inputtext, clear_pass);
				    format(string, sizeof(string), "SELECT COUNT(*) FROM `players` WHERE `id` = '%d' AND `password` = MD5(CONCAT(MD5('%s'), (SELECT `salt` FROM `players` WHERE id = '%d')))", PlayerInfo[playerid][pUserID], clear_pass, PlayerInfo[playerid][pUserID]);
					new Cache:result = mysql_query(g_SQL, string);
					new count;
					cache_get_value_index_int(0, 0, count);
					cache_delete(result);
					if(count == 0)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������ ������ �� �����.");
					}
					else
					{
						SetPVarInt(playerid, "change_pass", 1);
					}
					ShowDialog(playerid, dialogid);
				}
				else ShowDialog(playerid, DMENU_PROTECTION);
			}
			else
			{
				DeletePVar(playerid, "change_pass");
				if(response)
				{
					if(strlen(inputtext) == 0) 	return ShowDialog(playerid, dialogid);
					if((MIN_PASS_SYMB <= strlen(inputtext) < MAX_PASS_SYMB) == false)
					{
						SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "����������� ������ ������ �� %d �� %d ��������.", MIN_PASS_SYMB, MAX_PASS_SYMB);
					    return ShowDialog(playerid, dialogid);
					}
					new salt[MAX_SALT_PASS];
					mysql_escape_string(inputtext, clear_pass);
				    strmid(salt, generateCode(MAX_SALT_PASS), 0, MAX_SALT_PASS);
					format(string, sizeof(string), "UPDATE `players` SET `password` = MD5(CONCAT(MD5('%s'), MD5('%s'))), `salt` = MD5('%s') WHERE `id` = '%d'", clear_pass, salt, salt, PlayerInfo[playerid][pUserID]);
					mysql_query_ex(string);

					format(string, sizeof(string), "��� ����� ������: %s\n�������� ���!", inputtext);
					MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "����������", string, "�������", "");
				}
				else ShowDialog(playerid, dialogid);
			}
		}
		case DMENU_BONUS:
		{
		    if(response)
			{
				new code[16];
				strput(code, inputtext);
			    if(strlen(inputtext) == 0)
			    {
			        ShowDialog(playerid, dialogid);
			        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ��� ������.");
			    }
			    new stmp[128], redirect[16];
			    //	redirect?
			    mysql_format(g_SQL, stmp, sizeof stmp, "SELECT `redirect` FROM `bonuses` WHERE `code` = '%s'", code);
			    new Cache:result = mysql_query(g_SQL, stmp);
			    if(cache_num_rows())	cache_get_value_index(0, 0, redirect);
			    cache_delete(result);
			    if(strlen(redirect) > 0)	strput(code, redirect);
			    //  check
			    mysql_format(g_SQL, stmp, sizeof stmp, "SELECT COUNT(*) FROM `bonuse_input` WHERE `playerid` = '%d' AND `code` = '%s'", PlayerInfo[playerid][pUserID], code);
			   	result = mysql_query(g_SQL, stmp);
			    new count;
			    cache_get_value_index_int(0, 0, count);
			    cache_delete(result);
			    if(count)
			    {
			        ShowDialog(playerid, dialogid);
			        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ��� ��� ����������� ����.");
			    }
			    mysql_format(g_SQL, stmp, sizeof stmp, "SELECT `using`, `type`, `value` FROM `bonuses` WHERE `code` = '%s' LIMIT 1", code);
			    result = mysql_query(g_SQL, stmp);
			    if(cache_num_rows() == 0)
			    {
			        cache_delete(result);
			        ShowDialog(playerid, dialogid);
			        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ���� �� ����������.");
			    }
                new use, type, value;
                cache_get_value_index_int(0, 0, use);
                cache_get_value_index_int(0, 1, type);
                cache_get_value_index_int(0, 2, value);
                cache_delete(result);
                if(use)
                {
	                mysql_format(g_SQL, stmp, sizeof stmp, "SELECT COUNT(*) FROM `bonuse_input` WHERE `code` = '%s'", code);
				    result = mysql_query(g_SQL, stmp);
				    cache_get_value_index_int(0, 0, count);
				    cache_delete(result);
				    if(count >= use)
				    {
				        ShowDialog(playerid, dialogid);
				        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ��� ��� ����������� ������� �������� � ������ �� ��������.");
				    }
				}
                switch(type)
                {
                    case 0:
                    {	//	������
						MyGivePlayerMoney(playerid, value);
						format(stmp, sizeof stmp, "��� '{33AA33}%s{FFFFFF}' ������� �����������! �� �������� {33AA33}%d${FFFFFF}!", inputtext, value);
                    }
                    case 1:
                    {	//	������
                        GivePlayerCoins(playerid, value);
                        format(stmp, sizeof stmp, "��� '{33AA33}%s{FFFFFF}' ������� �����������! �� �������� {33AA33}%d{FFFFFF} �����!", inputtext, value);
                    }
                    case 2:
                    {	//	����
                    	GivePlayerEXP(playerid, value);
                    	format(stmp, sizeof stmp, "��� '{33AA33}%s{FFFFFF}' ������� �����������! �� �������� {33AA33}%d{FFFFFF} �����!", inputtext, value);
                    }
                    default:	format(stmp, sizeof stmp, "��� '{33AA33}%s{FFFFFF}' ������� �����������!", inputtext);
                }
                SendClientMessage(playerid, -1, stmp);
                PlayerPlaySound(playerid, 30801, 0.0, 0.0, 0.0);
                mysql_format(g_SQL, stmp, sizeof stmp, "INSERT INTO `bonuse_input` SET `playerid` = '%d', `code` = '%e'", PlayerInfo[playerid][pUserID], code);
			    mysql_query_ex(stmp);
			}
			else	ShowDialog(playerid, DMENU_MAIN);
		}
		case DMENU_CONTACT:
		{
		    if(response)
		    {
			    if(strlen(inputtext) == 0) return ShowDialog(playerid, dialogid);
			    callcmd::ask(playerid, inputtext);
		    }
		    else if(openWithMenu[playerid])
		    {
		    	ShowDialog(playerid, DMENU_MAIN);
		    }
		}
		//---
		case DBIZ_MAIN:
		{
			if(response)
			{
		    	new b = PickupedBiz[playerid];
		    	if(b != INVALID_DATA)
		    	{
		    		if(listitem == 0)
			    	{
			    		if(BizInfo[b][bLocation] == 0)
						{
							return ShowBizMenu(playerid, b);
						}
						else
						{
							PlayerEnterBiz(playerid, b);
						}
			    	}
					else if(listitem == 1)
					{
						if(BizInfo[b][bOwnerID] == 0)
						{
							if(BuyPlayerBiz(playerid, b))
							{
								SendFormatMessage(playerid, COLOR_WHITE, string, "�� ������� ������ ������ '%s' �� %d$", BizInfo[b][bName], BizInfo[b][bPrice]);
				            	UpdatePlayerStatics(playerid);
							}
							else
							{
								return ShowDialog(playerid, dialogid);
							}
						}
						else if(BizInfo[b][bOwnerID] == PlayerInfo[playerid][pUserID])
						{
							return ShowDialog(playerid, DBIZ_MANAGE);
						}
					}
		    	}
			}
			PickupedBiz[playerid] = INVALID_DATA;
			gPickupTime[playerid] = 5;
		}
		case DBIZ_MANAGE:
		{
			if(response)
			{
				new b = GetBizWhichPlayer(playerid, 0);
		    	if(b != INVALID_DATA)
		    	{
					new item = 0;
					if(listitem == item++) //	�������� ��������
					{
						ShowDialog(playerid, DBIZ_CHANGE_NAME);
					}
	    			else if(listitem == item++)	//	�������� ������
	    			{
	    				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������� ����������.");
	    				ShowDialog(playerid, dialogid);
	    			}
	    			else if(listitem == item++)	//	���������
	    			{
	    				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������� ����������.");
	    				ShowDialog(playerid, dialogid);
	    			}
	    			else if(BizTypeData[ BizInfo[b][bType] ][btMaxEnterPrice] > 0 && listitem == item++)	//	���� �� ����
	    			{
	    				ShowDialog(playerid, DBIZ_ENTER_PRICE);
	    			}
					else if(listitem == item++)	//	������� ������
					{
						ShowDialog(playerid, DBIZ_SELL);
					}
				}
			}
			else
			{
				PickupedBiz[playerid] = INVALID_DATA;
			}
		}
		case DBIZ_CHANGE_NAME:
		{
			if(response)
			{
				if(!strlen(inputtext))
				{
					return ShowDialog(playerid, DBIZ_CHANGE_NAME);
				}
				new b = GetBizWhichPlayer(playerid, 0);
				if(b != INVALID_DATA)
				{
					if(strlen(inputtext) <= 3)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������� ������� ��������.");
						return ShowDialog(playerid, DBIZ_CHANGE_NAME);
					}
					if(strlen(inputtext) >= BIZ_NAME_SIZE)
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������� ������� �������.");
						return ShowDialog(playerid, DBIZ_CHANGE_NAME);
					}
					//if(!IsCorrectName(inputtext, true))
					//{
					//	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������� �������� ������������ �������.");
					//	return ShowDialog(playerid, DBIZ_CHANGE_NAME);
					//}
					new clear_name[BIZ_NAME_SIZE];
					mysql_escape_string(inputtext, clear_name);
					strput(BizInfo[b][bName], clear_name);
					SendFormatMessage(playerid, COLOR_WHITE, string, "�������� ������� ������� ��������: "MAIN_COLOR"%s", BizInfo[b][bName]);
					UpdateBusinessText(b);
					SaveBiz(b);
				}
			}
			ShowDialog(playerid, DBIZ_MANAGE);
		}
		case DBIZ_ENTER_PRICE:
		{
			if(response)
			{
				new b = GetBizWhichPlayer(playerid, 0);
				if(b != INVALID_DATA)
				{
					new const price = strval(inputtext);
					if(!(0 < strlen(inputtext) < 10) || price <= 0 || price > BizTypeData[ BizInfo[b][bType] ][btMaxEnterPrice])
			        {
			            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
			            return ShowDialog(playerid, dialogid);
			        }
					BizInfo[b][bEnterPrice] = price;
					SendFormatMessage(playerid, COLOR_WHITE, string, "��������� ����� ������� ��������: "MAIN_COLOR"$%d", BizInfo[b][bEnterPrice]);
					UpdateBusinessText(b);
					SaveBiz(b);
				}
			}
			ShowDialog(playerid, DBIZ_MANAGE);
		}
		case DBIZ_SELL:
		{
			if(response)
			{
				new b = GetBizWhichPlayer(playerid, 0);
				if(b != INVALID_DATA)
				{
					if(SellBiz(b))
					{
						SendClientMessage(playerid, COLOR_WHITE, "������ ������� ������!");
						PickupedBiz[playerid] = INVALID_DATA;
					}
				}
			}
			else
			{
				ShowDialog(playerid, DBIZ_MANAGE);
			}
		}
		//---
		case DHOME_MAIN:
		{
		    if(!response) return true;
	        new h = GetPlayerHouseID(playerid);
	        if(h < 0) return true;

	        switch(listitem)
			{
	            case 0:
				{	// �������/������� �����
	                if(HouseInfo[h][hLock])	GameTextForPlayer(playerid, "~w~Door ~g~Unlocked", 5000, 6);
					else					GameTextForPlayer(playerid, "~w~Door ~r~Locked", 5000, 6);
					HouseInfo[h][hLock] = !HouseInfo[h][hLock];
					mysql_format(g_SQL, string, sizeof(string), "UPDATE `houses` SET `lock` = '%d' WHERE `id` = '%d'", HouseInfo[h][hLock], h + 1);
					mysql_query_ex(string);
				  	ShowDialog(playerid, dialogid);
	            }
	            case 1:
	            {
	            	SendClientMessage(playerid, COLOR_WHITE, PREFIX_HINT "������ ���� ������������ � �����.");
	            	return ShowDialog(playerid, dialogid);
	            }
	            case 2:	ShowDialog(playerid, DHOME_FURNITURE);		// ���������� ������
	            case 3:	ShowDialog(playerid, DHOME_RENT);			// ������
	            case 4:	ShowDialog(playerid, DHOME_ACC_REGISTER);	// ����������� �����
	            case 5:
				{	// ������� ���
			        PickupedHouse[playerid] = h;
			        ShowDialog(playerid, DMODE_HOUSE_SELL);
	            }
	        }
		}
		case DHOME_ACC_REGISTER:
		{
		    if(response)
		    {
			    new house = GetPlayerHouseID(playerid);
			    if(house == -1)
			    {
			    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���� � ����, ����� ������������ ��� �������.");
			    }
			    if(HouseInfo[house][hOwnerID] != PlayerInfo[playerid][pUserID])
			    {
			    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �������� ����� ����.");
			    }
				if(PlayerInfo[playerid][pHousing] == HouseInfo[house][hID])
				{
					SendClientMessage(playerid, COLOR_LIGHTRED, "[���]: �� ������� ���������� �� ����� ����");
					PlayerInfo[playerid][pHousing] = 0;
				}
			    else
			    {
					SendFormatMessage(playerid, COLOR_GREEN, string, "[���]: �� ������� ��������� � ���� #%d", HouseInfo[house][hID]);
					PlayerInfo[playerid][pHousing] = HouseInfo[house][hID];
				#if defined _player_achieve_included	
					GivePlayerAchieve(playerid, ACHIEVE_URBAN);
				#endif	
			    }
		    	UpdatePlayerHouseMapIcon(playerid);
			}
		    ShowDialog(playerid, DHOME_MAIN);
		}
		case DHOME_FURNITURE:
		{
		    if(response)
		    {
				new house = GetPlayerHouseID(playerid);
			    if(house == -1){
			    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���� � ����, ����� ������������ ��� �������.");
			    }
			    if(HouseInfo[house][hOwnerID] != PlayerInfo[playerid][pUserID]){
			    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �������� ����� ����.");
			    }

				if(listitem == 0){
					return BuyPlayerFurniture(playerid);	//  ������� ������
				}
				else if(listitem == 1)    //  ������� ��� ������
				{
				    if(HouseInfo[house][hExtraSlots] >= MAX_DONATE_FUR)
				    {
				        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������� ��� �������������� �����.");
				     	return ShowDialog(playerid, dialogid);
				    }
					return ShowDialog(playerid, DHOME_BUY_FUR_SLOT);
				}
				else if(listitem == 2)
				{
				    return ShowDialog(playerid, dialogid);
				}
				else
				{
				    listitem -= 3;
		            if(GetPVarInt(playerid, "fur_editid") || GetPVarInt(playerid, "fur_creteid"))
		            {
		            	CancelEditHomeObject(playerid);
		            }
					new query[128];
					mysql_format(g_SQL, query, sizeof query, "SELECT `id`, `object_id`, `dynamic_id`, `fur_num`, `set` FROM `furniture` WHERE `house_id` = '%d' LIMIT %d, 1", HouseInfo[house][hID], listitem);
					new Cache:result = mysql_query(g_SQL, query);
					if(cache_num_rows() == 0)
					{
					    return SendClientMessage(playerid, COLOR_RED, "��������� ������!");
					}
					new id, object_id, dynamic_id, fur_num, set;
					cache_get_value_name_int(0, "id", id);
					cache_get_value_name_int(0, "object_id", object_id);
					cache_get_value_name_int(0, "dynamic_id", dynamic_id);
					cache_get_value_name_int(0, "fur_num", fur_num);
					cache_get_value_name_int(0, "set", set);
					cache_delete(result);

					new stmp[128];
					ShowPlayerHint(playerid,
						"~y~ESC~w~ - ������ ��������������~n~\
						~y~~k~~PED_SPRINT~~w~ - �������� ������____~n~\
						~y~/dfur~w~ - �������� ��������_____", 0);
					if(set)
					{
						SendFormatMessage(playerid, COLOR_LIGHTGREEN, stmp, "�� ������ ������������� �������: %s", FurnitureList[fur_num][fName]);
			   			SetPVarInt(playerid, "fur_editid", dynamic_id);
					}
					else
					{
		                new Float:pos[3];
						GetPlayerPos(playerid, Arr3<pos>);
						dynamic_id = CreateDynamicObject(object_id, pos[0] + 2.0, pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid));
						SendFormatMessage(playerid, COLOR_LIGHTGREEN, stmp, "�� ������ ��������� ��������: %s", FurnitureList[fur_num][fName]);
					  	SetPVarInt(playerid, "fur_creteid", id);
					  	SetPVarInt(playerid, "fur_crete_obj_id", dynamic_id);
					}
					SetPVarInt(playerid, "Fur:HouseID", house);
					EditDynamicObject(playerid, dynamic_id);
					for(new i = 0; i < 8; i++)	SetDynamicObjectMaterial(dynamic_id, i, -1, "none", "none", 0xAAAA3333);
				}
			}
			else
			{
				ShowDialog(playerid, DHOME_MAIN);
			}
		}
		case DHOME_BUY_FUR_SLOT:
		{
		    if(response)
		    {
				new slots = strval(inputtext);
				if(!(0 < strlen(inputtext) < 10) || slots <= 0)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
		            return ShowDialog(playerid, dialogid);
		        }
	            new house = GetPlayerHouseID(playerid);
			    if(house == -1){
			    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���� � ����, ����� ������������ ��� �������.");
			    }
			    if(HouseInfo[house][hOwnerID] != PlayerInfo[playerid][pUserID]){
			    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �������� ����� ����.");
			    }

				if(HouseInfo[house][hExtraSlots] + slots > MAX_DONATE_FUR){
				    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������ ������� ������.");
				    return ShowDialog(playerid, dialogid);
				}
				if(GetPlayerCoins(playerid) < (FUR_SLOT_PRICE * slots))
				{
				    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
				    return ShowDialog(playerid, dialogid);
				}
	            HouseInfo[house][hExtraSlots] += slots;
	            GivePlayerCoins(playerid, -(FUR_SLOT_PRICE * slots));
	            SendFormatMessage(playerid, COLOR_WHITE, string, "�� ������ %d �������������� ������ ��� ������ � ��� ���!", slots);
	            SaveHouse(house);
        	}
        	ShowDialog(playerid, DHOME_FURNITURE);
		}
		case DHOME_FUR_ACCEPT_DEL:
		{
			if(response)
			{
				if(GetPVarInt(playerid, "fur_editid"))
				{
					new dynamic_id = GetPVarInt(playerid, "fur_editid");
			        mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `furniture` WHERE `dynamic_id` = '%d'", dynamic_id);
			        mysql_query_ex(string);
					DestroyDynamicObject(dynamic_id);
					DeletePVar(playerid, "fur_editid");
				}
				else if(GetPVarInt(playerid, "fur_creteid"))
				{
			        mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `furniture` WHERE `id` = '%d'", GetPVarInt(playerid, "fur_creteid"));
			        mysql_query_ex(string);

					DestroyDynamicObject(GetPVarInt(playerid, "fur_crete_obj_id"));
					DeletePVar(playerid, "fur_creteid");
					DeletePVar(playerid, "fur_crete_obj_id");
				}
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "������� ������� ������ �� ������ ����!");
	   			CancelSelectTextDraw(playerid);
	   		}
		}
		case DHOME_RENT:
		{
			if(response)
			{
				new h = GetPlayerHouseID(playerid);
		        if(h < 0) return true;
		        if(HouseInfo[h][hRentPrice] > 0)
		        {
	        		mysql_format(g_SQL, string, sizeof(string), "SELECT `id` FROM `players` WHERE `rent` = '%d'", HouseInfo[h][hID]);
				    new Cache:result = mysql_query(g_SQL, string);
				    new count = cache_num_rows();
				    if(count > 0)
				    {
				    	if(listitem == 0)
				    	{
				    		ShowDialog(playerid, dialogid);
				    	}
				    	else
				    	{
				    		new id;
				    		for(new i = 1; i <= count; i++)
				    		{
					    		if(listitem == i)
					    		{
					    			cache_get_value_name_int(i - 1, "id", id);
					    			SetPVarInt(playerid, "House:Rent:Playerid", id);
					    			return ShowDialog(playerid, DHOME_RENT_MOVEOUT);
					    		}
					    	}
				    	}
				    }
				    if((count == 0 && listitem == 0) || (count > 0 && (listitem - count - 1) == 0))
				    {
				    	return ShowDialog(playerid, DHOME_RENT_CHANGE);
				    }
				    else if((count == 0 && listitem == 1) || (count > 0 && (listitem - count - 1) == 1))
				    {
				    	if(count > 0)
				    	{
				    		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������� ������, ���� � ��� ���-�� ��������.");
						    return ShowDialog(playerid, dialogid);

				    		/*foreach(LoginPlayer, i)
					    	{
					    		if(PlayerInfo[i][pRent] == HouseInfo[h][hID])
					    		{
					    			PlayerInfo[i][pRent] = 0;
					    			SendFormatMessage(i, COLOR_LIGHTRED, string, "[������]: �������� ���� %s ������� ��� �� ����������� ����", ReturnPlayerName(playerid));
					    			// ��������� �� ���������� � ���� � �������� �� ����
					    		}
					    	}
					    	mysql_format(g_SQL, string, sizeof(string), "UPDATE `players` SET `rent` = '0' WHERE `rent` = '%d'", HouseInfo[h][hID]);
					    	mysql_query_ex(string);*/
				    	}
				    	else
				    	{
				    		SendClientMessage(playerid, COLOR_LIGHTRED, "[���]: ������ ������� �������, ��� ���������� ��������");
					    	HouseInfo[h][hRentPrice] = 0;
					    	SaveHouse(h);
		        			UpdateHouse(h);
				    	}
				    }
				    cache_delete(result);
		        }
		        else
		        {
		        	new const rent_price = strval(inputtext);
					if(!(0 < strlen(inputtext) < 10) || rent_price <= 0)
			        {
			            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
			            return ShowDialog(playerid, dialogid);
			        }
		        	HouseInfo[h][hRentPrice] = rent_price;
		        	SendFormatMessage(playerid, COLOR_GREEN, string, "[���]: ������ ������� �������, ���������: $%d", HouseInfo[h][hRentPrice]);
		        	SaveHouse(h);
		        	UpdateHouse(h);
		        }
			}
			ShowDialog(playerid, DHOME_MAIN);
		}
		case DHOME_RENT_MOVEOUT:
		{
			if(response)
			{
				new h = GetPlayerHouseID(playerid);
		        if(h < 0) return true;
				new userid = GetPVarInt(playerid, "House:Rent:Playerid");
				SendFormatMessage(playerid, COLOR_LIGHTRED, string, "[���]: %s ������� �� ������ ����", GetPlayerUsername(userid));
	    		foreach(LoginPlayer, i)
		    	{
		    		if(PlayerInfo[i][pUserID] == userid && PlayerInfo[i][pRent] == HouseInfo[h][hID])
		    		{
		    			SendFormatMessage(i, COLOR_LIGHTRED, string, "[������]: %s ������� ��� �� ������ ����", ReturnPlayerName(playerid));
		    			GivePlayerBank(i, PlayerInfo[i][pPaymentDays] * HouseInfo[h][hRentPrice]);
		    			PlayerInfo[i][pRent] = 0;
		    			UpdatePlayerData(i, "rent", 0);
		    			PlayerInfo[i][pPaymentDays] = 0;
		    			goto end;
		    		}
		    	}

		    	mysql_format(g_SQL, string, sizeof(string), "SELECT `rent`, `payment_days` FROM `players` WHERE `id` = '%d'", userid);
		    	new Cache:result = mysql_query(g_SQL, string);
			    new rent, payment_days;
			    cache_get_value_name_int(0, "rent", rent);
			    cache_get_value_name_int(0, "payment_days", payment_days);
			    cache_delete(result);

			    if(rent == HouseInfo[h][hID])
	    		{
	    			format(string, sizeof(string), "[������]: %s ������� ��� �� ������ ����, ������ ���������� � ����", ReturnPlayerName(playerid));
	    			SendOfflineMessage(userid, string);

	    			new bank = payment_days * HouseInfo[h][hRentPrice];
	    			mysql_format(g_SQL, string, sizeof(string), "UPDATE `players` SET `rent` = '0', `payment_days` = 0, `bank` = `bank` + '%d' WHERE `id` = '%d'", bank, userid);
		    		mysql_query_ex(string);
	    		}
			}
		end:
			ShowDialog(playerid, DHOME_RENT);
		}
		case DHOME_RENT_CHANGE:
		{
			if(response)
			{
				new h = GetPlayerHouseID(playerid);
		        if(h < 0) return true;
				new const rent_price = strval(inputtext);
				if(!(0 < strlen(inputtext) < 10) || rent_price <= 0)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������");
		            return ShowDialog(playerid, dialogid);
		        }

		        mysql_format(g_SQL, string, sizeof(string), "SELECT COUNT(*) AS `count` FROM `players` WHERE `rent` = '%d'", HouseInfo[h][hID]);
		    	new Cache:result = mysql_query(g_SQL, string);
			    new count;
			    cache_get_value_name_int(0, "count", count);
			    cache_delete(result);

			    if(count > 0)
			    {
			    	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ �������� ��������� ������, ���� � ��� ���-�� ��������.");
			    }
			    else
			    {
			    	HouseInfo[h][hRentPrice] = rent_price;
		        	SendFormatMessage(playerid, COLOR_GREEN, string, "[���]: ��������� ������ ������� ��������: $%d", HouseInfo[h][hRentPrice]);
		        	SaveHouse(h);
		        	UpdateHouse(h);
			    }
			}
			ShowDialog(playerid, DHOME_RENT);
		}
		case DHOME_TAKE_RENT:
		{
			if(response)
			{
				new h = PickupedHouse[playerid];
				if(h >= 0 && HouseInfo[h][hOwnerID] > 0)
	    		{
	    			if(HouseInfo[h][hRentPrice] > 0)
	    			{
	    				new days = strval(inputtext);
	    				if(!(0 < strlen(inputtext) < 10) || days <= 0)
				        {
				            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
				            return ShowDialog(playerid, dialogid);
				        }
						new price = HouseInfo[h][hRentPrice] * days;
						if(MyGetPlayerMoney(playerid) < price)
						{
							SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� ��������.");
							return ShowDialog(playerid, dialogid);
						}
						if(days > 30)
						{
							SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������ ���������� ���� ��� ������ - 30.");
							return ShowDialog(playerid, dialogid);
						}
						MyGivePlayerMoney(playerid, -price);
	    				PlayerInfo[playerid][pRent] = HouseInfo[h][hID];
	    				PlayerInfo[playerid][pPaymentDays] = days;
	    				PlayerInfo[playerid][pSpawn] = SPAWN_HOUSE;
	    				UpdatePlayerData(playerid, "rent", PlayerInfo[playerid][pRent]);
	    				UpdatePlayerData(playerid, "payment_days", PlayerInfo[playerid][pPaymentDays]);

	    				SendFormatMessage(playerid, COLOR_GREEN, string, "[������]: �� ������� ���������� ��� #%d �� %d ����", HouseInfo[h][hID], days);
	    				SendClientMessage(playerid, COLOR_LIGHTBLUE, "[Spawn]: ������ �� ������ ��������� � ���������� ����");

	    				new ownerid = GetPlayeridToUserID(HouseInfo[h][hOwnerID]);
	    				format(string, sizeof(string), "[������]: %s ��������� ��� ��� �� %d ����", ReturnPlayerName(playerid), days);
	    				if(ownerid == INVALID_PLAYER_ID)	SendOfflineMessage(HouseInfo[h][hOwnerID], string);
	    				else 								SendClientMessage(ownerid, COLOR_GREEN, string);
	    			#if defined _player_achieve_included
	    				GivePlayerAchieve(playerid, ACHIEVE_URBAN);
	    			#endif
						TextDrawHideForPlayer(playerid, tdHouseButton2);
						TextDrawShowForPlayer(playerid, tdHouseButton3);
	    			}
	    			else
	    			{
	    				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ��� �������.");
	    			}
	    		}
			}
		}
		case DHOME_CANCEL_RENT:
		{
			if(response)
			{
				new h = PickupedHouse[playerid];
				if(h >= 0)
	    		{
	    			if(PlayerInfo[playerid][pRent] == HouseInfo[h][hID])
	    			{
	    				PlayerInfo[playerid][pRent] = 0;
	    				SendFormatMessage(playerid, COLOR_LIGHTRED, string, "[������]: �� ���������� ������ ���� #%d", HouseInfo[h][hID]);
						TextDrawHideForPlayer(playerid, tdHouseButton3);
						TextDrawShowForPlayer(playerid, tdHouseButton2);
	    			}
	    		}
			}
		}
		// npc
		case DNPC_EMMET:
		{
		    if(response)
		    {
				new Float:pos[3];
				GetActorPos(ACTOR[A_EMMET], Arr3<pos>);
				if(!IsPlayerInRangeOfPoint(playerid, 30.0, Arr3<pos>)) return 1;

		        new const idx = listitem,
		        		  weaponid = EmmetStore[idx][0],
		        		  storeammo = EmmetStore[idx][1];
		        if(weaponid == 0 || storeammo == 0)
				{
				    ShowPlayerHint(playerid, "����� ��� � �������.");
					return ShowDialog(playerid, dialogid);
				}
			    if(MyGetPlayerMoney(playerid) < EmmetStore[idx][2])
			    {
				    ShowPlayerHint(playerid, "��� �� ������� �����.");
					return ShowDialog(playerid, dialogid);
			    }
				if(listitem == 6)
				{// ����������
				    if(MyGetPlayerArmour(playerid) > 95.0)
					{
					    ShowPlayerHint(playerid, "�� ��� ����� ����������.");
						return ShowDialog(playerid, dialogid);
					}
					EmmetStore[idx][1] -= 1;
					MyGivePlayerMoney(playerid, -EmmetStore[idx][2]);
					MySetPlayerArmour(playerid, 100.0);
				}
				else
				{
					new curgun, curammo, ammo = GunParams[weaponid][GUN_AMMO];
				    GetPlayerWeaponData(playerid, GunParams[weaponid][GUN_SLOT], curgun, curammo);
					if(storeammo < ammo) ammo = storeammo;
					if(curgun > 0 && curgun != weaponid && curammo > 0)
					{
					    MyHidePlayerDialog(playerid);
					    weaponid_new[playerid] = weaponid;
					    SetPVarInt(playerid, "Player:WaponBuy:Price", EmmetStore[idx][2]);
					    return ShowDialog(playerid, DMODE_GUNDEL);
					}
					if(curammo + ammo >= 1000)
					{
					    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ������������ ���������� ������.");
						return ShowDialog(playerid, dialogid);
					}
					//
					EmmetStore[idx][1] -= ammo;
					MyGivePlayerMoney(playerid, -EmmetStore[idx][2]);
					//MyGivePlayerWeapon(playerid, weaponid, ammo);
					Inv.GivePlayerWeapon(playerid, weaponid, ammo);
					Inv.SavePlayerWeapon(playerid);
				}
				ShowDialog(playerid, dialogid);
		    }
		}
		//---
		case DRACE_JOIN:
		{
		    TogglePlayerControllable(playerid, true);
		    if(response)
		    {
		        if(RaceInfo[rStatus] != 1)
		        {
		        	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ���������, ����� �� ��� ����� ����������.");
		        }
			    for(new sp; sp < RaceInfo[sp_cache]; sp++)
			    {
			        if(RaceSpawn[sp][sp_Status] == 0)
			        {
		                RaceInfo[rPlayers] += 1;
		                RaceSpawn[sp][sp_Status] = playerid + 1;

						new vehicleid = MyCreateVehicle(RaceInfo[rVehicle], RaceSpawn[sp][sp_x], RaceSpawn[sp][sp_y], RaceSpawn[sp][sp_z], RaceSpawn[sp][sp_a], -1, -1);
						CarInfo[vehicleid][cOwnerID] = playerid;
		                SetPVarInt(playerid, "Race:Player:VehicleID", vehicleid);

			            SetVehicleVirtualWorld(vehicleid, VW_RACE);

		                pRaceCP[playerid] = 0;
		                Iter_Add(Racer, playerid);	// ���������
			            SetPlayerVirtualWorld(playerid, VW_RACE);
			            MyPutPlayerInVehicle(playerid, vehicleid, 0);
						SetCameraBehindPlayer(playerid);
						switch(VehInfo[vehicleid][vModelType])
						{
						    case MTYPE_RC, MTYPE_BIKE, MTYPE_MOTO, MTYPE_BOAT, MTYPE_HELIC: ShowPlayerHint(playerid, "~y~F~w~ - ��� ������ �� �����", 0);
						    default: ShowPlayerHint(playerid, "____~y~F~w~ - ��� ������ �� �����~n~~y~/nitro~w~ - ������ ����� [5 coins]", 0);
						}

						// �������� ������������� ������
						/*if(RaceInfo[rPlayers] == RaceInfo[sp_cache])
						{
						    KillTimer(RaceInfo[rtimer]);
						    RaceInfo[rtimer] = 0;
						    RaceTimer();
						}*/
			            return true;
			        }
			    }
			    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ����� ��� �� �������� ��������� ����.");
		    }
		}
		case DRACE_MAIN:
		{
		    if(response)
		    {
		        switch(listitem)
		        {
		            case 0: ShowDialog(playerid, DRACE_LIST); // ������ ���� �����
		            case 1: // ��������� ���������
		            {
					    if(RaceStart(playerid))
					    {
							format(string, 128, "[AdmCmd]: %s %s[%d] �������� ��������� �����", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
							SendAdminMessage(COLOR_ADMIN, string);
					    }
					    else ShowDialog(playerid, dialogid);
		            }
		            case 2: // ������� ����� �����
		            {
						mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `races` SET `name` = 'New Unknown Race', `creater` = '%s'", ReturnPlayerName(playerid));
						new Cache:result = mysql_query(g_SQL, string);
					    redit_id[playerid] = cache_insert_id();
					    cache_delete(result);
					    ShowDialog(playerid, DRACE_EDIT);
		            }
		            case 3: // ���������� �����
		            {
		                if(RaceInfo[rStatus] == 0)
					    {
					        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ���� ����� ��� �� ��������.");
					        return ShowDialog(playerid, dialogid);
					    }
				        foreach(LoginPlayer, i)
						{
						    if(InRace[i]) GameTextForPlayer(i, RusText("~r~����� ���������", isRus(i)), 3000, 4);
						}
						RaceStop();
						MySendClientMessageToAll(COLOR_EVENT, "[�����]: ����� ��������� �� ����������� ��������!");
				        ShowDialog(playerid, dialogid);
		            }
		            case 4: // ���� ����� �����
		            {
					    if(RaceInfo[rStatus] != 1)
					    {
					        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� �� ��������� � ������ ��������.");
					        return ShowDialog(playerid, dialogid);
					    }
					    RaceInfo[rcount] = 0;
						KillTimer(RaceInfo[rtimer]);
					    RaceTimer();
		            }
		        }
		    }
		}
		case DRACE_LIST:
		{
		    if(response)
		    {
			    mysql_format(g_SQL, string, sizeof(string), "SELECT `id` FROM `races` LIMIT %d,1", listitem);
				new Cache:result = mysql_query(g_SQL, string);
				if(!cache_num_rows())
				{
				    cache_delete(result);
				    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ����� �� ����������.");
				    ShowDialog(playerid, dialogid);
				    return 1;
				}
				cache_get_value_name_int(0, "id", redit_id[playerid]);
				cache_delete(result);
				ShowDialog(playerid, DRACE_EDIT);
			}
			else ShowDialog(playerid, DRACE_MAIN);
		}
		case DRACE_EDIT:
		{
		    if(!response)
		    {
		        ShowDialog(playerid, DRACE_MAIN);
		        redit_id[playerid] = 0;
		        return 1;
		    }
	        switch(listitem)
	        {
	            case 0: // ��������� ����� / �������� �����
	            {
			        if(RaceInfo[rStatus] != 0)
			        {
			            if(redit_id[playerid] != RaceInfo[rID])
			            {
			                SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �������� ������ �����.");
			                return ShowDialog(playerid, dialogid);
			            }
	        			foreach(LoginPlayer, i)
						{
						    if(InRace[i]) GameTextForPlayer(i, RusText("~r~����� ���������", isRus(i)), 3000, 4);
						}
				        RaceStop();
						MySendClientMessageToAll(COLOR_EVENT, "[�����]: ����� ��������� �� ����������� ��������!");
				        ShowDialog(playerid, dialogid);
			        }
			        else
			        {
			            if(RaceStart(playerid, redit_id[playerid])) redit_id[playerid] = 0;
			        }
	            }
	            case 1: ShowDialog(playerid, DRACE_EDIT_PARAMS); // ��������� �����
	            case 2: // ��������� �������������� / ����������� ��������������
	            {
				    mysql_format(g_SQL, string, sizeof(string), "SELECT `created` FROM `races` WHERE `id` = '%d'", redit_id[playerid]);
					new Cache:result = mysql_query(g_SQL, string);
					if(!cache_num_rows())
					{
					    cache_delete(result);
					    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ����� �� ����������.");
					    ShowDialog(playerid, DRACE_MAIN);
					    return 1;
					}
			        new created;
			        cache_get_value_name_int(0, "created", created);
			        cache_delete(result);
					//---
					if(created != 0)
					{	// ����������� ��������������
						mysql_format(g_SQL, string, 128, "UPDATE `races` SET `created` = '0' WHERE `id` = '%d'", redit_id[playerid]);
						mysql_query_ex(string);
						ShowDialog(playerid, dialogid);
					}
				    else
				    {	// ��������� ��������������
						mysql_format(g_SQL, string, sizeof(string), "SELECT COUNT(*) AS count FROM `race_cp` WHERE `raceid` = '%d'", redit_id[playerid]);
						result = mysql_query(g_SQL, string);
						new cache_count;
						cache_get_value_name_int(0, "count", cache_count);
						cache_delete(result);
						if(!cache_count)
						{
						    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������� �� ������ ���������.");
						    return ShowDialog(playerid, dialogid);
						}
						//
						mysql_format(g_SQL, string, sizeof(string), "SELECT COUNT(*) AS count FROM `race_spawn` WHERE `raceid` = '%d'", redit_id[playerid]);
						result = mysql_query(g_SQL, string);
						cache_get_value_name_int(0, "count", cache_count);
						cache_delete(result);
						if(cache_count < 4)
						{
						    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ����� ������ ���� �� ����� 4 ����� �����.");
						    ShowDialog(playerid, dialogid);
						    return 1;
						}
						//
						mysql_format(g_SQL, string, 128, "UPDATE `races` SET `created` = '1' WHERE `id` = '%d'", redit_id[playerid]);
						mysql_query_ex(string);
						format(string, 128, "����� #%d: �������������� ���������. ����� ������ � �������!", redit_id[playerid]);
						SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
				        ShowDialog(playerid, dialogid);
				    }
	            }
	            case 3: ShowDialog(playerid, dialogid); // Line
	            case 4: // ������������� ����� �����
	            {
					redit_act[playerid] = 2;
					redit_num[playerid] = 1;
					redit_curid[playerid] = 0;
					format(string, 128, "���������: �� ������ ������������� ����� �����. {FFFFFF}��������: %d", sizeof(RaceSpawn));
					SendClientMessage(playerid, COLOR_YELLOW, string);
					SendClientMessage(playerid, COLOR_YELLOW, "���������: ��� �������� ��� (������) ��� ��� (� ������). ��� ���������� - /race");
					SendClientMessage(playerid, COLOR_YELLOW, "���������: ��� ��������� �� ����� ����� - {FFFFFF}/racenum [spnum]");
	            }
	            case 5: // ������������� ���������
	            {
					redit_act[playerid] = 3;
					redit_num[playerid] = 1;
					redit_size[playerid] = 6.0;
					redit_previd[playerid] = 0;
			        redit_curid[playerid] = ShowPlayerEditCP(playerid, redit_num[playerid]);
					format(string, 128, "���������: �� ������ ������������� ���������. {FFFFFF}��������: %d", sizeof(RaceCP));
					SendClientMessage(playerid, COLOR_YELLOW, string);
					SendClientMessage(playerid, COLOR_YELLOW, "���������: ��� �������� ��� (������) ��� ��� (� ������). {FFFFFF}��� ���������� - /race");
					SendClientMessage(playerid, COLOR_YELLOW, "���������: ������ ������ - Num4 � Num6. ������������� �� ������������ �� - {FFFFFF}/racenum [cpnum]");
	            }
	            case 6: // �������� ������ �����
	            {
					mysql_format(g_SQL, string, sizeof(string), "UPDATE `races` SET `record` = '0', `recordby` = 'na' WHERE `id` = '%d'", redit_id[playerid]);
					mysql_query_ex(string);
					format(string, 128, "����� #%d: ������ ���� ����� ������� ������", redit_id[playerid]);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
					ShowDialog(playerid, dialogid);
	            }
	            case 7: ShowDialog(playerid, DRACE_DELETE); // ��������� ������� �����
	        }
      	}
      	case DRACE_EDIT_PARAMS:
      	{
      	    if(response)
      	    {
      	        switch(listitem)
      	        {
      	            case 1: // �������� �����
					{
					    redit_item[playerid] = listitem;
						format(string, 128, "����� #%d: ��������������", redit_id[playerid]);
						MyShowPlayerDialog(playerid, DRACE_EDIT_WRITE, DIALOG_STYLE_INPUT, string, "������� ����� �������� �����:", "������", "�����");
					}
					case 3:
					{
						redit_item[playerid] = listitem;
						format(string, 128, "����� #%d: ��������������", redit_id[playerid]);
						MyShowPlayerDialog(playerid, DRACE_EDIT_WRITE, DIALOG_STYLE_INPUT, string, "������� ����� id ���������� (400-611):", "������", "�����");
					}
					default: ShowDialog(playerid, dialogid);
      	        }
      	    }
      	    else ShowDialog(playerid, DRACE_EDIT);
      	}
      	case DRACE_EDIT_WRITE:
      	{
      	    if(response)
      	    {
      	        switch(redit_item[playerid])
      	        {
      	            case 1: // �������� �����
      	            {
      	                if(!strlen(inputtext))
      	                {
      	                    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
      	                    ShowDialog(playerid, dialogid);
      	                    return 1;
      	                }
   	                    SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "����� #%d: �������� �������� �� '%s'", redit_id[playerid], inputtext);
						mysql_format(g_SQL, string, sizeof(string), "UPDATE `races` SET `name` = '%e' WHERE `id` = '%d'", inputtext, redit_id[playerid]);
						mysql_query_ex(string);
      	            }
      	            case 3:	//	����������
      	            {
      	            	new model = strval(inputtext);
      	            	if(model < 400 || model > 611)
      	                {
      	                    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
      	                    return ShowDialog(playerid, dialogid);
      	                }
      	                SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "����� #%d: ���������� ������� �� %s[%d]", redit_id[playerid], VehParams[model - 400][VEH_NAME], model);
						mysql_format(g_SQL, string, sizeof(string), "UPDATE `races` SET `vehicle` = '%d' WHERE `id` = '%d'", model, redit_id[playerid]);
						mysql_query_ex(string);
      	            }
      	        }
   	            ShowDialog(playerid, DRACE_EDIT_PARAMS);
      	    }
      	    else ShowDialog(playerid, DRACE_EDIT_PARAMS);
      	}
      	case DRACE_DELCP:
      	{
		    if(response)
		    {
				if(!strlen(inputtext) || (strcmp(inputtext, "delcp", true) && strcmp(inputtext, "��������", true)))
				{
				    ShowDialog(playerid, dialogid);
				    return 1;
				}
				if(RaceInfo[rStatus] != 0 && RaceInfo[rID] == redit_id[playerid])
				{
				    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���������� ������� ��������� ���������� �����.");
				    return callcmd::race(playerid, "");
				}
				// ��������
				mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `race_cp` WHERE `raceid` = '%d' AND `id` >= '%d'", redit_id[playerid], redit_curid[playerid]);
				new Cache:result = mysql_query(g_SQL, string);
				new deleted = cache_affected_rows();
				cache_delete(result);
                format(string, 128, "����� #%d: ������� %d ����������, ������� � #%d", redit_id[playerid], deleted, redit_num[playerid]);
                SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
                //---
				if(redit_num[playerid] > 1)
				{
				    redit_num[playerid] -= 1;
					redit_previd[playerid] = ShowPlayerEditCP(playerid, redit_num[playerid]-1);
					redit_curid[playerid] = ShowPlayerEditCP(playerid, redit_num[playerid]);
				}
				else
				{
				    redit_num[playerid] = 1;
   				    redit_curid[playerid] = 0;
   				    redit_previd[playerid] = 0;
					DisablePlayerRaceCheckpoint(playerid);
				}
            }
      	}
      	case DRACE_DELETE:
      	{
		    if(response)
		    {
		        if(redit_id[playerid] == 0)
		        {
		            ShowDialog(playerid, DRACE_LIST);
		            return 1;
		        }
				if(!strlen(inputtext) || (strcmp(inputtext, "delete", true) && strcmp(inputtext, "�������", true)))
				{
				    ShowDialog(playerid, dialogid);
				    return 1;
				}
				if(RaceInfo[rStatus] != 0 && RaceInfo[rID] == redit_id[playerid])
				{
				    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���������� ������� ���������� �����.");
				    return ShowDialog(playerid, DRACE_EDIT);
				}
				// ��������
				mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `races` WHERE `id` = '%d'", redit_id[playerid]);
				mysql_query_ex(string);
				mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `race_spawn` WHERE `raceid` = '%d'", redit_id[playerid]);
				mysql_query_ex(string);
				mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `race_cp` WHERE `raceid` = '%d'", redit_id[playerid]);
				mysql_query_ex(string);
				mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `race_object` WHERE `raceid` = '%d'", redit_id[playerid]);
				mysql_query_ex(string);

				// �����������
				foreach(LoginPlayer, i)
				{
					if(redit_id[i] == redit_id[playerid])
					{
						if(i == playerid)
						{
							format(string, 128, "����� #%d: ������� �������", redit_id[i]);
							SendClientMessage(i, COLOR_LIGHTRED, string);
						}
						else
						{
							format(string, 128, "����� #%d: %s[%d] ������ ��� ������ ������������� �����", redit_id[i], ReturnPlayerName(playerid), playerid);
							SendClientMessage(i, COLOR_LIGHTRED, string);
						}
						MyHidePlayerDialog(i);
						callcmd::race(i, "");
						redit_id[i] = 0;
					}
				}
            }
            else ShowDialog(playerid, DRACE_EDIT);
      	}
		//---
      	case DPOKER_GAMESETUP:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: // Buy-In Max
					{
						ShowDialog(playerid, DPOKER_GAMESETUP2);
					}
					case 1: // Buy-In Min
					{
						ShowDialog(playerid, DPOKER_GAMESETUP3);
					}
					case 2: // Blind
					{
						ShowDialog(playerid, DPOKER_GAMESETUP4);
					}
					case 3: // Limit
					{
						ShowDialog(playerid, DPOKER_GAMESETUP5);
					}
					case 4: // Password
					{
						ShowDialog(playerid, DPOKER_GAMESETUP6);
					}
					case 5: // Round Delay
					{
						ShowDialog(playerid, DPOKER_GAMESETUP7);
					}
					case 6: // Start Game
					{
						ShowDialog(playerid, DPOKER_GAMESBUY);
					}
				}
			}
			else LeavePokerTable(playerid);
		}
		case DPOKER_GAMESETUP2:
		{
			if(response)
			{
				new money = strval(inputtext);
				if(!(0 < strlen(inputtext) < 10) || money <= 0 || money > 1000000000)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
		            return ShowDialog(playerid, dialogid);
		        }
				if(money <= PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBuyInMin])
				{
					return ShowDialog(playerid, dialogid);
				}
				PokerTable[GetPVarInt(playerid, "pkrTableID") - 1][pkrBuyInMax] = money;
			}
			ShowDialog(playerid, DPOKER_GAMESETUP);
		}
		case DPOKER_GAMESETUP3:
		{
			if(response)
			{
				new money = strval(inputtext);
				if(!(0 < strlen(inputtext) < 10) || money <= 0 || money > 1000000000)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
		            return ShowDialog(playerid, dialogid);
		        }
				if(money >= PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBuyInMax])
				{
					ShowDialog(playerid, DPOKER_GAMESETUP3);
					return false;
				}
				PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBuyInMin] = money;
			}
			ShowDialog(playerid, DPOKER_GAMESETUP);
		}
		case DPOKER_GAMESETUP4:
		{
			if(response)
			{
				new money = strval(inputtext);
				if(!(0 < strlen(inputtext) < 10) || money <= 0 || money > 1000000000)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
		            return ShowDialog(playerid, dialogid);
		        }
				PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrBlind] = money;
			}
			ShowDialog(playerid, DPOKER_GAMESETUP);
		}
		case DPOKER_GAMESETUP5:
		{
			if(response)
			{
				if(strval(inputtext) < 2 || strval(inputtext) > 6)
				{
					return ShowDialog(playerid, DPOKER_GAMESETUP5);
				}
				PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrLimit] = strval(inputtext);
			}
			ShowDialog(playerid, DPOKER_GAMESETUP);
		}
		case DPOKER_GAMESETUP6:
		{
			if(response)
			{
				new tableid = GetPVarInt(playerid, "pkrTableID") - 1;
				strmid(PokerTable[tableid][pkrPass], inputtext, 0, strlen(inputtext), 32);
			}
			ShowDialog(playerid, DPOKER_GAMESETUP);
		}
		case DPOKER_GAMESETUP7:
		{
			if(response)
			{
				new delay = strval(inputtext);
				if(delay < 15 || delay > 120)
				{
					return ShowDialog(playerid, dialogid);
				}
				PokerTable[GetPVarInt(playerid, "pkrTableID") - 1][pkrSetDelay] = delay;
			}
			ShowDialog(playerid, DPOKER_GAMESETUP);
		}
		case DPOKER_GAMESBUY:
		{
			if(response)
			{
				new tableid = GetPVarInt(playerid, "pkrTableID") - 1,
					count = strval(inputtext),
					chips = Inv.GetThing(playerid, THING_CHIPS);
				if(count < PokerTable[tableid][pkrBuyInMin]
				|| count > PokerTable[tableid][pkrBuyInMax]
				|| count > chips)
				{
					return ShowDialog(playerid, dialogid);
				}
				PokerTable[tableid][pkrActivePlayers]++;
				SetPVarInt(playerid, "pkrChips", GetPVarInt(playerid, "pkrChips") + count);
				Inv.PlayerDeleteThing(playerid, THING_CHIPS, 0, count);

				if(PokerTable[tableid][pkrActive] == 3 && PokerTable[tableid][pkrRound] == 0 && PokerTable[tableid][pkrDelay] >= 6)
				{
					SetPVarInt(playerid, "pkrStatus", 1);
				}
				else if(PokerTable[tableid][pkrActive] < 3)
				{
					SetPVarInt(playerid, "pkrStatus", 1);
				}

				if(PokerTable[tableid][pkrActive] == 1 && GetPVarInt(playerid, "pkrRoomLeader"))
				{
					PokerTable[tableid][pkrActive] = 2;
					SelectTextDraw(playerid, COLOR_GOLD);
				}
			}
			else LeavePokerTable(playerid);
		}
		case DPOKER_GAMESCALL:
		{
			if(response)
			{
				new tableid = GetPVarInt(playerid, "pkrTableID") - 1;
				new actualBet = PokerTable[tableid][pkrActiveBet]-GetPVarInt(playerid, "pkrCurrentBet");

				if(actualBet > GetPVarInt(playerid, "pkrChips"))
				{
					PokerTable[tableid][pkrPot] += GetPVarInt(playerid, "pkrChips");
					SetPVarInt(playerid, "pkrChips", 0);
					SetPVarInt(playerid, "pkrCurrentBet", PokerTable[tableid][pkrActiveBet]);
				}
				else
				{
					PokerTable[tableid][pkrPot] += actualBet;
					SetPVarInt(playerid, "pkrChips", GetPVarInt(playerid, "pkrChips")-actualBet);
					SetPVarInt(playerid, "pkrCurrentBet", PokerTable[tableid][pkrActiveBet]);
				}
				SetPVarString(playerid, "pkrStatusString", "Call");
				PokerRotateActivePlayer(tableid);
				ApplyAnimation(playerid, "CASINO", "cards_raise", 4.1, 0, 1, 1, 1, 1, 1);
			}
			DeletePVar(playerid, "pkrActionChoice");
		}
		case DPOKER_GAMESRAISE:
		{
			if(response)
			{
				new tableid = GetPVarInt(playerid, "pkrTableID")-1;
				new actualRaise = strval(inputtext)-GetPVarInt(playerid, "pkrCurrentBet");
				if(strval(inputtext) >= PokerTable[tableid][pkrActiveBet]+PokerTable[tableid][pkrBlind]/2 && strval(inputtext) <= GetPVarInt(playerid, "pkrCurrentBet")+GetPVarInt(playerid, "pkrChips"))
				{
					PokerTable[tableid][pkrPot] += actualRaise;
					PokerTable[tableid][pkrActiveBet] = strval(inputtext);
					SetPVarInt(playerid, "pkrChips", GetPVarInt(playerid, "pkrChips")-actualRaise);
					SetPVarInt(playerid, "pkrCurrentBet", PokerTable[tableid][pkrActiveBet]);

					SetPVarString(playerid, "pkrStatusString", "Raise");

					PokerTable[tableid][pkrRotations] = 0;
					PokerRotateActivePlayer(tableid);

					ApplyAnimation(playerid, "CASINO", "cards_raise", 4.1, 0, 1, 1, 1, 1, 1);
				}
				else ShowDialog(playerid, DPOKER_GAMESRAISE);
			}
			DeletePVar(playerid, "pkrActionChoice");
		}
		//	chips
		case DCHIPS_MENU:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: // Buy
					{
						ShowDialog(playerid, DCHIPS_BUY);
					}
					case 1: // Sell
					{
						ShowDialog(playerid, DCHIPS_SELL);
					}
				}
			}
		}
		case DCHIPS_BUY:
		{
			if(response)
			{
				new count = strval(inputtext);
				if(!(0 < strlen(inputtext) < 10) || count <= 0 || count > 10000000)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
		            return ShowDialog(playerid, dialogid);
		        }
				BuyChips(playerid, count);
				ShowDialog(playerid, dialogid);
			}
			else
			{
				ShowDialog(playerid, DCHIPS_MENU);
			}
		}
		case DCHIPS_SELL:
		{
			if(response)
			{
				new count = strval(inputtext);
				if(!(0 < strlen(inputtext) < 10) || count <= 0 || count > 10000000)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
		            return ShowDialog(playerid, dialogid);
		        }
		        SellChips(playerid, count);
				ShowDialog(playerid, dialogid);
			}
			else
			{
				ShowDialog(playerid, DCHIPS_MENU);
			}
		}
		//-- case
	}
	return true;
	// end of stock ShowDialog
}

public OnFadeComplete(playerid, fadeid)
{
	new string[256];
	switch(fadeid)
	{
		/*case FADE_ENTER:
		{
			//	system
			new e = fade_EnterID[playerid], side = fade_Side[playerid];
			SetCameraBehindPlayer(playerid);
			if(side == 1)
			{
				MySetPlayerPos(playerid, EnterInfo[e][exX], EnterInfo[e][exY], EnterInfo[e][exZ], EnterInfo[e][exA] + 180, EnterInfo[e][exInt], EnterInfo[e][exVW]);
				if(EnterInfo[e][exFreeze] == false)	TogglePlayerControllable(playerid, true);
				else 								SetTimerEx("MyUnfreezePlayer", 2000, false, "i", playerid);
			}
			else
			{
				MySetPlayerPos(playerid, EnterInfo[e][enX], EnterInfo[e][enY], EnterInfo[e][enZ], EnterInfo[e][enA] + 180, 0, 0);
				if(EnterInfo[e][enFreeze] == false)	TogglePlayerControllable(playerid, true);
				else 								SetTimerEx("MyUnfreezePlayer", 2000, false, "i", playerid);
			}
			FadeColorForPlayer(playerid, 0, 0, 0, 255, 0, 0, 0, 0, 10);
			OnPlayerEnterExitFinish(playerid, e, side);
		}*/
		case FADE_TELEPORT:
		{
			SetCameraBehindPlayer(playerid);
			MySetPlayerPos(playerid, Arr4<fade_TPToPos[playerid]>, fade_Interior[playerid], fade_VirtualWorld[playerid]);
			FadeColorForPlayer(playerid, 0, 0, 0, 255, 0, 0, 0, 0, 10);
			fade_Teleporting[playerid] = 0;
			if(fade_Freeze[playerid] == false)	TogglePlayerControllable(playerid, true);
			else 								SetTimerEx("MyUnfreezePlayer", 2000, false, "i", playerid);

			switch(Fade_TeleportID[playerid])
			{
				case FT_NONE:
				{
					//	---	//
				}
				case FT_BIZ:
				{
					new biz = GetBizWhichPlayer(playerid);
					if(biz != INVALID_DATA)
					{
						if(BizInfo[biz][bRobbery] != INVALID_PLAYER_ID)
						{
							PlayerPlaySound(playerid, 3401, 0.0, 0.0, 0.0);
						}
						if(BizInfo[biz][bType] == BUS_SHOP)
						{	// ������� 24/7
							SendClientMessage(playerid, COLOR_WHITE, PREFIX_HINT "����� ������ ������� - ���������������� � ��������� ("SCOLOR_HINT"��� + h"SCOLOR_WHITE").");
						}
					}
				}
				case FT_HOUSE:
				{
					new house = GetPlayerHouseID(playerid);
					if(house >= 0)
					{
						if(HouseInfo[house][hOwnerID] == PlayerInfo[playerid][pUserID] && FoundHouse(PlayerInfo[playerid][pHousing]) != house)
						{
							ShowPlayerHint(playerid, "����������� ~y~H ~w~��� ~y~/home~n~~w~����� ����������� � ����");
						}
					}
				}
				case FT_HROOM_EXIT:
				{
				#if defined _player_achieve_included	
					if(gMissionProgress[playerid][MIS_SOURCE_TRAINING] == 1)
					{
						GivePlayerAchieve(playerid, ACHIEVE_URBAN);
					}
				#endif
				}
				case FT_AUTOSCHOOL:
				{
					AS_ClearVars(playerid);
				}
				case FT_TIR:
				{
			    	MyChangePlayerWeapon(playerid, true);
			    	MyGivePlayerWeapon(playerid, 22, TirMissionInfo[ PlayerInfo[playerid][pShooting] - 1 ][TIR_AMMO]);
			    	format(string, sizeof(string), "~n~~n~~n~~w~Wave: %d~n~~y~GET READY!", PlayerInfo[playerid][pShooting]);
			    	GameTextForPlayer(playerid, string, 4900, 6);
			    	TogglePlayerControllable(playerid, false);
					SetTimerEx("MyUnfreezePlayer", 4000, false, "i", playerid);
			    	p_isShooting{playerid} = true;
			    	p_ShootingCountdown{playerid} = 5;
				}
				case FT_TIR_COMPLETE:
				{
			    	SuccesAnim(playerid);
					PlayerPlaySound(playerid, 36205, 0.0, 0.0, 0.0);
					SendClientMessage(playerid, COLOR_GREEN, "�����������, ������ ������������� � ����������� ������� ��� ������ � ��������� �������� �� ������!");
				}
			}

			//---	Mission
			if(GetPVarInt(playerid, "Mission:CompleteMission") == MIS_HOTEL)
			{
				DeletePVar(playerid, "Mission:CompleteMission");
				StoryMissionComplete(playerid, MIS_SOURCE_TRAINING, 0, 0);
			}
		}
	#if defined	_job_job_theft_included	
		case FADE_THEFT:
		{
			if(TheftStatus[playerid] == 2)
			{
				Job.ClearPlayerNowWork(playerid);
			}
		}
	#endif	
		default:
		{
			new cutstate = GetPVarInt(playerid, "RegCutSceneState");
			if(cutstate)
			{
				if(cutstate == 1)		RegisterCutScene(playerid, 2, 1, 1);
				else if(cutstate == 2)	RegisterCutScene(playerid, 13, 1, 1);
				else if(cutstate == 3)	RegisterCutScene(playerid, 21, 1, 1);
				SetPVarInt(playerid, "RegCutSceneState", 999);
			}
			else if(GetPVarInt(playerid, "PrisonCycle") == 2)
			{
				DeletePVar(playerid, "PrisonCycle");
				SetPlayerPrisonPos(playerid, LastPrisonStatus);
		    	MySpawnPlayer(playerid); // �����
			}
		}
	}
	return true;
}

Public: OnVisualTimerComplete(playerid)
{
	if(p_isShooting{playerid} && p_ShootingHits{playerid} < 7)
	{
		return FinishPlayerShooting(playerid, true);
	}
	return true;
}

public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{
	printf("OnPlayerSelectDynamicObject: %d, %d, %f, %f, %f", objectid, modelid, x, y, z);
	EditDynamicObject(playerid, objectid);
	return true;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	#if defined _inventory_acsr_included
		Callback: Acsr.OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
	#endif

	if(response)
	{
	    printf("%d %d %f %f %f %f %f %f %f %f %f", modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
	}
    return true;
}

// new _graffiti;
// CMD:graffiti(playerid, params[])
// {
// 	new Float:pos[3];
// 	MyGetPlayerPos(playerid, Arr3<pos>);
// 	_graffiti = CreateDynamicObject(18659, Arr3<pos>, 0.0, 0.0, 0.0);
// 	SelectObject(playerid);
// 	return true;
// }

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(IsValidDynamicObject(objectid) == 0)	return true;

	new string[256];
	if(response == EDIT_RESPONSE_FINAL)
	{ 	//  Save
		if(GetPVarType(playerid, "Fur:HouseID") != PLAYER_VARTYPE_NONE)
		{
			new h = GetPVarInt(playerid, "Fur:HouseID");
			new Class = HouseInfo[h][hClass] - 1,
	        	Int = HouseInfo[h][hInt] - 1;
			if(GetPVarInt(playerid, "fur_editid"))
			{
				for(new i = 0; i < 8; i++)	SetDynamicObjectMaterial(objectid, i, -1, "none", "none", 0);
				if(GetDistanceFromPointToPoint(Arr3<InterCoords[Class][Int]>, x, y, z) > 50)
				{
					SendClientMessage(playerid, COLOR_LIGHTRED, "������ �� ����� ���� ���������� �����");
					CancelEditHomeObject(playerid);
				}
				else
				{
					mysql_format(g_SQL, string, sizeof(string), "UPDATE `furniture` SET `x` = '%f', `y` = '%f', `z` = '%f', `rx` = '%f', `ry` = '%f', `rz` = '%f' WHERE `dynamic_id` = '%d'", x, y, z, rx, ry, rz, objectid);
					mysql_query_ex(string);
					SendClientMessage(playerid, COLOR_LIGHTGREEN, "������ ������� ��������������!");
					DeletePVar(playerid, "fur_editid");
				}
			}
			else if(GetPVarInt(playerid, "fur_creteid"))
			{
				if(GetDistanceFromPointToPoint(Arr3<InterCoords[Class][Int]>, x, y, z) > 50)
				{
					SendClientMessage(playerid, COLOR_LIGHTRED, "������ �� ����� ���� ���������� �����");
					CancelEditHomeObject(playerid);
				}
				else
				{
				    new model = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);
				    for(new i = 0; i < 8; i++)	SetDynamicObjectMaterial(objectid, i, -1, "none", "none", 0);
				    for(new i = 0; i < sizeof(FurnitureList); i++)
					{
						if(model == FurnitureList[i][fID])
						{
							mysql_format(g_SQL, string, sizeof(string), "UPDATE `furniture` SET `x` = '%f', `y` = '%f', `z` = '%f', `rx` = '%f', `ry` = '%f', `rz` = '%f', `set` = 1, `dynamic_id` = '%d', `fur_num` = '%d' WHERE `id` = '%d'", x, y, z, rx, ry, rz, objectid, i, GetPVarInt(playerid, "fur_creteid"));
							mysql_query_ex(string);
							break;
						}
					}
				    SendClientMessage(playerid, COLOR_LIGHTGREEN, "������ ������� ���������� � ��� ���!");
				    DeletePVar(playerid, "fur_creteid");
					DeletePVar(playerid, "fur_crete_obj_id");
				}
			}
			DeletePVar(playerid, "Fur:HouseID");
		}
		else
		{
			/*if(_graffiti)
			{

				for(new j = 0; j < sizeof(GangZones); j++)
				{
					if(IsCoordInSquare(x, y, Arr4<GangZones[j]>))
					{
						new query[256];
						mysql_format(g_SQL, query, sizeof query, "UPDATE `gang_zones` SET `graffiti_x` = '%f', `graffiti_y` = '%f', `graffiti_z` = '%f', `graffiti_a` = '%f' WHERE `id` = '%d'", x, y, z, rz, GangZoneID[j]);
						mysql_query_ex(query);
						break;
					}
				}
				DestroyDynamicObject(_graffiti);
				_graffiti = 0;
			}*/
			printf("%f %f %f %f %f %f", x, y, z, rx, ry, rz);
		}
	}
	else if(response == EDIT_RESPONSE_CANCEL)
	{
		CancelEditHomeObject(playerid);	//  Cancel
	}
	//else if(response == EDIT_RESPONSE_UPDATE)
	//{
		//SetDynamicObjectPos(objectid, x, y, z);
		//SetDynamicObjectRot(objectid, rx, ry, rz);
	//}
	return true;
}

stock CancelEditHomeObject(playerid)
{
	if(GetPVarType(playerid, "Fur:HouseID") != PLAYER_VARTYPE_NONE)
	{
	    if(GetPVarInt(playerid, "fur_editid"))
		{
		    new string[256];
			new objectid = GetPVarInt(playerid, "fur_editid");
			mysql_format(g_SQL, string, sizeof(string), "SELECT `x`, `y`, `z`, `rx`, `ry`, `rz` FROM `furniture` WHERE `dynamic_id` = '%d'", objectid);
			new Cache:result = mysql_query(g_SQL, string);
			if(!cache_num_rows())
			    return SendClientMessage(playerid, COLOR_RED, "��������� ����������� ������ ��� ��������������!");

			new Float:pos[6];
			cache_get_value_name_float(0, "x", pos[0]);
			cache_get_value_name_float(0, "y", pos[1]);
			cache_get_value_name_float(0, "z", pos[2]);
			cache_get_value_name_float(0, "rx", pos[3]);
			cache_get_value_name_float(0, "ry", pos[4]);
			cache_get_value_name_float(0, "rz", pos[5]);    

			SetDynamicObjectPos(objectid, Arr3<pos>);
			SetDynamicObjectRot(objectid, pos[3], pos[4], pos[5]);
			for(new i = 0; i < 8; i++)	SetDynamicObjectMaterial(objectid, i, -1, "none", "none", 0);
			cache_delete(result);

			SendClientMessage(playerid, COLOR_LIGHTGREEN, "�������������� �������� ��������");
			DeletePVar(playerid, "fur_editid");
		}
		else if(GetPVarInt(playerid, "fur_creteid"))
		{
		    DestroyDynamicObject(GetPVarInt(playerid, "fur_crete_obj_id"));
			SendClientMessage(playerid, COLOR_LIGHTGREEN, "��������� �������� ��������");
			DeletePVar(playerid, "fur_creteid");
			DeletePVar(playerid, "fur_crete_obj_id");
		}
		CancelEdit(playerid);
		//CancelSelectTextDraw(playerid);
		DeletePVar(playerid, "Fur:HouseID");
	}
	return true;
}

stock BuyPlayerFurniture(playerid)
{
	BuyFurFurCategory[playerid] = 0;
	BuyFurSelectItem[playerid] = -1;
    if(IFace.GetGroupToggleAndVisible(playerid, IFace.HOUSE_FUR))
	{
		IFace.ToggleGroup(playerid, IFace.HOUSE_FUR, false);
	    CancelSelectTextDraw(playerid);
	}
	else
	{
		new house = GetPlayerHouseID(playerid);
		if(house == -1)
		{
	    	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���� � ����, ����� ������������ ��� �������.");
	    	return false;
		}
	    if(HouseInfo[house][hOwnerID] != PlayerInfo[playerid][pUserID])
	    {
	    	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �������� ����� ����.");
	    	return false;
	    }
	    IFace.ToggleGroup(playerid, IFace.HOUSE_FUR, true);
	    IFace.House_FurSetTitle(playerid, FurCategories[ BuyFurFurCategory[playerid] ]);
        IFace.House_FurSetInfo(playerid, "_");
        IFace.House_FurSetPage(playerid, BuyFurFurCategory[playerid] + 1, sizeof(FurCategories));
		CreateFurnituresModels(playerid, BuyFurFurCategory[playerid]);

	    SelectTextDraw(playerid, 0xACCBF1FF);
	}
	return true;
}

stock CreateFurnituresModels(playerid, category)
{
	for(new i = 0, x = 0; x < SELECTION_ITEMS; i++)
	{
	    if(i < sizeof(FurnitureList) && FurnitureList[i][fType] == category)
	    {
			IFace.House_FurAddItem(playerid, x++, FurnitureList[i][fID]);
	    }
	    else
	    {
	    	IFace.House_FurHideItem(playerid, i);
	    }
	}
	return true;
}

stock GetOccupiedFurSlots(houseid)
{
    new string[128], count;
	mysql_format(g_SQL, string, sizeof(string), "SELECT COUNT(*) AS count FROM `furniture` WHERE `house_id` = '%d'", HouseInfo[houseid][hID]);
	new Cache:result = mysql_query(g_SQL, string);
	cache_get_value_name_int(0, "count", count);
	cache_delete(result);
	return count;
}

stock GetHouseFurSlot(houseid)
{
	return MAX_FURNITURE - 8 * (HouseInfo[houseid][hClass] - 1) + HouseInfo[houseid][hExtraSlots];
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if(GetPlayerAdmin(playerid) >= ADMIN_IVENTER)
	{
		new Float:z;
		CreateGotoSmoke(playerid);
		MapAndreas_FindZ_For2DCoord(fX, fY, z);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
	    if(GetPlayerState(playerid) == 2)
		{
		    new vehicleid = GetPlayerVehicleID(playerid);
			MySetVehiclePos(vehicleid, fX, fY, z + 2.0);
			LinkVehicleToInterior(vehicleid, 0);
			SetVehicleVirtualWorld(vehicleid, 0);
		}
		else MySetPlayerPos(playerid, fX, fY, z + 2.0);
	}
	else
	{
		ShowPlayerGPSPoint(playerid, fX, fY, fZ);
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "��������� ����� �������� �� ������ "SCOLOR_GPS"������ ��������");
	}
    return true;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	if(IsPlayerLogged(playerid) == 0)
	{
	    return false;
	}
	if((gBlockAction[playerid] & 1))
	{
		return false;
	}
	//--- ��������
	new tick = GetTickCount();
	if(tick - StartupAntiflood[playerid] < 800)
	{
	    StartupAntiflood[playerid] = tick;
	    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��� ������.");
	    return false;
	}
	StartupAntiflood[playerid] = tick;
	//---	check flags
	if( (flags & CMD_RCON) && GetPlayerAdmin(playerid) < ADMIN_RCON
	||  (flags & CMD_DEVELOPER) && GetPlayerAdmin(playerid) < ADMIN_DEVELOPER
	||	(flags & CMD_GADMIN) && GetPlayerAdmin(playerid) < ADMIN_GADMIN
	||	(flags & CMD_ADMIN) && GetPlayerAdmin(playerid) < ADMIN_ADMIN
	||	(flags & CMD_MODER) && GetPlayerAdmin(playerid) < ADMIN_MODER
	||	(flags & CMD_IVENTER) && GetPlayerAdmin(playerid) < ADMIN_IVENTER
	||	(flags & CMD_HELPER) && GetPlayerAdmin(playerid) < ADMIN_HELPER)
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��� �������.");
        return false;
	}
	return true;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
	if(result == (-1))
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����������� �������, ����������� /help.");
	}
	return true;
}

//	[BT] Commands
CMD:preview(playerid) 
{ 
	CallRemoteFunction("ShowPreviewEditor", "d", playerid); 
	SelectTextDraw(playerid, 0x2D3036FF); 
	return 1; 
}

flags:repairdoor(CMD_DEVELOPER);
CMD:repairdoor(playerid, params[])
{
	NearAirportDoorPlayers = 0;
    MyMoveDynamicObject(AirportDoor[0], 1684.27, -2335.98, 12.56, 1.5, -1000.0, -1000.0, -1000.0);
	MyMoveDynamicObject(AirportDoor[1], 1687.27, -2335.94, 12.56, 1.5, -1000.0, -1000.0, -1000.0);
	SendClientMessage(playerid, -1, "����� �������������!");
	return true;
}

flags:vtimer(CMD_DEVELOPER);
CMD:vtimer(playerid, params[])
{// [BT]
    new string[128];
    if(sscanf(params, "s[32] ", string))
        return SendClientMessage(playerid, COLOR_WHITE, "�����������: /vtimer [set/update/hide]");
	if(strcheck(string, "set"))
	{
		new time, bool:update;
		if(sscanf(params, "{s[32]}ib", time, update))
		    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /vtimer set [time] [autoupdate]");
		SetPlayerVisualTimer(playerid, time, update);
	}
	else if(strcheck(string, "update"))
	{
		new time;
		if(sscanf(params, "{s[32]}i", time))
		    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /vtimer update [time]");
		SetPlayerVisualTimer(playerid, time, false);
	}
	else if(strcheck(string, "hide"))
		HidePlayerVisualTimer(playerid);
	else
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ �������� � ���� ������� �� ����������.");
	return true;
}

flags:jailperiod(CMD_DEVELOPER);
CMD:jailperiod(playerid, params[])
{// [BT]
    new string[128];
    if(sscanf(params, "s[32] ", string))
        return SendClientMessage(playerid, COLOR_WHITE, "�����������: /jailperiod [update/hide]");
	if(strcheck(string, "hide"))
		PlayerTextDrawHide(playerid, p_JailPeriod);
	else if(strcheck(string, "update"))
	{
		new title[32];
		if(sscanf(params, "{s[32]}s[32]", title))
		    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /jailperiod update [title]");
		PlayerTextDrawSetString(playerid, p_JailPeriod, RusText(title, isRus(playerid)));
		PlayerTextDrawShow(playerid, p_JailPeriod);
	}
	else
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ �������� � ���� ������� �� ����������.");
	return true;
}

/*
flags:setcam(CMD_DEVELOPER);
CMD:setcam(playerid, params[])
{// [BT]
	TogglePlayerSpectating(playerid, true);
	IFace.ToggleTVEffect(playerid, true);
	RegisterCutScene(playerid, strval(params), 0, 0);
	return true;
}*/

flags:cutscene(CMD_DEVELOPER);
CMD:cutscene(playerid, params[])
{// [BT]
	KillTimer(LoginCameraTimer[playerid]);
	if(strval(params) == 0){
		TogglePlayerSpectating(playerid, false);
	}
	else{
		TogglePlayerSpectating(playerid, true);
		RegisterCutScene(playerid, strval(params), 1, 1);
	}
	return true;
}

flags:testjail(CMD_DEVELOPER);
CMD:testjail(playerid, params[])
{// [BT]
	new val = strval(params);
	if(val == 1){
		SetPlayerPos(playerid, 691.6, -2917.4, 1700.4);
		SetPlayerFacingAngle(playerid, 270.0);
		SetPlayerCameraPos(playerid, 693.5, -2917.4, 1700.8);
		SetPlayerCameraLookAt(playerid, 690.0, -2917.4, 1700.8);
	}
	else if(val == 2){
		SetPlayerFacingAngle(playerid, 180.0);
	}
	else{
		SetCameraBehindPlayer(playerid);
	}
	return true;
}

flags:testcycle(CMD_DEVELOPER);
CMD:testcycle(playerid, params[])
{// [BT]
	PlayerInfo[playerid][pJailTime] = gettime() + 600;
	SetPVarInt(playerid, "PrisonCycle", 1);
    TogglePlayerSpectating(playerid, 1);
	IFace.ToggleTVEffect(playerid, true);
	PrisonCycle(playerid, 4);
	return true;
}

flags:vrecord(CMD_DEVELOPER);
CMD:vrecord(playerid, params[])
{// [BT]
	if(sscanf(params, "s[256]", params))
	    return SendClientMessage(playerid,0xFF0000FF,"Usage: /vrecord {name}");
	if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid,0xFF0000FF,"Recording: Get in a vehicle.");

	StartRecordingPlayerData(playerid,PLAYER_RECORDING_TYPE_DRIVER,params);
	SendClientMessage(playerid,0xFF0000FF,"Recording: started. (Use: /stoprecord to stop)");
	return 1;
}

flags:ofrecord(CMD_DEVELOPER);
CMD:ofrecord(playerid, params[])
{// [BT]
	if(sscanf(params, "s[256]", params))
	    return SendClientMessage(playerid,0xFF0000FF,"Usage: /ofrecord {name}");
	if(IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid,0xFF0000FF,"Recording: Leave the vehicle and reuse the command.");

	StartRecordingPlayerData(playerid,PLAYER_RECORDING_TYPE_ONFOOT,params);
	SendClientMessage(playerid,0xFF0000FF,"Recording: started. (Use: /stoprecord to stop)");
	return 1;
}

flags:stoprecord(CMD_DEVELOPER);
CMD:stoprecord(playerid, params[])
{// [BT]
	StopRecordingPlayerData(playerid);
	SendClientMessage(playerid,0xFF0000FF,"Recording: stopped.");
	return 1;
}

flags:test1(CMD_DEVELOPER);
CMD:test1(playerid, params[])
{// [BT]
	SendAdminMessage(COLOR_ADMIN, "����� ��������� ���������� ���: �������������", PC_HasFlag("test1", CMD_DEVELOPER));
	return 1;
}

//flags:test2(CMD_DEVELOPER);
CMD:test2(playerid, params[])
{// [BT]
	SendClientMessage(playerid, -1, params);
	return 1;
}

flags:test3(CMD_DEVELOPER);
CMD:test3(playerid, params[])
{// [BT]
	PursuitLastUNIX[playerid] = 0;
	PlayerInfo[playerid][pNextFriskTime] = 0;
	return true;
}

flags:test4(CMD_DEVELOPER);
CMD:test4(playerid, params[])
{// [BT]
	OnPlayerPickUpDynamicPickup(playerid, PoliceDutyPickup);
	return true;
}

flags:test5(CMD_DEVELOPER);
CMD:test5(playerid, params[])
{// [BT]
	new string[128];
	format(string, sizeof(string), "���������� ����� ���: %d", gettime() / 86400);
	SendClientMessage(playerid, COLOR_SERVER, string);
	return true;
}

//----

flags:walter(CMD_DEVELOPER);
CMD:walter(playerid, params[])
{
	CreateVanWalter();
	return true;
}

flags:gotowalter(CMD_DEVELOPER);
CMD:gotowalter(playerid, params[])
{// [BT]
	if(BB_Car == 0)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ������ �� ����� ���.");
	new Float:pos[3];
	GetVehiclePos(BB_Car, Arr3<pos>);
	MySetPlayerPos(playerid, pos[0] + 1.0, pos[1] + 1.0, pos[2]);
	SendClientMessage(playerid, COLOR_WHITE, "�� ��������������� � ������� �������");
	return true;
}

COMMAND:updates(playerid, params[])
{
	new lstring[1524] = "{FFFFFF}";
	strcat(lstring, "[*] ����������� ��������� ������\n\
	[*] ���������� ������ ������������ �������� �� ��������");
	return MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "���������� [30.10.2016 00:00]", lstring, "�����!", "");
}

COMMAND:rules(playerid, params[])
{
	new lstring[2500] = ""MAIN_COLOR"[������� �������]\n\
	{FFFFFF}- ��������� ������������ ����, ���������� ����������� ��� �������������� �����.\n\
	- ��������� ������������ ����� �������, ���� � ����������, ������� ����� ������ �����-���� ������������.\n\
	- ��������� ��������� ������������ ����, ������� ����� ������ �����-���� ������������.\n";
	strcat(lstring, "- ��������� ������������� ���, ��� �� ������� � ������� ���������.\n\
	- ��������� �������� �� ������ � ��������� ���������� ������.\n\
	- ��������� ������� ������� ��� ������� �� �� ������� (������������� ��������, ���������� ������� �� ��������).\n\
	  �������� ����� �������� ���������� ������ � ��������������� �� ������ ������� (������ - �����������, ������ - ������).\n\
	  ��� �� �������� ����� �������� ������������� ��� �������� ������� �� ���������� �������� �� ������� ������.\n");
	strcat(lstring, "- ��������� ��������, ���������� � ����������� ������ �� ��������.\n\
	- ��������� �������� ���� �� �������������� ��� ������, ��� ���� �� ������� �������.\n\
	- ��������� ������������� �������, ������������� �������� ������������� ��� �������� ��������� �������.\n\n");
	strcat(lstring, ""MAIN_COLOR"[��� �������]\n\
	{FFFFFF}- ��������� ���������� �������, �� ����������� ����������� � ��������� ��� ��� ���������� ��������� � ������������� ������.\n\
	- ��������� �������� �������, ���� ��� �� ��������� � �������� ��������.\n\
	- ��������� ���������� �������������, �� ����������� �������, ����� ������������� ��������� � ������� ��������.\n\
	- ��������� ��������� � ����������� �������� �������������, �� ����������� ���������� ���������� ��� �� ������.\n\n");
	strcat(lstring, ""MAIN_COLOR"[�������� � ��������]\n\
	{FFFFFF}- ��������� ��������� ������� �� ����������� ��� ������ ����������� (��������: '����� /quit � �������� �����')\n\
	- ��������� ����������� ������� �� ��������� ������ �������.\n\
	- ��������� ���������� ������� � ����� ��������� ���������� ��� �������� (������� ��������� � ��������� ����������� ��������).\n\
	- ��������� ���������/�������� ������� �������� (��������, ���������, ����) ������ �� ��������� �������� �(���) ������ ����� ��������.\n");
	strcat(lstring, "- ��������� ����������/�������� ���� �������.\n\
	- ��������� ��������� ������ (�������� ������ ���������) � ����� �������� � �������� ��������.\n\
	- ��������� ������������ ������ � ������, ���� �������� ������� ����� �� ��������� ������ ��� ��������������.\n\n\
	"MAIN_COLOR"[���������������]\n\
	{FFFFFF}- ��������� ������������ ����� ����������� � ������ �����");
	return MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "������� �������", lstring, "�������", "");
}

CMD:radio(playerid, params[])
{
	if(Acsr.GetSlotToType(playerid, ACSR_EARFLAPS) == INVALID_DATA)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���� � ���������.");
	}
 	if(PlayerInfo[playerid][pPhoneNumber] == 0)
    {
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������ ���� �������.");
    }
 	if(PlayerInfo[playerid][pPhoneEnable] == false)
    {
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������ ���� �������.");
    }
	ShowDialog(playerid, DMODE_RADIO_PLEER);
	return 1;
}

flags:neon(CMD_DEVELOPER);
COMMAND:neon(playerid, params[])
{// [BT]
	new num = strval(params);
	if(0 <= num <= 5)
	{
		if(AttachNeons(GetPlayerVehicleID(playerid), num))
		{
			SendClientMessage(playerid, COLOR_GREEN, "�����������");
		}
	}
	else
		SendClientMessage(playerid, COLOR_GREY, "�� ����� ������ ���� �� 0 �� 6");
	return true;
}

COMMAND:flash(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(CarInfo[vehicleid][cFlash] == 0)
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� �� ����������� �����������.");
		return true;
	}
	new flash;
	if(sscanf(params, "d", flash))
	{
		SendClientMessage(playerid, COLOR_GREY, "�����������: /flash [0-5]");
		return true;
	}
	if(SetVehicleFlasher(vehicleid, flash))
	{
		if(flash)	GameTextForPlayer(playerid, "~w~Strobe Lights ~g~ON", 3000, 4);
		else 		GameTextForPlayer(playerid, "~w~Strobe Lights ~r~OFF", 3000, 4);
	}
    return true;
}

COMMAND:debug(playerid, params[])
{// [BT]
	if(showDebug[playerid])
	{
	    PlayerTextDrawHide(playerid, debugTD);
	    SendClientMessage(playerid, COLOR_GREY, "������� ���������!");
	    showDebug[playerid] = false;
	}
	else
	{
		PlayerTextDrawShow(playerid, debugTD);
        SendClientMessage(playerid, COLOR_GREY, "������� ��������!");
        showDebug[playerid] = true;
	}
	return true;
}

COMMAND:dfur(playerid, params[])
{
    //  �������� ��������
	if(GetPVarInt(playerid, "fur_editid") || GetPVarInt(playerid, "fur_creteid"))
	{
		MyShowPlayerDialog(playerid, DHOME_FUR_ACCEPT_DEL,	DIALOG_STYLE_MSGBOX, "�������������� ������", "{FFFFFF}������������� ������ ������� ���� ������?", "��", "������");
	}
	else
	{
	    SendClientMessage(playerid, COLOR_WHITE, "�� �� ������������ ������!" );
	}
	return true;
}

/*COMMAND:allowdealer(playerid, params[])
{
    if(!IsMafia(PlayerInfo[playerid][pFaction])){
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ����� ����� �� �����.");
    }
    extract params -> new player:giveplayerid; else{
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /allowdealer [playerid/playername]");
    }
    new string[128];
    if(PlayerInfo[playerid][pFaction] == F_RUSMAF){

		SendFormatMessage(giveplayerid, COLOR_LIGHTBLUE, string, "%s %s ����� ��� ���������� �� �������� �������", GetPlayerRank(playerid), ReturnPlayerName(playerid));
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "�� ������ %s ���������� �� �������� �������", ReturnPlayerName(giveplayerid));
	    PlayerInfo[giveplayerid][pGunDealLic] = 1;
    }
    else if(PlayerInfo[playerid][pFaction] == F_LCN)
    {
		SendFormatMessage(giveplayerid, COLOR_LIGHTBLUE, string, "%s %s ����� ��� ���������� �� ���� ��������������", GetPlayerRank(playerid), ReturnPlayerName(playerid));
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "�� ������ %s ���������� �� ���� ��������������", ReturnPlayerName(giveplayerid));
	    PlayerInfo[giveplayerid][pTheftLic] = 1;
    }
	else if(PlayerInfo[playerid][pFaction] == F_YAKUZA){
		SendFormatMessage(giveplayerid, COLOR_LIGHTBLUE, string, "%s %s ����� ��� ���������� �� �������� �����������", GetPlayerRank(playerid), ReturnPlayerName(playerid));
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "�� ������ %s ���������� �� �������� �����������", ReturnPlayerName(giveplayerid));
	    PlayerInfo[giveplayerid][pDrugDealLic] = 1;
	}
	else{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ���������, ��� ��� ���������� ��� �������.");
	}
	return true;
}

COMMAND:deletedealer(playerid, params[])
{
	if(!IsMafia(PlayerInfo[playerid][pFaction])){
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ����� ����� �� �����.");
    }
    extract params -> new player:giveplayerid; else{
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /deletedealer [playerid/playername]");
    }
	new string[128];
	if(PlayerInfo[playerid][pFaction] == F_RUSMAF)
	{
		SendFormatMessage(giveplayerid, COLOR_LIGHTBLUE, string, "%s %s ������ � ��� ���������� �� �������� �������", GetPlayerRank(playerid), ReturnPlayerName(playerid));
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "�� ������� � %s ���������� �� �������� �������", ReturnPlayerName(giveplayerid));
	    PlayerInfo[giveplayerid][pGunDealLic] = 0;
		if(Job.GetPlayerJob(giveplayerid) == JOB_GUNDEAL)
		{
			Job.SetPlayerJob(giveplayerid, JOB_NONE);
			SendClientMessage(playerid, COLOR_GREY, "�� ������ �� ������ ����������� � ��������� ������");
			Job.UpdatePlayerMapIcon(playerid);
		}
	}
	else if(PlayerInfo[playerid][pFaction] == F_LCN)
	{
		SendFormatMessage(giveplayerid, COLOR_LIGHTBLUE, string, "%s %s ������ � ��� ���������� �� ���� ��������������", GetPlayerRank(playerid), ReturnPlayerName(playerid));
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "�� ������� � %s ���������� �� ���� ��������������", ReturnPlayerName(giveplayerid));
	    PlayerInfo[giveplayerid][pTheftLic] = 0;
		if(Job.GetPlayerJob(giveplayerid) == JOB_THEFT)
		{
			Job.SetPlayerJob(giveplayerid, JOB_NONE);
			SendClientMessage(playerid, COLOR_GREY, "�� ������ �� ������ ���������� � ������� �������������");
			Job.UpdatePlayerMapIcon(playerid);
		}
	}
	else if(PlayerInfo[playerid][pFaction] == F_YAKUZA)
	{
		SendFormatMessage(giveplayerid, COLOR_LIGHTBLUE, string, "%s %s ������ � ��� ���������� �� �������� �����������", GetPlayerRank(playerid), ReturnPlayerName(playerid));
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "�� ������� � %s ���������� �� �������� �����������", ReturnPlayerName(giveplayerid));
	    PlayerInfo[giveplayerid][pDrugDealLic] = 0;
		if(Job.GetPlayerJob(giveplayerid) == JOB_DRUGDEAL)
		{
			Job.SetPlayerJob(giveplayerid, JOB_NONE);
			SendClientMessage(playerid, COLOR_GREY, "�� ������ �� ������ ����������� � ��������� ���������");
			Job.UpdatePlayerMapIcon(playerid);
		}
	}
	else{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ���������, ��� ��� ���������� ��� �������.");
	}
	return true;
}*/

//  admin
flags:setwalk(CMD_DEVELOPER);
COMMAND:setwalk(playerid, params[])
{
	new giveplayerid, walk;
	if(sscanf(params, "rd", giveplayerid, walk))
	{
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /setwalk [playerid/playername][walk]");
	}
	new string[128];
    if(!IsPlayerLogged(giveplayerid))
    {
    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
    }
    if(!(0 <= walk <= 13))
    {
    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ������ ���� �� 0 �� 13.");
    }
  	SetPlayerWalkingStyle(giveplayerid, walk);
	format(string, 128, "[AdmCmd]: %s %s[%d] ����� %d ����� ������ ������ %s[%d]",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, walk, ReturnPlayerName(giveplayerid), giveplayerid);
	SendAdminMessage(COLOR_ADMIN, string);
	SendFormatMessage(giveplayerid, COLOR_LIGHTBLUE, string, "%s %s[%d] ����� ��� %d ����� ������", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, walk);
    return true;
}

flags:jailopen(CMD_DEVELOPER);
COMMAND:jailopen(playerid, params[])
{// [BT]
	JailDoorsMove(true);
	return SendClientMessage(playerid, COLOR_WHITE, "����� ����� �������!");
}

flags:jailclose(CMD_DEVELOPER);
COMMAND:jailclose(playerid, params[])
{// [BT]
	JailDoorsMove(false);
	return SendClientMessage(playerid, COLOR_WHITE, "����� ����� �������!");
}

flags:jailpos(CMD_DEVELOPER);
COMMAND:jailpos(playerid, params[])
{// [BT]
    SetPlayerPos(playerid, Arr3<JailPos[ strval(params) ]>);
    SetPlayerFacingAngle(playerid, JailPos[ strval(params) ][3]);
    return true;
}

flags:jailstatus(CMD_DEVELOPER);
COMMAND:jailstatus(playerid, params[])
{// [BT]
	new status = strval(params);
	if(1 <= status <= 4)	OnPrisonStatusChange(strval(params));
	else
	{
		SendClientMessage(playerid, COLOR_WHITE, "�����������: /jailstatus [1-4]");
		SendClientMessage(playerid, COLOR_WHITE, "1 - ������, 2 - ����, 3 - ��������, 4 - �����");
	}
    return true;
}

flags:setanim(CMD_DEVELOPER);
COMMAND:setanim(playerid, params[])
{// [BT]
	new lib[32], name[32], Float:fDelta, loop, lockx, locky, freeze, time, forcesync;
    if(sscanf(params, "s[32]s[32]fdddddd", lib, name, fDelta, loop, lockx, locky, freeze, time, forcesync))
 		return SendClientMessage( playerid, COLOR_WHITE, "�����������: /setanim [����������] [��������] [fDelta] [loop] [lockx] [locky] [freeze] [time] [forcesync]" );
    LoopingAnim(playerid, lib, name, fDelta, loop, lockx, locky, freeze, time, forcesync);
	return true;
}

flags:setelement(CMD_DEVELOPER);
COMMAND:setelement(playerid, params[])
{// [BT]
    new targetid, value;
	if(sscanf(params, "rd", targetid, value))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /setelement [playerid/playername] [��������]");
    if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
    new string[128];
	if(value < 0 || value > sizeof(AS_Mission) + 1)
		return SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "������� �������� �������� �� 0 �� %d.", sizeof(AS_Mission));
	PlayerInfo[targetid][pASElement] = value;
	UpdatePlayerBitData(playerid, "as_element", PlayerInfo[playerid][pASElement]);
	format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ������� ���������� ��������� �� %s[%d]: %d ��.",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid, value);
	SendAdminMessage(COLOR_ADMIN, string);
	SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ������� ��� ���-�� ���������� ��������� ��: %d ��.", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, value);
	return true;
}

flags:getelement(CMD_DEVELOPER);
COMMAND:getelement(playerid, params[])
{// [BT]
    new targetid;
	if(sscanf(params, "r", targetid))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /getelement [playerid/playername]");
    if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	new string[128];
	format(string, sizeof(string), "����� %s[%d] ����� ������� [%d] � ���������", ReturnPlayerName(targetid), targetid, PlayerInfo[targetid][pASElement]);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	return true;
}

flags:setlaw(CMD_DEVELOPER);
COMMAND:setlaw(playerid, params[])
{// [BT]
    new targetid, lawnum;
	if(sscanf(params, "rd", targetid, lawnum))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /setlaw [playerid/playername] [��������]");
    if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	if(!(-50 <= lawnum <= 50))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� �������� �� -50 �� 50.");
	new string[128];
	PlayerInfo[targetid][pLaw] = lawnum;
	UpdatePlayerStatics(targetid);
	format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ������� ����������������� %s[%d]: %d ��.",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid, lawnum);
	SendAdminMessage(COLOR_ADMIN, string);
	SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ������� ���� �����������������: %d ��.", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, lawnum);
	return true;
}

flags:setbank(CMD_DEVELOPER);
COMMAND:setbank(playerid, params[])
{
    new targetid, Float:bank;
	if(sscanf(params, "rf", targetid, bank))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /setbank [playerid/playername] [��������]");
    if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	new string[128];
	PlayerInfo[targetid][pBank] = bank;
	UpdatePlayerStatics(targetid);
	format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ������� ���������� ���� %s[%d]: $%.1f",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid, bank);
	SendAdminMessage(COLOR_ADMIN, string);
	SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ������� ��� ���������� ����: $%.1f", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, bank);
	return true;
}

COMMAND:licenses(playerid, params[])
{
	ShowLicenses(playerid, playerid);
	PlayerAction(playerid, "������������� ���� ��������.");
	return 1;
}

flags:checklic(CMD_HELPER);
COMMAND:checklic(playerid, params[])
{
    new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /checklic [playerid/playername]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	ShowLicenses(playerid, giveplayerid);
	return 1;
}

flags:givelic(CMD_DEVELOPER);
COMMAND:givelic(playerid, params[])
{
    new targetid, lic, value;
	if(sscanf(params, "rdd", targetid, lic, value))
	{
		SendClientMessage(playerid, COLOR_WHITE, "�����������: /givelic [playerid/playername] [��������] [0 - �������, 1 - ������]");
		SendClientMessage(playerid, COLOR_WHITE, "��������: (1 - ��������� A, 2 - ��������� B, 3 - ��������� C, 4 - ��������� D, 5 - ������)");
		return true;
	}
    if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");

	new string[128];
	switch(lic)
	{
	    case 1:
	    {	// ��������� A
	        if(value == 0)
	        {
	            if(PlayerInfo[targetid][pCarLicA] == 0)
	                return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ����� ������ ��� ���� ��������� A.");
				PlayerInfo[targetid][pCarLicA] = 0;
				format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ������ ����� ��������� A � ������ %s[%d]",
					GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid);
				SendAdminMessage(COLOR_ADMIN, string);
				SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ������ � ��� ����� ��������� A", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
	        }
	        else
	        {
	            if(PlayerInfo[targetid][pCarLicA] == 1)
	                return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ��� ����� ����� ��������� A.");
				PlayerInfo[targetid][pCarLicA] = 1;
			//#if defined _player_achieve_included	
			//	GivePlayerAchieve(playerid, ACHIEVE_DRIVER);
			//#endif	
				//if(mission_id[playerid] == MIS_GET_LICENSE)
				//{
				//	StoryMissionComplete(playerid, MIS_SOURCE_TRAINING, 0, 0);
				//}
				format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ����� ����� ��������� A ������ %s[%d]",
					GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid);
				SendAdminMessage(COLOR_ADMIN, string);
				SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ����� ��� ����� ��������� A", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
	        }
	    }
	    case 2:
	    {	// ��������� B
	        if(value == 0)
	        {
	            if(PlayerInfo[targetid][pCarLicB] == 0)
	                return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ����� ������ ��� ���� ��������� B.");
				PlayerInfo[targetid][pCarLicB] = 0;
				format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ������ ����� ��������� B � ������ %s[%d]",
					GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid);
				SendAdminMessage(COLOR_ADMIN, string);
				SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ������ � ��� ����� ��������� B", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
	        }
	        else
	        {
	            if(PlayerInfo[targetid][pCarLicB] == 1)
	                return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ��� ����� ����� ��������� B.");
				PlayerInfo[targetid][pCarLicB] = 1;
			//#if defined _player_achieve_included	
			//	GivePlayerAchieve(playerid, ACHIEVE_DRIVER);
			//#endif	
				//if(mission_id[playerid] == MIS_GET_LICENSE)
				//{
				//	StoryMissionComplete(playerid, MIS_SOURCE_TRAINING, 0, 0);
				//}
				format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ����� ����� ��������� B ������ %s[%d]",
					GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid);
				SendAdminMessage(COLOR_ADMIN, string);
				SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ����� ��� ����� ��������� B", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
	        }
	    }
	    case 3:
	    {	// ��������� C
	        if(value == 0)
	        {
	            if(PlayerInfo[targetid][pCarLicC] == 0)
	                return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ����� ������ ��� ���� ��������� C.");
				PlayerInfo[targetid][pCarLicC] = 0;
				format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ������ ����� ��������� C � ������ %s[%d]",
					GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid);
				SendAdminMessage(COLOR_ADMIN, string);
				SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ������ � ��� ����� ��������� C", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
	        }
	        else
	        {
	            if(PlayerInfo[targetid][pCarLicC] == 1)
	                return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ��� ����� ����� ��������� C.");
				PlayerInfo[targetid][pCarLicC] = 1;
			//#if defined _player_achieve_included	
			//	GivePlayerAchieve(playerid, ACHIEVE_DRIVER);
			//#endif	
				//if(mission_id[playerid] == MIS_GET_LICENSE)
				//{
				//	StoryMissionComplete(playerid, MIS_SOURCE_TRAINING, 0, 0);
				//}
				format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ����� ����� ��������� C ������ %s[%d]",
					GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid);
				SendAdminMessage(COLOR_ADMIN, string);
				SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ����� ��� ����� ��������� C", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
	        }
	    }
	    case 4:
	    {	// ��������� B
	        if(value == 0)
	        {
	            if(PlayerInfo[targetid][pCarLicD] == 0)
	                return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ����� ������ ��� ���� ��������� D.");
				PlayerInfo[targetid][pCarLicD] = 0;
				format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ������ ����� ��������� D � ������ %s[%d]",
					GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid);
				SendAdminMessage(COLOR_ADMIN, string);
				SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ������ � ��� ����� ��������� D", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
	        }
	        else
	        {
	            if(PlayerInfo[targetid][pCarLicD] == 1)
	                return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ��� ����� ����� ��������� D.");
				PlayerInfo[targetid][pCarLicD] = 1;
			//#if defined _player_achieve_included	
			//	GivePlayerAchieve(playerid, ACHIEVE_DRIVER);
			//#endif	
				//if(mission_id[playerid] == MIS_GET_LICENSE)
				//{
				//	StoryMissionComplete(playerid, MIS_SOURCE_TRAINING, 0, 0);
				//}
				format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ����� ����� ��������� D ������ %s[%d]",
					GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid);
				SendAdminMessage(COLOR_ADMIN, string);
				SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ����� ��� ����� ��������� D", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
	        }
	    }
	    case 5:
	    {// ������
	        if(value == 0)
	        {
	            if(PlayerInfo[targetid][pGunLic] == 0)
	                return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ����� ������ � ��� ��� �������� �� ������.");
				PlayerInfo[targetid][pGunLic] = 0;
				PlayerInfo[targetid][pShooting] = 0;
	        	format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ������ �������� �� ������ ������ %s[%d]",
					GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid);
				SendAdminMessage(COLOR_ADMIN, string);
				SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ������ � ��� �������� �� ������", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
	        }
	        else
	        {
	            if(PlayerInfo[targetid][pGunLic] == 1)
	                return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ��� ����� �������� �� ������.");
				PlayerInfo[targetid][pGunLic] = 1;
				format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ����� �������� �� ������ ������ %s[%d]",
					GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid);
				SendAdminMessage(COLOR_ADMIN, string);
				SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ����� ��� �������� �� ������", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
	        }
	    }
	    default: SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� �������� �� ����������.");
	}
	UpdatePlayerStatics(targetid);
	return true;
}

flags:setskill(CMD_ADMIN);
COMMAND:setskill(playerid, params[])
{
	new targetid, skill, level, progress;
	if(sscanf(params, "rddd", targetid, skill, level, progress))
	{
		SendClientMessage(playerid, COLOR_WHITE, "�����������: /setskill [playerid/playername] [�����] [�������] [��������]");
		SendClientMessage(playerid, COLOR_WHITE, "(1 - �������, 2 - �������� ��������, 3 - ������������)");
		return true;
	}
    if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");

	new string[128];
	switch(skill)
	{
	    case 1:
	    {// �������
	        PlayerInfo[targetid][pTaxiLevel] = level;
	        PlayerInfo[targetid][pTaxiSkill] = progress;
			format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ��������� %s[%d] ����� ��������: %d ��. [%d]",
				GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid, level, progress);
			SendAdminMessage(COLOR_ADMIN, string);
			SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ��������� ��� ����� ��������: %d ��. [%d]", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, level, progress);
	    }
	    case 2:
	    {// �������� ��������
	        PlayerInfo[targetid][pBusLevel] = level;
	        PlayerInfo[targetid][pBusSkill] = progress;
			format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ��������� %s[%d] ����� �������� ��������: %d ��. [%d]",
				GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid, level, progress);
			SendAdminMessage(COLOR_ADMIN, string);
			SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ��������� ��� ����� �������� ��������: %d ��. [%d]", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, level, progress);
	    }
	    case 3:
	    {// ������������
	        PlayerInfo[targetid][pTruckLevel] = level;
	        PlayerInfo[targetid][pTruckSkill] = progress;
			format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ��������� %s[%d] ����� �������������: %d ��. [%d]",
				GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid, level, progress);
			SendAdminMessage(COLOR_ADMIN, string);
			SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ��������� ��� ����� �������������: %d ��. [%d]", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, level, progress);
	    }
	    default: SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� �������� �� ����������.");
	}
	UpdatePlayerStatics(targetid);
	return true;
}

flags:setrank(CMD_DEVELOPER);
COMMAND:setrank(playerid, params[])
{
    new targetid, rank;
	if(sscanf(params, "rd", targetid, rank))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /setrank [�� ������] [rank]");
    if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	new faction = PlayerInfo[targetid][pFaction];
	if(faction == 0)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� �� ������� �� �������.");
	if(1 <= rank <= FactionRankMax[faction])
	{
		new string[128];
		SetPlayerFaction(targetid, PlayerInfo[targetid][pFaction], rank);
		format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ����� ����� ���� %s[%d]: %s (%d)",
			GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid, GetPlayerRank(targetid), rank);
		SendAdminMessage(COLOR_ADMIN, string);
		SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ����� ��� ����� ����: %s (%d)", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, GetPlayerRank(targetid), rank);
	}
	else{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ����� ��� �� ������� ������.");
	}
	return true;
}

flags:unjail(CMD_ADMIN);
COMMAND:unjail(playerid, params[])
{
	new targetid;
	if(sscanf(params, "r", targetid))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /unjail [�� ������]");
    if(!IsPlayerLogged(targetid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	if(PlayerInfo[targetid][pJailTime] == 0)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� �� � ������.");
	new string[128];
	format(string, 128, "[AdmCmd]: %s %s[%d] �������� �� ������ ������ %s[%d]",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid);
	SendAdminMessage(COLOR_ADMIN, string);
	SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "������������� %s �������� ��� �� ������", ReturnPlayerName(playerid));
	KillTimer(GetPVarInt(playerid, "Prison:FlyCamera:Timer"));
    return JailDelivery(targetid);
}

flags:jaillist(CMD_DEVELOPER);
COMMAND:jaillist(playerid, params[])
{
	new lstring[1792];
	if(Iter_Count(Prisoners))
	{
	    new curtime;
		new const nowtime = gettime();
		foreach(Prisoners, i)
		{
		    if(PlayerInfo[i][pJailTime] > 0)
		    {
		        curtime = PlayerInfo[i][pJailTime]-nowtime;
			    format(lstring, sizeof(lstring), "%s{AFAFAF}� {FFFFFF}%s[%d] (%02d ��� %02d ���)\n", lstring, ReturnPlayerName(i), i, curtime/60, curtime%60);
			}
		}
	}
	else lstring = "{AFAFAF}< � ������ ��� �����������. >";
	MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_LIST, "������ �����������:", lstring, "�������");
	return 1;
}

flags:gpe(CMD_DEVELOPER);
COMMAND:gpe(playerid, params[])
{// [BT]
    new giveplayerid, amount;
	if(sscanf(params, "ri", giveplayerid, amount))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /gpe [playerid/playername] [amount]");
    if(!IsPlayerLogged(giveplayerid))
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	return GivePlayerEXP(giveplayerid, amount);
}

flags:botinfo(CMD_DEVELOPER);
COMMAND:botinfo(playerid, params[])
{
	new giveplayerid, level;
	if(sscanf(params, "ri", giveplayerid, level))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /botinfo [playerid/playername] [level]");
    if(!IsPlayerConnected(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
    if(IsPlayerLogged(giveplayerid))
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ��� �����������.");

	new string[128];
	SetPlayerScore(giveplayerid, level);
	SetPlayerColor(giveplayerid, 0xFFFFFF00);
	SendFormatMessage(playerid, COLOR_SERVER, string, "[BT] �� �������� ���� � ������� ���� %s[%d]", ReturnPlayerName(giveplayerid), giveplayerid);
	return 1;
}

flags:setupgrade(CMD_DEVELOPER);
COMMAND:setupgrade(playerid, params[])
{
    new targetid, amount;
	if(sscanf(params, "ri", targetid, amount)){
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /setupgrade [playerid/playername] [amount]");
	}
    if(!IsPlayerLogged(targetid)){
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
    }
    new string[256];
	PlayerInfo[targetid][pUpgrade] = amount;
	//UpdatePlayerUpgrade(targetid);
	format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ������� ���-�� ��������� %s[%d]: %d ��.",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid, amount);
	SendAdminMessage(COLOR_ADMIN, string);
	SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ������� ��� �������: %d ��.", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, amount);
	return true;
}

flags:tds(CMD_DEVELOPER);
COMMAND:tds(playerid, params[])
{// [BT]
	new bool:effect;
	if(sscanf(params, "b", effect))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /tds [value]");
	IFace.ToggleTVEffect(playerid, effect);
	return true;
}

flags:cp(CMD_DEVELOPER);
COMMAND:cp(playerid, params[])
{// [BT]
	new Float:X, Float:Y, Float:Z, Float:size;
	if(sscanf(params, "p<,>ffff", X, Y, Z, size))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /cp [X,Y,Z,size]");
	return MySetPlayerCheckpoint(playerid, CPMODE_NONE, X, Y, Z, size);
}

flags:cpdel(CMD_DEVELOPER);
COMMAND:cpdel( playerid, params[] )
{// [BT]
	return MyDisablePlayerCheckpoint(playerid);
}

flags:sound(CMD_DEVELOPER);
COMMAND:sound(playerid, params[])
{// [BT]
    new soundid;
	if(sscanf(params, "i", soundid))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /sound [soundid]");
	new string[32];
	format(string, 32, "~g~Sound ID: ~w~%d", soundid);
	GameTextForPlayer(playerid, string, 1500, 4);
	return PlayerPlaySound(playerid, soundid, 0.0, 0.0, 0.0);
}

flags:gametext(CMD_DEVELOPER);
COMMAND:gametext(playerid, params[])
{// [BT]
	new string[128], style;
	if(sscanf(params, "is[128]", style, string))
		return SendClientMessage( playerid, COLOR_WHITE, "�����������: /gametext [style] [string]" );
	//format(string, 128, "%s", string);
	return GameTextForPlayer(playerid, string, 3000, style);
}

flags:gt(CMD_DEVELOPER);
COMMAND:gt(playerid, params[])
{// [BT]
	new string[128], style, type;
	if(sscanf(params, "iis[128]", type, style, string) || type < 0 || type > 1)
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /gt [rusik] [style] [string]");
	return GameTextForAll(RusText(string, type), 3000, style);
}

flags:mmessage(CMD_DEVELOPER);
COMMAND:mmessage(playerid, params[])
{// [BT]
	new string[128];
	if(sscanf(params, "s[128]", string))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /mmessage [string]");
	return SendMissionMessage(playerid, string);
}

flags:minfo(CMD_DEVELOPER);
COMMAND:minfo(playerid, params[])
{// [BT]
	new string[128];
	if(sscanf(params, "s[128]", string))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /minfo [string (0 = hide)]");
	if(strcheck(string, "0")) return HideMissionInfo(playerid);
	return ShowMissionInfo(playerid, string);
}

flags:hint(CMD_DEVELOPER);
COMMAND:hint(playerid, params[])
{// [BT]
	new string[128], time;
	if(sscanf(params, "s[128]d", string, time))
		return SendClientMessage( playerid, COLOR_WHITE, "�����������: /hint [string] [time]" );
	return ShowPlayerHint(playerid, string, time);
}

flags:getnitro(CMD_DEVELOPER);
COMMAND:getnitro(playerid, params[])
{// [BT]
	if(GetPlayerState(playerid) != 2)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ����� �� ����� ��������.");
	return AddVehicleComponent(GetPlayerVehicleID(playerid), 1008+random(3));
}

flags:cbonus(CMD_DEVELOPER);
COMMAND:cbonus(playerid, params[])
{
	extract params -> new type, ammo, use; else
	{
		SendClientMessage(playerid, -1, "�����������: /cbonus  [���] [���-��] [���-�� ������������� (0 - ��� ����)] [��� (����. 32 �������)] ");
		SendClientMessage(playerid, -1, "����: 0 - ������, 1 - ������, 2 - ����");
		return SendClientMessage(playerid, COLOR_YELLOW, "��� ����� �������� ������, ����� �� ����� ������������ �������������!");
	}
	if(type < 0 || type > 2)
	{
	    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ����� ���� �� 0 �� 2.");
	    return SendClientMessage(playerid, COLOR_WHITE, "����: 0 - ������, 1 - ������, 2 - ����");
	}
	if(ammo <= 0)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������� ������ �� ����� ���� �������������.");

	new code[MAX_CODE_SIZE];
	sscanf(params, "{iii}s[" #MAX_CODE_SIZE "]", code);
	if(!strlen(code))	strmid(code, generateCode(8), 0, 8);

	new stmp[256];
	mysql_format(g_SQL, stmp, sizeof stmp, "SELECT COUNT(*) AS count FROM `bonuses` WHERE `code` = '%e'", code);
	new Cache:result = mysql_query(g_SQL, stmp);
	new res;
	cache_get_value_name_int(0, "count", res);
	cache_delete(result);
	if(res)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ��� ��� ������.");
	mysql_format(g_SQL, stmp, sizeof stmp, "INSERT INTO `bonuses` SET `using` = '%d', `code` = '%e', `type` = '%d', `value` = '%d', `creator` = '%d'", use, code, type, ammo, PlayerInfo[playerid][pUserID]);
	result = mysql_query(g_SQL, stmp);
	new date[3], time[3], stype[16];
	getdate(Arr3<date>);	gettime(Arr3<time>);
	if(type == 0) 		stype = "������";
	else if(type == 1) 	stype = "������";
	else if(type == 2) 	stype = "����";
	SendFormatMessage(playerid, -1, stmp, "����� ��� '{33AA33}%s{FFFFFF}' ������, ��� ������: '{33AA33}%s{FFFFFF}', ��������: '{33AA33}%d{FFFFFF}' (%02d/%02d/%04d %02d:%02d)", code, stype, ammo, date[2], date[1], date[0], time[0], time[1]);
	return true;
}

flags:bonuslist(CMD_DEVELOPER);
COMMAND:bonuslist(playerid, params[])
{
    return ShowDialog(playerid, DMODE_BONUS_LIST);
}

flags:delbonus(CMD_DEVELOPER);
COMMAND:delbonus(playerid, params[])
{
	new code[MAX_CODE_SIZE];
	if(sscanf(params, "s[" #MAX_CODE_SIZE "]", code))
		return SendClientMessage(playerid, -1, "�����������: /delbonus [���]");
	new stmp[64], res;
	mysql_format(g_SQL, stmp, sizeof stmp, "SELECT COUNT(*) AS count FROM `bonuses` WHERE `code` = '%e'", code);
	new Cache:result = mysql_query(g_SQL, stmp);
	cache_get_value_name_int(0, "count", res);
	cache_delete(result);
	if(res == 0)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ����� ��� �� ������.");
	mysql_format(g_SQL, stmp, sizeof stmp, "DELETE FROM `bonuses` WHERE `code` = '%e'", code);
	mysql_query_ex(stmp);
	SendFormatMessage(playerid, -1, stmp, "����� ��� '{33AA33}%s{FFFFFF}' ������� ������!", code);
	return true;
}

flags:headshot(CMD_DEVELOPER);
COMMAND:headshot(playerid, params[])
{// [BT]
	if(sscanf(params, "i", HEADSHOT))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /headshot [status]");
	new string[128];
    format(string, 128, "[AdmCmd]: %s[%d] set headshot mode to %d", ReturnPlayerName(playerid), playerid, HEADSHOT);
	return SendAdminMessage(COLOR_LIGHTRED, string, 3);
}

flags:anticheat(CMD_DEVELOPER);
COMMAND:anticheat(playerid, params[])
{// [BT]
	new bool:anticheat;
	if(sscanf(params, "b", anticheat)){
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /anticheat [status]");
	}
	new string[128];
	Anticheat.Toggle(anticheat);
	foreach(LoginPlayer, i)
	{
		SetPVarInt(i, "AC:ChangePos:GTC", GetTickCount());
		MyGetPlayerPos(playerid, Arr3<OldPlayerPos[i]>);
	}
    format(string, sizeof(string), "[AdmCmd]: %s[%d] set anticheat to %d", ReturnPlayerName(playerid), playerid, Anticheat.GetToggle());
	return SendAdminMessage(COLOR_LIGHTRED, string, 3);
}

flags:delcars(CMD_ADMIN);
COMMAND:delcars(playerid, params[])
{
	new count = 0;
	foreach(Vehicle, v)
	{
	    if(CarInfo[v][cType] == C_TYPE_EVENT)
		{
		    count++;
			MyDestroyVehicle(v);
			v = VehInfo[v][vIterNext];
		}
	}
	new string[128];
	format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ������ ����� ������: %d ��.", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, count);
	SendAdminMessage(COLOR_ADMIN, string);
    return 1;
}

flags:delcar(CMD_ADMIN);
COMMAND:delcar(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���� � ����������.");
	new string[128];
    new vehicleid = GetPlayerVehicleID(playerid);
    MyDestroyVehicle(vehicleid);
    format(string, sizeof(string), "������ #%d ������� �������", vehicleid);
    SendClientMessage(playerid, COLOR_LIGHTRED, string);
    return 1;
}

flags:entercar(CMD_ADMIN);
COMMAND:entercar(playerid, params[])
{// [BT]
    new vehicleid;
	if(sscanf(params, "i", vehicleid))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /entercar [vehicleid] [seatid]");
    if(vehicleid <= 0 || !VehInfo[vehicleid][vCreated])
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������ ��� �� �������.");
	if(IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� �� ���������� ��� ���������.");
	new seatid = 0;
	sscanf(params, "{i}i", seatid);
	return MyPutPlayerInVehicle(playerid, vehicleid, seatid);
}

flags:gmcheck(CMD_MODER);
COMMAND:gmcheck(playerid, params[])
{// [BT]
    new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /gmcheck [playerid/playername]");
	}
    if(!IsPlayerLogged(giveplayerid))
    {
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	}
    new Float:Health;
    GetPlayerHealth(giveplayerid, Health);
    MySetPlayerHealth(giveplayerid, Health-1.0);
	SetTimerEx("GM_TIMER2", 1000, false, "iif", playerid, giveplayerid, Health);
	return 1;
}

Public: GM_TIMER2(playerid, giveplayerid, Float:Health2)
{
	new string[128], Float:Health;
    GetPlayerHealth(giveplayerid, Health);
    format(string, 128, "����� %s �������� �� ������: ", ReturnPlayerName(giveplayerid));
	if(IsPlayerAFK(giveplayerid)) strcat(string, "{F5DEB3}���������� (AFK)");
    else if(Health == Health2) strcat(string, "{FF6347}�����");
    else
	{
		strcat(string, "{33AA33}�� �����");
		MySetPlayerHealth(giveplayerid, Health+1.0);
	}
	SendClientMessage(playerid, COLOR_WHITE, string);

}

flags:mycmd(CMD_DEVELOPER);
COMMAND:mycmd(playerid, params[])
{// [BT]
	new acmd[32], string[256], giveplayerid;
	if(sscanf(params, "rs[32]s[256]", giveplayerid, acmd, string))
	    return SendClientMessage(playerid, -1, "�����������: /mycmd [playerid/playername] [cmd] [params]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	new funcname[32] = "pc_cmd_";
	strmid(funcname[7], acmd, 1, strlen(acmd), 28);
	CallLocalFunction(funcname, "is", giveplayerid, string);
	return 1;
}

flags:clock(CMD_DEVELOPER);
COMMAND:clock(playerid, params[])
{// [BT]
	ClockStatus = !ClockStatus;
	TogglePlayerClock(playerid, ClockStatus);
	return 1;
}

flags:payday(CMD_DEVELOPER);
COMMAND:payday(playerid, params[])
{// [BT]
	EveryHourTimer();
	return 1;
}

flags:myweapon(CMD_DEVELOPER);
COMMAND:myweapon(playerid, params[])
{// [BT]
	Inv.GivePlayerWeapon(playerid, 1, 1);  // Slot 0
	Inv.GivePlayerWeapon(playerid, 2, 1);  // Slot 1
	Inv.GivePlayerWeapon(playerid, 22, 10);// Slot 2
	Inv.GivePlayerWeapon(playerid, 25, 11);// Slot 3
	Inv.GivePlayerWeapon(playerid, 28, 12);// Slot 4
	Inv.GivePlayerWeapon(playerid, 30, 13);// Slot 5
	Inv.GivePlayerWeapon(playerid, 33, 14);// Slot 6
	Inv.GivePlayerWeapon(playerid, 35, 15);// Slot 7
	Inv.GivePlayerWeapon(playerid, 16, 16);// Slot 8
	Inv.GivePlayerWeapon(playerid, 43, 17);// Slot 9
	Inv.GivePlayerWeapon(playerid, 14, 1);// Slot 10
	Inv.GivePlayerWeapon(playerid, 46, 1);// Slot 11
	return 1;
}

flags:reset(CMD_DEVELOPER);
COMMAND:reset(playerid, params[])
{
    new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /reset [playerid/playername]");
	}
    if(IsPlayerLogged(giveplayerid) == 0)
    {
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	}
	MyResetPlayerWeapons(giveplayerid);
	new string[128];
	format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ������� ��� ������ ������ %s[%d]",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid);
	SendAdminMessage(COLOR_ADMIN, string);
	if(GetPlayerAdmin(giveplayerid) == 0)
	{
		SendFormatMessage(giveplayerid, COLOR_LIGHTBLUE, string, "%s {FFFFFF}%s{33CCFF} ������� ��� ���� ������", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid));
	}
	return true;
}

flags:specoff(CMD_HELPER);
COMMAND:specoff(playerid, params[])
{
    TogglePlayerSpectating(playerid, 0);
    Iter_Remove(Spectators, playerid);
    SpectateID[playerid] = INVALID_PLAYER_ID;
    Interface_SpecPanel_Toggle(playerid, false);
    CancelSelectTextDraw(playerid);
    return 1;
}

flags:speclist(CMD_DEVELOPER);
COMMAND:speclist(playerid, params[])
{// [BT]
	new lstring[1792];
	if(Iter_Count(Spectators))
	{
		foreach(Spectators, i)
		{
		    format(lstring, sizeof(lstring), "%s{AFAFAF}� {FFFFFF}%s %s[%d] > %s[%d]\n", lstring, GetPlayerAdminStatus(i), ReturnPlayerName(i), i, ReturnPlayerName(SpectateID[i]), SpectateID[i]);
		}
	}
	else lstring = "{AFAFAF}< ������������ ���. >";
	MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_LIST, "������ �����������:", lstring, "�������");
	return 1;
}

stock UpdatePlayerSpectate(playerid, giveplayerid)
{
	SetTimerEx("Timer_UpdatePlayerSpectate", 1000, false, "ii", playerid, giveplayerid);
}

Public: Timer_UpdatePlayerSpectate(playerid, giveplayerid)
{
    if(IsPlayerInAnyVehicle(giveplayerid))
	{
	    new carid = GetPlayerVehicleID(giveplayerid);
	    PlayerSpectateVehicle(playerid, carid);
	}
	else PlayerSpectatePlayer(playerid, giveplayerid);
	SetPlayerInterior(playerid, GetPlayerInterior(giveplayerid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(giveplayerid));
}

flags:spec(CMD_MODER);
COMMAND:spec(playerid, params[])
{
    new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /spec [playerid/playername]");
    if(playerid == giveplayerid)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ��������� �� ����� �����.");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	if(SpectateID[playerid] == INVALID_PLAYER_ID)
	{
		new Float:pos[3];
		GetPlayerPos(playerid, Arr3<pos>);
		MySetPlayerSpawnPos(playerid, Arr3<pos>, 180.0, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
		MyChangePlayerWeapon(playerid, true);
	}
	PoliceMissionCancel(playerid, "quit");

	Iter_Add(Spectators, playerid);
	SpectateID[playerid] = giveplayerid;
    TogglePlayerSpectating(playerid, true);
	UpdatePlayerSpectate(playerid, giveplayerid);
	Timer_UpdatePlayerSpectate(playerid, giveplayerid);

	new string[128];
	format(string, 128, "[AdmCmd]: %s %s[%d] ����� ������� �� %s[%d]", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid);
	SendAdminMessage(COLOR_GREY, string);
	SendClientMessage(playerid, COLOR_WHITE, PREFIX_HINT "��� ���������� �������� ����������� "SCOLOR_HINT"/specoff"SCOLOR_WHITE".");
	Interface_SpecPanel_Toggle(playerid, true);
	SelectTextDraw(playerid, 0xFCEC3AFF);
	return 1;
}

flags:setfuel(CMD_DEVELOPER);
COMMAND:setfuel(playerid, params[])
{
    new targetid, Float:fuel;
	if(sscanf(params, "rf", targetid, fuel))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /setfuel [playerid/playername] [fuel 0-100]");
	}
    if(!IsPlayerLogged(targetid))
    {
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	}
	new string[256];
	new vehicleid = GetPlayerVehicleID(targetid);
	if(vehicleid)
	{
		if(!(0.0 <= fuel <= GetVehicleMaxFuel(vehicleid)))
		{
			SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "������� ������ �� 0 �� %d.", GetVehicleMaxFuel(vehicleid));
			return 1;
		}
		VehInfo[vehicleid][vFuel] = fuel;
		IFace.Veh_Update(targetid, 0);
		format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ��������� ������� ��� %s[%d] �� %.1f�",
			GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid, fuel);
		SendAdminMessage(COLOR_ADMIN, string);
		SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ��������� ������� ������� � ����� ���������� �� %.1f�", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, fuel);
	}
	else SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� �� � ������.");
	return 1;
}

flags:setdrunk(CMD_DEVELOPER);
COMMAND:setdrunk(playerid, params[])
{// [BT]
    new targetid, drunklevel;
	if(sscanf(params, "ri", targetid, drunklevel)){
	   	return SendClientMessage(playerid, COLOR_WHITE, "�����������: /setdrunk [playerid/playername] [drunklevel]");
	}
    if(!IsPlayerLogged(targetid)){
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	}
	if(!(0 <= drunklevel <= 50000)){
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������� ��������� �� 0 �� 50000.");
	}
	new string[256];
	SetPlayerDrunkLevel(targetid, drunklevel);
	format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ������� ��������� %s[%d]: %d",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid, drunklevel);
	SendAdminMessage(COLOR_ADMIN, string);
	SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] ������� ��� ������� ���������: %d", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, drunklevel);
	return 1;
}

flags:pickup(CMD_DEVELOPER);
COMMAND:pickup(playerid, params[])
{// [BT]
    new objectid, type;
	if(sscanf(params, "dd", type, objectid))
	{
	    SendClientMessage(playerid, COLOR_WHITE, "�����������: /pickup [type] [pickupid]");
		return 1;
	}
	new string[128];
	new Float:x, Float:y, Float:z, Float:a;
	MyGetPlayerPos(playerid, x, y, z, a);
	x += (2 * floatsin(-a, degrees));
	y += (2 * floatcos(-a, degrees));
	DestroyDynamicPickup(TestPickup[playerid]), TestPickup[playerid] = INVALID_STREAMER_ID;
	TestPickup[playerid] = CreateDynamicPickup(objectid, type, x, y, z, 0, 0, 0);
	format(string, 128, "[object]: ������ ����� ID %d", objectid);
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}

flags:object(CMD_DEVELOPER);
COMMAND:object(playerid, params[])
{// [BT]
    new objectid;
	if(sscanf(params, "d", objectid))
	{
	    SendClientMessage(playerid, COLOR_WHITE, "�����������: /object [objectid]");
		return 1;
	}
	new string[128];
	new Float:x, Float:y, Float:z, Float:a;
	MyGetPlayerPos(playerid, x, y, z, a);
	x += (2 * floatsin(-a, degrees));
	y += (2 * floatcos(-a, degrees));
	DestroyDynamicObject(TestObject[playerid]);
	TestObject[playerid] = CreateDynamicObject(objectid, x, y, z, 0, 0, 0);
	EditDynamicObject(playerid, TestObject[playerid]);
	format(string, 128, "[object]: ������ ������ ID %d", objectid);
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}

flags:selectobject(CMD_DEVELOPER);
CMD:selectobject(playerid, params[])
{
	SelectObject(playerid);
	return true;
}

flags:objectmat(CMD_DEVELOPER);
COMMAND:objectmat(playerid, params[])
{// [BT]
    new objectid, materialindex, modelid, txdname[32], texturename[32], colour;
	if(sscanf(params, "ddds[32]s[32]h", objectid, materialindex, modelid, txdname, texturename, colour))
	{
	    SendClientMessage(playerid, COLOR_WHITE, "�����������: /objectmat [objectid] [materialindex] [modelid] [txdname] [texturename] [colour]");
		return 1;
	}
	new string[128];
	new Float:x, Float:y, Float:z, Float:a;
	MyGetPlayerPos(playerid, x, y, z, a);
	x += (2 * floatsin(-a, degrees));
	y += (2 * floatcos(-a, degrees));
	DestroyDynamicObject(TestObject[playerid]);
	TestObject[playerid] = CreateDynamicObject(objectid, x, y, z, 0, 0, 0);
	SetDynamicObjectMaterial(TestObject[playerid], materialindex, modelid, txdname, texturename, colour);
	EditDynamicObject(playerid, TestObject[playerid]);
	format(string, 128, "[object]: ������ ������ ID %d", objectid);
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}

flags:carcheck(CMD_MODER);
COMMAND:carcheck(playerid, params[])
{// [BT]
	new v = GetNearVehicles(playerid);
	if(!v)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���������� ��� �� ����� ������.");

	new string[164];
	for(new i; i < BREAK_CAR_CODE_LEN; i++)
	{
		if((VehInfo[v][vBitHack] >> i ^ 0) & 1) strcat(string, "L");
		else strcat(string, "R");
	}
    format(string, 164, "[BT]: Vehicle #%d, BitHack[%s]", v, string);
	if(CarInfo[v][cID] > 0 && CarInfo[v][cType] == C_TYPE_PLAYER)
	{
	    format(string, 164, "%s Owner[%s]", string, GetPlayerUsername(CarInfo[v][cOwnerID]));
	}
    SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}

flags:check(CMD_MODER);
COMMAND:check(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /check [playerid/playername]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	ShowStats(playerid, giveplayerid);
	return 1;
}

flags:getwage(CMD_MODER);
COMMAND:getwage(playerid,params[])
{
	new giveplayerid;
    if(sscanf(params, "r", giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /getwage [playerid/playername]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	new string[128];
	format(string, sizeof(string), "%s[%d] � ��������� PayDay �������: {FFFFFF}$%.1f [vip: %d]", ReturnPlayerName(giveplayerid), giveplayerid, Job.GetPlayerWage(giveplayerid), PlayerInfo[giveplayerid][pVip]);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
    return 1 ;
}

flags:reloadmaps(CMD_DEVELOPER);
COMMAND:reloadmaps(playerid, params[])
{
	SendRconCommand("reloadfs objects");
	SendClientMessage(playerid, COLOR_GREY, "������� ������� ������������.");
	return true;
}

COMMAND:aduty(playerid, params[])
{
	if(!IsPlayerAdmin(playerid) && PlayerInfo[playerid][pAdmin] == 0)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��� �������.");
	new string[128];
	if(AdminDuty[playerid])
	{
	    format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ������� � ���������", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
	    SendAdminMessage(COLOR_ADMIN, string, 1);
	    AdminDuty[playerid] = false;
	    Interface_AdmPanel_Toggle(playerid, false);
	}
	else
	{
	    new adminpass[32];
		if(sscanf(params, "s[32]", adminpass))
		    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /aduty [password]");
		if(strcheck(adminpass, ADMIN_PASS))
		{
		    AdminDuty[playerid] = true;
		    format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ������� �� ���������", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
		    SendAdminMessage(COLOR_ADMIN, string, 1);
		    if(GetPlayerAdmin(playerid) >= ADMIN_MODER)	Interface_AdmPanel_Toggle(playerid, true);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������� �����-������.");
		    format(string, sizeof(string), "[AdmWrn]: %s[%d] �������� ����� �� �����-��������� � �������� �������", ReturnPlayerName(playerid), playerid);
		    SendAdminMessage(COLOR_RED, string); 
		}
	}
	return true;
}

flags:sethunger(CMD_ADMIN);
CMD:sethunger(playerid, params[])
{
	new giveplayerid, hunger;
	if(sscanf(params, "rd", giveplayerid, hunger))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /sethunger [playerid/playername] [hunger]");

    if(!IsPlayerLogged(giveplayerid))
    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");

	SetPlayerHunger(giveplayerid, hunger);
	//
	new string[128];
	format(string, 128, "[AdmCmd]: %s %s[%d] ��������� ������� ������ %s[%d] %d%s",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, hunger, "%%");
	SendAdminMessage(COLOR_ADMIN, string);
	SendFormatMessage(giveplayerid, COLOR_LIGHTBLUE, string, "%s %s[%d] ��������� ���� ������� ��: {FFFFFF}%d%s", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, hunger, "%%");
	return true;
}

flags:sethp(CMD_ADMIN);
COMMAND:sethp(playerid, params[])
{
	new giveplayerid, Float:health;
	if(sscanf(params, "rf", giveplayerid, health))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /sethp [playerid/playername] [health]");

    if(!IsPlayerLogged(giveplayerid))
    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");

	new Float:oldheal;
	GetPlayerHealth(giveplayerid, oldheal);
	MySetPlayerHealth(giveplayerid, health);
	//
	new string[128];
	format(string, 128, "[AdmCmd]: %s %s[%d] ������� �������� ������ %s[%d] �� %.1f ��",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, health);
	SendAdminMessage(COLOR_ADMIN, string);
	if(health < 100 && health < oldheal)
		GameTextForPlayer(giveplayerid, "~r~infected     ~n~~w~     by admin", 3000, 4);
	else
		GameTextForPlayer(giveplayerid, "~g~healed     ~n~~w~     by admin", 3000, 4);
	return 1;
}

flags:setarmour(CMD_ADMIN);
COMMAND:setarmour(playerid, params[])
{
	new giveplayerid, Float:armour;
	if(sscanf(params, "rf", giveplayerid, armour))
	{
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /setarmour [playerid/playername] [health]");
	}
    if(IsPlayerLogged(giveplayerid) == 0)
    {
    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
    }
	new Float:oldarmour;
	GetPlayerArmour(giveplayerid, oldarmour);
	MySetPlayerArmour(giveplayerid, armour);
	//
	new string[128];
	format(string, sizeof(string), "[AdmCmd]: %s %s[%d] ������� ����� ������ %s[%d] �� %.1f ��",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, armour);
	SendAdminMessage(COLOR_ADMIN, string);
	if(armour < 100 && armour < oldarmour)
		GameTextForPlayer(giveplayerid, "~r~disarmed     ~n~~w~     by admin", 3000, 4);
	else
		GameTextForPlayer(giveplayerid, "~g~armed     ~n~~w~     by admin", 3000, 4);
	return 1;
}

flags:explode(CMD_DEVELOPER);
COMMAND:explode(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /explode [playerid/playername]");

    if(!IsPlayerLogged(giveplayerid))
    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");

	if(playerid != giveplayerid && GetPlayerAdmin(giveplayerid) >= ADMIN_MODER)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ��������� ������.");

	new string[128];
	format(string, 128, "[AdmCmd]: %s %s[%d] �������� ������ %s[%d]",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid);
	SendAdminMessage(COLOR_ADMIN, string);

	new Float:x, Float:y, Float:z;
    GetPlayerPos(giveplayerid, x, y, z);
    foreach(Player, i)
    {
        if(IsPlayerInRangeOfPoint(i, 50.0, x, y, z))
        {
            PlayAudioStreamForPlayer(i, AUDIOFILE_PATH "/takbir.mp3", x, y, z, 50.0, 1);
        }
    }
    SetTimerEx("takbir_explode", 1000, false, "d", giveplayerid);
	return 1;
}

Public: takbir_explode(playerid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    CreateExplosion(x, y, z, 7, 20.0);
    SetTimerEx("takbir_nasheed", 1200, false, "fff", x, y, z);
    return 1;
}

Public: takbir_nasheed(Float:x, Float:y, Float:z)
{
    foreach(Player, i)
    {
        if (IsPlayerInRangeOfPoint(i, 50.0, x, y, z))
        {
            PlayAudioStreamForPlayer(i, AUDIOFILE_PATH "/nasheed.mp3", x, y, z, 50.0, 1);
        }
    }
}

flags:slap(CMD_MODER);
COMMAND:slap(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /slap [playerid/playername]");

    if(!IsPlayerLogged(giveplayerid))
    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");

	if(playerid != giveplayerid && GetPlayerAdmin(giveplayerid) >= ADMIN_MODER)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ���������� ������.");

	new Float:height = 7.0;
	new Float:X, Float:Y, Float:Z;
	sscanf(params, "{r}f", height);
	GetPlayerPos(giveplayerid, X, Y, Z);
	MySetPlayerPos(giveplayerid, X, Y, Z+height);
	PlayerPlaySound(giveplayerid, 1130, 0.0, 0.0, 0.0);
	//
	new string[128];
	format(string, 128, "[AdmCmd]: %s %s[%d] ��������� ������ %s[%d]",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid);
	SendAdminMessage(COLOR_ADMIN, string);
	return 1;
}

stock AJailPlayer(playerid, time)
{
	PlayerBusy{playerid} = true;
	PlayerInfo[playerid][pAJailTime] = gettime() + (time * 60);
	SetPlayerSpawn(playerid);
	MySpawnPlayer(playerid);
}

flags:ajail(CMD_MODER);
COMMAND:ajail(playerid, params[])
{
	new giveplayerid, time, reason[64];
	if(sscanf(params, "rds[64]", giveplayerid, time, reason))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /ajail [playerid/playername][������][�������]");

    if(!IsPlayerConnected(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");

	//if(playerid == giveplayerid)
	//	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ �������� � ������ ������ ����.");

	new string[128];
	format(string, 128, "[AdmCmd]: %s %s[%d] ������� %s[%d] � ������ �� %d �����: %s",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, time, reason);
	MySendClientMessageToAll(COLOR_LIGHTRED, string), Admin_Log(string);
	PlayerPlaySound(giveplayerid, 1085, 0.0, 0.0, 0.0);

	AJailPlayer(giveplayerid, time);
	return true;
}

flags:kick(CMD_MODER);
COMMAND:kick(playerid, params[])
{
	new giveplayerid, reason[64];
	if(sscanf(params, "rs[64]", giveplayerid, reason))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /kick [playerid/playername] [�������]");

    if(!IsPlayerConnected(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");

	if(playerid == giveplayerid)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������� ������ ����.");

	new string[128];
	if(PlayerInfo[playerid][pAdmin] <= PlayerInfo[giveplayerid][pAdmin])
	{
	    format(string, 128, "[AdmWrn]: %s %s[%d] �������� ������� �������� ������ %s[%d]",
			GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid);
	    return SendAdminMessage(COLOR_LIGHTRED, string);
	}
	format(string, 128, "[AdmCmd]: %s %s[%d] ������ ������ %s[%d]: %s",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, reason);
	MySendClientMessageToAll(COLOR_LIGHTRED, string), Admin_Log(string);
	PlayerPlaySound(giveplayerid, 1085, 0.0, 0.0, 0.0);
	KickEx(giveplayerid);
	return true;
}

flags:askunmute(CMD_MODER);
COMMAND:askunmute(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /askunmute [playerid/playername]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
    if(PlayerInfo[giveplayerid][pAskMute] < gettime())
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� � ��� �� ������� � ����.");

	new string[128];
	PlayerInfo[giveplayerid][pAskMute] = 0;
    format(string, 128, "[AdmCmd]: %s %s[%d] ������������� �����-����� ������ %s[%d]", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid);
	SendAdminMessage(COLOR_ADMIN, string);
	if(GetPlayerAdmin(giveplayerid) == 0)
	{
		format(string, 128, "%s %s[%d] ������������� ��� �����-�����", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
		SendClientMessage(giveplayerid, COLOR_LIGHTRED, string);
	}
	PlayerPlaySound(giveplayerid, 1085, 0.0, 0.0, 0.0);
	return 1;
}

flags:askmute(CMD_MODER);
COMMAND:askmute(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /askmute [playerid/playername]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
    if(playerid == giveplayerid)
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������� �����-����� ������ ����.");

	new string[128];
	PlayerInfo[giveplayerid][pAskMute] = gettime() + 5 * 60;
    format(string, 128, "[AdmCmd]: %s %s[%d] ������� �����-����� ������ %s[%d] �� 5 �����", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid);
	SendAdminMessage(COLOR_ADMIN, string);
	if(GetPlayerAdmin(giveplayerid) == 0)
	{
		format(string, 128, "%s %s[%d] ������������ ��� �����-����� �� 5 �����", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
		SendClientMessage(giveplayerid, COLOR_LIGHTRED, string);
	}
	PlayerPlaySound(giveplayerid, 1085, 0.0, 0.0, 0.0);
	return 1;
}

flags:mute(CMD_MODER);
COMMAND:mute(playerid, params[])
{
	new string[128], giveplayerid, mutetime;
	if(sscanf(params, "ris[128]", giveplayerid, mutetime, string))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /mute [playerid] [�����(���)] [�������]");

    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	if(mutetime > 60)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ���� ���� �� ����� ��������� 60 �����.");
	if(mutetime < 0)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ���� ���� ������ ���� ������������� ���������.");
	else if(mutetime == 0)
	{
	    if(PlayerInfo[giveplayerid][pMuteTime] == 0)
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� � ��� �� ������� � ����.");

		PlayerInfo[giveplayerid][pMuteTime] = 0;
	    format(string, 128, "[AdmCmd]: %s %s[%d] ���� �������� � ������ %s[%d]",
			GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid);
	    MySendClientMessageToAll(COLOR_LIGHTRED, string);
	    return 1;
	}
    if(playerid == giveplayerid)
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ���� �������� ������ ����.");

	PlayerInfo[giveplayerid][pMuteTime] = mutetime*60;
    format(string, 128, "[AdmCmd]: %s %s[%d] ������� ��� ������ %s[%d] �� %d ���: %s",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, mutetime, string);
    MySendClientMessageToAll(COLOR_LIGHTRED, string), Admin_Log(string);
	PlayerPlaySound(giveplayerid, 1085, 0.0, 0.0, 0.0);
	return 1;
}

flags:mutelist(CMD_MODER);
COMMAND:mutelist(playerid, params[])
{
	new lstring[1792];
	new bool:founded = false;
	foreach(LoginPlayer, i)
	{
	    if(PlayerInfo[i][pMuteTime] > 0)
	    {
	        founded = true;
		    format(lstring, sizeof(lstring), "%s"MAIN_COLOR"� {FFFFFF}%s[%d] (%02d ���)\n", lstring, ReturnPlayerName(i), i, PlayerInfo[i][pMuteTime]);
		}
	}
	if(!founded) lstring = "{AFAFAF}< �� ������� ��� ������� � ���������. >";
	MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_LIST, "������ � ���������:", lstring, "�������");
	return 1;
}

stock GivePlayerWarn(playerid, giveplayerid, reason[])
{
	new string[128];
    if(playerid == -1) format(string, sizeof(string), "[AdmWrn]: ������");
    else format(string, sizeof(string), "[AdmWrn]: %s %s[%d]", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
    format(string, sizeof(string), "%s ����������� ������ %s[%d]: %s", string, ReturnPlayerName(giveplayerid), giveplayerid, reason);
	MySendClientMessageToAll(COLOR_LIGHTRED, string);
	PlayerPlaySound(giveplayerid, 1085, 0.0, 0.0, 0.0);

	PlayerInfo[giveplayerid][pWarnUNIX] = gettime();
	if(++PlayerInfo[giveplayerid][pWarns] >= 3)
	{
        new days = 3;
		format(string, sizeof(string), "[AdmWrn]: ������ ������� ������ %s[%d] �� %d ��� �� ��������� 3/3 ��������������", ReturnPlayerName(giveplayerid), giveplayerid, days);
		MySendClientMessageToAll(COLOR_LIGHTRED, string);
		PlayerInfo[giveplayerid][pBanUNIX] = gettime() + days * 24 * 60 * 60;
		PlayerInfo[giveplayerid][pWarns] = 0;
		KickEx(giveplayerid);
	}
	UpdatePlayerStatics(giveplayerid);
}

flags:warn(CMD_MODER);
COMMAND:warn(playerid, params[])
{
	new giveplayerid, reason[64];
	if(sscanf(params, "rs[64]", giveplayerid, reason))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /warn [playerid/playername] [�������]");

    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");

	if(playerid == giveplayerid)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ���� ���� ������ ����.");

	new string[128];
	if(GetPlayerAdmin(playerid) <= GetPlayerAdmin(giveplayerid))
	{
	    format(string, 128, "[AdmWrn]: %s %s[%d] �������� ���� ���� �������� ������ %s[%d]",
			GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid);
	    SendAdminMessage(COLOR_LIGHTRED, string, GetPlayerAdmin(giveplayerid));
	    return 1;
	}
	GivePlayerWarn(playerid, giveplayerid, reason);
	return true;
}

flags:unwarn(CMD_ADMIN);
COMMAND:unwarn(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /unwarn [playerid/playername]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
    if(PlayerInfo[giveplayerid][pWarns] == 0)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ����� ������ ��� ��������������.");
	new string[128];
	PlayerInfo[giveplayerid][pWarns]--;
    format(string, 128, "[AdmCmd]: %s %s[%d] ���� ���� ������ %s[%d]",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid);
    MySendClientMessageToAll(COLOR_LIGHTRED, string), Admin_Log(string);
    PlayerPlaySound(giveplayerid, 1085, 0.0, 0.0, 0.0);
	return 1;
}

flags:freeze(CMD_MODER);
COMMAND:freeze(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
	{
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /freeze [playerid/playername]");
	}
    if(!IsPlayerLogged(giveplayerid))
    {
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	}
	if(playerid != giveplayerid && GetPlayerAdmin(giveplayerid) >= ADMIN_MODER)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ���������� ������.");
	}
	new string[128];
	TogglePlayerControllable(giveplayerid, false);
    format(string, 128, "[AdmCmd]: %s %s[%d] ��������� ������ %s[%d]",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid);
    SendAdminMessage(COLOR_ADMIN, string);
    if(playerid != giveplayerid)
    {
		format(string, 128, "%s {FFFFFF}%s{33CCFF} ��������� ���", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid));
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
		PlayerPlaySound(giveplayerid, 1085, 0.0, 0.0, 0.0);
	}
	return 1;
}

flags:unfreezeall(CMD_MODER);
COMMAND:unfreezeall(playerid, params[])
{
	new Float:Radius;
	if(sscanf(params, "f", Radius))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /unfreezeall [radius]");
		
	new string[128], Float:pos[3];
	GetPlayerPos(playerid, Arr3<pos>);
	foreach(LoginPlayer, i)
	{
	    if(IsPlayerInRangeOfPoint(i, Radius, Arr3<pos>))
	    {
			TogglePlayerControllable(i, true);
			GameTextForPlayer(i, "~g~Unfreeze", 5000, 5);
			PlayerPlaySound(i, 1085, 0.0, 0.0, 0.0);
	    }
	}
    format(string, 128, "[AdmCmd]: %s %s[%d] ���������� ���� � ������� %.1f �� ����", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, Radius);
    SendAdminMessage(COLOR_ADMIN, string);
	return 1;
}

flags:unfreeze(CMD_MODER);
COMMAND:unfreeze(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /unfreeze [playerid/playername]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
		
	new string[128];
	TogglePlayerControllable(giveplayerid, true);
    format(string, 128, "[AdmCmd]: %s %s[%d] ���������� ������ %s[%d]",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid);
    SendAdminMessage(COLOR_ADMIN, string);
	if(!GetPlayerAdmin(giveplayerid))
    {
		format(string, 128, "%s {FFFFFF}%s{33CCFF} ���������� ���", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid));
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
		PlayerPlaySound(giveplayerid, 1085, 0.0, 0.0, 0.0);
	}
	return 1;
}

flags:clearchat(CMD_MODER);
COMMAND:clearchat(playerid, params[])
{
	for(new i; i < 100; i++)
	{
	    SendClientMessageToAll(COLOR_BLACK, "");
	}
	new string[128];
	format(string, 128, "[AdmCmd]: %s %s[%d] ������� ��� ��� ����", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
	SendAdminMessage(COLOR_ADMIN, string);
	return 1;
}

flags:settime(CMD_DEVELOPER);
COMMAND:settime(playerid, params[])
{
	new hour = 0, minute = 0;
	gettime(hour, minute, _);
	sscanf(params, "ii", hour, minute);
	SetPlayerTime(playerid, hour, minute);
	return 1;
}

COMMAND:weather(playerid, params[])
{
    if(GetPlayerAdmin(playerid) < ADMIN_ADMIN || GetPlayerAdmin(playerid) < ADMIN_IVENTER)
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��� �������.");

    new string[128], weatherid = 0;

	sscanf(params, "i", weatherid);
	if(weatherid < 0 || weatherid > 68)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ����� ������ �� 0 �� 68.");

    UpdateWeather(weatherid);

	if(weatherid == 0)
		format(string, 128, "[AdmCmd]: %s %s[%d] ������ ��������� ������ ��� �����",
			GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
	else
		format(string, 128, "[AdmCmd]: %s %s[%d] ������ ������ (#%d) ��� �����",
			GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, weatherid);
	SendAdminMessage(COLOR_ADMIN, string);
	return 1;
}

flags:setjob(CMD_DEVELOPER);
COMMAND:setjob(playerid, params[])
{// [BT]
    new giveplayerid, jobid;
	if(sscanf(params, "rd", giveplayerid, jobid))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /setjob [playerid/playername] [jobid]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	if(jobid < 0 || jobid >= sizeof(Jobs))
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ �� ����������.");
	if(jobid > 0 && !IsAvailableJob(giveplayerid, jobid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ������� �� �������.");

	Job.SetPlayerJob(giveplayerid, jobid);
	UpdatePlayerStatics(giveplayerid);

	new string[128];
	format(string, sizeof(string), "[AdmCmd]: %s %s[%d] �������� ����� ������ ������ %s[%d]: %s",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, GetJobName(jobid));
	SendAdminMessage(COLOR_ADMIN, string);
	SendFormatMessage(giveplayerid, COLOR_LIGHTBLUE, string, "%s %s[%d] �������� ����� ����� ������: {FFFFFF}%s", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, GetJobName(jobid));
	return 1;
}

COMMAND:afind(playerid, params[])
{
	if(GetPlayerAdmin(playerid) < ADMIN_DEVELOPER)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��� �������.");
    new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /afind [playerid/playername]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	new Float:pos[3];
	GetPlayerPos(giveplayerid, Arr3<pos>);
    ShowPlayerGPSPoint(playerid, Arr3<pos>);
    SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "�������������� ����� ������ �������� �� ������ "SCOLOR_GPS"������ ��������");
	return 1;
}

COMMAND:setskin(playerid, params[])
{
	if(GetPlayerAdmin(playerid) < ADMIN_ADMIN && GetPlayerAdmin(playerid) != ADMIN_IVENTER)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��� �������.");

    new giveplayerid, skinid;
	if(sscanf(params, "ri", giveplayerid, skinid))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /setskin [playerid/playername] [�� �����] [1 - ����������]");

    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");

	if(skinid > 311 || skinid < 0)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ���� �� 0 �� 311.");

	new string[128], forever = 0;
	sscanf(params, "{ri}i", forever);
	KillTimer(unfreeze_timer[giveplayerid]);
	unfreeze_timer[giveplayerid] = SetTimerEx("MyUnfreezePlayer", 3000, false, "i", giveplayerid);
	new skinname[32] = "����";
	if(forever == 1)
	{
	    if(GetPlayerAdmin(playerid) < ADMIN_ADMIN)
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ �������� ���������� ����.");
		skinname = "���������� ����";
		PlayerInfo[giveplayerid][pSkin] = skinid;
		UpdatePlayerSkin(giveplayerid);
		UpdatePlayerData(playerid, "skin", skinid);
	}
	else
	{
		MySetPlayerSkin(giveplayerid, skinid, false);
		//SetTimerEx("FixVehicleAnim", 1000, false, "i", giveplayerid);
	}
	format(string, 128, "[AdmCmd]: %s %s[%d] ����� ������ %s[%d] %s #%d",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, skinname, skinid);
	SendAdminMessage(COLOR_ADMIN, string);
	if(GetPlayerAdmin(giveplayerid) == 0)
	{
		format(string, 128, "%s {FFFFFF}%s{33CCFF} ����� ��� %s #%d", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), skinname, skinid);
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
	}
	return true;
}

COMMAND:givegun(playerid, params[])
{
	if(GetPlayerAdmin(playerid) < ADMIN_ADMIN && GetPlayerAdmin(playerid) != ADMIN_IVENTER)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��� �������.");
    new giveplayerid, weaponid, ammo;
	if(sscanf(params, "ri", giveplayerid, weaponid))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /givegun [playerid/playername] [�� ������] [�������]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	if(weaponid < 0 || weaponid >= sizeof(GunParams) || !GunParams[weaponid][GUN_EXIST])
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ������������ �� ������.");
	if(sscanf(params, "{ri}i", ammo))
		ammo = GunParams[weaponid][GUN_AMMO];
	else if(ammo < 1 || ammo > 10000)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������� �� 1 �� 10000.");
	new string[128], gunname[64];
	GetWeaponName(weaponid, gunname, 64);
	//MyGivePlayerWeapon(giveplayerid, weaponid, ammo);
	Inv.GivePlayerWeapon(giveplayerid, weaponid, ammo);
	Inv.SavePlayerWeapon(playerid);
	format(string, 128, "[AdmCmd]: %s %s[%d] ����� ������ %s[%d] %s (%d ������)",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, gunname, ammo);
	SendAdminMessage(COLOR_ADMIN, string);
	if(!GetPlayerAdmin(giveplayerid))
	{
		format(string, 128, "%s {FFFFFF}%s[%d]{33CCFF} ����� ��� %s (%d ������)", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, gunname, ammo);
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
	}
	return 1;
}

CMD:changepass(playerid, params[])
{
	ShowDialog(playerid, DMENU_CHANGE_PASS);
	return 1;
}

flags:setpass(CMD_DEVELOPER);
CMD:setpass(playerid, params[])
{
    new userid, clear_pass[32];
	if(sscanf(params, "is[32]", userid, clear_pass))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /setpass [USER_ID] [new_password]");
	new string[164];
	if((MIN_PASS_SYMB <= strlen(clear_pass) < MAX_PASS_SYMB) == false)
		return SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "����������� ������ ������ �� %d �� %d ��������.", MIN_PASS_SYMB, MAX_PASS_SYMB);

	if(GetPVarInt(playerid, "SETPASS:ID") != userid)
	{
		format(string, 128, "�� ��������� �������� ������ ������: %s (������� ������� ��������)", GetPlayerUsername(userid));
		SendClientMessage(playerid, COLOR_SERVER, string);
		SetPVarInt(playerid, "SETPASS:ID", userid);
		return 1;
	}

	new salt[MAX_SALT_PASS];
    strmid(salt, generateCode(MAX_SALT_PASS), 0, MAX_SALT_PASS);
	mysql_format(g_SQL, string, sizeof(string), "UPDATE `players` SET `password` = MD5(CONCAT(MD5('%s'), MD5('%s'))), salt = MD5('%s') WHERE `id` = '%d'", clear_pass, salt, salt, userid);
	mysql_query(g_SQL, string);
	if(cache_affected_rows())
	{
		format(string, 128, "[AdmCmd]: %s %s[%d] ������� ������ ������ %s (userid: %d)", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, GetPlayerUsername(userid), userid);
		SendAdminMessage(COLOR_ADMIN, string);

		new giveplayerid = GetPlayeridToUserID(userid);
		if(giveplayerid != INVALID_PLAYER_ID)
		{
			format(string, sizeof(string), "[�������]: %s %s ������� ��� ������: {FFFFFF}%s", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), clear_pass);
			SendClientMessage(giveplayerid, COLOR_LIGHTRED, string);
		}
		DeletePVar(playerid, "SETPASS:ID");
	}
	else return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������� ������ ��������� �������������� ������.");
	return 1;
}

flags:changename(CMD_DEVELOPER);
COMMAND:changename(playerid, params[])
{
    new giveplayerid, playername[32];
	if(sscanf(params, "rs[32]", giveplayerid, playername))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /changename [playerid/playername] [new_playername]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	if(strcheck(playername, ReturnPlayerName(giveplayerid), false))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������� ������ ��� �� ��� �� �����.");
	if(!IsCorrectName(playername))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ����� ���� ������������ ������������ �������.");

    new string[128], count;
	format(string, sizeof(string), "SELECT COUNT(*) AS count FROM `players` WHERE `username` = '%s'", playername);
	new Cache:result = mysql_query(g_SQL, string);
	cache_get_value_name_int(0, "count", count);
	cache_delete(result);
	if(count > 0)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ��� ����������� ������� ������.");

	mysql_format(g_SQL, string, sizeof(string), "UPDATE `players` SET `username` = '%s' WHERE `id` = '%d'", playername, PlayerInfo[giveplayerid][pUserID]);
	mysql_query(g_SQL, string);
	if(cache_affected_rows())
	{
		format(string, 128, "[AdmCmd]: %s %s[%d] ������� ��� ������ %s[%d] �� %s[%d]",
			GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, playername, giveplayerid);
		SendAdminMessage(COLOR_ADMIN, string);
		SendFormatMessageToAll(COLOR_ORANGE, string, "[NEWS]: {FFFFFF}%s{FF8300} ������ �������� ��� {FFFFFF}%s{FF8300}", ReturnPlayerName(giveplayerid), playername);
        SetPlayerName(giveplayerid, playername);
	}
	else return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������� ���� ��������� �������������� ������.");
	return 1;
}

flags:givemoney(CMD_DEVELOPER);
COMMAND:givemoney(playerid, params[])
{
    new giveplayerid, money;
	if(sscanf(params, "ri", giveplayerid, money))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /givemoney [playerid/playername] [���-��($)]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	new string[128];
	MyGivePlayerMoney(giveplayerid, money);
	format(string, 128, "[AdmCmd]: %s %s[%d] ����� ������ %s[%d] %d$",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, money);
	SendAdminMessage(COLOR_ADMIN, string);
	if(!GetPlayerAdmin(giveplayerid))
	{
		format(string, 128, "%s {FFFFFF}%s{33CCFF} ����� ��� %d$", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), money);
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
	}
	return 1;
}

flags:givecoins(CMD_DEVELOPER);
COMMAND:givecoins(playerid, params[])
{
    new giveplayerid, coins;
	if(sscanf(params, "ri", giveplayerid, coins))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /givecoins [playerid/playername] [���-�� �����]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	new string[128];
	GivePlayerCoins(giveplayerid, coins);
	format(string, 128, "[AdmCmd]: %s %s[%d] ����� ������ %s[%d] %d �����",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, coins);
	SendAdminMessage(COLOR_ADMIN, string);
	if(!GetPlayerAdmin(giveplayerid))
	{
		format(string, 128, "%s {FFFFFF}%s{33CCFF} ����� ��� %d �����", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), coins);
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
	}
	return 1;
}

flags:ban(CMD_MODER);
COMMAND:ban(playerid, params[])
{
	new giveplayerid, days, reason[64];
	if(sscanf(params, "ris[64]", giveplayerid, days, reason))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /ban [playerid/playername] [�����(���)] [�������]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	if(playerid == giveplayerid)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ �������� ������ ����.");
	if(!(1 <= days <= 30))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ����� �� 1 �� 30 ����.");

	new string[128];
	if(GetPlayerAdmin(playerid) <= GetPlayerAdmin(giveplayerid) && !IsPlayerAdmin(playerid))
	{
	    format(string, 128, "[AdmWrn]: %s %s[%d] �������� �������� �������� ������ %s[%d]",
			GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid);
	    return SendAdminMessage(COLOR_LIGHTRED, string);
	}
	SendFormatMessageToAll(COLOR_LIGHTRED, string, "[AdmWrn]: %s %s ������� ������ %s �� %d ����: %s", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), ReturnPlayerName(giveplayerid), days, reason);
	Admin_Log(string);
	//
	ClearChatbox(giveplayerid, 100);
	PlayerInfo[giveplayerid][pBanUNIX] = gettime() + days * 24 * 60 * 60;
	SendClientMessage(giveplayerid, COLOR_SERVER, "You are banned from this server.");
	SendFormatMessage(giveplayerid, COLOR_LIGHTRED, string, "�������: %s {FFFFFF}%s", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid));
	SendFormatMessage(giveplayerid, COLOR_LIGHTRED, string, "����� ����: {FFFFFF}%d ����", days);
	SendFormatMessage(giveplayerid, COLOR_LIGHTRED, string, "�������: {FFFFFF}%s", reason);
	SendFormatMessage(giveplayerid, COLOR_LIGHTRED, string, "����, �����: {FFFFFF}%s %s", ReturnDate(), ReturnTime());
	SendClientMessage(giveplayerid, COLOR_LIGHTRED, " ");
	SendClientMessage(giveplayerid, COLOR_LIGHTRED, "�� ������ ���������� ��� �� ������");
	SendClientMessage(giveplayerid, COLOR_LIGHTRED, "����� ������: {FFFFFF}forum." SITE_ADRESS);
	SendClientMessage(giveplayerid, COLOR_LIGHTRED, "��� ����� �������� ����� ����� ���� �� F8");
	KickEx(giveplayerid);
	return true;
}

flags:checkban(CMD_MODER);
COMMAND:checkban(playerid, params[])
{
	new name[24];
	if(sscanf(params, "s[24]", name))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /checkban [playername]");

	new string[256];
	mysql_format(g_SQL, string, sizeof(string), "SELECT `banunix` FROM `players` WHERE `username` = '%s'", name);
	new Cache:result = mysql_query(g_SQL, string);
	if(!cache_num_rows())
	{
		cache_delete(result);
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ������ �� ����������.");
	}
	new banunix;
	cache_get_value_name_int(0, "banunix", banunix);
	cache_delete(result);
	format(string, sizeof(string), "[AdmCmd]: %s %s[%d] �������� ������ ���� �������� '%s': ", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, name);
	if(banunix)
	{
		strcat(string, "�������");
		SendAdminMessage(COLOR_ADMIN, string);
		SendRemainingBanTime(playerid, banunix);
	}
	else
	{
		strcat(string, "�� �������");
		SendAdminMessage(COLOR_ADMIN, string);
	}
	return true;
}

flags:unban(CMD_ADMIN);
COMMAND:unban(playerid, params[])
{
	new name[24];
	if(sscanf(params, "s[24]", name))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /unban [playername]");
	new string[256];
	mysql_format(g_SQL, string, sizeof(string), "SELECT `banunix` FROM `players` WHERE `username` = '%s'", name);
	new Cache:result = mysql_query(g_SQL, string);
	if(!cache_num_rows())
	{
		cache_delete(result);
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ������ �� ����������.");
	}
	new banunix;
	cache_get_value_index_int(0, 0, banunix);
	cache_delete(result);
	if(banunix == 0)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� �� ������� �� ��������.");
	mysql_format(g_SQL, string, sizeof(string), "UPDATE `players` SET `banunix` = '0' WHERE `username` = '%s'", name);
	mysql_query_ex(string);
	format(string, sizeof(string), "[AdmCmd]: %s %s[%d] �������� ������� '%s'", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, name);
	SendAdminMessage(COLOR_ADMIN, string);
	return true;
}

flags:banip(CMD_MODER);
COMMAND:banip(playerid, params[])
{
	new ip[16], days;
	if(sscanf(params, "s[16]i", ip, days) || IsIpAdress(ip) == 0)
	{
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /banip [ip][�����(���)]");
	}
	if((1 <= days <= 30) == false)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ����� �� 1 �� 30 ����.");
	}
	new string[128];
	mysql_format(g_SQL, string, sizeof(string), "SELECT `id` FROM `banips` WHERE `ip` = '%s'", ip);
	new Cache:result = mysql_query(g_SQL, string);
	new banid;
	cache_get_value_name_int(0, "id", banid);
	cache_delete(result);
	if(banid)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ip ����� ��� ��� �������.");
	}

	mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `banips` SET `ip` = '%s', `time` = '%d'", ip, gettime() + days * 24 * 60 * 60);
	mysql_query_ex(string);

	//format(string, 128, "banip %s", ip);
	//SendRconCommand(string);
	BlockIpAddress(ip, days * 24 * 60 * 60 * 1000);

	format(string, 128, "[AdmCmd]: %s %s[%d] ������� ip ����� '%s' �� %d ����", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ip, days);
	SendAdminMessage(COLOR_ADMIN, string);
	return true;
}

flags:unbanip(CMD_ADMIN);
COMMAND:unbanip(playerid, params[])
{
	new ip[16];
	if(sscanf(params, "s[16]", ip) || !IsIpAdress(ip))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /unbanip [ip]");
	new string[128];
	mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `banips` WHERE `ip` = '%e'", ip);
	new Cache:result = mysql_query(g_SQL, string);

	//format(string, 128, "unbanip %s", ip);
	//SendRconCommand(string);
	//SendRconCommand("reloadbans");
	UnBlockIpAddress(ip);

	format(string, 128, "[AdmCmd]: %s %s[%d] �������� ip ����� '%s'", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ip);
    if(!cache_affected_rows()) strcat(string, " (�������� �� ��� �������)");
	SendAdminMessage(COLOR_ADMIN, string);
	cache_delete(result);
	return true;
}

flags:checkip(CMD_MODER);
COMMAND:checkip(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /checkip [playerid/playername]");
	if(IsPlayerLogged(giveplayerid) == 0)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");

	new string[256], ip_address[24] = "?";
	mysql_format(g_SQL, string, sizeof(string), "SELECT `ip_address` FROM `players` WHERE `id` = '%d'", PlayerInfo[giveplayerid][pUserID]);
	new Cache:result = mysql_query(g_SQL, string);
	if(cache_num_rows()) cache_get_value_index(0, 0, ip_address);
	cache_delete(result);
	
	format(string, sizeof(string), "* %s[%d] - RegIP(%s) IP(%s)", ReturnPlayerName(giveplayerid), giveplayerid, ip_address, ReturnPlayerIP(giveplayerid));
	SendClientMessage(playerid, COLOR_GREY, string);
	return true;
}

flags:checktwink(CMD_MODER);
COMMAND:checktwink(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
	{
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /checktwink [playerid/playername]");
	}
	if(IsPlayerLogged(giveplayerid) == 0)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	}
	new query[128], ip[16], lstring[1024];
	GetPlayerIp(giveplayerid, ip, 16);
	mysql_format(g_SQL, query, sizeof query, "SELECT `username` FROM `players` WHERE `ip_address` = '%s' AND `id` <> '%d'", ip, PlayerInfo[giveplayerid][pUserID]);
	new Cache:result = mysql_query(g_SQL, query);
	new row = cache_num_rows();
	if(row == 0)
	{
		lstring = "< �� ������� ���������� �� IP ������. >";
	}
	else
	{
		lstring = "������ �������� �� IP ������ ������:\n\n";
		new name[24];
		for(new i = 0; i < row; i++)
		{
			cache_get_value_index(i, 0, name);
			format(lstring, sizeof lstring, "%s%s\n", lstring, name);
		}
	}
	cache_delete(result);
	MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "�������� �� �������", lstring, "�������", "");
	format(query, sizeof(query), "[AdmCmd]: %s %s[%d] �������� ������ %s �� ������� �������: %s", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), row ? ("����") : ("���"));
	SendAdminMessage(COLOR_ADMIN, query);
	return true;
}

flags:spawncars(CMD_MODER);
COMMAND:spawncars(playerid, params[])
{
	new Float:radius;
	if(sscanf(params, "f", radius) || radius < 0.5)
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /spawncars [������]");
	new string[128], vehicles;
	new Float:X, Float:Y, Float:Z;
	foreach(Vehicle, v)
	{
	    if(!VehInfo[v][vCreated] || !IsVehicleIsEmpty(v)) continue;
	    if(BusVehicle[0] <= v <= BusVehicle[2]) continue;
	    GetVehiclePos(v, X, Y, Z);
		if(IsPlayerInRangeOfPoint(playerid, radius, X, Y, Z))
		{
		    vehicles++;
			MySetVehicleToRespawn(v);
		    // �� ������ �������� ���� �� ����� ������
			if(VehInfo[v][vCreated] == false) v = VehInfo[v][vIterNext];
		}
	}
	format(string, 128, "[AdmCmd]: %s %s[%d] ����������� %d ����� � ������� %0.1f �� ����",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, vehicles, radius);
	SendAdminMessage(COLOR_ADMIN, string);
    return true;
}

flags:goto(CMD_IVENTER);
COMMAND:goto(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
		return ShowDialog(playerid, DMODE_GOTOLIST);
    if(!IsPlayerLogged(giveplayerid))
    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	new string[128];
	new Float: X, Float: Y, Float: Z;
	new inter = GetPlayerInterior(giveplayerid);
	new vw = GetPlayerVirtualWorld(giveplayerid);
	GetPlayerPos(giveplayerid, X, Y, Z);
	SetPlayerInterior(playerid, inter);
	SetPlayerVirtualWorld(playerid, vw);
	CreateGotoSmoke(playerid);
	if(GetPlayerState(playerid) == 2)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		MySetVehiclePos(vehicleid, X+2, Y+2, Z);
		LinkVehicleToInterior(vehicleid, PlayerInfo[playerid][pPosINT]);
		SetVehicleVirtualWorld(vehicleid, PlayerInfo[playerid][pPosVW]);
	}
	else MySetPlayerPos(playerid, X, Y+2, Z);
	format(string, 128, "[AdmCmd]: %s %s[%d] ���������������� � ������ %s[%d]",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid);
	SendAdminMessage(COLOR_ADMIN, string);
	return 1;
}

flags:gethere(CMD_IVENTER);
COMMAND:gethere(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /gethere [playerid/playername]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	if(playerid == giveplayerid)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ��������������� ������ ����.");
	if(GetPlayerAdmin(giveplayerid) >= ADMIN_MODER)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ��������������� ������.");
	if(PlayerBusy{giveplayerid} == true)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ���-�� �������� � ������ ������.");
	new string[128];
	new Float: X, Float: Y, Float: Z;
	GetPlayerPos(playerid, X, Y, Z);
	new inter = GetPlayerInterior(playerid);
	new vw = GetPlayerVirtualWorld(playerid);
	SetPlayerInterior(giveplayerid, inter);
	SetPlayerVirtualWorld(giveplayerid, vw);
	if(GetPlayerState(giveplayerid) == 2)
	{
		new vehicleid = GetPlayerVehicleID(giveplayerid);
		MySetVehiclePos(vehicleid, X+2, Y+2, Z);
		LinkVehicleToInterior(vehicleid, PlayerInfo[giveplayerid][pPosINT]);
		SetVehicleVirtualWorld(vehicleid, PlayerInfo[giveplayerid][pPosVW]);
	}
	else MySetPlayerPos(giveplayerid, X, Y+2, Z);
	format(string, 128, "[AdmCmd]: %s %s[%d] �������������� � ���� ������ %s[%d]",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid);
	SendAdminMessage(COLOR_ADMIN, string);
	if(!GetPlayerAdmin(giveplayerid))
	{
		format(string, 128, "%s {FFFFFF}%s{33CCFF} �������������� ��� � ����", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid));
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
    }
	return true;
}

COMMAND:makeadmin(playerid, params[])
{
	if(!IsPlayerAdmin(playerid) && GetPlayerAdmin(playerid) < ADMIN_GADMIN)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��� �������.");
    new giveplayerid, adminlvl;
	if(sscanf(params, "ri", giveplayerid, adminlvl))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /makeadmin [playerid/playername] [�������]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	new string[164];
	if(!(0 <= adminlvl < GetPlayerAdmin(playerid)))
		return SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "������� �����-������� �� 0 �� %d.", GetPlayerAdmin(playerid)-1);
	if(PlayerInfo[giveplayerid][pAdmin] == adminlvl)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ��� ����� ������ �����-�������.");
	if(adminlvl == 0)
	{
		if(playerid == giveplayerid)
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ����� � ���� �������.");
		if(GetPlayerAdmin(playerid) <= GetPlayerAdmin(giveplayerid))
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ����������� ����� ������.");
		AdminDuty[giveplayerid] = false;
		PlayerInfo[giveplayerid][pAdmin] = 0;
		format(string, 128, "[AdmCmd]: %s %s[%d] ���� ������� � %s[%d]",
			GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid);
		SendAdminMessage(COLOR_ADMIN, string);
		format(string, 128, "%s %s[%d] ���� � ��� �������", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
		SendClientMessage(giveplayerid, COLOR_LIGHTRED, string);
	}
	else
	{
	    if(playerid == giveplayerid && adminlvl < PlayerInfo[playerid][pAdmin])
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ �������� ���� ����� �������.");
		PlayerInfo[giveplayerid][pAdmin] = adminlvl;
		format(string, 128, "[AdmCmd]: %s %s[%d] ����� ������ %s[%d] ����� ������� [%s]",
			GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, GetPlayerAdminStatus(giveplayerid));
		SendAdminMessage(COLOR_ADMIN, string);
		format(string, 128, "%s %s ����� ��� ����� �������: [%s]", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), GetPlayerAdminStatus(giveplayerid));
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);

		if(AUTOADMIN) AdminDuty[giveplayerid] = true;
	}
	return 1;
}

flags:restart(CMD_ADMIN);
COMMAND:restart(playerid, params[])
{
	new string[128], resttime;
	if(sscanf(params, "i", resttime))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /restart [�������]");
	else if(resttime == 0)
	{
	    if(!RestTime)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� �������� �� �������.");
	    RestTime = 0;
	    foreach(Player, i)
	    {
	    	IFace.ToggleGroup(playerid, IFace.RESTART, false);
		}
		format(string, 128, "[AdmCmd]: %s %s[%d] ������� ������� �������", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
		SendAdminMessage(COLOR_ADMIN, string);
	}
	else
	{
	    RestTime = resttime;
	    IFace.UpdateRestartInfo(RestTime);
		format(string, sizeof(string), "~r~�������~n~����� ~w~%02d:%02d", RestTime / 60, RestTime % 60);
	    foreach(Player, i)
		{
			IFace.ToggleGroup(i, IFace.RESTART, true);
			GameTextForPlayer(i, RusText(string, isRus(playerid)), 5000, 4);
		}
		format(string, 128, "[AdmCmd]: %s %s[%d] �������� ������� ������� ����� %d ������",
			GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, resttime);
		SendAdminMessage(COLOR_ADMIN, string);
	}
	return 1;
}

flags:aen(CMD_ADMIN);
COMMAND:aen(playerid, params[])
{// [BT] // Admin Start/Stop Engine
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetPlayerState(playerid) != 2)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ������ �� �����, ����� ������������ ��� �������.");
	if(!GetVehicleEngine(vehicleid))
	{// �������
		SetVehicleEngine(vehicleid, true);
		GameTextForPlayer(playerid, "~w~Engine ~g~On", 1000, 4);
	}
	else
	{	// ������
	    if(!IsVehicleWithEngine(vehicleid))
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������� ������ �� ����� ����������.");
		SetVehicleEngine(vehicleid, false);
		GameTextForPlayer(playerid, "~w~Engine ~r~Off", 1000, 4);
	}
	return true;
}

COMMAND:v(playerid, params[])
{
	if(GetPlayerAdmin(playerid) < ADMIN_ADMIN && GetPlayerAdmin(playerid) != ADMIN_IVENTER)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��� �������.");
	new car;
	if(sscanf(params, "i", car))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /v [������] [����1] [����2]");
	new color1 = -1, color2 = -1;
	sscanf(params, "{i}ii", color1, color2);
	if(car < 400 || car > 611)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������ ������, ��������� �� 400 �� 611.");
	if(color1 < -1 || color1 > 255 || color2 < -1 || color2 > 255)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������ ����, ��������� �� -1 �� 255.");
	new string[128],
	    Float:angle,
		Float:X,Float:Y,Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, angle);
	new carid = MyCreateVehicle(car, X+2, Y+2, Z+2, angle, color1, color2, 0);
	CarInfo[carid][cType] = C_TYPE_EVENT; // �������� ��� ����
	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
	format(string, 128, "[BT]: �� ������� ������ #%d [model %d]", carid, car);
    return SendClientMessage(playerid, COLOR_SERVER, string);
}

flags:gotohouse(CMD_DEVELOPER);
COMMAND:gotohouse(playerid, params[])
{
    new h;
    if(sscanf(params, "i", h))
        return SendClientMessage(playerid, COLOR_WHITE, "�����������: /gotohouse [house num]");
	if(h < 0 || h >= sizeof(HouseInfo) || HouseInfo[h][hID] == 0)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ���� �� ���������� � ����.");
	gPickupTime[playerid] = 5;
	MySetPlayerPos(playerid, HouseInfo[h][hX], HouseInfo[h][hY], HouseInfo[h][hZ], HouseInfo[h][hA]);
	return 1;
}

flags:house(CMD_DEVELOPER);
COMMAND:house(playerid, params[])
{
	if(PickupedHouse[playerid] == -1)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��������� � ���� ����� ������������ ��� �������.");
    new const h = PickupedHouse[playerid];
	if(h < 0 || h >= sizeof(HouseInfo) || HouseInfo[h][hID] == 0)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ��� ������ ������������� - ��� �� ���������� � ����.");
    new string[152];
    if(sscanf(params, "s[32] ", string))
        return SendClientMessage(playerid, COLOR_WHITE, "�����������: /house [info/create/delete/enter/price/donate/class/int]");
	if(strcheck(string, "info"))
	{
		format(string, sizeof(string), "��� #%d: {FFFFFF}��������[%s], �����[%c], ��������[%d], ����[%d%s], ������[%d/%d], ���.������[%d]",
			HouseInfo[h][hID], GetPlayerUsername(HouseInfo[h][hOwnerID]), HouseInfo[h][hClass]+64, HouseInfo[h][hInt],
			HouseInfo[h][hPrice], (HouseInfo[h][hDonate] > 0) ? (" �����") : ("$"), GetOccupiedFurSlots(h), GetHouseFurSlot(h), HouseInfo[h][hExtraSlots]);
		SendClientMessage(playerid, COLOR_GREEN, string);
	    return 1;
	}
	if(strcheck(string, "create"))
	{// [BT]
	    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������� �������� ����������.");
	    return 1;
	}
	if(strcheck(string, "delete"))
	{
	    if(HouseInfo[h][hOwnerID] > 0)
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������� ���-�� ����� ���.");
		if(sscanf(params, "{s[32]}s[4] ", string) || !strcheck(string, "yes"))
		    return SendClientMessage(playerid, COLOR_WHITE, "��� ������������� �������� ������� /house delete yes");
		// �������� ������ � �������
		mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `houses` WHERE `id` = '%d'", HouseInfo[h][hID]);
		mysql_query_ex(string);

		// �������� ����
		new hid = HouseInfo[h][hID];
		HouseInfo[h][hID] = 0;
	    UpdateHouse(h, false);

		// ���������
		PickupedHouse[playerid] = -1;
	    if(PickupedHouse[playerid] != (-1))
				HidePropertyMenu(playerid);
	    else 	MyHidePlayerDialog(playerid);
	    format(string, 128, "��� #%d: {FFFFFF}�� ������� ���� ���", hid);
	    SendClientMessage(playerid, COLOR_LIGHTRED, string);
	    return 1;
	}
	if(strcheck(string, "enter"))
	{
        new const Class = HouseInfo[h][hClass] - 1;
        new const Int = HouseInfo[h][hInt] - 1;
		SetCameraBehindPlayer(playerid);
		HidePropertyMenu(playerid); MyHidePlayerDialog(playerid);
        MySetPlayerPosFade(playerid, FT_NONE, Arr3<InterCoords[Class][Int]>, InterCoords[Class][Int][3] + 180.0, false, 1, VW_HOUSE + HouseInfo[h][hID]);
	    return 1;
	}
	if(strcheck(string, "price"))
	{
	    new price;
		if(sscanf(params, "{s[32]}i", price))
		{
		    SendFormatMessage(playerid, COLOR_WHITE, string, "�����������: /house price [ammount] (now: %d$)", HouseInfo[h][hPrice]);
		    return 1;
		}
		if(price < 0)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������ �������� ���������.");
		HouseInfo[h][hPrice] = price;
	    SaveHouse(h);
	    UpdateHouse(h);
	    if(PickupedHouse[playerid] != (-1))
		{
			HidePropertyMenu(playerid);
			gPickupTime[playerid] = 0;
		}
	    else MyHidePlayerDialog(playerid);
	    if(HouseInfo[h][hDonate])	format(string, 128, "��� #%d: {FFFFFF}��������� ���� ��������: %d$", HouseInfo[h][hID], HouseInfo[h][hPrice]);
	    else                 		format(string, 128, "��� #%d: {FFFFFF}��������� ���� ��������: %d �����", HouseInfo[h][hID], HouseInfo[h][hPrice]);
	    SendClientMessage(playerid, COLOR_GREEN, string);
	    return 1;
	}
	if(strcheck(string, "donate"))
	{
	    new amount;
		if(sscanf(params, "{s[32]}i", amount))
		{
		    SendFormatMessage(playerid, COLOR_WHITE, string, "�����������: /house donate [(1 - donate, 0 - not)] (now: %d)", HouseInfo[h][hDonate]);
		    return 1;
		}
		if(amount != 0 && amount != 1)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������ ��������.");
		HouseInfo[h][hDonate] = amount;
	    SaveHouse(h);
	    UpdateHouse(h);
	    if(PickupedHouse[playerid] != (-1))
		{
			HidePropertyMenu(playerid);
			gPickupTime[playerid] = 0;
		}
	    else MyHidePlayerDialog(playerid);
	    format(string, 128, "��� #%d: {FFFFFF}�������� ���� ���� ��������: %s", HouseInfo[h][hID], (HouseInfo[h][hDonate]) ? ("�������") : ("�������"));
	    SendClientMessage(playerid, COLOR_GREEN, string);
	    return 1;
	}
	if(strcheck(string, "class"))
	{
	    if(HouseInfo[h][hOwnerID] > 0)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ������������� ����� ���������� ����.");
	    new Class;
		if(sscanf(params, "{s[32]}i", Class))
		    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /house class [ammount]");
		if(Class < 1 || Class > 5)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� �������� ������ �� 1 �� 5.");
		HouseInfo[h][hClass] = Class;
	    SaveHouse(h);
	    UpdateHouse(h);
	    if(PickupedHouse[playerid] != (-1))
		{
			HidePropertyMenu(playerid);
			gPickupTime[playerid] = 0;
		}
	    else MyHidePlayerDialog(playerid);
	    format(string, 128, "��� #%d: {FFFFFF}����� ���� �������: %c", HouseInfo[h][hID], HouseInfo[h][hClass]+64);
	    SendClientMessage(playerid, COLOR_GREEN, string);
	    return 1;
	}
	if(strcheck(string, "int"))
	{
	    if(HouseInfo[h][hOwnerID] > 0)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ������������� �������� ���������� ����.");
	    new Int;
		if(sscanf(params, "{s[32]}i", Int))
		    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /house int [ammount]");
		if(Int < 1 || Int > 5)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� �������� ��������� �� 1 �� 5.");
		HouseInfo[h][hInt] = Int;
	    SaveHouse(h);
	    UpdateHouse(h);
	    if(PickupedHouse[playerid] != (-1))
		{
			HidePropertyMenu(playerid);
			gPickupTime[playerid] = 0;
		}
	    else MyHidePlayerDialog(playerid);
	    format(string, 128, "��� #%d: {FFFFFF}�������� ���� �������: %d", HouseInfo[h][hID], HouseInfo[h][hInt]);
	    SendClientMessage(playerid, COLOR_GREEN, string);
	    return 1;
	}
	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ �������� � ���� ������� �� ����������.");
}

flags:setcolor(CMD_DEVELOPER);
COMMAND:setcolor(playerid, params[])
{// [BT]
	new string[128], color1, color2;
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���� � ����������.");
	if(sscanf(params, "ii", color1, color2))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /setcolor [����1] [����2]");
	if(color1 < -1 || color1 > 255 || color2 < -1 || color2 > 255)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������ ����, ��������� �� -1 �� 255.");
	new vehicleid = GetPlayerVehicleID(playerid);
	MyChangeVehicleColor(vehicleid, color1, color2);
	format(string, 128, "������ #%d ������ �����: %d � %d", vehicleid, color1, color2);
    SendClientMessage(playerid, COLOR_GREEN, string);
	return 1;
}

flags:spawncar(CMD_MODER);
COMMAND:spawncar(playerid, params[])
{// [BT] ����� �� ���� � �������
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���� � ����������.");
	new string[128];
    new vehicleid = GetPlayerVehicleID(playerid);
	MySetVehicleToRespawn(vehicleid);
    format(string, 128, "������ %d ������� ������������", vehicleid);
    SendClientMessage(playerid, COLOR_WHITE, string);
    return 1;
}

flags:newinter(CMD_DEVELOPER);
COMMAND:newinter(playerid, params[])
{// [BT]
	new internum;
	if(sscanf(params, "i", internum))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /newinter [internum (1,2,..,n)]");

	switch(internum)
	{
		case 1:
		{
		    MySetPlayerPos(playerid, 2218.40, -1076.18, 1050.48, 0.0, 1);
		    SendClientMessage(playerid, COLOR_WHITE, "�������� ����� � ��������� #1");
		}
		case 2:
		{
		    MySetPlayerPos(playerid, 2233.64, -1115.26, 1050.88, 0.0, 5);
		    SendClientMessage(playerid, COLOR_WHITE, "�������� ����� � ��������� #2");
		}
		case 3:
		{
		    MySetPlayerPos(playerid, 2258.4766, -1209.7891, 1048.9922, 0.0, 10);
		    SendClientMessage(playerid, COLOR_WHITE, "����� ������ �������� ���� ~Class B");
		}
		case 4:
		{
		    MySetPlayerPos(playerid, 2190.5469, -1201.5625, 1048.0078, 0.0, 6);
		    SendClientMessage(playerid, COLOR_WHITE, "����� ������ �������� ���� ~Class C");
		}
		case 5:
		{
		    MySetPlayerPos(playerid, 2243.3281, -1067.8281, 1048.0234, 0.0, 2);
		    SendClientMessage(playerid, COLOR_WHITE, "����� ������ �������� ���� ~Class D");
		}
		case 6:
		{
		    MySetPlayerPos(playerid, 2372.0938, -1124.2188, 1049.8516, 0.0, 8);
		    SendClientMessage(playerid, COLOR_WHITE, "����� ������ �������� ���� ~Class C");
		}
		case 7:
		{
		    MySetPlayerPos(playerid, 2321.4609, -1019.7500, 1049.3672, 0.0, 9);
		    SendClientMessage(playerid, COLOR_WHITE, "����� ������ �������� ���� ~Class B. ���� �������� �� /inter 2-5");
		}
		case 8:
		{
		    MySetPlayerPos(playerid, 2335.4297, -1065.7422, 1048.4844, 0.0, 6);
		    SendClientMessage(playerid, COLOR_WHITE, "����� ������ �������� ���� ~Class D. ���� �������� �� /inter 4-5");
		}
	}
	return 1;
}

flags:inter(CMD_DEVELOPER);
COMMAND:inter(playerid, params[])
{// [BT]
	new IntClass, IntNum;
	if(sscanf(params, "ii", IntClass, IntNum) || !(1 <= IntClass <= 5) || !(1 <= IntNum <= 5))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /inter [class] [num]");
	new string[128], Class;
	new Float:X = InterCoords[IntClass-1][IntNum-1][0];
	new Float:Y = InterCoords[IntClass-1][IntNum-1][1];
	new Float:Z = InterCoords[IntClass-1][IntNum-1][2];
	new Float:A = InterCoords[IntClass-1][IntNum-1][3];
	switch(IntClass-1)
	{
	    case 0: Class = 'A';
	    case 1: Class = 'B';
	    case 2: Class = 'C';
	    case 3: Class = 'D';
	    case 4: Class = 'E';
	}
	SetPlayerInterior(playerid, 1);
	MySetPlayerPos(playerid, X, Y, Z, A+180.0);
	SetCameraBehindPlayer(playerid);
	format(string, 128, "Class %c, #%d", Class, IntNum);
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}

flags:tp(CMD_ADMIN);
COMMAND:tp(playerid, params[])
{// [BT]
	new Float:X, Float:Y, Float:Z, Float:A;
	if(sscanf(params, "p<,>ffff", X, Y, Z, A) && sscanf(params, "p<,>fff", X, Y, Z))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /tp [x,y,z]");
	new vehicleid = GetPlayerVehicleID(playerid);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	if(IsPlayerInAnyVehicle(playerid))
	{
		MySetVehiclePos(vehicleid, X, Y, Z, A);
		LinkVehicleToInterior(vehicleid, 0);
		SetVehicleVirtualWorld(vehicleid, 0);
	}
	else
		MySetPlayerPos(playerid, X, Y, Z, A);
    SendClientMessage(playerid, COLOR_WHITE, "�� ����������������� �� �����������");
	return 1;
}

Public: EmptyFunc() { }
flags:gettimer(CMD_ADMIN);
COMMAND:gettimer(playerid, params[])
{// [BT]
	new string[128], timer = SetTimer("EmptyFunc", 1000, false);
	format(string, 128, "������� ������������ ��: %.4f%s", 100*float(timer)/2147483647, "%%");
    SendClientMessage(playerid, COLOR_SERVER, string);
    return 1;
}

flags:uptime(CMD_ADMIN);
COMMAND:uptime(playerid, params[])
{// [BT]
	new string[128], tick = GetTickCount()/1000;
	new const days = tick / (24*60*60);
	tick -= days * 24 * 60 * 60;
	new const hours = tick / (60*60);
	tick -= hours * 60 * 60;
	new const minutes = tick / 60;
	tick -= minutes * 60;
	new const seconds = tick % 60;
	format(string, 128, "������ ��������: ����[%d] �����[%02d] �����[%02d] ������[%02d]", days, hours, minutes, seconds);
    SendClientMessage(playerid, COLOR_SERVER, string);
    return 1;
}

flags:server(CMD_ADMIN);
COMMAND:server(playerid, params[])
{// [BT]
	ShowDialog(playerid, DSERV_MAIN);
    return 1;
}

flags:coplist(CMD_MODER);
COMMAND:coplist(playerid, params[])
{// [BT]
	new string[128];
	SendClientMessage( playerid, COLOR_GREEN, "===========[Cop List]===========" );
    foreach(Cop, i)
    {
		format(string, 128, "%s", ReturnPlayerName(i));
		SendClientMessage(playerid, COLOR_WHITE, string);
	}
	return SendClientMessage(playerid, COLOR_GREEN, "==============================");
}

flags:setwl(CMD_IVENTER);
COMMAND:setwl(playerid, params[])
{// [BT]
    new giveplayerid, wantedlvl;
	if(sscanf(params, "ri", giveplayerid, wantedlvl))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /setwl [playerid] [wantedlvl]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
    if(IsForce(PlayerInfo[giveplayerid][pFaction]) && wantedlvl != 0)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������ ������ ���������� �������.");
    if(wantedlvl < 0 || wantedlvl > 8)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������� ������� �� 0 �� 8.");
	new string[128];
    MySetPlayerWantedLevel(giveplayerid, wantedlvl);
	format(string, 128, "%s[%d] ����� ��� %d ������� �������", ReturnPlayerName(playerid), playerid, wantedlvl);
    SendClientMessage(giveplayerid, COLOR_SERVER, string);
    return 1;
}

flags:su(CMD_ADMIN);
COMMAND:su(playerid, params[])
{// [BT]
    new giveplayerid, level, maxlvl, reason[64];
	if(sscanf(params, "riis[64]", giveplayerid, level, maxlvl, reason))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /su [playerid] [level] [maxlvl] [reason]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
    if(IsForce(PlayerInfo[giveplayerid][pFaction]))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������ ������ ���������� �������.");

	new string[128];
    level = GivePlayerWantedLevel(giveplayerid, level, maxlvl, reason);
	format(string, 128, "[BT]: ������ %s[%d] ������ �����: %d, �������: %s", ReturnPlayerName(giveplayerid), giveplayerid, level, reason);
    SendClientMessage(playerid, COLOR_SERVER, string);
    return 1;
}

flags:togooc(CMD_ADMIN);
COMMAND:togooc(playerid, params[])
{
	if(sscanf(params, "b", TOGOOC))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /togooc [0 - off, 1 - on]");
	new string[128];
	format(string, 128, "[AdmCmd]: %s %s[%d] %s ����� ���",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, (TOGOOC == false) ? ("��������") : ("�������"));
	SendClientMessageToAll(COLOR_ADMIN, string);
	return 1;
}

flags:makeleader(CMD_GADMIN);
COMMAND:makeleader(playerid, params[])
{
	new giveplayerid, factionid;
	if(sscanf(params, "r", giveplayerid))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /makeleader [playerid/playername] [factionid]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");

	if(sscanf(params, "{r}i", factionid))
	{// ���� ������������� �� ������ ����� �������
		MakeleaderPlayerid[playerid] = giveplayerid;
		ShowDialog(playerid, DMODE_MAKELEADER);
		return 1;
	}
	if(factionid < 0 || factionid >= sizeof(Faction))
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������� �� ����������.");

	new string[128];
	if(factionid == 0)
	{
		if(!IsPlayerLeader(giveplayerid))
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� �� �������� �������.");

	    factionid = PlayerInfo[giveplayerid][pFaction];
		SetPlayerFaction(giveplayerid, F_NONE);

		format(string, 128, "[AdmCmd]: %s %s[%d] ���� ������� [%s] � ������ %s",
			GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, GetFactionName(factionid), ReturnPlayerName(giveplayerid));
		SendAdminMessage(COLOR_ADMIN, string);
		SendFormatMessage(giveplayerid, COLOR_LIGHTRED, string, "����� %s ������ � ��� ������� ����������� %s", ReturnPlayerName(playerid), GetFactionName(factionid));
	    return 1;
	}

	SetPlayerFaction(giveplayerid, factionid, FactionRankMax[factionid]);

	format(string, 128, "[AdmCmd]: %s %s[%d] ����� ������� [%s] ������ %s",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, GetFactionName(factionid), ReturnPlayerName(giveplayerid));
	SendAdminMessage(COLOR_ADMIN, string);
	SendFormatMessage(giveplayerid, COLOR_LIGHTBLUE, string, "����� %s ����� ��� ������� ����������� %s", ReturnPlayerName(playerid), GetFactionName(factionid));
	return 1;
}

flags:healall(CMD_ADMIN);
COMMAND:healall(playerid, params[])
{
	new Float:Radius;
	if(sscanf(params, "f", Radius))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /healall [radius]");

	new string[128], Float:pos[3];
	GetPlayerPos(playerid, Arr3<pos>);
	foreach(LoginPlayer, i)
	{
	    if(IsPlayerInRangeOfPoint(i, Radius, Arr3<pos>))
	    {
			MySetPlayerHealth(i, 100.0);
			GameTextForPlayer(i, "~g~Healed by ~w~Admin", 1000, 4);
	    }
	}
    format(string, 128, "[AdmCmd]: %s %s[%d] ������� ���� � ������� %.1f �� ����", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, Radius);
    SendAdminMessage(COLOR_ADMIN, string);
	return 1;
}

flags:spawn(CMD_ADMIN);
COMMAND:spawn(playerid, params[])
{// [BT]
	SetPlayerSpawn(playerid);
	SpawnPlayer(playerid);
	/*if(GetPlayerState(playerid) == 2)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
		MySetVehiclePos(vehicleid,-162.2598,1228.6979,19.4003,180.0);
		LinkVehicleToInterior(vehicleid, 0);
		SetVehicleVirtualWorld(vehicleid, 0);
	}
	else
		MySetPlayerPos(playerid, Arr4<SpawnCoord>);
	SetCameraBehindPlayer(playerid);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);*/
	return 1;
}

flags:mark(CMD_MODER);
COMMAND:mark(playerid, params[])
{// [BT]
	if(IsPlayerInAnyVehicle(playerid))
		MyGetVehiclePos(GetPlayerVehicleID(playerid), Arr4<Mark[playerid]>);
	else
		MyGetPlayerPos(playerid, Arr4<Mark[playerid]>);
	MarkINT[playerid] = GetPlayerInterior(playerid);
	MarkVW[playerid] = GetPlayerVirtualWorld(playerid);
    SendClientMessage(playerid, COLOR_WHITE, "����� ������� ���������");
	return 1;
}

flags:gotomark(CMD_MODER);
COMMAND:gotomark(playerid, params[])
{// [BT]
	if(Mark[playerid][0] == 0.0 && Mark[playerid][1] == 0.0)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ��������� �� �����������.");
	new vehicleid = GetPlayerVehicleID(playerid);
	SetPlayerInterior(playerid, MarkINT[playerid]);
	SetPlayerVirtualWorld(playerid, MarkVW[playerid]);
	CreateGotoSmoke(playerid);
	if(vehicleid)
	{
		LinkVehicleToInterior(vehicleid, MarkINT[playerid]);
		SetVehicleVirtualWorld(vehicleid, MarkVW[playerid]);
		MySetVehiclePos(vehicleid, Arr4<Mark[playerid]>);
	}
	else
		MySetPlayerPos(playerid, Arr4<Mark[playerid]>);
    SendClientMessage(playerid, COLOR_WHITE, "�� ����������������� � �������");
	return 1;
}

flags:jet(CMD_ADMIN);
COMMAND:jet(playerid, params[])
{// [BT]
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)
	{
		MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	else
	{
		MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
		SendClientMessage(playerid, COLOR_SERVER, "[BT] ���������: ��� ������ ���� ���� ����������� ��� �� /jet");
	}
    return 1;
}

COMMAND:drop(playerid, params[])
{
	#if defined	_job_part_farmer_included
		if(g_FarmPlayerGrass{playerid})
		{
			FarmDropGrass(playerid);
			CarryDown(playerid);
			PlayerAction(playerid, "������ ��� ����� �� �����.");
			return true;
		}
	#endif
	#if defined	_job_part_delivery_included
		Delivery_Drop(playerid);
	#endif
	return true;
}

COMMAND:eat(playerid, params[])
{
	if(PlayerFoodHands[playerid] == 1)
	{
		RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND);
		MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		new eat = EatPlayer(playerid, 50, "��� ��� � �������");
		if(eat == 1)
		{
			MyApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0);
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� � ����� ��� ���.");
	}
	return true;
}

COMMAND:time(playerid, params[])
{
	new string[128];
	if(ItemStockPlayer(playerid, THING_WATCH))
	{
	    new mtext[16], month, day, hour, minute;
		getdate(_, month, day);
		gettime(hour, minute, _);
		switch(month)
		{
		    case 1:		mtext = "������";
			case 2: 	mtext = "�������";
			case 3: 	mtext = "�����";
			case 4: 	mtext = "������";
			case 5: 	mtext = "���";
			case 6: 	mtext = "����";
			case 7: 	mtext = "����";
			case 8: 	mtext = "�������";
			case 9: 	mtext = "��������";
			case 10: 	mtext = "�������";
			case 11: 	mtext = "������";
			case 12: 	mtext = "�������";
		}
		format(string, 128, "~y~%d %s~n~~g~|~w~%02d:%02d~g~|", day, RusText(mtext, isRus(playerid)), hour, minute);
	}
	if(PlayerInfo[playerid][pAJailTime] > 0)
	{
		new jailtime = PlayerInfo[playerid][pAJailTime] - unixtime();
	    if(jailtime < 0) jailtime = 0;
	    format(string, 128, "%s~n~~r~Jail: %02d:%02d:%02d", string, jailtime / 3600, (jailtime % 3600) / 60, (jailtime % 3600) % 60);
	}
	else if(PlayerInfo[playerid][pJailTime] > 0)
	{
	    new jailtime = PlayerInfo[playerid][pJailTime] - unixtime();
	    if(jailtime < 0) jailtime = 0;
	    format(string, 128, "%s~n~~r~Jail: %02d:%02d:%02d", string, jailtime / 3600, ( jailtime % 3600 ) / 60, ( jailtime % 3600 ) % 60);
	}
	if(strlen(string))
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
			MyApplyAnimation(playerid, "COP_AMBIENT", "coplook_watch", 4.1, 0, 0, 0, 0, 0);
		}
		GameTextForPlayer(playerid, string, 5000, 1);
		return PlayerAction(playerid, "������� ����� �� �����.");
	}
	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� �����.");
}

COMMAND:oldcar(playerid, params[])
{// [BT]
	new string[128];
	format(string, 128, "Your last vehicle: %d", gLastVehicle[playerid]);
	SendClientMessage(playerid, COLOR_SERVER, string);
	return 1;
}

COMMAND:getvw(playerid, params[])
{// [BT]
	new string[128];
	format(string, 128, "Current Virtual World: %d", GetPlayerVirtualWorld(playerid));
    SendClientMessage(playerid, COLOR_SERVER, string);
    return 1;
}

COMMAND:menu(playerid, params[])	return ShowDialog(playerid, DMENU_MAIN);
alias:menu("mn", "mm");
COMMAND:donate(playerid, params[])	return ShowDialog(playerid, DMENU_DONATE);
COMMAND:stats(playerid, params[])	return ShowStats(playerid, playerid);
COMMAND:skill(playerid, params[])	return ShowDialog(playerid, DMENU_LEVELING);

COMMAND:anim(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��� ������� � ������.");
	}
	new listitem;
	if(sscanf(params, "i", listitem))
	{// �������� �� �������
		return ShowDialog(playerid, DMODE_ANIMLIST);
	}
	if((0 <= --listitem < sizeof(AnimList)) == false)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������� ����� ��������.");
	}
	if(!LoopingAnim(playerid,
		AnimList[listitem][ANIM_LIB],
		AnimList[listitem][ANIM_NAME],
		AnimList[listitem][ANIM_DELTA],
		AnimList[listitem][ANIM_LOOP],
		AnimList[listitem][ANIM_LOCKX],
		AnimList[listitem][ANIM_LOCKY],
		AnimList[listitem][ANIM_FREEZE],
		AnimList[listitem][ANIM_TIME],
		AnimList[listitem][ANIM_SYNC]))
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ������ ������ �� �� ������ ������������ ��������.");
	}
	return 1;
}

alias:help("cmds");
COMMAND:help(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREEN, "================[�������� ������� ����]===============");

    SendClientMessage(playerid, COLOR_WHITE, "�����: /ask /mm /stats /licenses /showpass /skill /report /anim");
    SendClientMessage(playerid, COLOR_WHITE, "�����: /home /leaders /admins");
    SendClientMessage(playerid, COLOR_WHITE, "���: /s /c /me /do /try /o /b");
    SendClientMessage(playerid, COLOR_WHITE, "����: /veh /open /lock /unlock /eject");

    //	�������
    if(0 < PlayerInfo[playerid][pFaction] < sizeof(Faction))
    {
    	//	������
    	if(PlayerInfo[playerid][pRank] >= GetRankMax(PlayerInfo[playerid][pFaction]) - 1)
    	{
    		SendClientMessage(playerid, COLOR_WHITE, "�����: /invite /uninvite /giverank /members");
	  		if(IsForce(PlayerInfo[playerid][pFaction]))
	  		{
		  		SendClientMessage(playerid, COLOR_WHITE, "���������: /hq /wanted /gov");
	  		}
	  		else if(IsMafia(PlayerInfo[playerid][pFaction]))
	  		{
		  		SendClientMessage(playerid, COLOR_WHITE, "�����: /allowdealer /deletedealer");
	  		}
    	}
  		
	    if(PlayerInfo[playerid][pFaction] == F_POLICE)
		{
			SendClientMessage(playerid, COLOR_WHITE, "�������: /hq /wanted");
		}
	    else if(PlayerInfo[playerid][pFaction] == F_NEWS)
	    {
		    SendClientMessage(playerid, COLOR_WHITE, "��������: /edit /news /newsinfo /live");
	    }
    }
   
    //	������
    if(Job.GetPlayerJob(playerid) == JOB_MECHANIC)
    {
    	SendClientMessage(playerid, COLOR_WHITE, "�������: /fixveh /refill /tow");
    }

    SendClientMessage(playerid, COLOR_WHITE, "* ����������� �� ������ ��� � ������� h ��� ��������������");
    SendClientMessage(playerid, COLOR_WHITE, "* ���� ��� ����� ������ ������, ����������� /ask");

    SendClientMessage(playerid, COLOR_GREEN, "======================================================");
	return 1;
}

COMMAND:vhelp(playerid, params[])
{
	ClearChatbox(playerid, 10);
	SendClientMessage(playerid, COLOR_GREEN, "_______________[Vehicle Controll Help]_______________");
    SendClientMessage(playerid, COLOR_WHITE, "/vinfo - ������ ���������� �� ����������");
    SendClientMessage(playerid, COLOR_WHITE, "/v - ������� ����� ���������");
    SendClientMessage(playerid, COLOR_WHITE, "/vfind - ����� ��������� �� ��������");
    SendClientMessage(playerid, COLOR_WHITE, "/delcar - ������� ���������");
    SendClientMessage(playerid, COLOR_WHITE, "/setcolor - ������ ���������� ����");
    SendClientMessage(playerid, COLOR_WHITE, "/spawncar - ������������ ���������");
    SendClientMessage(playerid, COLOR_WHITE, "/engine - ������� ���������");
    SendClientMessage(playerid, COLOR_WHITE, "/lights - �������� ����");
	SendClientMessage(playerid, COLOR_GREEN, "_____________________________________________________");
	return 1;
}

COMMAND:ahelp(playerid, params[])
{
	new admlvl = GetPlayerAdmin(playerid);
	if(!admlvl)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��� �������.");
	ClearChatbox(playerid, 10);
	SendClientMessage(playerid, COLOR_GREEN, "_______________[Admin Help]_______________");
	SendClientMessage(playerid, COLOR_WHITE, "������: /aduty /answer");
	if(admlvl >= ADMIN_IVENTER)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "�����: /a /v /setskin /givegun");
    }
	if(admlvl >= ADMIN_MODER)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "�����: /a /spec /check /checklic /checkip /getwage /slap /kick /mute /mutelist /jaillist /warn /ban");
	    SendClientMessage(playerid, COLOR_WHITE, "/setint /delcar /goto /carcheck /checkban /banip /spawncars /freeze /unfreeze /clearchat");
    }
    if(admlvl >= ADMIN_ADMIN)
    {
	    SendClientMessage(playerid, COLOR_WHITE, "�����: /restart /unwarn /unban /unbunip /healall /entercar /server");
	    SendClientMessage(playerid, COLOR_WHITE, "/gethere /sethp /weather /setwl /su /togooc /makeleader /auninvite");
	    SendClientMessage(playerid, COLOR_WHITE, "/setskill");
    }
    if(admlvl >= ADMIN_DEVELOPER)
    {
	    SendClientMessage(playerid, COLOR_WHITE, "������: /anticheat /headshot /makeadmin /givemoney /givecoins /rescue /speclist /prisoners");
	    SendClientMessage(playerid, COLOR_WHITE, "/explode /race /settime /uptime /gettimer /house /unjail /checkphone /setphone");
    }
	new string[128];
	format(string, 128, "_______________________��� ������: [%s]", GetPlayerAdminStatus(playerid));
	SendClientMessage(playerid, COLOR_GREEN, string);
	return 1;
}

//--- Chats
COMMAND:a(playerid, params[])
{
	if(GetPlayerAdmin(playerid) < ADMIN_HELPER)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��� �������.");
	new string[196];
	if(sscanf(params, "s[128]", string))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /a [���������]");
	SendFormatMessageToAll(COLOR_ADMIN, string, "%s %s[%d]: {FFFFFF}%s", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, string);
	return true;
}

COMMAND:gov(playerid, params[])
{
	if(!IsGover(PlayerInfo[playerid][pFaction]))
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��� �������.");
	new string[128], needrank = FactionRankMax[PlayerInfo[playerid][pFaction]]-1; // �����������
	if(PlayerInfo[playerid][pRank] < needrank)
		return SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "��� ������� ������� ���� %s (%d).", GetRankName(PlayerInfo[playerid][pFaction], needrank), needrank);
	if(PlayerInfo[playerid][pMuteTime] > 0)
		return SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "�� �������� � ����, ��������: %d ���.", PlayerInfo[playerid][pMuteTime]);
	if(sscanf(params, "s[128]", string))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /gov [���������]");
	SendFormatMessageToAll(COLOR_DBLUE, string, "[��������������]: %s %s[%d]: {FFFFFF}%s", GetPlayerRank(playerid), ReturnPlayerName(playerid), playerid, string);
	return 1;
}

COMMAND:d(playerid, params[])
{
    if(IsGover(PlayerInfo[playerid][pFaction]) == 0){
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �������� � ���.���������.");
    }
    if(PlayerInfo[playerid][pRank] < 4){
    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������� � 4 �����.");
    }
	/*if(PlayerInfo[playerid][pJailTime] > 0){
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ��� ���������� � ������.");
	}*/
    new string[196];
	if(sscanf(params, "s[128]", string))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /d [���������]");
	if(PlayerInfo[playerid][pMuteTime] > 0)
	    return SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "�� �������� � ����, ��������: %d ���.", PlayerInfo[playerid][pMuteTime]);
	new color = 0xFF8282AA;
	format(string, sizeof(string), "[D][%s] %s %s[%d]: %s", GetFactionName(PlayerInfo[playerid][pFaction]), GetPlayerRank(playerid), ReturnPlayerName(playerid), playerid, string);

	//	�������
	new cens_string[256];
	strput(cens_string, string);
	if(RemoveBadWords(cens_string) >= 5)
	{
		new stmp[128];
		PlayerInfo[playerid][pMuteTime] = 5 * 60;
	    SendFormatMessageToAll(COLOR_LIGHTRED, stmp, "[AdmWrn]: %s[%d] ������� �������� �� 5 ����� �� ������ ����", ReturnPlayerName(playerid), playerid);
	}
	foreach(LoginPlayer, i)
	{
		if(IsGover(PlayerInfo[i][pFaction]))	{
        	SendClientMessage(i, color, PlayerInfo[i][pCensored] ? cens_string : string);
        }
	}
	return true;
}
COMMAND:departments(playerid, params[]){	return callcmd::d(playerid, params);	}

COMMAND:rb(playerid, params[])
{
	new string[256];
	format(string, sizeof(string), "(( %s ))", params);
	callcmd::r(playerid, string);
	return 1;
}

COMMAND:r(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] > 0){
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ��� ���������� � ������.");
	}
    if(Job.GetPlayerJob(playerid) == JOB_NONE && IsGover(PlayerInfo[playerid][pFaction]) == 0){
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ����� �� ��������� � �� �������� � ���.���������.");
    }
    new string[196];
	if(sscanf(params, "s[128]", string))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /r [���������]");
	if(PlayerInfo[playerid][pMuteTime] > 0)
	{
	    SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "�� �������� � ����, ��������: %d ���.", PlayerInfo[playerid][pMuteTime]);
	    return true;
	}
	new color = COLOR_LIGHTBLUE;
	if(IsGover(PlayerInfo[playerid][pFaction]))
	{
	    color = COLOR_BLUE;
		format(string, sizeof(string), "[R] %s %s[%d]: %s", GetPlayerRank(playerid), ReturnPlayerName(playerid), playerid, string);
	}
	else {
		format(string, sizeof(string), "[R] %s[%d]: %s", ReturnPlayerName(playerid), playerid, string);
	}
	//	�������
	new cens_string[196];
	strput(cens_string, string);
	if(RemoveBadWords(cens_string) >= 5)
	{
		new stmp[128];
		PlayerInfo[playerid][pMuteTime] = 5 * 60;
	    SendFormatMessageToAll(COLOR_LIGHTRED, stmp, "[AdmWrn]: %s[%d] ������� �������� �� 5 ����� �� ������ ����", ReturnPlayerName(playerid), playerid);
	}
	new job = Job.GetPlayerJob(playerid);
	foreach(LoginPlayer, i)
	{
		if(IsGover(PlayerInfo[playerid][pFaction]))
		{
			if(PlayerInfo[playerid][pFaction] != PlayerInfo[i][pFaction])	continue;
		}
        else
        {
        	if(job != Job.GetPlayerJob(i))			continue;
        }
        SendClientMessage(i, color, PlayerInfo[i][pCensored] ? cens_string : string);
	}
	return true;
}

COMMAND:fb(playerid, params[])
{
	new string[256];
	format(string, sizeof(string), "(( %s ))", params);
	callcmd::f(playerid, string);
	return 1;
}

COMMAND:f(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime] > 0){
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ��� ���������� � ������.");
	}
    if(PlayerInfo[playerid][pFaction] <= 0){
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �������� �� � ����� �����������.");
    }
    if(IsGover(PlayerInfo[playerid][pFaction]))
	{
	    callcmd::r(playerid, params);
    	return 1;
    }
	new string[196];
	if(sscanf(params, "s[128]", string))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /f [���������]");
	if(PlayerInfo[playerid][pMuteTime] > 0)
	{
	    SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "�� �������� � ����, ��������: %d ���.", PlayerInfo[playerid][pMuteTime]);
	    return true;
	}
	new color = COLOR_WHITE;
	if(PlayerInfo[playerid][pFaction] == F_POLICE)
	{
	    color = COLOR_BLUE;
		format(string, sizeof(string), "[R] %s %s[%d]: %s", GetPlayerRank(playerid), ReturnPlayerName(playerid), playerid, string);
	}
	else if(IsGang(PlayerInfo[playerid][pFaction]))
	{
		color = GetGangColor(PlayerInfo[playerid][pFaction]);
		// GodFather format: "** Outsider %s: %s. ))  **"
		format(string, sizeof(string), "# | %s %s[%d]: %s", GetPlayerRank(playerid), ReturnPlayerName(playerid), playerid, string);
	}
	else
	{
	    color = COLOR_LIGHTPURPLE; // COLOR_LIGHTBLUE
		format(string, sizeof(string), "# | %s %s[%d]: %s", GetPlayerRank(playerid), ReturnPlayerName(playerid), playerid, string);
	}
	//	�������
	new cens_string[256];
	strput(cens_string, string);
	if(RemoveBadWords(cens_string) >= 5)
	{
		new stmp[128];
		PlayerInfo[playerid][pMuteTime] = 5 * 60;
	    SendFormatMessageToAll(COLOR_LIGHTRED, stmp, "[AdmWrn]: %s[%d] ������� �������� �� 5 ����� �� ������ ����", ReturnPlayerName(playerid), playerid);
	}
	foreach(LoginPlayer, i)
	{
        if(PlayerInfo[playerid][pFaction] == PlayerInfo[i][pFaction])
			SendClientMessage(i, color, PlayerInfo[i][pCensored] ? cens_string : string);
	}
	return true;
}

COMMAND:ad(playerid, params[])
{
	if(PlayerInfo[playerid][pPhoneNumber] == 0)	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ����� �������, ����� ��������� ����������.");
	}
    new string[196];
	if(sscanf(params, "s[128]", string))
	    return SendFormatMessage(playerid, COLOR_WHITE, string, "�����������: /ad [����� ����������] (����: %d$)", SENDAD_PRICE);

	if(gAdvertCount >= MAX_ADVERT_COUNT)	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� �� ���������� ������, ���������� �����.");
	}
	new time = GetPVarInt(playerid, "SendADTime") + 60 - gettime();
	if(time > 0)    {
	    format(string, sizeof(string), "�� ��������� �������� ����������: ~y~%02d ��� %02d ���", time/60, time%60);
		return ShowPlayerHint(playerid, string);
	}
	if(strlen(string) < 10)	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����������� ����� ���������� - 10 ��������.");
	}
	if(strlen(string) > 100)	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������ ����� ���������� - 100 ��������.");
	}
	if(MyGetPlayerMoney(playerid) < SENDAD_PRICE)	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ �����.");
	}
	new slot = -1;
	for(new i; i < MAX_ADVERT_COUNT; i++)
	{
		if(gAdvert[i][adBusy] == false)
		{
			slot = i;
			break;
		}
	}
	if(slot == -1)	
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� �� ���������� ������, ���������� �����.");
	}
	SetPVarString(playerid, "SendADText", params);
	format(string, sizeof(string), "{FFFFFF}����� ����������:\n{44B2FF}%s\n\n{FFFFFF}���������?", params);
	MyShowPlayerDialog(playerid, DMODE_SENDAD, DIALOG_STYLE_MSGBOX, "{44B2FF}�������� ����������", string, "��", "���");
	return true;
}

//--- Reporters
COMMAND:edit(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] != F_NEWS)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ��������.");
	}
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetPlayerInterior(playerid) != 18 && (vehicleid > 0 && CarInfo[vehicleid][cType] == C_TYPE_FACTION && CarInfo[vehicleid][cOwnerID] == F_NEWS) == false)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���������� � ������ ��� � �������.");
	}
	ShowDialog(playerid, DMODE_ADLIST);
	return true;
}

stock getMaxNews(playerid)
{
	switch(PlayerInfo[playerid][pRank])
	{
	    case 1: return 0;   	// ��������
	    case 2: return 150;   	// ��������
	    case 3: return 200;   	// �������
	    case 4: return 250;   	// �� ��������
	    case 5: return 300;   	// ��������
	    case 6: return 400;     // ��� ���������
	    case 7: return 500;     // ��������
	}
	return 0;
}

COMMAND:news(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] != F_NEWS)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ��������.");
    new string[196];
	if(PlayerInfo[playerid][pRank] < 2)
		return SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "��� ������� ������� ���� %s (%d).", GetRankName(F_NEWS, 2), 2);
	new difunix = gettime() - PlayerInfo[playerid][pNewsUnix];
	if(difunix < 3600 && PlayerInfo[playerid][pNewsCount] >= getMaxNews(playerid))
	{// �������� �������� ����������
		return SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "�� ������ ���������� ����������: %d ���. (����� ����������: %d/���).", (3600-difunix)/60 + 1, getMaxNews(playerid));
	}
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetPlayerInterior(playerid) != 18 && (vehicleid > 0 && CarInfo[vehicleid][cType] == C_TYPE_FACTION && CarInfo[vehicleid][cOwnerID] == F_NEWS) == false)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���������� � ������ ��� � �������.");
	if(sscanf(params, "s[128]", string))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /news [���������]");
	SendFormatMessageToAll(COLOR_NEWS, string, "[������ ����] %s: %s", ReturnPlayerName(playerid), string);
	Job.GivePlayerWage(playerid, 2.5);

	if(difunix > 3600)
	{
	    PlayerInfo[playerid][pNewsUnix] = gettime();
	    PlayerInfo[playerid][pNewsCount] = 0;
	}
	PlayerInfo[playerid][pNewsCount]++;

	switch(getMaxNews(playerid)-PlayerInfo[playerid][pNewsCount])
	{
	    case 50,40,30,20,10,5,4,3,2,1:
		{
		    format(string, sizeof(string), "�������� ����������: ~y~%d", getMaxNews(playerid)-PlayerInfo[playerid][pNewsCount]);
			ShowPlayerHint(playerid, string);
		}
		case 0:
		{
		    format(string, sizeof(string), "�� ��������� �����! ~n~�� ����. ����������: ~y~%d ���", (3600-difunix)/60 + 1);
			ShowPlayerHint(playerid, string);
		}
	}
	return true;
}

COMMAND:newsinfo(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] != F_NEWS)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ��������.");
    new string[196];
	if(PlayerInfo[playerid][pRank] < 2)
		return SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "��� ������� ������� ���� %s (%d).", GetRankName(F_NEWS, 2), 2);
	new difunix = gettime() - PlayerInfo[playerid][pNewsUnix];
	if(difunix > 3600)
	{
	    format(string, sizeof(string), "����� ����������: ~y~%d~w~/~y~%d~n~~w~~g~����� ������ ����������", getMaxNews(playerid)-PlayerInfo[playerid][pNewsCount], getMaxNews(playerid));
		ShowPlayerHint(playerid, string);
	}
	else
	{
	    format(string, sizeof(string), "����� ����������: ~y~%d~w~/~y~%d~n~~w~�� ����� ����������: ~y~%d ���", getMaxNews(playerid)-PlayerInfo[playerid][pNewsCount], getMaxNews(playerid), (3600-difunix)/60 + 1);
		ShowPlayerHint(playerid, string);
	}
	return true;
}

COMMAND:live(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] != F_NEWS)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ��������.");
	new string[128];
	if(PlayerInfo[playerid][pRank] < 3)
		return SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "��� ������� ������� ���� %s (%d).", GetRankName(F_NEWS, 3), 3);
		
    if(TalkingLive[playerid] != INVALID_PLAYER_ID)
    {
        SendClientMessage(playerid, COLOR_LIGHTBLUE, "�������� ���������");
        SendClientMessage(TalkingLive[playerid], COLOR_LIGHTBLUE, "�������� ���������");
        TogglePlayerControllable(playerid, true);
        TogglePlayerControllable(TalkingLive[playerid], true);
        TalkingLive[TalkingLive[playerid]] = INVALID_PLAYER_ID;
        TalkingLive[playerid] = INVALID_PLAYER_ID;
        return 1;
    }
    new vehicleid = GetPlayerVehicleID(playerid);
	if(GetPlayerInterior(playerid) != 18 && (vehicleid > 0 && CarInfo[vehicleid][cType] == C_TYPE_FACTION && CarInfo[vehicleid][cOwnerID] == F_NEWS) == false)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���������� � ������ ��� � �������.");
	}
   	new giveplayerid;
	if(sscanf(params, "d", giveplayerid)){
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /live [playerid/playername]");
	}
	if(giveplayerid == playerid) {
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ����� �������� � ����� �����.");
	}
	if(IsPlayerNearPlayer(playerid, giveplayerid, 5.0) == 0){
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��������� ����� � ����.");
	}
	if(TalkingLive[giveplayerid] != INVALID_PLAYER_ID){
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ��� ���� ��������.");
	}
	if(AskPlayer(playerid, giveplayerid, ASK_INTERVIEW))
	{
		SendFormatMessage(playerid, COLOR_WHITE, string, "�� ���������� %s'� ���� ��� �������� � ������ �����", ReturnPlayerName(giveplayerid));
		SendFormatMessage(giveplayerid, COLOR_WHITE, string, "%s ����� ����� � ��� �������� � ������ ����� "ASK_CONFIRM_INFO, ReturnPlayerName(playerid));
	}
	else{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ������ ���� �� �������� ������, ���������� �����.");
	}
	return true;
}

//---
COMMAND:admins(playerid, params[])	return ShowDialog(playerid, DMODE_ADMINS);

COMMAND:gps(playerid, params[])
{
	if(PlayerInfo[playerid][pJailTime])
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ������������ �� ����� ����������.");
	ShowDialog(playerid, DMODE_GPS);
	return true;
}

COMMAND:id(playerid, params[])
{
    new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /id [playername]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");

	new string[128];
	new time = GetPlayerAFKTime(playerid);
	format(string, sizeof(string), "* %s [id: %d]", ReturnPlayerName(giveplayerid), giveplayerid);
	if(PlayerInfo[giveplayerid][pPhoneNumber] > 0)	format(string, sizeof(string), "%s [phone: %d]", string, PlayerInfo[giveplayerid][pPhoneNumber]);
	if(IsPlayerAFK(giveplayerid))					format(string, sizeof(string), "%s (AFK %02d:%02d)", string, time/60, time%60);
	SendClientMessage(playerid, COLOR_SERVER, string);
	return 1;
}

//--- Actions
COMMAND:action(playerid, params[])
{
	extract params -> new player:targetid; else
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /action [playerid/playername]");

	if(22 <= GetPlayerWeapon(playerid) <= 33)	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� �������������� ������� ������ �� ���.");
	}
	if(IsPlayerNearPlayer(playerid, targetid, 4.0) == 0)
	{	// ����� �����, ���� ������
	    if(random(2) == 0) 	MyApplyAnimation(playerid, "PED", "endchat_03", 4.1, 0, 0, 0, 0, 0, 1);
	    else           		MyApplyAnimation(playerid, "RIOT", "RIOT_ANGRY", 4.1, 0, 1, 1, 1, 1, 1);
	    return true;
	}
	if(PlayerCuffedTime[targetid]){
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ����������������� � ���������� �������.");
	}
	if(PlayerCuffedTime[playerid]){
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��������.");
	}
    gTargetid[playerid] = targetid;
    ShowDialog(playerid, DMODE_REACTION);
    return true;
}

COMMAND:hi(playerid, params[])
{
	extract params -> new player:giveplayerid; else
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /hi [playerid/playername]");

	if(playerid == giveplayerid){
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������� � �����.");
	}
	if(GetPlayerState(playerid) != 1){
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ������������� ������ ���� �� �����.");
	}
    new const Float:max_dist = 35.0;
	new Float:tpos[3], Float:pos[3];
	GetPlayerPos(giveplayerid, Arr3<tpos>);
	GetPlayerPos(playerid, Arr3<pos>);
	new Float:dist = GetDistanceFromPointToPoint(Arr3<tpos>, Arr3<pos>);
    new string[128];
	if(GetPlayerAsk(playerid) == ASK_HI && GetPlayerAskOfferid(playerid) == giveplayerid)
    {	//  ������������� ��������
    	if(dist > max_dist)
    		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ������� ������ �� ���.");
    	if(GetPlayerState(giveplayerid) != 1)
    		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ������ �� �����.");

        if(dist <= 4.0)
        {
        	//new Float:pos[3];
			new Float:A = 180.0 - atan2(pos[0] - tpos[0], pos[1] - tpos[1]);
		    SetPlayerFacingAngle(playerid, A);
			tpos[0] = pos[0] + (1.0 * floatsin(-A, degrees));
			tpos[1] = pos[1] + (1.0 * floatcos(-A, degrees));
			MySetPlayerPos(giveplayerid, Arr3<tpos>, A + 180.0);
			new animname[20];
			switch(random(8))
			{
				case 0: animname = "hndshkaa";
				case 1: animname = "hndshkba";
				case 2: animname = "hndshkca";
				case 3: animname = "hndshkcb";
				case 4: animname = "hndshkda";
				case 5: animname = "hndshkea";
				case 6: animname = "hndshkfa";
				case 7: animname = "hndshkfa_swt";
			}
			MyApplyAnimation(playerid, "GANGS", animname, 4.0, 0, 0, 0, 0, 0);
			MyApplyAnimation(giveplayerid, "GANGS", animname, 4.0, 0, 0, 0, 0, 0);
			StopAsking(playerid);
        }
        else if(4.0 < dist < 35.0)
        {
        	if(random(2) == 0) 	MyApplyAnimation(playerid, "PED", "endchat_03", 4.1, 0, 0, 0, 0, 0, 1);
			else
			{
				MyApplyAnimation(playerid, "RIOT", "RIOT_ANGRY", 4.1, 0, 1, 1, 1, 1, 1);
				SetTimerEx("ClearFreezeAnim", 5000, false, "i", playerid);
        	}
        }
		SendFormatMessage(playerid, COLOR_GREEN, string, "�� ����������� ������������� � %s", ReturnPlayerName(giveplayerid));
		SendFormatMessage(giveplayerid, COLOR_GREEN, string, "%s ���������� ������������� � ����", ReturnPlayerName(playerid));
	}
	else
	{
		if(dist > 5.0)
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ������� ������ �� ���.");

		if(AskPlayer(playerid, giveplayerid, ASK_HI))
		{
			SendFormatMessage(giveplayerid, COLOR_WHITE, string, "%s ����� ������������� � ���� "ASK_CONFIRM_INFO, ReturnPlayerName(playerid));
			SendFormatMessage(playerid, COLOR_WHITE, string, "�� ���������� %s ������������� � ����", ReturnPlayerName(giveplayerid));
		}
		else{
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ������ ���� �� �������� ������, ���������� �����.");
		}
	}
	return true;
}

COMMAND:showpass(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "r", giveplayerid)){
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /showpass [playerid/playername]");
	}
	if(!IsPlayerLogged(giveplayerid)){
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
    }
    if(GetDistanceBetweenPlayers(playerid, giveplayerid) > 5.0){
    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ������� ������ �� ���.");
    }
    if(playerid == giveplayerid)
    {
    	ShowPass(playerid, giveplayerid);
    }
    else
    {
    	if(AskPlayer(playerid, giveplayerid, ASK_SHOWPASS))
		{
			new string[128];
			SendFormatMessage(giveplayerid, COLOR_WHITE, string, "%s ����� �������� ��� ���� ��������� "ASK_CONFIRM_INFO,  ReturnPlayerName(playerid));
			SendFormatMessage(playerid, COLOR_WHITE, string, "�� ���������� %s ��������� �� ���� ���������", ReturnPlayerName(giveplayerid));
		}
		else SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ������ ���� �� �������� ������, ���������� �����.");
    }
	return true;
}

COMMAND:pay(playerid, params[])
{
	if(PlayerInfo[playerid][pLevel] < 2)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������� �������� �� 2 ������.");
	}
    extract params -> new player:giveplayerid, money;    else
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /pay [playerid/playername] [������]");
	if(playerid == giveplayerid)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ �������� ����� ������ ����.");
	}
    if(IsPlayerLogged(giveplayerid) == 0)
    {
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
    }
	if(IsPlayerNearPlayer(playerid, giveplayerid, 4.0) == 0)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ������� ������ �� ���.");
	}
	if(money <= 0)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ �������� ������ ���� ��� ����.");
	}
	if(MyGetPlayerMoney(playerid) < money)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������� �����.");
	}
	if(money > 1000 && PlayerInfo[playerid][pLevel] < 4)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ���������� �� ��� ����� $1.000.");
	}
	else if(money > 10000)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ���������� �� ��� ����� $10.000.");
	}
	if(AskPlayer(playerid, giveplayerid, ASK_GIVE_MONEY, 30, money))
	{
		new string[128];
		SendFormatMessage(giveplayerid, COLOR_WHITE, string, "%s ����� �������� ��� %d$ "ASK_CONFIRM_INFO, ReturnPlayerName(playerid), money);
		SendFormatMessage(playerid, COLOR_WHITE, string, "�� ���������� %s ����� �� ��� %d$", ReturnPlayerName(giveplayerid), money);
		//AskAmount[giveplayerid] = money;
	}
	else
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ������ ���� �� �������� ������, ���������� �����.");
	}
	return true;
}

COMMAND:dance(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT){
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������� ������ ������.");
	}
	new dance;
	if(sscanf(params, "d", dance)){
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /dance [1-4]");
	}
	if(dance < 1 || dance > 4){
		return SendClientMessage( playerid, COLOR_WHITE, "�����������: /dance [1-4]");
	}
	switch(dance)
	{
	    case 1: MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
		case 2: MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
		case 3: MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
		case 4: MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
		/*case 5:
		{
			Dancing[ playerid ] = 5;
			MyApplyAnimation( playerid, "DANCING", "DAN_Loop_A", 4.0, 1, 0, 0, 0, 0 );
		}
		case 6:
		{
			Dancing[ playerid ] = 6;
			MyApplyAnimation( playerid, "DANCING", "dnce_M_b", 4.0, 1, 0, 0, 0, 0 );
		}*/
	}
	return true;
}

//--- Vehicle
COMMAND:refill(playerid, params[])
{
	if(Job.GetPlayerNowWork(playerid) != JOB_MECHANIC)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ��������� ��������� ��� �� ����� �� ���������.");
	}
	new vehicleid = GetNearVehicles(playerid, 2);
    if(!vehicleid) return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���������� ��� �� ����� ������.");
	SetPVarInt(playerid, "Mechanic:Refill:VehicleID", vehicleid);
	return ShowDialog(playerid, DMODE_REFILL);
}

COMMAND:fixveh(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
	    if(GetPlayerAdmin(playerid) < ADMIN_ADMIN)
    	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������� �������� ������ ����� ������.");
		new const vehicleid = GetPlayerVehicleID(playerid);
		if(MyGetVehicleHealth(vehicleid) < 250)
		{
		    new Float:A;
			GetVehicleZAngle(vehicleid, A);
			SetVehicleZAngle(vehicleid, A);
		}
		MyRepairVehicle(vehicleid);
		return SendClientMessage(playerid, COLOR_WHITE, "������ ��������� ���������������");
    }
    else
    {
    	if(Job.GetPlayerNowWork(playerid) != JOB_MECHANIC)
		{
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ��������� ��������� ��� �� ����� �� ���������.");
		}

    	new v = GetNearVehicles(playerid, 2);
	    if(!v) return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���������� ��� �� ����� ������.");

	    new price;
		if(sscanf(params, "d", price))
		{
			return SendClientMessage(playerid, COLOR_WHITE, "�����������: /fixveh [���������]");
		}

		if(!(10 <= price <= 200))
		{
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��������� ������ ���� �� $10 �� $200.");
		}

	    new dif = 20,
			Float:carX, Float:carY, Float:carZ,
	        Float:carA, Float:plX, Float:plY, Float:plZ;

		GetVehiclePos(v, carX, carY, carZ);
		GetVehicleZAngle(v, carA);
		GetPlayerPos(playerid, plX, plY, plZ);
		new A = floatround(atan2(carX - plX, carY - plY) + carA);
		if(A > 360)	A -= 360;
		if(180 - dif < A < 180 + dif)
	    {	// �����
			if(!GetVehicleBonnet(v))
			{
				return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ���� ������ ������.");
			}
		    new Float:Health;
		    GetVehicleHealth(v, Health);
		    if(Health >= 999.0)
		    {
				return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������ ���������� ��������.");
		    }
		    if(Health < 400.0)
		    {
				return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������ ����� ��������������� ������ � �������.");
		    }
		    new giveplayerid = VehInfo[v][vDriver];
		    if(giveplayerid < 0)
		    {
		    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������� � ������ ������ ������ ��������.");
		    }
		    if(AskPlayer(playerid, giveplayerid, ASK_REPAIR, 30, price))
		    {
		    	new string[128];
		    	//AskAmount[giveplayerid] = price;
				SendFormatMessage(giveplayerid, COLOR_WHITE, string, "%s ����� ��������������� ��� ���� �� $%d "ASK_CONFIRM_INFO, ReturnPlayerName(playerid), price);
				SendFormatMessage(playerid, COLOR_WHITE, string, "�� ���������� %s ��������������� ��� ���� �� $%d", ReturnPlayerName(giveplayerid), price);
			}
			else
			{
				return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ������ ���� �� �������� ������, ���������� �����.");
			}
	    }
    }
	return true;
}

COMMAND:open(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���������� ������������ ��� ������� �� ������.");
	new vehicle = GetNearVehicles(playerid);
	if(!vehicle)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���������� ��� �� ����� ������.");
	}
	return PlayerOpenVehicle(playerid, vehicle);
}

flags:alock(CMD_DEVELOPER);
COMMAND:alock(playerid, params[])
{
	new vehicle = GetNearVehicles(playerid);
    if(vehicle == 0)
	{
    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���������� ��� �� ����� ������.");
    }
    LockPlayerVehicle(playerid, vehicle, true);
	return true;
}

COMMAND:lock(playerid, params[])
{
	new vehicle = GetNearVehicles(playerid);
    if(vehicle == 0)
	{
    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���������� ��� �� ����� ������.");
    }
    LockPlayerVehicle(playerid, vehicle);
	return true;
}

COMMAND:unlock(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetPlayerState(playerid) != 2 || !IsVehicleWithEngine(vehicleid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������� ������ �� ����� ����������.");
	if(VehInfo[vehicleid][vLocked] == 0)
	{
	    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ��� � ��� ��������������.");
	    return 1;
	}
    if(IsAvailableVehicle(vehicleid, playerid) >= VEH_AVAILABLE_CONTROL)
    {
	    new giveplayerid;
		if(sscanf(params, "r", giveplayerid))
		{// ��� ��������
            VehInfo[vehicleid][vLocked] = 0;
			GameTextForPlayer(playerid, "~w~Vehicle ~g~Unlocked", 3000, 3);
			UpdateVehicleParamsEx(vehicleid);
		}
		else
		{// � ���������
			if(!IsPlayerNearPlayer(playerid, giveplayerid, 10.0))
				return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ������� ������ �� ���.");
		    new string[128];
		    format(string, 128, "~w~Vehicle ~g~Unlocked~n~~w~%s", ReturnPlayerName(giveplayerid));
			GameTextForPlayer(playerid, string, 3000, 3);

			GameTextForPlayer(giveplayerid, "~w~Vehicle ~g~Unlocked", 3000, 3);
            SetVehicleParamsForPlayer(vehicleid, giveplayerid, 0, false);
		}
	}
	else SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������� ��� ������.");
	return 1;
}

COMMAND:eject(playerid, params[])
{
    if(GetPlayerState(playerid) != 2)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ������ �� �����, ����� ������������ ��� �������.");
	if(GetPlayerInterior(playerid) > 0)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ ������������ ��� ������� � ���������.");
    new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /eject [playerid/playername]");
	new string[128];
	new vehicleid = GetPlayerVehicleID(playerid);

	#if defined	_job_job_busdriver_included
		if(BusDriverStatus[playerid] > 0 && BusDriverVeh[playerid] == vehicleid)
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�������� �������� �� ����� ������� �������� ���������.");
	#endif

	if(vehicleid == GetPlayerVehicleID(giveplayerid))
	{
		switch(VehInfo[vehicleid][vModelType])
		{
			case MTYPE_MOTO: 	string = "��������";
			case MTYPE_TRUCK: 	string = "��������";
			case MTYPE_TRAIN: 	string = "�����";
			case MTYPE_BOAT: 	string = "�����";
			case MTYPE_HELIC: 	string = "��������";
			case MTYPE_PLANE: 	string = "�������";
			default: 			string = "����������";
		}
		format(string, 128, "������ %s �������� %s.", ReturnPlayerName(giveplayerid), string);
	    PlayerAction(playerid, string);
	    BlockVehicleEffect(vehicleid, 4);
	    RemovePlayerFromVehicle(giveplayerid);
	}
	else if(vehicleid == GetPlayerSurfingVehicleID(giveplayerid))
	{
		switch(VehInfo[vehicleid][vModelType])
		{
			case MTYPE_MOTO: 	string = "���������";
			case MTYPE_TRUCK: 	string = "���������";
			case MTYPE_TRAIN: 	string = "������";
			case MTYPE_BOAT: 	string = "�����";
			case MTYPE_HELIC: 	string = "���������";
			case MTYPE_PLANE: 	string = "��������";
			default: 			string = "����������";
		}
		format(string, 128, "��������� %s � %s.", ReturnPlayerName(giveplayerid), string);
	    PlayerAction(playerid, string);
		new Float:surfX, Float:surfY, Float:surfZ;
	    GetVehiclePos(vehicleid, surfX, surfY, surfZ);
	    MySetPlayerPos(giveplayerid, surfX + 2.0, surfY + 2.0, surfZ);
	}
	else return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� � (��) ����������.");
	return 1;
}

COMMAND:engine(playerid, params[])
{
	if(InRace[playerid]) return 1;
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetPlayerState(playerid) != 2 || vehicleid <= 0 || IsVehicleWithEngine(vehicleid) == false)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ������ �� �����, ����� ������������ ��� �������.");
	if(GetVehicleEngine(vehicleid) == false)
	{	// �������
	    if(IsAvailableVehicle(vehicleid, playerid) >= VEH_AVAILABLE_CONTROL)
	    {
		    new time = 400 + (random(4) + 1) * 100;
	        engine_timer[playerid] = SetTimerEx("StartEngine", time, false, "dd", vehicleid, true);
			GameTextForPlayer(playerid, "~w~Starting engine...", 1000, 4);
		}
		else
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ������ ��������� �� ����� ����.");
			if(Job.GetPlayerJob(playerid) == JOB_THEFT)
				ShowPlayerHint(playerid, "~w~��� ������ ����� ��������� ������� ~y~���");
		}
	}
	else
	{	// ������
		StartEngine(vehicleid, false);
		PlayerAction(playerid, "������ ���������.");
	}
	return true;
}

COMMAND:lights(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetPlayerState(playerid) != 2 || !IsVehicleWithEngine(vehicleid))
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ������ �� �����, ����� ������������ ��� �������.");
	VehInfo[vehicleid][vLights] = !VehInfo[vehicleid][vLights];
	IFace.Veh_Update(playerid, 0);
	return UpdateVehicleParamsEx(vehicleid);
}

COMMAND:tow(playerid, params[])
{
	if(GetPlayerState(playerid) != 2)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ������ �� �����, ����� ������������ ��� �������.");
	new vehicleid = GetPlayerVehicleID(playerid);
	new model = GetVehicleModel(vehicleid);
	if(model != 525 && model != 531 && model != 583)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ��������� �� ����� ����������� � ����������.");
	if(IsTrailerAttachedToVehicle(vehicleid) > 0)
	    return true;
    new Float:pos[ 3 ], Float:dist, Float:mindist = 0.0, veh = 0;
    foreach(Vehicle, v)
	{
	    if(!IsVehicleStreamedIn( v, playerid ) || v == vehicleid) continue;
		GetVehiclePos(v, Arr3<pos>);
		dist = GetDistanceFromMeToPoint(playerid, Arr3<pos>);
		if(dist <= 8.0 && (mindist == 0.0 || dist < mindist))
		{
			mindist = dist;
			veh = v;
		}
    }
	if(veh == 0)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���������� ��� �� ����� ������, ������� ����� ���������.");
	if(VehInfo[veh][vModelType] != MTYPE_NONE && VehInfo[veh][vModelType] != MTYPE_NODOOR && VehInfo[veh][vModelType] != MTYPE_TRUCK)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ��� ���������� ������ ����������� � �������.");
	AttachTrailerToVehicle(veh, vehicleid);
	return 1;
}

COMMAND:detach(playerid, params[]) return callcmd::untow(playerid, params);
COMMAND:untow(playerid, params[])
{
	if(GetPlayerState(playerid) != 2)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ������ �� �����, ����� ������������ ��� �������.");
	new vehicleid = GetPlayerVehicleID(playerid);
	if(!IsTrailerAttachedToVehicle(vehicleid))
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ���� ������ ��� �������� �������.");
	return DetachTrailerFromVehicle(vehicleid);
}

COMMAND:vinfo(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid) == 0)
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���� � ����������.");

	new string[128], lstring[1024];
	new vehicleid = GetPlayerVehicleID(playerid);
	new vehmodel = GetVehicleModel(vehicleid);
	//
	format(string, 128, "Model: %s(id %d)\n", ReturnVehicleName(vehicleid), vehmodel); strcat(lstring, string);
	format(string, 128, "Num: %d (id %d)\n", vehicleid, CarInfo[vehicleid][cID]); strcat(lstring, string);
	format(string, 128, "Type: %d (owner: %d)\n", CarInfo[vehicleid][cType], CarInfo[vehicleid][cOwnerID]); strcat(lstring, string);
	format(string, 128, "Colors: %d and %d\n", CarInfo[vehicleid][cColor1], CarInfo[vehicleid][cColor2]); strcat(lstring, string);
	format(string, 128, "Fuel: %0.2f%%\n", VehInfo[vehicleid][vFuel]); strcat(lstring, string);
	format(string, 128, "Mileage: %0.1f km\n", CarInfo[vehicleid][cMileage]); strcat(lstring, string);
	format(string, 128, "Inside: %d players\n",VehInfo[vehicleid][vPlayers]); strcat(lstring, string);
	strcat(lstring, "\n");
	new anothers;
	//
	strcat(lstring, "Driver: ");
	new driver = VehInfo[vehicleid][vDriver];
	if(driver >= 0) { anothers++; format(string, 128, "%s[%d]\n",ReturnPlayerName(driver),driver); strcat(lstring, string); } else strcat(lstring, "None\n");
	//
	strcat(lstring, "CoDriver: ");
	new codriver = VehInfo[vehicleid][vCoDriver];
	if(codriver >= 0) { anothers++; format(string, 128, "%s[%d]\n",ReturnPlayerName(codriver),codriver); strcat(lstring, string); } else strcat(lstring, "None\n");
	//
	strcat(lstring, "LeftSeat: ");
	new leftseat = VehInfo[vehicleid][vLeftSeat];
	if(leftseat >= 0) { anothers++; format(string, 128, "%s[%d]\n",ReturnPlayerName(leftseat),leftseat); strcat(lstring, string); } else strcat(lstring, "None\n");
	//
	strcat(lstring, "RightSeat: ");
	new rightseat = VehInfo[vehicleid][vRightSeat];
	if(rightseat >= 0) { anothers++; format(string, 128, "%s[%d]\n",ReturnPlayerName(rightseat),rightseat); strcat(lstring, string); } else strcat(lstring, "None\n");
	//
	strcat(lstring, "Anothers: ");
	anothers = VehInfo[vehicleid][vPlayers]-anothers;
	if(anothers) { format(string, 128, "%d players\n",anothers); strcat(lstring, string); } else strcat(lstring, "None\n");
	//
	MyShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "���������", lstring, "��");
	return 1;
}

COMMAND:vfind(playerid, params[])
{
	new string[128];
    if(sscanf(params, "s[32] ", string))
        return ShowDialog(playerid, DMODE_VFIND);
	Dialogid[playerid] = DMODE_VFIND;
	OnDialogResponse(playerid, DMODE_VFIND, 1, 0, string);
	return 1;
}

COMMAND:veh(playerid, params[])
{
    new string[128];
    if(sscanf(params, "s[32] ", string))
        return SendClientMessage(playerid, COLOR_WHITE, "�����������: /veh [park/find/sellto/sell]");
	if(strcheck(string, "unpark") || strcheck(string, "park0"))
	{// [BT] // �������� ��������
		if(GetPlayerAdmin(playerid) < ADMIN_ADMIN)
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��� �������.");
		if(GetPlayerState(playerid) != 2)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���� �� ����� ������ ����������.");
		new vehicleid = GetPlayerVehicleID(playerid);
		if(CarInfo[vehicleid][cID] == 0 || CarInfo[vehicleid][cType] != C_TYPE_PLAYER)
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ����������� ���� ���������.");
		CarInfo[vehicleid][cX] = 0.0;
		CarInfo[vehicleid][cY] = 0.0;
		GameTextForPlayer(playerid, "~w~Vehicle has been~n~~y~UnParked", 3000, 3);
		return UpdateVehicleStatics(vehicleid);
	}
	else if(strcheck(string, "park"))
	{
		if(GetPlayerState(playerid) != 2)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���� �� ����� ������ ����������.");
		new vehicleid = GetPlayerVehicleID(playerid);
		//if(CarInfo[vehicleid][cID] == 0 || CarInfo[vehicleid][cType] == C_TYPE_DEFAULT)
		//	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ���� ���������");
		if(IsAvailableVehicle(vehicleid, playerid) != VEH_AVAILABLE_OWNER)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �������� ����� ����������.");
		if(!IsPlayerAtParkPlace(playerid) && CarInfo[vehicleid][cType] == C_TYPE_PLAYER)
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ���� ����� �������� ���������.");
		if(GetVehicleSpeed(vehicleid) > 2.0)
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������, ����� ��������������.");
		MyGetVehiclePos(vehicleid, CarInfo[vehicleid][cX], CarInfo[vehicleid][cY], CarInfo[vehicleid][cZ], CarInfo[vehicleid][cA]);
		GameTextForPlayer(playerid, "~w~Vehicle has been~n~~g~Parked", 3000, 3);
		return UpdateVehicleStatics(vehicleid);
	}
	else if(strcheck(string, "find"))
	{
		mysql_format(g_SQL, string, sizeof(string), "SELECT `fine_park` FROM `cars` WHERE `type` = 1 AND `ownerid` = '%d'", PlayerInfo[playerid][pUserID]);
		new Cache:result = mysql_query(g_SQL, string);
		new finepark;
		cache_get_value_name_int(0, "fine_park", finepark);
		new veh_num = cache_num_rows();
		cache_delete(result);
		if(veh_num == 0)
		{
		    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� �� ����� ����������� ������.");
		    return 1;
		}
		if(finepark > 0)
		{// �����-�������
            ShowPlayerGPSPoint(playerid, 1573.0726, -1605.7681, 14.0);
            return SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "�������������� ������ ���������� �������� �� ������ "SCOLOR_GPS"������ ��������");
		}
		else
		{
			foreach(Vehicle, v)
			{
			    if(CarInfo[v][cID] > 0 && CarInfo[v][cType] == C_TYPE_PLAYER && CarInfo[v][cOwnerID] == PlayerInfo[playerid][pUserID])
			    {
					new Float:pos[3];
					GetVehiclePos(v, Arr3<pos>);
		            ShowPlayerGPSPoint(playerid, Arr3<pos>);
		            return SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "�������������� ������ ���������� �������� �� ������ "SCOLOR_GPS"������ ��������");
			    }
		    }
	    }
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ �� �������, ���������� � �������������.");
	}
	else if(strcheck(string, "sellto"))
	{
		if(GetPlayerState(playerid) != 2)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���� �� ����� ������ ����������.");
		new vehicleid = GetPlayerVehicleID(playerid);
		if(IsAvailableVehicle(vehicleid, playerid) != VEH_AVAILABLE_OWNER)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �������� ����� ����������.");
	    if(CarInfo[vehicleid][cType] != C_TYPE_PLAYER)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ��������� �� �������� �����������.");
		if(!IsPlayerInRangeOfPoint(playerid, 50.0, 1529.4467,-1676.2250,13.3828))
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����������� �������� ������ ����� ��� ������� ��� �������.");
		new giveplayerid, price;
		if(sscanf(params, "{s[32]}ri", giveplayerid, price))
		    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /veh sellto [playerid] [����]");
		if(playerid == giveplayerid)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ����������� ��������� ������ ����.");
	    if(!IsPlayerLogged(giveplayerid))
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	    if(GetPlayerVehicleID(giveplayerid) != vehicleid)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� ������ ������ ����� � ����.");
	    //if(PlayerInfo[giveplayerid][pCarLic] == 0)
	    if(IsPlayerHaveLicThisVehicle(giveplayerid, GetVehicleModel(vehicleid)))
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ����� ������ ��� �������� �� ���� ���������.");
	    if(price < 0)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ��������� ������������� ����.");

        if(AskPlayer(playerid, giveplayerid, ASK_CAR_SELLTO, 30, price, vehicleid))
        {
			// AskAmount[giveplayerid] = price;
			// AskAmount2[giveplayerid] = vehicleid;
			SendFormatMessage(playerid, COLOR_WHITE, string, "������ {B1C8FB}%s{FFFFFF} ���������� '{B1C8FB}%s{FFFFFF}' �� {B1C8FB}%d$", ReturnPlayerName(giveplayerid), ReturnVehicleName(vehicleid), price);
			SendFormatMessage(giveplayerid, COLOR_WHITE, string, "{B1C8FB}%s{FFFFFF} ���������� ��� '{B1C8FB}%s{FFFFFF}' �� {B1C8FB}%d$ "ASK_CONFIRM_INFO, ReturnPlayerName(playerid), ReturnVehicleName(vehicleid), price);
			PlayerAction(playerid, "����������� ������� �����-������� ����������.");
		}
		else{
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ������ ���� �� �������� ������, ���������� �����.");
		}
	    return 1;
	}
	else if(strcheck(string, "sell"))
	{
		if(GetPlayerState(playerid) != 2)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���� �� ����� ������ ����������.");
		new vehicleid = GetPlayerVehicleID(playerid);
		if(IsAvailableVehicle(vehicleid, playerid) != VEH_AVAILABLE_OWNER)
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �������� ����� ����������.");
		if(CarInfo[vehicleid][cType] == C_TYPE_PLAYER && !IsAtCarSellPlace(playerid))
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ���� ����� ������-���� ����������.");
		new Float:proc = 0.70;
		if(IsPlayerInRangeOfPoint(playerid, 25.0, -1786.7600,1205.1584,24.8255)) proc = 0.75;
		new price = floatround(VehParams[GetVehicleModel(vehicleid) - 400][VEH_PRICE]*proc);
		if(sscanf(params, "{s[32]}s[4] ", string) || !strcheck(string, "yes"))
		{
		    format(string, 128, "��������� ����� ������: {33AA33}%d${FFFFFF}. ��� ������� �������: /veh sell yes", price);
		    SendClientMessage(playerid, COLOR_WHITE, string);
		    return 1;
		}
		if(CarInfo[vehicleid][cID] > 0)
		{
			mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `cars` WHERE `id` = '%d'", CarInfo[vehicleid][cID]);
			mysql_query_ex(string);
		}
		//
		MyDestroyVehicle(vehicleid);
		MyGivePlayerMoney(playerid, price);
		SendClientMessage(playerid, COLOR_SAYING, "- ��������: �� ������� ���� ������ - ��� ������ �� ���. ����� ��������!");
	    return 1;
	}
	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ �������� � ���� ������� �� ����������.");
}

//--- Report
SendDiscordNotification(playerid, playerName[], text[], reportId = -1, reportName[] = "") 
{
	new string[256];
	format(string, sizeof string, "?playerid=%d&playerName=%s&text=%s&reportId=%d&reportName=%s&token=162e3bc50e2eb52c", playerid, playerName, text, reportId, reportName);
	HTTP(1, HTTP_POST, SITE_ADRESS "/utils/feedback", string, "httpResponses");
	return 1;
}

Public: httpResponses(index, response_code, data[])
{
	printf("[HTTP Response] index = %d, response_code = %d, data = '%s'", index, response_code, data);
	return 1;
}

COMMAND:ask(playerid, params[])
{
	new string[164];
	if(PlayerInfo[playerid][pAskMute] > gettime())
	    return SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "��� ������������� �����-�����. ��������: %d ���", PlayerInfo[playerid][pAskMute] - gettime());
	new question[128];
	if(sscanf(params, "s[128]", question))	return ShowDialog(playerid, DMENU_CONTACT);
	if(!IsAdminsOnline())
	{
		SendDiscordNotification(playerid, ReturnPlayerName(playerid), question);
		//return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������� ��� �������, ������� �������� �� ��� ������");
	}
	else
	{
		format(string, 128, "Ask | %s[%d]: %s", ReturnPlayerName(playerid), playerid, question);
		SendAdminMessage(COLOR_ASK, string, 1);
	}
	format(string, 128, "��������� ������: {FFFFFF}%s", question);
	SendClientMessage(playerid, COLOR_ASK, string);
    /*if(gAskCount >= MAX_ASK_COUNT)	
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� �� ���������� ������, ���������� �����.");
	}
	new question[128];
	if(sscanf(params, "s[128]", question))	return ShowDialog(playerid, DMENU_CONTACT);
	if(!IsAdminsOnline())
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ������ ����� �� ����� �������� �� ������. ���������� ���������� �� �����!");
	}
	new slot = -1;
	for(new i; i < MAX_ASK_COUNT; i++)
	{
		if(gAsk[i][askBusy] == false)
		{
			slot = i;
			break;
		}
	}
	if(slot == -1)	
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� �� ������� ������, ���������� �����.");
	}

	gAskCount++;
	gAsk[slot][askSender]	= playerid;
	gAsk[slot][askStatus]	= false;
	strput(gAsk[slot][askText], question);
	gAsk[slot][askBusy]		= true;

	format(string, 128, "%s[%d] ����� ������ (����������� /tickets)", ReturnPlayerName(playerid), playerid);
	SendAdminMessage(COLOR_ASK, string, 1);
	SendFormatMessage(playerid, COLOR_ASK, string, "��������� ������: {FFFFFF}%s", question);*/
	return 1;
}

flags:tickets(CMD_HELPER);
COMMAND:tickets(playerid, params[])
{
	ShowDialog(playerid, DADMIN_TICKETS);
	return 1;
}

COMMAND:report(playerid, params[])
{
	new string[128];
	if(PlayerInfo[playerid][pAskMute] > gettime())
	    return SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "��� ������������� �����-�����. ��������: %d ���", PlayerInfo[playerid][pAskMute] - gettime());
	if(GetPlayerAdmin(playerid))
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������������� �� ����� ������������ ��� �������.");
	new giveplayerid, report[128];
	if(sscanf(params, "rs[128]", giveplayerid, report))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /report [playerid/playername] [������]");
	if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	if(!IsAdminsOnline())
	{
		SendDiscordNotification(playerid, ReturnPlayerName(playerid), report, giveplayerid, ReturnPlayerName(giveplayerid));
		//return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������� ��� �������, ������� �������� �� ��� ������.");
	}
	else
	{
		format(string, 128, "[AdmRep] %s[%d]: %s[%d] %s", ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, report);
		SendAdminMessage(COLOR_LIGHTRED, string);
	}
	SendFormatMessage(playerid, COLOR_LIGHTRED, string, "�� ��������� ������ �� %s[%d]: %s", ReturnPlayerName(giveplayerid), giveplayerid, report);
	return 1;
}

flags:answer(CMD_HELPER);
COMMAND:answer(playerid, params[])
{
	new giveplayerid, answer[128];
	if(sscanf(params, "rs[128]", giveplayerid, answer))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /answer [playerid/playername] [�����]");

	if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");

	new string[256];
	SendFormatMessage(giveplayerid, COLOR_ANSWER, string, "%s %s ��������: {FFFFFF}%s", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), answer);
	format(string, 256, "%s %s[%d]: {FFFFFF}%s[%d], %s", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, answer);
	SendAdminMessage(COLOR_ANSWER, string, 1);
	PlayerPlaySound(giveplayerid, 6401, 0, 0, 0);
	return 1;
}

//--- Houses
COMMAND:home(playerid, params[])
{
	new house = GetPlayerHouseID(playerid);
	if(house == -1)
	{
		new string[128];
		format(string, sizeof(string), "SELECT `X`, `Y`, `Z` FROM `houses` WHERE `ownerid` = '%d' LIMIT 1", PlayerInfo[playerid][pUserID]);
		new Cache:result = mysql_query(g_SQL, string);
		if(cache_num_rows())
		{
			new Float:pos[3];
			cache_get_value_name_float(0, "X", pos[0]);
			cache_get_value_name_float(0, "Y", pos[1]);	
			cache_get_value_name_float(0, "Z", pos[2]);
			ShowPlayerGPSPoint(playerid, Arr3<pos>, 4.0);
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_GPS "��� ��� ������� �� ������ "SCOLOR_GPS"������ ��������");
		}
		else 	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ����.");
		cache_delete(result);
	}
	else
	{
		if(HouseInfo[house][hOwnerID] == PlayerInfo[playerid][pUserID])	ShowDialog(playerid, DHOME_MAIN);
		else 		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� �������� ����� ����.");
	}
    return true;
}

COMMAND:masklist(playerid, params[])
{
	if(GetPlayerAdmin(playerid) < ADMIN_MODER)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��� �������.");
	new lstring[1792];
	new bool:founded = false;
	foreach(LoginPlayer, i)
	{
	    if(InMask[i])
	    {
	        founded = true;
		    format(lstring, sizeof(lstring), "%s"MAIN_COLOR"� {FFFFFF}%s[%d]\n", lstring, ReturnPlayerName(i), i);
		}
	}
	if(!founded) lstring = "{AFAFAF}< �� ������� ��� ������� � �����. >";
	MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_LIST, "������ � �����:", lstring, "�������");
	return 1;
}

COMMAND:adminlist(playerid, params[])
{
	if(GetPlayerAdmin(playerid) < ADMIN_DEVELOPER)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��� �������.");

	new query[512], string[64] = "%d/%m/%Y"; // Date Format
	mysql_format(g_SQL, query, sizeof(query), "SELECT `username`, `online`, `admin`, FROM_UNIXTIME(`exitunix`, '%s') FROM `players` WHERE `admin` > 0 ORDER BY `admin` DESC, `exitunix` DESC", string);
	new Cache:result = mysql_query(g_SQL, query);
	new row_count = cache_num_rows();
	if(row_count == 0)
	{
		cache_delete(result);
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ����� ������� �� ������� �� ������ ��������������.");
	}
    new name[32], date[20], online, admin,
    	lstring[2048] = "ID\t�������\t��� � ����\t��� ������\n";
    for(new r = 0; r < row_count; r++)
    {
		cache_get_value_index(r, 0, name);
		cache_get_value_name_int(r, "online", online);
		cache_get_value_name_int(r, "admin", admin);
		cache_get_value_index(r, 3, date);
		if(online == -1)
			format(lstring, sizeof(lstring), "%s{DFDFDF}%d\t{DFDFDF}%s\t{DFDFDF}%s\t{DFDFDF}%s\n", lstring, online, getAdminStatus(admin), date, name);
		else
			format(lstring, sizeof(lstring), "%s{FFFFFF}%d\t{FFFFFF}%s\t{FFFFFF}%s\t{FFFFFF}%s\n", lstring, online, getAdminStatus(admin), date, name);
	}
	cache_delete(result);
	format(string, sizeof(string), "����������������� ������:");
	MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_TABLIST_HEADERS, string, lstring, "�������", "");
	return 1;
}

public OnPlayerChangeSkin(playerid, skinid)
{
	#if defined _inventory_acsr_included
		Acsr.UpdatePlayerAcsr(playerid);
	#endif

	#if defined _inventory_interface_included
		IFace.Inv_UpdateSkin(playerid);
	#endif

	if(!IsPlayerInAnyVehicle(playerid))
	{
		SetTimerEx("FixPlayerFreeze", 500, false, "i", playerid);
	}
	return true;
}

public OnPlayerStartWork(playerid, work)
{
	switch(work)
	{
		#if defined	_job_job_theft_included
			case JOB_THEFT:
			{
				return Theft_StartWork(playerid);
			}
		#endif
		#if defined	_job_job_taxi_included
			case JOB_TAXI:
			{
				return Taxi_StartWork(playerid);
			}
		#endif
	}
	return true;
}

public OnPlayerFinishWork(playerid, work, reason)
{
	switch(work)
	{
		#if defined	_job_job_theft_included
			case JOB_THEFT:
			{
				Theft_FinishWork(playerid, reason);
			}
		#endif

		#if defined	_job_job_trucker_included
			case JOB_TRUCKER:
			{
				Trucker_FinishWork(playerid, reason);
			}
		#endif

		#if defined	_job_job_busdriver_included
			case JOB_BUSDRIVER:
			{
				BusDriver_FinishWork(playerid, reason);
			}
		#endif

		#if defined	_job_part_delivery_included
			case PART_DELIVERY:
			{
				Delivery_FinishWork(playerid, reason);
			}
		#endif	

		#if defined	_job_part_farmer_included
			case PART_FARMER:
			{
				Farmer_FinishWork(playerid);
			}
		#endif

		#if defined	_job_part_loader_included
			case PART_LOADER:
			{
				Loader_FinishWork(playerid);
			}
		#endif

		#if defined	_job_job_taxi_included
			case JOB_TAXI:
			{
				Taxi_FinishWork(playerid);
			}
		#endif	
	}
}

public OnPlayerHackLockClick(playerid, step, success)
{
	if(success)
	{
		MyApplyAnimation(playerid, "CASINO", "dealone", 4.1, 0, 0, 0, 0, 2000, 1);
		PlayerPlaySound(playerid, 32000, 0.0, 0.0, 0.0);

		if(random(2))	GameTextForPlayer(playerid, "~g~Successful", 2000, 4);
		else			GameTextForPlayer(playerid, "~g~Very nice", 2000, 4);

		foreach(Cop, copid)
	    {
			if(GetDistanceBetweenPlayers(playerid, copid) <= 50 && GetPlayerState(copid) != PLAYER_STATE_SPECTATING)
			{
			    CrimePlayer(playerid, CRIME_THEFT_AUTO);
				ShowPlayerHint(playerid, "�� ��������� �������� ������������ ������ �������");
			    if(!random(2))	PlayerPlaySound(playerid, 10200, 0.0,0.0,0.0);	// Hey, you! Police. Stop!
			    else 			PlayerPlaySound(playerid, 10201, 0.0,0.0,0.0);	// Hey, what are you doing in here?
				break;
			}
		}
		return 2000;
	}
	else
	{
		new bool:theft_break = false;
	    if(random(2))
	    {
	    	GameTextForPlayer(playerid, RusText("~n~~r~������� ���������...", PlayerInfo[playerid][pRusifik]), 2000, 4);
	    	Inv.PlayerDeleteThing(playerid, THING_PICKLOCK, 0, 1);	
	    	if(!Inv.GetThing(playerid, THING_PICKLOCK))
	    	{
				ShowPlayerHint(playerid, "� ��� ��������� �������");
				theft_break = true;
	    	}
		}
		else
		{
			GameTextForPlayer(playerid, RusText("~n~~y~���������� �����", PlayerInfo[playerid][pRusifik]), 2000, 4);
		}
		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		LoseAnim(playerid);
		if(theft_break)
			return (0);
	}
	return (1);
}

public OnPlayerHackLock(playerid, success)
{
	if(success)
	{
		BreakCar(playerid, BREAK_CAR_HACKING, 1);
	}
	return (1);
}

public	OnPlayerPhoneCall(playerid, number)
{
	switch(number)
	{
		case 911:
		{
			SetPVarInt(playerid, "Player:Call911", 1);
			SendClientMessage(playerid, COLOR_BLUE, "�������� 911 �������: ������������, �� ��������� � ������ 911.");
			SendClientMessage(playerid, COLOR_BLUE, "�������� 911 �������: ��� ��� �����: ������� ��� ������?");
			return (1);
		}
	#if defined	_job_job_taxi_included
		case 555:
		{
			if(Taxi_PlayerUsed(playerid))
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��� ����� � �����.");
				return (1);
			}
			if(Job.GetPlayerNowWork(playerid) == JOB_TAXI)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ �������� ����� �������� �� ���������.");
				return (1);
			}
			if(TaxiCall != -1)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���-�� ��� ������� ������, ���������� �����.");
				return (1);
			}
			new bool:founded;
			foreach(LoginPlayer, i)
			{
				if(Job.GetPlayerNowWork(i) == JOB_TAXI)
				{
					founded = true;
					break;
				}
			}
			if(founded == false)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��������� ��� �� ������ ��������, ���������� �����.");
				return (1);
			}
			new string[128];
			format(string, sizeof(string), "[���������]: %s [���: %d] �������� �����. {FFFFFF}(�������: Y)", ReturnPlayerName(playerid), PlayerInfo[playerid][pPhoneNumber]);
			SendJobMessage(JOB_TAXI, COLOR_LIGHTBLUE, string);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "* �� ��������� � ���������, �������� ������ � ��������� �����");

			TaxiCall = playerid;
			TaxiCallTime = 60;
			return (1);
		}
	#endif 	
		case 600:
		{
			if(GetPVarInt(playerid, "Player:AtWork") == JOB_MECHANIC)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ �������� �������� �������� �� ���������.");
				return (1);
			}
			if(MechanicCall != -1)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���-�� ��� ������� ������, ���������� �����.");
				return (1);
			}
			new founded;
			foreach(LoginPlayer, i)
			{
				if(GetPVarInt(i, "Player:AtWork") == JOB_MECHANIC)
				{
					if(MechanicClientid[i] == playerid)
					{
						founded = 2;
						break;
					}
					founded = 1;
				}
			}
			if(founded == 0)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��������� ��� �� ������ ��������, ���������� �����.");
				return (1);
			}
			if(founded == 2)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ����� ��� �������.");
				return (1);
			}
			new string[128];
			format(string, sizeof(string), "[���������]: %s [���: %d] �������� ��������. {FFFFFF}(����� �������, ������� 2)", ReturnPlayerName(playerid), PlayerInfo[playerid][pPhoneNumber]);
			SendJobMessage(JOB_MECHANIC, COLOR_LIGHTBLUE, string);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "* �� ��������� � ������ �������� ������, �������� ������ � ��������� �����");

			MechanicCall = playerid;
			MechanicCallTime = 60;
			return (1);
		}
	}
	return (0);
}

//	Copyright � Silver Break 2017
//	Developed by Borog25 & Impereal