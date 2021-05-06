#!/bin/sh
#
# docker-runfunc.sh
#
# Allow functions to be accessed from the command line.
#

#
# Source common functions.
#
. docker-common.sh
. docker-config.sh

#
# dr_docker_call_func "$@"
#
dr_docker_call_func() {
	export DOCKER_RUNFUNC="$@"
	local cmd=$1
	shift
#	dc_log 7 "CMD:$cmd ARG:$@"
	$cmd "$@"
	exit 0
}

#
# dr_docker_run_parts dir name
# Read and execute commands from files in the _current_ shell environment.
#
dr_docker_run_parts() {
	for file in $(find $1 -type f -name "$2" -executable 2>/dev/null|sort); do
#		dc_log 7 run_parts: executing $file
		. $file
	done
}

#
# Source files with function definitions.
#
dr_docker_run_parts "$DOCKER_ENTRY_DIR" "1*"

#
# Call function.
#
dr_docker_call_func "$@"
