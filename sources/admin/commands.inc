flags:setvw(CMD_MODER);
COMMAND:setvw(playerid, params[])
{// [BT]
	new giveplayerid, vw;
	if(sscanf(params, "ri", giveplayerid, vw))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /setvw [playerid] [vw]");
	if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	if(GetPlayerState(giveplayerid) == 2)
	    SetVehicleVirtualWorld(GetPlayerVehicleID(giveplayerid), vw);
	SetPlayerVirtualWorld(giveplayerid, vw);
    SendClientMessage(playerid, COLOR_WHITE, "����� ����� ����������� ��� ��� ������");
    SendClientMessage(giveplayerid, COLOR_WHITE, "������������� ������� ��� ����������� ���");
	return 1;
}

flags:setint(CMD_MODER);
COMMAND:setint(playerid, params[])
{// [BT]
	new inter, giveplayerid;
	if(sscanf(params, "ri", giveplayerid, inter))
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /setint [playerid] [int]");
	if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ��� �� �������.");
	SetPlayerInterior(giveplayerid, inter);
    SendClientMessage(playerid, COLOR_WHITE, "����� ����� �������� ��� ������");
    SendClientMessage(giveplayerid, COLOR_WHITE, "������������� ������� ��� ��������");
    return 1;
}