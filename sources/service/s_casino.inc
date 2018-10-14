// Note: 0, 1 should be the hand, the rest are community cards.
AnaylzePokerHand(playerid, Hand[])
{
	new pokerArray[7];
	for(new i = 0; i < sizeof(pokerArray); i++)
		pokerArray[i] = Hand[i];

	new suitArray[4][13];
	new tmp = 0;
	new pairs = 0;
	new bool:isRoyalFlush = false;
	new bool:isFlush = false;
	new bool:isStraight = false;
	new bool:isFour = false;
	new bool:isThree = false;
	new bool:isTwoPair = false;
	new bool:isPair = false;

	// Convert Hand[] (AKA pokerArray) to suitArray[]
	for(new i = 0; i < sizeof(pokerArray); i++) 
	{
		if(pokerArray[i] <= 12)							suitArray[0][pokerArray[i]] = 1;		// Clubs (0 - 12)
		if(pokerArray[i] <= 25 && pokerArray[i] >= 13)	suitArray[1][pokerArray[i] - 13] = 1;	// Diamonds (13 - 25)
		if(pokerArray[i] <= 38 && pokerArray[i] >= 26)	suitArray[2][pokerArray[i] - 26] = 1;	// Hearts (26 - 38)
		if(pokerArray[i] <= 51 && pokerArray[i] >= 39)	suitArray[3][pokerArray[i] - 39] = 1;	// Spades (39 - 51)
	}

	// Royal Check
	for(new i = 0; i < 4; i++) 
	{
		if(suitArray[i][0] == 1 && suitArray[i][9] == 1 && suitArray[i][10] == 1 && suitArray[i][11] == 1 && suitArray[i][12] == 1) 
		{
			isRoyalFlush = true;
			break;
		}
	}
	tmp = 0;

	// Flush Check
	for(new i = 0; i < 4; i++) 
	{
		for(new j = 0; j < 13; j++) 
		{
			if(suitArray[i][j] == 1)
				tmp++;
		}

		if(tmp > 4) 
		{
			isFlush = true;
			break;
		} 
		else tmp = 0;
	}
	tmp = 0;

	// Four of a Kind Check
	// Three of a Kind Check
	for(new i = 0; i < 4; i++) 
	{
		for(new j = 0; j < 13; j++) 
		{
			if(suitArray[i][j] == 1) 
			{
				for(new c = 0; c < 4; c++) 
				{
					if(suitArray[c][j] == 1) 
						tmp++;
				}
				if(tmp == 4)		isFour = true;
				else if(tmp >= 3)	isThree = true;
				else 				tmp = 0;
			}
		}
	}
	tmp = 0;

	// Two Pair & Pair Check
	for(new j = 0; j < 13; j++) 
	{
		tmp = 0;
		for(new i = 0; i < 4; i++) 
		{
			if(suitArray[i][j] == 1 && ++tmp >= 2) 
			{
				isPair = true;
				pairs++;

				if(pairs >= 2)
					isTwoPair = true;
			}
		}
	}
	tmp = 0;

	// Straight Check
	for(new j = 0; j < 13; j++) 
	{
		for(new i = 0; i < 4; i++) 
		{
			if(suitArray[i][j] == 1) 
			{
				for(new s = 0; s < 5; s++) 
				{
					for(new c = 0; c < 4; c++) 
					{
						if(j + s == 13)
						{
							if(suitArray[c][0] == 1) 
							{
								tmp++;
								break;
							}
						}
						else if (j+s >= 14)
						{
							break;
						}
						else
						{
							if(suitArray[c][j + s] == 1) 
							{
								tmp++;
								break;
							}
						}
					}
				}
			}
			if(tmp >= 5)
				isStraight = true;
			tmp = 0;
		}
	}
	tmp = 0;

	// Convert Hand to Singles
	// Card 1
	if(pokerArray[0] > 12 && pokerArray[0] < 26) pokerArray[0] -= 13;
	if(pokerArray[0] > 25 && pokerArray[0] < 39) pokerArray[0] -= 26;
	if(pokerArray[0] > 38 && pokerArray[0] < 52) pokerArray[0] -= 39;
	if(pokerArray[0] == 0) pokerArray[0] = 13; // Convert Aces to worth 13.

	// Card 2
	if(pokerArray[1] > 12 && pokerArray[1] < 26) pokerArray[1] -= 13;
	if(pokerArray[1] > 25 && pokerArray[1] < 39) pokerArray[1] -= 26;
	if(pokerArray[1] > 38 && pokerArray[1] < 52) pokerArray[1] -= 39;
	if(pokerArray[1] == 0) pokerArray[1] = 13; // Convert Aces to worth 13.

	// 10) POKER_RESULT_ROYAL_FLUSH - A, K, Q, J, 10 (SAME SUIT) * ROYAL + FLUSH *
	if(isRoyalFlush) 
	{
		SetPVarString(playerid, "pkrResultString", "Royal Flush");
		return 1000 + pokerArray[0] + pokerArray[1];
	}

	// 9) POKER_RESULT_STRAIGHT_FLUSH - Any five card squence. (SAME SUIT) * STRAIGHT + FLUSH *
	if(isStraight && isFlush) 
	{
		SetPVarString(playerid, "pkrResultString", "Straight Flush");
		return 900 + pokerArray[0] + pokerArray[1];
	}

	// 8) POKER_RESULT_FOUR_KIND - All four cards of the same rank. * FOUR KIND *
	if(isFour) 
	{
		SetPVarString(playerid, "pkrResultString", "Four of a Kind");
		return 800 + pokerArray[0] + pokerArray[1];
	}

	// 7) POKER_RESULT_FULL_HOUSE - Three of a kind combined with a pair. * THREE KIND + PAIR *
	if(isThree && isTwoPair) 
	{
		SetPVarString(playerid, "pkrResultString", "Full House");
		return 700 + pokerArray[0] + pokerArray[1];
	}

	// 6) POKER_RESULT_FLUSH - Any five cards of the same suit, no sequence. * FLUSH *
	if(isFlush) 
	{
		SetPVarString(playerid, "pkrResultString", "Flush");
		return 600 + pokerArray[0] + pokerArray[1];
	}

	// 5) POKER_RESULT_STRAIGHT - Five cards in sequence, but not in the same suit. * STRAIGHT *
	if(isStraight) 
	{
		SetPVarString(playerid, "pkrResultString", "Straight");
		return 500 + pokerArray[0] + pokerArray[1];
	}

	// 4) POKER_RESULT_THREE_KIND - Three cards of the same rank. * THREE KIND *
	if(isThree) 
	{
		SetPVarString(playerid, "pkrResultString", "Three of a Kind");
		return 400 + pokerArray[0] + pokerArray[1];
	}

	// 3) POKER_RESULT_TWO_PAIR - Two seperate pair. * TWO PAIR *
	if(isTwoPair) 
	{
		SetPVarString(playerid, "pkrResultString", "Two Pair");
		return 300 + pokerArray[0] + pokerArray[1];
	}

	// 2) POKER_RESULT_PAIR - Two cards of the same rank. * PAIR *
	if(isPair) 
	{
		SetPVarString(playerid, "pkrResultString", "Pair");
		return 200 + pokerArray[0] + pokerArray[1];
	}

	// 1) POKER_RESULT_HIGH_CARD - Highest card.
	SetPVarString(playerid, "pkrResultString", "High Card");
	return pokerArray[0] + pokerArray[1];
}

SetPlayerPosObjectOffset(objectid, playerid, Float:offset_x, Float:offset_y, Float:offset_z)
{
	new Float:pos[6];
    GetDynamicObjectPos(objectid, Arr3<pos>);
    GetDynamicObjectRot(objectid, pos[3], pos[4], pos[5]);

    new Float:cos_x = floatcos(pos[3], degrees),
        Float:cos_y = floatcos(pos[4], degrees),
        Float:cos_z = floatcos(pos[5], degrees),
        Float:sin_x = floatsin(pos[3], degrees),
        Float:sin_y = floatsin(pos[4], degrees),
        Float:sin_z = floatsin(pos[5], degrees);

    new Float:x = pos[0] + offset_x * cos_y * cos_z - offset_x * sin_x * sin_y * sin_z - offset_y * cos_x * sin_z + offset_z * sin_y * cos_z + offset_z * sin_x * cos_y * sin_z;
    new Float:y = pos[1] + offset_x * cos_y * sin_z + offset_x * sin_x * sin_y * cos_z + offset_y * cos_x * cos_z + offset_z * sin_y * sin_z - offset_z * sin_x * cos_y * cos_z;
    new Float:z = pos[2] - offset_x * cos_x * sin_y + offset_y * sin_x + offset_z * cos_x * cos_y;

	MySetPlayerPos(playerid, x, y, z);
}

Public: PokerExit(playerid)
{
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, 1);
	ClearAnimations(playerid);
	CancelSelectTextDraw(playerid);
}

