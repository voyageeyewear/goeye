#!/bin/bash

# Goeye Database Setup Script
# This script helps you connect the PostgreSQL database on Railway

echo "🚀 Goeye Database Setup"
echo "========================"
echo ""

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "📦 Installing Railway CLI..."
    npm install -g @railway/cli
fi

echo "📋 Step 1: Add PostgreSQL to Railway"
echo "-------------------------------------"
echo "1. Go to: https://railway.app"
echo "2. Open your Goeye project"
echo "3. Click '+ New' → 'Database' → 'PostgreSQL'"
echo "4. Wait for provisioning (30-60 seconds)"
echo ""
read -p "Press Enter when PostgreSQL service is created..."

echo ""
echo "📋 Step 2: Link DATABASE_URL"
echo "-----------------------------"
echo "1. In Railway Dashboard, click on your middleware service (not Postgres)"
echo "2. Go to 'Variables' tab"
echo "3. Click 'New Variable'"
echo "4. Name: DATABASE_URL"
echo "5. Value: \${{Postgres.DATABASE_URL}}"
echo "   (Railway will auto-populate from Postgres service)"
echo "6. Click 'Add'"
echo ""
read -p "Press Enter when DATABASE_URL is added..."

echo ""
echo "📋 Step 3: Test Connection"
echo "----------------------------"
echo "Testing database connection..."
echo ""

cd shopify-middleware

# Try to test connection
if [ -f "scripts/testDatabaseConnection.js" ]; then
    echo "Running connection test..."
    node scripts/testDatabaseConnection.js
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Connection successful!"
        echo ""
        echo "📋 Step 4: Seed Database"
        echo "------------------------"
        read -p "Do you want to seed the database now? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Seeding database..."
            node scripts/seedDatabase.js
        fi
    else
        echo ""
        echo "❌ Connection failed. Please check:"
        echo "1. DATABASE_URL is set correctly in Railway"
        echo "2. PostgreSQL service is running"
        echo "3. Try again after a few seconds"
    fi
else
    echo "⚠️  Test script not found. Please check manually:"
    echo "   curl https://web-production-b0095.up.railway.app/health"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "🔍 Verify connection:"
echo "   curl https://web-production-b0095.up.railway.app/health"
echo ""
echo "The health endpoint should show: \"database\": \"Connected\""

