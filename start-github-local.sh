#!/bin/bash

# Start script for GitHub image-based local development
# Works on both Linux and Mac (including M2)

set -e

echo "========================================="
echo "🚀 Starting Chatwoot (GitHub Image)"
echo "========================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop."
    exit 1
fi

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker-compose -f docker-compose.github-local.yml down 2>/dev/null || true
docker-compose -f docker-compose.development.yml down 2>/dev/null || true
docker-compose -f docker-compose.local.yml down 2>/dev/null || true
pkill ngrok 2>/dev/null || true

# Pull the latest image
echo "📦 Pulling latest image from GitHub..."
echo "   Image: ghcr.io/adzanaco/chatwootzana:local-testing"
docker pull ghcr.io/adzanaco/chatwootzana:local-testing

# Start ngrok if available
if command -v ./ngrok &> /dev/null; then
    echo "🌐 Starting ngrok tunnel..."
    ./ngrok http 3000 > ngrok.log 2>&1 &
    sleep 3
    
    # Try to get ngrok URL (works on both Mac and Linux)
    if command -v python3 &> /dev/null; then
        NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | python3 -c "import sys, json; data = json.load(sys.stdin); print(data['tunnels'][0]['public_url'] if data.get('tunnels') else '')" 2>/dev/null || echo "")
    else
        NGROK_URL=""
    fi
    
    if [ -z "$NGROK_URL" ]; then
        NGROK_URL="http://localhost:3000"
        echo "⚠️  Ngrok not configured, using localhost"
    else
        echo "✅ Ngrok URL: $NGROK_URL"
    fi
else
    NGROK_URL="http://localhost:3000"
    echo "ℹ️  Ngrok not found, using localhost"
fi

# Start services
echo ""
echo "🚀 Starting services..."
FRONTEND_URL=$NGROK_URL docker-compose -f docker-compose.github-local.yml up -d

# Wait for services
echo "⏳ Waiting for services to start..."
echo "   This may take up to 30 seconds..."

# Wait for PostgreSQL
echo -n "   Waiting for PostgreSQL..."
for i in {1..30}; do
    if docker-compose -f docker-compose.github-local.yml exec -T postgres pg_isready -U postgres >/dev/null 2>&1; then
        echo " ✅"
        break
    fi
    echo -n "."
    sleep 1
done

# Wait for Redis
echo -n "   Waiting for Redis..."
for i in {1..10}; do
    if docker-compose -f docker-compose.github-local.yml exec -T redis redis-cli ping >/dev/null 2>&1; then
        echo " ✅"
        break
    fi
    echo -n "."
    sleep 1
done

# Wait for Rails
echo -n "   Waiting for Rails..."
for i in {1..30}; do
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        echo " ✅"
        break
    fi
    echo -n "."
    sleep 1
done

echo ""
echo "📊 Service status:"
docker-compose -f docker-compose.github-local.yml ps

echo ""
echo "========================================="
echo "✅ Chatwoot is running!"
echo "========================================="
echo ""
echo "🌐 Access at: $NGROK_URL"
echo "🌐 Or locally: http://localhost:3000"
echo ""
echo "📝 Using image: ghcr.io/adzanaco/chatwootzana:local-testing"
echo ""
echo "📊 View logs: docker-compose -f docker-compose.github-local.yml logs -f"
echo "🛑 Stop: ./stop-github-local.sh"
echo ""
echo "⚠️  Note: Changes require pushing to GitHub and waiting for build"