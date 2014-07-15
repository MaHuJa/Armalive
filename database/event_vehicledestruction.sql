-- Table: event.vehicledestruction

-- DROP TABLE event.vehicledestruction;

CREATE TABLE event.vehicledestruction
(
  eventid integer NOT NULL DEFAULT nextval('event.event_id_counter'::regclass),
  session integer NOT NULL,
  extent character varying(8) NOT NULL, -- mobility, evacuated, decrewed, scrapped
  killerid integer,
  killer_position real[],
  killer_weapon text,
  target_position real[],
  target_class text,
  killer_class text,
  CONSTRAINT vehicledestruction_pkey PRIMARY KEY (eventid),
  CONSTRAINT vehicledestruction_session_fkey FOREIGN KEY (session)
      REFERENCES session.session (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE event.vehicledestruction
  OWNER TO mahuja;
GRANT ALL ON TABLE event.vehicledestruction TO mahuja;
GRANT INSERT ON TABLE event.vehicledestruction TO armalive_auto;
GRANT SELECT ON TABLE event.vehicledestruction TO armalive_reader;
COMMENT ON COLUMN event.vehicledestruction.extent IS 'mobility, evacuated, decrewed, scrapped';

