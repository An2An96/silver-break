#if defined _inventory_weapon_included
	#endinput
#endif

#define _inventory_weapon_included

new Inv.weaponIDInInventory[MAX_PLAYERS][13];

//	It will give player weapon from inventory
UseItem:Weapon(playerid, thingid, weaponid, ammo)
{
	new slot = GetWeaponSlot(weaponid);
	if(slot != 255)
	{
		if(Inv.weaponIDInInventory[playerid][slot])
		{
			Inv.SetItemFlag(Inv.weaponIDInInventory[playerid][slot], false);
		}
	
		if(Inv.weaponIDInInventory[playerid][slot] != thingid)
		{
			Inv.weaponIDInInventory[playerid][slot] = thingid;
			MySetPlayerWeapon(playerid, weaponid, ammo);
			Inv.SetItemFlag(thingid, true);
		}
		else
		{
			Inv.weaponIDInInventory[playerid][slot] = 0;
			MyClearPlayerWeaponSlot(playerid, slot);
		}
		return true;
	}
	return false;
}

stock Inv.UpdateWeaponAmmo(playerid, thingid, ammo)
{
	for(new i = 0; i < 13; i++)
	{
		if(Inv.weaponIDInInventory[playerid][i] == thingid)
		{
			MySetPlayerWeapon(playerid, MyGetPlayerWeaponID(playerid, i), ammo);
			//MyGivePlayerWeapon(playerid, MyGetPlayerWeaponID(playerid, i), ammo);
			return true;
		}
	}
	return false;
}

//	Give the player weapons in inventory
stock Inv.GivePlayerWeapon(playerid, weaponid, ammo)
{
	Inv.AddPlayerThing(playerid, THING_WEAPON, ammo, weaponid);
	return true;
}

//	Get and equip used player weapons
stock Inv.LoadPlayerUsedWeapon(playerid)
{
	new stmp[128];
	mysql_format(g_SQL, stmp, sizeof(stmp), "SELECT `id`, `thing`, `option`, `count` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `used` = '1'", PlayerInfo[playerid][pUserID], _:TAB_INVENTORY);
	new Cache:result = mysql_query(g_SQL, stmp);
	for(new i = 0, id, thing, option, count; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i, "id", id);
		cache_get_value_name_int(i, "thing", thing);
		cache_get_value_name_int(i, "option", option);
		cache_get_value_name_int(i, "count", count);

		if(GetThingType(thing) == TH_TYPE_WEAPON)
		{
			UseItem_Weapon(playerid, id, option, count);
			//PlayerUseItem(playerid, id);
		}
	}
	cache_delete(result);
}

//	Save weapon ammo in database
stock Inv.SavePlayerWeapon(playerid)
{
	if(!gPlayerLogged[playerid])	return false;

	new stmp[128];
	for(new i = 0, ammo; i < 13; i++)
	{
		if(Inv.weaponIDInInventory[playerid][i])
		{
			ammo = MyGetPlayerWeaponAmmo(playerid, i);
			if(ammo < 1)
			{
				Inv.DeleteItem(Inv.weaponIDInInventory[playerid][i]);
			}
			else
			{
				format(stmp, sizeof(stmp), "UPDATE `inventory` SET `count` = '%d' WHERE `id` = '%d'", MyGetPlayerWeaponAmmo(playerid, i), Inv.weaponIDInInventory[playerid][i]);
		    	mysql_query(g_SQL, stmp);
			}
		}
	}
	return true;
}

//	Clear player data
Inv.ClearWeaponData(playerid)
{
	for (new i = 0; i < 13; i++)
	{
		Inv.weaponIDInInventory[playerid][i] = 0;
	}
}