# Chatwoot Production Deployment Guide

## Overview
This guide sets up automated deployment from your local development to production server on Hetzner.

**Workflow**: Local changes → Test locally → Push to GitHub → Auto-deploy to production

## Prerequisites
- Hetzner Cloud server (Ubuntu 22.04 LTS)
- Domain name pointed to server IP
- GitHub repository (already set up: `adzanaco/chatwootzana`)

## Step 1: Server Setup

### 1.1 Connect to your Hetzner server
```bash
ssh root@YOUR_SERVER_IP
```

### 1.2 Run the setup script
```bash
# Download and run setup script
wget https://raw.githubusercontent.com/adzanaco/chatwootzana/production/deploy/setup-server.sh
chmod +x setup-server.sh

# For AdzanaChat specifically:
./setup-server.sh www.adzanachat.com executive@adzana.ae
```

This script will:
- Install Docker and Docker Compose
- Configure Nginx with SSL
- Set up firewall
- Create application directory
- Clone your repository

### 1.3 Configure environment variables
```bash
cd /opt/chatwoot
cp .env.production.example .env.production
nano .env.production
```

**Required changes:**
```env
# Generate new secret (IMPORTANT!)
SECRET_KEY_BASE=<run: openssl rand -hex 64>

# Set strong password
POSTGRES_PASSWORD=your_strong_password_here

# Update domain
FRONTEND_URL=https://your-domain.com
MAILER_SENDER_EMAIL=noreply@your-domain.com

# Configure SMTP (Gmail example)
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-specific-password
```

## Step 2: GitHub Actions Setup

### 2.1 Generate SSH key for deployment
On your server:
```bash
ssh-keygen -t ed25519 -C "github-actions" -f /root/.ssh/github_deploy -N ""
cat /root/.ssh/github_deploy.pub >> /root/.ssh/authorized_keys
cat /root/.ssh/github_deploy  # Copy this private key
```

### 2.2 Add GitHub Secrets
Go to your GitHub repository → Settings → Secrets → Actions

Add these secrets:
- `PRODUCTION_HOST`: Your server IP
- `PRODUCTION_USER`: root
- `PRODUCTION_SSH_KEY`: (paste the private key from step 2.1)

## Step 3: Initial Deployment

### 3.1 Start the application
On your server:
```bash
cd /opt/chatwoot
docker-compose -f docker-compose.production-new.yml up -d
```

### 3.2 Initialize database (first time only)
```bash
# Create database and run migrations
docker-compose -f docker-compose.production-new.yml exec chatwoot-web bundle exec rails db:chatwoot_prepare

# Create admin user
docker-compose -f docker-compose.production-new.yml exec chatwoot-web bundle exec rails console
```

In Rails console:
```ruby
User.create!(
  email: 'admin@your-domain.com',
  password: 'YourStrongPassword123!',
  name: 'Admin',
  confirmed_at: Time.now
)
exit
```

### 3.3 Verify deployment
- Visit: `https://your-domain.com`
- Login with admin credentials
- Check all services are running:
  ```bash
  docker-compose -f docker-compose.production-new.yml ps
  ```

## Step 4: Development Workflow

### 4.1 Local Development
Continue using your existing setup:
```bash
./start-dev.sh  # Start local development
# Make changes, test at http://localhost:3000
./stop-dev.sh   # Stop when done
```

### 4.2 Deploy Changes
When you're happy with local changes:
```bash
# Commit your changes
git add .
git commit -m "Your changes description"

# Push to production branch
git push origin production
```

**That's it!** GitHub Actions will automatically:
1. Build new Docker image
2. Push to GitHub Container Registry
3. Deploy to your server
4. Restart containers with new code

### 4.3 Monitor Deployment
- Go to GitHub → Actions tab to watch deployment progress
- Takes ~5-10 minutes
- Server automatically updates when complete

## Customization Locations

### Branding Files
- **Logo**: `app/javascript/dashboard/assets/images/logo.svg`
- **Favicon**: `public/favicon.ico`
- **Colors**: Edit components and `tailwind.config.js`
- **App Name**: `app/javascript/dashboard/i18n/locale/en.json`

### After editing:
```bash
# Test locally first
./start-dev.sh

# Deploy to production
git add .
git commit -m "Updated branding"
git push origin production
```

## Troubleshooting

### Check logs on server
```bash
cd /opt/chatwoot
docker-compose -f docker-compose.production-new.yml logs -f
```

### Restart services
```bash
docker-compose -f docker-compose.production-new.yml restart
```

### Manual deployment (if GitHub Actions fails)
```bash
cd /opt/chatwoot
./deploy/manual-deploy.sh
```

### Database issues
```bash
# Reset database (WARNING: Deletes all data!)
docker-compose -f docker-compose.production-new.yml down -v
docker-compose -f docker-compose.production-new.yml up -d
docker-compose -f docker-compose.production-new.yml exec chatwoot-web bundle exec rails db:chatwoot_prepare
```

## Maintenance

### Backup database
```bash
docker-compose -f docker-compose.production-new.yml exec postgres pg_dump -U postgres chatwoot_production > backup.sql
```

### Update Chatwoot version
```bash
# Pull latest from upstream
git fetch upstream
git merge upstream/develop
git push origin production
```

### SSL certificate renewal
Certbot auto-renews, but you can force renewal:
```bash
certbot renew --nginx
```

## Security Checklist

- [x] Changed SECRET_KEY_BASE
- [x] Set strong POSTGRES_PASSWORD
- [x] Disabled ENABLE_ACCOUNT_SIGNUP
- [x] Configured firewall (UFW)
- [x] SSL enabled with Let's Encrypt
- [x] GitHub secrets secured
- [ ] Regular backups configured
- [ ] Monitoring setup (optional)

## Support

- **Logs**: `docker-compose -f docker-compose.production-new.yml logs`
- **Health check**: `curl https://your-domain.com/api/v1/health`
- **Container status**: `docker ps`
- **Disk space**: `df -h`

## Summary

Your workflow is now:
1. **Develop locally** → `./start-dev.sh`
2. **Test changes** → `http://localhost:3000`
3. **Push to GitHub** → `git push origin production`
4. **Auto-deploys** → Watch at `https://your-domain.com`

No manual server work needed after initial setup!