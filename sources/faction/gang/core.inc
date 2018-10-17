#if defined _gang_core_included
	#endinput
#endif

#define _gang_core_included

#include "faction/gang/header"

#include "faction/gang/gang_zones"
#include "faction/gang/robbery"
#include "faction/gang/interface"

Public: Gang.OnGameModeInit()
{
	GangZone_Load();
	
	return CONTINUE;
}

stock IsPlayerInGetto(playerid)
{
    return IsPlayerInSquare(playerid, 1650.00, -2167.17, 2882.00, -945.28);
}

stock SendGangMessageToAll(color, string[])
{
	foreach(LoginPlayer, i)
	    if(IsGang(PlayerInfo[i][pFaction]))
	        SendClientMessage(i, color, string);
	return true;
}

stock IsGang(faction)
{
	if(0 < faction < sizeof(Faction))
	{
	    switch(Faction[faction][F_ID])
	    {
	        case F_GROVE, F_BALLAS, F_VAGOS, F_AZTECAS, F_RIFA: return true;
	    }
	}
	return false;
}

stock GetGangColorChart(faction)
{
	if(0 < faction < sizeof(Faction))
	{
	    switch(Faction[faction][F_ID])
	    {
	        case F_GROVE:	return 'g';
			case F_BALLAS:	return 'p';
			case F_VAGOS:	return 'y';
			case F_AZTECAS:	return 'b';
			case F_RIFA:	return 'w';
	    }
	}
	return 'l';
}

stock GetGangColor(faction, bool:bright = true)
{
	if(0 < faction < sizeof(Faction))
	{
	    switch(Faction[faction][F_ID])
	    {
	        /*case F_GROVE:	{ if(bright) return 0x0DE01888; else return 0x0DE018FF; }
			case F_BALLAS:	{ if(bright) return 0xC715FF88; else return 0xC715FFFF; }
			case F_VAGOS:	{ if(bright) return 0xFFD72088; else return 0xFFD720FF; }
			case F_AZTECAS:	{ if(bright) return 0x0FD9FA88; else return 0x0FD9FAFF; }
			case F_RIFA:	{ if(bright) return 0x77889988; else return 0x778899FF; }*/

			case F_GROVE:	{ if(bright) return 0x119103CC; else return 0x0DE018FF; }
			case F_BALLAS:	{ if(bright) return 0xD20068CC; else return 0xC715FFFF; }
			case F_VAGOS:	{ if(bright) return 0xF3D400CC; else return 0xFFD720FF; }
			case F_AZTECAS:	{ if(bright) return 0x00A8FFCC; else return 0x0FD9FAFF; }
			case F_RIFA:	{ if(bright) return 0x5665bACC; else return 0x778899FF; }
	    }
	}
	if(bright)	return 0xFFFFFF88;
	else		return 0xFFFFFFFF;
}

stock GetGangColorRGB(faction)
{
	new rgb[8] = "000000";
	if(0 < faction < sizeof(Faction))
	{
	    switch(Faction[faction][F_ID])
	    {
	        case F_GROVE:	rgb = "0DE018";
			case F_BALLAS:	rgb = "C715FF";
			case F_VAGOS:	rgb = "FFD720";
			case F_AZTECAS:	rgb = "0FD9FA";
			case F_RIFA:	rgb = "778899";
	    }
	}
	return rgb;
}