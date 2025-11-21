import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/collection_model.dart';
import '../screens/collection_screen.dart';

class HeroSliderWidget extends StatefulWidget {
  final Map<String, dynamic> settings;

  const HeroSliderWidget({super.key, required this.settings});

  @override
  State<HeroSliderWidget> createState() => _HeroSliderWidgetState();
}

class _HeroSliderWidgetState extends State<HeroSliderWidget> {
  VideoPlayerController? _currentVideoController;
  ChewieController? _currentChewieController;
  int _currentSlideIndex = 0;
  int? _currentVideoIndex;

  @override
  void initState() {
    super.initState();
    _initializeCurrentSlide();
  }

  @override
  void didUpdateWidget(covariant HeroSliderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings) {
      _disposeCurrentVideo();
      _currentSlideIndex = 0;
      _currentVideoIndex = null;
      _initializeCurrentSlide();
    }
  }

  void _initializeCurrentSlide() {
    final slides = widget.settings['slides'] as List<dynamic>? ?? [];
    if (_currentSlideIndex < slides.length) {
      final slide = slides[_currentSlideIndex];
      final slideType = slide['type'] ?? 'image';
      
      if (slideType == 'video') {
        _initializeVideo(_currentSlideIndex, slide);
      }
    }
  }

  Future<void> _initializeVideo(int index, Map<String, dynamic> slide) async {
    final videoUrl = slide['videoUrl'] ?? '';
    if (videoUrl.isEmpty) return;

    // Dispose previous video if exists
    _disposeCurrentVideo();

    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await controller.initialize();
      
      if (!mounted) {
        controller.dispose();
        return;
      }

      controller.setLooping(true);
      controller.setVolume(0);

      final chewie = ChewieController(
        videoPlayerController: controller,
        autoInitialize: true,
        autoPlay: true,
        looping: true,
        showControls: false,
        allowFullScreen: false,
        allowMuting: false,
        allowPlaybackSpeedChanging: false,
        aspectRatio: controller.value.aspectRatio == 0 ? 16 / 9 : controller.value.aspectRatio,
      );

      if (mounted) {
        setState(() {
          _currentVideoController = controller;
          _currentChewieController = chewie;
          _currentVideoIndex = index;
        });
      } else {
        controller.dispose();
        chewie.dispose();
      }
    } catch (e) {
      debugPrint('Error loading video $index: $e');
    }
  }

  void _disposeCurrentVideo() {
    _currentChewieController?.dispose();
    _currentVideoController?.dispose();
    _currentChewieController = null;
    _currentVideoController = null;
    _currentVideoIndex = null;
  }

  Future<void> _onSlideChanged(int index) async {
    if (_currentSlideIndex == index) return;

    setState(() {
      _currentSlideIndex = index;
    });

    final slides = widget.settings['slides'] as List<dynamic>? ?? [];
    if (index < slides.length) {
      final slide = slides[index];
      final slideType = slide['type'] ?? 'image';
      
      if (slideType == 'video') {
        await _initializeVideo(index, slide);
      } else {
        _disposeCurrentVideo();
      }
    }
  }

  @override
  void dispose() {
    _disposeCurrentVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = widget.settings['slides'] as List<dynamic>? ?? [];
    final autoplay = widget.settings['autoplay'] ?? true;
    final autoplaySpeed = widget.settings['autoplaySpeed'] ?? 5000;
    final showDots = widget.settings['showDots'] ?? true;
    
    if (slides.isEmpty) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;
    
    // Full-height slider to match live site (memory optimized via single video controller)
    final sliderHeight = isMobile 
        ? (screenHeight * 0.65).clamp(450.0, 700.0)  // 65% of screen height for full view
        : 600.0;  // Desktop height

    return SizedBox(
      height: sliderHeight,
      width: double.infinity,
      child: Stack(
        children: [
          FlutterCarousel(
            options: CarouselOptions(
              height: sliderHeight,
              viewportFraction: 1.0,
              autoPlay: autoplay,
              autoPlayInterval: Duration(milliseconds: autoplaySpeed),
              showIndicator: false,
              enableInfiniteScroll: slides.length > 1,
              onPageChanged: (index, reason) {
                // Fire-and-forget async slide change handler
                _onSlideChanged(index);
              },
            ),
            items: slides.asMap().entries.map((entry) {
              final index = entry.key;
              final slide = entry.value;
              final slideType = slide['type'] ?? 'image';

              if (slideType == 'video') {
                return _buildVideoSlide(index, slide, isMobile);
              } else {
                return _buildImageSlide(slide, isMobile);
              }
            }).toList(),
          ),
          
          // Dot Indicators
          if (showDots && slides.length > 1)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  slides.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentSlideIndex
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoSlide(int index, Map<String, dynamic> slide, bool isMobile) {
    final isCurrentVideo = _currentVideoIndex == index;
    final controller = isCurrentVideo ? _currentVideoController : null;
    final chewie = isCurrentVideo ? _currentChewieController : null;
    final linkUrl = slide['link'] ?? '';
    
    Widget videoWidget = Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (chewie != null && (controller?.value.isInitialized ?? false))
            FittedBox(
              fit: BoxFit.contain, // Changed from cover to contain - prevents side cropping
              child: SizedBox(
                width: controller!.value.size.width,
                height: controller.value.size.height,
                child: Chewie(controller: chewie),
              ),
            )
          else
            // Show black screen without loading indicator
            Container(
              color: Colors.black,
            ),
        ],
      ),
    );

    // Wrap with GestureDetector if link is provided
    if (linkUrl.isNotEmpty) {
      return GestureDetector(
        onTap: () => _handleSlideLink(linkUrl),
        child: videoWidget,
      );
    }
    
    return videoWidget;
  }

  void _handleSlideLink(String url) {
    if (url.isEmpty) return;
    
    debugPrint('🔗 Slide link tapped: $url');
    
    // Extract collection handle from URL
    // e.g., https://goeye.in/collections/sunglasses -> sunglasses
    if (url.contains('/collections/')) {
      final handle = url.split('/collections/').last;
      final collectionName = handle.split('-').map((s) => s[0].toUpperCase() + s.substring(1)).join(' ');
      
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

  Widget _buildImageSlide(Map<String, dynamic> slide, bool isMobile) {
    final desktopImage = slide['desktopImage'] ?? slide['image'] ?? '';
    final mobileImage = slide['mobileImage'] ?? slide['image'] ?? '';
    final imageUrl = isMobile ? mobileImage : desktopImage;
    final heading = slide['heading'] ?? '';
    final subheading = slide['subheading'] ?? '';
    final ctaText = slide['ctaText'] ?? '';
    final linkUrl = slide['link'] ?? '';

    Widget imageWidget = Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.black,
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.black,
            child: const Icon(Icons.image, size: 80, color: Colors.grey),
          ),
        ),
        
        // Text Overlay (if any)
        if (heading.isNotEmpty || subheading.isNotEmpty || ctaText.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (heading.isNotEmpty)
                    Text(
                      heading,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  if (subheading.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      subheading,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                  if (ctaText.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _handleSlideLink(linkUrl),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        ctaText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
      ],
    );

    // Wrap with GestureDetector if link is provided and no CTA button
    if (linkUrl.isNotEmpty && ctaText.isEmpty) {
      return GestureDetector(
        onTap: () => _handleSlideLink(linkUrl),
        child: imageWidget,
      );
    }
    
    return imageWidget;
  }
}
