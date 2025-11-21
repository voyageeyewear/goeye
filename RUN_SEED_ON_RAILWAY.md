# 🚂 Run Seed Script on Railway

## Issue
The API is deployed but database tables don't exist yet. You need to run the seed script on Railway's PostgreSQL.

## Solution Options

### Option 1: Railway CLI (Easiest)

```bash
# 1. Install Railway CLI (if not already installed)
npm i -g @railway/cli

# 2. Login to Railway
railway login

# 3. Link to your project
cd "/Users/ssenterprises/Goeye Native Application/shopify-middleware"
railway link

# 4. Select your project from list

# 5. Run seed script on Railway
railway run node scripts/seedDatabase.js
```

Expected output:
```
🌱 Starting database seed...
📊 Creating database tables...
✅ Tables created successfully
📦 Seeding app sections...
✅ Created 9 sections
✅ Database seeded successfully!
```

---

### Option 2: Via Railway Dashboard

1. **Go to Railway Dashboard**
2. **Open your PostgreSQL service**
3. **Click "Query" tab**
4. **Run these SQL commands:**

```sql
-- Create app_sections table
CREATE TABLE app_sections (
    id SERIAL PRIMARY KEY,
    section_id VARCHAR(100) UNIQUE NOT NULL,
    section_type VARCHAR(50) NOT NULL,
    settings JSONB NOT NULL DEFAULT '{}',
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create app_theme table
CREATE TABLE app_theme (
    id SERIAL PRIMARY KEY,
    theme_key VARCHAR(100) UNIQUE NOT NULL,
    theme_value TEXT NOT NULL,
    theme_type VARCHAR(50),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

5. **Then insert data** (you can copy from `scripts/seedDatabase.js` or use Railway CLI)

---

### Option 3: One-Line Command

```bash
cd "/Users/ssenterprises/Goeye Native Application/shopify-middleware" && railway run node scripts/seedDatabase.js
```

---

## Verification

After running seed, test:

```bash
# Should return 9 sections
curl https://motivated-intuition-production.up.railway.app/api/admin/sections
```

---

## If Railway CLI Doesn't Work

You can also:

1. **Set DATABASE_URL locally:**
   ```bash
   # Get DATABASE_URL from Railway dashboard
   export DATABASE_URL="postgresql://postgres:xxxxx@...railway.app:6379/railway"
   
   # Run seed
   node scripts/seedDatabase.js
   ```

---

## After Seed Success

Railway will be fully functional:
- ✅ Database tables created
- ✅ 9 sections loaded
- ✅ API endpoints working
- ✅ Flutter app can fetch data
- ✅ Ready for dashboard!

---

**Run the command and let me know when you see "✅ Database seeded successfully!"** 🚀

