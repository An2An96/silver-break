#if defined _police_pursuit_included
	#endinput
#endif

#define _police_pursuit_included

#include "player/ask"
#include "faction/police/header"

Public: Pursuit_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	new string[128];
	new pState = GetPlayerState(playerid);
	new vehicleid = GetPlayerVehicleID(playerid);
	if(PRESSED(KEY_WALK))
    {
    	if(pState == PLAYER_STATE_ONFOOT)
    	{
			if(PlayerCuffedTime[playerid] == 0)
	    	{
	    		if(GetPVarInt(playerid, "Police:Pursuit:Handsup") && PursuitStatus[playerid] > PS_NONE && PlayerCuffedTime[playerid] == 0)
				{
					PursuitCancelHandsup[playerid] = 1;
					return true;
				}

				if(PlayerInfo[playerid][pFaction] == F_POLICE && IsPoliceDuty(playerid))
	    		{
					foreach(LoginPlayer, i)
					{
			    		if(GetDistanceBetweenPlayers(playerid, i) < 2.0 && GetPlayerState(i) == PLAYER_STATE_ONFOOT)
			    		{
			    			if(CriminalDanger[i] || (PM_Type[playerid] == 10 && PM_Place[playerid] == i && (GetPlayerWantedLevel(i) > 3 || PursuitAllowArrest[i])))
			    			{
				    			if(GetPVarInt(i, "Police:Arrest") == 1)
				    			{
				    				return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "Игрока уже арестовывает другой полицейский.");
				    			}
								if(GetPVarInt(i, "Police:Pursuit:Handsup"))
								{
									MyApplyAnimation(playerid, "INT_SHOP", "shop_loop", 4.1, 1, 0, 0, 0, 0);
								}
								else if(PlayerCuffedTime[i])
								{
									MyApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 0, 1, 1, 1, 0);
								}
								else
								{
									return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "Игрок должен поднять руки или быть оглушен.");
								}
								PursuitArest[playerid] = 1;
								PursuitArestPlayer[playerid] = i;
								SetPVarInt(i, "Police:Arrest", 1);
								GameTextForPlayer(i, "~r~A ~b~r ~r~r ~b~e ~r~s ~b~t", 500, 3);
								GameTextForPlayer(playerid, "~r~A ~b~r ~r~r ~b~e ~r~s ~b~t", 500, 3);
								return true;
							}
						}
			    	}
		    	}
			}
		}
	}
	else if(RELEASED(KEY_WALK))
	{
		if(PursuitArest[playerid])
		{
        	DeletePVar(PursuitArestPlayer[playerid], "Police:Arrest");
        	PursuitArest[playerid] = 0;
        	PursuitArestPlayer[playerid] = INVALID_PLAYER_ID;
        	GameTextForPlayer(playerid, "~r~arrest failure", 3000, 3);
        	ClearAnimations(playerid);
        	ProgressBarHide(playerid);
        }
		if(PursuitCancelHandsup[playerid])
		{
			PursuitCancelHandsup[playerid] = 0;
			ProgressBarHide(playerid);
		}
	}
	else if(PRESSED(KEY_CTRL_BACK))	// H
	{
		if(pState == PLAYER_STATE_DRIVER)
		{
			if(IsVehicleWithEngine(GetPlayerVehicleID(playerid)))
			{
	        	if(CarInfo[vehicleid][cType] == C_TYPE_FACTION && CarInfo[vehicleid][cOwnerID] == PlayerInfo[playerid][pFaction])
		    	{
		    		if(CarInfo[vehicleid][cOwnerID] == F_POLICE)
					{
						if(PM_Type[playerid] == 10)
						{	// Ведет преследование подозреваемого
							new suspectid = PM_Place[playerid];
							if(PS_NONE < PursuitStatus[suspectid] < PS_CRIMINAL)
							{
								return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Помощь в задержании пока не требуется.");
							}
							if(PursuitReinforcReload[playerid])
							{
								return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Подкрепление недавно уже запрашивалось.");
							}
							PursuitReinforc[playerid] = 1;
							return true;
						}
					}
		    	}
	        }
	    }
	}
	else if(RELEASED(KEY_CTRL_BACK))
	{
		if(PursuitReinforc[playerid])
		{
			PursuitReinforc[playerid] = 0;
			ProgressBarHide(playerid);
		}
	}
	else if(PRESSED(KEY_SUBMISSION))
	{
		if(pState == PLAYER_STATE_ONFOOT)	//	колесико мышки
		{
			if(GetPVarInt(playerid, "Police:Pursuit:Handsup") == 0 && PursuitStatus[playerid] > PS_NONE && PlayerCuffedTime[playerid] == 0)
			{
				if(GetPlayerWeapon(playerid) != 0)
				{
					ShowPlayerHint(playerid, "Чтобы поднять руки спрячьте оружие");
				}
				else
				{
					PursuitHandsup(playerid);
				}
			}
			else
			{
				if(PlayerInfo[playerid][pAnim] > 0)
				{
					MyApplyAnimation(playerid, PlayerAnims[ PlayerInfo[playerid][pAnim] ][PANIM_LIB], PlayerAnims[ PlayerInfo[playerid][pAnim] ][PANIM_NAME], 4.1, 0, 0, 0, 0, 0);
				}
			}
		}
	    else if(pState == PLAYER_STATE_DRIVER) // KEY_2
		{
			if(CarInfo[vehicleid][cType] == C_TYPE_FACTION && CarInfo[vehicleid][cOwnerID] == PlayerInfo[playerid][pFaction])
		    {
				// Преследование на транспорте
				if(CarInfo[vehicleid][cOwnerID] == F_POLICE)
				{
					if(!IsPoliceDuty(playerid))
		    		{
		    			return ShowPlayerHint(playerid, "Для остановки транспорта вы должны быть на ~b~дежурстве");
		    		}
					new model = GetVehicleModel(GetPlayerVehicleID(playerid));
					if(PM_Type[playerid] == 0)
					{// Не выполняет задание
						new bool:founded, Float:curdist, Float:mindist, suspectid, vehid, mtype;
						foreach(LoginPlayer, i)
						{
							if(IsForce(PlayerInfo[i][pFaction]) || GetPlayerState(i) != 2) continue;
							//
							if(model == 497)
							{
								curdist = GetDistanceBetweenPlayers(playerid, i, true);
								if(curdist > 100)	continue;
							}
							else
							{
								curdist = GetDistanceBetweenPlayers(playerid, i);
								if(curdist > 50)	continue;
							}
							//
							vehid = GetPlayerVehicleID(i);
							//if(VehInfo[vehid][vWithEngine] == false) continue;
							mtype = VehInfo[vehid][vModelType];
							if(mtype == MTYPE_RC || mtype == MTYPE_TRAIN || mtype == MTYPE_BOAT || mtype == MTYPE_HELIC || mtype == MTYPE_PLANE) continue;
							//
							if(curdist < mindist || founded == false)
							{
								suspectid = i;
								mindist = curdist;
								founded = true;
							}
						}
						if(founded)
						{
							if(GetPlayerWarGangZone(suspectid) >= 0 && PursuitStatus[suspectid] == PS_NONE)
							{
								return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете запросить остановку члена банды во время захвата территории.");
							}
							if(IsPlayerAFK(suspectid))
							{
								return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Подозреваемый находится в AFK, его нельзя остановить.");
							}
							new bool:wl_veh = false;
							foreach(LoginPlayer, i)
							{
							    if(IsPlayerInVehicle(i, vehid) && GetPlayerWantedLevel(i) > 0)
							    {
							        wl_veh = true; // В машине найден игрок с розыском
							        break;
							    }
							}
							if(!wl_veh && PursuitLastUNIX[suspectid] > gettime())
							{
							    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Совсем недавно этот автомобиль уже проверяли.");
							}
							if(PS_NONE < PursuitStatus[suspectid] < PS_CRIMINAL)
							{
								return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Помощь в задержании пока не требуется, но будьте на чеку.");
							}
							// Формируем задание
							if(!PursuitStatus[suspectid])
							{
								if(model == 497)
								{
									return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "На вертолете можно только подключиться к погоне.");
								}
								PursuitTimer(suspectid);
								new sound = 15800;
								format(string, 128, "[%s %s:o< Это отделение полиции Лос-Сантос. Оставайтесь на месте!]", GetPlayerRank(playerid), ReturnPlayerName(playerid));
								//format(string, 128, "[%s %s:o< Водитель %s, прижмитесь к обочине и остановитесь]", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(suspectid));
								SendRadiusMessage(playerid, 60.0, COLOR_YELLOW, string);
								PlayerPlaySound(playerid, sound, 0, 0, 0);
								PlayerPlaySound(suspectid, sound, 0, 0, 0);
							}
							else
							{
								format(string, 128, "[R] %s %s: {FFFFFF}Подключаюсь к погоне за %s, прием.", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(suspectid));
								SendPoliceMessage(COLOR_BLUE, string);
							}
							if(CriminalDanger[suspectid])	format(string, 128, "~n~~n~Остановите ~r~%s ~w~любой ценой!", ReturnPlayerName(suspectid));
							else 							format(string, 128, "~n~~n~Задержите ~b~%s ~w~не применяя силы.", ReturnPlayerName(suspectid));
							// Подключаем всех копов в машине, из которой поступил запрос
							foreach(Cop, copid)
							{
							    if(PM_Type[copid] == 0 && GetPlayerVehicleID(copid) == vehicleid)
							    {
									PM_Type[copid] = 10;// Номер миссии (10 - преследование)
									PM_Place[copid] = suspectid;// ид подозреваемого
									PM_UNIX[copid] = gettime();// Время начала погони
									SendMissionMessage(copid, string, 0);// Вывод задания
								}
							}
						}
						else
						{
							SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Поблизости не найдено ни одного игрока.");
						}
						return true;
					}
					else if(PM_Type[playerid] == 10)
					{	// Ведет преследование подозреваемого
						new suspectid = PM_Place[playerid];
						if(GetDistanceBetweenPlayers(playerid, suspectid) > 50)
						{
							return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Подозреваемый слишком далеко, подъедьте ближе.");
						}
						if(PursuitStatus[suspectid] == PS_WAIT)
						{
							return ShowPlayerHint(playerid, "Требования выполнены, задержите подозреваемого");
						}
						if(IsPlayerInAnyVehicle(suspectid) == 0)
						{
							return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Подозреваемый вышел из машины, задержите его.");
						}
						new nowtick = GetTickCount();
						if(PursuitTickcount[suspectid] > nowtick)
						{
							format(string, 128, "Остановку уже запрашивали, до следующего раза: ~y~%d сек", 1+(PursuitTickcount[suspectid]-nowtick)/1000);
							return ShowPlayerHint(playerid, string);
						}
						new sound = 15800;
						format(string, 128, "[%s %s:o< Это отделение полиции Лос-Сантос. Оставайтесь на месте!]", GetPlayerRank(playerid), ReturnPlayerName(playerid));
						//if(!random(2))	format(string, 128, "[%s %s:o< Прижмитесь к обочине или мы будем вынуждены применить силу]", GetPlayerRank(playerid), ReturnPlayerName(playerid));
						//else 			format(string, 128, "[%s %s:o< Водитель %s, последнее предупреждение и мы открываем огонь]", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(suspectid));
						SendRadiusMessage(playerid, 60.0, COLOR_YELLOW, string);
						PlayerPlaySound(playerid, sound, 0, 0, 0);
						PlayerPlaySound(suspectid, sound, 0, 0, 0);
						PursuitTickcount[suspectid] = nowtick + 15000;
					}
					else
					{
						SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы выполняете задание, подробнее в /hq.");
					}
					return true;
				}
			}
		}
		else if(pState == PLAYER_STATE_PASSENGER)
		{
			if(PlayerInfo[playerid][pFaction] == F_POLICE && PM_Type[playerid] == 0 && VehInfo[vehicleid][vDriver] >= 0)
			{
				new driver = VehInfo[vehicleid][vDriver];
				if(PlayerInfo[driver][pFaction] == F_POLICE && PM_Type[driver] == 10)
				{
					if(!IsPoliceDuty(playerid))
		    		{
		    			return ShowPlayerHint(playerid, "Для присоединения к погоне вы должны быть на ~b~дежурстве");
		    		}
		    		new suspectid = PM_Place[driver];
		    		if(PS_NONE < PursuitStatus[suspectid] < PS_CRIMINAL)
		    		{
		    			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Помощь в задержании пока не требуется, но будьте на чеку.");
		    		}
					// Формируем задание
					format(string, 128, "[R] %s %s: {FFFFFF}Подключаюсь к погоне за %s, прием.", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(suspectid));
					SendPoliceMessage(COLOR_BLUE, string);
					PM_Type[playerid] = 10;			// Номер миссии (10 - преследование)
					PM_Place[playerid] = suspectid;	// ид подозреваемого
					PM_UNIX[playerid] = gettime();	// Время начала погони
					if(CriminalDanger[suspectid])	format(string, 128, "~n~~n~Остановите ~r~%s ~w~любой ценой!", ReturnPlayerName(suspectid));
					else 							format(string, 128, "~n~~n~Задержите ~b~%s ~w~не применяя силы.", ReturnPlayerName(suspectid));
					SendMissionMessage(playerid, string, 0);	// Вывод задания
				}
			}
		}
	}
	return CONTINUE;
}

