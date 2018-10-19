#if defined _admin_header_included
	#endinput
#endif
#define _admin_header_included

forward SendAdminMessage(color, string[], admlvl = ADMIN_HELPER + 1);
forward getAdminStatus(adminlvl);
forward GetPlayerAdmin(playerid);
forward IsAdminsOnline();