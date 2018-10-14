#if defined _inventory_model_included
  #endinput
#endif

#define _inventory_model_included

IsThing(thing)
{
	return (0 <= thing < sizeof(thingData));
}

GetThingName(thing, option = 0, bool:format = false)	
{
	new title[32] = "undefined";
	if(IsThing(thing))	
	{
		new thingType = GetThingType(thing);
		if(thingType == TH_TYPE_WEAPON)
		{
			strput(title, ReturnWeaponName(option));
		}
		else
		{
			strput(title, thingData[thing][T_TITLE]);
			if(format)
			{
				string_tolow(title);
				ChangeStringCase(title, 3);
			}
		}
	}
	return title;
}

GetThingDescrip(thing)
{
	new descrip[64];
	if(IsThing(thing))	strput(descrip, thingData[thing][T_DESCRIP]);
	return descrip;
}

GetThingCost(thing)
{
	if(IsThing(thing))	return thingData[thing][T_COST];
	return 0;
}

GetThingType(thing)	
{
	if(IsThing(thing))	return thingData[thing][T_TYPE];
	return 0;
}

GetThingMaxStack(thing)
{
	if(IsThing(thing))	return thingData[thing][T_MAX_STACK];
	return 0;
}

GetThingVisualObject(thing, option = 0)	
{
	if(IsThing(thing))	
	{
		new thingType = GetThingType(thing);
		if(thingType == TH_TYPE_WEAPON)
		{
			return GetWeaponModel(option);
		}
		else if(thingType == TH_TYPE_SKIN)
		{
			return option;
		}
		else if(thingType == TH_TYPE_ACSR)
		{
			return Acsr.GetAcsrObject(thing, option);
		}
		else
		{
			return thingData[thing][T_OBJECTID];
		}
	}
	return 0;
}

GetThingObject(thing, option = 0)
{
	if(IsThing(thing))	
	{
		new thingType = GetThingType(thing);
		if(thingType == TH_TYPE_WEAPON)
		{
			return GetWeaponModel(option);
		}
		else if(thingType == TH_TYPE_ACSR)
		{
			return Acsr.GetAcsrObject(thing, option);
		}
		else
		{
			return thingData[thing][T_OBJECTID];
		}
	}
	return 0;
}

Float:GetThingObjectHeight(thing)
{
	if(IsThing(thing))	return thingData[thing][T_OBJ_HEIGHT];
	return 0.0;
}

Float:GetThingObjectRot(thing)
{
	if(IsThing(thing))	return thingData[thing][T_OBJ_ROT];
	return 0.0;
}

GetThingUseType(thing)
{
	if(IsThing(thing))	return thingData[thing][T_USETYPE];
	return 0;
}

GetThingLegally(thing)
{
	if(IsThing(thing))	return thingData[thing][T_LEGALLY];
	return false;
}

GetThingFunc(thing)	
{
	new func[32] = "";
	if(IsThing(thing))	strput(func, thingData[thing][T_FUNC]);
	return func;
}

//////////////////////////////////////////////////////////////
stock Inv.PlayerDeleteThing(playerid, thing = -1, option = -1, count = -1)
{
	return Inv.DeleteThing(PlayerInfo[playerid][pUserID], TAB_INVENTORY, thing, option, count);
}

