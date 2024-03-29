#if defined _player_account_included
	#endinput
#endif

#define _player_account_included

#include "inventory/header"
#include "faction/header"
#include "player/chat/header"

#define MIN_PASS_SYMB			4		// ��� ����� ������
#define MAX_PASS_SYMB   		32      // ������������ ����� ������
#define MAX_SALT_PASS			16
#define MAX_LOG_TRIES			3		// ���� ������� ����� ������
#define MAX_LOGGED_TIME			120 	//	������������ ����� ��� ����������� ������

enum
{
	REG_STATE_UNDEFINED,	//	��� �� ����������
	REG_STATE_REGISTER,		//	�����������
	REG_STATE_LOGIN,		//	�����������
};

new gPlayerRegged[MAX_PLAYERS] = { REG_STATE_UNDEFINED, ... };

GetPlayerUserID(playerid)
{
	return PlayerInfo[playerid][pUserID];
}

UpdatePlayerStatics(playerid)
{
	if(IsPlayerLogged(playerid) && PlayerInfo[playerid][pUserID])
	{
		if(gPlayerDisconnecting[playerid])
		{
		    UpdatePlayerData(playerid, "online", -1);
			PlayerInfo[playerid][pExitUNIX] = gettime();
		}
		Inv.SavePlayerWeapon(playerid);
		orm_save(PlayerInfo[playerid][ORM_ID]);
	}
	return true;
}

stock UpdatePlayerData(playerid, field[], data)
{
	new query[128];
	mysql_format(g_SQL, query, sizeof query, "UPDATE `players` SET `%s` = '%d' WHERE `id` = '%d'", field, data, PlayerInfo[playerid][pUserID]);
    mysql_query_ex(query);
	return 1;
}

stock UpdatePlayerBitData(playerid, field[], data)
{
	new query[128];
	mysql_format(g_SQL, query, sizeof(query), "UPDATE `players` SET `%s` = '%b' WHERE `id` = '%d'", field, data, PlayerInfo[playerid][pUserID]);
	mysql_query_ex(query);
	return true;
}

Public: OnPlayerDataLoaded(playerid)
{
	new string[256];

	if(orm_errno(PlayerInfo[playerid][ORM_ID]) == ERROR_NO_DATA)
	{
		//  ������ ��������� ������
		return false;
	}

    new as_element[9],
    	learn_fstyle[6];
    mysql_format(g_SQL, string, sizeof(string), "SELECT `as_element`, `learn_fstyle` FROM `players` WHERE `id` = '%d'", PlayerInfo[playerid][pUserID]);
    new Cache:result = mysql_query(g_SQL, string);
    cache_get_value_index(0, 0, as_element);
    cache_get_value_index(0, 1, learn_fstyle);
    sscanf(as_element, "b", PlayerInfo[playerid][pASElement]);
    sscanf(learn_fstyle, "b", PlayerInfo[playerid][pLearnFStyle]);
    cache_delete(result);

    OnPlayerLogged(playerid);
	return true;
}

Public: OnPlayerRegister(playerid, password[])
{	//	����������� � ������� ���� �������
	new query[512], clear_pass[MAX_PASS_SYMB], salt[MAX_SALT_PASS];
	mysql_escape_string(password, clear_pass);
    strmid(salt, generateCode(MAX_SALT_PASS), 0, MAX_SALT_PASS);	// ��� ��������� ��������� ������������ �������� /setpass � /changepass
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO `players` SET username = '%s', password = MD5(CONCAT(MD5('%s'), MD5('%s'))), salt = MD5('%s'), `regdate` = UNIX_TIMESTAMP()", ReturnPlayerName(playerid), clear_pass, salt, salt);
	new Cache:result = mysql_query(g_SQL, query);
	PlayerInfo[playerid][pUserID] = cache_insert_id();
	cache_delete(result);

	//	������ �����������
	PlayerInfo[playerid][pLevel] 		= 1;
	PlayerInfo[playerid][pFaction] 		= F_NONE;
	PlayerInfo[playerid][pMoney] 		= START_MONEY;
	PlayerInfo[playerid][pExitUNIX] 	= 0;
	PlayerInfo[playerid][pSaveHealth] 	= 50.0;
	PlayerInfo[playerid][pHunger] 		= 100;
    PlayerInfo[playerid][pInterface]	= true;
	PlayerInfo[playerid][pLowerPanel]	= true;
	PlayerInfo[playerid][pToggleZone]	= true;
	PlayerInfo[playerid][pHouseIcon]	= true;
	PlayerPlaySound(playerid, 1188, 0.0, 0.0, 0.0);	//	��������� ������

	orm_save(PlayerInfo[playerid][ORM_ID], "OnPlayerServerRegister", "d", playerid);
	return true;
}

