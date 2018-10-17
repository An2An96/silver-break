#if defined _core_interface_included
	#endinput
#endif

#define _core_interface_included

#include "interface/header"

//---	Global TD
new
	Text:BuyHelp,
	Text:lbt, Text:lbb,
	//Text:TD_Loading,
	Text:tdChooseButton1,
	Text:tdChooseButton2,
	Text:PayNSprayColorMenu[67];
	//Text:TD_TutTitle,
    //Text:TD_TutTitle2;

//  Players TD
new PlayerText:BuyInfo,
	PlayerText:BuyPrice,
	PlayerText:tdChoosePrice,
	PlayerText:tdChooseItemL,
	PlayerText:tdChooseItemR,
	PlayerText:debugTD,
	PlayerText:p_JailPeriod,
	PlayerText:InfoBar,
	PlayerText:PTD_AttachHealth[3];

enum IFace.E_GROUP_INFO
{
	bool:giToggle,
	bool:giShow,
}

static IFace.Groups[MAX_PLAYERS][IFace.E_GROUPS][IFace.E_GROUP_INFO];

enum
{
	ADDICTION_DIRECT,
	ADDICTION_OPPOSITE,
}

static IFace.E_GROUPS:IFace.Addictions[IFace.E_GROUPS][3][15];
static IFace.AddictionsCount[IFace.E_GROUPS][3];

//	This function changes visibility groups of text-draws because they require change total or temporary visibility
//	element				- id of element which require change visibility
//	toggle 				- state visibility which is required
//	changeVisibility	- flag which is indicates on temporary change visibility
stock IFace.ChangeGroupState(playerid, IFace.E_GROUPS:element, bool:toggle, bool:changeVisibility)
{
	if(!IsNull(IFace.GroupsInfo[element][gFunction]))
	{
		CallLocalFunction(IFace.GroupsInfo[element][gFunction], "ddd", playerid, toggle, changeVisibility);
	}
	else
	{
		switch(element)
		{
			case IFace.TV_EFFECT:
			{
				if(toggle)
				{
					TextDrawShowForPlayer(playerid, lbb);
					TextDrawShowForPlayer(playerid, lbt);	
				}
				else
				{
					TextDrawHideForPlayer(playerid, lbt);
					TextDrawHideForPlayer(playerid, lbb);
				}
			}
			case IFace.LOGO:
			{
				if(toggle)
				{
					TextDrawShowForPlayer(playerid, LogoTD[0]);
					TextDrawShowForPlayer(playerid, LogoTD[1]);
				}
				else
				{
					TextDrawHideForPlayer(playerid, LogoTD[0]);
					TextDrawHideForPlayer(playerid, LogoTD[1]);
				}
			}
			case IFace.RESTART:
			{
				if(toggle)
				{
					TextDrawShowForPlayer(playerid, RestartInfo);
				}
				else
				{
					TextDrawHideForPlayer(playerid, RestartInfo);
				}
			}
		}
	}

	//	Активация/Деактивация мыши
	if(IFace.GroupsInfo[element][gToggleMouse])
	{
		if(toggle)
		{
			SelectTextDraw(playerid, INTERFACE_SELECT_COLOR);
		}
		else
		{
			new bool:noCancelSelectTD;
			for(new IFace.E_GROUPS:i; i < IFace.E_GROUPS; i++)
			{
				if(element == i)	continue;
				if(IFace.GroupsInfo[i][gToggleMouse])
				{
					if(IFace.GetGroupToggleAndVisible(playerid, i))
					{
						noCancelSelectTD = true;
						break;
					}
				}
			}
			if(noCancelSelectTD)	SelectTextDraw(playerid, INTERFACE_SELECT_COLOR);
			else 					CancelSelectTextDraw(playerid);
		}
	}

	IFace.ChangeLinksGroups(playerid, element, toggle);

	CallLocalFunction("OnPlayerChangeInterface", "ddd", playerid, _:element, toggle);
	return true;
}

//	Проверяет можно ли изменить состояние группы (element)
Public: IFace.IsChangeGroupToggle(playerid, IFace.E_GROUPS:element, bool:toggle, bool:changeVisibility)
{
	if(changeVisibility)
	{
		if(!IFace.GetGroupToggle(playerid, element) || IFace.GetGroupVisible(playerid, element) == _:toggle)
		{
			return false;
		}
	}
	else
	{
		if(IFace.GetGroupToggle(playerid, element) == _:toggle || !IFace.GetGroupVisible(playerid, element))
		{
			return false;
		}
	}
	
	if(toggle)
	{
		for(new IFace.E_GROUPS:j; j < IFace.E_GROUPS; j++)
		{
			if(element == j)	continue;

			if(IFace.GetGroupToggleAndVisible(playerid, j))
			{
				for(new i = 0; i < IFace.AddictionsCount[j][ADDICTION_OPPOSITE]; i++)
				{
					if(IFace.Addictions[j][ADDICTION_OPPOSITE][i] == element)
					{
						return false;
					}
				}
			}
		}
	}
	else
	{
		for(new IFace.E_GROUPS:j; j < IFace.E_GROUPS; j++)
		{
			if(element == j)	continue;

			if(IFace.GetGroupToggleAndVisible(playerid, j))
			{
				for(new i = 0; i < IFace.AddictionsCount[j][ADDICTION_DIRECT]; i++)
				{
					if(IFace.Addictions[j][ADDICTION_DIRECT][i] == element)
					{
						return false;
					}
				}
			}
		}
	}

	if(!CallLocalFunction("IsPlayerChangeInterface", "ddd", playerid, _:element, toggle))
	{
		return false;
	}

	switch(element)
	{
		#if defined _interface_progress_included
			case IFace.PROGRESS:
			{
				if(toggle)
				{
					if(PlayerInfo[playerid][pJailTime])
					{
						PlayerTextDrawHide(playerid, p_JailPeriod);
					}	
				}
				else
				{
					if(PlayerInfo[playerid][pJailTime])
					{
						PlayerTextDrawShow(playerid, p_JailPeriod);
					}
				}	
			}
		#endif
	}
	return true;
}

//	Изменяет состояния групп связанных с текущей изменяемой группой (element)
IFace.ChangeLinksGroups(playerid, IFace.E_GROUPS:element, bool:toggle)
{
	//	перебираем все группы которые нужно скрыть
	for(new i = 0; i < IFace.AddictionsCount[element][ADDICTION_OPPOSITE]; i++)
	{
		IFace.ChangeVisibleGroup(playerid, IFace.Addictions[element][ADDICTION_OPPOSITE][i], !toggle);
	}

	//	перебираем элементы которые надо показать
	for(new i = 0; i < IFace.AddictionsCount[element][ADDICTION_DIRECT]; i++)
	{
		IFace.ToggleGroup(playerid, IFace.Addictions[element][ADDICTION_DIRECT][i], toggle);
	}
	return true;
}

stock IFace.ToggleGroup(playerid, IFace.E_GROUPS:element, bool:toggle)
{
	if(IFace.IsChangeGroupToggle(playerid, element, toggle, false))
	{
		IFace.Groups[playerid][element][giToggle] = toggle;
		IFace.ChangeGroupState(playerid, element, toggle, false);
	}
	else
	{
		IFace.Groups[playerid][element][giToggle] = toggle;
	}
	return true;
}

stock IFace.ChangeVisibleGroup(playerid, IFace.E_GROUPS:element, bool:toggle)
{
	if(IFace.IsChangeGroupToggle(playerid, element, toggle, true))
	{
		IFace.Groups[playerid][element][giShow] = toggle;
		IFace.ChangeGroupState(playerid, element, toggle, true);
	}
	else
	{
		IFace.Groups[playerid][element][giShow] = toggle;
	}
	return true;
}