Public: PokerPulse(tableid)
{
	// Idle Animation Loop & Re-seater
	for(new i = 0; i < 6; i++) 
	{
		new playerid = PokerTable[tableid][pkrSlot][i];
		if(playerid != -1) 
		{	// Disable Weapons
			SetPlayerArmedWeapon(playerid,0);

			new idleRandom = random(100);
			if(idleRandom >= 90) 
			{
				SetPlayerPosObjectOffset(PokerTable[tableid][pkrObjectID], playerid, Arr3<PokerTableMiscObjOffsets[i]>);
				SetPlayerFacingAngle(playerid, PokerTableMiscObjOffsets[i][5]+90.0);

				// Animation
				if(GetPVarInt(playerid, "pkrActiveHand"))
					ApplyAnimation(playerid, "CASINO", "cards_loop", 4.1, 0, 1, 1, 1, 1, 1);
			}
		}
	}

	if(PokerTable[tableid][pkrActivePlayers] >= 2 && PokerTable[tableid][pkrActive] == 2) 
	{	// Count the number of active players with more than $0, activate the round if more than 1 gets counted.
		new tmpCount = 0;
		for(new i = 0; i < 6; i++) 
		{
			new playerid = PokerTable[tableid][pkrSlot][i];
			if(playerid != -1) 
			{
				if(GetPVarInt(playerid, "pkrChips") > 0)
					tmpCount++;
			}
		}
		if(tmpCount > 1) 
		{
			PokerTable[tableid][pkrActive] = 3;
			PokerTable[tableid][pkrDelay] = PokerTable[tableid][pkrSetDelay];
		}
	}

	if(PokerTable[tableid][pkrPlayers] < 2 && PokerTable[tableid][pkrActive] == 3) 
	{	// Pseudo Code (Move Pot towards last player's chip count)
		for(new i = 0; i < 6; i++) 
		{
			new playerid = PokerTable[tableid][pkrSlot][i];
			if(playerid != -1) 
			{
				SetPVarInt(playerid, "pkrChips", GetPVarInt(playerid, "pkrChips")+PokerTable[tableid][pkrPot]);

				LeavePokerTable(playerid);
				ResetPokerTable(tableid);
				JoinPokerTable(playerid, tableid);
			}
		}
	}

	// Winner Loop
	if(PokerTable[tableid][pkrActive] == 4)
	{
		if(PokerTable[tableid][pkrDelay] == 20) 
		{
			new endBetsSoundID[] = { 5826, 5827 };
			new randomEndBetsSoundID = random(2);
			GlobalPlaySound(endBetsSoundID[randomEndBetsSoundID], PokerTable[tableid][pkrX], PokerTable[tableid][pkrY], PokerTable[tableid][pkrZ]);

			for(new i = 0; i < 6; i++) 
			{
				new playerid = PokerTable[tableid][pkrSlot][i];
				if(playerid != -1) PokerOptions(playerid, 0);
			}
		}

		if(PokerTable[tableid][pkrDelay] > 0) 
		{
			PokerTable[tableid][pkrDelay]--;
			if(PokerTable[tableid][pkrDelay] <= 5 && PokerTable[tableid][pkrDelay] > 0) 
			{
				for(new i = 0; i < 6; i++) 
				{
					new playerid = PokerTable[tableid][pkrSlot][i];
					if(playerid != -1) PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
				}
			}
		}

		if(PokerTable[tableid][pkrDelay] == 0)
			return ResetPokerRound(tableid);

		if(PokerTable[tableid][pkrDelay] == 19) 
		{	// Anaylze Cards
			new resultArray[6];
			for(new i = 0; i < 6; i++) 
			{
				new playerid = PokerTable[tableid][pkrSlot][i];
				new cards[7];

				if(playerid != -1) 
				{
					if(GetPVarInt(playerid, "pkrActiveHand")) 
					{
						cards[0] = GetPVarInt(playerid, "pkrCard1");
						cards[1] = GetPVarInt(playerid, "pkrCard2");

						new tmp = 0;
						for(new c = 2; c < 7; c++) 
						{
							cards[c] = PokerTable[tableid][pkrCCards][tmp];
							tmp++;
						}
						SetPVarInt(playerid, "pkrResult", AnaylzePokerHand(playerid, cards));
					}
				}
			}

			// Sorting Results (Highest to Lowest)
			for(new i = 0; i < 6; i++) 
			{
				new playerid = PokerTable[tableid][pkrSlot][i];
				if(playerid != -1 && GetPVarInt(playerid, "pkrActiveHand")) 
				{
					resultArray[i] = GetPVarInt(playerid, "pkrResult");
				}
			}
			BubbleSort(resultArray, sizeof(resultArray));

			// Determine Winner(s)
			for(new i = 0; i < 6; i++) 
			{
				if(resultArray[5] == resultArray[i])
					PokerTable[tableid][pkrWinners]++;
			}

			// Notify Table of Winner & Give Rewards
			for(new i = 0; i < 6; i++) 
			{
				new playerid = PokerTable[tableid][pkrSlot][i];
				if(playerid != -1) 
				{
					if(PokerTable[tableid][pkrWinners] > 1) 
					{	// Split
						if(resultArray[5] == GetPVarInt(playerid, "pkrResult")) 
						{
							new splitPot = PokerTable[tableid][pkrPot]/PokerTable[tableid][pkrWinners];

							SetPVarInt(playerid, "pkrWinner", 1);
							SetPVarInt(playerid, "pkrChips", GetPVarInt(playerid, "pkrChips")+splitPot);

							PlayerPlaySound(playerid, 5821, 0.0, 0.0, 0.0);
						} 
						else
							PlayerPlaySound(playerid, 31202, 0.0, 0.0, 0.0);
					} 
					else 
					{	// Single Winner
						if(resultArray[5] == GetPVarInt(playerid, "pkrResult")) 
						{
							SetPVarInt(playerid, "pkrWinner", 1);
							SetPVarInt(playerid, "pkrChips", GetPVarInt(playerid, "pkrChips")+PokerTable[tableid][pkrPot]);
							PokerTable[tableid][pkrWinnerID] = playerid;

							new winnerSoundID[] = { 5847, 5848, 5849, 5854, 5855, 5856 };
							new randomWinnerSoundID = random(6);
							PlayerPlaySound(playerid, winnerSoundID[randomWinnerSoundID], 0.0, 0.0, 0.0);
						} 
						else
							PlayerPlaySound(playerid, 31202, 0.0, 0.0, 0.0);
					}
				}
			}
		}
	}

	// Game Loop
	if(PokerTable[tableid][pkrActive] == 3)
	{
		if(PokerTable[tableid][pkrActiveHands] == 1 && PokerTable[tableid][pkrRound] == 1) 
		{
			PokerTable[tableid][pkrStage] = 0;
			PokerTable[tableid][pkrActive] = 4;
			PokerTable[tableid][pkrDelay] = 20+1;

			for(new i = 0; i < 6; i++) 
			{
				new playerid = PokerTable[tableid][pkrSlot][i];

				if(playerid != -1 && GetPVarInt(playerid, "pkrActiveHand")) 
				{
					SetPVarInt(playerid, "pkrHide", 1);
				}
			}
		}

		// Delay Time Controller
		if(PokerTable[tableid][pkrDelay] > 0) 
		{
			PokerTable[tableid][pkrDelay]--;
			if(PokerTable[tableid][pkrDelay] <= 5 && PokerTable[tableid][pkrDelay] > 0) 
			{
				for(new i = 0; i < 6; i++) 
				{
					new playerid = PokerTable[tableid][pkrSlot][i];
					if(playerid != -1) PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
				}
			}
		}

		// Assign Blinds & Active Player
		if(PokerTable[tableid][pkrRound] == 0 && PokerTable[tableid][pkrDelay] == 5)
		{
			for(new i = 0; i < 6; i++) 
			{
				new playerid = PokerTable[tableid][pkrSlot][i];
				if(playerid != -1)	SetPVarInt(playerid, "pkrStatus", 1);
			}
			PokerAssignBlinds(tableid);
		}

		// If no round active, start it.
		if(PokerTable[tableid][pkrRound] == 0 && PokerTable[tableid][pkrDelay] == 0)
		{
			PokerTable[tableid][pkrRound] = 1;
			for(new i = 0; i < 6; i++) 
			{
				new playerid = PokerTable[tableid][pkrSlot][i];

				if(playerid != -1)	SetPVarString(playerid, "pkrStatusString", " ");
			}

			// Shuffle Deck & Deal Cards & Allocate Community Cards
			PokerShuffleDeck(tableid);
			PokerDealHands(tableid);
			PokerRotateActivePlayer(tableid);
		}

		// Round Logic

		// Time Controller
		for(new i = 0; i < 6; i++) 
		{
			new playerid = PokerTable[tableid][pkrSlot][i];
			if(playerid != -1 && GetPVarInt(playerid, "pkrActivePlayer")) 
			{
				SetPVarInt(playerid, "pkrTime", GetPVarInt(playerid, "pkrTime") - 1);
				if(GetPVarInt(playerid, "pkrTime") == 0) 
				{
					if(GetPVarInt(playerid, "pkrActionChoice")) 
					{
						DeletePVar(playerid, "pkrActionChoice");
						ShowPlayerDialog(playerid, -1, DIALOG_STYLE_LIST, "Close", "Close", "Close", "Close");
					}
					PokerFoldHand(playerid);
					PokerRotateActivePlayer(tableid);
				}
			}
		}
	}

	// Update GUI
	for(new i = 0; i < 6; i++) 
	{
		new playerid = PokerTable[tableid][pkrSlot][i];
		new tmp, tmpString[128];

		// Set Textdraw Offset
		switch(i)
		{
			case 0:	tmp = 0;
			case 1:	tmp = 5;
			case 2:	tmp = 10;
			case 3:	tmp = 15;
			case 4:	tmp = 20;
			case 5:	tmp = 25;
		}

		if(playerid != -1) 
		{
			// Debug
			if(showDebug[playerid])
			{
				new string[512];
				format(string, sizeof(string), "Debug:~n~pkrActive: %d~n~pkrPlayers: %d~n~pkrActivePlayers: %d~n~pkrActiveHands: %d~n~pkrPos: %d~n~pkrDelay: %d~n~pkrRound: %d~n~pkrStage: %d~n~pkrActiveBet: %d~n~pkrRotations: %d",
					PokerTable[tableid][pkrActive],
					PokerTable[tableid][pkrPlayers],
					PokerTable[tableid][pkrActivePlayers],
					PokerTable[tableid][pkrActiveHands],
					PokerTable[tableid][pkrPos],
					PokerTable[tableid][pkrDelay],
					PokerTable[tableid][pkrRound],
					PokerTable[tableid][pkrStage],
					PokerTable[tableid][pkrActiveBet],
					PokerTable[tableid][pkrRotations]
				);
				strcat(string, "~n~----------~n~");
				
				new sstring[128];
				GetPVarString(playerid, "pkrStatusString", sstring, 128);
				format(string, sizeof(string), "%spkrTableID: %d~n~pkrCurrentBet: %d~n~pkrStatus: %d~n~pkrRoomLeader: %d~n~pkrRoomBigBlind: %d~n~pkrRoomSmallBlind: %d~n~pkrRoomDealer: %d~n~pkrActivePlayer: %d~n~pkrActiveHand: %d~n~pkrStatusString: %s",
					string,
					GetPVarInt(playerid, "pkrTableID")-1,
					GetPVarInt(playerid, "pkrCurrentBet"),
					GetPVarInt(playerid, "pkrStatus"),
					GetPVarInt(playerid, "pkrRoomLeader"),
					GetPVarInt(playerid, "pkrRoomBigBlind"),
					GetPVarInt(playerid, "pkrRoomSmallBlind"),
					GetPVarInt(playerid, "pkrRoomDealer"),
					GetPVarInt(playerid, "pkrActivePlayer"),
					GetPVarInt(playerid, "pkrActiveHand"),
					sstring
				);
				PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][45], string);
			}
			
			// Name
			for(new td = 0; td < 6; td++) 
			{
				new pid = PokerTable[tableid][pkrSlot][td];
				if(pid != -1) PlayerTextDrawSetString(pid, PlayerPokerUI[pid][0+tmp], ReturnPlayerName(playerid));
			}

			// Chips
			if(GetPVarInt(playerid, "pkrChips") > 0)
					format(tmpString, sizeof(tmpString), "$%d", GetPVarInt(playerid, "pkrChips"));
			else	format(tmpString, sizeof(tmpString), "~r~$%d", GetPVarInt(playerid, "pkrChips"));
			
			for(new td = 0; td < 6; td++) 
			{
				new pid = PokerTable[tableid][pkrSlot][td];
				if(pid != -1) PlayerTextDrawSetString(pid, PlayerPokerUI[pid][1+tmp], tmpString);
			}

			// Cards
			for(new td = 0; td < 6; td++) 
			{
				new pid = PokerTable[tableid][pkrSlot][td];
				if(pid != -1) 
				{
					if(GetPVarInt(playerid, "pkrActiveHand")) 
					{
						if(playerid != pid) 
						{
							if(PokerTable[tableid][pkrActive] == 4 && PokerTable[tableid][pkrDelay] <= 19 && GetPVarInt(playerid, "pkrHide") != 1) 
							{
								format(tmpString, sizeof(tmpString), "%s", DeckTextdrw[GetPVarInt(playerid, "pkrCard1")+1]);
								PlayerTextDrawSetString(pid, PlayerPokerUI[pid][2+tmp], tmpString);
								format(tmpString, sizeof(tmpString), "%s", DeckTextdrw[GetPVarInt(playerid, "pkrCard2")+1]);
								PlayerTextDrawSetString(pid, PlayerPokerUI[pid][3+tmp], tmpString);
							} 
							else 
							{
								PlayerTextDrawSetString(pid, PlayerPokerUI[pid][2+tmp], DeckTextdrw[0]);
								PlayerTextDrawSetString(pid, PlayerPokerUI[pid][3+tmp], DeckTextdrw[0]);
							}
						} 
						else 
						{
							format(tmpString, sizeof(tmpString), "%s", DeckTextdrw[GetPVarInt(playerid, "pkrCard1")+1]);
							PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][2+tmp], tmpString);

							format(tmpString, sizeof(tmpString), "%s", DeckTextdrw[GetPVarInt(playerid, "pkrCard2")+1]);
							PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][3+tmp], tmpString);
						}
					}
					else 
					{
						PlayerTextDrawSetString(pid, PlayerPokerUI[pid][2+tmp], " ");
						PlayerTextDrawSetString(pid, PlayerPokerUI[pid][3+tmp], " ");
					}
				}
			}

			// Status
			if(PokerTable[tableid][pkrActive] < 3) 
			{
				format(tmpString, sizeof(tmpString), " ");
			} 
			else if(GetPVarInt(playerid, "pkrActivePlayer") && PokerTable[tableid][pkrActive] == 3) 
			{
				format(tmpString, sizeof(tmpString), "0:%d", GetPVarInt(playerid, "pkrTime"));
			} 
			else 
			{
				if(PokerTable[tableid][pkrActive] == 3 && PokerTable[tableid][pkrDelay] > 5) 
				{
					SetPVarString(playerid, "pkrStatusString", " ");
				}

				if(PokerTable[tableid][pkrActive] == 4 && PokerTable[tableid][pkrDelay] == 19) 
				{
					if(PokerTable[tableid][pkrWinners] == 1) 
					{
						if(GetPVarInt(playerid, "pkrWinner")) 
						{
							format(tmpString, sizeof(tmpString), "+$%d", PokerTable[tableid][pkrPot]);
							SetPVarString(playerid, "pkrStatusString", tmpString);
						} 
						else 
						{
							format(tmpString, sizeof(tmpString), "-$%d", GetPVarInt(playerid, "pkrCurrentBet"));
							SetPVarString(playerid, "pkrStatusString", tmpString);
						}
					} 
					else 
					{
						if(GetPVarInt(playerid, "pkrWinner")) 
						{
							new splitPot = PokerTable[tableid][pkrPot]/PokerTable[tableid][pkrWinners];
							format(tmpString, sizeof(tmpString), "+$%d", splitPot);
							SetPVarString(playerid, "pkrStatusString", tmpString);
						} 
						else 
						{
							format(tmpString, sizeof(tmpString), "-$%d", GetPVarInt(playerid, "pkrCurrentBet"));
							SetPVarString(playerid, "pkrStatusString", tmpString);
						}
					}
				}

				if(PokerTable[tableid][pkrActive] == 4 && PokerTable[tableid][pkrDelay] == 19) 
				{
					if(GetPVarInt(playerid, "pkrActiveHand") && GetPVarInt(playerid, "pkrHide") != 1) 
					{
						new resultString[64];
						GetPVarString(playerid, "pkrResultString", resultString, 64);
						format(tmpString, sizeof(tmpString), "%s", resultString);
						SetPVarString(playerid, "pkrStatusString", resultString);
					}
				}

				if(PokerTable[tableid][pkrActive] == 4 && PokerTable[tableid][pkrDelay] == 10) 
				{
					if(PokerTable[tableid][pkrWinners] == 1) 
					{
						if(GetPVarInt(playerid, "pkrWinner")) 
						{
							format(tmpString, sizeof(tmpString), "+$%d", PokerTable[tableid][pkrPot]);
							SetPVarString(playerid, "pkrStatusString", tmpString);
						} 
						else 
						{
							format(tmpString, sizeof(tmpString), "-$%d", GetPVarInt(playerid, "pkrCurrentBet"));
							SetPVarString(playerid, "pkrStatusString", tmpString);
						}
					} 
					else 
					{
						if(GetPVarInt(playerid, "pkrWinner")) 
						{
							new splitPot = PokerTable[tableid][pkrPot]/PokerTable[tableid][pkrWinners];
							format(tmpString, sizeof(tmpString), "+$%d", splitPot);
							SetPVarString(playerid, "pkrStatusString", tmpString);
						} 
						else 
						{
							format(tmpString, sizeof(tmpString), "-$%d", GetPVarInt(playerid, "pkrCurrentBet"));
							SetPVarString(playerid, "pkrStatusString", tmpString);
						}
					}
				}
				GetPVarString(playerid, "pkrStatusString", tmpString, 128);
			}

			for(new td = 0; td < 6; td++) 
			{
				new pid = PokerTable[tableid][pkrSlot][td];
				if(pid != -1) PlayerTextDrawSetString(pid, PlayerPokerUI[pid][4+tmp], tmpString);
			}

			// Pot
			if(PokerTable[tableid][pkrDelay] > 0 && PokerTable[tableid][pkrActive] == 3) 
			{
				if(playerid != -1) PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][37], "Texas Holdem Poker");
			} 
			else if(PokerTable[tableid][pkrActive] == 2) 
			{
				if(playerid != -1) PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][37], "Texas Holdem Poker");
			} 
			else if(PokerTable[tableid][pkrActive] == 3) 
			{
				format(tmpString, sizeof(tmpString), "Pot: $%d", PokerTable[tableid][pkrPot]);
				if(playerid != -1) PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][37], tmpString);
			} 
			else if(PokerTable[tableid][pkrActive] == 4 && PokerTable[tableid][pkrDelay] < 19) 
			{
				if(PokerTable[tableid][pkrWinnerID] != -1) 
				{
					new winnerName[24];
					GetPlayerName(PokerTable[tableid][pkrWinnerID], winnerName, sizeof(winnerName));
					format(tmpString, sizeof(tmpString), "%s Won $%d", winnerName, PokerTable[tableid][pkrPot]);
					if(playerid != -1) PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][37], tmpString);
				} 
				else if(PokerTable[tableid][pkrWinners] > 1) 
				{
					new splitPot = PokerTable[tableid][pkrPot]/PokerTable[tableid][pkrWinners];
					format(tmpString, sizeof(tmpString), "%d Winners Won $%d", PokerTable[tableid][pkrWinners], splitPot);
					if(playerid != -1) PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][37], tmpString);
				}
			} 
			else 
			{
				if(playerid != -1) PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][37], "Texas Holdem Poker");
			}

			// Bet
			if(PokerTable[tableid][pkrDelay] > 0 && PokerTable[tableid][pkrActive] == 3) 
			{
				format(tmpString, sizeof(tmpString), "Round Begins in ~r~%d~w~...", PokerTable[tableid][pkrDelay]);
				if(playerid != -1) PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][46], tmpString);
			} 
			else if(PokerTable[tableid][pkrActive] == 2) 
			{
				format(tmpString, sizeof(tmpString), "Waiting for players...", PokerTable[tableid][pkrPot]);
				if(playerid != -1) PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][46], tmpString);
			} 
			else if(PokerTable[tableid][pkrActive] == 3) 
			{
				format(tmpString, sizeof(tmpString), "Bet: $%d", PokerTable[tableid][pkrActiveBet]);
				if(playerid != -1) PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][46], tmpString);
			} 
			else if(PokerTable[tableid][pkrActive] == 4) 
			{
				format(tmpString, sizeof(tmpString), "Round Ends in ~r~%d~w~...", PokerTable[tableid][pkrDelay]);
				if(playerid != -1) PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][46], tmpString);
			} 
			else 
			{
				if(playerid != -1) PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][46], "Texas Holdem Poker");
			}

			// Community Cards
			switch(PokerTable[tableid][pkrStage]) 
			{
				case 0: // Opening
				{
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][31], "LD_CARD:cdback");
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][32], "LD_CARD:cdback");
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][33], "LD_CARD:cdback");
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][34], "LD_CARD:cdback");
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][35], "LD_CARD:cdback");
				}
				case 1: // Flop
				{
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][31], DeckTextdrw[PokerTable[tableid][pkrCCards][0]+1]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][32], DeckTextdrw[PokerTable[tableid][pkrCCards][1]+1]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][33], DeckTextdrw[PokerTable[tableid][pkrCCards][2]+1]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][34], "LD_CARD:cdback");
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][35], "LD_CARD:cdback");
				}
				case 2: // Turn
				{
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][31], DeckTextdrw[PokerTable[tableid][pkrCCards][0]+1]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][32], DeckTextdrw[PokerTable[tableid][pkrCCards][1]+1]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][33], DeckTextdrw[PokerTable[tableid][pkrCCards][2]+1]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][34], DeckTextdrw[PokerTable[tableid][pkrCCards][3]+1]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][35], "LD_CARD:cdback");
				}
				case 3: // River
				{
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][31], DeckTextdrw[PokerTable[tableid][pkrCCards][0]+1]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][32], DeckTextdrw[PokerTable[tableid][pkrCCards][1]+1]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][33], DeckTextdrw[PokerTable[tableid][pkrCCards][2]+1]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][34], DeckTextdrw[PokerTable[tableid][pkrCCards][3]+1]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][35], DeckTextdrw[PokerTable[tableid][pkrCCards][4]+1]);
				}
				case 4: // Win
				{
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][31], DeckTextdrw[PokerTable[tableid][pkrCCards][0]+1]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][32], DeckTextdrw[PokerTable[tableid][pkrCCards][1]+1]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][33], DeckTextdrw[PokerTable[tableid][pkrCCards][2]+1]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][34], DeckTextdrw[PokerTable[tableid][pkrCCards][3]+1]);
					PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][35], DeckTextdrw[PokerTable[tableid][pkrCCards][4]+1]);
				}
			}
		} 
		else 
		{
			for(new td = 0; td < 6; td++) 
			{
				new pid = PokerTable[tableid][pkrSlot][td];
				if(pid != -1) 
				{
					PlayerTextDrawSetString(pid, PlayerPokerUI[pid][0+tmp], " ");
					PlayerTextDrawSetString(pid, PlayerPokerUI[pid][1+tmp], " ");
					PlayerTextDrawSetString(pid, PlayerPokerUI[pid][2+tmp], " ");
					PlayerTextDrawSetString(pid, PlayerPokerUI[pid][3+tmp], " ");
					PlayerTextDrawSetString(pid, PlayerPokerUI[pid][4+tmp], " ");
				}
			}
		}
	}
	return 1;
}

