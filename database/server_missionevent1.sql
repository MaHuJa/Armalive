-- Function: server.missionevent1(integer, text, numeric, integer)

-- DROP FUNCTION server.missionevent1(integer, text, numeric, integer);

CREATE OR REPLACE FUNCTION server.missionevent1(sessionid integer, what text, "when" numeric, score integer)
  RETURNS void AS
$BODY$
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.missionevent1(integer, text, numeric, integer)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.missionevent1(integer, text, numeric, integer) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.missionevent1(integer, text, numeric, integer) TO public;
GRANT EXECUTE ON FUNCTION server.missionevent1(integer, text, numeric, integer) TO armalive_server;
