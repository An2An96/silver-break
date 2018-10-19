#if defined _events_races_included
	#endinput
#endif

#define _events_races_included

#include "events/races/header"

//---   Race
ShowNextRaceCP(playerid, cp)
{
	new Float:nextx, Float:nexty, Float:nextz;
	if(RaceCP[cp][cp_Type] == 0 && cp < sizeof(RaceCP)-1)
	{
	    nextx = RaceCP[cp+1][cp_X];
	    nexty = RaceCP[cp+1][cp_Y];
	    nextz = RaceCP[cp+1][cp_Z];
	}
	//CreateDynamicRaceCP(RaceCP[cp][cp_Type], RaceCP[cp][cp_X], RaceCP[cp][cp_Y], RaceCP[cp][cp_Z], nextx, nexty, nextz, RaceCP[cp][cp_size], -1, -1, playerid);
	SetPlayerRaceCheckpoint(playerid, RaceCP[cp][cp_Type], RaceCP[cp][cp_X], RaceCP[cp][cp_Y], RaceCP[cp][cp_Z], nextx, nexty, nextz, RaceCP[cp][cp_size]);
}

Public: AutoStartRace()
{
	RaceStart();
	DeleteSVar("Race:AutoStart:Timer");
	return true;
}

stock RaceStart(playerid = -1, raceid = 0)
{
	if(playerid != -1 && GetPlayerAdmin(playerid) < ADMIN_ADMIN)
	{
	    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете использовать эту команду.");
	    return false;
	}
	if(RaceInfo[rStatus] != 0)
	{
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Уже запущена другая гонка.");
	    return false;
	}
	if(Iter_Count(LoginPlayer) < 4)
	{
	    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "На сервере должно быть как минимум 4 игрока, чтобы запустить гонку.");
	    return false;
	}
	if(raceid == 0)
	{	// Случайная гонка
		new Cache:result = mysql_query(g_SQL, "SELECT r1.`id` FROM `races` AS r1 JOIN ( SELECT (RAND() * (SELECT MAX(id) FROM `races`)) AS id ) AS r2 WHERE r1.id >= r2.id AND r1.created > 0 ORDER BY r1.id ASC LIMIT 1;");
		if(cache_num_rows() == 0)
		{
		    cache_delete(result);
	        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ни одной готовой гонки не найдено.");
	        return false;
	    }
	    cache_get_value_index_int(0, 0, raceid);
	    cache_delete(result);
	}
	new string[128];
	mysql_format(g_SQL, string, sizeof(string), "SELECT * FROM `races` WHERE `id` = '%d'", raceid);
	new Cache:result = mysql_query(g_SQL, string);
	new cache_count = cache_num_rows();
	if(cache_count == 0)
	{
	    cache_delete(result);
	    if(redit_id[playerid] > 0) ShowDialog(playerid, DRACE_EDIT);
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Гонки с таким raceid не существует.");
        return false;
    }
    new val;
    cache_get_value_name_int(0, "created", val);
    if(val == 0)
    {
	    cache_delete(result);
	    if(redit_id[playerid] > 0) ShowDialog(playerid, DRACE_EDIT);
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Эта гонка находится в стадии редактирования.");
        return false;
    }

    // Загрузка информации из БД
    cache_get_value_name_int(0, "id", RaceInfo[rID]);
    cache_get_value_name(0, "name", RaceInfo[rName], 32);
    cache_get_value_name_int(0, "record", RaceInfo[rRecord]);
    cache_get_value_name(0, "recordby", RaceInfo[rRecordBy], 32);
    cache_get_value_name_int(0, "vehicle", RaceInfo[rVehicle]);
    cache_delete(result);

    // Загрузка чекпоинтов
	mysql_format(g_SQL, string, sizeof(string), "SELECT * FROM `race_cp` WHERE `raceid` = '%d'", raceid);
    result = mysql_query(g_SQL, string);
    cache_count = cache_num_rows();
	if(cache_count == 0)
	{
	    cache_delete(result);
	    if(redit_id[playerid] > 0) ShowDialog(playerid, DRACE_EDIT);
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У этой гонки отсутствуют чекпоинты.");
        return false;
    }
	if(cache_count >= sizeof(RaceCP))
	{
	    cache_delete(result);
	    if(redit_id[playerid] > 0) ShowDialog(playerid, DRACE_EDIT);
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Количество чекпоинтов превышает допустимы размер, подробнее в логах.");
		printf("  ERROR! Size of RaceCP(%d) is smaller then checkpoints of race(%d)!", sizeof(RaceCP), cache_count);
        return false;
    }
    for(new cp = 0; cp < cache_count; cp++)
    {
        if(cache_count-1 == cp)	RaceCP[cp][cp_Type] = 1;
	    else 					RaceCP[cp][cp_Type] = 0;
	    cache_get_value_index_float(cp, 2, RaceCP[cp][cp_X]);
	    cache_get_value_index_float(cp, 3, RaceCP[cp][cp_Y]);
	    cache_get_value_index_float(cp, 4, RaceCP[cp][cp_Z]);
	    cache_get_value_index_float(cp, 5, RaceCP[cp][cp_size]);
    }
	RaceInfo[cp_cache] = cache_count;

    // Загрузка точек старта
	mysql_format(g_SQL, string, sizeof(string), "SELECT * FROM `race_spawn` WHERE `raceid` = '%d'", raceid);
    result = mysql_query(g_SQL, string);
    cache_count = cache_num_rows();
	if(cache_count == 0)
	{
	    cache_delete(result);
	    if(redit_id[playerid] > 0) ShowDialog(playerid, DRACE_EDIT);
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У этой гонки отсутствуют стартовые позиции.");
        return false;
    }
	if(cache_count > sizeof(RaceSpawn))
	{
	    cache_delete(result);
	    if(redit_id[playerid] > 0) ShowDialog(playerid, DRACE_EDIT);
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Количество стартовых позиций превышает допустимы размер, подробнее в логах.");
		printf("  ERROR! Size of RaceSpawn(%d) is smaller then spawns of race(%d)!", sizeof(RaceSpawn), cache_count);
        return false;
    }
    for(new sp = 0; sp < sizeof(RaceSpawn); sp++)
    {
        if(sp < cache_count)
        {
		    RaceSpawn[sp][sp_Status] = 0;
		    cache_get_value_index_float(sp, 2, RaceSpawn[sp][sp_x]);
		    cache_get_value_index_float(sp, 3, RaceSpawn[sp][sp_y]);
		    cache_get_value_index_float(sp, 4, RaceSpawn[sp][sp_z]);
		    cache_get_value_index_float(sp, 5, RaceSpawn[sp][sp_a]);
	    }
	    else RaceSpawn[sp][sp_Status] = -1;
    }
	RaceInfo[sp_cache] = cache_count;

    // Загрузка объектов
	mysql_format(g_SQL, string, sizeof(string), "SELECT * FROM `race_object` WHERE `raceid` = '%d'", raceid);
    result = mysql_query(g_SQL, string);
    cache_count = cache_num_rows();
	if(cache_count >= sizeof(RaceObject))
	{
	    cache_delete(result);
	    if(redit_id[playerid] > 0) ShowDialog(playerid, DRACE_EDIT);
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Количество объектов гонки превышает допустимы размер, подробнее в логах.");
		printf("  ERROR! Size of RaceObject(%d) is smaller then checkpoints of race(%d)!", sizeof(RaceObject), cache_count);
        return false;
    }
    for(new obj = 0; obj < cache_count; obj++)
    {
	    cache_get_value_index_int(obj, 2, RaceObject[obj][ob_modelid]);
	    cache_get_value_index_float(obj, 3, RaceObject[obj][ob_X]);
	    cache_get_value_index_float(obj, 4, RaceObject[obj][ob_Y]);
	    cache_get_value_index_float(obj, 5, RaceObject[obj][ob_Z]);
	    cache_get_value_index_float(obj, 6, RaceObject[obj][ob_X]);
	    cache_get_value_index_float(obj, 7, RaceObject[obj][ob_Y]);
	    cache_get_value_index_float(obj, 8, RaceObject[obj][ob_Z]);
	    RaceObject[obj][ob_object] = CreateDynamicObject
		(
			RaceObject[obj][ob_modelid],
			RaceObject[obj][ob_X],
			RaceObject[obj][ob_Y],
			RaceObject[obj][ob_Z],
			RaceObject[obj][ob_rX],
			RaceObject[obj][ob_rY],
			RaceObject[obj][ob_rZ]
		);
    }
	RaceInfo[ob_cache] = cache_count;

	// Обнуление массива
	RaceInfo[rStatus] = 1;// Ожидание
	RaceInfo[rPlayers] = 0;// Кол-во участников
	RaceInfo[rFinisher] = 0;// Фишинировавшие

	// Подготовка и объявление
	RaceInfo[r_mapicon] = CreateDynamicMapIcon(2695.6345, -1704.6891, 11.8438, 33, 0, 0, -1, -1, 20000.0, MAPICON_GLOBAL);
	format(string, 128, "{80FF00}Текущая гонка\n{DABB3E}Название: '{FFFFFF}%s{DABB3E}'\nТип гонки: {FFFFFF}Спринт", RaceInfo[rName]);
	RaceInfo[r_text3d] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, 2695.6345, -1704.6891, 11.8438 + 1.0, 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0);
    RaceInfo[rcount] = 10; // Старт гонки (в минутах)
	RaceInfo[rtimer] = SetTimer("RaceTimer", 100, false);
	return true;// Успешный запуск
}

