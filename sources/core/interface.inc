#if defined _core_interface_included
	#endinput
#endif

#define _core_interface_included

#include "core/utils"

#define	IFace.						IFace_
#define MAX_IFACE_GROUPS			64

#define INTERFACE_SELECT_COLOR		0xB7BBC499

forward OnTextDrawInit();
forward OnPlayerTextDrawInit(playerid);
forward IsPlayerChangeInterface(playerid, element, bool:toggle);
forward OnPlayerChangeInterface(playerid, element, bool:toggle);

// new const RusChars[] =
// {	// Alt + 0XXX
// 	65,		// А ('A')
// 	128,	// Б ('Ђ')
// 	139,	// В ('‹')
// 	130,	// Г ('‚')
// 	131,	// Д ('ѓ')
// 	69, 	// Е ('E')
// 	132,	// Ж ('„')
// 	136,	// З ('€')
// 	133,	// И ('…')
// 	157,	// Й ('ќ')
// 	75, 	// К ('K')
// 	135,	// Л ('‡')
// 	77, 	// М ('M')
// 	72, 	// Н ('H')
// 	79, 	// О ('O')
// 	140,	// П ('Њ')
// 	80, 	// Р ('P')
// 	67, 	// С ('C')
// 	143,	// Т ('Џ')
// 	89, 	// У ('Y')
// 	129,	// Ф ('Ѓ')
// 	88, 	// Х ('X')
// 	137,	// Ц ('‰')
// 	141,	// Ч ('Ќ')
// 	142,	// Ш ('Ћ')
// 	138,	// Щ ('Љ')
// 	144, 	// Ъ ('ђ')
// 	145, 	// Ы ('‘')
// 	146, 	// Ь ('’')
// 	147, 	// Э ('“')
// 	148, 	// Ю ('”')
// 	149, 	// Я ('•')•Ўњkњ: 120~n~ѓe®©™њ
// 	'a', // а (97)
// 	'—', // б (151)
// 	'ў', // в (162)
// 	'™', // г (153)
// 	'љ', // д (154)
// 	'e', // е (101)
// 	'›', // ж (155)
// 	'џ', // з (159)
// 	'њ', // и (156)
// 	'ќ', // й (157)
// 	'k', // к (107)
// 	'ћ', // л (158)
// 	'Ї', // м (175)
// 	'®', // н (174)
// 	'o', // о (111)
// 	'Ј', // п (163)
// 	'p', // р (112)
// 	'c', // с (99)
// 	'¦', // т (166)
// 	'y', // у (121)
// 	'ў', // ф (152)	//	??????
// 	'x', // х (120)
// 	' ', // ц (160)
// 	'¤', // ч (164)
// 	'Ґ', // ш (165)
// 	'Ў', // щ (161)
// 	'§', // ъ (167)
// 	'Ё', // ы (168)
// 	'©', // ь (169)
// 	'Є', // э (170)
// 	'«', // ю (171)
// 	'¬' // я (172)
// };
// #pragma unused RusChars

enum IFace.E_GROUP_INFO
{
	bool:giToggle,
	bool:giShow
}

static IFace.Groups[MAX_PLAYERS][MAX_IFACE_GROUPS][IFace.E_GROUP_INFO];

enum IFace.E_GROUPS_INFO
{
	bool:gToggleMouse,
	gFunction[32],
}
new const IFace.GroupsInfo[MAX_IFACE_GROUPS][IFace.E_GROUPS_INFO];

enum
{
	ADDICTION_DIRECT,
	ADDICTION_OPPOSITE,
}

static IFace.Addictions[MAX_IFACE_GROUPS][3][15];
static IFace.AddictionsCount[MAX_IFACE_GROUPS][3];

IFace_CancelSelectTextDraw(playerid)
{
	SetPVarInt(playerid, "Core:CancelSelectTD", true);
	return (CancelSelectTextDraw(playerid));
}
#if defined _ALS_CancelSelectTextDraw
	#undef CancelSelectTextDraw
