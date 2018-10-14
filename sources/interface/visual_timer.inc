#if defined _interface_vtimer_included
    #endinput
#endif

#define _interface_vtimer_included

static 
    PlayerText:VTimer_TD,
    visualTimerTimer[MAX_PLAYERS];

Public: IFace.VisualTimer_Toggle(playerid, bool:toggle, bool:changeVisibility)
{
    if(!changeVisibility)
    {
        if(visualTimerTimer[playerid])
        {
            KillTimer(visualTimerTimer[playerid]);
            visualTimerTimer[playerid] = 0;
        }
    }
    if(toggle)
    {
        PlayerTextDrawShow(playerid, VTimer_TD);
    }
    else
    {
        
        PlayerTextDrawHide(playerid, VTimer_TD);
    }
}

Public: SetPlayerVisualTimer(playerid, time, bool:autoupdate)
{   
    IFace.ToggleGroup(playerid, IFace.VISUAL_TIMER, true);
    return IFace.VisualTimer_Update(playerid, time, autoupdate);
}

Public: HidePlayerVisualTimer(playerid)
{
    return IFace.ToggleGroup(playerid, IFace.VISUAL_TIMER, false);
}

Public: IFace.VisualTimer_Update(playerid, time, bool:autoupdate)
{
    if(time <= 0)
    {
        IFace.ToggleGroup(playerid, IFace.VISUAL_TIMER, false);
        CallLocalFunction("OnVisualTimerComplete", "d", playerid);
    }
    else
    {
        new string[16];
        format(string, 16, "%02d:%02d", time / 60, time % 60);
        PlayerTextDrawSetString(playerid, VTimer_TD, string);
        if(IFace.GetGroupVisible(playerid, IFace.VISUAL_TIMER))
        {
            PlayerTextDrawShow(playerid, VTimer_TD);
        }

        if(autoupdate)
        {
            visualTimerTimer[playerid] = SetPlayerTimerEx(playerid, "IFace_VisualTimer_Update", 1000, false, "iib", playerid, time - 1, true);
        }
    }
    return true;
}

IFace.VisualTimer_Load_Player(playerid)
{
    /*VTimer_TD = CreatePlayerTextDraw(playerid, 560.0, 140.0, "00:00");
    PlayerTextDrawBackgroundColor(playerid, VTimer_TD, 255);
    PlayerTextDrawFont(playerid, VTimer_TD, 2);
    PlayerTextDrawLetterSize(playerid, VTimer_TD, 0.4, 1.5);
    PlayerTextDrawColor(playerid, VTimer_TD, 0xB1C8FBFF);
    PlayerTextDrawSetOutline(playerid, VTimer_TD, 1);*/

    VTimer_TD = CreatePlayerTextDraw(playerid, 580.0, 140.0, "00:00");
    PlayerTextDrawAlignment(playerid, VTimer_TD, 2);
    PlayerTextDrawBackgroundColor(playerid, VTimer_TD, 0x0D0F11FF);
    PlayerTextDrawFont(playerid, VTimer_TD, 1);
    PlayerTextDrawLetterSize(playerid, VTimer_TD, 0.3, 1.5);
    PlayerTextDrawColor(playerid, VTimer_TD, -1);
    PlayerTextDrawSetOutline(playerid, VTimer_TD, 0);
    PlayerTextDrawSetProportional(playerid, VTimer_TD, 1);
    PlayerTextDrawSetShadow(playerid, VTimer_TD, 1);
    PlayerTextDrawUseBox(playerid, VTimer_TD, 1);
    PlayerTextDrawBoxColor(playerid, VTimer_TD, 0x181B20FF);
    PlayerTextDrawTextSize(playerid, VTimer_TD, 0.0, 45.0);
    return true;
}
