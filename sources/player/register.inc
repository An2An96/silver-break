#if defined _player_register_included
	#endinput
#endif

#define _player_register_included

#include "player/walk"

new const Float:RegActorPos[][4] = {
	{ 1999.0, -1230.0, 20.8, 180.0 },
	{ 2000.5, -1230.0, 20.8, 180.0 },
	{ 2002.0, -1230.0, 20.8, 180.0 },
	{ 2003.5, -1230.0, 20.8, 180.0 },
	{ 2005.0, -1230.0, 20.8, 180.0 },
	{ 2006.5, -1230.0, 20.8, 180.0 }
};
new RegActor[MAX_PLAYERS][sizeof(RegActorPos)];

new Text:Reg_IFace_TD[5];

flags:testreg(CMD_DEVELOPER);
CMD:testreg(playerid, prams[])
{
	Reg_SetStep(playerid, 1);
	return true;
}

//	IFace
Public: IFace.Reg_OnPlayerClickTD(playerid, Text:clickedid)
{
	new step = GetPVarInt(playerid, "Player:Reg:Step");
	if(step)
	{
		if(clickedid == Text:INVALID_TEXT_DRAW)
		{
			if(step < 4)
			{
				SelectTextDraw(playerid, 0xFFFFFFAA);
				if(step > 1)	Reg_SetStep(playerid, step - 1);
				return true;
			}
		}

		//	Выбор скина и пола
		if(step == 1)
		{
			if(clickedid == Reg_IFace_TD[0])			CreateRegActors(playerid, 1);
			else if(clickedid == Reg_IFace_TD[1])		CreateRegActors(playerid, 0);
			else if(clickedid == Reg_IFace_TD[2])		NextRegSkin(playerid);
			else if(clickedid == Reg_IFace_TD[3])		DownRegSkin(playerid);
			else if(clickedid == Reg_IFace_TD[4])
			{
				TextDrawHideForPlayer(playerid, Reg_IFace_TD[0]);
				TextDrawHideForPlayer(playerid, Reg_IFace_TD[1]);
				Reg_SetStep(playerid, 2);
			}
			return true;		
		}
		//	Выбор походки
		else if(step == 2)
		{
			if(		clickedid == Reg_IFace_TD[0]
			||		clickedid == Reg_IFace_TD[1])		Reg_WalkAnim(playerid);
			else if(clickedid == Reg_IFace_TD[2])		Reg_NextAnim(playerid);
			else if(clickedid == Reg_IFace_TD[3])		Reg_DownAnim(playerid);
			else if(clickedid == Reg_IFace_TD[4])		Reg_SetStep(playerid, step + 1);
			return true;
		}
		//	Выбор личной анимации
		else if(step == 3)
		{
			if(		clickedid == Reg_IFace_TD[0]
			||		clickedid == Reg_IFace_TD[1])		Reg_MyAnim(playerid);
			else if(clickedid == Reg_IFace_TD[2])		Reg_NextAnim(playerid);
			else if(clickedid == Reg_IFace_TD[3])		Reg_DownAnim(playerid);
			else if(clickedid == Reg_IFace_TD[4])		Reg_SetStep(playerid, step + 1);
			return true;
		}
	}
	return CONTINUE;
}

Reg_IFace_Toggle(playerid, bool:toggle)
{
	if(toggle)
	{
		TextDrawShowForPlayer(playerid, Reg_IFace_TD[0]);
		TextDrawShowForPlayer(playerid, Reg_IFace_TD[1]);
		TextDrawShowForPlayer(playerid, Reg_IFace_TD[2]);
		TextDrawShowForPlayer(playerid, Reg_IFace_TD[3]);
		TextDrawShowForPlayer(playerid, Reg_IFace_TD[4]);
	}
	else
	{
		TextDrawHideForPlayer(playerid, Reg_IFace_TD[0]);
		TextDrawHideForPlayer(playerid, Reg_IFace_TD[1]);
		TextDrawHideForPlayer(playerid, Reg_IFace_TD[2]);
		TextDrawHideForPlayer(playerid, Reg_IFace_TD[3]);
		TextDrawHideForPlayer(playerid, Reg_IFace_TD[4]);
	}
}

