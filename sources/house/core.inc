#include "house/header"

RestoreDefaultHouses()
{	// X, Y, Z, A, Class, Zone (0 LS, 1 SF, 2 LV)
	new File:file = fopen(GM_FOLDER"houses.cfg", io_read);
	if(file)
	{
		new string[164];
		while(fread(file, string))
		{
		    if(MaxHouses >= MAX_HOUSES) break;
			sscanf(string, "p<,>ffffi",	HouseInfo[MaxHouses][hX],
										HouseInfo[MaxHouses][hY],
										HouseInfo[MaxHouses][hZ],
										HouseInfo[MaxHouses][hA],
										HouseInfo[MaxHouses][hClass]);
			format(string, sizeof(string), "INSERT INTO `houses` (`X`, `Y`, `Z`, `A`, `class`, `price`) VALUES('%f', '%f', '%f', '%f', '%d', '%d')",
				HouseInfo[MaxHouses][hX],
				HouseInfo[MaxHouses][hY],
				HouseInfo[MaxHouses][hZ],
				HouseInfo[MaxHouses][hA],
				HouseInfo[MaxHouses][hClass],
				3250 + (6 - HouseInfo[MaxHouses][hClass]) * 18750);
			mysql_query_ex(string);
		}
		fclose(file);
	}
	return 1;
}

GetPlayerHouseID(playerid)
{
    new h = FoundHouse(GetPlayerVirtualWorld(playerid) - VW_HOUSE);
    if(h == -1) return -1;
    new Class = HouseInfo[h][hClass] - 1;
	new Int = HouseInfo[h][hInt] - 1;
    if(IsPlayerInRangeOfPoint(playerid, 50.0, Arr3<InterCoords[Class][Int]>) == 0)
    {
        return -1;
    }
	return h;
}

SaveHouse(houseid = -1)
{
	if(houseid < 0)
	{
		for(houseid = 0; houseid < MaxHouses; houseid++)
		{
			SaveHouse(houseid);
		}
	}
	else
	{
		if(houseid < sizeof(HouseInfo) && HouseInfo[houseid][hID] > 0)
		{
			new query[256];
			format(query, sizeof(query), "UPDATE `houses` SET \
									`ownerid` = '%d',\
									`payment_days` = '%d',\
									`X` = '%0.2f',\
									`Y` = '%0.2f',\
									`Z` = '%0.2f',\
									`A` = '%0.2f',\
									`class` = '%d',\
									`int` = '%d',\
									`donate` = '%d',\
									`price` = '%d',\
									`lock` = '%d',\
									`extra_slots` = '%d',\
									`rent` = '%d'\
									WHERE `id` = '%d'",
									HouseInfo[houseid][hOwnerID], HouseInfo[houseid][hPaymentDays],
									HouseInfo[houseid][hX],		HouseInfo[houseid][hY],
									HouseInfo[houseid][hZ],		HouseInfo[houseid][hA],
									HouseInfo[houseid][hClass],	HouseInfo[houseid][hInt],
									HouseInfo[houseid][hDonate], HouseInfo[houseid][hPrice],
									HouseInfo[houseid][hLock],  HouseInfo[houseid][hExtraSlots],
									HouseInfo[houseid][hRentPrice],
									HouseInfo[houseid][hID]);
			mysql_query_ex(query);
		}
	}
	return true;
}