#else
	#define _ALS_CancelSelectTextDraw
#endif
#define CancelSelectTextDraw	IFace_CancelSelectTextDraw

stock	IFace.CreateGroup(idx, const function[], bool:mouse)
{
	if (idx < 0 || idx >= MAX_IFACE_GROUPS)
		return (0);
	strput(IFace.GroupsInfo[idx][gFunction], function);
	IFace.GroupsInfo[idx][gToggleMouse] = mouse;
	return (1);
}

stock	IFace.AddWantShow(element, showElement)
{
	new idx = IFace.AddictionsCount[element][ADDICTION_DIRECT];
	if (idx >= sizeof(IFace.Addictions[][]))
	{
		printf("[WARNING]: Function IFace.AddWantShow: element not added, because the array is full");
		return (0);
	}
	IFace.Addictions[element][ADDICTION_DIRECT][idx] = showElement;
	IFace.AddictionsCount[element][ADDICTION_DIRECT]++;
	return (1);
}

stock	IFace.AddWantHide(element, hideElement)
{
	new idx = IFace.AddictionsCount[element][ADDICTION_OPPOSITE];
	if (idx >= sizeof(IFace.Addictions[][]))
	{
		printf("[WARNING]: Function IFace.AddWantHide: element not added, because the array is full");
		return (0);
	}
	IFace.Addictions[element][ADDICTION_OPPOSITE][idx] = hideElement;
	IFace.AddictionsCount[element][ADDICTION_OPPOSITE]++;
	return (1);
}

//	This function changes visibility groups of text-draws because they require change total or temporary visibility
//	element				- id of element which require change visibility
//	toggle 				- state visibility which is required
//	changeVisibility	- flag which is indicates on temporary change visibility
stock	IFace.ChangeGroupState(playerid,
	element, bool:toggle, bool:changeVisibility)
{
	if (!IsNull(IFace.GroupsInfo[element][gFunction]))
	{
		CallLocalFunction(IFace.GroupsInfo[element][gFunction],
			"ddd", playerid, toggle, changeVisibility);
	}

	//	Активация/Деактивация мыши
	if (IFace.GroupsInfo[element][gToggleMouse])
	{
		if (toggle)
			SelectTextDraw(playerid, INTERFACE_SELECT_COLOR);
		else
		{
			new bool:noCancelSelectTD;
			for (new i; i < MAX_IFACE_GROUPS; i++)
			{
				if (element == i)
					continue;
				if (IFace.GroupsInfo[i][gToggleMouse])
				{
					if (IFace.GetGroupToggleAndVisible(playerid, i))
					{
						noCancelSelectTD = true;
						break;
					}
				}
			}
			if (noCancelSelectTD)
				SelectTextDraw(playerid, INTERFACE_SELECT_COLOR);
			else
				CancelSelectTextDraw(playerid);
		}
	}
	IFace.ChangeLinksGroups(playerid, element, toggle);

	#if defined OnPlayerChangeInterface
		OnPlayerChangeInterface(playerid, element, toggle);
	#endif
	//CallLocalFunction("OnPlayerChangeInterface", "ddd", playerid, _:element, toggle);
	return (1);
}

