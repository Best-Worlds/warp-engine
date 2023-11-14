#!/bin/bash

function git_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp git [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " rsync              $(warp_message 'Synchronize git folder (hooks)')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " github actions:"
    warp_message " Synchronize .git_override folder with original .git directory "

    warp_message ""
    warp_message_info "Example:"
    warp_message " warp git rsync"

    warp_message ""

}

function git_help()
{
    warp_message_info   " git                $(warp_message 'github actions')"
}
