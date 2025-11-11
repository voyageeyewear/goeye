#!/bin/bash

echo "🚂 Railway Database Setup Script"
echo "=================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}📋 You need to get your DATABASE_URL from Railway:${NC}"
echo ""
echo "1. Go to: https://railway.app"
echo "2. Open your project (Motivated Intuition)"
echo "3. Click on 'PostgreSQL' service"
echo "4. Go to 'Variables' tab"
echo "5. Copy the 'DATABASE_URL' value"
echo ""
echo -e "${GREEN}Paste your DATABASE_URL here and press Enter:${NC}"
read -r DATABASE_URL

if [ -z "$DATABASE_URL" ]; then
    echo "❌ No DATABASE_URL provided. Exiting."
    exit 1
fi

echo ""
echo "✅ DATABASE_URL received!"
echo ""

# Export for current session
export DATABASE_URL="$DATABASE_URL"

# Navigate to middleware directory
cd "/Users/ssenterprises/Eyejack Native Application/shopify-middleware"

# Run seed script
echo "🌱 Running seed script..."
echo ""

node scripts/seedDatabase.js

echo ""
echo "🎉 Done! Now test:"
echo "curl https://motivated-intuition-production.up.railway.app/api/admin/sections"

