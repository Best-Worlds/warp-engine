#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/ps_help.sh"

function ps_command() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        ps_help_usage 
        exit 1
    fi;

    warp_check_is_running_error

    docker-compose -f $DOCKERCOMPOSEFILE ps
}

function ps_main()
{
    case "$1" in
        ps)
            shift 1
            ps_command $*
        ;;

        -h | --help)
            ps_help_usage
        ;;

        *)            
            ps_help_usage
        ;;
    esac
}