Public: RaceTimer()
{
	new string[128];
	if(RaceInfo[rStatus] == 1)
	{
	    if(RaceInfo[rcount] > 0)
	    {
	        switch(RaceInfo[rcount])
	        {
				case 15, 10, 5, 3, 2, 1: SendFormatMessageToAll(COLOR_EVENT, string, "[Ивент]: Гонка '%s' начнется через %d минут на стадионе (место отмечено на радаре)", RaceInfo[rName], RaceInfo[rcount]);
			}
	        RaceInfo[rcount]--;
			RaceInfo[rtimer] = SetTimer("RaceTimer", 60 * 1000, false);
	        return 1;
	    }
		// Закончилось ожидание
	    // Удалить старт гонки
	    DestroyDynamicMapIcon(RaceInfo[r_mapicon]), 	RaceInfo[r_mapicon] = INVALID_STREAMER_ID;
		DestroyDynamic3DTextLabel(RaceInfo[r_text3d]),	RaceInfo[r_text3d] = Text3D:INVALID_STREAMER_ID;
		RaceInfo[rAllPlayers] = RaceInfo[rPlayers];

		if(RaceInfo[rPlayers] < 4)
		{
		    foreach(LoginPlayer, i)
			{
			    if(InRace[i]) RaceLeave(i);
			}
			SendClientMessageToAll(COLOR_EVENT, "[Ивент]: Гонка так и не началась - почти никто не доехал");
	        RaceInfo[rStatus] = 4;
	        RaceTimer();
		}
		else
		{// Запустить отсчет для гонщиков
		    foreach(Racer, i)
		    {
				//HidePlayerHint(i);
				TogglePlayerControllable(i, false);
				SetCameraBehindPlayer(i);
				SetVehicleEngine(GetPlayerVehicleID(i), true);
		    }
		    RaceInfo[rStatus] = 2;
		    RaceInfo[rcount] = 6;
		    RaceInfo[rtimer] = SetTimer("RaceTimer", 1000, true);
	    }
	}
	else if(RaceInfo[rStatus] == 2)
	{// Идет отсчет
	    if(--RaceInfo[rcount] <= 0)
	    {// Начинаем гонку

	    	format(string, sizeof(string), "/%d", Iter_Count(Racer));
	    	TextDrawSetString(s_RaceTD[4], string);
			TextDrawSetString(s_RaceTD[5], "00:00");
		    foreach(Racer, i)
		    {
			    GameTextForPlayer(i, "~g~GO GO GO", 1000, 4);
			    PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
			    TogglePlayerControllable(i, true);
			    ShowNextRaceCP(i, pRaceCP[i]);

			    TextDrawShowForPlayer(i, s_RaceTD[0]);
				TextDrawShowForPlayer(i, s_RaceTD[1]);
				TextDrawShowForPlayer(i, s_RaceTD[2]);
				TextDrawShowForPlayer(i, s_RaceTD[3]);
				TextDrawShowForPlayer(i, s_RaceTD[4]);
				TextDrawShowForPlayer(i, s_RaceTD[5]);

				PlayerTextDrawSetString(i, p_RaceTD, "1");
				PlayerTextDrawShow(i, p_RaceTD);
		    }
		    RaceInfo[rStatus] = 3;
		    RaceInfo[rcount] = 0;
		    RaceInfo[rtick] = GetTickCount();
	    }
	    else
	    {
		    format(string, 128, "~r~%d", RaceInfo[rcount]);
		    foreach(Racer, i)
		    {
			    GameTextForPlayer(i, string, 3000, 4);
			    PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
		    }
	    }
	}
	else if(RaceInfo[rStatus] == 3)
	{// Идет гонка
	    if(++RaceInfo[rcount] >= RACE_MAX_TIME * 60)
	    {// Время вышло, заканчиваем гонку
	        foreach(LoginPlayer, i)
			{
			    if(InRace[i]) GameTextForPlayer(i, RusText("~r~Гонка завершена~n~~w~Время вышло", isRus(i)), 3000, 4);
			}
			SendClientMessageToAll(COLOR_EVENT, "[Ивент]: Все гонщики выбыли - гонка завершена!");
	        RaceStop();
	        return 1;
        }
        // Расчет позиции гонщика
        // 1. Получаем дистанцию до ЧП
        new idx = 0;
        foreach(Racer, i)
        {
            RaceInfo[rPos][idx++] = i;
            RaceInfo[rDist][i] = -pRaceCP[i] * 10000 + GetDistanceFromMeToPoint(i, RaceCP[pRaceCP[i]][cp_X], RaceCP[pRaceCP[i]][cp_Y], RaceCP[pRaceCP[i]][cp_Z]);
        }
        // 2. Сортируем
		new const count = Iter_Count(Racer);
		for(new c, i; i < count - 1; i++)
		{
		    for(new j; j < count - i - 1; j++)
		    {
			    if(RaceInfo[rDist][ RaceInfo[rPos][j] ] > RaceInfo[rDist][ RaceInfo[rPos][j + 1] ])
			    {
			        c = RaceInfo[rPos][j];
			        RaceInfo[rPos][j] = RaceInfo[rPos][j+1];
			        RaceInfo[rPos][j+1] = c;
			    }
		    }
		}
		// 3. Выводим
		new time[20];
		format(time, sizeof(time), "%02d:%02d", RaceInfo[rcount] / 60, RaceInfo[rcount] % 60);
		TextDrawSetString(s_RaceTD[5], time);
		for(new i; i < count; i++)
		{
          	format(string, sizeof(string), "%d", i + RaceInfo[rFinisher] + 1);
			PlayerTextDrawSetString(RaceInfo[rPos][i], p_RaceTD, string);
		}
	}
	else if(RaceInfo[rStatus] == 4)
	{// Завершение гонки
	    RaceStop();
	}
	return 1;
}

