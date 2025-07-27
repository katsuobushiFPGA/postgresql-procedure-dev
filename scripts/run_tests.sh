#!/bin/bash

# pgTAPテスト実行スクリプト

echo "=== pgTAPテスト実行開始 ==="

# PostgreSQLコンテナでテストを実行
docker-compose exec db pg_prove -U postgres -d postgres /tests/01_test_sync_procedure.sql
docker-compose exec db pg_prove -U postgres -d postgres /tests/02_test_sync_procedure.sql
docker-compose exec db pg_prove -U postgres -d postgres /tests/03_test_sync_procedure.sql
docker-compose exec db pg_prove -U postgres -d postgres /tests/04_test_sync_procedure.sql
docker-compose exec db pg_prove -U postgres -d postgres /tests/05_test_sync_procedure.sql

echo "=== pgTAPテスト実行完了 ==="
