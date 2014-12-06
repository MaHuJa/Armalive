--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: event; Type: SCHEMA; Schema: -; Owner: mahuja
--

CREATE SCHEMA event;


ALTER SCHEMA event OWNER TO mahuja;

--
-- Name: persistence; Type: SCHEMA; Schema: -; Owner: mahuja
--

CREATE SCHEMA persistence;


ALTER SCHEMA persistence OWNER TO mahuja;

--
-- Name: player; Type: SCHEMA; Schema: -; Owner: mahuja
--

CREATE SCHEMA player;


ALTER SCHEMA player OWNER TO mahuja;

--
-- Name: server; Type: SCHEMA; Schema: -; Owner: mahuja
--

CREATE SCHEMA server;


ALTER SCHEMA server OWNER TO mahuja;

--
-- Name: SCHEMA server; Type: COMMENT; Schema: -; Owner: mahuja
--

COMMENT ON SCHEMA server IS 'This schema shall contain ALL the server needs access to. Mostly functions that run with enough priveleges for that particular task.';


--
-- Name: session; Type: SCHEMA; Schema: -; Owner: mahuja
--

CREATE SCHEMA session;


ALTER SCHEMA session OWNER TO mahuja;

--
-- Name: util; Type: SCHEMA; Schema: -; Owner: mahuja
--

CREATE SCHEMA util;


ALTER SCHEMA util OWNER TO mahuja;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET search_path = event, pg_catalog;

--
-- Name: teamkilltype; Type: TYPE; Schema: event; Owner: mahuja
--

CREATE TYPE teamkilltype AS ENUM (
    'no',
    'empty_friendly',
    'teamkill',
    'civilian',
    'potential warcrime',
    'definite warcrime'
);


ALTER TYPE event.teamkilltype OWNER TO mahuja;

SET search_path = player, pg_catalog;

--
-- Name: player_uid_to_id(character varying); Type: FUNCTION; Schema: player; Owner: mahuja
--

CREATE FUNCTION player_uid_to_id(uid character varying) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$select id from player.playerlist where gameuid = $1;
$_$;


ALTER FUNCTION player.player_uid_to_id(uid character varying) OWNER TO mahuja;

SET search_path = server, pg_catalog;

--
-- Name: accrash1(integer, numeric, text, text, integer, text, text); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION accrash1(sessionid integer, "when" numeric, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
insert into event.ac_crash ("session", "time", playerid, player_position, passengers, vehicle_class, vehicle_position ) values
( $1, 
  util.seconds($2),
  util.player_uid_to_id($3), 
  util.position($4),
  $5,
  $6, 
  util.position($7)
)
$_$;


ALTER FUNCTION server.accrash1(sessionid integer, "when" numeric, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text) OWNER TO armalive_auto;

--
-- Name: died1(integer, numeric, text, text, text, text); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION died1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
insert into event.deathevent
(session, "time", 
victim, victim_position, victim_class, victim_side,
how
) values (
$1,	-- session id
util.seconds($2),	-- when/time
-- victim
util.player_uid_to_id($3),	
util.position($4),
$5,	-- class
$6, 	-- side

'death'
)
$_$;


ALTER FUNCTION server.died1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) OWNER TO armalive_auto;

--
-- Name: drowned1(integer, numeric, text, text, text, text); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION drowned1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
insert into event.deathevent
(session, "time", 
victim, victim_position, victim_class, victim_side,
how
) values (
$1,	-- session id
util.seconds($2),	-- when/time
-- victim
util.player_uid_to_id($3),	
util.position($4),
$5,	-- class
$6, 	-- side

'drown'
)
$_$;


ALTER FUNCTION server.drowned1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) OWNER TO armalive_auto;

