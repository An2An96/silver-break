#if defined _events_races_header_included
	#endinput
#endif

#define _events_races_header_included

#define RACE_MAX_TIME			5 							// Максимальная продолжительность гонки (мин)
#define RACE_PRIZE              500     					// Выйгрыш за гонку (1 место - 100%, 2 место - 50%, 3 место - 20%)
#define InRace[%0]    			Iter_Contains(Racer, %0)

//	Races
enum rInfo
{
	// Static Data (mysql)
	rID,            // raceid базы
	rName[32],		// Название гонки
	rCreater[32],	// Автор
	rRecord,		// Рекорд гонки (мс)
	rRecordBy[32],	// Автор рекорда
	// rType,		// Тип гонки - (спринт; круг; дерби; дрифт; выбывание; джимхана; радар)
	// rOutTime,	// Время на гонку (мин) - (не вижу необходимости)
	rVehicle,		// Транспорт
	// rWeather,	// Погода гонки - (пока только текущая)
	// rTime,		// Время гонки - (пока только текущее)

	// Dynamic Data
	rStatus,		// Статус гонки (Не запущена(0), Ожидание(1), Отсчет(2), Дан старт(3), Все финишировали(4))
	rAllPlayers,	// Кол-во участников на момент старта
	rPlayers,   	// Текущие кол-во участников
	rFinisher,   	// Текущие кол-во финишировавших
	//
	r_mapicon,      // (ид мап иконки)
	Text3D:r_text3d,// (ид 3д текста)
	rtimer,         // (ид таймера)
	rtick,			// Начало гонки
	rcount,         // Счетчик отсчета
	Float:rDist[MAX_PLAYERS],	// Дистанция игрока до ЧП
	rPos[MAX_PLAYERS],			// Для привязки к позиции (MAX_PLAYERS) ид игрока
	//
	cp_cache,   // Количество загруженых чекпоинтов
	sp_cache,   // Количество загруженых спавн точек
	ob_cache,   // Количество загруженых объектов
};
new RaceInfo[rInfo];

enum cpInfo
{
	cp_Type,
	Float:cp_X,
	Float:cp_Y,
	Float:cp_Z,
	Float:cp_size,
};
new RaceCP[100][cpInfo];

enum spInfo
{
	sp_Status,// closed(-1), empty(0), busy(playerid+1)
	Float:sp_x,
	Float:sp_y,
	Float:sp_z,
	Float:sp_a,
};
new RaceSpawn[20][spInfo];

enum obInfo
{
	ob_object,
	ob_modelid,
	Float:ob_X,
	Float:ob_Y,
	Float:ob_Z,
	Float:ob_rX,
	Float:ob_rY,
	Float:ob_rZ,
};
new RaceObject[100][obInfo];
new pRaceCP[MAX_PLAYERS];
new RaceZone;
new Iterator:Racer<MAX_PLAYERS>;

//	IFace
new Text:s_RaceTD[6],
	Text:tdRaceBox,
	Text:tdRaceTitle,
	Text:tdRaceLine1,
	Text:tdRaceLine2;
new PlayerText:p_RaceTD,
	PlayerText:tdRacePos,
	PlayerText:tdRaceTime;