#if !defined _job_core_included
	#endinput
#endif

#if defined	_job_part_loader_included
	#endinput
#endif
#define _job_part_loader_included

enum E_LOADER
{
	// Основное
	LE_STAGE,       // Сцена (0 - разгрузка вагона, 1 - загрузка машины, 2 - разгрузка машины)
	LE_TIME,		// Счетчик таймера (в секундах)
	LE_TIMER,       // Идентификатор таймера
	LE_AREAID,      // Идентификатор динамической зоны всего помещения
	LE_ZONE,		// зона ограничивающая рабочих

	// Вагон
	WAGON_ID,       // Идентификатор объекта вагона
	WAGON_BOX[90],  // Идентификатор ящиков (objectid)
	WAGON_AREAID,   // Идентификатор динамической зоны
	WAGON_OPEN,     // Статус доступности вагона (0 - приезжает, 1 - доступен, 2 - уезжает)
	WAGON_STATUS,   // Состояние вагона (0 - стоит открытый, 1 - закрылся, 2 - поехал, 3 - удалился, 4 - возвращается)
	WAGON_TIME,     // Счетчик времени

	// Стаки
	STACK_NUM,			// Номер активного стака
	STACK_AREAID[3],	// Идентификатор динамической зоны

	// Грузовики
	LE_VEH_ID[2],		// Идентфикатор транспорта грузовиков
	LE_VEH_AREAID[2],  	// Идентификатор динамической зоны
};

new LoaderInfo[E_LOADER],
	bool:LoaderStatus[MAX_PLAYERS],	// (0 - с пустыми руками, 1 - с ящиком в руках)
	LoaderTick[MAX_PLAYERS],		// Время подбора последнего ящика

	LoaderObject[MAX_PLAYERS];  	// Идентификатор подвижного ящика

static 
	LOADER_STACK_BOX[3][90],		// Идентификатор ящиков (под каждый стак)
	Float:LOADER_STACK_POS[90][4],	// Координаты ящиков текущего стака
	LOADER_VEH_BOX[2][45],			// Идентификатор ящиков (под каждое авто)
 
	LoaderBoxes[MAX_PLAYERS];   	// Счетчик перенесенных ящиков

Public: Loader_OnGameModeInit()
{
	new Float:coords[] = {2178.7563,-2249.0256,2135.7939,-2290.9390,2116.6306,-2272.1421,2158.7856,-2229.7563};
	LoaderInfo[LE_AREAID] = CreateDynamicPolygon(coords, 11.0, 23.0, sizeof(coords));
	LoaderInfo[WAGON_AREAID] = CreateDynamicSphere(2230.5857, -2283.5625, 13.6904, 2.0);
	LoaderInfo[STACK_AREAID][0] = CreateDynamicSphere(2135.6702,-2279.3044,16.8010, 5.0);
	LoaderInfo[STACK_AREAID][1] = CreateDynamicSphere(2131.2390,-2274.8533,16.8010, 5.0);
	LoaderInfo[STACK_AREAID][2] = CreateDynamicSphere(2126.6089,-2270.3579,16.8010, 5.0);
	new Float:coords1[] = {2157.9253, -2243.6799, 2163.5520, -2238.0776, 2165.7009, -2240.2346, 2160.0950, -2245.8391};
	LoaderInfo[LE_VEH_AREAID][0] = CreateDynamicPolygon(coords1, 12.0, 16.0, sizeof(coords1));
	new Float:coords2[] = {2161.2268, -2246.9819, 2166.8499, -2241.4058, 2168.9502, -2243.5112, 2163.3652, -2249.1355};
	LoaderInfo[LE_VEH_AREAID][1] = CreateDynamicPolygon(coords2, 12.0, 16.0, sizeof(coords2));

	LoaderInfo[LE_ZONE] = CreateDynamicRectangle(2104.5, -2345.5, 2258.5,	-2191.9, 0, 0);

	Loader_ChangeStage(-2);  //	Запускаем цикл подработки
	return CONTINUE;
}

Public: Loader_OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(areaid == LoaderInfo[LE_AREAID])
	{
	    if(GetPlayerState(playerid) == 2)
	    {
	        new vehicleid = GetPlayerVehicleID(playerid);
			MySetVehiclePos(vehicleid, 2185.4512,-2261.8936,12.9963, 225.0);
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_WARNING "Сюда запрещено заезжать на транспорте");
			SetCameraBehindPlayer(playerid);
	    }
		else if(mission_id[playerid] == MIS_START_WORK && !Job.GetPlayerNowWork(playerid))
		{
			new Float:PlayerCameraPos[3],
				Float:PlayerCameraVector[3];

			GetPlayerCameraPos(playerid, Arr3<PlayerCameraPos>);
			GetPlayerCameraFrontVector(playerid, Arr3<PlayerCameraVector>);
			PlayerCameraVector[0] = PlayerCameraPos[0] + floatmul(PlayerCameraVector[0], 5.0);
			PlayerCameraVector[1] = PlayerCameraPos[1] + floatmul(PlayerCameraVector[1], 5.0);
			PlayerCameraVector[2] = PlayerCameraPos[2] + floatmul(PlayerCameraVector[2], 5.0);

			InterpolateCameraPos(playerid, Arr3<PlayerCameraPos>, 2143.9578,-2272.7078,19.9885, 3000);
			InterpolateCameraLookAt(playerid, Arr3<PlayerCameraVector>, 2134.0881,-2277.4233,21.5105, 3000);
		    TogglePlayerControllable(playerid, false);
		    IFace.ToggleGroup(playerid, IFace.TV_EFFECT, true);
		    SetTimerEx("Loader_CameraRemove", 5000, false, "i", playerid);
	    }
	    return true;
	}
    else if(areaid == LoaderInfo[WAGON_AREAID])
    {
        if(!LoaderStatus[playerid] && LoaderInfo[LE_STAGE] == 0 && LoaderInfo[WAGON_OPEN] == 1)
			ShowPlayerHint(playerid, "Нажмите ~y~Alt~n~~w~чтобы взять ящик");
		return true;	
    }
    else if(areaid == LoaderInfo[STACK_AREAID][ LoaderInfo[STACK_NUM] ])
	{
        if(LoaderStatus[playerid] && LoaderInfo[LE_STAGE] == 0 && LoaderInfo[WAGON_OPEN] == 1)		// Относим ящик из вагоне
			ShowPlayerHint(playerid, "Нажмите ~y~Alt~n~~w~чтобы положить ящик");
        else if(!LoaderStatus[playerid] && LoaderInfo[LE_STAGE] == 1) // Берем ящик в грузовик
			ShowPlayerHint(playerid, "Нажмите ~y~Alt~n~~w~чтобы взять ящик");
		return true;
	}
	else if(areaid == LoaderInfo[LE_VEH_AREAID][0] || areaid == LoaderInfo[LE_VEH_AREAID][1])
	{
        if(LoaderStatus[playerid] && LoaderInfo[LE_STAGE] == 1) // Относим ящик в грузовик
			ShowPlayerHint(playerid, "Нажмите ~y~Alt~n~~w~чтобы положить ящик");
        else if(!LoaderStatus[playerid] && LoaderInfo[LE_STAGE] == 2) // Берем ящик из грузовика
			ShowPlayerHint(playerid, "Нажмите ~y~Alt~n~~w~чтобы взять ящик");
		return true;
	}
	return CONTINUE;
}

Public: Loader_OnDynamicObjectMoved(objectid)
{
	// Подработка грузчиком
	if(objectid == LoaderInfo[WAGON_ID] && LoaderInfo[LE_STAGE] == 0)
	{
	    if(LoaderInfo[WAGON_OPEN] == 0)
	    {
			DestroyDynamicObject(LoaderInfo[WAGON_ID]);
			LoaderInfo[WAGON_ID] = CreateDynamicObject(3585, 2231.53589, -2284.41650, 14.15630, 0.0, 0.0, 45.0); // Открытый
	        LoaderInfo[WAGON_OPEN] = 1;
			Loader_LoadWagon();
		}
		return 1;
	}
	foreach(Player, i)
	{
	    if(LoaderObject[i] == objectid)
	    {
		    DestroyDynamicObject(objectid);
		    LoaderObject[i] = 0;
		    return 1;
	    }
	}
	return CONTINUE;
}

