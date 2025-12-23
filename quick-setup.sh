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
echo -e "${YELLOW}Available options:${NC}"
echo -e "${YELLOW}1. System & Package Management${NC}"
echo -e "${YELLOW}2. Theme Installation${NC}"
echo -e "${YELLOW}3. Web Browsers${NC}"
echo -e "${YELLOW}4. Communication Apps${NC}"
echo -e "${YELLOW}5. Media & Entertainment${NC}"
echo -e "${YELLOW}6. Development Tools${NC}"
echo -e "${YELLOW}7. Terminal & Shell${NC}"
echo -e "${YELLOW}8. Docker Setup (NEW!)${NC}"
echo -e "${YELLOW}9. Run ALL Setup Scripts${NC}"
echo -e "${YELLOW}10. Fully Automated Setup${NC}"
echo -e "${YELLOW}If you encounter permission issues, run: chmod +x *.sh && chmod +x bash-resources/*.sh${NC}"

# Run the menu
./setup-menu.sh