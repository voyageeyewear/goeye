import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo and Description
          Center(
            child: Column(
              children: [
                Image.network(
                  'https://goeye.in/cdn/shop/files/colored-logo.png',
                  height: 60,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'GOEYE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  'Premium Eyewear Collection',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Quick Links
          _buildFooterSection(
            'Quick Links',
            [
              {'title': 'About Us', 'url': 'https://goeye.in/pages/about-us'},
              {'title': 'Contact Us', 'url': 'https://goeye.in/pages/contact'},
              {'title': 'Track Order', 'url': 'https://goeye.in/pages/track-order'},
              {'title': 'Shipping Policy', 'url': 'https://goeye.in/policies/shipping-policy'},
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Customer Service
          _buildFooterSection(
            'Customer Service',
            [
              {'title': 'Return & Exchange', 'url': 'https://goeye.in/policies/refund-policy'},
              {'title': 'Privacy Policy', 'url': 'https://goeye.in/policies/privacy-policy'},
              {'title': 'Terms of Service', 'url': 'https://goeye.in/policies/terms-of-service'},
              {'title': 'FAQ', 'url': 'https://goeye.in/pages/faq'},
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Social Media
          const Text(
            'Follow Us',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildSocialIcon(Icons.facebook, 'https://facebook.com/goeyeindia'),
              _buildSocialIcon(Icons.camera_alt, 'https://instagram.com/goeye.in'),
              _buildSocialIcon(Icons.phone, 'https://wa.me/919876543210'),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Contact Info
          const Text(
            'Contact Info',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Email: support@goeye.in\nPhone: +91 98765 43210',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Copyright
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '© ${DateTime.now().year} Goeye. All rights reserved.',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(String title, List<Map<String, String>> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...links.map((link) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () => _launchURL(link['url']!),
              child: Text(
                link['title']!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () => _launchURL(url),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white30, width: 1),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

