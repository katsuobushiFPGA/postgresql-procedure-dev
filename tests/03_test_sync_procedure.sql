-- テスト開始（テスト数を増やす）
SELECT plan(5);

-- テスト用のデータをクリア
DELETE FROM t_data;
DELETE FROM t_datalatest;

-- テストケース3: 差分なしデータの削除テスト
INSERT INTO t_data (pkey_1, pkey_2, pkey_3, pkey_4, column_1, column_2, column_3, column_4, column_5, column_6, column_7, column_8, column_9, column_10)
VALUES ('TEST2', 'B002', 'C002', 'D002', '同一1', '同一2', '同一3', '同一4', '同一5', '同一6', '同一7', '同一8', '同一9', '同一10');

INSERT INTO t_datalatest (pkey_1, pkey_2, pkey_3, pkey_4, column_1, column_2, column_3, column_4, column_5, column_6, column_7, column_8, column_9, column_10)
VALUES ('TEST2', 'B002', 'C002', 'D002', '同一1', '同一2', '同一3', '同一4', '同一5', '同一6', '同一7', '同一8', '同一9', '同一10');

-- プロシージャ実行前のテスト
SELECT is(
    (SELECT COUNT(*) FROM t_data WHERE pkey_1 = 'TEST2' AND pkey_2 = 'B002' AND pkey_3 = 'C002' AND pkey_4 = 'D002'),
    1::bigint,
    'テスト前: t_dataに同一レコードが存在する'
);

SELECT is(
    (SELECT COUNT(*) FROM t_datalatest WHERE pkey_1 = 'TEST2' AND pkey_2 = 'B002' AND pkey_3 = 'C002' AND pkey_4 = 'D002'),
    1::bigint,
    'テスト前: t_datalatest に同一レコードが存在する'
);

-- データカラムが完全に一致していることを確認
SELECT is(
    (SELECT COALESCE(column_1, '') || '|' || COALESCE(column_2, '') || '|' || 
            COALESCE(column_3, '') || '|' || COALESCE(column_4, '') || '|' || 
            COALESCE(column_5, '') || '|' || COALESCE(column_6, '') || '|' || 
            COALESCE(column_7, '') || '|' || COALESCE(column_8, '') || '|' || 
            COALESCE(column_9, '') || '|' || COALESCE(column_10, '')
     FROM t_data 
     WHERE pkey_1 = 'TEST2' AND pkey_2 = 'B002' AND pkey_3 = 'C002' AND pkey_4 = 'D002'),
    (SELECT COALESCE(column_1, '') || '|' || COALESCE(column_2, '') || '|' || 
            COALESCE(column_3, '') || '|' || COALESCE(column_4, '') || '|' || 
            COALESCE(column_5, '') || '|' || COALESCE(column_6, '') || '|' || 
            COALESCE(column_7, '') || '|' || COALESCE(column_8, '') || '|' || 
            COALESCE(column_9, '') || '|' || COALESCE(column_10, '')
     FROM t_datalatest 
     WHERE pkey_1 = 'TEST2' AND pkey_2 = 'B002' AND pkey_3 = 'C002' AND pkey_4 = 'D002'),
    'テスト前: t_dataとt_datalatest の全データカラムが完全に一致している'
);

-- プロシージャ実行
CALL sync_t_data_to_t_datalatest_upsert_correct();

-- 差分なし削除のテスト
SELECT is(
    (SELECT COUNT(*) FROM t_data WHERE pkey_1 = 'TEST2' AND pkey_2 = 'B002' AND pkey_3 = 'C002' AND pkey_4 = 'D002'),
    0::bigint,
    'テスト後: 差分なしレコードがt_dataから削除された'
);

SELECT is(
    (SELECT COUNT(*) FROM t_datalatest WHERE pkey_1 = 'TEST2' AND pkey_2 = 'B002' AND pkey_3 = 'C002' AND pkey_4 = 'D002'),
    1::bigint,
    'テスト後: t_datalatest のレコードは残っている'
);

-- テスト完了
SELECT finish();