stock Inv.DeleteThing(source, E_INV_TABS:sourceType, thing = -1, option = -1, count = -1)
{
	new string[256];
	if(count == -1 && thing != -1 && GetThingType(thing) != TH_TYPE_IN_HAND)
	{
		mysql_format(g_SQL, string, sizeof(string), 
			"DELETE FROM `inventory`\
				WHERE `source` = '%d' AND \
					`source_type` = '%d'", source, _:sourceType);
		if(option != -1)	mysql_format(g_SQL, string, sizeof(string), "%s AND `option` = '%d'", string, option);
		if(thing != -1)		mysql_format(g_SQL, string, sizeof(string), "%s AND `thing` = '%d'", string, thing);
		mysql_query_ex(string);
		return true;
	}
	else
	{
		mysql_format(g_SQL, string, sizeof(string), 
			"SELECT `id`, `count`\
				FROM `inventory`\
				WHERE `source` = '%d' AND \
					`source_type` = '%d'", source, _:sourceType);
		if(option != -1)	mysql_format(g_SQL, string, sizeof(string), "%s AND `option` = '%d'", string, option);
		if(thing != -1)		mysql_format(g_SQL, string, sizeof(string), "%s AND `thing` = '%d'", string, thing);
	}
	new Cache:result = mysql_query(g_SQL, string);

	new playerid = -1;
	if(sourceType == TAB_INVENTORY)
	{
		foreach(Player, i)
		{
			if(PlayerInfo[i][pUserID] == source)
			{
				playerid = i;
			}
		}
	}

	for(new i = 0, thingid, tmp; i < cache_num_rows(); i++)
	{	
		cache_get_value_name_int(i, "id", 		thingid);
		cache_get_value_name_int(i, "count", 	tmp);

		if(playerid != -1 && Inv.GetPlayerThingIDInHand(playerid) == thingid)
		{
			Inv.ClearThingInHand(playerid);
		}

		if(count == -1)
		{
			Inv.DeleteItem(thingid);
		}
		else
		{
			if(tmp > count)
			{
				Inv.DeleteItem(thingid, count);
				break;
			}
			else
			{
				Inv.DeleteItem(thingid, tmp);
				count -= tmp;
			}
		}

		cache_set_active(result);
	}
	cache_delete(result);
	return true;
}

stock Inv.DeleteItem(thingid, count = -1)	
{
	new string[128];
	mysql_format(g_SQL, string, sizeof(string), "SELECT `thing`, `count` FROM `inventory` WHERE `id` = '%d'", thingid);
	new Cache:result = mysql_query(g_SQL, string);
	if(!cache_num_rows())
	{
		return false;
	}
	new _thing, _count = count;
	cache_get_value_name_int(0, "thing", _thing);
	cache_get_value_name_int(0, "count", _count);
	cache_delete(result);		
	
	if(count == -1 || _count <= count)	
	{
		if(GetThingType(_thing) == TH_TYPE_IN_HAND)
		{
			mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d'", thingid, _:TYPE_INSIDE);	//	TAB_IN_HAND
			mysql_query_ex(string);
		}
		mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `inventory` WHERE `id` = '%d'", thingid);
	}
	else
	{
		mysql_format(g_SQL, string, sizeof(string), "UPDATE `inventory` SET `count` = '%d' WHERE `id` = '%d'", _count - count, thingid);
	}  				
	mysql_query_ex(string);
	return true;	
}

