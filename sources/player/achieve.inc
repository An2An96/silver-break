#if defined _player_achieve_included
	#endinput
#endif

#define _player_achieve_included

enum
{
	ACHIEVE_BONUS_MONEY,
	ACHIEVE_BONUS_COINS,
	ACHIEVE_BONUS_EXP,
	ACHIEVE_BONUS_UPGRADE,
}

enum E_ACHIEVES
{
	ACHIEVE_NONE,
	ACHIEVE_URBAN,
	ACHIEVE_DRIVER,
	ACHIEVE_METEOR,
	ACHIEVE_CARRIER,
	ACHIEVE_RESEARCHER,
	ACHIEVE_KILLER,
	ACHIEVE_DEATH,
	ACHIEVE_ADMINKILL,
	ACHIEVE_PAYDAY,
	ACHIEVE_ARNOLD,
	ACHIEVE_WALTER,
}

enum E_ACHIEVE_DATA
{
	A_NAME[24],
	A_DESCRIP[64],
	A_BONUS_TYPE,
	A_BONUS_COUNT,
	bool:A_INFORM
}

static Achievements[E_ACHIEVES][E_ACHIEVE_DATA];
static bool:pAchieves[MAX_PLAYERS][E_ACHIEVES];

/*{
	{	"Урбанизация",		"Прописаться в городе",							ACHIEVE_BONUS_EXP,		50, false	},
	{	"Водитель",			"Получить водительские права",					ACHIEVE_BONUS_MONEY,		(PRICE_AUTOSCHOOL / 2), false },
	{	"Метеор", 			"Выиграть игру в чате менее чем за 2 секунды",	ACHIEVE_BONUS_EXP, 		500, true	},
	{	"Водила",			"Проехать на машине 1000км",					ACHIEVE_BONUS_EXP,		300, true	},
	{	"Исследователь",	"Подняться на гору Чилиад",						ACHIEVE_BONUS_MONEY,		300, true	},
	{	"Киллер", 			"Убить 100 игроков", 							ACHIEVE_BONUS_EXP, 		300, true	},
	{	"Смертник",			"Умереть 100 раз",								ACHIEVE_BONUS_MONEY,		300, true	},
	{	"Какая честь",		"Умереть от рук админа",						ACHIEVE_BONUS_MONEY,		500, true	},
	{	"Карманные деньги", "Получить первую зарплату",						ACHIEVE_BONUS_EXP,		100, false 	},
	{	"Арнольд",			"Прокачать свою силу на максимум",				ACHIEVE_BONUS_MONEY,		500, true	},
	{	"Синий мет",		"Вряд ли Уолтер будет рад вашему визиту",		ACHIEVE_BONUS_COINS,		10, true	}
};*/

Public: Achieve_OnGameModeInit()
{
	new i,
		query[256],
		Cache:result;

	mysql_format(g_SQL, query, sizeof(query),
		"SELECT `id`, `title`, `description`, `bounty_type`, `bounty_value`, `inform` \
		FROM %s.`achievements_data`", MAIN_DB);
	result = mysql_query(g_SQL, query);
	i = 0;
	for(new E_ACHIEVES:aid; i < cache_num_rows(); i++)
	{ 
		cache_get_value_name_int(i, "id",			_:aid);
		if(_:aid < 0 || aid > E_ACHIEVES)
			continue;
		cache_get_value_name(i,		"title",		Achievements[aid][A_NAME]);
	    cache_get_value_name(i,		"description",	Achievements[aid][A_DESCRIP]);
	    cache_get_value_name_int(i, "bounty_type",	Achievements[aid][A_BONUS_TYPE]);
	    cache_get_value_name_int(i, "bounty_value",	Achievements[aid][A_BONUS_COUNT]);
	    cache_get_value_name_int(i, "inform",		Achievements[aid][A_INFORM]);
	}
	cache_delete(result);
	printf("  Loaded achievements : %d.", i);
	return (CONTINUE);
}

Achieve_LoadPlayer(playerid)
{
	new string[64],
		Cache:result;

	mysql_format(g_SQL, string, sizeof(string), "SELECT `aid` FROM `achievements` WHERE `uid` = '%d'", PlayerInfo[playerid][pUserID]);
    result = mysql_query(g_SQL, string);
	for(new i = 0, E_ACHIEVES:aid; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i, "aid", _:aid);
		if(_:aid < 0 || aid > E_ACHIEVES)
			continue;
		pAchieves[playerid][aid] = true;
	}
	cache_delete(result);
	return (true);
}

Achieve_ZeroVars(playerid)
{
	for(new E_ACHIEVES:i; i < E_ACHIEVES; i++)	
		pAchieves[playerid][i] = false;
}

Achieve_Check(playerid)
{
	new count = 0;
	if(PlayerInfo[playerid][pKills] >= 100 && GivePlayerAchieve(playerid, ACHIEVE_KILLER, false))	count++;
	if(PlayerInfo[playerid][pDeaths] >= 100 && GivePlayerAchieve(playerid, ACHIEVE_DEATH, false))	count++;
	if(PlayerInfo[playerid][pCarLic] != 0 && GivePlayerAchieve(playerid, ACHIEVE_DRIVER, false))		count++;
	if(count)	SendClientMessage(playerid, COLOR_GREEN, "[Достижения]: Получены новые достижения, подробнее: {FFFFFF}/menu > Достижения");
	return true;
}

