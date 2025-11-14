# Build 147 - Cache Fix Applied ✅

## Issue
The emulator was loading the old app version (Build 146) instead of the new Build 147 with color swatches due to Android caching.

## Solution Applied

Performed a **complete clean installation** with the following steps:

### 1. Clear App Data
```bash
adb shell pm clear com.eyejack.app
```
- Removes all cached data, preferences, and files
- Resets app to fresh state

### 2. Force Stop App
```bash
adb shell am force-stop com.eyejack.app
```
- Ensures app is not running in background

### 3. Complete Uninstall
```bash
adb uninstall com.eyejack.app
```
- Removes app completely from device
- Clears all system caches

### 4. Fresh Install
```bash
adb install "Eyejack-v12.19.0-Build147-COLOR-SWATCHES.apk"
```
- Installs Build 147 from scratch

### 5. Verification
```bash
adb shell dumpsys package com.eyejack.app | grep "versionName\|versionCode"
```
Result:
- ✅ versionName=12.19.0
- ✅ versionCode=147

## Current Status

- **App Version**: 12.19.0
- **Build Number**: 147
- **Package**: com.eyejack.app
- **Status**: ✅ Running fresh on emulator
- **Features**: Color swatches enabled for Matrix products

## Quick Reinstall Script

Created `INSTALL_BUILD147_FRESH.sh` for easy reinstallation:

```bash
./INSTALL_BUILD147_FRESH.sh
```

This script automatically:
1. Clears all caches
2. Uninstalls old app
3. Installs Build 147
4. Verifies version
5. Launches app

## Testing Color Swatches

Now that Build 147 is fresh, test the color swatches:

1. **Open app** (already running on emulator)
2. **Search** for "Matrix"
3. **Select** either:
   - Matrix - Grey Square Metal Sunglasses
   - Matrix - Black Square Metal Sunglasses
4. **Look for** color swatches below Trust Badges section
5. **Verify**:
   - 2 circular color swatches (Grey and Black)
   - Selected color has green border + checkmark
   - Unselected color has grey border
   - Tap to see switch notification

## Avoiding Cache Issues

For future builds, always use the fresh install script or run:
```bash
adb uninstall com.eyejack.app && adb install [NEW_APK_PATH]
```

## Files
- APK: `Eyejack-v12.19.0-Build147-COLOR-SWATCHES.apk`
- Script: `INSTALL_BUILD147_FRESH.sh`
- Docs: `BUILD147_COLOR_SWATCHES.md`

---

**Cache cleared**: November 14, 2025
**Fresh install**: ✅ Successful
**App running**: ✅ Yes

