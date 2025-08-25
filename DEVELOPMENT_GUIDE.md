# Development Environment Guide

## ✅ Current Setup

Your development environment is now running with:
- **URL**: https://cba782caaa22.ngrok-free.app
- **Local**: http://localhost:3000
- **Telegram Bot**: Connected and working
- **Code Mounting**: Key directories are mounted for live editing

## 📁 What You Can Edit (Live Changes)

These directories are mounted and changes will reflect:

### 1. **Dashboard Assets** (Logos, Images)
```
app/javascript/dashboard/assets/
```
- Replace logo files here
- Add custom images
- Changes visible after page refresh

### 2. **Dashboard Components** (UI Elements)
```
app/javascript/dashboard/components/
```
- Edit Vue components
- Modify UI layouts
- Changes need page refresh

### 3. **Translations** (Text/Labels)
```
app/javascript/dashboard/i18n/
```
- Change app text
- Update labels
- Instant with page refresh

### 4. **Widget** (Customer-facing chat widget)
```
app/javascript/widget/
```
- Customize chat bubble
- Edit widget appearance
- Changes need page refresh

### 5. **Email Templates**
```
app/views/layouts/
```
- Email headers/footers
- Template styling

### 6. **Brand Assets** (Your custom assets)
```
public/brand-assets/
```
- Store your logos here
- Custom CSS files
- Favicons

## 🔄 How Changes Work

### Frontend Changes (Instant)
1. Edit file in mounted directory
2. Save the file
3. Refresh browser
4. See changes immediately

### Backend Changes (Need Restart)
For Ruby/Rails code changes:
```bash
./restart-dev.sh
```

## 📝 Example: Changing the Logo

1. **Find current logo:**
```bash
ls app/javascript/dashboard/assets/images/
```

2. **Replace with your logo:**
```bash
cp your-logo.png app/javascript/dashboard/assets/images/logo.png
```

3. **Refresh browser** - Logo updated!

## 🎨 Example: Changing Colors

1. **Edit Tailwind config:**
```bash
nano tailwind.config.js
```

2. **Rebuild CSS:**
```bash
docker exec chatwoot-web yarn build:css
```

3. **Refresh browser**

## 🔧 Useful Commands

### View logs:
```bash
docker-compose -f docker-compose.development.yml logs -f chatwoot-web
```

### Restart web service:
```bash
./restart-dev.sh
```

### Stop everything:
```bash
./stop-dev.sh
```

### Start everything:
```bash
./start-dev.sh
```

### Check container status:
```bash
docker ps | grep chatwoot
```

## 🚀 Deployment Workflow

1. **Make changes locally** (this environment)
2. **Test at ngrok URL**
3. **When happy, commit:**
```bash
git add .
git commit -m "Your changes"
git push origin production
```
4. **EasyPanel auto-deploys** from GitHub

## ⚠️ Important Notes

- **Ngrok URL changes** when restarted
- **Telegram webhook** needs updating if ngrok restarts
- **Some files** aren't mounted (for stability)
- **Database changes** need migrations

## 🐛 Troubleshooting

### Changes not showing?
1. Check file is in mounted directory
2. Hard refresh browser (Cmd+Shift+R)
3. Check Docker logs for errors

### Telegram not working?
```bash
# Check webhook
docker exec chatwoot-web bundle exec rails runner "puts Channel::Telegram.first.bot_token"
```

### Container crashed?
```bash
docker-compose -f docker-compose.development.yml logs chatwoot-web
```

## Next Steps

Now you can:
1. Replace logos in `app/javascript/dashboard/assets/images/`
2. Edit colors in component files
3. Change text in locale files
4. Test everything at your ngrok URL
5. Push to GitHub when ready for production