--
-- Name: endsession1(integer, numeric, text); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION endsession1(sessionid integer, duration numeric, outcome text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
-- todo: Sanity checks - has this been called already?
update session.session set duration = server.seconds($2), result = $3 where id = $1;
$_$;


ALTER FUNCTION server.endsession1(sessionid integer, duration numeric, outcome text) OWNER TO armalive_auto;

--
-- Name: friendlydmg1(integer, text, text, integer, text, integer, numeric, text, text); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION friendlydmg1(sessionid integer, victimid text, damageruid text, "when" integer, weapon text, score integer, distance numeric, victimpos text, killerpos text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $$
$$;


ALTER FUNCTION server.friendlydmg1(sessionid integer, victimid text, damageruid text, "when" integer, weapon text, score integer, distance numeric, victimpos text, killerpos text) OWNER TO armalive_auto;

--
-- Name: get_atlas_all1(integer, text); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION get_atlas_all1(session integer, playerid text) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
DECLARE
  pid integer = util.player_uid_to_id ($2);
  retval text = e'[\n';
  name text;
  val int;
BEGIN
  FOR name, val IN 
	SELECT varname, sum(increment)
	FROM persistence.atlas
	where atlas.playerid = pid
	group by varname
  LOOP
    retval = retval || '["' || name || '",' || val || e'],\n';
  END LOOP;
  retval = retval || e'["atlas_read_successful",1]\n]';
  RETURN retval;
END
$_$;


ALTER FUNCTION server.get_atlas_all1(session integer, playerid text) OWNER TO armalive_auto;

--
-- Name: get_atlas_points1(integer, text, text); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION get_atlas_points1(sessionid integer, playeruid text, varname text) RETURNS integer
    LANGUAGE sql SECURITY DEFINER
    AS $_$
select sum(increment)::integer 
from persistence.atlas
where playerid = util.player_uid_to_id($2)
and varname = $3
;
$_$;


ALTER FUNCTION server.get_atlas_points1(sessionid integer, playeruid text, varname text) OWNER TO armalive_auto;

--
-- Name: getin1(integer, numeric, text, text, text, text, text); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION getin1(sessionid integer, "when" numeric, playeruid text, slot text, vehiclepos text, vehicleclass text, vehicleid text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
DECLARE
  "time" interval = util.seconds("when");
  playerid integer = util.player_uid_to_id($3);
  vehpos real[] = util.position($5);
BEGIN
-- TODO

END
$_$;


ALTER FUNCTION server.getin1(sessionid integer, "when" numeric, playeruid text, slot text, vehiclepos text, vehicleclass text, vehicleid text) OWNER TO armalive_auto;

--
-- Name: getout1(integer, numeric, text, text, text, text, text); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION getout1(sessionid integer, "when" numeric, playeruid text, slot text, vehiclepos text, vehicleclass text, vehicleid text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
DECLARE
  "time" interval = util.seconds("when");
  playerid integer = util.player_uid_to_id($3);
  vehpos real[] = util.position($5);
BEGIN
-- TODO
  
END
$_$;


ALTER FUNCTION server.getout1(sessionid integer, "when" numeric, playeruid text, slot text, vehiclepos text, vehicleclass text, vehicleid text) OWNER TO armalive_auto;

--
-- Name: inf_killed1(integer, numeric, text, text, text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
insert into event.deathevent
(session, "time", 
victim, victim_position, victim_class, victim_side,
killer, killer_position, killer_class, killer_side, killer_weapon, teamkill, how
) values (
$1,	-- session id
util.seconds($2),	-- when/time
-- victim
util.player_uid_to_id($3),	
util.position($4),
$5,	-- class
$6, 	-- side
-- killer
util.player_uid_to_id($7),
util.position($8),
$9,	-- class
$10,	-- side
$11,	-- weapon

$12, -- TK
'kill' --killtype
)
$_$;


ALTER FUNCTION server.inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text) OWNER TO armalive_auto;

--
-- Name: missionevent1(integer, numeric, text, text[]); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION missionevent1(sessionid integer, "when" numeric, what text, VARIADIC playerlist text[]) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $$
$$;


ALTER FUNCTION server.missionevent1(sessionid integer, "when" numeric, what text, VARIADIC playerlist text[]) OWNER TO armalive_auto;

--
-- Name: newsession1(integer, text, text, text, text); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION newsession1(oldsession integer, mission_name text, map_name text, scriptversion text, duplidetect text) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
DECLARE

BEGIN
-- TODO Add column for scriptversion
-- TODO this is an opportunity to finish "cleanup" of oldsession, or schedule it.
insert into session.session (missionname, mapname,server,duplidetect) 
values ($2, $3,
  ( select id from session.serverlist where name = session_user ),
  $4
)
returning id;
END
$_$;


ALTER FUNCTION server.newsession1(oldsession integer, mission_name text, map_name text, scriptversion text, duplidetect text) OWNER TO armalive_auto;

--
-- Name: playerjoin1(integer, numeric, text, text, text[]); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION playerjoin1(sessionid integer, "when" numeric, playeruid text, playerside text, VARIADIC playername_p text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
DECLARE
	p_id integer; -- Do later :=  util.player_uid_to_id($2);
	pname text := array_to_string(playername_p,';');
	jointime interval = util.seconds("when");
BEGIN
-- todo: Consider moving trigger work here.
-- Upsert trigger involved in next line
insert into player.player(gameuid,last_name_seen) values (playeruid, pname);

p_id := util.player_uid_to_id(playeruid);
insert into session.sessionplayers(session, player, side, joined, playername) values 
  (sessionid, p_id, playerside, jointime, pname);

-- add to playername
update player.playername set lastseen = current_timestamp where playerid=p_id and name = pname;
if not found then
	insert into player.playername (playerid,name) values (p_id, pname);
end if;

END
$_$;


ALTER FUNCTION server.playerjoin1(sessionid integer, "when" numeric, playeruid text, playerside text, VARIADIC playername_p text[]) OWNER TO armalive_auto;

--
-- Name: playerleft1(integer, numeric, text); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION playerleft1(sessionid integer, "when" numeric, playerid text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
DECLARE
  pid integer = util.player_uid_to_id(playerid);
  "time" interval = util.seconds("when");
BEGIN
-- todo: Sanity checks - has this been called already?
-- todo: A player can join and leave several times
update session.sessionplayers set "left" = "time"
where "session" = $1 and player = pid and "left" is null;
END
$_$;


ALTER FUNCTION server.playerleft1(sessionid integer, "when" numeric, playerid text) OWNER TO armalive_auto;

--
-- Name: put_atlas_addpoints1(integer, text, text, integer); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION put_atlas_addpoints1(sessionid integer, playeruid text, varname text, increment integer) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
with record as (
insert into persistence.atlas ( session, playerid, varname, increment) values 
($1,util.player_uid_to_id($2),$3,$4) returning *
)
insert into persistence.atlas_archive select * from record;
$_$;


ALTER FUNCTION server.put_atlas_addpoints1(sessionid integer, playeruid text, varname text, increment integer) OWNER TO armalive_auto;

--
-- Name: roadkill1(integer, numeric, text, text, text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION roadkill1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_vehicle text, istk text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
DECLARE
vicpos real[] = util.position(victim_position);
kilpos real[] = util.position(killer_position);
distance real = util.realpoint(vicpos) <-> util.realpoint(kilpos);
BEGIN
IF distance < 0.0000001 THEN RAISE EXCEPTION 'Zero distance (Lazy scripter check)'; END IF;
IF distance > 20 THEN RAISE WARNING 'Too far to be a road kill. Saving it anyway.'; END IF;

INSERT INTO event.deathevent(
            session, "time", how, victim, victim_position, victim_class, 
            victim_side, killer, killer_position, killer_class, killer_side, 
            killer_weapon, teamkill)
    VALUES ($1, util.seconds($2), 'roadkill', util.player_uid_to_id($3), util.position($4), $5,
	$6, util.player_uid_to_id($7), util.position($8), $9, $10,
	$11, $12
    );
END
$_$;


ALTER FUNCTION server.roadkill1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_vehicle text, istk text) OWNER TO armalive_auto;

--
-- Name: suicide1(integer, numeric, text, text, text, text); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION suicide1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
insert into event.deathevent
(session, "time", 
victim, victim_position, victim_class, victim_side,
how
) values (
$1,	-- session id
util.seconds($2),	-- when/time
-- victim
util.player_uid_to_id($3),	
util.position($4),
$5,	-- class
$6, 	-- side

'suicide'
)
$_$;


ALTER FUNCTION server.suicide1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) OWNER TO armalive_auto;

--
-- Name: uvwstats1(integer, numeric, text, text, text, text, numeric, integer, text[]); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION uvwstats1(sessionid integer, "when" numeric, playerid text, unitclass text, vehicleclass text, weaponclass text, weapontime numeric, shotsfired integer, VARIADIC hits text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
DECLARE
  playerid integer = util.player_uid_to_id($3);
  unit text = $4;
  vehicle text = $5;
  weapon text = $6;
  totaltime interval = util.seconds($7);
BEGIN
  IF unit = vehicle THEN vehicle = ''; END IF;
  EXECUTE util.checkwritable($1);
  INSERT INTO player.uvwstats_raw (session, player, 
    unit, vehicle, weapon, 
    totalseconds, fired, hits)
  VALUES ($1, playerid, 
    unit, vehicle, weapon, 
    totaltime, $8, $9);
END
$_$;


ALTER FUNCTION server.uvwstats1(sessionid integer, "when" numeric, playerid text, unitclass text, vehicleclass text, weaponclass text, weapontime numeric, shotsfired integer, VARIADIC hits text[]) OWNER TO armalive_auto;

--
-- Name: veh_killed1(integer, numeric, text, text, text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: server; Owner: armalive_auto
--

CREATE FUNCTION veh_killed1(sessionid integer, "when" numeric, severity text, vehicleclass text, vehicle_position text, last_used_by_side text, last_used_by_player text, killer_uid text, killer_position text, killer_class text, killer_weapon text, killer_side text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
INSERT INTO event.vehicledestruction(
	session, "when", severity, 
	vehicleclass, vehicleposition, 
	last_used_by_side, last_used_by_player, 
	killer, killer_position, 
	killer_class, killer_weapon, killer_side
	)
    VALUES (
	$1, util.seconds($2), $3, 
	$4, util.position($5), 
	$6, util.player_uid_to_id($7),
	util.player_uid_to_id($8), util.position($9),
	$10, $11, $12        
	);
$_$;


ALTER FUNCTION server.veh_killed1(sessionid integer, "when" numeric, severity text, vehicleclass text, vehicle_position text, last_used_by_side text, last_used_by_player text, killer_uid text, killer_position text, killer_class text, killer_weapon text, killer_side text) OWNER TO armalive_auto;

SET search_path = util, pg_catalog;

--
-- Name: checkwritable(integer); Type: FUNCTION; Schema: util; Owner: armalive_auto
--

CREATE FUNCTION checkwritable(session integer) RETURNS void
    LANGUAGE plpgsql STABLE
    AS $$
declare
	serverid integer = (select id from session.serverlist where name = session_user);
	lastsession integer = (select max(id) from session.session where server = serverid);
begin
	-- todo: if session_user is member of armalive_admin then allow
	if lastsession != session or lastsession is null then
		raise exception 'Invalid session push';
	end if;
end
$$;


ALTER FUNCTION util.checkwritable(session integer) OWNER TO armalive_auto;

--
-- Name: player_uid_to_id(text); Type: FUNCTION; Schema: util; Owner: armalive_auto
--

CREATE FUNCTION player_uid_to_id(uid text) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT SECURITY DEFINER
    AS $_$
  select id from player.player where gameuid = $1;
$_$;


ALTER FUNCTION util.player_uid_to_id(uid text) OWNER TO armalive_auto;

--
-- Name: position(text); Type: FUNCTION; Schema: util; Owner: mahuja
--

CREATE FUNCTION "position"(text) RETURNS numeric[]
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  select replace((replace($1,'[','{')), ']','}')
	:: numeric array
$_$;


ALTER FUNCTION util."position"(text) OWNER TO mahuja;

--
-- Name: realpoint(real[]); Type: FUNCTION; Schema: util; Owner: mahuja
--

CREATE FUNCTION realpoint(o real[]) RETURNS point
    LANGUAGE sql IMMUTABLE
    AS $_$select point($1[0],$1[1])$_$;


ALTER FUNCTION util.realpoint(o real[]) OWNER TO mahuja;

--
-- Name: seconds(numeric); Type: FUNCTION; Schema: util; Owner: mahuja
--

CREATE FUNCTION seconds(seconds numeric) RETURNS interval
    LANGUAGE sql IMMUTABLE COST 1
    AS $_$
select ($1 || ' seconds') :: interval;
$_$;


ALTER FUNCTION util.seconds(seconds numeric) OWNER TO mahuja;

SET search_path = event, pg_catalog;

--
-- Name: event_id_counter; Type: SEQUENCE; Schema: event; Owner: mahuja
--

CREATE SEQUENCE event_id_counter
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event.event_id_counter OWNER TO mahuja;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ac_crash; Type: TABLE; Schema: event; Owner: mahuja; Tablespace: 
--

CREATE TABLE ac_crash (
    eventid bigint DEFAULT nextval('event_id_counter'::regclass) NOT NULL,
    session integer NOT NULL,
    "time" interval NOT NULL,
    playerid integer,
    player_position real[],
    passengers integer,
    vehicle_class text,
    vehicle_position real[],
    CONSTRAINT ac_crash_passengers_positive CHECK ((passengers >= 0))
);


ALTER TABLE event.ac_crash OWNER TO mahuja;

--
-- Name: deathevent; Type: TABLE; Schema: event; Owner: mahuja; Tablespace: 
--

CREATE TABLE deathevent (
    eventid integer DEFAULT nextval('event_id_counter'::regclass) NOT NULL,
    session integer NOT NULL,
    "time" interval,
    how character varying(8) NOT NULL,
    victim integer NOT NULL,
    victim_position real[] NOT NULL,
    victim_class text,
    victim_side text,
    killer integer,
    killer_position real[],
    killer_class text,
    killer_side text,
    killer_weapon text,
    teamkill text,
    CONSTRAINT deathevent_how_check CHECK (((how)::text = ANY (ARRAY[('kill'::character varying)::text, ('death'::character varying)::text, ('drown'::character varying)::text, ('suicide'::character varying)::text, ('roadkill'::character varying)::text]))),
    CONSTRAINT deathevent_teamkill_check CHECK ((teamkill = ANY (ARRAY['not'::text, 'empty_friendly'::text, 'teamkill'::text, 'civilian'::text, 'potential warcrime'::text, 'definite warcrime'::text])))
);


ALTER TABLE event.deathevent OWNER TO mahuja;

--
-- Name: vehicledestruction; Type: TABLE; Schema: event; Owner: mahuja; Tablespace: 
--

CREATE TABLE vehicledestruction (
    eventid integer DEFAULT nextval('event_id_counter'::regclass) NOT NULL,
    session integer NOT NULL,
    "when" interval NOT NULL,
    severity character varying(9) NOT NULL,
    vehicleclass text NOT NULL,
    vehicleposition real[] NOT NULL,
    last_used_by_side text,
    last_used_by_player integer,
    killer integer,
    killer_position real[],
    killer_class text,
    killer_weapon text,
    killer_side text,
    CONSTRAINT vehicledestruction_severity_check CHECK (((severity)::text = ANY (ARRAY[('mobility'::character varying)::text, ('evacuated'::character varying)::text, ('decrewed'::character varying)::text, ('scrapped'::character varying)::text])))
);


ALTER TABLE event.vehicledestruction OWNER TO mahuja;

--
-- Name: COLUMN vehicledestruction.severity; Type: COMMENT; Schema: event; Owner: mahuja
--

COMMENT ON COLUMN vehicledestruction.severity IS 'mobility, evacuated, decrewed, scrapped';


SET search_path = persistence, pg_catalog;

--
-- Name: atlas; Type: TABLE; Schema: persistence; Owner: mahuja; Tablespace: 
--

CREATE TABLE atlas (
    playerid integer NOT NULL,
    varname text NOT NULL,
    increment integer,
    session integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE persistence.atlas OWNER TO mahuja;

--
-- Name: atlas_archive; Type: TABLE; Schema: persistence; Owner: mahuja; Tablespace: 
--

CREATE TABLE atlas_archive (
    playerid integer NOT NULL,
    varname text NOT NULL,
    increment integer,
    session integer NOT NULL,
    id integer NOT NULL,
    transfer integer
);


ALTER TABLE persistence.atlas_archive OWNER TO mahuja;

--
-- Name: COLUMN atlas_archive.transfer; Type: COMMENT; Schema: persistence; Owner: mahuja
--

COMMENT ON COLUMN atlas_archive.transfer IS 'partner in transfer';


--
-- Name: atlas_variables_id_seq; Type: SEQUENCE; Schema: persistence; Owner: mahuja
--

CREATE SEQUENCE atlas_variables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE persistence.atlas_variables_id_seq OWNER TO mahuja;

--
-- Name: atlas_variables_id_seq; Type: SEQUENCE OWNED BY; Schema: persistence; Owner: mahuja
--

ALTER SEQUENCE atlas_variables_id_seq OWNED BY atlas.id;


SET search_path = player, pg_catalog;

--
-- Name: playername; Type: TABLE; Schema: player; Owner: mahuja; Tablespace: 
--

CREATE TABLE playername (
    playerid integer NOT NULL,
    name text NOT NULL,
    lastseen timestamp with time zone DEFAULT now() NOT NULL,
    firstseen timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE player.playername OWNER TO mahuja;

--
-- Name: last_name_seen; Type: VIEW; Schema: player; Owner: mahuja
--

CREATE VIEW last_name_seen AS
SELECT playername.playerid, first_value(playername.name) OVER (PARTITION BY playername.playerid ORDER BY playername.lastseen DESC) AS name FROM playername;


ALTER TABLE player.last_name_seen OWNER TO mahuja;

--
-- Name: player; Type: TABLE; Schema: player; Owner: mahuja; Tablespace: 
--

CREATE TABLE player (
    id bigint NOT NULL,
    gameuid character varying(64) NOT NULL,
    first_seen timestamp with time zone DEFAULT now() NOT NULL,
    last_name_seen text NOT NULL,
    hide boolean DEFAULT false
);


ALTER TABLE player.player OWNER TO mahuja;

--
-- Name: playerlist_id_seq; Type: SEQUENCE; Schema: player; Owner: mahuja
--

CREATE SEQUENCE playerlist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE player.playerlist_id_seq OWNER TO mahuja;

--
-- Name: playerlist_id_seq; Type: SEQUENCE OWNED BY; Schema: player; Owner: mahuja
--

ALTER SEQUENCE playerlist_id_seq OWNED BY player.id;


--
-- Name: uvwstats_cooked; Type: TABLE; Schema: player; Owner: mahuja; Tablespace: 
--

CREATE TABLE uvwstats_cooked (
    session integer NOT NULL,
    player integer NOT NULL,
    unit text NOT NULL,
    vehicle text NOT NULL,
    weapon text NOT NULL,
    totalseconds interval NOT NULL,
    fired integer DEFAULT 0,
    hits text[]
);


ALTER TABLE player.uvwstats_cooked OWNER TO mahuja;

--
-- Name: uvwstats_raw; Type: TABLE; Schema: player; Owner: mahuja; Tablespace: 
--

CREATE TABLE uvwstats_raw (
    session integer NOT NULL,
    player integer NOT NULL,
    unit text NOT NULL,
    vehicle text NOT NULL,
    weapon text NOT NULL,
    totalseconds interval NOT NULL,
    fired integer DEFAULT 0,
    hits text[]
);


ALTER TABLE player.uvwstats_raw OWNER TO mahuja;

--
-- Name: TABLE uvwstats_raw; Type: COMMENT; Schema: player; Owner: mahuja
--

COMMENT ON TABLE uvwstats_raw IS 'During the mission, the rows are all dumped in here. After the mission is over, they should be collapsed into the cooked table.';


SET search_path = session, pg_catalog;

--
-- Name: errorlog; Type: TABLE; Schema: session; Owner: mahuja; Tablespace: 
--

CREATE TABLE errorlog (
    errorid integer NOT NULL,
    query text,
    errormessage text
);


ALTER TABLE session.errorlog OWNER TO mahuja;

--
-- Name: TABLE errorlog; Type: COMMENT; Schema: session; Owner: mahuja
--

COMMENT ON TABLE errorlog IS 'Anytime a query fails on a server, that should be logged in this table.';


--
-- Name: errorlog_errorid_seq; Type: SEQUENCE; Schema: session; Owner: mahuja
--

CREATE SEQUENCE errorlog_errorid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE session.errorlog_errorid_seq OWNER TO mahuja;

--
-- Name: errorlog_errorid_seq; Type: SEQUENCE OWNED BY; Schema: session; Owner: mahuja
--

ALTER SEQUENCE errorlog_errorid_seq OWNED BY errorlog.errorid;


--
-- Name: serverlist; Type: TABLE; Schema: session; Owner: mahuja; Tablespace: 
--

CREATE TABLE serverlist (
    id integer NOT NULL,
    name character varying(64),
    address inet,
    displayname text
);


ALTER TABLE session.serverlist OWNER TO mahuja;

--
-- Name: serverlist_id_seq; Type: SEQUENCE; Schema: session; Owner: mahuja
--

CREATE SEQUENCE serverlist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE session.serverlist_id_seq OWNER TO mahuja;

--
-- Name: serverlist_id_seq; Type: SEQUENCE OWNED BY; Schema: session; Owner: mahuja
--

ALTER SEQUENCE serverlist_id_seq OWNED BY serverlist.id;


--
-- Name: session; Type: TABLE; Schema: session; Owner: mahuja; Tablespace: 
--

CREATE TABLE session (
    id integer NOT NULL,
    missionname text,
    result text,
    server integer NOT NULL,
    duration interval,
    mapname text,
    duplidetect numeric,
    session_start timestamp with time zone DEFAULT now()
);


ALTER TABLE session.session OWNER TO mahuja;

--
-- Name: session_id_seq; Type: SEQUENCE; Schema: session; Owner: mahuja
--

CREATE SEQUENCE session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE session.session_id_seq OWNER TO mahuja;

--
-- Name: session_id_seq; Type: SEQUENCE OWNED BY; Schema: session; Owner: mahuja
--

ALTER SEQUENCE session_id_seq OWNED BY session.id;


--
-- Name: sessionplayers; Type: TABLE; Schema: session; Owner: mahuja; Tablespace: 
--

CREATE TABLE sessionplayers (
    player integer NOT NULL,
    session integer,
    side character varying(8),
    playername text,
    id integer NOT NULL,
    joined interval,
    "left" interval
);


ALTER TABLE session.sessionplayers OWNER TO mahuja;

--
-- Name: sessionplayers_id_seq; Type: SEQUENCE; Schema: session; Owner: mahuja
--

CREATE SEQUENCE sessionplayers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE session.sessionplayers_id_seq OWNER TO mahuja;

--
-- Name: sessionplayers_id_seq; Type: SEQUENCE OWNED BY; Schema: session; Owner: mahuja
--

ALTER SEQUENCE sessionplayers_id_seq OWNED BY sessionplayers.id;


SET search_path = persistence, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: persistence; Owner: mahuja
--

ALTER TABLE ONLY atlas ALTER COLUMN id SET DEFAULT nextval('atlas_variables_id_seq'::regclass);


SET search_path = player, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: player; Owner: mahuja
--

ALTER TABLE ONLY player ALTER COLUMN id SET DEFAULT nextval('playerlist_id_seq'::regclass);


SET search_path = session, pg_catalog;

--
-- Name: errorid; Type: DEFAULT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY errorlog ALTER COLUMN errorid SET DEFAULT nextval('errorlog_errorid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY serverlist ALTER COLUMN id SET DEFAULT nextval('serverlist_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY session ALTER COLUMN id SET DEFAULT nextval('session_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY sessionplayers ALTER COLUMN id SET DEFAULT nextval('sessionplayers_id_seq'::regclass);


SET search_path = event, pg_catalog;

--
-- Name: ac_crash_pkey; Type: CONSTRAINT; Schema: event; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY ac_crash
    ADD CONSTRAINT ac_crash_pkey PRIMARY KEY (eventid);


--
-- Name: deathevent_pkey; Type: CONSTRAINT; Schema: event; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY deathevent
    ADD CONSTRAINT deathevent_pkey PRIMARY KEY (eventid);


--
-- Name: vehicledestruction_pkey; Type: CONSTRAINT; Schema: event; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY vehicledestruction
    ADD CONSTRAINT vehicledestruction_pkey PRIMARY KEY (eventid);


SET search_path = persistence, pg_catalog;

--
-- Name: atlas_archive_pkey; Type: CONSTRAINT; Schema: persistence; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY atlas_archive
    ADD CONSTRAINT atlas_archive_pkey PRIMARY KEY (id);


--
-- Name: atlas_variables_pkey; Type: CONSTRAINT; Schema: persistence; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY atlas
    ADD CONSTRAINT atlas_variables_pkey PRIMARY KEY (id);


SET search_path = player, pg_catalog;

--
-- Name: playerlist_pkey; Type: CONSTRAINT; Schema: player; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY player
    ADD CONSTRAINT playerlist_pkey PRIMARY KEY (id);


--
-- Name: playername_pkey; Type: CONSTRAINT; Schema: player; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY playername
    ADD CONSTRAINT playername_pkey PRIMARY KEY (playerid, name);


--
-- Name: unique_gameuid; Type: CONSTRAINT; Schema: player; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY player
    ADD CONSTRAINT unique_gameuid UNIQUE (gameuid);


--
-- Name: uvwstats_pkey; Type: CONSTRAINT; Schema: player; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY uvwstats_cooked
    ADD CONSTRAINT uvwstats_pkey PRIMARY KEY (session, player, unit, vehicle, weapon);


SET search_path = session, pg_catalog;

--
-- Name: errorlog_pkey; Type: CONSTRAINT; Schema: session; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY errorlog
    ADD CONSTRAINT errorlog_pkey PRIMARY KEY (errorid);


--
-- Name: serverlist_pkey; Type: CONSTRAINT; Schema: session; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY serverlist
    ADD CONSTRAINT serverlist_pkey PRIMARY KEY (id);


--
-- Name: session_pkey; Type: CONSTRAINT; Schema: session; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY session
    ADD CONSTRAINT session_pkey PRIMARY KEY (id);


--
-- Name: sessionplayers_pkey; Type: CONSTRAINT; Schema: session; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY sessionplayers
    ADD CONSTRAINT sessionplayers_pkey PRIMARY KEY (id);


SET search_path = event, pg_catalog;

--
-- Name: ac_crash_playerid_idx; Type: INDEX; Schema: event; Owner: mahuja; Tablespace: 
--

CREATE INDEX ac_crash_playerid_idx ON ac_crash USING btree (playerid);


--
-- Name: deathevent_killer_victim_idx; Type: INDEX; Schema: event; Owner: mahuja; Tablespace: 
--

CREATE INDEX deathevent_killer_victim_idx ON deathevent USING btree (killer, victim);


--
-- Name: deathevent_victim_idx; Type: INDEX; Schema: event; Owner: mahuja; Tablespace: 
--

CREATE INDEX deathevent_victim_idx ON deathevent USING btree (victim);


SET search_path = persistence, pg_catalog;

--
-- Name: atlas_playerid_varname_idx; Type: INDEX; Schema: persistence; Owner: mahuja; Tablespace: 
--

CREATE INDEX atlas_playerid_varname_idx ON atlas USING btree (playerid, varname);


SET search_path = player, pg_catalog;

--
-- Name: upsert; Type: RULE; Schema: player; Owner: mahuja
--

CREATE RULE upsert AS ON INSERT TO player WHERE ((new.gameuid)::text IN (SELECT player.gameuid FROM player)) DO INSTEAD UPDATE player SET last_name_seen = new.last_name_seen WHERE ((player.gameuid)::text = (new.gameuid)::text);


SET search_path = event, pg_catalog;

--
-- Name: ac_crash_playerid_fkey; Type: FK CONSTRAINT; Schema: event; Owner: mahuja
--

ALTER TABLE ONLY ac_crash
    ADD CONSTRAINT ac_crash_playerid_fkey FOREIGN KEY (playerid) REFERENCES player.player(id);


--
-- Name: ac_crash_session_fkey; Type: FK CONSTRAINT; Schema: event; Owner: mahuja
--

ALTER TABLE ONLY ac_crash
    ADD CONSTRAINT ac_crash_session_fkey FOREIGN KEY (session) REFERENCES session.session(id);


--
-- Name: deathevent_killer_fkey; Type: FK CONSTRAINT; Schema: event; Owner: mahuja
--

ALTER TABLE ONLY deathevent
    ADD CONSTRAINT deathevent_killer_fkey FOREIGN KEY (killer) REFERENCES player.player(id);


--
-- Name: deathevent_session_fkey; Type: FK CONSTRAINT; Schema: event; Owner: mahuja
--

ALTER TABLE ONLY deathevent
    ADD CONSTRAINT deathevent_session_fkey FOREIGN KEY (session) REFERENCES session.session(id);


--
-- Name: deathevent_victim_fkey; Type: FK CONSTRAINT; Schema: event; Owner: mahuja
--

ALTER TABLE ONLY deathevent
    ADD CONSTRAINT deathevent_victim_fkey FOREIGN KEY (victim) REFERENCES player.player(id);


--
-- Name: vehicledestruction_session_fkey; Type: FK CONSTRAINT; Schema: event; Owner: mahuja
--

ALTER TABLE ONLY vehicledestruction
    ADD CONSTRAINT vehicledestruction_session_fkey FOREIGN KEY (session) REFERENCES session.session(id);


SET search_path = persistence, pg_catalog;

--
-- Name: atlas_session_fkey; Type: FK CONSTRAINT; Schema: persistence; Owner: mahuja
--

ALTER TABLE ONLY atlas
    ADD CONSTRAINT atlas_session_fkey FOREIGN KEY (session) REFERENCES session.session(id);


SET search_path = player, pg_catalog;

--
-- Name: playername_playerid_fkey; Type: FK CONSTRAINT; Schema: player; Owner: mahuja
--

ALTER TABLE ONLY playername
    ADD CONSTRAINT playername_playerid_fkey FOREIGN KEY (playerid) REFERENCES player(id);


SET search_path = session, pg_catalog;

--
-- Name: session_server_fkey; Type: FK CONSTRAINT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY session
    ADD CONSTRAINT session_server_fkey FOREIGN KEY (server) REFERENCES serverlist(id);


--
-- Name: sessionplayers_player_fkey; Type: FK CONSTRAINT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY sessionplayers
    ADD CONSTRAINT sessionplayers_player_fkey FOREIGN KEY (player) REFERENCES player.player(id);


--
-- Name: sessionplayers_session_fkey; Type: FK CONSTRAINT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY sessionplayers
    ADD CONSTRAINT sessionplayers_session_fkey FOREIGN KEY (session) REFERENCES session(id) ON DELETE CASCADE;


--
-- Name: event; Type: ACL; Schema: -; Owner: mahuja
--

REVOKE ALL ON SCHEMA event FROM PUBLIC;
REVOKE ALL ON SCHEMA event FROM mahuja;
GRANT ALL ON SCHEMA event TO mahuja;
GRANT USAGE ON SCHEMA event TO armalive_auto;
GRANT USAGE ON SCHEMA event TO armalive_reader;
GRANT USAGE ON SCHEMA event TO armalive_admin;


--
-- Name: persistence; Type: ACL; Schema: -; Owner: mahuja
--

REVOKE ALL ON SCHEMA persistence FROM PUBLIC;
REVOKE ALL ON SCHEMA persistence FROM mahuja;
GRANT ALL ON SCHEMA persistence TO mahuja;
GRANT USAGE ON SCHEMA persistence TO armalive_auto;
GRANT USAGE ON SCHEMA persistence TO armalive_admin;


--
-- Name: player; Type: ACL; Schema: -; Owner: mahuja
--

REVOKE ALL ON SCHEMA player FROM PUBLIC;
REVOKE ALL ON SCHEMA player FROM mahuja;
GRANT ALL ON SCHEMA player TO mahuja;
GRANT USAGE ON SCHEMA player TO armalive_auto;
GRANT USAGE ON SCHEMA player TO armalive_admin;
GRANT USAGE ON SCHEMA player TO armalive_reader;


--
-- Name: server; Type: ACL; Schema: -; Owner: mahuja
--

REVOKE ALL ON SCHEMA server FROM PUBLIC;
REVOKE ALL ON SCHEMA server FROM mahuja;
GRANT ALL ON SCHEMA server TO mahuja;
GRANT USAGE ON SCHEMA server TO armalive_auto;
GRANT USAGE ON SCHEMA server TO armalive_server;
GRANT USAGE ON SCHEMA server TO armalive_reader;


--
-- Name: session; Type: ACL; Schema: -; Owner: mahuja
--

REVOKE ALL ON SCHEMA session FROM PUBLIC;
REVOKE ALL ON SCHEMA session FROM mahuja;
GRANT ALL ON SCHEMA session TO mahuja;
GRANT USAGE ON SCHEMA session TO armalive_auto;
GRANT USAGE ON SCHEMA session TO armalive_reader;


--
-- Name: util; Type: ACL; Schema: -; Owner: mahuja
--

REVOKE ALL ON SCHEMA util FROM PUBLIC;
REVOKE ALL ON SCHEMA util FROM mahuja;
GRANT ALL ON SCHEMA util TO mahuja;
GRANT USAGE ON SCHEMA util TO armalive_auto;
GRANT USAGE ON SCHEMA util TO armalive_reader;


SET search_path = event, pg_catalog;

--
-- Name: teamkilltype; Type: ACL; Schema: event; Owner: mahuja
--

REVOKE ALL ON TYPE teamkilltype FROM PUBLIC;
REVOKE ALL ON TYPE teamkilltype FROM mahuja;
GRANT ALL ON TYPE teamkilltype TO PUBLIC;


SET search_path = server, pg_catalog;

--
-- Name: accrash1(integer, numeric, text, text, integer, text, text); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION accrash1(sessionid integer, "when" numeric, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text) FROM PUBLIC;
REVOKE ALL ON FUNCTION accrash1(sessionid integer, "when" numeric, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text) FROM armalive_auto;
GRANT ALL ON FUNCTION accrash1(sessionid integer, "when" numeric, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text) TO armalive_auto;
GRANT ALL ON FUNCTION accrash1(sessionid integer, "when" numeric, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text) TO armalive_server;


--
-- Name: died1(integer, numeric, text, text, text, text); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION died1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) FROM PUBLIC;
REVOKE ALL ON FUNCTION died1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) FROM armalive_auto;
GRANT ALL ON FUNCTION died1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) TO armalive_auto;
GRANT ALL ON FUNCTION died1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) TO PUBLIC;
GRANT ALL ON FUNCTION died1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) TO armalive_server;


--
-- Name: drowned1(integer, numeric, text, text, text, text); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION drowned1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) FROM PUBLIC;
REVOKE ALL ON FUNCTION drowned1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) FROM armalive_auto;
GRANT ALL ON FUNCTION drowned1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) TO armalive_auto;
GRANT ALL ON FUNCTION drowned1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) TO PUBLIC;
GRANT ALL ON FUNCTION drowned1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) TO armalive_server;


--
-- Name: endsession1(integer, numeric, text); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION endsession1(sessionid integer, duration numeric, outcome text) FROM PUBLIC;
REVOKE ALL ON FUNCTION endsession1(sessionid integer, duration numeric, outcome text) FROM armalive_auto;
GRANT ALL ON FUNCTION endsession1(sessionid integer, duration numeric, outcome text) TO armalive_auto;
GRANT ALL ON FUNCTION endsession1(sessionid integer, duration numeric, outcome text) TO PUBLIC;
GRANT ALL ON FUNCTION endsession1(sessionid integer, duration numeric, outcome text) TO armalive_server;


--
-- Name: friendlydmg1(integer, text, text, integer, text, integer, numeric, text, text); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION friendlydmg1(sessionid integer, victimid text, damageruid text, "when" integer, weapon text, score integer, distance numeric, victimpos text, killerpos text) FROM PUBLIC;
REVOKE ALL ON FUNCTION friendlydmg1(sessionid integer, victimid text, damageruid text, "when" integer, weapon text, score integer, distance numeric, victimpos text, killerpos text) FROM armalive_auto;
GRANT ALL ON FUNCTION friendlydmg1(sessionid integer, victimid text, damageruid text, "when" integer, weapon text, score integer, distance numeric, victimpos text, killerpos text) TO armalive_auto;
GRANT ALL ON FUNCTION friendlydmg1(sessionid integer, victimid text, damageruid text, "when" integer, weapon text, score integer, distance numeric, victimpos text, killerpos text) TO PUBLIC;
GRANT ALL ON FUNCTION friendlydmg1(sessionid integer, victimid text, damageruid text, "when" integer, weapon text, score integer, distance numeric, victimpos text, killerpos text) TO armalive_server;


--
-- Name: get_atlas_all1(integer, text); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION get_atlas_all1(session integer, playerid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION get_atlas_all1(session integer, playerid text) FROM armalive_auto;
GRANT ALL ON FUNCTION get_atlas_all1(session integer, playerid text) TO armalive_auto;
GRANT ALL ON FUNCTION get_atlas_all1(session integer, playerid text) TO PUBLIC;
GRANT ALL ON FUNCTION get_atlas_all1(session integer, playerid text) TO armalive_server;


--
-- Name: get_atlas_points1(integer, text, text); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION get_atlas_points1(sessionid integer, playeruid text, varname text) FROM PUBLIC;
REVOKE ALL ON FUNCTION get_atlas_points1(sessionid integer, playeruid text, varname text) FROM armalive_auto;
GRANT ALL ON FUNCTION get_atlas_points1(sessionid integer, playeruid text, varname text) TO armalive_auto;
GRANT ALL ON FUNCTION get_atlas_points1(sessionid integer, playeruid text, varname text) TO PUBLIC;
GRANT ALL ON FUNCTION get_atlas_points1(sessionid integer, playeruid text, varname text) TO armalive_server;
GRANT ALL ON FUNCTION get_atlas_points1(sessionid integer, playeruid text, varname text) TO mahuja;


--
-- Name: getin1(integer, numeric, text, text, text, text, text); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION getin1(sessionid integer, "when" numeric, playeruid text, slot text, vehiclepos text, vehicleclass text, vehicleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION getin1(sessionid integer, "when" numeric, playeruid text, slot text, vehiclepos text, vehicleclass text, vehicleid text) FROM armalive_auto;
GRANT ALL ON FUNCTION getin1(sessionid integer, "when" numeric, playeruid text, slot text, vehiclepos text, vehicleclass text, vehicleid text) TO armalive_auto;
GRANT ALL ON FUNCTION getin1(sessionid integer, "when" numeric, playeruid text, slot text, vehiclepos text, vehicleclass text, vehicleid text) TO PUBLIC;
GRANT ALL ON FUNCTION getin1(sessionid integer, "when" numeric, playeruid text, slot text, vehiclepos text, vehicleclass text, vehicleid text) TO armalive_server;


--
-- Name: getout1(integer, numeric, text, text, text, text, text); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION getout1(sessionid integer, "when" numeric, playeruid text, slot text, vehiclepos text, vehicleclass text, vehicleid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION getout1(sessionid integer, "when" numeric, playeruid text, slot text, vehiclepos text, vehicleclass text, vehicleid text) FROM armalive_auto;
GRANT ALL ON FUNCTION getout1(sessionid integer, "when" numeric, playeruid text, slot text, vehiclepos text, vehicleclass text, vehicleid text) TO armalive_auto;
GRANT ALL ON FUNCTION getout1(sessionid integer, "when" numeric, playeruid text, slot text, vehiclepos text, vehicleclass text, vehicleid text) TO PUBLIC;
GRANT ALL ON FUNCTION getout1(sessionid integer, "when" numeric, playeruid text, slot text, vehiclepos text, vehicleclass text, vehicleid text) TO armalive_server;


--
-- Name: inf_killed1(integer, numeric, text, text, text, text, text, text, text, text, text, text); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text) FROM PUBLIC;
REVOKE ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text) FROM armalive_auto;
GRANT ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text) TO armalive_auto;
GRANT ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text) TO PUBLIC;
GRANT ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text) TO armalive_server;