Public: OnPlayerServerRegister(playerid)
{
	Reg_SetStep(playerid, 1);
	return true;
}

Public: OnPlayerLogin(playerid, password[])
{
	new query[256], string[128];
	mysql_escape_string(password, string);
    format(query, sizeof query, "SELECT COUNT(*) FROM `players` WHERE id = '%d' AND password = MD5(CONCAT(MD5('%s'), (SELECT `salt` FROM `players` WHERE id = '%d')))", PlayerInfo[playerid][pUserID], string, PlayerInfo[playerid][pUserID]);
	new Cache:result = mysql_query(g_SQL, query);
	new count;
	cache_get_value_index_int(0, 0, count);
	cache_delete(result);
	
	if(!count)
	{
		if(MAX_LOG_TRIES - (++gPlayerLogTries{playerid}) == 0)
		{
			KickEx(playerid);
		}
		else
		{
			SendFormatMessage(playerid, COLOR_LIGHTRED, string, "������ ������ �������. �������� �������: %d", MAX_LOG_TRIES - gPlayerLogTries{playerid});
			Dialog_Show(playerid, Dialog:Account_Login);
		}
		return false;
	}
	orm_load(PlayerInfo[playerid][ORM_ID], "OnPlayerDataLoaded", "d", playerid);
	return true;
}

Public: OnPlayerGetRegister(playerid)
{
	if(cache_num_rows())
	{	//	��������������� �� �������
		new banunix;
		cache_get_value_name_int(0, "id", 		PlayerInfo[playerid][pUserID]);
		cache_get_value_name_int(0, "banunix", 	banunix);

		new bantime = banunix - gettime();
		if(banunix > 0 && bantime > 0)
		{
			SendClientMessage(playerid, COLOR_SERVER, "You are banned from this server.");
			SendRemainingBanTime(playerid, banunix);
			KickEx(playerid);
		}
		else
		{
			cache_get_value_name_int(0, "exitunix", PlayerInfo[playerid][pExitUNIX]);
			gPlayerRegged[playerid] = REG_STATE_LOGIN;
		}
	}
	else
	{
		gPlayerRegged[playerid] = REG_STATE_REGISTER;
	}
	return true;
}

Public: ShowPlayerLogin(playerid)
{
	if(gPlayerShowLoginCam[playerid])	return false;
	gPlayerShowLoginCam[playerid] = true;

	PlayAudioStreamForPlayer(playerid, AUDIOFILE_PATH "/login.mp3");
	ClearChatbox(playerid, 20);

	//PlayerPlaySound(playerid, 1187, 0.0, 0.0, 0.0);
	SetPlayerVirtualWorld(playerid, VW_LOGIN);

	SetPlayerTime(playerid, 20, 0);
	SetPlayerWeather(playerid, 13);
	SetPlayerCameraPos(playerid, 1486.6, -1770.29, 71.15);
	SetPlayerCameraLookAt(playerid, 1485.8, -1765.55, 70.86);

	//	Show dialogs
	if(gPlayerRegged[playerid] == REG_STATE_REGISTER)
	{
		if(REGISTER == false)
		{
			Dialog_Message(playerid, "{FFFFFF}����������",
				"{FFFFFF}��������, � ������ ������ ����������� �� ������� �������.\n\
				�� ������ ������������������ �� ����� �����: "MAIN_COLOR"http://"SITE_ADRESS"/\n\n\
				{FFFFFF}��� ������ ����������� ������� /q.", "�������");
			KickEx(playerid);	
		}
		else
		{
			if(!IsRPName(ReturnPlayerName(playerid)))
			{
				Dialog_Message(playerid, " ",
					"{FFFFFF}������������!\n\n\
					��� ������ ����� Role Play �����, ��� ������� ����� ������������ ������ ����:\n\
					"MAIN_COLOR"���_������� (��������: Carl_Johnson)\n\n\
					{FFFFFF}����������, ������� ��� � ����� ������� �� ������.", "�����");
				KickEx(playerid);
			}
			else
			{
				PlayerInfo[playerid][pRusifik] = true;
		   		SendMissionMessage(playerid, "~y~����� �� ��� ���� ������ ����� �� ����� ���", 0);
		   		Dialog_Show(playerid, Dialog:Account_Rus);
			}
		}
	}
	else if(gPlayerRegged[playerid] == REG_STATE_LOGIN)
	{
		Dialog_Show(playerid, Dialog:Account_Login);
	}
	return true;
}

