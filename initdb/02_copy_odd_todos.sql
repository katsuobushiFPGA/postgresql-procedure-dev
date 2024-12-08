CREATE OR REPLACE PROCEDURE copy_odd_todos()
LANGUAGE plpgsql
AS $$
DECLARE
  todo_record todos%ROWTYPE; -- todosテーブルの行を格納する変数
BEGIN
  -- 奇数のIDを持つ行をループで処理
  FOR todo_record IN
    SELECT * FROM todos WHERE id % 2 = 1
  LOOP
    BEGIN
      -- titleが空白の場合に例外を投げる
      IF TRIM(todo_record.title) = '' THEN
        RAISE EXCEPTION 'Error: title cannot be empty or whitespace for todo with id %', todo_record.id;
      END IF;

      -- 選択された行を新しいテーブルに挿入
      INSERT INTO todos_copy (title, description, due_date, is_completed)
      VALUES (todo_record.title, todo_record.description, todo_record.due_date, todo_record.is_completed);
    EXCEPTION
      WHEN OTHERS THEN
        -- エラーメッセージをログに記録
        RAISE NOTICE 'Skipping todo with id % due to error: %', todo_record.id, SQLERRM;
        -- 必要であれば、エラー内容を別のテーブルに記録する処理を追加
    END;
  END LOOP;
END;
$$;