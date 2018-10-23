#if defined CORE_GLOBAL_SCOPE_INCLUDED
	#endinput
#endif
#define CORE_GLOBAL_SCOPE_INCLUDED

#define MAX_BUSINESSES  		50		// Количество бизнесов
#define MISSION_SOURCE			1		// Источники миссий

//  Спорт зал
#define MAX_TRAINING			10  	//  Макс. упражнений за тренировку (между зарплатами)
// Донат экономика
#define MoneyForCoin    		50      // Сколько долларов за одну монету
#define CoinForUpgrade  		100     // Сколько монет за одно очко апгрейда
#define CoinForLaw				2 		// Сколько монет за единицу законопослушности
#define CoinForShooting 		50 		// Стоимость пропуска прохождения тира
#define CoinForVIP 				50 		// Стоимость премиума на неделю
// Экономика
#define START_MONEY				100		// Начальные деньги игрока
#define PRICE_AUTOSCHOOL		300		// Стоимость автошколы
#define BENEFIT					50.0	// Пособие по безработице
#define PRODUCTS_PRICE			5.0		// Цена для закупки товара доставщиками
#define BIZ_SPRODS_PRICE		12.0	// Цена для закупки единицы продуктов в бизнесе
#define PROFIT_TAX				0.15    // Налог на прибыль (проц)
#define TAX_BIZ  	 			1000	// Налог на бизнес (сутки)
//#define PRICE_GUNLIC			500		// Стоимость разрешения на оружие
#define PRICE_FUEL      		1.2     // Стоимость литра бензина
#define PRICE_LOADBOX   		3		// Стоимость одного ящика в подработке грузчиком
#define PRICE_BUSSTOP   		1.5		// Зарплата водителя автобуса за каждый чекпоинт
#define PRICE_DRUG      		100     // Стоимость наркотиков (за 1 грамм)
#define ROBBERING_BANK			150		// Количество денег на одного участника ограбления
#define COST_PER_WANTED			22      // Награда за одну звезду розыска менту
#define FINE_PER_WANTED			90      // Штраф за одну звезду розыска нарушителю
#define TIME_PER_WANTED         5		// Минут за розыск (умножается от 1 до 6)
#define PICKLOCK_PRICE          25      // Стоимость отмычки
#define HOTEL_COST				50		// Стоимость самого дешевого отеля (за день)
#define SENDAD_PRICE            50      // Стоимость отправки объявления в /ad
// Бизнесы
#define BIZ_NAME_SIZE			32		//	Длинна названия бизнесов
#define BIZ_ROBB_RELOAD 		900		//	Время ограничения ограблений бизнеса (15 минут)
#define BIZ_MAX_DEBT			-10000	//	Максимальная сумма долга
// Преступность
#define RESCUE_TIME     		15      // Время восстановления (мин)
// Пикапы
#define PICKUPID_SBIZ 			1272	// ид пикапа продаваемого бизнеса (19470)
#define PICKUPID_BBIZ 			19607	// ид пикапа купленного бизнеса
#define PICKUPID_ENTRY 			19197	// ид пикапа входа/выхода (старые: 19135)
#define PICKUPID_ENTRY2			1559
// Остальное
#define WH_GUN_MAX 				9
#define VEH_SPAWNTIME			900		// Стандартное время спавна машин (сек) (900 сек = 15 мин)
#define LEVEL_EXP       		400		// Опыт для получения 2го уровня
#define CONSUM_FUEL				0.8		// Расход топлива л/km (посл: 1.25) 		Было:	2.0
#define CONSUM_ENGINE			0.0012	// Расход заведенного двигателя (л/сек)		Было:	0.002
#define BREAK_CAR_GLASS_TIME    500
#define BREAK_CAR_CODE_LEN      6
#define MAX_CODE_SIZE   		32      // Максимальный размер кодов бонусов
#define AS_TIMER_UPDATE 		200     // Частота обновления таймера автошколы
#define UPDATERATE 				100     // Частота обновления цветного эффекта экрана (fader)
#define DAMAGE_COEFFICIENT  	0.5 	// Коеффициент расчета урона
#define AFK_TIME        		5
#define MAX_ABSENCE_TIME 		15		// Максимальное время вне игры без потерь (мин)
#define TIR_MODIFY_POS			0.05
#define MAX_ADVERT_COUNT		20		//	Максимум объявлений в очереди
#define TASKS_COUNT				5		//	Начальные задания игрока
#define MAX_ASK_COUNT			100
#define ROPE_LENGTH				50

#define SuccesAnim(%0) 							ApplyAnimation(%0, "CRIB", "PED_Console_Win", 4.1, 0, 0, 0, 0, 2500, 1)
#define LoseAnim(%0)                        	ApplyAnimation(%0, "OTB", "wtchrace_lose", 4.1, 0, 0, 0, 0, 0, 1)
#define GetPlayerWantedLevel(%0)				PlayerInfo[%0][pWantedLvl]
#define IsPlayerDead(%0)                    	(GetPlayerState(%0) == PLAYER_STATE_WASTED ? true : false)
#define IsPlayerLive(%0)                    	(PLAYER_STATE_ONFOOT <= GetPlayerState(%0) <= PLAYER_STATE_ENTER_VEHICLE_PASSENGER)
#define MyGetPlayerMoney(%0)					PlayerInfo[%0][pMoney]
#define CriminalMarked[%0]						IsValidDynamicMapIcon(CriminalMarkers[%0])
#define MyGetPlayerDialog(%0)					Dialogid[%0]
#define GetPlayerRank(%0) 						GetRankName(PlayerInfo[%0][pFaction], PlayerInfo[%0][pRank])
#define NextLvlExp(%0)                      	(LEVEL_EXP * (%0 - 1))
#define getNextLevelExp(%0)                 	NextLvlExp(PlayerInfo[%0][pLevel] + 1)         
#define GetPlayerAdminStatus(%0) 				getAdminStatus(PlayerInfo[%0][pAdmin]) 

//	Префиксы сообщений
#define PREFIX_ADMIN			SCOLOR_LIGHTRED	"[Adm] {FFFFFF}"
#define PREFIX_PROTECT			SCOLOR_PROTECT	"[Wrn] "
#define PREFIX_ERROR			SCOLOR_ERROR	"Ошибка | {FFFFFF}"
#define PREFIX_HINT				SCOLOR_HINT		"Подсказка | {FFFFFF}"
#define PREFIX_PHONE			SCOLOR_PHONE	"Телефон | {FFFFFF}"
#define PREFIX_GAME				SCOLOR_GAME		"Игра | {FFFFFF}"
#define PREFIX_GPS				SCOLOR_GPS		"GPS | {FFFFFF}"
#define PREFIX_DONATE			SCOLOR_GREEN	"Донат | {FFFFFF}"
#define PREFIX_WARNING			SCOLOR_WARNING	"Предупреждение | {FFFFFF}"
#define ASK_CONFIRM_INFO 		"{FFFFFF}(нажмите {9ACD32}Пробел + Y {FFFFFF}или {FF6347}Пробел + N{FFFFFF})"
#define ACTION_TEXT				"Нажмите Enter для взаимодействия"

new MySQL:g_SQL = MYSQL_INVALID_HANDLE;	//	MySQL connection handle
new StartUNIXTime;

//	Enums
enum (<<=1)
{
	CMD_HELPER = 1,
	CMD_IVENTER,
	CMD_MODER,
	CMD_ADMIN,
	CMD_GADMIN,
	CMD_DEVELOPER,
	CMD_RCON,
}

enum
{
	SM_DRINK,
	SM_CLOTHE,
}

enum
{
	SELECTER_CLOTHE_SHOP,
}

enum 	//	Типы объектов
{
	OBJECT_TYPE_THROW		= 1,		//	Выброшенные вещи
	OBJECT_TYPE_TRASHCAN,				//	Мусорки
}

