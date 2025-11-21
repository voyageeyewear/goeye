class CollectionPageSettings {
  // Text & Typography
  final int titleFontSize;
  final String titleFontFamily;
  final String titleColor;
  
  // Price Settings
  final int priceFontSize;
  final String priceColor;
  final String originalPriceColor;
  final bool showOriginalPrice;
  
  // EMI Badge
  final bool showEMI;
  final String emiBadgeColor;
  final String emiTextColor;
  final int emiFontSize;
  
  // Stock Badge
  final bool showInStock;
  final String inStockBadgeColor;
  final String inStockTextColor;
  final String outOfStockBadgeColor;
  final String outOfStockTextColor;
  
  // Discount Badge
  final bool showDiscountBadge;
  final String discountBadgeColor;
  final String discountTextColor;
  
  // Buttons
  final String addToCartButtonColor;
  final String addToCartTextColor;
  final String selectLensButtonColor;
  final String selectLensTextColor;
  final int buttonBorderRadius;
  final int buttonFontSize;
  
  // Card Settings
  final String cardBackgroundColor;
  final String cardBorderColor;
  final int cardBorderRadius;
  final int cardElevation;
  final int cardPadding;
  final int itemSpacing;
  
  // Additional Features
  final bool showRatings;
  final String ratingStarColor;

  CollectionPageSettings({
    required this.titleFontSize,
    required this.titleFontFamily,
    required this.titleColor,
    required this.priceFontSize,
    required this.priceColor,
    required this.originalPriceColor,
    required this.showOriginalPrice,
    required this.showEMI,
    required this.emiBadgeColor,
    required this.emiTextColor,
    required this.emiFontSize,
    required this.showInStock,
    required this.inStockBadgeColor,
    required this.inStockTextColor,
    required this.outOfStockBadgeColor,
    required this.outOfStockTextColor,
    required this.showDiscountBadge,
    required this.discountBadgeColor,
    required this.discountTextColor,
    required this.addToCartButtonColor,
    required this.addToCartTextColor,
    required this.selectLensButtonColor,
    required this.selectLensTextColor,
    required this.buttonBorderRadius,
    required this.buttonFontSize,
    required this.cardBackgroundColor,
    required this.cardBorderColor,
    required this.cardBorderRadius,
    required this.cardElevation,
    required this.cardPadding,
    required this.itemSpacing,
    required this.showRatings,
    required this.ratingStarColor,
  });

  factory CollectionPageSettings.fromJson(Map<String, dynamic> json) {
    return CollectionPageSettings(
      titleFontSize: json['titleFontSize'] ?? 16,
      titleFontFamily: json['titleFontFamily'] ?? 'Roboto',
      titleColor: json['titleColor'] ?? '#000000',
      priceFontSize: json['priceFontSize'] ?? 18,
      priceColor: json['priceColor'] ?? '#000000',
      originalPriceColor: json['originalPriceColor'] ?? '#999999',
      showOriginalPrice: json['showOriginalPrice'] ?? true,
      showEMI: json['showEMI'] ?? true,
      emiBadgeColor: json['emiBadgeColor'] ?? '#4CAF50',
      emiTextColor: json['emiTextColor'] ?? '#FFFFFF',
      emiFontSize: json['emiFontSize'] ?? 11,
      showInStock: json['showInStock'] ?? true,
      inStockBadgeColor: json['inStockBadgeColor'] ?? '#4CAF50',
      inStockTextColor: json['inStockTextColor'] ?? '#FFFFFF',
      outOfStockBadgeColor: json['outOfStockBadgeColor'] ?? '#F44336',
      outOfStockTextColor: json['outOfStockTextColor'] ?? '#FFFFFF',
      showDiscountBadge: json['showDiscountBadge'] ?? true,
      discountBadgeColor: json['discountBadgeColor'] ?? '#FF5722',
      discountTextColor: json['discountTextColor'] ?? '#FFFFFF',
      addToCartButtonColor: json['addToCartButtonColor'] ?? '#000000',
      addToCartTextColor: json['addToCartTextColor'] ?? '#FFFFFF',
      selectLensButtonColor: json['selectLensButtonColor'] ?? '#4CAF50',
      selectLensTextColor: json['selectLensTextColor'] ?? '#FFFFFF',
      buttonBorderRadius: json['buttonBorderRadius'] ?? 8,
      buttonFontSize: json['buttonFontSize'] ?? 14,
      cardBackgroundColor: json['cardBackgroundColor'] ?? '#FFFFFF',
      cardBorderColor: json['cardBorderColor'] ?? '#E0E0E0',
      cardBorderRadius: json['cardBorderRadius'] ?? 12,
      cardElevation: json['cardElevation'] ?? 2,
      cardPadding: json['cardPadding'] ?? 12,
      itemSpacing: json['itemSpacing'] ?? 16,
      showRatings: json['showRatings'] ?? true,
      ratingStarColor: json['ratingStarColor'] ?? '#FFB800',
    );
  }

  // Helper method to convert hex color to Flutter Color
  static int hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return int.parse(buffer.toString(), radix: 16);
  }

  // Default settings
  static CollectionPageSettings defaults() {
    return CollectionPageSettings(
      titleFontSize: 16,
      titleFontFamily: 'Roboto',
      titleColor: '#000000',
      priceFontSize: 18,
      priceColor: '#000000',
      originalPriceColor: '#999999',
      showOriginalPrice: true,
      showEMI: true,
      emiBadgeColor: '#4CAF50',
      emiTextColor: '#FFFFFF',
      emiFontSize: 11,
      showInStock: true,
      inStockBadgeColor: '#4CAF50',
      inStockTextColor: '#FFFFFF',
      outOfStockBadgeColor: '#F44336',
      outOfStockTextColor: '#FFFFFF',
      showDiscountBadge: true,
      discountBadgeColor: '#FF5722',
      discountTextColor: '#FFFFFF',
      addToCartButtonColor: '#000000',
      addToCartTextColor: '#FFFFFF',
      selectLensButtonColor: '#4CAF50',
      selectLensTextColor: '#FFFFFF',
      buttonBorderRadius: 8,
      buttonFontSize: 14,
      cardBackgroundColor: '#FFFFFF',
      cardBorderColor: '#E0E0E0',
      cardBorderRadius: 12,
      cardElevation: 2,
      cardPadding: 12,
      itemSpacing: 16,
      showRatings: true,
      ratingStarColor: '#FFB800',
    );
  }
}

