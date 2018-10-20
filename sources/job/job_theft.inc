#if !defined _job_core_included
	#endinput
#endif

#if defined	_job_job_theft_included
	#endinput
#endif
#define _job_job_theft_included

#include "faction/header"

#define THEFT_RELOAD_TIME       1800    // Перезарядка между угонами авто (1800 = 30 мин)

//  Угон автотранспорта
static
	TheftGarage[MAX_PLAYERS],		// Гараж для доставки (смотри TheftGate)
	bool:TheftRespawn[MAX_PLAYERS],	// (true - респавнить, false - пересоздать)
	TheftZone[MAX_PLAYERS],			// Гангзона
	TheftZone2[MAX_PLAYERS],		// Динамическа зона
	TheftTime[MAX_PLAYERS],			// Время на угон
	theft_timer[MAX_PLAYERS],		// Таймер угонщика

	TheftGate[2],					// Объекты ворот автоугонщиков
	TheftGateZone[2];				// Зоны ворот автоугонщиков

new TheftVehicle[MAX_PLAYERS],      // Транспорт для угона
	TheftStatus[MAX_PLAYERS],       // Статус работы (0 - не работает, 1 - в поисках авто, 2 - везет авто в гараж)
	TheftTimeOut[MAX_PLAYERS];      // Время вернуться за руль

Public: Theft_OnGameModeInit()
{
	TheftGate[0] = CreateDynamicObject(10149, -1695.18, 1035.617, 45.70, 0.0, 0.0, 90.0);// Ворота в точке автосбыта СФ
	TheftGate[1] = CreateDynamicObject(10154, -1790.45313, 1430.12500, 8.97660, 0.0, 0.0, 270.0);	// Гараж СФ Порт
	//TheftGate[2] = CreateDynamicObject(5302, 2741.07031, -2004.78125, 14.87500,   0.00000, 0.00000, 90.00000); // Гараж ЛС гетто - ВЫЛЕТАЕТ

	TheftGateZone[0] = CreateDynamicSphere(-1695.5710,1035.7693,45.2109, 12.0, 0, 0, -1); // Гараж автоугона СФ (в переулке)
	TheftGateZone[1] = CreateDynamicSphere(-1790.45313, 1430.12500, 8.97660, 12.0, 0, 0, -1); // Гараж автоугона СФ (в порту)

	return CONTINUE;
}

Public: Theft_OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
		// Работа автоугонщика
		new vehicleid = GetPlayerVehicleID(playerid);
		if(Job.GetPlayerJob(playerid) == JOB_THEFT)
		{
		    if(TheftStatus[playerid] == 1)
		    {
		        if(GetVehicleModel(TheftVehicle[playerid]) == GetVehicleModel(vehicleid))
		        {
		        	new string[32];
			        format(string, sizeof(string), "Вы нашли ~y~%s", ReturnVehicleName(vehicleid));
			        ShowPlayerHint(playerid, string);
		        }
		    }
			else if(TheftStatus[playerid] == 0)
			{
				if(GetVehicleEngine(vehicleid) && CarInfo[vehicleid][cType] == C_TYPE_DEFAULT && !IsAvailableVehicle(vehicleid, playerid))
				{
					if(VehInfo[vehicleid][vModelType] == MTYPE_NONE || VehInfo[vehicleid][vModelType] == MTYPE_MOTO || VehInfo[vehicleid][vModelType] == MTYPE_TRUCK)
					{
						ShowPlayerHint(playerid, "Нажмите ~y~~k~~TOGGLE_SUBMISSIONS~ ~w~чтобы отметить гараж для угнанных авто");
					}
				}
			}
		}
	}

	return CONTINUE;
}

