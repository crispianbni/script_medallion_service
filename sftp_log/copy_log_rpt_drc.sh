#!/bin/bash

###############################################################################
# Script Name  : copy_log_rpt_drc.sh
# Description  : Script untuk menyalin log medallionPentahoReport_Today.log dari local dan server APP 2
# Author       : Crispian | 901146
# Division     : IT Application Services
# Last Update  : 23-02-2026
###############################################################################

REMOTE_HOST="192.168.231.105" # Report 2
SOURCE_FILE="/opt/MedallionLog/server/medallionPentahoReport_Today.log"
LOCAL_DIR="/home/medallion/monitoring/automation/output_sftp_log/"
LOCAL_NAME1="medallionPentahoReport_1.log"
LOCAL_NAME2="medallionPentahoReport_2.log"

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