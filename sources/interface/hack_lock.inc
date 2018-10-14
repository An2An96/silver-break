#if defined _interface_hack_lock_included
	#endinput
#endif

#define _interface_hack_lock_included

#define START_HACK_HEIGHT	397.0
#define FINISH_HACK_HEIGHT	370.0
#define HACK_MOVE_STEP		2.0

forward OnPlayerHackLockClick(playerid, step, success);
forward OnPlayerHackLock(playerid, success);

static
	Text:gHackLockFonts[6],
	Text:gHackLockBackground,
	PlayerText:pHackLock[MAX_PLAYERS][6],
	PlayerText:pHackPointer[MAX_PLAYERS],

	PointerHack[MAX_PLAYERS],
	Float:CurrentHeight[MAX_PLAYERS],
	pHackLockTimer[MAX_PLAYERS],
	pLastClickTime[MAX_PLAYERS],
	Float:pHackLockStart[MAX_PLAYERS][6],
	Float:pHackLockFinish[MAX_PLAYERS][6];

Public: HackLock_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(IFace.GetGroupToggle(playerid, IFace.HACK_LOCK))
	{
		if(PRESSED(KEY_FIRE))
		{
			if(CurrentHeight[playerid] > FINISH_HACK_HEIGHT)
			{
				new pointer = PointerHack[playerid];

				new bool:right;
				CurrentHeight[playerid] -= HACK_MOVE_STEP;
				if(pHackLockStart[playerid][pointer] >= CurrentHeight[playerid] >= pHackLockFinish[playerid][pointer])
				{
					right = true;
				}
				pLastClickTime[playerid] = GetTickCount();
				IFace.HackLock_CreateElement(playerid, pointer, CurrentHeight[playerid], right);
			}		
			return true;
		}
		else if(PRESSED(KEY_YES))
		{
			new pointer = PointerHack[playerid];
			if(pHackLockStart[playerid][pointer] >= CurrentHeight[playerid] >= pHackLockFinish[playerid][pointer])
			{
				CurrentHeight[playerid] = START_HACK_HEIGHT;
				if(PointerHack[playerid] == 5)
				{
					CancelPlayerHackLock(playerid);
				}
				else
				{
					if(CallLocalFunction("OnPlayerHackLockClick", "ddd", playerid, PointerHack[playerid], true))
					{
						PointerHack[playerid]++;
						IFace.HackLock_CreatePointer(playerid);
					}
					else
					{
						CancelPlayerHackLock(playerid, false);
					}
				}
			}
			else
			{
				CurrentHeight[playerid] = START_HACK_HEIGHT;
				if(pointer == 0)
				{
					CancelPlayerHackLock(playerid, false);
				}
				else
				{
					if(CallLocalFunction("OnPlayerHackLockClick", "ddd", playerid, PointerHack[playerid], false))
					{
						IFace.HackLock_CreateElement(playerid, PointerHack[playerid], CurrentHeight[playerid]);

						PointerHack[playerid]--;
						IFace.HackLock_CreatePointer(playerid);

						IFace.HackLock_CreateElement(playerid, PointerHack[playerid], CurrentHeight[playerid]);
					}
					else
					{
						CancelPlayerHackLock(playerid, false);
					}
				}
			}
			return true;
		}
		else if(PRESSED(KEY_NO))
		{
			CancelPlayerHackLock(playerid, false);
			return true;
		}
	}
	return CONTINUE;
}

//////////	Functions	//////////
SetPlayerHackLock(playerid, start[], len[], size = sizeof(start))
{
	new Float:bit = ((START_HACK_HEIGHT - FINISH_HACK_HEIGHT) / 100.0);
	for(new i = 0; i < size; i++)
	{
		pHackLockStart[playerid][i] 	= START_HACK_HEIGHT - (bit * float(start[i]));
		pHackLockFinish[playerid][i]	= pHackLockStart[playerid][i] - (bit * float(len[i]));
	}

	IFace.ToggleGroup(playerid, IFace.HACK_LOCK, true);
	TogglePlayerControllable(playerid, false);
	return true;
}

