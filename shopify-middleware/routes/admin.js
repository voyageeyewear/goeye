const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');

// ============================================
// SECTION MANAGEMENT ROUTES
// ============================================

// Get all sections
router.get('/sections', adminController.getAllSections);

// Get single section
router.get('/sections/:id', adminController.getSectionById);

// Create new section
router.post('/sections', adminController.createSection);

// Update section
router.put('/sections/:id', adminController.updateSection);

// Delete section
router.delete('/sections/:id', adminController.deleteSection);

// Toggle section active/inactive
router.patch('/sections/:id/toggle', adminController.toggleSectionStatus);

// Reorder sections
router.post('/sections/reorder', adminController.reorderSections);

// ============================================
// THEME SETTINGS ROUTES
// ============================================

// Get all theme settings
router.get('/theme', adminController.getAllThemeSettings);

// Update theme setting
router.put('/theme/:key', adminController.updateThemeSetting);

// ============================================
// DASHBOARD STATS
// ============================================

// Get dashboard statistics
router.get('/stats', adminController.getDashboardStats);

module.exports = router;

