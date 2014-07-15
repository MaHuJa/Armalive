-- Function: player.weaponstats_sum_upsert()

-- DROP FUNCTION player.weaponstats_sum_upsert();

CREATE OR REPLACE FUNCTION player.weaponstats_sum_upsert()
  RETURNS trigger AS
$BODY$begin
perform * from weaponstats_sum where player = new.player and "class" = new.class;
if found then
  update player.weaponstats_sum set 
	totalseconds = totalseconds + new.totalseconds,
	"fired" = "fired" + new.fired,
	vehiclehits = vehiclehits + new.vehiclehits,
	headhits = headhits + new.headhits,
	bodyhits = bodyhits + new.bodyhits,
	leghits = leghits + new.leghits,
	armhits = armhits + new.armhits
	where player = new.player and "class" = new.class;
  return null;
end if;
return new;
end $BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION player.weaponstats_sum_upsert()
  OWNER TO armalive_auto;
COMMENT ON FUNCTION player.weaponstats_sum_upsert() IS 'To have an actual race condition, some server must delay its data transmission enough for the player to switch to another enabled server. Therefore this, despite being single-checked, is considered adequate.';
