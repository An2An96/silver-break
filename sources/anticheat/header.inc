#define Anticheat.				Anticheat_

#define MAX_WARNS 				3 									//	Максимум сробатывания одного античита до кика игрока
#define WARN_RESET_TIME			300									//	Интвервал обнуления варнов античита
#define AC_GetPlayerDelay(%0)	500 + (GetPlayerPing(%0) * 15)

forward OnPlayerCheckAnticheat(playerid);
forward OnPlayerChangeArmour(playerid, Float:oldArmour, Float:armour);

forward bool:IsPlayerAFK(playerid);

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

new const Cheats[E_CHEATS][] = {
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
new p_Protect[MAX_PLAYERS][E_PROTECTION];
new p_Warnings[MAX_PLAYERS][E_CHEATS][E_WARN_DATA];
new gCheaterID[10] = { -1, ... };
new gCheaterCount;

new bool:PlayerBusy[MAX_PLAYERS char];
new Float:OldPlayerPos[MAX_PLAYERS][4];