--
-- Name: missionevent1(integer, numeric, text, text[]); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION missionevent1(sessionid integer, "when" numeric, what text, VARIADIC playerlist text[]) FROM PUBLIC;
REVOKE ALL ON FUNCTION missionevent1(sessionid integer, "when" numeric, what text, VARIADIC playerlist text[]) FROM armalive_auto;
GRANT ALL ON FUNCTION missionevent1(sessionid integer, "when" numeric, what text, VARIADIC playerlist text[]) TO armalive_auto;
GRANT ALL ON FUNCTION missionevent1(sessionid integer, "when" numeric, what text, VARIADIC playerlist text[]) TO PUBLIC;
GRANT ALL ON FUNCTION missionevent1(sessionid integer, "when" numeric, what text, VARIADIC playerlist text[]) TO armalive_server;


--
-- Name: newsession1(integer, text, text, text, text); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION newsession1(oldsession integer, mission_name text, map_name text, scriptversion text, duplidetect text) FROM PUBLIC;
REVOKE ALL ON FUNCTION newsession1(oldsession integer, mission_name text, map_name text, scriptversion text, duplidetect text) FROM armalive_auto;
GRANT ALL ON FUNCTION newsession1(oldsession integer, mission_name text, map_name text, scriptversion text, duplidetect text) TO armalive_auto;
GRANT ALL ON FUNCTION newsession1(oldsession integer, mission_name text, map_name text, scriptversion text, duplidetect text) TO PUBLIC;
GRANT ALL ON FUNCTION newsession1(oldsession integer, mission_name text, map_name text, scriptversion text, duplidetect text) TO armalive_server;


