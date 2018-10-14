#if defined _player_phone_included
	#endinput
#endif

#define _player_phone_included

#define PHONE_BASE_POS_X	35.0
#define PHONE_BASE_POS_Y	305.0

#define COST_PHONE_CALL 		5.0 	// Стоимость минуты разговора по телефону
#define COST_PHONE_SMS  		1.0 	// Стоимость СМС

forward OnPlayerPhoneCall(playerid, number);

// 	0 - ид кто звонит/кому звонишь/с кем говоришь
// 	1 - статус звонка
// 	2 - Дополнительный параметр (	при звонке хранит время вызова (для автосброса)
//									при разговоре хранит время разговора в секундах )
enum
{
	PHONE_OFF,		//	без звонка
	PHONE_WAIT,		//	ты позвонил и ждешь
	PHONE_CALL,		//	тебе звонят
	PHONE_SPEAK,	//	ты позвонил и вы разговариваете
	PHONE_ANSWER	//	тебе позвонили и вы разговариваете
}
new call_phone[MAX_PLAYERS][3];
new SMS_Buffer[MAX_PLAYERS][12][128]; // смс игрока
static phone_anim_ellipsis[MAX_PLAYERS char]; // кол-во точек для экрана (для анимированого вызова)
static phoneAction[MAX_PLAYERS];
static Text:phone_td[2];
static PlayerText:p_phone_td;

stock Phone_CallTimer(playerid)
{
	new i = playerid;
	if(call_phone[i][0] != -1)
	{
		new string[128];
		call_phone[i][2]++;
	    if(call_phone[i][1] == PHONE_WAIT)
		{	//  ты звонишь
	        if(++phone_anim_ellipsis{i} >= 3) 		phone_anim_ellipsis{i} = 0;
			if(phone_anim_ellipsis{i} == 0)  		strput(string, "Исходящий вызов.");
			else if(phone_anim_ellipsis{i} == 1) 	strput(string, "Исходящий вызов..");
			else if(phone_anim_ellipsis{i} == 2) 	strput(string, "Исходящий вызов...");
			format(string, sizeof(string), "%s~n~%s~n~Номер: %d", string, ReturnPlayerName(call_phone[i][0]), PlayerInfo[call_phone[i][0]][pPhoneNumber]);
		}
		else if(call_phone[i][1] == PHONE_CALL)
		{	//  тебе звонят
			if(call_phone[i][2] >= 60)
			{
				SendFormatMessage(call_phone[i][0], COLOR_WHITE, string, PREFIX_PHONE "%s (%d) не отвечает", ReturnPlayerName(i), PlayerInfo[i][pPhoneNumber]);
				return _ClearCall(i);
			}
			else
			{
		        if(++phone_anim_ellipsis{i} >= 3) 		phone_anim_ellipsis{i} = 0;
				if(phone_anim_ellipsis{i} == 0) 		strput(string, "Входящий вызов.");
				else if(phone_anim_ellipsis{i} == 1) 	strput(string, "Входящий вызов..");
				else if(phone_anim_ellipsis{i} == 2) 	strput(string, "Входящий вызов...");
				format(string, sizeof(string), "%s~n~%s~n~Номер: %d", string, ReturnPlayerName(call_phone[i][0]), PlayerInfo[call_phone[i][0]][pPhoneNumber]);
            }
		}
		else if(call_phone[i][1] == PHONE_SPEAK)
		{	//  разговор
	    	if(PlayerInfo[i][pPhoneBalance] <= 0.0)
	    	{
	    		SendClientMessage(i, COLOR_WHITE, PREFIX_PHONE "На счету вашего телефона не хватает средств, звонок прерван");
	    		SendClientMessage(call_phone[i][0], COLOR_WHITE, PREFIX_PHONE "У вашего собеседника закончились деньги на счету, звонок прерван");
	    		return _ClearCall(i);
	    	}
	    	else
	    	{
	    		PlayerInfo[i][pPhoneBalance] -= (COST_PHONE_CALL / 60);
				format(string, sizeof(string), "%02d:%02d~n~%s~n~Номер: %d", call_phone[i][2] / 60, call_phone[i][2] % 60, ReturnPlayerName(call_phone[i][0]), PlayerInfo[call_phone[i][0]][pPhoneNumber]);
	    	}
	    }
		else if(call_phone[i][1] == PHONE_ANSWER)
		{
			format(string, sizeof(string), "%02d:%02d~n~%s~n~Номер: %d", call_phone[i][2] / 60, call_phone[i][2] % 60, ReturnPlayerName(call_phone[i][0]), PlayerInfo[call_phone[i][0]][pPhoneNumber]);
		}
		IFace.Phone_Update(i, string);
	}
	return true;
}

