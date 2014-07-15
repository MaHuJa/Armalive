-- Function: server.newplayer1(integer, text, text, numeric, text)

-- DROP FUNCTION server.newplayer1(integer, text, text, numeric, text);

CREATE OR REPLACE FUNCTION server.newplayer1(sessionid integer, playeruid text, playerside text, jointime numeric, playername_p text)
  RETURNS void AS
$BODY$
insert into player.player(gameuid,last_name_seen) values ($2, $5);
insert into session.sessionplayers(session, player, side, joined, playername) values 
($1, server.player_uid_to_id($2), $3, ($4 || ' seconds') ::interval, $5);
-- todo: add to playername list
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.newplayer1(integer, text, text, numeric, text)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.newplayer1(integer, text, text, numeric, text) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.newplayer1(integer, text, text, numeric, text) TO armalive_server;
REVOKE ALL ON FUNCTION server.newplayer1(integer, text, text, numeric, text) FROM public;
