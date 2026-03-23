#!/bin/bash

echo " System Monitor — Setup"

# Detecting project directory
PROJECT_DIR="$(dirname "$(realpath "$0")")"
echo "[1/4] Project directory: $PROJECT_DIR"

#Installing all  dependencies
echo "[2/4] Installing dependencies (bc)..."
sudo apt update -qq && sudo apt install -y bc > /dev/null 2>&1
echo "      bc installed."

# Making scripts executable
echo "[3/4] Setting permissions..."
chmod +x "$PROJECT_DIR/monitoring.sh"
chmod +x "$PROJECT_DIR/alert.sh"
echo "      Done."

# Installing cron jobs
echo "[4/4] Installing cron jobs..."
CRON_1="*/5 * * * * $PROJECT_DIR/monitoring.sh >> $PROJECT_DIR/cron.log 2>&1"
CRON_2="*/5 * * * * $PROJECT_DIR/alert.sh >> $PROJECT_DIR/cron.log 2>&1"

# add only if not already present
(crontab -l 2>/dev/null | grep -v "monitoring.sh" | grep -v "alert.sh"; echo "$CRON_1"; echo "$CRON_2") | crontab -
echo "      Cron jobs installed."

echo ""
echo "================================================"
echo " Setup complete!"
echo " Monitor log : $PROJECT_DIR/monitor.log"
echo " Alert log   : $PROJECT_DIR/alert.log"
echo " Dashboard   : $PROJECT_DIR/index.html"
echo " Cron        : runs every 5 minutes"
echo "================================================"
echo ""
echo " Run manually anytime:"
echo "   $PROJECT_DIR/monitoring.sh"
echo "   $PROJECT_DIR/alert.sh"
echo ""
