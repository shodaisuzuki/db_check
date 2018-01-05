#!/bin/bash

source ../psql.conf
# CSV出力するテーブルを指定
TABLES=( 
 ""
)

# 各テーブルごとにCSV出力
for table in "${TABLES[@]}"
do
    export PGPASSWORD=$SOURCE_PASSWORD
    
    COLUMN_LIST_SQL="SELECT column_name FROM information_schema.columns where table_name = '\''$table'\'';"
    COLUMN_LIST_CMD="echo '${COLUMN_LIST_SQL}' | psql $SOURCE_OPTIONS -t "
    COLUMN_LIST=(`eval $COLUMN_LIST_CMD`)
    COLUMN="$(IFS=,; echo "${COLUMN_LIST[*]}")"
    
    OUTPUT_DIR=../$EXPORT_DIR/culumn_export/ 
    
    if [ ! -e $OUTPUT_DIR ]; then
      mkdir $OUTPUT_DIR
    fi

   #CSV出力
    SOURCE_SQL="select ${COLUMN} FROM $table"
    SOURCE_CMD="psql -U ${SOURCE_USER_NAME} ${SOURCE_DB_NAME} -c '${SOURCE_SQL}' -A -F, > "$OUTPUT_DIR/${table}.csv"
    eval $SOURCE_CMD
    echo $table
done

echo "DONE!!"