stock IFace.GetGroupToggle(playerid, IFace.E_GROUPS:element)
{
	return IFace.Groups[playerid][element][giToggle];
}

stock IFace.GetGroupVisible(playerid, IFace.E_GROUPS:element)
{
	return IFace.Groups[playerid][element][giShow];
}

stock IFace.GetGroupToggleAndVisible(playerid, IFace.E_GROUPS:element)
{
	return (IFace.Groups[playerid][element][giToggle] && IFace.Groups[playerid][element][giShow]);
}

stock IFace.ZeroVars(playerid)
{
	for(new IFace.E_GROUPS:e; e < IFace.E_GROUPS; e++)
	{
		IFace.Groups[playerid][e][giToggle] = false;
		IFace.Groups[playerid][e][giShow] 	= true;
		IFace.ChangeGroupState(playerid, e, false, false);
	}
}

stock IFace.AddWantShow(IFace.E_GROUPS:element, IFace.E_GROUPS:showElement)
{
	if(IFace.AddictionsCount[element][ADDICTION_DIRECT] >= sizeof(IFace.Addictions[][]))
	{
		printf("[WARNING]: Function IFace.AddWantShow: element not added, because the array is full");
		return false;
	}
	IFace.Addictions[element][ADDICTION_DIRECT][ IFace.AddictionsCount[element][ADDICTION_DIRECT] ] = showElement;
	IFace.AddictionsCount[element][ADDICTION_DIRECT]++;
	return true;
}

stock IFace.AddWantHide(IFace.E_GROUPS:element, IFace.E_GROUPS:hideElement)
{
	if(IFace.AddictionsCount[element][ADDICTION_OPPOSITE] >= sizeof(IFace.Addictions[][]))
	{
		printf("[WARNING]: Function IFace.AddWantHide: element not added, because the array is full");
		return false;
	}
	IFace.Addictions[element][ADDICTION_OPPOSITE][ IFace.AddictionsCount[element][ADDICTION_OPPOSITE] ] = hideElement;
	IFace.AddictionsCount[element][ADDICTION_OPPOSITE]++;
	return true;
}

//	Spec panel
Interface_SpecPanel_Toggle(playerid, toggle)
{
	if(toggle)
	{
		for(new i = 0; i < 10; i++)
		{
			TextDrawShowForPlayer(playerid, GUI_TD[td_SpecPanel][i]);
		}
		PlayerTextDrawShow(playerid, GUI_PlayerTD[ptd_SpecInfo]);
	}
	else
	{
		for(new i = 0; i < 10; i++)
		{
			TextDrawHideForPlayer(playerid, GUI_TD[td_SpecPanel][i]);
		}
		PlayerTextDrawHide(playerid, GUI_PlayerTD[ptd_SpecInfo]);
	}
}

Interface_SpecPanel_Update(playerid, targetid)
{
	new string[64];
	new Float:health, Float:armour, veh = GetPlayerVehicleID(targetid);
	GetPlayerHealth(targetid, health);
	GetPlayerArmour(targetid, armour);
	format(string, 128, 
		"%s (%d)~n~\
		IP: %s~n~\
		Speed: %d km/h~n~\
		Health: %0.1f",
			ReturnPlayerName(targetid), targetid, 
			ReturnPlayerIP(targetid), 
			(veh > 0) ? GetVehicleSpeed(veh) : GetPlayerSpeed(targetid),
			(veh > 0) ? MyGetVehicleHealth(veh) : MyGetPlayerHealth(targetid));
	PlayerTextDrawSetString(playerid, GUI_PlayerTD[ptd_SpecInfo], string);
}

//	Admin panel
Interface_AdmPanel_Toggle(playerid, bool:toggle)
{
	if(toggle)
	{
		TextDrawShowForPlayer(playerid, GUI_TD[td_AdmPanel]);
	}
	else
	{
		TextDrawHideForPlayer(playerid, GUI_TD[td_AdmPanel]);
	}
}

Interface_AdmPanel_Update(string[])
{
	TextDrawSetString(GUI_TD[td_AdmPanel], string);
}

//	Attach Health
stock HideAttackHealth(playerid)
{
	PlayerTextDrawHide(playerid, PTD_AttachHealth[0]);
	PlayerTextDrawHide(playerid, PTD_AttachHealth[1]);
	PlayerTextDrawHide(playerid, PTD_AttachHealth[2]);
	DeletePVar(playerid, "AttackHealthID");
}

stock ShowAttackHealth(playerid, attackid)
{
	SetPVarInt(playerid, "AttackHealthID", attackid);
	PlayerTextDrawShow(playerid, PTD_AttachHealth[0]);

	// Health line
	new Float:k = MyGetPlayerHealth(attackid);
	PlayerTextDrawTextSize(playerid, PTD_AttachHealth[1], 222.0 + 1.75 * k, 0.0);
	PlayerTextDrawHide(playerid, PTD_AttachHealth[1]);
	PlayerTextDrawShow(playerid, PTD_AttachHealth[1]);

	new string[32];
	format(string, 32, "%s", ReturnPlayerName(attackid));
	PlayerTextDrawSetString(playerid, PTD_AttachHealth[2], string);
	PlayerTextDrawShow(playerid, PTD_AttachHealth[2]);
}

stock UpdateAttackHealth(playerid)
{
	// Health line
	new Float:k = MyGetPlayerHealth(GetPVarInt(playerid, "AttackHealthID"));
	PlayerTextDrawTextSize(playerid, PTD_AttachHealth[1], 222.0 + 1.75 * k, 0.0);
	PlayerTextDrawHide(playerid, PTD_AttachHealth[1]);
	PlayerTextDrawShow(playerid, PTD_AttachHealth[1]);
}

