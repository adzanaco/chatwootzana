#!/bin/bash

echo "========================================"
echo "Starting Chatwoot in Docker (No Ruby/Homebrew needed!)"
echo "========================================"
echo ""

# Start all services
docker-compose -f docker-compose.local.yml up

echo ""
echo "Chatwoot is starting..."
echo "Wait for 'Listening on http://0.0.0.0:3000' message"
echo "Then open: http://localhost:3000"