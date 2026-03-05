# Script Medallion Service

![Version](https://img.shields.io/badge/version-1.0-blue)
![License](https://img.shields.io/badge/license-Private-red)
![Status](https://img.shields.io/badge/status-Production-green)

This repository contains a collection of Linux scripts used for automation and monitoring in the Medallion service. These scripts are designed to enhance operational efficiency and system reliability.

---
🌐 **Languages:**
- 🇬🇧 English (default)
- 🇮🇩 [Bahasa Indonesia](README.id.md)
- 🇩🇪 [Deutsch](README.de.md)

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation & Setup](#installation--setup)
- [Directory Structure](#directory-structure)
- [Script Descriptions](#script-descriptions)
- [Usage Guide](#usage-guide)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Support & Contact](#support--contact)

---

## 📌 Overview

This project is a collection of Linux automation and monitoring scripts to support the operational reliability of the Medallion service. These scripts are designed to:

- ✅ Compare data integrity between DC and DRC
- ✅ Perform automatic log backup and rotation
- ✅ Monitor file changes in critical directories
- ✅ Provide real-time reports for operational purposes

---

## 🔧 Prerequisites

Before running these scripts, ensure that:

- **Operating System**: Linux (Red Hat, CentOS, Debian, or other distributions)
- **Shell**: Bash 4.0 or newer
- **Required Tools**:
  - `awk` - for text processing
  - `grep` - for pattern matching
  - `date` - for timestamp generation
  - `tail` - for log monitoring
  - `ls`, `mkdir`, `mv` - basic Linux utilities
- **Access**: Root or sudo access for monitored directories
- **Disk Space**: Sufficient disk space for backup and log files

---

## 📦 Installation & Setup

### Step 1: Clone or Download Repository
```bash
cd /home/oracle/scripts/automation/
git clone <repository-url>
cd script_medallion_service
```

### Step 2: Set Permissions
```bash
# Grant execute permission to all scripts
chmod +x compare_count_table/compare_count_table.sh
chmod +x medallionpentahoreport_daily/medallionPentahoReport_daily.sh.sh
chmod +x monitoring_path_reportloaderoutput/monitoring_path_reportloaderoutput.sh

# Create output directories if they don't exist
mkdir -p compare_count_table/output
mkdir -p medallionpentahoreport_daily/output
mkdir -p monitoring_path_reportloaderoutput/output
```

### Step 3: Configure Paths and Variables
Customize the paths and variables in each script to match your environment (see [Configuration](#configuration) section).

### Step 4: Setup with Cron (Optional)
To run scripts periodically, add them to crontab:

```bash
# Edit crontab
crontab -e

# Example: Run compare_count_table every day at 6 AM
0 6 * * * /opt/script_medallion_service/compare_count_table/compare_count_table.sh

# Example: Monitor report loader 24/7 (background service)
0 0 * * * /opt/script_medallion_service/medallionpentahoreport_daily/medallionPentahoReport_daily.sh.sh &

# Example: Monitor path every 1 minute
* * * * * /opt/script_medallion_service/monitoring_path_reportloaderoutput/monitoring_path_reportloaderoutput.sh &
```

---

## 📂 Directory Structure

```
script_medallion_service/
│
├── README.md.idn                          # Indonesian Documentation
├── README.md.eng                          # English Documentation
│
├── compare_count_table/                   # DC vs DRC Comparison Module
│   ├── compare_count_table.sh             # Main script
│   ├── source/                            # Input CSV files directory
│   │   ├── output_count_table_dc.csv      # Data Center count data
│   │   └── output_count_table_drc.csv     # Disaster Recovery Center count data
│   └── output/                            # Report output directory
│       └── hasil_compare_dc_drc.txt       # Comparison report output
│
├── medallionpentahoreport_daily/          # Pentaho Log Monitoring Module
│   ├── medallionPentahoReport_daily.sh.sh # Main script (note: double extension)
│   ├── source/                            # Source log directory
│   └── output/                            # Log backup directory
│       └── medallionPentahoReport_Today.log
│       └── medallionPentahoReport_DD_MM_YYYY.log
│
└── monitoring_path_reportloaderoutput/    # Directory Monitoring Module
    ├── monitoring_path_reportloaderoutput.sh  # Main script
    ├── filebeat.yml                           # Filebeat configuration
    ├── monitoring_logs_aux.service            # Systemd service file
    ├── run_all_monitoring.sh                  # Script to run all monitoring
    └── output/                                # Monitoring log output directory
        └── monitoring_path_reportloaderoutput.log

├── monitoring_path_downloadgeneral/          # Download general directory monitoring module
│   ├── monitoring_path_downloadgeneral.sh    # Main script
│   ├── filebeat.yml                          # Filebeat configuration
│   ├── monitoring_logs_aux.service           # Systemd service file
│   ├── run_all_monitoring.sh                 # Script to run all monitoring
│   └── output/                               # Monitoring log output directory
│       └── monitoring_path_downloadgeneral.log

└── sftp_log/                                # SFTP log transfer module
    ├── copy_log_app_dc.sh                # pull APP DC log (local+remote)
    ├── copy_log_app_drc.sh               # pull APP DRC log (local+remote)
    ├── copy_log_rpt_dc.sh                # pull report DC log (local+remote)
    ├── copy_log_rpt_drc.sh               # pull report DRC log (local+remote)
    ├── copy_log_web_dc.sh                # pull web DC log (local+remote)
    ├── copy_log_web_drc.sh               # pull web DRC log (local+remote)
    ├── credential_nas                    # credentials for NAS access
    └── sftp_to_nas                       # placeholder script (empty)
    └── output/                            # Monitoring log output directory
        └── monitoring_path_reportloaderoutput.log
```

---

## 🚀 Script Descriptions

### 1. compare_count_table.sh

**Purpose**: Compare table count results between Data Center (DC) and Disaster Recovery Center (DRC) to ensure data integrity.

**Main Functions**:
- Read two CSV files (count results from DC and DRC)
- Compare LASTKEY and record count for each table
- Generate formatted report with MATCH/NOT MATCH status

**Input**:
- `output_count_table_dc.csv` - Count file from DC
- `output_count_table_drc.csv` - Count file from DRC

**Output**:
- `hasil_compare_dc_drc.txt` - Comparison report in table format

**Technical Information**:
- **Author**: Crispian | 901146
- **Last Update**: 04-02-2026
- **Runtime**: ~5 minutes (depends on data size)

**Sample Output**:
```
                                                    SO SB Medallion 2026
                                                    Tanggal : 11/02/2026

+--------------------+-----+--------+--------------------+-----+--------+----------+
|        DC          | JML | TABEL  |        DRC         | JML | TABEL  |   KET    |
+--------------------+-----+--------+--------------------+-----+--------+----------+
| 12345678           | 1000| TABLE1 | 12345678           | 1000| TABLE1 | MATCH    |
| 12345679           | 2000| TABLE2 | 12345679           | 2000| TABLE2 | MATCH    |
| 12345680           | 1500| TABLE3 | -                  | -   | -      | N/A      |
```

---

### 2. medallionPentahoReport_daily.sh.sh

**Purpose**: Monitor and backup MedallionPentahoReport log file in real-time with automatic daily rotation.

**Main Functions**:
- Monitor source log file in real-time (tail -F)
- Perform automatic log rotation when day changes
- Separate logs by date (Today and Yesterday)
- Backup logs for analysis and debugging purposes

**Input**:
- `medallionPentahoReport.log` - Source log file from Pentaho service

**Output**:
- `medallionPentahoReport_Today.log` - Today's log
- `medallionPentahoReport_DD_MM_YYYY.log` - Previous day's log (archived)

**Technical Information**:
- **Author**: Crispian | 901146
- **Last Update**: 20-10-2025
- **Mode**: Continuous service (run in background)

**Special Features**:
- ✅ Automatic day-change detection
- ✅ Automatic log rotation without downtime
- ✅ Duplicate prevention for identical logs
- ✅ Safety check with date filtering

---

### 3. monitoring_path_reportloaderoutput.sh

**Purpose**: Continuously monitor the `reportloaderoutput` directory and log every new file that appears with full timestamp.

**Main Functions**:
- Monitor target directory at regular intervals
- Detect new files using file state comparison
- Log new file information with timestamp
- Automatically reset log on day change

**Input**:
- Monitor path: `/opt/MedallionFiles/data/reportloaderoutput/`

**Output**:
- `monitoring_path_reportloaderoutput.log` - Monitoring log file

**Technical Information**:
- **Author**: Crispian | 901146
- **Last Update**: 15-12-2025
- **Check Interval**: 60 seconds (configurable)
- **Mode**: Continuous service (run in background)

**Log Output Format**:
```
2026-02-11 10:30:45 | reportloaderoutput | /opt/MedallionFiles/data/reportloaderoutput/file_new_001.txt
2026-02-11 10:31:02 | reportloaderoutput | /opt/MedallionFiles/data/reportloaderoutput/file_new_002.xml
2026-02-11 10:35:18 | INFO | Initial state created
```

### 4. monitoring_path_downloadgeneral.sh

**Purpose**: Continuously monitor the `downloadgeneral` directory and log every new file that appears with full timestamp.

**Main Functions**:
- Monitor target directory at regular intervals
- Detect new files using file state comparison
- Log new file information with timestamp
- Automatically reset log on day change

**Input**:
- Monitor path: `/opt/MedallionFiles/download/general/`

**Output**:
- `monitoring_path_downloadgeneral.log` - Monitoring log file

**Technical Information**:
- **Author**: Crispian | 901146
- **Last Update**: 02-03-2026
- **Check Interval**: 60 seconds (configurable)
- **Mode**: Continuous service (run in background)

**Log Output Format**:
```
2026-03-05 10:30:45 | downloadgeneral | /opt/MedallionFiles/download/general/file_new_001.txt
2026-03-05 10:31:02 | downloadgeneral | /opt/MedallionFiles/download/general/file_new_002.xml
2026-03-05 10:35:18 | INFO | Initial state created
```

### 5. sftp_log module (SFTP log transfer)

**Purpose**: Fetch important log files from local and remote servers (APP, REPORT, WEB) using SFTP for monitoring and analysis.

**Scripts included**:
- `copy_log_app_dc.sh` / `copy_log_app_drc.sh` – pull `medallionServer.log` from APP DC/DRC servers
- `copy_log_rpt_dc.sh` / `copy_log_rpt_drc.sh` – pull `medallionPentahoReport_Today.log` from Report DC/DRC servers
- `copy_log_web_dc.sh` / `copy_log_web_drc.sh` – pull `medallionWeb.log` from WEB DC/DRC servers
- `credential_nas` – contains NAS credentials for later transfer
- `sftp_to_nas` – placeholder script (currently empty)

**Main Functions**:
- Create destination directory (`/home/medallion/monitoring/automation/output_sftp_log/`) if missing
- Copy local log file to destination directory
- Establish SFTP connection to remote host and download remote log
- Validate operation status and print SUCCESS/FAILED

**Technical Information**:
- **Author**: Crispian | 901146
- **Last Update**: 23-02-2026 (varies per script)
- **Key Variables**: `REMOTE_HOST`, `SOURCE_FILE`, `LOCAL_DIR`, `LOCAL_NAME1`, `LOCAL_NAME2`

**Notes**:
- Ensure SFTP connectivity between local and remote hosts is configured (SSH keys or passwordless).
- Edit `credential_nas` to provide NAS access if needed.


---

## 💻 Usage Guide

### Running compare_count_table.sh
```bash
# Run once
./compare_count_table/compare_count_table.sh

# Check results
cat compare_count_table/output/hasil_compare_dc_drc.txt

# Run via cron (every day at 6 AM)
0 6 * * * /path/to/script/compare_count_table/compare_count_table.sh
```

### Running medallionPentahoReport_daily.sh.sh
```bash
# Run in foreground
./medallionpentahoreport_daily/medallionPentahoReport_daily.sh.sh

# Run in background using nohup
nohup ./medallionpentahoreport_daily/medallionPentahoReport_daily.sh.sh > /tmp/pentaho_monitor.log 2>&1 &

# Run as systemd service (recommended)
# Create file /etc/systemd/system/medallion-pentaho.service
sudo systemctl start medallion-pentaho
sudo systemctl enable medallion-pentaho

# Check status
ps aux | grep medallionPentahoReport
```

### Running monitoring_path_reportloaderoutput.sh
```bash
# Run in background
nohup ./monitoring_path_reportloaderoutput/monitoring_path_reportloaderoutput.sh &

# Or use systemd
sudo systemctl start medallion-monitor
sudo systemctl enable medallion-monitor

# Monitor in real-time
tail -f /home/medallion/monitoring/App/output_monitoring_logs_aux/monitoring_path_reportloaderoutput.log

# Stop monitoring
killall monitoring_path_reportloaderoutput.sh
```

### Running monitoring_path_downloadgeneral.sh
```bash
# Run in background
nohup ./monitoring_path_downloadgeneral/monitoring_path_downloadgeneral.sh &

# Or use systemd
sudo systemctl start medallion-monitor-downloadgeneral
sudo systemctl enable medallion-monitor-downloadgeneral

# Monitor in real-time
tail -f /home/medallion/monitoring/App/output_monitoring_logs_aux/monitoring_path_downloadgeneral.log

# Stop monitoring
killall monitoring_path_downloadgeneral.sh
```

### Running sftp_log scripts
```bash
# example: pull application log from DC
./sftp_log/copy_log_app_dc.sh

# example: pull web log from DRC
./sftp_log/copy_log_web_drc.sh

# outputs are stored under "/home/medallion/monitoring/automation/output_sftp_log/"
# check STDOUT for SUCCESS/FAILED messages

# customize NAS credentials (if used)
# edit sftp_log/credential_nas before running upload scripts
```

---

## ⚙️ Configuration

### compare_count_table.sh
Edit the following section to match your environment:
```bash
# Location of input CSV files
DC_FILE="/home/oracle/scripts/automation/output_count/output_count_table_dc.csv"
DRC_FILE="/home/oracle/scripts/automation/output_count/output_count_table_drc.csv"
OUT_FILE="/home/oracle/scripts/automation/output_count/hasil_compare_dc_drc.txt"
```

### medallionPentahoReport_daily.sh.sh
Edit directories to match your server configuration:
```bash
# Source log directory
LOG_DIR="/opt/MedallionLog/server/"

# Backup directory
BACKUP_DIR="/opt/MedallionLog/server/"

# Name of log file to monitor
SOURCE_LOG="medallionPentahoReport.log"
TODAY_FILE="medallionPentahoReport_Today.log"
```

### monitoring_path_reportloaderoutput.sh
Customize path and monitoring interval:
```bash
# Directory to monitor
MONITOR_PATH="/opt/MedallionFiles/data/reportloaderoutput/"

# Directory for logs
LOG_DIR="/home/medallion/monitoring/App/output_monitoring_logs_aux/"

# Check interval in seconds (default: 60)
SLEEP_INTERVAL=60
```

### monitoring_path_downloadgeneral.sh
Customize path and monitoring interval:
```bash
# Directory to monitor
MONITOR_PATH="/opt/MedallionFiles/download/general/"

# Directory for logs
LOG_DIR="/home/medallion/monitoring/App/output_monitoring_logs_aux/"

# Check interval in seconds (default: 60)
SLEEP_INTERVAL=60
```

### sftp_log scripts
Edit connection variables and paths as needed:
```bash
# Remote host IP (adjust for DC/DRC)
REMOTE_HOST="192.168.x.x"

# Location of log file on server
SOURCE_FILE="/opt/MedallionLog/server/medallionServer.log"

# Local directory to hold results
LOCAL_DIR="/home/medallion/monitoring/automation/output_sftp_log/"

# Local filenames for local and remote copy
LOCAL_NAME1="medallionServer_1.log"
LOCAL_NAME2="medallionServer_2.log"
```

# To enable NAS uploads, modify
# `sftp_log/credential_nas` with valid credentials.

---

## 🔍 Troubleshooting

### compare_count_table.sh Issues

**Problem**: CSV files not found
```bash
# Solution: Verify file paths
ls -la /home/oracle/scripts/automation/output_count/
# If missing, create dummy files for testing
```

**Problem**: Output file not generated
```bash
# Check permissions
ls -l output/
chmod 755 output/

# Run script with verbose mode
bash -x compare_count_table.sh
```

**Problem**: Output format is incorrect
```bash
# Ensure awk is available
which awk
awk --version
```

---

### medallionPentahoReport_daily.sh.sh Issues

**Problem**: Script error "Source log not found"
```bash
# Verify LOG_DIR path is correct
ls -la /opt/MedallionLog/server/medallionPentahoReport.log

# Check permissions
file /opt/MedallionLog/server/medallionPentahoReport.log
```

**Problem**: Log rotation is not occurring
```bash
# Check file modification date
ls -l /opt/MedallionLog/server/medallionPentahoReport_Today.log
date

# Test manual rotation
stat /opt/MedallionLog/server/medallionPentahoReport_Today.log
```

**Problem**: High memory/CPU usage
```bash
# Script uses tail -F which runs continuously
# This is normal when there's log activity
# To optimize, use systemd service with resource limits:

[Service]
MemoryLimit=512M
CPUQuota=50%
```

---

### monitoring_path_reportloaderoutput.sh Issues

**Problem**: Log directory not found
```bash
# Create directory manually
sudo mkdir -p /home/medallion/monitoring/App/output_monitoring_logs_aux/
sudo chown medallion:medallion /home/medallion/monitoring/App/output_monitoring_logs_aux/
```

**Problem**: Permission denied on log file
```bash
# Check permissions
ls -la /home/medallion/monitoring/App/output_monitoring_logs_aux/
chmod 755 /home/medallion/monitoring/App/output_monitoring_logs_aux/
```

**Problem**: Script stops unexpectedly
```bash
# Check for errors
tail -100 /home/medallion/monitoring/App/output_monitoring_logs_aux/monitoring_path_reportloaderoutput.log

# Run with error handling
bash -x monitoring_path_reportloaderoutput.sh 2>&1 | tee debug.log
```

### monitoring_path_downloadgeneral.sh Issues

**Problem**: Log directory not found
```bash
# Create directory manually
sudo mkdir -p /home/medallion/monitoring/App/output_monitoring_logs_aux/
sudo chown medallion:medallion /home/medallion/monitoring/App/output_monitoring_logs_aux/
```

**Problem**: Permission denied on log file
```bash
# Check permissions
ls -la /home/medallion/monitoring/App/output_monitoring_logs_aux/
chmod 755 /home/medallion/monitoring/App/output_monitoring_logs_aux/
```

**Problem**: Script stops unexpectedly
```bash
# Check for errors
tail -100 /home/medallion/monitoring/App/output_monitoring_logs_aux/monitoring_path_downloadgeneral.log

# Run with error handling
bash -x monitoring_path_downloadgeneral.sh 2>&1 | tee debug.log
```

---

## 📋 Maintenance & Best Practices

### Regular Maintenance
- ✅ **Check log file size** monthly, rotate if too large
- ✅ **Archive old CSV files** to save disk space
- ✅ **Update script paths** if directories change
- ✅ **Test scripts** in test environment before production

### Best Practices
1. **Backup Configuration**
   ```bash
   # Backup script configuration
   cp -r script_medallion_service script_medallion_service.backup
   ```

2. **Error Notification** (Optional)
   ```bash
   # Add email notification on error
   if [ $? -ne 0 ]; then
       echo "Error running script" | mail -s "Alert: Medallion Script Error" admin@company.com
   fi
   ```

3. **Log Rotation** (use logrotate)
   ```bash
   # /etc/logrotate.d/medallion-scripts
   /home/medallion/monitoring/App/output_monitoring_logs_aux/*.log {
       daily
       rotate 30
       compress
       delaycompress
       notifempty
       create 0755 medallion medallion
   }
   ```

4. **Version Control**
   ```bash
   # Commit changes with clear messages
   git add .
   git commit -m "Update script version with bug fix"
   git push
   ```

---

## 📞 Support & Contact

### Author Information
- **Name**: Crispian
- **Employee ID**: 901146
- **Division**: IT Application Services

### For Questions & Issues
1. Contact the author directly
2. Submit issues to the repository
3. Contact IT Application Services

### Documentation & References
- [Bash Script Guide](https://www.gnu.org/software/bash/manual/)
- [Linux System Administration](https://linux.die.net/)
- [Cron Tutorial](https://linux.die.net/man/5/crontab)

---

## 📝 License

Proprietary Software - All Rights Reserved

Use of these scripts is limited to internal company purposes only. Distribution or use without IT department approval is prohibited.

---

## 📊 Changelog

### Version 1.0 - 2026-02-11
- Initial release
- 3 production scripts
- Complete documentation

---

**Last Updated**: February 11, 2026  
**Maintained By**: IT Application Services
