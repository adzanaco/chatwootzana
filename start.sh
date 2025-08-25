#!/bin/bash

echo "==================================="
echo "Starting Chatwoot Development"
echo "==================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Start Docker containers
echo -e "${YELLOW}Starting Docker services...${NC}"
docker start chatwoot-postgres chatwoot-redis 2>/dev/null

# Wait for services
sleep 3

# Check services are running
if docker ps | grep -q chatwoot-postgres && docker ps | grep -q chatwoot-redis; then
    echo -e "${GREEN}✓ Docker services running${NC}"
else
    echo -e "${YELLOW}Starting Docker services fresh...${NC}"
    ./setup-docker.sh
fi

# Initialize rbenv
eval "$(rbenv init -)" 2>/dev/null || true

# Start Chatwoot
echo ""
echo -e "${GREEN}Starting Chatwoot...${NC}"
echo "===================================="
echo "Opening http://localhost:3000 in 10 seconds..."
echo "Press Ctrl+C to stop"
echo "===================================="
echo ""

# Open browser after delay
(sleep 10 && open http://localhost:3000) &

# Start with foreman or overmind
if command -v overmind &> /dev/null; then
    overmind start -f Procfile.dev
elif command -v foreman &> /dev/null; then
    foreman start -f Procfile.dev
else
    echo "Installing foreman..."
    gem install foreman
    foreman start -f Procfile.dev
fi