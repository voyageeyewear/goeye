const shopifyService = require('../services/shopifyService');
const { AppSection } = require('../models');

// Get theme sections for homepage (NOW READS FROM POSTGRESQL with Shopify fallback!)
exports.getThemeSections = async (req, res, next) => {
  try {
    let layout = [];
    let shopInfo = null;

    // Try to fetch from PostgreSQL database first
    try {
      console.log('📊 Fetching sections from PostgreSQL...');
      
      const dbSections = await AppSection.findAll({
        where: { is_active: true },
        order: [['display_order', 'ASC']]
      });

      console.log(`✅ Found ${dbSections.length} active sections in database`);

      // Transform database format to API format
      layout = dbSections.map(section => ({
        id: section.section_id,
        type: section.section_type,
        settings: section.settings
      }));

      // Fetch shop info from Shopify
      shopInfo = await shopifyService.fetchShopInfo();

      // If we got sections from database, return them
      if (layout.length > 0) {
        return res.json({
          success: true,
          data: {
            layout,
            shop: shopInfo
          }
        });
      }
    } catch (dbError) {
      console.warn('⚠️ Database not available, falling back to Shopify API:', dbError.message);
    }

    // Fallback: Fetch from Shopify Theme API directly
    console.log('📦 Fetching sections from Shopify Theme API (fallback)...');
    try {
      const themeData = await shopifyService.fetchThemeSections();
      layout = themeData.layout || [];
      shopInfo = themeData.shop || {};

      // If shopInfo is empty, try to fetch it
      if (!shopInfo || Object.keys(shopInfo).length === 0) {
        shopInfo = await shopifyService.fetchShopInfo().catch(() => ({}));
      }

      res.json({
        success: true,
        data: {
          layout,
          shop: shopInfo
        }
      });
    } catch (shopifyError) {
      console.error('❌ Error fetching from Shopify API:', shopifyError);
      // Last resort: return minimal structure
      try {
        shopInfo = await shopifyService.fetchShopInfo();
      } catch (e) {
        shopInfo = {};
      }
      
      res.json({
        success: true,
        data: {
          layout: [],
          shop: shopInfo
        }
      });
    }
  } catch (error) {
    console.error('❌ Critical error in getThemeSections:', error);
    next(error);
  }
};

// Get theme files (product page templates and snippets)
exports.getThemeFiles = async (req, res, next) => {
  try {
    const themeFiles = await shopifyService.fetchThemeFiles();
    res.json({
      success: true,
      data: themeFiles
    });
  } catch (error) {
    next(error);
  }
};

// Get all theme assets list
exports.getAllThemeAssets = async (req, res, next) => {
  try {
    const assets = await shopifyService.fetchAllThemeAssets();
    res.json({
      success: true,
      data: assets
    });
  } catch (error) {
    next(error);
  }
};

// Get all products
exports.getProducts = async (req, res, next) => {
  try {
    const limit = parseInt(req.query.limit) || 50;
    const products = await shopifyService.fetchProducts(limit);
    res.json({
      success: true,
      data: products
    });
  } catch (error) {
    next(error);
  }
};

// Get product by ID
exports.getProductById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const product = await shopifyService.fetchProductById(id);
    res.json({
      success: true,
      data: product
    });
  } catch (error) {
    next(error);
  }
};

// Get products by collection
exports.getProductsByCollection = async (req, res, next) => {
  try {
    const { handle } = req.params;
    const limit = parseInt(req.query.limit) || 50;
    const offset = parseInt(req.query.offset) || 0;
    
    console.log(`📦 Pagination request: collection=${handle}, limit=${limit}, offset=${offset}`);
    
    const result = await shopifyService.fetchProductsByCollection(handle, limit, offset);
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    next(error);
  }
};

// Get all collections
exports.getCollections = async (req, res, next) => {
  try {
    const collections = await shopifyService.fetchCollections();
    res.json({
      success: true,
      data: collections
    });
  } catch (error) {
    next(error);
  }
};

// Get collection by handle
exports.getCollectionByHandle = async (req, res, next) => {
  try {
    const { handle } = req.params;
    const collection = await shopifyService.fetchCollectionByHandle(handle);
    res.json({
      success: true,
      data: collection
    });
  } catch (error) {
    next(error);
  }
};