stock GivePlayerAchieve(playerid, E_ACHIEVES:achieve, show = true)
{
	if(_:achieve < 1 || achieve > E_ACHIEVES || pAchieves[playerid][achieve])
	{
		return false;
	}

	new string[256];
	format(string, sizeof(string), "~y~%s~n~~n~~w~%s~n~~n~~g~ДОСТИЖЕНИЕ ПОЛУЧЕНО!~n~~w~Награда: ~g~", Achievements[achieve][A_NAME], Achievements[achieve][A_DESCRIP]);
	switch(Achievements[achieve][A_BONUS_TYPE])
	{
		case ACHIEVE_BONUS_MONEY:
		{
			format(string, sizeof(string), "%s%d$~w~~n~___________", string, Achievements[achieve][A_BONUS_COUNT]);
			MyGivePlayerMoney(playerid, Achievements[achieve][A_BONUS_COUNT]);
		}
		case ACHIEVE_BONUS_COINS:
		{
			format(string, sizeof(string), "%s%d coins~w~~n~___________", string, Achievements[achieve][A_BONUS_COUNT]);
			GivePlayerCoins(playerid, Achievements[achieve][A_BONUS_COUNT]);

		}
		case ACHIEVE_BONUS_EXP:
		{
			format(string, sizeof(string), "%s%d exp~w~~n~___________", string, Achievements[achieve][A_BONUS_COUNT]);
			GivePlayerEXP(playerid, Achievements[achieve][A_BONUS_COUNT]);
		}
		case ACHIEVE_BONUS_UPGRADE:
		{
			format(string, sizeof(string), "%s%d upgrade~w~~n~___________", string, Achievements[achieve][A_BONUS_COUNT]);
			PlayerInfo[playerid][pUpgrade] += Achievements[achieve][A_BONUS_COUNT];
		}
	}
	if(show)	ShowPlayerHint(playerid, string, 10000);
	if(Achievements[achieve][A_INFORM])
	{
		SendFormatMessageToAll(COLOR_ORANGE, string, "[NEWS]: {FFFFFF}%s{FF8300} получает достижение '{FFFFFF}%s{FF8300}'", ReturnPlayerName(playerid), Achievements[achieve][A_NAME]);
	}
	pAchieves[playerid][achieve] = true;
	PlayerPlaySound(playerid, 36205, 0.0, 0.0, 0.0);
	SuccesAnim(playerid);

	mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `achievements` SET `uid` = '%d', `aid` = '%d', `timestamp` = UNIX_TIMESTAMP()", PlayerInfo[playerid][pUserID], _:achieve);
    mysql_query_ex(string);

    #if defined _system_ucp_news_included
	    PushNews(playerid, NEWS_TYPE_ACHIEVEMENT, _:achieve);
	#endif
	return true;
}

//////////	Commands	//////////
flags:giveachieve(CMD_ADMIN);
COMMAND:giveachieve(playerid, params[])
{
	new giveplayerid, E_ACHIEVES:achieve, toggle;
	new string[128];
	if(sscanf(params, "rdd", giveplayerid, _:achieve, toggle))
	{
		SendFormatMessage(playerid, COLOR_WHITE, string, "Используйте: /giveachieve [playerid/playername][номер достижения (1-%d)][0/1]", sizeof(Achievements) - 1);
		return true;
	}
    if(!IsPlayerLogged(giveplayerid))
    {
    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого игрока нет на сервере.");
    }
    if(toggle)
    {
    	if(GivePlayerAchieve(giveplayerid, achieve))
    	{
	    	format(string, 128, "[AdmCmd]: %s %s[%d] выдал достижение '%s' игроку %s[%d]",
				GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, Achievements[achieve][A_NAME], ReturnPlayerName(giveplayerid), giveplayerid);
			SendAdminMessage(COLOR_ADMIN, string);
			SendFormatMessage(giveplayerid, COLOR_LIGHTBLUE, string, "%s %s[%d] выдал вам достижение '{FFFFFF}%s{33CCFF}'", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, Achievements[achieve][A_NAME]);
	    }
	    else
	    {
	    	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Такого достижения нет или оно уже есть у игрока.");
	    }
	}
	else
	{
		pAchieves[giveplayerid][achieve] = false;
		format(string, 128, "[AdmCmd]: %s %s[%d] забрал достижение '%s' у игрока %s[%d]",
			GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, Achievements[achieve][A_NAME], ReturnPlayerName(giveplayerid), giveplayerid);
		SendAdminMessage(COLOR_ADMIN, string);
		SendFormatMessage(giveplayerid, COLOR_LIGHTBLUE, string, "%s %s[%d] забрал у вас достижение '{FFFFFF}%s{33CCFF}'", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, Achievements[achieve][A_NAME]);
	}
	return 1;
}

//////////	Dialogs 	//////////
DialogCreate:Achieve_Main(playerid)
{
	new string[1024];
	for(new E_ACHIEVES:i = E_ACHIEVES:1; i < E_ACHIEVES; i++)
	{
		if(pAchieves[playerid][i])	strcat(string, "{88AA88}• {33AA33}");
		else 						strcat(string, "{88AA88}• {FF6347}");
		format(string, sizeof(string), "%s%s\t{B1C8FB}%s\n", string, Achievements[i][A_NAME], Achievements[i][A_DESCRIP]);
	}
	return Dialog_Open(playerid, Dialog:Achieve_Main, DIALOG_STYLE_TABLIST, "Достижения", string, "Назад", "");
}

DialogResponse:Achieve_Main(playerid, response, listitem, inputtext[])
{
	return ShowDialog(playerid, DMENU_LEVELING);
}