Public: Theft_OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(TheftGateZone[0] <= areaid <= TheftGateZone[sizeof(TheftGateZone) - 1])
	{	// Ворота гаража для автоугона
	    if(0 <= TheftGarage[playerid] < sizeof(TheftGateZone) && areaid == TheftGateZone[ TheftGarage[playerid] ]
		&& GetPlayerState(playerid) == PLAYER_STATE_DRIVER && TheftStatus[playerid] == 2)
	    {
		    if(TheftVehicle[playerid] == GetPlayerVehicleID(playerid))
		    {
		        switch(TheftGarage[playerid])
		        {
		            case 0:// СФ двор
		            {
						MoveDynamicObject(TheftGate[0], -1695.07031, 1035.61719, 47.14, 0.8, 90.0, 0.0, 90.0);
						SetTimerEx("MyMoveDynamicObject", 6000, 0, "ifffffff", TheftGate[0], -1695.18, 1035.617, 45.70, 0.8, 0.0, 0.0, 90.0);
		            }
		            case 1:// СФ порт
		            {
						MoveDynamicObject(TheftGate[1], -1790.47131, 1430.11658, 11.71660, 0.8, 0.0, 270.0, 270.0);
						SetTimerEx("MyMoveDynamicObject", 6000, 0, "ifffffff", TheftGate[1], -1790.45313, 1430.12500, 8.97660, 0.8, 0.0, 0.0, 270.0);
		            }
		            /*case 2:// ЛС гетто
		            {
						MoveDynamicObject(TheftGate[2], 2741.07031, -2004.78125, 17.09500, 0.8, 0.0, 270.0, 90.0);
						SetTimerEx("MyMoveDynamicObject", 6000, 0, "ifffffff", TheftGate[2], 2741.07031, -2004.78125, 14.87500, 0.8, 0.0, 0.0, 90.0);
		            }*/
		        }
		    }
		    else
		    {
			    ShowPlayerHint(playerid, "Это не тот автомобиль, который ты должен привезти");
		    }
		}
		return true;
	}
	else if(areaid == TheftZone2[playerid])
	{
	    MyDisablePlayerCheckpoint(playerid);
	    DestroyDynamicArea(TheftZone2[playerid]), TheftZone2[playerid] = INVALID_STREAMER_ID;
		return true;
	}

	return CONTINUE;
}

