import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ProductVideoWidget extends StatefulWidget {
  final List<String> videoUrls;

  const ProductVideoWidget({super.key, required this.videoUrls});

  @override
  State<ProductVideoWidget> createState() => _ProductVideoWidgetState();
}

class _ProductVideoWidgetState extends State<ProductVideoWidget> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  int _currentVideoIndex = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrls.isNotEmpty) {
      _initializeVideo(_currentVideoIndex);
    }
  }

  Future<void> _initializeVideo(int index) async {
    if (index >= widget.videoUrls.length) return;

    // Dispose previous controllers
    _chewieController?.dispose();
    _videoController?.dispose();

    setState(() {
      _isInitialized = false;
    });

    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrls[index]),
      );

      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        aspectRatio: 16 / 9,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              'Error loading video',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      );

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('❌ Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoUrls.isEmpty) return const SizedBox.shrink();

    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Product Videos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _isInitialized && _chewieController != null
                ? Chewie(controller: _chewieController!)
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
          ),
          if (widget.videoUrls.length > 1)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: List.generate(widget.videoUrls.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentVideoIndex = index;
                      });
                      _initializeVideo(index);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _currentVideoIndex == index
                            ? const Color(0xFF27916D)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Video ${index + 1}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _currentVideoIndex == index
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

