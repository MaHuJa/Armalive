-- Table: player.weaponstats

DROP TABLE player.weaponstats;

CREATE TABLE player.weaponstats
(
  session integer NOT NULL,
  player integer NOT NULL,
  class character varying(40) NOT NULL,
  totalseconds numeric DEFAULT 0,
  fired integer DEFAULT 0,
  vehiclehits integer DEFAULT 0,
  headhits integer DEFAULT 0,
  bodyhits integer DEFAULT 0,
  leghits integer DEFAULT 0,
  armhits integer DEFAULT 0,
  CONSTRAINT weaponstats_pkey PRIMARY KEY (session, player, class)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE player.weaponstats
  OWNER TO mahuja;
