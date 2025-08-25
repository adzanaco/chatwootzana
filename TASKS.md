# Phase 1: Fork & Initial Setup - Task Breakdown

## Overview
Phase 1 focuses on forking Chatwoot, setting up the development environment, and preparing for customization. This phase ensures we have a working copy of Chatwoot that we can modify without affecting the original.

## Prerequisites Checklist
- [ ] GitHub account with SSH keys configured
- [ ] Hetzner server with EasyPanel installed
- [ ] Domain name purchased and DNS configured
- [ ] Local development machine with admin access
- [ ] Basic knowledge of Ruby on Rails and Vue.js

## Main Tasks

### 1. Repository Setup
**Priority: Critical | Time: 1-2 hours**

#### 1.1 Fork Chatwoot Repository
- [ ] Go to https://github.com/chatwoot/chatwoot
- [ ] Click "Fork" to create your own copy
- [ ] Rename repository to your brand name
- [ ] Set repository to private (if desired)

#### 1.2 Clone to Local Development
```bash
git clone git@github.com:YOUR_USERNAME/YOUR_REPO_NAME.git
cd YOUR_REPO_NAME
git remote add upstream https://github.com/chatwoot/chatwoot.git
git fetch upstream
```

#### 1.3 Create Development Branch
```bash
git checkout -b white-label-customization
git push -u origin white-label-customization
```

### 2. Local Development Environment Setup
**Priority: Critical | Time: 2-3 hours**

#### 2.1 Install System Dependencies

**macOS:**
```bash
# Install Homebrew if not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install rbenv postgresql@17 redis imagemagick node pnpm
```

**Ubuntu/Debian:**
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y git curl build-essential libssl-dev libreadline-dev \
  zlib1g-dev postgresql postgresql-contrib redis-server \
  imagemagick libpq-dev nodejs npm
  
# Install pnpm
npm install -g pnpm
```

#### 2.2 Install Ruby 3.4.5
```bash
# Using rbenv
rbenv install 3.4.5
rbenv global 3.4.5
rbenv rehash

# Verify installation
ruby -v  # Should show 3.4.5
```

#### 2.3 Install Node.js 22 LTS
```bash
# Using nvm (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc  # or ~/.zshrc
nvm install 22
nvm use 22
nvm alias default 22  # Set as default

# Verify
node -v  # Should show v22.x.x
pnpm -v  # Should show 10.x.x
```

### 3. Application Setup
**Priority: Critical | Time: 1-2 hours**

#### 3.1 Install Ruby Dependencies
```bash
# Install bundler
gem install bundler

# Install gems
bundle install

# If you encounter issues with pg gem:
# macOS: gem install pg -- --with-pg-config=/opt/homebrew/opt/postgresql@17/bin/pg_config
# Linux: sudo apt-get install libpq-dev
```

#### 3.2 Install JavaScript Dependencies
```bash
# Install frontend dependencies
pnpm install

# Build frontend assets
pnpm run build
```

#### 3.3 Configure Environment Variables
```bash
# Copy example environment file
cp .env.example .env

# Edit .env file with your configurations
# Key variables to set:
# - DATABASE_URL=postgres://postgres:password@localhost:5432/chatwoot_dev
# - REDIS_URL=redis://localhost:6379
# - FRONTEND_URL=http://localhost:3000
# - SECRET_KEY_BASE=$(rails secret)
```

#### 3.4 Database Setup
```bash
# Start PostgreSQL and Redis
# macOS:
brew services start postgresql@17
brew services start redis

# Linux:
sudo systemctl start postgresql
sudo systemctl start redis

# Create database and install pgvector extension
rails db:create
psql -d chatwoot_dev -c "CREATE EXTENSION IF NOT EXISTS vector;"

# Run migrations
rails db:migrate
rails db:seed  # Creates sample data (optional)
```

### 4. Verify Local Installation
**Priority: Critical | Time: 30 minutes**

#### 4.1 Start Development Server
```bash
# Using Foreman (recommended)
gem install foreman
foreman start -f Procfile.dev

# Or manually in separate terminals:
# Terminal 1: Rails server
rails server

# Terminal 2: Webpack dev server
pnpm run dev

# Terminal 3: Sidekiq
bundle exec sidekiq
```

#### 4.2 Access Application
- [ ] Open http://localhost:3000
- [ ] You should see Chatwoot login page
- [ ] Create admin account if using fresh database
- [ ] Test basic functionality:
  - [ ] Login/logout
  - [ ] Create inbox
  - [ ] Send test message
  - [ ] Check real-time updates

#### 4.3 Troubleshooting Checklist
- [ ] PostgreSQL running? `pg_isready`
- [ ] Redis running? `redis-cli ping`
- [ ] Port 3000 available? `lsof -i :3000`
- [ ] Database migrated? `rails db:migrate:status`
- [ ] Assets compiled? Check `/public/packs`

### 5. EasyPanel Deployment Preparation
**Priority: High | Time: 1-2 hours**

#### 5.1 Analyze Current EasyPanel Setup
```bash
# SSH into Hetzner server
ssh root@your-server-ip

