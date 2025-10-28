# PiDriveSmartOS Scripts

This directory contains utility scripts for building, running, and managing the PiDriveSmartOS application.

---

## 🚀 Quick Start

### **Primary Development Launch** (Always rebuilds)

From the project root:
```bash
./run.sh
```
✅ **Automatically does clean rebuild**  
✅ Ensures all code changes are reflected  
✅ Launches in windowed mode  
✅ Recommended for active development

### **Quick Launch** (No rebuild)

For rapid testing without code changes:
```bash
./quick-run.sh
```
⚡ Skips rebuild, launches existing binary  
⚠️ Use only when no code changes made

### Manual Launch with Options

Full control:
```bash
./scripts/run_carui.sh [OPTIONS]
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

### 2. Development Launcher - `run.sh` ⭐

**Location:** `/run.sh` (project root)

**Primary development script** that always does a clean rebuild before launching.

**Usage:**
```bash
./run.sh
```

**Behavior:**
- ✅ Always rebuilds (passes `--rebuild` flag)
- ✅ Ensures fresh compilation
- ✅ Launches in windowed mode
- ✅ Best for active development

**Equivalent to:**
```bash
./scripts/run_carui.sh --rebuild --windowed
```

---

### 3. Quick Launcher - `quick-run.sh` ⚡

**Location:** `/quick-run.sh` (project root)

**Fast launch script** that skips rebuilding for rapid testing.

**Usage:**
```bash
./quick-run.sh
```

**Behavior:**
- ⚡ No rebuild - launches existing binary
- ⚠️ Use only when no code changes made
- ✅ Faster startup for testing
- ✅ Checks if binary exists first

**When to use:**
- Testing UI interactions
- Quick restarts after crashes
- Demo purposes
- No code was modified

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

2. **Initial build and run:**
   ```bash
   ./run.sh
   ```

### Daily Development

1. **Primary workflow** (making code changes):
   ```bash
   ./run.sh  # Always rebuilds - use this!
   ```
   
2. **Quick testing** (no code changes):
   ```bash
   ./quick-run.sh  # Fast launch without rebuild
   ```

3. **With debug output:**
   ```bash
   ./scripts/run_carui.sh --rebuild --debug --windowed
   ```

4. **Fullscreen mode:**
   ```bash
   ./scripts/run_carui.sh --rebuild --fullscreen
   ```

### Recommended Workflow

```
📝 Edit code
   ↓
💾 Save changes
   ↓
🔨 ./run.sh  ← Always rebuilds!
   ↓
🧪 Test in UI
   ↓
🔄 Repeat
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

