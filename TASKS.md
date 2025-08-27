# Project Progress

## ✅ Phase 1: Setup - COMPLETED
- Forked Chatwoot to `github.com/adzanaco/chatwootzana`
- Created `production` branch for customizations
- Set up local development with Docker
- Configured ngrok for testing integrations

## 🚀 Phase 2: Production Deployment - COMPLETED
- Deployed to Hetzner server (188.245.44.186)
- Accessible at https://www.adzanachat.com
- GitHub Actions CI/CD configured

## Development Workflow

### CURRENT SETUP: GitHub Image-Based Workflow (Recommended)
This workflow uses GitHub Actions to build Docker images, avoiding M2 Mac build issues.

#### Workflow Steps:
1. **Make code changes locally** in your repository
2. **Commit and push to `local-testing` branch**:
   ```bash
   git add .
   git commit -m "Your changes"
   git push origin local-testing
   ```
3. **Wait for GitHub Actions to build** (~10 minutes)
   - Check progress at: https://github.com/adzanaco/chatwootzana/actions
4. **Start local environment** with GitHub image:
   ```bash
   ./start-github-local.sh
   ```
5. **Access application**:
   - Local: http://localhost:3000
   - ngrok: Check terminal output for public URL
6. **Stop environment** when done:
   ```bash
   ./stop-github-local.sh
   ```

#### When ready for production:
1. **Merge changes to production branch**:
   ```bash
   git checkout production
   git merge local-testing
   git push origin production
   ```
2. **GitHub Actions automatically deploys** to Hetzner server
3. **Access at**: https://www.adzanachat.com

### ALTERNATIVE: Volume Mount Setup (Has Issues)
⚠️ **Note**: This approach has issues with backend changes not reflecting properly.

```bash
# Start with volume mounts
./start-dev.sh

# Restart web service after backend changes
./restart-dev.sh

# Stop environment
./stop-dev.sh
```

## 🎨 Phase 3: Customization - IN PROGRESS

### Branding Changes
- [ ] Replace logos in `/app/javascript/dashboard/assets/images/`
- [ ] Update color scheme in components
- [ ] Change app name in i18n files
- [ ] Customize email templates
- [ ] Replace favicon

### Quick Customization Guide
```bash
# 1. Make your changes (e.g., update logo)
cp your-logo.png app/javascript/dashboard/assets/images/logo.png

# 2. Commit and push to local-testing
git add .
git commit -m "Update branding"
git push origin local-testing

# 3. Wait for GitHub Actions to build

# 4. Test locally
./start-github-local.sh

# 5. When satisfied, push to production
git checkout production
git merge local-testing
git push origin production
```

## 🚀 Phase 4: Features - FUTURE

### AI Integration
- [ ] Add toggle switch UI for AI mode
- [ ] Create n8n webhook endpoints
- [ ] Handle AI responses in chat

### Social Integrations
- [ ] Fix Facebook Messenger OAuth
- [ ] Fix Instagram Business API
- [ ] Add proper webhook verification

### Billing System
- [ ] Integrate Stripe
- [ ] Add subscription management
- [ ] Track usage per account

## Docker Compose Files Reference

### Currently Used
- **`docker-compose.github-local.yml`** - Local development with GitHub images (RECOMMENDED)
- **`docker-compose.production-new.yml`** - Production deployment on Hetzner server

### Alternative/Deprecated
- `docker-compose.development.yml` - Volume mount approach (has backend issues)
- `docker-compose.dev.yml` - Old setup (deprecated)
- `docker-compose.local.yml` - Old setup (deprecated)
- `docker-compose.yaml` - Base config (not used directly)
- `docker-compose.production.yaml` - Old production setup (deprecated)

## Shell Scripts Reference

### Primary Scripts (GitHub Image Workflow)
- **`./start-github-local.sh`** - Start local environment with GitHub image
- **`./stop-github-local.sh`** - Stop GitHub image containers

### Alternative Scripts (Volume Mount)
- `./start-dev.sh` - Start with volume mounts (has issues)
- `./stop-dev.sh` - Stop volume mount containers
- `./restart-dev.sh` - Restart web service only

### Deprecated Scripts
- `./quick-start.sh` - Old setup script
- `./start-docker-dev.sh` - Old setup script
- `./start.sh`, `./stop.sh` - Generic scripts (not configured)

### One-Time Setup Scripts
- `./setup-ngrok.sh` - Configure ngrok
- `./setup-docker.sh` - Install Docker
- `./setup-app.sh` - Initial app setup
- `./complete-setup.sh` - Full initial setup

## File Locations Reference

| What to Change | Where |
|---------------|-------|
| Logos | `app/javascript/dashboard/assets/images/` |
| Colors | Component files + Tailwind config |
| App Name | `app/javascript/dashboard/i18n/locale/en/login.json` |
| Emails | `app/views/mailers/` |
| Widget | `app/javascript/widget/` |
| Custom Assets | `public/brand-assets/` |

## Production Server Access

### SSH Access
```bash
ssh root@188.245.44.186
# Password: Shuaib6655@
```

### Manual Deployment (if GitHub Actions fails)
```bash
# SSH to server
ssh root@188.245.44.186

# Navigate to app
cd /opt/chatwoot

# Pull latest changes
git pull origin production

# Build and deploy
docker build . --platform linux/x86_64
docker-compose -f docker-compose.production-new.yml up -d

# Check logs
docker-compose -f docker-compose.production-new.yml logs -f
```

## Current Issues
- **Image display**: Images upload but don't display in agent dashboard (Active Storage issue)
- **Database persistence**: May reset on container restart
- **ngrok URL changes**: Requires re-adding integrations after restart

## Git Commands Quick Reference

### Working with branches
```bash
# Create and switch to local-testing branch
git checkout -b local-testing

# Switch between branches
git checkout local-testing  # For local testing
git checkout production    # For production

# Check current branch
git branch
```

### Making changes
```bash
# After editing files
git add .
git commit -m "Description of changes"

# Push to local-testing for testing
git push origin local-testing

# Push to production for deployment
git push origin production
```

### Merging to production
```bash
# After testing on local-testing branch
git checkout production
git merge local-testing
git push origin production
```

## Important Notes

1. **Always test on `local-testing` branch first** before pushing to production
2. **GitHub Actions builds take ~10 minutes** - be patient
3. **Frontend changes** (Vue/JavaScript) require rebuilding the Docker image
4. **Database changes** require migrations - handle with care
5. **Production deploys automatically** when you push to production branch

## Support
- GitHub Repository: https://github.com/adzanaco/chatwootzana
- Production URL: https://www.adzanachat.com
- Admin Login: executive@adzana.ae / Shuaib6655@