stock 	StartCall(playerid, targetid)
{	//  Phone call
	//	targetid
	if(PlayerInfo[targetid][pPhoneNumber] == 0)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У этого игрока нет мобильного телефона.");
	}
	if(PlayerInfo[targetid][pJailTime])
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете позвонить заключенному.");
	}
	if(call_phone[targetid][0] != (-1))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Абонент занят.");
	}
	if(PlayerInfo[targetid][pPhoneEnable] == false)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Аппарат абонента выключен или находится вне зоны действия сети.");
	}
	new string[128];
	//  Set Vars
	call_phone[playerid][0] = targetid;	call_phone[playerid][1] = PHONE_WAIT;	call_phone[playerid][2] = 0;
	call_phone[targetid][0]	= playerid;	call_phone[targetid][1]	= PHONE_CALL;	call_phone[targetid][2] = 0;
	//  Message
	PlayerAction(playerid, "достает телефон и начинает звонить.");
	SendFormatMessage(targetid, COLOR_WHITE, string, PREFIX_PHONE "Вам звонит %s (%d) " ASK_CONFIRM_INFO, ReturnPlayerName(call_phone[targetid][0]), PlayerInfo[ call_phone[targetid][0] ][pPhoneNumber]);
	//  ShowPhone
	IFace.Phone_Show(playerid, 1);
	IFace.Phone_Show(targetid, 2);
	MyApplyAnimation(playerid, "ped", "phone_in", 4.1, 0, 1, 1, 1, 1);//  Set Anim
    //  Sound
    PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);  // 20804
    PlayerPlaySound(targetid, 20600, 0.0, 0.0, 0.0);  // 20804
	return true;
}

stock SendSMS(playerid, targetid, text[], bool:actor = false)
{// playerid - отправитель
	new stmp[128];
	for(new i = 10; i >= 0; i--)
        strmid(SMS_Buffer[targetid][i + 1], SMS_Buffer[targetid][i], 0, 128, 255);
	strmid(SMS_Buffer[targetid][0], text, 0, strlen(text), 255);
	if(actor == false)
		SendFormatMessage(playerid, COLOR_YELLOW, stmp, "[SMS] » %s[%d][%d]: %s", ReturnPlayerName(targetid), targetid, PlayerInfo[targetid][pPhoneNumber], SMS_Buffer[targetid][0]);
	PlayerPlaySound(playerid, 5201, 0.0, 0.0, 0.0);	// Исходящая
    if(PlayerInfo[targetid][pPhoneEnable])
    {
        if(actor)
        {
        	SendFormatMessage(targetid, COLOR_YELLOW2, stmp, "[SMS] « %s: %s", ReturnActorName(playerid), SMS_Buffer[targetid][0]);
        }
		else
		{
			if(!PlayerInfo[playerid][pVip]) PlayerInfo[playerid][pPhoneBalance] -= COST_PHONE_SMS;
	        SendFormatMessage(targetid, COLOR_YELLOW2, stmp, "[SMS] « %s[%d][%d]: %s", ReturnPlayerName(playerid), playerid, PlayerInfo[playerid][pPhoneNumber], SMS_Buffer[targetid][0]);
			if(IsPlayerAFK(targetid))
			{
				SendClientMessage(playerid, COLOR_WHITE, "Игрок, которому вы отправляете смс, находится в AFK.");
			}

		}
		PlayerPlaySound(targetid, 5202, 0.0, 0.0, 0.0);// Входящая
	}
	PlayerAction(playerid, "набирает смс сообщение.");
	return true;
}

Phone_CancelCall(playerid)
{
	if(call_phone[playerid][0] != -1)
	{
	    if(call_phone[playerid][1] == PHONE_SPEAK || call_phone[playerid][1] == PHONE_ANSWER)
		{
			new string[64];
			SendFormatMessage(call_phone[playerid][0], COLOR_WHITE, string, PREFIX_PHONE "Разговор с %s (%d) прервался.", ReturnPlayerName(playerid), PlayerInfo[playerid][pPhoneNumber]);
		}
		_ClearCall(playerid);
	}
	return true;
}

Phone_GetSpeaker(playerid)	return call_phone[playerid][0];
Phone_GetStatus(playerid)	return call_phone[playerid][1];

Phone_ZeroVars(playerid)
{
	call_phone[playerid][0] = -1;
	call_phone[playerid][1] = PHONE_OFF;
	call_phone[playerid][2] = 0;
}

stock CreatePhoneNumber()
{
	new n = 6, counts = 0, number;
	while(n < 10)
	{
	    number = 1 + random(9); // Первая цифра номера не 0
		if(counts++ == 15)	
		{	
			n++;	
			counts = 0;	
		}
	    for(new i = 1; i < n; i++)	number = number * 10 + random(10);
		if(!_CheckPhoneNumber(number)) return number;
	}
	return 0;
}

//////////	Private //////////
static _ClearCall(playerid)
{	//  cancel call
	//  Clear Sound
	new targetid = call_phone[playerid][0];
	PlayerPlaySound(targetid, 0, 0.0, 0.0, 0.0);
	PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
	//  Clear Anim
	MyApplyAnimation(targetid, "ped", "phone_out", 4.1, 0, 1, 1, 1, 1);
	MyApplyAnimation(playerid, "ped", "phone_out", 4.1, 0, 1, 1, 1, 1);
	//  Hide Phone
	IFace.Phone_Hide(targetid);
	IFace.Phone_Hide(playerid);
	//  Clear Vars
	call_phone[targetid][0] = -1;	call_phone[targetid][1] = PHONE_OFF;
	call_phone[playerid][0] = -1;	call_phone[playerid][1] = PHONE_OFF;
	return true;
}

