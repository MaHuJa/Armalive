-- Schema: session

-- DROP SCHEMA session;

CREATE SCHEMA session
  AUTHORIZATION mahuja;

GRANT ALL ON SCHEMA session TO mahuja;
GRANT USAGE ON SCHEMA session TO armalive_auto;
GRANT USAGE ON SCHEMA session TO armalive_reader;

ALTER DEFAULT PRIVILEGES IN SCHEMA session
    GRANT INSERT, SELECT, UPDATE ON TABLES
    TO armalive_auto;

ALTER DEFAULT PRIVILEGES IN SCHEMA session
    GRANT SELECT ON TABLES
    TO armalive_reader;

