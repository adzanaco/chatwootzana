#!/bin/bash

echo "Stopping Chatwoot development environment..."

# Stop Docker services
docker-compose -f docker-compose.development.yml down

# Kill ngrok
pkill ngrok

echo "✅ Development environment stopped"