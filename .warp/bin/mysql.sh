#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/mysql_help.sh"

function mysql_info()
{

    if ! warp_check_env_file ; then
        warp_message_error "file not found $(basename $ENVIRONMENTVARIABLESFILE)"
        exit
    fi; 

    DATABASE_NAME=$(warp_env_read_var DATABASE_NAME)
    DATABASE_USER=$(warp_env_read_var DATABASE_USER)
    DATABASE_PASSWORD=$(warp_env_read_var DATABASE_PASSWORD)
    DATABASE_ROOT_PASSWORD=$(warp_env_read_var DATABASE_ROOT_PASSWORD)
    DATABASE_BINDED_PORT=$(warp_env_read_var DATABASE_BINDED_PORT)
    MYSQL_CONFIG_FILE=$(warp_env_read_var MYSQL_CONFIG_FILE)
    MYSQL_VERSION=$(warp_env_read_var MYSQL_VERSION)
    MODE_SANDBOX=$(warp_env_read_var MODE_SANDBOX)

    if [ "$MODE_SANDBOX" = "Y" ] || [ "$MODE_SANDBOX" = "y" ] ; then 
        DATABASE_USER=null
        DATABASE_PASSWORD=null
    fi

    if [ ! -z "$DATABASE_ROOT_PASSWORD" ]
    then
        warp_message ""
        warp_message_info "* MySQL"
        warp_message "Database Name:              $(warp_message_info $DATABASE_NAME)"
        warp_message "Host: (container)           $(warp_message_info mysql)"
        warp_message "Username:                   $(warp_message_info $DATABASE_USER)"
        warp_message "Password:                   $(warp_message_info $DATABASE_PASSWORD)"
        warp_message "Root user:                  $(warp_message_info root)"
        warp_message "Root password:              $(warp_message_info $DATABASE_ROOT_PASSWORD)"
        warp_message "Binded port (host):         $(warp_message_info $DATABASE_BINDED_PORT)"
        warp_message "MySQL version:              $(warp_message_info $MYSQL_VERSION)"
        warp_message "my.cnf location:            $(warp_message_info $PROJECTPATH/.warp/docker/config/mysql/my.cnf)"
        warp_message "Other config files:         $(warp_message_info $MYSQL_CONFIG_FILE)"
        warp_message "Dumps folder (host):        $(warp_message_info $PROJECTPATH/.warp/docker/dumps)" 
        warp_message "Dumps folder (container):   $(warp_message_info /dumps)"
        warp_message ""
        warp_message_warn " - prevent to use 127.0.0.1 or localhost as database host.  Instead of 127.0.0.1 use: $(warp_message_bold 'mysql')"
        warp_message ""
    fi
}

function mysql_connect() 
{
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        mysql_connect_help 
        exit 1
    fi;

    if [[ $(warp_get_current_remote_env) = false ]];
    then
        warp_check_is_running_error
        DATABASE_ROOT_PASSWORD=$(warp_env_read_var DATABASE_ROOT_PASSWORD)

        docker-compose -f $DOCKERCOMPOSEFILE exec mysql bash -c "mysql -uroot -p$DATABASE_ROOT_PASSWORD"
    else
        warp_remote_env_connect "$(mysql_connect_get_command)"
    fi
}

function mysql_query()
{
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
        then
            mysql_connect_help
            exit 1
        fi;

        QUERY=$1
        if [[ -z "${QUERY}" ]];
        then
            warp_message_error "Missing query for database execution"
            exit 1
        fi

        if [[ $(warp_get_current_remote_env) = false ]];
        then
            warp_check_is_running_error
            DATABASE_ROOT_PASSWORD=$(warp_env_read_var DATABASE_ROOT_PASSWORD)

            docker-compose -f $DOCKERCOMPOSEFILE exec mysql bash -c "mysql -uroot -p$DATABASE_ROOT_PASSWORD -e '${QUERY}'"
        else
            warp_remote_env_connect "$(mysql_connect_get_command)"
        fi
}

function mysql_update_db() 
{
    DOCKER_PRIVATE_REGISTRY=$(warp_env_read_var DOCKER_PRIVATE_REGISTRY)

    if [ -z "$DOCKER_PRIVATE_REGISTRY" ] ; then
        warp_message_error "this command only work with private db registry"

        exit 1;
    fi

    warp_message "This command will do:"
    warp_message "* stop containers"
    warp_message "* pull new images"
    warp_message "* remove volume db"
    warp_message "* start containers"
    
    respuesta_update_db=$( warp_question_ask_default "Do you want to continue? $(warp_message_info [Y/n]) " "Y" )

    if [ "$respuesta_update_db" = "Y" ] || [ "$respuesta_update_db" = "y" ]
    then

        if [ $(warp_check_is_running) = true ]; then
            warp stop --hard 
        fi

        #  CHECK IF GITIGNOREFILE CONTAINS FILES WARP TO IGNORE
        [ -f "$HOME/.aws/credentials" ] && cat "$HOME/.aws/credentials" | grep --quiet -w "^[summa-docker]"

        # Exit status 0 means string was found
        # Exit status 1 means string was not found
        if [ $? = 0 ] || [ -f "$HOME/.aws/credentials" ]
        then
            $(aws ecr get-login --region us-east-1 --no-include-email --profile summa-docker)

            # check if login Succeeded 
            if [ $? = 0 ]
            then
                warp docker pull
                warp volume --rm mysql 2> /dev/null
                warp start
            fi
        fi
    else 
        warp_message_warn "* aborting update database"    
    fi
}

