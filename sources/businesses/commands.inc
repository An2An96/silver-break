flags:abiz(CMD_DEVELOPER);
COMMAND:abiz(playerid, params[])
{
	new const b = PickupedBiz[playerid];
	if(b == INVALID_DATA)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��������� � ������� ����� ������������ ��� �������.");
	}
	if(b < 0 || b >= sizeof(BizInfo) || BizInfo[b][bID] == 0)
	{
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "���� ������ ������ ������������� - ��� �� ���������� � ����.");
	}
    new string[152];
    if(sscanf(params, "s[32] ", string))
    {
        return SendClientMessage(playerid, COLOR_WHITE, "�����������: /abiz [owner]");
    }
	if(strcheck(string, "owner"))
	{
		new owner;
		if(sscanf(params, "{s[32]}i", owner))
		    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /abiz owner [userid]");
		BizInfo[b][bOwnerID] = owner;
		UpdateBusinessText(b);
		SaveBiz(b);
		if(owner != 0)
		{
			SendFormatMessage(playerid, COLOR_GREEN, string, "������ #%d: {FFFFFF}����� ��������: %s", BizInfo[b][bID], GetPlayerUsername(BizInfo[b][bOwnerID]));
		}
		else
		{
			SendFormatMessage(playerid, COLOR_GREEN, string, "������ #%d: {FFFFFF}�������� ������� �������", BizInfo[b][bID]);
		}
	    return true;
	}
	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������ �������� � ���� ������� �� ����������.");
}