//
public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	//////////	#Fix	//////////
	if(clickedid == Text:INVALID_TEXT_DRAW && GetPVarInt(playerid, "CancelSelectTD"))
	{
		DeletePVar(playerid, "CancelSelectTD");
		return true;
	}
	//////////////////////////////

	#if defined _inventory_interface_included
		Callback: IFace.Inv_OnPlayerClickTD(playerid, clickedid);
	#endif
	#if defined _player_register_included
		Callback: IFace.Reg_OnPlayerClickTD(playerid, clickedid);
	#endif
	#if defined _house_interface_included
		Callback: IFace.House_OnPlayerClickTD(playerid, clickedid);
	#endif
	#if defined _interface_buy_menu_included
		Callback: IFace.BuyMenu_OnPlayerClickTD(playerid, clickedid);
	#endif
	#if defined _interface_select_menu_included
		Callback: IFace.Select_OnPlayerClickTD(playerid, clickedid);
	#endif
	#if defined _interface_selecter_included
		Callback: IFace.Selecter_OnPlayerClickTD(playerid, clickedid);
	#endif	

	new string[128];
	// Остановить выбор (ESC)
	if(clickedid == Text:INVALID_TEXT_DRAW)
	{
		if(ClothesShopID[playerid])						ChoosePlayerClothes(playerid, 0);
	    else if(ChooseVehicleID[playerid])				ChoosePlayerVehicle(playerid, 0);
	    else if(GetPVarType(playerid, "pkrTableID"))	LeavePokerTable(playerid);
		else if(PlayerSelectVCFM[playerid])
		{
		    new v = GetPlayerVehicleID(playerid);
			MyChangeVehicleColor(v, CarInfo[v][cColor1], CarInfo[v][cColor2]);
			ColorMenuHide(playerid);
			ShowDialog(playerid, DMODE_REPAIR);
			DeletePVar(playerid, "repair_color_1");
			DeletePVar(playerid, "repair_color_2");
		}
		return true;
	}

	//	Меню спектра
	if(SpectateID[playerid] != INVALID_PLAYER_ID)
	{
		format(string, sizeof(string), "%d", SpectateID[playerid]);
		if(clickedid == GUI_TD[td_SpecPanel][1])	//	check
		{
			callcmd::check(playerid, string);
			return true;
		}
		else if(clickedid == GUI_TD[td_SpecPanel][2])
		{
			callcmd::freeze(playerid, string);
			return true;
		}
		else if(clickedid == GUI_TD[td_SpecPanel][3])
		{
			callcmd::unfreeze(playerid, string);
			return true;
		}
		else if(clickedid == GUI_TD[td_SpecPanel][4])
		{
			callcmd::slap(playerid, string);
			return true;
		}
		else if(clickedid == GUI_TD[td_SpecPanel][5])
		{
			new Float:pos[3];
			MyGetPlayerPos(SpectateID[playerid], Arr3<pos>);
			if(GetPlayerState(SpectateID[playerid]) == PLAYER_STATE_DRIVER)
			{
				MySetVehiclePos(GetPlayerVehicleID(SpectateID[playerid]), pos[0] - 1.0, pos[1] - 1.0, pos[2]);
			}
			else MySetPlayerPos(SpectateID[playerid], pos[0] - 1.0, pos[1] - 1.0, pos[2]);
			return true;
		}
		else if(clickedid == GUI_TD[td_SpecPanel][6])
		{
			new Float:pos[3];
			MyGetPlayerPos(SpectateID[playerid], Arr3<pos>);
			if(GetPlayerState(SpectateID[playerid]) == PLAYER_STATE_DRIVER)
			{
				MySetVehiclePos(GetPlayerVehicleID(SpectateID[playerid]), pos[0] + 1.0, pos[1] + 1.0, pos[2]);
			}
			else MySetPlayerPos(SpectateID[playerid], pos[0] + 1.0, pos[1] + 1.0, pos[2]);
			return true;
		}
		else if(clickedid == GUI_TD[td_SpecPanel][7])
		{
			new lastid = SpectateID[playerid];
			do
			{
				if(--lastid < 0)	lastid = MAX_PLAYERS - 1;
				if(lastid == SpectateID[playerid])	break;

			} while(!IsPlayerLogged(lastid) || lastid == playerid);
			UpdatePlayerSpectate(playerid, lastid);
			Timer_UpdatePlayerSpectate(playerid, lastid);
			return true;
		}
		else if(clickedid == GUI_TD[td_SpecPanel][8])
		{
			new lastid = SpectateID[playerid];
			do
			{
				if(++lastid >= MAX_PLAYERS)	lastid = 0;
				if(lastid == SpectateID[playerid])	break;

			} while(!IsPlayerLogged(lastid) || lastid == playerid);
			UpdatePlayerSpectate(playerid, lastid);
			Timer_UpdatePlayerSpectate(playerid, lastid);
			return true;
		}
		else if(clickedid == GUI_TD[td_SpecPanel][9])
		{
			callcmd::specoff(playerid, "");
			return true;
		}
	}
	
	//	Магазин одежды
	if(ClothesShopID[playerid] > 0)
	{
	    if(clickedid == tdChooseButton1)
	    {
			ChoosePlayerClothes(playerid, 5);
			return true;
		}
	    else if(clickedid == tdChooseButton2)
	    {
	    	ChoosePlayerClothes(playerid, 0);
    		return true;
    	}
    }

  	// Меню покупки автомобиля
   	if(ChooseVehicleID[playerid] > 0)	
    {
	    if(clickedid == tdChooseButton1)		
	    {
	    	ChoosePlayerVehicle(playerid, 5);
	    	return true;
	    }
	    else if(clickedid == tdChooseButton2)	
	    {
	    	ChoosePlayerVehicle(playerid, 0);
    		return true;
    	}
    }
	
	//  Меню покраски
	if(PlayerSelectVCFM[playerid])	
	{
		new v		=	GetPlayerVehicleID(playerid), color[2];
		new step	=	GetPVarInt(playerid, "painting_step");
		color[0]	=	GetPVarInt(playerid, "repair_color_1");
		color[1]	=	GetPVarInt(playerid, "repair_color_2");
	    if(clickedid == PayNSprayColorMenu[1])
		{
			//  buy
		    if(step == 1)
			{
				if(color[0] == -1)
				{
					return SendClientMessage(playerid, COLOR_SAYING, "- Автомеханик: Сначало выбери цвет, в который будем красить!");
				}
				SendClientMessage(playerid, COLOR_SAYING, "- Автомеханик: Теперь выбирай второй цвет покраски");
				SetPVarInt(playerid, "painting_step", 2);
			}
			else
			{
				if(color[0] != (-1) || color[1] != (-1))
				{
				    if(color[0] != (-1) && color[1] == (-1))
					{
						MyChangeVehicleColor(v, color[0], CarInfo[v][cColor2]);
  						MyGivePlayerMoney(playerid, -50);
					}
					else if(color[0] == (-1) && color[1] != (-1))
					{
					    MyChangeVehicleColor(v, CarInfo[v][cColor1], color[1]);
     					MyGivePlayerMoney(playerid, -50);
					}
					else
					{
					    MyChangeVehicleColor(v, color[0], color[1]);
						MyGivePlayerMoney(playerid, -100);
					}
					PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
					SendClientMessage(playerid, COLOR_SAYING, "- Автомеханик: Покрашено! Краска высохнет через пару минут");
				}
				else return SendClientMessage(playerid, COLOR_SAYING, "- Автомеханик: Сначало выбери цвет, в который будем красить!");
				ColorMenuHide(playerid);
				ShowDialog(playerid, DMODE_REPAIR);
				DeletePVar(playerid, "repair_color_1");
				DeletePVar(playerid, "repair_color_2");
			}
			return true;
		}
		else if(clickedid == PayNSprayColorMenu[2])
		{	//  cancel
			MyChangeVehicleColor(v, CarInfo[v][cColor1], CarInfo[v][cColor2]);
		    if(step == 1)
			{
				SetPVarInt(playerid, "painting_step", 2);
				SetPVarInt(playerid, "repair_color_1", -1);
				SendClientMessage(playerid, COLOR_SAYING, "- Автомеханик: Теперь выбирай второй цвет покраски");
			}
			else
			{
				ColorMenuHide(playerid);
				ShowDialog(playerid, DMODE_REPAIR);
				DeletePVar(playerid, "repair_color_1");	DeletePVar(playerid, "repair_color_2");
			}
			return true;
		}
		else
		{	// box color
		    new color_ch;
			for(new i = 3; i <= 66; i++)
			{
				if(clickedid == PayNSprayColorMenu[i])
				{
				    color_ch = i - 3;
				    if(step == 1)
					{
						ChangeVehicleColor(v, color_ch, CarInfo[v][cColor2]);
						SetPVarInt(playerid, "repair_color_1", color_ch);
					}
					else if(step == 2)
					{
					   	ChangeVehicleColor(v, (color[0] == -1) ? CarInfo[v][cColor1] : color[0], color_ch);
						SetPVarInt(playerid, "repair_color_2", color_ch);
					}
					return true;
				}
			}
		}
	}

    return false;
}// end of OnPlayerClickTextDraw

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	#if defined _inventory_interface_included
		Callback:IFace.Inv_OnPlayerClickPTD(playerid, playertextid);
	#endif
	#if defined _house_interface_included
		Callback:IFace.House_OnPlayerClickPTD(playerid, playertextid);
	#endif
	#if defined _service_casino_included
		Callback:IFace.Poker_OnPlayerClickPTD(playerid, playertextid);
	#endif
	#if defined _interface_buy_menu_included
		Callback:IFace.BuyMenu_OnPlayerClickPTD(playerid, playertextid);
	#endif
	#if defined _interface_select_menu_included
		Callback:IFace.Select_OnPlayerClickPTD(playerid, playertextid);
	#endif

	if(ClothesShopID[playerid])	//	Меню покупки одежды
	{
	    if(playertextid == tdChooseItemR)		ChoosePlayerClothes(playerid, 2);
	    else if(playertextid == tdChooseItemL)	ChoosePlayerClothes(playerid, 3);
	}
    else if(ChooseVehicleID[playerid] > 0)	//	Меню покупки автомобиля
    {
	    if(playertextid == tdChooseItemR)		ChoosePlayerVehicle(playerid, 2);
	    else if(playertextid == tdChooseItemL)	ChoosePlayerVehicle(playerid, 3);
    }
    return false;
}

