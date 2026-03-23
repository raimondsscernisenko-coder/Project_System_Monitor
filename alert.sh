#!/bin/bash

# Config
PROJECT_DIR="$(dirname "$(realpath "$0")")"
LOG_FILE="$PROJECT_DIR/monitor.log"
ALERT_LOG="$PROJECT_DIR/alert.log"


# Thresholds
CPU_THRESHOLD=75
RAM_THRESHOLD=80
DISK_THRESHOLD=75

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')


# Reads the latest metrics from log
LAST_LINE=$(tail -2 "$LOG_FILE" | head -1)

CPU_USAGE=$(echo "$LAST_LINE" | grep -oP 'CPU: \K[0-9]+' | head -1)
RAM_PERCENT=$(echo "$LAST_LINE" | grep -oP '\((\K[0-9]+)' | head -1)
DISK_USAGE=$(echo "$LAST_LINE" | grep -oP 'DISK: \K[0-9]+' | head -1)

#Check thresholds
ALERT_TRIGGERED=false

if [ "$CPU_USAGE" -ge "$CPU_THRESHOLD" ]; then
    MSG="[ALERT] $TIMESTAMP | CPU usage critical: ${CPU_USAGE}% (threshold: ${CPU_THRESHOLD}%)"
    echo "$MSG" >> "$ALERT_LOG"
    echo "$MSG"
    ALERT_TRIGGERED=true
fi

if [ "$RAM_PERCENT" -ge "$RAM_THRESHOLD" ]; then
    MSG="[ALERT] $TIMESTAMP | RAM usage critical: ${RAM_PERCENT}% (threshold: ${RAM_THRESHOLD}%)"
    echo "$MSG" >> "$ALERT_LOG"
    echo "$MSG"
    ALERT_TRIGGERED=true
fi

if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
    MSG="[ALERT] $TIMESTAMP | Disk usage critical: ${DISK_USAGE}% (threshold: ${DISK_THRESHOLD}%)"
    echo "$MSG" >> "$ALERT_LOG"
    echo "$MSG"
    ALERT_TRIGGERED=true
fi


#  If all good, than it is good
if [ "$ALERT_TRIGGERED" = false ]; then
    echo "[$TIMESTAMP] All metrics OK — CPU: ${CPU_USAGE}% | RAM: ${RAM_PERCENT}% | Disk: ${DISK_USAGE}%" >> "$ALERT_LOG"
fi
