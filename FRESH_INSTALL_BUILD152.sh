#!/bin/bash

echo "🧹 Fresh Install of Build 152 (Pagination)"
echo "=========================================="
echo ""

# Step 1: Force stop app
echo "1/5 Force stopping app..."
adb shell am force-stop com.eyejack.app 2>/dev/null

# Step 2: Clear all app data
echo "2/5 Clearing app data..."
adb shell pm clear com.eyejack.app 2>/dev/null

# Step 3: Uninstall completely
echo "3/5 Uninstalling app..."
adb uninstall com.eyejack.app 2>/dev/null

# Step 4: Install fresh
echo "4/5 Installing Build 152..."
adb install "/Users/ssenterprises/Eyejack Native Application/Eyejack-v12.22.0-Build152-PAGINATION.apk"

if [ $? -eq 0 ]; then
    echo "5/5 Verifying installation..."
    VERSION=$(adb shell dumpsys package com.eyejack.app | grep versionName | head -1)
    BUILD=$(adb shell dumpsys package com.eyejack.app | grep versionCode | head -1)
    
    echo ""
    echo "✅ Installation Complete!"
    echo "   $VERSION"
    echo "   $BUILD"
    
    echo ""
    echo "🚀 Launching app..."
    adb shell monkey -p com.eyejack.app -c android.intent.category.LAUNCHER 1 > /dev/null 2>&1
    
    echo ""
    echo "✨ Build 152 is now running fresh!"
    echo ""
    echo "🧪 Test pagination:"
    echo "   1. Open any collection (Sunglasses, Eyeglasses, etc.)"
    echo "   2. Scroll to bottom of products"
    echo "   3. Look for green 'Load More Products' button"
    echo "   4. Tap button to load next 50 products"
    echo ""
else
    echo ""
    echo "❌ Installation failed!"
    exit 1
fi

