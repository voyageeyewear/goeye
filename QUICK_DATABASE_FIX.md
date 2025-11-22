# 🔧 Quick Database Connection Fix

## What You Need to Do

You're almost there! You have:
- ✅ Postgres service created
- ✅ Postgres has DATABASE_URL available
- ❌ **web service has empty DATABASE_URL** ← This is the problem!

## Fix in 3 Steps (2 minutes)

### Step 1: Open "web" Service Variables
1. In Railway dashboard, click on the **"web"** service (the one with GitHub icon)
2. Click on **"Variables"** tab

### Step 2: Add DATABASE_URL Variable
1. Click **"+ New Variable"** button
2. **Name:** `DATABASE_URL`
3. **Value:** `${{Postgres.DATABASE_URL}}`
   - Click the variable picker icon next to the input
   - Select "Postgres" → "DATABASE_URL"
   - OR just type: `${{Postgres.DATABASE_URL}}`
4. Click **"Add"** or **"Save"**

### Step 3: Wait for Redeployment
- Railway will automatically redeploy (60-90 seconds)
- Check the Deployments tab to see progress
- Wait until deployment shows green checkmark

## Verify It Works

After redeployment completes:

```bash
curl https://web-production-b0095.up.railway.app/health
```

Should show:
```json
{
  "database": "Connected"  ← Should say "Connected"!
}
```

Then refresh your dashboard at `http://localhost:5173`:
- Footer should show: "PostgreSQL Connected" (green)
- Warning banner should disappear
- Settings will save to database
- Changes will appear in your Flutter app!

## What This Does

- Links your Postgres database to your API service
- Allows settings to be saved permanently
- Makes changes visible in your Flutter app
- Enables all database features

---

**Once DATABASE_URL is set, everything will work!** 🎉

