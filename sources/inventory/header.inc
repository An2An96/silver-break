#if defined _inventory_header_included
  #endinput
#endif

#define _inventory_header_included

#define Inv.					Inv_
#define Acsr.					Acsr_
#define UseItem:%0(%1) \
	forward UseItem_%0(%1); public UseItem_%0(%1)

#define MAX_THINGS 				36
//#define MAX_THROW_THINGS		200
#define ACSR_TAB_NUM			999

forward E_INV_TABS:IFace_Inv_GetTabType(playerid, tabNum); 
forward Inv_IFace_Create_Player(playerid);

enum E_INV_TABS
{
	TYPE_THROW,				//	На земле				(sourceId — -)
	TAB_INVENTORY,			//	В инвентаре игрока		(sourceId — Id игрока в базе)
	TAB_ACSR,				//	Надето на игрока 		(sourceId - Id игрока в базе)
	TYPE_IN_HAND,			//	В руках игрока			(sourceId - Id игрока в базе)
	TYPE_INSIDE,			//	Внутри другого предмета (sourceId — Id предмета в базе)
 	TAB_VEHICLE_TRUNK,		//	В багажнике авто 		(sourceId — Id авто в базе)
	TYPE_TRASHCAN,			//	Внутри мусорного бака 	(sourceId - Id мусорки в базе)
}

new const tabNames[E_INV_TABS][24] = { "На земле", "Инвентарь", "Аксессуары", "В руках", "Коробка", "Багажник", "Мусорка" };

enum
{
	ACT_USE,
	ACT_GIVE,
	ACT_DROP,
	ACT_SPLIT,
	ACT_INFO,
	ACT_SETTING,
}

//	acsr wear errors
enum
{
	ERROR_INVALID_SLOT 		= -1,
	ERROR_TYPE_ALREADY_USE 	= -2,
	ERROR_ALREADY_PUTS 		= -3,
}

enum
{
	TH_TYPE_WEAPON,
	TH_TYPE_DEFAULT,
	TH_TYPE_FOOD,
	TH_TYPE_SKIN,
	TH_TYPE_ACSR,
	TH_TYPE_IN_HAND
}

enum
{
	THING_NONE,
	// Usual
	THING_WATCH,
	THING_GASCAN,
	
	THING_FIREWORK,
	THING_PICKLOCK,
	THING_FIRSTAID,
	THING_CIGARETTE,
	THING_METALL,
	THING_GUN_MATS,
	THING_DRUGS_MATS,
	THING_DRUGS,
	THING_CHIPS,
	//	Other
	THING_PRESENTBOX,
	THING_HELPREWARD,

	//	Еда
	THING_CHOCOLATE,
	THING_RED_APPLE,
	THING_GREEN_APPLE,
	THING_ORANGE,
	THING_BANANA,
	THING_CEREAL,
	THING_BREAD,
	THING_MILK,
	THING_JUICE,
	THING_ICECREAM,

	THING_WEAPON,
	//	Clothes
	THING_SKIN,
	THING_MUSIC,
	THING_GLASS,
	THING_MASK,
	THING_HELMET,
	THING_HAT,

	//
	THING_BOX,
	THING_BOX2,
	THING_SUITCASE,
	THING_SUITCASE2,
	THING_BAG,
	THING_BAG2,
	THING_TRASH,
}

enum
{
	USE_ONEOFF,     // Автоматически забирать после использования
	USE_FULLY,		// Забирать все количество при использовании
	USE_REUSABLE,   // Не забирать предмет после использования (может забираться в ручную)
}

