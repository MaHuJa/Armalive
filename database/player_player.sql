-- Table: player.player

-- DROP TABLE player.player;

CREATE TABLE player.player
(
  id bigint NOT NULL DEFAULT nextval('player.playerlist_id_seq'::regclass),
  gameuid character varying(64) NOT NULL,
  first_seen timestamp with time zone NOT NULL DEFAULT now(),
  last_name_seen text NOT NULL,
  CONSTRAINT playerlist_pkey PRIMARY KEY (id),
  CONSTRAINT unique_gameuid UNIQUE (gameuid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE player.player
  OWNER TO mahuja;
GRANT ALL ON TABLE player.player TO mahuja;
GRANT SELECT, UPDATE, INSERT ON TABLE player.player TO armalive_auto;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE player.player TO armalive_admin;
GRANT SELECT ON TABLE player.player TO armalive_reader;

-- Rule: upsert ON player.player

-- DROP RULE upsert ON player.player;

CREATE OR REPLACE RULE upsert AS
    ON INSERT TO player.player
   WHERE (new.gameuid::text IN ( SELECT player.gameuid
           FROM player.player)) DO INSTEAD  UPDATE player.player SET last_name_seen = new.last_name_seen
  WHERE player.gameuid::text = new.gameuid::text;