Reg_SetStep(playerid, step)
{
	SetPVarInt(playerid, "Player:Reg:Step", step);
	if(step == 1)	//	выбор скина
	{
		PlayAudioStreamForPlayer(playerid, AUDIOFILE_PATH "/reg.mp3");
		SetPlayerVirtualWorld(playerid, VW_REG + playerid);
		
		CreateRegActors(playerid, 1);
		ShowRegSkin(playerid);
		Reg_IFace_Toggle(playerid, true);
		SelectTextDraw(playerid, 0xA32725FF);

		SetPlayerCameraPos(playerid, 2002.9, -1239.3, 21.7);
		SetPlayerCameraLookAt(playerid, 2002.5, -1230.0, 22.0);

		ClearChatbox(playerid, 20);
		SendClientMessage(playerid, COLOR_WHITE, "{0BDA51}Регистрация | {FFFFFF}Выберите пол и скин вашего персонажа.");
	}
	else if(step == 2)	//	выбор походки
	{
		PlayerInfo[playerid][pWalk] = 1;
		PlayerInfo[playerid][pAnim] = 1;

		new actor = GetPVarInt(playerid, "Player:Reg:Skin");
		new Float:x = RegActorPos[actor][0],
			Float:y = RegActorPos[actor][1],
			Float:z = RegActorPos[actor][2],
			Float:a = RegActorPos[actor][3];
		InterpolateCameraLookAt(playerid, 2002.0, -1230.0, 22.5, x, y, z + 0.5, 2000);

		GetXYInFrontOfPoint(x, y, a, 6.0);
		InterpolateCameraPos(playerid, 2002.9, -1239.3, 21.7, x, y, z + 0.5, 2000);

		Reg_WalkAnim(playerid);

		SendClientMessage(playerid, COLOR_WHITE, "{0BDA51}Регистрация | {FFFFFF}Выберите походку вашего персонажа.");
	}
	else if(step == 3)	//	выбор личной анимации
	{
		Reg_MyAnim(playerid);

		SendClientMessage(playerid, COLOR_WHITE, "{0BDA51}Регистрация | {FFFFFF}Выберите личную анимацию вашего персонажа.");
	}
	else if(step == 4)
	{
		//		удаление актеров
		for(new i = 0; i < sizeof(RegActorPos); i++)
		{
			if(RegActor[playerid][i] > 0)
			{
				DestroyActor(RegActor[playerid][i]);
				RegActor[playerid][i] = 0;
			}
			else break;
		}
		//		Установка скина
		if(PlayerInfo[playerid][pSex])
		{
			PlayerInfo[playerid][pSkin] = Newbie_Skin_Male[ GetPVarInt(playerid, "Player:Reg:Skin") ];
		}
		else
		{
			PlayerInfo[playerid][pSkin] = Newbie_Skin_Female[ GetPVarInt(playerid, "Player:Reg:Skin") ];
		}
		CancelSelectTextDraw(playerid);
		Reg_IFace_Toggle(playerid, false);
		RegisterCutScene(playerid, 1, 1, 1);
	}
	return true;
}

Reg_WalkAnim(playerid)
{
	new actor	= GetPVarInt(playerid, "Player:Reg:Skin");
	new anim	= PlayerInfo[playerid][pWalk];
	ApplyActorAnimation(RegActor[playerid][actor], "ped", WalkAnims[anim], 4.1, 1, 0, 0, 1, 0);
}

Reg_MyAnim(playerid)
{
	new actor	= GetPVarInt(playerid, "Player:Reg:Skin");
	new anim	= PlayerInfo[playerid][pAnim];
	ApplyActorAnimation(RegActor[playerid][actor], PlayerAnims[anim][PANIM_LIB], PlayerAnims[anim][PANIM_NAME], 4.1, 1, 0, 0, 1, 0);
}

Reg_NextAnim(playerid)
{
	new anim_type	= GetPVarInt(playerid, "Player:Reg:Step");
	if(anim_type == 2)
	{
		new anim	= PlayerInfo[playerid][pWalk] + 1;
		if(anim >= sizeof(WalkAnims))	anim = 1;
		PlayerInfo[playerid][pWalk] = anim;
		Reg_WalkAnim(playerid);
	}
	else if(anim_type == 3)
	{
		new anim	= PlayerInfo[playerid][pAnim] + 1;
		if(anim >= sizeof(PlayerAnims))	anim = 1;
		PlayerInfo[playerid][pAnim] = anim;
		Reg_MyAnim(playerid);
	}
}

