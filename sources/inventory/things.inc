#if defined _inventory_things_included
  #endinput
#endif

#define _inventory_things_included

new gPresentBoxObject;

UseItem:Gascan(playerid, thingid, option, count)
{
	// Канистра с бензином
	if(IsPlayerInAnyVehicle(playerid))
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Невозможно использовать канистру из машины");
        return false;
	}
	new v = GetNearVehicles(playerid);
	if(!v)
	{
		SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Поблизости нет ни одной машины");
        return false;
	}
    if(GetVehicleEngine(v))
    {
    	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Для заправки необходимо заглушить двигатель");
        return false;
    }
    new const Float:add = 10.0;
    if(VehInfo[v][vFuel] + add > GetVehicleMaxFuel(v))
    {
    	SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "В бак этого транспорта не поместиться столько бензина");
        return false;
    }
    VehInfo[v][vFuel] += add;
   	PlayerAction(playerid, "заливает топливо из канистры.");
   	return true;
}

UseItem:Watch(playerid, thingid, option, count)
{
    callcmd::time(playerid, "");
    return true;
}

UseItem:Chocolate(playerid, thingid, option, count)
{
    if(!EatPlayer(playerid, 30, "ест гамбургер"))
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "В данный момент вы не можете есть");
        return false;
    } 
    return true;
}

UseItem:Apple(playerid, thingid, option, count)
{
    if(!EatPlayer(playerid, 5, "ест яблоко"))
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "В данный момент вы не можете есть");
        return false;
    } 
    return true;
}

UseItem:Orange(playerid, thingid, option, count)
{
    if(!EatPlayer(playerid, 5, "ест апельсин"))
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "В данный момент вы не можете есть");
        return false;
    } 
    return true;
}

UseItem:Banana(playerid, thingid, option, count)
{
    if(!EatPlayer(playerid, 5, "ест банан"))
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "В данный момент вы не можете есть");
        return false;
    } 
    return true;
}

UseItem:Cereal(playerid, thingid, option, count)
{
    if(!EatPlayer(playerid, 50, "ест хлопья"))
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "В данный момент вы не можете есть");
        return false;
    } 
    return true;
}

UseItem:Bread(playerid, thingid, option, count)
{
    if(!EatPlayer(playerid, 30, "ест хлеб"))
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "В данный момент вы не можете есть");
        return false;
    } 
    return true;
}

UseItem:Milk(playerid, thingid, option, count)
{
    if(!EatPlayer(playerid, 30, "пьет молоко"))
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "В данный момент вы не можете есть");
        return false;
    } 
    return true;
}

UseItem:Juice(playerid, thingid, option, count)
{
    if(!EatPlayer(playerid, 15, "пьет сок"))
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "В данный момент вы не можете есть");
        return false;
    } 
    return true;
}

UseItem:IceCream(playerid, thingid, option, count)
{
    if(!EatPlayer(playerid, 15, "ест мороженное"))
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "В данный момент вы не можете есть");
        return false;
    } 
    return true;
}

UseItem:Firework(playerid)
{
    if(IsPlayerInAnyVehicle(playerid))
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Запуск фейерверка недоступен из машины");
        return false;
    }
    if(GetPlayerInterior(playerid))
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Запуск фейерверка в зданиях запрещен");
        return false;
    }
    if(GetPVarInt(playerid, "Player:InGreenZone"))
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Запуск фейерверка недоступен в зеленой зоне");
        return false;
    }
    if(FW_Missile[playerid])
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы уже поставили фейерверк");
        return false;
    }
    if(MyApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0))
    {
        new Float:X, Float:Y, Float:Z, Float:angle;
        MyGetPlayerPos(playerid, X, Y, Z, angle);
        X += floatsin(-angle, degrees);
        Y += floatcos(-angle, degrees);
        FW_Missile[playerid] = CreateObject(3786, X, Y, Z-1.5, 0.0, 90.0, 0.0);
        FW_Smoke[playerid] = CreateObject(18704, X, Y, Z-2.6, 0.0, 0.0, 0.0);
        SetTimerEx("Firework", 6000, false, "dd", playerid, 1);
    }
    return true;
}

