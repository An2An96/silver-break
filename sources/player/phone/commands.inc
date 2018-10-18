COMMAND:phone(playerid, params[])
{
	Dialog_Show(playerid, Dialog:Phone_Main);
	return true;
}

COMMAND:call(playerid, params[])
{
	if(PlayerInfo[playerid][pPhoneNumber] == 0)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ���������� ��������.");
	}
	if(PlayerInfo[playerid][pPhoneEnable] == false)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������� ��������.");
	}
	if(PlayerInfo[playerid][pJailTime])
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������� ����� �� ����� ����������.");
	}
	if(call_phone[playerid][0] != (-1) || call_phone[playerid][1] != PHONE_OFF)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������� ��� ����� ������ �������.");
	}
	if(PlayerInfo[playerid][pPhoneBalance] <= 0)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ����� ������������ �������.");
	}
	new number;
	if(sscanf(params, "i", number))
	{
		SendClientMessage(playerid, COLOR_WHITE, "�����������: /call [�����]");
		return SendClientMessage(playerid, COLOR_WHITE, "������: 911 - �������, 555 - �����, 600 - ��������");
	}
	if(PlayerInfo[playerid][pPhoneNumber] == number)
	{
 		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ��������� ������ ����.");
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
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� �������� �������� ��� ��������� ��� ���� �������� ����.");
	}
	return true;
}

COMMAND:acceptcall(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /acceptcall [playerid/playername]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	new string[124];
	if(IsPoliceDuty(playerid))
	{
		if(GetPVarInt(giveplayerid, "Player:Service:Police"))
		{ 
			new Float:pos[3];
            MyGetPlayerPos(giveplayerid, Arr3<pos>);
           	ShowPlayerGPSPoint(playerid, Arr3<pos>);

            SendFormatMessage(giveplayerid, COLOR_BLUE, string, "����������� %s ������ ��� �����, ����������� �� �����.", ReturnPlayerName(playerid));
            SendFormatMessage(playerid, COLOR_BLUE, string, "�� ������� ����� %s, �� ������� �� �����.", ReturnPlayerName(giveplayerid));
            
			DeletePVar(giveplayerid, "Player:Service:Police");
		}
        else
        {
            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� �� ������� �������, ���� ��� ����� ��� �������.");
        }
	}
	else if(GetPVarInt(playerid, "Player:EmergyDuty"))
	{
		if(GetPVarInt(giveplayerid, "Player:Service:Medic"))
		{
			new Float:pos[3];
            MyGetPlayerPos(giveplayerid, Arr3<pos>);
           	ShowPlayerGPSPoint(playerid, Arr3<pos>);

            SendFormatMessage(giveplayerid, COLOR_BLUE, string, "����� %s ������ ��� �����, ����������� �� �����.", ReturnPlayerName(playerid));
            SendFormatMessage(playerid, COLOR_BLUE, string, "�� ������� ����� %s, �� ������� �� �����.", ReturnPlayerName(giveplayerid));

			DeletePVar(giveplayerid, "Player:Service:Medic");
		}
		else
        {
            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ����� �� ������� ������, ���� ��� ����� ��� �������.");
        }
	}
	return true;
}

COMMAND:pm(playerid, params[])
{
    if(PlayerInfo[playerid][pPhoneNumber] == 0)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ���������� ��������.");
    if(PlayerInfo[playerid][pPhoneEnable] == false)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������� ��������.");
	if(PlayerInfo[playerid][pJailTime])
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������� ����� �� ����� ����������.");
	if(call_phone[playerid][0] != (-1) || call_phone[playerid][1] != PHONE_OFF)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������� ��� ����� ������ �������.");
	if(PlayerInfo[playerid][pPhoneBalance] <= 0)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ����� ������������ �������.");

	new giveplayerid, string[128];
	if(sscanf(params, "rs[96]", giveplayerid, string))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /pm [playerid/playername] [���������]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	format(string, sizeof(string), "%d %s", PlayerInfo[giveplayerid][pPhoneNumber], string);
	return callcmd::sms(playerid, string);
}

COMMAND:sms(playerid, params[])
{
    if(PlayerInfo[playerid][pPhoneNumber] == 0)
    {
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ���������� ��������.");
    }
    if(PlayerInfo[playerid][pPhoneEnable] == false)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������� ��������.");
	}
	if(PlayerInfo[playerid][pJailTime])
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������� ����� �� ����� ����������.");
	}
	if(call_phone[playerid][0] != (-1) || call_phone[playerid][1] != PHONE_OFF)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������� ��� ����� ������ �������.");
	}
	if(PlayerInfo[playerid][pPhoneBalance] <= 0)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ����� ������������ �������.");
	}
	new number, message[64];
	if(sscanf(params, "is[64]", number, message))
	{
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /sms [�����] [���������]");
	}
	foreach(LoginPlayer, i)
	{
	    if(PlayerInfo[i][pPhoneNumber] == number)
	    {
		    if(playerid == i)
		    {
		        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ��������� ��� ������ ����.");
		    }
		    if(PlayerInfo[i][pJailTime])
			{
			    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������ ��� ������������.");
			}
			if(PlayerInfo[i][pPhoneEnable] == false)
			{
			    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� �������� �������� ��� ��������� ��� ���� �������� ����.");
			}
			SendSMS(playerid, i, message);
			return true;
		}
	}
	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� �������� �������� ��� ��������� ��� ���� �������� ����.");
}

