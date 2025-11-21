# Seed Goeye Database on Railway

## Step 1: Verify DATABASE_URL is Set

1. Go to Railway Dashboard → Your **Goeye Service** (not Postgres)
2. Click **"Variables"** tab
3. Make sure `DATABASE_URL` is set to:
   ```
   postgresql://postgres:OSfQXgpXfUVhyJYbhYdRVOgxRynsZeHE@shortline.proxy.rlwy.net:20844/railway
   ```

## Step 2: Seed the Database

You have **3 options** to seed the database:

### Option A: Using Railway CLI (Recommended)

1. **Install Railway CLI** (if not installed):
   ```bash
   npm install -g @railway/cli
   ```

2. **Login to Railway**:
   ```bash
   railway login
   ```

3. **Link to your project**:
   ```bash
   cd "/Users/ssenterprises/Goeye Native Application"
   railway link
   ```
   Select your Goeye project when prompted.

4. **Run the seed script**:
   ```bash
   railway run --service goeye cd shopify-middleware && node scripts/seedDatabase.js
   ```

### Option B: Using Railway Web Terminal

1. Go to Railway Dashboard → Your **Goeye Service**
2. Click **"Deployments"** tab
3. Click on the latest deployment
4. Click **"View Logs"** → **"Shell"** tab (or look for terminal/console option)
5. Run:
   ```bash
   cd shopify-middleware
   node scripts/seedDatabase.js
   ```

### Option C: Run Locally (with Railway DATABASE_URL)

1. **Set DATABASE_URL locally**:
   ```bash
   cd "/Users/ssenterprises/Goeye Native Application/shopify-middleware"
   export DATABASE_URL="postgresql://postgres:OSfQXgpXfUVhyJYbhYdRVOgxRynsZeHE@shortline.proxy.rlwy.net:20844/railway"
   export NODE_ENV=production
   ```

2. **Run seed script**:
   ```bash
   node scripts/seedDatabase.js
   ```

## Step 3: Verify Database is Seeded

After running the seed script, you should see:
```
✅ Created 9 sections
✅ Created 3 theme settings
✅ Database seeded successfully!
```

## Step 4: Test the API

Test the health endpoint:
```
https://your-railway-url.railway.app/health
```

Should show:
```json
{
  "status": "OK",
  "message": "Shopify Middleware API is running",
  "store": "goeyee.myshopify.com",
  "database": "Connected",
  "shopifyApi": "Configured"
}
```

Test theme sections endpoint:
```
https://your-railway-url.railway.app/api/shopify/theme-sections
```

Should return all 9 sections from the database!

## What Gets Seeded

The seed script creates:

### 9 App Sections:
1. Announcement Bars (3 bars)
2. App Header (logo, search, cart)
3. USP Moving Strip (COD, EMI, Returns, Support)
4. Circular Categories (5 categories)
5. Hero Slider (3 slides)
6. Gender Categories - Eyeglasses (Men, Women, Sale, Unisex)
7. Gender Categories - Sunglasses (Men, Women, Sale, Unisex)
8. Video Slider (5 videos)
9. Exclusive Eyewear Collection Cards (6 collections)

### 3 Theme Settings:
1. Primary Color: `#52b1e2` (blue)
2. Background Color: `#FFFFFF` (white)
3. Text Color: `#000000` (black)

## Troubleshooting

### Error: "Cannot connect to database"
- Check `DATABASE_URL` is set in Railway Variables
- Verify the connection string is correct (no extra spaces)
- Make sure Postgres service is running

### Error: "Table already exists"
- The seed script uses `force: true` which drops existing tables
- This is safe - it will recreate everything fresh

### Error: "Permission denied"
- Make sure you're running in the correct service context
- Check Railway service permissions

---

**Quick Command (if Railway CLI is installed):**
```bash
railway run --service goeye cd shopify-middleware && node scripts/seedDatabase.js
```

