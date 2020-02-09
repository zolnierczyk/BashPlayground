#!/usr/bin/env bash

# For cross compilation purpose we need to have target file system
# available. There are multiple ways to do it:
# - cross compile vs sd card with system
# - cross compile vs mounted image of sd card with system
# - cross compile vs folder where target file system was build (in case of yocto)
# Or we can make ordinary copy of traget file system on our disk. 
# And exactly that this scripts do. What is very important is fact that
# at last step in script we are recreating symlinks that are pointing to 
# our local folder not to root file system.

set -e 
set -u
#set -x

## Important variables
lock_file_or_dir="/var/lock/copy-targetfs-lock-dir"
cmd_locking="mkdir ${lock_file_or_dir}"
cmd_check_lock="test -d ${lock_file_or_dir}"
cmd_unlocking="rm -rf ${lock_file_or_dir}"

target_fs=""
copy_into=""
remove_old="no"

target_fs_opt="--targetfs"
target_fs_opt_short="-t"
copy_into_opt="--copy-into"
copy_into_opt_short="-c"
remove_old_opt="--remove-old"
remove_old_opt_short="-r"

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

function display_help()
{
    printf "Please define options: \n"
    printf -- "${target_fs_opt} or ${target_fs_opt_short} PATH \t to define targetfs source \n"
    printf -- "${copy_into_opt} or ${copy_into_opt_short} PATH \t to define to which folder copy into \n"
    printf -- "${remove_old_opt} or ${remove_old_opt_short} PATH \t remove all files from copy into folder before copy \n"
}

if [[ $# -eq 0 ]]; then
    printf "Not enugh arguments.\n"
    display_help
    exit 1
fi

while [[ $# -ne 0 ]]; do
    case "$1" in
        "${target_fs_opt}"|"${target_fs_opt_short}")
            shift  
            if [[ $# -eq 0 ]]; then 
                printf "Not enugh arguments\n"; 
                display_help
                exit 1; 
            fi
            target_fs=$1
            printf "Targetfs: %s \n" ${target_fs} 
            ;;
        "${copy_into_opt}"|"${copy_into_opt_short}") 
            shift
            if [[ $# -eq 0 ]]; then 
                printf "Not enugh arguments\n"; 
                display_help
                exit 1; 
            fi
            copy_into=$1
            printf "Copy into: %s \n" ${copy_into} 
            ;;
        "${remove_old_opt}"|"${remove_old_opt_short}") 
            remove_old="yes"
            printf "Old files from copy int will be removed\n"
            ;;
        *)  
            printf "Command unrecognized\n"
            display_help
            exit 1
            ;;
    esac
    shift
done

if [[ ${target_fs} == ${copy_into} ]] ; then
    printf "Targetfs and copy into folders cant be the same.\n"
    exit 2
fi

if [[ ! -d ${target_fs} ]] ; then
    printf "Targetfs is not valid path to folder.\n"
    exit 2
fi

if [[ ! -d ${copy_into} ]] ; then
    printf "Copy into is not valid path to folder.\n"
    exit 2
fi

if is_already_running "${cmd_check_lock}" ; then
	printf "Cannot acquire lock (another instance is running?) - exiting. ${lock_file_or_dir} \n"
	exit 1
fi

create_lock "${cmd_locking}"

if [[ ${remove_old} == "yes" ]] ; then
    rm -rf ${copy_into}/* || {
        printf "Error during removing old files - exiting.\n"
        remove_lock "${cmd_unlocking}"
        exit 3
    }
fi 

printf "Copying opt folder.\n"
rsync -a ${target_fs}/opt  ${copy_into} || {
        printf "Error copying opt folder.\n"
        remove_lock "${cmd_unlocking}"
        exit 3
    }
# sudo cp -rf $1/opt $ROOT_PATH

printf "Copying lib folder.\n"
# sudo cp -rf $1/lib $ROOT_PATH
rsync -a ${target_fs}/lib  ${copy_into} || {
        printf "Error copying lib folder.\n"
        remove_lock "${cmd_unlocking}"
        exit 3
    }

printf "Copying usr folder.\n"
# sudo cp -rf $1/usr $ROOT_PATH
rsync -a ${target_fs}/usr  ${copy_into} || {
        printf "Error copying usr folder.\n"
        remove_lock "${cmd_unlocking}"
        exit 3
    }

printf "Updating symlinks to contain full path to new folder.\n"
sudo find ${copy_into} -lname '/*' -exec sh -c "ln -snf ${copy_into}"'$(readlink "$0") "$0" ' {} \;

remove_lock "${cmd_unlocking}"