enum
{
	DMODE_NONE,
	DMODE_RUSIK,
	DMODE_EMAIL,
	DMODE_NEWBIE,
	DMODE_NEWBIE2,
	DMODE_ADMINS,
	DMODE_ANIMLIST,
	DMODE_LAWYER,
	DMODE_POLICE_HQ,
    DMODE_POLICE_MISSION,
    DMODE_POLICE_DUTY,
    DMODE_POLICE_WANTED,
    DMODE_POLICE_STOPMENU,
	DMODE_SHOP,
	DMODE_SEXSHOP,
	DMODE_HOUSE,
	DMODE_HOUSE_SELL,
	DMODE_RADIO,
	DMODE_RADIO_PLEER,
	DMODE_VMENU,
	DMODE_REFILL,
	DMODE_REFILL2,
	DMODE_VFIND,
	DMODE_GOTOLIST,
	DMODE_REPAIR,
	DMODE_TUNING,
	DMODE_CARPLATE,
	DMODE_JOBLIST,
	DMODE_GAS,
	DMODE_GAS_REFILL,
	DMODE_GAS_RULES,
	DMODE_AUTOSCHOOL,
	DMODE_BUYELEMENT,
	DMODE_REACTION,
	DMODE_PAY_SUMM,
	DMODE_BONUS_LIST,
	DMODE_HOTEL,
	DMODE_EX_HOTEL,
	DMODE_ATM,
	DMODE_BANK,
	DMODE_BANK_ACTION,
	DMODE_BANK_TAKE,
	DMODE_BANK_GIVE,
	DMODE_PROPERTY_PAY,
	DMODE_FINEPARK,
	DMODE_SHOOTING,
	DMODE_SHOOTING_INFO,
	DMODE_GPS,
	DMODE_GPS_MAIN,
	DMODE_GPS_VEH,
	DMODE_GPS_PART,
	DMODE_GPS_OFFJOB,
	DMODE_GPS_JOB,
	DMODE_GPS_SHOPS,
	DMODE_GPS_REST,
	DMODE_GPS_BIZ,
	DMODE_GUNDEL,
	DMODE_SENDAD,
	DMODE_ADLIST,
	DMODE_ADMENU,
	DMODE_ADEDIT,
	DMODE_GIVERANK,
	DMODE_RENTCAR,
	DMODE_EXTEND_RENTCAR,
	DMODE_DRUGSTORE,
	DMODE_MAKELEADER,
	DMODE_CHOOSEGANG,
	DMODE_OFFLINE_MESSAGE,
	DMODE_HOSPITAL,
	DMODE_BOXINFO,
	DMODE_FSTYLE,
	//	admin
	DADMIN_TICKETS,
	DADMIN_TICKET_MENU,
	DADMIN_TICKET_ANS,
	//  server
	DSERV_MAIN,
	DSERV_STATS,
	DSERV_ADMINS,
	DSERV_ADMINS_ACTION,
	DSERV_LEADERS,
	DSERV_LEADERS_ACTION,
	//  faction
	DFACT_MEMBERS,
	DFACT_MEMBERS_ACTION,
	//	mission
	DMIS_TRAINING1,
	DMIS_TRAINING2,
	// warehouses
	DWAREHOUSE_MAIN, // Содержимое склада
	DWAREHOUSE_TAKE, // Выбор количества "забрать"
	DWAREHOUSE_INV,  // Содержимое инвентаря (которое можно положить)
	DWAREHOUSE_GIVE, // Выбор количества "положить"
	//	job
	DJOB_GUNDEAL_MATS,
	DJOB_GUNDEAL_GUN,
	DJOB_DRUGDEAL_MATS,
	DJOB_FARM_INFO,
	DJOB_MECHANIC,
	//  menu
	DMENU_MAIN,
	DMENU_TASKS,
	DMENU_TASKS_INFO,
	DMENU_STATS,
	DMENU_LEVELING,
	DMENU_SKILL,
	DMENU_WEAPON_SKILL,
	DMENU_ADVANCE,
	DMENU_DONATE,
	DMENU_HOWGETCOIN,
	DMENU_COINTOVIP,
	DMENU_COINTOMONEY,
	DMENU_COINTOUPGRADE,
	DMENU_COINTOLAW,
	DMENU_SETTING,
	DMENU_FSTYLE,
	DMENU_PROTECTION,
	DMENU_CHANGE_ANIM,
	DMENU_CHANGE_SPAWN,
	DMENU_CHANGE_PASS,
	DMENU_BONUS,
	DMENU_CONTACT,
	//	biz
	DBIZ_MAIN,
	DBIZ_MANAGE,
	DBIZ_CHANGE_NAME,
	DBIZ_ENTER_PRICE,
	DBIZ_SELL,
	//  home
	DHOME_MAIN,
	DHOME_ACC_REGISTER,
	DHOME_FURNITURE,
	DHOME_BUY_FUR_SLOT,
	DHOME_FUR_ACCEPT_DEL,
	DHOME_RENT,
	DHOME_RENT_MOVEOUT,
	DHOME_RENT_CHANGE,
	DHOME_TAKE_RENT,
	DHOME_CANCEL_RENT,
	//  npcs
	DNPC_EMMET, // Используется в (DMODE_GUNDEL)
	// races
	DRACE_JOIN,
	DRACE_MAIN,
	DRACE_LIST,
	DRACE_EDIT,
	DRACE_EDIT_PARAMS,
	DRACE_EDIT_WRITE,
	DRACE_DELCP,
	DRACE_DELETE,
	//	casino
	DPOKER_GAMESETUP,
	DPOKER_GAMESETUP2,
	DPOKER_GAMESETUP3,
	DPOKER_GAMESETUP4,
	DPOKER_GAMESETUP5,
	DPOKER_GAMESETUP6,
	DPOKER_GAMESETUP7,
	DPOKER_GAMESBUY,
	DPOKER_GAMESCALL,
	DPOKER_GAMESRAISE,
	//	chips
	DCHIPS_MENU,
	DCHIPS_BUY,
	DCHIPS_SELL,
}

// Checkpoints
new CP_AUTOSCHOOL,
	CP_BANK,
	CP_SEXSHOP,
	CP_MOTEL,
	CP_SHOOTING,
	CP_EXIT_TIR,
	CP_DRUGSTORE,
	CP_GUNDEAL;

enum
{
	CPMODE_NONE,
	CPMODE_MISSION,
	CPJOB_TRUCKER,
	CPJOB_LOADER,
	CPJOB_AUTOTHEFT,
	CPPOLICE_MISSION,
	CPPOLICE_ROPE,
}

enum
{
	EVENT_NONE,
	EVENT_ADMIN,
	EVENT_RACE,
}

// Аттач (slot 0 - 9)
enum
{
	ATTACH_SLOT_IN_HAND = 0,	//	{ 0, 1 }		Номер слота для аттача объекта в руках
	//ATTACH_SLOT_CASE 	= 2,	//	{ 2 }			Номер слота для аттача чемодана в руки (с деньгами например)
	ATTACH_SLOT_WEAPON 	= 3,	//	{ 3, 4, 5 }		Номер слота для оружия (+4 следующих тоже под оружие) (вип игроки)
	ATTACH_TRY_ACSR		= 5,	//	{ 5 }			Номер слота для примерки аксессуаров в магазине			
	ATTACH_SLOT_CLOTHE 	= 6,	//	{ 6, 7, 8, 9 }	Номер слота для аттача одежды
}

enum
{
	OBJECT_WEAPON,
}

enum
{
	ADMIN_NONE,
	ADMIN_HELPER,
	ADMIN_IVENTER,
	ADMIN_MODER,
	ADMIN_ADMIN,
	ADMIN_GADMIN,
	ADMIN_DEVELOPER,
	ADMIN_RCON,
};

enum
{
	SPAWN_NEWBIE,
	SPAWN_FACTION,
	SPAWN_HOUSE
}

//----------
enum E_ANIMLIST
{
	ANIM_TITLE[32],
	ANIM_LIB[20],
	ANIM_NAME[32],
	Float:ANIM_DELTA, //
	ANIM_LOOP,  	  // Зацикливание
	ANIM_LOCKX,       //
	ANIM_LOCKY,       //
	ANIM_FREEZE,      //
	ANIM_TIME,        //
	ANIM_SYNC,        //
};

new const AnimList[][E_ANIMLIST] =
{// ApplyAnimation(playerid, lib, name, fDelta, loop, lockx, locky, freeze, time, forcesync);
	{ "Поднять руки",		"PED","handsup",			4.1, 0, 1, 1, 1, 1, 1 },
	{ "Танцевать",			"DANCING","DAN_Loop_A",		4.1, 1, 1, 1, 1, 1, 1 },
	{ "Плакать",			"GRAVEYARD","mrnF_loop",	4.1, 0, 1, 1, 1, 1, 1 },
	{ "Смеяться",			"RAPPING","Laugh_01", 		4.0, 0, 0, 0, 0, 0, 1 },
	{ "Распластаться",		"PED","FLOOR_hit_f",		4.1, 0, 1, 1, 1, 1, 1 },
	{ "Помахать рукой",		"ON_LOOKERS","wave_loop",	4.0, 1, 0, 0, 0, 0, 1 },
	{ "Отказаться",			"PED","endchat_02",			4.1, 0, 1, 1, 1, 1, 1 },
	{ "Совершить сделку",	"DEALER","DEALER_DEAL", 	4.0, 0, 0, 0, 0, 0, 1 },
	{ "Лежа умирать",		"CRACK","crckdeth2", 		4.0, 1, 0, 0, 0, 0, 1 },
	{ "Сесть на пол",		"BEACH","ParkSit_M_loop", 	4.0, 1, 0, 0, 0, 0, 1 },
	{ "Сказать что-то",		"PED","IDLE_CHAT",			4.0, 0, 0, 0, 0, 0, 1 },
	{ "Средний палец",		"PED","fucku",				4.0, 0, 0, 0, 0, 0, 1 },
	{ "Болеть за команду",	"RIOT","RIOT_PUNCHES",		4.1, 0, 1, 1, 1, 1, 1 },
	{ "Зачитать рэп",		"RAPPING","RAP_B_Loop",		4.1, 0, 1, 1, 1, 1, 1 },
	{ "Пьяная походка",		"PED","WALK_DRUNK",			4.0, 1, 1, 1, 1, 0, 1 },
	{ "Заложить бомбу",		"BOMBER","BOM_Plant", 		4.0, 0, 0, 0, 0, 0, 1 },
	{ "Арестовать",			"PED","ARRESTgun", 			4.0, 0, 1, 1, 1, 0, 1 },
	{ "Осмотреться",		"SHOP","ROB_Shifty", 		4.0, 0, 0, 0, 0, 0, 1 },
	{ "Направить оружие",	"SHOP","ROB_Loop_Threat", 	4.0, 1, 0, 0, 0, 0, 1 },
	{ "Сложить руки",		"COP_AMBIENT","Coplook_loop", 4.0, 0, 1, 1, 1, 0, 1 },
	{ "Прилечь",			"BEACH","bather", 			4.0, 1, 0, 0, 0, 0, 1 },
	{ "Прикрыть голову",	"PED","cower", 				3.0, 1, 0, 0, 0, 0, 1 },
	{ "Скушать что-то",		"FOOD","EAT_Burger",		3.0, 0, 0, 0, 0, 0, 1 },
	{ "Блевать",			"FOOD","EAT_Vomit_P", 		3.0, 0, 0, 0, 0, 0, 1 },
	{ "Реанимировать",		"MEDIC","CPR",				4.1, 0, 1, 1, 1, 1, 1 }
};