Police.Pursuit_QuickTimer(playerid)
{
	new i = playerid;
	//---	Cancel Handsup
	if(PursuitCancelHandsup[i])
	{
		if(++PursuitCancelHandsup[i] < 15)
		{
			ProgressBarUpdate(i, PursuitCancelHandsup[i], 15, RusText("Сопротивление", isRus(i)));
		}
		else
		{
			PursuitHandsupCancel(i);
			PursuitCancelHandsup[i] = 0;
			ProgressBarHide(i);
		}
	}
	//---	Reinforc
	if(PursuitReinforc[i])
	{
		if(++PursuitReinforc[i] < 20)
		{
			ProgressBarUpdate(i, PursuitReinforc[i], 20, RusText("Подмога", isRus(i)));
		}
		else
		{
			ProgressBarHide(i);
			PursuitReinforc[i] = 0;
			PursuitReinforcReload[i] = 120;
			PursuitReinforcTime[i] = 60;
			new Float:pos[3];
			GetPlayerPos(i, Arr3<pos>);
			PursuitReinforcMapIcon[i] = CreateDynamicMapIcon(Arr3<pos>, 30, COLOR_WHITE, GetPlayerVirtualWorld(i), GetPlayerInterior(i), i, 3000.0, MAPICON_GLOBAL);
			new string[128];
			format(string, sizeof(string), "[R] Диспетчер HQ: {FFFFFF}%s запрашивает подкрепление {8D8DFF}| Район: {FFFFFF}%s", ReturnPlayerName(i), GetPlayerArea(i));
			SendPoliceMessage(COLOR_BLUE, string);
		}
	}
	//---	Arrest
	if(PursuitArest[i])
	{
		new pursued = PursuitArestPlayer[i];
		if(++PursuitArest[i] < 50)
		{
			if(GetDistanceBetweenPlayers(i, pursued) < 2.0 && (PlayerCuffedTime[pursued] || GetPVarInt(pursued, "Police:Pursuit:Handsup")))
			{
				ProgressBarUpdate(i, PursuitArest[i], 50, RusText("Арест", isRus(i)));
				GameTextForPlayer(pursued, "~r~A ~b~r ~r~r ~b~e ~r~s ~b~t", 500, 3);
				GameTextForPlayer(i, "~r~A ~b~r ~r~r ~b~e ~r~s ~b~t", 500, 3);
			}
			else
			{
				DeletePVar(PursuitArestPlayer[i], "Police:Arrest");
				PursuitArest[i] = 0;
				PursuitArestPlayer[i] = INVALID_PLAYER_ID;
	        	GameTextForPlayer(i, "~r~arrest failure", 3000, 3);
	        	ClearAnimations(i);
	        	ProgressBarHide(i);
			}
		}
		else
		{
			new string[128];
			//MySetPlayerSpecialAction(pursued, SPECIAL_ACTION_CUFFED);
			if(PursuitStatus[pursued] == PS_NONE)
			{
    			PlayerInfo[i][pCopCases] += 1;
				SendFormatMessage(i, COLOR_DBLUE, string, "Преступник %s отправлен за решетку, отличная работа!", ReturnPlayerName(pursued));

				HidePlayerVisualTimer(pursued);
				FlashPoliceZone(pursued, false);
		        KillTimer(pursuit_timer[pursued]);
		        PursuitStatus[pursued] = PS_NONE;
		        PursuitCount[pursued] = 0;
		        pursuit_timer[pursued] = 0;
				SetPlayerInJail(pursued, true);
			}
			else StopPursuit(pursued, 4);
			SendFormatMessageToAll(COLOR_DBLUE, string, "[Госдепартамент]: %s {FFFFFF}%s[%d] {2641FE}арестовал преступника {FFFFFF}%s[%d]", GetPlayerRank(i), ReturnPlayerName(i), i, ReturnPlayerName(pursued), pursued);
			DeletePVar(PursuitArestPlayer[i], "Police:Arrest");
			PursuitArest[i] = 0;
			PursuitArestPlayer[i] = INVALID_PLAYER_ID;
        	ClearAnimations(i);
        	ProgressBarHide(i);
		}
	}
}

