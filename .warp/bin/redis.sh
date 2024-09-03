#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/redis_help.sh"

function redis_info()
{

    if ! warp_check_env_file ; then
        warp_message_error "file not found $(basename $ENVIRONMENTVARIABLESFILE)"
        exit
    fi; 

    REDIS_CACHE_VERSION=$(warp_env_read_var REDIS_CACHE_VERSION)
    REDIS_CACHE_CONF=$(warp_env_read_var REDIS_CACHE_CONF)

    REDIS_SESSION_VERSION=$(warp_env_read_var REDIS_CACHE_VERSION)
    REDIS_SESSION_CONF=$(warp_env_read_var REDIS_CACHE_CONF)

    REDIS_FPC_VERSION=$(warp_env_read_var REDIS_CACHE_VERSION)
    REDIS_FPC_CONF=$(warp_env_read_var REDIS_CACHE_CONF)

    if [ ! -z "$REDIS_CACHE_VERSION" ]
    then
        warp_message ""
        warp_message_info "* Redis Cache"
        warp_message "Redis Version:              $(warp_message_info $REDIS_CACHE_VERSION)"
        warp_message "Host:                       $(warp_message_info 'redis-cache')"
        warp_message "Port (container):           $(warp_message_info '6379')"
        warp_message ""
    fi

    if [ ! -z "$REDIS_SESSION_VERSION" ]
    then
        warp_message ""
        warp_message_info "* Redis Session"
        warp_message "Redis version:              $(warp_message_info $REDIS_SESSION_VERSION)"
        warp_message "Host:                       $(warp_message_info 'redis-session')"
        warp_message "Port (container):           $(warp_message_info '6379')"
        warp_message ""
    fi

    if [ ! -z "$REDIS_FPC_VERSION" ]
    then
        warp_message ""
        warp_message_info "* Redis Fpc"
        warp_message "Redis version:              $(warp_message_info $REDIS_FPC_VERSION)"
        warp_message "Host:                       $(warp_message_info 'redis-fpc')"
        warp_message "Port (container):           $(warp_message_info '6379')"
        warp_message ""
    fi

}

function redis_cli()
{
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        redis_cli_help_usage
        exit 1
    fi;

    warp_check_is_running_error
    redis_validate_type "$1"
    warp_container_exec redis-$1 "redis-cli $2" --root $3
}

function redis_monitor()
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        redis_monitor_help_usage
        exit 1
    fi;

    warp_check_is_running_error
    redis_validate_type "$1"
    warp_container_exec redis-$1 "redis-cli -c 'monitor'" --root
}

function redis_validate_type()
{
    REDIS_TYPES=( "fpc" "session" "cache" )

    if [[ ! $(array_includes "$1" "${REDIS_TYPES[@]}") = true ]];
    then
        warp_message_error "Please, choose a valid option:"
        warp_message_error "fpc, session, cache"
        warp_message_error "for more information please run: warp redis cli --help"
        exit 1
    fi
}

function redis_main()
{
    case "$1" in
        cli)
            shift 1
            redis_cli $* "" "--no-output"
        ;;
        monitor)
            shift 1
            redis_monitor $*
        ;;
        info)
            redis_info
        ;;
        flush)
            shift 1
            redis_cli $* 'FLUSHALL'
        ;;
        -h | --help)
            redis_help_usage
        ;;
        *)            
            redis_help_usage
        ;;
    esac
}