-- Function: server.player_uid_to_id(text)

-- DROP FUNCTION server.player_uid_to_id(text);

CREATE OR REPLACE FUNCTION server.player_uid_to_id(uid text)
  RETURNS bigint AS
$BODY$
  select id from player.player where gameuid = $1;
$BODY$
  LANGUAGE sql IMMUTABLE STRICT SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.player_uid_to_id(text)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.player_uid_to_id(text) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.player_uid_to_id(text) TO armalive_server;
GRANT EXECUTE ON FUNCTION server.player_uid_to_id(text) TO armalive_reader;
REVOKE ALL ON FUNCTION server.player_uid_to_id(text) FROM public;
