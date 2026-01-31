# Conduit-Docker v2.0 Changelog

## Version 2.0 - February 2026

### 🎯 Major New Features

#### 1. Historical Tracking System
- **Automated Data Collection:** New `conduit-history` script runs hourly via cron
- **90-Day Retention:** Stores up to 2160 hourly snapshots (90 days) in `history.json`
- **Efficient Storage:** Lightweight JSON format, ~1-2MB for full history
- **Data Points:** Tracks clients, upload/download MB, and uptime per hour

#### 2. Enhanced Reporting Commands
- **`conduit history`:** 7-day trend visualization with ASCII charts
  - Shows daily average client counts
  - Displays total upload/download statistics
  - Beautiful bar chart visualization
  
- **`conduit summary`:** Weekly impact report
  - Estimated number of people helped
  - Total data served
  - Uptime hours
  - Motivational messaging

- **`conduit export`:** CSV data export
  - Full historical data in CSV format
  - Compatible with Excel, Google Sheets
  - Includes timestamp, datetime, clients, traffic, uptime

#### 3. Telegram Notifications (Optional)
- **Setup Wizard:** Interactive `conduit telegram setup` command
- **Daily Reports:** Automatic daily summaries sent at 8 AM
- **Downtime Alerts:** Container status checked every 30 minutes
- **Secure Storage:** Bot credentials stored with chmod 600
- **Easy Management:** Test, disable, or reconfigure anytime

### 🔧 Core Improvements

#### Enhanced Main Command (`/usr/local/bin/conduit`)
- **Better UI:** Professional formatting with Unicode box-drawing characters
- **Color-Coded Output:** Green for success, yellow for info, red for errors
- **Smart Formatting:** Automatic byte conversion (MB/GB), uptime humanization
- **Help System:** Comprehensive `--help` documentation
- **Error Handling:** Friendly error messages with guidance

#### Installation Script Enhancements
- **jq Installation:** Automatic installation of JSON processor
- **Cron Setup:** Automated hourly history collection
- **Optional Telegram:** Interactive setup during installation
- **Better Feedback:** Enhanced progress messages and final summary
- **Preserved Data:** Upgrade-safe - keeps existing keys and config

### 📊 New Files and Structure

```
conduit-docker/
├── conduit-data/
│   ├── stats.json            # (existing) Live stats from Conduit
│   ├── conduit_key.json      # (existing) Node identity
│   ├── history.json          # NEW: Historical snapshots
│   └── telegram.conf         # NEW: Telegram configuration (if enabled)
```

### 🆕 New Scripts

1. **`/usr/local/bin/conduit`** (Enhanced)
   - Added: history, summary, export, telegram subcommands
   - Improved: report command with better formatting
   - Enhanced: Error handling and user feedback

2. **`/usr/local/bin/conduit-history`** (New)
   - Purpose: Hourly data collection
   - Function: Reads stats.json, appends to history.json
   - Optimization: Maintains only last 2160 entries
   - Performance: <10MB RAM usage, fast execution

3. **`/usr/local/bin/conduit-telegram`** (New)
   - Purpose: Telegram notification system
   - Daily Reports: Summary of last 24 hours
   - Alerts: Container downtime detection
   - Integration: Uses Telegram Bot API

### 📝 Documentation Updates

#### README.md (Persian)
- Complete rewrite for v2.0
- New sections:
  - Historical tracking explanation
  - Telegram setup guide
  - Comprehensive FAQ (7 questions)
  - Troubleshooting guide
  - Upgrade instructions from v1.0
- Maintained emotional tone and dedication
- Added example outputs for all new commands

#### README.en.md (English)
- Mirror structure of Persian version
- Full translation of all new features
- Same FAQ and troubleshooting sections
- Maintained activist, hopeful tone
- Technical accuracy with accessibility

### 🔒 Security & Privacy

- **Local-First:** All data stored locally on user's server
- **No External Services:** Except optional Telegram (user choice)
- **Secure Credentials:** telegram.conf protected with chmod 600
- **No User Tracking:** Only aggregate statistics, no personal data
- **Transparent:** Open source, auditable code

### ⚡ Performance Optimizations

- **Lightweight History:** Efficient JSON operations with jq
- **Cron Scheduling:** Non-overlapping hourly executions
- **Memory Efficient:** History script uses <10MB RAM
- **Fast Commands:** All commands respond in <1 second
- **Disk Management:** Automatic log rotation, history pruning

### 🎨 User Experience Improvements

- **Visual Consistency:** Unicode box-drawing characters throughout
- **Color Coding:** Consistent use of colors for different message types
- **Progress Feedback:** Clear status messages during installation
- **Error Messages:** Helpful, actionable error descriptions
- **Mobile-Friendly:** ASCII charts work well in mobile SSH clients
- **RTL Support:** Proper Persian text display

### 🌍 Accessibility

- **Simple Installation:** Still one-command install
- **Optional Features:** Telegram is opt-in, not forced
- **Help System:** Comprehensive inline help with `--help`
- **Bilingual:** Full Persian and English documentation
- **Low Barrier:** No advanced technical knowledge required

### 🔄 Backward Compatibility

- **Upgrade Safe:** v1.0 users can upgrade without losing data
- **Key Preservation:** Existing conduit_key.json maintained
- **Config Migration:** Smooth transition from v1.0 to v2.0
- **Breaking Changes:** None - all v1.0 commands still work

### 📦 Dependencies

**New:**
- jq (JSON processor) - Auto-installed during setup
- bc (calculator) - Usually pre-installed on Linux
- curl (for Telegram API) - Usually pre-installed

**Existing:**
- Docker & Docker Compose
- bash
- cron

### 🧪 Testing Checklist

- [x] install.sh runs without errors on Ubuntu 20.04+
- [x] conduit report shows live data correctly
- [x] conduit history displays after 1+ hour
- [x] conduit export creates valid CSV
- [x] conduit telegram setup works
- [x] All commands have --help text
- [x] Error messages are friendly
- [x] Both README files are complete

### 📊 Statistics

- **Lines of Code:**
  - install.sh: ~200 lines (was ~150)
  - conduit main: ~450 lines (was ~50)
  - conduit-history: ~60 lines (new)
  - conduit-telegram: ~80 lines (new)

- **Documentation:**
  - README.md: ~600 lines (was ~150)
  - README.en.md: ~550 lines (was ~120)

### 🎯 Impact

Version 2.0 empowers Conduit operators with:
- **Visibility:** See the real impact of their contribution
- **Monitoring:** Track trends and performance over time
- **Awareness:** Get notified of issues immediately
- **Motivation:** Weekly summaries show lives touched
- **Data:** Export for analysis or reporting

### 🙏 Dedication

This version 2.0 remains dedicated to:
- Those who fell on Dey 18-19, 1404 (January 8-9, 2026)
- All fighters for internet freedom in Iran
- Everyone contributing servers to help others access free information

### 🔜 Future Possibilities

Potential features for future versions:
- Web dashboard (optional)
- Multi-node management
- Advanced analytics
- Auto-scaling recommendations
- Geographic distribution stats
- Cost tracking

---

**Release Date:** February 2026  
**Maintainer:** Ramtin Rahmaninezhad - Net Admin Plus  
**License:** MIT  
**Motto:** "Every byte counts. Thank you for your contribution to internet freedom."  

🕯️ Made with ❤️ for Iran
