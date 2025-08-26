# Deployment Files Overview

This directory contains all scripts and configurations for deploying Chatwoot to production.

## Files

### setup-server.sh
Complete server setup script that:
- Installs Docker and Docker Compose
- Configures Nginx with SSL (Let's Encrypt)
- Sets up firewall rules
- Clones the repository
- Creates environment file template

**Usage:**
```bash
./setup-server.sh your-domain.com admin@email.com
```

### manual-deploy.sh
Manual deployment script for when you want to deploy without GitHub Actions:
- Pulls latest code from GitHub
- Builds Docker image locally
- Restarts containers
- Runs migrations
- Performs health check

**Usage:**
```bash
# On production server
cd /opt/chatwoot
./deploy/manual-deploy.sh
```

## Important Notes

1. **First Time Setup**: Run `setup-server.sh` first to prepare your server
2. **Environment Variables**: Always configure `.env.production` before deploying
3. **GitHub Actions**: Preferred method - automatic deployment on push to `production` branch
4. **Manual Deploy**: Use `manual-deploy.sh` as backup or for testing

## Security Checklist

- [ ] Changed SECRET_KEY_BASE in .env.production
- [ ] Set strong POSTGRES_PASSWORD
- [ ] Configured SMTP settings
- [ ] SSL certificate active
- [ ] Firewall configured (UFW)
- [ ] SSH key authentication only