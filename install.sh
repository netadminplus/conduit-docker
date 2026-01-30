#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}>>> Starting Psiphon Conduit Installation (by NetAdminPlus)...${NC}"

# 1. Check and Install Docker
if ! [ -x "$(command -v docker)" ]; then
    echo -e "${YELLOW}>>> Docker is not installed. Installing Docker...${NC}"
    curl -fsSL https://get.docker.com | sh
    systemctl enable --now docker
else
    echo -e "${GREEN} [OK] Docker is already installed.${NC}"
fi

# 2. Setup project structure
PROJECT_DIR="$HOME/conduit-docker"
mkdir -p "$PROJECT_DIR/conduit-data"
chmod -R 777 "$PROJECT_DIR/conduit-data"
cd "$PROJECT_DIR"

# 3. Create docker-compose.yaml with detailed documentation
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

# 4. Create the 'conduit' helper command
echo -e "${BLUE}>>> Setting up 'conduit' helper command...${NC}"
cat <<'EOF' > /usr/local/bin/conduit
#!/bin/bash
STATS_FILE="$HOME/conduit-docker/conduit-data/stats.json"
COMPOSE_PATH="$HOME/conduit-docker"

case "$1" in
    report)
        if [ -f "$STATS_FILE" ]; then
            echo "--------------------------------"
            echo "📊 Psiphon Conduit Station Report"
            echo "--------------------------------"
            python3 -c "import json; d=json.load(open('$STATS_FILE')); print(f'Connected Clients: {d.get(\"connectedClients\", 0)}\nUpload: {d.get(\"totalBytesUp\", 0)/1048576:.2f} MB\nDownload: {d.get(\"totalBytesDown\", 0)/1048576:.2f} MB\nUptime: {d.get(\"uptimeSeconds\", 0)//60} Minutes')"
            echo "--------------------------------"
        else
            echo "⚠️ No stats yet. Please wait a few minutes for the first connection..."
        fi
        ;;
    logs)
        docker logs -f psiphon-conduit
        ;;
    up)
        cd "$COMPOSE_PATH" && docker compose up -d
        ;;
    down)
        cd "$COMPOSE_PATH" && docker compose down
        ;;
    restart)
        cd "$COMPOSE_PATH" && docker compose restart
        ;;
    *)
        echo "Usage: conduit {report|logs|up|down|restart}"
        ;;
esac
EOF

chmod +x /usr/local/bin/conduit

# 5. Start the engine
echo -e "${BLUE}>>> Starting the Psiphon Conduit engine...${NC}"
docker compose up -d

# Final Output
echo -e "${GREEN}==============================================${NC}"
echo -e "${GREEN}✅ Installation Completed Successfully!${NC}"
echo -e "${GREEN}==============================================${NC}"
echo -e "${YELLOW}You can manage your station using these commands:${NC}"
echo -e "  ${BLUE}conduit report${NC}  - View active users and traffic"
echo -e "  ${BLUE}conduit logs${NC}    - See connection details"
echo -e "  ${BLUE}conduit down${NC}    - Stop the station"
echo -e "  ${BLUE}conduit up${NC}      - Start the station"
echo -e "${GREEN}==============================================${NC}"
