#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/git_help.sh"

function git_rsync()
{
    if ! warp_check_env_file ; then
        warp_message_error "file not found $(basename $ENVIRONMENTVARIABLESFILE)"
        exit
    fi;

    if [ $(warp_check_is_running) = false ]; then
        warp_message_error "The containers are not running"
        warp_message_error "please, first run warp start"

        exit 0;
    fi

    GIT_CONFIG_DIR="$CONFIGFOLDER/git"

    if [ -d "$GIT_CONFIG_DIR" ]
    then
        rsync -azvP "$GIT_CONFIG_DIR/" "$PROJECTPATH/.git/" > /dev/null
        chmod -R 755 "$PROJECTPATH/.git/hooks"
    fi

}

function git_main()
{

    case "$1" in
        rsync)
            git_rsync
        ;;

        -h | --help)
            git_help_usage
        ;;

        *)
            git_help_usage
        ;;
    esac
}