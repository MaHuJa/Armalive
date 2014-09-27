-- Function: server.newplayer1(integer, text, text, numeric, text[])

-- DROP FUNCTION server.newplayer1(integer, text, text, numeric, text[]);

CREATE OR REPLACE FUNCTION server.newplayer1(IN sessionid integer, IN playeruid text, IN playerside text, IN jointime numeric, VARIADIC playername_p text[])
  RETURNS void AS
$BODY$
DECLARE
	p_id integer := util.player_uid_to_id($2);
	pname text := array_to_string(playername_p,';');
BEGIN
-- todo: Consider doing trigger work here
insert into player.player(gameuid,last_name_seen) values ($2, pname);
insert into session.sessionplayers(session, player, side, joined, playername) values 
  ($1, p_id, $3, util.seconds($4), pname);

-- add to playername
update player.playername set lastseen = current_timestamp where playerid=p_id and name = pname;
if not found then
	insert into player.playername (playerid,name) values (p_id, pname);
end if;

END
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.newplayer1(integer, text, text, numeric, text[])
  OWNER TO mahuja;
GRANT EXECUTE ON FUNCTION server.newplayer1(integer, text, text, numeric, text[]) TO public;
GRANT EXECUTE ON FUNCTION server.newplayer1(integer, text, text, numeric, text[]) TO mahuja;
GRANT EXECUTE ON FUNCTION server.newplayer1(integer, text, text, numeric, text[]) TO armalive_auto;
