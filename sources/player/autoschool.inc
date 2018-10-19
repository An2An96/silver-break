enum
{
	AUTOSCHOOL_START,
	AUTOSCHOOL_PASSAGE,
	AUTOSCHOOL_FINISH
};

new AS_ElementNumber[MAX_PLAYERS]; // 0 - не проходит, > 0 - проходит
new AS_Objects[MAX_PLAYERS][48];
new AS_Vehicle[MAX_PLAYERS];
new AS_Time[MAX_PLAYERS];
new AS_Timer[MAX_PLAYERS];
new Float:AS_OldAngel[MAX_PLAYERS];
new AS_Check[MAX_PLAYERS];

enum AS_INFO
{
	AS_Name[32],          	//  название
    AS_Descrip[512],      	//  описание
	AS_RunTime,				//	время выполнения
	AS_Veh,             	//  ид авто
	Float:AS_Damage,        //  Допустимые повреждения
	bool:AS_CP,             //  показывать чекпоинты?
	bool:AS_CheckSpeed,     //  проверять скорость на финише?
	Float:AS_StartPos[4],	//	стартовая позиция
	Float:AS_CheckPos[4], 	//  промежутачная позиция
	Float:AS_FinishPos[4],	//  конечная позиция
};

new const AS_Mission[][AS_INFO] =
{
	{	"360 градусов",     //  Название
		"Вокруг твоей машины расставлены конусы.\n\
		Все, что тебе надо сделать, это "MAIN_COLOR"зажать газ и тормоз{FFFFFF} одновременно, "MAIN_COLOR"поворачивая влево либо вправо{FFFFFF}.\n\
		Таким образом, за машиной будет тянуться след от колес, который нарисует "MAIN_COLOR"окружность{FFFFFF} вокруг тебя.\n\
		Постарайся остановить авто там же, где стартовал.",     //  Описание
		10, 	//  Время на выполнение
		411,    //  Машина
		0.0,    //  Допустимые повреждения
		false,  //  показывать чекпоинты?
		false,   //  проверять скорость на финише?
		{	-2048.9355,	-130.5788,	35.0,	180.0	},  //  Стартовая позиция
		{	-2048.9355,	-130.5788,	35.0,	360.0	},  //  Промежуточная позиция
		{	-2048.9,	-130.6,		35.0,	180.0	}	//  Конечная позиция
	},
	{	"180 градусов", //  Название
		"Разгонись и езжай прямо вперед.\n\
		Доехав до конусов, "MAIN_COLOR"развернись{FFFFFF} вокруг них, удерживая "MAIN_COLOR"ручной тормоз{FFFFFF}.\n\
		Пройдя поворот, сразу начинай ускоряться.\n\
		Ровно и аккуратно "MAIN_COLOR"останови автомобиль{FFFFFF} между конусами.", //  Описание
		10,     //  Время на выполнение
		496,    //  Машина
		0.0,    //  Допустимые повреждения
		false,  //  показывать чекпоинты?
		false,   //  проверять скорость на финише?
		{	-2048.6,	-124.7,	35.0,	180.0	},  //  Стартовая позиция
		{	-2047.9, 	-209.7, 	35.0,	999.0	},  //  Промежуточная позиция
		{	-2048.6,	-124.7,		35.0,	360.0	}	//  Конечная позиция
	},
	{	"Поворот и остановка",  //  Название
		"Соверши "MAIN_COLOR"поворот{FFFFFF} при помощи заноса и "MAIN_COLOR"остановись{FFFFFF} в обозначенном месте.", //  Описание
		5,      //  Время на выполнение
		429,    //  Машина
		0.0,    //  Допустимые повреждения
		false,  //  показывать чекпоинты?
		false,   //  проверять скорость на финише?
		{	-2029.9352,	-137.6946,	35.0,	180.0	},  //  Стартовая позиция
		{	-2030.8, 	-176.8, 	35.0,	999.0	},  //  Промежуточная позиция
		{	-2062.0,	-179.0,		35.0,	90.0	}   //  Конечная позиция
	},
	{   "Управляемый занос",    //  Название
	    "Разгонись, на полпути отпусти газ и "MAIN_COLOR"переедь через шипы{FFFFFF}.\n\
		Твои "MAIN_COLOR"шины лопнут{FFFFFF}, после чего можешь вновь ускоряться.\n\
		"MAIN_COLOR"Проедь{FFFFFF} указанным курсом и "MAIN_COLOR"припаркуйся{FFFFFF}.", //  Описание
		5,      //  Время на выполнение
		596,    //  Машина
		0.0,    //  Допустимые повреждения
		false,  //  показывать чекпоинты?
		false,   //  проверять скорость на финише?
		{	-2049.0,	-130.0,	35.0,	180.0	},  //  Стартовая позиция
		{	-2049.0,	-168.1,	35.0,	999.0	},  //  Промежуточная позиция
		{	-2049.0,	-214.7,	35.0,	180.0	},  //  Конечная позиция
	},
	{   "Разворот вокруг конуса",    //  Название
	    "Быстро "MAIN_COLOR"объедь конусы{FFFFFF}, соверши "MAIN_COLOR"разворот на 180{FFFFFF} и "MAIN_COLOR"вернись{FFFFFF} на стартовую позицию.", //  Описание
		10,     //  Время на выполнение
		429,    //  Машина
		0.0,    //  Допустимые повреждения
		false,  //  показывать чекпоинты?
		false,   //  проверять скорость на финише?
		{	-2053.0,	-138.0,	35.0,	180.0	},  //  Стартовая позиция
		{	-2053.0,	-199.3,	35.0,	999.0	},  //  Промежуточная позиция
		{	-2053.0,	-138.0,	35.0,	360.0	}	//  Конечная позиция
	},
	{   "Прыжок",    //  Название
	    "Тебе надо добраться до "MAIN_COLOR"трамплина{FFFFFF} и заехав на него "MAIN_COLOR"совершить прыжок{FFFFFF}.\n\
		При этом необходимо "MAIN_COLOR"перелететь{FFFFFF} через первый ряд машин и "MAIN_COLOR"остановится{FFFFFF} не задев второй.", //  Описание
		6,      //  Время на выполнение
		429,    //  Машина
		25.0,    //  Допустимые повреждения
		false,  //  показывать чекпоинты?
		true,   //  проверять скорость на финише?
		{	-2047.0,	-130.0,	35.0,	180.0	},  //  Стартовая позиция
		{	-2047.0,	-181.4,	37.5,	999.0	},  //  Промежуточная позиция
		{	-2047.0,	-217.2,	35.0,	180.0	}	//  Конечная позиция
	},
	{   "Выход в город",    //  Название
		"Как и положено выпускному экзамену, этот тест сложен.\n\
		Тебе предстоит проехать по улицам Сан-Фиерро "MAIN_COLOR"до одного маркера{FFFFFF} и\n\
		"MAIN_COLOR"вернуться обратно{FFFFFF} за короткий отрезок времени.\n\
		Ты не должен оставить "MAIN_COLOR"ни единой царапины{FFFFFF} на своем красавце-автомобиле Super GT.\n\
		Старайся держаться на разделительной полосе (или трамвайных путях) и тормози только для того,\n\
		чтобы избежать аварии. И внимательнее на перекрестках!",    //  Описание
		105,    //  Время на выполнение
		506,    //  Машина
		0.0,    //  Допустимые повреждения
		true,  //  показывать чекпоинты?
		false,   //  проверять скорость на финише?
	    {	-2047.0,	-90.0,	35.0,	360.0	},  //  Стартовая позиция
		{	-1768.0,	1265.1,	9.6,	999.0	},  //  Промежуточная позиция
		{	-2047.0,	-90.0,	35.0,	999.0	}	//  Конечная позиция
	}
};