//////////	Functions	//////////
Theft_StartWork(playerid)
{
	new string[128];
	new vehicleid = GetPlayerVehicleID(playerid);
	if(PlayerInfo[playerid][pTheftTime] + THEFT_RELOAD_TIME > gettime())
    {
        format(string, sizeof(string), "До следующего угона осталось: ~y~%d мин", floatround((PlayerInfo[playerid][pTheftTime] + THEFT_RELOAD_TIME - gettime()) / 60));
		ShowPlayerHint(playerid, string, 5000);
		return false;
    }

    if(TheftStatus[playerid] > 0)
	{
		ShowPlayerHint(playerid, "У тебя уже весит текущее задание на угон, выполняй его");
	    return false;
	}

    if(vehicleid)
    {
		if(GetVehicleEngine(vehicleid))
		{
			TheftStatus[playerid] = 2;
			TheftRespawn[playerid] = false;
		    TheftVehicle[playerid] = vehicleid;
			TheftTime[playerid] = 8 * 60;
			TheftTimeOut[playerid] = 0;
			theft_timer[playerid] = SetTimerEx("TheftTimer", 1000, true, "i", playerid);

	        TheftGarage[playerid] = random(sizeof(TheftGate));
	        switch(TheftGarage[playerid])
	        {
	            case 0: MySetPlayerCheckpoint(playerid, CPJOB_AUTOTHEFT, -1686.8579, 1035.5972, 45.2109, 4.0);// Гараж СФ (в переулке)
	            case 1: MySetPlayerCheckpoint(playerid, CPJOB_AUTOTHEFT, -1790.6713, 1437.4227, 7.1875, 4.0);// Гараж СФ (в порту)
	            //case 2: { }
	        }
		    Streamer_Update(playerid);
	        ShowPlayerHint(playerid, "Отвезите этот автомобиль в ~r~гараж ~w~для угнанных авто");
			SendMissionMessage(playerid, "~n~Доставьте транспорт в ~r~гараж~w~. Осталось 10:00", 10000);
			PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
		}
		else
		{
		    // Сначала взломайте автомобиль
		}
	}
	else
	{
		// Замена автомобиля
		new v = GetRandomVehicle(playerid);
		if(v == 0)
		{
			SendLocalMessage(ACTOR[A_AUTOTHEFT], playerid, "Я не могу найти машину для твоего задания");
			printf("[WARNING]: Для %s[%d] не найдено авто для задания автоугона (Код #3273)", ReturnPlayerName(playerid), playerid);
			return false;
		}
		new Float:X, Float:Y, Float:Z, Float:A;
	    MyGetVehiclePos(v, X, Y, Z, A);
	    MyDestroyVehicle(v);
	    new vehicles[] = {429,402,411,541,415,560,559,603,475,506,451};
	    v = MyCreateVehicle(vehicles[random(sizeof(vehicles))], X, Y, Z, A, -1, -1);
	    VehInfo[v][vLocked] = 1;
	    TheftStatus[playerid] = 1;
	    TheftVehicle[playerid] = v;
	    TheftRespawn[playerid] = false;

		// Текстдрав автомобиля
		ShowWorkInfo(playerid, "", 0, "", 0, GetVehicleModel(v));
		WorkInfo_SetText(playerid, "In Wanted");
		WorkInfo_SetPreviewVehCol(playerid, CarInfo[v][cColor1], CarInfo[v][cColor2]);
		//PlayerTextDrawSetPreviewModel(playerid, InWantedTD, GetVehicleModel(v));
		//PlayerTextDrawSetPreviewVehCol(playerid, InWantedTD, CarInfo[v][cColor1], CarInfo[v][cColor2]);
		//PlayerTextDrawShow(playerid, InWantedTD);
		//PlayerTextDrawShow(playerid, InWantedInfo);

	    // Создание зоны поиска
	    new const ZoneSize = 500;
	    new Float:DoubleX = random(ZoneSize);
	    new Float:DoubleY = random(ZoneSize);
		TheftZone[playerid] = GangZoneCreate(X-DoubleX,Y-DoubleY,X+(ZoneSize-DoubleX),Y+(ZoneSize-DoubleY));
	    TheftZone2[playerid] = CreateDynamicRectangle(X-DoubleX,Y-DoubleY,X+(ZoneSize-DoubleX),Y+(ZoneSize-DoubleY), -1, -1, playerid);
		MySetPlayerCheckpoint(playerid, CPJOB_AUTOTHEFT, X - DoubleX + ZoneSize / 2, Y - DoubleY + ZoneSize / 2, 10.0, 0.0);
	    GangZoneShowForPlayer(playerid, TheftZone[playerid], 0x000000CC);
	    Streamer_Update(playerid);

		// Уведомление
		TheftTime[playerid] = 15 * 60;
		TheftTimeOut[playerid] = 0;
		theft_timer[playerid] = SetTimerEx("TheftTimer", 1000, true, "i", playerid);
		format(string, sizeof(string), "Угони автомобиль марки {80FF00}%s{E6E6E6}. Я отметил район, где такой видели поледний раз.", ReturnVehicleName(v));
		SendLocalMessage(ACTOR[A_AUTOTHEFT], playerid, string);
		PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
	}
	return true;
}

