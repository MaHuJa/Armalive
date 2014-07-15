-- Function: server.wpninfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer)

-- DROP FUNCTION server.wpninfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer);

CREATE OR REPLACE FUNCTION server.wpninfo1(sessionid integer, playerid text, vehicleclass text, "when" integer, weapontime integer, shotsfired integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer)
  RETURNS void AS
$BODY$
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.wpninfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer)
  OWNER TO mahuja;
GRANT EXECUTE ON FUNCTION server.wpninfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer) TO mahuja;
GRANT EXECUTE ON FUNCTION server.wpninfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer) TO public;
GRANT EXECUTE ON FUNCTION server.wpninfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.wpninfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer) TO armalive_server;
