-- Table: persistence.atlas

-- DROP TABLE persistence.atlas;

CREATE TABLE persistence.atlas
(
  playerid integer NOT NULL,
  varname text NOT NULL,
  increment integer,
  session integer NOT NULL,
  id integer NOT NULL DEFAULT nextval('persistence.atlas_variables_id_seq'::regclass),
  CONSTRAINT atlas_variables_pkey PRIMARY KEY (id),
  CONSTRAINT atlas_session_fkey FOREIGN KEY (session)
      REFERENCES session.session (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE persistence.atlas
  OWNER TO mahuja;
GRANT ALL ON TABLE persistence.atlas TO mahuja;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE persistence.atlas TO armalive_auto;
GRANT SELECT ON TABLE persistence.atlas TO armalive_admin;

-- Index: persistence.atlas_playerid_varname_idx

-- DROP INDEX persistence.atlas_playerid_varname_idx;

CREATE INDEX atlas_playerid_varname_idx
  ON persistence.atlas
  USING btree
  (playerid, varname COLLATE pg_catalog."default");

