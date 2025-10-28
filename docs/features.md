# Features

> Comprehensive feature list and module specifications for PiDriveSmartOS

---

## Table of Contents

- [Core Features](#core-features)
- [Vehicle Integration](#vehicle-integration)
- [Media and Entertainment](#media-and-entertainment)
- [Navigation](#navigation)
- [User Interface](#user-interface)
- [Connectivity](#connectivity)
- [Developer Features](#developer-features)
- [Optional Modules](#optional-modules)
- [Future Features](#future-features)

---

## Core Features

### Dual Operating Modes

#### 🚗 Car Mode (Production)
- **Purpose**: Daily driving interface
- **UI**: Full-screen touch-only automotive dashboard
- **Security**: Read-only filesystem, SSH disabled
- **Boot time**: ~8 seconds
- **User**: `pidrive` (limited privileges)
- **Access**: No terminal, no file browser

**Use Cases**:
- Daily commute
- Family use
- Production deployment

#### 🛠️ Developer Mode
- **Purpose**: Development, debugging, system maintenance
- **UI**: Full Linux desktop (LXDE/Wayfire)
- **Security**: Read-write filesystem, SSH enabled
- **Boot time**: ~15 seconds
- **User**: Full sudo access
- **Access**: Terminal, code editors, system tools

**Use Cases**:
- Software development
- System updates
- Troubleshooting
- Custom modifications

**Toggle Methods**:
1. UI gesture: Hold Settings icon for 10 seconds + PIN
2. Config file: Edit `/boot/firmware/devmode.cfg`
3. GPIO switch: Physical toggle connected to GPIO 17

---

## Vehicle Integration

### OBD-II Diagnostics

#### Real-Time Data Display

| Parameter | Update Rate | Range | Unit |
|-----------|-------------|-------|------|
| **Speed** | 10 Hz | 0-250 | km/h or mph |
| **RPM** | 10 Hz | 0-8000 | revolutions/min |
| **Engine Temp** | 1 Hz | -40 to 150 | °C or °F |
| **Coolant Temp** | 1 Hz | -40 to 150 | °C or °F |
| **Fuel Level** | 0.5 Hz | 0-100 | % |
| **Battery Voltage** | 1 Hz | 0-16 | V |
| **Throttle Position** | 5 Hz | 0-100 | % |
| **MAF (Mass Airflow)** | 5 Hz | 0-655 | g/s |
| **Intake Pressure** | 5 Hz | 0-255 | kPa |
| **Oxygen Sensor** | 1 Hz | 0-1.275 | V |

#### Diagnostic Trouble Codes (DTCs)

**Features**:
- Read DTCs (current and pending)
- Clear DTCs (with confirmation)
- Decode standard SAE codes (P0xxx, P2xxx, etc.)
- Manufacturer-specific codes (P1xxx)
- Freeze frame data
- Emissions readiness status

**Example Display**:
```
P0301 - Cylinder 1 Misfire Detected
  Status: Confirmed
  Freeze Frame: 2500 RPM, 85°C, 45 mph
  First Seen: 2024-10-15 08:23 AM
  Occurrences: 3
  [Clear Code] [More Info]
```

#### Vehicle Profiles

**Customizable per vehicle**:
- VIN (Vehicle Identification Number)
- Make, model, year
- Engine type (gasoline, diesel, hybrid, electric)
- Transmission (manual, automatic)
- Fuel capacity, tank size
- Preferred units (metric/imperial)
- Custom gauge thresholds

**Storage**: `/var/lib/pidrive/vehicles/profile_<VIN>.json`

### CAN Bus Monitoring

**Advanced Mode** (Developer only):
- Raw CAN frame viewer
- Hex dump of messages
- Filtering by arbitration ID
- Recording CAN traffic
- Replay recorded sessions

**Safety**: Read-only by default (no sending CAN messages)

---

## Media and Entertainment

### Audio Playback

#### Supported Sources

1. **Streaming Services** (Web-based)
   - YouTube Music
   - Spotify Web Player
   - Apple Music (web)
   - SoundCloud
   - Pandora

2. **Local Media**
   - MP3, AAC, FLAC, OGG, WAV
   - M4A, WMA (via GStreamer)
   - USB drive playback
   - SD card media library

3. **Radio** (Optional)
   - FM tuner (with USB RTL-SDR)
   - Internet radio (TuneIn, Radio.net)
   - Podcast player

4. **Bluetooth Audio**
   - Phone audio streaming (A2DP)
   - Hands-free calling (HFP)
   - Automatic pairing

#### Playback Controls

- Play/Pause, Next/Previous
- Seek bar (timeline scrubbing)
- Volume control (0-100%)
- Equalizer (5-band)
- Bass boost, Treble enhancement
- Shuffle, Repeat modes

#### Now Playing Screen

```
┌──────────────────────────────────────┐
│  [Album Art]                         │
│                                      │
│  ♪ Song Title                        │
│     Artist Name                      │
│     Album Name                       │
│                                      │
│  [━━━━━━━●─────────] 2:34 / 4:12    │
│                                      │
│  [🔀] [⏮] [⏸] [⏭] [🔁]              │
│                                      │
│  Volume: ──────●────── 75%           │
└──────────────────────────────────────┘
```

### Video Playback

**Supported Formats**:
- MP4, MKV, AVI, MOV
- H.264, H.265/HEVC (hardware decode)
- VP9, AV1 (if supported by GStreamer)

**Features**:
- Full-screen video player
- Subtitle support (SRT, ASS)
- Picture-in-picture mode
- Parked mode only (safety interlock)

**Safety**: Video disabled while vehicle speed > 5 km/h

### YouTube Integration

**Web Player**:
- Embedded YouTube player (Qt WebEngine)
- Search videos
- Playlists, subscriptions
- Recommendations

**Premium Features** (with YouTube Premium):
- Background playback
- Ad-free
- Offline downloads

---

## Navigation

### GPS Positioning

**Hardware Support**:
- USB GPS dongles (u-blox, BU-353S4)
- UART GPS modules (NEO-6M, NEO-M8N)
- Smartphone GPS (via Bluetooth tethering)

**Accuracy**:
- Standard GPS: ±5-10 meters
- SBAS (WAAS/EGNOS): ±3-5 meters
- RTK (optional): ±0.02 meters

**Features**:
- Real-time position (lat/lon)
- Speed from GPS (more accurate than OBD)
- Heading/bearing
- Altitude
- Satellite status (# in view, HDOP)

### Map Display

**Map Providers**:
1. **OpenStreetMap** (Free, default)
   - Offline tiles support
   - Turn-by-turn navigation
   - POI (Points of Interest)

2. **Mapbox** (API key required)
   - High-quality vector maps
   - Traffic data
   - Custom styles

3. **Google Maps** (Web view)
   - Familiar interface
   - Street View
   - Real-time traffic

**Features**:
- Pinch-to-zoom, pan
- 2D/3D view
- Night mode (dark tiles)
- Current location marker
- Route display
- Speed camera warnings

### Routing

**Turn-by-Turn Navigation**:
- Voice guidance (TTS)
- Lane guidance
- ETA calculation
- Alternate routes
- Avoid tolls/highways

**Route Recalculation**:
- Automatic when off-route
- Traffic-aware rerouting

**Example Route Display**:
```
┌──────────────────────────────────────┐
│  🧭 Navigation Active                │
│                                      │
│  In 500m, turn LEFT onto Main St    │
│                                      │
│  [Map View]                          │
│    ↑                                 │
│   You                                │
│    │                                 │
│    └─ Main St                        │
│                                      │
│  ETA: 10:45 AM (12 min, 8.5 km)     │
│  [End Navigation]                    │
└──────────────────────────────────────┘
```

### Points of Interest (POI)

**Categories**:
- Gas stations (with fuel prices)
- Restaurants, cafes
- Hotels
- Parking
- EV charging stations
- ATMs, banks
- Hospitals

**Features**:
- Search nearby
- Add favorites
- Phone number, hours
- Directions to POI

---

## User Interface

### Dashboard Widgets

**Customizable Layout**:
- Drag-and-drop widget positioning
- Resize widgets
- Multiple dashboard pages (swipe left/right)

**Available Widgets**:
1. **Speedometer** (digital or analog gauge)
2. **Tachometer** (RPM)
3. **Fuel Gauge**
4. **Engine Temperature**
5. **Trip Computer** (distance, avg speed, fuel economy)
6. **Clock** (digital or analog)
7. **Weather** (current conditions)
8. **Media Player** (now playing)
9. **Navigation** (next turn preview)
10. **Compass** (heading)

**Widget Themes**:
- Classic Gauges (analog needles)
- Digital Display (numeric)
- Minimalist (text only)
- Sport (racing style)

### Themes

**Day Mode**:
- Bright background
- High contrast text
- Optimized for sunlight visibility

**Night Mode**:
- Dark background (#121212)
- Dim UI elements
- Red accent color (preserves night vision)
- Auto-switch based on sunset time or ambient sensor

**Custom Themes**:
- User-created color schemes
- Import/export theme files
- Theme marketplace (community themes)

### Touch Optimization

**Design Guidelines**:
- Minimum touch target: 44x44 px (11mm)
- Large, easy-to-tap buttons
- No small checkboxes or radio buttons
- Swipe gestures for common actions
- Haptic feedback (if supported)

**Safety Features**:
- No scrolling lists while driving
- Large, high-contrast text
- Confirmation for critical actions
- Voice feedback for button presses

---

## Connectivity

### Wi-Fi

**Modes**:
1. **Client Mode** (default)
   - Connect to home/public Wi-Fi
   - Automatic reconnection
   - Saved networks

2. **Access Point Mode**
   - Create Wi-Fi hotspot
   - Share Pi's internet (tethering)
   - Password-protected (WPA2/WPA3)

**Configuration**:
- SSID, password management
- Static IP or DHCP
- Hidden network support
- MAC filtering

### Bluetooth

**Profiles**:
- **A2DP**: Audio streaming from phone
- **AVRCP**: Media controls (play/pause/next)
- **HFP**: Hands-free calling
- **PBAP**: Phonebook access
- **MAP**: Message access (SMS)

**Features**:
- Auto-connect on ignition
- Multiple device pairing (up to 5)
- Device priority (which phone connects first)

**Hands-Free Calling**:
- Answer/reject calls
- Dial from contact list
- Caller ID display
- In-call UI with mute, speakerphone

### LTE Mobile Data (Optional)

**Hardware**: USB 4G LTE dongle (Huawei E3372, etc.)

**Features**:
- Always-on internet
- Hotspot for passengers
- OTA updates via cellular
- Remote diagnostics

**Data Usage**:
- Monitor data usage
- Set monthly cap
- Disable auto-updates on cellular

### Network Services

**mDNS/Bonjour**:
- Discoverable as `pidrive.local`
- AirPlay receiver (optional)

**DLNA/UPnP**:
- Media server for phone apps
- Stream media from NAS

---

## Developer Features

### WebSocket API

**Endpoint**: `ws://localhost:9000/api`

**Authentication**: API key or OAuth token

**Example Usage**:

```javascript
const ws = new WebSocket('ws://pidrive.local:9000/api/vehicle');

ws.onopen = () => {
  ws.send(JSON.stringify({
    type: 'subscribe',
    channels: ['speed', 'rpm', 'fuel']
  }));
};

ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  console.log('Speed:', data.speed, 'km/h');
};
```

**Available Channels**:
- `vehicle` - Real-time OBD data
- `gps` - GPS position stream
- `media` - Playback status
- `system` - CPU, memory, temp

### Plugin System

**Plugin Types**:
1. **QML Plugins**: Custom UI screens
2. **Python Services**: Background daemons
3. **Qt C++ Plugins**: High-performance modules

**Example Plugin** (`MyGauges.qml`):

```qml
import QtQuick 2.15
import org.pidrive.vehicle 1.0

Item {
    id: customGauge
    
    VehicleData {
        id: vehicle
        onSpeedChanged: {
            speedText.text = Math.round(speed) + " mph"
        }
    }
    
    Text {
        id: speedText
        font.pixelSize: 48
        color: "white"
    }
}
```

**Installation**:
```bash
# Copy plugin to plugins directory
cp MyGauges.qml /opt/pidrive/share/plugins/

# Enable in Settings → Plugins
```

### Logging and Debugging

**Log Files**:
- `/var/log/pidrive/system.log` - Main system log
- `/var/log/pidrive/obd.log` - OBD service
- `/var/log/pidrive/gps.log` - GPS data
- `/var/log/pidrive/crash/` - Crash dumps

**Log Viewer** (Developer Mode):
- Real-time log streaming
- Filter by severity (debug, info, warning, error)
- Search logs
- Export logs

**Debugging Tools**:
- GDB (C++ debugging)
- QML profiler
- Performance monitor (CPU, RAM, GPU)
- CAN traffic analyzer

---

## Optional Modules

### Backup Camera

**Hardware**: USB webcam (720p or 1080p)

**Features**:
- Auto-activate on reverse gear (GPIO trigger)
- Parking guidelines overlay
- Distance estimation
- Wide-angle lens support
- Night vision (IR camera)

**Configuration**:
```bash
# Detect reverse gear from CAN bus or GPIO
# GPIO 26 connected to reverse light circuit
echo "reverse_gpio=26" >> /etc/pidrive/camera.conf
```

### Dashcam Recording

**Features**:
- Continuous loop recording (overwrites oldest)
- Event detection (hard braking, collision)
- Manual recording trigger
- Timestamp and GPS overlay
- Export clips to USB

**Storage**: Requires 64GB+ SD card or USB drive

**Video Settings**:
- Resolution: 720p, 1080p, 1440p
- FPS: 30, 60
- Bitrate: 5-15 Mbps
- Format: MP4 (H.264)

### Voice Assistant

**Wake Word**: "Hey Car" or "OK Drive"

**Commands**:
- "Navigate to [address]"
- "Play [song] by [artist]"
- "Call [contact]"
- "What's my fuel level?"
- "Read my messages"
- "Set volume to 50%"

**Engines**:
- Mycroft (open-source)
- Rhasspy (offline)
- Google Assistant (online)
- Amazon Alexa (online)

### ADAS (Advanced Driver Assistance Systems)

#### Lane Departure Warning

**Hardware**: Front-facing camera + Coral USB Accelerator

**Features**:
- Detect lane markings
- Visual + audio alert on drift
- Lane centering visualization
- Works at 50+ km/h

**Accuracy**: 90%+ in daylight, 70%+ at night

#### Forward Collision Warning

**Features**:
- Detect vehicles ahead
- Calculate time-to-collision (TTC)
- Alert if TTC < 2 seconds
- Distance indicator

**Limitations**: Visual warning only, no active braking

---

## Future Features

### Planned (See [roadmap.md](roadmap.md))

- **Android Auto / Apple CarPlay** (v1.1)
- **Cloud sync** (v1.2)
- **Mobile companion app** (v1.2)
- **Smart home integration** (v2.3)
- **EV charging status** (v2.4)
- **V2V communication** (v3.0)

### Under Research

- **AI Co-Pilot**: ChatGPT-like assistant
- **Predictive Maintenance**: ML-based fault prediction
- **Gesture Control**: Camera-based hand gestures
- **Augmented Reality HUD**: Windshield projection
- **Mesh Networking**: Car-to-car data exchange

---

## Feature Comparison

### vs. Commercial Systems

| Feature | PiDriveSmartOS | Tesla | Android Auto | Apple CarPlay |
|---------|----------------|-------|--------------|---------------|
| **Open Source** | ✅ | ❌ | ❌ | ❌ |
| **Customizable UI** | ✅ | ❌ | ❌ | ❌ |
| **OBD-II Diagnostics** | ✅ | ✅ | ❌ | ❌ |
| **Navigation** | ✅ | ✅ | ✅ | ✅ |
| **Media Playback** | ✅ | ✅ | ✅ | ✅ |
| **Voice Control** | ⚠️ (planned) | ✅ | ✅ | ✅ |
| **ADAS** | ⚠️ (basic) | ✅ | ❌ | ❌ |
| **Cost** | **$300** | $15,000+ | Free (phone req'd) | Free (phone req'd) |
| **Hardware** | Raspberry Pi | Custom | Phone | Phone |
| **Developer Mode** | ✅ | ❌ | ❌ | ❌ |

---

## Feature Requests

**Vote for features**: [GitHub Discussions](https://github.com/yourorg/pidrivesmartos/discussions/categories/feature-requests)

**Top Requests**:
1. Offline maps with routing
2. Native Spotify app (vs web player)
3. Wireless Android Auto
4. Custom gauge creator (visual editor)
5. Trip statistics and analytics

---

## Conclusion

PiDriveSmartOS offers a **comprehensive feature set** rivaling commercial systems, with the added benefit of **full customization and open-source transparency**.

**Key Strengths**:
- 🚗 Full vehicle integration (OBD-II, CAN)
- 🎵 Rich media playback options
- 🗺️ Flexible navigation (multiple map providers)
- 🛠️ Developer-friendly (plugins, API)
- 🔒 Security-focused (developer mode toggle)
- 💰 Cost-effective ($300 vs $1,000+ commercial)

**Next Steps**:
- Review [ui-design.md](ui-design.md) for UX details
- See [roadmap.md](roadmap.md) for upcoming features
- Check [architecture.md](architecture.md) for technical design

