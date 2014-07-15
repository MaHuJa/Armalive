-- Table: session.errorlog

-- DROP TABLE session.errorlog;

CREATE TABLE session.errorlog
(
  errorid serial NOT NULL,
  query text,
  errormessage text,
  CONSTRAINT errorlog_pkey PRIMARY KEY (errorid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE session.errorlog
  OWNER TO mahuja;
GRANT ALL ON TABLE session.errorlog TO mahuja;
GRANT SELECT, UPDATE, INSERT ON TABLE session.errorlog TO armalive_auto;
COMMENT ON TABLE session.errorlog
  IS 'Anytime a query fails on a server, that should be logged in this table.';
