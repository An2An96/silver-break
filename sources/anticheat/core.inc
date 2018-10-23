#if defined _ac_core_included
  #endinput
#endif

#define _ac_core_included

#include "anticheat/header"

#include "admin/header"
#include "player/header"
#include "interface/header"
#include "vehicle/header"
#include "player/chat/header"

#include "anticheat/money"
#include "anticheat/weapon"
#include "anticheat/health"
#include "anticheat/airbreak"

// #include "anticheat/nex-ac_ru.lang"
// #include "anticheat/nex-ac"

stock Anticheat.Toggle(bool:toggle)
{
	ANTICHEAT = toggle;
}

stock bool:Anticheat.GetToggle()
{
	return ANTICHEAT;
}

stock MySetVehicleHealth(vehicleid, Float:health)
{
	// 1000.0 not allowed (anticheat)
	if(health >= 999.0)
		health = 999.0;
	return SetVehicleHealth(vehicleid, health);
}

stock MyRepairVehicle(vehicleid)
{
    RepairVehicle(vehicleid);
    MySetVehicleHealth(vehicleid, 999.0);
}

//----
stock TogglePlayerControllableEx(playerid, toggle)
{
	p_Protect[playerid][prControllable] = toggle ? true : false;
	new vehicleid = GetPlayerVehicleID(playerid);
	if(vehicleid)
		BlockVehicleEffect(vehicleid);
	return TogglePlayerControllable(playerid, toggle);
}
#if defined _ALS_TogglePlayerControllable
	#undef TogglePlayerControllable
#else
	#define _ALS_TogglePlayerControllable
#endif
#define TogglePlayerControllable 	TogglePlayerControllableEx

IsPlayerControllable(playerid)
{
	return p_Protect[playerid][prControllable];
}	

//	special action
stock MySetPlayerSpecialAction(playerid, actionid)
{
	//if(actionid == SPECIAL_ACTION_USEJETPACK)
	p_Protect[playerid][prSpecialAction] = SPECIAL_ACTION_USEJETPACK;
	SetPlayerSpecialAction(playerid, actionid);
	return true;
}

bool:IsPlayerAimingAtPlayer(playerid, target)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(target, x, y, z);
    if (IsPlayerAimingAt(playerid, x, y, z-0.75, 0.25)) return true;
    if (IsPlayerAimingAt(playerid, x, y, z-0.25, 0.25)) return true;
    if (IsPlayerAimingAt(playerid, x, y, z+0.25, 0.25)) return true;
    if (IsPlayerAimingAt(playerid, x, y, z+0.75, 0.25)) return true;
    return false;
}

bool:IsPlayerAFK(playerid)
{
	return p_Protect[playerid][prPause];
} 					

GetPlayerAFKTime(playerid)
{
	return floatround((GetTickCount() - p_Protect[playerid][prLastUpdate]) / 1000);
}

// public OnCheatDetected(playerid, ip_address[], type, code)
// {
// 	new string[256];
// 	format(string, sizeof(string), "читерит, тип: %d, код: %d", type, code);
// 	AC_PlayerMessage(playerid, string);

// 	switch (code)
// 	{
// 		case 12:
// 		{
// 			format(string, sizeof(string),
// 				"попытался начитерить здоровье",
// 					p_Protect[playerid][prHealth], pHealth,
// 					floatabs(p_Protect[playerid][prHealth] - pHealth));
// 			AC_PlayerMessage(playerid, string);
// 			MySetPlayerHealth(playerid, p_Protect[playerid][prHealth]);
// 			GiveAnticheatWarn(playerid, HEALTH);
// 		}
// 	}
// 	return (1);
// }

