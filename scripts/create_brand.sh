#!/bin/bash

# White Label App Brand Creation Script
# Usage: ./scripts/create_brand.sh <brand_id> <brand_name> <app_title> <primary_color>
# Example: ./scripts/create_brand.sh brand_c "Brand C" "Brand C Enterprise" "#FF6B35"

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required arguments are provided
if [ $# -lt 4 ]; then
    print_error "Usage: $0 <brand_id> <brand_name> <app_title> <primary_color>"
    print_error "Example: $0 brand_c \"Brand C\" \"Brand C Enterprise\" \"#FF6B35\""
    exit 1
fi

BRAND_ID=$1
BRAND_NAME=$2
APP_TITLE=$3
PRIMARY_COLOR=$4

# Validate brand doesn't already exist
if [ -d "assets/brands/$BRAND_ID" ]; then
    print_error "Brand already exists: $BRAND_ID"
    exit 1
fi

print_status "Creating new brand: $BRAND_ID"

# Create brand directory
mkdir -p "assets/brands/$BRAND_ID"

# Create brand configuration
cat > "assets/brands/$BRAND_ID/config.json" << EOF
{
  "brandName": "$BRAND_NAME",
  "appTitle": "$APP_TITLE",
  "logoPath": "assets/brands/$BRAND_ID/logo.png",
  "primaryColorHex": "$PRIMARY_COLOR",
  "secondaryColorHex": "#03DAC6",
  "accentColorHex": "#FF5722",
  "backgroundColorHex": "#FFFFFF",
  "textColorHex": "#000000",
  "fontFamily": "Roboto",
  "assets": {
    "logo": "assets/brands/$BRAND_ID/logo.png",
    "splash_background": "assets/brands/$BRAND_ID/splash_bg.png",
    "app_icon": "assets/brands/$BRAND_ID/app_icon.png"
  },
  "customSettings": {
    "enableAnalytics": true,
    "apiBaseUrl": "https://api.${BRAND_ID}.com",
    "supportEmail": "support@${BRAND_ID}.com",
    "termsUrl": "https://${BRAND_ID}.com/terms",
    "privacyUrl": "https://${BRAND_ID}.com/privacy"
  }
}
EOF

# Create placeholder assets
touch "assets/brands/$BRAND_ID/logo.png"
touch "assets/brands/$BRAND_ID/splash_bg.png"
touch "assets/brands/$BRAND_ID/app_icon.png"

print_status "Brand created successfully: $BRAND_ID"
print_warning "Don't forget to:"
print_warning "1. Replace placeholder assets with actual brand assets"
print_warning "2. Update BrandSwitcher.availableBrands in lib/utils/brand_switcher.dart"
print_warning "3. Customize colors and settings in the configuration file"

print_status "Brand configuration saved to: assets/brands/$BRAND_ID/config.json"
