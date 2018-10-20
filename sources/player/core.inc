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