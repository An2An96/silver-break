#define MAX_GATES		50

enum E_GATE_INFO
{
	gModelId,
	Float:gPos[6],
	Float:gOpenPos[3],
	Float:gSpeed,
	gTime,
	gObjectId,
	bool:gStatus,
}

static GateInfo[MAX_GATES][E_GATE_INFO];
static lastId;

CreateGate(objectid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:ox, Float:oy, Float:oz, Float:speed = 1.0, time = 0)
{
	GateInfo[lastId][gModelId]		= objectid;
	GateInfo[lastId][gPos][0]		= x;
	GateInfo[lastId][gPos][1]		= y;
	GateInfo[lastId][gPos][2]		= z;
	GateInfo[lastId][gPos][3]		= rx;
	GateInfo[lastId][gPos][4]		= ry;
	GateInfo[lastId][gPos][5]		= rz;
	GateInfo[lastId][gOpenPos][0]	= ox;
	GateInfo[lastId][gOpenPos][1]	= oy;
	GateInfo[lastId][gOpenPos][2]	= oz;
	GateInfo[lastId][gObjectId]		= CreateDynamicObject(GateInfo[lastId][gModelId], Arr6<GateInfo[lastId][gPos]>);
	GateInfo[lastId][gSpeed] 		= speed;
	GateInfo[lastId][gTime] 		= time;
	return lastId++;
}

stock OpenGate(gateid)
{
	if(0 <= gateid < sizeof(GateInfo))
	{
		if(GateInfo[gateid][gTime] > 0)
		{
			if(!IsDynamicObjectMoving(GateInfo[gateid][gObjectId]))
			{
				MoveDynamicObject(GateInfo[gateid][gObjectId], Arr3<GateInfo[gateid][gOpenPos]>, GateInfo[gateid][gSpeed]);
				GateInfo[gateid][gStatus] = true;
				SetTimerEx("CloseGate", GateInfo[lastId][gTime], 0, "i", gateid);
			}
		}
		else
		{
			if(GateInfo[gateid][gStatus])
			{
				CloseGate(gateid);
			}
			else
			{
				MoveDynamicObject(GateInfo[gateid][gObjectId], Arr3<GateInfo[gateid][gOpenPos]>, 1.0);
				GateInfo[gateid][gStatus] = true;
			}
		}
	}
	return true;
}

Public: CloseGate(gateid)
{
	MoveDynamicObject(GateInfo[gateid][gObjectId], Arr3<GateInfo[gateid][gPos]>, GateInfo[gateid][gSpeed]);
	GateInfo[gateid][gStatus] = false;
	return true;
}