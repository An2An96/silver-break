COMMAND:frisk(playerid, params[])
{
	extract params -> new player:giveplayerid; else
		return SendClientMessage(playerid, COLOR_WHITE, "�����������: /frisk [playerid/playername]");

	if(playerid == giveplayerid)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ �������� ������ ����.");
	}
	if(GetDistanceBetweenPlayers(playerid, giveplayerid) > 5.0)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������� ������ �� ���.");
	}
	if(IsGover(PlayerInfo[giveplayerid][pFaction]))
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ �������� ���.���������.");
	}
	if(PlayerInfo[giveplayerid][pNextFriskTime] > gettime())
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� ������ ������� ����������.");
	}
	if(PursuitStatus[giveplayerid] == PS_NONE)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "��� ������ �� ������ ��������� ��������� ������.");
	}
	if(PursuitStatus[giveplayerid] == PS_WAIT || PursuitStatus[giveplayerid] == PS_OUT_COMPLETE)
	{
		new string[128];
		PlayerInfo[giveplayerid][pNextFriskTime] = gettime() + (60 * 5);
		format(string, sizeof(string), "���������� %s'�.", ReturnPlayerName(giveplayerid));
		PlayerAction(playerid, string);

		mysql_format(g_SQL, string, sizeof(string), "SELECT `thing`, `count` FROM `inventory` WHERE `source` = '%d' AND `source_type` = '%d'", PlayerInfo[giveplayerid][pUserID], _:TAB_INVENTORY);
		new Cache:result = mysql_query(g_SQL, string);
		new thing, cnt, count, wcount;
		for(new i = 0; i < cache_num_rows(); i++)
		{
			cache_get_value_name_int(i, "thing", thing);
			if(GetThingLegally(thing) == 0)
			{
				cache_get_value_name_int(i, "count", cnt);
				if(count)	format(string, sizeof(string), "%s, %s (%d ��.)", string, GetThingName(thing), cnt);
				else 		format(string, sizeof(string), "%s (%d ��.)", GetThingName(thing), cnt);
				count++;
			}
		}
		cache_delete(result);
		//	������
		if(PlayerInfo[giveplayerid][pGunLic] == 0)
		{
			for(new s = 2; s < 13; s++)
			{
				if(!MyGetPlayerWeaponID(giveplayerid, s) || 9 <= s <= 11) continue;
				if(count || wcount)	format(string, sizeof(string), "%s, %s", string, ReturnWeaponName(MyGetPlayerWeaponID(giveplayerid, s)));
				else 				format(string, sizeof(string), "%s", ReturnWeaponName(MyGetPlayerWeaponID(giveplayerid, s)));
				wcount++;
			}
		}
		if(count || wcount)
		{
			SendFormatMessage(playerid, COLOR_DBLUE, string, "����������� ���� %s'�: {FFFFFF}%s", ReturnPlayerName(giveplayerid), string);
			if(count)
			{
				CrimePlayer(giveplayerid, CRIME_THINGS);
			}
			if(wcount)
			{
				CrimePlayer(giveplayerid, CRIME_HAVE_GUN);
			}
			if(PM_Type[playerid] == 10 && PM_Place[playerid] == giveplayerid)
			{
				PursuitIllegalItem[giveplayerid] = true;
				ShowDialog(playerid, DMODE_REACTION);
			}
		}
		else
		{
			if(PM_Type[playerid] == 10 && PM_Place[playerid] == giveplayerid)
			{
				if(GetPlayerWantedLevel(giveplayerid) == 0)
				{
					CancelPlayerPursuit(giveplayerid, 1);
				}
			}
			SendFormatMessage(giveplayerid, COLOR_DBLUE, string, "%s %s ������� ��� � ������ �� �����", GetPlayerRank(playerid), ReturnPlayerName(playerid));
			SendFormatMessage(playerid, COLOR_DBLUE, string, "�� �������� %s: ������ ������������ �� �������", ReturnPlayerName(giveplayerid));
		}
	}
	else
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ������ ������ ����� ����������.");
	}
	return true;
}

COMMAND:wanted(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] != F_POLICE)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��� �������.");
	}
	if(GetPlayerState(playerid) != 2 || IsCopCar(GetPlayerVehicleID(playerid)) == 0)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ ������������ ��� ������� ������ �� ����� ����������� ������.");
	}
	new string[1024] = "{FFFFFF}", count;
	foreach(Player, i)
	{
		if(GetPlayerWantedLevel(i) == 0)	continue;
		format(string, sizeof(string), "%s%s[%d] - %d ��. �������\n", string, ReturnPlayerName(i), i, GetPlayerWantedLevel(i));
		count++;
	}
	if(count == 0)	format(string, sizeof(string), "%s������ ������������� ����.", string);
	MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, "������ �������������", string, "�������", "");
	return true;
}

COMMAND:spike(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction] != F_POLICE)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������ ������������ ��� �������.");
	}
	if(GetPVarInt(playerid, "Police:Spikes"))	callcmd::dspike(playerid, "");
	if(MyApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0))
	{
		SetPVarInt(playerid, "Police:Spikes:Timer", SetTimerEx("SetPlayerSpike", 2000, false, "d", playerid));
	}
	return true;
}

COMMAND:dspike(playerid, params[])
{
	if(GetPVarInt(playerid, "Police:Spikes") == 0)
	{
		return SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� �� ������������� �����.");
	}
	if(GetPVarInt(playerid, "Police:Spikes:Timer"))
	{
		KillTimer(GetPVarInt(playerid, "Police:Spikes:Timer"));
		DeletePVar(playerid, "Police:Spikes:Timer");
	}
	GameTextForPlayer(playerid, "~w~Spikes ~r~removed", 3000, 3);
	DestroyDynamicObject(GetPVarInt(playerid, "Police:Spikes"));
	DeletePVar(playerid, "Police:Spikes");
	return true;
}