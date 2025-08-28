# White Label Flutter App

A Flutter application designed for white labeling with dynamic theming and asset management through Fastlane pipelines.

## Features

- **Dynamic Brand Configuration**: JSON-based brand configuration system
- **Theme Management**: Automatic theme generation from brand colors
- **Asset Management**: Brand-specific assets and logos
- **Fastlane Integration**: Automated deployment pipeline for different brands

## Project Structure

```
lib/
├── models/
│   ├── brand_config.dart      # Brand configuration model
│   └── brand_config.g.dart    # Generated JSON serialization
├── services/
│   └── brand_config_service.dart # Brand configuration service
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

### Example Brand Configuration

```json
{
  "brandName": "Brand A",
  "appTitle": "Brand A Mobile",
  "splashScreenUrl": "https://picsum.photos/400/800?random=2",
  "primaryColorHex": "#E91E63",
  "secondaryColorHex": "#FFC107",
  "accentColorHex": "#4CAF50",
  "backgroundColorHex": "#FAFAFA",
  "textColorHex": "#212121",
  "fontFamily": "Roboto",
  "assets": {
    "logo": "https://picsum.photos/200/200?random=1",
    "splash_background": "https://picsum.photos/400/800?random=2",
    "app_icon": "https://picsum.photos/200/200?random=1"
  }
}
```

**Asset URLs**: The `assets` object supports both local file paths and remote URLs:
- **Local assets**: `"logo": "assets/brands/brand_a/logo.png"`
- **Remote URLs**: `"logo": "https://example.com/logo.png"`

The system automatically detects URLs (starting with `http://` or `https://`) and loads them using `Image.network()` with proper error handling and loading states.

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
Use the VS Code launch configurations or set the BRAND_ID environment variable:
```bash
flutter run --dart-define=BRAND_ID=brand_a
```

## Deployment with Fastlane

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
4. Deploy using Fastlane or GitHub Actions

## Customization

### Theme Customization

The `BrandConfig` class automatically generates Flutter `ThemeData` from the brand colors. You can customize the theme generation in the `themeData` getter.

### Asset Management

Brand-specific assets are managed through the `assets` map in the brand configuration. The `BrandConfigService.getAssetPath()` method provides access to these assets.


## Development Notes

- The app uses JSON serialization with `json_annotation` and `build_runner`
- Brand configurations are loaded at app startup
- Fastlane handles asset copying and platform-specific configurations
- Asset directory lint warnings can be ignored as directories are created programmatically

## GitHub Actions Pipelines

### Create and Deploy New Brand

The repository includes a GitHub Actions workflow for creating and deploying new brands automatically:

1. **Go to Actions tab** in your GitHub repository
2. **Select "Create and Deploy New Brand"** workflow
3. **Fill in the parameters**:
   - **Brand ID**: Unique identifier (lowercase, no spaces)
   - **Brand Config URL**: URL to your JSON configuration file
   - **Platform**: Android (default)
   - **Build Mode**: Release or Debug

#### Example Usage

1. Host your brand configuration JSON file (e.g., on GitHub raw, CDN, or any public URL)
2. Run the workflow with the URL: `https://raw.githubusercontent.com/user/repo/main/config.json`
3. The pipeline will:
   - Validate the configuration
   - Create the brand directory structure
   - Generate the brand configuration file
   - Deploy to Android
   - Upload build artifacts

### Manual Deployment

You can also trigger deployments manually using the existing workflows:
- **Build and Test**: Runs tests and builds the app
- **Deploy Android**: Deploys a specific brand to Android

## Production Deployment

For production deployments:

1. Set the specific brand ID using environment variables
2. Use GitHub Actions or Fastlane to deploy with the appropriate brand configuration
3. Ensure all brand assets are properly sized for their target platforms

## Contributing

When adding new features:

1. Consider how they might vary between brands
2. Add configuration options to the `BrandConfig` model if needed
3. Update the Fastlane deployment scripts for new asset types
4. Test with multiple brand configurations
