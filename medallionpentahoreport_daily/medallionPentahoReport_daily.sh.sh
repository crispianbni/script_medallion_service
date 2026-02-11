#!/bin/bash

###############################################################################
# Script Name  : medallionPentahoReport_daily.sh
# Description  : Script untuk Backup MedallionPentahoReport.Log(Today dan Yesterday)
# Author       : Crispian | 901146
# Division     : IT Application Services
# Last Update  : 20-10-2025
###############################################################################

# Direktori Log dan Backup
LOG_DIR="/opt/MedallionLog/server/"
BACKUP_DIR="/opt/MedallionLog/server/"

# Nama file log sumber (ubah jika perlu)
SOURCE_LOG="medallionPentahoReport.log"
TODAY_FILE="medallionPentahoReport_Today.log"

mkdir -p "${BACKUP_DIR}"

# Periksa apakah file sumber ada
if [ ! -f "${LOG_DIR}${SOURCE_LOG}" ]; then
        echo "Source log not found: ${LOG_DIR}${SOURCE_LOG}" >&2
        exit 1
fi

# Function: rotate today file if its modification date is not today
rotate_log_if_needed() {
        if [ -f "${BACKUP_DIR}${TODAY_FILE}" ]; then
                TODAY=$(date +%Y-%m-%d)
                # Use date -r to read file modification timestamp (Linux)
                FILE_DATE=$(date -r "${BACKUP_DIR}${TODAY_FILE}" +%Y-%m-%d)
                if [ "${FILE_DATE}" != "${TODAY}" ]; then
                        TARGET_DATE=$(date -r "${BACKUP_DIR}${TODAY_FILE}" +%d_%m_%Y)
                        TARGET_NAME="medallionPentahoReport_${TARGET_DATE}.log"
                        COUNTER=1
                        BASE_TARGET="${BACKUP_DIR}${TARGET_NAME}"
                        NEW_TARGET="${BASE_TARGET}"
                        while [ -f "${NEW_TARGET}" ]; do
                                NEW_TARGET="${BASE_TARGET%.log}_$COUNTER.log"
                                COUNTER=$((COUNTER + 1))
                        done
                        mv "${BACKUP_DIR}${TODAY_FILE}" "${NEW_TARGET}"
                        echo "Rotated ${TODAY_FILE} -> ${NEW_TARGET}"
                fi
        fi
}

# Pastikan rotasi dijalankan sekali saat startup agar log kemarin tidak bercampur
rotate_log_if_needed

# File sumber yang akan dipantau (full path)
SRC_LOG="${LOG_DIR}${SOURCE_LOG}"

echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - Starting realtime monitoring for ${SRC_LOG}..."
tail -F "${SRC_LOG}" | while IFS= read -r line; do
        # Periksa apakah perlu rotasi sebelum menulis (untuk pergantian hari saat running)
        rotate_log_if_needed

        # Simpan baris jika mengandung tanggal hari ini (safety)
        if echo "$line" | grep -q "^$(date +%Y-%m-%d)"; then
                echo "$line" >> "${BACKUP_DIR}${TODAY_FILE}"
        fi
done
