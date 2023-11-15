#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/git_help.sh"

function git_rsync()
{
    if ! warp_check_env_file ; then
        warp_message_error "file not found $(basename $ENVIRONMENTVARIABLESFILE)"
        exit
    fi;

    GIT_CONFIG_DIR="$CONFIGFOLDER/git"

    if [ -d "$GIT_CONFIG_DIR" ]
    then
      rsync -azvP "$GIT_CONFIG_DIR" "$PROJECTPATH/.git" > /dev/null
      warp_message "GitHub directory has been synchronized."
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