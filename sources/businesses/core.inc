#include "businesses/header"

#include "businesses/commands"

stock FoundBiz(bizid)
{
	if(bizid > 0)
	{
		for(new b; b < MaxBiz; b++)
		{
			if(bizid == BizInfo[b][bID])
			{
				return b;
			}
		}
	}
	return -1;
}

SaveBiz(bizid = -1)
{
	// Сохранение всех бизнесов //
	if(bizid == -1)
	{
		for(bizid = 0; bizid < MaxBiz; bizid++)
		{
			SaveBiz(bizid);
		}
		return true;
	}

	// Сохранение конкретного бизнеса //
	if(0 <= bizid < sizeof(BizInfo) && BizInfo[bizid][bID] > 0)
	{
		new query[512];
		format(query, sizeof(query), "UPDATE business SET \
								name = '%s', type = '%d',\
								owner = '%d', sell_price = '%d',\
								bank = '%f', payment_days = '%d', price = '%d',\
								max_prods = '%d', product = '%d',\
								status = '%d',\
								x = '%f', y = '%f', z = '%f', r = '%f',\
								w_x = '%f', w_y = '%f', w_z = '%f',\
								location = '%d', enter_price = '%d'\
								WHERE id = '%d'",
								BizInfo[bizid][bName], 		BizInfo[bizid][bType],
								BizInfo[bizid][bOwnerID], 	BizInfo[bizid][bSellPrice],
								BizInfo[bizid][bBank], 		BizInfo[bizid][bPaymentDays], BizInfo[bizid][bPrice],
								BizInfo[bizid][bMaxProds], 	BizInfo[bizid][bProduct],
								BizInfo[bizid][bStatus],
								Arr4<BizInfo[bizid][bPos]>,
								Arr3<BizInfo[bizid][bWorkPos]>,
								BizInfo[bizid][bLocation], BizInfo[bizid][bEnterPrice],
								BizInfo[bizid][bID]);
		mysql_query_ex(query);
	}
	return true;
}

