# White Label Flutter App

A Flutter application designed for white labeling with dynamic theming and asset management through Fastlane pipelines.

## Features

- **Dynamic Brand Configuration**: JSON-based brand configuration system
- **Theme Management**: Automatic theme generation from brand colors
- **Asset Management**: Brand-specific assets and logos
- **Fastlane Integration**: Automated deployment pipeline for different brands
- **Runtime Brand Switching**: Switch between brands for testing (development only)

## Project Structure

```
lib/
├── models/
│   ├── brand_config.dart      # Brand configuration model
│   └── brand_config.g.dart    # Generated JSON serialization
├── services/
│   └── brand_config_service.dart # Brand configuration service
├── utils/
│   └── brand_switcher.dart    # Brand switching utility
└── main.dart                  # Main application entry point

assets/
├── config/
│   └── default_brand.json     # Default brand configuration
└── brands/
    ├── default/               # Default brand assets
    ├── brand_a/               # Brand A configuration and assets
    ├── brand_b/               # Brand B configuration and assets
    └── active/                # Active brand assets (managed by Fastlane)

fastlane/
├── Fastfile                   # Fastlane deployment configuration
└── Appfile                    # App-specific Fastlane configuration
```

## Brand Configuration

Each brand is defined by a JSON configuration file containing:

- **Brand Identity**: Name, app title, logo path
- **Colors**: Primary, secondary, accent, background, text colors (hex format)
- **Typography**: Font family
- **Assets**: Brand-specific asset paths
- **Custom Settings**: API URLs, feature flags, etc.

### Example Brand Configuration

```json
{
  "brandName": "Brand A",
  "appTitle": "Brand A Mobile",
  "logoPath": "assets/brands/brand_a/logo.png",
  "primaryColorHex": "#E91E63",
  "secondaryColorHex": "#FFC107",
  "accentColorHex": "#4CAF50",
  "backgroundColorHex": "#FAFAFA",
  "textColorHex": "#212121",
  "fontFamily": "Roboto",
  "assets": {
    "logo": "assets/brands/brand_a/logo.png",
    "splash_background": "assets/brands/brand_a/splash_bg.png",
    "app_icon": "assets/brands/brand_a/app_icon.png"
  },
  "customSettings": {
    "enableAnalytics": true,
    "apiBaseUrl": "https://api.branda.com",
    "supportEmail": "support@branda.com"
  }
}
```

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Fastlane (for deployment automation)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate JSON serialization code:
   ```bash
   dart run build_runner build
   ```

### Running the App

#### Default Brand
```bash
flutter run
```

#### Specific Brand (Development)
Modify the `main()` function in `lib/main.dart`:
```dart
await BrandConfigService.initialize('brand_a'); // or 'brand_b'
```

### Brand Switching (Development)

The app includes a brand switcher widget for testing different configurations in development mode. Use the chips at the top of the app to switch between brands.

## Deployment with Fastlane

### iOS Deployment

Deploy a specific brand to iOS:
```bash
cd fastlane
fastlane ios deploy_brand brand_id:brand_a
```

Build and deploy:
```bash
fastlane ios build_and_deploy brand_id:brand_a
```

### Android Deployment

Deploy a specific brand to Android:
```bash
cd fastlane
fastlane android deploy_brand brand_id:brand_a
```

Build and deploy:
```bash
fastlane android build_and_deploy brand_id:brand_a
```

## Adding New Brands

1. Create a new directory under `assets/brands/` (e.g., `brand_c/`)
2. Add the brand configuration file: `assets/brands/brand_c/config.json`
3. Add brand-specific assets (logo, splash screen, app icon)
4. Update the `BrandSwitcher.availableBrands` list in `lib/utils/brand_switcher.dart`
5. Deploy using Fastlane

## Customization

### Theme Customization

The `BrandConfig` class automatically generates Flutter `ThemeData` from the brand colors. You can customize the theme generation in the `themeData` getter.

### Asset Management

Brand-specific assets are managed through the `assets` map in the brand configuration. The `BrandConfigService.getAssetPath()` method provides access to these assets.

### Custom Settings

Use the `customSettings` map in brand configurations to store brand-specific feature flags, API endpoints, and other configuration values.

## Development Notes

- The app uses JSON serialization with `json_annotation` and `build_runner`
- Brand configurations are loaded at app startup
- The brand switcher is only intended for development/testing
- Fastlane handles asset copying and platform-specific configurations
- Asset directory lint warnings can be ignored as directories are created programmatically

## Production Deployment

For production deployments:

1. Remove or disable the brand switcher widget
2. Set the specific brand ID in the `main()` function
3. Use Fastlane to deploy with the appropriate brand configuration
4. Ensure all brand assets are properly sized for their target platforms

## Contributing

When adding new features:

1. Consider how they might vary between brands
2. Add configuration options to the `BrandConfig` model if needed
3. Update the Fastlane deployment scripts for new asset types
4. Test with multiple brand configurations
