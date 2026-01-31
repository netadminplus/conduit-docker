<div align="left">

**English** | [فارسی](README.md

# One-Command Psiphon Conduit Installation

**Easy Psiphon Bridge setup with Docker and intelligent management to help Internet freedom in Iran**

[Ramtin Rahmaninezhad - Net Admin Plus](https://netadminplus.com)

[YouTube](https://youtube.com/@netadminplus) • [Website](https://netadminplus.com) • [Instagram](https://instagram.com/netadminplus)

---

🕯️ This tool is dedicated to those who strive for Internet freedom.

---

## Features

- One-command installation (fully automated)
- Dedicated `conduit` command for easy management from anywhere
- Live reporting of user count and traffic volume
- High stability with RAM limit configuration
- Auto-restart after server reboot
- Optimized for low-end VPS servers

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
curl -fsSL https://raw.githubusercontent.com/netadminplus/conduit-docker/main/install.sh
chmod +x install.sh
sudo ./install.sh
```

---

## Conduit Management Commands

After installation, you can manage the conduit from anywhere using the dedicated `conduit` command:

```bash
conduit report      # View live user count and traffic report
conduit logs        # View system logs and connection status
conduit down        # Stop the conduit
conduit up          # Start the conduit
conduit restart     # Quick service restart
```

---

## File Structure

Default installation path is `~/conduit-docker`:

```
conduit-docker/
├── docker-compose.yaml       # Docker settings and resource limits
├── conduit-data/             # Key and stats storage folder (very important)
│   ├── stats.json            # Live data file
│   └── conduit_key.json      # Your bridge identity on Psiphon network
└── install.sh                # Installation script
```

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

---

**Made with ❤️ for Iran**
