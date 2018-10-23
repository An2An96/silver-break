stock AC_GivePlayerWeapon(playerid, weaponid, ammo)
{
	new slot = GetWeaponSlot(weaponid);
	if(slot != 255)
	{
	    SetPVarInt(playerid, "AC:Weapon:GTC", GetTickCount()); 
	    p_Protect[playerid][prWeaponID][slot] = weaponid;
	    p_Protect[playerid][prWeaponAmmo][slot] += ammo;
	    GivePlayerWeapon(playerid, weaponid, ammo);
	    
	    switch(GetPlayerState(playerid))
	    {
	        case PLAYER_STATE_DRIVER:
	        {
	            // Убрать оружие из рук водителя
	            SetPlayerArmedWeapon(playerid, 0);
	        }
	        case PLAYER_STATE_PASSENGER:
	        {
	            // Убрать оружие из рук пассажира
	            if(!(3 <= slot <= 5))
	            {
	                // Кроме дробовиков, полуавтоматов и автоматов
	                SetPlayerArmedWeapon(playerid, 0);
	            }
	        }
	    }
	}
}
#if defined _ALS_GivePlayerWeapon
	#undef GivePlayerWeapon
#else
	#define _ALS_GivePlayerWeapon
#endif
#define GivePlayerWeapon AC_GivePlayerWeapon

stock AC_SetPlayerWeapon(playerid, weaponid, ammo)
{
	new slot = GetWeaponSlot(weaponid);
	if(slot != 255)
	{
	    SetPVarInt(playerid, "AC:Weapon:GTC", GetTickCount()); 
	    p_Protect[playerid][prWeaponID][slot] = weaponid;
	    p_Protect[playerid][prWeaponAmmo][slot] = ammo;
	    ResetPlayerWeapons(playerid);
	    for(new s = 0; s < 13; s++)
		{
			GivePlayerWeapon(playerid, p_Protect[playerid][prWeaponID][s], p_Protect[playerid][prWeaponAmmo][s]); 
		}
	}
}
#if defined _ALS_SetPlayerWeapon
	#undef SetPlayerWeapon
#else
	#define _ALS_SetPlayerWeapon
#endif
#define SetPlayerWeapon AC_SetPlayerWeapon

stock AC_ResetPlayerWeapons(playerid)
{
	SetPVarInt(playerid, "AC:Weapon:GTC", GetTickCount()); 
	ResetPlayerWeapons(playerid);
	for(new s = 0; s < 13; s++)
	{
		p_Protect[playerid][prWeaponID][s] = 0;
	    p_Protect[playerid][prWeaponAmmo][s] = 0;
	}
	return true;
}
#if defined _ALS_ResetPlayerWeapons
	#undef ResetPlayerWeapons
#else
	#define _ALS_ResetPlayerWeapons
#endif
#define ResetPlayerWeapons AC_ResetPlayerWeapons

stock AC_UpdatePlayerWeapon(playerid)
{
	ResetPlayerWeapons(playerid);
	for(new s = 0; s < 13; s++)
	{
		MySetPlayerWeapon(playerid, p_Protect[playerid][prWeaponID][s], p_Protect[playerid][prWeaponAmmo][s]);
	}
	SetPlayerArmedWeapon(playerid,  0);
	return true;
}
#if defined _ALS_UpdatePlayerWeapon
	#undef UpdatePlayerWeapon
#else
	#define _ALS_UpdatePlayerWeapon
#endif
#define UpdatePlayerWeapon AC_UpdatePlayerWeapon

Public: AC_RearmedPlayerWeapon(playerid)
{
    new bool:founded = false;
    for(new i = 3; i <= 5; i++)
    {
        if(p_Protect[playerid][prWeaponID][i] > 0 && p_Protect[playerid][prWeaponAmmo][i] > 0)
        {
            founded = true;
			SetPlayerArmedWeapon(playerid, p_Protect[playerid][prWeaponID][i]);
			break;
        }
    }
    if(!founded) SetPlayerArmedWeapon(playerid, 0);
}
#if defined _ALS_RearmedPlayerWeapon
	#undef RearmedPlayerWeapon
#else
	#define _ALS_RearmedPlayerWeapon
#endif
#define RearmedPlayerWeapon AC_RearmedPlayerWeapon

stock AC_DeletePlayerWeapon(playerid, slot)
{
	p_Protect[playerid][prWeaponID][slot]	=	0;
    p_Protect[playerid][prWeaponAmmo][slot]	=	0;
    MyUpdatePlayerWeapon(playerid);
}
#if defined _ALS_DeletePlayerWeapon
	#undef DeletePlayerWeapon
#else
	#define _ALS_DeletePlayerWeapon
#endif
#define DeletePlayerWeapon AC_DeletePlayerWeapon