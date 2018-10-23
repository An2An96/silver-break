#if defined _gym_boxing_included
	#endinput
#endif
#define _gym_boxing_included

enum E_RING_POS
{
	Float:RING_POS[3],
	Float:RING_RED[4],
	Float:RING_BLUE[4]
};
new const Float:BoxingRingPos[][E_RING_POS] = {
	//	зал лс
	{
		{ 760.9, 0.6, 1001.6 },
		{ 758.8, -1.9, 1001.6, 313.8 },
		{ 762.9, 2.4, 1001.6, 134.7 }
	},
	//	зал лс
	{
		{ 760.9, 11.2, 1001.2 },
		{ 758.6, 9.1, 1001.2, 319.2 },
		{ 763.1, 13.4, 1001.2, 135.4 }
	},
	//	тюрьма
	{
		{ 510.8, -2753.8, 13.4 },
		{ 508.6, -2751.5, 13.4, 226.8 },
		{ 512.9, -2755.8, 13.4, 42.7 }
	}
};

enum E_RING
{
	RING_STATE,
	RING_TIME,
	RING_RED_PLAYER,
	RING_BLUE_PLAYER
}
new BoxingRing[sizeof(BoxingRingPos)][E_RING];

new gPlayerRing[MAX_PLAYERS] = { -1, ... };
new gPlayerBoxEnemy[MAX_PLAYERS] = { INVALID_PLAYER_ID, ... };
new Float:gPlayerPosToRing[MAX_PLAYERS][4];

stock	IsPlayerBoxing(playerid)
{
	return (gPlayerRing[playerid] != (-1) ? true : false);
}

stock	GetNearRing(playerid)
{
	new Float:dist,
		Float:best_dist,
		ring = (-1);

	for(new i = 0; i < sizeof(BoxingRingPos); i++)
	{
		dist = GetDistanceFromMeToPoint(playerid,
			Arr3<BoxingRingPos[i][RING_POS]>);
		if(dist < 8.0)
		{
			if (ring == (-1) || dist < best_dist)
			{
				best_dist = dist;
				ring = i;
			}
		}
	}
	return (ring);
}

stock	StartBox(playerid, giveplayerid)
{
	if(IsPlayerNearPlayer(playerid, giveplayerid, 5.0) == 0)
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ётот игрок слишком далеко от вас.");
		return (0);
	}
	new ring = GetNearRing(giveplayerid);
	if(ring == (-1))
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ётот игрок слишком далеко от ринга.");
		return (0);
	}
	if(BoxingRing[ring][RING_STATE] != 0)
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ётот ринг в данный момент зан€т.");
		return (0);
	}
	if(PlayerInfo[giveplayerid][pTraining] >= MAX_TRAINING)
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ётот игрок устал и сейчас не может боксировать.");
		return (0);
	}
	if(PlayerInfo[playerid][pTraining] >= MAX_TRAINING)
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "¬ы сильно устали и не можете сейчас боксировать.");
		return (0);
	}
	if(MyGetPlayerHealth(playerid) < 15.0)
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "” вас слишком мало здоровь€.");
		return (0);
	}
	if(MyGetPlayerHealth(giveplayerid) < 15.0)
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "” игрока слишком мало здоровь€.");
		return (0);
	}
	//	positions
	GetPlayerPos(playerid, Arr3<gPlayerPosToRing[playerid]>);
	GetPlayerFacingAngle(playerid, gPlayerPosToRing[playerid][3]);
	SetPlayerPos(playerid, Arr3<BoxingRingPos[ring][RING_RED]>);
	SetPlayerFacingAngle(playerid, BoxingRingPos[ring][RING_RED][3]);
	MySetPlayerSkin(playerid, 80, false);
	TogglePlayerControllable(playerid, false);
	MyChangePlayerWeapon(playerid, true);
	BoxingRing[ring][RING_RED_PLAYER] = playerid;
	gPlayerRing[playerid] = ring;
	gPlayerBoxEnemy[playerid] = giveplayerid;
	if(PlayerInfo[playerid][pJailTime])
		HidePlayerPrisonTime(playerid);

	GetPlayerPos(giveplayerid, Arr3<gPlayerPosToRing[giveplayerid]>);
	GetPlayerFacingAngle(giveplayerid, gPlayerPosToRing[giveplayerid][3]);
	SetPlayerPos(giveplayerid, Arr3<BoxingRingPos[ring][RING_BLUE]>);
	SetPlayerFacingAngle(giveplayerid, BoxingRingPos[ring][RING_BLUE][3]);
	MySetPlayerSkin(giveplayerid, 81, false);
	TogglePlayerControllable(giveplayerid, false);
	MyChangePlayerWeapon(giveplayerid, true);
	BoxingRing[ring][RING_BLUE_PLAYER] = giveplayerid;
	gPlayerRing[giveplayerid] = ring;
	gPlayerBoxEnemy[giveplayerid] = playerid;
	if(PlayerInfo[giveplayerid][pJailTime])
		HidePlayerPrisonTime(giveplayerid);

	BoxingRing[ring][RING_STATE] = 1;
	BoxingRing[ring][RING_TIME] = 15;
	return (1);
}

