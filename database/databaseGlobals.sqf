--
-- PostgreSQL database cluster dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE "all";
ALTER ROLE "all" WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION VALID UNTIL 'infinity';
CREATE ROLE "armalive.com";
ALTER ROLE "armalive.com" WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'md54a19d99168ea3c77d7ebd4fc952d5183' VALID UNTIL 'infinity';
CREATE ROLE armalive_admin;
ALTER ROLE armalive_admin WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION VALID UNTIL 'infinity';
CREATE ROLE armalive_auto;
ALTER ROLE armalive_auto WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION VALID UNTIL 'infinity';
CREATE ROLE armalive_devtest;
ALTER ROLE armalive_devtest WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'md5bb665e031046824088cf9ed7056e3762' VALID UNTIL 'infinity';
CREATE ROLE armalive_reader;
ALTER ROLE armalive_reader WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION VALID UNTIL 'infinity';
CREATE ROLE armalive_server;
ALTER ROLE armalive_server WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION VALID UNTIL 'infinity';
CREATE ROLE hywell;
ALTER ROLE hywell WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'md5f859403029288b44b78f883286e68b69' VALID UNTIL 'infinity';
CREATE ROLE loki;
ALTER ROLE loki WITH NOSUPERUSER INHERIT CREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'md555954963d6ef110358caed88b2f576a3' VALID UNTIL 'infinity';
CREATE ROLE mahuja;
ALTER ROLE mahuja WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION PASSWORD 'md5b92dcbd92637e2a2666a763eaf823465' VALID UNTIL 'infinity';
CREATE ROLE manw_jury;
ALTER ROLE manw_jury WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'md56f9dfd56fa44f76ec88f5aeb6199f9f7' VALID UNTIL 'infinity';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION PASSWORD 'md53a2ffdf3ad221cdca438ffa6a2f87f02';
CREATE ROLE spyder;
ALTER ROLE spyder WITH NOSUPERUSER INHERIT CREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'md5bb18a9d6c2df5f5dc385cbfd521fb109' VALID UNTIL 'infinity';
ALTER ROLE mahuja SET search_path TO "$user", public, static, raw, cooked, pg_catalog;


--
-- Role memberships
--

GRANT "all" TO mahuja GRANTED BY mahuja;
GRANT armalive_admin TO hywell GRANTED BY mahuja;
GRANT armalive_admin TO loki GRANTED BY mahuja;
GRANT armalive_admin TO spyder GRANTED BY mahuja;
GRANT armalive_auto TO armalive_admin GRANTED BY mahuja;
GRANT armalive_reader TO "armalive.com" GRANTED BY mahuja;
GRANT armalive_reader TO armalive_admin GRANTED BY mahuja;
GRANT armalive_server TO armalive_admin GRANTED BY mahuja;
GRANT armalive_server TO armalive_devtest GRANTED BY mahuja;
GRANT armalive_server TO manw_jury GRANTED BY mahuja;




--
-- PostgreSQL database cluster dump complete
--

