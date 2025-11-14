#!/bin/bash

echo "☢️  NUCLEAR EMULATOR REFRESH ☢️"
echo "==============================="
echo ""
echo "This will:"
echo "1. Reboot the emulator (clears ALL caches)"
echo "2. Wait for emulator to restart"
echo "3. Uninstall old app"
echo "4. Install Build 153 fresh"
echo "5. Launch the app"
echo ""
read -p "Press Enter to start..."

# Step 1: Reboot emulator
echo ""
echo "🔄 Step 1/5: Rebooting emulator..."
adb reboot
echo "   ⏳ Waiting for emulator to shut down..."
sleep 5

# Step 2: Wait for emulator to come back
echo ""
echo "⏳ Step 2/5: Waiting for emulator to restart..."
echo "   (This takes about 30-60 seconds...)"

# Wait for device to be back online
adb wait-for-device
echo "   ✅ Emulator is online!"

# Wait a bit more for it to fully boot
echo "   ⏳ Waiting for full boot..."
sleep 20

# Wait for boot to complete
while [ -z "$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" ]; do
    sleep 2
done
echo "   ✅ Emulator fully booted!"

# Step 3: Uninstall old app (if exists)
echo ""
echo "🗑️  Step 3/5: Removing old app..."
adb uninstall com.eyejack.app 2>/dev/null || echo "   (No previous app found)"

# Step 4: Install fresh
echo ""
echo "📦 Step 4/5: Installing Build 153..."
adb install "/Users/ssenterprises/Eyejack Native Application/eyejack_flutter_app/build/app/outputs/flutter-apk/app-release.apk"

if [ $? -eq 0 ]; then
    # Step 5: Verify and launch
    echo ""
    echo "✅ Step 5/5: Verifying and launching..."
    
    VERSION=$(adb shell dumpsys package com.eyejack.app | grep versionName | head -1)
    BUILD=$(adb shell dumpsys package com.eyejack.app | grep versionCode | head -1)
    
    echo "   $VERSION"
    echo "   $BUILD"
    
    echo ""
    echo "🚀 Launching app..."
    adb shell monkey -p com.eyejack.app -c android.intent.category.LAUNCHER 1 > /dev/null 2>&1
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✨ NUCLEAR REFRESH COMPLETE!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Build 153 is now running 100% fresh!"
    echo "ALL caches cleared (emulator rebooted)."
    echo ""
    echo "🧪 Test pagination now:"
    echo "   1. Open any collection"
    echo "   2. Scroll to bottom"
    echo "   3. Look for 'Load More Products' button"
    echo ""
else
    echo ""
    echo "❌ Installation failed!"
    exit 1
fi

