/*  SA-MP Compatible Upgrades Function's
 *
 *		Version: 1.1
 *
 *  (c) Copyright 2011, AirKite
 */
 
#if defined _acuf_included
	#endinput
#endif
#define _acuf_included

stock IsVehicleUpgradeCompatible(model,componentid)
{
	switch(model)
	{
		case 400:
		{
			switch(componentid)
			{
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1013: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1021: { return 1; }
				case 1024: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 401:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1003: { return 1; }
				case 1004: { return 1; }
				case 1005: { return 1; }
				case 1006: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1013: { return 1; }
				case 1017: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1142: { return 1; }
				case 1143: { return 1; }
				case 1144: { return 1; }
			}
		}
		case 404:
		{
			switch(componentid)
			{
				case 1000: { return 1; }
				case 1002: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1013: { return 1; }
				case 1016: { return 1; }
				case 1017: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1021: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 405:
		{
			switch(componentid)
			{
				case 1000: { return 1; }
				case 1001: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1014: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1021: { return 1; }
				case 1023: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 410:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1003: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1013: { return 1; }
				case 1017: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1021: { return 1; }
				case 1023: { return 1; }
				case 1024: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 415:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1003: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1017: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1023: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 418:
		{
			switch(componentid)
			{
				case 1002: { return 1; }
				case 1006: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1016: { return 1; }
				case 1020: { return 1; }
				case 1021: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 420:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1003: { return 1; }
				case 1004: { return 1; }
				case 1005: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1019: { return 1; }
				case 1021: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 421:
		{
			switch(componentid)
			{
				case 1000: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1014: { return 1; }
				case 1016: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1021: { return 1; }
				case 1023: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 422:
		{
			switch(componentid)
			{
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1013: { return 1; }
				case 1017: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1021: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 426:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1003: { return 1; }
				case 1004: { return 1; }
				case 1005: { return 1; }
				case 1006: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1019: { return 1; }
				case 1021: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 436:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1003: { return 1; }
				case 1006: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1013: { return 1; }
				case 1017: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1021: { return 1; }
				case 1022: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 439:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1003: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1013: { return 1; }
				case 1017: { return 1; }
				case 1023: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1142: { return 1; }
				case 1143: { return 1; }
				case 1144: { return 1; }
				case 1145: { return 1; }
			}
		}
		case 477:
		{
			switch(componentid)
			{
				case 1006: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1017: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1021: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 478:
		{
			switch(componentid)
			{
				case 1004: { return 1; }
				case 1005: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1012: { return 1; }
				case 1013: { return 1; }
				case 1020: { return 1; }
				case 1021: { return 1; }
				case 1022: { return 1; }
				case 1024: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 489:
		{
			switch(componentid)
			{
				case 1000: { return 1; }
				case 1002: { return 1; }
				case 1004: { return 1; }
				case 1005: { return 1; }
				case 1006: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1013: { return 1; }
				case 1016: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1024: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 491:
		{
			switch(componentid)
			{
				case 1003: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1014: { return 1; }
				case 1017: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1021: { return 1; }
				case 1023: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1142: { return 1; }
				case 1143: { return 1; }
				case 1144: { return 1; }
				case 1145: { return 1; }
			}
		}
		case 492:
		{
			switch(componentid)
			{
				case 1000: { return 1; }
				case 1004: { return 1; }
				case 1005: { return 1; }
				case 1006: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1016: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 496:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1002: { return 1; }
				case 1003: { return 1; }
				case 1006: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1011: { return 1; }
				case 1017: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1023: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1142: { return 1; }
				case 1143: { return 1; }
			}
		}
		case 500:
		{
			switch(componentid)
			{
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1013: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1021: { return 1; }
				case 1024: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 516:
		{
			switch(componentid)
			{
				case 1000: { return 1; }
				case 1002: { return 1; }
				case 1004: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1015: { return 1; }
				case 1016: { return 1; }
				case 1017: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1021: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 517:
		{
			switch(componentid)
			{
				case 1002: { return 1; }
				case 1003: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1016: { return 1; }
				case 1017: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1023: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1142: { return 1; }
				case 1143: { return 1; }
				case 1144: { return 1; }
				case 1145: { return 1; }
			}
		}
		case 518:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1003: { return 1; }
				case 1005: { return 1; }
				case 1006: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1013: { return 1; }
				case 1017: { return 1; }
				case 1018: { return 1; }
				case 1020: { return 1; }
				case 1023: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1142: { return 1; }
				case 1143: { return 1; }
				case 1144: { return 1; }
				case 1145: { return 1; }
			}
		}
		case 527:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1014: { return 1; }
				case 1015: { return 1; }
				case 1017: { return 1; }
				case 1018: { return 1; }
				case 1020: { return 1; }
				case 1021: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 529:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1003: { return 1; }
				case 1006: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1011: { return 1; }
				case 1012: { return 1; }
				case 1017: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1023: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 534:
		{
			switch(componentid)
			{
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1100: { return 1; }
				case 1101: { return 1; }
				case 1106: { return 1; }
				case 1122: { return 1; }
				case 1123: { return 1; }
				case 1124: { return 1; }
				case 1125: { return 1; }
				case 1126: { return 1; }
				case 1127: { return 1; }
				case 1178: { return 1; }
				case 1179: { return 1; }
				case 1180: { return 1; }
				case 1185: { return 1; }
			}
		}
		case 535:
		{
			switch(componentid)
			{
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1109: { return 1; }
				case 1110: { return 1; }
				case 1113: { return 1; }
				case 1114: { return 1; }
				case 1115: { return 1; }
				case 1116: { return 1; }
				case 1117: { return 1; }
				case 1118: { return 1; }
				case 1119: { return 1; }
				case 1120: { return 1; }
				case 1121: { return 1; }
			}
		}
		case 536:
		{
			switch(componentid)
			{
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1103: { return 1; }
				case 1104: { return 1; }
				case 1105: { return 1; }
				case 1107: { return 1; }
				case 1108: { return 1; }
				case 1128: { return 1; }
				case 1181: { return 1; }
				case 1182: { return 1; }
				case 1183: { return 1; }
				case 1184: { return 1; }
			}
		}
		case 540:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1004: { return 1; }
				case 1006: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1017: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1023: { return 1; }
				case 1024: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1142: { return 1; }
				case 1143: { return 1; }
				case 1144: { return 1; }
				case 1145: { return 1; }
			}
		}
		case 542:
		{
			switch(componentid)
			{
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1014: { return 1; }
				case 1015: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1021: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1144: { return 1; }
				case 1145: { return 1; }
			}
		}
		case 546:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1002: { return 1; }
				case 1004: { return 1; }
				case 1006: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1017: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1023: { return 1; }
				case 1024: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1142: { return 1; }
				case 1143: { return 1; }
				case 1144: { return 1; }
				case 1145: { return 1; }
			}
		}
		case 547:
		{
			switch(componentid)
			{
				case 1000: { return 1; }
				case 1003: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1016: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1021: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1142: { return 1; }
				case 1143: { return 1; }
			}
		}
		case 549:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1003: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1011: { return 1; }
				case 1012: { return 1; }
				case 1017: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1023: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1142: { return 1; }
				case 1143: { return 1; }
				case 1144: { return 1; }
				case 1145: { return 1; }
			}
		}
		case 550:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1003: { return 1; }
				case 1004: { return 1; }
				case 1005: { return 1; }
				case 1006: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1023: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1142: { return 1; }
				case 1143: { return 1; }
				case 1144: { return 1; }
				case 1145: { return 1; }
			}
		}
		case 551:
		{
			switch(componentid)
			{
				case 1002: { return 1; }
				case 1003: { return 1; }
				case 1005: { return 1; }
				case 1006: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1016: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1021: { return 1; }
				case 1023: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 558:
		{
			switch(componentid)
			{
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1088: { return 1; }
				case 1089: { return 1; }
				case 1090: { return 1; }
				case 1091: { return 1; }
				case 1092: { return 1; }
				case 1093: { return 1; }
				case 1094: { return 1; }
				case 1095: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1163: { return 1; }
				case 1164: { return 1; }
				case 1165: { return 1; }
				case 1166: { return 1; }
				case 1167: { return 1; }
				case 1168: { return 1; }
			}
		}
		case 559:
		{
			switch(componentid)
			{
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1025: { return 1; }
				case 1065: { return 1; }
				case 1066: { return 1; }
				case 1067: { return 1; }
				case 1068: { return 1; }
				case 1069: { return 1; }
				case 1070: { return 1; }
				case 1071: { return 1; }
				case 1072: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1158: { return 1; }
				case 1159: { return 1; }
				case 1160: { return 1; }
				case 1161: { return 1; }
				case 1162: { return 1; }
				case 1173: { return 1; }
			}
		}
		case 560:
		{
			switch(componentid)
			{
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1025: { return 1; }
				case 1026: { return 1; }
				case 1027: { return 1; }
				case 1028: { return 1; }
				case 1029: { return 1; }
				case 1030: { return 1; }
				case 1031: { return 1; }
				case 1032: { return 1; }
				case 1033: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1138: { return 1; }
				case 1139: { return 1; }
				case 1140: { return 1; }
				case 1141: { return 1; }
				case 1169: { return 1; }
				case 1170: { return 1; }
			}
		}
		case 561:
		{
			switch(componentid)
			{
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1025: { return 1; }
				case 1055: { return 1; }
				case 1056: { return 1; }
				case 1057: { return 1; }
				case 1058: { return 1; }
				case 1059: { return 1; }
				case 1060: { return 1; }
				case 1061: { return 1; }
				case 1062: { return 1; }
				case 1063: { return 1; }
				case 1064: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1154: { return 1; }
				case 1155: { return 1; }
				case 1156: { return 1; }
				case 1157: { return 1; }
			}
		}
		case 562:
		{
			switch(componentid)
			{
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1025: { return 1; }
				case 1034: { return 1; }
				case 1035: { return 1; }
				case 1036: { return 1; }
				case 1037: { return 1; }
				case 1038: { return 1; }
				case 1039: { return 1; }
				case 1040: { return 1; }
				case 1041: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1146: { return 1; }
				case 1147: { return 1; }
				case 1148: { return 1; }
				case 1149: { return 1; }
				case 1171: { return 1; }
				case 1172: { return 1; }
			}
		}
		case 565:
		{
			switch(componentid)
			{
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1025: { return 1; }
				case 1045: { return 1; }
				case 1046: { return 1; }
				case 1047: { return 1; }
				case 1048: { return 1; }
				case 1049: { return 1; }
				case 1050: { return 1; }
				case 1051: { return 1; }
				case 1052: { return 1; }
				case 1053: { return 1; }
				case 1054: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1150: { return 1; }
				case 1151: { return 1; }
				case 1152: { return 1; }
				case 1153: { return 1; }
			}
		}
		case 567:
		{
			switch(componentid)
			{
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1102: { return 1; }
				case 1129: { return 1; }
				case 1130: { return 1; }
				case 1131: { return 1; }
				case 1132: { return 1; }
				case 1133: { return 1; }
				case 1186: { return 1; }
				case 1187: { return 1; }
				case 1188: { return 1; }
				case 1189: { return 1; }
			}
		}
		case 575:
		{
			switch(componentid)
			{
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1025: { return 1; }
				case 1042: { return 1; }
				case 1043: { return 1; }
				case 1044: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1099: { return 1; }
				case 1174: { return 1; }
				case 1175: { return 1; }
				case 1176: { return 1; }
				case 1177: { return 1; }
			}
		}
		case 576:
		{
			switch(componentid)
			{
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1134: { return 1; }
				case 1135: { return 1; }
				case 1136: { return 1; }
				case 1137: { return 1; }
				case 1190: { return 1; }
				case 1191: { return 1; }
				case 1192: { return 1; }
				case 1193: { return 1; }
			}
		}
		case 580:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1006: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1017: { return 1; }
				case 1018: { return 1; }
				case 1020: { return 1; }
				case 1023: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 585:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1003: { return 1; }
				case 1006: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1013: { return 1; }
				case 1017: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1023: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1142: { return 1; }
				case 1143: { return 1; }
				case 1144: { return 1; }
				case 1145: { return 1; }
			}
		}
		case 589:
		{
			switch(componentid)
			{
				case 1000: { return 1; }
				case 1004: { return 1; }
				case 1005: { return 1; }
				case 1006: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1013: { return 1; }
				case 1016: { return 1; }
				case 1017: { return 1; }
				case 1018: { return 1; }
				case 1020: { return 1; }
				case 1024: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1144: { return 1; }
				case 1145: { return 1; }
			}
		}
		case 600:
		{
			switch(componentid)
			{
				case 1004: { return 1; }
				case 1005: { return 1; }
				case 1006: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1013: { return 1; }
				case 1017: { return 1; }
				case 1018: { return 1; }
				case 1020: { return 1; }
				case 1022: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
		case 603:
		{
			switch(componentid)
			{
				case 1001: { return 1; }
				case 1006: { return 1; }
				case 1007: { return 1; }
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1017: { return 1; }
				case 1018: { return 1; }
				case 1019: { return 1; }
				case 1020: { return 1; }
				case 1023: { return 1; }
				case 1024: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
				case 1142: { return 1; }
				case 1143: { return 1; }
				case 1144: { return 1; }
				case 1145: { return 1; }
			}
		}
		case 402,403,406..409,411..414,416,419,423,424,427..429,431..435,437,438,440..445,448,450,451,455..459,461..463,466..468,470,471,474,475,479..486,490,494,495,498,499,502..510,514,515,521..526,528,530..533,541,552,543..545,554..557,566,568,578,571..574,579,581..584,586..588,591,594,596..599,601,602,604..611:
		{
			switch(componentid)
			{
				case 1008: { return 1; }
				case 1009: { return 1; }
				case 1010: { return 1; }
				case 1025: { return 1; }
				case 1073: { return 1; }
				case 1074: { return 1; }
				case 1075: { return 1; }
				case 1076: { return 1; }
				case 1077: { return 1; }
				case 1078: { return 1; }
				case 1079: { return 1; }
				case 1080: { return 1; }
				case 1081: { return 1; }
				case 1082: { return 1; }
				case 1083: { return 1; }
				case 1084: { return 1; }
				case 1085: { return 1; }
				case 1087: { return 1; }
				case 1096: { return 1; }
				case 1097: { return 1; }
				case 1098: { return 1; }
			}
		}
	}
	return 0;
}

stock GetVehicleCompatibleUpgrades(model, count, &component = 0)
{
	component = 0;
	switch(model)
	{
		case 400:
		{
			switch(count)
			{
				case 1: { component = 1008; }
				case 2: { component = 1009; }
				case 3: { component = 1010; }
				case 4: { component = 1013; }
				case 5: { component = 1018; }
				case 6: { component = 1019; }
				case 7: { component = 1020; }
				case 8: { component = 1021; }
				case 9: { component = 1024; }
				case 10: { component = 1025; }
				case 11: { component = 1073; }
				case 12: { component = 1074; }
				case 13: { component = 1075; }
				case 14: { component = 1076; }
				case 15: { component = 1077; }
				case 16: { component = 1078; }
				case 17: { component = 1079; }
				case 18: { component = 1080; }
				case 19: { component = 1081; }
				case 20: { component = 1082; }
				case 21: { component = 1083; }
				case 22: { component = 1084; }
				case 23: { component = 1085; }
				case 24: { component = 1087; }
				case 25: { component = 1096; }
				case 26: { component = 1097; }
				case 27: { component = 1098; }
			}
		}
		case 401:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1003; }
				case 3: { component = 1004; }
				case 4: { component = 1005; }
				case 5: { component = 1006; }
				case 6: { component = 1007; }
				case 7: { component = 1008; }
				case 8: { component = 1009; }
				case 9: { component = 1010; }
				case 10: { component = 1013; }
				case 11: { component = 1017; }
				case 12: { component = 1019; }
				case 13: { component = 1020; }
				case 14: { component = 1025; }
				case 15: { component = 1073; }
				case 16: { component = 1074; }
				case 17: { component = 1075; }
				case 18: { component = 1076; }
				case 19: { component = 1077; }
				case 20: { component = 1078; }
				case 21: { component = 1079; }
				case 22: { component = 1080; }
				case 23: { component = 1081; }
				case 24: { component = 1082; }
				case 25: { component = 1083; }
				case 26: { component = 1084; }
				case 27: { component = 1085; }
				case 28: { component = 1087; }
				case 29: { component = 1096; }
				case 30: { component = 1097; }
				case 31: { component = 1098; }
				case 32: { component = 1142; }
				case 33: { component = 1143; }
				case 34: { component = 1144; }
			}
		}
		case 404:
		{
			switch(count)
			{
				case 1: { component = 1000; }
				case 2: { component = 1002; }
				case 3: { component = 1007; }
				case 4: { component = 1008; }
				case 5: { component = 1009; }
				case 6: { component = 1010; }
				case 7: { component = 1013; }
				case 8: { component = 1016; }
				case 9: { component = 1017; }
				case 10: { component = 1019; }
				case 11: { component = 1020; }
				case 12: { component = 1021; }
				case 13: { component = 1025; }
				case 14: { component = 1073; }
				case 15: { component = 1074; }
				case 16: { component = 1075; }
				case 17: { component = 1076; }
				case 18: { component = 1077; }
				case 19: { component = 1078; }
				case 20: { component = 1079; }
				case 21: { component = 1080; }
				case 22: { component = 1081; }
				case 23: { component = 1082; }
				case 24: { component = 1083; }
				case 25: { component = 1084; }
				case 26: { component = 1085; }
				case 27: { component = 1087; }
				case 28: { component = 1096; }
				case 29: { component = 1097; }
				case 30: { component = 1098; }
			}
		}
		case 405:
		{
			switch(count)
			{
				case 1: { component = 1000; }
				case 2: { component = 1001; }
				case 3: { component = 1008; }
				case 4: { component = 1009; }
				case 5: { component = 1010; }
				case 6: { component = 1014; }
				case 7: { component = 1018; }
				case 8: { component = 1019; }
				case 9: { component = 1020; }
				case 10: { component = 1021; }
				case 11: { component = 1023; }
				case 12: { component = 1025; }
				case 13: { component = 1073; }
				case 14: { component = 1074; }
				case 15: { component = 1075; }
				case 16: { component = 1076; }
				case 17: { component = 1077; }
				case 18: { component = 1078; }
				case 19: { component = 1079; }
				case 20: { component = 1080; }
				case 21: { component = 1081; }
				case 22: { component = 1082; }
				case 23: { component = 1083; }
				case 24: { component = 1084; }
				case 25: { component = 1085; }
				case 26: { component = 1087; }
				case 27: { component = 1096; }
				case 28: { component = 1097; }
				case 29: { component = 1098; }
			}
		}
		case 410:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1003; }
				case 3: { component = 1007; }
				case 4: { component = 1008; }
				case 5: { component = 1009; }
				case 6: { component = 1010; }
				case 7: { component = 1013; }
				case 8: { component = 1017; }
				case 9: { component = 1019; }
				case 10: { component = 1020; }
				case 11: { component = 1021; }
				case 12: { component = 1023; }
				case 13: { component = 1024; }
				case 14: { component = 1025; }
				case 15: { component = 1073; }
				case 16: { component = 1074; }
				case 17: { component = 1075; }
				case 18: { component = 1076; }
				case 19: { component = 1077; }
				case 20: { component = 1078; }
				case 21: { component = 1079; }
				case 22: { component = 1080; }
				case 23: { component = 1081; }
				case 24: { component = 1082; }
				case 25: { component = 1083; }
				case 26: { component = 1084; }
				case 27: { component = 1085; }
				case 28: { component = 1087; }
				case 29: { component = 1096; }
				case 30: { component = 1097; }
				case 31: { component = 1098; }
			}
		}
		case 415:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1003; }
				case 3: { component = 1007; }
				case 4: { component = 1008; }
				case 5: { component = 1009; }
				case 6: { component = 1010; }
				case 7: { component = 1017; }
				case 8: { component = 1018; }
				case 9: { component = 1019; }
				case 10: { component = 1023; }
				case 11: { component = 1025; }
				case 12: { component = 1073; }
				case 13: { component = 1074; }
				case 14: { component = 1075; }
				case 15: { component = 1076; }
				case 16: { component = 1077; }
				case 17: { component = 1078; }
				case 18: { component = 1079; }
				case 19: { component = 1080; }
				case 20: { component = 1081; }
				case 21: { component = 1082; }
				case 22: { component = 1083; }
				case 23: { component = 1084; }
				case 24: { component = 1085; }
				case 25: { component = 1087; }
				case 26: { component = 1096; }
				case 27: { component = 1097; }
				case 28: { component = 1098; }
			}
		}
		case 418:
		{
			switch(count)
			{
				case 1: { component = 1002; }
				case 2: { component = 1006; }
				case 3: { component = 1008; }
				case 4: { component = 1009; }
				case 5: { component = 1010; }
				case 6: { component = 1016; }
				case 7: { component = 1020; }
				case 8: { component = 1021; }
				case 9: { component = 1025; }
				case 10: { component = 1073; }
				case 11: { component = 1074; }
				case 12: { component = 1075; }
				case 13: { component = 1076; }
				case 14: { component = 1077; }
				case 15: { component = 1078; }
				case 16: { component = 1079; }
				case 17: { component = 1080; }
				case 18: { component = 1081; }
				case 19: { component = 1082; }
				case 20: { component = 1083; }
				case 21: { component = 1084; }
				case 22: { component = 1085; }
				case 23: { component = 1087; }
				case 24: { component = 1096; }
				case 25: { component = 1097; }
				case 26: { component = 1098; }
			}
		}
		case 420:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1003; }
				case 3: { component = 1004; }
				case 4: { component = 1005; }
				case 5: { component = 1008; }
				case 6: { component = 1009; }
				case 7: { component = 1010; }
				case 8: { component = 1019; }
				case 9: { component = 1021; }
				case 10: { component = 1025; }
				case 11: { component = 1073; }
				case 12: { component = 1074; }
				case 13: { component = 1075; }
				case 14: { component = 1076; }
				case 15: { component = 1077; }
				case 16: { component = 1078; }
				case 17: { component = 1079; }
				case 18: { component = 1080; }
				case 19: { component = 1081; }
				case 20: { component = 1082; }
				case 21: { component = 1083; }
				case 22: { component = 1084; }
				case 23: { component = 1085; }
				case 24: { component = 1087; }
				case 25: { component = 1096; }
				case 26: { component = 1097; }
				case 27: { component = 1098; }
			}
		}
		case 421:
		{
			switch(count)
			{
				case 1: { component = 1000; }
				case 2: { component = 1008; }
				case 3: { component = 1009; }
				case 4: { component = 1010; }
				case 5: { component = 1014; }
				case 6: { component = 1016; }
				case 7: { component = 1018; }
				case 8: { component = 1019; }
				case 9: { component = 1020; }
				case 10: { component = 1021; }
				case 11: { component = 1023; }
				case 12: { component = 1025; }
				case 13: { component = 1073; }
				case 14: { component = 1074; }
				case 15: { component = 1075; }
				case 16: { component = 1076; }
				case 17: { component = 1077; }
				case 18: { component = 1078; }
				case 19: { component = 1079; }
				case 20: { component = 1080; }
				case 21: { component = 1081; }
				case 22: { component = 1082; }
				case 23: { component = 1083; }
				case 24: { component = 1084; }
				case 25: { component = 1085; }
				case 26: { component = 1087; }
				case 27: { component = 1096; }
				case 28: { component = 1097; }
				case 29: { component = 1098; }
			}
		}
		case 422:
		{
			switch(count)
			{
				case 1: { component = 1007; }
				case 2: { component = 1008; }
				case 3: { component = 1009; }
				case 4: { component = 1010; }
				case 5: { component = 1013; }
				case 6: { component = 1017; }
				case 7: { component = 1019; }
				case 8: { component = 1020; }
				case 9: { component = 1021; }
				case 10: { component = 1025; }
				case 11: { component = 1073; }
				case 12: { component = 1074; }
				case 13: { component = 1075; }
				case 14: { component = 1076; }
				case 15: { component = 1077; }
				case 16: { component = 1078; }
				case 17: { component = 1079; }
				case 18: { component = 1080; }
				case 19: { component = 1081; }
				case 20: { component = 1082; }
				case 21: { component = 1083; }
				case 22: { component = 1084; }
				case 23: { component = 1085; }
				case 24: { component = 1087; }
				case 25: { component = 1096; }
				case 26: { component = 1097; }
				case 27: { component = 1098; }
			}
		}
		case 426:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1003; }
				case 3: { component = 1004; }
				case 4: { component = 1005; }
				case 5: { component = 1006; }
				case 6: { component = 1008; }
				case 7: { component = 1009; }
				case 8: { component = 1010; }
				case 9: { component = 1019; }
				case 10: { component = 1021; }
				case 11: { component = 1025; }
				case 12: { component = 1073; }
				case 13: { component = 1074; }
				case 14: { component = 1075; }
				case 15: { component = 1076; }
				case 16: { component = 1077; }
				case 17: { component = 1078; }
				case 18: { component = 1079; }
				case 19: { component = 1080; }
				case 20: { component = 1081; }
				case 21: { component = 1082; }
				case 22: { component = 1083; }
				case 23: { component = 1084; }
				case 24: { component = 1085; }
				case 25: { component = 1087; }
				case 26: { component = 1096; }
				case 27: { component = 1097; }
				case 28: { component = 1098; }
			}
		}
		case 436:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1003; }
				case 3: { component = 1006; }
				case 4: { component = 1007; }
				case 5: { component = 1008; }
				case 6: { component = 1009; }
				case 7: { component = 1010; }
				case 8: { component = 1013; }
				case 9: { component = 1017; }
				case 10: { component = 1019; }
				case 11: { component = 1020; }
				case 12: { component = 1021; }
				case 13: { component = 1022; }
				case 14: { component = 1025; }
				case 15: { component = 1073; }
				case 16: { component = 1074; }
				case 17: { component = 1075; }
				case 18: { component = 1076; }
				case 19: { component = 1077; }
				case 20: { component = 1078; }
				case 21: { component = 1079; }
				case 22: { component = 1080; }
				case 23: { component = 1081; }
				case 24: { component = 1082; }
				case 25: { component = 1083; }
				case 26: { component = 1084; }
				case 27: { component = 1085; }
				case 28: { component = 1087; }
				case 29: { component = 1096; }
				case 30: { component = 1097; }
				case 31: { component = 1098; }
			}
		}
		case 439:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1003; }
				case 3: { component = 1007; }
				case 4: { component = 1008; }
				case 5: { component = 1009; }
				case 6: { component = 1010; }
				case 7: { component = 1013; }
				case 8: { component = 1017; }
				case 9: { component = 1023; }
				case 10: { component = 1025; }
				case 11: { component = 1073; }
				case 12: { component = 1074; }
				case 13: { component = 1075; }
				case 14: { component = 1076; }
				case 15: { component = 1077; }
				case 16: { component = 1078; }
				case 17: { component = 1079; }
				case 18: { component = 1080; }
				case 19: { component = 1081; }
				case 20: { component = 1082; }
				case 21: { component = 1083; }
				case 22: { component = 1084; }
				case 23: { component = 1085; }
				case 24: { component = 1087; }
				case 25: { component = 1096; }
				case 26: { component = 1097; }
				case 27: { component = 1098; }
				case 28: { component = 1142; }
				case 29: { component = 1143; }
				case 30: { component = 1144; }
				case 31: { component = 1145; }
			}
		}
		case 477:
		{
			switch(count)
			{
				case 1: { component = 1006; }
				case 2: { component = 1007; }
				case 3: { component = 1008; }
				case 4: { component = 1009; }
				case 5: { component = 1010; }
				case 6: { component = 1017; }
				case 7: { component = 1018; }
				case 8: { component = 1019; }
				case 9: { component = 1020; }
				case 10: { component = 1021; }
				case 11: { component = 1025; }
				case 12: { component = 1073; }
				case 13: { component = 1074; }
				case 14: { component = 1075; }
				case 15: { component = 1076; }
				case 16: { component = 1077; }
				case 17: { component = 1078; }
				case 18: { component = 1079; }
				case 19: { component = 1080; }
				case 20: { component = 1081; }
				case 21: { component = 1082; }
				case 22: { component = 1083; }
				case 23: { component = 1084; }
				case 24: { component = 1085; }
				case 25: { component = 1087; }
				case 26: { component = 1096; }
				case 27: { component = 1097; }
				case 28: { component = 1098; }
			}
		}
		case 478:
		{
			switch(count)
			{
				case 1: { component = 1004; }
				case 2: { component = 1005; }
				case 3: { component = 1008; }
				case 4: { component = 1009; }
				case 5: { component = 1010; }
				case 6: { component = 1012; }
				case 7: { component = 1013; }
				case 8: { component = 1020; }
				case 9: { component = 1021; }
				case 10: { component = 1022; }
				case 11: { component = 1024; }
				case 12: { component = 1025; }
				case 13: { component = 1073; }
				case 14: { component = 1074; }
				case 15: { component = 1075; }
				case 16: { component = 1076; }
				case 17: { component = 1077; }
				case 18: { component = 1078; }
				case 19: { component = 1079; }
				case 20: { component = 1080; }
				case 21: { component = 1081; }
				case 22: { component = 1082; }
				case 23: { component = 1083; }
				case 24: { component = 1084; }
				case 25: { component = 1085; }
				case 26: { component = 1087; }
				case 27: { component = 1096; }
				case 28: { component = 1097; }
				case 29: { component = 1098; }
			}
		}
		case 489:
		{
			switch(count)
			{
				case 1: { component = 1000; }
				case 2: { component = 1002; }
				case 3: { component = 1004; }
				case 4: { component = 1005; }
				case 5: { component = 1006; }
				case 6: { component = 1008; }
				case 7: { component = 1009; }
				case 8: { component = 1010; }
				case 9: { component = 1013; }
				case 10: { component = 1016; }
				case 11: { component = 1018; }
				case 12: { component = 1019; }
				case 13: { component = 1020; }
				case 14: { component = 1024; }
				case 15: { component = 1025; }
				case 16: { component = 1073; }
				case 17: { component = 1074; }
				case 18: { component = 1075; }
				case 19: { component = 1076; }
				case 20: { component = 1077; }
				case 21: { component = 1078; }
				case 22: { component = 1079; }
				case 23: { component = 1080; }
				case 24: { component = 1081; }
				case 25: { component = 1082; }
				case 26: { component = 1083; }
				case 27: { component = 1084; }
				case 28: { component = 1085; }
				case 29: { component = 1087; }
				case 30: { component = 1096; }
				case 31: { component = 1097; }
				case 32: { component = 1098; }
			}
		}
		case 491:
		{
			switch(count)
			{
				case 1: { component = 1003; }
				case 2: { component = 1007; }
				case 3: { component = 1008; }
				case 4: { component = 1009; }
				case 5: { component = 1010; }
				case 6: { component = 1014; }
				case 7: { component = 1017; }
				case 8: { component = 1018; }
				case 9: { component = 1019; }
				case 10: { component = 1020; }
				case 11: { component = 1021; }
				case 12: { component = 1023; }
				case 13: { component = 1025; }
				case 14: { component = 1073; }
				case 15: { component = 1074; }
				case 16: { component = 1075; }
				case 17: { component = 1076; }
				case 18: { component = 1077; }
				case 19: { component = 1078; }
				case 20: { component = 1079; }
				case 21: { component = 1080; }
				case 22: { component = 1081; }
				case 23: { component = 1082; }
				case 24: { component = 1083; }
				case 25: { component = 1084; }
				case 26: { component = 1085; }
				case 27: { component = 1087; }
				case 28: { component = 1096; }
				case 29: { component = 1097; }
				case 30: { component = 1098; }
				case 31: { component = 1142; }
				case 32: { component = 1143; }
				case 33: { component = 1144; }
				case 34: { component = 1145; }
			}
		}
		case 492:
		{
			switch(count)
			{
				case 1: { component = 1000; }
				case 2: { component = 1004; }
				case 3: { component = 1005; }
				case 4: { component = 1006; }
				case 5: { component = 1008; }
				case 6: { component = 1009; }
				case 7: { component = 1010; }
				case 8: { component = 1016; }
				case 9: { component = 1025; }
				case 10: { component = 1073; }
				case 11: { component = 1074; }
				case 12: { component = 1075; }
				case 13: { component = 1076; }
				case 14: { component = 1077; }
				case 15: { component = 1078; }
				case 16: { component = 1079; }
				case 17: { component = 1080; }
				case 18: { component = 1081; }
				case 19: { component = 1082; }
				case 20: { component = 1083; }
				case 21: { component = 1084; }
				case 22: { component = 1085; }
				case 23: { component = 1087; }
				case 24: { component = 1096; }
				case 25: { component = 1097; }
				case 26: { component = 1098; }
			}
		}
		case 496:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1002; }
				case 3: { component = 1003; }
				case 4: { component = 1006; }
				case 5: { component = 1007; }
				case 6: { component = 1008; }
				case 7: { component = 1009; }
				case 8: { component = 1010; }
				case 9: { component = 1011; }
				case 10: { component = 1017; }
				case 11: { component = 1019; }
				case 12: { component = 1020; }
				case 13: { component = 1023; }
				case 14: { component = 1025; }
				case 15: { component = 1073; }
				case 16: { component = 1074; }
				case 17: { component = 1075; }
				case 18: { component = 1076; }
				case 19: { component = 1077; }
				case 20: { component = 1078; }
				case 21: { component = 1079; }
				case 22: { component = 1080; }
				case 23: { component = 1081; }
				case 24: { component = 1082; }
				case 25: { component = 1083; }
				case 26: { component = 1084; }
				case 27: { component = 1085; }
				case 28: { component = 1087; }
				case 29: { component = 1096; }
				case 30: { component = 1097; }
				case 31: { component = 1098; }
				case 32: { component = 1142; }
				case 33: { component = 1143; }
			}
		}
		case 500:
		{
			switch(count)
			{
				case 1: { component = 1008; }
				case 2: { component = 1009; }
				case 3: { component = 1010; }
				case 4: { component = 1013; }
				case 5: { component = 1019; }
				case 6: { component = 1020; }
				case 7: { component = 1021; }
				case 8: { component = 1024; }
				case 9: { component = 1025; }
				case 10: { component = 1073; }
				case 11: { component = 1074; }
				case 12: { component = 1075; }
				case 13: { component = 1076; }
				case 14: { component = 1077; }
				case 15: { component = 1078; }
				case 16: { component = 1079; }
				case 17: { component = 1080; }
				case 18: { component = 1081; }
				case 19: { component = 1082; }
				case 20: { component = 1083; }
				case 21: { component = 1084; }
				case 22: { component = 1085; }
				case 23: { component = 1087; }
				case 24: { component = 1096; }
				case 25: { component = 1097; }
				case 26: { component = 1098; }
			}
		}
		case 516:
		{
			switch(count)
			{
				case 1: { component = 1000; }
				case 2: { component = 1002; }
				case 3: { component = 1004; }
				case 4: { component = 1007; }
				case 5: { component = 1008; }
				case 6: { component = 1009; }
				case 7: { component = 1010; }
				case 8: { component = 1015; }
				case 9: { component = 1016; }
				case 10: { component = 1017; }
				case 11: { component = 1018; }
				case 12: { component = 1019; }
				case 13: { component = 1020; }
				case 14: { component = 1021; }
				case 15: { component = 1025; }
				case 16: { component = 1073; }
				case 17: { component = 1074; }
				case 18: { component = 1075; }
				case 19: { component = 1076; }
				case 20: { component = 1077; }
				case 21: { component = 1078; }
				case 22: { component = 1079; }
				case 23: { component = 1080; }
				case 24: { component = 1081; }
				case 25: { component = 1082; }
				case 26: { component = 1083; }
				case 27: { component = 1084; }
				case 28: { component = 1085; }
				case 29: { component = 1087; }
				case 30: { component = 1096; }
				case 31: { component = 1097; }
				case 32: { component = 1098; }
			}
		}
		case 517:
		{
			switch(count)
			{
				case 1: { component = 1002; }
				case 2: { component = 1003; }
				case 3: { component = 1007; }
				case 4: { component = 1008; }
				case 5: { component = 1009; }
				case 6: { component = 1010; }
				case 7: { component = 1016; }
				case 8: { component = 1017; }
				case 9: { component = 1018; }
				case 10: { component = 1019; }
				case 11: { component = 1020; }
				case 12: { component = 1023; }
				case 13: { component = 1025; }
				case 14: { component = 1073; }
				case 15: { component = 1074; }
				case 16: { component = 1075; }
				case 17: { component = 1076; }
				case 18: { component = 1077; }
				case 19: { component = 1078; }
				case 20: { component = 1079; }
				case 21: { component = 1080; }
				case 22: { component = 1081; }
				case 23: { component = 1082; }
				case 24: { component = 1083; }
				case 25: { component = 1084; }
				case 26: { component = 1085; }
				case 27: { component = 1087; }
				case 28: { component = 1096; }
				case 29: { component = 1097; }
				case 30: { component = 1098; }
				case 31: { component = 1142; }
				case 32: { component = 1143; }
				case 33: { component = 1144; }
				case 34: { component = 1145; }
			}
		}
		case 518:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1003; }
				case 3: { component = 1005; }
				case 4: { component = 1006; }
				case 5: { component = 1007; }
				case 6: { component = 1008; }
				case 7: { component = 1009; }
				case 8: { component = 1010; }
				case 9: { component = 1013; }
				case 10: { component = 1017; }
				case 11: { component = 1018; }
				case 12: { component = 1020; }
				case 13: { component = 1023; }
				case 14: { component = 1025; }
				case 15: { component = 1073; }
				case 16: { component = 1074; }
				case 17: { component = 1075; }
				case 18: { component = 1076; }
				case 19: { component = 1077; }
				case 20: { component = 1078; }
				case 21: { component = 1079; }
				case 22: { component = 1080; }
				case 23: { component = 1081; }
				case 24: { component = 1082; }
				case 25: { component = 1083; }
				case 26: { component = 1084; }
				case 27: { component = 1085; }
				case 28: { component = 1087; }
				case 29: { component = 1096; }
				case 30: { component = 1097; }
				case 31: { component = 1098; }
				case 32: { component = 1142; }
				case 33: { component = 1143; }
				case 34: { component = 1144; }
				case 35: { component = 1145; }
			}
		}
		case 527:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1007; }
				case 3: { component = 1008; }
				case 4: { component = 1009; }
				case 5: { component = 1010; }
				case 6: { component = 1014; }
				case 7: { component = 1015; }
				case 8: { component = 1017; }
				case 9: { component = 1018; }
				case 10: { component = 1020; }
				case 11: { component = 1021; }
				case 12: { component = 1025; }
				case 13: { component = 1073; }
				case 14: { component = 1074; }
				case 15: { component = 1075; }
				case 16: { component = 1076; }
				case 17: { component = 1077; }
				case 18: { component = 1078; }
				case 19: { component = 1079; }
				case 20: { component = 1080; }
				case 21: { component = 1081; }
				case 22: { component = 1082; }
				case 23: { component = 1083; }
				case 24: { component = 1084; }
				case 25: { component = 1085; }
				case 26: { component = 1087; }
				case 27: { component = 1096; }
				case 28: { component = 1097; }
				case 29: { component = 1098; }
			}
		}
		case 529:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1003; }
				case 3: { component = 1006; }
				case 4: { component = 1007; }
				case 5: { component = 1008; }
				case 6: { component = 1009; }
				case 7: { component = 1010; }
				case 8: { component = 1011; }
				case 9: { component = 1012; }
				case 10: { component = 1017; }
				case 11: { component = 1018; }
				case 12: { component = 1019; }
				case 13: { component = 1020; }
				case 14: { component = 1023; }
				case 15: { component = 1025; }
				case 16: { component = 1073; }
				case 17: { component = 1074; }
				case 18: { component = 1075; }
				case 19: { component = 1076; }
				case 20: { component = 1077; }
				case 21: { component = 1078; }
				case 22: { component = 1079; }
				case 23: { component = 1080; }
				case 24: { component = 1081; }
				case 25: { component = 1082; }
				case 26: { component = 1083; }
				case 27: { component = 1084; }
				case 28: { component = 1085; }
				case 29: { component = 1087; }
				case 30: { component = 1096; }
				case 31: { component = 1097; }
				case 32: { component = 1098; }
			}
		}
		case 534:
		{
			switch(count)
			{
				case 1: { component = 1008; }
				case 2: { component = 1009; }
				case 3: { component = 1010; }
				case 4: { component = 1025; }
				case 5: { component = 1073; }
				case 6: { component = 1074; }
				case 7: { component = 1075; }
				case 8: { component = 1076; }
				case 9: { component = 1077; }
				case 10: { component = 1078; }
				case 11: { component = 1079; }
				case 12: { component = 1080; }
				case 13: { component = 1081; }
				case 14: { component = 1082; }
				case 15: { component = 1083; }
				case 16: { component = 1084; }
				case 17: { component = 1085; }
				case 18: { component = 1087; }
				case 19: { component = 1096; }
				case 20: { component = 1097; }
				case 21: { component = 1098; }
				case 22: { component = 1100; }
				case 23: { component = 1101; }
				case 24: { component = 1106; }
				case 25: { component = 1122; }
				case 26: { component = 1123; }
				case 27: { component = 1124; }
				case 28: { component = 1125; }
				case 29: { component = 1126; }
				case 30: { component = 1127; }
				case 31: { component = 1178; }
				case 32: { component = 1179; }
				case 33: { component = 1180; }
				case 34: { component = 1185; }
			}
		}
		case 535:
		{
			switch(count)
			{
				case 1: { component = 1008; }
				case 2: { component = 1009; }
				case 3: { component = 1010; }
				case 4: { component = 1025; }
				case 5: { component = 1073; }
				case 6: { component = 1074; }
				case 7: { component = 1075; }
				case 8: { component = 1076; }
				case 9: { component = 1077; }
				case 10: { component = 1078; }
				case 11: { component = 1079; }
				case 12: { component = 1080; }
				case 13: { component = 1081; }
				case 14: { component = 1082; }
				case 15: { component = 1083; }
				case 16: { component = 1084; }
				case 17: { component = 1085; }
				case 18: { component = 1087; }
				case 19: { component = 1096; }
				case 20: { component = 1097; }
				case 21: { component = 1098; }
				case 22: { component = 1109; }
				case 23: { component = 1110; }
				case 24: { component = 1113; }
				case 25: { component = 1114; }
				case 26: { component = 1115; }
				case 27: { component = 1116; }
				case 28: { component = 1117; }
				case 29: { component = 1118; }
				case 30: { component = 1119; }
				case 31: { component = 1120; }
				case 32: { component = 1121; }
			}
		}
		case 536:
		{
			switch(count)
			{
				case 1: { component = 1008; }
				case 2: { component = 1009; }
				case 3: { component = 1010; }
				case 4: { component = 1025; }
				case 5: { component = 1073; }
				case 6: { component = 1074; }
				case 7: { component = 1075; }
				case 8: { component = 1076; }
				case 9: { component = 1077; }
				case 10: { component = 1078; }
				case 11: { component = 1079; }
				case 12: { component = 1080; }
				case 13: { component = 1081; }
				case 14: { component = 1082; }
				case 15: { component = 1083; }
				case 16: { component = 1084; }
				case 17: { component = 1085; }
				case 18: { component = 1087; }
				case 19: { component = 1096; }
				case 20: { component = 1097; }
				case 21: { component = 1098; }
				case 22: { component = 1103; }
				case 23: { component = 1104; }
				case 24: { component = 1105; }
				case 25: { component = 1107; }
				case 26: { component = 1108; }
				case 27: { component = 1128; }
				case 28: { component = 1181; }
				case 29: { component = 1182; }
				case 30: { component = 1183; }
				case 31: { component = 1184; }
			}
		}
		case 540:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1004; }
				case 3: { component = 1006; }
				case 4: { component = 1007; }
				case 5: { component = 1008; }
				case 6: { component = 1009; }
				case 7: { component = 1010; }
				case 8: { component = 1017; }
				case 9: { component = 1018; }
				case 10: { component = 1019; }
				case 11: { component = 1020; }
				case 12: { component = 1023; }
				case 13: { component = 1024; }
				case 14: { component = 1025; }
				case 15: { component = 1073; }
				case 16: { component = 1074; }
				case 17: { component = 1075; }
				case 18: { component = 1076; }
				case 19: { component = 1077; }
				case 20: { component = 1078; }
				case 21: { component = 1079; }
				case 22: { component = 1080; }
				case 23: { component = 1081; }
				case 24: { component = 1082; }
				case 25: { component = 1083; }
				case 26: { component = 1084; }
				case 27: { component = 1085; }
				case 28: { component = 1087; }
				case 29: { component = 1096; }
				case 30: { component = 1097; }
				case 31: { component = 1098; }
				case 32: { component = 1142; }
				case 33: { component = 1143; }
				case 34: { component = 1144; }
				case 35: { component = 1145; }
			}
		}
		case 542:
		{
			switch(count)
			{
				case 1: { component = 1008; }
				case 2: { component = 1009; }
				case 3: { component = 1010; }
				case 4: { component = 1014; }
				case 5: { component = 1015; }
				case 6: { component = 1018; }
				case 7: { component = 1019; }
				case 8: { component = 1020; }
				case 9: { component = 1021; }
				case 10: { component = 1025; }
				case 11: { component = 1073; }
				case 12: { component = 1074; }
				case 13: { component = 1075; }
				case 14: { component = 1076; }
				case 15: { component = 1077; }
				case 16: { component = 1078; }
				case 17: { component = 1079; }
				case 18: { component = 1080; }
				case 19: { component = 1081; }
				case 20: { component = 1082; }
				case 21: { component = 1083; }
				case 22: { component = 1084; }
				case 23: { component = 1085; }
				case 24: { component = 1087; }
				case 25: { component = 1096; }
				case 26: { component = 1097; }
				case 27: { component = 1098; }
				case 28: { component = 1144; }
				case 29: { component = 1145; }
			}
		}
		case 546:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1002; }
				case 3: { component = 1004; }
				case 4: { component = 1006; }
				case 5: { component = 1007; }
				case 6: { component = 1008; }
				case 7: { component = 1009; }
				case 8: { component = 1010; }
				case 9: { component = 1017; }
				case 10: { component = 1018; }
				case 11: { component = 1019; }
				case 12: { component = 1023; }
				case 13: { component = 1024; }
				case 14: { component = 1025; }
				case 15: { component = 1073; }
				case 16: { component = 1074; }
				case 17: { component = 1075; }
				case 18: { component = 1076; }
				case 19: { component = 1077; }
				case 20: { component = 1078; }
				case 21: { component = 1079; }
				case 22: { component = 1080; }
				case 23: { component = 1081; }
				case 24: { component = 1082; }
				case 25: { component = 1083; }
				case 26: { component = 1084; }
				case 27: { component = 1085; }
				case 28: { component = 1087; }
				case 29: { component = 1096; }
				case 30: { component = 1097; }
				case 31: { component = 1098; }
				case 32: { component = 1142; }
				case 33: { component = 1143; }
				case 34: { component = 1144; }
				case 35: { component = 1145; }
			}
		}
		case 547:
		{
			switch(count)
			{
				case 1: { component = 1000; }
				case 2: { component = 1003; }
				case 3: { component = 1008; }
				case 4: { component = 1009; }
				case 5: { component = 1010; }
				case 6: { component = 1016; }
				case 7: { component = 1018; }
				case 8: { component = 1019; }
				case 9: { component = 1020; }
				case 10: { component = 1021; }
				case 11: { component = 1025; }
				case 12: { component = 1073; }
				case 13: { component = 1074; }
				case 14: { component = 1075; }
				case 15: { component = 1076; }
				case 16: { component = 1077; }
				case 17: { component = 1078; }
				case 18: { component = 1079; }
				case 19: { component = 1080; }
				case 20: { component = 1081; }
				case 21: { component = 1082; }
				case 22: { component = 1083; }
				case 23: { component = 1084; }
				case 24: { component = 1085; }
				case 25: { component = 1087; }
				case 26: { component = 1096; }
				case 27: { component = 1097; }
				case 28: { component = 1098; }
				case 29: { component = 1142; }
				case 30: { component = 1143; }
			}
		}
		case 549:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1003; }
				case 3: { component = 1007; }
				case 4: { component = 1008; }
				case 5: { component = 1009; }
				case 6: { component = 1010; }
				case 7: { component = 1011; }
				case 8: { component = 1012; }
				case 9: { component = 1017; }
				case 10: { component = 1018; }
				case 11: { component = 1019; }
				case 12: { component = 1020; }
				case 13: { component = 1023; }
				case 14: { component = 1025; }
				case 15: { component = 1073; }
				case 16: { component = 1074; }
				case 17: { component = 1075; }
				case 18: { component = 1076; }
				case 19: { component = 1077; }
				case 20: { component = 1078; }
				case 21: { component = 1079; }
				case 22: { component = 1080; }
				case 23: { component = 1081; }
				case 24: { component = 1082; }
				case 25: { component = 1083; }
				case 26: { component = 1084; }
				case 27: { component = 1085; }
				case 28: { component = 1087; }
				case 29: { component = 1096; }
				case 30: { component = 1097; }
				case 31: { component = 1098; }
				case 32: { component = 1142; }
				case 33: { component = 1143; }
				case 34: { component = 1144; }
				case 35: { component = 1145; }
			}
		}
		case 550:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1003; }
				case 3: { component = 1004; }
				case 4: { component = 1005; }
				case 5: { component = 1006; }
				case 6: { component = 1008; }
				case 7: { component = 1009; }
				case 8: { component = 1010; }
				case 9: { component = 1018; }
				case 10: { component = 1019; }
				case 11: { component = 1020; }
				case 12: { component = 1023; }
				case 13: { component = 1025; }
				case 14: { component = 1073; }
				case 15: { component = 1074; }
				case 16: { component = 1075; }
				case 17: { component = 1076; }
				case 18: { component = 1077; }
				case 19: { component = 1078; }
				case 20: { component = 1079; }
				case 21: { component = 1080; }
				case 22: { component = 1081; }
				case 23: { component = 1082; }
				case 24: { component = 1083; }
				case 25: { component = 1084; }
				case 26: { component = 1085; }
				case 27: { component = 1087; }
				case 28: { component = 1096; }
				case 29: { component = 1097; }
				case 30: { component = 1098; }
				case 31: { component = 1142; }
				case 32: { component = 1143; }
				case 33: { component = 1144; }
				case 34: { component = 1145; }
			}
		}
		case 551:
		{
			switch(count)
			{
				case 1: { component = 1002; }
				case 2: { component = 1003; }
				case 3: { component = 1005; }
				case 4: { component = 1006; }
				case 5: { component = 1008; }
				case 6: { component = 1009; }
				case 7: { component = 1010; }
				case 8: { component = 1016; }
				case 9: { component = 1018; }
				case 10: { component = 1019; }
				case 11: { component = 1020; }
				case 12: { component = 1021; }
				case 13: { component = 1023; }
				case 14: { component = 1025; }
				case 15: { component = 1073; }
				case 16: { component = 1074; }
				case 17: { component = 1075; }
				case 18: { component = 1076; }
				case 19: { component = 1077; }
				case 20: { component = 1078; }
				case 21: { component = 1079; }
				case 22: { component = 1080; }
				case 23: { component = 1081; }
				case 24: { component = 1082; }
				case 25: { component = 1083; }
				case 26: { component = 1084; }
				case 27: { component = 1085; }
				case 28: { component = 1087; }
				case 29: { component = 1096; }
				case 30: { component = 1097; }
				case 31: { component = 1098; }
			}
		}
		case 558:
		{
			switch(count)
			{
				case 1: { component = 1008; }
				case 2: { component = 1009; }
				case 3: { component = 1010; }
				case 4: { component = 1025; }
				case 5: { component = 1073; }
				case 6: { component = 1074; }
				case 7: { component = 1075; }
				case 8: { component = 1076; }
				case 9: { component = 1077; }
				case 10: { component = 1078; }
				case 11: { component = 1079; }
				case 12: { component = 1080; }
				case 13: { component = 1081; }
				case 14: { component = 1082; }
				case 15: { component = 1083; }
				case 16: { component = 1084; }
				case 17: { component = 1085; }
				case 18: { component = 1087; }
				case 19: { component = 1088; }
				case 20: { component = 1089; }
				case 21: { component = 1090; }
				case 22: { component = 1091; }
				case 23: { component = 1092; }
				case 24: { component = 1093; }
				case 25: { component = 1094; }
				case 26: { component = 1095; }
				case 27: { component = 1096; }
				case 28: { component = 1097; }
				case 29: { component = 1098; }
				case 30: { component = 1163; }
				case 31: { component = 1164; }
				case 32: { component = 1165; }
				case 33: { component = 1166; }
				case 34: { component = 1167; }
				case 35: { component = 1168; }
			}
		}
		case 559:
		{
			switch(count)
			{
				case 1: { component = 1008; }
				case 2: { component = 1009; }
				case 3: { component = 1010; }
				case 4: { component = 1025; }
				case 5: { component = 1065; }
				case 6: { component = 1066; }
				case 7: { component = 1067; }
				case 8: { component = 1068; }
				case 9: { component = 1069; }
				case 10: { component = 1070; }
				case 11: { component = 1071; }
				case 12: { component = 1072; }
				case 13: { component = 1073; }
				case 14: { component = 1074; }
				case 15: { component = 1075; }
				case 16: { component = 1076; }
				case 17: { component = 1077; }
				case 18: { component = 1078; }
				case 19: { component = 1079; }
				case 20: { component = 1080; }
				case 21: { component = 1081; }
				case 22: { component = 1082; }
				case 23: { component = 1083; }
				case 24: { component = 1084; }
				case 25: { component = 1085; }
				case 26: { component = 1087; }
				case 27: { component = 1096; }
				case 28: { component = 1097; }
				case 29: { component = 1098; }
				case 30: { component = 1158; }
				case 31: { component = 1159; }
				case 32: { component = 1160; }
				case 33: { component = 1161; }
				case 34: { component = 1162; }
				case 35: { component = 1173; }
			}
		}
		case 560:
		{
			switch(count)
			{
				case 1: { component = 1008; }
				case 2: { component = 1009; }
				case 3: { component = 1010; }
				case 4: { component = 1025; }
				case 5: { component = 1026; }
				case 6: { component = 1027; }
				case 7: { component = 1028; }
				case 8: { component = 1029; }
				case 9: { component = 1030; }
				case 10: { component = 1031; }
				case 11: { component = 1032; }
				case 12: { component = 1033; }
				case 13: { component = 1073; }
				case 14: { component = 1074; }
				case 15: { component = 1075; }
				case 16: { component = 1076; }
				case 17: { component = 1077; }
				case 18: { component = 1078; }
				case 19: { component = 1079; }
				case 20: { component = 1080; }
				case 21: { component = 1081; }
				case 22: { component = 1082; }
				case 23: { component = 1083; }
				case 24: { component = 1084; }
				case 25: { component = 1085; }
				case 26: { component = 1087; }
				case 27: { component = 1096; }
				case 28: { component = 1097; }
				case 29: { component = 1098; }
				case 30: { component = 1138; }
				case 31: { component = 1139; }
				case 32: { component = 1140; }
				case 33: { component = 1141; }
				case 34: { component = 1169; }
				case 35: { component = 1170; }
			}
		}
		case 561:
		{
			switch(count)
			{
				case 1: { component = 1008; }
				case 2: { component = 1009; }
				case 3: { component = 1010; }
				case 4: { component = 1025; }
				case 5: { component = 1055; }
				case 6: { component = 1056; }
				case 7: { component = 1057; }
				case 8: { component = 1058; }
				case 9: { component = 1059; }
				case 10: { component = 1060; }
				case 11: { component = 1061; }
				case 12: { component = 1062; }
				case 13: { component = 1063; }
				case 14: { component = 1064; }
				case 15: { component = 1073; }
				case 16: { component = 1074; }
				case 17: { component = 1075; }
				case 18: { component = 1076; }
				case 19: { component = 1077; }
				case 20: { component = 1078; }
				case 21: { component = 1079; }
				case 22: { component = 1080; }
				case 23: { component = 1081; }
				case 24: { component = 1082; }
				case 25: { component = 1083; }
				case 26: { component = 1084; }
				case 27: { component = 1085; }
				case 28: { component = 1087; }
				case 29: { component = 1096; }
				case 30: { component = 1097; }
				case 31: { component = 1098; }
				case 32: { component = 1154; }
				case 33: { component = 1155; }
				case 34: { component = 1156; }
				case 35: { component = 1157; }
			}
		}
		case 562:
		{
			switch(count)
			{
				case 1: { component = 1008; }
				case 2: { component = 1009; }
				case 3: { component = 1010; }
				case 4: { component = 1025; }
				case 5: { component = 1034; }
				case 6: { component = 1035; }
				case 7: { component = 1036; }
				case 8: { component = 1037; }
				case 9: { component = 1038; }
				case 10: { component = 1039; }
				case 11: { component = 1040; }
				case 12: { component = 1041; }
				case 13: { component = 1073; }
				case 14: { component = 1074; }
				case 15: { component = 1075; }
				case 16: { component = 1076; }
				case 17: { component = 1077; }
				case 18: { component = 1078; }
				case 19: { component = 1079; }
				case 20: { component = 1080; }
				case 21: { component = 1081; }
				case 22: { component = 1082; }
				case 23: { component = 1083; }
				case 24: { component = 1084; }
				case 25: { component = 1085; }
				case 26: { component = 1087; }
				case 27: { component = 1096; }
				case 28: { component = 1097; }
				case 29: { component = 1098; }
				case 30: { component = 1146; }
				case 31: { component = 1147; }
				case 32: { component = 1148; }
				case 33: { component = 1149; }
				case 34: { component = 1171; }
				case 35: { component = 1172; }
			}
		}
		case 565:
		{
			switch(count)
			{
				case 1: { component = 1008; }
				case 2: { component = 1009; }
				case 3: { component = 1010; }
				case 4: { component = 1025; }
				case 5: { component = 1045; }
				case 6: { component = 1046; }
				case 7: { component = 1047; }
				case 8: { component = 1048; }
				case 9: { component = 1049; }
				case 10: { component = 1050; }
				case 11: { component = 1051; }
				case 12: { component = 1052; }
				case 13: { component = 1053; }
				case 14: { component = 1054; }
				case 15: { component = 1073; }
				case 16: { component = 1074; }
				case 17: { component = 1075; }
				case 18: { component = 1076; }
				case 19: { component = 1077; }
				case 20: { component = 1078; }
				case 21: { component = 1079; }
				case 22: { component = 1080; }
				case 23: { component = 1081; }
				case 24: { component = 1082; }
				case 25: { component = 1083; }
				case 26: { component = 1084; }
				case 27: { component = 1085; }
				case 28: { component = 1087; }
				case 29: { component = 1096; }
				case 30: { component = 1097; }
				case 31: { component = 1098; }
				case 32: { component = 1150; }
				case 33: { component = 1151; }
				case 34: { component = 1152; }
				case 35: { component = 1153; }
			}
		}
		case 567:
		{
			switch(count)
			{
				case 1: { component = 1008; }
				case 2: { component = 1009; }
				case 3: { component = 1010; }
				case 4: { component = 1025; }
				case 5: { component = 1073; }
				case 6: { component = 1074; }
				case 7: { component = 1075; }
				case 8: { component = 1076; }
				case 9: { component = 1077; }
				case 10: { component = 1078; }
				case 11: { component = 1079; }
				case 12: { component = 1080; }
				case 13: { component = 1081; }
				case 14: { component = 1082; }
				case 15: { component = 1083; }
				case 16: { component = 1084; }
				case 17: { component = 1085; }
				case 18: { component = 1087; }
				case 19: { component = 1096; }
				case 20: { component = 1097; }
				case 21: { component = 1098; }
				case 22: { component = 1102; }
				case 23: { component = 1129; }
				case 24: { component = 1130; }
				case 25: { component = 1131; }
				case 26: { component = 1132; }
				case 27: { component = 1133; }
				case 28: { component = 1186; }
				case 29: { component = 1187; }
				case 30: { component = 1188; }
				case 31: { component = 1189; }
			}
		}
		case 575:
		{
			switch(count)
			{
				case 1: { component = 1008; }
				case 2: { component = 1009; }
				case 3: { component = 1010; }
				case 4: { component = 1025; }
				case 5: { component = 1042; }
				case 6: { component = 1043; }
				case 7: { component = 1044; }
				case 8: { component = 1073; }
				case 9: { component = 1074; }
				case 10: { component = 1075; }
				case 11: { component = 1076; }
				case 12: { component = 1077; }
				case 13: { component = 1078; }
				case 14: { component = 1079; }
				case 15: { component = 1080; }
				case 16: { component = 1081; }
				case 17: { component = 1082; }
				case 18: { component = 1083; }
				case 19: { component = 1084; }
				case 20: { component = 1085; }
				case 21: { component = 1087; }
				case 22: { component = 1096; }
				case 23: { component = 1097; }
				case 24: { component = 1098; }
				case 25: { component = 1099; }
				case 26: { component = 1174; }
				case 27: { component = 1175; }
				case 28: { component = 1176; }
				case 29: { component = 1177; }
			}
		}
		case 576:
		{
			switch(count)
			{
				case 1: { component = 1008; }
				case 2: { component = 1009; }
				case 3: { component = 1010; }
				case 4: { component = 1025; }
				case 5: { component = 1073; }
				case 6: { component = 1074; }
				case 7: { component = 1075; }
				case 8: { component = 1076; }
				case 9: { component = 1077; }
				case 10: { component = 1078; }
				case 11: { component = 1079; }
				case 12: { component = 1080; }
				case 13: { component = 1081; }
				case 14: { component = 1082; }
				case 15: { component = 1083; }
				case 16: { component = 1084; }
				case 17: { component = 1085; }
				case 18: { component = 1087; }
				case 19: { component = 1096; }
				case 20: { component = 1097; }
				case 21: { component = 1098; }
				case 22: { component = 1134; }
				case 23: { component = 1135; }
				case 24: { component = 1136; }
				case 25: { component = 1137; }
				case 26: { component = 1190; }
				case 27: { component = 1191; }
				case 28: { component = 1192; }
				case 29: { component = 1193; }
			}
		}
		case 580:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1006; }
				case 3: { component = 1007; }
				case 4: { component = 1008; }
				case 5: { component = 1009; }
				case 6: { component = 1010; }
				case 7: { component = 1017; }
				case 8: { component = 1018; }
				case 9: { component = 1020; }
				case 10: { component = 1023; }
				case 11: { component = 1025; }
				case 12: { component = 1073; }
				case 13: { component = 1074; }
				case 14: { component = 1075; }
				case 15: { component = 1076; }
				case 16: { component = 1077; }
				case 17: { component = 1078; }
				case 18: { component = 1079; }
				case 19: { component = 1080; }
				case 20: { component = 1081; }
				case 21: { component = 1082; }
				case 22: { component = 1083; }
				case 23: { component = 1084; }
				case 24: { component = 1085; }
				case 25: { component = 1087; }
				case 26: { component = 1096; }
				case 27: { component = 1097; }
				case 28: { component = 1098; }
			}
		}
		case 585:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1003; }
				case 3: { component = 1006; }
				case 4: { component = 1007; }
				case 5: { component = 1008; }
				case 6: { component = 1009; }
				case 7: { component = 1010; }
				case 8: { component = 1013; }
				case 9: { component = 1017; }
				case 10: { component = 1018; }
				case 11: { component = 1019; }
				case 12: { component = 1020; }
				case 13: { component = 1023; }
				case 14: { component = 1025; }
				case 15: { component = 1073; }
				case 16: { component = 1074; }
				case 17: { component = 1075; }
				case 18: { component = 1076; }
				case 19: { component = 1077; }
				case 20: { component = 1078; }
				case 21: { component = 1079; }
				case 22: { component = 1080; }
				case 23: { component = 1081; }
				case 24: { component = 1082; }
				case 25: { component = 1083; }
				case 26: { component = 1084; }
				case 27: { component = 1085; }
				case 28: { component = 1087; }
				case 29: { component = 1096; }
				case 30: { component = 1097; }
				case 31: { component = 1098; }
				case 32: { component = 1142; }
				case 33: { component = 1143; }
				case 34: { component = 1144; }
				case 35: { component = 1145; }
			}
		}
		case 589:
		{
			switch(count)
			{
				case 1: { component = 1000; }
				case 2: { component = 1004; }
				case 3: { component = 1005; }
				case 4: { component = 1006; }
				case 5: { component = 1007; }
				case 6: { component = 1008; }
				case 7: { component = 1009; }
				case 8: { component = 1010; }
				case 9: { component = 1013; }
				case 10: { component = 1016; }
				case 11: { component = 1017; }
				case 12: { component = 1018; }
				case 13: { component = 1020; }
				case 14: { component = 1024; }
				case 15: { component = 1025; }
				case 16: { component = 1073; }
				case 17: { component = 1074; }
				case 18: { component = 1075; }
				case 19: { component = 1076; }
				case 20: { component = 1077; }
				case 21: { component = 1078; }
				case 22: { component = 1079; }
				case 23: { component = 1080; }
				case 24: { component = 1081; }
				case 25: { component = 1082; }
				case 26: { component = 1083; }
				case 27: { component = 1084; }
				case 28: { component = 1085; }
				case 29: { component = 1087; }
				case 30: { component = 1096; }
				case 31: { component = 1097; }
				case 32: { component = 1098; }
				case 33: { component = 1144; }
				case 34: { component = 1145; }
			}
		}
		case 600:
		{
			switch(count)
			{
				case 1: { component = 1004; }
				case 2: { component = 1005; }
				case 3: { component = 1006; }
				case 4: { component = 1007; }
				case 5: { component = 1008; }
				case 6: { component = 1009; }
				case 7: { component = 1010; }
				case 8: { component = 1013; }
				case 9: { component = 1017; }
				case 10: { component = 1018; }
				case 11: { component = 1020; }
				case 12: { component = 1022; }
				case 13: { component = 1025; }
				case 14: { component = 1073; }
				case 15: { component = 1074; }
				case 16: { component = 1075; }
				case 17: { component = 1076; }
				case 18: { component = 1077; }
				case 19: { component = 1078; }
				case 20: { component = 1079; }
				case 21: { component = 1080; }
				case 22: { component = 1081; }
				case 23: { component = 1082; }
				case 24: { component = 1083; }
				case 25: { component = 1084; }
				case 26: { component = 1085; }
				case 27: { component = 1087; }
				case 28: { component = 1096; }
				case 29: { component = 1097; }
				case 30: { component = 1098; }
			}
		}
		case 603:
		{
			switch(count)
			{
				case 1: { component = 1001; }
				case 2: { component = 1006; }
				case 3: { component = 1007; }
				case 4: { component = 1008; }
				case 5: { component = 1009; }
				case 6: { component = 1010; }
				case 7: { component = 1017; }
				case 8: { component = 1018; }
				case 9: { component = 1019; }
				case 10: { component = 1020; }
				case 11: { component = 1023; }
				case 12: { component = 1024; }
				case 13: { component = 1025; }
				case 14: { component = 1073; }
				case 15: { component = 1074; }
				case 16: { component = 1075; }
				case 17: { component = 1076; }
				case 18: { component = 1077; }
				case 19: { component = 1078; }
				case 20: { component = 1079; }
				case 21: { component = 1080; }
				case 22: { component = 1081; }
				case 23: { component = 1082; }
				case 24: { component = 1083; }
				case 25: { component = 1084; }
				case 26: { component = 1085; }
				case 27: { component = 1087; }
				case 28: { component = 1096; }
				case 29: { component = 1097; }
				case 30: { component = 1098; }
				case 31: { component = 1142; }
				case 32: { component = 1143; }
				case 33: { component = 1144; }
				case 34: { component = 1145; }
			}
		}
		case 402,403,406..409,411..414,416,419,423,424,427..429,431..435,437,438,440..445,448,450,451,455..459,461..463,466..468,470,471,474,475,479..486,490,494,495,498,499,502..510,514,515,521..526,528,530..533,541,552,543..545,554..557,566,568,578,571..574,579,581..584,586..588,591,594,596..599,601,602,604..611:
		{
			switch(count)
			{
				case 1: { component = 1008; }
				case 2: { component = 1009; }
				case 3: { component = 1010; }
				case 4: { component = 1025; }
				case 5: { component = 1073; }
				case 6: { component = 1074; }
				case 7: { component = 1075; }
				case 8: { component = 1076; }
				case 9: { component = 1077; }
				case 10: { component = 1078; }
				case 11: { component = 1079; }
				case 12: { component = 1080; }
				case 13: { component = 1081; }
				case 14: { component = 1082; }
				case 15: { component = 1083; }
				case 16: { component = 1084; }
				case 17: { component = 1085; }
				case 18: { component = 1087; }
				case 19: { component = 1096; }
				case 20: { component = 1097; }
				case 21: { component = 1098; }
			}
		}
	}
	return component;
}

