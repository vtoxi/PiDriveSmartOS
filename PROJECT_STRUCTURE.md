# PiDriveSmartOS - Project Structure

This document describes the complete file and directory structure of the PiDriveSmartOS repository.

---

## Root Directory

```
PiDriveSmartOS/
├── README.md                    # Main project documentation
├── LICENSE                      # Apache 2.0 license
├── CONTRIBUTING.md             # Contribution guidelines
├── PROJECT_STRUCTURE.md        # This file
├── requirements.txt            # Python dependencies
│
├── docs/                       # Technical documentation
│   ├── architecture.md         # System architecture
│   ├── hardware.md             # Hardware setup guide
│   ├── software-stack.md       # Software stack details
│   ├── security.md             # Security guidelines
│   ├── roadmap.md              # Development roadmap
│   ├── features.md             # Feature specifications
│   └── ui-design.md            # UI/UX design guide
│
├── src/                        # Source code
│   ├── carui/                  # Qt QML Car UI application
│   │   ├── main.cpp            # Application entry point
│   │   ├── vehicledata.h       # Vehicle data class header
│   │   ├── vehicledata.cpp     # Vehicle data implementation
│   │   ├── gpsservice.h        # GPS service (not yet created)
│   │   ├── mediacontroller.h   # Media controller (not yet created)
│   │   ├── carui.pro           # Qt project file (qmake)
│   │   ├── CMakeLists.txt      # CMake build file (alternative)
│   │   └── qml/                # QML UI files
│   │       ├── main.qml        # Main window
│   │       ├── DashboardPage.qml    # Dashboard screen
│   │       ├── NavigationPage.qml   # Navigation screen (stub)
│   │       ├── MediaPage.qml        # Media player screen (stub)
│   │       ├── VehiclePage.qml      # Vehicle info screen (stub)
│   │       └── SettingsPage.qml     # Settings screen (stub)
│   │
│   ├── obd_service/            # OBD-II service daemon (Python)
│   │   ├── obd_daemon.py       # Main OBD service
│   │   ├── pid_decoder.py      # PID decoding logic (stub)
│   │   └── can_listener.py     # CAN bus listener (stub)
│   │
│   ├── systemd/                # Systemd service files
│   │   ├── carui.service       # Car UI service
│   │   ├── obdsvc.service      # OBD service
│   │   └── socketcan.service   # SocketCAN setup
│   │
│   └── plugins/                # Plugin examples (future)
│       └── example_plugin.so   # Placeholder
│
├── scripts/                    # Setup and utility scripts
│   ├── install_dependencies.sh # Install all dependencies
│   ├── setup_socketcan.sh      # Configure CAN interface
│   ├── toggle_dev_mode.sh      # Switch between modes
│   ├── start_car_mode.sh       # Launch Car Mode
│   └── simulate_obd.py         # OBD simulator (future)
│
├── config/                     # Configuration files
│   ├── devmode.cfg             # Developer mode toggle
│   ├── carui.conf              # Car UI settings
│   ├── obd.conf                # OBD service config
│   ├── network.conf            # Network settings
│   └── kms.json                # Display KMS config
│
├── tests/                      # Test suites (future)
│   ├── unit/                   # Unit tests
│   ├── integration/            # Integration tests
│   └── fixtures/               # Test data
│
└── .github/                    # GitHub-specific files (future)
    ├── workflows/              # CI/CD workflows
    │   └── build.yml           # Build and test
    ├── ISSUE_TEMPLATE/         # Issue templates
    └── PULL_REQUEST_TEMPLATE.md # PR template
```

---

## Directory Details

### `/docs` - Documentation

Comprehensive technical documentation covering all aspects of the system.

| File | Description |
|------|-------------|
| `architecture.md` | System architecture, boot sequence, data flow |
| `hardware.md` | Raspberry Pi 5 wiring, CAN interface, pinouts |
| `software-stack.md` | OS selection, Qt framework, build instructions |
| `security.md` | Security model, developer mode, CAN safety |
| `roadmap.md` | Development timeline, feature roadmap |
| `features.md` | Detailed feature specifications |
| `ui-design.md` | UI/UX design guidelines, theming |

### `/src` - Source Code

All application and service code.

#### `/src/carui` - Qt Car UI

The main touchscreen interface built with Qt 6 and QML.

**C++ Files**:
- `main.cpp` - Application entry point, initializes Qt and QML
- `vehicledata.h/cpp` - DBus interface to OBD service
- `gpsservice.h/cpp` - GPS data handling (to be implemented)
- `mediacontroller.h/cpp` - Media playback control (to be implemented)

**QML Files**:
- `main.qml` - Root window, navigation bar, status bar
- `DashboardPage.qml` - Main dashboard with gauges
- `NavigationPage.qml` - Map and routing interface
- `MediaPage.qml` - Music and video player
- `VehiclePage.qml` - Vehicle diagnostics and DTCs
- `SettingsPage.qml` - System settings

**Build System**:
- `carui.pro` - qmake project file
- `CMakeLists.txt` - CMake alternative

#### `/src/obd_service` - OBD Service

Python daemon that reads CAN bus and exposes data via DBus.

