#if defined _core_timers_included
	#endinput
#endif
#define _core_timers_included

forward OnEveryMillisecondTimer();
forward OnEverySecondTimer();
forward OnPlayerEverySecondTimer(playerid);

public	OnGameModeInit()
{
	#if defined OnEverySecondTimer
		SetTimer("OnEverySecondTimer", 950, true);
	#endif
	#if defined OnEveryMillisecondTimer
		SetTimer("OnEveryMillisecondTimer", 100, true);
	#endif

	#if defined Timers_OnGameModeInit
		return Timers_OnGameModeInit();
	#else
		return (1);
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Timers_OnGameModeInit
#if defined Timers_OnGameModeInit
	forward Timers_OnGameModeInit();
#endif

public	OnPlayerConnect(playerid)
{
	#if defined OnPlayerEverySecondTimer
		new timer = SetPlayerTimerEx(playerid,
			"OnPlayerEverySecondTimer", 950, true, "d", playerid);
		SetPVarInt(playerid, "Player:Timer", timer);
	#endif

	#if defined Timers_OnPlayerConnect
		return Timers_OnPlayerConnect(playerid);
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Timers_OnPlayerConnect
#if defined Timers_OnPlayerConnect
	forward Timers_OnPlayerConnect(playerid);
#endif

public	OnPlayerDisconnect(playerid, reason)
{
	new timer = GetPVarInt(playerid, "Player:Timer");
	if (timer)
		KillTimer(GetPVarInt(playerid, "Player:Timer"));

	#if defined Timers_OnPlayerDisconnect
		return (Timers_OnPlayerDisconnect(playerid, reason));
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Timers_OnPlayerDisconnect
#if defined Timers_OnPlayerDisconnect
	forward Timers_OnPlayerDisconnect(playerid, reason);
#endif