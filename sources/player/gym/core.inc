#include "player/gym/header"

#include "player/gym/bench_press"
#include "player/gym/boxing"

stock	GivePlayerPower(playerid, Float:power)
{
	new a = floatround(PlayerInfo[playerid][pPower], floatround_floor);
	PlayerInfo[playerid][pPower] += power
		* ((PlayerInfo[playerid][pVip]) ? (1.2) : (1.0));
	new b = floatround(PlayerInfo[playerid][pPower], floatround_floor);
	if (b > a)
		RepBarShow(playerid, "Ваша сила выросла:", a, b);
	return (1);
}

stock	IsPlayerTraining(playerid)
{
	#if defined _gym_bench_press_included
		if (playerBenchUsed{playerid} > 0)
			return (true);
	#endif

	return (false);
}

flags:setpower(CMD_DEVELOPER);
COMMAND:setpower(playerid, params[])
{// [BT]
	new giveplayerid, Float:powerlvl;
	if(sscanf(params, "rf", giveplayerid, powerlvl))
	    return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /setpower [playerid/playername] [level]");
	if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого игрока нет на сервере.");
	new string[128];
	PlayerInfo[giveplayerid][pPower] = powerlvl;
	format(string, 128, "Вы задали игроку %s[%d] силу %0.2f", ReturnPlayerName(giveplayerid), giveplayerid, powerlvl);
	SendClientMessage(playerid, COLOR_WHITE, string);
	format(string, 128, "%s[%d] задал вам силу %0.2f", ReturnPlayerName(playerid), playerid, powerlvl);
	SendClientMessage(giveplayerid, COLOR_WHITE, string);
	return 1;
}

public	OnGameModeInit()
{
	#if defined _gym_bench_press_included
		BenchpressInit();
	#endif

	// for (new i = 0; i < sizeof(BoxingRing); i++)
	// {
	// 	BoxingRing[i][RING_RED_PLAYER] = INVALID_PLAYER_ID;
	// 	BoxingRing[i][RING_BLUE_PLAYER] = INVALID_PLAYER_ID;
	// }

	#if defined GYM_OnGameModeInit
		return GYM_OnGameModeInit();
	#else
		return (1);
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit GYM_OnGameModeInit
#if defined GYM_OnGameModeInit
	forward GYM_OnGameModeInit();
#endif