public	OnPlayerCheckAnticheat(playerid)
{
	new const i = playerid;

	new const ac_gtc = GetTickCount();

	new string[128],
		pState = GetPlayerState(i), 
		vehicleid = GetPlayerVehicleID(i),
		second, ping;
	gettime(_, _, second);
	//if(GetPlayerAdmin(i) > ADMIN_HELPER)							continue;
	
	ping = GetPlayerPing(i);
	if(1000 < ping < INVALID_DATA)
	{
		format(string, sizeof(string), "кикнут с пингом %d [подозрение на бота]", ping);
		AC_PlayerMessage(i, string);
		Kick(i);
		return true;
	}
	
	//if(!IsPlayerLogged(i) || GetPVarInt(i, "AC:Spawn:BlockCheck"))	return true;

	//ac_delay = AC_GetPlayerDelay(i);
    //if(ac_gtc > p_Protect[i][prLastUpdate] + ac_delay)				return true;

	if(PLAYER_STATE_ONFOOT <= pState <= PLAYER_STATE_PASSENGER)
	{
		if(pState == PLAYER_STATE_DRIVER)
		{
		    // Проверка на ремонт машины
            new Float:vHealth;
            GetVehicleHealth(vehicleid, vHealth);
            if(vHealth == 1000.0)
            {
                if(IsPlayerInPaynSpray(i))
                {
					CallLocalFunction("OnEnterPaynspray", "ii", i, vehicleid);
                }
                else
                {
                	format(string, sizeof(string), "подозревается в нелегальной починке авто (#%d)", vehicleid);
					AC_PlayerMessage(i, string);
                	GiveAnticheatWarn(i, CAR_REPAIR);
                	StopEnterVehicle(i, true);
                }
                MySetVehicleHealth(vehicleid, 999.0);
            }

            if(IsVehicleWithEngine(vehicleid) && !GetVehicleEngine(vehicleid))
            {
				if(GetVehicleSpeed(vehicleid) > 15.0)
				{
				    if(ac_gtc < GetPVarInt(i, "AC:VEngine:Trigger:GTC") + 3000)
					{
						AC_PlayerMessage(i, "подозревается в вождении заглушенного авто");
						GiveAnticheatWarn(i, OUTOFENGINE);
					    SetPVarInt(i, "AC:VEngine:Trigger:GTC", 0);
						SetVehicleSpeed(vehicleid, 0.0);
					}
					else SetPVarInt(i, "AC:VEngine:Trigger:GTC", GetTickCount());
				}
			}
		}

		// ---	Vehicle TP
		/*if(vehicleid > 0 && vehicleid != PlayerVehicle[i])
		{
		    format(string, sizeof(string), "[AdmWrn]: %s[%d] подозревается в Vehicle Teleporting [%d -> %d]", ReturnPlayerName(i), i, PlayerVehicle[i], vehicleid);
		    SendAdminMessage(COLOR_LIGHTRED, string);
		    PlayerVehicle[i] = vehicleid;
			UpdateVehInfo();
		}*/

		//	---	Special Action
		if(p_Protect[i][prSpecialAction] != SPECIAL_ACTION_USEJETPACK && GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK)
		{
			AC_PlayerMessage(i, "попытался начитерить JetPack");
			MySetPlayerSpecialAction(i, SPECIAL_ACTION_NONE);
		}
	}
	return 1;
}

