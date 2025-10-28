# 🔧 Hardware Guide - PiDriveSmartOS

Complete hardware setup, wiring, and Bill of Materials for Raspberry Pi 5-based automotive system.

---

## 📋 **Table of Contents**

1. [Hardware Requirements](#hardware-requirements)
2. [Raspberry Pi 5 Pinout](#raspberry-pi-5-pinout)
3. [Wiring Diagram](#wiring-diagram)
4. [Bill of Materials (BOM)](#bill-of-materials)
5. [Step-by-Step Assembly](#assembly)
6. [Power Management](#power-management)
7. [Safety & Noise Reduction](#safety)
8. [Future Expansions](#expansions)

---

## 🛠️ **Hardware Requirements**

### **Core Components:**

| Component | Model/Spec | Required | Notes |
|-----------|------------|----------|-------|
| **SBC** | Raspberry Pi 5 (8GB) | ✅ Yes | Main compute unit |
| **Storage** | 64GB+ microSD (A2/U3) | ✅ Yes | OS + data storage |
| **Power** | 12V→5V/5A DC-DC Converter | ✅ Yes | Car power adapter |
| **CAN Interface** | MCP2515 SPI CAN Module | ✅ Yes | OBD-II communication |
| **Display** | 7" DSI/HDMI Touchscreen | ✅ Yes | 1024x600 minimum |

### **Optional Components:**

| Component | Model/Spec | Use Case |
|-----------|------------|----------|
| GPS Module | NEO-6M/7M/8M | Navigation |
| Microphone | USB/I2S Mic | Voice assistant |
| Camera | Raspberry Pi Camera V3 | Dashcam, parking |
| HUD Projector | 5" HUD Display | Heads-up display |
| Cooling Fan | 5V PWM Fan | Thermal management |
| RTC | DS3231 I2C RTC | Time keeping |
| LTE Modem | Huawei E3372 4G | Internet connectivity |

---

## 📌 **Raspberry Pi 5 Pinout Usage**

```
╔═══════════════════════════════════════╗
║   Raspberry Pi 5 GPIO Mapping        ║
╚═══════════════════════════════════════╝

Power:
  Pin 2/4:  5V Power (from DC-DC converter)
  Pin 6/9:  Ground

SPI (CAN Interface - MCP2515):
  Pin 19:   SPI0_MOSI  → MCP2515 SI
  Pin 21:   SPI0_MISO  → MCP2515 SO
  Pin 23:   SPI0_SCLK  → MCP2515 SCK
  Pin 24:   SPI0_CE0   → MCP2515 CS
  Pin 22:   GPIO 25    → MCP2515 INT

I2C (GPS, RTC, Sensors):
  Pin 3:    SDA (I2C1)
  Pin 5:    SCL (I2C1)

UART (Debug/Serial):
  Pin 8:    UART TX
  Pin 10:   UART RX

GPIO (Buttons, LED, Fan):
  Pin 11:   GPIO 17   → Developer Mode Switch
  Pin 13:   GPIO 27   → Status LED
  Pin 15:   GPIO 22   → Fan PWM Control
  Pin 16:   GPIO 23   → Ignition Sense (optional)
```

---

## 🔌 **Wiring Diagram**

```mermaid
graph TB
    subgraph "Vehicle"
        IGN[Ignition 12V]
        OBD[OBD-II Port]
        GND[Vehicle Ground]
    end
    
    subgraph "Power Module"
        DC[12V→5V 5A Converter]
        FUSE[10A Fuse]
    end
    
    subgraph "Raspberry Pi 5"
        RPI[RPi 5 Main Board]
        GPIO[GPIO Pins]
    end
    
    subgraph "Peripherals"
        CAN[MCP2515 CAN]
        LCD[7" Touchscreen]
        GPS[GPS Module]
        MIC[Microphone]
        CAM[Camera]
        FAN[Cooling Fan]
    end
    
    IGN -->|12V| FUSE
    FUSE --> DC
    DC -->|5V 5A| RPI
    GND --> DC
    GND --> RPI
    
    OBD -->|CAN-H/L| CAN
    CAN -->|SPI| GPIO
    LCD -->|DSI/HDMI| RPI
    GPS -->|I2C/UART| GPIO
    MIC -->|USB| RPI
    CAM -->|CSI| RPI
    FAN -->|PWM| GPIO
```

---

## 💰 **Bill of Materials (BOM)**

### **Essential Components (~$250-300):**

| Item | Model/Spec | Source | Est. Cost | Notes |
|------|------------|--------|-----------|-------|
| Raspberry Pi 5 | 8GB RAM | Official/Adafruit | $80 | Core compute |
| microSD Card | SanDisk Extreme 64GB A2 | Amazon | $15 | Fast boot |
| DC-DC Converter | DROK LM2596 12V→5V 5A | Amazon | $12 | Efficient, regulated |
| CAN Interface | MCP2515 SPI Module | Amazon/AliExpress | $8 | With TJA1050 transceiver |
| OBD-II Cable | OBD-II to DB9 Cable | Amazon | $12 | CAN bus access |
| Touchscreen | Official 7" Touch Display | Raspberry Pi | $70 | DSI connection |
| Case/Mount | Custom 3D Printed | Thingiverse | $20 | Or acrylic case |
| Cables & Wires | Dupont, JST, Power | Amazon | $15 | Assorted |
| Fuse Holder | Inline 10A Fuse | Auto parts | $5 | Safety |
| Cooling Fan | 30mm 5V PWM Fan | Amazon | $8 | Temperature control |
| **Subtotal** | | | **~$245** | |

### **Optional Upgrades (~$150-250):**

| Item | Model/Spec | Source | Est. Cost | Purpose |
|------|------------|--------|-----------|---------|
| GPS Module | NEO-8M with Antenna | Amazon | $25 | Navigation, time sync |
| USB Microphone | Mini USB Mic Array | Amazon | $15 | Voice commands |
| Camera Module | RPi Camera V3 | Official | $35 | Dashcam, parking assist |
| HUD Projector | 5" OBD HUD Display | Amazon | $45 | Heads-up display |
| LTE Modem | Huawei E3372 4G USB | Amazon | $40 | Internet connectivity |
| RTC Module | DS3231 High Precision | Amazon | $8 | Time keeping (offline) |
| Storage Upgrade | 128GB Industrial SD | Amazon | $30 | More space, reliability |
| **Subtotal** | | | **~$198** | |

### **Total Build Cost:**
- **Basic Setup:** ~$250
- **Full Featured:** ~$450
- **Premium (with HUD/LTE):** ~$500

---

## 🔧 **Step-by-Step Assembly**

### **1. Prepare Raspberry Pi**
```bash
# Flash Raspberry Pi OS 64-bit to microSD
# Enable SPI, I2C, UART in raspi-config
sudo raspi-config
```

### **2. Install MCP2515 CAN Module**
- Connect via SPI (see pinout above)
- Add to `/boot/config.txt`:
```
dtparam=spi=on
dtoverlay=mcp2515-can0,oscillator=8000000,interrupt=25
dtoverlay=spi-bcm2835
```

### **3. Wire Power System**
```
Vehicle 12V → 10A Fuse → DC-DC Converter (Input)
DC-DC Converter (Output) → Raspberry Pi 5V GPIO Pins
Vehicle GND → DC-DC GND → Raspberry Pi GND
```

### **4. Connect OBD-II**
```
OBD-II Pin 6 (CAN-H) → MCP2515 CAN-H
OBD-II Pin 14 (CAN-L) → MCP2515 CAN-L
OBD-II Pin 4/5 (GND) → System Ground
```

### **5. Mount Display**
- Connect via DSI ribbon cable (recommended) or HDMI
- Connect touch interface via USB or GPIO

### **6. Add Optional Modules**
- GPS: I2C or UART connection
- Microphone: USB port
- Camera: CSI connector
- Fan: GPIO 22 (PWM control)

---

## ⚡ **Power Management**

### **Power Requirements:**
- Raspberry Pi 5: 5V @ 5A (25W max)
- Touchscreen: 5V @ 500mA (2.5W)
- Peripherals: ~1A total
- **Total:** ~6.5A @ 5V = 32.5W

### **DC-DC Converter Selection:**
- Input: 9-36V (car battery range)
- Output: 5V @ 5A minimum (7A recommended)
- Features: Over-voltage, over-current, reverse polarity protection
- Efficiency: >85%

### **Ignition Sensing (Optional):**
```python
# Auto-shutdown on ignition off
import RPi.GPIO as GPIO
import subprocess

IGNITION_PIN = 23
GPIO.setmode(GPIO.BCM)
GPIO.setup(IGNITION_PIN, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

def ignition_callback(channel):
    if not GPIO.input(IGNITION_PIN):  # Ignition OFF
        subprocess.run(["sudo", "shutdown", "-h", "now"])

GPIO.add_event_detect(IGNITION_PIN, GPIO.FALLING, 
                      callback=ignition_callback, bouncetime=5000)
```

---

## 🛡️ **Safety & Noise Reduction**

### **Electrical Safety:**
1. ✅ **Always use inline fuse** (10A recommended)
2. ✅ **Never connect directly to battery** - use switched 12V
3. ✅ **Proper grounding** - connect to chassis ground
4. ✅ **Reverse polarity protection** - use diode or protected converter
5. ✅ **Strain relief** - secure all cables

### **Noise Reduction (CAN Bus):**
```
📌 Use twisted pair wires for CAN-H/CAN-L
📌 Keep CAN wires <3m length
📌 Add 120Ω termination resistor if needed
📌 Shield wires from ignition coils & alternator
📌 Use ferrite beads on power cables
```

### **Thermal Management:**
- Raspberry Pi 5 can reach 80°C+
- Install heatsink + fan (mandatory for car use)
- Enable fan PWM control:
```python
# /usr/local/bin/fan_control.py
import RPi.GPIO as GPIO
import time

FAN_PIN = 22
GPIO.setmode(GPIO.BCM)
GPIO.setup(FAN_PIN, GPIO.OUT)
fan = GPIO.PWM(FAN_PIN, 25)  # 25 Hz

def get_temp():
    with open('/sys/class/thermal/thermal_zone0/temp') as f:
        return int(f.read()) / 1000

while True:
    temp = get_temp()
    if temp > 70:
        fan.start(100)  # Full speed
    elif temp > 60:
        fan.start(70)   # 70% speed
    elif temp > 50:
        fan.start(40)   # 40% speed
    else:
        fan.stop()
    time.sleep(5)
```

---

## 🚀 **Future Expansions**

### **ADAS Integration:**
- Add ultrasonic sensors (HC-SR04) for parking assist
- Camera + OpenCV for lane detection
- Radar module for blind spot monitoring

### **Smart Home Integration:**
- MQTT client for home automation
- Garage door opener (GPIO relay)
- Home security notifications

### **Additional Sensors:**
- BME280: Temperature, humidity, pressure
- MPU6050: Accelerometer, gyroscope (driving behavior)
- Light sensor: Auto display brightness

---

## 📞 **Support & Resources**

- **Schematic:** See `/hardware/schematics/` (future)
- **3D Models:** See `/hardware/3d-models/` (future)
- **Community:** [Discord](#) / [Forum](#)
- **Issues:** [GitHub Issues](https://github.com/yourusername/PiDriveSmartOS/issues)

---

**⚠️ Disclaimer:** Working with vehicle electronics can void warranties. Consult a professional if unsure. Always prioritize safety.

**Last Updated:** 2025-10-28 | **Version:** 1.0
