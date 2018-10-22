#if defined _gym_bench_press_included
	#endinput
#endif
#define _gym_bench_press_included

//  Жим лежа
enum
{
    BENCHPRESS_UP = 1,
    BENCHPRESS_DOWN
};

enum
{
    BENCHSTEP_START_DOWN,
    BENCHSTEP_START_READY,
    BENCHSTEP_DOWN_FINISH,
    BENCHSTEP_UP_FINISH,
    BENCHSTEP_FINISH_UP,
    BENCHSTEP_FINISH_ALL
}

new const Float:BenchpressPos[][10] =
{
	//  X, Y, Z, ANGEL POS          |   X, Y, Z, RX, RY, RZ Benchpress object
	//  Prison
	{	514.5, -2722.7, 13.2, 00.00,
		513.976, -2721.272, 13.086, -88.6, 89.5, 0.0 },
	{	519.3, -2722.6, 13.2, 00.00,
		519.715, -2721.252, 13.029, 0.0, -90.5, 0.0 },
	{	550.9, -2777.9, 13.2, 270.0,
		552.249, -2778.369, 13.086, -89.9, 0.0, 0.0 },
	{	551.0, -2782.1, 13.2, 270.0,
		552.332, -2782.501, 13.070, -89.2, 0.0, 0.0 },
	//  Ganton Gym
	{	772.98, 1.40, 1000.7, 270.0,
		774.443, 0.991, 1000.635, 0.2, 89.2, 90.5 },
	//	SF Gym
	{	766.27, -47.4, 1000.6, 180.0,
		765.817, -48.8, 1000.647, 0.0, 90.2, 0.00 }
};
new bool:BenchpressUsed[ sizeof(BenchpressPos) ],
	g_BenchpressObject[ sizeof(BenchpressPos) ],
	bool:playerBenchStop[MAX_PLAYERS char],
	playerBenchStep[MAX_PLAYERS char],
	playerBenchUsed[MAX_PLAYERS char],
	BenchpressTimer[MAX_PLAYERS],
	BenchpressStepTimer[MAX_PLAYERS];

stock	BenchpressInit()
{
	for (new i = 0; i < sizeof(BenchpressPos); i++)
	{
	    CreateDynamic3DTextLabel(ACTION_TEXT, COLOR_ACTION,
			Arr3<BenchpressPos[i]>, 2.5);
	    g_BenchpressObject[i] = CreateDynamicObject(2913,
			BenchpressPos[i][4], BenchpressPos[i][5], BenchpressPos[i][6],
			BenchpressPos[i][7], BenchpressPos[i][8], BenchpressPos[i][9]);
	}
	return (0);
}

