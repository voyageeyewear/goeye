#!/bin/bash

echo "📱 Checking Build 149 Debug Logs..."
echo "=================================="
echo ""
echo "Filtering for Color Swatch debug messages..."
echo ""

adb logcat -d | grep "🎨 Color Swatch" -A 6

echo ""
echo "=================================="
echo ""
echo "If you see debug messages above, that's good!"
echo "If not, the widget might not be loading on that product."