stock StartASElement(playerid, element)
{
	new obj,
		vw;
	
	vw = playerid + 1;
	if (element == 0)
	{	// Элемент '360 градусов'
	    AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2049.39, -138.12, 34.61, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2043.72, -133.20, 34.61, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2043.20, -129.94, 34.61, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2046.64, -137.70, 34.61, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2043.67, -126.83, 34.61, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2045.36, -124.25, 34.61, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2048.03, -123.23, 34.61, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2044.81, -135.77, 34.61, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2051.82, -137.18, 34.61, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2053.50, -134.78, 34.61, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2054.56, -131.79, 34.61, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2054.53, -128.16, 34.61, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2053.20, -125.34, 34.61, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2050.88, -123.41, 34.61, 0.0, 0.0, 0.0, vw, -1, playerid);
	}
	else if (element == 1)
	{	// Элемент '180 градусов'
	    AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2045.50, -124.50, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2045.50, -127.50, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2045.50, -121.50, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2048.50, -121.50, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2051.50, -121.50, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2051.50, -124.50, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2048.50, -200.00, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2048.50, -204.00, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2048.52, -208.00, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2056.50, -200.00, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2056.50, -204.00, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2056.50, -208.00, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2051.70, -216.50, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2048.50, -217.50, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2043.08, -214.50, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2040.50, -208.00, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2040.50, -204.00, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2040.50, -200.00, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2041.50, -212.00, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2055.50, -212.00, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2051.50, -127.50, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2054.04, -214.50, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2045.50, -216.5, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
	}
	else if (element == 2)
	{
	    AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2035.00, -134.00, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2030.00, -134.00, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2025.00, -134.00, 34.60, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2025.00, -138.00, 34.60, 0.0, 0.0, -0.12, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2035.00, -138.00, 34.64, 0.0, 0.0, -0.12, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2025.00, -142.00, 34.62, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2025.00, -146.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2035.00, -142.00, 34.64,   0.0, 0.0, -0.12, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2035.00, -150.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2035.00, -146.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2035.00, -154.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2035.00, -158.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2025.00, -150.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2025.00, -154.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2025.00, -158.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2025.00, -162.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2025.00, -166.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2025.00, -170.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2035.00, -162.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2035.00, -166.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2035.00, -174.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2035.00, -170.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2039.00, -174.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2043.00, -174.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2047.00, -174.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2025.00, -174.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2025.00, -179.93, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2029.00, -184.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2035.00, -184.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2039.00, -184.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2043.00, -184.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2047.00, -184.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2051.00, -184.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2051.00, -174.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2055.00, -174.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2055.00, -184.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2059.00, -176.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2059.00, -182.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2063.00, -182.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2067.00, -182.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2067.00, -176.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2067.00, -179.00, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2063.0, -176.0, 34.64, 0.0, 0.0, 16.32, vw, -1, playerid);
	}
	else if (element == 3)
	{
		AS_Objects[playerid][obj++] = CreateDynamicObject(2899, -2049.1, -165.8, 34.4, 0.0, 0.0, 90.25, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2046.5, -167.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2051.5, -167.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2046.0, -169.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2046.0, -172.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2046.0, -175.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2046.0, -178.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2052.0, -169.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2052.0, -172.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2052.0, -175.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2052.0, -178.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2047.5, -182.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2053.5, -182.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2049.0, -186.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2055.0, -186.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2055.0, -190.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2049.0, -190.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2049.0, -194.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2055.0, -194.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2054.0, -198.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2048.0, -198.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2047.0, -202.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2053.0, -202.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2052.0, -206.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2046.0, -206.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2046.0, -210.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2052.0, -210.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2046.0, -214.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2052.0, -214.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2046.0, -218.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2052.0, -218.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2049.0, -219.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
	}
	else if (element == 4)
	{
    	AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2050.0, -135.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2050.0, -138.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2053.0, -135.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2056.0, -135.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2056.0, -138.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2050.0, -141.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2056.0, -141.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2053.0, -155.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2051.0, -155.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2049.0, -155.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2047.0, -155.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2053.0, -169.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2055.0, -169.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2057.0, -169.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2059.0, -169.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2053.0, -183.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2051.0, -183.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2049.0, -183.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2047.0, -183.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2053.0, -196.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2057.5, -203.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2054.5, -205.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2051.5, -205.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2048.5, -203.0, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2059.0, -199.5, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1238, -2047.0, -199.5, 34.6, 0.0, 0.0, 0.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1652, -2060.0, -155.0, 35.0, 0.0, 0.0, 90.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1652, -2060.0, -183.0, 35.0, 0.0, 0.0, 90.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1652, -2046.0, -155.0, 35.0, 0.0, 0.0, 90.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(1652, -2046.0, -183.0, 35.0, 0.0, 0.0, 90.0, vw, -1, playerid);
	}
	else if (element == 5)
	{
        AS_Objects[playerid][obj++] = CreateDynamicObject(3080, -2047.0 ,-180.0, 35.5, 0.0, 0.0, 180.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(13591, -2047.0, -200.0, 34.7 , 0.0, 0.0, 90.0, vw, -1, playerid);
		AS_Objects[playerid][obj++] = CreateDynamicObject(13591, -2047.0, -230.0, 34.7, 0.0, 0.0, 270.0, vw, -1, playerid);
	}

	// StartASElement
	new string[1024], str[64];
	format(str, sizeof(str), ""MAIN_COLOR"Автошкола [%s]", AS_Mission[element][AS_Name]);
	format(string, sizeof(string),	"\n{FFFFFF}%s\n\n\
		"MAIN_COLOR"Для начала выполнения, заведите двигатель автомобиля!", AS_Mission[element][AS_Descrip]);
	MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, str, string, "Закрыть");
	PlayerBusy{playerid} = true;
	AS_OldAngel[playerid] = AS_Mission[element][AS_StartPos][3];
	AS_ElementNumber[playerid] = element + 1;
	AS_Time[playerid] = AS_Mission[element][AS_RunTime] * 1000;
	AS_Check[playerid] = 0;
	AS_Vehicle[playerid] = MyCreateVehicle(AS_Mission[element][AS_Veh], Arr4<AS_Mission[element][AS_StartPos]>, 3, 3);
	CarInfo[AS_Vehicle[playerid]][cOwnerID] = playerid;
	SetVehicleVirtualWorld(AS_Vehicle[playerid], vw);
	SetPlayerVirtualWorld(playerid, vw);
	MyPutPlayerInVehicle(playerid, AS_Vehicle[playerid], 0);
	SetPlayerInterior(playerid, 0);
	SetPlayerWeather(playerid, 1);
	return (1);
}

