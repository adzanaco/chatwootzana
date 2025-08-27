#!/bin/bash

echo "================================================"
echo "SAFE CLEANUP SCRIPT - Review Before Running"
echo "================================================"
echo ""
echo "This script will help you identify what can be safely deleted."
echo "Each section is commented - uncomment only what you're sure about."
echo ""

# ============================================
# SAFEST TO DELETE - Old Docker Compose Files
# ============================================
echo "1. OLD DOCKER COMPOSE FILES (Very Safe to Delete):"
echo "   These are deprecated and NOT used by your current setup"
echo "   - docker-compose.yaml (old base file)"
echo "   - docker-compose.production.yaml (old production)"
echo "   - docker-compose.test.yaml (for testing only)"
echo "   - docker-compose.dev.yml (old dev setup)"
echo "   - docker-compose.local.yml (old local setup)"
echo ""
# UNCOMMENT TO DELETE:
# rm -f docker-compose.yaml docker-compose.production.yaml docker-compose.test.yaml docker-compose.dev.yml docker-compose.local.yml
# echo "✅ Deleted old Docker compose files"

# ============================================
# TEST FILES - Safe if Not Running Tests
# ============================================
echo "2. TEST FILES (Safe if you don't run tests):"
echo "   - spec/ folder (500+ test files)"
echo "   - test/ folder"
echo "   - vitest.setup.js"
echo ""
# UNCOMMENT TO DELETE:
# rm -rf spec/ test/
# rm -f vitest.setup.js test_helper.rb
# echo "✅ Deleted test files"

# ============================================
# OLD DOCUMENTATION - Safe to Delete
# ============================================
echo "3. OLD DOCUMENTATION (Safe - you have CLAUDE.md):"
echo "   These are original Chatwoot docs you've replaced"
echo ""
# UNCOMMENT TO DELETE:
# rm -f CODE_OF_CONDUCT.md CONTRIBUTING.md SECURITY.md
# rm -f DEPLOYMENT_GUIDE.md DEVELOPMENT_GUIDE.md DNS_SETUP.md
# rm -f DOCKER_SUCCESS.md EASYPANEL_SETUP.md FIX_SSL_MOBILE.md
# rm -f GITHUB_EXPLAINED.md PRODUCTION_SETUP.md SETUP_INSTRUCTIONS.md TELEGRAM_SETUP.md
# echo "✅ Deleted old documentation"

# ============================================
# UNUSED SETUP SCRIPTS - Medium Risk
# ============================================
echo "4. UNUSED SETUP SCRIPTS (Check each before deleting):"
echo "   - quick-start.sh (alternative setup)"
echo "   - start-docker-dev.sh (old docker start)"
echo "   - setup-local.sh (local setup without docker)"
echo "   - complete-setup.sh (old setup)"
echo "   Keep: start-dev.sh, stop-dev.sh, restart-dev.sh"
echo ""
# UNCOMMENT TO DELETE (BE CAREFUL):
# rm -f quick-start.sh start-docker-dev.sh setup-local.sh
# rm -f setup-docker.sh setup-app.sh complete-setup.sh
# rm -f install-homebrew.sh start.sh stop.sh
# echo "✅ Deleted unused scripts"

# ============================================
# OLD DEPLOYMENT METHODS - Safe if Using Docker
# ============================================
echo "5. OLD DEPLOYMENT FOLDERS (Safe if using Docker):"
echo "   - deployment/ folder (Ubuntu systemd setup)"
echo "   - clevercloud/ (CleverCloud platform)"
echo "   - Procfile* (Heroku)"
echo "   IMPORTANT: Keep deploy/ folder!"
echo ""
# UNCOMMENT TO DELETE:
# rm -rf deployment/ clevercloud/
# rm -f Procfile* Capfile app.json
# echo "✅ Deleted old deployment methods"

# ============================================
# DEVELOPMENT TOOLS - Keep if Developing
# ============================================
echo "6. DEVELOPMENT TOOLS (Keep if you might code):"
echo "   - rubocop/ (Ruby linting)"
echo "   - .eslintrc.js (JavaScript linting)"
echo "   - .prettierrc.js (Code formatting)"
echo ""
# UNCOMMENT TO DELETE (if not coding):
# rm -rf rubocop/
# rm -f .rubocop.yml .codeclimate.yml .eslintrc.js .prettierrc.js
# echo "✅ Deleted dev tools"

# ============================================
# SUMMARY
# ============================================
echo "================================================"
echo "WHAT YOU SHOULD DEFINITELY KEEP:"
echo "================================================"
echo "✓ docker-compose.development.yml (your local dev)"
echo "✓ docker-compose.production-new.yml (your production)"
echo "✓ deploy/ folder (production scripts)"
echo "✓ start-dev.sh, stop-dev.sh, restart-dev.sh"
echo "✓ setup-ngrok.sh"
echo "✓ CLAUDE.md, TASKS.md, AGENTS.md"
echo "✓ .github/workflows/ (for auto-deploy)"
echo "✓ swagger/ (API documentation)"
echo ""
echo "TO RUN CLEANUP:"
echo "1. Review this script"
echo "2. Uncomment only sections you're sure about"
echo "3. Run: bash cleanup-safe.sh"
echo ""
echo "SAFEST APPROACH:"
echo "Start with just deleting old docker-compose files (Section 1)"
echo "Those are 100% safe to remove."