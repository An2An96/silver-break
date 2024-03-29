#if !defined _job_core_included
	#endinput
#endif

#if defined	_job_job_taxi_included
	#endinput
#endif
#define _job_job_taxi_included

new TaxiCall = -1, TaxiCallTime,    // ����� ����� (playerid, time)
	TaxiDuty[MAX_PLAYERS],			// ������ ��������� (0 - �� ��������, 1 - �� ���������, 2 - ������ �� �������, 3 - � ��������)
	TaxiVeh[MAX_PLAYERS],			// ���������� ����� �����
	TaxiRate[MAX_PLAYERS],			// �������� ������
	TaxiClientid[MAX_PLAYERS],		// ������������� �������
	TaxiMoney[MAX_PLAYERS],			// ������������ ������
	bool:UseTaxi[MAX_PLAYERS],      // ������ ��������� �����
	Float:TaxiDist[MAX_PLAYERS],    // ���������� ��������� ���������
	TaxiDriverid[MAX_PLAYERS],		// ������������� ��������
	TaxiMapIcon[MAX_PLAYERS];       // ���-������ ��� �������� � ���������

Public: Taxi_OnPlayerClickY(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(Job.GetPlayerNowWork(playerid) == JOB_TAXI && CarInfo[vehicleid][cType] == C_TYPE_JOB && CarInfo[vehicleid][cOwnerID] == JOB_TAXI)
    {
        Taxi_AcceptCall(playerid);
        return true;
    }
	return CONTINUE;
}

Public: Taxi_OnPlayerClickSubmission(playerid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) // KEY_2
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(CarInfo[vehicleid][cType] == C_TYPE_JOB)
		{
			if(CarInfo[vehicleid][cOwnerID] == JOB_TAXI)
			{
			 	if(Job.GetPlayerNowWork(playerid) == JOB_TAXI)
			    {
			    	Job.ClearPlayerNowWork(playerid);
				}
				else
				{
					Dialog_Show(playerid, Dialog:Taxi_Duty);
				}
				return true;
			}
		}
	}
	return CONTINUE;
}

Public: Taxi_OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_ONFOOT)
	{
		if(oldstate == PLAYER_STATE_DRIVER)
		{
			if(Job.GetPlayerNowWork(playerid) == JOB_TAXI)
			{
				Job.ClearPlayerNowWork(playerid);
			}
		}
		CancelUseTaxi(playerid);
	}
	else if(newstate == PLAYER_STATE_PASSENGER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		new driverid = VehInfo[vehicleid][vDriver];
		if(Job.GetPlayerNowWork(driverid) == JOB_TAXI)
		{
			if(TaxiDuty[driverid] != 3 || (TaxiClientid[driverid] != INVALID_PLAYER_ID && TaxiClientid[driverid] != playerid))
			{
			    if(MyGetPlayerMoney(playerid) <= 0)
			    {
			        SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "� ��� ��� ����� �� �����.");
				    return RemovePlayerFromVehicle(playerid);
			    }
			    TaxiDuty[driverid] = 3;
			    TaxiClientid[driverid] = INVALID_PLAYER_ID;
				UseTaxi[playerid] = true;
				TaxiDist[playerid] = 0.0;
				TaxiRate[playerid] = TaxiRate[driverid];
				TaxiDriverid[playerid] = driverid;
			}
		}
	}
	return CONTINUE;
}

