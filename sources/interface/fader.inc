#if defined _interface_fader_included
	#endinput
#endif

#define _interface_fader_included

forward OnFadeComplete(playerid, fadeid);

static 	
	pEndColor[MAX_PLAYERS][4],
	pCurrentColor[MAX_PLAYERS][4],
	pRateColor[MAX_PLAYERS][4],
	pStep[MAX_PLAYERS],
	pFadeTimer[MAX_PLAYERS],
	pFadeID[MAX_PLAYERS],
	PlayerText:fade_text[MAX_PLAYERS];

stock FadeColorForPlayer(playerid, RR1, GG1, BB1, AA1, RR2, GG2, BB2, AA2, steps, fadeid = FADE_NONE, recreate = false)
{
	//if(recreate)//&& pFadeTimer[playerid])
	//{
	//	PlayerTextDrawDestroy(playerid, fade_text[playerid]);
	//}

	if(recreate)
	{
		PlayerTextDrawDestroy(playerid, fade_text[playerid]);
		fade_text[playerid] = CreatePlayerTextDraw(playerid, 640.0, 0.0, "~g~");
		PlayerTextDrawAlignment(playerid,	fade_text[playerid], 3);
		PlayerTextDrawUseBox(playerid,		fade_text[playerid], 1);
		PlayerTextDrawLetterSize(playerid,	fade_text[playerid], 0.0, 50.0);
		PlayerTextDrawTextSize(playerid,	fade_text[playerid], 0.0, 0.0);
	}

	pFadeID[playerid] 	= fadeid;
	pStep[playerid] 	= (steps <= 0) ? 1 : steps;	//	countdown, sorta
	
	new tmpsteps; //	This will have to be added to incase the math is messed up (programming annoyance)
	tmpsteps += _setAmounts(playerid, 0, RR1, RR2);
	tmpsteps += _setAmounts(playerid, 1, GG1, GG2);
	tmpsteps += _setAmounts(playerid, 2, BB1, BB2);
	tmpsteps += _setAmounts(playerid, 3, AA1, AA2);
	if(tmpsteps)	pStep[playerid] += tmpsteps + 1;

	if(!pFadeTimer[playerid])	
	{
		pFadeTimer[playerid] = SetPlayerTimerEx(playerid, "UpdateFadeTimer", UPDATERATE, true, "i", playerid);
	}
	return true;
}

stock StopPlayerFade(playerid)
{
	if(!pFadeTimer[playerid])	return false;
	KillTimer(pFadeTimer[playerid]),	pFadeTimer[playerid] = 0;
	PlayerTextDrawHide(playerid, fade_text[playerid]);
	return true;
}

Public: UpdateFadeTimer(playerid)
{
	if(pStep[playerid]-- > 0)
	{
		for(new color; color < 4; color++)
		{
			pCurrentColor[playerid][color] -= pRateColor[playerid][color];
			if((pRateColor[playerid][color] > 0 && pCurrentColor[playerid][color] < pEndColor[playerid][color])
			|| (pRateColor[playerid][color] < 0 && pCurrentColor[playerid][color] > pEndColor[playerid][color]))
			{
				pCurrentColor[playerid][color] = pEndColor[playerid][color];
			}
			if(pCurrentColor[playerid][color] < 0)		pCurrentColor[playerid][color] = 0;
			if(pCurrentColor[playerid][color] > 255)	pCurrentColor[playerid][color] = 255;
		}
		PlayerTextDrawBoxColor(playerid, fade_text[playerid], _ConvertToColor(Arr4<pCurrentColor[playerid]>));
		PlayerTextDrawShow(playerid, fade_text[playerid]);
	}
	else
	{
		CallLocalFunction("OnFadeComplete", "ii", playerid, pFadeID[playerid]);
		KillTimer(pFadeTimer[playerid]),	pFadeTimer[playerid] = 0;
		//StopPlayerFade(playerid);
	}
	return true;
}

IFace.Fader_Create_Player(playerid)
{
	fade_text[playerid] = CreatePlayerTextDraw(playerid, 640.0, 0.0, "~g~");
	PlayerTextDrawAlignment(playerid, fade_text[playerid], 3);
	PlayerTextDrawUseBox(playerid, fade_text[playerid], 1);
	PlayerTextDrawLetterSize(playerid, fade_text[playerid], 0.0, 50.0);
	PlayerTextDrawTextSize(playerid, fade_text[playerid], 0.0, 0.0);
}

//////////	Private	//////////
static _setAmounts(playerid, index, amount1, amount2)
{
	pEndColor[playerid][index] 		= amount2;
	pCurrentColor[playerid][index] 	= amount1;	
	pRateColor[playerid][index] 	= (amount1 - amount2) / pStep[playerid];
	if(pRateColor[playerid][index] && ((amount1 - amount2) / pRateColor[playerid][index]) > pStep[playerid])
	{
		return ((amount1 - amount2) / pRateColor[playerid][index]) - pStep[playerid];	
	}
	return 0;
}

static _ConvertToColor(R, G, B, A)
{
	return ((R * 16777216) + (G * 65536) + (B * 256) + A);
}