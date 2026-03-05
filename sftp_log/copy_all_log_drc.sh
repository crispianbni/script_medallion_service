#!/bin/bash

###############################################################################
# Script Name  : copy_all_log_drc.sh
# Description  : Script untuk menyalin log medallion dari server APP dan WEB, REPORT ke local
# Author       : Crispian | 901146
# Division     : IT Application Services
# Last Update  : 24-02-2026
###############################################################################

REMOTE_HOST_WEB="192.168.230.23" # WEB1
REMOTE_HOST_RPT="192.168.231.55" # RPT1
SOURCE_FILE="/home/medallion/monitoring/automation/output_sftp_log/*.log"
LOCAL_DIR="/home/medallion/monitoring/automation/output_sftp_log/all/"

# Buat directory jika belum ada
mkdir -p "$LOCAL_DIR"

cp "$SOURCE_FILE" "$LOCAL_DIR"

sftp $REMOTE_HOST_WEB <<EOF
get $SOURCE_FILE $LOCAL_DIR
bye
EOF

sftp $REMOTE_HOST_RPT <<EOF
get $SOURCE_FILE $LOCAL_DIR
bye
EOF

# Validasi hasil
if [ $? -eq 0 ]; then
    echo "SUCCESS: server.log berhasil ditarik ke $LOCAL_DIR"
else
    echo "FAILED: Gagal menarik server.log"
fi