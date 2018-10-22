#include <easy_keys>

forward OnActorReaction(playerid, targetid);

enum
{
	A_Truth,
	A_EMMET,
	//	Job
	//A_GUNDEAL,
	//A_DRUGDEAL,
	A_AUTOTHEFT,
	//  Prison NPC
	A_PRISONMAN1,
	A_PRISONMAN2,
	A_PRISONMAN3,
	//	City Hall
	A_CITYHALL1,
	A_CITYHALL2,
	//  LSPD
	A_POLICE_GUNDEALER,
	A_POLICE_DUTY,
	A_POLICE_DUTY2,
	A_POLICE_DUTY3,
	A_POLICE_MAN1,
	A_POLICE_MAN2,
	////////
	A_HOSPITAL,
	A_HOTDOGER,
	A_HOTDOGER2,
	A_HOTDOGER3,
	A_BANK,
	A_NEWBIE,
	A_DEREK,
	A_STEVE,
	A_AUTOSCHOOL,
	//	Airport
	A_AIRPORT1,
	A_AIRPORT2,
	A_AIRPORT3,
	A_AIRPORT4,
	A_AIRPORT5,
	A_AIRPORT6,
	A_AIRPORT7,
	A_AIRPORT8,
	A_AIRPORT9,
	A_AIRPORT10,
	A_AIRPORT11,
	A_AIRPORT12,
	A_AIRPORT13,
	//
	A_CITYZEN1,
	A_CITYZEN2,
	A_CITYZEN3,
	A_CITYZEN4,
	A_CITYZEN5,
	A_CITYZEN6,
	A_CITYZEN7,
	A_CITYZEN8,
	A_CITYZEN9,
	A_CITYZEN10,
	A_CITYZEN11,
	A_CITYZEN12,
	//
	A_WORKER1,
	A_WORKER2,
	A_WORKER3,
	A_WORKER4,
	A_WORKER5,
	A_WORKER6,
};

