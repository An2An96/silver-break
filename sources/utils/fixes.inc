/*
	Анимации игрока
*/
stock FIXER_ClearAnimations(playerid, forcesync = 0)
{
    if (playerid < 0 || playerid >= MAX_PLAYERS)
    	return 0;

	if (IsPlayerInAnyVehicle(playerid))
		return ApplyAnimation(playerid, "PED", "CAR_SIT", 4.0, 0, 0, 0, 0, 1, forcesync);

	new ret = ClearAnimations(playerid, forcesync);

	ApplyAnimation(playerid, "PED", "IDLE_STANCE", 4.0, 0, 0, 0, 0, 1, forcesync);
	ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.0, 0, 0, 0, 0, 1, forcesync);
	ApplyAnimation(playerid, "PED", "WALK_PLAYER", 4.0, 0, 0, 0, 0, 1, forcesync);

	return ret;
}
#if defined _ALS_ClearAnimations
	#undef ClearAnimations
#else
	#define _ALS_ClearAnimations
#endif
#define ClearAnimations FIXER_ClearAnimations

/*
	Фикс спавна (если спавнить когда игрок в машине - его убьет)
*/
stock FIXER_SpawnPlayer(playerid)
{
    if (playerid < 0 || playerid >= MAX_PLAYERS)
    	return 0;

	if (IsPlayerInAnyVehicle(playerid))
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		SetPlayerPos(playerid, x, y, z);
	}

	return SpawnPlayer(playerid);
}
#if defined _ALS_SpawnPlayer
	#undef SpawnPlayer
#else
	#define _ALS_SpawnPlayer
#endif
#define SpawnPlayer FIXER_SpawnPlayer

stock FIXER_PutPlayerInVehicle(playerid, vehicleid, seatid)
{
    if (playerid < 0 || playerid >= MAX_PLAYERS)
    	return 0;

	if (IsPlayerInAnyVehicle(playerid))
	{
		new Float:x, Float:y, Float:z;
		GetVehiclePos(playerid, x, y, z);
		SetPlayerPos(playerid, x, y, z);
	}

	return PutPlayerInVehicle(playerid, vehicleid, seatid);
}
#if defined _ALS_PutPlayerInVehicle
	#undef PutPlayerInVehicle
#else
	#define _ALS_PutPlayerInVehicle
#endif
#define PutPlayerInVehicle FIXER_PutPlayerInVehicle

stock FIXER_TogglePlayerControllable(playerid, toggle)
{
    if (playerid < 0 || playerid >= MAX_PLAYERS)
    	return 0;

	if (!toggle && !IsPlayerInAnyVehicle(playerid))
	{
		ClearAnimations(playerid, 1);
	}

	return TogglePlayerControllable(playerid, toggle);
}
#if defined _ALS_TogglePlayerControllable
	#undef TogglePlayerControllable
#else
	#define _ALS_TogglePlayerControllable
#endif
#define TogglePlayerControllable FIXER_TogglePlayerControllable

stock FIXER_GetPlayerWeaponData(playerid, slot, &weapons, &ammo)
{
	new ret = GetPlayerWeaponData(playerid, slot, weapons, ammo);
	if (ret)
	{
		if (ammo <= 0)
		    weapons = 0;
	}
	return ret;
}
#if defined _ALS_GetPlayerWeaponData
	#undef GetPlayerWeaponData
#else
	#define _ALS_GetPlayerWeaponData
#endif
#define GetPlayerWeaponData FIXER_GetPlayerWeaponData

/*
	»справление функций работы с интерьером игрока
*/
stock FIXER_SetPlayerInterior(playerid, interior)
{
	SetPVarInt(playerid, "Gear:Player:Int", interior);
	return SetPlayerInterior(playerid, interior);
}
#if defined _ALS_SetPlayerInterior
	#undef SetPlayerInterior
#else
	#define _ALS_SetPlayerInterior
#endif
#define SetPlayerInterior FIXER_SetPlayerInterior

stock FIXER_GetPlayerInterior(playerid)
{
	return GetPVarInt(playerid, "Gear:Player:Int");
}
#if defined _ALS_GetPlayerInterior
	#undef GetPlayerInterior
#else
	#define _ALS_GetPlayerInterior
#endif
#define GetPlayerInterior FIXER_GetPlayerInterior