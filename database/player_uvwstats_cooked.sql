-- Table: player.uvwstats_cooked

-- DROP TABLE player.uvwstats_cooked;

CREATE TABLE player.uvwstats_cooked
(
  session integer NOT NULL,
  player integer NOT NULL,
  unit text NOT NULL,
  vehicle text NOT NULL,
  weapon text NOT NULL,
  totalseconds interval NOT NULL,
  fired integer DEFAULT 0,
  hits text[],
  CONSTRAINT uvwstats_pkey PRIMARY KEY (session, player, unit, vehicle, weapon)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE player.uvwstats_cooked
  OWNER TO mahuja;