LoadHouses()
{
	//	Load data
	new Cache:result = mysql_query(g_SQL, "SELECT * FROM `houses`");
	if(!cache_num_rows())
	{
	    cache_delete(result);
	    return -1;
	}
	new string[128], houses;
    for(new r = 0; r < cache_num_rows(); r++)
    {
        if(MaxHouses >= MAX_HOUSES)
        {
			printf( "  WARNING! Constant MAX_HOUSES(%d) is smaller then houses in database(%d)!", MAX_HOUSES, cache_num_rows());
            break;
        }
        new field = 0;
        cache_get_value_index_int(r, field++, HouseInfo[MaxHouses][hID]);
		cache_get_value_index_int(r, field++, HouseInfo[MaxHouses][hOwnerID]);
		cache_get_value_index_int(r, field++, HouseInfo[MaxHouses][hPaymentDays]);
		cache_get_value_index_float(r, field++, HouseInfo[MaxHouses][hX]);
		cache_get_value_index_float(r, field++, HouseInfo[MaxHouses][hY]);
		cache_get_value_index_float(r, field++, HouseInfo[MaxHouses][hZ]);
		cache_get_value_index_float(r, field++, HouseInfo[MaxHouses][hA]);
		cache_get_value_index_int(r, field++, HouseInfo[MaxHouses][hClass]);
		cache_get_value_index_int(r, field++, HouseInfo[MaxHouses][hInt]);
		cache_get_value_index_int(r, field++, HouseInfo[MaxHouses][hDonate]);
		cache_get_value_index_int(r, field++, HouseInfo[MaxHouses][hPrice]);
		cache_get_value_index_bool(r, field++, HouseInfo[MaxHouses][hLock]);
		cache_get_value_index_int(r, field++, HouseInfo[MaxHouses][hExtraSlots]);
		cache_get_value_index_int(r, field++, HouseInfo[MaxHouses][hRentPrice]);

		if(HouseInfo[MaxHouses][hExtraSlots] > MAX_DONATE_FUR)
			HouseInfo[MaxHouses][hExtraSlots] = MAX_DONATE_FUR;
		//
		if(HouseInfo[MaxHouses][hInt] == 0) 	HouseInfo[MaxHouses][hInt] = random(5) + 1;
		if(HouseInfo[MaxHouses][hOwnerID] > 0) 	houses++;

		HouseMapIcon[MaxHouses] = CreateDynamicMapIcon(HouseInfo[MaxHouses][hX], HouseInfo[MaxHouses][hY], HouseInfo[MaxHouses][hZ], ICONID_SHOUSE, -1, -1, -1);
        HousePickups[MaxHouses] = CreateDynamicPickup(PICKUPID_SHOUSE, 6, HouseInfo[MaxHouses][hX], HouseInfo[MaxHouses][hY], HouseInfo[MaxHouses][hZ], 0);
        //HousePickups[MaxHouses] = CreateDynamicCP(HouseInfo[MaxHouses][hX], HouseInfo[MaxHouses][hY], HouseInfo[MaxHouses][hZ], 0.7, 0, 0, -1, 10.0);
        HouseTexts[MaxHouses] = CreateDynamic3DTextLabel("", 0xFFFFFFFF, HouseInfo[MaxHouses][hX], HouseInfo[MaxHouses][hY], HouseInfo[MaxHouses][hZ] + 0.5, 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0);
        MaxHouses++;
    }
	cache_delete(result);

	//	вызывать после основного цикла чтобы не испортить кеш запроса с домами
	for(new h = 0; h < MaxHouses; h++)
		UpdateHouse(h);

	//  Load furniture
	result = mysql_query(g_SQL, "SELECT `id`, `house_id`, `object_id`, `x`, `y`, `z`, `rx`, `ry`, `rz` FROM `furniture` WHERE `set` = '1'");
	new dynamic_id;
	if(cache_num_rows())
	{
		new id, house_id, object_id, Float:pos[6];
	    for(new r = 0; r < cache_num_rows(); r++)
		{
			cache_get_value_name_int(r, "id", id);
			cache_get_value_name_int(r, "house_id", house_id);
			cache_get_value_name_int(r, "object_id", object_id);
			cache_get_value_name_float(r, "x", pos[0]);
			cache_get_value_name_float(r, "y", pos[1]);
			cache_get_value_name_float(r, "z", pos[2]);
			cache_get_value_name_float(r, "rx", pos[3]);
			cache_get_value_name_float(r, "ry", pos[4]);
			cache_get_value_name_float(r, "rz", pos[5]);
			dynamic_id = CreateDynamicObject(object_id, Arr6<pos>, VW_HOUSE + house_id, 1);
			for(new i = sizeof FurnitureList - 1; i >= 0; i--)
			{
				if(FurnitureList[i][fID] != object_id)	continue;
				format(string, sizeof(string), "UPDATE `furniture` SET `dynamic_id` = '%d', `fur_num` = '%d' WHERE `id` = '%d'", dynamic_id, i, id);
				mysql_query_ex(string);
			}
			//printf( "[Debug] Furniture #%d load in house (id: %d), objectid: %d", itmp[ 0 ], itmp[ 1 ] + 1, itmp[ 2 ] );
		}
	}
	cache_delete(result);

	//	Create exit pickups
	for(new cl = 0; cl < sizeof(InterCoords); cl++)
	{
	    for(new in = 0; in < sizeof(InterCoords[]); in++)
	    {
			InterPickups[cl][in] = CreateDynamicPickup(PICKUPID_ENTRY, 6, InterCoords[cl][in][0], InterCoords[cl][in][1], InterCoords[cl][in][2] + 0.5);
	    }
	}
	return houses;
}

