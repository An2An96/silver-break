#if defined _house_interface_included
	#endinput
#endif

#define _house_interface_included

#define SELECTION_ITEMS 		21      // Количество пунктов в листе покупки мебели

new
	Text:tdHouseDoor,
	Text:tdHouseRob,
	Text:tdHouseButton1,
	Text:tdHouseButton2,
	Text:tdHouseButton3,
	Text:tdHouseButton4,

	Text:furBackgroundTD,
	Text:furButtonTD[3],

//	furniture
	PlayerText:furInitTD,
	PlayerText:furPageTD,
	PlayerText:furInfoTD,

	PlayerText:furModelTD[SELECTION_ITEMS];

Public: IFace.House_OnPlayerClickTD(playerid, Text:clickedid)
{
	if(clickedid == Text:INVALID_TEXT_DRAW)
	{
		if(IFace.GetGroupToggleAndVisible(playerid, IFace.HOUSE_FUR))
		{
			BuyPlayerFurniture(playerid);
   			ShowDialog(playerid, DHOME_FURNITURE);
   			return true;
		}
		else if(IFace.GetGroupToggleAndVisible(playerid, IFace.HOUSE_ENTER_MENU))
		{
			HidePropertyMenu(playerid);
			return true;
		}
	}
	else
	{
		new h = PickupedHouse[playerid];
	    if(h >= 0 && HouseInfo[h][hOwnerID] > 0)
	    {
			if(clickedid == tdHouseDoor)
			{	// Enter
	            if(HouseInfo[h][hOwnerID] != PlayerInfo[playerid][pUserID] && PlayerInfo[playerid][pRent] != HouseInfo[h][hID] && HouseInfo[h][hLock])
	            {
					return GameTextForPlayer(playerid, "~w~House ~r~Closed", 5000, 3);
	            }
	            new Class = HouseInfo[h][hClass] - 1;
	            new Int = HouseInfo[h][hInt] - 1;
				SetCameraBehindPlayer(playerid);
				HidePropertyMenu(playerid);
	            MySetPlayerPosFade(playerid, FT_HOUSE, Arr3<InterCoords[Class][Int]>, InterCoords[Class][Int][3] + 180.0, true, 1, VW_HOUSE + HouseInfo[h][hID]);
	        	return true;
	        }
			else if(HouseInfo[h][hOwnerID] == PlayerInfo[playerid][pUserID])
			{
				if(clickedid == tdHouseButton1)
				{	// Lock
			        if(HouseInfo[h][hLock])	GameTextForPlayer(playerid, "~w~Door ~g~Unlocked", 5000, 3);
			        else					GameTextForPlayer(playerid, "~w~Door ~r~Locked", 5000, 3);
					HouseInfo[h][hLock] = !HouseInfo[h][hLock];
					new string[128];
					mysql_format(g_SQL, string, sizeof(string), "UPDATE `houses` SET `lock` = '%d' WHERE `id` = '%d'", HouseInfo[h][hLock], h + 1);
					mysql_query_ex(string);
					return true;
				}
				else if(clickedid == tdHouseButton4)
				{
				    ShowDialog(playerid, DMODE_HOUSE_SELL);	// Sell
				    return true;
				}
		    }
		    else
		    {
				if(clickedid == tdHouseRob)
				{	// Robbery
				    SendClientMessage(playerid, COLOR_GREY, "Ошибка: Эта возможность пока отсутствует");
				    return true;
				}
				else if(clickedid == tdHouseButton2)
				{	//	Rent
					ShowDialog(playerid, DHOME_TAKE_RENT);
					return true;
				}
				else if(clickedid == tdHouseButton3)
				{	//	Unrent
					ShowDialog(playerid, DHOME_CANCEL_RENT);
					return true;
				}
		    }
		    return true;
	    }

	    if(IFace.GetGroupToggleAndVisible(playerid, IFace.HOUSE_FUR))
		{
	        if(clickedid == furButtonTD[0] && ++BuyFurFurCategory[playerid] >= sizeof(FurCategories))
	        {
				BuyFurFurCategory[playerid] = 0;
	        }
	        else if(clickedid == furButtonTD[1] && --BuyFurFurCategory[playerid] < 0)
	        {
	            BuyFurFurCategory[playerid] = sizeof(FurCategories) - 1;
	        }
			else if(clickedid == furButtonTD[2])
			{
			    if(BuyFurSelectItem[playerid] == (-1))
			    {
			        return SendClientMessage(playerid, COLOR_GREY, "Ошибка: Вы не выбрали объект для покупки");
			    }
	            for(new i = 0, count = 0; i < sizeof(FurnitureList); i++)
				{
				    if(FurnitureList[i][fType] == BuyFurFurCategory[playerid])
				    {
						if(BuyFurSelectItem[playerid] != count++)	continue;
						new house = GetPlayerHouseID(playerid);
						if(house == (-1))
						{
							SendClientMessage(playerid, COLOR_GREY, "Ошибка: Вы должны быть в доме, чтобы использовать эту команду");
						}
						else if(HouseInfo[house][hOwnerID] != PlayerInfo[playerid][pUserID])
						{
					    	SendClientMessage(playerid, COLOR_GREY, "Ошибка: Вы не владелец этого дома");
						}
						else
						{
						    if(GetOccupiedFurSlots(house) >= GetHouseFurSlot(house))
						    {
						        return SendClientMessage(playerid, COLOR_GREY, "Ошибка: У вас нет свободных слотов для покупки новой мебели" );
						    }
							if(MyGetPlayerMoney(playerid) < FurnitureList[i][fPrice])
							{
						    	return SendClientMessage(playerid, COLOR_GREY, "Ошибка: У вас недостаточно денег");
							}
						    new stmp[128];
							mysql_format(g_SQL, stmp, sizeof stmp, "INSERT INTO `furniture` SET `house_id` = '%d', `object_id` = '%d', `fur_num` = '%d'", HouseInfo[house][hID], FurnitureList[i][fID], i);
							mysql_query_ex(stmp);
							SendFormatMessage(playerid, COLOR_WHITE, stmp, "Вы приобрели в свой дом %s, установить мебель можно через меню дома!", FurnitureList[i][fName]);
							MyGivePlayerMoney(playerid, -FurnitureList[i][fPrice]);
							return true;
						}
						return BuyPlayerFurniture(playerid);
				    }
				    else if(count && FurnitureList[i][fType] != BuyFurFurCategory[playerid])
				    {
				        return true;
				    }
				}
				return true;
			}
	        IFace.House_FurSetTitle(playerid, FurCategories[ BuyFurFurCategory[playerid] ]);
	        IFace.House_FurSetInfo(playerid, "_");
	        IFace.House_FurSetPage(playerid, BuyFurFurCategory[playerid] + 1, sizeof(FurCategories));
			CreateFurnituresModels(playerid, BuyFurFurCategory[playerid]);
			BuyFurSelectItem[playerid] = (-1);
	    }
	}
	return CONTINUE;
}

