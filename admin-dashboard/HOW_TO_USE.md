# 📖 How to Use the Dashboard

## Starting the Dashboard

### Every Time You Want to Manage Content:

1. **Open Terminal** (or Command Prompt on Windows)

2. **Navigate to the dashboard folder:**
   ```bash
   cd "/Users/ssenterprises/Eyejack Native Application/admin-dashboard"
   ```

3. **Start the dashboard:**
   ```bash
   npm run dev
   ```

4. **Open your browser:**
   - Go to: `http://localhost:5173`
   - Bookmark this URL for quick access!

5. **Start managing your app!**

### When You're Done:

- Close the browser tab
- In Terminal, press `Ctrl + C` to stop the server
- Or just close the Terminal window

---

## Daily Workflow

### Typical Use Case:

```
1. Morning: Start dashboard (npm run dev)
2. Make content changes throughout the day
3. Test changes in Flutter app
4. Evening: Stop dashboard (Ctrl + C)
```

### Quick Changes:

```
1. Start dashboard (npm run dev)
2. Edit what you need (5 minutes)
3. Stop dashboard (Ctrl + C)
```

---

## Managing Content

### Example 1: Change Announcement Bar
```
1. Open http://localhost:5173
2. Click "Sections" in sidebar
3. Find "announcement-bars"
4. Click edit (pencil icon)
5. Modify the text/colors
6. Click "Save Changes"
7. Done! ✅
```

### Example 2: Hide a Section
```
1. Go to "Sections" page
2. Find the section
3. Click the eye icon (toggle)
4. Section becomes inactive
5. Done! ✅
```

### Example 3: Change App Color
```
1. Go to "Theme Settings"
2. Find color setting
3. Use color picker
4. Click "Save"
5. Done! ✅
```

---

## Understanding the Interface

### Left Sidebar (Navigation)
- **Dashboard** - Overview and statistics
- **Sections** - Manage app content sections
- **Theme Settings** - Change colors and styles
- **Preview** - See current configuration

### Dashboard Page
- See how many sections you have
- Quick access buttons
- Section types overview

### Sections Page
- **Eye Icon** - Toggle active/inactive
- **Pencil Icon** - Edit section
- **Trash Icon** - Delete section
- **Green Badge** - Section is active
- **Gray Badge** - Section is inactive

### Theme Settings Page
- **Color Picker** - Click to choose colors
- **Text Input** - Enter hex values (#FF5733)
- **Save Button** - Appears when you make changes

### Preview Page
- **Auto-Refresh** - Updates every 5 seconds
- **Refresh Button** - Manual refresh
- **Expand Details** - Click to see full JSON

---

## Important Notes

### 🔴 Changes Are REAL
- Even though you're running locally
- All changes save to production database
- Your Flutter app will see these changes
- There's no "undo" button (yet)

### 💡 Best Practices
1. **Test Small Changes First** - Edit one thing, test it
2. **Keep Notes** - Remember what you changed
3. **Take Screenshots** - Before making big changes
4. **Ask if Unsure** - Better to ask than break something!

### 🔒 Security
- Only accessible from your computer
- No one else can access localhost
- Your Railway credentials are secure
- Dashboard uses HTTPS to Railway

### ⚡ Performance
- Changes save instantly
- Flutter app sees changes on next launch
- No app rebuild needed
- No waiting for deployment

---

## Common Tasks

### Daily Content Update
```
Time: 5 minutes
Steps:
1. Start dashboard
2. Go to Sections
3. Edit announcement bar
4. Save
5. Done!
```

### Weekly Color Refresh
```
Time: 10 minutes
Steps:
1. Start dashboard
2. Go to Theme Settings
3. Try new color scheme
4. Save each color
5. Test in app
6. Done!
```

### Monthly Section Review
```
Time: 30 minutes
Steps:
1. Start dashboard
2. Review all sections
3. Hide unused ones
4. Update outdated content
5. Check preview
6. Done!
```

---

## Troubleshooting

### Problem: Dashboard won't start
**Solution:**
```bash
cd "/Users/ssenterprises/Eyejack Native Application/admin-dashboard"
npm install
npm run dev
```

### Problem: Changes not saving
**Solution:**
- Check your internet connection
- Verify Railway backend is running
- Look for error messages in the dashboard
- Try refreshing the page

### Problem: Can't see changes in app
**Solution:**
- Close Flutter app completely
- Reopen the app
- Wait a few seconds for data to load
- Changes should now appear

### Problem: Port 5173 already in use
**Solution:**
```bash
lsof -ti:5173 | xargs kill -9
npm run dev
```

---

## Tips & Tricks

### 💡 Keyboard Shortcuts
- `Cmd + R` (Mac) or `Ctrl + R` (Windows) - Refresh page
- `Cmd + T` (Mac) or `Ctrl + T` (Windows) - New tab
- `Cmd + W` (Mac) or `Ctrl + W` (Windows) - Close tab

### 💡 Bookmarks
Add these bookmarks in your browser:
- Dashboard: `http://localhost:5173`
- Sections: `http://localhost:5173/sections`
- Theme: `http://localhost:5173/theme`
- Preview: `http://localhost:5173/preview`

### 💡 Multiple Browser Tabs
- Open dashboard in multiple tabs
- One for editing, one for preview
- Changes sync across tabs

### 💡 Browser Dev Tools
- Press `F12` to open developer tools
- See console for error messages
- Network tab shows API calls
- Helpful for debugging

---

## Getting Help

### Check the Logs
**Terminal Output:**
Look at the terminal where `npm run dev` is running for error messages.

**Browser Console:**
Press `F12` → Console tab to see JavaScript errors.

**Railway Logs:**
Visit Railway dashboard → Your project → View Logs

### Common Error Messages

**"Failed to fetch"**
- Check internet connection
- Verify Railway backend is running

**"Network Error"**
- Railway might be down
- Check Railway status page

**"Validation Error"**
- Check your JSON syntax
- Make sure all required fields are present

---

## Summary

### Remember:
✅ Start dashboard: `npm run dev`  
✅ Access: `http://localhost:5173`  
✅ Stop dashboard: `Ctrl + C`  
✅ Changes are real and instant  
✅ No app rebuild needed  

### For Help:
📚 Read `README.md` for technical details  
📚 Read `DASHBOARD_QUICK_START.md` for overview  
📚 This file for daily usage  

**Happy content managing!** 🎉

