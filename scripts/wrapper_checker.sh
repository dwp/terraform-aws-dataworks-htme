#!/bin/bash

set -u

# Import the logging functions
source /opt/htme/logging.sh
source /etc/environment

function log_wrapper_message() {
    log_htme_message "${1}" "wrapper_checker.sh" "wrapper_pid,${WRAPPER_PID}"
}

# Check status of wrapper script using PID env var set by wrapper script
STATUS=$(ps -p "$WRAPPER_PID" | wc -l)

# Check if wordcount received any letters or not (will do if PID running)
if [[ "${STATUS}" == "0" ]]; then
    log_wrapper_message "Wrapper script is no longer running. Terminating instance to force rebuild"

    # Sleeping here to allow the logs to flush as there is a one second delay
    sleep 5

    /sbin/shutdown -h now
fi
