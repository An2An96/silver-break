// Objects
#define OBJ_POKER_TABLE 					19474
#define OBJ_CHIP_MACHINE					962

// GUI
#define GUI_POKER_TABLE						0

// Poker Misc
#define MAX_POKERTABLES 					100
#define MAX_POKERTABLEMISCOBJS				6
#define MAX_PLAYERPOKERUI					48
#define DRAWDISTANCE_POKER_TABLE 			150.0
#define DRAWDISTANCE_POKER_MISC 			50.0
#define CAMERA_POKER_INTERPOLATE_SPEED		5000 // ms (longer = slower)

// Chip Machine
#define MAX_CHIPMACHINES 					10
#define DRAWDISTANCE_CHIP_MACHINE			150.0
#define DRAWDISTANCE_CHIP_MACHINE_MISC		50.0

enum cmInfo
{
	cmPlaced,
	cmObjectID,
	Text3D:cmText3DID,
	Float:cmX,
	Float:cmY,
	Float:cmZ,
	Float:cmRX,
	Float:cmRY,
	Float:cmRZ,
	cmInt,
	cmVW,
};
new ChipMachine[MAX_CHIPMACHINES][cmInfo];

enum pkrInfo
{
	pkrActive,
	pkrPlaced,
	pkrObjectID,
	pkrMiscObjectID[MAX_POKERTABLEMISCOBJS],
	Text3D:pkrText3DID,
	Float:pkrX,
	Float:pkrY,
	Float:pkrZ,
	Float:pkrRX,
	Float:pkrRY,
	Float:pkrRZ,
	pkrVW,
	pkrInt,
	pkrPlayers,
	pkrActivePlayers,
	pkrActiveHands,
	pkrSlot[6],
	pkrPass[32],
	pkrLimit,
	pkrPulseTimer,
	pkrBuyInMax,
	pkrBuyInMin,
	pkrBlind,
	pkrTinkerLiveTime,
	pkrDelay,
	pkrSetDelay,
	pkrPos,
	pkrRotations,
	pkrSlotRotations,
	pkrActivePlayerID,
	pkrActivePlayerSlot,
	pkrRound,
	pkrStage,
	pkrActiveBet,
	pkrDeck[52],
	pkrCCards[5],
	pkrPot,
	pkrWinners,
	pkrWinnerID,
};
new PokerTable[MAX_POKERTABLES][pkrInfo];

new PlayerText:PlayerPokerUI[MAX_PLAYERS][MAX_PLAYERPOKERUI];

new const Float:PokerTableMiscObjOffsets[MAX_POKERTABLEMISCOBJS][6] = {
	{-1.25, -0.470, 0.1, 0.0, 0.0, 180.0}, // (Slot 2)
	{-1.25, 0.470, 0.1, 0.0, 0.0, 180.0}, // (Slot 1)
	{0.01, 1.85, 0.1, 0.0, 0.0, 90.0},  // (Slot 6)
	{1.25, 0.470, 0.1, 0.0, 0.0, 0.0}, // (Slot 5)
	{1.25, -0.470, 0.1, 0.0, 0.0, 0.0}, // (Slot 4)
	{-0.01, -1.85, 0.1, 0.0, 0.0, -90.0} // (Slot 3)
};

new const DeckTextdrw[53][] = {
	"LD_CARD:cdback", // CARD BACK
	"LD_CARD:cd1c", // A Clubs - 0
	"LD_CARD:cd2c", // 2 Clubs - 1
	"LD_CARD:cd3c", // 3 Clubs - 2
	"LD_CARD:cd4c", // 4 Clubs - 3
	"LD_CARD:cd5c", // 5 Clubs - 4
	"LD_CARD:cd6c", // 6 Clubs - 5
	"LD_CARD:cd7c", // 7 Clubs - 6
	"LD_CARD:cd8c", // 8 Clubs - 7
	"LD_CARD:cd9c", // 9 Clubs - 8
	"LD_CARD:cd10c", // 10 Clubs - 9
	"LD_CARD:cd11c", // J Clubs - 10
	"LD_CARD:cd12c", // Q Clubs - 11
	"LD_CARD:cd13c", // K Clubs - 12
	"LD_CARD:cd1d", // A Diamonds - 13
	"LD_CARD:cd2d", // 2 Diamonds - 14
	"LD_CARD:cd3d", // 3 Diamonds - 15
	"LD_CARD:cd4d", // 4 Diamonds - 16
	"LD_CARD:cd5d", // 5 Diamonds - 17
	"LD_CARD:cd6d", // 6 Diamonds - 18
	"LD_CARD:cd7d", // 7 Diamonds - 19
	"LD_CARD:cd8d", // 8 Diamonds - 20
	"LD_CARD:cd9d", // 9 Diamonds - 21
	"LD_CARD:cd10d", // 10 Diamonds - 22
	"LD_CARD:cd11d", // J Diamonds - 23
	"LD_CARD:cd12d", // Q Diamonds - 24
	"LD_CARD:cd13d", // K Diamonds - 25
	"LD_CARD:cd1h", // A Heats - 26
	"LD_CARD:cd2h", // 2 Heats - 27
	"LD_CARD:cd3h", // 3 Heats - 28
	"LD_CARD:cd4h", // 4 Heats - 29
	"LD_CARD:cd5h", // 5 Heats - 30
	"LD_CARD:cd6h", // 6 Heats - 31
	"LD_CARD:cd7h", // 7 Heats - 32
	"LD_CARD:cd8h", // 8 Heats - 33
	"LD_CARD:cd9h", // 9 Heats - 34
	"LD_CARD:cd10h", // 10 Heats - 35
	"LD_CARD:cd11h", // J Heats - 36
	"LD_CARD:cd12h", // Q Heats - 37
	"LD_CARD:cd13h", // K Heats - 38
	"LD_CARD:cd1s", // A Spades - 39
	"LD_CARD:cd2s", // 2 Spades - 40
	"LD_CARD:cd3s", // 3 Spades - 41
	"LD_CARD:cd4s", // 4 Spades - 42
	"LD_CARD:cd5s", // 5 Spades - 43
	"LD_CARD:cd6s", // 6 Spades - 44
	"LD_CARD:cd7s", // 7 Spades - 45
	"LD_CARD:cd8s", // 8 Spades - 46
	"LD_CARD:cd9s", // 9 Spades - 47
	"LD_CARD:cd10s", // 10 Spades - 48
	"LD_CARD:cd11s", // J Spades - 49
	"LD_CARD:cd12s", // Q Spades - 50
	"LD_CARD:cd13s" // K Spades - 51
};