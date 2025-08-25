#!/bin/bash

echo "========================================="
echo "Quick Start - Chatwoot Docker Setup"
echo "========================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker Desktop first."
    exit 1
fi

echo "✅ Docker is running"
echo ""

# Check current containers
echo "Checking existing containers..."
docker ps -a | grep chatwoot

echo ""
echo "Starting Chatwoot services..."
docker-compose -f docker-compose.dev.yml up -d

echo ""
echo "Waiting for services to be ready..."
sleep 5

# Check if services are running
echo ""
echo "Service status:"
docker ps | grep chatwoot

echo ""
echo "========================================="
echo "Chatwoot should be starting..."
echo "Wait about 30 seconds for initialization"
echo "Then open: http://localhost:3000"
echo "========================================="
echo ""
echo "To view logs: docker-compose -f docker-compose.dev.yml logs -f chatwoot"
echo "To stop: docker-compose -f docker-compose.dev.yml down"