stock Taxi_StartWork(playerid)
{
	new const rate = TaxiRate[playerid];
	new vehicleid = GetPlayerVehicleID(playerid);
	new string[128];
	format(string, sizeof(string), "{FFFFFF}�����: {FFFF00}%d$ �� ��", rate);
	VehInfo[vehicleid][vLabel] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, 0.0, 0.0, 1.25, 25.0, INVALID_PLAYER_ID, vehicleid, 1);
	SetPVarInt(playerid, "Taxi:Objectid", CreateDynamicObject(19308, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
	AttachDynamicObjectToVehicle(GetPVarInt(playerid, "Taxi:Objectid"), vehicleid, -0.0, -0.4, GetVehicleModel(vehicleid) == 404 ? 1.05 : 0.95, 0, 0, 0);
	Streamer_Update(playerid);
    TaxiVeh[playerid] = vehicleid;
	TaxiRate[playerid] = rate;
	TaxiMoney[playerid] = 0;
	UpdatePlayerColor(playerid);
	format(string, sizeof(string), "[������]: ������� {FFFFFF}%s[%d]{F5DEB3} ����� �� ���������, �����: %d$ {FFFFFF}(/call 555)", ReturnPlayerName(playerid), playerid, rate);
	MySendClientMessageToAll(COLOR_YELLOW2, string);

	//
	TaxiDuty[playerid] = 1;
    foreach(LoginPlayer, i)
    {   // ���������� �������� �� ������, ����� �� ����� ���������
        if(IsPlayerInVehicle(i, vehicleid) && i != playerid)
        {
            RemovePlayerFromVehicle(i);
        }
    }

    // ���� �������� � ������
    /*new bool:founded = false;
    foreach(LoginPlayer, i)
    {
        if(IsPlayerInVehicle(i, vehicleid) && i != playerid)
        {
            RemovePlayerFromVehicle(i);
            founded = true;
			TaxiDuty[playerid] = 3;

			UseTaxi[i] = true;
			TaxiDist[i] = 0.0;
			TaxiRate[i] = TaxiRate[playerid];
			TaxiDriverid[i] = playerid;
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "������ �� ������ ������: {FFFFFF}%s", ReturnPlayerName(i));
			SendClientMessage(i, COLOR_LIGHTBLUE, "������ �� ������ ������� ��!");
			break;
        }
    }
    if(founded == false)
    {
	    TaxiDuty[playerid] = 1;
    }*/
    return true;
}

stock Taxi_FinishWork(playerid)
{
	if(TaxiDuty[playerid])
	{
		new string[128], vehicleid = TaxiVeh[playerid];
		DestroyDynamic3DTextLabel(VehInfo[vehicleid][vLabel]), VehInfo[vehicleid][vLabel] = Text3D:INVALID_STREAMER_ID;
		HideMissionMessage(playerid);
		TaxiDuty[playerid] = 0;
		UpdatePlayerColor(playerid);
		DestroyDynamicObject(GetPVarInt(playerid, "Taxi:Objectid"));

		// �������� ������ ������
		if(IsPlayerLogged(TaxiClientid[playerid]))
		{
		    new clientid = TaxiClientid[playerid];
		    DestroyDynamicMapIcon(TaxiMapIcon[playerid]), TaxiMapIcon[playerid] = INVALID_STREAMER_ID;
		    DestroyDynamicMapIcon(TaxiMapIcon[clientid]), TaxiMapIcon[clientid] = INVALID_STREAMER_ID;
			SendFormatMessage(TaxiClientid[playerid], COLOR_LIGHTBLUE, string, "������� %s �������� ���������. �������� ����� ��� ���!", ReturnPlayerName(playerid));
		}

		// ����� ����������
	    foreach(LoginPlayer, i)
	    {
	        if(UseTaxi[i] == true && IsPlayerInVehicle(i, vehicleid))
	        {
	            CancelUseTaxi(i);
	        }
	    }
	    HideMissionMessage(playerid);

	    Job.GivePlayerWage(playerid, CalcWage(TaxiMoney[playerid], PlayerInfo[playerid][pTaxiLevel]));

		SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "�� ��������� ��������� � ����������: {FFFFFF}%d$", TaxiMoney[playerid]);
	    TaxiMoney[playerid] = 0;
	    TaxiVeh[playerid] = 0;
		TaxiClientid[playerid] = INVALID_PLAYER_ID;
	}
    return true;
}

stock Taxi_SetRate(playerid, rate)
{
	TaxiRate[playerid] = rate;
}

stock Taxi_PlayerUsed(playerid)
{
	return UseTaxi[playerid];
}

