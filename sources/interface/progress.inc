#if defined _interface_progress_included
	#endinput
#endif

#define _interface_progress_included

static 
	PlayerText:ProgressBar_ActiveLine,
	PlayerText:ProgressBar_Background,
	PlayerText:ProgressBar_Backbox,
	PlayerText:ProgressBar_Title;

Public: IFace.Progress_Toggle(playerid, bool:toggle)
{
	if(toggle)
	{
		PlayerTextDrawShow(playerid, ProgressBar_Background);
		PlayerTextDrawShow(playerid, ProgressBar_Backbox);	
	}
	else
	{
		PlayerTextDrawHide(playerid, ProgressBar_ActiveLine);
		PlayerTextDrawHide(playerid, ProgressBar_Background);
		PlayerTextDrawHide(playerid, ProgressBar_Backbox);
		PlayerTextDrawHide(playerid, ProgressBar_Title);
	}
}

stock ProgressBarUpdate(playerid, value, max = 100, title[] = "")
{
	IFace.ToggleGroup(playerid, IFace.PROGRESS, true);

	if(strlen(title) > 0)
	{
		PlayerTextDrawShow(playerid, ProgressBar_Title);
		PlayerTextDrawSetString(playerid, ProgressBar_Title, title);
	}
	if(value < 0) value = 0;
	if(value > max) max = value;
	new Float:k = 100.0 * value / max;
	PlayerTextDrawTextSize(playerid, ProgressBar_ActiveLine, 542.0 + 0.62 * k, 0.0);
	PlayerTextDrawHide(playerid, ProgressBar_ActiveLine);
	PlayerTextDrawShow(playerid, ProgressBar_ActiveLine);
}

stock ProgressBarHide(playerid)
{
	IFace.ToggleGroup(playerid, IFace.PROGRESS, false);
}

IFace.Progress_Create_Player(playerid)
{
	// Progress Bar
	ProgressBar_Title = CreatePlayerTextDraw(playerid, 535.0, 124.0, "Progress");
	PlayerTextDrawAlignment(playerid, ProgressBar_Title, 3);
	PlayerTextDrawBackgroundColor(playerid, ProgressBar_Title, 255);
	PlayerTextDrawFont(playerid, ProgressBar_Title, 2);
	PlayerTextDrawLetterSize(playerid, ProgressBar_Title, 0.4, 1.5);
	PlayerTextDrawColor(playerid, ProgressBar_Title, -554770177);
	PlayerTextDrawSetOutline(playerid, ProgressBar_Title, 1);
	PlayerTextDrawSetProportional(playerid, ProgressBar_Title, 1);

	ProgressBar_Backbox = CreatePlayerTextDraw(playerid, 610.0, 130.0, "_");
	PlayerTextDrawBackgroundColor(playerid, ProgressBar_Backbox, 255);
	PlayerTextDrawFont(playerid, ProgressBar_Backbox, 1);
	PlayerTextDrawLetterSize(playerid, ProgressBar_Backbox, 0.0, 0.5);
	PlayerTextDrawColor(playerid, ProgressBar_Backbox, -1);
	PlayerTextDrawSetOutline(playerid, ProgressBar_Backbox, 0);
	PlayerTextDrawSetProportional(playerid, ProgressBar_Backbox, 1);
	PlayerTextDrawSetShadow(playerid, ProgressBar_Backbox, 1);
	PlayerTextDrawUseBox(playerid, ProgressBar_Backbox, 1);
	PlayerTextDrawBoxColor(playerid, ProgressBar_Backbox, 255);
	PlayerTextDrawTextSize(playerid, ProgressBar_Backbox, 540.0, 0.0);

	ProgressBar_Background = CreatePlayerTextDraw(playerid, 608.0, 132.0, "_");
	PlayerTextDrawBackgroundColor(playerid, ProgressBar_Background, 255);
	PlayerTextDrawFont(playerid, ProgressBar_Background, 1);
	PlayerTextDrawLetterSize(playerid, ProgressBar_Background, 0.0, 0.1);
	PlayerTextDrawColor(playerid, ProgressBar_Background, 16711935);
	PlayerTextDrawSetOutline(playerid, ProgressBar_Background, 0);
	PlayerTextDrawSetProportional(playerid, ProgressBar_Background, 1);
	PlayerTextDrawSetShadow(playerid, ProgressBar_Background, 1);
	PlayerTextDrawUseBox(playerid, ProgressBar_Background, 1);
	PlayerTextDrawBoxColor(playerid, ProgressBar_Background, 2038731519);
	PlayerTextDrawTextSize(playerid, ProgressBar_Background, 542.0, 0.0);

	ProgressBar_ActiveLine = CreatePlayerTextDraw(playerid, 546.0, 132.0, "_");
	PlayerTextDrawBackgroundColor(playerid, ProgressBar_ActiveLine, 255);
	PlayerTextDrawFont(playerid, ProgressBar_ActiveLine, 1);
	PlayerTextDrawLetterSize(playerid, ProgressBar_ActiveLine, 0.0, 0.1);
	PlayerTextDrawColor(playerid, ProgressBar_ActiveLine, 16711935);
	PlayerTextDrawSetOutline(playerid, ProgressBar_ActiveLine, 0);
	PlayerTextDrawSetProportional(playerid, ProgressBar_ActiveLine, 1);
	PlayerTextDrawSetShadow(playerid, ProgressBar_ActiveLine, 1);
	PlayerTextDrawUseBox(playerid, ProgressBar_ActiveLine, 1);
	PlayerTextDrawBoxColor(playerid, ProgressBar_ActiveLine, -554770177);
	PlayerTextDrawTextSize(playerid, ProgressBar_ActiveLine, 542.0, 0.0);
}