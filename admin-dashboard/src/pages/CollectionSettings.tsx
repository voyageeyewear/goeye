import { useState, useEffect } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { Save, RotateCcw, Palette, Type, DollarSign, Tag, ShoppingCart } from 'lucide-react';
import api from '../lib/api';
import { Button } from '../components/ui/Button';
import { Card } from '../components/ui/Card';
import { Input } from '../components/ui/Input';
import { Label } from '../components/ui/Label';

interface CollectionSettings {
  // Text & Typography
  titleFontSize: number;
  titleFontFamily: string;
  titleColor: string;
  
  // Price Settings
  priceFontSize: number;
  priceColor: string;
  originalPriceColor: string;
  showOriginalPrice: boolean;
  
  // EMI Badge
  showEMI: boolean;
  emiBadgeColor: string;
  emiTextColor: string;
  emiFontSize: number;
  
  // Stock Badge
  showInStock: boolean;
  inStockBadgeColor: string;
  inStockTextColor: string;
  outOfStockBadgeColor: string;
  outOfStockTextColor: string;
  
  // Discount Badge
  showDiscountBadge: boolean;
  discountBadgeColor: string;
  discountTextColor: string;
  
  // Buttons
  addToCartButtonColor: string;
  addToCartTextColor: string;
  selectLensButtonColor: string;
  selectLensTextColor: string;
  buttonBorderRadius: number;
  buttonFontSize: number;
  
  // Card Settings
  cardBackgroundColor: string;
  cardBorderColor: string;
  cardBorderRadius: number;
  cardElevation: number;
  cardPadding: number;
  itemSpacing: number;
  
  // Additional Features
  showRatings: boolean;
  ratingStarColor: string;
}

const STORAGE_KEY = 'goeye_collection_settings';