enum E_PANIM
{
	PANIM_TITLE[24],
	PANIM_LIB[20],
	PANIM_NAME[32],
}

new const PlayerAnims[][E_PANIM] =
{
	{ "Без анимации",		"",	"" },
	{ "Танцевать",			"DANCING","DAN_Loop_A" },
	{ "Плакать",			"GRAVEYARD","mrnF_loop" },
	{ "Смеяться",			"RAPPING","Laugh_01" },
	{ "Распластаться",		"PED","FLOOR_hit_f" },
	{ "Помахать рукой",		"ON_LOOKERS","wave_loop" },
	{ "Отказаться",			"PED","endchat_02" },
	{ "Совершить сделку",	"DEALER","DEALER_DEAL" },
	{ "Средний палец",		"PED","fucku" },
	{ "Болеть за команду",	"RIOT","RIOT_PUNCHES" },
	{ "Зачитать рэп",		"RAPPING","RAP_B_Loop" },
	{ "Направить оружие",	"SHOP","ROB_Loop_Threat" },
	{ "Сложить руки",		"COP_AMBIENT","Coplook_loop" },
	{ "Блевать",			"FOOD","EAT_Vomit_P" }
};

//	---
new const InfoText[][] =
{
	"Для просмотра доступных команд введите /help",
	"Пожалуйста, сообщайте администрации о найденых багах",
	"Вы всегда можете заработать копеечку на подработке",
	"Во время горения машины потушите пламя, зажав ЛКМ или Л.Альт",
	"Используйте /unlock [playerid], чтобы открыть машину для игрока",
	"Выкинуть игрока из машины или скинуть его с крыши можно командой /eject",
	//"Введите * (звездочку) в начале сообщения, чтобы писать в общий чат",
	"Мы всегда готовы ответить на ваши вопросы, используйте команду /ask",
	"Мы хотим, чтобы ваша игра была комфортна. Задавайте вопросы на /ask",
	"Для взаимодействия с ~n~игроками или ботами прицельтесь на них и нажмите H",
	"В меню настроек вы можете выбрать свою личную анимацию (/mm > Настройки)",
	"Ознакомиться с возможностями доната можно тут (/mm > Доп.возможности)",
	"Ознакомиться с возможностями доната можно тут (/mm > Доп.возможности)"
};
new lastinfotext = -1;

// Binco - гетто магазин
new const Binco_Skin[] = { 28, 29, 30, 207 };
// DS - премиум магазин и там есть все скины из сингла (герои)
new const DS_Skin[] = { 1, 2, 3, 4, 5, 6, 8, 65, 119, 273, 289, 268, 195, 190, 191, 192, 193, 194, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299 };
// Prolaps - спортивный магазин
new const Prolaps_Skin[] = { 26, 51, 52, 80, 81, 23, 90, 92, 96, 99, 49, 203, 204 };
// Suburban - уличный стиль
new const Suburban_Skin[] = { 13, 19, 21, 22, 23, 24, 25, 66, 67, 73, 100, 247, 248, 254, 101, 142, 143, 144, 180, 182, 183, 220, 241, 242, 261, 262, 121 };
// Zip - магазин престижных дорогих пиджаков и костюмов
new const ZIP_Skin[] = { 9, 11, 12, 40, 91, 141, 148, 150, 163, 169, 171, 172, 186, 189, 216, 219, 240, 249 };
// Victim - обычные скины
new const Victim_Skin[] = { 14, 20, 35, 36, 37, 38, 39, 41, 43, 44, 47, 48, 53, 54, 55, 56, 58, 60, 69,  72, 88, 89, 93, 94, 95, 123, 121, 151, 170, 184, 185, 210, 211, 215, 217, 221, 222, 224, 225, 226, 229, 231, 232, 233, 234, 235, 236, 250, 258, 259, 261, 263 };
// Fort Carson - деревенские скины
new const FC_Skin[] = { 58, 72, 73, 128, 131, 133, 151, 157, 158, 161, 198, 201, 202, 206, 261 };
// Скины новичков
new const Newbie_Skin_Male[]	= { 78, 134, 136, 137, 212, 230 };
new const Newbie_Skin_Female[]	= { 75, 77, 10, 39, 54, 130 };


new const AmmuList[] = { 31, 30, 33, 27, 23, 24, 26, 29, 25, 34, 99 };

new const EmmetAmmuList[6][3] =
{
	{23, 24, 0},	// Пистолеты
	{29, 0, 0},		// Полуавтоматы
	{25, 26, 27},	// Дробовики
	{99, 0,  0},	// Броня
	{30, 31, 0},	// Автоматы
	{33, 34, 0}		// Винтовки
};

new const Smiles[][][] =
{
	{":)", "улыбается во весь рот."},
	{":D", "смеется до слез."},
	{":(", "распускает нюни."},
	{":/", "презрительно ухмыляется."},
	{":о", "вытаращивает глаза."},//rus
	{":o", "вытягивает физиономию."},//eng
	{":О", "вытаращивает глаза."},//rus
	{":O", "вытягивает физиономию."},//eng
	{":Р", "показывает свой язык."},//rus
	{":P", "показывает свой язык."},//eng
	{":С", "прибывает в унынии."},//rus
	{":C", "прибывает в унынии."},//eng
	{":]", "краснеет до ушей."},
	{":*", "осыпает поцелуями."},
	{":!", "извергает рвоту."},
	{":`", "захлебывается слезами."}
};

new const LongWords[][] =
{
	{"Водогрязеторфопарафинолечение"},
    {"Фиброэзофагогастродуоденоскопия"},		// Медицинская диагностическая процедура
    {"Тифлосурдоолигофренопедагогика"},			// Педагогический термин
    {"Рентгеноэлектрокардиографического"},
    {"Превысокомногорассмотрительствующий"},
    {"Четырёхсотпятидесятисемимиллиметровое"},
    {"Прыжок с переподвыподвертом"}
};

new CurrentPlayerRecords = 0;

new const Float:paynspray[][] =
{
	{1025.05, -1024.23, 32.1}, // LS Temple
	{487.68, -1740.87, 11.13}, // LS Santa Maria
    {-1420.73, 2583.37, 55.56}, // El Quebrados
    {-1904.39, 284.97, 40.75}, // Wang Cars
    {-2425.91, 1022.33, 50.10}, // Juniper Hill
    {1975.60, 2162.16, 10.77}, // LV Redsands
    {2065.38, -1831.51, 13.25}, // Idlewood
    {-99.55, 1118.36, 19.44}, // Fort Carson
    {721.07, -455.94, 16.04}, // Dillimore
    {2393.74, 1493.01, 10.52} // LV Unused (Pyramid)
};

//	Работа - 10 минут; Столовая - 4 минуты; Прогулка - 15 минут; Отбой - 1 минута
new const JailPeriod[] = {	600,	240,	900,	60	};
new LastPrisonStatus = 1, PrisonStatusTime,
	PrisonersTP_Timer;

