import 'package:flutter/material.dart';

class ProductSpecsWidget extends StatefulWidget {
  final Map<String, dynamic> specs;

  const ProductSpecsWidget({super.key, required this.specs});

  @override
  State<ProductSpecsWidget> createState() => _ProductSpecsWidgetState();
}

class _ProductSpecsWidgetState extends State<ProductSpecsWidget> {
  final Set<String> _expandedSections = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Product Specifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildSpecSection('Frame Description', widget.specs['frame']),
          _buildSpecSection('Lens Information', widget.specs['lens']),
          _buildSpecSection('Product Dimensions', widget.specs['dimensions']),
          _buildSpecSection('In The Box', widget.specs['inTheBox']),
        ],
      ),
    );
  }

  Widget _buildSpecSection(String title, Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return const SizedBox.shrink();
    
    final isExpanded = _expandedSections.contains(title);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedSections.remove(title);
                } else {
                  _expandedSections.add(title);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.remove : Icons.add,
                    size: 20,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            entry.value.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

