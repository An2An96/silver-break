#if defined _player_interface_included
	#endinput
#endif

#define _player_interface_included

new
	Text:TD_PressH,
	Text:HungerTD[2],
	Text:LogoTD[2],
	Text:RestartInfo,
	Text:Busted,
	Text:Wasted,

	PlayerText:HungerPlayerTD[MAX_PLAYERS],
	PlayerText:HealthBar,
	PlayerText:StatusGPS,
	PlayerText:changeMoneyTD;

Public: IFace.Player_Toggle(playerid, bool:toggle)
{
	if(toggle)
	{
		PlayerTextDrawShow(playerid, HealthBar);
		PlayerTextDrawShow(playerid, StatusGPS);

		//	Hunger
		if(HungerPlayerTD[playerid])	
		{
			PlayerTextDrawDestroy(playerid, HungerPlayerTD[playerid]);
		}

		if(MyGetPlayerArmour(playerid))	
		{
			TextDrawHideForPlayer(playerid, HungerTD[1]);
			TextDrawShowForPlayer(playerid, HungerTD[0]);

			HungerPlayerTD[playerid] = CreatePlayerTextDraw(playerid, 550.0, 37.0, "_");
		} 
		else 
		{
			TextDrawHideForPlayer(playerid, HungerTD[0]);
			TextDrawShowForPlayer(playerid, HungerTD[1]);

			HungerPlayerTD[playerid] = CreatePlayerTextDraw(playerid, 550.0, 50.0, "_");
		}

		PlayerTextDrawBackgroundColor(playerid, HungerPlayerTD[playerid], 255);
		PlayerTextDrawFont(playerid, HungerPlayerTD[playerid], 1);
		PlayerTextDrawLetterSize(playerid, HungerPlayerTD[playerid], 0.0, 0.0);
		PlayerTextDrawColor(playerid, HungerPlayerTD[playerid], -1);
		PlayerTextDrawSetOutline(playerid, HungerPlayerTD[playerid], 0);
		PlayerTextDrawSetProportional(playerid, HungerPlayerTD[playerid], 1);
		PlayerTextDrawSetShadow(playerid, HungerPlayerTD[playerid], 1);
		PlayerTextDrawUseBox(playerid, HungerPlayerTD[playerid], 1);
		PlayerTextDrawBoxColor(playerid, HungerPlayerTD[playerid], 0xFF6347FF);	//	2077687961
		//PlayerTextDrawTextSize(playerid, HungerPlayerTD[playerid], 581.0, 0.0);

		IFace.HungerUpdate(playerid);
	}
	else
	{
		PlayerTextDrawHide(playerid, HealthBar);
		PlayerTextDrawHide(playerid, StatusGPS); 

		//	Hunger
		PlayerTextDrawHide(playerid, HungerPlayerTD[playerid]);
		TextDrawHideForPlayer(playerid, HungerTD[0]);
		TextDrawHideForPlayer(playerid, HungerTD[1]);
	}

	IFace.ToggleGroup(playerid, IFace.LOGO,	toggle);
}

IFace.HungerUpdate(playerid)
{
	if(IFace.GetGroupToggleAndVisible(playerid, IFace.INTERFACE))
	{
		new Float:x = 546.0 + (58.0 / 100.0 * float(GetPlayerHunger(playerid)));//	604.0(100)
		PlayerTextDrawTextSize(playerid, HungerPlayerTD[playerid], x, 0.0);
		PlayerTextDrawShow(playerid, HungerPlayerTD[playerid]);
	}
	return true;
}

IFace.HealthUpdate(playerid, Float:health = -100.0)
{
	if(IFace.GetGroupToggleAndVisible(playerid, IFace.INTERFACE))
	{
		new string[9];
		if(health == -100.0)	GetPlayerHealth(playerid, health);
		format(string, 9, "%.0fHP", health);
		PlayerTextDrawSetString(playerid, HealthBar, string);
	}
	return true;
}

IFace.UpdateRestartInfo(second)
{
	new string[32];
	format(string, sizeof(string), "~r~Restart: ~w~%02d:%02d", second / 60, second % 60);
	TextDrawSetString(RestartInfo, string);
}

//	Change money
IFace.ChangeMoney_Update(playerid, money)
{
	new string[32];
	format(string, sizeof(string), "%s%d$", (money > 0) ? ("~g~+") : ("~r~"), money);
	PlayerTextDrawSetString(playerid, changeMoneyTD, string);
	PlayerTextDrawShow(playerid, changeMoneyTD);
	SetPlayerTimerEx(playerid, "IFace_ChangeMoney_Hide", 5000, false, "i", playerid);
}

Public: IFace.ChangeMoney_Hide(playerid)
{
	PlayerTextDrawHide(playerid, changeMoneyTD);
}

