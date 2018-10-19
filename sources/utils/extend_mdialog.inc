#include <mdialog>

forward Dialog_Timer();

static gDialogTimeleft[MAX_PLAYERS];

stock Extend_Dialog_Open(playerid, const function[], style, const caption[],
	const info[], const button1[], const button2[], dtl = 60)
{
	gDialogTimeleft[playerid] = dtl;
	return (Dialog_Open(playerid, function, style, caption, info, button1, button2));
}

#if defined _ALS_Dialog_Open
    #undef Dialog_Open
#else
    #define _ALS_Dialog_Open
#endif
#define Dialog_Open		Extend_Dialog_Open

stock Extend_Dialog_Message(playerid, caption[], info[], button1[], dtl = 60)
{
	return Dialog_Open(playerid, Dialog:Message, DIALOG_STYLE_MSGBOX, caption, info, button1, "", dtl);
}

#if defined _ALS_Dialog_Message
    #undef Dialog_Message
#else
    #define _ALS_Dialog_Message
#endif
#define Dialog_Message	Extend_Dialog_Message

stock	Extend_Dialog_Close(playerid)
{
	gDialogTimeleft[playerid] = 0;
	return (Dialog_Close(playerid));
}

#if defined _ALS_Dialog_Close
    #undef Dialog_Close
#else
    #define _ALS_Dialog_Close
#endif
#define Dialog_Close	Extend_Dialog_Close

//	Add by shelby	14/03/17
stock Dialog_CallResponse(playerid, function[], response, listitem, inputtext[])
{
	new call_func[MAX_FUNCTION_NAME char] = !"dre_";
	strcat(call_func, function);
	return CallLocalFunction(call_func, "ddds", playerid, response, listitem, inputtext);
}

public	Dialog_Timer()
{
	foreach (Player, i)
	{
		if (Dialog_IsOpen(i) && gDialogTimeleft[i] > 0 && --gDialogTimeleft[i] == 0)
		{
			GameTextForPlayer(i, "~r~Dialog canceled", 3000, 4);
			gDialogTimeleft[i] = -1;
			CallLocalFunction("OnDialogResponse", "iiiis", i, MDIALOG_DIALOG_ID, 0, 0, " ");
			if (gDialogTimeleft[i] == -1)
				Dialog_Close(i);	//	если в OnDialogResponse не показало нового диалога, закрываем текущий
		}
	}
	return true;
}

public	OnGameModeInit()
{
	SetTimer("Dialog_Timer", 1000, true);

	#if defined Extend_OnGameModeInit
        return Extend_OnGameModeInit();
    #else
        return 1;
    #endif
}
 
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Extend_OnGameModeInit
#if defined Extend_OnGameModeInit
    forward Extend_OnGameModeInit();
#endif