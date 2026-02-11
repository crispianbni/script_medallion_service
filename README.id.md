# Script Medallion Service

![Version](https://img.shields.io/badge/version-1.0-blue)
![License](https://img.shields.io/badge/license-Private-red)
![Status](https://img.shields.io/badge/status-Production-green)

Repositori ini berisi koleksi script Linux yang digunakan untuk automation dan monitoring pada layanan Medallion. Script-script ini dirancang untuk meningkatkan efisiensi operasional dan reliabilitas sistem.

---
🌐 **Languages:**
- 🇮🇩 Bahasa Indonesia
- 🇬🇧 [English](README.md)

## 📋 Daftar Isi

- [Ringkasan](#ringkasan)
- [Prasyarat](#prasyarat)
- [Instalasi & Setup](#instalasi--setup)
- [Struktur Direktori](#struktur-direktori)
- [Deskripsi Script](#deskripsi-script)
- [Cara Penggunaan](#cara-penggunaan)
- [Konfigurasi](#konfigurasi)
- [Troubleshooting](#troubleshooting)
- [Kontak & Dukungan](#kontak--dukungan)

---

## 📌 Ringkasan

Proyek ini merupakan kumpulan script automation dan monitoring Linux untuk mendukung operasional layanan Medallion. Script-script ini didesain untuk:

- ✅ Membandingkan integritas data antara DC dan DRC
- ✅ Melakukan backup dan rotasi log secara otomatis
- ✅ Memonitor perubahan file pada direktori critical
- ✅ Memberikan laporan real-time untuk keperluan operational

---

## 🔧 Prasyarat

Sebelum menjalankan script ini, pastikan:

- **Sistem Operasi**: Linux (Red Hat, CentOS, Debian, atau distribusi lain)
- **Shell**: Bash 4.0 atau lebih baru
- **Tools yang diperlukan**:
  - `awk` - untuk text processing
  - `grep` - untuk pattern matching
  - `date` - untuk timestamp
  - `tail` - untuk monitoring log
  - `ls`, `mkdir`, `mv` - utilitas dasar Linux
- **Akses**: Akses root atau sudo untuk direktori yang dijaga
- **Disk Space**: Ruang disk yang cukup untuk menyimpan backup dan log files

---

## 📦 Instalasi & Setup

### Step 1: Clone atau Download Repository
```bash
cd /home/oracle/scripts/automation/
git clone <repository-url>
cd script_medallion_service
```

### Step 2: Set Permissions
```bash
# Berikan permission execute ke semua script
chmod +x compare_count_table/compare_count_table.sh
chmod +x medallionpentahoreport_daily/medallionPentahoReport_daily.sh.sh
chmod +x monitoring_path_reportloaderoutput/monitoring_path_reportloaderoutput.sh

# Buat direktori output jika belum ada
mkdir -p compare_count_table/output
mkdir -p medallionpentahoreport_daily/output
mkdir -p monitoring_path_reportloaderoutput/output
```

### Step 3: Konfigurasi Path dan Variabel
Sesuaikan path dan variabel pada setiap script dengan environment Anda (lihat bagian [Konfigurasi](#konfigurasi)).

### Step 4: Setup dengan Cron (Opsional)
Untuk menjalankan script secara berkala, tambahkan ke crontab:

```bash
# Edit crontab
crontab -e

# Contoh: Jalankan compare_count_table setiap hari jam 6 pagi
0 6 * * * /opt/script_medallion_service/compare_count_table/compare_count_table.sh

# Contoh: Monitor report loader setiap saat (background service)
0 0 * * * /opt/script_medallion_service/medallionpentahoreport_daily/medallionPentahoReport_daily.sh.sh &

# Contoh: Monitor path setiap 1 menit
* * * * * /opt/script_medallion_service/monitoring_path_reportloaderoutput/monitoring_path_reportloaderoutput.sh &
```

---

## 📂 Struktur Direktori

```
script_medallion_service/
│
├── README.md.idn                          # Dokumentasi Bahasa Indonesia
├── README.md.eng                          # Dokumentasi Bahasa Inggris
│
├── compare_count_table/                   # Modul perbandingan DC vs DRC
│   ├── compare_count_table.sh             # Script utama
│   ├── source/                            # Direktori input file CSV
│   │   ├── output_count_table_dc.csv      # Data dari Data Center
│   │   └── output_count_table_drc.csv     # Data dari Disaster Recovery Center
│   └── output/                            # Direktori hasil laporan
│       └── hasil_compare_dc_drc.txt       # Output laporan perbandingan
│
├── medallionpentahoreport_daily/          # Modul monitoring Pentaho Log
│   ├── medallionPentahoReport_daily.sh.sh # Script utama (perhatian: double extension)
│   ├── source/                            # Direktori sumber log
│   └── output/                            # Direktori backup log
│       └── medallionPentahoReport_Today.log
│       └── medallionPentahoReport_DD_MM_YYYY.log
│
└── monitoring_path_reportloaderoutput/    # Modul monitoring direktori
    ├── monitoring_path_reportloaderoutput.sh  # Script utama
    └── output/                            # Direktori output log monitoring
        └── monitoring_path_reportloaderoutput.log
```

---

## 🚀 Deskripsi Script

### 1. compare_count_table.sh

**Tujuan**: Membandingkan hasil count table antara Data Center (DC) dan Disaster Recovery Center (DRC) untuk memastikan integritas data.

**Fungsi Utama**:
- Membaca dua file CSV (hasil count dari DC dan DRC)
- Membandingkan LASTKEY dan jumlah record setiap table
- Menghasilkan laporan formatted dengan status MATCH/NOT MATCH

**Input**:
- `output_count_table_dc.csv` - File count dari DC
- `output_count_table_drc.csv` - File count dari DRC

**Output**:
- `hasil_compare_dc_drc.txt` - Laporan perbandingan dalam format tabel

**Informasi Teknis**:
- **Author**: Crispian | 901146
- **Last Update**: 04-02-2026
- **Runtime**: ~5 menit (tergantung ukuran data)

**Contoh Output**:
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

**Tujuan**: Memonitor dan mem-backup log file MedallionPentahoReport secara real-time dengan rotasi harian otomatis.

**Fungsi Utama**:
- Monitor file log source secara real-time (tail -F)
- Lakukan rotasi log otomatis saat pergantian hari
- Separasi log berdasarkan tanggal (Today dan Yesterday)
- Backup log untuk keperluan analysis dan debugging

**Input**:
- `medallionPentahoReport.log` - Sumber log file dari Pentaho service

**Output**:
- `medallionPentahoReport_Today.log` - Log hari ini
- `medallionPentahoReport_DD_MM_YYYY.log` - Log hari sebelumnya (diarsipkan)

**Informasi Teknis**:
- **Author**: Crispian | 901146
- **Last Update**: 20-10-2025
- **Mode**: Continuous service (run di background)

**Fitur Khusus**:
- ✅ Deteksi otomatis pergantian hari
- ✅ Rotasi log otomatis tanpa downtime
- ✅ Duplicate prevention untuk log yang sama
- ✅ Safety check untuk filter tanggal

---

### 3. monitoring_path_reportloaderoutput.sh

**Tujuan**: Memonitor direktori `reportloaderoutput` secara kontinyu dan mencatat setiap file baru yang muncul dengan timestamp lengkap.

**Fungsi Utama**:
- Monitor direktori target setiap interval waktu
- Deteksi file baru menggunakan file state comparison
- Catat informasi file baru ke log dengan timestamp
- Reset log otomatis saat pergantian hari

**Input**:
- Monitor path: `/opt/MedallionFiles/data/reportloaderoutput/`

**Output**:
- `monitoring_path_reportloaderoutput.log` - Log file monitoring

**Informasi Teknis**:
- **Author**: Crispian | 901146
- **Last Update**: 15-12-2025
- **Check Interval**: 60 detik (dapat dikonfigurasi)
- **Mode**: Continuous service (run di background)

**Format Log Output**:
```
2026-02-11 10:30:45 | reportloaderoutput | /opt/MedallionFiles/data/reportloaderoutput/file_baru_001.txt
2026-02-11 10:31:02 | reportloaderoutput | /opt/MedallionFiles/data/reportloaderoutput/file_baru_002.xml
2026-02-11 10:35:18 | INFO | Initial state created
```

---

## 💻 Cara Penggunaan

### Menjalankan compare_count_table.sh
```bash
# Jalan satu kali saja
./compare_count_table/compare_count_table.sh

# Cek hasil
cat compare_count_table/output/hasil_compare_dc_drc.txt

# Jalankan via cron (setiap hari jam 6 pagi)
0 6 * * * /path/to/script/compare_count_table/compare_count_table.sh
```

### Menjalankan medallionPentahoReport_daily.sh.sh
```bash
# Jalankan di background (foreground mode)
./medallionpentahoreport_daily/medallionPentahoReport_daily.sh.sh

# Jalankan di background menggunakan nohup
nohup ./medallionpentahoreport_daily/medallionPentahoReport_daily.sh.sh > /tmp/pentaho_monitor.log 2>&1 &

# Jalankan menggunakan systemd service (recommended)
# Buat file /etc/systemd/system/medallion-pentaho.service
sudo systemctl start medallion-pentaho
sudo systemctl enable medallion-pentaho

# Cek status
ps aux | grep medallionPentahoReport
```

### Menjalankan monitoring_path_reportloaderoutput.sh
```bash
# Jalankan di background
nohup ./monitoring_path_reportloaderoutput/monitoring_path_reportloaderoutput.sh &

# Atau gunakan systemd
sudo systemctl start medallion-monitor
sudo systemctl enable medallion-monitor

# Monitor real-time
tail -f /home/medallion/monitoring/App/output_monitoring_logs_aux/monitoring_path_reportloaderoutput.log

# Hentikan monitoring
killall monitoring_path_reportloaderoutput.sh
```

---

## ⚙️ Konfigurasi

### compare_count_table.sh
Edit bagian berikut sesuai dengan lingkungan Anda:
```bash
# Lokasi file CSV input
DC_FILE="/home/oracle/scripts/automation/output_count/output_count_table_dc.csv"
DRC_FILE="/home/oracle/scripts/automation/output_count/output_count_table_drc.csv"
OUT_FILE="/home/oracle/scripts/automation/output_count/hasil_compare_dc_drc.txt"
```

### medallionPentahoReport_daily.sh.sh
Edit direktori sesuai konfigurasi server Anda:
```bash
# Direktori log sumber
LOG_DIR="/opt/MedallionLog/server/"

# Direktori untuk backup
BACKUP_DIR="/opt/MedallionLog/server/"

# Nama file log yang dimonitor
SOURCE_LOG="medallionPentahoReport.log"
TODAY_FILE="medallionPentahoReport_Today.log"
```

### monitoring_path_reportloaderoutput.sh
Sesuaikan path dan interval monitoring:
```bash
# Direktori yang dimonitor
MONITOR_PATH="/opt/MedallionFiles/data/reportloaderoutput/"

# Direktori untuk log
LOG_DIR="/home/medallion/monitoring/App/output_monitoring_logs_aux/"

# Interval check dalam detik (default: 60)
SLEEP_INTERVAL=60
```

---

## 🔍 Troubleshooting

### Script compare_count_table.sh

**Masalah**: File CSV tidak ditemukan
```bash
# Solusi: Pastikan path file benar
ls -la /home/oracle/scripts/automation/output_count/
# Jika tidak ada, buat file dummy untuk testing
```

**Masalah**: Output tidak ter-generate
```bash
# Check permission
ls -l output/
chmod 755 output/

# Run script dengan verbose
bash -x compare_count_table.sh
```

**Masalah**: Format output tidak sesuai
```bash
# Pastikan awk tersedia
which awk
awk --version
```

---

### Script medallionPentahoReport_daily.sh.sh

**Masalah**: Script error "Source log not found"
```bash
# Pastikan path LOG_DIR benar
ls -la /opt/MedallionLog/server/medallionPentahoReport.log

# Cek permission
file /opt/MedallionLog/server/medallionPentahoReport.log
```

**Masalah**: Rotasi log tidak terjadi
```bash
# Check file modification date
ls -l /opt/MedallionLog/server/medallionPentahoReport_Today.log
date

# Test rotasi manual
stat /opt/MedallionLog/server/medallionPentahoReport_Today.log
```

**Masalah**: Memory/CPU usage tinggi
```bash
# Script menggunakan tail -F yang terus running
# Ini normal, process akan consume resources saat ada log activity
# Untuk optimize, gunakan systemd service dengan proper resource limits:

[Service]
MemoryLimit=512M
CPUQuota=50%
```

---

### Script monitoring_path_reportloaderoutput.sh

**Masalah**: Log directory tidak ada
```bash
# Buat direktori secara manual
sudo mkdir -p /home/medallion/monitoring/App/output_monitoring_logs_aux/
sudo chown medallion:medallion /home/medallion/monitoring/App/output_monitoring_logs_aux/
```

**Masalah**: Permission denied pada log file
```bash
# Cek permission
ls -la /home/medallion/monitoring/App/output_monitoring_logs_aux/
chmod 755 /home/medallion/monitoring/App/output_monitoring_logs_aux/
```

**Masalah**: Script berhenti secara tiba-tiba
```bash
# Check apakah ada error
tail -100 /home/medallion/monitoring/App/output_monitoring_logs_aux/monitoring_path_reportloaderoutput.log

# Jalankan dengan error handling
bash -x monitoring_path_reportloaderoutput.sh 2>&1 | tee debug.log
```

---

## 📋 Maintenance & Best Practices

### Regular Maintenance
- ✅ **Cek log file size** setiap bulan, rotate jika terlalu besar
- ✅ **Archive old CSV files** untuk save disk space
- ✅ **Update script path** jika ada perubahan direktori
- ✅ **Test script** di environment test sebelum production

### Best Practices
1. **Backup Configuration**
   ```bash
   # Backup script configuration
   cp -r script_medallion_service script_medallion_service.backup
   ```

2. **Error Notification** (Optional)
   ```bash
   # Tambahkan notification email jika ada error
   if [ $? -ne 0 ]; then
       echo "Error running script" | mail -s "Alert: Medallion Script Error" admin@company.com
   fi
   ```

3. **Log Rotation** (gunakan logrotate)
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
   # Commit changes dengan pesan yang jelas
   git add .
   git commit -m "Update script version with bug fix"
   git push
   ```

---

## 📞 Kontak & Dukungan

### Author Information
- **Nama**: Crispian
- **Employee ID**: 901146
- **Divisi**: IT Application Services

### Untuk Pertanyaan & Issues
1. Hubungi Author langsung
2. Submit issue ke repository
3. Contact IT Application Services

### Dokumentasi & Referensi
- [Bash Script Guide](https://www.gnu.org/software/bash/manual/)
- [Linux System Administration](https://linux.die.net/)
- [Cron Tutorial](https://linux.die.net/man/5/crontab)

---

## 📝 License

Proprietary Software - All Rights Reserved

Penggunaan script ini terbatas untuk keperluan internal perusahaan. Dilarang mendistribusikan atau menggunakan tanpa persetujuan ITdepartment.

---

## 📊 Changelog

### Version 1.0 - 2026-02-11
- Initial release
- 3 production scripts
- Complete documentation

---

**Last Updated**: 11 Februari 2026  
**Maintained By**: IT Application Services
