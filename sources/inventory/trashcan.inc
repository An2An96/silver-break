#if defined _inventory_trashcan_included
	#endinput
#endif

#define _inventory_trashcan_included






enum E_TRASHCAN
{
	tModelId,
	tSlotCount,
	tTitle[24]
}

new const TrashcanTypes[][E_TRASHCAN] = {
	{ 1235, 6,	"Мусорная урна" },
	{ 1347, 6,	"Мусорная урна" },
	{ 1362, 6,	"Мусорная урна" },
	{ 1442, 6,	"Мусорная урна" },
	{ 1300, 6,	"Мусорная урна" },
	{ 3035, 18,	"Мусорный бак" },
	{ 2770, 6,	"Мусорная урна" },
	{ 1329, 6,	"Мусорная урна" },
	{ 1333, 18,	"Мусорный бак" },
	{ 1334, 18,	"Мусорный бак" },
	{ 1337, 12,	"Мусорный бак" },
	{ 1339, 12,	"Мусорный бак" },
	{ 1332, 18,	"Мусорный бак" },
	{ 1330, 6,	"Мусорная урна" },
	{ 1372, 18,	"Мусорный бак" },
	{ 1227, 24,	"Мусорный бак" },
	{ 1331, 18,	"Мусорный бак" },
	{ 1343, 12,	"Мусорный бак" },
	{ 1359, 6,	"Мусорная урна" },
	{ 11706, 12,"Мусорный бак" }
};

stock Inv.LoadTrashcan()
{
	new string[48];
	new id, type, bool:createObject, Float:pos[6], data[4];
	new Cache:result = mysql_query(g_SQL, "SELECT * FROM `trashcans`");
	for(new i = 0; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i, "id",				id);
		cache_get_value_name_int(i, "type",				type);
		cache_get_value_name_int(i, "create_object",	createObject);
		cache_get_value_name_float(i, "x",				pos[0]);
		cache_get_value_name_float(i, "y",				pos[1]);
		cache_get_value_name_float(i, "z",				pos[2]);
		cache_get_value_name_float(i, "rx",				pos[3]);
		cache_get_value_name_float(i, "ry",				pos[4]);
		cache_get_value_name_float(i, "rz",				pos[5]);

		data[0]	= OBJECT_TYPE_TRASHCAN;
		data[1] = id;
		data[2] = type;
		data[3] = createObject ? CreateDynamicObject(TrashcanTypes[type][tModelId], Arr6<pos>) : INVALID_STREAMER_ID;
		format(string, sizeof(string), "%s\n" ACTION_TEXT, TrashcanTypes[type][tTitle]);
		Streamer_SetArrayData(
			STREAMER_TYPE_3D_TEXT_LABEL,
			CreateDynamic3DTextLabel(string, COLOR_ACTION, pos[0], pos[1], pos[2] + 0.5, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0),
			E_STREAMER_EXTRA_ID, 
			data);
	}
	cache_delete(result);
	return true;
}

stock Inv.GetPlayerNearTrashcan(playerid, &trashcanType = 0)
{
	new Float:pos[3], items[32] = { INVALID_STREAMER_ID, ... };
	MyGetPlayerPos(playerid, Arr3<pos>);
	Streamer_GetNearbyItems(Arr3<pos>, STREAMER_TYPE_3D_TEXT_LABEL, items, sizeof(items), 1.5);

	for(new i, data[4]; i < sizeof(items); i++) 
	{
		if(items[i] == INVALID_STREAMER_ID)	break;
		Streamer_GetArrayData(STREAMER_TYPE_3D_TEXT_LABEL, items[i], E_STREAMER_EXTRA_ID, data);
		if(data[0] == OBJECT_TYPE_TRASHCAN)	
		{
			trashcanType = data[2];
			return data[1];
		}
	}
    return INVALID_DATA; 
}

stock Inv.GetTrashcanSlotCount(type)
{
	return TrashcanTypes[type][tSlotCount];
}