#define Vehicle.		Vehicle_

forward bool:GetVehicleEngine(vehicleid);
forward Float:MyGetVehicleHealth(vehicleid);
forward bool:GetVehicleBonnet(vehicleid);
forward bool:GetVehicleBoot(vehicleid);
forward bool:IsVehicleWithEngine(vehicleid);

enum
{
	MTYPE_NONE,
	MTYPE_RC,
	MTYPE_BIKE,
	MTYPE_MOTO,
	MTYPE_TRUCK,
	MTYPE_BUS,
	MTYPE_TRAIN,
	MTYPE_BOAT,
	MTYPE_HELIC,
	MTYPE_PLANE,
	MTYPE_NODOOR,
}

enum // Vehicle Class
{
	VC_SPECIAL,		// (+) Специальный
	VC_LOWCOST,		// (+) Бюджетный 			(5.000$ - 11.500$)
	VC_GENERAL, 	// (+) Средний 				(11.500$ - 21.000$)
	VC_LOWRIDER,    // (+) Лоурайдерский        (15.000$ - 20.000$)
	VC_PREMIER,     // (+) Представительский    (21.000$ - 55.000$)
	VC_SPORT,       // (+) Спортивные           (27.000$ - 55.000$)
	VC_MONSTER,		// (+) Огромные джипы       (21.000$ - 55.000$)
	VC_SUPER,       // (+) Супер дорогие        (55.000$ - 330.000$)
}

enum VEHICLE_ENUM
{
	VEH_MODEL,
	VEH_MTYPE,
	VEH_NAME[20],
	VEH_CLASS,
	bool:VEH_DONATE,
	VEH_PRICE,
	VEH_FUEL,
}

