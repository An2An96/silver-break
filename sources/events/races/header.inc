#if defined _events_races_header_included
	#endinput
#endif

#define _events_races_header_included

#define RACE_MAX_TIME			5 							// ������������ ����������������� ����� (���)
#define RACE_PRIZE              500     					// ������� �� ����� (1 ����� - 100%, 2 ����� - 50%, 3 ����� - 20%)
#define InRace[%0]    			Iter_Contains(Racer, %0)

//	Races
enum rInfo
{
	// Static Data (mysql)
	rID,            // raceid ����
	rName[32],		// �������� �����
	rCreater[32],	// �����
	rRecord,		// ������ ����� (��)
	rRecordBy[32],	// ����� �������
	// rType,		// ��� ����� - (������; ����; �����; �����; ���������; ��������; �����)
	// rOutTime,	// ����� �� ����� (���) - (�� ���� �������������)
	rVehicle,		// ���������
	// rWeather,	// ������ ����� - (���� ������ �������)
	// rTime,		// ����� ����� - (���� ������ �������)

	// Dynamic Data
	rStatus,		// ������ ����� (�� ��������(0), ��������(1), ������(2), ��� �����(3), ��� ������������(4))
	rAllPlayers,	// ���-�� ���������� �� ������ ������
	rPlayers,   	// ������� ���-�� ����������
	rFinisher,   	// ������� ���-�� ��������������
	//
	r_mapicon,      // (�� ��� ������)
	Text3D:r_text3d,// (�� 3� ������)
	rtimer,         // (�� �������)
	rtick,			// ������ �����
	rcount,         // ������� �������
	Float:rDist[MAX_PLAYERS],	// ��������� ������ �� ��
	rPos[MAX_PLAYERS],			// ��� �������� � ������� (MAX_PLAYERS) �� ������
	//
	cp_cache,   // ���������� ���������� ����������
	sp_cache,   // ���������� ���������� ����� �����
	ob_cache,   // ���������� ���������� ��������
};
new RaceInfo[rInfo];

enum cpInfo
{
	cp_Type,
	Float:cp_X,
	Float:cp_Y,
	Float:cp_Z,
	Float:cp_size,
};
new RaceCP[100][cpInfo];

enum spInfo
{
	sp_Status,// closed(-1), empty(0), busy(playerid+1)
	Float:sp_x,
	Float:sp_y,
	Float:sp_z,
	Float:sp_a,
};
new RaceSpawn[20][spInfo];

enum obInfo
{
	ob_object,
	ob_modelid,
	Float:ob_X,
	Float:ob_Y,
	Float:ob_Z,
	Float:ob_rX,
	Float:ob_rY,
	Float:ob_rZ,
};
new RaceObject[100][obInfo];
new pRaceCP[MAX_PLAYERS];
new RaceZone;
new Iterator:Racer<MAX_PLAYERS>;

//	IFace
new Text:s_RaceTD[6],
	Text:tdRaceBox,
	Text:tdRaceTitle,
	Text:tdRaceLine1,
	Text:tdRaceLine2;
new PlayerText:p_RaceTD,
	PlayerText:tdRacePos,
	PlayerText:tdRaceTime;