-- Table: player.weaponstats_sum

-- DROP TABLE player.weaponstats_sum;

CREATE TABLE player.weaponstats_sum
(
  player integer NOT NULL,
  class character varying(40) NOT NULL,
  totalseconds numeric NOT NULL DEFAULT 0,
  fired integer NOT NULL DEFAULT 0,
  vehiclehits integer NOT NULL DEFAULT 0,
  headhits integer NOT NULL DEFAULT 0,
  bodyhits integer NOT NULL DEFAULT 0,
  leghits integer NOT NULL DEFAULT 0,
  armhits integer NOT NULL DEFAULT 0,
  CONSTRAINT weaponstats_sum_pkey PRIMARY KEY (player, class)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE player.weaponstats_sum
  OWNER TO mahuja;

-- Trigger: upsert on player.weaponstats_sum

-- DROP TRIGGER upsert ON player.weaponstats_sum;

CREATE TRIGGER upsert
  BEFORE INSERT
  ON player.weaponstats_sum
  FOR EACH ROW
  EXECUTE PROCEDURE player.weaponstats_sum_upsert();

