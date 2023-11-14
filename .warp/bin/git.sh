#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/git_help.sh"

function git_rsync()
{
    if ! warp_check_env_file ; then
        warp_message_error "file not found $(basename $ENVIRONMENTVARIABLESFILE)"
        exit
    fi;

    GIT_OVERRIDE_DIR="$PROJECTPATH/.git_override"
    echo $GIT_OVERRIDE_DIR

    if [ -d "$GIT_OVERRIDE_DIR" ]
    then
      rsync -azvP --exclude "logs" ./.git_override/ ./.git
      warp_message ""
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