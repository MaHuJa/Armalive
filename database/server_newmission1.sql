-- Function: server.newmission1(integer, text, text, numeric)

-- DROP FUNCTION server.newmission1(integer, text, text, numeric);

CREATE OR REPLACE FUNCTION server.newmission1(oldsession integer, mission_name text, map_name text, duplidetect numeric)
  RETURNS integer AS
$BODY$
-- this is an opportunity to finish "cleanup" of oldsession, or schedule it.
insert into session.session (missionname, mapname,server,duplidetect) 
values ($2, $3,
  ( select id from session.serverlist where name = session_user ),
  $4
)
returning id;
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.newmission1(integer, text, text, numeric)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.newmission1(integer, text, text, numeric) TO public;
GRANT EXECUTE ON FUNCTION server.newmission1(integer, text, text, numeric) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.newmission1(integer, text, text, numeric) TO armalive_server;
