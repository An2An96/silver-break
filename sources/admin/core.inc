IsAdminsOnline()
{
	foreach(LoginPlayer, i)
	{
	    if(GetPlayerAdmin(i) && AdminDuty[i])
	    {
			return true;
	    }
	}
	return false;
}

stock SendAdminMessage(color, string[], admlvl = ADMIN_HELPER + 1)
{
    foreach(LoginPlayer, i)
    {
	    if(GetPlayerAdmin(i) >= admlvl)
	    {
	    	SendClientMessage(i, color, string);
	    }
    }
	Admin_Log(string);
	return true;
}

stock getAdminStatus(adminlvl)
{
	new status[24];
	switch(adminlvl)
	{
	    case ADMIN_NONE:        status = "Not Admin";
	    case ADMIN_HELPER:		status = "������";
	    case ADMIN_IVENTER:		status = "�����-��������";
	    case ADMIN_MODER:		status = "���������";
	    case ADMIN_ADMIN:		status = "�������������";
	    case ADMIN_GADMIN:		status = "��.�������������";
	    case ADMIN_DEVELOPER:	status = "�����������";
	    default: format(status, 24, "AdmLvl-%d", adminlvl);
	}
	return status;
}

stock GetPlayerAdmin(playerid)
{
	if(AdminDuty[playerid])
	{
		if(IsPlayerAdmin(playerid))		return ADMIN_RCON;
		else							return PlayerInfo[playerid][pAdmin];
	}
	else 								return 0;
}