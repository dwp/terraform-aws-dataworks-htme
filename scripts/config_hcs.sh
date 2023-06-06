#!/usr/bin/env bash

(
    # Import the logging functions
    source /opt/htme/logging.sh

    log_message "Populate HCS required tags..."


    # Import tenable Linking Key
    source /etc/environment

    export TECHNICALSERVICE="DataWorks"
    export ENVIRONMENT="$1"

    echo "$TECHNICALSERVICE"
    echo "$ENVIRONMENT"

    log_message "Configuring tenable agent"

    sudo /opt/nessus_agent/sbin/nessuscli agent link --key="$TENABLE_LINKING_KEY" --cloud --groups="$TECHNICALSERVICE"_"$ENVIRONMENT",TVAT --proxy-host="$2" --proxy-port="$3"


)   >> /var/log/htme/config_hcs.log 2>&1