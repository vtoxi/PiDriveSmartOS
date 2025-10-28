#!/bin/bash
###############################################################################
# PiDriveSmartOS - Dependency Installation Script
# 
# Installs all required packages for PiDriveSmartOS
# Run as: sudo ./install_dependencies.sh
###############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   PiDriveSmartOS Dependency Installer         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Error: Please run as root (sudo)${NC}"
    exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VERSION=$VERSION_ID
else
    echo -e "${RED}Cannot detect OS version${NC}"
    exit 1
fi

echo -e "${YELLOW}Detected OS: $OS $VERSION${NC}"
echo ""

# Update system
echo -e "${GREEN}[1/8] Updating package lists...${NC}"
apt update

echo -e "${GREEN}[2/8] Upgrading system packages...${NC}"
apt upgrade -y

# Install Qt 6
echo -e "${GREEN}[3/8] Installing Qt 6 framework...${NC}"
apt install -y \
    qt6-base-dev \
    qt6-declarative-dev \
    qt6-multimedia-dev \
    qt6-webengine-dev \
    qt6-positioning-dev \
    qml6-module-qtquick \
    qml6-module-qtquick-controls \
    qml6-module-qtquick-layouts \
    qml6-module-qtmultimedia \
    qml6-module-qtpositioning \
    qml6-module-qtwebengine \
    libqt6dbus6

# Install CAN tools
echo -e "${GREEN}[4/8] Installing CAN bus tools...${NC}"
apt install -y \
    can-utils \
    libsocketcan-dev \
    iproute2

# Install GPS daemon
echo -e "${GREEN}[5/8] Installing GPS daemon...${NC}"
apt install -y \
    gpsd \
    gpsd-clients \
    python3-gps

# Install Python and dependencies
echo -e "${GREEN}[6/8] Installing Python and libraries...${NC}"
apt install -y \
    python3 \
    python3-pip \
    python3-dev \
    python3-dbus \
    python3-gi \
    python3-gi-cairo \
    gir1.2-glib-2.0

pip3 install --upgrade pip
pip3 install python-can python-obd pydbus pygobject pyyaml

# Install multimedia
echo -e "${GREEN}[7/8] Installing multimedia support...${NC}"
apt install -y \
    gstreamer1.0-tools \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    gstreamer1.0-alsa \
    alsa-utils

# Install development tools
echo -e "${GREEN}[8/8] Installing development tools...${NC}"
apt install -y \
    git \
    cmake \
    build-essential \
    gdb \
    valgrind \
    vim \
    nano

# Optional: Install Qt Creator
read -p "Install Qt Creator IDE? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    apt install -y qtcreator
fi

# Create system users
echo -e "${GREEN}Creating system users...${NC}"

# Create pidrive user (main application user)
if ! id "pidrive" &>/dev/null; then
    useradd -r -m -s /bin/bash pidrive
    echo -e "${GREEN}Created user: pidrive${NC}"
fi

# Create obduser (OBD service user)
if ! id "obduser" &>/dev/null; then
    useradd -r -s /usr/sbin/nologin -d /var/lib/obd obduser
    echo -e "${GREEN}Created user: obduser${NC}"
fi

# Create CAN group
if ! getent group can &>/dev/null; then
    groupadd can
    echo -e "${GREEN}Created group: can${NC}"
fi

# Add users to groups
usermod -a -G video,audio,input,gpio,spi pidrive
usermod -a -G can obduser

# Create directories
echo -e "${GREEN}Creating application directories...${NC}"
mkdir -p /opt/pidrive/{bin,lib,share}
mkdir -p /etc/pidrive
mkdir -p /var/log/pidrive
mkdir -p /var/lib/pidrive

# Set permissions
chown -R pidrive:pidrive /opt/pidrive
chown -R pidrive:pidrive /var/lib/pidrive
chown -R pidrive:adm /var/log/pidrive
chmod 755 /opt/pidrive
chmod 750 /var/log/pidrive

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Installation Complete!                      ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Configure CAN interface: sudo ./setup_socketcan.sh"
echo "  2. Build CarUI application: cd src/carui && qmake6 && make"
echo "  3. Install services: sudo ./install_services.sh"
echo ""
echo -e "${YELLOW}Reboot recommended to apply all changes.${NC}"

