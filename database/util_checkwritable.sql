-- Function: util.checkwritable(integer)

-- DROP FUNCTION util.checkwritable(integer);

CREATE OR REPLACE FUNCTION util.checkwritable(session integer)
  RETURNS void AS
$BODY$
declare
	serverid integer = (select id from session.serverlist where name = session_user);
	lastsession integer = (select max(id) from session.session where server = serverid);
begin
	-- todo: if session_user is member of armalive_admin then allow
	if lastsession != session or lastsession is null then
		raise exception 'Invalid session push';
	end if;
end
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
ALTER FUNCTION util.checkwritable(integer)
  OWNER TO armalive_auto;
