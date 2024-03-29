#if !defined _job_core_included
	#endinput
#endif

#if defined	_job_job_trucker_included
	#endinput
#endif
#define _job_job_trucker_included

// ������� �������� ��������� ���������
new const Float:TrailerPos[][] =
{
	// ������������ ����
	{2236.6501, -2246.8835, 14.0895, 45.0},
	{2229.0872, -2254.4875, 14.0895, 45.0},
	{2221.6260, -2261.8406, 14.0895, 45.0},
	{2214.2703, -2269.1533, 14.0895, 45.0},
	{2206.8071, -2276.5317, 14.0895, 45.0},
	// ���� � ����� ��
	{2783.7000, -2418.0000, 14.0895, 90.0},
	{2783.7000, -2456.1431, 14.0895, 90.0},
	{2783.7000, -2494.1501, 14.0895, 90.0},
	// ����������� ���� ����� � ��
	{-520.4276, -501.7234, 25.4529, 0.0},
	{-529.7214, -501.7234, 25.4662, 0.0},
	{-557.6224, -501.7234, 25.4748, 0.0},
	// ��������� ���� �� ������ �� ��
	{-66.4882, -1119.9561, 1.7149, 69.0},
	{-63.1870, -1110.8597, 1.7149, 69.0},
	// ���� ����� ����������� �����
	{-144.5922, -321.2000, 2.1353, 180.0},
	{-130.6473, -321.2000, 2.1353, 180.0},
	{-116.7739, -321.2000, 2.1353, 180.0}
};
new TrailerPosStatus[sizeof(TrailerPos)];		// 0 ��� ��������, 1 ��������� �������, 2 ������� ��������
new TrailerPosVeh[sizeof(TrailerPos)];			// ���������� ����� ���������� ���������� (��������)
new TrailerPosTime[sizeof(TrailerPos)];			// ���������� ����� (���)
new TrailerPosPoint[sizeof(TrailerPos)];		// ����� ���������� �� ������� TruckPoint
new Text3D:TrailerPosText[sizeof(TrailerPos)];	// 3� ����� ����� ����� ��������� ���������

enum TPOINT_ENUM
{
	TPOINT_NAME[20],    // �������� �����
	TPOINT_MOD,  		// ������ ������� (435 ��������, 450 �����, 584 ����, 591 ������������)
	Float:TPOINT_X,     // ������� ��������
	Float:TPOINT_Y,     //
	Float:TPOINT_Z,		//
};

new const Float:TruckPoint[][TPOINT_ENUM] =
{
	// ��������
	{"��������", 435, -2442.4021,738.7883,35.0156}, // Market San Fierro
	{"��������", 435, 1118.7349,-1515.3392,15.7969}, // Market Los Santos
	{"��������", 435, -1917.5388,281.9348,41.0469}, // San Fierro
	{"��������", 435, 1240.1866,184.7321,19.5547},
	{"��������", 435, 1043.2793,-1031.4860,32.0588}, // Los Santos Transfender (��������)
	{"������� �������", 435, -2130.6016,-101.6377,35.3203}, // Market Los Santos
	{"������� �������", 435, 1138.5975,-1513.7479,15.7969}, // San Fierro (����� ����� ���������)
	// ��������
	{"����� ���������", 450, -2262.2004,2319.8711,4.8125}, // Bayside Marina
	{"����� ���������", 450, -2004.6505,-2414.6147,30.6250}, // Angle Pine
	{"����� ���������", 450, -2098.3740,208.4009,35.3085}, // San Fierro
	{"����� ���������", 450, 1274.8480,-1276.1560,13.3676}, // Los Santos (����� ����������)
	// ��������
	{"�����", 584, -1014.4851,-687.5897,32.0078},
	{"�����", 584, 243.2842,1421.6818,10.5859},
	{"������", 584, 652.8531,-564.8312,16.3359}, // Dillimore (�������� ����� ����������� ��� �������)
	{"������", 584, -1881.4547,-1687.0876,21.7453} // Whetstone (������)
	// ������� � ����
};

