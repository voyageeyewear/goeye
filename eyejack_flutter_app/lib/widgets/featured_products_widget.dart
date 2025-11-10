import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product_model.dart';
import '../screens/product_detail_screen.dart';

class FeaturedProductsWidget extends StatefulWidget {
  final Map<String, dynamic> settings;

  const FeaturedProductsWidget({super.key, required this.settings});

  @override
  State<FeaturedProductsWidget> createState() => _FeaturedProductsWidgetState();
}

class _FeaturedProductsWidgetState extends State<FeaturedProductsWidget> {
  Timer? _countdownTimer;
  Duration _timeRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    final endTimeStr = widget.settings['countdownEndTime'] as String?;
    if (endTimeStr != null) {
      final endTime = DateTime.parse(endTimeStr);
      _timeRemaining = endTime.difference(DateTime.now());

      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {
          _timeRemaining = endTime.difference(DateTime.now());
          if (_timeRemaining.isNegative) {
            _timeRemaining = Duration.zero;
            timer.cancel();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 0) {
      return '$days:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.settings['title'] ?? 'Limited Time Offer';
    final subtitle = widget.settings['subtitle'] ?? '';
    final backgroundColor = _parseColor(widget.settings['backgroundColor'] ?? '#FFF5E6');
    final productsData = widget.settings['products'] as List<dynamic>? ?? [];

    final products = productsData
        .map((p) => Product.fromJson(Map<String, dynamic>.from(p)))
        .toList();

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          // Header with countdown
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
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 16),
                // Countdown Timer
                _buildCountdownTimer(),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Products horizontal scroll
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildProductCard(context, products[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownTimer() {
    if (_timeRemaining == Duration.zero) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Offer Expired',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.access_time,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Ends in: ${_formatDuration(_timeRemaining)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    final imageUrl = product.images.isNotEmpty ? product.images[0].src : '';
    final price = product.priceRange.minVariantPrice;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 160,
                          color: Colors.grey[200],
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 160,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, size: 40),
                        ),
                      )
                    : Container(
                        height: 160,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 40),
                      ),
              ),

              // Product Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Rs. ${price.amount}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'SALE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return const Color(0xFFFFF5E6);
    }
  }
}

