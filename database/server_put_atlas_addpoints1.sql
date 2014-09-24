-- Function: server.put_atlas_addpoints1(integer, text, text, integer)

-- DROP FUNCTION server.put_atlas_addpoints1(integer, text, text, integer);

CREATE OR REPLACE FUNCTION server.put_atlas_addpoints1(sessionid integer, playeruid text, varname text, increment integer)
  RETURNS void AS
$BODY$
with record as (
insert into persistence.atlas ( session, playerid, varname, increment) values 
($1,util.player_uid_to_id($2),$3,$4) returning *
)
insert into persistence.atlas_archive select * from record;
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.put_atlas_addpoints1(integer, text, text, integer)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.put_atlas_addpoints1(integer, text, text, integer) TO public;
GRANT EXECUTE ON FUNCTION server.put_atlas_addpoints1(integer, text, text, integer) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.put_atlas_addpoints1(integer, text, text, integer) TO armalive_server;
