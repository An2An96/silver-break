#include <a_npc>

public OnNPCSpawn()
{
	printf( "Train NPC Spawned!", npcid );
	return true;
}

public OnRecordingPlaybackEnd()
{
    new string[128];
	for(new train = 0; train < sizeof(TrainInfo); train++)
	{
	    new npc = TrainInfo[train][trNPC];
		if(npcid == NPC_ID[npc])
		{
		    TrainInfo[train][trPlayback]++;
			new station = GetTrainStation(NPC_ID[npc]);
	   		format(string, 128, "[Railway Station]: Поезд прибыл на станцию, остановка: %d сек.", StationInfo[station][stStop]);
			for(new pid, i; pid < MaxPlayerID; pid++)
			{
			    i = PLIDs[pid];
			    if(IsPlayerInRangeOfPoint(i, 50.0, StationInfo[station][stPos][0], StationInfo[station][stPos][1], StationInfo[station][stPos][2]))
			        SendClientMessage(i, COLOR_LIGHTBLUE, string);
			}
			if(TrainInfo[train][trPlayback] == TrainInfo[train][trAllStations])
			{// Проверка для начала нового цикла
				new finished;
				for(new t; t < sizeof(TrainInfo); t++)
				    if(TrainInfo[t][trPlayback] == TrainInfo[t][trAllStations])
				        finished++;
				if(finished == sizeof(TrainInfo))
				{
					SetTimer("StartTrainCycle", StationInfo[station][stStop]*1000, false);
				}
			}
			else
			{
			    if(npc == NPC_TrainDriver3) SetTimerEx("NextTrainPlayback", 60000, 0, "d", 2);
			    else SetTimerEx("NextTrainPlayback", StationInfo[station][stStop]*1000, 0, "d", train);

			    if(npc == NPC_TrainDriver1) UpdateStationTime(station, 800);
			    else if(npc == NPC_TrainDriver2) UpdateStationTime(station, 300);
			}
	    }
	}
	return true;
}

public OnNPCExitVehicle()
{
	print( "Train NPC exit train" );
	return true;
}

UpdateStationTime(station, interval)
{
	new string[128];
	new hour, minute, second;
	gettime(hour, minute, second);
	new time = hour*3600+minute*60+second+interval;
	hour = time/3600;
	minute = (time%3600)/60;
	format(string, 128, "%s\nСледующий поезд: [%02d:%02d]", StationInfo[station][stName], hour, minute);
	UpdateDynamic3DTextLabelText(RailStation3DText[station], 0x33CCFFFF, string);
}

Public: StartTrainCycle()
{
	//print("[TRAIN]: Starting train cycle...");
	for(new train; train < sizeof(TrainInfo); train++)
	{
	    TrainInfo[train][trPlayback] = 0;
		NextTrainPlayback(train);
	}
	new interval = 0;
	for(new s; s < sizeof(StationInfo); s++)
	{
	    if(s != 0) interval += StationInfo[s][stStop];
		interval += StationInfo[s][stInterval];
		UpdateStationTime(s, interval);
	}
	return 1;
}

Public: NextTrainPlayback(train)
{
    new string[64], npc = TrainInfo[train][trNPC];
	if(TrainInfo[train][trPlayback] <= TrainInfo[train][trAllStations])
	{
		format(string, 64, "train_%d_%d", train+1, TrainInfo[train][trPlayback]);
		if(FCNPC_StartRecordingPlayback(NPC_ID[npc], string))
		{
		    //printf("[TRAIN]: TrainDriver%d start record (%s)", npc, string);
		}
		else
		    printf("ERROR! TrainDriver%d error start record (%s)", npc, string);
		return 1;
	}
	return 1;
}

GetTrainStation(npcid)
{
	new Float:X, Float:Y, Float:Z;
	FCNPC_GetPosition(npcid, X, Y, Z);
	for(new Float:Dist, s; s < sizeof(StationInfo); s++)
	{
	    Dist = floatsqroot((X - StationInfo[s][stPos][0]) * (X - StationInfo[s][stPos][0]) + (Y - StationInfo[s][stPos][1]) * (Y - StationInfo[s][stPos][1]) + (Z - StationInfo[s][stPos][2]) * (Z - StationInfo[s][stPos][2]));
	    if(Dist < 100.0) return s;
	}
	return 0;
}
