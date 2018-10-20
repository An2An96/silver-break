#if defined _extend_keys_included
	#endinput
#endif
#define _extend_keys_included

#if !defined KEY_AIM
	#define KEY_AIM		KEY_HANDBRAKE
#endif
#define HOLDING(%0)		((newkeys & (%0)) == (%0))
#define PRESSED(%0)		(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0)	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

forward OnPlayerClickY(playerid);
forward OnPlayerClickN(playerid);
forward OnPlayerClickH(playerid);
forward OnPlayerClickAlt(playerid);
forward OnPlayerClickEnter(playerid);
forward OnPlayerClickSubmission(playerid);

public	OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (PRESSED(KEY_YES))
	{
		return CallLocalFunction("OnPlayerClickY", "d", playerid);
	}
	else if (PRESSED(KEY_NO))
	{
		return CallLocalFunction("OnPlayerClickN", "d", playerid);
	}
	else if (PRESSED(KEY_CTRL_BACK))
	{
		return CallLocalFunction("OnPlayerClickH", "d", playerid);
	}
	else if (PRESSED(KEY_WALK))
    {
    	return CallLocalFunction("OnPlayerClickAlt", "d", playerid);
    }
	else if (PRESSED(KEY_SECONDARY_ATTACK))
    {
    	return CallLocalFunction("OnPlayerClickEnter", "d", playerid);
    }
	else if(PRESSED(KEY_SUBMISSION))
	{
		return CallLocalFunction("OnPlayerClickSubmission", "d", playerid);
	}

	#if defined Extend_OnPlayerKeyStateChange
		return (Extend_OnPlayerKeyStateChange(playerid, newkeys, oldkeys));
	#else
		return (1);
	#endif
}
#if defined _ALS_OnPlayerKeyStateChange
	#undef OnPlayerKeyStateChange
#else
	#define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange	Extend_OnPlayerKeyStateChange
#if defined Extend_OnPlayerKeyStateChange
	forward Extend_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif