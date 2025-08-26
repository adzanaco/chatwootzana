#!/bin/bash

# Manual deployment script for production server
# Use this if you want to deploy without GitHub Actions

set -e

echo "========================================="
echo "Chatwoot Manual Deployment"
echo "========================================="

# Check if running on production server
if [ ! -d "/opt/chatwoot" ]; then
    echo "Error: This script should be run on the production server"
    echo "Directory /opt/chatwoot not found"
    exit 1
fi

cd /opt/chatwoot

# Pull latest changes from git
echo "Pulling latest changes from GitHub..."
git fetch origin production
git reset --hard origin/production

# Build the Docker image locally
echo "Building Docker image..."
docker build -f docker/Dockerfile -t ghcr.io/adzanaco/chatwootzana:production .

# Stop existing containers
echo "Stopping existing containers..."
docker-compose -f docker-compose.production-new.yml down || true

# Start new containers
echo "Starting new containers..."
docker-compose -f docker-compose.production-new.yml up -d

# Wait for services to be healthy
echo "Waiting for services to be healthy..."
sleep 20

# Run database migrations
echo "Running database migrations..."
docker-compose -f docker-compose.production-new.yml exec -T chatwoot-web bundle exec rails db:migrate

# Clean up old images
echo "Cleaning up old images..."
docker image prune -f

# Health check
echo "Performing health check..."
if curl -f http://localhost:3000/api/v1/health; then
    echo ""
    echo "✅ Deployment successful!"
    echo "Application is running at https://$(grep FRONTEND_URL .env.production | cut -d '=' -f2 | sed 's|https://||')"
else
    echo ""
    echo "❌ Health check failed!"
    echo "Check logs with: docker-compose -f docker-compose.production-new.yml logs"
    exit 1
fi

echo ""
echo "Deployment completed!"
echo "========================================="