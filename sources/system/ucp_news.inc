#if defined _system_ucp_news_included
    #endinput
#endif

#define _system_ucp_news_included

enum 
{
    NEWS_TYPE_ACHIEVEMENT = 1,      // id ачивки
    NEWS_TYPE_MEMBERSHIP,           // id фракции
    NEWS_TYPE_LEADERSHIP,           // id фракции
    NEWS_TYPE_CAR_PURCHASE,         // id модели
    NEWS_TYPE_HOUSE_PURCHASE,       // id дома, район
    NEWS_TYPE_BUSINESS_PURCHASE     // id бизнеса, тип (строкой) -- закусочная там хуй знает
}

stock PushNews(playerid, type, object_id, const object_string[] = "")
{
    new query[256];
    mysql_format(g_SQL, query, sizeof(query), "INSERT INTO `ucp_common_news` SET `user_id` = '%d', `type` = '%d', `object_id` = '%d', `object_string` = '%s'", GetPlayerUserID(playerid), type, object_id, object_string);
    mysql_query_ex(query);
    
    mysql_format(g_SQL, query, sizeof(query), "CALL pushNews('%d', '%d', '%d', '%s', '%d')", GetPlayerUserID(playerid), type, object_id, object_string, unixtime());
    printf(query);
    mysql_query_ex(query);
    return true;
}