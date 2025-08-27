#!/bin/bash

# White Label App Deployment Script
# Usage: ./scripts/deploy_brand.sh <brand_id> <platform> [build_type]
# Example: ./scripts/deploy_brand.sh brand_a ios release

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
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
    print_error "Usage: $0 <brand_id> <platform> [build_type]"
    print_error "Platforms: ios, android, both"
    print_error "Build types: debug, release (default: release)"
    exit 1
fi

BRAND_ID=$1
PLATFORM=$2
BUILD_TYPE=${3:-release}

# Validate brand exists
if [ ! -f "assets/brands/$BRAND_ID/config.json" ]; then
    print_error "Brand configuration not found: assets/brands/$BRAND_ID/config.json"
    exit 1
fi

print_status "Deploying brand: $BRAND_ID for platform: $PLATFORM"

# Clean previous builds
print_status "Cleaning previous builds..."
flutter clean
flutter pub get

# Generate code if needed
print_status "Generating code..."
dart run build_runner build --delete-conflicting-outputs

# Deploy using Fastlane
case $PLATFORM in
    ios)
        print_status "Deploying to iOS..."
        cd fastlane
        if [ "$BUILD_TYPE" = "release" ]; then
            fastlane ios build_and_deploy brand_id:$BRAND_ID
        else
            fastlane ios deploy_brand brand_id:$BRAND_ID
        fi
        cd ..
        ;;
    android)
        print_status "Deploying to Android..."
        cd fastlane
        if [ "$BUILD_TYPE" = "release" ]; then
            fastlane android build_and_deploy brand_id:$BRAND_ID
        else
            fastlane android deploy_brand brand_id:$BRAND_ID
        fi
        cd ..
        ;;
    both)
        print_status "Deploying to both iOS and Android..."
        cd fastlane
        if [ "$BUILD_TYPE" = "release" ]; then
            fastlane ios build_and_deploy brand_id:$BRAND_ID
            fastlane android build_and_deploy brand_id:$BRAND_ID
        else
            fastlane ios deploy_brand brand_id:$BRAND_ID
            fastlane android deploy_brand brand_id:$BRAND_ID
        fi
        cd ..
        ;;
    *)
        print_error "Invalid platform: $PLATFORM. Use 'ios', 'android', or 'both'"
        exit 1
        ;;
esac

print_status "Deployment completed successfully for brand: $BRAND_ID"

# Show brand configuration summary
print_status "Brand Configuration Summary:"
echo "$(cat assets/brands/$BRAND_ID/config.json | jq -r '.brandName + " - " + .appTitle')"
echo "Primary Color: $(cat assets/brands/$BRAND_ID/config.json | jq -r '.primaryColorHex')"
echo "API Base URL: $(cat assets/brands/$BRAND_ID/config.json | jq -r '.customSettings.apiBaseUrl // "Not specified"')"
