# Hardware Guide

> Complete hardware specifications, wiring diagrams, and component selection for PiDriveSmartOS

---

## Table of Contents

- [Bill of Materials](#bill-of-materials)
- [Raspberry Pi 5 Specifications](#raspberry-pi-5-specifications)
- [Pinout and GPIO Usage](#pinout-and-gpio-usage)
- [CAN Bus Interface](#can-bus-interface)
- [Power Supply Design](#power-supply-design)
- [Display Configuration](#display-configuration)
- [GPS Module](#gps-module)
- [Audio System](#audio-system)
- [Cameras](#cameras)
- [Assembly Guide](#assembly-guide)
- [Enclosure Design](#enclosure-design)
- [Thermal Management](#thermal-management)

---

## Bill of Materials

### Core Components

| Part | Specification | Quantity | Est. Cost (USD) |
|------|---------------|----------|-----------------|
| Raspberry Pi 5 | 8GB RAM model | 1 | $80 |
| Power Supply | 12V→5V 5A USB-C PD (automotive) | 1 | $25 |
| MicroSD Card | 64GB Class A2 (SanDisk Extreme) | 1 | $15 |
| **OR** NVMe HAT | M.2 NVMe adapter + 256GB SSD | 1 | $60 |
| Touchscreen | 7" 1024x600 HDMI capacitive | 1 | $60 |
| CAN Interface | MCP2515 SPI CAN module + transceiver | 1 | $12 |
| GPS Module | USB GPS (u-blox NEO-6M or better) | 1 | $20 |
| Cooling | Active cooling fan + heatsink | 1 | $10 |
| Enclosure | Custom 3D printed or aluminum case | 1 | $30 |

**Total Core System**: ~$250-$300

### Optional Components

| Part | Purpose | Est. Cost (USD) |
|------|---------|-----------------|
| Secondary Display | 3.5" TFT for HUD (SPI/HDMI) | $25 |
| USB Camera | Front/rear camera (1080p) | $30 each |
| LTE Modem | 4G USB dongle (Huawei E3372) | $40 |
| Microphone Array | 2-mic USB array for voice | $20 |
| OBD-II Connector | Male OBD-II plug with cable | $8 |
| GPIO Buttons | Emergency controls (5x tactile) | $5 |
| RTC Module | DS3231 for accurate timekeeping | $5 |

---

## Raspberry Pi 5 Specifications

### Technical Specs

- **SoC**: Broadcom BCM2712 (2.4 GHz quad-core Cortex-A76)
- **RAM**: 4GB or 8GB LPDDR4X-4267
- **GPU**: VideoCore VII (OpenGL ES 3.1, Vulkan 1.2)
- **Storage**: microSD + PCIe 2.0 x1 (for NVMe)
- **USB**: 2x USB 3.0, 2x USB 2.0
- **Display**: 2x micro-HDMI (4Kp60 each)
- **Network**: Gigabit Ethernet, Wi-Fi 6, Bluetooth 5.0
- **GPIO**: 40-pin header (same as Pi 4)
- **Power**: USB-C PD (5V 5A / 25W recommended)

### Why Raspberry Pi 5?

1. **Performance**: 2-3x faster than Pi 4 (critical for Qt/WebEngine)
2. **PCIe NVMe**: Fast storage for maps and media cache
3. **Dual display**: Simultaneous dashboard + HUD output
4. **Better thermals**: Improved power management vs Pi 4
5. **Community support**: Excellent driver ecosystem

---

## Pinout and GPIO Usage

### 40-Pin GPIO Header

```
        Raspberry Pi 5 GPIO Pinout
        (Looking at board from above)

    3.3V  1 ● ● 2   5V      ← Power rails
   GPIO2  3 ● ● 4   5V
   GPIO3  5 ● ● 6   GND
   GPIO4  7 ● ● 8   GPIO14  ← UART TX (GPS)
     GND  9 ● ● 10  GPIO15  ← UART RX (GPS)
  GPIO17 11 ● ● 12  GPIO18  ← Developer Mode Toggle
  GPIO27 13 ● ● 14  GND
  GPIO22 15 ● ● 16  GPIO23  ← CAN INT (MCP2515)
    3.3V 17 ● ● 18  GPIO24  ← Aux Button 1
  GPIO10 19 ● ● 20  GND
   GPIO9 21 ● ● 22  GPIO25  ← Aux Button 2
  GPIO11 23 ● ● 24  GPIO8   ← SPI CE0 (CAN CS)
     GND 25 ● ● 26  GPIO7   ← SPI CE1
   GPIO0 27 ● ● 28  GPIO1
   GPIO5 29 ● ● 30  GND
   GPIO6 31 ● ● 32  GPIO12  ← HUD Backlight PWM
  GPIO13 33 ● ● 34  GND
  GPIO19 35 ● ● 36  GPIO16  ← Cooling Fan PWM
  GPIO26 37 ● ● 38  GPIO20  ← I2S Data (Audio)
     GND 39 ● ● 40  GPIO21  ← I2S Clock
```

### Pin Allocation Table

| GPIO | Function | Direction | Notes |
|------|----------|-----------|-------|
| GPIO8 | SPI0 CE0 (CAN CS) | Output | MCP2515 chip select |
| GPIO9 | SPI0 MISO | Input | SPI data from CAN |
| GPIO10 | SPI0 MOSI | Output | SPI data to CAN |
| GPIO11 | SPI0 SCLK | Output | SPI clock |
| GPIO23 | CAN Interrupt | Input | MCP2515 INT pin |
| GPIO14 | UART TX | Output | GPS module (optional) |
| GPIO15 | UART RX | Input | GPS module (optional) |
| GPIO17 | Dev Mode Toggle | Input (pull-up) | Switch to GND |
| GPIO24 | Aux Button 1 | Input (pull-up) | Custom function |
| GPIO25 | Aux Button 2 | Input (pull-up) | Custom function |
| GPIO12 | PWM0 | Output | HUD backlight dimming |
| GPIO16 | PWM1 | Output | Fan speed control |
| GPIO18 | PCM CLK | Output | I2S audio (optional) |
| GPIO19 | PCM FS | Output | I2S frame sync |
| GPIO20 | PCM DIN | Input | I2S data in |
| GPIO21 | PCM DOUT | Output | I2S data out |

---

## CAN Bus Interface

### MCP2515 SPI CAN Module

**Recommended Module**: Waveshare MCP2515 CAN HAT or generic MCP2515 board

#### Wiring Diagram

```
MCP2515 Module          Raspberry Pi 5
──────────────          ──────────────
VCC (3.3V)      →       Pin 1 (3.3V)
GND             →       Pin 6 (GND)
CS              →       GPIO8 (Pin 24)
SO (MISO)       →       GPIO9 (Pin 21)
SI (MOSI)       →       GPIO10 (Pin 19)
SCK             →       GPIO11 (Pin 23)
INT             →       GPIO23 (Pin 16)

CAN_H           →       OBD-II Pin 6
CAN_L           →       OBD-II Pin 14
```

#### OBD-II Connector Pinout

```
    OBD-II Female Connector (Looking at socket)
    
          1  2  3  4  5  6  7  8
         ┌─────────────────────┐
         │ ⚪ ⚪ ⚪ ⚪ ⚪ ⚪ ⚪ ⚪ │
         │⚪ ⚪ ⚪ ⚪ ⚪ ⚪ ⚪ ⚪  │
         └─────────────────────┘
          9 10 11 12 13 14 15 16

Pin 4:  Chassis Ground
Pin 5:  Signal Ground
Pin 6:  CAN-H (ISO 15765-4)
Pin 14: CAN-L (ISO 15765-4)
Pin 16: +12V Battery
```

#### Device Tree Overlay

Add to `/boot/firmware/config.txt`:

```bash
# Enable SPI
dtparam=spi=on

# MCP2515 overlay
dtoverlay=mcp2515-can0,oscillator=8000000,interrupt=23
dtoverlay=spi0-hw-cs
```

#### SocketCAN Configuration

```bash
# Load kernel modules
sudo modprobe can
sudo modprobe can-raw
sudo modprobe mcp251x

# Bring up CAN interface (500 kbps - standard OBD-II)
sudo ip link set can0 type can bitrate 500000
sudo ip link set up can0

# Verify
ip -details link show can0
```

### CAN Bus Termination

**Important**: Most OBD-II ports have built-in 120Ω termination. Do NOT add extra termination unless using a custom CAN network.

---

## Power Supply Design

### Automotive Power Considerations

Vehicle electrical systems are harsh environments:
- **Voltage range**: 9-16V (nominal 12V)
- **Spikes**: Up to 24V during jump-starts
- **Noise**: Alternator whine, ignition pulses
- **Polarity reversal**: Accidental wrong connection

### Recommended Power Module

**Option 1: USB-C PD Car Charger**
- Input: 12V DC (cigarette lighter)
- Output: 5V 5A (25W) USB-C PD
- Protection: Over-voltage, over-current, reverse polarity
- Example: Anker PowerDrive+ III

**Option 2: Hardwired DC-DC Converter**
- Input: 9-36V DC (direct battery connection)
- Output: 5V 6A (30W)
- Isolation: Optional galvanic isolation
- Example: MEAN WELL SDR-120-5

#### Wiring (Hardwired Installation)

```
Vehicle Battery (+12V)
        │
        ├─── 5A Blade Fuse
        │
        ├─── Ignition-switched relay (optional)
        │
    DC-DC Converter (12V→5V)
        │
        └─── USB-C to Raspberry Pi 5

Vehicle Chassis (GND)
        │
        └─── DC-DC Converter GND
```

**Power Budget**:
- Raspberry Pi 5: 15W (typical), 25W (peak)
- Touchscreen: 3W (backlight on)
- USB GPS: 0.5W
- CAN module: 0.5W
- **Total**: ~20W typical, 30W max

**Recommendation**: Use 30W or higher power supply for headroom.

### Power Sequencing

1. **Ignition ON** → 12V available
2. **Delay 2s** (allow voltage stabilization)
3. **Enable DC-DC converter** → 5V to Pi
4. **Pi boots** (~8s)
5. **Ignition OFF** → Trigger graceful shutdown
6. **Wait 30s** → Cut power after shutdown complete

**Implementation**: Use ATtiny85 microcontroller to monitor ignition line and control power relay.

---

## Display Configuration

### Primary Touchscreen

**Recommended**: 7-10" capacitive touchscreen (USB or I2C touch controller)

#### Wiring

```
Touchscreen              Raspberry Pi 5
───────────              ──────────────
HDMI out        →        micro-HDMI 0
USB (touch)     →        USB port (any)
5V power        →        From DC-DC converter
GND             →        Common ground
```

#### Configuration

Edit `/boot/firmware/config.txt`:

```bash
# Set HDMI output to specific resolution
hdmi_group=2
hdmi_mode=87
hdmi_cvt=1024 600 60 6 0 0 0  # 1024x600 @ 60Hz

# Rotate display if mounted upside-down
display_rotate=2

# Disable overscan
disable_overscan=1

# Increase GPU memory for UI rendering
gpu_mem=256
```

#### Touch Calibration

```bash
# Install xinput-calibrator
sudo apt install xinput-calibrator

# Run calibration (from desktop)
xinput_calibrator

# Save to /etc/X11/xorg.conf.d/99-calibration.conf
```

### Secondary HUD Display

**Option 1**: 3.5" TFT SPI display (cheap, low resolution)
**Option 2**: Small HDMI display (better quality, uses micro-HDMI 1)

#### HUD Configuration (HDMI)

```bash
# config.txt - Dual display setup
[HDMI:0]
# Main touchscreen
hdmi_group=2
hdmi_mode=87
hdmi_cvt=1024 600 60 6 0 0 0

[HDMI:1]
# HUD display
hdmi_group=2
hdmi_mode=85  # 1280x720 @ 60Hz
```

**Qt Environment Variables**:

```bash
# Use both displays
export QT_QPA_EGLFS_PHYSICAL_WIDTH=1024
export QT_QPA_EGLFS_PHYSICAL_HEIGHT=600
export QT_QPA_EGLFS_KMS_CONFIG=/etc/pidrive/kms.json
```

**kms.json** (dual display):

```json
{
  "device": "/dev/dri/card1",
  "outputs": [
    { "name": "HDMI1", "mode": "1024x600" },
    { "name": "HDMI2", "mode": "1280x720" }
  ]
}
```

---

## GPS Module

### Recommended Modules

1. **u-blox NEO-6M**: Budget option, good accuracy
2. **u-blox NEO-M8N**: Better accuracy, faster fix
3. **u-blox ZED-F9P**: RTK support (cm-level accuracy)

### Connection Methods

**Option 1: USB GPS (Easiest)**

```bash
# Plug in USB GPS
# Auto-detected as /dev/ttyACM0

# Configure gpsd
sudo systemctl stop gpsd
sudo gpsd /dev/ttyACM0 -F /var/run/gpsd.sock
sudo systemctl start gpsd

# Test
gpsmon
cgps -s
```

**Option 2: UART GPS (GPIO)**

```
GPS Module              Raspberry Pi 5
──────────              ──────────────
VCC (3.3V)      →       Pin 1 (3.3V)
GND             →       Pin 6 (GND)
TX              →       GPIO15 (Pin 10) RX
RX              →       GPIO14 (Pin 8) TX
PPS (optional)  →       GPIO4 (Pin 7)
```

Enable UART in `/boot/firmware/config.txt`:

```bash
enable_uart=1
dtoverlay=pps-gpio,gpiopin=4
```

Configure gpsd for UART:

```bash
sudo gpsd /dev/serial0 -F /var/run/gpsd.sock
```

### External GPS Antenna

For better signal in metal car bodies:
- Use **active GPS antenna** (with built-in LNA)
- Mount on **dashboard or roof**
- Cable: SMA or MMCX connector

---

## Audio System

### Audio Output Options

1. **HDMI Audio**: Sent via HDMI cable to display (if supported)
2. **3.5mm Jack**: Built-in analog audio (lower quality)
3. **USB DAC**: External USB audio adapter (best quality)
4. **I2S DAC**: High-quality DAC HAT (e.g., HiFiBerry)

### Recommended: USB DAC

```bash
# List audio devices
aplay -l

# Set default device in /etc/asound.conf
pcm.!default {
    type hw
    card 1  # USB DAC card number
}
```

### Car Audio Integration

**Option 1: AUX Input**
- Connect 3.5mm jack to car stereo AUX input

**Option 2: FM Transmitter**
- Use USB FM transmitter dongle

**Option 3: Direct Connection**
- Use car amplifier input (requires wiring harness)

---

## Cameras

### USB Camera Setup

```bash
# Install V4L2 tools
sudo apt install v4l-utils

# List cameras
v4l2-ctl --list-devices

# Test camera
ffplay /dev/video0

# In Qt/QML
Camera {
    deviceId: "/dev/video0"
}
```

### Dual Camera Configuration

```
Front Camera (/dev/video0) → USB Port 1
Rear Camera (/dev/video1) → USB Port 2
```

**Auto-switch on reverse gear**: Use GPIO input connected to reverse light circuit.

---

## Assembly Guide

### Step-by-Step Build

1. **Prepare Raspberry Pi**
   - Attach heatsink to SoC
   - Install active cooling fan
   - Insert microSD card (or attach NVMe HAT)

2. **Connect CAN Module**
   - Solder header pins if needed
   - Connect SPI wires as per pinout
   - Secure with standoffs

3. **Wire OBD-II Connector**
   - Solder wires to OBD-II male plug
   - Connect CAN-H, CAN-L, GND, +12V
   - Add fuse on +12V line (1A)

4. **Install in Enclosure**
   - Mount Raspberry Pi on standoffs
   - Position touchscreen
   - Route cables neatly

5. **Connect Power**
   - Wire DC-DC converter to ignition-switched 12V
   - Connect USB-C to Raspberry Pi

6. **Final Checks**
   - Verify all connections
   - Check for shorts with multimeter
   - Power on and test

---

## Enclosure Design

### 3D Printed Case

**Dimensions**: ~200mm x 150mm x 40mm

**Features**:
- Mounting tabs for dashboard/DIN slot
- Ventilation slots for cooling
- Cable pass-throughs
- Removable back panel for access

**Files**: STL models available in `/hardware/3d_models/`

### DIN Mount Adapter

For standard car stereo slot (2-DIN):
- Width: 180mm
- Height: 100mm
- Depth: 150mm

---

## Thermal Management

### Cooling Strategies

1. **Passive**: Heatsink only (sufficient for <50% CPU load)
2. **Active**: 30mm fan + heatsink (recommended for continuous use)
3. **Temperature-controlled**: PWM fan based on CPU temp

### Fan Control Script

```python
import RPi.GPIO as GPIO
import time

FAN_PIN = 16
GPIO.setmode(GPIO.BCM)
GPIO.setup(FAN_PIN, GPIO.OUT)
pwm = GPIO.PWM(FAN_PIN, 25)  # 25 kHz

def get_cpu_temp():
    with open('/sys/class/thermal/thermal_zone0/temp') as f:
        return int(f.read()) / 1000.0

while True:
    temp = get_cpu_temp()
    if temp < 60:
        pwm.ChangeDutyCycle(0)  # Fan off
    elif temp < 70:
        pwm.ChangeDutyCycle(50)  # Fan 50%
    else:
        pwm.ChangeDutyCycle(100)  # Fan 100%
    time.sleep(5)
```

**Target Temperature**: <70°C under load

---

## Testing Checklist

- [ ] Raspberry Pi boots successfully
- [ ] Touchscreen displays image
- [ ] Touch input responsive
- [ ] CAN interface detected (`ip link show can0`)
- [ ] GPS receives satellite fix
- [ ] Audio output working
- [ ] Cameras detected
- [ ] Developer mode toggle functional
- [ ] System survives power cycle

---

## Troubleshooting

### Common Issues

| Problem | Solution |
|---------|----------|
| CAN interface not found | Check SPI enabled, verify wiring, check `dmesg` |
| Touchscreen not responding | Check USB connection, run `xinput list` |
| GPS no fix | Ensure antenna has clear sky view, check `gpsmon` |
| System won't boot | Check power supply (need 5A), verify SD card image |
| Display blank | Check HDMI cable, verify config.txt settings |

---

## Component Suppliers

- **Raspberry Pi**: [Official Store](https://www.raspberrypi.com/)
- **CAN Modules**: Waveshare, DFRobot, Seeed Studio
- **Displays**: Waveshare, Adafruit
- **Power**: MEAN WELL, Pololu
- **Automotive Connectors**: Amazon, AutoZone

---

**Next Steps**:
- Review [software-stack.md](software-stack.md) for OS setup
- See [architecture.md](architecture.md) for system design
- Check [security.md](security.md) for hardening

