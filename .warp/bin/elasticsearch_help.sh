#!/bin/bash

function elasticsearch_help_usage()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp elasticsearch [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " elasticsearch service uses ports 9200 and 9300 inside the containers"
    warp_message " to use this service you must modify localhost:9200 by elasticsearch:9200 in the project"
    warp_message ""

}

function elasticsearch_indexes_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp elasticsearch indexes [arguments] [options] "
    warp_message ""

    warp_message ""
    warp_message_info "Arguments:"
    warp_message_info   " [index_prefix]         $(warp_message 'index prefix with wildcard (*) at the end')"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -w, --watch            $(warp_message 'executes watch command to visualize progress')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " allows to visualize elasticsearch indexes information"
    warp_message " it can be filtered through index prefix "
    warp_message " by using the watch option, progress can be verified when reindex is being executed "

    warp_message ""

    warp_message_info "Example:"
    warp_message " warp elasticsearch indexes"
    warp_message " warp elasticsearch indexes magento2_local"
    warp_message " warp elasticsearch indexes magento2_local -w [--watch]"
    warp_message ""

}

function elasticsearch_help()
{
    warp_message_info   " elasticsearch      $(warp_message 'service of elasticsearch')"
}
