# Local Development Setup Instructions

## ✅ What's Already Done:
1. PostgreSQL running on Docker (port 5433)
2. Redis running on Docker (port 6379)
3. Environment file configured (.env)
4. Setup scripts created

## 📋 What You Need to Do:

### Step 1: Install Homebrew (if not installed)
Open Terminal and run:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installation, add to PATH (for M2 Mac):
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Step 2: Install Ruby and Dependencies
```bash
# Install Ruby version manager and tools
brew install rbenv imagemagick vips

# Install and set Ruby 3.3.0
rbenv install 3.3.0
rbenv local 3.3.0
eval "$(rbenv init -)"

# Install bundler
gem install bundler
```

### Step 3: Install Application Dependencies
```bash
# Install Ruby gems
bundle install

# Install pnpm if needed
npm install -g pnpm

# Install JavaScript packages
pnpm install
```

### Step 4: Setup Database
```bash
# Create database
bundle exec rails db:create

# Run migrations
bundle exec rails db:migrate

# Add pgvector extension
bundle exec rails runner "ActiveRecord::Base.connection.execute('CREATE EXTENSION IF NOT EXISTS vector')"
```

### Step 5: Install Foreman
```bash
gem install foreman
```

### Step 6: Start Chatwoot
```bash
./start.sh
```

## 🚀 Quick Commands After Setup:

**Start Chatwoot:**
```bash
./start.sh
```

**Stop Chatwoot:**
```bash
./stop.sh
```

**Access Chatwoot:**
Open http://localhost:3000

## ⚠️ Troubleshooting:

### If bundle install fails:
```bash
gem update bundler
bundle install
```

### If PostgreSQL connection fails:
Check Docker is running:
```bash
docker ps
```

Restart containers:
```bash
./setup-docker.sh
```

### If port 5432 is in use:
We're using port 5433 for PostgreSQL to avoid conflicts.

## 📝 Notes:
- PostgreSQL: localhost:5433 (user: postgres, pass: postgres)
- Redis: localhost:6379
- Ruby: 3.3.0 (managed by rbenv)
- Node: Your existing 22.14.0 is perfect!