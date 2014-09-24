-- Function: server.get_atlas_points1(integer, text, text)

-- DROP FUNCTION server.get_atlas_points1(integer, text, text);

CREATE OR REPLACE FUNCTION server.get_atlas_points1(sessionid integer, playeruid text, varname text)
  RETURNS integer AS
$BODY$
select sum(increment)::integer 
from persistence.atlas
where playerid = util.player_uid_to_id($2)
and varname = $3
;
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.get_atlas_points1(integer, text, text)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.get_atlas_points1(integer, text, text) TO public;
GRANT EXECUTE ON FUNCTION server.get_atlas_points1(integer, text, text) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.get_atlas_points1(integer, text, text) TO armalive_server;
GRANT EXECUTE ON FUNCTION server.get_atlas_points1(integer, text, text) TO mahuja;
