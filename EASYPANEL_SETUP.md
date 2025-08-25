# EasyPanel Deployment Guide for Chatwoot White-Label

## ✅ What's Done
1. **Forked Chatwoot** to `github.com/adzanaco/chatwootzana`
2. **Cloned locally** with full codebase
3. **Created production branch** for customizations
4. **Set up remotes** for tracking upstream changes

## 🚀 Ready for EasyPanel - DO THIS NOW!

### Step 1: Go to EasyPanel Dashboard
1. Click **"Create New"** → **"App"**
2. Name it: `chatwoot-custom` (or your brand name)

### Step 2: Configure GitHub Source
1. **Source Type**: GitHub
2. **Repository**: `adzanaco/chatwootzana`
3. **Branch**: `production`
4. **Build Type**: Dockerfile
5. **Dockerfile Path**: `Dockerfile` (default)

### Step 3: Add Required Services

#### PostgreSQL Service
1. Click **"Add Service"** → **"PostgreSQL"**
2. Version: **17** (for pgvector support)
3. Database Name: `chatwoot_production`
4. Note the connection details:
   - Host: `postgres` (internal name)
   - Port: `5432`
   - Username: (EasyPanel provides)
   - Password: (EasyPanel provides)

#### Redis Service
1. Click **"Add Service"** → **"Redis"**
2. Version: **8** (latest)
3. Note the connection:
   - Host: `redis` (internal name)
   - Port: `6379`

#### Sidekiq Worker Service
1. Click **"Add Service"** → **"App"**
2. Name: `chatwoot-worker`
3. **Same GitHub repo and branch**
4. Command Override: `bundle exec sidekiq -C config/sidekiq.yml`
5. Uses same environment variables as main app

### Step 4: Environment Variables (COPY THESE!)

Add these to your main App service AND Worker service:

```env
# Database (adjust with your EasyPanel PostgreSQL details)
DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@postgres:5432/chatwoot_production
POSTGRES_HOST=postgres
POSTGRES_USERNAME=postgres
POSTGRES_PASSWORD=YOUR_PASSWORD
POSTGRES_DATABASE=chatwoot_production

# Redis (adjust with your EasyPanel Redis details)
REDIS_URL=redis://redis:6379/0
REDIS_PASSWORD=

# Rails Configuration
RAILS_ENV=production
RACK_ENV=production
NODE_ENV=production
RAILS_LOG_TO_STDOUT=true
RAILS_SERVE_STATIC_FILES=true

# Security (GENERATE A NEW ONE!)
SECRET_KEY_BASE=GENERATE_WITH_openssl_rand_-hex_64

# Application URLs
FRONTEND_URL=https://YOUR_DOMAIN.com
FORCE_SSL=true

# Features
ENABLE_ACCOUNT_SIGNUP=false
USE_INBOX_AVATAR_FOR_BOT=true

# Storage
ACTIVE_STORAGE_SERVICE=local
STORAGE_PATH=/app/storage

# Email (Required - use your SMTP)
MAILER_SENDER_EMAIL=noreply@YOUR_DOMAIN.com
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password
SMTP_DOMAIN=YOUR_DOMAIN.com
SMTP_AUTHENTICATION=plain
SMTP_ENABLE_STARTTLS_AUTO=true

# Optional - Social Login
# GOOGLE_OAUTH_CLIENT_ID=
# GOOGLE_OAUTH_CLIENT_SECRET=
# FB_APP_ID=
# FB_APP_SECRET=

# Optional - AI Integration
# OPENAI_API_KEY=
# N8N_WEBHOOK_URL=
```

### Step 5: Volumes Configuration

Add persistent volume for uploads:
- **Mount Path**: `/app/storage`
- **Size**: 10GB (adjust as needed)

### Step 6: Networking & Domain

1. **Port**: 3000 (Rails default)
2. **Enable HTTPS**: ✅ (Let's Encrypt auto SSL)
3. **Domain**: Add your custom domain
4. **Health Check Path**: `/api/v1/health`

### Step 7: Build & Deploy Settings

1. **Build Command**: Leave empty (Dockerfile handles it)
2. **Start Command**: Leave empty (uses Dockerfile CMD)
3. **Memory**: Minimum 2GB recommended
4. **CPU**: Minimum 1 core

### Step 8: Database Initialization (FIRST TIME ONLY!)

After first deployment, run these commands in EasyPanel terminal:

```bash
# Access the app container
docker exec -it chatwoot-custom bash

# Create database and extensions
rails db:create
rails db:migrate

# Install pgvector extension
rails runner "ActiveRecord::Base.connection.execute('CREATE EXTENSION IF NOT EXISTS vector')"

# Create first admin user
rails c
> User.create!(email: 'admin@yourdomain.com', password: 'StrongPassword123!', name: 'Admin', confirmed_at: Time.now)
> exit
```

### Step 9: Deploy!

1. Click **"Deploy"** button
2. Watch build logs (takes 5-10 minutes first time)
3. Once green, access your domain
4. Login with admin credentials

## 🎨 Next: Customization

Once deployed and working, we'll customize:
1. **Logo**: `/app/javascript/dashboard/assets/images/`
2. **Colors**: `tailwind.config.js`
3. **App Name**: `/app/javascript/dashboard/i18n/locale/en.json`

## 🔧 Troubleshooting

### If deployment fails:
1. Check build logs in EasyPanel
2. Verify all environment variables are set
3. Ensure PostgreSQL and Redis are running
4. Check memory/CPU limits

### Common Issues:
- **Database connection failed**: Check DATABASE_URL format
- **Assets not loading**: Ensure RAILS_SERVE_STATIC_FILES=true
- **Emails not sending**: Verify SMTP settings
- **Sidekiq not processing**: Check worker service is running

## 📝 Important Notes

1. **First deployment takes longer** (building assets)
2. **Keep original Chatwoot template running** as backup
3. **Test on subdomain first** before switching main domain
4. **Database is separate** from original Chatwoot template

## ✅ Deployment Checklist

- [ ] Created new App in EasyPanel
- [ ] Connected GitHub repository
- [ ] Added PostgreSQL service
- [ ] Added Redis service
- [ ] Added Sidekiq worker service
- [ ] Configured all environment variables
- [ ] Set up persistent storage volume
- [ ] Configured domain and SSL
- [ ] Deployed successfully
- [ ] Ran database migrations
- [ ] Created admin user
- [ ] Tested login

Once all checked, you're ready for customization!