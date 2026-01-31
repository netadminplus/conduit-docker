#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}>>> Starting Psiphon Conduit Installation v2.0 (by NetAdminPlus)...${NC}"

# 1. Check and Install Docker
if ! [ -x "$(command -v docker)" ]; then
    echo -e "${YELLOW}>>> Docker is not installed. Installing Docker...${NC}"
    curl -fsSL https://get.docker.com | sh
    systemctl enable --now docker
else
    echo -e "${GREEN}✓ [OK] Docker is already installed.${NC}"
fi

# 2. Check and Install jq (required for JSON operations)
if ! [ -x "$(command -v jq)" ]; then
    echo -e "${YELLOW}>>> Installing jq for JSON processing...${NC}"
    if [ -x "$(command -v apt-get)" ]; then
        apt-get update && apt-get install -y jq
    elif [ -x "$(command -v yum)" ]; then
        yum install -y jq
    else
        echo -e "${RED}⚠ Could not install jq automatically. Please install manually.${NC}"
    fi
else
    echo -e "${GREEN}✓ [OK] jq is already installed.${NC}"
fi

# 3. Setup project structure
PROJECT_DIR="$HOME/conduit-docker"
mkdir -p "$PROJECT_DIR/conduit-data"
chmod -R 777 "$PROJECT_DIR/conduit-data"
cd "$PROJECT_DIR"

# 4. Create docker-compose.yaml with detailed documentation
echo -e "${BLUE}>>> Creating documented docker-compose.yaml...${NC}"
cat <<EOF > docker-compose.yaml
services:
  conduit:
    # Official community-maintained image based on Psiphon CLI
    image: ghcr.io/ssmirr/conduit/conduit:latest
    container_name: psiphon-conduit
    restart: unless-stopped
    
    # Configuration parameters
    command: 
      - "start"
      - "--data-dir"
      - "/data"
      - "--max-clients"
      - "1000"         # [Changeable] Max simultaneous users (1-1000)
      - "--bandwidth"
      - "-1"           # [Changeable] Bandwidth limit in Mbps (-1 for unlimited)
      - "--stats-file"
      - "/data/stats.json" # Required for monitoring and reports
    
    volumes:
      - ./conduit-data:/data
    
    # Resource management to protect your server
    deploy:
      resources:
        limits:
          memory: 512M # Prevents the container from consuming all server RAM
    
    # Log management to prevent disk space issues
    logging:
      driver: "json-file"
      options:
        max-size: "10m" # Max size of a single log file
        max-file: "3"   # Number of log files to keep
EOF

# 5. Create the enhanced 'conduit' main command
echo -e "${BLUE}>>> Setting up enhanced 'conduit' command...${NC}"
cat <<'MAINEOF' > /usr/local/bin/conduit
#!/bin/bash
STATS_FILE="$HOME/conduit-docker/conduit-data/stats.json"
HISTORY_FILE="$HOME/conduit-docker/conduit-data/history.json"
COMPOSE_PATH="$HOME/conduit-docker"
TELEGRAM_CONF="$HOME/conduit-docker/conduit-data/telegram.conf"

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Helper function to format bytes
format_bytes() {
    local bytes=$1
    if [ "$bytes" -lt 1073741824 ]; then
        echo "scale=2; $bytes/1048576" | bc | awk '{printf "%.2f MB", $1}'
    else
        echo "scale=2; $bytes/1073741824" | bc | awk '{printf "%.2f GB", $1}'
    fi
}

# Helper function to format uptime
format_uptime() {
    local seconds=$1
    local days=$((seconds / 86400))
    local hours=$(((seconds % 86400) / 3600))
    local minutes=$(((seconds % 3600) / 60))
    
    if [ $days -gt 0 ]; then
        echo "${days} days ${hours} hours"
    elif [ $hours -gt 0 ]; then
        echo "${hours} hours ${minutes} minutes"
    else
        echo "${minutes} minutes"
    fi
}

