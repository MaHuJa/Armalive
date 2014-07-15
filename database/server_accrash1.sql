-- Function: server.accrash1(integer, integer, text, text, integer, text, text)

-- DROP FUNCTION server.accrash1(integer, integer, text, text, integer, text, text);

CREATE OR REPLACE FUNCTION server.accrash1(sessionid integer, "when" integer, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text)
  RETURNS void AS
$BODY$
insert into event.ac_crash ("session", "time", playerid, player_position, passengers, vehicle_class, vehicle_position ) values
( $1, 
  ($2 || ' seconds') :: interval,
  server.player_uid_to_id($3), 
  server.position($4),
  $5,
  $6, 
  server.position($7)
)
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.accrash1(integer, integer, text, text, integer, text, text)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.accrash1(integer, integer, text, text, integer, text, text) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.accrash1(integer, integer, text, text, integer, text, text) TO public;