stock IsPlayerLogged(playerid)
{
	if(IsPlayerConnected(playerid) && gPlayerLogged[playerid]) return true;
	else return false;
}

gLastLogText(time)
{	// ����������: %s �����
	// time = gettime()-timeunix;

	new string[32];
	new unix = 30*24*60*60;
	if(time >= unix)
	{// �����
	    time = time/unix;
		format(string, 32, "%d �������", time);
		if(time < 10 || time > 20)
		{
		    switch(time%10)
		    {
		        case 1: format(string, 64, "%d �����", time);
		        case 2..4: format(string, 64, "%d ������", time);
		    }
		}
		return string;
	}
	unix = 24*60*60;
	if(time >= unix)
	{// ����
	    time = time/unix;
		format(string, 32, "%d ����", time);
		if(time < 10 || time > 20)
		{
		    switch(time%10)
		    {
		        case 1: format(string, 64, "%d ����", time);
		        case 2..4: format(string, 64, "%d ���", time);
		    }
		}
		return string;
	}
	unix = 60*60;
	if(time >= unix)
	{// ���
	    time = time/unix;
		format(string, 32, "%d �����", time);
		if(time < 10 || time > 20)
		{
		    switch(time%10)
		    {
		        case 1: format(string, 64, "%d ���", time);
		        case 2..4: format(string, 64, "%d ����", time);
		    }
		}
		return string;
	}
	unix = 60;
	if(time >= unix)
	{// ������
	    time = time/unix;
		format(string, 32, "%d �����", time, "");
		if(time < 10 || time > 20)
		{
		    switch(time%10)
		    {
		        case 1: format(string, 64, "%d ������", time);
		        case 2..4: format(string, 64, "%d ������", time);
		    }
		}
		return string;
	}
	if(time > 15)
	{// �������
		format(string, 32, "%d ������", time);
		if(time < 10 || time > 20)
		{
		    switch(time%10)
		    {
		        case 1: format(string, 64, "%d �������", time);
		        case 2..4: format(string, 64, "%d �������", time);
		    }
		}
		return string;
	}
	string = "���� ������";
	return string;
}

//////////	Dialogs 	//////////
DialogCreate:Account_Rus(playerid)
{
	new string[256];
    format(string, sizeof(string),
		MAIN_COLOR "� {FFFFFF}�� ���� ����� ������� ����\n\
		" MAIN_COLOR "� {FFFFFF}� ���� ���������� ������������� �������\n\
		" MAIN_COLOR "� {FFFFFF}����� �� ��� ���� ������ ����� �� ����� ���\n\
		" MAIN_COLOR "� {FFFFFF}�� ����� - �����, �� ����� - �����\n");
	Dialog_Open(playerid, Dialog:Account_Rus, DIALOG_STYLE_LIST, "��� �������� ������� ������� �����?", string, "�������", "", 0);
	return true;
}

DialogResponse:Account_Rus(playerid, response, listitem, inputtext[])
{
    if(listitem == 2)
	{
	    PlayerInfo[playerid][pRusifik] = true;
	    Dialog_Show(playerid, Dialog:Account_Register);
	}
    else
    {
		PlayerInfo[playerid][pRusifik] = false;
		Dialog_Show(playerid, Dialog:Account_Rus2);
    }
    HideMissionMessage(playerid);
    return true;
}