Public: Firework(playerid, step)
{
    switch(step)
    {
        case 1:
        {
            new Float:objx, Float:objy, Float:objz;
            GetObjectPos(FW_Missile[playerid], objx, objy, objz);
            CreateExplosion(objx, objy, objz, 12, 5.0);
            //spark[playerid] = CreateObject(18718, objx, objy, objz, 0, 0, 0);
            DestroyObject(FW_Smoke[playerid]);
            FW_Smoke[playerid] = CreateObject(18715, objx, objy, objz, 0.0, 0.0, 0.0);
            //AttachObjectToObject(spark[playerid],c_object[playerid],0,0,-1,0,0,0,0);
            AttachObjectToObject(FW_Smoke[playerid], FW_Missile[playerid], 0.0,0.0,0.0,0.0,0.0,0.0,0);
            MoveObject(FW_Missile[playerid], objx, objy, objz+30.0, 20.0);
            SetTimerEx("Firework", 1200, 0, "dd", playerid, 2);
        }
        case 2:
        {
            new Float:objx, Float:objy, Float:objz;
            GetObjectPos(FW_Missile[playerid], objx, objy, objz);
            CreateExplosion(objx, objy, objz, 0, 5.0);
            DestroyObject(FW_Smoke[playerid]);
            DestroyObject(FW_Missile[playerid]);
            for(new i = 0; i < 8; i++)
            {
                new Float:randx = objx+random(16)-8;
                new Float:randy = objy+random(16)-8;
                new Float:randz = objz+random(8)-4;
                FW_Sparks[playerid][i] = CreateDynamicPickup(354, 13, randx, randy, randz);
                CreateExplosion(randx, randy, randz, 12, 5.0);
            }
            FW_Missile[playerid] = 0;
            SetTimerEx("Firework", 2500, false, "dd", playerid, 3);
        }
        case 3:
        {
            for(new i = 0; i < 8; i++)
            {
                DestroyDynamicPickup(FW_Sparks[playerid][i]), FW_Sparks[playerid][i] = INVALID_STREAMER_ID;
            }
        }
    }
    return true;
}

UseItem:Picklock(playerid)
{
    if(Job.GetPlayerJob(playerid) != JOB_THEFT)
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Только угонщик может использовать отмычку");
        return false;
    }
    if(IFace.GetGroupToggle(playerid, IFace.HACK_LOCK))
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы уже взламываете машину");
        return false;
    }
    new v = GetNearVehicles(playerid, 1);
    if(!v)
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Поблизости нет ни одной закрытой машины");
        return false;
    }
    if(IsAvailableVehicle(v, playerid))
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас есть ключи от машины, похлопайте по карманам");
        return false;
    }
    if(CarInfo[v][cType] == C_TYPE_PLAYER)
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не можете угонять личные автомобили");
        return false;
    }
    if(VehInfo[v][vPlayers] > 0)
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "В машине кто-то есть");
        return false;
    }
    SetPVarInt(playerid, "LastLockCar", v);
    BreakCar(playerid, BREAK_CAR_HACKING, 0);
    HidePlayerInventory(playerid);
    return true;
}

UseItem:Firstaid(playerid)
{
    new Float:Health;
    GetPlayerHealth(playerid, Health);
    if(Health >= 100.0)
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вам не требуется аптечка");
        return false;
    }
    Health += 10.0;
    if(Health > 100.0)  Health = 100.0;
    MySetPlayerHealth(playerid, Health);
    PlayerAction(playerid, "перевязывает рану.");
    return true;
}

UseItem:Cigarette(playerid)
{
    if(MyApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0, 1))
    {
        if(playerDrink{playerid})   ClearPlayerDrink(playerid); 
        playerSmokeCount{playerid} = 5;
        MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
        PlayerAction(playerid, "закуривает сигарету.");
        ShowPlayerHint(playerid, "~y~ЛКМ~w~ - Затянуться сигаретой~n~~y~Enter~w~ - Закончить курить");
        return true;
    }
    return false;
}

UseItem:Metall(playerid, thingid, option, count)
{
    if(IsMafia(PlayerInfo[playerid][pFaction]))//Job.GetPlayerJob(playerid) != JOB_GUNDEAL)
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не торговец оружием");
        return false;
    }
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, -616.3, -478.1, 25.7))    
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не на месте переработки металла");
        return false;
    }
    new string[128];
    Inv.AddPlayerThing(playerid, THING_GUN_MATS, (count * 100), 0);
    PlayerAction(playerid, "изготавливает материалы");
    SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "Вы переработали %d металла и получили %d материалов", count, count * 100);
    return true;
}

UseItem:GunMats(playerid)
{
    if(IsMafia(PlayerInfo[playerid][pFaction]))//Job.GetPlayerJob(playerid) != JOB_GUNDEAL)
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не торговец оружием");
        return false;
    }
    ShowDialog(playerid, DJOB_GUNDEAL_GUN);
    return false;
}

UseItem:DrugsMats(playerid)
{
    if(IsMafia(PlayerInfo[playerid][pFaction]))//Job.GetPlayerJob(playerid) != JOB_DRUGDEAL)
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не наркодиллер");
        return false;
    }
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2164.1, -249.25, 36.51)) 
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Вы не на месте переработки");
        return false;
    }
    if(MyApplyAnimation(playerid, "INT_SHOP", "shop_cashier", 4.1, 1, 0, 0, 1, 11000))
    {
        new bool:comb[5];
        _GenerateComb(sizeof(comb), comb);
        SetPlayerComb(playerid, COMB_CREATE_DRUG, sizeof(comb), comb, true);
        HidePlayerInventory(playerid);
    }
    return false;
}