stock CancelUseTaxi(playerid)
{
	if(UseTaxi[playerid])
	{
		new string[128],
			driverid = TaxiDriverid[playerid],
	    	money = floatround(TaxiDist[playerid] * TaxiRate[playerid] / 1000),
	    	vehicleid = GetPlayerVehicleID(driverid);

	    GiveTaxiSkill(driverid, money);
	    MyGivePlayerMoney(playerid, -money);
	    TaxiMoney[driverid] += money;
		SendFormatMessage(driverid, COLOR_LIGHTBLUE, string, "������ {FFFFFF}%s{44B2FF} ������� �����. ����������: {FFFFFF}%d$", ReturnPlayerName(playerid), money);

	    HideMissionMessage(playerid);
	    UseTaxi[playerid] = false;
	    TaxiDist[playerid] = 0.0;
	    TaxiRate[playerid] = 0;
	    TaxiDriverid[playerid] = -1;

	    // ���� ������ �������� � ������
	    if(IsPlayerLogged(driverid) && TaxiDuty[driverid] > 0)
	    {
		    new bool:founded = false;
		    foreach(LoginPlayer, i)
		    {
		        if(IsPlayerInVehicle(i, vehicleid) && i != driverid && i != playerid)
		        {
		            founded = true;
					UseTaxi[i] = true;
					TaxiDist[i] = 0.0;
					TaxiRate[i] = TaxiRate[driverid];
					TaxiDriverid[i] = driverid;
					SendFormatMessage(driverid, COLOR_LIGHTBLUE, string, "������ �� ������ ������: {FFFFFF}%s", ReturnPlayerName(i));
					SendClientMessage(i, COLOR_LIGHTBLUE, "������ �� ������ ������� ��!");
					break;
		        }
		    }
		    if(founded == false)
		    {
			    TaxiDuty[driverid] = 1;
			    HideMissionMessage(driverid);
		    }
	    }
	}
	return true;
}	

Taxi_AcceptCall(playerid)
{
 	if(TaxiDuty[playerid] == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "������� �� ���������, ����� ��������� �����.");
    }
    if(TaxiCall == (-1))
    {
        return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "�� ��������� ������ ����� �� ��������� � �����.");
    }
    if(TaxiDuty[playerid] >= 2 || TaxiClientid[playerid] != INVALID_PLAYER_ID)
    {
        return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "�� ��� ������� �����, ������� �� ������ ����� �������.");
    }
    new string[128];
	format(string, 128, "* ������� {FFFFFF}%s[%d]{44B2FF} ������ ����� ������� %s", ReturnPlayerName(playerid), playerid, ReturnPlayerName(TaxiCall));
	SendJobMessage(JOB_TAXI, COLOR_LIGHTBLUE, string);
    format(string, 128, "~n~~n~~n~������ ~y~%s~w~ ������� ���.", ReturnPlayerName(TaxiCall));
    SendMissionMessage(playerid, string, 0);

	SendFormatMessage(TaxiCall, COLOR_LIGHTBLUE, string, "������� {FFFFFF}%s{44B2FF} ������ ��� �����. ����������� �� �����!", ReturnPlayerName(playerid));
    format(string, 128, "~n~~n~~n~������� ~y~%s~w~ ������ ��� �����.", ReturnPlayerName(playerid));
	SendMissionMessage(TaxiCall, string);

	TaxiClientid[playerid] = TaxiCall;
    TaxiCall = -1; 
    TaxiCallTime = 0;
    return true;
}

Taxi_PlayerEverySecondTimer(playerid, Float:dist)
{
	new i = playerid;
	new string[128];
	if(Taxi_PlayerUsed(i) && dist < 110.0)
	{
	    new cost = floatround(TaxiDist[i] * TaxiRate[i] / 1000);
		TaxiDist[i] += dist;
		format(string, 128, "~y~���������: ~w~%.1f ��~n~~y~���������: ~w~$%d", TaxiDist[i] / 1000, cost);
		SendMissionMessage(i, string, 0);
		SendMissionMessage(TaxiDriverid[i], string, 0);

		// ����������� ������
		if(MyGetPlayerMoney(i) <= cost)
		{
			TogglePlayerControllable(TaxiDriverid[i], false);
			SetTimerEx("MyUnfreezePlayer", 2000, false, "i", TaxiDriverid[i]);
			RemovePlayerFromVehicle(i);
			SendClientMessage(i, COLOR_WHITE, PREFIX_ERROR "� ��� ����������� ������ �� �����.");
		}
	}

	if(TaxiDuty[i] > 0 && TaxiClientid[i] != INVALID_PLAYER_ID)
	{// ���������� ������� �������� � �������
	    new clientid = TaxiClientid[i];
	    DestroyDynamicMapIcon(TaxiMapIcon[i]), TaxiMapIcon[i] = INVALID_STREAMER_ID;
	    DestroyDynamicMapIcon(TaxiMapIcon[clientid]), TaxiMapIcon[clientid] = INVALID_STREAMER_ID;
	    if(IsPlayerLogged(clientid) == 0)
	    {
	    	TaxiClientid[i] = INVALID_PLAYER_ID;
	    	SendClientMessage(i, COLOR_LIGHTRED, "��� ������ ����� � �������, ����� �������!");
	    }
	    else if(TaxiDuty[i] < 2)
	    {
			if(GetDistanceBetweenPlayers(i, TaxiClientid[i]) > 10.0)
			{
			    new Float:pos[4], Float:ClientPos[3];
			    GetPlayerPos(clientid, Arr3<ClientPos>);
			    MyGetPlayerPos(i, Arr4<pos>);
				TaxiMapIcon[i] = CreateDynamicMapIcon(Arr3<ClientPos>, 56, 0, -1, -1, i, 20000.0, MAPICON_GLOBAL);
				TaxiMapIcon[clientid] = CreateDynamicMapIcon(Arr3<pos>, 56, 0, -1, -1, clientid, 20000.0, MAPICON_GLOBAL);
				Streamer_Update(i, STREAMER_TYPE_MAP_ICON);
				Streamer_Update(clientid, STREAMER_TYPE_MAP_ICON);
			}
			else
			{
			    TaxiDuty[i] = 2;
			    SendMissionMessage(i, "~n~~n~~n~�� ��������� �� �������.");
			}
		}
	}
	return true;
}

