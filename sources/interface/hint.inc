#if defined _interface_hint_included
	#endinput
#endif

#define _interface_hint_included

#define MAX_HINTS	5
#define HINT_X 		90.0
#define HINT_Y		320.0

enum E_HINT_INFO 
{
	HINT_TEXT[128],
	HINT_LINES,
	Float:HINT_POS[2],
	Float:HINT_HEIGHT,
	HINT_TIMER,
	HINT_ORDER,
}
static 
	HintsInfo[MAX_PLAYERS][MAX_HINTS][E_HINT_INFO],
	HintCount[MAX_PLAYERS];

static	
	PlayerText:IFace.Hints[MAX_PLAYERS][5][2];

stock ShowPlayerHint(playerid, const text[], time = 7000)
{
	if(isRus(playerid))
	{
		new tdNumber = INVALID_DATA;

		//	≈сли все слоты зан€ты - ищем подход€щую подсказку дл€ удалени€
		if(HintCount[playerid] == MAX_HINTS)
		{
			new number;
			for(new i = 1; i < MAX_HINTS; i++)
			{
				if(GetTimerIntervalLeft(HintsInfo[playerid][i][HINT_TIMER]) < GetTimerIntervalLeft(HintsInfo[playerid][number][HINT_TIMER]))
				{
					number = i;
				}
			}
			KillTimer(HintsInfo[playerid][number][HINT_TIMER]);
			tdNumber = HintsInfo[playerid][number][HINT_ORDER];
			HidePlayerHint(playerid, tdNumber);
		}

		//	освобождаем первую позицию
		for(new i = MAX_HINTS - 1; i >= 0; i--)
		{
			if(HintsInfo[playerid][i][HINT_ORDER] == INVALID_DATA)	continue;

			_MoveData(playerid, i + 1, i);
		}

		//	ищем свободный текст драв дл€ отрисовки
		if(tdNumber == INVALID_DATA)
		{
			for(tdNumber = 0; tdNumber < MAX_HINTS; tdNumber++)
			{
				if(!IFace.Hints[playerid][tdNumber][0])	break;
			}
		}

		strput(HintsInfo[playerid][0][HINT_TEXT], text);
		HintsInfo[playerid][0][HINT_LINES] = getLinesNumber(HintsInfo[playerid][0][HINT_TEXT], 30);
		HintsInfo[playerid][0][HINT_ORDER] = tdNumber;
		HintsInfo[playerid][0][HINT_TIMER] = SetPlayerTimerEx(playerid, "HidePlayerHint", time, false, "dd", playerid, tdNumber);
		HintCount[playerid]++;

		_RenderHints(playerid);
	}
	else
	{
		new string[256];
		SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_HINT "%s", _FormatTextDrawString(text));
	}
	return true;
}

Public: HidePlayerHint(playerid, number)
{
	PlayerTextDrawDestroy(playerid, IFace.Hints[playerid][number][0]),	IFace.Hints[playerid][number][0] = PlayerText:0;
	PlayerTextDrawDestroy(playerid, IFace.Hints[playerid][number][1]),	IFace.Hints[playerid][number][1] = PlayerText:0;
	HintCount[playerid]--;

	for(new i = 0, bool:flag; i < MAX_HINTS; i++)
	{
		if(HintsInfo[playerid][i][HINT_ORDER] == INVALID_DATA)	break;
		if(flag)
		{
			_MoveData(playerid, i - 1, i);
		}
		else if(HintsInfo[playerid][i][HINT_ORDER] == number)
		{
			_DeleteData(playerid, i);
			flag = true;
		}
	}
	_RenderHints(playerid);
    return true;
}

Public: UpdatePlayerHints(playerid)
{
	_RenderHints(playerid);
	return true;
}

Hint_ZeroVars(playerid)
{
	for(new i = 0; i < MAX_HINTS; i++)
	{
		HintsInfo[playerid][i][HINT_ORDER] = INVALID_DATA;
	}	
	HintCount[playerid] = 0;
}

//////////	Private	//////////
static _RenderHints(playerid)
{
	_RecalculatePosition(playerid);
	for(new i = 0; i < MAX_HINTS; i++)
	{
		if(HintsInfo[playerid][i][HINT_ORDER] == INVALID_DATA)	break;
		_SetHintText(playerid, i);
	}
}

