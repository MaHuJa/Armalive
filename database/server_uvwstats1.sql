-- Function: server.uvwstats1(integer, numeric, text, text, text, text, numeric, text[])

-- DROP FUNCTION server.uvwstats1(integer, numeric, text, text, text, text, numeric, text[]);

CREATE OR REPLACE FUNCTION server.uvwstats1
(IN sessionid integer, IN "when" numeric, IN playerid text, 
IN unitclass text, IN vehicleclass text, IN weaponclass text, 
IN weapontime numeric, IN shotsfired integer, VARIADIC hits text[])
  RETURNS void AS
$BODY$
DECLARE
  playerid integer = util.player_uid_to_id($3);
  unit text = $4;
  vehicle text = $5;
  weapon text = $6;
  totaltime interval = util.seconds($7);
BEGIN
  IF unit = vehicle THEN vehicle = ''; END IF;
  EXECUTE util.checkwritable($1);
  INSERT INTO player.uvwstats_raw (session, player, 
    unit, vehicle, weapon, 
    totalseconds, fired, hits)
  VALUES ($1, playerid, 
    unit, vehicle, weapon, 
    totaltime, $8, $9);
END
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.uvwstats1(integer, numeric, text, text, text, text, numeric, integer, text[])
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.uvwstats1(integer, numeric, text, text, text, text, numeric, integer, text[]) TO public;
GRANT EXECUTE ON FUNCTION server.uvwstats1(integer, numeric, text, text, text, text, numeric, integer, text[]) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.uvwstats1(integer, numeric, text, text, text, text, numeric, integer, text[]) TO armalive_server;
