#!/bin/bash

##
# Creates directory if it doesn't exists
#
# Globals:
#   PROJECTPATH
# Arguments:
#
# Returns:
#   string
##
warp_create_directory_if_not_exists()
{
    ROOT_DIR="${PROJECTPATH}"
    DIR="${ROOT_DIR}/$1"
    if [[ ! -d "${DIR}" ]];
    then
        mkdir "${DIR}"
        warp_grant_directory_permissions "${DIR}"
    fi
}

##
# Grants correct directory permissions to specific directories
#
# Globals:
#
# Arguments:
#
# Returns:
#   string
##
warp_grant_directory_permissions()
{
    chmod ug+rwx $*
}

##
# Checks whether file exists
#
# Globals:
#
# Arguments:
#
# Returns:
#   true|false
##
warp_file_exists()
{
    # Replace 'newflow' symbol with home folder cause it can't read it
    FILE=$(echo "$1" | sed "s/~/\/home\/$(whoami)/g")
    if [[ ! -f "${FILE}" ]];
    then
        echo false
    else
        echo true
    fi
}

##
# Check whether file exists but prints an error and breaks execution on failure
#
# Globals:
#
# Arguments:
#
# Returns:
#   string
##
warp_file_exists_error()
{
    if [[ $(warp_file_exists "$1") = false ]];
    then
        warp_message_error "$2"
        exit 1
    fi
}