stock FinishBox(playerid, reason)
{
	if (gPlayerRing[playerid] != (-1))
	{
		new enemy = gPlayerBoxEnemy[playerid];
		BoxingRing[ gPlayerRing[playerid] ][RING_BLUE_PLAYER] = INVALID_PLAYER_ID;
		BoxingRing[ gPlayerRing[playerid] ][RING_RED_PLAYER] = INVALID_PLAYER_ID;
		BoxingRing[ gPlayerRing[playerid] ][RING_STATE] = 0;

		if(reason == 2)	//	ничь€
		{
			if(enemy != INVALID_PLAYER_ID)
			{
				GameTextForPlayer(enemy, "~n~~n~~n~~r~Time is over", 5000, 6);
				MySetPlayerPos(enemy, Arr4<gPlayerPosToRing[ enemy ]>);
				ReloadPlayerSkin(enemy);
				LoseAnim(enemy);
				gPlayerBoxEnemy[enemy] = INVALID_PLAYER_ID;
				gPlayerRing[enemy] = (-1);

				GivePlayerPower(enemy, 0.1);
				HidePlayerVisualTimer(enemy);
				HideAttackHealth(enemy);
				if(PlayerInfo[enemy][pJailTime])	ShowPlayerPrisonTime(enemy);
			}

			GameTextForPlayer(playerid, "~n~~n~~n~~r~Time is over", 5000, 6);
			MySetPlayerPos(playerid, Arr4<gPlayerPosToRing[playerid]>);
			ReloadPlayerSkin(playerid);
			LoseAnim(playerid);

			GivePlayerPower(playerid, 0.1);
			HidePlayerVisualTimer(playerid);
			HideAttackHealth(playerid);
			if(PlayerInfo[playerid][pJailTime]){
				ShowPlayerPrisonTime(playerid);
			}
		}
		else
		{
			if(enemy != INVALID_PLAYER_ID)
			{
				GameTextForPlayer(enemy, "~n~~n~~n~~g~You won!!!", 5000, 6);
				MySetPlayerPos(enemy, Arr4<gPlayerPosToRing[ enemy ]>);
				ReloadPlayerSkin(enemy);
				SuccesAnim(enemy);
				gPlayerBoxEnemy[enemy] = INVALID_PLAYER_ID;
				gPlayerRing[enemy] = (-1);

				GivePlayerPower(enemy, 1.0);
				HidePlayerVisualTimer(enemy);
				HideAttackHealth(enemy);
				if(PlayerInfo[enemy][pJailTime])	ShowPlayerPrisonTime(enemy);
			}
			if(reason)
			{
				GameTextForPlayer(playerid, "~n~~n~~n~~r~You lose!", 5000, 6);
				MySetPlayerPos(playerid, Arr4<gPlayerPosToRing[playerid]>);
				ReloadPlayerSkin(playerid);
				LoseAnim(playerid);

				GivePlayerPower(playerid, 0.5);
				HidePlayerVisualTimer(playerid);
				HideAttackHealth(playerid);
				if(PlayerInfo[playerid][pJailTime])	ShowPlayerPrisonTime(playerid);
			}
		}
		MyChangePlayerWeapon(enemy, false);
		MyChangePlayerWeapon(playerid, false);
		PlayerInfo[enemy][pTraining] += 5;
		PlayerInfo[playerid][pTraining] += 5;
		gPlayerBoxEnemy[playerid] = INVALID_PLAYER_ID;
		gPlayerRing[playerid] = (-1);
	}
	return true;
}

