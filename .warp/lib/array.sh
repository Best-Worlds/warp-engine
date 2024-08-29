#!/bin/bash +x

array_join()
{
    local IFS="$1"
    shift
    echo "$*"
}

array_includes()
{
    NEEDLE=$1
    shift 1

    if [[ ! "$*" =~ ${NEEDLE} ]]
    then
        echo false
    else
        echo true
    fi
}