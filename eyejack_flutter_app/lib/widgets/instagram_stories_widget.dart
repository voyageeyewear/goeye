import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class InstagramStoriesWidget extends StatelessWidget {
  final Map<String, dynamic> settings;

  const InstagramStoriesWidget({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final stories = settings['stories'] as List<dynamic>? ?? [];
    final title = settings['title'] ?? 'Follow Us on Instagram';
    final subtitle = settings['subtitle'] ?? '@eyejack.in';
    
    if (stories.isEmpty) return const SizedBox.shrink();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _openInstagram(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: Color(0xFFE4405F),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFE4405F),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Stories Horizontal List
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                return _buildStoryItem(story);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(Map<String, dynamic> story) {
    final imageUrl = story['image'] ?? '';
    final link = story['link'] ?? '';
    
    return GestureDetector(
      onTap: () => _openStoryLink(link),
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Container(
              width: 90,
              height: 90,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFFFCAF45),
                    Color(0xFFE4405F),
                    Color(0xFF833AB4),
                  ],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 30, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Icon(
              Icons.camera_alt,
              size: 16,
              color: Color(0xFFE4405F),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openStoryLink(String link) async {
    if (link.isEmpty) return;
    
    try {
      final Uri uri = Uri.parse(link);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error opening story link: $e');
    }
  }

  Future<void> _openInstagram() async {
    const instagramUrl = 'https://instagram.com/eyejack.in';
    try {
      final Uri uri = Uri.parse(instagramUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error opening Instagram: $e');
    }
  }
}

