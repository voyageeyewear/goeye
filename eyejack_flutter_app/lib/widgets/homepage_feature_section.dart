import 'package:flutter/material.dart';

class HomepageFeatureSection extends StatelessWidget {
  const HomepageFeatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FA),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          // Section Title
          const Text(
            'Why Choose Eyejack?',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Premium eyewear designed for modern living',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          
          // Feature Grid
          _buildFeatureGrid(),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      {
        'icon': Icons.remove_red_eye_outlined,
        'title': 'Premium Lenses',
        'description': 'High-quality lenses with UV400 protection and anti-glare coating',
        'color': const Color(0xFF2196F3),
      },
      {
        'icon': Icons.palette_outlined,
        'title': 'Stylish Designs',
        'description': 'Trendy frames that complement every face shape and style',
        'color': const Color(0xFF9C27B0),
      },
      {
        'icon': Icons.verified_user_outlined,
        'title': 'Quality Assured',
        'description': '1-year warranty and 30-day money-back guarantee',
        'color': const Color(0xFF27916D),
      },
      {
        'icon': Icons.local_shipping_outlined,
        'title': 'Free Shipping',
        'description': 'Free delivery on all orders across India',
        'color': const Color(0xFFFF9800),
      },
      {
        'icon': Icons.support_agent_outlined,
        'title': '24/7 Support',
        'description': 'Dedicated customer support always ready to help',
        'color': const Color(0xFFE91E63),
      },
      {
        'icon': Icons.currency_rupee,
        'title': 'Best Prices',
        'description': 'Competitive pricing with regular offers and discounts',
        'color': const Color(0xFF00BCD4),
      },
    ];

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: features.map((feature) {
        return _buildFeatureCard(
          feature['icon'] as IconData,
          feature['title'] as String,
          feature['description'] as String,
          feature['color'] as Color,
        );
      }).toList(),
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 32,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