new const VehParams[212][VEHICLE_ENUM] =
{
	{400, MTYPE_NONE,	"Landstalker",	VC_GENERAL, false, 16000, 60 },
	{401, MTYPE_NONE,	"Bravura",		VC_LOWCOST, false, 7900, 60 },
	{402, MTYPE_NONE,	"Buffalo",		VC_SPORT, 	false, 34000, 60 },
	{403, MTYPE_TRUCK,	"Linerunner",	VC_SPECIAL, false, 100000, 60 },
	{404, MTYPE_NONE,	"Pereniel",		VC_LOWCOST, false, 7900, 60 },
	{405, MTYPE_NONE,	"Sentinel", 	VC_PREMIER, false, 35000, 60 },
	{406, MTYPE_TRUCK,	"Dumper", 		VC_SPECIAL, false, 100000, 60 },
	{407, MTYPE_TRUCK,	"Firetruck", 	VC_SPECIAL, false, 100000, 60 },
	{408, MTYPE_TRUCK,	"Trashmaster", 	VC_SPECIAL, false, 100000, 60 },
	{409, MTYPE_NONE,	"Stretch", 		VC_PREMIER, false, 54000, 60 },
	{410, MTYPE_NONE,	"Manana", 		VC_LOWCOST, false, 5900, 60 },
	{411, MTYPE_NONE,	"Infernus", 	VC_SUPER, 	true,  990, 60 },
	{412, MTYPE_NONE,	"Voodoo", 		VC_LOWRIDER, false, 16000, 60 },
	{413, MTYPE_NONE,	"Pony", 		VC_GENERAL, false, 14000, 60 },
	{414, MTYPE_TRUCK,	"Mule", 		VC_SPECIAL, false, 100000, 60 },
	{415, MTYPE_NONE,	"Cheetah", 		VC_SUPER, 	true,  690, 60 },
	{416, MTYPE_TRUCK,	"Ambulance", 	VC_SPECIAL, false, 100000, 60 },
	{417, MTYPE_HELIC,	"Leviathan", 	VC_SPECIAL, false, 100000, 60 },
	{418, MTYPE_NONE,	"Moonbeam", 	VC_GENERAL, false, 15000, 60 },
	{419, MTYPE_NONE,	"Esperanto", 	VC_PREMIER, false, 24000, 60 },
	{420, MTYPE_NONE,	"Taxi", 		VC_SPECIAL, false, 100000, 60 },
	{421, MTYPE_NONE,	"Washington", 	VC_PREMIER, false, 45000, 60 },
	{422, MTYPE_NONE,	"Bobcat", 		VC_GENERAL, false, 14000, 60 },
	{423, MTYPE_NONE,	"Mr Whoopee", 	VC_SPECIAL, false, 100000, 60 },
	{424, MTYPE_NONE,	"BF Injection", VC_SPECIAL, false, 100000, 60 },
	{425, MTYPE_HELIC,	"Hunter", 		VC_SPECIAL, false, 100000, 60 },
	{426, MTYPE_NONE,	"Premier", 		VC_PREMIER, false, 26000, 60 },
	{427, MTYPE_TRUCK,	"Enforcer", 	VC_SPECIAL, false, 100000, 60 },
	{428, MTYPE_TRUCK,	"Securicar", 	VC_SPECIAL, false, 100000, 60 },
	{429, MTYPE_NONE,	"Banshee", 		VC_SUPER, 	true,  790, 60 },
	{430, MTYPE_BOAT,	"Predator", 	VC_SPECIAL, false, 100000, 60 },
	{431, MTYPE_BUS,	"Bus", 			VC_SPECIAL, false, 100000, 60 },
	{432, MTYPE_NONE,	"Rhino", 		VC_SPECIAL, false, 100000, 60 },
	{433, MTYPE_TRUCK,	"Barracks", 	VC_SPECIAL, false, 100000, 60 },
	{434, MTYPE_NONE,	"Hotknife", 	VC_SPECIAL, true,  390, 60 },
	{435, MTYPE_NONE,	"Trailer", 		VC_SPECIAL, false, 100000, 60 },
	{436, MTYPE_NONE,	"Previon", 		VC_LOWCOST, false, 5900, 60 },
	{437, MTYPE_BUS,	"Coach", 		VC_SPECIAL, false, 100000, 60 },
	{438, MTYPE_NONE,	"Cabbie", 		VC_SPECIAL, false, 100000, 60 },
	{439, MTYPE_NONE,	"Stallion", 	VC_LOWCOST, false, 10900, 60 },
	{440, MTYPE_NONE,	"Rumpo", 		VC_SPECIAL, false, 100000, 60 },
	{441, MTYPE_RC,		"RC Bandit", 	VC_SPECIAL, false, 100000, 60 },
	{442, MTYPE_NONE,	"Romero", 		VC_SPECIAL, true,  290, 60 },
	{443, MTYPE_TRUCK,	"Packer", 		VC_SPECIAL, false, 100000, 60 },
	{444, MTYPE_TRUCK,	"Monster Truck", VC_MONSTER, false, 100000, 60 },
	{445, MTYPE_NONE,	"Admiral", 		VC_PREMIER, false, 23000, 60 },
	{446, MTYPE_BOAT,	"Squalo", 		VC_SPECIAL, false, 100000, 60 },
	{447, MTYPE_HELIC,	"Seasparrow",	VC_SPECIAL, false, 100000, 60 },
	{448, MTYPE_MOTO,	"Pizzaboy", 	VC_SPECIAL, false, 100000, 60 },
	{449, MTYPE_TRAIN,	"Tram", 		VC_SPECIAL, false, 100000, 60 },
	{450, MTYPE_NONE,	"Trailer",		VC_SPECIAL, false, 100000, 60 },
	{451, MTYPE_NONE,	"Turismo",		VC_SUPER,	true,  690, 60 },
	{452, MTYPE_BOAT,	"Speeder",		VC_SPECIAL, false, 100000, 60 },
	{453, MTYPE_BOAT,	"Reefer",		VC_SPECIAL, false, 100000, 60 },
	{454, MTYPE_BOAT,	"Tropic",		VC_SPECIAL, false, 100000, 60 },
	{455, MTYPE_TRUCK,	"Flatbed",		VC_SPECIAL, false, 100000, 60 },
	{456, MTYPE_TRUCK,	"Yankee", 		VC_SPECIAL, false, 100000, 60 },
	{457, MTYPE_NONE,	"Caddy", 		VC_SPECIAL, false, 100000, 60 },
	{458, MTYPE_NONE,	"Solair", 		VC_GENERAL, false, 18000, 60 },
	{459, MTYPE_NONE,	"RC Van", 		VC_GENERAL, false, 14500, 60 },
	{460, MTYPE_PLANE,	"Skimmer", 		VC_SPECIAL, false, 100000, 60 },
	{461, MTYPE_MOTO,	"PCJ-600", 		VC_GENERAL, false, 15000, 60 },
	{462, MTYPE_NODOOR,	"Faggio", 		VC_LOWCOST, false, 2900, 60 },
	{463, MTYPE_MOTO,	"Freeway",		VC_GENERAL, false, 15000, 60 },
	{464, MTYPE_RC,		"RC Baron",		VC_SPECIAL, false, 100000, 60 },
	{465, MTYPE_RC,		"RC Raider", 	VC_SPECIAL, false, 100000, 60 },
	{466, MTYPE_NONE,	"Glendale", 	VC_GENERAL, false, 17000, 60 },
	{467, MTYPE_NONE,	"Oceanic", 		VC_GENERAL, false, 18000, 60 },
	{468, MTYPE_MOTO,	"Sanchez", 		VC_GENERAL, false, 13000, 60 },
	{469, MTYPE_HELIC,	"Sparrow", 		VC_SPECIAL, false, 100000, 60 },
	{470, MTYPE_NONE,	"Patriot", 		VC_SPECIAL, false, 100000, 60 },
	{471, MTYPE_MOTO,	"Quad", 		VC_SPECIAL, false, 100000, 60 },
	{472, MTYPE_BOAT,	"Coastguard", 	VC_SPECIAL, false, 100000, 60 },
	{473, MTYPE_BOAT,	"Dinghy", 		VC_SPECIAL, false, 100000, 60 },
	{474, MTYPE_NONE,	"Hermes", 		VC_GENERAL, false, 18000, 60 },
	{475, MTYPE_NONE,	"Sabre", 		VC_GENERAL, false, 18000, 60 },
	{476, MTYPE_PLANE,	"Rustler",	 	VC_SPECIAL, false, 100000, 60 },
	{477, MTYPE_NONE,	"ZR-350", 		VC_SPORT,   false, 34000, 60 },
	{478, MTYPE_NONE,	"Walton", 		VC_LOWCOST, false, 7900, 60 },
	{479, MTYPE_NONE,	"Regina", 		VC_GENERAL, false, 16000, 60 },
	{480, MTYPE_NONE,	"Comet",	 	VC_SUPER,   true,  490, 60 },
	{481, MTYPE_BIKE,	"BMX", 			VC_SPECIAL, false, 100000, 60 },
	{482, MTYPE_NONE,	"Burrito", 		VC_GENERAL, false, 16000, 60 },
	{483, MTYPE_NONE,	"Camper", 		VC_SPECIAL, true,  290, 60 },
	{484, MTYPE_BOAT,	"Marquis", 		VC_SPECIAL, false, 100000, 60 },
	{485, MTYPE_NONE,	"Baggage", 		VC_SPECIAL, false, 100000, 60 },
	{486, MTYPE_NONE,	"Dozer", 		VC_SPECIAL, false, 100000, 60 },
	{487, MTYPE_HELIC,	"Maverick",		VC_SPECIAL, false, 100000, 60 },
	{488, MTYPE_HELIC,	"News Chopper", VC_SPECIAL, false, 100000, 60 },
	{489, MTYPE_NONE,	"Rancher", 		VC_PREMIER, false, 36500, 60 }, // см. 505
	{490, MTYPE_NONE,	"FBI Rancher", 	VC_SPECIAL, false, 100000, 60 },
	{491, MTYPE_NONE,	"Virgo", 		VC_PREMIER, false, 25000, 60 },
	{492, MTYPE_NONE,	"Greenwood", 	VC_GENERAL, false, 19900, 60 },
	{493, MTYPE_BOAT,	"Jetmax", 		VC_SPECIAL, false, 100000, 60 },
	{494, MTYPE_NONE,	"Hotring", 		VC_SPECIAL, true,  390, 60 },
	{495, MTYPE_NONE,	"Sandking", 	VC_SPECIAL, true,  450, 60 },
	{496, MTYPE_NONE,	"Blista Compact", VC_SPORT, false, 27000, 60 },
	{497, MTYPE_HELIC,	"Police Maverick", VC_SPECIAL, false, 100000, 60 },
	{498, MTYPE_TRUCK,	"Boxville", 	VC_SPECIAL, false, 100000, 60 },
	{499, MTYPE_TRUCK,	"Benson", 		VC_SPECIAL, false, 100000, 60 },
	{500, MTYPE_NONE,	"Mesa", 		VC_GENERAL, false, 19900, 60 },
	{501, MTYPE_RC,		"RC Goblin", 	VC_SPECIAL, false, 5000, 60 },
	{502, MTYPE_NONE,	"Hotring Racer", VC_SPECIAL, true, 390, 60 },
	{503, MTYPE_NONE,	"Hotring Racer", VC_SPECIAL, true, 390, 60 },
	{504, MTYPE_NONE,	"Bloodring Banger", VC_SPECIAL, true, 390, 60 },
	{505, MTYPE_NONE,	"Rancher", 		VC_PREMIER, false, 37500, 60 }, // см. 459
	{506, MTYPE_NONE,	"Super GT", 	VC_SPORT,   false, 36000, 60 },
	{507, MTYPE_NONE,	"Elegant", 		VC_PREMIER, false, 31000, 60 },
	{508, MTYPE_NONE,	"Journey", 		VC_SPECIAL, false, 100000, 60 },
	{509, MTYPE_BIKE,	"Bike", 		VC_SPECIAL, false, 100000, 60 },
	{510, MTYPE_BIKE,	"Mountain Bike", VC_SPECIAL, false, 100000, 60 },
	{511, MTYPE_PLANE,	"Beagle",		VC_SPECIAL, false, 100000, 60 },
	{512, MTYPE_PLANE,	"Cropdust", 	VC_SPECIAL, false, 100000, 60 },
	{513, MTYPE_PLANE,	"Stunt", 		VC_SPECIAL, false, 100000, 60 },
	{514, MTYPE_TRUCK,	"Tanker", 		VC_SPECIAL, false, 100000, 60 },
	{515, MTYPE_TRUCK,	"RoadTrain", 	VC_SPECIAL, false, 100000, 60 },
	{516, MTYPE_NONE,	"Nebula", 		VC_GENERAL, false, 19000, 60 },
	{517, MTYPE_NONE,	"Majestic", 	VC_GENERAL, false, 16000, 60 },
	{518, MTYPE_NONE,	"Buccaneer", 	VC_GENERAL, false, 14000, 60 },
	{519, MTYPE_PLANE,	"Shamal", 		VC_SPECIAL, false, 100000, 60 },
	{520, MTYPE_PLANE,	"Hydra", 		VC_SPECIAL, false, 100000, 60 },
	{521, MTYPE_MOTO,	"FCR-900", 		VC_SPORT,   false, 31000, 60 },
	{522, MTYPE_MOTO,	"NRG-500", 		VC_SPORT,   false, 38000, 60 },
	{523, MTYPE_MOTO,	"HPV1000", 		VC_SPECIAL, false, 100000, 60 },
	{524, MTYPE_TRUCK,	"Cement Truck", VC_SPECIAL, false, 100000, 60 },
	{525, MTYPE_NONE,	"Tow Truck", 	VC_SPECIAL, false, 100000, 300 },
	{526, MTYPE_NONE,	"Fortune", 		VC_LOWCOST, false, 5900, 60 },
	{527, MTYPE_NONE,	"Cadrona", 		VC_LOWCOST, false, 5900, 60 },
	{528, MTYPE_NONE,	"FBI Truck",	VC_SPECIAL, false, 100000, 60 },
	{529, MTYPE_NONE,	"Willard", 		VC_GENERAL, false, 16000, 60 },
	{530, MTYPE_NODOOR,	"Forklift", 	VC_SPECIAL, false, 100000, 60 },
	{531, MTYPE_NODOOR,	"Tractor", 		VC_SPECIAL, false, 100000, 60 },
	{532, MTYPE_NONE,	"Combine", 		VC_SPECIAL, false, 100000, 60 },
	{533, MTYPE_NONE,	"Feltzer", 		VC_PREMIER, false, 34000, 60 },
	{534, MTYPE_NONE,	"Remington", 	VC_LOWRIDER, false, 16000, 60 },
	{535, MTYPE_NONE,	"Slamvan", 		VC_LOWRIDER, false, 18000, 60 },
	{536, MTYPE_NONE,	"Blade", 		VC_LOWRIDER, false, 18000, 60 },
	{537, MTYPE_TRAIN,	"Freight", 		VC_SPECIAL, false, 100000, 60 },
	{538, MTYPE_TRAIN,	"Streak", 		VC_SPECIAL, false, 100000, 60 },
	{539, MTYPE_BOAT,	"Vortex", 		VC_SPECIAL, false, 100000, 60 },
	{540, MTYPE_NONE,	"Vincent",		VC_GENERAL, false, 17000, 60 },
	{541, MTYPE_NONE,	"Bullet", 		VC_SUPER,   true,  890, 60 },
	{542, MTYPE_NONE,	"Clover",		VC_LOWCOST, false, 11400, 60 },
	{543, MTYPE_NONE,	"Sadler", 		VC_LOWCOST, false, 9400, 60 },
	{544, MTYPE_TRUCK,	"Firetruck", 	VC_SPECIAL, false, 100000, 60 },
	{545, MTYPE_NONE,	"Hustler", 		VC_SPECIAL, true,  290, 60 },
	{546, MTYPE_NONE,	"Intruder", 	VC_GENERAL, false, 14000, 60 },
	{547, MTYPE_NONE,	"Primo", 		VC_GENERAL, false, 14000, 60 },
	{548, MTYPE_HELIC,	"Cargobob", 	VC_SPECIAL, false, 100000, 60 },
	{549, MTYPE_NONE,	"Tampa", 		VC_LOWCOST, false, 11500, 60 },
	{550, MTYPE_NONE,	"Sunrise", 		VC_GENERAL, false, 16000, 60 },
	{551, MTYPE_NONE,	"Merit", 		VC_PREMIER, false, 26000, 60 },
	{552, MTYPE_NONE,	"Utility", 		VC_SPECIAL, false, 100000, 60 },
	{553, MTYPE_PLANE,	"Nevada", 		VC_SPECIAL, false, 100000, 60 },
	{554, MTYPE_NONE,	"Yosemite", 	VC_PREMIER, false, 32000, 60 },
	{555, MTYPE_NONE,	"Windsor", 		VC_SPECIAL, true,  290, 60 },
	{556, MTYPE_TRUCK,	"Monster Truck", VC_MONSTER, false, 100000, 60 },
	{557, MTYPE_TRUCK,	"Monster Truck", VC_MONSTER, false, 100000, 60 },
	{558, MTYPE_NONE,	"Uranus", 		VC_SPORT,   false, 27000, 60 },
	{559, MTYPE_NONE,	"Jester", 		VC_SPORT,   false, 30900, 60 },
	{560, MTYPE_NONE,	"Sultan", 		VC_SPORT,   false, 32000, 60 },
	{561, MTYPE_NONE,	"Stratum", 		VC_SPORT,   false, 30900, 60 },
	{562, MTYPE_NONE,	"Elegy",		VC_SPORT,   false, 32000, 60 },
	{563, MTYPE_HELIC,	"Raindance",	VC_SPECIAL, false, 100000, 60 },
	{564, MTYPE_RC,		"RC Tiger", 	VC_SPECIAL, false, 100000, 60 },
	{565, MTYPE_NONE,	"Flash", 		VC_SPORT,   false, 27000, 60 },
	{566, MTYPE_NONE,	"Tahoma", 		VC_LOWRIDER, false, 20000, 60 },
	{567, MTYPE_NONE,	"Savanna",	 	VC_LOWRIDER, false, 20000, 60 },
	{568, MTYPE_NODOOR,	"Bandito", 		VC_SPECIAL, true,  290, 60 },
	{569, MTYPE_TRAIN,	"Freight", 		VC_SPECIAL, false, 100000, 60 },
	{570, MTYPE_TRAIN,	"Trailer", 		VC_SPECIAL, false, 100000, 60 },
	{571, MTYPE_NODOOR,	"Kart",			VC_SPECIAL, false, 100000, 60 },
	{572, MTYPE_NODOOR,	"Mower", 		VC_SPECIAL, false, 100000, 60 },
	{573, MTYPE_TRUCK,	"Duneride", 	VC_SPECIAL, false, 100000, 60 },
	{574, MTYPE_NONE,	"Sweeper", 		VC_SPECIAL, false, 100000, 60 },
	{575, MTYPE_NONE,	"Broadway", 	VC_LOWRIDER, false, 15000, 60 },
	{576, MTYPE_NONE,	"Tornado", 		VC_LOWRIDER, false, 15000, 60 },
	{577, MTYPE_PLANE,	"AT-400", 		VC_SPECIAL, false, 100000, 60 },
	{578, MTYPE_TRUCK,	"DFT-30", 		VC_SPECIAL, false, 100000, 60 },
	{579, MTYPE_NONE,	"Huntley", 		VC_PREMIER, false, 50000, 60 },
	{580, MTYPE_NONE,	"Stafford", 	VC_PREMIER, false, 45000, 60 },
	{581, MTYPE_MOTO,	"BF-400", 		VC_GENERAL, false, 15000, 60 },
	{582, MTYPE_NONE,	"Newsvan", 		VC_SPECIAL, false, 100000, 60 },
	{583, MTYPE_NONE,	"Tug", 			VC_SPECIAL, false, 100000, 60 },
	{584, MTYPE_NONE,	"Trailer", 		VC_SPECIAL, false, 100000, 60 },
	{585, MTYPE_NONE,	"Emperor", 		VC_GENERAL, false, 14000, 60 },
	{586, MTYPE_MOTO,	"Wayfarer", 	VC_GENERAL, false, 5000, 60 },
	{587, MTYPE_NONE,	"Euros", 		VC_SPORT,   false, 34000, 60 },
	{588, MTYPE_NONE,	"Hotdog", 		VC_SPECIAL, false, 100000, 60 },
	{589, MTYPE_NONE,	"Club", 		VC_SPORT,   false, 27000, 60 },
	{590, MTYPE_TRAIN,	"Trailer", 		VC_SPECIAL, false, 100000, 60 },
	{591, MTYPE_NONE,	"Trailer",		VC_SPECIAL, false, 100000, 60 },
	{592, MTYPE_PLANE,	"Andromada", 	VC_SPECIAL, false, 100000, 60 },
	{593, MTYPE_PLANE,	"Dodo", 		VC_SPECIAL, false, 100000, 60 },
	{594, MTYPE_RC,		"RC Cam", 		VC_SPECIAL, false, 100000, 60 },
	{595, MTYPE_BOAT,	"Launch", 		VC_SPECIAL, false, 100000, 60 },
	{596, MTYPE_NONE,	"Police Car (LSPD)", VC_SPECIAL, false, 100000, 60 },
	{597, MTYPE_NONE,	"Police Car (SFPD)", VC_SPECIAL, false, 100000, 60 },
	{598, MTYPE_NONE,	"Police Car (LVPD)", VC_SPECIAL, false, 100000, 60 },
	{599, MTYPE_NONE,	"Police Ranger",	VC_SPECIAL, false, 100000, 60 },
	{600, MTYPE_NONE,	"Picador", 			VC_GENERAL, false, 13900, 60 },
	{601, MTYPE_TRUCK,	"S.W.A.T. Van", 	VC_SPECIAL, false, 100000, 60 },
	{602, MTYPE_NONE,	"Alpha", 			VC_SPORT,   false, 29000, 60 },
	{603, MTYPE_NONE,	"Phoenix", 			VC_SPORT,   false, 36000, 60 },
	{604, MTYPE_NONE,	"Glendale", 		VC_SPECIAL, false, 100000, 60 },
	{605, MTYPE_NONE,	"Sadler", 			VC_SPECIAL, false, 100000, 60 },
	{606, MTYPE_NONE,	"Luggage Trailer",	VC_SPECIAL, false, 100000, 60 },
	{607, MTYPE_NONE,	"Luggage Trailer",	VC_SPECIAL, false, 100000, 60 },
	{608, MTYPE_NONE,	"Stair Trailer", 	VC_SPECIAL, false, 100000, 60 },
	{609, MTYPE_TRUCK,	"Boxville", 		VC_SPECIAL, false, 100000, 60 },
	{610, MTYPE_NONE,	"Farm Plow", 		VC_SPECIAL, false, 100000, 60 },
	{611, MTYPE_NONE,	"Utility Trailer",	VC_SPECIAL, false, 100000, 60 }
};

