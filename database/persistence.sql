-- Schema: persistence

-- DROP SCHEMA persistence;

CREATE SCHEMA persistence
  AUTHORIZATION mahuja;

GRANT ALL ON SCHEMA persistence TO mahuja;
GRANT USAGE ON SCHEMA persistence TO armalive_auto;
GRANT USAGE ON SCHEMA persistence TO armalive_admin;

ALTER DEFAULT PRIVILEGES IN SCHEMA persistence
    GRANT INSERT, SELECT, UPDATE ON TABLES
    TO armalive_auto;

ALTER DEFAULT PRIVILEGES IN SCHEMA persistence
    GRANT SELECT, UPDATE, USAGE ON SEQUENCES
    TO armalive_auto;

ALTER DEFAULT PRIVILEGES IN SCHEMA persistence
    GRANT EXECUTE ON FUNCTIONS
    TO armalive_auto;