case "$1" in
    report)
        if [ -f "$STATS_FILE" ]; then
            echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "${GREEN}📊 Psiphon Conduit Live Report${NC}"
            echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            
            # Check if container is running
            if docker ps --format '{{.Names}}' | grep -q "psiphon-conduit"; then
                echo -e "${GREEN}🟢 Status: Running${NC}"
            else
                echo -e "${RED}🔴 Status: Stopped${NC}"
            fi
            
            # Read and display stats
            clients=$(jq -r '.connectedClients // 0' "$STATS_FILE")
            upload=$(jq -r '.totalBytesUp // 0' "$STATS_FILE")
            download=$(jq -r '.totalBytesDown // 0' "$STATS_FILE")
            uptime=$(jq -r '.uptimeSeconds // 0' "$STATS_FILE")
            
            echo -e "${YELLOW}👥 Connected Clients:${NC} $clients"
            echo -e "${YELLOW}⬆️  Upload:${NC} $(format_bytes $upload)"
            echo -e "${YELLOW}⬇️  Download:${NC} $(format_bytes $download)"
            echo -e "${YELLOW}⏱  Uptime:${NC} $(format_uptime $uptime)"
            echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "${GREEN}💡 You're helping people access freedom${NC}"
        else
            echo -e "${RED}⚠️  No stats available yet.${NC}"
            echo -e "${YELLOW}Please wait a few minutes after installation...${NC}"
        fi
        ;;
        
    history)
        if [ ! -f "$HISTORY_FILE" ]; then
            echo -e "${RED}⚠️  No historical data available yet.${NC}"
            echo -e "${YELLOW}History tracking starts after installation.${NC}"
            echo -e "${YELLOW}Data will be collected hourly. Check back in a few hours.${NC}"
            exit 0
        fi
        
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}📈 7-Day Trends${NC}"
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        
        # Get last 7 days of data (168 hours)
        last_week=$(jq -r 'if length > 168 then .[-168:] else . end' "$HISTORY_FILE")
        
        # Calculate totals
        total_upload=$(echo "$last_week" | jq '[.[].upload_mb] | add // 0')
        total_download=$(echo "$last_week" | jq '[.[].download_mb] | add // 0')
        peak_clients=$(echo "$last_week" | jq '[.[].clients] | max // 0')
        total_entries=$(echo "$last_week" | jq 'length')
        
        echo -e "${YELLOW}Total Data Points:${NC} $total_entries hours"
        echo -e "${YELLOW}Peak Clients:${NC} $peak_clients"
        echo -e "${YELLOW}Total Upload:${NC} ${total_upload} MB"
        echo -e "${YELLOW}Total Download:${NC} ${total_download} MB"
        echo ""
        
        # Daily trend (last 7 days)
        echo -e "${GREEN}Daily Trend (average clients):${NC}"
        
        # Get daily averages
        for i in {6..0}; do
            day_start=$((i * 24))
            day_end=$(((i + 1) * 24))
            
            if [ $total_entries -lt $day_end ]; then
                continue
            fi
            
            day_data=$(echo "$last_week" | jq "[.[-$day_end:-$day_start // -1]] | if length > 0 then ([.[].clients] | add / length | floor) else 0 end")
            
            # Format date
            date_str=$(date -d "$i days ago" "+%b %d" 2>/dev/null || date -v-${i}d "+%b %d" 2>/dev/null)
            
            # Create bar chart (scale: 1 block = 5 clients)
            bar_length=$((day_data / 5))
            [ $bar_length -lt 1 ] && bar_length=1
            bar=$(printf '█%.0s' $(seq 1 $bar_length))
            
            printf "${YELLOW}%s:${NC} %s %d\n" "$date_str" "$bar" "$day_data"
        done
        
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        ;;
        
    summary)
        if [ ! -f "$HISTORY_FILE" ]; then
            echo -e "${RED}⚠️  No historical data available yet.${NC}"
            exit 0
        fi
        
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}🕯️  Weekly Impact Summary${NC}"
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        
        # Get last 7 days
        last_week=$(jq -r 'if length > 168 then .[-168:] else . end' "$HISTORY_FILE")
        
        total_upload=$(echo "$last_week" | jq '[.[].upload_mb] | add // 0' | awk '{printf "%.0f", $1}')
        total_download=$(echo "$last_week" | jq '[.[].download_mb] | add // 0' | awk '{printf "%.0f", $1}')
        total_data=$((total_upload + total_download))
        total_gb=$(echo "scale=2; $total_data/1024" | bc)
        peak_clients=$(echo "$last_week" | jq '[.[].clients] | max // 0')
        uptime_hours=$(echo "$last_week" | jq 'length')
        
        # Estimate unique users (very rough: peak * 10)
        estimated_users=$((peak_clients * 10))
        
        echo -e "${YELLOW}This week you helped:${NC}"
        echo -e "  ${GREEN}👥 ~$estimated_users people access the free internet${NC}"
        echo -e "  ${GREEN}📊 Served ${total_gb} GB of uncensored data${NC}"
        echo -e "  ${GREEN}⏱ $uptime_hours hours of uptime${NC}"
        echo ""
        echo -e "${BLUE}💡 Every byte counts. Thank you for your contribution${NC}"
        echo -e "${BLUE}   to internet freedom.${NC}"
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        ;;
        
    export)
        if [ ! -f "$HISTORY_FILE" ]; then
            echo -e "${RED}⚠️  No historical data to export.${NC}"
            exit 0
        fi
        
        output_file="$HOME/conduit-export-$(date +%Y%m%d-%H%M%S).csv"
        
        echo "timestamp,datetime,clients,upload_mb,download_mb,uptime_minutes" > "$output_file"
        jq -r '.[] | [.timestamp, (.timestamp | strftime("%Y-%m-%d %H:%M:%S")), .clients, .upload_mb, .download_mb, .uptime_minutes] | @csv' "$HISTORY_FILE" >> "$output_file"
        
        echo -e "${GREEN}✓ Data exported to: $output_file${NC}"
        echo -e "${YELLOW}Total records: $(wc -l < "$output_file" | awk '{print $1-1}')${NC}"
        ;;
        
    telegram)
        case "$2" in
            setup)
                echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
                echo -e "${GREEN}📱 Telegram Notifications Setup${NC}"
                echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
                echo ""
                echo -e "${YELLOW}To receive notifications, you need:${NC}"
                echo "1. A Telegram Bot Token (from @BotFather)"
                echo "2. Your Chat ID (from @userinfobot)"
                echo ""
                
                read -p "Enter Bot Token: " bot_token
                read -p "Enter Chat ID: " chat_id
                
                # Save configuration
                cat > "$TELEGRAM_CONF" <<TGEOF
