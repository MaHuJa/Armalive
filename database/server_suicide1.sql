-- Function: server.suicide1(integer, numeric, text, text, text, text)

-- DROP FUNCTION server.suicide1(integer, numeric, text, text, text, text);

CREATE OR REPLACE FUNCTION server.suicide1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text)
  RETURNS void AS
$BODY$
insert into event.deathevent
(session, "time", 
victim, victim_position, victim_class, victim_side,
how
) values (
$1,	-- session id
($2 || ' seconds') ::interval,	-- when/time
-- victim
server.player_uid_to_id($3),	
server.position($4),
$5,	-- class
$6, 	-- side

'death'
)
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.suicide1(integer, numeric, text, text, text, text)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.suicide1(integer, numeric, text, text, text, text) TO public;
GRANT EXECUTE ON FUNCTION server.suicide1(integer, numeric, text, text, text, text) TO armalive_auto;
