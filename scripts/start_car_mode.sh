#!/bin/bash
###############################################################################
# PiDriveSmartOS - Car Mode Startup Script
# 
# Launches the system in Car Mode (kiosk mode)
# Called by systemd or can be run manually
###############################################################################

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
CONFIG_FILE="/boot/firmware/devmode.cfg"
CAR_UI_BIN="/opt/pidrive/bin/carui"

echo -e "${GREEN}PiDriveSmartOS Starting in Car Mode...${NC}"

# Check configuration
if [ -f "$CONFIG_FILE" ]; then
    MODE=$(grep "^car_mode=" "$CONFIG_FILE" | cut -d'=' -f2)
    if [ "$MODE" != "1" ]; then
        echo -e "${YELLOW}Warning: Not in Car Mode (car_mode=$MODE)${NC}"
        echo -e "${YELLOW}Launching anyway...${NC}"
    fi
fi

# Disable screen blanking
echo -e "${GREEN}Disabling screen blanking...${NC}"
xset s off 2>/dev/null || true
xset -dpms 2>/dev/null || true
xset s noblank 2>/dev/null || true

# Hide mouse cursor
echo -e "${GREEN}Hiding cursor...${NC}"
unclutter -idle 0.1 -root &

# Set Qt environment
export QT_QPA_PLATFORM=eglfs
export QT_QPA_EGLFS_HIDECURSOR=1
export QT_QPA_EGLFS_INTEGRATION=eglfs_kms
export QT_QPA_EGLFS_KMS_CONFIG=/etc/pidrive/kms.json
export QT_LOGGING_RULES="*.debug=false"

# Check if OBD service is running
if systemctl is-active --quiet obdsvc.service; then
    echo -e "${GREEN}OBD service is running${NC}"
else
    echo -e "${YELLOW}Warning: OBD service is not running${NC}"
    echo -e "${YELLOW}Starting OBD service...${NC}"
    systemctl start obdsvc.service || true
fi

# Check if GPS service is running
if systemctl is-active --quiet gpsd.service; then
    echo -e "${GREEN}GPS service is running${NC}"
else
    echo -e "${YELLOW}Warning: GPS service is not running${NC}"
    systemctl start gpsd.service || true
fi

# Launch Car UI
echo -e "${GREEN}Launching Car UI...${NC}"
if [ -x "$CAR_UI_BIN" ]; then
    exec "$CAR_UI_BIN"
else
    echo -e "${RED}Error: Car UI binary not found or not executable${NC}"
    echo -e "${RED}Path: $CAR_UI_BIN${NC}"
    exit 1
fi

