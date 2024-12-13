CREATE OR REPLACE PROCEDURE todo_done(
    IN todo_id bigint,
    OUT is_completed boolean
)
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE todos
  SET is_completed = true
  WHERE id = todo_id;

  -- 更新された行の状態を確認してOUTパラメータに設定
  SELECT is_completed
  INTO is_completed
  FROM todos
  WHERE id = todo_id;
END;
$$;

CREATE OR REPLACE PROCEDURE todo_undone(
    IN todo_id bigint,
    OUT is_completed boolean
)
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE todos
  SET is_completed = false
  WHERE id = todo_id;

  SELECT is_completed
  INTO is_completed
  FROM todos
  WHERE id = todo_id;
END;
$$;

CREATE OR REPLACE PROCEDURE todo_delete(
    IN todo_id bigint,
    OUT result boolean
)
LANGUAGE plpgsql
AS $$
DECLARE
  deleted_count int;
BEGIN
  DELETE FROM todos 
  WHERE id = todo_id
  RETURNING 1 INTO deleted_count;

-- 削除された行が存在した場合はTRUE、そうでなければFALSEを設定
  result := (deleted_count > 0);
END;
$$;

