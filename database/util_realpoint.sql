-- Function: util.realpoint(real[])

-- DROP FUNCTION util.realpoint(real[]);

CREATE OR REPLACE FUNCTION util.realpoint(o real[])
  RETURNS point AS
'select point($1[0],$1[1])'
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION util.realpoint(real[])
  OWNER TO mahuja;