// Get shop information
exports.getShopInfo = async (req, res, next) => {
  try {
    const shopInfo = await shopifyService.fetchShopInfo();
    res.json({
      success: true,
      data: shopInfo
    });
  } catch (error) {
    next(error);
  }
};

// Search products
exports.searchProducts = async (req, res, next) => {
  try {
    const { q } = req.query;
    if (!q) {
      return res.status(400).json({
        success: false,
        error: 'Search query is required'
      });
    }
    const results = await shopifyService.searchProducts(q);
    res.json({
      success: true,
      data: results
    });
  } catch (error) {
    next(error);
  }
};

// Cart operations
exports.addToCart = async (req, res, next) => {
  try {
    const { variantId, quantity = 1, properties = {} } = req.body;
    if (!variantId) {
      return res.status(400).json({
        success: false,
        error: 'Variant ID is required'
      });
    }
    const cart = await shopifyService.addToCart(variantId, quantity, properties);
    res.json({
      success: true,
      data: cart
    });
  } catch (error) {
    next(error);
  }
};

// Add multiple items to cart
exports.addMultipleToCart = async (req, res, next) => {
  try {
    const { items } = req.body;
    
    if (!items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ 
        success: false,
        error: 'Items array is required' 
      });
    }
    
    const cart = await shopifyService.addMultipleToCart(items);
    res.json({
      success: true,
      data: cart
    });
  } catch (error) {
    next(error);
  }
};

exports.updateCart = async (req, res, next) => {
  try {
    const { variantId, quantity, lineItemId } = req.body;
    
    // Accept either variantId or lineItemId
    let itemId = lineItemId;
    
    if (!itemId && variantId) {
      // Get current cart to find line item by variant ID
      const currentCart = await shopifyService.getCart();
      const item = currentCart.items.find(item => item.variantId === variantId);
      if (!item) {
        return res.status(404).json({
          success: false,
          error: 'Item not found in cart'
        });
      }
      itemId = item.id;
    }
    
    if (!itemId || quantity === undefined) {
      return res.status(400).json({
        success: false,
        error: 'Variant ID or Line item ID, and quantity are required'
      });
    }
    
    const cart = await shopifyService.updateCart(itemId, quantity);
    res.json({
      success: true,
      data: cart
    });
  } catch (error) {
    next(error);
  }
};

exports.removeFromCart = async (req, res, next) => {
  try {
    const { variantId, lineItemId } = req.body;
    
    // Accept either variantId or lineItemId
    let itemId = lineItemId;
    
    if (!itemId && variantId) {
      // Get current cart to find line item by variant ID
      const currentCart = await shopifyService.getCart();
      const item = currentCart.items.find(item => item.variantId === variantId);
      if (!item) {
        return res.status(404).json({
          success: false,
          error: 'Item not found in cart'
        });
      }
      itemId = item.id;
    }
    
    if (!itemId) {
      return res.status(400).json({
        success: false,
        error: 'Variant ID or Line item ID is required'
      });
    }
    
    const cart = await shopifyService.removeFromCart(itemId);
    res.json({
      success: true,
      data: cart
    });
  } catch (error) {
    next(error);
  }
};

exports.getCart = async (req, res, next) => {
  try {
    const cart = await shopifyService.getCart();
    res.json({
      success: true,
      data: cart
    });
  } catch (error) {
    next(error);
  }
};

exports.clearCart = async (req, res, next) => {
  try {
    const cart = await shopifyService.clearCart();
    res.json({
      success: true,
      data: cart
    });
  } catch (error) {
    next(error);
  }
};

exports.createCheckout = async (req, res, next) => {
  try {
    const { lineItems } = req.body;
    if (!lineItems || !Array.isArray(lineItems)) {
      return res.status(400).json({
        success: false,
        error: 'Line items array is required'
      });
    }
    const checkout = await shopifyService.createCheckout(lineItems);
    res.json({
      success: true,
      data: checkout
    });
  } catch (error) {
    next(error);
  }
};

exports.createGokwikCheckout = async (req, res, next) => {
  try {
    const checkoutData = await shopifyService.createGokwikCheckout();
    res.json({
      success: true,
      data: checkoutData
    });
  } catch (error) {
    console.error('Gokwik checkout error:', error);
    next(error);
  }
};

exports.getLensOptions = async (req, res, next) => {
  try {
    const lensOptions = await shopifyService.fetchLensOptions();
    res.json({
      success: true,
      data: lensOptions
    });
  } catch (error) {
    next(error);
  }
};