Theft_FinishWork(playerid, reason = Job.REASON_COMPLETE)
{
	if(TheftStatus[playerid] > 0)
	{
		switch(reason)
		{
			case Job.REASON_COMPLETE:
			{
				//PlayerInfo[playerid][pTheftTime] = gettime();
	            GameTextForPlayer(playerid, "~g~Mission Complete", 5000, 4);

			    // Возвращение машины
			    new vehicleid = GetPlayerVehicleID(playerid);
				if(TheftVehicle[playerid] != vehicleid)
				{
				    MyDestroyVehicle(vehicleid);
				    MyCreateVehicle(GetRandomModel(), Arr4<VehInfo[vehicleid][vPos]>, -1, -1);
				}

				// Возвращение игроков (находившихся в гараже)
		        switch(TheftGarage[playerid])
		        {
		            case 0:
		            {	// Гараж СФ (в переулке)
		                foreach(LoginPlayer, i)
		                {
		                    if(IsPlayerInRangeOfPoint(i, 10.0, -1686.8579, 1035.5972, 45.2109))
			                    MySetPlayerPos(i, -1699.1669, 1039.9766, 45.2109, 90.0);
		                }
		            }
		            case 1:
		            {	// Гараж СФ (в порту)
		                foreach(LoginPlayer, i)
		                {
		                    if(IsPlayerInRangeOfPoint(i, 10.0, -1790.6713, 1437.4227, 7.1875))
								MySetPlayerPos(playerid, -1795.3143,1424.8286,7.1875, 180.0);
		                }
		            }
		            case 2: 
		            {

		            }
		        }
			    TogglePlayerControllable(playerid, true);

			    SetCameraBehindPlayer(playerid);
				FadeColorForPlayer(playerid, 0, 0, 0, 255, 0, 0, 0, 0, 10);
			}
			case Job.REASON_TIMEOUT:
			{
				GameTextForPlayer(playerid, "~r~Mission Failed~n~~w~Time out", 5000, 4);
			}
			case Job.REASON_SPECIAL:
			{
				GameTextForPlayer(playerid, "~r~Mission Failed~n~~w~Vehicle is gone", 5000, 4);
			}
			default:
			{
				GameTextForPlayer(playerid, "~r~Mission Failed", 5000, 4);
			}
		}

		// Пересоздаем авто
		if(TheftRespawn[playerid])
		{
		    new vehid = TheftVehicle[playerid];
		    MyDestroyVehicle(vehid);
		    MyCreateVehicle(GetRandomModel(), Arr4<VehInfo[vehid][vPos]>, -1, -1);
	    }
	    else 
	    {
	    	MySetVehicleToRespawn(TheftVehicle[playerid]);	
	    }

	    // Обнуляем переменные
	    TheftStatus[playerid] 	= 0;
	    TheftVehicle[playerid] 	= 0;
	    TheftRespawn[playerid] 	= false;
	    TheftTime[playerid] 	= 0;
	    TheftTimeOut[playerid] 	= 0;

	    HideMissionMessage(playerid);
	    MyDisablePlayerCheckpoint(playerid);
	    KillTimer(theft_timer[playerid]), theft_timer[playerid] = 0;
	    GangZoneDestroy(TheftZone[playerid]), TheftZone[playerid] = 0;
		DestroyDynamicArea(TheftZone2[playerid]), TheftZone2[playerid] = INVALID_STREAMER_ID;
	}
	return true;
}

Theft_EnterCP(playerid)
{
	if(TheftStatus[playerid] == 2 && GetPlayerState(playerid) == 2 && TheftVehicle[playerid] == GetPlayerVehicleID(playerid))
    {
    	new Float:Health, Float:price,
		modelid = GetVehicleModel(TheftVehicle[playerid])-400;

	    // Выдача денег и опыта
		GetVehicleHealth(TheftVehicle[playerid], Health);
		if(VehParams[modelid][VEH_DONATE] == true)
			price = float(2 * MoneyForCoin * VehParams[modelid][VEH_PRICE]); // Donate model
		else
			price = float(VehParams[modelid][VEH_PRICE]); // Others

		price = price * Health / 1000;  // Учет повреждений
		price = price * 0.008; 			// 0.8% от стоимости

		Job.GivePlayerPartWage(playerid, (price * 0.9));
		GiveFactionMoney(F_LCN, floatround(price * 0.1));

        // Останавливаем таймер
	    HideMissionMessage(playerid);
	    MyDisablePlayerCheckpoint(playerid);
	    KillTimer(theft_timer[playerid]), theft_timer[playerid] = 0;

        // Показываем камеру перед гаражем
        switch(TheftGarage[playerid])
        {
            case 0:// СФ двор
            {
		        SetPlayerCameraPos(playerid, -1710.1085, 1035.4904, 46.7021);
		        SetPlayerCameraLookAt(playerid, -1688.8579, 1035.5972, 45.2109);
            }
            case 1:// СФ порт
            {
		        SetPlayerCameraPos(playerid, -1790.6171,1414.3281,10.9604);
		        SetPlayerCameraLookAt(playerid, -1790.6713,1437.4227,7.1875);
            }
            case 2:// ЛС гетто
            {
            }
        }
        TogglePlayerControllable(playerid, false);
        SetTimerEx("OnTheftComplete", 5000, false, "i", playerid);
    }
    return true;
}

