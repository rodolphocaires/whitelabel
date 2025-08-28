import 'package:flutter/material.dart';
import '../services/brand_config_service.dart';

/// A widget that displays the current brand's logo
class BrandLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;

  const BrandLogo({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final config = BrandConfigService.currentConfig;
    
    if (config == null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.image, color: Colors.grey),
      );
    }

    final logoPath = config.assets['logo'];
    
    if (logoPath == null || logoPath.isEmpty) {
      // Fallback to brand initials if no logo is configured
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [config.primaryColor, config.secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            config.brandName.split(' ').map((word) => word[0]).join(''),
            style: TextStyle(
              color: config.textColor,
              fontSize: (width ?? 100) * 0.3,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // Check if the logo path is a URL or local asset
    final isUrl = logoPath.startsWith('http://') || logoPath.startsWith('https://');
    
    Widget imageWidget;
    if (isUrl) {
      imageWidget = Image.network(
        logoPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.broken_image, color: Colors.grey),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    } else {
      imageWidget = Image.asset(
        logoPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.broken_image, color: Colors.grey),
          );
        },
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageWidget,
    );
  }
}