static _CheckPhoneNumber(number)
{
	new query[128];
	mysql_format(g_SQL, query, sizeof(query), "SELECT `id` FROM `players` WHERE `p_number` = '%d'", number);
	new Cache:result = mysql_query(g_SQL, query);
	if(cache_num_rows() > 0)
	{
	    new id;
	    cache_get_value_name_int(0, "id", id);
  		cache_delete(result);
  		return id;
	}
	cache_delete(result);
	return 0;
}

//////////	IFace	//////////
stock IFace.Phone_Show(playerid, status)
{
	IFace.ToggleGroup(playerid, IFace.PHONE, true);

	new stmp[128];
	new giveplayerid = call_phone[playerid][0];
	if(status == 1)		// ты звонишь
	{
		format(stmp, 128, "Исходящий вызов...~n~%s~n~Номер: %d", ReturnPlayerName(giveplayerid), PlayerInfo[giveplayerid][pPhoneNumber]);
	}
	else if(status == 2)	//  тебе звонят
	{
		format(stmp, 128, "Входящий вызов...~n~%s~n~Номер: %d", ReturnPlayerName(giveplayerid), PlayerInfo[giveplayerid][pPhoneNumber]);
	}
	else if(status == 3)	//  разговор
	{
		format(stmp, 128, "00:00~n~%s~n~Номер: %d", ReturnPlayerName(giveplayerid), PlayerInfo[giveplayerid][pPhoneNumber]);
	}
	if(strlen(stmp))
	{
		IFace.Phone_Update(playerid, stmp);
	}
	return true;
}

stock IFace.Phone_Update(playerid, text[])
{
	if(IFace.GetGroupToggleAndVisible(playerid, IFace.PHONE))
	{
		PlayerTextDrawSetString(playerid, p_phone_td, RusText(text, isRus(playerid)));
		PlayerTextDrawShow(playerid, p_phone_td);
	}
}

stock IFace.Phone_Hide(playerid)
{
	IFace.ToggleGroup(playerid, IFace.PHONE, false);
	return true;
}

Public: IFace.Phone_Toggle(playerid, bool:toggle)
{
	if(toggle)
	{
		TextDrawShowForPlayer(playerid, phone_td[0]);
		TextDrawShowForPlayer(playerid, phone_td[1]);
	}
	else
	{
		TextDrawHideForPlayer(playerid, phone_td[0]);
	 	TextDrawHideForPlayer(playerid, phone_td[1]);
		PlayerTextDrawHide(playerid, p_phone_td);
	}
}

IFace.Phone_Load_Base()
{
	phone_td[0] = TextDrawCreate(PHONE_BASE_POS_X, PHONE_BASE_POS_Y, "1");
	TextDrawBackgroundColor(phone_td[0], 255);
	TextDrawFont(phone_td[0], 1);
	TextDrawLetterSize(phone_td[0], 0.0, 3.0999);
	TextDrawColor(phone_td[0], -1);
	TextDrawSetOutline(phone_td[0], 0);
	TextDrawSetProportional(phone_td[0], 1);
	TextDrawSetShadow(phone_td[0], 0);
	TextDrawUseBox(phone_td[0], 1);
	TextDrawBoxColor(phone_td[0], INTERFACE_MAIN_COLOR);
	TextDrawTextSize(phone_td[0], 150.0, 110.0);

	phone_td[1] = TextDrawCreate(PHONE_BASE_POS_X - 25.0, PHONE_BASE_POS_Y - 5.0, "1");
	TextDrawAlignment(phone_td[1], 2);
	TextDrawBackgroundColor(phone_td[1], 0x00000000);
	TextDrawFont(phone_td[1], 5);
	TextDrawUseBox(phone_td[1], 1);
	TextDrawBoxColor(phone_td[1], 0x00000000);
	TextDrawTextSize(phone_td[1], 40.0, 40.0);
	TextDrawLetterSize(phone_td[1], 0.0, 0.0);
	TextDrawSetPreviewModel(phone_td[1], 18871);
	TextDrawSetPreviewRot(phone_td[1], 90.0, 181.0, 0.0, 0.8);
}

IFace.Phone_Load_Player(playerid)
{
	p_phone_td = CreatePlayerTextDraw(playerid, PHONE_BASE_POS_X + 15.0, PHONE_BASE_POS_Y, "text");
	PlayerTextDrawBackgroundColor(playerid, p_phone_td, 255);
	PlayerTextDrawFont(playerid, p_phone_td, 1);
	PlayerTextDrawLetterSize(playerid, p_phone_td, 0.23, 0.899);
	PlayerTextDrawColor(playerid, p_phone_td, -1);
	PlayerTextDrawSetOutline(playerid, p_phone_td, 0);
	PlayerTextDrawSetProportional(playerid, p_phone_td, 1);
	PlayerTextDrawSetShadow(playerid, p_phone_td, 0);
}

