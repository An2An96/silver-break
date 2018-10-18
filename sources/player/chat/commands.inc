#include "player/chat/header"

COMMAND:o(playerid, params[])
{
	if(TOGOOC == false)
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ��� ��������.");

	new string[128];
	if(PlayerInfo[playerid][pMuteTime] > 0)
	    return SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "�� �������� � ����, ��������: %d ���.", PlayerInfo[playerid][pMuteTime]);

	if(sscanf(params, "s[128]", string))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /o [���������]");

	//	�������
	if(RemoveBadWords(string, true) >= 5)
	{
		new stmp[128];
		PlayerInfo[playerid][pMuteTime] = 5 * 60;
	    SendFormatMessageToAll(COLOR_LIGHTRED, stmp, "[AdmWrn]: %s[%d] ������� �������� �� 5 ����� �� ������ ����", ReturnPlayerName(playerid), playerid);
	    return true;
	}
	CensoreFormatMessageToAll(GetPlayerColor(playerid), string, "(( O���� ��� )) %s[%d]: {FFFFFF}%s", ReturnPlayerName(playerid), playerid, string);
	return true;
}

COMMAND:do(playerid, params[])
{
	new string[128];
	if(PlayerInfo[playerid][pMuteTime] > 0)
		return SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "�� �������� � ����, ��������: %d ���.", PlayerInfo[playerid][pMuteTime]);
	if(sscanf(params, "s[128]", string))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /do [�������]");
	format(string, 128, "* %s (( %s ))", string, ReturnPlayerName(playerid));
	ProxDetector(playerid, 30.0, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, true);
	printf("[chat] %s", string);
	return true;
}

COMMAND:try(playerid, params[])
{
    new string[128];
	if(PlayerInfo[playerid][pMuteTime] > 0)
		return SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "�� �������� � ����, ��������: %d ���.", PlayerInfo[playerid][pMuteTime]);
	if(sscanf(params, "s[128]", string))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /try [��������]");
	new randa = random(2) + 1;
    if(randa == 1)	format(string, sizeof(string), "* %s ��������: %s (�������)", ReturnPlayerName(playerid), string);
	else 			format(string, sizeof(string), "* %s ��������: %s (����������)", ReturnPlayerName(playerid), string);
	ProxDetector(playerid, 30.0, string, COLOR_TRY, COLOR_TRY, COLOR_TRY, COLOR_TRY, COLOR_TRY, true);
	printf("[chat] %s", string);
	return true;
}

COMMAND:me(playerid, params[])
{
	if(PlayerInfo[playerid][pMuteTime] > 0)
	{
		new string[128];
		SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "�� �������� � ����, ��������: %d ���.", PlayerInfo[playerid][pMuteTime]);
	    if(random(2))	SetPlayerChatBubble(playerid, "�������� ���-�� �������...", COLOR_LIGHTRED, 20.0, 5000);
	    else			SetPlayerChatBubble(playerid, "�����...", COLOR_LIGHTRED, 20.0, 5000);
	}
	else
	{
		if(sscanf(params, "s[128]", params))
		    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /me [��������]");
		PlayerAction(playerid, params, true);
	}
	return true;
}

COMMAND:s(playerid, params[])
{
	new string[196];
	if(sscanf(params, "s[128]", string))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /s [���������]");
	if(PlayerInfo[playerid][pMuteTime] > 0)
	{
		SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "�� �������� � ����, ��������: %d ���.", PlayerInfo[playerid][pMuteTime]);
		return 1;
	}
	format(string, sizeof(string), "- %s ������: %s", ReturnPlayerName(playerid), string);
	CensoreProxDetector(playerid, 30.0, string, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, 0xE6E6E6E6, 0xC8C8C8C8);
	SetPlayerChatBubble(playerid, params, COLOR_LIGHTGREEN, 30.0, 5000);
	if(IsPlayerInAnyVehicle(playerid) == 0 && playerBenchUsed{playerid} == 0)
		MyApplyAnimation(playerid, "ON_LOOKERS", "shout_01", 4.1, 0, 0, 0, 0, 0);
	//printf("[%s]: %s", ReturnPlayerName(playerid), params);
	return true;
}

alias:b("n");
COMMAND:b(playerid, params[])
{
    new string[196];
	if(sscanf(params, "s[128]", string))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /b [���������]");
	if(PlayerInfo[playerid][pMuteTime] > 0)
	{
		SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "�� �������� � ����, ��������: %d ���.", PlayerInfo[playerid][pMuteTime]);
		return 1;
	}
	format(string, sizeof(string), "(( %s[%d]: %s )) ", ReturnPlayerName(playerid), playerid, string);
	CensoreProxDetector(playerid, 20.0, string);
	SetPlayerChatBubble(playerid, params, COLOR_LIGHTGREEN, 20.0, 5000);
	return 1;
}

alias:close("c");
COMMAND:close(playerid, params[])
{
    new string[196];
	if(sscanf(params, "s[128]", string))
	    return SendClientMessage(playerid, COLOR_WHITE, "�����������: /c [���������]");
	if(PlayerInfo[playerid][pMuteTime] > 0)
	{
		SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "�� �������� � ����, ��������: %d ���.", PlayerInfo[playerid][pMuteTime]);
		return 1;
	}
    format(string, sizeof(string), "- %s[%d] ������: %s", ReturnPlayerName(playerid), playerid, string);
	CensoreProxDetector(playerid, 4.0, string, COLOR_GRAD1, COLOR_GRAD2, COLOR_GRAD3, COLOR_GRAD4, COLOR_GRAD5);
	SetPlayerChatBubble(playerid, params, COLOR_LIGHTGREEN, 4.0, 5000);
	return 1;
}

COMMAND:censore(playerid, params[])
{
	if(PlayerInfo[playerid][pCensored])	SendClientMessage(playerid, COLOR_RED, "�� ��������� �������");
	else								SendClientMessage(playerid, COLOR_GREEN, "�� �� ������ ������ ���");
	PlayerInfo[playerid][pCensored] = !PlayerInfo[playerid][pCensored];
	return true;
}