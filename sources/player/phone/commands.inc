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
	if(CallLocalFunction("OnPlayerPhoneCall", "dd", playerid, number) == 0)
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