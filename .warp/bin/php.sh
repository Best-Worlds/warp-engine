#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/php_help.sh"

function php_info()
{

    if ! warp_check_env_file ; then
        warp_message_error "file not found $(basename $ENVIRONMENTVARIABLESFILE)"
        exit
    fi; 

    PHP_VERSION=$(warp_env_read_var PHP_VERSION)

    if [ ! -z "$PHP_VERSION" ]
    then
        warp_message ""
        warp_message_info "* PHP"
        warp_message "Version:                    $(warp_message_info $PHP_VERSION)"
        warp_message "Logs:                       $(warp_message_info $PROJECTPATH/.warp/docker/volumes/php-fpm/logs)"
        warp_message "Xdebug file:                $(warp_message_info $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini)"
        warp_message "php.ini file:               $(warp_message_info $PROJECTPATH/.warp/docker/config/php/php.ini)"
        warp_message "Cron file:                  $(warp_message_info $PROJECTPATH/.warp/docker/config/crontab/cronfile)"
        warp_message ""
        warp_message_warn " - In order to configure Xdebug, please check FAQs here: $(warp_message_bold 'http://ct.summasolutions.net/warp-engine/?#anchorFAQs')"
        
        warp_message ""
    fi
}

function php_connect_ssh() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        php_ssh_help 
        exit 1
    fi;

    if [ $(warp_check_is_running) = false ]; then
        warp_message_error "The containers are not running"
        warp_message_error "please, first run warp start"

        exit 1;
    fi

    if [ "$1" = "--root" ]
    then
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "export COLUMNS=`tput cols`; export LINES=`tput lines`; exec bash"
    else
        docker-compose -f $DOCKERCOMPOSEFILE exec php bash -c "export COLUMNS=`tput cols`; export LINES=`tput lines`; exec bash"
    fi;    
}

function php_switch() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ]
    then
        php_switch_help 
        exit 1
    fi;

    if [ $(warp_check_is_running) = true ]; then
        warp_message_error "The containers are running"
        warp_message_error "please, first run warp stop --hard"

        exit 1;
    fi

    PHP_VERSION_CURRENT=$(warp_env_read_var PHP_VERSION)
    warp_message_info2 "You current PHP version is: $PHP_VERSION_CURRENT"

    if [ $PHP_VERSION_CURRENT = $1 ]
    then
        warp_message_info2 "the selected version is the same as the previous one, no changes will be made"
        warp_message_warn "for help run: $(warp_message_bold './warp php switch --help')"
    else
        php_version=$1
        case $php_version in
        '5.6-fpm'|'7.0-fpm'|'7.1-fpm'|'7.2-fpm'|'7.3-fpm'|'7.4-fpm'|'7.1.17-fpm'|'7.1.26-fpm'|'7.2.24-fpm')
            warp_message_info2 "PHP new version selected: $php_version"
        ;;
        *)
            warp_message_info2 "Selected: $php_version, the available versions are 5.6-fpm, 7.0-fpm, 7.1-fpm, 7.2-fpm, 7.3-fpm, 7.4-fpm, 7.1.17-fpm, 7.1.26-fpm, 7.2.24-fpm"
            warp_message_warn "for help run: $(warp_message_bold './warp php switch --help')"
            exit 1;
        ;;
        esac
        
        if [ -d $CONFIGFOLDER/php ]
        then
            warp_message "* reset php configurations files $(warp_message_ok [ok])"
            rm  -rf $CONFIGFOLDER/php 2> /dev/null
        fi

        warp_message "* creating configurations files $(warp_message_ok [ok])"
        # copy base files
        cp -R $PROJECTPATH/.warp/setup/php/config/php $CONFIGFOLDER/php

        warp_message "* setting samples files $(warp_message_ok [ok])"
        # helper create .sample files
        . "$WARPFOLDER/setup/php/php-helper.sh"

        # Change .env and .env.sample
        warp_message "* change environment file $(warp_message_ok [ok])"                

        PHP_VERSION_OLD="PHP_VERSION=$PHP_VERSION_CURRENT"
        PHP_VERSION_NEW="PHP_VERSION=$php_version"

        cat $ENVIRONMENTVARIABLESFILE | sed -e "s/$PHP_VERSION_OLD/$PHP_VERSION_NEW/" > "$ENVIRONMENTVARIABLESFILE.warp_tmp"
        mv "$ENVIRONMENTVARIABLESFILE.warp_tmp" $ENVIRONMENTVARIABLESFILE

        cat $ENVIRONMENTVARIABLESFILESAMPLE | sed -e "s/$PHP_VERSION_OLD/$PHP_VERSION_NEW/" > "$ENVIRONMENTVARIABLESFILESAMPLE.warp_tmp"
        mv "$ENVIRONMENTVARIABLESFILESAMPLE.warp_tmp" $ENVIRONMENTVARIABLESFILESAMPLE

        # creating ext-xdebug.ini
        if  [ ! -f $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini ] && [ -f $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample ]
        then
            cp $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini

            case "$(uname -s)" in
                Darwin)

                IP_XDEBUG_MAC="10.254.254.254"
                IP_XDEBUG_LINUX="172.17.0.1"

                cat $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini | sed -e "s/$IP_XDEBUG_LINUX/$IP_XDEBUG_MAC/" > $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.tmp
                mv $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.tmp $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini

                # Disable XDEBUG for MacOS only, performance purpose
                sed -i -e 's/^zend_extension/\;zend_extension/g' $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini                
                [ -f $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini-e ] && rm $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini-e 2> /dev/null
                ;;
            esac
        fi

        # creating ext-ioncube.ini
        if  [ ! -f $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini ] && [ -f $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample ]
        then
            cp $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini
        fi

        if [ -f $ENVIRONMENTVARIABLESFILE ]
        then
            case "$(uname -s)" in
                Darwin)

                IP_XDEBUG_MAC="10.254.254.254"
                IP_XDEBUG_LINUX="172.17.0.1"

                cat $ENVIRONMENTVARIABLESFILE | sed -e "s/$IP_XDEBUG_LINUX/$IP_XDEBUG_MAC/" > $ENVIRONMENTVARIABLESFILE.tmp
                mv $ENVIRONMENTVARIABLESFILE.tmp $ENVIRONMENTVARIABLESFILE
                ;;
            esac

            VIRTUAL_HOST=$(warp_env_read_var VIRTUAL_HOST)

            cat $ENVIRONMENTVARIABLESFILE | sed -e "s/PHP_IDE_CONFIG=serverName=docker/PHP_IDE_CONFIG=serverName=$VIRTUAL_HOST/" > $ENVIRONMENTVARIABLESFILE.tmp
            mv $ENVIRONMENTVARIABLESFILE.tmp $ENVIRONMENTVARIABLESFILE
        fi

        warp_message_warn "* commit new changes"
        warp_message_warn "* at each environment run: $(warp_message_bold './warp reset')"
    fi
}

function php_main()
{
    case "$1" in
        ssh)
            shift 1
            php_connect_ssh $*
        ;;

        info)
            php_info
        ;;

        switch)
            shift 1
            php_switch $*
        ;;

        -h | --help)
            php_help_usage
        ;;

        *)            
            php_help_usage
        ;;
    esac
}