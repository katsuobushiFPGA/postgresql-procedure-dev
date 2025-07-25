-- テーブルA（トランザクションテーブル）とテーブルB（最新状態保持テーブル）の作成

-- テーブルA（随時データが入れ替わるトランザクションテーブル）
DROP TABLE IF EXISTS t_data CASCADE;
CREATE TABLE IF NOT EXISTS t_data (
    pkey_1 VARCHAR(50) NOT NULL,
    pkey_2 VARCHAR(50) NOT NULL,
    pkey_3 VARCHAR(50) NOT NULL,
    pkey_4 VARCHAR(50) NOT NULL,
    column_1 TEXT,
    column_2 TEXT,
    column_3 TEXT,
    column_4 TEXT,
    column_5 TEXT,
    column_6 TEXT,
    column_7 TEXT,
    column_8 TEXT,
    column_9 TEXT,
    column_10 TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_t_data PRIMARY KEY (pkey_1, pkey_2, pkey_3, pkey_4)
);

-- テーブルB（最新の状態を保持するテーブル）
DROP TABLE IF EXISTS t_datalatest CASCADE;
CREATE TABLE IF NOT EXISTS t_datalatest (
    pkey_1 VARCHAR(50) NOT NULL,
    pkey_2 VARCHAR(50) NOT NULL,
    pkey_3 VARCHAR(50) NOT NULL,
    pkey_4 VARCHAR(50) NOT NULL,
    column_1 TEXT,
    column_2 TEXT,
    column_3 TEXT,
    column_4 TEXT,
    column_5 TEXT,
    column_6 TEXT,
    column_7 TEXT,
    column_8 TEXT,
    column_9 TEXT,
    column_10 TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_t_datalatest PRIMARY KEY (pkey_1, pkey_2, pkey_3, pkey_4)
);

-- インデックスの作成（パフォーマンス向上のため）
CREATE INDEX IF NOT EXISTS idx_t_data_updated_at ON t_data (updated_at);
CREATE INDEX IF NOT EXISTS idx_t_datalatest_updated_at ON t_datalatest (updated_at);

-- サンプルデータの挿入（テスト用）
INSERT INTO t_data (pkey_1, pkey_2, pkey_3, pkey_4, column_1, column_2, column_3, column_4, column_5, column_6, column_7, column_8, column_9, column_10)
VALUES 
    ('A001', 'B001', 'C001', 'D001', 'データ1-1', 'データ1-2', 'データ1-3', 'データ1-4', 'データ1-5', 'データ1-6', 'データ1-7', 'データ1-8', 'データ1-9', 'データ1-10'),
    ('A002', 'B002', 'C002', 'D002', 'データ2-1', 'データ2-2', 'データ2-3', 'データ2-4', 'データ2-5', 'データ2-6', 'データ2-7', 'データ2-8', 'データ2-9', 'データ2-10'),
    ('A003', 'B003', 'C003', 'D003', 'データ3-1', 'データ3-2', 'データ3-3', 'データ3-4', 'データ3-5', 'データ3-6', 'データ3-7', 'データ3-8', 'データ3-9', 'データ3-10')
ON CONFLICT DO NOTHING;

INSERT INTO t_datalatest (pkey_1, pkey_2, pkey_3, pkey_4, column_1, column_2, column_3, column_4, column_5, column_6, column_7, column_8, column_9, column_10)
VALUES 
    ('A001', 'B001', 'C001', 'D001', 'データ1-1', 'データ1-2', 'データ1-3', 'データ1-4', 'データ1-5', 'データ1-6', 'データ1-7', 'データ1-8', 'データ1-9', 'データ1-10'),
    ('A002', 'B002', 'C002', 'D002', '古いデータ2-1', '古いデータ2-2', '古いデータ2-3', '古いデータ2-4', '古いデータ2-5', '古いデータ2-6', '古いデータ2-7', '古いデータ2-8', '古いデータ2-9', '古いデータ2-10')
ON CONFLICT DO NOTHING;
