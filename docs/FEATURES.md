# ⭐ Features Guide - PiDriveSmartOS

Complete feature list, setup guides, and platform comparisons.

---

## 📋 **Core Features**

### **🎛️ Dashboard & Vehicle Data**
- Real-time OBD-II metrics (speed, RPM, fuel, temp, voltage)
- Circular & linear gauges with color-coded warnings
- Trip computer (MPG, distance, time, avg speed)
- Live weather widget
- Vehicle diagnostics (DTCs, freeze frames)

### **📱 Bluetooth Phone Integration**
- Hands-Free Profile (HFP) - make/receive calls
- Advanced Audio Distribution Profile (A2DP) - music streaming
- Phone Book Access Profile (PBAP) - contact sync
- Recent calls, favorites, dial pad

### **🎵 Media Player**
- Local music playback
- Spotify web player integration
- YouTube web player integration
- Bluetooth audio streaming
- EQ controls, playlists

### **🗺️ Navigation**
- GPS positioning
- Route planning (future)
- Real-time traffic (future)

### **📱 Android App Support (Waydroid)**
- Run Android APKs natively
- Google Play Store access
- Install apps: Waze, Google Maps, Spotify, etc
- Container-based isolation

### **🌐 Connectivity**
- WiFi management (scan, connect, password entry)
- Bluetooth pairing (devices, speakers, phones)
- LTE/4G modem support (optional)
- Hotspot mode

### **🎤 Voice Assistant**
- Offline voice commands
- "Navigate to [destination]"
- "Call [contact]"
- "Play music"
- "Turn on night mode"

### **⚙️ System Settings**
- Display: Brightness, theme (day/night), units
- Vehicle: Name, type, fuel type
- Network: WiFi, Bluetooth, LTE
- Developer mode toggle
- System updates (OTA)

---

## 🔧 **Setup Guides**

### **Android Apps (Waydroid)**

#### **Installation:**

```bash
# Install Waydroid
sudo apt install curl ca-certificates
curl https://repo.waydro.id | sudo bash
sudo apt install waydroid

# Initialize Waydroid (first time)
sudo waydroid init

# Start Waydroid service
sudo systemctl enable --now waydroid-container

# First launch (from UI or terminal)
waydroid session start
```

#### **Install Apps:**

```bash
# Install APK
waydroid app install app.apk

# Or use Google Play (requires gapps init)
sudo waydroid init -s GAPPS
```

#### **Recommended Apps:**
- **Navigation**: Waze, Google Maps, Sygic
- **Music**: Spotify, YouTube Music, Deezer
- **Communication**: WhatsApp, Telegram
- **Utilities**: Torque Pro (OBD), Dashcam

---

### **Web Player (Spotify & YouTube)**

#### **Installation:**

```bash
# Install QtWebEngine
sudo apt install qt6-webengine-dev libqt6webengine6

# Already integrated in PiDriveSmartOS!
# Just click "Spotify" or "YouTube" in Media page
```

#### **Usage:**
1. Open **Media** page
2. Click **"Spotify"** or **"YouTube"** button
3. Login with your account
4. Music plays in embedded browser
5. Click **X** to close player

#### **Troubleshooting:**
```bash
# If WebEngine not found during build:
sudo apt install qt6-webengine-dev

# Enable GPU acceleration (Raspberry Pi 5):
export QT_QUICK_BACKEND=software  # Or hardware if drivers available
```

---

### **WiFi & Bluetooth**

#### **WiFi Setup:**
1. Open **Settings** → **Connectivity**
2. Toggle WiFi **ON**
3. Select network from list
4. Enter password in dialog
5. Click **Connect**

#### **Bluetooth Pairing:**
1. Open **Settings** → **Connectivity**
2. Toggle Bluetooth **ON**
3. Select device from scan results
4. Confirm pairing code
5. Device connected!

#### **Advanced (NetworkManager CLI):**
```bash
# Scan WiFi
nmcli device wifi list

# Connect to WPA2 network
nmcli device wifi connect "SSID" password "PASSWORD"

# Bluetooth pairing
bluetoothctl
> scan on
> pair AA:BB:CC:DD:EE:FF
> connect AA:BB:CC:DD:EE:FF
```

---

## 🆚 **Platform Comparison**

| Feature | PiDriveSmartOS | Tesla | Apple CarPlay | Android Auto |
|---------|----------------|-------|---------------|--------------|
| **Open Source** | ✅ | ❌ | ❌ | ❌ |
| **Hardware Cost** | ~$300 | $60,000+ | $500+ (aftermarket) | $200+ |
| **OBD-II Access** | ✅ Full | ⚠️ Limited | ❌ | ⚠️ Via app |
| **Android Apps** | ✅ Waydroid | ❌ | ❌ | ✅ Native |
| **Customization** | ✅ Full | ❌ | ❌ | ⚠️ Limited |
| **Voice Assistant** | ✅ Offline | ✅ Online | ✅ Siri (online) | ✅ Google (online) |
| **Navigation** | ✅ (Waze, Maps) | ✅ Proprietary | ✅ Apple Maps | ✅ Google Maps |
| **Music Streaming** | ✅ (Spotify, YT) | ✅ | ✅ | ✅ |
| **Bluetooth** | ✅ HFP/A2DP/PBAP | ✅ | ✅ | ✅ |
| **OTA Updates** | ✅ (RAUC/Mender) | ✅ | ✅ | ✅ (via phone) |
| **Developer Mode** | ✅ Full Linux | ❌ | ❌ | ❌ |
| **Privacy** | ✅ Offline-first | ⚠️ Telemetry | ⚠️ Apple data | ⚠️ Google data |

### **Why PiDriveSmartOS?**

✅ **Open Source** - modify anything, no vendor lock-in  
✅ **Affordable** - $300 vs $60k for Tesla  
✅ **Full Control** - developer mode, SSH, root access  
✅ **Privacy** - offline-first, no telemetry  
✅ **Extensible** - add sensors, cameras, custom features  
✅ **Learning Platform** - perfect for makers, students, DIYers  

---

## 🚀 **Future Features (Roadmap)**

- **ADAS**: Lane departure warning, collision detection
- **Smart Home**: Garage door, lights, thermostat control
- **Cloud Sync**: Backup settings, remote access
- **Multi-user**: Profiles, seat/mirror memory
- **Advanced Voice**: Offline LLM (Llama 3), natural language
- **Dashcam**: Video recording, parking mode, G-sensor

---

**Last Updated:** 2025-10-28 | **Version:** 2.0 (Consolidated)
