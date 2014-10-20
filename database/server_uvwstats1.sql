-- Function: server.uvwstats1(integer, numeric, text, text, text, text, numeric, text[])

-- DROP FUNCTION server.uvwstats1(integer, numeric, text, text, text, text, numeric, text[]);

CREATE OR REPLACE FUNCTION server.uvwstats1
(IN sessionid integer, IN "when" numeric, IN playerid text, 
IN unitclass text, IN vehicleclass text, IN weaponclass text, 
IN weapontime numeric, VARIADIC hits text[])
  RETURNS void AS
$BODY$
DECLARE
  playerid integer = util.player_uid_to_id($3);
BEGIN
  EXECUTE util.checkwritable($1);
  INSERT INTO player.uvwstats_raw (session, player, 
    unit, vehicle, weapon, 
    totalseconds, fired, hits)
  VALUES ($1, playerid, 
    $4, $5, $6, 
    $7, $8, $9);
END
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.uvwstats1(integer, numeric, text, text, text, text, numeric, text[])
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.uvwstats1(integer, numeric, text, text, text, text, numeric, text[]) TO public;
GRANT EXECUTE ON FUNCTION server.uvwstats1(integer, numeric, text, text, text, text, numeric, text[]) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.uvwstats1(integer, numeric, text, text, text, text, numeric, text[]) TO armalive_server;
