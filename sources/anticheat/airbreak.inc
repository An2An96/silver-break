static	UpdatePlayerOldPos(playerid, Float:x, Float:y, Float:z)
{
	SetPVarInt(playerid, "AC:ChangePos:GTC", GetTickCount());
	OldPlayerPos[playerid][0] = x;
	OldPlayerPos[playerid][1] = y;
	OldPlayerPos[playerid][2] = z;
	return (1);
}

stock AirBreak_PutPlayerInVehicle(playerid, vehicleid, seatid)
{
	if (GetVehicleModel(vehicleid) == 0)
		return (0);
	GetVehiclePos(vehicleid, Arr3<OldPlayerPos[playerid]>);
	SetPVarInt(playerid, "AC:ChangePos:GTC", GetTickCount());
	PutPlayerInVehicle(playerid, vehicleid, seatid);
	return true;
}
#if defined _ALS_PutPlayerInVehicle
	#undef PutPlayerInVehicle
#else
	#define _ALS_PutPlayerInVehicle
#endif
#define PutPlayerInVehicle	AirBreak_PutPlayerInVehicle

stock	AirBreak_SetPlayerPos(playerid, Float:x, Float:y, Float:z)
{
	if (SetPlayerPos(playerid, x, y, z))
	{
		UpdatePlayerOldPos(playerid, x, y, z);
		return (1);
	}
	return (0);
}
#if defined _ALS_SetPlayerPos
	#undef SetPlayerPos
#else
	#define _ALS_SetPlayerPos
#endif
#define SetPlayerPos	AirBreak_SetPlayerPos

stock	AirBreak_SetVehiclePos(vehicleid, Float:x, Float:y, Float:z)
{
	if (VehInfo[vehicleid][vDriver] >= 0)
		UpdatePlayerOldPos(VehInfo[vehicleid][vDriver], x, y, z);
	if (VehInfo[vehicleid][vCoDriver] >= 0)
		UpdatePlayerOldPos(VehInfo[vehicleid][vCoDriver], x, y, z);
	if (VehInfo[vehicleid][vLeftSeat] >= 0)
		UpdatePlayerOldPos(VehInfo[vehicleid][vLeftSeat], x, y, z);
	if (VehInfo[vehicleid][vRightSeat] >= 0)
		UpdatePlayerOldPos(VehInfo[vehicleid][vRightSeat], x, y, z);
	return SetVehiclePos(vehicleid, x, y, z);
}
#if defined _ALS_SetVehiclePos
	#undef SetVehiclePos
#else
	#define _ALS_SetVehiclePos
#endif
#define SetVehiclePos	AirBreak_SetVehiclePos

public	OnPlayerCheckAnticheat(playerid)
{
	new player_state = GetPlayerState(playerid);
	if (PLAYER_STATE_ONFOOT <= player_state <= PLAYER_STATE_PASSENGER)
	{
		new string[128];
		new const ac_gtc = GetTickCount();
		new const ac_delay = AC_GetPlayerDelay(playerid);

		if(ac_gtc > (GetPVarInt(playerid, "AC:ChangePos:GTC") + ac_delay)
			&& !IsPlayerAFK(playerid))
		{
			new Float:X, Float:Y, Float:Z, Float:A;
			GetPlayerPos(playerid, X, Y, Z);
			GetPlayerFacingAngle(playerid, A);

			new bool:update_cord = true;
			new Float:sZ = (Z < OldPlayerPos[playerid][2]) ? OldPlayerPos[playerid][2] : Z;
			new Float:var = floatsqroot(GetDistanceFromPointToPoint(X, Y, sZ, Arr3<OldPlayerPos[playerid]>));


			new vehicleid = GetPlayerVehicleID(playerid), 
				vsurfinf = GetPlayerSurfingVehicleID(playerid);
			//	пешком:		1.285
			//	в машине:	2.443
			//	аирбрейк:	6.31

			//	---	Teleport Hack
			if (OldPlayerPos[playerid][2] > -50.0)
			{
				if (var > 6.5)
				{
					if (player_state != PLAYER_STATE_PASSENGER)
					{
						update_cord = false;
						SetPVarInt(playerid, "AC:DetectTeleporting", true);
						GiveAnticheatWarn(playerid, TELEPORT_HACK);

						//	Выключаем игроку элементы стримера
						TogglePlayerStreamerAllItem(playerid, false);

						//	Сообщаем
						format(string, sizeof(string),
							"подозревается в телепортации [%s -> %s]",
								GetPointArea(OldPlayerPos[playerid][0], OldPlayerPos[playerid][1]),
								GetPointArea(X, Y));
						AC_PlayerMessage(playerid, string);

						//	Пытаемся вернуть назад
						if(vehicleid)
							MySetVehiclePos(vehicleid, Arr4<OldPlayerPos[playerid]>);
						else
							MySetPlayerPos(playerid, Arr4<OldPlayerPos[playerid]>);
					}
				}
				else
				{
					if (GetPVarInt(playerid, "AC:DetectTeleporting"))
					{
						//	Включаем игроку элементы стримера
						TogglePlayerStreamerAllItem(playerid, true);
						DeletePVar(playerid, "AC:DetectTeleporting");
					}

					//	Air Break
					if (player_state == PLAYER_STATE_ONFOOT
						&& vsurfinf == INVALID_VEHICLE_ID)
					{
						if (GetPlayerSurfingObjectID(playerid) == INVALID_OBJECT_ID
							&& GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_USEJETPACK)
						{
							if (ac_gtc > (p_Protect[playerid][prLastChangeState] + ac_delay))
							{
								if (var > 1.5)
								{
									format(string, sizeof(string),
										"подозревается в AirBreak пешком [height: %.2f | %.2f]", Z, var);
									AC_PlayerMessage(playerid, string);
									GiveAnticheatWarn(playerid, AIR_BREAK);
								}
							}
						}
					}
					else if (player_state == PLAYER_STATE_DRIVER)
					{
						if (var > 2.7)
						{
							format(string, sizeof(string),
								"подозревается в AirBreak в авто [height: %.2f | %.2f]", Z, var);
							AC_PlayerMessage(playerid, string);
							GiveAnticheatWarn(playerid, AIR_BREAK);
						}
					}
				}
			}
			if (update_cord)
			{
				OldPlayerPos[playerid][0] = X;
				OldPlayerPos[playerid][1] = Y;
				OldPlayerPos[playerid][2] = Z;
				OldPlayerPos[playerid][3] = A;
			}
		}
	}

	#if defined AirBreak_OnPlayerCheckAnticheat
		return (AirBreak_OnPlayerCheckAnticheat(playerid));
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerCheckAnticheat
	#undef OnPlayerCheckAnticheat
#else
	#define _ALS_OnPlayerCheckAnticheat
#endif
#define OnPlayerCheckAnticheat AirBreak_OnPlayerCheckAnticheat
#if defined AirBreak_OnPlayerCheckAnticheat
	forward AirBreak_OnPlayerCheckAnticheat(playerid);
#endif
