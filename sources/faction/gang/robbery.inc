#if defined _gang_robbery_included
	#endinput
#endif

#define _gang_robbery_included

static 	GangRobberyBiz[sizeof(Faction)] = { INVALID_DATA, ... },	//	Ид бизнеса который грабит банда
		GangRobberyMembers[sizeof(Faction)],						//	Количество участников ограбления
		GangRobberyMoney[sizeof(Faction)];							//	Количество вытащеных из кассы денег

new GangRobberyReload[sizeof(Faction)];		//	Время ограничения ограблений для банд

stock RobberyStart(playerid)
{
	new gang = PlayerInfo[playerid][pFaction];
	if(IsGang(gang) == 0)
    {
        return ShowPlayerHint(playerid, "Грабить бизнесы могут только участники банды");
    }
    if(GangRobberyBiz[gang] != INVALID_DATA)
    {
    	return ShowPlayerHint(playerid, "Ваша банда уже ~r~грабит один из бизнесов");
    }
	new b = GetBizWhichPlayer(playerid);
	if(b == INVALID_DATA)	return true;
	if(BizInfo[b][bRobbery] != INVALID_PLAYER_ID)
	{
	    return ShowPlayerHint(playerid, "Этот бизнес уже грабят");
	}
	if(!BizTypeData[ BizInfo[b][bType] ][btRobbery])
	{
		return ShowPlayerHint(playerid, "Этот бизнес нельзя грабить");
	}
	new string[128];
	if(GangRobberyReload[gang] > 0)
	{
	    new time = GangRobberyReload[gang];
		format(string, sizeof(string), "Ваша банда недавно грабила~n~До ограбления: ~y~%02d мин %02d сек", time/60, time%60);
		return ShowPlayerHint(playerid, string);
	}
	if(BizInfo[b][bRobberyTime] + BIZ_ROBB_RELOAD > gettime())
	{
		return ShowPlayerHint(playerid, "Этот бизнес недавно грабили");
	}
	//---	Сообщение полиции
	format(string, sizeof(string), "[R] Диспетчер HQ: {FFFFFF}Поступило сообщение об ограблении {8D8DFF}| Район: {FFFFFF}%s", GetPointArea(BizInfo[b][bPos][0], BizInfo[b][bPos][1]));
	SendPoliceMessage(COLOR_BLUE, string);
    // Проработать под полицейскую миссию!
    //---
	ApplyActorAnimation(BizInfo[b][bActor], "SHOP", "SHP_Rob_GiveCash", 4.1, 0, 1, 1, 1, 0);
	callcmd::s(playerid, "Это ограбление! Всем оставаться на своих местах");
	BizInfo[b][bRobbery] = playerid;
	GangRobberyBiz[gang] = b;
	foreach(LoginPlayer, i)
	{
	    if(GetBizWhichPlayer(i) == b)
	    {
	        if(PlayerInfo[i][pFaction] == gang && IsPlayerAFK(i) == false && SpectateID[playerid] == INVALID_PLAYER_ID)
	        {
	            robbery_biz[i] = b;
				robbery_money[i] = 0;
	            robbery_offerid[i] = playerid;
	            robbery_step[i] = 0;
	            GangRobberyMembers[gang]++;
	            if(InMask[i] == false)	CrimePlayer(i, CRIME_ROBBERY_SHOP);
	        }
			PlayerPlaySound(i, 3401, 0.0, 0.0, 0.0);
		}
	}
    SendClientMessage(playerid, COLOR_WHITE, PREFIX_HINT "Встаньте у кассы и зажмите F, чтобы начать ограбление");
	return true;
}

