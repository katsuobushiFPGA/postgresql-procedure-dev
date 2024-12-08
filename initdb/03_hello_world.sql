CREATE OR REPLACE PROCEDURE hello_world()
LANGUAGE plpgsql
AS $$
BEGIN
  RAISE INFO 'Hello, World';
END;  
$$;