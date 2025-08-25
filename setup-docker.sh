#!/bin/bash

echo "==================================="
echo "Setting up PostgreSQL & Redis with Docker"
echo "==================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Step 1: Create Docker network
echo -e "${YELLOW}Creating Docker network...${NC}"
docker network create chatwoot-network 2>/dev/null || true

# Step 2: Start PostgreSQL 17
echo -e "${YELLOW}Starting PostgreSQL 17...${NC}"
docker run -d \
  --name chatwoot-postgres \
  --network chatwoot-network \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=chatwoot_development \
  -p 5432:5432 \
  -v chatwoot-postgres-data:/var/lib/postgresql/data \
  postgres:17-alpine \
  2>/dev/null || docker start chatwoot-postgres

# Step 3: Start Redis 8
echo -e "${YELLOW}Starting Redis 8...${NC}"
docker run -d \
  --name chatwoot-redis \
  --network chatwoot-network \
  -p 6379:6379 \
  -v chatwoot-redis-data:/data \
  redis:8-alpine \
  2>/dev/null || docker start chatwoot-redis

# Step 4: Wait for services
echo -e "${YELLOW}Waiting for services to start...${NC}"
sleep 5

# Step 5: Install pgvector extension
echo -e "${YELLOW}Installing pgvector extension...${NC}"
docker exec chatwoot-postgres psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS vector;" 2>/dev/null || true

# Step 6: Check services
echo -e "${YELLOW}Checking services...${NC}"
docker ps | grep chatwoot

echo ""
echo -e "${GREEN}==================================="
echo "Docker services are running!"
echo "===================================${NC}"
echo ""
echo "PostgreSQL: localhost:5432 (user: postgres, pass: postgres)"
echo "Redis: localhost:6379"
echo ""
echo "Next, run: ./setup-app.sh"