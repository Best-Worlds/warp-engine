#!/bin/bash +x

warp_message ""
warp_message_info "Configuring the Redis Service"

PATH_CONFIG_REDIS='./.warp/docker/config/redis'
MSJ_REDIS_VERSION_HUB=1 # True

while : ; do
    respuesta_redis_cache=$( warp_question_ask_default "Do you want to add a service for Redis Cache? $(warp_message_info [Y/n]) " "Y" )

    if [ "$respuesta_redis_cache" = "Y" ] || [ "$respuesta_redis_cache" = "y" ] || [ "$respuesta_redis_cache" = "N" ] || [ "$respuesta_redis_cache" = "n" ] ; then
        break
    else
        warp_message_warn "wrong answer, you must select between two options: $(warp_message_info [Y/n]) "
    fi
done

image_tags_switch=$(get_docker_image_tags_switch 'redis')
image_tags=$(get_docker_image_tags 'redis')
last_tag=$(get_docker_image_last_tag 'redis')

if [ "$respuesta_redis_cache" = "Y" ] || [ "$respuesta_redis_cache" = "y" ]
then

    warp_message_info2 "You can check the Redis versions available here: $(warp_message_info '[ '$(get_docker_image_repository_url "redis")' ]')"

    while : ; do
        redis_version=$( warp_question_ask_default "Choose a version of Redis for cache: $(warp_message_info ["${last_tag}"]) " "${last_tag}" )
        if [[ "$redis_version" =~ ^($image_tags_switch)$ ]]; then
            break
        else
            warp_message_info2 "Selected: $redis_version, $image_tags"
        fi
    done

    warp_message_info2 "Selected Redis Cache version: $redis_version, in the internal port 6379 $(warp_message_bold 'redis-cache:6379')"

    cache_config_file_cache=$( warp_question_ask_default "Set Redis configuration file: $(warp_message_info [./.warp/docker/config/redis/redis.conf]) " "./.warp/docker/config/redis/redis.conf" )
    warp_message_info2 "Selected configuration file: $cache_config_file_cache"
    
    cat $PROJECTPATH/.warp/setup/redis/tpl/redis_cache.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo "REDIS_CACHE_VERSION=$redis_version" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "REDIS_CACHE_CONF=$cache_config_file_cache" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

    # Control will enter here if $PATH_CONFIG_REDIS doesn't exist.
    if [ ! -d "$PATH_CONFIG_REDIS" ]; then
        cp -R ./.warp/setup/redis/config/redis $PATH_CONFIG_REDIS
    fi
    warp_message ""
fi; 

while : ; do
    respuesta_redis_session=$( warp_question_ask_default "Do you want to add a service for Redis Session? $(warp_message_info [Y/n]) " "Y" )

    if [ "$respuesta_redis_session" = "Y" ] || [ "$respuesta_redis_session" = "y" ] || [ "$respuesta_redis_session" = "N" ] || [ "$respuesta_redis_session" = "n" ] ; then
        break
    else
        warp_message_warn "wrong answer, you must select between two options: $(warp_message_info [Y/n]) "
    fi
done

if [ "$respuesta_redis_session" = "Y" ] || [ "$respuesta_redis_session" = "y" ]
then

    warp_message_info2 "You can check the Redis versions available here: $(warp_message_info '[ '$(get_docker_image_repository_url "redis")' ]')"

    while : ; do
        redis_version=$( warp_question_ask_default "Choose a version of Redis for session: $(warp_message_info ["${last_tag}"]) " "${last_tag}" )
        if [[ "$redis_version" =~ ^($image_tags_switch)$ ]]; then
            break
        else
            warp_message_info2 "Selected: $redis_version, $image_tags"
        fi
    done

    warp_message_info2 "Selected version of Redis Session: $redis_version, in the internal port 6379 $(warp_message_bold 'redis-session:6379')"

    cache_config_file_session=$( warp_question_ask_default "Set Redis configuration file: $(warp_message_info [./.warp/docker/config/redis/redis.conf]) " "./.warp/docker/config/redis/redis.conf" )
    warp_message_info2 "Selected configuration file: $cache_config_file_session"

    cat $PROJECTPATH/.warp/setup/redis/tpl/redis_session.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo "REDIS_SESSION_VERSION=$redis_version" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "REDIS_SESSION_CONF=$cache_config_file_session" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

    # Control will enter here if $PATH_CONFIG_REDIS doesn't exist.
    if [ ! -d "$PATH_CONFIG_REDIS" ]; then
        cp -R ./.warp/setup/redis/config/redis $PATH_CONFIG_REDIS
    fi
    warp_message ""
fi; 

while : ; do
    respuesta_redis_fpc=$( warp_question_ask_default "Do you want to add a service for Redis FPC? $(warp_message_info [Y/n]) " "Y" )

    if [ "$respuesta_redis_fpc" = "Y" ] || [ "$respuesta_redis_fpc" = "y" ] || [ "$respuesta_redis_fpc" = "N" ] || [ "$respuesta_redis_fpc" = "n" ] ; then
        break
    else
        warp_message_warn "wrong answer, you must select between two options: $(warp_message_info [Y/n]) "
    fi
done

if [ "$respuesta_redis_fpc" = "Y" ] || [ "$respuesta_redis_fpc" = "y" ]
then

    warp_message_info2 "You can check the Redis versions available here: $(warp_message_info '[ '$(get_docker_image_repository_url "redis")' ]')"

    while : ; do
        redis_version=$( warp_question_ask_default "Choose a version of Redis for FPC: $(warp_message_info ["${last_tag}"]) " "${last_tag}" )
        if [[ "$redis_version" =~ ^($image_tags_switch)$ ]]; then
            break
        else
            warp_message_info2 "Selected: $redis_version, $image_tags"
        fi
    done

    warp_message_info2 "Selected Redis FPC version: $redis_version, in the internal port 6379 $(warp_message_bold 'redis-fpc:6379')"

    cache_config_file_fpc=$( warp_question_ask_default "Set Redis configuration file: $(warp_message_info [./.warp/docker/config/redis/redis.conf]) " "./.warp/docker/config/redis/redis.conf" )
    warp_message_info2 "Selected configuration file: $cache_config_file_fpc"

    cat $PROJECTPATH/.warp/setup/redis/tpl/redis_fpc.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo "REDIS_FPC_VERSION=$redis_version" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "REDIS_FPC_CONF=$cache_config_file_fpc" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

    # Control will enter here if $PATH_CONFIG_REDIS doesn't exist.
    if [ ! -d "$PATH_CONFIG_REDIS" ]; then
        cp -R ./.warp/setup/redis/config/redis $PATH_CONFIG_REDIS
    fi
    warp_message ""
fi; 
