#!/bin/bash

# Stop script for GitHub image-based local development

echo "========================================="
echo "🛑 Stopping Chatwoot (GitHub Image)"
echo "========================================="
echo ""

# Stop containers
echo "📦 Stopping containers..."
docker-compose -f docker-compose.github-local.yml down

# Stop ngrok
echo "🌐 Stopping ngrok..."
pkill ngrok 2>/dev/null || true

echo ""
echo "✅ All services stopped"
echo ""
echo "ℹ️  Data is preserved in Docker volumes"
echo "   Run ./start-github-local.sh to start again"