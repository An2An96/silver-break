#if defined _vehicle_interface_included
  #endinput
#endif

#define _vehicle_interface_included

enum E_VEH_IFACE_TD
{
	Text:veh_Td_Background,
	Text:veh_Td_FuelScale[6],
	Text:veh_Td_FuelIcon[3],
}

enum E_VEH_IFACE_PTD
{
	PlayerText:veh_PTd_Fuel,
	PlayerText:veh_PTd_Speed,
	PlayerText:veh_PTd_Mileage,
	PlayerText:veh_PTd_Engine,
	PlayerText:veh_PTd_Light,
	PlayerText:veh_PTd_Lock
}

static Vehicle_IFace_TD[E_VEH_IFACE_TD];
static Vehicle_IFace_PTD[E_VEH_IFACE_PTD];

Public: IFace.Veh_Toggle(playerid, bool:toggle)
{
	if(toggle)
	{
	    TextDrawShowForPlayer(playerid, Vehicle_IFace_TD[veh_Td_Background]);
	    for(new i = 0; i < sizeof(Vehicle_IFace_TD[veh_Td_FuelScale]); i++)
	    {
	    	TextDrawShowForPlayer(playerid, Vehicle_IFace_TD[veh_Td_FuelScale][i]);
	    }
	    for(new i = 0; i < sizeof(Vehicle_IFace_TD[veh_Td_FuelIcon]); i++)
	    {
	    	TextDrawShowForPlayer(playerid, Vehicle_IFace_TD[veh_Td_FuelIcon][i]);
	    }

	    PlayerTextDrawShow(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel]);
	    PlayerTextDrawShow(playerid, Vehicle_IFace_PTD[veh_PTd_Speed]);
	    PlayerTextDrawShow(playerid, Vehicle_IFace_PTD[veh_PTd_Mileage]);
	    PlayerTextDrawShow(playerid, Vehicle_IFace_PTD[veh_PTd_Engine]);
	    PlayerTextDrawShow(playerid, Vehicle_IFace_PTD[veh_PTd_Light]);
	    PlayerTextDrawShow(playerid, Vehicle_IFace_PTD[veh_PTd_Lock]);

		IFace.Veh_Update(playerid, 0);
	}
	else
	{	// Hide
		TextDrawHideForPlayer(playerid, Vehicle_IFace_TD[veh_Td_Background]);
	    for(new i = 0; i < sizeof(Vehicle_IFace_TD[veh_Td_FuelScale]); i++)
	    {
	    	TextDrawHideForPlayer(playerid, Vehicle_IFace_TD[veh_Td_FuelScale][i]);
	    }
	    for(new i = 0; i < sizeof(Vehicle_IFace_TD[veh_Td_FuelIcon]); i++)
	    {
	    	TextDrawHideForPlayer(playerid, Vehicle_IFace_TD[veh_Td_FuelIcon][i]);
	    }

	    PlayerTextDrawHide(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel]);
	    PlayerTextDrawHide(playerid, Vehicle_IFace_PTD[veh_PTd_Speed]);
	    PlayerTextDrawHide(playerid, Vehicle_IFace_PTD[veh_PTd_Mileage]);
	    PlayerTextDrawHide(playerid, Vehicle_IFace_PTD[veh_PTd_Engine]);
	    PlayerTextDrawHide(playerid, Vehicle_IFace_PTD[veh_PTd_Light]);
	    PlayerTextDrawHide(playerid, Vehicle_IFace_PTD[veh_PTd_Lock]);
	}
	return true;
}

