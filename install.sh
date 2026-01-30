#!/bin/bash

# رنگ‌ها برای زیبایی خروجی
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}>>> شروع فرآیند نصب ایستگاه Conduit (NetAdminPlus)...${NC}"

# ۱. بررسی و نصب داکر
if ! [ -x "$(command -v docker)" ]; then
    echo -e "${BLUE}>>> داکر نصب نیست. در حال نصب داکر...${NC}"
    curl -fsSL https://get.docker.com | sh
    systemctl enable --now docker
else
    echo -e "${GREEN} [OK] داکر از قبل نصب است.${NC}"
fi

# ۲. ایجاد ساختار پوشه‌ها
PROJECT_DIR="$HOME/conduit-docker"
mkdir -p "$PROJECT_DIR/conduit-data"
chmod -R 777 "$PROJECT_DIR/conduit-data"
cd "$PROJECT_DIR"

# ۳. ایجاد فایل docker-compose.yaml
cat <<EOF > docker-compose.yaml
services:
  conduit:
    image: ghcr.io/ssmirr/conduit/conduit:latest
    container_name: psiphon-conduit
    restart: unless-stopped
    command: ["start", "--data-dir", "/data", "--max-clients", "1000", "--bandwidth", "-1", "--stats-file", "/data/stats.json"]
    volumes:
      - ./conduit-data:/data
    deploy:
      resources:
        limits:
          memory: 512M
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
EOF

# ۴. اجرای داکر
echo -e "${BLUE}>>> در حال اجرای پل سایفون...${NC}"
docker compose up -d

# ۵. ایجاد دستور مدیریتی conduit
cat <<'EOF' > /usr/local/bin/conduit
#!/bin/bash
STATS_FILE="$HOME/conduit-docker/conduit-data/stats.json"

case "$1" in
    report)
        if [ -f "$STATS_FILE" ]; then
            echo "--------------------------------"
            echo "📊 گزارش وضعیت ایستگاه Conduit"
            echo "--------------------------------"
            python3 -c "import json; d=json.load(open('$STATS_FILE')); print(f'کاربران متصل: {d.get(\"connectedClients\", 0)}\nارسال: {d.get(\"totalBytesUp\", 0)/1048576:.2f} MB\nدریافت: {d.get(\"totalBytesDown\", 0)/1048576:.2f} MB\nزمان فعالیت: {d.get(\"uptimeSeconds\", 0)//60} دقیقه')"
            echo "--------------------------------"
        else
            echo "⚠️ هنوز دیتایی ثبت نشده است. چند دقیقه صبر کنید..."
        fi
        ;;
    logs)
        docker logs -f psiphon-conduit
        ;;
    restart)
        cd "$HOME/conduit-docker" && docker compose restart
        ;;
    *)
        echo "Usage: conduit {report|logs|restart}"
        ;;
esac
EOF

chmod +x /usr/local/bin/conduit

echo -e "${GREEN}✅ نصب با موفقیت تمام شد!${NC}"
echo -e "${BLUE}حالا می‌توانید از دستور زیر برای دیدن گزارش استفاده کنید:${NC}"
echo -e "${GREEN}conduit report${NC}"
