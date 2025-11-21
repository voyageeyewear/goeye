# 🚀 Quick Database Setup Guide

## Current Status
- ✅ Backend is running on Railway
- ❌ Database is NOT connected
- ⚠️ Changes won't persist until database is connected

## Step-by-Step Setup (5 minutes)

### Step 1: Add PostgreSQL to Railway

1. **Go to Railway Dashboard:**
   - Visit: https://railway.app
   - Login to your account
   - Open your **Goeye** project

2. **Add PostgreSQL Database:**
   - Click **"+ New"** button (top right)
   - Select **"Database"**
   - Choose **"PostgreSQL"**
   - Wait 30-60 seconds for provisioning

### Step 2: Link Database to Your Service

1. **In your Railway project**, you'll now see:
   - Your middleware service (Node.js)
   - A new PostgreSQL service

2. **Click on your middleware service** (the one running your API)

3. **Go to "Variables" tab**

4. **Add DATABASE_URL:**
   - Click **"New Variable"**
   - **Name:** `DATABASE_URL`
   - **Value:** `${{Postgres.DATABASE_URL}}`
     - *(This automatically links to your Postgres service)*
   - Click **"Add"**

5. **Railway will automatically redeploy** your service (takes 60-90 seconds)

### Step 3: Verify Connection

After redeployment, test the connection:

```bash
curl https://web-production-b0095.up.railway.app/health
```

Should show:
```json
{
  "status": "OK",
  "database": "Connected"  ← This should say "Connected" now!
}
```

### Step 4: Seed the Database

Once connected, seed the database with initial data:

**Option A: Using Railway CLI (Recommended)**

```bash
# Install Railway CLI (if not installed)
npm install -g @railway/cli

# Login
railway login

# Link to project
cd /Users/dhruv/Desktop/Goeye-app-finalize
railway link

# Run seed script
railway run --service <your-service-name> node shopify-middleware/scripts/seedDatabase.js
```

**Option B: Run Locally (with Railway DATABASE_URL)**

1. Get DATABASE_URL from Railway:
   - Go to PostgreSQL service → Variables tab
   - Copy the `DATABASE_URL` value

2. Run locally:
```bash
cd /Users/dhruv/Desktop/Goeye-app-finalize/shopify-middleware
export DATABASE_URL="postgresql://postgres:xxxxx@xxxxx.railway.app:xxxxx/railway"
node scripts/seedDatabase.js
```

### Step 5: Test Everything

1. **Check health endpoint:**
   ```bash
   curl https://web-production-b0095.up.railway.app/health
   ```
   Should show: `"database": "Connected"`

2. **Test admin dashboard:**
   - Refresh http://localhost:5173
   - Try saving settings
   - Reload page - changes should persist!

3. **Test in Flutter app:**
   - Restart the app
   - Settings should now load from database

## ✅ Success Checklist

- [ ] PostgreSQL service created on Railway
- [ ] DATABASE_URL added to middleware service variables
- [ ] Health endpoint shows "database": "Connected"
- [ ] Database seeded successfully
- [ ] Admin dashboard saves and loads settings
- [ ] Flutter app shows settings from database

## 🐛 Troubleshooting

### "Database: Not Connected" after setup

**Check:**
1. DATABASE_URL is set in Railway variables
2. Value is: `${{Postgres.DATABASE_URL}}` (not a manual string)
3. Wait 2-3 minutes after adding variable (deployment takes time)
4. Check Railway logs for connection errors

### "Connection refused" error

**Solution:**
- Verify PostgreSQL service is running (green status)
- Check DATABASE_URL format is correct
- Ensure SSL is enabled (our code handles this automatically)

### Settings still not persisting

**Solution:**
1. Clear browser localStorage: Open DevTools → Application → Local Storage → Clear
2. Refresh dashboard
3. Save settings again
4. Check Railway logs to see if save succeeded

## 📞 Need Help?

If you're stuck:
1. Check Railway service logs for errors
2. Verify DATABASE_URL format matches: `postgresql://user:pass@host:port/db`
3. Test connection locally using the test script:
   ```bash
   cd shopify-middleware
   node scripts/testDatabaseConnection.js
   ```

---

**Once database is connected, all your dashboard changes will persist and appear in the Flutter app!** 🎉

