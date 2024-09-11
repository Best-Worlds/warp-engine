#!/bin/bash

function update_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp update [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -c, --config       $(warp_message 'refresh env configurations')"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " -f, --force        $(warp_message 'force update without confirmation')"
    warp_message_info   " -i, --images       $(warp_message 'update images from hub registry docker')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Update the framework to the latest version"

    warp_message ""

}

function update_help()
{
    warp_message_info   " update             $(warp_message 'update warp framework')"

}
