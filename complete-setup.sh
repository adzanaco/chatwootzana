#!/bin/bash

set -e  # Exit on error

echo "========================================="
echo "Chatwoot Complete Local Setup"
echo "========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Initialize Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Step 1: Install Ruby tools
echo -e "${YELLOW}Installing Ruby tools...${NC}"
brew install rbenv imagemagick vips

# Step 2: Setup Ruby 3.3.0
echo -e "${YELLOW}Setting up Ruby 3.3.0...${NC}"
rbenv install 3.3.0 --skip-existing
rbenv local 3.3.0
eval "$(rbenv init -)"

# Step 3: Install bundler
echo -e "${YELLOW}Installing bundler...${NC}"
gem install bundler

# Step 4: Install Ruby gems
echo -e "${YELLOW}Installing Ruby gems (this may take a while)...${NC}"
bundle install

# Step 5: Install pnpm if needed
echo -e "${YELLOW}Installing pnpm...${NC}"
npm install -g pnpm

# Step 6: Install JavaScript packages
echo -e "${YELLOW}Installing JavaScript packages...${NC}"
pnpm install

# Step 7: Create database
echo -e "${YELLOW}Creating database...${NC}"
bundle exec rails db:create

# Step 8: Run migrations
echo -e "${YELLOW}Running database migrations...${NC}"
bundle exec rails db:migrate

# Step 9: Add pgvector extension
echo -e "${YELLOW}Adding pgvector extension...${NC}"
bundle exec rails runner "ActiveRecord::Base.connection.execute('CREATE EXTENSION IF NOT EXISTS vector')" || true

# Step 10: Seed database (optional)
echo -e "${YELLOW}Seeding database with sample data...${NC}"
bundle exec rails db:seed || true

# Step 11: Install foreman
echo -e "${YELLOW}Installing foreman...${NC}"
gem install foreman

echo ""
echo -e "${GREEN}========================================="
echo "✅ Setup Complete!"
echo "=========================================${NC}"
echo ""
echo "To start Chatwoot, run:"
echo "  ./start.sh"
echo ""
echo "Then open: http://localhost:3000"
echo ""
echo "Default login (if seeded):"
echo "  Email: john@acme.inc"
echo "  Password: Password1!"