CameraRadiusSetPos(playerid, Float:x, Float:y, Float:z, Float:degree = 0.0, Float:height = 3.0, Float:radius = 8.0)
{
	new Float:deltaToX = x + radius * floatsin(-degree, degrees);
	new Float:deltaToY = y + radius * floatcos(-degree, degrees);
	new Float:deltaToZ = z + height;

	SetPlayerCameraPos(playerid, deltaToX, deltaToY, deltaToZ);
	SetPlayerCameraLookAt(playerid, x, y, z);
}

PokerOptions(playerid, option)
{
	switch(option)
	{
		case 0:
		{
			DeletePVar(playerid, "pkrActionOptions");
			PlayerTextDrawHide(playerid, PlayerPokerUI[playerid][38]);
			PlayerTextDrawHide(playerid, PlayerPokerUI[playerid][39]);
			PlayerTextDrawHide(playerid, PlayerPokerUI[playerid][40]);
		}
		case 1: // if(CurrentBet >= ActiveBet)
		{
			SetPVarInt(playerid, "pkrActionOptions", 1);
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][38], "RAISE");
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][39], "CHECK");
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][40], "FOLD");

			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][38]);
			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][39]);
			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][40]);
		}
		case 2: // if(CurrentBet < ActiveBet)
		{
			SetPVarInt(playerid, "pkrActionOptions", 2);
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][38], "CALL");
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][39], "RAISE");
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][40], "FOLD");

			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][38]);
			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][39]);
			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][40]);
		}
		case 3: // if(pkrChips < 1)
		{
			SetPVarInt(playerid, "pkrActionOptions", 3);

			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][38], "CHECK");
			PlayerTextDrawSetString(playerid, PlayerPokerUI[playerid][39], "FOLD");

			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][38]);
			PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][39]);
		}
	}
}