public	OnEverySecondTimer()
{
	new string[32];

	for (new i = 0; i < sizeof(BoxingRing); i++)
	{
		if (!BoxingRing[i][RING_TIME])
			continue;
		BoxingRing[i][RING_TIME]--;
		if (BoxingRing[i][RING_STATE] == 1)
		{
			if (0 < BoxingRing[i][RING_TIME] <= 3)
			{
				format(string, 32, "~n~~n~~n~~n~~r~%d", BoxingRing[i][RING_TIME]);
				GameTextForPlayer(BoxingRing[i][RING_RED_PLAYER], string, 1000, 6);
				GameTextForPlayer(BoxingRing[i][RING_BLUE_PLAYER], string, 1000, 6);
			}
			else if (BoxingRing[i][RING_TIME] == 0)
			{
				BoxingRing[i][RING_STATE] = 2;
				BoxingRing[i][RING_TIME] = 180;
				GameTextForPlayer(BoxingRing[i][RING_RED_PLAYER], "~n~~n~~n~~n~~g~FIGHT!", 2000, 6);
				GameTextForPlayer(BoxingRing[i][RING_BLUE_PLAYER], "~n~~n~~n~~n~~g~FIGHT!", 2000, 6);
				TogglePlayerControllable(BoxingRing[i][RING_RED_PLAYER], true);
				TogglePlayerControllable(BoxingRing[i][RING_BLUE_PLAYER], true);
				SetPlayerVisualTimer(BoxingRing[i][RING_RED_PLAYER], BoxingRing[i][RING_TIME], true);
				SetPlayerVisualTimer(BoxingRing[i][RING_BLUE_PLAYER], BoxingRing[i][RING_TIME], true);
				ShowAttackHealth(BoxingRing[i][RING_RED_PLAYER], BoxingRing[i][RING_BLUE_PLAYER]);
				ShowAttackHealth(BoxingRing[i][RING_BLUE_PLAYER], BoxingRing[i][RING_RED_PLAYER]);
			}
		}
		else if (BoxingRing[i][RING_STATE] == 2)
		{
			if (BoxingRing[i][RING_TIME] == 0)
				FinishBox(BoxingRing[i][RING_RED_PLAYER], 2);
		}
	}
	
	#if defined Boxing_OnEverySecondTimer
		return Boxing_OnEverySecondTimer();
	#else
		return (1);
	#endif
}
#if defined _ALS_OnEverySecondTimer
	#undef OnEverySecondTimer
#else
	#define _ALS_OnEverySecondTimer
#endif
#define OnEverySecondTimer Boxing_OnEverySecondTimer
#if defined Boxing_OnEverySecondTimer
	forward Boxing_OnEverySecondTimer();
#endif