new const Float:PeriodPos[][] =
{
	{540.0750, -2709.3696, 13.2537, 360.0},// Работа
	{540.0750, -2709.3696, 13.2537, 360.0},// Столовая
	{540.2695, -2751.7681, 13.1566, 180.0},// Прогулка
	{554.3091, -2731.3972, 13.1566, 270.0} // Отбой
};
new const Float:JailDoorsPos[][3] =
{
	{ 701.789, -2939.409, 1702.06 },
	{ 701.770, -2944.139, 1702.06 },
	{ 701.840, -2948.870, 1702.06 },
	{ 701.940, -2953.639, 1702.06 },
	{ 701.940, -2958.290, 1702.06 },
	{ 701.909, -2963.060, 1702.06 },
	{ 701.950, -2967.820, 1702.06 },
	{ 701.950, -2967.820, 1705.50 },
	{ 701.929, -2963.080, 1705.50 },
	{ 701.919, -2958.310, 1705.50 },
	{ 701.909, -2953.639, 1705.50 },
	{ 701.830, -2948.850, 1705.50 },
	{ 701.780, -2944.139, 1705.50 },
	{ 701.770, -2939.399, 1705.50 },
	{ 717.900, -2939.159, 1705.50 },
	{ 717.900, -2943.899, 1705.50 },
	{ 717.979, -2948.659, 1705.50 },
	{ 718.010, -2953.409, 1705.50 },
	{ 718.070, -2958.149, 1705.50 },
	{ 718.049, -2962.870, 1705.50 },
	{ 718.099, -2967.659, 1705.50 },
	{ 718.099, -2967.659, 1702.04 },
	{ 718.049, -2962.899, 1702.04 },
	{ 718.049, -2958.159, 1702.04 },
	{ 718.039, -2953.389, 1702.04 },
	{ 717.969, -2948.649, 1702.04 },
	{ 717.890, -2943.899, 1702.04 },
	{ 717.900, -2939.179, 1702.04 }
};
new JailDoors[ sizeof JailDoorsPos ];

new const Float:JailPos[][4] =
{
	{ 721.0, -2969.4, 1700.4, 90.0 },
	{ 721.0, -2964.6, 1700.4, 90.0 },
	{ 721.0, -2959.6, 1700.4, 90.0 },
	{ 721.0, -2954.9, 1700.4, 90.0 },
	{ 721.0, -2950.3, 1700.4, 90.0 },
	{ 721.0, -2945.5, 1700.4, 90.0 },
	{ 721.0, -2940.8, 1700.4, 90.0 },
	{ 721.0, -2940.8, 1703.9, 90.0 },
	{ 721.0, -2945.5, 1703.9, 90.0 },
	{ 721.0, -2950.3, 1703.9, 90.0 },
	{ 721.0, -2954.9, 1703.9, 90.0 },
	{ 721.0, -2959.6, 1703.9, 90.0 },
	{ 721.0, -2964.6, 1703.9, 90.0 },
	{ 721.0, -2969.4, 1703.9, 90.0 },
	{ 699.3, -2968.0, 1703.9, 270.0 },
	{ 699.3, -2963.4, 1703.9, 270.0 },
	{ 699.3, -2958.8, 1703.9, 270.0 },
	{ 699.3, -2954.2, 1703.9, 270.0 },
	{ 699.3, -2949.0, 1703.9, 270.0 },
    { 699.3, -2944.4, 1703.9, 270.0 },
    { 699.3, -2939.8, 1703.9, 270.0 },
    { 699.3, -2939.8, 1700.4, 270.0 },
    { 699.3, -2944.4, 1700.4, 270.0 },
    { 699.3, -2949.0, 1700.4, 270.0 },
    { 699.3, -2954.2, 1700.4, 270.0 },
    { 699.3, -2958.8, 1700.4, 270.0 },
    { 699.3, -2963.4, 1700.4, 270.0 },
    { 699.3, -2968.0, 1700.4, 270.0 }
};

//  Работа на зоне
	//  Завод
new const Float:j_fMatPos[][3] =
{  //  12 точек
    { 2558.2, -1302.6, 1043.8 },	{ 2560.1, -1302.5, 1043.8 },	{ 2558.2, -1304.5, 1043.8 },
	{ 2560.1, -1304.5, 1043.8 },	{ 2552.1, -1302.5, 1043.8 },	{ 2550.2, -1302.6, 1043.8 },
	{ 2552.1, -1304.5, 1043.8 },	{ 2550.2, -1304.5, 1043.8 },	{ 2544.1, -1302.3, 1043.8 },
	{ 2542.1, -1302.6, 1043.8 },	{ 2544.0, -1304.5, 1043.8 },	{ 2542.1, -1304.5, 1043.8 }
};

new const Float:j_fJobPos[][4] =
{  //  10 точек
	{ 2542.1, -1295.8, 1044.1, 0.0 },
	{ 2544.4, -1295.8, 1044.1, 0.0 },
	{ 2553.8, -1295.8, 1044.1, 0.0 },
	{ 2556.2, -1295.8, 1044.1, 0.0 },
	{ 2558.5, -1295.8, 1044.1, 0.0 },

	{ 2558.4, -1291.0, 1044.1, 180.0 },
	{ 2556.1, -1291.0, 1044.1, 180.0 },
	{ 2553.7, -1291.0, 1044.1, 180.0 },
	{ 2544.2, -1291.0, 1044.1, 180.0 },
	{ 2541.8, -1291.0, 1044.1, 180.0 }
};

//  =======
enum G_INFO
{
	G_NAME[24],
	Float:G_X,
	Float:G_Y,
	Float:G_Z,
	Float:G_A
};

new const GotoList[][G_INFO] =
{
	{"LS Police Dept.",		1539.5029,-1690.2836,13.5469,360.0},
	{"LS Ocean Docs",		2182.2432,-2299.0046,13.5469,45.0},
	{"LS Grove st.",		2494.3818,-1664.5542,13.3438,90.0},
	{"LS SpawnAirport",		1724.9930,-2302.8130,13.2667,180.0},
	{"LS Jefferson",		2263.2463,-1161.4094,26.283,360.0},
	{"LS Autoschool",		675.5267,-1413.3010,13.5683,270.0},
	{"LS Stadion",			2702.9829,-1671.7976,9.5074,180.0},
	{"The Central Farm",	-1033.3416,-1163.5620,129.2126,90.0},
	{"SF AutoSchool", 		-2080.2788,-76.7549,35.0826,270.0},
	{"LV 4 Dragons",		2032.4054,1019.9095,10.8203,180.0},
	{"Fort Carson",			-165.6477,1226.2340,19.7422,180.0},
	{"Alcatraz (Prison)",	671.7111,-2743.6487,2.2656,90.0}
};

enum eRadio
{
	RADIO_NAME[24],
	RADIO_URL[64]
};
new const RadioList[][eRadio] =
{// UPD 28/01/15. Можно добавить '.m3u' в конец ссылки
	{"Radio Record",		"http://air.radiorecord.ru:8101/rr_320"},
	{"Disco 90х",			"http://air.radiorecord.ru:8102/sd90_320"},
	{"Trancemission",		"http://air.radiorecord.ru:8102/tm_320"},
	{"Russian Mix",			"http://air.radiorecord.ru:8102/rus_320"},
	{"Medlyak FM",			"http://air.radiorecord.ru:8102/mdl_320"},
	{"Record Chill-Out",	"http://air.radiorecord.ru:8102/chil_320"},
	//{"Record Club",		"http://air.radiorecord.ru:8102/club_320"},// not work
	{"Gop FM",				"http://air.radiorecord.ru:8102/gop_320"},
	{"Vip Mix",				"http://air.radiorecord.ru:8102/vip_320"},
	{"Pirate Station",		"http://air.radiorecord.ru:8102/ps_320"},
	{"Record Deep",			"http://air.radiorecord.ru:8102/deep_320"},
	{"Record Breaks",		"http://air.radiorecord.ru:8102/brks_320"},
	{"Record Dancecore",	"http://air.radiorecord.ru:8102/dc_320"},
	{"Record Dubstep",		"http://air.radiorecord.ru:8102/dub_320"},
	{"Record Trap",			"http://air.radiorecord.ru:8102/trap_320"},
	{"Record Hardstyle",	"http://air.radiorecord.ru:8102/teo_320"},
	{"Rock Radio",			"http://air.radiorecord.ru:8102/rock_320"},
	{"Pump'n'Klubb",		"http://air.radiorecord.ru:8102/pump_320"}
};

new const Float:AutoShowPos[][4] =
{
	{	2131.613, -1149.12, 24.30, 185.56 },
	{	541.5977, -1292.09, 17.24, 164.49 },
	{	-1961.03, 289.8271, 35.45, 154.92 },
	{	-1649.95, 1210.372, 7.250, 184.51 }
};

new const Float:AutoRepairPos[][4] =
{
	{   -125.5800, 1013.9900, 20.1800 },	// Fort Carson
	{   971.6804, -1525.5406, 13.5599 },	// Los Santos
	{   -2052.6096, 145.5321, 28.8359 },	// San Fierro
	{   1091.6481, 2370.9287, 10.8203 }		// Las Venturas
};

