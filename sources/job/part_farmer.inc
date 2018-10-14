#if !defined _job_core_included
	#endinput
#endif

#if defined	_job_part_farmer_included
	#endinput
#endif
#define _job_part_farmer_included

#define MAX_GRASS   			256		//  максимум травы на поле фермы
#define MAX_VEHICLE_GRASS   	8   	//  кол-во травы в кузове пикапа
#define FARM_GRASS_OBJECT		2901
#define PRICE_FARMER 			6.0 	// Стоимость легального тюка у фермера

enum
{
	FSTATUS_PLANTED,	//	Засеивается
	FSTATUS_GROWTH,		//	Растет
	FSTATUS_GATHER,		//	Собирается
}

enum FZ_ENUM
{
	Float:fzPos[4],
	Float:fzStock[3],
	Float:fzStep,
	fzHeight,
	fzWidth
}
new Float:FarmZones[][FZ_ENUM] =
{
	// Point pos, step, height, width
	//{ {-118.3, 61.8, 3.1172, 340.0},	{ -90.84, -10.19, 3.10 },	11.0, 15, 11 }
	{ { -1100.0, -1220.0, 129.22, 270.0}, { -1060.82, -1205.40, 129.38 },	9.0, 12, 6 }
		//-1110

	//{ {-329.0, -1428.0, 15.1096, 271.0},	10.0, 14, 11 },
	//{ {-279.0, -1004.4, 40.58, 226.0},		7.7, 11, 8 }
};
new Float:FarmGrassPos[ sizeof(FarmZones) ][MAX_GRASS][3];	//  для хранения точек травы на поле фермы
new FarmGrassArea[ sizeof(FarmZones) ][MAX_GRASS];
new FarmGrassStatus[ sizeof(FarmZones) ][MAX_GRASS];		//	для хранения статуса точки
new FarmGrassObjects[ sizeof(FarmZones) ][MAX_GRASS];		//  сохранение идов объектов травы на поле фермы
new Text3D:Farm3DInfo[ sizeof(FarmZones) ];					//  3д тексты с информацией о статусе фермы

enum farmData
{
	fStatus,	//	статус поля
	fMaxCount,	//  кол-во растений на поле (расчитывается при запуске мода относительно размеров поля)
	fCount,		//  кол-во обработаных растений на текущем шаге
	fHarvest,	//  кол-во собраного урожая
	fPickup 	//	пикап фермы
}
new FarmInfo[ sizeof FarmZones ][farmData];
new FarmZone;	//	зона ограничивающая рабочих

new FarmPlayer[MAX_PLAYERS],    			//  ид фермы на которой в данный момент РАБОТАЕТ игрок
	g_FarmSpeedLimiter[MAX_PLAYERS],        //  указатель на таймер ограничителя скорости
	g_FarmPlayerGrass[MAX_PLAYERS char],    //  есть у игрока в руках трава или нет (0 - нет, 1 - обычная)
	g_FarmVehiclePoint[MAX_PLAYERS],        //  указатель на динамическую точку возле кузова пикапа
	g_FarmPlayerVID[MAX_PLAYERS];           //  ид автомобиля пикапа игрока

new g_FarmVehicleGrass[MAX_VEHICLES],       //  кол-во травы в кузове
	g_FarmVGrassObjects[MAX_VEHICLES][MAX_VEHICLE_GRASS];			//  иды объектов травы в кузове

static FarmPickup;


