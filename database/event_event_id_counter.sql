-- Sequence: event.event_id_counter

-- DROP SEQUENCE event.event_id_counter;

CREATE SEQUENCE event.event_id_counter
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1131
  CACHE 1;
ALTER TABLE event.event_id_counter
  OWNER TO mahuja;
GRANT ALL ON TABLE event.event_id_counter TO mahuja;
GRANT ALL ON TABLE event.event_id_counter TO armalive_auto;