UseItem:Drug(playerid)
{
    if(DrugsCrack[playerid])
    {   
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас передозировка, вы не можете принять дозу.");
        return false;
    }
    new Float:Health = MyGetPlayerHealth(playerid) + 20.0;
    if(Health > 160.0)  Health = 160.0;
    MySetPlayerHealth(playerid, Health);
    
    PlayerAction(playerid, "употребляет наркотики");
    SetPlayerWeather(playerid, -68);
    SetPlayerDrunkLevel(playerid, GetPlayerDrunkLevel(playerid) + 1000);
    
    UseDrugsTime[playerid] += 60;
    if(UseDrugsTime[playerid] > 120)
    {
        SendClientMessage(playerid, COLOR_RED, "У вас произошла передозировка!");
        MyApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 1, 1, 1, 1, 0, 1);
        DrugsCrack[playerid] = true;
    }
    else
    {
        if(!IsPlayerInAnyVehicle(playerid)) MyApplyAnimation(playerid, "SMOKING", "M_smk_drag", 4.1, 0, 0, 0, 0, 0, 1);
    }
    return true;
}

UseItem:Chips(playerid)
{
    return true;
}

UseItem:Presentbox(playerid)
{
    new Float:X, Float:Y, Float:Z;
    GetPlayerPos(playerid, X, Y, Z);
    DestroyObject(gPresentBoxObject);
    gPresentBoxObject = CreateObject(18678, X, Y, Z - 2.0, 0.0, 0.0, 0.0);
    PlayerAction(playerid, "вскрывает коробку с подарком.");
    //
    Inv.AddPlayerThing(playerid, THING_FIRSTAID, 2);
    MyGivePlayerMoney(playerid, 5000);    
    ShowPlayerHint(playerid, "~g~Коробка с подарком~w~~n~~n~- Аптечка [2 шт]______~n~- Конверт [$5000]~n~", 8000);
    PlayerPlaySound(playerid, 17200, 0.0, 0.0, 0.0);
    return true;
}

UseItem:Helpreward(playerid)
{
    ShowPlayerHint(playerid, "~b~Награда 'За помощь!'~w~~n~~n~Выдана в знак благодарности за активную помощь серверу.~n~");
    return true;
}

UseItem:Skin(playerid, thingid, option, count)
{
    new string[128];
    format(string, sizeof(string), "UPDATE `inventory` SET `option` = '%d' WHERE `id` = '%d'", PlayerInfo[playerid][pSkin], thingid);
    mysql_query(g_SQL, string);

    PlayerInfo[playerid][pSkin] = option;
    UpdatePlayerSkin(playerid);
    UpdatePlayerData(playerid, "skin", PlayerInfo[playerid][pSkin]);
    PlayerAction(playerid, "переодевается.");
    return true;
}

UseItem:Wear(playerid, thingid)
{
    new slot = Acsr.GetFreeSlot(playerid);
    if(slot == INVALID_DATA)
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас нет свободных слотов, чтобы одеть эту вещь.");
        return false;
    }
    Inv.WearAcsr(playerid, thingid, slot);
    return true;
}

