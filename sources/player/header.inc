#if defined _player_header_included
	#endinput
#endif
#define _player_header_included

#define isRus(%0)		PlayerInfo[%0][pRusifik]

enum E_PLAYER
{
	ORM:ORM_ID,	//  �� ����������
	pUserID,	//  �� �������� � ����� ���� (UCP)

	pLevel,		// �������
	pExp,       // ����
	pVip,		// ������� �������
	pVipUNIX,	// ����� ��������� ��������
	pSex,		// ���
	pSkin,		// ������ ����
	pMoney,		// ������
	pWantedLvl,	// ������� �������
	pFaction,	// ����� ����������� ������
	pLeader,	// UNIX ����� ������ ������� (����� ���� ������ ����!)
	pRank,		// ���� � �����������
	pCopWarn,   // �������������� ����
	pCopCases,  // ����������� ���� ����
	pSpawn,		// ��� ���������
	Float:pPosX,// ������� ������:
	Float:pPosY,//  -//-
	Float:pPosZ,//  -//-
	Float:pPosA,//  -//-
	pPosINT,    //  -//-
	pPosVW,     //  -//-
	pExitUNIX,  // ����� ������
	pJailTime,  // �������� ���� (������ ���� - ���(-wl); ������ ���� - ������(jailtime))
	pAJailTime,	// ���� ��������� (����� ������)
	pWarns,     // ��������������
	pWarnUNIX,  // ����� ���������� �����
	pAskMute,   // ����� ���������� ����� � �������� (�������� UNIX �����, �� �������� �������)
	pMuteTime,  // ����� �������� (������� � ���� [> 0], �� ������� � ���� [= 0])
	pAdmin,     // ������� ������
	pBanUNIX,   // ����� ����
	pHousing,   // ����� ���������� (��� [houseid > 0], ����������� [= 0])
	pRent,		// �� ����������� ���� (����� [hotel < 0], ����������� [= 0], ��� [houseid > 0])
	pPaymentDays,		// ���������� ��������� ���� ��� ������
	pCensored,  		// �����.: �������
	pLaw,				// ����������������� (�� -50 �� 50)
	Float:pBank,		// ���� � ����� (GivePlayerBank)
	Float:pCrimeWage,	// ������� ������������� ��������� (����������, ������ � ���-��)
	pEmployer,  		// ���������������
	pUpgrade,   		// ���� �������
	Float:pRunCar,		// ������ �� ����
	Float:pSaveHealth,	// ����� ��������
	Float:pSaveArmour,	// ����� �����
	pHunger,			// �����
	pPhoneNumber,		//	����� ���������� �������� (0-�������� ���)
	Float:pPhoneBalance,//	������ ��������
	bool:pPhoneEnable,	//	�������/�������� �������
	pCarLicA,			//	����� ��������� A (���������, ������)
	pCarLicB,			//	����� ��������� B (����������)
	pCarLicC,			//	����� ��������� C (���������)
	pCarLicD,			//	����� ���������	D (��������)
	pCarLic,		// �������� �� ��������
	pGunLic,    	// ���������� �� ������
	pTheftTime,     // UNIX ����� ��������� �������� ��������� ���� (����� = 0, �� �� ����� ����������� � �����������)
	pASElement,		// �������� ��������� � ���������
	pTaxiLevel,		// ������� ������ ���������
	pTaxiSkill,		// ����� ������ ���������
	pBusLevel,		// ������� ������ �������� ��������
	pBusSkill,		// ����� ������ �������� ��������
	pTruckLevel,	// ������� ������ ��������������
	pTruckSkill,	// ����� ������ ��������������
	pNewsUnix,      // ����� ������� ���������� (� ���)
	pNewsCount,     // ���������� ���������� (� ���)
	pKills,     	// ���������� �������
	pDeaths,    	// ���������� �������
	pExpsum,		// ����� ����������� �����
	bool:pRusifik,		// ������� ������������
	bool:pInterface,	// ������ ���������� ������
	bool:pLowerPanel,	// ������ ������ ������ ����������
	bool:pHouseIcon,	// ����������� ������ �����
	bool:pToggleZone,	// ����������� ����-���
	Float:pPower,   	// ���� ������
	pTraining,      	// ���-�� ���������� �������� ������� (���������� ������ ���)
	pShooting,			// ������ ����
	pWalk,				// ������� ������
	pAnim,				// �� ������ �������� (0 - ���)
	pLearnFStyle,		// �������� ����� ���
	pFightStyle,		// ����� ���
	pGametime,			// ������� ����� ��������� �� ��������� ���

	//	Not Saved
	pNextFriskTime,		// ����� ���������� ������
};
new PlayerInfo[MAX_PLAYERS][E_PLAYER];