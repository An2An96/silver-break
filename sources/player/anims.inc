#include "interface/hint"

static
	bool:g_PlayerBlockAnim[MAX_PLAYERS],
	bool:gPlayerUsingLoopingAnim[MAX_PLAYERS];

stock	BlockPlayerAnimation(playerid, bool:toggle)
{
	g_PlayerBlockAnim[playerid] = toggle;
	return (1);
}

stock	MyApplyAnimation(playerid, const lib[], const name[], Float:fDelta,
	loop = 0, lockx = 0, locky = 0, freeze = 0, time = 0, forcesync = 1)
{
	if (g_PlayerBlockAnim[playerid])
		return (0);
	if (gPlayerUsingLoopingAnim[playerid])
		StopLoopingAnim(playerid);
	return (ApplyAnimation(playerid, lib, name, fDelta, loop, lockx, locky, freeze, time, forcesync));
}

stock	LoopingAnim(playerid, const lib[], const name[], Float:fDelta,
	loop, lockx, locky, freeze, time, forcesync = 1)
{
	if (MyApplyAnimation(playerid, lib, name, fDelta, loop, lockx, locky, freeze, time, forcesync))
	{
		ShowPlayerHint(playerid, "Используйте ~y~пробел ~w~чтобы остановить анимацию");
    	gPlayerUsingLoopingAnim[playerid] = true;
    	return (1);
	}
	return (0);
}

stock	IsPlayerLoopingAnim(playerid)
{
	return (gPlayerUsingLoopingAnim[playerid]);
}

stock	StopLoopingAnim(playerid)
{
	gPlayerUsingLoopingAnim[playerid] = false;
	return (ClearAnimations(playerid));
}

public	OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (PRESSED(KEY_SPRINT))
	{
	 	if (IsPlayerLoopingAnim(playerid))
			return (StopLoopingAnim(playerid));
	}
	
	#if defined Anims_OnPlayerKeyStateChange
		return (Anims_OnPlayerKeyStateChange(playerid, newkeys, oldkeys));
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerKeyStateChange
	#undef OnPlayerKeyStateChange
#else
	#define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange	Anims_OnPlayerKeyStateChange
#if defined Anims_OnPlayerKeyStateChange
	forward Anims_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

public	OnPlayerDeath(playerid, killerid, reason)
{
	gPlayerUsingLoopingAnim[playerid] = false;

	#if defined Anims_OnPlayerDeath
		return (Anims_OnPlayerDeath(playerid, killerid, reason));
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerDeath
	#undef OnPlayerDeath
#else
	#define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath	Anims_OnPlayerDeath
#if defined Anims_OnPlayerDeath
	forward Anims_OnPlayerDeath(playerid, killerid, reason);
#endif

public	OnPlayerDisconnect(playerid, reason)
{
	g_PlayerBlockAnim[playerid] = false;
	gPlayerUsingLoopingAnim[playerid] = false;
	
	#if defined Anims_OnPlayerDisconnect
		return (Anims_OnPlayerDisconnect(playerid, reason));
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect	Anims_OnPlayerDisconnect
#if defined Anims_OnPlayerDisconnect
	forward Anims_OnPlayerDisconnect(playerid, reason);
#endif
