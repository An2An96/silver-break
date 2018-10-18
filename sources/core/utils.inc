#define INVALID_DIALOGID                    (0xFFFF)
#define INVALID_ZONE                        (0xFFFF)
#define INVALID_DATA                        (0xFFFF)

#define CONTINUE                            (0xFFFF)
new _rslt;

//	Constructions
#define Arr3<%0>                            %0[0], %0[1], %0[2]
#define Arr4<%0>                            %0[0], %0[1], %0[2], %0[3]
#define Arr6<%0>                            %0[0], %0[1], %0[2], %0[3], %0[4], %0[5]
#define Arr9<%0>                            %0[0], %0[1], %0[2], %0[3], %0[4], %0[5], %0[6], %0[7], %0[8]
#define diff(%0,%1)                         ((%0>%1) ? (%0-%1) : (%1-%0))
#define Public:%0(%1)                       forward %0(%1); public %0(%1)
#define Callback:%0(%1)                     _rslt = %0(%1); if(_rslt != CONTINUE) return _rslt

//	Functions
#define PreloadAnimLib(%1,%2)				ApplyAnimation(%1,%2,"null",0.0,0,0,0,0,0)  //
#define RemovePlayerWorldBounds(%0)			SetPlayerWorldBounds(%0, 20000.0, -20000.0, 20000.0, -20000.0)
#define mysql_query_ex(%0)  				mysql_tquery(g_SQL, %0)
#define unixtime()							gettime(_, _, _)
#define IsNull(%0) 							((!(%0[0])) || (((%0[0]) == '\1') && (!(%0[1]))))  

//  Keys
#if !defined KEY_AIM
	#define KEY_AIM 						KEY_HANDBRAKE
#endif
#define HOLDING(%0)							((newkeys & (%0)) == (%0))
#define PRESSED(%0)							(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0)						(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

native gpci(playerid, buffer[], size);