enum
{
	C_TYPE_DEFAULT,
	C_TYPE_PLAYER,
	C_TYPE_FACTION,
	C_TYPE_JOB,
	C_TYPE_PARTJOB,
	C_TYPE_RENT,
	C_TYPE_EVENT,
}

enum
{
	VEH_AVAILABLE_NONE,		//	не имеет доступа к авто
	VEH_AVAILABLE_DRIVE,	//	может ездить, но не может заводить, закрывать и т д
	VEH_AVAILABLE_CONTROL,	//	может управлять: закрывать, заводить (арендованное авто/ивент)
	VEH_AVAILABLE_OWNER		//	личное авто
}

enum cInfo
{
	cID,
	cType, // 0 - Default, 1 - Players, 2 - Factions, 3 - Job, 4 - Part job, 5 - Rent, 6 - Event
	cOwnerID, // id в таблице (игрока/бизнеса/банды)
	cRank,
	cModel,
	cPlate[10],
	Float:cX,
	Float:cY,
	Float:cZ,
	Float:cA,
	cColor1,
	cColor2,
	// Tuning
	cPaintJob,
	cSpoiler,
	cHood,
	cRoof,
	cSideskirt,
	cNitro,
	cLamps,
	cExhaust,
	cWheels,
	cHydraulics,
	cFrontBumper,
	cRearBumper,
	cVentR,
	cVentL,
	cNeon,
	cFlash,
	// Tuning end.
	Float:cMileage, // Пробег в км
	// fine_park // Статус штраф-стоянки (в массив не записывается): 0 - Не оштрафован, 1 - Неправильная парковка
};
// Сохраняющиеся параметры транспорта
new CarInfo[MAX_VEHICLES][cInfo];