ToggleHouseIcons(playerid, toggle)
{
	if(toggle)
	{
		for(new h = 0; h < MaxHouses; h++)
		{
			if(HouseInfo[h][hOwnerID] == 0)
			{
				Streamer_AppendArrayData(STREAMER_TYPE_MAP_ICON, HouseMapIcon[h], E_STREAMER_PLAYER_ID, playerid);
			}
		}
	}
	else
	{
		for(new h = 0; h < MaxHouses; h++)
		{
			Streamer_RemoveArrayData(STREAMER_TYPE_MAP_ICON, HouseMapIcon[h], E_STREAMER_PLAYER_ID, playerid);
		}
	}
	Streamer_Update(playerid, STREAMER_TYPE_MAP_ICON);
}

stock UpdateHouse(h, bool:recreate = true)
{
	if(recreate == true && HouseInfo[h][hID] > 0)
	{
		new string[192];
		new players[MAX_PLAYERS] = { INVALID_PLAYER_ID, ... }, count = 0;
		if(HouseInfo[h][hOwnerID] > 0)
		{
			if(HouseInfo[h][hRentPrice] > 0)	Streamer_SetIntData(STREAMER_TYPE_PICKUP, HousePickups[h], E_STREAMER_MODEL_ID, PICKUPID_RHOUSE);
			else 								Streamer_SetIntData(STREAMER_TYPE_PICKUP, HousePickups[h], E_STREAMER_MODEL_ID, PICKUPID_BHOUSE);
			Streamer_SetFloatData(STREAMER_TYPE_PICKUP, HousePickups[h], E_STREAMER_Z, HouseInfo[h][hZ]);
			Streamer_SetArrayData(STREAMER_TYPE_MAP_ICON, HouseMapIcon[h], E_STREAMER_PLAYER_ID, players, count);
		}
		else
		{
		    foreach(LoginPlayer, i)
		    {
		    	if(PlayerInfo[i][pHouseIcon])
		    	{
		    		players[count++] = i;
		    	}
		    }
		    Streamer_SetArrayData(STREAMER_TYPE_MAP_ICON, HouseMapIcon[h], E_STREAMER_PLAYER_ID, players, count);
		    Streamer_SetIntData(STREAMER_TYPE_PICKUP, HousePickups[h], E_STREAMER_MODEL_ID, PICKUPID_SHOUSE);
		    Streamer_SetFloatData(STREAMER_TYPE_PICKUP, HousePickups[h], E_STREAMER_Z, HouseInfo[h][hZ]);
		}
		if(HouseInfo[h][hDonate] == 0)
		{
			if(HouseInfo[h][hOwnerID] == 0)
			{
				format(string, sizeof(string), 
					"{FFFFFF}Номер дома: {33AA33}%d\n\
					{FFFFFF}Класс дома: {33AA33}%c\n\
					{FFFFFF}Стоимость: {33AA33}$%d", 
						HouseInfo[h][hID], HouseInfo[h][hClass] + 64, HouseInfo[h][hPrice]);
			}
			else
			{
				format(string, sizeof(string), 
					"{FFFFFF}Номер дома: {33AA33}%d\n\
					{FFFFFF}Класс дома: {33AA33}%c\n\
					{FFFFFF}Владелец: {33AA33}%s", 
						HouseInfo[h][hID], HouseInfo[h][hClass] + 64, GetPlayerUsername(HouseInfo[h][hOwnerID]));
				if(HouseInfo[h][hRentPrice] > 0)	format(string, sizeof(string), "%s\n{FFFFFF}Аренда: {33AA33}$%d", string, HouseInfo[h][hRentPrice]);
			}
		}
		else
		{
			if(HouseInfo[h][hOwnerID] == 0)
			{
				format(string, sizeof(string), "{CFB53B}Дом #%d {FFFFFF}[Класс: {CFB53B}%c{FFFFFF}]\n{CFB53B}Стоимость: {FFFFFF}%d coins", HouseInfo[h][hID], HouseInfo[h][hClass] + 64, HouseInfo[h][hPrice]);
			}
			else
			{
				format(string, sizeof(string), "{CFB53B}Дом #%d {FFFFFF}[Класс: {CFB53B}%c{FFFFFF}]\n{CFB53B}Владелец: {FFFFFF}%s", HouseInfo[h][hID], HouseInfo[h][hClass] + 64, GetPlayerUsername(HouseInfo[h][hOwnerID]));
				if(HouseInfo[h][hRentPrice] > 0)	format(string, sizeof(string), "%s\n{CFB53B}Аренда: {FFFFFF}$%d", string, HouseInfo[h][hRentPrice]);
			}
		}
		UpdateDynamic3DTextLabelText(HouseTexts[h], 0xFFFFFFFF, string);
	}
}