stock PreloadAnimLibs(playerid)
{
	//PreloadAnimLib(playerid, "AIRPORT");
    //PreloadAnimLib(playerid, "Attractors");
    PreloadAnimLib(playerid, "BAR");
    PreloadAnimLib(playerid, "BASEBALL");
    //PreloadAnimLib(playerid, "BD_FIRE");
    PreloadAnimLib(playerid, "BEACH");
    PreloadAnimLib(playerid, "benchpress");
    //PreloadAnimLib(playerid, "BF_injection");
    //PreloadAnimLib(playerid, "BIKED");
    //PreloadAnimLib(playerid, "BIKEH");
    //PreloadAnimLib(playerid, "BIKELEAP");
    //PreloadAnimLib(playerid, "BIKES");
    //PreloadAnimLib(playerid, "BIKEV");
    //PreloadAnimLib(playerid, "BIKE_DBZ");
    //PreloadAnimLib(playerid, "BLOWJOBZ");
    //PreloadAnimLib(playerid, "BMX");
    PreloadAnimLib(playerid, "BOMBER");
    //PreloadAnimLib(playerid, "BOX");
    //PreloadAnimLib(playerid, "BSKTBALL");
    //PreloadAnimLib(playerid, "BUDDY");
    //PreloadAnimLib(playerid, "BUS");
    //PreloadAnimLib(playerid, "CAMERA");
    //PreloadAnimLib(playerid, "CAR");
    PreloadAnimLib(playerid, "CARRY");
    //PreloadAnimLib(playerid, "CAR_CHAT");
    PreloadAnimLib(playerid, "CASINO");
    //PreloadAnimLib(playerid, "CHAINSAW");
    //PreloadAnimLib(playerid, "CHOPPA");
    //PreloadAnimLib(playerid, "CLOTHES");
    //PreloadAnimLib(playerid, "COACH");
    //PreloadAnimLib(playerid, "COLT45");
    PreloadAnimLib(playerid, "COP_AMBIENT");
    //PreloadAnimLib(playerid, "COP_DVBYZ");
    PreloadAnimLib(playerid, "CRACK");
    //PreloadAnimLib(playerid, "CRIB");
    //PreloadAnimLib(playerid, "DAM_JUMP");
    PreloadAnimLib(playerid, "DANCING");
    PreloadAnimLib(playerid, "DEALER");
    //PreloadAnimLib(playerid, "DILDO");
    //PreloadAnimLib(playerid, "DODGE");
    //PreloadAnimLib(playerid, "DOZER");
    //PreloadAnimLib(playerid, "DRIVEBYS");
    //PreloadAnimLib(playerid, "FAT");
    //PreloadAnimLib(playerid, "FIGHT_B");
    PreloadAnimLib(playerid, "FIGHT_C");
    PreloadAnimLib(playerid, "FIGHT_D");
    //PreloadAnimLib(playerid, "FIGHT_E");
    //PreloadAnimLib(playerid, "FINALE");
    //PreloadAnimLib(playerid, "FINALE2");
    //PreloadAnimLib(playerid, "FLAME");
    //PreloadAnimLib(playerid, "Flowers");
    PreloadAnimLib(playerid, "FOOD");
    //PreloadAnimLib(playerid, "Freeweights");
    PreloadAnimLib(playerid, "GANGS");
    //PreloadAnimLib(playerid, "GHANDS");
    //PreloadAnimLib(playerid, "GHETTO_DB");
    //PreloadAnimLib(playerid, "goggles");
    //PreloadAnimLib(playerid, "GRAFFITI");
    PreloadAnimLib(playerid, "GRAVEYARD");
    //PreloadAnimLib(playerid, "GRENADE");
    //PreloadAnimLib(playerid, "GYMNASIUM");
    //PreloadAnimLib(playerid, "HAIRCUTS");
    PreloadAnimLib(playerid, "HEIST9");
    //PreloadAnimLib(playerid, "INT_HOUSE");
    PreloadAnimLib(playerid, "INT_OFFICE");
    PreloadAnimLib(playerid, "INT_SHOP");
    //PreloadAnimLib(playerid, "JST_BUISNESS");
    //PreloadAnimLib(playerid, "KART");
    //PreloadAnimLib(playerid, "KISSING");
    //PreloadAnimLib(playerid, "KNIFE");
    //PreloadAnimLib(playerid, "LAPDAN1");
    //PreloadAnimLib(playerid, "LAPDAN2");
    //PreloadAnimLib(playerid, "LAPDAN3");
    //PreloadAnimLib(playerid, "LOWRIDER");
    //PreloadAnimLib(playerid, "MD_CHASE");
    //PreloadAnimLib(playerid, "MD_END");
    PreloadAnimLib(playerid, "MEDIC");
    PreloadAnimLib(playerid, "MISC");
    //PreloadAnimLib(playerid, "MTB");
    //PreloadAnimLib(playerid, "MUSCULAR");
    //PreloadAnimLib(playerid, "NEVADA");
    //PreloadAnimLib(playerid, "ON_LOOKERS");
    //PreloadAnimLib(playerid, "OTB");
    //PreloadAnimLib(playerid, "PARACHUTE");
    //PreloadAnimLib(playerid, "PARK");
    //PreloadAnimLib(playerid, "PAULNMAC");
    PreloadAnimLib(playerid, "ped");
    //PreloadAnimLib(playerid, "PLAYER_DVBYS");
    //PreloadAnimLib(playerid, "PLAYIDLES");
    //PreloadAnimLib(playerid, "POLICE");
    //PreloadAnimLib(playerid, "POOL");
    //PreloadAnimLib(playerid, "POOR");
    //PreloadAnimLib(playerid, "PYTHON");
    //PreloadAnimLib(playerid, "QUAD");
    //PreloadAnimLib(playerid, "QUAD_DBZ");
    PreloadAnimLib(playerid, "RAPPING");
    //PreloadAnimLib(playerid, "RIFLE");
    PreloadAnimLib(playerid, "RIOT");
    //PreloadAnimLib(playerid, "ROB_BANK");
    //PreloadAnimLib(playerid, "ROCKET");
    //PreloadAnimLib(playerid, "RUSTLER");
    //PreloadAnimLib(playerid, "RYDER");
    //PreloadAnimLib(playerid, "SCRATCHING");
    //PreloadAnimLib(playerid, "SHAMAL");
    PreloadAnimLib(playerid, "SHOP");
    //PreloadAnimLib(playerid, "SHOTGUN");
    //PreloadAnimLib(playerid, "SILENCED");
    //PreloadAnimLib(playerid, "SKATE");
    //PreloadAnimLib(playerid, "SMOKING");
    //PreloadAnimLib(playerid, "SNIPER");
    //PreloadAnimLib(playerid, "SPRAYCAN");
    PreloadAnimLib(playerid, "STRIP");
    //PreloadAnimLib(playerid, "SUNBATHE");
    //PreloadAnimLib(playerid, "SWAT");
    //PreloadAnimLib(playerid, "SWEET");
    PreloadAnimLib(playerid, "SWIM");
    //PreloadAnimLib(playerid, "SWORD");
    //PreloadAnimLib(playerid, "TANK");
    //PreloadAnimLib(playerid, "TATTOOS");
    //PreloadAnimLib(playerid, "TEC");
    //PreloadAnimLib(playerid, "TRAIN");
    //PreloadAnimLib(playerid, "TRUCK");
    //PreloadAnimLib(playerid, "UZI");
    //PreloadAnimLib(playerid, "VAN");
    //PreloadAnimLib(playerid, "VENDING");
    //PreloadAnimLib(playerid, "VORTEX");
    //PreloadAnimLib(playerid, "WAYFARER");
    //PreloadAnimLib(playerid, "WEAPONS");
    //PreloadAnimLib(playerid, "WUZI");
	return true;
}