//////////	Functions	///////////
GetPlayerPursuit(playerid)
{
	return PursuitStatus[playerid];
}

CancelPlayerPursuit(playerid, reason = 0)
{
 	HidePlayerVisualTimer(playerid);
	KillTimer(pursuit_timer[playerid]);
	PursuitHandsupClear(playerid);	//	опускаем руки
	new wl = GetPlayerWantedLevel(playerid);
	if(wl == 0)	ShowPlayerHint(playerid, "~b~Вы свободны ~w~и ближайшие~n~90 секунд вас не остановят", 10000);
	else 		ShowPlayerHint(playerid, "~b~Вы свободны", 10000);
	if(!CriminalMarked[playerid])
	{	// Не подсвечивается
	    FlashPoliceZone(playerid, false);
	}
	PursuitLastUNIX[playerid] = gettime() + 90;
	PursuitStatus[playerid] = PS_NONE;
	PursuitAllowArrest[playerid] = false;
	PursuitIllegalItem[playerid] = false;
	pursuit_timer[playerid] = 0;
	DeletePVar(playerid, "Pursuit:CheckDoc");
	DeletePVar(playerid, "Pursuit:CheckDrunk");
	DeletePVar(playerid, "Pursuit:CheckLight");
	foreach(Cop, copid)
	{// Завершаем миссию копам
		if(PM_Type[copid] == 10 && PM_Place[copid] == playerid)
		{
			if(reason == 0)			PoliceMissionCancel(copid, "Подозреваемый освобожден");
			else if(reason == 1)	PoliceMissionComplete(copid, 0, "Проверка завершена");
			else if(reason == 2)	PoliceMissionComplete(copid, wl * COST_PER_WANTED, "Выписана квитанция");
		}
	}
}