//////////	Dialogs 	//////////
DialogCreate:Phone_Main(playerid)	//	DPHONE_MAIN
{
	if(PlayerInfo[playerid][pPhoneNumber] == 0)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас нет телефона.");
    if(PlayerInfo[playerid][pJailTime])
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете пользоваться телефоном в тюрьме.");
	new string[256];
	new stmp[128];
	new clickedplayerid = (GetPVarType(playerid, "Phone:ClickPlayer") == PLAYER_VARTYPE_NONE) ? INVALID_PLAYER_ID : GetPVarInt(playerid, "Phone:ClickPlayer");
    if(clickedplayerid == INVALID_PLAYER_ID)
	{
		if(PlayerInfo[playerid][pPhoneEnable])
		{
			strcat(string, ""MAIN_COLOR"• {FFFFFF}Позвонить\n\
							"MAIN_COLOR"• {FFFFFF}Отправить СМС\n\
							"MAIN_COLOR"• {FFFFFF}Принятые СМС\n\
							"MAIN_COLOR"• {FFFFFF}Баланс телефона\n\
							"MAIN_COLOR"• {FFFFFF}Выключить телефон");
			format(stmp, sizeof stmp, "{FFFFFF}Телефон [Номер: {88AA88}%d{FFFFFF}]", PlayerInfo[playerid][pPhoneNumber]);
		}
		else
		{
			strcat(string, ""MAIN_COLOR"• {AFAFAF}Позвонить\t\t[Недоступно]\n\
							"MAIN_COLOR"• {AFAFAF}Отправить СМС\t[Недоступно]\n\
							"MAIN_COLOR"• {AFAFAF}Принятые СМС\t[Недоступно]\n\
							"MAIN_COLOR"• {AFAFAF}Баланс телефона\t[Недоступно]\n\
							"MAIN_COLOR"• {FFFFFF}Включить телефон");
			format(stmp, sizeof stmp, "{FFFFFF}Телефон [Номер: {88AA88}%d{FFFFFF}][{88AA88}Выключен{FFFFFF}]", PlayerInfo[playerid][pPhoneNumber]);
		}
	}
	else
	{
		if(PlayerInfo[playerid][pPhoneEnable] && PlayerInfo[clickedplayerid][pPhoneNumber] && PlayerInfo[clickedplayerid][pPhoneEnable])
		{
			strcat(string, ""MAIN_COLOR"• {FFFFFF}Позвонить\n\
							"MAIN_COLOR"• {FFFFFF}Отправить СМС\n\
							"MAIN_COLOR"• {FFFFFF}Принятые СМС\n\
							"MAIN_COLOR"• {FFFFFF}Баланс телефона\n\
							"MAIN_COLOR"• {FFFFFF}Выключить телефон");
			format(stmp, sizeof stmp, "{FFFFFF}Телефон [Номер: {88AA88}%d{FFFFFF}]", PlayerInfo[clickedplayerid][pPhoneNumber]);
		}
		else
		{
			strcat(string, ""MAIN_COLOR"• {AFAFAF}Позвонить\t\t[Недоступно]\n\
							"MAIN_COLOR"• {AFAFAF}Отправить СМС\t[Недоступно]\n\
							"MAIN_COLOR"• {FFFFFF}Принятые СМС\n\
							"MAIN_COLOR"• {FFFFFF}Баланс телефона\n");
			if(PlayerInfo[playerid][pPhoneEnable])
				strcat(string, ""MAIN_COLOR"• {FFFFFF}Выключить телефон");
			else
				strcat(string, ""MAIN_COLOR"• {FFFFFF}Включить телефон");
			//	ДОРАБОТАТЬ
			format(stmp, sizeof stmp, "{FFFFFF}Телефон [Номер: {88AA88}%d{FFFFFF}][{88AA88}Недоступен{FFFFFF}]", PlayerInfo[clickedplayerid][pPhoneNumber]);
		}
	}
	Dialog_Open(playerid, Dialog:Phone_Main, DIALOG_STYLE_LIST, stmp, string, "Выбрать", ((openWithMenu[playerid]) ? ("Назад") : ("Закрыть")));
	return true;
}

