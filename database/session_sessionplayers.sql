-- Table: session.sessionplayers

-- DROP TABLE session.sessionplayers;

CREATE TABLE session.sessionplayers
(
  player integer NOT NULL,
  session integer,
  side character varying(8),
  playername text,
  id serial NOT NULL,
  joined interval,
  "left" interval,
  CONSTRAINT sessionplayers_pkey PRIMARY KEY (id),
  CONSTRAINT sessionplayers_player_fkey FOREIGN KEY (player)
      REFERENCES player.player (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT sessionplayers_session_fkey FOREIGN KEY (session)
      REFERENCES session.session (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE session.sessionplayers
  OWNER TO mahuja;
GRANT ALL ON TABLE session.sessionplayers TO mahuja;
GRANT SELECT, UPDATE, INSERT ON TABLE session.sessionplayers TO armalive_auto;
