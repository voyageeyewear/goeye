import 'package:flutter/material.dart';

class ProductFAQWidget extends StatefulWidget {
  final List<Map<String, String>> faqs;

  const ProductFAQWidget({super.key, required this.faqs});

  @override
  State<ProductFAQWidget> createState() => _ProductFAQWidgetState();
}

class _ProductFAQWidgetState extends State<ProductFAQWidget> {
  final Set<int> _expandedFAQs = {};

  @override
  Widget build(BuildContext context) {
    if (widget.faqs.isEmpty) return const SizedBox.shrink();

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.help_outline, color: Color(0xFF27916D), size: 20),
              SizedBox(width: 8),
              Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(widget.faqs.length, (index) {
            return _buildFAQItem(index, widget.faqs[index]);
          }),
        ],
      ),
    );
  }

  Widget _buildFAQItem(int index, Map<String, String> faq) {
    final isExpanded = _expandedFAQs.contains(index);
    final question = faq['question'] ?? '';
    final answer = faq['answer'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
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
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
                    size: 24,
                    color: const Color(0xFF27916D),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