Public: OnTheftComplete(playerid)
{
	FadeColorForPlayer(playerid, 0, 0, 0, 0, 0, 0, 0, 255, 10, FADE_THEFT);
}

Theft_StartEngine(vehicleid, playerid)
{
	// Работа автоугонщика
	foreach(LoginPlayer, i)
	{
	    if(playerid != i && TheftStatus[i] > 0 && TheftVehicle[i] == vehicleid)
	    {	// Если другой игрок угнал искомый транспорт игрока
			Job.ClearPlayerNowWork(i, Job.REASON_SPECIAL);
	    }
	}
	if(Job.GetPlayerJob(playerid) == JOB_THEFT)
	{
	    if(TheftStatus[playerid] == 1)
	    {
	        if(GetVehicleModel(TheftVehicle[playerid]) == GetVehicleModel(vehicleid))
	        {// Искомая модель заведена
				if(CarInfo[vehicleid][cType] != C_TYPE_DEFAULT || IsAvailableVehicle(vehicleid, playerid))
				{
				    ShowPlayerHint(playerid, "Этот транспорт не подходит для задания по угону");
				    return 1;
				}
	            if(TheftVehicle[playerid] != vehicleid)
				{// Если это не искомый автомобиль
				    new vehid = TheftVehicle[playerid];
				    MyDestroyVehicle(vehid);
				    MyCreateVehicle(GetRandomModel(), Arr4<VehInfo[vehid][vPos]>, -1, -1);

					TheftRespawn[playerid] = true;
					TheftVehicle[playerid] = vehicleid;
				}
	            TheftStatus[playerid] = 2;
	            TheftTimeOut[playerid] = 0;

	            HideWorkInfo(playerid);
				//PlayerTextDrawHide(playerid, InWantedTD);
				//PlayerTextDrawHide(playerid, InWantedInfo);
		        GangZoneDestroy(TheftZone[playerid]), TheftZone[playerid] = 0;

		        TheftGarage[playerid] = random(sizeof(TheftGate));
		        switch(TheftGarage[playerid])
		        {
		            case 0: MySetPlayerCheckpoint(playerid, CPJOB_AUTOTHEFT, -1686.8579, 1035.5972, 45.2109, 4.0);// Гараж СФ (в переулке)
		            case 1: MySetPlayerCheckpoint(playerid, CPJOB_AUTOTHEFT, -1790.6713, 1437.4227, 7.1875, 4.0);// Гараж СФ (в порту)
		        }
		        ShowPlayerHint(playerid, "Отвезите этот транспорт в ~r~гараж ~w~для угнанных авто");
				PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
	        }
	    }
	    else if(TheftStatus[playerid] == 0 && PlayerInfo[playerid][pTheftTime] + THEFT_RELOAD_TIME < gettime())
	    {
			if(CarInfo[vehicleid][cType] == C_TYPE_DEFAULT && !IsAvailableVehicle(vehicleid, playerid))
				ShowPlayerHint(playerid, "Нажмите ~y~2~w~ чтобы отметить гараж для угнанных авто");
	    }
	}
	return true;
}

