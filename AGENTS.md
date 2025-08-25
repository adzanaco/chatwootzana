# Chatwoot White-Label SaaS Project Documentation

## Project Overview
Building a white-label customer support platform based on Chatwoot (open-source) to sell as a monthly subscription SaaS to businesses.

### Business Goals
- **White-label Solution**: Completely rebrand Chatwoot as proprietary software
- **Monthly Subscriptions**: Charge businesses for using the platform
- **AI Integration**: Add AI-powered responses via n8n integration
- **Full Customization**: Maintain all features while adding custom enhancements
- **Multi-tenant SaaS**: Each business gets isolated environment

## Current Infrastructure

### Server Setup
- **Provider**: Hetzner (VPS/Dedicated Server)
- **Management**: EasyPanel (Docker orchestration platform)
- **Current Status**: 
  - Original Chatwoot template running (as reference)
  - Ready to deploy custom version from GitHub

### GitHub Repository
- **Forked Repository**: `github.com/adzanaco/chatwootzana`
- **Working Branch**: `production` (for all customizations)
- **Upstream Connection**: Maintained for updates from original Chatwoot
- **Deployment**: EasyPanel will pull from GitHub and auto-deploy

### Domain & Access
- **Custom Domain**: Will be configured (replacing Chatwoot branding)
- **SSL**: Required for production
- **Multi-tenant**: Each business potentially gets subdomain

## Technology Stack

### Backend
- **Language**: Ruby 3.4.5 (Latest stable as of Aug 2025)
- **Framework**: Rails 7.2.2.2 (Consider Rails 8.0.2.1 for new features)
- **Database**: PostgreSQL 17.6 (with pgvector extension - REQUIRED for Chatwoot v4)
- **Cache**: Redis 8.2.1 (Latest stable, 2x performance improvement)
- **Background Jobs**: Sidekiq with Sidekiq-cron
- **WebSockets**: ActionCable (Rails built-in)
- **API**: RESTful v1 namespace

### Frontend
- **Framework**: Vue.js 3.5.18 (Latest stable, Vue 3.6 alpha available)
- **State Management**: Vuex 4.1.0 (Consider Pinia for new projects)
- **Router**: Vue Router 4.4.5
- **Build Tool**: Vite 5.4.19 (Vite 6 coming Jan 2025)
- **Testing**: Vitest 3.0.5
- **Styling**: Tailwind CSS 3.4.13
- **UI Components**: Custom design system + Radix UI

### DevOps
- **Containerization**: Docker
- **Orchestration**: EasyPanel
- **Process Manager**: Puma (Rails server)
- **Node Version**: Node.js 22 LTS (v22.15.0 - Active LTS until Oct 2025)
- **Package Manager**: pnpm 10.x

## Key Customization Requirements

### 1. Branding Changes
- **Logo Replacement**: Update all logo references in `/app/javascript/dashboard/assets/`
- **Color Scheme**: Modify `tailwind.config.js` and design system
- **Application Name**: Update in all i18n locale files
- **Email Templates**: Rebrand all customer-facing emails
- **Favicon**: Replace with custom icon

### 2. Feature Additions

#### AI Mode Integration
- **Toggle Switch**: Add UI toggle for AI mode per conversation
- **n8n Webhook**: Send messages to n8n when AI mode active
- **Multi-modal**: Support text, image, and voice inputs
- **Response Handling**: Process AI responses back to chat
- **Configuration**: Easy setup for businesses via UI

#### Fixed Integrations
- **Facebook Messenger**: Currently broken on localhost
- **Instagram**: Integration needs fixing
- **Solution**: Implement proper OAuth callbacks and webhook verification
- **UI Wizard**: Create setup guide for businesses

#### Billing System
- **Stripe Integration**: For subscription management
- **Usage Tracking**: Monitor per-account usage
- **Limits**: Enforce plan-based restrictions
- **Admin Dashboard**: Manage customer subscriptions

### 3. Webhook System
- **Custom Webhooks**: Add ability to configure external webhooks
- **n8n Integration**: Primary AI processing pipeline
- **Event Types**: Message received, sent, conversation status changes
- **Security**: Token-based authentication

## Architecture Details

### Multi-tenancy
- **Model**: Account-based isolation
- **Database**: Single database, account_id foreign keys
- **Security**: Pundit policies enforce boundaries
- **Sequences**: Dynamic per-account ID generation

### File Structure (Key Locations)
```
/app/
  /models/           # Rails models (channels, accounts, users)
    /channel/        # Integration models (facebook, instagram, etc.)
  /controllers/      # API and webhook controllers
  /javascript/       # Vue.js frontend
    /dashboard/      # Main application UI
      /assets/       # Images, logos
      /i18n/         # Translations
      /components/   # Vue components
    /design-system/  # UI component library
  /views/           # Rails views (emails, layouts)
/config/
  /routes.rb        # API and webhook routes
  /database.yml     # Database configuration
/docker/            # Docker configurations
/public/            # Static assets
```

### API Structure
- **Public API**: `/public/api/v1/` - Widget and public endpoints
- **Account API**: `/api/v1/` - Main business logic
- **Platform API**: `/platform/api/v1/` - Admin functions
- **Webhooks**: `/webhooks/` - Integration endpoints