//	Проверяет можно ли изменить состояние группы (element)
static	IFace.IsChangeGroupToggle(playerid,
	element, bool:toggle, bool:changeVisibility)
{
	if (changeVisibility)
	{
		if (!IFace.GetGroupToggle(playerid, element)
			|| IFace.GetGroupVisible(playerid, element) == _:toggle)
		{
			return (0);
		}
	}
	else
	{
		if (IFace.GetGroupToggle(playerid, element) == _:toggle
			|| !IFace.GetGroupVisible(playerid, element))
		{
			return (0);
		}
	}
	if (toggle)
	{
		for (new j; j < MAX_IFACE_GROUPS; j++)
		{
			if (element == j)
				continue;

			if (IFace.GetGroupToggleAndVisible(playerid, j))
			{
				new count = IFace.AddictionsCount[j][ADDICTION_OPPOSITE];
				for (new i = 0; i < count; i++)
				{
					if (IFace.Addictions[j][ADDICTION_OPPOSITE][i] == element)
					{
						return (0);
					}
				}
			}
		}
	}
	else
	{
		for (new j; j < MAX_IFACE_GROUPS; j++)
		{
			if (element == j)
				continue;

			if (IFace.GetGroupToggleAndVisible(playerid, j))
			{
				new count = IFace.AddictionsCount[j][ADDICTION_DIRECT];
				for (new i = 0; i < count; i++)
				{
					if (IFace.Addictions[j][ADDICTION_DIRECT][i] == element)
					{
						return (0);
					}
				}
			}
		}
	}
	#if defined IsPlayerChangeInterface
		if (IsPlayerChangeInterface(playerid, element, toggle) == 0)
			return (0);
	#endif
	return (1);
}

//	Изменяет состояния групп связанных с текущей изменяемой группой (element)
IFace.ChangeLinksGroups(playerid, element, bool:toggle)
{
	//	перебираем все группы которые нужно скрыть
	for (new i = 0; i < IFace.AddictionsCount[element][ADDICTION_OPPOSITE]; i++)
	{
		IFace.ChangeVisibleGroup(playerid,
			IFace.Addictions[element][ADDICTION_OPPOSITE][i], !toggle);
	}

	//	перебираем элементы которые надо показать
	for (new i = 0; i < IFace.AddictionsCount[element][ADDICTION_DIRECT]; i++)
	{
		IFace.ToggleGroup(playerid,
			IFace.Addictions[element][ADDICTION_DIRECT][i], toggle);
	}
	return true;
}

stock	IFace.ToggleGroup(playerid, element, bool:toggle)
{
	if (IFace.IsChangeGroupToggle(playerid, element, toggle, false))
	{
		IFace.Groups[playerid][element][giToggle] = toggle;
		IFace.ChangeGroupState(playerid, element, toggle, false);
	}
	else
		IFace.Groups[playerid][element][giToggle] = toggle;
	return (1);
}

stock	IFace.ChangeVisibleGroup(playerid, element, bool:toggle)
{
	if (IFace.IsChangeGroupToggle(playerid, element, toggle, true))
	{
		IFace.Groups[playerid][element][giShow] = toggle;
		IFace.ChangeGroupState(playerid, element, toggle, true);
	}
	else
		IFace.Groups[playerid][element][giShow] = toggle;
	return (1);
}

stock	IFace.GetGroupToggle(playerid, element)
{
	return IFace.Groups[playerid][element][giToggle];
}

stock	IFace.GetGroupVisible(playerid, element)
{
	return IFace.Groups[playerid][element][giShow];
}

stock	IFace.GetGroupToggleAndVisible(playerid, element)
{
	return (IFace.Groups[playerid][element][giToggle]
		&& IFace.Groups[playerid][element][giShow]);
}

stock	IFace.ZeroVars(playerid)
{
	for (new e; e < MAX_IFACE_GROUPS; e++)
	{
		IFace.Groups[playerid][e][giToggle] = false;
		IFace.Groups[playerid][e][giShow] 	= true;
		IFace.ChangeGroupState(playerid, e, false, false);
	}
}

//	Callbacks
// public	OnPlayerLogged(playerid)
// {
// 	#if defined OnPlayerTextDrawInit
// 		OnPlayerTextDrawInit();
// 	#endif

// 	#if defined Core_IFace_OnPlayerLogged
// 		return Core_IFace_OnPlayerLogged(playerid);
// 	#else
// 		return (1);
// 	#endif
// }
// #if defined _ALS_OnPlayerLogged
// 	#undef OnPlayerLogged
// #else
// 	#define _ALS_OnPlayerLogged
// #endif
// #define OnPlayerLogged Core_IFace_OnPlayerLogged
// #if defined Core_IFace_OnPlayerLogged
// 	forward Core_IFace_OnPlayerLogged(playerid);
// #endif

