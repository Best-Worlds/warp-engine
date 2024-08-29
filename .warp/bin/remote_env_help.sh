#!/bin/bash

function remote_env_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp remote [command] [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message_info "Available commands:"

    warp_message_info   " info                $(warp_message 'shows remote connections information')"
    warp_message_info   " ssh                 $(warp_message 'connects to remote server through SSH protocol')"
    warp_message_info   " test                $(warp_message 'tests connection establishment with remote server')"

    warp_message ""
    warp_message_info "Help:"
    warp_message " Interacts with remote environments "

    warp_message ""
    warp_message_info "Example:"
    warp_message " warp remote"
    warp_message " warp remote --help"

    warp_message ""
}

function remote_env_info_help()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp remote info"

    warp_message ""
    warp_message_info "Help:"
    warp_message " shows remote connections information' "

    warp_message ""
    warp_message_info "Example:"
    warp_message " warp remote info"

    warp_message ""
}

function remote_env_ssh_help()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp remote ssh [options]"

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -e, --env         $(warp_message 'specify remote environment')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " connects to remote server through SSH protocol "

    warp_message ""
    warp_message_info "Examples:"
    warp_message " warp remote ssh             $(warp_message_warn "(environment selection feature will popup)")"
    warp_message " warp remote ssh -e          $(warp_message_warn "(environment selection feature will popup)")"
    warp_message " warp remote ssh -e stage"

    warp_message ""
}

function remote_env_test_help()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp remote test [options]"

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -e, --env         $(warp_message 'specify remote environment')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " tests connection establishment with remote server "

    warp_message ""
    warp_message_info "Examples:"
    warp_message " warp remote test             $(warp_message_warn "(environment selection feature will popup)")"
    warp_message " warp remote test -e          $(warp_message_warn "(environment selection feature will popup)")"
    warp_message " warp remote test -e stage"

    warp_message ""
}

function remote_env_help()
{
    warp_message_info   " remote             $(warp_message 'remote environments service')"
}