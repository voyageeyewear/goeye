#!/bin/bash

# Fresh Install Script for Build 88
# Run this anytime you need to clear cache and reinstall

echo "🧹 Clearing app data and cache..."
adb shell pm clear com.eyejack.app

echo "🛑 Force stopping app..."
adb shell am force-stop com.eyejack.app

echo "🗑️  Uninstalling old version..."
adb uninstall com.eyejack.app

echo "📦 Installing Build 88 fresh..."
cd "/Users/ssenterprises/Eyejack Native Application"
adb install "Eyejack-v8.2.1-Build88-BiggerImages.apk"

echo "🚀 Launching app..."
adb shell monkey -p com.eyejack.app -c android.intent.category.LAUNCHER 1

echo ""
echo "✅ Fresh install complete!"
echo "📱 Build 88 is now running in your emulator"
echo ""
echo "🎯 Check these improvements:"
echo "   1. Bigger, well-proportioned banners"
echo "   2. 33% larger product images"
echo "   3. No loading spinners anywhere"
echo ""

