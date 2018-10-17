#if defined _ac_core_included
  #endinput
#endif

#define _ac_core_included

#include "interface/header"
#include "vehicle/header"

#define Anticheat.				Anticheat_

#define MAX_WARNS 				3 									//	Максимум сробатывания одного античита до кика игрока
#define WARN_RESET_TIME			300									//	Интвервал обнуления варнов античита
#define AC_GetPlayerDelay(%0)	500 + (GetPlayerPing(%0) * 15)

forward OnPlayerChangeArmour(playerid, Float:oldArmour, Float:armour);

static bool:ANTICHEAT;

enum 	E_CHEATS
{
	MONEY,
	WEAPON,
	HEALTH,
	ARMOUR,
	FLY_HACK,
	VEHICLE_TELEPORT,
	AIR_BREAK,
	TELEPORT_HACK,
	FAKE_KILL,
	CAR_REPAIR,
	SPEED_HACK,
	OUTOFENGINE,        // Вождение с заглохшим двигателем
}

enum E_WARN_DATA
{
	CW_COUNT,
	CW_TIME,
}

static const Cheats[E_CHEATS][] = {
	"Чит на деньги",
	"Чит на оружие",
	"Чит на здоровье",
	"Чит на броню",
	"FlyHack",
	"Телепортация авто",
	"AirBreak",
	"Телепортация",
	"Ложное убийство",
	"Ремонт авто",
	"Спидхак",
	"Вождение с заглушенным двиг"
};

enum    E_PROTECTION
{
	//	--- health/armour
	Float:prHealth,	//	Хранит кол-во хп которые должны быть у игрока
	Float:prArmour,	//	Хранит кол-во брони которые должны быть у игрока

	//	--- weapon
	prWeaponID[13],
	prWeaponAmmo[13],

	//	---	special action
	prSpecialAction, // Для проверки джетпака

	prNoTPCheck,	//	Кол-во секунд пока позиция игрока не проверяется
	prLastCheck,

	prLastUpdate,	//	Время последнего обновления игрока (для отслеживания ухода в АФК)

	//	---	speed
	prOldSpeed,				//	

	//	--- other info
	bool:prPause, 			//	Находится ли игрок в АФК
	bool:prControllable,
	prLastChangeState,
}
static p_Protect[MAX_PLAYERS][E_PROTECTION];
static p_Warnings[MAX_PLAYERS][E_CHEATS][E_WARN_DATA];
static gCheaterID[10] = { -1, ... };
static gCheaterCount;

new bool:PlayerBusy[MAX_PLAYERS char];
new Float:OldPlayerPos[MAX_PLAYERS][4];

stock Anticheat.Toggle(bool:toggle)
{
	ANTICHEAT = toggle;
}

stock bool:Anticheat.GetToggle()
{
	return ANTICHEAT;
}

//	Money anticheat func.
stock MySetPlayerMoney(playerid, money)
{
    SetPVarInt(playerid, "AC:Money:GTC", GetTickCount());
	ResetPlayerMoney(playerid);
	PlayerInfo[playerid][pMoney] = money;
	return GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
}

stock MyGivePlayerMoney(playerid, money, bool:visible = true)
{
	if(visible && money != 0)
	{
		IFace.ChangeMoney_Update(playerid, money);
	    PlayerPlaySound(playerid, 4201, 0.0, 0.0, 0.0);
    }
    SetPVarInt(playerid, "AC:Money:GTC", GetTickCount());
	PlayerInfo[playerid][pMoney] += money;
	return GivePlayerMoney(playerid, money);
}

stock MyResetPlayerMoney(playerid)
{
	SetPVarInt(playerid, "AC:Money:GTC", GetTickCount());
    PlayerInfo[playerid][pMoney] = 0;
	return ResetPlayerMoney(playerid);
}

//	Health anticheat func.
stock MySetPlayerHealth(playerid, Float:health)
{
	SetPVarInt(playerid, "AC:Health:GTC", GetTickCount());
	if(health < 0)	health = 0;
	PlayerInfo[playerid][pSaveHealth] = health;
	p_Protect[playerid][prHealth] = health;
	return SetPlayerHealth(playerid, health);
}