PokerCheckHand(playerid)
{
	if(GetPVarInt(playerid, "pkrActiveHand")) 
		SetPVarString(playerid, "pkrStatusString", "Check");
	// Animation
	ApplyAnimation(playerid, "CASINO", "cards_raise", 4.1, 0, 1, 1, 1, 1, 1);
}

PokerFoldHand(playerid)
{
	if(GetPVarInt(playerid, "pkrActiveHand")) 
	{
		DeletePVar(playerid, "pkrCard1");
		DeletePVar(playerid, "pkrCard2");
		DeletePVar(playerid, "pkrActiveHand");
		DeletePVar(playerid, "pkrStatus");

		PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrActiveHands]--;

		SetPVarString(playerid, "pkrStatusString", "Fold");

		// SFX
		GlobalPlaySound(5602, PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrX], PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrY], PokerTable[GetPVarInt(playerid, "pkrTableID")-1][pkrZ]);

		// Animation
		ApplyAnimation(playerid, "CASINO", "cards_out", 4.1, 0, 1, 1, 1, 1, 1);
	}
}

PokerDealHands(tableid)
{
	new tmp = 0;
	// Loop through active players.
	for(new i = 0; i < 6; i++) 
	{
		new playerid = PokerTable[tableid][pkrSlot][i];
		if(playerid != -1 && GetPVarInt(playerid, "pkrStatus") && GetPVarInt(playerid, "pkrChips") > 0) 
		{
			SetPVarInt(playerid, "pkrCard1", PokerTable[tableid][pkrDeck][tmp]);
			SetPVarInt(playerid, "pkrCard2", PokerTable[tableid][pkrDeck][tmp+1]);

			SetPVarInt(playerid, "pkrActiveHand", 1);

			PokerTable[tableid][pkrActiveHands]++;

			// SFX
			PlayerPlaySound(playerid, 5602, 0.0, 0.0, 0.0);

			// Animation
			ApplyAnimation(playerid, "CASINO", "cards_in", 4.1, 0, 1, 1, 1, 1, 1);

			tmp += 2;
		}
	}

	// Loop through community cards.
	for(new i = 0; i < 5; i++) {

		PokerTable[tableid][pkrCCards][i] = PokerTable[tableid][pkrDeck][tmp];
		tmp++;
	}
}

PokerShuffleDeck(tableid)
{
	// SFX
	GlobalPlaySound(5600, PokerTable[tableid][pkrX], PokerTable[tableid][pkrY], PokerTable[tableid][pkrZ]);

	// Order the deck
	for(new i = 0; i < 52; i++)
		PokerTable[tableid][pkrDeck][i] = i;

	// Randomize the array (AKA Shuffle Algorithm)
	new rand, tmp, i;
	for(i = 52; i > 1; i--) 
	{
		rand = random(52) % i;
		tmp = PokerTable[tableid][pkrDeck][rand];
		PokerTable[tableid][pkrDeck][rand] = PokerTable[tableid][pkrDeck][i-1];
		PokerTable[tableid][pkrDeck][i-1] = tmp;
	}
}

PokerFindPlayerOrder(tableid, index)
{
	new tmpIndex = -1;
	for(new i = 0; i < 6; i++) 
	{
		new playerid = PokerTable[tableid][pkrSlot][i];
		if(playerid != -1 && ++tmpIndex == index) 
		{
			if(GetPVarInt(playerid, "pkrStatus") == 1)
				return playerid;
		}
	}
	return -1;
}

