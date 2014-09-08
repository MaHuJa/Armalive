-- Function: server.get_atlas_all1(integer, text)

-- DROP FUNCTION server.get_atlas_all1(integer, text);

CREATE OR REPLACE FUNCTION server.get_atlas_all1(session integer, playerid text)
  RETURNS text AS
$BODY$
DECLARE
  pid integer = server.player_uid_to_id ($2);
  retval text = e'[\n';
  name text;
  val int;
BEGIN
  FOR name, val IN 
	SELECT varname, sum(increment)
	FROM persistence.atlas
	where atlas.playerid = server.player_uid_to_id('76561198001161042')
	group by varname
  LOOP
    retval = retval || '["' || name || '",' || val || e'],\n';
  END LOOP;
  retval = retval || ']';
  RETURN retval;
END
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION server.get_atlas_all1(integer, text)
  OWNER TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.get_atlas_all1(integer, text) TO public;
GRANT EXECUTE ON FUNCTION server.get_atlas_all1(integer, text) TO armalive_auto;
GRANT EXECUTE ON FUNCTION server.get_atlas_all1(integer, text) TO armalive_server;