stock Float:MyGetPlayerHealth(playerid)
{
	return p_Protect[playerid][prHealth];
}		

stock MySetVehicleHealth(vehicleid, Float:health)
{
	// 1000.0 not allowed (anticheat)
	if(health >= 999.0) health = 999.0;
	return SetVehicleHealth(vehicleid, health);
}

stock MyRepairVehicle(vehicleid)
{
    RepairVehicle(vehicleid);
    MySetVehicleHealth(vehicleid, 999.0);
}

//	Armour anticheat func.
stock MySetPlayerArmour(playerid, Float:armour)
{
	SetPVarInt(playerid, "AC:Health:GTC", GetTickCount());
	if(armour < 0)	armour = 0;
	new Float:oldArmour = p_Protect[playerid][prArmour];
	p_Protect[playerid][prArmour] = armour;
	CallLocalFunction("OnPlayerChangeArmour", "dff", playerid, oldArmour, armour);
	return SetPlayerArmour(playerid, armour);
}

stock Float:MyGetPlayerArmour(playerid)
{
	return p_Protect[playerid][prArmour];
}

//----
stock MyPutPlayerInVehicle(playerid, vehicleid, seatid)
{
	if(GetVehicleModel(vehicleid) == 0)
	{
		return false;
	}
	gEnteringVehicle[playerid] = -1;
	PlayerVehicle[playerid] = vehicleid;
	GetVehiclePos(vehicleid, Arr3<OldPlayerPos[playerid]>);
	SetPVarInt(playerid, "AC:ChangePos:GTC", GetTickCount());
	PutPlayerInVehicle(playerid, vehicleid, seatid);

	UpdatePlayerWeather(playerid);
	UpdatePlayerTime(playerid);
	UpdatePlayerGPSZone(playerid);
	return true;
}

stock MySetPlayerPos(playerid, Float:x, Float:y, Float:z, Float:a = 0.0, inter = -1, vw = -1)
{
	if(SetPlayerPos(playerid, x, y, z))
	{
		SetPVarInt(playerid, "AC:ChangePos:GTC", GetTickCount());
		OldPlayerPos[playerid][0] = x;	OldPlayerPos[playerid][1] = y;	OldPlayerPos[playerid][2] = z;

		SetPlayerFacingAngle(playerid, a);
		if(inter != -1) SetPlayerInterior(playerid, inter);
		if(vw != -1)	SetPlayerVirtualWorld(playerid, vw);

		UpdatePlayerWeather(playerid);
		UpdatePlayerTime(playerid);
		UpdatePlayerGPSZone(playerid);
		BenchpressClear(playerid);
		return true;
	}
	else
		return false;
}

stock MyGetPlayerPos(playerid, &Float:x = 0.0, &Float:y = 0.0, &Float:z = 0.0, &Float:a = 0.0)
{
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	return true;
}

MySetVehiclePos(vehicleid, Float:x, Float:y, Float:z, Float:a = 0.0)
{
	new i;
	BlockVehicleEffect(vehicleid);
	if(VehInfo[vehicleid][vDriver] >= 0)
	{
		EffectCheck{ VehInfo[vehicleid][vDriver] } = 2;

		i = VehInfo[vehicleid][vDriver];
		OldPlayerPos[i][0] = x;	OldPlayerPos[i][1] = y;	OldPlayerPos[i][2] = z;
		SetPVarInt(i, "AC:ChangePos:GTC", GetTickCount());
	}
	if(VehInfo[vehicleid][vCoDriver] >= 0)
	{
		EffectCheck{ VehInfo[vehicleid][vCoDriver] } = 2;

		i = VehInfo[vehicleid][vCoDriver];
		OldPlayerPos[i][0] = x;	OldPlayerPos[i][1] = y;	OldPlayerPos[i][2] = z;
		SetPVarInt(i, "AC:ChangePos:GTC", GetTickCount());
	}
	if(VehInfo[vehicleid][vLeftSeat] >= 0)
	{
		EffectCheck{ VehInfo[vehicleid][vLeftSeat] } = 2;

		i = VehInfo[vehicleid][vLeftSeat];
		OldPlayerPos[i][0] = x;	OldPlayerPos[i][1] = y;	OldPlayerPos[i][2] = z;
		SetPVarInt(i, "AC:ChangePos:GTC", GetTickCount());
	}
	if(VehInfo[vehicleid][vRightSeat] >= 0)
	{
		EffectCheck{ VehInfo[vehicleid][vRightSeat] } = 2;

		i = VehInfo[vehicleid][vRightSeat];
		OldPlayerPos[i][0] = x;	OldPlayerPos[i][1] = y;	OldPlayerPos[i][2] = z;
		SetPVarInt(i, "AC:ChangePos:GTC", GetTickCount());
	}
	SetVehiclePos(vehicleid, x, y, z);
	SetVehicleZAngle(vehicleid, a);
	return true;
}

