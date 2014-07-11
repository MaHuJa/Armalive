// Once only - if this script gets called from multiple sources, ignore the latter cases.
if (_this getvariable ["armalive_init",false]) exitwith {};
_this setvariable ["armalive_init",true];

_this addEventHandler ["killed",armalive_eh_killed];

_this setvariable ["armalive_uid",getplayeruid _this,true];
_this setvariable ["armalive_side", side _this, true];
// To correctly determine TK for a sideEnemy.
// Note; will need special handling for setCaptive.


