-- Table: event.deathevent

-- DROP TABLE event.deathevent;

CREATE TABLE event.deathevent
(
  eventid integer NOT NULL DEFAULT nextval('event.event_id_counter'::regclass),
  session integer NOT NULL,
  "time" interval,
  how character varying(8) NOT NULL,
  victim integer NOT NULL,
  victim_position real[] NOT NULL,
  victim_class text,
  victim_side text,
  killer integer,
  killer_position real[],
  killer_class text,
  killer_side text,
  killer_weapon text,
  teamkill text,
  CONSTRAINT deathevent_pkey PRIMARY KEY (eventid),
  CONSTRAINT deathevent_killer_fkey FOREIGN KEY (killer)
      REFERENCES player.player (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT deathevent_session_fkey FOREIGN KEY (session)
      REFERENCES session.session (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT deathevent_victim_fkey FOREIGN KEY (victim)
      REFERENCES player.player (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT deathevent_how_check CHECK (how::text = ANY (ARRAY['kill'::character varying::text, 'death'::character varying::text, 'drown'::character varying::text, 'suicide'::character varying::text, 'roadkill'::character varying::text])),
  CONSTRAINT deathevent_teamkill_check CHECK (teamkill = ANY (ARRAY['not'::text, 'empty_friendly'::text, 'teamkill'::text, 'civilian'::text, 'potential warcrime'::text, 'definite warcrime'::text]))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE event.deathevent
  OWNER TO mahuja;
GRANT ALL ON TABLE event.deathevent TO mahuja;
GRANT INSERT ON TABLE event.deathevent TO armalive_auto;
GRANT SELECT ON TABLE event.deathevent TO armalive_reader;

-- Index: event.deathevent_killer_victim_idx

-- DROP INDEX event.deathevent_killer_victim_idx;

CREATE INDEX deathevent_killer_victim_idx
  ON event.deathevent
  USING btree
  (killer, victim);

-- Index: event.deathevent_victim_idx

-- DROP INDEX event.deathevent_victim_idx;

CREATE INDEX deathevent_victim_idx
  ON event.deathevent
  USING btree
  (victim);

