#include "player/phone/header"

#include "player/phone/dialogs"
#include "player/phone/commands"
#include "player/phone/interface"

stock	Phone_CallTimer(playerid)
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
	new string[256];
	//  Set Vars
	call_phone[playerid][0] = targetid;
	call_phone[playerid][1] = PHONE_WAIT;
	call_phone[playerid][2] = 0;
	call_phone[targetid][0]	= playerid;
	call_phone[targetid][1]	= PHONE_CALL;
	call_phone[targetid][2] = 0;
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
			new string[128];
			SendFormatMessage(call_phone[playerid][0], COLOR_WHITE, string, PREFIX_PHONE "Разговор с %s (%d) прервался.", ReturnPlayerName(playerid), PlayerInfo[playerid][pPhoneNumber]);
		}
		_ClearCall(playerid);
	}
	return true;
}

stock Phone_GetSpeaker(playerid)
	return call_phone[playerid][0];

stock Phone_GetStatus(playerid)
	return call_phone[playerid][1];

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

stock _ClearCall(playerid)
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

stock _CheckPhoneNumber(number)
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