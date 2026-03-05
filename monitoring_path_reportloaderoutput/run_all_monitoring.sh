#!/bin/bash

# aktifkan semua script monitoring di background
/home/medallion/monitoring/App/monitoring_path_sftp.sh &
/home/medallion/monitoring/App/monitoring_path_reportloaderoutput.sh &
/home/medallion/monitoring/App/monitoring_path_downloadgeneral.sh &

# Tunggu semua background process (opsional, supaya script wrapper tidak exit)
wait
