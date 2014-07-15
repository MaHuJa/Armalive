-- Sequence: logs.client_errors_id_seq

-- DROP SEQUENCE logs.client_errors_id_seq;

CREATE SEQUENCE logs.client_errors_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE logs.client_errors_id_seq
  OWNER TO mahuja;
GRANT ALL ON TABLE logs.client_errors_id_seq TO mahuja;