- `obd_daemon.py` - Main service with DBus interface
- `pid_decoder.py` - OBD-II PID parsing logic
- `can_listener.py` - SocketCAN message handling

#### `/src/systemd` - System Services

Systemd unit files for service management.

- `carui.service` - Launches Car UI in kiosk mode
- `obdsvc.service` - OBD-II service daemon
- `socketcan.service` - CAN interface setup

### `/scripts` - Setup Scripts

Automation scripts for installation and configuration.

| Script | Purpose |
|--------|---------|
| `install_dependencies.sh` | Install all system packages |
| `setup_socketcan.sh` | Configure MCP2515 CAN interface |
| `toggle_dev_mode.sh` | Switch between Car/Developer modes |
| `start_car_mode.sh` | Launch Car Mode manually |

### `/config` - Configuration Files

Example configuration files (copied to `/etc/pidrive` during installation).

| File | Purpose |
|------|---------|
| `devmode.cfg` | Developer mode flag (car_mode=0/1) |
| `carui.conf` | Car UI settings (theme, units, etc.) |
| `obd.conf` | OBD service configuration (CAN, PIDs) |
| `network.conf` | Network settings (Wi-Fi, Bluetooth) |
| `kms.json` | KMS display configuration for Qt |

---

## Installation Paths

After installation, files are deployed to:

```
/opt/pidrive/               # Application root
├── bin/
│   ├── carui               # Qt application binary
│   ├── obd_daemon.py       # OBD service
│   └── setup_socketcan.sh  # Helper script
├── lib/
│   └── plugins/            # Qt plugins, extensions
└── share/
    ├── qml/                # QML files
    ├── themes/             # UI themes
    └── sounds/             # UI sounds

/etc/pidrive/               # System configuration
├── carui.conf
├── obd.conf
├── network.conf
├── kms.json
└── devmode.pin             # Hashed PIN

/var/log/pidrive/           # Log files
├── system.log
├── obd.log
├── gps.log
└── crash/                  # Crash dumps

/var/lib/pidrive/           # Application data
├── cache/                  # Map tiles, media cache
├── data/                   # Trip logs
└── vehicles/               # Vehicle profiles

/boot/firmware/             # Boot partition
└── devmode.cfg             # Mode toggle flag
```

---

## Build Artifacts

After building, temporary files are created:

```
src/carui/build/            # Qt build directory
├── carui                   # Executable
├── *.o                     # Object files
├── Makefile                # Generated makefile
└── moc_*.cpp               # Qt MOC files

src/obd_service/__pycache__/ # Python bytecode
└── *.pyc
```

---

## Git Ignore

The following are typically ignored (`.gitignore`):

```
# Build artifacts
build/
*.o
*.so
*.a
moc_*.cpp
qrc_*.cpp

# Python
__pycache__/
*.pyc
*.pyo
*.egg-info/

# Qt Creator
*.pro.user
*.autosave

# Logs
*.log

# IDE
.vscode/
.idea/
*.swp

# Temporary
*~
.DS_Store
```

---

## Key Files Summary

### For Developers

| File | Purpose |
|------|---------|
| `README.md` | Start here for overview |
| `CONTRIBUTING.md` | Contribution guidelines |
| `docs/architecture.md` | Understand system design |
| `docs/software-stack.md` | Build instructions |
| `src/carui/main.cpp` | Qt app entry point |
| `src/obd_service/obd_daemon.py` | OBD service logic |

### For Users

| File | Purpose |
|------|---------|
| `README.md` | Quick start guide |
| `scripts/install_dependencies.sh` | Install system |
| `scripts/toggle_dev_mode.sh` | Switch modes |
| `config/carui.conf` | Customize UI |
| `docs/hardware.md` | Wiring guide |

### For Admins

| File | Purpose |
|------|---------|
| `docs/security.md` | Hardening guide |
| `src/systemd/*.service` | Service management |
| `config/network.conf` | Network setup |
| `/var/log/pidrive/` | System logs |

---

## Contributing

When adding new files:

1. **Source code** → `/src/[module]/`
2. **Documentation** → `/docs/`
3. **Scripts** → `/scripts/`
4. **Configuration** → `/config/`
5. **Tests** → `/tests/`

Follow the existing structure and naming conventions.

---

## Future Expansions

Planned additions to the structure:

```
src/
├── adas/                   # Advanced driver assistance
│   ├── lane_detection.py
│   └── collision_warning.py
├── voice/                  # Voice assistant
│   └── voice_controller.py
└── cloud/                  # Cloud sync service
    └── cloud_sync.py

hardware/
├── 3d_models/              # STL files for enclosure
│   └── case_v1.stl
├── pcb/                    # Custom PCB designs
│   └── can_hat.kicad_pcb
└── wiring/                 # Fritzing diagrams
    └── full_system.fzz

images/
└── screenshots/            # UI screenshots
    ├── dashboard.png
    └── navigation.png
```

---

## Resources

- **GitHub**: [Repository](https://github.com/vtoxi/pidrivesmartos)
- **Documentation**: [GitHub Pages](https://vtoxi.github.io/pidrivesmartos)
- **Discord**: [Community](https://discord.gg/pidrive)

---

**Last Updated**: 2024-10-28  
**Version**: 0.9.0

