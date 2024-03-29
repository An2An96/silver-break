#if defined _businesses_header_included
	#endinput
#endif
#define _businesses_header_included

enum
{
	BUS_SHOP,
	BUS_EATERY,
	BUS_GAS_STATION,
	BUS_BAR,
	BUS_CLUB,
	BUS_GYM,
	BUS_AMMO,
	BUS_CLOTHING,
	BUS_STRIP,
	BUS_CASINO,
	BUS_ACSR,
};

enum eBizParams
{
	btName[24],
	btMapIcon,
	btRobbery,			//	����� �� ������� ������
	btMaxEnterPrice,	//	������������ ���� �� ����
	btGPSType,			//	0 - ��������/����������, 1 - �����������, 2 - ��������
};

new const BizTypeData[][eBizParams] = {
	{ "�������", 				52,	true,	0,		0 },
	{ "����������",				10,	true,	0,		0 },
	{ "����������� �������",	47,	false,	0, 		2 },
	{ "���",					49,	true,	250,	1 },
	{ "������ ����",			48,	true,	300,	1 },
	{ "���������� ���",			54,	false,	300,	1 },
	{ "��������� �������",		6,	false,	350,	0 },
	{ "������� ������",			45,	true,	100,	0 },
	{ "�������� ����",			12,	true,	800,	1 },
	{ "������",					44,	true,	1000,	1 },
	{ "������� �����������",	0,	true,	100,	0 }
};

enum bInfo
{
	bID,
	bName[BIZ_NAME_SIZE],
	bType,
	bOwnerID,
	bSellPrice,
	Float:bBank,
	bPrice,
	bMaxProds,
	bProduct,
	bOrderProds,
	bStatus,
	Float:bPos[4],
	Float:bWorkPos[3],
	bLocation,
	bEnterPrice,
	bPaymentDays,

	//	Not Save
	bPickup,
	bExPickup,
	bMapIcon,
	Text3D:b3dText,

	bActor,
	bRobbery,
	bRobberyTime,
};
new BizInfo[MAX_BUSINESSES][bInfo];
new PickupedBiz[MAX_PLAYERS] = { INVALID_DATA, ... };