stock MyGetVehiclePos(vehicleid, &Float:x, &Float:y, &Float:z, &Float:a)
{
	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, a);
	return true;
}

//	Weapon
stock MyGivePlayerWeapon(playerid, weaponid, ammo)
{
	new slot = GetWeaponSlot(weaponid);
	if(slot != 255)
	{
	    SetPVarInt(playerid, "AC:Weapon:GTC", GetTickCount());
	    p_Protect[playerid][prWeaponID][slot] = weaponid;
	    p_Protect[playerid][prWeaponAmmo][slot] += ammo;
	    GivePlayerWeapon(playerid, weaponid, ammo);

	    switch(GetPlayerState(playerid))
	    {
	        case PLAYER_STATE_DRIVER:
	        {
	            // Убрать оружие из рук водителя
	            SetPlayerArmedWeapon(playerid, 0);
	        }
	        case PLAYER_STATE_PASSENGER:
	        {
	            // Убрать оружие из рук пассажира
	            if(!(3 <= slot <= 5))
	            {
	                // Кроме дробовиков, полуавтоматов и автоматов
	                SetPlayerArmedWeapon(playerid, 0);
	            }
	        }
	    }
	}
}

stock MySetPlayerWeapon(playerid, weaponid, ammo)
{
	new slot = GetWeaponSlot(weaponid);
	if(slot != 255)
	{
	    SetPVarInt(playerid, "AC:Weapon:GTC", GetTickCount());
	    p_Protect[playerid][prWeaponID][slot] = weaponid;
	    p_Protect[playerid][prWeaponAmmo][slot] = ammo;
	    ResetPlayerWeapons(playerid);
	    for(new s = 0; s < 13; s++)
		{
			GivePlayerWeapon(playerid, p_Protect[playerid][prWeaponID][s], p_Protect[playerid][prWeaponAmmo][s]);
		}
	}
	return true;
}

MyGetPlayerWeapon(playerid, slot, &weaponid, &ammo)
{
	weaponid	= p_Protect[playerid][prWeaponID][slot];
	ammo		= p_Protect[playerid][prWeaponAmmo][slot];
}

MyGetPlayerWeaponID(playerid, slot)
{
	return p_Protect[playerid][prWeaponID][slot];
}

MyGetPlayerWeaponAmmo(playerid, slot)
{
	new ammo;
	if(ANTICHEAT)
	{
		ammo = p_Protect[playerid][prWeaponAmmo][slot];
	}
	else
	{
		new weapons;
		GetPlayerWeaponData(playerid, slot, weapons, ammo);
	}
	return ammo;
}

stock MyClearPlayerWeaponSlot(playerid, slot)
{
	p_Protect[playerid][prWeaponID][slot] = 0;
    p_Protect[playerid][prWeaponAmmo][slot] = 0;
    MyUpdatePlayerWeapon(playerid);
}

stock MyResetPlayerWeapons(playerid)
{
	SetPVarInt(playerid, "AC:Weapon:GTC", GetTickCount());
	ResetPlayerWeapons(playerid);
	for(new s = 0; s < 13; s++)
	{
		p_Protect[playerid][prWeaponID][s] = 0;
	    p_Protect[playerid][prWeaponAmmo][s] = 0;
	}
	return true;
}

