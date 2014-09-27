-- Function: server.missionevent1(integer, text, numeric, integer)

-- DROP FUNCTION server.missionevent1(integer, text, numeric, integer);

CREATE OR REPLACE FUNCTION server.missionevent1(sessionid integer, "when" numeric, what text, VARIADIC playerlist text[])
  RETURNS void AS
$BODY$
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.missionevent1(integer, text, numeric, VARIADIC text[])
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.missionevent1(integer, text, numeric, VARIADIC text[]) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.missionevent1(integer, text, numeric, VARIADIC text[]) TO public;
GRANT EXECUTE ON FUNCTION server.missionevent1(integer, text, numeric, VARIADIC text[]) TO armalive_server;
