DialogCreate:Phone_Main(playerid)	//	DPHONE_MAIN
{
	if(PlayerInfo[playerid][pPhoneNumber] == 0)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ��������.");
    if(PlayerInfo[playerid][pJailTime])
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��������� � ������.");
	new string[256];
	new stmp[128];
	new clickedplayerid = (GetPVarType(playerid, "Phone:ClickPlayer") == PLAYER_VARTYPE_NONE) ? INVALID_PLAYER_ID : GetPVarInt(playerid, "Phone:ClickPlayer");
    if(clickedplayerid == INVALID_PLAYER_ID)
	{
		if(PlayerInfo[playerid][pPhoneEnable])
		{
			strcat(string, ""MAIN_COLOR"� {FFFFFF}���������\n\
							"MAIN_COLOR"� {FFFFFF}��������� ���\n\
							"MAIN_COLOR"� {FFFFFF}�������� ���\n\
							"MAIN_COLOR"� {FFFFFF}������ ��������\n\
							"MAIN_COLOR"� {FFFFFF}��������� �������");
			format(stmp, sizeof stmp, "{FFFFFF}������� [�����: {88AA88}%d{FFFFFF}]", PlayerInfo[playerid][pPhoneNumber]);
		}
		else
		{
			strcat(string, ""MAIN_COLOR"� {AFAFAF}���������\t\t[����������]\n\
							"MAIN_COLOR"� {AFAFAF}��������� ���\t[����������]\n\
							"MAIN_COLOR"� {AFAFAF}�������� ���\t[����������]\n\
							"MAIN_COLOR"� {AFAFAF}������ ��������\t[����������]\n\
							"MAIN_COLOR"� {FFFFFF}�������� �������");
			format(stmp, sizeof stmp, "{FFFFFF}������� [�����: {88AA88}%d{FFFFFF}][{88AA88}��������{FFFFFF}]", PlayerInfo[playerid][pPhoneNumber]);
		}
	}
	else
	{
		if(PlayerInfo[playerid][pPhoneEnable] && PlayerInfo[clickedplayerid][pPhoneNumber] && PlayerInfo[clickedplayerid][pPhoneEnable])
		{
			strcat(string, ""MAIN_COLOR"� {FFFFFF}���������\n\
							"MAIN_COLOR"� {FFFFFF}��������� ���\n\
							"MAIN_COLOR"� {FFFFFF}�������� ���\n\
							"MAIN_COLOR"� {FFFFFF}������ ��������\n\
							"MAIN_COLOR"� {FFFFFF}��������� �������");
			format(stmp, sizeof stmp, "{FFFFFF}������� [�����: {88AA88}%d{FFFFFF}]", PlayerInfo[clickedplayerid][pPhoneNumber]);
		}
		else
		{
			strcat(string, ""MAIN_COLOR"� {AFAFAF}���������\t\t[����������]\n\
							"MAIN_COLOR"� {AFAFAF}��������� ���\t[����������]\n\
							"MAIN_COLOR"� {FFFFFF}�������� ���\n\
							"MAIN_COLOR"� {FFFFFF}������ ��������\n");
			if(PlayerInfo[playerid][pPhoneEnable])
				strcat(string, ""MAIN_COLOR"� {FFFFFF}��������� �������");
			else
				strcat(string, ""MAIN_COLOR"� {FFFFFF}�������� �������");
			//	����������
			format(stmp, sizeof stmp, "{FFFFFF}������� [�����: {88AA88}%d{FFFFFF}][{88AA88}����������{FFFFFF}]", PlayerInfo[clickedplayerid][pPhoneNumber]);
		}
	}
	Dialog_Open(playerid, Dialog:Phone_Main, DIALOG_STYLE_LIST, stmp, string, "�������", ((openWithMenu[playerid]) ? ("�����") : ("�������")));
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
		        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������� ������� ������ ���� �������.");
				return Dialog_Show(playerid, Dialog:Phone_Main);
		    }
			if(clickedplayerid != INVALID_PLAYER_ID)
			{
			    valstr(string, PlayerInfo[clickedplayerid][pPhoneNumber]);
				callcmd::call(playerid, string); // call
			}
			else
			{	// ���� ������
				phoneAction[playerid] = 1;
				return Dialog_Show(playerid, Dialog:Phone_EnterNumber);
			}
		}
		else if(listitem == 1)
		{	// sms
		    if(PlayerInfo[playerid][pPhoneEnable] == false)
		    {
		        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��� ������� ������ ���� �������.");
				return Dialog_Show(playerid, Dialog:Phone_Main);
		    }
		    if(clickedplayerid != INVALID_PLAYER_ID)
			{
				if(PlayerInfo[clickedplayerid][pPhoneNumber] == 0)
				{
					SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ����� ������ ��� ���������� ��������.");
					return Dialog_Show(playerid, Dialog:Phone_Main);
				}
				return Dialog_Show(playerid, Dialog:Phone_Sms);
			}
			else
			{	//	���� ������
				phoneAction[playerid] = 2;
				return Dialog_Show(playerid, Dialog:Phone_EnterNumber);
			}
		}
		else if(listitem == 2)
		{	//	������ ���
		    if(PlayerInfo[playerid][pPhoneEnable] == false)
		    {
		        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������� ��� ������� ������ ���� �������.");
				return Dialog_Show(playerid, Dialog:Phone_Main);
		    }
			return Dialog_Show(playerid, Dialog:Phone_SmsList);
		}
		else if(listitem == 3)
		{	//	������ ��������
		    if(PlayerInfo[playerid][pPhoneEnable] == false)
		    {
		        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ��������� ������� ������� ������ ���� �������.");
				return Dialog_Show(playerid, Dialog:Phone_Main);
		    }
			SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_PHONE "������ ������ ��������: %.2f$.", PlayerInfo[playerid][pPhoneBalance]);
			return Dialog_Show(playerid, Dialog:Phone_Main);
		}
		else if(listitem == 4)
		{	//	���������/�������� �������
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
		Dialog_Open(playerid, Dialog:Phone_EnterNumber, DIALOG_STYLE_INPUT, "������� - ���� ������", "������� ����� �������� ��� ������:", "��", "�����");
	}
	else if(phoneAction[playerid] == 2)
	{
		Dialog_Open(playerid, Dialog:Phone_EnterNumber, DIALOG_STYLE_INPUT, "������� - ���� ������", "������� ����� �������� ��� ���:", "��", "�����");
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
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� �������� �������� ��� ��������� ��� ���� �������� ����.");
    }
    else
    {
		Dialog_Show(playerid, Dialog:Phone_Main);
    }
    return true;
}