//	Add thing in inventory
stock Inv.AddPlayerThing(playerid, thing, count = 1, option = 0)
{	
    if(!IsThing(thing) || count <= 0 || !IsPlayerLogged(playerid))	
    {
    	return false;
    }

    new string[256],
		Cache:result;
	new saveCount = count;

	new slotUsed = Inv.GetPlayerSlotUsed(playerid);
	new maxStack = GetThingMaxStack(thing);

	if(maxStack > 1)
	{
		mysql_format(g_SQL, string, sizeof(string), "SELECT `id`, `count`, `used` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `thing` = '%d' AND `option` = '%d'", PlayerInfo[playerid][pUserID], _:TAB_INVENTORY, thing, option);
		result = mysql_query(g_SQL, string);

		//	имитация
		new tmpCount = count;
		for(new i = 0, destID, destCount, diff; i < cache_num_rows(); i++)
		{	
			cache_get_value_name_int(i, "id", 		destID);
			cache_get_value_name_int(i, "count", 	destCount);
			if(destCount < maxStack)
			{
				diff = maxStack - destCount;
				if(tmpCount > diff)
				{
					destCount 	+= diff;
					tmpCount 	-= diff;
				}
				else
				{
					destCount 	+= tmpCount;
					tmpCount 	= 0;
				}
			}
		}

		if(tmpCount)
		{
			new needSlot = floatround(float(tmpCount) / float(maxStack), floatround_ceil);
			if(slotUsed + needSlot > 12)
			{
				ShowPlayerHint(playerid, "Инвентарь переполнен");
				return false;
			}
		}

		for(new i = 0, destID, destCount, destUsed, diff; i < cache_num_rows(); i++)
		{	
			cache_get_value_name_int(i, "id", 		destID);
			cache_get_value_name_int(i, "count", 	destCount);
			cache_get_value_name_int(i, "used", 	destUsed);
			if(destCount < maxStack)
			{
				diff = maxStack - destCount;
				if(count > diff)
				{
					destCount 	+= diff;
					count 		-= diff;
				}
				else
				{
					destCount 	+= count;
					count 		= 0;
				}
				if(GetThingType(thing) == TH_TYPE_WEAPON && destUsed)
				{
					Inv.UpdateWeaponAmmo(playerid, destID, destCount);
				}
				mysql_format(g_SQL, string, sizeof(string), "UPDATE `inventory` SET `count` = '%d' WHERE `id` = '%d'", destCount, destID);
				mysql_query_ex(string);
			}
		}
		cache_delete(result);
	}
	else
	{
		new needSlot = floatround(float(count) / float(maxStack), floatround_ceil);
		if(slotUsed + needSlot > 12)
		{
			ShowPlayerHint(playerid, "Инвентарь переполнен");
			return false;
		}
	}
	
	while(count > 0)
	{
		//	Поиск свободного слота
	    new minslot = Inv.FindPlayerFreeSlot(playerid);
		if(minslot == INVALID_DATA)
		{
			ShowPlayerHint(playerid, "Инвентарь переполнен");
			break;
		}

		new tmp = (count > maxStack) ? maxStack : count;
		mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `inventory` SET `source` = '%d', `source_type` = '%d', `slot` = '%d', `thing` = '%d', `option` = '%d', `count` = '%d'", PlayerInfo[playerid][pUserID], _:TAB_INVENTORY, minslot, thing, option, tmp);
		mysql_query_ex(string);
		count -= tmp;
	}

	PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
	format(string, sizeof(string), "~w~В инвентарь добавлено: ~n~~y~%s (%d шт.)~w~", GetThingName(thing, option), saveCount);
	ShowPlayerHint(playerid, string);
	return true;
}

