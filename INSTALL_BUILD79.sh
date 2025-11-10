#!/bin/bash

echo "🚀 Installing Eyejack Build 79 - RELIABLE VIDEOS + PERFECT CIRCLES"
echo "=================================================="
echo ""
echo "✅ FIXED ISSUES:"
echo "   1. Video reliability - proper buffering & state"
echo "   2. Perfect circular shapes - responsive on all screens"
echo ""
echo "📦 APK: Eyejack-v7.0.1-Build79-ReliableVideos-PerfectCircles.apk"
echo ""

# Check if device connected
if ! adb devices | grep -q "device$"; then
    echo "❌ No device connected!"
    echo "Please connect your Android device and enable USB debugging."
    exit 1
fi

echo "📱 Device connected!"
echo ""

# Uninstall old version
echo "🗑️  Uninstalling old version..."
adb uninstall com.eyejack.shopify_app 2>/dev/null
echo ""

# Install new APK
echo "📲 Installing Build 79..."
adb install -r "Eyejack-v7.0.1-Build79-ReliableVideos-PerfectCircles.apk"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ INSTALLATION SUCCESSFUL!"
    echo ""
    echo "🎯 What's Fixed:"
    echo "   ✓ Videos now load reliably with proper timeout"
    echo "   ✓ Better buffering and state management"
    echo "   ✓ Videos won't get stuck anymore"
    echo "   ✓ Circular sections now perfect circles"
    echo "   ✓ Responsive on all screen sizes"
    echo ""
    echo "🚀 Ready to test!"
else
    echo ""
    echo "❌ Installation failed!"
    echo "Try manually: adb install -r Eyejack-v7.0.1-Build79-ReliableVideos-PerfectCircles.apk"
fi