Public: TheftTimer(playerid)
{
	if(--TheftTime[playerid] <= 0)
	{	// Кончилось общее время
		Job.ClearPlayerNowWork(playerid, Job.REASON_TIMEOUT);
		return 1;
	}
	new string[128];
	if(TheftStatus[playerid] == 1)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if(GetPlayerState(playerid) == 2 && GetVehicleModel(TheftVehicle[playerid]) == GetVehicleModel(vehicleid))
			format(string, sizeof(string), "~n~Угоните ~y~%s~w~. Осталось ~w~%02d:%02d", ReturnVehicleName(TheftVehicle[playerid]), TheftTime[playerid]/60, TheftTime[playerid]%60);
		else
			format(string, sizeof(string), "~n~Найдите ~y~%s~w~. Осталось ~w~%02d:%02d", ReturnVehicleName(TheftVehicle[playerid]), TheftTime[playerid]/60, TheftTime[playerid]%60);
		SendMissionMessage(playerid, string);
	}
	else if(TheftStatus[playerid] == 2)
	{
		if(TheftTimeOut[playerid] > 0)
		{
		    if(GetPlayerState(playerid) == 2 && TheftVehicle[playerid] == GetPlayerVehicleID(playerid))
		    {
		        TheftTimeOut[playerid] = 0;
		        return 1;
		    }
		    if(--TheftTimeOut[playerid] <= 0)
		    {	// Кончилось время возвращения за руль
		        Job.ClearPlayerNowWork(playerid, Job.REASON_TIMEOUT);
		        return 1;
		    }
			format(string, sizeof(string), "~n~~r~Вернитесь за руль! Осталось ~w~%02d:%02d", TheftTimeOut[playerid]/60, TheftTimeOut[playerid]%60);
			SendMissionMessage(playerid, string);
		}
		else
		{
			format(string, sizeof(string), "~n~Доставьте транспорт в ~r~гараж~w~. Осталось %02d:%02d", TheftTime[playerid]/60, TheftTime[playerid]%60);
			SendMissionMessage(playerid, string);
		}
	}
	return 1;
}

//////////	Dialogs 	//////////
DialogCreate:Theft_Main(playerid)	//	case DMODE_AUTOTHEFT:
{
	new string[256];
    if(Job.GetPlayerJob(playerid) == JOB_THEFT)
    {
        format(string, sizeof(string), "{80FF00}• {FFFFFF}Купить отмычку (%d$)\n\
										{80FF00}• {FFFFFF}Взять новое задание\n\
										{80FF00}• {FFFFFF}Обучение автоугону\n\
				        				{80FF00}• {FFFFFF}Уволиться с работы", PICKLOCK_PRICE);
	}
	else
	{
        format(string, sizeof(string), "{80FF00}• {FFFFFF}Устроиться на работу ($500)");
	}
	Dialog_Open(playerid, Dialog:Theft_Main, DIALOG_STYLE_LIST, "Автоугонщик", string, "Выбрать", "Закрыть");
	return true;
}

