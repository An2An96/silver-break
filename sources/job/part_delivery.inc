#if !defined _job_core_included
	#endinput
#endif

#if defined	_job_part_delivery_included
	#endinput
#endif
#define _job_part_delivery_included

#include "businesses/header"

#define DELIVERY_MENU_ITEMS		10		//	���������� ������� �� �������� �� ������� ��������

enum
{
	DELIVERY_STATUS_NONE,
	//DELIVERY_STATUS_TRANSIT,
	DELIVERY_STATUS_CARRY,
}

new DeliveryVehLoadCount[MAX_VEHICLES],
	DeliveryVehLoadDamage[MAX_VEHICLES],
	DeliveryVehUnloadPickup[MAX_VEHICLES],
	DeliveryVehCheckPickupTimer[MAX_VEHICLES];

new DeliveryStatus[MAX_PLAYERS],
	DeliveryDamage[MAX_PLAYERS];

new DeliveryLoadZone;
new DeliveryPickup;

Public: Delivery_OnGameModeInit()
{
	/*new models[] = { 440, 499, 414, 456 };
	new car1 = MyCreateVehicle(models[ random(sizeof(models) - 1)], 2175.3616, -2266.7151, 15.0, 225.0, 93, 93);
	MyCreateVehicle(models[ random(sizeof(models) - 1)], 2168.0566, -2274.1399, 15.0, 225.0, 93, 93);
	MyCreateVehicle(models[ random(sizeof(models) - 1)], 2160.7991, -2281.6094, 15.0, 225.0, 93, 93);
	MyCreateVehicle(models[ random(sizeof(models) - 1)], 2158.9324, -2314.2068, 13.7, 315.0, 93, 93);
	MyCreateVehicle(models[ random(sizeof(models) - 1)], 2166.1624, -2321.6367, 13.7, 315.0, 93, 93);
	new car2 = MyCreateVehicle(models[ random(sizeof(models) - 1)], 2173.5332, -2329.0085, 13.7, 315.0, 93, 93);
    for(new x = car1; x <= car2; x++)
	{
	    CarInfo[x][cType] = C_TYPE_PARTJOB;
	    CarInfo[x][cOwnerID] = PART_DELIVERY;
	    VehInfo[x][vRentPrice] = 75;
	    VehInfo[x][vLabel] = CreateDynamic3DTextLabel(" ", COLOR_LIGHTPINK, 0.0, 0.0, 1.5, 25.0, INVALID_PLAYER_ID, x, 1);
	    UpdateVehicleLabel(x);
	    SetVehicleNumberPlate(x, "DELIVERY");
	}*/

	DeliveryPickup = CreateDynamicPickup(1275, 1, 2156.899, -2300.11, 13.47);
	CreateDynamicPickup(1271, 1, 2153.8533,-2289.6404, 13.7983); // DeliveryLoadZone
	DeliveryLoadZone = CreateDynamicSphere(2152.6, -2288.0, 13.3, 3.0);	// ����� ��������� ��� �������� � �������

	CreateDynamic3DTextLabel("�������� ���������", COLOR_LIGHTBLUE, 2153.8533,-2289.6404, 15.0, 40.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	CreateDynamic3DTextLabel("������ ��������", COLOR_LIGHTBLUE, 2156.899, -2300.11, 14.2, 20.0);

	return CONTINUE;
}

Public: Delivery_OnPlayerPickUpDPickup(playerid, pickupid)
{
	foreach(Vehicle, v)
    {
    	if(DeliveryVehUnloadPickup[v] == pickupid)
    	{
    		if(DeliveryStatus[playerid] != DELIVERY_STATUS_CARRY && DeliveryVehLoadCount[v] > 0)
			{
				if(VehInfo[v][vRentOwner] == PlayerInfo[playerid][pUserID]
				|| GetPVarInt(playerid, "Player:JobPartner") == VehInfo[v][vRentOwner])
				{
					if(CarryUP(playerid, 2969, 0.009, 0.344, -0.024, 0.0, 90.0, 0.0))
					{
						SetPVarInt(playerid, "Player:Delivery:Veh", v);
						DeliveryStatus[playerid] = DELIVERY_STATUS_CARRY;
						DeliveryVehLoadCount[v]--;
						DeliveryDamage[playerid] = DeliveryVehLoadDamage[v];
					}
				}
			}
    		else if(DeliveryStatus[playerid] == DELIVERY_STATUS_CARRY)
			{
				DeliveryStatus[playerid] = DELIVERY_STATUS_NONE;
				DeliveryVehLoadCount[v]++;
				PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
			    CarryDown(playerid);
			}
			UpdateVehicleLabel(v);
			gPickupTime[playerid] = 3;
		}
    }

	return CONTINUE;
}

////////////////////////////////////////
Delivery_FinishWork(playerid, reason = Job.REASON_COMPLETE)
{
	#pragma unused reason
	if(DeliveryVehLoadCount[ gLastVehicle[playerid] ] > 0)
	{
		IFace.ProgressBarHide(playerid);
	}
	if(DeliveryStatus[playerid] == DELIVERY_STATUS_CARRY)
	{
		DeliveryStatus[playerid] = DELIVERY_STATUS_NONE;
		DeliveryDamage[playerid] = 0;
	}
}

Delivery_Drop(playerid)
{
	if(DeliveryStatus[playerid] == DELIVERY_STATUS_CARRY)
	{
		CarryDown(playerid);
		PlayerAction(playerid, "������ ���� �� �����.");
		DeliveryStatus[playerid] = DELIVERY_STATUS_NONE;
		DeliveryDamage[playerid] = 0;
	}
}

Public: Delivery_Load(vehicleid, count)
{
	if(vehicleid > 0 && IsVehicleDelivery(GetVehicleModel(vehicleid)))
	{
		DeliveryVehLoadDamage[vehicleid] = 100;
		DeliveryVehLoadCount[vehicleid] += count;
		UpdateVehicleLabel(vehicleid);

	    new playerid = VehInfo[vehicleid][vDriver];
	    if(playerid != -1)
	    {
			IFace.ShowPlayerProgress(playerid, 1000, 1000,
				isRus(playerid) ? RusText("�����") : "Damage");
			PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
			TogglePlayerControllable(playerid, true);

			ShowPlayerHint(playerid, "~w~������� ~y~~k~~TOGGLE_SUBMISSIONS~ ~w~����� ������� ������ ��������", 5000);
	    }
	}
    return true;
}

Public: Delivery_Unload(vehicleid)
{
	DeliveryVehLoadDamage[vehicleid] = 0;
	DeliveryVehLoadCount[vehicleid] = 0;
    UpdateVehicleLabel(vehicleid);
    Delivery_DeletePoint(vehicleid);
    return true;
}

Delivery_StartUnload(playerid, oldstate)
{
	if(DeliveryVehLoadCount[ gLastVehicle[playerid] ] > 0)
    {
    	new Float:pos[3];
		for(new i = 0; i < MaxBiz; i++)
		{
			if(BizInfo[i][bID] == 0)
				continue;
			if(GetDistanceFromMeToPoint(playerid, Arr3<BizInfo[i][bPos]>) < 20.0)
			{
				pos[0] = BizInfo[i][bPos][0];
				pos[1] = BizInfo[i][bPos][1];
				pos[2] = BizInfo[i][bPos][2];
			}
		}
		new Float:dist = GetDistanceFromMeToPoint(playerid, Arr3<pos>);
		if(dist < 5.0 && oldstate == PLAYER_STATE_DRIVER)
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "�� ��������� ������� ������ � ����� ���������.");
		}
		else if(dist < 20.0)
		{
			Delivery_CreatePoint(gLastVehicle[playerid]);
		}
	 	MyDisablePlayerCheckpoint(playerid);
		IFace.ProgressBarHide(playerid);
	}
}

