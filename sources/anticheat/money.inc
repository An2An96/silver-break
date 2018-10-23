stock	MySetPlayerMoney(playerid, money)
{
	SetPVarInt(playerid, "AC:Money:GTC", GetTickCount());
	ResetPlayerMoney(playerid);
	PlayerInfo[playerid][pMoney] = money;
	return (GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]));
}

stock	MyGivePlayerMoney(playerid, money, bool:visible = true)
{
	if (visible && money != 0)
	{
		IFace.ChangeMoney_Update(playerid, money);
		PlayerPlaySound(playerid, 4201, 0.0, 0.0, 0.0);
	}
	SetPVarInt(playerid, "AC:Money:GTC", GetTickCount());
	PlayerInfo[playerid][pMoney] += money;
	return (GivePlayerMoney(playerid, money));
}

stock	MyResetPlayerMoney(playerid)
{
	SetPVarInt(playerid, "AC:Money:GTC", GetTickCount());
	PlayerInfo[playerid][pMoney] = 0;
	return (ResetPlayerMoney(playerid));
}

public	OnPlayerCheckAnticheat(playerid)
{
	new player_state = GetPlayerState(playerid);
	if (PLAYER_STATE_ONFOOT <= player_state <= PLAYER_STATE_PASSENGER)
	{
		new string[128];
		new const ac_gtc = GetTickCount();
		new const ac_delay = AC_GetPlayerDelay(playerid);
		new money = GetPlayerMoney(playerid);
		if (ac_gtc > GetPVarInt(playerid, "AC:Money:GTC") + ac_delay
			&& money != PlayerInfo[playerid][pMoney])
		{
			if (money > PlayerInfo[playerid][pMoney])
			{
				format(string, sizeof(string),
					"пытается начитерить %d$",
						money - PlayerInfo[playerid][pMoney]);
				AC_PlayerMessage(playerid, string);
				GiveAnticheatWarn(playerid, MONEY);
			}
			else if (money < PlayerInfo[playerid][pMoney])
			{
				if (IsPlayerInRangeOfPoint(playerid, 10.0, 617.530, -1.989, 1000.55)		// Transfender (int 1)
					|| IsPlayerInRangeOfPoint(playerid, 10.0, 616.778, -74.815, 997.77)	// Lawrider (int 2)
					|| IsPlayerInRangeOfPoint(playerid, 10.0, 615.283, -124.23, 997.56)	// Wheels
					|| IsPlayerInPaynSpray(playerid))
				{
					format(string, sizeof(string),
						"потратил %d$ на тюнинг транспорта",
							PlayerInfo[playerid][pMoney] - money);
					Admin_Log(string);
					PlayerInfo[playerid][pMoney] = money;
				}
			}
			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
		}
	}

	#if defined Money_OnPlayerCheckAnticheat
		return (Money_OnPlayerCheckAnticheat(playerid));
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerCheckAnticheat
	#undef OnPlayerCheckAnticheat
#else
	#define _ALS_OnPlayerCheckAnticheat
#endif
#define OnPlayerCheckAnticheat Money_OnPlayerCheckAnticheat
#if defined Money_OnPlayerCheckAnticheat
	forward Money_OnPlayerCheckAnticheat(playerid);
#endif
