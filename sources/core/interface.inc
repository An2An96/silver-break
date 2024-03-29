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
// 	65,		// � ('A')
// 	128,	// � ('�')
// 	139,	// � ('�')
// 	130,	// � ('�')
// 	131,	// � ('�')
// 	69, 	// � ('E')
// 	132,	// � ('�')
// 	136,	// � ('�')
// 	133,	// � ('�')
// 	157,	// � ('�')
// 	75, 	// � ('K')
// 	135,	// � ('�')
// 	77, 	// � ('M')
// 	72, 	// � ('H')
// 	79, 	// � ('O')
// 	140,	// � ('�')
// 	80, 	// � ('P')
// 	67, 	// � ('C')
// 	143,	// � ('�')
// 	89, 	// � ('Y')
// 	129,	// � ('�')
// 	88, 	// � ('X')
// 	137,	// � ('�')
// 	141,	// � ('�')
// 	142,	// � ('�')
// 	138,	// � ('�')
// 	144, 	// � ('�')
// 	145, 	// � ('�')
// 	146, 	// � ('�')
// 	147, 	// � ('�')
// 	148, 	// � ('�')
// 	149, 	// � ('�')���k�: 120~n~�e����
// 	'a', // � (97)
// 	'�', // � (151)
// 	'�', // � (162)
// 	'�', // � (153)
// 	'�', // � (154)
// 	'e', // � (101)
// 	'�', // � (155)
// 	'�', // � (159)
// 	'�', // � (156)
// 	'�', // � (157)
// 	'k', // � (107)
// 	'�', // � (158)
// 	'�', // � (175)
// 	'�', // � (174)
// 	'o', // � (111)
// 	'�', // � (163)
// 	'p', // � (112)
// 	'c', // � (99)
// 	'�', // � (166)
// 	'y', // � (121)
// 	'�', // � (152)	//	??????
// 	'x', // � (120)
// 	'�', // � (160)
// 	'�', // � (164)
// 	'�', // � (165)
// 	'�', // � (161)
// 	'�', // � (167)
// 	'�', // � (168)
// 	'�', // � (169)
// 	'�', // � (170)
// 	'�', // � (171)
// 	'�' // � (172)
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

	//	���������/����������� ����
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

//	��������� ����� �� �������� ��������� ������ (element)
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

//	�������� ��������� ����� ��������� � ������� ���������� ������� (element)
IFace.ChangeLinksGroups(playerid, element, bool:toggle)
{
	//	���������� ��� ������ ������� ����� ������
	for (new i = 0; i < IFace.AddictionsCount[element][ADDICTION_OPPOSITE]; i++)
	{
		IFace.ChangeVisibleGroup(playerid,
			IFace.Addictions[element][ADDICTION_OPPOSITE][i], !toggle);
	}

	//	���������� �������� ������� ���� ��������
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
				case '�': gametext[j++] = 'a';
				case '�': gametext[j++] = 'A';
				case '�': gametext[j++] = 'b';
				case '�': gametext[j++] = 'B';
				case '�': gametext[j++] = 'v';
				case '�': gametext[j++] = 'V';
				case '�': gametext[j++] = 'g';
				case '�': gametext[j++] = 'G';
				case '�': gametext[j++] = 'd';
				case '�': gametext[j++] = 'D';
				case '�': gametext[j++] = 'e';
				case '�': gametext[j++] = 'E';
				case '�': gametext[j++] = 'e';
				case '�': gametext[j++] = 'E';
				case '�':
				{
					gametext[j++] = 'z';
					gametext[j++] = 'h';
				}
				case '�':
				{
					gametext[j++] = 'Z';
					gametext[j++] = 'h';
				}
				case '�': gametext[j++] = 'z';
				case '�': gametext[j++] = 'Z';
				case '�': gametext[j++] = 'i';
				case '�': gametext[j++] = 'I';
				case '�': gametext[j++] = 'j';
				case '�': gametext[j++] = 'J';
				case '�': gametext[j++] = 'k';
				case '�': gametext[j++] = 'K';
				case '�': gametext[j++] = 'l';
				case '�': gametext[j++] = 'L';
				case '�': gametext[j++] = 'm';
				case '�': gametext[j++] = 'M';
				case '�': gametext[j++] = 'n';
				case '�': gametext[j++] = 'N';
				case '�': gametext[j++] = 'o';
				case '�': gametext[j++] = 'O';
				case '�': gametext[j++] = 'p';
				case '�': gametext[j++] = 'P';
				case '�': gametext[j++] = 'r';
				case '�': gametext[j++] = 'R';
				case '�': gametext[j++] = 's';
				case '�': gametext[j++] = 'S';
				case '�': gametext[j++] = 't';
				case '�': gametext[j++] = 'T';
				case '�': gametext[j++] = 'u';
				case '�': gametext[j++] = 'U';
				case '�': gametext[j++] = 'f';
				case '�': gametext[j++] = 'F';
				case '�': gametext[j++] = 'h';//kh
				case '�': gametext[j++] = 'H';
				case '�': gametext[j++] = 'c';//tc
				case '�': gametext[j++] = 'C';
				case '�':
				{
					gametext[j++] = 'c';
					gametext[j++] = 'h';
				}
				case '�':
				{
					gametext[j++] = 'C';
					gametext[j++] = 'h';
				}
				case '�':
				{
					gametext[j++] = 's';
					gametext[j++] = 'h';
				}
				case '�':
				{
					gametext[j++] = 'S';
					gametext[j++] = 'h';
				}
				case '�':
				{
					gametext[j++] = 's';
					gametext[j++] = 'c';
					gametext[j++] = 'h';
				}
				case '�':
				{
					gametext[j++] = 'S';
					gametext[j++] = 'c';
					gametext[j++] = 'h';
				}
				case '�','�':
				{
					gametext[j++] = '\'';
					gametext[j++] = '\'';
				}
				case '�':
					gametext[j++] = 'y';
				case '�':
					gametext[j++] = 'Y';
				case '�', '�':
					gametext[j++] = '\''; //'
				case '�':
					gametext[j++] = 'e';
				case '�':
					gametext[j++] = 'E';
				case '�':
				{
					gametext[j++] = 'e';
					gametext[j++] = 'u';
				}
				case '�':
				{
					gametext[j++] = 'E';
					gametext[j++] = 'u';
				}
				case '�':
				{
					gametext[j++] = 'y';
					gametext[j++] = 'a';
				}
				case '�':
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
