-- Function: server.playerleft1(integer, text, integer)

-- DROP FUNCTION server.playerleft1(integer, text, integer);

CREATE OR REPLACE FUNCTION server.playerleft1(sessionid integer, playerid text, "when" integer)
  RETURNS void AS
$BODY$
-- todo: Sanity checks - has this been called already?
-- todo: A player can join and leave several times
update session.sessionplayers set "left" = server.seconds($3)
where "session" = $1 and player = server.player_uid_to_id($2);
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.playerleft1(integer, text, integer)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.playerleft1(integer, text, integer) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.playerleft1(integer, text, integer) TO armalive_server;
REVOKE ALL ON FUNCTION server.playerleft1(integer, text, integer) FROM public;