Public: IFace.House_OnPlayerClickPTD(playerid, PlayerText:playertextid)
{
	if(IFace.GetGroupToggleAndVisible(playerid, IFace.HOUSE_FUR))
	{
        new x = 0;
		while(x != SELECTION_ITEMS)
		{
		    if(playertextid == furModelTD[x])
			{
	            for(new i = 0, count = 0; i < sizeof(FurnitureList); i++)
				{
				    if(FurnitureList[i][fType] == BuyFurFurCategory[playerid])
				    {
						if(x != count++)	continue;
						if(BuyFurSelectItem[playerid] != -1)
						{
							IFace.House_FurToggleItem(playerid, BuyFurSelectItem[playerid], false);
						}
						new string[64];
	                    format(string, sizeof(string), "Стоимость: %d$     Объект: %s [ID: %d]", FurnitureList[i][fPrice], FurnitureList[i][fName], FurnitureList[i][fID]);
	                    IFace.House_FurSetInfo(playerid, string);
	                    BuyFurSelectItem[playerid] = x;
	                    IFace.House_FurToggleItem(playerid, BuyFurSelectItem[playerid], true);
	                    break;
				    }
				    else if(count && FurnitureList[i][fType] != BuyFurFurCategory[playerid])
				    {
				        break;
				    }
				}
		    	PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
	        	return true;
			}
			x++;
		}
    }

	return CONTINUE;
}

//////////	Functions	//////////
Public: IFace.House_EnterMenuToggle(playerid, bool:toggle, bool:changeVisible)
{
	if(toggle)
	{
		TextDrawShowForPlayer(playerid, tdHouseDoor);
	}
	else
	{
		TextDrawHideForPlayer(playerid, tdHouseDoor);
		TextDrawHideForPlayer(playerid, tdHouseRob);
		TextDrawHideForPlayer(playerid, tdHouseButton1);
		TextDrawHideForPlayer(playerid, tdHouseButton2);
		TextDrawHideForPlayer(playerid, tdHouseButton3);
		TextDrawHideForPlayer(playerid, tdHouseButton4);
	}

	return true;
}

	//	Furnitures