stock Inv.AddThing(E_INV_TABS:source_type, source, thing, count = 1, option = 0, result[], size = sizeof(result))
{
	if(!IsThing(thing) || count <= 0)	
    {
    	return false;
    }

    new string[256],
		Cache:_result;
	//new saveCount = count;

	//new slotUsed = Inv.GetPlayerSlotUsed(playerid);
	new maxStack = GetThingMaxStack(thing);

	/*if(maxStack > 1 && tab != TYPE_THROW)
	{
		mysql_format(g_SQL, string, sizeof(string), "SELECT `id`, `count`, `used` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `thing` = '%d' AND `option` = '%d'", sourceID, _:tab, thing, option);
		result = mysql_query(g_SQL, string);

		//	имитация
		new tmpCount = count;
		for(new i = 0, destID, destCount, diff; i < cache_num_rows(); i++)
		{	
			cache_get_value_name_int(i, "id", 		destID);
			cache_get_value_name_int(i, "count", 	destCount);
			if(destCount < maxStack)
			{
				diff = maxStack - destCount;
				if(tmpCount > diff)
				{
					destCount 	+= diff;
					tmpCount 	-= diff;
				}
				else
				{
					destCount 	+= tmpCount;
					tmpCount 	= 0;
				}
			}
		}

		if(tmpCount)
		{
			new needSlot = floatround(float(tmpCount) / float(maxStack), floatround_ceil);
			if(slotUsed + needSlot > 12)
			{
				//ShowPlayerHint(playerid, "Инвентарь переполнен");
				return false;
			}
		}

		for(new i = 0, destID, destCount, destUsed, diff; i < cache_num_rows(); i++)
		{	
			cache_get_value_name_int(i, "id", 		destID);
			cache_get_value_name_int(i, "count", 	destCount);
			cache_get_value_name_int(i, "used", 	destUsed);
			if(destCount < maxStack)
			{
				diff = maxStack - destCount;
				if(count > diff)
				{
					destCount 	+= diff;
					count 		-= diff;
				}
				else
				{
					destCount 	+= count;
					count 		= 0;
				}
				if(GetThingType(thing) == TH_TYPE_WEAPON && destUsed)
				{
					Inv.UpdateWeaponAmmo(playerid, destID, destCount);
				}
				mysql_format(g_SQL, string, sizeof(string), "UPDATE `inventory` SET `count` = '%d' WHERE `id` = '%d'", destCount, destID);
				mysql_query_ex(string);
			}
		}
		cache_delete(result);
	}
	else
	{
		new needSlot = floatround(float(count) / float(maxStack), floatround_ceil);
		if(slotUsed + needSlot > 12)
		{
			//ShowPlayerHint(playerid, "Инвентарь переполнен");
			return false;
		}
	}*/
	
	new i = 0;
	while(count > 0)
	{
		//	Поиск свободного слота
	    new minslot = Inv.FindFreeSlot(source, source_type);
		if(minslot == INVALID_DATA)
		{
			//ShowPlayerHint(playerid, "Инвентарь переполнен");
			break;
		}

		new tmp = (count > maxStack) ? maxStack : count;
		mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `inventory` SET `source` = '%d', `source_type` = '%d', `slot` = '%d', `thing` = '%d', `option` = '%d', `count` = '%d'", source, _:source_type, minslot, thing, option, tmp);
		_result = mysql_query(g_SQL, string);
		if(i < size)	result[i++] = cache_insert_id();
		cache_delete(_result);

		count -= tmp;
	}

	return i > 0;
}

Inv.ThrowThing(thingid, Float:x, Float:y, Float:z)
{
	new string[256];
	format(string, sizeof(string), "UPDATE `inventory` SET `source` = '0', `source_type` = '%d', `slot` = '0', `attach_x` = '%f', `attach_y` = '%f', `attach_z` = '%f' WHERE `id` = '%d'", _:TYPE_THROW, x, y, z, thingid);
	mysql_query_ex(string);

	return true;
}

