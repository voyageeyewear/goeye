#!/bin/bash

# Goeye APK Installation Script
# This script installs the Goeye app APK on a connected Android emulator

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
ADB_PATH="/Users/dhruv/Library/Android/sdk/platform-tools/adb"

echo "🔍 Checking for connected devices..."
DEVICES=$($ADB_PATH devices | grep "device$" | wc -l | tr -d ' ')

if [ "$DEVICES" -eq 0 ]; then
    echo "❌ No Android emulator detected!"
    echo ""
    echo "Please:"
    echo "1. Open Android Studio"
    echo "2. Go to Tools > Device Manager"
    echo "3. Start an Android emulator"
    echo "4. Wait for it to fully boot"
    echo "5. Run this script again: bash install_apk.sh"
    exit 1
fi

echo "✅ Found $DEVICES device(s)"
echo ""
echo "📦 Installing Goeye APK (v1.2.0)..."
$ADB_PATH install -r "$APK_PATH"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ APK installed successfully!"
    echo ""
    echo "🚀 Launching Goeye app..."
    $ADB_PATH shell am start -n com.goeye.app/.MainActivity
    echo ""
    echo "✨ Goeye app should now be open on your emulator!"
else
    echo ""
    echo "❌ Installation failed. Please check the error message above."
    exit 1
fi

