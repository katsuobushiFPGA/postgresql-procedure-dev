CREATE OR REPLACE PROCEDURE todo_done_debug(
    IN todo_id bigint,
    OUT is_completed boolean
)
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE todos
  SET is_completed = true
  WHERE id = todo_id;
  RAISE INFO 'Updated todo with id %', todo_id;

  -- 更新された行の状態を確認してOUTパラメータに設定
  SELECT is_completed
  INTO is_completed
  FROM todos
  WHERE id = todo_id;
END;
$$;