--
-- Name: playerjoin1(integer, numeric, text, text, text[]); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION playerjoin1(sessionid integer, "when" numeric, playeruid text, playerside text, VARIADIC playername_p text[]) FROM PUBLIC;
REVOKE ALL ON FUNCTION playerjoin1(sessionid integer, "when" numeric, playeruid text, playerside text, VARIADIC playername_p text[]) FROM armalive_auto;
GRANT ALL ON FUNCTION playerjoin1(sessionid integer, "when" numeric, playeruid text, playerside text, VARIADIC playername_p text[]) TO armalive_auto;
GRANT ALL ON FUNCTION playerjoin1(sessionid integer, "when" numeric, playeruid text, playerside text, VARIADIC playername_p text[]) TO PUBLIC;
GRANT ALL ON FUNCTION playerjoin1(sessionid integer, "when" numeric, playeruid text, playerside text, VARIADIC playername_p text[]) TO armalive_server;


--
-- Name: playerleft1(integer, numeric, text); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION playerleft1(sessionid integer, "when" numeric, playerid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION playerleft1(sessionid integer, "when" numeric, playerid text) FROM armalive_auto;
GRANT ALL ON FUNCTION playerleft1(sessionid integer, "when" numeric, playerid text) TO armalive_auto;
GRANT ALL ON FUNCTION playerleft1(sessionid integer, "when" numeric, playerid text) TO PUBLIC;
GRANT ALL ON FUNCTION playerleft1(sessionid integer, "when" numeric, playerid text) TO armalive_server;


--
-- Name: put_atlas_addpoints1(integer, text, text, integer); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION put_atlas_addpoints1(sessionid integer, playeruid text, varname text, increment integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION put_atlas_addpoints1(sessionid integer, playeruid text, varname text, increment integer) FROM armalive_auto;
GRANT ALL ON FUNCTION put_atlas_addpoints1(sessionid integer, playeruid text, varname text, increment integer) TO armalive_auto;
GRANT ALL ON FUNCTION put_atlas_addpoints1(sessionid integer, playeruid text, varname text, increment integer) TO PUBLIC;
GRANT ALL ON FUNCTION put_atlas_addpoints1(sessionid integer, playeruid text, varname text, increment integer) TO armalive_server;


--
-- Name: roadkill1(integer, numeric, text, text, text, text, text, text, text, text, text, text); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION roadkill1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_vehicle text, istk text) FROM PUBLIC;
REVOKE ALL ON FUNCTION roadkill1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_vehicle text, istk text) FROM armalive_auto;
GRANT ALL ON FUNCTION roadkill1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_vehicle text, istk text) TO armalive_auto;
GRANT ALL ON FUNCTION roadkill1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_vehicle text, istk text) TO armalive_server;
GRANT ALL ON FUNCTION roadkill1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_vehicle text, istk text) TO mahuja;