Interface_StaticCreate()
{
	IFace.AddWantHide(IFace.TV_EFFECT,	IFace.INTERFACE);

	//	Admin
	GUI_TD[td_AdmPanel] = TextDrawCreate(150.0, 425.0, "-1_____-1_____-1_____-1_____-1_____-1_____-1_____-1_____-1_____-1");
	TextDrawColor(GUI_TD[td_AdmPanel], 0xEF8100FF);
	TextDrawFont(GUI_TD[td_AdmPanel], 1);
	TextDrawSetOutline(GUI_TD[td_AdmPanel], 1);
	TextDrawLetterSize(GUI_TD[td_AdmPanel], 0.35, 1.27);

	GUI_TD[td_SpecPanel][0] = TextDrawCreate(550.0, 140.0, "New Textdraw");
	TextDrawAlignment(GUI_TD[td_SpecPanel][0], 2);
	TextDrawBackgroundColor(GUI_TD[td_SpecPanel][0], 255);
	TextDrawFont(GUI_TD[td_SpecPanel][0], 1);
	TextDrawLetterSize(GUI_TD[td_SpecPanel][0], 0.0, 22.000007);
	TextDrawColor(GUI_TD[td_SpecPanel][0], -1);
	TextDrawSetOutline(GUI_TD[td_SpecPanel][0], 0);
	TextDrawSetProportional(GUI_TD[td_SpecPanel][0], 1);
	TextDrawSetShadow(GUI_TD[td_SpecPanel][0], 1);
	TextDrawUseBox(GUI_TD[td_SpecPanel][0], 1);
	TextDrawBoxColor(GUI_TD[td_SpecPanel][0], 187);
	TextDrawTextSize(GUI_TD[td_SpecPanel][0], 0.0, 100.0);

	GUI_TD[td_SpecPanel][1] = TextDrawCreate(550.0, 143.0, "CHECK");
	TextDrawAlignment(GUI_TD[td_SpecPanel][1], 2);
	TextDrawBackgroundColor(GUI_TD[td_SpecPanel][1], 255);
	TextDrawFont(GUI_TD[td_SpecPanel][1], 1);
	TextDrawLetterSize(GUI_TD[td_SpecPanel][1], 0.300000, 1.599999);
	TextDrawColor(GUI_TD[td_SpecPanel][1], -1);
	TextDrawSetOutline(GUI_TD[td_SpecPanel][1], 0);
	TextDrawSetProportional(GUI_TD[td_SpecPanel][1], 1);
	TextDrawSetShadow(GUI_TD[td_SpecPanel][1], 0);
	TextDrawUseBox(GUI_TD[td_SpecPanel][1], 1);
	TextDrawBoxColor(GUI_TD[td_SpecPanel][1], 1180255658);
	TextDrawTextSize(GUI_TD[td_SpecPanel][1], 10.0, 95.0);
	TextDrawSetSelectable(GUI_TD[td_SpecPanel][1], true);

	GUI_TD[td_SpecPanel][2] = TextDrawCreate(550.0, 165.0, "FREEZE");
	TextDrawAlignment(GUI_TD[td_SpecPanel][2], 2);
	TextDrawBackgroundColor(GUI_TD[td_SpecPanel][2], 255);
	TextDrawFont(GUI_TD[td_SpecPanel][2], 1);
	TextDrawLetterSize(GUI_TD[td_SpecPanel][2], 0.300000, 1.599999);
	TextDrawColor(GUI_TD[td_SpecPanel][2], -1);
	TextDrawSetOutline(GUI_TD[td_SpecPanel][2], 0);
	TextDrawSetProportional(GUI_TD[td_SpecPanel][2], 1);
	TextDrawSetShadow(GUI_TD[td_SpecPanel][2], 0);
	TextDrawUseBox(GUI_TD[td_SpecPanel][2], 1);
	TextDrawBoxColor(GUI_TD[td_SpecPanel][2], 1180255658);
	TextDrawTextSize(GUI_TD[td_SpecPanel][2], 10.0, 95.0);
	TextDrawSetSelectable(GUI_TD[td_SpecPanel][2], true);

	GUI_TD[td_SpecPanel][3] = TextDrawCreate(550.0, 187.0, "UNFREEZE");
	TextDrawAlignment(GUI_TD[td_SpecPanel][3], 2);
	TextDrawBackgroundColor(GUI_TD[td_SpecPanel][3], 255);
	TextDrawFont(GUI_TD[td_SpecPanel][3], 1);
	TextDrawLetterSize(GUI_TD[td_SpecPanel][3], 0.300000, 1.599999);
	TextDrawColor(GUI_TD[td_SpecPanel][3], -1);
	TextDrawSetOutline(GUI_TD[td_SpecPanel][3], 0);
	TextDrawSetProportional(GUI_TD[td_SpecPanel][3], 1);
	TextDrawSetShadow(GUI_TD[td_SpecPanel][3], 0);
	TextDrawUseBox(GUI_TD[td_SpecPanel][3], 1);
	TextDrawBoxColor(GUI_TD[td_SpecPanel][3], 1180255658);
	TextDrawTextSize(GUI_TD[td_SpecPanel][3], 10.0, 95.0);
	TextDrawSetSelectable(GUI_TD[td_SpecPanel][3], true);

	GUI_TD[td_SpecPanel][4] = TextDrawCreate(550.0, 210.0, "SLAP");
	TextDrawAlignment(GUI_TD[td_SpecPanel][4], 2);
	TextDrawBackgroundColor(GUI_TD[td_SpecPanel][4], 255);
	TextDrawFont(GUI_TD[td_SpecPanel][4], 1);
	TextDrawLetterSize(GUI_TD[td_SpecPanel][4], 0.300000, 1.599999);
	TextDrawColor(GUI_TD[td_SpecPanel][4], -1);
	TextDrawSetOutline(GUI_TD[td_SpecPanel][4], 0);
	TextDrawSetProportional(GUI_TD[td_SpecPanel][4], 1);
	TextDrawSetShadow(GUI_TD[td_SpecPanel][4], 0);
	TextDrawUseBox(GUI_TD[td_SpecPanel][4], 1);
	TextDrawBoxColor(GUI_TD[td_SpecPanel][4], 1180255658);
	TextDrawTextSize(GUI_TD[td_SpecPanel][4], 10.0, 95.0);
	TextDrawSetSelectable(GUI_TD[td_SpecPanel][4], true);

	GUI_TD[td_SpecPanel][5] = TextDrawCreate(550.0, 232.0, "<- MOVE");
	TextDrawAlignment(GUI_TD[td_SpecPanel][5], 2);
	TextDrawBackgroundColor(GUI_TD[td_SpecPanel][5], 255);
	TextDrawFont(GUI_TD[td_SpecPanel][5], 1);
	TextDrawLetterSize(GUI_TD[td_SpecPanel][5], 0.300000, 1.599999);
	TextDrawColor(GUI_TD[td_SpecPanel][5], -1);
	TextDrawSetOutline(GUI_TD[td_SpecPanel][5], 0);
	TextDrawSetProportional(GUI_TD[td_SpecPanel][5], 1);
	TextDrawSetShadow(GUI_TD[td_SpecPanel][5], 0);
	TextDrawUseBox(GUI_TD[td_SpecPanel][5], 1);
	TextDrawBoxColor(GUI_TD[td_SpecPanel][5], 1180255658);
	TextDrawTextSize(GUI_TD[td_SpecPanel][5], 10.0, 95.0);
	TextDrawSetSelectable(GUI_TD[td_SpecPanel][5], true);

	GUI_TD[td_SpecPanel][6] = TextDrawCreate(550.0, 254.0, "MOVE ->");
	TextDrawAlignment(GUI_TD[td_SpecPanel][6], 2);
	TextDrawBackgroundColor(GUI_TD[td_SpecPanel][6], 255);
	TextDrawFont(GUI_TD[td_SpecPanel][6], 1);
	TextDrawLetterSize(GUI_TD[td_SpecPanel][6], 0.300000, 1.599999);
	TextDrawColor(GUI_TD[td_SpecPanel][6], -1);
	TextDrawSetOutline(GUI_TD[td_SpecPanel][6], 0);
	TextDrawSetProportional(GUI_TD[td_SpecPanel][6], 1);
	TextDrawSetShadow(GUI_TD[td_SpecPanel][6], 0);
	TextDrawUseBox(GUI_TD[td_SpecPanel][6], 1);
	TextDrawBoxColor(GUI_TD[td_SpecPanel][6], 1180255658);
	TextDrawTextSize(GUI_TD[td_SpecPanel][6], 10.0, 95.0);
	TextDrawSetSelectable(GUI_TD[td_SpecPanel][6], true);

	GUI_TD[td_SpecPanel][7] = TextDrawCreate(550.0, 276.0, "<< PREV");
	TextDrawAlignment(GUI_TD[td_SpecPanel][7], 2);
	TextDrawBackgroundColor(GUI_TD[td_SpecPanel][7], 255);
	TextDrawFont(GUI_TD[td_SpecPanel][7], 1);
	TextDrawLetterSize(GUI_TD[td_SpecPanel][7], 0.300000, 1.599999);
	TextDrawColor(GUI_TD[td_SpecPanel][7], -1);
	TextDrawSetOutline(GUI_TD[td_SpecPanel][7], 0);
	TextDrawSetProportional(GUI_TD[td_SpecPanel][7], 1);
	TextDrawSetShadow(GUI_TD[td_SpecPanel][7], 0);
	TextDrawUseBox(GUI_TD[td_SpecPanel][7], 1);
	TextDrawBoxColor(GUI_TD[td_SpecPanel][7], 1180255658);
	TextDrawTextSize(GUI_TD[td_SpecPanel][7], 10.0, 95.0);
	TextDrawSetSelectable(GUI_TD[td_SpecPanel][7], true);

	GUI_TD[td_SpecPanel][8] = TextDrawCreate(550.0, 298.0, "NEXT >>");
	TextDrawAlignment(GUI_TD[td_SpecPanel][8], 2);
	TextDrawBackgroundColor(GUI_TD[td_SpecPanel][8], 255);
	TextDrawFont(GUI_TD[td_SpecPanel][8], 1);
	TextDrawLetterSize(GUI_TD[td_SpecPanel][8], 0.300000, 1.599999);
	TextDrawColor(GUI_TD[td_SpecPanel][8], -1);
	TextDrawSetOutline(GUI_TD[td_SpecPanel][8], 0);
	TextDrawSetProportional(GUI_TD[td_SpecPanel][8], 1);
	TextDrawSetShadow(GUI_TD[td_SpecPanel][8], 0);
	TextDrawUseBox(GUI_TD[td_SpecPanel][8], 1);
	TextDrawBoxColor(GUI_TD[td_SpecPanel][8], 1180255658);
	TextDrawTextSize(GUI_TD[td_SpecPanel][8], 10.0, 95.0);
	TextDrawSetSelectable(GUI_TD[td_SpecPanel][8], true);

	GUI_TD[td_SpecPanel][9] = TextDrawCreate(550.0, 320.0, "~r~SPEC OFF");
	TextDrawAlignment(GUI_TD[td_SpecPanel][9], 2);
	TextDrawBackgroundColor(GUI_TD[td_SpecPanel][9], 255);
	TextDrawFont(GUI_TD[td_SpecPanel][9], 1);
	TextDrawLetterSize(GUI_TD[td_SpecPanel][9], 0.300000, 1.599999);
	TextDrawColor(GUI_TD[td_SpecPanel][9], -1);
	TextDrawSetOutline(GUI_TD[td_SpecPanel][9], 0);
	TextDrawSetProportional(GUI_TD[td_SpecPanel][9], 1);
	TextDrawSetShadow(GUI_TD[td_SpecPanel][9], 0);
	TextDrawUseBox(GUI_TD[td_SpecPanel][9], 1);
	TextDrawBoxColor(GUI_TD[td_SpecPanel][9], 1180255658);
	TextDrawTextSize(GUI_TD[td_SpecPanel][9], 10.0, 95.0);
	TextDrawSetSelectable(GUI_TD[td_SpecPanel][9], true);

	//////////////////////////////////////////////////

	//	Loading
	/*TD_Loading = TextDrawCreate(320.0, 200.0, "L O A D I N G");
	TextDrawAlignment(TD_Loading, 2);
	TextDrawBackgroundColor(TD_Loading, 255);
	TextDrawFont(TD_Loading, 2);
	TextDrawLetterSize(TD_Loading, 0.5, 2.0);
	TextDrawSetOutline(TD_Loading, 0);
	TextDrawSetProportional(TD_Loading, 1);
	TextDrawSetShadow(TD_Loading, 1);*/

	//	CamEffects
	lbt = TextDrawCreate(-2.0, 0.0, "---");
	lbb = TextDrawCreate(0.0, 340.0, "---");
	TextDrawUseBox(lbt, 1);
	TextDrawUseBox(lbb, 1);
	TextDrawBoxColor(lbt, 0x000000ff);
	TextDrawBoxColor(lbb, 0x000000ff);
	TextDrawTextSize(lbt, 640.0, -69.0);
	TextDrawTextSize(lbb, 638.0, -60.0);
	TextDrawLetterSize(lbt, 0.0, 10.5);
	TextDrawLetterSize(lbb, 0.0, 12.0);

	//---

	/*TD_TutTitle = TextDrawCreate(320.0, 120.0, "Silver Break");
	TextDrawAlignment(TD_TutTitle, 2);
	TextDrawBackgroundColor(TD_TutTitle, 255);
	TextDrawFont(TD_TutTitle, 0);
	TextDrawLetterSize(TD_TutTitle, 1.5, 5.0);
	TextDrawColor(TD_TutTitle, -1);
	TextDrawSetOutline(TD_TutTitle, 0);
	TextDrawSetProportional(TD_TutTitle, 1);
	TextDrawSetShadow(TD_TutTitle, 1);

	TD_TutTitle2 = TextDrawCreate(320.0, 185.0, "Role Play");
	TextDrawAlignment(TD_TutTitle2, 2);
	TextDrawBackgroundColor(TD_TutTitle2, 255);
	TextDrawFont(TD_TutTitle2, 1);
	TextDrawLetterSize(TD_TutTitle2, 0.5, 2.0);
	TextDrawColor(TD_TutTitle2, -1);
	TextDrawSetOutline(TD_TutTitle2, 0);
	TextDrawSetProportional(TD_TutTitle2, 1);
	TextDrawSetShadow(TD_TutTitle2, 1);*/

	BuyHelp = TextDrawCreate(497.0, 110.0, "\
	~g~~h~Next: ~w~~k~~VEHICLE_TURRETRIGHT~~n~\
	~g~~h~Prev: ~w~~k~~VEHICLE_TURRETLEFT~~n~\
	~g~~h~Buy: ~w~~k~~PED_SPRINT~~n~\
	~g~~h~Exit: ~w~~k~~VEHICLE_ENTER_EXIT~");
	TextDrawBackgroundColor(BuyHelp, 255);
	TextDrawFont(BuyHelp, 1);
	TextDrawLetterSize(BuyHelp, 0.500000, 1.100000);
	TextDrawColor(BuyHelp, -1);
	TextDrawSetOutline(BuyHelp, 1);
	TextDrawSetProportional(BuyHelp, 1);

	tdChooseButton1 = TextDrawCreate(284.0, 350.0, "select");
	TextDrawFont(tdChooseButton1, 3);
	TextDrawLetterSize(tdChooseButton1, 0.58, 1.7);
	TextDrawTextSize(tdChooseButton1, 350.0, 15.0);
	TextDrawSetShadow(tdChooseButton1, 0);
	TextDrawSetSelectable(tdChooseButton1, 1);

	tdChooseButton2 = TextDrawCreate(285.0, 400.0, "cancel");
	TextDrawFont(tdChooseButton2, 3);
	TextDrawLetterSize(tdChooseButton2, 0.58, 1.7);
	TextDrawTextSize(tdChooseButton2, 350.0, 15.0);
	TextDrawSetShadow(tdChooseButton2, 0);
	TextDrawSetSelectable(tdChooseButton2, 1);

	// Repaint menu
    PayNSprayColorMenu[0] = TextDrawCreate(130.0, 127.0, "~n~");
	TextDrawAlignment(PayNSprayColorMenu[0], 2);
	TextDrawLetterSize(PayNSprayColorMenu[0], 0.0, 19.5);
	TextDrawUseBox(PayNSprayColorMenu[0], 1);
	TextDrawBoxColor(PayNSprayColorMenu[0], PayNSprayColors4Menu[0]);
	TextDrawTextSize(PayNSprayColorMenu[0], 0.0, 200.0);

    PayNSprayColorMenu[ 1 ] = TextDrawCreate( 78.5, 307.0, "BUY" );
	TextDrawAlignment( PayNSprayColorMenu[ 1 ], 2 );
	TextDrawBackgroundColor( PayNSprayColorMenu[ 1 ], 255 );
	TextDrawFont( PayNSprayColorMenu[ 1 ], 2 );
	TextDrawLetterSize( PayNSprayColorMenu[ 1 ], 0.5, 1.0 );
	TextDrawColor( PayNSprayColorMenu[ 1 ], -1 );
	TextDrawUseBox( PayNSprayColorMenu[ 1 ], 1 );
	TextDrawBoxColor( PayNSprayColorMenu[ 1 ], 170 );
	TextDrawTextSize( PayNSprayColorMenu[ 1 ], 20.0, 97.0 );
	TextDrawSetSelectable( PayNSprayColorMenu[ 1 ], 1 );

	PayNSprayColorMenu[ 2 ] = TextDrawCreate( 181.5, 307.0, "CANCEL" );
	TextDrawAlignment( PayNSprayColorMenu[ 2 ], 2 );
	TextDrawBackgroundColor( PayNSprayColorMenu[ 2 ], 255 );
	TextDrawFont( PayNSprayColorMenu[ 2 ], 2 );
	TextDrawLetterSize( PayNSprayColorMenu[ 2 ], 0.5, 1.0 );
	TextDrawColor( PayNSprayColorMenu[ 2 ], -1 );
	TextDrawUseBox( PayNSprayColorMenu[ 2 ], 1 );
	TextDrawBoxColor( PayNSprayColorMenu[ 2 ], 170 );
	TextDrawTextSize( PayNSprayColorMenu[ 2 ], 20.0, 97.0 );
	TextDrawSetSelectable( PayNSprayColorMenu[ 2 ], 1 );

	new x_it = 0,
		Float:y = 130.0,
		Float:x = 42.0 - 25.0;
	for( new i = 3, count_items = 8; i <= 66; i++ )
	{
		if( x_it++ == count_items )
		{
			x_it = 1;
			x = 42.0;
			y += 22.0;
		}
		else x += 25.0;
		PayNSprayColorMenu[ i ] = TextDrawCreate( x, y, "1");
		TextDrawColor( PayNSprayColorMenu[ i ], 0x00000000 );
		TextDrawAlignment( PayNSprayColorMenu[ i ], 2 );
		TextDrawLetterSize( PayNSprayColorMenu[ i ], 0.0, 1.6 );
		TextDrawUseBox( PayNSprayColorMenu[ i ], 1 );
		TextDrawBoxColor( PayNSprayColorMenu[ i ], PayNSprayColors4Menu[ i - 1 ] );
		TextDrawTextSize( PayNSprayColorMenu[ i ], 17.5, 17.5 );
		TextDrawSetSelectable( PayNSprayColorMenu[ i ], 1 );
	}
}

