-- Function: server.friendlydmg1(integer, text, text, integer, text, integer, numeric, text, text)

-- DROP FUNCTION server.friendlydmg1(integer, text, text, integer, text, integer, numeric, text, text);

CREATE OR REPLACE FUNCTION server.friendlydmg1(sessionid integer, victimid text, damageruid text, "when" integer, weapon text, score integer, distance numeric, victimpos text, killerpos text)
  RETURNS void AS
$BODY$
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.friendlydmg1(integer, text, text, integer, text, integer, numeric, text, text)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.friendlydmg1(integer, text, text, integer, text, integer, numeric, text, text) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.friendlydmg1(integer, text, text, integer, text, integer, numeric, text, text) TO public;
GRANT EXECUTE ON FUNCTION server.friendlydmg1(integer, text, text, integer, text, integer, numeric, text, text) TO armalive_server;
