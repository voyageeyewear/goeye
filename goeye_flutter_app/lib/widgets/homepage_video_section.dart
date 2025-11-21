import 'package:flutter/material.dart';

class HomepageVideoSection extends StatelessWidget {
  const HomepageVideoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          const Text(
            'See How It Works',
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
            'Discover how easy it is to find your perfect eyewear',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          
          // Video Placeholder
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1574258495973-f010dfbb5371?w=800',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Overlay
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    // Play Button
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        size: 48,
                        color: Color(0xFF27916D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Process Steps
          _buildProcessSteps(),
        ],
      ),
    );
  }

  Widget _buildProcessSteps() {
    final steps = [
      {
        'number': '1',
        'title': 'Browse',
        'description': 'Explore our collection of premium eyewear',
      },
      {
        'number': '2',
        'title': 'Try On',
        'description': 'Use our virtual try-on feature',
      },
      {
        'number': '3',
        'title': 'Customize',
        'description': 'Add your prescription and lens options',
      },
      {
        'number': '4',
        'title': 'Enjoy',
        'description': 'Receive your perfect glasses at home',
      },
    ];

    return Wrap(
      spacing: 30,
      runSpacing: 30,
      alignment: WrapAlignment.center,
      children: steps.map((step) {
        return _buildStepCard(
          step['number'] as String,
          step['title'] as String,
          step['description'] as String,
        );
      }).toList(),
    );
  }

  Widget _buildStepCard(String number, String title, String description) {
    return Container(
      width: 140,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF27916D),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
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

