#if defined _inventory_acsr_included
  #endinput
#endif

#define _inventory_acsr_included

forward UpdatePlayerAcsr(playerid);

//	Типы прикрепляемых объектов
enum
{
	ACSR_EARFLAPS,	//	Наушники
	ACSR_HAT,		//	Шапки
	ACSR_GLASSES,	//	Очки
	ACSR_MASK,		//	Маски
	ACSR_HELMET,	//	Шлема
}

//	Группы прикрепляемых объектов
new const 
		Earflaps[]	= { 19421, 19422, 19423, 19424 },
		Glasses[]	= { 19006, 19007, 19008, 19009, 19010, 19011, 19012, 19013, 19014, 19015, 19016, 19017, 19018, 19019, 19020,
						19021, 19022, 19023, 19024, 19025, 19026, 19027, 19028, 19029, 19030, 19031, 19032, 19033, 19034, 19035 },
		Bandanas[]	= { 18911, 18912, 18913, 18914, 18915, 18916, 18917, 18918, 18919, 18920 },
		Helmets[]	= { 18645, 18976, 18977, 18978, 18979 },
		Hats[]		= { 19107, 19108, 19109, 19110, 19113, 19114, 19115, 19116, 19117, 19118, 19119, 19120, 18953, 18954, 18638,
						18639, 18971, 18973, 19095, 19096, 19097, 19098, 19099, 19100, 19136 };


enum E_ACSR_INFO
{
	aType,
	Float:aPos[6]
} 

static const EarflapsSkinOffSet[E_ACSR_INFO]	= { ACSR_EARFLAPS,	{ 0.048, -0.017, 0.0, -88.2, -5.8, -87.5 } };
static const GlassSkinOffSet[E_ACSR_INFO]		= { ACSR_GLASSES,	{ 0.098771, 0.030772, -0.000335, 85.342658, 84.122947, 4.236968 } };
static const BandanaSkinOffSet[E_ACSR_INFO]		= { ACSR_MASK,		{ -0.08, 0.03, 0.0, 90.0, -180.0, -90.0 } };
static const HelmetSkinOffSet[E_ACSR_INFO]		= { ACSR_HELMET,	{ 0.08, 0.03, 0.0, 92.6, 89.4, 0.0 } };
static const HatSkinOffSet[E_ACSR_INFO]			= { ACSR_HAT,		{ 0.1467, 0.011, 0.0, 0.0, 0.0, 0.0 } };

Public: Acsr.OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	if(GetPVarType(playerid, "Acsr:Edit:ThingID") != PLAYER_VARTYPE_NONE)
	{
		new string[256];
		new thingid = GetPVarInt(playerid, "Acsr:Edit:ThingID");
		if(response)
		{
			SendClientMessage(playerid, COLOR_WHITE, "Новая позиция аксессуара успешно сохранена.");
			mysql_format(g_SQL, string, sizeof(string), 
				"UPDATE `inventory` \
					SET `attach_x` = '%f', `attach_y` = '%f', `attach_z` = '%f', \
						`attach_rx` = '%f', `attach_ry` = '%f', `attach_rz` = '%f' \
					WHERE `id` = '%d'", fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, thingid);
			mysql_query_ex(string);
		}
		else
		{
			//WearEx(playerid, thingid);
		}
		DeletePVar(playerid, "Acsr:Edit:ThingID");
		DeletePVar(playerid, "Acsr:Edit:Slot");
		return true;
	}
	
    return CONTINUE;
}

Acsr.StartEdit(playerid, slot)
{
	SetPVarInt(playerid, "Acsr:Edit:Slot", slot);

	new string[16], thingid, attachSlot;
	format(string, 16, "Acsr:%d:ThingID", 	slot),	thingid 	= GetPVarInt(playerid, string);
	format(string, 16, "Acsr:%d:AttachSlot",slot),	attachSlot 	= GetPVarInt(playerid, string);

	SetPVarInt(playerid, "Acsr:Edit:ThingID", thingid);
	EditAttachedObject(playerid, attachSlot);
	return true;
}

