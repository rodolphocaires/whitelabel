import 'package:flutter/material.dart';
import '../services/brand_config_service.dart';

/// Utility class for switching between brands at runtime
/// This is useful for testing and demonstration purposes
class BrandSwitcher {
  static const List<String> availableBrands = [
    'default',
    'brand_a',
    'brand_b',
  ];

  /// Switch to a different brand configuration
  static Future<void> switchToBrand(String brandId) async {
    if (!availableBrands.contains(brandId)) {
      throw ArgumentError('Brand $brandId is not available');
    }

    await BrandConfigService.reloadConfig(brandId);
  }

  /// Get list of available brands
  static List<String> getAvailableBrands() {
    return List.from(availableBrands);
  }

  /// Check if a brand is currently active
  static bool isBrandActive(String brandId) {
    final currentConfig = BrandConfigService.currentConfig;
    if (currentConfig == null) return false;
    
    // Simple check based on brand name
    return currentConfig.brandName.toLowerCase().contains(brandId.toLowerCase());
  }

  /// Create a brand switcher widget for testing
  static Widget createSwitcherWidget({
    required VoidCallback onBrandChanged,
  }) {
    return BrandSwitcherWidget(onBrandChanged: onBrandChanged);
  }
}

class BrandSwitcherWidget extends StatefulWidget {
  final VoidCallback onBrandChanged;

  const BrandSwitcherWidget({
    super.key,
    required this.onBrandChanged,
  });

  @override
  State<BrandSwitcherWidget> createState() => _BrandSwitcherWidgetState();
}

class _BrandSwitcherWidgetState extends State<BrandSwitcherWidget> {
  String? _selectedBrand;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedBrand = BrandSwitcher.availableBrands.first;
  }

  Future<void> _switchBrand(String brandId) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await BrandSwitcher.switchToBrand(brandId);
      setState(() {
        _selectedBrand = brandId;
      });
      widget.onBrandChanged();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to switch brand: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Brand Switcher',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Switch between different brand configurations:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: BrandSwitcher.availableBrands.map((brand) {
                final isSelected = brand == _selectedBrand;
                return FilterChip(
                  label: Text(brand.replaceAll('_', ' ').toUpperCase()),
                  selected: isSelected,
                  onSelected: _isLoading ? null : (selected) {
                    if (selected && !isSelected) {
                      _switchBrand(brand);
                    }
                  },
                );
              }).toList(),
            ),
            if (_isLoading) ...[
              const SizedBox(height: 16),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