stock BuyPlayerHouse(playerid, h)
{
	if(GetPlayerHouse(playerid) > 0)
	{
	    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете иметь больше 1 дома.");
	    return false;
	}
	if(HouseInfo[h][hDonate] == 0)
	{// Обычный дом (за доллары)
	    if(MyGetPlayerMoney(playerid) < HouseInfo[h][hPrice])
	    {
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас не хватает денег, чтобы купить этот дом.");
			return false;
		}
		MyGivePlayerMoney(playerid, -HouseInfo[h][hPrice]);
	}
	else
	{// Премиум дом (за валюту)
	    if(GetPlayerCoins(playerid) < HouseInfo[h][hPrice])
	    {
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас не хватает монет, чтобы купить этот дом.");
			return false;
		}
		GivePlayerCoins(playerid, -HouseInfo[h][hPrice]);
	}
	PlayerInfo[playerid][pHousing] = HouseInfo[h][hID];
	PlayerInfo[playerid][pSpawn] = SPAWN_HOUSE;
	HouseInfo[h][hOwnerID] = PlayerInfo[playerid][pUserID];
	HouseInfo[h][hLock] = true;
	UpdatePlayerHouseMapIcon(playerid);
	UpdateHouse(h);
	SaveHouse(h);

	#if defined _system_ucp_news_included
	    PushNews(playerid, NEWS_TYPE_HOUSE_PURCHASE, HouseInfo[h][hID]);
	#endif

	#if defined _player_achieve_included	
		GivePlayerAchieve(playerid, ACHIEVE_URBAN);
	#endif	
	
	return true;
}

