#!/bin/bash

echo "==================================="
echo "Chatwoot Local Development Setup"
echo "==================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Install Homebrew
echo -e "${YELLOW}Step 1: Installing Homebrew...${NC}"
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for M2 Macs
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo -e "${GREEN}✓ Homebrew already installed${NC}"
fi

# Step 2: Install Ruby dependencies
echo -e "${YELLOW}Step 2: Installing Ruby and tools...${NC}"
brew install rbenv ruby-build imagemagick vips

# Step 3: Install Ruby 3.3.0
echo -e "${YELLOW}Step 3: Setting up Ruby 3.3.0...${NC}"
rbenv install 3.3.0 --skip-existing
rbenv local 3.3.0
eval "$(rbenv init -)"

# Step 4: Install bundler
echo -e "${YELLOW}Step 4: Installing Bundler...${NC}"
gem install bundler

echo ""
echo -e "${GREEN}==================================="
echo "Homebrew and Ruby setup complete!"
echo "===================================${NC}"
echo ""
echo "Next, run: ./setup-docker.sh"