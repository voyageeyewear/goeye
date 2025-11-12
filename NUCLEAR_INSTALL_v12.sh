#!/bin/bash

# 🔥 NUCLEAR INSTALLATION SCRIPT FOR BUILD 121 - v12.1.0 🔥
# This script will COMPLETELY REMOVE all traces of the old app
# BUILD 121 includes VISIBLE DEBUG BANNERS to verify which version is running!

echo "===================================="
echo "🔥 NUCLEAR INSTALL - v12.1.0 DEBUG"
echo "===================================="
echo ""

# Check if adb is available
if ! command -v adb &> /dev/null; then
    echo "❌ ERROR: adb not found!"
    echo "Please make sure Android SDK platform-tools is in your PATH"
    exit 1
fi

# Check if device is connected
echo "🔍 Checking for connected devices..."
DEVICES=$(adb devices | grep -v "List" | grep "device" | wc -l)

if [ $DEVICES -eq 0 ]; then
    echo "❌ ERROR: No device connected!"
    echo "Please connect your device and enable USB debugging"
    exit 1
fi

echo "✅ Found $DEVICES connected device(s)"
echo ""

echo "🛑 STEP 1: Force stopping app..."
adb shell am force-stop com.eyejack.app
echo "✅ App force stopped"
echo ""

echo "🧹 STEP 2: Clearing ALL app data..."
adb shell pm clear com.eyejack.app
echo "✅ All app data cleared"
echo ""

echo "🗑️  STEP 3: Uninstalling app completely..."
adb uninstall com.eyejack.app
echo "✅ App uninstalled"
echo ""

echo "💾 STEP 4: Clearing package manager cache..."
adb shell pm trim-caches 999G
echo "✅ Cache trimmed"
echo ""

echo "📦 STEP 5: Installing v12.1.0 Build 121 (WITH DEBUG BANNERS)..."
adb install -r "/Users/ssenterprises/Eyejack Native Application/Eyejack-v12.1.0-Build121-WITH-DEBUG-BANNER.apk"
echo "✅ App installed!"
echo ""

echo "🚀 STEP 6: Launching app..."
adb shell am start -n com.eyejack.app/.MainActivity
echo "✅ App launched!"
echo ""

echo "===================================="
echo "✅ NUCLEAR INSTALL COMPLETE!"
echo "===================================="
echo ""
echo "📱 Version: v12.1.0 (Build 121)"
echo "🔥 This is a COMPLETELY FRESH install"
echo "📋 All old data has been wiped"
echo ""
echo "🎯 HOW TO VERIFY IT'S THE NEW VERSION:"
echo "   1. Open any collection page in the app"
echo "   2. Look for a GREEN BANNER at the top"
echo "   3. It should say: '🔥 v12.1.0 DEBUG BUILD'"
echo ""
echo "❌ If you DON'T see the green banner:"
echo "   → You're running the OLD cached version!"
echo "   → Restart your phone and re-run this script"
echo ""