public	OnPlayerDisconnect(playerid, reason)
{
	IFace.ZeroVars(playerid);

	#if defined Core_IFace_OnPlayerDisconnect
		return Core_IFace_OnPlayerDisconnect(playerid, reason);
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Core_IFace_OnPlayerDisconnect
#if defined Core_IFace_OnPlayerDisconnect
	forward Core_IFace_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	//////////	#Fix	//////////
	if(_:clickedid == INVALID_TEXT_DRAW
		&& GetPVarInt(playerid, "Core:CancelSelectTD"))
	{
		DeletePVar(playerid, "Core:CancelSelectTD");
		return true;
	}

	#if defined Core_IFace_OnPlayerClickTextDra
		return Core_IFace_OnPlayerClickTextDra(playerid, clickedid);
	#else
		return (0);
	#endif
}
#if defined _ALS_OnPlayerClickTextDraw
	#undef OnPlayerClickTextDraw
#else
	#define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw Core_IFace_OnPlayerClickTextDra
#if defined Core_IFace_OnPlayerClickTextDra
	forward Core_IFace_OnPlayerClickTextDra(playerid, Text:clickedid);
#endif

public	OnGameModeInit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		for(new e; e < MAX_IFACE_GROUPS; e++)
		{
			IFace.Groups[i][e][giShow] = true;
		}
	}

	#if defined OnTextDrawInit
		OnTextDrawInit();
	#endif

	#if defined Core_IFace_OnGameModeInit
		return Core_IFace_OnGameModeInit();
	#else
		return (0);
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Core_IFace_OnGameModeInit
#if defined Core_IFace_OnGameModeInit
	forward Core_IFace_OnGameModeInit();
#endif

//	System
stock _FormatTextDrawString(const string[])
{
	new message[256];
	for(new i, c, bool:ccode; string[i] != EOS; i++) 
	{
		if(string[i] == '~') 
		{
			ccode ^= true;
			if (!ccode) 
			{
				switch (string[i - 1]) 
				{
					case 'r':	strins(message, "{DE2121}", c);
					case 'y':	strins(message, "{CFB53B}", c);
					case 'b':	strins(message, "{3039F1}", c);
					case 'g':	strins(message, "{47A76A}", c);
					case 'w':	strins(message, "{FFFFFF}", c);
					case 'p':	strins(message, "{BB00DD}", c);
					default:	continue;
				}
				c += 8;
			}
		}
		else if(!ccode) 
		{
			message[c++] = string[i];
		}
	}
	return message;
}

stock getLinesNumber(string[], max_line_len)
{
	new lines = 1;
	for(new i, line_len, word_len, bool:tilda; string[i] != EOS; i++)
	{
		if(tilda)
		{
			if(string[i] == 'n')
			{
				line_len = 0;
				word_len = 0;
			    lines++;
			}
			else if(string[i] == '~') tilda = false;
			continue;
		}
		else if(string[i] == '~') 
		{
			tilda = true;
			continue;
		}
		
		if(string[i] != ' ')
		{
			word_len ++;
			if(line_len >= max_line_len || word_len + line_len >= max_line_len)
			{
			    line_len = 0;
			    lines++;
			}
		}
		else
		{
			line_len += word_len + 1;
			word_len = 0;
		}
	}
	return lines;
}