RaceStop()
{
	if(RaceInfo[rStatus] != 0)
	{
	    if(RaceInfo[rtimer] > 0)						KillTimer(RaceInfo[rtimer]), RaceInfo[rtimer] = 0;
		DestroyDynamicMapIcon(RaceInfo[r_mapicon]), 	RaceInfo[r_mapicon] = INVALID_STREAMER_ID;
		DestroyDynamic3DTextLabel(RaceInfo[r_text3d]), 	RaceInfo[r_text3d] = Text3D:INVALID_STREAMER_ID;
	    // Удаление объектов
	    for(new obj = 0; obj < RaceInfo[ob_cache]; obj++)
	    {
		    DestroyDynamicObject(RaceObject[obj][ob_object]), RaceObject[obj][ob_object] = INVALID_STREAMER_ID;
	    }
	    foreach(Racer, i) RaceLeave(i);
		RaceInfo[rStatus] = 0;
	}
}

stock RaceLeave(playerid, bool:finish = false)
{
	if(InRace[playerid])
	{
		Iter_Remove(Racer, playerid);// Очищаем из списка
		MyDestroyVehicle(GetPVarInt(playerid, "Race:Player:VehicleID"));
		DeletePVar(playerid, "Race:Player:VehicleID");
		TogglePlayerControllable(playerid, true);
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerVirtualWorld(playerid, 0);
		MySetPlayerPos(playerid, 2692.1, -1699.7, 10.4, 33.0);

		TextDrawHideForPlayer(playerid, s_RaceTD[0]);
		TextDrawHideForPlayer(playerid, s_RaceTD[1]);
		TextDrawHideForPlayer(playerid, s_RaceTD[2]);
		TextDrawHideForPlayer(playerid, s_RaceTD[3]);
		TextDrawHideForPlayer(playerid, s_RaceTD[4]);
		TextDrawHideForPlayer(playerid, s_RaceTD[5]);

		PlayerTextDrawHide(playerid, p_RaceTD);

		RaceInfo[rPlayers] -= 1;
		if(RaceInfo[rStatus] == 1)
		{	// Ожидание игроков
		    for(new sp = 0; sp < sizeof(RaceSpawn); sp++)
		    {
		        if(RaceSpawn[sp][sp_Status] == playerid+1)
		        {
				    RaceSpawn[sp][sp_Status] = 0;
		        }
		    }
		    //HidePlayerHint(playerid);
		}
		else if(RaceInfo[rStatus] != 0 && RaceInfo[rPlayers] <= 0 && finish == false)
		{	// Завершаем гонку
			SendClientMessageToAll(COLOR_EVENT, "[Ивент]: Все гонщики выбыли - гонка завершена!");
	        RaceStop();
		}
	}
}

