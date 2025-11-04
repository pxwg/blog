#!/bin/bash

# Font deployment script for CI/CD environments
# This script ensures STIX fonts are available during astro build

echo "Setting up fonts for deployment..."

# Create system fonts directory
sudo mkdir -p /usr/share/fonts/truetype/stix

# Copy STIX font from assets/fonts to system location
sudo cp assets/fonts/STIXTwoMath-Regular.otf /usr/share/fonts/truetype/stix/
# Copy Libertinus Math font to system location
sudo cp assets/fonts/LibertinusMath-Regular.otf /usr/share/fonts/truetype/stix/

# Update font cache
sudo fc-cache -f -v

# Verify font installation
echo "Checking font installation..."
fc-list | grep -i stix || echo "STIX font not found in system"

# Ensure fonts are available in fallback locations
mkdir -p public/fonts

# Copy to public/fonts as fallback
cp assets/fonts/STIXTwoMath-Regular.otf public/fonts/

echo "Font deployment setup complete"
echo "STIX font available in:"
echo "  - Primary: assets/fonts/"
echo "  - System: /usr/share/fonts/truetype/stix/"
echo "  - Fallback: public/fonts/"
