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

### Local Development
1. Edit files in mounted directories
2. Test at ngrok URL
3. Frontend changes: Refresh browser
4. Backend changes: Run `./restart-dev.sh`

### Deployment
1. Commit changes locally
2. Push to `production` branch
3. GitHub Actions auto-deploys to server
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

## Current Development Tools

### Local Scripts
- `./start-dev.sh` - Start development environment
- `./stop-dev.sh` - Stop all containers
- `./restart-dev.sh` - Restart web service

### Production Scripts (on server)
- `/opt/chatwoot/deploy/quick-commands.sh status` - Check container status
- `/opt/chatwoot/deploy/quick-commands.sh logs` - View live logs
- `/opt/chatwoot/deploy/quick-commands.sh restart` - Restart services
- `/opt/chatwoot/deploy/quick-commands.sh update` - Pull latest and redeploy
- `/opt/chatwoot/deploy/quick-commands.sh backup` - Create database backup

### Access
- **Production**: https://www.adzanachat.com
- **ngrok URL**: Public access for local testing
- **localhost:3000**: Direct local access
- **Production logs**: `docker-compose -f docker-compose.production-new.yml logs -f`
- **Local logs**: `docker-compose -f docker-compose.development.yml logs -f`

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

## Next Steps

### Phase 3: Customization
- Replace logos and branding
- Update color scheme
- Change app name throughout
- Customize email templates

### Phase 4: Features
- Implement AI toggle UI
- Add n8n webhook integration
- Fix social media integrations
- Add billing system