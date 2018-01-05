#!/bin/bash

PG_PASSWORD=""
DB_NAME=""
USER_NAME=""
HOST_NAME=""
PORT=""
OPTIONS="-U $USER_NAME -h $HOST_NAME -p $PORT -d $DB_NAME"
EXPORT_FILE_NAME="table_data_count.csv"
 
export PGPASSWORD=$PG_PASSWORD
指定したデーベースのテーブル名を全て取得
TABLE_LIST_CMD="echo 'select relname as TABLE_NAME from pg_stat_user_tables;' | psql $OPTIONS -t"
TABLES=(`eval $TABLE_LIST_CMD`)

# 各テーブルごとにテーブル名,count結果をCSV出力する
for table in "${TABLES[@]}"
do
  COUNT_SQL="select count(*) FROM $table"  COUNT_CMD="echo '${COUNT_SQL};' | psql ${OPTIONS} | head -3 | tail -n 1"
  COUNT_RESULT=(`eval $COUNT_CMD`)
  echo "$table,$COUNT_RESULT" >> EXPORT_FILE_NAME
done