stock	BenchpressStart(playerid, bench_idx)
{
	if (GetPlayerDrunkLevel(playerid) > 100)
		return SendClientMessage(playerid, COLOR_GREY,
			PREFIX_ERROR "Вы не можете тренироваться пьяным.");
	if (BenchpressUsed[bench_idx])
		return SendClientMessage(playerid, COLOR_GREY,
			PREFIX_ERROR "Данный тренажер занят.");
	if (PlayerInfo[playerid][pPower] >= 100.0)
		return ShowPlayerHint(playerid,
			"Ваша сила прокачена на максимум");
	if (PlayerInfo[playerid][pTraining] >= MAX_TRAINING)
		return ShowPlayerHint(playerid,
			"Вы достаточно потренеровались, приходите позже!");
	IFace.ToggleGroup(playerid, IFace.TV_EFFECT, true);
	SetPlayerArmedWeapon(playerid, 0);

	//	===================	Set player camera pos and look 	====================
	new Float:CameraPos[3],
		Float:CameraLookAt[3],
		Float:PlayerCameraPos[3],
		Float:PlayerCameraVector[3];

	CameraPos[0] = BenchpressPos[bench_idx][0]
		+ (1.4866 * floatsin(-BenchpressPos[bench_idx][3] + 70.34, degrees));
	CameraPos[1] = BenchpressPos[bench_idx][1]
		+ (1.4866 * floatcos(-BenchpressPos[bench_idx][3] + 70.34, degrees));
	CameraPos[2] = BenchpressPos[bench_idx][2] - 0.3;

	CameraLookAt[0] = BenchpressPos[bench_idx][0]
		+ (1.0049 * floatsin(-BenchpressPos[bench_idx][3] + 5.71, degrees));
	CameraLookAt[1] = BenchpressPos[bench_idx][1]
		+ (1.0049 * floatcos(-BenchpressPos[bench_idx][3] + 5.71, degrees));
	CameraLookAt[2] = BenchpressPos[bench_idx][2] - 0.3;

	GetPlayerCameraPos(playerid, Arr3<PlayerCameraPos>);
	GetPlayerCameraFrontVector(playerid, Arr3<PlayerCameraVector>);
	PlayerCameraVector[0] = PlayerCameraPos[0]
		+ floatmul(PlayerCameraVector[0], 5.0);
	PlayerCameraVector[1] = PlayerCameraPos[1]
		+ floatmul(PlayerCameraVector[1], 5.0);
	PlayerCameraVector[2] = PlayerCameraPos[2]
		+ floatmul(PlayerCameraVector[2], 5.0);

	InterpolateCameraPos(playerid,
		Arr3<PlayerCameraPos>, Arr3<CameraPos>, 5000);
	InterpolateCameraLookAt(playerid,
		Arr3<PlayerCameraVector>, Arr3<CameraLookAt>, 5000);
	MySetPlayerPos(playerid, Arr4<BenchpressPos[bench_idx]>);
	//	========================================================================

	BenchpressUsed[bench_idx] = true;
	GymAnimState{playerid} = 0;
	GymBlockKey{playerid} = true;
	playerBenchStop{playerid} = false;
	playerBenchUsed{playerid} = bench_idx + 1;
	playerBenchStep{playerid} = 0;
	BenchpressStepTimer[playerid] = SetTimerEx("BenchpressNext",
		3900, false, "ii", playerid, BENCHSTEP_START_DOWN);
	MyApplyAnimation(playerid, "benchpress", "gym_bp_geton", 4.1, 0, 0, 0, 1, 0);
	return (1);
}

static	BenchpressEND(playerid)
{
    new i = playerBenchUsed{playerid} - 1;

    //	==========================	Set Camera Pos 	============================
	new Float:CameraPos[3],
		Float:PlayerCameraPos[3],
		Float:PlayerCameraVector[3];
	const Float:fScale = 5.0;

	GetPlayerCameraPos(playerid, Arr3<PlayerCameraPos>);
	GetPlayerCameraFrontVector(playerid, Arr3<PlayerCameraVector>);

	PlayerCameraVector[0] =
		PlayerCameraPos[0] + floatmul(PlayerCameraVector[0], fScale);
	PlayerCameraVector[1] =
		PlayerCameraPos[1] + floatmul(PlayerCameraVector[1], fScale);
	PlayerCameraVector[2] =
		PlayerCameraPos[2]+ floatmul(PlayerCameraVector[2], fScale);

    CameraPos[0] =
		BenchpressPos[i][0] - 3.5 * floatsin(-BenchpressPos[i][3], degrees);
	CameraPos[1] =
		BenchpressPos[i][1] - 3.5 * floatcos(-BenchpressPos[i][3], degrees);
	CameraPos[2] =
		BenchpressPos[i][2] + 1.0;

	InterpolateCameraPos(playerid,
		Arr3<PlayerCameraPos>, Arr3<CameraPos>, 5000);
	InterpolateCameraLookAt(playerid,
		Arr3<PlayerCameraVector>,Arr3<BenchpressPos[i]>, 5000);
	//	========================================================================

	IFace.HidePlayerInfoBar(playerid);
	ProgressBarHide(playerid);

	MyApplyAnimation(playerid,
		"benchpress", "gym_bp_getoff", 4.1, 0, 0, 0, 0, 0);
	KillTimer(BenchpressStepTimer[playerid]);
	KillTimer(BenchpressTimer[playerid]);

	if (PlayerInfo[playerid][pJailTime])
		ShowPlayerPrisonTime(playerid);

	GymBlockKey{playerid} = true;
	BenchpressStepTimer[playerid] = SetTimerEx("BenchpressNext", 1800, false, "ii", playerid, BENCHSTEP_FINISH_UP);
    return (1);
}