IFace.Veh_Update(playerid, part)
{
    if(!IFace.GetGroupToggleAndVisible(playerid, IFace.SPEEDO))
    {
	    return false;
    }

	new string[32], vehicleid = GetPlayerVehicleID(playerid);
	if(part == 0)
	{
	// Fuel
		new Float:proc = VehInfo[vehicleid][vFuel] / (float(GetVehicleMaxFuel(vehicleid)) / 100.0);
		if(proc > 100.0)	proc = 100.0;
		new Float:Pos = 530.0 + 0.74 * proc;
		// Fuel
		PlayerTextDrawDestroy(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel]);
		Vehicle_IFace_PTD[veh_PTd_Fuel] = CreatePlayerTextDraw(playerid, Pos, 425.500000, "~r~l");
		PlayerTextDrawAlignment(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel], 2);
		PlayerTextDrawBackgroundColor(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel], 255);
		PlayerTextDrawFont(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel], 1);
		PlayerTextDrawLetterSize(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel], 0.3, -1.0);
		PlayerTextDrawColor(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel], -16776961);
		PlayerTextDrawSetOutline(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel], 0);
		PlayerTextDrawSetProportional(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel], 1);
		PlayerTextDrawSetShadow(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel], 0);
		PlayerTextDrawShow(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel]);

	// Dist
		format(string, 32, "%05.1f__KM", CarInfo[vehicleid][cMileage]);
		PlayerTextDrawSetString(playerid, Vehicle_IFace_PTD[veh_PTd_Mileage], string);

		if(GetVehicleEngine(vehicleid))	PlayerTextDrawSetString(playerid, Vehicle_IFace_PTD[veh_PTd_Engine], "~r~E");
		else 							PlayerTextDrawSetString(playerid, Vehicle_IFace_PTD[veh_PTd_Engine], "E");

		if(VehInfo[vehicleid][vLights])	PlayerTextDrawSetString(playerid, Vehicle_IFace_PTD[veh_PTd_Light], "~r~L");
		else 							PlayerTextDrawSetString(playerid, Vehicle_IFace_PTD[veh_PTd_Light], "L");

		if(VehInfo[vehicleid][vLocked])	PlayerTextDrawSetString(playerid, Vehicle_IFace_PTD[veh_PTd_Lock], "~r~closed");
		else 							PlayerTextDrawSetString(playerid, Vehicle_IFace_PTD[veh_PTd_Lock], "___open");
	}
	else if(part == 1)
	{
		new speed = GetVehicleSpeed(vehicleid);
		format(string, sizeof(string), "%03d_____KMH", speed);
		PlayerTextDrawSetString(playerid, Vehicle_IFace_PTD[veh_PTd_Speed], string);
	}
	return true;
}

