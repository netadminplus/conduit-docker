# Conduit-Docker v2.0 Implementation Guide

## Quick Start for Developers

This guide explains how to deploy the v2.0 files to the repository and test them.

## Files Overview

You now have these files ready:

1. **install.sh** - Modified installation script with v2.0 features
2. **README.md** - Complete Persian documentation
3. **README.en.md** - Complete English documentation
4. **CHANGELOG.md** - Detailed change log

## Scripts Created During Installation

The install.sh creates these scripts on the target system:

1. **`/usr/local/bin/conduit`** - Main management command (enhanced)
2. **`/usr/local/bin/conduit-history`** - Hourly data collector
3. **`/usr/local/bin/conduit-telegram`** - Telegram notification system

## Deployment Steps

### 1. Update GitHub Repository

```bash
# Navigate to your local conduit-docker repo
cd /path/to/conduit-docker

# Replace files
cp /path/to/new/install.sh ./install.sh
cp /path/to/new/README.md ./README.md
cp /path/to/new/README.en.md ./README.en.md
cp /path/to/new/CHANGELOG.md ./CHANGELOG.md

# Commit changes
git add .
git commit -m "Release v2.0: Historical tracking, Telegram notifications, enhanced reporting"

# Push to GitHub
git push origin main

# Create release tag
git tag -a v2.0.0 -m "Version 2.0: Full featured monitoring and notifications"
git push origin v2.0.0
```

### 2. Testing Checklist

#### Fresh Installation Test

```bash
# On a clean Ubuntu 20.04+ server
curl -fsSL https://raw.githubusercontent.com/netadminplus/conduit-docker/main/install.sh | sudo bash

# Verify installation
conduit help
conduit report
docker ps

# Wait 1-2 hours, then test history
conduit history
```

#### Upgrade Test (v1.0 to v2.0)

```bash
# On a server with v1.0 installed
cd ~/conduit-docker
curl -fsSL https://raw.githubusercontent.com/netadminplus/conduit-docker/main/install.sh -o install.sh
sudo bash install.sh

# Verify old data preserved
ls -la ~/conduit-docker/conduit-data/conduit_key.json

# Test new features
conduit history
conduit summary
```

#### Telegram Integration Test

```bash
# Setup
conduit telegram setup
# Enter test bot credentials

# Test
conduit telegram test
# Check Telegram for test message

# Verify cron jobs
crontab -l | grep conduit
```

### 3. Feature Verification

#### Historical Tracking

```bash
# Manual history collection
sudo /usr/local/bin/conduit-history

# Check history file
cat ~/conduit-docker/conduit-data/history.json | jq '.' | head -20

# Wait for hourly cron to run
# Check at :05 past the hour
tail -f /var/log/syslog | grep conduit-history
```

#### Export Functionality

```bash
conduit export
ls -lh ~/conduit-export-*.csv
head -5 ~/conduit-export-*.csv
```

#### Report Commands

```bash
# Live report
conduit report

# Trends (requires some history)
conduit history

# Weekly summary
conduit summary
```

### 4. Performance Testing

```bash
# CPU usage during history collection
top -b -n 1 | grep conduit-history

# Memory usage
ps aux | grep conduit

# Disk usage
du -sh ~/conduit-docker/conduit-data/

# Response time
time conduit report
time conduit history
```

### 5. Security Verification

```bash
# Check file permissions
ls -la ~/conduit-docker/conduit-data/telegram.conf
# Should be: -rw------- (600)

# Check script permissions
ls -la /usr/local/bin/conduit*
# Should all be: -rwxr-xr-x (755)

# Verify no external connections except Telegram
netstat -tupn | grep conduit
```

## Common Issues and Solutions

### Issue: jq not installing

**Solution:**
```bash
# Manual installation
sudo apt-get update
sudo apt-get install -y jq
```

### Issue: Cron jobs not running

**Solution:**
```bash
# Check cron service
sudo systemctl status cron

# View cron logs
grep CRON /var/log/syslog

# Manually verify script works
sudo /usr/local/bin/conduit-history
```

### Issue: Telegram messages not sending

**Solution:**
```bash
# Test bot token manually
BOT_TOKEN="your_token"
CHAT_ID="your_chat_id"
curl -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d chat_id="${CHAT_ID}" \
  -d text="Test"

# Check telegram.conf exists and has correct format
cat ~/conduit-docker/conduit-data/telegram.conf
```

### Issue: History file not created

**Solution:**
```bash
# Check if stats.json exists
cat ~/conduit-docker/conduit-data/stats.json

# Manually run history script with debug
bash -x /usr/local/bin/conduit-history
```

## Rollback Plan

If v2.0 has issues, users can rollback:

```bash
# Stop current version
conduit down

# Checkout v1.0
cd ~/conduit-docker
git fetch --tags
git checkout v1.0.0

# Reinstall v1.0
sudo bash install.sh

# Note: History data will be preserved but not accessible in v1.0
```

## Documentation Updates Needed

After deployment, update:

1. **YouTube Tutorial:**
   - Create new video showing v2.0 features
   - Update description with new commands
   - Pin comment about v2.0 release

2. **Website:**
   - Update feature list
   - Add screenshots of new commands
   - Update installation instructions

3. **Social Media:**
   - Instagram post about v2.0
   - Tweet/thread about new features
   - Persian-language announcement

## Support Preparation

Prepare for common user questions:

1. **"How do I upgrade from v1.0?"**
   - Answer: Just re-run the installation script, data is preserved

2. **"Is Telegram required?"**
   - Answer: No, it's completely optional

3. **"How much data does history tracking use?"**
   - Answer: About 1-2MB for 90 days

4. **"Can I export older data?"**
   - Answer: Yes, `conduit export` exports all available history

5. **"What if I delete history.json?"**
   - Answer: It will start fresh from next hour, no problem

## Marketing Points for Announcement

Highlight these benefits:

- 📊 **See Your Impact:** Visual charts show how many people you're helping
- 🕒 **90 Days of History:** Track your contribution over time
- 📱 **Stay Informed:** Optional Telegram alerts keep you connected
- 📈 **Professional Reports:** Beautiful, motivating weekly summaries
- 💾 **Export Your Data:** Keep records of your contribution to freedom

## Next Steps

1. Deploy to GitHub
2. Test fresh installation
3. Test upgrade path
4. Create demo video
5. Announce release
6. Monitor for issues
7. Iterate based on feedback

---

**Remember:** This tool helps real people access freedom. Test thoroughly - bugs can cost lives in censored regions.

🕯️ Every installation matters.
