# Railway Deployment - Quick Fix Guide

## 🔧 Most Common Issue: Missing Environment Variables

Your deployment is crashing because **required environment variables are missing**.

### ✅ Fix This First:

1. **Go to Railway Dashboard** → Your Project → **Variables** tab

2. **Add these environment variables:**

```
SHOPIFY_STORE_DOMAIN=goeyee.myshopify.com
SHOPIFY_ADMIN_ACCESS_TOKEN=shpat_xxxxxxxxxxxxxxxxxxxxx
SHOPIFY_STOREFRONT_ACCESS_TOKEN=xxxxxxxxxxxxxxxxxxxxxxx
SHOPIFY_API_VERSION=2025-01
NODE_ENV=production
```

**Note**: Replace `xxxxxxxxxxxxxxxxxxxxx` with your actual Shopify API tokens.

**Note**: Railway automatically sets `PORT`, so don't set it manually.

3. **After adding variables**, Railway will automatically redeploy.

## 🔍 How to Check Your Logs

1. In Railway Dashboard → Click your deployment
2. Go to **"Logs"** tab
3. Look for error messages like:
   - `Missing SHOPIFY_STORE_DOMAIN` → Add environment variable
   - `Cannot find module` → Dependencies issue
   - `Database connection failed` → This is OK, database is optional

## ✅ Verify Deployment

After redeploying, test the health endpoint:
```
https://your-railway-url.railway.app/health
```

Expected response:
```json
{
  "status": "OK",
  "message": "Shopify Middleware API is running",
  "store": "goeyee.myshopify.com",
  "database": "Not Connected",
  "shopifyApi": "Configured"
}
```

## 🎯 Configuration Checklist

- [ ] **Root Directory**: Set to `shopify-middleware` in Railway settings
- [ ] **Environment Variables**: All 5 variables added (see above)
- [ ] **Build Command**: Railway auto-detects `npm install`
- [ ] **Start Command**: Railway auto-detects from `package.json`

## 📝 If Still Crashing

1. **Check Railway Logs** - They show the exact error
2. **Verify Root Directory** - Should be `shopify-middleware`
3. **Check Procfile** - Should exist at root with `web: cd shopify-middleware && npm start`

## 💡 Database is Optional!

The app works **without a database**. The database is only needed for:
- Admin dashboard features
- Dynamic content management

If you see database connection errors, **that's OK** - the server will still work for Shopify API calls.

---

**Quick Actions:**
1. Add environment variables → Railway will auto-redeploy
2. Wait 30-60 seconds
3. Check health endpoint
4. Done! 🎉