Interface_PlayerCreate(playerid)
{
	GUI_PlayerTD[ptd_SpecInfo] = CreatePlayerTextDraw(playerid, 320.0, 350.0, "_");
	PlayerTextDrawAlignment(playerid, GUI_PlayerTD[ptd_SpecInfo], 2);
	PlayerTextDrawBackgroundColor(playerid, GUI_PlayerTD[ptd_SpecInfo], 255);
	PlayerTextDrawFont(playerid, GUI_PlayerTD[ptd_SpecInfo], 1);
	PlayerTextDrawLetterSize(playerid, GUI_PlayerTD[ptd_SpecInfo], 0.25, 1.1);
	PlayerTextDrawColor(playerid, GUI_PlayerTD[ptd_SpecInfo], -1);
	PlayerTextDrawSetOutline(playerid, GUI_PlayerTD[ptd_SpecInfo], 0);
	PlayerTextDrawSetProportional(playerid, GUI_PlayerTD[ptd_SpecInfo], 1);
	PlayerTextDrawSetShadow(playerid, GUI_PlayerTD[ptd_SpecInfo], 1);
	PlayerTextDrawUseBox(playerid, GUI_PlayerTD[ptd_SpecInfo], 1);
	PlayerTextDrawBoxColor(playerid, GUI_PlayerTD[ptd_SpecInfo], 187);
	PlayerTextDrawTextSize(playerid, GUI_PlayerTD[ptd_SpecInfo], 0.0, 150.0);

	BuyInfo = CreatePlayerTextDraw(playerid, 220.0, 365.0, "~y~<12 ~w~Business ~y~2>");
	PlayerTextDrawBackgroundColor(playerid, BuyInfo, 255);
	PlayerTextDrawFont(playerid, BuyInfo, 1);
	PlayerTextDrawLetterSize(playerid, BuyInfo, 0.500000, 1.10);
	PlayerTextDrawSetOutline(playerid, BuyInfo, 1);

	BuyPrice = CreatePlayerTextDraw(playerid, 250.0, 380.0, "~y~Price: ~w~$10.000");
	PlayerTextDrawBackgroundColor(playerid, BuyPrice, 255);
	PlayerTextDrawFont(playerid, BuyPrice, 1);
	PlayerTextDrawLetterSize(playerid, BuyPrice, 0.50, 1.100000);
	PlayerTextDrawSetOutline(playerid, BuyPrice, 1);

	tdChoosePrice = CreatePlayerTextDraw(playerid, 317.0, 375.0, "~g~$0");
	PlayerTextDrawFont(playerid, tdChoosePrice, 1);
	PlayerTextDrawLetterSize(playerid, tdChoosePrice, 0.58, 1.7);
	PlayerTextDrawTextSize(playerid, tdChoosePrice, 350.0, 60.0);
	PlayerTextDrawAlignment(playerid, tdChoosePrice, 2);

	tdChooseItemL = CreatePlayerTextDraw(playerid, 220.0, 348.0, " ");
	PlayerTextDrawFont(playerid, tdChooseItemL, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawBackgroundColor(playerid, tdChooseItemL, 0x88888899);
	PlayerTextDrawTextSize(playerid, tdChooseItemL, 60.0, 70.0);
	PlayerTextDrawBoxColor(playerid, tdChooseItemL, 0x00000000);
	PlayerTextDrawSetSelectable(playerid, tdChooseItemL, 1);

	tdChooseItemR = CreatePlayerTextDraw(playerid, 355.0, 348.0, " ");
	PlayerTextDrawFont(playerid, tdChooseItemR, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawBackgroundColor(playerid, tdChooseItemR, 0x88888899);
	PlayerTextDrawTextSize(playerid, tdChooseItemR, 60.0, 70.0);
	PlayerTextDrawBoxColor(playerid, tdChooseItemR, 0x00000000);
	PlayerTextDrawSetSelectable(playerid, tdChooseItemR, 1);

	//  Jail
	p_JailPeriod = CreatePlayerTextDraw(playerid, 605.0, 125.0, "~y~Jail Period");
	PlayerTextDrawAlignment(playerid, p_JailPeriod, 3);
	PlayerTextDrawBackgroundColor(playerid, p_JailPeriod, 255);
	PlayerTextDrawFont(playerid, p_JailPeriod, 2);
	PlayerTextDrawLetterSize(playerid, p_JailPeriod, 0.25, 1.5);
	PlayerTextDrawColor(playerid, p_JailPeriod, 0xB1C8FBFF);
	PlayerTextDrawSetOutline(playerid, p_JailPeriod, 1);
	PlayerTextDrawSetProportional(playerid, p_JailPeriod, 1);

	//  Gym
	InfoBar = CreatePlayerTextDraw(playerid, 608.0, 140.0, "_");
	PlayerTextDrawAlignment(playerid, InfoBar, 3);
	PlayerTextDrawBackgroundColor(playerid, InfoBar, 255);
	PlayerTextDrawFont(playerid, InfoBar, 2);
	PlayerTextDrawLetterSize(playerid, InfoBar, 0.25, 1.5);
	PlayerTextDrawColor(playerid, InfoBar, 0xB1C8FBFF);
	PlayerTextDrawSetOutline(playerid, InfoBar, 1);
	PlayerTextDrawSetProportional(playerid, InfoBar, 1);

	//  DEBUG TD
	debugTD = CreatePlayerTextDraw(playerid, 20.0, 280.0, "_");
	PlayerTextDrawBackgroundColor(playerid, debugTD, 255);
	PlayerTextDrawFont(playerid, debugTD, 2);
	PlayerTextDrawLetterSize(playerid, debugTD, 0.15, 1.0);
	PlayerTextDrawSetOutline(playerid, debugTD, 0);
	PlayerTextDrawSetProportional(playerid, debugTD, 1);
	PlayerTextDrawSetShadow(playerid, debugTD, 1);

	//	Attack Health TD
	PTD_AttachHealth[0] = CreatePlayerTextDraw(playerid, 220.0, 69.0, "_"); // Main Black Box
	PlayerTextDrawLetterSize(playerid, PTD_AttachHealth[0], 0.5, 0.5);
	PlayerTextDrawUseBox(playerid, PTD_AttachHealth[0], 1);
	PlayerTextDrawBoxColor(playerid, PTD_AttachHealth[0], 0x000000AA);
	PlayerTextDrawTextSize(playerid, PTD_AttachHealth[0], 400.0, 0.0);

	PTD_AttachHealth[1] = CreatePlayerTextDraw(playerid, 223.0, 71.0, "_"); // Health Line
	PlayerTextDrawLetterSize(playerid, PTD_AttachHealth[1], 0.5, 0.0);
	PlayerTextDrawUseBox(playerid, PTD_AttachHealth[1], 1);
	PlayerTextDrawBoxColor(playerid, PTD_AttachHealth[1], 0xCB2821AA);
	PlayerTextDrawTextSize(playerid, PTD_AttachHealth[1], 397.0, 0.0); // 222.0 - min

	PTD_AttachHealth[2] = CreatePlayerTextDraw(playerid, 310.0, 52.0, "Name"); // Title
	PlayerTextDrawAlignment(playerid, PTD_AttachHealth[2], 2);
	PlayerTextDrawFont(playerid, PTD_AttachHealth[2], 1);
	PlayerTextDrawLetterSize(playerid, PTD_AttachHealth[2], 0.3, 1.2);
	PlayerTextDrawColor(playerid, PTD_AttachHealth[2], 0xB1C8FBFF);
	PlayerTextDrawSetOutline(playerid, PTD_AttachHealth[2], 1);
}

Public: IFace.OnGameModeInit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		for(new IFace.E_GROUPS:e; e < IFace.E_GROUPS; e++)
		{
			IFace.Groups[i][e][giShow] = true;
		}
	}

	Interface_StaticCreate();

	#if defined _player_interface_included
		IFace.Player_Load_Base();
	#endif
	#if defined _player_phone_included
		IFace.Phone_Load_Base();
	#endif

	#if defined _inventory_interface_included
		IFace.Inv_Create_Base();
	#endif

	#if defined _interface_exp_line_included
		IFace.ExpLine_Create_Base();
	#endif

	#if defined _interface_repbar_included
		IFace.RepBar_Create_Base();
	#endif

	#if defined _interface_cam_effect_included
		IFace.CamEffect_Load_Base();
	#endif
	#if defined _interface_buy_menu_included
		IFace.BuyMenu_Load_Base();
	#endif
	#if defined _interface_select_menu_included
		IFace.SelectMenu_Create_Base();
	#endif
	#if defined _interface_selecter_included
		IFace.Selecter_Create_Base();
	#endif	

	#if defined _vehicle_interface_included
		IFace.Veh_Create_Base();
	#endif

	#if defined _events_races_included
		IFace.Race_Create_Base();
	#endif

	#if defined _house_interface_included
		IFace.House_Create_Base();
	#endif

	IFace.Hack_Create_Base();

	Reg_IFace_Create_Base();

	return CONTINUE;
}

