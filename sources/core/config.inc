//----------[Параметры сервера]----------//
#undef MAX_PLAYERS
#undef MAX_VEHICLES
#define MAX_NPC				3      			// Слоты для ботов
#define MAX_PLAYERS			500 + MAX_NPC	// Количество игроков
#define MAX_VEHICLES		2000			// Количество транспорта

#define GAMEMODE_NAME 		"v3.1.0"
#define SITE_ADRESS 		"s-break.ru" 	// Адрес сайта
#define GM_FOLDER 			"gm_data/"		// Папка с файлами необходимыми для мода
#define AUDIOFILE_PATH		"http://164.177.176.44:3000/audio"
#define DONATE_URL			"http://ucp.s-break.ru/donate"

//--------------[Mail Settings]-----------//
#define SECRET_CODE			"8ZsAm90e8ahunJL4ENIsFo0Dr"
#define CONFIRM_MAIL_URL	"ucp.s-break.ru/account/set_mail"

//-------------[MySQL Date Base]----------//
#define MYSQL_LOG			(ERROR | WARNING)

//#define MYSQL_LOCAL
#if defined MYSQL_LOCAL
	//	Для входа:	127.0.0.1/phpmyadmin/
	#define MYSQL_HOST		"127.0.0.1"
	#define MYSQL_USER 		"root"
	#define MYSQL_PASS 		""
	#define MAIN_DB 		"sb_main"
	// #define MYSQL_HOST		"51.68.137.210"
	// #define MYSQL_USER 		"root"
	// #define MYSQL_PASS 		"(Z=y,i7_Gj4UBK$6an"
	// #define MAIN_DB 		"samp_main"
#else
	//	Для входа:	http://213.32.88.126/phpmyadmin
	#define MYSQL_HOST		"127.0.0.1"
	#define MYSQL_USER 		"root"
	#define MYSQL_PASS 		"(Z=y,i7_Gj4UBK$6an"
	#define MAIN_DB 		"samp_main"
#endif

new SERVER_ID = INVALID_DATA;
new ADMIN_PASS[24];		// Админ пароль для админ-деружства
new bool:ANTICHEAT;		// Включен ли античит по умолчанию
new bool:HEADSHOT;		// Хедшоты (0 выкл, 1 вкл)
new bool:REGISTER;		// Регистрации на сервере (0 выкл, 1 вкл)
new bool:LOGTIMEOUT;	// Таймаут авторизации (0 выкл, 1 вкл)
new bool:AUTOADMIN;		// Автоматический выход на админ дежурство (0 выкл, 1 вкл)
new bool:TOGOOC;		// Общий чат (0 выкл, 1 вкл)
new bool:RESTSPAWNDROP;	// Сброс позиции игрока после рестарта

LoadSettings()
{
	new File = ini_openFile(GM_FOLDER"settings.ini");
	if(File < 0)
	{
		return false;
	}
	ini_getInteger(File, "server_id", SERVER_ID);
	ini_getString(File, "aduty_pass", ADMIN_PASS);
	ini_getInteger(File, "anticheat", ANTICHEAT);
	ini_getInteger(File, "headshot", HEADSHOT);
	ini_getInteger(File, "register", REGISTER);
	ini_getInteger(File, "logtimeout", LOGTIMEOUT);
	ini_getInteger(File, "autoadmin", AUTOADMIN);
	ini_getInteger(File, "togooc", TOGOOC);
	ini_getInteger(File, "restspawndrop", RESTSPAWNDROP);
	ini_closeFile(File);
	return true;
}