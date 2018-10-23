#include "player/header"

//	System
#include "player/player_spawn"
#include "player/anims"

//	Gameplay
#include "player/account"
#include "player/register"
#include "player/interface"
#include "player/level"
#include "player/walk"
#include "player/ask"
#include "player/autoschool"
#include "player/gym/core"

stock	ToggleNameTags(playerid, bool:toggle)
{
	pNameTags[playerid] = toggle;
	if (toggle)
	{	// Показать ники всех
		foreach(LoginPlayer, i)
			if(!InMask[i])
				ShowPlayerNameTagForPlayer(playerid, i, true);
		GameTextForPlayer(playerid, "~w~Nametags ~g~on", 5000, 5);
	}
	else
	{	// Скрыть
		foreach(LoginPlayer, i)
			ShowPlayerNameTagForPlayer(playerid, i, false);	// Скрыть ники всех
		GameTextForPlayer(playerid, "~w~Nametags ~r~off", 5000, 5);
		// Помимо этого надо скрывать ники тех, кто зашел
	}
}

stock	MySetPlayerPos(playerid, Float:x, Float:y, Float:z, Float:a = 0.0, inter = -1, vw = -1)
{
	if(SetPlayerPos(playerid, x, y, z))
	{
		SetPlayerFacingAngle(playerid, a);
		if(inter != -1)
			SetPlayerInterior(playerid, inter);
		if(vw != -1)
			SetPlayerVirtualWorld(playerid, vw);

		UpdatePlayerWeather(playerid);
		UpdatePlayerTime(playerid);
		UpdatePlayerGPSZone(playerid);
		BenchpressClear(playerid);
		return true;
	}
	else
		return false;
}

stock	MyGetPlayerPos(playerid, &Float:x = 0.0, &Float:y = 0.0, &Float:z = 0.0, &Float:a = 0.0)
{
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	return true;
}