ER=""
PG_PASSWORD=""
PG_HOST=""
PG_PORT=""
DB_NAME=""

export PGPASSWORD=$PG_PASSWORD
IFS=','

date_now=`date +"%Y-%m-%d %k:%M:%S.%3N"`

GET_USER_SQL="
SELECT 
  id, name 
FROM 
  user;
"
GET_POST_SQL="
SELECT 
  user_id, content 
FROM 
  post;
"
    
result=`psql -U $PG_USER -h $PG_HOST -p $PG_PORT -d $DB_NAME <<_EOD
   \timing
   $GET_USER_SQL
   $GET_POST_SQL
_EOD
`

MAILING_LIST=(
  sample@ne.jp
  example@xxx.com
)
SUBJECT="Excute Result"

mail_body=`
echo
echo date_now
echo $result | sed -e '1,1d'
`
echo -e "Subject: $SUBJECT \n\n $mail_body"  | sendmail ${MAILING_LIST[*]}

