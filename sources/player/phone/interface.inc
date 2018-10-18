stock IFace.Phone_Show(playerid, status)
{
	IFace.ToggleGroup(playerid, IFace.PHONE, true);

	new stmp[128];
	new giveplayerid = call_phone[playerid][0];
	if(status == 1)		// ты звонишь
	{
		format(stmp, 128, "Исходящий вызов...~n~%s~n~Номер: %d", ReturnPlayerName(giveplayerid), PlayerInfo[giveplayerid][pPhoneNumber]);
	}
	else if(status == 2)	//  тебе звонят
	{
		format(stmp, 128, "Входящий вызов...~n~%s~n~Номер: %d", ReturnPlayerName(giveplayerid), PlayerInfo[giveplayerid][pPhoneNumber]);
	}
	else if(status == 3)	//  разговор
	{
		format(stmp, 128, "00:00~n~%s~n~Номер: %d", ReturnPlayerName(giveplayerid), PlayerInfo[giveplayerid][pPhoneNumber]);
	}
	if(strlen(stmp))
	{
		IFace.Phone_Update(playerid, stmp);
	}
	return true;
}

stock IFace.Phone_Update(playerid, text[])
{
	if(IFace.GetGroupToggleAndVisible(playerid, IFace.PHONE))
	{
		PlayerTextDrawSetString(playerid, p_phone_td, RusText(text, isRus(playerid)));
		PlayerTextDrawShow(playerid, p_phone_td);
	}
}

stock IFace.Phone_Hide(playerid)
{
	IFace.ToggleGroup(playerid, IFace.PHONE, false);
	return true;
}

Public: IFace.Phone_Toggle(playerid, bool:toggle)
{
	if(toggle)
	{
		TextDrawShowForPlayer(playerid, phone_td[0]);
		TextDrawShowForPlayer(playerid, phone_td[1]);
	}
	else
	{
		TextDrawHideForPlayer(playerid, phone_td[0]);
	 	TextDrawHideForPlayer(playerid, phone_td[1]);
		PlayerTextDrawHide(playerid, p_phone_td);
	}
}

IFace.Phone_Load_Base()
{
	phone_td[0] = TextDrawCreate(PHONE_BASE_POS_X, PHONE_BASE_POS_Y, "1");
	TextDrawBackgroundColor(phone_td[0], 255);
	TextDrawFont(phone_td[0], 1);
	TextDrawLetterSize(phone_td[0], 0.0, 3.0999);
	TextDrawColor(phone_td[0], -1);
	TextDrawSetOutline(phone_td[0], 0);
	TextDrawSetProportional(phone_td[0], 1);
	TextDrawSetShadow(phone_td[0], 0);
	TextDrawUseBox(phone_td[0], 1);
	TextDrawBoxColor(phone_td[0], INTERFACE_MAIN_COLOR);
	TextDrawTextSize(phone_td[0], 150.0, 110.0);

	phone_td[1] = TextDrawCreate(PHONE_BASE_POS_X - 25.0, PHONE_BASE_POS_Y - 5.0, "1");
	TextDrawAlignment(phone_td[1], 2);
	TextDrawBackgroundColor(phone_td[1], 0x00000000);
	TextDrawFont(phone_td[1], 5);
	TextDrawUseBox(phone_td[1], 1);
	TextDrawBoxColor(phone_td[1], 0x00000000);
	TextDrawTextSize(phone_td[1], 40.0, 40.0);
	TextDrawLetterSize(phone_td[1], 0.0, 0.0);
	TextDrawSetPreviewModel(phone_td[1], 18871);
	TextDrawSetPreviewRot(phone_td[1], 90.0, 181.0, 0.0, 0.8);
}

IFace.Phone_Load_Player(playerid)
{
	p_phone_td = CreatePlayerTextDraw(playerid, PHONE_BASE_POS_X + 15.0, PHONE_BASE_POS_Y, "text");
	PlayerTextDrawBackgroundColor(playerid, p_phone_td, 255);
	PlayerTextDrawFont(playerid, p_phone_td, 1);
	PlayerTextDrawLetterSize(playerid, p_phone_td, 0.23, 0.899);
	PlayerTextDrawColor(playerid, p_phone_td, -1);
	PlayerTextDrawSetOutline(playerid, p_phone_td, 0);
	PlayerTextDrawSetProportional(playerid, p_phone_td, 1);
	PlayerTextDrawSetShadow(playerid, p_phone_td, 0);
}