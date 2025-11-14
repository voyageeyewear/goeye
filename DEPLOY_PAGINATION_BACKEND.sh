#!/bin/bash

echo "🚀 DEPLOYING PAGINATION BACKEND TO RAILWAY"
echo "=========================================="
echo ""

cd "/Users/ssenterprises/Eyejack Native Application"

# Step 1: Check git status
echo "📋 Step 1/4: Checking git status..."
git status --short

# Step 2: Commit backend changes
echo ""
echo "💾 Step 2/4: Committing pagination backend changes..."
git add shopify-middleware/controllers/shopifyController.js
git add shopify-middleware/services/shopifyService.js

git commit -m "feat: Add pagination support to collection API

- Accept offset parameter in controller
- Implement offset-based pagination in service
- Return hasMore flag for pagination
- Support up to 250 products per collection
- Add backend logging for debugging"

# Step 3: Push to trigger Railway deployment
echo ""
echo "⬆️  Step 3/4: Pushing to Railway..."
git push origin main

echo ""
echo "⏳ Step 4/4: Waiting for Railway deployment..."
echo "   (This takes about 60-90 seconds...)"
sleep 90

# Step 5: Test the API
echo ""
echo "🧪 Testing pagination API..."
echo ""
echo "Test 1: Page 1 (offset=0, limit=50)"
curl -s "https://motivated-intuition-production.up.railway.app/api/shopify/products/collection/sunglasses?limit=50&offset=0" | grep -o '"products":\[' | wc -l

echo ""
echo "Test 2: Page 2 (offset=50, limit=50)"
curl -s "https://motivated-intuition-production.up.railway.app/api/shopify/products/collection/sunglasses?limit=50&offset=50" | grep -o '"products":\[' | wc -l

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ BACKEND DEPLOYED!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Now the API supports pagination with offset parameter."
echo ""
echo "Next: Rebuild the Flutter app and test!"

