#include "player/chat/header"

#include "player/chat/commands"

stock ProxDetector(playerid, Float:rad, const string[], color1 = 0xFFFFFFFF, color2 = 0xE6E6E6E6, color3 = 0xC8C8C8C8, color4 = 0xAAAAAAAA, color5 = 0x8C8C8C8C, censore = false)
{
	new bool:founded;
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	new Float:dist, Float:radius = 0;
	new vw = GetPlayerVirtualWorld(playerid);
	//	Антимат
	new cens_string[256];
	strput(cens_string, string);
	if(censore)
	{
		if(RemoveBadWords(cens_string) >= 5 && GetPlayerAdmin(playerid) == 0)
		{
			new stmp[128];
			PlayerInfo[playerid][pMuteTime] = 5 * 60;
		    SendFormatMessageToAll(COLOR_WHITE, stmp, "%s[%d] "SCOLOR_LIGHTRED"получил молчанку на "SCOLOR_WHITE"5 минут "SCOLOR_LIGHTRED"за обилие мата", ReturnPlayerName(playerid), playerid);
		    return true;
		}
	}
	foreach(LoginPlayer, i)
	{
		if(GetPlayerVirtualWorld(i) != vw)	continue;
		#if defined _player_phone_included
			if(Phone_GetSpeaker(playerid) == i)	continue;
		#endif
		dist = GetDistanceFromMeToPoint(i, X, Y, Z);
		if(dist > rad) continue;
		for(new x = 0; x < 5; x++)
		{
		    radius += rad / 5;
			if(dist < radius)
			{
			    switch(x)
			    {
			        case 0: SendClientMessage(i, color1, PlayerInfo[i][pCensored] ? cens_string : string);
			        case 1: SendClientMessage(i, color2, PlayerInfo[i][pCensored] ? cens_string : string);
			        case 2: SendClientMessage(i, color3, PlayerInfo[i][pCensored] ? cens_string : string);
			        case 3: SendClientMessage(i, color4, PlayerInfo[i][pCensored] ? cens_string : string);
			        case 4: SendClientMessage(i, color5, PlayerInfo[i][pCensored] ? cens_string : string);
			    }
				if(playerid != i) founded = true;
			    break;
			}
		}
	}
	return founded;
}

stock CensoreProxDetector(playerid, Float:rad, const string[], color1 = 0xFFFFFFFF, color2 = 0xE6E6E6E6, color3 = 0xC8C8C8C8, color4 = 0xAAAAAAAA, color5 = 0x8C8C8C8C)
{
	return ProxDetector(playerid, rad, string, color1, color2, color3, color4, color5, true);
}

stock PlayerAction(playerid, action[], censore = false)
{
	if(SpectateID[playerid] != INVALID_PLAYER_ID)
		return true;

	new string[128];
	format(string, 128, "* %s %s", ReturnPlayerName(playerid), action);
	ProxDetector(playerid, 30.0, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, censore);
	SetPlayerChatBubble(playerid, action, COLOR_PURPLE, 30.0, 10000);
	printf("[chat] %s", string);
	return true;
}

stock SendRadiusMessage(playerid, Float:range, color, string[])
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	SendRadiusMessageEx(X, Y, Z, range, color, string);
}

stock SendRadiusMessageEx(Float:X, Float:Y, Float:Z, Float:range, color, string[])
{
	foreach(LoginPlayer, i)
	{
	    if(IsPlayerInRangeOfPoint(i, range, X, Y, Z))
	    {
	        SendClientMessage(i, color, string);
		}
	}
}

MySendClientMessageToAll(color, const message[], censore = false)
{
	//	Антимат
	new cens_string[256];
	strput(cens_string, message);
	if(censore)	RemoveBadWords(cens_string);
	foreach(LoginPlayer, i)
	{
		if(gBlockAction[i] >> 1 & 1) continue;
	    SendClientMessage(i, color, PlayerInfo[i][pCensored] ? cens_string : message);
	}
}