Public: ChangePlayerASStatus(playerid, status)
{
	new element;
	
	element = AS_ElementNumber[playerid] - 1;
	if (element < 0)
		return GMError(playerid, "ChangePlayerASStatus #0");
	//	При смерти скидываем ТАЙМЕР
	if (GetPlayerState(playerid) == PLAYER_STATE_WASTED)
	{
		KillTimer(AS_Timer[playerid]), AS_Timer[playerid] = 0;
		HidePlayerVisualTimer(playerid);
		GameTextForPlayer(playerid, RusText("~r~Миссия провалена~n~", isRus(playerid)), 5000, 4);
		return true;
	}
	// Начал выполнение
	if (status == AUTOSCHOOL_START)
	{
		if (AS_Timer[playerid] == 0)
		{
			AS_Timer[playerid] = SetTimerEx("ChangePlayerASStatus", AS_TIMER_UPDATE, true, "ii", playerid, AUTOSCHOOL_PASSAGE);
			if (AS_Mission[element][AS_CP])
				MySetPlayerCheckpoint(playerid, CPMODE_NONE, Arr3<AS_Mission[element][AS_CheckPos]>, 3.0);
		}
	}

	// Выполняет
	else if (status == AUTOSCHOOL_PASSAGE)
	{
        new Float:angel;
        GetVehicleZAngle(AS_Vehicle[playerid], angel);
        if (AS_ElementNumber[playerid] == 1)	// Элемент '360 градусов'
		{
            if (AS_Check[playerid] == 0)	// Прошел половину
			{
				if (300.0 < AS_OldAngel[playerid] < 360.0 && 0.0 < angel < 60.0)
					AS_Check[playerid] = 1;
				else if (0.0 < AS_OldAngel[playerid] < 60.0 && 300.0 < angel < 360.0)
					AS_Check[playerid] = 2;
			}
            else if (AS_Check[playerid] == 1 && AS_Mission[0][AS_FinishPos][3] <= angel
				&& angel < AS_Mission[0][AS_FinishPos][3] + 20.0
				&& AS_OldAngel[playerid] < AS_Mission[0][AS_FinishPos][3])
			{
                return ChangePlayerASStatus(playerid, AUTOSCHOOL_FINISH);
			}
			else if (AS_Check[playerid] == 2 && AS_Mission[0][AS_FinishPos][3] - 20.0 < angel
				&& angel <= AS_Mission[0][AS_FinishPos][3]
				&& AS_OldAngel[playerid] > AS_Mission[0][AS_FinishPos][3])
			{
				return ChangePlayerASStatus(playerid, AUTOSCHOOL_FINISH);
			}
            AS_OldAngel[playerid] = angel;
		}
		else
		{
		    if (AS_Check[playerid] == 0
				&& GetDistanceFromMeToPoint(playerid, Arr3<AS_Mission[element][AS_CheckPos]>) <= 4.0)
			{
				if (AS_ElementNumber[playerid] == 4)	// Элемент 'Управляемый занос'
				{
					new vStatus[4]; // Прокалываем шины
					GetVehicleDamageStatus(AS_Vehicle[playerid], Arr4<vStatus>);
					UpdateVehicleDamageStatus(AS_Vehicle[playerid], Arr3<vStatus>, 0001);
				}
				AS_Check[playerid] = 1;	// Доехал до поворота
				if (AS_Mission[element][AS_CP])
					MySetPlayerCheckpoint(playerid, CPMODE_NONE, Arr3<AS_Mission[element][AS_FinishPos]>, 3.0);
			}
			if (AS_Check[playerid] > 0
				&& GetDistanceFromMeToPoint(playerid, Arr3<AS_Mission[element][AS_FinishPos]>) <= 4.0)
			{
				if (AS_Mission[element][AS_CheckSpeed] == false || GetVehicleSpeed(AS_Vehicle[playerid]) < 5)
				{
					if (AS_Mission[element][AS_CP])
						MyDisablePlayerCheckpoint(playerid);
					if (AS_Mission[element][AS_FinishPos][3] != 999.0)
					{
						if (angel < 180 && AS_Mission[element][AS_FinishPos][3] + 20 > 360)
				    		angel += 360;
						if (AS_Mission[element][AS_FinishPos][3] - 20 <= angel
							&& angel <= AS_Mission[element][AS_FinishPos][3] + 20)
	                		return (ChangePlayerASStatus(playerid, AUTOSCHOOL_FINISH));
	                }
					else
						return (ChangePlayerASStatus(playerid, AUTOSCHOOL_FINISH));
				}
			}
		}
		AS_Time[playerid] -= AS_TIMER_UPDATE;
		SetPlayerVisualTimer(playerid, (AS_Time[playerid] / 1000 + 1), false);
        if (AS_Time[playerid] <= 0)	// Вышло время
        {
            return (ChangePlayerASStatus(playerid, AUTOSCHOOL_FINISH));
        }
	}
	// Закончил выполнение
	else if (status == AUTOSCHOOL_FINISH)
	{
		new Float:angel;
        GetVehicleZAngle(AS_Vehicle[playerid], angel);
        if (AS_ElementNumber[playerid] == 1
        	&& ((AS_Check[playerid] == 1 && 
				(angel < AS_Mission[0][AS_FinishPos][3]
				|| AS_OldAngel[playerid] >= AS_Mission[0][AS_FinishPos][3]))
			|| (AS_Check[playerid] == 2 && 
				(angel > AS_Mission[0][AS_FinishPos][3] 
				|| AS_OldAngel[playerid] <= AS_Mission[0][AS_FinishPos][3]))))
		{
	        GameTextForPlayer(playerid, RusText("~r~Миссия провалена~n~~w~Задание не выполнено", isRus(playerid)), 2000, 4);
		}
		else if (AS_Check[playerid] == 0
			|| GetDistanceFromMeToPoint(playerid, Arr3<AS_Mission[element][AS_FinishPos]>) > 4.0)
		{
			GameTextForPlayer(playerid, RusText("~r~Миссия провалена~n~~w~Задание не выполнено", isRus(playerid)), 2000, 4);
		}
		else
		{
			new Float:health;
	    	GetVehicleHealth(AS_Vehicle[playerid], health);
			if (health < (990 - AS_Mission[element][AS_Damage]))
			{
				GameTextForPlayer(playerid, RusText("~r~Миссия провалена~n~~w~Автомобиль поврежден", isRus(playerid)), 2000, 4);
			}
			else
			{
				GameTextForPlayer(playerid, RusText("~g~Миссия выполнена", isRus(playerid)), 2000, 4);
				PlayerInfo[playerid][pASElement] |= 0x1 << AS_ElementNumber[playerid];
				UpdatePlayerBitData(playerid, "as_element", PlayerInfo[playerid][pASElement]);
			}
		}
		AS_ReturnInAS(playerid);
	}
	return (1);
}

