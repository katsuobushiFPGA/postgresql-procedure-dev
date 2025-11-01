-- PostgreSQL パーティションテーブルでのインデックス検証
-- パーティションキー以外のカラムでのWHERE句でインデックスが効くかを確認する

-- 1. 親テーブルの作成（パーティションテーブル）
CREATE TABLE sales (
    id BIGSERIAL,
    sale_date DATE NOT NULL,
    customer_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    region VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY RANGE (sale_date);

-- 2. パーティションの作成（月ごとに分割）
CREATE TABLE sales_2024_01 PARTITION OF sales
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE sales_2024_02 PARTITION OF sales
    FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

CREATE TABLE sales_2024_03 PARTITION OF sales
    FOR VALUES FROM ('2024-03-01') TO ('2024-04-01');

CREATE TABLE sales_2024_04 PARTITION OF sales
    FOR VALUES FROM ('2024-04-01') TO ('2024-05-01');

CREATE TABLE sales_2024_05 PARTITION OF sales
    FOR VALUES FROM ('2024-05-01') TO ('2024-06-01');

CREATE TABLE sales_2024_06 PARTITION OF sales
    FOR VALUES FROM ('2024-06-01') TO ('2024-07-01');

-- 3. インデックスの作成
-- パーティションキー（sale_date）のインデックス
CREATE INDEX idx_sales_sale_date ON sales (sale_date);

-- パーティションキー以外のカラムのインデックス
CREATE INDEX idx_sales_customer_id ON sales (customer_id);
CREATE INDEX idx_sales_product_id ON sales (product_id);
CREATE INDEX idx_sales_region ON sales (region);
CREATE INDEX idx_sales_status ON sales (status);

-- 複合インデックス
CREATE INDEX idx_sales_customer_product ON sales (customer_id, product_id);
CREATE INDEX idx_sales_region_status ON sales (region, status);

-- 4. テストデータの挿入
-- 各月に500件ずつ、合計3000件のデータを挿入
INSERT INTO sales (sale_date, customer_id, product_id, amount, region, status)
SELECT
    DATE '2024-01-01' + (i % 31) * INTERVAL '1 day' AS sale_date,
    (random() * 1000)::INTEGER + 1 AS customer_id,
    (random() * 50)::INTEGER + 1 AS product_id,
    (random() * 10000)::DECIMAL(10, 2) + 100 AS amount,
    CASE (random() * 4)::INTEGER
        WHEN 0 THEN 'North'
        WHEN 1 THEN 'South'
        WHEN 2 THEN 'East'
        ELSE 'West'
    END AS region,
    CASE (random() * 3)::INTEGER
        WHEN 0 THEN 'pending'
        WHEN 1 THEN 'completed'
        ELSE 'cancelled'
    END AS status
FROM generate_series(1, 500) AS i;

INSERT INTO sales (sale_date, customer_id, product_id, amount, region, status)
SELECT
    DATE '2024-02-01' + (i % 29) * INTERVAL '1 day' AS sale_date,
    (random() * 1000)::INTEGER + 1 AS customer_id,
    (random() * 50)::INTEGER + 1 AS product_id,
    (random() * 10000)::DECIMAL(10, 2) + 100 AS amount,
    CASE (random() * 4)::INTEGER
        WHEN 0 THEN 'North'
        WHEN 1 THEN 'South'
        WHEN 2 THEN 'East'
        ELSE 'West'
    END AS region,
    CASE (random() * 3)::INTEGER
        WHEN 0 THEN 'pending'
        WHEN 1 THEN 'completed'
        ELSE 'cancelled'
    END AS status
FROM generate_series(1, 500) AS i;

INSERT INTO sales (sale_date, customer_id, product_id, amount, region, status)
SELECT
    DATE '2024-03-01' + (i % 31) * INTERVAL '1 day' AS sale_date,
    (random() * 1000)::INTEGER + 1 AS customer_id,
    (random() * 50)::INTEGER + 1 AS product_id,
    (random() * 10000)::DECIMAL(10, 2) + 100 AS amount,
    CASE (random() * 4)::INTEGER
        WHEN 0 THEN 'North'
        WHEN 1 THEN 'South'
        WHEN 2 THEN 'East'
        ELSE 'West'
    END AS region,
    CASE (random() * 3)::INTEGER
        WHEN 0 THEN 'pending'
        WHEN 1 THEN 'completed'
        ELSE 'cancelled'
    END AS status
FROM generate_series(1, 500) AS i;

INSERT INTO sales (sale_date, customer_id, product_id, amount, region, status)
SELECT
    DATE '2024-04-01' + (i % 30) * INTERVAL '1 day' AS sale_date,
    (random() * 1000)::INTEGER + 1 AS customer_id,
    (random() * 50)::INTEGER + 1 AS product_id,
    (random() * 10000)::DECIMAL(10, 2) + 100 AS amount,
    CASE (random() * 4)::INTEGER
        WHEN 0 THEN 'North'
        WHEN 1 THEN 'South'
        WHEN 2 THEN 'East'
        ELSE 'West'
    END AS region,
    CASE (random() * 3)::INTEGER
        WHEN 0 THEN 'pending'
        WHEN 1 THEN 'completed'
        ELSE 'cancelled'
    END AS status
FROM generate_series(1, 500) AS i;

INSERT INTO sales (sale_date, customer_id, product_id, amount, region, status)
SELECT
    DATE '2024-05-01' + (i % 31) * INTERVAL '1 day' AS sale_date,
    (random() * 1000)::INTEGER + 1 AS customer_id,
    (random() * 50)::INTEGER + 1 AS product_id,
    (random() * 10000)::DECIMAL(10, 2) + 100 AS amount,
    CASE (random() * 4)::INTEGER
        WHEN 0 THEN 'North'
        WHEN 1 THEN 'South'
        WHEN 2 THEN 'East'
        ELSE 'West'
    END AS region,
    CASE (random() * 3)::INTEGER
        WHEN 0 THEN 'pending'
        WHEN 1 THEN 'completed'
        ELSE 'cancelled'
    END AS status
FROM generate_series(1, 500) AS i;

INSERT INTO sales (sale_date, customer_id, product_id, amount, region, status)
SELECT
    DATE '2024-06-01' + (i % 30) * INTERVAL '1 day' AS sale_date,
    (random() * 1000)::INTEGER + 1 AS customer_id,
    (random() * 50)::INTEGER + 1 AS product_id,
    (random() * 10000)::DECIMAL(10, 2) + 100 AS amount,
    CASE (random() * 4)::INTEGER
        WHEN 0 THEN 'North'
        WHEN 1 THEN 'South'
        WHEN 2 THEN 'East'
        ELSE 'West'
    END AS region,
    CASE (random() * 3)::INTEGER
        WHEN 0 THEN 'pending'
        WHEN 1 THEN 'completed'
        ELSE 'cancelled'
    END AS status
FROM generate_series(1, 500) AS i;

-- 5. 統計情報の更新
ANALYZE sales;

-- 6. パーティション情報の確認
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE tablename LIKE 'sales%'
ORDER BY tablename;

-- 7. インデックス一覧の確認
SELECT
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename LIKE 'sales%'
ORDER BY tablename, indexname;

/*
================================================================================
検証クエリ例: パーティションプルーニングの動作確認
================================================================================

-- ケース1: 正しい書き方（プルーニングが効く - 1つのパーティション）
EXPLAIN ANALYZE
SELECT * FROM sales 
WHERE sale_date >= '2024-03-01' 
AND sale_date < '2024-04-01';
-- 期待: 1つのパーティション（sales_2024_03）のみスキャン

-- ケース2: BETWEEN で正しく指定（プルーニングが効く - 1つのパーティション）
EXPLAIN ANALYZE
SELECT * FROM sales 
WHERE sale_date BETWEEN '2024-03-01' AND '2024-03-31';
-- 期待: 1つのパーティション（sales_2024_03）のみスキャン

================================================================================
パーティションキーがあっても全パーティションスキャンになるケース
================================================================================

-- ケース3: 関数を使った条件（パーティションプルーニングが効かない）
EXPLAIN ANALYZE
SELECT * FROM sales 
WHERE EXTRACT(YEAR FROM sale_date) = 2024
AND EXTRACT(MONTH FROM sale_date) = 3;
-- 期待: 全パーティションスキャン（関数を使うとプルーニングが効かない）

-- ケース4: 型変換を伴う条件
EXPLAIN ANALYZE
SELECT * FROM sales 
WHERE sale_date::TEXT LIKE '2024-03%';
-- 期待: 全パーティションスキャン（型変換が入るとプルーニングが効かない）

-- ケース5: OR条件で複数の範囲を指定（不連続な範囲）
EXPLAIN ANALYZE
SELECT * FROM sales 
WHERE sale_date BETWEEN '2024-01-01' AND '2024-01-31'
   OR sale_date BETWEEN '2024-06-01' AND '2024-06-30';
-- 期待: 2つのパーティションのみスキャン（sales_2024_01 と sales_2024_06）

-- ケース6: 範囲が広すぎる条件（ほぼ全パーティション）
EXPLAIN ANALYZE
SELECT * FROM sales 
WHERE sale_date >= '2024-01-01';
-- 期待: 全6パーティションスキャン（条件に該当するパーティションが多い）

-- ケース7: 否定条件
EXPLAIN ANALYZE
SELECT * FROM sales 
WHERE sale_date != '2024-03-15';
-- 期待: 全パーティションスキャン（否定条件はプルーニングできない）

-- ケース8: IN句で関数を使用
EXPLAIN ANALYZE
SELECT * FROM sales 
WHERE EXTRACT(MONTH FROM sale_date) IN (1, 2, 3, 4, 5, 6);
-- 期待: 全パーティションスキャン（関数 + 全範囲カバー）

-- ケース9: サブクエリでパーティションキーを動的に決定
EXPLAIN ANALYZE
SELECT * FROM sales 
WHERE sale_date = (SELECT MAX(sale_date) FROM sales);
-- 期待: 全パーティションスキャン（実行時にしか値が決まらない）

-- ケース10: 複雑な条件式（左辺に計算）
EXPLAIN ANALYZE
SELECT * FROM sales 
WHERE sale_date + INTERVAL '1 day' > '2024-03-01';
-- 期待: 全パーティションスキャン（左辺に計算があるとプルーニングが効かない）

-- ケース11: 複雑な条件式（右辺に計算 - プルーニングが効く）
EXPLAIN ANALYZE
SELECT * FROM sales 
WHERE sale_date > '2024-03-01'::DATE - INTERVAL '1 day';
-- 期待: プルーニングが効く（右辺の計算は問題なし）

================================================================================
パーティション数とスキャン範囲の確認
================================================================================

-- パーティションごとのデータ件数を確認
SELECT 
    tableoid::regclass AS partition_name,
    COUNT(*) AS row_count
FROM sales
GROUP BY tableoid
ORDER BY partition_name;

-- 実行計画でスキャンされるパーティション数を確認（全パーティション）
EXPLAIN (VERBOSE, COSTS OFF)
SELECT * FROM sales 
WHERE EXTRACT(MONTH FROM sale_date) = 3;
-- 全6パーティションがスキャンされることを確認

-- 実行計画でスキャンされるパーティション数を確認（1つのみ）
EXPLAIN (VERBOSE, COSTS OFF)
SELECT * FROM sales 
WHERE sale_date BETWEEN '2024-03-01' AND '2024-03-31';
-- 1つのパーティション（sales_2024_03）のみスキャンされることを確認

================================================================================
まとめ: パーティションプルーニングが効く/効かないケース
================================================================================

【パーティションプルーニングが効かないケース（全パーティションスキャン）】

1. 関数適用
   NG: WHERE EXTRACT(YEAR FROM sale_date) = 2024
   NG: WHERE DATE_TRUNC('month', sale_date) = '2024-03-01'
   OK: WHERE sale_date >= '2024-03-01' AND sale_date < '2024-04-01'

2. 型変換
   NG: WHERE sale_date::TEXT LIKE '2024-03%'
   OK: WHERE sale_date >= '2024-03-01' AND sale_date < '2024-04-01'

3. 否定条件
   NG: WHERE sale_date != '2024-03-15'
   OK: WHERE sale_date >= '2024-03-01' AND sale_date < '2024-04-01'

4. 動的な値（実行時決定）
   NG: WHERE sale_date = (SELECT MAX(sale_date) FROM sales)

5. 広すぎる範囲
   NG: WHERE sale_date >= '2024-01-01'  -- 全期間に該当
   OK: WHERE sale_date >= '2024-03-01' AND sale_date < '2024-04-01'

6. 複雑な条件式（左辺に計算）
   NG: WHERE sale_date + INTERVAL '1 day' > '2024-03-01'
   OK: WHERE sale_date > '2024-03-01' - INTERVAL '1 day'
   (右辺の計算は OK、左辺の計算は NG)

【パーティションプルーニングを効かせるベストプラクティス】

✓ パーティションキーをそのまま使う（関数や型変換を避ける）
✓ 等号、不等号、BETWEEN を使う
✓ 範囲を明示的に指定する
✓ 右辺に関数や計算を配置する（左辺はシンプルに）

【検証結果の見方】

EXPLAIN (VERBOSE) の出力で以下を確認：
- Subplans Removed: N → N個のパーティションがプルーニングされた
- Seq Scan on sales_2024_XX → スキャンされたパーティション名

プルーニングが効いている例:
  Append
    -> Seq Scan on sales_2024_03  （1つのパーティションのみ）

プルーニングが効いていない例:
  Append
    -> Seq Scan on sales_2024_01
    -> Seq Scan on sales_2024_02
    -> Seq Scan on sales_2024_03
    -> Seq Scan on sales_2024_04
    -> Seq Scan on sales_2024_05
    -> Seq Scan on sales_2024_06  （全6パーティション）

================================================================================
*/