enum actor_Data
{
	a_Name[24],		//  имя
	a_Skin,			//  скин
	Float:a_Pos[4],	//  позиция
	a_VW,			//  вирт мир
	a_AnimLib[16],	//	Анимация
	a_AnimName[24],	//	Анимация
	bool:a_Nametag,	//  показывать ли имя
	bool:a_Hint,    //  показывать ли подсказку (как говорить)
};
new const ActorInfo[][actor_Data] =
{
	{	"The_Truth",		1,
		{ -1097.82, -1629.952,	76.4, 	270.0 },	VW_NONE,
		"",				"",					true, true },
	{	"Emmet",		  	6,
		{ 2451.031, -1972.768,	13.6, 	255.0 }, 	VW_NONE,
		"",				"",					true, true },
	//	Актеры дающие работу
	// {	"Торговец оружием",	46,
	// 	{ 1268.0101, -819.3066, 84.1406, 0.0 },		VW_NONE,
	//	"",				"",					true, true },
	// {	"Наркодиллер",		123,
	// 	{ 688.9843, -1271.3917, 13.558, 90.0 },		VW_NONE,
	//	"",				"",					true, true },
	{	"Автоугонщик",		124,
		{ 1240.1600, -2047.200, 60.00, 270.0 },		VW_NONE,
		"",				"",					true, true },
	//	Актеры в тюрьме
	{	"Надзиратель", 		287,
		{ 573.9, -2653.4, 29.3, 131.9 },			VW_NONE,
		"",				"",					false, false },
	{	"Надзиратель", 		287,
		{ 560.6, -2810.9, 29.3, 56.47 },			VW_NONE,
		"",				"",					false, false },
	{	"Надзиратель", 		287,
		{ 551.8, -2708.6, 29.3, 141.3 },			VW_NONE,
		"",				"",					false, false },
	//	Актеры в мерии
	{	"Секретарь",		169,
		{ 1568.78, -1567.89, 1001.1, 90.0 },		VW_CITYHALL,
		"PED",			"SEAT_idle",		false, false },
	{	"Трудоустройство",	150, 
		{ 1592.6, -1567.3, 1004.6, 90.0 },			VW_CITYHALL,
		"PED",			"SEAT_idle",		true, true },
	//  Актеры в полиции
	// Оружейка ментов
	{	"Продавец",			280,
		{ 311.80, -167.76, 999.5, 0.0 },			VW_LSPD,
		"",				"",					false, true },	
	// Внутри участка
	{	"Дежурный",			267,
		{ 251.90, 67.65, 1003.64, 90.0 },			VW_LSPD,
		"",				"",					true, true },	
	// Возле шлакбаума
	{	"Дежурный",			267,
		{ 1544.20,-1631.89,13.38, 360.0 },			VW_NONE,
		"",				"",					false, false },	
	// В будке возле ворот
	{	"Дежурный",			267,
		{ 1580.34,-1634.82,13.56, 360.0 },			VW_NONE,
		"",				"",					false, false },	
	{	"Полицейский",		280,
		{ 1544.98, -1669.46, 13.55, 126.2 },		VW_NONE,
		"",				"",					false, false },
	{	"Полицейский",		281,
		{ 1544.18, -1670.37, 13.55, 312.9 },		VW_NONE,
		"PED",			"IDLE_CHAT",		false, false },
	//////////
	//	Медсестра в больнице
	{	"Медсестра",		308,
		{ -2636.68, 622.30, 1274.26, 0.0 },			VW_HOSPITAL,
		"",				"",					true, false },
	//	Ларек на спавне
	{	"Продавец",			209,
		{ 959.64, -1640.87, 13.5, 90.00 },			VW_NONE,
		"",				"",					true, true },
	//	Ларек на вокзале
	{	"Продавец",			209,
		{ 2182.0, -2265.40, 13.4, 270.0 },			VW_NONE,
		"",				"",					true, true },
	//	Ларек на вокзале
	{	"Продавец",			209,
		{ -1037.4, -1193.6, 129.2, 90.0 },			VW_NONE,
		"",				"",					true, true },
	//	Оператор в банке
	{	"Оператор",			172,
		{ 2144.55, 1624.52, 993.69, 180.0},			VW_BANK,
		"",				"",					true, true },
	//	Бот для начальных миссий
	{	"Джейсон",			46,
		{ 2222.9, -1152.70, 1025.8, 30.0 },			VW_HOTEL,
		"",				"",					true, true },
	//	Подработка грузчиком
	{	"Дерек",			258,
		{ 2123.99, -2274.06, 20.67, 226.85 },		VW_NONE,
		"ped",			"SEAT_idle",		true, true },
	//	Подработка грузчиком
	{	"Стив",				34,
		{ 2152.86, -2267.39, 13.30, 4.5 },			VW_NONE,
		"DEALER",		"DEALER_IDLE",		false, false },
	//	Автошкола
	{	"Инструктор",		171,
		{ -2034.7, -117.92, 1035.17, 275.0 },		VW_AUTOSCHOOL,
		"",				"",					true, false },
	//	аэро
	{	"Оператор",			11,
		{ 1682.45, -2353.10, 13.54, 5.0647 },		VW_AIRPORT,
		"ped",			"SEAT_idle",		false, false },
	{	"Оператор",			219,
		{ 1685.45, -2353.00, 13.54, 5.4015 },		VW_AIRPORT,
		"ped",			"SEAT_idle",		false, false },
	{	"Оператор",			194,
		{ 1688.30, -2353.10, 13.54, 4.7984 },		VW_AIRPORT,
		"ped",			"SEAT_idle",		false, false },
	{	"Охранник",			71,
		{ 1665.63, -2355.72, 13.54, 358.09 },		VW_AIRPORT,
		"PED",			"SEAT_idle",		false, false },
	{	"Охранник",			71,
		{ 1664.47, -2365.23, 13.54, 358.09 },		VW_AIRPORT,
		"INT_OFFICE",	"OFF_Sit_Bored_Loop",	false, false },
	{	"Охранник",			71,
		{ 1665.28, -2347.35, 13.54, 358.09 },		VW_AIRPORT,
		"PED",			"SEAT_idle",		false, false },
	{	"Охранник",			71,
		{ 1676.43, -2339.16, 13.55, 220.22 },		VW_AIRPORT,
		"DEALER",		"DEALER_IDLE",		false, false },
	{	"Житель",			94,
		{ 1681.40, -2342.39, 13.54, 181.83 },		VW_AIRPORT,
		"ped",			"SEAT_idle",		false, false },
	{	"Житель",			101,
		{ 1679.69, -2345.17, 13.54, 181.83 },		VW_AIRPORT,
		"ped",			"SEAT_idle",		false, false },
	{	"Житель",			170,
		{ 1691.21, -2345.12, 13.54, 181.83 },		VW_AIRPORT,
		"ped",			"SEAT_idle",		false, false },
	{	"Житель",			148,
		{ 1689.58, -2342.43, 13.54, 181.83 },		VW_AIRPORT,
		"ped",			"SEAT_idle",		false, false },
	{	"Житель",			211,
		{ 1690.40, -2342.40, 13.54, 181.83 },		VW_AIRPORT,
		"ped",			"SEAT_idle",		false, false },
	{	"Житель",			215,
		{ 1683.11, -2351.61, 13.54, 177.44 },		VW_AIRPORT,
		"PED", 			"IDLE_CHAT",		false, false },
	//	массовка
	{	"Житель",			29,
		{ 1673.85, -2326.50, 13.54, 270.00 },		VW_NONE,
		"SHOP", 		"Smoke_RYD",		false, false },
	{	"Житель",			35,
		{ 1662.86, -2332.59, 13.54, 00.700 },		VW_NONE,
		"PED", 			"SEAT_idle",		false, false },
	{	"Житель",			223,
		{ 1676.62, -2311.45, 13.54, 245.96 },		VW_NONE,
		"PED", 			"IDLE_CHAT",		false, false },
	{	"Житель",			170,
		{ 1677.91, -2312.50, 13.54, 46.370 },		VW_NONE,
		"",				"",					false, false },
	{	"Житель",			131,
		{ 1693.27, -2311.02, 13.54, 180.00 },		VW_NONE,
		"ped", 			"SEAT_idle",		false, false },
	{	"Житель",			239,
		{ 1460.43, -1690.06, 13.67, 275.23 },		VW_NONE,
		"CRACK", 		"crckidle2",		false, false },
	{	"Житель",			192,
		{ 1488.41, -1724.55, 13.37, 180.00 },		VW_NONE,
		"COP_AMBIENT",	"Coplook_loop",		false, false },
	{	"Житель",			136,
		{ 2220.36, -1151.59, 25.75, 309.26 },		VW_NONE,
		"RAPPING",		"Laugh_01",			false, false },
	{	"Житель",			136,
		{ 1498.32, -1690.39, 12.57, 91.085 },		VW_NONE,
		"PED",			"SEAT_idle",		false, false },
	{	"Житель",			26,
		{ 1478.60, -1658.30, 13.41, 357.87 },		VW_NONE,
		"",				"",					false, false },
	{	"Житель",			23,
		{ 1461.24, -1674.51, 13.40, 196.80 },		VW_NONE,
		"",				"",					false, false },
	{	"Житель",			22,
		{ 1461.82, -1675.79, 13.40, 16.487 },		VW_NONE,
		"PED",			"IDLE_CHAT",		false, false },
	//	Склад
	{	"Рабочий",			16,
		{ 2139.98, -2253.94, 13.30, 44.738 },		VW_NONE,
		"BOMBER", 		"BOM_Plant_Loop",	false, false },
	{	"Рабочий",			27,
		{ 2174.45, -2256.99, 13.30, 44.570 },		VW_NONE,
		"SHOP", 		"Smoke_RYD",		false, false },
	{	"Рабочий",			260,
		{ 2150.21, -2248.87, 14.44, 222.64 },		VW_NONE,
		"BEACH", 		"ParkSit_M_loop", 	false, false },
	{	"Рабочий",			27,
		{ 2151.10, -2249.85, 13.29, 40.900 },		VW_NONE,
		"PED", 			"IDLE_CHAT",		false, false },
	{	"Рабочий",			16,
		{ 2200.51, -2284.74, 13.54, 86.7 },			VW_NONE,
		"",				"", 				false, false },
	{	"Рабочий",			260,
		{ 2199.12, -2284.62, 13.54, 268.26 },		VW_NONE,
		"PED", 			"IDLE_CHAT",		false, false }
};
new ACTOR[sizeof(ActorInfo)];
new Text3D:ActorNametag[sizeof(ActorInfo)];

