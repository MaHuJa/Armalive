-- Function: server.roadkill1(integer, numeric, text, text, text, text, text, text, text, text, text, text)

-- DROP FUNCTION server.roadkill1(integer, numeric, text, text, text, text, text, text, text, text, text, text);

CREATE OR REPLACE FUNCTION server.roadkill1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_vehicle text, istk text)
  RETURNS void AS
$BODY$
DECLARE
vicpos real[] = util.position(victim_position);
kilpos real[] = util.position(killer_position);
distance real = util.realpoint(vicpos) <-> util.realpoint(kilpos);
BEGIN
IF distance < 0.0000001 THEN RAISE EXCEPTION 'Zero distance (Lazy scripter check)'; END IF;
IF distance > 20 THEN RAISE WARNING 'Too far to be a road kill. Saving it anyway.'; END IF;

INSERT INTO event.deathevent(
            session, "time", how, victim, victim_position, victim_class, 
            victim_side, killer, killer_position, killer_class, killer_side, 
            killer_weapon, teamkill)
    VALUES ($1, util.seconds($2), 'roadkill', util.player_uid_to_id($3), util.position($4), $5,
	$6, util.player_uid_to_id($7), util.position($8), $9, $10,
	$11, $12
    );
END
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.roadkill1(integer, numeric, text, text, text, text, text, text, text, text, text, text)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.roadkill1(integer, numeric, text, text, text, text, text, text, text, text, text, text) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.roadkill1(integer, numeric, text, text, text, text, text, text, text, text, text, text) TO armalive_server;
GRANT EXECUTE ON FUNCTION server.roadkill1(integer, numeric, text, text, text, text, text, text, text, text, text, text) TO mahuja;
REVOKE ALL ON FUNCTION server.roadkill1(integer, numeric, text, text, text, text, text, text, text, text, text, text) FROM public;