//	--- банкоматы
new const Float:ATM[][6] =
{
	{ 1928.6, -1770.7, 13.4, 0.0, 0.0, 182.0 	},  // Заправка в опасном районе
	{ 1496.5, -1749.8, 15.3, 0.0, 0.0, 270.0 	},  // Мэрия Лос Сантос
	{ 1367.2, -1290.5, 13.4, 0.0, 0.0, 0.0 		},  // Лос Сантос Аммунация (центральная)
	{ -167.5, 1188.8, 19.6, 0.0, 0.0, 270.0 	},  // Форт Карсон
	{ -2035.4, -101.9, 35.1, 0.0, 0.0, 270.5 	},  // Автошкола Сан Фиерро
	{ -23.4, -91.7, 1003.4, 0.0, 0.0, 269.25 	},  // Магазин 24/7 (интерьер)
	//{ 1690.6, -2263.3, -2.8, 0.0, 0.0, 270.0 	},  // Аэропорт Лос Сантос
	{ 1679.54, -2335.17, 13.45, 0.0, 0.0, 270.0 },	// Аэропорт Лос Сантос
	{ 1551.4, -1277.6, 17.2, 0.0, 0.0, 0.0		},	// Банк Лос Сантос
	{ 1350.2, -1759.0, 13.4, 0.0, 0.0, 270.0    },  // Магазин 24/7 возле мэрии
	{ 1225.0, -1812.0, 16.4, 0.0, 0.0, 90.0     },  // Автовокзал Лос Сантос
	{ 2175.4, -2259.0, 14.5, 0.0, 0.0, 135.0    },	// Дальнобойная база Лос Сантос
	{ 2233.1, -1166.0, 25.7, 0.0, 0.0, 0.0 },		// Отель Джефферсон
	{ 708.71, -1440.2, 13.5, 0.0, 0.0, -90.0 },		// Автошкола ЛС
	//	Мерия
	{ 2746.57, -2380.02, 819.1, 0.0, 0.0, 180.0 },
	{ 2746.52, -2381.97, 819.1, 0.0, 0.0, 180.0 },
	{ 2746.51, -2383.92, 819.1, 0.0, 0.0, 180.0 }
};
new ATM_Zone[ sizeof(ATM) ];

//---	Map Icon
enum SMP_ENUM
{
	Float:smp_x,
	Float:smp_y,
	Float:smp_z,
	smp_type,
	smp_color
};
new const StaticMapIcon[][SMP_ENUM] =
{
	//---	main
	{ 1545.9950, -1269.106, 17.406, 52,	0 }, 	// Los Santos Bank
	{ 1528.7800, -1678.110, 5.9000, 30,	0 },	// Pol.Dep. Los Santos
	{ 1685.6700, -2332.730, 13.540, 5,	0 },	// Airport
	{ 1173.2300, -1323.720, 15.390, 22,	0 },	// Hospital
	{ -2026.591, -101.4174, 35.164, 36,	0 },	// Autoschool San Fierro
	//{725.65, -1440.13, 13.53,36,0},         // Автошкола Лос Сантос

	//---	car showroom
	{2131.8499,-1150.9371,24.1029,55,0},	// Салон 'Coutt And Shoutz' (лоурайдерские)
	{541.3572,-1293.3917,17.2422,55,0},		// Салон 'Grotti' (городские)
	{-1649.2346,1209.3027,7.2500,55,0},		// Салон 'Ottos Autos' (спортивные)
	{-1961.7168,288.5224,35.4688,55,0},		// Салон 'Wang Cars' (элитные)

	//---	bands
	{ 2492.08, -1686.16, 13.51, 62, 0 },	// Grove Street
	{ 1990.91, -1118.61, 26.77, 59, 0 },	// Ballas
	{ 2805.41, -1177.68, 25.45, 60, 0 },	// Vagos
	{ 1781.30, -2101.50, 14.00, 58, 0 },	// Los Aztecas
	{ 2153.48, -1794.00, 13.53, 61, 0 },	// The Rifa

	//---	repair
	{ 971.711, -1525.47, 13.55, 27, 0 }

	//---	fort carson (неиспользуемое)
	//{-180.1149,1087.8340,19.5898,49,0}, 	// Fort Carson Bar
	//{-53.7951,1188.8074,19.7422,50,0}, 		// Fort Carson Restaurant
	//{-144.0158,1224.9629,19.7422,17,0}, 	// Fort Carson Пончичная
	//{-127.0274,1188.6163,19.7422,45,0}, 	// Fort Carson Clothes
	//{-125.58,1013.99,20.18,27,0},			// Fort Carson Autorepair
	//{-318.7504,1048.5914,20.3403,22,0},		// Fort Carson Hospital
	//{-217.7175,978.6415,19.5024,30,0}		// Fort Carson Pol.Dep.

	//---	burger
	//{2362.2,2069.9,10.8,10,0},	//	burger lv
	//{2469.5,2033.8,10.8,10,0},	//	burger lv
	//{2172.9,2795.7,10.8,10,0},	//	burger lv
	//{1875.3,2072.0,10.8,10,0},	//	burger lv
	//{1161.5,2072.0,10.8,10,0},	//	burger lv
	//{-2356.0,1009.0,49.0,10,0},	//	burger sf
	//{-1913.3,826.2,36.9,10,0},	//	burger sf
	//{-2335.6,-165.6,39.5,10,0},	//	burger sf

	//---	pizza
	//{-1805.7,943.2,24.8,29,0},	//	pizza sf
	//{2750.9,2470.9,11.0,29,0},	//	pizza lv
	//{2351.8,2529.0,10.8,29,0},	//	pizza lv
	//{2635.5,1847.4,11.0,29,0},	//	pizza lv
	//{2083.4,2221.0,11.0,29,0},	//	pizza lv
	//{-1719.1,1359.4,8.6,29,0},	//	pizza sf
	//{2330.2,75.2,31.0,29,0},		//	pizza village
	//{203.2,-200.4,6.5,29,0},		//	pizza village

	//---	cluckin
	//{-2671.6,257.4,4.6,14,0},		//	cluckin sf
	//{2392.4,2046.5,10.8,14,0},	//	cluckin lv
	//{2844.5,2401.1,11.0,14,0},	//	cluckin lv
	//{2635.5,1674.3,11.0,14,0},	//	cluckin lv
	//{2105.7,2228.7,11.0,14,0},	//	cluckin lv
	//{-2154.0,-2461.2,30.8,14,0},	//	cluckin village
	//{-1816.2,620.8,37.5,14,0},	//	cluckin sf
	//{-1216.0,1831.4,45.3,14,0},	//	cluckin village
	//{172.73,1176.76,13.7,14,0},	//	cluckin fc

	//---	ammo
	//{-2626.6,209.4,4.9,6,0},		//	ammo sf
	//{2535.9,2083.5,10.8,6,0},		//	ammo lv
	//{2156.5,943.2,10.8,6,0},		//	ammo lv
	//{779.7,1874.3,4.9,6,0},		//	ammo village
	//{-2092.7,-2463.8,30.6,6,0},	//	ammo village
	//{240.0,-178.2,2.0,6,0},		//	ammo village
	//{-1509.4,2611.8,58.5,6,0},	//	ammo village
	//{-315.67,829.87,13.43,6,0},	//	ammo fc
	//{2332.9,63.6,31.0,6,0}		//	ammo village
};
new static_MapIconID[sizeof(StaticMapIcon)],
	g_TogleMapIcon[MAX_PLAYERS];

enum GUN_ENUM
{
	GUN_ID,
	GUN_NAME[20],
	bool:GUN_EXIST,
	GUN_SLOT,
	GUN_MODEL,
	GUN_AMMO, // Обойма
	GUN_PRICE,
	GUN_MATS,
};
new const GunParams[][GUN_ENUM] =
{
	{ 0, "Кулаки",				false,	0, 0, 0, 0, 0},
	{ 1, "Кастет",				true,	0, 331, 1, 0, 0},
	{ 2, "Клюшка",				true,	1, 333, 1, 0, 0},
	{ 3, "Дубинка",				true,	1, 334, 1, 0, 0},
	{ 4, "Нож",					true,	1, 335, 1, 0, 0},
	{ 5, "Бита",				true,	1, 336, 1, 0, 0},
	{ 6, "Лопата",				true,	1, 337, 1, 0, 0},
	{ 7, "Кий",					true,	1, 338, 1, 0, 0},
	{ 8, "Катана",				true,	1, 339, 1, 0, 0},
	{ 9, "Бензопила",			true,	1, 341, 1, 0, 0},
	{ 10, "Самотык",			true,	10, 321, 1, 0, 0},
	{ 11, "Самотык",			true,	10, 322, 1, 0, 0},
	{ 12, "Вибратор",			true,	10, 323, 1, 0, 0},
	{ 13, "Вибратор",			true,	10, 324, 1, 0, 0},
	{ 14, "Цветы",				true,	10, 325, 1, 0, 0},
	{ 15, "Трость",				true,	10, 326, 1, 0, 0},
	{ 16, "Граната взр",		true,	8, 342, 1, 200, 0},
	{ 17, "Граната газ",		true,	8, 343, 1, 0, 0},
	{ 18, "Молотов",			true,	8, 344, 1, 0, 0},
	{ 19, "unknown",			false,	0, 0, 0, 0, 0},
	{ 20, "unknown",			false,	0, 0, 0, 0, 0},
	{ 21, "unknown",			false,	0, 0, 0, 0, 0},
	{ 22, "Colt45 9mm",			true,	2, 346, 34, 200,	60	},
	{ 23, "Silenced 9mm",		true,	2, 347, 17, 200,	60	},
	{ 24, "Desert Eagle",		true,	2, 348, 7, 300,	90	},	// Обойма: 7
	{ 25, "Shotgun",			true,	3, 349, 12, 600,	180 },
	{ 26, "Sawnoff Shotgun",	true,	3, 350, 12, 800,	240 },	// Обрез
	{ 27, "Combat Shotgun",		true,	3, 351, 12, 1000, 300	},
	{ 28, "Micro SMG",			true,	4, 352, 100, 500, 150 },
	{ 29, "MP5",				true,	4, 353, 30, 1000, 300 },
	{ 30, "AK-47",				true,	5, 355, 30, 2750, 825 },
	{ 31, "M4",					true,	5, 356, 25, 2250, 675 },
	{ 32, "Tec-9",				true,	4, 372, 100, 300, 90	},
	{ 33, "County Rifle",		true,	6, 357, 8, 3000, 900	},
	{ 34, "Sniper Rifle",		true,	6, 358, 8, 5000, 1500 },
	{ 35, "RPG",				true,	7, 359, 3, 6000, 1800 },
	{ 36, "HS Rocket",			true,	7, 360, 3, 8000, 2400 },
	{ 37, "Огнемет",			true,	7, 361, 250, 0, 0},// Обойма: 500
	{ 38, "Minigun",			true,	7, 362, 125, 0, 0},// Обойма: 500
	{ 39, "Взрывчатка",			true,	8, 363, 4, 0, 0},
	{ 40, "Детонатор",			true,	12, 364, 1, 0, 0},
	{ 41, "Балончик",			true,	9, 365, 500, 0, 0},
	{ 42, "Огнетушитель",		true,	9, 366, 500, 0, 0},
	{ 43, "Фотокамера",			true,	9, 367, 12, 0, 0},
	{ 44, "Ночное видение",		true,	11, 368, 1, 0, 0},
	{ 45, "Тепловизор",			true,	11, 369, 1, 0, 0},
	{ 46, "Парашют",			true,	11, 371, 1, 0, 0}
};
new const GunDealWeapons[] = { 22, 24, 25, 29, 30, 31, 34 };