UnixToRaceTime(time)
{
	new string[32], minute = time/60000, second = time%60000;
	format(string, 32, "%02d:%02d.%03d", minute, second/1000, second%1000);
	return string;
}

ShowRaceResult(playerid, position, time)
{
	new string[32];
	switch(position)
	{
		case 1: string = "ST";
		case 2: string = "ND";
		case 3: string = "RD";
		default: string = "TH";
	}
	format(string, 32, "%d%s", position, string);
	tdRacePos = CreatePlayerTextDraw(playerid, 409.0, 327.0, string);
	PlayerTextDrawAlignment(playerid, tdRacePos, 3);
	PlayerTextDrawBackgroundColor(playerid, tdRacePos, 255);
	PlayerTextDrawFont(playerid, tdRacePos, 1);
	PlayerTextDrawLetterSize(playerid, tdRacePos, 0.5, 2.5);
	PlayerTextDrawColor(playerid, tdRacePos, -1347440641);
	PlayerTextDrawSetOutline(playerid, tdRacePos, 0);
	PlayerTextDrawSetProportional(playerid, tdRacePos, 1);
	PlayerTextDrawSetShadow(playerid, tdRacePos, 2);
	PlayerTextDrawSetSelectable(playerid, tdRacePos, 0);
	PlayerTextDrawShow(playerid, tdRacePos);

	tdRaceTime = CreatePlayerTextDraw(playerid, 410.0, 357.0, UnixToRaceTime(time));
	PlayerTextDrawAlignment(playerid, tdRaceTime, 3);
	PlayerTextDrawBackgroundColor(playerid, tdRaceTime, 255);
	PlayerTextDrawFont(playerid, tdRaceTime, 1);
	PlayerTextDrawLetterSize(playerid, tdRaceTime, 0.5, 2.5);
	PlayerTextDrawColor(playerid, tdRaceTime, -1347440641);
	PlayerTextDrawSetOutline(playerid, tdRaceTime, 0);
	PlayerTextDrawSetProportional(playerid, tdRaceTime, 1);
	PlayerTextDrawSetShadow(playerid, tdRaceTime, 2);
	PlayerTextDrawSetSelectable(playerid, tdRaceTime, 0);
	PlayerTextDrawShow(playerid, tdRaceTime);

	TextDrawShowForPlayer(playerid, tdRaceBox);
	TextDrawShowForPlayer(playerid, tdRaceTitle);
	TextDrawShowForPlayer(playerid, tdRaceLine1);
	TextDrawShowForPlayer(playerid, tdRaceLine2);

	SetTimerEx("HideRaceResult", 5000, false, "i", playerid);
}