stock LoadBiz()
{
	new Cache:result = mysql_query(g_SQL, "SELECT * FROM `business` ORDER BY `id`");
	new str[256], biz;
	for(new i; i < cache_num_rows(); i++)
	{
		if(MaxBiz >= MAX_BUSINESSES)
        {
			printf( "  WARNING! Constant MAX_BUSINESSES(%d) is smaller then bus in database(%d)!", MAX_BUSINESSES, cache_num_rows());
            break;
        }
		new field = 0;
		cache_get_value_index_int(i, field++, BizInfo[i][bID]);
		cache_get_value_index(i, field++, str);
		format(BizInfo[i][bName], BIZ_NAME_SIZE, "%s", str);
		cache_get_value_index_int(i, field++, BizInfo[i][bType]);
		cache_get_value_index_int(i, field++, BizInfo[i][bOwnerID]);
		if(BizInfo[i][bOwnerID])	biz++;
		cache_get_value_index_int(i, field++, BizInfo[i][bSellPrice]);
		cache_get_value_index_float(i, field++, BizInfo[i][bBank]);
		cache_get_value_index_int(i, field++, BizInfo[i][bPaymentDays]);
		cache_get_value_index_int(i, field++, BizInfo[i][bPrice]);
		cache_get_value_index_int(i, field++, BizInfo[i][bMaxProds]);
		cache_get_value_index_int(i, field++, BizInfo[i][bProduct]);
		cache_get_value_index_int(i, field++, BizInfo[i][bStatus]);
		cache_get_value_index_float(i, field++, BizInfo[i][bPos][0]);
		cache_get_value_index_float(i, field++, BizInfo[i][bPos][1]);
		cache_get_value_index_float(i, field++, BizInfo[i][bPos][2]);
		cache_get_value_index_float(i, field++, BizInfo[i][bPos][3]);
		cache_get_value_index_float(i, field++, BizInfo[i][bWorkPos][0]);
		cache_get_value_index_float(i, field++, BizInfo[i][bWorkPos][1]);
		cache_get_value_index_float(i, field++, BizInfo[i][bWorkPos][2]);
		cache_get_value_index_int(i, field++, BizInfo[i][bLocation]);
		cache_get_value_index_int(i, field++, BizInfo[i][bEnterPrice]);

		//	Not load
		BizInfo[i][bRobbery] = INVALID_PLAYER_ID;

		MaxBiz++;
	}
	cache_delete(result);
	if(MaxBiz == 0)
	{
	    return -1;
	}
	new interior, skin;
	new Float:pos[3], Float:apos[4];
	for(new i; i < MaxBiz; i++)
	{
		if(BizInfo[i][bLocation] > 0)
		{
		    format(str, sizeof(str), "SELECT `x`, `y`, `z`, `actor_skin`, `actor_x`, `actor_y`, `actor_z`, `actor_a`, `interior` FROM %s.`locations` WHERE `id` = '%d'", MAIN_DB, BizInfo[i][bLocation]);
			result = mysql_query(g_SQL, str);
			cache_get_value_name_float(0, "x", pos[0]);
			cache_get_value_name_float(0, "y", pos[1]);
			cache_get_value_name_float(0, "z", pos[2]);
			cache_get_value_name_int(0, "actor_skin", skin);
			cache_get_value_name_float(0, "actor_x", apos[0]);
			cache_get_value_name_float(0, "actor_y", apos[1]);
			cache_get_value_name_float(0, "actor_z", apos[2]);
			cache_get_value_name_float(0, "actor_a", apos[3]);
			cache_get_value_name_int(0, "interior", interior);
			BizInfo[i][bExPickup] = CreateDynamicPickup(PICKUPID_ENTRY, 1, pos[0], pos[1], pos[2] + 0.5, VW_BIZ + i);
			if(skin != 0)
			{
				BizInfo[i][bActor] = CreateActor(skin, Arr4<apos>);
				SetActorVirtualWorld(BizInfo[i][bActor], VW_BIZ + i);
    			CreateDynamic3DTextLabel("Продавец\n{AFAFAF}(прицелиться + y)", 0xFFFFFFFF, apos[0], apos[1], apos[2] + 1.2, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, VW_BIZ + i);
			}
			cache_delete(result);
		}
		if(BizInfo[i][bType] == BUS_EATERY)
		{
			new icon;
			switch(GetEateryType(interior))
			{
				case 1:		icon = 29;	//	Well stacked pizza
				case 2:		icon = 14;	//	Cluckin Bell
				case 3:		icon = 10;	//	Burger Shot
				case 4:		icon = 17;	//	Ring Donuts
				default:	icon = BizTypeData[ BizInfo[i][bType] ][btMapIcon];
			}
			BizInfo[i][bMapIcon] = CreateDynamicMapIcon(Arr3<BizInfo[i][bPos]>, icon, -1);
		}
		else
		{
			BizInfo[i][bMapIcon] = CreateDynamicMapIcon(Arr3<BizInfo[i][bPos]>, BizTypeData[ BizInfo[i][bType] ][btMapIcon], -1);
		}
		if(BizInfo[i][bType] == BUS_STRIP)
		{
			//	Стриптизерши
			new strip = CreateActor(256, 1216.5, -6.6, 1001.3, 90.0);
			SetActorVirtualWorld(strip, VW_BIZ + i);
			ApplyActorAnimation(strip, "STRIP", "strip_G", 4.1, 1, 1, 1, 0, 0);
			strip = CreateActor(257, 1221.0, 8.24, 1001.3, 130.0);
			SetActorVirtualWorld(strip, VW_BIZ + i);
			ApplyActorAnimation(strip, "STRIP", "strip_A", 4.1, 1, 1, 1, 0, 0);
		}
		else if(BizInfo[i][bType] == BUS_CASINO)
		{
			// Автомобили в казино (четыре дракона)
			new cars[] = { 411, 415, 429, 451, 467, 541, 580 };
			new vehid = MyCreateVehicle(cars[random(sizeof(cars))], 1954.3347, 919.8059, 992.5, 215.0, 3, 1);
			LinkVehicleToInterior(vehid, 1);
			SetVehicleVirtualWorld(vehid, VW_BIZ + i);
			VehInfo[vehid][vLocked] = 999;
			UpdateVehicleParamsEx(vehid);
		}
		BizInfo[i][bPickup] = CreateDynamicPickup(PICKUPID_SBIZ, 1, Arr3<BizInfo[i][bPos]>);
		BizInfo[i][b3dText] = CreateDynamic3DTextLabel("_", COLOR_WHITE, BizInfo[i][bPos][0], BizInfo[i][bPos][1], BizInfo[i][bPos][2] + 1.0, 20.0);
		UpdateBusinessText(i);
	}
	return biz;
}

