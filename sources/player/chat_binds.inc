#define MAX_CHAT_BINDS 	5
#define MAX_CMD_LEN		8

enum stChatBinds 
{
	sym,
	command[MAX_CMD_LEN]
}
new chatBind[MAX_PLAYERS][MAX_CHAT_BINDS][stChatBinds];

stock SendBindMessage(playerid, text[])
{
	for(new i = 0; i < MAX_CHAT_BINDS; i++)
	{
		if(text[0] == chatBind[playerid][i][sym])
		{
			new string[16];
			format(string, sizeof(string), "pc_cmd_%s", chatBind[playerid][i][command]);
			CallLocalFunction(string, "ds", playerid, text[1]);
			return true;
		}
	}
	return false;
}

//////////	Private		//////////
static GetChatBindsFreeSlot(playerid)
{
	for(new i; i < MAX_CHAT_BINDS; i++)
	{
		if(chatBind[playerid][i][sym] == 0)
		{
			return i;
		}
	}
	return -1;
}

//////////	Commands	//////////
CMD:binds(playerid, params[])
{
	return Dialog_Show(playerid, Dialog:ChatBinds);
}

//////////	Dialogs 	//////////
DialogCreate:ChatBinds(playerid)
{
	new freeslot = GetChatBindsFreeSlot(playerid);
	
	new string[192] = "Символ\tКоманда\n";
	strcat(string, ""MAIN_COLOR"• Восстановить по умолчанию\n");
	if(freeslot != -1) strcat(string, ""MAIN_COLOR"• {FFFFFF}Добавить новое правило\n");

	for(new i; i < MAX_CHAT_BINDS; i++)
	{
		if(chatBind[playerid][i][sym] != 0)
		{
			format(string, sizeof(string), "%s"MAIN_COLOR"• {FFFFFF}%c\t/%s\n", string, chatBind[playerid][i][sym], chatBind[playerid][i][command]);
		}
		else break;
	}
	Dialog_Open(playerid, Dialog:ChatBinds, DIALOG_STYLE_TABLIST_HEADERS, "Бинды команд", string, "Выбрать", "Закрыть");
	return true;
}

DialogResponse:ChatBinds(playerid, response, listitem, inputtext[])
{
    if (response)
    {
    	if(listitem == 0)
    	{
    		chatBind[playerid][0][sym]		= '!';
    		strmid(chatBind[playerid][0][command], "s", 0, MAX_CMD_LEN);

			chatBind[playerid][1][sym]		= '*';
			strmid(chatBind[playerid][1][command], "o", 0, MAX_CMD_LEN);

			chatBind[playerid][2][sym]		= '#';
			strmid(chatBind[playerid][2][command], "r", 0, MAX_CMD_LEN);

			chatBind[playerid][3][sym]		= '№';
			strmid(chatBind[playerid][3][command], "f", 0, MAX_CMD_LEN);

			SendClientMessage(playerid, COLOR_WHITE, "Бинды по умолчанию установлены");
			Dialog_Show(playerid, Dialog:ChatBinds);
    	}
    	else
    	{
    		new freeslot = GetChatBindsFreeSlot(playerid);
			if(freeslot != -1 && listitem == 1)	Dialog_Show(playerid, Dialog:ChatBindsCreate);
			else
			{
				Dialog_Open(playerid, Dialog:ChatBindManage, DIALOG_STYLE_MSGBOX, "Подтверждение", "{FFFFFF}Вы хотите удалить данное правило?", "Да", "Нет");
				SetPVarInt(playerid, "ChatBindIndex", listitem - 1);
			}
    	}
    }
    return 1;
}

DialogCreate:ChatBindsCreate(playerid)
{
	Dialog_Open(playerid, Dialog:ChatBindsCreate, DIALOG_STYLE_INPUT, "Задание нового правила", "{ffffff}Здесь Вы можете добавить правило для использования серверных команд\n\
				Введите символ, с которого должно начинаться отправленное Вами сообщение\n\
				и команду, которая должна будет вызваться через пробел.\n\n\
				Пример: "MAIN_COLOR"! /me{FFFFFF}\n\
				В результате этого все ваши сообщения, начинающиеся с восклицательного\n\
				знака, будут отправлены в /me чат", "Выбрать", "Назад");
	return true;
}

DialogResponse:ChatBindsCreate(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new freeslot = GetChatBindsFreeSlot(playerid);
		if (freeslot == -1)
		{
			SendClientMessage(playerid, -1, "Нет свободных слотов.");
		}
		else
		{
			new symbol, scommand[16];
			if (sscanf(inputtext, "p< >cs[16]", symbol, scommand))
			{
				SendClientMessage(playerid, -1, "Неверный формат.");
				Dialog_Show(playerid, Dialog:ChatBindsCreate);
				return 1;
			}
			chatBind[playerid][freeslot][sym] = symbol;
			format(chatBind[playerid][freeslot][command], MAX_CMD_LEN, "%s", scommand[1]);
		}
	}
	Dialog_Show(playerid, Dialog:ChatBinds);
	return true;
}

DialogResponse:ChatBindManage(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = GetPVarInt(playerid, "ChatBindIndex");
		for (; id < MAX_CHAT_BINDS - 1; id++)
		{
			chatBind[playerid][id][sym] = chatBind[playerid][id + 1][sym];
			format(chatBind[playerid][id][command], MAX_CMD_LEN, "%s", chatBind[playerid][id + 1][command]);
		}
		chatBind[playerid][id][sym] = 0;
		format(chatBind[playerid][id][command], MAX_CMD_LEN, "");
		SendClientMessage(playerid, -1, "Правило удалено.");
	}
	DeletePVar(playerid, "ChatBindIndex");
	return Dialog_Show(playerid, Dialog:ChatBinds);
}