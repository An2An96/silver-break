#define TESTING_MODE

#define Imitation::			Imitation_
#define ImitationPlayerID		0

//	данные имитаций
new PlayerState;

//	функции имитации
Imitation::GetPlayerState(playerid)
{
	#pragma unused playerid
	return PlayerState;
}
#define GetPlayerState	Imitation::GetPlayerState

Imitation::SetPlayerState(pstate)
{
	PlayerState = pstate;
}

//	инициализация тестов
CreateTests()
{
	printf("\n\n\n\nInitialization test's:");
	
	Test_PlayerKeyStateChange();
	
	printf("Testing end");
}

Test_PlayerKeyStateChange()
{
	print("Testing OnPlayerKeyStateChange:");
	
	//	Подготавливаем данные
	Imitation::SetPlayerState(PLAYER_STATE_ONFOOT);
	
	//	Вызываем тестируемую ф-ию
	CallLocalFunction("OnPlayerKeyStateChange", "iii", ImitationPlayerID, KEY_CTRL_BACK, 0);
	
	//	Выводим получившиеся данные
	
}