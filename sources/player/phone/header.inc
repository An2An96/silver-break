#if defined _player_phone_included
	#endinput
#endif
#define _player_phone_included

#include "faction/police/header"

#define PHONE_BASE_POS_X	35.0
#define PHONE_BASE_POS_Y	305.0

#define COST_PHONE_CALL 		5.0 	// —тоимость минуты разговора по телефону
#define COST_PHONE_SMS  		1.0 	// —тоимость —ћ—

forward OnPlayerPhoneCall(playerid, number);
forward IFace.Phone_Load_Base();
forward IFace.Phone_Load_Player(playerid);
forward Phone_GetSpeaker(playerid);
forward Phone_GetStatus(playerid);

// 	0 - ид кто звонит/кому звонишь/с кем говоришь
// 	1 - статус звонка
// 	2 - ƒополнительный параметр (	при звонке хранит врем€ вызова (дл€ автосброса)
//									при разговоре хранит врем€ разговора в секундах )
enum
{
	PHONE_OFF,		//	без звонка
	PHONE_WAIT,		//	ты позвонил и ждешь
	PHONE_CALL,		//	тебе звон€т
	PHONE_SPEAK,	//	ты позвонил и вы разговариваете
	PHONE_ANSWER	//	тебе позвонили и вы разговариваете
}
new call_phone[MAX_PLAYERS][3];
new SMS_Buffer[MAX_PLAYERS][12][128]; // смс игрока
new phone_anim_ellipsis[MAX_PLAYERS char]; // кол-во точек дл€ экрана (дл€ анимированого вызова)
new phoneAction[MAX_PLAYERS];
new Text:phone_td[2];
new PlayerText:p_phone_td;