stock GetComponentType(componentid)
{
	switch(componentid)
	{
		case 1000..1003,1014..1016,1023,1049,1050,1058,1060,1138,1139,1146,1147,1158,1162..1164: return 0;
		case 1004,1005,1011,1012: return 1;
		case 1006,1032,1033,1035,1038,1053..1055,1061,1067,1068,1088,1091,1103,1128,1130,1131: return 2;
		case 1007,1017,1026,1027,1030,1031,1036,1039,1040..1042,1047,1048,1051,1052,1056,1057,1062,1063,1069,1070..1072,1090: return 3;
		case 1093..1095,1099,1101,1102,1106..1108,1118..1122,1124,1133,1134,1137: return 3;
		case 1013,1024: return 4;
		case 1008..1010: return 5;
		case 1018..1022,1028,1029,1034,1037,1043..1046,1059,1064..1066,1089,1092,1104,1105,1113,1114,1126,1127,1129,1132,1135,1136: return 6;
		case 1025,1073..1085,1096..1098: return 7;
		case 1086: return 8;
		case 1087: return 9;
		case 1117,1152,1153,1155,1157,1160,1165,1166,1169,1170..1174,1176,1179,1181,1182,1185,1188..1191: return 10;
		case 1140,1141,1148..1151,1154,1156,1159,1161,1167,1168,1175,1177,1178,1180,1183,1184,1186,1187,1192,1193: return 11;
		case 1143,1145: return 12;
		case 1142,1144: return 13;
		default: return -1;
	}
	return -1;
}
/*
native IsVehicleUpgradeCompatible(model,componentid);
native GetVehicleCompatibleUpgrades(model, count, &component = 0);
*/