Public: Loader_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(Job.GetPlayerNowWork(playerid) != PART_LOADER)
	{
		return CONTINUE;
	}

	if(PRESSED(KEY_WALK))
    {
    	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    	{
	        //--- Подбираем ---//
            if(!LoaderStatus[playerid])
            {
	            if(LoaderInfo[LE_STAGE] == 0 && LoaderInfo[WAGON_OPEN] == 1 && IsPlayerInRangeOfPoint(playerid, 4.0, 2231.4575,-2284.4902,14.3752))
	            {
	                new Float:pos[3], Float:mypos[4],
						Float:mindist, Float:dist,
						minbox = -1, count = 0;

					MyGetPlayerPos(playerid, Arr4<mypos>);
					mypos[0] += (0.3 * floatsin(-mypos[3], degrees));
					mypos[1] += (0.3 * floatcos(-mypos[3], degrees));
					for(new idx = 0; idx < sizeof(LoaderInfo[WAGON_BOX]); idx += 3)
					{
						if(LoaderInfo[WAGON_BOX][idx] == INVALID_STREAMER_ID)
						{
						    count++;
							continue;
						}
					    GetDynamicObjectPos(LoaderInfo[WAGON_BOX][idx], Arr3<pos>);
						dist = GetDistanceFromPointToPoint(Arr3<mypos>, Arr3<pos>);
						if(mindist == 0.0 || dist < mindist)
						{
						    mindist = dist;
						    minbox = idx;
						}
					}
					if(minbox == -1)	return ShowPlayerHint(playerid, "Не найдено ни одного ящика");
					if(mindist > 1.0)	return ShowPlayerHint(playerid, "Подойдите ближе к ящику");

			        if(CarryUP(playerid, 1271, 0.311, 0.579, 0.0, 0.0, 90.0, 0.0))
			        {
			        	if(minbox%3 == 0 && LoaderInfo[WAGON_BOX][minbox+1] != INVALID_STREAMER_ID) minbox += 1;
						if(minbox%3 == 1 && LoaderInfo[WAGON_BOX][minbox+1] != INVALID_STREAMER_ID) minbox += 1;
			        	
			        	LoaderStatus[playerid] = true;
				        LoaderTick[playerid] = GetTickCount();
				        DestroyDynamicObject(LoaderInfo[WAGON_BOX][minbox]);
						LoaderInfo[WAGON_BOX][minbox] = INVALID_STREAMER_ID;

						if(count == 29 && minbox%3 == 0)
						{// Последний ящик
						    LoaderInfo[WAGON_OPEN] = 2;
						    LoaderInfo[LE_TIME] = 45;
						    LoaderInfo[LE_TIMER] = SetTimer("Loader_Timer", 1000, true);
						    Loader_UpdateMission();
						}
						else Loader_UpdateMission(playerid);
			        }
	                return 1;
				}
				new stack = LoaderInfo[STACK_NUM];
				if(LoaderInfo[LE_STAGE] == 1 && IsPlayerInDynamicArea(playerid, LoaderInfo[STACK_AREAID][stack]))
				{
	                new count = 0, minbox = -1,
						Float:mypos[4], Float:mindist, Float:dist;

					MyGetPlayerPos(playerid, Arr4<mypos>);
					mypos[0] += (0.3 * floatsin(-mypos[3], degrees));
					mypos[1] += (0.3 * floatcos(-mypos[3], degrees));
					for(new idx = 0; idx < sizeof(LoaderInfo[WAGON_BOX]); idx += 3)
					{
						if(LOADER_STACK_BOX[stack][idx] == INVALID_STREAMER_ID)
						{
						    count++;
							continue;
						}
						dist = GetDistanceFromPointToPoint(Arr3<mypos>, Arr3<LOADER_STACK_POS[idx]>);
						if(mindist == 0.0 || dist < mindist)
						{
						    mindist = dist;
						    minbox = idx;
						}
					}
					if(minbox == -1)	return ShowPlayerHint(playerid, "Не найдено ни одного ящика");
					if(mindist > 1.0)	return ShowPlayerHint(playerid, "Подойдите ближе к ящику");

			        if(CarryUP(playerid, 1271, 0.311, 0.579, 0.0, 0.0, 90.0, 0.0))
			        {
			        	if(minbox%3 == 0 && LOADER_STACK_BOX[stack][minbox+1] != INVALID_STREAMER_ID) minbox += 1;
						if(minbox%3 == 1 && LOADER_STACK_BOX[stack][minbox+1] != INVALID_STREAMER_ID) minbox += 1;
			        
						LoaderStatus[playerid] = true;
				        LoaderTick[playerid] = GetTickCount();
				        DestroyDynamicObject(LOADER_STACK_BOX[stack][minbox]);
						LOADER_STACK_BOX[stack][minbox] = INVALID_STREAMER_ID;

						if(count == 29 && minbox%3 == 0)
						{// Последний ящик
						    LoaderInfo[LE_TIME] = 45;
						    LoaderInfo[LE_TIMER] = SetTimer("Loader_Timer", 1000, true);
						    Loader_UpdateMission();
						}
						else Loader_UpdateMission(playerid);
			        }
				    return 1;
				}
				if(LoaderInfo[LE_STAGE] == 2)
				{
				    new number;
				    if(IsPlayerInDynamicArea(playerid, LoaderInfo[LE_VEH_AREAID][0])) number = 0;
				    else if(IsPlayerInDynamicArea(playerid, LoaderInfo[LE_VEH_AREAID][1])) number = 1;
	                else return 1;

	                if(LOADER_VEH_BOX[number][0] == INVALID_STREAMER_ID) return 1;
					for(new idx = sizeof(LOADER_VEH_BOX[])-1; idx >= 0; idx--)
					{
						if(LOADER_VEH_BOX[number][idx] != INVALID_STREAMER_ID)
						{
					        DestroyDynamicObject(LOADER_VEH_BOX[number][idx]);
							LOADER_VEH_BOX[number][idx] = INVALID_STREAMER_ID;
						    break;
						}
					}

	                /*new count = 0, minbox = -1, Float:pos[3], Float:mypos[4], Float:vpos[3], Float:mindist, Float:dist;
					MyGetPlayerPos(playerid, Arr4<mypos>);
					GetVehiclePos(vehicleid, Arr3<vpos>);
					mypos[0] += (0.3 * floatsin(-mypos[3], degrees));
					mypos[1] += (0.3 * floatcos(-mypos[3], degrees));
					for(new idx = 0; idx < sizeof(LOADER_VEH_BOX[]); idx++)
					{
						if(LOADER_VEH_BOX[number][idx] == INVALID_STREAMER_ID)
						{
						    count++;
							continue;
						}
					    GetDynamicObjectPos(LOADER_VEH_BOX[number][idx], Arr3<pos>);
						dist = GetDistanceFromPointToPoint(Arr3<mypos>, pos[0]+vpos[0], pos[1]+vpos[1], pos[2]+vpos[2]);
						if(mindist == 0.0 || dist < mindist)
						{
						    mindist = dist;
						    minbox = idx;
						}
					}
					if(minbox == -1) return ShowPlayerHint(playerid, "Не найдено ни одного ящика");
					if(mindist > 2.0) return ShowPlayerHint(playerid, "Подойдите ближе к ящику");
			        DestroyDynamicObject(LOADER_VEH_BOX[number][minbox]);
					LOADER_VEH_BOX[number][minbox] = INVALID_STREAMER_ID;*/

			        if(CarryUP(playerid, 1271, 0.311, 0.579, 0.0, 0.0, 90.0, 0.0))
			        {
			        	LoaderStatus[playerid] = true;
				        LoaderTick[playerid] = GetTickCount();

						//if(count == 44)
						if(LOADER_VEH_BOX[0][0] == INVALID_STREAMER_ID && LOADER_VEH_BOX[1][0] == INVALID_STREAMER_ID)
						{// Последний ящик
						    LoaderInfo[LE_TIME] = 30;
						    LoaderInfo[LE_TIMER] = SetTimer("Loader_Timer", 1000, true);
						    Loader_UpdateMission();
						}
						else Loader_UpdateMission(playerid);
			        }
				    return 1;
				}
            }
            //--- Кладем ---//
            else if(LoaderStatus[playerid])
            {
                new stack = LoaderInfo[STACK_NUM];
                if(LoaderInfo[LE_STAGE] == 0 && IsPlayerInDynamicArea(playerid, LoaderInfo[STACK_AREAID][stack]))
                {
					for(new idx = 0; idx < sizeof(LoaderInfo[WAGON_BOX]); idx++)
					{
						if(LOADER_STACK_BOX[stack][idx] == INVALID_STREAMER_ID)
						{
						    LOADER_STACK_BOX[stack][idx] = CreateDynamicObject(1271, Arr3<LOADER_STACK_POS[idx]>, 0.0, 0.0, LOADER_STACK_POS[idx][3]);
						    LoaderStatus[playerid] = false;
							Loader_GiveMoney(playerid, 6);
						    CarryDown(playerid);
							Loader_UpdateMission(playerid);
						    return 1;
						}
					}
                }
                else if(LoaderInfo[LE_STAGE] == 1)
                {
				    new number;
				    if(IsPlayerInDynamicArea(playerid, LoaderInfo[LE_VEH_AREAID][0])) number = 0;
				    else if(IsPlayerInDynamicArea(playerid, LoaderInfo[LE_VEH_AREAID][1])) number = 1;
	                else return 1;

	                if(LOADER_VEH_BOX[number][44] != INVALID_STREAMER_ID)
					{
					    ShowPlayerHint(playerid, "Этот грузовик заполнен");
						return 1;
					}
					for(new idx = 0; idx < sizeof(LOADER_VEH_BOX[]); idx++)
					{
						if(LOADER_VEH_BOX[number][idx] == INVALID_STREAMER_ID)
						{
						    Loader_LoadVeh(number, idx);
						    LoaderStatus[playerid] = false;
						    Loader_GiveMoney(playerid, 3);
						    CarryDown(playerid);
							Loader_UpdateMission(playerid);
						    return 1;
						}
					}
                }
                return 1;
            }
	    }
    }

    return CONTINUE;
}

