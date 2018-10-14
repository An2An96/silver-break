#if !defined _job_core_included
	#endinput
#endif

#if defined	_job_job_busdriver_included
	#endinput
#endif
#define _job_job_busdriver_included

enum BS_ENUM
{
	BS_TYPE,    // Тип чекпоинта (0 - путь, 1 - остановка, 9 - пустая строка)
	Float:BS_X,
	Float:BS_Y,
	Float:BS_Z
}

static const BusStopPos[][][BS_ENUM] =
{// Внимание! У каждого маршрута должен быть ноль в конце!
	{// Автовокзал - Аэропорт ЛС
		{0, 1245.5934,-1827.2794,12.9630},
		{0, 1214.7922,-1841.8560,12.9564},
		{0, 1183.3729,-1847.3668,12.9689},
		{1, 1182.6996,-1755.1780,12.9672}, // Verona Beach (автовокзал)
		{0, 1185.3765,-1714.5061,13.0382},
		{0, 1294.3369,-1717.4796,12.9472},
		{0, 1302.8832,-1851.6414,12.9444},
		{0, 1387.1575,-1869.7021,12.9496},
		{0, 1393.2305,-1736.2311,12.9400},
		{1, 1505.2665,-1735.2202,12.9558}, // Commerce (Мэрия)
		{0, 1586.8246,-1734.8845,13.5160},
		{0, 1681.6024,-1734.9403,12.9646},
		{0, 1696.2594,-1813.0950,12.9499},
		{0, 1816.6770,-1836.8966,12.9760},
		{1, 1818.4041,-1871.2587,12.9850}, // El Corona (ЖДЛС)
		{0, 1821.7081,-1928.2598,12.9446},
		{0, 1956.2943,-1935.7954,12.9443},
		{0, 1961.8755,-2103.9170,12.9565},
		{0, 2133.1516,-2117.7029,12.9217},
		{1, 2229.8794,-2200.5261,12.9054}, // Ocean Docs (Склад)
		{0, 2287.6406,-2258.2568,12.9405},
		{0, 2173.7947,-2390.9744,12.9389},
		{0, 2150.9546,-2606.6533,12.9465},
		{0, 2056.0017,-2667.7979,12.6404},
		{0, 1568.1046,-2667.6411,5.9142},
		{0, 1408.2803,-2659.5657,12.9394},
		{0, 1355.8024,-2520.5571,12.9472},
		{0, 1365.3070,-2466.8313,7.2152},
		{0, 1507.6788,-2456.7668,2.0330},
		{0, 1524.9114,-2291.3306,-3.4248},
		{0, 1577.9092,-2275.6702,-3.3654},
		{1, 1673.7887,-2256.6572,-3.3110}, // Los Santos Airport
		{0, 1793.7958,-2256.9036,5.8298},
		{0, 1794.5490,-2315.3589,12.9505},
		{0, 1580.0198,-2316.3027,12.9416},
		{0, 1566.0557,-2284.6702,12.9520},
		{0, 1518.5747,-2298.2742,12.9423},
		{0, 1458.2084,-2375.7339,13.3237},
		{0, 1269.3127,-2362.6091,18.9049},
		{0, 1328.9883,-2334.6072,12.9393},
		{0, 1329.8776,-2508.9629,12.9378},
		{0, 1399.8346,-2675.8640,12.9394},
		{0, 1577.7349,-2686.9402,5.4443},
		{0, 1935.2168,-2687.0833,5.6305},
		{0, 2125.5862,-2666.9414,12.9392},
		{0, 2176.5764,-2570.7542,12.9399},
		{0, 2205.0288,-2372.4158,12.9471},
		{0, 2296.1260,-2265.4312,12.9439},
		{1, 2227.7722,-2190.4600,12.8936}, // Ocean Docs (Склад)
		{0, 2140.0325,-2115.9326,12.9464},
		{0, 1966.8716,-2106.5159,12.9446},
		{0, 1961.7566,-1937.8927,12.9433},
		{0, 1825.6947,-1928.2090,12.9439},
		{1, 1824.7462,-1852.8041,12.9752}, // El Corona (ЖДЛС)
		{0, 1787.2096,-1829.4305,12.9476},
		{0, 1695.0321,-1808.8335,12.9452},
		{0, 1689.6829,-1736.7065,12.9687},
		{0, 1580.5402,-1730.4697,12.9476},
		{1, 1493.5623,-1729.2915,12.9533}, // Мэрия
		{0, 1394.3605,-1732.3472,12.9465},
		{0, 1385.0555,-1867.1183,12.9495},
		{0, 1271.5289,-1845.3046,12.9605},
		{9, 0.0, 0.0, 0.0}
	},
	//	Автовокзал - Центр ЛС
	{
		{0, 1245.5934, -1827.2794, 12.9630},
		{0, 1181.5464,-1848.9764,13.1074},
		{1, 1183.1958,-1757.4110,13.1090},
		{0, 1041.1058,-1712.3622,13.0897},
		{0, 1020.6936,-1796.8400,13.5196},
		{0, 767.4044,-1766.8395,12.5550},
		{0, 633.3858,-1724.2943,13.6389},
		{0, 637.4774,-1411.6017,13.1291},
		{1, 721.1442,-1407.9788,13.0706},
		{0, 909.0608,-1405.5121,12.9122},
		{0, 1184.3832,-1405.5891,12.9139},
		{1, 1209.1611,-1316.0081,13.1029},
		{0, 1212.9933,-1283.7701,13.0885},
		{0, 1254.4921,-1285.8134,13.0491},
		{0, 1254.0356,-1387.9741,12.8499},
		{1, 1317.1934,-1409.3669,12.9880},
		{0, 1395.5992,-1409.4652,13.0881},
		{0, 1403.1398,-1443.1089,13.0885},
		{0, 1602.1648,-1443.1801,13.0868},
		{0, 1760.6256,-1446.6068,13.0642},
		{0, 1841.0798,-1463.3486,13.1008},
		{1, 1818.3843,-1678.6592,13.0874},
		{0, 1813.2762,-1730.3798,13.0880},
		{0, 1676.1288,-1730.2821,13.0875},
		{1, 1493.5623,-1729.2915,12.9533}, // Мэрия
		{0, 1394.3605,-1732.3472,12.9465},
		{0, 1385.0555,-1867.1183,12.9495},
		{0, 1271.5289,-1845.3046,12.9605},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0},
		{9, 0.0, 0.0, 0.0}
	}
};

