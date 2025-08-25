#!/bin/bash

echo "========================================="
echo "Ngrok Setup for Chatwoot Telegram Testing"
echo "========================================="
echo ""

# Check if ngrok is installed
if [ ! -f "./ngrok" ]; then
    echo "❌ Ngrok not found. Installing..."
    curl -o ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-arm64.zip
    unzip -o ngrok.zip
    rm ngrok.zip
    chmod +x ngrok
    echo "✅ Ngrok installed"
fi

echo ""
echo "📝 You need a free ngrok account to continue."
echo ""
echo "Steps:"
echo "1. Go to: https://dashboard.ngrok.com/signup"
echo "2. Sign up for a free account"
echo "3. Get your authtoken from: https://dashboard.ngrok.com/get-started/your-authtoken"
echo "4. Run: ./ngrok config add-authtoken YOUR_TOKEN_HERE"
echo ""
echo "After adding your token, run:"
echo "  ./start-ngrok.sh"
echo ""
echo "This will give you a public URL for your local Chatwoot!"