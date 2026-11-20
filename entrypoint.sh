#!/bin/sh
set -e
PORT="${PORT:-8080}"
UUID="${UUID:-}"
WS_PATH="${WS_PATH:-/vless}"
if [ -z "$UUID" ]; then UUID=$(cat /proc/sys/kernel/random/uuid); echo "UUID 未设置，已自动生成: $UUID"; fi
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "vless",
      "settings": { "clients": [{ "id": "$UUID" }], "decryption": "none" },
      "streamSettings": { "network": "ws", "wsSettings": { "path": "$WS_PATH" } }
    }
  ],
  "outbounds": [{ "protocol": "freedom", "tag": "direct" }]
}
EOF
echo "Xray listening on port $PORT, WS path $WS_PATH, UUID $UUID"
exec /usr/bin/xray -config /etc/xray/config.json
