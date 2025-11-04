# EyeJack Native Application

A complete Flutter-based e-commerce mobile application for EyeJack eyewear store, integrated with Shopify Storefront API and featuring a sophisticated lens customization wizard with modern BoAt-style UI.

## 🎯 Project Overview

EyeJack Native Application is a full-featured mobile e-commerce app that replicates the functionality of the live EyeJack Shopify store (www.eyejack.in) with enhanced mobile-first user experience. The app includes real-time product synchronization, custom lens selection wizard, cart management, and seamless checkout integration.

## 📦 Latest Release

**Version:** 6.0.1 (Build 61)  
**Release Date:** November 5, 2024  
**APK:** `Eyejack-v6.0.1-BoatStyle-Build61.apk` (52MB)

### What's New in v6.0.1
- ✅ **BoAt-Style Product Page**: Modern two-button layout (Add To Cart + Select Lens)
- ✅ **Enhanced Price Display**: Price with discount badge and tax information
- ✅ **4 New Homepage Sections**: Feature highlights, statistics, video demo, FAQ
- ✅ **Real Lens Products**: Step 3 shows actual products from Shopify
- ✅ **Railway Deployment**: All backend updates deployed to production

## ✨ Key Features

### 🏪 E-Commerce Functionality
- ✅ **Shopify Integration**: Full integration with Shopify Storefront API v2025-01
- ✅ **Dynamic Home Screen**: Real-time product collections, banners, and promotional content
- ✅ **Hero Slider**: Image and video carousel with smooth playback (BoxFit.contain for no cropping)
- ✅ **Product Details**: Complete product information with variant selection and breadcrumbs
- ✅ **In-App Navigation**: All collection/product links navigate within app (no external browser)
- ✅ **Search Functionality**: Product search with icon in header
- ✅ **Smart Cart Management**: Add multiple items (lens + frame) in single transaction
- ✅ **Cart Drawer**: Full-featured cart with item management
- ✅ **Checkout Integration**: Seamless Gokwik checkout integration