//////////////////////////////
IFace.Player_Load_Base()
{
	IFace.AddWantHide(IFace.RESTART,	IFace.LOGO);

	//	hunger
	HungerTD[0] = TextDrawCreate(577.0, 35.0, "1");
	TextDrawAlignment(HungerTD[0], 2);
	TextDrawBackgroundColor(HungerTD[0], 255);
	TextDrawFont(HungerTD[0], 1);
	TextDrawLetterSize(HungerTD[0], 0.0, 0.4);
	TextDrawColor(HungerTD[0], -1);
	TextDrawSetOutline(HungerTD[0], 0);
	TextDrawSetProportional(HungerTD[0], 1);
	TextDrawSetShadow(HungerTD[0], 1);
	TextDrawUseBox(HungerTD[0], 1);
	TextDrawBoxColor(HungerTD[0], 0x000000FF);		//	102
	TextDrawTextSize(HungerTD[0], 0.0, 58.0);

	HungerTD[1] = TextDrawCreate(577.0, 48.0, "1");
	TextDrawAlignment(HungerTD[1], 2);
	TextDrawBackgroundColor(HungerTD[1], 255);
	TextDrawFont(HungerTD[1], 1);
	TextDrawLetterSize(HungerTD[1], 0.0, 0.4);
	TextDrawColor(HungerTD[1], -1);
	TextDrawSetOutline(HungerTD[1], 0);
	TextDrawSetProportional(HungerTD[1], 1);
	TextDrawSetShadow(HungerTD[1], 1);
	TextDrawUseBox(HungerTD[1], 1);
	TextDrawBoxColor(HungerTD[1], 0x000000FF);		//	102
	TextDrawTextSize(HungerTD[1], 0.0, 58.0);

	LogoTD[0] = TextDrawCreate(575.0, 5.0, "Silver Break");
	TextDrawAlignment(LogoTD[0], 2);
	TextDrawBackgroundColor(LogoTD[0], 68);
	TextDrawFont(LogoTD[0], 0);
	TextDrawLetterSize(LogoTD[0], 0.5, 1.5);
	TextDrawColor(LogoTD[0], 409316095);
	TextDrawSetOutline(LogoTD[0], 1);
	TextDrawSetProportional(LogoTD[0], 1);

	LogoTD[1] = TextDrawCreate(575.0, 18.0, "role play");
	TextDrawAlignment(LogoTD[1], 2);
	TextDrawBackgroundColor(LogoTD[1], 51);
	TextDrawFont(LogoTD[1], 3);
	TextDrawLetterSize(LogoTD[1], 0.35, 1.0);
	TextDrawColor(LogoTD[1], -1);
	TextDrawSetOutline(LogoTD[1], 1);
	TextDrawSetProportional(LogoTD[1], 1);

	RestartInfo = TextDrawCreate(565.0, 5.0, "~r~Restart: ~w~00:00");
	TextDrawAlignment(RestartInfo, 2);
	TextDrawBackgroundColor(RestartInfo, 255);
	TextDrawFont(RestartInfo, 2);
	TextDrawLetterSize(RestartInfo, 0.3, 1.4);
	TextDrawSetOutline(RestartInfo, 1);
	TextDrawSetProportional(RestartInfo, 1);

	Busted = TextDrawCreate(220.0, 150.0, "Busted");
	TextDrawBackgroundColor(Busted, 255);
	TextDrawFont(Busted, 0);
	TextDrawLetterSize(Busted, 2.55, 5.0);
	TextDrawColor(Busted, -538976257);
	TextDrawSetOutline(Busted, 0);
	TextDrawSetProportional(Busted, 1);
	TextDrawSetShadow(Busted, 3);

	Wasted = TextDrawCreate(220.0, 150.0, "Wasted");
	TextDrawBackgroundColor(Wasted, 255);
	TextDrawFont(Wasted, 0);
	TextDrawLetterSize(Wasted, 2.55, 5.0);
	TextDrawColor(Wasted, -538976257);
	TextDrawSetOutline(Wasted, 0);
	TextDrawSetProportional(Wasted, 1);
	TextDrawSetShadow(Wasted, 3);

	TD_PressH = TextDrawCreate(410.0, 190.0, "press Y");
	TextDrawAlignment(TD_PressH, 2);
	TextDrawBackgroundColor(TD_PressH, 255);
	TextDrawFont(TD_PressH, 2);
	TextDrawLetterSize(TD_PressH, 0.2, 1.3);
	TextDrawColor(TD_PressH, -751619141);
	TextDrawSetOutline(TD_PressH, 0);
	TextDrawSetProportional(TD_PressH, 1);
	TextDrawSetShadow(TD_PressH, 0);
	TextDrawUseBox(TD_PressH, 1);
	TextDrawBoxColor(TD_PressH, INTERFACE_MAIN_COLOR);
	TextDrawTextSize(TD_PressH, 0.0, 50.0);
}

IFace.Player_Load_Player(playerid)
{
	HealthBar = CreatePlayerTextDraw(playerid, 570.0, 67.0, "50HP");
	PlayerTextDrawFont(playerid, HealthBar, 1);
	PlayerTextDrawLetterSize(playerid, HealthBar, 0.2, 0.799999);
	PlayerTextDrawColor(playerid, HealthBar, -1);
	PlayerTextDrawSetOutline(playerid, HealthBar, 1);
	PlayerTextDrawSetShadow(playerid, HealthBar, 1);

	StatusGPS = CreatePlayerTextDraw(playerid, 90.0, 430.0, "_");
	PlayerTextDrawAlignment(playerid, StatusGPS, 2);
	PlayerTextDrawBackgroundColor(playerid, StatusGPS, 85);
	PlayerTextDrawFont(playerid, StatusGPS, 2);
	PlayerTextDrawLetterSize(playerid, StatusGPS, 0.2, 1.0);
	PlayerTextDrawColor(playerid, StatusGPS, -1);
	PlayerTextDrawSetOutline(playerid, StatusGPS, 1);
	PlayerTextDrawSetProportional(playerid, StatusGPS, 1);

	changeMoneyTD = CreatePlayerTextDraw(playerid, 600.0, 320.0, "~g~+$100");
	PlayerTextDrawAlignment(playerid, changeMoneyTD, 3);
	PlayerTextDrawBackgroundColor(playerid, changeMoneyTD, 255);
	PlayerTextDrawFont(playerid, changeMoneyTD, 3);
	PlayerTextDrawLetterSize(playerid, changeMoneyTD, 0.9, 3.0);
	PlayerTextDrawColor(playerid, changeMoneyTD, -1);
	PlayerTextDrawSetOutline(playerid, changeMoneyTD, 1);
	PlayerTextDrawSetProportional(playerid, changeMoneyTD, 1);
}