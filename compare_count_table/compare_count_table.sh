#!/bin/bash

###############################################################################
# Script Name  : compare_count_table.sh
# Description  : Script compare hasil count table DC vs DRC.
# Author       : Crispian | 901146
# Division     : IT Application Services
# Last Update  : 04-02-2026
###############################################################################

DC_FILE="/home/oracle/scripts/automation/output_count/output_count_table_dc.csv"
DRC_FILE="/home/oracle/scripts/automation/output_count/output_count_table_drc.csv"
OUT_FILE="/home/oracle/scripts/automation/output_count/hasil_compare_dc_drc.txt"

TANGGAL=$(date +%d/%m/%Y)

DC_TMP=$(mktemp)
DRC_TMP=$(mktemp)

awk -F',' 'NR>1 {
  gsub(/"/,""); gsub(/\r/,"");
  if ($3 != "") print $1 "|" $2 "|" $3
}' "$DC_FILE" > "$DC_TMP"

awk -F',' 'NR>1 {
  gsub(/"/,""); gsub(/\r/,"");
  if ($3 != "") print $1 "|" $2 "|" $3
}' "$DRC_FILE" > "$DRC_TMP"

> "$OUT_FILE"

{
echo
echo "                                                    SO SB Medallion 2026"
echo "                                                    Tanggal : $TANGGAL"
echo
echo "+------------------------------------------------------------+------------------------------------------------------------+------------+"
echo "|                              DC                            |                              DRC                           |  KET       |"
echo "+--------------+------------+--------------------------------+--------------+------------+--------------------------------+------------+"
echo "| LASTKEY      | JML        | TABLENAME                      | LASTKEY      | JML        | TABLENAME                      |            |"
echo "+--------------+------------+--------------------------------+--------------+------------+--------------------------------+------------+"
} | tee -a "$OUT_FILE"

while IFS='|' read -r DC_LASTKEY DC_JML DC_TABLE
do
    DRC_LINE=$(awk -F'|' -v t="$DC_TABLE" '$3==t {print; exit}' "$DRC_TMP")

    if [ -z "$DRC_LINE" ]; then
        printf "| %-12s | %-10s | %-30s | %-12s | %-10s | %-30s | %-6s |\n" \
        "$DC_LASTKEY" "$DC_JML" "$DC_TABLE" "-" "-" "-" "N/A" | tee -a "$OUT_FILE"
        continue
    fi

    IFS='|' read -r DRC_LASTKEY DRC_JML DRC_TABLE <<< "$DRC_LINE"

    if [ "$DC_LASTKEY" = "$DRC_LASTKEY" ] && [ "$DC_JML" = "$DRC_JML" ]; then
        KET="MATCH"
    else
        KET="NOT MATCH"
    fi

    printf "| %-12s | %-10s | %-30s | %-12s | %-10s | %-30s | %-10s |\n" \
    "$DC_LASTKEY" "$DC_JML" "$DC_TABLE" \
    "$DRC_LASTKEY" "$DRC_JML" "$DRC_TABLE" "$KET" | tee -a "$OUT_FILE"

done < "$DC_TMP"

echo "+--------------+------------+--------------------------------+--------------+------------+--------------------------------+------------+" | tee -a "$OUT_FILE"

rm -f "$DC_TMP" "$DRC_TMP"
