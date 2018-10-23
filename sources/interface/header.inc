#if defined INTERFACE_HEADER_INCLUDED
	#endinput
#endif

#define INTERFACE_HEADER_INCLUDED

#define INTERFACE_MAIN_COLOR					0x181B20AA
#define INTERFACE_CO_MAIN_COLOR					0xA32725FF
#define INTERFACE_BUTTON_COLOR					INTERFACE_CO_MAIN_COLOR

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