public	OnPlayerEverySecondTimer(playerid)
{
	if (IsPlayerBoxing(playerid))
	{
		if (GetDistanceFromMeToPoint(playerid,
			Arr3<BoxingRingPos[gPlayerRing[playerid]][RING_POS]>) > 4.0)
		{
			new lr = GetPVarInt(playerid, "LeaveRing");
			if (lr == 10)
			{
				FinishBox(playerid, 0);
				DeletePVar(playerid, "LeaveRing");
			}
			else
			{
				new string[64];
				SetPVarInt(playerid, "LeaveRing", lr + 1);
				format(string, sizeof(string), "~n~~r~%d sec~n~~w~¬ернитесь на ринг!", 10 - lr);
				GameTextForPlayer(playerid, RusText(string, isRus(playerid)), 1000, 4);
			}
		}
		else if (GetPVarInt(playerid, "LeaveRing") > 0)
		{
			DeletePVar(playerid, "LeaveRing");
		}
	}

	#if defined Boxing_OnPlayerEverySecondTimer
		return Boxing_OnPlayerEverySecondTimer(playerid);
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerEverySecondTimer
	#undef OnPlayerEverySecondTimer
#else
	#define _ALS_OnPlayerEverySecondTimer
#endif
#define OnPlayerEverySecondTimer Boxing_OnPlayerEverySecondTimer
#if defined Boxing_OnPlayerEverySecondTimer
	forward Boxing_OnPlayerEverySecondTimer(playerid);
#endif

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if (IsPlayerBoxing(playerid))
	{
		new Float:health = MyGetPlayerHealth(playerid);
		if (issuerid != INVALID_PLAYER_ID
			&& gPlayerBoxEnemy[issuerid] == playerid)
		{
			UpdateAttackHealth(issuerid);
		}
		if ((health - amount) < 15.0)
		{
			FinishBox(playerid, (weaponid == 54) ? 0 : 1);
		}
	}

	#if defined Boxing_OnPlayerTakeDamage
		return Boxing_OnPlayerTakeDamage(playerid, issuerid, amount, weaponid, bodypart);
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerTakeDamage
	#undef OnPlayerTakeDamage
#else
	#define _ALS_OnPlayerTakeDamage
#endif
#define OnPlayerTakeDamage Boxing_OnPlayerTakeDamage
#if defined Boxing_OnPlayerTakeDamage
	forward Boxing_OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart);
#endif

COMMAND:box(playerid, params[])
{
	new giveplayerid;
	if (sscanf(params, "r", giveplayerid))
	    return SendClientMessage(playerid, COLOR_WHITE,
			"»спользуйте: /box [playerid/playername]");
    if (!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "Ётого игрока нет на сервере.");
    if (PlayerInfo[playerid][pTraining] >= MAX_TRAINING)
		return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "¬ы сильно устали и не можете сейчас боксировать.");
    new ring = GetNearRing(playerid);
	if (ring == (-1))
		return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "¬ы должны быть р€дом с боксерским рингом.");
	if (BoxingRing[ring][RING_STATE] != 0)
		return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "Ётот ринг в данный момент зан€т.");
	if (gPlayerRing[giveplayerid] != (-1))
		return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "Ётот игрок в данный момент уже боксирует.");
    new Float:dist = GetDistanceBetweenPlayers(playerid, giveplayerid);
    if (dist > 5.0)
    	return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "Ётот игрок слишком далеко от вас.");
    if (PlayerInfo[giveplayerid][pTraining] >= MAX_TRAINING)
		return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "Ётот игрок устал и сейчас не может боксировать.");
	if (MyGetPlayerHealth(playerid) < 15.0)
		return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "” вас слишком мало здоровь€.");
	if (MyGetPlayerHealth(giveplayerid) < 15.0)
		return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "” игрока слишком мало здоровь€.");
	new string[128];
    if (AskPlayer(playerid, giveplayerid, ASK_BOX))
	{
		SendFormatMessage(giveplayerid, COLOR_WHITE, string, "%s вызывает вас на боксерский поединок "ASK_CONFIRM_INFO, ReturnPlayerName(playerid));
		SendFormatMessage(playerid, COLOR_WHITE, string, "¬ы предложили %s боксерский поединок", ReturnPlayerName(giveplayerid));
	}
	else
		SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "” игрока есть не прин€тый запрос, попробуйте позже.");
    return true;
}