DialogCreate:Phone_Sms(playerid, response, listitem, inputtext[])
{
	Dialog_Open(playerid, Dialog:Phone_Sms, DIALOG_STYLE_INPUT, "������� - ���", "������� ����� ���������:", "���������", "�����");
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
    	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� �������� ���");
    	return ShowDialog(playerid, DPHONE_MAIN);
    }
    MyShowPlayerDialog(playerid, action, DIALOG_STYLE_LIST, "������� - �������� ���", lstring, "�������", "�����");*/
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
		    		"{FFFFFF}�����������: "MAIN_COLOR"����������\n\
		    		{FFFFFF}�����: "MAIN_COLOR"����������\n\
		    		{FFFFFF}�����: "MAIN_COLOR"%s", SMS_Buffer[playerid][i]);
	    		break;
	    	}
	    }
		MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "������� - �������� ���", string, "�����", "");
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
	format(string, sizeof(string), "{FFFFFF}�� ������ ��������� ���� ���������� ��������\n\
									������� ������: "MAIN_COLOR"$%.2f\n\n\
									{FFFFFF}��������� �������: "MAIN_COLOR"$%.0f/���.\n\
									{FFFFFF}��������� ���: "MAIN_COLOR"$%.0f\n\n\
									{FFFFFF}������� ����� ������� ������ �������� �� ����:", PlayerInfo[playerid][pPhoneBalance], COST_PHONE_CALL, COST_PHONE_SMS);
	Dialog_Open(playerid, Dialog:Phone_Pay, DIALOG_STYLE_INPUT, "������ ��������", string, "�������", "�����");
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
            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
            return Dialog_Show(playerid, Dialog:Phone_Pay);
        }
        PlayerInfo[playerid][pPhoneBalance] += float(money);
        MyGivePlayerMoney(playerid, -money);
        SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_PHONE "������ �������� �������� �� %d$ ($%.2f).", money, PlayerInfo[playerid][pPhoneBalance]);
	}
	if(openWithATM[playerid])	ShowDialog(playerid, DMODE_ATM);
	else 						ShowDialog(playerid, DMODE_BANK);
	return true;
}