Public: IFace.OnPlayerConnect(playerid)
{
	#if defined _interface_mission_included
		IFace.Mission_Create_Player(playerid);
	#endif

	#if defined _interface_fader_included
		IFace.Fader_Create_Player(playerid);
	#endif	

	return CONTINUE;
}

IFace.Load_Player(playerid)
{
	Interface_PlayerCreate(playerid);

	#if defined _player_interface_included
		IFace.Player_Load_Player(playerid);
	#endif
	#if defined _player_phone_included
		IFace.Phone_Load_Player(playerid);
	#endif

	#if defined _inventory_interface_included
		IFace.Inv_Create_Player(playerid);
	#endif

	#if defined _service_casino_included
		IFace.Poker_Create_Player(playerid);
	#endif

	#if defined _interface_exp_line_included
		IFace.ExpLine_Create_Player(playerid);
	#endif

	#if defined _interface_progress_included
		IFace.Progress_Create_Player(playerid);	
	#endif

	#if defined _interface_repbar_included
		IFace.RepBar_Create_Player(playerid);	
	#endif

	#if defined _vehicle_interface_included
		IFace.Veh_Create_Player(playerid);
	#endif

	#if defined _interface_vtimer_included
		IFace.VisualTimer_Load_Player(playerid);
	#endif

	#if defined _interface_buy_menu_included
		IFace.BuyMenu_Load_Player(playerid);
	#endif

	#if defined _interface_select_menu_included
		IFace.SelectMenu_Create_Player(playerid);
	#endif

	#if defined _events_races_included
		IFace.Race_Create_Player(playerid);
	#endif

	#if defined _job_interface_included
		IFace.Job_Create_Player(playerid);
	#endif

	#if defined _house_interface_included
		IFace.House_Create_Player(playerid);
	#endif

	#if defined FACTION_POLICE_CORE_INCLUDED
		IFace.Wanted_Create_Player(playerid);
	#endif
}

