#!/bin/bash

# Font deployment script for CI/CD environments
# This script ensures STIX fonts are available during astro build

echo "Setting up fonts for deployment..."

# Create system fonts directory
sudo mkdir -p /usr/share/fonts/truetype/stix

# Copy STIX font to system location
sudo cp STIXTwoMath-Regular.otf /usr/share/fonts/truetype/stix/

# Update font cache
sudo fc-cache -f -v

# Verify font installation
echo "Checking font installation..."
fc-list | grep -i stix || echo "STIX font not found in system"

# Also ensure fonts are in all expected project locations
mkdir -p assets/fonts public/fonts

# Copy to project font directories
cp STIXTwoMath-Regular.otf assets/fonts/
cp STIXTwoMath-Regular.otf public/fonts/

echo "Font deployment setup complete"
echo "STIX font available in:"
echo "  - System: /usr/share/fonts/truetype/stix/"
echo "  - Project: assets/fonts/"
echo "  - Public: public/fonts/"
echo "  - Root: ."