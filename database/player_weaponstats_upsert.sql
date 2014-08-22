-- Function: player.weaponstats_upsert()

-- DROP FUNCTION player.weaponstats_upsert();

CREATE OR REPLACE FUNCTION player.weaponstats_upsert()
  RETURNS trigger AS
$BODY$begin
perform * from player.weaponstats where player = new.player and "class" = new.class and session = new.session;
if found then
  update player.weaponstats set 
	totalseconds = totalseconds + new.totalseconds,
	"fired" = "fired" + new.fired,
	vehiclehits = vehiclehits + new.vehiclehits,
	headhits = headhits + new.headhits,
	bodyhits = bodyhits + new.bodyhits,
	leghits = leghits + new.leghits,
	armhits = armhits + new.armhits
	where player = new.player and "class" = new.class and session = new.session;
  return null;
end if;
return new;
end $BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION player.weaponstats_upsert()
  OWNER TO armalive_auto;
COMMENT ON FUNCTION player.weaponstats_upsert() IS 'I don''t care enough about this to double-check it. If a piece of data is lost, then meh, who cares.';