//	Timer
Public: AnticheatTimer()
{
	if (!ANTICHEAT)
		return (1);

	//new const ac_gtc = GetTickCount();

	//new string[128];
	//	Float:pArmour, Float:pHealth,
	//	Float:X, Float:Y, Float:Z, Float:A,
	//	pState, vehicleid, vsurfinf, second, ping, ac_delay;
	//gettime(_, _, second);
	foreach(Player, i)
	{
		//	--- AFK
		if(!IsPlayerAFK(i) && GetPlayerAFKTime(i) >= AFK_TIME)
		{
	    	p_Protect[i][prPause] = true;
			OnPlayerPauseStateChange(i, true);
		}

		//if(GetPlayerAdmin(i) > ADMIN_HELPER)							continue;
		
		/*ping = GetPlayerPing(i);
		if(1000 < ping < INVALID_DATA)
		{
			format(string, sizeof(string), "кикнут с пингом %d [подозрение на бота]", ping);
			AC_PlayerMessage(i, string);
			Kick(i);
			continue;
		}
		
		if(!IsPlayerLogged(i) || GetPVarInt(i, "AC:Spawn:BlockCheck"))	continue;

		ac_delay = AC_GetPlayerDelay(i);
	    if(ac_gtc > p_Protect[i][prLastUpdate] + ac_delay)				continue;

		pState = GetPlayerState(i);
		if(PLAYER_STATE_ONFOOT <= pState <= PLAYER_STATE_PASSENGER)
		{
			if(pState == PLAYER_STATE_DRIVER)
			{
			    // Проверка на ремонт машины
                new Float:vHealth;
                GetVehicleHealth(vehicleid, vHealth);
                if(vHealth == 1000.0)
                {
                    if(IsPlayerInPaynSpray(i))
                    {
						CallLocalFunction("OnEnterPaynspray", "ii", i, vehicleid);
                    }
                    else
                    {
	                	format(string, sizeof(string), "подозревается в нелегальной починке авто (#%d)", vehicleid);
						AC_PlayerMessage(i, string);
	                	GiveAnticheatWarn(i, CAR_REPAIR);
	                	StopEnterVehicle(i, true);
                    }
                    MySetVehicleHealth(vehicleid, 999.0);
                }

	            if(VehInfo[vehicleid][vWithEngine] && !GetVehicleEngine(vehicleid))
	            {
					if(GetVehicleSpeed(vehicleid) > 15.0)
					{
					    if(ac_gtc < GetPVarInt(i, "AC:VEngine:Trigger:GTC") + 3000)
						{
							AC_PlayerMessage(i, "подозревается в вождении заглушенного авто");
							GiveAnticheatWarn(i, OUTOFENGINE);
						    SetPVarInt(i, "AC:VEngine:Trigger:GTC", 0);
							SetVehicleSpeed(vehicleid, 0.0);
						}
						else SetPVarInt(i, "AC:VEngine:Trigger:GTC", GetTickCount());
					}
				}
			}
			
			// ---	Vehicle TP
			if(vehicleid > 0 && vehicleid != PlayerVehicle[i])
			{
			    format(string, sizeof(string), "[AdmWrn]: %s[%d] подозревается в Vehicle Teleporting [%d -> %d]", ReturnPlayerName(i), i, PlayerVehicle[i], vehicleid);
			    SendAdminMessage(COLOR_LIGHTRED, string);
			    PlayerVehicle[i] = vehicleid;
				UpdateVehInfo();
			}*/

		/*	
			//	---	Special Action
			if(p_Protect[i][prSpecialAction] != SPECIAL_ACTION_USEJETPACK && GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK)
			{
				AC_PlayerMessage(i, "попытался начитерить JetPack");
				MySetPlayerSpecialAction(i, SPECIAL_ACTION_NONE);
			}
		}
		p_Protect[i][prLastCheck] = GetTickCount();*/
		//	Обнуление варнов
		for (new E_CHEATS:e; e < E_CHEATS; e++)
		{
			if (p_Warnings[i][e][CW_COUNT] > 0)
			{
				if (p_Warnings[i][e][CW_TIME] + WARN_RESET_TIME < gettime())
					p_Warnings[i][e][CW_COUNT]--;
			}
		}
	}
	return 1;
}

stock AC_PlayerMessage(playerid, const mes[])
{
	new string[256];
	format(string, sizeof(string), PREFIX_PROTECT "%s[%d] %s [Пинг: %d | Потеря: %.2f]",
		ReturnPlayerName(playerid), playerid, mes, GetPlayerPing(playerid), NetStats_PacketLossPercent(playerid));
	SendAdminMessage(COLOR_WHITE, string);
	AddCheater(playerid);
	return true;
}

