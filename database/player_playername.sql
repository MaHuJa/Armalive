-- Table: player.playername

-- DROP TABLE player.playername;

CREATE TABLE player.playername
(
  playerid integer NOT NULL,
  name text NOT NULL,
  lastseen timestamp with time zone NOT NULL DEFAULT now(),
  firstseen timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT playername_pkey PRIMARY KEY (playerid, name),
  CONSTRAINT playername_playerid_fkey FOREIGN KEY (playerid)
      REFERENCES player.player (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE player.playername
  OWNER TO mahuja;
GRANT ALL ON TABLE player.playername TO mahuja;
GRANT SELECT ON TABLE player.playername TO armalive_reader;
GRANT SELECT, UPDATE, INSERT ON TABLE player.playername TO armalive_auto;
