#if defined _job_interface_included
	#endinput
#endif

#define _job_interface_included

static PlayerText:pJobInfo[2];

stock ShowWorkInfo(playerid, const titelCount[], count, const titleWage[], wage, model = INVALID_DATA)
{
	new string[32];
	if(strlen(titelCount))
	{
		format(string, sizeof(string), "%s: %d~n~", titelCount, count);
	}
	if(strlen(titleWage))
	{
		format(string, sizeof(string), "%s%s: $%d~n~", string, titleWage, wage);
	}
	PlayerTextDrawSetString(playerid, pJobInfo[1], string);
	PlayerTextDrawSetPreviewModel(playerid, pJobInfo[0], model);

	//if(!IFace.GetGroupToggle(playerid, IFace.WORK_INFO))
	//{
	IFace.ToggleGroup(playerid, IFace.WORK_INFO, true);
	//}
}

stock HideWorkInfo(playerid)
{
	IFace.ToggleGroup(playerid, IFace.WORK_INFO, false);
	return true;
}

stock WorkInfo_SetText(playerid, string[])
{
	if(IFace.GetGroupToggleAndVisible(playerid, IFace.WORK_INFO))
	{
		PlayerTextDrawSetString(playerid, pJobInfo[1], string);
		PlayerTextDrawShow(playerid, pJobInfo[0]);
	}
}

stock WorkInfo_SetPreviewVehCol(playerid, color1, color2)
{
	if(IFace.GetGroupToggleAndVisible(playerid, IFace.WORK_INFO))
	{
		PlayerTextDrawSetPreviewVehCol(playerid, pJobInfo[0], color1, color2);
		PlayerTextDrawShow(playerid, pJobInfo[0]);
	}	
}

Public: IFace.Job_Toggle(playerid, bool:toggle)
{
	if(toggle)
	{
		PlayerTextDrawShow(playerid, pJobInfo[0]);
        PlayerTextDrawShow(playerid, pJobInfo[1]);
	}
	else
	{
		PlayerTextDrawHide(playerid, pJobInfo[0]);
		PlayerTextDrawHide(playerid, pJobInfo[1]);
	}

	return true;
}

IFace.Job_Create_Player(playerid)
{
	pJobInfo[0] = CreatePlayerTextDraw(playerid, 530.0, 265.0, "1");
	PlayerTextDrawBackgroundColor(playerid, pJobInfo[0], 0);
	PlayerTextDrawFont(playerid, pJobInfo[0], 5);
	PlayerTextDrawLetterSize(playerid, pJobInfo[0], 0.5, 1.0);
	PlayerTextDrawColor(playerid, pJobInfo[0], -1);
	PlayerTextDrawSetOutline(playerid, pJobInfo[0], 0);
	PlayerTextDrawSetProportional(playerid, pJobInfo[0], 1);
	PlayerTextDrawSetShadow(playerid, pJobInfo[0], 0);
	PlayerTextDrawUseBox(playerid, pJobInfo[0], 1);
	PlayerTextDrawBoxColor(playerid, pJobInfo[0], 0);				// Без этого мигает модель
	PlayerTextDrawTextSize(playerid, pJobInfo[0], 60.0, 60.0);
	PlayerTextDrawSetPreviewModel(playerid, pJobInfo[0], 2912);			
	PlayerTextDrawSetPreviewRot(playerid, pJobInfo[0], -25.0, 10.0, -55.0, 1.0);

	pJobInfo[1] = CreatePlayerTextDraw(playerid, 560.0, 330.0, "text");
	PlayerTextDrawAlignment(playerid, pJobInfo[1], 2);
	PlayerTextDrawBackgroundColor(playerid, pJobInfo[1], 255);
	PlayerTextDrawFont(playerid, pJobInfo[1], 1);
	PlayerTextDrawLetterSize(playerid, pJobInfo[1], 0.3, 1.0);
	PlayerTextDrawColor(playerid, pJobInfo[1], -1347440726);
	PlayerTextDrawSetOutline(playerid, pJobInfo[1], 0);
	PlayerTextDrawSetProportional(playerid, pJobInfo[1], 1);
	PlayerTextDrawSetShadow(playerid, pJobInfo[1], 0);
	PlayerTextDrawUseBox(playerid, pJobInfo[1], 1);
	PlayerTextDrawBoxColor(playerid, pJobInfo[1], INTERFACE_MAIN_COLOR);
	PlayerTextDrawTextSize(playerid, pJobInfo[1], 0.0, 85.0);
}
