forward OnPlayerEnterReceived(playerid, enterid);
forward OnPlayerExitReceived(playerid, exitid);
forward OnPlayerEnterExitFinish(playerid, enterid, bool:side);

enum
{
	E_NONE,
	E_LSPD,
	E_LSPD_GARAGE,
	E_LSPD_ROOF,
	E_LSPD_AMMO,
	E_AUTOSCHOOL,
	E_AUTOSCHOOL2,
	E_HOTEL_JEF,
	E_DIVER,
	//	Базы банд
	E_GROOVE,
	E_BALLAS,
	E_VAGOS,
	E_AZTECAS,
	E_AZTECAS2,
	E_RIFA,
	// Особняки мафий
	E_RM,
	E_RM_UP,
	E_LCN,
	E_LCN_UP,
	E_YAKUZA,
	// Алькатрас
	E_PRISON1,
	E_PRISON2,
	E_PRISON_HOSPITAL,
	E_PRISON_EAT,
	E_PRISON_JOB,
}

enum enInfo
{
	enID,
	//	EnterInfo
	Float:enX,
	Float:enY,
	Float:enZ,
	Float:enA,
	bool:enFreeze,
	//	ExitInfo
	Float:exX,
	Float:exY,
	Float:exZ,
	Float:exA,
	bool:exFreeze,
	exInt,
	exVW
}