export function CollectionSettings() {
  const queryClient = useQueryClient();
  const [settings, setSettings] = useState<CollectionSettings | null>(null);
  const [hasChanges, setHasChanges] = useState(false);
  const [isLocalStorage, setIsLocalStorage] = useState(false);

  // Load from localStorage on mount
  useEffect(() => {
    const saved = localStorage.getItem(STORAGE_KEY);
    if (saved) {
      try {
        const parsed = JSON.parse(saved);
        setSettings(parsed);
        setIsLocalStorage(true);
      } catch (e) {
        console.error('Error loading from localStorage:', e);
      }
    }
  }, []);

  // Fetch settings
  const { data, isLoading, error } = useQuery({
    queryKey: ['collectionSettings'],
    queryFn: async () => {
      const response = await api.get('/api/collection/settings');
      return response.data.data;
    },
  });

  useEffect(() => {
    if (data) {
      // Only update if we don't have localStorage data
      if (!localStorage.getItem(STORAGE_KEY)) {
        setSettings(data);
        setIsLocalStorage(false);
      }
    }
  }, [data]);

  // Update settings mutation
  const updateMutation = useMutation({
    mutationFn: async (updatedSettings: CollectionSettings) => {
      const response = await api.put('/api/collection/settings', updatedSettings);
      
      // Save to localStorage as backup (especially when database is unavailable)
      localStorage.setItem(STORAGE_KEY, JSON.stringify(updatedSettings));
      setIsLocalStorage(true);
      
      return response.data;
    },
    onSuccess: (data: any) => {
      queryClient.invalidateQueries({ queryKey: ['collectionSettings'] });
      setHasChanges(false);
      
      // Check if database is connected
      if (data.warning && data.warning.includes('Database not connected')) {
        // Show less intrusive notification
        console.warn('⚠️ Settings saved locally. Database not connected.');
        // Don't show alert - the warning banner is already visible
      } else {
        alert('✅ Settings saved successfully! Changes will appear in the app on next launch.');
      }
    },
    onError: (error: any) => {
      // Even on error, save to localStorage
      if (settings) {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(settings));
        setIsLocalStorage(true);
        console.warn('⚠️ Settings saved locally. Database error occurred.');
        // Don't show alert - the warning banner is already visible
      } else {
        alert(`❌ Error: ${error.response?.data?.error || error.message}`);
      }
    },
  });

  // Reset settings mutation
  const resetMutation = useMutation({
    mutationFn: async () => {
      const response = await api.post('/api/collection/settings/reset');
      return response.data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['collectionSettings'] });
      setHasChanges(false);
      localStorage.removeItem(STORAGE_KEY);
      setIsLocalStorage(false);
      alert('✅ Settings reset to defaults!');
    },
    onError: (error: any) => {
      alert(`❌ Error: ${error.response?.data?.error || error.message}`);
    },
  });

  const handleChange = (field: keyof CollectionSettings, value: any) => {
    if (settings) {
      setSettings({ ...settings, [field]: value });
      setHasChanges(true);
    }
  };

  const handleSave = () => {
    if (settings) {
      updateMutation.mutate(settings);
    }
  };

  const handleReset = () => {
    if (confirm('Are you sure you want to reset all settings to defaults?')) {
      resetMutation.mutate();
      // Clear localStorage on reset
      localStorage.removeItem(STORAGE_KEY);
      setIsLocalStorage(false);
    }
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-gray-500">Loading settings...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-red-500">Error loading settings</div>
      </div>
    );
  }

  if (!settings) return null;

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Collection Page Settings</h1>
          <p className="text-gray-600 mt-1">
            Customize the appearance of your collection pages. Changes apply instantly without rebuilding the app.
          </p>
        </div>
        <div className="flex gap-3">
          <Button
            variant="outline"
            onClick={handleReset}
            disabled={resetMutation.isPending}
          >
            <RotateCcw className="w-4 h-4 mr-2" />
            Reset to Defaults
          </Button>
          <Button
            onClick={handleSave}
            disabled={!hasChanges || updateMutation.isPending}
          >
            <Save className="w-4 h-4 mr-2" />
            {updateMutation.isPending ? 'Saving...' : 'Save Changes'}
          </Button>
        </div>
      </div>

      {hasChanges && (
        <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
          <p className="text-yellow-800 text-sm">
            ⚠️ You have unsaved changes. Click "Save Changes" to apply them.
          </p>
        </div>
      )}

      {isLocalStorage && (
        <div className="bg-orange-50 border border-orange-200 rounded-lg p-4 mb-6">
          <div className="flex items-start gap-3">
            <div className="flex-shrink-0">
              <svg className="w-5 h-5 text-orange-600" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
              </svg>
            </div>
            <div className="flex-1">
              <h3 className="text-orange-800 font-semibold mb-1">Database Not Connected</h3>
              <p className="text-orange-700 text-sm mb-2">
                Settings are saved in browser storage only. Changes will NOT appear in the Flutter app until the database is connected.
              </p>
              <details className="text-sm">
                <summary className="text-orange-800 cursor-pointer font-medium hover:text-orange-900">
                  How to connect the database →
                </summary>
                <div className="mt-2 pl-4 border-l-2 border-orange-300 text-orange-700">
                  <ol className="list-decimal list-inside space-y-1">
                    <li>Go to <a href="https://railway.app" target="_blank" className="underline">Railway Dashboard</a></li>
                    <li>Open your Goeye project</li>
                    <li>Click "+ New" → "Database" → "PostgreSQL"</li>
                    <li>Click on your middleware service → "Variables" tab</li>
                    <li>Add variable: <code className="bg-orange-100 px-1 rounded">DATABASE_URL</code> = <code className="bg-orange-100 px-1 rounded">{'${{Postgres.DATABASE_URL}}'}</code></li>
                    <li>Wait 60-90 seconds for redeployment</li>
                    <li>Refresh this page - status should change to "Connected"</li>
                  </ol>
                </div>
              </details>
            </div>
          </div>
        </div>
      )}

      {/* Text & Typography Settings */}
      <Card>
        <div className="flex items-center gap-2 mb-4">
          <Type className="w-5 h-5 text-blue-600" />
          <h2 className="text-xl font-semibold">Text & Typography</h2>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <Label htmlFor="titleFontSize">Title Font Size</Label>
            <Input
              id="titleFontSize"
              type="number"
              value={settings.titleFontSize}
              onChange={(e) => handleChange('titleFontSize', parseInt(e.target.value))}
            />
          </div>
          <div>
            <Label htmlFor="titleFontFamily">Title Font Family</Label>
            <select
              id="titleFontFamily"
              value={settings.titleFontFamily}
              onChange={(e) => handleChange('titleFontFamily', e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="Roboto">Roboto</option>
              <option value="Poppins">Poppins</option>
              <option value="Inter">Inter</option>
              <option value="Open Sans">Open Sans</option>
            </select>
          </div>
          <div>
            <Label htmlFor="titleColor">Title Color</Label>
            <div className="flex gap-2">
              <Input
                id="titleColor"
                type="color"
                value={settings.titleColor}
                onChange={(e) => handleChange('titleColor', e.target.value)}
                className="w-16 h-10"
              />
              <Input
                type="text"
                value={settings.titleColor}
                onChange={(e) => handleChange('titleColor', e.target.value)}
                className="flex-1"
              />
            </div>
          </div>
        </div>
      </Card>

      {/* Price Settings */}
      <Card>
        <div className="flex items-center gap-2 mb-4">
          <DollarSign className="w-5 h-5 text-green-600" />
          <h2 className="text-xl font-semibold">Price Settings</h2>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <Label htmlFor="priceFontSize">Price Font Size</Label>
            <Input
              id="priceFontSize"
              type="number"
              value={settings.priceFontSize}
              onChange={(e) => handleChange('priceFontSize', parseInt(e.target.value))}
            />
          </div>
          <div>
            <Label htmlFor="priceColor">Price Color</Label>
            <div className="flex gap-2">
              <Input
                id="priceColor"
                type="color"
                value={settings.priceColor}
                onChange={(e) => handleChange('priceColor', e.target.value)}
                className="w-16 h-10"
              />
              <Input
                type="text"
                value={settings.priceColor}
                onChange={(e) => handleChange('priceColor', e.target.value)}
                className="flex-1"
              />
            </div>
          </div>
          <div>
            <Label htmlFor="originalPriceColor">Original Price Color</Label>
            <div className="flex gap-2">
              <Input
                id="originalPriceColor"
                type="color"
                value={settings.originalPriceColor}
                onChange={(e) => handleChange('originalPriceColor', e.target.value)}
                className="w-16 h-10"
              />
              <Input
                type="text"
                value={settings.originalPriceColor}
                onChange={(e) => handleChange('originalPriceColor', e.target.value)}
                className="flex-1"
              />
            </div>
          </div>
          <div className="flex items-center gap-2">
            <input
              type="checkbox"
              id="showOriginalPrice"
              checked={settings.showOriginalPrice}
              onChange={(e) => handleChange('showOriginalPrice', e.target.checked)}
              className="w-4 h-4 text-blue-600 rounded focus:ring-blue-500"
            />
            <Label htmlFor="showOriginalPrice" className="mb-0">Show Original Price</Label>
          </div>
        </div>
      </Card>

      {/* EMI Badge */}
      <Card>
        <div className="flex items-center gap-2 mb-4">
          <Tag className="w-5 h-5 text-purple-600" />
          <h2 className="text-xl font-semibold">EMI Badge</h2>
        </div>
        <div className="space-y-4">
          <div className="flex items-center gap-2">
            <input
              type="checkbox"
              id="showEMI"
              checked={settings.showEMI}
              onChange={(e) => handleChange('showEMI', e.target.checked)}
              className="w-4 h-4 text-blue-600 rounded focus:ring-blue-500"
            />
            <Label htmlFor="showEMI" className="mb-0">Show EMI Badge</Label>
          </div>
          {settings.showEMI && (
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <Label htmlFor="emiBadgeColor">Badge Background</Label>
                <div className="flex gap-2">
                  <Input
                    id="emiBadgeColor"
                    type="color"
                    value={settings.emiBadgeColor}
                    onChange={(e) => handleChange('emiBadgeColor', e.target.value)}
                    className="w-16 h-10"
                  />
                  <Input
                    type="text"
                    value={settings.emiBadgeColor}
                    onChange={(e) => handleChange('emiBadgeColor', e.target.value)}
                    className="flex-1"
                  />
                </div>
              </div>
              <div>
                <Label htmlFor="emiTextColor">Text Color</Label>
                <div className="flex gap-2">
                  <Input
                    id="emiTextColor"
                    type="color"
                    value={settings.emiTextColor}
                    onChange={(e) => handleChange('emiTextColor', e.target.value)}
                    className="w-16 h-10"
                  />
                  <Input
                    type="text"
                    value={settings.emiTextColor}
                    onChange={(e) => handleChange('emiTextColor', e.target.value)}
                    className="flex-1"
                  />
                </div>
              </div>
              <div>
                <Label htmlFor="emiFontSize">Font Size</Label>
                <Input
                  id="emiFontSize"
                  type="number"
                  value={settings.emiFontSize}
                  onChange={(e) => handleChange('emiFontSize', parseInt(e.target.value))}
                />
              </div>
            </div>
          )}
        </div>
      </Card>

      {/* Stock Badge */}
      <Card>
        <div className="flex items-center gap-2 mb-4">
          <Tag className="w-5 h-5 text-green-600" />
          <h2 className="text-xl font-semibold">Stock Badge</h2>
        </div>
        <div className="space-y-4">
          <div className="flex items-center gap-2">
            <input
              type="checkbox"
              id="showInStock"
              checked={settings.showInStock}
              onChange={(e) => handleChange('showInStock', e.target.checked)}
              className="w-4 h-4 text-blue-600 rounded focus:ring-blue-500"
            />
            <Label htmlFor="showInStock" className="mb-0">Show Stock Badge</Label>
          </div>
          {settings.showInStock && (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <Label htmlFor="inStockBadgeColor">In Stock Badge Color</Label>
                <div className="flex gap-2">
                  <Input
                    id="inStockBadgeColor"
                    type="color"
                    value={settings.inStockBadgeColor}
                    onChange={(e) => handleChange('inStockBadgeColor', e.target.value)}
                    className="w-16 h-10"
                  />
                  <Input
                    type="text"
                    value={settings.inStockBadgeColor}
                    onChange={(e) => handleChange('inStockBadgeColor', e.target.value)}
                    className="flex-1"
                  />
                </div>
              </div>
              <div>
                <Label htmlFor="inStockTextColor">In Stock Text Color</Label>
                <div className="flex gap-2">
                  <Input
                    id="inStockTextColor"
                    type="color"
                    value={settings.inStockTextColor}
                    onChange={(e) => handleChange('inStockTextColor', e.target.value)}
                    className="w-16 h-10"
                  />
                  <Input
                    type="text"
                    value={settings.inStockTextColor}
                    onChange={(e) => handleChange('inStockTextColor', e.target.value)}
                    className="flex-1"
                  />
                </div>
              </div>
              <div>
                <Label htmlFor="outOfStockBadgeColor">Out of Stock Badge Color</Label>
                <div className="flex gap-2">
                  <Input
                    id="outOfStockBadgeColor"
                    type="color"
                    value={settings.outOfStockBadgeColor}
                    onChange={(e) => handleChange('outOfStockBadgeColor', e.target.value)}
                    className="w-16 h-10"
                  />
                  <Input
                    type="text"
                    value={settings.outOfStockBadgeColor}
                    onChange={(e) => handleChange('outOfStockBadgeColor', e.target.value)}
                    className="flex-1"
                  />
                </div>
              </div>
              <div>
                <Label htmlFor="outOfStockTextColor">Out of Stock Text Color</Label>
                <div className="flex gap-2">
                  <Input
                    id="outOfStockTextColor"
                    type="color"
                    value={settings.outOfStockTextColor}
                    onChange={(e) => handleChange('outOfStockTextColor', e.target.value)}
                    className="w-16 h-10"
                  />
                  <Input
                    type="text"
                    value={settings.outOfStockTextColor}
                    onChange={(e) => handleChange('outOfStockTextColor', e.target.value)}
                    className="flex-1"
                  />
                </div>
              </div>
            </div>
          )}
        </div>
      </Card>

      {/* Discount Badge */}
      <Card>
        <div className="flex items-center gap-2 mb-4">
          <Tag className="w-5 h-5 text-orange-600" />
          <h2 className="text-xl font-semibold">Discount Badge</h2>
        </div>
        <div className="space-y-4">
          <div className="flex items-center gap-2">
            <input
              type="checkbox"
              id="showDiscountBadge"
              checked={settings.showDiscountBadge}
              onChange={(e) => handleChange('showDiscountBadge', e.target.checked)}
              className="w-4 h-4 text-blue-600 rounded focus:ring-blue-500"
            />
            <Label htmlFor="showDiscountBadge" className="mb-0">Show Discount Badge</Label>
          </div>
          {settings.showDiscountBadge && (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <Label htmlFor="discountBadgeColor">Badge Background</Label>
                <div className="flex gap-2">
                  <Input
                    id="discountBadgeColor"
                    type="color"
                    value={settings.discountBadgeColor}
                    onChange={(e) => handleChange('discountBadgeColor', e.target.value)}
                    className="w-16 h-10"
                  />
                  <Input
                    type="text"
                    value={settings.discountBadgeColor}
                    onChange={(e) => handleChange('discountBadgeColor', e.target.value)}
                    className="flex-1"
                  />
                </div>
              </div>
              <div>
                <Label htmlFor="discountTextColor">Text Color</Label>
                <div className="flex gap-2">
                  <Input
                    id="discountTextColor"
                    type="color"
                    value={settings.discountTextColor}
                    onChange={(e) => handleChange('discountTextColor', e.target.value)}
                    className="w-16 h-10"
                  />
                  <Input
                    type="text"
                    value={settings.discountTextColor}
                    onChange={(e) => handleChange('discountTextColor', e.target.value)}
                    className="flex-1"
                  />
                </div>
              </div>
            </div>
          )}
        </div>
      </Card>

      {/* Button Settings */}
      <Card>
        <div className="flex items-center gap-2 mb-4">
          <ShoppingCart className="w-5 h-5 text-blue-600" />
          <h2 className="text-xl font-semibold">Button Settings</h2>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <Label htmlFor="addToCartButtonColor">Add to Cart Button Color</Label>
            <div className="flex gap-2">
              <Input
                id="addToCartButtonColor"
                type="color"
                value={settings.addToCartButtonColor}
                onChange={(e) => handleChange('addToCartButtonColor', e.target.value)}
                className="w-16 h-10"
              />
              <Input
                type="text"
                value={settings.addToCartButtonColor}
                onChange={(e) => handleChange('addToCartButtonColor', e.target.value)}
                className="flex-1"
              />
            </div>
          </div>
          <div>
            <Label htmlFor="addToCartTextColor">Add to Cart Text Color</Label>
            <div className="flex gap-2">
              <Input
                id="addToCartTextColor"
                type="color"
                value={settings.addToCartTextColor}
                onChange={(e) => handleChange('addToCartTextColor', e.target.value)}
                className="w-16 h-10"
              />
              <Input
                type="text"
                value={settings.addToCartTextColor}
                onChange={(e) => handleChange('addToCartTextColor', e.target.value)}
                className="flex-1"
              />
            </div>
          </div>
          <div>
            <Label htmlFor="selectLensButtonColor">Select Lens Button Color</Label>
            <div className="flex gap-2">
              <Input
                id="selectLensButtonColor"
                type="color"
                value={settings.selectLensButtonColor}
                onChange={(e) => handleChange('selectLensButtonColor', e.target.value)}
                className="w-16 h-10"
              />
              <Input
                type="text"
                value={settings.selectLensButtonColor}
                onChange={(e) => handleChange('selectLensButtonColor', e.target.value)}
                className="flex-1"
              />
            </div>
          </div>
          <div>
            <Label htmlFor="selectLensTextColor">Select Lens Text Color</Label>
            <div className="flex gap-2">
              <Input
                id="selectLensTextColor"
                type="color"
                value={settings.selectLensTextColor}
                onChange={(e) => handleChange('selectLensTextColor', e.target.value)}
                className="w-16 h-10"
              />
              <Input
                type="text"
                value={settings.selectLensTextColor}
                onChange={(e) => handleChange('selectLensTextColor', e.target.value)}
                className="flex-1"
              />
            </div>
          </div>
          <div>
            <Label htmlFor="buttonBorderRadius">Button Border Radius</Label>
            <Input
              id="buttonBorderRadius"
              type="number"
              value={settings.buttonBorderRadius}
              onChange={(e) => handleChange('buttonBorderRadius', parseInt(e.target.value))}
            />
          </div>
          <div>
            <Label htmlFor="buttonFontSize">Button Font Size</Label>
            <Input
              id="buttonFontSize"
              type="number"
              value={settings.buttonFontSize}
              onChange={(e) => handleChange('buttonFontSize', parseInt(e.target.value))}
            />
          </div>
        </div>
      </Card>

      {/* Card Settings */}
      <Card>
        <div className="flex items-center gap-2 mb-4">
          <Palette className="w-5 h-5 text-indigo-600" />
          <h2 className="text-xl font-semibold">Card & Layout Settings</h2>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <Label htmlFor="cardBackgroundColor">Card Background</Label>
            <div className="flex gap-2">
              <Input
                id="cardBackgroundColor"
                type="color"
                value={settings.cardBackgroundColor}
                onChange={(e) => handleChange('cardBackgroundColor', e.target.value)}
                className="w-16 h-10"
              />
              <Input
                type="text"
                value={settings.cardBackgroundColor}
                onChange={(e) => handleChange('cardBackgroundColor', e.target.value)}
                className="flex-1"
              />
            </div>
          </div>
          <div>
            <Label htmlFor="cardBorderColor">Card Border Color</Label>
            <div className="flex gap-2">
              <Input
                id="cardBorderColor"
                type="color"
                value={settings.cardBorderColor}
                onChange={(e) => handleChange('cardBorderColor', e.target.value)}
                className="w-16 h-10"
              />
              <Input
                type="text"
                value={settings.cardBorderColor}
                onChange={(e) => handleChange('cardBorderColor', e.target.value)}
                className="flex-1"
              />
            </div>
          </div>
          <div>
            <Label htmlFor="cardBorderRadius">Card Border Radius</Label>
            <Input
              id="cardBorderRadius"
              type="number"
              value={settings.cardBorderRadius}
              onChange={(e) => handleChange('cardBorderRadius', parseInt(e.target.value))}
            />
          </div>
          <div>
            <Label htmlFor="cardElevation">Card Elevation (Shadow)</Label>
            <Input
              id="cardElevation"
              type="number"
              value={settings.cardElevation}
              onChange={(e) => handleChange('cardElevation', parseInt(e.target.value))}
            />
          </div>
          <div>
            <Label htmlFor="cardPadding">Card Padding</Label>
            <Input
              id="cardPadding"
              type="number"
              value={settings.cardPadding}
              onChange={(e) => handleChange('cardPadding', parseInt(e.target.value))}
            />
          </div>
          <div>
            <Label htmlFor="itemSpacing">Item Spacing</Label>
            <Input
              id="itemSpacing"
              type="number"
              value={settings.itemSpacing}
              onChange={(e) => handleChange('itemSpacing', parseInt(e.target.value))}
            />
          </div>
        </div>
      </Card>

      {/* Additional Features */}
      <Card>
        <div className="flex items-center gap-2 mb-4">
          <Tag className="w-5 h-5 text-yellow-600" />
          <h2 className="text-xl font-semibold">Additional Features</h2>
        </div>
        <div className="space-y-4">
          <div className="flex items-center gap-2">
            <input
              type="checkbox"
              id="showRatings"
              checked={settings.showRatings}
              onChange={(e) => handleChange('showRatings', e.target.checked)}
              className="w-4 h-4 text-blue-600 rounded focus:ring-blue-500"
            />
            <Label htmlFor="showRatings" className="mb-0">Show Product Ratings</Label>
          </div>
          {settings.showRatings && (
            <div>
              <Label htmlFor="ratingStarColor">Rating Star Color</Label>
              <div className="flex gap-2">
                <Input
                  id="ratingStarColor"
                  type="color"
                  value={settings.ratingStarColor}
                  onChange={(e) => handleChange('ratingStarColor', e.target.value)}
                  className="w-16 h-10"
                />
                <Input
                  type="text"
                  value={settings.ratingStarColor}
                  onChange={(e) => handleChange('ratingStarColor', e.target.value)}
                  className="flex-1"
                />
              </div>
            </div>
          )}
        </div>
      </Card>

      {/* Save Button at Bottom */}
      <div className="flex justify-end gap-3 sticky bottom-4 bg-white p-4 rounded-lg shadow-lg border">
        <Button
          variant="outline"
          onClick={handleReset}
          disabled={resetMutation.isPending}
        >
          <RotateCcw className="w-4 h-4 mr-2" />
          Reset to Defaults
        </Button>
        <Button
          onClick={handleSave}
          disabled={!hasChanges || updateMutation.isPending}
        >
          <Save className="w-4 h-4 mr-2" />
          {updateMutation.isPending ? 'Saving...' : 'Save Changes'}
        </Button>
      </div>
    </div>
  );
}