/*UseItem:Box(playerid, thingid)
{
    if(pThingInHand[playerid] == 0 || pThingInHand[playerid] == thingid)
    {
        if(Inv.IsItemUsed(thingid))
        {
            MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
            RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND);
            IFace.Inv_DeleteTab(playerid, TAB_IN_HAND, thingid);
            Inv.SetItemFlag(thingid, false);
            pThingInHand[playerid] = 0;
        }
        else
        {
            if(Inv.SetThingInHand(playerid, THING_BOX))
            {
                IFace.Inv_AddTab(playerid, "BOX", TAB_IN_HAND, thingid, 6);
                Inv.SetItemFlag(thingid, true);
                pThingInHand[playerid] = thingid;
            }
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ваши руки уже заняты другим предметом.");
    }
    return true;
}

UseItem:Box2(playerid, thingid)
{
    if(pThingInHand[playerid] == 0 || pThingInHand[playerid] == thingid)
    {
        if(Inv.IsItemUsed(thingid))
        {
            MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
            RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND);
            IFace.Inv_DeleteTab(playerid, TAB_IN_HAND, thingid);
            Inv.SetItemFlag(thingid, false);
            pThingInHand[playerid] = 0;
        }
        else
        {
            if(Inv.SetThingInHand(playerid, THING_BOX2))
            {
                IFace.Inv_AddTab(playerid, "BOX", TAB_IN_HAND, thingid, 6);
                Inv.SetItemFlag(thingid, true);
                pThingInHand[playerid] = thingid;
            }
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ваши руки уже заняты другим предметом.");
    }
    return true;
}

UseItem:Suitcase(playerid, thingid)
{
    if(pThingInHand[playerid] == 0 || pThingInHand[playerid] == thingid)
    {
        if(Inv.IsItemUsed(thingid))
        {
            RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1);
            IFace.Inv_DeleteTab(playerid, TAB_IN_HAND, thingid);
            Inv.SetItemFlag(thingid, false);
            pThingInHand[playerid] = 0;
        }
        else
        {
            if(Inv.SetThingInHand(playerid, THING_SUITCASE))
            {
                IFace.Inv_AddTab(playerid, "CASE", TAB_IN_HAND, thingid, 6);
                Inv.SetItemFlag(thingid, true);
                pThingInHand[playerid] = thingid; 
            }
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ваши руки уже заняты другим предметом.");
    }
    return true;
}

UseItem:Suitcase2(playerid, thingid)
{
    if(pThingInHand[playerid] == 0 || pThingInHand[playerid] == thingid)
    {
        if(Inv.IsItemUsed(thingid))
        {
            RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1);
            IFace.Inv_DeleteTab(playerid, TAB_IN_HAND, thingid);
            Inv.SetItemFlag(thingid, false);
            pThingInHand[playerid] = 0;
        }
        else
        {
            if(Inv.SetThingInHand(playerid, THING_SUITCASE2))
            {
                IFace.Inv_AddTab(playerid, "CASE", TAB_IN_HAND, thingid, 6);
                Inv.SetItemFlag(thingid, true);
                pThingInHand[playerid] = thingid;
            }
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ваши руки уже заняты другим предметом.");
    }
    return true;
}

UseItem:Bag(playerid, thingid)
{
    if(pThingInHand[playerid] == 0 || pThingInHand[playerid] == thingid)
    {
        if(Inv.IsItemUsed(thingid))
        {
            RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1);
            IFace.Inv_DeleteTab(playerid, TAB_IN_HAND, thingid);
            Inv.SetItemFlag(thingid, false);
            pThingInHand[playerid] = 0;
        }
        else
        {
            if(Inv.SetThingInHand(playerid, THING_BAG))
            {
                IFace.Inv_AddTab(playerid, "BAG", TAB_IN_HAND, thingid, 6);
                Inv.SetItemFlag(thingid, true);
                pThingInHand[playerid] = thingid;
            }
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ваши руки уже заняты другим предметом.");
    }
    return true;
}

UseItem:Bag2(playerid, thingid)
{
    if(pThingInHand[playerid] == 0 || pThingInHand[playerid] == thingid)
    {
        if(Inv.IsItemUsed(thingid))
        {
            RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND + 1);
            IFace.Inv_DeleteTab(playerid, TAB_IN_HAND, thingid);
            Inv.SetItemFlag(thingid, false);
            pThingInHand[playerid] = 0;
        }
        else
        {
            if(Inv.SetThingInHand(playerid, THING_BAG2))
            {
                IFace.Inv_AddTab(playerid, "BAG", TAB_IN_HAND, thingid, 6);
                Inv.SetItemFlag(thingid, true);
                pThingInHand[playerid] = thingid;
            }
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ваши руки уже заняты другим предметом.");
    }
    return true;
}

UseItem:Trash(playerid, thingid)
{
    if(pThingInHand[playerid] == 0 || pThingInHand[playerid] == thingid)
    {
        if(Inv.IsItemUsed(thingid))
        {
            MySetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
            RemovePlayerAttachedObject(playerid, ATTACH_SLOT_IN_HAND);
            IFace.Inv_DeleteTab(playerid, TAB_IN_HAND, thingid);
            Inv.SetItemFlag(thingid, false);
            pThingInHand[playerid] = 0;
        }
        else
        {
            if(Inv.SetThingInHand(playerid, THING_TRASH))
            {
                IFace.Inv_AddTab(playerid, "TRASH", TAB_IN_HAND, thingid, 6);
                Inv.SetItemFlag(thingid, true);
                pThingInHand[playerid] = thingid;
            }
        }
    }
    else
    {
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "Ваши руки уже заняты другим предметом.");
    }
    return true;
}*/

//////////  Commands    //////////
COMMAND:firework(playerid, params[])
{
    if(PlayerUseThing(playerid, THING_FIREWORK) == 0)
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас нет фейерверка.");
    return true;
}

COMMAND:smoke(playerid, params[])
{
    if(PlayerUseThing(playerid, THING_CIGARETTE) == 0)
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас нет сигарет.");
    return true;
}

COMMAND:usedrugs(playerid, params[])
{
    if(PlayerUseThing(playerid, THING_DRUGS) == 0)
        SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "У вас нет при себе наркотиков.");
    return 1;
}