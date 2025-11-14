#!/bin/bash

echo "🔍 Checking Pagination Debug Logs"
echo "=================================="
echo ""
echo "📝 INSTRUCTIONS:"
echo "1. Open ANY collection in the app (Sunglasses, Eyeglasses, etc.)"
echo "2. Wait for products to load"
echo "3. Scroll to the bottom"
echo "4. Come back here and press Enter"
echo ""
read -p "Press Enter after opening a collection and scrolling to bottom..."
echo ""
echo "Fetching logs..."
echo ""

# API logs
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📡 API Response:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
adb logcat -d | grep "🔍 API Pagination" -A 4 | tail -20

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Collection Screen State:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
adb logcat -d | grep "📦 Loaded page" -A 5 | tail -20

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔘 Button Rendering:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
adb logcat -d | grep "🔘 Rendering Load More" | tail -10

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "ANALYSIS:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Look for these values:"
echo "  • Products received: Should be 50 or less"
echo "  • hasMore: Should be true if exactly 50 products"
echo "  • Should show button: Should be true if hasMore=true"
echo ""
echo "If 'Should show button: false', button won't appear!"
echo "If products < 50, button correctly doesn't appear (all loaded)"
echo ""

