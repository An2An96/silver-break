#include "admin/header"
#include "player/header"

stock IsAdminsOnline()
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
	    case ADMIN_HELPER:		status = "Хелпер";
	    case ADMIN_IVENTER:		status = "Ивент-менеджер";
	    case ADMIN_MODER:		status = "Модератор";
	    case ADMIN_ADMIN:		status = "Администратор";
	    case ADMIN_GADMIN:		status = "Гл.Администратор";
	    case ADMIN_DEVELOPER:	status = "Разработчик";
	    default: format(status, 24, "AdmLvl-%d", adminlvl);
	}
	return status;
}

stock GetPlayerAdmin(playerid)
{
	if(AdminDuty[playerid])
	{
		if(IsPlayerAdmin(playerid))
			return (ADMIN_RCON);
		else
			return (PlayerInfo[playerid][pAdmin]);
	}
	return (0);
}