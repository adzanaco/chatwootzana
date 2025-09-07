# Chatwoot White-Label SaaS Project

## Project Overview
Building a white-label customer support platform based on Chatwoot to sell as a monthly subscription SaaS.

### Business Goals
- **White-label Solution**: Completely rebrand Chatwoot
- **Monthly Subscriptions**: Charge businesses for platform usage
- **AI Integration**: Add AI-powered responses via n8n
- **Multi-tenant SaaS**: Each business gets isolated environment

## Current Setup

### Local Development
- **Environment**: Docker containers with volume mounts
- **URL**: ngrok tunnel (changes each restart)
- **Database**: PostgreSQL 17 with pgvector
- **Redis**: Version 8.2.1
- **Storage**: Local file storage configured
- **Integrations**: Telegram/WhatsApp work via ngrok

### Production (Hetzner Server - 188.245.44.186)
- **Repository**: `github.com/adzanaco/chatwootzana`
- **Branch**: `production` (all customizations)
- **Provider**: Hetzner server with EasyPanel
- **Deployment**: GitHub Actions auto-deploy on push to production
- **Access**: https://www.adzanachat.com (via Cloudflare Tunnel)
- **Internal Port**: 3001 (exposed as 0.0.0.0:3001)
- **Admin Login**: executive@adzana.ae / Shuaib6655@
- **Docker Setup**: Custom docker-compose.production-new.yml
- **Cloudflare Tunnel ID**: cf8bcc8b-85c8-4cf6-b20d-1fdb94707a35

## Technology Stack

### Backend
- **Ruby**: 3.4.5
- **Rails**: 7.1.5.2 (Chatwoot current)
- **PostgreSQL**: 17 with pgvector extension (REQUIRED)
- **Redis**: 8.2.1
- **Sidekiq**: Background job processing

### Frontend
- **Vue.js**: 3.5.18
- **Tailwind CSS**: 3.4.13
- **Vite**: Build tool
- **UI Components**: Custom design system

## Development Workflow

### CURRENT WORKING SETUP: GitHub Image-Based (Recommended)
Use this approach to avoid M2 Mac build issues. GitHub builds the Docker image for you.

**Workflow:**
1. Make code changes locally
2. Commit and push to `local-testing` branch
3. Wait for GitHub Actions to build (~10 minutes)
4. Run `./start-github-local.sh` to pull and test
5. Access at http://localhost:3000 or ngrok URL
6. Stop with `./stop-github-local.sh`

**Note:** This 10-minute wait for every code change can slow development. Consider using volume-mounted setup for rapid local development if you need to iterate quickly.

**Scripts for GitHub Image Setup:**
- `./start-github-local.sh` - Pulls GitHub image and starts containers (uses `docker-compose.github-local.yml`)
- `./stop-github-local.sh` - Stops all containers

### ALTERNATIVE: Local Development with Volume Mounts (Has Issues)
This approach mounts local directories but has issues with backend changes not reflecting.

**Scripts for Volume Mount Setup:**
- `./start-dev.sh` - Start with volume mounts (uses `docker-compose.development.yml`)
- `./stop-dev.sh` - Stop containers
- `./restart-dev.sh` - Restart web service only

**Other deprecated/unused scripts:**
- `./start-docker-dev.sh` - Uses `docker-compose.local.yml` (deprecated)
- `./quick-start.sh` - Uses `docker-compose.dev.yml` (deprecated)
- Various `setup-*.sh` - Initial setup scripts (one-time use)

### Production Deployment

**IMPORTANT:** The production server uses pre-built Docker images from GitHub Container Registry. There is NO Dockerfile on the server, so no local building happens.

#### For Static Assets (logos, images in `/public/brand-assets/`):
```bash
ssh root@188.245.44.186
cd /opt/chatwoot
git pull origin production
# That's it! Changes are live instantly (volume-mounted)
```

#### For Code Changes (Vue, Ruby, etc.):
1. Push to `production` branch
2. Wait for GitHub Actions to build and push image (~10 minutes)
3. Deploy on server:
   ```bash
   ssh root@188.245.44.186
   cd /opt/chatwoot
   git pull origin production
   docker-compose -f docker-compose.production-new.yml down
   docker-compose -f docker-compose.production-new.yml up -d
   ```
4. Accessible at https://www.adzanachat.com

### Mounted Directories (Live Editing)
```
app/javascript/dashboard/assets/     # Logos, images
app/javascript/dashboard/components/ # UI components
app/javascript/dashboard/i18n/       # Translations
app/javascript/widget/               # Chat widget
public/brand-assets/                 # Custom assets
storage/                            # File uploads
```

