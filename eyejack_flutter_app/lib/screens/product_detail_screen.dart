import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../widgets/lens_selector_drawer.dart';
import '../widgets/sticky_cart_widget.dart';
import '../widgets/cart_drawer.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  ProductVariant? _selectedVariant;
  Map<String, dynamic>? _selectedLensOptions;
  final ScrollController _scrollController = ScrollController();
  bool _showStickyCart = false;

  @override
  void initState() {
    super.initState();
    if (widget.product.variants.isNotEmpty) {
      _selectedVariant = widget.product.variants.first;
    }

    // Show sticky cart when scrolled down
    _scrollController.addListener(() {
      final shouldShow = _scrollController.offset > 200;
      if (shouldShow != _showStickyCart) {
        setState(() {
          _showStickyCart = shouldShow;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showCartDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CartDrawer(
        onCheckout: () async {
          Navigator.pop(context); // Close cart drawer
          // TODO: Navigate to checkout
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Redirecting to checkout...'),
              backgroundColor: Color(0xFF27916D),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasNoPowerTag = widget.product.tags.contains('no-power');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.product.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: _showCartDrawer,
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {
              // TODO: Add to favorites
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {
              // TODO: Share product
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Gallery
                _buildImageGallery(),
                
                // Product Details
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Title
                      Text(
                        widget.product.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Price Section
                      _buildPriceSection(),
                      const SizedBox(height: 16),

                      // Trust Badges
                      _buildTrustBadges(),
                      const SizedBox(height: 24),

                      // Variant Selector
                      if (widget.product.variants.length > 1)
                        _buildVariantSelector(),

                      // Product Description
                      _buildDescriptionSection(),
                      const SizedBox(height: 24),

                      // Features Section
                      _buildFeaturesSection(),
                      const SizedBox(height: 24),

                      // Frame Measurements
                      _buildFrameMeasurements(),
                      
                      // Bottom padding to account for sticky cart
                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sticky Cart - Always visible on mobile
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: StickyCartWidget(
              product: widget.product,
              selectedVariant: _selectedVariant,
              selectedLensOptions: _selectedLensOptions,
              onLensSelectorPressed: hasNoPowerTag ? null : _showLensSelector,
              onAddToCart: _addToCart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = widget.product.images;
    
    if (images.isEmpty) {
      return Container(
        height: 500,
        color: Colors.grey[100],
        child: const Center(
          child: Icon(Icons.image_outlined, size: 100, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        // Main Image Carousel
        FlutterCarousel(
          options: CarouselOptions(
            height: 500,
            viewportFraction: 1.0,
            enableInfiniteScroll: images.length > 1,
            showIndicator: false,
            slideIndicator: null,
            onPageChanged: (index, reason) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
          items: images.map((image) {
            return Hero(
              tag: 'product_${widget.product.id}_$image.src}',
              child: CachedNetworkImage(
                imageUrl: image.src,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => Container(
                  color: Colors.grey[100],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[100],
                  child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                ),
              ),
            );
          }).toList(),
        ),
        
        // Thumbnail Navigation
        if (images.length > 1)
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                final isSelected = _currentImageIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: CachedNetworkImage(
                        imageUrl: images[index].src,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, size: 20),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildPriceSection() {
    final price = _selectedVariant?.price ?? widget.product.priceRange.minVariantPrice;
    final compareAtPrice = _selectedVariant?.compareAtPrice;
    
    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          price.formatted,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF27916D),
          ),
        ),
        if (compareAtPrice != null) ...[
          Text(
            compareAtPrice.formatted,
            style: TextStyle(
              fontSize: 20,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey[500],
              fontWeight: FontWeight.w400,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${_calculateDiscount(compareAtPrice, price)}% OFF',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
          ),
        ],
      ],
    );
  }

  int _calculateDiscount(Price compareAt, Price current) {
    final compareAmount = double.parse(compareAt.amount);
    final currentAmount = double.parse(current.amount);
    final discount = ((compareAmount - currentAmount) / compareAmount * 100);
    return discount.round();
  }

  Widget _buildTrustBadges() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FFF4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF27916D).withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTrustBadge(Icons.local_shipping_outlined, 'Free\nShipping'),
          _buildTrustBadge(Icons.swap_horiz, 'Easy\nReturns'),
          _buildTrustBadge(Icons.verified_outlined, 'Authentic\nProducts'),
          _buildTrustBadge(Icons.support_agent_outlined, '24/7\nSupport'),
        ],
      ),
    );
  }

  Widget _buildTrustBadge(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF27916D), size: 24),
        const SizedBox(height: 4),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[700],
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildVariantSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Color',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: widget.product.variants.map((variant) {
            final isSelected = _selectedVariant?.id == variant.id;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedVariant = variant;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  variant.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.product.description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    final features = [
      {'icon': Icons.remove_red_eye_outlined, 'title': 'UV Protection', 'subtitle': '100% UV400 Protection'},
      {'icon': Icons.layers_outlined, 'title': 'Premium Material', 'subtitle': 'High-quality acetate frame'},
      {'icon': Icons.support_agent_outlined, 'title': 'Warranty', 'subtitle': '1 Year Manufacturer Warranty'},
      {'icon': Icons.local_shipping_outlined, 'title': 'Delivery', 'subtitle': 'Free delivery across India'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Features',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ...features.map((feature) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FFF4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: const Color(0xFF27916D),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature['title'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      feature['subtitle'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildFrameMeasurements() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.straighten, color: Color(0xFF27916D), size: 20),
              SizedBox(width: 8),
              Text(
                'Frame Measurements',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMeasurement('Lens Width', '52mm'),
              _buildMeasurement('Bridge', '18mm'),
              _buildMeasurement('Temple', '145mm'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurement(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showLensSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LensSelectorDrawer(
        product: widget.product,
        onLensSelected: (lensOptions) {
          setState(() {
            _selectedLensOptions = lensOptions;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _addToCart() async {
    if (_selectedVariant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a variant'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 12),
              Text('Adding to cart...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      // Prepare line items with lens options as properties
      final variantId = _selectedVariant!.id;
      
      // If lens is selected, add BOTH lens AND frame together
      if (_selectedLensOptions != null && _selectedLensOptions!['lens'] != null) {
        final lensId = _selectedLensOptions!['lens'] as String;
        
        debugPrint('🔍 Adding lens + frame to cart together:');
        debugPrint('   Lens ID: $lensId');
        debugPrint('   Frame ID: $variantId');
        debugPrint('   Lens Type: ${_selectedLensOptions!['lensType']}');
        debugPrint('   Power Type: ${_selectedLensOptions!['powerType']}');
        debugPrint('   Power Range: ${_selectedLensOptions!['powerRange']}');
        debugPrint('   Prescription Type: ${_selectedLensOptions!['prescriptionType']}');
        
        final lensProperties = <String, dynamic>{
          '1. Lens Type': _selectedLensOptions!['lensType'] ?? '',
          '2. Power Type': _selectedLensOptions!['powerType'] ?? '',
          '3. Lens Name': _selectedLensOptions!['powerType'] ?? '', // Use power type as lens name
          'Power Range': _selectedLensOptions!['powerRange'] ?? '',
          'Associated Frame': widget.product.id, // Link to frame
          'Frame SKU': _selectedVariant!.id, // Use variant ID as SKU
          '4. Prescription Type': _selectedLensOptions!['prescriptionType'] ?? '',
        };

        // Add power values if available
        if (_selectedLensOptions!['powerValues'] != null) {
          final powerValues = _selectedLensOptions!['powerValues'] as Map<String, String>;
          powerValues.forEach((key, value) {
            lensProperties[key] = value;
          });
        }

        // Create items array (lens first, then frame - matching Shopify theme)
        final items = [
          {
            'variantId': lensId,
            'quantity': 1,
            'properties': lensProperties,
          },
          {
            'variantId': variantId,
            'quantity': 1,
            'properties': null, // Frame has no extra properties
          }
        ];

        // Add both items to cart in a single API call
        debugPrint('📦 Calling add multiple to cart...');
        await ApiService().addMultipleToCart(items: items);
        debugPrint('✅ Lens + Frame added to cart successfully!');
      } else {
        // No lens selected, just add frame
        debugPrint('📦 Adding frame only (no lens selected)...');
        await ApiService().addToCart(
          variantId: variantId,
          quantity: 1,
          properties: null,
        );
        debugPrint('✅ Frame added to cart successfully!');
      }

      if (mounted) {
        // Show success message
        final itemsAdded = _selectedLensOptions != null && _selectedLensOptions!['lens'] != null 
            ? 'Frame & Lens added' 
            : 'Added';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ $itemsAdded to cart successfully!'),
            backgroundColor: const Color(0xFF27916D),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );

        // Wait a moment, then show cart drawer
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (mounted) {
          _showCartDrawer();
        }
      }
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add to cart: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }
}