DialogResponse:Phone_Main(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new string[128];
		new clickedplayerid = (GetPVarType(playerid, "Phone:ClickPlayer") == PLAYER_VARTYPE_NONE) ? INVALID_PLAYER_ID : GetPVarInt(playerid, "Phone:ClickPlayer");
		if(listitem == 0)
		{
		    if(PlayerInfo[playerid][pPhoneEnable] == false)
		    {
		        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Для звонков телефон должен быть включен.");
				return Dialog_Show(playerid, Dialog:Phone_Main);
		    }
			if(clickedplayerid != INVALID_PLAYER_ID)
			{
			    valstr(string, PlayerInfo[clickedplayerid][pPhoneNumber]);
				callcmd::call(playerid, string); // call
			}
			else
			{	// ввод номера
				phoneAction[playerid] = 1;
				return Dialog_Show(playerid, Dialog:Phone_EnterNumber);
			}
		}
		else if(listitem == 1)
		{	// sms
		    if(PlayerInfo[playerid][pPhoneEnable] == false)
		    {
		        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Для смс телефон должен быть включен.");
				return Dialog_Show(playerid, Dialog:Phone_Main);
		    }
		    if(clickedplayerid != INVALID_PLAYER_ID)
			{
				if(PlayerInfo[clickedplayerid][pPhoneNumber] == 0)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У этого игрока нет мобильного телефона.");
					return Dialog_Show(playerid, Dialog:Phone_Main);
				}
				return Dialog_Show(playerid, Dialog:Phone_Sms);
			}
			else
			{	//	ввод номера
				phoneAction[playerid] = 2;
				return Dialog_Show(playerid, Dialog:Phone_EnterNumber);
			}
		}
		else if(listitem == 2)
		{	//	список смс
		    if(PlayerInfo[playerid][pPhoneEnable] == false)
		    {
		        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Для просмотра смс телефон должен быть включен.");
				return Dialog_Show(playerid, Dialog:Phone_Main);
		    }
			return Dialog_Show(playerid, Dialog:Phone_SmsList);
		}
		else if(listitem == 3)
		{	//	баланс телефона
		    if(PlayerInfo[playerid][pPhoneEnable] == false)
		    {
		        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Для просмотра баланса телефон должен быть включен.");
				return Dialog_Show(playerid, Dialog:Phone_Main);
		    }
			SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_PHONE "Баланс вашего телефона: %.2f$.", PlayerInfo[playerid][pPhoneBalance]);
			return Dialog_Show(playerid, Dialog:Phone_Main);
		}
		else if(listitem == 4)
		{	//	выключить/включить телефон
			callcmd::togphone(playerid, string);
			return Dialog_Show(playerid, Dialog:Phone_Main);
		}
	}
	else if(openWithMenu[playerid])
	{
		openWithMenu[playerid] = false;
		ShowDialog(playerid, DMENU_MAIN);
	}
	DeletePVar(playerid, "Phone:ClickPlayer");
	return true;
}

DialogCreate:Phone_EnterNumber(playerid)
{
	if(phoneAction[playerid] == 1)
	{
		Dialog_Open(playerid, Dialog:Phone_EnterNumber, DIALOG_STYLE_INPUT, "Телефон - Ввод номера", "Введите номер телефона для смс:", "ОК", "Назад");
	}
	else if(phoneAction[playerid] == 2)
	{
		Dialog_Open(playerid, Dialog:Phone_EnterNumber, DIALOG_STYLE_INPUT, "Телефон - Ввод номера", "Введите номер телефона для звонка:", "ОК", "Назад");
	}
	return true;
}

DialogResponse:Phone_EnterNumber(playerid, response, listitem, inputtext[])	//case DPHONE_ENTER_NUMBER:
{
    if(response)
    {
    	new number = strval(inputtext);
		if(!(0 < strlen(inputtext) < 10) || number < 0 || number > 99999999)
		{
		    if(phoneAction[playerid] == 1)
		    {
		        return Dialog_Show(playerid, Dialog:Phone_EnterNumber);
		    }
		    else if(phoneAction[playerid] == 2)
		    {
            	return Dialog_Show(playerid, Dialog:Phone_EnterNumber);
		    }
			else
			{
			    return Dialog_Show(playerid, Dialog:Phone_Main);
			}
		}
	    if(phoneAction[playerid] == 1)
	    {
	    	new string[24];
		    valstr(string, number);
			return callcmd::call(playerid, string); // call
	    }
		foreach(LoginPlayer, i)
		{
			if(PlayerInfo[i][pPhoneNumber] == number)
			{
				if(phoneAction[playerid] == 2)
				{
			   		SetPVarInt(playerid, "Phone:SmsPlayer", i);
					return Dialog_Show(playerid, Dialog:Phone_Sms);
				}
			}
		}
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Аппарат абонента выключен или находится вне зоны действия сети.");
    }
    else
    {
		Dialog_Show(playerid, Dialog:Phone_Main);
    }
    return true;
}

DialogCreate:Phone_Sms(playerid, response, listitem, inputtext[])
{
	Dialog_Open(playerid, Dialog:Phone_Sms, DIALOG_STYLE_INPUT, "Телефон - СМС", "Введите текст сообщения:", "Отправить", "Назад");
	return true;
}

DialogResponse:Phone_Sms(playerid, response, listitem, inputtext[])	//case DPHONE_SMS:
{
	new clickedplayerid = (GetPVarType(playerid, "Phone:ClickPlayer") == PLAYER_VARTYPE_NONE) ? INVALID_PLAYER_ID : GetPVarInt(playerid, "Phone:ClickPlayer");
    if(response)
    {
    	new string[128];
		if(strlen(inputtext) == 0)
		{
            return Dialog_Show(playerid, Dialog:Phone_Sms);
		}
        if(clickedplayerid != INVALID_PLAYER_ID)
        {
            format(string, sizeof string, "%d %s", PlayerInfo[clickedplayerid][pPhoneNumber], inputtext);
		}
		else if(GetPVarType(playerid, "Phone:SmsPlayer") != PLAYER_VARTYPE_NONE)
		{
			format(string, sizeof string, "%d %s", PlayerInfo[GetPVarInt(playerid, "Phone:SmsPlayer")][pPhoneNumber], inputtext);
		}
		callcmd::sms(playerid, string);
    }
    else if(clickedplayerid != INVALID_PLAYER_ID)
	{
		Dialog_Show(playerid, Dialog:Phone_Main);
	}
    else
    {
    	Dialog_Show(playerid, Dialog:Phone_EnterNumber);
    }
    return true;
}

