#!/bin/bash

echo "========================================="
echo "Starting Chatwoot Development Environment"
echo "========================================="
echo ""

# Stop any existing containers
echo "Stopping existing containers..."
docker-compose -f docker-compose.development.yml down 2>/dev/null
docker stop chatwoot-app 2>/dev/null
docker rm chatwoot-app 2>/dev/null

# Kill existing ngrok
pkill ngrok 2>/dev/null

# Start ngrok in background
echo "Starting ngrok tunnel..."
./ngrok http 3000 > ngrok.log 2>&1 &
sleep 3

# Get ngrok URL
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | python3 -c "import sys, json; data = json.load(sys.stdin); print(data['tunnels'][0]['public_url'] if data.get('tunnels') else '')" 2>/dev/null)

if [ -z "$NGROK_URL" ]; then
    echo "❌ Failed to get ngrok URL. Make sure ngrok is configured with authtoken."
    echo "Run: ./ngrok config add-authtoken YOUR_TOKEN"
    exit 1
fi

echo "✅ Ngrok URL: $NGROK_URL"
echo ""

# Export the URL for docker-compose
export FRONTEND_URL=$NGROK_URL

# Start services with the ngrok URL
echo "Starting Docker services with FRONTEND_URL=$FRONTEND_URL..."
FRONTEND_URL=$NGROK_URL docker-compose -f docker-compose.development.yml up -d

echo ""
echo "Waiting for services to be ready..."
sleep 10

# Check if services are running
echo ""
echo "Service status:"
docker-compose -f docker-compose.development.yml ps

# Update Telegram webhook if bot exists
echo ""
echo "Updating Telegram webhook..."
docker exec chatwoot-web bundle exec rails runner "
t = Channel::Telegram.first
if t
  webhook_url = '$NGROK_URL/api/v1/webhooks/telegram/' + t.bot_token
  puts 'Setting webhook to: ' + webhook_url
  
  require 'net/http'
  require 'uri'
  
  uri = URI.parse(\"https://api.telegram.org/bot#{t.bot_token}/setWebhook\")
  response = Net::HTTP.post_form(uri, 'url' => webhook_url)
  result = JSON.parse(response.body)
  if result['ok']
    puts '✅ Telegram webhook updated successfully!'
  else
    puts '❌ Failed to update webhook: ' + result.to_s
  end
else
  puts 'No Telegram channel configured yet'
end
" 2>/dev/null || echo "Telegram webhook will be set when you add the bot in UI"

echo ""
echo "========================================="
echo "✅ Development environment is ready!"
echo "========================================="
echo ""
echo "🌐 Access Chatwoot at: $NGROK_URL"
echo "🌐 Or locally at: http://localhost:3000"
echo ""
echo "📁 Code changes in ./app will be reflected immediately"
echo "🔄 Frontend changes: Refresh browser"
echo "🔄 Backend changes: Run ./restart-dev.sh"
echo ""
echo "📊 View logs:"
echo "  docker-compose -f docker-compose.development.yml logs -f chatwoot-web"
echo ""
echo "🛑 To stop:"
echo "  ./stop-dev.sh"