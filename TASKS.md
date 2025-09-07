# Project Progress

## ✅ Phase 1: Setup - COMPLETED
- Forked Chatwoot to `github.com/adzanaco/chatwootzana`
- Created `production` branch for customizations
- Set up local development with Docker
- Configured ngrok for testing integrations

## 🚀 Phase 2: Production Deployment - COMPLETED ✅
- Deployed to Hetzner server (188.245.44.186)
- Accessible at https://www.adzanachat.com
- GitHub Actions CI/CD configured
- **Recent Updates (Sept 2025)**:
  - ✅ Fixed deployment health check port (3000 → 3001)
  - ✅ Updated button color hex codes (#f9a49a → #f9a94a)
  - ✅ Verified production pipeline working correctly
  - ✅ All containers healthy and operational

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

## 🎨 Phase 3: COMPLETE CHATWOOT → ADZANACHAT REBRANDING - READY TO EXECUTE

**🔍 COMPREHENSIVE SCAN RESULTS:**
- **1266 files** contain "Chatwoot"/"CHATWOOT"/"chatwoot" references
- **24 files** with blue color codes (#2781F6, #1f93ff, #007bff, etc.) to change to orange
- **5 custom AdzanaChat logos** available: `/Users/raedshuaibwork/Downloads/adzanachatlogos/`
- **137+ logo/icon files** across PNG/SVG formats in public directories

### 🎯 PHASE 3A: LOGO SYSTEM REPLACEMENT (Priority 1 - SURGICAL)

**Custom AdzanaChat Logos Available:**
- **browsertab.svg** (10,893 bytes) → Browser tab icon/favicon
- **smallcirclelogo.svg** (10,893 bytes) → Dashboard UI, sidebar icons  
- **logothumbnail.svg** (13,185 bytes) → Settings, profile areas, thumbnails
- **mainlogo.svg** (29,991 bytes) → Login pages, main headers, full branding
- **widgetlogo.svg** (12,829 bytes) → Customer chat widget, external facing

**Target Locations for Logo Replacement (47 files minimum):**
1. **Brand Assets** (Already started):
   - ✅ `/public/brand-assets/logo_thumbnail.svg` (color changed blue→orange)
   - ❌ `/public/brand-assets/logo.svg` (needs replacement)
   - ❌ `/public/brand-assets/logo_dark.svg` (needs replacement)

2. **Dashboard Assets** (3 files):
   - ❌ `/app/javascript/dashboard/assets/images/bubble-logo.svg`
   - ❌ `/app/javascript/design-system/images/logo-thumbnail.svg` 
   - ❌ `/app/javascript/design-system/images/logo.png`
   - ❌ `/app/javascript/design-system/images/logo-dark.png`

3. **Widget Assets** (2 files):
   - ❌ `/app/javascript/widget/assets/images/logo.svg`

4. **Favicon System** (16 files in `/public/`):
   - ❌ `favicon.ico`, `favicon-16x16.png`, `favicon-32x32.png`, `favicon-96x96.png`
   - ❌ `favicon-512x512.png`, `favicon-badge-*.png` (3 files)

5. **Apple Icons** (10 files in `/public/`):
   - ❌ `apple-icon-*.png` (8 sizes), `apple-touch-icon*.png` (2 files)

6. **Android Icons** (6 files in `/public/`):
   - ❌ `android-icon-*.png` (6 sizes)

7. **Microsoft Icons** (4 files in `/public/`):
   - ❌ `ms-icon-*.png` (4 sizes)

### 🎨 PHASE 3B: COLOR SYSTEM OVERHAUL (Priority 1 - SYSTEMATIC)

**Primary Theme Color Change:**
- ❌ `theme/colors.js` line 214: `brand: '#2781F6'` → `brand: '#f9a94a'`
- ❌ `theme/colors.js` lines 18-29: Update entire `woot` color palette from blue to orange spectrum

**Component Color Updates (24 files identified):**
- ❌ Vue components with hardcoded blue colors
- ❌ SCSS variable files in `/app/assets/stylesheets/`
- ❌ Swagger documentation color references
- ❌ Widget color configuration files
- ❌ Inline SVG colors in components (like Logo.vue - partially done)

### 📝 PHASE 3C: TEXT BRANDING REPLACEMENT (Priority 2 - SYSTEMATIC)

**i18n Localization Files (~50 language directories):**
- ✅ `/app/javascript/dashboard/i18n/locale/en/login.json` (already shows "AdzanaChat")
- ❌ `/app/javascript/dashboard/i18n/locale/en/resetPassword.json` (line 4: "Chatwoot")
- ❌ `/app/javascript/dashboard/i18n/locale/*/login.json` (~49 other languages)
- ❌ All other i18n files containing "Chatwoot" references

**Configuration & Infrastructure Files:**
- ❌ Docker compose files with "chatwoot" in comments/labels
- ❌ Installation config files
- ❌ Shell scripts with hardcoded references
- ❌ Documentation files (DEVELOPMENT_GUIDE.md, etc.)

**Code References (1200+ files):**
- ❌ Ruby class/module names containing "Chatwoot"
- ❌ Vue component internal references
- ❌ Test files and specs
- ❌ Variable names and constants
- ❌ Email template content
- ❌ Error messages and system strings

### ⚙️ PHASE 3D: VALIDATION & TESTING (Priority 3)

**Build Verification Steps:**
1. ❌ Run `npm run lint` - ensure no linting errors
2. ❌ Run `npm run typecheck` - verify TypeScript consistency  
3. ❌ Test GitHub Actions build pipeline
4. ❌ Visual verification across all UI contexts

### 🔧 EXECUTION STRATEGY

**Order of Operations:**
1. **Logo Replacements** (immediate visual impact, low risk)
2. **Core Theme Colors** (broad visual consistency) 
3. **Text Replacements** (batch process by file type)
4. **Build & Deploy** (comprehensive testing)

**Risk Mitigation:**
- Commit each phase separately for easy rollback
- Test build after each major change batch
- Validate file paths exist before replacement
- Backup original assets before replacement

### 📊 CURRENT STATUS SUMMARY

**Already Completed:**
- ✅ Logo color changes in 2 files (Logo.vue, logo_thumbnail.svg)
- ✅ Button color system using correct orange (#f9a94a)
- ✅ Custom logo files designed and ready
- ✅ English login form shows "AdzanaChat"

**Ready to Execute:**
- 🔄 **47+ logo file replacements** using provided AdzanaChat designs
- 🔄 **24 color system files** blue → orange transformation
- 🔄 **1200+ text replacements** Chatwoot → AdzanaChat
- 🔄 **Build validation** and deployment testing

**Expected Outcome:**
- Complete visual transformation to AdzanaChat brand
- Consistent orange color scheme (#f9a94a) throughout
- All user-facing text changed to AdzanaChat
- Professional, cohesive brand identity
- Zero broken builds or missing assets

### UI Development Workflow
```bash
# Current workflow for UI changes:

# 1. Make UI/styling changes locally
# Edit Vue components, CSS, images, etc.

# 2. Test changes (commit to local-testing)
git add .
git commit -m "UI: describe your changes"
git push origin local-testing

# 3. Wait for GitHub Actions to build image (~10 minutes)

# 4. Test locally with built image
./start-github-local.sh

# 5. Verify changes look good, then deploy
git checkout production
git merge local-testing  
git push origin production

# 6. Automatic deployment to https://www.adzanachat.com
```

**UI Testing Notes**:
- Frontend changes require full Docker image rebuild
- Use local-testing branch for all UI experiments
- Always test locally before production merge
- GitHub Actions build time: ~10 minutes per change

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