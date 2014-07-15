-- Table: player.playersum

-- DROP TABLE player.playersum;

CREATE TABLE player.playersum
(
  playerid integer NOT NULL,
  totalscore integer NOT NULL DEFAULT 0,
  battlescore integer NOT NULL DEFAULT 0,
  otherscore integer NOT NULL DEFAULT 0,
  suicides integer NOT NULL DEFAULT 0,
  weaponkills integer NOT NULL DEFAULT 0,
  deaths integer NOT NULL DEFAULT 0,
  aircrashes integer NOT NULL DEFAULT 0,
  roadkills integer NOT NULL DEFAULT 0,
  civcas integer NOT NULL DEFAULT 0,
  civdmg integer NOT NULL DEFAULT 0,
  teamkills integer NOT NULL DEFAULT 0,
  teamdmg integer NOT NULL DEFAULT 0,
  killed_vehicles integer NOT NULL DEFAULT 0,
  tked_vehicles integer NOT NULL DEFAULT 0,
  killassist integer NOT NULL DEFAULT 0,
  CONSTRAINT playersum_pkey PRIMARY KEY (playerid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE player.playersum
  OWNER TO mahuja;
