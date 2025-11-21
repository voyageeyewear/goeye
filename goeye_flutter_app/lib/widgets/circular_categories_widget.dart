import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import '../models/collection_model.dart';
import '../screens/collection_screen.dart';

class CircularCategoriesWidget extends StatefulWidget {
  final Map<String, dynamic> settings;

  const CircularCategoriesWidget({super.key, required this.settings});

  @override
  State<CircularCategoriesWidget> createState() => _CircularCategoriesWidgetState();
}

class _CircularCategoriesWidgetState extends State<CircularCategoriesWidget> 
    with AutomaticKeepAliveClientMixin {
  final Map<String, VideoPlayerController> _videoControllers = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeVideos();
  }

  void _initializeVideos() {
    final categories = widget.settings['categories'] as List<dynamic>? ?? [];
    
    for (var i = 0; i < categories.length; i++) {
      final category = categories[i];
      final type = category['type'] as String? ?? 'image';
      final videoUrl = category['video'] as String? ?? '';
      final handle = category['handle'] as String? ?? '';
      
      if (type == 'video' && videoUrl.isNotEmpty && handle.isNotEmpty) {
        final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
        _videoControllers[handle] = controller;
        
        controller.initialize().then((_) {
          if (mounted) {
            controller.setLooping(true);
            controller.setVolume(0.0);
            controller.play();
            setState(() {});
          }
        });
      }
    }
  }

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
    
    final categories = widget.settings['categories'] as List<dynamic>? ?? [];
    
    if (categories.isEmpty) return const SizedBox.shrink();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: categories.map((category) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildCircularCategory(
                context,
                category['name'] ?? '',
                category['handle'] ?? '',
                category['type'] as String? ?? 'image',
                category['image'] ?? '',
                category['video'] as String? ?? '',
                category['badge'] as String?,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCircularCategory(
    BuildContext context,
    String name,
    String handle,
    String type,
    String imageUrl,
    String videoUrl,
    String? badge,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CollectionScreen(
              collection: Collection(
                id: handle,
                title: name,
                handle: handle,
                description: null,
                image: imageUrl.isNotEmpty 
                    ? CollectionImage(src: imageUrl) 
                    : null,
              ),
            ),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular container with FIXED size for perfect circle
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Circle container - MUST maintain aspect ratio
              AspectRatio(
                aspectRatio: 1.0,  // Perfect circle
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF52b1e2),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: ClipOval(
                      child: _buildContent(type, imageUrl, videoUrl, handle),
                    ),
                  ),
                ),
              ),
              
              // Badge
              if (badge != null && badge.isNotEmpty)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          // Name - 2 lines max
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String type, String imageUrl, String videoUrl, String handle) {
    if (type == 'video' && videoUrl.isNotEmpty) {
      final controller = _videoControllers[handle];
      
      if (controller != null && controller.value.isInitialized) {
        return FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.size.width,
            height: controller.value.size.height,
            child: VideoPlayer(controller),
          ),
        );
      } else {
        return imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: _addImageSize(imageUrl, 200),
                fit: BoxFit.cover,
                memCacheWidth: 200,
                memCacheHeight: 200,
                placeholder: (context, url) => Container(color: Colors.grey[200]),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.video_library, size: 20, color: Colors.grey),
                ),
              )
            : Container(
                color: Colors.grey[200],
                child: const Icon(Icons.video_library, size: 20, color: Colors.grey),
              );
      }
    } else {
      return imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: _addImageSize(imageUrl, 200),
              fit: BoxFit.cover,
              memCacheWidth: 200,
              memCacheHeight: 200,
              placeholder: (context, url) => Container(color: Colors.grey[200]),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.image_outlined, size: 20, color: Colors.grey),
              ),
            )
          : Container(
              color: Colors.grey[200],
              child: const Icon(Icons.category_outlined, size: 20, color: Colors.grey),
            );
    }
  }

  String _addImageSize(String url, int size) {
    if (url.contains('cdn.shopify.com')) {
      // Add Shopify image size parameter
      final separator = url.contains('?') ? '&' : '?';
      return '$url${separator}width=$size';
    }
    return url;
  }
}
