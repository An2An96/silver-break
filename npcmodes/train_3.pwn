#include <a_npc>

#define NUM_PLAYBACK_FILES 	6

new gPlaybackFileCycle = 0;

enum    stationInfo {
	stName[ 32 ],
	stTime
}

new stationsInfo[ NUM_PLAYBACK_FILES ][ stationInfo ] = {
	{	"Las Venturas City Train Station",	60	},  //  ����� ��������� �� ��������� ��������� ����� ������ ���� LV
	{	"Suburban Station Las Venturas",	30	},  //  2 ��������� LV
	{	"Fort Carson Train Station",		10	},  //  3 ��������� Fort Carson
	{	"San Fierro City Train Station",	60	},  //  4 ��������� SF
	{	"Los Santos Underground Station",	30	},  //  5 ��������� ������ LS
	{	"Los Santos City Train Station",	60	}   //  ����� ��������� �� ������� ������� LS
};

forward NextPlayback();

main(){
	SendChat( "1" );
	printf( "2" );
}

public NextPlayback() {
	if( gPlaybackFileCycle == NUM_PLAYBACK_FILES )
		gPlaybackFileCycle = 0;

	new stmp[ 32 ];
	format( stmp, 32, "train%d", gPlaybackFileCycle + 1 );
	StartRecordingPlayback( PLAYER_RECORDING_TYPE_DRIVER, stmp );

	gPlaybackFileCycle++;
	SendChat( "[�����]: ����� ������������..." ) ;
}

public OnRecordingPlaybackEnd() {
    new stmp[ 32 ];
    format( stmp, -1, "[�����]: %s [����� ���������: %d ���.], ��������� ���������: %s", stationsInfo[ gPlaybackFileCycle - 1 ][ stName ], stationsInfo[ gPlaybackFileCycle - 1 ][ stTime ], stationsInfo[ gPlaybackFileCycle ][ stName ] );
	SendChat( stmp );
	SetTimer( "NextPlayback", stationsInfo[ gPlaybackFileCycle - 1 ][ stTime ] * 1000, 0);
}

public OnNPCEnterVehicle( vehicleid, seatid ) {
    NextPlayback();
    SendChat( "NPC Train enter vehicle" );
}

public OnNPCExitVehicle()
{
    StopRecordingPlayback();
    gPlaybackFileCycle = 0;
    SendChat( "NPC Train exit vehicle" );
}
