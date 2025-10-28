# Software Stack

> Complete software architecture, dependencies, and build instructions for PiDriveSmartOS

---

## Table of Contents

- [Overview](#overview)
- [Operating System](#operating-system)
- [Core Technologies](#core-technologies)
- [Package Dependencies](#package-dependencies)
- [Qt Framework](#qt-framework)
- [Development Environment](#development-environment)
- [Build Instructions](#build-instructions)
- [Cross-Compilation](#cross-compilation)
- [Creating Custom Images](#creating-custom-images)

---

## Overview

PiDriveSmartOS is built on a modern Linux stack optimized for automotive embedded systems:

```
┌─────────────────────────────────────────────────┐
│  Application Layer                              │
│  • Qt 6.5+ QML UI                              │
│  • Python 3.11+ services                        │
│  • Web technologies (Chromium)                  │
├─────────────────────────────────────────────────┤
│  Framework Layer                                │
│  • Qt Core, Quick, Multimedia, WebEngine       │
│  • DBus (system/session bus)                   │
│  • GStreamer (media pipeline)                   │
├─────────────────────────────────────────────────┤
│  System Services                                │
│  • systemd (init, services, timers)            │
│  • gpsd (GPS daemon)                            │
│  • can-utils (SocketCAN tools)                 │
├─────────────────────────────────────────────────┤
│  Operating System                               │
│  • Raspberry Pi OS 64-bit (Bookworm)           │
│  • Linux Kernel 6.6.x                          │
│  • Debian package management                    │
└─────────────────────────────────────────────────┘
```

---

## Operating System

### Base OS Selection

**Chosen**: **Raspberry Pi OS 64-bit (Debian Bookworm)**

#### Rationale

| Criteria | Raspberry Pi OS | Ubuntu Core | Yocto/Buildroot |
|----------|-----------------|-------------|-----------------|
| Hardware support | ✅ Excellent | ⚠️ Good | ⚠️ Manual |
| Package availability | ✅ apt (vast) | ⚠️ snap (limited) | ❌ Manual builds |
| Maintenance | ✅ Official | ✅ Canonical | ⚠️ DIY |
| Boot time | ✅ Fast (<10s) | ⚠️ Moderate | ✅ Fastest |
| Qt 6 support | ✅ Native | ✅ Via PPA | ⚠️ Custom build |
| Community docs | ✅ Extensive | ✅ Good | ⚠️ Limited |
| **Verdict** | **✅ Best choice** | Acceptable | For experts only |

**Alternative Options**:
- **Ubuntu 24.04 LTS ARM64**: If you prefer snap packages
- **DietPi**: Minimal Debian-based (faster boot)
- **Custom Yocto**: For production hardening (advanced)

### Kernel Configuration

**Version**: Linux 6.6.x (Raspberry Pi kernel fork)

**Key Kernel Features Required**:
- `CONFIG_CAN=m` (CAN bus support)
- `CONFIG_CAN_RAW=m` (SocketCAN)
- `CONFIG_CAN_MCP251X=m` (MCP2515 driver)
- `CONFIG_USB_SERIAL=m` (USB GPS)
- `CONFIG_OVERLAY_FS=y` (Read-only root with overlayfs)
- `CONFIG_PREEMPT=y` (Better latency for real-time apps)

**Optional (for ADAS)**:
- `CONFIG_VIDEO_V4L2=m` (Camera support)
- `CONFIG_DRM=y` (GPU acceleration)

---

## Core Technologies

### Qt Framework

**Version**: Qt 6.5.3 or later (Long-Term Support)

**Modules Used**:
- **Qt Core**: Base classes, event loop
- **Qt Quick**: QML engine, UI rendering
- **Qt Quick Controls 2**: Touch-optimized UI widgets
- **Qt Multimedia**: Audio/video playback
- **Qt WebEngine**: Embedded Chromium browser
- **Qt Positioning**: GPS/location services
- **Qt DBus**: Inter-process communication
- **Qt Sensors**: Accelerometer (optional)

**Why Qt 6?**
1. **Performance**: Vulkan/Metal rendering backend
2. **Touch-first**: Designed for mobile/embedded
3. **QML**: Declarative UI (fast iteration)
4. **Cross-platform**: Develop on desktop, deploy to Pi
5. **Licensing**: LGPL (commercial-friendly)

### Python Services

**Version**: Python 3.11+

**Key Libraries**:
- **python-can**: CAN bus interface (SocketCAN backend)
- **python-obd**: OBD-II protocol library
- **dbus-python**: DBus bindings
- **pyserial**: Serial GPS (if not using gpsd)
- **asyncio**: Async I/O for services
- **pydantic**: Configuration validation

### Media Stack

**GStreamer 1.22+**:
- **Audio codecs**: MP3, AAC, FLAC, Opus
- **Video codecs**: H.264, VP9, AV1 (hardware decode)
- **Streaming**: RTSP, HTTP, HLS

**ALSA**: Low-level audio interface

**PipeWire** (optional): Modern audio routing

### Networking

- **systemd-networkd**: Network configuration
- **wpa_supplicant**: Wi-Fi management
- **NetworkManager** (alternative): Easier configuration
- **gpsd**: GPS daemon (NMEA parser)

### Boot and Init

- **systemd**: Service manager
  - Targets: `multi-user.target` (Car Mode), `graphical.target` (Dev Mode)
  - Services: One-shot, simple, forking
  - Timers: Scheduled tasks (e.g., OTA checks)

---

## Package Dependencies

### Installation Commands

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Qt 6 (from Debian repos)
sudo apt install -y \
    qt6-base-dev \
    qt6-declarative-dev \
    qt6-multimedia-dev \
    qt6-webengine-dev \
    qt6-positioning-dev \
    qml6-module-qtquick \
    qml6-module-qtquick-controls \
    qml6-module-qtmultimedia \
    qml6-module-qtpositioning \
    libqt6dbus6

# Install CAN tools
sudo apt install -y \
    can-utils \
    libsocketcan-dev

# Install GPS daemon
sudo apt install -y \
    gpsd \
    gpsd-clients \
    python3-gps

# Install Python dependencies
sudo apt install -y \
    python3-pip \
    python3-dev \
    python3-dbus \
    python3-gi

# Install multimedia
sudo apt install -y \
    gstreamer1.0-tools \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav

# Install development tools
sudo apt install -y \
    git \
    cmake \
    build-essential \
    qtcreator \
    gdb \
    valgrind
```

### Python Packages

Create `requirements.txt`:

```txt
# Core dependencies
python-can==4.3.1
python-obd==0.7.1
dbus-python==1.3.2
pygobject==3.46.0
pyserial==3.5

# Async and utilities
asyncio==3.4.3
pydantic==2.5.0
pyyaml==6.0.1
toml==0.10.2

# Optional
paho-mqtt==1.6.1  # For MQTT telemetry
requests==2.31.0   # For OTA updates
pillow==10.1.0     # Image processing
```

Install:

```bash
pip3 install -r requirements.txt
```

---

## Qt Framework

### Installation Methods

#### Method 1: Debian Packages (Recommended)

```bash
sudo apt install qt6-base-dev qt6-declarative-dev
```

✅ **Pros**: Easy, maintained
❌ **Cons**: May be slightly outdated (Qt 6.4 in Bookworm)

#### Method 2: Qt Online Installer

```bash
# Download installer
wget https://download.qt.io/official_releases/online_installers/qt-unified-linux-arm64-online.run
chmod +x qt-unified-linux-arm64-online.run
./qt-unified-linux-arm64-online.run
```

✅ **Pros**: Latest version (6.7+)
❌ **Cons**: Requires Qt account, larger install

#### Method 3: Build from Source

```bash
git clone https://code.qt.io/qt/qt5.git
cd qt5
git checkout v6.5.3
./configure -prefix /opt/qt6 -release -opensource -confirm-license
cmake --build . --parallel 4
sudo cmake --install .
```

✅ **Pros**: Full control, optimizations
❌ **Cons**: 6+ hours compile time on Pi 5

### Qt Configuration for Embedded

**Qt environment variables** (`/etc/environment`):

```bash
# Use EGL instead of GLX (for embedded)
QT_QPA_PLATFORM=eglfs

# Touchscreen input
QT_QPA_EGLFS_INTEGRATION=eglfs_kms
QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS=/dev/input/event0

# Font rendering
QT_QPA_FONTDIR=/usr/share/fonts/truetype

# Disable mouse cursor
QT_QPA_EGLFS_HIDECURSOR=1

# GPU acceleration
QT_QPA_EGLFS_KMS_CONFIG=/etc/pidrive/kms.json
```

**kms.json** (display configuration):

```json
{
  "device": "/dev/dri/card1",
  "outputs": [
    {
      "name": "HDMI1",
      "mode": "1024x600",
      "format": "rgb565",
      "physicalWidth": 155,
      "physicalHeight": 86
    }
  ]
}
```

---

## Development Environment

### On-Device Development (Developer Mode)

```bash
# Install Qt Creator
sudo apt install qtcreator

# Install code editors
sudo apt install vim neovim nano

# Install debugging tools
sudo apt install gdb valgrind strace

# Enable SSH (Developer Mode only)
sudo systemctl enable ssh
sudo systemctl start ssh
```

### Remote Development (Cross-Compile)

**Host**: x86_64 Linux (Ubuntu 22.04+)
**Target**: Raspberry Pi 5 (ARM64)

#### Install Cross-Compiler

```bash
# On x86_64 host
sudo apt install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

# Verify
aarch64-linux-gnu-gcc --version
```

#### Qt Creator Configuration

1. **Tools → Options → Kits**
2. **Add Kit**: "Raspberry Pi 5 ARM64"
   - **Device**: SSH connection to Pi
   - **Compiler**: aarch64-linux-gnu-g++
   - **Qt Version**: Qt 6.5 (aarch64 build)
   - **CMake**: Use host cmake

### VS Code Remote Development

```bash
# Install Remote-SSH extension
# Connect to pi@raspberrypi.local

# Install C++/Qt extensions on Pi
code --install-extension ms-vscode.cpptools
code --install-extension tonka3000.qtvsctools
```

---

## Build Instructions

### Building CarUI (Qt Application)

```bash
# Clone repository
git clone https://github.com/vtoxi/pidrivesmartos.git
cd pidrivesmartos/src/carui

# Create build directory
mkdir build && cd build

# Configure with qmake
qmake6 .. CONFIG+=release

# Build (use all cores)
make -j$(nproc)

# Run
./carui
```

**Build flags**:
- `CONFIG+=debug`: Debug symbols
- `CONFIG+=qml_debug`: QML profiler
- `DEFINES+=NO_WEBENGINE`: Disable WebEngine (saves RAM)

### Building OBD Service

```bash
cd src/obd_service

# Install dependencies
pip3 install -r requirements.txt

# Run directly (for testing)
python3 obd_daemon.py

# Install as system service
sudo cp obd_daemon.py /opt/pidrive/bin/
sudo cp ../systemd/obdsvc.service /etc/systemd/system/
sudo systemctl enable obdsvc
sudo systemctl start obdsvc
```

### Build System: CMake (Alternative)

If you prefer CMake over qmake:

```cmake
# CMakeLists.txt
cmake_minimum_required(VERSION 3.16)
project(CarUI VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Multimedia DBus)

add_executable(carui
    main.cpp
    vehicledata.cpp
    vehicledata.h
    qml.qrc
)

target_link_libraries(carui
    Qt6::Core
    Qt6::Quick
    Qt6::Multimedia
    Qt6::DBus
)

install(TARGETS carui DESTINATION /opt/pidrive/bin)
```

Build:

```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
sudo cmake --install build
```

---

## Cross-Compilation

### Setup Cross-Compile Toolchain

```bash
# On x86_64 host
mkdir -p ~/pi-cross
cd ~/pi-cross

# Download Raspberry Pi toolchain
git clone https://github.com/raspberrypi/tools.git

# Add to PATH
export PATH=$PATH:~/pi-cross/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin

# Download sysroot (Pi filesystem)
rsync -avz pi@raspberrypi.local:/lib ~/pi-cross/sysroot/
rsync -avz pi@raspberrypi.local:/usr ~/pi-cross/sysroot/
```

### Cross-Compile Qt Application

```bash
# Configure qmake for cross-compilation
qmake6 -spec linux-aarch64-gnu-g++ \
    QMAKE_CC=aarch64-linux-gnu-gcc \
    QMAKE_CXX=aarch64-linux-gnu-g++ \
    ..

# Build
make -j$(nproc)

# Transfer to Pi
scp carui pi@raspberrypi.local:/opt/pidrive/bin/
```

### Docker Cross-Compile Environment

```dockerfile
# Dockerfile.cross
FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    qt6-base-dev:arm64 \
    cmake \
    git

WORKDIR /build
COPY . .

RUN cmake -B build -DCMAKE_TOOLCHAIN_FILE=toolchain-aarch64.cmake
RUN cmake --build build

CMD ["bash"]
```

Build:

```bash
docker build -f Dockerfile.cross -t pidrive-cross .
docker run -v $(pwd):/build pidrive-cross
```

---

## Creating Custom Images

### Method 1: pi-gen (Raspberry Pi Image Generator)

```bash
# Clone pi-gen
git clone https://github.com/RPi-Distro/pi-gen.git
cd pi-gen

# Create custom stage
mkdir -p stage-pidrive/00-install-pidrive
cd stage-pidrive/00-install-pidrive

# Create install script
cat > 00-run.sh << 'EOF'
#!/bin/bash -e
# Install PiDriveSmartOS packages
apt-get install -y qt6-base-dev can-utils gpsd
pip3 install python-can python-obd

# Copy application files
cp -r /build/opt/pidrive /opt/

# Enable services
systemctl enable carui.service obdsvc.service
EOF

# Build image
cd ../..
touch ./stage2/SKIP ./stage3/SKIP ./stage4/SKIP ./stage5/SKIP
RELEASE=bookworm ./build.sh
```

**Output**: `deploy/pidriveos-lite.img`

### Method 2: Manual Customization

```bash
# Start with base Raspberry Pi OS image
wget https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2024-07-04/2024-07-04-raspios-bookworm-arm64.img.xz
xzcat 2024-07-04-raspios-bookworm-arm64.img.xz > base.img

# Mount image
sudo losetup -fP base.img
sudo mount /dev/loop0p2 /mnt/pi

# Chroot and customize
sudo mount --bind /dev /mnt/pi/dev
sudo mount --bind /proc /mnt/pi/proc
sudo mount --bind /sys /mnt/pi/sys
sudo chroot /mnt/pi

# Install packages
apt update
apt install -y qt6-base-dev can-utils gpsd python3-pip
pip3 install python-can python-obd

# Copy files
cp -r /opt/pidrive /mnt/pi/opt/
cp systemd/*.service /mnt/pi/etc/systemd/system/

# Exit chroot
exit
sudo umount /mnt/pi/{dev,proc,sys,}

# Compress image
xz -9 -T0 base.img
mv base.img.xz pidriveos-v1.0.img.xz
```

### Method 3: Buildroot (Advanced)

For minimal, production-hardened images:

```bash
git clone https://github.com/buildroot/buildroot.git
cd buildroot

# Configure for Raspberry Pi 5
make raspberrypi5_64_defconfig

# Customize
make menuconfig
# Select: Qt6, SocketCAN, gpsd

# Build (takes 1-2 hours)
make -j$(nproc)

# Output: output/images/sdcard.img
```

---

## Version Matrix

### Tested Configurations

| Component | Version | Status |
|-----------|---------|--------|
| Raspberry Pi OS | Bookworm (2024-07) | ✅ Recommended |
| Linux Kernel | 6.6.31 | ✅ Stable |
| Qt | 6.5.3 | ✅ LTS |
| Python | 3.11.2 | ✅ Stable |
| GStreamer | 1.22.0 | ✅ Stable |
| systemd | 252 | ✅ Stable |
| gpsd | 3.25 | ✅ Stable |

### Compatibility Notes

- **Qt 6.7+**: Works but not LTS (use for testing only)
- **Python 3.12**: Compatible but not required
- **GStreamer 1.24**: Adds AV1 decode (optional)

---

## Performance Optimization

### Compile Flags

```bash
# Add to qmake CONFIG
QMAKE_CXXFLAGS += -O3 -march=armv8-a -mtune=cortex-a76
QMAKE_LFLAGS += -flto  # Link-time optimization
```

### GPU Acceleration

Ensure `/boot/firmware/config.txt`:

```bash
# Allocate GPU memory
gpu_mem=256

# Enable OpenGL ES 3.1
dtoverlay=vc4-kms-v3d
```

### Profiling

```bash
# CPU profiling
perf record -g ./carui
perf report

# QML profiler
QSG_RENDER_TIMING=1 ./carui

# Memory leaks
valgrind --leak-check=full ./carui
```

---

## Package Management

### Creating .deb Package

```bash
# Create package structure
mkdir -p pidriveos_1.0-1_arm64/DEBIAN
mkdir -p pidriveos_1.0-1_arm64/opt/pidrive/bin

# Copy files
cp build/carui pidriveos_1.0-1_arm64/opt/pidrive/bin/

# Create control file
cat > pidriveos_1.0-1_arm64/DEBIAN/control << EOF
Package: pidriveos
Version: 1.0-1
Architecture: arm64
Maintainer: Your Name <you@example.com>
Description: PiDriveSmartOS in-car system
Depends: qt6-base-dev, can-utils, gpsd
EOF

# Build package
dpkg-deb --build pidriveos_1.0-1_arm64
```

Install:

```bash
sudo dpkg -i pidriveos_1.0-1_arm64.deb
sudo apt-get install -f  # Fix dependencies
```

---

## Continuous Integration

### GitHub Actions Workflow

```yaml
# .github/workflows/build.yml
name: Build PiDriveSmartOS

on: [push, pull_request]

jobs:
  build-arm64:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Install cross-compiler
        run: |
          sudo apt-get update
          sudo apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
      
      - name: Build application
        run: |
          cd src/carui
          mkdir build && cd build
          cmake -DCMAKE_TOOLCHAIN_FILE=../toolchain-aarch64.cmake ..
          cmake --build .
      
      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: carui-arm64
          path: src/carui/build/carui
```

---

## Next Steps

- Review [architecture.md](architecture.md) for system design
- See [hardware.md](hardware.md) for Pi 5 wiring
- Check [security.md](security.md) for hardening
- Read [ui-design.md](ui-design.md) for UX guidelines

