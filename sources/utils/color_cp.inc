#define MAX_COLOR_CP						50
#define	IsPlayerInColorCheckID(%0,%1)		cEntered[%0][%1]

forward OnPlayerEnterColorCP(playerid, checkpointid);

enum
{
	CCP_COLOR_RED,
	CCP_COLOR_ORANGE,
	CCP_COLOR_YELLOW,
	CCP_COLOR_GREEN,
	CCP_COLOR_BLUE,
}

enum E_COLOR_CP
{
	Float:CCP_POS[3],
	CCP_COLOR,
	CCP_PLAYER,

	CCP_OBJECT,
	CCP_AREA
}
new ColorCPInfo[MAX_COLOR_CP][E_COLOR_CP];
new bool:cEntered[MAX_PLAYERS][MAX_COLOR_CP];

FindFreeSlot()
{
	for(new i = 0; i < MAX_COLOR_CP; i++)
	{
		if(ColorCPInfo[i][CCP_OBJECT] == INVALID_STREAMER_ID)
		{
			return i;
		}
	}
	return -1;
}

SetPlayerColorCP(playerid, color, Float:x, Float:y, Float:z)
{
	new slot = FindFreeSlot();
	if(slot == -1 || !(CCP_COLOR_RED <= color <= CCP_COLOR_BLUE))	return false;

	ColorCPInfo[slot][CCP_POS][0] = x, ColorCPInfo[slot][CCP_POS][1] = y, ColorCPInfo[slot][CCP_POS][2] = z;
	ColorCPInfo[slot][CCP_OBJECT] = CreateDynamicObject(1317, x, y, z, 0.0, 0.0, 0.0, -1, -1, playerid);
	ColorCPInfo[slot][CCP_PLAYER] = playerid;
	switch(color)
	{
		case CCP_COLOR_RED:		SetDynamicObjectMaterial(ColorCPInfo[slot][CCP_OBJECT], 0, 18646, "matcolours", "red-4", 0x99FF0000);
		case CCP_COLOR_ORANGE:	SetDynamicObjectMaterial(ColorCPInfo[slot][CCP_OBJECT], 0, 18646, "matcolours", "red-4", 0x99FF0000);
		case CCP_COLOR_YELLOW:	SetDynamicObjectMaterial(ColorCPInfo[slot][CCP_OBJECT], 0, 18646, "matcolours", "red-4", 0x99FF0000);
		case CCP_COLOR_GREEN:	SetDynamicObjectMaterial(ColorCPInfo[slot][CCP_OBJECT], 0, 18646, "matcolours", "red-4", 0x99FF0000);
		case CCP_COLOR_BLUE:	SetDynamicObjectMaterial(ColorCPInfo[slot][CCP_OBJECT], 0, 18646, "matcolours", "red-4", 0x99FF0000);
	}
	ColorCPInfo[slot][CCP_AREA] = CreateDynamicSphere(x, y, z, 1.0, -1, -1, playerid);
	return slot;
}

public OnPlayerConnect(playerid)
{
	for(new i = 0; i < MAX_COLOR_CP; i++) cEntered[playerid][i] = false;
	
	return CallLocalFunction("CCP_OnPlayerConnect", "i", playerid);
}
forward CCP_OnPlayerConnect(playerid);
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect CCP_OnPlayerConnect

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	for(new i = 0; i < MAX_COLOR_CP; i++)
	{
		printf("areaid %d %d", areaid, ColorCPInfo[i][CCP_AREA]);
		if(areaid == ColorCPInfo[i][CCP_AREA])
		{
			CallLocalFunction("OnPlayerEnterColorCP", "ii", playerid, i);
		}
	}

	return CallLocalFunction("CCP_OnPlayerEnterDynamicArea", "ii", playerid, areaid);
}
forward CCP_OnPlayerEnterDynamicArea(playerid, areaid);
#if defined _ALS_OnPlayerEnterDynamicArea
	#undef OnPlayerEnterDynamicArea
#else
	#define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea CCP_OnPlayerEnterDynamicArea

stock IsPlayerInAnyColorCheck(playerid)
{
	for(new i = 0; i < MAX_COLOR_CP; i++) if(IsPlayerInColorCheckID(playerid, i)) return true;
	return false;
}

stock GetPlayerColorCheckID(playerid)
{
	for(new i = 0; i < MAX_COLOMAX_COLOR_CPR_CHECK; i++) if(IsPlayerInColorCheckID(playerid, i)) return i;
	return -1;
}