Delivery_CreatePoint(vehicleid)
{
	if(DeliveryVehUnloadPickup[vehicleid] == 0 && DeliveryVehLoadCount[vehicleid] > 0)
	{
	    new Float:pos[4];
	    GetVehiclePos(vehicleid, Arr3<pos>);
		GetVehicleZAngle(vehicleid, pos[3]);
		pos[0] += (-3.7 * floatsin(-pos[3], degrees));	pos[1] += (-3.7 * floatcos(-pos[3], degrees));
		DeliveryVehUnloadPickup[vehicleid] = CreateDynamicPickup(1239, 1, pos[0], pos[1], pos[2]);
		DeliveryVehCheckPickupTimer[vehicleid] = SetTimerEx("Delivery_CheckPoint", 1000, true, "d", vehicleid);
		SetVehicleBoot(vehicleid, true);
	}
	return true;
}

Public: Delivery_CheckPoint(vehicleid)
{
	new Float:pos[3], Float:point_pos[3];
	GetVehiclePos(vehicleid, Arr3<pos>);
	Streamer_GetFloatData(STREAMER_TYPE_PICKUP, DeliveryVehUnloadPickup[vehicleid], E_STREAMER_X, point_pos[0]);
	Streamer_GetFloatData(STREAMER_TYPE_PICKUP, DeliveryVehUnloadPickup[vehicleid], E_STREAMER_Y, point_pos[1]);
	Streamer_GetFloatData(STREAMER_TYPE_PICKUP, DeliveryVehUnloadPickup[vehicleid], E_STREAMER_Z, point_pos[2]);
	if(GetDistanceFromPointToPoint(Arr3<point_pos>, Arr3<pos>) > 5.0)
	{
		Delivery_DeletePoint(vehicleid);
	}
	return true;
}