stock GiveAnticheatWarn(playerid, E_CHEATS:cheat)
{
	p_Warnings[playerid][cheat][CW_TIME] = gettime();
	if(++p_Warnings[playerid][cheat][CW_COUNT] >= MAX_WARNS)
	{
		if(PlayerInfo[playerid][pAdmin] < ADMIN_IVENTER)
		{
			new string[164], date[3], time[3];
			getdate(date[2],date[1],date[0]), gettime(Arr3<time>);
			SendFormatMessageToAll(COLOR_LIGHTRED, string, "[Безопасность]: {FFFFFF}%s[%d]{FF6347} был кикнут системой: {FFFFFF}%s{FF6347} [%02d/%02d/%04d %02d:%02d:%02d]", ReturnPlayerName(playerid), playerid, Cheats[cheat], Arr3<date>, Arr3<time>);
			Admin_Log(string);
			KickEx(playerid);
		}
		p_Warnings[playerid][cheat][CW_COUNT] = 0;
	}
}

stock AddCheater(playerid)
{
	gCheaterID[ gCheaterCount ] = playerid;
	if(++gCheaterCount == 10)	gCheaterCount = 0;

	new string[128], str[8];
	for(new i = 0; i < 10; i++)
	{
		format(str, sizeof(str), "%d", gCheaterID[i]);
		for(new j = 0; j < (8 - strlen(str)); j++)	strcat(str, "_");
		strcat(string, str);
	}
	Interface_AdmPanel_Update(string);
    return 1;
}

stock AC_ClearVars(playerid)
{
	//	--	anticheat
	for(new E_PROTECTION:e; e < E_PROTECTION; e++)
		p_Protect[playerid][e] = 0;
	for(new E_CHEATS:e; e < E_CHEATS; e++)
	{
		p_Warnings[playerid][e][CW_COUNT] = 0;
		p_Warnings[playerid][e][CW_TIME] = 0;
	}
}

