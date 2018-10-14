#if defined _inventory_throw_included
	#endinput
#endif

#define _inventory_throw_included

stock Inv.CreateThrowThing(thing, option, thingid, count, Float:x, Float:y, Float:z)
{
	new string[48];
	new objectid = CreateDynamicObject(GetThingObject(thing, option), x, y, z, GetThingObjectRot(thing), 0.0, 0.0);

	new data[7];
	data[0]	= OBJECT_TYPE_THROW;
	data[1] = thingid;
	data[2] = GetThingType(thing);
	data[3] = thing;
	data[4] = option;
	data[5] = count;
	format(string, sizeof(string), "%s\n" ACTION_TEXT, GetThingName(thing, option));
	data[6] = _:CreateDynamic3DTextLabel(string, COLOR_ACTION, x, y, z + 0.2, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0);
	Streamer_SetArrayData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, data);
	return true;
}

stock Inv.LoadThrowThings()
{
	new stmp[128];
	mysql_format(g_SQL, stmp, sizeof(stmp), "SELECT `id`, `thing`, `option`, `count`, `attach_x`, `attach_y`, `attach_z` FROM `inventory` WHERE `source_type` = '%d'", _:TYPE_THROW);
	new Cache:result = mysql_query(g_SQL, stmp);
	for(new i = 0, thingid, thing, option, count, Float:pos[3]; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i,		"id",		thingid);
		cache_get_value_name_int(i, 	"thing",	thing);
		cache_get_value_name_int(i,		"option",	option);
		cache_get_value_name_int(i,		"count",	count);
		cache_get_value_name_float(i,	"attach_x",	pos[0]);
		cache_get_value_name_float(i, 	"attach_y",	pos[1]);
		cache_get_value_name_float(i, 	"attach_z",	pos[2]);
		Inv.CreateThrowThing(thing, option, thingid, count, Arr3<pos>);
	}
	cache_delete(result);
	return true;
}

stock NearThings(playerid)
{
	for(new j = 0; j < 32; j++)
	{
    	playerNearThings[playerid][j] = INVALID_DATA;
	}

	new Float:pos[3], items[32] = { INVALID_STREAMER_ID, ... };
	MyGetPlayerPos(playerid, Arr3<pos>);
	Streamer_GetNearbyItems(Arr3<pos>, STREAMER_TYPE_OBJECT, items, sizeof(items), 1.5);

	new count;
	for(new i, data[6]; i < sizeof(items); i++) 
	{
		if(items[i] == INVALID_STREAMER_ID)	break;
		Streamer_GetArrayData(STREAMER_TYPE_OBJECT, items[i], E_STREAMER_EXTRA_ID, data);
		if(data[0] == OBJECT_TYPE_THROW) 
		{
			playerNearThings[playerid][count++] = items[i];
		}
	}
    return (count > 0); 
}

COMMAND:throw(playerid, params[])
{
	if(NearThings(playerid))
	{
		Dialog_Show(playerid, Dialog:Inv.Throw);
	}
	else
	{
		if(strval(params) != 999){
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Поблизости нет вещей.");
		}
		return false;
	}
	return true;
}