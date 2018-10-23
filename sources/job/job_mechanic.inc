stock CancelMechanicDuty(playerid)
{
	if(Job.GetPlayerNowWork(playerid) == JOB_MECHANIC)
	{
		new string[128];
		// Удаление иконки вызова
		if (IsPlayerLogged(MechanicClientid[playerid]))
		{
			new clientid = MechanicClientid[playerid];
			DestroyDynamicMapIcon(MechanicMapIcon[playerid]), MechanicMapIcon[playerid] = INVALID_STREAMER_ID;
			DestroyDynamicMapIcon(MechanicMapIcon[clientid]), MechanicMapIcon[clientid] = INVALID_STREAMER_ID;
			SendFormatMessage(MechanicClientid[playerid], COLOR_LIGHTBLUE, string, "%s закончил дежурство. Вызовите механика еще раз!", ReturnPlayerName(playerid));
		}
		//SendFormatMessage(playerid, COLOR_LIGHTBLUE, string, "Вы закончили дежурство и заработали: {FFFFFF}%d$", TaxiMoney[playerid]);
		MechanicClientid[playerid] = INVALID_PLAYER_ID;
		MechanicStatus[playerid] = 0;
		HideMissionMessage(playerid);
		//Job.ClearPlayerNowWork(playerid);
	}
	return true;
}