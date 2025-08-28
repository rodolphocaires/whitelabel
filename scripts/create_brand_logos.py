#!/usr/bin/env python3
"""
Script to create simple brand logos for testing
"""
from PIL import Image, ImageDraw, ImageFont
import os

def create_logo(brand_id, color, letter, size=192):
    """Create a simple logo with brand color and letter"""
    # Create image with brand color background
    img = Image.new('RGB', (size, size), color)
    draw = ImageDraw.Draw(img)
    
    # Try to use a system font, fallback to default
    try:
        font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", size//2)
    except:
        font = ImageFont.load_default()
    
    # Get text size and center it
    bbox = draw.textbbox((0, 0), letter, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    x = (size - text_width) // 2
    y = (size - text_height) // 2
    
    # Draw white letter
    draw.text((x, y), letter, fill='white', font=font)
    
    return img

def main():
    # Brand configurations
    brands = {
        'brand_a': {'color': '#E91E63', 'letter': 'A'},
        'brand_b': {'color': '#673AB7', 'letter': 'B'}
    }
    
    base_path = '/Users/rod/Development/sandbox/whitelabel/assets/brands'
    
    for brand_id, config in brands.items():
        brand_path = os.path.join(base_path, brand_id)
        logo_path = os.path.join(brand_path, 'logo.png')
        
        # Create logo
        logo = create_logo(brand_id, config['color'], config['letter'])
        logo.save(logo_path)
        print(f"Created logo for {brand_id}: {logo_path}")

if __name__ == '__main__':
    main()
