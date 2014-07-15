-- Function: player.player_uid_to_id(character varying)

-- DROP FUNCTION player.player_uid_to_id(character varying);

CREATE OR REPLACE FUNCTION player.player_uid_to_id(uid character varying)
  RETURNS integer AS
$BODY$select id from player.playerlist where gameuid = $1;
$BODY$
  LANGUAGE sql IMMUTABLE STRICT
  COST 100;
ALTER FUNCTION player.player_uid_to_id(character varying)
  OWNER TO mahuja;
