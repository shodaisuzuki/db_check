#!/bin/bash

source ../psql.conf
EXPORT_FILE_NAME="objects_data_size_export_$TIMESTAMP"

export PGPASSWORD=$PG_PASSWORD

SQL="
select
  objectname,
  to_char(pg_relation_size(objectname::regclass), '999,999,999,999') as bytes 
from (
  select 
   tablename as objectname 
  from pg_tables 
  where schemaname = 'public'

  UNION

  select 
   indexname as objectname 
  from pg_indexes
  where schemaname = 'public'
) as objectlist

order by bytes desc;
"

psql ${OPTIONS} -c ${SQL} -A -F, > "../$EXPORT_DIR/$EXPORT_FILE_NAME.csv"

#出力csvのヘッダを挿入
echo "object_name,byte_size" >> "../$EXPORT_DIR/$EXPORT_FILE_NAME.csv"

echo "DONE! open to $EXPORT_DIR/$EXPORT_FILE_NAME.csv"
