#define MAX_BUTTONS		50

forward OnPlayerPressedButton(playerid, button);

enum E_BUTTON_INFO
{
	Float:btPos[6],
	btObjectId
}

static ButtonInfo[MAX_BUTTONS][E_BUTTON_INFO];
static lastId;

CreateButton(Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	ButtonInfo[lastId][btPos][0] = x;
	ButtonInfo[lastId][btPos][1] = y;
	ButtonInfo[lastId][btPos][2] = z;
	ButtonInfo[lastId][btPos][3] = rx;
	ButtonInfo[lastId][btPos][4] = ry;
	ButtonInfo[lastId][btPos][5] = rz;
	ButtonInfo[lastId][btObjectId] = CreateDynamicObject(2886, x, y, z, rx, ry, rz);
	CreateDynamic3DTextLabel("asd", COLOR_ACTION, x, y, z, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	return lastId++;
}

Button_OnPlayerClickEnter(playerid)
{
	for(new i = 0; i < lastId; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 1.5, ButtonInfo[i][btPos][0], ButtonInfo[i][btPos][1], ButtonInfo[i][btPos][2]))
		{
			if(MyApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 8.0, 0, 0, 0, 0, 0))
			{
				if(CallLocalFunction("OnPlayerPressedButton", "dd", playerid, i))
				{
					PlayerPlaySound(playerid, 21000, 0.0, 0.0, 0.0);
				}
				else
				{
					GameTextForPlayer(playerid, "~r~Access denied", 3000, 4);
					PlayerPlaySound(playerid, 41603, 0.0, 0.0, 0.0);// 21001
				}
			}
			return true;
		}
	}

	return false;
}