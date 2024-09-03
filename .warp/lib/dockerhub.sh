#!/bin/bash

get_docker_image_tags() {
    SERVICE=$1
    TAGS=$(curl -L -s "${DOCKER_NAMESPACE_REPOSITORY_URL}${SERVICE}/tags" | grep -Po '"name":.*?[^\\]",' | sed -e's/"name":"//g' -e's/",/ /g' | tr -d '\n' | sed 's/ | $//')
    SORTED_TAGS=$(sort_versions ${TAGS[@]})
    echo "The available versions are: $(array_join '|' ${SORTED_TAGS[@]})" | sed -e 's/|/ | /g'
}

get_docker_image_tags_switch() {
    SERVICE=$1
    TAGS=$(curl -L -s "${DOCKER_NAMESPACE_REPOSITORY_URL}${SERVICE}/tags" | grep -Po '"name":.*?[^\\]",' | sed -e's/"name":"//g' -e's/",/ /g' | tr -d '\n' | sed 's/ | $//')
    SORTED_TAGS=$(sort_versions ${TAGS[@]})
    echo $(array_join '|' ${SORTED_TAGS[@]})
}

get_docker_image_last_tag() {
    SERVICE=$1
    echo $(get_docker_image_tags_switch ${SERVICE}) | sed -e 's/|.*//g'
}

get_docker_image_repository_url() {
    SERVICE=$1
    echo "https://hub.docker.com/r/${DOCKER_NAMESPACE}/${SERVICE}/tags/"
}

# Function to sort versions
sort_versions() {
    for version in "$@"; do
        # Split version into main and suffix
        main_version="${version%%-*}"
        suffix="${version#*-}"

        # Avoid duplicates if suffix is the same as the main version (no dashes)
        if [[ "${main_version}" = "${suffix}" ]];
        then
            suffix=""
        fi

        # Print main version and suffix for sorting
        echo "$main_version $suffix"
    done | sort -Vr | awk '{if ($2) print $1"-"$2; else print $1}'
}