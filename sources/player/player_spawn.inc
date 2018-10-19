/*
	Библиотека с механизмами реализующими правильную работу с игровыми функциями игрока

		* Система установки спавна игрока
		* Система управления скинами игрока
		* Функции изменения погоды и времени
*/

#include "faction/header"

forward OnPlayerChangeSkin(playerid, skinid);

enum E_SPAWN
{
	S_TEAMID,
	S_SKINID,
	Float:S_POS[4],
	S_WEAPON[3],
	S_AMMO[3],
	S_INT,
	S_VW
}
new g_SpawnInfo[MAX_PLAYERS][E_SPAWN];

//---	Spawn System
stock	MySpawnPlayer(playerid)
{
	TogglePlayerSpectating(playerid, 1);
	TogglePlayerSpectating(playerid, 0);
}

stock	SB_SetSpawnInfo(playerid, teamid, modelid,
	Float:x, Float:y, Float:z, Float:a,
	weapon1, ammo1, weapon2, ammo2, weapon3, ammo3)
{
	g_SpawnInfo[playerid][S_TEAMID] = teamid;
	g_SpawnInfo[playerid][S_SKINID] = modelid;
	g_SpawnInfo[playerid][S_POS][0] = x;
	g_SpawnInfo[playerid][S_POS][1] = y;
	g_SpawnInfo[playerid][S_POS][2] = z;
	g_SpawnInfo[playerid][S_POS][3] = a;
	g_SpawnInfo[playerid][S_WEAPON][0] = weapon1;
	g_SpawnInfo[playerid][S_AMMO][0] = ammo1;
	g_SpawnInfo[playerid][S_WEAPON][1] = weapon2;
	g_SpawnInfo[playerid][S_AMMO][1] = ammo2;
	g_SpawnInfo[playerid][S_WEAPON][2] = weapon3;
	g_SpawnInfo[playerid][S_AMMO][2] = ammo3;
	return (SetSpawnInfo(playerid, teamid, modelid, x, y, z, a, weapon1, ammo1, weapon2, ammo2, weapon3, ammo3));
}
#if defined _ALS_SetSpawnInfo
	#undef	SetSpawnInfo
#else
	#define	_ALS_SetSpawnInfo
#endif
#define		SetSpawnInfo	SB_SetSpawnInfo

stock	SB_SetPlayerTeam(playerid, teamid)
{
	g_SpawnInfo[playerid][S_TEAMID] = teamid;
	return (SetPlayerTeam(playerid, teamid));
}
#if defined _ALS_SetPlayerTeam
	#undef	SetPlayerTeam
#else
	#define	_ALS_SetPlayerTeam
#endif
#define		SetPlayerTeam	SB_SetPlayerTeam

stock	GetSpawnInfo(playerid, &teamid, &modelid, &Float:x, &Float:y, &Float:z, &Float:a, &weapon1, &ammo1, &weapon2, &ammo2, &weapon3, &ammo3)
{
	teamid = g_SpawnInfo[playerid][S_TEAMID];
	modelid = g_SpawnInfo[playerid][S_SKINID];
	x = g_SpawnInfo[playerid][S_POS][0];	
	y = g_SpawnInfo[playerid][S_POS][1];	
	z = g_SpawnInfo[playerid][S_POS][2];
	a = g_SpawnInfo[playerid][S_POS][3];
	weapon1 = g_SpawnInfo[playerid][S_WEAPON][0];
	ammo1 = g_SpawnInfo[playerid][S_AMMO][0];
	weapon2 = g_SpawnInfo[playerid][S_WEAPON][1];
	ammo2 = g_SpawnInfo[playerid][SA_AMMO][1];
	weapon3 = g_SpawnInfo[playerid][S_WEAPON][1];
	ammo3 = g_SpawnInfo[playerid][S_AMMO][2];
	return (1);
}

stock	GetSpawnPos(playerid, &Float:x, &Float:y, &Float:z, &Float:a, &interior = 0, &vw = 0)
{
	x = g_SpawnInfo[playerid][S_POS][0];	
	y = g_SpawnInfo[playerid][S_POS][1];	
	z = g_SpawnInfo[playerid][S_POS][2];
	a = g_SpawnInfo[playerid][S_POS][3];
	interior = g_SpawnInfo[playerid][S_INT];
	vw = g_SpawnInfo[playerid][S_VW];
	return (1);
}

