-- Table: session.serverlist

-- DROP TABLE session.serverlist;

CREATE TABLE session.serverlist
(
  id serial NOT NULL,
  name character varying(64),
  address inet,
  displayname text,
  CONSTRAINT serverlist_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE session.serverlist
  OWNER TO mahuja;
GRANT ALL ON TABLE session.serverlist TO mahuja;
GRANT SELECT, UPDATE, INSERT ON TABLE session.serverlist TO armalive_auto;
