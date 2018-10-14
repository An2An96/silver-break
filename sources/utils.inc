native gpci(playerid, buffer[], size);

#define INVALID_DIALOGID		(0xFFFF)
#define INVALID_ZONE			(0xFFFF)
#define INVALID_DATA			(0xFFFF)

//	Constructions
#define Arr3<%0>				%0[0], %0[1], %0[2]
#define Arr4<%0>				%0[0], %0[1], %0[2], %0[3]
#define Arr6<%0>				%0[0], %0[1], %0[2], %0[3], %0[4], %0[5]
#define Arr9<%0>                %0[0], %0[1], %0[2], %0[3], %0[4], %0[5], %0[6], %0[7], %0[8]
#define Public:%0(%1)			forward %0(%1); public %0(%1)
#define diff(%0,%1)				((%0>%1) ? (%0-%1) : (%1-%0))

//	Functions
#define PreloadAnimLib(%1,%2)					ApplyAnimation(%1,%2,"null",0.0,0,0,0,0,0)  //
#define SendFormatMessage(%0,%1,%2,%3,%4)		format(%2,sizeof %2,%3,%4), SendClientMessage(%0,%1,%2)				//	SendFormatMessage(playerid, color, var, string, format)
#define SendFormatMessageToAll(%0,%1,%2,%3)		format(%1,sizeof %1,%2,%3), MySendClientMessageToAll(%0,%1)			//	SendFormatMessageToAll(color, var, string, format)
#define CensoreFormatMessageToAll(%0,%1,%2,%3)	format(%1,sizeof %1,%2,%3), MySendClientMessageToAll(%0,%1,true)	//	CensoreFormatMessageToAll(color, var, string, format)
#define RemovePlayerWorldBounds(%0)				SetPlayerWorldBounds(%0, 20000.0, -20000.0, 20000.0, -20000.0)
#define mysql_query_ex(%0)  					mysql_query(g_SQL, %0, false)
#define unixtime()								gettime(_, _, _)
#define SuccesAnim(%0)							ApplyAnimation(%0, "CRIB", "PED_Console_Win", 4.1, 0, 0, 0, 0, 2500, 1)
#define LoseAnim(%0)							ApplyAnimation(%0, "OTB", "wtchrace_lose", 4.1, 0, 0, 0, 0, 0, 1)
#define IsNull(%0) 								((!(%0[0])) || (((%0[0]) == '\1') && (!(%0[1]))))

#define CopList_ADD(%0)						Iter_Add(Cop, %0)
#define CopList_REMOVE(%0)					Iter_Remove(Cop, %0)
#define IsPoliceDuty(%0)    				Iter_Contains(Cop, %0)  //  Optimize
#define GetPlayerWantedLevel(%0)			PlayerInfo[%0][pWantedLvl]
#define InRace[%0]    						Iter_Contains(Racer, %0)  //  Optimize
#define InPaint[%0]	    					Iter_Contains(Painter, %0)  //  Optimize
#define IsPlayerDead(%0)                    (GetPlayerState(%0) == PLAYER_STATE_WASTED ? true : false)
#define IsPlayerLive(%0)                    (PLAYER_STATE_ONFOOT <= GetPlayerState(%0) <= PLAYER_STATE_ENTER_VEHICLE_PASSENGER)
#define MyGetPlayerMoney(%0)				PlayerInfo[%0][pMoney]
#define CriminalMarked[%0]					IsValidDynamicMapIcon(CriminalMarkers[%0])
#define MyGetPlayerDialog(%0)				Dialogid[%0]
#define GetPlayerComb(%0)					CombSource[%0]
#define GetPlayerRank(%0) 					GetRankName(PlayerInfo[%0][pFaction], PlayerInfo[%0][pRank])
#define NextLvlExp(%0)                      (LEVEL_EXP * (%0 - 1))
#define getNextLevelExp(%0)                 NextLvlExp(PlayerInfo[%0][pLevel] + 1)         
#define GetPlayerAdminStatus(%0) 			getAdminStatus(PlayerInfo[%0][pAdmin])   

//  Keys
#if !defined KEY_AIM
	#define KEY_AIM 							KEY_HANDBRAKE
#endif
#define HOLDING(%0)							((newkeys & (%0)) == (%0))
#define PRESSED(%0)							(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0)						(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

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

//  PVArs
stock AddPVarFloat(playerid, var[], Float:val)
{
    return SetPVarFloat(playerid, var, GetPVarFloat(playerid, var) + val);
} 

//  Получить строку с именем игрока
stock ReturnPlayerName(playerid)
{
    new playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
    return playername;
}

stock ReturnWeaponName(weaponid)
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

Float: floatdif(Float:oper1, Float:oper2)
{   // Только для положительных углов
    return floatabs((floatround(oper1-oper2+180.0)%360)-180.0);
}

//  Вхождение одной точки в другую с некоторым радиусом
stock cmatch(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2, Float:size)
{
    if(floatabs(x1 - x2) > size || floatabs(y1 - y2) > size || floatabs(z1 - z2) > size) return 0;
    return 1;
}

//  Очистка чата
ClearChatbox(playerid, lines)
{
    for(new i = 0; i < lines; i++)
        SendClientMessage(playerid, -1, " ");
    return true;
}

//  Функции получения различных дистанций
Float:GetDistanceBetweenPlayers(player1, player2, ignore_z = false)
{
    new Float:x1, Float:y1, Float:z1;
    GetPlayerPos(player1, x1, y1, z1);
    new Float:x2, Float:y2, Float:z2;
    GetPlayerPos(player2, x2, y2, z2);
    if(ignore_z) z2 = z1;
    return floatsqroot((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1));
}

Float:GetDistanceFromMeToPoint(playerid, Float:x2, Float:y2, Float:z2 = 0.0)
{
    new Float:x1, Float:y1, Float:z1;
    GetPlayerPos(playerid, x1, y1, z1);
    if(z2 == 0.0) z2 = z1;
    return floatsqroot((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1));
}

Float:GetSquareDistance(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    x1 -= x2;   y1 -= y2;   z1 -= z2;
    x1 *= x1;   y1 *= y1;   z1 *= z1;
    return (x1 + y1 + z1);
}

Float:GetDistanceFromPointToPoint(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2 = 0.0)
{
    if(z2 == 0.0)   z2 = z1;
    return floatsqroot((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1));
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