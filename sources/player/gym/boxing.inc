//	Бокс
enum E_RING_POS{
	Float:RING_POS[3],
	Float:RING_RED[4],
	Float:RING_BLUE[4]
};
new const Float:BoxingRingPos[][E_RING_POS] = {
	{	{ 760.9, 0.6, 1001.6 },		{ 758.8, -1.9, 1001.6, 313.8 },		{ 762.9, 2.4, 1001.6, 134.7 }	},	//	зал лс
	{	{ 760.9, 11.2, 1001.2 },	{ 758.6, 9.1, 1001.2, 319.2 },		{ 763.1, 13.4, 1001.2, 135.4 }	},	//	зал лс
	{	{ 510.8, -2753.8, 13.4 },	{ 508.6, -2751.5, 13.4, 226.8 },	{ 512.9, -2755.8, 13.4, 42.7 }	}	//	тюрьма
};

enum E_RING
{
	RING_STATE,
	RING_TIME,
	RING_RED_PLAYER = INVALID_PLAYER_ID,
	RING_BLUE_PLAYER = INVALID_PLAYER_ID,
}
new BoxingRing[sizeof(BoxingRingPos)][E_RING];

new gPlayerRing[MAX_PLAYERS] = { -1, ... };
new gPlayerBoxEnemy[MAX_PLAYERS] = { INVALID_PLAYER_ID, ... };
new Float:gPlayerPosToRing[MAX_PLAYERS][4];

stock	IsPlayerBoxing(playerid)
{
	return (gPlayerRing[playerid] == (-1) ? true : false);
}

stock	GetNearRing(playerid)
{
	new Float:dist,
		Float:best_dist,
		ring = (-1);

	for(new i = 0; i < sizeof(BoxingRingPos); i++){
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

stock FinishBox(playerid, reason)
{
	if (gPlayerRing[playerid] != (-1))
	{
		new enemy = gPlayerBoxEnemy[playerid];
		BoxingRing[ gPlayerRing[playerid] ][RING_BLUE_PLAYER] = INVALID_PLAYER_ID;
		BoxingRing[ gPlayerRing[playerid] ][RING_RED_PLAYER] = INVALID_PLAYER_ID;
		BoxingRing[ gPlayerRing[playerid] ][RING_STATE] = 0;

		if(reason == 2)	//	ничья
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

COMMAND:box(playerid, params[])
{
	new giveplayerid;
	if (sscanf(params, "r", giveplayerid))
	    return SendClientMessage(playerid, COLOR_WHITE,
			"Используйте: /box [playerid/playername]");
    if (!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "Этого игрока нет на сервере.");
    if (PlayerInfo[playerid][pTraining] >= MAX_TRAINING)
		return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "Вы сильно устали и не можете сейчас боксировать.");
    new ring = GetNearRing(playerid);
	if (ring == (-1))
		return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "Вы должны быть рядом с боксерским рингом.");
	if (BoxingRing[ring][RING_STATE] != 0)
		return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "Этот ринг в данный момент занят.");
	if (gPlayerRing[giveplayerid] != (-1))
		return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "Этот игрок в данный момент уже боксирует.");
    new Float:dist = GetDistanceBetweenPlayers(playerid, giveplayerid);
    if (dist > 5.0)
    	return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "Этот игрок слишком далеко от вас.");
    if (PlayerInfo[giveplayerid][pTraining] >= MAX_TRAINING)
		return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "Этот игрок устал и сейчас не может боксировать.");
	if (MyGetPlayerHealth(playerid) < 15.0)
		return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "У вас слишком мало здоровья.");
	if (MyGetPlayerHealth(giveplayerid) < 15.0)
		return SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "У игрока слишком мало здоровья.");
	new string[128];
    if (AskPlayer(playerid, giveplayerid, ASK_BOX))
	{
		SendFormatMessage(giveplayerid, COLOR_WHITE, string, "%s вызывает вас на боксерский поединок "ASK_CONFIRM_INFO, ReturnPlayerName(playerid));
		SendFormatMessage(playerid, COLOR_WHITE, string, "Вы предложили %s боксерский поединок", ReturnPlayerName(giveplayerid));
	}
	else
		SendClientMessage(playerid, COLOR_WHITE,
			PREFIX_ERROR "У игрока есть не принятый запрос, попробуйте позже.");
    return true;
}