Public: Farmer_OnGameModeInit()
{
	//	Расчет позиций растений на поле фермы
	new bool:front = false;
	new Float:curx, Float:cury, Float:Z, Float:A;
	for(new farmid = 0; farmid < sizeof(FarmZones); farmid++)
	{
		curx = FarmZones[farmid][fzPos][0];
		cury = FarmZones[farmid][fzPos][1];
		Z = FarmZones[farmid][fzPos][2];
		A = FarmZones[farmid][fzPos][3];
		for(new j; j < FarmZones[farmid][fzWidth]; j++)
		{
		    // Двигаемся рядом
			curx += (FarmZones[farmid][fzStep] * floatsin(-A-90, degrees));
			cury += (FarmZones[farmid][fzStep] * floatcos(-A-90, degrees));

		    // Двигаемся вперед
		    for(new i; i < FarmZones[farmid][fzHeight]; i++)
		    {
		        if(j == 0 || i != 0)
		        {
			        if(front)
			        {
						curx += (FarmZones[farmid][fzStep] * floatsin(-A, degrees));
						cury += (FarmZones[farmid][fzStep] * floatcos(-A, degrees));
					}
					else
					{
						curx -= (FarmZones[farmid][fzStep] * floatsin(-A, degrees));
						cury -= (FarmZones[farmid][fzStep] * floatcos(-A, degrees));
					}
				}
				MapAndreas_FindAverageZ(curx, cury, Z);
		       	FarmGrassPos[farmid][ FarmInfo[farmid][fMaxCount] ][0] = curx;
		       	FarmGrassPos[farmid][ FarmInfo[farmid][fMaxCount] ][1] = cury;
		       	FarmGrassPos[farmid][ FarmInfo[farmid][fMaxCount] ][2] = Z;

				FarmGrassArea[farmid][ FarmInfo[farmid][fMaxCount] ] = CreateDynamicSphere(Arr3<FarmGrassPos[farmid][ FarmInfo[farmid][fMaxCount] ]>, 5.0, 0, 0, INVALID_PLAYER_ID);

				FarmInfo[farmid][fMaxCount]++;
		    }
		    front = !front;
		}
		if(FarmInfo[farmid][fMaxCount] > 0)
		{
			curx = (FarmGrassPos[farmid][0][0] + FarmGrassPos[farmid][ FarmInfo[farmid][fMaxCount]-1 ][0]) / 2;
			cury = (FarmGrassPos[farmid][0][1] + FarmGrassPos[farmid][ FarmInfo[farmid][fMaxCount]-1 ][1]) / 2;
			MapAndreas_FindAverageZ(curx, cury, Z);
			Farm3DInfo[farmid] = CreateDynamic3DTextLabel("", -1, curx, cury, Z + 8.0, 250.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1, 250.0);
			FarmUpdate3D(farmid);
		}
		FarmInfo[farmid][fPickup] = CreateDynamicPickup(1239, 1, Arr3<FarmZones[farmid][fzStock]>);
	}

	//	Подработа Фермеров
	/*new car1 = MyCreateVehicle(531, -1092.72, -1170.08, 129.18, 90.00); // трактор
	MyCreateVehicle(531, -1092.79, -1166.05, 129.18, 90.00); // трактор
	MyCreateVehicle(532, -1091.99, -1191.06, 130.16, 90.00); // комбаин
	MyCreateVehicle(532, -1091.91, -1201.07, 130.20, 90.00); // комбаин
	MyCreateVehicle(478, -1109.00, -1155.46, 129.26, 180.0); // фургон
	MyCreateVehicle(478, -1114.00, -1155.50, 129.36, 180.0); // фургон
	MyCreateVehicle(478, -1119.00, -1155.50, 129.36, 180.0); // фургон
	//  Фермерские прицепы
	    // Ферма 1 (на горе между лс-сф)
	MyCreateVehicle(610, -1100.0, -1155.0, 128.6, 180.0, 0, 0);
    new car2 = MyCreateVehicle(610, -1095.0, -1155.0, 128.6, 180.0, 0, 0);*/

		// Ферма 2 (центральная)
    //MyCreateVehicle(610, -79.6383, 87.4604, 2.2077, 70.0, 0, 0);
    //MyCreateVehicle(610, -80.5549, 84.8143, 2.2077, 70.0, 0, 0);
        // Ферма 3 (возле Лос Сантоса)
    //MyCreateVehicle(610, -365.0994, -1414.1129, 24.8173, 0.0, 0, 0);
    //MyCreateVehicle(610, -368.1019, -1414.1913, 24.8173, 0.0, 0, 0);
        // Ферма 4 (следующая, возле бензоколонки)
    //MyCreateVehicle(610, -353.9981, -1038.5464, 58.5820, 90.0, 0, 0);
    //FarmVehicle_F = MyCreateVehicle(610, -354.0168, -1042.1282, 58.5820, 90.0, 0, 0);
  	/*for(new x = car1; x <= car2; x++)
	{
	    CarInfo[x][cType] = C_TYPE_PARTJOB;
	    CarInfo[x][cOwnerID] = PART_FARMER;
	    UpdateVehicleRespawnDelay(x, 30);
	    SetVehicleNumberPlate(x, "FARM");
	}*/

	FarmPickup = CreateDynamicPickup(1275, 1, -1060.89, -1195.57, 129.67);
	FarmZone = CreateDynamicRectangle(-1279.01, -1324.32, -987.31, -915.547, 0, 0);

	return CONTINUE;
}

