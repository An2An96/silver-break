#if defined _player_header_included
	#endinput
#endif
#define _player_header_included

#define isRus(%0)		PlayerInfo[%0][pRusifik]

enum E_PLAYER
{
	ORM:ORM_ID,	//  Ид соединения
	pUserID,	//  Ид аккаунта в общей базе (UCP)

	pLevel,		// Уровень
	pExp,       // Опыт
	pVip,		// Премиум аккаунт
	pVipUNIX,	// Время истечения премиума
	pSex,		// Пол
	pSkin,		// Личный скин
	pMoney,		// Деньги
	pWantedLvl,	// Уровень розыска
	pFaction,	// Номер организации работы
	pLeader,	// UNIX время начала лидерки (Лидер если больше нуля!)
	pRank,		// Ранг в организации
	pCopWarn,   // Предупреждения копа
	pCopCases,  // Выполненные дела копа
	pSpawn,		// Где спавнится
	Float:pPosX,// Позиции выхода:
	Float:pPosY,//  -//-
	Float:pPosZ,//  -//-
	Float:pPosA,//  -//-
	pPosINT,    //  -//-
	pPosVW,     //  -//-
	pExitUNIX,  // Время выхода
	pJailTime,  // Тюремный срок (Меньше нуля - КПЗ(-wl); Больше нуля - Тюрьма(jailtime))
	pAJailTime,	// Срок наказания (Админ тюрьма)
	pWarns,     // Предупреждения
	pWarnUNIX,  // Время последнего врана
	pAskMute,   // Время блокировки связи с админами (Содержит UNIX время, до которого забанен)
	pMuteTime,  // Время молчанки (Забанен в чате [> 0], Не забанен в чате [= 0])
	pAdmin,     // Уровень админа
	pBanUNIX,   // Время бана
	pHousing,   // Место жительства (Дом [houseid > 0], Отсутствует [= 0])
	pRent,		// Ид арендуемого дома (Отель [hotel < 0], Отсутствует [= 0], Дом [houseid > 0])
	pPaymentDays,		// Количество оплаченых дней для аренды
	pCensored,  		// Настр.: Цензура
	pLaw,				// Законопослушность (от -50 до 50)
	Float:pBank,		// Счет в банке (GivePlayerBank)
	Float:pCrimeWage,	// Счетчик криминального заработка (ограбления, деньги с тер-ий)
	pEmployer,  		// Предприниматель
	pUpgrade,   		// Очки навыков
	Float:pRunCar,		// Пробег на авто
	Float:pSaveHealth,	// Спаун здоровье
	Float:pSaveArmour,	// Спаун броня
	pHunger,			// Голод
	pPhoneNumber,		//	Номер мобильного телефона (0-телефона нет)
	Float:pPhoneBalance,//	Баланс телефона
	bool:pPhoneEnable,	//	Включен/выключен телефон
	pCarLicA,			//	Права категории A (мотоциклы, мопеды)
	pCarLicB,			//	Права категории B (автомобили)
	pCarLicC,			//	Права категории C (грузовики)
	pCarLicD,			//	Права категории	D (автобусы)
	pCarLic,		// Лицензия на вождение
	pGunLic,    	// Разрешение на оружие
	pTheftTime,     // UNIX время последней доставки угнанного авто (когда = 0, то не будет уведомления о перезарядки)
	pASElement,		// Элементы пройденые в автошколе
	pTaxiLevel,		// Уровень работы таксистом
	pTaxiSkill,		// Скилл работы таксистом
	pBusLevel,		// Уровень работы водителя автобуса
	pBusSkill,		// Скилл работы водителя автобуса
	pTruckLevel,	// Уровень работы дальнобойщиком
	pTruckSkill,	// Скилл работы дальнобойщиком
	pNewsUnix,      // Время первого объявления (в час)
	pNewsCount,     // Количество объявлений (в час)
	pKills,     	// Количество убийств
	pDeaths,    	// Количество смертей
	pExpsum,		// Сумма полученного опыта
	bool:pRusifik,		// Наличие русификатора
	bool:pInterface,	// Статус интерфейса игрока
	bool:pLowerPanel,	// Статус нижней панели интерфейса
	bool:pHouseIcon,	// Отображение иконок домов
	bool:pToggleZone,	// Отображение ганг-зон
	Float:pPower,   	// Сила игрока
	pTraining,      	// Кол-во упражнений сделаных игроком (обнуляется каждый час)
	pShooting,			// Статус тира
	pWalk,				// Походка игрока
	pAnim,				// Ид личной анимации (0 - нет)
	pLearnFStyle,		// Изученые стили боя
	pFightStyle,		// Стиль боя
	pGametime,			// Сколько минут отыгранно за последний час

	//	Not Saved
	pNextFriskTime,		// Время последнего обыска
};
new PlayerInfo[MAX_PLAYERS][E_PLAYER];