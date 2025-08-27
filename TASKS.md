# Project Progress

## ✅ Phase 1: Setup - COMPLETED
- Forked Chatwoot to `github.com/adzanaco/chatwootzana`
- Created `production` branch for customizations
- Set up local development with Docker
- Configured ngrok for testing integrations

## 🚀 Phase 2: Production Deployment - CURRENT
Deploy to EasyPanel from GitHub repository (production branch)

## 🎨 Phase 3: Customization - NEXT

### Branding Changes
- [ ] Replace logos in `/app/javascript/dashboard/assets/images/`
- [ ] Update color scheme in components
- [ ] Change app name in i18n files
- [ ] Customize email templates
- [ ] Replace favicon

### Quick Customization Guide
```bash
# Logo replacement
cp your-logo.png app/javascript/dashboard/assets/images/logo.png

# Test locally
./start-dev.sh
# View at ngrok URL

# Deploy to production
git add .
git commit -m "Update branding"
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

## Development Workflow

### Local Testing (CORRECT FILES TO USE)
1. Start environment: `./start-dev.sh` (uses docker-compose.development.yml)
2. Make changes in mounted directories
3. Test at ngrok URL
4. Restart web only: `./restart-dev.sh` (uses docker-compose.development.yml)
5. Stop: `./stop-dev.sh` (uses docker-compose.development.yml)

**DO NOT USE:** docker-compose.dev.yml, docker-compose.local.yml, or docker-compose.yaml directly

### Deploy to Production
```bash
git add .
git commit -m "Your changes"
git push origin production
# GitHub Actions auto-deploys using docker-compose.production-new.yml
```

**PRODUCTION FILE:** docker-compose.production-new.yml (on server at /opt/chatwoot/)
**DO NOT USE:** docker-compose.production.yaml (deprecated)

## File Locations Reference

| What to Change | Where |
|---------------|-------|
| Logos | `app/javascript/dashboard/assets/images/` |
| Colors | Component files + Tailwind config |
| App Name | `app/javascript/dashboard/i18n/locale/en.json` |
| Emails | `app/views/mailers/` |
| Widget | `app/javascript/widget/` |
| Custom Assets | `public/brand-assets/` |

## Current Issues
- Image display in agent dashboard (uploads work, display doesn't)
- Database resets on container restart
- ngrok URL changes require re-adding integrations

## Git Commands
```bash
# Always work on production branch
git checkout production

# After changes
git add .
git commit -m "Description"
git push origin production
```