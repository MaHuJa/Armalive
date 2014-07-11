--
-- PostgreSQL database dump
--

-- Dumped from database version 9.1.9
-- Dumped by pg_dump version 9.3.1
-- Started on 2014-07-11 17:48:37

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

DROP DATABASE bstats_master;
--
-- TOC entry 2042 (class 1262 OID 16590)
-- Name: bstats_master; Type: DATABASE; Schema: -; Owner: mahuja
--

CREATE DATABASE bstats_master WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';


ALTER DATABASE bstats_master OWNER TO mahuja;

\connect bstats_master

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 10 (class 2615 OID 16787)
-- Name: event; Type: SCHEMA; Schema: -; Owner: mahuja
--

CREATE SCHEMA event;


ALTER SCHEMA event OWNER TO mahuja;

--
-- TOC entry 9 (class 2615 OID 16788)
-- Name: logs; Type: SCHEMA; Schema: -; Owner: mahuja
--

CREATE SCHEMA logs;


ALTER SCHEMA logs OWNER TO mahuja;

--
-- TOC entry 6 (class 2615 OID 16791)
-- Name: player; Type: SCHEMA; Schema: -; Owner: mahuja
--

CREATE SCHEMA player;


ALTER SCHEMA player OWNER TO mahuja;

--
-- TOC entry 8 (class 2615 OID 16792)
-- Name: server; Type: SCHEMA; Schema: -; Owner: mahuja
--

CREATE SCHEMA server;


ALTER SCHEMA server OWNER TO mahuja;

--
-- TOC entry 2045 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA server; Type: COMMENT; Schema: -; Owner: mahuja
--

COMMENT ON SCHEMA server IS 'This schema shall contain ALL the server needs access to. Mostly functions that run with enough priveleges for that particular task.';


--
-- TOC entry 7 (class 2615 OID 16793)
-- Name: session; Type: SCHEMA; Schema: -; Owner: mahuja
--

CREATE SCHEMA session;


ALTER SCHEMA session OWNER TO mahuja;

--
-- TOC entry 187 (class 3079 OID 16615)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2048 (class 0 OID 0)
-- Dependencies: 187
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 186 (class 3079 OID 16620)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 2049 (class 0 OID 0)
-- Dependencies: 186
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET search_path = player, pg_catalog;

--
-- TOC entry 199 (class 1255 OID 16797)
-- Name: player_uid_to_id(character varying); Type: FUNCTION; Schema: player; Owner: mahuja
--

CREATE FUNCTION player_uid_to_id(uid character varying) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$select id from player.playerlist where gameuid = $1;
$_$;


ALTER FUNCTION player.player_uid_to_id(uid character varying) OWNER TO mahuja;

--
-- TOC entry 200 (class 1255 OID 16798)
-- Name: weaponstats_sum_upsert(); Type: FUNCTION; Schema: player; Owner: bstats_auto
--

CREATE FUNCTION weaponstats_sum_upsert() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$begin
perform * from weaponstats_sum where player = new.player and "class" = new.class;
if found then
  update player.weaponstats_sum set 
	totalseconds = totalseconds + new.totalseconds,
	"fired" = "fired" + new.fired,
	vehiclehits = vehiclehits + new.vehiclehits,
	headhits = headhits + new.headhits,
	bodyhits = bodyhits + new.bodyhits,
	leghits = leghits + new.leghits,
	armhits = armhits + new.armhits
	where player = new.player and "class" = new.class;
  return null;
end if;
return new;
end $$;


ALTER FUNCTION player.weaponstats_sum_upsert() OWNER TO bstats_auto;

--
-- TOC entry 2050 (class 0 OID 0)
-- Dependencies: 200
-- Name: FUNCTION weaponstats_sum_upsert(); Type: COMMENT; Schema: player; Owner: bstats_auto
--

COMMENT ON FUNCTION weaponstats_sum_upsert() IS 'To have an actual race condition, some server must delay its data transmission enough for the player to switch to another enabled server. Therefore this, despite being single-checked, is considered adequate.';


SET search_path = server, pg_catalog;

--
-- TOC entry 209 (class 1255 OID 17353)
-- Name: accrash1(integer, integer, text, text, integer, text, text); Type: FUNCTION; Schema: server; Owner: mahuja
--

