#!/bin/bash

###############################################################################
# Script Name  : copy_log_app_dc.sh
# Description  : Script untuk menyalin log medallionServer.log dari local dan server APP 2
# Author       : Crispian | 901146
# Division     : IT Application Services
# Last Update  : 23-02-2026
###############################################################################

REMOTE_HOST="192.168.92.107" # APP 2
SOURCE_FILE="/opt/MedallionLog/server/medallionServer.log"
LOCAL_DIR="/home/medallion/monitoring/automation/output_sftp_log/"
LOCAL_NAME1="medallionServer_1.log"
LOCAL_NAME2="medallionServer_2.log"

# Buat directory jika belum ada
mkdir -p "$LOCAL_DIR"

cp "$SOURCE_FILE" "$LOCAL_DIR/$LOCAL_NAME1"

sftp $REMOTE_HOST <<EOF
get $SOURCE_FILE $LOCAL_DIR/$LOCAL_NAME2
bye
EOF

# Validasi hasil
if [ $? -eq 0 ]; then
    echo "SUCCESS: server.log berhasil ditarik ke $LOCAL_DIR"
else
    echo "FAILED: Gagal menarik server.log"
fi