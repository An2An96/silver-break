static 
	Text:lbt,
	Text:lbb;

IFace.ToggleTVEffect(playerid, bool:toggle)
{
	IFace.ToggleGroup(playerid, IFace.TV_EFFECT, toggle);
	return (1);
}

Public:	IFace.TVEffect_Toggled(playerid, bool:toggle)
{
	if (toggle)
	{
		TextDrawShowForPlayer(playerid, lbb);
		TextDrawShowForPlayer(playerid, lbt);	
	}
	else
	{
		TextDrawHideForPlayer(playerid, lbt);
		TextDrawHideForPlayer(playerid, lbb);
	}
	return (1);
}

public	OnTextDrawInit()
{
	IFace.AddWantHide(IFace.TV_EFFECT,	IFace.INTERFACE);

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

	#if defined TVEffect_OnTextDrawInit
		return (TVEffect_OnTextDrawInit());
	#else
		return (1);
	#endif
}
#if defined _ALS_OnTextDrawInit
	#undef OnTextDrawInit
#else
	#define _ALS_OnTextDrawInit
#endif
#define OnTextDrawInit TVEffect_OnTextDrawInit
#if defined TVEffect_OnTextDrawInit
	forward TVEffect_OnTextDrawInit();
#endif