Public: Farmer_OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(Job.GetPlayerNowWork(playerid) == PART_FARMER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		new farmid = 0;
		if(vehicleid)
		{
			new model = GetVehicleModel(vehicleid);
			for(new i = 0; i < FarmInfo[farmid][fMaxCount]; i++)
			{
				if(areaid == FarmGrassArea[farmid][i])
				{
					if(FarmInfo[farmid][fStatus] == FSTATUS_PLANTED && FarmGrassStatus[farmid][i] == FSTATUS_PLANTED)	//	не засеяно
					{
						if(model != 531)	return true;
						if(GetVehicleModel(GetVehicleTrailer(vehicleid)) != 610)
		            	{
							return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "Для засеивания прикрепите прицеп к трактору (NUM 2 или /tow).");
		            	}
		            	Job.GivePlayerPartWage(playerid, PRICE_FARMER * 0.127);
		            	ShowWorkInfo(playerid, "", 0, "Заработок", Job.GetPlayerPartWage(playerid), FARM_GRASS_OBJECT);
						FarmGrassStatus[farmid][i] = FSTATUS_GATHER;
						FarmGrassObjects[farmid][i] = CreateDynamicObject(823, FarmGrassPos[farmid][i][0], FarmGrassPos[farmid][i][1], FarmGrassPos[farmid][i][2] - 1.5, 0.0, 0.0, random(360));
						if(++FarmInfo[farmid][fCount] == FarmInfo[farmid][fMaxCount])
						{
							HideMissionInfo(playerid);
							SendFarmMessage(farmid, 300.0, COLOR_LIGHTGREEN, "> Поле засеяно, ждите, пока растения вырастут!");
							FarmInfo[farmid][fCount] = 0;
							FarmInfo[farmid][fStatus] = FSTATUS_GROWTH;
							//  Move Grass
							for(new j = 0; j < sizeof(FarmGrassPos[]); j++)
							{
								MoveDynamicObject(FarmGrassObjects[farmid][j], Arr3<FarmGrassPos[farmid][j]>, 0.02);
							}
						}
						FarmUpdate3D(farmid);
					}
					else if(FarmInfo[farmid][fStatus] == FSTATUS_GATHER && FarmGrassStatus[farmid][i] == FSTATUS_GATHER)
					{
						if(model != 532)	return true;
						Job.GivePlayerPartWage(playerid, PRICE_FARMER * 0.137);
						ShowWorkInfo(playerid, "", 0, "Заработок", Job.GetPlayerPartWage(playerid), FARM_GRASS_OBJECT);
						FarmGrassStatus[farmid][i] = FSTATUS_PLANTED;
						DestroyDynamicObject(FarmGrassObjects[farmid][i]), FarmGrassObjects[farmid][i] = INVALID_STREAMER_ID;
						SetTimerEx("FarmCreateGrassObject", 1000, 0, "ddd", vehicleid, farmid, i);
						if(++FarmInfo[farmid][fCount] == FarmInfo[farmid][fMaxCount])
						{
							HideMissionInfo(playerid);
							SendFarmMessage(farmid, 300.0, COLOR_LIGHTGREEN, "> Поле скошено, используйте фургон или вручную отнесите урожай на склад!");
						}
						FarmUpdate3D(farmid);
					}
					return true;
				}
			}
		}
		else
		{
			foreach(LoginPlayer, i)
			{
				if(areaid != g_FarmVehiclePoint[i])	continue;
			    new v = g_FarmPlayerVID[i];
			    if(GetVehicleBoot(v) == false)
			    {
			        return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "Кузов закрыт, откройте его командой /open или ПКМ + h.");
			    }
			   	new Float:dist = GetDistanceFromMeToPoint(playerid, Arr3<FarmZones[farmid][fzStock]>);
				if(g_FarmPlayerGrass{playerid})
				{
				    if(dist < 10.0)	return true;
			        if(g_FarmVehicleGrass[v] >= MAX_VEHICLE_GRASS)
			        {
			            return ShowPlayerHint(playerid, "~y~КYЗОВ ЗАПОЛНЕН~n~~w~Используйте ~y~/drop~w~, чтобы положить траву на землю");
			        }
			        g_FarmVGrassObjects[v][ g_FarmVehicleGrass[v] ] = CreateDynamicObject(FARM_GRASS_OBJECT, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
			        if(g_FarmVehicleGrass[v] < MAX_VEHICLE_GRASS / 2)
					{
						AttachDynamicObjectToVehicle(g_FarmVGrassObjects[v][ g_FarmVehicleGrass[v] ], v, 0.0, -0.8 - (0.5 * g_FarmVehicleGrass[v]), 0.2, 0.5, 0.5, 0.5);
					}
					else
					{
					    AttachDynamicObjectToVehicle(g_FarmVGrassObjects[v][ g_FarmVehicleGrass[v] ], v, 0.0, -0.8 - (0.5 * (g_FarmVehicleGrass[v] - MAX_VEHICLE_GRASS / 2)), 0.5, 0.5, 0.5, 0.5);
					}
					_CarryDown(playerid);
	                g_FarmPlayerGrass{playerid} = 0;
					if(++g_FarmVehicleGrass[v] == MAX_VEHICLE_GRASS)
					{
				    	SendClientMessage(i, COLOR_LIGHTGREEN, "> Кузов заполнен, отвезите урожай на склад фермы и разгрузите его.");
	                    FarmDeleteVPoint(i);
					}
				}
				else if(g_FarmVehicleGrass[v] > 0 && dist < 10.0)
				{
					if(CarryUP(playerid, FARM_GRASS_OBJECT, 0.059, 0.315, 0.065, 331.51, 271.87, 321.75, 0.83, 1.0, 0.748))
					{
						if(--g_FarmVehicleGrass[v] == 0)	FarmDeleteVPoint(i);
				    	DestroyDynamicObject(g_FarmVGrassObjects[v][ g_FarmVehicleGrass[v] ]);
	               		g_FarmPlayerGrass{playerid} = 1;
					}
				}
				return true;
			}
		}
	}
	return CONTINUE;
}

