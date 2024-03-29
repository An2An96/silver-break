#if defined _job_header_included
	#endinput
#endif

#define _job_header_included

#define Job.	Job_

#define CONTRACT_TIME			180		// ����� �������� ���������

forward OnPlayerStartWork(playerid, work);
forward OnPlayerFinishWork(playerid, work, reason);
forward GetPlayerJob(playerid);

enum
{
	Job.REASON_COMPLETE,
	Job.REASON_TIMEOUT,
	Job.REASON_DEATH,
	Job.REASON_DISCONNECT,
	Job.REASON_SPECIAL,
}

enum
{/* �� ������ ������������������, ��������� � ����� */
	JOB_NONE,

// ��������� ������
	JOB_BUSDRIVER,  // 	�������� �������� (��������)
	JOB_TRUCKER,    // 	������������ (��������)
	JOB_TAXI,		//	������� (��������)
	JOB_MECHANIC,	//	������� (��������)
	JOB_TRASHMAN,	//	�������� (��������)

// ����������� ������ (IsAvailableJob)
	JOB_THEFT,		// 	����������� (����������, LCN)
	//JOB_GUNDEAL,	// 	�������� ������� (����������, RusMaf)
	//JOB_DRUGDEAL,	// 	����������� (����������, Yakuza)

//	���������� (� �����)
	PART_LOADER	= 9,//	�������
	PART_FARMER,	//	������
	PART_DELIVERY,	//	��������
	PART_DIVER,		//	������					[not implemented]
	PART_PIZZA,		//	�������� �����			[not implemented]

	//JOB_AUTODEAL,	// 	���������� (��������)
	//JOB_FISHER,	// 	��������� (����������)
	//JOB_WHORE,	// 	����� (����������)
	//JOB_KILLER,   // ������ (������)
	//JOB_BUILDER,  // ��������� (�������)
	//JOB_PHOTO,    // �������� (�������)
	//JOB_LAWYER,	// ������� (���������� ����������)
	//JOB_DETECTIVE,	// ��������
	//JOB_AIRCOMPANY,   // ������������ (�������)
};

enum E_JOB_INFO
{
	J_NAME[24],		//	�������� ������
	J_LEVEL,
	bool:J_OFF,		//	����������� ������ (true - ��� | false - �� ���)
	bool:J_PART,	//	0 - ������ | 1 - ����������
	Float:J_POS[3],	//	������� ������ �� ����� (��� ���� ������)

	//	Settings
	J_CLEAR_TYPE,	//	��� ������ ������ (0 - ��� ������, 1 - ��� ������)
};

new Jobs[][E_JOB_INFO] = {
	{ "�����������",		0,	false,	false,	{ 0.0, 0.0, 0.0 },	false },				//	JOB_NONE
	
	{ "�������� ��������",	2,	true, 	false,	{ 1259.86, -1814.57, 13.40 },	false },	//	JOB_BUSDRIVER
	{ "������������",		3,	true,	false,	{ 2212.05, -2226.70, 13.54 },	false },	//	JOB_TRUCKER
	{ "�������",			2,	true,	false,	{ 1091.07, -1768.42, 13.30 },	false },	//	JOB_TAXI
	{ "�������",			4,	true,	false,	{ 1099.81, -1235.69, 15.80 },	false },	//	JOB_MECHANIC
	{ "��������",			0,	true,	false,	{ 2200.47, -1970.28, 13.78 },	false },	//	JOB_TRASHMAN

	{ "�����������",		5,	false,	false,	{ 1241.09, -2047.22, 60.0 },	true },		//	JOB_THEFT
	//{ "�������� �������",	5,	false,	false,	{ 1267.99, -818.602, 84.1 },	false },	//	JOB_GUNDEAL
	//{ "�����������",		5,	false, 	false,	{ 688.287, -1271.47, 13.5 },	false },	//	JOB_DRUGDEAL

	//	Part Jobs
	{ "������",				0,	true,	true,	{ 0.0, 0.0, 0.0 },	false },	//	PART_FARMER
	{ "��������",			0,	true,	true,	{ 0.0, 0.0, 0.0 },	false },	//	PART_DELIVERY
	{ "������",				0,	true,	true,	{ 0.0, 0.0, 0.0 },	false },	//	PART_DIVER
	{ "������",				0,	true,	true,	{ 0.0, 0.0, 0.0 },	false }		//	PART_PIZZA
};

new 
	pJob[MAX_PLAYERS]			=	{ JOB_NONE, ... },
	pContract[MAX_PLAYERS],
	pAtWork[MAX_PLAYERS] 		= 	{ JOB_NONE, ... },
	pJobMapIcon[MAX_PLAYERS]	=	{ INVALID_STREAMER_ID, ... },
	Float:pJobWage[MAX_PLAYERS],		// ������� ��������� (������������� � 00 �����)
	Float:pPartWage[MAX_PLAYERS];