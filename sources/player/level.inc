#include "interface/exp_line"

stock	UpdatePlayerLVL(playerid)
{
	new string[32];
	SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
	format(string, 32, "LVL: %d", PlayerInfo[playerid][pLevel]);
	//PlayerTextDrawSetString(playerid, StatusLVL, string);
	return true;
}

//stock UpdatePlayerUpgrade(playerid)
//{
    //new string[32];
	//format(string, 32, "UPGRADE: %d", PlayerInfo[playerid][pUpgrade]);
	//PlayerTextDrawSetString(playerid, StatusUpgrade, string);
//	return true;
//}

stock	GivePlayerEXPInTime(playerid, Float:amount, time = 10)
{
	gExpTime[playerid] = time;
	gExpCount[playerid] += amount;
}

GivePlayerEXP(playerid, amount)
{
	new curlevel = PlayerInfo[playerid][pLevel],
		curexp = PlayerInfo[playerid][pExp],
		cur = PlayerInfo[playerid][pExp] + amount,
		chlevel = 0, chlevelexp = 0;
	if(amount < 0)
	{
		while(cur < 0)
		{
			chlevel++;
			if(PlayerInfo[playerid][pLevel] - chlevel < 1)
			{
				chlevel = PlayerInfo[playerid][pLevel];
				if(cur < 0)	cur = 0;
				break;
			}
			chlevelexp = NextLvlExp(PlayerInfo[playerid][pLevel] - chlevel + 1);
			cur += chlevelexp;
		}
		PlayerInfo[playerid][pExp] = cur;
		PlayerInfo[playerid][pExpsum] -= amount;
		if(PlayerInfo[playerid][pExpsum] < 0)	PlayerInfo[playerid][pExpsum] = 0;
		if(chlevel)
		{
			PlayerInfo[playerid][pLevel] -= chlevel;
			UpdatePlayerLVL(playerid);
			SetTimerEx("LevelDownTimer", 3000, false, "dd", playerid, chlevel);
		}
	}
	else
	{
		while(cur)
		{
	   	    chlevelexp = NextLvlExp(PlayerInfo[playerid][pLevel] + chlevel + 1);
		    if(cur >= chlevelexp)
		    {	// Level up
				chlevel++;
		        cur -= chlevelexp;
		    }
		    else
		    {
		    	break;
		    }
		}
		PlayerInfo[playerid][pExp] = cur;
		PlayerInfo[playerid][pExpsum] += cur;
		if(chlevel)
		{
			PlayerInfo[playerid][pLevel] += chlevel;
		    PlayerInfo[playerid][pUpgrade] += chlevel;
			//UpdatePlayerUpgrade(playerid);
			UpdatePlayerLVL(playerid);
			SetTimerEx("LevelUpTimer", 3000, false, "dd", playerid, chlevel);
		}
	}
	
	#if defined _interface_exp_line_included
		IFace.ToggleGroup(playerid, IFace.EXP_LINE, true);
  		IFace.ExpLine_Update(playerid, curlevel, curexp, amount);
	#endif
	
	return true;
}

Public: LevelUpTimer(playerid, newlevel)
{
	new string[32];
	
	if (newlevel == 1)
		strcat(string, "Level up!~n~~w~Upgrade +1");
	else
		format(string, sizeof(string), "%d Level's up!~n~~w~Upgrade +%d", newlevel, newlevel);
	GameTextForPlayer(playerid, string, 5000, 6);
    //PlayerPlaySound(playerid, 31205, 0.0, 0.0, 0.0);// Пионерская труба
    PlayerPlaySound(playerid, 36205, 0.0, 0.0, 0.0);// Ликуют и аплодируют
    SuccesAnim(playerid);
}

Public: LevelDownTimer(playerid, newlevel)
{
	new string[32];
	
	if (newlevel == 1)
		strcat(string, "Level down!");
	else
		format(string, sizeof(string), "%d Level's down!", newlevel);
	GameTextForPlayer(playerid, string, 5000, 6);
	PlayerPlaySound(playerid, 31202, 0.0, 0.0, 0.0);
	LoseAnim(playerid);
}

flags:setlvl(CMD_DEVELOPER);
COMMAND:setlvl(playerid, params[])
{
    new targetid, amount;
	if(sscanf(params, "ri", targetid, amount)){
		return SendClientMessage(playerid, COLOR_WHITE, "Используйте: /setlvl [playerid/playername] [amount]");
	}
    if(!IsPlayerLogged(targetid)){
        return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Этого игрока нет на сервере.");
    }
    new string[256];
	PlayerInfo[targetid][pLevel] = amount;
	PlayerInfo[targetid][pExp] = 0;
	//UpdatePlayerEXP(targetid);
	UpdatePlayerLVL(targetid);
	format(string, sizeof(string), "[AdmCmd]: %s %s[%d] изменил уровень %s[%d]: %d lvl",
		GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, ReturnPlayerName(targetid), targetid, amount);
	SendAdminMessage(COLOR_ADMIN, string);
	SendFormatMessage(targetid, COLOR_LIGHTBLUE, string, "%s %s[%d] изменил ваш уровень: %d lvl", GetPlayerAdminStatus(playerid), ReturnPlayerName(playerid), playerid, amount);
	return true;
}