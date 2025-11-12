#!/bin/bash

# 💥 SUPER NUCLEAR INSTALLATION SCRIPT - BUILD 122 💥
# This is the MOST AGGRESSIVE cache-clearing method possible!

echo "========================================"
echo "💥 SUPER NUCLEAR INSTALL - Build 122"
echo "========================================"
echo ""
echo "⚠️  WARNING: This will:"
echo "   - Stop ALL apps"
echo "   - Clear ALL system caches"
echo "   - Wipe ALL app data"
echo "   - Clear Dalvik/ART cache"
echo "   - Clear package manager cache"
echo ""
read -p "Press ENTER to continue or Ctrl+C to cancel..."
echo ""

# Check if adb is available
if ! command -v adb &> /dev/null; then
    echo "❌ ERROR: adb not found!"
    exit 1
fi

# Check if device is connected
echo "🔍 Checking for connected devices..."
DEVICES=$(adb devices | grep -v "List" | grep "device" | wc -l)
if [ $DEVICES -eq 0 ]; then
    echo "❌ ERROR: No device connected!"
    exit 1
fi
echo "✅ Found device"
echo ""

echo "🛑 STEP 1: Killing ALL running apps..."
adb shell am kill-all
sleep 2
echo "✅ All apps killed"
echo ""

echo "🛑 STEP 2: Force stopping Eyejack..."
adb shell am force-stop com.eyejack.app
adb shell am force-stop com.eyejack.app
adb shell am force-stop com.eyejack.app
echo "✅ Force stopped (3x for good measure)"
echo ""

echo "🧹 STEP 3: Clearing ALL Eyejack data..."
adb shell pm clear com.eyejack.app
sleep 1
echo "✅ App data cleared"
echo ""

echo "🗑️  STEP 4: Uninstalling Eyejack..."
adb uninstall com.eyejack.app
sleep 1
echo "✅ App uninstalled"
echo ""

echo "💾 STEP 5: Clearing package manager cache (999GB)..."
adb shell pm trim-caches 999G
sleep 2
echo "✅ Package cache trimmed"
echo ""

echo "🔥 STEP 6: Clearing Dalvik/ART cache..."
adb shell rm -rf /data/dalvik-cache/*
adb shell rm -rf /cache/dalvik-cache/*
sleep 1
echo "✅ Dalvik cache cleared"
echo ""

echo "🧹 STEP 7: Clearing system cache..."
adb shell rm -rf /cache/*
sleep 1
echo "✅ System cache cleared"
echo ""

echo "🗑️  STEP 8: Removing ALL Eyejack residual files..."
adb shell rm -rf /data/data/com.eyejack.app
adb shell rm -rf /sdcard/Android/data/com.eyejack.app
adb shell rm -rf /data/app/com.eyejack.app*
sleep 1
echo "✅ All residual files removed"
echo ""

echo "⏸️  STEP 9: Waiting 5 seconds for system to settle..."
sleep 5
echo "✅ Ready to install"
echo ""

echo "📦 STEP 10: Installing Build 122 (v12.2.0 NO SPACER)..."
adb install "/Users/ssenterprises/Eyejack Native Application/Eyejack-v12.2.0-Build122-NO-SPACER.apk"
echo "✅ App installed!"
echo ""

echo "⏸️  STEP 11: Waiting for installation to settle..."
sleep 3
echo ""

echo "🚀 STEP 12: Launching app..."
adb shell am start -n com.eyejack.app/.MainActivity
echo "✅ App launched!"
echo ""

echo "========================================"
echo "✅ SUPER NUCLEAR INSTALL COMPLETE!"
echo "========================================"
echo ""
echo "📱 Version: v12.2.0 (Build 122)"
echo "🔥 EVERYTHING was wiped and reinstalled"
echo ""
echo "🎯 VERIFICATION:"
echo "   1. Open ANY collection page"
echo "   2. Green banner MUST say: 'v12.2.0 ULTRA TIGHT'"
echo ""
echo "❌ IF YOU STILL SEE v12.1.0:"
echo "   → Restart your phone NOW"
echo "   → Run this script again after reboot"
echo "   → This is a SYSTEM-LEVEL cache issue"
echo ""

