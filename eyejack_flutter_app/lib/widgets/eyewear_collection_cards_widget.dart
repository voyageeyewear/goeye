import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';

class EyewearCollectionCardsWidget extends StatefulWidget {
  final Map<String, dynamic> settings;

  const EyewearCollectionCardsWidget({super.key, required this.settings});

  @override
  State<EyewearCollectionCardsWidget> createState() => _EyewearCollectionCardsWidgetState();
}

class _EyewearCollectionCardsWidgetState extends State<EyewearCollectionCardsWidget>
    with AutomaticKeepAliveClientMixin {
  final Map<int, VideoPlayerController> _videoControllers = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    final title = widget.settings['title'] ?? '';
    final collections = widget.settings['collections'] as List<dynamic>? ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,  // Changed from 1.5 to 0.9 for more height
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: collections.length,
            itemBuilder: (context, index) {
              final collection = collections[index];
              return _buildCollectionCard(context, collection);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionCard(BuildContext context, Map<String, dynamic> collection) {
    final name = collection['name'] ?? '';
    final subtitle = collection['subtitle'] ?? '';
    final backgroundType = collection['backgroundType'] ?? 'gradient';
    final backgroundUrl = collection['backgroundUrl'] ?? '';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navigate to collection
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background (video, image, or gradient)
            _buildBackground(backgroundType, backgroundUrl),
            
            // Lighter overlay for better visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),  // Reduced from 0.3
                    Colors.black.withOpacity(0.3),  // Reduced from 0.7
                  ],
                ),
              ),
            ),
            
            // Text content
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground(String type, String url) {
    if (type == 'video' && url.isNotEmpty) {
      return _VideoBackground(url: url);
    } else if (type == 'image' && url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: _addImageSize(url, 600),
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 300),
        placeholder: (context, url) => Container(color: Colors.grey[300]),
        memCacheWidth: 600,  // Optimize image loading
        memCacheHeight: 800,
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple.withOpacity(0.3),
                Colors.blue.withOpacity(0.3),
              ],
            ),
          ),
        ),
      );
    } else {
      // Default gradient
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.withOpacity(0.3),
              Colors.blue.withOpacity(0.3),
            ],
          ),
        ),
      );
    }
  }

  String _addImageSize(String url, int size) {
    if (url.contains('cdn.shopify.com')) {
      // Add Shopify image size parameter for optimization
      final separator = url.contains('?') ? '&' : '?';
      return '$url${separator}width=$size';
    }
    return url;
  }
}

// Stateful widget for video background
class _VideoBackground extends StatefulWidget {
  final String url;

  const _VideoBackground({required this.url});

  @override
  State<_VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<_VideoBackground> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
      await _controller.initialize();
      _controller.setLooping(true);
      _controller.setVolume(0.0); // Mute
      _controller.play();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(color: Colors.black);
    }

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _controller.value.size.width,
        height: _controller.value.size.height,
        child: VideoPlayer(_controller),
      ),
    );
  }
}

