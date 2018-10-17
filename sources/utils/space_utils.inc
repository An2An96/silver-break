Float:DistanceCameraTargetToLocation(Float:CamX, Float:CamY, Float:CamZ, Float:ObjX, Float:ObjY, Float:ObjZ, Float:FrX, Float:FrY, Float:FrZ)
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

Float:GetPointAngleToPoint(Float:x2, Float:y2, Float:X, Float:Y)
{
	new Float:DX, Float:DY;
	new Float:angle;

	DX = floatabs(floatsub(x2,X));
	DY = floatabs(floatsub(y2,Y));

	if (DY == 0.0 || DX == 0.0)
	{
		if(DY == 0 && DX > 0) angle = 0.0;
		else if(DY == 0 && DX < 0) angle = 180.0;
		else if(DY > 0 && DX == 0) angle = 90.0;
		else if(DY < 0 && DX == 0) angle = 270.0;
		else if(DY == 0 && DX == 0) angle = 0.0;
	}
	else
	{
		angle = atan(DX/DY);

		if(X > x2 && Y <= y2) angle += 90.0;
		else if(X <= x2 && Y < y2) angle = floatsub(90.0, angle);
		else if(X < x2 && Y >= y2) angle -= 90.0;
		else if(X >= x2 && Y > y2) angle = floatsub(270.0, angle);
	}
	return floatadd(angle, 90.0);
}

GetXYInFrontOfPoint(&Float:x, &Float:y, Float:angle, Float:distance)
{
	x += (distance * floatsin(-angle, degrees));
	y += (distance * floatcos(-angle, degrees));
}