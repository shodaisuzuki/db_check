#!/bin/bash
SOURCE_PASSWORD=""
SOURCE_DB_NAME=""
SOURCE_USER_NAME=""
SOURCE_HOST_NAME=""
SOURCE_PASSWORD=""
SOURCE_PORT=""
SOURCE_OPTIONS="-U $SOURCE_USER_NAME -h $SOURCE_HOST_NAME -p $SOURCE_PORT -d $SOURCE_DB_NAME"

# 指定したデーベースのテーブル名を全て取得
CMD="echo 'select relname as TABLE_NAME from pg_stat_user_tables;' | psql $SOURCE_OPTIONS -t"
TABLES=(`eval $CMD`)

# 各テーブルごとにcount
for table in "${TABLES[@]}"
do
    export PGPASSWORD=$SOURCE_PASSWORD
    SOURCE_SQL="select count(*) FROM $table;"
    SOURCE_CMD="echo '${SOURCE_SQL};' | psql ${SOURCE_OPTIONS} | head -3 | tail -n 1"
    SOURCE_TABLECOUNT=(`eval $SOURCE_CMD`)

    echo "$table"
    echo "$SOURCE_TABLECOUNT"
done

echo "Done!!"
