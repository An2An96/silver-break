#if defined _vehicle_core_included
	#endinput
#endif

#define _vehicle_core_included

#include "vehicle/header"

#include "vehicle/load"
#include "vehicle/interface"

stock MyCreateVehicle(modelid, Float:x, Float:y, Float:z, Float:rotation, color1 = -1, color2 = -1, respawn_delay = VEH_SPAWNTIME, addsiren = 0)
{
	if(modelid != -1 && (modelid < 400 || modelid > 611)) return false;

	if(modelid == -1)	modelid = GetRandomModel();
	if(color1 == -1)	color1 = random(126) + 1;
	if(color2 == -1)	color2 = random(126) + 1;

	new vehid;
	new mtype = VehParams[modelid - 400][VEH_MTYPE];
	if(mtype == MTYPE_TRAIN) 	vehid = AddStaticVehicle(modelid, x, y, z, rotation, color1, color2);
	else if(modelid != 0)		vehid = CreateVehicle(modelid, x, y, z, rotation, color1, color2, -1, addsiren);
	if(vehid == 0 || vehid == INVALID_VEHICLE_ID)
	{
		return false;
	}

	Iter_Add(Vehicle, vehid); //  add for foreach
	MySetVehicleHealth(vehid, 999.0); // 1000 not allowed
    VehInfo[vehid][vCreated] = true;
	VehInfo[vehid][vModelType] = mtype;
	VehInfo[vehid][vRespawn] = respawn_delay;
	VehInfo[vehid][vRespawnTime] = 0;
	VehInfo[vehid][vPos][0] = x;
	VehInfo[vehid][vPos][1] = y;
	VehInfo[vehid][vPos][2] = z;
	VehInfo[vehid][vPos][3] = rotation;
	VehInfo[vehid][vRadio] = 0;
	VehInfo[vehid][vRentOwner] = 0;
	VehInfo[vehid][vRentPrice] = 0;
	VehInfo[vehid][vPlayers] = 0;
	VehInfo[vehid][vDriver] = -1;
	VehInfo[vehid][vCoDriver] = -1;
	VehInfo[vehid][vLeftSeat] = -1;
	VehInfo[vehid][vRightSeat] = -1;
	VehInfo[vehid][vLights] = false;
	VehInfo[vehid][vLocked] = 0;
	VehInfo[vehid][vFlashMode] = 0;
   	VehInfo[vehid][vFlashState] = 0;
	VehInfo[vehid][vFuel] = GetVehicleMaxFuel(vehid);
	VehInfo[vehid][vTrailerID] = 0;
	VehInfo[vehid][vSpawnDestroy] = false;
	VehInfo[vehid][vTrapState] = false;

	CarInfo[vehid][cX] = x;
	CarInfo[vehid][cY] = y;
	CarInfo[vehid][cZ] = z;
	CarInfo[vehid][cA] = rotation;

    CarInfo[vehid][cType] = C_TYPE_DEFAULT;
    CarInfo[vehid][cOwnerID] = INVALID_PLAYER_ID;
    CarInfo[vehid][cModel] = modelid;
	CarInfo[vehid][cColor1] = color1;
	CarInfo[vehid][cColor2] = color2;
	CarInfo[vehid][cPaintJob] = 3;
	CarInfo[vehid][cSpoiler] = 0;
	CarInfo[vehid][cHood] = 0;
	CarInfo[vehid][cRoof] = 0;
	CarInfo[vehid][cSideskirt] = 0;
	CarInfo[vehid][cNitro] = 0;
	CarInfo[vehid][cLamps] = 0;
	CarInfo[vehid][cExhaust] = 0;
	CarInfo[vehid][cWheels] = 0;
	CarInfo[vehid][cHydraulics] = 0;
	CarInfo[vehid][cFrontBumper] = 0;
	CarInfo[vehid][cRearBumper] = 0;
	CarInfo[vehid][cVentR] = 0;
	CarInfo[vehid][cVentL] = 0;
	CarInfo[vehid][cNeon] = 0;
	CarInfo[vehid][cFlash] = 0;
	CarInfo[vehid][cMileage] = random(10000);

	SetVehicleEngine(vehid, false);
	SetVehicleBonnet(vehid, false);
	SetVehicleBoot(vehid, false);
	UpdateVehicleParamsEx(vehid);

	// Генерируем последовательность взлома
	//VehInfo[vehid][vBitHack] = 1;
	//for(new i = 0; i < BREAK_CAR_CODE_LEN; i++)
	//    VehInfo[vehid][vBitHack] = (VehInfo[vehid][vBitHack] << 1) | random(2);

	// Создаем объекты вертолета для десанта
	if(modelid == 548)
	{
        VehInfo[vehid][vObject][0] = CreateDynamicObject(19454, 314.2, 1034.82, 1946.9, -4.5, 90.0, 0.0, vehid);
        VehInfo[vehid][vObject][1] = CreateDynamicObject(19454, 317.7, 1034.82, 1946.9, -4.5, 90.0, 0.0, vehid);
		SetDynamicObjectMaterial(VehInfo[vehid][vObject][0], 0, 3068, "cargo_rear", "cargo_gir3", 0);
		SetDynamicObjectMaterial(VehInfo[vehid][vObject][1], 0, 3068, "cargo_rear", "cargo_gir3", 0);
		VehInfo[vehid][vText3D] = CreateDynamic3DTextLabel("Прыжок запрещен!", 0xFF0000FF, 315.8, 1029.5, 1949.5, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, vehid);
	}
	return vehid;
}

