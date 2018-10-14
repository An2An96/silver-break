stock Migration_Houses()
{
	new query[1024];
	mysql_format(g_SQL, query, sizeof(query),
		"CREATE TABLE `houses` (\
	 		`id` int(4) NOT NULL,\
	  		`ownerid` int(11) NOT NULL,\
	  		`payment_days` smallint(6) NOT NULL,\
	  		`X` float(8,2) NOT NULL,\
	  		`Y` float(8,2) NOT NULL,\
	  		`Z` float(8,2) NOT NULL,\
	  		`A` float(8,2) NOT NULL,\
	  		`class` int(1) NOT NULL,\
	  		`int` int(1) NOT NULL,\
	  		`donate` int(1) NOT NULL,\
	  		`price` int(9) NOT NULL,\
	  		`lock` int(1) NOT NULL,\
	  		`extra_slots` int(2) NOT NULL,\
	  		`rent` int(11) NOT NULL DEFAULT '0'\
		) ENGINE=InnoDB DEFAULT CHARSET=cp1251;");
	mysql_query(g_SQL, query);
	mysql_query(g_SQL, 
		"ALTER TABLE `houses`\
  		ADD PRIMARY KEY (`id`);");
}

stock Migration_Furniture()
{
	new query[1024];
	mysql_format(g_SQL, query, sizeof(query), 
		"CREATE TABLE `furniture` (\
			`id` int(11) NOT NULL,\
	  		`house_id` int(4) NOT NULL,\
	  		`object_id` int(6) NOT NULL,\
	  		`x` float NOT NULL DEFAULT '0',\
	  		`y` float NOT NULL DEFAULT '0',\
	  		`z` float NOT NULL DEFAULT '0',\
	  		`rx` float NOT NULL DEFAULT '0',\
	  		`ry` float NOT NULL DEFAULT '0',\
	  		`rz` float NOT NULL DEFAULT '0',\
	  		`set` tinyint(1) NOT NULL DEFAULT '0',\
	  		`dynamic_id` int(8) NOT NULL DEFAULT '0',\
	  		`fur_num` int(4) NOT NULL DEFAULT '0'\
		) ENGINE=InnoDB DEFAULT CHARSET=cp1251;");
	mysql_query(g_SQL, query);
	mysql_query(g_SQL, 
		"ALTER TABLE `furniture`\
		ADD PRIMARY KEY (`id`),\
		ADD KEY `house_id` (`house_id`);");
}