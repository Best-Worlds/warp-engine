#!/bin/bash

function layout_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp layout [command] [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help            $(warp_message 'display this help message')"
    warp_message ""

    warp_message_info "Available commands:"
    warp_message ""
    warp_message_info   " flush                 $(warp_message 'flushes cache layout')"

    warp_message ""
    warp_message_info "Help:"
    warp_message " Magento layout service "

    warp_message ""
    warp_message_info "Example:"
    warp_message " warp layout"
    warp_message " warp layout --help"

    warp_message ""
}

function layout_flush_help()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp layout flush [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -S, --static            $(warp_message 'clears layout static content')"
    warp_message_info   " -h, --help              $(warp_message 'display this help message')"
    warp_message ""

    warp_message_info "Available commands:"
    warp_message ""
    warp_message_info   " flush                   $(warp_message 'flushes cache layout')"

    warp_message ""
    warp_message_info "Help:"
    warp_message " Magento layout flush service "

    warp_message ""
    warp_message_info "Example:"
    warp_message " warp layout flush"
    warp_message " warp layout flush --static"
    warp_message " warp layout flush --help"

    warp_message ""
}

function layout_help()
{
    warp_message_info   " layout             $(warp_message 'magento layout service')"
}
