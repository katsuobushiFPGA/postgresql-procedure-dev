-- テスト開始
SELECT plan(5);

-- テスト用のデータをクリア
DELETE FROM t_data;
DELETE FROM t_datalatest;

-- テストケース2: 新規データの挿入テスト
INSERT INTO t_data (pkey_1, pkey_2, pkey_3, pkey_4, column_1, column_2, column_3, column_4, column_5, column_6, column_7, column_8, column_9, column_10)
VALUES ('TEST1', 'B001', 'C001', 'D001', '新規1', '新規2', '新規3', '新規4', '新規5', '新規6', '新規7', '新規8', '新規9', '新規10');

-- プロシージャ実行前のテスト
SELECT is(
    (SELECT COUNT(*) FROM t_data WHERE pkey_1 = 'TEST1' AND pkey_2 = 'B001' AND pkey_3 = 'C001' AND pkey_4 = 'D001'),
    1::bigint,
    'テスト前: t_dataに新規レコードが存在する'
);

SELECT is(
    (SELECT COUNT(*) FROM t_datalatest WHERE pkey_1 = 'TEST1' AND pkey_2 = 'B001' AND pkey_3 = 'C001' AND pkey_4 = 'D001'),
    0::bigint,
    'テスト前: t_datalatest に該当レコードが存在しない'
);

-- プロシージャ実行
CALL sync_t_data_to_t_datalatest_upsert_correct();

-- 新規挿入のテスト
SELECT is(
    (SELECT COUNT(*) FROM t_datalatest WHERE pkey_1 = 'TEST1' AND pkey_2 = 'B001' AND pkey_3 = 'C001' AND pkey_4 = 'D001'),
    1::bigint,
    'テスト後: t_datalatest に新規レコードが挿入された'
);

SELECT is(
    (SELECT column_1 FROM t_datalatest WHERE pkey_1 = 'TEST1' AND pkey_2 = 'B001' AND pkey_3 = 'C001' AND pkey_4 = 'D001'),
    '新規1',
    'テスト後: 挿入されたデータが正しい'
);

SELECT is(
    (SELECT COUNT(*) FROM t_data WHERE pkey_1 = 'TEST1' AND pkey_2 = 'B001' AND pkey_3 = 'C001' AND pkey_4 = 'D001'),
    1::bigint,
    'テスト後: 新規データはt_dataから削除されていない'
);

-- テスト完了
SELECT finish();
