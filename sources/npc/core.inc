#if defined _npc_core_included
	#endinput
#endif
#define _npc_core_included

#include "npc/header"
#include "vehicle/header"

#include "npc/trains"

stock MyCreateNPC(name[], script[] = "")
{
    #if defined _FCNPC_included
        #pragma unused script
		return FCNPC_Create(name);
	#elseif defined RNPC_VERSION
		#pragma unused script
		return ConnectRNPC(name);
	#else
	    //ConnectNPC(name, script);
	    return -1;
	#endif
}

// stock CreateNPCTextLabel(npcid)
// {
//     new string[128];
//     format(string, 128, "%s\n{AFAFAF}(прицелиться + y)", ReturnPlayerName(npcid));// CFB53B
//     CreateDynamic3DTextLabel(string, 0xFFFFFFFF, 0.0, 0.0, 0.15, 20.0, npcid, INVALID_VEHICLE_ID, 1, 0);
// }

stock	NPC.CreateRecordVehicle()
{
	#if defined _npc_trains_included
		// Поезда	(создаются всегда первыми)
		NPC.CreateTrainsVehicle();
	#endif

	// Автобусы для записи ботов (маршрут: Аэропорт ЛС - Джефферсон)
	/*BusVehicle[0] = MyCreateVehicle(418, 1188.3907,-1815.1123,13.7037, 0.0, 6, 6);
	BusVehicle[1] = MyCreateVehicle(418, 1188.3907,-1821.9747,13.7036, 0.0, 6, 6);
	BusVehicle[2] = MyCreateVehicle(418, 1188.3907,-1829.9794,13.7036, 0.0, 6, 6);
	BusVehicle[3] = MyCreateVehicle(418, 1188.3907,-1838.1414,13.7036, 0.0, 6, 6);
	for(new i = 0; i < sizeof(BusVehicle); i++)
	{
	    new vehicleid = BusVehicle[i];
		VehInfo[vehicleid][vLabel] = CreateDynamic3DTextLabel("Аэропорт ЛС - Джефферсон\nБесплатный", 0xFF8300FF, 0.0, 0.0, 1.5, 40.0, INVALID_PLAYER_ID, vehicleid, 1);
		VehInfo[vehicleid][vLights] = true;
		VehInfo[vehicleid][vRadio] = 1;
		CarInfo[vehicleid][cOwnerID] = -1;
		UpdateVehicleParamsEx(vehicleid);
	}*/
}

Public: NPC.Init()
{
	new string[16];
	format(string, sizeof(string), "maxnpc %d", MAX_NPC);
	SendRconCommand(string);

	printf("  Load NPC:");
	for(new i = 0; i < MAX_NPC; i++)
	{
		NPC_ID[i] = MyCreateNPC(NpcInfo[i][n_Name]);//, NpcInfo[i][n_Script]);
		if(NPC_ID[i] == INVALID_PLAYER_ID)
			printf("WARNING! NPC '%s' (%d) was not created!", NpcInfo[i][n_Name], i);
	}

#if defined _FCNPC_included
	for(new i = 0; i < MAX_NPC; i++)
	{
		if(NPC_ID[i] == INVALID_PLAYER_ID)
			continue;	//  fix
		FCNPC_Spawn(NPC_ID[i], NpcInfo[i][n_Skin], Arr3<NpcInfo[i][n_Pos]>);
		FCNPC_SetAngle(NPC_ID[i], NpcInfo[i][n_Pos][3]);
		SetPlayerColor(NPC_ID[i], DEFAULT_NPC_COLOR);
	}
#endif

	#if defined _npc_trains_included
		NPC.TrainsInit();
	#endif

	return (1);
}

public OnGameModeExit()
{
	#if defined _FCNPC_included
		for(new i = 0; i < MAX_NPC; i++)
		{
			if(NPC_ID[i] != INVALID_PLAYER_ID)
				FCNPC_Destroy(NPC_ID[i]);
		}
	#else
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerNPC(i))
				Kick(i);
		}
	#endif

	#if defined NPC_OnGameModeExit
		return NPC_OnGameModeExit();
	#else
		return (1);
	#endif
}
#if defined _ALS_OnGameModeExit
	#undef OnGameModeExit
#else
	#define _ALS_OnGameModeExit
#endif
#define OnGameModeExit NPC_OnGameModeExit
#if defined NPC_OnGameModeExit
	forward NPC_OnGameModeExit();
#endif