Acsr.LoadPlayerAcsr(playerid)
{
	new string[256];
	mysql_format(g_SQL, string, sizeof(string), 
		"SELECT * FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d'", PlayerInfo[playerid][pUserID], _:TAB_ACSR);
	new Cache:result = mysql_query(g_SQL, string);

	new thingid, slot, thing, option, count, Float:attach[6];
	for(new i = 0; i < cache_num_rows(); i++)
	{
		//	одеваем
		cache_get_value_name_int(i, "id", thingid);
		cache_get_value_name_int(i, "slot", slot);
		cache_get_value_name_int(i, "thing", thing);
		cache_get_value_name_int(i, "option", option);
		cache_get_value_name_int(i, "count", count);

		cache_get_value_name_float(i, "attach_x", attach[0]);
		cache_get_value_name_float(i, "attach_y", attach[1]);
		cache_get_value_name_float(i, "attach_z", attach[2]);
		cache_get_value_name_float(i, "attach_rx", attach[3]);
		cache_get_value_name_float(i, "attach_ry", attach[4]);
		cache_get_value_name_float(i, "attach_rz", attach[5]);

		Acsr.SetPlayerAcsr(playerid, slot, thingid, Acsr.GetAttachType(thing), Acsr.GetAcsrObject(thing, option), false, 2, Arr6<attach>);
	}
	cache_delete(result);
}

stock Acsr.RemovePlayerAcsr(playerid, slot)
{
	new string[16], object, attachSlot;
	format(string, 16, "Acsr:%d:ThingID",	slot),	DeletePVar(playerid, string);
	format(string, 16, "Acsr:%d:Type",		slot),	DeletePVar(playerid, string);
	format(string, 16, "Acsr:%d:Object",	slot),	object 		= GetPVarInt(playerid, string),	DeletePVar(playerid, string);
	format(string, 16, "Acsr:%d:AttachSlot",slot),	attachSlot 	= GetPVarInt(playerid, string), DeletePVar(playerid, string);

	RemovePlayerAttachedObject(playerid, attachSlot);
	CallLocalFunction("OnPlayerRemoveAcsr", "ii", playerid, Acsr.GetObjectThing(object));
	return true;
}

stock Acsr.UpdatePlayerAcsr(playerid)
{
	new object, attachSlot, Float:attach[6], string[16];
	for(new i; i < 4; i++)
	{
		format(string, 16, "Acsr:%d:Type", i);
		if(GetPVarType(playerid, string) == PLAYER_VARTYPE_INT)
		{
			format(string, 16, "Acsr:%d:Object",	i),	object 		= GetPVarInt(playerid, string);
			format(string, 16, "Acsr:%d:AttachSlot",i),	attachSlot 	= GetPVarInt(playerid, string);

			//	одеваем на новый скин
			Acsr.GetAttachPosition(Acsr.GetObjectThing(object), Arr6<attach>);	//	находим примерную позицию для аттача
			SetPlayerAttachedObjectEx(playerid, attachSlot, object, 2, Arr6<attach>);
		}
	}
	return true;
}

stock Acsr.ShiftAcsr(playerid, sourceSlot, destSlot)
{
	if(Acsr.GetPlayerAcsrObject(playerid, destSlot) != INVALID_DATA)
	{
		return false;
	}
	new string[128], thindID, type, object, attachSlot;
	format(string, 16, "Acsr:%d:ThingID",	sourceSlot),	thindID		= GetPVarInt(playerid, string), DeletePVar(playerid, string);
	format(string, 16, "Acsr:%d:Type",		sourceSlot),	type 		= GetPVarInt(playerid, string), DeletePVar(playerid, string);
	format(string, 16, "Acsr:%d:Object",	sourceSlot),	object 		= GetPVarInt(playerid, string), DeletePVar(playerid, string);
	format(string, 16, "Acsr:%d:AttachSlot",sourceSlot),	attachSlot 	= GetPVarInt(playerid, string), DeletePVar(playerid, string);

	format(string, 16, "Acsr:%d:ThingID",	destSlot),	SetPVarInt(playerid, string, thindID);
	format(string, 16, "Acsr:%d:Type",		destSlot),	SetPVarInt(playerid, string, type);
	format(string, 16, "Acsr:%d:Object",	destSlot),	SetPVarInt(playerid, string, object);
	format(string, 16, "Acsr:%d:AttachSlot",destSlot),	SetPVarInt(playerid, string, attachSlot);

	mysql_format(g_SQL, string, sizeof(string), "UPDATE `inventory` SET `slot` = '%d' WHERE `id` = '%d'", destSlot, thindID);
	mysql_query_ex(string);
	return true;
}

stock Acsr.TryPlayerAcsr(playerid, object)
{
	new Float:attach[6];
	Acsr.GetAttachPosition(Acsr.GetObjectThing(object), Arr6<attach>);
	SetPlayerAttachedObjectEx(playerid, ATTACH_TRY_ACSR, object, 2, Arr6<attach>);
	return true;
}