stock UpdateBusinessText(id)
{
	if(id < 0 || id >= MAX_BUSINESSES || BizInfo[id][bID] == 0)
	{
		return false;
	}
	new mes[256];
	if(BizInfo[id][bStatus])
	{
		if(BizInfo[id][bOwnerID])
		{
			format(mes, sizeof(mes),
			"{4682B4}%s\n\
			{4682B4}Владелец: {FFFFFF}%s\n\
			{4682B4}Крыша: {FFFFFF}Нет", BizTypeData[ BizInfo[id][bType] ][btName], GetPlayerUsername(BizInfo[id][bOwnerID]));
			Streamer_SetIntData(STREAMER_TYPE_PICKUP, BizInfo[id][bPickup], E_STREAMER_MODEL_ID, PICKUPID_BBIZ);
			Streamer_SetFloatData(STREAMER_TYPE_PICKUP, BizInfo[id][bPickup], E_STREAMER_Z, BizInfo[id][bPos][2] - 0.8);
		}
		else
		{
			format(mes, sizeof(mes),
			"{4682B4}%s\n\
			{4682B4}Стоимость: {FFFFFF}$%d\n\
			{4682B4}Крыша: {FFFFFF}Нет", BizTypeData[ BizInfo[id][bType] ][btName], BizInfo[id][bPrice]);
			Streamer_SetIntData(STREAMER_TYPE_PICKUP, BizInfo[id][bPickup], E_STREAMER_MODEL_ID, PICKUPID_SBIZ);
			Streamer_SetFloatData(STREAMER_TYPE_PICKUP, BizInfo[id][bPickup], E_STREAMER_Z, BizInfo[id][bPos][2]);
		}
		if(BizInfo[id][bEnterPrice])	format(mes, sizeof(mes), "%s\n{4682B4}Цена за вход: {FFFFFF}$%d", mes, BizInfo[id][bEnterPrice]);
	}
	else
	{
		strcat(mes, "\t\t\t{FF0000}ЗАКРЫТО\n{AFAFAF}(Информация недоступна)");
	}
	UpdateDynamic3DTextLabelText(BizInfo[id][b3dText], 0xFFFFFFFF, mes);
	return true;
}

stock BuyPlayerBiz(playerid, b)
{
	if(GetPlayerBiz(playerid) > 0)
	{
	    SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете иметь больше 1 бизнеса.");
	    return false;
	}
	if(MyGetPlayerMoney(playerid) < BizInfo[b][bPrice])
    {
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас не хватает денег, чтобы купить этот бизнес.");
		return false;
	}
	new string[128];
	MyGivePlayerMoney(playerid, -BizInfo[b][bPrice]);
	BizInfo[b][bOwnerID] = PlayerInfo[playerid][pUserID];
	BizInfo[b][bBank] = 0.0;
	SaveBiz(b);
	UpdateBusinessText(b);

	SetPlayerCameraPos(playerid, BizInfo[b][bPos][0] + 15.0, BizInfo[b][bPos][1] + 35.0, BizInfo[b][bPos][2] + 15.0);
	SetPlayerCameraLookAt(playerid, Arr3<BizInfo[b][bPos]>);
	GameTextForPlayer(playerid, "~n~~w~PROPERTY PURCHASED", 5000, 3);
	PlayAudioStreamForPlayer(playerid, AUDIOFILE_PATH "/complete.mp3");
	SetTimerEx("PlayerCameraBehind", 5000, false, "d", playerid);
	SendFormatMessageToAll(COLOR_ORANGE, string, "[NEWS]: {FFFFFF}%s{FF8300} покупает бизнес '{FFFFFF}%s{FF8300}'", ReturnPlayerName(playerid), BizInfo[b][bName]);
	gPickupTime[playerid] = 5;

	#if defined _system_ucp_news_included
	    PushNews(playerid, NEWS_TYPE_BUSINESS_PURCHASE, BizInfo[b][bID]);
	#endif

	return true;
}