Mission_CancelPursuit(playerid)
{
	new bool:founded = false;
    new suspectid = PM_Place[playerid];
    foreach(Cop, copid)
    {
		if(PM_Type[copid] == 10 && PM_Place[copid] == suspectid && copid != playerid)
		{
		    founded = true;
		    break;
		}
	}
	if(founded == false) StopPursuit(suspectid, 0);

	PursuitReinforcReload[playerid] = 0;
	PursuitReinforc[playerid] = 0;
	PursuitReinforcTime[playerid] = 0;
	DestroyDynamicMapIcon(PursuitReinforcMapIcon[playerid]), PursuitReinforcMapIcon[playerid] = INVALID_STREAMER_ID;
}

//	поднять игроку руки
PursuitHandsup(playerid)
{
	MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);
	ShowPlayerHint(playerid, "Для сопротивления удерживайте ~y~~k~~SNEAK_ABOUT~");
	SetPVarInt(playerid, "Police:Pursuit:Handsup", true);
	BlockPlayerAnimation(playerid, true);
}

//	опускание рук через ALT (сопротивление)
PursuitHandsupCancel(playerid)
{
	DeletePVar(playerid, "Police:Pursuit:Handsup");
	BlockPlayerAnimation(playerid, false);
	MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	ClearAnimations(playerid);
	ToggleCriminalDanger(playerid, true);
	CrimePlayer(playerid, CRIME_RESIST);
}

//	Отчищает поднятые руки (при поимке, убийстве и т д)
PursuitHandsupClear(playerid, clearanim = 1)
{
	DeletePVar(playerid, "Police:Pursuit:Handsup");
	BlockPlayerAnimation(playerid, false);
	if(PursuitCancelHandsup[playerid] > 0)
	{
		PursuitCancelHandsup[playerid] = 0;
		ProgressBarHide(playerid);
	}
	if(clearanim)
	{
		MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		ClearAnimations(playerid);
	}
}

UpdateIconReinforce(playerid)
{
	if(PursuitReinforcTime[playerid] > 0)
	{
		if(--PursuitReinforcTime[playerid] > 0)
		{
			new Float:X, Float:Y, Float:Z;
			Streamer_SetFloatData(STREAMER_TYPE_MAP_ICON, PursuitReinforcMapIcon[playerid], E_STREAMER_X, X);
			Streamer_SetFloatData(STREAMER_TYPE_MAP_ICON, PursuitReinforcMapIcon[playerid], E_STREAMER_Y, Y);
			Streamer_SetFloatData(STREAMER_TYPE_MAP_ICON, PursuitReinforcMapIcon[playerid], E_STREAMER_Z, Z);
			if(Streamer_GetIntData(STREAMER_TYPE_MAP_ICON, PursuitReinforcMapIcon[playerid], E_STREAMER_TYPE) == 30)
			{
				Streamer_SetIntData(STREAMER_TYPE_MAP_ICON, PursuitReinforcMapIcon[playerid], E_STREAMER_TYPE, 20);
			}
			else
			{
				Streamer_SetIntData(STREAMER_TYPE_MAP_ICON, PursuitReinforcMapIcon[playerid], E_STREAMER_TYPE, 30);
			}
			new cops[MAX_PLAYERS], count = 0;
			foreach(Cop, c)
			{
				if(playerid == c || (PM_Type[c] == 10 && PM_Place[c] == PM_Place[playerid]))	continue;
				cops[count++] = c;
			}
			Streamer_SetArrayData(STREAMER_TYPE_MAP_ICON, PursuitReinforcMapIcon[playerid], E_STREAMER_PLAYER_ID, cops, count);
		}
		else	DestroyDynamicMapIcon(PursuitReinforcMapIcon[playerid]), PursuitReinforcMapIcon[playerid] = INVALID_STREAMER_ID;
	}
	else if(PursuitReinforcReload[playerid] > 0)	PursuitReinforcReload[playerid]--;
}