PokerAssignBlinds(tableid)
{
	if(PokerTable[tableid][pkrPos] == 6)
		PokerTable[tableid][pkrPos] = 0;

	// Find where to start & distubute blinds.
	new bool:roomDealer = false, bool:roomBigBlind = false, bool:roomSmallBlind = false;

	// Find the Dealer.
	new tmpPos = PokerTable[tableid][pkrPos];
	while(roomDealer == false) 
	{
		if(tmpPos == 6)	tmpPos = 0;

		new playerid = PokerFindPlayerOrder(tableid, tmpPos);
		if(playerid != -1) 
		{
			SetPVarInt(playerid, "pkrRoomDealer", 1);
			SetPVarString(playerid, "pkrStatusString", "Dealer");
			roomDealer = true;
		} 
		else tmpPos++;
	}

	// Find the player after the Dealer.
	tmpPos = PokerTable[tableid][pkrPos];
	while(roomBigBlind == false) 
	{
		if(tmpPos == 6)	tmpPos = 0;

		new playerid = PokerFindPlayerOrder(tableid, tmpPos);
		if(playerid != -1) 
		{
			if(GetPVarInt(playerid, "pkrRoomDealer") != 1 && GetPVarInt(playerid, "pkrRoomBigBlind") != 1 && GetPVarInt(playerid, "pkrRoomSmallBlind") != 1) 
			{
				SetPVarInt(playerid, "pkrRoomBigBlind", 1);
				new tmpString[128];
				format(tmpString, sizeof(tmpString), "~r~BB -$%d", PokerTable[tableid][pkrBlind]);
				SetPVarString(playerid, "pkrStatusString", tmpString);
				roomBigBlind = true;

				if(GetPVarInt(playerid, "pkrChips") < PokerTable[tableid][pkrBlind]) 
				{
					PokerTable[tableid][pkrPot] += GetPVarInt(playerid, "pkrChips");
					SetPVarInt(playerid, "pkrChips", 0);
				} 
				else 
				{
					PokerTable[tableid][pkrPot] += PokerTable[tableid][pkrBlind];
					SetPVarInt(playerid, "pkrChips", GetPVarInt(playerid, "pkrChips")-PokerTable[tableid][pkrBlind]);
				}

				SetPVarInt(playerid, "pkrCurrentBet", PokerTable[tableid][pkrBlind]);
				PokerTable[tableid][pkrActiveBet] = PokerTable[tableid][pkrBlind];

			} 
			else tmpPos++;
		} 
		else tmpPos++;
	}

	// Small Blinds are active only if there are more than 2 players.
	if(PokerTable[tableid][pkrActivePlayers] > 2) 
	{	// Find the player after the Big Blind.
		tmpPos = PokerTable[tableid][pkrPos];
		while(roomSmallBlind == false) 
		{
			if(tmpPos == 6)	tmpPos = 0;

			new playerid = PokerFindPlayerOrder(tableid, tmpPos);
			if(playerid != -1) 
			{
				if(GetPVarInt(playerid, "pkrRoomDealer") != 1 && GetPVarInt(playerid, "pkrRoomBigBlind") != 1 && GetPVarInt(playerid, "pkrRoomSmallBlind") != 1) 
				{
					SetPVarInt(playerid, "pkrRoomSmallBlind", 1);
					new tmpString[128];
					format(tmpString, sizeof(tmpString), "~r~SB -$%d", PokerTable[tableid][pkrBlind]/2);
					SetPVarString(playerid, "pkrStatusString", tmpString);
					roomSmallBlind = true;

					if(GetPVarInt(playerid, "pkrChips") < (PokerTable[tableid][pkrBlind]/2)) 
					{
						PokerTable[tableid][pkrPot] += GetPVarInt(playerid, "pkrChips");
						SetPVarInt(playerid, "pkrChips", 0);
					} 
					else 
					{
						PokerTable[tableid][pkrPot] += (PokerTable[tableid][pkrBlind]/2);
						SetPVarInt(playerid, "pkrChips", GetPVarInt(playerid, "pkrChips")-(PokerTable[tableid][pkrBlind]/2));
					}

					SetPVarInt(playerid, "pkrCurrentBet", PokerTable[tableid][pkrBlind]/2);
					PokerTable[tableid][pkrActiveBet] = PokerTable[tableid][pkrBlind]/2;
				} 
				else tmpPos++;
			} 
			else tmpPos++;
		}
	}
	PokerTable[tableid][pkrPos]++;
}

PokerRotateActivePlayer(tableid)
{
	new nextactiveid = -1, lastapid = -1, lastapslot = -1;
	if(PokerTable[tableid][pkrActivePlayerID] != -1) 
	{
		lastapid = PokerTable[tableid][pkrActivePlayerID];
		for(new i = 0; i < 6; i++) 
		{
			if(PokerTable[tableid][pkrSlot][i] == lastapid)
				lastapslot = i;
		}
		DeletePVar(lastapid, "pkrActivePlayer");
		DeletePVar(lastapid, "pkrTime");

		PokerOptions(lastapid, 0);
	}

	// New Round Init Block
	if(PokerTable[tableid][pkrRotations] == 0 && lastapid == -1 && lastapslot == -1) 
	{	// Find & Assign ActivePlayer to Dealer
		for(new i = 0; i < 6; i++) 
		{
			new playerid = PokerTable[tableid][pkrSlot][i];
			if(GetPVarInt(playerid, "pkrRoomDealer") == 1) 
			{
				nextactiveid = playerid;
				PokerTable[tableid][pkrActivePlayerID] = playerid;
				PokerTable[tableid][pkrActivePlayerSlot] = i;
				PokerTable[tableid][pkrRotations]++;
				PokerTable[tableid][pkrSlotRotations] = i;
			}
		}
	}
	else if(PokerTable[tableid][pkrRotations] >= 6)
	{
		PokerTable[tableid][pkrRotations] = 0;
		PokerTable[tableid][pkrStage]++;

		if(PokerTable[tableid][pkrStage] > 3) 
		{
			PokerTable[tableid][pkrActive] = 4;
			PokerTable[tableid][pkrDelay] = 20+1;
			return 1;
		}

		PokerTable[tableid][pkrSlotRotations]++;
		if(PokerTable[tableid][pkrSlotRotations] >= 6) 
			PokerTable[tableid][pkrSlotRotations] -= 6;

		new playerid = PokerFindPlayerOrder(tableid, PokerTable[tableid][pkrSlotRotations]);

		if(playerid != -1) 
		{
			nextactiveid = playerid;
			PokerTable[tableid][pkrActivePlayerID] = playerid;
			PokerTable[tableid][pkrActivePlayerSlot] = PokerTable[tableid][pkrSlotRotations];
			PokerTable[tableid][pkrRotations]++;
		} 
		else 
		{
			PokerTable[tableid][pkrRotations]++;
			PokerRotateActivePlayer(tableid);
		}
	}
	else
	{
		if(++PokerTable[tableid][pkrSlotRotations] >= 6)
			PokerTable[tableid][pkrSlotRotations] -= 6;

		new playerid = PokerFindPlayerOrder(tableid, PokerTable[tableid][pkrSlotRotations]);
		if(playerid != -1) 
		{
			nextactiveid = playerid;
			PokerTable[tableid][pkrActivePlayerID] = playerid;
			PokerTable[tableid][pkrActivePlayerSlot] = PokerTable[tableid][pkrSlotRotations];
			PokerTable[tableid][pkrRotations]++;
		} 
		else 
		{
			PokerTable[tableid][pkrRotations]++;
			PokerRotateActivePlayer(tableid);
		}
	}

	if(nextactiveid != -1) 
	{
		if(GetPVarInt(nextactiveid, "pkrActiveHand")) 
		{
			new currentBet = GetPVarInt(nextactiveid, "pkrCurrentBet");
			new activeBet = PokerTable[tableid][pkrActiveBet];

			new apSoundID[] = {5809, 5810};
			new randomApSoundID = random(sizeof(apSoundID));
			PlayerPlaySound(nextactiveid, apSoundID[randomApSoundID], 0.0, 0.0, 0.0);

			if(GetPVarInt(nextactiveid, "pkrChips") < 1) 	PokerOptions(nextactiveid, 3);
			else if(currentBet >= activeBet) 				PokerOptions(nextactiveid, 1);
			else if (currentBet < activeBet) 				PokerOptions(nextactiveid, 2);
			else 											PokerOptions(nextactiveid, 0);

			SetPVarInt(nextactiveid, "pkrTime", 60);
			SetPVarInt(nextactiveid, "pkrActivePlayer", 1);
		}
	}
	return 1;
}

OnCasinoInit()
{
	InitChipMachines();
	InitPokerTables();
}

InitChipMachines()
{
	for(new i = 0; i < MAX_CHIPMACHINES; i++) 
	{
		ChipMachine[i][cmPlaced] = 0;
		ChipMachine[i][cmObjectID] = 0;
		ChipMachine[i][cmX] = 0.0;
		ChipMachine[i][cmY] = 0.0;
		ChipMachine[i][cmZ] = 0.0;
		ChipMachine[i][cmRX] = 0.0;
		ChipMachine[i][cmRY] = 0.0;
		ChipMachine[i][cmRZ] = 0.0;
		ChipMachine[i][cmInt] = 0;
		ChipMachine[i][cmVW] = 0;
	}
	state DataType: Chipmachines;
	LoadData();
}

LoadData() <DataType: Chipmachines>
{
	new string[512];
	new File: file = fopen(GM_FOLDER"chipmachines.ini", io_read);
	if(file)
	{
		new idx;
		while(fread(file, string))
		{
			sscanf(string, "p<,>ffffffdd", 
				ChipMachine[idx][cmX],
				ChipMachine[idx][cmY],
				ChipMachine[idx][cmZ],
				ChipMachine[idx][cmRX],
				ChipMachine[idx][cmRY],
				ChipMachine[idx][cmRZ],
				ChipMachine[idx][cmVW],
				ChipMachine[idx][cmInt]);
			PlaceChipMachine(idx, ChipMachine[idx][cmX], ChipMachine[idx][cmY], ChipMachine[idx][cmZ], ChipMachine[idx][cmRX], ChipMachine[idx][cmRY], ChipMachine[idx][cmRZ], ChipMachine[idx][cmVW], ChipMachine[idx][cmInt]);
			if(++idx >= sizeof(ChipMachine))	break;
		}
		fclose(file);
	}
	return true;
}

PlaceChipMachine(machineid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, virtualworld, interior)
{
	ChipMachine[machineid][cmPlaced] = 1;
	ChipMachine[machineid][cmX] = x;
	ChipMachine[machineid][cmY] = y;
	ChipMachine[machineid][cmZ] = z;
	ChipMachine[machineid][cmRX] = rx;
	ChipMachine[machineid][cmRY] = ry;
	ChipMachine[machineid][cmRZ] = rz;
	ChipMachine[machineid][cmVW] = virtualworld;
	ChipMachine[machineid][cmInt] = interior;
	
	ChipMachine[machineid][cmObjectID] = CreateDynamicObject(OBJ_CHIP_MACHINE, x, y, z, rx, ry, rz, virtualworld, interior);
	ChipMachine[machineid][cmText3DID] = CreateDynamic3DTextLabel("Покупка фишек\nНажмите ALT", COLOR_3DTEXT, x, y, z + 1.1, DRAWDISTANCE_CHIP_MACHINE_MISC, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true, virtualworld, interior);
	return machineid;
}

