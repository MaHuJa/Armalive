-- Schema: server

-- DROP SCHEMA server;

CREATE SCHEMA server
  AUTHORIZATION mahuja;

GRANT ALL ON SCHEMA server TO mahuja;
GRANT USAGE ON SCHEMA server TO armalive_auto;
GRANT USAGE ON SCHEMA server TO armalive_server;
GRANT USAGE ON SCHEMA server TO armalive_reader;
COMMENT ON SCHEMA server
  IS 'This schema shall contain ALL the server needs access to. Mostly functions that run with enough priveleges for that particular task.';

ALTER DEFAULT PRIVILEGES IN SCHEMA server
    GRANT EXECUTE ON FUNCTIONS
    TO armalive_auto;

ALTER DEFAULT PRIVILEGES IN SCHEMA server
    GRANT EXECUTE ON FUNCTIONS
    TO armalive_server;

