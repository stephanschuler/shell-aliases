#!/bin/zsh


function _xdebugStart() {
	local xdebugConfig
	declare -A xdebugConfig

	xdebugConfig[idekey]="PHPSTORM"
	xdebugConfig[remote_enable]="1"
	xdebugConfig[remote_host]="127.0.0.1"
	xdebugConfig[remote_mode]="jit"
	xdebugConfig[max_nesting_level]="2048"

	export XDEBUG_CONFIG=""
	local key
	local value
	for key value in ${(kv)xdebugConfig}; do
		export XDEBUG_CONFIG="$XDEBUG_CONFIG$key=$value "
	done

	export SERVER_NAME="$(pwd | cut -d '/' -f 6-7 | tr / .).local"
	export SERVER_PORT=80

	if [[ "$SERVER_NAME" = ".local" ]];
	then
		_xdebugStop
		return
	fi

	echo "Start Xdebug as http://$SERVER_NAME:$SERVER_PORT/"
}
alias xdebug-start=_xdebugStart


function _xdebugStop() {
	unset SERVER_NAME
	unset SERVER_PORTs
	unset XDEBUG_CONFIG
}
alias xdebug-stop=_xdebugStop
