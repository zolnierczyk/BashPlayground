#!/usr/bin/env bash

#From: https://devopsiarz.pl/bash/proper-bash-scripting-training-introduction-practises-shellcheck/

## In case of any error without pipelining - exit immediately
set -e 

## Exit if there is unbound (unused) variable
set -u

## Important variables, even with rm command
working_dir=$1
lock_file_or_dir="/var/lock/good-script-lock-dir"
cmd_locking="mkdir ${lock_file_or_dir}"
cmd_check_lock="test -d ${lock_file_or_dir}"
cmd_unlocking="rm -rf ${lock_file_or_dir}"
cmd_rm="rm -f"
cmd_mv="mv"
cmd_find="find"
cmd_find=(${cmd_find} . -maxdepth 1 -type f -iname "*config*" -printf "%p\n")
prefix="old"
config_file_name="config"
how_many_newest_files_keep=3

## Checks if lock is active
## 1 for true, means is active 
## 0 for false, means there is no active lock
function is_already_running()
{
	local cmd_check_lock=${1}

	${cmd_check_lock} || { 
		return 1
	}

	return 0
}

## Creating lock
function create_lock()
{
	local cmd_locking=${1}

	${cmd_locking} || {
		printf "Cannot create lock\n"
		exit 2
	}
}

## Removing lock
function remove_lock() 
{
	local cmd_unlocking="${1}"
	${cmd_unlocking} || {
		printf "Cannot unlock\n"
		exit 3
	}
}

## Catch some signals like Ctrl+C and clean up
trap 'remove_lock "${cmd_unlocking}"' SIGINT SIGTERM

## Check if another instance is running....
if is_already_running "${cmd_check_lock}" ; then
	printf "Cannot acquire lock (another instance is running?) - exiting.\n"
	exit 1
fi

## Now create lock
create_lock "${cmd_locking}"

## Go to working dir
cd "${working_dir}" || { 
	remove_lock "${cmd_unlocking}"
	printf "Cannot enter to working dir.\n" >&2 ;
	exit 4
}

## Creating config_file_path and time postfix
config_file_path="${working_dir}/${config_file_name}"
time_now=$(date +%s)

if [ -e "${config_file_path}" ]; then
	## mv command mail fail hence we are checking this here
	${cmd_mv} "${config_file_path}" "${prefix}.${config_file_name}.${time_now}" || {
	    printf "Cannot rename %s as %s.%s.%s\n" "${config_file_path}" "${prefix}" "${config_file_name}" "${time_now}" >&2 ;
		remove_lock "${cmd_unlocking}"
		exit 5
	}
fi

printf "%s" "${time_now}" > "${config_file_path}" || {
	printf "Cannot save unixtime %s to %s\n" "${time_now}" "${config_file_path}" >&2 ;
	remove_lock "${cmd_unlocking}"
	exit 6
}

## Removing old and keep X last
how_many=$((how_many_newest_files_keep + 1))

for file in $( "${cmd_find[@]}" | sort -rz | tail -n +${how_many}); do
	## mv command may fail hence are are checking this here
	${cmd_rm} "${file}" || {
		printf "Cannot remove old file: %s\n" "${file}" >&2 ;
		remove_lock "${cmd_unlocking}"
		exit 7
	}
done

sleep 10

## Finishing work
remove_lock "${cmd_unlocking}"