public OnPlayerRequestClass(playerid, classid)
{
	if (IsPlayerNPC(playerid))
   	{
	#if	!defined _FCNPC_included
		for (new i = 0; i < MAX_NPC; i++)
		{
			if (strcmp(ReturnPlayerName(playerid), NpcInfo[i][n_Name], true) == 0)
			{
				NPC_ID[i] = playerid;
				SetSpawnInfo(playerid, 0, NpcInfo[i][n_Skin], Arr4<NpcInfo[i][n_Pos]>, 0, 0, 0, 0, 0, 0);
			}
		}
	#endif
	}

	#if defined NPC_OnPlayerRequestClass
		return NPC_OnPlayerRequestClass(playerid, classid);
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerRequestClass
	#undef OnPlayerRequestClass
#else
	#define _ALS_OnPlayerRequestClass
#endif
#define OnPlayerRequestClass NPC_OnPlayerRequestClass
#if defined NPC_OnPlayerRequestClass
	forward NPC_OnPlayerRequestClass(playerid, classid);
#endif

public OnPlayerSpawn(playerid)
{
	if (IsPlayerNPC(playerid))
	{
		//SetPlayerColor(playerid, 0xB1C8FB33);
	#if !defined _FCNPC_included
		for (new i = 0; i < sizeof(NpcInfo); i++)
		{
			if (NPC_ID[i] != playerid)
				continue;
			for (new t = 0; t < sizeof(TrainInfo); t++)
			{
				if (i != TrainInfo[t][trNPC])
					continue;
		       	MyPutPlayerInVehicle(playerid, TrainInfo[t][trID], 0);
		    #if defined RNPC_VERSION
		        if (++TDriverCount == sizeof(TrainInfo))
					StartTrainCycle();
		    #endif
		    	//return true;
			}
		}
	#endif
	}

	#if defined NPC_OnPlayerSpawn
		return NPC_OnPlayerSpawn(playerid);
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn NPC_OnPlayerSpawn
#if defined NPC_OnPlayerSpawn
	forward NPC_OnPlayerSpawn(playerid);
#endif


#if defined _FCNPC_included
	public FCNPC_OnSpawn(npcid)
	{
		//SetPlayerColor(npcid, DEFAULT_NPC_COLOR);
		
		/*if(npcid == NPC_ID[NPC_BusDriver1])
		{
			if(FCNPC_PutInVehicle(npcid, BusVehicle[0], 0) == 0)
			{
				printf("ERROR! FCNPC %d didn't seat in vehicle!", npcid);
			}
			else
			{
				MyStartPlayback(npcid);
			    SetPlayerColor(npcid, COLOR_ORANGE);
			}
		}
		else if(npcid == NPC_ID[NPC_BusDriver2])
		{
			if(FCNPC_PutInVehicle(npcid, BusVehicle[1], 0) == 0)
			{
				printf("ERROR! FCNPC %d didn't seat in vehicle!", npcid);
			}
			else
			{
				MyStartPlayback(npcid);
			    SetPlayerColor(npcid, COLOR_ORANGE);
			}
		}
		else if(npcid == NPC_ID[NPC_BusDriver3])
		{
			if(FCNPC_PutInVehicle(npcid, BusVehicle[2], 0) == 0)
			{
				printf("ERROR! FCNPC %d didn't seat in vehicle!", npcid);
			}
			else
			{
				MyStartPlayback(npcid);
			    SetPlayerColor(npcid, COLOR_ORANGE);
			}
		}
		else if(npcid == NPC_ID[NPC_BusDriver4])
		{
			if(FCNPC_PutInVehicle(npcid, BusVehicle[3], 0) == 0)
			{
				printf("ERROR! FCNPC %d didn't seat in vehicle!", npcid);
			}
			else
			{
				MyStartPlayback(npcid);
			    SetPlayerColor(npcid, COLOR_ORANGE);
			}
		}*/
		return (1);
	}

	Public: MyStartPlayback(npcid)
	{
		/*if(npcid == NPC_ID[NPC_BusDriver1])
		{
		    FCNPC_StartPlayingPlayback(npcid, "bus_1");
		   	BusPlaybackCount++;
		}
		else if(npcid == NPC_ID[NPC_BusDriver2])
		{
			FCNPC_StartPlayingPlayback(npcid, "bus_2");
			BusPlaybackCount++;
		}
		else if(npcid == NPC_ID[NPC_BusDriver3])
		{
			FCNPC_StartPlayingPlayback(npcid, "bus_3");
			BusPlaybackCount++;
		}
		else if(npcid == NPC_ID[NPC_BusDriver4])
		{
			FCNPC_StartPlayingPlayback(npcid, "bus_4");
			BusPlaybackCount++;
		}*/
	    return true;
	}

	public FCNPC_OnFinishPlayback(npcid)
	{
		/*if(npcid == NPC_ID[NPC_BusDriver1] || npcid == NPC_ID[NPC_BusDriver2] || npcid == NPC_ID[NPC_BusDriver3] || npcid == NPC_ID[NPC_BusDriver4])
		{
			if(--BusPlaybackCount == 0)
			{
				MyStartPlayback(NPC_ID[NPC_BusDriver1]);
				MyStartPlayback(NPC_ID[NPC_BusDriver2]);
				MyStartPlayback(NPC_ID[NPC_BusDriver3]);
				MyStartPlayback(NPC_ID[NPC_BusDriver4]);
			}
		}*/
		return (1);
	}

	/*public FCNPC_OnVehicleExitComplete(npcid)
	{
		print("NPC Train exit vehicle");

	    for( new i = 0; i < sizeof(TrainInfo); i++ )
		{
			if( TrainInfo[ i ][ trNPC ] != npcid )
			    continue;
			FCNPC_StopRecordingPlayback( npcid );
	   		TrainInfo[ i ][ trPlaybackCycle ] = 0;
		}
		return true;
	}*/
#endif

#if defined _FCNPC_included
	flags:gotobot(CMD_MODER);
	COMMAND:gotobot(playerid, params[])
	{
		new npcid;
		if(sscanf(params, "i", npcid))
			return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /gotobot [npcid]");
		if(!FCNPC_IsSpawned(npcid))
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого бота нет на сервере.");
		new string[128];
		new Float: X, Float: Y, Float: Z;
		FCNPC_GetPosition(npcid, X, Y, Z);
		if(GetPlayerState(playerid) == 2)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			MySetVehiclePos(vehicleid, X+2, Y+2, Z);
			LinkVehicleToInterior(vehicleid, PlayerInfo[playerid][pPosINT]);
			SetVehicleVirtualWorld(vehicleid, PlayerInfo[playerid][pPosVW]);
		}
		else MySetPlayerPos(playerid, X, Y+2, Z);
		format(string, 128, "[AdmCmd]: %s %s[%d] телепортировался к боту %s[%d]",
			GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(npcid), npcid);
		SendAdminMessage(COLOR_ADMIN, string);
		return 1;
	}

	/*flags:startbot(CMD_MODER);
	COMMAND:startbot(playerid, params[])
	{
		BusPlaybackCount = 0;
		MyStartPlayback(NPC_ID[NPC_BusDriver1]);
		MyStartPlayback(NPC_ID[NPC_BusDriver2]);
		MyStartPlayback(NPC_ID[NPC_BusDriver3]);
		MyStartPlayback(NPC_ID[NPC_BusDriver4]);
		SendClientMessage(playerid, COLOR_SERVER, "[BT]: Цикл ботов запущен сначала");
		return 1;
	}

	flags:putbotdriver(CMD_DEVELOPER);
	COMMAND:putbotdriver(playerid, params[])
	{
		new npcid;
		if(sscanf(params, "i", npcid))
			return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /putbotdriver [npcid]");
		if(!FCNPC_IsSpawned(npcid))
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого бота нет на сервере.");

		new string[128], vehicleid;
		if(npcid == NPC_ID[NPC_BusDriver1]) vehicleid = BusVehicle[0];
		else if(npcid == NPC_ID[NPC_BusDriver2]) vehicleid = BusVehicle[1];
		else if(npcid == NPC_ID[NPC_BusDriver3]) vehicleid = BusVehicle[2];
		else if(npcid == NPC_ID[NPC_BusDriver4]) vehicleid = BusVehicle[3];
		else return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого бот не является водителем автобуса.");

		if(FCNPC_PutInVehicle(npcid, vehicleid, 0) == 0)
		{
			SendFormatMessage(playerid, COLOR_LIGHTRED, string, "[BT]: Бот-Водитель[%d] не захотел сесть в автомобиль vehicleid[%d]", npcid, vehicleid);
		}
		else
		{
			SetTimerEx("MyStartPlayback", 5000, 0, "d", npcid);
			SetPlayerColor(npcid, COLOR_ORANGE);
			SendFormatMessage(playerid, COLOR_SERVER, string, "[BT]: Бот-Водитель[%d] успешно сел в автомобиль vehicleid[%d]", npcid, vehicleid);
		}
		return 1;
	}*/
#endif