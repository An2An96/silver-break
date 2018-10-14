/*
	
	CreateWorldText(text[], Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
	DestroyWorldText(textid)
	SetWorldText(textid, text[])
	SetWorldTextPos(textid, Float:x, Float:y, Float:z)
	SetWorldTextRot(textid, Float:rx, Float:ry, Float:rz)
	SetWorldTextColor(textid, color)
	SetWorldTextBackgroundColor(textid, color)
	SetWorldTextFontface(textid, fontface[])
	SetWorldTextFontsize(textid, size)
	SetWorldTextBold(textid, bool:bold)
	
*/

#define MAX_WORLD_TEXT		512
#define INVALID_WORLD_TEXT	(0xFFFF)

enum E_WTEXT{
	WT_TEXT[64],
	WT_TEXT_COLOR,
	WT_BACKGROUND_COLOR,
	WT_FONTFACE[32],
	WT_FONTSIZE,
	bool:WT_BOLD,
	
	WT_OBJECTID,
};
new wlData[MAX_WORLD_TEXT][E_WTEXT];

stock WL_FindFreeSlot()
{
	for(new i = 1; i < MAX_WORLD_TEXT; i++)
	{
		if(IsValidDynamicObject(wlData[i][WT_OBJECTID]) == 0){
			return i;
		}	
	}
	return INVALID_WORLD_TEXT;
}

stock WL_GetObject(textid)
{
	if(IsValidDynamicObject(wlData[textid][WT_OBJECTID]) == 0)
	{
		return INVALID_WORLD_TEXT;
	}
	return wlData[textid][WT_OBJECTID];
}

stock UpdateWorldText(textid)
{
	if(IsValidDynamicObject(wlData[textid][WT_OBJECTID]) == 0)
	{
		return INVALID_WORLD_TEXT;
	}
	SetDynamicObjectMaterialText
	(
		wlData[textid][WT_OBJECTID], 
		0, 
		wlData[textid][WT_TEXT], 
		OBJECT_MATERIAL_SIZE_256x128, 
		wlData[textid][WT_FONTFACE], 
		wlData[textid][WT_FONTSIZE], 
		wlData[textid][WT_BOLD], 
		wlData[textid][WT_TEXT_COLOR], 
		wlData[textid][WT_BACKGROUND_COLOR], 
		OBJECT_MATERIAL_TEXT_ALIGN_CENTER
	);
	return true;
}

stock CreateWorldText(text[], Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, world = -1, interior = -1, playerid = -1)
{
	new textid = WL_FindFreeSlot();
	if(textid == INVALID_WORLD_TEXT)	{
		return INVALID_WORLD_TEXT;
	}
	format(wlData[textid][WT_TEXT], 64, "%s", text);
	wlData[textid][WT_TEXT_COLOR] = 0xFFFFFFFF;
	wlData[textid][WT_BACKGROUND_COLOR] = 0x00000000;
	wlData[textid][WT_FONTSIZE] = 24;
	format(wlData[textid][WT_FONTFACE], 32, "Arial");
	wlData[textid][WT_BOLD] = false;

	wlData[textid][WT_OBJECTID] = CreateDynamicObject(2661, x, y, z, rx, ry, rz, world, interior, playerid);
	UpdateWorldText(textid);
	return textid;
}

stock DestroyWorldText(textid)
{
	if(IsValidDynamicObject(wlData[textid][WT_OBJECTID]) == 0)
	{
		return INVALID_WORLD_TEXT;
	}
	DestroyDynamicObject(wlData[textid][WT_OBJECTID]);
	return true;
}

stock SetWorldText(textid, text[])
{
	if(IsValidDynamicObject(wlData[textid][WT_OBJECTID]) == 0)
	{
		return INVALID_WORLD_TEXT;
	}
	format(wlData[textid][WT_TEXT], sizeof(wlData[textid][WT_TEXT]), "%s", text);
	UpdateWorldText(textid);
	return true;
}

stock SetWorldTextPos(textid, Float:x, Float:y, Float:z)
{
	if(IsValidDynamicObject(wlData[textid][WT_OBJECTID]) == 0)
	{
		return INVALID_WORLD_TEXT;
	}
	SetDynamicObjectPos(wlData[textid][WT_OBJECTID], x, y, z);
	return true;
}

stock SetWorldTextRot(textid, Float:rx, Float:ry, Float:rz)
{
	if(IsValidDynamicObject(wlData[textid][WT_OBJECTID]) == 0)
	{
		return INVALID_WORLD_TEXT;
	}
	SetDynamicObjectPos(wlData[textid][WT_OBJECTID], rx, ry, rz);
	return true;
}

stock SetWorldTextColor(textid, color)
{
	if(IsValidDynamicObject(wlData[textid][WT_OBJECTID]) == 0)
	{
		return INVALID_WORLD_TEXT;
	}
	wlData[textid][WT_TEXT_COLOR] = color;
	UpdateWorldText(textid);
	return true;
}

stock SetWorldTextBackgroundColor(textid, color)
{
	if(IsValidDynamicObject(wlData[textid][WT_OBJECTID]) == 0)
	{
		return INVALID_WORLD_TEXT;
	}
	wlData[textid][WT_BACKGROUND_COLOR] = color;
	UpdateWorldText(textid);
	return true;
}

stock SetWorldTextFontface(textid, fontface[])
{
	if(IsValidDynamicObject(wlData[textid][WT_OBJECTID]) == 0)
	{
		return INVALID_WORLD_TEXT;
	}
	format(wlData[textid][WT_FONTFACE], 32, "%s", fontface);
	UpdateWorldText(textid);
	return true;
}	
	
stock SetWorldTextFontsize(textid, size)
{
	if(IsValidDynamicObject(wlData[textid][WT_OBJECTID]) == 0)
	{
		return INVALID_WORLD_TEXT;
	}
	wlData[textid][WT_FONTSIZE] = size;
	UpdateWorldText(textid);
	return true;
}		
	
stock SetWorldTextBold(textid, bool:bold)
{
	if(IsValidDynamicObject(wlData[textid][WT_OBJECTID]) == 0)
	{
		return INVALID_WORLD_TEXT;
	}
	wlData[textid][WT_BOLD] = bold;
	UpdateWorldText(textid);
	return true;
}