/////////////////////////////
new const Float:GreenZones[][4]  =
{
	{	923.17,		-1611.5,	1000.5,		-1675.5 },	//	Спавн новичков
	{	1534.7, 	-1722.4, 	1607.5, 	-1602.9	},	//  LSPD
	{   1434.9,		-1774.3,    1543.7,		-1597.3 },	//  Town Hall
	{	1149.6,		-1385.2,	1211.3,		-1290.9	},	//	Hospital LS 1
	{	622.04,		-356.84,	684.25,		-324.78	},	//	Интерьер Госпиталя
	{	2104.5,		-2345.5,	2258.5,		-2191.9 },	//	Товарный склад
	{	1695.4,		-1942.6,	1734.7,		-1893.7 },  //  Бонус площадка (жд ЛС)
	{	2185.8,		-1193.0,	2248.7,		-1146.7 },	//	Отель Jefferson
	//{	1650.591,	-2339.1,	1707.300,	-2293.6 },	//	Аэропорт
	{	-1221.57,	-1223.2,	-1030.35,	-1140.0 },	//	Ферма
	{	689.4961,	-1482.7,	776.7458,	-1407.9	}	//	Автошкола
};
new area_GreenZones[sizeof GreenZones];

new const Float:SpawnCoord[] = { 946.0, -1657.0, 13.5, 0.0 };
//	1654.0, -2351.0, 13.55, 270.00
//	1645.0, -2286.5, -1.3, 270.0
//	-176.4564, 1170.9753, 19.75, 270.0

new const Float:FillPos[][3] =
{
	{ 1939.0956, 	-1773.8364, 13.5	},
	{ 1004.1484, 	-938.9459,	42.2 	},
	{ -91.6648,		-1169.0172,	2.4 	},
	{ -1606.1063,	-2714.1504,	48.5 	},
	{ -2244.2561,	-2560.7932,	31.9 	},
	{ -2029.3003,	157.9346,	28.8 	},
	{ -2413.8540,	976.7621,	45.3 	},
	{ -1328.0632,	2677.4766,	50.1 	},
	{ 619.0574,		1684.9814,	6.9 	},
	{ 608.5440,		1699.9197,	6.9 	},
	{ 2201.9497,	2474.5491,	10.8 	},
	{ 2114.9487,	920.4476,	10.8 	},
	{ 658.3701,		-570.9639,	16.3 	},
	{ 1596.0234,	2199.1831,	10.8 	},
	{ 2639.6646,	1106.3054,	10.8 	},
	{ -2531.5281,	2363.7927,	4.9 	},
	{ -1674.2936,	415.0908,	7.2 	},
	{ 1381.9795,	459.4446,	20.3 	},
	{ 1381.3932,	457.1069,	19.9 	},
	{ -117.4886,	1005.4965,	19.8 	}
};

new const FightStyleNames[][16] = {
	"Нормальный",
	"Бокс",
	"Кунг-фу",
	"Удар коленом",
	"Удар ногой",
	"Удар локтем"
};

//---- [Varriables] ------
new CutSceneText[MAX_PLAYERS][2];

new NowWeather;

new bool:GameModeStatus, MaxHouses, MaxBiz;
new OldMinute, OldHour, RestTime, GlobalGZ, PoliceCallNum;
new TruthCar;
//new BusPlaybackCount = 0;

new finepark_timer;
new FineparkCount;
new FineparkVehicle;
new Text3D:Finepark3DText;

new EmmetStore[7][3];// [Пистолет, Полуавтомат,...] [0 weaponid; 1 ammo; 2 price]

new bool:ClockStatus;

//	Combs System
enum
{
	COMB_NONE,
	COMB_JAILJOB,
	COMB_CREATE_GUN,
	COMB_CREATE_DRUG,
};

//	Tickets System
enum E_ASK
{
	askId,
	askSender,
	bool:askStatus,
	askText[128],
	bool:askBusy
}
new gAsk[MAX_ASK_COUNT][E_ASK];
new gAskCount;

//	Advert System
enum ADVERT_DATA
{
	adSender[24],
	adCheker[24],
	adRang[24],
	adPhone,
	adText[100],
	adTime,
	adStatus,
	bool:adEdit,
	bool:adBusy,
};
new gAdvert[MAX_ADVERT_COUNT][ADVERT_DATA];
new gAdvertCount;
//new gAdvertPrice = 8;
new gAdvertTime;
new pAdverReload[MAX_PLAYERS]; // UNIX последнего редактирования (репортером)

new DrugStore = 100; // Счетчик нарко в притоне
new Text3D:Drug3DText;

//	Game menu
new Menu:PizzaMenu,
	Menu:CluckinBellMenu,
	Menu:BurgerShotMenu,
	Menu:KingRingMenu;

//	SHOOTING System
new const Float:TirTargetsPos[][][] =
{
	{	{ 293.2, -14.0, 1004.0	},	{ 293.2, -10.0, 1004.0	},	{ 293.2, -6.0, 1004.0	}	},
	{	{ 293.2, -6.0, 1004.0	},	{ 293.2, -6.0, 1004.0	},	{ 293.2, -6.0, 1004.0	}	},
	{	{ 297.0, -6.0, 1004.0	},	{ 287.0, -10.0, 1004.0	},	{ 297.0, -14.0, 1004.0 	}	}
};

enum E_TIR_MISSION
{
	TIR_TIME,
	TIR_AMMO
}

new const TirMissionInfo[ sizeof(TirTargetsPos) ][E_TIR_MISSION] =
{
	{	30, 30	},
	{	35, 35	},
	{	45,	40	}
};

//--- Pickups
new PoliceDutyPickup, 	// 	Раздевалка в участке
	HospitalDutyPickup,	//	Раздевалка в больнице
	LawbookPickup,		// 	Свод законов в участке
	CopGuidePickup,		// 	Инструктаж для копов
	FineParkPickup, 	// 	Штраф-стоянка
	StuffBankEnter,     //  Вход в служ помещение в банке
	StuffBankExit,      //  Выход из служ помещение в банке
	StuffBankExit2,     //  Выход из служ помещение в банке
	VentBankPickup,     //  Вход в вентиляцию в банке
	PrisonEatPickup,	//	Пикап еды в тюрьме
	RepairPickup[sizeof(AutoRepairPos)], // Пикап починки авто
	GunDealPickup,
	DrugDealPickup[2],
	RingInfoPickup[2],
	GYMPickup[2],
	MotelPickup,
	MRoomPickup[3],
	WarehousePickup[5+3],
	CrimebankPickup[5],
	MechanicPickup,
	NewbiePickup,
	AirportPickup,
	BoardPickup[2];

//	Zone
new PoliceGateZone,     // 	Зона возле ворот полицейских
	GateInfoZone[2],	//	Зона для подсказок открытия ворот
	TrainingZone[1];	//	Зона подсказок при прохождении обучения

//---	Objects
new Crane,
	// Active Gates
	LSPDbarr,
	FC_Gate[2],
	AreaGate[4],
	KassGate[2],
	PrisonGate[6],
	LS_PrisonGate[10],
	ASbarr,
	FBIGate;

new CranePos;

// Aircraft Carrier
new bool:AirGate1Open, AirGate1, // Большой квадратный люк сзади
	bool:AirGate2Open, AirGate2; // Подъемник слева от корабля