Public: StartPursuit(playerid, targetid)
{
	if(PlayerInfo[playerid][pFaction] == F_POLICE && GetPlayerState(targetid) != PLAYER_STATE_WASTED)
	{	
		if(IsPlayerNPC(targetid))
		{
			return false;
		}
		if(!IsPoliceDuty(playerid))
		{
			SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "Для остановки игроков вы должны быть на дежурстве.");
			return false;
		}
		new sound, string[128];
		if(PM_Type[playerid] == 0)
		{
			if(IsForce(PlayerInfo[targetid][pFaction]))
			{
			    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Подозреваемый работает в органах, вы не можете остановить его.");
			    return false;
			}
			if(GetPlayerWarGangZone(targetid) >= 0 && PursuitStatus[targetid] == PS_NONE)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете запросить остановку члена банды во время захвата территории.");
				return false;
			}
			if(IsPlayerAFK(targetid))
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Подозреваемый находится в AFK, его нельзя остановить.");
				return false;
			}
			if(GetPlayerWantedLevel(targetid) == 0 && PursuitLastUNIX[targetid] > gettime())
			{
			    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Совсем недавно этого игрока уже проверяли.");
				return false;
			}
			if(PS_NONE < PursuitStatus[targetid] < PS_CRIMINAL)
			{
				SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Помощь в задержании пока не требуются, но будьте на чеку.");
				return false;
			}

			PM_Type[playerid] = 10;			// Номер миссии (10 - преследование)
			PM_Place[playerid] = targetid;	// ид подозреваемого
			PM_UNIX[playerid] = gettime();	// Время начала погони

			if(PursuitStatus[targetid] == PS_NONE)
			{
				PursuitTimer(targetid);
				if(CriminalDanger[targetid])
				{
					ShowPlayerHint(targetid, "Чтобы сдаться нажмите ~y~колесико мыши", 10000);

					sound = 15801;
					format(string, 128, "- %s %s кричит: Стоять! Или мы откроем огонь! (( %s ))", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(targetid));
				}
				else
				{// Требования
					if(22 <= GetPlayerWeapon(targetid) <= 38)
					{
						ShowPlayerHint(targetid, "Чтобы не бросать оружие, достаточно его спрятать", 10000);
					}
					if(!random(2))
					{
						sound = 10200;
						format(string, 128, "- %s %s кричит: Эй, ты! Полиция. Стоп! (( %s ))", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(targetid));
					}
					else
					{
						sound = 34402;
						format(string, 128, "- %s %s кричит: Полиция! Не двигайся! (( %s ))", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(targetid));
					}
				}
				PlayerPlaySound(playerid, sound, 0, 0, 0);
				PlayerPlaySound(targetid, sound, 0, 0, 0);
				ProxDetector(playerid, 30.0, string, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, 0xE6E6E6E6, 0xC8C8C8C8);
			}
			else
			{
				format(string, 128, "[R] %s %s: {FFFFFF}Оказываю содействие в задержении %s, прием.", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(targetid));
				SendPoliceMessage(COLOR_BLUE, string);
			}

			// Вывод задания
			if(CriminalDanger[targetid])	format(string, 128, "~n~~n~Остановите ~r~%s ~w~любой ценой!", ReturnPlayerName(targetid));
			else 							format(string, 128, "~n~~n~Задержите ~b~%s ~w~не применяя силы.", ReturnPlayerName(targetid));
			SendMissionMessage(playerid, string, 0);
		}
		else if(PM_Type[playerid] == 10 && PM_Place[playerid] == targetid)
		{
			if(PursuitStatus[targetid] == PS_WAIT || PursuitStatus[targetid] == PS_OUT_COMPLETE)
			{
				ShowPlayerHint(playerid, "Требования выполнены, задержите подозреваемого");
			}
			else if(PursuitStatus[targetid] == PS_CRIMINAL)
			{
				new nowtick = GetTickCount();
				if(PursuitTickcount[targetid] <= nowtick)
				{
					sound = 15801;
					format(string, 128, "- %s %s кричит: Стоять! Или мы откроем огонь! (( %s ))", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(targetid));
					//if(!random(2)) 	format(string, sizeof(string), "- %s %s кричит: Сейчас же остановись, %s!", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(targetid));
					//else 			format(string, sizeof(string), "- %s %s кричит: Не вынуждай меня применять силу, %s!", GetPlayerRank(playerid), ReturnPlayerName(playerid), ReturnPlayerName(targetid));
					ProxDetector(playerid, 30.0, string, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, 0xE6E6E6E6, 0xC8C8C8C8);
					PlayerPlaySound(playerid, sound, 0, 0, 0);
					PlayerPlaySound(targetid, sound, 0, 0, 0);
					PursuitTickcount[targetid] = nowtick + 15000;
				}
				else
				{
					format(string, sizeof(string), "Остановку уже запрашивали, до следующего раза: ~y~%d сек", 1 + (PursuitTickcount[targetid] - nowtick) / 1000);
					ShowPlayerHint(playerid, string);
				}
			}
		}
		else if((PM_Type[playerid] != 10 || PM_Place[playerid] != targetid) && CriminalDanger[targetid] == false)
		{
			ShowPlayerHint(playerid, "Вы уже выполняете задание! Для отмены войдите в /hq");
		}
	}
	return true;
}

