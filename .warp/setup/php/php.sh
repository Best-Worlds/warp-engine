#!/bin/bash +x

echo ""
warp_message_info "Configuring PHP Service"

while : ; do
    respuesta_php=$( warp_question_ask_default "Do you want to add a php service? $(warp_message_info [Y/n]) " "Y" )

    if [ "$respuesta_php" = "Y" ] || [ "$respuesta_php" = "y" ] || [ "$respuesta_php" = "N" ] || [ "$respuesta_php" = "n" ] ; then
        break
    else
        warp_message_warn "wrong answer, you must select between two options: $(warp_message_info [Y/n]) "
    fi
done

if [ "$respuesta_php" = "Y" ] || [ "$respuesta_php" = "y" ]
then
    warp_message_info2 "You can check the available PHP versions from: $(warp_message_info '[ '$(get_docker_image_repository_url "php")' ]')"
    image_tags_switch=$(get_docker_image_tags_switch 'php')
    image_tags=$(get_docker_image_tags 'php')
    last_tag=$(get_docker_image_last_tag 'php')
    while : ; do
        php_version=$( warp_question_ask_default "Set the PHP version of your project: $(warp_message_info ["${last_tag}"]) " "${last_tag}" )
        if [[ "$php_version" =~ ^($image_tags_switch)$ ]]; then
            break
        else
            warp_message_info2 "Selected: $php_version, $image_tags"
        fi
    done

    warp_message_info2 "PHP version selected: $php_version"
    cat $PROJECTPATH/.warp/setup/php/tpl/php.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo ""  >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "# Config PHP" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "PHP_VERSION=$php_version" >> $ENVIRONMENTVARIABLESFILESAMPLE

    echo ""  >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "# Config xdebug by Console"  >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "XDEBUG_CONFIG=remote_host=172.17.0.1" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "PHP_IDE_CONFIG=serverName=docker" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo ""  >> $ENVIRONMENTVARIABLESFILESAMPLE

    mkdir -p $PROJECTPATH/.warp/docker/volumes/php-fpm/logs 2> /dev/null
    # Create logs file
    [ ! -f $PROJECTPATH/.warp/docker/volumes/php-fpm/logs/access.log ] && touch $PROJECTPATH/.warp/docker/volumes/php-fpm/logs/access.log  2> /dev/null
    [ ! -f $PROJECTPATH/.warp/docker/volumes/php-fpm/logs/fpm-error.log ] && touch $PROJECTPATH/.warp/docker/volumes/php-fpm/logs/fpm-error.log 2> /dev/null
    [ ! -f $PROJECTPATH/.warp/docker/volumes/php-fpm/logs/fpm-php.www.log ] && touch $PROJECTPATH/.warp/docker/volumes/php-fpm/logs/fpm-php.www.log 2> /dev/null
    # chmod -R 775 $PROJECTPATH/.warp/docker/volumes/php-fpm 2> /dev/null
        
    mkdir -p $PROJECTPATH/.warp/docker/volumes/supervisor/logs 2> /dev/null
    [ ! -f $PROJECTPATH/.warp/docker/volumes/supervisor/logs/supervisord.log ] && touch $PROJECTPATH/.warp/docker/volumes/supervisor/logs/supervisord.log 2> /dev/null
    chmod 777 $PROJECTPATH/.warp/docker/volumes/supervisor/logs/supervisord.log 2> /dev/null

    cp -R $PROJECTPATH/.warp/setup/php/config/php $PROJECTPATH/.warp/docker/config/php
    cp -R $PROJECTPATH/.warp/setup/php/config/crontab $PROJECTPATH/.warp/docker/config/crontab
    cp -R $PROJECTPATH/.warp/setup/php/config/supervisor $PROJECTPATH/.warp/docker/config/supervisor

    # helper create .sample files
    . "$WARPFOLDER/setup/php/php-helper.sh"
fi; 