stock SellBiz(b, show = true)
{
	new owner = BizInfo[b][bOwnerID];
	new playerid = GetPlayeridToUserID(owner);
	new Float:price = float(BizInfo[b][bPrice]) * 0.8 + BizInfo[b][bBank];
	if(playerid != INVALID_PLAYER_ID)
	{
		MyGivePlayerMoney(playerid, floatround(price));
		if(show)
		{
			GameTextForPlayer(playerid, "~n~~n~~w~PROPERTY SALES", 5000, 3);
			PlayerPlaySound(playerid, 36200, 0, 0, 0);
			//HidePropertyMenu(playerid);
		}
	}
	else
	{
		new query[128];
		format(query, sizeof(query), "UPDATE `players` SET `money` = (`money` + '%d') WHERE `id` = '%d'", floatround(price), owner);
		mysql_query_ex(query);
	}
	BizInfo[b][bBank] = 0.0;
	BizInfo[b][bPaymentDays] = 0;
	BizInfo[b][bOwnerID] = 0;
	SaveBiz(b);
	UpdateBusinessText(b);
	return true;
}

stock GetPlayerClotheShop(playerid)
{
	switch(GetPlayerInterior(playerid))
	{
		case 15:	return 1;
		case 14:	return 2;
		case 3:		return 3;
		case 1:		return 4;
		case 5:		return 5;
		case 18:	return 6;
	}
	return 0;
}

stock GetEateryType(interior)
{
	switch(interior)
	{
		case 5:		return 1;	//	Well stacked pizza
		case 9:		return 2;	//	Cluckin Bell
		case 10:	return 3;	//	Burger Shot
		case 17:	return 4;	//	Ring Donuts
	}
	return 0;
}

stock IsPlayerInShop(playerid)
{
	new b = GetBizWhichPlayer(playerid);
	if(b == INVALID_DATA)	return false;
	return BizInfo[b][bType] == BUS_SHOP ? true : false;
}

GetPlayerBiz(playerid)
{
	new string[128], b = 0;
	format(string, sizeof(string), "SELECT `id` FROM `business` WHERE `owner` = '%d'", PlayerInfo[playerid][pUserID]);
	new Cache:result = mysql_query(g_SQL, string);
	if(cache_num_rows())	cache_get_value_name_int(0, "id", b);
	cache_delete(result);
	return b;
}

stock PlayerEnterBiz(playerid, biz)
{
	//HidePropertyMenu(playerid);
	if(BizInfo[biz][bEnterPrice] && BizInfo[biz][bOwnerID] != PlayerInfo[playerid][pUserID])
	{
		if(GetPlayerMoney(playerid) < BizInfo[biz][bEnterPrice])
		{
			PickupedBiz[playerid] = INVALID_DATA;
			gPickupTime[playerid] = 5;
			return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас недостаточно денег.");
		}
		MyGivePlayerMoney(playerid, -BizInfo[biz][bEnterPrice]);
		BizInfo[biz][bBank] += float(BizInfo[biz][bEnterPrice]);
	}
	new string[128];
    format(string, sizeof(string), "SELECT `x`, `y`, `z`, `a`, `interior` FROM %s.`locations` WHERE `id` = '%d'", MAIN_DB, BizInfo[biz][bLocation]);
	new Cache:result = mysql_query(g_SQL, string);
	new Float:pos[4], int;
	cache_get_value_name_int(0, "interior", int);
	cache_get_value_name_float(0, "x", pos[0]);
	cache_get_value_name_float(0, "y", pos[1]);
	cache_get_value_name_float(0, "z", pos[2]);
	cache_get_value_name_float(0, "a", pos[3]);
	//MySetPlayerPosFade(playerid, FT_BIZ, Arr3<pos>, pos[3] + 180, true, int, VW_BIZ + b);
	MySetPlayerPos(playerid, Arr3<pos>, pos[3] + 180, int, VW_BIZ + biz);
	SetCameraBehindPlayer(playerid);
	cache_delete(result);
	return true;
}

