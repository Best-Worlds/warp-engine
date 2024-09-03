#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/remote_env_help.sh"

##
# Shows remote environments information
#
# Globals:
#   REMOTE_ENVIRONMENTS
# Arguments:
#
# Returns:
#   string
##
function remote_env_info()
{
    if ! warp_check_env_file ; then
        warp_message_error "file not found $(basename $ENVIRONMENTVARIABLESFILE)"
        exit
    fi;

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        remote_env_info_help
        exit 1
    fi;

    if [[ ! -z "${REMOTE_ENVIRONMENTS[@]}" ]];
    then
        warp_message ""
        warp_message_info "* Remote Environments"
        warp_message ""

        remote_env_get_info

        warp_message_warn " - You can verify if your remote connections are working ok by executing: $(warp_message_bold) warp remote test"
        warp_message ""
    fi
}

##
# Access to remote server through SSH protocol
#
# Globals:
#
# Arguments:
#
# Returns:
#   string
##
function remote_env_ssh()
{
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        remote_env_ssh_help
        exit 1
    fi;

    warp_remote_env_connect
}

##
# Access to remote server and execute download/upload action
#
# Globals:
#
# Arguments:
#
# Returns:
#   string
##
function remote_env_scp()
{
    ACTION="$1"
    shift 1

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        remote_env_"${ACTION}"_help
        exit 1
    fi;

    if [[ -z "$*" ]];
    then
        FROM_ARGUMENT_NAME=$(if [[ "${ACTION}" = "download" ]]; then echo "remote source file"; else echo "local source file"; fi)
        while : ; do
            FROM_ARGUMENT_RESPONSE=$(warp_question_ask "Set the ${FROM_ARGUMENT_NAME}: ")
            if [[ -z ${FROM_ARGUMENT_RESPONSE} ]];
            then
                warp_message_error "The value cannot be empty"
            else
                break
            fi
        done

        TARGET_ARGUMENT_NAME=$(if [[ "${ACTION}" = "download" ]]; then echo "local target directory $(warp_message_info "[.]")"; else echo "remote target directory $(warp_message_info "[~]")"; fi)
        while : ; do
            TARGET_ARGUMENT_RESPONSE=$(warp_question_ask_default "Set the ${TARGET_ARGUMENT_NAME}: " ".")
            if [[ -z ${TARGET_ARGUMENT_RESPONSE} ]];
            then
                warp_message_error "The value cannot be empty"
            else
                break
            fi
        done

        warp_remote_env_file_transfer "${ACTION}" "${FROM_ARGUMENT_RESPONSE}" "${TARGET_ARGUMENT_RESPONSE}"
    else
        warp_remote_env_file_transfer "${ACTION}" $*
    fi
}

##
# Test remote connection status
#
# Globals:
#
# Arguments:
#
# Returns:
#   string
##
function remote_env_test()
{
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        remote_env_test_help
        exit 1
    fi;

    warp_remote_env_connect 'test'
}

##
# Prints remote environments relevant information
#
# Globals:
#   REMOTE_ENVIRONMENTS
# Arguments:
#
# Returns:
#   string
##
function remote_env_get_info()
{
    for i in "${!REMOTE_ENVIRONMENTS[@]}";do
        warp_message_warn "$((i+1))- ${REMOTE_ENVIRONMENTS[$i]^}"
        warp_message ""
        warp_message "Host:                       $(warp_message_info $(warp_remote_env_read_var 'host' ${REMOTE_ENVIRONMENTS[$i]}))"
        warp_message "Identity Key:               $(warp_message_info $(warp_remote_env_read_var 'identity_key' ${REMOTE_ENVIRONMENTS[$i]}))"
        warp_message "User:                       $(warp_message_info $(warp_remote_env_read_var 'user' ${REMOTE_ENVIRONMENTS[$i]}))"
        warp_message "Root Directory:             $(warp_message_info $(warp_remote_env_read_var 'root_dir' ${REMOTE_ENVIRONMENTS[$i]}))"
        warp_message ""
    done;
}

##
# Main command to redirect to specific one
#
# Globals:
#
# Arguments:
#
# Returns:
#   string
##
function remote_env_main()
{
    # Prevent environment selection for help or info actions
    HELP_PARAM=false
    INFO_PARAM=false
    for param in $*; do
        if [[ "$param" = '-h' ]] || [[ "$param" = '--help' ]]
        then
            HELP_PARAM=true
        fi
        if [[ "$param" = 'info' ]]
        then
            INFO_PARAM=true
        fi
    done

    if [[ $(warp_get_current_remote_env) = false ]] && [[ ${HELP_PARAM} = false ]] &&  [[ ${INFO_PARAM} = false ]] && [[ ! -z "$1" ]];
    then
        warp_set_current_remote_env
    fi

    case "$1" in
        download | upload)
            remote_env_scp $*
        ;;
        info)
            shift 1
            remote_env_info $*
        ;;
        ssh)
            shift 1
            remote_env_ssh $*
        ;;
        test)
            shift 1
            remote_env_test $*
        ;;
        -h | --help)
            remote_env_help_usage
        ;;
        *)
            remote_env_help_usage
        ;;
    esac
}