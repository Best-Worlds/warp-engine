#!/bin/sh
get_docker_image_tags() {
    SERVICE=$1
    echo "The available versions are: $(curl -L -s "${DOCKER_NAMESPACE_REPOSITORY_URL}${SERVICE}/tags?name=&ordering=name" | grep -Po '"name":.*?[^\\]",' | sed -e's/"name":"//g' -e's/",/ | /g' | tr -d '\n' | sed 's/ | $//')"
}

get_docker_image_tags_switch() {
    SERVICE=$1
    echo "$(curl -L -s "${DOCKER_NAMESPACE_REPOSITORY_URL}${SERVICE}/tags?name=&ordering=name" | grep -Po '"name":.*?[^\\]",' | sed -e's/"name"://g' -e's/",/"|/g' | tr -d '\n' | sed 's/|$//' | sed "s/\"//g")"
}

get_docker_image_last_tag() {
    SERVICE=$1
    echo "$(curl -L -s "${DOCKER_NAMESPACE_REPOSITORY_URL}${SERVICE}/tags?name=&ordering=name&page_size=1" | grep -Po '"name":.*?[^\\]",' | sed -e's/"name":"//g' -e's/",//g')"
}

get_docker_image_repository_url() {
    SERVICE=$1
    echo "https://hub.docker.com/r/${DOCKER_NAMESPACE}/${SERVICE}/tags/"
}