////////////////////////////////////////
Public: Loader_CameraRemove(playerid)
{
	TogglePlayerControllable(playerid, true);
	IFace.ToggleGroup(playerid, IFace.TV_EFFECT, false);
	SetCameraBehindPlayer(playerid);
}

Public: Loader_Timer()
{
	new string[64];
	switch(LoaderInfo[LE_STAGE])
	{
	    case 0://
	    {
	        LoaderInfo[LE_TIME]--;
            if(LoaderInfo[LE_TIME] == 40)
            {
	            // Выгоняем игроков из вагона
	            new Float:X, Float:Y, Float:Z;
	            foreach(LoginPlayer, i)
	            {
					if(IsPlayerInRangeOfPoint(i, 4.0, 2231.5359, -2284.4165, 14.1563))
	                {
		                GetPlayerPos(i, X, Y, Z);
		                MySetPlayerPos(i, X - 6.0, Y - 6.0, Z);
                 	}
	            }

	            // Отправляем вагончик
				DestroyDynamicObject(LoaderInfo[WAGON_ID]);
				LoaderInfo[WAGON_ID] = CreateDynamicObject(3564, 2231.53589, -2284.41650, 14.15630, 0.0, 0.0, 45.0);
				MoveDynamicObject(LoaderInfo[WAGON_ID], 2300.08936, -2215.77734, 14.15, 5.0);
	        }
	        else if(LoaderInfo[LE_TIME] <= 0)
	        {
	            KillTimer(LoaderInfo[LE_TIMER]);
	            LoaderInfo[LE_TIME] = 0;
	            LoaderInfo[LE_TIMER] = 0;

				// Доносим ящики
	            foreach(LoginPlayer, i)
	            {
	                if(LoaderStatus[i])
	                {
					    LoaderStatus[i] = false;
					    _CarryDown(i);
	                }
	            }
	            new number = LoaderInfo[STACK_NUM];
				Loader_DestroyStack(number);
				for(new idx = 0; idx < sizeof(LoaderInfo[WAGON_BOX]); idx++)
				{
				    LOADER_STACK_BOX[number][idx] = CreateDynamicObject(1271, Arr3<LOADER_STACK_POS[idx]>, 0.0, 0.0, LOADER_STACK_POS[idx][3]);
				}

	            Loader_ChangeStage();
	            return 1;
	        }
	        format(string, sizeof(string), "~n~~r~Скорее относите ящик! Осталось: ~w~00:%02d", LoaderInfo[LE_TIME]);
            foreach(LoginPlayer, i) { if(LoaderStatus[i]) SendMissionMessage(i, string); }

	    }
	    case 1://
	    {
	        LoaderInfo[LE_TIME]--;
	        if(LoaderInfo[LE_TIME] > 15)
			{
		        format(string, sizeof(string), "~n~~r~Скорее относите ящик! Осталось: ~w~00:%02d", LoaderInfo[LE_TIME]-15);
	            foreach(LoginPlayer, i) { if(LoaderStatus[i]) SendMissionMessage(i, string); }
	        }
	        else if(LoaderInfo[LE_TIME] == 15)
	        {
	            foreach(LoginPlayer, i)
	            {
	                if(LoaderStatus[i])
	                {
					    LoaderStatus[i] = false;
					    _CarryDown(i);
	                }
	            }
	            Loader_UpdateMission();
	        }
	        else if(LoaderInfo[LE_TIME] == 10)
	        {
		        Loader_UnloadVeh();
	            MyDestroyVehicle(LoaderInfo[LE_VEH_ID][0]), LoaderInfo[LE_VEH_ID][0] = 0;
	            MyDestroyVehicle(LoaderInfo[LE_VEH_ID][1]), LoaderInfo[LE_VEH_ID][1] = 0;
	        }
	        else if(LoaderInfo[LE_TIME] <= 0)
	        {
	            KillTimer(LoaderInfo[LE_TIMER]);
	            LoaderInfo[LE_TIME] = 0;
	            LoaderInfo[LE_TIMER] = 0;
	            Loader_ChangeStage();
	        }
	    }
	    case 2://
	    {
	        LoaderInfo[LE_TIME]--;
            if(LoaderInfo[LE_TIME] == 25)
            {
				MyDestroyVehicle(LoaderInfo[LE_VEH_ID][0]), LoaderInfo[LE_VEH_ID][0] = 0;
				MyDestroyVehicle(LoaderInfo[LE_VEH_ID][1]), LoaderInfo[LE_VEH_ID][1] = 0;
	        }
	        else if(LoaderInfo[LE_TIME] <= 0)
	        {
	            KillTimer(LoaderInfo[LE_TIMER]);
	            LoaderInfo[LE_TIME] = 0;
	            LoaderInfo[LE_TIMER] = 0;
	            foreach(LoginPlayer, i)
	            {
	                if(LoaderStatus[i])
	                {
					    LoaderStatus[i] = false;
					    _CarryDown(i);
	                }
	            }
	            Loader_ChangeStage();
	            return 1;
	        }
	        format(string, sizeof(string), "~n~~r~Скорее относите ящик! Осталось: ~w~00:%02d", LoaderInfo[LE_TIME]);
            foreach(LoginPlayer, i) { if(LoaderStatus[i]) SendMissionMessage(i, string); }
	    }
	}
	return 1;
}

