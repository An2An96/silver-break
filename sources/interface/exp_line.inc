#if defined _interface_exp_line_included
	#endinput
#endif
#define _interface_exp_line_included

#define EXP_LINE_POS			370.0

new Text:s_ExpLineTD[2][10];
new PlayerText:p_ExpTD[3];

new UpdateExp_Timer[MAX_PLAYERS];

Public: IFace.ExpLine_Toggle(playerid, bool:toggle)
{
	if(toggle)
	{
		if(UpdateExp_Timer[playerid])
		{
			IFace.ExpLine_Toggle(playerid, false);
		}
	}
	else
	{
		for(new i = 0; i < 10; i++)	TextDrawHideForPlayer(playerid, s_ExpLineTD[0][i]);
		for(new i = 0; i < 10; i++)	TextDrawHideForPlayer(playerid, s_ExpLineTD[1][i]);

		PlayerTextDrawHide(playerid, p_ExpTD[0]);
		PlayerTextDrawHide(playerid, p_ExpTD[1]);
		PlayerTextDrawHide(playerid, p_ExpTD[2]);
		KillTimer(UpdateExp_Timer[playerid]),	UpdateExp_Timer[playerid] = 0;
	}
}

Public:_ExpLine_Hide(playerid)
{
	IFace.ToggleGroup(playerid, IFace.EXP_LINE, false);
}

IFace.ExpLine_Update(playerid, curlevel, curexp, amount)
{
	new string[32];
	new k = floatround(100.0 * PlayerInfo[playerid][pExp] / getNextLevelExp(playerid) / 10, floatround_ceil),
		i = 0;
	for(; i < k; i++)	TextDrawShowForPlayer(playerid, s_ExpLineTD[0][i]);
	for(; i < 10; i++)	TextDrawShowForPlayer(playerid, s_ExpLineTD[1][i]);

	format(string, 32, "%d", curlevel);
	PlayerTextDrawSetString(playerid, p_ExpTD[0], string);
	PlayerTextDrawShow(playerid, p_ExpTD[0]);

	format(string, 32, "%d", curlevel + 1);
	PlayerTextDrawSetString(playerid, p_ExpTD[1], string);
	PlayerTextDrawShow(playerid, p_ExpTD[1]);

	format(string, 32, "%d/%d", curexp, NextLvlExp(curlevel + 1));
	PlayerTextDrawSetString(playerid, p_ExpTD[2], string);
	PlayerTextDrawShow(playerid, p_ExpTD[2]);

	if(amount > 0)	UpdateExp_Timer[playerid] = SetPlayerTimerEx(playerid, "UpdateUPNumEXP", 1000, false, "ddddd", playerid, curlevel, curexp, amount, amount / 30 + 1);
	else 			UpdateExp_Timer[playerid] = SetPlayerTimerEx(playerid, "UpdateDOWNNumEXP", 1000, false, "ddddd", playerid, curlevel, curexp, amount, amount / 30 * (-1) + 1);
	return true;
}

Public: UpdateUPNumEXP(playerid, curlevel, curexp, amount, add)
{
	new string[32],
	 	nextlvlexp = NextLvlExp(curlevel + 1);
	curexp += add;
	amount -= add;
	if(curexp >= nextlvlexp)
	{
		curlevel++;
		curexp -= nextlvlexp;
		nextlvlexp = NextLvlExp(curlevel + 1);

		format(string, 32, "%d", curlevel);
		PlayerTextDrawSetString(playerid, p_ExpTD[0], string);

		format(string, 32, "%d", curlevel + 1);
		PlayerTextDrawSetString(playerid, p_ExpTD[1], string);
	}
	if(amount <= 0)
	{
		curexp += amount;
		UpdateExp_Timer[playerid] = SetTimerEx("_ExpLine_Hide", 10000, false, "d", playerid);
	}
	else
	{
		UpdateExp_Timer[playerid] = SetTimerEx("UpdateUPNumEXP", 100, false, "ddddd", playerid, curlevel, curexp, amount, add);
	}
	format(string, sizeof(string), "%d/%d", curexp, nextlvlexp);
	PlayerTextDrawSetString(playerid, p_ExpTD[2], string);
	return true;
}

Public: UpdateDOWNNumEXP(playerid, curlevel, curexp, amount, add)
{
	new string[32],
	 	nextlvlexp = NextLvlExp(curlevel + 1);
	curexp -= add;
	amount += add;
	if(curexp < 0)
	{
		curlevel--;
		if(curlevel < 1)
		{
			curexp = 0;
			amount = 0;
		}
		else
		{
			nextlvlexp = NextLvlExp(curlevel + 1);
			curexp += nextlvlexp;

			format(string, 32, "%d", curlevel);
			PlayerTextDrawSetString(playerid, p_ExpTD[0], string);

			format(string, 32, "%d", curlevel + 1);
			PlayerTextDrawSetString(playerid, p_ExpTD[1], string);
		}
	}
	if(amount >= 0)
	{
		curexp += amount;
		UpdateExp_Timer[playerid] = SetTimerEx("_ExpLine_Hide", 10000, false, "d", playerid);
	}
	else
	{
		UpdateExp_Timer[playerid] = SetTimerEx("UpdateDOWNNumEXP", 100, false, "ddddd", playerid, curlevel, curexp, amount, add);
	}
	format(string, sizeof(string), "%d/%d", curexp, nextlvlexp);
	PlayerTextDrawSetString(playerid, p_ExpTD[2], string);
	return true;
}