new BusDriverStatus[MAX_PLAYERS],   // Статус работы (0 - не работает, 1 - арендовал, 2 - работает, 3 - на остановке)
	BusDriverVeh[MAX_PLAYERS],      // Порядковый номер автобуса
	BusDriverRoute[MAX_PLAYERS],    // Порядковый номер маршрута
	BusDriverPrice[MAX_PLAYERS],    // Цена проезда
	BusDriverStep[MAX_PLAYERS],     // Номер чекпоинта
	BusDriverCP[MAX_PLAYERS],     	// Идентификатор чекпоинта
	BusDriverLeave[MAX_PLAYERS];    // Счетчик времени при выходе из автобуса

Public: BusDriver_OnGameModeInit()
{
	// Работа Водителей автобусов. Автобусы
	/*new car1 = MyCreateVehicle(437, 1276.6675, -1795.7958, 13.3839, 90.0, 17, 17);
	MyCreateVehicle(437, 1276.6675, -1801.7958, 13.3839, 90.0, 17, 17);
	MyCreateVehicle(437, 1276.6675, -1807.7958, 13.3839, 90.0, 17, 17);
	MyCreateVehicle(437, 1276.6675, -1813.7958, 13.3839, 90.0, 17, 17);
	MyCreateVehicle(437, 1276.6675, -1819.7958, 13.3839, 90.0, 17, 17);
	MyCreateVehicle(437, 1276.6675, -1825.7958, 13.3839, 90.0, 17, 17);
	new car2 = MyCreateVehicle(437, 1276.6675, -1831.7958, 13.3839, 90.0, 17, 17);
	for(new x = car1; x <= car2; x++)
	{
	    CarInfo[x][cType] = C_TYPE_JOB;
	    CarInfo[x][cOwnerID] = JOB_BUSDRIVER;
	    VehInfo[x][vRentPrice] = 75;
	    SetVehicleNumberPlate(x, "BUSDRIVER");
	}*/

	return CONTINUE;
}