IFace.Veh_Create_Base()
{
	//	Speedometr
	Vehicle_IFace_TD[veh_Td_Background] = TextDrawCreate(560.0, 380.0, "_");
	TextDrawAlignment(Vehicle_IFace_TD[veh_Td_Background], 2);
	TextDrawBackgroundColor(Vehicle_IFace_TD[veh_Td_Background], 255);
	TextDrawFont(Vehicle_IFace_TD[veh_Td_Background], 1);
	TextDrawLetterSize(Vehicle_IFace_TD[veh_Td_Background], 0.5, 3.5);
	TextDrawColor(Vehicle_IFace_TD[veh_Td_Background], -1);
	TextDrawSetOutline(Vehicle_IFace_TD[veh_Td_Background], 0);
	TextDrawSetProportional(Vehicle_IFace_TD[veh_Td_Background], 1);
	TextDrawSetShadow(Vehicle_IFace_TD[veh_Td_Background], 1);
	TextDrawUseBox(Vehicle_IFace_TD[veh_Td_Background], 1);
	TextDrawBoxColor(Vehicle_IFace_TD[veh_Td_Background], INTERFACE_MAIN_COLOR);
	TextDrawTextSize(Vehicle_IFace_TD[veh_Td_Background], 0.0, 85.0);

	Vehicle_IFace_TD[veh_Td_FuelScale][0] = TextDrawCreate(567.000000, 425.000000, "_");
	TextDrawAlignment(Vehicle_IFace_TD[veh_Td_FuelScale][0], 2);
	TextDrawBackgroundColor(Vehicle_IFace_TD[veh_Td_FuelScale][0], 255);
	TextDrawFont(Vehicle_IFace_TD[veh_Td_FuelScale][0], 1);
	TextDrawLetterSize(Vehicle_IFace_TD[veh_Td_FuelScale][0], 0.500000, -0.399999);
	TextDrawColor(Vehicle_IFace_TD[veh_Td_FuelScale][0], -1);
	TextDrawSetOutline(Vehicle_IFace_TD[veh_Td_FuelScale][0], 0);
	TextDrawSetProportional(Vehicle_IFace_TD[veh_Td_FuelScale][0], 1);
	TextDrawSetShadow(Vehicle_IFace_TD[veh_Td_FuelScale][0], 1);
	TextDrawUseBox(Vehicle_IFace_TD[veh_Td_FuelScale][0], 1);
	TextDrawBoxColor(Vehicle_IFace_TD[veh_Td_FuelScale][0], -154);
	TextDrawTextSize(Vehicle_IFace_TD[veh_Td_FuelScale][0], 0.000000, 70.000000);

	Vehicle_IFace_TD[veh_Td_FuelScale][1] = TextDrawCreate(604.000000, 425.500000, "l");
	TextDrawAlignment(Vehicle_IFace_TD[veh_Td_FuelScale][1], 2);
	TextDrawBackgroundColor(Vehicle_IFace_TD[veh_Td_FuelScale][1], 255);
	TextDrawFont(Vehicle_IFace_TD[veh_Td_FuelScale][1], 1);
	TextDrawLetterSize(Vehicle_IFace_TD[veh_Td_FuelScale][1], 0.190000, -0.999999);
	TextDrawColor(Vehicle_IFace_TD[veh_Td_FuelScale][1], -1);
	TextDrawSetOutline(Vehicle_IFace_TD[veh_Td_FuelScale][1], 0);
	TextDrawSetProportional(Vehicle_IFace_TD[veh_Td_FuelScale][1], 1);
	TextDrawSetShadow(Vehicle_IFace_TD[veh_Td_FuelScale][1], 0);
	TextDrawSetSelectable(Vehicle_IFace_TD[veh_Td_FuelScale][1], 0);

	Vehicle_IFace_TD[veh_Td_FuelScale][2] = TextDrawCreate(530.000000, 425.500000, "l");
	TextDrawAlignment(Vehicle_IFace_TD[veh_Td_FuelScale][2], 2);
	TextDrawBackgroundColor(Vehicle_IFace_TD[veh_Td_FuelScale][2], 255);
	TextDrawFont(Vehicle_IFace_TD[veh_Td_FuelScale][2], 1);
	TextDrawLetterSize(Vehicle_IFace_TD[veh_Td_FuelScale][2], 0.190000, -0.999999);
	TextDrawColor(Vehicle_IFace_TD[veh_Td_FuelScale][2], -1);
	TextDrawSetOutline(Vehicle_IFace_TD[veh_Td_FuelScale][2], 0);
	TextDrawSetProportional(Vehicle_IFace_TD[veh_Td_FuelScale][2], 1);
	TextDrawSetShadow(Vehicle_IFace_TD[veh_Td_FuelScale][2], 0);
	TextDrawSetSelectable(Vehicle_IFace_TD[veh_Td_FuelScale][2], 0);

	Vehicle_IFace_TD[veh_Td_FuelScale][3] = TextDrawCreate(549.000000, 425.500000, "l");
	TextDrawAlignment(Vehicle_IFace_TD[veh_Td_FuelScale][3], 2);
	TextDrawBackgroundColor(Vehicle_IFace_TD[veh_Td_FuelScale][3], 255);
	TextDrawFont(Vehicle_IFace_TD[veh_Td_FuelScale][3], 1);
	TextDrawLetterSize(Vehicle_IFace_TD[veh_Td_FuelScale][3], 0.190000, -0.799999);
	TextDrawColor(Vehicle_IFace_TD[veh_Td_FuelScale][3], -1);
	TextDrawSetOutline(Vehicle_IFace_TD[veh_Td_FuelScale][3], 0);
	TextDrawSetProportional(Vehicle_IFace_TD[veh_Td_FuelScale][3], 1);
	TextDrawSetShadow(Vehicle_IFace_TD[veh_Td_FuelScale][3], 0);
	TextDrawSetSelectable(Vehicle_IFace_TD[veh_Td_FuelScale][3], 0);

	Vehicle_IFace_TD[veh_Td_FuelScale][4] = TextDrawCreate(585.000000, 425.500000, "l");
	TextDrawAlignment(Vehicle_IFace_TD[veh_Td_FuelScale][4], 2);
	TextDrawBackgroundColor(Vehicle_IFace_TD[veh_Td_FuelScale][4], 255);
	TextDrawFont(Vehicle_IFace_TD[veh_Td_FuelScale][4], 1);
	TextDrawLetterSize(Vehicle_IFace_TD[veh_Td_FuelScale][4], 0.190000, -0.799999);
	TextDrawColor(Vehicle_IFace_TD[veh_Td_FuelScale][4], -1);
	TextDrawSetOutline(Vehicle_IFace_TD[veh_Td_FuelScale][4], 0);
	TextDrawSetProportional(Vehicle_IFace_TD[veh_Td_FuelScale][4], 1);
	TextDrawSetShadow(Vehicle_IFace_TD[veh_Td_FuelScale][4], 0);
	TextDrawSetSelectable(Vehicle_IFace_TD[veh_Td_FuelScale][4], 0);

	Vehicle_IFace_TD[veh_Td_FuelScale][5] = TextDrawCreate(567.000000, 425.500000, "l");
	TextDrawAlignment(Vehicle_IFace_TD[veh_Td_FuelScale][5], 2);
	TextDrawBackgroundColor(Vehicle_IFace_TD[veh_Td_FuelScale][5], 255);
	TextDrawFont(Vehicle_IFace_TD[veh_Td_FuelScale][5], 1);
	TextDrawLetterSize(Vehicle_IFace_TD[veh_Td_FuelScale][5], 0.190000, -0.999999);
	TextDrawColor(Vehicle_IFace_TD[veh_Td_FuelScale][5], -1);
	TextDrawSetOutline(Vehicle_IFace_TD[veh_Td_FuelScale][5], 0);
	TextDrawSetProportional(Vehicle_IFace_TD[veh_Td_FuelScale][5], 1);
	TextDrawSetShadow(Vehicle_IFace_TD[veh_Td_FuelScale][5], 0);
	TextDrawSetSelectable(Vehicle_IFace_TD[veh_Td_FuelScale][5], 0);

	Vehicle_IFace_TD[veh_Td_FuelIcon][0] = TextDrawCreate(521.000000, 422.000000, "_");
	TextDrawAlignment(Vehicle_IFace_TD[veh_Td_FuelIcon][0], 2);
	TextDrawBackgroundColor(Vehicle_IFace_TD[veh_Td_FuelIcon][0], 255);
	TextDrawFont(Vehicle_IFace_TD[veh_Td_FuelIcon][0], 1);
	TextDrawLetterSize(Vehicle_IFace_TD[veh_Td_FuelIcon][0], 0.500000, 0.000000);
	TextDrawColor(Vehicle_IFace_TD[veh_Td_FuelIcon][0], -1);
	TextDrawSetOutline(Vehicle_IFace_TD[veh_Td_FuelIcon][0], 0);
	TextDrawSetProportional(Vehicle_IFace_TD[veh_Td_FuelIcon][0], 1);
	TextDrawSetShadow(Vehicle_IFace_TD[veh_Td_FuelIcon][0], 1);
	TextDrawUseBox(Vehicle_IFace_TD[veh_Td_FuelIcon][0], 1);
	TextDrawBoxColor(Vehicle_IFace_TD[veh_Td_FuelIcon][0], -1);
	TextDrawTextSize(Vehicle_IFace_TD[veh_Td_FuelIcon][0], 0.000000, 1.000000);
	TextDrawSetSelectable(Vehicle_IFace_TD[veh_Td_FuelIcon][0], 0);

	Vehicle_IFace_TD[veh_Td_FuelIcon][1] = TextDrawCreate(521.500000, 414.000000, "o");
	TextDrawAlignment(Vehicle_IFace_TD[veh_Td_FuelIcon][1], 2);
	TextDrawBackgroundColor(Vehicle_IFace_TD[veh_Td_FuelIcon][1], 255);
	TextDrawFont(Vehicle_IFace_TD[veh_Td_FuelIcon][1], 2);
	TextDrawLetterSize(Vehicle_IFace_TD[veh_Td_FuelIcon][1], 0.260000, 1.000000);
	TextDrawColor(Vehicle_IFace_TD[veh_Td_FuelIcon][1], -1);
	TextDrawSetOutline(Vehicle_IFace_TD[veh_Td_FuelIcon][1], 0);
	TextDrawSetProportional(Vehicle_IFace_TD[veh_Td_FuelIcon][1], 1);
	TextDrawSetShadow(Vehicle_IFace_TD[veh_Td_FuelIcon][1], 0);
	TextDrawSetSelectable(Vehicle_IFace_TD[veh_Td_FuelIcon][1], 0);

	Vehicle_IFace_TD[veh_Td_FuelIcon][2] = TextDrawCreate(521.500000, 417.000000, "o");
	TextDrawAlignment(Vehicle_IFace_TD[veh_Td_FuelIcon][2], 2);
	TextDrawBackgroundColor(Vehicle_IFace_TD[veh_Td_FuelIcon][2], 255);
	TextDrawFont(Vehicle_IFace_TD[veh_Td_FuelIcon][2], 2);
	TextDrawLetterSize(Vehicle_IFace_TD[veh_Td_FuelIcon][2], 0.260000, 1.000000);
	TextDrawColor(Vehicle_IFace_TD[veh_Td_FuelIcon][2], -1);
	TextDrawSetOutline(Vehicle_IFace_TD[veh_Td_FuelIcon][2], 0);
	TextDrawSetProportional(Vehicle_IFace_TD[veh_Td_FuelIcon][2], 1);
	TextDrawSetShadow(Vehicle_IFace_TD[veh_Td_FuelIcon][2], 0);
	TextDrawSetSelectable(Vehicle_IFace_TD[veh_Td_FuelIcon][2], 0);
}

