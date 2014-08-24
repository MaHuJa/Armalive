-- Table: event.vehicledestruction

DROP TABLE IF EXISTS event.vehicledestruction;

CREATE TABLE event.vehicledestruction
(
  eventid integer NOT NULL DEFAULT nextval('event.event_id_counter'::regclass),
  session integer NOT NULL,
  "when" interval NOT NULL,
  severity character varying(9) NOT NULL, -- mobility, evacuated, decrewed, scrapped
  vehicleclass text NOT NULL,
  vehicleposition real[] NOT NULL,

  last_used_by_side text,
  last_used_by_player integer,
  
  killer integer,
  killer_position real[],
  killer_class text,
  killer_weapon text,
  killer_side text,
  
  CONSTRAINT vehicledestruction_pkey PRIMARY KEY (eventid),
  CONSTRAINT vehicledestruction_session_fkey FOREIGN KEY (session)
      REFERENCES session.session (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT vehicledestruction_severity_check CHECK 
	(severity::text = ANY (ARRAY[
	'mobility'::character varying::text, 
	'evacuated'::character varying::text, 
	'decrewed'::character varying::text, 
	'scrapped'::character varying::text
	]))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE event.vehicledestruction
  OWNER TO mahuja;
GRANT ALL ON TABLE event.vehicledestruction TO mahuja;
GRANT INSERT ON TABLE event.vehicledestruction TO armalive_auto;
GRANT SELECT ON TABLE event.vehicledestruction TO armalive_reader;
COMMENT ON COLUMN event.vehicledestruction.severity IS 'mobility, evacuated, decrewed, scrapped';