Public: Farmer_OnPlayerPickUpDPickup(playerid, pickupid)
{
	if(pickupid == FarmPickup)
    {
    	if(!Dialog_IsOpen(playerid))
    	{
    		Dialog_Show(playerid, Dialog:Farmer_Main);
    	}
    }
    else
    {
    	if(Job.GetPlayerNowWork(playerid) == PART_FARMER)
		{
			for(new f = 0; f < sizeof(FarmInfo); f++)
			{
				if(f == FarmPlayer[playerid])
				{
					if(FarmInfo[f][fPickup] == pickupid)
					{
						if(g_FarmPlayerGrass{playerid})
						{	//  Farm
						    g_FarmPlayerGrass{playerid} = 0;
						    Job.GivePlayerPartWage(playerid, PRICE_FARMER * 0.735);
							ShowWorkInfo(playerid, "", 0, "Заработок", Job.GetPlayerPartWage(playerid), FARM_GRASS_OBJECT);
		                    CarryDown(playerid);
		                    gPickupTime[playerid] = 3;
		                    return true;
						}
					}
					else if(FarmInfo[f][fStatus] == FSTATUS_GATHER && !g_FarmPlayerGrass{playerid})
					{
						for(new p = 0; p < sizeof(FarmGrassObjects[]); p++)
					    {
					        if(pickupid == FarmGrassObjects[f][p])
							{
								if(CarryUP(playerid, FARM_GRASS_OBJECT, 0.059, 0.315, 0.065, 331.51, 271.87, 321.75, 0.83, 1.0, 0.748))
								{
									DestroyDynamicPickup(FarmGrassObjects[f][p]);
									FarmGrassObjects[f][p] = INVALID_STREAMER_ID;
									g_FarmPlayerGrass{playerid} = 1;
									if(++FarmInfo[f][fHarvest] == FarmInfo[f][fMaxCount])
									{
										SendFarmMessage(f, 300.0, COLOR_LIGHTGREEN, "> Урожай собран, можно приступать к новому засеиванию поля!");
										FarmInfo[f][fStatus] = FSTATUS_PLANTED;
					                	FarmInfo[f][fHarvest] = 0;
					                	FarmInfo[f][fCount] = 0;
									}
								}
								return FarmUpdate3D(f);
							}
					    }
					}
				}
			}
		}
    }
    return CONTINUE;
}

