#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/layout_help.sh"

#######################################

layout_flush()
{
    if [[ "$1" = '--static' ]] || [[ "$1" = '-S' ]];
    then
        warp_container_exec "php" "rm -rf pub/static/frontend/* var/view_preprocessed && bin/magento ca:fl"
    else
        warp_container_exec "php" "bin/magento ca:fl layout block_html translate"
    fi
}

layout_main()
{
    case "$1" in

    flush)
        shift 1
        layout_flush $*
    ;;
    -h | --help)
        layout_help
        exit 1
    ;;
    *)

    ;;

    esac
}