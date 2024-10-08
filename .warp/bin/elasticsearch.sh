#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/elasticsearch_help.sh"

function elasticsearch_info()
{

    if ! warp_check_env_file ; then
        warp_message_error "file not found $(basename $ENVIRONMENTVARIABLESFILE)"
        exit
    fi; 

    ES_HOST="elasticsearch"
    ES_VERSION=$(warp_env_read_var ES_VERSION)
    ES_MEMORY=$(warp_env_read_var ES_MEMORY)

    if [ ! -z "$ES_VERSION" ]
    then
        warp_message ""
        warp_message_info "* Elasticsearch"
        warp_message "Version:                    $(warp_message_info $ES_VERSION)"
        warp_message "Host:                       $(warp_message_info $ES_HOST)"
        warp_message "Ports (container):          $(warp_message_info '9200, 9300')"
        warp_message "Data:                       $(warp_message_info $PROJECTPATH/.warp/docker/volumes/elasticsearch)"
        warp_message "Memory:                     $(warp_message_info $ES_MEMORY)"

        warp_message ""
    fi

}

function elasticsearch_connect_ssh()
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        php_ssh_help
        exit 1
    fi;

    warp_check_is_running_error

    if [ "$1" = "--root" ]
    then
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot elasticsearch bash -c "export COLUMNS=`tput cols`; export LINES=`tput lines`; exec bash"
    else
        docker-compose -f $DOCKERCOMPOSEFILE exec elasticsearch bash -c "export COLUMNS=`tput cols`; export LINES=`tput lines`; exec bash"
    fi;
}

function elasticsearch_indexes()
{
    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ]
    then
        elasticsearch_indexes_help_usage
        exit 1
    fi;

    warp_check_is_running_error

    if [[ ! -z $* ]];then
        if [ "$1" = "-w" ] || [ "$1" = "--watch" ]
        then
            watch="watch "
            indexes_prefix=""
        else
            indexes_prefix="$1*"
            if [[ "$2" = "-w" ]] || [[ "$2" = "--watch" ]];
            then
                watch="watch "
            fi
        fi;
    else
        watch=""
        indexes_prefix=""
    fi

    docker-compose -f $DOCKERCOMPOSEFILE exec elasticsearch bash -c "export COLUMNS=`tput cols`; export LINES=`tput lines`;${watch}curl -XGET elasticsearch:9200/_cat/indices/${indexes_prefix}?v"
}

function elasticsearch_command()
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        elasticsearch_help_usage 
        exit 1
    fi;

}

function elasticsearch_main()
{
    case "$1" in
        info)
            elasticsearch_info
        ;;

        ssh)
            shift 1
            elasticsearch_connect_ssh $*
        ;;

        indexes)
            shift 1
            elasticsearch_indexes $*
        ;;

        -h | --help)
            elasticsearch_help_usage
        ;;

        *)
		    elasticsearch_help_usage
        ;;
    esac
}