Public: PursuitTimer(playerid)
{	// playerid = подозреваемый (suspectid)
	new string[128];
	new pstate = GetPlayerState(playerid);
	switch(PursuitStatus[playerid])
	{
	    case PS_NONE:// Условия требования
	    {
	        PursuitLamp[playerid] = false;
	        PursuitCrimTransit[playerid] = false;

	    	if(CriminalDanger[playerid])
	    	{
	    		PursuitStatus[playerid] = PS_CHECK;
	    		ToggleCriminalDanger(playerid, true);
	    	}
	    	else
	    	{
	    		if(GetPlayerState(playerid) == 1)
		        {	// Пешком
		            PursuitState[playerid] = 1;
		            PursuitCount[playerid] = 10;// Время на выполнение
		        }
		        else if(GetPlayerState(playerid) == 2)
		        {	// За рулем
		            new vehicleid = GetPlayerVehicleID(playerid);
					foreach(LoginPlayer, i)
					{
					    if(i != playerid && CriminalDanger[i] == true && IsPlayerInVehicle(i, vehicleid))
					    {
					        PursuitCrimTransit[playerid] = true;
					        break;
					    }
					}
					PursuitState[playerid] = 2;
		            PursuitCount[playerid] = 15;	// Время на выполнение
					PursuitLamp[playerid] = VehInfo[vehicleid][vLights];
					GameTextForPlayer(playerid, "~r~] ~b~P~r~o~b~l~r~i~b~c~r~e~b~! ~r~]~n~~w~Stop your vehicle!", 3000, 3);
		        }
		        else if(GetPlayerState(playerid) == 3)
		        {	// На пассажирском
					PursuitState[playerid] = 3;
		            PursuitCount[playerid] = 15;	// Время на выполнение
					GameTextForPlayer(playerid, "~r~] ~b~P~r~o~b~l~r~i~b~c~r~e~b~! ~r~]~n~~w~Stop your vehicle!", 3000, 3);
		        }
		        else return 1;

		        PursuitStatus[playerid] = PS_CHECK;
	    	}
	    	FlashPoliceZone(playerid, true);
	    	PursuitTickcount[playerid] = GetTickCount();
	        pursuit_timer[playerid] = SetTimerEx("PursuitTimer", 1000, true, "i", playerid);
	    }
	    case PS_CHECK:// Проверка выполнения требования
	    {
            new vehicleid = GetPlayerVehicleID(playerid);
	        if(--PursuitCount[playerid] <= 0 || (PursuitState[playerid] == 1 && vehicleid > 0))
	        {// Требование не выполнено за данное время
				ToggleCriminalDanger(playerid, true);
				CrimePlayer(playerid, CRIME_RESIST);
				if(PursuitCrimTransit[playerid])
				{
					CrimePlayer(playerid, CRIME_CARRY_CRIMINAL);
				}
			}
			else
			{
				SetPlayerVisualTimer(playerid, PursuitCount[playerid], false);
				switch(GetPlayerState(playerid))
				{
				    case PLAYER_STATE_ONFOOT:
				    {   // Пешком
			            if(GetPlayerWeapon(playerid) == 0 && CriminalDanger[playerid] == false)
			            {	// Убрал оружие
					        PursuitStatus[playerid] = PS_WAIT;
				            StopEnterVehicle(playerid);
							PursuitHandsup(playerid);
				            SendClientMessage(playerid, COLOR_BLUE, "> Оставайтесь на месте пока полицейский вас не проверит.");
				            HidePlayerVisualTimer(playerid);
			            }
				    }
				    case PLAYER_STATE_DRIVER, PLAYER_STATE_PASSENGER:
				    {   // В машине
			            if(GetVehicleSpeed(vehicleid) < 5.0)
			            {	// Остановился
					        PursuitStatus[playerid] = PS_WAIT;
							SendClientMessage(playerid, COLOR_BLUE, "> Оставайтесь на месте пока полицейский вас не проверит.");
							HidePlayerVisualTimer(playerid);
			            }
				    }
				}
	        }
	    }
	    case PS_WAIT:	// Требование выполнено, ожидание контакта
	    {
	        new vehicleid = GetPlayerVehicleID(playerid);
	        //
	        if((pstate == PLAYER_STATE_ONFOOT && PursuitState[playerid] == PLAYER_STATE_ONFOOT && GetPVarInt(playerid, "Police:Pursuit:Handsup") == 0)
			|| (pstate == PLAYER_STATE_ONFOOT && PLAYER_STATE_ONFOOT <= PursuitState[playerid] <= PLAYER_STATE_PASSENGER && GetPlayerSpeed(playerid) > 12.0)
	        || (PLAYER_STATE_DRIVER <= pstate <= PLAYER_STATE_PASSENGER && (!IsVehicleWithEngine(vehicleid) || GetVehicleEngine(vehicleid)) && GetVehicleSpeed(vehicleid) > 10.0))
	        {	// Передумал сотрудничать
				foreach(Cop, copid)
	            {
	            	if(PM_Type[copid] == 10 && PM_Place[copid] == playerid)
					{
						if(Dialogid[copid] == DMODE_POLICE_STOPMENU)
						{
							MyHidePlayerDialog(copid);
						}
					}
				}
				if(GetPlayerAsk(playerid) == ASK_POLICE_FINE)
					StopAsking(playerid);
				PursuitHandsupCancel(playerid);
				if(PursuitCrimTransit[playerid])
				{
					CrimePlayer(playerid, CRIME_CARRY_CRIMINAL);
				}
	        }
	        else if(pstate == PLAYER_STATE_ONFOOT && PursuitState[playerid] != pstate && GetPVarInt(playerid, "Police:Pursuit:Handsup") == 0)
	        {	//	сам вышел из авто
	        	PursuitHandsup(playerid);
	        }
	        else
	        {
				if(GetPlayerAsk(playerid) != ASK_POLICE_FINE)
				{
					new Float:curdist;
		  	        new wl = GetPlayerWantedLevel(playerid);
				    foreach(Cop, copid)
				    {	// Проверка наличия контакта
				        if(PM_Type[copid] != 10 || PM_Place[copid] != playerid)	continue;
				        if(GetPlayerState(copid) != PLAYER_STATE_ONFOOT)		continue;

				        curdist = GetDistanceBetweenPlayers(playerid, copid);
				        if((pstate == PLAYER_STATE_ONFOOT							&& curdist <= 2.0)
				        || (PLAYER_STATE_DRIVER <= pstate <= PLAYER_STATE_PASSENGER && curdist <= 4.0)
				        && GetPlayerSpeed(copid) == 0.0)
						{
		   	                if(PursuitState[playerid] == PLAYER_STATE_DRIVER)
		   	                {
		   	                	format(string, sizeof(string), "Взаимодействуйте с ~n~~r~%s~n~~w~(прицелиться + h)", ReturnPlayerName(playerid));
		   	                }
		   	                else
		   	                {
		   	                	if(wl > 3 || PursuitAllowArrest[playerid])
		   	                	{
		   	                		format(string, sizeof(string), "Зажмите ~y~ALT~w~ для ареста");
		   	                	}
		   	                	else if(0 <= wl <= 3)
		   	                	{
		   	                		format(string, sizeof(string), "Взаимодействуйте с ~n~~r~%s~n~~w~(прицелиться + h)", ReturnPlayerName(playerid));
		   	                	}
		   	                }
		   	                ShowPlayerHint(copid, string);
						}
					}
				}
	        }
	    }
	    case PS_WAIT_OUT_VEH:	//	Запрос на выход из авто
	    {
	    	if(pstate == PLAYER_STATE_ONFOOT)
	    	{	//	вышел из авто
	    		HidePlayerVisualTimer(playerid);
	    		PursuitStatus[playerid] = PS_OUT_COMPLETE;
	    		PursuitHandsup(playerid);
		        SendClientMessage(playerid, COLOR_BLUE, "> Оставайтесь на месте пока полицейский вас не проверит.");
	    	}
	    	else
	    	{
	    		if(--PursuitCount[playerid] <= 0)
	       		{
	       			if(GetPlayerAsk(playerid) == ASK_POLICE_FINE)
						StopAsking(playerid);
					ToggleCriminalDanger(playerid, true);
					CrimePlayer(playerid, CRIME_RESIST);
					if(PursuitCrimTransit[playerid])
					{
						CrimePlayer(playerid, CRIME_CARRY_CRIMINAL);
					}
	       		}
	       		else SetPlayerVisualTimer(playerid, PursuitCount[playerid], false);
	    	}
	    }
	    case PS_OUT_COMPLETE:	//	Требование выхода выполнено
	    {
	        if((pstate == PLAYER_STATE_ONFOOT && GetPVarInt(playerid, "Police:Pursuit:Handsup") == 0)
	        || (pstate == PLAYER_STATE_DRIVER || pstate == PLAYER_STATE_PASSENGER && GetPlayerSpeed(playerid) > 0.0))
	        {	// Передумал сотрудничать
				ToggleCriminalDanger(playerid, true);
				CrimePlayer(playerid, CRIME_RESIST);
				PursuitHandsupCancel(playerid);
				if(PursuitCrimTransit[playerid])
				{
					CrimePlayer(playerid, CRIME_CARRY_CRIMINAL);
				}
	        }
	        else
	        {
	            if(GetPlayerAsk(playerid) != ASK_POLICE_FINE)
				{
		  	        new wl = GetPlayerWantedLevel(playerid);
				    foreach(Cop, copid)
				    {	// Проверка наличия контакта
				        if(GetPlayerState(copid) != PLAYER_STATE_ONFOOT) 		continue;
				        if(PM_Type[copid] != 10 || PM_Place[copid] != playerid)	continue;
				        if((pstate == PLAYER_STATE_ONFOOT && GetDistanceBetweenPlayers(playerid, copid) <= 2.0))
						{
		                	if(wl > 3 || PursuitAllowArrest[playerid])
		                	{
		                		ShowPlayerHint(copid, "Зажмите ~y~ALT~w~ для ареста");
		                	}
		                	else if(0 <= wl <= 3)
		                	{
		                		format(string, sizeof(string), "Взаимодействуйте с ~n~~r~%s~n~~w~(прицелиться + h)", ReturnPlayerName(playerid));
								ShowPlayerHint(copid, string);
		                	}
						}
					}
				}
	        }
	    }
	    case PS_CRIMINAL:	// Оказано полное сопротивление, преследуем
	    {
	        // Система побега и укрытия
		    if(!CriminalMarked[playerid])
		    {
				if(PursuitCount[playerid] == 0)
				{	// Начинаем отсчет укрытия
				    PursuitCount[playerid] = 30;
				    SetPlayerVisualTimer(playerid, PursuitCount[playerid], false);
				    return 1;
				}
		        if(--PursuitCount[playerid] == 0)
		        {	// Просидел в укрытии и не был найден
		            HidePlayerVisualTimer(playerid);
                    StopPursuit(playerid, 0);
		        }
		        else SetPlayerVisualTimer(playerid, PursuitCount[playerid], false);
		    }
		    else
			{	// Обнуляем счетчик если нашли
			    if(PursuitCount[playerid] > 0)
			    {
			        PursuitCount[playerid] = 0;
			        HidePlayerVisualTimer(playerid);
			    }
			}
	    }
	}
	return true;
}