stock ShowBizMenu(playerid, biz)
{
	switch(BizInfo[biz][bType])
	{
		case BUS_SHOP:
		{
			ShowDialog(playerid, DMODE_SHOP);
		}
		case BUS_EATERY:
		{
			switch(GetEateryType( GetPlayerInterior(playerid) ))
			{
				case 1:	//	Well stacked pizza
				{
					TogglePlayerControllable(playerid, false);
					ShowMenuForPlayer(PizzaMenu, playerid);
				}
				case 2:	//	Cluckin Bell
				{
					TogglePlayerControllable(playerid, false);
					ShowMenuForPlayer(CluckinBellMenu, playerid);
				}
				case 3:	//	Burger Shot
				{
					TogglePlayerControllable(playerid, false);
					ShowMenuForPlayer(BurgerShotMenu, playerid);
				}
				case 4:	//	Ring Donuts
				{
					TogglePlayerControllable(playerid, false);
					ShowMenuForPlayer(KingRingMenu, playerid);
				}
			}
		}
		case BUS_GAS_STATION:
		{
			ShowDialog(playerid, DMODE_GAS);
		}
		case BUS_BAR, BUS_CLUB, BUS_STRIP:
		{
			if(GetPlayerDrunkLevel(playerid) >= 50000)
	        	return ShowPlayerHint(playerid, "Вы слишком пьяны, чтобы выпить еще.");
			CreatePlayerDrinkMenu(playerid);
		}
		case BUS_GYM:
		{

		}
		case BUS_AMMO:
		{
			if(PlayerInfo[playerid][pGunLic] == 0)
			{
	            SendClientMessage(playerid, COLOR_SAYING, "- Продавец: Для покупки вам необходимо разрешение на оружие из полицейского участка");
			}
			else
			{
				SendClientMessage(playerid, COLOR_SAYING, "- Продавец: Для покупки подойдите к стойке с нужным оружием и нажмите {33AA33}H");
			}
		}
		case BUS_CLOTHING:
		{
			if(IsPlayerLeader(playerid))
		    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Лидер должен оставаться в своей одежде.");
		    if(PlayerInfo[playerid][pFaction] == F_POLICE)
		    	return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Полицейский не может покупать гражданскую одежду.");
		    SetPVarInt(playerid, "Player:MenuBizID", biz);
		    ClothesShopID[playerid] = GetPlayerClotheShop(playerid);
			ChoosePlayerClothes(playerid, 1);
		}
		case BUS_CASINO:
		{
			if(GetPlayerDrunkLevel(playerid) >= 50000)
	        	return ShowPlayerHint(playerid, "Вы слишком пьяны, чтобы выпить еще.");
			CreatePlayerDrinkMenu(playerid);
		}
	}
	return true;
}

stock BizSaleProds(biz, price, count)
{
	// Нормировка
	if(BizInfo[biz][bProduct] < 0) BizInfo[biz][bProduct] = 0;
	if(BizInfo[biz][bProduct] < count) count = BizInfo[biz][bProduct];

	// Выполнение операции
	if(BizInfo[biz][bOwnerID] > 0) BizInfo[biz][bBank] += float(price * count);
	BizInfo[biz][bProduct] -= count;
	SaveBiz(biz);
	return true;
}

stock GetBizWhichPlayer(playerid, only_within = 1)
{
	if(only_within == 0 && PickupedBiz[playerid] != INVALID_DATA)
		return PickupedBiz[playerid];
	new vw = GetPlayerVirtualWorld(playerid) - VW_BIZ;
	return (vw > 0 && vw < sizeof(BizInfo)) ? vw : INVALID_DATA;
}