//	System
stock _FormatTextDrawString(const string[])
{
	new message[256];
	for(new i, c, bool:ccode; string[i] != EOS; i++) 
	{
		if(string[i] == '~') 
		{
			ccode ^= true;
			if (!ccode) 
			{
				switch (string[i - 1]) 
				{
					case 'r':	strins(message, "{DE2121}", c);
					case 'y':	strins(message, "{CFB53B}", c);
					case 'b':	strins(message, "{3039F1}", c);
					case 'g':	strins(message, "{47A76A}", c);
					case 'w':	strins(message, "{FFFFFF}", c);
					case 'p':	strins(message, "{BB00DD}", c);
					default:	continue;
				}
				c += 8;
			}
		}
		else if(!ccode) 
		{
			message[c++] = string[i];
		}
	}
	return message;
}

stock getLinesNumber(string[], max_line_len)
{
	new lines = 1;
	for(new i, line_len, word_len, bool:tilda; string[i] != EOS; i++)
	{
		if(tilda)
		{
			if(string[i] == 'n')
			{
				line_len = 0;
				word_len = 0;
			    lines++;
			}
			else if(string[i] == '~') tilda = false;
			continue;
		}
		else if(string[i] == '~') 
		{
			tilda = true;
			continue;
		}
		
		if(string[i] != ' ')
		{
			word_len ++;
			if(line_len >= max_line_len || word_len + line_len >= max_line_len)
			{
			    line_len = 0;
			    lines++;
			}
		}
		else
		{
			line_len += word_len + 1;
			word_len = 0;
		}
	}
	return lines;
}

