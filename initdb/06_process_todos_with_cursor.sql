CREATE OR REPLACE PROCEDURE process_todos_with_cursor()
LANGUAGE plpgsql
AS $$
DECLARE
  todo_cursor REFCURSOR;         -- カーソルの宣言
  todo_record todos%ROWTYPE;     -- todosテーブルの1行を格納する変数
BEGIN
  -- カーソルを開く
  OPEN todo_cursor FOR
    SELECT * FROM todos; -- todosテーブルのすべての行を取得

  -- カーソルから1行ずつ取得して処理
  LOOP
    FETCH todo_cursor INTO todo_record; -- カーソルから次の行を取得
    EXIT WHEN NOT FOUND;               -- データがない場合はループを終了

    -- 各行に対する処理
    RAISE NOTICE 'Processing todo: ID = %, Title = %', todo_record.id, todo_record.title;
  END LOOP;

  -- カーソルを閉じる
  CLOSE todo_cursor;
END;
$$;