Inv.RaiseThing(playerid, item, count)
{
	new data[7];
	Streamer_GetArrayData(STREAMER_TYPE_OBJECT, item, E_STREAMER_EXTRA_ID, data);

	if(data[5] == 0 || data[3] == 0)
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Кто-то уже поднял этот предмет.");
		return false;
	}

	if(count < 0 || data[5] < count)
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "На земле нет такого количества этого предмета.");
		return false;
	}

	new string[128];
	data[5] -= count;
	if(GetThingType(data[3]) == TH_TYPE_IN_HAND)
	{
		if(!Inv.GiveThingInHand(playerid, data[1]))
		{
			return false;
		}

		/*new slotUsed;
		mysql_format(g_SQL, string, sizeof(string), "SELECT `count` FROM `inventory` WHERE `id` = '%d'", data[1]);
		mysql_query(g_SQL, string);
		cache_get_value_name_int(0, "count", slotUsed);

		if(Inv.GetPlayerSlotUsed(playerid) + slotUsed > 12)	//	ИЗМЕНИТЬ
		{
			ShowPlayerHint(playerid, "Инвентарь переполнен");
			return false;
		}
	
		new minslot = Inv.FindPlayerFreeSlot(playerid);
		if(minslot == INVALID_DATA)
		{
			ShowPlayerHint(playerid, "Инвентарь переполнен");
			return false;
		}
		mysql_format(g_SQL, string, sizeof(string), "UPDATE `inventory` SET `source` = '%d', `source_type` = '%d', `slot` = '%d' WHERE `id` = '%d'", PlayerInfo[playerid][pUserID], _:TAB_INVENTORY, minslot, data[1]);
		mysql_query_ex(string);

		format(string, sizeof(string), "~w~В инвентарь добавлено: ~n~~y~%s", GetThingName(data[3], data[4]));
		ShowPlayerHint(playerid, string);*/
	}
	else
	{
		if(!Inv.AddPlayerThing(playerid, data[3], count, data[4]))
		{
			return false;
		}
		mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `inventory` WHERE `id` = '%d'", data[1]);
		mysql_query_ex(string);
	}

	if(data[5] <= 0)
	{
		DestroyDynamic3DTextLabel(Text3D:data[6]);
		DestroyDynamicObject(item);
	}
	else
	{
		Streamer_SetArrayData(STREAMER_TYPE_OBJECT, item, E_STREAMER_EXTRA_ID, data);
	}

	format(string, sizeof(string), "поднял с земли %s.", GetThingName(data[3], data[4], true));
	PlayerAction(playerid, string);

	PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
	MyApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 0, 1, 1, 0, 0);
	return true;
}

stock Inv.SplitItem(thingid)
{
	new string[256];
	mysql_format(g_SQL, string, sizeof(string), "SELECT `source`, `source_type`, `thing`, `option`, `used`, `count` FROM `inventory` WHERE `id` = '%d'", thingid);
	mysql_query(g_SQL, string);
	if(!cache_num_rows())
	{
		return false;
	}

	new source, source_type, thing, option, used, count;
	cache_get_value_name_int(0, "source",		source);
	cache_get_value_name_int(0, "source_type",	source_type);
	cache_get_value_name_int(0, "thing",		thing);
	cache_get_value_name_int(0, "option",		option);
	cache_get_value_name_int(0, "used",			used);
	cache_get_value_name_int(0, "count",		count);

	if(GetThingMaxStack(thing) == 1 || count < 2)
	{
		return false;
	}
	if(used)
	{
		return false;
	}

	new slotUsed = Inv.GetSlotUsed(source, E_INV_TABS:source_type);
	if(slotUsed >= 12)	// ИЗМЕНИТЬ
	{
		return false;
	}
	
	//	Поиск свободного слота
    new minslot = Inv.FindFreeSlot(source, E_INV_TABS:source_type);
	if(minslot == INVALID_DATA)
	{
		return false;
	}
	count /= 2;
	mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `inventory` SET `source` = '%d', `source_type` = '%d', `slot` = '%d', `thing` = '%d', `option` = '%d', `count` = '%d'", source, source_type, minslot, thing, option, count);
	mysql_query_ex(string);

	Inv.DeleteItem(thingid, count);
	return true;
}

stock Inv.GetThing(playerid, thing, option = 0)
{
    if(IsPlayerLogged(playerid) == 0)	return false;
	new string[256], count = 0;
	mysql_format(g_SQL, string, sizeof(string), "SELECT `count` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `thing` = '%d' AND `option` = '%d'", PlayerInfo[playerid][pUserID], _:TAB_INVENTORY, thing, option);
	new Cache:result = mysql_query(g_SQL, string);
	for(new i = 0, tmp; i < cache_num_rows(); i++)
	{	
		cache_get_value_name_int(i, "count", 	tmp);
		count += tmp;
	}
	cache_delete(result);
	return count;
}