BOT_TOKEN=$bot_token
CHAT_ID=$chat_id
TGEOF
                chmod 600 "$TELEGRAM_CONF"
                
                echo -e "${GREEN}✓ Configuration saved!${NC}"
                echo -e "${YELLOW}Run 'conduit telegram test' to verify${NC}"
                ;;
                
            test)
                if [ ! -f "$TELEGRAM_CONF" ]; then
                    echo -e "${RED}⚠️  Telegram not configured yet.${NC}"
                    echo -e "${YELLOW}Run 'conduit telegram setup' first${NC}"
                    exit 1
                fi
                
                source "$TELEGRAM_CONF"
                
                message="🤖 Conduit Test Message

✅ Your Telegram notifications are working!

Server: $(hostname)
Time: $(date)

You will receive daily reports and alerts."
                
                curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
                    -d chat_id="${CHAT_ID}" \
                    -d text="$message" > /dev/null
                
                echo -e "${GREEN}✓ Test message sent!${NC}"
                echo -e "${YELLOW}Check your Telegram bot${NC}"
                ;;
                
            disable)
                if [ -f "$TELEGRAM_CONF" ]; then
                    rm "$TELEGRAM_CONF"
                    echo -e "${GREEN}✓ Telegram notifications disabled${NC}"
                else
                    echo -e "${YELLOW}Telegram was not configured${NC}"
                fi
                ;;
                
            *)
                echo "Usage: conduit telegram {setup|test|disable}"
                ;;
        esac
        ;;
        
    logs)
        docker logs -f psiphon-conduit
        ;;
        
    up)
        cd "$COMPOSE_PATH" && docker compose up -d
        echo -e "${GREEN}✓ Conduit started${NC}"
        ;;
        
    down)
        cd "$COMPOSE_PATH" && docker compose down
        echo -e "${YELLOW}Conduit stopped${NC}"
        ;;
        
    restart)
        cd "$COMPOSE_PATH" && docker compose restart
        echo -e "${GREEN}✓ Conduit restarted${NC}"
        ;;
        
    --help|help|-h)
        echo -e "${GREEN}Conduit v2.0 - Psiphon Bridge Management${NC}"
        echo ""
        echo "Usage: conduit <command>"
        echo ""
        echo "Main Commands:"
        echo "  report          Show live status and current connections"
        echo "  history         Display 7-day trends and statistics"
        echo "  summary         Show weekly impact summary"
        echo "  export          Export historical data to CSV"
        echo ""
        echo "Telegram Notifications:"
        echo "  telegram setup  Configure Telegram bot"
        echo "  telegram test   Send test message"
        echo "  telegram disable Turn off notifications"
        echo ""
        echo "Container Management:"
        echo "  logs            View container logs (live)"
        echo "  up              Start the container"
        echo "  down            Stop the container"
        echo "  restart         Restart the container"
        echo ""
        echo "For more information: https://github.com/netadminplus/conduit-docker"
        ;;
        
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        echo "Run 'conduit help' for available commands"
        exit 1
        ;;