stock MyDestroyVehicle(vehicleid)
{
    if(0 < vehicleid < MAX_VEHICLES && VehInfo[vehicleid][vModelType] != MTYPE_TRAIN)
    {
		if(DestroyVehicle(vehicleid))
		{
			CarInfo[vehicleid][cID] = 0;
		    CarInfo[vehicleid][cType] = C_TYPE_DEFAULT;
		    CarInfo[vehicleid][cOwnerID] = INVALID_PLAYER_ID;
		    VehInfo[vehicleid][vCreated] = false;
		    VehInfo[vehicleid][vModelType] = 0;
			CarInfo[vehicleid][cColor1] = 0;
			CarInfo[vehicleid][cColor2] = 0;
			VehInfo[vehicleid][vRadio] = 0;
			VehInfo[vehicleid][vPlayers] = 0;
			VehInfo[vehicleid][vTrapState] = false;
			//
			VehInfo[vehicleid][vDriver] = -1;
			VehInfo[vehicleid][vCoDriver] = -1;
			VehInfo[vehicleid][vLeftSeat] = -1;
			VehInfo[vehicleid][vRightSeat] = -1;
			//
			RemoveNeons(vehicleid);
			DestroyDynamic3DTextLabel(VehInfo[vehicleid][vLabel]), VehInfo[vehicleid][vLabel] = Text3D:INVALID_STREAMER_ID;
			DestroyDynamic3DTextLabel(VehInfo[vehicleid][vText3D]), VehInfo[vehicleid][vText3D] = Text3D:INVALID_STREAMER_ID;
			DestroyDynamicObject(VehInfo[vehicleid][vObject][0]), VehInfo[vehicleid][vObject][0] = INVALID_STREAMER_ID;
			DestroyDynamicObject(VehInfo[vehicleid][vObject][1]), VehInfo[vehicleid][vObject][1] = INVALID_STREAMER_ID;
		    Iter_SafeRemove(Vehicle, vehicleid, VehInfo[vehicleid][vIterNext]);
			return true;
		}
    }
	return false;
}

UpdateVehicleLabel(vehicleid)
{
	new string[128];
	switch(CarInfo[vehicleid][cType])
	{
		case C_TYPE_JOB:
		{
			if(CarInfo[vehicleid][cOwnerID] == JOB_MECHANIC)
			{
				format(string, sizeof(string), "Топливо: %d/%dл", floatround(VehInfo[vehicleid][vFuel]), GetVehicleMaxFuel(vehicleid));
				UpdateDynamic3DTextLabelText(VehInfo[vehicleid][vLabel], COLOR_LIGHTPINK, string);
			}
		}
		case C_TYPE_PARTJOB:
		{
		#if defined	_job_part_delivery_included
			if(CarInfo[vehicleid][cOwnerID] == PART_DELIVERY)
			{
				if(DeliveryVehLoadCount[vehicleid] > 0)
				{
				    format(string, sizeof(string), "Товар: %d/%d", DeliveryVehLoadCount[vehicleid], Delivery_GetLoadSize(GetVehicleModel(vehicleid)));
				}
				else 	strput(string, "Не загружен");
				UpdateDynamic3DTextLabelText(VehInfo[vehicleid][vLabel], COLOR_LIGHTPINK, string);
			}
		#endif	
		}
		case C_TYPE_RENT:
		{
			if(CarInfo[vehicleid][cOwnerID] == -1 && VehInfo[vehicleid][vRentPrice] > 0)
			{
				if(VehInfo[vehicleid][vRentOwner] == 0)
				{
					format(string, sizeof(string), "Аренда\nСтоимость: {FFFFFF}$%d/час", VehInfo[vehicleid][vRentPrice]);
				}
				UpdateDynamic3DTextLabelText(VehInfo[vehicleid][vLabel], COLOR_LIGHTGREEN, string);
			}
		}
	}
	return true;
}

