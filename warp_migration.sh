ROOT_DIR=`git rev-parse --show-toplevel`

. "$ROOT_DIR/.warp/variables.sh"
. "$ROOT_DIR/.warp/lib/message.sh"
. "$ROOT_DIR/.warp/lib/env.sh"
. "$ROOT_DIR/.warp/includes.sh"

warp_message ""
warp_message "$FCYN ____      ___      ______      ___ $RS"
warp_message "$FCYN      _  ___  __    ___        ____ $RS"
warp_message "$FCYN ___ | |     / /___ __________       ____ $RS"
warp_message "$FCYN     | | /| / / __ \`/ ___/ __ \\ __    ___ $RS"
warp_message "$FCYN ___ | |/ |/ / /_/ / /  / /_/ / __  ___ $RS"
warp_message "$FCYN _   |__/|__/\__,_/_/  / .___/    ___   ____ $RS"
warp_message "$FCYN  __   ___    ____    /_/  ___   __   __  $RS"
warp_message "$FCYN BEST WORLDS RELEASE ____  __   ______ $RS"
warp_message ""
sleep 1

#warp_message_warn "༼ つ ◕_◕ ༽つ                                                             UPDATING WARP RELEASE"
#sleep 1
#warp_message ""
#curl -u "bestworlds:Sail7Seas" -L -o warp https://packages.bestworlds.com/warp-engine/release/latest
#chmod 755 warp
#./warp update --force
#warp_message ""

warp_message_warn "༼ つ ◕_◕ ༽つ                                                             REMOVING OLD CONTAINERS"
sleep 1
warp_message ""
warp start
warp stop --hard
warp_message ""

warp_message_warn "༼ つ ◕_◕ ༽つ                                                             UPDATING SAMPLE CONFIGURATION FILES"
sleep 1
warp_message ""
file=$DOCKERCOMPOSEFILESAMPLE
warp_message "* Updating $(basename $file) $(warp_message_ok [ok])"
sed -i 's|image: summasolutions/php:${PHP_VERSION}|image: devbestworlds/php:${PHP_VERSION}|g' $file
sed -i 's|image: summasolutions/appdata:latest|image: devbestworlds/appdata:latest|g' $file
sed -i 's|image: mysql:${MYSQL_VERSION}|image: devbestworlds/mysql:${MYSQL_VERSION}|g' $file
sed -i 's|image: summasolutions/elasticsearch:${ES_VERSION}|image: devbestworlds/elasticsearch:${ES_VERSION}|g' $file
sed -i 's|image: redis:${REDIS_CACHE_VERSION}|image: devbestworlds/redis:${REDIS_CACHE_VERSION}|g' $file
sed -i 's|image: redis:${REDIS_SESSION_VERSION}|image: devbestworlds/redis:${REDIS_SESSION_VERSION}|g' $file
sed -i 's|image: redis:${REDIS_FPC_VERSION}|image: devbestworlds/redis:${REDIS_FPC_VERSION}|g' $file
file=$ENVIRONMENTVARIABLESFILESAMPLE
warp_message "* Updating $(basename $file) $(warp_message_ok [ok])"
sed -i 's|MYSQL_DOCKER_IMAGE=mysql:|MYSQL_DOCKER_IMAGE=devbestworlds/mysql:|g' $file
warp_message ""

warp_message_warn "༼ つ ◕_◕ ༽つ                                                             REMOVING OLD INSTALLATION FILES"
sleep 1
warp_message ""
warp_message "* deleting $(basename $ENVIRONMENTVARIABLESFILE) $(warp_message_ok [ok])"
warp_message "* deleting $(basename $DOCKERCOMPOSEFILE) $(warp_message_ok [ok])"
warp_message "* deleting $(basename $DOCKERCOMPOSEFILEMAC) $(warp_message_ok [ok])"
warp_message "* deleting $(basename $DOCKERSYNCMAC) $(warp_message_ok [ok])"
warp_message "* deleting $(basename $DOCKERCOMPOSEFILEDEV) $(warp_message_ok [ok])"
if [ -f $CONFIGFOLDER/php/ext-xdebug.ini ] || [ -f $CONFIGFOLDER/php/ext-ioncube.ini ]
then
    warp_message "* reset php configurations files $(warp_message_ok [ok])"
    rm  $CONFIGFOLDER/php/ext-xdebug.ini 2> /dev/null
    rm $CONFIGFOLDER/php/ext-ioncube.ini 2> /dev/null
elif [ -d $CONFIGFOLDER/php/ext-xdebug.ini ] || [ -d $CONFIGFOLDER/php/ext-ioncube.ini ]
then
    warp_message "* reset php configurations files $(warp_message_ok [ok])"
    sudo rm -rf $CONFIGFOLDER/php/ext-xdebug.ini 2> /dev/null
    sudo rm -rf $CONFIGFOLDER/php/ext-ioncube.ini 2> /dev/null
fi
[ -f $ENVIRONMENTVARIABLESFILE ] && rm $ENVIRONMENTVARIABLESFILE 2> /dev/null
[ -f $DOCKERCOMPOSEFILE ] && rm $DOCKERCOMPOSEFILE 2> /dev/null
[ -f $DOCKERCOMPOSEFILEMAC ] && rm $DOCKERCOMPOSEFILEMAC 2> /dev/null
[ -f $DOCKERSYNCMAC ] && rm $DOCKERSYNCMAC 2> /dev/null
[ -f $DOCKERCOMPOSEFILEDEV ] && rm $DOCKERCOMPOSEFILEDEV 2> /dev/null
warp_message ""

warp_message_warn "༼ つ ◕_◕ ༽つ                                                             INSTALLING WITH NEW CONFIGURATION"
sleep 1
warp init --no-interaction
warp_message ""

warp_message_warn "༼ つ ◕_◕ ༽つ                                                             STARTING WITH NEW CONFIGURATION"
sleep 1
warp_message ""
warp start
warp_message ""

warp_message_warn "༼ つ ◕_◕ ༽つ                                                             SHOWING DOCKER CONTAINERS"
sleep 1
warp_message ""
docker ps
warp_message ""

warp_message_warn "༼ つ ◕_◕ ༽つ  You should see that the images no longer refer to summasolutions, instead you should see devbestworlds."
warp_message ""
