COMMAND:leaders(playerid, params[])
{
	new lstring[2048], bool:founded;
	foreach(LoginPlayer, i)
	{
	    if(IsPlayerLeader(i))
	    {
		    format(lstring, sizeof(lstring), "%s{B1C8FB}%s: {FFFFFF}%s [тел: %d]\n", lstring, GetFactionName(PlayerInfo[i][pFaction]), ReturnPlayerName(i), PlayerInfo[i][pPhoneNumber]);
		    founded = true;
		}
	}
	if(founded == false)
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Сейчас нет ни одного лидера организации.");
		return 1;
	}
	MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "Лидеры организаций онлайн", lstring, "Закрыть", "");
	return 1;
}

COMMAND:members(playerid, params[])
{
	if(!(0 < PlayerInfo[playerid][pFaction] < sizeof(Faction)))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не состоите ни в одной организации.");
	return ShowDialog(playerid, DFACT_MEMBERS);
}

COMMAND:invite(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] == F_NONE || PlayerInfo[playerid][pRank] < GetRankMax(PlayerInfo[playerid][pFaction]) - 1)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете использовать эту команду.");
    new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
	    return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /invite [playerid/playername]");
	if(playerid == giveplayerid)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете пригласить самого себя.");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого игрока нет на сервере.");
	if(!IsPlayerNearPlayer(playerid, giveplayerid, 10.0))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этот игрок слишком далеко от вас.");
	if(PlayerInfo[giveplayerid][pFaction] != 0)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этот игрок состоит в другой организации.");
	/*if(Job.GetPlayerJob(giveplayerid) != JOB_NONE)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этот игрок работает на работе.");*/

	if(IsForce(PlayerInfo[playerid][pFaction]))
	{
	    if(PlayerInfo[playerid][pLaw] < 0)
	    {
		    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этот игрок имеет отрицательную законопослушность.");
	    }
	}
	else if(IsGang(PlayerInfo[playerid][pFaction]))
	{
		if(GetPlayerInterior(playerid) == 0)
		{	// На улице только в гетто
			if(!IsPlayerInGetto(playerid))
			{
			    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Эту команду можно использовать только в Гетто.");
			}
		}
		else
		{	// В интерьере только возле склада банд
		    new bool:founded = false;
		    for(new i; i < 5; i++)
		    {
		        new Float:pos[3];
				GetDynamicPickupPos(WarehousePickup[i], Arr3<pos>);
				if(IsPlayerInRangeOfPoint(playerid, 50.0, Arr3<pos>))
				{
				    founded = true;
				    break;
				}
		    }
		    if(!founded)
		    {
		    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Эту команду можно использовать только в Гетто.");
		    }
		}
	}
	if(AskPlayer(playerid, giveplayerid, ASK_INVITE))
	{
		new string[192];
		AskAmount[giveplayerid] = PlayerInfo[playerid][pFaction];
		SendFormatMessage(giveplayerid, COLOR_LIGHTBLUE, string, "%s приглашает вступить в организацию %s "ASK_CONFIRM_INFO, ReturnPlayerName(playerid), GetFactionName(PlayerInfo[playerid][pFaction]));
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "Вы пригласили %s вступить в свою организацию %s", ReturnPlayerName(giveplayerid), GetFactionName(PlayerInfo[playerid][pFaction]));
		if(!IsAvailableJob(playerid, Job.GetPlayerJob(giveplayerid))) SendClientMessage(giveplayerid, COLOR_LIGHTRED, "Ваша нынешняя работа сбросится, если вы согласитесь!");
	}
	else
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У игрока есть не принятый запрос, попробуйте позже.");
	}
	return true;
}

COMMAND:uninvite(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] == F_NONE || PlayerInfo[playerid][pRank] < GetRankMax(PlayerInfo[playerid][pFaction]) - 1)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете использовать эту команду.");
	new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /uninvite [playerid/playername]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого игрока нет на сервере.");
	if(PlayerInfo[giveplayerid][pFaction] != PlayerInfo[playerid][pFaction])
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этот игрок не числится в вашей организации.");
	if(PlayerInfo[playerid][pRank] <= PlayerInfo[giveplayerid][pRank])
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете выгнать игрока этого ранга.");

	new string[128];
	SetPlayerFaction(giveplayerid, F_NONE);
	SendFormatMessage(playerid, COLOR_LIGHTRED, string, "Вы выгнали %s из организации", ReturnPlayerName(giveplayerid));
	SendFormatMessage(giveplayerid, COLOR_LIGHTRED, string, "%s %s выгнал вас из организации", GetPlayerRank(playerid), ReturnPlayerName(playerid));

	format(string, sizeof(string), "%s uninvite %s : %s", ReturnPlayerName(playerid), ReturnPlayerName(giveplayerid), GetFactionName(PlayerInfo[playerid][pFaction]));
	log("Faction", string);
	return true;
}

COMMAND:auninvite(playerid, params[])
{
    if(GetPlayerAdmin(playerid) < ADMIN_ADMIN)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете использовать эту команду.");
	new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /uninvite [playerid/playername]");
    if(!IsPlayerLogged(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого игрока нет на сервере.");
	if(IsPlayerLeader(giveplayerid))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Эта команда не можете выгнать лидера из фракции.");

	SetPlayerFaction(giveplayerid, F_NONE);

	new string[128];
	format(string, 128, "[AdmCmd]: %s %s[%d] выгнал игрока %s[%d] из фракции",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(giveplayerid), giveplayerid);
	SendAdminMessage(COLOR_ADMIN, string);
	if(!GetPlayerAdmin(giveplayerid))
	{
		format(string, 128, "%s {FFFFFF}%s[%d]{FF6347} выгнал вас из фракции", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid);
		SendClientMessage(giveplayerid, COLOR_LIGHTRED, string);
	}
	return true;
}

COMMAND:giverank(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] == F_NONE || PlayerInfo[playerid][pRank] < GetRankMax(PlayerInfo[playerid][pFaction]) - 1)
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете использовать эту команду.");
    new giveplayerid;
	if(sscanf(params, "r", giveplayerid))
	    return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /giverank [playerid/playername]");
    if(!IsPlayerLogged(giveplayerid))
	    return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого игрока нет на сервере.");
	if(!IsPlayerNearPlayer(playerid, giveplayerid, 10.0))
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этот игрок слишком далеко от вас.");
	if(PlayerInfo[giveplayerid][pFaction] != PlayerInfo[playerid][pFaction])
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этот игрок не числится в вашей организации.");
	if(PlayerInfo[playerid][pRank] <= PlayerInfo[giveplayerid][pRank])
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете выдать ранг этому игроку.");
		
    SetPVarInt(playerid, "giverank_targetid", giveplayerid);
	ShowDialog(playerid, DMODE_GIVERANK);
	return true;
}