IFace.Veh_Create_Player(playerid)
{
	//	Speedometr
	Vehicle_IFace_PTD[veh_PTd_Fuel] = CreatePlayerTextDraw(playerid, 604.000000, 425.500000, "~r~l");
	PlayerTextDrawAlignment(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel], 2);
	PlayerTextDrawBackgroundColor(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel], 255);
	PlayerTextDrawFont(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel], 1);
	PlayerTextDrawLetterSize(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel], 0.3, -1.0);
	PlayerTextDrawColor(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel], -16776961);
	PlayerTextDrawSetOutline(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel], 0);
	PlayerTextDrawSetProportional(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel], 1);
	PlayerTextDrawSetShadow(playerid, Vehicle_IFace_PTD[veh_PTd_Fuel], 0);

	Vehicle_IFace_PTD[veh_PTd_Speed] = CreatePlayerTextDraw(playerid, 525.0, 380.0, "000 KMH");
	PlayerTextDrawBackgroundColor(playerid, Vehicle_IFace_PTD[veh_PTd_Speed], 255);
	PlayerTextDrawFont(playerid, Vehicle_IFace_PTD[veh_PTd_Speed], 2);
	PlayerTextDrawLetterSize(playerid, Vehicle_IFace_PTD[veh_PTd_Speed], 0.25, 1.5);
	PlayerTextDrawColor(playerid, Vehicle_IFace_PTD[veh_PTd_Speed], -1347440726);
	PlayerTextDrawSetOutline(playerid, Vehicle_IFace_PTD[veh_PTd_Speed], 0);
	PlayerTextDrawSetProportional(playerid, Vehicle_IFace_PTD[veh_PTd_Speed], 0);
	PlayerTextDrawSetShadow(playerid, Vehicle_IFace_PTD[veh_PTd_Speed], 0);

	Vehicle_IFace_PTD[veh_PTd_Mileage] = CreatePlayerTextDraw(playerid, 525.0, 395.0, "00000.0 KM");
	PlayerTextDrawBackgroundColor(playerid, Vehicle_IFace_PTD[veh_PTd_Mileage], 255);
	PlayerTextDrawFont(playerid, Vehicle_IFace_PTD[veh_PTd_Mileage], 2);
	PlayerTextDrawLetterSize(playerid, Vehicle_IFace_PTD[veh_PTd_Mileage], 0.25, 1.5);
	PlayerTextDrawColor(playerid, Vehicle_IFace_PTD[veh_PTd_Mileage], -1347440726);
	PlayerTextDrawSetOutline(playerid, Vehicle_IFace_PTD[veh_PTd_Mileage], 0);
	PlayerTextDrawSetProportional(playerid, Vehicle_IFace_PTD[veh_PTd_Mileage], 0);
	PlayerTextDrawSetShadow(playerid, Vehicle_IFace_PTD[veh_PTd_Mileage], 0);

	Vehicle_IFace_PTD[veh_PTd_Engine] = CreatePlayerTextDraw(playerid, 524.0, 365.0, "E");
	PlayerTextDrawAlignment(playerid, Vehicle_IFace_PTD[veh_PTd_Engine], 2);
	PlayerTextDrawBackgroundColor(playerid, Vehicle_IFace_PTD[veh_PTd_Engine], 255);
	PlayerTextDrawFont(playerid, Vehicle_IFace_PTD[veh_PTd_Engine], 2);
	PlayerTextDrawLetterSize(playerid, Vehicle_IFace_PTD[veh_PTd_Engine], 0.25, 1.0);
	PlayerTextDrawColor(playerid, Vehicle_IFace_PTD[veh_PTd_Engine], -1347440726);
	PlayerTextDrawSetOutline(playerid, Vehicle_IFace_PTD[veh_PTd_Engine], 0);
	PlayerTextDrawSetProportional(playerid, Vehicle_IFace_PTD[veh_PTd_Engine], 1);
	PlayerTextDrawSetShadow(playerid, Vehicle_IFace_PTD[veh_PTd_Engine], 0);
	PlayerTextDrawUseBox(playerid, Vehicle_IFace_PTD[veh_PTd_Engine], 1);
	PlayerTextDrawBoxColor(playerid, Vehicle_IFace_PTD[veh_PTd_Engine], INTERFACE_MAIN_COLOR);
	PlayerTextDrawTextSize(playerid, Vehicle_IFace_PTD[veh_PTd_Engine], 0.0, 13.0);

	Vehicle_IFace_PTD[veh_PTd_Light] = CreatePlayerTextDraw(playerid, 543.9, 365.0, "L");
	PlayerTextDrawAlignment(playerid, Vehicle_IFace_PTD[veh_PTd_Light], 2);
	PlayerTextDrawBackgroundColor(playerid, Vehicle_IFace_PTD[veh_PTd_Light], 255);
	PlayerTextDrawFont(playerid, Vehicle_IFace_PTD[veh_PTd_Light], 2);
	PlayerTextDrawLetterSize(playerid, Vehicle_IFace_PTD[veh_PTd_Light], 0.25, 1.0);
	PlayerTextDrawColor(playerid, Vehicle_IFace_PTD[veh_PTd_Light], -1347440726);
	PlayerTextDrawSetOutline(playerid, Vehicle_IFace_PTD[veh_PTd_Light], 0);
	PlayerTextDrawSetProportional(playerid, Vehicle_IFace_PTD[veh_PTd_Light], 1);
	PlayerTextDrawSetShadow(playerid, Vehicle_IFace_PTD[veh_PTd_Light], 0);
	PlayerTextDrawUseBox(playerid, Vehicle_IFace_PTD[veh_PTd_Light], 1);
	PlayerTextDrawBoxColor(playerid, Vehicle_IFace_PTD[veh_PTd_Light], INTERFACE_MAIN_COLOR);
	PlayerTextDrawTextSize(playerid, Vehicle_IFace_PTD[veh_PTd_Light], 0.0, 14.0);

	Vehicle_IFace_PTD[veh_PTd_Lock] = CreatePlayerTextDraw(playerid, 580.0, 365.0, "CLOSED");
	PlayerTextDrawAlignment(playerid, Vehicle_IFace_PTD[veh_PTd_Lock], 2);
	PlayerTextDrawBackgroundColor(playerid, Vehicle_IFace_PTD[veh_PTd_Lock], 255);
	PlayerTextDrawFont(playerid, Vehicle_IFace_PTD[veh_PTd_Lock], 2);
	PlayerTextDrawLetterSize(playerid, Vehicle_IFace_PTD[veh_PTd_Lock], 0.25, 1.0);
	PlayerTextDrawColor(playerid, Vehicle_IFace_PTD[veh_PTd_Lock], -1347440726);
	PlayerTextDrawSetOutline(playerid, Vehicle_IFace_PTD[veh_PTd_Lock], 0);
	PlayerTextDrawSetProportional(playerid, Vehicle_IFace_PTD[veh_PTd_Lock], 1);
	PlayerTextDrawSetShadow(playerid, Vehicle_IFace_PTD[veh_PTd_Lock], 0);
	PlayerTextDrawUseBox(playerid, Vehicle_IFace_PTD[veh_PTd_Lock], 1);
	PlayerTextDrawBoxColor(playerid, Vehicle_IFace_PTD[veh_PTd_Lock], INTERFACE_MAIN_COLOR);
	PlayerTextDrawTextSize(playerid, Vehicle_IFace_PTD[veh_PTd_Lock], 0.0, 45.0);
}