SellHouse(h, show = true)
{
	new string[128];
	new owner = HouseInfo[h][hOwnerID];
	new playerid = GetPlayeridToUserID(owner);
	new price;
    if(HouseInfo[h][hDonate] == 0)	price = floatround(HouseInfo[h][hPrice] * 0.75);
    else 							price = floatround(HouseInfo[h][hPrice] * MoneyForCoin * 0.75);
	if(playerid != INVALID_PLAYER_ID)
	{
		if(show)
		{
			SendFormatMessage(playerid, COLOR_GREEN, string, "Вы успешно продали дом #%d за %d$", HouseInfo[h][hID], floatround(price));
        	GameTextForPlayer(playerid, "~n~~n~~w~PROPERTY SALES", 5000, 3);
			gPickupTime[playerid] = 3;
			SetPlayerInterior(playerid, 0);
	        SetPlayerVirtualWorld(playerid, 0);
	        MySetPlayerPos(playerid, HouseInfo[h][hX], HouseInfo[h][hY], HouseInfo[h][hZ], HouseInfo[h][hA]+180.0);
	        SetCameraBehindPlayer(playerid);
	        HidePropertyMenu(playerid);
		}
        PlayerPlaySound(playerid, 36200, 0, 0, 0);
		MyGivePlayerMoney(playerid, price);

		PlayerInfo[playerid][pHousing] = 0;
	    UpdatePlayerHouseMapIcon(playerid);
	}
	else
	{
		format(string, sizeof(string), "UPDATE `players` SET `money` = (`money` + '%d') WHERE `id` = '%d'", price, owner);
		mysql_query_ex(string);
	}

	//	сообщение арендаторам онлайн
	foreach(LoginPlayer, i)
	{
		if(PlayerInfo[i][pRent] == HouseInfo[h][hID])
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "[Аренда]: Вы выселены из арендуемого дома, так как он был продан за долги");
		}
	}
	//	сообщение арендаторам офлайн
	mysql_format(g_SQL, string, sizeof(string), "SELECT `id` FROM `players` WHERE `rent` = '%d' AND `online` = -1", HouseInfo[h][hID]);
	new Cache:result = mysql_query(g_SQL, string);
	new id;
	for(new i = 0; i < cache_num_rows(); i++)
	{
		cache_get_value_name_int(i, "id", id);
		SendOfflineMessage(id, "[Аренда]: Вы выселены из арендуемого дома, так как он был продан за долги");
	}
	//	удаляем арендаторов
	mysql_format(g_SQL, string, sizeof(string), "UPDATE `players` SET `rent` = '0', `payment_days` = 0 WHERE `rent` = '%d'", HouseInfo[h][hID]);
	mysql_query_ex(string);

	//	очищаем данные
	HouseInfo[h][hPaymentDays] = 0;
	HouseInfo[h][hRentPrice] = 0;
	HouseInfo[h][hOwnerID] = 0;
	HouseInfo[h][hLock] = false;
	HouseInfo[h][hExtraSlots] = 0;

	//  delete furniture
	format(string, sizeof(string), "SELECT `dynamic_id` FROM `furniture` WHERE `house_id` = '%d'", HouseInfo[h][hID]);
	result = mysql_query(g_SQL, string);
	if(cache_num_rows())
	{
		new dynamic_id;
	    for(new r = 0; r < cache_num_rows(); r++)
		{
			cache_get_value_name_int(r, "dynamic_id", dynamic_id);
	        DestroyDynamicObject(dynamic_id);
		}
	}
    cache_delete(result);
	format(string, sizeof(string), "DELETE FROM `furniture` WHERE `house_id` = '%d'", HouseInfo[h][hID]);
	mysql_query_ex(string);

	UpdateHouse(h);
	SaveHouse(h);
	return true;
}

stock FoundHouse(houseid)
{
	/* Вспомогательная функция, служит для поиска соответствующего номеру строки дом */
	if(houseid > 0)
	{
		for(new h; h < MaxHouses; h++)
		{
			if(houseid == HouseInfo[h][hID])
			{
				return h;
			}
		}
	}
	return -1;
}

GetPlayerHouse(playerid)
{
	new string[128], house = 0;
	format(string, sizeof(string), "SELECT `id` FROM `houses` WHERE `ownerid` = '%d'", PlayerInfo[playerid][pUserID]);
	new Cache:result = mysql_query(g_SQL, string);
	if(cache_num_rows()) cache_get_value_name_int(0, "id", house);
	cache_delete(result);
	return house;
}