# Script Medallion Service

![Version](https://img.shields.io/badge/version-1.0-blue)
![License](https://img.shields.io/badge/license-Private-red)
![Status](https://img.shields.io/badge/status-Production-green)

Dieses Repository enthält eine Sammlung von Linux-Skripten zur Automatisierung und Überwachung im Medallion-Service. Diese Skripte wurden entwickelt, um die Betriebszuverlässigkeit und Effizienz zu verbessern.

---
🌐 **Sprachen:**
- 🇩🇪 Deutsch
- 🇬🇧 [English](README.md)

## 📋 Inhaltsverzeichnis

- [Überblick](#überblick)
- [Voraussetzungen](#voraussetzungen)
- [Installation & Einrichtung](#installation--einrichtung)
- [Verzeichnisstruktur](#verzeichnisstruktur)
- [Beschreibung der Skripte](#beschreibung-der-skripte)
- [Verwendung](#verwendung)
- [Konfiguration](#konfiguration)
- [Fehlerbehebung](#fehlerbehebung)
- [Support & Kontakt](#support--kontakt)

---

## 📌 Überblick

Dieses Projekt ist eine Sammlung von Linux-Skripten zur Automatisierung und Überwachung, die den Betrieb des Medallion-Dienstes unterstützen. Die Skripte sind darauf ausgelegt:

- ✅ Datenintegrität zwischen DC und DRC zu vergleichen
- ✅ Automatische Sicherung und Rotation von Logs durchzuführen
- ✅ Änderungen in kritischen Verzeichnissen zu überwachen
- ✅ Echtzeitberichte für den Betrieb bereitzustellen

---

## 🔧 Voraussetzungen

Bevor Sie diese Skripte ausführen, stellen Sie sicher, dass:

- **Betriebssystem:** Linux (Red Hat, CentOS, Debian oder andere Distributionen)
- **Shell:** Bash 4.0 oder neuer
- **Erforderliche Tools:**
  - `awk` – für Textverarbeitung
  - `grep` – für Musterabgleich
  - `date` – für Zeitstempel
  - `tail` – für Logüberwachung
  - `ls`, `mkdir`, `mv` – grundlegende Linux-Befehle
- **Zugriff:** Root- oder sudo-Rechte für überwachte Verzeichnisse
- **Festplattenspeicher:** Genug Platz für Backups und Logdateien

---

## 📦 Installation & Einrichtung

### Schritt 1: Repository klonen oder herunterladen
```bash
cd /home/oracle/scripts/automation/
git clone <repository-url>
cd script_medallion_service
```

### Schritt 2: Berechtigungen setzen
```bash
# Ausführungsrechte für alle Skripte setzen
chmod +x compare_count_table/compare_count_table.sh
chmod +x medallionpentahoreport_daily/medallionPentahoReport_daily.sh.sh
chmod +x monitoring_path_reportloaderoutput/monitoring_path_reportloaderoutput.sh

# Ausgabe-Verzeichnisse erstellen, falls sie nicht existieren
mkdir -p compare_count_table/output
mkdir -p medallionpentahoreport_daily/output
mkdir -p monitoring_path_reportloaderoutput/output
```

### Schritt 3: Pfade und Variablen konfigurieren
Passen Sie die Pfade und Variablen in jedem Skript an Ihre Umgebung an (siehe [Konfiguration](#konfiguration)).

### Schritt 4: Cron-Einträge (optional)
Um die Skripte regelmäßig auszuführen, fügen Sie sie der crontab hinzu:

```bash
# crontab bearbeiten
crontab -e

# Beispiel: compare_count_table täglich um 6 Uhr morgens ausführen
0 6 * * * /opt/script_medallion_service/compare_count_table/compare_count_table.sh

# Beispiel: Report-Loader rund um die Uhr überwachen (im Hintergrund)
0 0 * * * /opt/script_medallion_service/medallionpentahoreport_daily/medallionPentahoReport_daily.sh.sh &

# Beispiel: Pfad jede Minute überwachen
* * * * * /opt/script_medallion_service/monitoring_path_reportloaderoutput/monitoring_path_reportloaderoutput.sh &
``` 

---

## 📂 Verzeichnisstruktur

```
script_medallion_service/
│
├── README.md.idn                          # Indonesische Dokumentation
├── README.md.eng                          # Englische Dokumentation
├── README.de.md                           # Deutsche Dokumentation
│
├── compare_count_table/                   # Modul zum Vergleich DC vs DRC
│   ├── compare_count_table.sh             # Hauptskript
│   ├── source/                            # Verzeichnis für CSV-Eingabedateien
│   │   ├── output_count_table_dc.csv      # DC-Daten
│   │   └── output_count_table_drc.csv     # DRC-Daten
│   └── output/                            # Verzeichnis für Berichtsausgabe
│       └── hasil_compare_dc_drc.txt       # Vergleichsbericht
│
├── medallionpentahoreport_daily/          # Modul zur Überwachung von Pentaho-Logs
│   ├── medallionPentahoReport_daily.sh.sh # Hauptskript (doppelte Endung)
│   ├── source/                            # Verzeichnis für Quell-Logs
│   └── output/                            # Verzeichnis für Sicherungs-Logs
│       └── medallionPentahoReport_Today.log
│       └── medallionPentahoReport_DD_MM_YYYY.log
│
└── monitoring_path_reportloaderoutput/    # Modul zur Verzeichnisüberwachung
    ├── monitoring_path_reportloaderoutput.sh  # Hauptskript
    ├── filebeat.yml                          # Filebeat-Konfiguration
    ├── monitoring_logs_aux.service           # Systemd-Service-Datei
    ├── run_all_monitoring.sh                 # Skript zum Ausführen aller Überwachungen
    └── output/                               # Verzeichnis für Überwachungslogs
        └── monitoring_path_reportloaderoutput.log

├── monitoring_path_downloadgeneral/         # Modul zur Überwachung des Download-General-Verzeichnisses
│   ├── monitoring_path_downloadgeneral.sh   # Hauptskript
│   ├── filebeat.yml                         # Filebeat-Konfiguration
│   ├── monitoring_logs_aux.service          # Systemd-Service-Datei
│   ├── run_all_monitoring.sh                # Skript zum Ausführen aller Überwachungen
│   └── output/                              # Verzeichnis für Überwachungslogs
│       └── monitoring_path_downloadgeneral.log

├── sftp_log/                               # Modul zum Übertragen von Logs via SFTP
│   ├── copy_log_app_dc.sh                # Log von APP DC lokal & remote holen
│   ├── copy_log_app_drc.sh               # Log von APP DRC lokal & remote holen
│   ├── copy_log_rpt_dc.sh                # Report-Log DC lokal & remote holen
│   ├── copy_log_rpt_drc.sh               # Report-Log DRC lokal & remote holen
│   ├── copy_log_web_dc.sh                # Web-Log DC lokal & remote holen
│   ├── copy_log_web_drc.sh               # Web-Log DRC lokal & remote holen
│   ├── credential_nas                    # Datei mit NAS-Anmeldedaten
│   └── sftp_to_nas                       # Platzhalterskript (leer)
``` 

---

## 🚀 Beschreibung der Skripte

### 1. compare_count_table.sh

**Zweck:** Vergleicht Tabellenanzahlen zwischen Data Center (DC) und Disaster Recovery Center (DRC), um die Datenintegrität sicherzustellen.

**Hauptfunktionen:**
- Liest zwei CSV-Dateien (Anzahl von DC und DRC)
- Vergleicht LASTKEY und Datensatzanzahl jeder Tabelle
- Erzeugt einen formatierten Bericht mit MATCH/NOT MATCH Status

**Eingabe:**
- `output_count_table_dc.csv` – Zähldatei aus dem DC
- `output_count_table_drc.csv` – Zähldatei aus dem DRC

**Ausgabe:**
- `hasil_compare_dc_drc.txt` – Vergleichsbericht im Tabellenformat

**Technische Daten:**
- **Autor:** Crispian | 901146
- **Letztes Update:** 04-02-2026
- **Laufzeit:** ~5 Minuten (abhängig von der Datenmenge)

**Beispielausgabe:**
```
                                                    SO SB Medallion 2026
                                                    Datum : 11/02/2026

+--------------------+-----+--------+--------------------+-----+--------+----------+
|        DC          | JML | TABEL  |        DRC         | JML | TABEL  |   KET    |
+--------------------+-----+--------+--------------------+-----+--------+----------+
| 12345678           | 1000| TABLE1 | 12345678           | 1000| TABLE1 | MATCH    |
| 12345679           | 2000| TABLE2 | 12345679           | 2000| TABLE2 | MATCH    |
| 12345680           | 1500| TABLE3 | -                  | -   | -      | N/A      |
```

---

### 2. medallionPentahoReport_daily.sh.sh

**Zweck:** Überwacht und sichert die Log-Datei `medallionPentahoReport` in Echtzeit mit täglicher Rotation.

**Hauptfunktionen:**
- Echtzeitüberwachung (tail -F)
- Automatische Rotation bei Tageswechsel
- Trennung der Logs nach Datum (Today/Yesterday)
- Backup für Analyse und Debugging

**Eingang:**
- `medallionPentahoReport.log` – Quelllog des Pentaho-Dienstes

**Ausgang:**
- `medallionPentahoReport_Today.log` – heutige Logs
- `medallionPentahoReport_DD_MM_YYYY.log` – archivierte Logs des Vortages

**Technische Daten:**
- **Autor:** Crispian | 901146
- **Letztes Update:** 20-10-2025
- **Modus:** Dauerbetrieb im Hintergrund

**Besondere Merkmale:**
- ✅ Automatische Tageswechselerkennung
- ✅ Rotation ohne Ausfall
- ✅ Duplikatschutz
- ✅ Datumsfilter-Sicherheitsprüfung

---

### 3. monitoring_path_reportloaderoutput.sh

**Zweck:** Überwacht kontinuierlich das Verzeichnis `reportloaderoutput` und protokolliert neue Dateien mit Zeitstempel.

**Hauptfunktionen:**
- Periodische Verzeichnisprüfung
- Erkennung neuer Dateien durch Statesvergleich
- Protokollierung mit Zeitstempel
- Automatisches Zurücksetzen des Logs an Tageswechsel

**Eingabe:**
- Überwachungs-Pfad: `/opt/MedallionFiles/data/reportloaderoutput/`

**Ausgang:**
- `monitoring_path_reportloaderoutput.log` – Überwachungslog

**Technische Daten:**
- **Autor:** Crispian | 901146
- **Letztes Update:** 15-12-2025
- **Check-Intervall:** 60 Sekunden (konfigurierbar)
- **Modus:** Dauerbetrieb im Hintergrund

**Log-Format:**
```
2026-02-11 10:30:45 | reportloaderoutput | /opt/MedallionFiles/data/reportloaderoutput/file_baru_001.txt
2026-02-11 10:31:02 | reportloaderoutput | /opt/MedallionFiles/data/reportloaderoutput/file_baru_002.xml
2026-02-11 10:35:18 | INFO | Initial state created
```

### 4. monitoring_path_downloadgeneral.sh

**Zweck:** Überwacht kontinuierlich das Verzeichnis `downloadgeneral` und protokolliert neue Dateien mit Zeitstempel.

**Hauptfunktionen:**
- Periodische Verzeichnisprüfung
- Erkennung neuer Dateien durch Statesvergleich
- Protokollierung mit Zeitstempel
- Automatisches Zurücksetzen des Logs an Tageswechsel

**Eingabe:**
- Überwachungs-Pfad: `/opt/MedallionFiles/download/general/`

**Ausgang:**
- `monitoring_path_downloadgeneral.log` – Überwachungslog

**Technische Daten:**
- **Autor:** Crispian | 901146
- **Letztes Update:** 02-03-2026
- **Check-Intervall:** 60 Sekunden (konfigurierbar)
- **Modus:** Dauerbetrieb im Hintergrund

**Log-Format:**
```
2026-03-05 10:30:45 | downloadgeneral | /opt/MedallionFiles/download/general/file_baru_001.txt
2026-03-05 10:31:02 | downloadgeneral | /opt/MedallionFiles/download/general/file_baru_002.xml
2026-03-05 10:35:18 | INFO | Initial state created
```

### 5. sftp_log-Modul (Log-Transfer via SFTP)

**Zweck:** Kopiert wichtige Log-Dateien von lokalen und entfernten Servern (APP, REPORT, WEB) per SFTP für Analyse und Überwachung.

**Enthaltene Skripte:**
- `copy_log_app_dc.sh` / `copy_log_app_drc.sh` – zieht `medallionServer.log` vom APP-Server DC/DRC
- `copy_log_rpt_dc.sh` / `copy_log_rpt_drc.sh` – zieht `medallionPentahoReport_Today.log` vom Report-Server DC/DRC
- `copy_log_web_dc.sh` / `copy_log_web_drc.sh` – zieht `medallionWeb.log` vom WEB-Server DC/DRC
- `credential_nas` – enthält NAS-Zugangsdaten
- `sftp_to_nas` – Platzhalterskript für NAS-Upload (momentan leer)

**Hauptfunktionen:**
- Erstellen des Zielverzeichnisses (`/home/medallion/monitoring/automation/output_sftp_log/`)
- Lokales Kopieren der Log-Datei
- SFTP-Verbindung zum Remote-Host und Download der Log-Datei
- Statusprüfung und Ausgabe von SUCCESS/FAILED

**Technische Daten:**
- **Autor:** Crispian | 901146
- **Letztes Update:** 23-02-2026 (je nach Skript)
- **Wichtige Variablen:** `REMOTE_HOST`, `SOURCE_FILE`, `LOCAL_DIR`, `LOCAL_NAME1`, `LOCAL_NAME2`

**Hinweise:**
- Stellen Sie sicher, dass SFTP-Verbindungen (SSH-Schlüssel oder passwortlos) zwischen lokalen und entfernten Hosts konfiguriert sind.
- `credential_nas` kann angepasst werden, um NAS-Zugang bereitzustellen.

---

## 💻 Verwendung

### compare_count_table.sh ausführen
```bash
# Einmalig ausführen
./compare_count_table/compare_count_table.sh

# Ergebnis prüfen
cat compare_count_table/output/hasil_compare_dc_drc.txt

# Über cron ausführen (täglich um 6 Uhr)
0 6 * * * /path/to/script/compare_count_table/compare_count_table.sh
```

### medallionPentahoReport_daily.sh.sh ausführen
```bash
# Im Vordergrund ausführen
./medallionpentahoreport_daily/medallionPentahoReport_daily.sh.sh

# Im Hintergrund mit nohup
nohup ./medallionpentahoreport_daily/medallionPentahoReport_daily.sh.sh > /tmp/pentaho_monitor.log 2>&1 &

# Als systemd-Service ausführen (empfohlen)
# /etc/systemd/system/medallion-pentaho.service erstellen
sudo systemctl start medallion-pentaho
sudo systemctl enable medallion-pentaho

# Status prüfen
ps aux | grep medallionPentahoReport
```

### monitoring_path_reportloaderoutput.sh ausführen
```bash
# Im Hintergrund ausführen
nohup ./monitoring_path_reportloaderoutput/monitoring_path_reportloaderoutput.sh &

# Oder systemd verwenden
sudo systemctl start medallion-monitor
sudo systemctl enable medallion-monitor

# Echtzeitüberwachung
tail -f /home/medallion/monitoring/App/output_monitoring_logs_aux/monitoring_path_reportloaderoutput.log

# Überwachung beenden
killall monitoring_path_reportloaderoutput.sh
```

### monitoring_path_downloadgeneral.sh ausführen
```bash
# Im Hintergrund ausführen
nohup ./monitoring_path_downloadgeneral/monitoring_path_downloadgeneral.sh &

# Oder systemd verwenden
sudo systemctl start medallion-monitor-downloadgeneral
sudo systemctl enable medallion-monitor-downloadgeneral

# Echtzeitüberwachung
tail -f /home/medallion/monitoring/App/output_monitoring_logs_aux/monitoring_path_downloadgeneral.log

# Überwachung beenden
killall monitoring_path_downloadgeneral.sh
```

### sftp_log-Skripte ausführen
```bash
# Beispiel: Anwendungslog vom DC ziehen
./sftp_log/copy_log_app_dc.sh

# Beispiel: Web-Log vom DRC ziehen
./sftp_log/copy_log_web_drc.sh

# Ergebnisse liegen unter "/home/medallion/monitoring/automation/output_sftp_log/"
# Prüfen Sie die STDOUT-Meldungen auf SUCCESS/FAILED

# NAS-Zugang sshbbuster anpassen bei Bedarf:
# Datei sftp_log/credential_nas bearbeiten
```

---

## ⚙️ Konfiguration

### compare_count_table.sh
Bearbeiten Sie den folgenden Abschnitt entsprechend Ihrer Umgebung:
```bash
# Speicherort der Eingabe-CSV-Dateien
DC_FILE="/home/oracle/scripts/automation/output_count/output_count_table_dc.csv"
DRC_FILE="/home/oracle/scripts/automation/output_count/output_count_table_drc.csv"
OUT_FILE="/home/oracle/scripts/automation/output_count/hasil_compare_dc_drc.txt"
```

### medallionPentahoReport_daily.sh.sh
Passen Sie Verzeichnisse gemäß Ihrer Serverkonfiguration an:
```bash
# Quell-Log-Verzeichnis
LOG_DIR="/opt/MedallionLog/server/"

# Backup-Verzeichnis
BACKUP_DIR="/opt/MedallionLog/server/"

# Name der zu überwachenden Log-Datei
SOURCE_LOG="medallionPentahoReport.log"
TODAY_FILE="medallionPentahoReport_Today.log"
```

### monitoring_path_reportloaderoutput.sh
Passen Sie Pfad und Intervall an:
```bash
# Überwachtes Verzeichnis
MONITOR_PATH="/opt/MedallionFiles/data/reportloaderoutput/"

# Verzeichnis für Logs
LOG_DIR="/home/medallion/monitoring/App/output_monitoring_logs_aux/"

# Prüfintervall in Sekunden (Standard: 60)
SLEEP_INTERVAL=60
```

### monitoring_path_downloadgeneral.sh
Passen Sie Pfad und Intervall an:
```bash
# Überwachtes Verzeichnis
MONITOR_PATH="/opt/MedallionFiles/download/general/"

# Verzeichnis für Logs
LOG_DIR="/home/medallion/monitoring/App/output_monitoring_logs_aux/"

# Prüfintervall in Sekunden (Standard: 60)
SLEEP_INTERVAL=60
```

### sftp_log-Skripte
Bearbeiten Sie Verbindungsvariablen und Pfade bei Bedarf:
```bash
# Remote-Host (für DC/DRC anpassen)
REMOTE_HOST="192.168.x.x"

# Speicherort der Log-Datei auf dem Server
SOURCE_FILE="/opt/MedallionLog/server/medallionServer.log"

# Lokales Zielverzeichnis
LOCAL_DIR="/home/medallion/monitoring/automation/output_sftp_log/"

# Lokale Dateinamen für lokal und remote
LOCAL_NAME1="medallionServer_1.log"
LOCAL_NAME2="medallionServer_2.log"
```

# Für NAS-Uploads `sftp_log/credential_nas` mit korrekten Zugangsdaten füllen.

---

## 🔍 Fehlerbehebung

### compare_count_table.sh

**Problem:** CSV-Dateien nicht gefunden
```bash
# Lösung: Pfade überprüfen
ls -la /home/oracle/scripts/automation/output_count/
# Falls nicht vorhanden, Dummy-Dateien erstellen
```

**Problem:** Ausgabedatei wird nicht erstellt
```bash
# Berechtigungen prüfen
ls -l output/
chmod 755 output/

# Debugmodus nutzen
bash -x compare_count_table.sh
```

**Problem:** Falsches Ausgabeformat
```bash
# Sicherstellen, dass awk installiert ist
which awk
awk --version
```

---

### medallionPentahoReport_daily.sh.sh

**Problem:** "Source log not found" Fehler
```bash
# LOG_DIR prüfen
ls -la /opt/MedallionLog/server/medallionPentahoReport.log

# Berechtigungen prüfen
file /opt/MedallionLog/server/medallionPentahoReport.log
```

**Problem:** Logrotation erfolgt nicht
```bash
# Änderungsdatum prüfen
ls -l /opt/MedallionLog/server/medallionPentahoReport_Today.log
date

# Manuelle Rotation testen
stat /opt/MedallionLog/server/medallionPentahoReport_Today.log
```

---

### monitoring_path_reportloaderoutput.sh

**Problem:** Überwachungsverzeichnis fehlt
```bash
# Verzeichnis manuell erstellen
sudo mkdir -p /home/medallion/monitoring/App/output_monitoring_logs_aux/
sudo chown medallion:medallion /home/medallion/monitoring/App/output_monitoring_logs_aux/
```

**Problem:** Berechtigungsfehler im Log
```bash
# Rechte prüfen und setzen
ls -la /home/medallion/monitoring/App/output_monitoring_logs_aux/
chmod 755 /home/medallion/monitoring/App/output_monitoring_logs_aux/
```

**Problem:** Skript stürzt ab
```bash
# Fehler im Log ansehen
tail -100 /home/medallion/monitoring/App/output_monitoring_logs_aux/monitoring_path_reportloaderoutput.log

# Debugmodus ausführen
bash -x monitoring_path_reportloaderoutput.sh 2>&1 | tee debug.log
```

### monitoring_path_downloadgeneral.sh

**Problem:** Überwachungsverzeichnis fehlt
```bash
# Verzeichnis manuell erstellen
sudo mkdir -p /home/medallion/monitoring/App/output_monitoring_logs_aux/
sudo chown medallion:medallion /home/medallion/monitoring/App/output_monitoring_logs_aux/
```

**Problem:** Berechtigungsfehler im Log
```bash
# Rechte prüfen und setzen
ls -la /home/medallion/monitoring/App/output_monitoring_logs_aux/
chmod 755 /home/medallion/monitoring/App/output_monitoring_logs_aux/
```

**Problem:** Skript stürzt ab
```bash
# Fehler im Log ansehen
tail -100 /home/medallion/monitoring/App/output_monitoring_logs_aux/monitoring_path_downloadgeneral.log

# Debugmodus ausführen
bash -x monitoring_path_downloadgeneral.sh 2>&1 | tee debug.log
```

---

## 📋 Wartung & Best Practices

1. **Regelmäßige Wartung**
   - Logdateien monatlich prüfen und bei Bedarf rotieren
   - Alte CSV-Dateien archivieren, um Speicherplatz freizugeben
   - Skriptpfade aktualisieren, wenn Verzeichnisse geändert werden
   - Skripte vor dem Einsatz in einer Testumgebung prüfen

2. **Backup-Konfiguration**
```bash
# Konfiguration sichern
cp -r script_medallion_service script_medallion_service.backup
```

3. **Fehlerbenachrichtigung**
```bash
# Mailbenachrichtigung bei Skriptfehlern
if [ $? -ne 0 ]; then
    echo "Fehler beim Ausführen des Skripts" | mail -s "Alarm: Medallion Skript Fehler" admin@company.com
fi
```

4. **Logrotation (logrotate)**
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

5. **Versionsverwaltung**
```bash
# Änderungen mit klaren Nachrichten committen
git add .
git commit -m "Update script version with bug fix"
git push
```

---

## 📞 Support & Kontakt

### Autor
- **Name:** Crispian
- **Mitarbeiter-ID:** 901146
- **Abteilung:** IT Application Services

### Fragen & Probleme
1. Autor direkt kontaktieren
2. Issue im Repository erstellen
3. IT Application Services ansprechen

### Dokumentation & Referenzen
- [Bash Script Guide](https://www.gnu.org/software/bash/manual/)
- [Linux System Administration](https://linux.die.net/)
- [Cron Tutorial](https://linux.die.net/man/5/crontab)

---

## 📝 Lizenz

Proprietäre Software – Alle Rechte vorbehalten

Diese Skripte dürfen nur intern verwendet werden. Ohne Genehmigung der IT-Abteilung ist Weitergabe oder Nutzung untersagt.

---

## 📊 Changelog

### Version 1.0 - 2026-02-11
- Erstveröffentlichung
- 3 Produktionsskripte
- Vollständige Dokumentation

---

**Letzte Aktualisierung**: 11. Februar 2026  
**Wartung durch**: IT Application Services
