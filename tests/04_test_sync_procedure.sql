-- テスト開始（テスト数を調整）
SELECT plan(4);

-- テスト用のデータをクリア
DELETE FROM t_data;
DELETE FROM t_datalatest;

-- テストケース4: 差分ありデータの更新テスト
INSERT INTO t_data (pkey_1, pkey_2, pkey_3, pkey_4, column_1, column_2, column_3, column_4, column_5, column_6, column_7, column_8, column_9, column_10)
VALUES ('TEST3', 'B003', 'C003', 'D003', '更新後1', '更新後2', '更新後3', '更新後4', '更新後5', '更新後6', '更新後7', '更新後8', '更新後9', '更新後10');

INSERT INTO t_datalatest (pkey_1, pkey_2, pkey_3, pkey_4, column_1, column_2, column_3, column_4, column_5, column_6, column_7, column_8, column_9, column_10)
VALUES ('TEST3', 'B003', 'C003', 'D003', '更新前1', '更新前2', '更新前3', '更新前4', '更新前5', '更新前6', '更新前7', '更新前8', '更新前9', '更新前10');

-- プロシージャ実行前のテスト
SELECT is(
    (SELECT COUNT(*) FROM t_data WHERE pkey_1 = 'TEST3' AND pkey_2 = 'B003' AND pkey_3 = 'C003' AND pkey_4 = 'D003'),
    1::bigint,
    'テスト前: t_data に差分ありレコードが存在する'
);

-- 事前にデータが異なることを確認
SELECT is(
    (SELECT COALESCE(column_1, '') || '|' || COALESCE(column_2, '') || '|' || 
            COALESCE(column_3, '') || '|' || COALESCE(column_4, '') || '|' || 
            COALESCE(column_5, '') || '|' || COALESCE(column_6, '') || '|' || 
            COALESCE(column_7, '') || '|' || COALESCE(column_8, '') || '|' || 
            COALESCE(column_9, '') || '|' || COALESCE(column_10, '')
     FROM t_datalatest 
     WHERE pkey_1 = 'TEST3' AND pkey_2 = 'B003' AND pkey_3 = 'C003' AND pkey_4 = 'D003'),
    '更新前1|更新前2|更新前3|更新前4|更新前5|更新前6|更新前7|更新前8|更新前9|更新前10',
    'テスト前: t_datalatest に古いデータが存在する（全カラム確認）'
);

-- プロシージャ実行
CALL sync_t_data_to_t_datalatest_upsert_correct();

-- 差分あり更新のテスト：全カラムが正しく更新されたかを確認
SELECT is(
    (SELECT COALESCE(column_1, '') || '|' || COALESCE(column_2, '') || '|' || 
            COALESCE(column_3, '') || '|' || COALESCE(column_4, '') || '|' || 
            COALESCE(column_5, '') || '|' || COALESCE(column_6, '') || '|' || 
            COALESCE(column_7, '') || '|' || COALESCE(column_8, '') || '|' || 
            COALESCE(column_9, '') || '|' || COALESCE(column_10, '')
     FROM t_datalatest 
     WHERE pkey_1 = 'TEST3' AND pkey_2 = 'B003' AND pkey_3 = 'C003' AND pkey_4 = 'D003'),
    '更新後1|更新後2|更新後3|更新後4|更新後5|更新後6|更新後7|更新後8|更新後9|更新後10',
    'テスト後: t_datalatest の全カラム（column_1～column_10）が正しく更新された'
);

SELECT is(
    (SELECT COUNT(*) FROM t_data WHERE pkey_1 = 'TEST3' AND pkey_2 = 'B003' AND pkey_3 = 'C003' AND pkey_4 = 'D003'),
    1::bigint,
    'テスト後: 差分ありレコードはt_dataから削除されていない'
);

-- テスト完了
SELECT finish();
