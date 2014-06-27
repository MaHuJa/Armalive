if (isServer) then {
	"armalive" callextension _this;
} else {
	armalive_cmd = _this;
	publicVariableServer "armalive_cmd";
}
