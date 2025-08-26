#!/bin/bash

# Chatwoot Production Server Setup Script
# For Ubuntu 22.04 LTS on Hetzner Cloud

set -e

echo "========================================="
echo "Chatwoot Production Server Setup"
echo "========================================="

# Variables
DOMAIN=${1:-""}
EMAIL=${2:-""}

if [ -z "$DOMAIN" ] || [ -z "$EMAIL" ]; then
    echo "Usage: ./setup-server.sh <domain> <email>"
    echo "Example: ./setup-server.sh chat.yourdomain.com admin@yourdomain.com"
    exit 1
fi

# Update system
echo "Updating system packages..."
apt-get update
apt-get upgrade -y

# Install dependencies
echo "Installing dependencies..."
apt-get install -y \
    curl \
    git \
    ufw \
    nginx \
    certbot \
    python3-certbot-nginx \
    software-properties-common \
    ca-certificates \
    gnupg \
    lsb-release

# Install Docker
echo "Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
fi

# Install Docker Compose v2
echo "Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    apt-get install -y docker-compose-plugin
    # Create symlink for compatibility
    ln -sf /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose
fi

# Configure firewall
echo "Configuring firewall..."
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

# Create app directory
echo "Creating application directory..."
mkdir -p /opt/chatwoot
cd /opt/chatwoot

# Clone repository
echo "Cloning repository..."
if [ ! -d ".git" ]; then
    git clone -b production https://github.com/adzanaco/chatwootzana.git .
else
    git fetch origin production
    git reset --hard origin/production
fi

# Create environment file
echo "Creating environment template..."
if [ ! -f ".env.production" ]; then
    cp .env.production.example .env.production 2>/dev/null || cat > .env.production <<'EOF'
# Database
POSTGRES_USER=postgres
POSTGRES_PASSWORD=CHANGE_ME_STRONG_PASSWORD
POSTGRES_DATABASE=chatwoot_production

# Redis
REDIS_PASSWORD=

# Rails
RAILS_ENV=production
RACK_ENV=production
NODE_ENV=production
RAILS_LOG_TO_STDOUT=true
RAILS_SERVE_STATIC_FILES=true

# Security - Generate with: openssl rand -hex 64
SECRET_KEY_BASE=CHANGE_ME_GENERATE_NEW_SECRET

# Application
FRONTEND_URL=https://DOMAIN_PLACEHOLDER
FORCE_SSL=true
ENABLE_ACCOUNT_SIGNUP=false
USE_INBOX_AVATAR_FOR_BOT=true

# Storage
ACTIVE_STORAGE_SERVICE=local
STORAGE_PATH=/app/storage

# Email Configuration
MAILER_SENDER_EMAIL=noreply@DOMAIN_PLACEHOLDER
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=CHANGE_ME
SMTP_PASSWORD=CHANGE_ME
SMTP_DOMAIN=DOMAIN_PLACEHOLDER
SMTP_AUTHENTICATION=plain
SMTP_ENABLE_STARTTLS_AUTO=true

# Optional: Social Login
# GOOGLE_OAUTH_CLIENT_ID=
# GOOGLE_OAUTH_CLIENT_SECRET=
# FB_APP_ID=
# FB_APP_SECRET=

# Optional: AI Integration
# OPENAI_API_KEY=
# N8N_WEBHOOK_URL=
EOF
    
    # Replace domain placeholder
    sed -i "s/DOMAIN_PLACEHOLDER/$DOMAIN/g" .env.production
    
    echo ""
    echo "================================================"
    echo "IMPORTANT: Edit .env.production with your values"
    echo "================================================"
    echo "1. Generate SECRET_KEY_BASE: openssl rand -hex 64"
    echo "2. Set strong POSTGRES_PASSWORD"
    echo "3. Configure SMTP settings"
    echo "================================================"
fi

# Configure Nginx
echo "Configuring Nginx..."
cat > /etc/nginx/sites-available/chatwoot <<EOF
server {
    listen 80;
    server_name $DOMAIN;
    
    location / {
        return 301 https://\$server_name\$request_uri;
    }
}

server {
    listen 443 ssl http2;
    server_name $DOMAIN;
    
    # SSL will be configured by Certbot
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    # Proxy settings
    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Forwarded-Ssl on;
        proxy_set_header X-Forwarded-Port \$server_port;
        proxy_set_header X-Forwarded-Host \$host;
        
        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # File upload size
        client_max_body_size 100M;
    }
    
    # Cable endpoint for ActionCable
    location /cable {
        proxy_pass http://127.0.0.1:3000/cable;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable site
ln -sf /etc/nginx/sites-available/chatwoot /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Test and reload Nginx
nginx -t
systemctl reload nginx

# Setup SSL with Let's Encrypt
echo "Setting up SSL certificate..."
certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m $EMAIL --redirect

# Create systemd service for auto-start
echo "Creating systemd service..."
cat > /etc/systemd/system/chatwoot.service <<'EOF'
[Unit]
Description=Chatwoot Docker Compose Application
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/chatwoot
ExecStart=/usr/local/bin/docker-compose -f docker-compose.production-new.yml up -d
ExecStop=/usr/local/bin/docker-compose -f docker-compose.production-new.yml down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable chatwoot

# Create GitHub deploy key directory
echo "Setting up deploy keys..."
mkdir -p /root/.ssh
chmod 700 /root/.ssh

echo ""
echo "========================================="
echo "Server Setup Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Edit environment file:"
echo "   nano /opt/chatwoot/.env.production"
echo ""
echo "2. Generate deploy key for GitHub Actions:"
echo "   ssh-keygen -t ed25519 -C 'github-actions' -f /root/.ssh/github_deploy"
echo "   cat /root/.ssh/github_deploy.pub >> /root/.ssh/authorized_keys"
echo "   cat /root/.ssh/github_deploy  # Copy this private key to GitHub Secrets"
echo ""
echo "3. Add GitHub Secrets in your repository:"
echo "   - PRODUCTION_HOST: $(curl -s ifconfig.me)"
echo "   - PRODUCTION_USER: root"
echo "   - PRODUCTION_PORT: 22"
echo "   - PRODUCTION_SSH_KEY: (paste private key from step 2)"
echo ""
echo "4. Start Chatwoot:"
echo "   cd /opt/chatwoot"
echo "   docker-compose -f docker-compose.production-new.yml up -d"
echo ""
echo "5. Initialize database (first time only):"
echo "   docker-compose -f docker-compose.production-new.yml exec chatwoot-web bundle exec rails db:chatwoot_prepare"
echo ""
echo "Domain: https://$DOMAIN"
echo "========================================="