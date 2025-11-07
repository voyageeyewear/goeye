import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/collection_model.dart';
import '../screens/collection_screen.dart';

class VideoSliderWidget extends StatefulWidget {
  final Map<String, dynamic> settings;

  const VideoSliderWidget({super.key, required this.settings});

  @override
  State<VideoSliderWidget> createState() => _VideoSliderWidgetState();
}

class _VideoSliderWidgetState extends State<VideoSliderWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Map<int, VideoPlayerController?> _videoControllers = {};
  Map<int, ChewieController?> _chewieControllers = {};
  int? _playingIndex;

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _videoControllers.values) {
      controller?.dispose();
    }
    for (var controller in _chewieControllers.values) {
      controller?.dispose();
    }
    super.dispose();
  }

  Future<void> _initializeVideo(int index, String videoUrl) async {
    if (_videoControllers[index] != null) return;

    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await controller.initialize();

      final chewieController = ChewieController(
        videoPlayerController: controller,
        autoPlay: false,
        looping: false,
        aspectRatio: 9 / 16,
        showControls: true,
        placeholder: Container(
          color: Colors.black,
        ),
      );

      if (mounted) {
        setState(() {
          _videoControllers[index] = controller;
          _chewieControllers[index] = chewieController;
        });
      }
    } catch (e) {
      debugPrint('❌ Error initializing video: $e');
    }
  }

  void _handleVideoTap(int index, String link) {
    if (link.contains('/collections/')) {
      final handle = link.split('/collections/').last.split('/').first;
      final collectionName = handle
          .split('-')
          .map((s) => s[0].toUpperCase() + s.substring(1))
          .join(' ');

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CollectionScreen(
            collection: Collection(
              id: handle,
              title: collectionName,
              handle: handle,
              description: null,
              image: null,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.settings['title'] ?? 'Shop By Video';
    final videos = widget.settings['videos'] as List<dynamic>? ?? [];

    if (videos.isEmpty) return const SizedBox.shrink();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Video slider
          SizedBox(
            height: 450,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                // Pause previous video if playing
                if (_playingIndex != null && _playingIndex != index) {
                  _videoControllers[_playingIndex!]?.pause();
                  setState(() {
                    _playingIndex = null;
                  });
                }
              },
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return _buildVideoCard(
                  index,
                  video['videoUrl'] ?? '',
                  video['thumbnail'] ?? '',
                  video['title'] ?? '',
                  video['link'] ?? '',
                );
              },
            ),
          ),
          
          // Page indicators
          if (videos.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(videos.length, (index) {
                  return Container(
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? const Color(0xFF52b1e2)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(
    int index,
    String videoUrl,
    String thumbnailUrl,
    String title,
    String link,
  ) {
    final isInitialized = _videoControllers[index]?.value.isInitialized ?? false;
    final isPlaying = _playingIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => _handleVideoTap(index, link),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Video or thumbnail
                if (isInitialized && isPlaying && _chewieControllers[index] != null)
                  Chewie(controller: _chewieControllers[index]!)
                else
                  CachedNetworkImage(
                    imageUrl: thumbnailUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF52b1e2),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.black,
                      child: const Icon(
                        Icons.video_library,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                
                // Overlay gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
                
                // Play button (only if not playing)
                if (!isPlaying)
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        if (!isInitialized) {
                          await _initializeVideo(index, videoUrl);
                        }
                        if (mounted) {
                          setState(() {
                            _playingIndex = index;
                          });
                          _videoControllers[index]?.play();
                        }
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 50,
                          color: Color(0xFF52b1e2),
                        ),
                      ),
                    ),
                  ),
                
                // Title at bottom
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