stock Acsr.CancelTryPlayerAcsr(playerid)
{
	RemovePlayerAttachedObject(playerid, ATTACH_TRY_ACSR);
	return true;
}

stock Acsr.SetPlayerAcsr(playerid, slot, thingid, type, objectid, anim, bone, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:sx = 1.0, Float:sy = 1.0, Float:sz = 1.0)
{
	if(!(0 <= slot <= 3))									return ERROR_INVALID_SLOT;
	if(Acsr.GetSlotToType(playerid, type) != INVALID_DATA)	return ERROR_TYPE_ALREADY_USE;
	if(GetPVarInt(playerid, "Acsr:WearTimer"))				return ERROR_ALREADY_PUTS;

	new attachSlot = Acsr.FindSlotForAttach(playerid);
	if(attachSlot == INVALID_DATA)							return false;

	new string[48];
	format(string, 16, "Acsr:%d:ThingID",	slot),	SetPVarInt(playerid, string, thingid);
	format(string, 16, "Acsr:%d:Type",		slot),	SetPVarInt(playerid, string, type);
	format(string, 16, "Acsr:%d:Object",	slot),	SetPVarInt(playerid, string, objectid);
	format(string, 16, "Acsr:%d:AttachSlot",slot),	SetPVarInt(playerid, string, attachSlot);

	if(anim && MyApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.1, 0, 0, 0, 0, 0, 1))
	{
		SetPVarInt(playerid, "Acsr:WearTimer", SetPlayerTimerEx(playerid, "_WearPlayerAcsr", 4500, false, "iiifffffffff", playerid, slot, bone, x, y, z, rx, ry, rz, sx, sy, sz));
		SetPVarInt(playerid, "Acsr:WearObject", type);
	}
	else
	{
		SetPlayerAttachedObject(playerid, attachSlot, objectid, bone, x, y, z, rx, ry, rz, sx, sy, sz);
	}
	return true;
}

Public: _WearPlayerAcsr(playerid, slot, bone, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:sx, Float:sy, Float:sz)
{
	new string[16], object, attachSlot;
	format(string, 16, "Acsr:%d:Object", 	slot),	object = GetPVarInt(playerid, string);
	format(string, 16, "Acsr:%d:AttachSlot",slot),	attachSlot = GetPVarInt(playerid, string);
	SetPlayerAttachedObject(playerid, attachSlot, object, bone, x, y, z, rx, ry, rz, sx, sy, sz);
	
	format(string, 16, "Acsr:%d:Type", slot);
	CallLocalFunction("OnPlayerWearAcsr", "ii", playerid, Acsr.GetObjectThing(object));
	
	DeletePVar(playerid, "Acsr:WearTimer"), DeletePVar(playerid, "Acsr:WearType");
	return true;
}

DeletePlayerAcsr(playerid, type)
{
	new string[16];
	for(new i = 0; i < 4; i++)
	{
		format(string, 16, "Acsr:%d:Type", i);
		if(GetPVarType(playerid, string) == PLAYER_VARTYPE_INT && type == GetPVarInt(playerid, string))
		{
			RemovePlayerAttachedObject(playerid, ATTACH_SLOT_CLOTHE + i);
			DeletePVar(playerid, string);
			return true;
		}
	}
	return false;
}

////////////////////		System		////////////////////
Acsr.FindSlotForAttach(playerid)
{
	for(new i = 0; i < 4; i++)
	{
		if(!IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_SLOT_CLOTHE + i))
		{
			return ATTACH_SLOT_CLOTHE + i;
		}
	}
	return INVALID_DATA;
}

Acsr.GetSlotToType(playerid, type)
{
	new string[16];
	for(new i = 0; i < 4; i++)
	{
		format(string, 16, "Acsr:%d:Type", i);
		if(GetPVarType(playerid, string) && GetPVarInt(playerid, string) == type)
		{
			return i;
		}
	}
	return INVALID_DATA;
}

Acsr.GetPlayerAcsrObject(playerid, slot)
{
	new string[16];
	format(string, 16, "Acsr:%d:Object", slot);
	if(GetPVarType(playerid, string) == PLAYER_VARTYPE_NONE)
	{
		return INVALID_DATA;
	}
	return GetPVarInt(playerid, string);
}