stock RobberyFinish(playerid, step, bool:status)
{	// status (1 - completed, 0 - not completed)
	new b = robbery_biz[playerid];
	if(b >= 0)
	{
		new string[128];
		/////////		Вышли из магазина
		if(step == 0 && robbery_step[playerid] == 0)
		{
			if(robbery_offerid[playerid] == playerid)
			{
				if(status && GangRobberyMoney[ PlayerInfo[playerid][pFaction] ] == 0)	status = false;
				new count = 0, money = 0, remainder = 0;
				foreach(LoginPlayer, i)
				{
					if(GetBizWhichPlayer(i) == b)
				    {
				        // Остановить сигнализацию для тех кто остался в бизнесе
				        PlayerPlaySound(i, 0, 0.0, 0.0, 0.0);
				    }
					if(robbery_biz[i] >= 0 && robbery_offerid[i] == playerid)
				    {
				    	count++;
					    robbery_step[i]++;
				    }
				}
				remainder = GangRobberyMoney[ PlayerInfo[playerid][pFaction] ] % count;
				money = GangRobberyMoney[ PlayerInfo[playerid][pFaction] ] / count;
				//---
				BizInfo[b][bRobbery] = INVALID_PLAYER_ID;
				BizInfo[b][bRobberyTime] = gettime();
				if(status) GangRobberyReload[ PlayerInfo[playerid][pFaction] ] = (60 * 15);
				GangRobberyBiz[ PlayerInfo[playerid][pFaction] ] = INVALID_DATA;
				GangRobberyMembers[ PlayerInfo[playerid][pFaction] ] = 0;
				GangRobberyMoney[ PlayerInfo[playerid][pFaction] ] = 0;
				ClearActorAnimations(BizInfo[b][bActor]);
				ApplyActorAnimation(BizInfo[b][bActor], "PED", "WALK_PLAYER", 4.0, 0, 0, 0, 0, 1);
				//---
				robbery_money[playerid] += remainder;
				foreach(LoginPlayer, i)
				{
				    if(robbery_biz[i] >= 0 && robbery_offerid[i] == playerid)
				    {
			            ProgressBarHide(i);
						PlayerPlaySound(i, 0, 0.0, 0.0, 0.0);
				        if(!status)
				        {
			                GameTextForPlayer(i, RusText("~r~Миссия провалена~n~~w~Касса не ограблена", isRus(i)), 3000, 4);
			                robbery_biz[i] = -1;
				        }
				        else
				        {
		       				robbery_money[i] += money;	//	делим деньги между всеми участниками ограбления
			            	SendClientMessage(i, GetGangColor(PlayerInfo[i][pFaction]), "[Ограбления]: Доставьте деньги до дома банды!");
			            	SetPlayerAttachedObject(i, ATTACH_SLOT_IN_HAND, 1550, 1, 0.052, -0.162, 0.0, 0.0, 103.99, 164.99, 1.0, 0.69, 0.98);
				        }
				    }
				}
			}
			else
			{	//	выкидывать из ограбления если выбежал раньше лидера
				GameTextForPlayer(playerid, RusText("~r~Миссия провалена~n~~w~Бизнес покинут", isRus(playerid)), 3000, 4);
				RobberyClear(playerid);
			}
		}
		/////////	Доставил деньги до дома банды
		else if(step == 1)
		{
			if(status)
			{
				//---	добавляем деньги в общак
				if(IsGang(PlayerInfo[playerid][pFaction]))
				{
				    GiveFactionMoney(PlayerInfo[playerid][pFaction], floatround(robbery_money[playerid] * 0.1));
				    GivePlayerCrimeWage(playerid, robbery_money[playerid] * 0.9);
				}
				GameTextForPlayer(playerid, RusText("~g~Миссия выполнена", isRus(playerid)), 3000, 4);
				format(string, 128, "[Ограбления]: %s %s довез до общака %d$", GetPlayerRank(playerid), ReturnPlayerName(playerid), robbery_money[playerid]);
				SendFactionMessage(PlayerInfo[playerid][pFaction], GetGangColor(PlayerInfo[playerid][pFaction]), string);
				PlayAudioStreamForPlayer(playerid, AUDIOFILE_PATH "/complete.mp3");
			}
			else
			{	//	потерял все деньги
				GameTextForPlayer(playerid, RusText("~r~Миссия провалена~n~~w~Деньги потеряны", isRus(playerid)), 3000, 4);
			}
			RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND);
			//---	очистка
			robbery_biz[playerid] = -1;
			robbery_money[playerid] = 0;
			robbery_offerid[playerid] = 0;
			robbery_step[playerid] = 0;
		}
	}
	return true;
}

stock RobberyClear(playerid, reason = 0)
{
	if(robbery_biz[playerid] >= 0)
	{
		if(robbery_step[playerid] == 0 && robbery_offerid[playerid] == playerid)
		{
			RobberyFinish(playerid, 0, false);
		}
		else if(robbery_step[playerid] == 1)
		{
			new string[128];
			if(reason == 1)
				format(string, 128, "[Ограбления]: %s %s отключился с ограблеными деньгами (%d$)", GetPlayerRank(playerid), ReturnPlayerName(playerid), robbery_money[playerid]);
			else if(reason == 2)
				format(string, 128, "[Ограбления]: %s %s погиб с ограблеными деньгами (%d$)", GetPlayerRank(playerid), ReturnPlayerName(playerid), robbery_money[playerid]);
			SendFactionMessage(PlayerInfo[playerid][pFaction], GetGangColor(PlayerInfo[playerid][pFaction]), string);
			RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND);
		}
		robbery_biz[playerid] = -1;
		robbery_money[playerid] = 0;
		robbery_offerid[playerid] = 0;
		robbery_step[playerid] = 0;
        ProgressBarHide(playerid);
		PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
	}
}

Public: Robbering(playerid)
{
	new string[128],
		gang = PlayerInfo[playerid][pFaction],
		bank = GangRobberyMembers[gang] * ROBBERING_BANK;
	if(GangRobberyMoney[gang] < bank)
	{
	    GangRobberyMoney[gang] += 10;
		MyApplyAnimation(playerid, "SHOP", "ROB_StickUp_In", 4.0, 0, 0, 0, 0, 0);
	}
	else
	{
		KillTimer(robbery_timer[playerid]), robbery_timer[playerid] = 0;
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid, true);
		IFace.ToggleGroup(playerid, IFace.CAM_EFFECT, false);
		ShowPlayerHint(playerid, "Касса пуста!~n~Бегите отсюда!");
	}
	format(string, sizeof(string), "Robbery~n~%s%d$~w~/~g~%d$", (GangRobberyMoney[gang] < bank) ? ("~y~") : ("~g~"), GangRobberyMoney[gang], bank);
	ProgressBarUpdate(playerid, GangRobberyMoney[gang], bank, string);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	return true;
}