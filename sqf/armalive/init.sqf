#define COMPILE(func) func = compilefinal preprocessfile "armalive\##func##.sqf"

// First, report a new session starting
"armalive" callextension format ["newmission1;%1",missionName];

// Set up for clients to transfer their info
armalive_cmd = "";
"armalive_cmd" addPublicVariableEventHandler { "armalive" callextension (_this select 1); };
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
player call armalive_infeh;

