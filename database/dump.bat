set PATH=%PATH%;C:\Program Files (x86)\pgAdmin III\1.18

set PGHOST=master1.armalive.com
set PGDATABASE=armalive_master
set PGUSER=mahuja

rem pg_dumpall -g -f databaseGlobals.sqf
pg_dump -s -f databaseSchema.sqf
