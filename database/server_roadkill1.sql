-- Function: server.roadkill1(integer, text, text, text, integer, text)

-- DROP FUNCTION server.roadkill1(integer, text, text, text, integer, text);

CREATE OR REPLACE FUNCTION server.roadkill1(sessionid integer, victimid text, killerid text, vehicle_used text, score integer, "position" text)
  RETURNS void AS
$BODY$
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.roadkill1(integer, text, text, text, integer, text)
  OWNER TO mahuja;
GRANT EXECUTE ON FUNCTION server.roadkill1(integer, text, text, text, integer, text) TO mahuja;
GRANT EXECUTE ON FUNCTION server.roadkill1(integer, text, text, text, integer, text) TO public;
GRANT EXECUTE ON FUNCTION server.roadkill1(integer, text, text, text, integer, text) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.roadkill1(integer, text, text, text, integer, text) TO armalive_server;