stock BubbleSort(a[], size)
{
	new tmp = 0, bool:swapped;
	do
	{
		swapped = false;
		for(new i = 1; i < size; i++) 
		{
			if(a[i - 1] > a[i]) 
			{
				tmp = a[i];
				a[i] = a[i - 1];
				a[i - 1] = tmp;
				swapped = true;
			}
		}
	} while(swapped);
}

stock GlobalPlaySound(soundid, Float:x, Float:y, Float:z)
{
	foreach(Player, i) 
	{
		if(IsPlayerInRangeOfPoint(i, 25.0, x, y, z))
			PlayerPlaySound(i, soundid, x, y, z);
	}
}

stock IsValidPlayer(playerid)
{
    return (0 <= playerid < MAX_PLAYERS) ? true : false;
}

stock BinToInt(bin)
{
    new s[16],
        Float:res = 0.0;
    format(s, 16, "%d", bin);
    for(new i = 0, len = strlen(s); i < len; i++)
        if(s[i] == '1')
            res += floatpower(2.0, float(len - i - 1));
    return floatround(res, floatround_round);
}

ChangeStringCase(string[], newCase)
{
    new len = strlen(string);
    switch(newCase)
    {
        case 3:
        {
            if(string[len - 1] == 'а')      string[len - 1] = 'у';
            else if(string[len - 1] == 'А') string[len - 1] = 'У';
        }
    }
}

//  PVArs
stock AddPVarFloat(playerid, var[], Float:val)
{
    return SetPVarFloat(playerid, var, GetPVarFloat(playerid, var) + val);
} 

//  Получить строку с именем игрока
stock	ReturnPlayerName(playerid)
{
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
	return playername;
}

stock	ReturnPlayerIP(playerid)
{
	new IP[16];
	GetPlayerIp(playerid, IP, 16);
	return IP;
}

stock	ReturnWeaponName(weaponid)
{
	new gunname[32];
	GetWeaponName(weaponid, gunname, sizeof(gunname));
	return gunname;
}

stock HexToRGB(color)
{
    new string[7];
    format(string, sizeof(string), "%06x", color >>> 8);
    return string;
}

