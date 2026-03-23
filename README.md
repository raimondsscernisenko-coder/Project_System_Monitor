# Project System Monitor

A lightweight Bash based system monitoring tool deployed on AWS EC2.
Monitors CPU, RAM and disk usage in real time, triggers alerts when 
thresholds are exceeded, and serves a live dashboard via nginx.

Built as a practical DevOps project demonstrating Linux automation,
cloud deployment and infrastructure monitoring.


## Live Dashboard
http://50.19.20.209
Auto-refreshes every 5 minutes with latest metrics.


#Features
- Real time monitoring of CPU, RAM and disk usage
- Configurable alert thresholds with logging
- Auto generated HTML dashboard served via nginx
- Automated execution via cron every 5 minutes
- Deployed on AWS EC2 (free tier)
- Docker support for local development
- One command setup script for easy installation


#Project Structure
Project_System_Monitor/
├── monitoring.sh        # Collects CPU, RAM, disk metrics
├── alert.sh             # Checks thresholds, writes alerts
├── setup.sh             # One command installer
├── docker-compose.yml   # Docker setup
└── .gitignore


## Install process

### Option 1 — Run with setup script
git clone https://github.com/raimondsscernisenko-coder/Project_System_Monitor
cd Project_System_Monitor
chmod +x setup.sh
./setup.sh


### Option 2 — Run with Docker
git clone https://github.com/raimondsscernisenko-coder/Project_System_Monitor
cd Project_System_Monitor
docker compose up -d


## Alert Thresholds
| Metric | Warning threshold |
| CPU    | 75%
| RAM    | 80%
| Disk   | 85% 
Thresholds are configurable at the top of `alert.sh` for your personal solution.


## Tech Stack
- Bash scripting
- Linux (Ubuntu 24.04)
- AWS EC2 (t3.micro, free tier)
- nginx
- Docker
- cron


## Log Files
| File | Description |
| monitor.log | Metrics history, one entry per 5 minutes |
| alert.log | Alert history with timestamps |
| cron.log | Cron execution log for debugging |


## The author
Raimonds Cernisenko  
[Linkedin] https://www.linkedin.com/in/raimonds-cernisenko/
[GitHub] https://github.com/raimondsscernisenko-coder