Delivery_DeletePoint(vehicleid)
{	//	0 - �������� ������� �� �����, 1 - ���������, 2 - ���������
	if(DeliveryVehUnloadPickup[vehicleid])
	{
		KillTimer(DeliveryVehCheckPickupTimer[vehicleid]), DeliveryVehCheckPickupTimer[vehicleid] = 0;
		DestroyDynamicPickup(DeliveryVehUnloadPickup[vehicleid]), DeliveryVehUnloadPickup[vehicleid] = INVALID_STREAMER_ID;
		SetVehicleBoot(vehicleid, false);
	}
	return true;
}

Delivery_BringInBiz(playerid, biz)
{
	if(DeliveryStatus[playerid] == DELIVERY_STATUS_CARRY)
	{
		if(BizInfo[biz][bProduct] >= BizInfo[biz][bMaxProds])
		{
			return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "����� ��������, ������������� � ������� �������.");
		}
		new Float:price = BIZ_SPRODS_PRICE * (float(DeliveryDamage[playerid]) / 100);
		if(BizInfo[biz][bOwnerID] > 0)
		{
    		if(BizInfo[biz][bBank] <= price)
    		{
    			return SendClientMessage(playerid, COLOR_GREY, PREFIX_ERROR "� ������� ������������ ������� ��� ������ �������.");
    		}
		    BizInfo[biz][bBank] -= price;
	    }
		BizInfo[biz][bProduct] += 5;

		new delveh = GetPVarInt(playerid, "Player:Delivery:Veh");
		if(BizInfo[biz][bProduct] > BizInfo[biz][bMaxProds])
		{
			BizInfo[biz][bProduct] = BizInfo[biz][bMaxProds];
			Delivery_DeletePoint(delveh);
	    }
	    SaveBiz(biz);

		if(!DeliveryVehLoadCount[delveh])	Delivery_DeletePoint(delveh);
		Job.GivePlayerPartWage(playerid, price);
		PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
	    CarryDown(playerid);
	    DeliveryStatus[playerid] = DELIVERY_STATUS_NONE;
		DeliveryDamage[playerid] = 0;
		gPickupTime[playerid] = 3;
		return true;
   	}
   	return false;
}

IsVehicleDelivery(model)
{
	switch(model)
	{
		case 440:	return true;
		case 499:	return true;
		case 414:	return true;
		case 456:	return true;
	}
	return false;
}

Delivery_GetLoadSize(model)
{
	switch(model)
	{
		case 440:	return 10;
		case 499:	return 12;
		case 414:	return 14;
		case 456:	return 16;
	}
	return 0;
}

//////////	Dialogs 	//////////
DialogCreate:Delivery_Board(playerid)	//	case DJOB_DELIVERY_BOARD:
{
	return Dialog_Open(playerid, Dialog:Delivery_Board, DIALOG_STYLE_LIST, "{008A32}����������", "���������� �� ������\n������ �������", "�������", "�������");
}

DialogResponse:Delivery_Board(playerid, response, listitem, inputtext[])	//	case DJOB_DELIVERY_BOARD:
{
	if(response)
	{
		if(listitem == 0)
		{
			Dialog_Show(playerid, Dialog:Delivery_Info);
		}
		else if(listitem == 1)
		{
			Dialog_Show(playerid, Dialog:Delivery_Biz);
		}
	}
	else gPickupTime[playerid] = 3;
	return true;
}

