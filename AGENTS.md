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

### Production (EasyPanel)
- **Repository**: `github.com/adzanaco/chatwootzana`
- **Branch**: `production` (all customizations)
- **Provider**: Hetzner server
- **Deployment**: Auto-deploy from GitHub

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
3. EasyPanel auto-deploys

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
POSTGRES_DATABASE=chatwoot_production
REDIS_URL=redis://redis:6379

# Application
FRONTEND_URL=https://your-domain.com
SECRET_KEY_BASE=<generate-unique-key>
RAILS_ENV=production
ACTIVE_STORAGE_SERVICE=local

# Email (Required)
SMTP_ADDRESS=<smtp-server>
SMTP_PORT=587
SMTP_USERNAME=<email>
SMTP_PASSWORD=<password>

# Integrations
N8N_WEBHOOK_URL=<your-n8n-webhook>
```

## Current Development Tools

### Scripts
- `./start-dev.sh` - Start development environment
- `./stop-dev.sh` - Stop all containers
- `./restart-dev.sh` - Restart web service

### Access
- **ngrok URL**: Public access for testing
- **localhost:3000**: Direct local access
- **Docker logs**: `docker-compose -f docker-compose.development.yml logs -f`

## Known Issues

1. **Image Display**: Images upload but don't display in agent dashboard (Active Storage serving issue)
2. **Database Reset**: Restarting containers may reset database
3. **ngrok URL Changes**: Need to re-add integrations after restart

## Legal
- **Chatwoot License**: MIT (commercial use permitted)
- **Attribution**: Keep MIT license in repository
- **Branding**: Can fully rebrand for customers

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