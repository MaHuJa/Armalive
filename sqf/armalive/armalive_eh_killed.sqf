
_victim = _this select 0;
_killer = _this select 1;

_victim_uid = _victim getvariable "armalive_uid";
_victim_side = _victim getvariable "armalive_side";

if (_victim == _killer) exitwith {
	private "_type";
	if (getOxygenRemaining _victim <= 0) then {
		// Drowned
		format[
			"drowned1;%1;%2;%3;%4;%5",
			time,
			_victim_uid,
			getposasl _victim,
			typeof _victim,
			_victim_side
		] call armalive_send;
		{	_victim call _x;
		} foreach (missionnamespace getvariable ["armalive_hook_drowned",[]];
	} else {
		format[
			"suicide1;%1;%2;%3;%4;%5",
			time,
			_victim_uid,
			getposasl _victim,
			typeof _victim,
			_victim_side
		] call armalive_send;
		{	_victim call _x;
		} foreach (missionnamespace getvariable ["armalive_hook_suicide",[]];
	};
};

// bstats uses if (!(_k isKindOf "Man") && (!(_dUnit isKindOf "Man") || (_dUnit == _v))) exitWith {
if (isnull _killer || !(_killer isKindOf "Man")) exitwith {
	format[
		"died1;%1;%2;%3;%4;%5",
		time,
		_victim_uid,
		getposasl _victim,
		typeof _victim,
		_victim_side
	] call armalive_send;
	{	_victim call _x;
	} foreach (missionnamespace getvariable ["armalive_hook_died",[]];
};

_killer_uid = _killer getvariable "armalive_uid";
_killer_side = _killer getvariable "armalive_side";

if (_killer iskindof "Man") exitwith {

	_isTK = "not";
	if (_victim_side == _killer_side) then {
		_isTK = "teamkill";
	};

	format ["inf_killed1;%1;%2;%3;%4;%5;%6;%7;%8;%9;%10;%11", 
		time,
		_victim_uid,
		getposasl _victim,
		typeof _victim,
		_victim_side,
		
		_killer_uid,
		getposasl _killer,
		typeof _killer,
		_killer_side,
		
		currentweapon _killer, // TODO: bstats parity
		_isTK
	] call armalive_send;
	{	[_victim, _killer, _isTK] call _x;
	} foreach (missionnamespace getvariable ["armalive_hook_kill",[]];
};