Public: Farmer_OnDynamicObjectMoved(objectid)
{
 	for(new i = 0; i < sizeof(FarmInfo); i++)
	{
	    if(FarmInfo[i][fStatus] == FSTATUS_GROWTH)
		{
        	for(new p = 0; p < sizeof(FarmGrassPos[]); p++)
			{
				if(objectid == FarmGrassObjects[i][p])
				{
				    SendFarmMessage(i, 300.0, COLOR_LIGHTGREEN, "> Урожай вырос, можно приступать к сбору!");
					FarmInfo[i][fStatus] = FSTATUS_GATHER;
					return FarmUpdate3D(i);
				}
			}
		}
	}

	return CONTINUE;
}

//////////	Functions	//////////
stock SendFarmMessage(farmid, Float:rad, color, const string[])
{
	if(0 <= farmid < sizeof(FarmInfo))
	{
		foreach(LoginPlayer, i)
		{
		    if(Job.GetPlayerNowWork(i) == PART_FARMER && GetDistanceFromMeToPoint(i, Arr3<FarmZones[farmid][fzPos]>) < rad)
		    {
		    	SendClientMessage(i, color, string);
		    }
		}
	}
}

FarmCreateVPoint(playerid, vehicleid)
{
    if(g_FarmPlayerVID[playerid] > 0 || g_FarmVehiclePoint[playerid])
    {
    	FarmDeleteVPoint(playerid);
    }
	g_FarmVehiclePoint[playerid] = CreateDynamicSphere(0.0, 0.0, 0.0, 1.5);
	AttachDynamicAreaToVehicle(g_FarmVehiclePoint[playerid], vehicleid, 0.0, -2.7, 0.5);
	g_FarmPlayerVID[playerid] = vehicleid;

	SetVehicleBoot(g_FarmPlayerVID[playerid], true);
	UpdateVehicleParamsEx(g_FarmPlayerVID[playerid]);
	return true;
}

FarmDeleteVPoint(playerid)
{
	if(g_FarmPlayerVID[playerid] > 0 || g_FarmVehiclePoint[playerid])
    {
		DestroyDynamicArea(g_FarmVehiclePoint[playerid]);
	    SetVehicleBoot(g_FarmPlayerVID[playerid], false);
		UpdateVehicleParamsEx(g_FarmPlayerVID[playerid]);
		g_FarmVehiclePoint[playerid] = 0;
		g_FarmPlayerVID[playerid] = 0;
	}
	return true;
}