AS_ReturnInAS(playerid)
{
	HidePlayerVisualTimer(playerid);
	KillTimer(AS_Timer[playerid]), AS_Timer[playerid] = 0;
	SetVehicleSpeed(AS_Vehicle[playerid], 5.0);
	MySetPlayerPosFade(playerid, FT_AUTOSCHOOL, -2026.77, -114.345, 1035.172, 1.0, false, 3, VW_AUTOSCHOOL);
}

AS_ClearVars(playerid)
{
	if (AS_ElementNumber[playerid])
	{	// Обнуление значений
		MyDisablePlayerCheckpoint(playerid);
		SetCameraBehindPlayer(playerid);
		MyDestroyVehicle(AS_Vehicle[playerid]), AS_Vehicle[playerid] = 0;
		KillTimer(AS_Timer[playerid]), AS_Timer[playerid] = 0;
		AS_ElementNumber[playerid] = 0;
		AS_Time[playerid] = 0;
		AS_Check[playerid] = 0;
		AS_OldAngel[playerid] = 0.0;
		PlayerBusy{playerid} = false;
		for(new i = 0; i < sizeof(AS_Objects[]); i++)
		{
			DestroyDynamicObject(AS_Objects[playerid][i]);
			AS_Objects[playerid][i] = INVALID_STREAMER_ID;
		}
	}
	return (1);
}