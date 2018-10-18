#if defined _player_chat_included
	#endinput
#endif
#define _player_chat_included

#include "player/phone/header"

//	SendFormatMessage(playerid, color, var, string, format)
#define SendFormatMessage(%0,%1,%2,%3,%4)		\
	format(%2,sizeof %2,%3,%4), SendClientMessage(%0,%1,%2)
//	SendFormatMessageToAll(color, var, string, format)
#define SendFormatMessageToAll(%0,%1,%2,%3)		\
	format(%1,sizeof %1,%2,%3), MySendClientMessageToAll(%0,%1)
//	CensoreFormatMessageToAll(color, var, string, format)
#define CensoreFormatMessageToAll(%0,%1,%2,%3)	\
	format(%1,sizeof %1,%2,%3), MySendClientMessageToAll(%0, %1, true)

forward RemoveBadWords(text[], bool:onlycount = false);

new talking_timer[MAX_PLAYERS];

new const BadWords[][] = { "бля", "хуй", "хуи", "хуя", "хуе", "пизд", "еба", "ебъ", "ебу", "ебл", "чмо", "сука", "суки", "мудил", "мудак", "ублюдок", "пидор", "пидар", "гандон", "мразь", "залуп" };
new const Exceptions[][] = { "оскорбля", "учебни", "страхуй", "штрихуй", "сабля", "корабля", "требу", "чмок", "рубля" };