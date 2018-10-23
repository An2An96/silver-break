#if defined _player_chat_game_included
	#endinput
#endif
#define _player_chat_game_included

new ChatGameTick; // 0 no game; > 0 going;
new ChatGameTimer;
new ChatGameRes[20];

Public:	StopChatGame()
{
	if (ChatGameTick)
	{
		new string[129];
		SendFormatMessageToAll(COLOR_WHITE, string, PREFIX_GAME "Никто не ответил на задание. Правильный ответ: '"SCOLOR_GAME"%s"SCOLOR_WHITE"'.", ChatGameRes);
		ChatGameTick = 0;
	}
}

stock	StartRandomChatGame()
{
	if(!ChatGameTick)
	{
		new string[128];
		switch(random(2))
		{
			case 0:
			{// Случайная строка
				new const SECRETWORDS[] = {
					'/', '!', '"', '@', '#', '$', '^', '&', '*', '(', ')', '-',
					'=', '+', '_', '.', '~', '1', '2', '3', '4', '5', '6', '7',
					'8', '9', '0', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O',
					'P', 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'Z', 'X',
					'C', 'V', 'B', 'N', 'M'
				};
				ChatGameRes = "";
				for(new c; c < 10; c++)
				{
					if(!c)
						ChatGameRes[c] = SECRETWORDS[random(sizeof(SECRETWORDS)-17)+17]; // без спец символов
					else 
						ChatGameRes[c] = SECRETWORDS[random(sizeof(SECRETWORDS))];
				}
				SendFormatMessageToAll(COLOR_WHITE, string, PREFIX_GAME "Напишите в чат '"SCOLOR_GAME"%s"SCOLOR_WHITE"' как можно быстрее!", ChatGameRes);
			}
			case 1:
			{// Арифметическое действие
				new acttext[20], num1, num2;
				switch(random(5))
				{
					case 0:
					{
						/*if(!random(2))	num1 = random(201)-100;
						else            num1 = random(2001)-1000;
						if(random(2))	num2 = random(100);
						else            num2 = random(1000);*/
						num1 = random(201)-100;
						num2 = random(201)-100;
						valstr(ChatGameRes, num1 + num2);
						if(num2 < 0) format(acttext, 20, "%d + (%d)", num1, num2);
						else         format(acttext, 20, "%d + %d", num1, num2);
					}
					case 1:
					{
						num1 = random(101);
						num2 = random(201)-100;
						valstr(ChatGameRes, num1 - num2);
						if(num2 < 0) format(acttext, 20, "%d – (%d)", num1, num2);
						else         format(acttext, 20, "%d – %d", num1, num2);
					}
					case 2:
					{
						if(!random(2))	num1 = random(23)-11;
						else            num1 = random(43)-21;
						if(random(2))	num2 = random(23)-11;
						else            num2 = random(43)-21;
						valstr(ChatGameRes, num1 * num2);
						if(num2 < 0) format(acttext, 20, "%d * (%d)", num1, num2);
						else         format(acttext, 20, "%d * %d", num1, num2);
					}
					case 3:
					{
						num2 = random(20) + 1;
						num1 = random(21) * num2;
						valstr(ChatGameRes, num1 / num2);
						format(acttext, 20, "%d / %d", num1, num2);

					}
					case 4:
					{
						if(random(3) == 0) num1 = 2;
						else num1 = random(12)+1;
						//
						if(num1 < 3) num2 = random(11);
						else if(3 < num1 < 5) num2 = random(5);
						else if(num1 >= 5) num2 = random(3);
						//
						valstr(ChatGameRes, floatround(floatpower(num1, num2)));
						format(acttext, 20, "%d^%d", num1, num2);
					}
				}
				SendFormatMessageToAll(COLOR_WHITE, string, PREFIX_GAME "Напишите в чат решение '"SCOLOR_GAME"%s = ?"SCOLOR_WHITE"' как можно быстрее!", acttext);
			}
		}
		ChatGameTick = GetTickCount();
		ChatGameTimer = SetTimer("StopChatGame", 30000, false);
	}
}
