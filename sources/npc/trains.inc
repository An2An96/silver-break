#if defined _npc_trains_included
	#endinput
#endif
#define _npc_trains_included

#include "vehicle/header"

#define STATION_3D_COLOR	0x33CCFFFF

enum e_Station
{
	stName[32],		// Название станции
	Float:stPos[3],	// Позиция станции
	stInterval,		// Время в пути до станции (сек)
	stStop,			// Стоянка на этой станции (сек)
}
static const StationInfo[][e_Station] =
{
	{ "Fort Carson Train Station",
		{ 144.74,	1261.49,	22.7 }, 135, 60	},	//  остановка Fort Carson
	{ "Suburban Station Las Venturas",
		{ 1433.5,	2627.07,	11.4 }, 135, 30	},	//  остановка LV (Train 2 start)
	{ "Las Venturas City Train Station",
		{ 2859.5,	1291.19,	11.4 }, 130, 60	},	//  остановка LV
	{ "Los Santos City Train Station",
		{ 1736.0,	-1949.8,	14.1 }, 210, 60	},	//  остановка LS (Train 3 start)
	{ "Los Santos Underground Station",
		{ 817.66,	-1361.3,	-0.5 }, 92,  30	},	//  остановка тоннель LS
	{ "San Fierro City Train Station",
		{ -1951.9,	139.257,	26.3 }, 237, 60	}	//	остановка SF (Train 1 start)
};
static Text3D:RailStation3DText[ sizeof(StationInfo) ];

//  Поезда
enum e_Train
{
	// Static data
	trVID,			 // Модель поезда
	Float:trPos[4],	 // Позиция поезда
	trNPC,			 // Номер бота-машиниста (не игровой ид)
	trAllStations,	 // Количество станций
	// Dynamic data
	trID,			 // ИД поезда
	trPlayback		 // Количество пройденых остановок
}
static TrainInfo[3][e_Train] =
{
	{ 538, { -1942.795, 168.4164, 27.0006, 200.0 },
		NPC_TrainDriver1, sizeof(StationInfo), 0, 0 },
	{ 538, { 1462.0745, 2630.878, 10.8203, 200.0 },
		NPC_TrainDriver2, sizeof(StationInfo), 0, 0 },
	{ 537, { 1700.7551, -1953.65, 14.8756, 200.0 },
		NPC_TrainDriver3, 3, 0, 0 }
};

new TDriverCount = 0;

