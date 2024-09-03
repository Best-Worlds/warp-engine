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

    warp_message_info   " download            $(warp_message 'downloads files/directories from remote environment')"
    warp_message_info   " info                $(warp_message 'shows remote connections information')"
    warp_message_info   " ssh                 $(warp_message 'connects to remote environment through SSH protocol')"
    warp_message_info   " test                $(warp_message 'tests connection establishment with remote environment')"
    warp_message_info   " upload              $(warp_message 'uploads files/directories to remote environment')"

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

function remote_env_download_help()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp remote download [options]"

    warp_message ""
    warp_message_info "Arguments:"
    warp_message_info   " [REMOTE_SOURCE_FILE]       $(warp_message 'remote source file to download')"
    warp_message_info   " [TARGET_DIRECTORY]         $(warp_message 'target local download directory')"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -e, --env                  $(warp_message 'specify remote environment')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " downloads file/directory from remote server through SCP protocol "
    warp_message " if you want to use '~' symbol, the full string must be closed between double quotes "

    warp_message ""
    warp_message_info "Examples:"
    warp_message " warp remote download                                                     $(warp_message_warn "(environment selection feature will popup & another for the arguments)")"
    warp_message " warp remote download [REMOTE_SOURCE_FILE] [TARGET_DIRECTORY]             $(warp_message_warn "(environment selection feature will popup)")"
    warp_message " warp remote download [REMOTE_SOURCE_FILE] [TARGET_DIRECTORY] -e          $(warp_message_warn "(environment selection feature will popup)")"
    warp_message " warp remote download [REMOTE_SOURCE_FILE] [TARGET_DIRECTORY] -e stage"

    warp_message ""
}

function remote_env_upload_help()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp remote upload [options]"

    warp_message ""
    warp_message_info "Arguments:"
    warp_message_info   " [LOCAL_SOURCE_FILE]           $(warp_message 'local source file to upload')"
    warp_message_info   " [REMOTE_TARGET_DIRECTORY]     $(warp_message 'remote target upload directory')"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -e, --env                     $(warp_message 'specify remote environment')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " uploads file to remote server through SCP protocol "
    warp_message " if you want to use '~' symbol, the full string must be closed between double quotes "

    warp_message ""
    warp_message_info "Examples:"
    warp_message " warp remote upload                                                           $(warp_message_warn "(environment selection feature will popup & another for the arguments)")"
    warp_message " warp remote upload [LOCAL_SOURCE_FILE] [REMOTE_TARGET_DIRECTORY]             $(warp_message_warn "(environment selection feature will popup)")"
    warp_message " warp remote upload [LOCAL_SOURCE_FILE] [REMOTE_TARGET_DIRECTORY] -e          $(warp_message_warn "(environment selection feature will popup)")"
    warp_message " warp remote upload [LOCAL_SOURCE_FILE] [REMOTE_TARGET_DIRECTORY] -e stage"

    warp_message ""
}

function remote_env_test_help()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp remote test [options]"

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -e, --env             $(warp_message 'specify remote environment')"
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