stock StopPursuit(playerid, result)
{
// result = 0 - не пойман (оторвался)
// result = 1 - погиб
// result = 2 - вышел с сервера
// result = 3 - ушел в АФК
// result = 4 - задержали
// result = 5 - задержали с убийством
	if(PursuitStatus[playerid] == PS_NONE) return 1;

	new string[128];
	HidePlayerVisualTimer(playerid);
	PursuitHandsupClear(playerid, 0);
    KillTimer(pursuit_timer[playerid]);
    PursuitIllegalItem[playerid] = false;
    PursuitAllowArrest[playerid] = false;
    PursuitStatus[playerid] = PS_NONE;
    PursuitCancelHandsup[playerid] = 0;
    pursuit_timer[playerid] = 0;

    DeletePVar(playerid, "Pursuit:CheckDoc");
   	DeletePVar(playerid, "Pursuit:CheckDrunk");
	DeletePVar(playerid, "Pursuit:CheckLight");

	if(result == 0)
	{
        new cops;
	    foreach(Cop, copid)
	    {	// Завершаем миссию копам
			if(PM_Type[copid] == 10 && PM_Place[copid] == playerid)
			{
			    cops++;
				PoliceMissionCancel(copid, "Подозреваемый сбежал");
			}
		}
		if(cops == 0) cops = 1;
	    GameTextForPlayer(playerid, RusText("~g~Оторвался", isRus(playerid)), 5000, 3);
	}
	else
	{
	    // Оформляем
	    new wl = GetPlayerWantedLevel(playerid);
	    if(result == 1 || result == 5)
	    {// Если уничтожен
			TextDrawShowForPlayer(playerid, Busted);
			SetPlayerInJail(playerid, false);
	    }
	    else SetPlayerInJail(playerid, true);

	    // Подсчитываем время
		new Float:proc, maxtime, nowtime = gettime();
	    foreach(Cop, copid)
	    {
			if(PM_Type[copid] == 10 && PM_Place[copid] == playerid && nowtime-PM_UNIX[copid] > maxtime) maxtime = nowtime-PM_UNIX[copid];
		}

		// Распределение зарплаты
	    foreach(Cop, copid)
	    {
			if(PM_Type[copid] == 10 && PM_Place[copid] == playerid)
			{
			    proc = float(nowtime-PM_UNIX[copid])/float(maxtime);
			    if(result == 1) 		PoliceMissionComplete(copid, floatround(wl * COST_PER_WANTED * proc), 		"Подозреваемый погиб");	// Погиб
			    else if(result == 2) 	PoliceMissionComplete(copid, floatround(wl * COST_PER_WANTED * proc), 		"Подозреваемый вышел");	// Вышел
			    else if(result == 3) 	PoliceMissionComplete(copid, floatround(wl * COST_PER_WANTED * proc), 		"Подозреваемый АФК");	// АФК
			    else if(result == 4) 	PoliceMissionComplete(copid, floatround(wl * COST_PER_WANTED * proc), 		"Подозреваемый пойман");// Пойман
			    else if(result == 5)	PoliceMissionComplete(copid, floatround(wl * COST_PER_WANTED * proc * 0.7), "Подозреваемый убит");	// Убит при задержании
	        	format(string, 128, "Преступник %s пойман и отправлен за решетку! Участие в погоне: %d%s", ReturnPlayerName(playerid), floatround(100 * proc), "%%");
	        	SendClientMessage(copid, COLOR_DBLUE, string);
			}
		}
	}
	return 1;
}