new TruckerStatus[MAX_PLAYERS],     // ������ ������ (0 - �� ��������, 1 - ��������, 2 - ������� �����, 3 - ������� ������)
	TruckerVeh[MAX_PLAYERS],    	// ���������� ����� ������
	TruckerTrailer[MAX_PLAYERS],    // ���������� ����� ��������
	TruckerPos[MAX_PLAYERS],    	// ���������� ����� ������� ��������
	TruckerPoint[MAX_PLAYERS],      // ����� ���������� (����: TruckPoint[])
	Float:TruckerDist[MAX_PLAYERS],	// ��������� �� ����� ����������
	Float:TruckerDmg[MAX_PLAYERS],	// ������� ����� �����
	TruckerTick[MAX_PLAYERS],		// ������� ������� �����
	TruckerLeave[MAX_PLAYERS];      // ������� ������� ��� ������ ������ ��� �������

Public: Trucker_OnGameModeInit()
{
	// ������ ��������������. ������
	/*new car1 = MyCreateVehicle(515, 2189.4700, -2225.8853, 15.0, 225.0, 41, 0);
	MyCreateVehicle(515, 2197.0559, -2218.5869, 15.0, 225.0, 41, 0);
	MyCreateVehicle(515, 2211.9038, -2203.7253, 15.0, 225.0, 41, 0);
	MyCreateVehicle(515, 2204.0105, -2211.6504, 15.0, 225.0, 41, 0);
	new car2 = MyCreateVehicle(515, 2182.5, -2232.92, 14.5, 225.0, 41, 0);
	for(new x = car1; x <= car2; x++)
	{
	    CarInfo[x][cType] = C_TYPE_JOB;
	    CarInfo[x][cOwnerID] = JOB_TRUCKER;
	    VehInfo[x][vRentPrice] = 75;
	    SetVehicleNumberPlate(x, "TRUCKER");
	}*/

	// ����� ��� ��������
    for(new i; i < sizeof(TrailerPos); i++)
    {
		if(TrailerPosStatus[i] == 0)
            TrailerPosText[i] = CreateDynamic3DTextLabel("����� ��� �������\n{FFFFFF}��������", 0xFFFF00FF, TrailerPos[i][0], TrailerPos[i][1], TrailerPos[i][2]+1.5, 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	}

	return CONTINUE;
}

Public: OnVehicleAttachTrailer(vehicleid, trailerid)
{
	new playerid = VehInfo[vehicleid][vDriver];
	if(!IsPlayerLogged(VehInfo[vehicleid][vDriver])) return 1;

	// ������ �������������
    if(TruckerStatus[playerid] == 3 && trailerid == TruckerTrailer[playerid])
    {// ������ ���������� �������
        TruckerStatus[playerid] = 1;
        TruckerLeave[playerid] = 0;
        HideMissionMessage(playerid);
        return 1;
    }
	for(new i; i < sizeof(TrailerPos); i++)
	{// �������� ������� �� ������
	    if(trailerid == TrailerPosVeh[i])
	    {
	        if(Job.GetPlayerJob(VehInfo[vehicleid][vDriver]) == JOB_TRUCKER)
	        {
	            TruckerPos[VehInfo[vehicleid][vDriver]] = i;
		        Dialog_Show(VehInfo[vehicleid][vDriver], Dialog:Trucker_TrailerMenu);
		    }
	        break;
	    }
	}
	return 1;
}

Public: OnVehicleDetachTrailer(vehicleid, oldtrailerid)
{
	new playerid = VehInfo[vehicleid][vDriver];
	if(!IsPlayerLogged(VehInfo[vehicleid][vDriver])) return 1;

	// ������ �������������
    if(TruckerStatus[playerid] == 1)
    {// ������� �������
        TruckerStatus[playerid] = 3;
        TruckerLeave[playerid] = 90;
    }
    return 1;
}

////////////////////////////////////////
stock Trucker_FinishWork(playerid, reason = Job.REASON_COMPLETE)
{
	if(TruckerStatus[playerid] > 0)
	{
		if(reason != Job.REASON_COMPLETE)  
		{
	        GameTextForPlayer(playerid, "~r~Mission Failed", 3000, 4);
	 		PlayerPlaySound(playerid, 36200, 0.0, 0.0, 0.0);
		}
	    MyDestroyVehicle(TruckerTrailer[playerid]);
	    MyDisablePlayerCheckpoint(playerid);
	    HideMissionMessage(playerid);

		TruckerStatus[playerid] = 0;
		TruckerVeh[playerid] = 0;
	    TruckerTrailer[playerid] = 0;
		TruckerPoint[playerid] = 0;
		TruckerLeave[playerid] = 0;
	}
	return true;
}

Trucker_Complete(playerid)
{
	if(TruckerStatus[playerid] > 0)
	{
        new lstring[1024], bonus1, bonus2,
            point = TruckerPoint[playerid],
			time = floatround((GetTickCount() - TruckerTick[playerid]) / 1000),
			price = floatround(TruckerDist[playerid] / 25),
			quart = floatround(price / 8),
			Float:speed = 3.6 * TruckerDist[playerid] / time; // km/h

		// ����� �� ��������
		if(speed > 40.0)
		{
		    if(speed > 100.0) speed = 100.0;                        // ������������� ��������
			bonus1 = floatround((speed - 40.0) / 60.0);             // ������ ���������� ���� ������ {0,..,1}
			bonus1 = floatround(bonus1 * quart);                    // ��������� ���������� ���� ������ �� ������������ ���� (12,5%)
		}

		// ����� �� �����������
		if(TruckerDmg[playerid] <= 350.0)
		{
			bonus2 = floatround(1 - (TruckerDmg[playerid] / 350));  // ������ ���������� ���� ������ {0,..,1}
			bonus2 = floatround(bonus2 * quart);                    // ��������� ���������� ���� ������ �� ������������ ���� (12,5%)
		}

		//price += bonus1 + bonus2;
		price += CalcWage(price, PlayerInfo[playerid][pTruckLevel]);
	    Job.GivePlayerWage(playerid, price + bonus1 + bonus2);

        format(lstring, sizeof(lstring),
			"{FFFFFF}����:\t\t\t\t\t{B1C8FB}%s\n\
			{FFFFFF}����������:\t\t\t\t{B1C8FB}%s\n\
			{FFFFFF}����� ��������:\t\t\t{B1C8FB}%02d:%02d\n\
			{FFFFFF}���������:\t\t\t\t{B1C8FB}%.1f m.\n\
			\n\
			{FFFFFF}���������:\t\t\t\t{B1C8FB}%d$\n\
			{FFFFFF}����� �� �����:\t\t\t{B1C8FB}%d/%d$\n\
			{FFFFFF}����� �� �����������:\t\t{B1C8FB}%d/%d$\n\
			______________________________________________\n\
			{B1C8FB}�����:\t\t\t\t\t+%d$",
			TruckPoint[point][TPOINT_NAME],
			GetPointArea(TruckPoint[point][TPOINT_X], TruckPoint[point][TPOINT_X]),
			time/60, time%60,
			TruckerDist[playerid],
			price,
			bonus1, quart,
			bonus2, quart,
			price + bonus1 + bonus2);
        Dialog_Message(playerid, "{FFFF00}\t���� ��������� �� ����� ����������!", lstring, "�������", 0);

		TogglePlayerControllable(playerid, false);
		SetTimerEx("MyUnfreezePlayer", 1000, false, "i", playerid);

	    PlayAudioStreamForPlayer(playerid, AUDIOFILE_PATH "/complete.mp3");
		
		GiveTruckSkill(playerid);
		Trucker_FinishWork(playerid);
   	}
}

Trucker_TrailersTimer()
{
	for(new tid; tid < sizeof(TrailerPos); tid++)
	{
	    if(TrailerPosStatus[tid] > 0 && TrailerPosTime[tid] > 0)
	    {// �������, ����� ����� �������
            if(--TrailerPosTime[tid] <= 0)
			{
			    TrailerPosTime[tid] = 0;
				Trucker_UpdateTrailerStatus(tid);
			}
            else
            {
            	new string[128];
                if(TrailerPosStatus[tid] == 1)
                {
		            format(string, sizeof(string), "����� ��� �������\n{FFFFFF}�������� ����� %02d:%02d", TrailerPosTime[tid]/60, TrailerPosTime[tid]%60);
		            UpdateDynamic3DTextLabelText(TrailerPosText[tid], 0xFFFF00FF, string);
	            }
	            else if(TrailerPosStatus[tid] == 2)
	            {
		            format(string, sizeof(string), "����: {FFFFFF}%s\n{FFFF00}�����: {FFFFFF}%02d:%02d", TruckPoint[ TrailerPosPoint[tid] ][TPOINT_NAME], TrailerPosTime[tid] / 60, TrailerPosTime[tid] % 60);
		            UpdateDynamic3DTextLabelText(VehInfo[ TrailerPosVeh[tid] ][vLabel], 0xFFFF00FF, string);
	            }
            }
	    }
	}
}

Trucker_UpdateTrailers()
{
	new truckers, trailers;
    foreach(LoginPlayer, i)	if(Job.GetPlayerJob(i) == JOB_TRUCKER)		truckers++;
    for(new i; i < sizeof(TrailerPos); i++)	if(TrailerPosStatus[i] > 0)	trailers++;
    if(trailers == 0 || truckers > trailers * 2)	Trucker_UpdateTrailerStatus();
}

Trucker_UpdateTrailerStatus(tid = -1)
{
	if(tid == -1)
	{// �������� ������� � ��������� �����
	    new trailers[sizeof(TrailerPos)], count = 0;
	    for(new i; i < sizeof(TrailerPos); i++) if(TrailerPosStatus[i] == 0) trailers[count++] = i;
		if(count > 0) Trucker_UpdateTrailerStatus(trailers[random(count)]);
	}
	else if(0 <= tid < sizeof(TrailerPos))
	{
	    new string[128];
	    switch(TrailerPosStatus[tid])
	    {
	        case 0:
	        {// �� "���������" � "��������"
	            TrailerPosStatus[tid] = 1;
	            TrailerPosTime[tid] = 120; // 2 ������
	        }
	        case 1:
	        {// �� "��������" � "��������"
	            TrailerPosStatus[tid] = 2;
	            TrailerPosTime[tid] = 600; // 10 �����

	            TrailerPosPoint[tid] = random(sizeof(TruckPoint));
	            UpdateDynamic3DTextLabelText(TrailerPosText[tid], 0xFFFF00FF, " ");
	            TrailerPosVeh[tid] = MyCreateVehicle(TruckPoint[TrailerPosPoint[tid]][TPOINT_MOD], TrailerPos[tid][0], TrailerPos[tid][1], TrailerPos[tid][2], TrailerPos[tid][3], 1, 1);
	            VehInfo[ TrailerPosVeh[tid] ][vLocked] = 999;
	            VehInfo[ TrailerPosVeh[tid] ][vLabel] = CreateDynamic3DTextLabel(" ", 0xFFFF00FF, 0.0, 0.0, 2.0, 25.0, INVALID_PLAYER_ID, TrailerPosVeh[tid], 1);

	            format(string, sizeof(string), "�������� ����� �� '{FFFFFF}%s{33CCFF}'. ����������� ������ 2 � ������, ����� ������� ���", TruckPoint[TrailerPosPoint[tid]][TPOINT_NAME]);
	            SendJobMessage(JOB_TRUCKER, COLOR_LIGHTBLUE, string);
	        }
	        case 2:
	        {// �� "��������" � "��������"
	            MyDestroyVehicle(TrailerPosVeh[tid]);
	            UpdateDynamic3DTextLabelText(TrailerPosText[tid], 0xFFFF00FF, "����� ��� �������\n{FFFFFF}��������");

	            TrailerPosStatus[tid] = 0;
	            TrailerPosTime[tid] = 0;
	            TrailerPosVeh[tid] = 0;
	            TrailerPosPoint[tid] = 0;
	        }
	    }
	}
}

stock	GetTruckSkill(playerid)
{
	if (1 <= PlayerInfo[playerid][pTruckLevel] < 5)
		return PlayerInfo[playerid][pTruckLevel] * 20;
	return -1;
}

stock	GiveTruckSkill(playerid, skill = 1)
{
	if (0 <= PlayerInfo[playerid][pTruckLevel] < 5)
	{
		if (PlayerInfo[playerid][pTruckLevel] == 0)
			PlayerInfo[playerid][pTruckLevel] = 1;

	    new string[128], next = GetTruckSkill(playerid);
		PlayerInfo[playerid][pTruckSkill] += skill;
		if (PlayerInfo[playerid][pTruckSkill] >= next)
		{
			PlayerInfo[playerid][pTruckLevel]++;
			PlayerInfo[playerid][pTruckSkill] -= next;
			next = GetTruckSkill(playerid);

			format(string, 128,
				"~g~������������~n~~w~+ ����� � ��������: ~y~%d%s",
					getWageBonus(PlayerInfo[playerid][pTruckLevel]), "%%");
			ShowPlayerHint(playerid, string);
		}
		else if (PlayerInfo[playerid][pTruckSkill] % 2 == 0)
		{
			format(string, 128,
				"��������� [Y������: %d]", PlayerInfo[playerid][pTruckLevel]);
			IFace.RepBarShow(playerid, string,
				PlayerInfo[playerid][pTruckSkill] - 1,
				PlayerInfo[playerid][pTruckSkill], next);
		}
	}
}

//////////	Dialogs 	//////////
DialogCreate:Trucker_TrailerList(playerid)
{
    new Float:Dist;
    // lstring = "#\t����\t�����\t���������\n";
    new string[128] = "����\t�����\t�� �����\t�����\n";
    for(new i; i < sizeof(TrailerPos); i++)
    {
        if(TrailerPosStatus[i] == 2)
        {// ������� �������� (�� �����)
            Dist = GetDistanceFromMeToPoint(playerid, TrailerPos[i][0], TrailerPos[i][1], TrailerPos[i][2]);
            format(string, sizeof(string), "%s� %s\t%s\t%.1f m.\t%02d:%02d\n",
				string, TruckPoint[TrailerPosPoint[i]][TPOINT_NAME], GetPointArea(TrailerPos[i][0], TrailerPos[i][1]), Dist, TrailerPosTime[i]/60, TrailerPosTime[i]%60);
        }
    }
	Dialog_Open(playerid, Dialog:Trucker_TrailerList, DIALOG_STYLE_TABLIST_HEADERS, "������ ��������� ��������", string, "������", "�������");
	return true;
}

DialogResponse:Trucker_TrailerList(playerid, response, listitem, inputtext[])
{
	if(response)
    {
	    new idx, bool:founded = false;
	    for(new i; i < sizeof(TrailerPos); i++)
	    {
	        if(TrailerPosStatus[i] == 2)
	        {
	            if(idx == listitem)
	            {
	                idx = i;
		            founded = true;
		            break;
	            }
	            idx++;
	        }
	    }
	    if(founded == false)
	    {
	        if(idx == listitem) SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ������ �������� ���, �������� ��������� �����.");
	        else SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "����� �������� ��� ���, ���������� ��� ���.");
	        return Dialog_Show(playerid, Dialog:Trucker_TrailerList);
	    }
		ShowPlayerGPSPoint(playerid, TrailerPos[idx][0], TrailerPos[idx][1], TrailerPos[idx][2], 30.0);
		new string[128];
		SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_GPS "������ � ������ '%s' ������� �� ������ "SCOLOR_GPS"������ ��������", TruckPoint[TrailerPosPoint[idx]][TPOINT_NAME]);
    }
    return true;
}

