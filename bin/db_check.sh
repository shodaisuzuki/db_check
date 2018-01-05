#!/bin/bash

source ../psql.conf
SOURCE_DB_NAME=""
SOURCE_USER_NAME=""
SOURCE_HOST_NAME=""
SOURCE_PASSWORD=""
SOURCE_PORT=""

TARGET_DB_NAME=""
TARGET_USER_NAME=""
TARGET_HOST_NAME=""
TARGET_PASSWORD=""
TARGET_PORT=""

# 指定したデーベースのテーブル名を全て取得
CMD="echo 'select relname as TABLE_NAME from pg_stat_user_tables;' | psql $/OPTIONS -t"
TABLES=(`eval $CMD`)

# 各テーブルごとにcountの結果を比較
export TOTAL_ERROR_CODE=0
for table in "${TABLES[@]}"
do
    export PGPASSWORD=$SOURCE_PASSWORD
    SOURCE_SQL="select count(*) FROM $table;"
    SOURCE_CMD="echo '${SOURCE_SQL};' | psql ${OPTIONS} | head -3 | tail -n 1"
    SOURCE_TABLECOUNT=(`eval $SOURCE_CMD`)

    export PGPASSWORD=$TARGET_PASSWORD
    TARGET_SQL="select count(*) FROM $table"
    TARGET_CMD="echo '${TARGET_SQL};' | psql ${OPTIONS} | head -3 | tail -n 1"
    TARGET_TABLECOUNT=(`eval $TARGET_CMD`)

    if [ $SOURCE_TABLECOUNT = $TARGET_TABLECOUNT ]; then
      echo "OK is $table"
    else
      echo "NOT EQUAL $table SOURCE_DB count $SOURCE_TABLECOUNT  :  TARGET_DB count $TARGET_TABLECOUNT"
      export TOTAL_ERROR_CODE=1
    fi
done
if [ "$TOTAL_ERROR_CODE" -gt "0" ];then
  echo '---> エラーがあります!!!!'
else
  echo '---> 整合性が確認されました'
fi
