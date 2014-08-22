-- Function: server.newplayer1(integer, text, text, numeric, text)

-- DROP FUNCTION server.newplayer1(integer, text, text, numeric, text);

CREATE OR REPLACE FUNCTION server.newplayer1(sessionid integer, playeruid text, playerside text, jointime numeric, VARIADIC playername_p text[])
  RETURNS void AS
$BODY$
DECLARE
	pname text := array_to_string(playername_p,';');
BEGIN
insert into player.player(gameuid,last_name_seen) values ($2, pname);
insert into session.sessionplayers(session, player, side, joined, playername) values 
($1, server.player_uid_to_id($2), $3, server.seconds($4), pname);
-- todo: add to playername list
END
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.newplayer1(integer, text, text, numeric, text)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.newplayer1(integer, text, text, numeric, text) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.newplayer1(integer, text, text, numeric, text) TO armalive_server;
REVOKE ALL ON FUNCTION server.newplayer1(integer, text, text, numeric, text) FROM public;
