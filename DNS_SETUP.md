# DNS Configuration for AdzanaChat

## Required DNS Records

You need to configure these DNS records for `www.adzanachat.com` to point to your server.

### Primary Record (www subdomain)
- **Type**: A
- **Name**: www
- **Value**: 188.245.44.186
- **TTL**: 3600 (or Auto)

### Root Domain Redirect (optional but recommended)
- **Type**: A  
- **Name**: @ (or leave empty for root)
- **Value**: 188.245.44.186
- **TTL**: 3600 (or Auto)

## Where to Add These Records

Depending on where your domain is registered:

### Namecheap
1. Log in to Namecheap
2. Go to Domain List → Manage
3. Click "Advanced DNS"
4. Add the A records above

### GoDaddy
1. Log in to GoDaddy
2. Go to My Products → Domains
3. Click "DNS" next to your domain
4. Add the A records above

### Cloudflare
1. Log in to Cloudflare
2. Select your domain
3. Go to DNS settings
4. Add the A records above
5. **Important**: Set proxy status to "DNS only" (grey cloud) initially

### Google Domains
1. Log in to Google Domains
2. Click your domain
3. Go to DNS → Manage custom records
4. Add the A records above

## Verify DNS Propagation

After adding records, verify they're working:

```bash
# Check DNS resolution
nslookup www.adzanachat.com
# Should return: 188.245.44.186

# Alternative check
dig www.adzanachat.com
# Should show: 188.245.44.186

# Test from browser
curl -I https://www.adzanachat.com
```

## DNS Propagation Time

- DNS changes can take 5 minutes to 48 hours to propagate globally
- Usually takes 15-30 minutes for most locations
- You can check propagation status at: https://www.whatsmydns.net/

## Troubleshooting

### If domain doesn't resolve:
1. Verify records are saved in your DNS provider
2. Wait 15-30 minutes for propagation
3. Clear your local DNS cache:
   - Mac: `sudo dscacheutil -flushcache`
   - Windows: `ipconfig /flushdns`
   - Linux: `sudo systemd-resolve --flush-caches`

### If SSL certificate fails:
1. Make sure DNS is pointing to 188.245.44.186
2. Ensure port 80 and 443 are open on server
3. Re-run certbot: `certbot --nginx -d www.adzanachat.com`

## Current Status Check

Run this to verify your domain setup:
```bash
echo "Checking www.adzanachat.com..."
if [[ $(dig +short www.adzanachat.com) == "188.245.44.186" ]]; then
  echo "✅ DNS is correctly configured!"
else
  echo "❌ DNS not yet pointing to 188.245.44.186"
  echo "Current IP: $(dig +short www.adzanachat.com)"
fi
```