static Loader_ChangeStage(stageid = -1)
{// Изменение сцены подработки

    new freestack = 0; // Количество пустых стаков
    for(new i; i < 3; i++) 
    { 
    	if(LOADER_STACK_BOX[i][0] == INVALID_STREAMER_ID) freestack++; 
    }

    // Случайный выбор эпизода (включая создание стака)
	if(stageid == -2)
	{
	    stageid = random(3);
	    if(stageid == 0)
		{
		    new stack = random(3);
			Loader_DestroyStack(stack);
			Loader_LoadStack(stack);
		}
	    if(stageid == 1) Loader_LoadStack(random(3), true);
	}
	// Случайный выбор эпизода
	else if(stageid == -1)
    {
	    new count, availablearr[3] = {0, 0, 1};
	    if(freestack > 0) availablearr[0] = 1; // Если есть свободные стаки
	    if(freestack < 3) availablearr[1] = 1; // Если есть занятые стаки
	    for(new i; i < 3; i++) { if(availablearr[i] == 1) count++; }

	    new idx, rand = random(count);
	    for(new i; i < 3; i++)
	    {
		    if(availablearr[i] == 0) continue;
		    if(idx++ == rand)
		    {
		        Loader_ChangeStage(i);
		        break;
		    }
	    }
	    return 1;
	}
	// Выбор пустого стака
	else if(0 <= stageid <= 1)
	{
	    if(stageid == 0 && freestack == 0)
	    {	// Намеренное удаление стака
		    new stack = random(3);
			Loader_DestroyStack(stack);
			Loader_LoadStack(stack);
	    }
	    else if(stageid == 1 && freestack == 3)
		{	// Намеренное создание стака
		    Loader_LoadStack(random(3), true);
		}
		else
		{
			if(stageid == 1) freestack = 3 - freestack; // Для первого эпизода нужны пустые, для второго заполненные
		    new number = random(freestack);
		    for(new idx, i; i < 3; i++)
		    {
			    if((stageid == 0 && LOADER_STACK_BOX[i][0] != INVALID_STREAMER_ID)
				|| (stageid == 1 && LOADER_STACK_BOX[i][0] == INVALID_STREAMER_ID)) continue;
			    if(idx++ == number)
			    {
			        Loader_LoadStack(i);
			        break;
			    }
		    }
	    }
    }

	// Обнуление данных и объектов
	Loader_UnloadWagon();
	Loader_UnloadVeh();
	DestroyDynamicObject(LoaderInfo[WAGON_ID]);
	if(LoaderInfo[LE_VEH_ID][0]) MyDestroyVehicle(LoaderInfo[LE_VEH_ID][0]), LoaderInfo[LE_VEH_ID][0] = 0;
	if(LoaderInfo[LE_VEH_ID][1]) MyDestroyVehicle(LoaderInfo[LE_VEH_ID][1]), LoaderInfo[LE_VEH_ID][1] = 0;
	if(LoaderInfo[LE_TIMER]) KillTimer(LoaderInfo[LE_TIMER]), LoaderInfo[LE_TIMER] = 0, LoaderInfo[LE_TIME] = 0;
    foreach(LoginPlayer, i)
    {
    	if(LoaderStatus[i])
    	{
    		LoaderStatus[i] = false;
    		_CarryDown(i);
    	}
    }

	// Создание эпизода
 	switch(stageid)
	{
	    case 0://
	    {
		    LoaderInfo[WAGON_OPEN] = 0;
			LoaderInfo[WAGON_ID] = CreateDynamicObject(3564, 2300.08936, -2215.77734, 14.15, 0.0, 0.0, 45.0); // Закрытый
			MoveDynamicObject(LoaderInfo[WAGON_ID], 2231.53589, -2284.41650, 14.15630, 5.0);
	    }
	    case 1://
	    {
			LoaderInfo[LE_VEH_ID][0] = MyCreateVehicle(578, 2162.9758, -2240.7935, 13.92, 315.0, 10, 1);
			LoaderInfo[LE_VEH_ID][1] = MyCreateVehicle(578, 2166.2632, -2244.1001, 13.92, 315.0, 10, 1);
			VehInfo[LoaderInfo[LE_VEH_ID][0]][vLocked] = 999, VehInfo[LoaderInfo[LE_VEH_ID][0]][vBlockMove] = true, UpdateVehicleParamsEx(LoaderInfo[LE_VEH_ID][0]);
			VehInfo[LoaderInfo[LE_VEH_ID][1]][vLocked] = 999, VehInfo[LoaderInfo[LE_VEH_ID][1]][vBlockMove] = true, UpdateVehicleParamsEx(LoaderInfo[LE_VEH_ID][1]);
	    }
	    case 2://
	    {
			LoaderInfo[LE_VEH_ID][0] = MyCreateVehicle(578, 2162.9758, -2240.7935, 13.92, 315.0, 10, 1);
			LoaderInfo[LE_VEH_ID][1] = MyCreateVehicle(578, 2166.2632, -2244.1001, 13.92, 315.0, 10, 1);
			VehInfo[LoaderInfo[LE_VEH_ID][0]][vLocked] = 999, UpdateVehicleParamsEx(LoaderInfo[LE_VEH_ID][0]);
			VehInfo[LoaderInfo[LE_VEH_ID][1]][vLocked] = 999, UpdateVehicleParamsEx(LoaderInfo[LE_VEH_ID][1]);
			for(new idx = 0; idx < sizeof(LOADER_VEH_BOX[]); idx++)
			{
				Loader_LoadVeh(0, idx);
				Loader_LoadVeh(1, idx);
			}
	    }
	    default: return 1;
	}
	LoaderInfo[LE_STAGE] = stageid;
	Loader_UpdateMission();
	return 1;
}

