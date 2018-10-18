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
		Dialog_Open(playerid, Dialog:Phone_EnterNumber, DIALOG_STYLE_INPUT, "Телефон - Ввод номера", "Введите номер телефона для звонка:", "ОК", "Назад");
	}
	else if(phoneAction[playerid] == 2)
	{
		Dialog_Open(playerid, Dialog:Phone_EnterNumber, DIALOG_STYLE_INPUT, "Телефон - Ввод номера", "Введите номер телефона для смс:", "ОК", "Назад");
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