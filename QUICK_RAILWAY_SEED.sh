#!/bin/bash

echo "🚂 Running Seed Script on Railway..."
echo ""
echo "This will create tables and load data into Railway PostgreSQL"
echo ""

cd "/Users/ssenterprises/Eyejack Native Application/shopify-middleware"

# Check if railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found!"
    echo ""
    echo "Installing Railway CLI..."
    npm i -g @railway/cli
    echo ""
fi

echo "🔐 Logging in to Railway..."
railway login

echo ""
echo "🔗 Linking to project..."
railway link

echo ""
echo "🌱 Running seed script..."
railway run node scripts/seedDatabase.js

echo ""
echo "✅ Done! Now test:"
echo "curl https://motivated-intuition-production.up.railway.app/api/admin/sections"

