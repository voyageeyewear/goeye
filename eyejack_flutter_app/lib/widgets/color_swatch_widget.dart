import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ColorSwatchWidget extends StatefulWidget {
  final Product currentProduct;
  final Function(Product) onColorSelected;

  const ColorSwatchWidget({
    super.key,
    required this.currentProduct,
    required this.onColorSelected,
  });

  @override
  State<ColorSwatchWidget> createState() => _ColorSwatchWidgetState();
}

class _ColorSwatchWidgetState extends State<ColorSwatchWidget> {

  @override
  Widget build(BuildContext context) {
    // Extract color from current product title
    final currentColor = _extractColorFromTitle(widget.currentProduct.title);
    
    // Get related color variants
    final colorVariants = _getColorVariants();
    
    // Debug logging
    debugPrint('🎨 Color Swatch Widget Debug:');
    debugPrint('   Product Title: ${widget.currentProduct.title}');
    debugPrint('   Extracted Color: $currentColor');
    debugPrint('   Variants Count: ${colorVariants.length}');
    debugPrint('   Variants: ${colorVariants.map((v) => v['color']).join(', ')}');
    
    // Don't show widget if no color or only one variant
    if (currentColor.isEmpty || colorVariants.length <= 1) {
      debugPrint('   ❌ NOT SHOWING (color empty: ${currentColor.isEmpty}, variants: ${colorVariants.length})');
      return const SizedBox.shrink();
    }
    
    debugPrint('   ✅ SHOWING color swatches!');

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
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
          Row(
            children: colorVariants.map((variant) {
              final isSelected = variant['color'] == currentColor;
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () async {
                    if (!isSelected) {
                      _switchToColor(context, variant['color'] as String);
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: variant['hexColor'],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF27916D)
                                : Colors.grey[300]!,
                            width: isSelected ? 3 : 1.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF27916D).withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: isSelected
                            ? const Center(
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        variant['color'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.black : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _switchToColor(BuildContext context, String targetColor) async {
    try {
      debugPrint('🎨 Switching to $targetColor color variant...');
      
      // Determine product type and build search query
      String searchQuery;
      String productType;
      
      if (widget.currentProduct.title.contains('Matrix')) {
        searchQuery = 'Matrix $targetColor Square Metal Sunglasses';
        productType = 'Matrix';
      } else if (widget.currentProduct.title.contains('Classic') && 
                 widget.currentProduct.title.contains('Aviator')) {
        searchQuery = 'Classic $targetColor Aviator';
        productType = 'Classic Aviator';
      } else {
        throw Exception('Unknown product type');
      }
      
      debugPrint('🔍 Searching for: $searchQuery');
      
      final products = await ApiService().searchProducts(searchQuery);
      debugPrint('📦 Found ${products.length} products');
      
      if (products.isNotEmpty) {
        // Find the best match
        Product? matchedProduct;
        
        for (final product in products) {
          debugPrint('   - ${product.title}');
          
          // Match for Matrix products
          if (productType == 'Matrix' &&
              product.title.contains('Matrix') &&
              product.title.contains(targetColor) &&
              product.title.contains('Square Metal Sunglasses')) {
            matchedProduct = product;
            debugPrint('✅ Matched: ${product.title}');
            break;
          }
          
          // Match for Classic Aviator products
          if (productType == 'Classic Aviator' &&
              product.title.contains('Classic') &&
              product.title.contains(targetColor) &&
              product.title.contains('Aviator')) {
            matchedProduct = product;
            debugPrint('✅ Matched: ${product.title}');
            break;
          }
        }
        
        if (matchedProduct != null && mounted) {
          debugPrint('🚀 Navigating to ${matchedProduct.title}');
          widget.onColorSelected(matchedProduct);
        } else {
          throw Exception('Product not found');
        }
      } else {
        throw Exception('No products found');
      }
    } catch (e) {
      debugPrint('❌ Error switching color: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not find $targetColor variant'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  String _extractColorFromTitle(String title) {
    // Pattern 1: "Matrix - Grey Square Metal Sunglasses I RH9522CL859"
    // Pattern 2: "Classic Grey Aviator - (3025CL975)"
    // Pattern 3: "Classic Golden Aviator I Green Lense - (3025CL981)"
    
    // For Matrix products: Extract after " - "
    if (title.contains('Matrix')) {
      final parts = title.split(' - ');
      if (parts.length >= 2) {
        final afterDash = parts[1].trim();
        final color = afterDash.split(' ').first;
        return color;
      }
    }
    
    // For Classic Aviator products: Extract between "Classic " and " Aviator"
    if (title.contains('Classic') && title.contains('Aviator')) {
      final regex = RegExp(r'Classic\s+(\w+)\s+Aviator');
      final match = regex.firstMatch(title);
      if (match != null) {
        return match.group(1) ?? '';
      }
    }
    
    return '';
  }

  List<Map<String, dynamic>> _getColorVariants() {
    // Check if this is a Matrix product (RH9522CL8XX)
    if (widget.currentProduct.title.contains('Matrix') && 
        widget.currentProduct.title.contains('Square Metal Sunglasses')) {
      return [
        {
          'color': 'Grey',
          'hexColor': const Color(0xFF808080),
          'sku': 'RH9522CL859',
        },
        {
          'color': 'Black',
          'hexColor': const Color(0xFF000000),
          'sku': 'RH9522CL858',
        },
      ];
    }
    
    // Check if this is a Classic Aviator product (3025CL9XX)
    if (widget.currentProduct.title.contains('Classic') && 
        widget.currentProduct.title.contains('Aviator')) {
      return [
        {
          'color': 'Golden',
          'hexColor': const Color(0xFFFFD700), // Gold
          'sku': '3025CL981',
        },
        {
          'color': 'Silver',
          'hexColor': const Color(0xFFC0C0C0), // Silver
          'sku': '3025CL980',
        },
        {
          'color': 'Grey',
          'hexColor': const Color(0xFF808080), // Grey
          'sku': '3025CL975',
        },
        {
          'color': 'Black',
          'hexColor': const Color(0xFF000000), // Black
          'sku': '3025CL978',
        },
      ];
    }
    
    // No color variants available
    return [];
  }
}

