import 'package:flutter/material.dart';
import '../models/product_model.dart';

class StickyCartWidget extends StatelessWidget {
  final Product product;
  final ProductVariant? selectedVariant;
  final Map<String, dynamic>? selectedLensOptions;
  final VoidCallback? onLensSelectorPressed;
  final VoidCallback onAddToCart;

  const StickyCartWidget({
    super.key,
    required this.product,
    this.selectedVariant,
    this.selectedLensOptions,
    this.onLensSelectorPressed,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // Only show on mobile
    if (MediaQuery.of(context).size.width >= 768) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Section 1: Promotional Banner
            _buildSection1PromoBanner(),

            // Section 2: Action Buttons
            _buildSection2ActionButtons(),
          ],
        ),
      ),
    );
  }

  /// SECTION 1: Promotional Banner (Diwali/Offer Theme)
  Widget _buildSection1PromoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3a9ccf), Color(0xFF4ECDC4)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Promo Text
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.local_offer,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'BUY 2 AT FLAT 1299/-',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Price
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              selectedVariant?.price.formatted ?? product.priceRange.minVariantPrice.formatted,
              style: const TextStyle(
                color: Color(0xFF27916D),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// SECTION 2: Main Action Buttons
  Widget _buildSection2ActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          // Lens Selector Button (if applicable)
          if (onLensSelectorPressed != null)
            Expanded(
              flex: 5,
              child: ElevatedButton(
                onPressed: onLensSelectorPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722), // ORANGE to verify new code!
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.remove_red_eye_outlined, size: 18),
                    const SizedBox(width: 8),
                    const Flexible(
                      child: Text(
                        'Free Lens+Frame',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (selectedLensOptions != null) ...[
                      const SizedBox(width: 4),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

          if (onLensSelectorPressed != null) const SizedBox(width: 8),

          // Add to Cart Button
          Expanded(
            flex: onLensSelectorPressed != null ? 5 : 10,
            child: ElevatedButton(
              onPressed: product.availableForSale ? onAddToCart : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[400],
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    product.availableForSale
                        ? Icons.shopping_cart_outlined
                        : Icons.block,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      product.availableForSale ? 'Add to Cart' : 'Sold Out',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