Public: IFace.House_FurToggle(playerid, bool:toggle, bool:changeVisible)
{
	if(toggle)
	{
		TextDrawShowForPlayer(playerid, furBackgroundTD);
	    TextDrawShowForPlayer(playerid, furButtonTD[0]);
	    TextDrawShowForPlayer(playerid, furButtonTD[1]);
        TextDrawShowForPlayer(playerid, furButtonTD[2]);
	}
	else
	{
		TextDrawHideForPlayer(playerid, furBackgroundTD);
	    TextDrawHideForPlayer(playerid, furButtonTD[0]);
	    TextDrawHideForPlayer(playerid, furButtonTD[1]);
		TextDrawHideForPlayer(playerid, furButtonTD[2]);

	    PlayerTextDrawHide(playerid, furInitTD);
	    PlayerTextDrawHide(playerid, furPageTD);
	    PlayerTextDrawHide(playerid, furInfoTD);

	    for(new i = 0; i < SELECTION_ITEMS; i++)	PlayerTextDrawHide(playerid, furModelTD[i]);
	}
	return true;
}

IFace.House_FurAddItem(playerid, item, model)
{
	PlayerTextDrawBackgroundColor(playerid, furModelTD[item], 0x88888899);
	PlayerTextDrawSetPreviewModel(playerid, furModelTD[item], model);
	PlayerTextDrawShow(playerid, furModelTD[item]);
}

IFace.House_FurHideItem(playerid, item)
{
	PlayerTextDrawHide(playerid, furModelTD[item]);
}

IFace.House_FurSetPage(playerid, page, maxPages)
{
	new string[4];
	format(string, sizeof(string), "%d/%d", page, maxPages);
   	PlayerTextDrawSetString(playerid, furPageTD, string);
}

IFace.House_FurSetTitle(playerid, title[])
{
	new string[32];
 	format(string, sizeof(string), "%s", RusText(title, isRus(playerid)));
	PlayerTextDrawSetString(playerid, furInitTD, string);
	PlayerTextDrawShow(playerid, furInitTD);
}

IFace.House_FurSetInfo(playerid, info[])
{
	new string[32];
 	format(string, sizeof(string), "%s", RusText(info, isRus(playerid)));
	PlayerTextDrawSetString(playerid, furInfoTD, string);
	PlayerTextDrawShow(playerid, furInfoTD);
}

IFace.House_FurToggleItem(playerid, item, bool:toggle)
{
	PlayerTextDrawBackgroundColor(playerid, furModelTD[item], toggle ? COLOR_SERVER : 0x88888899);//0x33AA33AA
	PlayerTextDrawShow(playerid, furModelTD[item]);
}

