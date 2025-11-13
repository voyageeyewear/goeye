const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const CollectionPageSettings = sequelize.define('CollectionPageSettings', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  // Text & Typography
  titleFontSize: {
    type: DataTypes.INTEGER,
    defaultValue: 16,
    field: 'title_font_size'
  },
  titleFontFamily: {
    type: DataTypes.STRING,
    defaultValue: 'Roboto',
    field: 'title_font_family'
  },
  titleColor: {
    type: DataTypes.STRING,
    defaultValue: '#000000',
    field: 'title_color'
  },
  
  // Price Settings
  priceFontSize: {
    type: DataTypes.INTEGER,
    defaultValue: 18,
    field: 'price_font_size'
  },
  priceColor: {
    type: DataTypes.STRING,
    defaultValue: '#000000',
    field: 'price_color'
  },
  originalPriceColor: {
    type: DataTypes.STRING,
    defaultValue: '#999999',
    field: 'original_price_color'
  },
  showOriginalPrice: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
    field: 'show_original_price'
  },
  
  // EMI Badge
  showEMI: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
    field: 'show_emi'
  },
  emiBadgeColor: {
    type: DataTypes.STRING,
    defaultValue: '#4CAF50',
    field: 'emi_badge_color'
  },
  emiTextColor: {
    type: DataTypes.STRING,
    defaultValue: '#FFFFFF',
    field: 'emi_text_color'
  },
  emiFontSize: {
    type: DataTypes.INTEGER,
    defaultValue: 11,
    field: 'emi_font_size'
  },
  
  // Stock Badge
  showInStock: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
    field: 'show_in_stock'
  },
  inStockBadgeColor: {
    type: DataTypes.STRING,
    defaultValue: '#4CAF50',
    field: 'in_stock_badge_color'
  },
  inStockTextColor: {
    type: DataTypes.STRING,
    defaultValue: '#FFFFFF',
    field: 'in_stock_text_color'
  },
  outOfStockBadgeColor: {
    type: DataTypes.STRING,
    defaultValue: '#F44336',
    field: 'out_of_stock_badge_color'
  },
  outOfStockTextColor: {
    type: DataTypes.STRING,
    defaultValue: '#FFFFFF',
    field: 'out_of_stock_text_color'
  },
  
  // Discount Badge
  showDiscountBadge: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
    field: 'show_discount_badge'
  },
  discountBadgeColor: {
    type: DataTypes.STRING,
    defaultValue: '#FF5722',
    field: 'discount_badge_color'
  },
  discountTextColor: {
    type: DataTypes.STRING,
    defaultValue: '#FFFFFF',
    field: 'discount_text_color'
  },
  
  // Buttons
  addToCartButtonColor: {
    type: DataTypes.STRING,
    defaultValue: '#000000',
    field: 'add_to_cart_button_color'
  },
  addToCartTextColor: {
    type: DataTypes.STRING,
    defaultValue: '#FFFFFF',
    field: 'add_to_cart_text_color'
  },
  selectLensButtonColor: {
    type: DataTypes.STRING,
    defaultValue: '#4CAF50',
    field: 'select_lens_button_color'
  },
  selectLensTextColor: {
    type: DataTypes.STRING,
    defaultValue: '#FFFFFF',
    field: 'select_lens_text_color'
  },
  buttonBorderRadius: {
    type: DataTypes.INTEGER,
    defaultValue: 8,
    field: 'button_border_radius'
  },
  buttonFontSize: {
    type: DataTypes.INTEGER,
    defaultValue: 14,
    field: 'button_font_size'
  },
  
  // Card Settings
  cardBackgroundColor: {
    type: DataTypes.STRING,
    defaultValue: '#FFFFFF',
    field: 'card_background_color'
  },
  cardBorderColor: {
    type: DataTypes.STRING,
    defaultValue: '#E0E0E0',
    field: 'card_border_color'
  },
  cardBorderRadius: {
    type: DataTypes.INTEGER,
    defaultValue: 12,
    field: 'card_border_radius'
  },
  cardElevation: {
    type: DataTypes.INTEGER,
    defaultValue: 2,
    field: 'card_elevation'
  },
  
  // Spacing
  cardPadding: {
    type: DataTypes.INTEGER,
    defaultValue: 12,
    field: 'card_padding'
  },
  itemSpacing: {
    type: DataTypes.INTEGER,
    defaultValue: 16,
    field: 'item_spacing'
  },
  
  // Additional Features
  showRatings: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
    field: 'show_ratings'
  },
  ratingStarColor: {
    type: DataTypes.STRING,
    defaultValue: '#FFB800',
    field: 'rating_star_color'
  },
  
  updatedAt: {
    type: DataTypes.DATE,
    field: 'updated_at'
  },
  createdAt: {
    type: DataTypes.DATE,
    field: 'created_at'
  }
}, {
  tableName: 'collection_page_settings',
  timestamps: true,
  underscored: true
});

module.exports = CollectionPageSettings;

