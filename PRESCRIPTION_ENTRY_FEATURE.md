# 📋 Prescription Entry Feature - Step 4 Enhancement

## ✅ What's Implemented

### New UI Flow in Step 4

When users reach Step 4 (Add Your Prescription), they now see **3 options**:

1. **📤 Upload File** - Upload prescription image/PDF
2. **✏️ Enter Manually** - Manual entry form (existing)
3. **📧 Email Later** - Skip and email later

### UI/UX Details

#### Option Selection Screen
```
┌──────────────────────────────────────┐
│  Add Your Prescription               │
│                                      │
│  ┌────────────────────────────────┐ │
│  │ 📤  Upload File                │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌────────────────────────────────┐ │
│  │ ✏️   Enter Manually             │ │ ← Highlighted
│  └────────────────────────────────┘ │
│                                      │
│  ┌────────────────────────────────┐ │
│  │ 📧  Email Later                │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

- Clean, card-based design
- Icons for each option
- Tap to select
- Back button returns to Step 3

### 1. Upload File (Placeholder Ready)

**Current Status:** UI ready, file picker placeholder

**UI Features:**
- Large upload area with cloud icon
- "Tap to upload prescription"
- Supports: PDF, JPG, PNG (Max 5MB)
- Shows uploaded file name with checkmark
- "Change file" option after upload
- Save button disabled until file uploaded

**What Happens:**
1. User taps upload area
2. Shows info message (placeholder)
3. Simulates file selection
4. Displays filename
5. Enables "Save and Continue"
6. Adds to cart with file URL in properties

**Cart Properties Added:**
```json
{
  "4. Prescription Type": "upload",
  "Prescription File": "https://eyejack.in/cdn/shop/files/prescription.pdf",
  "File Name": "prescription_demo.pdf"
}
```

### 2. Enter Manually (Fully Functional)

**Current Status:** ✅ Fully working

**UI Features:**
- Same as before
- Shows Left Eye (OS) and Right Eye (OD) fields
- SPH, CYL, Axis inputs
- Optional fields
- Save button always enabled

**Cart Properties Added:**
```json
{
  "4. Prescription Type": "manual",
  "left_sph": "-2.50",
  "left_cyl": "-1.00",
  "left_axis": "90",
  "right_sph": "-2.00",
  "right_cyl": "-0.75",
  "right_axis": "85"
}
```

### 3. Email Later (Fully Functional)

**Current Status:** ✅ Fully working

**UI Features:**
- Shows email icon (large)
- "Email Later" title
- Message: "We'll send you an email..."
- Auto-proceeds to cart
- Shows "Proceeding to cart..." message

**Cart Properties Added:**
```json
{
  "4. Prescription Type": "email",
  "Prescription Note": "Customer will email prescription later"
}
```

---

## 🔧 To Enable Full File Upload

### Step 1: Add file_picker Package

Add to `pubspec.yaml`:

```yaml
dependencies:
  file_picker: ^6.1.1  # Or latest version
```

Run:
```bash
flutter pub get
```

### Step 2: Update Android Permissions

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

### Step 3: Implement File Picker

Uncomment and implement in `_pickAndUploadFile()`:

```dart
import 'package:file_picker/file_picker.dart';

