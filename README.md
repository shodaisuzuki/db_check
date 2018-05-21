# PostgreSQL用便利シェル

# 構成

├── README.md
├── bin
│   ├── column_export_csv.sh
│   ├── db_check.sh
│   ├── excute_mailer.sh
│   ├── objects_data_size_export.sh
│   └── table_data_count.sh
├── export
└── psql.conf

## bin
### db_check.sh

2つのDB(SOURCEとTARGET)のデータするを比較する
詳細
http://qiita.com/shodaisuzuki/items/a5f58a501bec0e7bab2c

### column_export_csv.sh

指定したテーブルのカラム一覧をCSV出力する

### table_data_count.sh

指定したDBの全テーブルのデータ数をCSV出力する

### excute_mailer.sh

クエリの実行結果をメール送信する

### objects_data_size_export.sh

全テーブル、インデックスのデータサイズを大きい順にソートしてCSV出力する

## export

ファイル出力先ディレクトリ

## psql.conf
PostgreSQLの設定値を記述します。
このファイルは各実行ファイルで読み込まれています。
