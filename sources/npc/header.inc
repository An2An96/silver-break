#if defined _npc_header_included
	#endinput
#endif
#define _npc_header_included

#include <FCNPC>

#define NPC.	NPC_

#define DEFAULT_NPC_COLOR	0x88AA8800

forward NPC.CreateRecordVehicle();

enum
{
	NPC_TrainDriver3,
	NPC_TrainDriver2,
	NPC_TrainDriver1,
	NPC_BusDriver1,
	NPC_BusDriver2,
	NPC_BusDriver3,
	NPC_BusDriver4
};

enum npc_Data
{
	n_Name[24],		//  имя
	n_Script[32], 	//  имя скрипта (Для станд системы)
	Float:n_Pos[4],	//  позиция
	n_Skin			//  скин
};

new	const NpcInfo[MAX_NPC][npc_Data] =
{	//	Последовательность из NPC_ID (обязательно!)
	//  При добавлении и удалении редактировать MAX_NPC
	//	Train Drivers
	{	"TrainDriver3",		"train_ls",	{ 1697.8, -1950.5, 14.1, 90.0 },	255	},
	{	"TrainDriver2",		"train_lv",	{ 1463.1, 2630.87, 10.8, 355.0 },	255	},
	{	"TrainDriver1",		"train_sf",	{ -1939.9, 174.08, 26.3, 355.0 },	255	}
	//{	"BusDriver1",		"",			{ 1180.6, -1749.8, 13.4, 0.0 },		255 },
	//{	"BusDriver2",		"",			{ 1184.5, -1817.7, 13.4, 0.0 }, 	255 },
	//{	"BusDriver3",		"",			{ 1184.5, -1831.9, 13.4, 0.0 }, 	255 },
	//{	"BusDriver4",		"",			{ 1184.5, -1831.9, 13.4, 0.0 }, 	255 }
};
new NPC_ID[MAX_NPC];
new BusVehicle[4];