enum vInfo
{
	bool:vCreated,
	vRespawn,
	vRespawnTime,
	Float:vPos[4],
	vModelType,
	vRadio,
	//---	rent
	vRentPrice,
	vRentOwner,
	vRentTime,
	//---
	vPlayers,
	vDriver,
	vCoDriver,
	vLeftSeat,
	vRightSeat,
	bool:vLights,
	vLocked,				// 0 - Open, 1 - Closed, 999 - Blocked
	bool:vSiren,
 	vAlarm,
	bool:vAlarmLight,
	Float:vFuel,
	Float:vWishFuel,
	vBitHack,				// Последовательность взлома
	Text3D:vLabel,
	vIterNext,
	vFlashMode,
	vFlashState,
	vTrailerID,				// Порядковый номер прикрепленного трейлера
	bool:vSpawnDestroy,		// Если true, то уничтожить при спавн
	bool:vBlockMove,		//	Заблокировать перемещение авто
	vObject[2], // Для динамических объектов
	Text3D:vText3D, // Для 3д текста

	bool:vTrapState, // Статус грузового люка (false - закрыт, true - открыт)
}
// Не сохраняющиеся параметры транспорта
new VehInfo[MAX_VEHICLES][vInfo];
new g_NeonObject[MAX_VEHICLES][2];

new freightTrain[3];