Taxi_EverySecondTimer()
{
	// �������� �����
	if(TaxiCall != -1 && TaxiCallTime > 0)
	{
		if(--TaxiCallTime <= 0)
		{
		    SendMissionMessage(TaxiCall, "~n~~n~~n~~r~�� ��������� ������, ���������� �����.");
		    TaxiCall = -1; TaxiCallTime = 0;
		}
		else
		{
			new string[64];
		    format(string, 128, "~n~~n~~n~�� ������� �����, ��������: ~y~%d ���", TaxiCallTime);
		    SendMissionMessage(TaxiCall, string, 0);
		}
	}
}

stock GetTaxiSkill(playerid)
{
	if(1 <= PlayerInfo[playerid][pTaxiLevel] < 5)
	    return PlayerInfo[playerid][pTaxiLevel] * 2000;
	return -1;
}

stock GiveTaxiSkill(playerid, skill = 1)
{
	if(0 <= PlayerInfo[playerid][pTaxiLevel] < 5)
	{
		if(PlayerInfo[playerid][pTaxiLevel] == 0)	PlayerInfo[playerid][pTaxiLevel] = 1;

	    new string[128], next = GetTaxiSkill(playerid);
		PlayerInfo[playerid][pTaxiSkill] += skill;
		if(PlayerInfo[playerid][pTaxiSkill] >= next)
		{
			PlayerInfo[playerid][pTaxiLevel]++;
			PlayerInfo[playerid][pTaxiSkill] -= next;
			next = GetTaxiSkill(playerid);

			format(string, 128, "~g~�������~n~~w~+ ����� � ��������: ~y~%d%s", getWageBonus(PlayerInfo[playerid][pTaxiLevel]), "%%");
			ShowPlayerHint(playerid, string);
		}
		else if(PlayerInfo[playerid][pTaxiSkill] % 200 == 0)
		{
			format(string, 128, "������� [Y������: %d]", PlayerInfo[playerid][pTaxiLevel]);
			IFace.RepBarShow(playerid, string, PlayerInfo[playerid][pTaxiSkill] - 1, PlayerInfo[playerid][pTaxiSkill], next);
		}
	}
}

//////////	Dialogs 	///////////
DialogCreate:Taxi_Duty(playerid)
{
	Dialog_Open(playerid, Dialog:Taxi_Duty, DIALOG_STYLE_INPUT, "{FFFF00}������� ��������", "\n{FFFFFF}������� ����� (�� 1$ �� 20$ �� ��):\n", "������", "�������");
	return true;
}

DialogResponse:Taxi_Duty(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new const rate = strval(inputtext);
		if(!(0 < strlen(inputtext) < 10) || rate <= 0)
        {
            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
            return Dialog_Show(playerid, Dialog:Taxi_Duty);
        }
		if(rate > 20 || rate < 1)
		{
			return Dialog_Show(playerid, Dialog:Taxi_Duty);
		}
		new vehicleid = GetPlayerVehicleID(playerid);
		if(!vehicleid)	return true;

		Taxi_SetRate(playerid, rate);
		Job.SetPlayerNowWork(playerid, JOB_TAXI);
	}
	return true;
}