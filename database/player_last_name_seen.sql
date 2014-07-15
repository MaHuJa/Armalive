-- View: player.last_name_seen

-- DROP VIEW player.last_name_seen;

CREATE OR REPLACE VIEW player.last_name_seen AS 
 SELECT playername.playerid, first_value(playername.name) OVER (PARTITION BY playername.playerid ORDER BY playername.lastseen DESC) AS name
   FROM player.playername;

ALTER TABLE player.last_name_seen
  OWNER TO mahuja;