## Key Customization Locations

### Branding
- **Logos**: `/app/javascript/dashboard/assets/images/`
- **Colors**: Component files and Tailwind config
- **App Name**: i18n locale files
- **Email Templates**: `/app/views/mailers/`
- **Favicon**: `/public/favicon.ico`

### Features to Add
1. **AI Mode Toggle**: Per-conversation AI activation
2. **n8n Integration**: Webhook endpoints for AI
3. **Billing System**: Stripe subscriptions
4. **Fixed Social Integrations**: Facebook/Instagram OAuth

## Environment Variables (Production)

```bash
# Database
POSTGRES_HOST=postgres
POSTGRES_USER=postgres
POSTGRES_PASSWORD=Shuaib6655
POSTGRES_DATABASE=chatwoot_production
REDIS_URL=redis://redis:6379

# Application  
FRONTEND_URL=https://www.adzanachat.com
SECRET_KEY_BASE=2526d0535ad2a4964d47c85441a94788dd736336ad424e1625e4caf829842970d637d223771739e58d75a2534b88f3e45c1db809a0185ab3e3b07dd0b648d25a
RAILS_ENV=production
ACTIVE_STORAGE_SERVICE=local
FORCE_SSL=true

# Email (Gmail configured)
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=executive@adzana.ae
SMTP_PASSWORD=fqed mbry uqll silj
SMTP_DOMAIN=adzana.ae
MAILER_SENDER_EMAIL=executive@adzana.ae

# Integrations
N8N_WEBHOOK_URL=<pending-setup>
```

## How Deployments Actually Work

### Production Server Reality:
1. **Pre-built Images**: Server pulls from `ghcr.io/adzanaco/chatwootzana:production`
2. **No Local Building**: No Dockerfile on server, `docker build` will fail
3. **Brand Assets**: Volume-mounted at `./public/brand-assets:/app/public/brand-assets:ro`
   - Changes to logos/images are instant with just `git pull`
   - No container restart needed for brand assets
4. **Code Changes**: Require GitHub Actions to build first, then server pulls new image

### What Needs Container Restart vs What Doesn't:
- **NO restart needed**: Images/logos in `/public/brand-assets/`
- **Restart needed**: Any code changes (Vue components, Ruby files, CSS, etc.)

## Important: File Structure Clarification

### Docker Compose Files
**CURRENTLY USED:**
- `docker-compose.github-local.yml` - **PRIMARY LOCAL FILE** - Pulls from GitHub registry
- `docker-compose.production-new.yml` - **PRODUCTION FILE** (on server at /opt/chatwoot/)

**ALTERNATIVE/DEPRECATED:**
- `docker-compose.development.yml` - Volume mount approach (has issues with backend changes)
- `docker-compose.dev.yml` - Old setup (deprecated)
- `docker-compose.local.yml` - Old setup (deprecated)

### Shell Scripts Breakdown

**RECOMMENDED SCRIPTS (GitHub Image-Based):**
- `./start-github-local.sh` - Start local env with GitHub image
- `./stop-github-local.sh` - Stop GitHub image containers

**ALTERNATIVE SCRIPTS (Volume Mount - Has Issues):**
- `./start-dev.sh` - Start with volume mounts
- `./stop-dev.sh` - Stop volume mount containers
- `./restart-dev.sh` - Restart web service only

**DEPRECATED/UNUSED:**
- `./quick-start.sh` - Old setup script
- `./start-docker-dev.sh` - Old setup script
- `./start.sh`, `./stop.sh` - Generic scripts (not configured)

**ONE-TIME SETUP SCRIPTS:**
- `./setup-ngrok.sh` - Configure ngrok
- `./setup-docker.sh` - Install Docker
- `./setup-app.sh` - Initial app setup
- `./complete-setup.sh` - Full initial setup

**PRODUCTION SCRIPTS (on server at /opt/chatwoot/deploy/):**
- `quick-commands.sh status` - Check container status (uses docker-compose.production-new.yml)
- `quick-commands.sh logs` - View live logs (uses docker-compose.production-new.yml)
- `quick-commands.sh restart` - Restart services (uses docker-compose.production-new.yml)
- `quick-commands.sh update` - Pull and redeploy (uses docker-compose.production-new.yml)
- `quick-commands.sh backup` - Create database backup
- `manual-deploy.sh` - Manual deployment script (uses docker-compose.production-new.yml)
- `setup-server.sh` - Initial server setup (uses docker-compose.production-new.yml)
- `fix-ssl-dns.sh` - Fix SSL and DNS issues