new const EnterInfo[][enInfo] =
{
	{ E_LSPD, 1554.38, -1675.64, 16.19, 270.0, false, 246.78, 62.59, 1003.64, 180.0, false, 6, VW_LSPD },			//	Вход в ЛСПД
	{ E_LSPD_GARAGE, 1568.63, -1689.97, 6.21, 360.0, false, 242.98, 66.32, 1003.64, 90.0, false, 6, VW_LSPD },		//	Вход в ЛСПД с гаража
	{ E_LSPD_ROOF, 1564.75, -1666.29, 28.28, 180.0, true, 246.39, 87.93, 1003.3, 360.0, true, 6, VW_LSPD },			//	Вход в ЛСПД с крыши
	{ E_LSPD_AMMO, 1524.82, -1677.89, 6.0, 90.00, false, 316.25, -169.77, 999.60, 180.0, false, 6, VW_LSPD },		//	Аммунация ЛСПД
	{ E_NONE, 1653.90,-1655.55, 22.51, 360.0, false, 1672.89, -1643.37, 1398.9, 270.0, true, 18, VW_CNN },			//	Вход в телецентр (репортеры)
	//{ E_NONE, 1726.80, -1636.31, 20.21, 180.0, false, 1727.00, -1638.50, 20.22, 360.0, false, 18, VW_TV_CENTER },	//	Черный вход в телецентр (репортеры)
	//{ E_AUTOSCHOOL, 725.65, -1440.13, 13.53, 180.0, false, -2026.92, -104.19, 1035.17, 315.0, false, 3, VW_AUTOSCHOOL },	// Автошкола Лос Сантос
	{ E_AUTOSCHOOL, -2026.59, -101.41, 35.16, 180.0, false, -2026.92, -104.19, 1035.17, 315.0, false, 3, VW_AUTOSCHOOL }, // Автошкола Сан Фиерро
	{ E_AUTOSCHOOL2, -2029.78, -121.09, 35.17, 360.0, false, -2029.79, -119.24, 1035.17, 180.0, false, 3, VW_AUTOSCHOOL },	//	Вход в автошколу со двора
	{ E_NONE, -594.95, 2018.12, 60.53, 135.0, false, -959.63, 1955.54, 9.00, 360.0, false, 17, VW_OTHER },		//	Вход внутрь дамбы недалеко от ФЦ
	{ E_NONE, -2242.51, 128.61, 35.32, 270.0, false, -2240.54, 128.39, 1035.41, 90.0, false, 6, VW_OTHER },	//	магазин игрушек СФ (неиспользуемый)
	{ E_NONE, 1631.90, -1172.20, 24.07, 180.0, false, 833.90, 7.41, 1004.17, 270.0, false, 3, VW_OTHER },		//	принятие ставок ЛС (неиспользуемый)
	{ E_NONE, 1570.99, -1336.80, 16.48, 135.0, false, 1548.64, -1364.76, 326.21, 305.0, false, 0, VW_NONE },	//	подъем на небоскреб ЛС
	{ E_NONE, 2140.18, -2291.51, 20.66, 225.5, false, 2141.53, -2292.77, 20.676, 44.70, false, 0, VW_NONE },	//	Выход на крышу товарного склада
	{ E_NONE, 1480.96, -1771.04, 18.79, 180.0, false, 1553.32, -1567.8, 1001.1, 90.00, true, 0, VW_CITYHALL },	//	мерия лс
	{ E_NONE, 1545.99, -1269.11, 17.41, 310.0, false, 2144.27, 1607.81, 993.69, 180.0, false, 1, VW_BANK },	// Интерьер банка
	{ E_NONE, 1833.02, -1125.64, 24.67, 270.0, false, 246.39, 107.78, 1003.21, 180.0, false, 10, VW_FBI },	// Лос Сантос ФБР
	{ E_NONE, 1786.04, -1297.82, 13.37, 180.0, false, 367.62, 161.97, 1025.78, 270.0, false, 3, VW_OTHER },	//	Агенство недвижимости ЛС (неиспользуемое)
	{ E_NONE, 1940.30, -2115.97, 13.69, 90.0, false, -100.39, -24.62, 1000.71, 180.0, false, 3, VW_SEXSHOP1 },	//	sexshop ls
	{ E_NONE, 953.85, -1336.83, 13.53, 180.0, false, -100.39, -24.62, 1000.71, 180.0, false, 3, VW_SEXSHOP2 },	//	sexshop ls
	{ E_NONE, 		1087.59, -922.620, 43.39, 360.0, false, -100.390, -24.6200, 1000.71, 180.0, false,	3,	VW_SEXSHOP3 },	//	sexshop ls
	{ E_HOTEL_JEF,	2232.90, -1159.80, 25.90, 270.0, false, 2214.580, -1150.45, 1025.79, 90.00, false,	15,	VW_HOTEL 	},	//	Отель Джефферсон
	{ E_NONE, 		2166.38, -1671.67, 15.07, 45.00, false, 318.6010, 1114.843, 1083.88, 180.0, false,	5,	VW_OTHER 	},	// Притон в гетто
	{ E_NONE, 		1172.46, -1321.50, 15.39, 90.00, false, -2631.30, 626.8000, 1274.26, 270.0, true,	1,	VW_HOSPITAL },	//	Больница ЛС
	{ E_DIVER,		2732.95, -2578.25, 3.000, 180.0, false, 2732.950, -2582.09, -9.6400, 00.00, false,	0,	VW_NONE 	},	//	Работа дайвера
	// Базы банд
	{ E_GROOVE, 2495.3826, -1690.8391, 14.7656, 180.0, false, 2495.9668, -1692.3921, 1014.7422, 360.0, false, 3, VW_GROOVE }, // Groove Street
	{ E_BALLAS, 2000.0435, -1114.3876, 27.1250, 360.0, false, 491.1613, 1398.9972, 1080.2578, 180.0, false, 2, VW_BALLAS }, // Ballas
	{ E_VAGOS, 2808.1238, -1176.5128, 25.3759, 360.0, false, 2807.6025, -1174.5161, 1025.5703, 180.0 , false, 8, VW_VAGOS }, // Vagos
	{ E_AZTECAS, 1781.3823, -2101.5317, 14.0566, 0.0, false, 1781.3879, -2100.3210, 1021.4250, 180.0, true, 1, VW_AZTECAS }, // Aztecas
	{ E_AZTECAS2, 1781.1971, -2089.6245, 13.6300, 180.0, false, 1781.3380,-2090.7405,1021.4250, 0.0, true, 1, VW_AZTECAS },	//	Aztecas
	{ E_RIFA, 2151.5059, -1789.1716, 13.5099, 90.0, false, 309.4454, 311.4069, 1003.3047, 360.0, false, 4, VW_RIFA },  // The Rifa
	// Особняки мафий
	{ E_RM, 1298.57, -798.555, 84.14, 360.0, false,	2576.55, -1350.45, 1060.98, 270.0, true, 1, VW_RUSMAF }, 	// Russian Mafia
	{ E_RM_UP, 1259.19, -785.429, 92.03, 270.0, false,	2576.57, -1334.45, 1065.36, 270.0, true, 1, VW_RUSMAF }, 	// Russian Mafia (upstairs)
	{ E_LCN, 1123.27, -2036.95, 69.88, 90.0, false,	165.765, 1366.45, 1083.859, 180.0, true, 1, VW_LCN }, 		// LCN
	{ E_LCN_UP, 1117.78, -2043.99, 74.43, 360.0, false,	160.67, 1379.97, 1088.3672, 90.0,  true, 1, VW_LCN }, 		// LCN (upstairs)
	{ E_YAKUZA, 691.140, -1275.96, 13.56, 270.0, false,	-2167.47, 662.30, 1050.4839, 180.0, true, 1, VW_YAKUZA }, 	// Yakuza
	// Алькатрас
	{ E_PRISON1, 641.97, -2742.85, 2.32, 90.0, true, 709.85, -2901.55, 1700.40, 360.0, true, 1, VW_JAIL }, // Главный вход
	{ E_PRISON2, 570.06, -2748.43, 13.19, 180.0, true, 709.32, -2971.23, 1700.40, 180.0, true, 1, VW_JAIL }, // Вход с прогулки
	{ E_PRISON_HOSPITAL, 647.14, -2681.79, 7.44, 270.0, true, 673.2001,-339.6146,-94.7852, 270.0, true, 1, VW_JAIL }, // Больница Алькатрас
	{ E_PRISON_EAT, 553.11, -2645.91, 13.50, 90.0, true, 601.53, -2831.36, 1032.66, 360.0, true, 1, VW_JAIL },
	{ E_PRISON_JOB, 514.30, -2680.82, 14.19, 180.0, true, 2545.47, -1306.60, 1044.12, 180.0, false, 2, VW_JAIL }, // Вход на завод
	//	Fort Carson (неиспользуемое)
	//{ E_NONE, -127.0, 1188.9, 19.74, 180.0, false, -125.20,	1193.83, 1001.09, 360.0, true, 1, VW_OTHER },		//	Магазин одежды
	{ E_NONE, -89.32, 1378.27, 10.46, 90.0, false, -228.97, 1401.20, 27.76, 90.0, false, 18, VW_OTHER },		//	бар недалеко от FC
	{ E_NONE, -53.84, 1189.30, 19.35, 180.0, false, 459.98, -89.51, 999.55, 270.0, false, 4, VW_OTHER },		// 	рестаран
	{ E_NONE, -144.01, 1224.50, 19.89, 360.0, false, 377.11, -192.95, 1000.64, 180.0, false, 17, VW_OTHER },	//	king ring
	{ E_NONE, -217.71, 978.64, 19.50, 90.0, false, 322.17, 302.63, 999.14, 180.0, false, 5, VW_OTHER },			//	полцейский участок
	{ E_NONE, -19.15, 1175.63, 19.56, 180.0, false, 292.84, 309.98, 999.14, 270.0, false, 3, VW_OTHER },		//	барак
	{ E_NONE, -318.75, 1048.59, 20.34, 180.0, false, 673.2001, -339.6146, -94.7852, 270.0, true, 1, VW_OTHER },	//	Больника ФК
	{ E_NONE, -176.81, 1111.64, 19.74, 315.0, false, 964.24, -53.21, 1001.12, 270.0, false, 3, VW_OTHER }		//	отель

	//{ 2332.51, 75.07, 26.62, 90.0, false, 372.31, -132.99, 1001.49, 180.0, false, 5, 6 },	//	village pizza
	//{ 2333.67, 61.62, 26.70, 90.0, false },		//	village ammo
	//{ 172.69, 1176.61, 14.76, 315.0, false },		//	cluckin fc
	//{ -2336.27, -166.84, 35.55, 90.0, false },	//	burger sf
	//{ -2671.46, 258.49, 4.63, 180.0, false },		//	cluckin sf
	//{ -2625.89, 208.87, 4.61, 180.0, false },		//	ammo sf
	//{ -2551.51, 193.67, 6.20, 289.0, false },		//	club sf
	//{ -1816.72, 617.72, 35.17, 360.0, false },	//	cluckin sf
	//{ -1911.71, 828.51, 35.17, 135.0, false },	//	burger sf
	//{ -1882.84, 866.02, 35.17, 315.0, false },	//	zip sf
	//{ -1695.00, 951.58, 24.89, 315.0, false },	//	victim sf
	//{ -2356.67, 1008.09, 50.89, 270.0, false },	//	burger sf
	//{ 242.47, -178.28, 1.57, 270.0, false },	//	village ammo
	//{ -2154.81, -2460.61, 30.85, 18.0, false },		//	village cluckin
	//{ 681.62, -473.34, 16.53, 360.0, false },	//	village bar
	//{ -180.18, 1087.96, 19.74, 225.0, false },	//	bar fc
	//{ 627.55, -571.85, 17.65, 90.0, false, 246.80, 62.85, 1003.64, 180.0, false, 6, 1 },		//	Вход в участок за городом
	//{ 693.69, 1967.02, 5.53, 360.0, false, 1212.22, -26.51, 1000.95, 360.0, false, 3, 0 },	//	Стрип клуб недалеко от ФЦ (прикольный интерьер)
	//{ -315.51, 829.91, 14.24, 90.0, false, 296.82, -111.80, 1001.51, 180.0, false, 6, 3 },	//	Амунация рядом с ФЦ
	//{ -2490.61, -29.07, 25.61, 270.0, false, 203.82, -49.95, 1001.80, 180.0, false, 1, 1 },	//	suburban sf
	//{ -1808.26, 945.33, 24.89, 45.0, false, 372.31, -132.99, 1001.49, 180.0, false, 5, 7 },		//	pizza sf
	//{ -1721.67, 1359.79, 7.18, 270.0, false, 372.31, -132.99, 1001.49, 180.0, false, 5, 8 },	//	pizza sf
	//{ -1508.97, 2609.98, 55.83, 360.0, false, 296.82, -111.80, 1001.51, 180.0, false, 6, 4 },	//	village ammo
	//{ 966.98, 2160.62, 10.82, 90.0, false, 964.79, 2160.04, 1011.03, 270.0, false, 1, 0 },	//	комбинат ЛВ (прикольный интерьер)
	//{ 1366.86, 248.62, 19.56, 248.0, false, 372.31, -132.99, 1001.49, 180.0, false, 5, 9 },	//	village pizza
	//{ -1213.27, 1830.94, 41.92, 135.0, false, 365.11, -11.33, 1001.85, 270.0, false, 9, 10 },	//	village cluckin
	//{ -2093.35, -2464.55, 30.62, 135.0, false, 296.82, -111.80, 1001.51, 180.0, false, 6, 5 },//	village ammo
	//{ -2765.65, 375.54, 6.33, 90.0, false, 390.11, 173.77, 1008.38, 270.0, false, 3, 1 },		//	Вход в мерию СФ
	//{ -2649.43, 376.03, 6.15, 270.0, false, 367.62, 161.97, 1025.78, 270.0, false, 3, 4 },	//	Агенство недвижимости СФ

}; /* End of EnterInfo */
new EnExPickup[sizeof(EnterInfo) * 2];