InitPokerTables()
{
	for(new i = 0; i < MAX_POKERTABLES; i++) 
	{
		PokerTable[i][pkrActive] = 0;
		PokerTable[i][pkrPlaced] = 0;
		PokerTable[i][pkrObjectID] = 0;

		for(new c = 0; c < MAX_POKERTABLEMISCOBJS; c++)
			PokerTable[i][pkrMiscObjectID][c] = 0;

		for(new s = 0; s < 6; s++)
			PokerTable[i][pkrSlot][s] = -1;

		PokerTable[i][pkrX] = 0.0;
		PokerTable[i][pkrY] = 0.0;
		PokerTable[i][pkrZ] = 0.0;
		PokerTable[i][pkrRX] = 0.0;
		PokerTable[i][pkrRY] = 0.0;
		PokerTable[i][pkrRZ] = 0.0;
		PokerTable[i][pkrVW] = 0;
		PokerTable[i][pkrInt] = 0;
		PokerTable[i][pkrPlayers] = 0;
		PokerTable[i][pkrLimit] = 6;
		PokerTable[i][pkrBuyInMax] = 1000;
		PokerTable[i][pkrBuyInMin] = 500;
		PokerTable[i][pkrBlind] = 100;
		PokerTable[i][pkrPos] = 0;
		PokerTable[i][pkrRound] = 0;
		PokerTable[i][pkrStage] = 0;
		PokerTable[i][pkrActiveBet] = 0;
		PokerTable[i][pkrSetDelay] = 15;
		PokerTable[i][pkrActivePlayerID] = -1;
		PokerTable[i][pkrActivePlayerSlot] = -1;
		PokerTable[i][pkrRotations] = 0;
		PokerTable[i][pkrSlotRotations] = 0;
		PokerTable[i][pkrWinnerID] = -1;
		PokerTable[i][pkrWinners] = 0;
	}
	state DataType: PokerTables;
	LoadData();
}

LoadData() <DataType: PokerTables>
{
	
	new File: file = fopen(GM_FOLDER"pokertables.ini", io_read);
	if(file)
	{
		new string[256], idx;
		while(fread(file, string))
		{
			sscanf(string, "p<,>ffffffdd", 
				PokerTable[idx][pkrX],
				PokerTable[idx][pkrY],
				PokerTable[idx][pkrZ],
				PokerTable[idx][pkrRX],
				PokerTable[idx][pkrRY],
				PokerTable[idx][pkrRZ],
				PokerTable[idx][pkrVW],
				PokerTable[idx][pkrInt]);
			PlacePokerTable(idx,
				PokerTable[idx][pkrX],
				PokerTable[idx][pkrY],
				PokerTable[idx][pkrZ],
				PokerTable[idx][pkrRX],
				PokerTable[idx][pkrRY],
				PokerTable[idx][pkrRZ],
				PokerTable[idx][pkrVW],
				PokerTable[idx][pkrInt]
			);
			if(++idx >= sizeof(PokerTable))	break;
		}
		fclose(file);
	}
	return true;
}

ResetPokerRound(tableid)
{
	PokerTable[tableid][pkrRound] = 0;
	PokerTable[tableid][pkrStage] = 0;
	PokerTable[tableid][pkrActiveBet] = 0;
	PokerTable[tableid][pkrActive] = 2;
	PokerTable[tableid][pkrDelay] = PokerTable[tableid][pkrSetDelay];
	PokerTable[tableid][pkrPot] = 0;
	PokerTable[tableid][pkrRotations] = 0;
	PokerTable[tableid][pkrSlotRotations] = 0;
	PokerTable[tableid][pkrWinnerID] = -1;
	PokerTable[tableid][pkrWinners] = 0;

	// Reset Player Variables
	for(new i = 0; i < 6; i++) 
	{
		new playerid = PokerTable[tableid][pkrSlot][i];
		if(playerid != -1) 
		{
			DeletePVar(playerid, "pkrWinner");
			DeletePVar(playerid, "pkrRoomBigBlind");
			DeletePVar(playerid, "pkrRoomSmallBlind");
			DeletePVar(playerid, "pkrRoomDealer");
			DeletePVar(playerid, "pkrCard1");
			DeletePVar(playerid, "pkrCard2");
			DeletePVar(playerid, "pkrActivePlayer");
			DeletePVar(playerid, "pkrTime");

			if(GetPVarInt(playerid, "pkrActiveHand")) 
			{
				PokerTable[tableid][pkrActiveHands]--;

				// Animation
				ApplyAnimation(playerid, "CASINO", "cards_out", 4.1, 0, 1, 1, 1, 1, 1);
			}

			DeletePVar(playerid, "pkrActiveHand");
			DeletePVar(playerid, "pkrCurrentBet");
			DeletePVar(playerid, "pkrResultString");
			DeletePVar(playerid, "pkrHide");
		}
	}
	return 1;
}

ResetPokerTable(tableid)
{
	new szString[32];
	format(szString, sizeof(szString), "");
	strmid(PokerTable[tableid][pkrPass], szString, 0, strlen(szString), 64);

	PokerTable[tableid][pkrActive] = 0;
	PokerTable[tableid][pkrLimit] = 6;
	PokerTable[tableid][pkrBuyInMax] = 1000;
	PokerTable[tableid][pkrBuyInMin] = 500;
	PokerTable[tableid][pkrBlind] = 100;
	PokerTable[tableid][pkrPos] = 0;
	PokerTable[tableid][pkrRound] = 0;
	PokerTable[tableid][pkrStage] = 0;
	PokerTable[tableid][pkrActiveBet] = 0;
	PokerTable[tableid][pkrDelay] = 0;
	PokerTable[tableid][pkrPot] = 0;
	PokerTable[tableid][pkrSetDelay] = 15;
	PokerTable[tableid][pkrRotations] = 0;
	PokerTable[tableid][pkrSlotRotations] = 0;
	PokerTable[tableid][pkrWinnerID] = -1;
	PokerTable[tableid][pkrWinners] = 0;
}

ShowPokerGUI(playerid, guitype)
{
	switch(guitype)
	{
		case GUI_POKER_TABLE:
		{
			SetPVarInt(playerid, "pkrTableGUI", 1);
			for(new i = 0; i < MAX_PLAYERPOKERUI; i++)
				PlayerTextDrawShow(playerid, PlayerPokerUI[playerid][i]);
		}
	}
}

DestroyPokerGUI(playerid)
{
	for(new i = 0; i < MAX_PLAYERPOKERUI; i++) {
		PlayerTextDrawDestroy(playerid, PlayerPokerUI[playerid][i]);
	}
}

PlacePokerTable(tableid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, virtualworld, interior)
{
	PokerTable[tableid][pkrPlaced] = 1;
	PokerTable[tableid][pkrX] = x;
	PokerTable[tableid][pkrY] = y;
	PokerTable[tableid][pkrZ] = z;
	PokerTable[tableid][pkrRX] = rx;
	PokerTable[tableid][pkrRY] = ry;
	PokerTable[tableid][pkrRZ] = rz;
	PokerTable[tableid][pkrVW] = virtualworld;
	PokerTable[tableid][pkrInt] = interior;

	// Create Table
	PokerTable[tableid][pkrObjectID] = CreateDynamicObject(OBJ_POKER_TABLE, x, y, z, rx, ry, rz, virtualworld, interior);

	// Create 3D Text Label
	PokerTable[tableid][pkrText3DID] = CreateDynamic3DTextLabel("Стол для покера\nДля начала игры нажмите ALT", COLOR_3DTEXT, x, y, z + 1.3, DRAWDISTANCE_POKER_MISC, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, true, virtualworld, interior);
	return tableid;
}

JoinPokerTable(playerid, tableid)
{
	// Check if there is room for the player
	if(PokerTable[tableid][pkrPlayers] < PokerTable[tableid][pkrLimit])
	{
		// Check if table is not joinable.
		if(PokerTable[tableid][pkrActive] == 1) 
		{
			return SendClientMessage(playerid, COLOR_GREY, "Ошибка: Кто-то уже настраивает стол для начала игры");
		}

		// Find an open seat
		for(new s; s < 6; s++) 
		{
			if(PokerTable[tableid][pkrSlot][s] == -1) 
			{
				SetPVarInt(playerid, "pkrTableID", tableid + 1);
				SetPVarInt(playerid, "pkrSlot", s);

				// Occuply Slot
				PokerTable[tableid][pkrPlayers] += 1;
				PokerTable[tableid][pkrSlot][s] = playerid;

				// Check & Start Game Loop if Not Active
				if(PokerTable[tableid][pkrPlayers] == 1) 
				{
					// Player is Room Creator
					SetPVarInt(playerid, "pkrRoomLeader", 1);
					ShowDialog(playerid, DPOKER_GAMESETUP);

					PokerTable[tableid][pkrActive] = 1; // Warmup Phase
					PokerTable[tableid][pkrPulseTimer] = SetTimerEx("PokerPulse", 1000, true, "i", tableid);

					UpdateDynamic3DTextLabelText(PokerTable[tableid][pkrText3DID], COLOR_3DTEXT, " ");
				} 
				else 
				{ 	// Execute code for Non-Room Creators
					ShowDialog(playerid, DPOKER_GAMESBUY);
					SelectTextDraw(playerid, COLOR_GOLD);
				}

				CameraRadiusSetPos(playerid, PokerTable[tableid][pkrX], PokerTable[tableid][pkrY], PokerTable[tableid][pkrZ], 90.0, 4.7, 0.1);

				new Float:pos[3];
				MyGetPlayerPos(playerid, Arr3<pos>);

				SetPVarFloat(playerid, "pkrTableJoinX", pos[0]);
				SetPVarFloat(playerid, "pkrTableJoinY", pos[1]);
				SetPVarFloat(playerid, "pkrTableJoinZ", pos[2]);

				ApplyAnimation(playerid, "CASINO", "cards_out", 4.1, 0, 1, 1, 1, 1, 1);
				TogglePlayerControllable(playerid, false);
				SetPlayerPosObjectOffset(PokerTable[tableid][pkrObjectID], playerid, Arr3<PokerTableMiscObjOffsets[s]>);
				SetPlayerFacingAngle(playerid, PokerTableMiscObjOffsets[s][5] + 90.0);
				ApplyAnimation(playerid, "CASINO", "cards_out", 4.1, 0, 1, 1, 1, 1, 1);

				// Create GUI
				CreatePokerGUI(playerid);
				ShowPokerGUI(playerid, GUI_POKER_TABLE);

				// Hide Action Bar
				PokerOptions(playerid, 0);
				return true;
			}
		}
	}
	return true;
}

