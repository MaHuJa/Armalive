-- Function: server.newmission1(integer, text, text)

-- DROP FUNCTION server.newmission1(integer, text, text);

CREATE OR REPLACE FUNCTION server.newmission1(oldsession integer, mission_name text, map_name text)
  RETURNS integer AS
$BODY$
insert into session.session (missionname, mapname,server) 
values ($2, $3,
  ( select id from session.serverlist where name = session_user )
)
returning id;
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.newmission1(integer, text, text)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.newmission1(integer, text, text) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.newmission1(integer, text, text) TO public;
GRANT EXECUTE ON FUNCTION server.newmission1(integer, text, text) TO armalive_server;
