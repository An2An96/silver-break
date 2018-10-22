#if defined FACTION_POLICE_HEADER_INCLUDED
	#endinput
#endif
#define FACTION_POLICE_HEADER_INCLUDED

#define Police.				Police_

#define CopList_ADD(%0)		Iter_Add(Cop, %0)
#define CopList_REMOVE(%0)	Iter_Remove(Cop, %0)
//#define IsPoliceDuty(%0)	Iter_Contains(Cop, %0)  //  Optimize

enum
{
	//	Легкие (штраф)
	CRIME_NOT_LIGHT,
	CRIME_DRUNK,
	CRIME_NOT_LIC,
	//	Средние (арест)
	CRIME_HOOLIGAN,
	CRIME_ROBBERY_SHOP,
	CRIME_THEFT_AUTO,
	CRIME_CREATE_GUN,
	CRIME_CREATE_DRUGS,
	CRIME_RESIST,
	CRIME_CARRY_CRIMINAL,
	CRIME_HAVE_GUN,
	CRIME_THINGS,
	//	Тяжкие (арест)
	CRIME_KILL,
	CRIME_COP_KILL,
	CRIME_RUNAWAY,
	CRIME_IN_JAIL
}

enum
{
	PS_NONE,
	PS_CHECK,
	PS_WAIT,
	PS_WAIT_ACTION,
	PS_WAIT_OUT_VEH,
	PS_OUT_COMPLETE,
	PS_CRIMINAL,
}

enum E_CRIME
{
	E_TITLE[32],
	E_START_WL,		// Если меньше этого, то даст этот
	E_WL,			// Сколько будет прибавляться
	E_MAX_WL,		// Какой максимальный за нарушение
	E_SHOW_AGAIN	// Показывать информацию о преступлении при повторном совершении(кога звезд уже максимум)
}

new CrimesList[][E_CRIME] =
{
	//	Легкие (штраф)
	{ "Вождение без освещения",			1, 1, 2, false },
	{ "Вождение в пьяном виде",			3, 1, 3, false },
	{ "Вождение без лицензии",			3, 1, 3, false },
	{ "Хулиганство", 					3, 1, 3, false },
	//	Средние (арест)
	{ "Ограбление магазина",			4, 2, 6, false },
	{ "Угон автотранспорта",			4, 1, 4, false },
	{ "Изготовление оружия",			4, 1, 4, false },
	{ "Изготовление наркотиков",		4, 1, 4, false },
	{ "Оказание сопротивления",			4, 1, 4, false },
	{ "Перевозка преступника",			4, 1, 4, false },
	{ "Незаконное ношение оружия",		4, 1, 4, false },
	{ "Ношение запрещенных предметов",	4, 1, 4, false },
	//	Тяжкие (арест)
	{ "Убийство", 						4, 1, 8, false },
	{ "Нападение на сотрудника",		4, 1, 6, false },
	{ "Побег из тюрьмы",				8, 1, 8, false },
	{ "Проникновение в тюрьму",			8, 1, 8, false }
};

new PlayerCuffedTime[MAX_PLAYERS];
new CriminalMarkers[MAX_PLAYERS];
new bool:CriminalDanger[MAX_PLAYERS];    // Особо опасен (сопротивление)
new criminal_timer[MAX_PLAYERS];

new 
	PlayerText:PTD_WantedLevel,
	PlayerText:PTD_WantedStatus;
	
forward	CrimePlayer(playerid, crimeid);
forward	MySetPlayerWantedLevel(playerid, level);

//	Полицейские погони
new PursuitStatus[MAX_PLAYERS],				// Статус погони
	PursuitState[MAX_PLAYERS],				// GetPlayerState в начале погони
	PursuitCount[MAX_PLAYERS],				// Счетчик времени
	PursuitLastUNIX[MAX_PLAYERS],			// Unix последней остановки
	PursuitTickcount[MAX_PLAYERS],			// Счетчик мегафона
	bool:PursuitLamp[MAX_PLAYERS],			// Статус фар на момент остановки
	bool:PursuitCrimTransit[MAX_PLAYERS],	// Перевозит ли преступника
	bool:PursuitIllegalItem[MAX_PLAYERS],	//	Нашли ли нелегальные предметы
	bool:PursuitAllowArrest[MAX_PLAYERS],	//	Разрешено ли арестовать (розыск < 4)
	PursuitReinforc[MAX_PLAYERS],
	PursuitReinforcReload[MAX_PLAYERS],
	PursuitReinforcMapIcon[MAX_PLAYERS],
	PursuitReinforcTime[MAX_PLAYERS],
	PursuitArest[MAX_PLAYERS],
	PursuitArestPlayer[MAX_PLAYERS] = { INVALID_PLAYER_ID, ... },	//	ид игрока которого арестовывает коп
	PursuitCancelHandsup[MAX_PLAYERS],
	pursuit_timer[MAX_PLAYERS];
new Text3D:criminal_3d[MAX_PLAYERS];

enum pmInfo
{
	pmNum,      // Номер вызова
	pmType,     // Тип вызова
	pmPlace,    // Место вызова
	pmUNIX,     // Срок вызова
};
new PoliceMission[12][pmInfo];

new PM_Type[MAX_PLAYERS],// 0 - пусто, 2-4 - одиночные миссии, 10 - преследование
	PM_Step[MAX_PLAYERS],
	PM_Place[MAX_PLAYERS],
	PM_UNIX[MAX_PLAYERS],
	PM_SearchZone[MAX_PLAYERS], // CreateGangZone()
	PM_SearchZone2[MAX_PLAYERS]; // CreateDynamicRectangle()
