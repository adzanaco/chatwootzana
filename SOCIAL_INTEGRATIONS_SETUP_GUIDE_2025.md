# Complete A-Z Social Integrations Setup Guide for Chatwoot Self-Hosted (2025)

## Overview
This comprehensive guide covers setting up Facebook Messenger, Instagram Business API, and Gmail OAuth integrations for your Chatwoot self-hosted white-label SaaS platform. All steps are current as of 2025.

## Prerequisites
- Facebook Developer account (which you already have)
- Google Cloud Console access
- Your Chatwoot domain (e.g., `https://www.adzanachat.com`)
- SSH access to your production server

---

## 🔵 Part 1: Facebook Messenger Integration

### Step 1: Create Facebook App
1. **Go to Facebook Developer Portal**: https://developers.facebook.com/
2. **Click "Create App"**
3. **Select App Type**: Choose **"Other"**
4. **Choose Category**: Select **"Business"**
5. **Enter App Details**:
   - App Name: `YourPlatform Messenger Integration`
   - Email: Your business email
   - Click **Create App**

### Step 2: Configure Basic App Settings
1. **In App Dashboard → Settings → Basic**:
   - Note down your **App ID** and **App Secret**
   - Add your domain: `adzanachat.com` to **App Domains**
   - Privacy Policy URL: Your privacy policy URL
   - Terms of Service URL: Your terms URL

### Step 3: Add Facebook Login Product
1. **In App Dashboard → Add Product**
2. **Find "Facebook Login" and click "Set Up"**
3. **In Settings → Facebook Login → Settings**:
   - ✅ Enable **"Web OAuth Login"**
   - ✅ Enable **"Login with JavaScript SDK"**
   - **Valid OAuth Redirect URIs**: Add `https://www.adzanachat.com`
   - **Allowed Domains for the JavaScript SDK**: Add `adzanachat.com`

### Step 4: Add Messenger Product
1. **In App Dashboard → Add Product**
2. **Find "Messenger" and click "Set Up"**
3. **In Settings → Messenger → Settings**:
   - **Callback URL**: `https://www.adzanachat.com/bot`
   - **Verify Token**: Generate a secure token (save this): `your_secure_fb_verify_token_2025`
   - **Webhook Fields**: Subscribe to:
     - ✅ messages
     - ✅ messaging_postbacks
     - ✅ message_deliveries
     - ✅ message_reads
     - ✅ message_echoes

### Step 5: Configure Environment Variables
Add these to both your local `.env` and production environment:

```bash
# Facebook Messenger Configuration
FB_APP_ID=YOUR_APP_ID_HERE
FB_APP_SECRET=YOUR_APP_SECRET_HERE
FB_VERIFY_TOKEN=your_secure_fb_verify_token_2025
FB_APP_VERSION=v17.0
```

### Step 6: Configure Chatwoot Super Admin
1. Go to: `https://www.adzanachat.com/super_admin/installation_configs`
2. Find **Facebook section** and fill:
   - **Facebook App ID**: [Your App ID]
   - **Facebook App Secret**: [Your App Secret]
   - **Facebook Verify Token**: `your_secure_fb_verify_token_2025`
   - **Facebook API Version**: `v17.0`
3. **Click Submit**

---

## 📸 Part 2: Instagram Business API Integration

### Step 1: Create Meta App for Instagram
1. **Go to Meta Developer Portal**: https://developers.facebook.com/
2. **Either use existing Facebook app OR create new one**:
   - **For New App**: Follow same steps as Facebook (Other → Business)

### Step 2: Add Instagram Product
1. **In App Dashboard → Add Product**
2. **Find "Instagram" and click "Set Up"**
3. **Choose "Instagram Business Login"** (New 2025 Method)

### Step 3: Configure Instagram Business Login
1. **In Instagram Settings**:
   - **Callback URL**: `https://www.adzanachat.com/instagram/callback`
   - **Webhook URL**: `https://www.adzanachat.com/webhooks/instagram`
   - **Verify Token**: Generate secure token: `your_secure_ig_verify_token_2025`