COMMAND:togphone(playerid, params[])
{
    if(PlayerInfo[playerid][pPhoneNumber] == 0)
    {
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ���������� ��������.");
    }
	if(PlayerInfo[playerid][pPhoneEnable])
	{
		if(call_phone[playerid][0] != (-1))
		{// �������� �����
		    callcmd::h(playerid, "");
		}
		if(GetPVarInt(playerid, "Thing:RadioID") > 0)
		{// ��������� �����
			DeletePVar(playerid, "Thing:RadioID");
			UpdatePlayerRadio(playerid);
		}
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_PHONE "�� ��������� ������� � ������ �� ������ �������� ������ � ���.");
	}
	else
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_PHONE "�� �������� ������� � ������ ������ �������� ������ � ���.");
	}
	PlayerInfo[playerid][pPhoneEnable] = !PlayerInfo[playerid][pPhoneEnable];
	return 1;
}

COMMAND:p(playerid, params[])
{	//  accept call
	if(PlayerInfo[playerid][pPhoneNumber] == 0)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ���������� ��������.");
	}
	if(call_phone[playerid][0] == (-1) || call_phone[playerid][1] != PHONE_CALL)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������� �������.");
	}
	new string[128];
	SendFormatMessage(call_phone[playerid][0], COLOR_WHITE, string, PREFIX_PHONE "%s (%d) ������� �� ������.", ReturnPlayerName(playerid), PlayerInfo[playerid][pPhoneNumber]);
	SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_PHONE "�� �������� �� ������ �� %s (%d).", ReturnPlayerName(call_phone[playerid][0]), PlayerInfo[call_phone[playerid][0]][pPhoneNumber]);
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
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ��� ���������� ��������.");
    }
	if(call_phone[playerid][0] == (-1))
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������� �������.");
	}
	new string[128];
	if(call_phone[playerid][1] == PHONE_CALL)
	{
		SendFormatMessage(call_phone[playerid][0], COLOR_YELLOW2, string, PREFIX_PHONE "%s (%d) ������� ��� �����.", ReturnPlayerName(playerid), PlayerInfo[playerid][pPhoneNumber]);
		format(string, sizeof(string), PREFIX_PHONE "�� �������� ������ �� %s (%d).", ReturnPlayerName(call_phone[playerid][0]), PlayerInfo[call_phone[playerid][0]][pPhoneNumber]);
	}
	else if(call_phone[playerid][1] == PHONE_WAIT)
	{
		SendFormatMessage(call_phone[playerid][0], COLOR_YELLOW2, string, PREFIX_PHONE "%s (%d) ������� �����.", ReturnPlayerName(playerid), PlayerInfo[playerid][pPhoneNumber]);
		format(string, sizeof(string), PREFIX_PHONE "�� �������� ������ %s'� (%d).", ReturnPlayerName(call_phone[playerid][0]), PlayerInfo[call_phone[playerid][0]][pPhoneNumber]);
	}
	else if(call_phone[playerid][1] == PHONE_SPEAK || call_phone[playerid][1] == PHONE_ANSWER)
	{
		SendFormatMessage(call_phone[playerid][0], COLOR_YELLOW2, string, PREFIX_PHONE "%s (%d) �������� ���������� ��������.", ReturnPlayerName(playerid), PlayerInfo[playerid][pPhoneNumber]);
		format(string, sizeof(string), PREFIX_PHONE "�� ��������� �������� � %s (%d).", ReturnPlayerName(call_phone[playerid][0]), PlayerInfo[call_phone[playerid][0]][pPhoneNumber]);
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
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /setphone [playerid/playername] [�����]");
	}
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	if(phonenum <= 0) phonenum = CreatePhoneNumber();
	if(phonenum == 0 || _CheckPhoneNumber(phonenum))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ���������� ����� ����� ������ �������.");

	PlayerInfo[giveplayerid][pPhoneNumber] = phonenum;
	PlayerInfo[giveplayerid][pPhoneEnable] = true;
	PlayerInfo[giveplayerid][pPhoneBalance] = 50;
	UpdatePlayerData(giveplayerid, "p_number", PlayerInfo[giveplayerid][pPhoneNumber]);

	new string[128];
	format(string, 128, "[AdmCmd]: %s %s[%d] ������� ������ %s[%d] ��� ����� �� %d",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid, phonenum);
	SendAdminMessage(COLOR_ADMIN, string);
	if(!GetPlayerAdmin(giveplayerid))
	{
		format(string, 128, "%s {FFFFFF}%s[%d]{33CCFF} ������� ��� ��� ����� �� %d", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, phonenum);
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
	}
    return 1;
}

flags:checkphone(CMD_DEVELOPER);
COMMAND:checkphone(playerid, params[])
{
	new phonenum;
	if(sscanf(params, "i", phonenum) || phonenum <= 0)
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /checkphone [�����]");
	new string[128], result = _CheckPhoneNumber(phonenum);
	if(result == 0) string = "{33AA33}��������";
	else format(string, 128, "{FF6347}%s (ID: %d)", GetPlayerUsername(result), result);
	format(string, sizeof(string), "���������� ����� [%d]: %s", phonenum, string);
	SendClientMessage(playerid, COLOR_SERVER, string);
	return 1;
}