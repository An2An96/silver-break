#if defined _inventory_in_hands_included
	#endinput
#endif

#define _inventory_in_hands_included

static 
	pThingInHand[MAX_PLAYERS],
	pThingInHandObject[MAX_PLAYERS];

stock Inv.LoadPlayrerThingInHand(playerid)
{
	new string[256];
	mysql_format(g_SQL, string, sizeof(string), "SELECT `id`, `thing` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d'", PlayerInfo[playerid][pUserID], _:TYPE_IN_HAND);
	new Cache:result = mysql_query(g_SQL, string);
	for(new i = 0, thingid, thing; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i, "id", thingid);
		cache_get_value_name_int(i, "thing", thing);
		Inv.SetThingInHand(playerid, thingid, thing);
	}
	cache_delete(result);
	return true;
}

stock Inv.GiveThingInHand(playerid, thingid)
{
	if(pThingInHand[playerid] == thingid)
	{
		return false;
	}
	if(pThingInHand[playerid] != 0)
    {
    	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ваши руки уже заняты другим предметом.");
        return false;
    }
  
  	new string[256];
    mysql_format(g_SQL, string, sizeof(string), "SELECT `thing` FROM `inventory` WHERE `id` = '%d'", thingid);
	new Cache:result = mysql_query(g_SQL, string);
	if(!cache_num_rows())
	{
		cache_delete(result);
		return false;
	}

	new thing;
	cache_get_value_name_int(0, "thing", thing);
	cache_delete(result);

	if(Inv.SetThingInHand(playerid, thingid, thing))
	{
		format(string, sizeof(string), "UPDATE `inventory` SET `source` = '%d', `source_type` = '%d' WHERE `id` = '%d'", PlayerInfo[playerid][pUserID], _:TYPE_IN_HAND, thingid);
		mysql_query_ex(string);
		return true;
	}
    return false;
}

stock Inv.UpdateThingInHand(playerid)
{
	Inv.SetThingInHand(playerid, pThingInHand[playerid], pThingInHandObject[playerid]);
	return true;
}

stock Inv.GetPlayerThingIDInHand(playerid)
{
	return pThingInHand[playerid];
}

stock Inv.ClearThingInHand(playerid)
{
	if(pThingInHand[playerid])
	{
		MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	    RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND);
	    RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1);
	    //IFace.Inv_DeleteTab(playerid, TYPE_INSIDE, pThingInHand[playerid]);
	    pThingInHand[playerid] = 0;
	    pThingInHandObject[playerid] = 0;
	}
	return true;
}

stock Inv.ThrowThingOutHand(playerid)
{
	if(!pThingInHand[playerid]) {
		return false;
	}

	new thingid	= pThingInHand[playerid],
		thing	= pThingInHandObject[playerid];

	new string[256];
	mysql_format(g_SQL, string, sizeof(string), "SELECT `thing`, `option`, `used`, `count` FROM `inventory` WHERE `id` = '%d'", pThingInHand[playerid]);
	new Cache:result = mysql_query(g_SQL, string);
	if(!cache_num_rows())
	{
		cache_delete(result);
		return false;
	}

	new option, count;	
	cache_get_value_name_int(0, "option",		option);
	cache_get_value_name_int(0, "count",		count);
	cache_delete(result);

	if(GetThingLegally(thing) == 0)
	{
		foreach(Cop, c)
		{
			if(GetDistanceBetweenPlayers(playerid, c) < 30.0)
			{
				CrimePlayer(playerid, CRIME_THINGS);
				break;
			}
		}
	}

	new title[32], format_title[32];
	strput(title, GetThingName(thing, option));
	strput(format_title, GetThingName(thing, option, true));

	new Float:pos[3];
	GetPlayerPos(playerid, Arr3<pos>);
	pos[2] -= 1.0 - GetThingObjectHeight(thing);

	Inv.CreateThrowThing(thing, option, thingid, count, Arr3<pos>);
	Inv.ThrowThing(thingid, Arr3<pos>);

	format(string, sizeof(string), "выбрасывает %s на землю.", format_title);
	PlayerAction(playerid, string);
	MyApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 0, 1, 1, 0, 0);

	Inv.ClearThingInHand(playerid);
	return true;
}