DialogCreate:Delivery_Info(playerid)	//	case DJOB_DELIVERY_INFO:
{
	new string[1024] = "{FFFFFF}������ �������� ���������� ��������� ������� � ������� �����.\n\n\
	\t\t\t\t\t{FCEC3A}���������� �� ������{FFFFFF}\n\
	[1] ������������� � ������� ������ [����� ������� ����� �� ���]\n\n\
	[2] ��������� ���� �� ��������\n\n\
	[3] ��������� � ����� �������� � �������� ����� [����� ������� ������ �� ���]\n\n\
	[4] �������� ������ ������� � �������� ���������� ������ [������� 2 ���� � ����]\n\n";
	strcat(string, "[5] ��������� � ������� � ������� �� ����, ����� ������� �������� ����� ��� ���������\n\n\
	[6] ���������� ������ � ������, �� ������ ���� �� ������ �������� ������\n\n\n\
	\t\t\t\t\t{FCEC3A}���������� ������{FFFFFF}\n\
	[1] ������������� ������ �� ����� ����������\n\n\
	[2] ��������� ���� ������\n\n\
	[3] �������� ���� �������������� �� ����� ���������� � �������� ����� '���������� ����������'\n\n\
	[4] ��������� ���������");
	return Dialog_Open(playerid, Dialog:Delivery_Info, DIALOG_STYLE_MSGBOX, "{008A32}����������", string, "�����", "");
}

DialogResponse:Delivery_Info(playerid, response, listitem, inputtext[])	//	case DJOB_DELIVERY_INFO:
{
	return Dialog_Show(playerid, Dialog:Delivery_Board);
}

DialogCreate:Delivery_Main(playerid)	//	case DJOB_DELIVERY:
{
	new string[128];
	if(Job.GetPlayerNowWork(playerid) == PART_DELIVERY)
	{
		string = "{FFFFFF}�� ������� ��� ������ ��������� ������?";
	}
	else
	{
		string = "{FFFFFF}�� ������ ���������� � ������ ���������� ���������?";
	}
	return Dialog_Open(playerid, Dialog:Delivery_Main, DIALOG_STYLE_MSGBOX, "����� �� ������", string, "��", "�������");
}

DialogResponse:Delivery_Main(playerid, response, listitem, inputtext[])	//	case DJOB_DELIVERY:
{
	if(response)
	{
		if(Job.GetPlayerNowWork(playerid) == PART_DELIVERY)
		{
			Job.ClearPlayerNowWork(playerid);
			//SendClientMessage(playerid, COLOR_WHITE, "�� ��������� ������ ���������� ���������.");
		}
		else
		{
			if(Job.SetPlayerNowWork(playerid, PART_DELIVERY))
			{
				SendClientMessage(playerid, COLOR_WHITE, "�� ������ ������ ���������� ���������, ��������� ������.");
			}
		}
	}
	gPickupTime[playerid] = 3;
	return true;
}

DialogCreate:Delivery_Load(playerid)	//	case DJOB_DELIVERY_LOAD:
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(vehicleid > 0 && VehInfo[vehicleid][vDriver] == playerid && Delivery_GetLoadSize(GetVehicleModel(vehicleid)))
	{
		new string[256];
		format(string, sizeof(string),
			"{FFFFFF}��������� ���������: {80FF00}$%.2f\n\
			{FFFFFF}���������: {80FF00}%d{FFFFFF}/{80FF00}%d\n\n\n\
			{FFFFFF}������� ���-�� ��������� ��� �������:", PRODUCTS_PRICE, DeliveryVehLoadCount[vehicleid], Delivery_GetLoadSize(GetVehicleModel(vehicleid)));
		Dialog_Open(playerid, Dialog:Delivery_Load, DIALOG_STYLE_INPUT, "�������� ���������", string, "���������", "�������");
		HideMissionMessage(playerid);
		TogglePlayerControllable(playerid, false);
	}
	return true;
}