# Check Docker containers
docker ps

# Check EasyPanel Chatwoot template configuration
# Document current environment variables
# Note PostgreSQL and Redis connection details
```

#### 5.2 Prepare Docker Configuration
- [ ] Review `docker-compose.yaml` in repository
- [ ] Create `docker-compose.production.yaml` with:
  - [ ] Custom image name
  - [ ] Production environment variables
  - [ ] Volume mappings for persistence
  - [ ] Network configuration

#### 5.3 Create Deployment Scripts
```bash
# Create deploy.sh
#!/bin/bash
echo "Building Docker image..."
docker build -t your-brand/chatwoot:latest .

echo "Pushing to registry..."
docker push your-brand/chatwoot:latest

echo "Deploying to EasyPanel..."
# Add EasyPanel deployment commands
```

### 6. Documentation & Version Control
**Priority: Medium | Time: 30 minutes**

#### 6.1 Create Project Documentation
- [x] CLAUDE.md - Project context for AI assistants
- [x] TASKS.md - This file
- [ ] README_CUSTOM.md - Your brand's README
- [ ] DEPLOYMENT.md - Deployment instructions
- [ ] CUSTOMIZATION.md - Track all modifications

#### 6.2 Set Up Git Workflow
```bash
# Create .gitignore additions
echo ".env" >> .gitignore
echo "custom_branding/" >> .gitignore
echo "deployment_scripts/" >> .gitignore

# Commit initial setup
git add .
git commit -m "Initial white-label setup and documentation"
git push origin white-label-customization
```

## Validation Checklist
Before proceeding to Phase 2, ensure:

- [ ] **Repository**: Forked and cloned successfully
- [ ] **Dependencies**: All system dependencies installed
- [ ] **Ruby Environment**: Ruby 3.4.5 with all gems installed
- [ ] **Node Environment**: Node.js 22 LTS with pnpm packages installed
- [ ] **Database**: PostgreSQL 17.6 with pgvector extension and Redis 8.2.1 running
- [ ] **Application**: Runs locally without errors
- [ ] **Access**: Can login and use basic features
- [ ] **Documentation**: CLAUDE.md and TASKS.md created with latest versions
- [ ] **Version Control**: Changes committed to git
- [ ] **EasyPanel**: Current setup documented
- [ ] **Chatwoot v4**: Verified pgvector extension is installed

## Common Issues & Solutions

### Issue: Bundle install fails
**Solution:**
```bash
# Update bundler
gem update bundler
# Clear bundle cache
rm -rf vendor/bundle
bundle install --path vendor/bundle
```

### Issue: Database connection error
**Solution:**
```bash
# Check PostgreSQL is running
sudo systemctl status postgresql
# Check connection
psql -U postgres -h localhost
# Update DATABASE_URL in .env
```

### Issue: Redis connection refused
**Solution:**
```bash
# Start Redis
redis-server
# Or as service
brew services start redis  # macOS
sudo systemctl start redis  # Linux
```

### Issue: Assets not loading
**Solution:**
```bash
# Rebuild assets
pnpm run build
# Clear cache
rails tmp:clear
rails assets:clean
```

### Issue: pgvector extension not found
**Solution:**
```bash
# Install pgvector for PostgreSQL 17
# macOS:
brew install pgvector

# Linux:
sudo apt-get install postgresql-17-pgvector

# Then enable in database:
psql -d chatwoot_dev -c "CREATE EXTENSION IF NOT EXISTS vector;"
```

## Time Estimate
- **Total Phase 1 Duration**: 6-10 hours
- **With experience**: 3-4 hours
- **First time setup**: 8-12 hours

## Next Phase Preview
Phase 2 will focus on:
- Replacing logos and branding elements
- Customizing color schemes
- Updating application name across the codebase
- Creating a branding configuration system
- Setting up automated build pipeline

## Notes for Future Sessions
- Document any custom changes in CUSTOMIZATION.md
- Keep track of environment-specific configurations
- Test each modification in local environment first
- Maintain backward compatibility for database migrations
- Consider creating feature flags for new functionality

---
**Last Updated**: 2025-08-24
**Status**: Ready for Phase 1 Execution
**Next Review**: After Phase 1 Completion