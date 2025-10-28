# 💻 Development Guide - PiDriveSmartOS

Complete developer setup, architecture, coding standards, and optimization strategies.

---

## 📋 **Table of Contents**

1. [Development Environment Setup](#setup)
2. [System Architecture](#architecture)
3. [Code Structure](#code-structure)
4. [Best Practices & Design Patterns](#best-practices)
5. [Memory Optimization](#memory-optimization)
6. [Building & Testing](#building)

---

## 🛠️ **Development Environment Setup** {#setup}

### **Prerequisites:**

```bash
# Ubuntu/Raspberry Pi OS
sudo apt update && sudo apt install -y \
    qt6-base-dev qt6-declarative-dev qt6-webengine-dev \
    cmake build-essential git \
    python3 python3-pip python3-dbus \
    can-utils libsocketcan-dev

# Install Python dependencies
pip3 install -r requirements.txt
```

### **Clone & Build:**

```bash
git clone https://github.com/yourusername/PiDriveSmartOS.git
cd PiDriveSmartOS

# Build UI
cd src/carui
mkdir build && cd build
cmake ..
make -j4

# Run windowed (development)
./carui --windowed

# Run fullscreen (production)
./carui
```

### **Quick Launch Scripts:**

```bash
# From project root
./run.sh           # Clean build + launch (windowed)
./quick-run.sh     # Launch without rebuild
```

---

## 🏗️ **System Architecture** {#architecture}

### **High-Level Overview:**

```
┌─────────────────────────────────────────────────────┐
│              Qt 6 QML User Interface               │
│  (Dashboard, Media, Phone, Vehicle, Settings, etc) │
└───────────────┬─────────────────────────────────────┘
                │ C++ Services Layer
                ├─► VehicleData (DBus/OBD-II)
                ├─► BluetoothService (HFP/A2DP/PBAP)
                ├─► MediaController (Playback)
                ├─► GPSService (Location)
                ├─► VoiceAssistant (Commands)
                ├─► WeatherService (Live data)
                ├─► NetworkManager (WiFi/LTE)
                ├─► AndroidAppManager (Waydroid)
                └─► ErrorHandler (Centralized errors)
                        │
        ┌───────────────┴───────────────┐
        │    Linux System Services      │
        ├─► DBus (IPC)                 │
        ├─► systemd (Service mgmt)     │
        ├─► SocketCAN (Vehicle comms)  │
        ├─► NetworkManager (Connectivity)│
        └─► Waydroid (Android container)│
        └───────────────────────────────┘
```

### **Boot Sequence:**

```
1. Raspberry Pi Power On
   ├─> systemd starts base services
   ├─> socketcan.service (CAN bus init)
   ├─> obdsvc.service (OBD-II daemon)
   ├─> carui.service (Main UI in kiosk mode)
   └─> Developer mode check (GPIO 17)
       ├─> LOW = Car Mode (kiosk, read-only root)
       └─> HIGH = Developer Mode (SSH, full OS access)
```

### **Data Flow (OBD-II Example):**

```
Vehicle CAN Bus
  ↓ (CAN-H/CAN-L)
MCP2515 SPI Module
  ↓ (SocketCAN: can0)
obd_daemon.py (Python)
  ├─> Reads PIDs (0x0C, 0x0D, 0x05, etc)
  ├─> Decodes values
  └─> Emits DBus signals
      ↓ (org.pidrive.vehicle)
VehicleData.cpp (Qt C++)
  ├─> Listens to DBus
  ├─> Exposes Q_PROPERTY to QML
  └─> Emits Qt signals
      ↓
Dashboard.qml
  └─> Updates gauges in real-time
```

---

## 📂 **Code Structure** {#code-structure}

```
PiDriveSmartOS/
├── src/
│   ├── carui/                 # Qt QML Application
│   │   ├── main.cpp           # Entry point, service initialization
│   │   ├── CMakeLists.txt     # Build configuration
│   │   ├── qml.qrc            # Resource file (embeds QML)
│   │   │
│   │   ├── *.h / *.cpp        # C++ Services
│   │   │   ├── vehicledata.{h,cpp}
│   │   │   ├── bluetoothservice.{h,cpp}
│   │   │   ├── mediacontroller.{h,cpp}
│   │   │   ├── gpsservice.{h,cpp}
│   │   │   ├── voiceassistant.{h,cpp}
│   │   │   ├── weatherservice.{h,cpp}
│   │   │   ├── networkmanager.{h,cpp}
│   │   │   ├── androidappmanager.{h,cpp}
│   │   │   └── errorhandler.{h,cpp}
│   │   │
│   │   └── qml/               # QML UI Files
│   │       ├── Theme.qml      # Singleton: Colors, fonts, spacing
│   │       ├── main.qml       # Root window, navigation
│   │       │
│   │       ├── *Page.qml      # Top-level pages
│   │       │   ├── DashboardPage.qml
│   │       │   ├── MediaPage.qml
│   │       │   ├── PhonePage.qml
│   │       │   ├── VehiclePage.qml
│   │       │   ├── NavigationPage.qml
│   │       │   ├── AppsPage.qml
│   │       │   ├── SettingsPage.qml
│   │       │   └── ConnectivityPage.qml
│   │       │
│   │       └── Components/    # Reusable components
│   │           ├── AppButton.qml
│   │           ├── AppCard.qml
│   │           ├── CircularGauge.qml
│   │           ├── LinearGauge.qml
│   │           ├── StatusIndicator.qml
│   │           ├── NavButton.qml
│   │           ├── NotificationToast.qml
│   │           ├── ScrollablePage.qml
│   │           ├── PageLoader.qml
│   │           ├── WebPlayer.qml
│   │           ├── WiFiPasswordDialog.qml
│   │           └── BluetoothPairingDialog.qml
│   │
│   ├── obd_service/           # OBD-II Python Daemon
│   │   └── obd_daemon.py      # SocketCAN → DBus bridge
│   │
│   ├── systemd/               # Service files
│   │   ├── carui.service
│   │   ├── obdsvc.service
│   │   └── socketcan.service
│   │
│   └── utils/                 # Helper scripts
│
├── scripts/                   # Build & setup scripts
│   ├── run_carui.sh           # Primary launch script
│   ├── install_dependencies.sh
│   ├── setup_socketcan.sh
│   └── toggle_dev_mode.sh
│
├── config/                    # Configuration files
│   ├── devmode.cfg
│   ├── carui.conf
│   └── obd.conf
│
├── docs/                      # Documentation
│   ├── INDEX.md              # ← Start here
│   ├── HARDWARE.md
│   ├── DEVELOPMENT.md        # ← You are here
│   ├── FEATURES.md
│   ├── DEPLOYMENT.md
│   ├── DESIGN.md
│   └── roadmap.md
│
├── run.sh                     # Quick launch (root)
├── quick-run.sh
├── README.md
└── LICENSE
```

---

## ⚡ **Best Practices & Design Patterns** {#best-practices}

### **SOLID Principles:**

1. **Single Responsibility**: Each C++ service handles ONE domain (e.g., `BluetoothService` only manages BT)
2. **Open/Closed**: Extend via inheritance/composition, not modification
3. **Liskov Substitution**: All services implement common interfaces
4. **Interface Segregation**: Lean interfaces (no bloated base classes)
5. **Dependency Inversion**: Depend on abstractions (Q_PROPERTY, signals), not concrete types

### **Clean Architecture Layers:**

```
┌──────────────────────────────────────┐
│  UI Layer (QML)                     │  ← Presentation
├──────────────────────────────────────┤
│  Presentation Logic (C++ Services)  │  ← Business logic
├──────────────────────────────────────┤
│  Data Layer (DBus, Files, Network)  │  ← Infrastructure
├──────────────────────────────────────┤
│  Hardware (CAN, GPIO, Bluetooth)    │  ← Devices
└──────────────────────────────────────┘
```

### **QML Component Design (Atomic):**

- **Atoms**: `AppButton`, `StatusIndicator` (smallest units)
- **Molecules**: `CircularGauge`, `LinearGauge` (atoms + logic)
- **Organisms**: `VehicleInfoCard`, `MediaControls` (complex groups)
- **Templates**: `ScrollablePage`, `PageLoader` (layout structure)
- **Pages**: `DashboardPage`, `MediaPage` (final screens)

### **State Management (Redux Pattern):**

```qml
// Centralized state in main.qml
property var appState: ({
    theme: "day",
    currentPage: "Dashboard",
    notifications: [],
    connectivity: { wifi: false, bluetooth: false, lte: false }
})

// Actions dispatch state changes
function setTheme(mode) {
    appState.theme = mode;
    // Trigger side effects
}
```

---

## 🚀 **Memory Optimization** {#memory-optimization}

### **Critical for Raspberry Pi 5 (8GB RAM, but UI should use <500MB):**

#### **1. Lazy Loading (PageLoader.qml)**

```qml
// ❌ BAD: All pages in memory
Component { id: dashboardPage; DashboardPage {} }
Component { id: mediaPage; MediaPage {} }
stackView.push(dashboardPage)

// ✅ GOOD: Load on-demand
function loadPage(pageName) {
    var loader = Qt.createComponent("qrc:/qml/" + pageName + ".qml");
    stackView.replace(loader.createObject());
}
```

**Memory Impact:**
- Before: ~350MB (all pages loaded)
- After: ~180MB (one page at a time)

#### **2. Explicit Destruction**

```qml
// PageLoader.qml
Loader {
    onLoaded: {
        // Page is active
    }
    onUnloaded: {
        if (item) {
            item.destroy(); // Force GC
        }
    }
}
```

#### **3. Image Optimization**

```qml
Image {
    source: "image.png"
    asynchronous: true          // Load in background
    cache: false                // Don't cache large images
    sourceSize.width: width     // Downscale on load
    sourceSize.height: height
}
```

#### **4. List View Optimization**

```qml
ListView {
    model: 1000  // Large dataset
    delegate: ItemDelegate {
        width: ListView.view.width
        height: 60
    }
    cacheBuffer: 200            // Cache 200px offscreen
    reuseItems: true            // Qt 5.15+ reuse delegates
}
```

### **Memory Budget:**

| Component | Budget | Notes |
|-----------|--------|-------|
| Qt Runtime | ~100MB | QML engine, Qt modules |
| UI (Active Page) | ~80MB | One page at a time |
| Services (C++) | ~50MB | All backend services |
| Images/Assets | ~40MB | Cached resources |
| Waydroid (if active) | ~300MB | Android container |
| **Total** | **~270MB** | (or ~570MB with Android) |

---

## 🔨 **Building & Testing** {#building}

### **CMake Build Options:**

```bash
cmake -DCMAKE_BUILD_TYPE=Release \        # Optimize (-O3)
      -DCMAKE_TOOLCHAIN_FILE=arm64.cmake \  # Cross-compile
      -DQT_WEBENGINE=ON \                   # Enable web player
      ..
```

### **Cross-Compilation for Raspberry Pi:**

```cmake
# arm64.cmake
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
set(CMAKE_C_COMPILER aarch64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER aarch64-linux-gnu-g++)
set(CMAKE_SYSROOT /path/to/rpi/rootfs)
```

### **Testing:**

```bash
# Unit tests (C++)
cd build && ctest

# QML tests (qmltest)
qmltestrunner -input tests/qml/

# Integration tests
python3 tests/integration/test_obd_service.py
```

### **Debugging:**

```bash
# Enable QML debugging
QML_DEBUG=1 ./carui --windowed

# DBus introspection
qdbus org.pidrive.vehicle /org/pidrive/vehicle

# CAN bus monitoring
candump can0

# Memory profiling
valgrind --tool=massif ./carui
```

---

## 📚 **Additional Resources**

- **Qt 6 QML Docs**: https://doc.qt.io/qt-6/qmlapplications.html
- **SocketCAN Guide**: https://www.kernel.org/doc/html/latest/networking/can.html
- **DBus Tutorial**: https://dbus.freedesktop.org/doc/dbus-tutorial.html
- **Raspberry Pi GPIO**: https://pinout.xyz/

---

**Last Updated:** 2025-10-28 | **Version:** 2.0 (Consolidated)

