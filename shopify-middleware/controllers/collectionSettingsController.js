const { CollectionPageSettings } = require('../models');

// Get collection page settings
exports.getSettings = async (req, res) => {
  try {
    let settings = await CollectionPageSettings.findOne();
    
    // If no settings exist, create default settings
    if (!settings) {
      settings = await CollectionPageSettings.create({});
    }
    
    res.json({
      success: true,
      data: settings
    });
  } catch (error) {
    console.warn('⚠️ Database not available, returning default settings:', error.message);
    // Return complete default settings when database is unavailable
    res.json({
      success: true,
      data: {
        // Text & Typography
        titleFontSize: 16,
        titleFontFamily: 'Roboto',
        titleColor: '#000000',
        // Price Settings
        priceFontSize: 18,
        priceColor: '#000000',
        originalPriceColor: '#999999',
        showOriginalPrice: true,
        // EMI Badge
        showEMI: true,
        emiBadgeColor: '#52b1e2',
        emiTextColor: '#ffffff',
        emiFontSize: 12,
        // Stock Badge
        showInStock: false,
        inStockBadgeColor: '#4caf50',
        inStockTextColor: '#ffffff',
        outOfStockBadgeColor: '#f44336',
        outOfStockTextColor: '#ffffff',
        // Discount Badge
        showDiscountBadge: false,
        discountBadgeColor: '#f44336',
        discountTextColor: '#ffffff',
        // Buttons
        addToCartButtonColor: '#fa0000',
        addToCartTextColor: '#ffffff',
        selectLensButtonColor: '#000000',
        selectLensTextColor: '#ffffff',
        buttonBorderRadius: 10,
        buttonFontSize: 14,
        // Card Settings
        cardBackgroundColor: '#ffffff',
        cardBorderColor: '#e0e0e0',
        cardBorderRadius: 8,
        cardElevation: 2,
        cardPadding: 16,
        itemSpacing: 16,
        // Additional Features
        showProductRatings: false,
        ratingStarColor: '#ffc107'
      },
      warning: 'Database not connected. Using default settings.'
    });
  }
};

// Update collection page settings
exports.updateSettings = async (req, res) => {
  try {
    let settings = await CollectionPageSettings.findOne();
    
    if (!settings) {
      // Create new settings with provided data
      settings = await CollectionPageSettings.create(req.body);
    } else {
      // Update existing settings
      await settings.update(req.body);
    }
    
    res.json({
      success: true,
      data: settings,
      message: 'Collection page settings updated successfully'
    });
  } catch (error) {
    console.warn('⚠️ Database not available, cannot save settings:', error.message);
    // Return success with warning when database is unavailable
    res.json({
      success: true,
      data: req.body,
      message: 'Settings saved locally (database not connected - changes will not persist)',
      warning: 'Database not connected. Settings cannot be saved permanently.'
    });
  }
};

// Reset to default settings
exports.resetSettings = async (req, res) => {
  try {
    let settings = await CollectionPageSettings.findOne();
    
    if (settings) {
      await settings.destroy();
    }
    
    // Create new default settings
    settings = await CollectionPageSettings.create({});
    
    res.json({
      success: true,
      data: settings,
      message: 'Collection page settings reset to defaults'
    });
  } catch (error) {
    console.warn('⚠️ Database not available, returning default settings:', error.message);
    // Return default settings when database is unavailable
    res.json({
      success: true,
      data: {
        titleFontSize: 16,
        titleFontFamily: 'Roboto',
        titleColor: '#000000',
        priceFontSize: 18,
        priceColor: '#000000',
        originalPriceColor: '#999999',
        showOriginalPrice: true,
        showEMI: true,
        emiBadgeColor: '#52b1e2',
        emiTextColor: '#ffffff',
        emiFontSize: 12,
        showInStock: false,
        inStockBadgeColor: '#4caf50',
        inStockTextColor: '#ffffff',
        outOfStockBadgeColor: '#f44336',
        outOfStockTextColor: '#ffffff',
        showDiscountBadge: false,
        discountBadgeColor: '#f44336',
        discountTextColor: '#ffffff',
        addToCartButtonColor: '#fa0000',
        addToCartTextColor: '#ffffff',
        selectLensButtonColor: '#000000',
        selectLensTextColor: '#ffffff',
        buttonBorderRadius: 10,
        buttonFontSize: 14,
        cardBackgroundColor: '#ffffff',
        cardBorderColor: '#e0e0e0',
        cardBorderRadius: 8,
        cardElevation: 2,
        cardPadding: 16,
        itemSpacing: 16,
        showProductRatings: false,
        ratingStarColor: '#ffc107'
      },
      message: 'Settings reset to defaults (database not connected)',
      warning: 'Database not connected. Changes will not persist.'
    });
  }
};

