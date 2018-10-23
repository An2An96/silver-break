#if defined _interface_core_included
	#endinput
#endif

#define _interface_core_included

#include "interface/tv_effect"
#include "interface/fader"
#include "interface/hint"
#include "interface/exp_line"
#include "interface/progress"
#include "interface/repbar"
#include "interface/mission"
#include "interface/visual_timer"
#include "interface/cam_effect"
#include "interface/hack_lock"
#include "interface/buy_menu"
#include "interface/select_menu"
#include "interface/selecter"
#include "interface/info_bar"

//---	Global TD
new
	Text:BuyHelp,
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
	PlayerText:PTD_AttachHealth[3];

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
public IsPlayerChangeInterface(playerid, element, bool:toggle)
{
	switch(element)
	{
		case IFace.SPEEDO:
		{
			if(toggle)
			{
				if(!IFace.GetGroupToggleAndVisible(playerid, IFace.INTERFACE))
					return (0);
			}
		}
	}
	return (1);
}

public OnPlayerChangeInterface(playerid, element, bool:toggle)
{
	switch(element)
	{
		case IFace.INTERFACE:
		{
			IFace.ChangeVisibleGroup(playerid, IFace.SPEEDO, toggle);
			if(RestTime > 0)
			{
				IFace.ToggleGroup(playerid, IFace.RESTART, toggle);
			}
		}

	#if defined _inventory_interface_included
		case IFace.INVENTORY:
		{
			#if defined _interface_hint_included
				UpdatePlayerHints(playerid);
			#endif
		}
	#endif

	#if defined _interface_select_menu_included
		case IFace.SELECT_MENU:
		{
			#if defined _interface_hint_included
				UpdatePlayerHints(playerid);
			#endif
		}
	#endif

	#if defined _player_phone_included
		case IFace.PHONE:
		{
			#if defined _interface_hint_included
				UpdatePlayerHints(playerid);
			#endif
		}
	#endif

	#if defined _interface_progress_included
		case IFace.PROGRESS:
		{
			if (toggle)
			{
				if (PlayerInfo[playerid][pJailTime])
				{
					PlayerTextDrawHide(playerid, p_JailPeriod);
				}	
			}
			else
			{
				if (PlayerInfo[playerid][pJailTime])
				{
					PlayerTextDrawShow(playerid, p_JailPeriod);
				}
			}	
		}
	#endif

		case IFace.LOGO:
		{
			if (toggle)
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
			if (toggle)
			{
				TextDrawShowForPlayer(playerid, RestartInfo);
			}
			else
			{
				TextDrawHideForPlayer(playerid, RestartInfo);
			}
		}
	}
	return (1);
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
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

    return (0);
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

    return (0);
}

public	OnTextDrawInit()
{
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

	return (1);
}

Public: IFace.OnGameModeInit()
{
	//	Create Groups
	IFace.CreateGroup(IFace.TV_EFFECT,			#IFace.TVEffect_Toggled, false);
	IFace.CreateGroup(IFace.EXP_LINE,			#IFace.ExpLine_Toggle, false);
	IFace.CreateGroup(IFace.PROGRESS,			#IFace.Progress_Toggled, false);
	IFace.CreateGroup(IFace.REPBAR,				#IFace.RepBar_Toggle, false);
	IFace.CreateGroup(IFace.MISSION_MES,		#IFace.Mission_Message_Toggle, false);
	IFace.CreateGroup(IFace.VISUAL_TIMER,		#IFace.VisualTimer_Toggle, false);
	IFace.CreateGroup(IFace.HACK_LOCK,			#IFace.HackLock_Toggle, false);
	IFace.CreateGroup(IFace.CAM_EFFECT,			#IFace.CamEffect_Toggle, false);
	IFace.CreateGroup(IFace.BUY_MENU,			#IFace.BuyMenu_Toggle, true);
	IFace.CreateGroup(IFace.SELECT_MENU,		#IFace.SelectMenu_Toggle, true);
	IFace.CreateGroup(IFace.SELECTER,			#IFace.Selecter_Toggle, true);
	IFace.CreateGroup(IFace.INTERFACE,			#IFace.Player_Toggle, false);
	IFace.CreateGroup(IFace.LOGO,				"", false);
	IFace.CreateGroup(IFace.RESTART,			"", false);
	IFace.CreateGroup(IFace.WANTED,				#IFace.Wanted_Toggle, false);
	IFace.CreateGroup(IFace.INVENTORY,			#IFace.Inv_Toggle, true);
	IFace.CreateGroup(IFace.PHONE,				#IFace.Phone_Toggle, false);
	IFace.CreateGroup(IFace.HOUSE_ENTER_MENU,	#IFace.House_EnterMenuToggle, false);
	IFace.CreateGroup(IFace.HOUSE_FUR,			#IFace.House_FurToggle, false);
	IFace.CreateGroup(IFace.WORK_INFO,			#IFace.Job_Toggle, false);
	IFace.CreateGroup(IFace.SPEEDO,				#IFace.Veh_Toggle, false);

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

public	OnPlayerTextDrawInit(playerid)
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

	#if defined _interface_info_bar_included
		IFace.InfoBar_CreatePlayerTD(playerid);
	#endif

	return (1);
}