FarmDropGrass(playerid)
{
	new farm = FarmPlayer[playerid];
	if(FarmInfo[farm][fStatus] == FSTATUS_GATHER && IsPlayerInRangeOfPoint(playerid, 100.0, Arr3<FarmZones[farm][fzPos]>))
	{
        for(new i = 0; i < sizeof(FarmGrassObjects[]); i++)
		{
			if(FarmGrassObjects[farm][i] == 0)
			{
				new Float:pos[4];
        		MyGetPlayerPos(playerid, Arr4<pos>);
		        FarmInfo[farm][fHarvest]--;
				FarmGrassObjects[farm][i] = CreateDynamicPickup(FARM_GRASS_OBJECT, 6, pos[0] + (2.5 * floatsin(-pos[3], degrees)), pos[1] + (2.5 * floatcos(-pos[3], degrees)), pos[2] + 0.1);
		        FarmUpdate3D(farm);
				break;
			}
		}
	}
	g_FarmPlayerGrass{playerid} = 0;
    return true;
}

Farmer_FinishWork(playerid)
{
	FarmDeleteVPoint(playerid);
	HideMissionInfo(playerid);
	_CarryDown(playerid), g_FarmPlayerGrass{playerid} = 0;
	KillTimer(g_FarmSpeedLimiter[playerid]);
    return true;
}

FarmUpdate3D(farmid)
{
	new string[256], status[32];
	if(FarmInfo[farmid][fStatus] == FSTATUS_PLANTED)		status = "Засеивание";
	else if(FarmInfo[farmid][fStatus] == FSTATUS_GROWTH)	status = "Рост";
	else if(FarmInfo[farmid][fStatus] == FSTATUS_GATHER)	status = "Сбор";
    format(string, sizeof string, 	"{CFB53B}Статус: {FFFFFF}%s\n\
									{CFB53B}Обработано: {FFFFFF}%d{CFB53B}/{FFFFFF}%d\n\
									{CFB53B}Собрано: {FFFFFF}%d", 	status,
																	FarmInfo[farmid][fCount],
																	FarmInfo[farmid][fMaxCount],
																	FarmInfo[farmid][fHarvest]);
    return UpdateDynamic3DTextLabelText(Farm3DInfo[farmid], COLOR_ORANGE, string);
}

Public: FarmSpeedVehicleLimit(playerid, Float:speed)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(vehicleid && GetVehicleSpeed(vehicleid) > 25)
	{
		SetVehicleSpeed(vehicleid, 25.0);
	}
	return true;
}

Public: FarmCreateGrassObject(vehicleid, farmid, slot)
{
	new Float:pos[4];
	GetVehiclePos(vehicleid, Arr3<pos>);
	GetVehicleZAngle(vehicleid, pos[3]);
	pos[0] += (-3.0 * floatsin(-pos[3], degrees));	
	pos[1] += (-3.0 * floatcos(-pos[3], degrees));
	new obj = CreateDynamicObject(FARM_GRASS_OBJECT, pos[0], pos[1], pos[2] + 1.3, 0.0, 0.0, 0.0);
	pos[0] += (-10.0 * floatsin(-pos[3], degrees));	
	pos[1] += (-10.0 * floatcos(-pos[3], degrees)); 
	pos[2] -= 1.7;
	
	// Корректировка координат, чтобы не вылетали тюки за пределы поля
	new Float:A = FarmZones[farmid][fzPos][3];
	new Float:x = FarmZones[farmid][fzPos][0] + (FarmZones[farmid][fzStep] * FarmZones[farmid][fzHeight] * floatsin(A, degrees));
	new Float:y = FarmZones[farmid][fzPos][1] + (FarmZones[farmid][fzStep] * FarmZones[farmid][fzWidth] * floatcos(A, degrees));
	if(pos[0] < x) pos[0] = x;
	if(pos[1] < y) pos[1] = y;

	MapAndreas_FindZ_For2DCoord(Arr3<pos>);
	MoveDynamicObject(obj, pos[0], pos[1], pos[2], 20.0);
	SetTimerEx("FarmCreateGrassPickup", 1000, 0, "dddfff", obj, farmid, slot, pos[0], pos[1], pos[2]);
	return true;
}

