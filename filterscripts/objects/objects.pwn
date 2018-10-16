#include <a_samp>
#include <streamer>
//#include "../sources/lib/streamer"

forward RemoveStaticObjects(playerid);

new start_obj, end_obj, maps, obj;

public OnFilterScriptInit()
{
	start_obj = Main_CreateObjects();		maps++;
	CityLS_CreateObjects();					maps++;
	DivingJob_CreateObjects();				maps++;
	House_Int_CreateObjects();				maps++;
	News_Int_CreateObjects();				maps++;
	Park_CreateObjects();					maps++;
	Login_CreateObjects();					maps++;
	Airport_CreateObjects();				maps++;
	Farm_CreateObjects();					maps++;
	CityHall_Int_CreateObjects();			maps++;
	AztecasHouse_Int_CreateObjects();		maps++;
	Hospital_Int_CreateObjects();			maps++;
	FCClothes_Int_CreateObjects();			maps++;
	FBI_CreateObjects();					maps++;
	LSPD_CreateObjects();					maps++;
	LSPD_Int_CreateObjects();				maps++;
	Autoschool_CreateObjects();				maps++;
	FortCarson_CreateObjects();				maps++;
	BankLS_CreateObjects();					maps++;
	Taxi_CreateObjects();					maps++;
	MafiaHouse_CreateObjects();				maps++;
	LCNHouse_CreateObjects();				maps++;
	YakuzaHouse_CreateObjects();            maps++;
	FourDragon_CreateObjects();             maps++;
	AircraftCarrier_CreateObjects();        maps++; // Авианосец в СФ
	AJail_CreateObjects();					maps++;
	end_obj = Alcatraz_CreateObjects();		maps++;
	printf("\tLoaded %d maps [%d object]\n", maps, end_obj - start_obj);
	return true;
}

public OnFilterScriptExit()
{
	for(new i = start_obj; i < end_obj; i++)
	{
		DestroyDynamicObject(i);
	}
	return true;
}

public RemoveStaticObjects(playerid)
{
	//RemoveBuildingForPlayer(playerid, 17566, 2520.7344, -1673.8359, 15.5469, 0.10);// Ворота в гараж свита [BT]
	//RemoveBuildingForPlayer(playerid, 4084, 1643.4297, -1520.3047, 14.3438, 0.10);// Ворота в точке автосбыта ЛС-ЛСПД
	

	/*RemoveBuildingForPlayer(playerid, 4024, 1479.8672, -1790.3984, 56.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 4044, 1481.1875, -1785.0703, 22.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1527, 1448.2344, -1755.8984, 14.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 1220, 1420.4922, -1842.4375, 12.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 1220, 1419.7266, -1842.8516, 12.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 4002, 1479.8672, -1790.3984, 56.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 3980, 1481.1875, -1785.0703, 22.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 4003, 1481.0781, -1747.0313, 33.5234, 0.25);*/

	//	Спавн новичков
	RemoveBuildingForPlayer(playerid, 1280, 955.9063, -1656.2344, 12.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 954.7578, -1656.1797, 12.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 955.0547, -1651.6094, 15.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 638, 955.3281, -1653.4531, 13.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 638, 955.3281, -1649.8672, 13.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 954.6484, -1647.0313, 12.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 955.9063, -1647.0313, 12.8984, 0.25);

	//	Ящики в доках (освободить место под работу дайвера)
	RemoveBuildingForPlayer(playerid, 3744, 2771.0703, -2520.5469, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2774.7969, -2534.9531, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2774.7969, -2534.9531, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2771.0703, -2520.5469, 15.2188, 0.25);

	//	Прачка (замаскированный завод наркотиков)
	RemoveBuildingForPlayer(playerid, 2938, 1055.68, 2088.58, 10.82, 5.00);

	//	Площадка перед госпиталем
	RemoveBuildingForPlayer(playerid, 5929, 1230.8906, -1337.9844, 12.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 739, 1231.1406, -1341.8516, 12.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 739, 1231.1406, -1328.0938, 12.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 739, 1231.1406, -1356.2109, 12.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1374.6094, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1356.5547, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1374.6094, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1356.5547, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1335.0547, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1317.7422, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 5812, 1230.8906, -1337.9844, 12.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1335.0547, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1317.7422, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1300.9219, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1300.9219, 12.2969, 0.25);

	//	Парк перед мерией
	RemoveBuildingForPlayer(playerid, 4057, 1479.554, -1693.140, 19.578, 0.250);
	RemoveBuildingForPlayer(playerid, 4210, 1479.562, -1631.453, 12.078, 0.250);
	RemoveBuildingForPlayer(playerid, 713, 1457.937, -1620.695, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 713, 1496.867, -1707.820, 13.406, 0.250);
	RemoveBuildingForPlayer(playerid, 1283, 1430.171, -1719.468, 15.625, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1451.625, -1727.671, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1467.984, -1727.671, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1485.171, -1727.671, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1468.984, -1713.507, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 1231, 1479.695, -1716.703, 15.625, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1505.179, -1727.671, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1488.765, -1713.703, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 1289, 1504.750, -1711.882, 13.593, 0.250);
	RemoveBuildingForPlayer(playerid, 1258, 1445.007, -1704.765, 13.695, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1433.710, -1702.359, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1433.710, -1676.687, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1258, 1445.007, -1692.234, 13.695, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1433.710, -1656.250, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1433.710, -1636.234, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 712, 1445.812, -1650.023, 22.257, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1433.710, -1619.054, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1283, 1443.203, -1592.945, 15.625, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 1457.726, -1710.062, 12.398, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1461.656, -1707.687, 11.835, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1468.984, -1704.640, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 700, 1463.062, -1701.570, 13.726, 0.250);
	RemoveBuildingForPlayer(playerid, 1231, 1479.695, -1702.531, 15.625, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 1457.554, -1697.289, 12.398, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1468.984, -1694.046, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 1231, 1479.382, -1692.390, 15.632, 0.250);
	RemoveBuildingForPlayer(playerid, 4186, 1479.554, -1693.140, 19.578, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1461.125, -1687.562, 11.835, 0.250);
	RemoveBuildingForPlayer(playerid, 700, 1463.062, -1690.648, 13.726, 0.250);
	RemoveBuildingForPlayer(playerid, 641, 1458.617, -1684.132, 11.101, 0.250);
	RemoveBuildingForPlayer(playerid, 625, 1457.273, -1666.296, 13.695, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1468.984, -1682.718, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 712, 1471.406, -1666.179, 22.257, 0.250);
	RemoveBuildingForPlayer(playerid, 1231, 1479.382, -1682.312, 15.632, 0.250);
	RemoveBuildingForPlayer(playerid, 625, 1458.257, -1659.257, 13.695, 0.250);
	RemoveBuildingForPlayer(playerid, 712, 1449.851, -1655.937, 22.257, 0.250);
	RemoveBuildingForPlayer(playerid, 1231, 1477.937, -1652.726, 15.632, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1479.609, -1653.250, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 625, 1457.351, -1650.570, 13.695, 0.250);
	RemoveBuildingForPlayer(playerid, 625, 1454.421, -1642.492, 13.695, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1467.851, -1646.593, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1472.898, -1651.507, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1465.937, -1639.820, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 1231, 1466.468, -1637.960, 15.632, 0.250);
	RemoveBuildingForPlayer(playerid, 625, 1449.593, -1635.046, 13.695, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1467.710, -1632.890, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 1232, 1465.890, -1629.976, 15.531, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1472.664, -1627.882, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1479.468, -1626.023, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 3985, 1479.562, -1631.453, 12.078, 0.250);
	RemoveBuildingForPlayer(playerid, 4206, 1479.554, -1639.609, 13.648, 0.250);
	RemoveBuildingForPlayer(playerid, 1232, 1465.835, -1608.375, 15.375, 0.250);
	RemoveBuildingForPlayer(playerid, 1229, 1466.484, -1598.093, 14.109, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1451.335, -1596.703, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1471.351, -1596.703, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1488.765, -1704.593, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 700, 1494.210, -1694.437, 13.726, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1488.765, -1693.734, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1496.976, -1686.851, 11.835, 0.250);
	RemoveBuildingForPlayer(playerid, 641, 1494.140, -1689.234, 11.101, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1488.765, -1682.671, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 712, 1480.609, -1666.179, 22.257, 0.250);
	RemoveBuildingForPlayer(playerid, 712, 1488.226, -1666.179, 22.257, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1486.406, -1651.390, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1491.367, -1646.382, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1493.132, -1639.453, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1486.179, -1627.765, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 1280, 1491.218, -1632.679, 13.453, 0.250);
	RemoveBuildingForPlayer(playerid, 1232, 1494.414, -1629.976, 15.531, 0.250);
	RemoveBuildingForPlayer(playerid, 1232, 1494.359, -1608.375, 15.375, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1488.531, -1596.703, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1229, 1498.054, -1598.093, 14.109, 0.250);
	RemoveBuildingForPlayer(playerid, 1288, 1504.750, -1705.406, 13.593, 0.250);
	RemoveBuildingForPlayer(playerid, 1287, 1504.750, -1704.468, 13.593, 0.250);
	RemoveBuildingForPlayer(playerid, 1286, 1504.750, -1695.054, 13.593, 0.250);
	RemoveBuildingForPlayer(playerid, 1285, 1504.750, -1694.039, 13.593, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 1498.960, -1684.609, 12.398, 0.250);
	RemoveBuildingForPlayer(playerid, 625, 1504.164, -1662.015, 13.695, 0.250);
	RemoveBuildingForPlayer(playerid, 625, 1504.718, -1670.921, 13.695, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1503.187, -1621.125, 11.835, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 1501.281, -1624.578, 12.398, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 1498.359, -1616.968, 12.398, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1504.890, -1596.703, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 712, 1508.445, -1668.742, 22.257, 0.250);
	RemoveBuildingForPlayer(playerid, 625, 1505.695, -1654.835, 13.695, 0.250);
	RemoveBuildingForPlayer(playerid, 625, 1508.515, -1647.859, 13.695, 0.250);
	RemoveBuildingForPlayer(playerid, 625, 1513.273, -1642.492, 13.695, 0.250);
	RemoveBuildingForPlayer(playerid, 1258, 1510.890, -1607.312, 13.695, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1524.828, -1721.632, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1524.828, -1705.273, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1229, 1524.218, -1693.968, 14.109, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1524.828, -1688.085, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1229, 1524.218, -1673.710, 14.109, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1524.828, -1668.078, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1524.828, -1647.640, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1524.828, -1621.960, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 1525.382, -1611.156, 16.421, 0.250);
	RemoveBuildingForPlayer(playerid, 1283, 1528.953, -1605.859, 15.625, 0.250);

	// Airport
	RemoveBuildingForPlayer(playerid, 4890, 1683.2188, -2328.4297, 11.8750, 0.25); //здание аэропорта
	RemoveBuildingForPlayer(playerid, 4995, 1682.070, -2330.609, 16.898, 0.250);//здание аэропорта 2
	RemoveBuildingForPlayer(playerid, 4990, 1646.1953, -2414.0703, 17.9297, 0.25);//бочка аэропорта. даёт тень
	RemoveBuildingForPlayer(playerid, 5010, 1646.1953, -2414.0703, 17.9297, 0.25);//бочка аэропорта. даёт тень
	RemoveBuildingForPlayer(playerid, 4995, 1682.0703, -2330.6094, 16.8984, 0.25);//таблички под крышой аэропорта
	RemoveBuildingForPlayer(playerid, 4991, 1683.218, -2242.960, 11.789, 0.250);//таблички под крышой 2

	// Ферма
	RemoveBuildingForPlayer(playerid, 3374, -1206.1406, -1169.8359, 129.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3374, -1198.8672, -1169.8359, 129.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3374, -1191.6016, -1169.8359, 129.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3374, -1184.3281, -1169.8359, 129.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3374, -1177.0547, -1169.8359, 129.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -1064.9609, -1273.0156, 129.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -1088.4063, -1180.0703, 129.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 17007, -1071.9219, -1170.2109, 128.2188, 0.25);
	// Сено на ферме (возле праведника)
	RemoveBuildingForPlayer(playerid, 3374, -1206.1406, -1169.8359, 129.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3374, -1198.8672, -1169.8359, 129.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3374, -1191.6016, -1169.8359, 129.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3374, -1184.3281, -1169.8359, 129.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3374, -1177.0547, -1169.8359, 129.7031, 0.25);

	//	Свалка
	RemoveBuildingForPlayer(playerid, 18499, -1849.5156, -1701.1563, 32.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 18557, -1857.2969, -1617.9766, 26.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 18560, -1874.3438, -1680.9531, 25.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 18247, -1874.3438, -1680.9531, 25.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 18245, -1849.5156, -1701.1563, 32.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 18248, -1852.2578, -1676.2188, 28.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 18249, -1818.8125, -1675.5391, 27.0703, 0.25);
	RemoveBuildingForPlayer(playerid, 18250, -1857.2969, -1617.9766, 26.8125, 0.25);

	// Ворота для автоугона
	RemoveBuildingForPlayer(playerid, 5302, 2741.0703, -2004.7813, 14.8750, 0.25);// Ворота в точке автосбыта ЛС-Гетто
	RemoveBuildingForPlayer(playerid, 10149, -1695.0703, 1035.6172, 45.7031, 0.10);// Ворота в точке автосбыта СФ
	RemoveBuildingForPlayer(playerid, 10154, -1790.4531, 1430.1250, 8.9766, 0.25);// Ворота в точке автосбыта СФ-Порт

	// Автоматы с газировкой
	RemoveBuildingForPlayer(playerid, 955, 0.0,0.0,0.0, 5000);
	RemoveBuildingForPlayer(playerid, 956, 0.0,0.0,0.0, 5000);
	RemoveBuildingForPlayer(playerid, 1775, 0.0,0.0,0.0, 5000);
	RemoveBuildingForPlayer(playerid, 1776, 0.0,0.0,0.0, 5000);

	//	Удаление лишних объектов из оружейки lspd
	RemoveBuildingForPlayer(playerid, 18062, 314.8906, -164.2188, 1000.3203, 0.25);
	RemoveBuildingForPlayer(playerid, 18105, 312.9844, -163.2500, 1000.5547, 0.25);

	//	оружейка гетто
	RemoveBuildingForPlayer(playerid, 18048, 290.2266, -105.3203, 1000.9922, 0.25);
	//RemoveBuildingForPlayer(playerid, 18047, 289.8359, -102.9297, 1001.0938, 0.25);

	//	обычная оружейка
	RemoveBuildingForPlayer(playerid, 18034, 294.9609, -29.8906, 1003.3438, 0.25);

	// Закрашенные грувом граффити
	for(new x = 1524; x <= 1531; x++){
		RemoveBuildingForPlayer(playerid, x, 0.0,0.0,0.0, 5000);
	}
	RemoveBuildingForPlayer(playerid, 1490, 0.0,0.0,0.0, 5000);

	//	Мусорки на базе ФБР
	RemoveBuildingForPlayer(playerid, 1264, 1784.4141, -1148.3906, 23.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, 1786.2109, -1148.2969, 23.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1265, 1788.0625, -1148.4453, 23.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, 1800.4531, -1148.2969, 23.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, 1830.5703, -1147.3828, 23.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1265, 1830.4688, -1141.9375, 23.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, 1830.6172, -1143.8203, 23.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1264, 1829.8281, -1112.3906, 23.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, 1830.5703, -1113.9297, 23.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 1265, 1830.8359, -1112.2109, 23.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, 1830.5703, -1097.3047, 23.6797, 0.25);
	// Удаленные вентиляторы на базе ФБР
	RemoveBuildingForPlayer(playerid, 1617, 1831.4375, -1140.6016, 26.6953, 50.0);

	//	Товарный склад (на улице)
	RemoveBuildingForPlayer(playerid, 3744, 2179.9219, -2334.8516, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2179.9219, -2334.8516, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2165.2969, -2317.5000, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2193.2578, -2286.2891, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2183.1719, -2237.2734, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2174.6406, -2215.6563, 15.1016, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2193.0625, -2196.6406, 15.1016, 0.25);
	RemoveBuildingForPlayer(playerid, 5304, 2197.1875, -2325.5391, 27.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 5305, 2198.8516, -2213.9219, 14.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2234.3906, -2244.8281, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2226.9688, -2252.1406, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2219.4219, -2259.5234, 14.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2212.0938, -2267.0703, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2204.6328, -2274.4141, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 5126, 2197.1875, -2325.5391, 27.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2165.2969, -2317.5000, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2179.9219, -2334.8516, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3585, 2234.4297, -2287.3906, 14.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 3578, 2165.0703, -2288.9688, 13.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2193.2578, -2286.2891, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3630, 2217.5859, -2284.6641, 15.2344, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2204.6328, -2274.4141, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2212.0938, -2267.0703, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2219.4219, -2259.5234, 14.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3578, 2194.4766, -2242.8750, 13.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2226.9688, -2252.1406, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2234.3906, -2244.8281, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2183.1719, -2237.2734, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3578, 2235.1641, -2231.8516, 13.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2174.6406, -2215.6563, 15.1016, 0.25);
	RemoveBuildingForPlayer(playerid, 5244, 2198.8516, -2213.9219, 14.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2193.0625, -2196.6406, 15.1016, 0.25);
	RemoveBuildingForPlayer(playerid, 3585, 2246.4297, -2269.3672, 14.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 3585, 2252.7031, -2263.0859, 14.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 3585, 2231.8359, -2284.6406, 14.1563, 0.25);
	
	// Товарный склад (внутри)
	RemoveBuildingForPlayer(playerid, 5171, 2124.9453, -2275.4531, 20.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2131.3281, -2274.6484, 16.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2131.3438, -2274.6641, 14.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2126.8516, -2270.4453, 14.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2126.8359, -2270.4297, 16.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 5130, 2139.8594, -2271.7813, 16.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 3631, 2140.0391, -2271.5391, 14.1016, 0.25);
	RemoveBuildingForPlayer(playerid, 3631, 2149.1406, -2266.9063, 12.8750, 0.25);
	RemoveBuildingForPlayer(playerid, 3631, 2161.8516, -2264.0938, 16.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 3631, 2163.3750, -2262.6875, 16.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 3633, 2142.9141, -2256.3359, 13.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 3632, 2144.2969, -2258.1484, 13.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 3631, 2142.3047, -2255.8984, 12.8750, 0.25);
	RemoveBuildingForPlayer(playerid, 5262, 2152.7109, -2256.7813, 15.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 3633, 2158.0078, -2257.2656, 16.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3633, 2167.6641, -2256.7813, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 3633, 2167.6641, -2256.7813, 13.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 3633, 2167.6641, -2256.7813, 14.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3632, 2167.8047, -2257.3516, 16.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 3632, 2167.1719, -2257.1250, 16.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2170.0781, -2257.6641, 16.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3632, 2169.3516, -2258.0703, 17.2422, 0.25);
	RemoveBuildingForPlayer(playerid, 3632, 2168.8281, -2257.5234, 17.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 3633, 2140.3828, -2254.1016, 13.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 3632, 2150.6641, -2251.5547, 12.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 3632, 2150.2813, -2250.8516, 12.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 3633, 2150.6953, -2252.9141, 16.2344, 0.25);
	RemoveBuildingForPlayer(playerid, 3632, 2149.8125, -2253.3672, 16.2344, 0.25);
	RemoveBuildingForPlayer(playerid, 5261, 2152.2578, -2239.4609, 14.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 5269, 2146.3750, -2248.7969, 14.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 3633, 2153.7734, -2253.0859, 14.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 3633, 2154.5078, -2254.4766, 14.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 3632, 2158.5703, -2251.0156, 15.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3632, 2158.0469, -2250.5078, 15.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 5132, 2163.2891, -2251.6094, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 5259, 2168.8438, -2246.7813, 13.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2160.5625, -2234.8047, 14.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2160.5781, -2234.8203, 13.0234, 0.25);
	
	// Прицепы на загрузочной точке дальнобойщиков возле центральной фермы
	RemoveBuildingForPlayer(playerid, 3377, -149.9141, -324.3438, 1.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 12932, -117.9609, -337.4531, 3.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -149.9141, -324.3438, 1.5781, 0.25);

	// Los Santos Prison
	RemoveBuildingForPlayer(playerid, 4080, 1787.1328, -1565.6797, 11.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 4000, 1787.1328, -1565.6797, 11.9688, 0.25);

	// LSPD (exterior)
	/*RemoveBuildingForPlayer(playerid, 620, 1541.4531, -1709.6406, 13.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1546.6016, -1693.3906, 14.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1547.5703, -1689.9844, 13.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1546.8672, -1687.1016, 14.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1546.6016, -1664.6250, 14.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1546.8672, -1658.3438, 14.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1547.5703, -1661.0313, 13.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1541.4531, -1642.0313, 13.0469, 0.25);*/

	// Hotel Fort Carson
	RemoveBuildingForPlayer(playerid, 2024, 960.2500, -58.0625, 1000.3984, 0.25);// Стол в воздухе
	RemoveBuildingForPlayer(playerid, 2118, 960.8672, -45.6484, 1000.5234, 0.25);//

	// Apea51
	RemoveBuildingForPlayer(playerid, 16094, 191.1406, 1870.0391, 21.4766, 0.25);// Забор по периметру
	RemoveBuildingForPlayer(playerid, 1411, 347.1953, 1799.2656, 18.7578, 0.25);// Заборчик при въезде на парковку
	RemoveBuildingForPlayer(playerid, 1411, 342.9375, 1796.2891, 18.7578, 0.25);// Заборчик при въезде на парковку

	// Фонари Fort Carson`а
	RemoveBuildingForPlayer(playerid, 1294, -0.1484, 1193.6406, 23.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, -11.7656, 1202.8828, 23.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 20.9141, 1202.8828, 23.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 20.9141, 1193.6406, 23.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 49.1406, 1193.6406, 23.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 49.1406, 1202.8828, 23.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, -37.9766, 1202.8828, 23.2031, 0.25);

	// Остальное
	RemoveBuildingForPlayer(playerid, 1345, -162.0938, 1175.1406, 19.5391, 0.25);// Мусорка на спавне в Форт Карсоне
	RemoveBuildingForPlayer(playerid, 759, 984.0391, -1547.9688, 20.8359, 0.25);// Куст в ресторане автомастерской ЛС
	RemoveBuildingForPlayer(playerid, 968, -1736.7422, 31.8828, 3.5078, 0.25);// Шлагбаум на складе доставки авто
	RemoveBuildingForPlayer(playerid, 968, -1676.2266, 4.6250, 3.2422, 0.10);// Шлагбаум на складе доставки авто (рельсы)
	RemoveBuildingForPlayer(playerid, 985, 2497.4063, 2777.0703, 11.5313, 0.25);// ЛВ КАСС ворота 1
	RemoveBuildingForPlayer(playerid, 986, 2497.4063, 2769.1094, 11.5313, 0.25);// ЛВ КАСС ворота 2
	RemoveBuildingForPlayer(playerid, 669, -228.8281, 1050.7500, 18.8125, 0.25);// Дерево на лужайке Майка
	RemoveBuildingForPlayer(playerid, 700, -289.0625, 1074.9766, 19.0156, 0.25);// Деревья
	RemoveBuildingForPlayer(playerid, 773, -291.2578, 1085.0938, 17.6563, 0.25);// Деревья

	// Место рядом с ФК под кладбище
	RemoveBuildingForPlayer(playerid, 3342, -634.5625, 1447.8281, 12.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 3345, -648.9219, 1446.7188, 12.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 3343, -660.2422, 1446.4063, 12.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 3168, -660.2422, 1446.4063, 12.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 3172, -648.9219, 1446.7188, 12.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 3173, -634.5625, 1447.8281, 12.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 11565, -703.1250, 1460.5391, 24.7188, 1.0);
	RemoveBuildingForPlayer(playerid, 652, -637.38281, 1464.2109, 12.26563, 1.0);

	//	Для банка
	RemoveBuildingForPlayer(playerid, 13007, 2312.7031, -9.0625, 27.5313, 0.25);
	return true;
}

//	Основные объекты мода
Main_CreateObjects()
{
	obj = CreateDynamicObject(1535, 285.38, -29.48, 1000.51, 0.00, 0.00, 0.00);// Дверь в тир аммунации
    CreateDynamicObject(2987, 2228.95, -1150.51, 1030.00, 0.00, 0.00, 270.00);// Дверь отеля Джефферсон
	CreateDynamicObject(1676,1007.3336,-936.4127,42.7581,-0.0,0.0,5); // Gas tank in Vinewood
	CreateDynamicObject(1676,1000.6406,-937.1027,42.7581,-0.0,0.0,5); // Gas tank in Vinewood
	CreateDynamicObject(1686, -2026.57, 156.84, 28.00, 0.00, 0.00, 0.00);// Gas tank in SF railstation
	CreateDynamicObject(10814, 1884.77, -2283.72, 16.49, 0.00, 0.00, 270.00); // Gas tank in Airport LS
	CreateDynamicObject(10814, 1386.51, 1786.65, 13.88, 0.00, 0.00, 0.00); // Gas tank in Airport LV
	CreateDynamicObject(1536, -1753.85, 768.40, 23.87, 0.00, 0.00, 0.00); // Дверь1 в офис СФ
	CreateDynamicObject(1536, -1750.84, 768.44, 23.87, 0.00, 0.00, 180.00); // Дверь2 в офис СФ
	CreateDynamicObject(1536, -2200.83, 285.63, 34.30, 0.00, 0.00, 0.00); // Дверь1 на автопарковке
	CreateDynamicObject(1536, -2197.81, 285.67, 34.30, 0.00, 0.00, 180.00); // Дверь2 на автопарковке
	CreateDynamicObject(1536, 540.59, -1294.36, 16.22, 0.00, 0.00, 0.00); // Дверь1 в автосалоне Гротти
	CreateDynamicObject(1536, 543.61, -1294.32, 16.22, 0.00, 0.00, 180.00); // Дверь2 в автосалоне Гротти
	CreateDynamicObject(8168, -2596.11, 680.49, 28.62, 0.00, 0.00, 196.50); // Будка на автопарковку
	CreateDynamicObject(8168, -1669.32, 1312.39, 7.96, 0.00, 0.00, 60.78); // Будка на автопарковку
	CreateDynamicObject(8168, 1393.79, 2699.05, 11.64, 0.00, 0.00, 17.00); // Будка на автопарковку
	CreateDynamicObject(1538, 1461.58, -1009.88, 25.83, 0.00, 0.00, 0.00); // Дверь в банк
	CreateDynamicObject(1535, 322.97, 301.97, 998.15, 0.00, 0.00, 180.00); // Дверь в СФПД
	CreateDynamicObject(3055, 371.84, 166.58, 1006.16, 0.00, 90.00, 0.00); // Фон двери в Мэрии 1
	CreateDynamicObject(3055, 368.53, 161.80, 1016.73, 0.00, 90.00, 90.00); // Фон двери в Мэрии 2
	CreateDynamicObject(3055, 368.53, 161.80, 1024.56, 0.00, 90.00, 90.00); // Фон двери в Мэрии 3
	CreateDynamicObject(1569, 368.55, 162.77, 1024.72, 0.00, 0.00, 270.00); // Дверь в Агентстве Недвижимости
	CreateDynamicObject(1498, 2401.75, -1714.55, 13.13, 0.00, 0.00, 0.00); // Дверь в открытый дом рядом с грув стрит
	CreateDynamicObject(8168, -1714.11, -60.12, 4.36, 0.00, 0.00, 330.00); // Будка заказа авто в СФ
	CreateDynamicObject(973, -1678.36, 9.11, 3.10, 0.00, 0.00, 114.00);// Ограждение возле будки 1
	CreateDynamicObject(973, -1660.38, -8.76, 3.10, 0.00, 0.00, 155.00);// Ограждение возле будки 2
	CreateDynamicObject(973, -1667.91, -3.52, 3.10, 0.00, 0.00, 135.00);// Ограждение возле будки 3
	CreateDynamicObject(968, -1736.74, 32.04, 3.27, 0.00, 270.00, 90.00);// Шлагбаум возле будки заказа авто
	CreateDynamicObject(968, -1676.33, 4.72, 3.24, 0.00, 270.00, 135.00);// Шлагбаум возле будки заказа авто (рельсы)
	CreateDynamicObject(3075, 1658.59, 2250.90, 18.85, 137.00, 292.00, 75.00);// Закрытая надпись "Casino" 1
	CreateDynamicObject(3075, 1679.35, 2238.00, 18.87, 137.00, 292.00, 344.80);// Закрытая надпись "Casino" 2
	CreateDynamicObject(3075, 1637.70, 2238.00, 18.87, 137.00, 292.00, 164.80);// Закрытая надпись "Casino" 3
	CreateDynamicObject(1498, 2036.51, 2721.36, 10.54, 0.00, 0.00, 360.00); // Уличная дверь 1
	CreateDynamicObject(1569, 1408.57, 1896.28, 10.43, 0.00, 0.00, 90.00);// Уличная дверь 2
	CreateDynamicObject(1569, -2574.52, 1152.92, 54.66, 0.00, 0.00, 341.00);// Уличная дверь 3
	CreateDynamicObject(1498, -1800.71, 1201.01, 24.12, 0.00, 0.00, 360.00);// Уличная дверь 4
	CreateDynamicObject(19384, 965.07, -53.20, 1001.87, 0.00, 0.00, 0.00);// Стена FC элитного отеля
	CreateDynamicObject(1536, 965.02, -52.42, 1000.10, 0.00, 0.00, 270.00);// Дверь FC элитного отеля
	CreateDynamicObject(1535, 2255.64, -1140.94, 1049.55, 0.00, 0.00, 90.00);// Дверь в номере отеля 1
	CreateDynamicObject(1535, 2255.64, -1139.44, 1049.55, 0.00, 0.00, 90.00);// Дверь в номере отеля 2
	CreateDynamicObject(1497, -383.42, -1438.12, 25.31, 0.00, 0.00, 270.00);// Дверь на ферме
	CreateDynamicObject(2165, -1963.02, 288.12, 34.41, 0.00, 0.00, 315.00);// Стол в салоне Wang cars
	CreateDynamicObject(1671, -1963.41, 286.76, 34.90, 0.00, 0.00, 105.00);// Стул в салоне Wang cars
	CreateDynamicObject(3058, 2631.11035, -1484.56104, 17.87080, 0.0, 0.0, 0.0); // Решетка канализации в ЛС
	CreateDynamicObject(1498, 308.66525, 312.06943, 1002.29828, 0.0, 0.0, 0.0); // Дверь на базе Рифа в интерьере
	CreateDynamicObject(2886, 320.57111, 1023.80627, 1950.53528, 12.0, -14.0, 270.0); // Кодовый замок в вертолетах десанта
	CreateDynamicObject(19377, 2233.99683, -2215.70386, 12.35, 0.0, 90.0, 45.0); // Подставка на складе дальнобойщиков (дырка в карте)
	CreateDynamicObject(1557, 1116.23499, -2043.18005, 73.35540, 0.0, 0.0, 0.0); // Двери на крыше ЛКН
	CreateDynamicObject(1557, 1119.25415, -2043.18005, 73.35540, 0.0, 0.0, 180.0); // Двери на крыше ЛКН

//	Спавн новичков
	CreateDynamicObject(970,972.2998000,-1662.3896000,13.0000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(970,955.7705100,-1662.4004000,13.0000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(970,968.2002000,-1662.4004000,13.0000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(970,964.0498000,-1662.4004000,13.0000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(970,959.9003900,-1662.4004000,13.0000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(970,934.0996100,-1662.4100000,13.0000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(970,951.6601600,-1662.4004000,13.0000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(970,947.4853500,-1662.4004000,13.0000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(970,943.3095700,-1662.4004000,13.0000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(970,939.2002000,-1662.4004000,13.0000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(970,932.0200200,-1660.3199000,13.0000000,0.0000000,0.0000000,90.0000000);
	CreateDynamicObject(970,935.0595700,-1662.4004000,13.0000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(970,932.0205100,-1656.1504000,13.0000000,0.0000000,0.0000000,90.0000000);
	CreateDynamicObject(970,932.0205100,-1656.1504000,13.0000000,0.0000000,0.0000000,90.0000000);
	CreateDynamicObject(970,932.0000000,-1651.9795000,13.0000000,0.0000000,0.0000000,90.0000000);
	CreateDynamicObject(970,932.0000000,-1647.8101000,13.0000000,0.0000000,0.0000000,90.0000000);
	CreateDynamicObject(970,934.0700100,-1642.0300000,13.0000000,0.0000000,0.0000000,359.0000000);
	CreateDynamicObject(970,932.0000000,-1644.0699000,13.0000000,0.0000000,0.0000000,90.0000000);
	CreateDynamicObject(970,938.2000100,-1642.1000000,13.0000000,0.0000000,0.0000000,359.0000000);
	CreateDynamicObject(970,942.3499800,-1642.1700000,13.0000000,0.0000000,0.0000000,359.0000000);
	CreateDynamicObject(970,946.5000000,-1642.2400000,13.0000000,0.0000000,0.0000000,359.0000000);
	CreateDynamicObject(970,948.5999800,-1642.2800000,13.0000000,0.0000000,0.0000000,358.9950000);
	CreateDynamicObject(970,962.9000200,-1642.1500000,13.0000000,0.0000000,0.0000000,1.4000000);
	CreateDynamicObject(970,967.0499900,-1642.0500000,13.0000000,0.0000000,0.0000000,1.3950000);
	CreateDynamicObject(970,971.1500200,-1641.9500000,13.0000000,0.0000000,0.0000000,1.3950000);
	CreateDynamicObject(970,975.0999800,-1642.8400000,13.0000000,0.0000000,0.0000000,333.3950000);
	CreateDynamicObject(970,977.7299800,-1645.7000000,13.0000000,0.0000000,0.0000000,291.6410000);
	CreateDynamicObject(970,978.5000000,-1649.7000000,13.0000000,0.0000000,0.0000000,270.0000000);
	CreateDynamicObject(970,978.5000000,-1653.8400000,13.0000000,0.0000000,0.0000000,270.0000000);
	CreateDynamicObject(970,978.5000000,-1657.9500000,13.0000000,0.0000000,0.0000000,270.0000000);
	CreateDynamicObject(970,978.5100100,-1660.5200000,13.0000000,0.0000000,0.0000000,270.0000000);	
	CreateDynamicObject(970,950.7000100,-1640.2300000,13.0000000,0.0000000,0.0000000,90.0000000);
	CreateDynamicObject(970,950.7002000,-1636.1000000,13.0000000,0.0000000,0.0000000,90.0000000);
	CreateDynamicObject(970,950.7000100,-1628.2000000,13.0000000,0.0000000,0.0000000,90.0000000);
	CreateDynamicObject(970,950.7002000,-1631.9502000,13.0000000,0.0000000,0.0000000,90.0000000);
	CreateDynamicObject(970,960.8250100,-1628.1000000,13.0000000,0.0000000,0.0000000,90.0000000);
	CreateDynamicObject(970,960.8203100,-1640.0996000,13.0000000,0.0000000,0.0000000,90.0000000);
	CreateDynamicObject(970,960.8203100,-1635.9502000,13.0000000,0.0000000,0.0000000,90.0000000);
	CreateDynamicObject(970,960.8203100,-1631.8496000,13.0000000,0.0000000,0.0000000,90.0000000);
	//CreateDynamicObject(3515,955.2000100,-1651.6000000,12.4000000,0.0000000,0.0000000,0.0000000);	//	фонтан
	CreateDynamicObject(629,951.2000100,-1631.3000000,12.5000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(629,951.4000200,-1636.6000000,12.5000000,0.0000000,0.0000000,328.0000000);
	CreateDynamicObject(629,945.0000000,-1627.7000000,12.5000000,0.0000000,0.0000000,347.9970000);
	CreateDynamicObject(629,937.2000100,-1629.3000000,12.5000000,0.0000000,0.0000000,272.9920000);
	CreateDynamicObject(634,941.7000100,-1638.8000000,12.6000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(634,963.4000200,-1633.8000000,12.6000000,0.0000000,0.0000000,58.0000000);
	CreateDynamicObject(634,951.5000000,-1665.1000000,12.6000000,0.0000000,0.0000000,57.9970000);
	CreateDynamicObject(634,958.5999800,-1662.8000000,12.6000000,0.0000000,0.0000000,117.9970000);
	CreateDynamicObject(634,928.2999900,-1670.1000000,12.6000000,0.0000000,0.0000000,117.9930000);
	CreateDynamicObject(634,929.9000200,-1683.3000000,12.6000000,0.0000000,0.0000000,117.9930000);
	CreateDynamicObject(634,933.5000000,-1662.4000000,12.6000000,0.0000000,0.0000000,115.9930000);
	CreateDynamicObject(645,935.7999900,-1679.8000000,12.5000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(645,950.9000200,-1687.2000000,12.5000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(645,966.5999800,-1678.0000000,12.5000000,0.0000000,0.0000000,0.0000000);

//	Ammunation LS
	CreateDynamicObject(2414, 290.12, -33.90, 1000.512, 0.0, 0.0, -90.0);		//	прилавок
	CreateDynamicObject(2414, 290.89, -34.93, 1000.510, 0.0, 0.0, 90.00);		//	прилавок
	CreateDynamicObject(355, 289.934, -33.987, 1001.561, 83.80, -50.88, 98.4);	//	AK47
	CreateDynamicObject(356, 289.873, -34.759, 1001.610, -83.7, 122.09, 65.0);	//	M4
	CreateDynamicObject(357, 290.731, -34.651, 1001.537, 97.29, 122.08, -161.8);//	Rifle
	CreateDynamicObject(351, 291.091, -33.597, 1001.543, 95.90, 79.39, -164.9);	//	Combut

	CreateDynamicObject(2414, 294.12, -33.90, 1000.515, 00.0, 00.0, -90.0);		//	прилавок
	CreateDynamicObject(2414, 294.91, -34.93, 1000.510, 00.0, 00.0, 90.00);		//	прилавок
	CreateDynamicObject(347, 293.985, -34.12, 1001.565, 95.9, -119.2, -142.1);	//	Silenced
	CreateDynamicObject(348, 293.983, -35.09, 1001.562, 95.9, 5.79, 82.0);		//	Deagle
	CreateDynamicObject(350, 295.028, -34.56, 1001.551, 87.3, 0.00, -86.8);		//	sawnoff
	CreateDynamicObject(353, 295.071, -33.75, 1001.562, 83.0, -99.7, 18.2);		//	mp5

	CreateDynamicObject(349, 293.393, -39.187, 1001.515, 96.6998, 92.40, -90.0);	//	shotgun
	CreateDynamicObject(358, 300.063, -36.386, 1001.816, 84.6000, -70.4, 160.4);	//	sniper
	CreateDynamicObject(373, 298.208, -38.274, 1001.965, -27.199, -58.9, 123.9);	//	Armour

//	Ammunation Getto LS
	CreateDynamicObject(355, 292.698, -105.36, 1001.210, 83.8000, -94.5, -79.70);	//	AK47
	CreateDynamicObject(356, 290.402, -105.37, 1001.224, 83.8000, -94.5, -83.00);	//	M4
	CreateDynamicObject(357, 288.125, -105.31, 1000.711, 83.2000, -43.3, -131.6);	//	Rifle
	CreateDynamicObject(351, 286.490, -105.80, 1001.497, 85.6001, -98.8, 15.399);	//	Combut

	CreateDynamicObject(347, 289.562, -110.51, 1001.492, 87.5999, 82.79, -71.2);	//	Silenced
	CreateDynamicObject(348, 290.742, -110.47, 1001.528, 86.4999, 18.89, -22.7);	//	Deagle
	CreateDynamicObject(350, 287.707, -110.50, 1001.211, 95.1999, 27.49, -21.8);	//	sawnoff
	CreateDynamicObject(353, 292.320, -110.69, 1000.739, 95.1999, 99.70, -96.7);	//	mp5

	CreateDynamicObject(349, 298.546, -106.70, 1002.535, 0.00000, 0.000, 97.00);	//	shotgun
	CreateDynamicObject(358, 298.534, -104.61, 1002.565, 0.00000, 0.000, 96.40);	//	sniper
	CreateDynamicObject(373, 286.420, -109.82, 1001.963, -29.200, -63.1, 23.80);	//	Armour

// Дорога ЛС-СФ
	CreateDynamicObject(691,-136.2998000,-1183.9004000,2.20,0.0,0.0,0.0);
	CreateDynamicObject(16390,-165.00,-1179.50,4.50,0.0,0.0,346.9980000);
	CreateDynamicObject(16390,-175.8999900,-1237.60,7.20,355.0180000,5.0140000,280.6820000);
	CreateDynamicObject(16390,-101.00,-1245.70,3.50,0.0,0.0,100.0);
	CreateDynamicObject(691,-163.20,-1244.90,2.20,0.0,0.0,0.0);
	CreateDynamicObject(691,-125.30,-1280.10,2.20,0.0,0.0,0.0);
	CreateDynamicObject(691,-109.60,-1211.20,2.20,0.0,0.0,0.0);
	CreateDynamicObject(691,-159.3999900,-1289.60,2.20,0.0,0.0,0.0);
	CreateDynamicObject(691,-122.20,-1336.00,2.20,0.0,0.0,0.0);
	CreateDynamicObject(16390,-107.80,-1367.30,3.00,0.0,0.0,180.0);
	CreateDynamicObject(691,-126.00,-1401.50,2.20,0.0,0.0,0.0);
	CreateDynamicObject(691,-174.80,-1337.60,2.20,0.0,0.0,0.0);
	CreateDynamicObject(691,-170.3999900,-1397.90,2.20,0.0,0.0,0.0);
	CreateDynamicObject(691,-169.00,-1451.30,4.50,0.0,0.0,0.0);
	CreateDynamicObject(16390,-179.50,-1433.20,4.70,0.0,0.0,282.00);
	CreateDynamicObject(3276,-154.00,-1291.40,2.80,0.0,0.0,83.2500000);
	CreateDynamicObject(3276,-155.50,-1302.90,2.90,0.0,0.0,83.2490000);
	CreateDynamicObject(3276,-156.8999900,-1314.40,2.90,0.0,0.0,83.2490000);
	CreateDynamicObject(3276,-158.30,-1325.90,2.90,0.0,0.0,83.2490000);
	CreateDynamicObject(3276,-159.70,-1337.40,2.90,0.0,0.0,83.2490000);
	CreateDynamicObject(3276,-160.50,-1349.00,2.90,0.0,0.0,89.4950000);
	CreateDynamicObject(3276,-160.70,-1360.50,2.90,0.0,0.0,89.4950000);
	CreateDynamicObject(3276,-160.70,-1372.00,2.90,0.0,0.0,91.4950000);
	CreateDynamicObject(3276,-160.20,-1383.40,2.90,0.0,0.0,93.4940000);
	CreateDynamicObject(3276,-158.8999900,-1394.90,2.90,0.0,0.0,99.4940000);
	CreateDynamicObject(12861,-44.40,-1141.20,-4.00,0.0,0.0,67.00);
	CreateDynamicObject(16285,-127.30,-1127.40,2.00,0.0,0.0,162.50);
	CreateDynamicObject(12921,-112.80,-1120.80,3.90,0.0,0.0,80.50);
	CreateDynamicObject(16285,-135.00,-1107.50,2.90,0.0,0.0,351.9990000);
	CreateDynamicObject(13367,-126.40,-1143.00,12.80,0.0,0.0,337.7500000);


// Закрытый тюнинг и покраска
	// Pay and Spray
	/*CreateDynamicObject(3055, 2071.48, -1830.80, 14.29, 0.00, 0.00, 90.00);// Los Santos P&S
	CreateDynamicObject(3055, 1025.23, -1029.32, 32.99, 0.00, 0.00, 0.00);// Los Santos P&S
	CreateDynamicObject(3055, 488.37, -1734.73, 12.13, 0.00, 0.00, 172.00);// Los Santos P&S
	CreateDynamicObject(3055, 720.19, -462.47, 16.68, 0.00, 0.00, 0.00);// LS Village P&S
	CreateDynamicObject(3055, -100.02, 1111.50, 16.81, 0.00, 0.00, 0.00);// Fort Carson P&S (1)
	CreateDynamicObject(3055, -100.02, 1111.50, 21.85, 0.00, 0.00, 0.00);// Fort Carson P&S (2)
	CreateDynamicObject(3055, -1420.53, 2591.14, 52.91, 0.00, 0.00, 0.00);// BS Village P&S (1)
	CreateDynamicObject(3055, -1420.53, 2591.14, 57.96, 0.00, 0.00, 0.00);// BS Village P&S (2)
	CreateDynamicObject(3055, -1904.49, 277.79, 38.06, 0.00, 0.00, 0.00);// San Fierro P&S (1)
	CreateDynamicObject(3055, -1904.49, 277.79, 43.10, 0.00, 0.00, 0.00);// San Fierro P&S (2)
	CreateDynamicObject(3055, -2425.55, 1028.24, 47.39, 0.00, 0.00, 0.00);// San Fierro P&S (1)
	CreateDynamicObject(3055, -2425.55, 1028.24, 52.43, 0.00, 0.00, 0.00);// San Fierro P&S (2)
	CreateDynamicObject(3055, 1968.22, 2162.34, 11.65, 0.00, 0.00, 90.00);// Las Venturas P&S*/
	
	// Vehicle Tuning
	CreateDynamicObject(3055, 1843.24, -1855.98, 13.11, 0.00, 0.00, 90.00);// Los Santos Bomb
	CreateDynamicObject(3055, 2005.00, 2303.50, 10.80, 0.00, 0.00, 0.00);// Las Venturas Bomb (1)
	CreateDynamicObject(3055, 2005.00, 2318.00, 10.80, 0.00, 0.00, 0.00);// Las Venturas Bomb (2)
	/*CreateDynamicObject(3055, 2644.83, -2039.15, 13.05, 0.00, 0.00, 0.00);// Los Santos Lowriders
	CreateDynamicObject(3055, 1041.89, -1025.92, 31.54, 0.00, 0.00, 0.00);// Los Santos Transfender
	CreateDynamicObject(3055, -1935.78, 238.83, 35.21, 0.00, 0.00, 0.00);// San Fierro Transfender
	CreateDynamicObject(3055, -2716.12, 217.27, 5.02, 0.00, 0.00, 90.00);// San Fierro Wheel Angels
	CreateDynamicObject(3055, 2386.55, 1043.50, 10.94, 0.00, 0.00, 0.00);// Las Venturas Transfender*/

	// Автобусные остановки
	CreateDynamicObject(1257, 926.096679, -1633.97473, 13.80280, 0.0, 0.0, 0.0);	//	Спавн ночиков
	CreateDynamicObject(1257, 909.339416, -1623.90075, 13.54687, 0.0, 0.0, -180.0);	//	Спавн ночиков
	CreateDynamicObject(1257, 1187.99487, -1755.13538, 13.65590, 0.0, 0.0, 0.0); // Автовокзал
	CreateDynamicObject(1257, 1167.08545, -1766.01428, 13.65590, 0.0, 0.0, 180.0); // Автовокзал
	//CreateDynamicObject(1257, 1667.14819, -2327.28589, 13.709, 0.0, 0.0, -90.0, 0);	//	остановка
	//CreateDynamicObject(1257, 1673.64417, -2262.26685, -2.60000, 0.0, 0.0, 270.0); // Аэропорт ЛС
	//CreateDynamicObject(1257, 1693.00000, -2311.00000, 13.64000, 0.0, 0.0, 90.0); // Аэропорт ЛС
	CreateDynamicObject(1257, 2231.64209, -2186.39941, 13.77740, 0.0, 0.0, 45.0); // Дальнобойная база
	CreateDynamicObject(1257, 2225.96265, -2204.61108, 13.77740, 0.0, 0.0, 225.0); // Дальнобойная база
	CreateDynamicObject(1257, 1832.59717, -1853.06299, 13.81440, 0.0, 0.0, 0.0); // Железнодорожная станция ЛС
	CreateDynamicObject(1257, 1813.05188, -1871.19763, 13.81440, 0.0, 0.0, 180.0); // Железнодорожная станция ЛС
	CreateDynamicObject(1257, 1489.45886, -1724.28417, 13.70730, 0.0, 0.0, 90.0); // Мэрия ЛС
	CreateDynamicObject(1257, 1505.20923, -1741.16418, 13.70730, 0.0, 0.0, 270.0); // Мэрия ЛС
	CreateDynamicObject(1257, 2248.13720, -1149.92797, 26.53379, 3.6, 0.0, -104.8); // Джефферсон

	//	Хот-доги
	CreateDynamicObject(1340, 958.50, -1641.0, 13.5, 0.0, 0.0, -180.0);		//	спавн новичков
	CreateDynamicObject(1340, 2183.0, -2265.3, 13.5, 0.0, 0.0, 00.000);		//	склад
	CreateDynamicObject(1340, -1038.4, -1193.6, 129.25, 0.0, 0.0, 180.0);	//	ферма

//	ЛС (город)
	new tmpobjid;

//	вывески с объявлениями
	tmpobjid = CreateDynamicObject(19980, 929.0, -1619.5, 11.2, 0.0, 0.0, 0.0);		//	спавн новичков
	SetDynamicObjectMaterial(tmpobjid, 2, 12954, "sw_furniture", "CJ_WOOD5", -1);
	CreateDynamicObject(2059, 928.9, -1619.53, 13.9, 90.0, 0.0, 0.0);
	tmpobjid = CreateDynamicObject(19980, 2159.69, -2297.79, 11.2, 0.0, 0.0, 135.0);		//	доставка продуктов
	SetDynamicObjectMaterial(tmpobjid, 2, 12954, "sw_furniture", "CJ_WOOD5", 0xFFFFFFFF);
	CreateDynamicObject(2059, 2159.78, -2297.82, 13.9, 90.0, -175.0, -50.0);

//	Парковка перед госпиталем
	tmpobjid = CreateDynamicObject(19543, 1223.135, -1353.894, 12.360, 0.0, 0.0, 0.0);
	SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", -1);
	tmpobjid = CreateDynamicObject(19543, 1238.135, -1353.894, 12.360, 0.0, 0.0, 0.0);
	SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", -1);
	tmpobjid = CreateDynamicObject(19543, 1239.082, -1354.459, 12.355, 0.0, 0.0, 0.0);
	SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", -1);
	tmpobjid = CreateDynamicObject(19543, 1223.135, -1291.415, 12.360, 0.0, 0.0, 0.0);
	SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", -1);
	tmpobjid = CreateDynamicObject(19543, 1238.135, -1291.415, 12.360, 0.0, 0.0, 0.0);
	SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", -1);
	tmpobjid = CreateDynamicObject(19543, 1241.504, -1313.956, 12.350, 0.0, 0.0, 0.0);
	SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", -1);
	//tmpobjid = CreateDynamicObject(11008, 1237.949, -1308.299, 19.15, 0.0, 0.0, 180.00);
	//	3 ворота, 2 крыша,	4 вывеска
	//SetDynamicObjectMaterial(tmpobjid, 4, 3925, "weemap", "Bow_Abattoir_Conc2", 0xFFFFFFFF);
	//SetDynamicObjectMaterial(tmpobjid, 5, 8675, "wddngchpl02", "shingles6", 0xFFFFFFFF);	
	//SetDynamicObjectMaterial(tmpobjid, 6, 8675, "wddngchpl02", "shingles6", 0xFFFFFFFF);
	//SetDynamicObjectMaterial(tmpobjid, 8, 18757, "vcinteriors", "dts_elevator_carpet3", -1);
	//CreateDynamicObject(11245, 1226.681, -1298.697, 18.08, 0.0, 0.0, -180.0);
	CreateDynamicObject(991, 1245.762, -1315.462, 13.600, 0.0, 0.0, 270.2);
	CreateDynamicObject(991, 1245.793, -1322.082, 13.600, 0.0, 0.0, 270.2);
	CreateDynamicObject(991, 1245.823, -1328.702, 13.600, 0.0, 0.0, 270.2);
	CreateDynamicObject(991, 1245.852, -1335.322, 13.600, 0.0, 0.0, 270.2);
	CreateDynamicObject(991, 1245.882, -1341.989, 13.600, 0.0, 0.0, 270.2);
	CreateDynamicObject(991, 1245.901, -1348.650, 13.600, 0.0, 0.0, 270.2);
	CreateDynamicObject(991, 1242.584, -1351.982, 13.569, 0.0, 0.0, 180.0);
	CreateDynamicObject(991, 1239.261, -1351.982, 13.569, 0.0, 0.0, 180.0);
	CreateDynamicObject(991, 1232.681, -1351.982, 13.569, 0.0, 0.0, 180.0);
	CreateDynamicObject(991, 1226.010, -1351.982, 13.569, 0.0, 0.0, 180.0);
	CreateDynamicObject(991, 1219.339, -1351.982, 13.569, 0.0, 0.0, 180.0);

	CreateDynamicObject(991, 1226.130, -1290.925, 13.569, 0.0, 0.0, 00.00);
	CreateDynamicObject(991, 1219.469, -1290.925, 13.569, 0.0, 0.0, 00.00);

	CreateDynamicObject(970, 1245.847, -1354.118, 12.870, 0.0, 0.0, -90.0);
	CreateDynamicObject(970, 1245.847, -1358.288, 12.870, 0.0, 0.0, -90.0);
	CreateDynamicObject(970, 1245.847, -1362.458, 12.870, 0.0, 0.0, -90.0);
	CreateDynamicObject(970, 1245.847, -1366.628, 12.870, 0.0, 0.0, -90.0);
	CreateDynamicObject(970, 1245.847, -1370.798, 12.870, 0.0, 0.0, -90.0);
	//CreateDynamicObject(970, 1245.847, -1374.978, 12.870, 0.0, 0.0, -90.0);
	//CreateDynamicObject(970, 1245.847, -1379.148, 12.870, 0.0, 0.0, -90.0);
	CreateDynamicObject(970, 1245.847, -1382.727, 12.870, 0.0, 0.0, -90.0);

	CreateDynamicObject(970, 1215.916, -1354.100, 12.870, 0.0, 0.0, -90.0);	
	//CreateDynamicObject(970, 1215.916, -1358.270, 12.870, 0.0, 0.0, -90.0);	
	//CreateDynamicObject(970, 1215.916, -1362.440, 12.870, 0.0, 0.0, -90.0);
	CreateDynamicObject(970, 1216.0, -1366.339, 12.870, 0.0, 0.0, -90.0);
	CreateDynamicObject(970, 1216.0, -1370.489, 12.870, 0.0, 0.0, -90.0);
	CreateDynamicObject(970, 1216.0, -1374.639, 12.870, 0.0, 0.0, -90.0);
	CreateDynamicObject(970, 1216.0, -1378.809, 12.870, 0.0, 0.0, -90.0);
	CreateDynamicObject(970, 1216.0, -1382.979, 12.870, 0.0, 0.0, -90.0);

	CreateDynamicObject(970, 1243.768, -1384.816, 12.87, 0.0, 0.0, -180.0);
	CreateDynamicObject(970, 1239.598, -1384.816, 12.87, 0.0, 0.0, -180.0);
	CreateDynamicObject(970, 1235.428, -1384.816, 12.87, 0.0, 0.0, -180.0);
	CreateDynamicObject(970, 1231.258, -1384.816, 12.87, 0.0, 0.0, -180.0);
	//CreateDynamicObject(970, 1227.088, -1384.816, 12.87, 0.0, 0.0, -180.0);
	//CreateDynamicObject(970, 1222.918, -1384.816, 12.87, 0.0, 0.0, -180.0);
	CreateDynamicObject(970, 1218.087, -1385.036, 12.87, 0.0, 0.0, -180.0);

	//---
	CreateDynamicObject(869,1304.900,-1707.400,13.000,0.000,0.000,89.500);
	CreateDynamicObject(869,1304.900,-1712.000,13.000,0.000,0.000,297.4950000);
	CreateDynamicObject(869,1305.100,-1716.600,13.000,0.000,0.000,89.4950000);
	CreateDynamicObject(869,1304.900,-1721.400,13.000,0.000,0.000,40.000);
	CreateDynamicObject(869,1305.000,-1726.300,13.000,0.00,0.00,269.9960000);
	CreateDynamicObject(869,1305.000,-1730.400,13.000,0.00,0.00,269.9950000);
	CreateDynamicObject(869,1305.100,-1734.600,13.000,0.00,0.00,269.9950000);
	CreateDynamicObject(869,1305.000,-1739.200,13.000,0.00,0.00,89.9950000);
	CreateDynamicObject(869,1305.200,-1743.400,13.000,0.00,0.00,89.9950000);
	CreateDynamicObject(869,1305.100,-1747.700,13.000,0.00,0.00,129.9950000);
	CreateDynamicObject(869,1305.200,-1752.000,13.000,0.00,0.00,59.990);
	CreateDynamicObject(869,1305.200,-1756.600,13.000,0.00,0.00,99.9850000);
	CreateDynamicObject(869,1305.300,-1761.000,13.000,0.00,0.00,69.9810000);
	CreateDynamicObject(869,1305.400,-1764.500,13.000,0.00,0.00,69.9770000);
	CreateDynamicObject(869,1305.300,-1768.500,13.000,0.00,0.00,89.9770000);
	CreateDynamicObject(869,1305.400,-1772.600,13.000,0.00,0.00,89.9730000);
	CreateDynamicObject(869,1305.400,-1776.800,13.000,0.00,0.00,89.9730000);
	CreateDynamicObject(869,1305.500,-1780.600,13.000,0.00,0.00,89.9730000);
	CreateDynamicObject(869,1305.300,-1784.700,13.000,0.00,0.00,69.9730000);
	CreateDynamicObject(869,1305.400,-1788.800,13.000,0.00,0.00,109.9720000);
	CreateDynamicObject(869,1305.400,-1792.900,13.000,0.00,0.00,109.9680000);
	CreateDynamicObject(869,1305.500,-1797.800,13.000,0.00,0.00,89.9670000);
	CreateDynamicObject(869,1305.500,-1802.800,13.000,0.00,0.00,289.9670000);
	CreateDynamicObject(869,1305.500,-1808.100,13.000,0.00,0.00,289.9620000);
	CreateDynamicObject(869,1305.400,-1812.600,13.000,0.00,0.00,255.9620000);
	CreateDynamicObject(869,1305.300,-1817.000,13.000,0.00,0.00,255.9590000);
	CreateDynamicObject(869,1305.300,-1821.600,13.000,0.00,0.00,277.9590000);
	CreateDynamicObject(869,1305.200,-1825.700,13.000,0.00,0.00,265.9540000);
	CreateDynamicObject(869,1305.200,-1830.00,13.000,0.00,0.00,85.9520000);
	CreateDynamicObject(869,1305.200,-1833.700,13.000,0.00,0.00,85.9460000);
	CreateDynamicObject(869,1305.400,-1837.700,13.000,0.00,0.00,265.9460000);
	CreateDynamicObject(869,1305.100,-1841.700,13.000,0.00,0.00,265.9460000);
	CreateDynamicObject(869,1304.900,-1703.700,13.000,0.00,0.00,0.00);
	CreateDynamicObject(869,1305.000,-1700.200,13.000,0.00,0.00,0.00);
	CreateDynamicObject(869,1304.900,-1696.500,13.000,0.00,0.00,90.00);
	CreateDynamicObject(869,1304.900,-1692.500,13.000,0.00,0.00,76.000);
	CreateDynamicObject(869,1305.200,-1687.900,13.000,0.00,0.00,115.9980000);

	// Ограждение возле Мэрии ЛС
	/*CreateDynamicObject(994, 1453.97742, -1742.82983, 13.19220, 0.0, 0.0, 0.0); // Кривые ограждения
	CreateDynamicObject(994, 1462.97742, -1742.82983, 13.19220, 0.0, 0.0, 0.0);
	CreateDynamicObject(994, 1471.97742, -1742.82983, 13.19220, 0.0, 0.0, 0.0);
	CreateDynamicObject(994, 1480.97742, -1742.82983, 13.19220, 0.0, 0.0, 0.0);
	CreateDynamicObject(994, 1489.97742, -1742.82983, 13.19220, 0.0, 0.0, 0.0);
	CreateDynamicObject(994, 1498.97742, -1742.82983, 13.19220, 0.0, 0.0, 0.0);
	CreateDynamicObject(994, 1507.97742, -1742.82983, 13.19220, 0.0, 0.0, 0.0);*/

	// Парковка автобусов на автовокзале ЛС
	CreateDynamicObject(19121, 1260.16052, -1842.24609, 13.06000, 0.0, 0.0, 0.0);
	CreateDynamicObject(19121, 1279.95593, -1842.24670, 13.06000, 0.0, 0.0, 0.0);
	CreateDynamicObject(982, 1287.45837, -1829.43469, 13.20000, 0.0, 0.0, 0.0);
	CreateDynamicObject(983, 1284.24792, -1842.26550, 13.20000, 0.0, 0.0, 90.0);
	CreateDynamicObject(982, 1287.45825, -1803.83618, 13.20000, 0.0, 0.0, 0.0);
	CreateDynamicObject(982, 1274.65149, -1791.05762, 13.20000, 0.0, 0.0, 90.0);
	CreateDynamicObject(982, 1245.02515, -1842.27563, 13.20000, 0.0, 0.0, 90.0);
	CreateDynamicObject(983, 1229.04651, -1842.24512, 13.20000, 0.0, 0.0, 90.0);
	CreateDynamicObject(19121, 1223.73816, -1842.21008, 13.06000, 0.0, 0.0, 0.0);
	CreateDynamicObject(19121, 1203.63660, -1842.29846, 13.06000, 0.0, 0.0, 0.0);
	CreateDynamicObject(982, 1189.95605, -1829.44531, 13.20000, 0.0, 0.0, 0.0);
	CreateDynamicObject(983, 1189.94751, -1813.46643, 13.20000, 0.0, 0.0, 0.0);
	CreateDynamicObject(984, 1196.35803, -1842.25220, 13.15000, 0.0, 0.0, 90.0);

	// Товарный склад (внутри)
	CreateDynamicObject(5269, 2151.27319, -2243.83325, 14.61720,   0.00000, 0.00000, 44.17143);
	CreateDynamicObject(19448, 2158.92480, -2247.58472, 13.39310,   0.00000, 90.00000, 45.00000);
	CreateDynamicObject(14407, 2158.21338, -2252.26929, 10.17910,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(19356, 2154.40991, -2243.05566, 13.39310,   0.00000, 90.00000, 45.00000);
	CreateDynamicObject(19448, 2159.15161, -2238.51807, 13.39310,   0.00000, 90.00000, 135.00000);
	CreateDynamicObject(19456, 2160.00366, -2239.47852, 11.60000,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(19456, 2159.98999, -2246.41113, 11.60000,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(14407, 2155.41040, -2249.46289, 10.17910,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(19364, 2162.14258, -2250.93994, 11.60000,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(19456, 2157.61621, -2248.55713, 11.60000,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(1438, 2163.42236, -2251.28174, 12.29360,   0.00000, 0.00000, 51.12225);
	CreateDynamicObject(1431, 2162.05884, -2236.01563, 13.98340,   0.00000, 0.00000, 156.00000);
	CreateDynamicObject(1431, 2160.87451, -2252.83179, 12.84200,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(5262, 2144.85815, -2248.80640, 15.18850,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(5269, 2149.76343, -2245.35718, 14.61720,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(5261, 2157.37304, -2235.65429, 14.50000, 0.00000, 0.0, 45.0);
	CreateDynamicObject(5261, 2156.00317, -2234.26807, 14.60100,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(5269, 2151.55981, -2242.21094, 14.51720,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(5269, 2150.10425, -2240.75562, 14.51720,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(19364, 2162.15503, -2234.94165, 11.60000,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(19425, 2162.12549, -2248.72583, 13.34000,   -34.00000, 0.00000, 135.00000);
	CreateDynamicObject(19425, 2159.91797, -2246.51245, 13.34000,   -34.00000, 0.00000, 135.00000);
	CreateDynamicObject(19425, 2157.70386, -2244.30103, 13.34000,   -34.00000, 0.00000, 135.00000);
	CreateDynamicObject(19425, 2157.78882, -2241.74780, 13.34000,   -34.00000, 0.00000, 45.00000);
	CreateDynamicObject(19425, 2160.00098, -2239.52417, 13.34000,   -34.00000, 0.00000, 45.00000);
	CreateDynamicObject(19425, 2162.22314, -2237.31812, 13.34000,   -34.00000, 0.00000, 45.00000);
	CreateDynamicObject(3631, 2151.66357, -2242.11548, 17.40000,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(3761, 2168.90698, -2261.13647, 14.30810,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(925, 2173.31421, -2246.41235, 13.24170,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(3761, 2168.79321, -2247.47705, 14.30810,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(3630, 2129.06616, -2281.61523, 15.27790,   0.00000, 0.00000, 315.00000);
	CreateDynamicObject(5261, 2122.11963, -2274.69238, 14.04300,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(3630, 2135.94824, -2288.47485, 15.27790,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(18260, 2146.08081, -2283.09814, 15.36160,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(3799, 2131.35791, -2261.31885, 13.64340,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19857, 2132.21021, -2277.70874, 20.80000,   0.00000, 0.00000, 69.00000);
	CreateDynamicObject(19857, 2120.15479, -2274.65186, 20.87260,   0.00000, 0.00000, 136.00000);
	CreateDynamicObject(3799, 2140.28809, -2286.22192, 13.64340,   0.00000, 0.00000, 98.00000);
	CreateDynamicObject(3799, 2128.36328, -2263.96362, 13.64340,   0.00000, 0.00000, 149.00000);
	CreateDynamicObject(8613, 2140.87622, -2275.43750, 16.30000,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(3632, 2155.33643, -2240.36768, 13.90000,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(1421, 2154.64355, -2246.85645, 13.01520,   0.00000, 0.00000, 226.40950);
	CreateDynamicObject(1438, 2153.31372, -2243.17334, 13.48340,   0.00000, 0.00000, 280.00000);
	CreateDynamicObject(3632, 2154.78833, -2240.85791, 13.90000,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(3799, 2158.18604, -2269.76904, 12.14340,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(3799, 2155.52807, -2271.57910, 12.14340, 0.0, 0.0, 29.00000);
	CreateDynamicObject(3799, 2157.00366, -2271.16918, 14.34339, 0.0, 0.0, 120.00000);
	CreateDynamicObject(3631, 2163.17627, -2266.93555, 16.29450,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(19279, 2132.86255, -2278.18091, 22.54420,   280.00000, 0.00000, 315.00000);
	CreateDynamicObject(939, 2134.62524, -2256.80688, 14.66620,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(942, 2138.43604, -2253.04443, 14.66620,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(1441, 2135.54810, -2260.52686, 12.89950,   0.00000, 0.00000, 120.00000);
	CreateDynamicObject(933, 2171.25757, -2247.59546, 12.33183,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3631, 2154.65674, -2236.17603, 17.40000,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(3798, 2148.22192, -2246.78662, 14.65000,   0.00000, 0.00000, 45.00000);

	new objmat;
	objmat = CreateDynamicObject(19447, 2166.74414, -2245.99683, 14.97000,   0.00000, 0.00000, 135.00000), SetDynamicObjectMaterial(objmat, 0, 18646, "MatColours", "green", 0x10FFFFFF);
	objmat = CreateDynamicObject(19447, 2160.35449, -2239.71875, 16.34690,   0.00000, 0.00000, 135.00000), SetDynamicObjectMaterial(objmat, 0, 18646, "MatColours", "green", 0x10FFFFFF);
	objmat = CreateDynamicObject(19447, 2164.40625, -2243.66187, 14.97000,   0.00000, 0.00000, 135.00000), SetDynamicObjectMaterial(objmat, 0, 18646, "MatColours", "green", 0x10FFFFFF);
	objmat = CreateDynamicObject(19447, 2163.45508, -2242.66650, 14.97000,   0.00000, 0.00000, 135.00000), SetDynamicObjectMaterial(objmat, 0, 18646, "MatColours", "green", 0x10FFFFFF);
	objmat = CreateDynamicObject(19447, 2161.11230, -2240.26758, 14.97000,   0.00000, 0.00000, 135.00000), SetDynamicObjectMaterial(objmat, 0, 18646, "MatColours", "green", 0x10FFFFFF);
	objmat = CreateDynamicObject(19443, 2160.51074, -2246.56616, 15.97000,   180.000, 180.000, 225.00000), SetDynamicObjectMaterial(objmat, 0, 18646, "MatColours", "green", 0x10FFFFFF);	
	objmat = CreateDynamicObject(19443, 2157.80615, -2242.84497, 15.97000,   180.000, 180.000, 315.00000), SetDynamicObjectMaterial(objmat, 0, 18646, "MatColours", "green", 0x10FFFFFF);
	objmat = CreateDynamicObject(19447, 2167.16470, -2238.36387, 14.97000,   0.00000, 0.00000, 45.0), SetDynamicObjectMaterial(objmat, 0, 18646, "MatColours", "green", 0x10FFFFFF);
	
	//	Товарный склад	(на улице)	
	CreateDynamicObject(3626, 2158.538, -2301.196, 13.55, 0.0, 0.0, 135.0);
	CreateDynamicObject(2971, 2154.643, -2296.097, 12.40, 0.0, 0.0, 0.0);
	CreateDynamicObject(1421, 2149.058, -2287.766, 14.53, 0.0, 0.0, 52.5);
	CreateDynamicObject(1431, 2150.765, -2285.669, 14.30, 0.0, 0.0, 17.5);
	CreateDynamicObject(14410, 2202.71558, -2280.74829, 10.44, 0.0, 0.0, 225.0);
	CreateDynamicObject(19365, 2202.54834, -2283.57813, 12.0, 0.0, 0.0, 45.0);
	CreateDynamicObject(3627, 2163.85229, -2323.98145, 15.78630, 360.0, -360.0, -136.0);
	CreateDynamicObject(8614, 2221.37549, -2290.27368, 12.5, 0.0, 0.0, 45.0);
	CreateDynamicObject(8572, 2231.48950, -2280.31299, 12.5, 0.0, 0.0, 45.0);
	CreateDynamicObject(1271, 2230.216, -2283.014, 12.916, 0.0, 0.0, 34.0);	// ящик под деревяшкой возле вагона
	CreateDynamicObject(1271, 2229.397, -2282.398, 12.906, 0.0, 0.0, 66.7);	// ящик под деревяшкой возле вагона
	
	// Товарный склад (кабинет Дерека)
	CreateDynamicObject(3034, 2130.08838, -2275.53247, 21.50000,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(3034, 2126.55908, -2271.98901, 21.50000,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(3034, 2129.94165, -2275.84912, 21.50000,   0.00000, 0.00000, 315.00000);
	CreateDynamicObject(3034, 2126.23047, -2272.16406, 21.50000,   0.00000, 0.00000, 315.00000);
	CreateDynamicObject(2063, 2133.58423, -2281.56641, 20.60000,   0.00000, 0.00000, 228.00000);
	CreateDynamicObject(2063, 2131.54956, -2283.45093, 20.60000,   0.00000, 0.00000, 218.00000);
	CreateDynamicObject(2066, 2122.45679, -2275.87769, 19.68760,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(2150, 2123.76733, -2269.82031, 20.39830,   0.00000, 0.00000, 315.00000);
	CreateDynamicObject(2173, 2129.80933, -2276.45947, 19.70000,   0.00000, 0.00000, 315.00000);
	CreateDynamicObject(2204, 2129.41919, -2283.06494, 19.66740,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(2205, 2125.00464, -2274.07007, 19.61740,   0.00000, 0.00000, 225.00000);
	CreateDynamicObject(2244, 2124.88306, -2271.57007, 20.43880,   0.00000, 0.00000, 265.00000);
	CreateDynamicObject(2286, 2125.28638, -2279.26294, 21.71970,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(2310, 2129.97729, -2276.93945, 20.08370,   0.00000, 0.00000, 222.00000);
	CreateDynamicObject(2315, 2125.35815, -2272.12964, 19.67560,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(2332, 2121.20386, -2275.69385, 20.68971,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(2417, 2120.54956, -2270.76807, 19.51200,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(2419, 2119.11987, -2272.34692, 19.51200,   0.00000, 0.00000, 47.00000);
	CreateDynamicObject(2421, 2119.51440, -2271.61743, 20.42610,   0.00000, 0.00000, 62.00000);
	CreateDynamicObject(2571, 2127.34424, -2279.39502, 19.65000,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(2576, 2127.12329, -2273.74731, 19.58540,   0.00000, 0.00000, 315.00000);
	CreateDynamicObject(2597, 2126.32593, -2272.98730, 20.24040,   0.00000, 0.00000, 265.00000);
	CreateDynamicObject(2609, 2127.11304, -2273.57837, 20.34040,   0.00000, 0.00000, 316.00000);
	CreateDynamicObject(2685, 2123.87695, -2269.85010, 20.94040,   0.00000, 0.00000, 315.00000);
	CreateDynamicObject(2649, 2119.85278, -2272.28564, 23.30000,   180.00000, 0.00000, 45.00000);
	CreateDynamicObject(2690, 2121.07666, -2270.10132, 20.03040,   0.00000, 0.00000, 69.00000);
	CreateDynamicObject(2811, 2127.26367, -2280.80444, 19.62390,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(2813, 2128.73975, -2281.97998, 20.42390,   0.00000, 0.00000, 157.00000);
	CreateDynamicObject(2825, 2125.73950, -2278.76099, 20.11880,   0.00000, 0.00000, 69.00000);
	CreateDynamicObject(2828, 2125.14941, -2274.26074, 20.55180,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(2891, 2122.53809, -2269.11572, 20.43010,   0.00000, 0.00000, -69.00000);
	CreateDynamicObject(2833, 2126.20972, -2275.50830, 19.68320,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(2894, 2124.07300, -2275.05811, 20.55000,   0.00000, 0.00000, 207.00000);
	CreateDynamicObject(2921, 2134.88501, -2280.70239, 23.10000,   0.00000, 0.00000, 15.00000);
	CreateDynamicObject(2926, 2133.43018, -2281.46704, 20.05000,   0.00000, 0.00000, 27.00000);
	CreateDynamicObject(2925, 2131.61548, -2283.21069, 21.13000,   0.00000, 180.00000, 40.00000);
	CreateDynamicObject(2966, 2124.70532, -2274.02319, 20.58200,   0.00000, 0.00000, -84.00000);
	CreateDynamicObject(2969, 2133.90698, -2281.10449, 21.08000,   0.00000, 0.00000, 54.00000);
	CreateDynamicObject(2986, 2129.23315, -2278.44263, 23.80000,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(2418, 2121.80200, -2269.83472, 19.51200,   0.00000, 0.00000, 41.00000);
	CreateDynamicObject(2718, 2121.79932, -2269.04346, 22.09040,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(1714, 2123.61426, -2273.70190, 19.67320,   0.00000, 0.00000, 45.00000);
	CreateDynamicObject(19582, 2124.33228, -2274.36768, 20.58900,   0.00000, 0.00000, 142.00000);
	CreateDynamicObject(11744, 2124.31738, -2274.37085, 20.57250,   0.00000, 0.00000, 0.00000);	

	// Los Santos Prison
	CreateDynamicObject(19794, 1787.13281, -1565.67969, 11.96880, 0.0, 0.0, 0.0);// Платформа
	CreateDynamicObject(11714, 1761.56323, -1561.62927, 9.79010, 0.0, 0.0, 90.0);// Дверь в проходе
	CreateDynamicObject(11714, 1781.28210, -1539.46826, 10.10000, 0.0, 0.0, 8.0);// Дверь в проходе

	// Los Santos
	// Агентство недвижимости ЛС (exterior)
	CreateDynamicObject(18755, 1786.98, -1300.78, 14.25, 0.00, 0.00, 270.00);
	CreateDynamicObject(18757, 1786.95, -1300.76, 14.25, 0.00, 0.00, 270.00);
	CreateDynamicObject(18757, 1784.96, -1300.76, 14.25, 0.00, 0.00, 270.00);
	CreateDynamicObject(18758, 1781.03, -1301.14, 14.25, 0.00, 0.00, 223.78);
	CreateDynamicObject(18758, 1794.89, -1300.96, 14.25, 0.00, 0.00, 308.88);
	CreateDynamicObject(18758, 1784.66, -1301.14, 14.25, 0.00, 0.00, 258.70);
	CreateDynamicObject(18758, 1787.10, -1300.80, 14.25, 0.00, 0.00, 270.00);
	CreateDynamicObject(18758, 1795.08, -1300.81, 14.25, 0.00, 0.00, 270.00);
	CreateDynamicObject(18758, 1797.44, -1299.62, 14.25, 0.00, 0.00, 287.06);

	// Автомастерская (exterior)
	CreateDynamicObject(1491, 982.19, -1546.31, 21.07, 0.00, 0.00, 0.00);
	CreateDynamicObject(3851, 976.56, -1559.74, 25.14, 0.00, 270.00, 90.00);
	CreateDynamicObject(3851, 976.56, -1555.75, 25.14, 0.00, 270.00, 90.00);
	CreateDynamicObject(3851, 976.56, -1551.76, 25.14, 0.00, 270.00, 90.00);
	CreateDynamicObject(3851, 976.56, -1547.76, 25.14, 0.00, 270.00, 90.00);
	CreateDynamicObject(3851, 965.25, -1555.75, 25.14, 0.00, 270.00, 90.00);
	CreateDynamicObject(3851, 965.25, -1551.76, 25.14, 0.00, 270.00, 90.00);
	CreateDynamicObject(3851, 965.25, -1547.76, 25.14, 0.00, 270.00, 90.00);
	CreateDynamicObject(10282, 981.02, -1524.36, 13.57, 0.00, 0.00, 0.00);
	CreateDynamicObject(16500, 977.03, -1527.29, 14.55, 0.00, 0.00, 0.00);
	CreateDynamicObject(16500, 977.03, -1522.30, 14.55, 0.00, 0.00, 0.00);
	CreateDynamicObject(16500, 984.99, -1527.29, 14.56, 0.00, 0.00, 180.00);
	CreateDynamicObject(16500, 984.98, -1522.29, 14.55, 0.00, 0.00, 179.99);
	CreateDynamicObject(11292, 994.36, -1524.73, 13.85, 0.00, 0.00, 270.00);
	CreateDynamicObject(10282, 962.89, -1520.27, 13.57, 0.00, 0.00, 0.00);
	CreateDynamicObject(939, 967.77, -1522.60, 15.00, 0.00, 0.00, 90.00);
	CreateDynamicObject(16151, 986.36, -1554.02, 20.84, 0.00, 0.00, 0.00);
	CreateDynamicObject(1432, 980.20, -1556.83, 20.51, 0.00, 0.00, 0.00);
	CreateDynamicObject(1432, 979.07, -1551.39, 20.51, 0.00, 0.00, 0.00);
	CreateDynamicObject(1432, 976.02, -1553.99, 20.51, 0.00, 0.00, 0.00);
	CreateDynamicObject(1432, 973.27, -1556.98, 20.50, 0.00, 0.00, 0.00);
	CreateDynamicObject(1432, 971.27, -1551.75, 20.50, 0.00, 0.00, 0.00);
	CreateDynamicObject(1432, 967.94, -1554.65, 20.49, 0.00, 0.00, 0.00);
	CreateDynamicObject(1432, 964.35, -1556.69, 20.49, 0.00, 0.00, 0.00);
	CreateDynamicObject(1432, 964.29, -1552.07, 20.49, 0.00, 0.00, 0.00);
	CreateDynamicObject(3088, 981.83, -1546.23, 12.49, 0.00, 0.00, 0.00);
	CreateDynamicObject(3851, 987.87, -1547.76, 25.14, 0.00, 270.00, 90.00);
	CreateDynamicObject(3851, 987.87, -1551.76, 25.14, 0.00, 270.00, 90.00);
	CreateDynamicObject(3851, 987.87, -1559.74, 25.14, 0.00, 270.00, 90.00);
	CreateDynamicObject(3851, 987.87, -1555.75, 25.14, 0.00, 270.00, 90.00);
	CreateDynamicObject(3851, 965.25, -1559.74, 25.14, 0.00, 270.00, 90.00);
	CreateDynamicObject(3851, 987.87, -1561.30, 22.83, 0.00, 180.00, 90.00);
	CreateDynamicObject(3851, 965.25, -1561.28, 22.83, 0.00, 180.00, 90.00);
	CreateDynamicObject(3851, 976.56, -1561.30, 22.83, 0.00, 180.00, 90.00);
	CreateDynamicObject(3851, 989.34, -1546.31, 22.83, 0.00, 180.00, 90.00);
	CreateDynamicObject(3851, 965.25, -1546.31, 22.83, 0.00, 180.00, 90.00);
	CreateDynamicObject(3851, 976.56, -1546.31, 22.83, 0.00, 180.00, 90.00);
	CreateDynamicObject(6976, 965.81, -1542.68, 12.39, 0.00, 0.00, 0.00);
	CreateDynamicObject(970, 986.92, -1545.04, 21.73, 0.00, 0.00, 0.00);
	CreateDynamicObject(1473, 982.97, -1546.28, 24.47, 66.00, 0.00, 180.00);
	CreateDynamicObject(1472, 982.94, -1546.29, 20.76, 0.00, 0.00, 0.00);
	CreateDynamicObject(759, 985.78, -1548.29, 20.84, 3.14, 0.00, 1.62);
	CreateDynamicObject(970, 979.82, -1545.04, 21.73, 0.00, 0.00, 0.00);
	CreateDynamicObject(970, 975.65, -1545.04, 21.73, 0.00, 0.00, 0.00);
	CreateDynamicObject(970, 971.49, -1545.04, 21.73, 0.00, 0.00, 0.00);
	CreateDynamicObject(970, 967.33, -1545.04, 21.73, 0.00, 0.00, 0.00);
	CreateDynamicObject(970, 963.17, -1545.04, 21.73, 0.00, 0.00, 0.00);
	CreateDynamicObject(970, 961.09, -1545.04, 21.73, 0.00, 0.00, 0.00);
	CreateDynamicObject(2931, 981.81, -1522.00, 12.03, 330.00, 0.00, 0.00);
	CreateDynamicObject(2931, 979.86, -1522.00, 12.03, 330.00, 0.00, 0.00);
	CreateDynamicObject(10281, 995.98, -1533.10, 20.36, 0.00, 0.00, 270.00);
	CreateDynamicObject(2931, 981.81, -1525.18, 11.85, 350.00, 0.00, 0.00);
	CreateDynamicObject(2931, 979.85, -1525.18, 11.85, 350.00, 0.00, 0.00);
	CreateDynamicObject(2931, 962.36, -1522.00, 12.03, 330.00, 0.00, 0.00);
	CreateDynamicObject(2931, 964.31, -1522.00, 12.03, 330.00, 0.00, 0.00);
	CreateDynamicObject(2931, 962.35, -1525.18, 11.85, 350.00, 0.00, 0.00);
	CreateDynamicObject(2931, 964.31, -1525.18, 11.85, 350.00, 0.00, 0.00);
	CreateDynamicObject(16500, 958.90, -1522.30, 14.55, 0.00, 0.00, 0.00);
	CreateDynamicObject(16500, 958.90, -1527.29, 14.55, 0.00, 0.00, 0.00);
	CreateDynamicObject(935, 975.23, -1525.83, 13.11, 0.00, 0.00, 90.00);
	CreateDynamicObject(935, 976.42, -1525.48, 13.11, 0.00, 0.00, 90.00);
	CreateDynamicObject(942, 975.01, -1522.61, 15.00, 0.00, 0.00, 102.00);
	CreateDynamicObject(935, 975.98, -1526.27, 13.11, 0.00, 0.00, 90.00);
	CreateDynamicObject(944, 976.07, -1528.26, 13.31, 0.00, 0.00, 90.00);

	// Автопарковка 4
	CreateDynamicObject(3115,758.35,-1436.8,12.2,-0.2,0.15,360.0);// Площадка для автошколы
	CreateDynamicObject(982,760.63,-1446.1,13.24,0.15,0.0,90.0);// Забор возле АШ
	CreateDynamicObject(983,773.47,-1442.9,13.2,0.0,0.0,360.0);// Забор возле АШ
	CreateDynamicObject(984,747.83,-1434.4,13.14,0.0,0.0,360.0);// Забор возле АШ
	CreateDynamicObject(1359,747.5,-1442.9,13.2,0.0,0.0,270.0);// Корзина возле АШ

// Las Venturas
	// Автомастерская
	CreateDynamicObject(13295,1101.97265625,2379.13867188,16.24542618,0.0,0.0,270.000); //object(ce_terminal1) (1)
	CreateDynamicObject(16500,1105.72021484,2380.96142578,9.66455460,0.0,80.0,270.000); //object(cn2_savgardr1_) (35)
	CreateDynamicObject(16500,1105.72277832,2377.03417969,10.00753593,0.0,90.0,270.000); //object(cn2_savgardr1_) (36)
	CreateDynamicObject(16500,1109.28137207,2380.95751953,9.66455460,0.0,79.99694824,270.000); //object(cn2_savgardr1_) (37)
	CreateDynamicObject(16500,1109.29223633,2377.01245117,10.00753593,0.0,90.0,270.000); //object(cn2_savgardr1_) (38)
	CreateDynamicObject(3066,1098.15258789,2377.19555664,10.69257832,0.0,0.0,90.000); //object(ammotrn_obj) (1)
	CreateDynamicObject(3529,1091.85083008,2377.89746094,13.26578140,0.0,0.0,0.000); //object(vgsn_constrbeam) (1)
	CreateDynamicObject(16500,1105.72717285,2373.12280273,9.66455460,0.0,79.99694824,90.000); //object(cn2_savgardr1_) (39)
	CreateDynamicObject(16500,1109.28955078,2373.08569336,9.66455460,0.0,79.99145508,90.000); //object(cn2_savgardr1_) (40)
	CreateDynamicObject(1464,1113.71582031,2366.93188477,10.98489761,0.0,0.0,180.000); //object(dyn_scaffold_3) (1)
	CreateDynamicObject(1464,1117.71520996,2362.64526367,10.98489761,0.0,0.0,90.000); //object(dyn_scaffold_3) (2)
	CreateDynamicObject(3851,1096.81860352,2365.12304688,11.82031250,0.0,0.0,270.000); //object(carshowwin_sfsx) (9)
	CreateDynamicObject(3851,1093.96972656,2365.38793945,11.82031250,0.0,0.0,270.000); //object(carshowwin_sfsx) (10)
	CreateDynamicObject(3851,1106.79125977,2353.87060547,11.82031250,0.0,0.0,90.000); //object(carshowwin_sfsx) (11)
	CreateDynamicObject(17951,1087.13647461,2362.07275391,11.85078239,0.0,0.0,0.000); //object(cjgaragedoor) (1)
	CreateDynamicObject(17951,1094.90332031,2354.20312500,11.59722233,0.0,0.0,90.000); //object(cjgaragedoor) (2)
	CreateDynamicObject(17951,1104.89245605,2366.02563477,11.59722233,0.0,0.0,90.000); //object(cjgaragedoor) (3)
	CreateDynamicObject(1491,1116.84167480,2357.55566406,9.82031250,0.0,0.0,90.000); //object(gen_doorint01) (2)
	CreateDynamicObject(2931,1092.04248047,2360.09228516,8.82032776,349.99694824,0.0,90.000); //object(kmb_jump1) (13)
	CreateDynamicObject(2931,1092.09948730,2361.83520508,8.82032776,349.99145508,0.0,90.000); //object(kmb_jump1) (14)
	CreateDynamicObject(2931,1088.85864258,2360.08837891,9.00530910,330.0,0.0,90.000); //object(kmb_jump1) (15)
	CreateDynamicObject(2931,1088.93579102,2361.83300781,9.00530910,329.99633789,0.0,90.000); //object(kmb_jump1) (16)
	CreateDynamicObject(1215,1108.35974121,2359.79028320,10.49461842,0.0,0.0,0.000); //object(bollardlight) (1)
	CreateDynamicObject(1215,1089.00268555,2364.78320312,10.49461842,0.0,0.0,0.000); //object(bollardlight) (2)
	CreateDynamicObject(1215,1088.64587402,2355.24560547,10.49461842,0.0,0.0,0.000); //object(bollardlight) (3)
	CreateDynamicObject(1215,1116.30383301,2359.69653320,10.49461842,0.0,0.0,0.000); //object(bollardlight) (4)
	CreateDynamicObject(942,1113.58044434,2355.61352539,12.37352180,0.0,0.0,0.000); //object(cj_df_unit_2) (1)
	CreateDynamicObject(2890,1114.55737305,2400.22656250,9.82031250,0.0,0.0,0.000); //object(kmb_skip) (1)

//	Кладбище около ФК
	CreateDynamicObject(16410, -652.5, 1469.4, 14.4, 0.0, 0.0, 302.75);
	CreateDynamicObject(5777, -652.8, 1440.8, 13.2, 0.0, 0.0, 90.0);
	CreateDynamicObject(2896, -652.8, 1442.8, 13.2, 0.0, 0.0, 87.0);
	CreateDynamicObject(18235, -639.0, 1448.3, 12.6, 0.0, 0.0, 270.5);
	CreateDynamicObject(3253, -642.8, 1440.4, 12.5, 0.0, 0.0, 270.0);
	CreateDynamicObject(5777, -656.8, 1439.2, 13.2, 0.0, 0.0, 106.0);
	CreateDynamicObject(5777, -659.4, 1442.4, 12.7, 0.0, 324.25, 84.0);
	CreateDynamicObject(5777, -663.0, 1447.4, 13.2, 0.0, 0.00, 90.0);
	CreateDynamicObject(5777, -663.7, 1440.7, 13.2, 0.0, 0.00, 76.0);
	CreateDynamicObject(16281, -674.5, 1456.9, 18.0, 341.751, 0.526,272.165);
	CreateDynamicObject(1410, -631.2, 1455.3, 13.4, 0.0, 0.0, 276.0);
	CreateDynamicObject(1410, -631.6, 1460.0, 13.4, 0.0, 0.0, 275.999);
	CreateDynamicObject(1410, -632.1, 1464.7, 13.4, 0.0, 0.0, 275.999);
	CreateDynamicObject(1410, -632.5, 1469.4, 13.4, 0.0, 0.0, 275.999);

	//	объекты притона оружейников
	CreateDynamicObject(13295,-606.5999800,-495.2000100,31.0,0.0,0.0,89.500);
	CreateDynamicObject(2110,-612.0999800,-476.3999900,25.100,90.0,180.0,199.0);
	CreateDynamicObject(1764,-608.5999800,-472.2000100,24.700,0.0,0.0,18.0);
	CreateDynamicObject(941,-619.2000100,-477.1000100,25.200,0.0,0.0,8.0);
	CreateDynamicObject(941,-615.9000200,-476.7999900,25.100,0.0,0.0,350.0);
	CreateDynamicObject(1421,-619.2000100,-480.3999900,25.400,0.0,0.0,350.0);
	CreateDynamicObject(2063,-613.7000100,-478.7000100,25.600,0.0,0.0,274.0);
	CreateDynamicObject(2063,-593.500,-480.8999900,25.600,20.0,0.0,12.0);
	CreateDynamicObject(2063,-598.7000100,-480.7999900,25.600,0.0,0.0,0.0);
	CreateDynamicObject(2969,-598.5999800,-480.7999900,25.100,0.0,0.0,0.0);
	CreateDynamicObject(1431,-594.500,-471.8999900,25.200,0.0,0.0,0.0);
	CreateDynamicObject(2358,-618.9000200,-477.2000100,25.800,0.0,0.0,0.0);
	CreateDynamicObject(3017,-615.7000100,-477.2000100,25.600,0.0,0.0,350.0);
	CreateDynamicObject(2359,-615.7999900,-476.500,25.800,0.0,0.0,0.0);
	CreateDynamicObject(1299,-598.0999800,-471.1000100,25.100,0.0,0.0,0.0);
	CreateDynamicObject(1299,-600.9000200,-471.500,25.100,0.0,0.0,34.0);
	CreateDynamicObject(1299,-600.0,-471.2999900,25.100,0.0,0.0,343.9970000);

// Bay Side
	// Бензоколонка
	CreateDynamicObject(11677, -2511.20, 2337.70, 8.12, 0.00, 0.00, 90.00);
	CreateDynamicObject(11546, -2548.05, 2358.33, 3.98, 0.00, 0.00, 90.00);
	CreateDynamicObject(11547, -2531.39, 2369.43, 6.90, 0.00, 0.00, 360.0);
	CreateDynamicObject(1686, -2531.50, 2361.09, 4.10, 0.00, 0.00, 90.00);
	CreateDynamicObject(1686, -2531.50, 2366.54, 4.10, 0.00, 0.00, 90.00);

// Apea51
	// Основное
	CreateDynamicObject(19312, 191.14, 1870.04, 21.48, 0.00, 0.00, 0.00, -1, -1, -1, 500.0); // Забор
	CreateDynamicObject(976, 96.69, 1918.90, 12.61, 0.00, 270.00, 270.00); // Заслонка дырки
	CreateDynamicObject(3095, 268.48, 1884.01, 16.09, 0.00, 0.00, 0.00); // Люк для дыры в земле
	CreateDynamicObject(980, 345.38, 1797.99, 18.39, 0.00, 2.40, 215.00); // Ворота на парковку
	CreateDynamicObject(3279, 349.27, 1811.25, 16.62, 0.00, 0.00, 251.00); // Вышка
	CreateDynamicObject(3279, 267.92, 2070.00, 16.58, 0.00, 0.00, 0.00); // Вышка
	CreateDynamicObject(3279, 352.35, 2070.00, 16.58, 0.00, 0.00, 180.00); // Вышка
	CreateDynamicObject(3755, 223.48, 1995.41, 21.79, 0.00, 0.00, 90.00); // Здание с крытой парковкой
	CreateDynamicObject(3707, 356.47, 1946.81, 23.94, 0.00, 0.00, 180.00); // Здание перед ангарами
	CreateDynamicObject(16599, 291.53, 2042.40, 21.29, 0.00, 0.00, 0.00); // Башня у ВПП
	CreateDynamicObject(16327, 327.14, 2057.60, 16.55, 0.00, 0.00, 0.00); // Башня у ВПП
	CreateDynamicObject(18876, 268.651, 1884.039, -31.325, 0.0, 0.0, 0.0);// Ядерная колба внутри
	return obj;
}

CityLS_CreateObjects()
{
	//	заборчики и деревья в центре (рядом с оружейкой)
	CreateDynamicObject(617,1349.5000000,-1419.7000000,12.5000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(617,1345.0000000,-1462.7000000,12.5000000,0.0000000,0.0000000,130.0000000);
	CreateDynamicObject(617,1337.0000000,-1486.0000000,12.5000000,0.0000000,0.0000000,129.9960000);
	CreateDynamicObject(615,1322.7000000,-1509.6000000,11.7000000,0.0000000,0.0000000,0.0000000);
	CreateDynamicObject(617,1312.6000000,-1529.5000000,12.5000000,0.0000000,0.0000000,129.9960000);
	CreateDynamicObject(617,1307.3000000,-1548.0000000,12.5000000,0.0000000,0.0000000,160.0000000);
	CreateDynamicObject(615,1348.5000000,-1436.6000000,11.7000000,0.0000000,0.0000000,40.0000000);
	CreateDynamicObject(970,1308.1000000,-1553.2000000,13.0000000,0.0000000,0.0000000,262.0000000);
	CreateDynamicObject(970,1308.6600000,-1549.1000000,13.0000000,0.0000000,0.0000000,262.2460000);
	CreateDynamicObject(970,1309.2000000,-1545.0000000,13.0000000,0.0000000,0.0000000,262.5000000);
	CreateDynamicObject(970,1309.9000000,-1541.0000000,13.0000000,0.0000000,0.0000000,258.0000000);
	CreateDynamicObject(970,1311.0500000,-1537.0000000,13.0000000,0.0000000,0.0000000,250.2470000);
	CreateDynamicObject(970,1312.5000000,-1533.2000000,13.0000000,0.0000000,0.0000000,247.9970000);
	CreateDynamicObject(970,1314.0400000,-1529.4000000,13.0000000,0.0000000,0.0000000,247.9940000);
	CreateDynamicObject(970,1315.5800000,-1525.6000000,13.0000000,0.0000000,0.0000000,247.9940000);
	CreateDynamicObject(970,1317.1200000,-1521.8000000,13.0000000,0.0000000,0.0000000,247.9940000);
	CreateDynamicObject(970,1319.0000000,-1518.1500000,13.0000000,0.0000000,0.0000000,237.2440000);
	CreateDynamicObject(970,1321.2800000,-1514.7000000,13.0000000,0.0000000,0.0000000,236.2440000);
	CreateDynamicObject(970,1323.5699000,-1511.2500000,13.0000000,0.0000000,0.0000000,236.2390000);
	CreateDynamicObject(970,1325.8600000,-1507.8000000,13.0000000,0.0000000,0.0000000,236.2390000);
	CreateDynamicObject(970,1328.2000000,-1504.4000000,13.0000000,0.0000000,0.0000000,235.0000000);
	CreateDynamicObject(970,1330.5500000,-1501.0000000,13.0000000,0.0000000,0.0000000,236.0000000);
	CreateDynamicObject(970,1332.6200000,-1497.5000000,13.0000000,0.0000000,0.0000000,243.0000000);
	CreateDynamicObject(970,1334.5000000,-1493.8000000,13.0000000,0.0000000,0.0000000,242.9960000);
	CreateDynamicObject(970,1336.4000000,-1490.1000000,13.0000000,0.0000000,0.0000000,242.9960000);
	CreateDynamicObject(970,1338.2800000,-1486.4000000,13.0000000,0.0000000,0.0000000,242.9960000);
	CreateDynamicObject(970,1340.1600000,-1482.7200000,13.0000000,0.0000000,0.0000000,242.9960000);
	CreateDynamicObject(970,1342.0000000,-1479.0900000,13.0000000,0.0000000,0.0000000,242.9960000);
	CreateDynamicObject(970,1343.4000000,-1475.3000000,13.0000000,0.0000000,0.0000000,256.7460000);
	CreateDynamicObject(970,1344.3500000,-1471.3000000,13.0000000,0.0000000,0.0000000,256.7450000);
	CreateDynamicObject(970,1345.3000000,-1467.3000000,13.0000000,0.0000000,0.0000000,256.7450000);
	CreateDynamicObject(970,1346.2200000,-1463.3000000,13.0000000,0.0000000,0.0000000,257.2500000);
	CreateDynamicObject(970,1347.1600000,-1459.2300000,13.0000000,0.0000000,0.0000000,256.8000000);
	CreateDynamicObject(970,1348.1100000,-1455.2000000,13.0000000,0.0000000,0.0000000,257.0000000);
	CreateDynamicObject(970,1349.0400000,-1451.2000000,13.0000000,0.0000000,0.0000000,256.5000000);
	CreateDynamicObject(970,1349.7100000,-1447.1100000,13.0000000,0.0000000,0.0000000,264.7950000);
	CreateDynamicObject(970,1350.0400000,-1443.0000000,13.0000000,0.0000000,0.0000000,266.0420000);
	CreateDynamicObject(970,1350.3300000,-1438.9000000,13.0000000,0.0000000,0.0000000,266.0390000);
	CreateDynamicObject(970,1350.6100000,-1434.8000000,13.0000000,0.0000000,0.0000000,266.0390000);
	CreateDynamicObject(970,1350.9000000,-1430.7000000,13.0000000,0.0000000,0.0000000,266.0390000);
	CreateDynamicObject(970,1351.1801000,-1426.6000000,13.0000000,0.0000000,0.0000000,266.0390000);
	CreateDynamicObject(970,1351.4600000,-1422.5000000,13.0000000,0.0000000,0.0000000,266.0390000);
	CreateDynamicObject(970,1351.7500000,-1418.4000000,13.0000000,0.0000000,0.0000000,266.0390000);
	CreateDynamicObject(970,1304.5000000,-1552.6500000,13.0000000,0.0000000,0.0000000,261.9960000);
	CreateDynamicObject(970,1305.1000000,-1548.6000000,13.0000000,0.0000000,0.0000000,261.4960000);
	CreateDynamicObject(970,1305.6899000,-1544.5000000,13.0000000,0.0000000,0.0000000,262.2410000);
	CreateDynamicObject(970,1306.4000000,-1540.4000000,13.0000000,0.0000000,0.0000000,257.9970000);
	CreateDynamicObject(970,1307.5500000,-1536.4000000,13.0000000,0.0000000,0.0000000,249.9970000);
	CreateDynamicObject(970,1308.9900000,-1532.6000000,13.0000000,0.0000000,0.0000000,248.7440000);
	CreateDynamicObject(970,1310.4600000,-1528.8000000,13.0000000,0.0000000,0.0000000,248.7410000);
	CreateDynamicObject(970,1311.9301000,-1525.0000000,13.0000000,0.0000000,0.0000000,248.7410000);
	CreateDynamicObject(970,1313.4000000,-1521.2000000,13.0000000,0.0000000,0.0000000,248.7410000);
	CreateDynamicObject(970,1315.2500000,-1517.5000000,13.0000000,0.0000000,0.0000000,237.9910000);
	CreateDynamicObject(970,1317.4600000,-1514.1000000,13.0000000,0.0000000,0.0000000,235.9940000);
	CreateDynamicObject(970,1319.7500000,-1510.7000000,13.0000000,0.0000000,0.0000000,235.9920000);
	CreateDynamicObject(970,1322.0500000,-1507.3000000,13.0000000,0.0000000,0.0000000,235.9920000);
	CreateDynamicObject(970,1324.3500000,-1503.9000000,13.0000000,0.0000000,0.0000000,235.9920000);
	CreateDynamicObject(970,1326.6500000,-1500.5000000,13.0000000,0.0000000,0.0000000,235.9920000);
	CreateDynamicObject(970,1328.7900000,-1497.0000000,13.0000000,0.0000000,0.0000000,241.2420000);
	CreateDynamicObject(970,1330.7000000,-1493.4000000,13.0000000,0.0000000,0.0000000,242.7380000);
	CreateDynamicObject(970,1332.6000000,-1489.7100000,13.0000000,0.0000000,0.0000000,242.7370000);
	CreateDynamicObject(970,1334.5000000,-1486.0400000,13.0000000,0.0000000,0.0000000,242.4870000);
	CreateDynamicObject(970,1336.4000000,-1482.4000000,13.0000000,0.0000000,0.0000000,242.4850000);
	CreateDynamicObject(970,1338.2700000,-1478.8000000,13.0000000,0.0000000,0.0000000,242.4850000);
	CreateDynamicObject(970,1339.8500000,-1475.0000000,13.0000000,0.0000000,0.0000000,252.4850000);
	CreateDynamicObject(970,1340.9100000,-1471.0000000,13.0000000,0.0000000,0.0000000,257.4950000);
	CreateDynamicObject(970,1341.8000000,-1467.0000000,13.0000000,0.0000000,0.0000000,257.4920000);
	CreateDynamicObject(970,1342.7000000,-1463.0000000,13.0000000,0.0000000,0.0000000,257.4920000);
	CreateDynamicObject(970,1343.5800000,-1459.0000000,13.0000000,0.0000000,0.0000000,257.4920000);
	CreateDynamicObject(970,1344.4800000,-1454.9399000,13.0000000,0.0000000,0.0000000,257.4920000);
	CreateDynamicObject(970,1345.3800000,-1450.9000000,13.0000000,0.0000000,0.0000000,257.4920000);
	CreateDynamicObject(970,1346.0800000,-1446.9000000,13.0000000,0.0000000,0.0000000,262.4920000);
	CreateDynamicObject(970,1346.4600000,-1442.8000000,13.0000000,0.0000000,0.0000000,266.4910000);
	CreateDynamicObject(970,1346.7100000,-1438.7000000,13.0000000,0.0000000,0.0000000,266.4900000);
	CreateDynamicObject(970,1347.0000000,-1434.6000000,13.0000000,0.0000000,0.0000000,265.7370000);
	CreateDynamicObject(970,1347.3000000,-1430.5000000,13.0000000,0.0000000,0.0000000,265.7320000);
	CreateDynamicObject(970,1347.6000000,-1426.4000000,13.0000000,0.0000000,0.0000000,265.7320000);
	CreateDynamicObject(970,1347.9000000,-1422.4000000,13.0000000,0.0000000,0.0000000,265.7320000);
	obj = CreateDynamicObject(970,1348.1500000,-1418.5000000,13.0000000,0.0000000,0.0000000,266.7320000);
}

DivingJob_CreateObjects()
{
	CreateDynamicObject(3867, 2831.7000000,-2531.1001000,-6.5000000,0.0000000,0.0000000,283.2500000);
	CreateDynamicObject(3867, 2827.3000000,-2514.0000000,-6.5000000,0.0000000,0.0000000,286.5000000);
	CreateDynamicObject(3867, 2822.7000000,-2497.2000000,-6.5000000,0.0000000,0.0000000,284.0000000);
	CreateDynamicObject(3867, 2819.8000000,-2476.1001000,-6.5000000,0.0000000,0.0000000,269.7470000);
	CreateDynamicObject(3867, 2819.8999000,-2458.6001000,-6.5000000,0.0000000,0.0000000,269.7420000);
	CreateDynamicObject(3867, 2820.0000000,-2441.1001000,-6.5000000,0.0000000,0.0000000,269.7420000);
	CreateDynamicObject(3867, 2820.1001000,-2417.8000000,-6.5000000,0.0000000,0.0000000,269.7420000);
	obj = CreateDynamicObject(3867, 2820.2000000,-2400.2000000,-6.5000000,0.0000000,0.0000000,269.7420000);
	//CreateDynamicObject(3867, 2824.1001000,-2378.1001000,-6.5000000,0.0000000,0.0000000,258.9920000);
	//CreateDynamicObject(3867, 2828.0000000,-2360.8000000,-6.5000000,0.0000000,0.0000000,255.7420000);
	//CreateDynamicObject(3867, 2833.0000000,-2343.8000000,-6.5000000,0.0000000,0.0000000,251.4900000);
	//CreateDynamicObject(1437, 2835.2600000,-2548.3000000,-15.6000000,316.0000000,0.0000000,12.0000000);
	//obj = CreateDynamicObject(1437, 2834.3000000,-2543.7000000,-12.1500000,316.0000000,0.0000000,11.0000000);
}

News_Int_CreateObjects()
{
	//Objects////////////////////////////////////////////////////////////////////////////////////////////////////////
	new tmpobjid;
	tmpobjid = CreateDynamicObjectEx(19466,1668.540,-1645.035,1404.319,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1668.540,-1645.035,1406.255,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1666.300,-1645.035,1404.319,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19174,1669.392,-1648.268,1405.361,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_poster", 0);
	tmpobjid = CreateDynamicObjectEx(19466,1666.300,-1645.035,1406.255,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1664.060,-1645.035,1404.319,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1664.060,-1645.035,1406.255,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(2774,1660.426,-1637.582,1397.679,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -52);
	tmpobjid = CreateDynamicObjectEx(19466,1661.819,-1645.035,1404.319,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1661.819,-1645.035,1406.255,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(3850,1660.740,-1634.999,1403.890,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(2425,1666.951,-1626.827,1399.006,0.000,0.000,-68.279,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -1);
	tmpobjid = CreateDynamicObjectEx(3850,1659.541,-1637.527,1403.890,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1660.765,-1646.209,1404.319,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1660.765,-1646.209,1406.255,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(2421,1666.310,-1625.906,1399.365,0.000,0.000,-45.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -1);
	tmpobjid = CreateDynamicObjectEx(3850,1658.980,-1645.042,1403.890,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(3850,1660.740,-1631.539,1403.890,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1658.280,-1632.560,1398.920,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1660.765,-1648.370,1406.940,90.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1657.600,-1634.372,1401.534,90.000,0.000,-45.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1658.280,-1632.560,1400.849,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1660.765,-1650.520,1404.319,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1658.280,-1632.560,1402.780,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1657.600,-1634.372,1403.772,90.000,0.000,-45.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1660.765,-1650.520,1406.255,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(2774,1656.371,-1645.596,1397.679,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -52);
	tmpobjid = CreateDynamicObjectEx(19466,1658.280,-1630.320,1398.920,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1658.280,-1630.320,1400.849,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(3850,1660.740,-1628.079,1403.890,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(3850,1656.079,-1637.527,1403.890,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1655.779,-1635.060,1398.920,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1658.280,-1630.320,1402.780,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1655.779,-1635.060,1400.849,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(3850,1656.745,-1646.510,1403.890,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1655.779,-1635.060,1402.780,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1658.280,-1628.080,1402.780,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(3850,1656.745,-1649.994,1403.890,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(2774,1661.526,-1623.777,1397.679,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -52);
	tmpobjid = CreateDynamicObjectEx(19466,1653.540,-1635.060,1398.920,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(3850,1660.740,-1624.619,1403.890,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1653.540,-1635.060,1400.849,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1658.280,-1626.160,1400.849,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1653.540,-1635.060,1402.780,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1658.280,-1625.839,1402.780,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(3850,1652.619,-1637.527,1403.890,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1658.280,-1624.420,1398.920,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(3850,1655.016,-1651.723,1403.890,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1658.280,-1623.920,1400.849,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(2774,1656.326,-1654.508,1397.679,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -52);
	tmpobjid = CreateDynamicObjectEx(19466,1658.280,-1623.599,1402.780,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1651.300,-1635.060,1402.780,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(4724,1652.505,-1629.432,1399.921,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -1);
	tmpobjid = CreateDynamicObjectEx(3850,1653.293,-1651.723,1403.890,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(10008,1650.185,-1646.542,1401.680,0.000,0.000,-90.839,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "ws_metalpanel1", -8882056);
	tmpobjid = CreateDynamicObjectEx(3850,1649.170,-1637.527,1403.890,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1649.060,-1635.060,1400.849,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1649.060,-1635.060,1402.780,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(2774,1648.253,-1637.856,1395.809,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -52);
	tmpobjid = CreateDynamicObjectEx(3850,1648.361,-1639.250,1403.890,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(3850,1648.361,-1642.709,1403.890,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(3850,1648.361,-1646.169,1403.890,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1647.259,-1635.060,1398.920,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1646.819,-1635.060,1400.849,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(19466,1646.819,-1635.060,1402.780,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -6908161);
	tmpobjid = CreateDynamicObjectEx(2774,1644.447,-1654.508,1397.679,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", -52);
	tmpobjid = CreateDynamicObjectEx(19172,1644.942,-1657.465,1405.247,0.000,0.000,-180.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14489, "carlspics", "AH_landscap1", 0);
	tmpobjid = CreateDynamicObjectEx(19174,1638.781,-1646.780,1400.473,0.000,0.000,-270.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_poster", 0);
	tmpobjid = CreateDynamicObjectEx(18769,1649.051,-1625.147,1404.000,0.000,180.000,180.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, "a51", "ws_metalpanel1", 0);
	tmpobjid = CreateDynamicObjectEx(18769,1679.412,-1645.927,1404.000,0.000,180.000,180.000,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "ws_stationfloor", -1);
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, "a51", "ws_stationfloor", 0);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObjectEx(2010,1673.143,-1639.136,1397.967,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1566,1674.042,-1638.679,1399.197,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1566,1674.042,-1641.745,1399.197,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1566,1674.051,-1641.804,1399.197,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2961,1672.635,-1638.674,1399.223,0.000,0.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2641,1671.063,-1638.729,1400.053,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1726,1669.927,-1639.286,1397.912,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(14461,1672.220,-1643.851,1399.781,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1886,1673.520,-1639.179,1403.549,20.000,0.000,-45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1566,1674.051,-1644.890,1399.197,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2002,1668.823,-1638.365,1397.967,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2597,1673.650,-1645.608,1398.786,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2691,1669.375,-1636.553,1400.478,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(18075,1674.262,-1644.783,1403.426,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1726,1668.835,-1635.598,1397.912,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1569,1669.456,-1634.800,1397.907,0.000,0.000,-270.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2424,1672.400,-1647.180,1397.967,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2424,1671.469,-1647.180,1397.967,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2422,1671.411,-1647.386,1399.015,0.000,0.000,-184.320,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2816,1670.493,-1647.177,1399.011,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2424,1670.540,-1647.180,1397.967,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2233,1669.721,-1645.424,1403.352,0.000,0.000,-54.060,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2423,1669.609,-1647.180,1397.967,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2251,1669.470,-1647.329,1399.863,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1806,1671.756,-1648.518,1397.967,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1668.137,-1633.494,1397.917,0.000,0.000,-642.359,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2424,1669.540,-1648.219,1397.967,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2186,1673.422,-1649.282,1397.968,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1671.060,-1648.319,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1806,1670.914,-1649.389,1397.967,0.000,0.000,86.459,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2010,1669.106,-1631.738,1397.967,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1665.561,-1634.832,1397.917,0.000,0.000,-276.839,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2256,1669.387,-1631.453,1400.102,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2424,1669.540,-1649.150,1397.967,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2422,1669.670,-1649.362,1399.015,0.000,0.000,-101.040,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2848,1666.439,-1633.083,1398.843,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2601,1669.538,-1649.531,1399.098,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1667.941,-1631.769,1397.917,0.000,0.000,-597.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2227,1669.600,-1648.661,1403.358,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2747,1666.402,-1632.754,1398.426,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2848,1666.370,-1632.420,1398.843,0.000,0.000,91.860,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1663.662,-1636.410,1397.917,0.000,0.000,-362.159,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2424,1669.540,-1650.079,1397.967,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1886,1668.939,-1645.428,1407.131,20.000,0.000,-56.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10079,1668.764,-1646.390,1406.629,180.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2011,1673.467,-1651.152,1397.967,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2184,1666.509,-1647.366,1403.365,0.000,0.000,-91.080,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1714,1668.682,-1649.037,1403.354,0.000,0.000,-111.360,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2690,1669.315,-1629.943,1399.112,0.000,0.000,-83.519,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2663,1669.855,-1650.730,1398.200,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2194,1666.903,-1647.358,1404.392,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2596,1673.628,-1651.197,1401.546,18.000,0.000,-135.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(14457,1668.082,-1647.812,1405.291,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2747,1663.708,-1634.687,1398.426,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1666.940,-1648.319,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2838,1663.573,-1634.779,1398.844,0.000,0.000,24.899,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1664.944,-1632.702,1397.917,0.000,0.000,-90.120,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2342,1666.692,-1647.911,1404.250,0.000,0.000,-122.339,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1666.562,-1631.024,1397.917,0.000,0.000,-545.160,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2257,1671.309,-1651.542,1400.429,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2827,1666.828,-1648.631,1404.141,0.000,0.000,57.299,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(18075,1664.855,-1637.534,1406.954,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1664.805,-1647.367,1403.377,0.000,0.000,-110.519,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2134,1668.669,-1628.941,1397.968,0.000,0.000,-45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2453,1668.819,-1628.828,1399.377,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2190,1666.754,-1649.131,1404.124,0.000,0.000,102.419,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1663.477,-1633.171,1397.917,0.000,0.000,-164.339,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2663,1668.785,-1628.830,1399.991,0.000,0.000,-20.940,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1664.278,-1631.519,1397.917,0.000,0.000,-362.159,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1661.835,-1634.837,1397.917,0.000,0.000,-90.120,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1665.860,-1629.813,1397.917,0.000,0.000,-627.359,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1726,1662.584,-1645.630,1403.346,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1569,1667.293,-1651.667,1397.907,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2233,1669.386,-1651.997,1403.352,0.000,0.000,-123.120,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1662.927,-1632.355,1397.917,0.000,0.000,-642.359,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2814,1668.076,-1628.152,1400.464,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2823,1664.493,-1630.459,1398.849,0.000,0.000,25.680,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10079,1664.497,-1646.390,1406.629,180.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1664.679,-1649.345,1403.377,0.000,0.000,-72.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2004,1668.417,-1651.689,1404.109,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2747,1664.309,-1630.162,1398.426,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1455,1664.221,-1630.084,1398.906,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1661.264,-1633.968,1397.917,0.000,0.000,-718.859,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2239,1661.427,-1645.452,1403.358,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2821,1667.619,-1627.569,1400.465,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2596,1669.012,-1651.242,1406.521,14.000,0.000,-127.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2353,1661.612,-1632.662,1398.904,-25.500,23.399,73.199,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1662.819,-1648.319,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1726,1664.341,-1650.939,1397.912,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2131,1667.242,-1627.523,1397.968,0.000,0.000,-45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1543,1667.173,-1627.542,1400.455,0.000,0.000,130.440,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2262,1664.218,-1651.125,1399.891,0.000,0.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1543,1667.148,-1627.302,1400.455,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1726,1664.601,-1651.012,1403.346,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2354,1661.565,-1631.719,1398.900,-25.000,24.000,58.500,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2747,1661.295,-1632.082,1398.426,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1662.894,-1629.942,1397.917,0.000,0.000,-90.120,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1664.152,-1628.438,1397.917,0.000,0.000,-164.339,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2134,1666.562,-1626.823,1397.968,0.000,0.000,-45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2261,1662.904,-1651.133,1399.145,0.000,0.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2260,1662.918,-1651.161,1400.380,0.000,0.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1661.454,-1630.861,1397.917,0.000,0.000,-547.499,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2596,1666.618,-1626.626,1401.546,18.000,0.000,-45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1644,1666.461,-1626.338,1399.044,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10079,1658.890,-1635.025,1398.365,0.000,0.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19317,1664.362,-1651.623,1405.441,0.000,20.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2133,1665.867,-1626.113,1397.968,0.000,0.000,-45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2295,1659.123,-1632.910,1398.089,0.000,0.000,103.620,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2848,1665.847,-1625.888,1399.018,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2001,1661.467,-1651.259,1397.967,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19318,1663.330,-1651.593,1405.379,0.000,20.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1661.686,-1628.669,1397.917,0.000,0.000,-362.159,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1658.699,-1634.239,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10079,1660.124,-1646.390,1406.629,180.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1660.773,-1629.569,1397.917,0.000,0.000,-362.159,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2295,1659.188,-1631.534,1398.089,0.000,0.000,51.959,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2811,1661.398,-1651.075,1403.357,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2354,1661.786,-1627.984,1398.900,-25.000,24.000,58.500,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(18075,1664.899,-1652.533,1406.954,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19319,1662.312,-1651.633,1405.291,0.000,20.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2747,1661.149,-1628.041,1398.426,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1658.699,-1648.319,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1569,1656.903,-1635.003,1397.907,0.000,0.000,-432.839,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1662.016,-1627.088,1397.917,0.000,0.000,-201.660,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10079,1660.144,-1648.695,1406.629,180.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2812,1664.601,-1624.802,1399.024,0.000,0.000,-5.639,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2132,1664.474,-1624.690,1397.968,0.000,0.000,-45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1546,1658.675,-1650.497,1398.842,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2295,1655.959,-1636.087,1398.089,0.000,0.000,-25.680,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1543,1664.419,-1624.510,1399.022,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1544,1664.549,-1624.407,1399.021,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1302,1660.439,-1652.747,1397.968,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1547,1664.390,-1624.410,1399.020,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1544,1664.259,-1624.483,1399.021,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1543,1664.382,-1624.342,1399.022,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1543,1664.186,-1624.381,1399.022,0.000,0.000,-115.019,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10079,1656.288,-1633.708,1398.365,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2002,1656.335,-1646.952,1397.966,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1569,1660.797,-1653.693,1397.907,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2267,1656.747,-1635.160,1405.194,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10079,1660.144,-1650.720,1406.629,180.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2309,1660.610,-1626.545,1397.917,0.000,0.000,-164.339,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1726,1655.740,-1635.766,1403.350,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10079,1657.282,-1632.566,1404.906,180.000,0.000,-113.060,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1569,1660.797,-1653.693,1403.349,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2165,1657.394,-1650.321,1397.968,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(18075,1664.855,-1625.156,1406.954,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10079,1656.523,-1633.600,1404.906,180.000,0.000,-140.540,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2961,1663.072,-1623.981,1399.223,0.000,0.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1806,1657.817,-1651.594,1397.967,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1716,1656.782,-1630.224,1397.965,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2295,1654.420,-1636.165,1398.089,0.000,0.000,38.639,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1658.702,-1627.600,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1716,1655.442,-1631.533,1397.965,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1789,1659.397,-1625.761,1398.506,0.000,0.000,-128.339,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1654.579,-1634.239,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10079,1656.798,-1630.185,1404.906,180.000,0.000,-76.580,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1359,1660.003,-1624.545,1398.657,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1716,1654.146,-1632.858,1397.965,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1569,1660.626,-1623.962,1403.347,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(18075,1653.963,-1641.599,1406.954,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1807,1660.263,-1656.930,1398.482,0.000,0.000,-28.379,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1658.699,-1654.959,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2066,1656.856,-1653.556,1397.967,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2011,1652.497,-1635.754,1397.967,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1569,1652.961,-1635.109,1403.347,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2263,1659.773,-1656.968,1399.222,0.000,0.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2229,1660.362,-1657.479,1403.357,0.000,0.000,-135.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2066,1655.811,-1653.532,1397.967,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(14391,1653.569,-1630.243,1398.878,0.000,0.000,-45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2443,1654.812,-1628.206,1396.716,0.000,0.000,45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10079,1652.968,-1633.606,1404.906,180.000,0.000,-140.540,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2232,1657.498,-1624.383,1398.561,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2443,1654.141,-1628.865,1396.716,0.000,0.000,45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1886,1660.326,-1656.983,1407.131,20.000,0.000,-135.500,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2443,1653.469,-1629.524,1396.716,0.000,0.000,45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2190,1655.153,-1653.921,1398.747,0.000,0.000,-16.920,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2167,1658.359,-1657.459,1397.968,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10079,1656.825,-1625.268,1404.406,180.000,0.000,-76.580,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1775,1650.878,-1635.762,1398.995,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2443,1652.822,-1630.178,1396.716,0.000,0.000,45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2443,1652.189,-1630.820,1396.716,0.000,0.000,45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2443,1651.623,-1631.379,1396.716,0.000,0.000,45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1806,1654.973,-1655.256,1397.967,0.000,0.000,55.619,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1650.460,-1634.239,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19173,1650.638,-1635.144,1405.254,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1654.579,-1654.959,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1658.699,-1620.959,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1726,1649.626,-1635.733,1403.350,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2166,1653.863,-1655.182,1397.967,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1726,1652.327,-1652.445,1403.350,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2162,1655.436,-1657.484,1399.065,0.000,0.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(18075,1652.414,-1627.436,1403.426,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1806,1651.859,-1653.241,1397.967,0.000,0.000,55.619,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(18075,1653.923,-1654.308,1406.954,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19175,1655.615,-1657.464,1405.405,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(14632,1648.631,-1646.636,1399.447,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2166,1650.717,-1652.895,1397.967,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2239,1653.613,-1657.111,1397.967,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2024,1647.979,-1644.021,1403.359,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2232,1647.991,-1634.242,1398.561,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1726,1647.547,-1639.983,1403.350,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2827,1647.553,-1643.119,1403.907,0.000,0.000,57.299,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1886,1647.928,-1634.557,1403.625,20.000,0.000,150.479,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2190,1650.688,-1626.344,1398.788,0.000,0.000,-141.120,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1726,1647.499,-1645.184,1403.350,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2853,1647.369,-1644.033,1403.892,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10079,1648.026,-1633.594,1404.406,180.000,0.000,-140.540,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2596,1647.974,-1632.339,1402.197,20.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1958,1650.028,-1626.744,1398.814,0.000,0.000,45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2190,1650.944,-1655.486,1398.747,0.000,0.000,-16.920,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1955,1650.150,-1626.125,1398.999,99.000,0.000,-216.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2422,1649.440,-1627.283,1398.772,0.000,0.000,-335.820,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2208,1649.223,-1627.676,1397.953,0.000,0.000,45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2344,1647.222,-1646.720,1403.869,0.000,0.000,-115.980,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2596,1646.482,-1635.485,1401.097,20.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1646.339,-1641.680,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1955,1649.349,-1626.837,1398.999,99.000,0.000,-216.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1650.459,-1654.959,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1646.339,-1635.040,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1716,1649.871,-1624.886,1397.965,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2173,1649.900,-1655.765,1397.969,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2596,1646.482,-1635.485,1405.824,20.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1716,1648.868,-1625.976,1397.965,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1806,1650.312,-1656.815,1397.967,0.000,0.000,13.500,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1566,1651.407,-1657.456,1404.870,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1646.339,-1648.319,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2922,1645.265,-1635.181,1399.380,0.000,0.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2922,1645.265,-1635.181,1404.733,0.000,0.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(14455,1648.217,-1657.461,1399.523,-0.039,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2165,1646.195,-1654.211,1397.968,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1806,1646.831,-1655.602,1397.967,0.000,0.000,-6.719,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(18757,1643.282,-1633.131,1399.895,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(18075,1643.522,-1641.599,1406.954,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(18756,1643.263,-1633.129,1399.895,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(18755,1643.266,-1633.100,1399.897,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1566,1648.234,-1657.476,1404.870,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1646.339,-1654.959,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2186,1645.059,-1653.143,1397.968,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2778,1645.824,-1654.406,1403.349,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1642.219,-1641.680,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(18757,1643.282,-1633.131,1405.296,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1569,1643.621,-1629.768,1397.685,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(18756,1643.263,-1633.129,1405.296,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(18755,1643.266,-1633.100,1405.282,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2232,1645.509,-1654.385,1403.747,-90.000,90.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1642.219,-1635.040,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2779,1644.398,-1653.078,1403.350,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2001,1646.140,-1657.086,1397.967,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2232,1644.362,-1653.408,1403.747,-90.000,90.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2066,1644.969,-1655.823,1397.967,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1642.219,-1648.319,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2965,1640.889,-1641.351,1403.557,0.000,52.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(3004,1640.927,-1639.491,1404.901,276.998,0.000,261.156,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2258,1645.092,-1657.436,1400.366,0.000,0.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2066,1643.943,-1655.451,1397.967,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(3001,1640.693,-1641.438,1404.410,0.000,0.000,-71.160,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(14651,1640.837,-1640.856,1405.593,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2194,1640.862,-1647.364,1399.036,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2997,1640.475,-1640.070,1404.410,66.959,-236.639,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(3003,1640.394,-1640.751,1404.410,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1778,1640.252,-1635.101,1397.969,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2996,1641.688,-1649.875,1404.410,-15.119,-138.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2028,1640.197,-1644.149,1403.454,0.000,0.000,70.559,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2996,1640.059,-1640.400,1404.410,344.877,221.995,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2190,1640.091,-1645.844,1398.747,0.000,0.000,-16.920,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(14651,1641.833,-1650.315,1405.593,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(3003,1641.258,-1649.162,1404.410,-21.600,102.959,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1806,1643.104,-1655.489,1397.967,0.000,0.000,35.700,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2998,1641.448,-1650.367,1404.410,137.940,-30.959,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(18075,1643.522,-1654.308,1406.954,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2995,1641.465,-1650.666,1404.410,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(3002,1639.763,-1641.514,1404.410,-146.820,-230.279,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2999,1641.312,-1650.532,1404.410,65.279,112.919,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(3004,1641.119,-1649.916,1404.390,358.994,0.000,325.195,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(3000,1641.326,-1650.648,1404.410,-106.680,-145.860,-156.539,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2166,1639.761,-1646.216,1397.967,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2165,1640.712,-1650.218,1397.968,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(3002,1640.891,-1649.611,1404.410,-253.259,151.020,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(3004,1641.042,-1650.239,1404.390,-1.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(3002,1641.210,-1650.843,1404.410,-152.460,-93.959,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2010,1639.355,-1644.872,1397.967,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2997,1640.866,-1650.433,1404.410,66.959,-236.639,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1886,1639.270,-1635.610,1403.323,20.000,0.000,45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2166,1642.100,-1655.268,1397.967,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(3106,1640.773,-1650.877,1404.410,0.000,0.000,288.836,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1642.219,-1654.959,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2690,1638.957,-1635.255,1398.304,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2344,1639.311,-1644.909,1404.726,0.000,0.000,-317.399,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1806,1639.239,-1647.249,1397.967,0.000,0.000,-56.700,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2229,1638.870,-1643.564,1403.357,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2104,1638.971,-1644.586,1403.367,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2104,1638.962,-1645.209,1403.367,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(3004,1638.777,-1641.854,1404.901,-83.000,0.000,-98.839,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2229,1638.951,-1645.882,1403.357,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(3004,1638.777,-1642.334,1404.901,-83.000,0.000,-98.839,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(3004,1638.777,-1642.834,1404.901,-83.000,0.000,-98.839,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2167,1642.520,-1657.447,1397.968,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19317,1639.053,-1646.991,1404.067,-22.000,0.000,71.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1886,1639.270,-1635.610,1407.131,20.000,0.000,45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1897,1638.773,-1645.100,1404.994,0.000,90.000,269.994,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1638.099,-1641.680,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2229,1638.234,-1636.179,1403.357,0.000,0.000,45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1806,1639.335,-1650.967,1397.967,0.000,0.000,-90.419,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1638.099,-1635.040,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2161,1638.843,-1650.770,1399.291,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2872,1641.624,-1656.937,1403.360,0.000,0.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2232,1641.579,-1657.274,1403.747,-90.000,90.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1638.099,-1648.319,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2239,1639.060,-1652.754,1397.967,0.000,0.000,85.860,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2162,1641.063,-1657.444,1399.065,0.000,0.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2872,1639.324,-1654.403,1403.360,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2164,1638.852,-1654.707,1397.968,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2232,1639.006,-1654.379,1403.747,-90.000,90.000,180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2811,1639.338,-1656.984,1397.966,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(1886,1639.250,-1656.980,1403.323,20.000,0.000,140.639,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(19325,1638.099,-1654.959,1403.352,0.000,90.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(2229,1638.763,-1657.034,1403.357,0.000,0.000,135.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10973,1715.419,-1651.211,1411.430,0.000,180.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10973,1720.036,-1643.437,1400.099,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10973,1715.418,-1596.042,1400.099,0.000,0.000,-90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10973,1703.387,-1697.641,1400.099,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10973,1681.034,-1575.479,1400.099,0.000,0.000,-45.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10973,1651.914,-1577.988,1400.099,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10973,1646.866,-1703.472,1400.099,0.000,0.000,-180.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10973,1616.420,-1589.140,1411.219,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10973,1592.785,-1647.142,1400.099,0.000,0.000,90.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(10973,1604.825,-1589.127,1400.099,0.000,0.000,0.000,300.000,300.000);
	tmpobjid = CreateDynamicObjectEx(3106,1640.246,-1639.583,1404.410,344.877,221.995,0.000,300.000,300.000);

	tmpobjid = CreateDynamicObject(4585, 1658.0, -1636.8, 1298.14, 0.0, 0.0, 0.0);
	//Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT, tmpobjid, true);
	obj = tmpobjid = CreateDynamicObject(4585, 1653.30200, -1634.89502, 1506.8, 0.0, 180.0, 0.0);
	return obj;
}

Park_CreateObjects()
{
	/*CreateDynamicObject(8555, 1462.94995, -1772.68005, 35.90000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(4003, 1465.03003, -1749.06006, 30.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(4691, 1524.21997, -1785.14001, 12.68000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(982, 1558.18994, -1757.01001, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19123, 1558.25000, -1744.06006, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(982, 1558.18994, -1782.60999, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(982, 1558.18994, -1808.21997, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(982, 1558.20996, -1829.46997, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(982, 1545.30005, -1744.13000, 13.23000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(982, 1523.68005, -1744.13000, 13.23000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 1510.81995, -1747.38000, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 1510.81995, -1748.94995, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19123, 1510.72998, -1744.06006, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(982, 1490.28003, -1805.38000, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(982, 1490.29004, -1816.23999, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(982, 1503.07996, -1829.04004, 13.23000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(982, 1528.68994, -1829.04004, 13.23000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(982, 1536.68005, -1829.03003, 13.23000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 1549.50000, -1825.80005, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 1549.50000, -1819.39001, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 1549.48999, -1814.81006, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 1552.68994, -1811.62000, 13.23000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 1555.01001, -1811.62000, 13.23000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19123, 1510.79004, -1752.34998, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19123, 1502.96997, -1752.43005, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19123, 1451.18994, -1744.12000, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 1451.09998, -1747.43005, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 1451.12000, -1749.42004, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(982, 1438.23999, -1744.14001, 13.23000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(982, 1414.18005, -1744.15002, 13.23000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19123, 1401.27002, -1744.06006, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(984, 1401.29004, -1750.59998, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(984, 1401.28003, -1762.43994, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19123, 1401.25000, -1769.02002, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3461, 1468.93994, -1750.69995, 14.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3461, 1462.51001, -1750.67004, 14.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 1511.83997, -1740.90002, 13.23000,   0.00000, 0.00000, -20.00000);
	CreateDynamicObject(983, 1502.97998, -1749.05005, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 1501.88000, -1740.80005, 13.23000,   0.00000, 0.00000, 20.00000);
	CreateDynamicObject(983, 1502.97998, -1746.98999, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(982, 1489.62000, -1742.32996, 13.23000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(982, 1485.23999, -1742.31995, 13.23000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 1461.80005, -1749.66003, 13.23000,   0.00000, 0.00000, 20.00000);
	CreateDynamicObject(983, 1451.09998, -1747.43005, 13.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 1455.38000, -1742.30005, 13.23000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19123, 1451.19995, -1743.89001, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19123, 1451.39001, -1743.77002, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19123, 1451.41003, -1743.53003, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19123, 1451.59998, -1743.40002, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19123, 1451.60999, -1743.17004, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19123, 1451.81006, -1743.04004, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19123, 1451.82996, -1742.80005, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19123, 1452.02002, -1742.67004, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19123, 1452.03003, -1742.43005, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 1460.19995, -1745.29004, 13.23000,   0.00000, 0.00000, 20.00000);
	CreateDynamicObject(983, 1455.90002, -1742.29004, 13.23000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 1469.77002, -1749.67004, 13.23000,   0.00000, 0.00000, -20.00000);
	CreateDynamicObject(983, 1471.37000, -1745.31995, 13.23000,   0.00000, 0.00000, -20.00000);
	CreateDynamicObject(19124, 1468.89001, -1742.41003, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19124, 1463.10999, -1742.39001, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19124, 1466.05005, -1742.38000, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1257, 1495.23999, -1740.41003, 13.77000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(673, 1499.29004, -1746.62000, 10.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(673, 1493.82996, -1746.39001, 10.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(673, 1488.90002, -1746.29004, 10.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(673, 1484.01001, -1746.21997, 10.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(673, 1479.13000, -1746.40002, 10.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(673, 1474.40002, -1746.40002, 10.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(673, 1458.17004, -1746.55005, 10.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(673, 1452.92004, -1746.56995, 10.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1223, 1458.93005, -1742.68005, 12.02000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1223, 1472.64001, -1742.71997, 12.23000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1223, 1502.10999, -1743.29004, 12.23000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1258, 1458.44995, -1741.39001, 13.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(821, 1498.79004, -1746.81006, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(821, 1494.43005, -1746.76001, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(821, 1489.98999, -1746.42004, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(821, 1485.64001, -1746.60999, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(821, 1481.04004, -1746.40002, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(821, 1476.18005, -1747.47998, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(821, 1474.27002, -1746.83997, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(821, 1457.28003, -1747.00000, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(821, 1454.39001, -1747.43005, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(824, 1487.70996, -1746.32996, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(824, 1493.56995, -1746.89001, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(824, 1478.63000, -1746.19995, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(824, 1455.81006, -1746.62000, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(982, 1477.50000, -1829.04004, 13.13000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(982, 1451.89001, -1829.04004, 13.13000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(982, 1445.50000, -1829.04004, 13.13000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(982, 1423.22998, -1805.50000, 13.13000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(982, 1423.22998, -1816.23999, 13.13000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(673, 1484.79004, -1826.45996, 10.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(673, 1478.25000, -1826.50000, 10.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(673, 1472.07996, -1826.31006, 10.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(673, 1465.81995, -1826.33997, 10.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(673, 1460.46997, -1826.25000, 10.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(673, 1454.83997, -1826.09998, 10.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(673, 1448.18005, -1825.85999, 10.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(673, 1440.40002, -1825.55005, 10.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 1432.09998, -1832.13000, 13.23000,   0.00000, 0.00000, -11.00000);
	CreateDynamicObject(983, 1434.69995, -1835.28003, 13.23000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 1438.29004, -1835.28003, 13.23000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(673, 1440.00000, -1832.35999, 10.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(673, 1436.18994, -1832.25000, 10.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, 1422.42004, -1842.34998, 13.23000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(983, 1430.89001, -1838.40002, 13.23000,   0.00000, 0.00000, -11.00000);
	CreateDynamicObject(983, 1430.72998, -1839.19995, 13.23000,   0.00000, 0.00000, -11.00000);
	CreateDynamicObject(983, 1426.93994, -1842.33997, 13.23000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3472, 1416.63000, -1820.14001, 12.80000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3472, 1416.31006, -1811.85999, 12.80000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3472, 1416.72998, -1804.80005, 12.80000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10032, 1455.68005, -1808.23999, 12.58000,   180.00000, 0.00000, 0.00000);
	CreateDynamicObject(11431, 1430.43005, -1787.26001, 60.58000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18850, 1483.03003, -1773.09998, 47.01000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(11431, 1426.23999, -1794.52002, 13.95000,   0.00000, 0.00000, 359.54999);
	CreateDynamicObject(18850, 1449.53003, -1773.09998, 47.01000,   0.00000, 0.00000, 90.00000);*/


	//Objects////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Objects////////////////////////////////////////////////////////////////////////////////////////////////////////
	new tmpobjid;
	tmpobjid = CreateDynamicObject(19543,1450.655,-1721.224,12.375,0.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", -1);
	Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT, tmpobjid, true);
	tmpobjid = CreateDynamicObject(19543,1513.121,-1721.224,12.375,0.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", -1);
	Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT, tmpobjid, true);
	tmpobjid = CreateDynamicObject(18980,1447.040,-1713.380,12.767,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1512.064,-1713.380,12.767,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1479.564,-1713.380,12.767,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1435.041,-1700.382,12.767,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1524.065,-1700.382,12.767,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1524.065,-1614.414,12.767,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(19430,1523.718,-1599.737,10.744,0.000,0.000,34.472,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0);
	tmpobjid = CreateDynamicObject(19430,1522.677,-1598.552,10.744,0.000,0.000,48.025,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0);
	tmpobjid = CreateDynamicObject(19430,1521.362,-1597.720,10.744,0.000,0.000,67.256,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0);
	tmpobjid = CreateDynamicObject(19430,1519.850,-1597.378,10.744,0.000,0.000,87.186,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0);
	tmpobjid = CreateDynamicObject(18980,1506.564,-1597.748,12.767,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1452.559,-1597.748,12.767,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1435.061,-1614.414,12.767,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(19430,1434.807,-1601.148,10.744,0.000,0.000,-11.310,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0);
	tmpobjid = CreateDynamicObject(19430,1435.401,-1599.737,10.744,0.000,0.000,-34.472,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0);
	tmpobjid = CreateDynamicObject(19430,1436.436,-1598.552,10.744,0.000,0.000,-48.025,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0);
	tmpobjid = CreateDynamicObject(19430,1437.753,-1597.720,10.744,0.000,0.000,-67.256,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0);
	tmpobjid = CreateDynamicObject(19430,1439.264,-1597.378,10.744,0.000,0.000,-87.186,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0);
	tmpobjid = CreateDynamicObject(18762,1459.042,-1713.381,13.365,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1467.563,-1713.381,13.365,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1491.565,-1713.381,13.365,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1524.067,-1713.381,13.365,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1435.036,-1713.385,13.367,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1435.041,-1675.382,11.909,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1435.041,-1650.382,11.909,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1435.041,-1625.382,11.909,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1524.065,-1625.382,11.909,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1524.065,-1650.382,11.909,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1524.067,-1675.382,11.909,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1435.062,-1688.380,13.365,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1524.085,-1688.380,13.375,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1524.065,-1700.382,15.365,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1512.064,-1713.380,15.365,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1447.040,-1713.380,15.365,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1435.041,-1700.382,15.365,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1524.065,-1614.414,15.365,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1506.564,-1597.748,15.365,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1452.559,-1597.748,15.365,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1435.061,-1614.414,15.365,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1435.062,-1626.416,13.365,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1435.062,-1602.375,13.365,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1524.065,-1602.365,13.375,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1524.075,-1626.426,13.385,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1494.533,-1597.739,13.355,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1518.627,-1597.729,13.375,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1464.591,-1597.750,13.365,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1440.552,-1597.729,13.365,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1477.559,-1597.748,11.909,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1492.557,-1597.750,11.909,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1466.347,-1713.380,11.909,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18980,1491.350,-1713.380,11.909,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1479.565,-1713.722,13.589,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(18980,1479.564,-1713.380,15.365,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18766,1463.307,-1707.890,11.909,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1495.817,-1707.890,11.909,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1463.307,-1697.890,11.909,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1495.817,-1697.890,11.909,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1463.303,-1687.910,11.909,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1460.807,-1684.139,11.919,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1450.807,-1684.139,11.909,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1440.947,-1684.139,11.909,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1495.817,-1687.890,11.908,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1498.307,-1684.139,11.909,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1508.307,-1684.139,11.909,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1518.307,-1684.139,11.909,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18762,1435.452,-1684.139,11.909,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18762,1523.812,-1684.139,11.909,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1493.327,-1679.139,11.910,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1484.307,-1679.139,11.920,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1474.307,-1679.139,11.919,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1465.807,-1679.139,11.913,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1495.817,-1671.630,11.909,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1495.817,-1661.710,11.909,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1495.817,-1651.740,11.909,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1495.817,-1631.911,11.949,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1518.807,-1630.638,11.909,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1509.307,-1630.638,11.909,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1499.307,-1630.638,11.909,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1459.807,-1630.638,11.909,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1449.807,-1630.638,11.909,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1439.813,-1630.638,11.909,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1463.303,-1671.668,11.909,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1463.303,-1661.668,11.909,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1463.303,-1651.678,11.909,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1463.303,-1641.679,11.909,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1463.303,-1631.889,11.929,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1489.313,-1629.400,11.945,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1469.807,-1629.400,11.909,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18766,1479.425,-1629.400,11.909,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(19430,1524.315,-1601.148,10.744,0.000,0.000,11.310,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0);
	tmpobjid = CreateDynamicObject(19087,1484.554,-1714.217,16.088,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1484.554,-1714.217,13.640,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1484.554,-1713.230,15.055,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1474.567,-1714.217,16.088,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1474.567,-1714.217,13.640,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1484.569,-1714.218,16.088,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19089,1481.934,-1714.214,16.088,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1484.137,-1714.214,16.088,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19089,1481.934,-1714.214,12.376,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1484.569,-1714.218,12.376,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1484.137,-1714.214,12.376,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19089,1483.189,-1714.214,15.463,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19089,1483.189,-1714.214,13.001,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1475.822,-1714.217,15.463,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1483.174,-1714.217,15.463,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(18766,1495.817,-1641.770,11.909,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(19089,1446.939,-1727.297,12.386,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19087,1434.562,-1722.272,12.386,0.000,90.000,134.772,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19087,1436.286,-1723.996,12.386,0.000,90.000,134.772,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19087,1437.833,-1725.555,12.385,0.000,90.000,134.772,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19089,1434.568,-1712.453,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19089,1454.303,-1727.297,12.386,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19089,1461.656,-1727.297,12.386,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19089,1469.030,-1727.297,12.386,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19089,1476.395,-1727.297,12.386,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19089,1483.790,-1727.297,12.386,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19089,1491.150,-1727.297,12.386,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19089,1498.510,-1727.297,12.386,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19089,1505.854,-1727.297,12.386,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19089,1513.227,-1727.297,12.386,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19089,1519.563,-1727.297,12.386,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19087,1521.281,-1725.555,12.386,0.000,90.000,45.319,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19087,1523.007,-1723.816,12.386,0.000,90.000,45.319,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19087,1524.550,-1722.278,12.385,0.000,90.000,44.898,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19087,1524.547,-1719.817,12.385,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19089,1524.547,-1712.449,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19087,1434.568,-1719.817,12.385,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-95-percent", 0);
	tmpobjid = CreateDynamicObject(19089,1437.568,-1713.453,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1440.568,-1713.453,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1443.568,-1713.453,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1446.568,-1713.453,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1449.568,-1713.453,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1452.568,-1713.453,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1455.568,-1713.453,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1458.568,-1713.453,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1500.568,-1713.453,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1503.568,-1713.453,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1506.568,-1713.453,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1509.568,-1713.453,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1512.568,-1713.453,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1515.568,-1713.453,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1518.568,-1713.453,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1521.568,-1713.453,12.386,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(8397,1479.545,-1650.792,-18.253,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18766,1479.565,-1648.403,12.171,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0);
	tmpobjid = CreateDynamicObject(18766,1479.565,-1653.317,12.171,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0);
	tmpobjid = CreateDynamicObject(18764,1480.150,-1651.446,10.657,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0);
	tmpobjid = CreateDynamicObject(18764,1478.980,-1650.159,10.657,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0);
	tmpobjid = CreateDynamicObject(18764,1480.148,-1650.161,10.657,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0);
	tmpobjid = CreateDynamicObject(18764,1478.982,-1651.443,10.657,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0);
	tmpobjid = CreateDynamicObject(18763,1479.515,-1651.008,15.975,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 4830, "airport2", "tardor9", 0);
	tmpobjid = CreateDynamicObject(18980,1447.040,-1679.880,12.767,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1447.040,-1634.880,12.767,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1459.042,-1679.881,13.365,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1435.038,-1679.881,13.365,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1447.040,-1634.880,15.365,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1435.038,-1634.878,13.365,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1459.041,-1647.882,12.767,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1459.041,-1647.882,15.365,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1459.040,-1666.913,12.767,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1459.040,-1666.907,15.365,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18766,1458.761,-1658.385,13.589,0.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(18980,1512.064,-1634.880,12.767,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1512.064,-1679.880,12.767,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1447.040,-1679.880,15.365,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1512.064,-1679.880,15.365,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1512.064,-1634.880,15.365,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1459.042,-1634.878,13.365,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1500.029,-1634.874,13.369,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1524.065,-1634.898,13.385,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1524.065,-1679.881,13.405,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18762,1500.021,-1679.885,13.367,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1500.025,-1647.875,12.767,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1500.025,-1666.875,12.767,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1500.025,-1666.875,15.365,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1500.025,-1647.875,15.365,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18766,1500.361,-1658.385,13.589,0.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(18980,1524.068,-1675.382,11.334,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1524.063,-1675.382,11.502,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18763,1479.523,-1674.148,10.916,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18763,1479.523,-1669.162,10.916,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18763,1479.523,-1664.176,10.916,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18763,1479.523,-1659.180,10.916,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18763,1479.523,-1654.180,10.916,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(19087,1474.567,-1713.230,15.055,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1458.258,-1653.385,16.089,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1458.258,-1653.385,13.639,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19089,1458.258,-1660.753,16.080,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1458.258,-1663.385,16.089,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1458.258,-1663.385,13.631,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19089,1458.258,-1663.397,16.079,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19089,1458.258,-1660.753,12.415,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19089,1458.258,-1663.397,12.414,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19089,1458.258,-1662.132,15.588,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1458.258,-1654.765,15.606,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19089,1458.258,-1662.132,13.128,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1458.258,-1662.129,15.606,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1500.863,-1663.385,16.088,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1500.863,-1663.385,13.631,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1500.863,-1653.385,16.089,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1500.863,-1653.385,13.639,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19089,1500.861,-1660.732,16.080,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19089,1500.863,-1663.397,16.079,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19089,1500.863,-1663.397,12.414,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19089,1500.863,-1660.753,12.415,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19089,1500.863,-1662.132,15.588,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1500.863,-1662.129,15.606,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19089,1500.863,-1662.132,13.128,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19087,1500.863,-1654.765,15.606,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14425, "madbedrooms", "ah_wallstyle2", 0);
	tmpobjid = CreateDynamicObject(19089,1507.291,-1679.328,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1507.291,-1675.858,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1507.291,-1672.358,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1507.291,-1668.843,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1507.291,-1665.439,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1507.291,-1661.939,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1507.291,-1658.439,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1507.291,-1654.939,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1507.291,-1651.439,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1507.291,-1647.939,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1507.291,-1644.439,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1507.291,-1641.383,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1459.299,-1679.342,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1459.299,-1676.342,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1459.299,-1673.342,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1459.299,-1670.342,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1459.299,-1667.342,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1459.299,-1664.342,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1459.299,-1661.342,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1459.299,-1658.342,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1459.299,-1655.342,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1459.299,-1652.342,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1459.299,-1649.342,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1459.299,-1645.842,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1459.299,-1642.842,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1459.299,-1639.342,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(18980,1523.073,-1667.709,11.909,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1523.073,-1646.953,11.910,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1436.037,-1667.840,11.909,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1436.037,-1647.840,11.909,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(19089,1459.299,-1635.432,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1507.291,-1635.460,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(19089,1507.291,-1638.406,12.402,90.000,0.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 14590, "mafcastopfoor", "cop_ceiling1", 0);
	tmpobjid = CreateDynamicObject(18980,1491.564,-1700.396,12.060,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18762,1491.564,-1685.398,12.060,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18980,1479.564,-1683.376,12.062,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18980,1467.567,-1700.396,12.060,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18762,1467.567,-1685.398,12.060,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18980,1459.042,-1700.396,12.060,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18980,1447.045,-1688.384,12.060,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18762,1500.063,-1713.381,13.365,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 13691, "bevcunto2_lahills", "adeta", 0);
	tmpobjid = CreateDynamicObject(18980,1500.063,-1700.396,12.060,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18980,1512.059,-1688.384,12.062,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19549,1522.967,-1663.896,12.411,0.000,0.000,180.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", -1);
	Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT, tmpobjid, true);
	tmpobjid = CreateDynamicObject(19549,1522.977,-1650.896,12.415,0.000,0.000,180.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", -1);
	Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT, tmpobjid, true);
	tmpobjid = CreateDynamicObject(19549,1458.997,-1663.896,12.411,0.000,0.000,180.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", -1);
	Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT, tmpobjid, true);
	tmpobjid = CreateDynamicObject(19549,1459.017,-1650.896,12.405,0.000,0.000,180.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18757, "vcinteriors", "dts_elevator_carpet3", -1);
	Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT, tmpobjid, true);
	tmpobjid = CreateDynamicObject(18980,1482.563,-1662.746,12.064,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18762,1485.539,-1674.742,12.060,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18762,1489.495,-1674.742,12.070,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18980,1491.546,-1662.744,12.064,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18980,1479.535,-1633.876,12.062,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18980,1491.542,-1645.865,12.060,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18980,1476.475,-1662.752,12.064,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18762,1473.535,-1674.752,12.060,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18762,1469.608,-1674.741,12.050,0.000,90.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18980,1467.533,-1662.756,12.064,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(18980,1467.547,-1645.865,12.060,0.000,90.000,90.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0);
	tmpobjid = CreateDynamicObject(19480,1500.875,-1658.489,14.705,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Parking", 140, "Ariel", 25, 1, -13676721, 0, 1);
	tmpobjid = CreateDynamicObject(19480,1500.867,-1658.430,13.825,0.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Police Department", 140, "Ariel", 20, 1, -13676721, 0, 1);
	tmpobjid = CreateDynamicObject(19480,1458.238,-1658.368,14.485,0.000,0.000,-179.300,-1,-1,-1);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Parking", 140, "Ariel", 25, 1, -13676721, 0, 1);
	tmpobjid = CreateDynamicObject(19480,1479.443,-1714.230,14.295,0.000,0.000,-90.000,-1,-1,-1);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Central Park", 140, "Ariel", 25, 1, -13676721, 0, 1);
	tmpobjid = CreateDynamicObject(18762,1435.042,-1682.399,11.918,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18762,1435.042,-1687.279,11.918,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18762,1524.063,-1686.879,11.918,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18762,1524.063,-1681.879,11.918,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(19430,1434.807,-1601.148,10.744,0.000,0.000,-11.310,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 18835, "mickytextures", "whiteforletters", 0);
	tmpobjid = CreateDynamicObject(18762,1435.042,-1632.638,11.918,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18762,1435.042,-1627.648,11.918,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18762,1524.063,-1632.388,11.918,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(18762,1524.063,-1627.388,11.918,90.000,0.000,0.000,-1,-1,-1);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "mono1_sfe", 0);
	tmpobjid = CreateDynamicObject(19480,1479.574,-1653.530,15.981,0.000,0.000,-89.899,-1,-1,-1);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Square", 140, "Ariel", 15, 1, -13676721, 0, 1);
	tmpobjid = CreateDynamicObject(19477,1479.491,-1653.516,14.706,0.000,0.000,-88.699,-1,-1,-1);
	SetDynamicObjectMaterialText(tmpobjid, 0, "2004", 140, "Ariel", 50, 1, -13676721, 0, 1);
	tmpobjid = CreateDynamicObject(19480,1479.574,-1653.530,15.051,0.000,0.000,-89.899,-1,-1,-1);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Los Santos", 140, "Ariel", 15, 1, -13676721, 0, 1);
	tmpobjid = CreateDynamicObject(19480,1479.574,-1653.510,16.541,0.000,0.000,-89.899,-1,-1,-1);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Pershing", 140, "Ariel", 15, 1, -13676721, 0, 1);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(19550,1494.608,-1651.245,12.273,0.000,0.000,0.000,-1,-1,-1);
	tmpobjid = CreateDynamicObject(19443,12.377,-1599.737,11.622,0.000,0.000,34.472,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1439.989,-1606.003,12.340,0.000,0.000,0.000,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1443.126,-1621.098,12.340,0.000,0.000,37.416,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1473.337,-1609.018,12.340,0.000,0.000,74.623,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1458.843,-1605.812,12.340,0.000,0.000,69.478,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1465.051,-1614.720,12.340,0.000,0.000,72.177,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1501.350,-1616.943,12.340,0.000,0.000,88.796,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1465.387,-1624.160,12.340,0.000,0.000,71.740,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1479.491,-1623.229,12.340,0.000,0.000,128.019,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1474.880,-1616.873,12.340,0.000,0.000,100.422,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1483.560,-1603.577,12.340,0.000,0.000,83.907,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1493.264,-1611.013,12.340,0.000,0.000,119.739,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1492.523,-1603.294,12.340,0.000,0.000,73.025,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1488.214,-1618.234,12.340,0.000,0.000,74.623,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1502.433,-1624.280,12.340,0.000,0.000,64.618,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1502.057,-1606.899,12.340,0.000,0.000,83.907,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1513.052,-1603.402,12.340,0.000,0.000,83.907,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1515.385,-1617.707,12.340,0.000,0.000,76.449,-1,-1,-1);
	tmpobjid = CreateDynamicObject(779,1518.233,-1624.891,12.340,0.000,0.000,91.193,-1,-1,-1);
	tmpobjid = CreateDynamicObject(776,1449.876,-1612.908,12.340,0.000,0.000,56.315,-1,-1,-1);
	tmpobjid = CreateDynamicObject(776,1506.405,-1611.880,11.318,0.000,0.000,344.680,-1,-1,-1);
	tmpobjid = CreateDynamicObject(778,1466.649,-1604.617,11.117,0.000,0.000,344.680,-1,-1,-1);
	tmpobjid = CreateDynamicObject(766,1482.838,-1609.891,12.135,0.000,0.000,324.811,-1,-1,-1);
	tmpobjid = CreateDynamicObject(763,1456.157,-1623.725,11.729,0.000,0.000,7.122,-1,-1,-1);
	tmpobjid = CreateDynamicObject(765,1496.615,-1620.296,12.135,0.000,0.000,333.310,-1,-1,-1);
	tmpobjid = CreateDynamicObject(760,1477.878,-1614.834,12.340,0.000,0.000,74.623,-1,-1,-1);
	tmpobjid = CreateDynamicObject(761,1488.353,-1618.334,12.340,0.000,0.000,74.623,-1,-1,-1);
	tmpobjid = CreateDynamicObject(759,1439.325,-1610.151,12.340,0.000,0.000,85.027,-1,-1,-1);
	tmpobjid = CreateDynamicObject(760,1497.431,-1611.067,12.340,0.000,0.000,74.623,-1,-1,-1);
	tmpobjid = CreateDynamicObject(760,1457.468,-1609.110,12.340,0.000,0.000,92.421,-1,-1,-1);
	tmpobjid = CreateDynamicObject(760,1448.623,-1620.577,12.340,0.000,0.000,77.218,-1,-1,-1);
	tmpobjid = CreateDynamicObject(760,1468.512,-1621.511,12.340,0.000,0.000,85.027,-1,-1,-1);
	tmpobjid = CreateDynamicObject(759,1473.134,-1604.270,12.340,0.000,0.000,91.972,-1,-1,-1);
	tmpobjid = CreateDynamicObject(759,1448.809,-1601.308,12.340,0.000,0.000,91.972,-1,-1,-1);
	tmpobjid = CreateDynamicObject(759,1513.253,-1623.123,12.340,0.000,0.000,91.972,-1,-1,-1);
	tmpobjid = CreateDynamicObject(758,1508.334,-1617.000,12.139,0.000,0.000,177.474,-1,-1,-1);
	tmpobjid = CreateDynamicObject(758,1451.291,-1610.260,12.139,0.000,0.000,118.331,-1,-1,-1);
	tmpobjid = CreateDynamicObject(747,1481.715,-1605.841,12.139,0.000,0.000,118.331,-1,-1,-1);
	tmpobjid = CreateDynamicObject(19480,1479.490,-1654.200,12.671,0.000,0.000,0.000,-1,-1,-1);
	tmpobjid = CreateDynamicObject(1280,1490.063,-1682.092,12.660,0.000,0.000,-90.200,-1,-1,-1);
	tmpobjid = CreateDynamicObject(1280,1479.702,-1682.055,12.660,0.000,0.000,-90.200,-1,-1,-1);
	tmpobjid = CreateDynamicObject(1280,1469.092,-1682.018,12.660,0.000,0.000,-90.200,-1,-1,-1);
	tmpobjid = CreateDynamicObject(1280,1498.927,-1690.192,12.629,0.000,0.000,0.000,-1,-1,-1);
	tmpobjid = CreateDynamicObject(1280,1498.927,-1702.402,12.629,0.000,0.000,0.000,-1,-1,-1);
	tmpobjid = CreateDynamicObject(1280,1460.306,-1702.402,12.659,0.000,0.000,179.500,-1,-1,-1);
	tmpobjid = CreateDynamicObject(1280,1460.415,-1689.931,12.659,0.000,0.000,179.500,-1,-1,-1);
	tmpobjid = CreateDynamicObject(1280,1463.165,-1627.232,12.818,0.000,0.000,90.900,-1,-1,-1);
	tmpobjid = CreateDynamicObject(1280,1479.517,-1627.275,12.818,0.000,0.000,90.900,-1,-1,-1);
	obj = CreateDynamicObject(1280,1497.189,-1627.237,12.818,0.000,0.000,90.900,-1,-1,-1);
	return obj;
}

Login_CreateObjects()
{
	new tmpobjid;
	new st_obj = tmpobjid = CreateDynamicObject(18981,1485.895,-1775.065,68.843,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14650, "ab_trukstpc", "mp_CJ_WOOD5", 0xFF808080);
	tmpobjid = CreateDynamicObject(19356,1487.305,-1762.838,70.853,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "bbar_wall1", 0xFF808080);
	tmpobjid = CreateDynamicObject(19356,1487.555,-1762.838,70.853,0.000,-0.000,179.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "bbar_wall1", 0xFF808080);
	tmpobjid = CreateDynamicObject(19358,1487.541,-1762.822,68.563,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14853, "gen_pol_vegas", "mp_cop_panel", 0xFF808080);
	tmpobjid = CreateDynamicObject(19358,1487.301,-1762.852,68.563,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14853, "gen_pol_vegas", "mp_cop_panel", 0xFF808080);
	tmpobjid = CreateDynamicObject(18880,1489.332,-1764.328,69.343,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 14652, "ab_trukstpa", "wood01", 0xFF808080);
	SetDynamicObjectMaterial(tmpobjid, 3, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19297, "matlights", "invisible", 0x00000000);
	tmpobjid = CreateDynamicObject(18880,1489.542,-1764.328,69.343,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 14652, "ab_trukstpa", "wood01", 0xFF808080);
	SetDynamicObjectMaterial(tmpobjid, 3, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19297, "matlights", "invisible", 0x00000000);
	tmpobjid = CreateDynamicObject(19358,1485.728,-1762.851,68.563,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14853, "gen_pol_vegas", "mp_cop_panel", 0xFF808080);
	tmpobjid = CreateDynamicObject(19356,1485.728,-1762.837,70.853,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "bbar_wall1", 0xFF808080);
	tmpobjid = CreateDynamicObject(2559,1482.718,-1763.349,71.083,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14713, "lahss2aint2", "HS2_Curt3", 0xFFF0FFFF);
	tmpobjid = CreateDynamicObject(2559,1482.709,-1763.349,70.533,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14713, "lahss2aint2", "HS2_Curt3", 0xFFF0FFFF);
	tmpobjid = CreateDynamicObject(2559,1482.708,-1763.349,70.063,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14713, "lahss2aint2", "HS2_Curt3", 0xFFF0FFFF);
	tmpobjid = CreateDynamicObject(2559,1482.709,-1763.349,69.563,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14713, "lahss2aint2", "HS2_Curt3", 0xFFF0FFFF);
	tmpobjid = CreateDynamicObject(1897,1483.189,-1762.894,72.503,0.000,810.000,179.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14479, "skuzzy_motelmain", "mp_CJ_Laminate1", 0x00000000);
	tmpobjid = CreateDynamicObject(1735,1483.140,-1765.809,69.343,0.000,-0.000,164.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 2562, "cj_hotel_sw", "CJ-COUCHL1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
	tmpobjid = CreateDynamicObject(2894,1483.409,-1764.475,70.183,0.000,0.000,4.999);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFF0FFFF);
	tmpobjid = CreateDynamicObject(2268,1481.927,-1764.737,71.209,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0xFF808080);
	SetDynamicObjectMaterial(tmpobjid, 1, 14789, "ab_sfgymmain", "gym_floor6", 0xFF808080);
	tmpobjid = CreateDynamicObject(19356,1483.500,-1764.926,69.343,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_Rug", 0x00000000);
	tmpobjid = CreateDynamicObject(1897,1484.180,-1762.774,70.433,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "LAcreamwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(1897,1484.180,-1762.774,72.643,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "LAcreamwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(1897,1482.930,-1762.774,69.293,89.999,179.999,-89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "LAcreamwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(1897,1482.349,-1762.774,70.403,-0.000,179.999,-89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "LAcreamwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(1897,1482.950,-1762.749,72.403,89.999,0.000,-89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "LAcreamwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(11699,1483.250,-1762.755,69.393,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-40-percent", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19297, "matlights", "invisible", 0x00000000);
	tmpobjid = CreateDynamicObject(11699,1483.250,-1762.755,72.063,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-40-percent", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19297, "matlights", "invisible", 0x00000000);
	tmpobjid = CreateDynamicObject(1897,1482.990,-1762.747,71.523,89.999,0.000,-89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "LAcreamwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(11699,1482.870,-1762.755,71.563,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-40-percent", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19297, "matlights", "invisible", 0x00000000);
	tmpobjid = CreateDynamicObject(11699,1483.650,-1762.755,71.603,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-40-percent", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19297, "matlights", "invisible", 0x00000000);
	tmpobjid = CreateDynamicObject(11699,1481.390,-1762.755,70.893,89.999,179.999,-89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-40-percent", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19297, "matlights", "invisible", 0x00000000);
	tmpobjid = CreateDynamicObject(11699,1481.380,-1762.755,70.093,89.999,179.999,-89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-40-percent", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19297, "matlights", "invisible", 0x00000000);
	tmpobjid = CreateDynamicObject(1897,1482.349,-1762.774,72.603,-0.000,179.999,-89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 3820, "boxhses_sfsx", "LAcreamwall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19807,1482.766,-1764.597,70.239,0.000,0.000,20.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFF0FFFF);
	tmpobjid = CreateDynamicObject(19822,1484.153,-1764.314,70.169,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFF0FFFF);
	tmpobjid = CreateDynamicObject(19356,1480.801,-1762.838,70.853,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "bbar_wall1", 0xFF808080);
	tmpobjid = CreateDynamicObject(19358,1480.807,-1762.852,68.563,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14853, "gen_pol_vegas", "mp_cop_panel", 0xFF808080);
	tmpobjid = CreateDynamicObject(19432,1487.420,-1763.597,72.560,0.000,89.999,179.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0xFF808080);
	tmpobjid = CreateDynamicObject(11699,1481.572,-1762.755,72.043,89.999,179.999,-89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-40-percent", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19297, "matlights", "invisible", 0x00000000);
	tmpobjid = CreateDynamicObject(19356,1481.325,-1762.838,70.853,0.000,-0.000,179.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "bbar_wall1", 0xFF808080);
	tmpobjid = CreateDynamicObject(19358,1481.332,-1762.862,68.563,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14853, "gen_pol_vegas", "mp_cop_panel", 0xFF808080);
	tmpobjid = CreateDynamicObject(14455,1489.526,-1762.941,70.842,0.000,-0.000,179.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_CORD", 0x00000000);
	tmpobjid = CreateDynamicObject(14455,1487.457,-1768.161,70.842,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_CORD", 0x00000000);
	tmpobjid = CreateDynamicObject(19432,1483.940,-1763.597,72.560,0.000,89.999,179.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0xFF808080);
	tmpobjid = CreateDynamicObject(19432,1480.450,-1763.597,72.560,0.000,89.999,179.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0xFF808080);
	tmpobjid = CreateDynamicObject(19432,1481.210,-1766.127,72.560,-0.000,90.000,-89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0xFF808080);
	tmpobjid = CreateDynamicObject(19432,1487.710,-1766.127,72.560,-0.000,90.000,-89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0xFF808080);
	tmpobjid = CreateDynamicObject(19356,1487.555,-1765.977,70.853,0.000,-0.000,179.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "bbar_wall1", 0xFF808080);
	tmpobjid = CreateDynamicObject(2269,1481.924,-1763.804,71.203,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 2266, "picture_frame", "CJ_PAINTING14", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14581, "ab_mafiasuitea", "walp45S", 0xFF808080);
	SetDynamicObjectMaterial(tmpobjid, 2, 2266, "picture_frame", "CJ_PAINTING14", 0x00000000);
	tmpobjid = CreateDynamicObject(19358,1487.541,-1766.032,68.563,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14853, "gen_pol_vegas", "mp_cop_panel", 0xFF808080);
	tmpobjid = CreateDynamicObject(19358,1487.541,-1769.232,68.563,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14853, "gen_pol_vegas", "mp_cop_panel", 0xFF808080);
	tmpobjid = CreateDynamicObject(19356,1487.555,-1769.197,70.853,0.000,-0.000,179.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "bbar_wall1", 0xFF808080);
	tmpobjid = CreateDynamicObject(19432,1487.710,-1769.617,72.560,-0.000,90.000,-89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0xFF808080);
	tmpobjid = CreateDynamicObject(19432,1485.160,-1769.937,72.560,0.000,89.999,179.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0xFF808080);
	tmpobjid = CreateDynamicObject(19432,1481.699,-1769.937,72.562,0.000,89.999,179.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0xFF808080);
	tmpobjid = CreateDynamicObject(19432,1481.210,-1769.047,72.561,-0.000,90.000,-89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0xFF808080);
	tmpobjid = CreateDynamicObject(18880,1486.822,-1764.289,72.593,0.000,-89.999,-0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 14652, "ab_trukstpa", "wood01", 0xFF808080);
	SetDynamicObjectMaterial(tmpobjid, 3, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19297, "matlights", "invisible", 0x00000000);
	tmpobjid = CreateDynamicObject(18880,1481.902,-1764.168,72.594,0.000,-89.999,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 14652, "ab_trukstpa", "wood01", 0xFF808080);
	SetDynamicObjectMaterial(tmpobjid, 3, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19297, "matlights", "invisible", 0x00000000);
	tmpobjid = CreateDynamicObject(18880,1487.023,-1764.168,72.594,0.000,-89.999,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 14652, "ab_trukstpa", "wood01", 0xFF808080);
	SetDynamicObjectMaterial(tmpobjid, 3, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19297, "matlights", "invisible", 0x00000000);
	tmpobjid = CreateDynamicObject(18880,1486.933,-1764.288,72.594,0.000,-89.999,-0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 14652, "ab_trukstpa", "wood01", 0xFF808080);
	SetDynamicObjectMaterial(tmpobjid, 3, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19297, "matlights", "invisible", 0x00000000);
	tmpobjid = CreateDynamicObject(18880,1486.933,-1769.028,72.594,0.000,-89.999,-0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 14652, "ab_trukstpa", "wood01", 0xFF808080);
	SetDynamicObjectMaterial(tmpobjid, 3, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 4, 19297, "matlights", "invisible", 0x00000000);
	tmpobjid = CreateDynamicObject(18981,1485.084,-1775.065,73.223,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14479, "skuzzy_motelmain", "mp_CJ_Laminate1", 0xFFF0FFFF);
	tmpobjid = CreateDynamicObject(14793,1486.829,-1770.264,72.623,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19297, "matlights", "invisible", 0x00000000);
	tmpobjid = CreateDynamicObject(19358,1481.332,-1766.072,68.563,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14853, "gen_pol_vegas", "mp_cop_panel", 0xFF808080);
	tmpobjid = CreateDynamicObject(19358,1481.332,-1769.292,68.563,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14853, "gen_pol_vegas", "mp_cop_panel", 0xFF808080);
	tmpobjid = CreateDynamicObject(19358,1481.332,-1772.482,68.563,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14853, "gen_pol_vegas", "mp_cop_panel", 0xFF808080);
	tmpobjid = CreateDynamicObject(19356,1481.325,-1766.048,70.853,0.000,-0.000,179.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "bbar_wall1", 0xFF808080);
	tmpobjid = CreateDynamicObject(19356,1481.325,-1769.178,70.853,0.000,-0.000,179.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "bbar_wall1", 0xFF808080);
	tmpobjid = CreateDynamicObject(19356,1481.325,-1772.368,70.853,0.000,-0.000,179.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "bbar_wall1", 0xFF808080);
	tmpobjid = CreateDynamicObject(2269,1481.924,-1765.664,71.203,0.000,0.000,89.999);
	SetDynamicObjectMaterial(tmpobjid, 0, 2266, "picture_frame", "CJ_PAINTING35", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14581, "ab_mafiasuitea", "walp45S", 0xFF808080);
	SetDynamicObjectMaterial(tmpobjid, 2, 2266, "picture_frame", "CJ_PAINTING14", 0x00000000);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	CreateDynamicObject(346,1484.217,-1764.719,70.188,89.965,450.000,89.999);
	CreateDynamicObject(3801,1481.723,-1764.740,71.499,0.000,0.000,0.000);
	CreateDynamicObject(2205,1482.774,-1764.422,69.227,0.000,0.000,0.000);
	obj = CreateDynamicObject(3857,1485.863,-1762.751,70.313,0.000,0.000,44.999);
	for(new i = st_obj; i <= obj; i++)	Streamer_SetIntData(STREAMER_TYPE_OBJECT, i, E_STREAMER_WORLD_ID, 3);
	return obj;
}

Airport_CreateObjects()
{
	new tmpobjid, st_obj;
	
	//	Экстерьер
	//CreateDynamicObject(1340, 1679.52001, -2304.51977, 13.539, 0.0, 0.0, -90.0);	//	Ларек с хот-догами
	tmpobjid = CreateDynamicObject(4890, 1683.21875, -2328.42969, 11.875, 0.0, 0.0, 00.00, 0);	//	восстанавливаем здание аэропорта
	SetDynamicObjectMaterial(tmpobjid, 1, 18996, "mattextures", "sampblack", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 972, "tunnel", "corugwall1128", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 7, 19297, "matlights", "invisible", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 9, 4829, "airport_las", "fancy_slab128", 0x00000000);
	tmpobjid = CreateDynamicObject(4995, 1682.070312, -2330.609375, 16.898399, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
	tmpobjid = CreateDynamicObject(4996, 1690.570312, -2242.523437, 16.898399, 0.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
	tmpobjid = CreateDynamicObject(1495, 1687.312622, -2237.089843, 12.466872, 0.000000, -0.000045, 179.999572);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, 1685.817016, -2236.959716, 10.626861, -0.000053, 0.000000, -89.999832);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	tmpobjid = CreateDynamicObject(1495, 1685.822387, -2237.089843, 12.466872, 0.000000, -0.000045, 179.999572);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
	tmpobjid = CreateDynamicObject(327, 1685.886474, -2237.131591, 15.124835, 0.000000, -86.999931, 0.399978);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);

	//вирт мир 0
	st_obj = tmpobjid = CreateDynamicObject(4991, 1683.218750, -2242.960937, 11.789059, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 18996, "mattextures", "sampblack", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 972, "tunnel", "corugwall1128", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 7, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 9, 4829, "airport_las", "fancy_slab128", 0x00000000);
	tmpobjid = CreateDynamicObject(1495, 1684.134521, -2335.923583, 12.546875, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, 1685.630126, -2336.053710, 10.646862, 360.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 5, 10398, "countryclub_sfs", "hc_wall1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1687.251586, -2368.270996, 12.546875, 0.000000, 0.000007, 179.999893);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	
	//	ГЛАВНЫЕ ДВЕРИ
	tmpobjid = CreateDynamicObject(1495, 1684.134521, -2335.923583, 12.546875, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
	tmpobjid = CreateDynamicObject(1495, 1685.624755, -2335.923583, 12.546875, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
	

	tmpobjid = CreateDynamicObject(327, 1685.560668, -2335.881835, 15.204837, 0.000000, -86.999977, -179.600051);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, 1730.312377, -2336.053710, 10.646862, 0.000015, 0.000000, 89.999931);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, 1685.755981, -2368.140869, 10.646862, 0.000000, 0.000000, -89.999992);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1728.816772, -2335.923583, 12.546875, 0.000000, 0.000022, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
	tmpobjid = CreateDynamicObject(1495, 1730.307006, -2335.923583, 12.546875, 0.000000, 0.000022, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1730.242919, -2335.881835, 15.204837, -0.000000, -87.000000, -179.599914);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, 1642.187744, -2336.053710, 10.646862, 0.000022, 0.000000, 89.999908);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1685.761352, -2368.270996, 12.546875, 0.000000, 0.000007, 179.999893);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
	tmpobjid = CreateDynamicObject(1495, 1640.692138, -2335.923583, 12.546875, 0.000000, 0.000030, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
	tmpobjid = CreateDynamicObject(1495, 1642.182373, -2335.923583, 12.546875, 0.000000, 0.000030, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1642.118286, -2335.881835, 15.204837, -0.000000, -87.000007, -179.599868);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, 1634.107055, -2332.972900, 7.266853, 0.000038, 0.000000, 89.999862);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	tmpobjid = CreateDynamicObject(327, 1685.825439, -2368.312744, 15.204837, -0.000000, -86.999984, 0.399978);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1631.031372, -2332.862792, 5.866867, 0.000000, 0.000045, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
	tmpobjid = CreateDynamicObject(1495, 1632.521606, -2332.862792, 5.866867, 0.000000, 0.000045, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1632.457519, -2332.821044, 8.524829, -0.000000, -87.000022, -179.599777);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, 1631.107299, -2332.992919, 7.266857, 0.000038, 0.000000, 89.999862);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1731.851562, -2368.270996, 12.546875, 0.000000, 0.000000, 179.999847);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(19378, 1664.708984, -2332.992919, 7.266854, 0.000045, 0.000000, 89.999839);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, 1730.355957, -2368.140869, 10.646862, -0.000007, 0.000000, -89.999969);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1661.633300, -2332.862792, 5.866867, 0.000000, 0.000053, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
	tmpobjid = CreateDynamicObject(1495, 1663.123535, -2332.862792, 5.866867, 0.000000, 0.000053, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1663.059448, -2332.821044, 8.524829, -0.000000, -87.000030, -179.599731);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, 1661.709228, -2333.012939, 7.266856, 0.000045, 0.000000, 89.999839);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1730.361328, -2368.270996, 12.546875, 0.000000, 0.000000, 179.999847);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(19378, 1661.826904, -2240.142333, 7.266854, 0.000061, 0.000000, -90.000175);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	tmpobjid = CreateDynamicObject(327, 1730.425415, -2368.312744, 15.204837, 0.000000, -86.999977, 0.399978);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1664.902587, -2240.272460, 5.866867, 0.000000, 0.000068, 179.999938);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
	tmpobjid = CreateDynamicObject(1495, 1663.412353, -2240.272460, 5.866867, 0.000000, 0.000068, 179.999938);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1663.476440, -2240.314208, 8.524829, -0.000000, -87.000045, 0.400298);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, 1664.826660, -2240.122314, 7.266857, 0.000061, 0.000000, -90.000175);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1643.751708, -2368.270996, 12.546875, 0.000000, -0.000015, 179.999755);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(19378, 1631.124389, -2240.142333, 7.266854, 0.000053, 0.000000, -90.000152);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, 1642.256103, -2368.140869, 10.646862, -0.000022, 0.000000, -89.999923);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1634.200073, -2240.272460, 5.866867, 0.000000, 0.000061, 179.999893);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);
	tmpobjid = CreateDynamicObject(1495, 1632.709838, -2240.272460, 5.866867, 0.000000, 0.000061, 179.999893);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1632.773925, -2240.314208, 8.524829, -0.000000, -87.000038, 0.400298);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, 1634.124145, -2240.122314, 7.266857, 0.000053, 0.000000, -90.000152);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1642.261474, -2368.270996, 12.546875, 0.000000, -0.000015, 179.999755);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1642.325561, -2368.312744, 15.204837, 0.000000, -86.999961, 0.399978);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1643.831787, -2237.089843, 12.466872, 0.000000, -0.000038, 179.999618);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(19378, 1642.336181, -2236.959716, 10.626861, -0.000045, 0.000000, -89.999855);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1642.341552, -2237.089843, 12.466872, 0.000000, -0.000038, 179.999618);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1642.405639, -2237.131591, 15.124835, 0.000000, -86.999938, 0.399978);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1731.892333, -2237.089843, 12.466872, 0.000000, -0.000053, 179.999526);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(19378, 1730.396728, -2236.959716, 10.626861, -0.000061, 0.000000, -89.999809);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1730.402099, -2237.089843, 12.466872, 0.000000, -0.000053, 179.999526);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1730.466186, -2237.131591, 15.124835, 0.000000, -86.999923, 0.399978);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1728.775756, -2204.697265, 12.466872, 0.000000, -0.000053, -0.000534);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(19378, 1730.271362, -2204.827392, 10.626861, -0.000061, 0.000000, 90.000129);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1730.265991, -2204.697265, 12.466872, 0.000000, -0.000053, -0.000534);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1730.201904, -2204.655517, 15.124835, 0.000000, -86.999923, -179.599899);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1684.216064, -2204.697265, 12.466872, 0.000000, -0.000045, -0.000534);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(19378, 1685.711669, -2204.827392, 10.626861, -0.000053, 0.000000, 90.000106);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1685.706298, -2204.697265, 12.466872, 0.000000, -0.000045, -0.000534);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1685.642211, -2204.655517, 15.124835, 0.000000, -86.999931, -179.599853);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1640.715576, -2204.697265, 12.466872, 0.000000, -0.000038, -0.000534);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(19378, 1642.211181, -2204.827392, 10.626861, -0.000045, 0.000000, 90.000083);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1642.205810, -2204.697265, 12.466872, 0.000000, -0.000038, -0.000534);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1642.141723, -2204.655517, 15.124835, 0.000000, -86.999938, -179.599807);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1640.715576, -2335.982910, -3.713128, 0.000000, -0.000030, -0.000534);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(19378, 1642.211181, -2336.113037, -2.033140, -0.000038, 0.000000, 90.000061);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1642.205810, -2335.982910, -3.713128, 0.000000, -0.000030, -0.000534);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1642.141723, -2335.941162, -1.055165, 0.000000, -86.999946, -179.599761);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1684.275878, -2335.982910, -3.713128, -0.000000, -0.000015, -0.000534);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(19378, 1685.771484, -2336.113037, -2.033140, -0.000022, 0.000000, 90.000015);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1685.766113, -2335.982910, -3.713128, -0.000000, -0.000015, -0.000534);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1685.702026, -2335.941162, -1.055165, 0.000000, -86.999961, -179.599670);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1728.756103, -2335.982910, -3.713128, -0.000000, 0.000000, -0.000534);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(19378, 1730.251708, -2336.113037, -2.033140, -0.000007, 0.000000, 89.999969);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1730.246337, -2335.982910, -3.713128, -0.000000, 0.000000, -0.000534);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1730.182250, -2335.941162, -1.055165, -0.000000, -86.999977, -179.599578);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1731.812377, -2237.090820, -3.713128, -0.000000, 0.000007, 179.999359);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(19378, 1730.316772, -2236.960693, -2.033140, 0.000000, 0.000000, -90.000022);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1730.322143, -2237.090820, -3.713128, -0.000000, 0.000007, 179.999359);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1730.386230, -2237.132568, -1.055165, -0.000000, -86.999984, 0.400451);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1687.271484, -2237.090820, -3.713128, -0.000000, 0.000000, 179.999313);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(19378, 1685.775878, -2236.960693, -2.033140, -0.000007, 0.000000, -90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1685.781250, -2237.090820, -3.713128, -0.000000, 0.000000, 179.999313);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1685.845336, -2237.132568, -1.055165, -0.000000, -86.999977, 0.400451);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1643.750244, -2237.090820, -3.713128, -0.000000, -0.000007, 179.999267);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(19378, 1642.254638, -2236.960693, -2.033140, -0.000015, 0.000000, -89.999977);
	SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
	/*tmpobjid = CreateDynamicObject(1495, 1642.260009, -2237.090820, -3.713128, -0.000000, -0.000007, 179.999267);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19325, "lsmall_shops", "lsmall_window01", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 19595, "lsappartments1", "carpet4-256x256", 0x00000000);*/
	tmpobjid = CreateDynamicObject(327, 1642.324096, -2237.132568, -1.055165, 0.000000, -86.999969, 0.400451);
	SetDynamicObjectMaterial(tmpobjid, 0, 19130, "matarrows", "arrowedges1", 0x00000000);
	for(new i = st_obj; i <= tmpobjid; i++)	Streamer_SetIntData(STREAMER_TYPE_OBJECT, i, E_STREAMER_WORLD_ID, 0);


	//	Интерьер
	st_obj = tmpobjid = CreateDynamicObject(3657, 1654.116210, -2339.635742, 13.066200, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(2773, 1684.000000, -2350.517333, 13.065198, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(3969, 1702.771850, -2346.170410, 13.438698, 0.000000, 0.000000, 269.994995);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 2, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	//tmpobjid = CreateDynamicObject(19376, 1643.667114, -2233.012207, -3.818598, 0.000000, 90.000000, 0.000000);
	//SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1688.814453, -2347.310058, 12.470000, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1685.746093, -2340.752929, 12.470000, 0.000000, 90.000000, 179.994995);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1694.660766, -2340.742919, 12.470000, 0.000000, 90.000000, 179.994995);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1694.654541, -2350.370849, 12.472000, 0.000000, 90.000000, 179.994995);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1694.649658, -2360.006103, 12.470000, 0.000000, 90.000000, 179.994995);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1679.880981, -2347.303222, 12.472000, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1676.810424, -2340.753173, 12.470000, 0.000000, 90.000000, 179.994995);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1676.814819, -2353.804199, 12.470000, 0.000000, 90.000000, 179.994995);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	//tmpobjid = CreateDynamicObject(19376, 1643.667114, -2233.012207, -3.818599, 0.000000, 90.000000, 0.000000);
	//SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1688.744018, -2336.419921, 12.065898, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18762, 1667.565429, -2340.171386, 18.000000, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1660.699951, -2360.472167, 12.467000, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1676.813110, -2363.429443, 12.470000, 0.000000, 90.000000, 179.994995);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1673.895996, -2340.168701, 15.043897, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(19368, 1661.000000, -2343.407226, 10.824198, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concreteyellow256 copy", 0x00000000);
	tmpobjid = CreateDynamicObject(19368, 1661.000000, -2351.963867, 10.824198, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concreteyellow256 copy", 0x00000000);
	tmpobjid = CreateDynamicObject(18764, 1649.170043, -2347.699951, 15.000000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18764, 1649.169921, -2356.199951, 15.000000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18764, 1649.169921, -2339.199951, 15.000000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(19377, 1653.699951, -2357.406005, 12.470000, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	tmpobjid = CreateDynamicObject(19377, 1653.699218, -2346.481445, 12.470000, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	tmpobjid = CreateDynamicObject(19377, 1653.703247, -2351.790771, 12.473999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	tmpobjid = CreateDynamicObject(18764, 1649.170043, -2364.699951, 15.000000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1670.247070, -2360.472900, 12.470000, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1660.617187, -2351.951416, 12.467000, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1670.247802, -2351.953613, 12.470000, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1660.612304, -2343.424804, 12.467000, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	tmpobjid = CreateDynamicObject(19454, 1670.245239, -2343.432128, 12.470000, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14803, "bdupsnew", "Bdup2_carpet", 0x00000000);
	tmpobjid = CreateDynamicObject(3657, 1654.115844, -2364.405273, 13.066200, 0.000000, 0.000000, 179.994995);
	SetDynamicObjectMaterial(tmpobjid, 2, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(19368, 1661.000000, -2360.495849, 10.824198, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "concreteyellow256 copy", 0x00000000);
	tmpobjid = CreateDynamicObject(19087, 1661.164062, -2348.858398, 12.569700, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19087, 1661.155273, -2348.875976, 13.081700, 90.000000, 179.994995, 179.994995);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1661.404296, -2340.110351, 11.671998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19087, 1661.159179, -2340.387695, 13.081700, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19087, 1661.159179, -2340.387695, 12.565698, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19087, 1661.156250, -2357.566406, 13.081700, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19087, 1661.156250, -2357.566406, 12.567700, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19087, 1661.163452, -2366.036865, 12.567700, 90.000000, 180.000000, 180.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19087, 1661.160034, -2366.044921, 13.077698, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1661.397460, -2337.725585, 11.671998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1661.401367, -2346.199218, 11.671998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1661.394531, -2348.602539, 11.671998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1661.401367, -2354.903320, 11.671998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1661.400390, -2357.322265, 11.671998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1661.400024, -2363.382324, 11.671998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1661.400024, -2365.809570, 11.671998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(18980, 1673.895996, -2367.902343, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1673.895996, -2363.750976, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(2206, 1663.734619, -2345.672851, 12.517900, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-93-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1662.756835, -2345.625000, 14.175100, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1673.895996, -2345.639892, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1662.756835, -2346.625000, 14.173100, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(2206, 1663.740356, -2346.287841, 12.517900, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-93-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(2206, 1671.446289, -2345.654296, 12.527899, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-93-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1673.895996, -2346.639892, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(2206, 1671.445312, -2346.289306, 12.528499, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-93-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(2003, 1667.860351, -2345.960937, 13.854598, 0.000000, 270.000000, 270.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 16640, "a51", "airvent_gz", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19799, 1669.538085, -2346.566406, 12.973698, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "airvent_gz", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19799, 1667.523437, -2345.368164, 12.973698, 0.000000, 0.000000, 179.994995);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "airvent_gz", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(2003, 1669.143066, -2345.972167, 13.854598, 0.000000, 270.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 16640, "a51", "airvent_gz", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(2003, 1668.495117, -2345.969726, 13.855998, 0.000000, 270.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 16640, "a51", "airvent_gz", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18980, 1673.895996, -2354.199951, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1673.895996, -2355.199951, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(2206, 1671.434204, -2354.211914, 12.527899, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-93-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(2206, 1671.433471, -2354.780273, 12.529000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-93-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(7313, 1685.756591, -2336.898193, 16.537952, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19426, "all_walls", "vgsn_scrollsgn256", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1662.817871, -2355.202880, 14.175100, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(2206, 1663.796264, -2354.207763, 12.517998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-93-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(2206, 1663.792480, -2354.786865, 12.520000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-93-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(2003, 1667.941162, -2354.480224, 13.860097, 0.000000, 270.000000, 270.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 16640, "a51", "airvent_gz", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19799, 1667.614624, -2353.901611, 12.973698, 0.000000, 0.000000, 179.994995);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "airvent_gz", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19799, 1669.621582, -2355.050292, 12.973698, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "airvent_gz", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(2003, 1668.606201, -2354.468750, 13.855998, 0.000000, 270.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 16640, "a51", "airvent_gz", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(2003, 1669.261230, -2354.446777, 13.855998, 0.000000, 270.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 16640, "a51", "airvent_gz", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18980, 1662.800048, -2363.750732, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1662.800048, -2364.750000, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(2206, 1662.807739, -2363.796630, 12.517900, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-93-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(2206, 1662.807128, -2364.350830, 12.520000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-93-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(2206, 1669.627929, -2363.780273, 12.517900, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-93-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19799, 1666.204956, -2363.472900, 12.970000, 0.000000, 0.000000, 179.994995);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "airvent_gz", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18762, 1670.910766, -2363.751708, 15.047900, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(2003, 1666.541015, -2364.070556, 13.860097, 0.000000, 270.000000, 270.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 16640, "a51", "airvent_gz", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19799, 1668.212402, -2364.627929, 12.973698, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "airvent_gz", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(2003, 1667.220947, -2364.060302, 13.855998, 0.000000, 270.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 16640, "a51", "airvent_gz", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(2003, 1667.881103, -2364.063476, 13.855998, 0.000000, 270.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 16640, "a51", "airvent_gz", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(2206, 1669.622436, -2364.360595, 12.520000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-93-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(2393, 1664.000000, -2357.463867, 11.671998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19089, 1671.104614, -2357.702392, 12.558400, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1671.400024, -2357.460205, 11.671998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19089, 1671.104492, -2357.702148, 13.088398, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1664.000000, -2348.761230, 11.671998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19089, 1671.152587, -2348.996826, 13.088398, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1671.400024, -2348.754882, 11.671998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1674.112426, -2348.594482, 11.671998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19089, 1671.150756, -2348.994140, 12.554400, 90.000000, 180.000000, 270.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(18980, 1664.827026, -2340.182861, 22.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(19087, 1673.868530, -2348.823974, 13.081700, 90.000000, 179.994995, 179.994995);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19087, 1673.868164, -2348.823242, 12.559700, 90.000000, 179.994995, 179.994995);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1674.077026, -2357.299072, 11.671998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19087, 1673.836669, -2357.502685, 13.081700, 90.000000, 180.000000, 180.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19087, 1673.839599, -2357.520996, 12.553700, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(3657, 1658.474121, -2339.636718, 13.066200, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(3657, 1658.641357, -2364.394775, 13.066200, 0.000000, 0.000000, 179.994995);
	SetDynamicObjectMaterial(tmpobjid, 2, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(3657, 1680.858764, -2344.592041, 13.066200, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(3657, 1680.892211, -2343.193603, 13.066200, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(3657, 1680.949218, -2341.813720, 13.066200, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(3657, 1690.608154, -2344.582031, 13.066200, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(3657, 1690.648559, -2343.211914, 13.066200, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(3657, 1690.593627, -2341.845458, 13.066200, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(3657, 1690.599609, -2340.447998, 13.066200, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(3657, 1680.946411, -2340.456787, 13.066200, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 2, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1679.728149, -2359.123046, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1690.349365, -2359.116943, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(2393, 1699.007568, -2349.500000, 11.831998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19449, 1685.036376, -2352.054687, 12.066100, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18762, 1679.730590, -2367.735351, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18762, 1694.847778, -2336.419921, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18762, 1682.250732, -2336.419921, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1686.000000, -2336.419921, 18.000000, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1711.000000, -2336.419921, 18.000000, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1708.629394, -2349.382324, 18.000000, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1711.046142, -2357.420410, 16.549999, 90.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18754, 1662.294799, -2461.039794, 18.979400, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "ws_stationfloor", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1673.900024, -2349.399902, 18.000000, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1673.900024, -2374.399902, 18.000000, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1661.099975, -2363.747558, 18.000000, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1671.216796, -2368.730468, 18.000000, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1661.099975, -2354.204101, 18.000000, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1655.732421, -2336.297363, 18.000000, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);

	tmpobjid = CreateDynamicObject(19376, 1685.500000, -2340.750000, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT, tmpobjid, true);
	tmpobjid = CreateDynamicObject(19376, 1674.999023, -2340.750000, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT, tmpobjid, true);

	tmpobjid = CreateDynamicObject(18980, 1661.099975, -2345.629882, 18.000000, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18762, 1664.835937, -2338.172607, 18.000000, 0.000000, 90.000000, 270.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(2393, 1698.966186, -2352.815429, 11.831998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1698.687377, -2351.213867, 11.831998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1699.046630, -2342.317871, 11.831998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1698.716552, -2340.844238, 11.831998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1698.793823, -2339.229980, 11.831998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1707.842163, -2340.393554, 12.569998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1707.247802, -2339.044677, 12.305998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1707.213623, -2342.145019, 12.126000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19455, 1703.348144, -2351.429687, 13.525300, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	tmpobjid = CreateDynamicObject(19455, 1703.408203, -2340.942382, 13.485300, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	tmpobjid = CreateDynamicObject(2393, 1707.913574, -2351.827148, 12.569998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(18762, 1682.699951, -2359.125000, 18.000000, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1648.294799, -2349.699951, 18.000000, 90.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1670.927612, -2376.129638, 18.000000, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(327, 1685.804565, -2336.006103, 15.433898, 270.000000, 90.000000, 175.500000);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF101010);
	tmpobjid = CreateDynamicObject(19464, 1684.050048, -2332.928222, 15.098898, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, 1687.478149, -2332.972900, 15.098898, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, 1685.499145, -2334.249755, 15.098898, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	tmpobjid = CreateDynamicObject(955, 1674.826904, -2338.253662, 12.911100, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(18766, 1685.125976, -2359.129150, 15.000000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18766, 1679.737548, -2363.803222, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18766, 1690.348754, -2363.713134, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18766, 1695.503173, -2362.199951, 15.000000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18766, 1698.971557, -2361.503906, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18766, 1705.510375, -2336.419921, 15.000000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18766, 1703.474975, -2357.000000, 15.000000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18766, 1669.332275, -2340.164550, 15.000000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18763, 1665.841552, -2338.182617, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18763, 1672.874511, -2338.218017, 15.055898, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18981, 1658.997436, -2336.295410, 15.000000, 0.000000, 0.000000, 270.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18981, 1648.280883, -2350.389404, 15.000000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18981, 1661.008666, -2367.699951, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18981, 1708.645263, -2349.198730, 15.000000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18766, 1677.744750, -2368.730468, 15.000000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18763, 1672.894042, -2364.770019, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18763, 1672.894042, -2367.770019, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18763, 1671.929443, -2364.762451, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18763, 1671.929443, -2367.762451, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18766, 1671.243774, -2336.419921, 15.000000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18762, 1689.288452, -2336.419921, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1710.972045, -2357.000000, 18.000000, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1698.970947, -2369.003662, 18.000000, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1698.957153, -2356.985839, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18762, 1687.699951, -2359.125000, 18.000000, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18762, 1671.386718, -2340.169677, 18.000000, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1661.099975, -2346.629882, 18.000000, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1661.099975, -2355.204101, 18.000000, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1662.817993, -2354.202880, 14.175100, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1661.099975, -2364.747558, 18.000000, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18764, 1649.170043, -2364.699951, 20.000000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18764, 1649.169921, -2356.199951, 20.000000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18764, 1649.170043, -2347.699951, 20.000000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18764, 1649.169921, -2339.199951, 20.000000, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18763, 1650.182006, -2356.199951, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18763, 1650.182006, -2364.699951, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18766, 1668.251953, -2346.265869, 10.925998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(18766, 1668.251953, -2345.668701, 10.923998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(18766, 1668.251953, -2354.753662, 10.925998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(18766, 1668.251953, -2354.205810, 10.923998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(18766, 1667.749755, -2363.763427, 10.925998, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(18766, 1668.073242, -2364.344238, 10.927997, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1698.919555, -2362.199951, 18.000000, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1690.347045, -2371.839355, 18.000000, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1679.730346, -2371.524169, 18.000000, 90.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1695.999633, -2340.750000, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1706.500000, -2340.750000, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1706.500000, -2350.379882, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1696.001953, -2350.379882, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(2773, 1687.000000, -2350.586914, 13.065198, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(19579, 1688.649291, -2352.577392, 13.221597, 0.000007, 0.000012, -23.999994);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObject(19610, 1688.640747, -2352.591064, 13.472997, -89.999992, 89.999992, 30.999994);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObject(2266, 1688.843505, -2352.209472, 13.341197, 14.999987, -0.000012, 155.999984);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObject(2266, 1688.439208, -2353.070312, 13.597200, -14.999987, 0.000012, -23.999994);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 2772, "airp_prop", "CJ_AIR_1", 0x00000000);
	tmpobjid = CreateDynamicObject(14793, 1665.067626, -2350.166259, 18.366003, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	tmpobjid = CreateDynamicObject(14793, 1685.031005, -2346.562744, 18.366003, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	tmpobjid = CreateDynamicObject(18763, 1650.182006, -2347.699951, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18763, 1650.182006, -2339.199951, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19597, "lsbeachside", "carpet19-128x128", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1661.099975, -2367.689208, 18.000000, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(2393, 1700.552490, -2351.214355, 12.751999, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1702.914672, -2351.214355, 12.751999, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1702.894653, -2340.647705, 12.751999, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(2393, 1700.093261, -2340.647705, 12.751999, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19579, 1686.124511, -2352.416748, 13.221597, 0.000004, 0.000018, -19.399993);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObject(19610, 1686.117065, -2352.431152, 13.472997, -89.999992, 113.199172, 58.799167);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObject(2266, 1686.288574, -2352.034667, 13.341197, 14.999990, -0.000019, 160.599945);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObject(2266, 1685.954589, -2352.924804, 13.597200, -14.999990, 0.000019, -19.399990);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 2772, "airp_prop", "CJ_AIRP_S_1", 0x00000000);
	tmpobjid = CreateDynamicObject(19579, 1684.844360, -2352.464111, 13.221597, 0.000003, 0.000025, 33.599994);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObject(19610, 1684.851440, -2352.478759, 13.472997, -89.999992, 127.720764, 126.320732);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObject(2266, 1684.637939, -2352.103271, 13.341197, 14.999992, -0.000027, -146.400024);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObject(2266, 1685.147949, -2352.905517, 13.597200, -14.999992, 0.000027, 33.599990);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 2772, "airp_prop", "CJ_AIRP_S_2", 0x00000000);
	tmpobjid = CreateDynamicObject(19579, 1682.070312, -2352.458007, 13.221597, 0.000007, 0.000033, 25.800003);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObject(19610, 1682.075317, -2352.473388, 13.472997, -89.999992, 111.223983, 102.023948);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObject(2266, 1681.914672, -2352.072265, 13.341197, 14.999987, -0.000034, -154.199966);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
	tmpobjid = CreateDynamicObject(2266, 1682.311157, -2352.936523, 13.597200, -14.999987, 0.000034, 25.800001);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "ap_runwaysigns", 0x00000000);
	tmpobjid = CreateDynamicObject(14793, 1665.067626, -2359.250732, 18.366003, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	tmpobjid = CreateDynamicObject(14793, 1665.187744, -2343.028076, 18.366003, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	tmpobjid = CreateDynamicObject(19477, 1662.133300, -2346.145263, 15.999926, 0.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "PASSPORT\nCONTROL", 130, "Calibri", 90, 0, 0xFFDAA520, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19477, 1662.193359, -2354.669189, 15.999926, 0.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "PASSPORT\nCONTROL", 130, "Calibri", 90, 0, 0xFFDAA520, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(18762, 1675.768554, -2336.429931, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(18762, 1700.990478, -2336.429931, 15.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(19455, 1703.348144, -2351.109375, 13.145296, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	tmpobjid = CreateDynamicObject(19455, 1703.348144, -2351.890136, 13.145296, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	tmpobjid = CreateDynamicObject(19455, 1703.348144, -2341.703613, 13.145296, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	tmpobjid = CreateDynamicObject(19455, 1703.348144, -2340.382324, 13.145296, 0.000000, 90.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19480, "signsurf", "sign", 0x00000000);
	tmpobjid = CreateDynamicObject(18980, 1664.832031, -2337.302490, 22.000000, 0.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1426, "break_scaffold", "CJ_BLUE_WOOD", 0x00000000);
	tmpobjid = CreateDynamicObject(7313, 1685.756591, -2336.918212, 16.537952, 0.000000, 0.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 19480, "signsurf", "sign", 0x00000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Silver Break", 110, "courier", 55, 1, 0xFFDAA520, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19477, 1662.213378, -2364.215332, 15.999926, 0.000000, 0.000000, 180.000000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "PASSPORT\nCONTROL", 130, "Calibri", 90, 0, 0xFFDAA520, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19089, 1689.733520, -2335.956054, 15.068404, 90.000000, 0.000000, 90.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1560, "7_11_door", "CJ_CHROME2", 0xFF000000);
	tmpobjid = CreateDynamicObject(19376, 1685.500366, -2350.379882, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1675.000000, -2350.379882, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1675.000000, -2360.000000, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1685.500000, -2360.000000, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1695.999145, -2360.000000, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1706.500000, -2360.000000, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1664.500000, -2340.750000, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1664.500000, -2350.379882, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1664.500000, -2360.000000, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1654.000000, -2369.629882, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1654.000000, -2340.750000, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1654.000000, -2350.379882, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1654.000000, -2360.000000, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1664.500000, -2369.629882, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, 1675.000000, -2369.630126, 12.461999, 0.000000, 90.000000, 0.000000);
	SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "gun_floor1", 0x00000000);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	CreateDynamicObject(1569, 1648.739990, -2353.439941, 12.555898, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1569, 1648.734985, -2350.439941, 12.555898, 0.000000, 0.000000, 270.000000);
	CreateDynamicObject(1569, 1648.737915, -2361.936523, 12.555898, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1569, 1648.729492, -2358.947265, 12.555898, 0.000000, 0.000000, 270.000000);
	CreateDynamicObject(1569, 1648.726684, -2341.955566, 12.555898, 0.000000, 0.000000, 270.000000);
	CreateDynamicObject(1569, 1648.736083, -2344.930419, 12.555898, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19466, 1661.159179, -2356.356445, 12.100000, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19624, 1701.801635, -2348.966796, 13.566800, 0.000000, 0.000000, 14.000000);
	CreateDynamicObject(19466, 1661.159179, -2347.639648, 12.100000, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19466, 1661.160034, -2364.835937, 12.100000, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19466, 1661.159179, -2339.153320, 12.100000, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(8979, 1691.041992, -2345.284179, 11.122200, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(2190, 1664.787231, -2345.917480, 13.454400, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19808, 1665.147338, -2346.607666, 13.470499, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19786, 1662.267944, -2346.159667, 16.000000, 0.000000, 0.000000, -90.000000);
	CreateDynamicObject(8979, 1691.065795, -2353.884521, 11.122200, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(8979, 1691.058837, -2363.470703, 11.122200, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19325, 1667.500000, -2357.701660, 11.017000, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19466, 1673.874145, -2347.596435, 12.100000, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19325, 1667.500000, -2349.000000, 11.017000, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19466, 1673.829956, -2356.331542, 12.100000, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(2796, 1675.005981, -2364.241455, 16.147800, 0.000000, 0.000000, 180.000000);
	CreateDynamicObject(2792, 1651.205200, -2361.490234, 16.736398, 0.000000, 0.000000, 270.000000);
	CreateDynamicObject(2793, 1651.106201, -2352.912597, 16.736398, 0.000000, 0.000000, 268.000000);
	CreateDynamicObject(2794, 1651.111083, -2344.489257, 16.736398, 0.000000, 0.000000, 270.000000);
	CreateDynamicObject(19325, 1680.221435, -2355.383789, 11.750000, 0.000000, 0.000000, 180.000000);
	CreateDynamicObject(19325, 1689.844970, -2355.446289, 11.750000, 0.000000, 0.000000, 180.000000);
	CreateDynamicObject(2173, 1685.000000, -2352.641845, 12.547900, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(2173, 1687.806030, -2352.669921, 12.547900, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(2173, 1682.001098, -2352.654052, 12.547900, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19325, 1690.584960, -2335.959960, 12.987998, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19325, 1680.973632, -2335.959960, 12.987998, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(1714, 1664.485839, -2365.840332, 12.547900, 0.000000, 0.000000, 180.000000);
	CreateDynamicObject(1714, 1669.664672, -2365.947753, 12.547900, 0.000000, 0.000000, 179.994995);
	CreateDynamicObject(1714, 1665.640991, -2356.376708, 12.547900, 0.000000, 0.000000, 179.994995);
	CreateDynamicObject(1714, 1665.295654, -2347.958740, 12.547900, 0.000000, 0.000000, 179.994995);
	CreateDynamicObject(1714, 1672.108642, -2348.013427, 12.547900, 0.000000, 0.000000, 179.994995);
	CreateDynamicObject(1714, 1671.220214, -2356.456298, 12.547900, 0.000000, 0.000000, 179.994995);
	CreateDynamicObject(2190, 1665.321166, -2354.443115, 13.456500, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19808, 1665.632568, -2355.066650, 13.472599, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(2190, 1664.245239, -2364.053710, 13.456500, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19808, 1664.456542, -2364.660888, 13.472599, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(1714, 1682.512207, -2353.750732, 12.547900, 0.000000, 0.000000, 179.994995);
	CreateDynamicObject(1714, 1685.500000, -2353.768066, 12.547900, 0.000000, 0.000000, 179.994995);
	CreateDynamicObject(1714, 1688.351806, -2353.773925, 12.547900, 0.000000, 0.000000, 179.994995);
	CreateDynamicObject(1569, 1689.559692, -2358.679931, 12.515898, 0.000000, 0.000000, 180.000000);
	CreateDynamicObject(1569, 1695.479614, -2361.739257, 12.555899, 0.000000, 0.000000, 180.000000);
	CreateDynamicObject(2163, 1685.446655, -2358.621337, 12.547900, 0.000000, 0.000000, 179.994995);
	CreateDynamicObject(1572, 1706.440551, -2355.480957, 13.118598, 0.000000, 0.000000, 42.000000);
	CreateDynamicObject(1572, 1705.321044, -2347.562500, 13.118598, 0.000000, 0.000000, 81.995002);
	CreateDynamicObject(2885, 1703.848388, -2349.163330, 13.128800, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(2885, 1703.854614, -2338.623535, 13.128800, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(2885, 1707.126586, -2347.095947, 13.128800, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(2885, 1704.055419, -2343.279052, 13.128800, 0.000000, 0.000000, 180.000000);
	CreateDynamicObject(2885, 1704.109252, -2353.784423, 13.128800, 0.000000, 0.000000, 179.994995);
	CreateDynamicObject(2885, 1708.291992, -2347.108154, 13.468798, 35.750000, 0.000000, 90.000000);
	CreateDynamicObject(2790, 1708.187377, -2346.062500, 15.456100, 0.000000, 0.000000, 270.000000);
	CreateDynamicObject(2789, 1684.664794, -2358.667724, 16.061107, 0.000000, 0.000000, 180.000000);
	CreateDynamicObject(2790, 1658.764770, -2336.718017, 15.610198, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(2789, 1656.400878, -2367.203369, 15.741100, 0.000000, 0.000000, 179.994995);
	CreateDynamicObject(1569, 1677.640136, -2368.279785, 12.555899, 0.000000, 0.000000, 180.000000);
	CreateDynamicObject(19624, 1704.908569, -2338.545410, 13.548800, 0.000000, 0.000000, 13.996998);
	CreateDynamicObject(19810, 1687.638549, -2358.617431, 14.347497, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19325, 1685.800048, -2335.959960, 17.114200, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19325, 1679.156982, -2335.959960, 17.114200, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19325, 1692.443481, -2335.959960, 17.114200, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19325, 1697.227539, -2335.959960, 12.987998, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19325, 1674.330322, -2335.959960, 12.987998, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19810, 1693.539428, -2361.697265, 14.347497, 0.000000, 0.000000, 0.000000);
	CreateDynamicObject(19325, 1699.085449, -2335.959960, 17.114200, 0.000000, 0.000000, 90.000000);
	CreateDynamicObject(19786, 1662.362548, -2354.675537, 16.000000, 0.000000, 0.000000, -90.000000);
	CreateDynamicObject(19786, 1662.362548, -2364.191894, 16.000000, 0.000000, 0.000000, -90.000000);
	CreateDynamicObject(1572, 1704.324462, -2355.490234, 13.118598, 0.000000, 0.000000, 60.500000);
	CreateDynamicObject(19808, 1688.275390, -2352.787109, 13.362600, 0.000000, 0.000007, 0.000000);
	CreateDynamicObject(19808, 1685.635375, -2352.787109, 13.362600, 0.000000, 0.000007, 0.000000);
	obj = CreateDynamicObject(19808, 1682.574829, -2352.787109, 13.362600, 0.000000, 0.000007, 0.000000);
	for(new i = st_obj; i <= obj; i++)	Streamer_SetIntData(STREAMER_TYPE_OBJECT, i, E_STREAMER_WORLD_ID, 2);
	return obj;
}

Farm_CreateObjects()
{
	CreateDynamicObject(2911, -1061.495239, -1204.93798, 128.61872, 0.00000, 0.00000, -89.70001);	//	дверь
	CreateDynamicObject(12921, -1048.93982, -1313.23682, 134.19460,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(12921, -1048.93982, -1313.24280, 127.60890,   0.00000, 180.00000, 180.00000);
	CreateDynamicObject(3276, -1062.99963, -1313.57874, 129.06250,   356.85840, 0.00000, 0.00000);
	CreateDynamicObject(3276, -1035.78076, -1315.08057, 129.09151,   357.00000, -4.00000, 0.00000);
	CreateDynamicObject(691, -1068.46167, -1310.75305, 128.35159,   3.00000, 0.00000, -149.00000);
	CreateDynamicObject(12915, -1078.16382, -1272.57898, 128.21629,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(12915, -1108.79785, -1272.57898, 128.21629,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(705, -1118.59082, -1287.13806, 128.07030,   3.00000, 0.00000, -18.00000);
	CreateDynamicObject(823, -1071.75134, -1286.66406, 129.62260,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(705, -1115.92236, -1250.39026, 128.11780,   3.14160, 0.00000, 3.04560);
	CreateDynamicObject(691, -1081.98730, -1258.77246, 128.07809,   357.00000, 0.00000, 49.00000);
	CreateDynamicObject(691, -1175.23438, -1152.12231, 127.63281,   356.85840, 0.00000, 3.14159);
	CreateDynamicObject(17061, -1104.45959, -1235.95337, 128.23039,   0.00000, 0.00000, -4.00000);
	CreateDynamicObject(3425, -1063.28735, -1225.51306, 132.14900,   0.00000, 0.00000, 69.00000);
	CreateDynamicObject(17010, -1135.32580, -1154.74707, 128.21875,	0.0, 0.0, -3.141);
	CreateDynamicObject(17010, -1149.90881, -1154.75232, 128.21875,   0.0, 0.0, -3.141);
	CreateDynamicObject(17010, -1164.55640, -1154.76343, 128.21875,   0.0, 0.0, -3.141);
	CreateDynamicObject(17324, -1211.00671, -949.44281, 127.47900,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18269, -1200.91101, -994.92181, 149.56310,   0.00000, 0.00000, -46.00000);
	CreateDynamicObject(18269, -1200.78088, -1020.91138, 149.56310,   0.00000, 0.00000, -46.00000);
	CreateDynamicObject(789, -1000.94928, -1123.81299, 124.77320,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(789, -1001.87921, -1196.00586, 124.77320,   0.00000, 0.00000, 113.00000);
	CreateDynamicObject(708, -1172.87732, -1129.21118, 128.44530,   357.00000, 0.00000, 76.00000);
	CreateDynamicObject(847, -1060.90967, -1162.39221, 130.09930,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(691, -1045.19775, -1100.74792, 128.58591,   357.00000, 0.00000, 40.00000);
	CreateDynamicObject(789, -1001.48969, -1280.75977, 124.77320,   0.00000, 0.00000, 113.00000);
	CreateDynamicObject(714, -1163.44385, -1260.00012, 153.91229,   3.00000, -6.00000, 18.00000);
	CreateDynamicObject(703, -1105.91040, -1137.17700, 127.59870,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14872, -1036.34045, -1176.74780, 128.65440,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1463, -1033.95386, -1179.02759, 128.55420,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1463, -1036.11157, -1178.89099, 128.55420,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1463, -1036.08557, -1179.34509, 129.17020,   -89.00000, 0.00000, 0.00000);
	CreateDynamicObject(1463, -1033.95081, -1179.34912, 129.17020,   -89.00000, 0.00000, 0.00000);
	CreateDynamicObject(731, -1135.35510, -1127.01831, 128.19380,   0.00000, 0.00000, 62.00000);
	CreateDynamicObject(705, -1152.94189, -1143.48120, 128.11481,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(703, -1168.80151, -1139.18530, 115.80130,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(703, -1165.15149, -1131.07422, 115.80130,   0.00000, 0.00000, 215.00000);
	CreateDynamicObject(703, -1146.78674, -1143.41528, 115.80130,   0.00000, 0.00000, 215.00000);
	CreateDynamicObject(703, -1128.52258, -1134.86707, 115.80130,   0.00000, 0.00000, 98.00000);
	CreateDynamicObject(703, -1115.24414, -1129.83252, 115.80130,   0.00000, 0.00000, 33.00000);
	CreateDynamicObject(703, -1101.70483, -1138.70129, 122.86510,   0.00000, 76.00000, 0.00000);
	CreateDynamicObject(700, -1064.80505, -1102.11584, 128.36880,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(700, -1091.26904, -1102.45349, 128.36880,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(700, -1119.66431, -1102.53162, 128.36880,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(700, -1150.25452, -1103.88708, 128.36880,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(700, -1179.25891, -1104.32275, 128.36880,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(700, -1194.85925, -1081.38501, 128.36880,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(703, -1192.43433, -1086.69922, 115.80130,   0.00000, 0.00000, 98.00000);
	CreateDynamicObject(790, -1175.87854, -1087.11389, 132.94531,   356.85840, 0.00000, -0.54780);
	CreateDynamicObject(703, -1157.71985, -1096.09155, 115.80130,   0.00000, 0.00000, 98.00000);
	CreateDynamicObject(703, -1166.71277, -1079.94861, 115.80130,   0.00000, 0.00000, 68.00000);
	CreateDynamicObject(703, -1112.20056, -1088.25952, 115.80130,   0.00000, 0.00000, 33.00000);
	CreateDynamicObject(703, -1130.27966, -1074.11865, 115.80130,   0.00000, 0.00000, 207.00000);
	CreateDynamicObject(703, -1106.11743, -1095.06104, 115.80130,   0.00000, 0.00000, 207.00000);
	CreateDynamicObject(703, -1042.14026, -1081.20044, 115.80130,   0.00000, 0.00000, 98.00000);
	CreateDynamicObject(705, -1225.26050, -1172.94470, 127.87840,   356.85840, 0.00000, -2.08570);
	CreateDynamicObject(790, -1232.93030, -1192.16895, 130.75000,   357.00000, 0.00000, -113.00000);
	CreateDynamicObject(17033, -1062.71301, -1080.22424, 127.37580,   3.14160, 0.00000, 3.14160);
	CreateDynamicObject(703, -1065.49585, -1084.41113, 115.80130,   0.00000, 0.00000, 98.00000);
	CreateDynamicObject(703, -1026.42749, -1141.10278, 115.80130,   0.00000, 0.00000, 76.00000);
	CreateDynamicObject(703, -1034.88000, -1143.98486, 115.80130,   0.00000, 0.00000, 149.00000);
	CreateDynamicObject(703, -1032.65576, -1158.33643, 115.80130,   0.00000, 0.00000, 149.00000);
	CreateDynamicObject(790, -1181.52795, -1224.84717, 130.71091,   -17.00000, 4.00000, 2.00000);
	CreateDynamicObject(703, -1116.62622, -1145.25232, 115.80130,   0.00000, 0.00000, 215.00000);
	CreateDynamicObject(703, -1155.05188, -1231.45789, 117.77630,   0.00000, 0.00000, 215.00000);
	CreateDynamicObject(703, -1175.03223, -1231.46204, 120.30430,   0.00000, 0.00000, 215.00000);
	CreateDynamicObject(703, -1199.89417, -1228.47180, 120.30430,   0.00000, 0.00000, 215.00000);
	CreateDynamicObject(789, -1192.00549, -1267.43323, 140.02020,   -16.00000, 4.00000, 0.00000);
	CreateDynamicObject(790, -1203.79822, -915.76160, 132.06239,   356.85840, 0.00000, -1.94410);
	CreateDynamicObject(708, -1228.88855, -926.36395, 112.27060,   3.00000, 55.00000, 1.00000);
	CreateDynamicObject(17057, -1097.52246, -1236.07031, 127.85220,   0.00000, 0.00000, 88.00000);
	CreateDynamicObject(791, -1119.71985, -1307.98718, 127.00340,   356.85840, 0.00000, 3.14160);
	CreateDynamicObject(703, -1116.40405, -1315.98450, 115.80130,   0.00000, 0.00000, 149.00000);
	CreateDynamicObject(700, -1067.21021, -1338.56958, 128.94460,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(700, -1035.24194, -1348.67114, 128.94460,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(700, -1038.71472, -1327.23718, 128.94460,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(700, -1061.30835, -1325.60229, 128.94460,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(823, -1068.02844, -1318.80298, 129.80611,   0.00000, 0.00000, -36.00000);
	CreateDynamicObject(3276, -1063.05261, -1318.51245, 129.06250,   357.00000, 1.00000, 69.00000);
	CreateDynamicObject(3276, -1067.12402, -1328.84680, 129.45250,   357.00000, 2.00000, 68.00000);
	CreateDynamicObject(3276, -1074.87183, -1332.82275, 129.71249,   357.00000, -1.20000, -14.00000);
	CreateDynamicObject(3276, -1086.15588, -1330.00562, 129.32249,   357.00000, -2.00000, -14.00000);
	CreateDynamicObject(3276, -1095.93054, -1319.49536, 129.06250,   357.00000, 0.00000, -90.00000);
	CreateDynamicObject(705, -1093.70850, -1328.32239, 128.07030,   3.00000, 0.00000, -33.00000);
	CreateDynamicObject(823, -1077.43542, -1318.68103, 129.80611,   0.00000, 0.00000, -36.00000);
	CreateDynamicObject(823, -1086.54089, -1318.50073, 129.80611,   0.00000, 0.00000, -36.00000);
	CreateDynamicObject(823, -1071.57666, -1327.87720, 129.80611,   0.00000, 0.00000, 33.00000);
	CreateDynamicObject(823, -1079.38586, -1325.95532, 129.80611,   0.00000, 0.00000, 33.00000);
	CreateDynamicObject(823, -1086.52563, -1325.02417, 129.80611,   0.00000, 0.00000, 33.00000);
	CreateDynamicObject(703, -1106.18164, -1322.97205, 115.80130,   0.00000, 0.00000, 207.00000);
	CreateDynamicObject(703, -1108.66357, -1301.36316, 115.80130,   0.00000, 0.00000, 207.00000);
	CreateDynamicObject(824, -1030.18250, -1290.75793, 129.71440,   0.00000, -2.00000, 0.00000);
	CreateDynamicObject(3276, -1020.42981, -1279.97119, 130.21750,   3.14160, 0.00000, 90.00000);
	CreateDynamicObject(3276, -1020.36438, -1268.21118, 130.21750,   3.14160, 0.00000, 90.00000);
	CreateDynamicObject(3276, -1026.88147, -1262.42078, 129.82750,   3.00000, -5.00000, 0.00000);
	CreateDynamicObject(3276, -1020.34943, -1291.98206, 130.21750,   3.14160, 0.00000, 90.00000);
	CreateDynamicObject(3276, -1020.26514, -1303.89734, 130.21750,   3.14160, 0.00000, 90.00000);
	CreateDynamicObject(705, -1026.91663, -1230.26331, 128.27780,   3.00000, 0.00000, 222.00000);
	CreateDynamicObject(708, -1027.98755, -1253.26758, 128.39780,   356.85840, 0.00000, 3.14160);
	CreateDynamicObject(703, -1064.60620, -1245.10339, 116.06120,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(703, -1025.35803, -1241.85461, 116.06120,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(703, -1011.08722, -1233.26135, 116.06120,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(703, -988.05054, -1231.97009, 116.06120,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(791, -1000.84601, -1352.64624, 136.75340,   357.00000, -6.00000, 33.00000);
	CreateDynamicObject(703, -1025.44629, -1307.41516, 115.02120,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(703, -1027.72302, -1329.07092, 122.43120,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(703, -1018.96771, -1341.72827, 124.51120,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(703, -1011.75458, -1357.50403, 129.58121,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(703, -996.68903, -1329.25916, 126.72120,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(791, -959.24878, -1329.56555, 136.17970,   356.85840, 0.00000, 3.14160);
	CreateDynamicObject(789, -952.41162, -1292.02979, 134.26320,   0.00000, 0.00000, 113.00000);
	CreateDynamicObject(789, -975.88037, -1353.26489, 141.54320,   0.00000, 0.00000, 113.00000);
	CreateDynamicObject(703, -1140.87329, -1312.71570, 125.94130,   0.00000, 0.00000, 207.00000);
	CreateDynamicObject(703, -1148.76514, -1283.57056, 136.60130,   0.00000, 6.00000, 207.00000);
	CreateDynamicObject(703, -1158.99670, -1315.52283, 139.07130,   0.00000, 6.00000, 207.00000);
	CreateDynamicObject(705, -1169.35950, -1306.99658, 151.08031,   3.00000, 0.00000, -33.00000);
	CreateDynamicObject(703, -1177.66040, -1324.69446, 139.07130,   0.00000, 6.00000, 207.00000);
	CreateDynamicObject(703, -1174.89941, -1296.08179, 140.89130,   0.00000, -25.00000, 207.00000);
	CreateDynamicObject(1257, -1059.93335, -1360.02197, 130.31931,   1.00000, -2.00000, -111.00000);
	CreateDynamicObject(1257, -1081.43140, -1338.12488, 129.66930,   -2.00000, -2.00000, 74.00000);
	CreateDynamicObject(700, -1072.74951, -1357.46509, 128.94460,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(700, -1092.85107, -1352.38159, 128.94460,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(700, -1112.89844, -1348.77979, 128.68460,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(700, -1048.86523, -1367.16504, 129.85460,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(700, -1024.00342, -1381.03235, 129.59460,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(700, -1004.30072, -1393.44788, 129.72459,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(703, -1042.00610, -1379.70496, 118.92120,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(703, -1072.78503, -1368.63391, 117.88120,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(703, -1058.45667, -1389.78918, 117.88120,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(703, -1102.67334, -1358.40540, 117.88120,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(703, -1012.59473, -1396.37646, 116.71120,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(824, -1030.44348, -1296.78674, 129.71440,   0.00000, -2.00000, 0.00000);
	CreateDynamicObject(824, -1023.23718, -1297.23047, 129.71440,   0.00000, -2.00000, 0.00000);
	CreateDynamicObject(824, -1023.94196, -1290.72034, 129.71440,   0.00000, -2.00000, 0.00000);
	CreateDynamicObject(824, -1030.06567, -1284.45276, 129.71440,   0.00000, -2.00000, 0.00000);
	CreateDynamicObject(824, -1024.10706, -1284.28638, 129.71440,   0.00000, -2.00000, 0.00000);
	CreateDynamicObject(824, -1023.90527, -1277.61072, 129.71440,   0.00000, -2.00000, 0.00000);
	CreateDynamicObject(824, -1024.03101, -1271.24182, 129.71440,   0.00000, -2.00000, 0.00000);
	CreateDynamicObject(824, -1024.02173, -1265.10730, 129.71440,   0.00000, -2.00000, 0.00000);
	CreateDynamicObject(824, -1029.75073, -1264.88440, 129.71440,   0.00000, -2.00000, 0.00000);
	CreateDynamicObject(824, -1029.88171, -1271.45654, 129.71440,   0.00000, -2.00000, 0.00000);
	CreateDynamicObject(824, -1029.93140, -1277.71729, 129.71440,   0.00000, -2.00000, 0.00000);
	CreateDynamicObject(3374, -1208.12878, -1153.71057, 129.70309,   357.00000, 0.00000, 1.00000);
	CreateDynamicObject(3374, -1202.79248, -1153.47107, 129.70309,   357.00000, 0.00000, 1.00000);
	CreateDynamicObject(3374, -1197.01147, -1153.40259, 129.70309,   357.00000, 0.00000, -1.00000);
	CreateDynamicObject(3374, -1190.95679, -1153.36560, 129.70309,   357.00000, 0.00000, -3.00000);
	CreateDynamicObject(3374, -1213.44434, -1153.79919, 129.70309,   357.00000, 0.00000, 1.00000);
	obj = CreateDynamicObject(3276, -1088.41589, -1226.7163, 129.0687, 0.0, 0.0, 90.0);
	return obj;
}

CityHall_Int_CreateObjects()
{
	//Objects////////////////////////////////////////////////////////////////////////////////////////////////////////
	new tmpobjid;
	tmpobjid = CreateDynamicObject(19379,1565.645,-1565.675,1000.000,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", -1);
	tmpobjid = CreateDynamicObject(19379,1565.645,-1556.064,1000.000,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", -1);
	tmpobjid = CreateDynamicObject(19379,1565.644,-1575.417,1000.000,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", -1);
	tmpobjid = CreateDynamicObject(19379,1576.145,-1575.129,1000.000,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", -1);
	tmpobjid = CreateDynamicObject(19379,1576.145,-1565.494,1000.000,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", -1);
	tmpobjid = CreateDynamicObject(19379,1576.145,-1555.862,1000.000,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", -1);
	tmpobjid = CreateDynamicObject(19461,1572.541,-1556.968,1005.335,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19462,1577.130,-1566.151,1003.494,0.000,90.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", 0);
	tmpobjid = CreateDynamicObject(19379,1577.723,-1557.036,1001.674,0.000,90.059,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", -1);
	tmpobjid = CreateDynamicObject(19369,1571.869,-1561.758,999.802,34.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14846, "genintintpoliceb", "p_floor3", -1);
	SetDynamicObjectMaterial(tmpobjid, 1, 14760, "sfhosemed2", "walp40S", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19369,1572.310,-1563.984,1001.533,33.997,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14846, "genintintpoliceb", "p_floor3", -1);
	SetDynamicObjectMaterial(tmpobjid, 1, 14760, "sfhosemed2", "walp40S", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19442,1572.326,-1562.468,1000.403,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14846, "genintintpoliceb", "p_floor3", 0);
	tmpobjid = CreateDynamicObject(19442,1570.359,-1561.755,998.604,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14846, "genintintpoliceb", "p_floor3", 0);
	tmpobjid = CreateDynamicObject(19369,1572.306,-1565.942,1002.758,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14846, "genintintpoliceb", "p_floor3", -1);
	SetDynamicObjectMaterial(tmpobjid, 1, 14760, "sfhosemed2", "walp40S", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19369,1572.307,-1569.333,1002.758,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14846, "genintintpoliceb", "p_floor3", -1);
	SetDynamicObjectMaterial(tmpobjid, 1, 14760, "sfhosemed2", "walp40S", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19369,1572.306,-1565.942,999.059,0.000,180.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14846, "genintintpoliceb", "p_floor3", -1);
	SetDynamicObjectMaterial(tmpobjid, 1, 14760, "sfhosemed2", "walp40S", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19369,1572.310,-1569.151,999.059,0.000,180.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14846, "genintintpoliceb", "p_floor3", -1);
	SetDynamicObjectMaterial(tmpobjid, 1, 14760, "sfhosemed2", "walp40S", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19462,1577.133,-1568.998,1003.502,0.000,90.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", 0);
	tmpobjid = CreateDynamicObject(19369,1572.317,-1571.290,1001.533,33.992,0.000,359.993,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14846, "genintintpoliceb", "p_floor3", -1);
	SetDynamicObjectMaterial(tmpobjid, 1, 14760, "sfhosemed2", "walp40S", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19369,1572.312,-1566.567,1002.757,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14846, "genintintpoliceb", "p_floor3", -1);
	SetDynamicObjectMaterial(tmpobjid, 1, 14760, "sfhosemed2", "walp40S", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19379,1577.655,-1578.062,1001.674,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", -1);
	tmpobjid = CreateDynamicObject(19442,1572.327,-1572.796,1000.403,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14846, "genintintpoliceb", "p_floor3", 0);
	tmpobjid = CreateDynamicObject(19369,1571.878,-1573.510,999.802,33.997,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14846, "genintintpoliceb", "p_floor3", -1);
	SetDynamicObjectMaterial(tmpobjid, 1, 14760, "sfhosemed2", "walp40S", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19442,1570.369,-1573.520,998.604,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14846, "genintintpoliceb", "p_floor3", 0);
	tmpobjid = CreateDynamicObject(19461,1572.541,-1578.291,1001.835,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1577.202,-1574.651,1001.835,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1577.203,-1560.489,1001.835,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1577.197,-1561.307,1005.335,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1577.196,-1573.900,1005.335,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19369,1577.182,-1567.580,1007.810,0.000,0.000,179.899,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", -1);
	SetDynamicObjectMaterial(tmpobjid, 1, 14760, "sfhosemed2", "walp40S", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19379,1555.140,-1556.084,1000.000,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", -1);
	tmpobjid = CreateDynamicObject(19379,1555.145,-1565.684,1000.000,0.000,90.120,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", -1);
	tmpobjid = CreateDynamicObject(19379,1555.145,-1575.420,1000.000,0.000,89.940,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", -1);
	tmpobjid = CreateDynamicObject(19450,1577.161,-1560.468,1000.153,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1577.291,-1556.973,1000.153,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1577.232,-1578.286,1000.153,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1577.183,-1577.442,1000.153,0.000,0.000,179.994,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1569.250,-1556.993,997.757,325.997,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1577.082,-1556.983,1000.153,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1569.192,-1578.281,997.757,325.992,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1577.026,-1578.276,1000.153,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1577.186,-1561.260,999.557,325.992,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1577.176,-1574.050,999.551,325.992,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2446,1568.260,-1564.359,1000.085,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "cd_tex2", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14387, "dr_gsnew", "AH_flroortile12", 0);
	tmpobjid = CreateDynamicObject(2446,1568.259,-1571.081,1000.085,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "cd_tex2", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14387, "dr_gsnew", "AH_flroortile12", 0);
	tmpobjid = CreateDynamicObject(2446,1568.264,-1565.358,1000.085,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "cd_tex2", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14387, "dr_gsnew", "AH_flroortile12", 0);
	tmpobjid = CreateDynamicObject(2446,1568.260,-1566.359,1000.085,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "cd_tex2", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14387, "dr_gsnew", "AH_flroortile12", 0);
	tmpobjid = CreateDynamicObject(2446,1568.260,-1567.359,1000.085,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "cd_tex2", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14387, "dr_gsnew", "AH_flroortile12", 0);
	tmpobjid = CreateDynamicObject(2446,1568.258,-1568.359,1000.085,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "cd_tex2", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14387, "dr_gsnew", "AH_flroortile12", 0);
	tmpobjid = CreateDynamicObject(2446,1568.255,-1569.359,1000.085,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "cd_tex2", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14387, "dr_gsnew", "AH_flroortile12", 0);
	tmpobjid = CreateDynamicObject(2446,1568.260,-1570.187,1000.083,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14387, "dr_gsnew", "cd_tex2", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14387, "dr_gsnew", "AH_flroortile12", 0);
	tmpobjid = CreateDynamicObject(2163,1572.223,-1563.130,1000.072,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "la_kitch3", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8481, "csrsfence01", "ceaserwall06_128", 0);
	tmpobjid = CreateDynamicObject(2161,1572.223,-1571.560,1000.062,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "la_kitch3", 0);
	tmpobjid = CreateDynamicObject(2162,1572.227,-1568.458,1000.067,0.119,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "la_kitch3", 0);
	tmpobjid = CreateDynamicObject(19454,1572.208,-1566.659,1000.013,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14812, "lee_studhall", "carpet", 0);
	tmpobjid = CreateDynamicObject(19454,1568.713,-1566.666,1000.013,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14812, "lee_studhall", "carpet", 0);
	Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT, tmpobjid, true);
	tmpobjid = CreateDynamicObject(19454,1572.229,-1568.644,1000.007,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14812, "lee_studhall", "carpet", 0);
	tmpobjid = CreateDynamicObject(19454,1568.729,-1568.603,1000.010,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14812, "lee_studhall", "carpet", 0);
	tmpobjid = CreateDynamicObject(19454,1562.151,-1566.625,1000.013,0.000,90.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14812, "lee_studhall", "carpet", 0);
	tmpobjid = CreateDynamicObject(19454,1562.145,-1568.858,1000.017,0.000,90.000,269.993,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14812, "lee_studhall", "carpet", 0);
	tmpobjid = CreateDynamicObject(19461,1562.909,-1556.968,1005.335,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1562.244,-1555.354,1001.835,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1557.520,-1560.088,1005.335,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1552.677,-1563.805,1005.335,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1552.677,-1573.437,1005.335,0.000,0.000,179.994,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1557.519,-1575.441,1001.835,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1562.258,-1580.171,1005.335,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1562.910,-1578.290,1001.835,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19454,1552.510,-1568.857,1000.017,0.000,90.000,269.993,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14812, "lee_studhall", "carpet", 0);
	tmpobjid = CreateDynamicObject(19454,1552.510,-1566.625,1000.013,0.000,90.000,269.993,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14812, "lee_studhall", "carpet", 0);
	tmpobjid = CreateDynamicObject(19450,1552.691,-1570.359,998.434,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1552.687,-1560.723,998.434,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1557.526,-1560.109,998.434,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1562.281,-1555.380,998.434,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1566.358,-1557.005,998.434,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1566.197,-1578.270,998.434,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1562.274,-1580.171,998.434,0.000,0.000,179.994,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1557.541,-1575.401,998.434,0.000,0.000,269.993,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19461,1552.677,-1563.802,1001.835,0.000,0.000,179.994,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1557.515,-1575.441,1005.335,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1552.677,-1573.437,1001.835,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1572.541,-1578.291,1005.335,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1562.909,-1578.290,1005.335,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1562.255,-1580.171,1001.835,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1557.519,-1560.100,1001.835,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1562.906,-1556.967,1001.835,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1562.249,-1555.354,1005.335,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1572.541,-1556.967,1001.835,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1549.119,-1564.784,1005.335,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1553.848,-1560.050,1001.835,0.000,0.000,179.994,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1553.848,-1560.050,1005.335,0.000,0.000,179.994,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1549.119,-1564.781,1001.835,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19450,1553.869,-1575.431,1008.514,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1552.711,-1570.359,1008.494,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1552.701,-1560.727,1008.494,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19461,1549.119,-1570.697,1001.835,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1553.848,-1575.431,1005.335,0.000,0.000,179.994,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1549.119,-1570.697,1005.335,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1553.848,-1575.430,1001.835,0.000,0.000,179.994,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19450,1553.869,-1575.431,998.434,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1553.859,-1560.050,998.434,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1549.145,-1570.680,998.434,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19560,1591.781,-1568.075,1004.390,0.000,0.000,-66.899,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19380,1557.692,-1581.083,1006.986,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 15048, "labigsave", "ah_wallstyle1", 0);
	tmpobjid = CreateDynamicObject(19380,1557.687,-1561.822,1006.986,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 15048, "labigsave", "ah_wallstyle1", 0);
	tmpobjid = CreateDynamicObject(19380,1589.187,-1571.453,1006.986,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 15048, "labigsave", "ah_wallstyle1", 0);
	tmpobjid = CreateDynamicObject(19380,1589.187,-1581.083,1006.986,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 15048, "labigsave", "ah_wallstyle1", 0);
	tmpobjid = CreateDynamicObject(19380,1578.687,-1552.187,1006.986,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 15048, "labigsave", "ah_wallstyle1", 0);
	tmpobjid = CreateDynamicObject(19380,1568.187,-1581.083,1006.986,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 15048, "labigsave", "ah_wallstyle1", 0);
	tmpobjid = CreateDynamicObject(19380,1557.702,-1571.453,1006.986,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 15048, "labigsave", "ah_wallstyle1", 0);
	tmpobjid = CreateDynamicObject(18980,1561.541,-1571.930,1012.585,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1562.020,-1563.077,987.736,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1562.020,-1571.427,987.736,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1561.020,-1563.077,987.736,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1561.020,-1571.427,987.736,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1562.020,-1564.072,1019.242,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1561.020,-1564.073,1019.242,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1561.020,-1563.076,1019.242,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1562.019,-1563.076,1019.242,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1561.020,-1564.073,987.736,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1562.020,-1564.073,987.736,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1561.531,-1563.609,1012.585,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1561.020,-1572.427,987.736,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1562.020,-1572.427,987.736,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1561.020,-1572.427,1019.242,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1562.020,-1572.427,1019.242,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1561.020,-1571.427,1019.242,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1562.020,-1571.427,1019.242,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(19379,1582.102,-1566.046,1003.504,0.000,90.000,89.995,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", -1);
	tmpobjid = CreateDynamicObject(19379,1582.102,-1555.546,1003.504,0.000,90.000,89.995,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", -1);
	tmpobjid = CreateDynamicObject(19379,1582.098,-1576.546,1003.504,0.000,90.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", -1);
	tmpobjid = CreateDynamicObject(19379,1591.734,-1555.546,1003.504,0.000,90.000,89.995,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", -1);
	tmpobjid = CreateDynamicObject(19379,1591.734,-1566.045,1003.504,0.000,90.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", -1);
	Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT, tmpobjid, true);
	tmpobjid = CreateDynamicObject(19379,1591.734,-1576.546,1003.504,0.000,90.000,89.995,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", -1);
	tmpobjid = CreateDynamicObject(19397,1583.560,-1571.906,1005.340,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19369,1578.865,-1571.938,1005.340,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", -1);
	SetDynamicObjectMaterial(tmpobjid, 1, 14760, "sfhosemed2", "walp40S", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19369,1580.375,-1571.907,1005.340,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", -1);
	SetDynamicObjectMaterial(tmpobjid, 1, 14760, "sfhosemed2", "walp40S", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1589.979,-1571.906,1005.335,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19369,1578.885,-1563.307,1005.340,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", -1);
	SetDynamicObjectMaterial(tmpobjid, 1, 14760, "sfhosemed2", "walp40S", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19397,1582.095,-1563.311,1005.340,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1588.516,-1563.310,1005.335,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1580.635,-1576.723,1005.335,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(2167,1580.739,-1573.555,1003.590,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "la_kitch3", 0);
	tmpobjid = CreateDynamicObject(2167,1580.739,-1574.468,1003.590,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "la_kitch3", 0);
	tmpobjid = CreateDynamicObject(2167,1580.739,-1575.384,1003.590,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "la_kitch3", 0);
	tmpobjid = CreateDynamicObject(19461,1586.946,-1576.661,1005.335,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1584.088,-1578.072,1005.335,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(2167,1580.739,-1576.296,1003.590,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "la_kitch3", 0);
	tmpobjid = CreateDynamicObject(2311,1583.560,-1577.402,1003.589,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14526, "sweetsmain", "mp_cooker2", 0);
	tmpobjid = CreateDynamicObject(19560,1584.380,-1577.496,1004.110,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19578,1584.382,-1577.584,1004.217,27.500,89.100,0.299,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2262,1584.388,-1577.087,1004.309,0.000,0.000,179.999,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8057, "vgsswarehse02", "ws_RShaul_transp_M", 0);
	tmpobjid = CreateDynamicObject(19461,1579.656,-1558.562,1005.335,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1579.654,-1548.958,1005.335,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1587.614,-1558.420,1005.335,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1583.453,-1551.446,1005.335,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1587.614,-1548.785,1005.335,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19450,1586.930,-1576.697,1001.942,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1584.034,-1578.067,1001.942,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1580.640,-1576.717,1001.942,0.000,0.000,359.993,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1579.666,-1558.567,1001.942,0.000,0.000,359.989,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1579.671,-1554.687,1001.942,0.000,0.000,359.989,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1583.701,-1551.458,1001.942,0.000,0.000,269.989,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1587.604,-1558.505,1001.942,0.000,0.000,179.988,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1587.598,-1549.947,1001.942,0.000,0.000,179.983,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1577.176,-1573.341,1008.503,0.000,0.000,179.999,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1577.218,-1573.890,1001.942,0.000,0.000,179.994,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19397,1587.557,-1567.557,1005.340,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19369,1587.567,-1570.223,1005.340,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", -1);
	SetDynamicObjectMaterial(tmpobjid, 1, 14760, "sfhosemed2", "walp40S", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19450,1587.547,-1561.850,1008.503,0.000,0.000,179.999,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19461,1592.354,-1570.562,1005.335,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1592.363,-1563.864,1005.335,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19461,1594.112,-1567.343,1005.335,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	tmpobjid = CreateDynamicObject(19450,1587.631,-1563.322,1001.942,0.000,0.000,269.984,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1592.343,-1563.878,1001.942,0.000,0.000,269.976,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1594.099,-1566.750,1001.942,0.000,0.000,179.977,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1592.468,-1570.545,1001.942,0.000,0.000,89.972,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1587.571,-1573.135,1001.942,0.000,0.000,359.967,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1587.578,-1562.014,1001.942,0.000,0.000,359.967,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1587.541,-1562.014,1001.942,0.000,0.000,359.967,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1587.541,-1573.130,1001.942,0.000,0.000,359.967,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1499,1582.786,-1571.901,1003.580,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 3089, "mafcasx", "cof_wind1", 0);
	tmpobjid = CreateDynamicObject(1499,1581.323,-1563.321,1003.580,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 3089, "mafcasx", "cof_wind1", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 3089, "mafcasx", "cof_wind1", 0);
	tmpobjid = CreateDynamicObject(1499,1587.541,-1566.821,1003.580,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 3089, "mafcasx", "cof_wind1", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 3089, "mafcasx", "cof_wind1", 0);
	tmpobjid = CreateDynamicObject(19380,1568.187,-1571.453,1006.986,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 15048, "labigsave", "ah_wallstyle1", 0);
	tmpobjid = CreateDynamicObject(19380,1568.187,-1561.822,1006.986,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 15048, "labigsave", "ah_wallstyle1", 0);
	tmpobjid = CreateDynamicObject(19380,1589.187,-1561.821,1006.986,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 15048, "labigsave", "ah_wallstyle1", 0);
	tmpobjid = CreateDynamicObject(19380,1578.687,-1571.453,1006.986,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 15048, "labigsave", "ah_wallstyle1", 0);
	tmpobjid = CreateDynamicObject(19380,1578.687,-1581.083,1006.986,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 15048, "labigsave", "ah_wallstyle1", 0);
	tmpobjid = CreateDynamicObject(19380,1589.187,-1552.187,1006.986,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 15048, "labigsave", "ah_wallstyle1", 0);
	tmpobjid = CreateDynamicObject(19380,1578.687,-1561.822,1006.986,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 15048, "labigsave", "ah_wallstyle1", 0);
	tmpobjid = CreateDynamicObject(19380,1599.687,-1567.750,1006.986,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 15048, "labigsave", "ah_wallstyle1", 0);
	tmpobjid = CreateDynamicObject(19450,1553.859,-1560.030,1008.514,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1557.541,-1575.401,1008.494,0.000,0.000,269.993,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1562.274,-1580.171,1008.494,0.000,0.000,179.994,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1566.197,-1578.270,1008.503,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1575.836,-1578.270,1008.503,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1577.206,-1567.990,1008.503,0.000,0.000,179.999,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1577.176,-1563.731,1008.503,0.000,0.000,179.999,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1577.176,-1554.131,1008.503,0.000,0.000,179.999,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1572.237,-1556.979,1008.503,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1562.638,-1556.979,1008.503,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1562.276,-1555.361,1008.494,0.000,0.000,179.994,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1557.541,-1560.100,1008.494,0.000,0.000,269.993,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1549.145,-1570.680,1008.504,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1549.145,-1564.800,1008.504,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1587.546,-1568.211,1008.503,0.000,0.000,179.999,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1587.576,-1568.211,1008.503,0.000,0.000,179.999,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1586.930,-1576.697,1008.542,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1580.640,-1576.697,1008.542,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1582.102,-1571.895,1008.502,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1591.732,-1571.895,1008.502,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1592.462,-1570.545,1008.502,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2184,1582.524,-1554.406,1003.593,0.000,0.180,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14652, "ab_trukstpa", "mp_diner_wood", 0);
	tmpobjid = CreateDynamicObject(14455,1587.473,-1557.874,1005.262,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "redmetal", 0);
	tmpobjid = CreateDynamicObject(14455,1579.692,-1556.452,1005.262,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "redmetal", 0);
	tmpobjid = CreateDynamicObject(14455,1579.703,-1553.562,1005.262,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "redmetal", 0);
	tmpobjid = CreateDynamicObject(2167,1593.148,-1570.429,1003.590,0.000,-0.180,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "la_kitch3", 0);
	tmpobjid = CreateDynamicObject(14387,1571.062,-1559.401,1000.768,0.000,0.000,179.994,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19071, "wssections", "rockbrown1", 0);
	tmpobjid = CreateDynamicObject(14387,1574.760,-1563.109,1002.601,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19071, "wssections", "rockbrown1", 0);
	tmpobjid = CreateDynamicObject(14387,1574.760,-1572.161,1002.601,0.000,0.000,269.993,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19071, "wssections", "rockbrown1", 0);
	tmpobjid = CreateDynamicObject(14387,1570.982,-1575.853,1000.768,0.000,0.000,179.994,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19071, "wssections", "rockbrown1", 0);
	tmpobjid = CreateDynamicObject(1726,1573.000,1340.000,-1568.000,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 4552, "ammu_lan2", "newall4-4", 0);
	tmpobjid = CreateDynamicObject(1726,1584.587,-1572.585,1003.583,0.000,-0.119,0.593,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 4552, "ammu_lan2", "newall4-4", 0);
	tmpobjid = CreateDynamicObject(2262,1584.357,-1578.064,1004.309,0.000,0.000,-0.400,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1726,1588.402,-1564.587,1003.590,-0.059,0.239,359.989,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 4552, "ammu_lan2", "newall4-4", 0);
	tmpobjid = CreateDynamicObject(1726,1578.258,-1563.862,1003.590,0.000,0.000,359.984,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 4552, "ammu_lan2", "newall4-4", 0);
	tmpobjid = CreateDynamicObject(1726,1580.407,-1571.260,1003.590,0.000,0.000,179.983,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 4552, "ammu_lan2", "newall4-4", 0);
	tmpobjid = CreateDynamicObject(19450,1594.106,-1568.211,1008.503,0.000,0.000,179.999,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(18980,1554.298,-1574.976,1012.585,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1554.652,-1574.650,987.736,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1553.654,-1574.654,987.734,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1554.652,-1575.649,987.736,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1554.652,-1574.650,1019.242,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1554.652,-1575.649,1019.242,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1553.654,-1574.652,1019.242,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1554.302,-1560.456,1012.585,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1554.652,-1560.803,987.736,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1554.652,-1559.806,987.736,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1553.654,-1560.803,987.736,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1019.161,-1560.803,987.736,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1553.654,-1560.803,1019.242,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1554.652,-1560.803,1019.242,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1554.652,-1559.806,1019.242,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1577.102,-1557.097,1012.585,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1577.102,-1578.167,1012.585,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1576.910,-1557.285,989.376,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14533, "pleas_dome", "ab_velvor", 0);
	tmpobjid = CreateDynamicObject(18980,1576.910,-1557.285,1019.242,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1576.915,-1577.983,1019.242,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(18980,1576.915,-1577.983,989.376,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10388, "scum2_sfs", "ws_carparkmanky1", 0);
	tmpobjid = CreateDynamicObject(19922,1583.544,-1556.271,1003.587,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "mp_diner_wood", 0);
	tmpobjid = CreateDynamicObject(19808,1584.179,-1553.630,1004.438,0.000,0.000,205.622,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1726,1586.934,-1559.490,1003.505,0.000,0.000,-90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 4552, "ammu_lan2", "newall4-4", 0);
	tmpobjid = CreateDynamicObject(1726,1585.837,-1562.606,1003.505,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 4552, "ammu_lan2", "newall4-4", 0);
	tmpobjid = CreateDynamicObject(1823,1587.335,-1562.938,1003.590,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "la_kitch3", 0);
	tmpobjid = CreateDynamicObject(19560,1584.447,-1554.004,1004.367,0.000,0.000,39.868,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19578,1584.483,-1554.039,1004.416,40.000,90.000,37.967,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2263,1584.197,-1553.670,1004.494,0.000,0.000,220.380,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19894, "laptopsamp1", "laptopscreen3", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2263,1584.850,-1554.437,1005.112,180.000,0.000,220.380,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1582.189,-1551.472,1005.402,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1583.286,-1551.530,1006.384,90.000,180.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1584.008,-1551.554,1006.384,90.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1585.167,-1551.472,1005.402,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1583.286,-1551.554,1004.419,-90.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1584.100,-1551.528,1004.419,-90.000,0.000,-90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1583.132,-1551.470,1005.402,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19477,1582.097,-1563.409,1006.279,0.000,0.000,-89.999,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Mayor's office", 140, "Ariel", 60, 1, -16777216, 0, 1);
	tmpobjid = CreateDynamicObject(19916,1582.654,-1551.085,1004.299,0.000,0.059,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(19916,1583.704,-1551.081,1004.299,-0.059,0.059,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(19916,1584.684,-1551.085,1004.299,0.000,0.119,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(1897,1583.258,-1551.470,1005.402,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1584.159,-1551.470,1005.402,0.000,0.119,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1584.285,-1551.470,1005.402,0.000,0.059,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1592.431,-1570.574,1005.338,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19916,1591.980,-1570.947,1004.232,0.059,-0.059,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(1897,1589.514,-1570.574,1005.323,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19916,1591.044,-1570.947,1004.232,0.059,-0.059,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(1897,1591.535,-1570.574,1005.338,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1591.406,-1570.574,1005.338,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1590.582,-1570.574,1005.338,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1590.453,-1570.574,1005.338,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19916,1590.003,-1570.947,1004.232,0.059,-0.059,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(1897,1591.391,-1570.572,1004.284,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1590.578,-1570.572,1004.284,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1590.578,-1570.572,1006.425,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1591.391,-1570.572,1006.425,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2164,1593.948,-1564.754,1003.589,-0.059,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "la_kitch3", 0);
	tmpobjid = CreateDynamicObject(2162,1588.954,-1570.429,1003.590,-0.059,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "la_kitch3", 0);
	tmpobjid = CreateDynamicObject(1823,1586.120,-1573.937,1003.579,0.000,0.000,-178.306,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14526, "sweetsmain", "mp_cooker2", 0);
	tmpobjid = CreateDynamicObject(2162,1572.229,-1564.907,1000.078,0.000,0.059,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "la_kitch3", 0);
	tmpobjid = CreateDynamicObject(2161,1572.223,-1571.994,1000.065,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "la_kitch3", 0);
	tmpobjid = CreateDynamicObject(2161,1572.223,-1570.228,1000.062,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 1714, "cj_office", "la_kitch3", 0);
	tmpobjid = CreateDynamicObject(2163,1572.223,-1566.682,1000.072,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 1714, "cj_office", "la_kitch3", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 8481, "csrsfence01", "ceaserwall06_128", 0);
	tmpobjid = CreateDynamicObject(1897,1564.687,-1557.010,1002.335,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10755, "airportrminl_sfse", "ws_airportconc1", 0);
	tmpobjid = CreateDynamicObject(1897,1564.687,-1557.010,1004.570,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19916,1565.116,-1556.590,1001.255,0.059,-0.180,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(19916,1565.117,-1556.610,1003.445,0.059,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 6286, "santamonhus1", "fivewins_law", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(19916,1565.924,-1556.610,1003.445,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(1897,1565.737,-1557.014,1001.294,0.000,90.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19916,1565.922,-1556.610,1001.255,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(19916,1566.724,-1556.610,1003.445,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(1897,1567.167,-1557.010,1002.335,0.000,-0.059,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1567.167,-1557.010,1004.569,0.059,-0.059,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1566.097,-1557.012,1001.294,0.000,89.879,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19916,1566.702,-1556.610,1001.255,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(1897,1565.737,-1557.014,1005.635,0.000,90.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1566.097,-1557.012,1005.635,0.000,89.879,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1726,1554.602,-1563.951,1000.085,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 4552, "ammu_lan2", "newall4-4", 0);
	tmpobjid = CreateDynamicObject(1726,1555.693,-1560.800,1000.085,0.000,0.059,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 4552, "ammu_lan2", "newall4-4", 0);
	tmpobjid = CreateDynamicObject(1726,1554.602,-1573.578,1000.085,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 4552, "ammu_lan2", "newall4-4", 0);
	tmpobjid = CreateDynamicObject(1726,1557.680,-1574.707,1000.085,0.000,0.059,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 4552, "ammu_lan2", "newall4-4", 0);
	tmpobjid = CreateDynamicObject(1897,1564.687,-1578.250,1002.335,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1567.167,-1578.250,1002.335,0.000,-0.059,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1564.687,-1578.250,1004.551,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1565.737,-1578.250,1005.635,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1566.097,-1578.250,1005.635,0.000,89.879,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1567.167,-1578.250,1004.569,0.059,-0.059,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1565.737,-1578.250,1001.294,0.000,90.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(1897,1566.097,-1578.250,1001.294,0.000,89.879,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19916,1565.117,-1578.658,1003.445,0.059,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(19916,1565.924,-1578.658,1003.445,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(19916,1566.724,-1578.658,1003.445,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(19916,1566.702,-1578.658,1001.255,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(19916,1565.922,-1578.658,1001.255,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(19916,1565.116,-1578.658,1001.255,0.059,-0.180,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 6332, "rodeo01_law2", "rodwall01_LAw2", 0);
	tmpobjid = CreateDynamicObject(19450,1592.462,-1563.865,1008.502,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1582.102,-1563.334,1008.502,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1582.942,-1563.285,1008.502,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1579.677,-1558.591,1008.503,0.000,0.000,179.999,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1579.656,-1548.951,1008.503,0.000,0.000,179.999,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1587.606,-1550.171,1008.503,0.000,0.000,179.999,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1587.606,-1558.402,1008.503,0.000,0.000,179.999,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1583.222,-1551.455,1008.502,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1582.242,-1571.915,1008.532,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1582.242,-1578.065,1008.532,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1591.692,-1563.324,1008.502,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19450,1577.226,-1561.317,1001.942,0.000,0.000,359.989,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19477,1587.460,-1567.602,1006.310,0.000,0.000,179.799,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Employment", 140, "Ariel", 60, 1, -16777216, 0, 1);
	tmpobjid = CreateDynamicObject(19477,1577.297,-1567.599,1006.400,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Lobby", 140, "Ariel", 60, 1, -16777216, 0, 1);
	tmpobjid = CreateDynamicObject(19477,1583.538,-1571.798,1006.360,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Cloakroom", 140, "Ariel", 60, 1, -16777216, 0, 1);
	tmpobjid = CreateDynamicObject(19480,1572.208,-1567.625,1003.328,0.000,0.000,179.999,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Reception", 140, "Ariel", 20, 1, -983041, 0, 1);
	tmpobjid = CreateDynamicObject(19450,1549.145,-1564.800,998.434,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19578,1591.699,-1568.122,1004.478,35.599,81.199,-51.099,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2263,1592.166,-1567.949,1004.498,0.000,-1.699,113.400,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 19894, "laptopsamp1", "laptopscreen2", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2263,1591.245,-1568.310,1004.498,0.000,1.199,-66.900,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(2894,1592.060,-1567.321,1004.381,0.000,0.059,92.137,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2420, "cj_ff_acc1", "CJ_MICROPANEL", 0);
	tmpobjid = CreateDynamicObject(19808,1605.277,-1597.622,1004.438,0.000,0.000,205.622,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19808,1592.062,-1567.953,1004.409,0.000,0.000,112.022,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19477,1552.782,-1567.956,1002.943,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "City Hall", 140, "Ariel", 100, 1, -16777216, 0, 1);
	tmpobjid = CreateDynamicObject(19461,1587.567,-1561.137,1005.335,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14760, "sfhosemed2", "walp40S", 0);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(1569,1552.754,-1566.361,1000.098,0.000,0.000,-89.799,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1569,1552.782,-1569.302,1000.098,0.000,0.000,91.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2161,1580.529,-1551.541,1003.590,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2161,1586.375,-1551.536,1003.590,0.119,0.239,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19358,1578.885,-1571.895,1001.942,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19358,1581.187,-1571.890,1001.942,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19358,1581.187,-1571.916,1001.942,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19358,1585.890,-1571.894,1001.942,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19358,1585.885,-1571.915,1001.942,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19358,1578.889,-1563.312,1001.942,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19358,1579.724,-1563.321,1001.942,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19358,1587.631,-1563.302,1001.942,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19358,1584.431,-1563.287,1001.942,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2161,1592.000,1400.000,-1570.000,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(18075,1554.822,-1567.607,1006.942,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1722,1590.963,-1566.520,1003.590,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1722,1587.239,-1566.119,1003.590,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1722,1587.239,-1565.364,1003.590,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1722,1587.239,-1568.984,1003.590,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19477,1552.791,-1567.673,1005.552,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19477,1552.791,-1566.792,1004.742,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19477,1587.432,-1568.232,1006.023,0.000,0.000,179.998,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19477,1582.845,-1571.800,1006.023,0.000,0.000,90.299,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19477,1584.422,-1563.464,1006.122,0.000,0.000,-91.199,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19431,1577.182,-1569.875,1001.942,0.000,0.000,179.994,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19431,1577.177,-1570.232,1001.942,0.000,0.000,179.994,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19431,1577.186,-1565.331,1001.942,0.000,0.000,179.994,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19431,1577.186,-1565.067,1001.942,0.000,0.000,179.994,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2173,1592.000,-1567.911,1003.590,0.059,-0.059,90.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(18075,1570.066,-1567.607,1006.942,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(18075,1570.066,-1557.416,1006.942,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(18075,1570.066,-1577.885,1006.942,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(18075,1593.243,-1567.218,1006.942,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(18075,1583.583,-1557.385,1006.942,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(18075,1582.352,-1567.552,1006.942,0.000,0.000,269.993,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(18075,1586.217,-1578.977,1006.942,0.000,0.000,359.989,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1714,1569.461,-1565.718,1000.085,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1714,1569.461,-1569.864,1000.085,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1714,1569.461,-1567.875,1000.085,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2689,1581.203,-1574.505,1004.442,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1719,1584.834,-1577.308,1003.690,0.000,0.000,-179.800,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2384,1580.911,-1574.500,1005.215,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(11735,1580.952,-1572.678,1003.590,0.000,0.059,92.015,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1714,1585.036,-1556.541,1003.590,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1714,1585.036,-1555.229,1003.590,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1714,1582.170,-1555.229,1003.590,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1714,1582.170,-1556.541,1003.590,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1714,1593.244,-1567.248,1003.590,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19894,1580.265,-1551.786,1004.530,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19792,1581.285,-1551.870,1004.955,0.000,0.000,60.305,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2855,1586.113,-1551.788,1003.649,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2894,1582.844,-1553.794,1004.394,0.000,0.059,125.837,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2967,1586.485,-1551.859,1004.504,-0.059,0.059,318.895,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19826,1583.089,-1563.219,1004.785,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19814,1581.726,-1551.534,1003.924,0.059,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19818,1581.241,-1551.684,1003.730,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19818,1581.041,-1551.804,1003.730,0.000,0.000,317.317,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19823,1581.051,-1551.636,1003.627,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19807,1582.363,-1554.007,1004.438,0.000,0.000,145.880,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(0,1586.874,-1553.515,1005.484,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1714,1583.369,-1552.292,1003.590,0.000,0.000,14.399,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2852,1586.825,-1562.462,1004.085,0.000,0.000,241.395,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2854,1586.825,-1562.356,1003.672,0.000,0.000,170.581,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2262,1584.596,-1562.727,1005.556,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2258,1587.518,-1560.063,1005.778,0.000,0.000,-90.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19358,1579.724,-1563.287,1001.942,0.000,0.000,89.995,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19352,1586.116,-1551.782,1004.947,-0.059,-0.180,90.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(11735,1580.952,-1572.478,1003.590,0.000,0.000,56.824,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2854,1585.727,-1574.348,1004.083,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19835,1585.281,-1574.674,1004.173,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1808,1584.177,-1563.614,1003.590,0.000,0.000,359.984,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2010,1586.987,-1571.194,1003.589,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2010,1586.987,-1563.893,1003.589,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2010,1562.837,-1557.553,1000.087,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2811,1553.359,-1570.071,1000.101,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2811,1553.359,-1565.487,1000.101,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2855,1572.000,-1565.012,1000.130,0.000,0.000,-90.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2854,1572.135,-1565.590,1000.565,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2855,1572.000,-1570.418,1000.568,0.059,0.000,90.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1818,1555.999,-1563.452,1000.085,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(1818,1555.999,-1573.159,1000.085,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2010,1562.837,-1577.753,1000.087,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(2028,1584.022,-1577.310,1003.743,0.000,0.000,-178.500,-1,-1,-1,300.000,300.000);
	tmpobjid = CreateDynamicObject(19807,1591.850,-1566.656,1004.438,0.000,0.000,56.680,-1,-1,-1,300.000,300.000);
	obj = CreateDynamicObject(2010,1580.217,-1562.784,1003.589,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	return obj;
}

AztecasHouse_Int_CreateObjects()
{
	CreateDynamicObject(2395,1788.8496090,-2100.7917480,1017.8937370,0.0,0.0,180.0);
	CreateDynamicObject(3615,1791.4841300,-2099.0671380,1020.1600950,90.0,0.0,-90.0);
	CreateDynamicObject(3615,1790.2471920,-2103.0690910,1020.1600950,90.0,0.0,180.0);
	CreateDynamicObject(2395,1789.1992180,-2097.5996090,1017.8937980,0.0,0.0,-90.0);
	CreateDynamicObject(3615,1773.7690420,-2099.0539550,1020.1601560,90.0,0.0,-270.0);
	CreateDynamicObject(16637,1783.9223630,-2089.8142080,1022.7249750,0.0,0.0,-90.0);
	CreateDynamicObject(2395,1776.0657950,-2100.4626460,1017.8937370,0.0,0.0,90.0);
	CreateDynamicObject(2395,1786.8895260,-2090.2319330,1021.7898550,0.0,180.0,0.0);
	CreateDynamicObject(17951,1783.9013670,-2081.5400390,1021.3969110,0.0,0.0,-0.40);
	CreateDynamicObject(3905,1795.0465080,-2026.2462150,1004.7159420,0.0,0.0,-90.0);
	CreateDynamicObject(3905,1789.0966790,-2029.9862060,1004.7139280,0.0,0.0,-90.0);
	CreateDynamicObject(3905,1799.0965570,-2029.9962150,1004.7139280,0.0,0.0,-90.0);
	CreateDynamicObject(17951,1783.9105220,-2081.5400390,1021.3969110,0.0,0.0,0.0);
	CreateDynamicObject(8390,1830.2739250,-2160.2343750,1000.7201530,0.0,0.0,0.0);
	CreateDynamicObject(2395,1785.3446040,-2100.7937010,1017.8937370,0.0,0.0,180.0);
	CreateDynamicObject(2395,1780.1157220,-2100.7937010,1017.8937370,0.0,0.0,180.0);
	CreateDynamicObject(2395,1777.6595450,-2100.7917480,1017.8937370,0.0,0.0,180.0);
	CreateDynamicObject(2665,1785.4365230,-2101.0234370,1022.4309080,0.0,90.0,0.0);
	CreateDynamicObject(1498,1780.5061030,-2090.1511230,1020.3969110,0.0,0.0,0.0);
	CreateDynamicObject(3615,1791.4810790,-2095.7773430,1020.1600950,90.0,0.0,-90.0);
	CreateDynamicObject(2527,1788.6695550,-2091.6730950,1020.4309080,0.0,0.0,0.0);
	CreateDynamicObject(1535,1780.5903320,-2100.9309080,1020.4238280,0.0,0.0,360.0);
	CreateDynamicObject(2395,1785.2783200,-2093.4291990,1023.1635740,0.0,180.0,-90.0);
	CreateDynamicObject(2395,1785.2769770,-2090.6833490,1022.9038080,0.0,0.0,270.0);
	CreateDynamicObject(3615,1787.4670410,-2103.0690910,1017.2800900,90.0,0.0,180.0);
	CreateDynamicObject(3615,1787.4670410,-2103.0690910,1023.0080560,90.0,0.0,180.0);
	CreateDynamicObject(2665,1784.5555410,-2101.0036620,1022.4249870,0.0,90.0,0.0);
	CreateDynamicObject(3615,1782.9667960,-2103.0690910,1024.1601560,90.0,0.0,180.0);
	CreateDynamicObject(3615,1779.2670890,-2103.0690910,1024.1601560,90.0,0.0,180.0);
	CreateDynamicObject(2395,1789.2011710,-2094.3996580,1017.8937370,0.0,0.0,-90.0);
	CreateDynamicObject(14483,1785.8931880,-2091.5061030,1021.2636710,90.0,0.0,0.0);
	CreateDynamicObject(2395,1789.1992180,-2097.5996090,1017.8937370,0.0,0.0,-90.0);
	CreateDynamicObject(14483,1785.8837890,-2092.5803220,1021.2445670,-90.0,0.0,0.0);
	CreateDynamicObject(14483,1787.8198240,-2090.6477050,1021.2609250,90.0,0.0,-90.0);
	CreateDynamicObject(3615,1773.7690420,-2095.3442380,1020.1600950,90.0,0.0,-270.0);
	CreateDynamicObject(3615,1773.7670890,-2092.0041500,1020.1600950,90.0,0.0,-270.0);
	CreateDynamicObject(3033,1778.2148430,-2089.9462890,1023.6710200,90.0,0.0,0.0);
	CreateDynamicObject(6959,1782.9460440,-2070.1760250,1023.6274410,0.0,180.0,0.0);
	CreateDynamicObject(3852,1778.7923580,-2086.3989250,1015.8573600,0.0,90.0,540.0);
	CreateDynamicObject(14483,1786.8968500,-2090.6437980,1021.2409050,-90.0,0.0,270.0);
	CreateDynamicObject(14483,1788.8291010,-2092.5739740,1021.2550040,90.0,0.0,180.0);
	CreateDynamicObject(14483,1788.8294670,-2091.4433590,1021.2388910,-90.0,0.0,180.0);
	CreateDynamicObject(1502,1785.3643790,-2093.8698730,1020.4038080,0.0,0.0,0.0);
	CreateDynamicObject(14483,1786.8839110,-2093.3820800,1021.2559200,90.0,0.0,90.0);
	CreateDynamicObject(14483,1789.2850340,-2093.3840330,1021.2438960,-90.0,0.0,89.8000030);
	CreateDynamicObject(2395,1776.0657950,-2096.7329100,1017.8937370,0.0,0.0,90.0);
	CreateDynamicObject(2395,1776.0638420,-2093.4025870,1017.8937370,0.0,0.0,90.0);
	CreateDynamicObject(1428,1779.0341790,-2085.9597160,1019.0274040,-15.00,0.0,0.0);
	CreateDynamicObject(3852,1781.7305900,-2088.2033690,1015.4273680,90.0,0.0,0.0);
	CreateDynamicObject(2395,1783.1605220,-2090.2319330,1021.7886960,0.0,180.0,0.0);
	CreateDynamicObject(2395,1780.4106440,-2090.2319330,1023.3588250,0.0,360.0,0.0);
	CreateDynamicObject(2395,1790.1206050,-2093.9765620,1023.1538080,0.0,180.0,0.0);
	CreateDynamicObject(2395,1785.8183590,-2093.9780270,1022.9036250,0.0,720.0,0.0);
	CreateDynamicObject(2395,1789.5499260,-2093.9780270,1022.9038080,0.0,360.0,0.0);
	CreateDynamicObject(14483,1786.2470700,-2093.3857420,1022.9238280,0.0,0.0,90.0);
	CreateDynamicObject(3861,1786.9195550,-2092.4829100,1024.8809810,0.0,180.0,0.0);
	CreateDynamicObject(3861,1790.0482170,-2092.4819330,1024.8808590,0.0,180.0,0.0);
	CreateDynamicObject(3861,1786.9237060,-2089.6655270,1024.8808590,0.0,180.0,0.0);
	CreateDynamicObject(3861,1789.9051510,-2089.6662590,1024.8909910,0.0,180.0,450.0);
	CreateDynamicObject(3615,1784.2264400,-2094.3508300,1026.7600090,0.0,198.3999930,0.0);
	CreateDynamicObject(3615,1787.4545890,-2098.0708000,1026.2760000,0.0,180.0,0.0);
	CreateDynamicObject(3615,1784.2264400,-2094.3508300,1026.7600090,0.0,198.3999930,0.0);
	CreateDynamicObject(3615,1784.2264400,-2098.3608390,1026.7600090,0.0,198.3999930,0.0);
	CreateDynamicObject(3615,1784.2264400,-2102.3776850,1026.7600090,0.0,198.3999930,0.0);
	CreateDynamicObject(3615,1783.1263420,-2094.3508300,1027.1400140,0.0,198.3999930,0.0);
	CreateDynamicObject(3615,1783.1264640,-2098.3605950,1027.1298820,0.0,198.3999930,0.0);
	CreateDynamicObject(3615,1783.1264640,-2102.3508300,1027.1280510,0.0,198.3999930,0.0);
	CreateDynamicObject(2528,1787.4948730,-2093.3146970,1020.4309080,0.0,0.0,540.0);
	CreateDynamicObject(3615,1777.0163570,-2094.2507320,1026.7431640,0.0,-198.3999930,0.0);
	CreateDynamicObject(3615,1777.0264890,-2098.2707510,1026.7438960,0.0,-198.3999930,0.0);
	CreateDynamicObject(3615,1777.0264890,-2102.2907710,1026.7409660,0.0,-198.3999930,0.0);
	CreateDynamicObject(3615,1780.5363760,-2094.2507320,1027.9100340,0.0,-198.3999930,0.0);
	CreateDynamicObject(14483,1785.8931880,-2091.5061030,1022.8936760,90.0,0.0,0.0);
	CreateDynamicObject(3615,1780.5263670,-2098.2607420,1027.9062500,0.0,-198.3999930,0.0);
	CreateDynamicObject(14483,1785.8837890,-2092.5803220,1022.8845820,-90.0,0.0,0.0);
	CreateDynamicObject(3615,1780.5263670,-2102.2807610,1027.9101560,0.0,-198.3999930,0.0);
	CreateDynamicObject(14483,1787.8198240,-2090.6477050,1022.9008780,90.0,0.0,-90.0);
	CreateDynamicObject(2395,1779.4376220,-2090.2304680,1026.3632810,0.0,540.0,0.0);
	CreateDynamicObject(14483,1786.8968500,-2090.6437980,1022.8809200,-90.0,0.0,270.0);
	CreateDynamicObject(2395,1775.7054440,-2090.2253410,1026.3670650,0.0,540.0,0.0);
	CreateDynamicObject(14483,1788.8291010,-2092.5739740,1022.8950190,90.0,0.0,180.0);
	CreateDynamicObject(6959,1779.3159170,-2109.9863280,1020.4562370,0.0,0.0,0.0);
	CreateDynamicObject(14483,1788.8294670,-2091.4433590,1022.8789060,-90.0,0.0,180.0);
	CreateDynamicObject(2911,1779.9739990,-2086.6723630,1017.6542350,0.0,0.0,0.0);
	CreateDynamicObject(14483,1786.8839110,-2093.3820800,1022.8959350,90.0,0.0,90.0);
	CreateDynamicObject(16337,1782.7485350,-2088.6518550,1022.0650020,90.0,-3.3999970,270.0);
	CreateDynamicObject(14483,1789.2850340,-2093.3840330,1022.8839110,-90.0,0.0,89.8000030);
	CreateDynamicObject(14483,1789.2850340,-2093.3840330,1021.2438960,-90.0,0.0,89.8000030);
	CreateDynamicObject(3615,1787.4545890,-2102.0905760,1026.2760000,0.0,180.0,0.0);
	CreateDynamicObject(3615,1787.1545410,-2098.0708000,1026.2799070,0.0,180.0,0.0);
	CreateDynamicObject(3615,1787.1546630,-2102.0905760,1026.2799070,0.0,180.0,0.0);
	CreateDynamicObject(3852,1779.2259520,-2088.9914550,1018.8639520,0.0,0.0,630.0);
	CreateDynamicObject(16337,1782.7485350,-2086.9748530,1022.0650020,91.1999960,86.5999980,180.0);
	CreateDynamicObject(3852,1781.7264400,-2084.1152340,1014.4653320,270.0,0.0,0.0);
	CreateDynamicObject(927,1783.0467520,-2077.9687500,1021.9274290,0.0,0.0,180.0);
	CreateDynamicObject(16337,1773.1378170,-2088.3520500,1022.0449820,90.0,-3.3999970,450.0);
	CreateDynamicObject(16337,1773.1367180,-2085.0520010,1022.0449820,90.0,-3.3999970,450.0);
	CreateDynamicObject(16337,1773.1356200,-2081.7219230,1022.0449820,90.0,-3.3999970,450.0);
	CreateDynamicObject(16337,1773.1339110,-2078.4018550,1022.0349730,90.0,-3.3999970,450.0);
	CreateDynamicObject(914,1779.9963370,-2086.1945800,1020.5534050,0.0,0.0,90.0);
	CreateDynamicObject(16337,1777.7484130,-2075.1716300,1022.0349730,90.0,-3.3999970,360.0);
	CreateDynamicObject(16337,1781.0684810,-2075.1706540,1022.0349730,90.0,-3.3999970,360.0);
	CreateDynamicObject(16337,1784.3885490,-2075.1689450,1022.0349730,90.0,-3.3999970,360.0);
	CreateDynamicObject(16337,1786.6983640,-2079.7517080,1022.0449820,90.0,-3.3999970,270.0);
	CreateDynamicObject(16337,1786.6994620,-2083.0617670,1022.0449820,90.0,-3.3999970,270.0);
	CreateDynamicObject(3852,1776.6290280,-2086.7915030,1018.8649290,0.0,0.0,180.0);
	CreateDynamicObject(3852,1776.8258050,-2089.7912590,1018.8669430,0.0,0.0,90.0);
	CreateDynamicObject(3852,1779.5460200,-2083.3510740,1018.8649290,0.0,0.0,90.0);
	CreateDynamicObject(3852,1776.9161370,-2086.2512200,1018.8629150,0.0,0.0,180.0);
	CreateDynamicObject(3852,1777.1759030,-2083.2714840,1018.8649290,0.0,0.0,270.0);
	CreateDynamicObject(3852,1776.9260250,-2079.7512200,1018.8629150,0.0,0.0,90.0);
	CreateDynamicObject(3852,1779.3061520,-2079.7612300,1018.8629150,0.0,0.0,90.0);
	CreateDynamicObject(3852,1781.6658930,-2079.7912590,1018.8649290,0.0,0.0,90.0);
	CreateDynamicObject(3852,1784.0458980,-2079.7912590,1018.8649290,0.0,0.0,90.0);
	CreateDynamicObject(3852,1781.9257810,-2083.3515620,1018.8649290,0.0,0.0,90.0);
	CreateDynamicObject(3852,1784.3057860,-2083.3510740,1018.8649290,0.0,0.0,90.0);
	CreateDynamicObject(16337,1786.6994620,-2086.0617670,1022.0449820,90.0,-3.3999960,270.0);
	CreateDynamicObject(16337,1781.4295650,-2087.9619140,1022.0449820,91.00,86.5999980,90.0);
	CreateDynamicObject(16337,1784.6994620,-2087.9636230,1022.0449820,90.0,-3.3999960,540.0);
	CreateDynamicObject(16637,1781.8383780,-2086.6586910,1020.4525750,0.0,270.0,90.0);
	CreateDynamicObject(2074,1789.1389160,-2087.8413080,1020.1376340,0.0,0.0,0.0);
	CreateDynamicObject(16502,1781.3919670,-2079.5319820,1014.1441650,0.0,0.0,-90.0);
	CreateDynamicObject(3033,1778.2148430,-2087.5461420,1023.6740110,90.0,0.0,0.0);
	CreateDynamicObject(3033,1778.2148430,-2085.1462400,1023.6770010,90.0,0.0,0.0);
	CreateDynamicObject(3033,1778.2148430,-2082.7463370,1023.6799920,90.0,0.0,0.0);
	CreateDynamicObject(3033,1778.2148430,-2080.3764640,1023.6830440,90.0,0.0,0.0);
	CreateDynamicObject(3033,1778.2148430,-2077.9462890,1023.6860350,90.0,0.0,0.0);
	CreateDynamicObject(3033,1783.8148190,-2085.1462400,1023.6770010,90.0,0.0,0.0);
	CreateDynamicObject(3033,1783.8148190,-2082.7463370,1023.6799920,90.0,0.0,0.0);
	CreateDynamicObject(3033,1783.8148190,-2080.3764640,1023.6830440,90.0,0.0,0.0);
	CreateDynamicObject(3033,1783.8148190,-2077.9462890,1023.6860350,90.0,0.0,0.0);
	CreateDynamicObject(16637,1785.6447750,-2085.6093750,1019.0675650,0.0,0.0,450.0);
	CreateDynamicObject(16637,1783.5135490,-2086.7104490,1019.0541990,0.0,0.0,-90.0);
	CreateDynamicObject(16637,1785.6483150,-2086.6586910,1020.4225460,0.0,270.0,90.0);
	CreateDynamicObject(16637,1789.4547110,-2085.6093750,1019.0675650,0.0,0.0,450.0);
	CreateDynamicObject(16637,1787.5136710,-2089.7065420,1019.0541990,0.0,0.0,-90.0);
	CreateDynamicObject(16637,1789.4682610,-2086.6586910,1020.4225460,0.0,270.0,90.0);
	CreateDynamicObject(16637,1781.8347160,-2085.6093750,1019.0675650,0.0,0.0,450.0);
	CreateDynamicObject(16637,1791.3334960,-2089.7065420,1019.0541990,0.0,0.0,-90.0);
	CreateDynamicObject(16502,1784.1818840,-2079.5319820,1014.1441650,0.0,0.0,-90.0);
	CreateDynamicObject(16502,1786.9719230,-2079.5319820,1014.1441650,0.0,0.0,-90.0);
	CreateDynamicObject(16502,1789.7620840,-2079.5319820,1014.1441650,0.0,0.0,-90.0);
	CreateDynamicObject(16502,1786.9719230,-2081.5319820,1014.1441650,0.0,0.0,-90.0);
	CreateDynamicObject(16502,1789.7619620,-2081.5319820,1014.1441650,0.0,0.0,-90.0);
	CreateDynamicObject(16502,1786.9719230,-2083.5319820,1014.1441650,0.0,0.0,-90.0);
	CreateDynamicObject(16502,1789.7619620,-2083.5422360,1014.1441650,0.0,0.0,-90.0);
	CreateDynamicObject(3051,1779.3212890,-2086.3093260,1020.4345090,46.00,450.0,90.0);
	CreateDynamicObject(14740,1783.5499260,-2101.0871580,1022.5468750,0.0,0.0,90.0);
	CreateDynamicObject(16637,1789.4682610,-2088.6586910,1020.4255370,0.0,270.0,90.0);
	CreateDynamicObject(16637,1785.5347900,-2088.5791010,1018.8975830,0.0,0.0,540.0);
	CreateDynamicObject(16637,1791.1335440,-2088.0063470,1019.0541990,0.0,0.0,0.0);
	CreateDynamicObject(16637,1785.6882320,-2088.6586910,1020.4265130,0.0,270.0,90.0);
	CreateDynamicObject(16637,1791.1367180,-2086.6093750,1019.0676260,0.0,0.0,360.0);
	CreateDynamicObject(16637,1783.6835930,-2086.7126460,1019.0541990,0.0,0.0,-90.0);
	CreateDynamicObject(16637,1781.9135740,-2086.7065420,1019.0541990,0.0,0.0,-90.0);
	CreateDynamicObject(14740,1778.0274650,-2101.0659170,1022.5769650,0.0,0.0,90.0);
	CreateDynamicObject(14740,1792.3521720,-2090.0605460,1022.1868890,0.0,0.0,270.0);
	CreateDynamicObject(2922,1782.2708740,-2077.9997550,1021.6273800,0.0,0.0,180.0);
	CreateDynamicObject(927,1783.8930660,-2078.8264160,1020.0574950,0.0,180.0,90.0);
	CreateDynamicObject(2558,1779.5109860,-2086.3520500,1021.9968870,0.0,0.0,-90.0);
	CreateDynamicObject(1977,1782.1129150,-2087.2653800,1022.4065550,90.0,0.0,-90.0);
	CreateDynamicObject(2395,1784.1337890,-2090.2297360,1023.3578490,0.0,0.0,0.0);
	CreateDynamicObject(2395,1788.2395010,-2090.2319330,1023.6188960,0.0,180.0,0.0);
	CreateDynamicObject(2395,1783.1605220,-2090.2299800,1023.6137080,0.0,180.0,0.0);
	CreateDynamicObject(1977,1782.1077880,-2086.3952630,1022.4765010,270.0,180.0,270.0);
	CreateDynamicObject(1977,1782.1137690,-2087.2692870,1022.8065180,0.0,90.0,180.0);
	CreateDynamicObject(1977,1782.1066890,-2086.4074700,1022.8473510,90.0,0.0,270.0);
	CreateDynamicObject(3615,1783.7669670,-2103.0710440,1017.2800900,90.0,0.0,180.0);
	CreateDynamicObject(1977,1778.3688960,-2101.5688470,1021.2249750,0.0,0.0,90.0);
	CreateDynamicObject(1977,1777.6513670,-2101.5712890,1021.1250000,0.0,0.0,90.0);
	CreateDynamicObject(3615,1775.6569820,-2103.0690910,1020.1600950,90.0,0.0,180.0);
	CreateDynamicObject(3615,1784.4670410,-2103.0720210,1023.0080560,90.0,0.0,180.0);
	CreateDynamicObject(3615,1781.3149410,-2103.0710440,1020.1600950,90.0,0.0,180.0);
	CreateDynamicObject(3615,1780.5073240,-2103.0690910,1020.1600950,90.0,0.0,180.0);
	CreateDynamicObject(3615,1777.3371580,-2103.0693350,1017.4200430,90.0,0.0,180.0);
	CreateDynamicObject(1977,1787.9992670,-2101.6779780,1020.9309080,0.0,0.0,90.0);
	CreateDynamicObject(1977,1787.0941160,-2101.6762690,1020.9309080,0.0,0.0,90.0);
	CreateDynamicObject(3615,1778.0472410,-2103.0690910,1023.0101310,90.0,0.0,180.0);
	CreateDynamicObject(1977,1786.2618400,-2101.6774900,1021.1309200,0.0,0.0,90.0);
	CreateDynamicObject(1977,1784.0432120,-2101.6542960,1021.1250000,0.0,0.0,90.0);
	CreateDynamicObject(1977,1783.2767330,-2101.6547850,1021.1250000,0.0,0.0,90.0);
	CreateDynamicObject(2526,1787.1470940,-2090.6516110,1020.4309080,0.0,0.0,180.0);
	CreateDynamicObject(2524,1788.7797850,-2092.2004390,1020.4309080,0.0,0.0,-90.0);
	CreateDynamicObject(16501,1789.4016110,-2093.6347650,1022.9309080,0.0,0.0,0.0);
	CreateDynamicObject(1802,1785.6762690,-2097.4587400,1020.4249870,0.0,0.0,-90.0);
	CreateDynamicObject(1738,1788.6209710,-2094.1254880,1020.9749750,0.0,0.0,180.0);
	CreateDynamicObject(1208,1776.3162840,-2085.4355460,1020.4294430,0.0,0.0,270.0);
	CreateDynamicObject(1481,1776.3033440,-2086.3110350,1021.1293940,0.0,0.0,90.0);
	CreateDynamicObject(2361,1776.4553220,-2087.3293450,1020.4264520,0.0,0.0,-90.0);
	CreateDynamicObject(2628,1776.7663570,-2079.0065910,1020.4254150,0.0,0.0,0.0);
	CreateDynamicObject(1778,1776.4541010,-2084.9401850,1020.4274290,0.0,0.0,-100.0);
	CreateDynamicObject(2332,1786.0484610,-2089.1928710,1018.1676020,0.0,0.0,90.0);
	CreateDynamicObject(2310,1789.8686520,-2087.8430170,1018.1676020,0.0,0.0,-10.0);
	CreateDynamicObject(1789,1776.3377680,-2089.4328610,1021.0050040,0.0,0.0,90.0);
	CreateDynamicObject(2338,1784.8173820,-2090.6867670,1020.4249870,0.0,0.0,0.0);
	CreateDynamicObject(2147,1784.8283690,-2093.2573240,1020.4249870,0.0,0.0,-90.0);
	CreateDynamicObject(2158,1782.8187250,-2090.6987300,1020.4249870,0.0,0.0,0.0);
	CreateDynamicObject(2337,1783.8041990,-2090.6933590,1020.4249870,0.0,0.0,360.0);
	CreateDynamicObject(2336,1784.8123770,-2091.2712400,1020.4249870,0.0,0.0,-90.0);
	CreateDynamicObject(2833,1781.8343500,-2100.2910150,1020.4449460,0.0,0.0,90.0);
	CreateDynamicObject(1710,1776.4954830,-2098.8598630,1020.4249870,0.0,0.0,90.0);
	CreateDynamicObject(1712,1779.0634760,-2100.3264160,1020.4249870,0.0,0.0,540.0);
	CreateDynamicObject(1711,1780.7832030,-2094.8962400,1020.4249870,0.0,0.0,-50.0);
	CreateDynamicObject(2370,1778.2342520,-2098.1777340,1019.9749750,0.0,0.0,0.0);
	CreateDynamicObject(2860,1778.3322750,-2097.7478020,1020.8250120,0.0,0.0,0.0);
	CreateDynamicObject(1486,1778.5222160,-2098.1433100,1020.9650260,0.0,0.0,0.0);
	CreateDynamicObject(1486,1777.9296870,-2097.1660150,1020.9750360,0.0,0.0,0.0);
	CreateDynamicObject(1486,1778.4477530,-2097.1408690,1020.9650260,0.0,0.0,309.00);
	CreateDynamicObject(1486,1778.2239990,-2098.2153320,1020.9749750,0.0,0.0,0.0);
	CreateDynamicObject(2867,1784.9392080,-2093.1894530,1022.2249750,0.0,0.0,20.0);
	CreateDynamicObject(2845,1787.9145500,-2099.9150390,1020.4249870,0.0,0.0,0.0);
	CreateDynamicObject(355,1778.7670890,-2098.0148920,1020.4249870,95.00,90.0,0.0);
	CreateDynamicObject(348,1785.8033440,-2088.9555660,1018.6676020,90.0,90.0,3103.00);
	CreateDynamicObject(2073,1778.5797110,-2097.6547850,1024.3249510,0.0,0.0,0.0);
	CreateDynamicObject(2073,1787.8336180,-2098.0158690,1023.9249870,0.0,0.0,0.0);
	CreateDynamicObject(2069,1776.4211420,-2100.2165520,1020.4749750,0.0,0.0,0.0);
	CreateDynamicObject(2664,1778.2431640,-2092.7590330,1021.2250360,90.0,0.0,540.0);
	CreateDynamicObject(2237,1778.1198730,-2091.7966300,1021.0950310,-1.00,0.0,0.0);
	CreateDynamicObject(2237,1778.1667480,-2093.9550780,1021.0750120,0.0,0.0,0.0);
	CreateDynamicObject(2237,1776.8342280,-2093.9208980,1021.0750120,0.0,0.0,0.0);
	CreateDynamicObject(2237,1776.8503410,-2091.7832030,1021.0949090,0.0,0.0,0.0);
	CreateDynamicObject(2309,1778.4212640,-2092.2338860,1020.4249870,0.0,0.0,95.00);
	CreateDynamicObject(2309,1778.4429930,-2093.2512200,1020.4249870,0.0,0.0,60.0);
	CreateDynamicObject(2309,1776.3679190,-2092.1772460,1020.4249870,0.0,0.0,270.0);
	CreateDynamicObject(2309,1776.3626700,-2093.1772460,1020.4249870,0.0,0.0,270.0);
	CreateDynamicObject(1712,1780.6472160,-2085.9104000,12.5468750,0.0,0.0,10.0);
	CreateDynamicObject(355,1780.7954100,-2085.3303220,12.5468750,94.00,90.0,110.0);
	CreateDynamicObject(1710,1786.7463370,-2089.5944820,12.5468750,0.0,0.0,180.0);
	CreateDynamicObject(1481,1788.3486320,-2089.7543940,13.2468740,0.0,0.0,180.0);
	CreateDynamicObject(2232,1780.5020750,-2089.0212400,13.1468740,0.0,0.0,110.0);
	CreateDynamicObject(2319,1783.1854240,-2087.4980460,12.5468750,0.0,0.0,-5.00);
	CreateDynamicObject(1486,1783.8497310,-2087.3337400,13.1868750,0.0,0.0,0.0);
	CreateDynamicObject(1486,1783.3908690,-2087.2746580,13.1868760,0.0,0.0,30.0);
	CreateDynamicObject(1486,1784.5013420,-2087.7954100,13.1968720,0.0,0.0,0.0);
	CreateDynamicObject(1486,1783.5861810,-2087.6406250,13.1868750,0.0,0.0,0.0);
	CreateDynamicObject(1665,1784.3051750,-2087.6677240,13.0618740,0.0,0.0,0.0);
	CreateDynamicObject(1485,1784.1031490,-2087.6369620,13.0468750,0.0,0.0,0.0);
	CreateDynamicObject(1486,1780.1520990,-2088.9626460,13.8968740,0.0,0.0,0.0);
	CreateDynamicObject(1486,1780.4005120,-2089.1093750,13.8868730,0.0,0.0,630.0);
	CreateDynamicObject(1751,1783.0941160,-2090.3061520,1022.9249870,0.0,0.0,-30.0);
	CreateDynamicObject(2225,1779.8906250,-2100.8044430,1020.4249870,0.0,0.0,180.0);
	CreateDynamicObject(2673,1781.3226310,-2087.1347650,12.6268730,0.0,0.0,0.0);
	CreateDynamicObject(2673,1786.2702630,-2088.4018550,12.6468740,0.0,0.0,500.0);
	CreateDynamicObject(2673,1782.6525870,-2088.3400870,12.6468760,0.0,0.0,290.0);
	CreateDynamicObject(1328,1783.6999510,-2101.1848140,13.0468750,0.0,0.0,0.0);
	CreateDynamicObject(1265,1784.3254390,-2101.4477530,12.8468760,0.0,0.0,0.0);
	CreateDynamicObject(1409,1792.1660150,-2078.4208980,12.5468750,0.0,0.0,0.0);
	CreateDynamicObject(1430,1791.3288570,-2078.3825680,12.7468730,0.0,0.0,0.0);
	CreateDynamicObject(946,1787.9681390,-2078.0776360,14.2468730,0.0,0.0,180.0);
	CreateDynamicObject(3065,1790.0302730,-2079.5283200,12.6868750,300.0,500.0,0.0);
	obj = CreateDynamicObject(6959,1782.8812250,-2101.2368160,1022.9309080,90.0,0.0,0.0);
	return obj;
}

// Интерьеры домов
House_Int_CreateObjects()
{
	// A class
	CreateDynamicObject(14707, 204.55, 1035.88, 1087.60, 0.00, 0.00, 0.00);// num 1	CreateObject
	//
	CreateDynamicObject(14758, 111.52340, 1365.56250, 1084.73438, 0.0, 0.0, 0.0);// num 2	CreateObject
	CreateDynamicObject(14757, 126.26560, 1369.52344, 1084.52344, 0.0, 0.0, 0.0);// num 2 (design)
	CreateDynamicObject(1491, 110.14840, 1382.32813, 1082.85938, 0.0, 0.0, 270.0);// num 2 (door)
	CreateDynamicObject(1491, 118.34380, 1382.32813, 1082.84375, 0.0, 0.0, 270.0);// num 2 (door)
	CreateDynamicObject(1491, 111.51560, 1382.00781, 1087.36719, 0.0, 0.0, 0.0);// num 2 (door)
	CreateDynamicObject(1491, 121.66410, 1377.85938, 1087.35156, 0.0, 0.0, 0.0);// num 2 (door)
	CreateDynamicObject(1491, 121.66410, 1382.00781, 1087.36719, 0.0, 0.0, 0.0);// num 2 (door)
	CreateDynamicObject(1506, 110.76560, 1365.48438, 1082.85156, 0.0, 0.0, 0.0);// num 2 (main door)
	CreateDynamicObject(1506, 113.78910, 1365.50781, 1082.85156, 0.0, 0.0, 180.0);// num 2 (main door)
	//
	CreateDynamicObject(14706, 202.91, 1075.83, 1086.41, 0.00, 0.00, 0.00);// num 3	CreateObject
	//
	CreateDynamicObject(14754, 62.76, 1330.96, 1086.80, 0.00, 0.00, 0.00);// num 4		CreateObject
	CreateDynamicObject(14753, 51.95, 1340.80, 1089.95, 0.00, 0.00, 0.00);// num 4 (add)
	CreateDynamicObject(1506, 59.30, 1321.84, 1082.85, 0.00, 0.00, 0.00);// num 4 (door)
	//
	CreateDynamicObject(15059, 2315.48, -1124.89, 1053.29, 0.00, 0.00, 0.00);// num 5 (1)	CreateObject
	CreateDynamicObject(15048, 2315.48, -1124.89, 1053.29, 0.00, 0.00, 0.00);// num 5 (2)	CreateObject
	CreateDynamicObject(1506, 2322.92, -1129.98, 1049.69, 0.00, 0.00, 0.00);// num 5 (door)
	CreateDynamicObject(1506, 2324.42, -1129.98, 1049.69, 0.00, 0.00, 0.00);// num 5 (door 2)
	CreateDynamicObject(15050, 2330.33, -1120.30, 1051.91, 0.00, 0.00, 270.00);// num 5 (window)

	// B class
	CreateDynamicObject(14476, 2508.53, -1699.28, 1013.73, 0.00, 0.00, 0.00);// num 1 (1)	CreateObject
	CreateDynamicObject(14471, 2510.96, -1708.96, 1015.472, 0.00, 0.00, 180.00);// num 1 (2)	CreateObject
	CreateDynamicObject(14472, 2512.3740, -1709.06, 1015.230, 0.00, 0.00, 180.00);// num 1 (kitchen)	CreateObject
	CreateDynamicObject(1498, 2511.23, -1691.63, 1013.73, 0.00, 0.00, 180.00);// num 1 (door)
	CreateDynamicObject(1567, 2506.11, -1709.01, 1017.332, 0.00, 0.00, 0.00);// num 1 (door 2)
	//
	CreateDynamicObject(14750, 27.30, 1366.60, 1089.88, 0.00, 0.00, 0.00);// num 2	CreateObject
	CreateDynamicObject(1506, 24.76, 1357.25, 1083.36, 0.00, 0.00, 180.00);// num 2 (door)
	CreateDynamicObject(14751, 34.54, 1360.92, 1085.83, 0.00, 0.00, 0.00);// num 2 (шторы)
	//
	CreateDynamicObject(14701, 447.43, 1382.60, 1085.38, 0.00, 0.00, 0.00);// num 3	CreateObject
	CreateDynamicObject(1506, 446.29, 1372.13, 1083.28, 0.00, 0.00, 0.00);// num 3 (door)
	//
	CreateDynamicObject(14708, 208.21, 1113.21, 1081.76, 0.00, 0.00, 270.00);// num 4	CreateObject
	//
	CreateDynamicObject(14703, 518.49, 1411.59, 1083.55, 0.00, 0.00, 0.00);// num 5	CreateObject
	CreateDynamicObject(1504, 520.38, 1398.06, 1079.24, 0.00, 0.00, 0.00);// num 5 (door)
	CreateDynamicObject(14715, 522.44, 1408.14, 1082.11, 0.00, 0.00, 0.00);// num 5 (stair 1)
	CreateDynamicObject(14722, 522.44, 1408.14, 1082.11, 0.00, 0.00, 0.00);// num 5 (stair 2)
	CreateDynamicObject(14723, 522.44, 1408.14, 1082.11, 0.00, 0.00, 0.00);// num 5 (stair 3)
	CreateDynamicObject(14724, 522.44, 1408.14, 1082.11, 0.00, 0.00, 0.00);// num 5 (stair 4)

	// C class
	CreateDynamicObject(14717, 203.33, 1245.84, 1082.88, 0.00, 0.00, 0.00);// num 1	CreateObject
	CreateDynamicObject(1567, 198.68, 1252.05, 1081.11, 0.00, 0.00, 270.00);// num 1 (door)
	CreateDynamicObject(1498, 207.21, 1240.73, 1081.13, 0.00, 0.00, 270.00);// num 1 (door 2)
	//
	CreateDynamicObject(14709, 209.23, 1150.16, 1083.08, 0.00, 0.00, 0.00);// num 2	CreateObject
	//
	CreateDynamicObject(14714, 274.14, 1479.97, 1081.06, 0.00, 0.00, 0.00);// num 3	CreateObject
	CreateDynamicObject(1498, 273.37, 1471.80, 1079.24, 0.00, 0.00, 0.00);// num 3 (door)
	//
	CreateDynamicObject(14712, 242.80, 1244.48, 1084.83, 0.00, 0.00, 0.00);// num 4	CreateObject
	CreateDynamicObject(1498, 245.00, 1236.78, 1083.23, 0.00, 0.00, 0.00);// num 4 (door)
	//
	CreateDynamicObject(14711, 359.05, 1464.31, 1080.79, 0.00, 0.00, 0.00);// num 5	CreateObject
	CreateDynamicObject(1498, 368.15, 1472.52, 1079.19, 0.00, 0.00, 270.00);// num 5 (door)

	// D class
	CreateDynamicObject(14755, -86.66, 1343.55, 1080.46, 0.00, 0.00, 0.00);// num 1	CreateObject
	CreateDynamicObject(1498, -86.06, 1350.77, 1079.20, 0.00, 0.00, 180.00);// num 1 (door)
	//
	CreateDynamicObject(14756, -62.58, 1405.77, 1085.43, 0.00, 0.00, 270.00);// num 2	CreateObject
	CreateDynamicObject(1506, -63.34, 1405.03, 1083.43, 0.00, 0.00, 0.00);// num 2 (door)
	//
	CreateDynamicObject(14718, 220.13, 1279.13, 1081.13, 0.00, 0.00, 0.00);// num 3	CreateObject
	CreateDynamicObject(1498, 222.37, 1274.13, 1081.13, 0.00, 0.00, 0.00);// num 3 (door)
	//
	CreateDynamicObject(15042, 2313.84375, -1229.73438, 1050.02344, 0.00, 0.00, 0.00);// num 4	CreateObject
	CreateDynamicObject(15052, 2313.84375, -1229.73438, 1049.55469, 0.00, 0.00, 0.00);// num 4 (fixed design)
	CreateDynamicObject(1501, 2308.03906, -1230.37500, 1048.01563, 0.00, 0.00, 0.00);// num 4 (door main)
	CreateDynamicObject(1567, 2320.21094, -1230.28906, 1048.03125, 0.00, 0.00, 180.00);// num 4 (door back)
	//
	CreateDynamicObject(14746, 2439.97, -1702.14, 1014.29, 0.00, 0.00, 0.00);// num 5	CreateObject
	CreateDynamicObject(14740, 2434.93, -1686.99, 1014.76, 0.00, 0.00, 0.00);// num 5 (windows)
	CreateDynamicObject(1498, 2444.95, -1697.53, 1012.51, 0.00, 0.00, 270.00);// num 5 (door)
	CreateDynamicObject(14763, 2435.75, -1694.26, 1014.06, 0.00, 0.00, 270.00);// num 5 (light)

	// E class
	CreateDynamicObject(14859, 239.16, 303.84, 1000.15, 0.00, 0.00, 0.00);// num 1	CreateObject
	//
	CreateDynamicObject(14865, 261.20, 305.64, 1000.15, 0.00, 0.00, 0.00);// num 2	CreateObject
	//
	CreateDynamicObject(14876, 304.83, 290.60, 1003.22, 0.00, 0.00, 0.00);// num 3	CreateObject
	CreateDynamicObject(983, 303.55, 285.73, 1002.99, 0.00, 0.00, 0.00);// num 3 (half-wall)
	CreateDynamicObject(14877, 306.45, 296.70, 1000.22, 0.00, 0.00, 0.00);// num 3 (stair)
	CreateDynamicObject(1498, 308.67, 295.04, 1002.30, 0.00, 0.00, 0.00);// num 3 (door)
	//
	CreateDynamicObject(14889, 355.30, 305.80, 1000.40, 0.00, 0.00, 0.00);// num 4	CreateObject
	//
	CreateDynamicObject(16407, 419.38, 2540.51, 2.89, 0.00, 0.00, 0.00);// num 5	CreateObject
	CreateDynamicObject(1498, 423.02, 2535.73, 2.48, 0.00, 0.00, 90.00);// num 5 (door)
	obj = CreateDynamicObject(1567, 412.97, 2536.01, 2.50, 0.00, 0.00, 90.00);// num 5 (door 2)
	return obj;
}

// Больница (interior)
Hospital_Int_CreateObjects()
{
	//Objects////////////////////////////////////////////////////////////////////////////////////////////////////////
	new tmpobjid;
	tmpobjid = CreateDynamicObject(8555, -2657.758789, 628.686523, 1249.915527, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 7, 4550, "skyscr1_lan2", "sl_librarywall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2630.136718, 626.530273, 1275.810058, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2629.644042, 629.192993, 1275.810058, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2629.644042, 624.203002, 1275.810058, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19465, -2632.485107, 621.362121, 1275.810058, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2631.256835, 623.355468, 1275.810058, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(2439, -2634.714111, 623.000976, 1273.258056, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-40-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(2439, -2635.715820, 623.000976, 1273.258056, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-40-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(2439, -2636.717529, 623.000976, 1273.258056, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-40-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(2440, -2638.714111, 623.002380, 1273.258056, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-40-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(2439, -2637.719238, 623.000976, 1273.258056, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-40-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(2439, -2638.746582, 621.995544, 1273.258056, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-40-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(2439, -2638.746582, 620.993774, 1273.258056, 0.000000, 0.000000, 269.994506, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-40-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(2439, -2638.746582, 619.992309, 1273.258056, 0.000000, 0.000000, 269.994506, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 18646, "matcolours", "grey-40-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2630.325195, 618.350585, 1275.810058, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19757, -2639.191894, 623.455017, 1322.093994, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19325, -2635.794921, 623.452148, 1277.490966, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, "bigwhitesfe", "sfe_arch8", 0x00000000);
	tmpobjid = CreateDynamicObject(19325, -2639.229492, 620.099975, 1277.490966, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, "bigwhitesfe", "sfe_arch8", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2632.485107, 632.034179, 1275.810058, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2631.379882, 634.806030, 1275.810058, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19757, -2637.258789, 631.342773, 1322.093994, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19787, -2637.245117, 631.232971, 1275.859985, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 15040, "cuntcuts", "GB_canvas17", 0x00000000);
	tmpobjid = CreateDynamicObject(19787, -2637.245117, 631.459960, 1275.859985, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 15040, "cuntcuts", "GB_canvas17", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2634.222167, 637.647766, 1275.810058, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2636.802734, 637.222656, 1275.810058, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2642.735351, 637.222656, 1275.810058, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19465, -2645.805664, 634.175781, 1275.810058, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2647.706054, 631.081054, 1275.810058, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2644.864257, 628.240234, 1275.810058, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2646.039062, 628.330017, 1271.534057, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2643.198242, 625.330017, 1271.533325, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2646.039062, 622.330017, 1271.534057, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19325, -2646.483398, 626.330017, 1273.996948, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3653, "beachapts_lax", "sjmscorclawn", 0x00000000);
	tmpobjid = CreateDynamicObject(19325, -2646.483886, 624.330017, 1273.997680, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3653, "beachapts_lax", "sjmscorclawn", 0x00000000);
	tmpobjid = CreateDynamicObject(19089, -2639.072265, 623.456054, 1275.417968, 0.000000, 270.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19089, -2639.236083, 616.156982, 1275.417968, 0.000000, 269.994506, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2639.167968, 615.507812, 1275.810058, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2644.864257, 622.303710, 1275.810058, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2647.706054, 619.458007, 1275.810058, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19465, -2645.805664, 616.385742, 1275.810058, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2642.861083, 613.343017, 1275.810058, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2636.924560, 613.343017, 1275.810058, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19465, -2646.060546, 616.385742, 1275.810058, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "hottop5d_law", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2649.063476, 618.657226, 1275.810058, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "hottop5d_law", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2649.063964, 613.931030, 1275.810058, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "hottop5d_law", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, -2657.012695, 618.793945, 1274.043945, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 4550, "skyscr1_lan2", "sl_librarywall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, -2667.513671, 618.793945, 1274.043945, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 4550, "skyscr1_lan2", "sl_librarywall1", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2655.000000, 618.657226, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "hottop5d_law", 0x00000000);
	tmpobjid = CreateDynamicObject(19325, -2654.073242, 613.976562, 1276.192993, 90.000000, 179.994506, 89.994506, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, "bigwhitesfe", "sfe_arch8", 0x00000000);
	tmpobjid = CreateDynamicObject(19465, -2659.023437, 613.930664, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "hottop5d_law", 0x00000000);
	tmpobjid = CreateDynamicObject(19325, -2664.025390, 613.976562, 1276.192993, 90.000000, 179.994506, 89.989013, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, "bigwhitesfe", "sfe_arch8", 0x00000000);
	tmpobjid = CreateDynamicObject(19465, -2669.047119, 613.931030, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "hottop5d_law", 0x00000000);
	tmpobjid = CreateDynamicObject(19089, -2652.029296, 613.996093, 1281.089965, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2672.142089, 616.315979, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "hottop5d_law", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2660.936523, 618.657226, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "hottop5d_law", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2666.872070, 618.657226, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "hottop5d_law", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2672.808593, 618.657226, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "hottop5d_law", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, -2657.012695, 609.159179, 1274.043945, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14710, "vgshm3int2", "HSV_3carpet2", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, -2667.513671, 609.159179, 1274.043945, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14710, "vgshm3int2", "HSV_3carpet2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2651.903320, 610.833984, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "hottop5d_law", 0x00000000);
	tmpobjid = CreateDynamicObject(19089, -2651.925781, 613.996093, 1278.279907, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19089, -2656.033935, 613.996582, 1281.089965, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19089, -2661.997070, 613.996582, 1281.089965, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19089, -2666.064453, 613.996093, 1281.089965, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19089, -2659.465332, 613.996093, 1278.279907, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2655.000000, 607.747985, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 15041, "bigsfsave", "windo_blinds", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2660.936523, 607.747070, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 15041, "bigsfsave", "windo_blinds", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2666.872070, 607.747070, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 15041, "bigsfsave", "windo_blinds", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2672.809082, 607.747985, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 15041, "bigsfsave", "windo_blinds", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2672.132080, 610.834655, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "hottop5d_law", 0x00000000);
	tmpobjid = CreateDynamicObject(19089, -2650.847656, 613.996093, 1274.141967, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19089, -2660.812988, 613.996582, 1274.141967, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19378, -2651.185058, 633.541015, 1273.172973, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5766, "capitol_lawn", "capitol3_LAwN", 0xFFA3A29E);
	tmpobjid = CreateDynamicObject(19464, -2661.864257, 610.833984, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3603, "bevmans01_la", "hottop5d_law", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2649.063476, 637.252929, 1275.810058, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2649.063476, 631.205078, 1275.810058, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(19465, -2646.060546, 634.175781, 1275.810058, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, -2657.018554, 632.409423, 1274.043945, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5766, "capitol_lawn", "capitol3_LAwN", 0xFFA3A29E);
	tmpobjid = CreateDynamicObject(19379, -2667.513671, 632.409179, 1274.043945, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5766, "capitol_lawn", "capitol3_LAwN", 0xFFA3A29E);
	tmpobjid = CreateDynamicObject(19465, -2655.000000, 637.252929, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2660.936523, 637.252929, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(19465, -2666.872070, 637.252929, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, -2678.012695, 632.409179, 1274.043945, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5766, "capitol_lawn", "capitol3_LAwN", 0xFFA3A29E);
	tmpobjid = CreateDynamicObject(19464, -2672.808593, 637.252929, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, -2663.178710, 626.503906, 1274.044555, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 15055, "svlamid", "AH_flroortile3", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2655.000000, 631.205078, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(19325, -2660.025390, 631.322265, 1273.310058, 90.000000, 179.994506, 89.994506, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, "bigwhitesfe", "sfe_arch8", 0x00000000);
	tmpobjid = CreateDynamicObject(1499, -2663.596679, 631.266601, 1274.132324, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_carpet2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14701, "lahss2int2", "HS2_Artex3", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19325, -2665.638671, 631.322265, 1273.310058, 90.000000, 180.005493, 89.983520, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, "bigwhitesfe", "sfe_arch8", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, -2673.680664, 626.503906, 1274.045043, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 15055, "svlamid", "AH_flroortile3", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2671.327148, 631.205078, 1276.682983, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(19325, -2659.455078, 631.322265, 1278.694580, 0.000000, 180.005493, 89.983520, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, "bigwhitesfe", "sfe_arch8", 0x00000000);
	tmpobjid = CreateDynamicObject(19325, -2666.097656, 631.322265, 1278.694580, 0.000000, 180.005493, 89.983520, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, "bigwhitesfe", "sfe_arch8", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2657.844482, 628.351562, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2660.919921, 625.253906, 1276.682983, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6286, "santamonhus1", "fivewins_law", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2666.855468, 625.253906, 1276.682983, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6286, "santamonhus1", "fivewins_law", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2672.791992, 625.253906, 1276.682983, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6286, "santamonhus1", "fivewins_law", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2671.060546, 628.112304, 1276.682983, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6988, "vgnfremnt1", "vgnhotelwin2", 0x00000000);
	tmpobjid = CreateDynamicObject(19375, -2657.018554, 641.993164, 1274.043945, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "ws_stationfloor", 0x00000000);
	tmpobjid = CreateDynamicObject(19375, -2667.513671, 641.993164, 1274.043945, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "ws_stationfloor", 0x00000000);
	tmpobjid = CreateDynamicObject(19375, -2678.012695, 641.993164, 1274.043945, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "ws_stationfloor", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2677.264404, 631.205993, 1276.682983, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(19465, -2675.861328, 634.177734, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(1493, -2659.783, 613.993, 1274.13, 0.0, 0.0, 130.0);
	SetDynamicObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_carpet2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 17588, "lae2coast_alpha", "plainglass", 0x00000000);
	tmpobjid = CreateDynamicObject(1493, -2669.811, 613.993, 1274.13, 0.0, 0.0, 130.0);
	SetDynamicObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_carpet2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 17588, "lae2coast_alpha", "plainglass", 0x00000000);
	tmpobjid = CreateDynamicObject(19176, -2630.261962, 626.781005, 1274.729003, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(2207, -2636.341064, 630.385986, 1278.558959, 0.000000, 179.994506, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(2207, -2638.189453, 632.297851, 1278.558959, 0.000000, 179.994506, 179.994506, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19089, -2657.439453, 631.309570, 1276.665039, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19089, -2664.799804, 631.311523, 1276.665039, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19089, -2662.785888, 631.312011, 1284.038940, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(1499, -2645.949951, 617.141601, 1273.260986, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_carpet2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14701, "lahss2int2", "HS2_Artex3", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1499, -2645.949951, 634.930664, 1273.260986, 0.000000, 0.000000, 269.989013, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_carpet2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14701, "lahss2int2", "HS2_Artex3", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19379, -2633.509033, 618.525024, 1273.172973, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14815, "whore_main", "WH_tiles2", 0x00000000);
	tmpobjid = CreateDynamicObject(1499, -2667.627929, 637.194335, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_carpet2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14701, "lahss2int2", "HS2_Artex3", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1499, -2655.758789, 637.195007, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_carpet2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14701, "lahss2int2", "HS2_Artex3", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19464, -2680.113037, 628.349975, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2678.925048, 637.229980, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, -2688.511962, 632.409973, 1274.043945, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5766, "capitol_lawn", "capitol3_LAwN", 0xFFA3A29E);
	tmpobjid = CreateDynamicObject(19464, -2684.860107, 637.229980, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(19465, -2684.715087, 630.018005, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(19379, -2678.012695, 622.776367, 1274.043945, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5766, "capitol_lawn", "capitol3_LAwN", 0xFFA3A29E);
	tmpobjid = CreateDynamicObject(19379, -2688.511718, 622.776367, 1274.043945, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 5766, "capitol_lawn", "capitol3_LAwN", 0xFFA3A29E);
	tmpobjid = CreateDynamicObject(19465, -2684.721679, 624.079101, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(1846, -2642.956054, 638.047851, 1275.635009, 180.000000, 90.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 3984, "lanbloki", "churchwin1_LAn", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2680.112304, 622.414062, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(1846, -2637.920898, 638.047851, 1275.635009, 180.000000, 90.000000, 269.989013, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 3984, "lanbloki", "churchwin1_LAn", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2681.694091, 621.383972, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8639, "chinatownmall", "ctmall18_64", 0x00000000);
	tmpobjid = CreateDynamicObject(1499, -2675.814941, 634.934448, 1274.130004, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_carpet2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14701, "lahss2int2", "HS2_Artex3", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(1493, -2684.657714, 630.778015, 1274.130004, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_carpet2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 17588, "lae2coast_alpha", "plainglass", 0x00000000);
	tmpobjid = CreateDynamicObject(1493, -2684.657226, 624.839843, 1274.130004, 0.000000, 0.000000, 269.989013, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_carpet2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 17588, "lae2coast_alpha", "plainglass", 0x00000000);
	tmpobjid = CreateDynamicObject(19863, -2644.760009, 625.312988, 1277.275024, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0x00000000);
	tmpobjid = CreateDynamicObject(19376, -2689.955078, 622.260742, 1274.045043, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "ws_stationfloor", 0x00000000);
	tmpobjid = CreateDynamicObject(1846, -2686.933105, 620.539001, 1275.130981, 0.000000, 180.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19379, -2623.008789, 618.525024, 1273.172973, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14815, "whore_main", "WH_tiles2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2625.320068, 623.355468, 1275.812988, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(19464, -2627.282958, 621.223022, 1275.812988, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14383, "burg_1", "hospital_wall2", 0x00000000);
	tmpobjid = CreateDynamicObject(1499, -2632.542968, 622.119995, 1273.260986, 0.000000, 0.000000, 269.989013, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14808, "lee_strip2", "strip_carpet2", 0x00000000);
	SetDynamicObjectMaterial(tmpobjid, 1, 14701, "lahss2int2", "HS2_Artex3", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(8555, -2625.838867, 617.781250, 1301.547851, 0.000000, 179.994506, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 7, 11301, "carshow_sfse", "ws_officy_ceiling", 0x00000000);
	tmpobjid = CreateDynamicObject(1846, -2631.650390, 631.500976, 1275.635009, 179.994506, 90.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 3984, "lanbloki", "churchwin1_LAn", 0x00000000);
	tmpobjid = CreateDynamicObject(1846, -2661.447265, 647.515625, 1276.590942, 180.000000, 90.000000, 269.989013, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 3984, "lanbloki", "churchwin1_LAn", 0x00000000);
	tmpobjid = CreateDynamicObject(1846, -2657.863281, 647.515625, 1276.590942, 180.000000, 90.000000, 269.989013, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 3984, "lanbloki", "churchwin1_LAn", 0x00000000);
	tmpobjid = CreateDynamicObject(8555, -2670.686035, 627.263977, 1301.641967, 0.000000, 179.994506, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 7, 11301, "carshow_sfse", "ws_officy_ceiling", 0xFFCFCFCF);
	tmpobjid = CreateDynamicObject(1846, -2654.383789, 647.515625, 1276.590942, 180.000000, 90.000000, 269.989013, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 3984, "lanbloki", "churchwin1_LAn", 0x00000000);
	tmpobjid = CreateDynamicObject(1846, -2673.510742, 647.515625, 1276.590942, 180.000000, 90.000000, 269.989013, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 3984, "lanbloki", "churchwin1_LAn", 0x00000000);
	tmpobjid = CreateDynamicObject(1846, -2669.926757, 647.515625, 1276.590942, 179.994506, 90.000000, 269.989013, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 3984, "lanbloki", "churchwin1_LAn", 0x00000000);
	tmpobjid = CreateDynamicObject(1846, -2666.492187, 647.515625, 1276.590942, 180.000000, 90.000000, 269.989013, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	SetDynamicObjectMaterial(tmpobjid, 1, 3984, "lanbloki", "churchwin1_LAn", 0x00000000);
	tmpobjid = CreateDynamicObject(19329, -2636.734375, 623.451171, 1276.643920, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "RECEPTION", 120, "Quartz MS", 100, 0, 0xFF000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19329, -2654.142089, 613.976989, 1276.057983, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "INTERVIEWS ROOM", 120, "Quartz MS", 50, 0, 0xFF000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19329, -2664.012939, 613.976989, 1276.057983, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "OFFICE", 120, "Engravers MT", 60, 0, 0xFF000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19329, -2684.657958, 635.085998, 1275.833007, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "CONFERENCE\nHALL", 120, "Quartz MS", 70, 0, 0xFF000000, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(18066, -2657.164062, 637.169006, 1275.488037, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(18066, -2669.072021, 637.169006, 1275.488037, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19329, -2657.157958, 637.127990, 1275.497436, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "CHAMBER 1", 120, "Quartz MS", 50, 0, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19329, -2669.086914, 637.127990, 1275.493652, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "CHAMBER 2", 120, "Quartz MS", 50, 0, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(18066, -2684.638183, 626.164978, 1275.488037, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 18646, "matcolours", "grey-90-percent", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19327, -2644.730957, 625.343994, 1276.450927, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "LOS-SANTOS", 120, "Quartz MS", 80, 0, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19327, -2644.730957, 625.336975, 1276.140136, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "_________________", 100, "Engravers MT", 100, 0, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19327, -2644.730957, 625.320983, 1275.660644, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "MEDICAL CENTER", 130, "Engravers MT", 50, 0, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19328, -2644.730957, 623.503112, 1276.004028, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{", 100, "Wingdings", 199, 0, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19329, -2684.596923, 626.120056, 1275.492919, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Operating", 90, "Calibri", 40, 1, 0xFFFFFFFF, 0x00000000, 1);
	tmpobjid = CreateDynamicObject(19329, -2686.854980, 619.007019, 1277.680053, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3801, "sfxref", "sfxref_aircon4", 0x00000000);
	tmpobjid = CreateDynamicObject(2001, -2644.969970, 613.880004, 1273.235961, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFFFFFFFF);
	tmpobjid = CreateDynamicObject(19329, -2627.406982, 620.905029, 1277.579956, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3801, "sfxref", "sfxref_aircon3", 0x00000000);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(19464, -2636.261718, 618.350585, 1275.810058, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1703, -2636.287109, 632.166992, 1273.258056, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1703, -2638.307617, 630.504882, 1273.258056, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1703, -2639.069335, 632.346679, 1273.258056, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1703, -2635.529052, 630.328002, 1273.258056, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(869, -2645.416015, 624.098022, 1274.447998, 0.000000, 0.000000, 357.495117, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(869, -2645.409912, 626.354980, 1274.447998, 0.000000, 0.000000, 357.495117, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(14394, -2650.957031, 616.103515, 1273.311035, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(14394, -2650.957031, 634.473632, 1273.311035, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19325, -2669.762695, 631.322265, 1273.310058, 90.000000, 180.005493, 89.983520, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(11711, -2630.237060, 626.768981, 1276.609985, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2308, -2633.104003, 619.965026, 1273.244995, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2310, -2634.275878, 620.169006, 1273.744995, 0.000000, 0.000000, 135.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2165, -2653.769042, 612.434020, 1274.130004, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1715, -2652.398437, 613.102539, 1274.130004, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2165, -2653.768554, 608.362304, 1274.130004, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1715, -2652.398925, 608.901977, 1274.130004, 0.000000, 0.000000, 269.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2191, -2657.419921, 613.307006, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1814, -2659.863281, 609.686523, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1713, -2661.211914, 609.302734, 1274.130004, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1713, -2658.641113, 608.385009, 1274.130004, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2011, -2661.282958, 611.711975, 1274.129028, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2162, -2652.002929, 613.114257, 1276.279052, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2162, -2652.002929, 609.578125, 1276.279052, 0.000000, 0.000000, 269.989013, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2608, -2636.556884, 618.643005, 1275.355957, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2182, -2662.479003, 609.377990, 1274.130004, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2198, -2667.001953, 613.366027, 1274.130004, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2198, -2665.965087, 612.343994, 1274.130004, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2198, -2662.531982, 613.366027, 1274.130004, 0.000000, 0.000000, 269.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2131, -2689.523925, 619.486999, 1274.130004, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2198, -2667.001953, 609.395019, 1274.130004, 0.000000, 0.000000, 269.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2198, -2665.965087, 608.372985, 1274.130004, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2356, -2668.435058, 612.611999, 1274.130004, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2356, -2668.435058, 608.664978, 1274.130004, 0.000000, 0.000000, 269.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2356, -2663.971923, 612.666015, 1274.130004, 0.000000, 0.000000, 269.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2356, -2663.681884, 609.711975, 1274.130004, 0.000000, 0.000000, 225.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2356, -2664.482910, 609.031982, 1274.130004, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2356, -2664.482910, 613.036987, 1274.130004, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2162, -2661.935058, 613.247985, 1276.279052, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2162, -2661.964111, 609.581970, 1276.279052, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19465, -2655.000000, 637.508789, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19465, -2666.872070, 637.508789, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2660.936523, 637.508789, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2672.808593, 637.508789, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2651.979492, 640.527343, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2651.979980, 646.464416, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2663.958007, 640.527343, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2663.958007, 646.463867, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2655.000000, 646.685546, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2660.936523, 646.685546, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2666.872070, 646.685546, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2672.808593, 646.685546, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2675.889648, 640.527343, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2675.889892, 646.464416, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(14532, -2661.260009, 625.762023, 1275.113037, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1997, -2659.735107, 626.421020, 1274.130981, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1997, -2662.826904, 626.421020, 1274.130981, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1997, -2666.098632, 626.420898, 1274.130981, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1997, -2669.345947, 626.421020, 1274.130981, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(14532, -2664.484375, 625.761718, 1275.113037, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(14532, -2667.794921, 625.762023, 1275.113037, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1796, -2656.810058, 641.166992, 1274.130004, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1796, -2659.836914, 641.166992, 1274.130004, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1796, -2663.041992, 641.166992, 1274.130004, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1796, -2668.728515, 641.166992, 1274.130004, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1796, -2671.906250, 641.166992, 1274.130004, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1796, -2675.048095, 641.166992, 1274.130004, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1796, -2675.225097, 643.059020, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1796, -2671.887939, 643.059020, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1796, -2668.311035, 643.059020, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1796, -2664.812988, 643.059020, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1796, -2663.302978, 643.059020, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1796, -2659.831054, 643.058593, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1796, -2656.257080, 643.059020, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1796, -2652.858886, 643.059020, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2339, -2673.516601, 646.065429, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2339, -2669.924072, 646.065979, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2339, -2666.483398, 646.065429, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2339, -2661.454101, 646.065429, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2339, -2657.924072, 646.065979, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2339, -2654.375000, 646.065429, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2339, -2673.604980, 638.111022, 1274.130004, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2339, -2670.466064, 638.111022, 1274.130004, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2339, -2661.615966, 638.111022, 1274.130004, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2339, -2658.437988, 638.111022, 1274.130004, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1703, -2670.227050, 618.018005, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1703, -2662.666015, 618.017578, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1703, -2654.781250, 618.017578, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19325, -2684.658203, 635.033203, 1276.192993, 90.000000, 180.005493, 179.983520, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2687.796875, 627.000000, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2690.787109, 637.229980, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2693.721679, 627.000000, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2693.629882, 628.435485, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2693.629882, 634.370971, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2691.893554, 624.079101, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2684.721679, 618.145507, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2691.894042, 618.145568, 1276.682006, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2687.797119, 618.882019, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2693.721923, 618.882019, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1726, -2686.320068, 636.604980, 1274.130004, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1726, -2686.320068, 633.153991, 1274.130004, 0.000000, 0.000000, 269.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1726, -2688.467041, 636.604980, 1274.130004, 0.000000, 0.000000, 269.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1726, -2688.466796, 633.153320, 1274.130004, 0.000000, 0.000000, 269.989013, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1727, -2686.320068, 628.565002, 1274.130004, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1727, -2688.467041, 628.565002, 1274.130004, 0.000000, 0.000000, 269.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19863, -2693.521484, 633.907226, 1277.529052, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1999, -2691.743896, 629.260009, 1274.130004, 0.000000, 0.000000, 315.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1715, -2692.090087, 627.585021, 1274.130004, 0.000000, 0.000000, 135.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2132, -2691.261962, 620.213989, 1274.130004, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2339, -2691.510986, 619.494018, 1274.130004, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2339, -2691.278076, 622.213989, 1274.130004, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2339, -2691.279052, 623.213012, 1274.130004, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1997, -2686.927978, 620.614990, 1274.130981, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19903, -2688.343017, 619.539001, 1274.130981, 0.000000, 0.000000, 61.248779, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(14532, -2685.757080, 619.614990, 1275.114013, 0.000000, 0.000000, 56.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(14532, -2685.521972, 620.698974, 1275.114013, 0.000000, 0.000000, 90.747314, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1513, -2691.593994, 622.716003, 1275.765991, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(3389, -2691.589111, 624.218017, 1274.130981, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(3387, -2691.589111, 625.297973, 1274.130981, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(3388, -2691.589111, 626.369995, 1274.130981, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(3394, -2686.541015, 626.276977, 1274.130981, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2687.796875, 627.125000, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2693.721679, 627.125000, 1276.682006, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2811, -2670.960937, 618.038024, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2811, -2663.399902, 618.038024, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2811, -2655.540039, 618.038024, 1274.130004, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19464, -2627.849121, 629.026000, 1275.812988, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(11729, -2628.270019, 622.969970, 1273.260986, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(11729, -2627.683105, 622.390014, 1273.260986, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(11729, -2628.937011, 622.969970, 1273.260986, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(11729, -2627.683105, 621.715026, 1273.260986, 0.000000, 0.000000, 269.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(11730, -2627.683105, 621.046020, 1273.260986, 0.000000, 0.000000, 269.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(11730, -2629.605957, 622.969970, 1273.260986, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(11729, -2630.275878, 622.969970, 1273.260986, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1569, -2629.095947, 618.447021, 1273.260986, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1569, -2639.257080, 616.695007, 1273.260986, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1302, -2634.621093, 636.460998, 1273.260986, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1775, -2634.612060, 635.301025, 1274.358032, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1776, -2633.241943, 634.318969, 1274.359985, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1726, -2671.439941, 608.153991, 1274.130004, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1726, -2671.439941, 611.539001, 1274.130004, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(18075, -2638.263916, 623.539978, 1278.400024, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(18075, -2638.263916, 636.150024, 1278.400024, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(18075, -2664.255859, 625.487304, 1278.318969, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1893, -2654.913085, 633.715820, 1278.724975, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1893, -2663.317382, 633.715820, 1278.724975, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1893, -2672.396484, 633.715820, 1278.724975, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1893, -2652.266601, 615.668945, 1278.724975, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1893, -2660.854492, 615.668945, 1278.724975, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1893, -2669.866943, 615.669006, 1278.724975, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1893, -2683.008789, 633.422851, 1278.724975, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1893, -2683.008789, 623.782226, 1278.724975, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19825, -2684.888916, 624.060974, 1277.209960, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1721, -2689.839111, 626.697998, 1274.130981, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1721, -2689.261962, 626.697998, 1274.130981, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1721, -2631.750000, 623.072265, 1273.260986, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1721, -2631.172119, 623.072998, 1273.260986, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2690, -2628.666992, 618.627929, 1273.772949, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1703, -2642.242919, 614.000000, 1273.260986, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2110, -2641.336914, 613.988281, 1272.961059, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(18075, -2656.883056, 608.158996, 1278.318969, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(18075, -2667.003906, 608.159179, 1278.318969, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1893, -2654.375000, 641.630004, 1278.724975, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1893, -2661.454101, 641.629882, 1278.724975, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1893, -2666.483398, 641.630004, 1278.800048, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1893, -2673.516601, 641.630004, 1278.800048, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1893, -2630.414062, 620.844970, 1278.681030, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2146, -2671.693115, 631.836975, 1274.615966, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1789, -2669.790039, 630.706970, 1274.687011, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2690, -2665.610107, 637.783996, 1274.600952, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2690, -2653.788085, 637.783996, 1274.600952, 0.000000, 0.000000, 179.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2116, -2664.595947, 640.585998, 1274.130004, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(2116, -2652.631103, 640.585998, 1274.130004, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19787, -2652.104980, 641.068969, 1276.172973, 0.000000, 0.000000, 270.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(19787, -2664.083007, 641.068969, 1276.172973, 0.000000, 0.000000, 269.994506, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1721, -2664.371093, 642.492004, 1274.130004, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1721, -2652.357910, 642.492004, 1274.130004, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(18075, -2689.188964, 634.156982, 1278.318969, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	tmpobjid = CreateDynamicObject(1893, -2688.250976, 622.270019, 1278.724975, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);


	obj = CreateDynamicObject(18030, 662.526, -339.767, -93.418, 0.0, 0.0, 0.0); //object(gap) (1)
	Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT, obj, true);
	CreateDynamicObject(19462,657.5625000,-335.1211853,-94.0350037,90.0,0.0,90.0); //object(wall102) (1)
	CreateDynamicObject(19462,659.4669800,-330.2080078,-90.6035004,0.0,0.0,0.0); //object(wall102) (3)
	CreateDynamicObject(19462,659.4669800,-330.2080078,-94.0350037,0.0,0.0,0.0); //object(wall102) (5)
	CreateDynamicObject(19462,655.4296875,-330.3154297,-94.0350037,0.0,0.0,0.0); //object(wall102) (6)
	CreateDynamicObject(19462,647.9780273,-330.2890015,-90.6035004,0.0,0.0,358.50); //object(wall102) (7)
	CreateDynamicObject(19462,667.2548828,-329.8662109,-94.0350037,0.0,0.0,0.0); //object(wall102) (11)
	CreateDynamicObject(19462,647.6610107,-330.1319885,-94.0350037,0.0,0.0,0.0); //object(wall102) (14)
	CreateDynamicObject(19462,659.4667969,-330.2080078,-90.6035004,0.0,0.0,0.0); //object(wall102) (16)
	CreateDynamicObject(19462,655.4296875,-330.3154297,-90.6035004,0.0,0.0,0.0); //object(wall102) (17)
	CreateDynamicObject(19462,647.9775391,-330.2880859,-94.0350037,0.0,0.0,358.4948730); //object(wall102) (18)
	CreateDynamicObject(19462,647.6601562,-330.1318359,-90.6035004,0.0,0.0,0.0); //object(wall102) (19)
	CreateDynamicObject(19462,667.2548828,-329.8662109,-90.6035004,0.0,0.0,0.0); //object(wall102) (20)
	CreateDynamicObject(19462,674.4056396,-338.7207031,-94.0350037,90.0,0.0,0.0); //object(wall102) (21)
	CreateDynamicObject(19462,674.4100952,-340.5859375,-94.0350037,90.0,0.0,0.0); //object(wall102) (23)
	CreateDynamicObject(19462,640.5986328,-340.5859375,-94.0350037,90.0,0.0,0.0); //object(wall102) (25)
	CreateDynamicObject(19462,640.5869141,-338.7207031,-94.0350037,90.0,0.0,0.0); //object(wall102) (26)
	CreateDynamicObject(19462,667.1552734,-349.2939453,-94.0350037,0.0,0.0,0.0); //object(wall102) (27)
	CreateDynamicObject(19462,659.6729736,-349.1849976,-90.6035004,0.0,0.0,0.0); //object(wall102) (28)
	CreateDynamicObject(19462,655.2990112,-349.1520081,-90.6035004,0.0,0.0,0.0); //object(wall102) (29)
	CreateDynamicObject(19462,647.7609863,-349.1409912,-90.6035004,0.0,0.0,0.0); //object(wall102) (32)
	CreateDynamicObject(19462,667.1552734,-349.2939453,-90.6035004,0.0,0.0,0.0); //object(wall102) (34)
	CreateDynamicObject(19462,659.6728516,-349.1845703,-94.0350037,0.0,0.0,0.0); //object(wall102) (35)
	CreateDynamicObject(19462,655.2988281,-349.1513672,-94.0350037,0.0,0.0,0.0); //object(wall102) (36)
	CreateDynamicObject(19462,647.7607422,-349.1406250,-94.0350037,0.0,0.0,0.0); //object(wall102) (37)
	CreateDynamicObject(19446,662.8057861,-353.4070129,-93.8050003,0.0,0.0,90.0); //object(wall086) (2)
	CreateDynamicObject(19446,652.0579834,-353.3900146,-93.8050003,0.0,0.0,90.0); //object(wall086) (3)
	CreateDynamicObject(19446,644.0579834,-353.3789978,-93.8050003,0.0,0.0,90.0); //object(wall086) (4)
	CreateDynamicObject(19462,657.4680176,-343.9783020,-94.0350037,90.0,0.0,90.0); //object(wall102) (39)
	CreateDynamicObject(19462,667.4539795,-349.2699890,-90.6035004,0.0,0.0,0.0); //object(wall102) (40)
	CreateDynamicObject(19462,667.4531250,-349.2695312,-94.0350037,0.0,0.0,0.0); //object(wall102) (41)
	CreateDynamicObject(19325,665.4658203,-343.9511719,-93.7220001,90.0,0.0,90.0); //object(lsmall_window01) (2)
	CreateDynamicObject(1523,661.9010010,-343.9930115,-95.7990036,0.0,0.0,0.0); //object(gen_doorext10) (1)
	CreateDynamicObject(19325,659.9039917,-343.9760132,-93.7220001,90.0,0.0,90.0); //object(lsmall_window01) (3)
	CreateDynamicObject(19462,662.4882812,-343.9794922,-91.5324631,0.0,0.0,90.0); //object(wall102) (42)
	CreateDynamicObject(19462,650.6488037,-343.9794922,-91.5324631,0.0,0.0,90.0); //object(wall102) (44)
	CreateDynamicObject(19462,641.0648193,-343.9794922,-91.5324631,0.0,0.0,90.0); //object(wall102) (45)
	CreateDynamicObject(19325,654.3740234,-343.9920044,-93.7220001,90.0,0.0,90.0); //object(lsmall_window01) (4)
	CreateDynamicObject(1523,652.3369751,-343.9710083,-95.7990036,0.0,0.0,180.0); //object(gen_doorext10) (2)
	CreateDynamicObject(19325,648.7640991,-343.9859924,-93.7220001,90.0,0.0,90.0); //object(lsmall_window01) (9)
	CreateDynamicObject(1523,646.7429810,-343.9809875,-95.7990036,0.0,0.0,179.9945068); //object(gen_doorext10) (6)
	CreateDynamicObject(19325,643.1669922,-343.9859924,-93.7220001,90.0,0.0,90.0); //object(lsmall_window01) (11)
	CreateDynamicObject(19325,639.0410156,-343.9853516,-93.7220001,90.0,0.0,90.0); //object(lsmall_window01) (13)
	CreateDynamicObject(19325,674.2034912,-335.1549988,-93.7220001,90.0,0.0,90.0); //object(lsmall_window01) (14)
	CreateDynamicObject(19325,665.4829712,-335.1619873,-93.7220001,90.0,0.0,90.0); //object(lsmall_window01) (15)
	CreateDynamicObject(19462,671.7730103,-335.1210022,-91.5319977,0.0,0.0,90.0); //object(wall102) (46)
	CreateDynamicObject(19462,662.5089722,-335.1400146,-91.5319977,0.0,0.0,90.0); //object(wall102) (47)
	CreateDynamicObject(19462,641.0099487,-335.1119995,-91.5319977,0.0,0.0,90.0); //object(wall102) (48)
	CreateDynamicObject(19462,650.6328125,-335.1113281,-91.5319977,0.0,0.0,90.0); //object(wall102) (50)
	CreateDynamicObject(3089,671.0908203,-335.1347656,-94.4560013,0.0,0.0,0.0); //object(ab_casdorlok) (1)
	CreateDynamicObject(19325,669.0341797,-335.1542969,-93.7220001,90.0,0.0,90.0); //object(lsmall_window01) (17)
	CreateDynamicObject(1523,663.4533081,-335.1189880,-95.7985001,0.0,0.0,180.0); //object(gen_doorext10) (8)
	CreateDynamicObject(19325,659.8734741,-335.1618042,-93.7220001,90.0,0.0,90.0); //object(lsmall_window01) (18)
	CreateDynamicObject(19325,649.5670166,-335.1409912,-93.7220001,90.0,0.0,90.0); //object(lsmall_window01) (20)
	CreateDynamicObject(1523,653.1323242,-335.0979919,-95.7990036,0.0,0.0,179.9945068); //object(gen_doorext10) (9)
	CreateDynamicObject(19325,655.1680298,-335.1119995,-93.7220001,90.0,0.0,90.0); //object(lsmall_window01) (22)
	CreateDynamicObject(19325,640.1307373,-335.1390076,-93.7220001,90.0,0.0,90.0); //object(lsmall_window01) (24)
	CreateDynamicObject(3089,642.1840210,-335.1099854,-94.4560013,0.0,0.0,0.0); //object(ab_casdorlok) (2)
	CreateDynamicObject(19325,645.7402344,-335.1386719,-93.7220001,90.0,0.0,90.0); //object(lsmall_window01) (26)
	CreateDynamicObject(2004,647.6370239,-331.0169983,-94.7259979,0.0,0.0,270.0); //object(cr_safe_door) (1)
	CreateDynamicObject(1569,674.3244019,-341.0880127,-95.7850037,0.0,0.0,90.0); //object(adam_v_door) (1)
	CreateDynamicObject(1569,674.3242188,-338.1010132,-95.7850037,0.0,0.0,270.0); //object(adam_v_door) (2)
	CreateDynamicObject(1569,676.7440186,-346.2040100,-95.5758972,0.0,0.0,0.0); //object(adam_v_door) (5)
	CreateDynamicObject(1569,676.7399902,-342.2464294,-95.5759964,0.0,0.0,0.0); //object(adam_v_door) (7)
	CreateDynamicObject(2146,668.3037109,-349.4775391,-95.3000031,0.0,0.0,0.0); //object(cj_trolly1) (1)
	CreateDynamicObject(1796,663.6884766,-333.1835938,-95.7850037,0.0,0.0,270.0); //object(low_bed_4) (1)
	CreateDynamicObject(2434,644.1997681,-341.6405945,-95.7850037,0.0,0.0,0.0); //object(cj_ff_conter_2b) (1)
	CreateDynamicObject(2435,644.3599854,-340.5119934,-95.7850037,0.0,0.0,90.0); //object(cj_ff_conter_2) (1)
	CreateDynamicObject(1997,667.7890625,-332.4755859,-95.7850037,0.0,0.0,0.0); //object(hos_trolley) (1)
	CreateDynamicObject(2021,665.7069702,-331.8580017,-95.7850037,0.0,0.0,270.0); //object(mrk_bdsdecab1) (1)
	CreateDynamicObject(1742,662.8870239,-325.8150024,-95.7869034,0.0,0.0,0.0); //object(med_bookshelf) (1)
	CreateDynamicObject(1744,665.0910034,-325.6481934,-94.3799973,0.0,0.0,0.0); //object(med_shelf) (1)
	CreateDynamicObject(1796,663.6884766,-330.2998352,-95.7850037,0.0,0.0,269.9945068); //object(low_bed_4) (2)
	CreateDynamicObject(2021,665.7069702,-328.9989929,-95.7850037,0.0,0.0,269.9890137); //object(mrk_bdsdecab1) (2)
	CreateDynamicObject(1796,663.6884766,-327.4299927,-95.7850037,0.0,0.0,269.9945068); //object(low_bed_4) (3)
	CreateDynamicObject(1796,663.0537109,-333.4003906,-95.7850037,0.0,0.0,90.0); //object(low_bed_4) (4)
	CreateDynamicObject(1796,663.0537109,-330.5400696,-95.7850037,0.0,0.0,90.0); //object(low_bed_4) (5)
	CreateDynamicObject(1796,663.0537109,-327.6400452,-95.7850037,0.0,0.0,90.0); //object(low_bed_4) (7)
	CreateDynamicObject(2021,661.0109863,-331.9079895,-95.7850037,0.0,0.0,90.0); //object(mrk_bdsdecab1) (3)
	CreateDynamicObject(2021,660.9990234,-328.9570007,-95.7850037,0.0,0.0,90.0); //object(mrk_bdsdecab1) (4)
	CreateDynamicObject(1796,651.4905396,-333.4003906,-95.7850037,0.0,0.0,90.0); //object(low_bed_4) (8)
	CreateDynamicObject(1796,651.5399780,-330.5379944,-95.7850037,0.0,0.0,90.0); //object(low_bed_4) (9)
	CreateDynamicObject(1796,651.6129761,-327.6430054,-95.7850037,0.0,0.0,90.0); //object(low_bed_4) (11)
	CreateDynamicObject(2021,649.4609985,-331.9249878,-95.7850037,0.0,0.0,89.50); //object(mrk_bdsdecab1) (6)
	CreateDynamicObject(2021,649.5540161,-328.9960022,-95.7850037,0.0,0.0,90.0); //object(mrk_bdsdecab1) (7)
	CreateDynamicObject(1796,651.8688354,-333.1835938,-95.7850037,0.0,0.0,270.0); //object(low_bed_4) (13)
	CreateDynamicObject(1796,651.8681641,-330.1835938,-95.7850037,0.0,0.0,269.9945068); //object(low_bed_4) (14)
	CreateDynamicObject(1796,651.8759766,-327.3919983,-95.7850037,0.0,0.0,269.9945068); //object(low_bed_4) (15)
	CreateDynamicObject(2021,653.8770142,-331.7760010,-95.7850037,0.0,0.0,269.9890137); //object(mrk_bdsdecab1) (9)
	CreateDynamicObject(2021,653.8900146,-328.9249878,-95.7850037,0.0,0.0,269.9890137); //object(mrk_bdsdecab1) (10)
	CreateDynamicObject(2025,651.2000122,-325.9729919,-95.7779999,0.0,0.0,0.0); //object(mrk_wrobe_tmp) (1)
	CreateDynamicObject(2202,641.1229858,-333.4679871,-95.7850037,0.0,0.0,90.0); //object(photocopier_2) (1)
	CreateDynamicObject(19173,659.5560303,-331.8590088,-93.7040024,0.0,0.0,270.0); //object(samppicture2) (1)
	CreateDynamicObject(19174,657.5109863,-335.2290039,-93.5279999,0.0,0.0,359.7500000); //object(samppicture3) (1)
	CreateDynamicObject(19172,657.5185547,-343.8916016,-93.5550003,0.0,0.0,179.9945068); //object(samppicture1) (1)
	CreateDynamicObject(630,673.8969727,-337.5450134,-94.7600021,0.0,0.0,336.00); //object(veg_palmkb8) (2)
	CreateDynamicObject(630,673.8029785,-341.6369934,-94.7600021,0.0,0.0,213.9948730); //object(veg_palmkb8) (3)
	CreateDynamicObject(2254,667.1439819,-329.5419922,-93.5390015,0.0,0.0,270.0); //object(frame_clip_1) (1)
	CreateDynamicObject(3396,673.7299805,-327.4370117,-95.7850037,0.0,0.0,0.0); //object(a51_sdsk_4_) (1)
	CreateDynamicObject(3394,673.7310181,-330.8009949,-95.7779999,0.0,0.0,0.0); //object(a51_sdsk_2_) (1)
	CreateDynamicObject(19339,673.5349731,-349.5660095,-94.4459991,0.0,0.0,90.0); //object(coffin01) (1)
	CreateDynamicObject(19175,655.3439941,-330.3970032,-93.1859970,0.0,0.0,270.2500000); //object(samppicture4) (1)
	CreateDynamicObject(11455,640.7119751,-339.6560059,-92.9879990,0.0,0.0,90.2500000); //object(des_medcensgn01) (1)
	CreateDynamicObject(2435,644.3619995,-338.6530151,-95.7850037,0.0,0.0,90.0); //object(cj_ff_conter_2) (1)
	CreateDynamicObject(2434,644.3629761,-337.7300110,-95.7850037,0.0,0.0,90.0); //object(cj_ff_conter_2b) (1)
	CreateDynamicObject(19462,640.9501953,-339.9804688,-98.6299973,90.0,0.0,0.0); //object(wall102) (25)
	CreateDynamicObject(19462,640.9501953,-339.2978516,-98.6299973,90.0,0.0,0.0); //object(wall102) (25)
	CreateDynamicObject(19462,639.2783203,-337.5371094,-91.6299973,90.0,0.0,90.0); //object(wall102) (25)
	CreateDynamicObject(19462,639.2783203,-341.7537231,-91.6299973,90.0,0.0,90.0); //object(wall102) (25)
	CreateDynamicObject(19462,636.1229858,-340.0320129,-93.8629990,0.0,90.0,90.0); //object(wall102) (25)
	CreateDynamicObject(19462,636.1300049,-339.2560120,-93.8563004,0.0,90.0,90.0); //object(wall102) (25)
	CreateDynamicObject(1600,619.2294922,-247.1005859,-114.0289993,0.0,0.0,0.0); //object(fish2single) (1)
	CreateDynamicObject(19325,640.9584961,-339.6340027,-93.7220001,90.0,0.0,0.0); //object(lsmall_window01) (26)
	CreateDynamicObject(19462,640.9323730,-339.9929810,-87.4600143,90.0,0.0,0.0); //object(wall102) (25)
	CreateDynamicObject(19462,636.2019043,-340.0202942,-92.2485580,0.0,90.0,90.0); //object(wall102) (25)
	CreateDynamicObject(19462,636.1989746,-339.2021484,-92.2485580,0.0,90.0,90.0); //object(wall102) (25)
	CreateDynamicObject(19462,640.9313354,-339.2978516,-87.4600143,90.0,0.0,0.0); //object(wall102) (25)
	CreateDynamicObject(2435,644.3662109,-339.5830078,-95.7850037,0.0,0.0,90.0); //object(cj_ff_conter_2) (1)
	CreateDynamicObject(2190,644.5670166,-338.6069946,-94.7289963,0.0,0.0,270.0); //object(pc_1) (1)
	CreateDynamicObject(2190,644.5709839,-340.3900146,-94.7289963,0.0,0.0,269.9945068); //object(pc_1) (2)
	CreateDynamicObject(630,641.1879883,-337.0910034,-94.7600021,0.0,0.0,1.9948730); //object(veg_palmkb8) (6)
	CreateDynamicObject(630,641.3029785,-342.2160034,-94.7600021,0.0,0.0,1.9940186); //object(veg_palmkb8) (7)
	CreateDynamicObject(1723,656.4732056,-335.7119141,-95.7850037,0.0,0.0,0.0); //object(mrk_seating1) (1)
	CreateDynamicObject(1723,658.4849854,-343.4147034,-95.7850037,0.0,0.0,180.0); //object(mrk_seating1) (2)
	CreateDynamicObject(1714,642.7310181,-340.2359924,-95.7850037,0.0,0.0,70.0); //object(kb_swivelchair1) (1)
	CreateDynamicObject(1714,642.6649780,-338.9590149,-95.7850037,0.0,0.0,96.7493896); //object(kb_swivelchair1) (2)
	CreateDynamicObject(1704,665.7739868,-335.7130127,-95.7850037,0.0,0.0,0.0); //object(kb_chair03) (1)
	CreateDynamicObject(1704,649.2899780,-335.6659851,-95.7850037,0.0,0.0,0.0); //object(kb_chair03) (2)
	CreateDynamicObject(1723,666.1589966,-343.4460144,-95.7850037,0.0,0.0,179.9945068); //object(mrk_seating1) (3)
	CreateDynamicObject(1704,649.2020264,-343.4760132,-95.7850037,0.0,0.0,180.0); //object(kb_chair03) (4)
	CreateDynamicObject(1796,663.5900269,-345.6849976,-95.7850037,0.0,0.0,270.0); //object(low_bed_4) (1)
	CreateDynamicObject(1796,663.5898438,-348.6845703,-95.7850037,0.0,0.0,270.0); //object(low_bed_4) (1)
	CreateDynamicObject(1796,663.5898438,-351.6845703,-95.7850037,0.0,0.0,270.0); //object(low_bed_4) (1)
	CreateDynamicObject(1796,651.7100220,-345.8099976,-95.7850037,0.0,0.0,270.0); //object(low_bed_4) (1)
	CreateDynamicObject(1796,651.7089844,-348.7850037,-95.7850037,0.0,0.0,270.0); //object(low_bed_4) (1)
	CreateDynamicObject(1796,651.7080078,-351.7600098,-95.7850037,0.0,0.0,270.0); //object(low_bed_4) (1)
	CreateDynamicObject(2021,653.7509766,-347.3720093,-95.7850037,0.0,0.0,269.9890137); //object(mrk_bdsdecab1) (9)
	CreateDynamicObject(2021,653.7579956,-350.3989868,-95.7850037,0.0,0.0,269.9890137); //object(mrk_bdsdecab1) (9)
	CreateDynamicObject(2021,665.6250000,-350.3229980,-95.7850037,0.0,0.0,269.9890137); //object(mrk_bdsdecab1) (9)
	CreateDynamicObject(2021,665.6129761,-347.3210144,-95.7850037,0.0,0.0,269.9890137); //object(mrk_bdsdecab1) (9)
	CreateDynamicObject(1796,663.2020264,-351.8919983,-95.7850037,0.0,0.0,90.0); //object(low_bed_4) (4)
	CreateDynamicObject(1796,663.2011719,-348.8916016,-95.7850037,0.0,0.0,90.0); //object(low_bed_4) (4)
	CreateDynamicObject(1796,663.2011719,-345.8916016,-95.7850037,0.0,0.0,90.0); //object(low_bed_4) (4)
	CreateDynamicObject(1796,651.2979736,-351.9140015,-95.7850037,0.0,0.0,90.0); //object(low_bed_4) (4)
	CreateDynamicObject(1796,651.2978516,-348.9130859,-95.7850037,0.0,0.0,90.0); //object(low_bed_4) (4)
	CreateDynamicObject(1796,651.2978516,-345.9130859,-95.7850037,0.0,0.0,90.0); //object(low_bed_4) (4)
	CreateDynamicObject(1796,644.1010132,-351.9049988,-95.7850037,0.0,0.0,90.0); //object(low_bed_4) (4)
	CreateDynamicObject(1796,644.1005859,-348.9042969,-95.7850037,0.0,0.0,90.0); //object(low_bed_4) (4)
	CreateDynamicObject(1796,644.1005859,-345.9042969,-95.7850037,0.0,0.0,90.0); //object(low_bed_4) (4)
	CreateDynamicObject(2021,661.1849976,-347.3080139,-95.7850037,0.0,0.0,90.0); //object(mrk_bdsdecab1) (9)
	CreateDynamicObject(2021,661.2150269,-350.3129883,-95.7850037,0.0,0.0,90.0); //object(mrk_bdsdecab1) (9)
	CreateDynamicObject(2021,649.3129883,-350.3179932,-95.7850037,0.0,0.0,90.0); //object(mrk_bdsdecab1) (9)
	CreateDynamicObject(2021,649.2800293,-347.3410034,-95.7850037,0.0,0.0,90.0); //object(mrk_bdsdecab1) (9)
	CreateDynamicObject(2021,642.0839844,-347.3359985,-95.7850037,0.0,0.0,90.0); //object(mrk_bdsdecab1) (9)
	CreateDynamicObject(2021,642.0980225,-350.3699951,-95.7850037,0.0,0.0,90.0); //object(mrk_bdsdecab1) (9)
	CreateDynamicObject(1796,644.2410278,-351.6380005,-95.7850037,0.0,0.0,270.0); //object(low_bed_4) (4)
	CreateDynamicObject(1796,644.2402344,-348.6376953,-95.7850037,0.0,0.0,269.9945068); //object(low_bed_4) (4)
	CreateDynamicObject(2021,646.2449951,-350.2940063,-95.7850037,0.0,0.0,269.9890137); //object(mrk_bdsdecab1) (9)
	CreateDynamicObject(2021,646.2319946,-347.3139954,-95.7850037,0.0,0.0,269.9890137); //object(mrk_bdsdecab1) (9)
	CreateDynamicObject(14532,647.1530151,-345.8519897,-94.8020020,0.0,0.0,130.0); //object(tv_stand_driv) (1)
	CreateDynamicObject(2855,647.4089966,-350.3120117,-94.8850021,0.0,0.0,0.0); //object(gb_bedmags05) (1)
	CreateDynamicObject(2828,640.9749756,-347.2999878,-94.9488525,0.0,0.0,264.00); //object(gb_ornament02) (1)
	CreateDynamicObject(1808,647.7059937,-335.4309998,-95.7850037,0.0,0.0,0.0); //object(cj_watercooler2) (1)
	CreateDynamicObject(3383,668.1170044,-328.7300110,-95.8789978,0.0,0.0,270.0); //object(a51_labtable1_) (1)
	CreateDynamicObject(3387,671.2969971,-325.8540039,-95.7850037,0.0,0.0,90.0); //object(a51_srack3_) (1)
	CreateDynamicObject(3387,670.2919922,-325.8479919,-95.7850037,0.0,0.0,90.0); //object(a51_srack3_) (2)
	CreateDynamicObject(1997,668.6610107,-334.3099976,-95.7850037,0.0,0.0,90.0); //object(hos_trolley) (1)
	CreateDynamicObject(1997,673.5599976,-333.8229980,-95.7850037,0.0,0.0,180.0); //object(hos_trolley) (1)
	CreateDynamicObject(2690,667.1890259,-343.8377075,-94.6279984,0.0,0.0,180.0); //object(cj_fire_ext) (1)
	CreateDynamicObject(2256,648.0759888,-331.7040100,-93.3059998,0.0,0.0,88.00); //object(frame_clip_3) (1)
	CreateDynamicObject(2257,648.1290283,-328.7319946,-93.2779999,0.0,0.0,88.2500000); //object(frame_clip_4) (1)
	CreateDynamicObject(2259,666.5859985,-348.7780151,-93.7379990,0.0,0.0,270.0); //object(frame_clip_6) (1)
	CreateDynamicObject(2261,666.5549927,-345.8519897,-94.0329971,0.0,0.0,270.0); //object(frame_slim_2) (1)
	CreateDynamicObject(2264,666.5720215,-347.3810120,-93.6370010,0.0,0.0,269.50); //object(frame_slim_5) (1)
	CreateDynamicObject(2267,659.8090210,-348.7650146,-93.5770035,0.0,0.0,90.0); //object(frame_wood_3) (1)
	CreateDynamicObject(2256,667.0479736,-351.0260010,-93.6320038,0.0,0.0,270.0); //object(frame_clip_3) (3)
	CreateDynamicObject(2259,666.7020264,-331.2470093,-94.0329971,0.0,0.0,270.0); //object(frame_clip_6) (3)
	CreateDynamicObject(2266,654.6929932,-346.7640076,-93.9860001,0.0,0.0,269.7500000); //object(frame_wood_5) (1)
	CreateDynamicObject(2268,654.7050171,-348.6870117,-93.9400024,0.0,0.0,270.0); //object(frame_wood_2) (1)
	CreateDynamicObject(2270,654.7230225,-347.8699951,-93.7639999,0.0,0.0,270.0); //object(frame_wood_6) (1)
	CreateDynamicObject(2269,654.7269897,-350.5090027,-93.8519974,0.0,0.0,270.7500000); //object(frame_wood_4) (1)
	CreateDynamicObject(2263,654.6859741,-351.7600098,-93.8199997,0.0,0.0,269.7500000); //object(frame_slim_4) (1)
	CreateDynamicObject(2267,655.1439819,-349.4570007,-92.4150009,0.0,0.0,270.0); //object(frame_wood_3) (4)
	CreateDynamicObject(2264,654.7189941,-346.9830017,-92.8669968,0.0,0.0,270.0); //object(frame_slim_5) (3)
	CreateDynamicObject(2260,641.1840210,-348.8049927,-93.7679977,0.0,0.0,90.0); //object(frame_slim_1) (1)
	CreateDynamicObject(2261,641.1459961,-347.5570068,-93.3389969,0.0,0.0,89.7500000); //object(frame_slim_2) (3)
	CreateDynamicObject(2263,641.1599731,-346.5320129,-94.0080032,0.0,0.0,92.00); //object(frame_slim_4) (4)
	CreateDynamicObject(2265,641.1710205,-349.9840088,-93.4919968,0.0,0.0,90.0); //object(frame_slim_6) (1)
	CreateDynamicObject(2255,647.1849976,-348.1239929,-93.6460037,0.0,0.0,270.0); //object(frame_clip_2) (1)
	CreateDynamicObject(2256,647.6250000,-349.8550110,-92.7839966,0.0,0.0,270.0); //object(frame_clip_3) (6)
	CreateDynamicObject(2259,647.1840210,-351.8269958,-93.8420029,0.0,0.0,270.0); //object(frame_clip_6) (5)
	CreateDynamicObject(19462,674.5360107,-346.2409973,-94.0350037,90.0,0.0,90.0); //object(wall102) (1)
	CreateDynamicObject(19462,674.2535400,-346.2402344,-94.0350037,90.0,0.0,90.0); //object(wall102) (1)
	CreateDynamicObject(19443,671.2839966,-346.2417297,-94.1035004,0.0,0.0,90.0); //object(wall083) (1)
	CreateDynamicObject(19443,668.2399292,-346.2412109,-94.1035004,0.0,0.0,90.0); //object(wall083) (2)
	CreateDynamicObject(3089,669.0230103,-346.2019958,-94.4560013,0.0,0.0,0.0); //object(ab_casdorlok) (1)
	CreateDynamicObject(19325,673.0200195,-346.2330017,-93.7220001,90.0,0.0,90.0); //object(lsmall_window01) (2)
	CreateDynamicObject(19462,672.2930298,-346.2459106,-91.5319977,0.0,0.0,90.0); //object(wall102) (42)
	CreateDynamicObject(19443,672.2832031,-346.2541199,-96.5103531,0.0,0.0,90.0); //object(wall083) (4)
	CreateDynamicObject(19462,671.9959717,-351.1149902,-94.0350037,0.0,0.0,90.0); //object(wall102) (11)
	CreateDynamicObject(19462,674.3950195,-351.0499878,-94.0350037,0.0,0.0,180.0); //object(wall102) (11)
	CreateDynamicObject(2004,670.2579956,-351.0289917,-94.6969986,0.0,0.0,180.0); //object(cr_safe_door) (1)
	CreateDynamicObject(2004,670.2550049,-351.0289917,-93.8610001,0.0,0.0,179.9945068); //object(cr_safe_door) (1)
	CreateDynamicObject(2004,671.0720215,-351.0289917,-93.8610001,0.0,0.0,179.9945068); //object(cr_safe_door) (1)
	CreateDynamicObject(2004,671.0739746,-351.0289917,-94.6949997,0.0,0.0,179.9945068); //object(cr_safe_door) (1)
	CreateDynamicObject(2004,671.8850098,-351.0289917,-94.6959991,0.0,0.0,179.9945068); //object(cr_safe_door) (1)
	CreateDynamicObject(2004,671.8889771,-351.0289917,-93.8619995,0.0,0.0,179.9945068); //object(cr_safe_door) (1)
	CreateDynamicObject(2004,672.6989746,-351.0289917,-94.6969986,0.0,0.0,179.9945068); //object(cr_safe_door) (1)
	CreateDynamicObject(2004,672.6989746,-351.0289917,-93.8610001,0.0,0.0,179.9945068); //object(cr_safe_door) (1)
	CreateDynamicObject(2146,673.5029907,-349.5459900,-95.3000031,0.0,0.0,0.0); //object(cj_trolly1) (1)
	CreateDynamicObject(19339,668.2832031,-349.4541016,-94.4459991,0.0,0.0,90.0); //object(coffin01) (2)
	CreateDynamicObject(630,667.9119873,-345.6789856,-94.7600021,0.0,0.0,213.9916992); //object(veg_palmkb8) (9)
	CreateDynamicObject(630,659.5650024,-343.4219971,-94.7600021,0.0,0.0,43.9916992); //object(veg_palmkb8) (10)
	CreateDynamicObject(630,655.5720215,-343.3909912,-94.7600021,0.0,0.0,43.9892578); //object(veg_palmkb8) (11)
	CreateDynamicObject(630,647.8460083,-343.3869934,-94.7600021,0.0,0.0,43.9892578); //object(veg_palmkb8) (12)
	CreateDynamicObject(630,655.5629883,-335.7449951,-94.7600021,0.0,0.0,333.9892578); //object(veg_palmkb8) (13)
	CreateDynamicObject(630,659.5200195,-335.6990051,-94.7600021,0.0,0.0,333.9843750); //object(veg_palmkb8) (14)
	CreateDynamicObject(1723,673.4060059,-345.6820068,-95.7850037,0.0,0.0,179.9945068); //object(mrk_seating1) (4)
	CreateDynamicObject(19462,678.9091187,-342.8770142,-94.0350037,90.0,0.0,0.0); //object(wall102) (23)
	CreateDynamicObject(19462,678.9090576,-346.3187561,-94.0350037,90.0,0.0,0.0); //object(wall102) (23)
	CreateDynamicObject(19172,678.7930298,-344.2470093,-93.7180023,0.0,0.0,270.0); //object(samppicture1) (4)
	CreateDynamicObject(630,678.3569946,-342.8280029,-94.5410004,0.0,0.0,211.9916992); //object(veg_palmkb8) (16)
	CreateDynamicObject(630,678.3439941,-345.6380005,-94.5410004,0.0,0.0,155.9866943); //object(veg_palmkb8) (17)
	CreateDynamicObject(2828,655.1110229,-328.9179993,-94.9489975,0.0,0.0,43.9959717); //object(gb_ornament02) (3)
	CreateDynamicObject(2164,645.4609985,-325.8420105,-95.7850037,0.0,0.0,0.0); //object(med_office_unit_5) (1)
	CreateDynamicObject(2165,645.2940063,-333.7699890,-95.7850037,0.0,0.0,90.0); //object(med_office_desk_1) (1)
	CreateDynamicObject(2162,647.5859985,-332.8429871,-94.2750015,0.0,0.0,270.0); //object(med_office_unit_1) (1)
	CreateDynamicObject(1714,646.3289795,-333.6919861,-95.7850037,0.0,0.0,228.7456055); //object(kb_swivelchair1) (4)
	CreateDynamicObject(2162,647.5859375,-329.2842712,-94.2750015,0.0,0.0,269.9945068); //object(med_office_unit_1) (5)
	CreateDynamicObject(2165,645.2939453,-330.1976929,-95.7850037,0.0,0.0,90.0); //object(med_office_desk_1) (3)
	CreateDynamicObject(1714,646.5189819,-329.2579956,-95.7850037,0.0,0.0,282.7408447); //object(kb_swivelchair1) (6)
	CreateDynamicObject(2164,643.7100220,-325.8280029,-95.7850037,0.0,0.0,0.0); //object(med_office_unit_5) (3)
	CreateDynamicObject(2164,641.9589844,-325.8389893,-95.7850037,0.0,0.0,0.0); //object(med_office_unit_5) (4)
	CreateDynamicObject(1723,641.1450195,-330.1359863,-95.7779999,0.0,0.0,90.0); //object(mrk_seating1) (8)
	CreateDynamicObject(2265,641.1339722,-328.2120056,-93.8320007,0.0,0.0,90.2500000); //object(frame_slim_6) (3)
	CreateDynamicObject(2264,641.1530151,-329.2839966,-93.4749985,0.0,0.0,90.0); //object(frame_slim_5) (5)
	CreateDynamicObject(2263,641.1699829,-330.1849976,-93.8870010,0.0,0.0,90.0); //object(frame_slim_4) (7)
	CreateDynamicObject(2262,641.1550293,-331.2569885,-93.6470032,0.0,0.0,90.0); //object(frame_slim_3) (1)
	CreateDynamicObject(2261,641.1389771,-332.3479919,-93.4160004,0.0,0.0,90.0); //object(frame_slim_2) (5)
	CreateDynamicObject(2260,641.1489868,-333.5199890,-93.9929962,0.0,0.0,90.0); //object(frame_slim_1) (3)
	CreateDynamicObject(630,641.0780029,-326.2510071,-94.7600021,0.0,0.0,305.9843750); //object(veg_palmkb8) (19)
	obj = CreateDynamicObject(630,646.9730225,-326.5079956,-94.7600021,0.0,0.0,235.9802246); //object(veg_palmkb8) (20)
	return obj;
}

//	Магазин одежды в ФК (interior)
FCClothes_Int_CreateObjects()
{
	new tmpobjid;
	tmpobjid = CreateDynamicObject(19375, -128.803, 1189.816, 1000.000, 0.000, 90.000, 0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2755, "ab_dojowall", "mp_apt1_roomfloor", 0);
	tmpobjid = CreateDynamicObject(19375,-128.803,1180.183,1000.000,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2755, "ab_dojowall", "mp_apt1_roomfloor", 0);
	tmpobjid = CreateDynamicObject(19368,-123.643,1180.184,1001.835,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19368,-123.643,1176.973,1001.835,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19368,-123.643,1183.396,1001.835,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19368,-123.643,1186.606,1001.835,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19368,-123.643,1189.817,1001.835,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19368,-123.643,1193.028,1001.835,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19368,-128.371,1194.546,1001.835,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19368,-131.582,1194.546,1001.835,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19368,-134.794,1194.546,1001.835,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19368,-133.966,1193.031,1001.835,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19368,-133.966,1189.822,1001.835,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19368,-133.966,1186.611,1001.835,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19368,-133.966,1183.402,1001.835,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19368,-133.968,1180.193,1001.835,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19368,-133.968,1176.984,1001.835,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19368,-132.451,1175.469,1001.835,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19368,-126.030,1175.469,1001.835,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19368,-122.819,1175.469,1001.835,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19396,-125.160,1194.546,1001.835,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(19380,-128.804,1180.195,1003.674,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	tmpobjid = CreateDynamicObject(19380,-128.804,1189.828,1003.674,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	tmpobjid = CreateDynamicObject(2624,-125.551,1177.883,1001.760,0.000,0.000,270.000);
	SetDynamicObjectMaterial(tmpobjid, 4, 2755, "ab_dojowall", "mp_apt1_roomfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 5, 2755, "ab_dojowall", "mp_apt1_roomfloor", 0);
	tmpobjid = CreateDynamicObject(2187,-133.394,1176.038,1000.088,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	tmpobjid = CreateDynamicObject(2187,-133.395,1176.037,1001.085,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	tmpobjid = CreateDynamicObject(2187,-131.869,1176.038,1000.088,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	tmpobjid = CreateDynamicObject(2187,-131.868,1176.038,1001.085,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	tmpobjid = CreateDynamicObject(2187,-130.342,1176.038,1000.088,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	tmpobjid = CreateDynamicObject(2187,-130.342,1176.038,1001.085,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	tmpobjid = CreateDynamicObject(2187,-130.342,1176.037,1001.138,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	tmpobjid = CreateDynamicObject(2187,-131.868,1176.038,1001.138,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	tmpobjid = CreateDynamicObject(2187,-133.395,1176.037,1001.138,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	tmpobjid = CreateDynamicObject(19368,-129.240,1175.469,1001.835,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14709, "lamidint2", "mp_apt1_floor", 0);
	tmpobjid = CreateDynamicObject(2187,-128.817,1176.038,1000.088,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	tmpobjid = CreateDynamicObject(2187,-128.817,1176.037,1001.077,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	tmpobjid = CreateDynamicObject(2187,-128.817,1176.036,1001.135,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	//
	CreateDynamicObject(1532,-124.419,1194.584,1000.083,0.000,0.000,179.994);
	CreateDynamicObject(1532,-126.210,1188.052,18.732,0.000,0.000,180.000);
	CreateDynamicObject(1532,-128.940,1178.199,18.732,0.000,0.000,0.000);
	CreateDynamicObject(18608,-128.929,1184.726,1004.752,0.000,0.000,0.000);
	CreateDynamicObject(2624,-131.678,1191.753,1001.760,0.000,0.000,90.000);
	CreateDynamicObject(2626,-125.754,1177.642,1000.736,0.000,0.000,223.846);
	CreateDynamicObject(2372,-128.337,1181.663,1000.091,0.000,0.000,90.000);
	CreateDynamicObject(2372,-128.337,1183.239,1000.091,0.000,0.000,90.000);
	CreateDynamicObject(2372,-128.337,1186.454,1000.091,0.000,0.000,90.000);
	CreateDynamicObject(2392,-129.404,1181.442,1000.799,0.000,0.000,90.000);
	CreateDynamicObject(2392,-128.485,1181.438,1000.799,0.000,0.000,90.000);
	CreateDynamicObject(2372,-128.337,1184.786,1000.091,0.000,0.000,90.000);
	CreateDynamicObject(2381,-128.968,1183.030,1000.799,0.000,0.000,0.000);
	CreateDynamicObject(2382,-128.343,1184.576,1000.768,0.000,0.000,90.000);
	CreateDynamicObject(2373,-134.313,1186.637,1000.083,0.000,0.000,90.000);
	CreateDynamicObject(2373,-134.318,1183.943,1000.083,0.000,0.000,90.000);
	CreateDynamicObject(2373,-134.322,1181.250,1000.083,0.000,0.000,90.000);
	CreateDynamicObject(2373,-134.326,1178.556,1000.083,0.000,0.000,90.000);
	CreateDynamicObject(2374,-133.611,1188.687,1000.578,0.000,0.000,90.000);
	CreateDynamicObject(2374,-133.611,1188.031,1000.578,0.000,0.000,90.000);
	CreateDynamicObject(2377,-133.597,1187.305,1000.544,0.000,0.000,90.000);
	CreateDynamicObject(2378,-133.608,1183.177,1000.549,0.000,0.000,90.000);
	CreateDynamicObject(2390,-133.607,1181.884,1000.552,0.000,0.000,90.000);
	CreateDynamicObject(2391,-133.608,1185.857,1000.552,0.000,0.000,90.000);
	CreateDynamicObject(2397,-133.615,1184.558,1000.556,0.000,0.000,90.000);
	CreateDynamicObject(2401,-133.608,1179.232,1000.554,0.000,0.000,90.000);
	CreateDynamicObject(2394,-128.878,1186.243,1000.804,0.247,0.499,359.296);
	CreateDynamicObject(2377,-133.597,1186.562,1000.544,0.000,0.000,90.000);
	CreateDynamicObject(2391,-133.608,1185.232,1000.552,0.000,0.000,90.000);
	CreateDynamicObject(2397,-133.615,1183.917,1000.556,0.000,0.000,90.000);
	CreateDynamicObject(2378,-133.608,1182.552,1000.551,0.000,0.000,90.000);
	CreateDynamicObject(2390,-133.608,1181.223,1000.552,0.000,0.000,90.000);
	CreateDynamicObject(2398,-133.608,1180.489,1000.554,0.000,0.000,90.000);
	CreateDynamicObject(2398,-133.608,1179.874,1000.554,0.000,0.000,90.000);
	CreateDynamicObject(2401,-133.608,1178.500,1000.554,0.000,0.000,90.000);
	CreateDynamicObject(2399,-133.645,1178.496,1001.461,0.000,0.000,90.000);
	CreateDynamicObject(2399,-133.645,1179.227,1001.461,0.000,0.000,90.000);
	CreateDynamicObject(2396,-133.630,1181.222,1001.463,0.000,0.000,90.000);
	CreateDynamicObject(2396,-133.630,1181.880,1001.463,0.000,0.000,90.000);
	CreateDynamicObject(2389,-133.606,1183.911,1001.466,0.000,0.000,90.000);
	CreateDynamicObject(2389,-133.606,1184.542,1001.466,0.000,0.000,90.000);
	CreateDynamicObject(2383,-133.598,1187.290,1001.450,0.000,0.000,0.000);
	CreateDynamicObject(2383,-133.598,1186.598,1001.450,0.000,0.000,0.000);
	CreateDynamicObject(2689,-129.005,1184.576,1000.802,0.000,0.000,90.000);
	CreateDynamicObject(2689,-129.119,1184.576,1000.802,0.000,0.000,90.000);
	CreateDynamicObject(2689,-129.246,1184.576,1000.801,0.000,0.000,90.000);
	CreateDynamicObject(2704,-129.524,1184.576,1000.804,0.000,0.000,90.000);
	CreateDynamicObject(2704,-129.658,1184.576,1000.804,0.000,0.000,90.000);
	CreateDynamicObject(2705,-129.387,1184.576,1000.804,0.000,0.000,90.000);
	CreateDynamicObject(2706,-129.795,1184.576,1000.804,0.000,0.000,90.000);
	CreateDynamicObject(2654,-133.521,1193.614,1001.080,0.000,0.000,0.000);
	CreateDynamicObject(2387,-124.237,1186.031,1000.085,0.000,0.000,90.428);
	CreateDynamicObject(2412,-125.751,1194.297,1000.085,0.000,0.000,0.000);
	CreateDynamicObject(2412,-123.891,1194.297,1000.085,0.000,0.000,0.000);
	CreateDynamicObject(2652,-124.368,1179.702,1000.711,0.000,0.000,327.326);
	CreateDynamicObject(14483,-131.613,1176.016,999.729,0.000,0.000,90.000);
	CreateDynamicObject(14483,-133.136,1176.017,999.729,0.000,0.000,90.000);
	CreateDynamicObject(2664,-132.340,1176.700,1001.260,0.000,0.000,179.994);
	CreateDynamicObject(2664,-130.814,1176.700,1001.260,0.000,0.000,179.994);
	CreateDynamicObject(1886,-124.032,1176.051,1003.684,15.108,0.000,209.148);
	CreateDynamicObject(2654,-131.927,1194.098,1001.080,0.000,0.000,270.159);
	CreateDynamicObject(2620,-130.052,1193.901,1000.997,0.000,0.000,0.000);
	CreateDynamicObject(2593,-123.775,1181.995,1000.937,0.000,0.000,311.667);
	CreateDynamicObject(2593,-123.774,1181.119,1000.937,0.000,0.000,311.747);
	CreateDynamicObject(19095,-123.930,1184.781,1000.533,270.000,270.000,43.302);
	CreateDynamicObject(19097,-123.957,1184.364,1000.533,270.000,270.000,124.891);
	CreateDynamicObject(19115,-124.000,1183.130,1000.518,270.000,270.000,48.920);
	CreateDynamicObject(19160,-123.921,1181.805,1000.536,270.000,270.000,123.434);
	CreateDynamicObject(18636,-123.983,1180.911,1000.489,0.000,80.000,212.669);
	CreateDynamicObject(19421,-124.207,1189.058,1000.966,0.000,0.000,73.506);
	CreateDynamicObject(19422,-124.291,1189.350,1000.783,0.000,0.000,65.338);
	CreateDynamicObject(19423,-124.301,1187.657,1000.781,0.000,0.000,73.506);
	CreateDynamicObject(19424,-124.199,1187.642,1000.966,0.000,0.000,73.506);
	CreateDynamicObject(18895,-123.935,1183.531,1000.523,180.000,0.000,311.331);
	CreateDynamicObject(18922,-123.943,1182.260,1000.517,280.000,270.000,32.837);
	CreateDynamicObject(18954,-123.900,1183.892,1000.539,90.000,0.000,135.569);
	CreateDynamicObject(18961,-123.948,1181.353,1000.494,0.000,79.996,138.164);
	CreateDynamicObject(18968,-123.956,1182.668,1000.505,0.000,90.000,229.322);
	CreateDynamicObject(2593,-123.774,1182.849,1000.937,0.000,0.000,311.665);
	CreateDynamicObject(2593,-123.773,1183.696,1000.937,0.000,0.000,311.667);
	CreateDynamicObject(2593,-123.775,1184.551,1000.937,0.000,0.000,311.665);
	CreateDynamicObject(18636,-123.984,1180.913,1000.867,0.000,79.996,212.667);
	CreateDynamicObject(18636,-123.983,1180.912,1001.234,0.000,79.996,212.667);
	CreateDynamicObject(18636,-123.982,1180.911,1001.590,0.000,79.996,212.667);
	CreateDynamicObject(18961,-123.948,1181.348,1000.877,0.000,79.991,138.164);
	CreateDynamicObject(18961,-123.947,1181.348,1001.241,0.000,79.991,138.164);
	CreateDynamicObject(18961,-123.946,1181.348,1001.601,0.000,79.991,138.164);
	CreateDynamicObject(18922,-123.942,1182.260,1000.895,279.997,270.000,32.832);
	CreateDynamicObject(18922,-123.941,1182.260,1001.262,279.997,270.000,32.832);
	CreateDynamicObject(18922,-123.940,1182.260,1001.619,279.997,270.000,32.832);
	CreateDynamicObject(19160,-123.921,1181.805,1000.921,270.000,270.000,123.431);
	CreateDynamicObject(19160,-123.921,1181.805,1001.288,270.000,270.000,123.431);
	CreateDynamicObject(19160,-123.921,1181.805,1001.643,270.000,270.000,123.431);
	CreateDynamicObject(19115,-124.000,1183.130,1000.898,270.000,270.000,48.916);
	CreateDynamicObject(19115,-124.000,1183.130,1001.262,270.000,270.000,48.916);
	CreateDynamicObject(19115,-124.000,1183.130,1001.624,270.000,270.000,48.916);
	CreateDynamicObject(18968,-123.955,1182.668,1000.888,0.000,90.000,229.317);
	CreateDynamicObject(18968,-123.954,1182.668,1001.252,0.000,90.000,229.317);
	CreateDynamicObject(18968,-123.953,1182.668,1001.607,0.000,90.000,229.317);
	CreateDynamicObject(18954,-123.899,1183.892,1000.924,90.000,0.000,135.565);
	CreateDynamicObject(18954,-123.898,1183.892,1001.286,90.000,0.000,135.565);
	CreateDynamicObject(18954,-123.897,1183.892,1001.643,90.000,0.000,135.565);
	CreateDynamicObject(18895,-123.935,1183.530,1000.898,179.994,0.000,311.330);
	CreateDynamicObject(18895,-123.935,1183.529,1001.265,179.994,0.000,311.330);
	CreateDynamicObject(18895,-123.935,1183.527,1001.640,179.994,0.000,311.330);
	CreateDynamicObject(19095,-123.930,1184.780,1000.914,270.000,270.000,43.297);
	CreateDynamicObject(19095,-123.930,1184.779,1001.280,270.000,270.000,43.297);
	CreateDynamicObject(19095,-123.930,1184.777,1001.633,270.000,270.000,43.297);
	CreateDynamicObject(19097,-123.956,1184.364,1000.916,270.000,270.000,124.887);
	CreateDynamicObject(19097,-123.955,1184.363,1001.278,270.000,270.000,124.887);
	CreateDynamicObject(19097,-123.954,1184.362,1001.632,270.000,270.000,124.887);
	CreateDynamicObject(2368,-124.060,1189.874,1000.085,0.000,0.000,270.000);
	CreateDynamicObject(2368,-124.060,1192.782,1000.085,0.000,0.000,270.000);
	CreateDynamicObject(2375,-128.988,1194.411,1000.085,0.000,0.000,0.000);
	CreateDynamicObject(19424,-124.214,1187.979,1000.966,0.000,0.000,73.504);
	CreateDynamicObject(19424,-124.208,1188.296,1000.966,0.000,0.000,73.504);
	CreateDynamicObject(19423,-124.289,1187.964,1000.781,0.000,0.000,73.504);
	CreateDynamicObject(19423,-124.300,1188.303,1000.781,0.000,0.000,73.504);
	CreateDynamicObject(19421,-124.212,1188.753,1000.966,0.000,0.000,73.504);
	CreateDynamicObject(19421,-124.209,1189.342,1000.966,0.000,0.000,73.504);
	CreateDynamicObject(19422,-124.306,1189.089,1000.783,0.000,0.000,65.335);
	CreateDynamicObject(19422,-124.314,1188.784,1000.783,0.000,0.000,65.335);
	CreateDynamicObject(19006,-124.353,1191.681,1000.809,0.000,0.000,172.150);
	CreateDynamicObject(19012,-124.307,1191.973,1000.809,0.000,0.000,172.150);
	CreateDynamicObject(19008,-124.323,1192.239,1000.809,0.000,0.000,172.150);
	CreateDynamicObject(19015,-124.232,1191.967,1001.007,0.000,0.000,172.150);
	CreateDynamicObject(19016,-124.244,1191.663,1001.007,0.000,0.000,172.150);
	CreateDynamicObject(19012,-124.250,1192.307,1001.007,0.000,0.000,172.150);
	CreateDynamicObject(19028,-124.212,1191.213,1000.989,0.000,0.000,188.485);
	CreateDynamicObject(19033,-124.214,1190.921,1000.989,0.000,0.000,188.481);
	CreateDynamicObject(19035,-124.220,1190.619,1000.989,0.000,0.000,188.481);
	CreateDynamicObject(19018,-124.347,1190.607,1000.815,0.000,0.000,196.652);
	CreateDynamicObject(19021,-124.327,1190.913,1000.802,0.000,0.000,196.652);
	CreateDynamicObject(19020,-124.355,1191.232,1000.802,0.000,0.000,193.902);
	CreateDynamicObject(2671,-131.613,1192.336,1000.221,0.000,0.000,155.816);
	CreateDynamicObject(2894,-125.985,1177.411,1001.275,0.000,0.000,65.338);
	CreateDynamicObject(2196,-126.120,1177.682,1001.275,0.000,0.000,0.000);
	CreateDynamicObject(2596,-125.978,1175.865,1002.791,0.000,0.000,179.994);
	CreateDynamicObject(2697,-133.863,1188.212,1002.289,0.000,0.000,90.000);
	CreateDynamicObject(2658,-133.854,1177.378,1002.289,0.000,0.000,90.000);
	CreateDynamicObject(2657,-133.856,1185.583,1002.289,0.000,0.000,90.000);
	CreateDynamicObject(2655,-133.856,1182.840,1002.289,0.000,0.000,90.000);
	CreateDynamicObject(2656,-133.854,1180.176,1002.289,0.000,0.000,90.000);
	CreateDynamicObject(14762,-123.749,1172.720,1002.031,0.000,0.000,179.994);
	CreateDynamicObject(1810,-125.079,1176.511,1000.221,0.000,0.000,229.322);
	CreateDynamicObject(14762,-123.748,1174.290,1002.031,0.000,0.000,179.994);
	CreateDynamicObject(2664,-129.287,1176.699,1001.260,0.000,0.000,179.994);
	CreateDynamicObject(14483,-130.087,1176.015,999.729,0.000,0.000,90.000);
	CreateDynamicObject(2404,-128.912,1175.598,1001.335,0.000,0.000,180.000);
	obj = CreateDynamicObject(2698,-128.091,1176.394,1001.031,0.000,0.000,0.000);
	return obj;
}

//	База ФБР
FBI_CreateObjects()
{
	CreateDynamicObject(10829,1783.500,-1144.500,22.800,0.000,0.000,0.000);
	CreateDynamicObject(5726,1818.900,-1103.300,26.900,0.000,0.000,181.500);
	CreateDynamicObject(987,1779.400,-1128.700,23.100,0.000,0.000,0.000);
	CreateDynamicObject(987,1767.400,-1128.700,23.100,0.000,0.000,0.000);
	CreateDynamicObject(987,1790.900,-1108.600,23.100,0.000,0.000,180.000);
	CreateDynamicObject(987,1779.000,-1108.600,23.100,0.000,0.000,179.9950000);
	CreateDynamicObject(984,1764.900,-1142.500,23.700,0.000,0.000,270.000);
	CreateDynamicObject(984,1761.700,-1142.500,23.700,0.000,0.000,270.000);
	CreateDynamicObject(984,1737.200,-1135.500,23.700,0.000,0.000,0.000);
	CreateDynamicObject(997,1773.500,-1142.400,23.100,0.000,0.000,0.000);
	CreateDynamicObject(997,1777.900,-1142.400,23.100,0.000,0.000,0.000);
	CreateDynamicObject(971,1790.700,-1136.000,26.500,0.000,0.000,270.000);
	CreateDynamicObject(971,1790.700,-1127.200,26.500,0.000,0.000,270.000);
	CreateDynamicObject(971,1788.600,-1144.800,26.200,0.000,0.000,270.000);
	CreateDynamicObject(987,1781.100,-1149.800,26.600,0.000,0.000,0.000);
	obj = CreateDynamicObject(987, 1792.9, -1149.9, 26.6, 0.0, 0.0, 351.25);
	return obj;
}

//  ЛСПД
LSPD_CreateObjects()
{
	CreateDynamicObject(4199, 1602.04, -1618.42, 14.46, 0.00, 0.00, 180.00);// Гаражи перед подвалом
	CreateDynamicObject(8407, 1573.07, -1603.94, 13.70, 0.00, 0.00, 270.00);// Будка штраф-стоянки
	CreateDynamicObject(19452, 1576.93, -1608.27, 12.40, 0.00, 90.00, 0.00);// Подиум штраф-стоянки

    /*new lspdobject = CreateDynamicObject(3976, 1571.64661, -1675.73230, 35.56850, 0.0, 0.0, 0.0, -1, -1, -1, 500.0, 500.0);
    SetDynamicObjectMaterial(lspdobject, 1, 5708, "hospital_lawn","hosp03b_law", 0);
	SetDynamicObjectMaterial(lspdobject, 3, 5708, "hospital_lawn","hosp03b_law", 0);
   	SetDynamicObjectMaterial(lspdobject, 2, 5708, "hospital_lawn","hosp01_law", 0);
 	SetDynamicObjectMaterial(lspdobject, 12, 5708, "hospital_lawn","hosp01_law", 0);
    SetDynamicObjectMaterial(lspdobject, 8, 5708, "hospital_lawn","hhosp03b_law", 0);
	SetDynamicObjectMaterial(lspdobject, 7, 5708, "hospital_lawn","hosp03b_law", 0);
	SetDynamicObjectMaterial(lspdobject, 6, 5708, "hospital_lawn","hosp03b_law", 0);
	SetDynamicObjectMaterial(lspdobject, 5, 5708, "hospital_lawn","hosp03b_law", 0);
    SetDynamicObjectMaterial(lspdobject, 4, 5708, "hospital_lawn","hosp03b_law", 0);
    SetDynamicObjectMaterial(lspdobject, 13, 5708, "hospital_lawn","hosp03b_law", 0);
    SetDynamicObjectMaterial(lspdobject, 10, 5708, "hospital_lawn","hosp03b_law", 0);
    SetDynamicObjectMaterial(lspdobject, 9, 5708, "hospital_lawn","hosp03b_law", 0);
    SetDynamicObjectMaterial(lspdobject, 14, 5708, "hospital_lawn","hosp03b_law", 0);
	lspdobject = CreateDynamicObject( 19375, 1558.51501, -1675.02527, 46.16256, 0.0, 0.0, 0.0, -1, -1, -1, 500.0, 500.0);
    SetDynamicObjectMaterial(lspdobject, 0, 5708, "hospital_lawn", "hosp01_law", 0);
	lspdobject = CreateDynamicObject( 19375, 1571.51587, -1677.01941, 46.16256, 0.0, 0.0, 0.0, -1, -1, -1, 500.0, 500.0);
    SetDynamicObjectMaterial(lspdobject, 0, 5708, "hospital_lawn", "hosp01_law", 0);
	lspdobject = CreateDynamicObject( 19375, 1558.51501, -1675.02527, 35.72773, 0.0, 0.0, 0.0, -1, -1, -1, 500.0, 500.0);
    SetDynamicObjectMaterial(lspdobject, 0, 5708, "hospital_lawn", "hosp01_law", 0);
	lspdobject = CreateDynamicObject( 19375, 1558.51501, -1675.02527, 25.28357, 0.0, 0.0, 0.0, -1, -1, -1, 500.0, 500.0);
    SetDynamicObjectMaterial(lspdobject, 0, 5708, "hospital_lawn", "hosp01_law", 0);
	lspdobject = CreateDynamicObject( 19375, 1571.51587, -1677.01941, 35.62878, 0.0, 0.0, 0.0, -1, -1, -1, 500.0, 500.0);
    SetDynamicObjectMaterial(lspdobject, 0, 5708, "hospital_lawn", "hosp01_law", 0);
	lspdobject = CreateDynamicObject( 19375, 1571.51587, -1677.01941, 25.17185, 0.0, 0.0, 0.0, -1, -1, -1, 500.0, 500.0);
 	SetDynamicObjectMaterial(lspdobject, 0, 5708, "hospital_lawn", "hosp01_law", 0);*/

 	// LSPD (exterior)
 	//---	Крыша
	CreateDynamicObject(982,1554.40,-1663.60,27.95,0.0,0.0,0.0);
	CreateDynamicObject(982,1554.40,-1687.60,27.95,0.0,0.0,0.0);
	CreateDynamicObject(982,1577.90,-1650.20,27.95,0.0,0.0,0.0);
	CreateDynamicObject(982,1577.90,-1675.80,27.95,0.0,0.0,0.0);
	CreateDynamicObject(982,1577.90,-1701.50,27.95,0.0,0.0,0.0);
	CreateDynamicObject(982,1565.10,-1714.30,27.95,0.0,0.0,90.0);
	CreateDynamicObject(982,1555.50,-1714.30,27.95,0.0,0.0,90.0);
	CreateDynamicObject(982,1565.10,-1637.40,27.95,0.0,0.0,90.0);
	CreateDynamicObject(982,1555.50,-1637.40,27.95,0.0,0.0,90.0);
	CreateDynamicObject(984,1542.70,-1644.20,27.95,0.0,0.0,0.0);
	CreateDynamicObject(984,1542.70,-1707.40,27.95,0.0,0.0,0.0);
	CreateDynamicObject(983,1551.20,-1700.40,27.95,0.0,0.0,90.0);
	CreateDynamicObject(983,1545.90,-1700.40,27.95,0.0,0.0,90.0);
	CreateDynamicObject(1237,1543.10,-1713.80,27.40,0.0,0.0,0.0);
	CreateDynamicObject(1237,1543.10,-1700.90,27.40,0.0,0.0,0.0);
	CreateDynamicObject(1237,1577.50,-1713.90,27.40,0.0,0.0,0.0);
	CreateDynamicObject(1237,1543.20,-1637.80,27.40,0.0,0.0,0.0);
	CreateDynamicObject(983,1551.20,-1650.80,27.95,0.0,0.0,90.0);
	CreateDynamicObject(983,1546.40,-1650.80,27.95,0.0,0.0,90.0);
	CreateDynamicObject(1237,1577.50,-1637.7998000,27.40,0.0,0.0,0.0);
	CreateDynamicObject(1237,1543.20,-1650.40,27.40,0.0,0.0,0.0);
	CreateDynamicObject(3934,1549.80,-1644.10,27.40,0.0,0.0,0.0);
	CreateDynamicObject(3934,1549.70,-1707.10,27.40,0.0,0.0,0.0);
	CreateDynamicObject(2924,1565.40,-1667.35,28.6,0.0,0.0,0.0);
 	//---
	CreateDynamicObject(3029, 1584.22, -1637.95, 12.30, 0.00, 0.00, 90.00);// door
	//CreateDynamicObject(3934, 1549.90, -1612.29, 12.40, 0.00, 0.00, 90.00);// helipad 1
	//CreateDynamicObject(3934, 1564.40, -1612.29, 12.40, 0.00, 0.00, 90.00);// helipad 2
	CreateDynamicObject(1361, 1579.70, -1616.00, 13.10, 0.00, 0.00, 0.00);
	CreateDynamicObject(1361, 1579.70, -1618.58, 13.10, 0.00, 0.00, 0.00);
	CreateDynamicObject(984, 1579.70, -1609.03, 13.01, 0.00, 0.00, 0.00);
	//CreateDynamicObject(3515, 1546.72, -1661.09, 13.30, 0.00, 0.00, 0.00);
	//CreateDynamicObject(3515, 1546.83, -1690.17, 13.30, 0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1549.59, -1661.06, 13.41, 0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1543.91, -1695.42, 13.41, 0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1549.73, -1695.54, 13.41, 0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1549.58, -1684.46, 13.41, 0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1549.70, -1690.23, 13.41, 0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1543.89, -1666.62, 13.41, 0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1549.54, -1666.65, 13.41, 0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1549.57, -1655.92, 13.41, 0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1543.89, -1655.83, 13.41, 0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1543.88, -1661.09, 13.41, 0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1543.83, -1684.37, 13.41, 0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 1543.82, -1690.07, 13.41, 0.00, 0.00, 0.00);
	CreateDynamicObject(19123, 1539.36, -1636.28, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(19123, 1539.34, -1700.11, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(19123, 1539.33, -1707.81, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(19123, 1539.46, -1715.54, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(19123, 1545.10, -1715.61, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(19123, 1545.14, -1700.15, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(19123, 1545.15, -1651.14, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(19123, 1539.45, -1651.11, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(19123, 1545.05, -1636.18, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(19123, 1539.35, -1643.43, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(970, 1542.22, -1715.59, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(970, 1539.32, -1711.68, 13.48, 0.00, 0.00, 90.00);
	CreateDynamicObject(970, 1549.63, -1692.85, 13.48, 0.00, 0.00, 90.00);
	CreateDynamicObject(970, 1546.76, -1684.32, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(970, 1539.34, -1703.77, 13.48, 0.00, 0.00, 90.00);
	CreateDynamicObject(970, 1543.71, -1692.79, 13.48, 0.00, 0.00, 90.00);
	CreateDynamicObject(970, 1542.31, -1700.03, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(970, 1546.85, -1666.74, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(970, 1539.35, -1639.85, 13.48, 0.00, 0.00, 90.00);
	CreateDynamicObject(970, 1549.67, -1687.20, 13.48, 0.00, 0.00, 90.00);
	CreateDynamicObject(970, 1543.71, -1687.27, 13.48, 0.00, 0.00, 90.00);
	CreateDynamicObject(970, 1549.70, -1658.44, 13.48, 0.00, 0.00, 90.00);
	CreateDynamicObject(970, 1546.70, -1695.50, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(970, 1542.22, -1636.16, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(970, 1543.82, -1663.98, 13.48, 0.00, 0.00, 90.00);
	CreateDynamicObject(970, 1549.67, -1663.89, 13.48, 0.00, 0.00, 90.00);
	CreateDynamicObject(970, 1543.82, -1658.39, 13.48, 0.00, 0.00, 90.00);
	CreateDynamicObject(970, 1539.34, -1647.19, 13.48, 0.00, 0.00, 90.00);
	CreateDynamicObject(970, 1546.75, -1655.67, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(970, 1542.24, -1651.14, 13.48, 0.00, 0.00, 0.00);
	CreateDynamicObject(870, 1546.40, -1686.91, 13.07, 0.00, 0.00, 51.21);
	CreateDynamicObject(870, 1545.25, -1665.25, 13.07, 0.00, 0.00, 0.00);
	CreateDynamicObject(870, 1547.80, -1665.13, 13.07, 0.00, 0.00, 0.00);
	CreateDynamicObject(870, 1547.98, -1663.80, 13.07, 0.00, 0.00, 0.00);
	CreateDynamicObject(870, 1545.99, -1664.22, 13.07, 0.00, 0.00, 42.16);
	CreateDynamicObject(870, 1544.94, -1663.71, 13.07, 0.00, 0.00, 42.16);
	CreateDynamicObject(870, 1548.07, -1657.24, 13.07, 0.00, 0.00, 42.16);
	CreateDynamicObject(870, 1545.55, -1657.37, 13.07, 0.00, 0.00, 42.16);
	CreateDynamicObject(870, 1548.30, -1658.71, 13.07, 0.00, 0.00, 20.13);
	CreateDynamicObject(870, 1544.90, -1658.76, 13.07, 0.00, 0.00, 51.21);
	CreateDynamicObject(870, 1548.16, -1685.86, 13.07, 0.00, 0.00, 51.21);
	CreateDynamicObject(870, 1545.58, -1685.85, 13.07, 0.00, 0.00, 51.21);
	CreateDynamicObject(870, 1544.99, -1687.70, 13.07, 0.00, 0.00, 51.21);
	CreateDynamicObject(870, 1545.11, -1692.64, 13.07, 0.00, 0.00, 51.21);
	CreateDynamicObject(870, 1548.00, -1687.43, 13.07, 0.00, 0.00, 51.21);
	CreateDynamicObject(870, 1544.99, -1687.70, 13.07, 0.00, 0.00, 51.21);
	CreateDynamicObject(870, 1548.17, -1694.14, 13.07, 0.00, 0.00, 51.21);
	CreateDynamicObject(870, 1545.94, -1694.21, 13.07, 0.00, 0.00, 51.21);
	CreateDynamicObject(870, 1548.24, -1692.77, 13.07, 0.00, 0.00, 51.21);
	CreateDynamicObject(870, 1545.81, -1692.92, 13.07, 0.00, 0.00, 51.21);
	CreateDynamicObject(870, 1545.01, -1694.09, 13.07, 0.00, 0.00, 51.21);
	CreateDynamicObject(1360, 1544.64, -1619.59, 13.28, 0.00, 0.00, 0.00);
	CreateDynamicObject(1360, 1544.64, -1634.49, 13.28, 0.00, 0.00, 0.00);
	CreateDynamicObject(1361, 1544.64, -1622.09, 13.28, 0.00, 0.00, 0.00);
	CreateDynamicObject(1671, 1579.18, -1635.67, 12.99, 0.00, 0.00, 177.43);
	CreateDynamicObject(1671, 1580.57, -1635.62, 12.99, 0.00, 0.00, 202.97);
	CreateDynamicObject(1429, 1579.86, -1633.20, 15.42, 18.00, 0.00, 0.00);
	CreateDynamicObject(1429, 1580.67, -1633.20, 15.42, 18.00, 0.00, 0.00);
	CreateDynamicObject(1429, 1579.05, -1633.20, 15.42, 18.00, 0.00, 0.00);
	CreateDynamicObject(817, 1542.02, -1705.57, 13.40, 0.00, 0.00, 31.64);
	CreateDynamicObject(817, 1540.78, -1706.84, 13.40, 0.00, 0.00, -127.00);
	CreateDynamicObject(817, 1541.76, -1708.84, 13.40, 0.00, 0.00, 105.00);
	CreateDynamicObject(817, 1541.41, -1710.99, 13.40, 0.00, 0.00, -120.00);
	CreateDynamicObject(817, 1540.77, -1645.61, 13.40, 0.00, 0.00, 321.79);
	CreateDynamicObject(817, 1542.01, -1644.02, 13.40, 0.00, 0.00, 33.00);
	CreateDynamicObject(817, 1541.14, -1642.78, 13.40, 0.00, 0.00, 302.00);
	obj = CreateDynamicObject(817, 1541.47, -1641.12, 13.40, 0.00, 0.00, 265.00);
 	return obj;
}

LSPD_Int_CreateObjects()
{
	// Ammunation LSPD
	CreateDynamicObject(347, 314.369, -163.16, 999.60, -94.69, 45.900, 34.999);	//	Silenced
	CreateDynamicObject(348, 315.507, -163.16, 999.59, -88.29, 84.198, 80.400);	//	Deagle

	CreateDynamicObject(353, 314.387, -161.47, 999.54, 96.999, 67.599, -75.30);	//	mp5

	CreateDynamicObject(349, 309.657, -158.69, 998.76, 16.399, -86.89, -170.6);	//	Shotgun
	CreateDynamicObject(349, 309.475, -158.69, 998.76, 16.399, -86.89, -170.6);	//	Shotgun
	CreateDynamicObject(349, 309.356, -158.90, 998.77, 34.198, -81.58, -178.3);	//	Shotgun
	CreateDynamicObject(349, 309.202, -158.75, 998.82, -27.00, -86.87, -9.800);	//	Shotgun
	CreateDynamicObject(350, 315.357, -161.45, 999.54, 82.799, 4.3999, -15.20);	//	sawnoff
	CreateDynamicObject(351, 309.878, -161.76, 999.54, 97.299, 142.69, -100.9);	//	shotgspa
	
	CreateDynamicObject(355, 311.162, -163.25, 999.61, -83.30, 36.700, 57.000);	//	AK47
	CreateDynamicObject(356, 309.984, -163.12, 999.60, -96.19, -65.88, -90.79);	//	M4

	CreateDynamicObject(358, 313.731, -158.75, 999.88, 96.199, 73.399, 105.09);	//	sniper
	CreateDynamicObject(357, 311.172, -161.47, 999.52, 97.299, 118.99, -143.7);	//	cuntgun

	CreateDynamicObject(373, 319.057, -159.85, 1000.22, -27.9, -57.89, -178.4);	//	Armour

	// LSPD (interior)
	CreateDynamicObject(1535, 246.96, 72.53, 1002.60, 0.00, 0.00, 0.00);// Дверь зап
	CreateDynamicObject(1998, 252.34, 65.96, 1002.64, 0.00, 0.00, 89.00);
	CreateDynamicObject(2008, 251.39, 67.86, 1002.64, 0.00, 0.00, 89.25);
	CreateDynamicObject(1811, 252.60, 66.93, 1003.27, 0.00, 0.00, 0.00);
	CreateDynamicObject(1811, 252.79, 68.60, 1003.27, 0.00, 0.00, 0.00);
	CreateDynamicObject(1722, 242.65, 63.15, 1002.64, 0.00, 0.00, 270.00);
	CreateDynamicObject(1722, 242.71, 64.33, 1002.64, 0.00, 0.00, 270.00);
	CreateDynamicObject(1722, 242.52, 68.21, 1002.64, 0.00, 0.00, 270.00);
	CreateDynamicObject(1722, 242.59, 69.51, 1002.64, 0.00, 0.00, 270.00);
	CreateDynamicObject(1722, 242.65, 70.89, 1002.64, 0.00, 0.00, 270.00);
	CreateDynamicObject(2949, 250.47, 64.24, 1002.64, 0.00, 0.00, 0.00);
	//CreateDynamicObject(1649, 250.57, 67.83, 1004.31, 0.00, 0.00, 270.25);
	CreateDynamicObject(2949, 250.47, 62.73, 1002.64, 0.00, 0.00, 0.00);
	CreateDynamicObject(2616, 219.37, 65.87, 1005.53, 0.00, 0.00, 180.00);
	CreateDynamicObject(1722, 218.47, 70.44, 1004.07, 0.00, 0.00, 178.75);
	CreateDynamicObject(1722, 219.48, 70.43, 1004.04, 0.00, 0.00, 180.49);
	CreateDynamicObject(1722, 220.74, 70.47, 1004.04, 0.00, 0.00, 180.49);
	CreateDynamicObject(1722, 218.56, 68.74, 1004.04, 0.00, 0.00, 180.49);
	CreateDynamicObject(1722, 219.61, 68.80, 1004.04, 0.00, 0.00, 180.49);
	CreateDynamicObject(1722, 217.67, 71.87, 1004.04, 0.00, 0.00, 178.74);
	CreateDynamicObject(1722, 218.85, 71.76, 1004.04, 0.00, 0.00, 178.74);
	CreateDynamicObject(1722, 220.16, 71.67, 1004.04, 0.00, 0.00, 178.74);
	CreateDynamicObject(2614, 218.15, 73.91, 1006.26, 0.00, 0.00, 179.75);
	CreateDynamicObject(2161, 221.35, 73.84, 1004.04, 0.00, 0.00, 178.00);
	CreateDynamicObject(2164, 220.02, 73.88, 1004.04, 0.00, 0.00, 179.00);
	CreateDynamicObject(2191, 214.86, 74.45, 1004.04, 0.00, 0.00, 179.25);
	CreateDynamicObject(1806, 217.95, 75.05, 1004.04, 0.00, 0.00, 0.00);
	CreateDynamicObject(2184, 218.99, 77.11, 1004.04, 0.00, 0.00, 182.00);
	CreateDynamicObject(2120, 219.46, 78.11, 1004.68, 0.00, 0.00, 0.00);
	CreateDynamicObject(1723, 216.99, 82.43, 1004.04, 0.00, 0.00, 0.00);
	CreateDynamicObject(2180, 218.01, 78.68, 1003.99, 0.00, 0.00, 271.50);
	CreateDynamicObject(2120, 216.48, 78.11, 1004.68, 0.00, 0.00, 179.75);
	obj = CreateDynamicObject(2190, 218.04, 76.92, 1004.81, 0.00, 0.00, 0.00);
	return obj;
}

//	Автошкола
Autoschool_CreateObjects()
{
	CreateDynamicObject(966,-2043.7049561,-80.5309982,34.1640015,0.00,0.00,0.00);
	CreateDynamicObject(984,-2017.1787109,-86.6220703,34.9570007,0.00,0.00,0.00);
	CreateDynamicObject(984,-2023.5898438,-80.2324219,34.9570007,0.00,0.00,90.00);
	CreateDynamicObject(1215,-2042.0539551,-80.2429962,34.8849983,0.00,0.00,0.00);
	CreateDynamicObject(1215,-2052.3710938,-80.2539978,34.8849983,0.00,0.00,0.00);
	CreateDynamicObject(984,-2065.4511719,-80.2480469,34.9570007,0.00,0.00,90.00);
	CreateDynamicObject(984,-2089.4677734,-80.2509766,34.9570007,0.00,0.00,89.9945068);
	CreateDynamicObject(984,-2076.6601562,-80.2509766,34.9570007,0.00,0.00,90.00);
	CreateDynamicObject(984,-2058.7580566,-80.2470016,34.9570007,0.00,0.00,90.00);
	CreateDynamicObject(983,-2057.1435547,-83.4365234,35.0040016,0.00,0.00,0.00);
	CreateDynamicObject(983,-2033.1939697,-80.2269974,35.0040016,0.00,0.00,90.00);
	CreateDynamicObject(983,-2038.8389893,-80.2259979,35.0040016,0.00,0.00,90.00);
	CreateDynamicObject(1215,-2057.1601562,-86.6757812,34.8849983,0.00,0.00,0.00);
	CreateDynamicObject(18014,-2093.5200195,-79.8379974,34.7529984,0.00,0.00,90.0839844);
	CreateDynamicObject(18014,-2085.3491211,-79.8379974,34.7529984,0.00,0.00,90.0823975);
	CreateDynamicObject(18014,-2076.9270020,-79.8379974,34.7529984,0.00,0.00,90.0823975);
	CreateDynamicObject(18014,-2068.5048828,-79.8378906,34.7529984,0.00,0.00,90.0823975);
	CreateDynamicObject(18014,-2059.4638672,-79.8378906,34.7529984,0.00,0.00,90.0823975);
	CreateDynamicObject(18014,-2034.6140137,-79.8379974,34.7529984,0.00,0.00,90.0823975);
	CreateDynamicObject(18014,-2019.4649658,-79.8379974,34.7529984,0.00,0.00,90.0823975);
	CreateDynamicObject(1280,-2019.8000488,-88.1729965,34.7220001,0.00,0.00,90.00);
	CreateDynamicObject(1280,-2027.1855469,-88.1728516,34.7220001,0.00,0.00,90.00);
	CreateDynamicObject(1280,-2035.0439453,-88.1728516,34.7220001,0.00,0.00,90.00);
	CreateDynamicObject(1280,-2037.5469971,-84.2839966,34.7220001,0.00,0.00,0.00);
	CreateDynamicObject(1346,-2040.7760010,-81.2279968,35.6710014,0.00,0.00,0.00);
	CreateDynamicObject(1257,-2027.0908203,-79.1933594,35.5999985,0.00,0.00,270.00);
	CreateDynamicObject(1231,-2036.8486328,-88.1621094,37.0499992,0.00,0.00,308.3203125);
	CreateDynamicObject(1231,-2017.4580078,-88.0722656,37.0509987,0.00,0.00,26.0101318);
	CreateDynamicObject(1359,-2030.2879639,-78.9570007,34.9410019,0.00,0.00,0.00);
	CreateDynamicObject(1468,-2017.1510010,-95.6429977,35.3359985,0.00,0.00,270.00);
	CreateDynamicObject(1468,-2017.1510010,-100.8050003,35.3359985,0.00,0.00,270.00);
	CreateDynamicObject(869,-2019.5710449,-85.5370026,34.9650002,0.00,0.00,0.00);
	CreateDynamicObject(869,-2023.4780273,-82.5130005,34.9650002,0.00,0.00,0.00);
	CreateDynamicObject(3515,-2027.1992188,-84.0615234,35.4150009,0.00,0.00,0.00);
	CreateDynamicObject(869,-2019.6240234,-82.6139984,34.9650002,0.00,0.00,0.00);
	CreateDynamicObject(869,-2023.4470215,-85.5309982,34.9650002,0.00,0.00,0.00);
	CreateDynamicObject(869,-2027.1479492,-85.5390015,34.9650002,0.00,0.00,0.00);
	CreateDynamicObject(869,-2031.1120605,-85.4909973,34.9650002,0.00,0.00,0.00);
	CreateDynamicObject(869,-2034.6789551,-85.4280014,34.9650002,0.00,0.00,0.00);
	CreateDynamicObject(869,-2034.6850586,-82.4359970,34.9650002,0.00,0.00,0.00);
	CreateDynamicObject(869,-2030.9079590,-82.3280029,34.9650002,0.00,0.00,0.00);
	CreateDynamicObject(869,-2027.1579590,-82.6439972,34.9650002,0.00,0.00,0.00);
	CreateDynamicObject(19425,-2048.6970215,-80.5059967,34.1619987,0.00,0.00,0.00);
	CreateDynamicObject(19425,-2045.6450195,-80.5059967,34.1640015,0.00,0.00,0.00);
	CreateDynamicObject(16322,-2090.6679688,-99.6989975,36.5139999,0.00,0.00,0.00);
	CreateDynamicObject(16322,-2090.6560059,-97.4219971,36.5139999,0.00,0.00,0.00);
	CreateDynamicObject(16322,-2080.7719727,-97.4649963,34.7700005,0.00,340.00,180.00);
	CreateDynamicObject(16322,-2080.7819824,-99.7389984,34.7700005,0.00,339.9993896,179.9945068);
	CreateDynamicObject(8614,-2090.5939941,-101.2559967,34.5970001,0.00,0.00,0.00);
	CreateDynamicObject(1215,-2081.2180176,-100.4739990,34.7330017,0.00,0.00,2.4619446);
	obj = CreateDynamicObject(1215,-2081.2070312,-96.7139969,34.7319984,0.00,0.00,356.9755859);
	return obj;
}

// Fort Carson
FortCarson_CreateObjects()
{
	// Основное
	CreateDynamicObject(1447, -163.21, 1158.28, 20.01, 3.14, 0.00, 0.00);// Забор1
	CreateDynamicObject(1447, -157.96, 1158.29, 20.01, 3.14, 0.00, 0.00);// Забор2
	CreateDynamicObject(1468, -178.61, 1127.36, 19.94, 0.00, 0.00, 90.00);// Забор3
	CreateDynamicObject(1468, -178.61, 1122.11, 19.94, 0.00, 0.00, 90.00);// Забор4
	CreateDynamicObject(19458, -180.10, 1169.23, 20.42, 0.00, 0.00, 0.00);// Дер.забор
	CreateDynamicObject(16480, -265.83, 1321.50, 49.04, 0.00, 0.00, 20.89);// Надпись Форт Карсон
	CreateDynamicObject(16001, -88.25, 1212.27, 18.72, 0.00, 0.00, 180.00);// Будка к Мотелю
	CreateDynamicObject(1493, -18.25, 1215.69, 18.33, 0.00, 0.00, 0.00);// Дверь Мотеля
	CreateDynamicObject(933, -26.43, 1159.38, 18.29, 0.00, 0.00, 0.00);// Защита для столба
	CreateDynamicObject(973, -380.63409, 1151.71936, 19.44900, 0.0, 0.0, 261.39600);// Заграждение возле пирса
	CreateDynamicObject(973, -379.42789, 1160.83765, 19.44900, 0.0, 0.0, 265.94769);// Заграждение
	CreateDynamicObject(973, -376.80627, 1183.85059, 19.44900, 0.0, 0.0, 270.0);// Заграждение
	CreateDynamicObject(973, -376.73465, 1195.23657, 19.44900, 0.0, 0.0, 269.98233);// Заграждение
	CreateDynamicObject(973, -480.19421, 2028.35693, 59.67690, 0.0, -1.0, -69.0);
	CreateDynamicObject(973, -482.63058, 2039.30884, 60.37690, 0.0, 7.0, -84.0);
	CreateDynamicObject(984, -136.77568, 1208.36255, 19.36820, 0.0, 0.0, 90.0);
	CreateDynamicObject(983, -128.77921, 1208.37756, 19.40820, 0.0, 0.0, 90.0);
	CreateDynamicObject(984, -125.64194, 1214.75623, 18.90820, 355.5, 0.0, 0.0);
	CreateDynamicObject(984, -178.45834, 1208.33154, 19.36820, 0.0, 0.0, 90.0);
	CreateDynamicObject(984, -206.92910, 1208.36755, 19.36820, 0.0, 0.0, 90.0);
	CreateDynamicObject(2118, 960.98566, -45.73114, 1000.1, 0.0, 0.0, 0.0);// Стол в отеле
	CreateDynamicObject(2024, 960.02606, -58.17406, 1000.1, 0.0, 0.0, 0.0);// Стол в отеле

	// Газон Майка
	CreateDynamicObject(874, -229.03680, 1057.61438, 18.6, 0.0, 0.0, 80.0);
	CreateDynamicObject(874, -228.69760, 1046.73450, 18.6, 0.0, 0.0, 80.0);
	CreateDynamicObject(874, -232.25150, 1039.78796, 18.6, 0.0, 0.0, 240.0);
	CreateDynamicObject(874, -235.93550, 1034.25378, 18.6, 0.0, 0.0, 77.0);
	CreateDynamicObject(874, -224.34489, 1037.32764, 18.6, 0.0, 0.0, -19.0);

	// Оформление перед больницей
	CreateDynamicObject(703, -298.75, 1079.59, 18.90, 0.00, 0.00, 0.00);// Деревья
	CreateDynamicObject(846, -288.88, 1085.14, 19.31, 0.00, 0.00, 45.00);// Деревья
	CreateDynamicObject(848, -289.91, 1080.88, 20.25, 0.00, 0.00, 300.0);// Деревья
	// #NEWYEAR
	/*CreateDynamicObject(19076, -296.38690, 1081.45508, 18.80100, 0.0, 0.0, 0.0);
	CreateDynamicObject(19454, -290.14517, 1081.41443, 18.70310, 0.0, 90.0, 90.0);
	CreateDynamicObject(1280, -288.08838, 1083.83179, 19.08420, 0.0, 0.0, 90.0);
	CreateDynamicObject(19454, -303.32687, 1081.17383, 18.70310, 0.0, 90.0, 90.0);
	CreateDynamicObject(1280, -292.58740, 1083.82593, 19.08420, 0.0, 0.0, 90.0);
	CreateDynamicObject(1280, -292.32990, 1078.67920, 19.08420, 0.0, 0.0, 270.0);
	CreateDynamicObject(1280, -288.15265, 1078.64587, 19.08420, 0.0, 0.0, 270.0);
	CreateDynamicObject(1419, -292.97177, 1088.35645, 19.22900, 0.0, 0.0, 0.0);
	CreateDynamicObject(1419, -288.88684, 1088.36475, 19.22900, 0.0, 0.0, 0.0);
	CreateDynamicObject(1419, -287.68756, 1088.36951, 19.22900, 0.0, 0.0, 0.0);
	CreateDynamicObject(1419, -285.59665, 1086.33508, 19.22900, 0.0, 0.0, 90.0);
	CreateDynamicObject(1419, -285.59991, 1085.11560, 19.22900, 0.0, 0.0, 90.0);
	CreateDynamicObject(14469, -288.50439, 1086.39612, 18.73489, 0.0, 0.0, 0.0);
	CreateDynamicObject(14469, -293.06061, 1086.20630, 18.73489, 0.0, 0.0, 0.0);
	CreateDynamicObject(19121, -286.09442, 1083.65710, 19.24260, 0.0, 0.0, 0.0);
	CreateDynamicObject(19121, -285.96683, 1078.76563, 19.24260, 0.0, 0.0, 0.0);
	CreateDynamicObject(19362, -296.71649, 1087.26367, 18.70310, 0.0, 90.0, 0.0);
	CreateDynamicObject(19362, -296.71649, 1084.06372, 18.70310, 0.0, 90.0, 0.0);
	CreateDynamicObject(19362, -296.71649, 1080.86353, 18.70310, 0.0, 90.0, 0.0);
	CreateDynamicObject(19362, -296.71649, 1077.66357, 18.70310, 0.0, 90.0, 0.0);
	CreateDynamicObject(19362, -296.71649, 1074.46362, 18.70310, 0.0, 90.0, 0.0);
	CreateDynamicObject(14469, -288.62146, 1076.11426, 18.73489, 0.0, 0.0, 0.0);
	CreateDynamicObject(14469, -292.39575, 1076.16187, 18.73489, 0.0, 0.0, 0.0);
	CreateDynamicObject(14469, -301.46548, 1086.12500, 18.73489, 0.0, 0.0, 0.0);
	CreateDynamicObject(14469, -304.55869, 1086.22241, 18.73489, 0.0, 0.0, 0.0);
	CreateDynamicObject(14469, -301.31519, 1076.40662, 18.73489, 0.0, 0.0, 0.0);
	CreateDynamicObject(14469, -304.81042, 1076.28967, 18.73489, 0.0, 0.0, 0.0);
	CreateDynamicObject(1419, -300.51556, 1088.33240, 19.22900, 0.0, 0.0, 0.0);
	CreateDynamicObject(1419, -305.20724, 1088.35315, 19.22900, 0.0, 0.0, 0.0);
	CreateDynamicObject(1419, -304.37787, 1088.35095, 19.22900, 0.0, 0.0, 0.0);
	CreateDynamicObject(1419, -307.19165, 1086.29150, 19.22900, 0.0, 0.0, 90.0);
	CreateDynamicObject(1419, -307.19165, 1086.29150, 19.22900, 0.0, 0.0, 90.0);
	CreateDynamicObject(1419, -307.19571, 1085.06799, 19.22900, 0.0, 0.0, 90.0);
	CreateDynamicObject(1419, -307.17407, 1077.45935, 19.22900, 0.0, 0.0, 90.0);
	CreateDynamicObject(1419, -307.20517, 1075.37817, 19.22900, 0.0, 0.0, 90.0);
	CreateDynamicObject(1280, -300.81763, 1078.56079, 19.08420, 0.0, 0.0, 270.0);
	CreateDynamicObject(1280, -304.70773, 1078.50159, 19.08420, 0.0, 0.0, 270.0);
	CreateDynamicObject(1280, -300.51807, 1083.89380, 19.08420, 0.0, 0.0, 90.0);
	CreateDynamicObject(1280, -304.59122, 1083.81409, 19.08420, 0.0, 0.0, 90.0);
	CreateDynamicObject(1419, -305.19037, 1073.39050, 19.22900, 0.0, 0.0, 0.0);
	CreateDynamicObject(1419, -300.54620, 1073.36157, 19.22900, 0.0, 0.0, 0.0);
	CreateDynamicObject(1419, -302.26874, 1073.39868, 19.22900, 0.0, 0.0, 0.0);
	CreateDynamicObject(1419, -292.94101, 1073.39441, 19.22900, 0.0, 0.0, 0.0);
	CreateDynamicObject(1419, -287.61566, 1073.37292, 19.22900, 0.0, 0.0, 0.0);
	CreateDynamicObject(1419, -289.65802, 1073.38879, 19.22900, 0.0, 0.0, 0.0);
	CreateDynamicObject(1419, -285.42624, 1077.81799, 19.22900, 0.0, 0.0, 90.0);
	CreateDynamicObject(1419, -285.45108, 1075.41150, 19.22900, 0.0, 0.0, 90.0);
	CreateDynamicObject(19121, -294.45041, 1073.87329, 19.24260, 0.0, 0.0, 0.0);
	CreateDynamicObject(19121, -298.93906, 1073.88574, 19.24260, 0.0, 0.0, 0.0);
	CreateDynamicObject(19121, -306.72186, 1078.81531, 19.24260, 0.0, 0.0, 0.0);
	CreateDynamicObject(19121, -306.86523, 1083.50488, 19.24260, 0.0, 0.0, 0.0);
	CreateDynamicObject(19121, -298.98746, 1087.89258, 19.24260, 0.0, 0.0, 0.0);
	CreateDynamicObject(19121, -294.53409, 1087.79004, 19.24260, 0.0, 0.0, 0.0);*/

	//CreateDynamicObject(19054, -296.34656, 1082.95984, 19.43210, 0.0, 0.0, 0.0);// Подарки
	//CreateDynamicObject(19055, -298.20081, 1081.49170, 19.43210, 0.0, 0.0, 0.0);//
	//CreateDynamicObject(19058, -294.78427, 1081.54358, 19.43210, 0.0, 0.0, 0.0);//
	//CreateDynamicObject(19057, -296.39575, 1079.83875, 19.43210, 0.0, 0.0, 0.0);//

	//	Подарки на площади (на открытие)
	/*CreateDynamicObject(19054, 1716.8, -1918.15, 13.17, 0.0, 0.0, 0.00);
	CreateDynamicObject(19055, 1716.9, -1916.79, 13.22, 0.0, 0.0, 20.4);
	CreateDynamicObject(19056, 1717.5, -1919.36, 13.20, 0.0, 0.0, 23.1);
	CreateDynamicObject(19057, 1718.2, -1918.21, 13.11, 0.0, 0.0, 16.8);
	CreateDynamicObject(19058, 1718.4, -1916.90, 13.18, 0.0, 0.0, 23.1);
	CreateDynamicObject(19054, 1715.6, -1917.42, 13.13, 0.0, 0.0, -31.1);
	CreateDynamicObject(19056, 1716.3, -1917.26, 14.28, 0.0, 0.0, 14.80);
	CreateDynamicObject(19057, 1715.4, -1919.24, 13.14, 0.0, 0.0, 9.299);
	CreateDynamicObject(19055, 1717.2, -1918.59, 14.34, 0.0, 0.0, -16.1);
	
	//---
	CreateDynamicObject(18728, 1716.8, -1918.23, 13.00, 0.0, 0.0, 0.00);	//	фаер
	CreateDynamicObject(18761, 1811.2, -1889.46, 13.41, 0.0, 0.0, 90.1);	//	ворота на въезде
	CreateDynamicObject(19129, 1716.5, -1917.05, 12.55, 0.0, 0.0, 0.00);	//	площадка
	CreateDynamicObject(19158, 1716.4, -1917.07, 13.57, 0.0, 0.0, 0.00);
	//---	подсветка на стойках
	CreateDynamicObject(19149, 1725.3, -1927.21, 17.09, 0.0, 0.0, 0.0);
	CreateDynamicObject(19143, 1721.3, -1927.21, 17.09, 0.0, 0.0, 0.0);
	CreateDynamicObject(19148, 1716.3, -1927.21, 17.09, 0.0, 0.0, 0.0);
	CreateDynamicObject(19146, 1711.2, -1927.21, 17.09, 0.0, 0.0, 0.0);
	CreateDynamicObject(19145, 1706.9, -1927.21, 17.09, 0.0, 0.0, 0.0);

	CreateDynamicObject(19145, 1706.2, -1922.19, 17.09, 0.0, 0.0, -90.0);
	CreateDynamicObject(19143, 1706.2, -1922.19, 17.09, 0.0, 0.0, -90.0);
	CreateDynamicObject(19149, 1706.2, -1917.04, 17.09, 0.0, 0.0, -90.0);
	CreateDynamicObject(19144, 1706.2, -1911.96, 17.09, 0.0, 0.0, -90.0);
	CreateDynamicObject(19148, 1706.2, -1907.20, 17.09, 0.0, 0.0, -90.0);

	CreateDynamicObject(19147, 1725.3, -1906.82, 17.09, 0.0, 0.0, -180.0);
	CreateDynamicObject(19144, 1721.3, -1906.82, 17.09, 0.0, 0.0, -180.0);
	CreateDynamicObject(19143, 1716.3, -1906.82, 17.09, 0.0, 0.0, -180.0);
	CreateDynamicObject(19146, 1711.2, -1906.82, 17.09, 0.0, 0.0, -180.0);
	CreateDynamicObject(19145, 1706.9, -1906.82, 17.09, 0.0, 0.0, -180.0);

	CreateDynamicObject(19144, 1726.6, -1922.19, 17.09, 0.0, 0.0, -270.0);
	CreateDynamicObject(19145, 1726.6, -1922.19, 17.09, 0.0, 0.0, -270.0);
	CreateDynamicObject(19148, 1726.6, -1917.04, 17.09, 0.0, 0.0, -270.0);
	CreateDynamicObject(19144, 1726.6, -1911.96, 17.09, 0.0, 0.0, -270.0);
	CreateDynamicObject(19149, 1726.6, -1907.20, 17.09, 0.0, 0.0, -270.0);
	//---	свечение
	CreateDynamicObject(19297, 1719.8, -1917.91, 13.10, 0.0, 0.0, 0.0);
	CreateDynamicObject(19297, 1714.2, -1918.08, 13.10, 0.0, 0.0, 0.0);
	CreateDynamicObject(19297, 1716.8, -1915.82, 13.10, 0.0, 0.0, 0.0);
	CreateDynamicObject(19297, 1716.9, -1919.68, 13.10, 0.0, 0.0, 0.0);*/

	// Заграждение (серпантит возле дамбы)
	CreateDynamicObject(979, -370.91025, 2068.05762, 60.32240, 0.0, 1.0, 101.0);
	CreateDynamicObject(979, -375.21115, 2077.65869, 60.22240, 0.0, 0.0, 125.0);
	CreateDynamicObject(979, -383.25449, 2085.41357, 60.62240, 0.0, -2.0, 146.0);
	CreateDynamicObject(979, -393.25708, 2089.57202, 61.02240, 0.0, -2.50000, 168.0);
	CreateDynamicObject(979, -404.45651, 2088.89160, 61.42240, 0.0, -1.0, 198.0);

	// Сельхоз центр
	// Забор
	CreateDynamicObject(8674, -260.35001, 1208.37000, 20.10000, 0.0, 0.0, 0.0);
	CreateDynamicObject(8674, -250.06210, 1208.38586, 20.10000, 0.0, 0.0, 0.0);
	CreateDynamicObject(8674, -215.86000, 1213.55005, 20.10000, 0.0, 0.0, 90.0);
	CreateDynamicObject(8674, -215.86000, 1223.84998, 20.10000, 0.0, 0.0, 90.0);
	CreateDynamicObject(8674, -215.86000, 1234.15002, 20.10000, 0.0, 0.0, 90.0);
	CreateDynamicObject(8674, -265.79691, 1213.53369, 20.10000, 0.0, 0.0, 93.0);
	CreateDynamicObject(8674, -231.36211, 1208.38586, 20.10000, 0.0, 0.0, 0.0);
	CreateDynamicObject(8674, -221.06210, 1208.38586, 20.10000, 0.0, 0.0, 0.0);
	CreateDynamicObject(8674, -266.35431, 1223.86328, 20.10000, 0.0, 0.0, 93.0);

	// Флора и фауна
	CreateDynamicObject(640, -255.44135, 1209.42798, 19.59660, 0.0, 0.0, 90.0);// Возле забора
	CreateDynamicObject(640, -262.22086, 1209.31262, 19.59660, 0.0, 0.0, 90.0);//
	CreateDynamicObject(640, -248.37854, 1209.40967, 19.59660, 0.0, 0.0, 90.0);//
	CreateDynamicObject(638, -239.72150, 1220.82680, 19.35080, 0.0, 0.0, 0.0);// Возле двери
	CreateDynamicObject(638, -242.44320, 1220.82680, 19.35080, 0.0, 0.0, 0.0);//
	CreateDynamicObject(867, -229.57628, 1226.19360, 19.10115, 0.0, 0.0, 358.84329);// Камень
	CreateDynamicObject(868, -217.77483, 1228.59717, 19.10110, 0.0, 0.0, 358.84329);// Камень
	CreateDynamicObject(819, -223.41458, 1227.65881, 18.68327, 0.0, 0.0, 0.0);// Кусты
	// Дома
	CreateDynamicObject(16285, -245.53680, 1222.59570, 18.82450, 0.0, 0.0, 0.0);
	CreateDynamicObject(16285, -253.35620, 1222.43115, 18.92450, 0.0, 0.0, 1.50000);
	CreateDynamicObject(16285, -261.02060, 1222.20862, 18.92450, 0.0, 0.0, 3.0);
	// Около территории
	CreateDynamicObject(16281, -268.68176, 1231.61438, 25.81964, 0.0, 0.0, 177.79097);// Табличка
	CreateDynamicObject(16325, -290.79810, 1223.82373, 18.85750, 0.0, 0.0, 90.0);// Платформа
	CreateDynamicObject(11493, -273.81659, 1209.16248, 16.60000, 0.0, 0.0, 0.0);// Большая лестница
	//SetDynamicObjectMaterial(CreateDynamicObject(19366,-272.48,1215.46,19.18,-0.4,0.0,349.50), 0, 13724, "docg01_lahills", "des_ranchwall1", 0);
	//SetDynamicObjectMaterial(CreateDynamicObject(19366,-272.06,1218.66,19.18,0.5,0.0,355.51), 0, 13724, "docg01_lahills", "des_ranchwall1", 0);
	//SetDynamicObjectMaterial(CreateDynamicObject(19366,-272.91,1213.40,18.64,28.2,0.0,347.10), 0, 13724, "docg01_lahills", "des_ranchwall1", 0);
	// Остальное
	CreateDynamicObject(3359, -221.26804, 1215.13684, 18.73000, 0.50000, 0.0, 270.0);// Деревянный гараж
	CreateDynamicObject(16326, -239.04230, 1226.10986, 18.65000, 0.0, 0.0, 180.0);// Дом губернатора
	CreateDynamicObject(1498, -241.7810, 1223.6501, 18.6678, 0.0, 0.0, 0.0);// Дверь
	CreateDynamicObject(11500, -230.95129, 1208.73706, 18.67210, 0.0, 0.0, 0.0);// Табличка
	CreateDynamicObject(1294, -250.04570, 1218.0, 21.0, 0.0, 0.0, 90.0);// Фонарь
	CreateDynamicObject(1294, -257.75009, 1218.0, 21.0, 0.0, 0.0, 90.0);// Фонарь
	CreateDynamicObject(1568, -241.01711, 1224.11719, 18.10340, 0.0, 0.0, 0.0);// Лампа над дверью

	// Супермаркет 24/7
	CreateDynamicObject(970, -125.54000, 1160.57813, 19.27760, 0.0, 0.0, 270.0);// Забор
	CreateDynamicObject(970, -125.54000, 1164.67810, 19.27760, 0.0, 0.0, 270.0);// Забор
	CreateDynamicObject(970, -125.54000, 1168.77808, 19.27760, 0.0, 0.0, 270.0);// Забор
	CreateDynamicObject(970, -125.54000, 1172.87805, 19.27760, 0.0, 0.0, 270.0);// Забор
	CreateDynamicObject(970, -133.01280, 1188.33412, 19.28000, 0.0, 0.0, 0.0);// Забор
	CreateDynamicObject(970, -144.41280, 1188.33411, 19.28000, 0.0, 0.0, 0.0);// Забор
	CreateDynamicObject(970, -148.51280, 1188.33411, 19.28000, 0.0, 0.0, 0.0);// Забор
	CreateDynamicObject(970, -152.61279, 1188.33411, 19.28000, 0.0, 0.0, 0.0);// Забор
	CreateDynamicObject(970, -156.71280, 1188.33411, 19.28000, 0.0, 0.0, 0.0);// Забор
	CreateDynamicObject(970, -160.81281, 1188.33411, 19.28000, 0.0, 0.0, 0.0);// Забор
	CreateDynamicObject(792, -142.91252, 1186.91077, 19.01320, 0.0, 0.0, 0.0);// Дерево
	CreateDynamicObject(792, -134.01250, 1186.91077, 19.01320, 0.0, 0.0, 0.0);// Дерево
	CreateDynamicObject(2388, -143.79269, 1173.25769, 18.72000, 0.0, 0.0, 0.0);// Стойка на входе
	CreateDynamicObject(2388, -147.39270, 1173.25769, 18.72000, 0.0, 0.0, 0.0);// Стойка на входе
	CreateDynamicObject(1257, -151.62790, 1189.71118, 19.97020, 0.0, 0.0, 270.0);// Остановка
	CreateDynamicObject(1257, -155.70941, 1207.22339, 19.97020, 0.0, 0.0, 90.0);// Остановка через дорогу

	// Сеновал (interior)
	CreateDynamicObject(14873, 287.62, 304.94, 998.97, 4.00, 0.00, 183.00);
	CreateDynamicObject(14875, 285.85, 307.14, 998.97, -4.00, 0.00, 3.00);
	CreateDynamicObject(14875, 282.77, 308.71, 998.97, -4.00, 0.00, 93.00);
	CreateDynamicObject(14875, 288.06, 307.74, 998.97, 4.00, 0.00, 183.00);

	// Оформление бара (Ten Green Bottles)
	CreateDynamicObject(18649, -180.49060, 1087.26978, 22.14450, 0.0, 0.0, 0.0);
	CreateDynamicObject(18649, -179.35516, 1088.31384, 22.14450, 0.0, 0.0, 90.0);
	CreateDynamicObject(17579, -181.36549, 1079.97449, 26.31940, 0.0, 0.0, 270.0);
	CreateDynamicObject(17579, -168.90109, 1080.51074, 26.31940, 0.0, 0.0, 90.0);
	CreateDynamicObject(19123, -180.70500, 1086.00806, 19.28180, 0.0, 0.0, 0.0);
	CreateDynamicObject(19123, -178.25505, 1088.53210, 19.28180, 0.0, 0.0, 0.0);
	CreateDynamicObject(19123, -169.75797, 1088.54053, 19.28180, 0.0, 0.0, 0.0);
	CreateDynamicObject(19123, -180.81845, 1072.30737, 19.28180, 0.0, 0.0, 0.0);

	// Бензоколонка
	CreateDynamicObject(13296, -120.30, 1004.97, 21.97, 0.00, 0.00, 90.00);
	CreateDynamicObject(3187, -102.01, 1045.92, 22.76, 0.00, 0.00, 184.00);
	CreateDynamicObject(1686, -114.60, 1008.14, 18.91, 0.00, 0.00, 0.00);
	CreateDynamicObject(1686, -114.60, 1003.45, 18.91, 0.00, 0.00, 0.00);
	CreateDynamicObject(970, -114.08, 1008.14, 19.45, 0.00, 0.00, 90.00);
	CreateDynamicObject(970, -115.15, 1008.14, 19.45, 0.00, 0.00, 90.00);
	CreateDynamicObject(970, -115.15, 1003.48, 19.45, 0.00, 0.00, 90.00);
	CreateDynamicObject(970, -114.08, 1003.48, 19.45, 0.00, 0.00, 90.00);
	CreateDynamicObject(19448, -125.60, 1014.07, 18.77, 0.00, 90.00, 90.00);
	CreateDynamicObject(691, -87.68, 999.41, 17.97, 356.86, 0.00, -0.86);
	CreateDynamicObject(691, -123.92, 1035.52, 17.97, 356.86, 0.00, -0.86);
	CreateDynamicObject(774, -136.95, 1003.08, 18.63, 0.00, 0.00, 55.00);
	CreateDynamicObject(780, -140.61, 1038.52, 16.60, 356.86, 0.00, -2.27);
	CreateDynamicObject(12957, -131.70, 1017.26, 19.39, 0.00, 0.00, 338.00);

	// Старая бензоколонка
	/*CreateDynamicObject(1686, 73.81, 1219.41, 18.08, 0.00, 0.00, 164.00);
	CreateDynamicObject(1686, 67.91, 1220.93, 18.08, 0.00, 0.00, 164.00);
	CreateDynamicObject(970, 74.04, 1218.06, 18.66, 0.00, 0.00, 75.00);
	CreateDynamicObject(970, 73.07, 1218.27, 18.66, 0.00, 0.00, 75.00);
	CreateDynamicObject(970, 68.16, 1219.52, 18.66, 0.00, 0.00, 75.00);
	CreateDynamicObject(970, 67.12, 1219.90, 18.66, 0.00, 0.00, 75.00);*/

	// Новая Ж/Д Станция //
	// Ограничение к рельсам
	CreateDynamicObject(1423, -212.81078, 1262.32654, 24.12070, 0.0, 0.0, 10.47100);
	CreateDynamicObject(1423, -186.14030, 1266.28516, 22.77760, 0.0, 4.0, 6.71970);
	CreateDynamicObject(1423, -162.43208, 1269.08594, 20.98480, 0.0, 4.0, 5.71063);
	CreateDynamicObject(1423, -138.25580, 1272.07654, 19.45470, 0.0, 4.0, 4.45880);
	// Платформа
	CreateDynamicObject(19378, 123.78580, 1268.08325, 22.0, 0.0, 90.0, 342.25980);
	CreateDynamicObject(19378, 133.60001, 1264.80005, 22.0, 0.0, 90.0, 340.74731);
	CreateDynamicObject(19378, 143.41350, 1261.28467, 22.0, 0.0, 90.0, 339.81360);
	CreateDynamicObject(19378, 153.05231, 1257.56018, 22.0, 0.0, 90.0, 337.87921);
	CreateDynamicObject(19378, 162.69000, 1253.56995, 22.0, 0.0, 90.0, 337.10379);
	CreateDynamicObject(19378, 172.28380, 1249.45496, 22.0, 0.0, 90.0, 336.44019);
	// Боковые стенки
	CreateDynamicObject(19458, 118.70160, 1269.71863, 20.33690, 0.0, 0.0, 342.25980);
	CreateDynamicObject(19458, 177.17999, 1247.34998, 20.33690, 180.0, 0.0, 336.44019);
	// Передние стенки
	CreateDynamicObject(19458, 124.82300, 1272.74963, 20.33690, 0.0, 0.0, 252.25980);
	CreateDynamicObject(19458, 133.95450, 1269.69934, 20.33690, 0.0, 0.0, 250.74730);
	CreateDynamicObject(19458, 143.02570, 1266.50330, 20.32690, 0.0, 0.0, 250.18359);
	CreateDynamicObject(19458, 152.02670, 1263.09399, 20.32690, 0.0, 0.0, 248.19920);
	CreateDynamicObject(19458, 160.94370, 1259.45959, 20.32690, 0.0, 0.0, 247.39290);
	CreateDynamicObject(19366, 166.87000, 1256.98499, 20.32690, 0.0, 0.0, 247.10381);
	CreateDynamicObject(19458, 172.75960, 1254.43628, 20.32690, 0.0, 0.0, 246.44020);
	CreateDynamicObject(19366, 177.52000, 1252.35999, 20.32690, 0.0, 0.0, 246.44020);
	// Задние стенки
	CreateDynamicObject(19458, 121.92300, 1263.74963, 20.33690, 0.0, 0.0, 252.25980);
	CreateDynamicObject(19458, 131.05450, 1260.69934, 20.33690, 0.0, 0.0, 250.74730);
	CreateDynamicObject(19458, 140.12570, 1257.50330, 20.32690, 0.0, 0.0, 250.18359);
	CreateDynamicObject(19458, 149.12669, 1254.09399, 20.32690, 0.0, 0.0, 248.19920);
	CreateDynamicObject(19458, 158.04370, 1250.45959, 20.32690, 0.0, 0.0, 247.39290);
	CreateDynamicObject(19366, 163.87000, 1247.98499, 20.32690, 0.0, 0.0, 247.10381);
	CreateDynamicObject(19366, 173.82001, 1243.66016, 20.32690, 0.0, 0.0, 246.44020);
	CreateDynamicObject(19458, 169.75960, 1245.43628, 20.32690, 0.0, 0.0, 246.44020);
	// Забор
	CreateDynamicObject(1419, 178.08220, 1249.86743, 22.60000, 0.0, 0.0, 246.44020);
	CreateDynamicObject(1419, 176.93411, 1247.24939, 22.60000, 0.0, 0.0, 246.44020);
	CreateDynamicObject(1419, 175.95500, 1245.00500, 22.60000, 0.0, 0.0, 246.44020);
	CreateDynamicObject(1419, 173.29207, 1243.90491, 22.60000, 0.0, 0.0, 156.44020);
	CreateDynamicObject(1419, 169.54585, 1245.53003, 22.60000, 0.0, 0.0, 156.44020);
	CreateDynamicObject(1419, 165.78687, 1247.15601, 22.60000, 0.0, 0.0, 156.84019);
	CreateDynamicObject(1419, 162.02000, 1248.76001, 22.60000, 0.0, 0.0, 157.10381);
	CreateDynamicObject(1419, 158.24855, 1250.35315, 22.60000, 0.0, 0.0, 157.10381);
	CreateDynamicObject(1419, 154.46831, 1251.92676, 22.60000, 0.0, 0.0, 157.87920);
	CreateDynamicObject(1419, 150.69234, 1253.45715, 22.60000, 0.0, 0.0, 157.87920);
	CreateDynamicObject(1419, 146.91141, 1254.98230, 22.60000, 0.0, 0.0, 158.57919);
	CreateDynamicObject(1419, 143.09283, 1256.42688, 22.60000, 0.0, 0.0, 159.81360);
	CreateDynamicObject(1419, 139.26445, 1257.82617, 22.60000, 0.0, 0.0, 159.81360);
	CreateDynamicObject(1419, 135.41188, 1259.18677, 22.60000, 0.0, 0.0, 160.74730);
	CreateDynamicObject(1419, 131.56172, 1260.53845, 22.60000, 0.0, 0.0, 160.74730);
	CreateDynamicObject(1419, 127.68767, 1261.87439, 22.60000, 0.0, 0.0, 161.34731);
	CreateDynamicObject(1419, 123.80873, 1263.14111, 22.60000, 0.0, 0.0, 162.25980);
	CreateDynamicObject(1419, 119.73286, 1272.21313, 22.60000, 0.0, 0.0, 252.25980);
	CreateDynamicObject(1419, 118.86000, 1269.47998, 22.60000, 0.0, 0.0, 252.25980);
	CreateDynamicObject(1419, 118.09602, 1267.12622, 22.60000, 0.0, 0.0, 252.25980);
	// Крыша платформы
	CreateDynamicObject(13206, 128.46248, 1266.05042, 21.97960, 0.0, 0.0, 341.37979);
	CreateDynamicObject(13206, 166.17725, 1251.56104, 21.97960, 0.0, 0.0, 336.44019);
	CreateDynamicObject(13206, 147.40836, 1259.34192, 21.97960, 0.0, 0.0, 338.38934);
	// Веранда платформы
	CreateDynamicObject(19378, 120.91680, 1259.13647, 21.0, 0.0, 90.0, 342.25980);
	CreateDynamicObject(19458, 115.83031, 1260.75366, 19.33690, 0.0, 0.0, 342.25980);
	CreateDynamicObject(19458, 119.06003, 1254.74731, 19.33690, 0.0, 0.0, 252.25980);
	CreateDynamicObject(19366, 122.94602, 1253.50928, 19.33690, 0.0, 0.0, 252.25980);
	CreateDynamicObject(19458, 126.02983, 1257.48560, 19.33690, 0.0, 0.0, 342.25980);
	CreateDynamicObject(19366, 116.41688, 1254.84888, 18.99280,   121.0, 0.0, 342.0);
	CreateDynamicObject(19366, 121.10676, 1253.44336, 18.99280,   121.0, 0.0, 342.0);
	CreateDynamicObject(14387, 118.52750, 1253.41553, 20.12860, 0.0, 0.0, 252.0);// Лестница
	// Забор веранды
	CreateDynamicObject(1419, 116.83370, 1263.02795, 21.60000, 0.0, 0.0, 72.25980);
	CreateDynamicObject(1419, 115.57247, 1259.14343, 21.60000, 0.0, 0.0, 72.25980);
	CreateDynamicObject(1419, 126.49893, 1259.95715, 21.60000, 0.0, 0.0, 72.25980);
	CreateDynamicObject(1419, 125.24232, 1256.07593, 21.60000, 0.0, 0.0, 72.25980);
	// Уличные лампы
	CreateDynamicObject(1223, 137.35310, 1258.78821, 21.80000, 0.0, 0.0, 70.0);
	CreateDynamicObject(1223, 156.05930, 1251.51746, 21.80000, 0.0, 0.0, 67.0);
	CreateDynamicObject(1223, 174.32770, 1243.73926, 21.80000, 0.0, 0.0, 99.0);
	CreateDynamicObject(1223, 117.75500, 1265.36426, 21.80000, 0.0, 0.0, 36.0);
	CreateDynamicObject(1223, 111.33818, 1247.54590, 19.48440, 0.0, 0.0, 340.0);
	CreateDynamicObject(1223, 108.17715, 1237.97107, 19.48440, 0.0, 0.0, 340.0);
	CreateDynamicObject(1223, 122.02874, 1244.26318, 19.48440, 0.0, 0.0, 160.0);
	CreateDynamicObject(1223, 119.17995, 1234.50879, 19.48440, 0.0, 0.0, 160.0);
	// Скамейки
	CreateDynamicObject(1256, 132.29924, 1261.30066, 22.75000, 0.0, 0.0, 250.74730);
	CreateDynamicObject(1256, 127.71980, 1262.87634, 22.75000, 0.0, 0.0, 251.0);
	CreateDynamicObject(1256, 123.60004, 1264.22375, 22.75000, 0.0, 0.0, 252.25980);
	CreateDynamicObject(1256, 142.42410, 1257.66211, 22.75000, 0.0, 0.0, 249.81360);
	CreateDynamicObject(1256, 146.64369, 1256.10425, 22.75000, 0.0, 0.0, 249.81360);
	CreateDynamicObject(1256, 150.84583, 1254.40967, 22.75000, 0.0, 0.0, 247.87920);
	CreateDynamicObject(1256, 161.23058, 1250.12866, 22.75000, 0.0, 0.0, 247.10381);
	CreateDynamicObject(1256, 165.23584, 1248.43774, 22.75000, 0.0, 0.0, 247.10381);
	CreateDynamicObject(1256, 169.50439, 1246.57715, 22.75000, 0.0, 0.0, 246.44020);
	// Мусорки
	CreateDynamicObject(1359, 129.99524, 1262.10120, 22.75000, 0.0, 0.0, 0.0);
	CreateDynamicObject(1359, 125.62533, 1263.57617, 22.75000, 0.0, 0.0, 0.0);
	CreateDynamicObject(1359, 144.52715, 1256.84497, 22.75000, 0.0, 0.0, 0.0);
	CreateDynamicObject(1359, 148.69376, 1255.22046, 22.75000, 0.0, 0.0, 0.0);
	CreateDynamicObject(1359, 163.17111, 1249.28503, 22.75000, 0.0, 0.0, 0.0);
	CreateDynamicObject(1359, 167.38722, 1247.49609, 22.75000, 0.0, 0.0, 0.0);
	// Остальное
	CreateDynamicObject(1216, 137.74072, 1259.72922, 22.69682, 0.0, 0.0, 160.0);// Телефонная будка
	CreateDynamicObject(1216, 156.33980, 1252.27234, 22.69680, 0.0, 0.0, 157.0);// Телефонная будка
	CreateDynamicObject(1472, 118.66722, 1264.81622, 21.4906, 0.0, 0.0, 342.25980);// Лестница лев
	CreateDynamicObject(1472, 120.09945, 1264.35962, 21.4906, 0.0, 0.0, 342.25980);// Лестница пр
	CreateDynamicObject(1487, 133.84348, 1260.71667, 22.28000, 0.0, 0.0, 0.0);// Бутылка
	CreateDynamicObject(2670, 125.61089, 1264.19751, 22.17720, 0.0, 0.0, 0.0);// Мусор
	CreateDynamicObject(2673, 148.99686, 1255.62256, 22.16720, 0.0, 0.0, 112.0);// Мусор
	CreateDynamicObject(2674, 163.97737, 1249.66943, 22.09720, 0.0, 0.0, 287.0);// Мусор
	CreateDynamicObject(715, 185.70564, 1240.47131, 19.88080, 0.0, 0.0, 17.42634);// Листва
	CreateDynamicObject(715, 141.34074, 1248.80103, 18.75948, 0.0, 0.0, 28.89493);// Листва
	CreateDynamicObject(1340, 123.33475, 1255.80029, 22.09480, 0.0, 0.0, -193.0);// Хотдог
	CreateDynamicObject(1571, 123.27260, 1260.40310, 22.35096, 0.0, 0.0, 305.57715);// Будка
	CreateDynamicObject(19121, 121.58185, 1254.06055, 21.55440, 0.0, 0.0, 0.0);// Столбик с белым
	CreateDynamicObject(19121, 116.39557, 1255.75745, 21.55440, 0.0, 0.0, 0.0);// Столбик с белым
	CreateDynamicObject(11547, 135.47525, 1233.79077, 21.69400, 0.0, 0.0, 70.0);// Парковка
	CreateDynamicObject(16020, 116.26524, 1245.51990, 20.25111, 0.0, 0.0, 70.13067);// Ограждение дорожки

	// Коробки на складе
	CreateDynamicObject(1299, -109.30, 1135.14, 19.18, 0.00, 0.00, 0.00);
	CreateDynamicObject(1431, -108.09, 1138.60, 19.28, 0.00, 0.00, 84.00);
	CreateDynamicObject(1438, -113.52, 1139.27, 18.74, 0.00, 0.00, 236.00);
	CreateDynamicObject(2991, -111.93, 1127.14, 19.33, 0.00, 0.00, 0.00);
	CreateDynamicObject(2991, -108.92, 1131.52, 20.57, 0.00, 0.00, 0.00);
	CreateDynamicObject(2991, -108.92, 1131.52, 19.33, 0.00, 0.00, 0.00);
	CreateDynamicObject(2991, -111.93, 1127.14, 20.59, 0.00, 0.00, 0.00);
	CreateDynamicObject(1438, -108.00, 1129.47, 18.74, 0.00, 0.00, 135.00);
	CreateDynamicObject(1299, -113.72, 1130.43, 19.18, 0.00, 0.00, 0.00);
	CreateDynamicObject(1299, -111.54, 1134.32, 19.18, 0.00, 0.00, 0.00);
	CreateDynamicObject(2991, -113.48, 1135.66, 19.33, 0.00, 0.00, 90.00);
	CreateDynamicObject(1438, -113.41, 1135.63, 19.96, 0.00, 0.00, 88.00);
	CreateDynamicObject(1299, -109.24, 1122.61, 19.18, 0.00, 0.00, 0.00);
	CreateDynamicObject(1299, -113.97, 1122.74, 19.18, 0.00, 0.00, 0.00);
	CreateDynamicObject(1299, -111.43, 1121.74, 19.18, 0.00, 0.00, 0.00);

	// Фонари
	CreateDynamicObject(1294, 49.14, 1193.64, 22.37, 0.00, 0.00, 270.00);
	CreateDynamicObject(1294, 49.14, 1202.88, 22.37, 0.00, 0.00, 90.00);
	CreateDynamicObject(1294, 21.49, 1193.67, 22.57, 0.00, 0.00, 270.00);
	CreateDynamicObject(1294, 21.21, 1202.88, 22.66, 0.00, 0.00, 90.00);
	CreateDynamicObject(1294, 0.68, 1193.64, 22.81, 0.00, 0.00, 270.00);
	CreateDynamicObject(1294, -11.13, 1202.88, 22.76, 0.00, 0.00, 90.00);
	CreateDynamicObject(1294, -37.44, 1202.88, 22.81, 0.00, 0.00, 90.00);

	// Озеро
	CreateDynamicObject(1568, -1382.43079, 2118.15820, 38.58600, 0.0, 0.0, 0.0);// Фонари
	CreateDynamicObject(1568, -1371.52490, 2108.45581, 38.58600, 0.0, 0.0, 0.0);// Фонари
	CreateDynamicObject(745, -1362.64319, 2146.71484, 41.28487, 0.0, 0.0, 321.26920);// Камень
	CreateDynamicObject(762, -1397.11572, 2145.74976, 45.35224, 0.0, 0.0, 12.16715);// Кусты
	CreateDynamicObject(1461, -1384.01062, 2115.68042, 41.93030, 0.0, 0.0, 45.0);// Спас круг
	CreateDynamicObject(872, -1386.06628, 2118.89160, 38.14475, 0.0, 0.0, 0.0);// Трава всякая
	CreateDynamicObject(872, -1388.38611, 2123.79297, 38.14475, 0.0, 0.0, 0.0);//
	CreateDynamicObject(872, -1389.67261, 2128.43628, 38.14475, 0.0, 0.0, 0.0);//
	CreateDynamicObject(872, -1388.45007, 2131.64014, 38.14475, 0.0, 0.0, 0.0);//
	CreateDynamicObject(872, -1386.66528, 2135.97217, 38.14475, 0.0, 0.0, 0.0);//
	CreateDynamicObject(872, -1383.51855, 2138.86719, 38.14475, 0.0, 0.0, 0.0);//
	CreateDynamicObject(872, -1379.64282, 2140.14209, 38.14475, 0.0, 0.0, 0.0);//
	CreateDynamicObject(872, -1375.30103, 2139.72754, 38.14475, 0.0, 0.0, 0.0);//
	CreateDynamicObject(872, -1370.91858, 2138.94263, 38.14475, 0.0, 0.0, 0.0);//
	CreateDynamicObject(872, -1366.92676, 2138.65649, 38.14475, 0.0, 0.0, 0.0);//
	CreateDynamicObject(872, -1368.42493, 2102.54614, 39.04456, 0.0, 0.0, 0.0);//
	CreateDynamicObject(855, -1366.37085, 2099.98853, 40.34222, 0.0, 0.0, 0.0);//
	CreateDynamicObject(872, -1365.24390, 2097.77563, 39.04456, 0.0, 0.0, 0.0);//
	CreateDynamicObject(872, -1361.53076, 2094.23657, 39.04456, 0.0, 0.0, 0.0);//
	CreateDynamicObject(872, -1357.90771, 2092.59985, 39.04456, 0.0, 0.0, 0.0);//
	CreateDynamicObject(855, -1362.47339, 2095.80981, 40.34222, 0.0, 0.0, 0.0);//
	CreateDynamicObject(855, -1389.59644, 2124.80688, 40.34222, 0.0, 0.0, 0.0);//
	CreateDynamicObject(855, -1384.78638, 2136.10596, 40.34222, 0.0, 0.0, 0.0);//

	// Озеленение
	CreateDynamicObject(715, -235.16461, 1258.22168, 21.90908, 0.0, 0.0, 2.32610);// Кусты возле станции
	CreateDynamicObject(669, -244.91385, 1252.75525, 23.73347, 0.0, 0.0, 356.91791);// Дерево возле жд
	CreateDynamicObject(669, -205.82988, 1254.32825, 22.43471, 0.0, 0.0, 356.91791);//
	CreateDynamicObject(669, -171.51048, 1259.02380, 20.64790, 0.0, 0.0, 356.91791);//
	CreateDynamicObject(874, -285.33047, 1211.22156, 18.81790, 0.0, 0.0, 31.09136);// Трава около дома с гаражом
	CreateDynamicObject(874, -290.79523, 1205.99414, 18.81790, 0.0, 0.0, 31.09136);//
	CreateDynamicObject(874, -300.43326, 1207.37842, 18.81790, 0.0, 0.0, 31.09136);//
	CreateDynamicObject(874, -296.26712, 1214.15552, 18.81790, 0.0, 0.0, 31.09136);//
	CreateDynamicObject(874, -309.48242, 1207.48999, 18.81790, 0.0, 0.0, 31.09136);//
	CreateDynamicObject(858, -344.08197, 1224.40283, 20.10381, 0.0, 0.0, 0.0);// Мини деревце возле дома с гаражом
	CreateDynamicObject(858, -337.32129, 1234.07788, 21.80321, 0.0, 0.0, 0.0);//
	CreateDynamicObject(858, -333.26785, 1226.34827, 19.99230, 0.0, 0.0, 0.0);//
	CreateDynamicObject(858, -325.79181, 1226.89673, 18.87655, 0.0, 0.0, 0.0);//
	CreateDynamicObject(858, -315.39105, 1218.70862, 18.38843, 0.0, 0.0, 0.0);//
	CreateDynamicObject(858, -322.64905, 1219.68787, 18.25715, 0.0, 0.0, 0.0);//
	CreateDynamicObject(858, -325.13596, 1235.28247, 21.37436, 0.0, 0.0, 0.0);//
	CreateDynamicObject(858, -313.83813, 1232.60449, 19.50004, 0.0, 0.0, 0.0);//
	CreateDynamicObject(858, -309.03894, 1223.70410, 18.44213, 0.0, 0.0, 0.0);//
	CreateDynamicObject(858, -318.67914, 1227.42688, 18.51888, 0.0, 0.0, 0.0);//
	CreateDynamicObject(858, -335.28363, 1218.65662, 19.17118, 0.0, 0.0, 0.0);//
	CreateDynamicObject(858, -317.76089, 1236.80981, 21.34532, 0.0, 0.0, 0.0);//
	CreateDynamicObject(856, -290.62463, 1001.51996, 17.85985, 0.0, 0.0, 0.0);// Кусты возле больницы
	CreateDynamicObject(856, -297.96857, 1003.52728, 17.85985, 0.0, 0.0, 0.0);//
	obj = CreateDynamicObject(856, -293.55014, 1005.89490, 17.85985, 0.0, 0.0, 0.0);//
	return obj;
}

// Лос Сантос Банк / Los Santos Bank (interior)
BankLS_CreateObjects()
{
	//CreateDynamicObject(1252, 2144.64551, 1626.87402, 994.20001, 0.0, -18.0, 0.0); // Bomb on the metal door
	CreateDynamicObject(19799, 2143.18628, 1627.04724, 994.25922, 0.0, 0.0, 180.0);// Turn to 240 to open
	CreateDynamicObject(19388, 2135.60010, 1609.40002, 994.20001, 0.0, 0.0, 0.0);
	CreateDynamicObject(19450, 2151.10010, 1617.50000, 994.20001, 0.0, 0.0, 0.0);
	CreateDynamicObject(19466, 2135.60010, 1620.0, 994.29138, 0.0, 0.0, 0.0);
	CreateDynamicObject(14799, 2141.10010, 1622.69995, 994.59998, 0.0, 0.0, 90.0);
	CreateDynamicObject(19431, 2150.22290, 1622.30005, 992.0, 0.0, 0.0, 90.0);
	CreateDynamicObject(19435, 2138.09985, 1622.87720, 993.72839, 0.0, 90.0, 0.0);
	CreateDynamicObject(19859, 2142.77490, 1606.69995, 993.79492, 0.0, 0.0, 0.0);
	CreateDynamicObject(19859, 2144.29712, 1606.69995, 995.04999, 0.0, 270.0, 0.0);
	CreateDynamicObject(19859, 2145.73950, 1606.69995, 993.79492, 0.0, 0.0, 180.0);
	CreateDynamicObject(1744, 2137.69995, 1622.39001, 993.0, 0.0, 0.0, 0.0);
	CreateDynamicObject(1778, 2154.02295, 1612.65137, 992.54999, 0.0, 0.0, 0.0);
	CreateDynamicObject(19450, 2144.60010, 1622.30005, 992.0, 0.0, 0.0, 90.0);
	CreateDynamicObject(19358, 2138.19995, 1622.30005, 992.0, 0.0, 0.0, 90.0);
	CreateDynamicObject(19435, 2141.59985, 1622.87720, 993.72839, 0.0, 90.0, 0.0);
	CreateDynamicObject(19435, 2145.09985, 1622.87720, 993.72839, 0.0, 90.0, 0.0);
	CreateDynamicObject(19435, 2148.59985, 1622.87720, 993.72839, 0.0, 90.0, 0.0);
	CreateDynamicObject(14799, 2145.60010, 1622.69995, 994.59998, 0.0, 0.0, 90.0);
	CreateDynamicObject(1703, 2136.37012, 1613.90002, 992.52368, 0.0, 0.0, 90.0);
	CreateDynamicObject(2000, 2130.27710, 1622.50342, 992.54999, 0.0, 0.0, 90.0);
	CreateDynamicObject(2001, 2137.22241, 1617.52600, 992.55988, 0.0, 0.0, 0.0);
	CreateDynamicObject(2002, 2138.73291, 1607.47815, 992.55988, 0.0, 0.0, 180.0);
	CreateDynamicObject(2006, 2144.44531, 1622.52502, 994.38562, 0.0, 0.0, 0.0);
	CreateDynamicObject(2007, 2130.15625, 1618.57056, 992.54999, 0.0, 0.0, 90.0);
	CreateDynamicObject(2008, 2130.17993, 1620.22424, 992.54999, 0.0, 0.0, 90.0);
	CreateDynamicObject(1808, 2137.80786, 1626.64404, 992.54999, 0.0, 0.0, 360.0);
	CreateDynamicObject(2202, 2139.00146, 1626.38013, 992.54999, 0.0, 0.0, 0.0);
	CreateDynamicObject(2167, 2141.69629, 1626.71387, 992.54999, 0.0, 0.0, 0.0);
	CreateDynamicObject(2164, 2135.75049, 1626.78894, 992.54999, 0.0, 0.0, 0.0);
	CreateDynamicObject(2190, 2138.27710, 1622.60327, 993.81458, 0.0, 0.0, 180.0);
	CreateDynamicObject(19807, 2136.88989, 1622.89368, 993.90979, 0.0, 0.0, 160.0);
	CreateDynamicObject(11728, 2142.90112, 1626.81689, 994.40002, 0.0, 0.0, 0.0);
	CreateDynamicObject(2197, 2150.81030, 1625.31201, 992.54999, 0.0, 0.0, -0.06000);
	CreateDynamicObject(2200, 2147.59326, 1626.70178, 992.54999, 0.0, 0.0, -0.06000);
	CreateDynamicObject(19431, 2135.60010, 1622.50000, 994.20001, 0.0, 0.0, 0.0);
	CreateDynamicObject(19404, 2135.60010, 1620.09998, 994.20001, 0.0, 0.0, 0.0);
	CreateDynamicObject(2190, 2140.57715, 1622.60327, 993.81458, 0.0, 0.0, 180.0);
	CreateDynamicObject(2190, 2142.77710, 1622.60327, 993.81458, 0.0, 0.0, 180.0);
	CreateDynamicObject(2190, 2145.07715, 1622.60327, 993.81458, 0.0, 0.0, 180.0);
	CreateDynamicObject(2190, 2147.27710, 1622.60327, 993.81458, 0.0, 0.0, 180.0);
	CreateDynamicObject(2190, 2149.47705, 1622.60327, 993.81458, 0.0, 0.0, 180.0);
	CreateDynamicObject(1806, 2137.06958, 1624.36987, 992.54999, 0.0, 0.0, 214.0);
	CreateDynamicObject(1806, 2139.47241, 1624.36523, 992.54999, 0.0, 0.0, 188.0);
	CreateDynamicObject(1806, 2141.27344, 1624.36230, 992.54999, 0.0, 0.0, 244.0);
	CreateDynamicObject(1806, 2143.31177, 1624.40125, 992.54999, 0.0, 0.0, 200.0);
	CreateDynamicObject(1806, 2149.65015, 1624.36292, 992.54999, 0.0, 0.0, 152.0);
	CreateDynamicObject(1806, 2146.33838, 1624.50220, 992.54999, 0.0, 0.0, 178.0);
	CreateDynamicObject(19431, 2135.60010, 1607.0, 994.20001, 0.0, 0.0, 0.0);
	CreateDynamicObject(19431, 2135.60010, 1611.80005, 994.20001, 0.0, 0.0, 0.0);
	CreateDynamicObject(19404, 2135.60010, 1615.0, 994.20001, 0.0, 0.0, 0.0);
	CreateDynamicObject(19431, 2135.60010, 1612.59998, 994.20001, 0.0, 0.0, 0.0);
	CreateDynamicObject(19431, 2135.60010, 1617.69995, 994.20001, 0.0, 0.0, 0.0);
	CreateDynamicObject(19431, 2135.60010, 1617.40002, 994.20001, 0.0, 0.0, 0.0);
	CreateDynamicObject(19466, 2135.60010, 1615.0, 994.29138, 0.0, 0.0, 0.0);
	CreateDynamicObject(1703, 2136.37012, 1619.0, 992.52368, 0.0, 0.0, 90.0);
	CreateDynamicObject(2001, 2137.21411, 1612.26294, 992.55988, 0.0, 0.0, 0.0);
	CreateDynamicObject(1998, 2130.11792, 1625.28772, 992.54999, 0.0, 0.0, 0.0);
	CreateDynamicObject(2008, 2130.17993, 1616.02417, 992.54999, 0.0, 0.0, 90.0);
	CreateDynamicObject(2008, 2130.17993, 1611.52417, 992.54999, 0.0, 0.0, 90.0);
	CreateDynamicObject(1998, 2131.13770, 1607.25989, 992.54999, 0.0, 0.0, 90.0);
	CreateDynamicObject(19859, 2135.62695, 1608.67505, 993.75000, 0.0, 0.0, 90.0);
	CreateDynamicObject(1791, 2150.14478, 1612.24536, 996.13092, 14.0, 0.0, 270.0);
	CreateDynamicObject(1791, 2150.24634, 1617.42554, 996.13092, 14.0, 0.0, 270.0);
	CreateDynamicObject(1886, 2130.03345, 1626.44580, 997.79523, 12.0, 0.0, 45.0);
	CreateDynamicObject(1886, 2149.25952, 1623.08008, 997.79523, 22.0, 0.0, 232.0);
	CreateDynamicObject(1886, 2130.90503, 1608.40991, 997.79523, 12.0, 0.0, 135.0);
	CreateDynamicObject(1886, 2150.70483, 1610.96106, 997.79523, 20.0, 0.0, 301.0);
	CreateDynamicObject(1744, 2141.19995, 1622.39001, 993.0, 0.0, 0.0, 0.0);
	CreateDynamicObject(1744, 2144.69995, 1622.39001, 993.0, 0.0, 0.0, 0.0);
	CreateDynamicObject(1744, 2148.19995, 1622.39001, 993.0, 0.0, 0.0, 0.0);
	CreateDynamicObject(19388, 2155.50000, 1612.80005, 994.20001, 0.0, 0.0, 90.0);
	CreateDynamicObject(19358, 2152.30005, 1612.80005, 994.20001, 0.0, 0.0, 90.0);
	CreateDynamicObject(19358, 2158.69995, 1612.80005, 994.20001, 0.0, 0.0, 90.0);
	CreateDynamicObject(1500, 2154.69824, 1612.82971, 992.45001, 0.0, 0.0, 0.0);
	CreateDynamicObject(19359, 2155.35718, 1613.18201, 993.20001, 0.0, 0.0, 90.0);
	CreateDynamicObject(1703, 2150.37012, 1615.90002, 992.52368, 0.0, 0.0, 270.0);
	CreateDynamicObject(1703, 2150.37012, 1621.0, 992.52368, 0.0, 0.0, 270.0);
	CreateDynamicObject(2001, 2149.72241, 1617.52600, 992.55988, 0.0, 0.0, 0.0);
	CreateDynamicObject(2001, 2149.71411, 1612.26294, 992.55988, 0.0, 0.0, 0.0);
	CreateDynamicObject(2202, 2130.12524, 1613.76880, 992.54999, 0.0, 0.0, 90.0);
	CreateDynamicObject(2164, 2129.64868, 1609.44336, 992.54999, 0.0, 0.0, 90.0);
	CreateDynamicObject(1806, 2131.57617, 1625.27527, 992.54999, 0.0, 0.0, 69.0);
	CreateDynamicObject(1806, 2131.18457, 1621.21594, 992.54999, 0.0, 0.0, 91.0);
	CreateDynamicObject(1806, 2130.93140, 1616.96143, 992.54999, 0.0, 0.0, 91.0);
	CreateDynamicObject(1806, 2131.18457, 1608.58618, 992.54999, 0.0, 0.0, 145.0);
	CreateDynamicObject(1806, 2130.96680, 1612.26770, 992.54999, 0.0, 0.0, 69.0);
	CreateDynamicObject(2202, 2151.54175, 1626.32715, 992.54999, 0.0, 0.0, 0.0);
	CreateDynamicObject(2164, 2155.16138, 1626.79468, 992.54999, 0.0, 0.0, 0.0);
	CreateDynamicObject(19388, 2155.50000, 1622.30005, 994.20001, 0.0, 0.0, 90.0);
	CreateDynamicObject(19358, 2152.30005, 1622.30005, 994.20001, 0.0, 0.0, 90.0);
	CreateDynamicObject(19358, 2158.69995, 1622.30005, 994.20001, 0.0, 0.0, 90.0);
	CreateDynamicObject(1500, 2156.25293, 1622.26746, 992.45001, 0.0, 0.0, 180.0);
	CreateDynamicObject(19359, 2155.32202, 1621.88318, 993.20001, 0.0, 0.0, 90.0);
	CreateDynamicObject(2007, 2158.46118, 1611.22583, 992.54999, 0.0, 0.0, 270.0);
	CreateDynamicObject(2007, 2158.46118, 1609.72583, 992.54999, 0.0, 0.0, 270.0);
	CreateDynamicObject(2007, 2158.46118, 1608.22583, 992.54999, 0.0, 0.0, 270.0);
	CreateDynamicObject(2011, 2157.88281, 1612.24084, 992.54999, 0.0, 0.0, 270.0);
	CreateDynamicObject(2256, 2158.73804, 1609.66211, 995.20001, 0.0, 0.0, 270.0);
	CreateDynamicObject(2262, 2149.56763, 1612.38196, 994.90002, 0.0, 0.0, 270.0);
	CreateDynamicObject(2261, 2149.56299, 1617.56311, 994.90002, 0.0, 0.0, 270.0);
	CreateDynamicObject(0, 2147.51538, 1604.74182, 1002.20001, 0.0, 0.0, 0.0);
	CreateDynamicObject(19859, 2148.53833, 1604.74182, 1003.45001, 0.0, 270.0, 0.0);
	CreateDynamicObject(2986, 2144.0, 1623.14819, 997.53003, 0.0, 0.0, 90.0);
	obj = CreateDynamicObject(2986, 2156.22192, 1624.73193, 997.53003, 0.0, 0.0, 90.0);
	return obj;
}

// Парковка таксоматорного парка
Taxi_CreateObjects()
{
	CreateDynamicObject(982, 1059.24744, -1748.57275, 13.22080, 0.0, 0.0, 0.0);
	CreateDynamicObject(982, 1059.23230, -1774.15588, 13.22080, 0.0, 0.0, 0.0);
	CreateDynamicObject(983, 1059.21631, -1790.15137, 13.16660, 0.0, 0.0, 0.0);
	CreateDynamicObject(983, 1059.24707, -1802.93872, 13.21660, 0.0, 0.0, 0.0);
	CreateDynamicObject(982, 1072.04065, -1806.14795, 13.22080, 0.0, 0.0, 90.0);
	CreateDynamicObject(982, 1072.04932, -1735.78333, 13.22080, 0.0, 0.0, 90.0);
	CreateDynamicObject(982, 1097.65088, -1735.77942, 13.22080, 0.0, 0.0, 90.0);
	CreateDynamicObject(982, 1106.73743, -1763.71155, 13.22080, 0.0, 0.0, 0.0);
	CreateDynamicObject(983, 1106.74158, -1779.71765, 13.22080, 0.0, 0.0, 0.0);
	CreateDynamicObject(967, 1105.99414, -1750.13403, 12.47080, 0.0, 0.0, 0.0);
	CreateDynamicObject(1360, 1059.20874, -1796.51904, 13.40190, 0.0, 0.0, 0.0);
	CreateDynamicObject(19121, 1059.21570, -1799.60315, 13.18020, 0.0, 0.0, 0.0);
	CreateDynamicObject(19121, 1059.14026, -1793.48792, 13.18020, 0.0, 0.0, 0.0);
	CreateDynamicObject(19467, 1106.61084, -1743.47595, 11.82520, 234.0, 0.0, 90.0);
	obj = CreateDynamicObject(19467, 1106.62378, -1738.35986, 11.91520, 234.0, 4.0, 93.0);

	/*CreateDynamicObject(996, 1177.76770, -1774.21704, 13.07110, 0.0, 0.0, 90.0); // Кривые ограждения
	CreateDynamicObject(996, 1177.76770, -1760.21704, 13.07110, 0.0, 0.0, 90.0);
	CreateDynamicObject(996, 1177.76770, -1749.71704, 13.07110, 0.0, 0.0, 90.0);
	CreateDynamicObject(996, 1177.76770, -1739.21704, 13.07110, 0.0, 0.0, 90.0);
	CreateDynamicObject(996, 1177.76770, -1727.71704, 13.07110, 0.0, 0.0, 90.0);*/
	return obj;
}

// Особняк мафий
MafiaHouse_CreateObjects()
{
	CreateDynamicObject(14444, 2551.88281, -1343.62500, 1059.80469, 0.0, 0.0, 0.0);
	CreateDynamicObject(14447, 2569.58594, -1333.94531, 1064.75000, 0.0, 0.0, 0.0);
	CreateDynamicObject(2076, 2558.21436, -1297.95801, 1059.97656, 0.0, 0.0, 90.0);
	CreateDynamicObject(2294, 2559.65625, -1355.87500, 1059.97656, 0.0, 0.0, 180.0);
	CreateDynamicObject(2294, 2558.66406, -1355.87500, 1059.97656, 0.0, 0.0, 180.0);
	CreateDynamicObject(2129, 2557.69531, -1355.86719, 1059.97656, 0.0, 0.0, 180.0);
	CreateDynamicObject(2129, 2556.70313, -1355.86719, 1059.97656, 0.0, 0.0, 180.0);
	CreateDynamicObject(2304, 2555.69531, -1355.87500, 1059.97656, 0.0, 0.0, 180.0);
	CreateDynamicObject(2129, 2555.70313, -1354.90625, 1059.97656, 0.0, 0.0, 90.0);
	CreateDynamicObject(2129, 2555.70313, -1353.92188, 1059.97656, 0.0, 0.0, 90.0);
	CreateDynamicObject(2129, 2555.70313, -1352.92969, 1059.97656, 0.0, 0.0, 90.0);
	CreateDynamicObject(2130, 2555.69531, -1351.92188, 1059.97656, 0.0, 0.0, 90.0);
	CreateDynamicObject(2129, 2555.70313, -1349.95313, 1059.97656, 0.0, 0.0, 90.0);
	CreateDynamicObject(2128, 2555.69531, -1348.96094, 1059.97656, 0.0, 0.0, 90.0);
	CreateDynamicObject(2127, 2555.70313, -1347.96875, 1059.97656, 0.0, 0.0, 90.0);
	CreateDynamicObject(1703, 2550.14063, -1336.60156, 1059.97656, 0.0, 0.0, 180.0);
	CreateDynamicObject(1703, 2551.28125, -1332.68750, 1059.97656, 0.0, 0.0, 270.0);
	CreateDynamicObject(2606, 2546.15625, -1334.54688, 1062.69531, 0.0, 0.0, 90.0);
	CreateDynamicObject(2606, 2546.15625, -1334.54688, 1062.22656, 0.0, 0.0, 90.0);
	CreateDynamicObject(2606, 2546.15625, -1334.54688, 1061.76563, 0.0, 0.0, 90.0);
	CreateDynamicObject(2606, 2546.15625, -1334.54688, 1061.30469, 0.0, 0.0, 90.0);
	CreateDynamicObject(2229, 2546.61426, -1331.35254, 1060.01563, 0.0, 0.0, 60.0);
	CreateDynamicObject(2104, 2546.22339, -1332.85388, 1060.01563, 0.0, 0.0, 90.0);
	CreateDynamicObject(1788, 2546.69678, -1334.67322, 1060.06250, 0.0, 0.0, 90.0);
	CreateDynamicObject(1703, 2548.14063, -1331.10156, 1059.97656, 0.0, 0.0, 0.0);
	CreateDynamicObject(2229, 2546.27344, -1336.04407, 1060.01563, 0.0, 0.0, 120.0);
	CreateDynamicObject(1557, 2577.40991, -1335.91003, 1064.36206, 0.0, 0.0, 90.0);
	CreateDynamicObject(1557, 2577.39990, -1332.88000, 1064.35999, 0.0, 0.0, 270.0);
	CreateDynamicObject(1557, 2577.40991, -1351.90344, 1059.99377, 0.0, 0.0, 90.0);
	CreateDynamicObject(1557, 2577.39990, -1348.88855, 1059.99377, 0.0, 0.0, 270.0);
	CreateDynamicObject(16151, 2569.0, -1355.34277, 1060.31946, 0.0, 0.0, 270.0);
	CreateDynamicObject(3850, 2562.03809, -1334.89355, 1060.46216, 0.0, 0.0, 30.0);
	CreateDynamicObject(3850, 2571.96240, -1337.80566, 1060.46216, 0.0, 0.0, 90.0);
	CreateDynamicObject(3850, 2565.19238, -1337.74451, 1060.46216, 0.0, 0.0, 90.0);
	CreateDynamicObject(1649, 2577.13428, -1333.93054, 1062.17114, 0.0, 0.0, 270.0);
	CreateDynamicObject(2491, 2574.30396, -1332.38940, 1059.40430, 0.0, 0.0, 30.0);
	CreateDynamicObject(1955, 2574.42993, -1332.58618, 1061.43604,   18.0, 288.0, -47.0);
	CreateDynamicObject(1703, 2569.37500, -1332.79553, 1059.98328, 0.0, 0.0, 90.0);
	CreateDynamicObject(1703, 2569.37500, -1335.79553, 1059.98328, 0.0, 0.0, 90.0);
	CreateDynamicObject(1703, 2566.87500, -1332.79553, 1059.98328, 0.0, 0.0, 90.0);
	CreateDynamicObject(1703, 2566.87500, -1335.79553, 1059.98328, 0.0, 0.0, 90.0);
	CreateDynamicObject(1703, 2564.37500, -1332.79553, 1059.98328, 0.0, 0.0, 90.0);
	CreateDynamicObject(1703, 2564.37500, -1335.79553, 1059.98328, 0.0, 0.0, 90.0);
	CreateDynamicObject(1726, 2573.19189, -1336.87732, 1064.36230, 0.0, 0.0, 166.0);
	CreateDynamicObject(1726, 2570.18115, -1335.81860, 1064.36230, 0.0, 0.0, 134.0);
	CreateDynamicObject(2205, 2574.76001, -1332.86731, 1064.36292, 0.0, 0.0, 135.0);
	CreateDynamicObject(1714, 2575.06860, -1331.51770, 1064.35327, 0.0, 0.0, -45.0);
	CreateDynamicObject(2608, 2576.95801, -1331.60669, 1066.55225, 0.0, 0.0, 90.0);
	CreateDynamicObject(2708, 2548.48999, -1345.36511, 1059.98303, 0.0, 0.0, 90.0);
	CreateDynamicObject(3791, 2553.37988, -1343.60803, 1060.36255, 0.0, 0.0, 90.0);
	CreateDynamicObject(941, 2552.18628, -1348.03723, 1060.39221, 0.0, 0.0, 0.0);
	CreateDynamicObject(941, 2549.62329, -1348.03931, 1060.39221, 0.0, 0.0, 0.0);
	obj = CreateDynamicObject(1829, 2549.56812, -1347.81921, 1061.34338, 0.0, 0.0, 122.0);
	return obj;
}

// Особняк ЛКН
LCNHouse_CreateObjects()
{
	CreateDynamicObject(14758, 165.02341, 1365.56250, 1084.73438, 0.0, 0.0, 0.0);
	CreateDynamicObject(1506,167.2891, 1365.5078, 1082.8516, 0.0, 0.0, 180.0);
	CreateDynamicObject(1506, 164.26559, 1365.48438, 1082.85156, 0.0, 0.0, 0.0);
	CreateDynamicObject(14757, 179.76559, 1369.52344, 1084.52344, 0.0, 0.0, 0.0);
	CreateDynamicObject(1491, 175.16409, 1377.85938, 1087.35156, 0.0, 0.0, 0.0);
	CreateDynamicObject(1491, 175.16409, 1382.00781, 1087.36719, 0.0, 0.0, 0.0);
	CreateDynamicObject(1491, 171.84380, 1382.32813, 1082.84375, 0.0, 0.0, 270.0);
	CreateDynamicObject(1491, 163.64841, 1382.32813, 1082.85938, 0.0, 0.0, 270.0);
	CreateDynamicObject(1705, 175.30000, 1367.01721, 1082.85913, 0.0, 0.0, 180.0);
	CreateDynamicObject(1739, 175.89999, 1386.30835, 1083.73999, 0.0, 0.0, 90.0);
	CreateDynamicObject(1702, 178.60001, 1371.11194, 1082.85913, 0.0, 0.0, 270.0);
	CreateDynamicObject(1705, 178.60001, 1374.10132, 1082.85913, 0.0, 0.0, 270.0);
	CreateDynamicObject(1705, 174.30000, 1376.11426, 1082.85913, 0.0, 0.0, 0.0);
	CreateDynamicObject(2314, 172.55338, 1372.98523, 1082.85876, 0.0, 0.0, 90.0);
	CreateDynamicObject(2315, 176.88995, 1367.22400, 1082.85876, 0.0, 0.0, 0.0);
	CreateDynamicObject(2312, 178.12007, 1367.15674, 1083.71875, 0.0, 0.0, 222.0);
	CreateDynamicObject(2636, 165.99739, 1385.94421, 1083.47986, 0.0, 0.0, 90.0);
	CreateDynamicObject(19836, 165.94411, 1385.48486, 1082.87415, 0.0, 0.0, 0.0);
	CreateDynamicObject(19903, 164.26785, 1387.00989, 1082.86108, 0.0, 0.0, 270.0);
	CreateDynamicObject(1736, 175.89999, 1387.29443, 1085.52905, 0.0, 0.0, 0.0);
	CreateDynamicObject(1828, 175.88370, 1371.26636, 1082.85913, 0.0, 0.0, 270.0);
	CreateDynamicObject(1665, 175.43480, 1382.86633, 1083.65002, 0.0, 0.0, 0.93690);
	CreateDynamicObject(11691, 175.89999, 1380.96936, 1082.84619, 0.0, 0.0, 90.0);
	CreateDynamicObject(11691, 175.89999, 1384.05566, 1082.84619, 0.0, 0.0, 90.0);
	CreateDynamicObject(2120, 174.30000, 1384.69995, 1083.50195, 0.0, 0.0, 180.0);
	CreateDynamicObject(1667, 175.81064, 1384.99805, 1083.72998, 0.0, 0.0, 0.93690);
	CreateDynamicObject(1670, 175.69644, 1381.32776, 1083.72998, 0.0, 0.0, 0.93690);
	CreateDynamicObject(1669, 176.25670, 1383.73938, 1083.80005, 0.0, 0.0, 0.93690);
	CreateDynamicObject(1665, 176.26411, 1380.60083, 1083.65002, 0.0, 0.0, 0.93690);
	CreateDynamicObject(2120, 174.30000, 1383.30005, 1083.50195, 0.0, 0.0, 180.0);
	CreateDynamicObject(2120, 174.30000, 1381.80005, 1083.50195, 0.0, 0.0, 180.0);
	CreateDynamicObject(2120, 174.30000, 1380.40002, 1083.50195, 0.0, 0.0, 180.0);
	CreateDynamicObject(2120, 177.39999, 1384.69995, 1083.50195, 0.0, 0.0, 0.0);
	CreateDynamicObject(2120, 177.39999, 1383.30005, 1083.50195, 0.0, 0.0, 0.0);
	CreateDynamicObject(2120, 177.39999, 1381.80005, 1083.50195, 0.0, 0.0, 0.0);
	CreateDynamicObject(2120, 177.39999, 1380.40002, 1083.50195, 0.0, 0.0, 0.0);
	CreateDynamicObject(1743, 173.57837, 1370.80481, 1087.26465, 0.0, 0.0, 90.0);
	CreateDynamicObject(1742, 173.41046, 1377.78638, 1087.36462, 0.0, 0.0, 0.0);
	CreateDynamicObject(1745, 176.46519, 1374.23779, 1087.26465, 0.0, 0.0, 270.0);
	CreateDynamicObject(1764, 172.62846, 1373.78381, 1087.26465, 0.0, 0.0, 90.0);
	CreateDynamicObject(1799, 176.26947, 1385.23572, 1087.26465, 0.0, 0.0, 270.0);
	CreateDynamicObject(2095, 178.51335, 1375.28210, 1087.36523, 0.0, 0.0, 270.0);
	CreateDynamicObject(2095, 178.59438, 1372.09705, 1087.36523, 0.0, 0.0, 270.0);
	CreateDynamicObject(2095, 178.28270, 1383.21655, 1087.36523, 0.0, 0.0, 270.0);
	CreateDynamicObject(2100, 172.45549, 1386.75916, 1087.36523, 0.0, 0.0, 45.0);
	CreateDynamicObject(1741, 176.32039, 1385.96484, 1087.36523, 0.0, 0.0, 0.0);
	CreateDynamicObject(1752, 172.47301, 1384.35742, 1087.86523, 0.0, 0.0, 90.0);
	CreateDynamicObject(1818, 172.25670, 1383.73865, 1087.36523, 0.0, 0.0, 0.0);
	CreateDynamicObject(1829, 160.69968, 1386.21594, 1088.73669, 0.0, 0.0, 20.0);
	CreateDynamicObject(941, 160.51346, 1383.30347, 1087.77905, 0.0, 0.0, 90.0);
	CreateDynamicObject(941, 160.51350, 1385.80347, 1087.77905, 0.0, 0.0, 90.0);
	CreateDynamicObject(3791, 162.95450, 1382.73816, 1087.76599, 0.0, 0.0, 0.0);
	CreateDynamicObject(2708, 163.95770, 1387.29871, 1087.36218, 0.0, 0.0, 0.0);
	CreateDynamicObject(2608, 171.66005, 1383.85815, 1089.52368, 0.0, 0.0, 270.0);
	CreateDynamicObject(1714, 170.18011, 1385.15100, 1087.36414, 0.0, 0.0, 69.0);
	CreateDynamicObject(2205, 171.08910, 1385.69604, 1087.37537, 0.0, 0.0, 270.0);
	obj = CreateDynamicObject(1726, 167.84596, 1386.95093, 1087.36389, 0.0, 0.0, 0.0);
	return obj;
}

stock YakuzaHouse_CreateObjects()
{
	//CreateDynamicObject(1557, 717.45001, -1277.66626, 16.60960, 0.0, 0.0, 90.0); // Двери на крыше Якудзы
	//CreateDynamicObject(1557, 717.45001, -1274.63354, 16.60960, 0.0, 0.0, 270.0); // Двери на крыше Якудзы
	
	// by Nikita Dorokhov (https://vk.com/id100290260 | 300 rub | 15/08/2016)
	new tmpobjid;
	tmpobjid = CreateDynamicObject(19379,-2167.409,666.408,1049.390,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 6869, "vegastemp1", "vgnbarb_wall_128", 0);
	tmpobjid = CreateDynamicObject(19379,-2157.774,666.408,1049.390,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 6869, "vegastemp1", "vgnbarb_wall_128", 0);
	tmpobjid = CreateDynamicObject(19379,-2177.040,666.408,1049.390,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 6869, "vegastemp1", "vgnbarb_wall_128", 0);
	tmpobjid = CreateDynamicObject(19379,-2177.040,676.910,1049.390,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 6869, "vegastemp1", "vgnbarb_wall_128", 0);
	tmpobjid = CreateDynamicObject(19379,-2167.409,676.910,1049.390,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 6869, "vegastemp1", "vgnbarb_wall_128", 0);
	tmpobjid = CreateDynamicObject(19379,-2157.774,676.910,1049.390,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 6869, "vegastemp1", "vgnbarb_wall_128", 0);
	tmpobjid = CreateDynamicObject(19377,-2174.045,666.008,1052.850,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(14411,-2167.409,670.192,1049.474,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 7985, "vgsswarehse02c", "muddywater", 0);
	tmpobjid = CreateDynamicObject(19450,-2169.277,669.145,1048.736,35.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19450,-2165.329,669.145,1048.736,35.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19377,-2174.045,675.642,1052.850,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19377,-2169.302,677.043,1047.392,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19377,-2165.305,677.043,1047.392,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19378,-2169.154,677.495,1052.609,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14479, "skuzzy_motelmain", "mp_CJ_Laminate1", 0);
	tmpobjid = CreateDynamicObject(19376,-2169.154,677.495,1052.438,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 7985, "vgsswarehse02c", "muddywater", 0);
	tmpobjid = CreateDynamicObject(19378,-2159.520,677.495,1052.609,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14479, "skuzzy_motelmain", "mp_CJ_Laminate1", 0);
	tmpobjid = CreateDynamicObject(19377,-2160.916,675.642,1052.850,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19387,-2160.916,669.218,1051.229,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19377,-2160.916,662.794,1052.850,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19358,-2160.916,669.218,1054.730,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19358,-2160.916,669.218,1058.232,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19377,-2177.040,661.191,1052.850,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19377,-2167.409,661.191,1052.850,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19377,-2157.774,661.191,1052.850,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19376,-2159.520,677.495,1052.438,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 7985, "vgsswarehse02c", "muddywater", 0);
	tmpobjid = CreateDynamicObject(19449,-2177.040,661.210,1048.420,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19449,-2167.409,661.210,1048.420,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19449,-2157.774,661.210,1048.420,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19449,-2160.920,662.794,1048.420,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19449,-2160.930,675.642,1048.420,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19451,-2165.285,677.083,1050.942,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14488, "dogsgym", "AH_bgmartiles", 0);
	tmpobjid = CreateDynamicObject(19387,-2163.660,672.328,1050.942,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19449,-2157.237,672.328,1050.942,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19389,-2163.660,672.508,1050.942,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14488, "dogsgym", "AH_bgmartiles", 0);
	tmpobjid = CreateDynamicObject(19451,-2157.237,672.508,1050.942,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14488, "dogsgym", "AH_bgmartiles", 0);
	tmpobjid = CreateDynamicObject(19451,-2160.964,677.337,1050.942,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14488, "dogsgym", "AH_bgmartiles", 0);
	tmpobjid = CreateDynamicObject(19358,-2167.409,661.262,1050.342,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19449,-2174.020,666.008,1048.420,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19449,-2174.020,675.642,1048.420,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19387,-2170.909,672.328,1050.942,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19449,-2177.330,672.328,1050.942,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19452,-2169.381,677.237,1050.757,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1", 0);
	tmpobjid = CreateDynamicObject(19385,-2170.909,672.508,1050.942,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1", 0);
	tmpobjid = CreateDynamicObject(19452,-2173.857,677.316,1050.942,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1", 0);
	tmpobjid = CreateDynamicObject(19452,-2177.330,672.508,1050.942,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1", 0);
	tmpobjid = CreateDynamicObject(19452,-2173.962,677.846,1050.942,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 4586, "skyscrap3_lan2", "sl_skyscrpr05wall1", 0);
	tmpobjid = CreateDynamicObject(19087,-2169.277,671.815,1053.555,-55.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19087,-2169.277,669.916,1052.233,-55.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19087,-2169.277,668.937,1051.551,-55.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19087,-2169.277,667.394,1050.471,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19087,-2169.277,669.625,1052.030,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19087,-2169.274,671.663,1053.437,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19087,-2165.329,671.663,1053.437,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19087,-2165.329,671.815,1053.555,-55.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19087,-2165.329,669.916,1052.233,-55.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19087,-2165.329,668.937,1051.551,-55.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19087,-2165.329,667.394,1050.471,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19451,-2160.525,680.324,1050.942,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14488, "dogsgym", "AH_bgmartiles", 0);
	tmpobjid = CreateDynamicObject(970,-2171.278,672.318,1053.230,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14839, "lee_strippriv", "WH_Chang1", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(970,-2175.424,672.312,1053.230,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14839, "lee_strippriv", "WH_Chang1", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(970,-2175.987,672.315,1053.230,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14839, "lee_strippriv", "WH_Chang1", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(970,-2163.315,672.315,1053.230,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14839, "lee_strippriv", "WH_Chang1", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(970,-2159.172,672.311,1053.230,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14839, "lee_strippriv", "WH_Chang1", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(970,-2158.948,672.319,1053.230,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14839, "lee_strippriv", "WH_Chang1", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0);
	tmpobjid = CreateDynamicObject(19377,-2160.989,680.492,1052.850,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19377,-2173.830,680.492,1052.850,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19387,-2167.409,680.492,1054.411,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19358,-2167.409,680.492,1057.911,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19449,-2174.026,677.074,1051.431,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19449,-2173.830,680.484,1051.431,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19449,-2160.989,680.484,1051.431,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19449,-2160.923,677.158,1051.431,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19375,-2172.631,685.416,1052.614,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 4828, "airport3_las", "gnhotelwall02_128", 0);
	tmpobjid = CreateDynamicObject(19375,-2162.128,685.416,1052.614,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 4828, "airport3_las", "gnhotelwall02_128", 0);
	tmpobjid = CreateDynamicObject(19384,-2167.409,680.692,1054.411,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19354,-2167.409,680.692,1057.911,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19427,-2165.782,681.544,1054.411,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19427,-2169.058,681.544,1054.411,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19427,-2169.058,681.544,1057.911,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19427,-2165.782,681.544,1057.911,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19380,-2161.050,682.262,1052.850,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19380,-2173.789,682.262,1052.850,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19384,-2156.940,683.910,1054.411,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19384,-2165.201,685.502,1054.411,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19354,-2165.201,685.502,1057.911,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19354,-2156.940,683.910,1057.911,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19384,-2176.148,683.880,1054.411,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19354,-2176.148,683.880,1057.911,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19375,-2151.625,685.416,1052.614,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 4828, "airport3_las", "gnhotelwall02_128", 0);
	tmpobjid = CreateDynamicObject(19375,-2183.133,685.416,1052.614,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 4828, "airport3_las", "gnhotelwall02_128", 0);
	tmpobjid = CreateDynamicObject(19380,-2176.268,690.330,1052.850,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19380,-2183.423,682.262,1052.850,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19380,-2181.199,690.144,1052.850,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19380,-2185.929,686.285,1052.850,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19375,-2162.128,695.049,1052.614,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 4828, "airport3_las", "gnhotelwall02_128", 0);
	tmpobjid = CreateDynamicObject(19375,-2172.631,695.049,1052.614,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 4828, "airport3_las", "gnhotelwall02_128", 0);
	tmpobjid = CreateDynamicObject(19380,-2171.423,690.347,1052.850,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19380,-2159.327,690.297,1052.850,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19380,-2160.581,694.849,1052.850,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19380,-2170.215,694.849,1052.850,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19380,-2156.172,677.530,1052.850,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19380,-2151.392,680.603,1052.850,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19380,-2146.635,685.355,1052.850,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19380,-2151.488,690.039,1052.850,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19380,-2153.811,690.218,1052.850,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19449,-2160.898,662.794,1048.420,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19449,-2160.913,675.642,1048.420,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19377,-2156.088,672.257,1052.850,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19377,-2153.001,667.598,1052.850,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19377,-2153.001,657.969,1052.850,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19449,-2156.112,672.245,1048.420,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19449,-2153.029,667.598,1048.420,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19449,-2153.029,657.969,1048.420,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14385, "trailerkb", "tr_wood1", 0);
	tmpobjid = CreateDynamicObject(19381,-2157.774,666.408,1056.890,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19381,-2167.409,666.408,1056.890,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19381,-2157.774,676.910,1056.890,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19381,-2177.040,676.910,1056.890,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19381,-2177.040,666.408,1056.890,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19381,-2167.409,676.910,1056.890,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19381,-2172.631,685.416,1056.913,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19381,-2183.133,685.416,1056.929,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19381,-2162.128,685.416,1056.929,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19381,-2151.625,685.416,1056.898,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19381,-2172.631,695.049,1056.929,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19381,-2162.128,695.049,1056.929,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19432,-2160.060,664.820,1051.229,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19432,-2160.060,664.820,1054.730,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19377,-2159.339,660.088,1052.850,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19432,-2152.805,664.820,1051.229,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19432,-2152.805,664.820,1054.730,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19377,-2153.538,660.079,1052.850,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	tmpobjid = CreateDynamicObject(19381,-2156.143,666.958,1053.535,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19381,-2156.182,666.274,1053.535,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19361,-2172.921,685.578,1054.411,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19361,-2174.744,685.578,1054.411,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19361,-2174.744,685.578,1057.911,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19361,-2172.921,685.578,1057.911,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19361,-2157.807,685.547,1054.411,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19361,-2157.807,685.547,1057.911,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19361,-2155.355,685.486,1054.411,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19361,-2155.355,685.486,1057.911,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 2823, "gb_kitchtake", "GB_takeaway04", 0);
	tmpobjid = CreateDynamicObject(19353,-2165.231,687.353,1052.616,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19353,-2165.231,690.853,1052.616,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(2128,-2169.307,694.990,1053.853,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14839, "lee_strippriv", "WH_Chang", 0);
	tmpobjid = CreateDynamicObject(2128,-2161.399,694.990,1053.853,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14839, "lee_strippriv", "WH_Chang", 0);
	tmpobjid = CreateDynamicObject(2128,-2163.486,680.620,1053.853,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14839, "lee_strippriv", "WH_Chang", 0);
	tmpobjid = CreateDynamicObject(2128,-2171.520,680.633,1053.853,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14839, "lee_strippriv", "WH_Chang", 0);
	tmpobjid = CreateDynamicObject(19435,-2149.687,684.642,1052.510,90.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 7985, "vgsswarehse02c", "muddywater", 0);
	tmpobjid = CreateDynamicObject(19435,-2151.368,682.959,1052.510,90.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 7985, "vgsswarehse02c", "muddywater", 0);
	tmpobjid = CreateDynamicObject(19435,-2151.366,679.731,1052.510,90.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 7985, "vgsswarehse02c", "muddywater", 0);
	tmpobjid = CreateDynamicObject(19435,-2150.625,682.962,1053.230,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 7985, "vgsswarehse02c", "muddywater", 0);
	tmpobjid = CreateDynamicObject(19435,-2148.088,683.907,1053.233,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 7985, "vgsswarehse02c", "muddywater", 0);
	tmpobjid = CreateDynamicObject(19435,-2147.231,684.647,1052.510,90.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 7985, "vgsswarehse02c", "muddywater", 0);
	tmpobjid = CreateDynamicObject(19435,-2150.631,679.620,1053.249,0.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 7985, "vgsswarehse02c", "muddywater", 0);
	tmpobjid = CreateDynamicObject(19435,-2149.907,682.099,1052.510,90.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 7985, "vgsswarehse02c", "muddywater", 0);
	tmpobjid = CreateDynamicObject(19435,-2148.156,680.659,1052.510,90.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 7985, "vgsswarehse02c", "muddywater", 0);
	tmpobjid = CreateDynamicObject(19435,-2146.670,681.952,1052.510,90.000,90.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 7985, "vgsswarehse02c", "muddywater", 0);
	tmpobjid = CreateDynamicObject(19435,-2148.352,683.153,1052.510,90.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 7985, "vgsswarehse02c", "muddywater", 0);
	tmpobjid = CreateDynamicObject(2128,-2183.248,690.289,1053.767,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14839, "lee_strippriv", "WH_Chang", 0);
	tmpobjid = CreateDynamicObject(2128,-2179.148,690.296,1053.767,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14839, "lee_strippriv", "WH_Chang", 0);
	tmpobjid = CreateDynamicObject(2128,-2183.424,682.131,1053.767,0.000,0.000,180.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14839, "lee_strippriv", "WH_Chang", 0);
	tmpobjid = CreateDynamicObject(2128,-2179.480,682.127,1053.767,0.000,0.000,180.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14839, "lee_strippriv", "WH_Chang", 0);
	tmpobjid = CreateDynamicObject(2128,-2166.290,661.093,1053.340,0.000,0.000,180.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14839, "lee_strippriv", "WH_Chang", 0);
	tmpobjid = CreateDynamicObject(2128,-2168.437,661.066,1053.340,0.000,0.000,180.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14839, "lee_strippriv", "WH_Chang", 0);
	tmpobjid = CreateDynamicObject(2128,-2174.188,670.095,1053.340,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14839, "lee_strippriv", "WH_Chang", 0);
	tmpobjid = CreateDynamicObject(2128,-2160.768,669.208,1053.467,0.000,0.000,-90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8534, "tikimotel", "sa_wood03_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14839, "lee_strippriv", "WH_Chang", 0);
	tmpobjid = CreateDynamicObject(1499,-2160.913,668.476,1049.459,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 6869, "vegastemp1", "vgnbarb_wall_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(1499,-2164.426,672.299,1049.175,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 6869, "vegastemp1", "vgnbarb_wall_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(1499,-2171.673,672.302,1049.175,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 6869, "vegastemp1", "vgnbarb_wall_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(1499,-2168.184,680.532,1052.675,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 6869, "vegastemp1", "vgnbarb_wall_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(1499,-2176.158,683.134,1052.675,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 6869, "vegastemp1", "vgnbarb_wall_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(1499,-2156.888,683.173,1052.675,0.000,0.000,90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 6869, "vegastemp1", "vgnbarb_wall_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(1499,-2165.976,685.542,1052.675,0.000,0.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 6869, "vegastemp1", "vgnbarb_wall_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19455,-2167.307,662.865,1049.398,0.000,90.000,0.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, "sphinx01", "luxorceiling01_128", 0);
	tmpobjid = CreateDynamicObject(19367,-2172.387,682.278,1054.420,0.000,0.000,89.699);
	SetDynamicObjectMaterial(tmpobjid, 0, 14839, "lee_strippriv", "WH_Chang", 0);
	tmpobjid = CreateDynamicObject(19367,-2162.138,682.283,1054.400,0.000,0.000,-90.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14839, "lee_strippriv", "WH_Chang", 0);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	CreateDynamicObject(2517,-2172.578,676.272,1049.458,0.000,0.000,0.000);
	CreateDynamicObject(2528,-2170.669,677.268,1049.477,0.000,0.000,0.000);
	CreateDynamicObject(2739,-2173.323,674.219,1049.478,0.000,0.000,90.000);
	CreateDynamicObject(2741,-2173.713,674.045,1050.316,0.000,0.000,90.000);
	//CreateDynamicObject(1828,-2167.230,676.439,1052.696,0.000,0.000,90.000);// шкура
	CreateDynamicObject(2517,-2172.578,676.272,1049.458,0.000,0.000,0.000);
	CreateDynamicObject(1754,-2162.833,662.016,1049.476,0.000,0.000,180.000);
	CreateDynamicObject(1753,-2161.854,664.046,1049.476,0.000,0.000,-90.000);
	CreateDynamicObject(1753,-2173.332,661.914,1049.476,0.000,0.000,90.000);
	CreateDynamicObject(1754,-2172.396,661.959,1049.476,0.000,0.000,180.000);
	CreateDynamicObject(3533,-2169.885,675.961,1056.852,0.000,0.000,0.000);
	CreateDynamicObject(3533,-2164.420,675.961,1056.847,0.000,0.000,0.000);
	CreateDynamicObject(1741,-2172.412,669.445,1049.476,0.000,0.000,90.000);
	CreateDynamicObject(1208,-2173.016,672.858,1049.478,0.000,0.000,0.000);
	CreateDynamicObject(1829,-2164.723,679.424,1049.955,0.000,0.000,0.000);
	CreateDynamicObject(936,-2162.299,679.799,1049.864,0.000,0.000,0.000);
	CreateDynamicObject(1222,-2161.741,673.063,1049.914,0.000,0.000,0.000);
	CreateDynamicObject(2060,-2165.006,675.704,1049.478,0.000,0.000,90.000);
	CreateDynamicObject(2060,-2165.004,676.808,1049.478,0.000,0.000,90.000);
	CreateDynamicObject(2060,-2165.112,676.296,1049.717,0.000,0.000,90.000);
	CreateDynamicObject(1577,-2162.230,679.578,1050.337,0.000,0.000,0.000);
	CreateDynamicObject(936,-2161.442,676.523,1049.864,0.000,0.000,-90.000);
	CreateDynamicObject(2035,-2161.614,676.726,1050.348,0.000,0.000,-92.039);
	CreateDynamicObject(2141,-2153.416,665.448,1049.477,0.000,0.000,-90.000);
	CreateDynamicObject(2025,-2159.404,671.901,1049.476,0.000,0.000,0.000);
	CreateDynamicObject(1757,-2156.409,671.792,1049.476,0.000,0.000,0.000);
	CreateDynamicObject(2267,-2173.925,676.403,1055.016,0.000,0.000,90.000);
	CreateDynamicObject(2266,-2161.540,676.262,1054.788,0.000,0.000,-90.000);
	CreateDynamicObject(1756,-2173.314,675.649,1052.696,0.000,0.000,90.000);
	CreateDynamicObject(1755,-2172.910,672.692,1052.696,0.000,0.000,127.000);
	CreateDynamicObject(1755,-2173.342,679.292,1052.696,0.000,0.000,40.000);
	CreateDynamicObject(1756,-2161.613,676.975,1052.696,0.000,0.000,-90.000);
	CreateDynamicObject(1755,-2162.239,679.717,1052.696,0.000,0.000,-47.000);
	CreateDynamicObject(1755,-2161.479,673.457,1052.696,0.000,0.000,222.000);
	CreateDynamicObject(1797,-2182.401,683.351,1052.701,0.000,0.000,90.000);
	CreateDynamicObject(2755,-2161.029,666.193,1051.186,0.000,0.000,90.000);
	CreateDynamicObject(2755,-2161.070,662.886,1051.186,0.000,0.000,90.000);
	CreateDynamicObject(2755,-2162.919,661.387,1051.186,0.000,0.000,0.000);
	CreateDynamicObject(1754,-2163.777,662.003,1049.476,0.000,0.000,180.000);
	CreateDynamicObject(1753,-2161.857,666.907,1049.476,0.000,0.000,-90.000);
	CreateDynamicObject(2755,-2172.203,661.301,1051.186,0.000,0.000,0.000);
	CreateDynamicObject(2755,-2173.916,662.727,1051.186,0.000,0.000,90.000);
	CreateDynamicObject(2755,-2173.892,666.057,1051.186,0.000,0.000,90.000);
	CreateDynamicObject(1754,-2171.474,661.951,1049.476,0.000,0.000,180.000);
	CreateDynamicObject(1753,-2173.337,664.802,1049.476,0.000,0.000,90.000);
	CreateDynamicObject(14535, -2156.45, 665.42, 1051.5, 0.0, 0.0, 0.0);
	CreateDynamicObject(1557,-2168.920,661.289,1049.475,0.000,0.000,0.000);
	CreateDynamicObject(1557,-2165.919,661.314,1049.475,0.000,0.000,180.000);
	CreateDynamicObject(14608,-2165.266,693.186,1054.316,0.000,0.000,135.000);
	CreateDynamicObject(2755,-2168.942,685.502,1054.446,0.000,0.000,0.000);
	CreateDynamicObject(2755,-2161.628,685.502,1054.446,0.000,0.000,0.000);
	CreateDynamicObject(19325,-2168.632,685.502,1055.873,90.000,0.000,90.000);
	CreateDynamicObject(19325,-2172.758,685.502,1055.873,90.000,0.000,90.000);
	CreateDynamicObject(19325,-2162.381,685.502,1055.873,90.000,0.000,90.000);
	CreateDynamicObject(19325,-2158.275,685.502,1055.873,90.000,0.000,90.000);
	CreateDynamicObject(1723,-2170.673,686.941,1052.701,0.000,0.000,90.000);
	CreateDynamicObject(1723,-2170.730,691.191,1052.701,0.000,0.000,90.000);
	CreateDynamicObject(1723,-2159.992,689.207,1052.701,0.000,0.000,-90.000);
	CreateDynamicObject(1723,-2160.021,693.306,1052.701,0.000,0.000,-90.000);
	CreateDynamicObject(2189,-2159.467,690.329,1055.204,0.000,90.000,180.000);
	CreateDynamicObject(2189,-2171.300,690.141,1055.204,0.000,90.000,0.000);
	CreateDynamicObject(2592,-2150.259,689.726,1053.605,0.000,0.000,0.000);
	CreateDynamicObject(19446,-2148.337,679.805,1052.701,0.000,90.000,0.000);
	CreateDynamicObject(19604,-2147.543,678.933,1053.224,0.000,0.000,0.000);
	CreateDynamicObject(2188,-2148.005,687.140,1053.526,0.000,0.000,0.000);
	CreateDynamicObject(2188,-2152.453,687.205,1053.526,0.000,0.000,0.000);
	CreateDynamicObject(2372,-2146.861,679.485,1052.595,0.000,0.000,0.000);
	CreateDynamicObject(2372,-2147.445,679.448,1052.594,0.000,0.000,0.000);
	CreateDynamicObject(1950,-2151.034,689.668,1053.692,0.000,0.000,0.000);
	CreateDynamicObject(1950,-2151.419,689.590,1053.692,0.000,0.000,0.000);
	CreateDynamicObject(1950,-2150.612,689.684,1053.692,0.000,0.000,0.000);
	CreateDynamicObject(1279,-2147.221,683.859,1053.320,0.000,0.000,90.000);
	CreateDynamicObject(1797,-2182.372,688.091,1052.701,0.000,0.000,90.000);
	CreateDynamicObject(1895,-2185.725,686.246,1055.230,0.000,0.000,90.000);
	CreateDynamicObject(2253,-2176.353,685.304,1052.959,0.000,0.000,0.000);
	CreateDynamicObject(2253,-2176.402,682.536,1052.959,0.000,0.000,0.000);
	CreateDynamicObject(2253,-2165.147,661.670,1049.768,0.000,0.000,0.000);
	CreateDynamicObject(2253,-2169.984,661.570,1049.768,0.000,0.000,0.000);
	CreateDynamicObject(1730,-2176.729,687.043,1052.660,0.000,0.000,-90.000);
	CreateDynamicObject(1730,-2176.679,689.082,1052.660,0.000,0.000,-90.000);
	CreateDynamicObject(1742,-2181.348,690.160,1052.701,0.000,0.000,0.000);
	obj = CreateDynamicObject(1742,-2181.215,682.202,1052.701,0.000,0.000,180.000);
	return obj;
}

stock FourDragon_CreateObjects()
{
	CreateDynamicObject(14563, 1971.60938, 898.32813, 1000.0, 0.0, 0.0, 0.0);
	CreateDynamicObject(14614, 1971.60938, 898.32813, 1000.0, 0.0, 0.0, 0.0);
	CreateDynamicObject(14607, 1971.60938, 898.32813, 1000.0, 0.0, 0.0, 0.0);
	CreateDynamicObject(14605, 1993.45313, 898.30469, 1003.75000, 0.0, 0.0, 0.0);
	CreateDynamicObject(1557, 2019.78125, 896.82031, 995.87500, 0.0, 0.0, 90.0);
	CreateDynamicObject(1557, 2019.78125, 899.84381, 995.87500, 0.0, 0.0, 270.0);
	CreateDynamicObject(14637, 1981.72083, 898.36627, 1001.36719, 0.0, 0.0, 0.0);
	CreateDynamicObject(14561, 1964.21094, 898.30469, 998.70313, 0.0, 0.0, 0.0);
	CreateDynamicObject(14562, 1975.82031, 898.21088, 994.75000, 0.0, 0.0, 0.0);
	CreateDynamicObject(14564, 1959.28906, 870.85938, 998.61719, 0.0, 0.0, 0.0);
	CreateDynamicObject(2098, 1941.52344, 886.88281, 993.41412, 0.0, 0.0, 110.0);
	CreateDynamicObject(2098, 1940.39063, 894.70313, 993.41412, 0.0, 0.0, 90.0);
	CreateDynamicObject(2098, 1940.39063, 901.91412, 993.41412, 0.0, 0.0, 90.0);
	CreateDynamicObject(2098, 1941.21875, 909.79688, 993.41412, 0.0, 0.0, 70.0);
	CreateDynamicObject(14620, 1957.91406, 872.35162, 991.84381, 0.0, 0.0, 0.0);
	CreateDynamicObject(14619, 1957.67969, 924.40631, 991.84381, 0.0, 0.0, 0.0);
	CreateDynamicObject(14560, 1950.79688, 899.30469, 995.96881, 0.0, 0.0, 0.0);
	CreateDynamicObject(14565, 1950.83594, 899.25781, 993.44531, 0.0, 0.0, 0.0);
	CreateDynamicObject(2098, 1968.09375, 886.85938, 993.40631, 0.0, 0.0, 90.0);
	CreateDynamicObject(2098, 1968.09375, 894.48438, 993.40631, 0.0, 0.0, 90.0);
	CreateDynamicObject(2098, 1968.09375, 902.17969, 993.40631, 0.0, 0.0, 90.0);
	CreateDynamicObject(2098, 1968.09375, 910.03912, 993.40631, 0.0, 0.0, 90.0);
	CreateDynamicObject(14608, 1955.57813, 874.52338, 993.46881, 0.0, 0.0, 0.0);
	CreateDynamicObject(2799, 1940.71094, 922.07813, 991.98438, 0.0, 0.0, 80.0);
	CreateDynamicObject(2799, 1936.21094, 920.57813, 991.98438, 0.0, 0.0, 80.0);
	CreateDynamicObject(2799, 1945.21094, 920.57813, 991.98438, 0.0, 0.0, 80.0);
	CreateDynamicObject(2799, 1940.71094, 925.57813, 991.98438, 0.0, 0.0, 80.0);
	CreateDynamicObject(2799, 1940.71094, 929.07813, 991.98438, 0.0, 0.0, 80.0);
	CreateDynamicObject(2799, 1936.21094, 924.07813, 991.98438, 0.0, 0.0, 80.0);
	CreateDynamicObject(2799, 1936.21094, 927.57813, 991.98438, 0.0, 0.0, 80.0);
	CreateDynamicObject(2799, 1945.21094, 924.07813, 991.98438, 0.0, 0.0, 80.0);
	CreateDynamicObject(2799, 1945.21094, 927.57813, 991.98438, 0.0, 0.0, 80.0);
	CreateDynamicObject(1895, 1940.68750, 869.65002, 992.88281, 0.0, 0.0, 180.0);
	CreateDynamicObject(2799, 1944.21094, 932.57813, 991.98438, 0.0, 0.0, 170.0);
	CreateDynamicObject(2799, 1939.71094, 932.57813, 991.98438, 0.0, 0.0, 170.0);
	CreateDynamicObject(2799, 1935.21094, 932.57813, 991.98438, 0.0, 0.0, 170.0);
	CreateDynamicObject(2799, 1937.71094, 936.07813, 991.98438, 0.0, 0.0, 130.0);
	CreateDynamicObject(2802, 1942.21094, 936.07813, 991.98438, 0.0, 0.0, 90.0);
	CreateDynamicObject(2801, 1942.21094, 936.07813, 991.98438, 0.0, 0.0, 90.0);
	CreateDynamicObject(2800, 1935.21094, 932.57813, 991.98438, 0.0, 0.0, 170.0);
	CreateDynamicObject(2800, 1945.21094, 924.07813, 991.98438, 0.0, 0.0, 80.0);
	CreateDynamicObject(2800, 1940.71094, 925.57813, 991.98438, 0.0, 0.0, 80.0);
	CreateDynamicObject(2800, 1936.21094, 924.07813, 991.98438, 0.0, 0.0, 80.0);
	CreateDynamicObject(2800, 1944.21094, 932.57813, 991.98438, 0.0, 0.0, 170.0);
	CreateDynamicObject(1895, 1938.04688, 867.12500, 992.88281,   356.85840, 0.0, 270.0);
	CreateDynamicObject(1895, 1943.21875, 867.02338, 992.88281, 0.0, 0.0, 90.0);
	CreateDynamicObject(2773, 1949.31335, 926.57458, 992.38000, 0.0, 0.0, 84.0);
	CreateDynamicObject(2773, 1952.62683, 925.69128, 992.38000, 0.0, 0.0, 68.0);
	CreateDynamicObject(2773, 1957.54565, 922.08954, 992.38000, 0.0, 0.0, 40.0);
	CreateDynamicObject(2773, 1959.17175, 919.30756, 992.38000, 0.0, 0.0, 24.0);
	CreateDynamicObject(2773, 1955.32568, 924.13989, 992.38000, 0.0, 0.0, 52.0);
	CreateDynamicObject(2773, 1960.06567, 916.32990, 992.38000, 0.0, 0.0, 10.0);
	CreateDynamicObject(2773, 1959.25977, 914.67072, 992.38000, 0.0, 0.0, 90.0);
	CreateDynamicObject(2773, 1956.50000, 914.67072, 992.38000, 0.0, 0.0, 90.0);
	CreateDynamicObject(2773, 1953.75977, 914.67072, 992.38000, 0.0, 0.0, 90.0);
	CreateDynamicObject(2773, 1949.31299, 918.76831, 992.38000, 0.0, 0.0, 70.0);
	obj = CreateDynamicObject(2773, 1951.82312, 916.74567, 992.38000, 0.0, 0.0, 32.0);
	//CreateDynamicObject(19474, 1963.0, 886.93512, 992.0, 0.0, 0.0, 0.0);// ????
	//CreateDynamicObject(19474, 1963.0, 894.43512, 992.0, 0.0, 0.0, 0.0);// ????
	//CreateDynamicObject(19474, 1963.0, 902.43512, 992.0, 0.0, 0.0, 0.0);// ????
	//CreateDynamicObject(19474, 1963.0, 909.93512, 992.0, 0.0, 0.0, 0.0);// ????
	//CreateDynamicObject(19464, 1954.22339, 919.79791, 991.70001, 0.0, 90.0, 35.0); // ????????? ?????????
	return obj;
}

AJail_CreateObjects()
{
	CreateDynamicObject(18765, -181.504, 3301.486, 21.00, 0.0, 0.0, 00.00);
	CreateDynamicObject(18765, -181.573, 3301.702, 29.47, 0.0, 0.0, 90.00);
	CreateDynamicObject(19456, -176.612, 3301.525, 25.23, 0.0, 0.0, 00.00);
	CreateDynamicObject(19456, -181.488, 3296.667, 25.23, 0.0, 0.0, -90.0);
	CreateDynamicObject(19456, -186.372, 3301.524, 25.23, 0.0, 0.0, 00.00);
	CreateDynamicObject(19456, -181.488, 3306.378, 25.23, 0.0, 0.0, -90.0);
}

// Alcatraz (Алькатрас)
Alcatraz_CreateObjects()
{
	// Остров (exterior)
	CreateDynamicObject(4842, 667.260, -2866.959, -8.000, 0.00, 0.00, 87.98);
	CreateDynamicObject(3378, 646.030, -2743.260, 0.150, 0.00, 0.00, 270.00);
	CreateDynamicObject(19463, 569.36, -2746.39, 12.02, 0.00, 90.00, 0.00);

	obj = CreateDynamicObject(19380, 691.279, -2923.639, 1699.318, 0.00, 90.00, 0.00);	//	пол
	Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT, obj, true);
	// Остальное
	CreateDynamicObject(3378, 695.659, -2756.679, 0.100, 0.00, 0.00, 0.00);
	CreateDynamicObject(3378, 719.919, -2756.580, 0.090, 0.00, 0.00, 0.00);
	CreateDynamicObject(3378, 689.000, -2776.469, 0.100, 0.00, 0.00, 270.00);
	CreateDynamicObject(3378, 711.539, -2776.399, 0.100, 0.00, 0.00, 270.00);
	CreateDynamicObject(3378, 689.979, -2756.689, 0.100, 0.00, 0.00, 0.00);
	CreateDynamicObject(18228, 661.340, -2708.979, -3.599, 0.00, 0.00, 111.98);
	CreateDynamicObject(3378, 705.840, -2769.020, -1.610, 360.00, 90.00, 90.00);
	CreateDynamicObject(3378, 721.619, -2767.879, -1.649, 360.00, 90.00, 0.30);
	CreateDynamicObject(3378, 721.570, -2756.580, -1.649, 360.00, 90.00, 0.10);
	CreateDynamicObject(3378, 719.849, -2746.379, -10.060, 90.00, 90.00, 90.00);
	CreateDynamicObject(3378, 711.539, -2778.040, -1.649, 360.00, 90.00, 270.20);
	CreateDynamicObject(3378, 689.080, -2778.120, -1.590, 359.79, 90.00, 270.20);
	CreateDynamicObject(12814, 634.739, -2724.139, 1.250, 0.00, 0.00, 88.00);
	CreateDynamicObject(12814, 633.679, -2753.919, 1.250, 0.00, 0.00, 87.98);
	CreateDynamicObject(12814, 632.640, -2783.760, 1.259, 0.00, 0.00, 87.98);
	CreateDynamicObject(12814, 631.650, -2807.469, 1.269, 0.00, 0.00, 87.98);
	CreateDynamicObject(3378, 668.650, -2776.520, 0.109, 359.75, 0.00, 270.00);
	CreateDynamicObject(9582, 635.280, -2776.350, 9.970, 0.00, 0.00, 74.00);
	CreateDynamicObject(1501, 641.099, -2745.050, 1.200, 0.00, 0.00, 90.00);
	CreateDynamicObject(3378, 654.549, -2768.399, 0.180, 0.00, 0.00, 0.00);
	CreateDynamicObject(3378, 654.489, -2749.169, 0.180, 0.00, 0.00, 0.00);
	CreateDynamicObject(3279, 656.210, -2722.929, 1.250, 0.00, 0.00, 178.00);
	CreateDynamicObject(3378, 654.460, -2737.850, 0.180, 0.20, 0.00, 0.00);
	CreateDynamicObject(3378, 642.400, -2729.449, 0.180, 0.00, 0.00, 90.00);
	CreateDynamicObject(12814, 635.260, -2711.020, 2.380, 0.00, 345.00, 87.98);
	CreateDynamicObject(12814, 636.280, -2681.600, 6.260, 0.00, 0.00, 87.98);
	CreateDynamicObject(3378, 628.280, -2721.060, 0.180, 0.00, 0.00, 0.00);
	CreateDynamicObject(3378, 628.250, -2706.800, 2.289, 15.00, 0.00, 0.00);
	CreateDynamicObject(3378, 628.190, -2684.949, 5.190, -0.10, 0.00, 0.00);
	CreateDynamicObject(11454, 652.200, -2679.149, 6.260, 0.00, 0.00, 90.00);
	CreateDynamicObject(3378, 639.830, -2681.689, 5.170, 0.00, 0.00, 270.00);
	CreateDynamicObject(18228, 666.179, -2685.689, -2.329, 0.00, 0.00, 49.99);
	CreateDynamicObject(12814, 636.580, -2674.179, 6.260, 0.00, 0.00, 87.98);
	CreateDynamicObject(18228, 645.840, -2654.580, -0.720, 0.00, 0.00, 141.99);
	CreateDynamicObject(3279, 642.020, -2667.120, 6.260, 0.00, 0.00, 271.98);
	CreateDynamicObject(18228, 605.530, -2729.540, 1.100, 0.00, 0.00, 69.98);
	CreateDynamicObject(18228, 605.570, -2705.209, 1.210, 0.00, 0.00, 45.97);
	CreateDynamicObject(3378, 619.760, -2676.520, 5.190, 0.00, 0.00, 270.00);
	CreateDynamicObject(12814, 614.330, -2673.020, 5.650, 345.00, 0.00, 269.98);
	CreateDynamicObject(3378, 600.900, -2676.560, 8.180, 345.00, 0.00, 270.00);
	CreateDynamicObject(18228, 598.489, -2655.570, -1.340, 0.00, 0.00, 141.99);
	CreateDynamicObject(18228, 598.849, -2689.919, 4.710, 0.00, 0.00, 327.98);
	CreateDynamicObject(12814, 565.200, -2672.850, 12.130, 0.00, 0.00, 89.98);
	CreateDynamicObject(12814, 565.200, -2648.560, 12.130, 0.00, 0.00, 89.98);
	CreateDynamicObject(12814, 516.140, -2648.530, 12.140, 0.00, 0.00, 269.98);
	CreateDynamicObject(12814, 516.130, -2672.840, 12.140, 0.00, 0.00, 269.98);
	CreateDynamicObject(18228, 578.469, -2635.639, 3.690, 0.00, 0.00, 107.98);
	CreateDynamicObject(3378, 579.080, -2676.610, 11.060, 0.00, 0.00, 270.00);
	CreateDynamicObject(3378, 556.570, -2676.669, 11.060, 0.00, 0.00, 270.00);
	CreateDynamicObject(12847, 533.789, -2650.110, 16.299, 0.00, 0.00, 270.00);
	CreateDynamicObject(18228, 543.599, -2629.909, 2.200, 0.00, 0.00, 139.99);
	CreateDynamicObject(18228, 503.419, -2633.389, 3.740, 0.00, 0.00, 161.99);
	CreateDynamicObject(3279, 575.429, -2651.209, 12.140, 0.00, 0.00, 181.99);
	CreateDynamicObject(3378, 555.440, -2662.570, 11.060, 0.00, 0.00, 180.00);
	CreateDynamicObject(3378, 555.380, -2640.040, 10.930, 0.10, 0.00, 179.99);
	CreateDynamicObject(11293, 511.299, -2655.590, 17.959, 0.00, 0.00, 0.00);
	CreateDynamicObject(18228, 487.510, -2664.709, 3.740, 0.00, 0.00, 231.97);
	CreateDynamicObject(12814, 566.080, -2702.219, 12.130, 0.00, 0.00, 89.98);
	CreateDynamicObject(12814, 516.119, -2702.300, 12.130, 0.00, 0.00, 269.98);
	CreateDynamicObject(8419, 541.000, -2740.100, 0.430, 0.00, 0.00, 90.00);
	CreateDynamicObject(8419, 538.539, -2792.120, 0.430, 0.00, 0.00, 90.00);
	CreateDynamicObject(12814, 579.440, -2702.139, 12.130, 0.00, 0.00, 89.98);
	CreateDynamicObject(12814, 577.280, -2729.770, 12.130, 0.00, 0.00, 105.98);
	CreateDynamicObject(12814, 582.580, -2745.010, 12.130, 0.00, 0.00, 101.98);
	CreateDynamicObject(18228, 589.020, -2713.320, 7.820, 0.00, 0.00, 77.98);
	CreateDynamicObject(18228, 594.770, -2753.409, 8.850, 0.00, 0.00, 53.97);
	CreateDynamicObject(18228, 592.919, -2801.350, 5.710, 0.00, 0.00, 46.00);
	CreateDynamicObject(18228, 487.159, -2704.949, 3.259, 0.00, 0.00, 231.97);
	CreateDynamicObject(18228, 489.260, -2750.169, 5.260, 0.00, 0.00, 231.97);
	CreateDynamicObject(18228, 489.049, -2785.050, 3.250, 0.00, 0.00, 231.97);
	CreateDynamicObject(10610, 571.380, -2769.959, 22.290, 0.00, 0.00, 270.00);
	CreateDynamicObject(987, 581.380, -2714.320, 12.170, 0.00, 0.00, 180.00);
	CreateDynamicObject(987, 569.450, -2714.330, 12.170, 0.00, 0.00, 179.99);
	CreateDynamicObject(987, 557.510, -2714.310, 12.170, 0.00, 0.00, 179.99);
	CreateDynamicObject(987, 535.469, -2714.310, 12.170, 0.00, 0.00, 179.99);
	CreateDynamicObject(987, 523.510, -2714.310, 12.170, 0.00, 0.00, 179.99);
	CreateDynamicObject(987, 511.559, -2714.310, 12.170, 0.00, 0.00, 179.99);
	CreateDynamicObject(987, 499.590, -2714.280, 12.170, 0.00, 0.00, 179.99);
	CreateDynamicObject(3279, 551.739, -2706.500, 12.170, 0.00, 0.00, 180.00);
	CreateDynamicObject(17007, 566.359, -2700.360, 12.140, 0.00, 0.00, 0.00);
	CreateDynamicObject(18234, 510.150, -2677.770, 12.140, 0.00, 0.00, 180.00);
	CreateDynamicObject(16359, 513.020, -2700.229, 12.130, 0.00, 0.00, 180.00);
	obj = CreateDynamicObject(3378, 540.039, -2702.840, 11.050, 0.20, 0.00, 180.00);
	Streamer_ToggleItemStatic(STREAMER_TYPE_OBJECT, obj, true);
	CreateDynamicObject(3378, 540.010, -2690.780, 11.060, 0.00, 0.00, 179.99);
	CreateDynamicObject(3378, 534.030, -2676.699, 11.060, 0.00, 0.00, 270.00);
	CreateDynamicObject(3378, 511.489, -2676.760, 11.000, 0.30, 0.00, 270.00);
	CreateDynamicObject(8417, 507.400, -2796.489, 12.140, 0.00, 0.00, 90.00);
	CreateDynamicObject(947, 503.940, -2778.669, 14.350, 0.00, 0.00, 178.00);
	CreateDynamicObject(947, 513.130, -2812.790, 14.350, 0.00, 0.00, 358.00);
	CreateDynamicObject(3819, 531.330, -2787.870, 13.140, 0.00, 0.00, 0.00);
	CreateDynamicObject(3819, 531.799, -2802.260, 13.170, 0.00, 0.00, 0.00);
	CreateDynamicObject(2631, 516.809, -2722.850, 12.210, 0.00, 0.00, 270.00);
	CreateDynamicObject(4100, 553.010, -2811.070, 13.850, 0.00, 0.00, 50.00);
	CreateDynamicObject(4100, 553.030, -2804.209, 13.850, 0.00, 0.00, 50.00);
	CreateDynamicObject(18228, 490.020, -2812.010, 3.710, 0.00, 0.00, 265.98);
	CreateDynamicObject(4574, 555.679, -2750.840, 43.590, 0.00, 0.00, 0.00);
	CreateDynamicObject(12814, 563.710, -2832.830, 12.130, 0.00, 0.00, 269.98);
	CreateDynamicObject(12814, 517.010, -2855.270, 12.130, 0.00, 0.00, 105.98);
	CreateDynamicObject(12814, 563.750, -2848.139, 12.130, 0.00, 0.00, 269.98);
	CreateDynamicObject(987, 506.440, -2818.149, 12.170, 0.00, 0.00, 359.98);
	CreateDynamicObject(987, 518.380, -2818.139, 12.170, 0.00, 0.00, 359.98);
	CreateDynamicObject(987, 530.330, -2818.139, 12.170, 0.00, 0.00, 359.98);
	CreateDynamicObject(987, 552.200, -2818.129, 12.170, 0.00, 0.00, 359.98);
	CreateDynamicObject(987, 564.099, -2818.149, 12.170, 0.00, 0.00, 359.98);
	CreateDynamicObject(987, 576.039, -2818.159, 12.130, 0.00, 0.00, 359.98);
	CreateDynamicObject(3279, 562.940, -2810.879, 12.170, 0.00, 0.00, 358.00);
	CreateDynamicObject(3666, 557.210, -2793.870, 33.330, 0.00, 0.00, 0.00);
	CreateDynamicObject(3666, 557.219, -2756.370, 33.330, 0.00, 0.00, 0.00);
	CreateDynamicObject(3666, 581.580, -2756.300, 33.330, 0.00, 0.00, 0.00);
	CreateDynamicObject(3666, 581.570, -2793.820, 33.330, 0.00, 0.00, 0.00);
	CreateDynamicObject(9241, 565.090, -2833.899, 13.840, 0.00, 0.00, 270.00);
	CreateDynamicObject(6295, 512.380, -2845.550, 36.060, 0.00, 0.00, 310.00);
	CreateDynamicObject(18228, 484.369, -2837.610, 7.090, 0.00, 0.00, 243.97);
	CreateDynamicObject(18228, 501.500, -2867.300, 6.000, 0.00, 0.00, 287.98);
	CreateDynamicObject(18228, 556.640, -2913.050, 0.400, 0.00, 0.00, 287.97);
	CreateDynamicObject(18228, 535.739, -2906.090, 4.900, 0.00, 0.00, 287.97);
	CreateDynamicObject(18228, 542.330, -2865.070, 8.050, 0.00, 0.00, 327.97);
	CreateDynamicObject(18228, 575.150, -2866.199, 0.680, 0.00, 0.00, 327.97);
	CreateDynamicObject(18228, 593.940, -2837.699, 2.829, 0.00, 0.00, 53.97);
	CreateDynamicObject(18228, 575.299, -2915.790, 3.680, 0.00, 0.00, 7.96);
	CreateDynamicObject(18228, 601.359, -2884.770, -0.870, 0.00, 0.00, 7.96);
	CreateDynamicObject(18228, 630.580, -2852.149, -0.800, 0.00, 0.00, 19.95);
	CreateDynamicObject(18228, 632.409, -2820.939, -0.750, 0.00, 0.00, 115.97);
	CreateDynamicObject(12814, 514.380, -2833.219, 12.130, 0.00, 0.00, 89.98);
	CreateDynamicObject(12814, 557.969, -2902.689, 5.440, 0.00, 0.00, 139.99);
	CreateDynamicObject(12814, 541.820, -2894.060, 5.440, 0.00, 0.00, 139.99);
	CreateDynamicObject(12814, 587.659, -2874.560, 5.440, 0.00, 0.00, 319.98);
	CreateDynamicObject(12814, 615.140, -2842.790, 1.500, 0.00, 0.00, 149.97);
	CreateDynamicObject(669, 622.789, -2708.889, 2.150, 0.00, 0.00, 0.00);
	CreateDynamicObject(672, 631.530, -2667.199, 6.260, 0.00, 0.00, 0.00);
	CreateDynamicObject(691, 646.919, -2716.129, 1.250, 0.00, 0.00, 310.00);
	CreateDynamicObject(703, 640.150, -2691.590, 6.260, 0.00, 0.00, 0.00);
	CreateDynamicObject(618, 629.390, -2734.629, 1.250, 0.00, 0.00, 0.00);
	CreateDynamicObject(672, 656.549, -2841.860, 1.250, 0.00, 0.00, 0.00);
	CreateDynamicObject(691, 672.030, -2732.330, 1.250, 0.00, 0.00, 0.00);
	CreateDynamicObject(703, 675.700, -2733.389, 1.250, 0.00, 0.00, 200.00);
	CreateDynamicObject(703, 662.750, -2815.219, 0.500, 0.00, 0.00, 0.00);
	CreateDynamicObject(708, 645.039, -2863.280, 0.750, 0.00, 0.00, 0.00);
	CreateDynamicObject(707, 630.900, -2887.260, 0.000, 0.00, 0.00, 0.00);
	CreateDynamicObject(705, 598.690, -2912.389, 0.500, 0.00, 0.00, 0.00);
	CreateDynamicObject(703, 568.309, -2665.760, 4.920, 0.00, 0.00, 0.00);
	CreateDynamicObject(691, 554.599, -2686.000, 12.130, 0.00, 0.00, 0.00);
	CreateDynamicObject(671, 549.179, -2669.979, 12.130, 0.00, 0.00, 0.00);
	CreateDynamicObject(671, 538.450, -2670.409, 12.140, 0.00, 0.00, 0.00);
	CreateDynamicObject(671, 527.419, -2670.530, 12.140, 0.00, 0.00, 0.00);
	CreateDynamicObject(671, 518.729, -2670.899, 12.140, 0.00, 0.00, 0.00);
	CreateDynamicObject(703, 529.780, -2689.120, 12.130, 0.00, 0.00, 0.00);
	CreateDynamicObject(707, 505.179, -2699.560, 11.630, 0.00, 0.00, 0.00);
	CreateDynamicObject(672, 532.760, -2702.280, 12.130, 0.00, 0.00, 0.00);
	CreateDynamicObject(703, 502.239, -2658.209, 12.140, 0.00, 0.00, 0.00);
	CreateDynamicObject(703, 516.309, -2826.419, 12.140, 0.00, 0.00, 0.00);
	CreateDynamicObject(691, 530.419, -2848.500, 11.380, 0.00, 0.00, 0.00);
	CreateDynamicObject(691, 498.780, -2830.419, 12.140, 0.00, 0.00, 0.00);
	CreateDynamicObject(703, 501.429, -2846.969, 11.390, 0.00, 0.00, 0.00);
	CreateDynamicObject(706, 552.559, -2894.000, 5.460, 0.00, 0.00, 0.00);
	CreateDynamicObject(708, 577.679, -2884.000, 5.460, 0.00, 0.00, 0.00);
	CreateDynamicObject(707, 570.479, -2897.679, 5.440, 0.00, 0.00, 0.00);
	CreateDynamicObject(709, 617.520, -2837.739, 1.500, 0.00, 0.00, 0.00);
	CreateDynamicObject(3517, 578.679, -2857.489, 23.309, 0.00, 0.00, 0.00);
	CreateDynamicObject(616, 565.549, -2858.830, 12.130, 0.00, 0.00, 0.00);
	CreateDynamicObject(617, 586.190, -2847.550, 12.130, 0.00, 0.00, 0.00);
	CreateDynamicObject(618, 587.140, -2833.280, 12.130, 0.00, 0.00, 0.00);
	CreateDynamicObject(669, 544.460, -2855.360, 12.130, 0.00, 0.00, 0.00);
	CreateDynamicObject(672, 534.960, -2823.860, 12.140, 0.00, 0.00, 0.00);
	CreateDynamicObject(3378, 667.760, -2806.300, -7.300, 360.00, 90.00, 0.10);
	CreateDynamicObject(3378, 711.539, -2778.040, -7.280, 360.00, 90.00, 270.20);
	CreateDynamicObject(3268, 705.000, -2763.649, 1.250, 0.00, 0.00, 270.00);
	CreateDynamicObject(3378, 668.809, -2770.820, 0.109, 359.75, 0.00, 270.00);
	CreateDynamicObject(3378, 688.979, -2770.790, 0.090, 0.00, 0.00, 270.00);
	CreateDynamicObject(3378, 711.520, -2770.709, 0.090, 0.00, 0.00, 270.00);
	CreateDynamicObject(3378, 721.570, -2756.580, -7.280, 360.00, 90.00, 0.10);
	CreateDynamicObject(3378, 721.619, -2767.879, -7.280, 360.00, 90.00, 0.30);
	CreateDynamicObject(3378, 683.309, -2769.020, -1.580, 359.79, 90.00, 90.00);
	CreateDynamicObject(3378, 712.520, -2756.580, -1.580, 359.79, 90.00, 180.00);
	CreateDynamicObject(3378, 705.840, -2769.020, -7.280, 359.79, 90.00, 90.00);
	CreateDynamicObject(3378, 714.229, -2756.590, 0.090, 0.00, 0.00, 0.00);
	CreateDynamicObject(3378, 714.169, -2746.379, -10.050, 90.00, 90.00, 90.00);
	CreateDynamicObject(3378, 712.520, -2756.580, -7.280, 359.79, 90.00, 180.00);
	CreateDynamicObject(3378, 688.289, -2756.679, -1.580, 359.79, 90.00, 180.00);
	CreateDynamicObject(3378, 689.960, -2746.570, -10.050, 90.00, 90.00, 90.00);
	CreateDynamicObject(3378, 695.609, -2746.570, -10.050, 90.00, 90.00, 90.00);
	CreateDynamicObject(3378, 697.369, -2756.679, -1.600, 360.00, 90.00, 0.30);
	CreateDynamicObject(947, 524.330, -2812.899, 14.350, 0.00, 0.00, 358.00);
	CreateDynamicObject(947, 513.150, -2778.479, 14.350, 0.00, 0.00, 178.00);
	CreateDynamicObject(3819, 501.119, -2753.629, 13.140, 0.00, 0.00, 180.00);
	CreateDynamicObject(3819, 510.789, -2745.379, 13.140, 0.00, 0.00, 90.00);
	CreateDynamicObject(1985, 162.470, 371.020, 1002.950, 0.00, 0.00, 0.00);
	CreateDynamicObject(2629, 519.239, -2721.790, 12.170, 0.00, 0.00, 0.00);
	CreateDynamicObject(2628, 512.479, -2724.600, 12.140, 0.00, 0.00, 90.00);
	CreateDynamicObject(2631, 551.039, -2780.100, 12.210, 0.00, 0.00, 0.00);
	CreateDynamicObject(2629, 551.780, -2777.899, 12.170, 0.00, 0.00, 270.00);
	CreateDynamicObject(2629, 551.849, -2782.030, 12.170, 0.00, 0.00, 270.00);
	CreateDynamicObject(2628, 549.809, -2783.989, 12.140, 0.00, 0.00, 180.00);
	CreateDynamicObject(2628, 549.580, -2775.919, 12.140, 0.00, 0.00, 0.00);
	CreateDynamicObject(987, 494.559, -2818.139, 12.170, 0.00, 0.00, 359.98);
	CreateDynamicObject(14780, 510.789, -2753.669, 12.760, 0.00, 0.00, 0.00);
	CreateDynamicObject(3819, 511.049, -2762.729, 13.140, 0.00, 0.00, 270.00);
	CreateDynamicObject(933, 716.929, -2754.709, 1.200, 0.00, 0.00, 0.00);
	CreateDynamicObject(933, 718.500, -2756.270, 1.200, 0.00, 0.00, 0.00);
	CreateDynamicObject(933, 717.890, -2755.280, 2.150, 0.00, 0.00, 0.00);
	CreateDynamicObject(2673, 497.750, -2716.310, 12.260, 0.00, 0.00, 0.00);
	CreateDynamicObject(2673, 497.429, -2722.199, 12.260, 0.00, 0.00, 0.00);
	CreateDynamicObject(2673, 504.859, -2718.580, 12.260, 0.00, 0.00, 0.00);
	CreateDynamicObject(2674, 498.229, -2721.209, 12.260, 0.00, 0.00, 0.00);
	CreateDynamicObject(2677, 499.500, -2717.949, 12.260, 0.00, 0.00, 0.00);
	CreateDynamicObject(2671, 501.580, -2719.070, 12.170, 0.00, 0.00, 0.00);
	CreateDynamicObject(703, 607.559, -2668.429, 6.260, 0.00, 0.00, 0.00);
	CreateDynamicObject(672, 585.080, -2667.330, 6.090, 0.00, 0.00, 0.00);
	CreateDynamicObject(3055, 539.630, -2640.040, 22.829, 0.00, 0.00, 0.00);
	CreateDynamicObject(3055, 539.630, -2639.909, 22.829, 0.00, 0.00, 0.00);
	CreateDynamicObject(987, 529.390, -2726.159, 12.170, 0.00, 0.00, 90.00);
	CreateDynamicObject(987, 551.609, -2714.330, 12.170, 0.00, 0.00, 270.00);
	CreateDynamicObject(987, 551.460, -2736.370, 12.170, 0.00, 0.00, 279.00);
	CreateDynamicObject(987, 529.390, -2738.169, 12.170, 0.00, 0.00, 90.00);
	CreateDynamicObject(987, 535.190, -2748.379, 12.170, 0.00, 0.00, 120.00);
	CreateDynamicObject(987, 557.320, -2748.419, 12.170, 0.00, 0.00, 180.00);
	CreateDynamicObject(947, 504.349, -2812.790, 14.350, 0.00, 0.00, 358.00);
	CreateDynamicObject(947, 524.159, -2778.659, 14.350, 0.00, 0.00, 178.00);
	CreateDynamicObject(3819, 520.619, -2753.629, 13.140, 0.00, 0.00, 0.00);
	CreateDynamicObject(2629, 514.419, -2721.879, 12.170, 0.00, 0.00, 0.00);
	CreateDynamicObject(2628, 521.010, -2724.280, 12.140, 0.00, 0.00, 270.00);
	CreateDynamicObject(1538, 552.429, -2646.659, 12.470, 0.00, 0.00, 90.00);
	CreateDynamicObject(1538, 552.450, -2643.659, 12.470, 0.00, 0.00, 270.00);
	CreateDynamicObject(1533, 569.369, -2749.310, 12.149, 0.00, 0.00, 180.00);
	CreateDynamicObject(1533, 570.869, -2749.330, 12.149, 0.00, 0.00, 180.00);
	CreateDynamicObject(746, 572.929, -2805.860, 12.149, 0.00, 0.00, 41.13);
	CreateDynamicObject(749, 499.849, -2803.179, 12.130, 0.00, 0.00, 0.00);
	CreateDynamicObject(762, 502.330, -2720.389, 12.020, 0.00, 0.00, 0.00);
	CreateDynamicObject(807, 520.200, -2770.439, 12.390, 0.00, 0.00, 0.00);
	CreateDynamicObject(807, 529.880, -2761.429, 12.390, 0.00, 0.00, -0.46);
	CreateDynamicObject(807, 524.190, -2738.010, 12.390, 0.00, 0.00, -0.46);
	CreateDynamicObject(816, 524.640, -2768.149, 12.390, 0.00, 0.00, -0.46);
	CreateDynamicObject(807, 529.270, -2770.659, 12.390, 0.00, 0.00, -0.46);
	CreateDynamicObject(816, 510.099, -2770.969, 12.390, 0.00, 0.00, -0.46);
	CreateDynamicObject(819, 549.219, -2751.870, 12.390, 0.00, 0.00, -0.46);
	CreateDynamicObject(825, 557.520, -2806.260, 12.390, 0.00, 0.00, -0.46);
	CreateDynamicObject(825, 556.900, -2814.040, 12.390, 0.00, 0.00, -0.46);
	CreateDynamicObject(874, 503.190, -2790.770, 11.729, 0.00, 0.00, -0.46);
	CreateDynamicObject(831, 525.809, -2825.169, 12.390, 0.00, 0.00, -0.46);
	CreateDynamicObject(874, 506.140, -2730.919, 11.729, 0.00, 0.00, 127.00);
	CreateDynamicObject(874, 551.909, -2768.219, 11.729, 0.00, 0.00, 185.00);
	CreateDynamicObject(879, 532.059, -2736.860, 11.729, 0.00, 0.00, 185.00);
	CreateDynamicObject(880, 547.510, -2721.070, 11.729, 0.00, 0.00, 47.00);
	CreateDynamicObject(987, 590.039, -2671.750, 12.170, 0.00, 0.00, 90.00);
	CreateDynamicObject(987, 590.030, -2693.520, 12.170, 0.00, 0.00, 90.00);
	CreateDynamicObject(987, 590.030, -2659.840, 12.170, 0.00, 0.00, 90.00);
	CreateDynamicObject(987, 633.099, -2704.129, 3.769, 0.00, 0.00, 0.00);
	CreateDynamicObject(987, 611.229, -2704.139, 3.769, 0.00, 0.00, 0.00);

	// Главный блок с камерами (interior)
	CreateDynamicObject(19380, 711.809, -2904.530, 1699.319, 0.00, 90.00, 0.00);	//	пол у входа
	CreateDynamicObject(19380, 711.809, -2971.949, 1699.319, 0.00, 90.00, 0.00);	//	пол у входа
	CreateDynamicObject(19380, 701.309, -2904.530, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 690.809, -2904.530, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 690.809, -2914.030, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 701.309, -2914.159, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 711.809, -2914.159, 1699.319, 0.00, 90.00, 0.00);
	//CreateDynamicObject(19380, 691.279, -2923.639, 1699.318, 0.00, 90.00, 0.00);	//	пол у место под фото	(перенесен в мод)
	CreateDynamicObject(19380, 701.309, -2923.790, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 722.309, -2914.159, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 711.809, -2923.790, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 722.309, -2923.790, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 722.309, -2933.419, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 711.809, -2933.419, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 701.309, -2933.419, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 732.809, -2914.159, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 732.809, -2923.790, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 732.809, -2933.419, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 701.309, -2943.050, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 711.809, -2943.050, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 722.309, -2943.050, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 701.309, -2952.679, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 711.809, -2952.679, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 722.309, -2952.679, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 701.309, -2962.320, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 711.809, -2962.320, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 722.309, -2962.320, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 701.309, -2971.949, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 722.309, -2971.949, 1699.319, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 709.979, -2973.439, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 699.479, -2973.439, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 720.479, -2973.439, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 699.010, -2963.810, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 699.010, -2954.179, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 699.010, -2944.550, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 699.479, -2934.919, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 721.080, -2963.810, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 721.080, -2954.179, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 721.080, -2944.550, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 720.479, -2934.919, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 709.979, -2934.929, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 699.479, -2925.290, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 709.979, -2925.290, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 720.479, -2925.290, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 730.979, -2934.919, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 730.979, -2925.290, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 699.479, -2915.669, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 709.979, -2915.669, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 720.479, -2915.669, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 730.979, -2915.669, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 709.979, -2906.040, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 699.479, -2906.040, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 688.979, -2906.040, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 688.979, -2915.669, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 688.979, -2925.290, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 709.979, -2896.409, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 699.479, -2896.409, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 688.979, -2896.409, 1702.780, 0.00, 90.00, 0.00);
	CreateDynamicObject(3944, 721.799, -2944.969, 1698.900, 0.00, 0.00, 270.25);
	CreateDynamicObject(3944, 721.869, -2962.949, 1698.900, 0.00, 0.00, 270.25);
	CreateDynamicObject(3944, 724.869, -2972.850, 1698.900, 0.00, 0.00, 0.25);
	CreateDynamicObject(3944, 724.869, -2969.129, 1698.900, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 706.789, -2971.219, 1698.900, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 695.260, -2973.010, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 695.250, -2969.250, 1698.900, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 698.659, -2961.100, 1698.900, 0.00, 0.00, 90.48);
	CreateDynamicObject(14437, 701.849, -2968.600, 1700.859, 0.00, 0.00, 270.50);
	CreateDynamicObject(3944, 721.869, -2962.949, 1702.400, 0.00, 0.00, 270.25);
	CreateDynamicObject(3944, 724.809, -2969.129, 1702.400, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 706.780, -2971.219, 1702.380, 0.00, 0.00, 180.24);
	CreateDynamicObject(8661, 716.450, -2962.280, 1706.349, 0.00, 179.99, 0.00);
	CreateDynamicObject(14437, 701.849, -2968.600, 1704.890, 0.00, 0.00, 270.48);
	CreateDynamicObject(3944, 693.479, -2968.340, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 693.460, -2964.590, 1698.900, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 693.460, -2964.590, 1702.400, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 693.479, -2968.340, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 698.659, -2961.100, 1702.380, 0.00, 0.00, 90.48);
	CreateDynamicObject(14437, 701.799, -2963.850, 1704.930, 0.00, 0.00, 270.48);
	CreateDynamicObject(14437, 701.799, -2963.850, 1700.859, 0.00, 0.00, 270.48);
	CreateDynamicObject(3944, 693.520, -2963.590, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 693.520, -2963.590, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 693.510, -2959.830, 1698.900, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 693.510, -2959.830, 1702.380, 0.00, 0.00, 180.24);
	CreateDynamicObject(14437, 701.799, -2959.090, 1700.859, 0.00, 0.00, 270.48);
	CreateDynamicObject(14437, 701.799, -2959.090, 1704.890, 0.00, 0.00, 270.48);
	CreateDynamicObject(3944, 721.799, -2944.919, 1702.400, 0.00, 0.00, 270.25);
	CreateDynamicObject(14437, 701.780, -2954.409, 1700.859, 0.00, 0.00, 270.73);
	CreateDynamicObject(14437, 701.780, -2954.409, 1704.890, 0.00, 0.00, 270.73);
	CreateDynamicObject(8661, 716.479, -2942.300, 1706.349, 0.00, 179.99, 0.00);
	CreateDynamicObject(3944, 693.520, -2958.820, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 693.520, -2958.820, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 693.510, -2955.070, 1698.900, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 693.500, -2955.070, 1702.380, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 698.510, -2943.090, 1698.900, 0.00, 0.00, 90.47);
	CreateDynamicObject(3944, 698.510, -2943.090, 1702.400, 0.00, 0.00, 90.48);
	CreateDynamicObject(3944, 693.479, -2954.139, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 693.479, -2954.139, 1702.390, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 693.469, -2950.389, 1698.900, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 693.469, -2950.389, 1702.390, 0.00, 0.00, 180.24);
	CreateDynamicObject(16101, 716.010, -2966.169, 1702.849, 0.00, 179.99, 0.00);
	CreateDynamicObject(16101, 716.020, -2956.750, 1702.849, 0.00, 179.99, 0.00);
	CreateDynamicObject(16101, 704.049, -2966.330, 1702.849, 0.00, 179.99, 0.00);
	CreateDynamicObject(16101, 704.090, -2957.020, 1702.849, 0.00, 179.99, 0.00);
	CreateDynamicObject(3944, 695.250, -2969.250, 1702.400, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 695.260, -2973.010, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(14437, 701.729, -2949.649, 1704.890, 0.00, 0.00, 270.73);
	CreateDynamicObject(14437, 701.729, -2949.649, 1700.849, 0.00, 0.00, 270.73);
	CreateDynamicObject(3944, 693.450, -2949.389, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 693.450, -2949.389, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 693.440, -2945.629, 1702.390, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 693.440, -2945.629, 1698.900, 0.00, 0.00, 180.24);
	CreateDynamicObject(14437, 701.650, -2944.919, 1704.890, 0.00, 0.00, 270.73);
	CreateDynamicObject(3944, 693.390, -2944.649, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(14437, 701.650, -2944.919, 1700.849, 0.00, 0.00, 270.73);
	CreateDynamicObject(3944, 693.369, -2940.899, 1702.390, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 693.390, -2940.860, 1698.900, 0.00, 0.00, 180.24);
	CreateDynamicObject(14437, 701.659, -2940.179, 1704.890, 0.00, 0.00, 270.73);
	CreateDynamicObject(3944, 693.390, -2939.909, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 693.390, -2936.149, 1702.390, 0.00, 0.00, 180.24);
	CreateDynamicObject(14437, 701.650, -2940.179, 1700.849, 0.00, 0.00, 270.73);
	CreateDynamicObject(3944, 693.390, -2939.909, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 693.390, -2936.149, 1698.900, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 726.200, -2940.610, 1702.400, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 726.210, -2945.379, 1702.400, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 726.289, -2950.120, 1702.400, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 726.349, -2954.870, 1702.400, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 726.349, -2959.610, 1702.400, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 726.340, -2964.360, 1702.400, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 726.340, -2964.360, 1698.949, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 726.349, -2959.610, 1698.900, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 726.349, -2954.870, 1698.910, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 726.289, -2950.120, 1698.939, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 726.210, -2945.379, 1698.939, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 726.200, -2944.290, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 726.200, -2940.610, 1698.949, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 726.200, -2944.290, 1698.920, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 726.210, -2949.060, 1698.920, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 726.210, -2949.060, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 726.280, -2953.790, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 726.280, -2953.790, 1698.920, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 726.359, -2958.540, 1698.920, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 726.359, -2958.540, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 726.340, -2963.280, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 726.340, -2963.280, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 726.330, -2968.040, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 726.330, -2968.040, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 726.200, -2939.560, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 726.200, -2939.560, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 726.190, -2935.879, 1698.949, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 726.190, -2935.879, 1702.400, 0.00, 0.00, 180.24);
	CreateDynamicObject(16101, 715.969, -2947.169, 1702.849, 0.00, 179.99, 0.00);
	CreateDynamicObject(16101, 715.979, -2937.830, 1702.849, 0.00, 179.99, 0.00);
	CreateDynamicObject(16101, 703.940, -2947.449, 1702.849, 0.00, 179.99, 0.00);
	CreateDynamicObject(16101, 703.960, -2938.030, 1702.849, 0.00, 179.99, 0.00);
	CreateDynamicObject(3944, 714.260, -2927.879, 1698.900, 0.00, 0.00, 270.25);
	CreateDynamicObject(3944, 699.700, -2935.699, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 696.119, -2937.860, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 696.099, -2935.850, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 696.119, -2937.860, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 696.099, -2935.850, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 699.679, -2931.949, 1698.949, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 699.690, -2935.679, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 699.679, -2931.949, 1702.400, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 716.789, -2931.879, 1701.420, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 720.789, -2931.860, 1698.910, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 720.789, -2935.540, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 720.780, -2935.530, 1702.400, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 703.000, -2935.669, 1701.420, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 720.780, -2931.850, 1702.380, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 703.200, -2935.659, 1702.380, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 717.289, -2931.840, 1702.380, 0.00, 0.00, 180.24);
	CreateDynamicObject(2774, 710.419, -2944.340, 1711.810, 0.00, 0.00, 0.00);
	CreateDynamicObject(2774, 710.280, -2957.870, 1711.810, 0.00, 0.00, 0.00);
	CreateDynamicObject(3944, 693.400, -2944.610, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 714.260, -2927.879, 1702.380, 0.00, 0.00, 270.25);
	CreateDynamicObject(14414, 710.030, -2966.800, 1699.650, 0.00, 0.00, 0.00);
	CreateDynamicObject(14414, 710.010, -2961.510, 1699.530, 359.94, 179.94, 180.11);
	CreateDynamicObject(970, 704.200, -2966.580, 1703.250, 0.00, 179.99, 270.00);
	CreateDynamicObject(970, 704.200, -2962.429, 1703.250, 0.00, 179.99, 270.00);
	CreateDynamicObject(970, 704.200, -2958.360, 1703.250, 0.00, 179.99, 270.00);
	CreateDynamicObject(970, 704.190, -2941.679, 1703.250, 0.00, 179.99, 270.00);
	CreateDynamicObject(970, 704.190, -2945.840, 1703.250, 0.00, 179.99, 270.00);
	CreateDynamicObject(970, 704.200, -2950.010, 1703.250, 0.00, 179.99, 270.00);
	CreateDynamicObject(970, 704.200, -2954.189, 1703.250, 0.00, 179.99, 270.00);
	CreateDynamicObject(970, 706.309, -2939.649, 1703.250, 0.00, 179.99, 180.27);
	CreateDynamicObject(970, 709.719, -2939.629, 1703.250, 0.00, 179.99, 180.27);
	CreateDynamicObject(970, 713.799, -2939.610, 1703.250, 0.00, 179.99, 180.27);
	CreateDynamicObject(970, 706.260, -2968.689, 1703.250, 0.00, 179.99, 180.27);
	CreateDynamicObject(970, 715.869, -2941.679, 1703.250, 0.00, 179.99, 270.00);
	CreateDynamicObject(970, 715.890, -2945.810, 1703.250, 0.00, 179.99, 270.00);
	CreateDynamicObject(970, 715.880, -2949.939, 1703.250, 0.00, 179.99, 270.00);
	CreateDynamicObject(970, 715.880, -2954.060, 1703.250, 0.00, 179.99, 270.00);
	CreateDynamicObject(970, 715.869, -2958.189, 1703.250, 0.00, 179.99, 270.00);
	CreateDynamicObject(970, 715.869, -2962.310, 1703.250, 0.00, 179.99, 270.00);
	CreateDynamicObject(970, 715.869, -2966.580, 1703.250, 0.00, 179.99, 270.00);
	CreateDynamicObject(970, 713.820, -2968.659, 1703.250, 0.00, 179.99, 180.27);

	CreateDynamicObject(1886, 715.219, -2971.719, 1702.719, 20.00, 0.00, 251.00);
	CreateDynamicObject(1886, 704.729, -2971.750, 1706.439, 20.17, 359.17, 149.02);
	CreateDynamicObject(1886, 702.710, -2937.580, 1702.680, 4.92, 359.26, 25.84);
	CreateDynamicObject(1886, 702.400, -2910.699, 1702.800, 20.92, 359.22, 135.72);
	CreateDynamicObject(1432, 712.469, -2948.340, 1699.430, 0.00, 0.00, 0.00);
	CreateDynamicObject(1432, 707.210, -2946.399, 1699.430, 0.00, 0.00, 0.00);
	CreateDynamicObject(1432, 708.270, -2950.350, 1699.430, 0.00, 0.00, 324.00);
	CreateDynamicObject(1771, 699.179, -2940.919, 1700.060, 0.00, 0.00, 267.98);
	CreateDynamicObject(1771, 699.140, -2945.709, 1700.060, 0.00, 0.00, 267.98);
	CreateDynamicObject(1771, 699.140, -2950.459, 1700.060, 0.00, 0.00, 267.98);
	CreateDynamicObject(1771, 699.210, -2955.120, 1700.060, 0.00, 0.00, 267.98);
	CreateDynamicObject(1771, 699.200, -2959.909, 1700.060, 0.00, 0.00, 267.98);
	CreateDynamicObject(1771, 699.409, -2964.629, 1700.060, 0.00, 0.00, 267.98);
	CreateDynamicObject(1771, 699.369, -2969.300, 1700.060, 0.00, 0.00, 267.98);
	CreateDynamicObject(1771, 699.369, -2969.300, 1703.530, 0.00, 0.00, 267.98);
	CreateDynamicObject(1771, 699.169, -2964.669, 1703.530, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 699.150, -2959.909, 1703.530, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 699.090, -2955.090, 1703.530, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 699.039, -2950.550, 1703.530, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 698.969, -2945.709, 1703.530, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 698.960, -2940.989, 1703.530, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 721.289, -2939.520, 1703.530, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 721.299, -2944.250, 1703.530, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 721.359, -2948.949, 1703.530, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 721.380, -2953.760, 1703.530, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 721.349, -2958.389, 1703.530, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 721.369, -2963.120, 1703.530, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 721.359, -2967.899, 1703.530, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 721.299, -2967.979, 1699.959, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 720.919, -2963.260, 1699.959, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 721.200, -2958.419, 1699.959, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 721.330, -2953.689, 1699.959, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 721.039, -2948.909, 1699.959, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 721.280, -2944.209, 1699.959, 0.00, 0.00, 268.57);
	CreateDynamicObject(1771, 720.880, -2939.500, 1699.959, 0.00, 0.00, 268.54);
	CreateDynamicObject(3944, 699.739, -2923.439, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 699.669, -2933.689, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 699.650, -2931.679, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 699.640, -2927.929, 1698.949, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 699.719, -2919.689, 1698.949, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 714.190, -2907.820, 1698.900, 0.00, 0.00, 270.25);
	CreateDynamicObject(3944, 717.830, -2927.929, 1698.910, 0.00, 0.00, 89.36);
	CreateDynamicObject(3944, 706.059, -2914.030, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 681.640, -2919.780, 1698.949, 0.00, 0.00, 180.24);
	CreateDynamicObject(3944, 691.419, -2913.250, 1698.900, 0.00, 0.00, 90.47);
	CreateDynamicObject(3944, 697.770, -2924.699, 1698.900, 0.00, 0.00, 270.25);
	CreateDynamicObject(3944, 706.039, -2910.330, 1698.949, 0.00, 0.00, 180.41);
	CreateDynamicObject(3944, 726.109, -2917.639, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 691.440, -2895.179, 1698.900, 0.00, 0.00, 89.36);
	CreateDynamicObject(3944, 695.849, -2901.729, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 713.940, -2901.570, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 728.830, -2924.070, 1698.900, 0.00, 0.00, 270.25);
	CreateDynamicObject(2774, 723.340, -2925.479, 1711.810, 0.00, 0.00, 358.07);
	CreateDynamicObject(2774, 709.000, -2905.699, 1711.810, 0.00, 0.00, 0.00);
	CreateDynamicObject(2165, 708.190, -2927.040, 1699.430, 0.00, 0.00, 270.00);
	CreateDynamicObject(2166, 707.179, -2924.879, 1699.430, 0.00, 0.00, 270.00);
	CreateDynamicObject(2774, 710.469, -2916.659, 1711.810, 0.00, 0.00, 0.00);
	CreateDynamicObject(1715, 706.700, -2927.580, 1699.430, 0.00, 0.00, 90.00);
	CreateDynamicObject(2186, 702.820, -2928.290, 1699.430, 0.00, 0.00, 180.00);
	CreateDynamicObject(1893, 702.159, -2924.899, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 706.500, -2924.899, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 711.599, -2928.879, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 711.599, -2920.780, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 713.630, -2911.570, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 705.000, -2918.399, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 694.450, -2916.830, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1744, 703.849, -2922.550, 1700.989, 0.00, 0.00, 0.00);
	CreateDynamicObject(2007, 703.780, -2923.020, 1699.430, 0.00, 0.00, 0.00);
	CreateDynamicObject(2007, 704.770, -2923.030, 1699.430, 0.00, 0.00, 0.00);
	CreateDynamicObject(2606, 700.969, -2925.120, 1701.239, 0.00, 0.00, 90.47);
	CreateDynamicObject(2606, 700.969, -2925.120, 1702.099, 0.00, 0.00, 90.47);
	CreateDynamicObject(2606, 700.969, -2925.120, 1701.670, 0.00, 0.00, 90.48);
	CreateDynamicObject(2737, 705.570, -2928.709, 1701.089, 0.00, 0.00, 180.27);
	CreateDynamicObject(2608, 700.909, -2925.159, 1700.030, 0.00, 0.00, 90.40);
	CreateDynamicObject(1495, 708.760, -2934.629, 1699.420, 0.00, 0.00, 0.00);
	//CreateDynamicObject(1495, 711.760, -2934.610, 1699.420, 0.00, 0.00, 180.00);
	//CreateDynamicObject(1495, 711.739, -2932.830, 1699.420, 0.00, 0.00, 180.00);
	CreateDynamicObject(1495, 708.729, -2932.870, 1699.420, 0.00, 0.00, 0.00);
	CreateDynamicObject(2922, 712.059, -2932.750, 1700.739, 0.00, 0.00, 0.00);
	CreateDynamicObject(3944, 685.000, -2914.209, 1698.900, 0.00, 0.00, 0.49);
	CreateDynamicObject(3944, 684.989, -2910.479, 1698.949, 0.00, 0.00, 180.41);
	CreateDynamicObject(1495, 697.010, -2912.149, 1699.420, 0.00, 0.00, 180.00);
	//CreateDynamicObject(1495, 694.010, -2912.189, 1699.420, 0.00, 0.00, 360.00);
	CreateDynamicObject(3944, 703.030, -2910.350, 1701.439, 0.00, 0.00, 180.41);
	CreateDynamicObject(3944, 702.780, -2914.060, 1701.420, 0.00, 0.00, 0.49);
	CreateDynamicObject(2922, 693.599, -2911.290, 1701.020, 0.00, 0.00, 0.00);
	CreateDynamicObject(2922, 697.369, -2913.250, 1701.020, 0.00, 0.00, 181.02);
	CreateDynamicObject(2137, 717.429, -2930.300, 1699.430, 0.00, 0.00, 90.00);
	CreateDynamicObject(2137, 717.429, -2931.270, 1699.430, 0.00, 0.00, 90.00);
	CreateDynamicObject(2140, 717.429, -2929.320, 1699.430, 0.00, 359.89, 89.91);
	CreateDynamicObject(2305, 717.440, -2932.229, 1699.430, 0.00, 0.00, 180.00);
	CreateDynamicObject(2137, 718.429, -2932.229, 1699.430, 0.00, 0.00, 179.72);
	CreateDynamicObject(2137, 719.390, -2932.239, 1699.430, 0.00, 0.00, 179.72);
	CreateDynamicObject(2136, 723.299, -2932.250, 1699.439, 0.00, 0.00, 180.05);
	CreateDynamicObject(2135, 720.349, -2932.250, 1699.430, 0.00, 0.00, 179.80);
	CreateDynamicObject(2139, 721.330, -2932.229, 1699.430, 0.00, 0.00, 179.99);
	CreateDynamicObject(2986, 709.750, -2949.580, 1706.319, 0.00, 180.00, 0.00);
	CreateDynamicObject(1811, 721.190, -2927.959, 1700.040, 0.00, 0.00, 88.66);
	CreateDynamicObject(2357, 722.640, -2929.219, 1699.819, 0.00, 0.00, 0.00);
	CreateDynamicObject(1811, 722.219, -2927.969, 1700.040, 0.00, 0.00, 88.65);
	CreateDynamicObject(1811, 723.219, -2928.000, 1700.040, 0.00, 0.00, 88.65);
	CreateDynamicObject(1811, 724.239, -2928.010, 1700.040, 0.00, 0.00, 88.65);
	CreateDynamicObject(1811, 724.109, -2930.469, 1700.040, 0.00, 0.00, 269.64);
	CreateDynamicObject(1811, 723.159, -2930.439, 1700.040, 0.00, 0.00, 269.35);
	CreateDynamicObject(1811, 722.229, -2930.419, 1700.040, 0.00, 0.00, 269.35);
	CreateDynamicObject(1811, 721.210, -2930.419, 1700.040, 0.00, 0.00, 269.35);
	CreateDynamicObject(2290, 727.590, -2921.860, 1699.430, 0.00, 0.00, 178.82);
	CreateDynamicObject(2290, 729.130, -2918.399, 1699.430, 0.00, 0.00, 269.76);
	CreateDynamicObject(2239, 728.799, -2921.669, 1699.430, 0.00, 0.00, 170.00);
	CreateDynamicObject(1754, 724.049, -2920.540, 1699.430, 0.00, 0.00, 120.00);
	CreateDynamicObject(1814, 726.229, -2920.080, 1699.430, 0.00, 0.00, 0.00);
	CreateDynamicObject(1778, 717.250, -2928.879, 1699.430, 0.00, 0.00, 190.00);
	CreateDynamicObject(2297, 726.000, -2917.090, 1699.430, 0.00, 0.00, 315.47);
	CreateDynamicObject(2964, 720.299, -2921.500, 1699.400, 0.00, 0.00, 88.47);
	CreateDynamicObject(3004, 720.200, -2922.199, 1700.300, 0.00, 0.00, 343.98);
	CreateDynamicObject(3106, 720.200, -2921.399, 1700.400, 0.00, 0.00, 0.00);
	CreateDynamicObject(3105, 720.700, -2921.100, 1700.400, 0.00, 0.00, 0.00);
	CreateDynamicObject(3103, 719.840, -2921.580, 1700.180, 0.00, 0.00, 0.00);
	CreateDynamicObject(3102, 719.869, -2921.580, 1700.209, 0.00, 0.00, 0.00);
	CreateDynamicObject(3042, 710.280, -2957.030, 1705.459, 0.00, 0.00, 0.00);
	CreateDynamicObject(2611, 729.669, -2929.429, 1701.150, 0.00, 0.00, 270.19);
	CreateDynamicObject(2612, 729.559, -2924.860, 1701.130, 0.00, 0.00, 270.19);
	CreateDynamicObject(18070, 699.440, -2907.610, 1699.910, 0.00, 0.00, 90.00);
	CreateDynamicObject(18070, 699.369, -2898.500, 1699.910, 0.00, 0.00, 90.48);
	CreateDynamicObject(1892, 701.559, -2902.510, 1699.430, 0.00, 0.00, 270.00);
	CreateDynamicObject(2422, 699.869, -2904.939, 1700.420, 0.00, 0.00, 180.00);
	CreateDynamicObject(2422, 698.669, -2904.959, 1700.420, 0.00, 0.00, 179.99);
	CreateDynamicObject(18070, 699.440, -2907.610, 1702.119, 0.00, 179.97, 90.48);
	CreateDynamicObject(18070, 699.369, -2898.500, 1702.130, 0.00, 179.88, 90.48);
	CreateDynamicObject(3857, 701.510, -2907.959, 1703.300, 0.00, 0.00, 315.14);
	CreateDynamicObject(16101, 701.500, -2911.139, 1702.739, 0.00, 179.99, 0.00);
	CreateDynamicObject(16101, 701.500, -2904.300, 1702.699, 0.00, 179.99, 0.00);
	CreateDynamicObject(3857, 701.510, -2907.959, 1703.300, 0.00, 0.00, 135.13);
	CreateDynamicObject(16101, 701.640, -2901.889, 1708.989, 0.00, 179.99, 0.00);
	CreateDynamicObject(16101, 697.320, -2901.909, 1708.989, 0.00, 179.99, 0.00);
	CreateDynamicObject(16101, 697.330, -2904.300, 1708.989, 0.00, 179.99, 0.00);
	CreateDynamicObject(16101, 697.359, -2911.030, 1708.989, 0.00, 179.99, 0.00);
	CreateDynamicObject(1533, 709.099, -2900.800, 1699.400, 0.00, 0.00, 0.00);
	CreateDynamicObject(1533, 710.599, -2900.800, 1699.400, 0.00, 0.00, 0.00);
	CreateDynamicObject(1722, 710.500, -2911.100, 1699.420, 0.00, 0.00, 0.00);
	CreateDynamicObject(1722, 711.200, -2911.100, 1699.420, 0.00, 0.00, 0.00);
	CreateDynamicObject(1722, 711.900, -2911.100, 1699.420, 0.00, 0.00, 0.00);
	CreateDynamicObject(1722, 712.599, -2911.100, 1699.420, 0.00, 0.00, 0.00);
	CreateDynamicObject(2239, 714.700, -2910.800, 1699.400, 0.00, 0.00, 200.00);
	CreateDynamicObject(1815, 713.500, -2910.699, 1699.420, 0.00, 0.00, 0.00);
	CreateDynamicObject(1722, 715.000, -2908.899, 1699.420, 0.00, 0.00, 90.00);
	CreateDynamicObject(1722, 715.000, -2908.199, 1699.420, 0.00, 0.00, 90.00);
	CreateDynamicObject(1722, 715.000, -2907.500, 1699.420, 0.00, 0.00, 90.00);
	CreateDynamicObject(1722, 715.000, -2906.800, 1699.420, 0.00, 0.00, 90.00);
	CreateDynamicObject(2852, 714.000, -2910.199, 1699.920, 0.00, 0.00, 0.00);
	CreateDynamicObject(2190, 701.200, -2907.100, 1700.400, 0.00, 0.00, 270.00);
	CreateDynamicObject(2190, 701.200, -2908.800, 1700.270, 0.00, 0.00, 248.00);
	CreateDynamicObject(2190, 701.200, -2908.800, 1700.569, 0.00, 180.00, 275.00);
	CreateDynamicObject(1715, 699.000, -2908.899, 1699.400, 0.00, 0.00, 130.00);
	CreateDynamicObject(1715, 699.000, -2906.600, 1699.400, 0.00, 0.00, 92.00);
	CreateDynamicObject(1808, 714.799, -2903.800, 1699.400, 0.00, 0.00, 268.25);
	CreateDynamicObject(1808, 690.700, -2906.000, 1699.400, 0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 702.799, -2906.000, 1698.630, 30.00, 0.00, 90.00);
	CreateDynamicObject(1886, 691.099, -2910.800, 1702.800, 20.92, 359.22, 135.72);
	CreateDynamicObject(1886, 714.400, -2901.100, 1702.800, 20.92, 359.22, 283.73);
	CreateDynamicObject(1892, 710.900, -2901.399, 1699.400, 0.00, 0.00, 0.00);
	CreateDynamicObject(1892, 709.299, -2901.399, 1699.400, 0.00, 0.00, 0.00);
	CreateDynamicObject(2165, 695.500, -2920.000, 1699.400, 0.00, 0.00, 90.00);
	CreateDynamicObject(970, 690.099, -2915.000, 1699.699, 90.00, 180.00, 270.00);
	CreateDynamicObject(970, 690.099, -2915.000, 1700.000, 90.00, 180.00, 270.00);
	CreateDynamicObject(970, 690.099, -2915.000, 1700.300, 90.00, 179.99, 270.50);
	CreateDynamicObject(970, 690.099, -2915.000, 1700.599, 90.00, 180.00, 270.00);
	CreateDynamicObject(970, 690.099, -2915.000, 1700.859, 90.00, 180.00, 270.00);
	CreateDynamicObject(970, 690.099, -2915.000, 1701.199, 90.00, 180.00, 270.00);
	CreateDynamicObject(970, 690.099, -2919.100, 1699.699, 90.00, 179.99, 270.00);
	CreateDynamicObject(970, 690.099, -2919.100, 1700.000, 90.00, 179.99, 270.00);
	CreateDynamicObject(970, 690.099, -2919.100, 1700.300, 90.00, 179.99, 270.00);
	CreateDynamicObject(970, 690.099, -2919.100, 1700.599, 90.00, 179.99, 270.00);
	CreateDynamicObject(970, 690.099, -2919.100, 1700.859, 90.00, 179.99, 270.00);
	CreateDynamicObject(970, 690.099, -2919.100, 1701.199, 90.00, 179.99, 270.00);
	CreateDynamicObject(970, 690.099, -2915.000, 1701.500, 90.00, 179.99, 270.00);
	CreateDynamicObject(970, 690.099, -2919.100, 1701.500, 90.00, 179.99, 270.00);
	CreateDynamicObject(3578, 691.799, -2918.199, 1698.630, 30.00, 0.00, 90.00);
	CreateDynamicObject(2166, 695.599, -2917.100, 1699.400, 0.00, 0.00, 0.00);
	CreateDynamicObject(1715, 696.799, -2919.699, 1699.400, 0.00, 0.00, 262.00);
	CreateDynamicObject(2186, 698.099, -2917.300, 1699.400, 0.00, 0.00, 270.00);
	CreateDynamicObject(1886, 698.700, -2917.199, 1701.800, 0.00, 0.00, 270.00);
	CreateDynamicObject(1886, 691.599, -2913.199, 1701.500, 0.00, 0.00, 0.00);
	CreateDynamicObject(1886, 691.599, -2920.699, 1701.500, 0.00, 0.00, 180.00);
	CreateDynamicObject(3944, 701.440, -2924.709, 1698.900, 0.00, 0.00, 90.00);
	CreateDynamicObject(2007, 702.099, -2920.000, 1699.400, 0.00, 0.00, 180.00);
	CreateDynamicObject(2007, 701.099, -2920.000, 1699.400, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 705.099, -2920.000, 1699.400, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 704.099, -2920.000, 1699.400, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 703.099, -2920.000, 1699.400, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 705.099, -2920.000, 1700.800, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 704.099, -2920.000, 1700.800, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 703.099, -2920.000, 1700.800, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 702.099, -2920.000, 1700.800, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 701.099, -2920.000, 1700.800, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 701.099, -2916.600, 1699.400, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 702.099, -2916.600, 1699.400, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 703.099, -2916.600, 1699.400, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 704.099, -2916.600, 1699.400, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 705.099, -2916.600, 1699.400, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 705.099, -2916.600, 1700.800, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 704.099, -2916.600, 1700.800, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 703.099, -2916.600, 1700.800, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 702.099, -2916.600, 1700.800, 0.00, 0.00, 179.99);
	CreateDynamicObject(2007, 701.099, -2916.600, 1700.800, 0.00, 0.00, 179.99);
	CreateDynamicObject(9339, 704.900, -2917.199, 1689.199, 90.00, 90.00, 0.00);
	CreateDynamicObject(1893, 702.200, -2918.300, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(2007, 705.090, -2917.800, 1699.400, 0.00, 0.00, 0.00);
	CreateDynamicObject(2007, 705.090, -2917.800, 1700.800, 0.00, 0.00, 0.00);
	CreateDynamicObject(2007, 704.099, -2917.800, 1700.800, 0.00, 0.00, 0.00);
	CreateDynamicObject(2007, 703.099, -2917.800, 1700.800, 0.00, 0.00, 0.00);
	CreateDynamicObject(2007, 702.099, -2917.800, 1700.800, 0.00, 0.00, 0.00);
	CreateDynamicObject(2007, 701.099, -2917.800, 1700.800, 0.00, 0.00, 0.00);
	CreateDynamicObject(2007, 701.099, -2917.800, 1699.400, 0.00, 0.00, 0.00);
	CreateDynamicObject(2007, 702.099, -2917.800, 1699.400, 0.00, 0.00, 0.00);
	CreateDynamicObject(2007, 703.099, -2917.800, 1699.400, 0.00, 0.00, 0.00);
	CreateDynamicObject(2007, 704.099, -2917.800, 1699.400, 0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 720.200, -2920.800, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 723.299, -2928.699, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 727.099, -2928.699, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 727.099, -2918.800, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 720.200, -2928.800, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 723.700, -2918.800, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 702.500, -2914.399, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 707.799, -2914.399, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 698.299, -2907.100, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 694.000, -2907.100, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 705.000, -2907.100, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 712.000, -2907.100, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 712.000, -2902.100, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(1893, 705.000, -2902.100, 1702.900, 0.00, 0.00, 270.00);
	CreateDynamicObject(2844, 701.299, -2919.100, 1699.400, 0.00, 0.00, 66.00);
	CreateDynamicObject(2845, 702.599, -2919.100, 1699.400, 0.00, 0.00, 270.00);
	CreateDynamicObject(2303, 706.299, -2920.000, 1699.400, 0.00, 0.00, 180.00);
	CreateDynamicObject(2303, 707.599, -2920.000, 1699.400, 0.00, 0.00, 179.99);
	CreateDynamicObject(2741, 708.299, -2920.399, 1701.000, 0.00, 0.00, 180.00);
	CreateDynamicObject(1789, 729.200, -2930.699, 1700.000, 0.00, 0.00, 270.00);
	CreateDynamicObject(1789, 729.200, -2928.899, 1700.000, 0.00, 0.00, 270.00);
	CreateDynamicObject(1808, 701.799, -2922.699, 1699.400, 0.00, 0.00, 0.00);
	CreateDynamicObject(2596, 700.599, -2909.600, 1702.099, 0.00, 0.00, 240.00);
	CreateDynamicObject(2813, 707.299, -2924.699, 1700.199, 0.00, 0.00, 0.00);
	CreateDynamicObject(2817, 704.200, -2926.199, 1699.420, 0.00, 0.00, 0.00);
	CreateDynamicObject(2822, 721.400, -2932.300, 1700.500, 0.00, 0.00, 280.00);
	CreateDynamicObject(2828, 704.080, -2922.899, 1701.300, 0.00, 0.00, 164.50);
	CreateDynamicObject(2831, 721.099, -2929.399, 1700.300, 0.00, 0.00, 0.00);
	CreateDynamicObject(2894, 699.799, -2910.100, 1700.410, 0.00, 0.00, 0.00);
	CreateDynamicObject(1828, 726.799, -2919.600, 1699.410, 0.00, 0.00, 358.00);
	CreateDynamicObject(2286, 706.000, -2900.800, 1701.400, 0.00, 0.00, 0.00);
	CreateDynamicObject(2279, 706.700, -2910.689, 1701.300, 0.00, 0.00, 180.00);
	CreateDynamicObject(2275, 711.599, -2910.600, 1701.099, 0.00, 0.00, 180.00);
	CreateDynamicObject(2261, 714.500, -2907.300, 1701.000, 0.00, 0.00, 270.00);
	CreateDynamicObject(1537, 708.609, -2972.020, 1699.400, 0.00, 0.00, 179.50);
	CreateDynamicObject(16101, 712.020, -2964.100, 1707.859, 0.00, 179.99, 0.00);
	CreateDynamicObject(16101, 708.080, -2964.100, 1707.859, 0.00, 179.99, 0.00);
	CreateDynamicObject(19437, 708.059, -2964.629, 1701.099, 0.00, 0.00, 0.00);
	CreateDynamicObject(19437, 708.059, -2966.239, 1701.099, 0.00, 0.00, 0.00);
	CreateDynamicObject(19437, 708.059, -2967.840, 1701.099, 0.00, 0.00, 0.00);
	CreateDynamicObject(19437, 708.780, -2968.729, 1701.099, 0.00, 0.00, 90.00);
	CreateDynamicObject(19437, 709.950, -2968.729, 1701.099, 0.00, 0.00, 90.00);
	CreateDynamicObject(19437, 711.280, -2968.729, 1701.099, 0.00, 0.00, 90.00);
	CreateDynamicObject(19437, 712.000, -2964.629, 1701.099, 0.00, 0.00, 0.00);
	CreateDynamicObject(19437, 712.000, -2966.239, 1701.099, 0.00, 0.00, 0.00);
	CreateDynamicObject(19437, 712.000, -2967.840, 1701.099, 0.00, 0.00, 0.00);
	CreateDynamicObject(2166, 713.820, -2932.270, 1699.430, 0.00, 0.00, 90.00);
	CreateDynamicObject(1715, 713.989, -2930.000, 1699.430, 0.00, 0.00, 244.00);
	CreateDynamicObject(2165, 712.830, -2930.260, 1699.430, 0.00, 0.00, 90.00);
	CreateDynamicObject(1432, 712.150, -2952.510, 1699.430, 0.00, 0.00, 324.00);
	CreateDynamicObject(1432, 708.549, -2954.620, 1699.430, 0.00, 0.00, 324.00);
	CreateDynamicObject(1537, 710.099, -2972.020, 1699.400, 0.00, 0.00, 179.50);

	// Столовая (interior)
	CreateDynamicObject(19380, 602.00, -2835.44, 1031.58, 0.00, 90.00, 0.00);
	CreateDynamicObject(18981, 602.047, -2843.272, 1039.099, 0.00, 90.00, 0.00);
	CreateDynamicObject(19377, 605.547, -2854.832, 1035.050, 0.00, 90.00, 0.00);
	CreateDynamicObject(19377, 595.057, -2854.832, 1035.050, 0.00, 90.00, 0.00);
	CreateDynamicObject(19393, 601.54, -2830.69, 1033.39, 0.00, 0.00, 90.00);
	CreateDynamicObject(19456, 595.13, -2830.69, 1036.89, 0.00, 0.00, 90.00);
	CreateDynamicObject(19456, 607.96, -2830.68, 1033.39, 0.00, 0.00, 90.00);
	CreateDynamicObject(19456, 590.51, -2835.59, 1033.39, 0.00, 0.00, 0.00);
	CreateDynamicObject(19456, 590.40, -2845.22, 1036.89, 0.00, 0.00, 0.00);
	CreateDynamicObject(19456, 612.70, -2835.59, 1033.39, 0.00, 0.00, 0.00);
	CreateDynamicObject(19456, 612.70, -2845.22, 1033.39, 0.00, 0.00, 0.00);
	CreateDynamicObject(19456, 607.80, -2849.95, 1033.39, 0.00, 0.00, 90.00);
	CreateDynamicObject(19393, 592.15, -2849.95, 1033.39, 0.00, 0.00, 90.00);
	CreateDynamicObject(19456, 604.31, -2855.71, 1033.39, 0.00, 0.00, 90.00);
	CreateDynamicObject(19456, 594.69, -2855.71, 1033.39, 0.00, 0.00, 90.00);
	CreateDynamicObject(19364, 595.35, -2849.95, 1033.39, 0.00, 0.00, 90.00);
	CreateDynamicObject(1845, 598.49, -2849.79, 1031.66, 0.00, 0.00, 180.00);
	CreateDynamicObject(1845, 601.48, -2849.79, 1031.66, 0.00, 0.00, 179.99);
	CreateDynamicObject(2144, 605.80, -2852.88, 1031.66, 0.00, 0.00, 270.00);
	CreateDynamicObject(2132, 605.67, -2853.76, 1031.66, 0.00, 0.00, 270.00);
	CreateDynamicObject(2131, 606.05, -2850.54, 1031.66, 0.00, 0.00, 270.00);
	CreateDynamicObject(941, 604.02, -2850.79, 1032.14, 0.00, 0.00, 0.00);
	CreateDynamicObject(1421, 602.49, -2855.15, 1032.43, 0.00, 0.00, 0.00);
	CreateDynamicObject(1421, 600.62, -2855.16, 1032.43, 0.00, 0.00, 0.00);
	CreateDynamicObject(2063, 595.04, -2850.35, 1032.57, 0.00, 0.00, 0.00);
	CreateDynamicObject(2063, 595.38, -2855.23, 1032.57, 0.00, 0.00, 180.00);
	CreateDynamicObject(941, 595.06, -2849.12, 1032.14, 0.00, 0.00, 0.00);
	CreateDynamicObject(19456, 607.96, -2830.68, 1036.89, 0.00, 0.00, 90.00);
	CreateDynamicObject(19456, 595.12, -2830.69, 1033.39, 0.00, 0.00, 90.00);
	CreateDynamicObject(19456, 590.39, -2835.59, 1036.89, 0.00, 0.00, 0.00);
	CreateDynamicObject(19456, 590.51, -2845.22, 1033.39, 0.00, 0.00, 0.00);
	CreateDynamicObject(19456, 590.51, -2854.85, 1033.39, 0.00, 0.00, 0.00);
	CreateDynamicObject(19456, 607.80, -2849.95, 1036.89, 0.00, 0.00, 90.00);
	CreateDynamicObject(19456, 598.18, -2849.95, 1036.89, 0.00, 0.00, 90.00);
	CreateDynamicObject(19364, 591.77, -2849.96, 1036.89, 0.00, 0.00, 90.00);
	CreateDynamicObject(19456, 612.70, -2845.22, 1036.89, 0.00, 0.00, 0.00);
	CreateDynamicObject(19456, 612.70, -2835.59, 1036.89, 0.00, 0.00, 0.00);
	CreateDynamicObject(19364, 601.55, -2830.69, 1036.89, 0.00, 0.00, 90.00);
	CreateDynamicObject(971, 599.29, -2849.96, 1037.52, 0.00, 180.00, 0.00);
	CreateDynamicObject(1538, 600.77, -2830.76, 1031.66, 0.00, 0.00, 0.00);
	CreateDynamicObject(2949, 592.87, -2849.93, 1031.64, 0.00, 0.00, 270.00);
	CreateDynamicObject(19456, 606.61, -2854.74, 1033.39, 0.00, 0.00, 0.00);
	CreateDynamicObject(1430, 591.10, -2852.66, 1031.97, 0.00, 0.00, 259.98);
	CreateDynamicObject(3041, 605.79, -2849.21, 1031.41, 0.00, 0.00, 180.00);
	CreateDynamicObject(3041, 609.33, -2849.20, 1031.41, 0.00, 0.00, 180.00);
	CreateDynamicObject(2637, 604.62, -2836.12, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2637, 604.60, -2832.94, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(1811, 598.64, -2844.82, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(2637, 598.08, -2845.51, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2637, 598.08, -2842.36, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2637, 598.12, -2839.24, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2637, 598.07, -2836.07, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2637, 598.12, -2832.94, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(1811, 597.66, -2844.82, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 597.49, -2841.67, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 598.46, -2841.64, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 597.59, -2838.24, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 598.78, -2838.27, 1032.21, 0.00, 0.00, 72.68);
	CreateDynamicObject(1811, 597.57, -2835.45, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 598.49, -2835.35, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 597.69, -2832.22, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 598.61, -2832.19, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 598.62, -2833.54, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 597.78, -2833.54, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 597.68, -2836.73, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 598.65, -2836.91, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 598.63, -2839.93, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 597.59, -2839.93, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 597.65, -2842.96, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 598.56, -2842.95, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 597.77, -2846.18, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 598.60, -2846.13, 1032.21, 0.00, 0.00, 284.22);
	CreateDynamicObject(2637, 593.77, -2832.98, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2637, 593.74, -2836.13, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2637, 593.71, -2839.30, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2637, 593.75, -2842.40, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2637, 593.74, -2845.52, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2637, 604.61, -2845.60, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2637, 604.65, -2842.45, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2637, 604.60, -2839.35, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2637, 609.57, -2845.52, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2637, 609.57, -2842.40, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2637, 609.60, -2839.28, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2637, 609.58, -2836.11, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2637, 609.63, -2832.98, 1032.06, 0.00, 0.00, 0.00);
	CreateDynamicObject(2063, 598.29, -2855.28, 1032.57, 0.00, 0.00, 180.00);
	CreateDynamicObject(1430, 591.33, -2853.67, 1031.97, 0.00, 0.00, 298.85);
	CreateDynamicObject(1430, 593.25, -2855.04, 1031.97, 0.00, 0.00, 0.00);
	CreateDynamicObject(1421, 591.13, -2851.21, 1032.43, 0.00, 0.00, 270.00);
	CreateDynamicObject(1421, 591.68, -2854.89, 1032.43, 0.00, 0.00, 338.44);
	CreateDynamicObject(1811, 594.29, -2832.20, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 593.29, -2832.25, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 593.27, -2835.43, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 594.17, -2835.42, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 594.21, -2838.63, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 593.25, -2838.59, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 594.24, -2841.69, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 593.32, -2841.70, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 593.25, -2844.88, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 594.10, -2844.87, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 594.22, -2846.13, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 593.30, -2846.11, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 593.38, -2843.04, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 594.29, -2842.96, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 594.23, -2839.94, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 593.34, -2839.97, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 593.23, -2836.76, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 594.10, -2836.82, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 594.19, -2833.65, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 593.35, -2833.53, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 604.21, -2846.20, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 605.22, -2846.25, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 604.25, -2843.05, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 605.20, -2843.13, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 604.14, -2839.96, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 605.16, -2840.05, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 604.23, -2836.75, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 605.07, -2836.68, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 604.12, -2833.70, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 605.23, -2833.70, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 604.14, -2832.39, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 605.22, -2832.31, 1032.21, 0.00, 0.00, 76.44);
	CreateDynamicObject(1811, 604.17, -2835.59, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 605.14, -2835.58, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 604.10, -2838.67, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 605.08, -2838.57, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 604.24, -2841.69, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 605.22, -2841.65, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 604.16, -2844.75, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 605.14, -2844.71, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 609.12, -2836.56, 1032.49, 0.00, 178.00, 90.00);
	CreateDynamicObject(1811, 610.11, -2836.57, 1032.49, 0.00, 178.00, 90.00);
	CreateDynamicObject(1811, 609.21, -2833.46, 1032.49, 0.00, 178.00, 90.00);
	CreateDynamicObject(1811, 610.11, -2833.44, 1032.49, 0.00, 178.00, 90.00);
	CreateDynamicObject(1811, 610.14, -2835.49, 1032.49, 0.00, 178.00, 270.00);
	CreateDynamicObject(1811, 609.13, -2835.52, 1032.49, 0.00, 178.00, 270.00);
	CreateDynamicObject(1811, 609.22, -2832.48, 1032.49, 0.00, 178.00, 270.00);
	CreateDynamicObject(1811, 610.18, -2832.49, 1032.49, 0.00, 178.00, 270.00);
	CreateDynamicObject(2676, 609.84, -2848.31, 1031.76, 0.00, 0.00, 0.00);
	CreateDynamicObject(2675, 606.98, -2833.73, 1031.76, 0.00, 0.00, 345.60);
	CreateDynamicObject(2675, 592.56, -2848.23, 1031.76, 0.00, 0.00, 276.39);
	CreateDynamicObject(2674, 595.93, -2832.59, 1031.76, 0.00, 0.00, 276.39);
	CreateDynamicObject(2673, 595.55, -2837.86, 1031.76, 0.00, 0.00, 276.39);
	CreateDynamicObject(2673, 607.49, -2843.46, 1031.76, 0.00, 0.00, 276.39);
	CreateDynamicObject(2671, 610.57, -2838.59, 1031.76, 0.00, 0.00, 276.39);
	CreateDynamicObject(2670, 601.36, -2839.88, 1031.76, 0.00, 0.00, 320.17);
	CreateDynamicObject(2653, 592.49, -2833.67, 1038.02, 0.00, 180.00, 320.00);
	CreateDynamicObject(2653, 610.71, -2833.08, 1038.02, 0.00, 180.00, 222.00);
	CreateDynamicObject(2674, 602.50, -2847.11, 1031.76, 0.00, 0.00, 319.07);
	CreateDynamicObject(1811, 610.08, -2846.19, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 609.22, -2846.29, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 609.14, -2843.03, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 610.08, -2843.08, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 609.08, -2839.86, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 609.95, -2839.99, 1032.21, 0.00, 0.00, 270.00);
	CreateDynamicObject(1811, 609.15, -2838.58, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 610.13, -2838.56, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 610.02, -2841.73, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 609.15, -2841.63, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 610.11, -2844.67, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 609.08, -2844.66, 1032.21, 0.00, 0.00, 90.00);
	CreateDynamicObject(1811, 606.09, -2845.57, 1032.21, 0.00, 0.00, 0.00);
	CreateDynamicObject(1811, 599.48, -2845.50, 1032.21, 0.00, 0.00, 0.00);
	CreateDynamicObject(1811, 599.36, -2842.36, 1032.21, 0.00, 0.00, 0.00);
	CreateDynamicObject(1811, 595.11, -2842.38, 1032.21, 0.00, 0.00, 0.00);
	CreateDynamicObject(1811, 606.03, -2842.39, 1032.21, 0.00, 0.00, 0.00);
	CreateDynamicObject(1811, 603.36, -2845.60, 1032.21, 0.00, 0.00, 180.00);
	CreateDynamicObject(1811, 603.47, -2842.45, 1032.21, 0.00, 0.00, 180.00);
	CreateDynamicObject(1811, 596.67, -2845.56, 1032.21, 0.00, 0.00, 180.00);
	CreateDynamicObject(1811, 591.09, -2841.54, 1032.21, 0.00, 0.00, 180.00);
	CreateDynamicObject(1811, 591.11, -2840.58, 1032.21, 0.00, 0.00, 180.00);
	CreateDynamicObject(1811, 591.10, -2839.70, 1032.21, 0.00, 0.00, 180.00);
	CreateDynamicObject(1811, 591.08, -2838.57, 1032.21, 0.00, 0.00, 180.00);
	CreateDynamicObject(1811, 591.07, -2837.40, 1032.21, 0.00, 0.00, 180.00);
	CreateDynamicObject(2850, 595.62, -2849.32, 1032.62, 0.00, 0.00, 2.70);
	CreateDynamicObject(2851, 594.98, -2849.40, 1032.62, 0.00, 0.00, 0.00);
	CreateDynamicObject(2856, 594.63, -2849.49, 1032.62, 0.00, 0.00, 0.00);
	CreateDynamicObject(2856, 596.28, -2849.49, 1032.62, 0.00, 0.00, 247.80);
	CreateDynamicObject(2865, 598.02, -2855.06, 1032.62, 0.00, 0.00, 20.93);
	CreateDynamicObject(2863, 598.97, -2855.33, 1032.92, 0.00, 0.00, 20.93);
	CreateDynamicObject(2812, 595.91, -2848.85, 1032.61, 0.00, 0.00, 341.35);
	CreateDynamicObject(2811, 591.06, -2831.35, 1031.52, 0.00, 0.00, 341.35);
	CreateDynamicObject(2811, 612.02, -2831.23, 1031.52, 0.00, 0.00, 341.35);
	CreateDynamicObject(2804, 603.70, -2850.80, 1032.66, 0.00, 0.00, 0.00);
	CreateDynamicObject(2803, 604.37, -2854.84, 1032.00, 0.00, 0.00, 0.00);
	CreateDynamicObject(2804, 604.21, -2850.79, 1032.66, 0.00, 0.00, 0.00);
	CreateDynamicObject(2804, 604.72, -2850.84, 1032.66, 0.00, 0.00, 0.00);
	CreateDynamicObject(19380, 612.50, -2835.44, 1031.58, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 591.50, -2835.33, 1031.58, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 612.50, -2845.00, 1031.58, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 602.00, -2845.00, 1031.58, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 591.50, -2845.00, 1031.58, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 591.50, -2854.61, 1031.58, 0.00, 90.00, 0.00);
	CreateDynamicObject(19380, 602.00, -2854.70, 1031.58, 0.00, 90.00, 0.00);

	// Завод (interior)
	CreateDynamicObject(2911,2545.8999,-1307.30,1043.20,0.00,0.00,180.25);
	CreateDynamicObject(16350,2540.50,-1296.50,1054.10,0.00,0.00,0.00);
	CreateDynamicObject(16350,2540.6001,-1283.40,1054.10,0.00,0.00,0.00);
	CreateDynamicObject(16350,2562.00,-1291.20,1054.10,0.00,0.00,179.75);
	CreateDynamicObject(16350,2561.8999,-1304.60,1054.10,0.00,0.00,179.747);
	CreateDynamicObject(16350,2543.8999,-1280.10,1054.10,0.00,0.00,269.247);
	CreateDynamicObject(16350,2557.00,-1280.20,1054.10,0.00,0.00,270.2420000);
	CreateDynamicObject(16350,2557.1001000,-1307.20,1054.10,0.00,0.00,90.00);
	CreateDynamicObject(16350,2544.8999,-1307.20,1054.10,0.00,0.00,89.75);
	CreateDynamicObject(17523,2551.50,-1295.00,1048.40,0.00,180.25,0.00);
	CreateDynamicObject(2971,2542.3999,-1298.00,1043.10,0.00,0.00,346.00);
	CreateDynamicObject(17523,2553.50,-1278.80,1048.40,359.75,180.2470000,0.001);
	CreateDynamicObject(2926,2551.00,-1286.50,1044.10,0.00,0.00,338.75);
	CreateDynamicObject(2968,2560.00,-1297.50,1043.40,0.00,0.00,350.00);
	CreateDynamicObject(2968,2559.70,-1298.50,1043.40,0.00,0.00,7.9970000);
	CreateDynamicObject(2968,2547.00,-1288.50,1043.40,0.00,0.00,7.9930000);
	CreateDynamicObject(854,2557.20,-1305.90,1043.30,0.00,0.00,0.00);
	CreateDynamicObject(854,2543.00,-1286.50,1043.30,0.00,0.00,0.00);
	CreateDynamicObject(850,2552.8999,-1298.90,1043.20,0.00,0.00,0.00);
	CreateDynamicObject(850,2552.20,-1289.30,1043.20,0.00,0.00,0.00);
	CreateDynamicObject(3119,2542.8999,-1283.60,1044.40,0.00,0.00,298.00);
	CreateDynamicObject(3097,2550.30,-1282.10,1047.00,0.00,0.00,78.50);
	CreateDynamicObject(3006,2555.00,-1281.90,1043.10,0.00,0.00,0.00);
	CreateDynamicObject(2971,2560.8999,-1289.50,1043.10,0.00,0.00,330.00);
	CreateDynamicObject(1440,2553.80,-1306.40,1043.60,0.00,0.00,0.00);
	CreateDynamicObject(1357,2551.00,-1301.00,1044.30,0.00,0.00,0.00);
	CreateDynamicObject(1355,2543.30,-1302.40,1044.30,0.00,0.00,316.00);
	CreateDynamicObject(1265,2543.70,-1280.70,1043.60,0.00,0.00,0.00);
	CreateDynamicObject(1219,2549.1001,-1281.60,1043.50,0.00,0.00,0.00);
	CreateDynamicObject(1219,2546.30,-1282.80,1043.50,0.00,0.00,21.25);
	CreateDynamicObject(1221,2546.20,-1283.30,1044.10,0.00,0.00,52.00);
	CreateDynamicObject(1221,2548.50,-1280.80,1044.10,0.00,0.00,51.998);
	CreateDynamicObject(1221,2549.50,-1282.00,1044.10,0.00,0.00,12.748);
	CreateDynamicObject(1221,2548.00,-1282.40,1044.10,0.00,0.00,324.744);

	//  Объекты ящиков для работы грузчика (за зданием завода)
	CreateDynamicObject(1431, 505.3, -2675.0, 12.6, 0.0, 0.0, 122.6);
	obj = CreateDynamicObject(925, 504.9, -2679.7, 13.1, 0.0, 0.0, -1.1);
	return obj;
}

stock AircraftCarrier_CreateObjects()
{
	CreateDynamicObject(10771, -1357.68359, 552.28070, 5.44530, 0.0, 0.0, 0.0);
	CreateDynamicObject(11146, -1366.68750, 552.85162, 12.28910, 0.0, 0.0, 0.0);
	CreateDynamicObject(11149, -1363.77344, 547.09381, 11.98440, 0.0, 0.0, 0.0);
	CreateDynamicObject(10770, -1354.46875, 544.75000, 38.67970, 0.0, 0.0, 0.0);
	CreateDynamicObject(11237, -1354.42188, 544.75000, 38.67970, 0.0, 0.0, 0.0);
	CreateDynamicObject(10772, -1356.35156, 552.11719, 17.27340, 0.0, 0.0, 0.0);
	CreateDynamicObject(11145, -1420.57813, 552.29688, 4.25780, 0.0, 0.0, 0.0);
}