DialogCreate:Trucker_TrailerMenu(playerid)
{
	new string[128];
	new point = TrailerPosPoint[TruckerPos[playerid]];
    format(string, sizeof(string), "{FFFF00}����: {FFFFFF}%s\n\
									{FFFF00}��: {FFFFFF}%s\n\
									{FFFF00}��: {FFFFFF}%s\n",
									TruckPoint[point][TPOINT_NAME],
									GetPlayerArea(playerid),
									GetPointArea(TruckPoint[point][TPOINT_X], TruckPoint[point][TPOINT_Y]));
	Dialog_Open(playerid, Dialog:Trucker_TrailerMenu, DIALOG_STYLE_MSGBOX, "���������� � �����", string, "�����", "�������");
	return true;
}

DialogResponse:Trucker_TrailerMenu(playerid, response, listitem, inputtext[])
{
  	if(response)
    {
        if(Job.SetPlayerNowWork(playerid, JOB_TRUCKER))
        {
        	new point = TrailerPosPoint[TruckerPos[playerid]];

	    	TruckerStatus[playerid] = 1;
	    	TruckerVeh[playerid] = GetPlayerVehicleID(playerid);
	        TruckerTrailer[playerid] = TrailerPosVeh[TruckerPos[playerid]];
	        VehInfo[TruckerTrailer[playerid]][vSpawnDestroy] = true;
	        TruckerPoint[playerid] = TrailerPosPoint[TruckerPos[playerid]];
	        TruckerDist[playerid] = GetDistanceFromMeToPoint(playerid, TruckPoint[point][TPOINT_X], TruckPoint[point][TPOINT_Y], TruckPoint[point][TPOINT_Z]);
	        TruckerDmg[playerid] = 0;
	        TruckerTick[playerid] = GetTickCount();

			PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
			MySetPlayerCheckpoint(playerid, CPJOB_TRUCKER, TruckPoint[point][TPOINT_X], TruckPoint[point][TPOINT_Y], TruckPoint[point][TPOINT_Z], 6.0);

			new string[128];
	        format(string, sizeof(string), "������������ {FFFFFF}%s{33CCFF} �������� ������ � ������ '{FFFFFF}%s{33CCFF}' � ������ {FFFFFF}%s",
				ReturnPlayerName(playerid), TruckPoint[point][TPOINT_NAME], GetPlayerArea(playerid));
	        SendJobMessage(JOB_TRUCKER, COLOR_LIGHTBLUE, string);
	        SendMissionMessage(playerid, "������������� �� ~r~������� ������~w~.");

			// ������� ����� � ������� ��������
		    for(new i; i < sizeof(TrailerPos); i++)
		    {
		    	if(TrailerPosVeh[i] == TruckerTrailer[playerid])
		    	{
		    		TrailerPosVeh[i] = 0;
		    		Trucker_UpdateTrailerStatus(i);
		    	}
	        }
	        format(string, sizeof(string), "����: {FFFFFF}%s", TruckPoint[point][TPOINT_NAME]);
	        UpdateDynamic3DTextLabelText(VehInfo[TruckerTrailer[playerid]][vLabel], 0xFFFF00FF, string);
        }
        else
        {
        	Dialog_Show(playerid, Dialog:Trucker_TrailerMenu);
        }
    }
    else
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
		MySetVehicleToRespawn(VehInfo[vehicleid][vTrailerID]);
		VehInfo[vehicleid][vTrailerID] = 0;
	}
	return true;
}