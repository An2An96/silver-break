#if defined _job_header_included
	#endinput
#endif

#define _job_header_included

#define Job.	Job_

#define CONTRACT_TIME			180		// Время рабочего контракта

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
{/* Не менять последовательность, добавлять в конец */
	JOB_NONE,

// Легальные работы
	JOB_BUSDRIVER,  // 	Водитель автобуса (Легально)
	JOB_TRUCKER,    // 	Дальнобойщик (Легально)
	JOB_TAXI,		//	Таксист (Легально)
	JOB_MECHANIC,	//	Механик (Легально)
	JOB_TRASHMAN,	//	Мусорщик (Легально)

// Нелегальные работы (IsAvailableJob)
	JOB_THEFT,		// 	Автоугонщик (Нелегально, LCN)
	//JOB_GUNDEAL,	// 	Торговец оружием (Нелегально, RusMaf)
	//JOB_DRUGDEAL,	// 	Наркодиллер (Нелегально, Yakuza)

//	Подработки (В КОНЦЕ)
	PART_LOADER	= 9,//	Грузчик
	PART_FARMER,	//	Фермер
	PART_DELIVERY,	//	Доставка
	PART_DIVER,		//	Дайвер					[not implemented]
	PART_PIZZA,		//	Доставка пиццы			[not implemented]

	//JOB_AUTODEAL,	// 	Автодиллер (Легально)
	//JOB_FISHER,	// 	Браконьер (Нелегально)
	//JOB_WHORE,	// 	Шлюха (Нелегально)
	//JOB_KILLER,   // Убийца (миссия)
	//JOB_BUILDER,  // Строитель (фракция)
	//JOB_PHOTO,    // Фотограф (фракция)
	//JOB_LAWYER,	// Адвокат (неизвестно применение)
	//JOB_DETECTIVE,	// Детектив
	//JOB_AIRCOMPANY,   // Авиакомпания (фракция)
};

enum E_JOB_INFO
{
	J_NAME[24],		//	название работы
	J_LEVEL,
	bool:J_OFF,		//	официальная работа (true - офф | false - не офф)
	bool:J_PART,	//	0 - работа | 1 - подработка
	Float:J_POS[3],	//	позиция работы на карте (для мапп иконки)

	//	Settings
	J_CLEAR_TYPE,	//	тип отмены работы (0 - при смерти, 1 - при спавне)
};

new Jobs[][E_JOB_INFO] = {
	{ "Отсутствует",		0,	false,	false,	{ 0.0, 0.0, 0.0 },	false },				//	JOB_NONE
	
	{ "Водитель автобуса",	2,	true, 	false,	{ 1259.86, -1814.57, 13.40 },	false },	//	JOB_BUSDRIVER
	{ "Дальнобойщик",		3,	true,	false,	{ 2212.05, -2226.70, 13.54 },	false },	//	JOB_TRUCKER
	{ "Таксист",			2,	true,	false,	{ 1091.07, -1768.42, 13.30 },	false },	//	JOB_TAXI
	{ "Механик",			4,	true,	false,	{ 1099.81, -1235.69, 15.80 },	false },	//	JOB_MECHANIC
	{ "Мусорщик",			0,	true,	false,	{ 2200.47, -1970.28, 13.78 },	false },	//	JOB_TRASHMAN

	{ "Автоугонщик",		5,	false,	false,	{ 1241.09, -2047.22, 60.0 },	true },		//	JOB_THEFT
	//{ "Торговец оружием",	5,	false,	false,	{ 1267.99, -818.602, 84.1 },	false },	//	JOB_GUNDEAL
	//{ "Наркодиллер",		5,	false, 	false,	{ 688.287, -1271.47, 13.5 },	false },	//	JOB_DRUGDEAL

	//	Part Jobs
	{ "Фермер",				0,	true,	true,	{ 0.0, 0.0, 0.0 },	false },	//	PART_FARMER
	{ "Доставка",			0,	true,	true,	{ 0.0, 0.0, 0.0 },	false },	//	PART_DELIVERY
	{ "Дайвер",				0,	true,	true,	{ 0.0, 0.0, 0.0 },	false },	//	PART_DIVER
	{ "Курьер",				0,	true,	true,	{ 0.0, 0.0, 0.0 },	false }		//	PART_PIZZA
};

new 
	pJob[MAX_PLAYERS]			=	{ JOB_NONE, ... },
	pContract[MAX_PLAYERS],
	pAtWork[MAX_PLAYERS] 		= 	{ JOB_NONE, ... },
	pJobMapIcon[MAX_PLAYERS]	=	{ INVALID_STREAMER_ID, ... },
	Float:pJobWage[MAX_PLAYERS],		// Счетчик заработка (перечисляется в 00 минут)
	Float:pPartWage[MAX_PLAYERS];