public OnPlayerSpawn(playerid)
{
	if(!IsPlayerNPC(playerid))
	{
		SetPVarInt(playerid, "AC:Spawn:BlockCheck", true);

		p_Protect[playerid][prSpecialAction] = SPECIAL_ACTION_NONE;

		new Float:pos[4], int, vw;
		GetSpawnPos(playerid, Arr4<pos>, int, vw);
		OldPlayerPos[playerid][0] = pos[0];
		OldPlayerPos[playerid][1] = pos[1];
		OldPlayerPos[playerid][2] = pos[2];
	}

	#if defined AC_OnPlayerSpawn
		return AC_OnPlayerSpawn(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn	AC_OnPlayerSpawn
#if defined AC_OnPlayerSpawn
	forward AC_OnPlayerSpawn(playerid);
#endif

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(GetWeaponSlot(weaponid) != 255 && !IsPlayerNPC(playerid))
	{
		if(ANTICHEAT)
		{
			new string[128];
			new ac_gtc = GetTickCount();
			new ping = GetPlayerPing(playerid) + 150;
			new pState = GetPlayerState(playerid);

			if(hittype != BULLET_HIT_TYPE_NONE) //  Anti crasher
			{
				if((fX <= -1000.0 || fX >= 1000.0)
					|| (fY <= -1000.0 || fY >= 1000.0)
					|| (fZ <= -1000.0 || fZ >= 1000.0)
					|| ((hittype != BULLET_HIT_TYPE_PLAYER)
						&& (hittype != BULLET_HIT_TYPE_VEHICLE)
						&& (hittype != BULLET_HIT_TYPE_OBJECT)
						&& (hittype != BULLET_HIT_TYPE_PLAYER_OBJECT)))
				{
					AC_PlayerMessage(playerid, "подозревается в Aim Crash");
					return false;
		        }
		        if(hittype == BULLET_HIT_TYPE_PLAYER && hitid != INVALID_PLAYER_ID)
				{
					if(IsPlayerNPC(hitid) == 0)
					{
						//	---	Anti Aim-bot
						if((weaponid >= 0 && weaponid <= 18 || weaponid >= 39 && weaponid <= 54) == false)
						{
							new Float:Shot[3], Float:Hit[3];
				            GetPlayerLastShotVectors(playerid, Shot[0], Shot[1], Shot[2], Hit[0], Hit[1], Hit[2]);

				            new playersurf = GetPlayerSurfingVehicleID(playerid);
				            new hitsurf = GetPlayerSurfingVehicleID(hitid);
				            new Float:targetpackets = NetStats_PacketLossPercent(hitid);
				            //new Float:playerpackets = NetStats_PacketLossPercent(playerid);
				            if(~(playersurf) && ~(hitsurf) && !IsPlayerInAnyVehicle(playerid) && !IsPlayerInAnyVehicle(hitid))
				            {
				                if(!IsPlayerAimingAtPlayer(playerid, hitid) && !IsPlayerInRangeOfPoint(hitid, 5.0, Hit[0], Hit[1], Hit[2]))
				                {
				                    SetPVarInt(playerid, "Protect_AimbotWarns", GetPVarInt(playerid, "Protect_AimbotWarns") + 1);
				                    format(string, sizeof(string), "подозревается в AimBot [Пакеты атакуемого: %.2f]", targetpackets);
				                    AC_PlayerMessage(playerid, string);

				                    if(GetPVarInt(playerid, "Protect_AimbotWarns") > 10)
				                    {
				                        /*if(targetpackets < 1.2 && playerpackets < 1.2)
				                        {
				                        	//	ИЗМЕНИТЬ
				                        	return Kick(playerid);
				                        }*/
				                        format(string, sizeof(string), "подозревается в AimBot [Пакеты атакуемого: %.2f]", targetpackets);
				                        AC_PlayerMessage(playerid, string);
				                    }
				                    return false;
				                }
				            }
			            }
			        }
				}
		    }

		    if(pState == PLAYER_STATE_DRIVER)
			{
				AC_PlayerMessage(playerid, "подозревается в стрельбе с водительского места");
		        return false;
			}
			else if(pState == PLAYER_STATE_PASSENGER)
			{
				if(!(3 <= GunParams[weaponid][GUN_SLOT] <= 5))
				{
					format(string, sizeof(string), "подозревается в стрельбе из %s с пассажирского места", GunParams[weaponid][GUN_NAME]);
					AC_PlayerMessage(playerid, string);
		       		return false;
				}
			}
		    //	---	Weapons
			if(ac_gtc > GetPVarInt(playerid, "AC:Weapon:GTC") + ping)
			{
			 	new slot = GetWeaponSlot(weaponid), weapon[2];
			    GetPlayerWeaponData(playerid, slot, weapon[0], weapon[1]);
			    if(slot == 255 || weapon[0] != MyGetPlayerWeaponID(playerid, slot))
			    {
			        MyUpdatePlayerWeapon(playerid);
					format(string, sizeof(string), "пытается начитерить оружие (id %d)", weaponid);
					AC_PlayerMessage(playerid, string);
					GiveAnticheatWarn(playerid, WEAPON);
					return false;
			    }
			    else if(weapon[1] < MyGetPlayerWeaponAmmo(playerid, slot))
			    {
			    	p_Protect[playerid][prWeaponAmmo][slot] = weapon[1];
			    }
			}
		}
	}

	#if defined AC_OnPlayerSpawn
		return AC_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, fX, fY, fZ);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerWeaponShot
	#undef OnPlayerWeaponShot
#else
	#define _ALS_OnPlayerWeaponShot
#endif

#define OnPlayerWeaponShot AC_OnPlayerWeaponShot
#if defined AC_OnPlayerWeaponShot
	forward AC_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
#endif

public OnPlayerUpdate(playerid)
{
	if(IsPlayerNPC(playerid))	return true;

	new const ac_gtc = GetTickCount();
	if(IsPlayerAFK(playerid))
	{
	    p_Protect[playerid][prPause] = false;
	   	SetPVarInt(playerid, "AC:LastAFK:GTC", ac_gtc);
		OnPlayerPauseStateChange(playerid, p_Protect[playerid][prPause]);
	}
	if(ANTICHEAT)
	{
		new ac_delay	= AC_GetPlayerDelay(playerid);
		new pstate		= GetPlayerState(playerid);
		if(ac_gtc > GetPVarInt(playerid, "AC:Health:GTC") + ac_delay)
		{
			if(PLAYER_STATE_ONFOOT <= pstate <= PLAYER_STATE_PASSENGER)
			{
				new Float:ftmp;
				GetPlayerHealth(playerid, ftmp);
				if(ftmp < p_Protect[playerid][prHealth])	p_Protect[playerid][prHealth] = ftmp;
		        GetPlayerArmour(playerid, ftmp);
				if(ftmp < p_Protect[playerid][prArmour])	{
					new Float:oldArmour = p_Protect[playerid][prArmour];
					p_Protect[playerid][prArmour] = ftmp;
					CallLocalFunction("OnPlayerChangeArmour", "dff", playerid, oldArmour, ftmp);
				}	
			}
		}

		if(pstate == PLAYER_STATE_DRIVER)
		{
			new vehicleid	= GetPlayerVehicleID(playerid);
			new modelid		= GetVehicleModel(vehicleid);
	        new Speed		= GetVehicleSpeed(vehicleid);
	        new Float:X, Float:Y, Float:Z, Float:A;
	        MyGetVehiclePos(vehicleid, X, Y, Z, A);
			//	Анти спидхак
	        if(VehInfo[vehicleid][vModelType] != MTYPE_BIKE && modelid != 432)
			{	// Not bike and not rhino (tank)
				if(Speed > 240 || (p_Protect[playerid][prOldSpeed] > 20 && Speed - p_Protect[playerid][prOldSpeed] > 10))
				{
					if(OldPlayerPos[playerid][2] - Z < 3.0)
					{
				    	new string[64];
						format(string, sizeof(string), "использует спидхак (model %d)", modelid);
						AC_PlayerMessage(playerid, string);
						GiveAnticheatWarn(playerid, SPEED_HACK);
						if(GetPlayerAdmin(playerid) < ADMIN_ADMIN)	SetVehicleSpeed(vehicleid, 0.0);
					}
				}
				p_Protect[playerid][prOldSpeed] = Speed;
			}
		}

		#if defined OnPlayerCheckAnticheat
			if (IsPlayerLogged(playerid)
				&& !GetPVarInt(playerid, "AC:Spawn:BlockCheck")
				&& ac_gtc <= p_Protect[playerid][prLastUpdate] + ac_delay)
			{
				OnPlayerCheckAnticheat(playerid);
				p_Protect[playerid][prLastCheck] = GetTickCount();
			}
			
		#endif
	}

	p_Protect[playerid][prLastUpdate] = ac_gtc;

	#if defined AC_OnPlayerUpdate
		return AC_OnPlayerUpdate(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerUpdate
	#undef OnPlayerUpdate
#else
	#define _ALS_OnPlayerUpdate
#endif

#define OnPlayerUpdate AC_OnPlayerUpdate
#if defined AC_OnPlayerUpdate
	forward AC_OnPlayerUpdate();
#endif

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	p_Protect[playerid][prLastChangeState] = GetTickCount();

	#if defined AC_OnPlayerStateChange
		return AC_OnPlayerStateChange(playerid, newstate, oldstate);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerStateChange
	#undef OnPlayerStateChange
#else
	#define _ALS_OnPlayerStateChange
#endif

#define OnPlayerStateChange AC_OnPlayerStateChange
#if defined AC_OnPlayerStateChange
	forward AC_OnPlayerStateChange(playerid, newstate, oldstate);
#endif
