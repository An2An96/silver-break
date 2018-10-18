#if defined _job_core_included
	#endinput
#endif
#define _job_core_included

#include "job/header"

#include "job/interface"

#tryinclude "job/job_theft"
#tryinclude "job/job_busdriver"
#tryinclude "job/job_trucker"
#tryinclude "job/job_taxi"
#tryinclude "job/part_loader"
#tryinclude "job/part_farmer"
#tryinclude "job/part_delivery"

public OnPlayerDeath(playerid, killerid, reason)
{
	/*if(Job.GetPlayerPartWage(playerid) > 0)
	{
	    SendFormatMessage(playerid, COLOR_WHITE, string, "Вы закончили работу и получаете за нее: {FFFF00}%d$", Job.GetPlayerPartWage(playerid));
	    MyGivePlayerMoney(playerid, Job.GetPlayerPartWage(playerid)), Job.SetPlayerPartWage(playerid, 0);
	}*/
	if(!Jobs[ Job.GetPlayerNowWork(playerid) ][J_CLEAR_TYPE])
	{
		Job.ClearPlayerNowWork(playerid, Job.REASON_DEATH);
	}

	#if defined JobCore_OnPlayerDeath
		return JobCore_OnPlayerDeath(playerid, killerid, reason);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerDeath
	#undef OnPlayerDeath
#else
	#define _ALS_OnPlayerDeath
#endif

#define OnPlayerDeath JobCore_OnPlayerDeath
#if defined JobCore_OnPlayerDeath
	forward JobCore_OnPlayerDeath(playerid, killerid, reason);
#endif

public OnPlayerDisconnect(playerid, reason)
{
	Job.ClearPlayerNowWork(playerid, Job.REASON_DISCONNECT);
	#if defined	_job_job_taxi_included
		CancelUseTaxi(playerid);            			// Очистка пассажирского такси
	#endif

	#if defined JobCore_OnPlayerDisconnect
		return JobCore_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect JobCore_OnPlayerDisconnect
#if defined JobCore_OnPlayerDisconnect
	forward JobCore_OnPlayerDisconnect(playerid, reason);
#endif

//////////////////////////////////
Job.SetORM(ORM:ormid, playerid)
{
	orm_addvar_int(ormid, 	pJob[playerid],			"job");
	orm_addvar_int(ormid, 	pContract[playerid], 	"contract");
	orm_addvar_float(ormid, pJobWage[playerid],		"wage");
	orm_addvar_float(ormid, pPartWage[playerid],	"job_wage");
}

//////////	Player Job 	//////////
stock Job.DismissPlayer(playerid)
{
	if(pContract[playerid] > 0)
	{
		new string[128];
		SendFormatMessage(playerid, COLOR_WHITE, string, "[Работа]: По контракту вы обязаны отработать еще %d минут.", pContract[playerid]);
		return false;
	}
	Job.SetPlayerJob(playerid, JOB_NONE);
	return true;
}

stock Job.SetPlayerJob(playerid, job, contract = 0)
{
	if(job == pJob[playerid])
	{
		return true;
	}
	if(pContract[playerid] > 0)
	{
		new string[128];
		SendFormatMessage(playerid, COLOR_WHITE, string, "[Работа]: По контракту вы обязаны отработать еще %d минут.", pContract[playerid]);
		return false;
	}
	if(pJob[playerid] == pAtWork[playerid])
	{
		Job.ClearPlayerNowWork(playerid);
	}
	pJob[playerid] 		= job;
	pContract[playerid] = contract;
	Job.UpdatePlayerMapIcon(playerid);
	return true;
}

stock Job.GetPlayerJob(playerid)
{
	return pJob[playerid];
}

stock Job.GetPlayerContract(playerid)
{
	return pContract[playerid];
}

stock Job.SetPlayerContract(playerid, contract)
{
	pContract[playerid] = contract;
}

//////////	Now Work 	//////////
stock Job.SetPlayerNowWork(playerid, job)
{
	if(Job.GetPlayerNowWork(playerid) != job)
	{
		if(Job.GetPlayerNowWork(playerid))
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете начать новую работу, пока не закончите прошлую.");
			return false;
		}
		if(!CallLocalFunction("OnPlayerStartWork", "ddd", playerid, job))
		{
			return false;
		}
		pPartWage[playerid]	= 0;
		pAtWork[playerid]	= job;
	}
	return true;
}

stock Job.GetPlayerNowWork(playerid)
{
	return IsValidPlayer(playerid) ? pAtWork[playerid] : JOB_NONE;
}

stock Job.ClearPlayerNowWork(playerid, reason = Job.REASON_COMPLETE)
{
	if(pAtWork[playerid] != JOB_NONE)
	{
		new string[128];
		CallLocalFunction("OnPlayerFinishWork", "ddd", playerid, pAtWork[playerid], reason);
		if(Jobs[ pAtWork[playerid] ][J_PART])
		{
			if(reason != Job.REASON_DISCONNECT)
			{
				SendFormatMessage(playerid, COLOR_WHITE, string, "Вы закончили работу и получаете за нее: "MAIN_COLOR"%d$", Job.GetPlayerPartWage(playerid));
				MyGivePlayerMoney(playerid, Job.GetPlayerPartWage(playerid));
				Job.SetPlayerPartWage(playerid, 0.0);
			}
		}
		else
		{
			SendFormatMessage(playerid, COLOR_WHITE, string, "Вы закончили работу и получаете за нее: "MAIN_COLOR"%d$", Job.GetPlayerPartWage(playerid));
			if(Jobs[ pAtWork[playerid] ][J_OFF])
			{
				Job.GivePlayerWage(playerid, Job.GetPlayerPartWage(playerid));
			}
			else
			{
				MyGivePlayerMoney(playerid, Job.GetPlayerPartWage(playerid));
			}
			Job.SetPlayerPartWage(playerid, 0.0);
		}
		if(reason != Job.REASON_DEATH)
		{
			ReloadPlayerSkin(playerid);
		}
		HideWorkInfo(playerid);
		pAtWork[playerid] = JOB_NONE;
	}
}

//////////		Wage 	//////////
stock Job.GivePlayerWage(playerid, Float:amount)
{
	pJobWage[playerid] += amount;
}

stock Job.SetPlayerWage(playerid, Float:amount)
{
	pJobWage[playerid] = amount;
}

stock Float:Job.GetPlayerWage(playerid)
{
	return pJobWage[playerid];
}

stock CalcWage(wage, level)
{
	return wage + floatround(wage * (getWageBonus(level) / 100.0));
}

stock getWageBonus(level)
{
	switch(level)
	{
	    case 2: return 5;
	    case 3: return 10;
	    case 4: return 15;
	    case 5: return 20;
	}
	return 0;
}

//////////	Part Wage 	//////////
stock Job.GivePlayerPartWage(playerid, Float:amount)
{
	pPartWage[playerid] += amount;
}

stock Job.SetPlayerPartWage(playerid, Float:amount)
{
	pPartWage[playerid] = amount;
}

stock Job.GetPlayerPartWage(playerid)
{
	return floatround(pPartWage[playerid]);
}

////////////////////////////////////////
stock SendJobMessage(job, color, string[])
{
	foreach(LoginPlayer, i)
	{
	    if(pJob[i] == job)
	    {
	        SendClientMessage(i, color, string);
	    }
	}
	return true;
}

stock GetJobName(job)
{
	new jname[24] = "Безработный";
	if(0 <= job < sizeof(Jobs))	format(jname, 24, "%s", Jobs[job][J_NAME]);
	return jname;
}

stock IsLegalJob(job)
{
	if(job < 0 || job >= sizeof(Jobs))
	{
		return false;
	}
	return Jobs[job][J_OFF];
}

stock Job.UpdatePlayerMapIcon(playerid)
{
	DestroyDynamicMapIcon(pJobMapIcon[playerid]), pJobMapIcon[playerid] = INVALID_STREAMER_ID;
	if(0 < pJob[playerid] < sizeof(Jobs)
	&& Jobs[ pJob[playerid] ][J_POS][0] != 0.0 && Jobs[ pJob[playerid] ][J_POS][1] != 0.0)
	{
		pJobMapIcon[playerid] = CreateDynamicMapIcon(Arr3<Jobs[ pJob[playerid] ][J_POS]>, 51, 0, -1, -1, playerid, 3000.0, MAPICON_GLOBAL);
	}
	return true;
}