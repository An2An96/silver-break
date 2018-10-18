#if defined _player_phone_included
	#endinput
#endif
#define _player_phone_included

#include "faction/police/header"

#define PHONE_BASE_POS_X	35.0
#define PHONE_BASE_POS_Y	305.0

#define COST_PHONE_CALL 		5.0 	// ��������� ������ ��������� �� ��������
#define COST_PHONE_SMS  		1.0 	// ��������� ���

forward OnPlayerPhoneCall(playerid, number);
forward IFace.Phone_Load_Base();
forward IFace.Phone_Load_Player(playerid);
forward Phone_GetSpeaker(playerid);
forward Phone_GetStatus(playerid);

// 	0 - �� ��� ������/���� �������/� ��� ��������
// 	1 - ������ ������
// 	2 - �������������� �������� (	��� ������ ������ ����� ������ (��� ����������)
//									��� ��������� ������ ����� ��������� � �������� )
enum
{
	PHONE_OFF,		//	��� ������
	PHONE_WAIT,		//	�� �������� � �����
	PHONE_CALL,		//	���� ������
	PHONE_SPEAK,	//	�� �������� � �� ��������������
	PHONE_ANSWER	//	���� ��������� � �� ��������������
}
new call_phone[MAX_PLAYERS][3];
new SMS_Buffer[MAX_PLAYERS][12][128]; // ��� ������
new phone_anim_ellipsis[MAX_PLAYERS char]; // ���-�� ����� ��� ������ (��� ������������� ������)
new phoneAction[MAX_PLAYERS];
new Text:phone_td[2];
new PlayerText:p_phone_td;