DialogCreate:Account_Rus2(playerid)
{
	new string[256];
	format(string, sizeof(string), "{FFFFFF}���� �� ����� � ��� ��� ������������\n\
		��� ����� �����, ��� ��� �� ���������� ���� �� ������� ���������\n\
		��� ������������ ������ ����� ����� ���������!\n\n\
		"MAIN_COLOR"�� ����������� ������� ����������� � ��� � ������: vk.com/sbreak{FFFFFF}\n\
		� �����, ����� ����� � ����.\n\n\
		��� ���������� ��� ������������? (�� �������������)");
	Dialog_Open(playerid, Dialog:Account_Rus2, DIALOG_STYLE_MSGBOX, "������ ����������", string, "��", "�����", 0);
	return true;
}

DialogResponse:Account_Rus2(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	   	Dialog_Show(playerid, Dialog:Account_Register);
	}
	else
	{
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "����������, ����������� ���� � ������� ����� ������ ��: vk.com/sbreak");
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "���� ��� � ����!");
		KickEx(playerid);
	}
	return true;
}

DialogCreate:Account_Register(playerid)
{
	//80FF00
	new title[64];
    new string[256] = "\t{FFFFFF}����� ���������� �� " MAIN_COLOR "Silver Break\n\n";
	strcat(string,
		"{FFFFFF}���������� ������, ������� ��� � ������:\n\
	 	����� � �������������� �����: " MAIN_COLOR "" SITE_ADRESS);
	format(title, sizeof(title), "{FFFFFF}�����������: %s", ReturnPlayerName(playerid));
	Dialog_Open(playerid, Dialog:Account_Register, DIALOG_STYLE_INPUT, title, string, "������", "", 0);
	return true;
}

DialogResponse:Account_Register(playerid, response, listitem, inputtext[])
{	// �����������
    if(response)
    {
		if(!strlen(inputtext)) return Dialog_Show(playerid, Dialog:Account_Register);
		if(!(MIN_PASS_SYMB <= strlen(inputtext) < MAX_PASS_SYMB))
		{
			new string[128];
			SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_ERROR "����������� ������ ������ �� %d �� %d ��������.", MIN_PASS_SYMB, MAX_PASS_SYMB);
		    return Dialog_Show(playerid, Dialog:Account_Register);
		}		
		OnPlayerRegister(playerid, inputtext);
	}
	else Dialog_Show(playerid, Dialog:Account_Register);
	return true;
}

DialogCreate:Account_Login(playerid)
{
	new string[288] = "\t{FFFFFF}����� ���������� �� " MAIN_COLOR "Silver Break\n\n";
	format(string, sizeof(string),
			"%s{FFFFFF}���� ��� " MAIN_COLOR "���������������{FFFFFF} � ������� �������\n\
	 		������� ������ � ������ � ������� '������' " MAIN_COLOR "(�������: %d){FFFFFF}\n\
 			����� � �������������� �����: " MAIN_COLOR "" SITE_ADRESS, string, MAX_LOG_TRIES - gPlayerLogTries{playerid});
    if(PlayerInfo[playerid][pExitUNIX] > 0)	
    {
    	format(string, sizeof(string), "%s\n\n" MAIN_COLOR "��������� ����������: %s �����\n", string, gLastLogText(gettime() - PlayerInfo[playerid][pExitUNIX]));
    }
    new title[64];
    format(title, sizeof(title), "{FFFFFF}�����������: %s", ReturnPlayerName(playerid));
	Dialog_Open(playerid, Dialog:Account_Login, DIALOG_STYLE_INPUT, title, string, "������", "", 0);
	return true;
}

DialogResponse:Account_Login(playerid, response, listitem, inputtext[])
{	// �����������
	if(response)
	{
		if(strlen(inputtext) == 0)
			return Dialog_Show(playerid, Dialog:Account_Login);
		OnPlayerLogin(playerid, inputtext);
	}
	else Dialog_Show(playerid, Dialog:Account_Login);
	return true;
}