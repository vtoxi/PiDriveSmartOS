#!/bin/bash
###############################################################################
# PiDriveSmartOS - Developer Mode Toggle Script
# 
# Switches between Car Mode and Developer Mode
# Usage: sudo ./toggle_dev_mode.sh [car|dev]
###############################################################################

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
CONFIG_FILE="/boot/firmware/devmode.cfg"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Error: Please run as root (sudo)${NC}"
    exit 1
fi

# Get current mode
get_current_mode() {
    if [ -f "$CONFIG_FILE" ]; then
        MODE=$(grep "^car_mode=" "$CONFIG_FILE" | cut -d'=' -f2)
        if [ "$MODE" = "0" ]; then
            echo "developer"
        else
            echo "car"
        fi
    else
        echo "car"  # Default
    fi
}

# Set mode
set_mode() {
    local mode=$1
    
    # Create config if doesn't exist
    if [ ! -f "$CONFIG_FILE" ]; then
        touch "$CONFIG_FILE"
    fi
    
    if [ "$mode" = "car" ]; then
        echo "car_mode=1" > "$CONFIG_FILE"
        echo -e "${GREEN}Switched to Car Mode${NC}"
        echo ""
        echo "Features:"
        echo "  ✓ Full-screen Car UI"
        echo "  ✓ Read-only filesystem"
        echo "  ✓ SSH disabled"
        echo "  ✓ Optimized for driving"
    elif [ "$mode" = "dev" ]; then
        echo "car_mode=0" > "$CONFIG_FILE"
        echo -e "${BLUE}Switched to Developer Mode${NC}"
        echo ""
        echo "Features:"
        echo "  ✓ Full desktop environment"
        echo "  ✓ SSH enabled"
        echo "  ✓ Terminal access"
        echo "  ✓ Development tools"
    fi
    
    chmod 644 "$CONFIG_FILE"
}

# Display banner
echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   PiDriveSmartOS Mode Switcher                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Get current mode
CURRENT_MODE=$(get_current_mode)
echo -e "Current mode: ${YELLOW}$(echo $CURRENT_MODE | tr '[:lower:]' '[:upper:]')${NC}"
echo ""

# If no argument, show interactive menu
if [ -z "$1" ]; then
    echo "Select mode:"
    echo "  1) Car Mode (Production)"
    echo "  2) Developer Mode"
    echo "  q) Quit"
    echo ""
    read -p "Choice: " choice
    
    case $choice in
        1)
            set_mode "car"
            ;;
        2)
            set_mode "dev"
            ;;
        q|Q)
            echo "Cancelled"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            exit 1
            ;;
    esac
else
    # Use command line argument
    case $1 in
        car)
            set_mode "car"
            ;;
        dev|developer)
            set_mode "dev"
            ;;
        *)
            echo -e "${RED}Invalid mode: $1${NC}"
            echo "Usage: $0 [car|dev]"
            exit 1
            ;;
    esac
fi

echo ""
echo -e "${YELLOW}Reboot required to apply changes.${NC}"
read -p "Reboot now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Rebooting...${NC}"
    reboot
else
    echo "Please reboot manually: sudo reboot"
fi