//  foreach
new Iterator:LoginPlayer<MAX_PLAYERS>;
new Iterator:Vehicle<MAX_VEHICLES>;
new Iterator:Cop<MAX_PLAYERS>;
new Iterator:Prisoners<MAX_PLAYERS>;
new Iterator:Spectators<MAX_PLAYERS>;

new SalonCars1[8];  // Los Santos (lowrider)
new SalonCars2[12]; // Los Santos (city-country)
new SalonCars3[10]; // San Fierro (sport)
new SalonCars4[16]; // San Fierro (elite)
new CarSalonPickup_F;
new CarSalonPickup_L;

//--- Attach weapon
enum E_W_ATTACH
{
	WA_BONE,
	Float:WA_POS[6]
};

new const attachWeaponPos[][E_W_ATTACH] =
{
	//{ 1, { 0.199999, -0.139999, 0.03, 0.500007, -115.0, 0.0 } },
	//{ 8, { -0.079999, -0.039999, 0.109999, -90.100006, 0.0, 0.0 } },
	{ 7, { 0.0, -0.1, -0.08, -95.0, -10.0, 0.0 } },
	{ 1, { 0.2, -0.119999, -0.059999, 0.0, 206.0, 0.0 } }
};

//--- [Player Varriables] ---//
new gWeaponID[MAX_PLAYERS][13];
new gWeaponAmmo[MAX_PLAYERS][13];
new bool:gWeaponStatus[MAX_PLAYERS char];
new DrugsCrack[MAX_PLAYERS];
new UseDrugsTime[MAX_PLAYERS];
new Float:RopePos[MAX_PLAYERS][5];
new RopeObjects[MAX_PLAYERS][ROPE_LENGTH];
new bool:openWithInv[MAX_PLAYERS];
new bool:openWithATM[MAX_PLAYERS];
new bool:openWithMenu[MAX_PLAYERS];
new bool:showDebug[MAX_PLAYERS];
new bool:PlayerSelectVCFM[MAX_PLAYERS];
new bool:pNameTags[MAX_PLAYERS];
new PlayerFoodHands[MAX_PLAYERS];
new armedbody_pTick[MAX_PLAYERS];
new CarryTimer[MAX_PLAYERS];
new SpectateID[MAX_PLAYERS] = { INVALID_PLAYER_ID, ... };
new gTickPushed[MAX_PLAYERS];
new gTickEngine[MAX_PLAYERS];
new gPlayerLogTries[ MAX_PLAYERS char ];
new gInModShop[MAX_PLAYERS];
new Float:gInModShopPos[MAX_PLAYERS][3];
new gLastVehicle[MAX_PLAYERS];
new gEnteringVehicle[MAX_PLAYERS]; // Tick
new gPickupTime[MAX_PLAYERS],
	gPickupID[MAX_PLAYERS];
new gCheckpoint[MAX_PLAYERS],
	gMapIcon_CP[MAX_PLAYERS],
	gType_CP[MAX_PLAYERS];
new gTargetid[MAX_PLAYERS] = { INVALID_PLAYER_ID, ... };
new bool:gLeavingGang[MAX_PLAYERS];
//-
new bool:InMask[MAX_PLAYERS];
new OldSpeed[MAX_PLAYERS];
new Dialogid[MAX_PLAYERS] = { INVALID_DIALOGID, ... };
new DialogTimeleft[MAX_PLAYERS];
new MembersPage[MAX_PLAYERS];
new MembersNum[MAX_PLAYERS];
new PlayerVehicle[MAX_PLAYERS];
new Float:Mark[MAX_PLAYERS][4];
new MarkINT[MAX_PLAYERS];
new MarkVW[MAX_PLAYERS];
new bool:AdminDuty[MAX_PLAYERS];
new RegBizIdx[MAX_PLAYERS];
new graffiti_timer[MAX_PLAYERS];
new burning_timer[MAX_PLAYERS];
new ChooseVehicleID[MAX_PLAYERS];
new ChooseVehicleSel[MAX_PLAYERS];
new ChooseVehicleModel[MAX_PLAYERS];
new engine_timer[MAX_PLAYERS];
new gzGodMode[MAX_PLAYERS];
new TestObject[MAX_PLAYERS];
new TestPickup[MAX_PLAYERS];
new FW_Missile[MAX_PLAYERS];
new FW_Smoke[MAX_PLAYERS];
new FW_Sparks[MAX_PLAYERS][8];
new GotoObject[MAX_PLAYERS];
new StartupAntiflood[MAX_PLAYERS];
new MakeleaderPlayerid[MAX_PLAYERS];
new pRepair[MAX_PLAYERS];
new unfreeze_timer[MAX_PLAYERS];
new weaponid_new[MAX_PLAYERS];
new gExpTime[MAX_PLAYERS];	// Для системы выдачи опыта через время (когда по чуть-чуть набирается, напр. на ферме)
new Float:gExpCount[MAX_PLAYERS];
new WantedTime[MAX_PLAYERS];
new gPressedKeyAIM[MAX_PLAYERS];
new gTargetVehicle[MAX_PLAYERS];
new TalkingLive[MAX_PLAYERS] = { INVALID_PLAYER_ID, ... };
new bool:p_FellAnim[MAX_PLAYERS];
new AmmoZone[11 * 3];

//	Clothes Shop
enum E_CLOTHE_DATA
{
	Float:csd_Pos[4],
	Float:csd_StartCamPos[3], 
	Float:csd_StartCamLookAt[3], 
	Float:csd_FaceCamPos[3],
	Float:csd_FaceCamLookAt[3], 
}
new const ClothesShopData[][E_CLOTHE_DATA] = {
	//	Player pos 		Cam pos start		Cam pos face
	{ 
		{ 0.0, 0.0, 0.0, 0.0 },					
		{ 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0 },
		{ 0.0, 0.0, 0.0 }, { 0.0, 0.0, 0.0 }
	},
	
	//	Binco
	{ 
		{ 218.0026, -98.3485, 1005.2578, 105.0 },	
		{ 215.478, -99.516, 1005.112 },	{ 219.937, -97.273, 1005.401 },	
		{ 217.174, -98.718, 1005.902 }, { 221.562, -96.327, 1006.054 } 
	},

	//	DS
	{
		{ 216.073, -155.509, 1000.523, 112.0 }, 
		{ 213.825, -156.791, 1000.458 }, { 218.167, -154.331, 1000.774 },
		{ 215.409, -155.939, 1001.142 }, { 219.569, -153.176, 1001.376 }
	},

	//	Prolaps
	{
		{ 199.823, -126.812, 1003.515, 159.0 },
		{ 198.673, -129.237, 1003.481 }, { 200.661, -124.664, 1003.852 },
		{ 199.479, -127.527, 1004.159 }, { 201.621, -123.011, 1004.257 }
	},

	// Suburban
	{
		{ 214.8540, -40.8765, 1002.0234, 105.0 },
		{ 212.200, -42.099, 1001.977 }, { 216.717, -39.979, 1002.293 },
		{ 214.033, -41.296, 1002.580 }, { 218.429, -38.962, 1003.060 }
	},

	// Victim
	{
		{ 204.2823, -4.1902, 1001.2109, 250.0 },
		{ 206.944, -5.661, 1001.239 }, { 202.566, -3.254, 1001.446 },
		{ 205.073, -4.591, 1001.870 }, { 200.555, -2.450, 1001.968 }
	},

	//	ZIP
	{
		{ 181.5283,-87.9415,1002.0234,103.0 },
		{ 178.704, -89.226, 1001.847 }, { 183.283, -87.258, 1002.245 },
		{ 180.782, -88.392, 1002.621 }, { 184.996, -85.723, 1002.965 }
	}
};
new ClothesShopID[MAX_PLAYERS],
	ClothesShopSel[MAX_PLAYERS],
	ClothesItem[MAX_PLAYERS];

//	Airport
new NearAirportDoorPlayers,
	AirportZone[3],
	AirportDoor[2];

//	Login player
new	gLoggedTime[MAX_PLAYERS],
	LoginCameraTimer[MAX_PLAYERS],
	bool:FirstSpawn[MAX_PLAYERS],
	bool:gPlayerShowLoginCam[MAX_PLAYERS],
	bool:gPlayerLogged[MAX_PLAYERS],
	bool:gPlayerDisconnecting[MAX_PLAYERS],
	bool:gPlayerDeath[MAX_PLAYERS];

//	Drink
new playerDrink[MAX_PLAYERS char],
	playerDrinkCount[MAX_PLAYERS char],
	PlayerDrunkTime[MAX_PLAYERS char],
	playerSmokeCount[MAX_PLAYERS char];

//	GPS
enum E_GPS
{
	Float:GPS_POS[3],
	GPS_CP,
	GPS_MAP,
	GPS_OBJ
};
new gps_Data[MAX_PLAYERS][E_GPS];

//	Механик
new MechanicCall = -1,
    MechanicCallTime,
    MechanicStatus[MAX_PLAYERS],
    MechanicClientid[MAX_PLAYERS],
    MechanicMapIcon[MAX_PLAYERS];

//	Jail
new const JailSkins[] = { 42, 176, 177, 268 };
new JailGZ;
new JailZone[3];
new g_JailOccupied[ sizeof(JailPos) ];