public	OnGameModeInit()
{
	new string[64];

	for (new i = 0; i < sizeof(ActorInfo); i++)
	{
		ACTOR[i] = CreateActor(ActorInfo[i][a_Skin], Arr4<ActorInfo[i][a_Pos]>);
		SetActorVirtualWorld(ACTOR[i], ActorInfo[i][a_VW]);
		if (ActorInfo[i][a_Nametag])
		{
			format(string, sizeof(string), "%s", ActorInfo[i][a_Name]); // CFB53B
			if(ActorInfo[i][a_Hint])
				strcat(string, "\n{AFAFAF}(прицелиться + y)");
	    	ActorNametag[i] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF,
				ActorInfo[i][a_Pos][0],
				ActorInfo[i][a_Pos][1],
				ActorInfo[i][a_Pos][2] + 1.0, 15.0,
				INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, ActorInfo[i][a_VW]);
		}
		if (strlen(ActorInfo[i][a_AnimLib]))
			ApplyActorAnimation(ACTOR[i], ActorInfo[i][a_AnimLib], ActorInfo[i][a_AnimName], 4.1, 1, 0, 0, 1, 0);
	}

	#if defined Actors_OnGameModeInit
		return Actors_OnGameModeInit();
	#else
		return (1);
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Actors_OnGameModeInit
#if defined Actors_OnGameModeInit
	forward Actors_OnGameModeInit();
#endif

public	OnPlayerClickY(playerid)
{
	#if defined OnActorReaction
		new targetid = GetPlayerTargetActor(playerid);
		if(targetid != INVALID_ACTOR_ID)
			return (OnActorReaction(playerid, targetid));
	#endif

	#if defined Actors_OnPlayerClickY
		return Actors_OnPlayerClickY(playerid);
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerClickY
	#undef OnPlayerClickY
#else
	#define _ALS_OnPlayerClickY
#endif
#define OnPlayerClickY Actors_OnPlayerClickY
#if defined Actors_OnPlayerClickY
	forward Actors_OnPlayerClickY(playerid);
#endif