Public: BenchpressNext(playerid, action)
{
	switch(action)
	{
		case BENCHSTEP_START_DOWN:
		{
			Streamer_RemoveArrayData(STREAMER_TYPE_OBJECT,
				g_BenchpressObject[ playerBenchUsed{playerid} - 1 ],
				E_STREAMER_PLAYER_ID, playerid);
			Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
	        SetPlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND, 2913, 5,
				0.099, 0.0039, 0.0606, 9.7105, -177.8293, 58.15, 1.0, 1.0, 1.0);
	        BenchpressStepTimer[playerid] = SetTimerEx("BenchpressNext",
				600, false, "ii", playerid, BENCHSTEP_START_READY);
	        ShowPlayerHint(playerid,
				"Нажимайте ~y~~k~~PED_SPRINT~~w~~n~\
				пока шкала справа не заполнится");
		}
		case BENCHSTEP_START_READY:
		{
			if(PlayerInfo[playerid][pJailTime])
				HidePlayerPrisonTime(playerid);
			GymBlockKey{playerid} = false;
		    ProgressBarUpdate(playerid, playerBenchStep{playerid}, 100);
			IFace.ShowPlayerInfoBar(playerid, "Повторений: 0");
	        BenchpressTimer[playerid] = SetTimerEx("BenchpressUpdate",
				100, true, "i", playerid);
		}
		case BENCHSTEP_DOWN_FINISH:	//  finish DOWN
		{
			ProgressBarUpdate(playerid, playerBenchStep{playerid}, 100);
		    GymBlockKey{playerid} = false;
		}
	 	case BENCHSTEP_UP_FINISH:	//  finish UP
	 	{
		 	GymCount{playerid}++;
			GivePlayerPower(playerid, 0.1);
			if(++PlayerInfo[playerid][pTraining] >= MAX_TRAINING)
			{
				BenchpressEND(playerid);
				ShowPlayerHint(playerid,
					"Вы достаточно потренеровались, приходите позже!");
			}
			else if(PlayerInfo[playerid][pPower] >= 100.0)
			{
				//	---	achievements
			#if defined _player_achieve_included	
				GivePlayerAchieve(playerid, ACHIEVE_ARNOLD);
			#endif
				BenchpressEND(playerid);
			}
			else
			{
				BenchpressDOWN(playerid);
				BenchpressStepTimer[playerid] = SetTimerEx("BenchpressNext",
					900, false, "ii", playerid, BENCHSTEP_DOWN_FINISH);
			}
			new string[32];
			format(string, 32, "Повторений: %d", GymCount{playerid});
			IFace.ShowPlayerInfoBar(playerid, string);
	 	}
	 	case BENCHSTEP_FINISH_UP:
	 	{
	 	    RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND);
	 	    new i = playerBenchUsed{playerid} - 1;
	 	    Streamer_AppendArrayData(STREAMER_TYPE_OBJECT,
				g_BenchpressObject[i], E_STREAMER_PLAYER_ID, playerid);
	 	    Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
	 	    BenchpressStepTimer[playerid] = SetTimerEx("BenchpressNext",
				6200, false, "ii", playerid, BENCHSTEP_FINISH_ALL);
	 	}
	 	case BENCHSTEP_FINISH_ALL:	//  finish
		{
			IFace.ToggleGroup(playerid, IFace.TV_EFFECT, false);
		    SetCameraBehindPlayer(playerid);
		    BlockPlayerAnimation(playerid, false);
		    MyApplyAnimation(playerid,
				"benchpress", "gym_bp_celebrate", 4.1, 0, 0, 0, 0, 0);
		    BenchpressUsed[ playerBenchUsed{playerid} - 1 ] = false;
		    playerBenchUsed{playerid} = 0;
			GymCount{playerid} = 0;
			GymBlockKey{playerid} = false;
		}
	}
	return true;
}

