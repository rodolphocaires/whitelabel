#!/bin/bash

# Build-time Brand Configuration Script
# Usage: ./scripts/build_brand.sh <brand_id> <platform> [build_mode]
# Example: ./scripts/build_brand.sh brand_a android release

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
if [ $# -lt 2 ]; then
    print_error "Usage: $0 <brand_id> <platform> [build_mode]"
    print_error "Platforms: ios, android, web"
    print_error "Build modes: debug, release, profile (default: release)"
    exit 1
fi

BRAND_ID=$1
PLATFORM=$2
BUILD_MODE=${3:-release}

# Validate brand exists
if [ ! -f "assets/brands/$BRAND_ID/config.json" ]; then
    print_error "Brand configuration not found: assets/brands/$BRAND_ID/config.json"
    exit 1
fi

print_status "Building app with brand: $BRAND_ID for platform: $PLATFORM in $BUILD_MODE mode"

# Clean and prepare
print_status "Cleaning and preparing build..."
flutter clean
flutter pub get

# Generate code if needed
print_status "Generating code..."
dart run build_runner build --delete-conflicting-outputs

# Build with brand configuration
case $PLATFORM in
    ios)
        print_status "Building for iOS..."
        flutter build ios --$BUILD_MODE --dart-define=BRAND_ID=$BRAND_ID
        ;;
    android)
        print_status "Building for Android..."
        if [ "$BUILD_MODE" = "release" ]; then
            flutter build apk --release --dart-define=BRAND_ID=$BRAND_ID
        else
            flutter build apk --$BUILD_MODE --dart-define=BRAND_ID=$BRAND_ID
        fi
        ;;
    web)
        print_status "Building for Web..."
        flutter build web --$BUILD_MODE --dart-define=BRAND_ID=$BRAND_ID
        ;;
    *)
        print_error "Invalid platform: $PLATFORM. Use 'ios', 'android', or 'web'"
        exit 1
        ;;
esac

print_status "Build completed successfully!"

# Show build info
print_status "Build Information:"
echo "Brand: $(cat assets/brands/$BRAND_ID/config.json | jq -r '.brandName')"
echo "App Title: $(cat assets/brands/$BRAND_ID/config.json | jq -r '.appTitle')"
echo "Platform: $PLATFORM"
echo "Build Mode: $BUILD_MODE"
echo "Brand ID: $BRAND_ID"

# Show output location
case $PLATFORM in
    ios)
        echo "Output: build/ios/iphoneos/Runner.app"
        ;;
    android)
        echo "Output: build/app/outputs/flutter-apk/app-$BUILD_MODE.apk"
        ;;
    web)
        echo "Output: build/web/"
        ;;
esac