DialogResponse:Theft_Main(playerid, response, listitem, inputtext[])	//case DMODE_AUTOTHEFT:
{
    if(response)
    {
        new targetid = ACTOR[A_AUTOTHEFT];
        if(Job.GetPlayerJob(playerid) != JOB_THEFT)
        {
            if(listitem == 0) // Устроиться на работы
            {
				/*if(PlayerInfo[playerid][pTheftLic] == 0)
				{// [BT] Временно выключено, пока нет мафий
					SendLocalMessage(targetid, playerid, "Для начала покажи мне разрешение от La Cosa Nostra на эту работу");
					return Dialog_Show(playerid, Dialog:Theft_Main);
				}*/
				if(!IsAvailableJob(playerid, JOB_THEFT))
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете устроиться на работу находясь в этой фракции.");
					return Dialog_Show(playerid, Dialog:Theft_Main);
				}
				if(PlayerInfo[playerid][pLevel] < 4)
				{
			        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Эта работа доступна только с 4 уровня.");
					return Dialog_Show(playerid, Dialog:Theft_Main);
				}
				if(MyGetPlayerMoney(playerid) < 500)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вам не хватает денег для покупки этой работы (500$).");
					return Dialog_Show(playerid, Dialog:Theft_Main);
				}
				if(Job.GetPlayerJob(playerid) != JOB_NONE)
				{
					SendLocalMessage(targetid, playerid, "Уволься со своей нынешней работы, а затем приходи");
					return Dialog_Show(playerid, Dialog:Theft_Main);
				}
				if(AskPlayer(INVALID_PLAYER_ID, playerid, ASK_INVITE_JOB, 60, JOB_THEFT))
				{
					//AskAmount[playerid] = JOB_THEFT;
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "Вы собрались устроиться {FFFFFF}Автоугонщиком "ASK_CONFIRM_INFO);
					SendClientMessage(playerid, COLOR_LIGHTRED, "Без разрешения от La Cosa Nostra, стоимость устройства $500!");	//	временно
					//if(Job.GetPlayerJob(playerid) != JOB_NONE) SendClientMessage(playerid, COLOR_LIGHTRED, "Ваша нынешняя работа сбросится, если вы согласитесь!");
				}
				else
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Сначала примите или отклоните текущий запрос.");
				}
            }
            return 1;
        }

        //////////////// Для автоугонщиков ///////////////////
		switch(listitem)
		{
		    case 0: // Купить отмычку (%d$)
		    {
		        if(Job.GetPlayerJob(playerid) != JOB_THEFT)
		        {
					SendLocalMessage(targetid, playerid, "Я не продаю отмычки тем, кто не работает на меня");
					return Dialog_Show(playerid, Dialog:Theft_Main);
				}
		        if(MyGetPlayerMoney(playerid) < PICKLOCK_PRICE)
		        {
		            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас не хватает денег на покупку отмычки.");
					return Dialog_Show(playerid, Dialog:Theft_Main);
				}
				if(Inv.AddPlayerThing(playerid, THING_PICKLOCK, 1) == 0)
				{
					return Dialog_Show(playerid, Dialog:Theft_Main);
				}
				MyGivePlayerMoney(playerid, -PICKLOCK_PRICE);
		        Dialog_Show(playerid, Dialog:Theft_Main);

		    }
		    case 1: // Взять новое задание
		    {
		        if(Job.GetPlayerJob(playerid) != JOB_THEFT)
		        {
					SendLocalMessage(targetid, playerid, "Я не работаю с теми, кто не работает на меня");
					return Dialog_Show(playerid, Dialog:Theft_Main);
				}
				if(TheftStatus[playerid] > 0)
				{
					SendLocalMessage(targetid, playerid, "У тебя уже весит текущее задание на угон, выполняй его");
				    return Dialog_Show(playerid, Dialog:Theft_Main);
				}
				if(PlayerInfo[playerid][pTheftTime] + THEFT_RELOAD_TIME > gettime())
				{
					new string[128];
					SendLocalMessage(targetid, playerid, "Пока у меня нет заданий для тебя, приходи позже");
			        format(string, sizeof(string), "До следующего угона осталось: ~y~%d мин", floatround((PlayerInfo[playerid][pTheftTime] + THEFT_RELOAD_TIME - gettime()) / 60));
					ShowPlayerHint(playerid, string, 5000);
				    return Dialog_Show(playerid, Dialog:Theft_Main);
				}
				Job.SetPlayerNowWork(playerid, JOB_THEFT);
		    }
		    case 2: // Обучение автоугону
			{
				SetPVarInt(playerid, "theft_learn_page", 0);
				Dialog_Show(playerid, Dialog:Theft_Learn);
			}
		    case 3: // Уволиться с работы
		    {
				if(Job.DismissPlayer(playerid))
				{
					SendLocalMessage(targetid, playerid, "Ты больше не работаешь на меня. Желаю удачи на новом месте");
				}
				else
				{
					Dialog_Show(playerid, Dialog:Theft_Main);
				}
		    }
		}
    }
    return true;
}