Public: HideRaceResult(playerid)
{
	PlayerTextDrawDestroy(playerid, tdRacePos);
	PlayerTextDrawDestroy(playerid, tdRaceTime);

	TextDrawHideForPlayer(playerid, tdRaceBox);
	TextDrawHideForPlayer(playerid, tdRaceTitle);
	TextDrawHideForPlayer(playerid, tdRaceLine1);
	TextDrawHideForPlayer(playerid, tdRaceLine2);
}

ShowPlayerEditCP(playerid, cpnum)
{
	if(cpnum < 1 || cpnum >= sizeof(RaceCP)) return 0;

	new string[256];
    format(string, 256, "SELECT `id`, `x`, `y`, `z`, `size` FROM `race_cp` WHERE `raceid` = '%d' LIMIT %d,2", redit_id[playerid], cpnum-1);
	new Cache:result = mysql_query(g_SQL, string);
	new id, cache_count = cache_num_rows();
	new Float:pos[2][3];
	if(cache_count > 1)
	{// Более одного чекпоинта
		cache_get_value_name_float(0, "x", pos[0][0]);
		cache_get_value_name_float(0, "y", pos[0][1]);
		cache_get_value_name_float(0, "z", pos[0][2]);
		cache_get_value_name_float(0, "size", redit_size[playerid]);
		cache_get_value_name_float(0, "x", pos[1][0]);
		cache_get_value_name_float(0, "y", pos[1][1]);
		cache_get_value_name_float(0, "z", pos[1][2]);
		SetPlayerRaceCheckpoint(playerid, 0, Arr3<pos[0]>, Arr3<pos[1]>, redit_size[playerid]);
	    cache_get_value_name_int(0, "id", id);
	}
	else if(cache_count > 0)
	{// Один чекпоинт, финиш
		cache_get_value_name_float(0, "x", pos[0][0]);
		cache_get_value_name_float(0, "y", pos[0][1]);
		cache_get_value_name_float(0, "z", pos[0][2]);
		cache_get_value_name_float(0, "size", redit_size[playerid]);
		SetPlayerRaceCheckpoint(playerid, 1, Arr3<pos[0]>, 0.0, 0.0, 0.0, redit_size[playerid]);
	    cache_get_value_name_int(0, "id", id);
	}
	else id = 0;
	//---
	cache_delete(result);
	return id;
}

