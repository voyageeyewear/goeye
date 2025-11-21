import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/collection_model.dart';
import '../screens/collection_screen.dart';

class GenderCategoriesWidget extends StatelessWidget {
  final Map<String, dynamic> settings;

  const GenderCategoriesWidget({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final title = settings['title'] ?? '';
    final categories = settings['categories'] as List<dynamic>? ?? [];
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          Row(
            children: categories.asMap().entries.map((entry) {
              final category = entry.value;
              return Expanded(
                child: _buildCategoryCard(context, category),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> category) {
    final label = category['label'] ?? category['name'] ?? '';
    final handle = category['handle'] ?? '';
    final image = category['image'] ?? '';
    
    // Debug: Print image URL
    debugPrint('🖼️ Gender Category: $label - Image: $image');
    
    return GestureDetector(
      onTap: () {
        if (handle.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CollectionScreen(
                collection: Collection(
                  id: handle,
                  title: label,
                  handle: handle,
                  description: null,
                  image: image.isNotEmpty ? CollectionImage(src: image) : null,
                ),
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: image.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          debugPrint('❌ Image Error for $label: $error');
                          debugPrint('   URL: $url');
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error, color: Colors.red, size: 20),
                                  const SizedBox(height: 4),
                                  Text(
                                    label,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