CancelPlayerHackLock(playerid, bool:success = true)
{
	TogglePlayerControllable(playerid, true);
	CallLocalFunction("OnPlayerHackLock", "dd", playerid, success);
	IFace.ToggleGroup(playerid, IFace.HACK_LOCK, false);
	return true;
}

Public: IFace.HackLock_Toggle(playerid, bool:toggle, bool:changeVisibility)
{
	if(toggle)
	{
		if(!changeVisibility)
		{
			PointerHack[playerid] = 0;
			CurrentHeight[playerid] = START_HACK_HEIGHT;
			pHackLockTimer[playerid] = SetPlayerTimerEx(playerid, "HackLock_Timer", 100, true, "d", playerid);

			for(new i = 0; i < 6; i++)
			{
				IFace.HackLock_CreateElement(playerid, i, CurrentHeight[playerid]);
			}
			IFace.HackLock_CreatePointer(playerid);
		}
		else
		{
			for(new i = 0; i < 6; i++)
			{
				PlayerTextDrawShow(playerid, pHackLock[playerid][i]);
			}
			PlayerTextDrawShow(playerid, pHackPointer[playerid]);
		}

		TextDrawShowForPlayer(playerid, gHackLockBackground);
		for(new i = 0; i < 6; i++)
		{
			TextDrawShowForPlayer(playerid, gHackLockFonts[i]);
		}
	}
	else
	{
		if(!changeVisibility)
		{
			for(new i = 0; i < 6; i++)
			{
				PlayerTextDrawDestroy(playerid, pHackLock[playerid][i]), pHackLock[playerid][i] = PlayerText:0;
			}
			PlayerTextDrawDestroy(playerid, pHackPointer[playerid]), pHackPointer[playerid] = PlayerText:0;
	
			KillTimer(pHackLockTimer[playerid]);
		}
		else
		{
			for(new i = 0; i < 6; i++)
			{
				PlayerTextDrawHide(playerid, pHackLock[playerid][i]);
			}
			PlayerTextDrawHide(playerid, pHackPointer[playerid]);
		}

		TextDrawHideForPlayer(playerid, gHackLockBackground);
		for(new i = 0; i < 6; i++)
		{
			TextDrawHideForPlayer(playerid, gHackLockFonts[i]);
		}
	}
}

//////////	Private		//////////
Public: HackLock_Timer(playerid)
{
	if(pLastClickTime[playerid] + 300 > GetTickCount())	return true;
	if(CurrentHeight[playerid] < START_HACK_HEIGHT)
	{
		new bool:right;
		CurrentHeight[playerid] += HACK_MOVE_STEP;
		new pointer = PointerHack[playerid];
		if(pHackLockStart[playerid][pointer] >= CurrentHeight[playerid] >= pHackLockFinish[playerid][pointer])
		{	
			right = true;
		}
		IFace.HackLock_CreateElement(playerid, PointerHack[playerid], CurrentHeight[playerid], right);
	}	
	return true;	
}

static IFace.HackLock_CreatePointer(playerid)
{
	if(IFace.GetGroupToggle(playerid, IFace.HACK_LOCK))
	{
		if(pHackPointer[playerid])
		{
			PlayerTextDrawDestroy(playerid, pHackPointer[playerid]), pHackPointer[playerid] = PlayerText:0;
		}
		pHackPointer[playerid] = CreatePlayerTextDraw(playerid, 530.0 + (10.0 * PointerHack[playerid]), 405.0, ".");
		PlayerTextDrawAlignment(playerid, pHackPointer[playerid], 2);
		PlayerTextDrawBackgroundColor(playerid, pHackPointer[playerid], 0x751C1AFF);
		PlayerTextDrawFont(playerid, pHackPointer[playerid], 1);
		PlayerTextDrawLetterSize(playerid, pHackPointer[playerid], 0.25, 1.0);
		PlayerTextDrawColor(playerid, pHackPointer[playerid], 0xA32725FF);
		PlayerTextDrawSetOutline(playerid, pHackPointer[playerid], 0);
		PlayerTextDrawSetProportional(playerid, pHackPointer[playerid], 1);
		PlayerTextDrawSetShadow(playerid, pHackPointer[playerid], 0);

		if(IFace.GetGroupVisible(playerid, IFace.HACK_LOCK))
		{
			PlayerTextDrawShow(playerid, pHackPointer[playerid]);
		}
	}
}