IFace.Race_Create_Base()
{
	tdRaceBox = TextDrawCreate(435.000000, 310.0, "_");
	TextDrawBackgroundColor(tdRaceBox, 255);
	TextDrawFont(tdRaceBox, 3);
	TextDrawLetterSize(tdRaceBox, 0.740000, 8.799999);
	TextDrawColor(tdRaceBox, 799);
	TextDrawSetOutline(tdRaceBox, 0);
	TextDrawSetProportional(tdRaceBox, 1);
	TextDrawSetShadow(tdRaceBox, 1);
	TextDrawUseBox(tdRaceBox, 1);
	TextDrawBoxColor(tdRaceBox, 170);
	TextDrawTextSize(tdRaceBox, 205.0, 0.0);

	tdRaceTitle = TextDrawCreate(221.000000, 290.0, "Finished!");
	TextDrawBackgroundColor(tdRaceTitle, 255);
	TextDrawFont(tdRaceTitle, 0);
	TextDrawLetterSize(tdRaceTitle, 1.0, 3.0);
	TextDrawColor(tdRaceTitle, -1);
	TextDrawSetOutline(tdRaceTitle, 1);
	TextDrawSetProportional(tdRaceTitle, 1);

	tdRaceLine1 = TextDrawCreate(223.000000, 330.0, "Position:");
	TextDrawBackgroundColor(tdRaceLine1, 255);
	TextDrawFont(tdRaceLine1, 1);
	TextDrawLetterSize(tdRaceLine1, 0.46, 2.0);
	TextDrawColor(tdRaceLine1, 0xB1C8FFFF);
	TextDrawSetOutline(tdRaceLine1, 0);
	TextDrawSetProportional(tdRaceLine1, 1);
	TextDrawSetShadow(tdRaceLine1, 1);

	tdRaceLine2 = TextDrawCreate(223.000000, 360.0, "Time:");
	TextDrawBackgroundColor(tdRaceLine2, 255);
	TextDrawFont(tdRaceLine2, 1);
	TextDrawLetterSize(tdRaceLine2, 0.46, 2.0);
	TextDrawColor(tdRaceLine2, 0xB1C8FFFF);
	TextDrawSetOutline(tdRaceLine2, 0);
	TextDrawSetProportional(tdRaceLine2, 1);
	TextDrawSetShadow(tdRaceLine2, 1);

	s_RaceTD[0] = TextDrawCreate(575.0, 320.0, "1");
	TextDrawAlignment(s_RaceTD[0], 2);
	TextDrawLetterSize(s_RaceTD[0], 0.0, 5.1);
	TextDrawUseBox(s_RaceTD[0], 1);
	TextDrawBoxColor(s_RaceTD[0], 85);
	TextDrawTextSize(s_RaceTD[0], 0.0, 49.0);

	s_RaceTD[1] = TextDrawCreate(575.0, 322.0, "2");
	TextDrawAlignment(s_RaceTD[1], 2);
	TextDrawLetterSize(s_RaceTD[1], 0.0, 4.6);
	TextDrawUseBox(s_RaceTD[1], 1);
	TextDrawBoxColor(s_RaceTD[1], -1312228523);
	TextDrawTextSize(s_RaceTD[1], 0.0, 45.0);

	s_RaceTD[2] = TextDrawCreate(575.0, 324.0, "3");
	TextDrawAlignment(s_RaceTD[2], 2);
	TextDrawLetterSize(s_RaceTD[2], 0.0, 4.2);
	TextDrawUseBox(s_RaceTD[2], 1);
	TextDrawBoxColor(s_RaceTD[2], 255);
	TextDrawTextSize(s_RaceTD[2], 0.0, 42.0);

	s_RaceTD[3] = TextDrawCreate(575.0, 320.0, "RD");
	TextDrawBackgroundColor(s_RaceTD[3], 255);
	TextDrawFont(s_RaceTD[3], 1);
	TextDrawLetterSize(s_RaceTD[3], 0.41, 2.0);
	TextDrawColor(s_RaceTD[3], -1312228438);
	TextDrawSetShadow(s_RaceTD[3], 1);

	s_RaceTD[4] = TextDrawCreate(575.0, 335.0, "/4");
	TextDrawBackgroundColor(s_RaceTD[4], 255);
	TextDrawFont(s_RaceTD[4], 1);
	TextDrawLetterSize(s_RaceTD[4], 0.41, 1.6);
	TextDrawColor(s_RaceTD[4], -1312228438);
	TextDrawSetOutline(s_RaceTD[4], 0);
	TextDrawSetProportional(s_RaceTD[4], 1);
	TextDrawSetShadow(s_RaceTD[4], 1);

	s_RaceTD[5] = TextDrawCreate(589.0, 345.0, "00:00");
	TextDrawAlignment(s_RaceTD[5], 3);
	TextDrawBackgroundColor(s_RaceTD[5], 255);
	TextDrawFont(s_RaceTD[5], 1);
	TextDrawLetterSize(s_RaceTD[5], 0.41, 2.0);
	TextDrawColor(s_RaceTD[5], -1312228438);
	TextDrawSetProportional(s_RaceTD[5], 1);
	TextDrawSetShadow(s_RaceTD[5], 1);

}

