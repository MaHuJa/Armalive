-- Function: server.inf_killed1(integer, numeric, text, text, text, text, text, text, text, text, text, text)

-- DROP FUNCTION server.inf_killed1(integer, numeric, text, text, text, text, text, text, text, text, text, text);

CREATE OR REPLACE FUNCTION server.inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text)
  RETURNS void AS
$BODY$
insert into event.deathevent
(session, "time", 
victim, victim_position, victim_class, victim_side,
killer, killer_position, killer_class, killer_side, killer_weapon, teamkill, how
) values (
$1,	-- session id
($2 || ' seconds') ::interval,	-- when/time
-- victim
server.player_uid_to_id($3),	
server.position($4),
$5,	-- class
$6, 	-- side
-- killer
server.player_uid_to_id($7),
server.position($8),
$9,	-- class
$10,	-- side
$11,	-- weapon

$12, -- TK
'kill' --killtype
)
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.inf_killed1(integer, numeric, text, text, text, text, text, text, text, text, text, text)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.inf_killed1(integer, numeric, text, text, text, text, text, text, text, text, text, text) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.inf_killed1(integer, numeric, text, text, text, text, text, text, text, text, text, text) TO public;
GRANT EXECUTE ON FUNCTION server.inf_killed1(integer, numeric, text, text, text, text, text, text, text, text, text, text) TO armalive_server;
