#!/bin/bash

source ../psql.conf
EXPORT_FILE_NAME="table_data_count_$TIMESTAMP"

export PGPASSWORD=$PG_PASSWORD
psql.confで指定したデータベースのテーブル名を全て取得
TABLE_LIST_CMD="echo 'select relnameas TABLE_NAME from pg_stat_user_tables;' | psql $OPTIONS -t"
TABLES=(`eval $TABLE_LIST_CMD`)

#出力csvのヘッダを挿入
echo "table_name,count" >> "../$EXPORT_DIR/$EXPORT_FILE_NAME.csv"

# 各テーブルごとにテーブル名,count結果をCSV出力する
for table in "${TABLES[@]}"
do
  COUNT_SQL="select count(*) FROM $table"  COUNT_CMD="echo '${COUNT_SQL};' | psql ${OPTIONS} | head -3 | tail -n 1"
  COUNT_RESULT=(`eval $COUNT_CMD`)
  echo "$table,$COUNT_RESULT" >> "../$EXPORT_DIR/$EXPORT_FILE_NAME.csv"
done

echo "DONE! open to $EXPORT_DIR/$EXPORT_FILE_NAME.csv"