Public: FarmCreateGrassPickup(object, farmid, slot, Float:x, Float:y, Float:z)
{
    DestroyDynamicObject(object);
	FarmGrassObjects[farmid][slot] = CreateDynamicPickup(FARM_GRASS_OBJECT, 6, x, y, z + 1.0);
	return true;
}

//////////	Commands	//////////
flags:farmstatus(CMD_DEVELOPER);
COMMAND:farmstatus(playerid, params[])
{
	new farmid, status;
	if(sscanf(params, "ii", farmid, status))
	{
		return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /farmstatus [farmid][status]");
	}
	if(!(0 <= farmid < sizeof(FarmInfo)))
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Неверный номер поля.");
	}
	if(!(0 <= status < 4))
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Неверный статус (0-4).");
	}
	FarmInfo[farmid][fStatus] = status;
	//	Удаляяем траву
	for(new i = 0; i < MAX_GRASS; i++)
	{
		DestroyDynamicObject(FarmGrassObjects[farmid][i]);
		DestroyDynamicPickup(FarmGrassObjects[farmid][i]);
		FarmGrassObjects[farmid][i] = INVALID_STREAMER_ID;
		FarmGrassStatus[farmid][i] = FSTATUS_PLANTED;
	}
	//	Обнуляем значения
	FarmInfo[farmid][fCount] = 0;
	FarmInfo[farmid][fHarvest] = 0;
	switch(FarmInfo[farmid][fStatus])
	{
		case 0:
		{
			FarmInfo[farmid][fStatus] = FSTATUS_PLANTED;
			SendFarmMessage(farmid, 300.0, COLOR_LIGHTGREEN, "> Поле очищено администратором!");
		}
		case 1:
		{
			FarmInfo[farmid][fStatus] = FSTATUS_GROWTH;
			for(new i = 0; i < FarmInfo[farmid][fMaxCount]; i++)
			{
				FarmGrassObjects[farmid][i] = CreateDynamicObject
				(
					823,
					FarmGrassPos[farmid][i][0],
					FarmGrassPos[farmid][i][1],
					FarmGrassPos[farmid][i][2] - 1.5,
					0.0, 0.0, 0.0
				);
				FarmGrassStatus[farmid][i] = FSTATUS_GATHER;
			}
			for(new i = 0; i < FarmInfo[farmid][fMaxCount]; i++)
			{
				MoveDynamicObject(FarmGrassObjects[farmid][i], Arr3<FarmGrassPos[farmid][i]>, 0.02);
			}
			SendFarmMessage(farmid, 300.0, COLOR_LIGHTGREEN, "> Поле засеяно администратором!");
		}
		case 2:
		{
			FarmInfo[farmid][fStatus] = FSTATUS_GATHER;
			for(new i = 0; i < FarmInfo[farmid][fMaxCount]; i++)
			{
				FarmGrassObjects[farmid][i] = CreateDynamicObject(823, Arr3<FarmGrassPos[farmid][i]>, 0.0, 0.0, 0.0);
				FarmGrassStatus[farmid][i] = FSTATUS_GATHER;
			}
			SendFarmMessage(farmid, 300.0, COLOR_LIGHTGREEN, "> Поле взрощено администратором!");
		}
		case 3:
		{
			FarmInfo[farmid][fStatus] = FSTATUS_GATHER;
			FarmInfo[farmid][fCount] = FarmInfo[farmid][fMaxCount];
			for(new i = 0; i < FarmInfo[farmid][fMaxCount]; i++)
			{
				FarmGrassObjects[farmid][i] = CreateDynamicPickup(FARM_GRASS_OBJECT, 6, FarmGrassPos[farmid][i][0], FarmGrassPos[farmid][i][1], FarmGrassPos[farmid][i][2] + 1.0);
			}
			SendFarmMessage(farmid, 300.0, COLOR_LIGHTGREEN, "> Поле скошено администратором!");
		}
	}
	FarmUpdate3D(farmid);
	return true;
}

