#!/bin/bash

echo "🔥 NUCLEAR CLEAN BUILD - Eyejack v12.10.0 (Build 138)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "This will completely remove all caches and rebuild from scratch"
echo ""

cd "/Users/ssenterprises/Eyejack Native Application/eyejack_flutter_app"

# Step 1: Clean Flutter
echo "🧹 Step 1/6: Cleaning Flutter build cache..."
flutter clean
rm -rf build/
rm -rf .dart_tool/

# Step 2: Clean Gradle
echo "🧹 Step 2/6: Cleaning Gradle cache..."
cd android
./gradlew clean
cd ..

# Step 3: Remove Gradle caches completely
echo "🧹 Step 3/6: Removing all Gradle caches..."
rm -rf ~/.gradle/caches/
rm -rf android/.gradle/
rm -rf android/app/build/

# Step 4: Get fresh dependencies
echo "📦 Step 4/6: Getting fresh dependencies..."
flutter pub get

# Step 5: Uninstall old app from device
echo "🗑️  Step 5/6: Uninstalling old app from device..."
adb uninstall com.eyejack.shopify_app 2>/dev/null
# Also clear app data if somehow still there
adb shell pm clear com.eyejack.shopify_app 2>/dev/null

# Step 6: Build fresh release APK
echo "🔨 Step 6/6: Building FRESH release APK..."
echo "This will take a few minutes..."
flutter build apk --release

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Fresh APK built successfully!"
    echo ""
    
    # Copy to root with timestamp
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    cp build/app/outputs/flutter-apk/app-release.apk \
       "../Eyejack-v12.10.0-Build138-FRESH-${TIMESTAMP}.apk"
    
    echo "📦 Installing FRESH APK..."
    adb install -r "build/app/outputs/flutter-apk/app-release.apk"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "✅ NUCLEAR CLEAN INSTALL COMPLETE!"
        echo ""
        echo "🎯 IMPORTANT: Clear app data on device too!"
        echo ""
        echo "On your Android device:"
        echo "1. Open Settings → Apps → Eyejack"
        echo "2. Tap 'Storage'"
        echo "3. Tap 'Clear Data' and 'Clear Cache'"
        echo "4. Then open the app"
        echo ""
        echo "OR run this command:"
        echo "adb shell pm clear com.eyejack.shopify_app"
        echo ""
        echo "🎉 Your changes should now be visible!"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    else
        echo ""
        echo "❌ Installation failed!"
        exit 1
    fi
else
    echo ""
    echo "❌ Build failed!"
    exit 1
fi