Reg_DownAnim(playerid)
{
	new anim_type	= GetPVarInt(playerid, "Player:Reg:Step");
	if(anim_type == 2)
	{
		new anim = PlayerInfo[playerid][pWalk] - 1;
		if(anim < 1)
			anim = sizeof(WalkAnims) - 1;
		PlayerInfo[playerid][pWalk] = anim;
		Reg_WalkAnim(playerid);
	}
	else if(anim_type == 3)
	{
		new anim = PlayerInfo[playerid][pAnim] - 1;
		if(anim < 1)
			anim = sizeof(PlayerAnims) - 1;
		PlayerInfo[playerid][pAnim] = anim;
		Reg_MyAnim(playerid);
	}
}

CreateRegActors(playerid, sex)
{
	//if(sex == SelectSex[playerid])	return false;
	for(new i = 0; i < sizeof(RegActorPos); i++)
	{
		if(RegActor[playerid][i] > 0)
		{
			DestroyActor(RegActor[playerid][i]);
			RegActor[playerid][i] = 0;
		}
		else break;
	}
	if(sex)
	{
		for(new i = 0; i < sizeof(RegActorPos); i++)
		{
			if(i >= sizeof(Newbie_Skin_Male))	break;
			RegActor[playerid][i] = CreateActor(Newbie_Skin_Male[i], Arr4<RegActorPos[i]>);
			SetActorVirtualWorld(RegActor[playerid][i], VW_REG + playerid);
		}
	}
	else
	{
		for(new i = 0; i < sizeof(RegActorPos); i++)
		{
			if(i >= sizeof(Newbie_Skin_Female))	break;
			RegActor[playerid][i] = CreateActor(Newbie_Skin_Female[i], Arr4<RegActorPos[i]>);
			SetActorVirtualWorld(RegActor[playerid][i], VW_REG + playerid);
		}
	}
	PlayerInfo[playerid][pSex] = sex;
	SetPVarInt(playerid, "Player:Reg:Skin", 0);
	ShowRegSkin(playerid);
	return true;
}

ShowRegSkin(playerid)
{
	new actor = GetPVarInt(playerid, "Player:Reg:Skin");
	SetActorPos(RegActor[playerid][actor], RegActorPos[actor][0], RegActorPos[actor][1] - 2.0, RegActorPos[actor][2]);
	ApplyActorAnimation(RegActor[playerid][actor], "ped", "XPRESSscratch", 4.1, 1, 0, 0, 0, 0);
	return true;
}

NextRegSkin(playerid)
{
	new actor = GetPVarInt(playerid, "Player:Reg:Skin");
	SetActorPos(RegActor[playerid][actor], Arr3<RegActorPos[actor]>);
	ClearActorAnimations(RegActor[playerid][actor]);

	actor++;
	if(PlayerInfo[playerid][pSex] == 1)
	{
		if(actor >= sizeof(Newbie_Skin_Male))	actor = 0;
	} 
	else
	{
		if(actor >= sizeof(Newbie_Skin_Female))	actor = 0;
	}
	SetPVarInt(playerid, "Player:Reg:Skin", actor);
	ShowRegSkin(playerid);
	return true;
}

DownRegSkin(playerid)
{
	new actor = GetPVarInt(playerid, "Player:Reg:Skin");
	SetActorPos(RegActor[playerid][actor], Arr3<RegActorPos[actor]>);
	ClearActorAnimations(RegActor[playerid][actor]);

	actor--;
	if(PlayerInfo[playerid][pSex] == 1)
	{
		if(actor < 0)	actor = sizeof(Newbie_Skin_Male) - 1;
	} 
	else
	{
		if(actor < 0)	actor = sizeof(Newbie_Skin_Female) - 1;
	}
	SetPVarInt(playerid, "Player:Reg:Skin", actor);
	ShowRegSkin(playerid);
	return true;
}

