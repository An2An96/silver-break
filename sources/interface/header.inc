#if defined INTERFACE_HEADER_INCLUDED
	#endinput
#endif

#define INTERFACE_HEADER_INCLUDED

#define INTERFACE_MAIN_COLOR					0x181B20AA
#define INTERFACE_CO_MAIN_COLOR					0xA32725FF
#define INTERFACE_BUTTON_COLOR					INTERFACE_CO_MAIN_COLOR

forward IFace.Load_Player(playerid);

forward IFace.ChangeMoney_Update(playerid, money);

enum // IFace.E_GROUPS
{
	//	Interface
	IFace.TV_EFFECT,
	IFace.EXP_LINE,
	IFace.PROGRESS,
	IFace.REPBAR,
	IFace.MISSION_MES,
	IFace.VISUAL_TIMER,
	IFace.HACK_LOCK,
	IFace.CAM_EFFECT,
	IFace.BUY_MENU,
	IFace.SELECT_MENU,
	IFace.SELECTER,
	//	Player Interface
	IFace.INTERFACE,
	IFace.LOGO,
	IFace.RESTART,
	IFace.WANTED,
	//	Inventory
	IFace.INVENTORY,
	//	Player
	IFace.PHONE,
	//	House
	IFace.HOUSE_ENTER_MENU,
	IFace.HOUSE_FUR,
	//	Job
	IFace.WORK_INFO,
	//	Vehicle
	IFace.SPEEDO,
}

// enum IFace.E_GROUPS_INFO
// {
// 	bool:gToggleMouse,
// 	gFunction[32],
// }
// new const IFace.GroupsInfo[IFace.E_GROUPS][IFace.E_GROUPS_INFO] = {
// 	{ false,	"" },
// 	//	Interface
// 	{ false,	"" },
// 	{ false,	#IFace.ExpLine_Toggle },
// 	{ false,	#IFace.Progress_Toggle },
// 	{ false,	#IFace.RepBar_Toggle },
// 	{ false,	#IFace.Mission_Message_Toggle },
// 	{ false,	#IFace.VisualTimer_Toggle },
// 	{ false,	#IFace.HackLock_Toggle },
// 	{ false,	#IFace.CamEffect_Toggle },
// 	{ true,		#IFace.BuyMenu_Toggle },
// 	{ true,		#IFace.SelectMenu_Toggle },
// 	{ true,		#IFace.Selecter_Toggle },
// 	//	Player Interface
// 	{ false,	#IFace.Player_Toggle }, 
// 	{ false,	"" },
// 	{ false,	"" },
// 	{ false,	#IFace.Wanted_Toggle },
// 	//	Inventory
// 	{ true,		#IFace.Inv_Toggle },
// 	//	Player
// 	{ false,	#IFace.Phone_Toggle },
// 	{ false,	#IFace.House_EnterMenuToggle },
// 	//	House
// 	{ false,	#IFace.House_FurToggle },
// 	//	Job
// 	{ false,	#IFace.Job_Toggle },
// 	//	Vehicle
// 	{ false,	#IFace.Veh_Toggle }
// };

enum E_GUI_TD
{
	Text:td_objectInfo,
	Text:td_Reg[5],
	Text:td_AdmPanel,
	Text:td_SpecPanel[11],
}
new GUI_TD[E_GUI_TD];

enum E_GUI_PTD
{
	PlayerText:ptd_ChangeMoney,
	PlayerText:ptd_objectInfo[2],
	PlayerText:ptd_SpecInfo
}
new GUI_PlayerTD[E_GUI_PTD];
