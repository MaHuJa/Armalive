-- Function: server.wpninfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer)

-- DROP FUNCTION server.wpninfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer);

CREATE OR REPLACE FUNCTION server.wpninfo1
(sessionid integer, playerid text, weaponclass text, "when" numeric, weapontime numeric, 
 shotsfired integer, hit_vehicle integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer)
  RETURNS void AS
$BODY$
  -- when is not actually used
  -- upsert trigger
  insert into player.weaponstats (session, player, class, totalseconds, 
	fired, vehiclehits, headhits, bodyhits, leghits, armhits)
  values
  ($1,server.player_uid_to_id($2),$3,$5,
  $6,$7,$8,$9,$10,$11);

  insert into player.weaponstats_sum (player, class, totalseconds, 
	fired, vehiclehits, headhits, bodyhits, leghits, armhits)
  values
  (server.player_uid_to_id($2),$3,$5,
  $6,$7,$8,$9,$10,$11);

  
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.wpninfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer)
  OWNER TO mahuja;
GRANT EXECUTE ON FUNCTION server.wpninfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer) TO mahuja;
GRANT EXECUTE ON FUNCTION server.wpninfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer) TO public;
GRANT EXECUTE ON FUNCTION server.wpninfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.wpninfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer) TO armalive_server;