esac
MAINEOF

chmod +x /usr/local/bin/conduit

# 6. Create the history collector script
echo -e "${BLUE}>>> Creating history collector script...${NC}"
cat <<'HISTEOF' > /usr/local/bin/conduit-history
#!/bin/bash

STATS_FILE="$HOME/conduit-docker/conduit-data/stats.json"
HISTORY_FILE="$HOME/conduit-docker/conduit-data/history.json"

# Only run if stats file exists
if [ ! -f "$STATS_FILE" ]; then
    exit 0
fi

# Read current stats
clients=$(jq -r '.connectedClients // 0' "$STATS_FILE")
upload=$(jq -r '.totalBytesUp // 0' "$STATS_FILE")
download=$(jq -r '.totalBytesDown // 0' "$STATS_FILE")
uptime=$(jq -r '.uptimeSeconds // 0' "$STATS_FILE")

# Convert to MB
upload_mb=$(echo "scale=2; $upload/1048576" | bc | awk '{printf "%.0f", $1}')
download_mb=$(echo "scale=2; $download/1048576" | bc | awk '{printf "%.0f", $1}')
uptime_min=$((uptime / 60))

# Create new entry
timestamp=$(date +%s)
new_entry=$(jq -n \
    --arg ts "$timestamp" \
    --arg clients "$clients" \
    --arg up "$upload_mb" \
    --arg down "$download_mb" \
    --arg uptime "$uptime_min" \
    '{
        timestamp: ($ts | tonumber),
        clients: ($clients | tonumber),
        upload_mb: ($up | tonumber),
        download_mb: ($down | tonumber),
        uptime_minutes: ($uptime | tonumber)
    }')

# Initialize or append to history
if [ ! -f "$HISTORY_FILE" ]; then
    echo "[$new_entry]" > "$HISTORY_FILE"
else
    # Read existing, append new, keep last 2160 entries (90 days)
    jq ". += [$new_entry] | if length > 2160 then .[-2160:] else . end" "$HISTORY_FILE" > "${HISTORY_FILE}.tmp"
    mv "${HISTORY_FILE}.tmp" "$HISTORY_FILE"
fi

chmod 644 "$HISTORY_FILE"
HISTEOF

chmod +x /usr/local/bin/conduit-history

# 7. Create the Telegram notification script
echo -e "${BLUE}>>> Creating Telegram notification script...${NC}"
cat <<'TGEOF' > /usr/local/bin/conduit-telegram
#!/bin/bash

STATS_FILE="$HOME/conduit-docker/conduit-data/stats.json"
HISTORY_FILE="$HOME/conduit-docker/conduit-data/history.json"
TELEGRAM_CONF="$HOME/conduit-docker/conduit-data/telegram.conf"

# Exit if Telegram not configured
if [ ! -f "$TELEGRAM_CONF" ]; then
    exit 0
fi

source "$TELEGRAM_CONF"

