#!/bin/bash

echo "Restarting Chatwoot web service..."

# Get current ngrok URL
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | python3 -c "import sys, json; data = json.load(sys.stdin); print(data['tunnels'][0]['public_url'] if data.get('tunnels') else '')" 2>/dev/null)

if [ -z "$NGROK_URL" ]; then
    echo "❌ Ngrok is not running. Run ./start-dev.sh first"
    exit 1
fi

export FRONTEND_URL=$NGROK_URL

# Restart only the web container
docker-compose -f docker-compose.development.yml restart chatwoot-web

echo "✅ Web service restarted"
echo "🌐 Access at: $NGROK_URL"