DialogCreate:Phone_SmsList(playerid)	//case DPHONE_SMS_LIST:
{
	/*for(new i = 0; i < sizeof(SMS_Buffer[]); i++)
    {
    	format(lstring, sizeof(lstring), "%s%s", lstring, SMS_Buffer[playerid][i]);
    }
    if(strlen(lstring) == 0)
    {
    	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас нет принятых СМС");
    	return ShowDialog(playerid, DPHONE_MAIN);
    }
    MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "Телефон - Принятые СМС", lstring, "Выбрать", "Назад");*/
    return Dialog_Show(playerid, Dialog:Phone_Main);
}

DialogResponse:Phone_SmsList(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new string[128];
		for(new i = 0; i < sizeof(SMS_Buffer[]); i++)
	    {
	    	if(i == listitem)
	    	{
	    		format(string, sizeof(string),
		    		"{FFFFFF}Отправитель: "MAIN_COLOR"Неизвестно\n\
		    		{FFFFFF}Время: "MAIN_COLOR"Неизвестно\n\
		    		{FFFFFF}Текст: "MAIN_COLOR"%s", SMS_Buffer[playerid][i]);
	    		break;
	    	}
	    }
		MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "Телефон - Принятые СМС", string, "Назад", "");
	}
	else
	{
		Dialog_Show(playerid, Dialog:Phone_Main);
	}
	return true;
}

DialogCreate:Phone_Pay(playerid)	//case DPHONE_PAY:
{
	new string[256];
	format(string, sizeof(string), "{FFFFFF}Вы хотите пополнить счет мобильного телефона\n\
									Текущий баланс: "MAIN_COLOR"$%.2f\n\n\
									{FFFFFF}Стоимость звонков: "MAIN_COLOR"$%.0f/мин.\n\
									{FFFFFF}Стоимость СМС: "MAIN_COLOR"$%.0f\n\n\
									{FFFFFF}Введите сумму которую хотите положить на счет:", PlayerInfo[playerid][pPhoneBalance], COST_PHONE_CALL, COST_PHONE_SMS);
	Dialog_Open(playerid, Dialog:Phone_Pay, DIALOG_STYLE_INPUT, "Баланс телефона", string, "Выбрать", "Назад");
	return true;
}

DialogResponse:Phone_Pay(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new string[128];
		new const money = strval(inputtext);
        if(!(0 < strlen(inputtext) < 10) || money <= 0)
        {
            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Введено некорректное значение.");
            return Dialog_Show(playerid, Dialog:Phone_Pay);
        }
        PlayerInfo[playerid][pPhoneBalance] += float(money);
        MyGivePlayerMoney(playerid, -money);
        SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_PHONE "Баланс телефона пополнен на %d$ ($%.2f).", money, PlayerInfo[playerid][pPhoneBalance]);
	}
	if(openWithATM[playerid])	ShowDialog(playerid, DMODE_ATM);
	else 						ShowDialog(playerid, DMODE_BANK);
	return true;
}

/////////	Commands	//////////
COMMAND:phone(playerid, params[])
{
	Dialog_Show(playerid, Dialog:Phone_Main);
	return true;
}

COMMAND:call(playerid, params[])
{
	if(PlayerInfo[playerid][pPhoneNumber] == 0)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас нет мобильного телефона.");
	}
	if(PlayerInfo[playerid][pPhoneEnable] == false)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ваш телефон выключен.");
	}
	if(PlayerInfo[playerid][pJailTime])
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ваш телефон изъят на время заключения.");
	}
	if(call_phone[playerid][0] != (-1) || call_phone[playerid][1] != PHONE_OFF)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ваш телефон уже занят другим вызовом.");
	}
	if(PlayerInfo[playerid][pPhoneBalance] <= 0)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "На счету недостаточно средств.");
	}
	new number;
	if(sscanf(params, "i", number))
	{
		SendClientMessage(playerid, COLOR_WHITE, "Используйте: /call [номер]");
		return SendClientMessage(playerid, COLOR_WHITE, "Службы: 911 - Полиция, 555 - Такси, 600 - Механики");
	}
	if(PlayerInfo[playerid][pPhoneNumber] == number)
	{
 		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете позвонить самому себе.");
	}
	if(!CallLocalFunction("OnPlayerPhoneCall", "dd", playerid, number))
	{
		foreach(LoginPlayer, i)
		{
		    if(PlayerInfo[i][pPhoneNumber] == number)
		    {
				return StartCall(playerid, i);
		    }
		}
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Аппарат абонента выключен или находится вне зоны действия сети.");
	}
	return true;
}

