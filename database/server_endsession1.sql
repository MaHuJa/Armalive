-- Function: server.endsession1(integer, numeric, text)

-- DROP FUNCTION server.endsession1(integer, numeric, text);

CREATE OR REPLACE FUNCTION server.endsession1(sessionid integer, duration numeric, outcome text)
  RETURNS void AS
$BODY$
-- todo: Sanity checks - has this been called already?
update session.session set duration = server.seconds($2), result = $3 where id = $1;
$BODY$
  LANGUAGE sql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.endsession1(integer, numeric, text)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.endsession1(integer, numeric, text) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.endsession1(integer, numeric, text) TO public;
GRANT EXECUTE ON FUNCTION server.endsession1(integer, numeric, text) TO armalive_server;