function mysql_connect_ssh() 
{
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        mysql_ssh_help 
        exit 1
    fi;

    warp_check_is_running_error
    docker-compose -f $DOCKERCOMPOSEFILE exec mysql bash -c "export COLUMNS=`tput cols`; export LINES=`tput lines`; exec bash"
}

function mysql_switch() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ]
    then
        mysql_switch_help 
        exit 1
    fi;

    if [ $(warp_check_is_running) = true ]; then
        warp_message_error "The containers are running"
        warp_message_error "please, first run warp stop --hard"

        exit 1;
    fi

    MYSQL_VERSION_CURRENT=$(warp_env_read_var MYSQL_VERSION)
    warp_message_info2 "You current MySQL version is: $MYSQL_VERSION_CURRENT"    

    if [ $MYSQL_VERSION_CURRENT = $1 ]
    then
        warp_message_info2 "the selected version is the same as the previous one, no changes will be made"
        warp_message_warn "for help run: $(warp_message_bold './warp mysql switch --help')"
    else
        warp_message_warn "This command will destroy MySQL database"
        warp_message "you can create a backup running: $(warp_message_bold './warp mysql dump --help')"
        respuesta_switch_version_db=$( warp_question_ask_default "Do you want to continue? $(warp_message_info [Y/n]) " "Y" )

        if [ "$respuesta_switch_version_db" = "Y" ] || [ "$respuesta_switch_version_db" = "y" ]
        then
            mysql_version=$1
            image_tags_switch=$(get_docker_image_tags_switch 'mysql')
            image_tags=$(get_docker_image_tags 'mysql')
            if [[ "$mysql_version" =~ ^($image_tags_switch)$ ]]; then
                warp_message_info2 "MySQL new version selected: $mysql_version"
            else
                warp_message_info2 "Selected: $mysql_version, $image_tags"
                warp_message_warn "for help run: $(warp_message_bold './warp mysql switch --help')"
                exit 1;
            fi

            warp_message_info2 "change version to: $mysql_version"

            MYSQL_VERSION_OLD="MYSQL_VERSION=$MYSQL_VERSION_CURRENT"
            MYSQL_VERSION_NEW="MYSQL_VERSION=$mysql_version"

            cat $ENVIRONMENTVARIABLESFILE | sed -e "s/$MYSQL_VERSION_OLD/$MYSQL_VERSION_NEW/" > "$ENVIRONMENTVARIABLESFILE.warp_tmp"
            mv "$ENVIRONMENTVARIABLESFILE.warp_tmp" $ENVIRONMENTVARIABLESFILE

            cat $ENVIRONMENTVARIABLESFILESAMPLE | sed -e "s/$MYSQL_VERSION_OLD/$MYSQL_VERSION_NEW/" > "$ENVIRONMENTVARIABLESFILESAMPLE.warp_tmp"
            mv "$ENVIRONMENTVARIABLESFILESAMPLE.warp_tmp" $ENVIRONMENTVARIABLESFILESAMPLE

            # delete old files
            rm  -rf $PROJECTPATH/.warp/docker/config/mysql/ 2> /dev/null
            if [ -d $PROJECTPATH/.warp/docker/volumes/mysql ]
            then
                sudo rm -rf $PROJECTPATH/.warp/docker/volumes/mysql/* 2> /dev/null
            fi
            
            # delete volume database
            warp volume --rm mysql 2> /dev/null

            DOCKER_PRIVATE_REGISTRY=$(warp_env_read_var DOCKER_PRIVATE_REGISTRY)

            if [ ! -z "$DOCKER_PRIVATE_REGISTRY" ] ; then
                NAMESPACE=$(warp_env_read_var NAMESPACE)
                PROJECT=$(warp_env_read_var PROJECT)                
                mysql_docker_image="${NAMESPACE}-${PROJECT}-dbs"

                CREATE_MYSQL_IMAGE_FROM="${mysql_docker_image}:latest"

                # clear custom image
                docker pull "mysql:$mysql_version"
                docker rmi "${DOCKER_PRIVATE_REGISTRY}/${mysql_docker_image}"
                docker tag $CREATE_MYSQL_IMAGE_FROM 2> /dev/null
            fi

            # check files for mysql version
            #warp_mysql_check_files_yaml

            # copy base files
            cp -R $PROJECTPATH/.warp/setup/mysql/config/ $PROJECTPATH/.warp/docker/config/mysql/    

            warp_message_warn "* commit new changes"
            warp_message_warn "* at each environment run: $(warp_message_bold './warp reset')"
            warp_message_warn "* after that run: $(warp_message_bold './warp mysql --update')"
        else 
            warp_message_warn "* aborting switch database"
        fi
    fi    
}

function mysql_dump() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        mysql_dump_help 
        exit 1
    fi;

    if [[ $(warp_get_current_remote_env) = false ]];
    then
        warp_check_is_running_error
        DATABASE_ROOT_PASSWORD=$(warp_env_read_var DATABASE_ROOT_PASSWORD)

        db="$@"

        [ -z "$db" ] && warp_message_error "Database name is required" && exit 1

        docker-compose -f $DOCKERCOMPOSEFILE exec mysql bash -c "mysqldump -uroot -p$DATABASE_ROOT_PASSWORD $db 2> /dev/null"
    else
        # Creates new directory if not exists for remote environment dumps
        DUMPS_DIR=".warp/docker/dumps/$(warp_get_current_remote_env)"
        warp_create_directory_if_not_exists "${DUMPS_DIR}"

        if [[ ! -z $* ]];
        then
            TABLES_FILENAME=$(echo $* | tr " " "-")
        else
            TABLES_FILENAME="full-db"
        fi

        OUTPUT="${DUMPS_DIR}/${TABLES_FILENAME}-$(date '+%Y_%m_%d%-H_%M_%S').sql"
        SUCCESS_MESSAGE="$(warp_message_ok "Dump was generated under the following path: $(warp_message_bold ${OUTPUT})")"

        warp_remote_env_connect "$(mysql_connect_get_command 'dump' $*)" > ${OUTPUT}
        warp_message "${SUCCESS_MESSAGE}"
    fi

}

function mysql_import()
{
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        mysql_import_help 
        exit 1
    fi;

    warp_check_is_running_error

    if [[ $(warp_get_current_remote_env) = false ]];
    then
        warp_check_is_running_error

        db=$1
        [ -z "$db" ] && warp_message_error "Database name is required" && exit 1

        DATABASE_ROOT_PASSWORD=$(warp_env_read_var DATABASE_ROOT_PASSWORD)

        docker-compose -f $DOCKERCOMPOSEFILE exec -T mysql bash -c "mysql -uroot -p$DATABASE_ROOT_PASSWORD $db 2> /dev/null"
    else
        $(warp_remote_env_connect "$(mysql_connect_get_command "dump")") > $(warp_get_current_remote_env)-$(date '+%Y-%m-%d%H:%M:%S').sql 2> /dev/null
    fi
}

function mysql_connect_get_command
{
    case "$1" in
        "dump")
            COMMAND="-C mysqldump"
            shift 1
            TABLES="$* 2>/dev/null"
            shift
        ;;
        *)
            COMMAND="-t mysql"
            TABLES=""
        ;;
    esac

    ENV_FILENAME="$(warp_remote_env_read_var 'root_dir')/app/etc/env.php"
    ENV_FILE_DATA=$(warp_remote_env_connect "-t cat ${ENV_FILENAME}")

    DB_CONN_DATA=$(echo "${ENV_FILE_DATA}" | sed -n "/'db' => \[/,/\],/p" | sed -n "/'default' => \[/,/\],/p")
    DB_HOST_PORT=$(echo "${DB_CONN_DATA}" | grep "'host' =>" | awk -F"'" '{print $4}')
    DB_NAME=$(echo "${DB_CONN_DATA}" | grep "'dbname' =>" | awk -F"'" '{print $4}')
    DB_USER=$(echo "${DB_CONN_DATA}" | grep "'username' =>" | awk -F"'" '{print $4}')
    DB_PASS=$(echo "${DB_CONN_DATA}" | grep "'password' =>" | awk -F"'" '{print $4}')
    DB_HOST=${DB_HOST_PORT}
    DB_PORT="3306"
    if [[ "${DB_HOST_PORT}" == *:* ]]; then
        DB_HOST=$(echo "${DB_HOST_PORT}" | awk -F':' '{print $1}')
        DB_PORT=$(echo "${DB_HOST_PORT}" | awk -F':' '{print $2}')
    fi

    echo "${COMMAND} --host=${DB_HOST} --port=${DB_PORT} --user=${DB_USER} --password=${DB_PASS} ${DB_NAME} ${TABLES}"
}

function mysql_main()
{
    case "$1" in
        dump)
            shift 1
            mysql_dump $*
        ;;

        info)
            mysql_info
        ;;

        import)
            shift 1
            mysql_import $*
        ;;

        connect)
            shift 1
            mysql_connect $*
        ;;

        query)
            shift 1
            mysql_query $*
        ;;

        ssh)
            shift 1
            mysql_connect_ssh $*
        ;;

        switch)
            shift 1
            mysql_switch $*
        ;;

        --update)
            mysql_update_db
        ;;

        -h | --help)
            mysql_help_usage
        ;;

        *)            
            mysql_help_usage
        ;;
    esac
}