static IFace.HackLock_CreateElement(playerid, element, Float:height, right = false)
{
	if(IFace.GetGroupToggle(playerid, IFace.HACK_LOCK))
	{
		if(pHackLock[playerid][element])
		{
			PlayerTextDrawDestroy(playerid, pHackLock[playerid][element]), pHackLock[playerid][element] = PlayerText:0;
		}
		pHackLock[playerid][element] = CreatePlayerTextDraw(playerid , 530.0 + (10.0 * element), height, "x");
		PlayerTextDrawAlignment(playerid, pHackLock[playerid][element], 2);
		PlayerTextDrawBackgroundColor(playerid, pHackLock[playerid][element], 255);
		PlayerTextDrawFont(playerid, pHackLock[playerid][element], 1);
		PlayerTextDrawLetterSize(playerid, pHackLock[playerid][element], 0.0, 1.0);
		PlayerTextDrawColor(playerid, pHackLock[playerid][element], -1);
		PlayerTextDrawSetOutline(playerid, pHackLock[playerid][element], 0);
		PlayerTextDrawSetProportional(playerid, pHackLock[playerid][element], 1);
		PlayerTextDrawSetShadow(playerid, pHackLock[playerid][element], 1);
		PlayerTextDrawUseBox(playerid, pHackLock[playerid][element], 1);
		PlayerTextDrawBoxColor(playerid, pHackLock[playerid][element], right ? 0xA32725FF : 0x4E5561FF);
		PlayerTextDrawTextSize(playerid, pHackLock[playerid][element], 0.0, 1.0);
		PlayerTextDrawShow(playerid, pHackLock[playerid][element]);

		if(IFace.GetGroupVisible(playerid, IFace.HACK_LOCK))
		{
			PlayerTextDrawShow(playerid, pHackLock[playerid][element]);
		}
	}
}

////////////////////////////////////////
IFace.Hack_Create_Base()
{
	gHackLockBackground = TextDrawCreate(555.0, 365.0, "_");
	TextDrawAlignment(gHackLockBackground, 2);
	TextDrawBackgroundColor(gHackLockBackground, 255);
	TextDrawFont(gHackLockBackground, 1);
	TextDrawLetterSize(gHackLockBackground, 0.5, 5.5);
	TextDrawColor(gHackLockBackground, -1);
	TextDrawSetOutline(gHackLockBackground, 0);
	TextDrawSetProportional(gHackLockBackground, 1);
	TextDrawSetShadow(gHackLockBackground, 1);
	TextDrawUseBox(gHackLockBackground, 1);
	TextDrawBoxColor(gHackLockBackground, INTERFACE_MAIN_COLOR);
	TextDrawTextSize(gHackLockBackground, 0.0, 70.0);

	for(new i = 0; i < 6; i++)
	{
		gHackLockFonts[i] = TextDrawCreate(530.0 + (10.0 * i), 370.0, "_");
		TextDrawAlignment(gHackLockFonts[i], 2);
		TextDrawBackgroundColor(gHackLockFonts[i], 255);
		TextDrawFont(gHackLockFonts[i], 1);
		TextDrawLetterSize(gHackLockFonts[i], 0.5, 4.0);
		TextDrawColor(gHackLockFonts[i], -1);
		TextDrawSetOutline(gHackLockFonts[i], 0);
		TextDrawSetProportional(gHackLockFonts[i], 1);
		TextDrawSetShadow(gHackLockFonts[i], 1);
		TextDrawUseBox(gHackLockFonts[i], 1);
		TextDrawBoxColor(gHackLockFonts[i], 0x212429FF);
		TextDrawTextSize(gHackLockFonts[i], 0.0, 1.0);
	}
}