stock MyUpdatePlayerWeapon(playerid)
{
	SetPVarInt(playerid, "AC:Weapon:GTC", GetTickCount());
	ResetPlayerWeapons(playerid);
	for(new s = 0; s < 13; s++)
	{
		GivePlayerWeapon(playerid, p_Protect[playerid][prWeaponID][s], p_Protect[playerid][prWeaponAmmo][s]);
	}
	SetPlayerArmedWeapon(playerid,  0);
	return true;
}

Public: RearmedPlayerWeapon(playerid)
{
    new bool:founded = false;
    for(new i = 3; i <= 5; i++)
    {
        if(p_Protect[playerid][prWeaponID][i] > 0 && p_Protect[playerid][prWeaponAmmo][i] > 0)
        {
            founded = true;
			SetPlayerArmedWeapon(playerid, p_Protect[playerid][prWeaponID][i]);
			break;
        }
    }
    if(!founded) SetPlayerArmedWeapon(playerid, 0);
}

stock TogglePlayerControllableEx(playerid, toggle)
{
	p_Protect[playerid][prControllable] = toggle ? true : false;
	new vehicleid = GetPlayerVehicleID(playerid);
	if(vehicleid)	BlockVehicleEffect(vehicleid);
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

AnticheatCheck(playerid)
{
	new const i = playerid;

	new const ac_gtc = GetTickCount();

	new string[128],
		Float:pArmour, Float:pHealth,
		Float:X, Float:Y, Float:Z, Float:A,
		pState = GetPlayerState(i), 
		vehicleid = GetPlayerVehicleID(i), 
		vsurfinf = GetPlayerSurfingVehicleID(i), 
		second, ping, ac_delay;
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
	
	if(!IsPlayerLogged(i) || GetPVarInt(i, "AC:Spawn:BlockCheck"))	return true;

	ac_delay = AC_GetPlayerDelay(i);
    if(ac_gtc > p_Protect[i][prLastUpdate] + ac_delay)				return true;

	if(PLAYER_STATE_ONFOOT <= pState <= PLAYER_STATE_PASSENGER)
	{
		//	--- Hack movement
	    if(ac_gtc > (GetPVarInt(i, "AC:ChangePos:GTC") + ac_delay) && IsPlayerAFK(i) == false)
	    {
	    	MyGetPlayerPos(i, X, Y, Z, A);

	    	new bool:update_cord = true;
	    	new Float:sZ = (Z < OldPlayerPos[i][2]) ? OldPlayerPos[i][2] : Z;
	    	new Float:var = floatsqroot(GetDistanceFromPointToPoint(X, Y, sZ, Arr3<OldPlayerPos[i]>));

	    	//	пешком:		1.285
	    	//	в машине:	2.443
	    	//	аирбрейк:	6.31

			//	---	Teleport Hack
			if(OldPlayerPos[i][2] > -50.0)
			{
				if(var > 6.5)
				{
					if(pState != PLAYER_STATE_PASSENGER)
					{
						update_cord = false;
						SetPVarInt(i, "AC:DetectTeleporting", true);
					    GiveAnticheatWarn(i, TELEPORT_HACK);

					    //	Выключаем игроку элементы стримера
					  	TogglePlayerStreamerAllItem(i, false);

					    //	Сообщаем
						format(string, sizeof(string), "подозревается в телепортации [%s -> %s]", GetPointArea(OldPlayerPos[i][0], OldPlayerPos[i][1]), GetPointArea(X, Y));
						AC_PlayerMessage(i, string);

					    //	Пытаемся вернуть назад
						if(vehicleid)	MySetVehiclePos(vehicleid, Arr4<OldPlayerPos[i]>);
						else 			MySetPlayerPos(i, Arr4<OldPlayerPos[i]>);
					}
				}
				else
				{
					if(GetPVarInt(i, "AC:DetectTeleporting"))
					{
						//	Включаем игроку элементы стримера
						TogglePlayerStreamerAllItem(i, true);
						DeletePVar(i, "AC:DetectTeleporting");
					}

					//	Air Break
					if(pState == PLAYER_STATE_ONFOOT && vsurfinf == INVALID_VEHICLE_ID)
					{
			            if(GetPlayerSurfingObjectID(i) == INVALID_OBJECT_ID && GetPlayerSpecialAction(i) != SPECIAL_ACTION_USEJETPACK)
			            {
			            	if(ac_gtc > (p_Protect[i][prLastChangeState] + ac_delay))
			            	{
			            		if(var > 1.5)
				                {
				                	format(string, sizeof(string), "подозревается в AirBreak пешком [height: %.2f | %.2f]", Z, var);
				                	AC_PlayerMessage(i, string);
				                	GiveAnticheatWarn(i, AIR_BREAK);
				                }
			            	}
			            }
					}
					else if(pState == PLAYER_STATE_DRIVER)
					{
						if(var > 2.7)
		                {
		                	format(string, sizeof(string), "подозревается в AirBreak в авто [height: %.2f | %.2f]", Z, var);
							AC_PlayerMessage(i, string);
		                	GiveAnticheatWarn(i, AIR_BREAK);
		                }
					}
				}
			}
			if(update_cord)
			{
				OldPlayerPos[i][0] = X, OldPlayerPos[i][1] = Y, OldPlayerPos[i][2] = Z, OldPlayerPos[i][3] = A;
			}
		}

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
	    // ---	Money Hack
	    new money = GetPlayerMoney(i);
        if(ac_gtc > GetPVarInt(i, "AC:Money:GTC") + ac_delay && money != PlayerInfo[i][pMoney])
        {
			if(money > PlayerInfo[i][pMoney])
			{
				format(string, sizeof(string), "пытается начитерить %d$", money - PlayerInfo[i][pMoney]);
				AC_PlayerMessage(i, string);
				GiveAnticheatWarn(i, MONEY);
			}
			else if(money < PlayerInfo[i][pMoney])
			{
				if(IsPlayerInRangeOfPoint(i, 10.0, 617.5304,-1.9892,1000.5591)  // Transfender (int 1)
				|| IsPlayerInRangeOfPoint(i, 10.0, 616.7782,-74.8152,997.7711)  // Lawrider (int 2)
				|| IsPlayerInRangeOfPoint(i, 10.0, 615.2830,-124.2390,997.5698) // Wheels
				|| IsPlayerInPaynSpray(i))
				{
					format(string, sizeof(string), "потратил %d$ на тюнинг транспорта", PlayerInfo[i][pMoney] - money);
					Admin_Log(string);
					PlayerInfo[i][pMoney] = money;
				}
			}
			ResetPlayerMoney(i);
			GivePlayerMoney(i, PlayerInfo[i][pMoney]);
		}

		// ---	Vehicle TP
		/*if(vehicleid > 0 && vehicleid != PlayerVehicle[i])
		{
		    format(string, sizeof(string), "[AdmWrn]: %s[%d] подозревается в Vehicle Teleporting [%d -> %d]", ReturnPlayerName(i), i, PlayerVehicle[i], vehicleid);
		    SendAdminMessage(COLOR_LIGHTRED, string);
		    PlayerVehicle[i] = vehicleid;
			UpdateVehInfo();
		}*/

		//	---	Weapons
		if(ac_gtc > GetPVarInt(i, "AC:Weapon:GTC") + ac_delay)
		{
		    if(second % 5 == 0)
		    {
		    	new weapon[2];
				for(new s = 2; s < 13; s++)
				{	//	Пропускаем первые два слота
				    GetPlayerWeaponData(i, s, weapon[0], weapon[1]);
				    if(weapon[0] == 0)
				    {
						p_Protect[i][prWeaponID][s] = 0;
						p_Protect[i][prWeaponAmmo][s] = 0;
				    }
				    else if(weapon[0] != p_Protect[i][prWeaponID][s])
				    {
				        MyUpdatePlayerWeapon(i);
						format(string, sizeof(string), "попытался начитерить оружие (id %d)", weapon[0]);
						AC_PlayerMessage(i, string);
						GiveAnticheatWarn(i, WEAPON);
				    }
				    else if(weapon[1] > p_Protect[i][prWeaponAmmo][s])
				    {
				        MyUpdatePlayerWeapon(i);
						format(string, sizeof(string), "попытался начитерить патроны к оружию (id %d)", weapon[0]);
						AC_PlayerMessage(i, string);
						GiveAnticheatWarn(i, WEAPON);
				    }
				    else if(weapon[1] < p_Protect[i][prWeaponAmmo][s])
				    {
				    	p_Protect[i][prWeaponAmmo][s] = weapon[1];
				    }
				}
			}
		}

		//	--- Health/Armour
		if(ac_gtc > GetPVarInt(i, "AC:Health:GTC") + ac_delay)
		{
			GetPlayerHealth(i, pHealth);
			GetPlayerArmour(i, pArmour);
			//	---	Armour
			if(pArmour > p_Protect[i][prArmour])
			{
				format(string, sizeof(string), "попытался начитерить броню (от %.0f до %.0f [+%.0f])", p_Protect[i][prArmour], pArmour, floatabs(p_Protect[i][prArmour] - pArmour));
				AC_PlayerMessage(i, string);
				MySetPlayerArmour(i, p_Protect[i][prArmour]);
				GiveAnticheatWarn(i, ARMOUR);
			}
			//	---	Health
			if(pHealth > p_Protect[i][prHealth])
			{
				format(string, sizeof(string), "попытался начитерить здоровье (от %.0f до %.0f [+%.0f])", p_Protect[i][prHealth], pHealth, floatabs(p_Protect[i][prHealth] - pHealth));
				AC_PlayerMessage(i, string);
				MySetPlayerHealth(i, p_Protect[i][prHealth]);
				GiveAnticheatWarn(i, HEALTH);
			}
		}

		//	---	Special Action
		if(p_Protect[i][prSpecialAction] != SPECIAL_ACTION_USEJETPACK && GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK)
		{
			AC_PlayerMessage(i, "попытался начитерить JetPack");
			MySetPlayerSpecialAction(i, SPECIAL_ACTION_NONE);
		}
	}
	//	Обнуление варнов
	/*for(new E_CHEATS:e; e < E_CHEATS; e++)
	{
		if(p_Warnings[i][e][CW_COUNT] > 0)
		{
			if(p_Warnings[i][e][CW_TIME] + WARN_RESET_TIME < gettime())
			{
				p_Warnings[i][e][CW_COUNT]--;
			}
		}
	}*/
	p_Protect[i][prLastCheck] = GetTickCount();
	return 1;
}

//	Timer
Public: AnticheatTimer()
{
	if(ANTICHEAT == false)	return true;

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
			//	--- Hack movement
		    if(ac_gtc > (GetPVarInt(i, "AC:ChangePos:GTC") + ac_delay) && IsPlayerAFK(i) == false)
		    {
		    	
		    	vehicleid = GetPlayerVehicleID(i);
				vsurfinf = GetPlayerSurfingVehicleID(i);
		    	MyGetPlayerPos(i, X, Y, Z, A);

		    	new bool:update_cord = true;
		    	new Float:sZ = (Z < OldPlayerPos[i][2]) ? OldPlayerPos[i][2] : Z;
		    	printf("1");
		    	new var = floatround(floatsqroot(GetSquareDistance(X, Y, sZ, Arr3<OldPlayerPos[i]>)) * 3600) / (ac_gtc - p_Protect[i][prLastCheck]);
		    	printf("2");
				//	---	Teleport Hack
				if(OldPlayerPos[i][2] > -50.0)
				{
					printf("3");
					if(var > 1200)
					{
						printf("4");
						if(pState != PLAYER_STATE_PASSENGER)
						{
							printf("5");
							update_cord = false;
							SetPVarInt(i, "AC:DetectTeleporting", true);
						    GiveAnticheatWarn(i, TELEPORT_HACK);

						    //	Выключаем игроку элементы стримера
						  	TogglePlayerStreamerAllItem(i, false);

						    //	Сообщаем
							format(string, sizeof(string), "подозревается в телепортации [%s -> %s]", GetPointArea(OldPlayerPos[i][0], OldPlayerPos[i][1]), GetPointArea(X, Y));
							AC_PlayerMessage(i, string);

						    //	Пытаемся вернуть назад
							if(vehicleid)	MySetVehiclePos(vehicleid, Arr4<OldPlayerPos[i]>);
							else 			MySetPlayerPos(i, Arr4<OldPlayerPos[i]>);
						}
					}
					else
					{
						printf("6");
						if(GetPVarInt(i, "AC:DetectTeleporting"))
						{
							//	Включаем игроку элементы стримера
							TogglePlayerStreamerAllItem(i, true);
							DeletePVar(i, "AC:DetectTeleporting");
						}

						printf("7");
						//	Air Break
						if(pState == PLAYER_STATE_ONFOOT && vsurfinf == INVALID_VEHICLE_ID)
						{
				            if(GetPlayerSurfingObjectID(i) == INVALID_OBJECT_ID && GetPlayerSpecialAction(i) != SPECIAL_ACTION_USEJETPACK)
				            {
				            	printf("8");
				            	if(ac_gtc > (p_Protect[i][prLastChangeState] + ac_delay))
				            	{
				            		if(GetPlayerWeapon(i) == 46 && var > 95
				            		|| GetPlayerWeapon(i) != 46 && var > 75)
					                {
					                	printf("10");
					                	format(string, sizeof(string), "подозревается в AirBreak пешком [height: %.2f | %d KM/H]", Z, var);
					                	AC_PlayerMessage(i, string);
					                	GiveAnticheatWarn(i, AIR_BREAK);
					                }
				            	}
				            }
						}
						else if(pState == PLAYER_STATE_DRIVER)
						{
							if(240 + 40 <= var)
			                {
			                	format(string, sizeof(string), "подозревается в AirBreak в авто [height: %.2f | %d KM/H]", Z, var);
								AC_PlayerMessage(i, string);
			                	GiveAnticheatWarn(i, AIR_BREAK);
			                }
						}
					}
				}
				if(update_cord)
				{
					OldPlayerPos[i][0] = X, OldPlayerPos[i][1] = Y, OldPlayerPos[i][2] = Z, OldPlayerPos[i][3] = A;
				}
			}

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
		    // ---	Money Hack
		    new money = GetPlayerMoney(i);
	        if(ac_gtc > GetPVarInt(i, "AC:Money:GTC") + ac_delay && money != PlayerInfo[i][pMoney])
	        {
				if(money > PlayerInfo[i][pMoney])
				{
					format(string, sizeof(string), "пытается начитерить %d$", money - PlayerInfo[i][pMoney]);
					AC_PlayerMessage(i, string);
					GiveAnticheatWarn(i, MONEY);
				}
				else if(money < PlayerInfo[i][pMoney])
				{
					if(IsPlayerInRangeOfPoint(i, 10.0, 617.5304,-1.9892,1000.5591)  // Transfender (int 1)
					|| IsPlayerInRangeOfPoint(i, 10.0, 616.7782,-74.8152,997.7711)  // Lawrider (int 2)
					|| IsPlayerInRangeOfPoint(i, 10.0, 615.2830,-124.2390,997.5698) // Wheels
					|| IsPlayerInPaynSpray(i))
					{
						format(string, sizeof(string), "потратил %d$ на тюнинг транспорта", PlayerInfo[i][pMoney] - money);
						Admin_Log(string);
						PlayerInfo[i][pMoney] = money;
					}
				}
				ResetPlayerMoney(i);
				GivePlayerMoney(i, PlayerInfo[i][pMoney]);
			}*/

			// ---	Vehicle TP
			/*if(vehicleid > 0 && vehicleid != PlayerVehicle[i])
			{
			    format(string, sizeof(string), "[AdmWrn]: %s[%d] подозревается в Vehicle Teleporting [%d -> %d]", ReturnPlayerName(i), i, PlayerVehicle[i], vehicleid);
			    SendAdminMessage(COLOR_LIGHTRED, string);
			    PlayerVehicle[i] = vehicleid;
				UpdateVehInfo();
			}*/

			//	---	Weapons
		/*	if(ac_gtc > GetPVarInt(i, "AC:Weapon:GTC") + ac_delay)
			{
			    if(second % 5 == 0)
			    {
			    	new weapon[2];
					for(new s = 2; s < 13; s++)
					{	//	Пропускаем первые два слота
					    GetPlayerWeaponData(i, s, weapon[0], weapon[1]);
					    if(weapon[0] == 0)
					    {
							p_Protect[i][prWeaponID][s] = 0;
							p_Protect[i][prWeaponAmmo][s] = 0;
					    }
					    else if(weapon[0] != p_Protect[i][prWeaponID][s])
					    {
					        MyUpdatePlayerWeapon(i);
							format(string, sizeof(string), "попытался начитерить оружие (id %d)", weapon[0]);
							AC_PlayerMessage(i, string);
							GiveAnticheatWarn(i, WEAPON);
					    }
					    else if(weapon[1] > p_Protect[i][prWeaponAmmo][s])
					    {
					        MyUpdatePlayerWeapon(i);
							format(string, sizeof(string), "попытался начитерить патроны к оружию (id %d)", weapon[0]);
							AC_PlayerMessage(i, string);
							GiveAnticheatWarn(i, WEAPON);
					    }
					    else if(weapon[1] < p_Protect[i][prWeaponAmmo][s])
					    {
					    	p_Protect[i][prWeaponAmmo][s] = weapon[1];
					    }
					}
				}
			}

			//	--- Health/Armour
			if(ac_gtc > GetPVarInt(i, "AC:Health:GTC") + ac_delay)
			{
				GetPlayerHealth(i, pHealth);
				GetPlayerArmour(i, pArmour);
				//	---	Armour
				if(pArmour > p_Protect[i][prArmour])
				{
					format(string, sizeof(string), "попытался начитерить броню (от %.0f до %.0f [+%.0f])", p_Protect[i][prArmour], pArmour, floatabs(p_Protect[i][prArmour] - pArmour));
					AC_PlayerMessage(i, string);
					MySetPlayerArmour(i, p_Protect[i][prArmour]);
					GiveAnticheatWarn(i, ARMOUR);
				}
				//	---	Health
				if(pHealth > p_Protect[i][prHealth])
				{
					format(string, sizeof(string), "попытался начитерить здоровье (от %.0f до %.0f [+%.0f])", p_Protect[i][prHealth], pHealth, floatabs(p_Protect[i][prHealth] - pHealth));
					AC_PlayerMessage(i, string);
					MySetPlayerHealth(i, p_Protect[i][prHealth]);
					GiveAnticheatWarn(i, HEALTH);
				}
			}

			//	---	Special Action
			if(p_Protect[i][prSpecialAction] != SPECIAL_ACTION_USEJETPACK && GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK)
			{
				AC_PlayerMessage(i, "попытался начитерить JetPack");
				MySetPlayerSpecialAction(i, SPECIAL_ACTION_NONE);
			}
		}
		p_Protect[i][prLastCheck] = GetTickCount();*/
		//	Обнуление варнов
		for(new E_CHEATS:e; e < E_CHEATS; e++)
		{
			if(p_Warnings[i][e][CW_COUNT] > 0)
			{
				if(p_Warnings[i][e][CW_TIME] + WARN_RESET_TIME < gettime())
				{
					p_Warnings[i][e][CW_COUNT]--;
				}
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

#define OnPlayerSpawn AC_OnPlayerSpawn
#if defined AC_OnPlayerSpawn
	forward AC_OnPlayerSpawn();
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
		        if((fX <= -1000.0 || fX >= 1000.0) || (fY <= -1000.0 || fY >= 1000.0) || (fZ <= -1000.0 || fZ >= 1000.0)
		        || ((hittype != BULLET_HIT_TYPE_PLAYER) && (hittype != BULLET_HIT_TYPE_VEHICLE) && (hittype != BULLET_HIT_TYPE_OBJECT)
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

		AnticheatCheck(playerid);
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