stock ToggleCriminalDanger(playerid, bool:toggle)
{
	if(toggle == true && PursuitStatus[playerid] > PS_NONE)
	{
	    new string[128];
		format(string, 128, "~n~~n~Остановите ~r~%s ~w~любой ценой!", ReturnPlayerName(playerid));
        foreach(Cop, copid)
        {
			if(PM_Type[copid] == 10 && PM_Place[copid] == playerid)
				SendMissionMessage(copid, string, 0);
		}
		if(CriminalDanger[playerid] == false)
		{	// В первый раз
	        format(string, 128, "[R] Диспетчер HQ: {FFFFFF}Разрешено открыть огонь по %s, прием.", ReturnPlayerName(playerid));
	        foreach(Cop, copid)
	        {
				if(PM_Type[copid] == 10 && PM_Place[copid] == playerid)
					SendClientMessage(copid, COLOR_BLUE, string);
			}
		}
		HidePlayerVisualTimer(playerid);
        PursuitCount[playerid] = 0;
		PursuitStatus[playerid] = PS_CRIMINAL;
	}
	//--
    DestroyDynamic3DTextLabel(criminal_3d[playerid]), criminal_3d[playerid] = Text3D:INVALID_STREAMER_ID;
    if(toggle == true)
    {
		criminal_3d[playerid] = CreateDynamic3DTextLabel("Преступник", 0xAA3333FF, 0.0, 0.0, 0.30, 20.0, playerid, INVALID_VEHICLE_ID, 1);
	}
	CriminalDanger[playerid] = toggle;
	IFace.UpdatePlayerWanted(playerid);
}

//////////	Commands	////////////
COMMAND:frisk(playerid, params[])
{
	extract params -> new player:giveplayerid; else
		return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /frisk [playerid/playername]");

	if(playerid == giveplayerid)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете обыскать самого себя.");
	}
	if(GetDistanceBetweenPlayers(playerid, giveplayerid) > 5.0)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Игрок слишком далеко от вас.");
	}
	if(IsGover(PlayerInfo[giveplayerid][pFaction]))
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете обыскать гос.служащего.");
	}
	if(PlayerInfo[giveplayerid][pNextFriskTime] > gettime())
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого игрока недавно обыскивали.");
	}
	if(PursuitStatus[giveplayerid] == PS_NONE)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Для обыска вы должны запросить остановку игрока.");
	}
	if(PursuitStatus[giveplayerid] == PS_WAIT || PursuitStatus[giveplayerid] == PS_OUT_COMPLETE)
	{
		new string[128];
		PlayerInfo[giveplayerid][pNextFriskTime] = gettime() + (60 * 5);
		format(string, sizeof(string), "обыскивает %s'а.", ReturnPlayerName(giveplayerid));
		PlayerAction(playerid, string);

		mysql_format(g_SQL, string, sizeof(string), "SELECT `thing`, `count` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d'", PlayerInfo[giveplayerid][pUserID], _:TAB_INVENTORY);
    	new Cache:result = mysql_query(g_SQL, string);
    	new thing, cnt, count, wcount;
    	for(new i = 0; i < cache_num_rows(); i++)
		{
			cache_get_value_name_int(i, "thing", thing);
			if(GetThingLegally(thing) == 0)
			{
				cache_get_value_name_int(i, "count", cnt);
				if(count)	format(string, sizeof(string), "%s, %s (%d шт.)", string, GetThingName(thing), cnt);
				else 		format(string, sizeof(string), "%s (%d шт.)", GetThingName(thing), cnt);
				count++;
			}
    	}
    	cache_delete(result);
    	//	Оружие
    	if(PlayerInfo[giveplayerid][pGunLic] == 0)
		{
	    	for(new s = 2; s < 13; s++)
	    	{
			    if(!MyGetPlayerWeaponID(giveplayerid, s) || 9 <= s <= 11) continue;
	    		if(count || wcount)	format(string, sizeof(string), "%s, %s", string, ReturnWeaponName(MyGetPlayerWeaponID(giveplayerid, s)));
				else 				format(string, sizeof(string), "%s", ReturnWeaponName(MyGetPlayerWeaponID(giveplayerid, s)));
				wcount++;
	    	}
    	}
    	if(count || wcount)
    	{
    		SendFormatMessage(playerid, COLOR_DBLUE, string, "Запрещенные вещи %s'а: {FFFFFF}%s", ReturnPlayerName(giveplayerid), string);
    		if(count)
    		{
	    		CrimePlayer(giveplayerid, CRIME_THINGS);
	    	}
	    	if(wcount)
	    	{
	    		CrimePlayer(giveplayerid, CRIME_HAVE_GUN);
	    	}
	    	if(PM_Type[playerid] == 10 && PM_Place[playerid] == giveplayerid)
			{
				PursuitIllegalItem[giveplayerid] = true;
				ShowDialog(playerid, DMODE_REACTION);
			}
    	}
    	else
    	{
    		if(PM_Type[playerid] == 10 && PM_Place[playerid] == giveplayerid)
    		{
    			if(GetPlayerWantedLevel(giveplayerid) == 0)
    			{
    				CancelPlayerPursuit(giveplayerid, 1);
    			}
    		}
    		SendFormatMessage(giveplayerid, COLOR_DBLUE, string, "%s %s обыскал вас и ничего не нашел", GetPlayerRank(playerid), ReturnPlayerName(playerid));
			SendFormatMessage(playerid, COLOR_DBLUE, string, "Вы обыскали %s: ничего запрещенного не найдено", ReturnPlayerName(giveplayerid));
    	}
	}
	else
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "В данный момент обыск невозможен.");
	}
	return true;
}