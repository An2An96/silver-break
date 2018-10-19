#if defined _player_walk_included
	#endinput
#endif
#define _player_walk_included

enum
{
	WALK_DEFAULT,
	WALK_NORMAL,
	WALK_PED,
	WALK_GANGSTA,
	WALK_GANGSTA2,
	WALK_OLD,
	WALK_FAT_OLD,
	WALK_FAT,
	WALK_LADY,
	WALK_LADY2,
	WALK_WHORE,
	WALK_WHORE2,
	WALK_DRUNK,
	WALK_BLIND
}

new const WalkAnims[][16] = {
	"", "WALK_player", "WALK_civi", "WALK_gang1", "WALK_gang2", "WALK_old", 
	"WALK_fatold", "WALK_fat", "WOMAN_walknorm", "WOMAN_walkbusy", 
	"WOMAN_walkpro", "WOMAN_walksexy", "WALK_drunk", "Walk_Wuzi"
};

static
	walktime[MAX_PLAYERS],
	WalkStyle[MAX_PLAYERS],
	bool:pWalking[MAX_PLAYERS];

Public: Walk_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if (((newkeys & KEY_WALK && newkeys & KEY_UP) || (newkeys & KEY_WALK && newkeys & KEY_DOWN) || (newkeys & KEY_WALK && newkeys & KEY_LEFT) || (newkeys & KEY_WALK && newkeys & KEY_RIGHT))
		|| ((oldkeys & KEY_WALK && newkeys & KEY_UP) || (oldkeys & KEY_WALK && newkeys & KEY_DOWN) || (oldkeys & KEY_WALK && newkeys & KEY_LEFT) || (oldkeys & KEY_WALK && newkeys & KEY_RIGHT))
		|| ((newkeys & KEY_WALK && oldkeys & KEY_UP) || (newkeys & KEY_WALK && oldkeys & KEY_DOWN) || (newkeys & KEY_WALK && oldkeys & KEY_LEFT) || (newkeys & KEY_WALK && oldkeys & KEY_RIGHT)))
		{	
			if(!pWalking[playerid])
			{
				walktime[playerid] = SetTimerEx("WalkAnim", 200, true, "d", playerid);
			}
		}
	}
	return CONTINUE;
}

Public: WalkAnim(playerid)
{
	new walk = GetPlayerWalkingStyle(playerid);
	if(walk > WALK_DEFAULT)
	{
		new keys, updown, leftright;
		GetPlayerKeys(playerid, keys, updown, leftright);
 	 	if(keys & KEY_WALK && (updown & KEY_UP || updown & KEY_DOWN || leftright & KEY_LEFT || leftright & KEY_RIGHT))
		{
			//if(!pWalking[playerid])
			//{
			ApplyAnimation(playerid, "PED", WalkAnims[walk], 4.1, 1, 1, 1, 1, 1);
			pWalking[playerid] = true;
			//}
		}
		else if(pWalking[playerid])
		{
			ApplyAnimation(playerid, "PED", WalkAnims[walk], 4.0, 0, 0, 0, 0, 1);
			KillTimer(walktime[playerid]);
			pWalking[playerid] = false;
		}
	}
	return true;
}

stock SetPlayerWalkingStyle(playerid, style)
{
	WalkStyle[playerid] = style;
	return true;
}

stock GetPlayerWalkingStyle(playerid)
{
	return WalkStyle[playerid];
}