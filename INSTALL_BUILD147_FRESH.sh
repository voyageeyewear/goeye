#!/bin/bash

# Fresh Install Script for Build 147 - Color Swatches
# This script completely removes the old app and installs Build 147 fresh

echo "🧹 Cleaning old installation..."

# Force stop the app
adb shell am force-stop com.eyejack.app 2>/dev/null

# Clear app data
adb shell pm clear com.eyejack.app 2>/dev/null

# Uninstall completely
adb uninstall com.eyejack.app 2>/dev/null

echo "📦 Installing Build 147 (Color Swatches)..."

# Install fresh APK
adb install "/Users/ssenterprises/Eyejack Native Application/Eyejack-v12.19.0-Build147-COLOR-SWATCHES.apk"

if [ $? -eq 0 ]; then
    echo "✅ Build 147 installed successfully!"
    
    # Verify version
    echo ""
    echo "📋 Installed version:"
    adb shell dumpsys package com.eyejack.app | grep "versionName\|versionCode" | head -2
    
    echo ""
    echo "🚀 Launching app..."
    adb shell monkey -p com.eyejack.app -c android.intent.category.LAUNCHER 1 > /dev/null 2>&1
    
    echo ""
    echo "✨ Done! App is running on emulator."
    echo ""
    echo "🧪 To test color swatches:"
    echo "   1. Search for 'Matrix' in the app"
    echo "   2. Open any Matrix Square Metal Sunglasses product"
    echo "   3. Look for color swatches below Trust Badges section"
    echo "   4. See Grey and Black circular swatches"
else
    echo "❌ Installation failed!"
    exit 1
fi