Loader_UpdateMission(playerid = -1)
{
	// Для всех игроков
	if(playerid == -1)
	{
	    foreach(LoginPlayer, i)
	    {
	        if(Job.GetPlayerNowWork(i)) Loader_UpdateMission(i);
	    }
	    return 1;
	}

	// Для конкретного игрока
	MyDisablePlayerCheckpoint(playerid);
    if(LoaderInfo[LE_TIME] > 0 && !LoaderStatus[playerid])
    {
        SendMissionMessage(playerid, "~n~Ожидайте нового задания.", 0);
        return 1;
    }
	switch(LoaderInfo[LE_STAGE])
	{
	    case 0://
	    {
	        /*if(LoaderInfo[WAGON_OPEN] == 2)
	        {
	            SendMissionMessage(playerid, "~n~Ожидайте нового задания.", 0);
	        }*/
	        if(!LoaderStatus[playerid])
	        {
		        MySetPlayerCheckpoint(playerid, CPMODE_NONE, 2230.10, -2283.09, 14.39, 1.4);
		        SendMissionMessage(playerid, "~n~Отправляйтесь на ~r~маркер ~w~разгружать вагон.", 10000);
	        }
	        else
	        {
                switch(LoaderInfo[STACK_NUM])
                {
		        	case 0: MySetPlayerCheckpoint(playerid, CPMODE_NONE, 2137.54, -2277.52, 14.78, 1.8);
		        	case 1: MySetPlayerCheckpoint(playerid, CPMODE_NONE, 2133.06, -2273.06, 14.78, 1.8);
		        	case 2: MySetPlayerCheckpoint(playerid, CPMODE_NONE, 2128.64, -2268.50, 14.78, 1.8);
		        }
		        SendMissionMessage(playerid, "~n~Отнесите ящик на ~r~склад ~w~и положите его там.", 5000);
	        }
	    }
	    case 1:
	    {
	        if(!LoaderStatus[playerid])
	        {
                switch(LoaderInfo[STACK_NUM])
                {
		        	case 0: MySetPlayerCheckpoint(playerid, CPMODE_NONE, 2137.54, -2277.52, 14.78, 1.8);
		        	case 1: MySetPlayerCheckpoint(playerid, CPMODE_NONE, 2133.06, -2273.06, 14.78, 1.8);
		        	case 2: MySetPlayerCheckpoint(playerid, CPMODE_NONE, 2128.64, -2268.50, 14.78, 1.8);
		        }
		        SendMissionMessage(playerid, "~n~Отправляйтесь на ~r~склад ~w~и заберите ящик.", 10000);
	        }
	        else
	        {
		        MySetPlayerCheckpoint(playerid, CPMODE_NONE, 2157.44, -2249.62, 15.48, 3.0);
		        SendMissionMessage(playerid, "~n~Отправляйтесь к ~r~грузовикам ~w~и погрузите ящик.", 10000);
	        }
	    }
	    case 2:
	    {
	        if(!LoaderStatus[playerid])
	        {
		        MySetPlayerCheckpoint(playerid, CPMODE_NONE, 2157.44, -2249.62, 15.48, 3.0);
		        SendMissionMessage(playerid, "~n~Отправляйтесь к ~r~грузовикам ~w~и возьмите ящик.", 10000);
	        }
	        else
	        {
		        MySetPlayerCheckpoint(playerid, CPJOB_LOADER, 2144.2974,-2265.5088,13.2955, 0.8);
		        SendMissionMessage(playerid, "~n~Отнесите ящик на ~r~ленту~w~ и положите его.", 10000);
	        }
	    }
	}
	PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
	return 1;
}

