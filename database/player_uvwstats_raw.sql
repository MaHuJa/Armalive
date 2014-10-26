-- Table: player.uvwstats_raw

-- DROP TABLE player.uvwstats_raw;

CREATE TABLE player.uvwstats_raw
(
  session integer NOT NULL,
  player integer NOT NULL,
  unit text NOT NULL,
  vehicle text NOT NULL,
  weapon text NOT NULL,
  totalseconds interval NOT NULL,
  fired integer DEFAULT 0,
  hits text[]
)
WITH (
  OIDS=FALSE
);
ALTER TABLE player.uvwstats_raw
  OWNER TO mahuja;
GRANT ALL ON TABLE player.uvwstats_raw TO mahuja;
GRANT SELECT ON TABLE player.uvwstats_raw TO armalive_reader;
GRANT SELECT, UPDATE, INSERT ON TABLE player.uvwstats_raw TO armalive_auto;
COMMENT ON TABLE player.uvwstats_raw
  IS 'During the mission, the rows are all dumped in here. After the mission is over, they should be collapsed into the cooked table.';