IFace.ExpLine_Create_Base()
{
	IFace.AddWantHide(IFace.EXP_LINE,	IFace.MISSION_MES);

	//	Exp TD
	for(new i = 0; i < 10; i++)	//	голубые полосочки
	{
		s_ExpLineTD[0][i] = TextDrawCreate(239.0 + (18.0 * i), EXP_LINE_POS, "1");
		TextDrawAlignment(s_ExpLineTD[0][i], 2);
		TextDrawBackgroundColor(s_ExpLineTD[0][i], 255);
		TextDrawFont(s_ExpLineTD[0][i], 1);
		TextDrawLetterSize(s_ExpLineTD[0][i], 0.0, 0.099999);
		TextDrawColor(s_ExpLineTD[0][i], -1);
		TextDrawSetOutline(s_ExpLineTD[0][i], 0);
		TextDrawSetProportional(s_ExpLineTD[0][i], 1);
		TextDrawSetShadow(s_ExpLineTD[0][i], 1);
		TextDrawUseBox(s_ExpLineTD[0][i], 1);
		TextDrawBoxColor(s_ExpLineTD[0][i], 325953023);
		TextDrawTextSize(s_ExpLineTD[0][i], 270.0, 13.0);
	}

	for(new i = 0; i < 10; i++)	//	синие полосочки
	{
		s_ExpLineTD[1][i] = TextDrawCreate(239.0 + (18.0 * i), EXP_LINE_POS, "1");
		TextDrawAlignment(s_ExpLineTD[1][i], 2);
		TextDrawBackgroundColor(s_ExpLineTD[1][i], 255);
		TextDrawFont(s_ExpLineTD[1][i], 1);
		TextDrawLetterSize(s_ExpLineTD[1][i], 0.0, 0.099999);
		TextDrawColor(s_ExpLineTD[1][i], -1);
		TextDrawSetOutline(s_ExpLineTD[1][i], 0);
		TextDrawSetProportional(s_ExpLineTD[1][i], 1);
		TextDrawSetShadow(s_ExpLineTD[1][i], 1);
		TextDrawUseBox(s_ExpLineTD[1][i], 1);
		TextDrawBoxColor(s_ExpLineTD[1][i], 355154431);
		TextDrawTextSize(s_ExpLineTD[1][i], 270.0, 13.0);
	}
}

IFace.ExpLine_Create_Player(playerid)
{
	p_ExpTD[0] = CreatePlayerTextDraw(playerid, 215.0, (EXP_LINE_POS - 15.7), "11");
	PlayerTextDrawAlignment(playerid, p_ExpTD[0], 2);
	PlayerTextDrawBackgroundColor(playerid, p_ExpTD[0], 255);
	PlayerTextDrawFont(playerid, p_ExpTD[0], 2);
	PlayerTextDrawLetterSize(playerid, p_ExpTD[0], 0.5, 3.0);
	PlayerTextDrawColor(playerid, p_ExpTD[0], -1);
	PlayerTextDrawSetOutline(playerid, p_ExpTD[0], 0);
	PlayerTextDrawSetProportional(playerid, p_ExpTD[0], 1);
	PlayerTextDrawSetShadow(playerid, p_ExpTD[0], 0);

	p_ExpTD[1] = CreatePlayerTextDraw(playerid, 425.0, (EXP_LINE_POS - 15.7), "12");
	PlayerTextDrawAlignment(playerid, p_ExpTD[1], 2);
	PlayerTextDrawBackgroundColor(playerid, p_ExpTD[1], -1);
	PlayerTextDrawFont(playerid, p_ExpTD[1], 2);
	PlayerTextDrawLetterSize(playerid, p_ExpTD[1], 0.5, 3.0);
	PlayerTextDrawColor(playerid, p_ExpTD[1], -1);
	PlayerTextDrawSetOutline(playerid, p_ExpTD[1], 0);
	PlayerTextDrawSetProportional(playerid, p_ExpTD[1], 1);
	PlayerTextDrawSetShadow(playerid, p_ExpTD[1], 0);

	p_ExpTD[2] = CreatePlayerTextDraw(playerid, 320.0, (EXP_LINE_POS + 10.0), "0/100");
	PlayerTextDrawAlignment(playerid, p_ExpTD[2], 2);
	PlayerTextDrawBackgroundColor(playerid, p_ExpTD[2], 255);
	PlayerTextDrawFont(playerid, p_ExpTD[2], 1);
	PlayerTextDrawLetterSize(playerid, p_ExpTD[2], 0.2, 1.3);
	PlayerTextDrawColor(playerid, p_ExpTD[2], -1);
	PlayerTextDrawSetOutline(playerid, p_ExpTD[2], 1);
	PlayerTextDrawSetProportional(playerid, p_ExpTD[2], 1);
}