stock Loader_FinishWork(playerid)
{
	_CarryDown(playerid);
   	LoaderStatus[playerid] = false;
   	LoaderBoxes[playerid] = 0;
   	DestroyDynamicObject(LoaderObject[playerid]), LoaderObject[playerid] = INVALID_STREAMER_ID;
}

Loader_GiveMoney(playerid, money)
{
	new string[32], bonus = 0;
	if(++LoaderBoxes[playerid] % 5 == 0) bonus = money;
	Job.GivePlayerPartWage(playerid, float(money + bonus));

	format(string, sizeof(string), "~g~+%d$ %s", money + bonus, (bonus > 0) ? ("~y~(+ bonus)") : "~w~");
    GameTextForPlayer(playerid, string, 3000, 4);
	ShowWorkInfo(playerid, "Ящиков", LoaderBoxes[playerid], "Заработок", Job.GetPlayerPartWage(playerid), 2912);
}

static Loader_LoadWagon()
{
	new idx = 0, Float:epsx, Float:epsy, Float:epsa,
		Float:StartX = 2233.2, Float:dX = 0.5,
		Float:StartY = -2281.7,
		Float:StartZ = 13.72, Float:dZ = 0.68;

	for(new j = 0; j < 3; j++) // Длина
	{
		for(new i = 0; i < 10; i++) // Ширина
		{
			for(new k = 0; k < 3; k++) // Высота
			{
			    epsx = float(random(201) - 100)/10000;
			    epsy = float(random(201) - 100)/10000;
			    epsa = float(random(31) - 15)/10;
			    LoaderInfo[WAGON_BOX][idx++] = CreateDynamicObject(1271, StartX - dX * i + epsx, StartY - dX * i + epsy, StartZ + dZ * k, 0.0, 0.0, 45.0 + epsa);
			}
		}
	    StartX += dX; StartY -= dX;
	}
}

static Loader_UnloadWagon()
{
	for(new idx = 0; idx < sizeof(LoaderInfo[WAGON_BOX]); idx++)
	{
		DestroyDynamicObject(LoaderInfo[WAGON_BOX][idx]);
		LoaderInfo[WAGON_BOX][idx] = INVALID_STREAMER_ID;
	}
}

static Loader_LoadStack(number, create = false)
{
	new idx = 0, Float:epsx, Float:epsy, Float:epsa,
		Float:StartX, Float:StartY, Float:dX = 0.56,
		Float:StartZ = 14.10, Float:dZ = 0.68;

	switch(number)
	{
	    case 0: { StartX = 2135.9944; StartY = -2281.9067; }
	    case 1: { StartX = 2131.5454; StartY = -2277.4302; }
	    case 2: { StartX = 2127.0652; StartY = -2272.9495; }
	    default: return 0;
	}

	if(create) Loader_DestroyStack(number);
	for(new j = 0; j < 5; j++) // Длина
	{
		for(new i = 0; i < 6; i++) // Ширина
		{
			for(new k = 0; k < 3; k++) // Высота
			{
			    epsx = float(random(401) - 200)/10000;
			    epsy = float(random(401) - 200)/10000;
			    epsa = float(random(51) - 25)/10;
			    LOADER_STACK_POS[idx][0] = StartX - dX * i + epsx;
				LOADER_STACK_POS[idx][1] = StartY + dX * i + epsy;
				LOADER_STACK_POS[idx][2] = StartZ + dZ * k;
				LOADER_STACK_POS[idx][3] = 45.0 + epsa;
				if(create) LOADER_STACK_BOX[number][idx] = CreateDynamicObject(1271, Arr3<LOADER_STACK_POS[idx]>, 0.0, 0.0, LOADER_STACK_POS[idx][3]);
				idx++;
			}
		}
	    StartX += dX; StartY += dX;
	}
	LoaderInfo[STACK_NUM] = number;
	return 1;
}

