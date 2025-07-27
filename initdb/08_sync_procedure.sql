-- テーブルAとテーブルBの差分更新プロシージャ
-- 要件：
-- ・AとBを比較して差分がないレコードのみをAから削除
-- ・差分があるレコードはBを更新（Aからは削除しない）
-- ・BにないレコードはBに挿入（Aからは削除しない）

-- UPSERT版の正しい同期プロシージャ
CREATE OR REPLACE PROCEDURE sync_t_data_to_t_datalatest_upsert_correct()
LANGUAGE plpgsql
AS $$
DECLARE
    total_count INTEGER;
    deleted_count INTEGER := 0;
    upsert_count INTEGER := 0;
BEGIN
    RAISE NOTICE '差分チェック処理を開始します...';
    
    -- テーブルAのレコード数を取得
    SELECT COUNT(*) INTO total_count FROM t_data;

    -- 差分がない場合のみテーブルAからの削除
    DELETE FROM t_data 
    USING t_datalatest 
    WHERE t_data.pkey_1 = t_datalatest.pkey_1 
      AND t_data.pkey_2 = t_datalatest.pkey_2 
      AND t_data.pkey_3 = t_datalatest.pkey_3 
      AND t_data.pkey_4 = t_datalatest.pkey_4
      AND t_data.column_1 IS NOT DISTINCT FROM t_datalatest.column_1
      AND t_data.column_2 IS NOT DISTINCT FROM t_datalatest.column_2
      AND t_data.column_3 IS NOT DISTINCT FROM t_datalatest.column_3
      AND t_data.column_4 IS NOT DISTINCT FROM t_datalatest.column_4
      AND t_data.column_5 IS NOT DISTINCT FROM t_datalatest.column_5
      AND t_data.column_6 IS NOT DISTINCT FROM t_datalatest.column_6
      AND t_data.column_7 IS NOT DISTINCT FROM t_datalatest.column_7
      AND t_data.column_8 IS NOT DISTINCT FROM t_datalatest.column_8
      AND t_data.column_9 IS NOT DISTINCT FROM t_datalatest.column_9
      AND t_data.column_10 IS NOT DISTINCT FROM t_datalatest.column_10;
      
    GET DIAGNOSTICS deleted_count = ROW_COUNT;

    -- UPSERT (INSERT ... ON CONFLICT DO UPDATE) で一括処理
    -- 差分がある場合のみ更新、新規の場合は挿入
    INSERT INTO t_datalatest (
        pkey_1, pkey_2, pkey_3, pkey_4,
        column_1, column_2, column_3, column_4, column_5,
        column_6, column_7, column_8, column_9, column_10
    )
    SELECT 
        a.pkey_1, a.pkey_2, a.pkey_3, a.pkey_4,
        a.column_1, a.column_2, a.column_3, a.column_4, a.column_5,
        a.column_6, a.column_7, a.column_8, a.column_9, a.column_10
    FROM t_data a
    ON CONFLICT (pkey_1, pkey_2, pkey_3, pkey_4) 
    DO UPDATE SET
        column_1 = EXCLUDED.column_1,
        column_2 = EXCLUDED.column_2,
        column_3 = EXCLUDED.column_3,
        column_4 = EXCLUDED.column_4,
        column_5 = EXCLUDED.column_5,
        column_6 = EXCLUDED.column_6,
        column_7 = EXCLUDED.column_7,
        column_8 = EXCLUDED.column_8,
        column_9 = EXCLUDED.column_9,
        column_10 = EXCLUDED.column_10,
        updated_at = CURRENT_TIMESTAMP
    WHERE (
        t_datalatest.column_1 IS DISTINCT FROM EXCLUDED.column_1 OR
        t_datalatest.column_2 IS DISTINCT FROM EXCLUDED.column_2 OR
        t_datalatest.column_3 IS DISTINCT FROM EXCLUDED.column_3 OR
        t_datalatest.column_4 IS DISTINCT FROM EXCLUDED.column_4 OR
        t_datalatest.column_5 IS DISTINCT FROM EXCLUDED.column_5 OR
        t_datalatest.column_6 IS DISTINCT FROM EXCLUDED.column_6 OR
        t_datalatest.column_7 IS DISTINCT FROM EXCLUDED.column_7 OR
        t_datalatest.column_8 IS DISTINCT FROM EXCLUDED.column_8 OR
        t_datalatest.column_9 IS DISTINCT FROM EXCLUDED.column_9 OR
        t_datalatest.column_10 IS DISTINCT FROM EXCLUDED.column_10
    );
    GET DIAGNOSTICS upsert_count = ROW_COUNT;

    -- 処理結果のサマリーを出力
    RAISE NOTICE '処理件数: %件', total_count;
    RAISE NOTICE 'UPSERT総処理件数: %件', upsert_count;
    RAISE NOTICE 'Aから削除（差分なし）: %件', deleted_count;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION '差分チェック処理中にエラーが発生しました: %', SQLERRM;
END;
$$;
