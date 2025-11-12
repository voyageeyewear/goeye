#!/bin/bash

echo "========================================="
echo "  FRESH INSTALL ON REAL DEVICE"
echo "========================================="
echo ""

# Check if device is connected
DEVICE_COUNT=$(adb devices | grep -v "List" | grep "device" | wc -l | tr -d ' ')

if [ "$DEVICE_COUNT" -eq "0" ]; then
    echo "❌ ERROR: No device connected!"
    echo ""
    echo "Please:"
    echo "1. Connect your phone via USB"
    echo "2. Enable USB debugging"
    echo "3. Allow USB debugging on your phone"
    echo ""
    exit 1
fi

echo "✅ Device found!"
echo ""

# Select specific device if multiple
if [ "$DEVICE_COUNT" -gt "1" ]; then
    echo "📱 Multiple devices found:"
    adb devices -l
    echo ""
    echo "⚠️  This script will install on ALL connected devices!"
    echo "   Press Ctrl+C to cancel, or Enter to continue..."
    read
fi

echo "🧹 STEP 1: Force stopping app..."
adb shell am force-stop com.eyejack.app
echo "✅ App stopped"
echo ""

echo "🧹 STEP 2: Clearing app data and cache..."
adb shell pm clear com.eyejack.app
echo "✅ Data cleared"
echo ""

echo "🧹 STEP 3: Uninstalling old app..."
adb uninstall com.eyejack.app
echo "✅ App uninstalled"
echo ""

echo "📦 STEP 4: Installing Build 113 (WORKING)..."
adb install "/Users/ssenterprises/Eyejack Native Application/Eyejack-v10.4.0-Build113-WORKING.apk"
echo "✅ App installed!"
echo ""

echo "🚀 STEP 5: Launching app..."
adb shell monkey -p com.eyejack.app 1
echo "✅ App launched!"
echo ""

echo "========================================="
echo "  ✅ FRESH INSTALL COMPLETE!"
echo "========================================="
echo ""
echo "Please test on your device:"
echo "1. Wait for splash screen (~8 seconds)"
echo "2. Navigate to any collection"
echo "3. Click 'ADD TO CART' button"
echo "4. Cart drawer should open immediately!"
echo ""

