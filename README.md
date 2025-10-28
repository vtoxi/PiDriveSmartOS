# 🚗 PiDriveSmartOS

> A next-generation automotive infotainment and telemetry system powered by Raspberry Pi 5

![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-Raspberry%20Pi%205-red.svg)
![Qt Version](https://img.shields.io/badge/Qt-6.5+-green.svg)
![Linux](https://img.shields.io/badge/OS-Linux%2064--bit-orange.svg)

PiDriveSmartOS transforms your Raspberry Pi 5 into a complete automotive operating system, delivering OEM-quality infotainment, real-time vehicle diagnostics, and extensible developer tools—all in a driver-safe, touch-optimized interface.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Hardware Requirements](#hardware-requirements)
- [Quick Start](#quick-start)
- [System Modes](#system-modes)
- [Architecture](#architecture)
- [Documentation](#documentation)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

PiDriveSmartOS is a Linux-based automotive platform designed for:

- **In-car dashboard/head unit** with modern touchscreen UI
- **Vehicle diagnostics** via OBD-II/CAN bus integration
- **HUD (Head-Up Display)** rendering for critical driving data
- **Media and navigation** with web-based services
- **Developer platform** with secure developer mode toggle
- **Modular architecture** for custom automotive applications

Built on Raspberry Pi 5's powerful ARM Cortex-A76 processor and 8GB RAM, PiDriveSmartOS delivers responsive performance with sub-10-second boot times.

---

## ✨ Key Features

### 🖥️ **Dual Operating Modes**
- **Car Mode**: Full-screen kiosk automotive UI (production/daily use)
- **Developer Mode**: Full Linux desktop with SSH, debugging tools, and development environment

### 🚘 **Vehicle Integration**
- Real-time OBD-II data acquisition via SocketCAN
- CAN bus monitoring and diagnostics
- Speed, RPM, fuel level, engine temperature display
- DTC (Diagnostic Trouble Code) reading and clearing
- Configurable gauge displays and alerts

### 🎨 **Modern Automotive UI**
- Qt 6/QML-based touch interface
- Day/night themes with automatic switching
- Animated transitions and smooth scrolling
- Large, driver-safe controls (minimum 44x44px touch targets)
- Customizable dashboard widgets

### 📡 **Connectivity**
- Wi-Fi and Bluetooth 5.0
- Optional LTE modem support
- GPS positioning (NMEA 0183)
- Android Auto/Apple CarPlay integration (roadmap)
- OTA (Over-The-Air) firmware updates

### 🎵 **Media & Navigation**
- Embedded Chromium/Qt WebEngine
- Spotify, YouTube, streaming services
- Online maps integration
- Voice command support (roadmap)
- Backup camera display

### 🔒 **Security**
- Secure boot with developer mode toggle
- Read-only root filesystem (overlayfs)
- Isolated CAN bus interface
- Encrypted OTA updates
- User privilege separation

### 🔧 **Developer Features**
- WebSocket/DBus API for custom apps
- Plugin architecture for extensions
- Python and C++ SDK
- Real-time telemetry logging
- Remote debugging support

---

## 🛠️ Hardware Requirements

### Minimum Configuration

| Component | Specification |
|-----------|---------------|
| **SBC** | Raspberry Pi 5 (8GB recommended, 4GB minimum) |
| **Display** | 7"–10" touchscreen LCD (HDMI or DSI) |
| **Power** | USB-C PD automotive power adapter (12V→5V, 5A) |
| **Storage** | 32GB+ microSD (Class 10/A2) or NVMe SSD |
| **CAN Interface** | MCP2515 SPI CAN module or Waveshare CAN HAT |
| **GPS** | USB GPS dongle (u-blox recommended) |
| **Connectivity** | Built-in Wi-Fi/BT (Pi 5 onboard) |

### Optional Components

- **Secondary Display**: HDMI HUD projector or 3.5" TFT
- **Cameras**: USB webcams for front/rear view
- **Microphone**: USB or I2S array for voice commands
- **LTE Module**: 4G USB dongle or HAT for mobile data
- **Accelerometer/Gyroscope**: MPU6050 for ADAS features
- **Cooling**: Active fan or heatsink case for high-temp environments

### Recommended Hardware Kits

See [docs/hardware.md](docs/hardware.md) for detailed wiring diagrams, pinouts, and tested component lists.

---

## 🚀 Quick Start

### 1. Flash the OS Image

```bash
# Download the latest PiDriveSmartOS image
wget https://github.com/yourorg/pidrivesmartos/releases/latest/pidriveos.img.xz

# Flash to microSD (Linux/macOS)
xzcat pidriveos.img.xz | sudo dd of=/dev/sdX bs=4M status=progress

# Or use Raspberry Pi Imager (recommended)
```

### 2. Initial Boot

1. Insert the microSD card into your Raspberry Pi 5
2. Connect your touchscreen display via HDMI/DSI
3. Power on the system (automotive 12V or USB-C PD)
4. System boots into **Car Mode** by default (~8 seconds)

### 3. Configure Wi-Fi & System

- Tap **Settings** → **Network** on the touchscreen
- Connect to your Wi-Fi network
- Set timezone, units (metric/imperial), and vehicle profile

### 4. Connect OBD-II Interface

```bash
# In Developer Mode (see below), configure CAN interface
sudo ./scripts/setup_socketcan.sh

# Test CAN connection
candump can0
```

### 5. Toggle Developer Mode

```bash
# From Car Mode: Hold "Settings" for 10 seconds → Enter PIN → Enable Developer Mode
# From terminal: Edit /boot/firmware/devmode.cfg

echo "car_mode=0" | sudo tee /boot/firmware/devmode.cfg
sudo reboot
```

**First-time PIN**: `1234` (change immediately in Settings → Security)

---

## 🔀 System Modes

### 🚗 Car Mode (Production)

- **Purpose**: Daily driving interface
- **UI**: Full-screen Qt CarUI application
- **Access**: Touch-only, no keyboard/mouse
- **Services**: OBD monitoring, media, navigation
- **Security**: Read-only root, SSH disabled
- **Boot time**: ~8 seconds

**Screens**: Home Dashboard, Navigation, Media, Vehicle Diagnostics, Settings

### 🛠️ Developer Mode

- **Purpose**: Development, debugging, system updates
- **UI**: Full LXDE/Wayfire desktop
- **Access**: SSH enabled (port 22), VNC optional
- **Services**: All system logs, terminals, debuggers
- **Security**: Read-write filesystem, sudo access
- **Boot time**: ~15 seconds

**Access**: Terminal, Qt Creator, code editors, log viewers

**Toggle Methods**:
1. UI gesture (hold Settings for 10s + PIN)
2. Config file: `/boot/firmware/devmode.cfg`
3. GPIO switch (GPIO 17 + ground)

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      PiDriveSmartOS                         │
├─────────────────────────────────────────────────────────────┤
│  UI Layer (Qt 6.5 QML)                                      │
│  ┌──────────┬──────────┬──────────┬──────────┬──────────┐  │
│  │Dashboard │Navigation│  Media   │ Vehicle  │ Settings │  │
│  │  Widget  │  Maps    │ Player   │   Info   │  Panel   │  │
│  └──────────┴──────────┴──────────┴──────────┴──────────┘  │
├─────────────────────────────────────────────────────────────┤
│  Service Layer (Python/C++ Daemons)                         │
│  ┌──────────┬──────────┬──────────┬──────────┬──────────┐  │
│  │   OBD    │   GPS    │  Media   │   HUD    │  Update  │  │
│  │ Service  │ Service  │ Service  │ Renderer │ Service  │  │
│  └──────────┴──────────┴──────────┴──────────┴──────────┘  │
├─────────────────────────────────────────────────────────────┤
│  Communication Bus (DBus / WebSocket)                       │
├─────────────────────────────────────────────────────────────┤
│  Hardware Abstraction Layer                                 │
│  ┌──────────┬──────────┬──────────┬──────────┬──────────┐  │
│  │SocketCAN │  NMEA    │ V4L2     │ ALSA     │  GPIO    │  │
│  │(OBD/CAN) │  (GPS)   │(Cameras) │ (Audio)  │ (I/O)    │  │
│  └──────────┴──────────┴──────────┴──────────┴──────────┘  │
├─────────────────────────────────────────────────────────────┤
│  Linux Kernel (Raspberry Pi OS 64-bit / 6.6.x)             │
└─────────────────────────────────────────────────────────────┘
        │                │              │              │
    [OBD-II]          [GPS]       [Touchscreen]    [Network]
```

**Data Flow**: Vehicle CAN → SocketCAN → OBD Service → DBus → Qt UI → Display

See [docs/architecture.md](docs/architecture.md) for detailed system design.

---

## 📚 Documentation

Comprehensive technical documentation is available in the `/docs` directory:

| Document | Description |
|----------|-------------|
| [architecture.md](docs/architecture.md) | System architecture, boot sequence, data flow |
| [hardware.md](docs/hardware.md) | Raspberry Pi 5 wiring, CAN interface, power design |
| [software-stack.md](docs/software-stack.md) | OS choice, Qt stack, package dependencies |
| [security.md](docs/security.md) | Developer mode security, CAN safety, OTA signing |
| [roadmap.md](docs/roadmap.md) | Development phases and future features |
| [features.md](docs/features.md) | Detailed feature list and optional modules |
| [ui-design.md](docs/ui-design.md) | UX philosophy, screen layouts, theming |

---

## 💻 Development

### Building from Source

```bash
# Clone the repository
git clone https://github.com/yourorg/pidrivesmartos.git
cd pidrivesmartos

# Install dependencies (on Raspberry Pi or cross-compile environment)
./scripts/install_dependencies.sh

# Build Qt CarUI application
cd src/carui
mkdir build && cd build
qmake6 .. && make -j4

# Build OBD service
cd ../../obd_service
python -m pip install -r requirements.txt
```

### Running in Development

```bash
# Start OBD service (requires CAN interface)
sudo python src/obd_service/obd_daemon.py &

# Launch CarUI in window mode (not fullscreen)
./src/carui/build/carui --windowed

# Monitor logs
tail -f /var/log/pidriveos/system.log
```

### Cross-Compilation (x86_64 → ARM64)

```bash
# Install Qt for cross-compilation
sudo apt install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

# Use the provided cross-compile toolchain
./scripts/setup_cross_compile.sh

# Build with qmake
qmake6 -spec linux-aarch64-gnu-g++ CONFIG+=release
make -j$(nproc)
```

See [docs/software-stack.md](docs/software-stack.md) for detailed build instructions.

---

## 🧪 Testing

```bash
# Run unit tests
cd src/carui
qmake6 CONFIG+=test && make check

# Test CAN interface (loopback)
sudo ip link add dev vcan0 type vcan
sudo ip link set up vcan0
cansend vcan0 123#DEADBEEF

# Simulate OBD data
python scripts/simulate_obd.py
```

---

## 🤝 Contributing

We welcome contributions! Please see our [CONTRIBUTING.md](CONTRIBUTING.md) guide.

**Areas of Focus**:
- Qt/QML UI improvements
- OBD-II protocol support expansion
- Hardware driver development
- Documentation and tutorials
- Localization (i18n)

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 🗺️ Roadmap

- [x] **Phase 1**: Core OS with basic UI (v0.1)
- [x] **Phase 2**: OBD-II integration and diagnostics (v0.2)
- [ ] **Phase 3**: Android Auto/Apple CarPlay (v0.3) - In Progress
- [ ] **Phase 4**: Voice assistant integration (v0.4)
- [ ] **Phase 5**: ADAS (lane detection, collision warning) (v0.5)
- [ ] **Phase 6**: Mobile companion app with cloud sync (v0.6)

See [docs/roadmap.md](docs/roadmap.md) for detailed timeline.

---

## 📸 Screenshots

> *Coming soon: Dashboard, navigation, diagnostics screens*

---

## 🙏 Acknowledgments

- **Qt Project** - UI framework
- **SocketCAN** - Linux CAN bus support
- **python-can** - OBD-II library
- **Raspberry Pi Foundation** - Hardware platform
- **Automotive communities** - OBD protocol documentation

---

## ⚖️ License

This project is licensed under the **Apache License 2.0** - see [LICENSE](LICENSE) for details.

```
Copyright 2025 PiDriveSmartOS Contributors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
```

---

## 📞 Contact & Support

- **Issues**: [GitHub Issues](https://github.com/yourorg/pidrivesmartos/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourorg/pidrivesmartos/discussions)
- **Discord**: [Join our community](https://discord.gg/pidriveos)
- **Email**: support@pidriveos.org

---

## ⚠️ Disclaimer

**Safety Notice**: This system is intended for testing and development purposes. Always prioritize road safety and comply with local traffic laws. Do not interact with the touchscreen while driving. The developers are not responsible for any accidents or damages resulting from the use of this system.

---

**Built with ❤️ by the PiDriveSmartOS community**

