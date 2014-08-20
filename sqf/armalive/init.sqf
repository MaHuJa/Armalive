#define COMPILE(func) func = compilefinal preprocessFileLineNumbers ("armalive\" + #func + ".sqf")
//loki was here :)
// First, report a new session starting
_str =  format ["newmission1;%1;%2",missionName,worldName];
"armalive" callextension _str;
diag_log _str;

// Set up for clients to transfer their info
armalive_cmd = "";
"armalive_cmd" addPublicVariableEventHandler { "armalive" callextension (_this select 1); diag_log text (_this select 1); };
//armalive_send = compilefinal preprocessfile "armalive\armalive_send.sqf";
COMPILE(armalive_send);

// Client should transmit his join message
if (!isDedicated) then {
	format[ "newplayer1;%1;%2;%3;%4",
		getplayeruid player,
		side player,
		time,	// 
		name player
		]
	  call armalive_send;
};

// Compile eventhandlers
COMPILE(armalive_eh_killed);

// Set eventhandlers
COMPILE(armalive_infeh);

//player call armalive_infeh;
// This will also allow kills on AI to be counted. Of course, it needs to be applied to every additional unit ever spawned.
{ if (local _x) then {_x call armalive_infeh;}; } foreach allunits;


