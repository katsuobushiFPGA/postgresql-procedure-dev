-- テスト開始
SELECT plan(1);

-- テスト用のデータをクリア
DELETE FROM t_data;
DELETE FROM t_datalatest;

-- テストケース5: NULLデータの処理テスト
INSERT INTO t_data (pkey_1, pkey_2, pkey_3, pkey_4, column_1, column_2, column_3, column_4, column_5, column_6, column_7, column_8, column_9, column_10)
VALUES ('TEST4', 'B004', 'C004', 'D004', NULL, 'NULL2', NULL, 'NULL4', NULL, 'NULL6', NULL, 'NULL8', NULL, 'NULL10');

INSERT INTO t_datalatest (pkey_1, pkey_2, pkey_3, pkey_4, column_1, column_2, column_3, column_4, column_5, column_6, column_7, column_8, column_9, column_10)
VALUES ('TEST4', 'B004', 'C004', 'D004', NULL, 'NULL2', NULL, 'NULL4', NULL, 'NULL6', NULL, 'NULL8', NULL, 'NULL10');

-- プロシージャ実行
CALL sync_t_data_to_t_datalatest_upsert_correct();

-- NULL値の同一判定テスト
SELECT is(
    (SELECT COUNT(*) FROM t_data WHERE pkey_1 = 'TEST4' AND pkey_2 = 'B004' AND pkey_3 = 'C004' AND pkey_4 = 'D004'),
    0::bigint,
    'テスト後: NULL値を含む同一レコードがt_dataから削除された'
);

-- テスト完了
SELECT finish();