DialogCreate:Theft_Learn(playerid)	//	case DMODE_AUTOTHEFT_LEARN:
{
	new lstring[1024];
	new pagenum = GetPVarInt(playerid, "theft_learn_page");
	switch(pagenum)
	{
	    case 0: // Вступительная часть
	    {
	        format(lstring, sizeof(lstring), "{80FF00}I. Вступительная часть.{FFFFFF}\n\n\
											Автоугон - это рискованное занятие, поэтому старайся {80FF00}не попадаться{FFFFFF} на глаза полиции.\n\
											Ты можешь {80FF00}угонять{FFFFFF} практически любой транспорт, но советую брать заказы именно у меня.");
	        format(lstring, sizeof(lstring), "%s\nСтарайся угонять машины {80FF00}подороже{FFFFFF} и доставлять их до места в {80FF00}хорошем состоянии{FFFFFF}.\n\
											Если убил машину во время погони, лучше {80FF00}почини{FFFFFF} ее. За разбитое корыто тебе мало заплатят.\n", lstring);
	        format(lstring, sizeof(lstring), "%s\n\
											У каждого угонщика есть правило: не угонять транспорт чаще чем {80FF00}%d минут{FFFFFF}.\n\
											Сам понимаешь, никому не нужно лишний раз светиться, да и механики должны еще разобрать ее.\n\
											Поэтому {80FF00}делай паузы{FFFFFF} между доставками. Ты поймешь, когда {80FF00}придет время{FFFFFF} для следующего угона.", lstring, THEFT_RELOAD_TIME/60);
			Dialog_Open(playerid, Dialog:Theft_Learn, DIALOG_STYLE_MSGBOX, "Обучение автоугону (1/3)", lstring, "Далее", "Закрыть");
	    }
	    case 1: // Вскрытие замка машины
	    {
			format(lstring, sizeof(lstring), "{80FF00}II. Вскрытие замка машины.{FFFFFF}\n\n\
											Первым делом нужно {80FF00}попасть в машину{FFFFFF}, для этого есть два способа: тихий и громкий.\n\
											{80FF00}Громкий способ{FFFFFF} самый простой. Ты просто подходишь к машине и {80FF00}бьешь стекло{FFFFFF} (зажать кнопку F).\n\
											Не удивляйся, если заработает сигнализация и ты {80FF00}привлечешь{FFFFFF} внимание копов.\n");

			format(lstring, sizeof(lstring), "%s\n{80FF00}Второй способ{FFFFFF} более сложный, за то тебя не станут розыскивать в первые же секунды.\n\
											Купи у меня {80FF00}набор отмычек{FFFFFF} и носи их с собой. Не переживай, они абсолютно легальны.\n\
											Подходишь к двери автомобиля, {80FF00}зажимаешь{FFFFFF} L.Alt, и начинаешь {80FF00}поворачивать отмычку{FFFFFF} (Num 4 и 6).", lstring);

			format(lstring, sizeof(lstring), "%s\n\
											Сложность заключается в том, что {80FF00}нужно подобрать комбинацию{FFFFFF} этих поворотов. Запоминай удачные!\n\
											Если ошибешься и повернешь отмычку не в ту сторону, она сломается и все {80FF00}начнется заново{FFFFFF}.", lstring);
			Dialog_Open(playerid, Dialog:Theft_Learn, DIALOG_STYLE_MSGBOX, "Обучение автоугону (2/3)", lstring, "Далее", "Закрыть");
	    }
	    case 2: // Взлом двигателя
	    {
	        format(lstring, sizeof(lstring), "{80FF00}III. Взлом замка зажигания.{FFFFFF}\n\n\
											Возможно, тебе повезло и замок автомобиля был открыт. Возможно, ты угоняешь мотоцикл.\n\
											В любом случае, ты сидишь за рулем и тебе остается взломать зажигание и {80FF00}завести{FFFFFF} транспорт.\n");
	        format(lstring, sizeof(lstring), "%s\n\
											{80FF00}Соединяй{FFFFFF} разные провода (зажимай ЛКМ) до тех пор, пока не найдешь {80FF00}провода зажигания{FFFFFF}.\n\
											Будь готов к тому, что тебя {80FF00}может ударить током{FFFFFF}, если соединишь неверные провода.\n\
											Иногда может включиться сигнализация, а иногда выключиться. Может открыться капот или багажник.\n\
											После того, двигатель заведен, {80FF00}отправляйся в гараж{FFFFFF} для угнанных авто (нажать на 2 для задания).", lstring);
			Dialog_Open(playerid, Dialog:Theft_Learn, DIALOG_STYLE_MSGBOX, "Обучение автоугону (3/3)", lstring, "Далее", "Закрыть");
	    }
	}
	return true;
}

DialogResponse:Theft_Learn(playerid, response, listitem, inputtext[])	//	case DMODE_AUTOTHEFT_LEARN
{
    if(response)
    {
        new const pagenum = GetPVarInt(playerid, "theft_learn_page");
        if(pagenum > 1)	SetPVarInt(playerid, "theft_learn_page", 0);
        else 			SetPVarInt(playerid, "theft_learn_page", pagenum + 1);
        Dialog_Show(playerid, Dialog:Theft_Learn);
    }
    else Dialog_Show(playerid, Dialog:Theft_Main);

    return true;
}