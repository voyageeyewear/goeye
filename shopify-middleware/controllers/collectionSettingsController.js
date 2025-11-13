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
    console.error('Error fetching collection page settings:', error);
    res.status(500).json({
      success: false,
      error: error.message
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
    console.error('Error updating collection page settings:', error);
    res.status(500).json({
      success: false,
      error: error.message
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
    console.error('Error resetting collection page settings:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
};