Acsr.GetFreeSlot(playerid)
{
	new string[16];
	for(new i = 0; i < 4; i++)
	{
		format(string, 16, "Acsr:%d:Type", i);
		if(!GetPVarType(playerid, string))
		{
			return i;
		}
	}
	return INVALID_DATA;
}

////////////////////////////////////////////

Acsr.GetAttachPosition(thing, &Float:x, &Float:y, &Float:z, &Float:rx, &Float:ry, &Float:rz)
{
	new slot;
	switch(thing)
	{
		case THING_MUSIC:
		{
			slot = EarflapsSkinOffSet[aType];
			x = EarflapsSkinOffSet[aPos][0], y = EarflapsSkinOffSet[aPos][1], z = EarflapsSkinOffSet[aPos][2];
			rx = EarflapsSkinOffSet[aPos][3], ry = EarflapsSkinOffSet[aPos][4], rz = EarflapsSkinOffSet[aPos][5];
		}
		case THING_GLASS:
		{
			slot = GlassSkinOffSet[aType];
			x = GlassSkinOffSet[aPos][0], y = GlassSkinOffSet[aPos][1], z = GlassSkinOffSet[aPos][2];
			rx = GlassSkinOffSet[aPos][3], ry = GlassSkinOffSet[aPos][4], rz = GlassSkinOffSet[aPos][5];
		}
		case THING_MASK:
		{
			slot = BandanaSkinOffSet[aType];
			x = BandanaSkinOffSet[aPos][0], y = BandanaSkinOffSet[aPos][1], z = BandanaSkinOffSet[aPos][2];
			rx = BandanaSkinOffSet[aPos][3], ry = BandanaSkinOffSet[aPos][4], rz = BandanaSkinOffSet[aPos][5];
		}
		case THING_HAT:
		{
			slot = HatSkinOffSet[aType];
			x = HatSkinOffSet[aPos][0], y = HatSkinOffSet[aPos][1], z = HatSkinOffSet[aPos][2]; 
			rx = HatSkinOffSet[aPos][3], ry = HatSkinOffSet[aPos][4], rz = HatSkinOffSet[aPos][5];
		}
		case THING_HELMET:
		{
			slot = HelmetSkinOffSet[aType];
			x = HelmetSkinOffSet[aPos][0], y = HelmetSkinOffSet[aPos][1], z = HelmetSkinOffSet[aPos][2];
			rx = HelmetSkinOffSet[aPos][3], ry = HelmetSkinOffSet[aPos][4], rz = HelmetSkinOffSet[aPos][5];
		}
	}
	return slot;
}

Acsr.GetAttachType(thing)
{
	switch(thing)
	{
		case THING_MUSIC:	return EarflapsSkinOffSet[aType];
		case THING_GLASS:	return GlassSkinOffSet[aType];
		case THING_MASK:	return BandanaSkinOffSet[aType];
		case THING_HAT:		return HatSkinOffSet[aType];
		case THING_HELMET:	return HelmetSkinOffSet[aType];
	}
	return false;
}

Acsr.GetObjectThing(object)
{
	for(new i = 0; i < sizeof(Earflaps); i++)
	{
		if(Earflaps[i] == object)	return THING_MUSIC;
	}
	for(new i = 0; i < sizeof(Glasses); i++)
	{
		if(Glasses[i] == object)	return THING_GLASS;
	}
	for(new i = 0; i < sizeof(Bandanas); i++)
	{
		if(Bandanas[i] == object)	return THING_MASK;
	}
	for(new i = 0; i < sizeof(Helmets); i++)
	{
		if(Helmets[i] == object)	return THING_HELMET;
	}
	for(new i = 0; i < sizeof(Hats); i++)
	{
		if(Hats[i] == object)		return THING_HAT;
	}
	return false;
}

Acsr.GetAcsrObject(thing, option)
{
	if(option < 0)	return false;
	switch(thing)
	{
		case THING_MUSIC:
		{
			if(option >= sizeof(Earflaps))	return false;
			return Earflaps[option];
		}
		case THING_GLASS:
		{
			if(option >= sizeof(Glasses))	return false;
			return Glasses[option];
		}
		case THING_MASK:
		{
			if(option >= sizeof(Bandanas))	return false;
			return Bandanas[option];
		}
		case THING_HELMET:
		{
			if(option >= sizeof(Helmets))	return false;
			return Helmets[option];
		}
		case THING_HAT:
		{
			if(option >= sizeof(Hats))		return false;
			return Hats[option];
		}
	}
	return false;
}