stock IsAvailableVehicle(vehicleid, playerid)
{	// return:	VEH_AVAILABLE_NONE		- не имеет доступа к авто
	//			VEH_AVAILABLE_DRIVE		- может ездить, но не может заводить, закрывать и т д
	//			VEH_AVAILABLE_CONTROL	- может управлять: закрывать, заводить (арендованное авто/ивент)
	//			VEH_AVAILABLE_OWNER		- личное авто

	//	Другие авто
	switch(CarInfo[vehicleid][cType])
	{
	    case C_TYPE_DEFAULT:
	    {
	        if(CarInfo[vehicleid][cOwnerID] == INVALID_PLAYER_ID) 	return VEH_AVAILABLE_NONE;
	        else if(CarInfo[vehicleid][cOwnerID] == -1) 			return VEH_AVAILABLE_CONTROL;
	        else if(CarInfo[vehicleid][cOwnerID] == playerid) 		return VEH_AVAILABLE_CONTROL;
	    }
	    //	Личные авто
	    case C_TYPE_PLAYER:
	    {
	        if(CarInfo[vehicleid][cOwnerID] == PlayerInfo[playerid][pUserID]) 	return VEH_AVAILABLE_OWNER;
	        else 																return VEH_AVAILABLE_DRIVE;
	    }
	    //	Фракционные авто
	    case C_TYPE_FACTION:
	    {
	        if(CarInfo[vehicleid][cOwnerID] == PlayerInfo[playerid][pFaction]) 	return VEH_AVAILABLE_CONTROL;
	    }
	    //	Рабочие авто
	    case C_TYPE_JOB:
	    {
	    	if(CarInfo[vehicleid][cOwnerID] == Job.GetPlayerJob(playerid))
	    	{
	    		if(VehInfo[vehicleid][vRentPrice] > 0)
				{
					if(VehInfo[vehicleid][vRentOwner] == PlayerInfo[playerid][pUserID])
					{
						return VEH_AVAILABLE_CONTROL;
					}
					else
					{
						return VEH_AVAILABLE_DRIVE;
					}
				}
				else
				{
					return VEH_AVAILABLE_CONTROL;
				}
    		}
	        else if(CarInfo[vehicleid][cOwnerID] == JOB_NONE)					return VEH_AVAILABLE_CONTROL;
	    }
	    //	Авто подработок
	    case C_TYPE_PARTJOB:
	    {
	    	if(Job.GetPlayerNowWork(playerid) == CarInfo[vehicleid][cOwnerID])
	    	{
	    		if(VehInfo[vehicleid][vRentPrice] > 0)
				{
					if(VehInfo[vehicleid][vRentOwner] == PlayerInfo[playerid][pUserID])
					{
						return VEH_AVAILABLE_CONTROL;
					}
					else
					{
						return VEH_AVAILABLE_DRIVE;
					}
				}
				else
				{
					return VEH_AVAILABLE_CONTROL;
				}
	    	}	
	    }
	    //	Арендованные авто
	    case C_TYPE_RENT:
	    {
	    	if(VehInfo[vehicleid][vRentPrice] > 0)
			{
				if(VehInfo[vehicleid][vRentOwner] == PlayerInfo[playerid][pUserID])
				{
					return VEH_AVAILABLE_CONTROL;
				}
			}
			else
			{
				return VEH_AVAILABLE_DRIVE;
			}
	    }
	    //	Машины созданные администрацией
	    case C_TYPE_EVENT:
	    {
	        return VEH_AVAILABLE_CONTROL;
	    }
	}
	return VEH_AVAILABLE_NONE;
}

//	Control Vehicles
encode_tires(tires1, tires2, tires3, tires4)
{
	return tires1 | (tires2 << 1) | (tires3 << 2) | (tires4 << 3);
}

stock bool:GetVehicleEngine(vehicleid)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return (engine ? true : false);
}

