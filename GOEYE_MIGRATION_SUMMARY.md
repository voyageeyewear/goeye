# Goeye Migration Summary

This document summarizes all the changes made to convert the EyeJack project to Goeye.

## ✅ Completed Changes

### 1. Branding Updates
- ✅ Replaced all "Eyejack"/"EyeJack"/"EYEJACK" references with "Goeye"/"Goeye"/"GOEYE"
- ✅ Updated all URLs:
  - `eyejack.in` → `goeye.in`
  - `www.eyejack.in` → `www.goeye.in`
  - `eyejack1907.myshopify.com` → `goeyee.myshopify.com`

### 2. Project Structure
- ✅ Renamed Flutter app folder: `eyejack_flutter_app` → `goeye_flutter_app`
- ✅ Updated package names:
  - Android: `com.eyejack.app` → `com.goeye.app`
  - iOS: `com.eyejack.eyejackShopifyApp` → `com.goeye.app`
- ✅ Updated app labels: "Eyejack" → "Goeye"

### 3. Shopify Credentials
- ✅ Created `.env.example` with Goeye credentials (placeholders):
  - Store Domain: `goeyee.myshopify.com`
  - Admin API: `shpat_xxxxxxxxxxxxxxxxxxxxx` (replace with your actual token)
  - Storefront API: `xxxxxxxxxxxxxxxxxxxxxxx` (replace with your actual token)
  - API Version: `2025-01`

### 4. Theme API Integration
- ✅ Added Shopify Theme API integration to fetch real theme sections
- ✅ Implemented fallback mechanism if theme API fails
- ✅ Updated fallback sections with Goeye branding

### 5. Configuration Files
- ✅ Updated `package.json` files (root and middleware)
- ✅ Updated `pubspec.yaml` with Goeye branding
- ✅ Updated Android `build.gradle.kts` with new package name
- ✅ Updated iOS `Info.plist` and `project.pbxproj` with new bundle identifier
- ✅ Updated Kotlin file paths to match new package structure

### 6. Documentation
- ✅ Updated main `README.md` with Goeye branding
- ✅ Updated middleware `README.md`
- ✅ Created this migration summary

## 📋 Next Steps

### 1. Create Environment File
Create a `.env` file in `shopify-middleware/` directory:

```bash
cd shopify-middleware
cp .env.example .env
```

Or manually create `.env` with:
```env
SHOPIFY_STORE_DOMAIN=goeyee.myshopify.com
SHOPIFY_ADMIN_ACCESS_TOKEN=shpat_xxxxxxxxxxxxxxxxxxxxx
SHOPIFY_STOREFRONT_ACCESS_TOKEN=xxxxxxxxxxxxxxxxxxxxxxx
SHOPIFY_API_VERSION=2025-01
PORT=3000
NODE_ENV=development
```
**Note**: Replace the placeholder tokens with your actual Shopify API credentials.

### 2. Test Theme API Integration
The app now attempts to fetch theme sections from Shopify Theme API. If your Goeye store has a custom theme with sections, they will be automatically used. If not, it falls back to hardcoded sections.

To verify theme API is working:
1. Start the backend: `cd shopify-middleware && npm start`
2. Test the endpoint: `curl http://localhost:3000/api/shopify/theme-sections`
3. Check the logs for theme API fetch status

### 3. Update Theme Section URLs (If Needed)
If your Goeye store uses different image URLs or CDN paths than EyeJack, you may need to update the fallback sections in:
- `shopify-middleware/services/shopifyService.js`

Look for hardcoded URLs in the fallback sections (around line 110-300) and update them to match your Goeye store's CDN URLs.

### 4. Update Color Scheme (Optional)
If you want to change the brand colors from the current blue (#52b1e2), you can:
1. Update colors in fallback sections in `shopifyService.js`
2. Or configure them through the admin dashboard if PostgreSQL is set up

### 5. Install Dependencies
```bash
# Backend
cd shopify-middleware
npm install

# Flutter App
cd ../goeye_flutter_app
flutter pub get
```

### 6. Test the App
```bash
# Start backend
cd shopify-middleware
npm start

# Run Flutter app (in another terminal)
cd goeye_flutter_app
flutter run
```

## 🎨 Theme API Details

The theme API integration works as follows:

1. **Primary Method**: Fetches sections from Shopify Theme API
   - Gets active theme ID
   - Fetches `templates/index.json` which contains section order
   - Extracts section settings from theme template
   - Returns formatted sections array

2. **Fallback Method**: Uses hardcoded sections
   - If theme API fails or returns no sections
   - Uses predefined sections matching Goeye branding
   - Fetches collections and products from Shopify Storefront API

## 📝 Important Notes

- **Package Name**: The Android package name is now `com.goeye.app`. If you're updating an existing app, you'll need to uninstall the old app first, or change the package name in `build.gradle.kts`.

- **iOS Bundle ID**: Updated to `com.goeye.app`. Make sure this matches your Apple Developer account configuration if you plan to publish to the App Store.

- **Environment Variables**: The `.env` file is gitignored. Always use `.env.example` as a template and create your own `.env` file locally.

- **Theme Sections**: The theme API will automatically fetch your Goeye store's theme sections. Make sure your Shopify store has an active theme with sections defined.

## 🚀 Deployment

For production deployment (Railway, Heroku, etc.), set the following environment variables:
- `SHOPIFY_STORE_DOMAIN`
- `SHOPIFY_ADMIN_ACCESS_TOKEN`
- `SHOPIFY_STOREFRONT_ACCESS_TOKEN`
- `SHOPIFY_API_VERSION`
- `PORT`

## 📞 Support

If you encounter any issues:
1. Check that all environment variables are set correctly
2. Verify Shopify API credentials have proper permissions
3. Check theme API endpoint access (requires Admin API access)
4. Review backend logs for detailed error messages

---

**Migration completed on**: $(date)
**Project**: Goeye Native Application
**Store**: www.goeye.in (goeyee.myshopify.com)