Future<void> _pickAndUploadFile() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    
    if (result != null) {
      final file = result.files.first;
      
      // Validate file size (5MB max)
      if (file.size > 5 * 1024 * 1024) {
        throw Exception('File size must be less than 5MB');
      }
      
      // Upload to Shopify
      final url = await _uploadToShopify(file);
      
      setState(() {
        _uploadedFileUrl = url;
        _uploadedFileName = file.name;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Prescription uploaded successfully!'),
          backgroundColor: Color(0xFF4caf50),
        ),
      );
    }
  } catch (e) {
    debugPrint('Error picking file: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
```

### Step 4: Implement Shopify File Upload

Create backend endpoint in `shopify-middleware`:

**File:** `shopify-middleware/routes/shopify.js`

```javascript
// Upload prescription file
router.post('/upload-prescription', 
  upload.single('file'), 
  shopifyController.uploadPrescription
);
```

**File:** `shopify-middleware/controllers/shopifyController.js`

```javascript
exports.uploadPrescription = async (req, res) => {
  try {
    const file = req.file;
    if (!file) {
      return res.status(400).json({
        success: false,
        error: 'No file provided'
      });
    }

    // Upload to Shopify Files API
    const url = await shopifyService.uploadFile(file);

    res.json({
      success: true,
      data: {
        url: url,
        filename: file.originalname
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
};
```

**File:** `shopify-middleware/services/shopifyService.js`

```javascript
exports.uploadFile = async (file) => {
  const FormData = require('form-data');
  const fs = require('fs');
  
  const formData = new FormData();
  formData.append('file', fs.createReadStream(file.path));
  
  const response = await axios.post(
    `https://${SHOPIFY_DOMAIN}/admin/api/${API_VERSION}/files.json`,
    formData,
    {
      headers: {
        'X-Shopify-Access-Token': ADMIN_TOKEN,
        ...formData.getHeaders()
      }
    }
  );
  
  return response.data.file.url;
};
```

### Step 5: Update Flutter API Service

Add method to `api_service.dart`:

```dart
Future<String> uploadPrescription(File file) async {
  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/api/shopify/upload-prescription'),
    );
    
    request.files.add(
      await http.MultipartFile.fromPath('file', file.path),
    );
    
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    final data = json.decode(responseData);
    
    if (data['success']) {
      return data['data']['url'];
    } else {
      throw Exception(data['error']);
    }
  } catch (e) {
    throw Exception('Failed to upload prescription: $e');
  }
}
```

### Step 6: Wire It All Together

Update `_pickAndUploadFile()` in `lens_selector_drawer.dart`:

```dart
Future<void> _pickAndUploadFile() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    
    if (result != null) {
      final file = File(result.files.first.path!);
      
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('📤 Uploading prescription...'),
          duration: Duration(hours: 1), // Keep until dismissed
        ),
      );
      
      // Upload to Shopify
      final url = await ApiService().uploadPrescription(file);
      
      // Dismiss loading
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      
      setState(() {
        _uploadedFileUrl = url;
        _uploadedFileName = result.files.first.name;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Prescription uploaded!'),
          backgroundColor: Color(0xFF4caf50),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    debugPrint('Error: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
```

---

## 📊 Testing

### Test Upload File Option
1. Open app
2. Go to product page
3. Click "Select Lens"
4. Complete Steps 1-3
5. In Step 4, click "Upload File"
6. Currently shows placeholder message
7. Simulates file selection
8. Shows filename with checkmark
9. Click "Save and Continue"
10. Adds to cart with file URL

### Test Enter Manually Option
1. In Step 4, click "Enter Manually"
2. See prescription form
3. Enter power values (optional)
4. Click "Save and Continue"
5. Adds to cart with power values

### Test Email Later Option
1. In Step 4, click "Email Later"
2. See "Email Later" screen
3. Auto-proceeds to cart
4. Adds to cart with email note

---

## 🎨 UI Colors & Styling

### Colors Used
- **Selected card**: `#e8f5e9` (light green background)
- **Selected border**: `#4caf50` (green)
- **Selected icon bg**: `#4caf50` (green)
- **Normal card**: White background
- **Normal border**: `#e0e0e0` (light gray)
- **Normal icon bg**: `#f5f5f5` (very light gray)
- **Text**: `#1a2332` (dark blue-gray)

### Typography
- **Title**: 20px, Bold
- **Option labels**: 16px, Semi-bold (w600)
- **Icons**: 24px in cards, 64px+ in content areas

---

## 📦 Cart Properties Structure

All three methods add properties to cart items for tracking:

```javascript
// Cart item with prescription
{
  "variantId": "gid://shopify/ProductVariant/...",
  "quantity": 1,
  "properties": {
    "1. Lens Type": "Single Vision",
    "2. Power Type": "Anti-glare",
    "3. Lens Name": "Anti-glare",
    "Associated Frame": "gid://shopify/Product/...",
    "4. Prescription Type": "upload|manual|email",
    
    // If upload:
    "Prescription File": "https://...",
    "File Name": "prescription.pdf",
    
    // If manual:
    "left_sph": "-2.50",
    "left_cyl": "-1.00",
    // ... etc
    
    // If email:
    "Prescription Note": "Customer will email prescription later"
  }
}
```

---

## 🚀 Next Steps

1. **Add file_picker package** (`flutter pub get`)
2. **Implement backend file upload** (Shopify Files API)
3. **Add multipart/form-data support** to middleware
4. **Test file upload end-to-end**
5. **Add file validation** (size, type checking)
6. **Add loading indicators** during upload
7. **Handle upload errors** gracefully

---

## 📝 Notes

- **Current implementation**: UI complete, file picker placeholder
- **File upload**: Ready to implement with TODO comments
- **All options**: Fully functional except actual file upload
- **Cart integration**: All prescription methods properly tracked
- **User experience**: Smooth, intuitive, follows your screenshot design

---

**The UI matches your screenshot perfectly!** 🎉

Users can now choose how they want to provide their prescription, making the lens selection process more flexible and user-friendly.

---

*Updated: October 30, 2025*  
*Status: UI Complete, File Upload Ready for Implementation*

