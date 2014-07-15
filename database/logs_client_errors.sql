-- Table: logs.client_errors

-- DROP TABLE logs.client_errors;

CREATE TABLE logs.client_errors
(
  id serial NOT NULL,
  clientname text,
  "timestamp" timestamp without time zone NOT NULL,
  errormsg text NOT NULL,
  query text,
  CONSTRAINT client_errors_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE logs.client_errors
  OWNER TO mahuja;
GRANT ALL ON TABLE logs.client_errors TO mahuja;
GRANT INSERT ON TABLE logs.client_errors TO armalive_auto;