stock SetPlayerEnter(playerid, en, bool:side = true)
{
	//TogglePlayerControllable(playerid, false);
	//	side: 0 - выход, 1 - вход
	SetCameraBehindPlayer(playerid);
	if(side)
	{
		SetPlayerObjectPos(playerid, GetPVarInt(playerid, "System:Player:EnterObject"), EnterInfo[en][exX], EnterInfo[en][exY], EnterInfo[en][exZ] - 1.8);
		Streamer_UpdateEx(playerid, EnterInfo[en][exX], EnterInfo[en][exY], EnterInfo[en][exZ], EnterInfo[en][exInt], EnterInfo[en][exVW]);
		MySetPlayerPos(playerid, EnterInfo[en][exX], EnterInfo[en][exY], EnterInfo[en][exZ], EnterInfo[en][exA] + 180, EnterInfo[en][exInt], EnterInfo[en][exVW]);
		//if(EnterInfo[en][exFreeze] == false)	TogglePlayerControllable(playerid, true);
		//else 									SetTimerEx("MyUnfreezePlayer", 2000, false, "i", playerid);
	}
	else
	{
		SetPlayerObjectPos(playerid, GetPVarInt(playerid, "System:Player:EnterObject"), EnterInfo[en][enX], EnterInfo[en][enY], EnterInfo[en][enZ] - 1.8);
		Streamer_UpdateEx(playerid, EnterInfo[en][enX], EnterInfo[en][enY], EnterInfo[en][enZ], 0, 0);
		MySetPlayerPos(playerid, EnterInfo[en][enX], EnterInfo[en][enY], EnterInfo[en][enZ], EnterInfo[en][enA] + 180, 0, 0);
		//if(EnterInfo[en][enFreeze] == false)	TogglePlayerControllable(playerid, true);
		//else 									SetTimerEx("MyUnfreezePlayer", 2000, false, "i", playerid);
	}
	CallLocalFunction("OnPlayerEnterExitFinish", "ddd", playerid, EnterInfo[en][enID], side);
	return true;
	//fade_EnterID[playerid] = en;
	//fade_Side[playerid] = side;
	//return FadeColorForPlayer(playerid, 0, 0, 0, 0, 0, 0, 0, 255, 10, FADE_ENTER);
}