Public: BenchpressUpdate(playerid)
{
	if (playerBenchStep{playerid} == 0)
		return (1);
	if(playerBenchStep{playerid} < 100)
	{
		BenchpressDOWN(playerid);
		if (playerBenchStop{playerid})
			playerBenchStop{playerid} = false;
		else if (playerBenchStep{playerid} - 4 < 0)
			playerBenchStep{playerid} = 0;
		else
			playerBenchStep{playerid} = playerBenchStep{playerid} - 4;
		ProgressBarUpdate(playerid, playerBenchStep{playerid}, 100);
	}
	else
	{
	    GymBlockKey{playerid} = true;
		playerBenchStep{playerid} = 0;
	    BenchpressStepTimer[playerid] = SetTimerEx("BenchpressNext",
			500, false, "ii", playerid, BENCHSTEP_UP_FINISH);
	}
	return true;
}

static	BenchpressUP(playerid)
{
	if(GymAnimState{playerid} == BENCHPRESS_UP)
		return (1);
	GymAnimState{playerid} = BENCHPRESS_UP;
	return MyApplyAnimation(playerid,
		"benchpress", "gym_bp_up_smooth",4.1, 0, 0, 0, 1, 0);
}

static	BenchpressDOWN(playerid)
{
	if(GymAnimState{playerid} == BENCHPRESS_DOWN)
		return (1);
	GymAnimState{playerid} = BENCHPRESS_DOWN;
	return MyApplyAnimation(playerid,
		"benchpress", "gym_bp_down", 4.1, 0, 0, 0, 1, 0);
}

stock	BenchpressClear(playerid)
{
	if(playerBenchUsed{playerid})
	{
		KillTimer(BenchpressTimer[playerid]);
		KillTimer(BenchpressStepTimer[playerid]);
		ProgressBarHide(playerid);
		IFace.ToggleGroup(playerid, IFace.TV_EFFECT, false);
		IFace.HidePlayerInfoBar(playerid);
		SetCameraBehindPlayer(playerid);
		//BlockPlayerAnimation(playerid, false);

		if(PlayerInfo[playerid][pJailTime])
			ShowPlayerPrisonTime(playerid);

		RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND);
		new i = playerBenchUsed{playerid} - 1;
		Streamer_AppendArrayData(STREAMER_TYPE_OBJECT, g_BenchpressObject[i], E_STREAMER_PLAYER_ID, playerid);
		Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

		BenchpressUsed[i] = false;
		playerBenchUsed{playerid} = 0;
		GymCount{playerid} = 0;
		GymBlockKey{playerid} = false;
	}
	return (1);
}

public	OnPlayerClickSprint(playerid)
{
	//  Тренажеры
	if(playerBenchUsed{playerid} && GymBlockKey{playerid} == false)
	{
		playerBenchStep{playerid} += 5;
		playerBenchStop{playerid} = true;
		ProgressBarUpdate(playerid, playerBenchStep{playerid}, 100);
		BenchpressUP(playerid);
		return (1);
	}

	#if defined BenchPress_OnPlayerClickSprint
		return BenchPress_OnPlayerClickSprint(playerid);
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerClickSprint
	#undef OnPlayerClickSprint
#else
	#define _ALS_OnPlayerClickSprint
#endif
#define OnPlayerClickSprint BenchPress_OnPlayerClickSprint
#if defined BenchPress_OnPlayerClickSprint
	forward BenchPress_OnPlayerClickSprint(playerid);
#endif

public OnPlayerClickEnter(playerid)
{
	if (playerBenchUsed{playerid} && GymBlockKey{playerid} == false)
		return (BenchpressEND(playerid));
	else if (playerBenchUsed{playerid} == 0)
	{
		for (new i = 0; i < sizeof BenchpressPos; i++)
		{
			if (IsPlayerInRangeOfPoint(playerid, 2.5, Arr3<BenchpressPos[i]>))
				return (BenchpressStart(playerid, i));
		}
	}

	#if defined BenchPress_OnPlayerClickEnter
		return (BenchPress_OnPlayerClickEnter(playerid));
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerClickEnter
	#undef OnPlayerClickEnter
#else
	#define _ALS_OnPlayerClickEnter
#endif
#define OnPlayerClickEnter BenchPress_OnPlayerClickEnter
#if defined BenchPress_OnPlayerClickEnter
	forward BenchPress_OnPlayerClickEnter(playerid);
#endif