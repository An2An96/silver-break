#if defined _headers_interface_included
  #endinput
#endif

#define _headers_interface_included

#define 	IFace.		IFace_

#define INTERFACE_SELECT_COLOR					0xB7BBC499	//	COLOR_SERVER
#define INTERFACE_MAIN_COLOR					0x181B20AA
#define INTERFACE_CO_MAIN_COLOR					0xA32725FF
#define INTERFACE_BUTTON_COLOR					INTERFACE_CO_MAIN_COLOR

forward IsPlayerChangeInterface(playerid, IFace.E_GROUPS:element, bool:toggle);
forward OnPlayerChangeInterface(playerid, IFace.E_GROUPS:element, bool:toggle);

enum IFace.E_GROUPS
{
	IFace.NONE,

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

enum IFace.E_GROUPS_INFO
{
	bool:gToggleMouse,
	gFunction[32],
}
new const IFace.GroupsInfo[IFace.E_GROUPS][IFace.E_GROUPS_INFO] = {
	{ false,	"" },
	//	Interface
	{ false,	"" },
	{ false,	#IFace.ExpLine_Toggle },
	{ false,	#IFace.Progress_Toggle },
	{ false,	#IFace.RepBar_Toggle },
	{ false,	#IFace.Mission_Message_Toggle },
	{ false,	#IFace.VisualTimer_Toggle },
	{ false,	#IFace.HackLock_Toggle },
	{ false,	#IFace.CamEffect_Toggle },
	{ true,		#IFace.BuyMenu_Toggle },
	{ true,		#IFace.SelectMenu_Toggle },
	{ true,		#IFace.Selecter_Toggle },
	//	Player Interface
	{ false,	#IFace.Player_Toggle }, 
	{ false,	"" },
	{ false,	"" },
	{ false,	#IFace.Wanted_Toggle },
	//	Inventory
	{ true,		#IFace.Inv_Toggle },
	//	Player
	{ false,	#IFace.Phone_Toggle },
	{ false,	#IFace.House_EnterMenuToggle },
	//	House
	{ false,	#IFace.House_FurToggle },
	//	Job
	{ false,	#IFace.Job_Toggle },
	//	Vehicle
	{ false,	#IFace.Veh_Toggle }
};

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

new const RusChars[] =
{	// Alt + 0XXX
	65,		// ¿ ('A')
	128,	// ¡ ('Ä')
	139,	// ¬ ('ã')
	130,	// √ ('Ç')
	131,	// ƒ ('É')
	69, 	// ≈ ('E')
	132,	// ∆ ('Ñ')
	136,	// « ('à')
	133,	// » ('Ö')
	157,	// … ('ù')
	75, 	//   ('K')
	135,	// À ('á')
	77, 	// Ã ('M')
	72, 	// Õ ('H')
	79, 	// Œ ('O')
	140,	// œ ('å')
	80, 	// – ('P')
	67, 	// — ('C')
	143,	// “ ('è')
	89, 	// ” ('Y')
	129,	// ‘ ('Å')
	88, 	// ’ ('X')
	137,	// ÷ ('â')
	141,	// ◊ ('ç')
	142,	// ÿ ('é')
	138,	// Ÿ ('ä')
	144, 	// ⁄ ('ê')
	145, 	// € ('ë')
	146, 	// ‹ ('í')
	147, 	// › ('ì')
	148, 	// ﬁ ('î')
	149, 	// ﬂ ('ï')ï°úkú: 120~n~ÉeÆ©ôú
	'a', // ‡ (97)
	'ó', // · (151)
	'¢', // ‚ (162)
	'ô', // „ (153)
	'ö', // ‰ (154)
	'e', // Â (101)
	'õ', // Ê (155)
	'ü', // Á (159)
	'ú', // Ë (156)
	'ù', // È (157)
	'k', // Í (107)
	'û', // Î (158)
	'Ø', // Ï (175)
	'Æ', // Ì (174)
	'o', // Ó (111)
	'£', // Ô (163)
	'p', //  (112)
	'c', // Ò (99)
	'¶', // Ú (166)
	'y', // Û (121)
	'¢', // Ù (152)	//	??????
	'x', // ı (120)
	'†', // ˆ (160)
	'§', // ˜ (164)
	'•', // ¯ (165)
	'°', // ˘ (161)
	'ß', // ˙ (167)
	'®', // ˚ (168)
	'©', // ¸ (169)
	'™', // ˝ (170)
	'´', // ˛ (171)
	'¨' // ˇ (172)
};
#pragma unused RusChars