static _SetHintText(playerid, number)
{
	new Float:x = HintsInfo[playerid][number][HINT_POS][0],
		Float:y = HintsInfo[playerid][number][HINT_POS][1];

	new tdNumber = HintsInfo[playerid][number][HINT_ORDER];

	if(IFace.Hints[playerid][tdNumber][0])	PlayerTextDrawDestroy(playerid, IFace.Hints[playerid][tdNumber][0]);
	if(IFace.Hints[playerid][tdNumber][1])	PlayerTextDrawDestroy(playerid, IFace.Hints[playerid][tdNumber][1]);

	IFace.Hints[playerid][tdNumber][0] = CreatePlayerTextDraw(playerid, x, y, HintsInfo[playerid][number][HINT_TEXT]);
	PlayerTextDrawAlignment(playerid, IFace.Hints[playerid][tdNumber][0], 2);
	PlayerTextDrawBackgroundColor(playerid, IFace.Hints[playerid][tdNumber][0], 255);
	PlayerTextDrawFont(playerid, IFace.Hints[playerid][tdNumber][0], 1);
	PlayerTextDrawLetterSize(playerid, IFace.Hints[playerid][tdNumber][0], 0.2, 1.0);
	PlayerTextDrawColor(playerid, IFace.Hints[playerid][tdNumber][0], -1);
	PlayerTextDrawSetOutline(playerid, IFace.Hints[playerid][tdNumber][0], 0);
	PlayerTextDrawSetProportional(playerid, IFace.Hints[playerid][tdNumber][0], 1);
	PlayerTextDrawSetShadow(playerid, IFace.Hints[playerid][tdNumber][0], 0);
	PlayerTextDrawUseBox(playerid, IFace.Hints[playerid][tdNumber][0], 1);
	PlayerTextDrawBoxColor(playerid, IFace.Hints[playerid][tdNumber][0], INTERFACE_MAIN_COLOR);
	PlayerTextDrawTextSize(playerid, IFace.Hints[playerid][tdNumber][0], 0.0, 100.0);
	PlayerTextDrawShow(playerid, IFace.Hints[playerid][tdNumber][0]);

	IFace.Hints[playerid][tdNumber][1] = CreatePlayerTextDraw(playerid, x - 52.0, y, "_");
	PlayerTextDrawAlignment(playerid, IFace.Hints[playerid][tdNumber][1], 2);
	PlayerTextDrawBackgroundColor(playerid, IFace.Hints[playerid][tdNumber][1], 255);
	PlayerTextDrawFont(playerid, IFace.Hints[playerid][tdNumber][1], 1);
	PlayerTextDrawLetterSize(playerid, IFace.Hints[playerid][tdNumber][1], 0.2, (1.0 * HintsInfo[playerid][number][HINT_LINES]));
	PlayerTextDrawColor(playerid, IFace.Hints[playerid][tdNumber][1], -1);
	PlayerTextDrawSetOutline(playerid, IFace.Hints[playerid][tdNumber][1], 0);
	PlayerTextDrawSetProportional(playerid, IFace.Hints[playerid][tdNumber][1], 1);
	PlayerTextDrawSetShadow(playerid, IFace.Hints[playerid][tdNumber][1], 0);
	PlayerTextDrawUseBox(playerid, IFace.Hints[playerid][tdNumber][1], 1);
	PlayerTextDrawBoxColor(playerid, IFace.Hints[playerid][tdNumber][1], 0xA32725FF);
	PlayerTextDrawTextSize(playerid, IFace.Hints[playerid][tdNumber][1], 0.0, -2.0);
	PlayerTextDrawShow(playerid, IFace.Hints[playerid][tdNumber][1]);
	return true;
}

static _RecalculatePosition(playerid)
{
	new Float:x = HINT_X,
		Float:y = HINT_Y - (9.0 * (HintsInfo[playerid][0][HINT_LINES] - 1));

	if(IFace.GetGroupToggle(playerid, IFace.INVENTORY) || IFace.GetGroupToggle(playerid, IFace.SELECT_MENU))
	{
		x += 145.0;
		y = 146.0;//y += 80.0;

		HintsInfo[playerid][0][HINT_POS][0] = x;
		HintsInfo[playerid][0][HINT_POS][1] = y;

		for(new i = 1; i < MAX_HINTS; i++)
		{
			if(HintsInfo[playerid][i][HINT_ORDER] == INVALID_DATA)	break;
			y = HintsInfo[playerid][i - 1][HINT_POS][1] + 16.0 + (9.0 * (HintsInfo[playerid][i - 1][HINT_LINES] - 1));
			HintsInfo[playerid][i][HINT_POS][0] = x;
			HintsInfo[playerid][i][HINT_POS][1] = y;
		}
	}
	else
	{
		if(IFace.GetGroupToggle(playerid, IFace.PHONE))
		{
			y -= 35.0;
		}
		HintsInfo[playerid][0][HINT_POS][0] = x;
		HintsInfo[playerid][0][HINT_POS][1] = y;

		for(new i = 1; i < MAX_HINTS; i++)
		{
			if(HintsInfo[playerid][i][HINT_ORDER] == INVALID_DATA)	break;
			y = HintsInfo[playerid][i - 1][HINT_POS][1] - 16.0 - (9.0 * (HintsInfo[playerid][i][HINT_LINES] - 1));
			HintsInfo[playerid][i][HINT_POS][0] = x;
			HintsInfo[playerid][i][HINT_POS][1] = y;
		}
	}
	
}

static _MoveData(playerid, dest, source)
{
	strput(HintsInfo[playerid][dest][HINT_TEXT], HintsInfo[playerid][source][HINT_TEXT]);
	HintsInfo[playerid][dest][HINT_LINES]	= HintsInfo[playerid][source][HINT_LINES];
	HintsInfo[playerid][dest][HINT_TIMER]	= HintsInfo[playerid][source][HINT_TIMER];
	HintsInfo[playerid][dest][HINT_ORDER]	= HintsInfo[playerid][source][HINT_ORDER];

	_DeleteData(playerid, source);
}

static _DeleteData(playerid, source)
{
	strdel(HintsInfo[playerid][source][HINT_TEXT], 0, strlen(HintsInfo[playerid][source][HINT_TEXT]));
	HintsInfo[playerid][source][HINT_LINES]		= 0;
	HintsInfo[playerid][source][HINT_POS][0]	= 0.0;
	HintsInfo[playerid][source][HINT_POS][1]	= 0.0;
	HintsInfo[playerid][source][HINT_TIMER]		= 0;
	HintsInfo[playerid][source][HINT_ORDER]		= INVALID_DATA;
}