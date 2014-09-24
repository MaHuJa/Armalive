-- Function: util."position"(text)

-- DROP FUNCTION util."position"(text);

CREATE OR REPLACE FUNCTION util."position"(text)
  RETURNS numeric[] AS
$BODY$
  select replace((replace($1,'[','{')), ']','}')
	:: numeric array
$BODY$
  LANGUAGE sql IMMUTABLE STRICT
  COST 100;
ALTER FUNCTION util."position"(text)
  OWNER TO mahuja;
GRANT EXECUTE ON FUNCTION util."position"(text) TO mahuja;
GRANT EXECUTE ON FUNCTION util."position"(text) TO armalive_auto;
GRANT EXECUTE ON FUNCTION util."position"(text) TO armalive_server;
REVOKE ALL ON FUNCTION util."position"(text) FROM public;
