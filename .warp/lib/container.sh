#!/bin/bash

# Executes command on specific container
# Globals:
#   DOCKERCOMPOSEFILE
# Arguments:
#   Container name
#   Command to be executed
#   Root flag
# Returns:
#   None
warp_container_exec()
{
    #warp_check_is_running_error

    CONTAINER=$1
    COMMAND=$2
    ROOT_FLAG=$3
    NO_OUTPUT_FLAG=$4

    if [[ -z "${CONTAINER}" ]];
    then
        warp_message_error "Missing container name"
        exit 1
    else
        if [[ "${CONTAINER}" = 'php' ]];
        then
            COMMAND="/bin/bash -c '${COMMAND}'"
        fi
    fi

    if [[ ! -z "${ROOT_FLAG}" ]] && [[ "${ROOT_FLAG}" = '--root' ]];
    then
        ROOT=" -uroot"
    else
        ROOT=""
    fi

    if [[ "${NO_OUTPUT_FLAG}" = '--no-output' ]];
    then
        docker-compose -f $DOCKERCOMPOSEFILE exec${ROOT} "${CONTAINER}" ${COMMAND}
    else
        RESULT=$(docker-compose -f $DOCKERCOMPOSEFILE exec${ROOT} "${CONTAINER}" ${COMMAND})
        if [[ "${RESULT}" =~ "err" ]] || [[ "${RESULT}" =~ "error" ]] || [[ "${RESULT}" =~ "ERROR" ]] || [[ "${RESULT}" =~ "fail" ]];
        then
            warp_message_error "${RESULT}"
        else
            warp_message_info "${RESULT}"
        fi
    fi
}