--
-- Name: suicide1(integer, numeric, text, text, text, text); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION suicide1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) FROM PUBLIC;
REVOKE ALL ON FUNCTION suicide1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) FROM armalive_auto;
GRANT ALL ON FUNCTION suicide1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) TO armalive_auto;
GRANT ALL ON FUNCTION suicide1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) TO PUBLIC;
GRANT ALL ON FUNCTION suicide1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text) TO armalive_server;


--
-- Name: uvwstats1(integer, numeric, text, text, text, text, numeric, integer, text[]); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION uvwstats1(sessionid integer, "when" numeric, playerid text, unitclass text, vehicleclass text, weaponclass text, weapontime numeric, shotsfired integer, VARIADIC hits text[]) FROM PUBLIC;
REVOKE ALL ON FUNCTION uvwstats1(sessionid integer, "when" numeric, playerid text, unitclass text, vehicleclass text, weaponclass text, weapontime numeric, shotsfired integer, VARIADIC hits text[]) FROM armalive_auto;
GRANT ALL ON FUNCTION uvwstats1(sessionid integer, "when" numeric, playerid text, unitclass text, vehicleclass text, weaponclass text, weapontime numeric, shotsfired integer, VARIADIC hits text[]) TO armalive_auto;
GRANT ALL ON FUNCTION uvwstats1(sessionid integer, "when" numeric, playerid text, unitclass text, vehicleclass text, weaponclass text, weapontime numeric, shotsfired integer, VARIADIC hits text[]) TO PUBLIC;
GRANT ALL ON FUNCTION uvwstats1(sessionid integer, "when" numeric, playerid text, unitclass text, vehicleclass text, weaponclass text, weapontime numeric, shotsfired integer, VARIADIC hits text[]) TO armalive_server;