enum THING_INFO
{
	T_TITLE[32],
	T_DESCRIP[64],
	T_TYPE,
	T_COST,
	T_MAX_STACK,
	T_OBJECTID,
	Float:T_OBJ_HEIGHT,
	Float:T_OBJ_ROT,
	Float:T_VISUAL_POS[4],
	T_USETYPE,
	bool:T_LEGALLY,
	T_FUNC[32],
}
new const thingData[][THING_INFO] =
{
//	Обычные предметы	
	{	"No-one",					"",														TH_TYPE_DEFAULT,	0,		0,		0,		0.00,	0.00,	{ -16.0, 0.0, -55.0, 1.0 },		USE_REUSABLE,	true,	""			},
	
	{	"Часы", 					"Помогают всегда знать точное время",					TH_TYPE_DEFAULT,	100,	1,		19043,	0.00,	0.00,	{ 00.00, 50.0, 20.0, 0.6 },		USE_REUSABLE,	true,	#Watch		},
	{	"Канистра с бензином", 		"Позволяет заправить авто если вы обсохли",				TH_TYPE_DEFAULT,	0,		1,		1650,	0.00,	90.0,	{ 00.00, 0.00, 0.00, 1.0 },		USE_ONEOFF,		true,	#Gascan 	},
	{	"Фейерверк",				"Небольшой фейерверк для развлечения",					TH_TYPE_DEFAULT,	40,		1,		19055,	0.00,	0.00,	{ 330.0, 00.00, 50.00, 1.2 },	USE_ONEOFF,		true,	#Firework 	},
	{	"Отмычка",			 		"Позволяет бесшумно открыть замок автомобиля",			TH_TYPE_DEFAULT,	0,		10,		1575,	0.03,	0.00,	{ 330.0, 00.00, 40.00, 1.2 },	USE_REUSABLE,	true,	#Picklock	},
	{	"Бинты",			 		"Позволяет перевязать рану, остановить кровотечение",	TH_TYPE_DEFAULT,	0,		5,		11747,	0.00,	0.00,	{ 310.0, 00.00, 150.0, 0.9 },	USE_ONEOFF,		true,	#Firstaid	},
	{	"Сигареты",			 		"Позволяют немного восполнить здоровье",				TH_TYPE_DEFAULT,	2,		10,		19897,	0.00,	0.00,	{ 310.0, 00.00, 150.0, 0.7 },	USE_ONEOFF,		true,	#Cigarette 	},	// 3044
	{	"Металл",					"Используется для изготовления материалов",				TH_TYPE_DEFAULT,	0,		5,		1579,	0.00,	0.00,	{ 310.0, 00.00, 30.00, 1.2 },	USE_FULLY,		true,	#Metall		},
	{	"Материалы",				"Используются для изготовления оружия",					TH_TYPE_DEFAULT,	0,		100,	1578,	0.00,	0.00,	{ 310.0, 00.00, 30.00, 1.2 },	USE_ONEOFF,		false,	#GunMats	},
	{	"Трава",					"Растения из которых можно изготовить наркотики",		TH_TYPE_DEFAULT,	0,		10,		1577,	0.00,	0.00,	{ 310.0, 00.00, 30.00, 1.2 },	USE_FULLY,		false,	#DrugsMats	},
	{   "Наркотики",                "Быстро восполняют здоровье, вызывая привыкание",		TH_TYPE_DEFAULT,	0,		100,	1576,	0.00,	0.00,	{ 310.0, 00.00, 30.00, 1.2 },	USE_ONEOFF,		false,	#Drug 		},
	{	"Фишки казино (чипы)",		"Небольшие диски, используемые вместо валюты в казино",	TH_TYPE_DEFAULT,	1,		100,	1904,	0.00,	0.00,	{ 330.0, 00.00, 00.00, 1.0 },	USE_REUSABLE,	true,	#Chips		},
	{	"Первооткрыватель", 		"Награда за участие в бета-тесте",						TH_TYPE_DEFAULT,	0,		1,		19057,	0.00,	0.00,	{ 330.0, 00.00, 50.00, 1.2 },	USE_ONEOFF,		true,	#Presentbox	},
	{	"Награда за помощь", 		"За вклад в развитие сервера",							TH_TYPE_DEFAULT,	0,		1,		902,	0.00,	0.00,	{ 290.0, 335.0, 50.00, 1.2 },	USE_REUSABLE,	true,	#Helpreward	},

//	Еда
	{	"Гамбургер", 				"Позволяет немного утолить голод",						TH_TYPE_FOOD,		10,		5,		19811,	0.04,	0.00,	{ 340.0, 00.00, 50.00, 1.0 },		USE_ONEOFF,		true,	#Chocolate	},
	{	"Красное яблоко", 			"Позволяет немного утолить голод",						TH_TYPE_FOOD,		2,		5,		19575,	0.04,	0.00,	{ 310.0, 00.00, 150.0, 0.7 },		USE_ONEOFF,		true,	#Apple		},
	{	"Зеленое яблоко", 			"Позволяет немного утолить голод",						TH_TYPE_FOOD,		2,		5,		19576,	0.04,	0.00,	{ 310.0, 00.00, 150.0, 0.7 },		USE_ONEOFF,		true,	#Apple		},
	{	"Апельсин", 				"Позволяет немного утолить голод",						TH_TYPE_FOOD,		2,		5,		19574,	0.04,	0.00,	{ 310.0, 00.00, 150.0, 0.7 },		USE_ONEOFF,		true,	#Orange		},
	{	"Банан", 					"Позволяет немного утолить голод",						TH_TYPE_FOOD,		2,		5,		19578,	0.04,	0.00,	{ 310.0, 00.00, 150.0, 0.6 },		USE_ONEOFF,		true,	#Banana		},
	{	"Пачка хлопьев", 			"Позволяет немного утолить голод",						TH_TYPE_FOOD,		15,		5,		19562,	0.04,	0.00,	{ 350.0, 00.00, 150.0, 1.0 },		USE_ONEOFF,		true,	#Cereal		},
	{	"Хлеб", 					"Позволяет немного утолить голод",						TH_TYPE_FOOD,		10,		5,		19579,	0.04,	0.00,	{ 330.0, 00.00, 130.0, 1.0 },		USE_ONEOFF,		true,	#Bread		},
	{	"Молоко", 					"Позволяет немного утолить голод",						TH_TYPE_FOOD,		10,		5,		19569,	0.04,	0.00,	{ 340.0, 00.00, 330.0, 1.0 },		USE_ONEOFF,		true,	#Milk		},
	{	"Сок", 						"Позволяет немного утолить голод",						TH_TYPE_FOOD,		5,		5,		19564,	0.04,	0.00,	{ 340.0, 00.00, 330.0, 1.0 },		USE_ONEOFF,		true,	#Juice		},
	{	"Мороженное", 				"Позволяет немного утолить голод",						TH_TYPE_FOOD,		10,		5,		19565,	0.04,	0.00,	{ 340.0, 00.00, 330.0, 1.0 },		USE_ONEOFF,		true,	#IceCream	},


//	Оружие
	{	"Оружие",					"Текст",												TH_TYPE_WEAPON,		0,		100,	0,		0.00,	90.0,	{ 0.0, 0.0, 0.0, 1.0 },			USE_REUSABLE,	true,	#Weapon		},

//	Одежда	
	{	"Одежда",					"Текст",												TH_TYPE_SKIN,		0,		1,		2705,	0.00,	90.0,	{ -16.0, 00.00, 00.00, 1.0 },	USE_REUSABLE,	true,	#Skin		},
	
//	Аксессуары
	{	"Наушники",					"Позволяют слушать радио с телефона за пределами авто",	TH_TYPE_ACSR,		0,		1,		19421,	0.00,	0.00,	{ 90.00, 40.00, 00.00, 1.0 },	USE_REUSABLE,	true,	#Wear		},
	{	"Очки",						"Добавят вам стиля и защитят от солнечных лучей",		TH_TYPE_ACSR,		0,		1,		19006,	0.00,	0.00,	{ 340.0, 00.00, 70.00, 0.8 },	USE_REUSABLE,	true,	#Wear		},
	{	"Бандана",					"Позволяет скрыть ваше лицо и остаться неузнанным",		TH_TYPE_ACSR,		0,		1,		18911,	0.00,	0.00,	{ 230.0, 00.00, 300.0, 0.9 },	USE_REUSABLE,	true,	#Wear		},
	{	"Мото-шлем",				"Спасет вам жизнь в случае аварии",						TH_TYPE_ACSR,		0,		1,		18645,	0.00,	0.00,	{ 00.00, 00.00, 40.00, 0.8 },	USE_REUSABLE,	true,	#Wear		},
	{	"Панама",					"Защитит вас от солнечного удара и добавит стиля",		TH_TYPE_ACSR,		0,		1,		19107,	0.00,	-90.0,	{ 00.00, 270.0, 60.00, 0.8 },	USE_REUSABLE,	true,	#Wear		},
	
//	Предметы в которые можно положить другие предметы
	{	"Коробка",					"Текст",												TH_TYPE_IN_HAND,	10,		1,		1271,	0.27,	0.00,	{ -25.0, 10.00, -55.0, 1.2 },	USE_REUSABLE,	true,	#Box		},
	{	"Ящик",						"Текст",												TH_TYPE_IN_HAND,	10,		1,		3052,	0.12,	0.00,	{ 330.0, 00.00, 320.0, 0.8 },	USE_REUSABLE,	true,	#Box2		},
	{	"Кейс",						"Текст",												TH_TYPE_IN_HAND,	100,	1,		1210,	0.10,	0.00,	{ 00.00, 00.00, 00.00, 1.0 },	USE_REUSABLE,	true,	#Suitcase	},	
	{	"Чемодан",					"Текст",												TH_TYPE_IN_HAND,	150,	1,		19624,	0.40,	0.00,	{ 00.00, 00.00, 00.00, 1.0 },	USE_REUSABLE,	true,	#Suitcase2	},
	{	"Сумка",					"Текст",												TH_TYPE_IN_HAND,	100,	1,		11745,	0.12,	0.00,	{ 00.00, 00.00, 00.00, 1.0 },	USE_REUSABLE,	true,	#Bag		},
	{	"Рюкзак",					"Текст",												TH_TYPE_IN_HAND,	100,	1,		19559,	0.00,	-90.0,	{ 00.00, 00.00, 00.00, 1.0 },	USE_REUSABLE,	true,	#Bag2		},
	{	"Мусорный пакет",			"Текст",												TH_TYPE_IN_HAND,	0,		1,		1265,	0.40,	0.00,	{ 00.00, 00.00, 00.00, 1.0 },	USE_REUSABLE,	true,	#Trash		}

	/*{	"Каска (красная)",			2,	0.10,	19117,	USE_REUSABLE,	true,	"WearPlayerHat"	},
	{	"Каска (зеленая)",			2,	0.10,	19118,	USE_REUSABLE,	true,	"WearPlayerHat"	},
	{	"Каска (синия)",			2,	0.10,	19119,	USE_REUSABLE,	true,	"WearPlayerHat"	},
	{	"Каска (желтая)",			2,	0.10,	19120,	USE_REUSABLE,	true,	"WearPlayerHat"	},
	{	"Шапка (черная)",			2,	0.10,	18953,	USE_REUSABLE,	true,	"WearPlayerHat"	},
	{	"Шапка (светлая)",			2,	0.10,	18954,	USE_REUSABLE,	true,	"WearPlayerHat"	},
	{	"Строительная каска",		2,	0.10,	18638,	USE_REUSABLE,	true,	"WearPlayerHat"	},*/
		//	в другую категорию
	//{	"Панама (оранжевая)",		2,	0.10,	18967,	USE_REUSABLE,	true,	"WearPlayerHat"	},
	//{	"Панама (черная)",			2,	0.10,	18968,	USE_REUSABLE,	true,	"WearPlayerHat"	},
	//{	"Панама (клетчатая)",		2,	0.10,	18969,	USE_REUSABLE,	true,	"WearPlayerHat"	},
};

new playerNearThings[MAX_PLAYERS][32];