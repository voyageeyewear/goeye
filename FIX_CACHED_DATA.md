# Fix Cached Data - Images Not Showing

## ✅ Good News: Backend is Working!

The API is now returning image URLs correctly:
```
https://cdn.shopify.com/s/files/1/0583/8831/6208/files/TR6601-CL66-1.jpg
```

## ⚠️ Problem: App Cached Old Data

Your app downloaded the old data (without images) and cached it. The app doesn't know the backend changed.

---

## 🔧 Solution 1: Pull to Refresh (Easiest)

**On your phone:**

1. Open the Goeye app
2. On the home screen, **swipe down** (pull to refresh)
3. The app should reload all data
4. Images should now appear!

---

## 🔧 Solution 2: Clear App Data (If pull-to-refresh doesn't work)

**On your phone:**

1. **Force Close App:**
   - Recent Apps button
   - Swipe away Goeye app

2. **Clear App Data:**
   - Settings → Apps → Goeye Eyewear
   - Storage → **Clear Data** (NOT just Clear Cache!)
   - Confirm

3. **Reopen App:**
   - Launch Goeye app
   - Wait for home screen to load
   - Images should appear!

---

## 🔧 Solution 3: Reinstall (Nuclear option)

If above doesn't work:

1. **Uninstall app completely**
2. **Restart phone**
3. **Reinstall:** `Goeye-v2.0.0-Build21-AllFixed.apk`

---

## ✅ What You Should See After Refresh:

### Eyeglasses Section:
```
┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│   [IMAGE]   │ │   [IMAGE]   │ │   [IMAGE]   │ │   [IMAGE]   │
│  Eyeglasses │ │  Eyeglasses │ │  Eyeglasses │ │  Eyeglasses │
│   on model  │ │   on model  │ │   on model  │ │   on model  │
└─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘
     Men            Women           Sale           Unisex
```

### Sunglasses Section:
```
┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│   [IMAGE]   │ │   [IMAGE]   │ │   [IMAGE]   │ │   [IMAGE]   │
│  Sunglasses │ │  Sunglasses │ │  Sunglasses │ │  Sunglasses │
│   on model  │ │   on model  │ │   on model  │ │   on model  │
└─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘
     Men            Women           Sale           Unisex
```

---

## 🧪 Test the Backend (From Computer)

You can verify the backend is working by opening this in your computer's browser:

```
http://localhost:3000/api/shopify/theme-sections
```

Search for "gender-categories-eyeglasses" and you should see image URLs like:
```json
{
  "name": "Men Eyeglasses",
  "label": "Men",
  "handle": "eyeglasses",
  "image": "https://cdn.shopify.com/s/files/1/0583/8831/6208/files/TR6601-CL66-1.jpg?v=1745667905"
}
```

---

## 💡 Why This Happens

1. **First Load:**
   - App fetches data from backend
   - Backend had no images (old code)
   - App saves this data in cache

2. **Backend Updated:**
   - You updated backend code
   - Backend now returns images
   - But app still uses old cached data

3. **Solution:**
   - App needs to re-fetch data
   - Pull-to-refresh triggers new API call
   - New data (with images) replaces old cache

---

## 📱 Pull-to-Refresh Instructions

**Detailed Steps:**

1. **Open App:**
   - Launch Goeye Eyewear

2. **Go to Home Screen:**
   - If you're on a product page, go back to home
   - You should see the hero slider at top

3. **Pull Down:**
   - Place finger at top of screen (below header)
   - Drag finger down slowly
   - You'll see a loading indicator appear
   - Release when you see the circular loading icon

4. **Wait:**
   - Screen will show loading spinner
   - App is fetching fresh data from backend
   - Should take 2-5 seconds

5. **Check:**
   - Scroll down to "Eyeglasses" section
   - Men/Women/Sale/Unisex cards should now show images!

---

## 🔍 Troubleshooting

### Pull-to-refresh doesn't work:
- Make sure you're on the home screen
- Try pulling from just below the header
- Pull slowly and release when icon appears

### Still no images after pull-to-refresh:
- Clear app data (Solution 2)
- Make sure backend server is running on your computer
- Check if phone and computer are on same WiFi network

### Images show briefly then disappear:
- This means images are loading but failing
- Check image URLs in backend response
- Verify Shopify CDN URLs are accessible

---

## 🌐 Network Requirements

**Important:**
- Backend server must be running on your computer
- Phone and computer must be on **same WiFi network**
- API Config should point to your computer's IP (not localhost)

**Check API Config:**
```dart
// goeye_flutter_app/lib/config/api_config.dart
static const String baseUrl = 'http://192.168.X.X:3000'; // Your computer's IP
```

---

## ✅ Success Indicators

After pull-to-refresh, you should have:
- ✅ 4 image cards under "Eyeglasses" (Men, Women, Sale, Unisex)
- ✅ 4 image cards under "Sunglasses" (Men, Women, Sale, Unisex)
- ✅ All 8 cards show actual eyewear product images
- ✅ No grey boxes

---

**Try pull-to-refresh first - it's the easiest solution!** 🔄

---

*Backend server is running and returning images correctly*  
*App just needs to refresh its cached data*

