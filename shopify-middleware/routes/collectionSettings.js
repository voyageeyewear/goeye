const express = require('express');
const router = express.Router();
const collectionSettingsController = require('../controllers/collectionSettingsController');

// Get collection page settings
router.get('/settings', collectionSettingsController.getSettings);

// Update collection page settings
router.put('/settings', collectionSettingsController.updateSettings);

// Reset to default settings
router.post('/settings/reset', collectionSettingsController.resetSettings);

module.exports = router;

