#!/bin/bash

###############################################################################
# Script Name  : monitoring_path_downloadgeneral.sh
# Description  : Monitoring file baru pada path downloadgeneral
# Author       : Crispian | 901146
# Division     : IT Application Services
# Last Update  : 02-03-2026
###############################################################################

set -euo pipefail

# =======================
# CONFIGURATION
# =======================
MONITOR_PATH="/opt/MedallionFiles/download/general/"
LOG_DIR="/home/medallion/monitoring/App/output_monitoring_logs_aux/"
STATE_FILE="${LOG_DIR}/.downloadgeneral_last_state"
LOG_FILE="${LOG_DIR}/monitoring_path_downloadgeneral.log"
SLEEP_INTERVAL=60
LAST_TODAY=""

log_message() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "${timestamp} | ${level} | ${message}" >> "${LOG_FILE}"
}

initialize_state() {
    if [[ ! -f "${STATE_FILE}" ]]; then
        ls -1 "${MONITOR_PATH}" 2>/dev/null | sort > "${STATE_FILE}" || true
        log_message "INFO" "Initial state created"
    fi
}

check_and_log_new_files() {
    local current_list
    current_list=$(mktemp)
    trap 'rm -f "${current_list}"' RETURN

    ls -1 "${MONITOR_PATH}" 2>/dev/null | sort > "${current_list}" || true

    local new_files
    new_files=$(comm -13 "${STATE_FILE}" "${current_list}")

    if [[ -n "${new_files}" ]]; then
        while read -r file; do
            log_message "downloadgeneral" "${MONITOR_PATH}/${file}"
        done <<< "${new_files}"
    fi

    mv "${current_list}" "${STATE_FILE}"
}

handle_day_change() {
    local today
    today=$(date +"%Y-%m-%d")

    if [[ "${today}" != "${LAST_TODAY}" ]]; then
        rm -f "${LOG_FILE}"
        LAST_TODAY="${today}"
    fi
}

trap 'log_message "INFO" "Service stopped"; exit 0' SIGTERM SIGINT

mkdir -p "${LOG_DIR}"

LAST_TODAY=$(date +"%Y-%m-%d")
initialize_state

while true; do
    handle_day_change
    check_and_log_new_files
    sleep "${SLEEP_INTERVAL}"
done