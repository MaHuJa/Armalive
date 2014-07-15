-- Sequence: session.errorlog_errorid_seq

-- DROP SEQUENCE session.errorlog_errorid_seq;

CREATE SEQUENCE session.errorlog_errorid_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE session.errorlog_errorid_seq
  OWNER TO mahuja;
GRANT ALL ON TABLE session.errorlog_errorid_seq TO mahuja;
GRANT SELECT, UPDATE ON TABLE session.errorlog_errorid_seq TO armalive_auto;
