#!/bin/bash

# Fix SSL and DNS issues for adzanachat.com
# Run this on your production server (188.245.44.186)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Fixing SSL and DNS Issues ===${NC}"

# Step 1: Check current DNS resolution
echo -e "\n${YELLOW}1. Checking DNS Resolution...${NC}"
echo "Current DNS for www.adzanachat.com:"
dig +short www.adzanachat.com
echo "Current DNS for adzanachat.com:"
dig +short adzanachat.com

# Step 2: Check Cloudflare Tunnel status
echo -e "\n${YELLOW}2. Checking Cloudflare Tunnel...${NC}"
if systemctl is-active --quiet cloudflared; then
    echo -e "${GREEN}✓ Cloudflare Tunnel is running${NC}"
    systemctl status cloudflared --no-pager | head -10
else
    echo -e "${RED}✗ Cloudflare Tunnel is not running${NC}"
    echo "Starting Cloudflare Tunnel..."
    systemctl start cloudflared
    systemctl enable cloudflared
fi

# Step 3: Update Cloudflare Tunnel configuration for proper SSL
echo -e "\n${YELLOW}3. Updating Cloudflare Tunnel Configuration...${NC}"
cat > ~/.cloudflared/config.yml << 'EOF'
tunnel: cf8bcc8b-85c8-4cf6-b20d-1fdb94707a35
credentials-file: /root/.cloudflared/cf8bcc8b-85c8-4cf6-b20d-1fdb94707a35.json

ingress:
  - hostname: www.adzanachat.com
    service: http://localhost:3001
    originRequest:
      noTLSVerify: true
      connectTimeout: 30s
  - hostname: adzanachat.com
    service: http://localhost:3001
    originRequest:
      noTLSVerify: true
      connectTimeout: 30s
  - service: http_status:404
EOF

echo -e "${GREEN}✓ Updated Cloudflare config${NC}"

# Step 4: Restart Cloudflare Tunnel
echo -e "\n${YELLOW}4. Restarting Cloudflare Tunnel...${NC}"
systemctl restart cloudflared
sleep 5

# Step 5: Stop EasyPanel from intercepting port 80/443
echo -e "\n${YELLOW}5. Checking for port conflicts...${NC}"
echo "Services on port 80:"
lsof -i :80 | grep LISTEN || echo "Port 80 is free"
echo -e "\nServices on port 443:"
lsof -i :443 | grep LISTEN || echo "Port 443 is free"

# Step 6: Add firewall rules to block direct IP access
echo -e "\n${YELLOW}6. Configuring firewall...${NC}"
# Allow Cloudflare IPs only for web traffic
ufw allow from 173.245.48.0/20 to any port 443
ufw allow from 103.21.244.0/22 to any port 443
ufw allow from 103.22.200.0/22 to any port 443
ufw allow from 103.31.4.0/22 to any port 443
ufw allow from 141.101.64.0/18 to any port 443
ufw allow from 108.162.192.0/18 to any port 443
ufw allow from 190.93.240.0/20 to any port 443
ufw allow from 188.114.96.0/20 to any port 443
ufw allow from 197.234.240.0/22 to any port 443
ufw allow from 198.41.128.0/17 to any port 443

# Block direct access to port 3001 from outside
ufw deny 3001

echo -e "${GREEN}✓ Firewall configured${NC}"

# Step 7: Test the setup
echo -e "\n${YELLOW}7. Testing configuration...${NC}"
echo "Testing Cloudflare Tunnel connection..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:3001/api/v1/health | grep -q "200"; then
    echo -e "${GREEN}✓ Local service is responding${NC}"
else
    echo -e "${RED}✗ Local service not responding${NC}"
fi

echo -e "\n${YELLOW}8. DNS Configuration Required:${NC}"
echo "=================================="
echo "You need to configure your DNS as follows:"
echo ""
echo "1. Go to Cloudflare Dashboard (https://dash.cloudflare.com)"
echo "2. Select your domain: adzanachat.com"
echo "3. Go to DNS settings"
echo "4. Delete any existing A records pointing to 188.245.44.186"
echo "5. Add these CNAME records instead:"
echo ""
echo "   Type: CNAME"
echo "   Name: www"
echo "   Target: cf8bcc8b-85c8-4cf6-b20d-1fdb94707a35.cfargotunnel.com"
echo "   Proxy: ON (orange cloud)"
echo ""
echo "   Type: CNAME"
echo "   Name: @ (or adzanachat.com)"
echo "   Target: cf8bcc8b-85c8-4cf6-b20d-1fdb94707a35.cfargotunnel.com"
echo "   Proxy: ON (orange cloud)"
echo ""
echo "This will:"
echo "- Route all traffic through Cloudflare (fixes SSL)"
echo "- Prevent direct IP access (fixes EasyPanel conflict)"
echo "- Work consistently on all devices"
echo ""
echo -e "${GREEN}=== Setup Complete ===${NC}"
echo ""
echo "After updating DNS in Cloudflare:"
echo "1. Clear your phone's browser cache"
echo "2. Wait 5-10 minutes for DNS propagation"
echo "3. Test on both mobile and desktop"