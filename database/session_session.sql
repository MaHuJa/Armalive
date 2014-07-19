-- Table: session.session

-- DROP TABLE session.session;

CREATE TABLE session.session
(
  id serial NOT NULL,
  missionname text,
  result text,
  server integer NOT NULL,
  duration interval,
  mapname text,
  duplidetect numeric,
  session_start timestamp with time zone DEFAULT now(),
  CONSTRAINT session_pkey PRIMARY KEY (id),
  CONSTRAINT session_server_fkey FOREIGN KEY (server)
      REFERENCES session.serverlist (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE session.session
  OWNER TO mahuja;
GRANT ALL ON TABLE session.session TO mahuja;
GRANT SELECT, UPDATE, INSERT ON TABLE session.session TO armalive_auto;
