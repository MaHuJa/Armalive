-- Sequence: session.session_id_seq

-- DROP SEQUENCE session.session_id_seq;

CREATE SEQUENCE session.session_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 25
  CACHE 1;
ALTER TABLE session.session_id_seq
  OWNER TO mahuja;
GRANT ALL ON TABLE session.session_id_seq TO mahuja;
GRANT SELECT, UPDATE ON TABLE session.session_id_seq TO armalive_auto;