--
-- Name: veh_killed1(integer, numeric, text, text, text, text, text, text, text, text, text, text); Type: ACL; Schema: server; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION veh_killed1(sessionid integer, "when" numeric, severity text, vehicleclass text, vehicle_position text, last_used_by_side text, last_used_by_player text, killer_uid text, killer_position text, killer_class text, killer_weapon text, killer_side text) FROM PUBLIC;
REVOKE ALL ON FUNCTION veh_killed1(sessionid integer, "when" numeric, severity text, vehicleclass text, vehicle_position text, last_used_by_side text, last_used_by_player text, killer_uid text, killer_position text, killer_class text, killer_weapon text, killer_side text) FROM armalive_auto;
GRANT ALL ON FUNCTION veh_killed1(sessionid integer, "when" numeric, severity text, vehicleclass text, vehicle_position text, last_used_by_side text, last_used_by_player text, killer_uid text, killer_position text, killer_class text, killer_weapon text, killer_side text) TO armalive_auto;
GRANT ALL ON FUNCTION veh_killed1(sessionid integer, "when" numeric, severity text, vehicleclass text, vehicle_position text, last_used_by_side text, last_used_by_player text, killer_uid text, killer_position text, killer_class text, killer_weapon text, killer_side text) TO PUBLIC;
GRANT ALL ON FUNCTION veh_killed1(sessionid integer, "when" numeric, severity text, vehicleclass text, vehicle_position text, last_used_by_side text, last_used_by_player text, killer_uid text, killer_position text, killer_class text, killer_weapon text, killer_side text) TO armalive_server;


