#if defined _system_combinations_included
  #endinput
#endif

#define _system_combinations_included					

#include "player/header"

forward OnPlayerSelectComb(playerid, source, bool:comb);
forward OnPlayerCombFinish(playerid, source, bool:fail);

static 
	bool:CombShow[MAX_PLAYERS],			//	отображать ли что нажимать
	CombSource[MAX_PLAYERS],			//	указатель что за комбинация (enum)
	CombCount[MAX_PLAYERS],				//	сколько всего шагов в комбинации
	CurentCombStep[MAX_PLAYERS],		//	текущий шаг в комбинации
	bool:PlayerComb[MAX_PLAYERS][16],	//	комбинация (0 - N, 1 - Y)
	CombTimer[MAX_PLAYERS];				//	таймер начала следующего шага

Public: Comb_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(CombSource[playerid] != COMB_NONE && CombTimer[playerid] == 0)
	{
		new bool:flag;
		if(PRESSED(KEY_ANALOG_RIGHT))
	    {
	    	flag = true;
	    }
	    else if(PRESSED(KEY_ANALOG_LEFT))
	    {
	    	flag = false;
	    }
	    else
	    {
	    	return true;
	    }

	    if(PlayerComb[playerid][ CurentCombStep[playerid] ] == flag)	
		{
			CurentCombStep[playerid]++;
			IFace.ShowPlayerProgress(playerid,
				CurentCombStep[playerid], CombCount[playerid], "Progress");
			new delay = CallLocalFunction("OnPlayerSelectComb", "ddd", playerid, CombSource[playerid], flag);
			if(delay)
				CombTimer[playerid] = SetTimerEx("_NextPlayerCombStep", delay, false, "d", playerid);
			else
				_NextPlayerCombStep(playerid);
		}
		else
		{
			new result = CallLocalFunction("OnPlayerCombFinish", "ddd", playerid, CombSource[playerid], true);
			if(result)
				_RestartInput(playerid);
			else
				ClearPlayerComb(playerid);
		}
	}
    return CONTINUE;
}

stock SetPlayerComb(playerid, source, comb_size, bool:comb[], bool:comb_show = true)
{
	CombShow[playerid] = comb_show;
	CurentCombStep[playerid] = 0;
	CombSource[playerid] = source;
	CombCount[playerid] = comb_size;
	for(new i = 0; i < CombCount[playerid]; i++)
	{
		PlayerComb[playerid][i] = comb[i];
	}
	_ShowComb(playerid);
	IFace.ShowPlayerProgress(playerid, 0, CombCount[playerid], "Progress");
	return true;
}

stock ClearPlayerComb(playerid)
{
	KillTimer(CombTimer[playerid]);
	CombTimer[playerid] = 0;
	CombSource[playerid] = COMB_NONE;
	CombCount[playerid] = 0;
	CurentCombStep[playerid] = 0;
	CombShow[playerid] = false;
	IFace.ProgressBarHide(playerid);
}

stock GetPlayerComb(playerid)
{
	return CombSource[playerid];
}

stock _GenerateComb(comb_size, comb[])
{
	for(new i = 0; i < comb_size; i++){
		comb[i] = random(2) ? false : true;
	}
}

Public: _NextPlayerCombStep(playerid)
{
	if(CurentCombStep[playerid] >= CombCount[playerid])
	{
		new result = CallLocalFunction("OnPlayerCombFinish", "ddd", playerid, CombSource[playerid], false);
		if(result)	_RestartInput(playerid);
		else 		ClearPlayerComb(playerid);
	}
	else
	{
		_ShowComb(playerid);
	}
	CombTimer[playerid] = 0;
	return true;
}

//////////	Private	//////////
static _ShowComb(playerid)
{
	if(CombShow[playerid])
	{
		if(PlayerComb[playerid][ CurentCombStep[playerid] ])
		{
			GameTextForPlayer(playerid, RusText("~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Нажмите ~y~Num 6", isRus(playerid)), 900, 3);
		}
		else
		{
			GameTextForPlayer(playerid, RusText("~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Нажмите ~y~Num 4", isRus(playerid)), 900, 3);
		}
	}
}

static _RestartInput(playerid)
{
	CurentCombStep[playerid] = 0;
	_ShowComb(playerid);
	IFace.ShowPlayerProgress(playerid, 0, CombCount[playerid], "Progress");
}