//////////////////////////////
IFace.House_Create_Base()
{
	IFace.AddWantShow(IFace.HOUSE_ENTER_MENU,	IFace.TV_EFFECT);

	tdHouseRob = TextDrawCreate(217.0, 341.0, " ");
	TextDrawFont(tdHouseRob, TEXT_DRAW_FONT_MODEL_PREVIEW);
	TextDrawBackgroundColor(tdHouseRob, 0xFF634788);// COLOR_LIGHTRED
	TextDrawTextSize(tdHouseRob, 60.0, 80.0);
	TextDrawBoxColor(tdHouseRob, 0x00000000);
	TextDrawSetPreviewModel(tdHouseRob, 18635);
	TextDrawSetPreviewRot(tdHouseRob, 0.0, 0.0, 0.0, 1.0);
	TextDrawSetSelectable(tdHouseRob, true);

	tdHouseDoor = TextDrawCreate(287.0, 341.0, " ");
	TextDrawFont(tdHouseDoor, TEXT_DRAW_FONT_MODEL_PREVIEW);
	TextDrawBackgroundColor(tdHouseDoor, 0xFFFFFFAA);// COLOR_WHITE
	TextDrawTextSize(tdHouseDoor, 60.0, 80.0);
	TextDrawBoxColor(tdHouseDoor, 0x00000000);
	TextDrawSetPreviewModel(tdHouseDoor, 1535);
	TextDrawSetPreviewRot(tdHouseDoor, 0.0, 0.0, 330.0, 0.9);
	TextDrawSetSelectable(tdHouseDoor, true);

	tdHouseButton1 = TextDrawCreate(357.0, 341.0, "lock");
	TextDrawFont(tdHouseButton1, 3);
	TextDrawLetterSize(tdHouseButton1, 0.58, 1.7);
	TextDrawTextSize(tdHouseButton1, 450.0, 15.0);
	TextDrawSetShadow(tdHouseButton1, 0);
	TextDrawSetOutline(tdHouseButton1, 1);
	TextDrawSetSelectable(tdHouseButton1, true);

	tdHouseButton2 = TextDrawCreate(357.0, 341.0, "rent");
	TextDrawFont(tdHouseButton2, 3);
	TextDrawLetterSize(tdHouseButton2, 0.58, 1.7);
	TextDrawTextSize(tdHouseButton2, 450.0, 15.0);
	TextDrawSetShadow(tdHouseButton2, 0);
	TextDrawSetOutline(tdHouseButton2, 1);
	TextDrawSetSelectable(tdHouseButton2, true);

	tdHouseButton3 = TextDrawCreate(357.0, 341.0, "unrent");
	TextDrawFont(tdHouseButton3, 3);
	TextDrawLetterSize(tdHouseButton3, 0.58, 1.7);
	TextDrawTextSize(tdHouseButton3, 450.0, 15.0);
	TextDrawSetShadow(tdHouseButton3, 0);
	TextDrawSetOutline(tdHouseButton3, 1);
	TextDrawSetSelectable(tdHouseButton3, true);

	tdHouseButton4 = TextDrawCreate(357.0, 401.0, "sell");
	TextDrawFont(tdHouseButton4, 3);
	TextDrawLetterSize(tdHouseButton4, 0.58, 1.7);
	TextDrawTextSize(tdHouseButton4, 450.0, 15.0);
	TextDrawSetShadow(tdHouseButton4, 0);
	TextDrawSetOutline(tdHouseButton4, 1);
	TextDrawSetSelectable(tdHouseButton4, true);

	furBackgroundTD = TextDrawCreate( 75.0, 150.0, "                                            ~n~" );	// enough space for everyone
    TextDrawUseBox( furBackgroundTD, 1 );
    TextDrawBoxColor( furBackgroundTD, 0x4A5A6BBB );
	TextDrawLetterSize( furBackgroundTD, 5.0, 5.0 );
	TextDrawFont( furBackgroundTD, 0 );
	TextDrawSetShadow( furBackgroundTD, 0 );
    TextDrawSetOutline( furBackgroundTD, 0 );
    TextDrawColor( furBackgroundTD,0x000000FF );
    TextDrawTextSize( furBackgroundTD, 550.0, 180.0 );
   	TextDrawBackgroundColor( furBackgroundTD, 0x4A5A6BBB );

    furButtonTD[0] = TextDrawCreate( 520.0, 385.0, "Next" );
   	TextDrawUseBox( furButtonTD[0], 1 );
   	TextDrawBoxColor( furButtonTD[0], 0x000000FF );
   	TextDrawBackgroundColor( furButtonTD[0], 0x000000FF );
	TextDrawLetterSize( furButtonTD[0], 0.4, 1.1 );
	TextDrawFont( furButtonTD[0], 1 );
	TextDrawSetShadow( furButtonTD[0], 0 ); // no shadow
    TextDrawSetOutline( furButtonTD[0], 0 );
    TextDrawColor( furButtonTD[0], 0x4A5A6BFF );
    TextDrawSetSelectable( furButtonTD[0], 1 );
    TextDrawAlignment( furButtonTD[0], 2 );
    TextDrawTextSize( furButtonTD[0], 50.0, 50.0 ); // The width and height are reversed for centering.. something the game does <g>

    furButtonTD[1] = TextDrawCreate( 460.0, 385.0, "Prev" );
   	TextDrawUseBox( furButtonTD[1], 1 );
   	TextDrawBoxColor( furButtonTD[1], 0x000000FF );
   	TextDrawBackgroundColor( furButtonTD[1], 0x000000FF );
	TextDrawLetterSize( furButtonTD[1], 0.4, 1.1 );
	TextDrawFont( furButtonTD[1], 1 );
	TextDrawSetShadow( furButtonTD[1], 0 ); // no shadow
    TextDrawSetOutline( furButtonTD[1], 0 );
    TextDrawColor( furButtonTD[1], 0x4A5A6BFF );
    TextDrawSetSelectable( furButtonTD[1], 1 );
    TextDrawAlignment( furButtonTD[1], 2 );
    TextDrawTextSize( furButtonTD[1], 50.0, 50.0 ); // The width and height are reversed for centering.. something the game does <g>

    furButtonTD[2] = TextDrawCreate( 400.0, 385.0, "Buy" );
   	TextDrawUseBox( furButtonTD[2], 1 );
   	TextDrawBoxColor( furButtonTD[2], 0x000000FF );
   	TextDrawBackgroundColor( furButtonTD[2], 0x000000FF );
	TextDrawLetterSize( furButtonTD[2], 0.4, 1.1 );
	TextDrawFont( furButtonTD[2], 1 );
	TextDrawSetShadow( furButtonTD[2], 0 ); // no shadow
    TextDrawSetOutline( furButtonTD[2], 0 );
    TextDrawColor( furButtonTD[2], 0x4A5A6BFF );
    TextDrawSetSelectable( furButtonTD[2], 1 );
    TextDrawAlignment( furButtonTD[2], 2 );
    TextDrawTextSize( furButtonTD[2], 50.0, 50.0 ); // The width and height are reversed for centering.. something the game does <g>
}

