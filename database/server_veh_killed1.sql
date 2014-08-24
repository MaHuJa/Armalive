-- Function: server.veh_killed1(integer, numeric, text, text, text, text, text, text, text, text, text, text)

-- DROP FUNCTION server.veh_killed1(integer, numeric, text, text, text, text, text, text, text, text, text, text);

CREATE OR REPLACE FUNCTION server.veh_killed1(sessionid integer, "when" numeric, severity text,
vehicleclass text, vehicle_position text, 
last_used_by_side text, last_used_by_player text,
killer_uid text, killer_position text, 
killer_class text, killer_weapon text, killer_side text
)
RETURNS void AS
$BODY$
INSERT INTO event.vehicledestruction(
	session, "when", severity, 
	vehicleclass, vehicleposition, 
	last_used_by_side, last_used_by_player, 
	killer, killer_position, 
	killer_class, killer_weapon, killer_side
	)
    VALUES (
	$1, server.seconds($2), $3, 
	$4, server.position($5), 
	$6, server.player_uid_to_id($7),
	server.player_uid_to_id($8), server.position($9),
	$10, $11, $12        
	);
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.veh_killed1(integer, numeric, text, text, text, text, text, text, text, text, text, text)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.veh_killed1(integer, numeric, text, text, text, text, text, text, text, text, text, text) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.veh_killed1(integer, numeric, text, text, text, text, text, text, text, text, text, text) TO armalive_server;