// Убрать верхний регистр в строке
stock string_tolow(string[])    
{   
    for(new i = 0; i < strlen(string); i++)
        string[i] = tolower(string[i]); 
}

//  Запись строки в файл
stock fwriterus(File:filename,string[])
{
    for(new i, len = strlen(string); i < len; i++)
        fputchar(filename, string[i], false);
}

//  Вставить одну строку в другую
strput(dest[], const source[], minus = 0)   
{   
    return strmid(dest, source, 0, strlen(source) - minus, 255);  
}

//  Сравнить две строки
strcheck(const string1[], const string2[], bool:ignorecase = false, length = cellmax)
{
    if(!strcmp(string1, string2, ignorecase, length) && strlen(string1) && strlen(string2)) return true;
    else    return false;
}

//  Очистка чата
ClearChatbox(playerid, lines)
{
    for(new i = 0; i < lines; i++)
        SendClientMessage(playerid, -1, " ");
    return true;
}

stock GetPlayerSpeed(playerid, block_height = 0)
{
    new Float:pos[3];
    GetPlayerVelocity(playerid, Arr3<pos>);
    return floatround(floatsqroot(pos[0] * pos[0] + pos[1] * pos[1] + ((block_height) ? 0.0 : (pos[2] * pos[2]))) * 160);
}

stock IsPlayerSwiming(playerid)
{
    if(GetPlayerAnimationIndex(playerid))
    {
        new animlib[32], animname[32];
        GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, 32, animname, 32);
        if(strcmp(animlib, "SWIM", true) == 0) return true;
    }
    return false;
}

//  Check nickname function
stock IsCorrectName(const string[], bool:special = false)
{
    for(new k, l = strlen(string); k < l; k++)
    {
        switch(string[k])
        {
            case 'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '[', ']', '(', ')': { }
            case 'А'..'Я', 'а'..'я', ' ', '.': if(special == false) return false;
            default:    return false;
        }
    }
    return true;
}

stock IsRPName(const string[])
{
    if(!IsCorrectName(string))  return false;
    new fname[24], lname[24];
    if(sscanf(string, "p<_>s[24]s[24]", fname, lname))
    {
        return false;
    }
    return true;
}

stock IsValidEmail(mail[])
{
	new index,
		len = strlen(mail),
		dog = strfind(mail, "@", false, 0);

	if( len < 7 || len > 129 ||
		dog == -1 || strfind(mail, ".", false, dog + 1) == -1 ||
		strfind(mail, "@", false, dog + 1) != -1 ||
		mail[len - 1] == '.' || mail[len - 2] == '.' || mail[dog + 1] == '.' || mail[0] == '@')
	{
		return false;
	}
	while(mail[index])
	{
		if((mail[index] >= 'A' && mail[index] <= 'Z') || (mail[index] >= 'a' && mail[index] <= 'z') || (mail[index] >= '0' && mail[index] <= '9')
		||  mail[index] == '-' || mail[index] == '_' || mail[index] == '.' || mail[index] == '@')
		{
			index++;
		}
		else
			return false;
	}
	return true;
}

stock   IsIpAdress(ip[])
{
	new cutip[4][3];
	if(sscanf(ip, "p<.>s[3]s[3]s[3]s[3]", Arr4<cutip>))
	{
		return false;
	}
	for(new i = 0; i < 4; i++)
	{
		for(new j = 0; j < strlen(cutip[i]); j++)
		{
			if((cutip[i][j] >= '0' && cutip[i][j] <= '9') == false && cutip[i][j] != '*')
			{
				return false;
			}
		}
	}
	//format(str, 16, "%d.%d.%d.%d", ippart[0], ippart[1], ippart[2], ippart[3]);
	//if(strlen(ip) != strlen(str)) return false;
	return true;
}

//  Vehicle functions
GetVehicleSpeed(vehicleid)
{
	new Float:pos[3];
	GetVehicleVelocity(vehicleid, Arr3<pos>);
	return floatround(floatsqroot(pos[0] * pos[0] + pos[1] * pos[1] + pos[2] * pos[2]) * 160);
}