stock RusText(const text[], rusif = true)
{
	new length = strlen(text),
		gametext[256], j = 0;
	if(rusif)
	{
		strput(gametext, text);
		//for(new i = 0; i < length; i++)
		//{
		//	j = text[i] - 192;
		//	gametext[i] = (0 <= j < sizeof(RusChars)) ? RusChars[j] : text[i];
		//}
	}
	else
	{
		for(new i; i < length; i++)
		{
			switch(text[i])
			{
				case 'а': gametext[j++] = 'a';
				case 'А': gametext[j++] = 'A';
				case 'б': gametext[j++] = 'b';
				case 'Б': gametext[j++] = 'B';
				case 'в': gametext[j++] = 'v';
				case 'В': gametext[j++] = 'V';
				case 'г': gametext[j++] = 'g';
				case 'Г': gametext[j++] = 'G';
				case 'д': gametext[j++] = 'd';
				case 'Д': gametext[j++] = 'D';
				case 'е': gametext[j++] = 'e';
				case 'Е': gametext[j++] = 'E';
				case 'ё': gametext[j++] = 'e';
				case 'Ё': gametext[j++] = 'E';
				case 'ж':
				{
					gametext[j++] = 'z';
					gametext[j++] = 'h';
				}
				case 'Ж':
				{
					gametext[j++] = 'Z';
					gametext[j++] = 'h';
				}
				case 'з': gametext[j++] = 'z';
				case 'З': gametext[j++] = 'Z';
				case 'и': gametext[j++] = 'i';
				case 'И': gametext[j++] = 'I';
				case 'й': gametext[j++] = 'j';
				case 'Й': gametext[j++] = 'J';
				case 'к': gametext[j++] = 'k';
				case 'К': gametext[j++] = 'K';
				case 'л': gametext[j++] = 'l';
				case 'Л': gametext[j++] = 'L';
				case 'м': gametext[j++] = 'm';
				case 'М': gametext[j++] = 'M';
				case 'н': gametext[j++] = 'n';
				case 'Н': gametext[j++] = 'N';
				case 'о': gametext[j++] = 'o';
				case 'О': gametext[j++] = 'O';
				case 'п': gametext[j++] = 'p';
				case 'П': gametext[j++] = 'P';
				case 'р': gametext[j++] = 'r';
				case 'Р': gametext[j++] = 'R';
				case 'с': gametext[j++] = 's';
				case 'С': gametext[j++] = 'S';
				case 'т': gametext[j++] = 't';
				case 'Т': gametext[j++] = 'T';
				case 'у': gametext[j++] = 'u';
				case 'У': gametext[j++] = 'U';
				case 'ф': gametext[j++] = 'f';
				case 'Ф': gametext[j++] = 'F';
				case 'х': gametext[j++] = 'h';//kh
				case 'Х': gametext[j++] = 'H';
				case 'ц': gametext[j++] = 'c';//tc
				case 'Ц': gametext[j++] = 'C';
				case 'ч':
				{
					gametext[j++] = 'c';
					gametext[j++] = 'h';
				}
				case 'Ч':
				{
					gametext[j++] = 'C';
					gametext[j++] = 'h';
				}
				case 'ш':
				{
					gametext[j++] = 's';
					gametext[j++] = 'h';
				}
				case 'Ш':
				{
					gametext[j++] = 'S';
					gametext[j++] = 'h';
				}
				case 'щ':
				{
					gametext[j++] = 's';
					gametext[j++] = 'c';
					gametext[j++] = 'h';
				}
				case 'Щ':
				{
					gametext[j++] = 'S';
					gametext[j++] = 'c';
					gametext[j++] = 'h';
				}
				case 'ъ','Ъ':
				{
					gametext[j++] = '\'';
					gametext[j++] = '\'';
				}
				case 'ы':
					gametext[j++] = 'y';
				case 'Ы':
					gametext[j++] = 'Y';
				case 'ь', 'Ь':
					gametext[j++] = '\''; //'
				case 'э':
					gametext[j++] = 'e';
				case 'Э':
					gametext[j++] = 'E';
				case 'ю':
				{
					gametext[j++] = 'e';
					gametext[j++] = 'u';
				}
				case 'Ю':
				{
					gametext[j++] = 'E';
					gametext[j++] = 'u';
				}
				case 'я':
				{
					gametext[j++] = 'y';
					gametext[j++] = 'a';
				}
				case 'Я':
				{
					gametext[j++] = 'Y';
					gametext[j++] = 'a';
				}
				default:
					gametext[j++] = text[i];
			}
		}
	}
	return gametext;
}