//	CutScene
Public: RegisterCutScene(playerid, cutscene, move, nextscene)
{
	new a = 1, time = 10000, interior = 0;
	if(move == 0)	a = 10000;
	switch(cutscene)
	{
		//	EPISOD 1:	CITY
		case 1:
		{
			SetPVarInt(playerid, "RegCutSceneState", 1);
			return FadeColorForPlayer(playerid, 0, 0, 0, 0, 0, 0, 0, 255, 15);
		}
		case 2:
		{
			//TextDrawTVEffect(playerid, true);
			MyShowPlayerDialog(playerid, DMODE_NONE, DIALOG_STYLE_MSGBOX, " ", "{CFB53B}Нажмите пробел, если хотите пропустить заставку", "Закрыть", "");
			PlayAudioStreamForPlayer(playerid, AUDIOFILE_PATH "/music_1.mp3");
			ClearChatbox(playerid, 20);
			SetPlayerVirtualWorld(playerid, VW_CUTSCENE);
			SetPlayerWeather(playerid, 6);
			SetPlayerTime(playerid, 7, 0);
			InterpolateCameraPos(playerid, 1558.0, -1552.0, 14.0, 1568.0, -1565.0, 14.0, 1000 * 90);
			InterpolateCameraLookAt(playerid, 1568.0, -1531.0, 28.0, 1578.0, -1544.0, 28.0, 1000 * 90);
			time = 4000;
		}
		case 3:
		{
			FadeColorForPlayer(playerid, 0, 0, 0, 255, 205, 164, 52, 30, 30);	// Открывает занавес
			time = 5000;
		}
		case 4:
		{
			SetPlayerWeather(playerid, 2);
			SetPlayerTime(playerid, 7, 0);
			InterpolateCameraPos(playerid, 2465.8, -1851.0, 3.0, 2383.0, -1850.0, 3.0, 1000 * 60 * a);
			InterpolateCameraLookAt(playerid, 2383.0, -1850.0, 9.0, 2383.0, -1850.0, 9.0, 1000 * 60 * a);
			FadeColorForPlayer(playerid, 172, 183, 142, 30, 172, 183, 142, 30, 1);
			time = 5000;
		}
		case 5:
		{
			SetPlayerWeather(playerid, 14);
			SetPlayerTime(playerid, 12, 0);
			InterpolateCameraPos(playerid, -1437.8, -1514.7, 118.0, -1434.0, -1515.3, 118.0, 1000 * 25 * a);
			InterpolateCameraLookAt(playerid, -1471.0, -1590.5, 120.0, -1471.0, -1590.5, 117.0, 1000 * 25 * a);
			FadeColorForPlayer(playerid, 205, 164, 52, 30, 205, 164, 52, 30, 1);
			time = 4000;
		}
		//	EPISOD 3:	MAFIA
		case 6:
		{
			SetPlayerWeather(playerid, 4);
			SetPlayerTime(playerid, 12, 0);
			InterpolateCameraPos(playerid, 1609.6, -1529.0, 13.2, 1607.2, -1529.9, 13.2, 1000 * 15 * a);
			InterpolateCameraLookAt(playerid, 1610.7, -1556.3, 13.2, 1608.3, -1557.2, 13.2, 1000 * 15 * a);
			FadeColorForPlayer(playerid, 172, 183, 142, 30, 172, 183, 142, 30, 1);
			time = 4000;
		}
		case 7:
		{
			SetPlayerWeather(playerid, 4);
			SetPlayerTime(playerid, 12, 0);
			InterpolateCameraPos(playerid, 1607.8, -1536.0, 13.2, 1607.8, -1543.0, 13.2, 1000 * 20 * a);
			InterpolateCameraLookAt(playerid, 1607.8, -1560.3, 13.6, 1607.8, -1560.3, 13.6, 1000 * 20 * a);
			time = 5000;
		}
		case 8:
		{
			SetPlayerWeather(playerid, 4);
			SetPlayerTime(playerid, 12, 0);
			InterpolateCameraPos(playerid, 1607.8, -1556.0, 14.2, 1607.8, -1540.8, 14.2, 1000 * 35 * a);
			InterpolateCameraLookAt(playerid, 1607.8, -1540.8, 14.2, 1607.8, -1540.8, 14.2, 1000 * 35 * a);
			time = 5000;
		}
		//	HOUSE
		case 9:
		{
			interior = 1;
			InterpolateCameraPos(playerid, 2528.4, -1678.5, 1015.0, 2531.6, -1680.6, 1015.0, 1000 * 40 * a);
			InterpolateCameraLookAt(playerid, 2535.9, -1673.3, 1015.5, 2535.9, -1673.3, 1015.5, 1000 * 40 * a);
			FadeColorForPlayer(playerid, 220, 224, 206, 20, 220, 224, 206, 20, 1);
			time = 3000;
		}
		case 10:
		{
			interior = 1;
			InterpolateCameraPos(playerid, 2525.0, -1674.5, 1016.0, 2530.0, -1674.5, 1016.0, 1000 * 20 * a);
			InterpolateCameraLookAt(playerid, 2533.15, -1674.5, 1015.5, 2533.15, -1674.5, 1015.5, 1000 * 20 * a);
			//	ЕСЛИ В InterpolateCameraLookAt ЗАДАТЬ ОДИНАКОВЫЕ КООРДИНАТЫ ТО МОЖНО КРУТИТЬ КАМЕРОЙ ВО ВРЕМЯ ПОЛЕТА!!
			time = 5000;
		}
		case 11:
		{
			interior = 1;
			InterpolateCameraPos(playerid, 2538.4, -1674.5, 1015.6, 2532.4, -1674.5, 1015.6, 1000 * 25 * a);
			InterpolateCameraLookAt(playerid, 2530.0, -1674.5, 1015.6, 2530.0, -1674.5, 1015.6, 1000 * 25 * a);
			time = 4000;
		}
		case 12:
		{
			FadeColorForPlayer(playerid, 0, 0, 0, 0, 0, 0, 0, 255, 30);	// Закрываем занавес
			SetPVarInt(playerid, "RegCutSceneState", 2);
			return true;
		}
		//	EPISOD 1:	POLICE
		case 13:
		{
			SetPlayerWeather(playerid, 9);
			SetPlayerTime(playerid, 22, 0);
			InterpolateCameraPos(playerid, 1422.0, -1338.0, 14.2, 1422.0, -1338.0 - 5.0, 14.2, 1000 * 20 * a);
			InterpolateCameraLookAt(playerid, 1422.0, -1345.9, 14.0, 1422.0, -1345.9, 14.0, 1000 * 20 * a);
			time = 1000;
		}
		case 14:
		{
			FadeColorForPlayer(playerid, 0, 0, 0, 255, 21, 23, 25, 80, 30);	// Открывает занавес
			time = 7000;
		}
		case 15:
		{
			InterpolateCameraPos(playerid, 1427.6, -1333.9, 13.2, 1425.5, -1333.3, 13.2, 1000 * 20 * a);
			InterpolateCameraLookAt(playerid, 1401.5, -1354.9, 15.8, 1401.5, -1354.9, 15.8, 1000 * 20 * a);
			time = 3000;
		}
		case 16:
		{
			InterpolateCameraPos(playerid, 1419.3, -1352.3, 13.3, 1417.0, -1352.3, 13.3, 1000 * 30 * a);
			InterpolateCameraLookAt(playerid, 1422.0, -1346.2, 13.7, 1419.7, -1344.2, 13.7, 1000 * 30 * a);
			time = 5000;
		}
		//
		case 17:
		{
			//	Спавним
			SetPlayerSpawn(playerid);
			UpdatePlayerSkin(playerid);
			TogglePlayerSpectating(playerid, false);

			new hour, minute;
			gettime(hour, minute, _);
			SetPlayerTime(playerid, hour, minute);
			SetPlayerWeather(playerid, 3);

			InterpolateCameraPos(playerid, 1694.548095, -2359.543212, 16.408246, 1693.325561, -2341.765136, 16.095087, 1000 * 30 * a);
			InterpolateCameraLookAt(playerid, 1689.671508, -2358.452880, 16.233711, 1688.354003, -2341.568847, 15.599807, 1000 * 30 * a);

			FadeColorForPlayer(playerid, 220, 224, 206, 20, 220, 224, 206, 20, 1);
			time = 5000;
		}
		case 18:
		{
			//new Float:x = 1651.11,
			//	Float:y = -2285.87,
			//	Float:z = -0.61;

			//new name[MAX_PLAYER_NAME];
			//GetPlayerName(playerid, name, MAX_PLAYER_NAME);
			//CutSceneText[playerid][0] = CreateWorldText(name, 1651.11, -2285.87, -0.61, 0.0, 0.0, 80.0, VW_CUTSCENE);	//	1651.11, -2285.87, -0.61
			//SetWorldTextFontface(CutSceneText[playerid][0], "Tahoma");
			//SetWorldTextFontsize(CutSceneText[playerid][0], 36);
			//SetWorldTextBold(CutSceneText[playerid][0], true);

			//CutSceneText[playerid][1] = CreateWorldText("what is your role?", x - 1.56, y - 0.4, z + 0.2, 0.0, 0.0, 77.0, VW_CUTSCENE);
			//SetWorldTextFontface(CutSceneText[playerid][1], "Tahoma");
			//SetWorldTextFontsize(CutSceneText[playerid][1], 36);

			InterpolateCameraPos(playerid, 1695.060668, -2350.765136, 13.126622, 1677.407104, -2351.107910, 13.023011, 1000 * 25 * a);
			InterpolateCameraLookAt(playerid, 1690.061157, -2350.759033, 13.061429, 1672.408691, -2351.183837, 13.121871, 1000 * 25 * a);
			time = 5000;
		}
		case 19:
		{
			InterpolateCameraPos(playerid, 1672.634399, -2351.706054, 14.514422, 1652.495117, -2351.874511, 14.034745, 1000 * 20 * a);
			InterpolateCameraLookAt(playerid, 1667.639404, -2351.674804, 14.291837, 1647.496948, -2351.950439, 13.921473, 1000 * 20 * a);
			time = 6000;
		}
		case 20:
		{
			FadeColorForPlayer(playerid, 220, 224, 206, 20, 0, 0, 0, 255, 60);	// Закрываем занавес
			SetPVarInt(playerid, "RegCutSceneState", 3);
			return true;
		}
		case 21:
		{
			DestroyWorldText(CutSceneText[playerid][0]);
			DestroyWorldText(CutSceneText[playerid][1]);
			time = 2000;
		}
		case 22:
		{
			DeletePVar(playerid, "RegCutSceneState");
			OnPlayerLogged(playerid);
			KillTimer(LoginCameraTimer[playerid]);
			//TextDrawHideForPlayer(playerid, TD_TutTitle);
			//TextDrawHideForPlayer(playerid, TD_TutTitle2);
			//FadeColorForPlayer(playerid, 0, 0, 0, 255, 0, 0, 0, 0, 15);	// Открывает занавес
			return true;
		}
	}
	SetPlayerInterior(playerid, interior);
	if(nextscene)
	{
		LoginCameraTimer[playerid] = SetTimerEx("RegisterCutScene", time, false, "dddd", playerid, cutscene + 1, move, nextscene);
	}
	return true;
}

