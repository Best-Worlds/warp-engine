#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/logs_help.sh"

function logs_command() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        logs_help_usage 
        exit 1
    fi;

    warp_check_is_running_error

    docker-compose -f $DOCKERCOMPOSEFILE logs $*
}

function logs_main()
{
    case "$1" in
        logs)
            shift 1
            logs_command $*
        ;;

        -h | --help)
            logs_help_usage
        ;;

        *)            
            logs_help_usage
        ;;
    esac
}