stock SetVehicleEngine(vehicleid, status)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, status, lights, alarm, doors, bonnet, boot, objective);
	return true;
}

stock bool:GetVehicleBonnet(vehicleid)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return (bonnet ? true : false);
}

stock SetVehicleBonnet(vehicleid, status)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, status, boot, objective);
	return true;
}

stock bool:GetVehicleBoot(vehicleid)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return (boot ? true : false);
}

stock SetVehicleBoot(vehicleid, status)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, status, objective);
	return true;
}

stock setVehicleAlarm(vehicleid, bool:toggle = true, time = -1)
{	//  toggle = 0 - off, 1 - on	|	time = -1 - all, >0 - set time
    if(toggle)	VehInfo[vehicleid][vAlarm] = time;
	else		VehInfo[vehicleid][vAlarm] = 0;
	VehInfo[vehicleid][vAlarmLight] = toggle;
	return UpdateVehicleParamsEx(vehicleid);
}

stock bool:getVehicleAlarm(vehicleid)
{
	return VehInfo[vehicleid][vAlarm] ? true : false;
}

stock SetVehicleFlasher(vehicleid, mode)
{
    new panel, door, light, tire;
    GetVehicleDamageStatus(vehicleid, panel, door, light, tire);
	//if(light == 5)
	//    return false;// Нельзя включать маячки с разбитыми фарами
	if(0 <= mode <= 5)
	{
 		UpdateVehicleDamageStatus(vehicleid, panel, door, 0, tire);
    	VehInfo[vehicleid][vFlashMode] = mode;
    	VehInfo[vehicleid][vFlashState] = 0;
	    return true;
	}
	return false;
}

stock UpdateVehicleParamsEx(vehicleid, objective2 = 0)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(
		vehicleid,
		engine,
		VehInfo[vehicleid][vAlarm] ? VehInfo[vehicleid][vAlarmLight] : VehInfo[vehicleid][vLights],
		VehInfo[vehicleid][vAlarm] ? true : false,
		VehInfo[vehicleid][vLocked] ? true : false,
		bonnet,
		boot,
		objective2
	);
	VehInfo[vehicleid][vWishFuel] = 0.0;
	return true;
}

MyChangeVehicleColor(vehicleid, color1, color2)
{
	CarInfo[vehicleid][cColor1] = color1;
	CarInfo[vehicleid][cColor2] = color2;
	return ChangeVehicleColor(vehicleid, color1, color2);
}

MySetVehicleToRespawn(vehicleid)
{
	ZeroVehSeats(vehicleid);
	return SetVehicleToRespawn(vehicleid);
}

stock ZeroVehSeats(vehicleid)
{
    if(VehInfo[vehicleid][vDriver] >= 0)
	{
	    PlayerVehicle[VehInfo[vehicleid][vDriver]] = 0;
	    VehInfo[vehicleid][vDriver] = -1;
	}
	if(VehInfo[vehicleid][vCoDriver] >= 0)
	{
	    PlayerVehicle[VehInfo[vehicleid][vCoDriver]] = 0;
	    VehInfo[vehicleid][vCoDriver] = -1;
	}
	if(VehInfo[vehicleid][vLeftSeat] >= 0)
	{
	    PlayerVehicle[VehInfo[vehicleid][vLeftSeat]] = 0;
	    VehInfo[vehicleid][vLeftSeat] = -1;
	}
	if(VehInfo[vehicleid][vRightSeat] >= 0)
	{
	    PlayerVehicle[VehInfo[vehicleid][vRightSeat]] = 0;
	    VehInfo[vehicleid][vRightSeat] = -1;
	}
}

stock IsVehicleIsEmpty(vehicleid)
{
    if(VehInfo[vehicleid][vDriver] >= 0) return false;
	if(VehInfo[vehicleid][vCoDriver] >= 0) return false;
	if(VehInfo[vehicleid][vLeftSeat] >= 0) return false;
	if(VehInfo[vehicleid][vRightSeat] >= 0) return false;
	return true;
}

Float:MyGetVehicleHealth(vehicleid)
{
	new Float:Health;
	GetVehicleHealth(vehicleid, Health);
	return Health;
}

IsCopCar(vehicleid)
{
	if(0 <= vehicleid <= sizeof(CarInfo))
	{
		if(CarInfo[vehicleid][cType] == C_TYPE_FACTION && CarInfo[vehicleid][cOwnerID] == F_POLICE)
		{
			return true;
		}
	}
	return false;
}

