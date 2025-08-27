#!/bin/bash

# Run app with specific brand configuration
# Usage: ./scripts/run_brand.sh <brand_id> [device]
# Example: ./scripts/run_brand.sh brand_a
# Example: ./scripts/run_brand.sh brand_a emulator-5554

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if brand ID is provided
if [ $# -lt 1 ]; then
    print_error "Usage: $0 <brand_id> [device]"
    print_error "Available brands: default, brand_a, brand_b"
    exit 1
fi

BRAND_ID=$1
DEVICE=${2:-""}

# Validate brand exists
if [ ! -f "assets/brands/$BRAND_ID/config.json" ]; then
    print_error "Brand configuration not found: assets/brands/$BRAND_ID/config.json"
    exit 1
fi

print_status "Running app with brand: $BRAND_ID"

# Show brand info
echo "Brand: $(cat assets/brands/$BRAND_ID/config.json | jq -r '.brandName')"
echo "App Title: $(cat assets/brands/$BRAND_ID/config.json | jq -r '.appTitle')"

# Run with brand configuration
if [ -n "$DEVICE" ]; then
    flutter run --dart-define=BRAND_ID=$BRAND_ID -d $DEVICE
else
    flutter run --dart-define=BRAND_ID=$BRAND_ID
fi
