-- Table: persistence.atlas_archive

-- DROP TABLE persistence.atlas_archive;

CREATE TABLE persistence.atlas_archive
(
  playerid integer NOT NULL,
  varname text NOT NULL,
  increment integer,
  session integer NOT NULL,
  id integer NOT NULL,
  CONSTRAINT atlas_archive_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE persistence.atlas_archive
  OWNER TO mahuja;
GRANT ALL ON TABLE persistence.atlas_archive TO mahuja;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE persistence.atlas_archive TO armalive_auto;
GRANT SELECT ON TABLE persistence.atlas_archive TO armalive_admin;
