#if defined _gang_interface_included
  #endinput
#endif

#define _gang_interface_included

CreateGangZoneTextDraw(zone)
{
	GangZoneTextDraw[zone][0] = TextDrawCreate(614.0, 132.0, "_");
	TextDrawLetterSize(GangZoneTextDraw[zone][0], 0.5, 4.7);
	TextDrawUseBox(GangZoneTextDraw[zone][0], 1);
	TextDrawBoxColor(GangZoneTextDraw[zone][0], 68);
	TextDrawTextSize(GangZoneTextDraw[zone][0], 474.0, 3.0);

	GangZoneTextDraw[zone][1] = TextDrawCreate(477.0, 175.0, "~w~waiting...");
	TextDrawFont(GangZoneTextDraw[zone][1], 2);
	TextDrawLetterSize(GangZoneTextDraw[zone][1], 0.32, 0.9);
	TextDrawSetOutline(GangZoneTextDraw[zone][1], 1);

	GangZoneTextDraw[zone][2] = TextDrawCreate(485.0, 141.0, "_");
	TextDrawFont(GangZoneTextDraw[zone][2], 3);// Gang1 Name
	TextDrawLetterSize(GangZoneTextDraw[zone][2], 0.35, 1.0);
	TextDrawSetOutline(GangZoneTextDraw[zone][2], 1);
	TextDrawSetShadow(GangZoneTextDraw[zone][2], 0);

	GangZoneTextDraw[zone][3] = TextDrawCreate(485.0, 157.0, "_");
	TextDrawFont(GangZoneTextDraw[zone][3], 3);// Gang2 Name
	TextDrawLetterSize(GangZoneTextDraw[zone][3], 0.35, 1.0);
	TextDrawSetOutline(GangZoneTextDraw[zone][3], 1);
	TextDrawSetShadow(GangZoneTextDraw[zone][3], 0);

	GangZoneTextDraw[zone][4] = TextDrawCreate(587.0, 142.0, "0");
	TextDrawFont(GangZoneTextDraw[zone][4], 2);// Gang1 Kills
	TextDrawLetterSize(GangZoneTextDraw[zone][4], 0.35, 1.0);
	TextDrawSetOutline(GangZoneTextDraw[zone][4], 1);
	TextDrawSetShadow(GangZoneTextDraw[zone][4], 0);

	GangZoneTextDraw[zone][5] = TextDrawCreate(587.0, 157.0, "0");
	TextDrawFont(GangZoneTextDraw[zone][5], 2);// Gang2 Kills
	TextDrawLetterSize(GangZoneTextDraw[zone][5], 0.35, 1.0);
	TextDrawSetOutline(GangZoneTextDraw[zone][5], 1);
	TextDrawSetShadow(GangZoneTextDraw[zone][5], 0);

	GangZoneTextDraw[zone][6] = TextDrawCreate(572.0, 175.0, "_");
	TextDrawFont(GangZoneTextDraw[zone][6], 2);// Timer
	TextDrawLetterSize(GangZoneTextDraw[zone][6], 0.32, 0.9);
	TextDrawColor(GangZoneTextDraw[zone][6], -1);
	TextDrawSetOutline(GangZoneTextDraw[zone][6], 1);

	GangZoneTextDraw[zone][7] = TextDrawCreate(488.0, 122.0, "Gang Zone");
	TextDrawFont(GangZoneTextDraw[zone][7], 0);
	TextDrawLetterSize(GangZoneTextDraw[zone][7], 0.55, 1.3);
	TextDrawColor(GangZoneTextDraw[zone][7], -1);
	TextDrawSetOutline(GangZoneTextDraw[zone][7], 1);
}

ShowGangZoneTextDraw(playerid, zone)
{
	for(new n; n < sizeof(GangZoneTextDraw[]); n++)
		TextDrawShowForPlayer(playerid, GangZoneTextDraw[zone][n]);
}

HideGangZoneTextDraw(playerid, zone)
{
	for(new n; n < sizeof(GangZoneTextDraw[]); n++)
		TextDrawHideForPlayer(playerid, GangZoneTextDraw[zone][n]);
}

DestroyGangZoneTextDraw(zone)
{
	for(new n; n < sizeof(GangZoneTextDraw[]); n++)
	{
		TextDrawHideForAll(GangZoneTextDraw[zone][n]);
		TextDrawDestroy(GangZoneTextDraw[zone][n]);
	}
}