# Check if container is running
if ! docker ps --format '{{.Names}}' | grep -q "psiphon-conduit"; then
    # Send alert
    message="⚠️ Conduit Alert

Your Conduit container has stopped.
Please check: conduit logs

Server: $(hostname)
Time: $(date -u +'%Y-%m-%d %H:%M UTC')"
    
    curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
        -d chat_id="${CHAT_ID}" \
        -d text="$message" > /dev/null
    exit 0
fi

# Get stats
if [ ! -f "$STATS_FILE" ]; then
    exit 0
fi

clients=$(jq -r '.connectedClients // 0' "$STATS_FILE")
upload=$(jq -r '.totalBytesUp // 0' "$STATS_FILE" | awk '{printf "%.2f GB", $1/1073741824}')
download=$(jq -r '.totalBytesDown // 0' "$STATS_FILE" | awk '{printf "%.2f GB", $1/1073741824}')

# Get 24h peak from history
peak_24h=0
if [ -f "$HISTORY_FILE" ]; then
    peak_24h=$(jq -r 'if length > 24 then .[-24:] else . end | [.[].clients] | max // 0' "$HISTORY_FILE")
fi

# Calculate uptime percentage (assume hourly checks)
uptime_pct=100
if [ -f "$HISTORY_FILE" ]; then
    total_checks=$(jq 'if length > 24 then 24 else length end' "$HISTORY_FILE")
    uptime_pct=$((total_checks * 100 / 24))
fi

# Send daily report
message="🤖 Conduit Daily Report

📊 Last 24 Hours:
👥 Clients: $clients (peak: $peak_24h)
⬆️ Upload: $upload
⬇️ Download: $download
⏱ Uptime: ${uptime_pct}%

💚 Keep running! You're making a difference."

curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    -d chat_id="${CHAT_ID}" \
    -d text="$message" > /dev/null
TGEOF

chmod +x /usr/local/bin/conduit-telegram

# 8. Setup cron jobs
echo -e "${BLUE}>>> Setting up automated tasks...${NC}"

# Add hourly history collection
(crontab -l 2>/dev/null | grep -v conduit-history; echo "0 * * * * /usr/local/bin/conduit-history") | crontab -

# Ask user about Telegram notifications
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Optional: Telegram Notifications${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -p "Do you want to setup Telegram notifications? (y/n): " setup_telegram

if [[ "$setup_telegram" =~ ^[Yy]$ ]]; then
    /usr/local/bin/conduit telegram setup
    
    # Add daily report cron job (8 AM daily)
    (crontab -l 2>/dev/null | grep -v conduit-telegram; echo "0 8 * * * /usr/local/bin/conduit-telegram") | crontab -
    
    # Add check every 30 minutes for container status
    (crontab -l 2>/dev/null | grep -v "conduit-telegram.*check"; echo "*/30 * * * * /usr/local/bin/conduit-telegram # check") | crontab -
    
    echo -e "${GREEN}✓ Telegram notifications enabled${NC}"
else
    echo -e "${YELLOW}You can setup Telegram later with: conduit telegram setup${NC}"
fi

# 9. Start the engine
echo -e "${BLUE}>>> Starting the Psiphon Conduit engine...${NC}"
docker compose up -d

# Wait a moment for container to start
sleep 3

# Run first history snapshot
/usr/local/bin/conduit-history

# Final Output
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Installation Completed Successfully! v2.0${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Available commands:${NC}"
echo -e "  ${BLUE}conduit report${NC}    - Live status and connections"
echo -e "  ${BLUE}conduit history${NC}   - 7-day trends and charts"
echo -e "  ${BLUE}conduit summary${NC}   - Weekly impact summary"
echo -e "  ${BLUE}conduit export${NC}    - Export data to CSV"
echo -e "  ${BLUE}conduit telegram${NC}  - Manage notifications"
echo -e "  ${BLUE}conduit logs${NC}      - View live logs"
echo -e "  ${BLUE}conduit up/down${NC}   - Start/stop container"
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🕯️  Dedicated to internet freedom fighters${NC}"
echo -e "${YELLOW}    In memory of Dey 18-19, 1404${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}💡 Run 'conduit report' to see your first stats!${NC}"
