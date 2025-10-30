import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gokwik/flow_result.dart';
import 'package:gokwik/checkout/checkout_shopify.dart';
import 'package:gokwik/config/cache_instance.dart';
import 'package:gokwik/config/key_congif.dart';

class GokwikService {
  static const String _merchantId = '19g6iluwldmy4';
  static const String _environment = 'prod'; // prod or staging
  static const String _merchantType = 'shopify'; // shopify or custom
  static const String _shopDomain = 'eyejack1907.myshopify.com'; // Your Shopify shop domain
  static const String _storefrontToken = '0032c089ead422dfbfaa0ffcbbddcc97'; // Your Storefront API token
  
  static bool _isInitialized = false;
  
  /// Initialize GoKwik SDK with required configuration
  static Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('✅ GoKwik already initialized');
      return;
    }
    
    try {
      debugPrint('🚀 Initializing GoKwik SDK...');
      debugPrint('   Merchant ID: $_merchantId');
      debugPrint('   Environment: $_environment');
      debugPrint('   Merchant Type: $_merchantType');
      debugPrint('   Shop Domain: $_shopDomain');
      
      final cache = cacheInstance;
      
      // Set required configuration in cache for Shopify integration
      await cache.setValue(KeyConfig.gkMerchantIdKey, _merchantId);
      await cache.setValue(KeyConfig.gkEnvironmentKey, _environment);
      await cache.setValue(KeyConfig.gkMerchantTypeKey, _merchantType);
      await cache.setValue(KeyConfig.gkMerchantUrlKey, _shopDomain); // Required for Shopify mode
      await cache.setValue(KeyConfig.enableCheckout, 'true');
      
      _isInitialized = true;
      debugPrint('✅ GoKwik SDK initialized successfully!');
    } catch (e) {
      debugPrint('❌ GoKwik initialization error: $e');
      rethrow;
    }
  }

  /// Open GoKwik checkout with Shopify cart data
  /// Returns true if checkout was successful, false otherwise
  static Future<bool> openCheckout({
    required BuildContext context,
    required String checkoutUrl,
    required Map<String, dynamic> cartData,
  }) async {
    try {
      debugPrint('🛒 Opening GoKwik checkout...');
      debugPrint('   Shopify Checkout URL: $checkoutUrl');
      debugPrint('   Cart ID: ${cartData['cartId']}');
      debugPrint('   Total: ${cartData['currency']} ${cartData['totalAmount']}');
      debugPrint('   Items: ${cartData['itemCount']}');

      // Extract checkout ID from checkout URL
      // Format can be:
      // - https://eyejack.in/cart/c/{checkoutId}?key=...
      // - https://checkout.shopify.com/.../c/{checkoutId}
      String? checkoutId;
      String? cartIdStr = cartData['cartId']?.toString();
      
      // Try to extract checkout ID from URL
      final uri = Uri.parse(checkoutUrl);
      final segments = uri.pathSegments;
      
      // Look for the checkout ID after "/c/" in the path
      final cIndex = segments.indexOf('c');
      if (cIndex >= 0 && cIndex < segments.length - 1) {
        checkoutId = segments[cIndex + 1]; // Get the segment after 'c'
        debugPrint('   Extracted Checkout ID: $checkoutId');
      }

      // Try to extract cart ID from Shopify cart ID
      // Format: gid://shopify/Cart/{cartId}?key=...
      String? cartId;
      if (cartIdStr != null && cartIdStr.contains('gid://shopify/Cart/')) {
        final cartIdMatch = RegExp(r'gid://shopify/Cart/([^?]+)').firstMatch(cartIdStr);
        if (cartIdMatch != null) {
          cartId = cartIdMatch.group(1);
          debugPrint('   Extracted Cart ID: $cartId');
        }
      }

      if (checkoutId == null || checkoutId.isEmpty) {
        debugPrint('❌ Could not extract checkout ID from URL: $checkoutUrl');
        debugPrint('   URL segments: $segments');
        return false;
      }

      // Create a completer to track checkout result
      final Completer<bool> checkoutCompleter = Completer<bool>();

      // Navigate to GoKwik checkout screen
      debugPrint('🚀 Launching CheckoutShopify widget...');
      debugPrint('   Checkout ID: $checkoutId');
      debugPrint('   Cart ID: $cartId');
      debugPrint('   Store ID: $_merchantId');

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutShopify(
            checkoutId: checkoutId,
            cartId: cartId,
            storefrontToken: _storefrontToken, // Pass Storefront API token
            storeId: _merchantId,
            onSuccess: (FlowResult result) {
              debugPrint('✅ GoKwik checkout successful!');
              debugPrint('   Flow type: ${result.flowType}');
              debugPrint('   Data: ${result.data}');
              
              if (!checkoutCompleter.isCompleted) {
                checkoutCompleter.complete(true);
              }
            },
            onError: (FlowResult result) {
              debugPrint('❌ GoKwik checkout error!');
              debugPrint('   Flow type: ${result.flowType}');
              debugPrint('   Error: ${result.error}');
              
              if (!checkoutCompleter.isCompleted) {
                checkoutCompleter.complete(false);
              }
            },
            onMessage: (dynamic message) {
              debugPrint('📨 GoKwik message: $message');
            },
          ),
        ),
      );

      // Return the checkout result
      return checkoutCompleter.isCompleted 
          ? checkoutCompleter.future 
          : false; // User closed without completing
    } catch (e) {
      debugPrint('❌ Error opening GoKwik checkout: $e');
      debugPrint('❌ Stack trace: ${StackTrace.current}');
      return false;
    }
  }
}