### Access & Commands
- **Production**: https://www.adzanachat.com
- **ngrok URL**: Public access for local testing
- **localhost:3000**: Direct local access

### Quick Command Reference

**RECOMMENDED LOCAL SETUP (GitHub Image):**
```bash
# Start local environment
./start-github-local.sh

# Stop environment
./stop-github-local.sh

# View logs
docker-compose -f docker-compose.github-local.yml logs -f

# Check status
docker-compose -f docker-compose.github-local.yml ps
```

**PRODUCTION (on server):**
```bash
# SSH to server
ssh root@188.245.44.186

# Navigate to app
cd /opt/chatwoot

# Deploy changes (NO docker build - server uses pre-built images!)
git pull origin production
docker-compose -f docker-compose.production-new.yml down
docker-compose -f docker-compose.production-new.yml up -d

# View logs
docker-compose -f docker-compose.production-new.yml logs -f

# Note: Brand assets in /public/brand-assets update instantly with git pull
# Only code changes require container restart
```

## Known Issues

1. **Image Display**: Images upload but don't display in agent dashboard (Active Storage serving issue)
2. **Database Reset**: Restarting containers may reset database
3. **ngrok URL Changes**: Need to re-add integrations after restart

## Legal
- **Chatwoot License**: MIT (commercial use permitted)
- **Attribution**: Keep MIT license in repository
- **Branding**: Can fully rebrand for customers

## Production Infrastructure Details

### Server SSH Access
```bash
ssh root@188.245.44.186
# Password: Shuaib6655@
```

### File Locations on Server
- **Application**: `/opt/chatwoot/`
- **Docker Compose**: `/opt/chatwoot/docker-compose.production-new.yml`
- **Environment Variables**: `/opt/chatwoot/.env.production`
- **Cloudflare Config**: `~/.cloudflared/config.yml`

### GitHub Secrets Configured
- `PRODUCTION_HOST`: 188.245.44.186
- `PRODUCTION_USER`: root
- `PRODUCTION_SSH_KEY`: (SSH key for deployment)
- `GITHUB_TOKEN`: (For container registry)

### Services Running
- **Port 3001**: Chatwoot application
- **Port 5432**: PostgreSQL database
- **Port 6379**: Redis cache
- **Cloudflare Tunnel**: Routes www.adzanachat.com to localhost:3001
- **EasyPanel**: Running on port 3000 (separate)
- **n8n**: Running via EasyPanel

## Current Status (September 2025)

**Production Status**: ✅ FULLY OPERATIONAL
- Production server deployed and running at https://www.adzanachat.com
- Health check port fixed (3001) - deployments now work correctly
- Button colors updated to lighter orange (#f9a94a)
- All containers healthy and running properly

**Recent Completed Work**:
- Fixed deployment health check from port 3000 → 3001
- Updated button color hex codes for better UI consistency
- Successfully tested GitHub Actions → production deployment pipeline
- Verified server configuration matches deployment requirements

## Logo Files - AdzanaChat Branding

**Custom AdzanaChat Logos Available:**
- **Source Location**: `/Users/raedshuaibwork/Downloads/adzanachatlogos/`
- **Color Scheme**: Orange `#f9a94a` + White
- **Brand**: "AdzanaChat" custom design

**Logo File Mappings:**
1. **browsertab.svg** → Browser tab icon/favicon
2. **smallcirclelogo.svg** → Dashboard UI elements, sidebar icons  
3. **logothumbnail.svg** → Settings, profile areas, thumbnails
4. **mainlogo.svg** → Login pages, main headers, full branding
5. **widgetlogo.svg** → Customer chat widget, external facing

**Implementation Status:**
- ✅ Logo files created with orange `#f9a94a` AdzanaChat branding
- 🔄 Integration in progress using systematic replacement approach

## Next Steps

### Phase 3: UI/UX Customization - IN PROGRESS
**Currently implementing AdzanaChat rebranding**

**Completed:**
- Custom AdzanaChat logo files designed and ready
- Color scheme defined: Orange `#f9a94a` (established)
- Button system already using correct orange

**In Progress:**
- Logo replacement throughout application
- Theme color updates from blue to orange
- Text branding updates (Chatwoot → AdzanaChat)

**Planned:**
- Comprehensive testing and deployment
- Final branding consistency verification

### Phase 4: Features - FUTURE
- Implement AI toggle UI
- Add n8n webhook integration
- Fix social media integrations
- Add billing system