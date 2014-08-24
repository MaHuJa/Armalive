-- Function: server.accrash1(integer, numeric, text, text, integer, text, text)

-- DROP FUNCTION server.accrash1(integer, numeric, text, text, integer, text, text);

CREATE OR REPLACE FUNCTION server.accrash1(sessionid integer, "when" numeric, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text)
  RETURNS void AS
$BODY$
insert into event.ac_crash ("session", "time", playerid, player_position, passengers, vehicle_class, vehicle_position ) values
( $1, 
  server.seconds($2),
  server.player_uid_to_id($3), 
  server.position($4),
  $5,
  $6, 
  server.position($7)
)
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.accrash1(integer, numeric, text, text, integer, text, text)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.accrash1(integer, numeric, text, text, integer, text, text) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.accrash1(integer, numeric, text, text, integer, text, text) TO armalive_server;
REVOKE ALL ON FUNCTION server.accrash1(integer, numeric, text, text, integer, text, text) FROM public;
