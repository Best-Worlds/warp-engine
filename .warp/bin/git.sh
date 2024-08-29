#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/git_help.sh"

function git_rsync()
{
    if ! warp_check_env_file ; then
        warp_message_error "file not found $(basename $ENVIRONMENTVARIABLESFILE)"
        exit
    fi;

    warp_check_is_running_error

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