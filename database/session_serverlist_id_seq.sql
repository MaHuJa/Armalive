-- Sequence: session.serverlist_id_seq

-- DROP SEQUENCE session.serverlist_id_seq;

CREATE SEQUENCE session.serverlist_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 3
  CACHE 1;
ALTER TABLE session.serverlist_id_seq
  OWNER TO mahuja;
GRANT ALL ON TABLE session.serverlist_id_seq TO mahuja;
GRANT SELECT, UPDATE ON TABLE session.serverlist_id_seq TO armalive_auto;
