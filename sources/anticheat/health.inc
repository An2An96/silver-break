stock	MySetPlayerHealth(playerid, Float:health)
{
	SetPVarInt(playerid, "AC:Health:GTC", GetTickCount());
	if(health < 0)
		health = 0;
	PlayerInfo[playerid][pSaveHealth] = health;
	p_Protect[playerid][prHealth] = health;
	return (SetPlayerHealth(playerid, health));
}

stock	Float:MyGetPlayerHealth(playerid)
{
	return (p_Protect[playerid][prHealth]);
}

stock	MySetPlayerArmour(playerid, Float:armour)
{
	SetPVarInt(playerid, "AC:Health:GTC", GetTickCount());
	if(armour < 0)
		armour = 0;
	new Float:oldArmour = p_Protect[playerid][prArmour];
	p_Protect[playerid][prArmour] = armour;
	CallLocalFunction("OnPlayerChangeArmour", "dff", playerid, oldArmour, armour);
	return (SetPlayerArmour(playerid, armour));
}

stock	Float:MyGetPlayerArmour(playerid)
{
	return (p_Protect[playerid][prArmour]);
}

public	OnPlayerCheckAnticheat(playerid)
{
	new player_state = GetPlayerState(playerid);
	if (PLAYER_STATE_ONFOOT <= player_state <= PLAYER_STATE_PASSENGER)
	{
		new string[128];
		new const ac_gtc = GetTickCount();
		new const ac_delay = AC_GetPlayerDelay(playerid);
		if(ac_gtc > GetPVarInt(playerid, "AC:Health:GTC") + ac_delay)
		{
			new Float:pArmour,
				Float:pHealth;
			GetPlayerHealth(playerid, pHealth);
			GetPlayerArmour(playerid, pArmour);
			//	Armour
			if (pArmour > p_Protect[playerid][prArmour])
			{
				format(string, sizeof(string),
					"попытался начитерить броню (от %.0f до %.0f [+%.0f])",
						p_Protect[playerid][prArmour], pArmour,
						floatabs(p_Protect[playerid][prArmour] - pArmour));
				AC_PlayerMessage(playerid, string);
				MySetPlayerArmour(playerid, p_Protect[playerid][prArmour]);
				GiveAnticheatWarn(playerid, ARMOUR);
			}
			//	Health
			if (pHealth > p_Protect[playerid][prHealth])
			{
				format(string, sizeof(string),
					"попытался начитерить здоровье (от %.0f до %.0f [+%.0f])",
						p_Protect[playerid][prHealth], pHealth,
						floatabs(p_Protect[playerid][prHealth] - pHealth));
				AC_PlayerMessage(playerid, string);
				MySetPlayerHealth(playerid, p_Protect[playerid][prHealth]);
				GiveAnticheatWarn(playerid, HEALTH);
			}
		}
	}

	#if defined Health_OnPlayerCheckAnticheat
		return (Health_OnPlayerCheckAnticheat(playerid));
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerCheckAnticheat
	#undef OnPlayerCheckAnticheat
#else
	#define _ALS_OnPlayerCheckAnticheat
#endif
#define OnPlayerCheckAnticheat Health_OnPlayerCheckAnticheat
#if defined Health_OnPlayerCheckAnticheat
	forward Health_OnPlayerCheckAnticheat(playerid);
#endif
