import 'package:flutter/material.dart';

class HomepageFAQSection extends StatefulWidget {
  const HomepageFAQSection({super.key});

  @override
  State<HomepageFAQSection> createState() => _HomepageFAQSectionState();
}

class _HomepageFAQSectionState extends State<HomepageFAQSection> {
  final Set<int> _expandedFAQs = {0}; // First FAQ open by default

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FA),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          const Text(
            'Frequently Asked Questions',
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
            'Everything you need to know about Eyejack',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          
          // FAQ List
          Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: _buildFAQs(),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Contact CTA
          _buildContactCTA(),
        ],
      ),
    );
  }

  List<Widget> _buildFAQs() {
    final faqs = [
      {
        'question': 'How do I know my prescription is correct?',
        'answer': 'You can upload your prescription from your eye doctor, or we can help you place an order with your previous prescription. Our team will verify all details before processing your order.',
      },
      {
        'question': 'What if the glasses don\'t fit?',
        'answer': 'We offer a 30-day return policy. If you\'re not satisfied with the fit or style, you can return them for a full refund or exchange for a different pair.',
      },
      {
        'question': 'How long does delivery take?',
        'answer': 'Standard delivery takes 5-7 business days. We also offer express shipping options for faster delivery within 2-3 business days.',
      },
      {
        'question': 'Are your lenses scratch-resistant?',
        'answer': 'Yes! All our lenses come with scratch-resistant coating as standard. We also offer premium coatings like anti-glare, blue-light blocking, and photochromic lenses.',
      },
      {
        'question': 'Do you offer a warranty?',
        'answer': 'All our products come with a 1-year manufacturer warranty covering any defects. We also offer 30-day money-back guarantee if you\'re not satisfied.',
      },
    ];

    return List.generate(faqs.length, (index) {
      return _buildFAQItem(
        index,
        faqs[index]['question']!,
        faqs[index]['answer']!,
      );
    });
  }

  Widget _buildFAQItem(int index, String question, String answer) {
    final isExpanded = _expandedFAQs.contains(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedFAQs.remove(index);
                } else {
                  _expandedFAQs.add(index);
                }
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
                    color: const Color(0xFF27916D),
                    size: 26,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContactCTA() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF27916D).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF27916D).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.support_agent_outlined,
            size: 48,
            color: const Color(0xFF27916D),
          ),
          const SizedBox(height: 16),
          const Text(
            'Still have questions?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Our customer support team is here to help',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // TODO: Open support chat or contact form
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF27916D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Contact Support',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

