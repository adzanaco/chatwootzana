#!/bin/bash

# Quick Commands for AdzanaChat Production Server
# Run these on your production server at 188.245.44.186

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}AdzanaChat Quick Commands${NC}"
echo "================================"

case "$1" in
  status)
    echo -e "${YELLOW}Checking service status...${NC}"
    cd /opt/chatwoot
    docker-compose -f docker-compose.production-new.yml ps
    ;;
    
  logs)
    echo -e "${YELLOW}Showing logs (Ctrl+C to exit)...${NC}"
    cd /opt/chatwoot
    docker-compose -f docker-compose.production-new.yml logs -f
    ;;
    
  restart)
    echo -e "${YELLOW}Restarting services...${NC}"
    cd /opt/chatwoot
    docker-compose -f docker-compose.production-new.yml restart
    echo -e "${GREEN}Services restarted!${NC}"
    ;;
    
  stop)
    echo -e "${RED}Stopping services...${NC}"
    cd /opt/chatwoot
    docker-compose -f docker-compose.production-new.yml down
    echo -e "${RED}Services stopped!${NC}"
    ;;
    
  start)
    echo -e "${GREEN}Starting services...${NC}"
    cd /opt/chatwoot
    docker-compose -f docker-compose.production-new.yml up -d
    echo -e "${GREEN}Services started!${NC}"
    ;;
    
  update)
    echo -e "${YELLOW}Pulling latest code and redeploying...${NC}"
    cd /opt/chatwoot
    git pull origin production
    docker-compose -f docker-compose.production-new.yml pull
    docker-compose -f docker-compose.production-new.yml down
    docker-compose -f docker-compose.production-new.yml up -d
    sleep 20
    docker-compose -f docker-compose.production-new.yml exec -T chatwoot-web bundle exec rails db:migrate
    echo -e "${GREEN}Update complete!${NC}"
    ;;
    
  console)
    echo -e "${YELLOW}Opening Rails console...${NC}"
    cd /opt/chatwoot
    docker-compose -f docker-compose.production-new.yml exec chatwoot-web bundle exec rails console
    ;;
    
  backup)
    echo -e "${YELLOW}Creating database backup...${NC}"
    cd /opt/chatwoot
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    docker-compose -f docker-compose.production-new.yml exec -T postgres pg_dump -U postgres chatwoot_production > backup_$TIMESTAMP.sql
    echo -e "${GREEN}Backup saved to: /opt/chatwoot/backup_$TIMESTAMP.sql${NC}"
    ;;
    
  health)
    echo -e "${YELLOW}Checking health...${NC}"
    if curl -s -f http://localhost:3000/api/v1/health > /dev/null; then
      echo -e "${GREEN}✅ Application is healthy!${NC}"
      echo "Visit: https://www.adzanachat.com"
    else
      echo -e "${RED}❌ Health check failed!${NC}"
      echo "Run: $0 logs"
    fi
    ;;
    
  *)
    echo "Usage: $0 {status|logs|restart|stop|start|update|console|backup|health}"
    echo ""
    echo "Commands:"
    echo "  status  - Show container status"
    echo "  logs    - Show live logs"
    echo "  restart - Restart all services"
    echo "  stop    - Stop all services"
    echo "  start   - Start all services"
    echo "  update  - Pull latest code and redeploy"
    echo "  console - Open Rails console"
    echo "  backup  - Create database backup"
    echo "  health  - Check application health"
    ;;
esac