Reg_IFace_Create_Base()
{
	Reg_IFace_TD[0] = TextDrawCreate(290.000000, 370.000000, "Male");
	TextDrawAlignment(Reg_IFace_TD[0], 2);
	TextDrawBackgroundColor(Reg_IFace_TD[0], 255);
	TextDrawFont(Reg_IFace_TD[0], 1);
	TextDrawLetterSize(Reg_IFace_TD[0], 0.300000, 1.000000);
	TextDrawColor(Reg_IFace_TD[0], -1);
	TextDrawSetOutline(Reg_IFace_TD[0], 0);
	TextDrawSetProportional(Reg_IFace_TD[0], 1);
	TextDrawSetShadow(Reg_IFace_TD[0], 0);
	TextDrawUseBox(Reg_IFace_TD[0], 1);
	TextDrawBoxColor(Reg_IFace_TD[0], 404431103);
	TextDrawTextSize(Reg_IFace_TD[0], 10.000000, 50.000000);
	TextDrawSetSelectable(Reg_IFace_TD[0], true);

	Reg_IFace_TD[1] = TextDrawCreate(345.000000, 370.000000, "Female");
	TextDrawAlignment(Reg_IFace_TD[1], 2);
	TextDrawBackgroundColor(Reg_IFace_TD[1], 255);
	TextDrawFont(Reg_IFace_TD[1], 1);
	TextDrawLetterSize(Reg_IFace_TD[1], 0.300000, 1.000000);
	TextDrawColor(Reg_IFace_TD[1], -1);
	TextDrawSetOutline(Reg_IFace_TD[1], 0);
	TextDrawSetProportional(Reg_IFace_TD[1], 1);
	TextDrawSetShadow(Reg_IFace_TD[1], 0);
	TextDrawUseBox(Reg_IFace_TD[1], 1);
	TextDrawBoxColor(Reg_IFace_TD[1], 404431103);
	TextDrawTextSize(Reg_IFace_TD[1], 10.000000, 50.000000);
	TextDrawSetSelectable(Reg_IFace_TD[1], true);

	Reg_IFace_TD[2] = TextDrawCreate(380.000000, 370.000000, ">");
	TextDrawAlignment(Reg_IFace_TD[2], 2);
	TextDrawBackgroundColor(Reg_IFace_TD[2], 255);
	TextDrawFont(Reg_IFace_TD[2], 1);
	TextDrawLetterSize(Reg_IFace_TD[2], 0.300000, 2.699999);
	TextDrawColor(Reg_IFace_TD[2], -1);
	TextDrawSetOutline(Reg_IFace_TD[2], 0);
	TextDrawSetProportional(Reg_IFace_TD[2], 1);
	TextDrawSetShadow(Reg_IFace_TD[2], 0);
	TextDrawUseBox(Reg_IFace_TD[2], 1);
	TextDrawBoxColor(Reg_IFace_TD[2], 404431103);
	TextDrawTextSize(Reg_IFace_TD[2], 22.000000, 10.000000);
	TextDrawSetSelectable(Reg_IFace_TD[2], true);

	Reg_IFace_TD[3] = TextDrawCreate(255.000000, 370.000000, "<");
	TextDrawAlignment(Reg_IFace_TD[3], 2);
	TextDrawBackgroundColor(Reg_IFace_TD[3], 255);
	TextDrawFont(Reg_IFace_TD[3], 1);
	TextDrawLetterSize(Reg_IFace_TD[3], 0.300000, 2.699999);
	TextDrawColor(Reg_IFace_TD[3], -1);
	TextDrawSetOutline(Reg_IFace_TD[3], 0);
	TextDrawSetProportional(Reg_IFace_TD[3], 1);
	TextDrawSetShadow(Reg_IFace_TD[3], 0);
	TextDrawUseBox(Reg_IFace_TD[3], 1);
	TextDrawBoxColor(Reg_IFace_TD[3], 404431103);
	TextDrawTextSize(Reg_IFace_TD[3], 22.000000, 10.000000);
	TextDrawSetSelectable(Reg_IFace_TD[3], true);

	Reg_IFace_TD[4] = TextDrawCreate(317.500000, 385.000000, "Accept");
	TextDrawAlignment(Reg_IFace_TD[4], 2);
	TextDrawBackgroundColor(Reg_IFace_TD[4], 255);
	TextDrawFont(Reg_IFace_TD[4], 1);
	TextDrawLetterSize(Reg_IFace_TD[4], 0.300000, 1.000000);
	TextDrawColor(Reg_IFace_TD[4], -1);
	TextDrawSetOutline(Reg_IFace_TD[4], 0);
	TextDrawSetProportional(Reg_IFace_TD[4], 1);
	TextDrawSetShadow(Reg_IFace_TD[4], 0);
	TextDrawUseBox(Reg_IFace_TD[4], 1);
	TextDrawBoxColor(Reg_IFace_TD[4], 404431103);
	TextDrawTextSize(Reg_IFace_TD[4], 10.000000, 105.000000);
	TextDrawSetSelectable(Reg_IFace_TD[4], true);
	return true;
}

