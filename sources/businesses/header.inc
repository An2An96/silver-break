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
	btRobbery,			//	можно ли грабить бизнес
	btMaxEnterPrice,	//	максимальная цена за вход
	btGPSType,			//	0 - магазины/закусочные, 1 - развлечения, 2 - заправка
};

new const BizTypeData[][eBizParams] = {
	{ "Магазин", 				52,	true,	0,		0 },
	{ "Закусочная",				10,	true,	0,		0 },
	{ "Заправочная станция",	47,	false,	0, 		2 },
	{ "Бар",					49,	true,	250,	1 },
	{ "Ночной клуб",			48,	true,	300,	1 },
	{ "Спортивный зал",			54,	false,	300,	1 },
	{ "Оружейный магазин",		6,	false,	350,	0 },
	{ "Магазин одежды",			45,	true,	100,	0 },
	{ "Стриптиз клуб",			12,	true,	800,	1 },
	{ "Казино",					44,	true,	1000,	1 },
	{ "Магазин Аксессуаров",	0,	true,	100,	0 }
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