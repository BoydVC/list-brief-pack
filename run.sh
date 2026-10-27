#!/usr/bin/env bash
# Start (or restart) List Brief Pack on 127.0.0.1:4332
set -euo pipefail
cd "$(dirname "$0")"
pkill -f "list-brief-pack/server.py" 2>/dev/null || true
sleep 0.3
setsid nohup python3 "$PWD/server.py" > /tmp/list-brief-pack-server.log 2>&1 < /dev/null &
sleep 0.7
code=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:4332/api/health || echo "000")
echo "List Brief Pack -> http://127.0.0.1:4332/ (health HTTP ${code})"
