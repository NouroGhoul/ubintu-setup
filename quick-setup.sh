#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Setting up Ubuntu Setup Scripts...${NC}"

# Make all scripts executable
echo "Making scripts executable..."
chmod +x *.sh
chmod +x bash-resources/*.sh

echo -e "${GREEN}All scripts are now executable!${NC}"
echo -e "${YELLOW}Starting the setup menu...${NC}"

# Run the menu
./setup-menu.sh