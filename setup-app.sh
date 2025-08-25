#!/bin/bash

echo "==================================="
echo "Setting up Chatwoot Application"
echo "==================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Make sure rbenv is initialized
eval "$(rbenv init -)" 2>/dev/null || true

# Step 1: Install Ruby dependencies
echo -e "${YELLOW}Installing Ruby dependencies...${NC}"
bundle install

# Step 2: Check for pnpm
echo -e "${YELLOW}Checking pnpm...${NC}"
if ! command -v pnpm &> /dev/null; then
    echo "Installing pnpm..."
    npm install -g pnpm
fi

# Step 3: Install JavaScript dependencies
echo -e "${YELLOW}Installing JavaScript dependencies...${NC}"
pnpm install

# Step 4: Setup environment file
echo -e "${YELLOW}Setting up environment...${NC}"
if [ ! -f .env ]; then
    cp .env.example .env
    
    # Update .env with Docker settings
    sed -i '' 's|^POSTGRES_HOST=.*|POSTGRES_HOST=localhost|' .env
    sed -i '' 's|^POSTGRES_USERNAME=.*|POSTGRES_USERNAME=postgres|' .env
    sed -i '' 's|^POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=postgres|' .env
    sed -i '' 's|^REDIS_URL=.*|REDIS_URL=redis://localhost:6379|' .env
    
    echo -e "${GREEN}✓ Environment configured${NC}"
else
    echo -e "${YELLOW}⚠ .env already exists, skipping...${NC}"
fi

# Step 5: Setup database
echo -e "${YELLOW}Setting up database...${NC}"
RAILS_ENV=development bundle exec rails db:create
RAILS_ENV=development bundle exec rails db:migrate

# Step 6: Add pgvector extension
echo -e "${YELLOW}Adding pgvector extension...${NC}"
bundle exec rails runner "ActiveRecord::Base.connection.execute('CREATE EXTENSION IF NOT EXISTS vector')" 2>/dev/null || true

# Step 7: Install foreman
echo -e "${YELLOW}Installing foreman...${NC}"
gem install foreman

echo ""
echo -e "${GREEN}==================================="
echo "Setup Complete!"
echo "===================================${NC}"
echo ""
echo "To start Chatwoot:"
echo "  ./start.sh"
echo ""
echo "To stop Chatwoot:"
echo "  ./stop.sh"
echo ""
echo "Then open: http://localhost:3000"