static Inv.SetThingInHand(playerid, thingid, thing)
{
	new result;
	switch(thing)
	{
		case THING_BOX:
		{
			result = CarryUPEx(playerid, GetThingObject(thing), 0.311, 0.579, 0.0, 0.0, 90.0, 0.0);
		}
		case THING_BOX2:
		{
			result = CarryUPEx(playerid, GetThingObject(thing), 0.062, 0.367, 0.0, 0.0, 90.0, 0.0);
		}
		case THING_SUITCASE:
		{
			result = SetPlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1, GetThingObject(thing), 6, 0.29, 0.077, 0.044, 0.0, -98.899, -9.399);
        }
		case THING_SUITCASE2:
		{
			result = SetPlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1, GetThingObject(thing), 6, 0.071, 0.015, 0.022, 0.0, -99.0, -4.4, 1.0, 0.737, 1.0);
		}
		case THING_BAG:
		{
			result = SetPlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1, GetThingObject(thing), 1, 0.074, -0.132, 0.023, -90.199, 0.0, -63.899, 0.788, 1.182, 1.0);
		}
		case THING_BAG2:
		{
			result = SetPlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1, GetThingObject(thing), 1, 0.095, -0.033, -0.005, 0.0, 90.0, 0.0, 1.0, 1.0, 1.0);
		}
		case THING_TRASH:
		{
			result = CarryUPEx(playerid, GetThingObject(thing), 0.4, 0.585, 0.0, 0.0, 90.0, 0.0);
		}
	}

	if(result)
    {
        //IFace.Inv_AddTab(playerid, "BOX", TYPE_INSIDE, thingid, 6);
        pThingInHand[playerid] = thingid;
        pThingInHandObject[playerid] = thing;
        return true;
    }
    return false;
}

CMD:testbox(playerid, params[])
{
	new Float:pos[3];
	GetPlayerPos(playerid, Arr3<pos>);

	new result[1];
	Inv.AddThing(TYPE_THROW, 0, THING_BOX2, 1, 0, result);
	Inv.ThrowThing(result[0], Arr3<pos>);
	Inv.CreateThrowThing(THING_BOX2, 0, result[0], 1, Arr3<pos>);

	return true;
}

CMD:testhand(playerid, params[])
{
	if(!pThingInHand[playerid])
	{
		return false;
	}

	new thingid = pThingInHand[playerid];

	new title[32], format_title[32];
	new string[256];

	mysql_format(g_SQL, string, sizeof(string), "SELECT `thing`, `option` FROM `inventory` WHERE `id` = '%d'", thingid);
	new Cache:result = mysql_query(g_SQL, string);
	if(!cache_num_rows())
	{
		cache_delete(result);
		return false;
	}

	new thing, option;
	cache_get_value_name_int(0, "thing",		thing);
	cache_get_value_name_int(0, "option",		option);
	cache_delete(result);

	new inputCount 	= 1;

	strput(title, GetThingName(thing, option));
	strput(format_title, GetThingName(thing, option, true));

	new Float:pos[3];
	GetPlayerPos(playerid, Arr3<pos>);
	pos[2] -= 1.0 - GetThingObjectHeight(thing);

	Inv.CreateThrowThing(thing, option, thingid, inputCount, Arr3<pos>);
	Inv.ThrowThing(thingid, Arr3<pos>);

	format(string, sizeof(string), "выбрасывает %s на землю.", format_title);
	PlayerAction(playerid, string);
	MyApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 0, 1, 1, 0, 0);

	MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND);
    RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1);
    IFace.Inv_DeleteTab(playerid, TYPE_INSIDE, thingid);
    pThingInHand[playerid] = 0;
	return true;
}

CMD:eao(playerid, params[])
{
	EditAttachedObject(playerid, ATTACH_SLOT_IN_HAND);
	return true;
}

/*stock Inv.SetThingInHand(playerid, thing)
{
	new result;
	switch(thing)
	{
		case THING_BOX:
		{
			result = CarryUPEx(playerid, GetThingObject(thing), 0.311, 0.579, 0.0, 0.0, 90.0, 0.0);
		}
		case THING_BOX2:
		{
			result = CarryUPEx(playerid, GetThingObject(thing), 0.062, 0.367, 0.0, 0.0, 90.0, 0.0);
		}
		case THING_SUITCASE:
		{
			result = SetPlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1, GetThingObject(thing), 6, 0.29, 0.077, 0.044, 0.0, -98.899, -9.399);
        }
		case THING_SUITCASE2:
		{
			result = SetPlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1, GetThingObject(thing), 6, 0.071, 0.015, 0.022, 0.0, -99.0, -4.4, 1.0, 0.737, 1.0);
		}
		case THING_BAG:
		{
			result = SetPlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1, GetThingObject(thing), 1, 0.074, -0.132, 0.023, -90.199, 0.0, -63.899, 0.788, 1.182, 1.0);
		}
		case THING_BAG2:
		{
			result = SetPlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1, GetThingObject(thing), 1, 0.095, -0.033, -0.005, 0.0, 90.0, 0.0, 1.0, 1.0, 1.0);
		}
		case THING_TRASH:
		{
			result = CarryUPEx(playerid, GetThingObject(thing), 0.4, 0.585, 0.0, 0.0, 90.0, 0.0);
		}
	}
	return result;
}*/