IFace.Race_Create_Player(playerid)
{
	p_RaceTD = CreatePlayerTextDraw(playerid, 555.0, 315.0, "1");
	PlayerTextDrawBackgroundColor(playerid, p_RaceTD, 255);
	PlayerTextDrawFont(playerid, p_RaceTD, 1);
	PlayerTextDrawLetterSize(playerid, p_RaceTD, 1.01, 4.1);
	PlayerTextDrawColor(playerid, p_RaceTD, -1312228438);
	PlayerTextDrawSetProportional(playerid, p_RaceTD, 1);
	PlayerTextDrawSetShadow(playerid, p_RaceTD, 1);
}

//	Commands
COMMAND:nitro(playerid, params[])
{
	if(!InRace[playerid])
	{
	    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Эта команда используется только во время гонок.");
	    return 1;
	}
	new vehicleid = GetPlayerVehicleID(playerid);
	switch(VehInfo[vehicleid][vModelType])
	{
	    case MTYPE_RC, MTYPE_BIKE, MTYPE_MOTO, MTYPE_BOAT, MTYPE_HELIC:
	    {
	        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете купить нитро на этот транспорт.");
	    }
	}
    if(GetPlayerCoins(playerid) < 5)
    {
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вам не хватает монет для покупки.");
    }
    GivePlayerCoins(playerid, -5);
    AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
	SendClientMessage(playerid, COLOR_EVENT, "[Ивент]: Вы купили нитро за 5 монет. Оно пропадет при выходе из гонки");
	return 1;
}

flags:race(CMD_DEVELOPER);
COMMAND:race(playerid, params[])
{
	new string[128];
    if(redit_act[playerid] == 2)
    {// Редактирование спавн точек
	    redit_act[playerid] = 0;
	    ShowDialog(playerid, DRACE_EDIT);
		format(string, 128, "Гонка #%d: Создание спавн точек завершено", redit_id[playerid]);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
		return 1;
    }
    if(redit_act[playerid] == 3)
    {// Редактирование чекпоинтов
	    redit_act[playerid] = 0;
	    ShowDialog(playerid, DRACE_EDIT);
		DisablePlayerRaceCheckpoint(playerid);
		format(string, 128, "Гонка #%d: Создание чекпоинтов завершено", redit_id[playerid]);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
		return 1;
    }

    new raceid;
    if(sscanf(params, "i", raceid))
    {// raceid не указан
        ShowDialog(playerid, DRACE_MAIN);
        return 1;
    }
    new count;
	mysql_format(g_SQL, string, sizeof(string), "SELECT COUNT(*) AS count FROM `races` WHERE `id` = '%d'", raceid);
	new Cache:result = mysql_query(g_SQL, string);
	cache_get_value_name_int(0, "count", count);
	if(!count)
	{
	    cache_delete(result);
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Гонки с таким raceid не существует.");
    }
    redit_id[playerid] = raceid;
    ShowDialog(playerid, DRACE_EDIT);
    cache_delete(result);
    return 1;
}