COMMAND:acceptcall(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /acceptcall [playerid/playername]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого игрока нет на сервере.");
	new string[124];
	if(IsPoliceDuty(playerid))
	{
		if(GetPVarInt(giveplayerid, "Player:Service:Police"))
		{ 
			new Float:pos[3];
            MyGetPlayerPos(giveplayerid, Arr3<pos>);
           	ShowPlayerGPSPoint(playerid, Arr3<pos>);

            SendFormatMessage(giveplayerid, COLOR_BLUE, string, "Полицейский %s принял ваш вызов, оставайтесь на месте.", ReturnPlayerName(playerid));
            SendFormatMessage(playerid, COLOR_BLUE, string, "Вы приняли вызов %s, он отмечен на карте.", ReturnPlayerName(giveplayerid));
            
			DeletePVar(giveplayerid, "Player:Service:Police");
		}
        else
        {
            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этот игрок не вызывал полицию, либо его вызов уже приняли.");
        }
	}
	else if(GetPVarInt(playerid, "Player:EmergyDuty"))
	{
		if(GetPVarInt(giveplayerid, "Player:Service:Medic"))
		{
			new Float:pos[3];
            MyGetPlayerPos(giveplayerid, Arr3<pos>);
           	ShowPlayerGPSPoint(playerid, Arr3<pos>);

            SendFormatMessage(giveplayerid, COLOR_BLUE, string, "Медик %s принял ваш вызов, оставайтесь на месте.", ReturnPlayerName(playerid));
            SendFormatMessage(playerid, COLOR_BLUE, string, "Вы приняли вызов %s, он отмечен на карте.", ReturnPlayerName(giveplayerid));

			DeletePVar(giveplayerid, "Player:Service:Medic");
		}
		else
        {
            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этот игрок не вызывал скорую, либо его вызов уже приняли.");
        }
	}
	return true;
}

COMMAND:pm(playerid, params[])
{
    if(PlayerInfo[playerid][pPhoneNumber] == 0)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас нет мобильного телефона.");
    if(PlayerInfo[playerid][pPhoneEnable] == false)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ваш телефон выключен.");
	if(PlayerInfo[playerid][pJailTime])
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ваш телефон изъят на время заключения.");
	if(call_phone[playerid][0] != (-1) || call_phone[playerid][1] != PHONE_OFF)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ваш телефон уже занят другим вызовом.");
	if(PlayerInfo[playerid][pPhoneBalance] <= 0)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "На счету недостаточно средств.");

	new giveplayerid, string[128];
	if(sscanf(params, "rs[96]", giveplayerid, string))
		return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /pm [playerid/playername] [сообщение]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого игрока нет на сервере.");
	format(string, sizeof(string), "%d %s", PlayerInfo[giveplayerid][pPhoneNumber], string);
	return callcmd::sms(playerid, string);
}

COMMAND:sms(playerid, params[])
{
    if(PlayerInfo[playerid][pPhoneNumber] == 0)
    {
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас нет мобильного телефона.");
    }
    if(PlayerInfo[playerid][pPhoneEnable] == false)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ваш телефон выключен.");
	}
	if(PlayerInfo[playerid][pJailTime])
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ваш телефон изъят на время заключения.");
	}
	if(call_phone[playerid][0] != (-1) || call_phone[playerid][1] != PHONE_OFF)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ваш телефон уже занят другим вызовом.");
	}
	if(PlayerInfo[playerid][pPhoneBalance] <= 0)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "На счету недостаточно средств.");
	}
	new number, message[64];
	if(sscanf(params, "is[64]", number, message))
	{
		return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /sms [номер] [сообщение]");
	}
	foreach(LoginPlayer, i)
	{
	    if(PlayerInfo[i][pPhoneNumber] == number)
	    {
		    if(playerid == i)
		    {
		        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете отправить СМС самому себе.");
		    }
		    if(PlayerInfo[i][pJailTime])
			{
			    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете писать смс заключенному.");
			}
			if(PlayerInfo[i][pPhoneEnable] == false)
			{
			    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Аппарат абонента выключен или находится вне зоны действия сети.");
			}
			SendSMS(playerid, i, message);
			return true;
		}
	}
	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Аппарат абонента выключен или находится вне зоны действия сети.");
}

COMMAND:togphone(playerid, params[])
{
    if(PlayerInfo[playerid][pPhoneNumber] == 0)
    {
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас нет мобильного телефона.");
    }
	if(PlayerInfo[playerid][pPhoneEnable])
	{
		if(call_phone[playerid][0] != (-1))
		{// Сбросить вызов
		    callcmd::h(playerid, "");
		}
		if(GetPVarInt(playerid, "Thing:RadioID") > 0)
		{// Выключить радио
			DeletePVar(playerid, "Thing:RadioID");
			UpdatePlayerRadio(playerid);
		}
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_PHONE "Вы отключили телефон и больше не будете получать звонки и смс.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_PHONE "Вы включили телефон и теперь будете получать звонки и смс.");
	}
	PlayerInfo[playerid][pPhoneEnable] = !PlayerInfo[playerid][pPhoneEnable];
	return 1;
}

