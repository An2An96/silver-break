#define Anticheat.				Anticheat_

#define MAX_WARNS 				3 									//	�������� ������������ ������ �������� �� ���� ������
#define WARN_RESET_TIME			300									//	��������� ��������� ������ ��������
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
	OUTOFENGINE,        // �������� � ��������� ����������
}

enum E_WARN_DATA
{
	CW_COUNT,
	CW_TIME,
}

new const Cheats[E_CHEATS][] = {
	"��� �� ������",
	"��� �� ������",
	"��� �� ��������",
	"��� �� �����",
	"FlyHack",
	"������������ ����",
	"AirBreak",
	"������������",
	"������ ��������",
	"������ ����",
	"�������",
	"�������� � ����������� ����"
};

enum    E_PROTECTION
{
	//	--- health/armour
	Float:prHealth,	//	������ ���-�� �� ������� ������ ���� � ������
	Float:prArmour,	//	������ ���-�� ����� ������� ������ ���� � ������

	//	--- weapon
	prWeaponID[13],
	prWeaponAmmo[13],

	//	---	special action
	prSpecialAction, // ��� �������� ��������

	prNoTPCheck,	//	���-�� ������ ���� ������� ������ �� �����������
	prLastCheck,

	prLastUpdate,	//	����� ���������� ���������� ������ (��� ������������ ����� � ���)

	//	---	speed
	prOldSpeed,				//	

	//	--- other info
	bool:prPause, 			//	��������� �� ����� � ���
	bool:prControllable,
	prLastChangeState,
}
new p_Protect[MAX_PLAYERS][E_PROTECTION];
new p_Warnings[MAX_PLAYERS][E_CHEATS][E_WARN_DATA];
new gCheaterID[10] = { -1, ... };
new gCheaterCount;

new bool:PlayerBusy[MAX_PLAYERS char];
new Float:OldPlayerPos[MAX_PLAYERS][4];