#!/bin/bash

function warp_message_no_newline()
{
    printf "$RS$1 "
}

show_progress() {
    while true
    do
        echo -n "."
        sleep 1
    done
}


ROOT_DIR=`git rev-parse --show-toplevel`
. "$ROOT_DIR/.warp/variables.sh"
. "$ROOT_DIR/.warp/lib/message.sh"

warp_message_no_newline "* Acquiring environment connection parameters  "
## $ENVIRONMENTVARIABLESFILE
identityFile="~/.ssh/bww_key.pem"
knownHostsFile="~/.ssh/known_hosts"
siteHost="ubuntu@52.87.144.138"
siteFolder="/var/www/magento"
## $ENVIRONMENTVARIABLESFILE
warp_message_ok "done"
sleep 1

warp_message_no_newline "* Acquiring database connection parameters     "
siteEnvFile="$siteFolder/app/etc/env.php"
siteEnvContent=$(ssh -o "LogLevel=QUIET" -o "SendEnv TERM" -o "IdentityFile=$identityFile" -o "UserKnownHostsFile=$knownHostsFile" $siteHost -t "cat $siteEnvFile")
dbConnectionData=$(echo "$siteEnvContent" | sed -n "/'db' => \[/,/\],/p" | sed -n "/'default' => \[/,/\],/p")
dbHostPort=$(echo "$dbConnectionData" | grep "'host' =>" | awk -F"'" '{print $4}')
dbName=$(echo "$dbConnectionData" | grep "'dbname' =>" | awk -F"'" '{print $4}')
dbUser=$(echo "$dbConnectionData" | grep "'username' =>" | awk -F"'" '{print $4}')
dbPass=$(echo "$dbConnectionData" | grep "'password' =>" | awk -F"'" '{print $4}')
dbHost=$dbHostPort
dbPort="3306"
if [[ "$dbHostPort" == *:* ]]; then
    dbHost=$(echo "$dbHostPort" | awk -F':' '{print $1}')
    dbPort=$(echo "$dbHostPort" | awk -F':' '{print $2}')
fi
warp_message_ok "done"
warp_message ""
sleep 1

startedAt=$(date '+%Y-%m-%d %H:%M:%S')
warp_message_no_newline "* Executing dump"
show_progress &
PROGRESS_PID=$!
dumpFile="$ROOT_DIR/test-dump.sql"
ssh -o "LogLevel=QUIET" -o "SendEnv TERM" -o "IdentityFile=$identityFile" -o "UserKnownHostsFile=$knownHostsFile" $siteHost -C \
    "mysqldump --single-transaction --host=$dbHost --port=$dbPort --user=$dbUser --password=$dbPass $dbName core_config_data 2>/dev/null" > "$dumpFile" 2>/dev/null
kill $PROGRESS_PID
warp_message ""
warp_message "  Dump saved in: $(warp_message_ok $dumpFile)"
warp_message "  Started  at: $(warp_message_ok "$startedAt")"
warp_message "  Finished at: $(warp_message_ok "$(date '+%Y-%m-%d %H:%M:%S')")"

warp_message ""
sleep 1

queryStartedAt=$(date '+%Y-%m-%d %H:%M:%S')
warp_message_no_newline "* Executing query"
show_progress &
PROGRESS_PID=$!
dbQuery="select * from core_config_data limit 1;"
result="$( \
    ssh -o "LogLevel=QUIET" -o "SendEnv TERM" -o "IdentityFile=$identityFile" -o "UserKnownHostsFile=$knownHostsFile" $siteHost -t \
    "mysql --no-auto-rehash --host=$dbHost --port=$dbPort --user=$dbUser --password=$dbPass $dbName --execute '$dbQuery' 2>/dev/null" | grep -v "bash: warning" \
    )"
kill $PROGRESS_PID
warp_message ""
warp_message_ok "$result"
warp_message "  Started  at: $(warp_message_ok "$queryStartedAt")"
warp_message "  Finished at: $(warp_message_ok "$(date '+%Y-%m-%d %H:%M:%S')")"
warp_message ""
sleep 1


startedAt=$(date '+%Y-%m-%d %H:%M:%S')
warp_message "* Connecting to Database $(warp_message_ok "done")"
warp_message ""
ssh -o "LogLevel=QUIET" -o "SendEnv TERM" -o "IdentityFile=$identityFile" -o "UserKnownHostsFile=$knownHostsFile" $siteHost -t \
    "mysql --no-auto-rehash --host=$dbHost --port=$dbPort --user=$dbUser --password=$dbPass $dbName"
warp_message ""
warp_message "  Started  at: $(warp_message_ok "$startedAt")"
warp_message "  Finished at: $(warp_message_ok "$(date '+%Y-%m-%d %H:%M:%S')")"
warp_message ""
warp_message ""
