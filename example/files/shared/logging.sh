#!/bin/bash

set -u

source /opt/shared/common_logging.sh

log_htme_message() {
    set +u

    message="${1}"
    component="${2}"
    process_id="${3}"

    application="hbase_to_mongo_exporter"

    app_version="NOT_SET"
    if [ -f "/opt/htme/version" ]; then
        app_version=$(cat /opt/htme/version)
    fi

    log_level="NOT_SET"
    if [ -f "/opt/htme/log_level" ]; then
        log_level=$(cat /opt/htme/log_level)
    fi

    environment="NOT_SET"
    if [ -f "/opt/htme/environment" ]; then
        environment=$(cat /opt/htme/environment)
    fi

    log_message "${message}" "${log_level}" "${app_version}" "${process_id}" "${application}" "${component}" "${environment}" "${@:4}"
}

log_hdi_message() {
    set +u

    message="${1}"
    component="${2}"
    process_id="${3}"

    application="historic_data_importer"

    app_version="NOT_SET"
    if [ -f "/opt/historic_data_importer/version" ]; then
        app_version=$(cat /opt/historic_data_importer/version)
    fi

    log_level="NOT_SET"
    if [ -f "/opt/historic_data_importer/log_level" ]; then
        log_level=$(cat /opt/historic_data_importer/log_level)
    fi

    environment="NOT_SET"
    if [ -f "/opt/historic_data_importer/environment" ]; then
        environment=$(cat /opt/historic_data_importer/environment)
    fi

    log_message "${message}" "${log_level}" "${app_version}" "${process_id}" "${application}" "${component}" "${environment}" "${@:4}"
}