DialogResponse:Delivery_Load(playerid, response, listitem, inputtext[])	//	case DJOB_DELIVERY_LOAD:
{
	if(response)
	{
		new count = strval(inputtext);
		if(!(0 < strlen(inputtext) < 10) || count <= 0)
        {
            SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "������� ������������ ��������.");
            return Dialog_Show(playerid, Dialog:Delivery_Load);
        }
		new vehicleid = GetPlayerVehicleID(playerid);
		if(vehicleid == 0 || VehInfo[vehicleid][vDriver] != playerid || Delivery_GetLoadSize(GetVehicleModel(vehicleid)) == 0)
		{
			return true;
		}
		if(Delivery_GetLoadSize(GetVehicleModel(vehicleid)) - DeliveryVehLoadCount[vehicleid] - count < 0)
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������ �� ������ ������� ���������.");
			return Dialog_Show(playerid, Dialog:Delivery_Load);
		}
		if(MyGetPlayerMoney(playerid) < floatround(PRODUCTS_PRICE * count))
		{
			SendClientMessage(playerid, COLOR_WHITE, PREFIX_ERROR "� ��� ������������ ����� ��� ������� �������.");
			return Dialog_Show(playerid, Dialog:Delivery_Load);
		}
		MyGivePlayerMoney(playerid, -floatround(count * PRODUCTS_PRICE));
		SetTimerEx("Delivery_Load", 500 * count, false, "ii", vehicleid, count);
		GameTextForPlayer(playerid, "~w~Loading...", 500 * count, 4);
	}
	else
	{
		TogglePlayerControllable(playerid, true);
	}
	return true;
}

DialogCreate:Delivery_Biz(playerid)	//	case DJOB_DELIVERY_BIZ:
{
	new string[1024] = "������\t��������\t���������\t���������\n";
	new page = GetPVarInt(playerid, "DeliveryListPage");
	for(new i = 0, count = 0; i < MaxBiz; i++)
	{
		if(BizInfo[i][bID] == 0)				continue;
		if(i < (page * DELIVERY_MENU_ITEMS))	continue;
		if(count == DELIVERY_MENU_ITEMS)
		{
			strcat(string, "{CFB53B}����� >>\n");
			break;
		}
		format(string, sizeof(string), "%s%s\t%d/%d\t%d\t%.1f m.\n", string, BizInfo[i][bName], BizInfo[i][bProduct], BizInfo[i][bMaxProds], 100, GetDistanceFromMeToPoint(playerid, Arr3<BizInfo[i][bPos]>));
		count++;
	}
	if(page)	strcat(string, "{FF6347}<< �����\n");
	return Dialog_Open(playerid, Dialog:Delivery_Biz, DIALOG_STYLE_TABLIST_HEADERS, "�������� ���������", string, "�������", "�������");
}

DialogResponse:Delivery_Biz(playerid, response, listitem, inputtext[])	//	case DJOB_DELIVERY_BIZ:
{
	if(response)
	{
		new page = GetPVarInt(playerid, "DeliveryListPage");
		if(listitem == DELIVERY_MENU_ITEMS)
		{
			if(MaxBiz - (page * DELIVERY_MENU_ITEMS) > DELIVERY_MENU_ITEMS)
			{		//	�����
				SetPVarInt(playerid, "DeliveryListPage", page + 1);
				Dialog_Show(playerid, Dialog:Delivery_Biz);
			}
			else
			{								//	�����
				SetPVarInt(playerid, "DeliveryListPage", page - 1);
				Dialog_Show(playerid, Dialog:Delivery_Biz);
			}
		}
		else
		{
			for(new i, count; i < MaxBiz; i++)
			{
				if(i < (page * DELIVERY_MENU_ITEMS))	continue;
				if(BizInfo[i][bID] == 0)				continue;
				if(count == DELIVERY_MENU_ITEMS)		break;
				if(listitem == count++)
				{
					new string[128];
					ShowPlayerGPSPoint(playerid, Arr3<BizInfo[i][bPos]>, 10.0);
					SendFormatMessage(playerid, COLOR_WHITE, string, PREFIX_GPS "������ '%s' ������� �� ������ "SCOLOR_GPS"������ ��������", BizInfo[i][bName]);
					PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
					DeletePVar(playerid, "DeliveryListPage");
					return true;
				}
			}
			//	�����
			SetPVarInt(playerid, "DeliveryListPage", page - 1);
			Dialog_Show(playerid, Dialog:Delivery_Biz);
		}
	}
	else
	{
		DeletePVar(playerid, "DeliveryListPage");
	}
	return true;
}