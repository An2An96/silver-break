#if defined FACTION_POLICE_HEADER_INCLUDED
	#endinput
#endif
#define FACTION_POLICE_HEADER_INCLUDED

#define Police.				Police_

#define CopList_ADD(%0)		Iter_Add(Cop, %0)
#define CopList_REMOVE(%0)	Iter_Remove(Cop, %0)
//#define IsPoliceDuty(%0)	Iter_Contains(Cop, %0)  //  Optimize

enum
{
	//	������ (�����)
	CRIME_NOT_LIGHT,
	CRIME_DRUNK,
	CRIME_NOT_LIC,
	//	������� (�����)
	CRIME_HOOLIGAN,
	CRIME_ROBBERY_SHOP,
	CRIME_THEFT_AUTO,
	CRIME_CREATE_GUN,
	CRIME_CREATE_DRUGS,
	CRIME_RESIST,
	CRIME_CARRY_CRIMINAL,
	CRIME_HAVE_GUN,
	CRIME_THINGS,
	//	������ (�����)
	CRIME_KILL,
	CRIME_COP_KILL,
	CRIME_RUNAWAY,
	CRIME_IN_JAIL
}

enum
{
	PS_NONE,
	PS_CHECK,
	PS_WAIT,
	PS_WAIT_ACTION,
	PS_WAIT_OUT_VEH,
	PS_OUT_COMPLETE,
	PS_CRIMINAL,
}

enum E_CRIME
{
	E_TITLE[32],
	E_START_WL,		// ���� ������ �����, �� ���� ����
	E_WL,			// ������� ����� ������������
	E_MAX_WL,		// ����� ������������ �� ���������
	E_SHOW_AGAIN	// ���������� ���������� � ������������ ��� ��������� ����������(���� ����� ��� ��������)
}

new CrimesList[][E_CRIME] =
{
	//	������ (�����)
	{ "�������� ��� ���������",			1, 1, 2, false },
	{ "�������� � ������ ����",			3, 1, 3, false },
	{ "�������� ��� ��������",			3, 1, 3, false },
	{ "�����������", 					3, 1, 3, false },
	//	������� (�����)
	{ "���������� ��������",			4, 2, 6, false },
	{ "���� ��������������",			4, 1, 4, false },
	{ "������������ ������",			4, 1, 4, false },
	{ "������������ ����������",		4, 1, 4, false },
	{ "�������� �������������",			4, 1, 4, false },
	{ "��������� �����������",			4, 1, 4, false },
	{ "���������� ������� ������",		4, 1, 4, false },
	{ "������� ����������� ���������",	4, 1, 4, false },
	//	������ (�����)
	{ "��������", 						4, 1, 8, false },
	{ "��������� �� ����������",		4, 1, 6, false },
	{ "����� �� ������",				8, 1, 8, false },
	{ "������������� � ������",			8, 1, 8, false }
};

new PlayerCuffedTime[MAX_PLAYERS];
new CriminalMarkers[MAX_PLAYERS];
new bool:CriminalDanger[MAX_PLAYERS];    // ����� ������ (�������������)
new criminal_timer[MAX_PLAYERS];

new 
	PlayerText:PTD_WantedLevel,
	PlayerText:PTD_WantedStatus;
	
forward	CrimePlayer(playerid, crimeid);
forward	MySetPlayerWantedLevel(playerid, level);

//	����������� ������
new PursuitStatus[MAX_PLAYERS],				// ������ ������
	PursuitState[MAX_PLAYERS],				// GetPlayerState � ������ ������
	PursuitCount[MAX_PLAYERS],				// ������� �������
	PursuitLastUNIX[MAX_PLAYERS],			// Unix ��������� ���������
	PursuitTickcount[MAX_PLAYERS],			// ������� ��������
	bool:PursuitLamp[MAX_PLAYERS],			// ������ ��� �� ������ ���������
	bool:PursuitCrimTransit[MAX_PLAYERS],	// ��������� �� �����������
	bool:PursuitIllegalItem[MAX_PLAYERS],	//	����� �� ����������� ��������
	bool:PursuitAllowArrest[MAX_PLAYERS],	//	��������� �� ���������� (������ < 4)
	PursuitReinforc[MAX_PLAYERS],
	PursuitReinforcReload[MAX_PLAYERS],
	PursuitReinforcMapIcon[MAX_PLAYERS],
	PursuitReinforcTime[MAX_PLAYERS],
	PursuitArest[MAX_PLAYERS],
	PursuitArestPlayer[MAX_PLAYERS] = { INVALID_PLAYER_ID, ... },	//	�� ������ �������� ������������ ���
	PursuitCancelHandsup[MAX_PLAYERS],
	pursuit_timer[MAX_PLAYERS];
new Text3D:criminal_3d[MAX_PLAYERS];

enum pmInfo
{
	pmNum,      // ����� ������
	pmType,     // ��� ������
	pmPlace,    // ����� ������
	pmUNIX,     // ���� ������
};
new PoliceMission[12][pmInfo];

new PM_Type[MAX_PLAYERS],// 0 - �����, 2-4 - ��������� ������, 10 - �������������
	PM_Step[MAX_PLAYERS],
	PM_Place[MAX_PLAYERS],
	PM_UNIX[MAX_PLAYERS],
	PM_SearchZone[MAX_PLAYERS], // CreateGangZone()
	PM_SearchZone2[MAX_PLAYERS]; // CreateDynamicRectangle()