stock Inv.GetItem(thingid)	
{
	new string[128], count;
	mysql_format(g_SQL, string, sizeof(string), "SELECT `count` FROM `inventory` WHERE `id` = '%d'", thingid);
	new Cache:result = mysql_query(g_SQL, stmp);
	if(cache_num_rows())	cache_get_value_name_int(0, "count", count);
	cache_delete(result);
	return count;	
}

stock ItemStockPlayer(playerid, thing, option = INVALID_DATA)	
{
	new stmp[128], id = 0;
	format(stmp, sizeof(stmp), "SELECT `id` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `thing` = '%d'", PlayerInfo[playerid][pUserID], _:TAB_INVENTORY, thing);
	if(option != INVALID_DATA)	format(stmp, sizeof stmp, "%s AND `option` = '%d'", stmp, option);
	new Cache:result = mysql_query(g_SQL, stmp);
	if(cache_num_rows() > 0)	cache_get_value_name_int(0, "id", id);
	cache_delete(result);
	return id;	
}

/*stock Inv.GetItemSlot(playerid, thingid)
{
	new stmp[128], slot = INVALID_DATA;
	format(stmp, sizeof(stmp), "SELECT `slot` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' AND `id` = '%d'", PlayerInfo[playerid][pUserID], TAB_INVENTORY, thingid);
	new Cache:result = mysql_query(g_SQL, stmp);
	if(cache_num_rows() > 0)	cache_get_value_name_int(0, "slot", slot);
	cache_delete(result);
	return slot;	
}*/

stock Inv.SetItemFlag(thingid, flag)
{
	new string[128];
	format(string, sizeof(string), "UPDATE `inventory` SET `used` = '%d' WHERE `id` = '%d'", flag, thingid);
	mysql_query_ex(string);
	return true;
}

stock Inv.IsItemUsed(thingid)
{
	new string[128], used;
	format(string, sizeof(string), "SELECT `used` FROM `inventory` WHERE `id` = '%d'", thingid);
	new Cache:result = mysql_query(g_SQL, string);
	cache_get_value_name_int(0, "used", used);
	cache_delete(result);
	return used;
}

//////////	Private 	//////////
static Inv.FindPlayerFreeSlot(playerid)
{
	return Inv.FindFreeSlot(PlayerInfo[playerid][pUserID], TAB_INVENTORY);
}

static Inv.FindFreeSlot(source, E_INV_TABS:source_type)
{
	new minslot = INVALID_DATA;
	if(source_type == TYPE_THROW)
	{
		minslot = 0;
	}
	else
	{
		new string[128];
	 	new bool:slots[MAX_THINGS];
	    mysql_format(g_SQL, string, sizeof(string), "SELECT `slot` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d' LIMIT %d", source, _:source_type, MAX_THINGS);
		new Cache:result = mysql_query(g_SQL, string);
		for(new i = 0, slot; i < cache_num_rows(); i++) 
		{
			cache_get_value_name_int(i, "slot", slot);
			slots[slot] = true;
		}
		cache_delete(result);

		for(new i = 0; i < MAX_THINGS; i++)
		{
			if(slots[i] == false)	
			{
				minslot = i;
				break;
			}
		}
	}
	return minslot;
}

static Inv.GetPlayerSlotUsed(playerid)
{
	return Inv.GetSlotUsed(PlayerInfo[playerid][pUserID], TAB_INVENTORY);
}

static Inv.GetSlotUsed(source, E_INV_TABS:source_type)
{
	new string[256];
	mysql_format(g_SQL, string, sizeof(string), "SELECT `thing`, `count` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d'", source, _:source_type);
	new Cache:result = mysql_query(g_SQL, string);
	new slotUsed, thing, count;
	for(new i = 0; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i, "thing", thing);
		if(GetThingType(thing) == TH_TYPE_IN_HAND)
		{
			cache_get_value_name_int(i, "count", count);
			slotUsed += count;
		}
		else
		{
			slotUsed++;
		}
	}
	cache_delete(result);
	return slotUsed;
}