stock SendLocalMessage(playerid, targetid, const message[], anim = true)
{
	new string[256];
	if(targetid != -1)
	{
		format(string, sizeof(string), "- %s (%s)", message, ReturnActorName(playerid));
		SendClientMessage(targetid, COLOR_SAYING, string);
		if(anim)
			ApplyActorAnimation(playerid, "PED", "IDLE_CHAT", 4.1, 0, 1, 1, 1, 1);
	}
	else
	{
	    //GetPVarString(playerid, "color", string, sizeof(string));
	    //if(strlen(string) == 0) format(string, sizeof(string), "- %s (%s)[%d]", message, ReturnPlayerName(playerid), playerid);
		//else format(string, sizeof(string), "- %s {%s}(%s)[%d]", message, string, ReturnPlayerName(playerid), playerid);

		new const iLineLen = 96;
		new szString[100];
		new bool:bResult;

	#if defined _player_phone_included
		if(Phone_GetStatus(playerid) == PHONE_WAIT)	anim = false;
		if(Phone_GetStatus(playerid) == PHONE_SPEAK || Phone_GetStatus(playerid) == PHONE_ANSWER)
		{
	   	 	format(szString, sizeof(szString), "- %s[%d] (в телефон): ", ReturnPlayerName(playerid), playerid);
	   	 	anim = false;
		}
		else
		{
			format(szString, sizeof(szString), "- %s[%d] говорит: ", ReturnPlayerName(playerid), playerid);
		}
	#else
		format(szString, sizeof(szString), "- %s[%d] говорит: ", ReturnPlayerName(playerid), playerid);
	#endif
		for(new 
				i = 0, 
				iCurPos = 0,
				iTextLen = strlen(message), 
				szTmp[100]; 
			iCurPos < iTextLen; i++)
		{
			strmid(szTmp, message, iCurPos, (iCurPos + iLineLen - ((i == 0) ? strlen(szString) : 0 )));
			strcat(szString, szTmp);
			iCurPos += strlen(szTmp);
			if(iCurPos < iTextLen)	strcat(szString, "...");
			if(i == 0)	SetPlayerChatBubble(playerid, szTmp, COLOR_LIGHTGREEN, 20.0, 5000);
			
		#if defined _player_phone_included
			if(Phone_GetStatus(playerid) == PHONE_SPEAK || Phone_GetStatus(playerid) == PHONE_ANSWER)
			{
				SendClientMessage(Phone_GetSpeaker(playerid), COLOR_YELLOW, szString);
				bResult = true;
			}
		#endif
			if(CensoreProxDetector(playerid, 20.0, szString))
			{
				bResult = true;
			}
			strdel(szString, 0, strlen(szString));
		}
		if(!bResult && PlayerInfo[playerid][pLevel] < 4)
		{
			ShowPlayerHint(playerid, "Вы пишите в локальный чат, при этом возле вас никого нет~n~~n~~y~/o - общий чат___________~n~/ask - задать вопрос", 8000);
		}
		if(IsPlayerInAnyVehicle(playerid) == 0 && gPlayerUsingLoopingAnim[playerid] == false)
		{
		    new stoptime = strlen(message) * 100;
		    KillTimer(talking_timer[playerid]);
			//MyApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.1, 0, 1, 1, 1, 1, 1);
			new chat_anims[][16] = { "prtial_gngtlkA", "prtial_gngtlkB",	"prtial_gngtlkC",	"prtial_gngtlkD",	"prtial_gngtlkE",	"prtial_gngtlkF",	"prtial_gngtlkG",	"prtial_gngtlkH" };
			if(anim)
			{
				MyApplyAnimation(playerid, "GANGS", chat_anims[ random( sizeof(chat_anims) ) ], 4.1, 0, 1, 1, 1, 1, 1);
				talking_timer[playerid] = SetPlayerTimerEx(playerid, "ChatClearFreezeAnim", (stoptime > 6000) ? 6000 : stoptime, false, "i", playerid);
			}	
		}
	}
	return 1;
}

Public: ChatClearFreezeAnim(playerid)
{
	MyApplyAnimation(playerid, "MISC", "Idle_Chat_02", 4.1, 0, 0, 0, 0, 100);
}

static	_strfind(const string[], const sub[], pos = 0)
{
	for(new i = pos, len = strlen(string), sublen = strlen(sub), startpos, curpos; i < len; i++)
	{
		if((65 <= string[i] <= 90 || 192 <= string[i] <= 223)
			&& (string[i] == sub[curpos] || (string[i] + 32) == sub[curpos]))	// большие русские и английские
		{
			curpos++;
		}
		else if((97 <= string[i] <= 122 || 224 <= string[i] <= 255)
			&& (string[i] == sub[curpos] || (string[i] - 32) == sub[curpos]))	//	маленькие русские и английские
		{
			curpos++;
		}
		else if(string[i] == sub[curpos])
			curpos++;
		else if(curpos)
		{
			curpos = 0;
			startpos = (-1);
			i--;
		}
		if(curpos == 1)
			startpos = i;
		if(curpos == sublen)
			return startpos;
	}
	return (-1);
}

stock	RemoveBadWords(text[], bool:onlycount = false)
{
	new pos = 0, len = 0, epos = 0, bool:except = false, count = 0;
	for(new i = 0; i < sizeof(BadWords); i++)
	{
		pos = 0;
		do
		{
			pos = _strfind(text, BadWords[i], pos);
			if(pos != -1)
			{
				len = strlen(BadWords[i]);
				for(new e = 0; e < sizeof(Exceptions); e++)
				{
					epos = _strfind(text, Exceptions[e]);
					if(epos > 0 && epos <= pos && epos + strlen(Exceptions[e]) >= pos + len)
					{
						except = true;
						break;
					}
				}
				if(except == false)
				{
					if(onlycount == false)	for(new k = pos; k < pos + len; k++) text[k] = '*';
					count++;
				}
				else except = false;
				pos += len;
			}
		} while(pos != (-1));
	}
	return count;
}