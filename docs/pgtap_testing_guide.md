# pgTAPテスト実行ガイド

## 概要

`sync_t_data_to_t_datalatest_upsert_correct` プロシージャの動作をpgTAPフレームワークを使用してテストします。

## テスト環境のセットアップ

### 1. DockerFileの修正内容

- pgTAPライブラリのインストールを追加
- PostgreSQL拡張として有効化

### 2. 拡張機能の有効化

```sql
CREATE EXTENSION IF NOT EXISTS pgtap;
```

## テストファイル構成

- `tests/01_test_sync_procedure.sql` - プロシージャ存在確認テスト
- `tests/02_test_sync_procedure.sql` - 新規データの挿入テスト
- `tests/03_test_sync_procedure.sql` - 差分なしデータの削除テスト
- `tests/04_test_sync_procedure.sql` - 差分ありデータの更新テスト
- `tests/05_test_sync_procedure.sql` - NULL値の処理テスト

## テストケース

### テストケース1: プロシージャの存在確認
- **ファイル**: `01_test_sync_procedure.sql`
- **目的**: プロシージャが正しく定義されているかテスト
- **期待結果**: `sync_t_data_to_t_datalatest_upsert_correct` プロシージャが存在する

### テストケース2: 新規データの挿入
- **ファイル**: `02_test_sync_procedure.sql`
- **目的**: t_datalatest に存在しないデータが正しく挿入されるかテスト
- **テストデータ**: 
  ```sql
  t_data: ('TEST1', 'B001', 'C001', 'D001', '新規1', ..., '新規10')
  t_datalatest: (空)
  ```
- **期待結果**: 
  - t_datalatest にレコードが挿入される
  - t_data からレコードは削除されない（新規データのため）

### テストケース3: 差分なしデータの削除
- **ファイル**: `03_test_sync_procedure.sql`
- **目的**: 完全に同一のデータがt_dataから削除されるかテスト
- **テストデータ**:
  ```sql
  t_data: ('TEST2', 'B002', 'C002', 'D002', '同一1', ..., '同一10')
  t_datalatest: ('TEST2', 'B002', 'C002', 'D002', '同一1', ..., '同一10')
  ```
- **事前確認**: 全データカラム（column_1～column_10）が完全に一致していることを検証
- **期待結果**:
  - t_data からレコードが削除される
  - t_datalatest のレコードは残る

### テストケース4: 差分ありデータの更新
- **ファイル**: `04_test_sync_procedure.sql`
- **目的**: 差分があるデータがt_datalatest で更新されるかテスト
- **テストデータ**:
  ```sql
  t_data: ('TEST3', 'B003', 'C003', 'D003', '更新後1', ..., '更新後10')
  t_datalatest: ('TEST3', 'B003', 'C003', 'D003', '更新前1', ..., '更新前10')
  ```
- **事前確認**: t_datalatest に古いデータが存在することを全カラムで検証
- **期待結果**:
  - t_datalatest の全カラム（column_1～column_10）が正しく更新される
  - t_data からレコードは削除されない

### テストケース5: NULL値の処理
- **ファイル**: `05_test_sync_procedure.sql`
- **目的**: NULL値を含むデータの同一判定が正しく動作するかテスト
- **テストデータ**:
  ```sql
  t_data: ('TEST4', 'B004', 'C004', 'D004', NULL, 'NULL2', NULL, 'NULL4', ...)
  t_datalatest: ('TEST4', 'B004', 'C004', 'D004', NULL, 'NULL2', NULL, 'NULL4', ...)
  ```
- **期待結果**:
  - NULL値を含む同一レコードがt_dataから削除される

## 複数カラム検証方法

データカラムの一致確認には以下の方法を使用：

```sql
-- 連結文字列での全カラム比較
SELECT is(
    (SELECT COALESCE(column_1, '') || '|' || COALESCE(column_2, '') || '|' || 
            COALESCE(column_3, '') || '|' || COALESCE(column_4, '') || '|' || 
            COALESCE(column_5, '') || '|' || COALESCE(column_6, '') || '|' || 
            COALESCE(column_7, '') || '|' || COALESCE(column_8, '') || '|' || 
            COALESCE(column_9, '') || '|' || COALESCE(column_10, '')
     FROM t_data WHERE ...),
    (SELECT COALESCE(column_1, '') || '|' || ... FROM t_datalatest WHERE ...),
    'テスト前: t_dataとt_datalatest の全データカラムが完全に一致している'
);
```

## テスト実行方法