SET search_path = util, pg_catalog;

--
-- Name: player_uid_to_id(text); Type: ACL; Schema: util; Owner: armalive_auto
--

REVOKE ALL ON FUNCTION player_uid_to_id(uid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION player_uid_to_id(uid text) FROM armalive_auto;
GRANT ALL ON FUNCTION player_uid_to_id(uid text) TO armalive_auto;
GRANT ALL ON FUNCTION player_uid_to_id(uid text) TO armalive_server;
GRANT ALL ON FUNCTION player_uid_to_id(uid text) TO armalive_reader;


--
-- Name: position(text); Type: ACL; Schema: util; Owner: mahuja
--

REVOKE ALL ON FUNCTION "position"(text) FROM PUBLIC;
REVOKE ALL ON FUNCTION "position"(text) FROM mahuja;
GRANT ALL ON FUNCTION "position"(text) TO mahuja;
GRANT ALL ON FUNCTION "position"(text) TO armalive_auto;
GRANT ALL ON FUNCTION "position"(text) TO armalive_server;


--
-- Name: seconds(numeric); Type: ACL; Schema: util; Owner: mahuja
--

REVOKE ALL ON FUNCTION seconds(seconds numeric) FROM PUBLIC;
REVOKE ALL ON FUNCTION seconds(seconds numeric) FROM mahuja;
GRANT ALL ON FUNCTION seconds(seconds numeric) TO mahuja;
GRANT ALL ON FUNCTION seconds(seconds numeric) TO PUBLIC;
GRANT ALL ON FUNCTION seconds(seconds numeric) TO armalive_auto;


SET search_path = event, pg_catalog;

--
-- Name: event_id_counter; Type: ACL; Schema: event; Owner: mahuja
--

REVOKE ALL ON SEQUENCE event_id_counter FROM PUBLIC;
REVOKE ALL ON SEQUENCE event_id_counter FROM mahuja;
GRANT ALL ON SEQUENCE event_id_counter TO mahuja;
GRANT ALL ON SEQUENCE event_id_counter TO armalive_auto;


--
-- Name: ac_crash; Type: ACL; Schema: event; Owner: mahuja
--

REVOKE ALL ON TABLE ac_crash FROM PUBLIC;
REVOKE ALL ON TABLE ac_crash FROM mahuja;
GRANT ALL ON TABLE ac_crash TO mahuja;
GRANT INSERT ON TABLE ac_crash TO armalive_auto;
GRANT SELECT ON TABLE ac_crash TO armalive_reader;


--
-- Name: deathevent; Type: ACL; Schema: event; Owner: mahuja
--

REVOKE ALL ON TABLE deathevent FROM PUBLIC;
REVOKE ALL ON TABLE deathevent FROM mahuja;
GRANT ALL ON TABLE deathevent TO mahuja;
GRANT INSERT ON TABLE deathevent TO armalive_auto;
GRANT SELECT ON TABLE deathevent TO armalive_reader;


--
-- Name: vehicledestruction; Type: ACL; Schema: event; Owner: mahuja
--

REVOKE ALL ON TABLE vehicledestruction FROM PUBLIC;
REVOKE ALL ON TABLE vehicledestruction FROM mahuja;
GRANT ALL ON TABLE vehicledestruction TO mahuja;
GRANT INSERT ON TABLE vehicledestruction TO armalive_auto;
GRANT SELECT ON TABLE vehicledestruction TO armalive_reader;


SET search_path = persistence, pg_catalog;

--
-- Name: atlas; Type: ACL; Schema: persistence; Owner: mahuja
--

REVOKE ALL ON TABLE atlas FROM PUBLIC;
REVOKE ALL ON TABLE atlas FROM mahuja;
GRANT ALL ON TABLE atlas TO mahuja;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE atlas TO armalive_auto;
GRANT SELECT ON TABLE atlas TO armalive_admin;


--
-- Name: atlas_archive; Type: ACL; Schema: persistence; Owner: mahuja
--

REVOKE ALL ON TABLE atlas_archive FROM PUBLIC;
REVOKE ALL ON TABLE atlas_archive FROM mahuja;
GRANT ALL ON TABLE atlas_archive TO mahuja;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE atlas_archive TO armalive_auto;
GRANT SELECT ON TABLE atlas_archive TO armalive_admin;


--
-- Name: atlas_variables_id_seq; Type: ACL; Schema: persistence; Owner: mahuja
--

REVOKE ALL ON SEQUENCE atlas_variables_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE atlas_variables_id_seq FROM mahuja;
GRANT ALL ON SEQUENCE atlas_variables_id_seq TO mahuja;
GRANT ALL ON SEQUENCE atlas_variables_id_seq TO armalive_auto;


SET search_path = player, pg_catalog;

--
-- Name: playername; Type: ACL; Schema: player; Owner: mahuja
--

REVOKE ALL ON TABLE playername FROM PUBLIC;
REVOKE ALL ON TABLE playername FROM mahuja;
GRANT ALL ON TABLE playername TO mahuja;
GRANT SELECT ON TABLE playername TO armalive_reader;
GRANT SELECT,INSERT,UPDATE ON TABLE playername TO armalive_auto;


--
-- Name: player; Type: ACL; Schema: player; Owner: mahuja
--

REVOKE ALL ON TABLE player FROM PUBLIC;
REVOKE ALL ON TABLE player FROM mahuja;
GRANT ALL ON TABLE player TO mahuja;
GRANT SELECT,INSERT,UPDATE ON TABLE player TO armalive_auto;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE player TO armalive_admin;
GRANT SELECT ON TABLE player TO armalive_reader;


--
-- Name: playerlist_id_seq; Type: ACL; Schema: player; Owner: mahuja
--

REVOKE ALL ON SEQUENCE playerlist_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE playerlist_id_seq FROM mahuja;
GRANT ALL ON SEQUENCE playerlist_id_seq TO mahuja;
GRANT USAGE ON SEQUENCE playerlist_id_seq TO armalive_auto;


--
-- Name: uvwstats_raw; Type: ACL; Schema: player; Owner: mahuja
--

REVOKE ALL ON TABLE uvwstats_raw FROM PUBLIC;
REVOKE ALL ON TABLE uvwstats_raw FROM mahuja;
GRANT ALL ON TABLE uvwstats_raw TO mahuja;
GRANT SELECT ON TABLE uvwstats_raw TO armalive_reader;
GRANT SELECT,INSERT,UPDATE ON TABLE uvwstats_raw TO armalive_auto;


SET search_path = session, pg_catalog;

--
-- Name: errorlog; Type: ACL; Schema: session; Owner: mahuja
--

REVOKE ALL ON TABLE errorlog FROM PUBLIC;
REVOKE ALL ON TABLE errorlog FROM mahuja;
GRANT ALL ON TABLE errorlog TO mahuja;
GRANT SELECT,INSERT,UPDATE ON TABLE errorlog TO armalive_auto;


--
-- Name: errorlog_errorid_seq; Type: ACL; Schema: session; Owner: mahuja
--

REVOKE ALL ON SEQUENCE errorlog_errorid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE errorlog_errorid_seq FROM mahuja;
GRANT ALL ON SEQUENCE errorlog_errorid_seq TO mahuja;
GRANT SELECT,UPDATE ON SEQUENCE errorlog_errorid_seq TO armalive_auto;


--
-- Name: serverlist; Type: ACL; Schema: session; Owner: mahuja
--

REVOKE ALL ON TABLE serverlist FROM PUBLIC;
REVOKE ALL ON TABLE serverlist FROM mahuja;
GRANT ALL ON TABLE serverlist TO mahuja;
GRANT SELECT,INSERT,UPDATE ON TABLE serverlist TO armalive_auto;


--
-- Name: serverlist_id_seq; Type: ACL; Schema: session; Owner: mahuja
--

REVOKE ALL ON SEQUENCE serverlist_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE serverlist_id_seq FROM mahuja;
GRANT ALL ON SEQUENCE serverlist_id_seq TO mahuja;
GRANT SELECT,UPDATE ON SEQUENCE serverlist_id_seq TO armalive_auto;


--
-- Name: session; Type: ACL; Schema: session; Owner: mahuja
--

REVOKE ALL ON TABLE session FROM PUBLIC;
REVOKE ALL ON TABLE session FROM mahuja;
GRANT ALL ON TABLE session TO mahuja;
GRANT SELECT,INSERT,UPDATE ON TABLE session TO armalive_auto;


--
-- Name: session_id_seq; Type: ACL; Schema: session; Owner: mahuja
--

REVOKE ALL ON SEQUENCE session_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE session_id_seq FROM mahuja;
GRANT ALL ON SEQUENCE session_id_seq TO mahuja;
GRANT SELECT,UPDATE ON SEQUENCE session_id_seq TO armalive_auto;


--
-- Name: sessionplayers; Type: ACL; Schema: session; Owner: mahuja
--

REVOKE ALL ON TABLE sessionplayers FROM PUBLIC;
REVOKE ALL ON TABLE sessionplayers FROM mahuja;
GRANT ALL ON TABLE sessionplayers TO mahuja;
GRANT SELECT,INSERT,UPDATE ON TABLE sessionplayers TO armalive_auto;


--
-- Name: sessionplayers_id_seq; Type: ACL; Schema: session; Owner: mahuja
--

REVOKE ALL ON SEQUENCE sessionplayers_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE sessionplayers_id_seq FROM mahuja;
GRANT ALL ON SEQUENCE sessionplayers_id_seq TO mahuja;
GRANT SELECT,UPDATE ON SEQUENCE sessionplayers_id_seq TO armalive_auto;


SET search_path = event, pg_catalog;

--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: event; Owner: mahuja
--

ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA event REVOKE ALL ON SEQUENCES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA event REVOKE ALL ON SEQUENCES  FROM mahuja;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA event GRANT ALL ON SEQUENCES  TO armalive_auto;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: event; Owner: mahuja
--

ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA event REVOKE ALL ON TABLES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA event REVOKE ALL ON TABLES  FROM mahuja;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA event GRANT INSERT ON TABLES  TO armalive_auto;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA event GRANT SELECT ON TABLES  TO armalive_reader;


SET search_path = persistence, pg_catalog;

--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: persistence; Owner: mahuja
--

ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA persistence REVOKE ALL ON SEQUENCES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA persistence REVOKE ALL ON SEQUENCES  FROM mahuja;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA persistence GRANT ALL ON SEQUENCES  TO armalive_auto;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: persistence; Owner: mahuja
--

ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA persistence REVOKE ALL ON FUNCTIONS  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA persistence REVOKE ALL ON FUNCTIONS  FROM mahuja;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA persistence GRANT ALL ON FUNCTIONS  TO armalive_auto;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: persistence; Owner: mahuja
--

ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA persistence REVOKE ALL ON TABLES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA persistence REVOKE ALL ON TABLES  FROM mahuja;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA persistence GRANT SELECT,INSERT,UPDATE ON TABLES  TO armalive_auto;


SET search_path = server, pg_catalog;

--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: server; Owner: mahuja
--

ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA server REVOKE ALL ON FUNCTIONS  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA server REVOKE ALL ON FUNCTIONS  FROM mahuja;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA server GRANT ALL ON FUNCTIONS  TO armalive_auto;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA server GRANT ALL ON FUNCTIONS  TO armalive_server;


SET search_path = session, pg_catalog;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: session; Owner: mahuja
--

ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA session REVOKE ALL ON TABLES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA session REVOKE ALL ON TABLES  FROM mahuja;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA session GRANT SELECT,INSERT,UPDATE ON TABLES  TO armalive_auto;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA session GRANT SELECT ON TABLES  TO armalive_reader;


--
-- PostgreSQL database dump complete
--