stock CreateCutSceneDecor()
{
	new id;
//	Печатающий бот при авторизации
	//id = CreateActor(2, 364.3, 152.4, 1025.8, 3.0);
	//SetActorVirtualWorld(id, VW_CUTSCENE);
	//ApplyActorAnimation(id, "INT_OFFICE", "OFF_Sit_Bored_Loop", 4.1, 1, 0, 0, 0, 0);

	//id = CreateActor(2, 1469.50, -1682.93, 14.04, 272.18);
	//SetActorVirtualWorld(id, VW_CUTSCENE);
	//ApplyActorAnimation(id, "PED", "SEAT_down", 4.1, 0, 0, 0, 1, 1);

	id = CreateActor(111, 1483.37, -1765.19, 70.42, 342.76);
	SetActorVirtualWorld(id, VW_LOGIN);
	ApplyActorAnimation(id, "MISC", "Seat_talk_02", 4.1, 1, 0, 0, 0, 0);

//	Кат сцена города
	id = CreateWorldText("developed by", 1559.75, -1549.33, 15.95, 0.0, 0.0, -70.0, VW_CUTSCENE);
	SetWorldTextFontface(id, "Tahoma");
	SetWorldTextFontsize(id, 25);

	id = CreateWorldText("Borog25 & Impereal", 1559.8, -1549.5, 15.85, 0.0, 0.0, -70.0, VW_CUTSCENE);
	SetWorldTextFontface(id, "Tahoma");
	SetWorldTextFontsize(id, 24);
	SetWorldTextBold(id, true);

//	Кат сцена с мафией
	id = CreateWorldText("mafia", 1608.5, -1549.7, 14.6, 0.0, 0.0, 0.0, VW_CUTSCENE);
	SetWorldTextFontface(id, "Tahoma");
	SetWorldTextFontsize(id, 36);

	id = CreateWorldText("Jacob Dickinson", 1608.32, -1551.57, 14.35, 0.0, 0.0, 5.0, VW_CUTSCENE);
	SetWorldTextFontface(id, "Tahoma");
	SetWorldTextFontsize(id, 36);
	SetWorldTextBold(id, true);

	id = CreateActor(112, 1607.8, -1549.8, 13.6, 0.0);
	SetActorVirtualWorld(id, VW_CUTSCENE);
	id = MyCreateVehicle(579, 1604.15, -1553.05, 13.52, 317.4, 0, 0);
	SetVehicleVirtualWorld(id, VW_CUTSCENE);
	VehInfo[id][vLights] = true;
	UpdateVehicleParamsEx(id);

//	Кат сцена в доме
	id = CreateWorldText("governor", 2534.0, -1675.3, 1015.93, 0.0, 0.0, 90.0, VW_CUTSCENE);
	SetWorldTextFontface(id, "Tahoma");
	SetWorldTextFontsize(id, 24);

	id = CreateWorldText("John Kerry", 2535.0, -1675.0, 1015.74, 0.0, 0.0, 90.0, VW_CUTSCENE);
	SetWorldTextFontface(id, "Tahoma");
	SetWorldTextFontsize(id, 36);
	SetWorldTextBold(id, true);

	id = CreateActor(147, 2533.15, -1674.5, 1015.5, 270.0);
	SetActorVirtualWorld(id, VW_CUTSCENE);
	ApplyActorAnimation(id, "ped", "SEAT_idle", 4.1, 1, 0, 0, 0, 0);

//	Кат сцена с полицейским
	id = CreateWorldText("Daniel Forster", 1420.459, -1348.445, 13.905, 0.0, 0.0, -20.0, VW_CUTSCENE);
	SetWorldTextFontface(id, "Tahoma");
	SetWorldTextFontsize(id, 32);
	SetWorldTextBold(id, true);

	id = CreateWorldText("detective", 1420.902, -1347.675, 14.164, 0.0, 0.0, -20.0, VW_CUTSCENE);
	SetWorldTextFontface(id, "Tahoma");
	SetWorldTextFontsize(id, 36);

	CreateDynamicObject(19281, 1422.87, -1347.54, 13.20, 0.0, 0.0, 0.0, VW_CUTSCENE);//	свет фар
	CreateDynamicObject(19281, 1421.14, -1347.59, 13.16, 0.0, 0.0, 0.0, VW_CUTSCENE);//	свет фар

	//	Мигалка
	CreateDynamicObject(19290, 1421.4, -1350.3, 14.2, 0.0, 0.0, 0.0, VW_CUTSCENE);
	CreateDynamicObject(19292, 1421.8, -1350.3, 14.2, 0.0, 0.0, 0.0, VW_CUTSCENE);
	CreateDynamicObject(19290, 1422.2, -1350.3, 14.2, 0.0, 0.0, 0.0, VW_CUTSCENE);
	CreateDynamicObject(19292, 1422.7, -1350.3, 14.2, 0.0, 0.0, 0.0, VW_CUTSCENE);

	id = CreateActor(288, 1422.0, -1346.2, 13.6, 357.0);
	SetActorVirtualWorld(id, VW_CUTSCENE);
	id = MyCreateVehicle(596, 1422.0, -1350.0, 13.6, 0.0, 0, 90);
	SetVehicleVirtualWorld(id, VW_CUTSCENE);
	VehInfo[id][vLights] = true;
	UpdateVehicleParamsEx(id);
	return true;
}