Public: BusDriver_OnPlayerEnterDRaceCP(playerid, checkpointid)
{
	if(BusDriverStatus[playerid] > 0 && BusDriverCP[playerid] == checkpointid && IsPlayerInVehicle(playerid, BusDriverVeh[playerid]))
	{
		new step = BusDriverStep[playerid];
		new route = BusDriverRoute[playerid];

		Job.GivePlayerPartWage(playerid, 1.0);
		GiveBusSkill(playerid);
	    DestroyDynamicRaceCP(BusDriverCP[playerid]), BusDriverCP[playerid] = INVALID_STREAMER_ID;
		ShowWorkInfo(playerid, "", 0, "Зарплата", floatround(Job.GetPlayerPartWage(playerid)), 437);

		if(BusStopPos[route][step][BS_TYPE] == 1 && BusDriverStatus[playerid] == 2)
		{// Остановка
			new string[128];
			switch(route)
			{
				case 0: string = "Автовокзал - Аэропорт ЛС";
			}
			format(string, sizeof(string), "Автобус по маршруту %s отправляется через 10 секунд", string);
	   		SendRadiusMessage(playerid, 50.0, 0x44B2FFFF, string);

	   		BusDriverStatus[playerid] = 3; // На остановке
			SetTimerEx("UpdateBusCheckpoint", 10000, false, "i", playerid);
			return 1;
		}
		// Отъехал с остановки
		if(BusDriverStatus[playerid] == 3) BusDriverStatus[playerid] = 2;

		if(BusStopPos[route][step+1][BS_TYPE] == 9)
		{// Законченный маршрут
		    ShowPlayerHint(playerid, "Нажмите ~y~~k~~TOGGLE_SUBMISSIONS~ ~w~чтобы завершить работу и получить деньги", 10000);

		    BusDriverStep[playerid] = 0;
			_SetBusCheckpoint(playerid, 0);
		}
		else _SetBusCheckpoint(playerid, ++BusDriverStep[playerid]);

		return true;
	}

	return CONTINUE;
}

////////////////////////////////////////
BusDriver_FinishWork(playerid, reason = Job.REASON_COMPLETE)
{
	#pragma unused reason
	if(BusDriverStatus[playerid] > 0)
	{
		DestroyDynamic3DTextLabel(VehInfo[BusDriverVeh[playerid]][vLabel]), VehInfo[BusDriverVeh[playerid]][vLabel] = Text3D:INVALID_STREAMER_ID;
		MySetVehicleToRespawn(BusDriverVeh[playerid]);
		DestroyDynamicRaceCP(BusDriverCP[playerid]), BusDriverCP[playerid] = INVALID_STREAMER_ID;
		HideMissionMessage(playerid);

		BusDriverStatus[playerid] 	= 0;
		BusDriverVeh[playerid] 		= 0;
		BusDriverPrice[playerid] 	= 0;
		BusDriverStep[playerid] 	= 0;
		BusDriverLeave[playerid] 	= 0;
		BusDriverRoute[playerid] 	= 0;
	}
	return true;
}	

Public: UpdateBusCheckpoint(playerid)
{
	if(BusDriverStatus[playerid] > 0)
	{
		new route = BusDriverRoute[playerid];
		new step = BusDriverStep[playerid];

		if(BusStopPos[route][step+1][BS_TYPE] != 9 && IsPlayerInRangeOfPoint(playerid, 5.0, BusStopPos[route][step][BS_X], BusStopPos[route][step][BS_Y], BusStopPos[route][step][BS_Z]))
		{// Если остановка не конечная и игрок остался в пределах чекпоинта, то сразу показывать следующий
			BusDriverStatus[playerid] = 2; // В пути
			_SetBusCheckpoint(playerid, ++BusDriverStep[playerid]);
		}
		else
		{// Если остановка - конечная, или игрок уехал от остановки, то показывать на остановку
			_SetBusCheckpoint(playerid, BusDriverStep[playerid]);
		}
	}
}

