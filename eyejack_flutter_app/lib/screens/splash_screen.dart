import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  
  const SplashScreen({super.key, required this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _videoController;
  bool _videoInitialized = false;
  
  // Splash video URL
  final String _splashVideoUrl = 'https://cdn.shopify.com/videos/c/o/v/6bab26bb066640ee88e75fbdcde5d938.mp4';

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }
  
  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(_splashVideoUrl));
    
    try {
      await _videoController!.initialize();
      await _videoController!.setLooping(false);
      await _videoController!.setVolume(0.0); // Muted
      await _videoController!.play();
      
      if (mounted) {
        setState(() {
          _videoInitialized = true;
        });
      }
      
      // Listen for video completion
      _videoController!.addListener(() {
        if (_videoController!.value.position >= _videoController!.value.duration) {
          // Video finished, navigate to home
          if (mounted) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => widget.nextScreen,
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          }
        }
      });
    } catch (e) {
      debugPrint('Error initializing splash video: $e');
      // If video fails, navigate after 3 seconds
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => widget.nextScreen,
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background video - no overlay/opacity
          if (_videoInitialized && _videoController != null)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController!.value.size.width,
                height: _videoController!.value.size.height,
                child: VideoPlayer(_videoController!),
              ),
            )
          else
            Container(
              color: Colors.black,
            ),
          
          // Logo and tagline at bottom
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Eyejack logo
                Image.network(
                  'https://eyejack.in/cdn/shop/files/colored-logo.png',
                  height: 80,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'EYEJACK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your Vision, Our Passion',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