//////////	Dialogs 	//////////
DialogCreate:Farmer_Main(playerid)
{
	new string[128];
	if(Job.GetPlayerNowWork(playerid) == PART_FARMER)
			strcat(string, "{80FF00}• {FFFFFF}Переодеться и закончить работу\n");
	else 	strcat(string, "{80FF00}• {FFFFFF}Переодеться и начать работу\n");
	strcat(string, "{80FF00}• {FFFFFF}Информация по работе");
	return Dialog_Open(playerid, Dialog:Farmer_Main, DIALOG_STYLE_LIST, "Ферма", string, "Выбрать", "Закрыть");
}

DialogResponse:Farmer_Main(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(listitem == 0)
		{
			//new farmid = 0;
			if(Job.GetPlayerNowWork(playerid) == PART_FARMER)
			{
				Job.ClearPlayerNowWork(playerid);
    			PlayerAction(playerid, "переодевается в свою одежду.");
			}
			else
			{
    			if(Job.SetPlayerNowWork(playerid, PART_FARMER))
    			{
    				new const Farm_Skins[] = { 132, 133, 158, 159, 160, 161, 162, 202 };
    				MySetPlayerSkin(playerid, Farm_Skins[ random(sizeof(Farm_Skins)) ], false);
    				FarmPlayer[playerid] = 0;
    				PlayerAction(playerid, "переодевается в рабочую одежду.");
    				ShowWorkInfo(playerid, "", 0, "Заработок", 0, FARM_GRASS_OBJECT);
    			}
			}
		}
		else if(listitem == 1)
		{
			new lstring[1408] = "{FFFFFF}Работа на ферме делиться на {80FF00}3 этапа{FFFFFF}:\n\n\
			{80FF00}[1]{FFFFFF} Этап засеивания\n\
			На данном этапе {80FF00}сядьте в трактор и подцепите плуг (NUM2 или /tow){FFFFFF}\n\
			После чего {80FF00}едьте по полю{FFFFFF} засеявая его.\n\
			Пройдя все поле - припаркуйте транспорт и ожидайте пока растения вырастут.\n\n";
			strcat(lstring, "{80FF00}[2]{FFFFFF} Этап скоса посевов\n\
			На втором этапе {80FF00}возьмите комбаин{FFFFFF} и отправляйтесь на поле.\n\
			Проезжайте по растениям для скоса. За вами будут появляться обработаные тюки травы.\n\n");
			strcat(lstring, "{80FF00}[3]{FFFFFF} Этап сбора\n\
			На третьем этапе необходимо {80FF00}взять фургон{FFFFFF} и подъехав к скошенным посевам {80FF00}нажать 2{FFFFFF},\n\
			чтобы {80FF00}открыть багажник для загрузки{FFFFFF}.\n\
			( Так же открыть багажник можно командой {80FF00}/open{FFFFFF} или нажатием {80FF00}ПКМ+h{FFFFFF} рядом с ним ){FFFFFF}\n\
			После открытия кузова, просто {80FF00}собирайте траву{FFFFFF} рядом с вами и подносите к кузову.\n");
			strcat(lstring, "Когда кузов полностью загружен - {80FF00}езжайте к складу разгрузки (желтый пикап i){FFFFFF} и\n\
			и открыв багажник - {80FF00}носите траву на склад{FFFFFF}.\n\
			После чего цикл повторяется.\n\n\
			Дополнительно:\n\
			Выбросить подобранный тюк можно командой /drop");
			return Dialog_Open(playerid, Dialog:Farmer_Info, DIALOG_STYLE_MSGBOX, "Информация по работе на ферме", lstring, "Назад", "", 0);
		}
	}
	gPickupTime[playerid] = 3;
	return true;
}

DialogResponse:Farmer_Info(playerid, response, listitem, inputtext[])
{
	return Dialog_Show(playerid, Dialog:Farmer_Main);
}