LeavePokerTable(playerid)
{
	new tableid = GetPVarInt(playerid, "pkrTableID")-1;

	// SFX
	new leaveSoundID[2] = {5852, 5853};
	new randomLeaveSoundID = random(sizeof(leaveSoundID));
	PlayerPlaySound(playerid, leaveSoundID[randomLeaveSoundID], 0.0, 0.0, 0.0);

	// Convert prkChips to cgChips
	inv_addThing(playerid, THING_CHIPS, GetPVarInt(playerid, "pkrChips"));

	// De-occuply Slot
	PokerTable[tableid][pkrPlayers] -= 1;
	if(GetPVarInt(playerid, "pkrStatus")) PokerTable[tableid][pkrActivePlayers] -= 1;
	PokerTable[tableid][pkrSlot][GetPVarInt(playerid, "pkrSlot")] = -1;

	// Check & Stop the Game Loop if No Players at the Table
	if(PokerTable[tableid][pkrPlayers] == 0) 
	{
		KillTimer(PokerTable[tableid][pkrPulseTimer]);
		UpdateDynamic3DTextLabelText(PokerTable[tableid][pkrText3DID], COLOR_3DTEXT, "Стол для покера\nДля начала игры нажмите ALT");
		ResetPokerTable(tableid);
	}

	if(PokerTable[tableid][pkrRound] == 0 && PokerTable[tableid][pkrDelay] < 5) 
	{
		ResetPokerRound(tableid);
	}

	SetPlayerPos(playerid, GetPVarFloat(playerid, "pkrTableJoinX"), GetPVarFloat(playerid, "pkrTableJoinY"), GetPVarFloat(playerid, "pkrTableJoinZ")+0.1);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, 1);
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 2.0, 0, 0, 0, 0, 0);
	CancelSelectTextDraw(playerid);

	if(GetPVarInt(playerid, "pkrActiveHand"))	PokerTable[tableid][pkrActiveHands]--;

	// Destroy Poker Memory
	DeletePVar(playerid, "pkrWinner");
	DeletePVar(playerid, "pkrCurrentBet");
	DeletePVar(playerid, "pkrChips");
	DeletePVar(playerid, "pkrTableJoinX");
	DeletePVar(playerid, "pkrTableJoinY");
	DeletePVar(playerid, "pkrTableJoinZ");
	DeletePVar(playerid, "pkrTableID");
	DeletePVar(playerid, "pkrSlot");
	DeletePVar(playerid, "pkrStatus");
	DeletePVar(playerid, "pkrRoomLeader");
	DeletePVar(playerid, "pkrRoomBigBlind");
	DeletePVar(playerid, "pkrRoomSmallBlind");
	DeletePVar(playerid, "pkrRoomDealer");
	DeletePVar(playerid, "pkrCard1");
	DeletePVar(playerid, "pkrCard2");
	DeletePVar(playerid, "pkrActivePlayer");
	DeletePVar(playerid, "pkrActiveHand");
	DeletePVar(playerid, "pkrHide");

	// Destroy GUI
	DestroyPokerGUI(playerid);

	// Delay Exit Call
	SetTimerEx("PokerExit", 250, false, "d", playerid);
	return 1;
}


//---	Chips
GetChipAmount(playerid)		return inv_getThing(playerid, THING_CHIPS);

BuyChips(playerid, amount)
{
	if(MyGetPlayerMoney(playerid) >= amount && inv_addThing(playerid, THING_CHIPS, amount)) 
	{
		MyGivePlayerMoney(playerid, -amount);
		return true;
	}
	return false;
}

SellChips(playerid, amount)
{
	if(GetChipAmount(playerid) >= amount) 
	{
		DeleteThing(playerid, THING_CHIPS, amount);
		MyGivePlayerMoney(playerid, amount);
		return true;
	}
	return false;
}

/*CMD:debugseat(playerid, params[]) // DEBUG ONLY
{
	for(new t = 0; t < MAX_POKERTABLES; t++) {
		if(IsPlayerInRangeOfPoint(playerid, 5.0, PokerTable[t][pkrX], PokerTable[t][pkrY], PokerTable[t][pkrZ])) {
			new s = strval(params);

			if(s < 6 && s >= 0) {
				SetPlayerPosObjectOffset(PokerTable[t][pkrObjectID], playerid, PokerTableMiscObjOffsets[s][0], PokerTableMiscObjOffsets[s][1], PokerTableMiscObjOffsets[s][2]);
				SetPlayerFacingAngle(playerid, PokerTableMiscObjOffsets[s][5]+90.0);
			}
		}
	}
	return 1;
}

CMD:debugcamera(playerid, params[]) // DEBUG ONLY
{
	for(new t = 0; t < MAX_POKERTABLES; t++) {
		if(IsPlayerInRangeOfPoint(playerid, 5.0, PokerTable[t][pkrX], PokerTable[t][pkrY], PokerTable[t][pkrZ])) {
			CameraRadiusSetPos(playerid, PokerTable[t][pkrX], PokerTable[t][pkrY], PokerTable[t][pkrZ], 90.0, 4.7, 0.1);
		}
	}
	return 1;
}

CMD:leavedebugcamera(playerid, params[]) // DEBUG ONLY
{
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, 1);
	ClearAnimations(playerid, 1);
	return 1;
}

CMD:debugtextsize(playerid, params[])
{
	switch(strval(params))
	{
		case 0:
		{
			PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][37], 0.199999, 1.200000);
		}
		case 1:
		{
			PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][37], 0.189999, 1.100000);
		}
		case 2:
		{
			PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][37], 0.179999, 1.000000);
		}
		case 3:
		{
			PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][37], 0.169999, 0.90000);
		}
		case 4:
		{
			PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][37], 0.159999, 0.800000);
		}
		case 5:
		{
			PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][37], 0.149999, 0.700000);
		}
	}
	return 1;
}*/

CMD:jointable(playerid, params[])
{
	if(GetPVarType(playerid, "pkrTableID") == 0) 
	{
		for(new t = 0; t < MAX_POKERTABLES; t++) 
		{
			if(IsPlayerInRangeOfPoint(playerid, 5.0, PokerTable[t][pkrX], PokerTable[t][pkrY], PokerTable[t][pkrZ])) 
			{
				if(PokerTable[t][pkrPass][0] != EOS) 
				{
					if(!strcmp(params, PokerTable[t][pkrPass], false, 32)) 
					{
						JoinPokerTable(playerid, t);
					} 
					else 
					{
						return SendClientMessage(playerid, COLOR_WHITE, "Usage: /jointable (password)");
					}
				} 
				else 
				{
					JoinPokerTable(playerid, t);
				}
				return 1;
			}
		}
	} 
	else 
	{
		SendClientMessage(playerid, COLOR_WHITE, "You are already at a Poker Table! You must /leavetable before you join another one!");
	}
	return 1;
}

CMD:leavetable(playerid, params[])
{
	if(GetPVarType(playerid, "pkrTableID")) {
		LeavePokerTable(playerid);
	}
	return 1;
}

