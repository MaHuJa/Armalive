-- Table: event.ac_crash

-- DROP TABLE event.ac_crash;

CREATE TABLE event.ac_crash
(
  eventid bigint NOT NULL DEFAULT nextval('event.event_id_counter'::regclass),
  session integer NOT NULL,
  "time" interval NOT NULL,
  playerid integer,
  player_position real[],
  passengers integer,
  vehicle_class text,
  vehicle_position real[],
  CONSTRAINT ac_crash_pkey PRIMARY KEY (eventid),
  CONSTRAINT ac_crash_playerid_fkey FOREIGN KEY (playerid)
      REFERENCES player.player (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT ac_crash_session_fkey FOREIGN KEY (session)
      REFERENCES session.session (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT ac_crash_passengers_positive CHECK (passengers >= 0)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE event.ac_crash
  OWNER TO mahuja;
GRANT ALL ON TABLE event.ac_crash TO mahuja;
GRANT INSERT ON TABLE event.ac_crash TO armalive_auto;
GRANT SELECT ON TABLE event.ac_crash TO armalive_reader;

-- Index: event.ac_crash_playerid_idx

-- DROP INDEX event.ac_crash_playerid_idx;

CREATE INDEX ac_crash_playerid_idx
  ON event.ac_crash
  USING btree
  (playerid);