CREATE FUNCTION accrash1(sessionid integer, "when" integer, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
insert into event.ac_crash ("session", "time", playerid, player_position, passengers, vehicle_class, vehicle_position ) values
( $1, 
  ($2 || ' seconds') :: interval,
  server.player_uid_to_id($3), 
  server.position($4),
  $5,
  $6, 
  server.position($7)
)
$_$;


ALTER FUNCTION server.accrash1(sessionid integer, "when" integer, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text) OWNER TO mahuja;

--
-- TOC entry 215 (class 1255 OID 17192)
-- Name: accrash1(integer, text, integer, integer, text, integer, text); Type: FUNCTION; Schema: server; Owner: mahuja
--

CREATE FUNCTION accrash1(sessionid integer, playerid text, "when" integer, passengercount integer, vehiclename text, score integer, playerpos text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
insert into event.ac_crash ("session", player, "time", "passengers", "vehicle", 
	points, "position" ) values
( $1, 
server.player_uid_to_id($2), 
  ($3 || ' seconds') :: interval,
  $4,
  $5,
  $6, 
  server.position($7)
)
$_$;


ALTER FUNCTION server.accrash1(sessionid integer, playerid text, "when" integer, passengercount integer, vehiclename text, score integer, playerpos text) OWNER TO mahuja;

--
-- TOC entry 212 (class 1255 OID 17198)
-- Name: death1(integer, text, integer, integer, text); Type: FUNCTION; Schema: server; Owner: mahuja
--

CREATE FUNCTION death1(sessionid integer, playerid text, "when" integer, score integer, playerpos text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
insert into event.death ("session", player, "time", "position", points, is_suicide) values
( $1, server.player_uid_to_id($2), 
  ($3 || ' seconds') :: interval,
  server.position($5),
  $4,
  false
)
$_$;


ALTER FUNCTION server.death1(sessionid integer, playerid text, "when" integer, score integer, playerpos text) OWNER TO mahuja;

--
-- TOC entry 214 (class 1255 OID 17195)
-- Name: endsession1(integer, numeric, text); Type: FUNCTION; Schema: server; Owner: mahuja
--

CREATE FUNCTION endsession1(sessionid integer, duration numeric, outcome text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
-- todo: Sanity checks - has this been called already?
update session.session set duration = ($2 || ' seconds')::interval, result = $3 where id = $1;
$_$;


ALTER FUNCTION server.endsession1(sessionid integer, duration numeric, outcome text) OWNER TO mahuja;

--
-- TOC entry 208 (class 1255 OID 17196)
-- Name: friendlydmg1(integer, text, text, integer, text, integer, numeric, text, text); Type: FUNCTION; Schema: server; Owner: mahuja
--

CREATE FUNCTION friendlydmg1(sessionid integer, victimid text, damageruid text, "when" integer, weapon text, score integer, distance numeric, victimpos text, killerpos text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $$
$$;


ALTER FUNCTION server.friendlydmg1(sessionid integer, victimid text, damageruid text, "when" integer, weapon text, score integer, distance numeric, victimpos text, killerpos text) OWNER TO mahuja;

--
-- TOC entry 218 (class 1255 OID 17476)
-- Name: inf_killed1(integer, numeric, text, text, text, text, text, text, text); Type: FUNCTION; Schema: server; Owner: mahuja
--

CREATE FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_class text, victim_position text, killer_uid text, killer_class text, killer_position text, killer_weapon text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
insert into event.deathevent
(session, "time", 
victim, victim_position, victim_class,
killer, killer_position, killer_class, killer_weapon
) values (
$1,			-- session id
($2 || ' seconds') ::interval,	-- when/time
-- victim
server.player_uid_to_id($3),	
server.position($4),
$5,
-- killer
server.player_uid_to_id($5),
server.position($6),
$7,	-- class
$8	-- weapon
)
$_$;


ALTER FUNCTION server.inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_class text, victim_position text, killer_uid text, killer_class text, killer_position text, killer_weapon text) OWNER TO mahuja;

--
-- TOC entry 219 (class 1255 OID 17477)
-- Name: inf_killed1(integer, numeric, text, text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: server; Owner: mahuja
--

CREATE FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_class text, victim_position text, victim_side text, killer_uid text, killer_class text, killer_position text, killer_side text, killer_weapon text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
insert into event.deathevent
(session, "time", 
victim, victim_position, victim_class,
killer, killer_position, killer_class, killer_weapon
) values (
$1,			-- session id
($2 || ' seconds') ::interval,	-- when/time
-- victim
server.player_uid_to_id($3),	
server.position($4),
$5,
-- killer
server.player_uid_to_id($5),
server.position($6),
$7,	-- class
$8	-- weapon
)
$_$;


ALTER FUNCTION server.inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_class text, victim_position text, victim_side text, killer_uid text, killer_class text, killer_position text, killer_side text, killer_weapon text) OWNER TO mahuja;

--
-- TOC entry 220 (class 1255 OID 17484)
-- Name: inf_killed1(integer, numeric, text, text, text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: server; Owner: mahuja
--

CREATE FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
insert into event.deathevent
(session, "time", 
victim, victim_position, victim_class, victim_side,
killer, killer_position, killer_class, killer_side, killer_weapon, teamkill
) values (
$1,	-- session id
($2 || ' seconds') ::interval,	-- when/time
-- victim
server.player_uid_to_id($3),	
server.position($4),
$5,	-- class
$6, 	-- side
-- killer
server.player_uid_to_id($7),
server.position($8),
$9,	-- class
$10,	-- side
$11,	-- weapon
-- TK
$11::teamkilltype
)
$_$;


ALTER FUNCTION server.inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text) OWNER TO mahuja;

--
-- TOC entry 206 (class 1255 OID 17179)
-- Name: inf_killed_inf1(integer, text, text, numeric, text, integer, text, text); Type: FUNCTION; Schema: server; Owner: bstats_auto
--

CREATE FUNCTION inf_killed_inf1(sessionid integer, killer text, victim text, "when" numeric, weapon text, score integer, killerpos text, victimpos text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
insert into event.deathevent
(session, "time", killer, killer_position, victim, victim_position, weapon,"how")
values (
$1,			-- session id
($4 || ' seconds') ::interval,	-- when/time
server.player_uid_to_id($2),	-- killer/player
server.position($7),	-- position/killerpos

server.player_uid_to_id($3),	-- victim
server.position($8),	-- victim_position/victimpos

$5,			-- weapon
'kill'
)
$_$;


ALTER FUNCTION server.inf_killed_inf1(sessionid integer, killer text, victim text, "when" numeric, weapon text, score integer, killerpos text, victimpos text) OWNER TO bstats_auto;

--
-- TOC entry 2059 (class 0 OID 0)
-- Dependencies: 206
-- Name: FUNCTION inf_killed_inf1(sessionid integer, killer text, victim text, "when" numeric, weapon text, score integer, killerpos text, victimpos text); Type: COMMENT; Schema: server; Owner: bstats_auto
--

COMMENT ON FUNCTION inf_killed_inf1(sessionid integer, killer text, victim text, "when" numeric, weapon text, score integer, killerpos text, victimpos text) IS '--backwards compatible with tests, will disappear after release';


--
-- TOC entry 217 (class 1255 OID 17420)
-- Name: missionevent1(integer, text, numeric, integer); Type: FUNCTION; Schema: server; Owner: mahuja
--

CREATE FUNCTION missionevent1(sessionid integer, what text, "when" numeric, score integer) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $$
$$;


ALTER FUNCTION server.missionevent1(sessionid integer, what text, "when" numeric, score integer) OWNER TO mahuja;

--
-- TOC entry 201 (class 1255 OID 16803)
-- Name: newmission1(integer, text); Type: FUNCTION; Schema: server; Owner: bstats_auto
--

CREATE FUNCTION newmission1(oldsession integer, mission_name text) RETURNS integer
    LANGUAGE sql SECURITY DEFINER
    AS $_$
insert into session.session (missionname,server) 
values ($2,
  ( select id from session.serverlist where name = session_user )
)
returning id;
$_$;


ALTER FUNCTION server.newmission1(oldsession integer, mission_name text) OWNER TO bstats_auto;

--
-- TOC entry 216 (class 1255 OID 17354)
-- Name: newmission1(integer, text, text); Type: FUNCTION; Schema: server; Owner: mahuja
--

CREATE FUNCTION newmission1(oldsession integer, mission_name text, map_name text) RETURNS integer
    LANGUAGE sql SECURITY DEFINER
    AS $_$
insert into session.session (missionname, mapname,server) 
values ($2, $3,
  ( select id from session.serverlist where name = session_user )
)
returning id;
$_$;


ALTER FUNCTION server.newmission1(oldsession integer, mission_name text, map_name text) OWNER TO mahuja;

--
-- TOC entry 205 (class 1255 OID 17178)
-- Name: newplayer1(integer, text, text, numeric, text); Type: FUNCTION; Schema: server; Owner: bstats_auto
--

CREATE FUNCTION newplayer1(sessionid integer, playeruid text, playerside text, jointime numeric, playername_p text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
insert into player.player(gameuid,last_name_seen) values ($2, $5);
insert into session.sessionplayers(session, player, side, joined, playername) values 
($1, server.player_uid_to_id($2), $3, ($4 || ' seconds') ::interval, $5);
-- todo: add to playername list
$_$;


ALTER FUNCTION server.newplayer1(sessionid integer, playeruid text, playerside text, jointime numeric, playername_p text) OWNER TO bstats_auto;

--
-- TOC entry 202 (class 1255 OID 16805)
-- Name: player_uid_to_id(text); Type: FUNCTION; Schema: server; Owner: bstats_auto
--

CREATE FUNCTION player_uid_to_id(uid text) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT SECURITY DEFINER
    AS $_$
  select id from player.player where gameuid = $1;
$_$;


ALTER FUNCTION server.player_uid_to_id(uid text) OWNER TO bstats_auto;

--
-- TOC entry 203 (class 1255 OID 16806)
-- Name: playerleft1(integer, text, integer); Type: FUNCTION; Schema: server; Owner: bstats_auto
--

CREATE FUNCTION playerleft1(sessionid integer, playerid text, "when" integer) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
-- todo: Sanity checks - has this been called already?
update session.sessionplayers set "left" = ($3 || ' seconds')::interval 
where "session" = $1 and player = server.player_uid_to_id($2);
$_$;


ALTER FUNCTION server.playerleft1(sessionid integer, playerid text, "when" integer) OWNER TO bstats_auto;

--
-- TOC entry 204 (class 1255 OID 16807)
-- Name: position(text); Type: FUNCTION; Schema: server; Owner: mahuja
--

CREATE FUNCTION "position"(text) RETURNS numeric[]
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  select replace((replace($1,'[','{')), ']','}')
	:: numeric array
$_$;


ALTER FUNCTION server."position"(text) OWNER TO mahuja;

--
-- TOC entry 211 (class 1255 OID 17191)
-- Name: roadkill1(integer, text, text, text, integer, text); Type: FUNCTION; Schema: server; Owner: mahuja
--

CREATE FUNCTION roadkill1(sessionid integer, victimid text, killerid text, vehicle_used text, score integer, "position" text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $$
$$;


ALTER FUNCTION server.roadkill1(sessionid integer, victimid text, killerid text, vehicle_used text, score integer, "position" text) OWNER TO mahuja;

--
-- TOC entry 213 (class 1255 OID 17199)
-- Name: suicide1(integer, text, integer, integer, text); Type: FUNCTION; Schema: server; Owner: mahuja
--

CREATE FUNCTION suicide1(sessionid integer, playerid text, "when" integer, score integer, playerpos text) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $_$
insert into event.death ("session", player, "time", "position", points, is_suicide) values
( $1, server.player_uid_to_id($2), 
  ($3 || ' seconds') :: interval,
  server.position($5),
  $4,
  true
)
$_$;


ALTER FUNCTION server.suicide1(sessionid integer, playerid text, "when" integer, score integer, playerpos text) OWNER TO mahuja;

--
-- TOC entry 207 (class 1255 OID 17189)
-- Name: vehinfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer); Type: FUNCTION; Schema: server; Owner: mahuja
--

CREATE FUNCTION vehinfo1(sessionid integer, playerid text, vehicleclass text, "when" integer, weapontime integer, shotsfired integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $$
$$;


ALTER FUNCTION server.vehinfo1(sessionid integer, playerid text, vehicleclass text, "when" integer, weapontime integer, shotsfired integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer) OWNER TO mahuja;

--
-- TOC entry 210 (class 1255 OID 17190)
-- Name: wpninfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer); Type: FUNCTION; Schema: server; Owner: mahuja
--

CREATE FUNCTION wpninfo1(sessionid integer, playerid text, vehicleclass text, "when" integer, weapontime integer, shotsfired integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer) RETURNS void
    LANGUAGE sql SECURITY DEFINER
    AS $$
$$;


ALTER FUNCTION server.wpninfo1(sessionid integer, playerid text, vehicleclass text, "when" integer, weapontime integer, shotsfired integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer) OWNER TO mahuja;

SET search_path = event, pg_catalog;

--
-- TOC entry 185 (class 1259 OID 17454)
-- Name: event_id_counter; Type: SEQUENCE; Schema: event; Owner: mahuja
--

CREATE SEQUENCE event_id_counter
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event.event_id_counter OWNER TO mahuja;

SET default_with_oids = false;

--
-- TOC entry 182 (class 1259 OID 17303)
-- Name: ac_crash; Type: TABLE; Schema: event; Owner: mahuja
--

CREATE TABLE ac_crash (
    eventid bigint DEFAULT nextval('event_id_counter'::regclass) NOT NULL,
    session integer NOT NULL,
    "time" interval NOT NULL,
    playerid integer,
    player_position real[],
    passengers integer,
    vehicle_class text,
    vehicle_position real[]
);


ALTER TABLE event.ac_crash OWNER TO mahuja;

--
-- TOC entry 183 (class 1259 OID 17323)
-- Name: deathevent; Type: TABLE; Schema: event; Owner: mahuja
--

CREATE TABLE deathevent (
    eventid integer DEFAULT nextval('event_id_counter'::regclass) NOT NULL,
    session integer NOT NULL,
    "time" interval,
    victim integer NOT NULL,
    victim_position real[] NOT NULL,
    how character varying(8) NOT NULL,
    teamkill teamkilltype,
    killer integer,
    killer_position real[],
    weapon text,
    victim_class text,
    killer_class text,
    killer_weapon text,
    victim_side text,
    killer_side text,
    CONSTRAINT deathevent_how_check CHECK (((how)::text = ANY (ARRAY[('kill'::character varying)::text, ('death'::character varying)::text, ('drown'::character varying)::text, ('suicide'::character varying)::text, ('roadkill'::character varying)::text])))
);


ALTER TABLE event.deathevent OWNER TO mahuja;

--
-- TOC entry 2074 (class 0 OID 0)
-- Dependencies: 183
-- Name: TABLE deathevent; Type: COMMENT; Schema: event; Owner: mahuja
--

COMMENT ON TABLE deathevent IS 'drop type teamkilltype cascade;
create type teamkilltype as enum (''not'',''empty_friendly'',''teamkill'',''civilian'',''potential warcrime'',''definite warcrime'');

To be considered: victim_side, victim_class, killer_side, killer_class';


--
-- TOC entry 184 (class 1259 OID 17405)
-- Name: vehicledestruction; Type: TABLE; Schema: event; Owner: mahuja
--

CREATE TABLE vehicledestruction (
    eventid integer DEFAULT nextval('event_id_counter'::regclass) NOT NULL,
    session integer NOT NULL,
    extent character varying(8) NOT NULL,
    killerid integer,
    killer_position real[],
    killer_weapon text,
    target_position real[],
    target_class text,
    killer_class text
);


ALTER TABLE event.vehicledestruction OWNER TO mahuja;

--
-- TOC entry 2076 (class 0 OID 0)
-- Dependencies: 184
-- Name: COLUMN vehicledestruction.extent; Type: COMMENT; Schema: event; Owner: mahuja
--

COMMENT ON COLUMN vehicledestruction.extent IS 'mobility, evacuated, decrewed, scrapped';


SET search_path = logs, pg_catalog;

--
-- TOC entry 165 (class 1259 OID 16915)
-- Name: client_errors; Type: TABLE; Schema: logs; Owner: mahuja
--

CREATE TABLE client_errors (
    id integer NOT NULL,
    clientname text,
    "timestamp" timestamp without time zone NOT NULL,
    errormsg text NOT NULL,
    query text
);


ALTER TABLE logs.client_errors OWNER TO mahuja;

--
-- TOC entry 166 (class 1259 OID 16921)
-- Name: client_errors_id_seq; Type: SEQUENCE; Schema: logs; Owner: mahuja
--

CREATE SEQUENCE client_errors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logs.client_errors_id_seq OWNER TO mahuja;

--
-- TOC entry 2079 (class 0 OID 0)
-- Dependencies: 166
-- Name: client_errors_id_seq; Type: SEQUENCE OWNED BY; Schema: logs; Owner: mahuja
--

ALTER SEQUENCE client_errors_id_seq OWNED BY client_errors.id;


SET search_path = player, pg_catalog;

--
-- TOC entry 167 (class 1259 OID 16937)
-- Name: playername; Type: TABLE; Schema: player; Owner: mahuja
--

CREATE TABLE playername (
    playerid integer NOT NULL,
    name text NOT NULL,
    lastseen timestamp with time zone DEFAULT now() NOT NULL,
    firstseen timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE player.playername OWNER TO mahuja;

--
-- TOC entry 168 (class 1259 OID 16945)
-- Name: last_name_seen; Type: VIEW; Schema: player; Owner: mahuja
--

CREATE VIEW last_name_seen AS
SELECT playername.playerid, first_value(playername.name) OVER (PARTITION BY playername.playerid ORDER BY playername.lastseen DESC) AS name FROM playername;


ALTER TABLE player.last_name_seen OWNER TO mahuja;

--
-- TOC entry 169 (class 1259 OID 16949)
-- Name: player; Type: TABLE; Schema: player; Owner: mahuja
--

CREATE TABLE player (
    id bigint NOT NULL,
    gameuid character varying(64) NOT NULL,
    first_seen timestamp with time zone DEFAULT now() NOT NULL,
    last_name_seen text NOT NULL
);


ALTER TABLE player.player OWNER TO mahuja;

--
-- TOC entry 170 (class 1259 OID 16956)
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
-- TOC entry 2082 (class 0 OID 0)
-- Dependencies: 170
-- Name: playerlist_id_seq; Type: SEQUENCE OWNED BY; Schema: player; Owner: mahuja
--

ALTER SEQUENCE playerlist_id_seq OWNED BY player.id;


--
-- TOC entry 171 (class 1259 OID 16958)
-- Name: playersum; Type: TABLE; Schema: player; Owner: mahuja
--

CREATE TABLE playersum (
    playerid integer NOT NULL,
    totalscore integer DEFAULT 0 NOT NULL,
    battlescore integer DEFAULT 0 NOT NULL,
    otherscore integer DEFAULT 0 NOT NULL,
    suicides integer DEFAULT 0 NOT NULL,
    weaponkills integer DEFAULT 0 NOT NULL,
    deaths integer DEFAULT 0 NOT NULL,
    aircrashes integer DEFAULT 0 NOT NULL,
    roadkills integer DEFAULT 0 NOT NULL,
    civcas integer DEFAULT 0 NOT NULL,
    civdmg integer DEFAULT 0 NOT NULL,
    teamkills integer DEFAULT 0 NOT NULL,
    teamdmg integer DEFAULT 0 NOT NULL,
    killed_vehicles integer DEFAULT 0 NOT NULL,
    tked_vehicles integer DEFAULT 0 NOT NULL,
    killassist integer DEFAULT 0 NOT NULL
);


ALTER TABLE player.playersum OWNER TO mahuja;

--
-- TOC entry 172 (class 1259 OID 16976)
-- Name: weaponstats; Type: TABLE; Schema: player; Owner: mahuja
--

CREATE TABLE weaponstats (
    session integer NOT NULL,
    player integer NOT NULL,
    class character varying(40) NOT NULL,
    totalseconds integer DEFAULT 0,
    fired integer DEFAULT 0,
    vehiclehits integer DEFAULT 0,
    headhits integer DEFAULT 0,
    bodyhits integer DEFAULT 0,
    leghits integer DEFAULT 0,
    armhits integer DEFAULT 0
);


ALTER TABLE player.weaponstats OWNER TO mahuja;

--
-- TOC entry 173 (class 1259 OID 16986)
-- Name: weaponstats_sum; Type: TABLE; Schema: player; Owner: mahuja
--

CREATE TABLE weaponstats_sum (
    player integer NOT NULL,
    class character varying(40) NOT NULL,
    totalseconds integer DEFAULT 0 NOT NULL,
    fired integer DEFAULT 0 NOT NULL,
    vehiclehits integer DEFAULT 0 NOT NULL,
    headhits integer DEFAULT 0 NOT NULL,
    bodyhits integer DEFAULT 0 NOT NULL,
    leghits integer DEFAULT 0 NOT NULL,
    armhits integer DEFAULT 0 NOT NULL,
    avgdist real DEFAULT 0 NOT NULL,
    avgcnt integer DEFAULT 0 NOT NULL
);


ALTER TABLE player.weaponstats_sum OWNER TO mahuja;

SET search_path = session, pg_catalog;

--
-- TOC entry 174 (class 1259 OID 16998)
-- Name: errorlog; Type: TABLE; Schema: session; Owner: mahuja
--

CREATE TABLE errorlog (
    errorid integer NOT NULL,
    query text,
    errormessage text
);


ALTER TABLE session.errorlog OWNER TO mahuja;

--
-- TOC entry 2084 (class 0 OID 0)
-- Dependencies: 174
-- Name: TABLE errorlog; Type: COMMENT; Schema: session; Owner: mahuja
--

COMMENT ON TABLE errorlog IS 'Anytime a query fails on a server, that should be logged in this table.';


--
-- TOC entry 175 (class 1259 OID 17004)
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
-- TOC entry 2086 (class 0 OID 0)
-- Dependencies: 175
-- Name: errorlog_errorid_seq; Type: SEQUENCE OWNED BY; Schema: session; Owner: mahuja
--

ALTER SEQUENCE errorlog_errorid_seq OWNED BY errorlog.errorid;


--
-- TOC entry 176 (class 1259 OID 17006)
-- Name: serverlist; Type: TABLE; Schema: session; Owner: mahuja
--

CREATE TABLE serverlist (
    id integer NOT NULL,
    name character varying(64),
    address inet,
    displayname text
);


ALTER TABLE session.serverlist OWNER TO mahuja;

--
-- TOC entry 177 (class 1259 OID 17012)
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
-- TOC entry 2089 (class 0 OID 0)
-- Dependencies: 177
-- Name: serverlist_id_seq; Type: SEQUENCE OWNED BY; Schema: session; Owner: mahuja
--

ALTER SEQUENCE serverlist_id_seq OWNED BY serverlist.id;


--
-- TOC entry 178 (class 1259 OID 17014)
-- Name: session; Type: TABLE; Schema: session; Owner: mahuja
--

CREATE TABLE session (
    id integer NOT NULL,
    missionname text,
    result text,
    server integer NOT NULL,
    duration interval,
    mapname text
);


ALTER TABLE session.session OWNER TO mahuja;

--
-- TOC entry 179 (class 1259 OID 17020)
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
-- TOC entry 2092 (class 0 OID 0)
-- Dependencies: 179
-- Name: session_id_seq; Type: SEQUENCE OWNED BY; Schema: session; Owner: mahuja
--

ALTER SEQUENCE session_id_seq OWNED BY session.id;


--
-- TOC entry 180 (class 1259 OID 17022)
-- Name: sessionplayers; Type: TABLE; Schema: session; Owner: mahuja
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
-- TOC entry 181 (class 1259 OID 17028)
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
-- TOC entry 2095 (class 0 OID 0)
-- Dependencies: 181
-- Name: sessionplayers_id_seq; Type: SEQUENCE OWNED BY; Schema: session; Owner: mahuja
--

ALTER SEQUENCE sessionplayers_id_seq OWNED BY sessionplayers.id;


SET search_path = logs, pg_catalog;

--
-- TOC entry 1854 (class 2604 OID 17057)
-- Name: id; Type: DEFAULT; Schema: logs; Owner: mahuja
--

ALTER TABLE ONLY client_errors ALTER COLUMN id SET DEFAULT nextval('client_errors_id_seq'::regclass);


SET search_path = player, pg_catalog;

--
-- TOC entry 1858 (class 2604 OID 17058)
-- Name: id; Type: DEFAULT; Schema: player; Owner: mahuja
--

ALTER TABLE ONLY player ALTER COLUMN id SET DEFAULT nextval('playerlist_id_seq'::regclass);


SET search_path = session, pg_catalog;

--
-- TOC entry 1890 (class 2604 OID 17059)
-- Name: errorid; Type: DEFAULT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY errorlog ALTER COLUMN errorid SET DEFAULT nextval('errorlog_errorid_seq'::regclass);


--
-- TOC entry 1891 (class 2604 OID 17060)
-- Name: id; Type: DEFAULT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY serverlist ALTER COLUMN id SET DEFAULT nextval('serverlist_id_seq'::regclass);


--
-- TOC entry 1892 (class 2604 OID 17061)
-- Name: id; Type: DEFAULT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY session ALTER COLUMN id SET DEFAULT nextval('session_id_seq'::regclass);


--
-- TOC entry 1893 (class 2604 OID 17062)
-- Name: id; Type: DEFAULT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY sessionplayers ALTER COLUMN id SET DEFAULT nextval('sessionplayers_id_seq'::regclass);


SET search_path = event, pg_catalog;

--
-- TOC entry 1922 (class 2606 OID 17333)
-- Name: deathevent_pkey; Type: CONSTRAINT; Schema: event; Owner: mahuja
--

ALTER TABLE ONLY deathevent
    ADD CONSTRAINT deathevent_pkey PRIMARY KEY (eventid);


--
-- TOC entry 1925 (class 2606 OID 17413)
-- Name: vehicledestruction_pkey; Type: CONSTRAINT; Schema: event; Owner: mahuja
--

ALTER TABLE ONLY vehicledestruction
    ADD CONSTRAINT vehicledestruction_pkey PRIMARY KEY (eventid);


SET search_path = logs, pg_catalog;

--
-- TOC entry 1899 (class 2606 OID 17094)
-- Name: client_errors_pkey; Type: CONSTRAINT; Schema: logs; Owner: mahuja
--

ALTER TABLE ONLY client_errors
    ADD CONSTRAINT client_errors_pkey PRIMARY KEY (id);


SET search_path = player, pg_catalog;

--
-- TOC entry 1903 (class 2606 OID 17102)
-- Name: playerlist_pkey; Type: CONSTRAINT; Schema: player; Owner: mahuja
--

ALTER TABLE ONLY player
    ADD CONSTRAINT playerlist_pkey PRIMARY KEY (id);


--
-- TOC entry 1901 (class 2606 OID 17104)
-- Name: playername_pkey; Type: CONSTRAINT; Schema: player; Owner: mahuja
--

ALTER TABLE ONLY playername
    ADD CONSTRAINT playername_pkey PRIMARY KEY (playerid, name);


--
-- TOC entry 1907 (class 2606 OID 17106)
-- Name: playersum_pkey; Type: CONSTRAINT; Schema: player; Owner: mahuja
--

ALTER TABLE ONLY playersum
    ADD CONSTRAINT playersum_pkey PRIMARY KEY (playerid);


--
-- TOC entry 1905 (class 2606 OID 17108)
-- Name: unique_gameuid; Type: CONSTRAINT; Schema: player; Owner: mahuja
--

ALTER TABLE ONLY player
    ADD CONSTRAINT unique_gameuid UNIQUE (gameuid);


--
-- TOC entry 1909 (class 2606 OID 17110)
-- Name: weaponstats_pkey; Type: CONSTRAINT; Schema: player; Owner: mahuja
--

ALTER TABLE ONLY weaponstats
    ADD CONSTRAINT weaponstats_pkey PRIMARY KEY (session, player, class);


--
-- TOC entry 1911 (class 2606 OID 17112)
-- Name: weaponstats_sum_pkey; Type: CONSTRAINT; Schema: player; Owner: mahuja
--

ALTER TABLE ONLY weaponstats_sum
    ADD CONSTRAINT weaponstats_sum_pkey PRIMARY KEY (player, class);


SET search_path = session, pg_catalog;

--
-- TOC entry 1913 (class 2606 OID 17114)
-- Name: errorlog_pkey; Type: CONSTRAINT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY errorlog
    ADD CONSTRAINT errorlog_pkey PRIMARY KEY (errorid);


--
-- TOC entry 1915 (class 2606 OID 17116)
-- Name: serverlist_pkey; Type: CONSTRAINT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY serverlist
    ADD CONSTRAINT serverlist_pkey PRIMARY KEY (id);


--
-- TOC entry 1917 (class 2606 OID 17118)
-- Name: session_pkey; Type: CONSTRAINT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY session
    ADD CONSTRAINT session_pkey PRIMARY KEY (id);


--
-- TOC entry 1919 (class 2606 OID 17120)
-- Name: sessionplayers_pkey; Type: CONSTRAINT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY sessionplayers
    ADD CONSTRAINT sessionplayers_pkey PRIMARY KEY (id);


SET search_path = event, pg_catalog;

--
-- TOC entry 1920 (class 1259 OID 17335)
-- Name: deathevent_killer_idx; Type: INDEX; Schema: event; Owner: mahuja
--

CREATE INDEX deathevent_killer_idx ON deathevent USING btree (killer) WHERE (killer IS NOT NULL);


--
-- TOC entry 1923 (class 1259 OID 17334)
-- Name: deathevent_victim_killer_idx; Type: INDEX; Schema: event; Owner: mahuja
--

CREATE INDEX deathevent_victim_killer_idx ON deathevent USING btree (victim, killer);


SET search_path = player, pg_catalog;

--
-- TOC entry 2037 (class 2618 OID 17121)
-- Name: upsert; Type: RULE; Schema: player; Owner: mahuja
--

CREATE RULE upsert AS ON INSERT TO player WHERE ((new.gameuid)::text IN (SELECT player.gameuid FROM player)) DO INSTEAD UPDATE player SET last_name_seen = new.last_name_seen WHERE ((player.gameuid)::text = (new.gameuid)::text);


--
-- TOC entry 1934 (class 2620 OID 17123)
-- Name: upsert; Type: TRIGGER; Schema: player; Owner: mahuja
--

CREATE TRIGGER upsert BEFORE INSERT ON weaponstats_sum FOR EACH ROW EXECUTE PROCEDURE weaponstats_sum_upsert();


SET search_path = event, pg_catalog;

--
-- TOC entry 1931 (class 2606 OID 17341)
-- Name: deathevent_killer_fkey; Type: FK CONSTRAINT; Schema: event; Owner: mahuja
--

ALTER TABLE ONLY deathevent
    ADD CONSTRAINT deathevent_killer_fkey FOREIGN KEY (killer) REFERENCES player.player(id);


--
-- TOC entry 1932 (class 2606 OID 17346)
-- Name: deathevent_session_fkey; Type: FK CONSTRAINT; Schema: event; Owner: mahuja
--

ALTER TABLE ONLY deathevent
    ADD CONSTRAINT deathevent_session_fkey FOREIGN KEY (session) REFERENCES session.session(id);


--
-- TOC entry 1930 (class 2606 OID 17336)
-- Name: deathevent_victim_fkey; Type: FK CONSTRAINT; Schema: event; Owner: mahuja
--

ALTER TABLE ONLY deathevent
    ADD CONSTRAINT deathevent_victim_fkey FOREIGN KEY (victim) REFERENCES player.player(id);


--
-- TOC entry 1933 (class 2606 OID 17414)
-- Name: vehicledestruction_session_fkey; Type: FK CONSTRAINT; Schema: event; Owner: mahuja
--

ALTER TABLE ONLY vehicledestruction
    ADD CONSTRAINT vehicledestruction_session_fkey FOREIGN KEY (session) REFERENCES session.session(id);


SET search_path = player, pg_catalog;

--
-- TOC entry 1926 (class 2606 OID 17160)
-- Name: playername_playerid_fkey; Type: FK CONSTRAINT; Schema: player; Owner: mahuja
--

ALTER TABLE ONLY playername
    ADD CONSTRAINT playername_playerid_fkey FOREIGN KEY (playerid) REFERENCES player(id);


SET search_path = session, pg_catalog;

--
-- TOC entry 1927 (class 2606 OID 17134)
-- Name: session_server_fkey; Type: FK CONSTRAINT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY session
    ADD CONSTRAINT session_server_fkey FOREIGN KEY (server) REFERENCES serverlist(id);


--
-- TOC entry 1928 (class 2606 OID 17139)
-- Name: sessionplayers_player_fkey; Type: FK CONSTRAINT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY sessionplayers
    ADD CONSTRAINT sessionplayers_player_fkey FOREIGN KEY (player) REFERENCES player.player(id);


--
-- TOC entry 1929 (class 2606 OID 17144)
-- Name: sessionplayers_session_fkey; Type: FK CONSTRAINT; Schema: session; Owner: mahuja
--

ALTER TABLE ONLY sessionplayers
    ADD CONSTRAINT sessionplayers_session_fkey FOREIGN KEY (session) REFERENCES session(id) ON DELETE CASCADE;


--
-- TOC entry 2043 (class 0 OID 0)
-- Dependencies: 10
-- Name: event; Type: ACL; Schema: -; Owner: mahuja
--

REVOKE ALL ON SCHEMA event FROM PUBLIC;
REVOKE ALL ON SCHEMA event FROM mahuja;
GRANT ALL ON SCHEMA event TO mahuja;
GRANT USAGE ON SCHEMA event TO bstats_auto;
GRANT USAGE ON SCHEMA event TO bstats_reader;
GRANT USAGE ON SCHEMA event TO bstats_admin;


--
-- TOC entry 2044 (class 0 OID 0)
-- Dependencies: 6
-- Name: player; Type: ACL; Schema: -; Owner: mahuja
--

REVOKE ALL ON SCHEMA player FROM PUBLIC;
REVOKE ALL ON SCHEMA player FROM mahuja;
GRANT ALL ON SCHEMA player TO mahuja;
GRANT USAGE ON SCHEMA player TO bstats_auto;
GRANT USAGE ON SCHEMA player TO bstats_admin;
GRANT USAGE ON SCHEMA player TO bstats_reader;


--
-- TOC entry 2046 (class 0 OID 0)
-- Dependencies: 8
-- Name: server; Type: ACL; Schema: -; Owner: mahuja
--

REVOKE ALL ON SCHEMA server FROM PUBLIC;
REVOKE ALL ON SCHEMA server FROM mahuja;
GRANT ALL ON SCHEMA server TO mahuja;
GRANT USAGE ON SCHEMA server TO bstats_servers;
GRANT USAGE ON SCHEMA server TO bstats_auto;


--
-- TOC entry 2047 (class 0 OID 0)
-- Dependencies: 7
-- Name: session; Type: ACL; Schema: -; Owner: mahuja
--

REVOKE ALL ON SCHEMA session FROM PUBLIC;
REVOKE ALL ON SCHEMA session FROM mahuja;
GRANT ALL ON SCHEMA session TO mahuja;
GRANT USAGE ON SCHEMA session TO bstats_auto;
GRANT USAGE ON SCHEMA session TO bstats_reader;


SET search_path = server, pg_catalog;

--
-- TOC entry 2051 (class 0 OID 0)
-- Dependencies: 209
-- Name: accrash1(integer, integer, text, text, integer, text, text); Type: ACL; Schema: server; Owner: mahuja
--

REVOKE ALL ON FUNCTION accrash1(sessionid integer, "when" integer, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text) FROM PUBLIC;
REVOKE ALL ON FUNCTION accrash1(sessionid integer, "when" integer, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text) FROM mahuja;
GRANT ALL ON FUNCTION accrash1(sessionid integer, "when" integer, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text) TO mahuja;
GRANT ALL ON FUNCTION accrash1(sessionid integer, "when" integer, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text) TO PUBLIC;
GRANT ALL ON FUNCTION accrash1(sessionid integer, "when" integer, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text) TO bstats_auto;
GRANT ALL ON FUNCTION accrash1(sessionid integer, "when" integer, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text) TO bstats_servers;


--
-- TOC entry 2052 (class 0 OID 0)
-- Dependencies: 215
-- Name: accrash1(integer, text, integer, integer, text, integer, text); Type: ACL; Schema: server; Owner: mahuja
--

REVOKE ALL ON FUNCTION accrash1(sessionid integer, playerid text, "when" integer, passengercount integer, vehiclename text, score integer, playerpos text) FROM PUBLIC;
REVOKE ALL ON FUNCTION accrash1(sessionid integer, playerid text, "when" integer, passengercount integer, vehiclename text, score integer, playerpos text) FROM mahuja;
GRANT ALL ON FUNCTION accrash1(sessionid integer, playerid text, "when" integer, passengercount integer, vehiclename text, score integer, playerpos text) TO mahuja;
GRANT ALL ON FUNCTION accrash1(sessionid integer, playerid text, "when" integer, passengercount integer, vehiclename text, score integer, playerpos text) TO PUBLIC;
GRANT ALL ON FUNCTION accrash1(sessionid integer, playerid text, "when" integer, passengercount integer, vehiclename text, score integer, playerpos text) TO bstats_auto;
GRANT ALL ON FUNCTION accrash1(sessionid integer, playerid text, "when" integer, passengercount integer, vehiclename text, score integer, playerpos text) TO bstats_servers;


--
-- TOC entry 2053 (class 0 OID 0)
-- Dependencies: 212
-- Name: death1(integer, text, integer, integer, text); Type: ACL; Schema: server; Owner: mahuja
--

REVOKE ALL ON FUNCTION death1(sessionid integer, playerid text, "when" integer, score integer, playerpos text) FROM PUBLIC;
REVOKE ALL ON FUNCTION death1(sessionid integer, playerid text, "when" integer, score integer, playerpos text) FROM mahuja;
GRANT ALL ON FUNCTION death1(sessionid integer, playerid text, "when" integer, score integer, playerpos text) TO mahuja;
GRANT ALL ON FUNCTION death1(sessionid integer, playerid text, "when" integer, score integer, playerpos text) TO PUBLIC;
GRANT ALL ON FUNCTION death1(sessionid integer, playerid text, "when" integer, score integer, playerpos text) TO bstats_auto;
GRANT ALL ON FUNCTION death1(sessionid integer, playerid text, "when" integer, score integer, playerpos text) TO bstats_servers;


--
-- TOC entry 2054 (class 0 OID 0)
-- Dependencies: 214
-- Name: endsession1(integer, numeric, text); Type: ACL; Schema: server; Owner: mahuja
--

REVOKE ALL ON FUNCTION endsession1(sessionid integer, duration numeric, outcome text) FROM PUBLIC;
REVOKE ALL ON FUNCTION endsession1(sessionid integer, duration numeric, outcome text) FROM mahuja;
GRANT ALL ON FUNCTION endsession1(sessionid integer, duration numeric, outcome text) TO mahuja;
GRANT ALL ON FUNCTION endsession1(sessionid integer, duration numeric, outcome text) TO PUBLIC;
GRANT ALL ON FUNCTION endsession1(sessionid integer, duration numeric, outcome text) TO bstats_auto;
GRANT ALL ON FUNCTION endsession1(sessionid integer, duration numeric, outcome text) TO bstats_servers;


--
-- TOC entry 2055 (class 0 OID 0)
-- Dependencies: 208
-- Name: friendlydmg1(integer, text, text, integer, text, integer, numeric, text, text); Type: ACL; Schema: server; Owner: mahuja
--

REVOKE ALL ON FUNCTION friendlydmg1(sessionid integer, victimid text, damageruid text, "when" integer, weapon text, score integer, distance numeric, victimpos text, killerpos text) FROM PUBLIC;
REVOKE ALL ON FUNCTION friendlydmg1(sessionid integer, victimid text, damageruid text, "when" integer, weapon text, score integer, distance numeric, victimpos text, killerpos text) FROM mahuja;
GRANT ALL ON FUNCTION friendlydmg1(sessionid integer, victimid text, damageruid text, "when" integer, weapon text, score integer, distance numeric, victimpos text, killerpos text) TO mahuja;
GRANT ALL ON FUNCTION friendlydmg1(sessionid integer, victimid text, damageruid text, "when" integer, weapon text, score integer, distance numeric, victimpos text, killerpos text) TO PUBLIC;
GRANT ALL ON FUNCTION friendlydmg1(sessionid integer, victimid text, damageruid text, "when" integer, weapon text, score integer, distance numeric, victimpos text, killerpos text) TO bstats_auto;
GRANT ALL ON FUNCTION friendlydmg1(sessionid integer, victimid text, damageruid text, "when" integer, weapon text, score integer, distance numeric, victimpos text, killerpos text) TO bstats_servers;


--
-- TOC entry 2056 (class 0 OID 0)
-- Dependencies: 218
-- Name: inf_killed1(integer, numeric, text, text, text, text, text, text, text); Type: ACL; Schema: server; Owner: mahuja
--

REVOKE ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_class text, victim_position text, killer_uid text, killer_class text, killer_position text, killer_weapon text) FROM PUBLIC;
REVOKE ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_class text, victim_position text, killer_uid text, killer_class text, killer_position text, killer_weapon text) FROM mahuja;
GRANT ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_class text, victim_position text, killer_uid text, killer_class text, killer_position text, killer_weapon text) TO mahuja;
GRANT ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_class text, victim_position text, killer_uid text, killer_class text, killer_position text, killer_weapon text) TO PUBLIC;
GRANT ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_class text, victim_position text, killer_uid text, killer_class text, killer_position text, killer_weapon text) TO bstats_auto;
GRANT ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_class text, victim_position text, killer_uid text, killer_class text, killer_position text, killer_weapon text) TO bstats_servers;


--
-- TOC entry 2057 (class 0 OID 0)
-- Dependencies: 219
-- Name: inf_killed1(integer, numeric, text, text, text, text, text, text, text, text, text); Type: ACL; Schema: server; Owner: mahuja
--

REVOKE ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_class text, victim_position text, victim_side text, killer_uid text, killer_class text, killer_position text, killer_side text, killer_weapon text) FROM PUBLIC;
REVOKE ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_class text, victim_position text, victim_side text, killer_uid text, killer_class text, killer_position text, killer_side text, killer_weapon text) FROM mahuja;
GRANT ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_class text, victim_position text, victim_side text, killer_uid text, killer_class text, killer_position text, killer_side text, killer_weapon text) TO mahuja;
GRANT ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_class text, victim_position text, victim_side text, killer_uid text, killer_class text, killer_position text, killer_side text, killer_weapon text) TO PUBLIC;
GRANT ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_class text, victim_position text, victim_side text, killer_uid text, killer_class text, killer_position text, killer_side text, killer_weapon text) TO bstats_auto;
GRANT ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_class text, victim_position text, victim_side text, killer_uid text, killer_class text, killer_position text, killer_side text, killer_weapon text) TO bstats_servers;


