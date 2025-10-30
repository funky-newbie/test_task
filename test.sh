#!/bin/bash

PROCESS_NAME="test"
URL="https://test.com/monitoring/test/api"
LOG_FILE="/var/log/monitoring.log"
DATE_FORMAT="+%Y-%m-%d %H:%M:%S"

LAST_PID=""

while true; do
    DATE=$(date "$DATE_FORMAT")

    PROCESS_PID=$(pgrep -x "$PROCESS_NAME")

    if [ -n "$PROCESS_PID" ]; then
        
	curl --silent --fail --max-time 10 "$URL"
        
        if [ $? -eq 0 ]; then
            echo "$DATE: $PROCESS_NAME is running, status sent successfully." >> "$LOG_FILE"
        else
            echo "$DATE: ERROR: Server $URL is not accessible." >> "$LOG_FILE"
        fi
        
        if [ "$PROCESS_PID" != "$LAST_PID" ]; then
            if [ -n "$LAST_PID" ]; then
                echo "$DATE: $PROCESS_NAME was restarted. Old PID: $LAST_PID, New PID: $PROCESS_PID" >> "$LOG_FILE"
            fi
            LAST_PID="$PROCESS_PID"
        fi
    else
        echo "$DATE: $PROCESS_NAME is not running." >> "$LOG_FILE"
    fi

    sleep 60
done
