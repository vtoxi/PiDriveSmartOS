#!/bin/bash
###############################################################################
# PiDriveSmartOS - SocketCAN Setup Script
# 
# Configures MCP2515 SPI CAN interface on Raspberry Pi 5
# Run as: sudo ./setup_socketcan.sh
###############################################################################

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Setting up SocketCAN interface...${NC}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Error: Please run as root (sudo)${NC}"
    exit 1
fi

# Configuration
CAN_INTERFACE="can0"
CAN_BITRATE="500000"  # Standard OBD-II bitrate (500 kbps)
SPI_OSCILLATOR="8000000"  # 8 MHz (common for MCP2515 modules)
INT_GPIO="23"  # GPIO 23 for interrupt pin

echo -e "${YELLOW}Configuration:${NC}"
echo "  Interface: $CAN_INTERFACE"
echo "  Bitrate: $CAN_BITRATE bps"
echo "  SPI Oscillator: $SPI_OSCILLATOR Hz"
echo "  Interrupt GPIO: $INT_GPIO"
echo ""

# Load kernel modules
echo -e "${GREEN}Loading kernel modules...${NC}"
modprobe can || true
modprobe can_raw || true
modprobe can_dev || true
modprobe mcp251x || true

# Make modules load on boot
if ! grep -q "can" /etc/modules; then
    echo "can" >> /etc/modules
    echo "can_raw" >> /etc/modules
    echo "can_dev" >> /etc/modules
fi

# Configure device tree overlay in /boot/firmware/config.txt
CONFIG_FILE="/boot/firmware/config.txt"

if [ -f "$CONFIG_FILE" ]; then
    echo -e "${GREEN}Configuring device tree overlay...${NC}"
    
    # Backup config
    cp "$CONFIG_FILE" "$CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Enable SPI if not already enabled
    if ! grep -q "^dtparam=spi=on" "$CONFIG_FILE"; then
        echo "dtparam=spi=on" >> "$CONFIG_FILE"
        echo -e "${YELLOW}Enabled SPI${NC}"
    fi
    
    # Add MCP2515 overlay if not present
    if ! grep -q "dtoverlay=mcp2515-can0" "$CONFIG_FILE"; then
        echo "dtoverlay=mcp2515-can0,oscillator=$SPI_OSCILLATOR,interrupt=$INT_GPIO" >> "$CONFIG_FILE"
        echo -e "${YELLOW}Added MCP2515 device tree overlay${NC}"
    fi
else
    echo -e "${RED}Warning: $CONFIG_FILE not found${NC}"
fi

# Bring up CAN interface
echo -e "${GREEN}Bringing up CAN interface...${NC}"

# First, bring down if already up
ip link set $CAN_INTERFACE down 2>/dev/null || true

# Configure and bring up
if ip link show $CAN_INTERFACE &>/dev/null; then
    ip link set $CAN_INTERFACE type can bitrate $CAN_BITRATE
    ip link set $CAN_INTERFACE up
    
    echo -e "${GREEN}CAN interface $CAN_INTERFACE is UP${NC}"
    
    # Show interface details
    ip -details link show $CAN_INTERFACE
else
    echo -e "${YELLOW}CAN interface not detected yet (requires reboot)${NC}"
fi

# Create systemd network configuration for CAN
SYSTEMD_NETWORK="/etc/systemd/network/80-can.network"

echo -e "${GREEN}Creating systemd network configuration...${NC}"
cat > "$SYSTEMD_NETWORK" << EOF
[Match]
Name=can*

[CAN]
BitRate=$CAN_BITRATE
RestartSec=100ms
EOF

echo -e "${GREEN}Created $SYSTEMD_NETWORK${NC}"

# Test CAN interface (if already up)
if ip link show $CAN_INTERFACE | grep -q "UP"; then
    echo ""
    echo -e "${GREEN}Testing CAN interface...${NC}"
    
    # Send a test frame (OBD query for VIN)
    echo -e "${YELLOW}Sending test OBD-II query...${NC}"
    cansend $CAN_INTERFACE 7DF#0201050000000000 || true
    
    # Listen for 2 seconds
    echo -e "${YELLOW}Listening for responses (2 seconds)...${NC}"
    timeout 2 candump $CAN_INTERFACE || true
    
    echo ""
    echo -e "${YELLOW}If you see CAN frames above, your CAN interface is working!${NC}"
else
    echo -e "${YELLOW}CAN interface not up yet. Reboot required.${NC}"
fi

# Create useful aliases
echo -e "${GREEN}Creating CAN utility aliases...${NC}"
cat >> /etc/bash.bashrc << 'EOF'

# PiDriveSmartOS CAN Aliases
alias can-up='sudo ip link set can0 up type can bitrate 500000'
alias can-down='sudo ip link set can0 down'
alias can-listen='candump can0'
alias can-stats='ip -s -d link show can0'
EOF

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   SocketCAN Setup Complete!                   ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Reboot to load device tree overlay: sudo reboot"
echo "  2. After reboot, check interface: ip link show can0"
echo "  3. Test with: candump can0"
echo "  4. Install OBD service: sudo systemctl enable obdsvc.service"
echo ""
echo -e "${YELLOW}Useful commands:${NC}"
echo "  can-up      - Bring up CAN interface"
echo "  can-down    - Bring down CAN interface"
echo "  can-listen  - Monitor CAN traffic"
echo "  can-stats   - Show CAN statistics"