new p_JailOccupied[MAX_PLAYERS] = { INVALID_PLAYER_ID, ... };
new JailTime[MAX_PLAYERS];
new jail_numer[MAX_PLAYERS][9];
new Text3D:jail_number_3dtext[MAX_PLAYERS];
new InJailTimer[MAX_PLAYERS];
new bool:p_PrisonTimer[MAX_PLAYERS char];

//	Jail Job
new j_JobObj[MAX_PLAYERS],
	j_MapIcon[MAX_PLAYERS];
new j_jobstep[MAX_PLAYERS char];

new j_fFinalPickup;
new j_matpickup[2], j_jobcp[ sizeof(j_fJobPos) ];
new j_Storage;
new j_lStartPickup,
	j_lFinishPickup;

new Text3D:j_f3DText,
	Text3D:j_l3DText;

// breaking car
enum
{   // типы взлома авто
    BREAK_CAR_B_GLASS,
	BREAK_CAR_HACKING,
	BREAK_CAR_ENGINE
};

// robbery
new robbery_biz[MAX_PLAYERS],
	robbery_offerid[MAX_PLAYERS],
	robbery_money[MAX_PLAYERS],
	robbery_step[MAX_PLAYERS],
	robbery_timer[MAX_PLAYERS];

// mission
enum
{
	MIS_SOURCE_TRAINING,	//	Начальные миссии (обучение)
}

enum
{
	MIS_NONE,
	MIS_HOTEL,			//	1 Начальная миссия: Добравть до отеля и прописаться в нем
	MIS_TRAINING,		//	2 Начальная миссия: Выполнить задание для Jason'a
	MIS_START_WORK,		//	3 Начальная миссия: Заработать на права
	MIS_GET_LICENSE,	//	4 Начальная миссия: Получить права
}

enum E_MIS
{
	m_Title[32],	//	заголовок задачи
	m_Desc[256],	//	описание задачи
}

new const StartMissionData[][E_MIS] = {
	{ "", "" },	//	MIS_NONE
	{
		"Прописаться в отеле",
		"{FFFFFF}Доберитесь до отеля Jefferson и пропишитесь в нем.\n\
		Добраться до туда можно на бесплатной маршрутке,\n\
		которая останавливается на спавне в аэропорту."
	},
	{
		"Поговорить с Джейсоном",
		"{FFFFFF}Поговорите с Джейсоном, который стоит в отеле.\n\
		Ему явно нужна помощь за которую он неплохо отблагодарит"
	},
	{
		"Получить работу у Дерека",
		"{FFFFFF}Доберитесь до товарного склада "MAIN_COLOR"(/gps > Подработка > Товарный склад)\n\
		{FFFFFF}Узнайте какую работу вам может предложить Дерек.\n\
		Это поможет заработать вам денег на первое время."
	},
	{
		"Получить лицензию на авто",
		"{FFFFFF}Доберитесь до автошколы и пройдите курсы вождения.\n\
		Это позволит вам получить более высокооплачиваемую работу.\n\n\
		Стоимость автошколы - $300\n\
		Проходить автошколу вы сможете в любое время, но для получения прав\n\
		Вам потребуется 2 уровень (1 upgrade)"
	}
};

new mission_id[MAX_PLAYERS],    // Номер миссии (0 - нет миссии)
	mission_step[MAX_PLAYERS],	// Шаг задания
	mission_count[MAX_PLAYERS], // Счетчик
	mission_cpnum[MAX_PLAYERS],
	mission_pobject[MAX_PLAYERS],	// PlayerObject
	mission_veh[MAX_PLAYERS],
	mission_timer[MAX_PLAYERS],
	mission_pickup[MAX_PLAYERS],
	mission_mapicon[MAX_PLAYERS][3];
new gMissionProgress[MAX_PLAYERS][MISSION_SOURCE];	//	сохраняющиеся данные

// redit
new redit_id[MAX_PLAYERS],		// Идентификатор гонки
	redit_item[MAX_PLAYERS],    // Редактируемый параметр
	redit_act[MAX_PLAYERS],		// Действие редактирования (0 - ничего, 1 - старт точка, 2 - спавн точки, 3 - чекпоинты)
	redit_num[MAX_PLAYERS],		// Порядковый номер
	redit_curid[MAX_PLAYERS],	// Текущий ид таблицы
	redit_previd[MAX_PLAYERS],	// Предыдущий ид таблицы
	Float:redit_size[MAX_PLAYERS];	// Размер чекпоинта

//  fader
enum
{
	FADE_NONE,
	//FADE_ENTER,
	FADE_TELEPORT,
	FADE_THEFT
};

enum
{
	FT_NONE,
	FT_BIZ,
	FT_HOUSE,
	FT_HROOM_EXIT,
	FT_AUTOSCHOOL,
	FT_TIR,
	FT_TIR_COMPLETE,
}

new fade_Teleporting[MAX_PLAYERS],
	bool:fade_Freeze[MAX_PLAYERS],
	fade_Interior[MAX_PLAYERS],
	fade_VirtualWorld[MAX_PLAYERS];
	//fade_Side[MAX_PLAYERS],
	//fade_EnterID[MAX_PLAYERS];
new Float:fade_TPToPos[MAX_PLAYERS][4],
	Fade_TeleportID[MAX_PLAYERS];

new EffectCheck[MAX_PLAYERS char];

//	Shooting
new p_ShootingTargetObjects[MAX_PLAYERS][8],
	p_ShootingCountdown[MAX_PLAYERS char],
	p_ShootingHits[MAX_PLAYERS char],
	p_ShootingWave[MAX_PLAYERS char],
	bool:p_isShooting[MAX_PLAYERS char];

//	Койки больницы
new const Float:HospitalBerth[][][] =
{	//	Палата 1
	{ { -2663.11, 645.6, 1275.77, 90.00 }, { -2663.08, 643.87, 1275.13, 180.0 } },
	{ { -2659.60, 645.6, 1275.77, 90.00 }, { -2659.63, 643.87, 1275.13, 180.0 } },
	{ { -2656.06, 645.6, 1275.77, 90.00 }, { -2656.02, 643.87, 1275.13, 180.0 } },
	{ { -2652.69, 645.4, 1275.77, 90.00 }, { -2652.67, 643.87, 1275.13, 180.0 } },
	{ { -2656.96, 638.7, 1275.77, 270.0 }, { -2656.94, 640.35, 1275.13, 360.0 } },
	{ { -2660.04, 638.7, 1275.77, 270.0 }, { -2659.98, 640.35, 1275.13, 360.0 } },
	{ { -2663.28, 638.7, 1275.77, 270.0 }, { -2663.30, 640.35, 1275.13, 360.0 } },
	//	Палата 2
	{ { -2675.05, 645.5, 1275.77, 90.00 }, { -2675.07, 643.87, 1275.13, 180.0 } },
	{ { -2671.66, 645.5, 1275.77, 90.00 }, { -2671.73, 643.87, 1275.13, 180.0 } },
	{ { -2668.11, 645.5, 1275.77, 90.00 }, { -2668.18, 643.87, 1275.13, 180.0 } },
	{ { -2664.55, 645.5, 1275.77, 90.00 }, { -2664.67, 643.87, 1275.13, 180.0 } },
	{ { -2668.90, 638.7, 1275.77, 270.0 }, { -2668.85, 640.35, 1275.13, 360.0 } },
	{ { -2672.09, 638.7, 1275.77, 270.0 }, { -2672.09, 640.35, 1275.13, 360.0 } },
	{ { -2675.25, 638.7, 1275.77, 270.0 }, { -2675.21, 640.35, 1275.13, 360.0 } }
};
new Text3D:Berth3DText[sizeof(HospitalBerth)];
new bool:BerthStatus[sizeof(HospitalBerth)];

enum
{
	BLOCK_NONE = 0,
	BLOCK_CMD = 1,
	BLOCK_CHAT = 2,
	BLOCK_SEND_CHAT = 4,

	BLOCK_ALL = BLOCK_CMD | BLOCK_CHAT | BLOCK_SEND_CHAT,
};
new gBlockAction[MAX_PLAYERS];
//--- [End of Player Varriables] ---//

//	---	breaking bad achieve
new Float:BreakingBad[][] = {
	//	Позиция авто
	{ 539.2, 	1580.0, 1.3, 	10.5	},
	{ -226.5,	1470.3,	75.9,	14.0 	},
	{ -150.8,	2291.8,	30.2,	325.4 	},
	{ 159.9,	2367.9,	16.7,	273.2 	}
};
new BB_Car,
    BB_Object,
    BB_MapIcon,
    BB_Time,        // Если > 0, то Уолтер на месте
    BB_Text,
    BB_TextNum;

//---	Hotels
enum E_HOTEL
{
	Float:H_POS[4],
	H_INT,
}

new const HotelRooms[3][E_HOTEL] = {
	{ { 2284.7, -1136.6, 1050.90, 90.0	}, 11 },
	{ { 2264.0, -1140.6, 1050.63, 360.0 }, 10 },
	{ { 2250.6, -1135.1, 1050.63, 178.5 }, 9 }
};

new StripZone[2];