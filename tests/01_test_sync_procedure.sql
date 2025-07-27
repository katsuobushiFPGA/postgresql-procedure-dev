-- テスト開始
SELECT plan(1);

-- テスト用のデータをクリア
DELETE FROM t_data;
DELETE FROM t_datalatest;

-- テストケース1: プロシージャが存在することの確認
SELECT has_function(
    'sync_t_data_to_t_datalatest_upsert_correct',
    ARRAY[]::TEXT[],
    'sync_t_data_to_t_datalatest_upsert_correct プロシージャが存在する'
);

-- テスト完了
SELECT finish();
