flags:setvw(CMD_MODER);
COMMAND:setvw(playerid, params[])
{// [BT]
	new giveplayerid, vw;
	if(sscanf(params, "ri", giveplayerid, vw))
		return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /setvw [playerid] [vw]");
	if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого игрока нет на сервере.");
	if(GetPlayerState(giveplayerid) == 2)
	    SetVehicleVirtualWorld(GetPlayerVehicleID(giveplayerid), vw);
	SetPlayerVirtualWorld(giveplayerid, vw);
    SendClientMessage(playerid, COLOR_WHITE, "Задан новый виртуальный мир для игрока");
    SendClientMessage(giveplayerid, COLOR_WHITE, "Администратор изменил ваш виртуальный мир");
	return 1;
}

flags:setint(CMD_MODER);
COMMAND:setint(playerid, params[])
{// [BT]
	new inter, giveplayerid;
	if(sscanf(params, "ri", giveplayerid, inter))
		return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /setint [playerid] [int]");
	if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого игрока нет на сервере.");
	SetPlayerInterior(giveplayerid, inter);
    SendClientMessage(playerid, COLOR_WHITE, "Задан новый интерьер для игрока");
    SendClientMessage(giveplayerid, COLOR_WHITE, "Администратор изменил вам интерьер");
    return 1;
}