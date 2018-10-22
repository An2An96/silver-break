#if defined _player_ask_included
	#endinput
#endif
#define _player_ask_included

#include <foreach>
#include <easy_keys>

forward AskTimer();
forward OnPlayerAskResponse(playerid, offerid, askid, const amount[], response);

enum
{
	ASK_NONE,
	ASK_INVITE,
	ASK_POLICE_FINE,
	ASK_CAR_SELLTO,
	ASK_INVITE_JOB,
	ASK_HI,
	ASK_GIVE_MONEY,
	ASK_GIVE_THING,
	ASK_INTERVIEW,
	ASK_BOX,
	ASK_BUY_HOTDOG,
	ASK_SHOWPASS,
	ASK_JOB_PARTNER,
	ASK_REPAIR,
	ASK_REFILL
};

new const AskPrimory[] =
{
	30,	//	ASK_INVITE
	40,	//	ASK_POLICE_FINE
	20,	//	ASK_CAR_SELLTO
	25,	//	ASK_INVITE_JOB
	10,	//	ASK_HI
	20,	//	ASK_GIVE_MONEY
	20,	//	ASK_GIVE_THING
	20,	//	ASK_INTERVIEW
	15, //	ASK_BOX
	5,	//	ASK_BUY_HOTDOG
	10,	//	ASK_SHOWPASS
	15,	//	ASK_JOB_PARTNER
	20,	//	ASK_REPAIR
	20	//	ASK_REFILL
};

static
	AskWhat[MAX_PLAYERS] = { ASK_NONE, ... },
	AskOfferID[MAX_PLAYERS] = { -1, ... },
	AskAmounts[MAX_PLAYERS][4],
	AskTime[MAX_PLAYERS];

stock	AskPlayer(playerid, giveplayerid, asktype, waittime = 30, ...)
{
	if(AskWhat[giveplayerid] != 0
		&& AskPrimory[asktype] <= AskPrimory[AskWhat[giveplayerid]])
		return (0);
	new arg;
	arg = 4;
	AskWhat[giveplayerid] = asktype;
	AskOfferID[giveplayerid] = playerid;
	AskTime[giveplayerid] = waittime;
	while (arg < numargs() && (arg - 4) < sizeof(AskAmounts[]))
	{
		AskAmounts[giveplayerid][arg - 4] = getarg(arg);
		arg++;
	}
	return (1);
}

stock	GetPlayerAsk(playerid)
{
	return AskWhat[playerid];
}

stock	GetPlayerAskOfferid(playerid)
{
	return AskOfferID[playerid];
}

stock	StopAsking(playerid)
{
	new i;

	AskOfferID[playerid] = -1;
	AskTime[playerid] = 0;
	AskWhat[playerid] = ASK_NONE;
	i = 0;
	while (i < sizeof(AskAmounts[]))
	{
		AskAmounts[playerid][i] = 0;
		i++;
	}
	return (1);
}

public	AskTimer()
{
	foreach(Player, i)
	{
		// јвтоматический отказ по истечении времени предложени€
		if(AskTime[i] > 0 && --AskTime[i] == 0)
		{
			CallLocalFunction("OnPlayerAskResponse", "dddab", i, AskOfferID[i], AskWhat[i], AskAmounts[i], false);
			StopAsking(i);
		}
	}
	return (1);
}

public	OnPlayerClickY(playerid)
{
	new newkeys,
		tmp;
	
	if (AskWhat[playerid] != ASK_NONE)
	{	
		GetPlayerKeys(playerid, newkeys, tmp, tmp);
		if (HOLDING(KEY_SPRINT))	//	ѕробел + Y
		{
			(CallLocalFunction("OnPlayerAskResponse", "dddab",
				playerid, AskOfferID[playerid],
				AskWhat[playerid], AskAmounts[playerid], true));
			return (StopAsking(playerid));
		}
	}

	#if defined Ask_OnPlayerClickY
		return (Ask_OnPlayerClickY(playerid));
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerClickY
	#undef OnPlayerClickY
#else
	#define _ALS_OnPlayerClickY
#endif
#define OnPlayerClickY	Ask_OnPlayerClickY
#if defined Ask_OnPlayerClickY
	forward Ask_OnPlayerClickY(playerid);
#endif

public	OnPlayerClickN(playerid)
{
	new newkeys,
		tmp;
	
	if (AskWhat[playerid] != ASK_NONE)
	{	
		GetPlayerKeys(playerid, newkeys, tmp, tmp);
		if (HOLDING(KEY_SPRINT))	//	ѕробел + N
			return (CallLocalFunction("OnPlayerAskResponse", "dddab",
				playerid, AskOfferID[playerid], AskWhat[playerid], AskAmounts[playerid], false));
	}

	#if defined Ask_OnPlayerClickN
		return (Ask_OnPlayerClickN(playerid));
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerClickN
	#undef OnPlayerClickN
#else
	#define _ALS_OnPlayerClickN
#endif
#define OnPlayerClickN	Ask_OnPlayerClickN
#if defined Ask_OnPlayerClickN
	forward Ask_OnPlayerClickN(playerid);
#endif

public	OnPlayerDisconnect(playerid, reason)
{
	new string[128];

	foreach(Player, i)
	{
		if (AskOfferID[i] == playerid)
		{
			SendFormatMessage(i, COLOR_LIGHTRED, string, "%s покинул сервер, предложение отклонено.", ReturnPlayerName(playerid));
			StopAsking(i);
			break;
		}
	}

	#if defined Ask_OnPlayerDisconnect
		return (Ask_OnPlayerDisconnect(playerid, reason));
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect	Ask_OnPlayerDisconnect
#if defined Ask_OnPlayerDisconnect
	forward Ask_OnPlayerDisconnect(playerid, reason);
#endif

public	OnGameModeInit()
{
	SetTimer("AskTimer", 1000, 1);

	#if defined Ask_OnGameModeInit
		return (Ask_OnGameModeInit());
	#else
		return (1);
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit	Ask_OnGameModeInit
#if defined Ask_OnGameModeInit
	forward Ask_OnGameModeInit();
#endif