### Step 4: Configure Webhook Subscriptions
**Subscribe to these webhook events**:
- ✅ messages
- ✅ messaging_seen  
- ✅ message_reactions

### Step 5: Add Instagram Testers (For Development)
1. **App Dashboard → Roles → Roles**
2. **Click "Add People"**
3. **Select Role**: "Instagram Tester"
4. **Enter Instagram Business Account ID**

### Step 6: Configure Environment Variables
Add these to your environment files:

```bash
# Instagram Configuration
INSTAGRAM_APP_ID=YOUR_INSTAGRAM_APP_ID
INSTAGRAM_APP_SECRET=YOUR_INSTAGRAM_APP_SECRET
INSTAGRAM_VERIFY_TOKEN=your_secure_ig_verify_token_2025
INSTAGRAM_API_VERSION=v22.0
```

### Step 7: Configure Chatwoot Super Admin
1. **Go to Super Admin → Installation Configs**
2. **Find Instagram section**:
   - **Instagram App ID**: [Your Instagram App ID]
   - **Instagram App Secret**: [Your Instagram App Secret]  
   - **Instagram Verify Token**: `your_secure_ig_verify_token_2025`
3. **Click Submit**

---

## 📧 Part 3: Gmail OAuth 2.0 Integration

### Step 1: Create Google Cloud Project
1. **Go to Google Cloud Console**: https://console.cloud.google.com/
2. **Create New Project**:
   - Project Name: `Chatwoot Gmail Integration`
   - Click **Create**

### Step 2: Enable Required APIs
1. **Go to APIs & Services → Library**
2. **Search and Enable**:
   - Gmail API
   - Google+ API (for profile access)

### Step 3: Configure OAuth Consent Screen
1. **Go to APIs & Services → OAuth consent screen**
2. **Choose User Type**: External
3. **Fill App Information**:
   - App Name: `Your Platform Email Integration`
   - User Support Email: Your email
   - Developer Contact: Your email
4. **Scopes → Add or Remove Scopes**:
   - ✅ `https://mail.google.com/` (Read, send, delete, and manage email)
   - ✅ `../auth/userinfo.profile` (View basic profile info)
5. **Test Users**: Add your Gmail addresses for testing

### Step 4: Create OAuth 2.0 Credentials
1. **Go to APIs & Services → Credentials**
2. **Click "Create Credentials" → OAuth 2.0 Client ID**
3. **Application Type**: Web Application
4. **Name**: `Chatwoot Gmail Integration`
5. **Authorized Redirect URIs**: Add:
   - `https://www.adzanachat.com/google/callback`
6. **Click Create** and **save Client ID and Client Secret**

### Step 5: Configure Environment Variables
Add to your environment files:

```bash
# Google OAuth Configuration
GOOGLE_OAUTH_CLIENT_ID=YOUR_CLIENT_ID.apps.googleusercontent.com
GOOGLE_OAUTH_CLIENT_SECRET=YOUR_CLIENT_SECRET
GOOGLE_OAUTH_CALLBACK_URL=https://www.adzanachat.com/google/callback

# Gmail SMTP Configuration (Required for sending emails)
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-gmail@gmail.com
SMTP_PASSWORD=your-app-password
SMTP_AUTHENTICATION=oauth2
```

### Step 6: Configure Chatwoot Super Admin (Dual Configuration)
1. **Go to Super Admin → Installation Configs**
2. **Find Google OAuth section**:
   - **Google OAuth Client ID**: [Your Client ID]
   - **Google OAuth Client Secret**: [Your Client Secret]
   - **Google OAuth Redirect URI**: `https://www.adzanachat.com/google/callback`
3. **Click Submit**

### Step 7: App Publishing (For Production)
**For Testing (Up to 100 users)**: Keep in Test Mode
**For Production**:
1. **OAuth Consent Screen → Publish App**
2. **Submit for Verification** (required for restricted scopes)
3. **Process takes 3-7 days**

---

## 🚀 Part 4: Deployment & Testing