COMMAND:p(playerid, params[])
{	//  accept call
	if(PlayerInfo[playerid][pPhoneNumber] == 0)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас нет мобильного телефона.");
	}
	if(call_phone[playerid][0] == (-1) || call_phone[playerid][1] != PHONE_CALL)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Нет текущих вызовов.");
	}
	new string[128];
	SendFormatMessage(call_phone[playerid][0], COLOR_WHITE, string, PREFIX_PHONE "%s (%d) ответил на звонок.", ReturnPlayerName(playerid), PlayerInfo[playerid][pPhoneNumber]);
	SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_PHONE "Вы ответили на звонок от %s (%d).", ReturnPlayerName(call_phone[playerid][0]), PlayerInfo[call_phone[playerid][0]][pPhoneNumber]);
	//  Set Vars
	call_phone[playerid][1]	= PHONE_ANSWER;
	call_phone[ call_phone[playerid][0] ][1] = PHONE_SPEAK;
	call_phone[playerid][2] = 0;
	call_phone[ call_phone[playerid][0] ][2] = 0;
	//  Show Phone
	IFace.Phone_Show(playerid, 3);
	IFace.Phone_Show(call_phone[playerid][0], 3);
    PlayerPlaySound(playerid, 39074, 0.0, 0.0, 0.0);
    MyApplyAnimation(playerid, "ped", "phone_in", 4.1, 0, 1, 1, 1, 1);
	return true;
}

COMMAND:h(playerid, params[])
{	//  cancel call
    if(PlayerInfo[playerid][pPhoneNumber] == 0)
    {
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас нет мобильного телефона.");
    }
	if(call_phone[playerid][0] == (-1))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Нет текущих вызовов.");
	}
	new string[128];
	if(call_phone[playerid][1] == PHONE_CALL)
	{
		SendFormatMessage(call_phone[playerid][0], COLOR_YELLOW2, string, PREFIX_PHONE "%s (%d) сбросил ваш вызов.", ReturnPlayerName(playerid), PlayerInfo[playerid][pPhoneNumber]);
		format(string, sizeof(string), PREFIX_PHONE "Вы сбросили звонок от %s (%d).", ReturnPlayerName(call_phone[playerid][0]), PlayerInfo[call_phone[playerid][0]][pPhoneNumber]);
	}
	else if(call_phone[playerid][1] == PHONE_WAIT)
	{
		SendFormatMessage(call_phone[playerid][0], COLOR_YELLOW2, string, PREFIX_PHONE "%s (%d) сбросил вызов.", ReturnPlayerName(playerid), PlayerInfo[playerid][pPhoneNumber]);
		format(string, sizeof(string), PREFIX_PHONE "Вы сбросили звонок %s'у (%d).", ReturnPlayerName(call_phone[playerid][0]), PlayerInfo[call_phone[playerid][0]][pPhoneNumber]);
	}
	else if(call_phone[playerid][1] == PHONE_SPEAK || call_phone[playerid][1] == PHONE_ANSWER)
	{
		SendFormatMessage(call_phone[playerid][0], COLOR_YELLOW2, string, PREFIX_PHONE "%s (%d) закончил телефонный разговор.", ReturnPlayerName(playerid), PlayerInfo[playerid][pPhoneNumber]);
		format(string, sizeof(string), PREFIX_PHONE "Вы закончили разговор с %s (%d).", ReturnPlayerName(call_phone[playerid][0]), PlayerInfo[call_phone[playerid][0]][pPhoneNumber]);
	}
	SendClientMessage(playerid, COLOR_YELLOW2, string);
	_ClearCall(playerid);	//  Clear Call
	return true;
}

flags:setphone(CMD_DEVELOPER);
COMMAND:setphone(playerid, params[])
{
    new giveplayerid, phonenum = 0;
	if(sscanf(params, "ri", giveplayerid, phonenum))
	{
		return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /setphone [playerid/playername] [номер]");
	}
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого игрока нет на сервере.");
	if(phonenum <= 0) phonenum = CreatePhoneNumber();
	if(phonenum == 0 || _CheckPhoneNumber(phonenum))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого телефонный номер занят другим игроком.");

	PlayerInfo[giveplayerid][pPhoneNumber] = phonenum;
	PlayerInfo[giveplayerid][pPhoneEnable] = true;
	PlayerInfo[giveplayerid][pPhoneBalance] = 50;
	UpdatePlayerData(giveplayerid, "p_number", PlayerInfo[giveplayerid][pPhoneNumber]);

	new string[128];
	format(string, 128, "[AdmCmd]: %s %s[%d] изменил игроку %s[%d] тел номер на %d",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, phonenum);
	SendAdminMessage(COLOR_ADMIN, string);
	if(!GetPlayerAdmin(giveplayerid))
	{
		format(string, 128, "%s {FFFFFF}%s[%d]{33CCFF} изменил вам тел номер на %d", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, phonenum);
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
	}
    return 1;
}

flags:checkphone(CMD_DEVELOPER);
COMMAND:checkphone(playerid, params[])
{
	new phonenum;
	if(sscanf(params, "i", phonenum) || phonenum <= 0)
		return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /checkphone [номер]");
	new string[128], result = _CheckPhoneNumber(phonenum);
	if(result == 0) string = "{33AA33}Свободен";
	else format(string, 128, "{FF6347}%s (ID: %d)", GetPlayerUsername(result), result);
	format(string, sizeof(string), "Телефонный номер [%d]: %s", phonenum, string);
	SendClientMessage(playerid, COLOR_SERVER, string);
	return 1;
}