### 🎨 UI/UX Features
- ✅ **BoAt-Style Product Page**: Modern sticky cart with two buttons side by side
- ✅ **Price Display**: Large price with discount badge and "Inclusive of all taxes"
- ✅ **Dual Action Buttons**: "Add To Cart" (black) + "Select Lens" (green)
- ✅ **Modern Product Page**: FireLens-inspired design with clean layouts
- ✅ **Homepage Sections**: 4 beautiful sections at bottom (Features, Stats, Video, FAQ)
- ✅ **Centered Logo**: Eyejack logo centered in header
- ✅ **Announcement Bars**: Unified blue color (#52b1e2) with smaller height (32px)
- ✅ **Moving USP Strip**: Scrolling trust badges (COD, Easy EMI, Easy Return, Support)
- ✅ **Gender Categories**: Image-based category cards for Men/Women/Sale/Unisex
- ✅ **Frame Measurements**: Auto-extracted from product descriptions (lens/bridge/temple)
- ✅ **Collapsible Product Description**: Better mobile readability
- ✅ **Clickable Breadcrumbs**: Navigate back through categories
- ✅ **Enhanced Image Gallery**: Image counter overlay with green-highlighted thumbnails

### 👓 Lens Customization
- ✅ **4-Step Lens Selector**: Intuitive lens customization wizard with modern UI
  - Step 1: Lens Type (Single Vision / Zero Power / Frame Only)
  - Step 2: Power Type (Anti-glare / Blue Block / Colour Lenses)
  - Step 3: **Real Lens Products** from Shopify (filtered by type, same as www.eyejack.in)
  - Step 4: Prescription Entry (Upload / Manual / Email Later)
- ✅ **Enhanced Step Indicators**: Circular badges with connecting lines and active shadows
- ✅ **Modern Header**: Large title, step counter, styled close button
- ✅ **Smart Categorization**: Automatic lens categorization by type
- ✅ **Cart Properties**: Prescription and lens info attached to cart items
- ✅ **Real Product Data**: Fetches actual lens products from Shopify API

### 🚀 Performance & Optimization
- ✅ **Cache-Busting**: Timestamp-based API requests for fresh data
- ✅ **Image Caching**: CachedNetworkImage for all product images
- ✅ **Memory Management**: Single video controller prevents crashes
- ✅ **Debug Logging**: Comprehensive logging for troubleshooting
- ✅ **Error Handling**: User-friendly error messages with retry options

## 📱 Tech Stack

### Frontend (Mobile App)
- **Framework**: Flutter 3.9.0
- **Language**: Dart
- **State Management**: Provider pattern
- **Key Packages**:
  - `http`: API communication
  - `provider`: State management
  - `cached_network_image`: Image caching and loading
  - `flutter_carousel_widget`: Carousel/slider functionality
  - `video_player` + `chewie`: Video playback
  - `url_launcher`: External links (Instagram, etc.)

### Backend (Middleware)
- **Runtime**: Node.js 18.x
- **Framework**: Express.js
- **API Integration**: Shopify Storefront API (GraphQL)
- **Deployment**: Railway (Production)
- **Key Libraries**:
  - `axios`: HTTP client
  - `dotenv`: Environment management
  - `cors`: Cross-origin resource sharing

### Infrastructure
- **Production Backend**: https://motivated-intuition-production.up.railway.app
- **Shopify Store**: eyejack1907.myshopify.com (www.eyejack.in)
- **CDN**: Shopify CDN for all images
- **API Version**: 2025-01

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│         Flutter Mobile App              │
│  ┌───────────────────────────────────┐  │
│  │  UI Layer (Screens & Widgets)     │  │
│  │  - Home Screen (sections)         │  │
│  │  - Product Details (breadcrumbs)  │  │
│  │  - Collection Screen              │  │
│  │  - Lens Selector (4 steps)        │  │
│  │  - Cart Drawer                    │  │
│  └───────────────────────────────────┘  │
│  ┌───────────────────────────────────┐  │
│  │  Business Logic (Providers)       │  │
│  │  - ShopProvider                   │  │
│  └───────────────────────────────────┘  │
│  ┌───────────────────────────────────┐  │
│  │  Data Layer (API Service)         │  │
│  │  - Cache-busting timestamps       │  │
│  │  - API calls to Railway           │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
                   ▼
         HTTP (JSON) - REST API
                   ▼
┌─────────────────────────────────────────┐
│      Railway Cloud (Production)         │
│      Node.js Middleware (Express)       │
│  ┌───────────────────────────────────┐  │
│  │  Routes                           │  │
│  │  - /api/shopify/*                 │  │
│  └───────────────────────────────────┘  │
│  ┌───────────────────────────────────┐  │
│  │  Controllers                      │  │
│  │  - shopifyController.js           │  │
│  └───────────────────────────────────┘  │
│  ┌───────────────────────────────────┐  │
│  │  Services                         │  │
│  │  - shopifyService.js              │  │
│  │  - Theme sections builder         │  │
│  │  - Lens categorization            │  │
│  │  - Cart management                │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
                   ▼
         GraphQL (Shopify Storefront API)
                   ▼
┌─────────────────────────────────────────┐
│       Shopify Store Backend             │
│       (eyejack1907.myshopify.com)       │
│       www.eyejack.in (Live Store)       │
└─────────────────────────────────────────┘
```

## 📂 Project Structure

```
Eyejack Native Application/
├── eyejack_flutter_app/           # Flutter mobile application
│   ├── lib/
│   │   ├── config/
│   │   │   └── api_config.dart    # Railway production URL
│   │   ├── models/
│   │   │   ├── product_model.dart # Product data models
│   │   │   ├── collection_model.dart
│   │   │   └── section_model.dart
│   │   ├── providers/
│   │   │   └── shop_provider.dart # State management
│   │   ├── screens/
│   │   │   ├── home_screen.dart   # Main home screen
│   │   │   ├── product_detail_screen.dart # Product page
│   │   │   ├── collection_screen.dart
│   │   │   └── search_screen.dart
│   │   ├── services/
│   │   │   ├── api_service.dart   # API calls (cache-busting)
│   │   │   └── gokwik_service.dart
│   │   ├── widgets/
│   │   │   ├── hero_slider_widget.dart    # Video/image carousel
│   │   │   ├── announcement_bars_widget.dart
│   │   │   ├── gender_categories_widget.dart
│   │   │   ├── lens_selector_drawer.dart  # 4-step wizard
│   │   │   ├── sticky_cart_widget.dart
│   │   │   ├── cart_drawer.dart
│   │   │   └── [15+ other widgets]
│   │   └── main.dart              # App entry point
│   ├── android/                   # Android build config
│   └── pubspec.yaml               # Flutter dependencies
│
├── shopify-middleware/            # Node.js backend
│   ├── controllers/
│   │   └── shopifyController.js   # Request handlers
│   ├── routes/
│   │   └── shopify.js             # API routes
│   ├── services/
│   │   └── shopifyService.js      # Shopify API logic
│   ├── server.js                  # Express server
│   ├── package.json               # Node dependencies
│   └── .env                       # Environment variables
│
├── BUILD32_FINAL.md               # Latest build documentation
├── README.md                      # This file
└── [APK files]                    # Built Android packages
```

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** >= 3.9.0
- **Dart SDK** >= 3.9.0
- **Node.js** >= 18.x
- **npm** or **yarn**
- Android Studio (for Android) or Xcode (for iOS)
- Git

### 1. Clone Repository

```bash
git clone https://github.com/voyageeyewear/eyejack.git
cd "Eyejack Native Application"
```

### 2. Setup Middleware (Node.js Backend)

#### For Local Development:

```bash
cd shopify-middleware
npm install
```

Create `.env` file:

```env
SHOPIFY_STORE_DOMAIN=eyejack1907.myshopify.com
SHOPIFY_ADMIN_ACCESS_TOKEN=shpat_xxxxxxxxxxxxxxxxxxxxx
SHOPIFY_STOREFRONT_ACCESS_TOKEN=xxxxxxxxxxxxxxxxxxxxxxx
SHOPIFY_API_VERSION=2025-01
PORT=3000
```

Start the server:

```bash
npm start
# Server runs on http://localhost:3000
```

#### For Production (Railway):

Backend is already deployed at:
```
https://motivated-intuition-production.up.railway.app
```

Auto-deploys on `git push` to `main` branch.

### 3. Setup Flutter App

```bash
cd eyejack_flutter_app
flutter pub get
```

#### Configure API Endpoint

The app is pre-configured for production (Railway):

```dart
// lib/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'https://motivated-intuition-production.up.railway.app';
}
```

For local development, change to:

```dart
static const String baseUrl = 'http://10.0.2.2:3000'; // Android emulator
// or
static const String baseUrl = 'http://YOUR_LOCAL_IP:3000'; // Physical device
```

### 4. Run the App

#### On Emulator/Simulator

```bash
flutter run
```

#### Build APK for Android

```bash
flutter clean
flutter pub get
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

#### Install APK on Device

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

## 🎨 Homepage Sections (In Order)

The app displays sections in this specific order:

1. **Announcement Bars** - Blue promotional banners (#52b1e2)
2. **Header** - Centered logo, menu, search, cart icons
3. **Moving USP Strip** - Scrolling trust badges
4. **Hero Slider** - Videos and images (full width, no cropping)
5. **Category Grid** - 4 quick category boxes
6. **Eyeglasses Section** - Gender categories with CDN images:
   - Men: `https://eyejack.in/cdn/shop/files/im-01.jpg`
   - Women: `https://eyejack.in/cdn/shop/files/im-02.jpg`
   - Sale: `https://eyejack.in/cdn/shop/files/wolf.webp`
   - Unisex: `https://eyejack.in/cdn/shop/files/View_all_New_Launch_Unisex_icon-03.png`
7. **Sunglasses Section** - Gender categories with CDN images:
   - Men: `https://eyejack.in/cdn/shop/files/2502PCL1474-men_3.jpg`
   - Women: `https://eyejack.in/cdn/shop/files/2502PCL1474-women_2.jpg`
   - Sale: `https://eyejack.in/cdn/shop/files/im-07.jpg`
   - Unisex: `https://eyejack.in/cdn/shop/files/View_all_New_Launch_Unisex_icon-03.png`
8. **Diwali Collection** - Featured products
9. **Exclusive Eyewear** - Collection cards
10. **Offers Section** - Promotional offers
11. **Trust Badges** - Footer trust indicators

## 🔧 Configuration

### Android Permissions

Required in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<application
    android:label="Eyejack"
    android:usesCleartextTraffic="true"
    ...>
```

### API Endpoints

All routes prefixed with `/api/shopify/`:

#### Core Routes
- `GET /api/shopify/theme-sections` - Homepage layout
- `GET /api/shopify/products?limit=50` - All products
- `GET /api/shopify/products/:id` - Single product
- `GET /api/shopify/products/collection/:handle` - Collection products
- `GET /api/shopify/collections` - All collections
- `GET /api/shopify/shop` - Shop info
- `GET /api/shopify/search?q=query` - Product search

#### Lens Routes
- `GET /api/shopify/lens-options` - Categorized lenses
  - Returns: `{ antiGlareLenses, blueBlockLenses, colourLenses, allLenses }`

#### Cart Routes
- `POST /api/shopify/cart/add` - Add single item
- `POST /api/shopify/cart/add-multiple` - Add lens + frame
- `POST /api/shopify/cart/update` - Update quantity
- `POST /api/shopify/cart/remove` - Remove item
- `GET /api/shopify/cart` - Get cart
- `POST /api/shopify/cart/clear` - Clear cart

#### Checkout Routes
- `POST /api/shopify/checkout/create` - Create checkout
- `POST /api/shopify/checkout/gokwik` - Gokwik checkout

### Lens Categorization

Automatic categorization by keywords:

- **Anti-glare**: "anti-glare", "anti glare", "antiglare"
- **Blue Block**: "blue", "block", "blu ray", "blue cut"
- **Colour Lenses**: "color", "colour", "tint", "mirror", "gradient"

## 📊 Features in Detail

### 1. Hero Slider
- Supports images and MP4 videos
- BoxFit.contain (no cropping)
- In-app navigation for slide links
- Single video controller (memory optimized)
- Auto-play with pause on interaction

### 2. Gender Categories
- Image-based cards with CachedNetworkImage
- Specific CDN URLs from Shopify
- In-app navigation to collections
- Error handling with fallback UI
- Debug logging for troubleshooting

### 3. Product Details
- Breadcrumbs (Home > Category > Product)
- Clickable breadcrumbs for navigation
- Frame measurements extraction (regex)
- Collapsible description (Read more/less)
- Image gallery (BoxFit.contain, no cropping)
- Smaller product title (18px)
- Reduced image margins

### 4. 4-Step Lens Selector

**Step 1: Lens Type**
- With power / Single Vision
- Progressive
- Computer Glasses / Blue Cut
- Zero Power

**Step 2: Power Type**
- Anti-glare lenses (shows count)
- Blue Block Lenses (shows count)
- Colour Lenses (shows count)

**Step 3: Select Lens**
- Filtered by power type
- Shows features and pricing
- Real-time Shopify data

**Step 4: Add Power (Optional)**
- SPH, CYL, Axis, ADD fields
- Right (OD) and Left (OS) eyes
- Auto-adds lens + frame to cart

### 5. Cart Management
- Image thumbnails for all items
- Quantity adjustment
- Remove items
- Cart properties preserved
- Total price display
- Gokwik checkout integration

## 🐛 Troubleshooting

### App Shows Old Data
**Solution**: Pull down to refresh or clear app data (Settings → Apps → Eyejack → Clear Data)

### Images Not Loading
**Solution**: 
1. Check internet connection
2. Verify Railway backend is running (https://motivated-intuition-production.up.railway.app/health)
3. Pull to refresh

### Videos Cropping
**Fixed**: All videos use BoxFit.contain (no cropping)

### Announcement Colors Changing
**Fixed**: All bars use #52b1e2 in backend

### Gender Category Images Not Showing
**Fixed**: Using specific CDN URLs from eyejack.in

## 🚢 Deployment

### Railway (Production Backend)

Already deployed at: `https://motivated-intuition-production.up.railway.app`

**Auto-deploy on Git push:**
```bash
git add .
git commit -m "Update"
git push origin main
```

Railway detects changes and deploys automatically (60-90 seconds).

**Environment Variables (set in Railway dashboard):**
- `SHOPIFY_STORE_DOMAIN`
- `SHOPIFY_ADMIN_ACCESS_TOKEN`
- `SHOPIFY_STOREFRONT_ACCESS_TOKEN`
- `SHOPIFY_API_VERSION`
- `PORT`

### APK Distribution

**Latest APK**: `Eyejack-v3.0.0-Build32-FINAL.apk`

Build new version:
```bash
# Update version in pubspec.yaml
version: 3.0.0+33  # Increment build number

# Build
flutter clean
flutter pub get
flutter build apk --release

# Copy APK
cp build/app/outputs/flutter-apk/app-release.apk Eyejack-v3.0.0-Build33.apk
```

## 📱 App Releases

### Latest Version: v6.0.1 Build 61 (November 5, 2024)

**🎉 BoAt-Style UI Update:**
- ✅ **Modern Sticky Cart**: Two buttons side by side (Add To Cart + Select Lens)
- ✅ **Enhanced Price Display**: Large price with discount badge and tax info
- ✅ **BoAt-Style Layout**: Exactly matches reference image design
- ✅ **Smart Button Logic**: Disabled "Add To Cart" for products requiring lens selection
- ✅ **4 New Homepage Sections**: Features, Statistics, Video Demo, FAQ (at bottom)
- ✅ **Railway Deployment**: Backend updated and deployed to production

### Version v6.0.0 Build 60 (November 5, 2024)

**🎨 Complete FireLens-Style Redesign:**
- ✅ **Product Page Redesign**: Modern white header, review stars, variant selector
- ✅ **Enhanced Image Gallery**: Counter overlay, green-highlighted thumbnails
- ✅ **Prescription Upload Section**: Three prominent options (Upload/Manual/Email)
- ✅ **Product Features Widget**: Icon-based feature cards with descriptions
- ✅ **Specifications Accordion**: Expandable sections for Frame/Lens/Dimensions
- ✅ **Product Videos Section**: Video player support (when available)
- ✅ **FAQ Section**: Collapsible product-specific FAQs
- ✅ **Lens Selector UI**: Enhanced with modern step indicators and shadows
- ✅ **10 New Widgets**: Modular, reusable UI components
- ✅ **2,500+ Lines**: Major code additions for premium experience

**Previous Versions:**
- v5.1.1 Build 53 - Collection page button spacing fix
- v5.1.0 Build 52 - Collection page responsiveness improvements
- v5.0.1 Build 51 - Version bump for cache clearing
- v5.0.0 Build 50 - Collection page redesign with sorting/filtering
- v4.0.0 Build 40-41 - Major UI updates
- v3.0.0 Build 30-36 - Gender categories and cache fixes
- v2.0.0 Build 20-22 - Collection integrations
- v1.0.0 Build 1-9 - Initial releases

## 🔐 Security

- ✅ Store credentials in `.env` (never commit)
- ✅ Storefront API token (read-only)
- ✅ Input validation in middleware
- ✅ HTTPS in production (Railway)
- ✅ CORS configuration

## 🤝 Contributing

1. Fork repository
2. Create feature branch (`git checkout -b feature/Feature`)
3. Commit changes (`git commit -m 'Add Feature'`)
4. Push to branch (`git push origin feature/Feature`)
5. Open Pull Request

## 📄 License

This project is proprietary and confidential.

## 📞 Support

For issues or questions:
- Check `BUILD32_FINAL.md` for latest documentation
- Review troubleshooting section above
- Contact development team

## 🙏 Acknowledgments

- Flutter team for excellent framework
- Shopify for comprehensive Storefront API
- Railway for reliable cloud hosting
- Material Design for UI guidelines

---

**Built with ❤️ for EyeJack**

**Production URL**: https://motivated-intuition-production.up.railway.app  
**Live Store**: www.eyejack.in  
**Latest APK**: Eyejack-v6.0.1-BoatStyle-Build61.apk (52MB)  
**Last Updated**: November 5, 2024  
**Current Version**: 6.0.1 (Build 61)

### 🎯 Quick Links
- [BoAt-Style Update Summary](BOAT_STYLE_UPDATE.md)
- [FireLens Redesign Details](FIRELENS_REDESIGN_COMPLETE.md)
- [Installation Guide](APK_INSTALL_INSTRUCTIONS.md)
