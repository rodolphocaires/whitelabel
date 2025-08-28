import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/brand_config.dart';

class BrandConfigService {
  static BrandConfig? _currentConfig;
  static const String _defaultConfigPath = 'assets/config/default_brand.json';
  static const String _configPathPrefix = 'assets/brands/';

  /// Get the current brand configuration
  static BrandConfig? get currentConfig => _currentConfig;

  /// Load brand configuration from assets
  /// If brandId is null, loads the default configuration
  static Future<BrandConfig> loadBrandConfig([String? brandId]) async {
    try {
      String configPath;
      if (brandId != null) {
        configPath = '$_configPathPrefix$brandId/config.json';
      } else {
        configPath = _defaultConfigPath;
      }

      final String configString = await rootBundle.loadString(configPath);
      final Map<String, dynamic> configJson = json.decode(configString);

      _currentConfig = BrandConfig.fromJson(configJson);
      return _currentConfig!;
    } catch (e) {
      // Fallback to default configuration if specific brand config fails
      if (brandId != null) {
        debugPrint(
          'Failed to load brand config for $brandId, falling back to default: $e',
        );
        return loadBrandConfig(); // Load default
      }

      // If even default fails, create a minimal fallback
      debugPrint('Failed to load default brand config, using fallback: $e');
      _currentConfig = _createFallbackConfig();
      return _currentConfig!;
    }
  }

  /// Initialize the brand configuration service
  /// This should be called early in the app lifecycle
  static Future<void> initialize([String? brandId]) async {
    await loadBrandConfig(brandId);
  }

  /// Get asset path for the current brand
  static String getAssetPath(String assetKey) {
    final config = _currentConfig;
    if (config == null) {
      throw StateError(
        'Brand configuration not loaded. Call initialize() first.',
      );
    }

    // Check if the asset is defined in the brand config
    if (config.assets.containsKey(assetKey)) {
      return config.assets[assetKey]!;
    }

    // Fallback to default asset path
    return 'assets/brands/default/$assetKey';
  }

  /// Get the logo path for the current brand
  static String get logoPath {
    final config = _currentConfig;
    if (config == null) {
      throw StateError(
        'Brand configuration not loaded. Call initialize() first.',
      );
    }
    return config.logoPath;
  }

  /// Create a fallback configuration when all else fails
  static BrandConfig _createFallbackConfig() {
    return const BrandConfig(
      brandName: 'Default Brand',
      appTitle: 'White Label App',
      logoPath: 'assets/brands/default/logo.png',
      splashScreenUrl: 'https://picsum.photos/400/800?random=1',
      primaryColorHex: '#2196F3',
      secondaryColorHex: '#03DAC6',
      accentColorHex: '#FF5722',
      backgroundColorHex: '#FFFFFF',
      textColorHex: '#000000',
      fontFamily: 'Roboto',
      assets: {},
      customSettings: {},
    );
  }

  /// Reload configuration (useful for testing or dynamic brand switching)
  static Future<BrandConfig> reloadConfig([String? brandId]) async {
    _currentConfig = null;
    return loadBrandConfig(brandId);
  }

  /// Check if a brand configuration exists
  static Future<bool> brandExists(String brandId) async {
    try {
      final configPath = '$_configPathPrefix$brandId/config.json';
      await rootBundle.loadString(configPath);
      return true;
    } catch (e) {
      return false;
    }
  }
}
