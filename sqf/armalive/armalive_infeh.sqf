_this addEventHandler ["killed",armalive_eh_killed];

_this setvariable ["armalive_uid",getplayeruid _this,true];
_this setvariable ["armalive_side", side _this, true];
// To correctly determine TK for a sideEnemy.
// Note; will need special handling for setCaptive.