### Step 1: Update Production Environment
```bash
# SSH to production server
ssh root@188.245.44.186

# Navigate to app directory
cd /opt/chatwoot

# Update .env.production with all the new variables
nano .env.production

# Add all FB, Instagram, and Google variables from above
```

### Step 2: Rebuild and Deploy
```bash
# Pull latest changes (if any code changes needed)
git pull origin production

# Restart containers to load new environment variables
docker-compose -f docker-compose.production-new.yml down
docker-compose -f docker-compose.production-new.yml up -d

# Check logs
docker-compose -f docker-compose.production-new.yml logs -f
```

### Step 3: Verify Integrations Work
1. **Log into Chatwoot Admin**: `https://www.adzanachat.com`
2. **Go to Settings → Inboxes → Add Inbox**
3. **Verify all channels are now clickable**:
   - ✅ Messenger (should be blue/active)
   - ✅ Instagram (should be active)  
   - ✅ Email → Google (should show Google option)

### Step 4: Test Each Integration
**Facebook Messenger**:
1. Click Messenger → should redirect to Facebook Login
2. Authorize and select a Facebook Page
3. Complete inbox setup

**Instagram**:
1. Click Instagram → should show Instagram Business Login
2. Authorize with Instagram Business Account
3. Complete setup

**Gmail**:
1. Click Email → Google
2. Should redirect to Google OAuth consent
3. Authorize and complete setup

---

## 🔧 Troubleshooting

### Facebook/Instagram Issues
**Problem**: "App not setup for this user"
**Solution**: Add users as App Testers in Meta Developer Console

**Problem**: Webhook verification fails  
**Solution**: Ensure verify tokens match exactly in app config and Chatwoot settings

### Gmail Issues
**Problem**: "OAuth error" during setup
**Solution**: 
- Verify both environment variables AND super admin config are set
- Check OAuth consent screen is properly configured
- Ensure Gmail API is enabled

**Problem**: Can receive but not send emails
**Solution**: Configure SMTP settings with OAuth2 authentication

### General Issues
**Problem**: Channels still greyed out after configuration
**Solution**:
1. Clear browser cache
2. Restart Chatwoot containers
3. Verify environment variables loaded: `docker-compose logs web`

**Problem**: Environment variables not loading
**Solution**:
```bash
# Check if variables are loaded in container
docker-compose exec web env | grep FB_APP_ID
docker-compose exec web env | grep GOOGLE_OAUTH
```

---

## 📋 Production Checklist

### Before Going Live
- [ ] All environment variables configured in production
- [ ] Super Admin console settings saved
- [ ] Facebook app in Live Mode (not Development)
- [ ] Instagram app in Live Mode  
- [ ] Google OAuth app published (if >100 users)
- [ ] Webhook URLs tested and verified
- [ ] Test user accounts can successfully connect
- [ ] SMTP configuration working for Gmail

### Security Notes
- Keep verify tokens secure and unique
- Use strong, random strings for verification tokens
- Regularly rotate app secrets
- Monitor webhook logs for suspicious activity

---

## 📞 Support & Next Steps

### For Your Customers
Once configured, your customers can:
1. **Facebook**: Connect their business Facebook Pages
2. **Instagram**: Connect their Instagram Business accounts  
3. **Gmail**: Connect their Gmail/Google Workspace accounts

### Scaling Considerations
- Facebook/Instagram apps support unlimited Pages/accounts
- Google OAuth may require verification for large-scale use
- Monitor API rate limits as you scale

### Maintenance
- Regularly update API versions (Facebook updates annually)
- Monitor deprecated features announcements
- Keep OAuth credentials secure and backed up

---

## 🎯 Success Indicators
✅ All three channel types show as active/clickable in inbox creation
✅ Test accounts can successfully complete OAuth flows  
✅ Messages flow bidirectionally for all channels
✅ Multiple customer accounts can connect their own social accounts
✅ No errors in Chatwoot application logs

---

*Last Updated: 2025 - Based on latest platform documentation and API changes*