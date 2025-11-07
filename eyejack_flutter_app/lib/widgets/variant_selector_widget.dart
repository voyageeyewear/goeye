import 'package:flutter/material.dart';
import '../models/product_model.dart';

class VariantSelectorWidget extends StatelessWidget {
  final List<ProductVariant> variants;
  final ProductVariant? selectedVariant;
  final Function(ProductVariant) onVariantSelected;

  const VariantSelectorWidget({
    super.key,
    required this.variants,
    required this.selectedVariant,
    required this.onVariantSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (variants.isEmpty) return const SizedBox.shrink();
    if (variants.length == 1) return const SizedBox.shrink(); // Hide if only one variant

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Variant',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: variants.map((variant) {
              final isSelected = selectedVariant?.id == variant.id;
              return _buildSimpleVariantOption(variant.title, isSelected, variant);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleVariantOption(String title, bool isSelected, ProductVariant variant) {
    return GestureDetector(
      onTap: () => onVariantSelected(variant),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[400]!,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

}

