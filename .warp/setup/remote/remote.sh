#!/bin/bash +x

echo ""

warp_message_info "Configuring Remote Environments"

while : ; do
    REMOTE_ENV_FLAG=$( warp_question_ask_default "Do you want to add remote environment connections? $(warp_message_info [Y/n]) " "Y" )

    if [ "${REMOTE_ENV_FLAG}" = "Y" ] || [ "${REMOTE_ENV_FLAG}" = "y" ] || [ "${REMOTE_ENV_FLAG}" = "N" ] || [ "${REMOTE_ENV_FLAG}" = "n" ] ; then
        break
    else
        warp_message_warn "wrong answer, you must select between two options: $(warp_message_info [Y/n]) "
    fi
done

warp_message ""

if [ "${REMOTE_ENV_FLAG}" = "Y" ] || [ "${REMOTE_ENV_FLAG}" = "y" ]
then
    while : ; do
        REMOTE_ENV_QTY=$( warp_question_ask_default "How many remote environments you want to configure? $(warp_message_info [2]) " "2" )
        if [[ ${REMOTE_ENV_QTY} =~ ^[1-9]+$ ]]; then
            break
        else
            warp_message_warn "You should enter a number between 1-9."
        fi
    done

    REMOTE_ENV_IDS=( )
    REMOTE_ENV_INFO=( )

    for (( i=1; i <= ${REMOTE_ENV_QTY}; i++ )); do
        warp_message ""
        warp_message_warn "- Environment [$i]"
        warp_message ""
        while : ; do
            REMOTE_ENV_NAME=$( warp_question_ask " Set an identifier for your environment $(warp_message_info "[dev,stage,live]"): ")
            if [[ -z "${REMOTE_ENV_NAME}" ]]; then
                warp_message_warn " Empty answer. Environment must have an identifier."
                warp_message ""
            else
                REMOTE_ENV_IDS+=( "${REMOTE_ENV_NAME}" )
                break
            fi
        done

        REMOTE_ENV_INFO+=( $(echo "#${REMOTE_ENV_NAME}") )
        while : ; do
            REMOTE_ENV_HOST=$( warp_question_ask " Set a host for your environment: ")
            if [[ -z "${REMOTE_ENV_HOST}" ]]; then
                warp_message_warn " Empty answer. Environment must have a host."
                warp_message ""
            else
                REMOTE_ENV_INFO+=( $(echo "${REMOTE_ENV_NAME^^}_REMOTE_ENVIRONMENT_HOST=${REMOTE_ENV_HOST}") )
                break
            fi
        done

        while : ; do
            REMOTE_ENV_USER=$( warp_question_ask " Set a user for your environment: ")
            if [[ -z "${REMOTE_ENV_USER}" ]]; then
                warp_message_warn " Empty answer. Environment must have a user."
                warp_message ""
            else
                REMOTE_ENV_INFO+=( $(echo "${REMOTE_ENV_NAME^^}_REMOTE_ENVIRONMENT_USER=${REMOTE_ENV_USER}") )
                break
            fi
        done

        while : ; do
            REMOTE_ENV_IDENTITY_KEY=$( warp_question_ask " Set an identity key for your environment: ")
            if [[ -z "${REMOTE_ENV_IDENTITY_KEY}" ]]; then
                warp_message_warn " Empty answer. Environment must have a user."
                warp_message ""
            else
                REMOTE_ENV_INFO+=( $(echo "${REMOTE_ENV_NAME^^}_REMOTE_ENVIRONMENT_IDENTITY_KEY=${REMOTE_ENV_IDENTITY_KEY}") )
                break
            fi
        done

        while : ; do
            REMOTE_ENV_ROOT_DIR=$( warp_question_ask " Set a root directory for your environment: ")
            if [[ -z "${REMOTE_ENV_ROOT_DIR}" ]]; then
                warp_message_warn " Empty answer. Environment must have a root directory."
                warp_message ""
            else
                REMOTE_ENV_INFO+=( $(echo "${REMOTE_ENV_NAME^^}_REMOTE_ENVIRONMENT_ROOT_DIR=${REMOTE_ENV_ROOT_DIR}") )
                break
            fi
        done
    done

    warp_message ""
    ENV_COUNT=${#REMOTE_ENV_IDS[@]}

    if [[ ${ENV_COUNT} -eq 1 ]];
    then
        warp_message_info2 "A single remote environment has been added ["${REMOTE_ENV_IDS[0]}"]"
    else
        warp_message_info2 "${ENV_COUNT} environments were added ["$(array_join "," "${REMOTE_ENV_IDS[@]}")"]"
    fi

    ENV_FILE_TEMPLATE="$PROJECTPATH/.warp/setup/remote/tpl/remote.env"

    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

    # Adding remote environments identifiers
    cat "${ENV_FILE_TEMPLATE}" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "${REMOTE_ENV_IDS[@]}" >> $ENVIRONMENTVARIABLESFILESAMPLE

    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

    # Adding remote environments variables
    for env_var in ${REMOTE_ENV_INFO[@]}; do
        echo "${env_var}" >> $ENVIRONMENTVARIABLESFILESAMPLE
    done

    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE
fi;