flags:raceclear(CMD_DEVELOPER);
COMMAND:raceclear(playerid, params[])
{// [BT]
	new string[128];
	mysql_query(g_SQL, "SET FOREIGN_KEY_CHECKS = 0");
	mysql_query(g_SQL, "TRUNCATE TABLE `races`");
	mysql_query(g_SQL, "TRUNCATE TABLE `race_cp`");
	mysql_query(g_SQL, "TRUNCATE TABLE `race_spawn`");
	mysql_query(g_SQL, "TRUNCATE TABLE `race_object`");
	mysql_query(g_SQL, "SET FOREIGN_KEY_CHECKS = 1");
	format(string, 128, "[AdmCmd]: Админ %s[%d] полностью и безвозвратно удалил все гонки", ReturnPlayerName(playerid), playerid);
	SendAdminMessage(COLOR_LIGHTRED, string);
    return 1;
}

flags:racenum(CMD_DEVELOPER);
COMMAND:racenum(playerid, params[])
{
    new string[128];
	if(redit_act[playerid] == 2)
	{// Спавн точки
	    new newnum;
		if(sscanf(params, "i", newnum))
		    return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /racenum [spnum]");
		if(!(0 < newnum < sizeof(RaceSpawn)))
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Неверный номер спавн точки.");
	    mysql_format(g_SQL, string, sizeof(string), "SELECT `x`,`y`,`z`,`a`,`id` FROM `race_spawn` WHERE `raceid` = '%d' LIMIT %d,%d", redit_id[playerid], newnum-1, sizeof(RaceSpawn));
		new Cache:result = mysql_query(g_SQL, string);
		if(!cache_num_rows())
		{
		    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Спавн точка с этим номером еще не создана.");
		    cache_delete(result);
		    return 1;
		}
		new vehicleid = GetPlayerVehicleID(playerid);
		new Float:pos[4];
		cache_get_value_name_float(0, "x", pos[0]);
		cache_get_value_name_float(0, "y", pos[1]);
		cache_get_value_name_float(0, "z", pos[2]);
		cache_get_value_name_float(0, "a", pos[3]);
		if(vehicleid > 0) MySetVehiclePos(vehicleid, Arr4<pos>);
		else 			  MySetPlayerPos(playerid, Arr4<pos>);
		cache_delete(result);
		SendClientMessage(playerid, COLOR_YELLOW, "При нажатии на действие будет создана НОВАЯ точка спавна");
	    return 1;
	}
	if(redit_act[playerid] == 3)
	{// Чекпоинты
	    new newnum;
		if(sscanf(params, "i", newnum))
		    return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /racenum [cpnum]");
		if(!(0 < newnum < sizeof(RaceCP)))
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Неверный номер чекпоинта.");

		new curid = ShowPlayerEditCP(playerid, newnum);
		if(curid == 0)
		{
		    ShowPlayerEditCP(playerid, redit_num[playerid]);
		    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Чекпоинт с этим номером еще не создан.");
		    return 1;
		}
		redit_previd[playerid] = 0;
		redit_curid[playerid] = curid;
		redit_num[playerid] = newnum;
	    /*mysql_format(g_SQL, string, sizeof(string), "SELECT `x`, `y`, `z` FROM `race_cp` WHERE `id` = '%d'", redit_curid[playerid]);
		new Cache:result = mysql_query(g_SQL, string);
		new vehicleid = GetPlayerVehicleID(playerid);
		if(vehicleid > 0) MySetVehiclePos(vehicleid, cache_get_row_float(0, 0), cache_get_row_float(0, 1), cache_get_row_float(0, 2));
		else 			  MySetPlayerPos(playerid, cache_get_row_float(0, 0), cache_get_row_float(0, 1), cache_get_row_float(0, 2));
		cache_delete(result);*/
		return 1;
	}
	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы ничего не редактируете.");
}