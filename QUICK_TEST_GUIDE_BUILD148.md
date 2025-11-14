# Quick Test Guide - Build 148 Color Swatches

## ✅ Build 148 is Running on Your Emulator

### 🎨 Color Swatches Now Work!

When you **tap a color swatch**, it will:
1. Show a loading spinner
2. Search for that color variant
3. Navigate to the product page
4. Show the new color as selected

---

## 🧪 Quick Test (2 minutes)

### Test 1: Matrix Products (2 colors)

1. **Search**: Type `"Matrix"` in search bar
2. **Open**: Any Matrix product
3. **See**: 2 color swatches (Grey ⚫ and Black ⚪)
4. **Tap**: The unselected color
5. **Result**: ✨ Navigates to that color product!

### Test 2: Classic Aviator (4 colors)

1. **Search**: Type `"Aviator"` in search bar
2. **Open**: Any Classic Aviator product
3. **See**: 4 color swatches:
   - 🟡 Golden
   - ⚪ Silver  
   - ⚪ Grey
   - ⚫ Black
4. **Tap**: Any unselected color
5. **Result**: ✨ Navigates to that color product!

---

## 🎯 What You Should See

### Before Tap:
```
┌────────────────────────────┐
│ Select Color               │
│ 🟡 ⚪ ⚪ ⚫                │
│ (One has green border +    │
│  white checkmark)          │
└────────────────────────────┘
```

### During Tap (Loading):
```
┌────────────────────────────┐
│ Select Color               │
│    ⟳ Loading...            │
│  (Green spinner)           │
└────────────────────────────┘
```

### After Navigation:
```
New product page loads!
Selected color changes to
the one you tapped!
```

---

## 📋 Supported Products

### ✅ Matrix Square Metal Sunglasses
- Search: "Matrix"
- Colors: **2** (Grey, Black)
- SKU: RH9522CL8XX

### ✅ Classic Aviator Sunglasses  
- Search: "Aviator" or "Classic Aviator"
- Colors: **4** (Golden, Silver, Grey, Black)
- SKU: 3025CL9XX

---

## 🎨 Color Swatch Visual Guide

| Color | Looks Like | Hex Code |
|-------|------------|----------|
| Golden | 🟡 Gold circle | #FFD700 |
| Silver | ⚪ Silver circle | #C0C0C0 |
| Grey | ⚪ Grey circle | #808080 |
| Black | ⚫ Black circle | #000000 |

**Selected** = Green border + white ✓ checkmark
**Unselected** = Grey border, no checkmark

---

## 🔥 Try These Tests

### Test A: Grey → Black (Matrix)
1. Open Matrix Grey product
2. Tap Black swatch
3. ✅ Should navigate to Black product

### Test B: Golden → Silver (Aviator)
1. Open Classic Golden Aviator
2. Tap Silver swatch
3. ✅ Should navigate to Silver product

### Test C: Multiple Switches (Aviator)
1. Open any Classic Aviator
2. Tap Golden → Navigates ✅
3. Tap Silver → Navigates ✅
4. Tap Grey → Navigates ✅
5. Tap Black → Navigates ✅

---

## ⚡ Quick Verification

**Open your emulator and try this RIGHT NOW:**

```
1. Tap search 🔍
2. Type "Aviator"
3. Open any product
4. See 4 color circles
5. Tap a different color
6. Watch it navigate!
```

Takes 10 seconds! 🚀

---

## 🐛 If Something Goes Wrong

### Red Error Message Appears?
**Means**: Product not found in Shopify
**Fix**: Check product exists on your Shopify store

### Swatches Don't Show?
**Means**: Not on a Matrix or Classic Aviator product  
**Fix**: Search for "Matrix" or "Aviator"

### Loading Never Stops?
**Means**: Network issue
**Fix**: Check internet connection

---

## 📱 App Info

- **Version**: 12.20.0
- **Build**: 148
- **Status**: Running on emulator
- **Products Supported**: Matrix (2 colors) + Classic Aviator (4 colors)

---

## ✨ What's Different from Build 147?

| Feature | Build 147 | Build 148 |
|---------|-----------|-----------|
| Shows swatches | ✅ | ✅ |
| Tap action | Shows notification only | **Navigates to product!** 🎉 |
| Loading indicator | ❌ | ✅ Added |
| Classic Aviator support | ❌ | ✅ Added 4 colors |

---

**GO TEST IT NOW!** 🚀

Search "Aviator" → Open product → Tap a color → Watch it work!

