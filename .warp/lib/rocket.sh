#!/bin/bash

##
# Initialize environment set by user
#
# Globals:
#   CURRENT_REMOTE_ENV
# Arguments:
#
# Returns:
#   string|false
##
function warp_get_current_remote_env()
{
    if [[ ! -z "${CURRENT_REMOTE_ENV}" ]];
    then
        echo "${CURRENT_REMOTE_ENV}"
    else
        echo false
    fi
}

##
# Initialize environment set by user
#
# Globals:
#   REMOTE_ENVIRONMENTS
#   CURRENT_REMOTE_ENV
# Arguments:
#
# Returns:
#   string
##
function warp_set_current_remote_env()
{
    declare -g CURRENT_REMOTE_ENV

    if [[ -z "$1" ]]
    then
        while : ; do
            environment_number=$( warp_question_ask "Enter a number to choose an environment: $(warp_remote_env_options)" )

            if [[ $environment_number =~ ^[0-9]$ ]] && [[ ! -z ${REMOTE_ENVIRONMENTS[$environment_number]} ]] ; then
                CURRENT_REMOTE_ENV="${REMOTE_ENVIRONMENTS[$environment_number]}"
                break
            else
                warp_message_warn "incorrect value, please enter one of the specified options\n"
            fi;
        done
    else
        CURRENT_REMOTE_ENV=$1
    fi

    warp_validate_remote_env ${CURRENT_REMOTE_ENV}

    warp_message_warn "Setting current environment: $(warp_message_bold ${CURRENT_REMOTE_ENV^})"
    warp_message ""
    sleep 1
}

##
# Retrieves environment options for selection purposes
#
# Globals:
#   REMOTE_ENVIRONMENTS
# Arguments:
#
# Returns:
#   string
##
function warp_remote_env_options()
{
    warp_message ""
    for i in "${!REMOTE_ENVIRONMENTS[@]}";do
        warp_message "  [$(warp_message_ok $i)] ${REMOTE_ENVIRONMENTS[$i]^} ($(warp_remote_env_read_var host ${REMOTE_ENVIRONMENTS[$i]}))"
    done
    warp_message "> "
}

##
# Validates whether the environment selected exists
#
# Globals:
#   REMOTE_ENVIRONMENTS
# Arguments:
#
# Returns:
#   string
##
function warp_validate_remote_env()
{
    if [[ $(array_includes "$1" "${REMOTE_ENVIRONMENTS[@]}") = false ]]
    then
        warp_message_error "Environment $1 doesn't exists"
        exit 0
    fi
}

##
# Connects through SSH Protocol to remote server and executes command
#
# Arguments:
#   COMMAND
# Returns:
#   string
##
function warp_remote_env_connect()
{
    HOST=$(warp_remote_env_read_var host)
    IDENTITY_KEY=$(warp_remote_env_read_var identity_key)

    warp_file_exists_error "${IDENTITY_KEY}" "Missing identity key file under: ${IDENTITY_KEY}. Please review your .env file and change it for the correct one or verify file permissions."

    USER=$(warp_remote_env_read_var user)

    COMMAND="$1"
    OUTPUT="$2"

    if [[ ! "$1" = "test" ]];
    then
        #echo ssh -o "LogLevel=QUIET" -o "SendEnv=TERM" -o "IdentityFile=${IDENTITY_KEY}" "${USER}@${HOST}" ${COMMAND}
        ssh -o "LogLevel=QUIET" -o "SendEnv=TERM" -o "IdentityFile=${IDENTITY_KEY}" "${USER}@${HOST}" ${COMMAND}
    else
        ssh -q -o BatchMode=yes -o "ConnectTimeout=5" -o "SendEnv=TERM" -o "IdentityFile=${IDENTITY_KEY}" "${USER}@${HOST}" 'exit 0'
        RESULT=$?
        if [ ${RESULT} -ne 0 ]; then
            warp_message_error "Unable to connect! Make sure the environment information is correct"
        else
            warp_message_ok "Successfully connected!"
        fi
    fi


}