//////////	Private 	//////////
static _SetBusCheckpoint(playerid, step)
{
	new route = BusDriverRoute[playerid];

	BusDriverCP[playerid] = CreateDynamicRaceCP(
		BusStopPos[route][step][BS_TYPE],
		BusStopPos[route][step][BS_X],
		BusStopPos[route][step][BS_Y],
		BusStopPos[route][step][BS_Z],
		BusStopPos[route][step + 1][BS_X],
		BusStopPos[route][step + 1][BS_Y],
		BusStopPos[route][step + 1][BS_Z],
		4.5, -1, -1, playerid, FLOAT_INFINITY);
	Streamer_Update(playerid, STREAMER_TYPE_RACE_CP);
}

//////////	Dialogs 	//////////
DialogCreate:BusDriver_Route(playerid) 
{
	if(!Job.GetPlayerNowWork(playerid) || Job.GetPlayerNowWork(playerid) == JOB_BUSDRIVER)
	{
		new string[128] =
		    "{80FF00}• {FFFFFF}Автовокзал - Аэропорт ЛС\n\
		    {80FF00}• {FFFFFF}Автовокзал - Автошкола";
		Dialog_Open(playerid, Dialog:BusDriver_Route, DIALOG_STYLE_LIST, "Выберите маршрут", string, "Выбрать", "");
	}
    return true;
}
		
DialogResponse:BusDriver_Route(playerid, response, listitem, inputtext[])
{
    if(!response) return Dialog_Show(playerid, Dialog:BusDriver_Route);
	BusDriverRoute[playerid] = listitem;
    return Dialog_Show(playerid, Dialog:BusDriver_Tax);
}

DialogCreate:BusDriver_Tax(playerid)
{
    new string[128] = "\n{FFFFFF}Введите цену проезда (от {80FF00}$1{FFFFFF} до {80FF00}$20{FFFFFF}):";
	return Dialog_Open(playerid, Dialog:BusDriver_Tax, DIALOG_STYLE_INPUT, "Цена проезда", string, "Ввести", "");
}

DialogResponse:BusDriver_Tax(playerid, response, listitem, inputtext[])
{
	new string[128];
    new const price = strval(inputtext);
	if(!(0 < strlen(inputtext) < 10) || price < 1 || price > 20)
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Введено некорректное значение.");
        return Dialog_Show(playerid, Dialog:BusDriver_Tax);
    }
    if(Job.SetPlayerNowWork(playerid, JOB_BUSDRIVER))
    {
    	switch(BusDriverRoute[playerid])
		{
		    case 0: string = "Автовокзал - Аэропорт ЛС";
		    case 1:	string = "Автовокзал - Центр (Автошкола)";
		}
		BusDriverStatus[playerid] = 2;
		BusDriverPrice[playerid] = price;
		BusDriverStep[playerid] = 0;
		BusDriverCP[playerid] = 0;
		format(string, sizeof(string), "{44B2FF}%s\n{FFFFFF}Цена проезда: {44B2FF}%d$", string, price);
		VehInfo[ BusDriverVeh[playerid] ][vLabel] = CreateDynamic3DTextLabel(string, -1, 0.0, 0.0, 3.0, 40.0, INVALID_PLAYER_ID, BusDriverVeh[playerid], 1);
		_SetBusCheckpoint(playerid, 0);

		ShowWorkInfo(playerid, "", 0, "Зарплата", floatround(Job.GetPlayerPartWage(playerid)), 437);

		//Streamer_Update(playerid);
    }
	return true;
}

DialogCreate:BusDriver_End(playerid)
{
	new string[256];
    format(string, sizeof(string), "\n{FFFFFF}Вы заработали {80FF00}%d${FFFFFF} за всю работу\nВы уверены, что хотите завершить?\n\nВнимание! После завершения работы ваш автобус исчезнет!", floatround(Job.GetPlayerPartWage(playerid)));
	return Dialog_Open(playerid, Dialog:BusDriver_End, DIALOG_STYLE_MSGBOX, "Завершение маршрута", string, "Да", "Отмена");
}

DialogResponse:BusDriver_End(playerid, response, listitem, inputtext[])
{
    if(response)
    {
    	Job.ClearPlayerNowWork(playerid);
	}
	return true;
}