stock	MySetPlayerSpawnPos(playerid, Float:x, Float:y, Float:z, Float:a, interior = 0, vw = 0)
{
	SetSpawnInfo(playerid,
		g_SpawnInfo[playerid][S_TEAMID], g_SpawnInfo[playerid][S_SKINID],
		x, y, z, a,
		g_SpawnInfo[playerid][S_WEAPON][0], g_SpawnInfo[playerid][S_AMMO][0],
		g_SpawnInfo[playerid][S_WEAPON][1], g_SpawnInfo[playerid][S_AMMO][1],
		g_SpawnInfo[playerid][S_WEAPON][1], g_SpawnInfo[playerid][S_AMMO][2]);
	g_SpawnInfo[playerid][S_INT] = interior;
	g_SpawnInfo[playerid][S_VW] = vw;
	return (1);
}

stock	SetRandPos(&Float:x, &Float:y, Float:radius)
{
	new rand,
		Float:bias,
		Float:angel;

	rand = random(100);
	bias = radius * (float(rand) / 100.0);
	angel = float(random(360));
	x += bias * floatsin(angel, degrees);
	y += bias * floatcos(angel, degrees);
}

/*
	Устанавливает скин игрока:
	constant - указывает на постоянство скина (до выхода из игры)
		true - до выхода из игры скин меняться не будет, false - сбросится при ближайшем спавне
	set - указывает, надо ли в момент вызова функции задать скин игроку 
	(например если после вызова функции происходит спавн, можно установить false, дабы не делать лишних действий
	так как при спавне все равно выставится нужный скин)
		true - выставит скин, false - просто изменит данные в SpawnInfo 
*/
stock	MySetPlayerSkin(playerid, skinid, constant = true, set = true)
{
	if (constant)
	{
		SetSpawnInfo(playerid,
			g_SpawnInfo[playerid][S_TEAMID], skinid, Arr4<g_SpawnInfo[playerid][S_POS]>,
			g_SpawnInfo[playerid][S_WEAPON][0], g_SpawnInfo[playerid][S_AMMO][0],
			g_SpawnInfo[playerid][S_WEAPON][1], g_SpawnInfo[playerid][S_AMMO][1],
			g_SpawnInfo[playerid][S_WEAPON][1], g_SpawnInfo[playerid][S_AMMO][2]);
	}
	if (set)
	{
		if (!gPlayerDeath[playerid])
		{
			SetPlayerSkin(playerid, skinid);

			if (IsPlayerInAnyVehicle(playerid))
				SetTimerEx("FixVehicleAnim", 2000, false, "i", playerid);
			// else
			// 	SetTimerEx("FixPlayerFreeze", 500, false, "i", playerid);
		}
		CallLocalFunction("OnPlayerChangeSkin", "dd", playerid, skinid);
	}
	return (1);
}

/*
	Выдает игроку постоянный скин (сохраненный в SpawnInfo)
	Применяется для возврата к основному скину игрока, после изменений скина в локальных системах
	(например просмотр скинов в магазине одежды, боксерский поединок и т д)
*/
stock	ReloadPlayerSkin(playerid)
{
	SetPlayerSkin(playerid, g_SpawnInfo[playerid][S_SKINID]);
	if (IsPlayerInAnyVehicle(playerid))
		SetTimerEx("FixVehicleAnim", 2000, false, "i", playerid);
	// else
	// 	SetTimerEx("FixPlayerFreeze", 500, false, "i", playerid);
	CallLocalFunction("OnPlayerChangeSkin", "dd", playerid, g_SpawnInfo[playerid][S_SKINID]);
	return (1);
}

/*
	Установит игроку нужный скин, на оснований того, состоит ли он во фракции или нет
*/
UpdatePlayerSkin(playerid, set = true)
{
	new skinid,
		faction;
		
	faction = PlayerInfo[playerid][pFaction];
	//	Если сейчас какой-то временный скин, то не надо менять 	
	if (set)
		set = (GetPlayerSkin(playerid) != g_SpawnInfo[playerid][S_SKINID]) ? false : true;
	//	В тюрьме
	if (PlayerInfo[playerid][pJailTime] >= unixtime())
		skinid = JailSkins[random(sizeof(JailSkins))];
	//	Во фракции
	else if (0 < faction < MAX_FACTIONS)
	{
		if (0 < PlayerInfo[playerid][pRank] <= FactionRankMax[faction])
			skinid = FactionSkins[faction][ PlayerInfo[playerid][pRank] - 1 ];
		else
			skinid = FactionSkins[faction][0];
	}
	//	Собственный скин
	else	
		skinid = PlayerInfo[playerid][pSkin];
	MySetPlayerSkin(playerid, skinid, true, set);
	return (1);
}

Public: FixVehicleAnim(playerid)
{
	if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		MyApplyAnimation(playerid, "PED", "CAR_SIT", 4.1, 1, 0, 0, 0, 0, 1);
	else if (GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
		MyApplyAnimation(playerid, "PED", "CAR_SITP", 4.1, 1, 0, 0, 0, 0, 1);
	//else FixPlayerFreeze(playerid);
}