## Environment Variables (Production)

```bash
# Database
POSTGRES_HOST=<easypanel-postgres-host>
POSTGRES_USERNAME=<username>
POSTGRES_PASSWORD=<password>
POSTGRES_DATABASE=chatwoot_production
REDIS_URL=redis://<easypanel-redis-host>:6379
REDIS_PASSWORD=<redis-password>

# Application
FRONTEND_URL=https://your-domain.com
SECRET_KEY_BASE=<generate-unique-key>
RAILS_ENV=production
RACK_ENV=production
NODE_ENV=production

# Features
ENABLE_ACCOUNT_SIGNUP=true
FORCE_SSL=true
ACTIVE_STORAGE_SERVICE=local  # or s3 for cloud storage

# Email (Required)
MAILER_SENDER_EMAIL=support@your-domain.com
SMTP_ADDRESS=<smtp-server>
SMTP_PORT=587
SMTP_USERNAME=<smtp-username>
SMTP_PASSWORD=<smtp-password>
SMTP_DOMAIN=your-domain.com

# Integrations (Add as needed)
FB_APP_SECRET=<facebook-app-secret>
FB_APP_ID=<facebook-app-id>
STRIPE_SECRET_KEY=<stripe-key>

# n8n Webhook (Custom)
N8N_WEBHOOK_URL=https://n8n.your-domain.com/webhook/
N8N_API_KEY=<secure-api-key>
```

## Deployment Workflow

### GitHub → EasyPanel (Current Approach)
1. **Edit code** locally or via GitHub web
2. **Push to GitHub** (`production` branch)
3. **EasyPanel pulls** from GitHub
4. **Auto-builds** Docker image
5. **Deploys** automatically

### Quick Commands:
```bash
# Always work on production branch
git checkout production

# After making changes
git add .
git commit -m "Your changes"
git push origin production

# EasyPanel auto-deploys!
```

### No Local Development Needed!
- Use GitHub web editor for simple changes
- EasyPanel handles all building and deployment
- Original Chatwoot template remains as backup

## Legal & Licensing

### Chatwoot License
- **Type**: MIT License
- **Commercial Use**: Fully permitted
- **Modifications**: Allowed
- **Attribution**: Must include MIT license notice (not user-visible)
- **Our Rights**: Can fully rebrand and sell

### Important Notes
- Keep MIT license file in repository
- No need to display Chatwoot branding to end users
- Review all gem/npm dependencies for license compatibility
- Enterprise directory features may have separate licensing

## Current Status - Phase 1 COMPLETED ✅

### What's Done:
1. ✅ Forked Chatwoot to `github.com/adzanaco/chatwootzana`
2. ✅ Cloned repository locally with full codebase
3. ✅ Created `production` branch for customizations
4. ✅ Set up upstream remote for tracking original Chatwoot
5. ✅ Created `EASYPANEL_SETUP.md` with deployment instructions

### Ready for:
- EasyPanel deployment (see EASYPANEL_SETUP.md)
- Initial customization after deployment

## Known Issues to Address
- Facebook Messenger localhost authentication
- Instagram integration setup
- Need proper webhook verification endpoints
- OAuth callback URLs for development
- Multi-tenant billing not implemented

## Success Metrics
- Fully white-labeled appearance
- Seamless AI integration via n8n
- Easy business onboarding process
- Stable multi-tenant operation
- Automated billing and provisioning

## Critical Updates for 2025

### Chatwoot v4 Requirements
- **pgvector Extension**: MANDATORY for Chatwoot v4 - must be installed in PostgreSQL
- **UI Transition**: v4.5.2 is the FINAL release with v3 UI support
- **Migration Guide**: Follow official v4 migration guide before upgrading
- **Database Backup**: CRITICAL - Always backup before v4 migration
- **Release Cycle**: New versions released first Monday of each month

### Version Compatibility Matrix
- **Ruby 3.4.5**: Works with Rails 7.2.x and 8.x
- **Rails 7.2.2.2**: Requires Ruby 3.1.0 or newer
- **Rails 8.0.2.1**: Latest major version, requires Ruby 3.1.0+
- **Node.js 22 LTS**: Supported until April 2027
- **PostgreSQL 17.6**: Supports pgvector extension
- **Redis 8.2.1**: 87% faster commands, 2x throughput

### Security & Performance Notes
- **Redis 8**: Includes vector set (beta), JSON, time series support
- **PostgreSQL pgvector**: Enables AI/ML features in Chatwoot v4
- **Rails 8**: Improved performance, native authentication generators
- **Vue 3.6 Vapor Mode**: Experimental - reduces bundle size by 50%+

## Next Steps

### Immediate Action (Phase 2):
1. Open `EASYPANEL_SETUP.md`
2. Follow deployment steps in EasyPanel
3. Deploy custom Chatwoot from GitHub

### After Deployment (Phase 3):
- Customize branding (logos, colors, name)
- Add AI integration toggle
- Fix social integrations

### Key Documents:
- **EASYPANEL_SETUP.md** - Deployment guide
- **GITHUB_EXPLAINED.md** - Understanding Git/GitHub
- **TASKS.md** - Project phases and progress