GetVehicleMaxFuel(vehicleid)
{
	new modelid = GetVehicleModel(vehicleid);
	if(modelid >= 400)	return VehParams[modelid - 400][VEH_FUEL];
	return 0;
}

ReturnVehicleName(vehicleid)
{
	new name[32];
	new modelid = GetVehicleModel(vehicleid);
	if(modelid >= 400)	strput(name, VehParams[modelid - 400][VEH_NAME]);
	return name;
}

SetVehicleSpeed(vehicleid, Float:speed_mph)
{
  	BlockVehicleEffect(vehicleid);

   	new Float: v[3], Float: cur_speed_mph;
   	GetVehicleVelocity(vehicleid, Arr3<v>);
   	cur_speed_mph = 200.0 * floatsqroot(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
   	if(cur_speed_mph <= 0.0)
   	{
     	new Float:zAngle;
     	GetVehicleZAngle( vehicleid, zAngle );
     	new Float:newVelX = floatcos( (zAngle -= 270.0), degrees ) * speed_mph / 200.0;
     	return SetVehicleVelocity( vehicleid, newVelX, floattan(zAngle,degrees) * newVelX, 0.0 );
   	}
   	new Float:vMultiplier = speed_mph / cur_speed_mph;
   	return SetVehicleVelocity(vehicleid, v[0] * vMultiplier, v[1] * vMultiplier, v[2] * vMultiplier);
}

stock AttachNeons(vehicleid, color)
{
	if(GetVehicleModel(vehicleid) == 0 || color < 0 || color > 5)
	{
		return false;
	}
	if(g_NeonObject[vehicleid][0] || g_NeonObject[vehicleid][1])
	{
		RemoveNeons(vehicleid);
	}
	new model = GetVehicleModel(vehicleid) - 400;
	g_NeonObject[vehicleid][0] = CreateDynamicObject(18647 + color, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	g_NeonObject[vehicleid][1] = CreateDynamicObject(18647 + color, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	AttachDynamicObjectToVehicle(g_NeonObject[vehicleid][0], vehicleid, (NeonPos[model][0] / 2) - 0.5, 
		NeonPos[model][4] - NeonPos[model][4], NeonPos[model][5] - 0.5, 0.00, 0.00, 0.00);
	AttachDynamicObjectToVehicle(g_NeonObject[vehicleid][1], vehicleid, ((NeonPos[model][0] / 2) + 0.5) - NeonPos[model][0],
		NeonPos[model][4] - NeonPos[model][4], NeonPos[model][5] - 0.5, 0.00, 0.00, 0.00);
	return true;
}

stock RemoveNeons(vehicleid)
{
	DestroyDynamicObject(g_NeonObject[vehicleid][0]), g_NeonObject[vehicleid][0] = INVALID_STREAMER_ID;
	DestroyDynamicObject(g_NeonObject[vehicleid][1]), g_NeonObject[vehicleid][1] = INVALID_STREAMER_ID;
	g_NeonObject[vehicleid][0] = 0; 	g_NeonObject[vehicleid][1] = 0;
	return true;
}

stock bool:IsVehicleWithEngine(vehicleid)
{
	switch(VehParams[GetVehicleModel(vehicleid) - 400][VEH_MTYPE])
	{
	    case MTYPE_NONE, MTYPE_MOTO, MTYPE_TRUCK, MTYPE_BOAT, MTYPE_NODOOR:	
	    {
	    	return true;
		}
	}
	return false;
}

stock UpdateVehicleRespawnDelay(vehicleid, respawnDelay)
{
	VehInfo[vehicleid][vRespawn] = respawnDelay;
}

stock IsPlayerHaveLicThisVehicle(playerid, modelid)
{
	switch(VehParams[modelid - 400][VEH_MTYPE])
    {
    	case MTYPE_MOTO:
    	{
    		if(PlayerInfo[playerid][pCarLicA] == 0)
    		{
    			return false;
    		}
    	}
    	case MTYPE_NONE:
    	{
    		if(PlayerInfo[playerid][pCarLicB] == 0)
    		{
    			return false;
    		}
    	}
    	case MTYPE_TRUCK:
    	{
    		if(PlayerInfo[playerid][pCarLicC] == 0)
    		{
    			return false;
    		}
    	}
    	case MTYPE_BUS:
    	{
    		if(PlayerInfo[playerid][pCarLicD] == 0)
    		{
    			return false;
    		}
    	}
    }
    return true;
}