# 🚂 Deploy to Railway

## Code Pushed to GitHub

✅ **Repository:** https://github.com/voyageeyewear/goeye.git  
✅ **Branch:** main

---

## 🚀 Railway Deployment Steps

### 1. **Go to Railway**

Visit: https://railway.app

### 2. **Create New Project**

1. Click **"New Project"**
2. Select **"Deploy from GitHub repo"**
3. Choose repository: **`voyageeyewear/goeye`**
4. Railway will detect it's a Node.js project

### 3. **Configure Environment Variables**

Go to **Variables** tab and add:

```bash
SHOPIFY_STORE_DOMAIN=goeyee.myshopify.com
SHOPIFY_ADMIN_ACCESS_TOKEN=YOUR_SHOPIFY_ADMIN_TOKEN
SHOPIFY_STOREFRONT_ACCESS_TOKEN=YOUR_STOREFRONT_TOKEN
SHOPIFY_API_KEY=YOUR_API_KEY
SHOPIFY_API_SECRET=YOUR_API_SECRET
SHOPIFY_API_VERSION=2024-01
PORT=3000
```

**Replace** `YOUR_*` placeholders with your actual Shopify credentials from `.env` file.

### 4. **Configure Build Settings**

**Root Directory:** `shopify-middleware`  
**Build Command:** (leave empty or: `npm install`)  
**Start Command:** `node server.js`

### 5. **Deploy**

Click **"Deploy"** and wait for Railway to:
- Install dependencies
- Start the server
- Generate a public URL

### 6. **Get Your Railway URL**

Once deployed, Railway will give you a URL like:
```
https://your-app-name.up.railway.app
```

### 7. **Update Flutter App**

Update `goeye_flutter_app/lib/config/api_config.dart`:

```dart
static const String baseUrl = 'https://your-app-name.up.railway.app';
```

---

## ✅ Next Steps

1. **Deploy backend to Railway** (follow steps above)
2. **Get Railway URL**
3. **Update Flutter app API config**
4. **Rebuild APK with Railway URL**
5. **Test videos on real device!**

---

## 🔧 Railway Tips

- **Auto-deploy:** Every push to `main` will auto-deploy
- **Logs:** Check deployment logs in Railway dashboard
- **Custom Domain:** Add your own domain in Railway settings
- **Scaling:** Upgrade plan for more resources if needed

---

**Once Railway is deployed, the Flutter app will connect to your live backend and videos will work on real devices!** 🎬