### 方法1: 個別テストファイル実行
```bash
# プロシージャ存在確認
docker-compose exec db psql -U postgres -d postgres -f /home/kbushi/workspace/postgresql/tests/01_test_sync_procedure.sql

# 新規データの挿入テスト
docker-compose exec db psql -U postgres -d postgres -f /home/kbushi/workspace/postgresql/tests/02_test_sync_procedure.sql

# 差分なしデータの削除テスト
docker-compose exec db psql -U postgres -d postgres -f /home/kbushi/workspace/postgresql/tests/03_test_sync_procedure.sql

# 差分ありデータの更新テスト
docker-compose exec db psql -U postgres -d postgres -f /home/kbushi/workspace/postgresql/tests/04_test_sync_procedure.sql

# NULL値の処理テスト
docker-compose exec db psql -U postgres -d postgres -f /home/kbushi/workspace/postgresql/tests/05_test_sync_procedure.sql
```

### 方法2: スクリプト実行（作成予定）
```bash
./run_tests.sh
```

## テスト結果の見方

### 成功例
```
# 01_test_sync_procedure.sql
1..1
ok 1 - sync_t_data_to_t_datalatest_upsert_correct プロシージャが存在する

# 02_test_sync_procedure.sql
1..5
ok 1 - テスト前: t_dataに新規レコードが存在する
ok 2 - テスト前: t_datalatest に該当レコードが存在しない
ok 3 - テスト後: t_datalatest に新規レコードが挿入された
ok 4 - テスト後: 挿入されたデータが正しい
ok 5 - テスト後: 新規データはt_dataから削除されていない

# 03_test_sync_procedure.sql
1..5
ok 1 - テスト前: t_dataに同一レコードが存在する
ok 2 - テスト前: t_datalatest に同一レコードが存在する
ok 3 - テスト前: t_dataとt_datalatest の全データカラムが完全に一致している
ok 4 - テスト後: 差分なしレコードがt_dataから削除された
ok 5 - テスト後: t_datalatest のレコードは残っている

# 04_test_sync_procedure.sql
1..4
ok 1 - テスト前: t_data に差分ありレコードが存在する
ok 2 - テスト前: t_datalatest に古いデータが存在する（全カラム確認）
ok 3 - テスト後: t_datalatest の全カラム（column_1～column_10）が正しく更新された
ok 4 - テスト後: 差分ありレコードはt_dataから削除されていない

# 05_test_sync_procedure.sql
1..1
ok 1 - テスト後: NULL値を含む同一レコードがt_dataから削除された
```

### 失敗例
```
# 03_test_sync_procedure.sql
1..5
ok 1 - テスト前: t_dataに同一レコードが存在する
ok 2 - テスト前: t_datalatest に同一レコードが存在する
not ok 3 - テスト前: t_dataとt_datalatest の全データカラムが完全に一致している
#   Failed test 3: "テスト前: t_dataとt_datalatest の全データカラムが完全に一致している"
#          got: "同一1|同一2|同一3|同一4|同一5|同一6|同一7|同一8|同一9|同一10"
#     expected: "同一1|同一2|同一3|同一4|同一5|同一6|同一7|同一8|同一9|異なる10"
```

## テストデータのクリーンアップ

各テストファイルの開始時にテストデータはクリアされます：

```sql
-- テスト用のデータをクリア
DELETE FROM t_data;
DELETE FROM t_datalatest;
```

## 継続的インテグレーション対応

このテストはCI/CDパイプラインに組み込むことができます：

```yaml
# GitHub Actions例
- name: Run PostgreSQL Tests
  run: |
    docker-compose up -d
    sleep 10
    # 各テストファイルを順次実行
    docker-compose exec db psql -U postgres -d postgres -f tests/01_test_sync_procedure.sql
    docker-compose exec db psql -U postgres -d postgres -f tests/02_test_sync_procedure.sql
    docker-compose exec db psql -U postgres -d postgres -f tests/03_test_sync_procedure.sql
    docker-compose exec db psql -U postgres -d postgres -f tests/04_test_sync_procedure.sql
    docker-compose exec db psql -U postgres -d postgres -f tests/05_test_sync_procedure.sql
    docker-compose down
```

## トラブルシューティング

### pgTAP拡張が見つからない場合
```sql
ERROR: extension "pgtap" is not available
```
- Dockerイメージの再ビルドが必要
- `docker-compose build --no-cache db`

### テーブルが存在しない場合
```sql
ERROR: relation "t_data" does not exist
```
- 初期化スクリプトの実行順序を確認
- `07_create_sync_tables.sql` が先に実行されているか確認

### プロシージャが見つからない場合
```sql
ERROR: function sync_t_data_to_t_datalatest_upsert_correct() does not exist
```
- `08_sync_procedure.sql` が正しく実行されているか確認
- initdbディレクトリ内のファイル順序を確認

## 今後の拡張予定

- エラーケースのテスト（存在しないテーブル、不正なデータ型など）
- パフォーマンステスト（大量データでの処理時間測定）
- 同時実行テスト（複数トランザクションでの競合状態テスト）
- 部分的カラム更新のテスト（一部のカラムのみ異なる場合）