--
-- TOC entry 2058 (class 0 OID 0)
-- Dependencies: 220
-- Name: inf_killed1(integer, numeric, text, text, text, text, text, text, text, text, text, text); Type: ACL; Schema: server; Owner: mahuja
--

REVOKE ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text) FROM PUBLIC;
REVOKE ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text) FROM mahuja;
GRANT ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text) TO mahuja;
GRANT ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text) TO PUBLIC;
GRANT ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text) TO bstats_auto;
GRANT ALL ON FUNCTION inf_killed1(sessionid integer, "when" numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text) TO bstats_servers;


--
-- TOC entry 2060 (class 0 OID 0)
-- Dependencies: 206
-- Name: inf_killed_inf1(integer, text, text, numeric, text, integer, text, text); Type: ACL; Schema: server; Owner: bstats_auto
--

REVOKE ALL ON FUNCTION inf_killed_inf1(sessionid integer, killer text, victim text, "when" numeric, weapon text, score integer, killerpos text, victimpos text) FROM PUBLIC;
REVOKE ALL ON FUNCTION inf_killed_inf1(sessionid integer, killer text, victim text, "when" numeric, weapon text, score integer, killerpos text, victimpos text) FROM bstats_auto;
GRANT ALL ON FUNCTION inf_killed_inf1(sessionid integer, killer text, victim text, "when" numeric, weapon text, score integer, killerpos text, victimpos text) TO bstats_auto;
GRANT ALL ON FUNCTION inf_killed_inf1(sessionid integer, killer text, victim text, "when" numeric, weapon text, score integer, killerpos text, victimpos text) TO bstats_servers;


