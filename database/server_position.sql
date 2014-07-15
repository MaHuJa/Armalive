-- Function: server."position"(text)

-- DROP FUNCTION server."position"(text);

CREATE OR REPLACE FUNCTION server."position"(text)
  RETURNS numeric[] AS
$BODY$
  select replace((replace($1,'[','{')), ']','}')
	:: numeric array
$BODY$
  LANGUAGE sql IMMUTABLE STRICT
  COST 100;
ALTER FUNCTION server."position"(text)
  OWNER TO mahuja;
GRANT EXECUTE ON FUNCTION server."position"(text) TO mahuja;
GRANT EXECUTE ON FUNCTION server."position"(text) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server."position"(text) TO armalive_server;
REVOKE ALL ON FUNCTION server."position"(text) FROM public;
