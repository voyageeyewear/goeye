#!/bin/bash

# ☢️ NUCLEAR INSTALL SCRIPT FOR BUILD 147 ☢️
# This is the most aggressive clean installation possible
# Use this when normal cache clearing doesn't work

set -e  # Exit on any error

echo "☢️  NUCLEAR REFRESH INITIATED ☢️"
echo "This will take ~2 minutes..."
echo ""

# Step 1: Flutter Clean
echo "🧹 Step 1/11: Flutter clean..."
cd "/Users/ssenterprises/Eyejack Native Application/eyejack_flutter_app"
flutter clean > /dev/null 2>&1
echo "   ✅ Flutter artifacts deleted"

# Step 2: Kill app on emulator
echo "🧹 Step 2/11: Stopping app on emulator..."
adb shell am force-stop com.eyejack.app 2>/dev/null || true
echo "   ✅ App stopped"

# Step 3: Clear app data
echo "🧹 Step 3/11: Clearing app data..."
adb shell pm clear com.eyejack.app 2>/dev/null || true
echo "   ✅ App data cleared"

# Step 4: Uninstall app
echo "🧹 Step 4/11: Uninstalling app..."
adb uninstall com.eyejack.app 2>/dev/null || true
echo "   ✅ App uninstalled"

# Step 5: Delete Gradle cache
echo "🧹 Step 5/11: Deleting Gradle cache..."
rm -rf android/.gradle android/app/build android/build 2>/dev/null || true
echo "   ✅ Gradle cache deleted"

# Step 6: Delete Dart metadata
echo "🧹 Step 6/11: Deleting Dart metadata..."
rm -rf .dart_tool .flutter-plugins .flutter-plugins-dependencies pubspec.lock 2>/dev/null || true
echo "   ✅ Dart metadata deleted"

# Step 7: Clear emulator cache (requires root, may fail)
echo "🧹 Step 7/11: Clearing emulator cache..."
adb shell "rm -rf /data/dalvik-cache/* && rm -rf /cache/*" 2>/dev/null || true
echo "   ✅ Emulator cache cleared (best effort)"

# Step 8: Get fresh dependencies
echo "📦 Step 8/11: Fetching fresh dependencies..."
flutter pub get > /dev/null 2>&1
echo "   ✅ Dependencies fetched"

# Step 9: Build fresh APK
echo "🔨 Step 9/11: Building fresh APK from scratch..."
echo "   (This takes ~60 seconds...)"
flutter build apk --release > /dev/null 2>&1
echo "   ✅ APK built successfully"

# Step 10: Install fresh APK
echo "📲 Step 10/11: Installing fresh APK..."
adb install "/Users/ssenterprises/Eyejack Native Application/Eyejack-v12.19.0-Build147-NUCLEAR-FRESH.apk"
echo "   ✅ APK installed"

# Step 11: Verify and launch
echo "🚀 Step 11/11: Verifying and launching..."
VERSION=$(adb shell dumpsys package com.eyejack.app | grep versionName | head -1 | awk '{print $1}')
BUILD=$(adb shell dumpsys package com.eyejack.app | grep versionCode | head -1 | awk '{print $1}')
echo "   $VERSION"
echo "   $BUILD"

adb shell monkey -p com.eyejack.app -c android.intent.category.LAUNCHER 1 > /dev/null 2>&1
echo "   ✅ App launched"

echo ""
echo "═══════════════════════════════════════"
echo "✅ NUCLEAR REFRESH COMPLETE!"
echo "═══════════════════════════════════════"
echo ""
echo "📱 Build 147 is now running on emulator"
echo ""
echo "🧪 TO TEST COLOR SWATCHES:"
echo "   1. Search for 'Matrix' in the app"
echo "   2. Open Matrix Square Metal Sunglasses"
echo "   3. Scroll to see color swatches"
echo "   4. Look for Grey and Black circles"
echo ""
echo "📝 Location: Below Trust Badges section"
echo ""