Public:	NPC.TrainsInit()
{
	for (new i = 0; i < sizeof(StationInfo); i++)
	{
		RailStation3DText[i] = CreateDynamic3DTextLabel(" ", STATION_3D_COLOR, 
			StationInfo[i][stPos][0],
			StationInfo[i][stPos][1],
			StationInfo[i][stPos][2] + 1.0,
			50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	}
}

stock	NPC.CreateTrainsVehicle()
{
	for(new i = 0; i < sizeof(TrainInfo); i++)
	{
        TrainInfo[i][trID] = MyCreateVehicle(TrainInfo[i][trVID], Arr4<TrainInfo[i][trPos]>, 1, 1);
        VehInfo[ TrainInfo[i][trID] ][vLocked] = 999;
        if(TrainInfo[i][trVID] == 537)
        {
        	freightTrain[0] = TrainInfo[i][trID] + 1;
        	freightTrain[1] = TrainInfo[i][trID] + 2;
        	freightTrain[2] = TrainInfo[i][trID] + 3;
        	VehInfo[ freightTrain[0] ][vLocked] = 999;
			VehInfo[ freightTrain[1] ][vLocked] = 999;
			VehInfo[ freightTrain[2] ][vLocked] = 999;
        }
        else
        {
	    #if defined _FCNPC_included
			VehInfo[ TrainInfo[i][trID] + 1 ][vLocked] = 999;
			VehInfo[ TrainInfo[i][trID] + 2 ][vLocked] = 999;
			VehInfo[ TrainInfo[i][trID] + 3 ][vLocked] = 999;
		#else
			CarInfo[ TrainInfo[i][trID] + 1 ][cOwnerID] = -1;
			CarInfo[ TrainInfo[i][trID] + 2 ][cOwnerID] = -1;
			CarInfo[ TrainInfo[i][trID] + 3 ][cOwnerID] = -1;
		#endif
        }
	}
	if(TrainInfo[0][trID] != 1)
		printf("WARNING! Trains must be created first (ID 1-3), the current Id's': %d-%d", TrainInfo[0][trID], TrainInfo[0][trID] + 2);
	else
		print("  Trains successfully created");
}

#if defined _FCNPC_included
	public	FCNPC_OnSpawn(npcid)
	{
		for (new i = 0; i < sizeof(TrainInfo); i++)
		{
			if (npcid == NPC_ID[TrainInfo[i][trNPC]])
			{
				if(FCNPC_PutInVehicle(npcid, TrainInfo[i][trID], 0))
					SetPlayerColor(npcid, 0x8C5F11FF);
				else
					printf("ERROR! FCNPC %d didn't seat in vehicle!", npcid);
				if(++TDriverCount == sizeof(TrainInfo))
					SetTimer("StartTrainCycle", 5000, 0);
			}
		}

		#if defined Trains_FCNPC_OnSpawn
			return Trains_FCNPC_OnSpawn(npcid);
		#else
			return (1);
		#endif
	}
	#if defined _ALS_FCNPC_OnSpawn
		#undef FCNPC_OnSpawn
	#else
		#define _ALS_FCNPC_OnSpawn
	#endif
	#define FCNPC_OnSpawn Trains_FCNPC_OnSpawn
	#if defined Trains_FCNPC_OnSpawn
		forward Trains_FCNPC_OnSpawn(npcid);
	#endif

	public	FCNPC_OnFinishPlayback(npcid)
	{
		OnNPCFinishPlayback(npcid);
		
		#if defined Trains_FCNPC_OnFinishPlayback
			return Trains_FCNPC_OnFinishPlayback(npcid);
		#else
			return (1);
		#endif
	}
	#if defined _ALS_FCNPC_OnFinishPlayback
		#undef FCNPC_OnFinishPlayback
	#else
		#define _ALS_FCNPC_OnFinishPlayback
	#endif
	#define FCNPC_OnFinishPlayback Trains_FCNPC_OnFinishPlayback
	#if defined Trains_FCNPC_OnFinishPlayback
		forward Trains_FCNPC_OnFinishPlayback(npcid);
	#endif
#elseif defined RNPC_VERSION
	public OnRNPCPlaybackFinished(npcid)
	{
		OnNPCFinishPlayback(npcid);

		#if defined Trains_OnRNPCPlaybackFinished
			return Trains_OnRNPCPlaybackFinished(npcid);
		#else
			return (1);
		#endif
	}
	#if defined _ALS_OnRNPCPlaybackFinished
		#undef OnRNPCPlaybackFinished
	#else
		#define _ALS_OnRNPCPlaybackFinished
	#endif
	#define OnRNPCPlaybackFinished Trains_OnRNPCPlaybackFinished
	#if defined Trains_OnRNPCPlaybackFinished
		forward Trains_OnRNPCPlaybackFinished(npcid);
	#endif
#endif

Public: StartTrainCycle()
{
	print("[TRAIN]: Starting train cycle...");
	for(new train; train < sizeof(TrainInfo); train++)
	{
	    TrainInfo[train][trPlayback] = 0;
		NextTrainPlayback(train);
	}
	new interval;
	for(new s; s < sizeof(StationInfo); s++)
	{
	    if(s != 0 && s != 2)
			interval += StationInfo[s][stStop];
	    else
			interval = 0;
		interval += StationInfo[s][stInterval];
		UpdateStationTime(s, interval);
	}
	return (1);
}

static	OnNPCFinishPlayback(npcid)
{
	new string[128];

	for(new train = 0; train < sizeof(TrainInfo); train++)
	{
		new npc = TrainInfo[train][trNPC];
		if(npcid == NPC_ID[npc])
		{
			TrainInfo[train][trPlayback]++;
			new station = GetTrainStation(npcid);
			if(npcid != NPC_TrainDriver3)
			{
				format(string, sizeof(string),
					"[Railway Station]: Поезд прибыл на станцию, \
					остановка: %d сек.", StationInfo[station][stStop]);
				SendRadiusMessageEx(Arr3<StationInfo[station][stPos]>,
					50.0, COLOR_LIGHTBLUE, string);
			}
			if (TrainInfo[train][trPlayback] == TrainInfo[train][trAllStations])
			{	// Проверка для начала нового цикла
				new finished;
				for(new t; t < sizeof(TrainInfo); t++)
					if(TrainInfo[t][trPlayback] == TrainInfo[t][trAllStations])
						finished++;
				if(finished == sizeof(TrainInfo))
					SetTimer("StartTrainCycle",
						StationInfo[station][stStop] * 1000, false);
			}
			else
			{
				if(npcid == NPC_TrainDriver3)
					SetTimerEx("NextTrainPlayback", 60000, 0, "d", 2);
				else
					SetTimerEx("NextTrainPlayback",
						StationInfo[station][stStop] * 1000, 0, "d", train);
				if(npcid == NPC_TrainDriver1)
					UpdateStationTime(station, 835);
				else if(npcid == NPC_TrainDriver2)
					UpdateStationTime(station, 315);
			}
		}
	}
}

Public: NextTrainPlayback(train)
{
    new string[64],
		npcid = NPC_ID[TrainInfo[train][trNPC]];
	if (TrainInfo[train][trPlayback] <= TrainInfo[train][trAllStations])
	{
		format(string, sizeof(string), "train_%d_%d",
			train + 1, TrainInfo[train][trPlayback]);
	#if defined _FCNPC_included
		if (FCNPC_StartPlayingPlayback(npcid, string))
 	#elseif defined RNPC_VERSION
		if (RNPC_StartPlayback(npcid, string))
	#else
		if (false)
	#endif
		{
		    //printf("[TRAIN]: TrainDriver%d start record (%s)", train, string);
		}
		else
		    printf("ERROR! TrainDriver%d error start record (%s)",
				train, string);
	}
	return (1);
}

static	GetTrainStation(npcid)
{
	new Float:X, Float:Y, Float:Z;
#if defined _FCNPC_included
	FCNPC_GetPosition(npcid, X, Y, Z);
#else
	GetPlayerPos(npcid, X, Y, Z);
#endif
	for(new s; s < sizeof(StationInfo); s++)
	{
		if (GetDistanceFromPointToPoint(
			X, Y, Z, Arr3<StationInfo[s][stPos]>) < 100.0)
			return (s);
	}
	return (0);
}

static	UpdateStationTime(station, interval)
{
	new time, hour, minute, second;
	gettime(hour, minute, second);
	time = hour * 3600 + minute * 60 + second + interval;

	hour = time / 3600;
	minute = (time % 3600) / 60;
	if(hour > 23) hour -= 24;

	new string[128];
	format(string, sizeof(string),
		"%s\nСледующий поезд: [%02d:%02d]",
		StationInfo[station][stName], hour, minute);
	UpdateDynamic3DTextLabelText(RailStation3DText[station],
		STATION_3D_COLOR, string);
}