public OnGameModeInit()
{
	DisableInteriorEnterExits();

	new en = sizeof(EnterInfo);
	for(new i = 0; i < en; i++)
	{
		EnExPickup[i] = CreateDynamicPickup(PICKUPID_ENTRY, 1, EnterInfo[i][enX], EnterInfo[i][enY], EnterInfo[i][enZ] + 0.5, -1);
		EnExPickup[en + i] = CreateDynamicPickup(PICKUPID_ENTRY, 1, EnterInfo[i][exX], EnterInfo[i][exY], EnterInfo[i][exZ] + 0.5, EnterInfo[i][exVW]);
	}
	printf("  Enters and exits: %d.", en);

	#if defined Enterexit_OnGameModeInit
		return Enterexit_OnGameModeInit();
	#else
		return 1;
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Enterexit_OnGameModeInit
#if defined Enterexit_OnGameModeInit
	forward Enterexit_OnGameModeInit();
#endif

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(EnExPickup[0] <= pickupid <= EnExPickup[sizeof(EnterInfo) * 2 - 1])
	{
	    new Float:angle;
		GetPlayerFacingAngle(playerid, angle);
		new vw = GetPlayerVirtualWorld(playerid);
		for(new e = 0; e < sizeof(EnterInfo); e++)
		{	//	Вход
		    if(pickupid == EnExPickup[e] && floatdif(EnterInfo[e][enA], angle) < 90.0
		    	&& CallLocalFunction("OnPlayerEnterReceived", "dd", playerid, EnterInfo[e][enID]))
			{
				SetPlayerEnter(playerid, e);
				gPickupTime[playerid] = 2;
				return true;
			}
			//	Выход
			else if(pickupid == EnExPickup[sizeof(EnterInfo) + e] && vw == EnterInfo[e][exVW] && floatdif(EnterInfo[e][exA], angle) < 90.0
				&& CallLocalFunction("OnPlayerExitReceived", "dd", playerid, EnterInfo[e][enID]))
			{
				SetPlayerEnter(playerid, e, false);
				PlayerPlaySound(playerid, 3402, 0.0, 0.0, 0.0);
				gPickupTime[playerid] = 2;
				return true;
			}
		}
	}

	#if defined Enterexit_OnPlayerPickUpDP
		return Enterexit_OnPlayerPickUpDP(playerid, pickupid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerPickUpDynPickup
	#undef OnPlayerPickUpDynamicPickup
#else
	#define _ALS_OnPlayerPickUpDynPickup
#endif
#define OnPlayerPickUpDynamicPickup Enterexit_OnPlayerPickUpDP
#if defined Enterexit_OnPlayerPickUpDP
	forward Enterexit_OnPlayerPickUpDP(playerid, pickupid);
#endif