stock RusText(const text[], rusif = true)
{
	new length = strlen(text),
		gametext[256], j = 0;
	if(rusif)
	{
		strput(gametext, text);
		//for(new i = 0; i < length; i++)
		//{
		//	j = text[i] - 192;
		//	gametext[i] = (0 <= j < sizeof(RusChars)) ? RusChars[j] : text[i];
		//}
	}
	else
	{
		for(new i; i < length; i++)
		{
			switch(text[i])
			{
				case 'а': gametext[j++] = 'a';
				case 'А': gametext[j++] = 'A';
				case 'б': gametext[j++] = 'b';
				case 'Б': gametext[j++] = 'B';
				case 'в': gametext[j++] = 'v';
				case 'В': gametext[j++] = 'V';
				case 'г': gametext[j++] = 'g';
				case 'Г': gametext[j++] = 'G';
				case 'д': gametext[j++] = 'd';
				case 'Д': gametext[j++] = 'D';
				case 'е': gametext[j++] = 'e';
				case 'Е': gametext[j++] = 'E';
				case 'ё': gametext[j++] = 'e';
				case 'Ё': gametext[j++] = 'E';
				case 'ж':
				{
					gametext[j++] = 'z';
					gametext[j++] = 'h';
				}
				case 'Ж':
				{
					gametext[j++] = 'Z';
					gametext[j++] = 'h';
				}
				case 'з': gametext[j++] = 'z';
				case 'З': gametext[j++] = 'Z';
				case 'и': gametext[j++] = 'i';
				case 'И': gametext[j++] = 'I';
				case 'й': gametext[j++] = 'j';
				case 'Й': gametext[j++] = 'J';
				case 'к': gametext[j++] = 'k';
				case 'К': gametext[j++] = 'K';
				case 'л': gametext[j++] = 'l';
				case 'Л': gametext[j++] = 'L';
				case 'м': gametext[j++] = 'm';
				case 'М': gametext[j++] = 'M';
				case 'н': gametext[j++] = 'n';
				case 'Н': gametext[j++] = 'N';
				case 'о': gametext[j++] = 'o';
				case 'О': gametext[j++] = 'O';
				case 'п': gametext[j++] = 'p';
				case 'П': gametext[j++] = 'P';
				case 'р': gametext[j++] = 'r';
				case 'Р': gametext[j++] = 'R';
				case 'с': gametext[j++] = 's';
				case 'С': gametext[j++] = 'S';
				case 'т': gametext[j++] = 't';
				case 'Т': gametext[j++] = 'T';
				case 'у': gametext[j++] = 'u';
				case 'У': gametext[j++] = 'U';
				case 'ф': gametext[j++] = 'f';
				case 'Ф': gametext[j++] = 'F';
				case 'х': gametext[j++] = 'h';//kh
				case 'Х': gametext[j++] = 'H';
				case 'ц': gametext[j++] = 'c';//tc
				case 'Ц': gametext[j++] = 'C';
				case 'ч':
				{
				    gametext[j++] = 'c';
				    gametext[j++] = 'h';
				}
				case 'Ч':
				{
				    gametext[j++] = 'C';
				    gametext[j++] = 'h';
				}
				case 'ш':
				{
				    gametext[j++] = 's';
				    gametext[j++] = 'h';
				}
				case 'Ш':
				{
				    gametext[j++] = 'S';
				    gametext[j++] = 'h';
				}
				case 'щ':
				{
				    gametext[j++] = 's';
				    gametext[j++] = 'c';
				    gametext[j++] = 'h';
				}
				case 'Щ':
				{
				    gametext[j++] = 'S';
				    gametext[j++] = 'c';
				    gametext[j++] = 'h';
				}
				case 'ъ','Ъ':
				{
					gametext[j++] = '\'';
					gametext[j++] = '\'';
				}
				case 'ы': gametext[j++] = 'y';
				case 'Ы': gametext[j++] = 'Y';
				case 'ь', 'Ь': gametext[j++] = '\''; //'
				case 'э': gametext[j++] = 'e';
				case 'Э': gametext[j++] = 'E';
				case 'ю':
				{
					gametext[j++] = 'e';
					gametext[j++] = 'u';
				}
				case 'Ю':
				{
					gametext[j++] = 'E';
					gametext[j++] = 'u';
				}
				case 'я':
				{
					gametext[j++] = 'y';
					gametext[j++] = 'a';
				}
				case 'Я':
				{
					gametext[j++] = 'Y';
					gametext[j++] = 'a';
				}
				default: gametext[j++] = text[i];
			}
		}
	}
	return gametext;
}