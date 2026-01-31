<div align="left">

**English** | [فارسی](README.md)

# One-Command Psiphon Conduit Installation v2.0

**Easy Psiphon Bridge setup with Docker and intelligent management to help Internet freedom in Iran**

[Ramtin Rahmaninezhad - Net Admin Plus](https://netadminplus.com)

[YouTube](https://youtube.com/@netadminplus) • [Website](https://netadminplus.com) • [Instagram](https://instagram.com/netadminplus)

---

🕯️ **In Memory of Dey 18-19, 1404 (January 8-9, 2026)**

Days when the voice of Iranian people demanding their rights was answered with bullets, and the value of staying connected was understood more than ever before.

> **"If you turn off the lights and close the curtains, you yourself know that what you're doing is not right. Those who do right things don't fear the light."**

---

🔴 **Current Situation (Bahman 1404 / February 2026)**

Internet access in Iran faces severe restrictions, and many users are in a communication deadlock. Now more than ever, your contribution to keeping communication channels open is vital:

- **Need a server outside Iran:** To help this movement, you need a VPS (Virtual Private Server) outside Iran.
- **Installation with just one command:** No complex technical knowledge needed; you can set up your Conduit node with just one script execution.
- **Direct impact:** Every server added directly increases Psiphon network's power to bypass censorship.
- **About server selection:** To reduce costs, use servers with unlimited traffic or high monthly bandwidth. Like Hetzner, BlueVPS, HostVDS, Contabo, etc.

---

## Features v2.0 🆕

### Core Features (v1.0)
- ✅ One-command installation (fully automated)
- ✅ Dedicated `conduit` command for easy management from anywhere
- ✅ Live reporting of user count and traffic volume
- ✅ High stability with RAM limit configuration
- ✅ Auto-restart after server reboot
- ✅ Optimized for low-end VPS servers

### New Features v2.0 🌟
- 🆕 **Historical Tracking:** Automatic hourly statistics storage for up to 90 days
- 🆕 **Trend Charts:** View 7-day changes graphically
- 🆕 **Impact Report:** Summary of your contribution to internet freedom
- 🆕 **CSV Export:** Download statistics for detailed analysis
- 🆕 **Telegram Notifications:** Receive daily reports and alerts (optional)
- 🆕 **Enhanced UI:** More beautiful and professional information display

---

## Requirements

**Hardware:**
- Minimum 512MB RAM (lightweight and optimized)
- Minimum 5GB free space

**Software:**
- Ubuntu 20.04+, Debian 10+
- Root or sudo access
- **Important:** Server must be located outside Iran.

---

## Installation

### One-Line Installation (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/netadminplus/conduit-docker/main/install.sh | sudo bash
```

### Alternative Method: Download and Run

```bash
curl -fsSL https://raw.githubusercontent.com/netadminplus/conduit-docker/main/install.sh -o install.sh
chmod +x install.sh
sudo ./install.sh
```

**Note:** During installation, you'll be asked if you want to enable Telegram notifications. This step is optional and can be configured later.

---

## Conduit Management Commands

After installation, you can manage the conduit from anywhere using the dedicated `conduit` command:

### Main Commands

```bash
conduit report      # View live user count and traffic report
conduit logs        # View system logs and connection status
conduit down        # Stop the conduit
conduit up          # Start the conduit
conduit restart     # Quick service restart
conduit help        # Show command help
```

**Example `conduit report` output:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 Psiphon Conduit Live Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🟢 Status: Running
👥 Connected Clients: 45
⬆️  Upload: 2.3 GB
⬇️  Download: 1.2 GB
⏱  Uptime: 2 days 5 hours
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💡 You're helping people access freedom
```

### New Commands v2.0

```bash
conduit history     # Show 7-day trends with charts
conduit summary     # Weekly impact summary
conduit export      # Export data to CSV format
conduit telegram    # Manage Telegram notifications
```

**Example `conduit history` output:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📈 7-Day Trends
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total Data Points: 168 hours
Peak Clients: 68
Total Upload: 23456 MB
Total Download: 12345 MB

Daily Trend (average clients):
Jan 25: ████████████ 48
Jan 26: ██████████ 42
Jan 27: ████████████████ 61
Jan 28: ███████████████ 58
Jan 29: █████████████ 52
Jan 30: ██████████████ 55
Jan 31: ████████████████████ 68
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Example `conduit summary` output:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🕯️  Weekly Impact Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
This week you helped:
  👥 ~680 people access the free internet
  📊 Served 35.1 GB of uncensored data
  ⏱ 168 hours of uptime

💡 Every byte counts. Thank you for your contribution
   to internet freedom.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Historical Tracking

Version 2.0 automatically saves your station's statistics every hour and keeps them for up to 90 days.

### How It Works

1. Every hour, an automated script (`conduit-history`) runs
2. Current statistics are read from `stats.json` file
3. A new snapshot is added to `history.json` file
4. Maximum 2160 records (90 days) are retained

### Viewing History

```bash
conduit history     # 7-day chart
conduit summary     # Weekly summary
conduit export      # Download CSV file
```

**CSV file includes these columns:**
- `timestamp`: Exact time (Unix timestamp)
- `datetime`: Human-readable date and time
- `clients`: Number of connected users
- `upload_mb`: Upload volume (megabytes)
- `download_mb`: Download volume (megabytes)
- `uptime_minutes`: Active time (minutes)

---

## Telegram Notifications (Optional)

You can set up a Telegram bot to receive daily reports and alerts.

### Setting Up Telegram

**Step 1: Create a Bot**
1. Go to [@BotFather](https://t.me/BotFather) on Telegram
2. Send `/newbot` command
3. Choose a name and username for your bot
4. Copy the **Bot Token** (like: `123456:ABC-DEF...`)

**Step 2: Find Your Chat ID**
1. Go to [@userinfobot](https://t.me/userinfobot)
2. Send `/start` command
3. Copy your **Chat ID** (a number like: `123456789`)

**Step 3: Configure in Conduit**

```bash
conduit telegram setup
```

Enter your Token and Chat ID.

**Step 4: Test It**

```bash
conduit telegram test
```

If you received the test message, configuration was successful! ✅

### Types of Notifications

**Daily Report (every day at 8 AM):**

```
🤖 Conduit Daily Report

📊 Last 24 Hours:
👥 Clients: 45 (peak: 68)
⬆️ Upload: 3.2 GB
⬇️ Download: 1.8 GB
⏱ Uptime: 100%

💚 Keep running! You're making a difference.
```

**Downtime Alert (checked every 30 minutes):**

```
⚠️ Conduit Alert

Your Conduit container has stopped.
Please check: conduit logs

Server: your-server-hostname
Time: 2026-01-31 14:30 UTC
```

### Telegram Management

```bash
conduit telegram setup    # Setup or change configuration
conduit telegram test     # Send test message
conduit telegram disable  # Turn off notifications
```

**Security Notes:**
- Bot information is stored in `telegram.conf` file with limited access (chmod 600)
- No data is sent to external services (except Telegram API)
- Don't share your Bot Token with anyone

---

## File Structure

Default installation path is `~/conduit-docker`:

```
conduit-docker/
├── docker-compose.yaml       # Docker settings and resource limits
├── conduit-data/             # Data storage folder (very important - backup this!)
│   ├── stats.json            # Live data (created by Conduit)
│   ├── history.json          # Last 90 days history (v2.0)
│   ├── telegram.conf         # Telegram settings (if enabled)
│   └── conduit_key.json      # Your bridge identity on Psiphon network
└── install.sh                # Installation script
```

**Important:** Always backup the `conduit-data` folder! This folder contains your station's unique identity and all historical statistics.

---

## Frequently Asked Questions (FAQ)

### How do I view statistical trends?

```bash
conduit history    # 7-day chart
conduit summary    # Weekly summary
```

**Note:** Historical statistics start collecting from the first hour after installation. Wait at least a few hours to see trends.

### How do I export data?

```bash
conduit export
```

A CSV file will be created in your home folder that you can open with Excel or Google Sheets.

### How do I set up Telegram?

Complete steps are explained in the [Telegram Notifications](#telegram-notifications-optional) section. In summary:

1. Get a Bot Token from @BotFather
2. Get your Chat ID from @userinfobot
3. Run `conduit telegram setup` command

### What data is stored?

Only this information is stored locally on your server:
- Number of connected users per hour
- Upload and download traffic volume
- Service uptime duration

No personal information or user identifiers are stored.

### Is my data safe?

Yes! All data is stored only on your server:
- No information is sent to external services
- Only you have access to this data
- Only exception: If you enable Telegram, reports are sent via Telegram API

### How much disk space is used?

- `history.json` file: About 1-2 megabytes (90 days of data)
- Docker logs: Maximum 30 megabytes (limited)
- Total usage: Less than 100 megabytes

### What happens if I reboot the server?

Don't worry! Everything starts automatically:
- Docker starts automatically
- Container runs automatically
- Statistics collection continues
- No action needed from you

### How do I backup historical statistics?

```bash
# Copy entire folder
cp -r ~/conduit-docker/conduit-data ~/conduit-backup

# Or just important files
cp ~/conduit-docker/conduit-data/history.json ~/history-backup.json
cp ~/conduit-docker/conduit-data/conduit_key.json ~/key-backup.json
```

---

## Troubleshooting

### Station won't start

```bash
# Check status
docker ps -a

# View logs
conduit logs

# Restart
conduit restart
```

### Statistics not showing

```bash
# Check stats file
cat ~/conduit-docker/conduit-data/stats.json

# If file is empty, wait a few minutes
# Then try again
conduit report
```

### Telegram not working

```bash
# Test again
conduit telegram test

# If it gives an error, reconfigure
conduit telegram setup
```

### History collection not working

```bash
# Check cron jobs
crontab -l

# Run manually
/usr/local/bin/conduit-history

# Check result
cat ~/conduit-docker/conduit-data/history.json
```

---

## Upgrading from v1.0 to v2.0

If you previously installed v1.0:

```bash
# 1. Go to project folder
cd ~/conduit-docker

# 2. Download new install.sh
curl -fsSL https://raw.githubusercontent.com/netadminplus/conduit-docker/main/install.sh -o install.sh

# 3. Run installation again (previous data will be preserved)
sudo bash install.sh
```

**Note:** Your previous identity and key will be preserved, no need to reconfigure.

---

## Support

- 📺 **YouTube**: [@netadminplus](https://youtube.com/@netadminplus)
- 🌐 **Website**: [netadminplus.com](https://netadminplus.com)
- 📸 **Instagram**: [@netadminplus](https://instagram.com/netadminplus)
- 🐛 **Report Issues**: [GitHub Issues](https://github.com/netadminplus/conduit-docker/issues)

---

## License

MIT License - Free to use and modify

---

## Creator

**Ramtin Rahmaninezhad - Net Admin Plus**

Helping the Iranian community deploy open-source communication tools

[YouTube](https://youtube.com/@netadminplus) • [Website](https://netadminplus.com) • [Instagram](https://instagram.com/netadminplus)

---

## Support the Project

If this project helped with Internet freedom:

- ⭐ Star this repository
- 📺 Subscribe to [Net Admin Plus](https://youtube.com/@netadminplus) channel
- 📢 Share this link with Iranians outside the country
- 💬 Share your experiences in Issues or YouTube comments

Every server added means one more person can make their voice heard to the world. 🕯️

---

**Made with ❤️ for Iran**

**Version 2.0 - Bahman 1404 / February 2026**
