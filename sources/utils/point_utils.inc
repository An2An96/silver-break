#if defined _point_utils_included
	#endinput
#endif
#define _point_utils_included

stock	Float: DistanceCameraTargetToLocation(Float:CamX, Float:CamY, Float:CamZ,
	Float:ObjX, Float:ObjY, Float:ObjZ, Float:FrX, Float:FrY, Float:FrZ)
{
	new Float: TGTDistance,
		Float: tmpX,
		Float: tmpY,
		Float: tmpZ,
		Float: result;

	TGTDistance = floatsqroot((CamX - ObjX) * (CamX - ObjX) + (CamY - ObjY) * (CamY - ObjY) + (CamZ - ObjZ) * (CamZ - ObjZ));
	tmpX = FrX * TGTDistance + CamX;
	tmpY = FrY * TGTDistance + CamY;
	tmpZ = FrZ * TGTDistance + CamZ;
	result = floatsqroot((tmpX - ObjX) * (tmpX - ObjX) + (tmpY - ObjY) * (tmpY - ObjY) + (tmpZ - ObjZ) * (tmpZ - ObjZ));
	return (result);
}

stock	Float: GetPointAngleToPoint(Float:x2, Float:y2, Float:X, Float:Y)
{
	new Float:DX,
		Float:DY,
		Float:angle;

	DX = floatabs(floatsub(x2,X));
	DY = floatabs(floatsub(y2,Y));
	if (DY == 0.0 || DX == 0.0)
	{
		if(DY == 0 && DX > 0)
			angle = 0.0;
		else if(DY == 0 && DX < 0)
			angle = 180.0;
		else if(DY > 0 && DX == 0)
			angle = 90.0;
		else if(DY < 0 && DX == 0)
			angle = 270.0;
		else if(DY == 0 && DX == 0)
			angle = 0.0;
	}
	else
	{
		angle = atan(DX/DY);
		if(X > x2 && Y <= y2)
			angle += 90.0;
		else if(X <= x2 && Y < y2)
			angle = floatsub(90.0, angle);
		else if(X < x2 && Y >= y2)
			angle -= 90.0;
		else if(X >= x2 && Y > y2)
			angle = floatsub(270.0, angle);
	}
	return (floatadd(angle, 90.0));
}

stock	GetXYInFrontOfPoint(&Float:x, &Float:y, Float:angle, Float:distance)
{
	x += (distance * floatsin(-angle, degrees));
	y += (distance * floatcos(-angle, degrees));
}

stock	Float: GetDistanceFromPointToPoint(Float:x1, Float:y1, Float:z1,
	Float:x2, Float:y2, Float:z2, ignore_z = false)
{
	new Float:result;

	if(ignore_z)
		z2 = z1;
	result = floatsqroot(floatpower(x2 - x1, 2)
		+ floatpower(y2 - y1, 2) + floatpower(z2 - z1, 2));
	return (result);
}

stock	Float: GetDistanceBetweenPlayers(player1, player2, ignore_z = false)
{
	new
		Float:pos[2][3],
		Float:result;

	GetPlayerPos(player1, pos[0][0], pos[0][1], pos[0][2]);
	GetPlayerPos(player2, pos[1][0], pos[1][1], pos[1][2]);
	result = GetDistanceFromPointToPoint(pos[0][0], pos[0][1], pos[0][2],
		pos[1][0], pos[1][1], pos[1][2], ignore_z);
	return (result);
}

stock	Float: GetDistanceFromMeToPoint(playerid, Float:x2, Float:y2, Float:z2, ignore_z = false)
{
	new Float:pos[3],
		Float:result;

	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	if(ignore_z)
		z2 = pos[2];
	result = GetDistanceFromPointToPoint(pos[0], pos[1], pos[2], x2, y2, z2);
	return (result);
}

stock	Float: GetSquareDistance(Float:x1, Float:y1, Float:z1,
	Float:x2, Float:y2, Float:z2)
{
	x1 -= x2;
	y1 -= y2;
	z1 -= z2;
	x1 *= x1;
	y1 *= y1;
	z1 *= z1;
	return (x1 + y1 + z1);
}

stock	Float: floatdif(Float:oper1, Float:oper2)
{	// Только для положительных углов
	return floatabs((floatround(oper1 - oper2 + 180.0) % 360) - 180.0);
}

//  Вхождение одной точки в другую с некоторым радиусом
stock	cmatch(Float:x1, Float:y1, Float:z1,
	Float:x2, Float:y2, Float:z2, Float:size)
{
	return (floatabs(x1 - x2) <= size
		&& floatabs(y1 - y2) <= size && floatabs(z1 - z2) <= size);
}

stock	IsCoordInSquare(Float:X, Float:Y, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY)
{
	return (MaxX >= X && X >= MinX && MaxY >= Y && Y >= MinY);
}

stock	IsPlayerInSquare(playerid, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY, bool:incZ = true)
{
	new Float:pos[3];

	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	if(IsCoordInSquare(pos[0], pos[1], MinX, MinY, MaxX, MaxY)
		&& (incZ == false || pos[2] < 530.0))
		return (true);
	return (false);
}

stock	IsPlayerNearPlayer(playerid, giveplayerid, Float:dist)
{
	return (dist > floatround(GetDistanceBetweenPlayers(playerid, giveplayerid)));
}