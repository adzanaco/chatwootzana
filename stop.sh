#!/bin/bash

echo "==================================="
echo "Stopping Chatwoot Development"
echo "==================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Stop Docker containers
echo -e "${YELLOW}Stopping Docker services...${NC}"
docker stop chatwoot-postgres chatwoot-redis

echo -e "${GREEN}✓ All services stopped${NC}"
echo ""
echo "To start again, run: ./start.sh"