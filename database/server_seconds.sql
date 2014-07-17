-- Function: server.seconds(numeric)

-- DROP FUNCTION server.seconds(numeric);

CREATE OR REPLACE FUNCTION server.seconds(seconds numeric)
  RETURNS interval AS
$BODY$
select ($1 || ' seconds') :: interval;
$BODY$
  LANGUAGE sql IMMUTABLE
  COST 1;
ALTER FUNCTION server.seconds(numeric)
  OWNER TO mahuja;
GRANT EXECUTE ON FUNCTION server.seconds(numeric) TO public;