CreatePokerGUI(playerid)
{
	PlayerPokerUI[playerid][0] = CreatePlayerTextDraw(playerid, 390.000000, 263.000000, " "); // Seat 2 (SEAT 1)
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][0], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][0], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][0], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][0], 0.159998, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][0], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][0], 0);

	PlayerPokerUI[playerid][1] = CreatePlayerTextDraw(playerid, 389.000000, 273.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][1], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][1], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][1], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][1], 0.159998, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][1], 16711935);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][1], 0);

	PlayerPokerUI[playerid][2] = CreatePlayerTextDraw(playerid, 369.000000, 286.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][2], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][2], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][2], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][2], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][2], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][2], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][2], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][2], 20.000000, 33.000000);

	PlayerPokerUI[playerid][3] = CreatePlayerTextDraw(playerid, 392.000000, 286.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][3], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][3], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][3], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][3], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][3], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][3], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][3], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][3], 20.000000, 33.000000);

	PlayerPokerUI[playerid][4] = CreatePlayerTextDraw(playerid, 391.000000, 319.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][4], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][4], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][4], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][4], 0.180000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][4], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][4], 0);

	PlayerPokerUI[playerid][5] = CreatePlayerTextDraw(playerid, 250.000000, 263.000000, " "); // Seat 1 (SEAT 2)
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][5], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][5], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][5], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][5], 0.159999, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][5], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][5], 0);

	PlayerPokerUI[playerid][6] = CreatePlayerTextDraw(playerid, 250.000000, 273.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][6], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][6], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][6], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][6], 0.159999, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][6], 16711935);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][6], 0);

	PlayerPokerUI[playerid][7] = CreatePlayerTextDraw(playerid, 229.000000, 286.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][7], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][7], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][7], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][7], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][7], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][7], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][7], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][7], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][7], 20.000000, 33.000000);

	PlayerPokerUI[playerid][8] = CreatePlayerTextDraw(playerid, 252.000000, 286.000000, " ");
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][8], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][8], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][8], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][8], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][8], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][8], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][8], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][8], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][8], 20.000000, 33.000000);

	PlayerPokerUI[playerid][9] = CreatePlayerTextDraw(playerid, 250.000000, 319.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][9], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][9], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][9], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][9], 0.180000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][9], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][9], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][9], 0);

	PlayerPokerUI[playerid][10] = CreatePlayerTextDraw(playerid, 199.000000, 190.000000, " "); // Seat 6 (SEAT 3)
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][10], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][10], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][10], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][10], 0.159998, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][10], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][10], 0);

	PlayerPokerUI[playerid][11] = CreatePlayerTextDraw(playerid, 199.000000, 199.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][11], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][11], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][11], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][11], 0.159998, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][11], 16711935);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][11], 0);

	PlayerPokerUI[playerid][12] = CreatePlayerTextDraw(playerid, 179.000000, 212.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][12], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][12], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][12], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][12], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][12], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][12], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][12], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][12], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][12], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][12], 20.000000, 33.000000);

	PlayerPokerUI[playerid][13] = CreatePlayerTextDraw(playerid, 202.000000, 212.000000, " ");
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][13], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][13], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][13], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][13], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][13], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][13], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][13], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][13], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][13], 20.000000, 33.000000);

	PlayerPokerUI[playerid][14] = CreatePlayerTextDraw(playerid, 200.000000, 245.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][14], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][14], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][14], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][14], 0.180000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][14], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][14], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][14], 0);

	PlayerPokerUI[playerid][15] = CreatePlayerTextDraw(playerid, 250.000000, 116.000000, " ");  // Seat 5 (SEAT 4)
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][15], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][15], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][15], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][15], 0.159998, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][15], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][15], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][15], 0);

	PlayerPokerUI[playerid][16] = CreatePlayerTextDraw(playerid, 250.000000, 126.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][16], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][16], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][16], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][16], 0.159998, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][16], 16711935);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][16], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][16], 0);

	PlayerPokerUI[playerid][17] = CreatePlayerTextDraw(playerid, 229.000000, 139.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][17], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][17], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][17], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][17], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][17], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][17], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][17], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][17], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][17], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][17], 20.000000, 33.000000);

	PlayerPokerUI[playerid][18] = CreatePlayerTextDraw(playerid, 252.000000, 139.000000, " ");
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][18], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][18], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][18], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][18], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][18], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][18], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][18], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][18], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][18], 20.000000, 33.000000);

	PlayerPokerUI[playerid][19] = CreatePlayerTextDraw(playerid, 250.000000, 172.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][19], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][19], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][19], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][19], 0.180000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][19], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][19], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][19], 0);

	PlayerPokerUI[playerid][20] = CreatePlayerTextDraw(playerid, 390.000000, 116.000000, " "); // Seat 4 (SEAT 5)
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][20], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][20], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][20], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][20], 0.159997, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][20], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][20], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][20], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][20], 0);

	PlayerPokerUI[playerid][21] = CreatePlayerTextDraw(playerid, 389.000000, 126.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][21], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][21], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][21], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][21], 0.159997, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][21], 16711935);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][21], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][21], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][21], 0);

	PlayerPokerUI[playerid][22] = CreatePlayerTextDraw(playerid, 369.000000, 139.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][22], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][22], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][22], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][22], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][22], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][22], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][22], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][22], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][22], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][22], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][22], 20.000000, 33.000000);

	PlayerPokerUI[playerid][23] = CreatePlayerTextDraw(playerid, 392.000000, 139.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][23], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][23], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][23], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][23], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][23], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][23], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][23], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][23], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][23], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][23], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][23], 20.000000, 33.000000);

	PlayerPokerUI[playerid][24] = CreatePlayerTextDraw(playerid, 391.000000, 172.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][24], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][24], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][24], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][24], 0.180000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][24], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][24], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][24], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][24], 0);

	PlayerPokerUI[playerid][25] = CreatePlayerTextDraw(playerid, 443.000000, 190.000000, " "); // Seat 3 (SEAT 6)
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][25], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][25], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][25], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][25], 0.159998, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][25], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][25], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][25], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][25], 0);

	PlayerPokerUI[playerid][26] = CreatePlayerTextDraw(playerid, 442.000000, 199.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][26], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][26], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][26], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][26], 0.159998, 1.200001);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][26], 16711935);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][26], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][26], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][26], 0);

	PlayerPokerUI[playerid][27] = CreatePlayerTextDraw(playerid, 422.000000, 212.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][27], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][27], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][27], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][27], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][27], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][27], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][27], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][27], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][27], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][27], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][27], 20.000000, 33.000000);

	PlayerPokerUI[playerid][28] = CreatePlayerTextDraw(playerid, 445.000000, 212.000000, " ");
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][28], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][28], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][28], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][28], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][28], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][28], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][28], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][28], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][28], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][28], 20.000000, 33.000000);

	PlayerPokerUI[playerid][29] = CreatePlayerTextDraw(playerid, 444.000000, 245.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][29], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][29], 100);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][29], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][29], 0.180000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][29], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][29], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][29], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][29], 0);

	PlayerPokerUI[playerid][30] = CreatePlayerTextDraw(playerid, 265.000000, 205.000000, "New Textdraw"); // Community Card Box
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][30], 0);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][30], 1);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][30], 0.539999, 2.099998);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][30], 0);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][30], 1);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][30], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][30], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][30], 100);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][30], 375.000000, 71.000000);

	PlayerPokerUI[playerid][31] = CreatePlayerTextDraw(playerid, 266.000000, 208.000000, "LD_CARD:cdback");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][31], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][31], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][31], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][31], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][31], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][31], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][31], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][31], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][31], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][31], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][31], 20.000000, 33.000000);

	PlayerPokerUI[playerid][32] = CreatePlayerTextDraw(playerid, 288.000000, 208.000000, "LD_CARD:cdback");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][32], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][32], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][32], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][32], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][32], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][32], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][32], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][32], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][32], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][32], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][32], 20.000000, 33.000000);

	PlayerPokerUI[playerid][33] = CreatePlayerTextDraw(playerid, 310.000000, 208.000000, "LD_CARD:cdback");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][33], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][33], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][33], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][33], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][33], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][33], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][33], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][33], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][33], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][33], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][33], 20.000000, 33.000000);

	PlayerPokerUI[playerid][34] = CreatePlayerTextDraw(playerid, 332.000000, 208.000000, "LD_CARD:cdback");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][34], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][34], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][34], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][34], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][34], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][34], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][34], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][34], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][34], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][34], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][34], 20.000000, 33.000000);

	PlayerPokerUI[playerid][35] = CreatePlayerTextDraw(playerid, 354.000000, 208.000000, "LD_CARD:cdback");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][35], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][35], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][35], 4);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][35], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][35], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][35], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][35], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][35], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][35], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][35], 255);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][35], 20.000000, 33.000000);

	PlayerPokerUI[playerid][36] = CreatePlayerTextDraw(playerid, 320.000000, 193.000000, "New Textdraw");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][36], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][36], 0);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][36], 1);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][36], 0.500000, 0.399999);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][36], 0);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][36], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][36], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][36], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][36], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][36], 50);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][36], 390.000000, 110.000000);

	PlayerPokerUI[playerid][37] = CreatePlayerTextDraw(playerid, 318.000000, 191.000000, "Texas Holdem Poker");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][37], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][37], -1);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][37], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][37], 0.199999, 1.200000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][37], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][37], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][37], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][37], 0);

	PlayerPokerUI[playerid][38] = CreatePlayerTextDraw(playerid, 321.000000, 268.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][38], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][38], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][38], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][38], 0.189999, 1.200000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][38], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][38], 1);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][38], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][38], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][38], 45);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][38], 10.000000, 26.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerPokerUI[playerid][38], 1);

	PlayerPokerUI[playerid][39] = CreatePlayerTextDraw(playerid, 321.000000, 284.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][39], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][39], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][39], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][39], 0.189999, 1.200000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][39], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][39], 1);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][39], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][39], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][39], 45);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][39], 10.000000, 26.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerPokerUI[playerid][39], 1);

	PlayerPokerUI[playerid][40] = CreatePlayerTextDraw(playerid, 321.000000, 300.000000, " ");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][40], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][40], 255);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][40], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][40], 0.189999, 1.200000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][40], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][40], 1);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][40], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][40], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][40], 45);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][40], 10.000000, 26.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerPokerUI[playerid][40], 1);

	PlayerPokerUI[playerid][45] = CreatePlayerTextDraw(playerid, 5.000000, 100.000000, " ");
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][45], 0);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][45], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][45], 0.159999, 1.099999);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][45], 200);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][45], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][45], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][45], 1);

	PlayerPokerUI[playerid][46] = CreatePlayerTextDraw(playerid, 318.000000, 245.000000, "Texas Holdem Poker");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][46], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][46], -1);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][46], 2);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][46], 0.199999, 1.200000);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][46], -1);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][46], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][46], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][46], 0);

	PlayerPokerUI[playerid][47] = CreatePlayerTextDraw(playerid, 320.000000, 248.000000, "New Textdraw");
	PlayerTextDrawAlignment(playerid, PlayerPokerUI[playerid][47], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerPokerUI[playerid][47], 0);
	PlayerTextDrawFont(playerid, PlayerPokerUI[playerid][47], 1);
	PlayerTextDrawLetterSize(playerid, PlayerPokerUI[playerid][47], 0.500000, 0.399998);
	PlayerTextDrawColor(playerid, PlayerPokerUI[playerid][47], 0);
	PlayerTextDrawSetOutline(playerid, PlayerPokerUI[playerid][47], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPokerUI[playerid][47], 1);
	PlayerTextDrawSetShadow(playerid, PlayerPokerUI[playerid][47], 1);
	PlayerTextDrawUseBox(playerid, PlayerPokerUI[playerid][47], 1);
	PlayerTextDrawBoxColor(playerid, PlayerPokerUI[playerid][47], 50);
	PlayerTextDrawTextSize(playerid, PlayerPokerUI[playerid][47], 390.000000, 110.000000);
}