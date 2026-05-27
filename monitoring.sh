
#!/bin/bash
PROJECT_DIR="$(dirname "$(realpath "$0")")"
LOG_FILE="$PROJECT_DIR/monitor.log"
DASHBOARD_FILE="$PROJECT_DIR/index.html"
TIMESTAMP=$(TZ='Europe/Riga' date '+%Y-%m-%d %H:%M:%S EET')

# ── CPU
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $4}' | cut -d'.' -f1)
CPU_USAGE=$((100 - CPU_IDLE))


# ── RAM
RAM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
RAM_USED=$(free -m | awk '/Mem:/ {print $3}')
RAM_PERCENT=$(echo "scale=1; $RAM_USED * 100 / $RAM_TOTAL" | bc)


# ── Disk
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
DISK_AVAIL=$(df -h / | awk 'NR==2 {print $4}')


# ── Log
echo "$TIMESTAMP | CPU: ${CPU_USAGE}% | RAM: ${RAM_USED}MB/${RAM_TOTAL}MB (${RAM_PERCENT}%) | DISK: ${DISK_USAGE}% used (${DISK_AVAIL} free)" >> "$LOG_FILE"




cat > "$DASHBOARD_FILE" << EOF
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta http-equiv="refresh" content="30">
  <title>System Monitor</title>
  <style>
body { font-family: monospace; background: #0d2b27; color: #b2d8d0; padding: 2rem; }
h1   { color: #4ecdc4; }
.metric { background: #0f3530; border: 1px solid #1e5c50; border-radius: 8px;
          padding: 1rem 1.5rem; margin: 0.5rem 0; font-size: 1.1rem; }
.ok   { color: #4ecdc4; }
.warn { color: #a8d8a0; }
.crit { color: #6fcf97; }
  </style>
</head>
<body>
  <h1>System Health Monitor by Raimonds Cernisenko</h1>
  <p>Last updated: $TIMESTAMP</p>
  <div class="metric">CPU usage: <span class="$([ ${CPU_USAGE%.*} -ge 80 ] && echo crit || [ ${CPU_USAGE%.*} -ge 60 ] && echo warn || echo ok)">${CPU_USAGE}%</span></div>
  <div class="metric">RAM used: <span class="$([ ${RAM_PERCENT%.*} -ge 85 ] && echo crit || [ ${RAM_PERCENT%.*} -ge 70 ] && echo warn || echo ok)">${RAM_USED}MB / ${RAM_TOTAL}MB (${RAM_PERCENT}%)</span></div>
  <div class="metric">Disk usage: <span class="$([ $DISK_USAGE -ge 90 ] && echo crit || [ $DISK_USAGE -ge 75 ] && echo warn || echo ok)">${DISK_USAGE}% used — ${DISK_AVAIL} free</span></div>
  <hr style="border-color:#30363d; margin: 1.5rem 0">
  <p style="color:#8b949e">Auto-refreshes every 5 minutes</p>
</body>
</html>
EOF


echo "[$TIMESTAMP] Monitor run complete." >> "$LOG_FILE"

