-- Function: server.uvwstats(integer, numeric, text, text, text, text, numeric, text[])

-- DROP FUNCTION server.uvwstats(integer, numeric, text, text, text, text, numeric, text[]);

CREATE OR REPLACE FUNCTION server.uvwstats(IN sessionid integer, IN "when" numeric, IN playerid text, IN unitclass text, IN vehicleclass text, IN weaponclass text, IN weapontime numeric, VARIADIC hits text[])
  RETURNS void AS
$BODY$
BEGIN
END
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.uvwstats(integer, numeric, text, text, text, text, numeric, text[])
  OWNER TO mahuja;
GRANT EXECUTE ON FUNCTION server.uvwstats(integer, numeric, text, text, text, text, numeric, text[]) TO public;
GRANT EXECUTE ON FUNCTION server.uvwstats(integer, numeric, text, text, text, text, numeric, text[]) TO mahuja;
GRANT EXECUTE ON FUNCTION server.uvwstats(integer, numeric, text, text, text, text, numeric, text[]) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.uvwstats(integer, numeric, text, text, text, text, numeric, text[]) TO armalive_server;
