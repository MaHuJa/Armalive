-- Sequence: player.playerlist_id_seq

-- DROP SEQUENCE player.playerlist_id_seq;

CREATE SEQUENCE player.playerlist_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 7
  CACHE 1;
ALTER TABLE player.playerlist_id_seq
  OWNER TO mahuja;
GRANT ALL ON TABLE player.playerlist_id_seq TO mahuja;
GRANT USAGE ON TABLE player.playerlist_id_seq TO armalive_auto;