--
-- TOC entry 2061 (class 0 OID 0)
-- Dependencies: 217
-- Name: missionevent1(integer, text, numeric, integer); Type: ACL; Schema: server; Owner: mahuja
--

REVOKE ALL ON FUNCTION missionevent1(sessionid integer, what text, "when" numeric, score integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION missionevent1(sessionid integer, what text, "when" numeric, score integer) FROM mahuja;
GRANT ALL ON FUNCTION missionevent1(sessionid integer, what text, "when" numeric, score integer) TO mahuja;
GRANT ALL ON FUNCTION missionevent1(sessionid integer, what text, "when" numeric, score integer) TO PUBLIC;
GRANT ALL ON FUNCTION missionevent1(sessionid integer, what text, "when" numeric, score integer) TO bstats_auto;
GRANT ALL ON FUNCTION missionevent1(sessionid integer, what text, "when" numeric, score integer) TO bstats_servers;


--
-- TOC entry 2062 (class 0 OID 0)
-- Dependencies: 201
-- Name: newmission1(integer, text); Type: ACL; Schema: server; Owner: bstats_auto
--

REVOKE ALL ON FUNCTION newmission1(oldsession integer, mission_name text) FROM PUBLIC;
REVOKE ALL ON FUNCTION newmission1(oldsession integer, mission_name text) FROM bstats_auto;
GRANT ALL ON FUNCTION newmission1(oldsession integer, mission_name text) TO bstats_auto;
GRANT ALL ON FUNCTION newmission1(oldsession integer, mission_name text) TO bstats_servers;


--
-- TOC entry 2063 (class 0 OID 0)
-- Dependencies: 216
-- Name: newmission1(integer, text, text); Type: ACL; Schema: server; Owner: mahuja
--

REVOKE ALL ON FUNCTION newmission1(oldsession integer, mission_name text, map_name text) FROM PUBLIC;
REVOKE ALL ON FUNCTION newmission1(oldsession integer, mission_name text, map_name text) FROM mahuja;
GRANT ALL ON FUNCTION newmission1(oldsession integer, mission_name text, map_name text) TO mahuja;
GRANT ALL ON FUNCTION newmission1(oldsession integer, mission_name text, map_name text) TO PUBLIC;
GRANT ALL ON FUNCTION newmission1(oldsession integer, mission_name text, map_name text) TO bstats_auto;
GRANT ALL ON FUNCTION newmission1(oldsession integer, mission_name text, map_name text) TO bstats_servers;


--
-- TOC entry 2064 (class 0 OID 0)
-- Dependencies: 205
-- Name: newplayer1(integer, text, text, numeric, text); Type: ACL; Schema: server; Owner: bstats_auto
--

REVOKE ALL ON FUNCTION newplayer1(sessionid integer, playeruid text, playerside text, jointime numeric, playername_p text) FROM PUBLIC;
REVOKE ALL ON FUNCTION newplayer1(sessionid integer, playeruid text, playerside text, jointime numeric, playername_p text) FROM bstats_auto;
GRANT ALL ON FUNCTION newplayer1(sessionid integer, playeruid text, playerside text, jointime numeric, playername_p text) TO bstats_auto;
GRANT ALL ON FUNCTION newplayer1(sessionid integer, playeruid text, playerside text, jointime numeric, playername_p text) TO bstats_servers;


--
-- TOC entry 2065 (class 0 OID 0)
-- Dependencies: 202
-- Name: player_uid_to_id(text); Type: ACL; Schema: server; Owner: bstats_auto
--

REVOKE ALL ON FUNCTION player_uid_to_id(uid text) FROM PUBLIC;
REVOKE ALL ON FUNCTION player_uid_to_id(uid text) FROM bstats_auto;
GRANT ALL ON FUNCTION player_uid_to_id(uid text) TO bstats_auto;
GRANT ALL ON FUNCTION player_uid_to_id(uid text) TO bstats_servers;


--
-- TOC entry 2066 (class 0 OID 0)
-- Dependencies: 203
-- Name: playerleft1(integer, text, integer); Type: ACL; Schema: server; Owner: bstats_auto
--

REVOKE ALL ON FUNCTION playerleft1(sessionid integer, playerid text, "when" integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION playerleft1(sessionid integer, playerid text, "when" integer) FROM bstats_auto;
GRANT ALL ON FUNCTION playerleft1(sessionid integer, playerid text, "when" integer) TO bstats_auto;
GRANT ALL ON FUNCTION playerleft1(sessionid integer, playerid text, "when" integer) TO bstats_servers;


--
-- TOC entry 2067 (class 0 OID 0)
-- Dependencies: 204
-- Name: position(text); Type: ACL; Schema: server; Owner: mahuja
--

REVOKE ALL ON FUNCTION "position"(text) FROM PUBLIC;
REVOKE ALL ON FUNCTION "position"(text) FROM mahuja;
GRANT ALL ON FUNCTION "position"(text) TO mahuja;
GRANT ALL ON FUNCTION "position"(text) TO bstats_servers;
GRANT ALL ON FUNCTION "position"(text) TO bstats_auto;


--
-- TOC entry 2068 (class 0 OID 0)
-- Dependencies: 211
-- Name: roadkill1(integer, text, text, text, integer, text); Type: ACL; Schema: server; Owner: mahuja
--

REVOKE ALL ON FUNCTION roadkill1(sessionid integer, victimid text, killerid text, vehicle_used text, score integer, "position" text) FROM PUBLIC;
REVOKE ALL ON FUNCTION roadkill1(sessionid integer, victimid text, killerid text, vehicle_used text, score integer, "position" text) FROM mahuja;
GRANT ALL ON FUNCTION roadkill1(sessionid integer, victimid text, killerid text, vehicle_used text, score integer, "position" text) TO mahuja;
GRANT ALL ON FUNCTION roadkill1(sessionid integer, victimid text, killerid text, vehicle_used text, score integer, "position" text) TO PUBLIC;
GRANT ALL ON FUNCTION roadkill1(sessionid integer, victimid text, killerid text, vehicle_used text, score integer, "position" text) TO bstats_auto;
GRANT ALL ON FUNCTION roadkill1(sessionid integer, victimid text, killerid text, vehicle_used text, score integer, "position" text) TO bstats_servers;


--
-- TOC entry 2069 (class 0 OID 0)
-- Dependencies: 213
-- Name: suicide1(integer, text, integer, integer, text); Type: ACL; Schema: server; Owner: mahuja
--

REVOKE ALL ON FUNCTION suicide1(sessionid integer, playerid text, "when" integer, score integer, playerpos text) FROM PUBLIC;
REVOKE ALL ON FUNCTION suicide1(sessionid integer, playerid text, "when" integer, score integer, playerpos text) FROM mahuja;
GRANT ALL ON FUNCTION suicide1(sessionid integer, playerid text, "when" integer, score integer, playerpos text) TO mahuja;
GRANT ALL ON FUNCTION suicide1(sessionid integer, playerid text, "when" integer, score integer, playerpos text) TO PUBLIC;
GRANT ALL ON FUNCTION suicide1(sessionid integer, playerid text, "when" integer, score integer, playerpos text) TO bstats_auto;
GRANT ALL ON FUNCTION suicide1(sessionid integer, playerid text, "when" integer, score integer, playerpos text) TO bstats_servers;


--
-- TOC entry 2070 (class 0 OID 0)
-- Dependencies: 207
-- Name: vehinfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer); Type: ACL; Schema: server; Owner: mahuja
--

REVOKE ALL ON FUNCTION vehinfo1(sessionid integer, playerid text, vehicleclass text, "when" integer, weapontime integer, shotsfired integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION vehinfo1(sessionid integer, playerid text, vehicleclass text, "when" integer, weapontime integer, shotsfired integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer) FROM mahuja;
GRANT ALL ON FUNCTION vehinfo1(sessionid integer, playerid text, vehicleclass text, "when" integer, weapontime integer, shotsfired integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer) TO mahuja;
GRANT ALL ON FUNCTION vehinfo1(sessionid integer, playerid text, vehicleclass text, "when" integer, weapontime integer, shotsfired integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer) TO PUBLIC;
GRANT ALL ON FUNCTION vehinfo1(sessionid integer, playerid text, vehicleclass text, "when" integer, weapontime integer, shotsfired integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer) TO bstats_auto;
GRANT ALL ON FUNCTION vehinfo1(sessionid integer, playerid text, vehicleclass text, "when" integer, weapontime integer, shotsfired integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer) TO bstats_servers;


--
-- TOC entry 2071 (class 0 OID 0)
-- Dependencies: 210
-- Name: wpninfo1(integer, text, text, integer, integer, integer, integer, integer, integer, integer); Type: ACL; Schema: server; Owner: mahuja
--

REVOKE ALL ON FUNCTION wpninfo1(sessionid integer, playerid text, vehicleclass text, "when" integer, weapontime integer, shotsfired integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION wpninfo1(sessionid integer, playerid text, vehicleclass text, "when" integer, weapontime integer, shotsfired integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer) FROM mahuja;
GRANT ALL ON FUNCTION wpninfo1(sessionid integer, playerid text, vehicleclass text, "when" integer, weapontime integer, shotsfired integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer) TO mahuja;
GRANT ALL ON FUNCTION wpninfo1(sessionid integer, playerid text, vehicleclass text, "when" integer, weapontime integer, shotsfired integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer) TO PUBLIC;
GRANT ALL ON FUNCTION wpninfo1(sessionid integer, playerid text, vehicleclass text, "when" integer, weapontime integer, shotsfired integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer) TO bstats_auto;
GRANT ALL ON FUNCTION wpninfo1(sessionid integer, playerid text, vehicleclass text, "when" integer, weapontime integer, shotsfired integer, hit_head integer, hit_body integer, hit_arms integer, hit_legs integer) TO bstats_servers;


SET search_path = event, pg_catalog;

--
-- TOC entry 2072 (class 0 OID 0)
-- Dependencies: 185
-- Name: event_id_counter; Type: ACL; Schema: event; Owner: mahuja
--

REVOKE ALL ON SEQUENCE event_id_counter FROM PUBLIC;
REVOKE ALL ON SEQUENCE event_id_counter FROM mahuja;
GRANT ALL ON SEQUENCE event_id_counter TO mahuja;
GRANT ALL ON SEQUENCE event_id_counter TO bstats_auto;


--
-- TOC entry 2073 (class 0 OID 0)
-- Dependencies: 182
-- Name: ac_crash; Type: ACL; Schema: event; Owner: mahuja
--

REVOKE ALL ON TABLE ac_crash FROM PUBLIC;
REVOKE ALL ON TABLE ac_crash FROM mahuja;
GRANT ALL ON TABLE ac_crash TO mahuja;
GRANT INSERT ON TABLE ac_crash TO bstats_auto;
GRANT SELECT ON TABLE ac_crash TO bstats_reader;


--
-- TOC entry 2075 (class 0 OID 0)
-- Dependencies: 183
-- Name: deathevent; Type: ACL; Schema: event; Owner: mahuja
--

REVOKE ALL ON TABLE deathevent FROM PUBLIC;
REVOKE ALL ON TABLE deathevent FROM mahuja;
GRANT ALL ON TABLE deathevent TO mahuja;
GRANT INSERT ON TABLE deathevent TO bstats_auto;
GRANT SELECT ON TABLE deathevent TO bstats_reader;


--
-- TOC entry 2077 (class 0 OID 0)
-- Dependencies: 184
-- Name: vehicledestruction; Type: ACL; Schema: event; Owner: mahuja
--

REVOKE ALL ON TABLE vehicledestruction FROM PUBLIC;
REVOKE ALL ON TABLE vehicledestruction FROM mahuja;
GRANT ALL ON TABLE vehicledestruction TO mahuja;
GRANT INSERT ON TABLE vehicledestruction TO bstats_auto;
GRANT SELECT ON TABLE vehicledestruction TO bstats_reader;


SET search_path = logs, pg_catalog;

--
-- TOC entry 2078 (class 0 OID 0)
-- Dependencies: 165
-- Name: client_errors; Type: ACL; Schema: logs; Owner: mahuja
--

REVOKE ALL ON TABLE client_errors FROM PUBLIC;
REVOKE ALL ON TABLE client_errors FROM mahuja;
GRANT ALL ON TABLE client_errors TO mahuja;
GRANT INSERT ON TABLE client_errors TO bstats_auto;


--
-- TOC entry 2080 (class 0 OID 0)
-- Dependencies: 166
-- Name: client_errors_id_seq; Type: ACL; Schema: logs; Owner: mahuja
--

REVOKE ALL ON SEQUENCE client_errors_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE client_errors_id_seq FROM mahuja;
GRANT ALL ON SEQUENCE client_errors_id_seq TO mahuja;


SET search_path = player, pg_catalog;

--
-- TOC entry 2081 (class 0 OID 0)
-- Dependencies: 169
-- Name: player; Type: ACL; Schema: player; Owner: mahuja
--

REVOKE ALL ON TABLE player FROM PUBLIC;
REVOKE ALL ON TABLE player FROM mahuja;
GRANT ALL ON TABLE player TO mahuja;
GRANT SELECT,INSERT,UPDATE ON TABLE player TO bstats_auto;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE player TO bstats_admin;
GRANT SELECT ON TABLE player TO bstats_reader;


--
-- TOC entry 2083 (class 0 OID 0)
-- Dependencies: 170
-- Name: playerlist_id_seq; Type: ACL; Schema: player; Owner: mahuja
--

REVOKE ALL ON SEQUENCE playerlist_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE playerlist_id_seq FROM mahuja;
GRANT ALL ON SEQUENCE playerlist_id_seq TO mahuja;
GRANT USAGE ON SEQUENCE playerlist_id_seq TO bstats_auto;


SET search_path = session, pg_catalog;

--
-- TOC entry 2085 (class 0 OID 0)
-- Dependencies: 174
-- Name: errorlog; Type: ACL; Schema: session; Owner: mahuja
--

REVOKE ALL ON TABLE errorlog FROM PUBLIC;
REVOKE ALL ON TABLE errorlog FROM mahuja;
GRANT ALL ON TABLE errorlog TO mahuja;
GRANT SELECT,INSERT,UPDATE ON TABLE errorlog TO bstats_auto;


--
-- TOC entry 2087 (class 0 OID 0)
-- Dependencies: 175
-- Name: errorlog_errorid_seq; Type: ACL; Schema: session; Owner: mahuja
--

REVOKE ALL ON SEQUENCE errorlog_errorid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE errorlog_errorid_seq FROM mahuja;
GRANT ALL ON SEQUENCE errorlog_errorid_seq TO mahuja;
GRANT SELECT,UPDATE ON SEQUENCE errorlog_errorid_seq TO bstats_auto;


--
-- TOC entry 2088 (class 0 OID 0)
-- Dependencies: 176
-- Name: serverlist; Type: ACL; Schema: session; Owner: mahuja
--

REVOKE ALL ON TABLE serverlist FROM PUBLIC;
REVOKE ALL ON TABLE serverlist FROM mahuja;
GRANT ALL ON TABLE serverlist TO mahuja;
GRANT SELECT,INSERT,UPDATE ON TABLE serverlist TO bstats_auto;


--
-- TOC entry 2090 (class 0 OID 0)
-- Dependencies: 177
-- Name: serverlist_id_seq; Type: ACL; Schema: session; Owner: mahuja
--

REVOKE ALL ON SEQUENCE serverlist_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE serverlist_id_seq FROM mahuja;
GRANT ALL ON SEQUENCE serverlist_id_seq TO mahuja;
GRANT SELECT,UPDATE ON SEQUENCE serverlist_id_seq TO bstats_auto;


--
-- TOC entry 2091 (class 0 OID 0)
-- Dependencies: 178
-- Name: session; Type: ACL; Schema: session; Owner: mahuja
--

REVOKE ALL ON TABLE session FROM PUBLIC;
REVOKE ALL ON TABLE session FROM mahuja;
GRANT ALL ON TABLE session TO mahuja;
GRANT SELECT,INSERT,UPDATE ON TABLE session TO bstats_auto;


--
-- TOC entry 2093 (class 0 OID 0)
-- Dependencies: 179
-- Name: session_id_seq; Type: ACL; Schema: session; Owner: mahuja
--

REVOKE ALL ON SEQUENCE session_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE session_id_seq FROM mahuja;
GRANT ALL ON SEQUENCE session_id_seq TO mahuja;
GRANT SELECT,UPDATE ON SEQUENCE session_id_seq TO bstats_auto;


--
-- TOC entry 2094 (class 0 OID 0)
-- Dependencies: 180
-- Name: sessionplayers; Type: ACL; Schema: session; Owner: mahuja
--

REVOKE ALL ON TABLE sessionplayers FROM PUBLIC;
REVOKE ALL ON TABLE sessionplayers FROM mahuja;
GRANT ALL ON TABLE sessionplayers TO mahuja;
GRANT SELECT,INSERT,UPDATE ON TABLE sessionplayers TO bstats_auto;


--
-- TOC entry 2096 (class 0 OID 0)
-- Dependencies: 181
-- Name: sessionplayers_id_seq; Type: ACL; Schema: session; Owner: mahuja
--

REVOKE ALL ON SEQUENCE sessionplayers_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE sessionplayers_id_seq FROM mahuja;
GRANT ALL ON SEQUENCE sessionplayers_id_seq TO mahuja;
GRANT SELECT,UPDATE ON SEQUENCE sessionplayers_id_seq TO bstats_auto;


SET search_path = event, pg_catalog;

--
-- TOC entry 1519 (class 826 OID 17149)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: event; Owner: mahuja
--

ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA event REVOKE ALL ON SEQUENCES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA event REVOKE ALL ON SEQUENCES  FROM mahuja;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA event GRANT ALL ON SEQUENCES  TO bstats_auto;


--
-- TOC entry 1520 (class 826 OID 17150)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: event; Owner: mahuja
--

ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA event REVOKE ALL ON TABLES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA event REVOKE ALL ON TABLES  FROM mahuja;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA event GRANT INSERT ON TABLES  TO bstats_auto;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA event GRANT SELECT ON TABLES  TO bstats_reader;


SET search_path = server, pg_catalog;

--
-- TOC entry 1522 (class 826 OID 17154)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: server; Owner: mahuja
--

ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA server REVOKE ALL ON FUNCTIONS  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA server REVOKE ALL ON FUNCTIONS  FROM mahuja;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA server GRANT ALL ON FUNCTIONS  TO bstats_auto;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA server GRANT ALL ON FUNCTIONS  TO bstats_servers;


SET search_path = session, pg_catalog;

--
-- TOC entry 1521 (class 826 OID 17155)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: session; Owner: mahuja
--

ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA session REVOKE ALL ON TABLES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA session REVOKE ALL ON TABLES  FROM mahuja;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA session GRANT SELECT,INSERT,UPDATE ON TABLES  TO bstats_auto;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA session GRANT SELECT ON TABLES  TO bstats_reader;


-- Completed on 2014-07-11 17:49:38

--
-- PostgreSQL database dump complete
--

