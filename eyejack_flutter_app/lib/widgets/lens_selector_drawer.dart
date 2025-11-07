import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class LensSelectorDrawer extends StatefulWidget {
  final Product product;
  final Function(Map<String, dynamic>) onLensSelected;

  const LensSelectorDrawer({
    super.key,
    required this.product,
    required this.onLensSelected,
  });

  @override
  State<LensSelectorDrawer> createState() => _LensSelectorDrawerState();
}

class _LensSelectorDrawerState extends State<LensSelectorDrawer>
    with SingleTickerProviderStateMixin {
  int _currentStep = 1;
  String? _selectedLensType;
  String? _selectedPowerType;
  String? _selectedLens;
  final Map<String, String> _powerValues = {};
  bool _isAddingToCart = false; // Track cart addition state
  
  // Prescription entry method
  String? _prescriptionMethod; // 'upload', 'manual', 'email'
  String? _uploadedFileUrl; // CDN URL of uploaded prescription
  String? _uploadedFileName;
  
  // Real lens data from Shopify - categorized
  List<Map<String, dynamic>> _antiGlareLenses = [];
  List<Map<String, dynamic>> _blueBlockLenses = [];
  List<Map<String, dynamic>> _colourLenses = [];
  bool _isLoadingLenses = false;
  String? _lensLoadError;
  
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
    
    // Fetch real lens options from Shopify
    _fetchLensOptions();
  }
  
  Future<void> _fetchLensOptions() async {
    setState(() {
      _isLoadingLenses = true;
      _lensLoadError = null;
    });

    try {
      final categorizedLenses = await ApiService().fetchLensOptions();
      if (mounted) {
        setState(() {
          _antiGlareLenses = categorizedLenses['antiGlareLenses'] ?? [];
          _blueBlockLenses = categorizedLenses['blueBlockLenses'] ?? [];
          _colourLenses = categorizedLenses['colourLenses'] ?? [];
          _isLoadingLenses = false;
        });
        debugPrint('✅ Loaded lenses: Anti-glare ${_antiGlareLenses.length}, Blue-block ${_blueBlockLenses.length}, Colour ${_colourLenses.length}');
      }
    } catch (e) {
      debugPrint('Error fetching lens options: $e');
      if (mounted) {
        setState(() {
          _isLoadingLenses = false;
          _lensLoadError = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(_slideAnimation),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.92,
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Modern Handle Bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            
            // Header with Title and Close
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Your Lens',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Step $_currentStep of 4',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 24),
                      color: Colors.black87,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),

            // Step Progress Indicators
            _buildStepIndicators(),

            // Progress Bar
            _buildProgressBar(),

            // Content
            Expanded(
              child: _buildStepContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicators() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepIndicator(1, 'Lens\nType'),
          _buildConnector(1),
          _buildStepIndicator(2, 'Power\nType'),
          _buildConnector(2),
          _buildStepIndicator(3, 'Select\nLens'),
          _buildConnector(3),
          _buildStepIndicator(4, 'Add\nPower'),
        ],
      ),
    );
  }

  Widget _buildConnector(int afterStep) {
    final isCompleted = _currentStep > afterStep;
    return Container(
      width: 30,
      height: 2,
      margin: const EdgeInsets.only(bottom: 40),
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFF27916D) : Colors.grey[300],
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep == step;
    final isCompleted = _currentStep > step;
    
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isActive || isCompleted
                ? const Color(0xFF27916D)
                : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive || isCompleted
                  ? const Color(0xFF27916D)
                  : Colors.grey[300]!,
              width: 2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF27916D).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 22)
                : Text(
                    '$step',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey[600],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 60,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? const Color(0xFF27916D) : Colors.grey[600],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    final progress = _currentStep / 4; // Changed from 6 to 4 steps
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF27916D),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1LensType();
      case 2:
        return _buildStep2PowerType();
      case 3:
        return _buildStep3Lenses(); // Select Lens Package
      case 4:
        return _buildStep4AddPower(); // Add Power + Save & Continue (adds to cart)
      default:
        return const SizedBox.shrink();
    }
  }

  // STEP 1: Lens Type Selection
  Widget _buildStep1LensType() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose your Lens Type:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Prepaid Notice
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1976D2).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.payment,
                    color: Color(0xFF1976D2),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lenses: Prepaid Payment Required',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Lenses require prepaid payment • Frames & other products available with COD',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Single Vision Option
          _buildLensTypeOption(
            type: 'single-vision',
            title: 'With power/Single Vision',
            subtitle: 'Standard lens type • Prepaid orders only',
            iconUrl: 'https://cdn.shopify.com/s/files/1/0570/8120/0663/files/Screenshot_2025-05-23_at_10.57.04_AM.png',
          ),
          const SizedBox(height: 16),

          // Zero Power Option
          _buildLensTypeOption(
            type: 'zero-power',
            title: 'Zero power',
            subtitle: 'No power required • Prepaid orders only',
            iconUrl: 'https://cdn.shopify.com/s/files/1/0570/8120/0663/files/Screenshot_2025-05-23_at_10.57.14_AM.png',
          ),
          const SizedBox(height: 16),

          // Frame Only Option
          _buildFrameOnlyOption(),
        ],
      ),
    );
  }

  Widget _buildLensTypeOption({
    required String type,
    required String title,
    required String subtitle,
    required String iconUrl,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLensType = type;
          _currentStep = 2;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF0FFF4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.remove_red_eye_outlined,
                color: Color(0xFF27916D),
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF102047),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrameOnlyOption() {
    return GestureDetector(
      onTap: () {
        // Frame only - immediately add to cart
        widget.onLensSelected({
          'lensType': 'frame-only',
          'isFrameOnly': true,
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FFF4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF27916D).withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF27916D).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Shopping Cart Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: Color(0xFF27916D),
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '🛒 Frame Only',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF27916D),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Quick Add',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Just the frame, no lenses',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow
            const Icon(
              Icons.arrow_forward,
              color: Color(0xFF27916D),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // STEP 2: Power Type Selection (matching Shopify theme)
  Widget _buildStep2PowerType() {
    // Power types based on Shopify theme
    final powerTypes = _selectedLensType == 'zero-power'
        ? [
            {'type': 'blue-block', 'title': 'Blue Block Lenses', 'subtitle': 'Positive, Negative or Cylindrical', 'badge': 'Most common'},
          ]
        : [
            {'type': 'anti-glare', 'title': 'Anti glare lenses', 'subtitle': 'Positive, Negative or Cylindrical', 'badge': 'Most common'},
            {'type': 'blue-block', 'title': 'Blue Block Lenses', 'subtitle': 'Positive, Negative or Cylindrical', 'badge': 'Most common'},
            {'type': 'colour', 'title': 'Colour Lenses', 'subtitle': 'Positive, Negative or Cylindrical', 'badge': ''},
          ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentStep = 1;
                    _selectedPowerType = null;
                  });
                },
              ),
              const Text(
                'Choose your Power Type:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          ...powerTypes.map((power) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildPowerTypeOption(
              type: power['type']!,
              title: power['title']!,
              subtitle: power['subtitle']!,
              badge: power['badge']!,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPowerTypeOption({
    required String type,
    required String title,
    required String subtitle,
    required String badge,
  }) {
    return GestureDetector(
      onTap: () {
        print('🔵 Power type selected: $type');
        print('🔵 Current step before: $_currentStep');
        setState(() {
          _selectedPowerType = type;
          _currentStep = 3;
          print('🔵 Current step after: $_currentStep');
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF0FFF4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.visibility_outlined,
                color: Color(0xFF27916D),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      if (badge.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2F1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF00796B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF102047),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // STEP 3: Lens Selection
  Widget _buildStep3Lenses() {
    // Show loading state if lenses are being fetched
    if (_isLoadingLenses) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _currentStep = 3; // Changed from 2 to 3
                      _selectedLens = null;
                    });
                  },
                ),
                const Text(
                  'Select Lens Package:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading lens options...'),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Show error message if loading failed
    if (_lensLoadError != null && _antiGlareLenses.isEmpty && _blueBlockLenses.isEmpty && _colourLenses.isEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _currentStep = 2;
                      _selectedLens = null;
                    });
                  },
                ),
                const Text(
                  'Select Lens Package:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Failed to load lens options'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchLensOptions,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Filter lenses based on selected power type
    List<Map<String, dynamic>> filteredLenses = [];
    String lensTypeTitle = 'Select Lens Package:';
    
    switch (_selectedPowerType) {
      case 'anti-glare':
        filteredLenses = _antiGlareLenses;
        lensTypeTitle = 'Anti Glare Lenses';
        break;
      case 'blue-block':
        filteredLenses = _blueBlockLenses;
        lensTypeTitle = 'Blue Block Lenses';
        break;
      case 'colour':
        filteredLenses = _colourLenses;
        lensTypeTitle = 'Colour Lenses';
        break;
      default:
        filteredLenses = _antiGlareLenses;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentStep = 2;
                    _selectedLens = null;
                  });
                },
              ),
              Expanded(
                child: Text(
                  lensTypeTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (filteredLenses.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Text(
                  'No lenses available for this type',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else
            ...filteredLenses.map((lens) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildLensOption(
                id: lens['id']!.toString(),
                name: lens['name']!.toString(),
                price: '₹${lens['price']}',
                features: (lens['features'] as List?)?.map((e) => e.toString()).toList() ?? [],
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildLensOption({
    required String id,
    required String name,
    required String price,
    required List<String> features,
  }) {
    final isSelected = _selectedLens == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLens = id;
          if (_selectedLensType == 'zero-power') {
            // Zero power - go directly to add power step
            _currentStep = 4;
          } else {
            _currentStep = 4; // Go to add power step
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0FFF4) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF27916D) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF27916D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF27916D),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    feature,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  // STEP 4: Add Your Prescription
  Widget _buildStep4AddPower() {
    // If no method selected, show options
    if (_prescriptionMethod == null) {
      return _buildPrescriptionOptions();
    }
    
    // If method selected, show relevant content
    switch (_prescriptionMethod) {
      case 'manual':
        return _buildManualPrescriptionForm();
      case 'upload':
        return _buildUploadPrescription();
      case 'email':
        return _buildEmailLaterOption();
      default:
        return _buildPrescriptionOptions();
    }
  }

  // Prescription method selection screen
  Widget _buildPrescriptionOptions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentStep = 3; // Back to lens selection
                  });
                },
              ),
              const Text(
                'Add Your Prescription',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1a2332),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Upload File Option
          _buildPrescriptionOptionCard(
            icon: Icons.upload_file,
            title: 'Upload File',
            isSelected: false,
            onTap: () {
              setState(() {
                _prescriptionMethod = 'upload';
              });
            },
          ),
          const SizedBox(height: 16),

          // Enter Manually Option (Highlighted)
          _buildPrescriptionOptionCard(
            icon: Icons.edit,
            title: 'Enter Manually',
            isSelected: false,
            onTap: () {
              setState(() {
                _prescriptionMethod = 'manual';
              });
            },
          ),
          const SizedBox(height: 16),

          // Email Later Option
          _buildPrescriptionOptionCard(
            icon: Icons.email,
            title: 'Email Later',
            isSelected: false,
            onTap: () {
              setState(() {
                _prescriptionMethod = 'email';
              });
              // Proceed to save
              _saveAndAddToCart();
            },
          ),
        ],
      ),
    );
  }

  // Prescription option card widget
  Widget _buildPrescriptionOptionCard({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFe8f5e9) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF4caf50) : const Color(0xFFe0e0e0),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF4caf50) : const Color(0xFFf5f5f5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF424242),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF1a2332) : const Color(0xFF424242),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Manual prescription entry form
  Widget _buildManualPrescriptionForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _prescriptionMethod = null; // Back to options
                  });
                },
              ),
              const Text(
                'Enter Prescription (Optional):',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Left Eye
          const Text(
            'Left Eye (OS)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _buildPowerInput('Left SPH', 'left_sph'),
          const SizedBox(height: 12),
          _buildPowerInput('Left CYL', 'left_cyl'),
          const SizedBox(height: 12),
          _buildPowerInput('Left Axis', 'left_axis'),
          const SizedBox(height: 24),

          // Right Eye
          const Text(
            'Right Eye (OD)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _buildPowerInput('Right SPH', 'right_sph'),
          const SizedBox(height: 12),
          _buildPowerInput('Right CYL', 'right_cyl'),
          const SizedBox(height: 12),
          _buildPowerInput('Right Axis', 'right_axis'),
          const SizedBox(height: 32),

          // Save and Continue Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isAddingToCart ? null : _saveAndAddToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5722),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isAddingToCart
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Save and Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Upload prescription file
  Widget _buildUploadPrescription() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _prescriptionMethod = null; // Back to options
                    _uploadedFileUrl = null;
                    _uploadedFileName = null;
                  });
                },
              ),
              const Text(
                'Upload Prescription',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Upload area
          GestureDetector(
            onTap: _pickAndUploadFile,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFf5f5f5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFe0e0e0),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: _uploadedFileName == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tap to upload prescription',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'PDF, JPG, PNG (Max 5MB)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 48,
                          color: Color(0xFF4caf50),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _uploadedFileName!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _pickAndUploadFile,
                          child: const Text('Change file'),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 32),

          // Save and Continue Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _uploadedFileName != null && !_isAddingToCart
                  ? _saveAndAddToCart
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5722),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: _isAddingToCart
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Save and Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Email later option
  Widget _buildEmailLaterOption() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Icon(
            Icons.email_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          const Text(
            'Email Later',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'We\'ll send you an email to upload your prescription after your purchase.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          const Text(
            'Proceeding to cart...',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4caf50),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Pick and upload file to Shopify
  Future<void> _pickAndUploadFile() async {
    try {
      // Note: file_picker package needs to be added to pubspec.yaml
      // For now, showing a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('📎 File picker will be implemented with file_picker package'),
          backgroundColor: Color(0xFF2196F3),
        ),
      );

      // TODO: Implement actual file picker and upload
      // final result = await FilePicker.platform.pickFiles(
      //   type: FileType.custom,
      //   allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      // );
      
      // if (result != null) {
      //   final file = result.files.first;
      //   // Upload to Shopify Files API
      //   final url = await _uploadToShopify(file);
      //   setState(() {
      //     _uploadedFileUrl = url;
      //     _uploadedFileName = file.name;
      //   });
      // }

      // For demonstration, simulate file upload
      setState(() {
        _uploadedFileName = 'prescription_demo.pdf';
        _uploadedFileUrl = 'https://eyejack.in/cdn/shop/files/prescription.pdf';
      });
    } catch (e) {
      debugPrint('Error picking file: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _buildPowerInput(String label, String key) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF27916D), width: 2),
        ),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        _powerValues[key] = value;
      },
    );
  }

  // Add lens + frame to cart automatically when "Save and Continue" is clicked
  Future<void> _saveAndAddToCart() async {
    if (_selectedLens == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a lens first')),
      );
      return;
    }

    setState(() {
      _isAddingToCart = true;
    });

    try {
      // Prepare lens properties
      final lensProperties = <String, dynamic>{
        '1. Lens Type': _selectedLensType ?? '',
        '2. Power Type': _selectedPowerType ?? '',
        '3. Lens Name': _selectedPowerType ?? '',
        'Associated Frame': widget.product.id,
        '4. Prescription Type': _prescriptionMethod ?? 'manual',
      };

      // Add prescription details based on method
      if (_prescriptionMethod == 'manual') {
        // Add power values if entered
        if (_powerValues.isNotEmpty) {
          _powerValues.forEach((key, value) {
            if (value.isNotEmpty) {
              lensProperties[key] = value;
            }
          });
        }
      } else if (_prescriptionMethod == 'upload') {
        // Add uploaded file info
        if (_uploadedFileUrl != null) {
          lensProperties['Prescription File'] = _uploadedFileUrl!;
          lensProperties['File Name'] = _uploadedFileName ?? 'prescription';
        }
      } else if (_prescriptionMethod == 'email') {
        // Mark as email later
        lensProperties['Prescription Note'] = 'Customer will email prescription later';
      }

      // Get frame variant ID (first variant or selected variant)
      final frameVariantId = widget.product.variants.isNotEmpty
          ? widget.product.variants.first.id
          : widget.product.id;

      // Create items array (lens first, then frame)
      final items = [
        {
          'variantId': _selectedLens!,
          'quantity': 1,
          'properties': lensProperties,
        },
        {
          'variantId': frameVariantId,
          'quantity': 1,
          'properties': null,
        }
      ];

      debugPrint('🛒 Adding lens + frame to cart from lens selector...');
      await ApiService().addMultipleToCart(items: items);
      debugPrint('✅ Successfully added lens + frame to cart!');

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Frame & Lens added to cart!'),
            backgroundColor: Color(0xFF27916D),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Call the callback to notify parent
        widget.onLensSelected({
          'lensType': _selectedLensType,
          'powerType': _selectedPowerType,
          'lens': _selectedLens,
          'powerValues': _powerValues,
        });

        // Close the drawer after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    } catch (e) {
      debugPrint('❌ Error adding to cart: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }
}

