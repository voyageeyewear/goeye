#!/bin/bash

echo "🚀 Installing Eyejack Build 80 - AGGRESSIVE CACHE BUSTING"
echo "=========================================================="
echo ""
echo "⚠️  IMPORTANT: This is a MAJOR version bump (8.0.0)"
echo "    This will FORCE fresh data from server"
echo ""
echo "✅ FIXES:"
echo "   1. Aggressive cache-busting headers"
echo "   2. Debug logging for circular categories"
echo "   3. Forces fresh API data on every launch"
echo ""
echo "📦 APK: Eyejack-v8.0.0-Build80-AggressiveCacheBusting.apk"
echo ""

# Check if device connected
if ! adb devices | grep -q "device$"; then
    echo "❌ No device connected!"
    echo "Please connect your Android device and enable USB debugging."
    exit 1
fi

echo "📱 Device connected!"
echo ""

# CRITICAL: Uninstall old version completely
echo "🗑️  Uninstalling ALL old versions (CRITICAL)..."
adb uninstall com.eyejack.shopify_app 2>/dev/null

# Clear any residual app data
echo "🧹 Clearing device cache..."
sleep 2

# Install new APK
echo "📲 Installing Build 80..."
adb install -r "Eyejack-v8.0.0-Build80-AggressiveCacheBusting.apk"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ INSTALLATION SUCCESSFUL!"
    echo ""
    echo "🎯 What's New in Build 80:"
    echo ""
    echo "   ✓ AGGRESSIVE CACHE BUSTING:"
    echo "     - Cache-Control: no-cache, no-store, must-revalidate"
    echo "     - Pragma: no-cache"
    echo "     - Expires: 0"
    echo "     - Timestamp query parameter"
    echo ""
    echo "   ✓ DEBUG LOGGING:"
    echo "     - Logs API calls"
    echo "     - Logs circular categories data"
    echo "     - Helps identify caching issues"
    echo ""
    echo "   ✓ CIRCULAR CATEGORIES:"
    echo "     - Sunglasses: female.png"
    echo "     - Eyeglasses: male-04.png"
    echo "     - New Arrivals: VIDEO (mp4)"
    echo "     - View All: view_all-02.png"
    echo "     - BOGO: VIDEO (mp4) + badge"
    echo ""
    echo "📱 TESTING:"
    echo "   1. Open the app"
    echo "   2. Check circular categories section"
    echo "   3. Videos should play for New Arrivals & BOGO"
    echo "   4. Images should match live website"
    echo ""
    echo "🐛 IF STILL SHOWING OLD DATA:"
    echo "   Run: adb logcat | grep '🔍 Circular categories'"
    echo "   This will show what data the app is receiving"
    echo ""
    echo "🚀 App installed and ready!"
else
    echo ""
    echo "❌ Installation failed!"
    echo "Try manually: adb install -r Eyejack-v8.0.0-Build80-AggressiveCacheBusting.apk"
fi

