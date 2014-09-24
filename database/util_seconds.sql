-- Function: util.seconds(numeric)

-- DROP FUNCTION util.seconds(numeric);

CREATE OR REPLACE FUNCTION util.seconds(seconds numeric)
  RETURNS interval AS
$BODY$
select ($1 || ' seconds') :: interval;
$BODY$
  LANGUAGE sql IMMUTABLE
  COST 1;
ALTER FUNCTION util.seconds(numeric)
  OWNER TO mahuja;
GRANT EXECUTE ON FUNCTION util.seconds(numeric) TO public;
GRANT EXECUTE ON FUNCTION util.seconds(numeric) TO mahuja;
GRANT EXECUTE ON FUNCTION util.seconds(numeric) TO armalive_auto;
