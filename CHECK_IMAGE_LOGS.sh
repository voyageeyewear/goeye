#!/bin/bash

echo "📸 Checking Image/Thumbnail Debug Logs..."
echo "==========================================="
echo ""
echo "Instructions:"
echo "1. Open ANY product in your app"
echo "2. Wait 2 seconds"
echo "3. Run this script"
echo ""
read -p "Press Enter after opening a product..."
echo ""
echo "Fetching logs..."
echo ""

# Get image debug logs
adb logcat -d | grep "📸 Product Images" -A 20

echo ""
echo "-------------------------------------------"
echo ""

# Get thumbnail logs
adb logcat -d | grep "🖼️ Rendering thumbnail" | tail -20

echo ""
echo "==========================================="
echo ""
echo "Analysis:"
echo "- 'Total Images:' shows how many images Shopify sent"
echo "- 'Rendering thumbnail' shows which thumbnails were displayed"
echo "- If numbers don't match, there's a display issue"
echo ""