static Loader_DestroyStack(number)
{
	for(new idx = 0; idx < sizeof(LoaderInfo[WAGON_BOX]); idx++)
	{
		DestroyDynamicObject(LOADER_STACK_BOX[number][idx]);
		LOADER_STACK_BOX[number][idx] = INVALID_STREAMER_ID;
	}
}

static Loader_LoadVeh(number, idx)
{
	if(number < 0 || number > 1) return 1;

	new j = idx / 5, //for(new j = 0; j < 9; j++) // Длина
		i = idx % 5, //for(new i = 0; i < 5; i++) // Ширина
    	Float:epsx = float(random(401) - 200)/10000,
    	Float:epsy = float(random(401) - 200)/10000,
    	Float:epsa = float(random(41) - 20)/10;

    LOADER_VEH_BOX[number][idx] = CreateDynamicObject(1271, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	if(i < 3)	AttachDynamicObjectToVehicle(LOADER_VEH_BOX[number][idx], LoaderInfo[LE_VEH_ID][number], -0.75 + 0.76 * i + epsx, 1.8 - 0.76 * j + epsy, 0.08, 0.0, 0.0, 0.0 + epsa);
	else        AttachDynamicObjectToVehicle(LOADER_VEH_BOX[number][idx], LoaderInfo[LE_VEH_ID][number], -0.75 + (0.5 + i - 3) * 0.76 + epsx, 1.8 - 0.76 * j + epsy, 0.76, 0.0, 0.0, 0.0 + epsa);
	return 1;
}

static Loader_UnloadVeh()
{
	for(new i = 0; i < 2; i++)
	{
		for(new idx = 0; idx < 45; idx++)
		{
			DestroyDynamicObject(LOADER_VEH_BOX[i][idx]);
			LOADER_VEH_BOX[i][idx] = INVALID_STREAMER_ID;
		}
	}
}

//////////	Dialogs 	//////////
DialogCreate:Loader_Main(playerid)
{
    if(Job.GetPlayerNowWork(playerid) != PART_LOADER)
    {
    	PlayAudioStreamForPlayer(playerid, AUDIOFILE_PATH "/derek1.mp3");
    	new string[] = "{FFFFFF}Здесь ты можешь поработать "MAIN_COLOR"Грузчиком{FFFFFF}\n\
	    				На наш склад постоянно приезжают множество вагонов и фургонов\n\
	    				Поэтому тебе потребуется таскать ящики из разных мест\n\
						За каждый 5-ый ящик ты будешь получать небольшую премию.\n\n\
	    				"MAIN_COLOR"Готов приступить?";
		Dialog_Open(playerid, Dialog:Loader_Main, DIALOG_STYLE_MSGBOX, "Derek говорит:", string, "Да", "Нет");
	}
	else
	{
		Dialog_Open(playerid, Dialog:Loader_Main, DIALOG_STYLE_MSGBOX, "Derek говорит:", ""MAIN_COLOR"Ты уже все на сегодня?", "Да", "Нет");
	}
	return true;
}

DialogResponse:Loader_Main(playerid, response, listitem, inputtext[])
{
    gPickupTime[playerid] = 3;
    if(response)
    {
	    if(Job.GetPlayerNowWork(playerid) != PART_LOADER)
	    {// Начать работы
	        if(Job.SetPlayerNowWork(playerid, PART_LOADER))
	        {
	        	new const skin[] = {16, 27, 260};
			    MySetPlayerSkin(playerid, skin[random(sizeof(skin))], false);
			    Loader_UpdateMission(playerid);
		        SendLocalMessage(ACTOR[A_DEREK], playerid, "Приступай, и следи за обновлениями заданий!", false);
		        ShowWorkInfo(playerid, "Ящиков", 0, "Заработок", 0, 2912);
	        }
	    }
	    else
	    {// Закончить работу
			CarryClear(playerid);
		    //ReloadPlayerSkin(playerid);
		    MyDisablePlayerCheckpoint(playerid);
		    HideMissionMessage(playerid);
		    if(Job.GetPlayerPartWage(playerid) == 0)		PlayAudioStreamForPlayer(playerid, AUDIOFILE_PATH "/derek3.mp3");
		    else if(Job.GetPlayerPartWage(playerid) > 150)	PlayAudioStreamForPlayer(playerid, AUDIOFILE_PATH "/derek2.mp3");
		    else 											PlayAudioStreamForPlayer(playerid, AUDIOFILE_PATH "/derek4.mp3");
		    Job.ClearPlayerNowWork(playerid);
	    }
    }	
	return true;
}

//////////	Commands	//////////
flags:loader(CMD_DEVELOPER);
CMD:loader(playerid, params[])
{// [BT]
    new status;
	if(sscanf(params, "i", status))
	    return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /loader [status (-2,-1 random, 0 - wagon unload, 1 - truck load, 2 - truck unload)]");
	if(status < -2 || status > 2)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вводите статус от -2 до 2.");
	Loader_ChangeStage(status);
	return 1;
}

/*flags:loadstack(CMD_DEVELOPER);
CMD:loadstack(playerid, params[])
{// [BT]
    new number, status;
	if(sscanf(params, "ii", number, status))
	    return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /loadstack [number (0-2)] [status]");
	if(number < 0 || number > 2)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Такого номера не существует");

	if(status) Loader_LoadStack(number, true);
	else Loader_DestroyStack(number);
	return 1;
}*/