IFace.House_Create_Player(playerid)
{
	furInitTD = CreatePlayerTextDraw(playerid, 75.0, 130.0, "_");
   	PlayerTextDrawUseBox( playerid, furInitTD, 0 );
	PlayerTextDrawLetterSize( playerid, furInitTD, 1.25, 3.0 );
	PlayerTextDrawFont( playerid, furInitTD, 0 );
	PlayerTextDrawSetShadow( playerid, furInitTD, 0 );
    PlayerTextDrawSetOutline( playerid, furInitTD, 1 );
    PlayerTextDrawColor( playerid, furInitTD, 0xACCBF1FF );

	furPageTD = CreatePlayerTextDraw( playerid, 520.0, 150.0, "_");
   	PlayerTextDrawUseBox( playerid, furPageTD, 0 );
	PlayerTextDrawLetterSize( playerid, furPageTD, 0.4, 1.1 );
	PlayerTextDrawFont( playerid, furPageTD, 1 );
	PlayerTextDrawSetShadow( playerid, furPageTD, 0 );
    PlayerTextDrawSetOutline( playerid, furPageTD, 1 );
    PlayerTextDrawColor( playerid, furPageTD, 0xACCBF1FF );

    furInfoTD = CreatePlayerTextDraw( playerid, 100.0, 360.0, "_");
   	PlayerTextDrawUseBox( playerid, furInfoTD, 0 );
	PlayerTextDrawLetterSize( playerid, furInfoTD, 0.4, 1.1 );
	PlayerTextDrawFont( playerid, furInfoTD, 1 );
	PlayerTextDrawSetShadow( playerid, furInfoTD, 0 );
    PlayerTextDrawSetOutline( playerid, furInfoTD, 1 );
    PlayerTextDrawColor( playerid, furInfoTD, 0xACCBF1FF );

    new Float:BaseX = 75.0;
	new Float:BaseY = 130.0 - ( 60.0 * 0.33 ); // down a bit
    for(new i = 0; i < SELECTION_ITEMS; i++, BaseX += 61.0)
	{
	    if(i % ITEMS_PER_LINE == 0)
		{
	        BaseX = 75.0 + 25.0; // in a bit from the box
	        BaseY += 60.0 + 1.0; // move on the Y for the next line
		}

  		furModelTD[i] = CreatePlayerTextDraw(playerid, BaseX, BaseY, ""); // it has to be set with SetText later
	    PlayerTextDrawFont(playerid, furModelTD[i], TEXT_DRAW_FONT_MODEL_PREVIEW);
	    PlayerTextDrawColor(playerid, furModelTD[i], 0xFFFFFFFF);
	    PlayerTextDrawBackgroundColor(playerid, furModelTD[i], 0x88888899);
	    PlayerTextDrawBoxColor(playerid, furModelTD[i], 0x00000000);
	    PlayerTextDrawTextSize(playerid, furModelTD[i], 60.0, 60.0); // Text size is the Width:Height
	    PlayerTextDrawSetPreviewModel(playerid, furModelTD[i], 0);
	    PlayerTextDrawSetSelectable(playerid, furModelTD[i], true);
	}
}