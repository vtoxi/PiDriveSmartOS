# PiDriveSmartOS Scripts

This directory contains utility scripts for building, running, and managing the PiDriveSmartOS application.

---

## 🚀 Quick Start

### Launch the Car UI (Windowed Mode)

From the project root:
```bash
./run.sh
```

Or from anywhere:
```bash
cd /Users/faisalsideline/Desktop/Data/repos/vtoxi/PiDriveSmartOS
./scripts/run_carui.sh --windowed
```

---

## 📋 Available Scripts

### 1. `run_carui.sh` - Car UI Launcher

**Purpose:** Launch the PiDriveSmartOS Car UI application with various options.

**Location:** `/scripts/run_carui.sh`

**Usage:**
```bash
./scripts/run_carui.sh [OPTIONS]
```

**Options:**
- `--windowed` - Run in windowed mode (for development/testing)
- `--fullscreen` - Run in fullscreen/kiosk mode (default for car use)
- `--debug` - Enable debug output and logging
- `--rebuild` - Rebuild the application before running
- `--help` - Show help message

**Examples:**
```bash
# Run in windowed mode for testing
./scripts/run_carui.sh --windowed

# Run with debug output
./scripts/run_carui.sh --debug --windowed

# Rebuild and run
./scripts/run_carui.sh --rebuild --windowed

# Run in fullscreen (car mode)
./scripts/run_carui.sh --fullscreen

# Show help
./scripts/run_carui.sh --help
```

**Features:**
- ✅ Automatic dependency checking (Qt 6, CMake)
- ✅ Automatic build if binary not found
- ✅ Colored output for easy reading
- ✅ Error handling and validation
- ✅ Background execution support
- ✅ Process ID tracking

---

### 2. Quick Launcher (Project Root)

**Location:** `/run.sh` (project root)

A convenience script that automatically runs the Car UI in windowed mode.

**Usage:**
```bash
cd /Users/faisalsideline/Desktop/Data/repos/vtoxi/PiDriveSmartOS
./run.sh
```

This is equivalent to:
```bash
./scripts/run_carui.sh --windowed
```

---

### 3. `install_dependencies.sh` - Dependency Installer

**Purpose:** Install all required dependencies for PiDriveSmartOS.

**Usage:**
```bash
./scripts/install_dependencies.sh
```

**Installs:**
- Qt 6 (Core, Quick, Multimedia, DBus, Positioning)
- CAN utilities (can-utils)
- Python dependencies (python-can, dbus-python, paho-mqtt)
- Build tools (CMake, pkg-config)
- System utilities

---

### 4. `setup_socketcan.sh` - CAN Interface Setup

**Purpose:** Configure CAN interface for OBD-II communication.

**Usage:**
```bash
sudo ./scripts/setup_socketcan.sh
```

**Configures:**
- MCP2515 CAN controller
- SocketCAN interface (can0)
- CAN bus speed (500kbps for OBD-II)
- Auto-start on boot

---

### 5. `toggle_dev_mode.sh` - Developer Mode Toggle

**Purpose:** Switch between Car Mode and Developer Mode.

**Usage:**
```bash
./scripts/toggle_dev_mode.sh
```

**Modes:**
- **Car Mode (0):** Kiosk fullscreen, minimal UI
- **Developer Mode (1):** Desktop access, SSH enabled, debugging tools

---

### 6. `start_car_mode.sh` - Car Mode Launcher

**Purpose:** Start the car in kiosk mode (for systemd service).

**Usage:**
```bash
./scripts/start_car_mode.sh
```

This script is typically called by systemd at boot.

---

## 🛠️ Development Workflow

### First Time Setup

1. **Install dependencies:**
   ```bash
   ./scripts/install_dependencies.sh
   ```

2. **Build and run:**
   ```bash
   ./scripts/run_carui.sh --rebuild --windowed
   ```

### Daily Development

1. **Quick launch for testing:**
   ```bash
   ./run.sh
   ```

2. **After making changes:**
   ```bash
   ./scripts/run_carui.sh --rebuild --windowed
   ```

3. **With debug output:**
   ```bash
   ./scripts/run_carui.sh --debug --windowed
   ```

---

## 📂 File Paths

The `run_carui.sh` script uses these absolute paths:

```bash
PROJECT_ROOT="/Users/faisalsideline/Desktop/Data/repos/vtoxi/PiDriveSmartOS"
CARUI_SOURCE="${PROJECT_ROOT}/src/carui"
CARUI_BUILD="${CARUI_SOURCE}/build"
CARUI_BINARY="${CARUI_BUILD}/carui"
```

**Note:** If you move the project, update the `PROJECT_ROOT` variable in `run_carui.sh`.

---

## 🐛 Troubleshooting

### Script won't run
```bash
# Make sure scripts are executable
chmod +x scripts/*.sh
chmod +x run.sh
```

### Binary not found
```bash
# Rebuild the application
./scripts/run_carui.sh --rebuild --windowed
```

### Qt not found
```bash
# Install Qt 6
brew install qt@6  # macOS
# or follow instructions in install_dependencies.sh
```

### Permission denied
```bash
# Some scripts need sudo (like setup_socketcan.sh)
sudo ./scripts/setup_socketcan.sh
```

---

## 📝 Creating New Scripts

When adding new scripts to this directory:

1. **Use absolute paths** for reliability
2. **Add shebang:** `#!/bin/bash`
3. **Make executable:** `chmod +x script_name.sh`
4. **Add help/usage:** Include `--help` option
5. **Error handling:** Check for dependencies and prerequisites
6. **Document here:** Add to this README

---

## 🔗 Related Documentation

- **Main README:** `/README.md`
- **Build Instructions:** `/src/carui/README.md`
- **Architecture:** `/docs/architecture.md`
- **Hardware Setup:** `/docs/hardware-wiring.md`
- **Branding Guide:** `/docs/visual-branding.md`

---

## 📞 Support

If you encounter issues with any scripts:

1. Run with `--debug` flag for detailed output
2. Check the script's help: `./script.sh --help`
3. Review error messages carefully
4. Check dependencies are installed
5. Verify file paths are correct

---

**Last Updated:** October 2025  
**Version:** 1.0.0

