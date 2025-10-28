# 🚢 Deployment Guide - PiDriveSmartOS

CI/CD pipelines, OTA updates, security, and production deployment.

---

## 📋 **Table of Contents**

1. [CI/CD Pipeline](#cicd)
2. [Image Building](#image-building)
3. [OTA Updates](#ota)
4. [Security Hardening](#security)
5. [Production Deployment](#production)

---

## ⚙️ **CI/CD Pipeline** {#cicd}

### **GitHub Actions Workflow**

```yaml
# .github/workflows/build.yml
name: Build PiDriveSmartOS

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Install Dependencies
        run: |
          sudo apt update
          sudo apt install -y qt6-base-dev cmake g++-aarch64-linux-gnu
      
      - name: Cross-Compile for ARM64
        run: |
          cd src/carui
          mkdir build && cd build
          cmake -DCMAKE_TOOLCHAIN_FILE=../arm64.cmake ..
          make -j4
      
      - name: Run Tests
        run: |
          cd build
          ctest --output-on-failure
      
      - name: Security Scan
        run: |
          docker run --rm -v $(pwd):/src aquasec/trivy fs /src
      
      - name: Build Image
        run: |
          cd image-builder
          sudo ./build-image.sh
      
      - name: Upload Artifacts
        uses: actions/upload-artifact@v3
        with:
          name: pidrive-image
          path: image-builder/pidrive-smartos-*.img.gz
```

### **Key Stages:**

1. **Lint & Format**: `clang-format`, `pylint`, `qmllint`
2. **Build**: Cross-compile Qt UI + Python services
3. **Test**: Unit tests (C++), integration tests (Python)
4. **Security**: Trivy scan for vulnerabilities
5. **Package**: Create `.img.gz` or `.rauc` bundle
6. **Publish**: GitHub Releases, Docker Hub, S3

---

## 💿 **Image Building** {#image-building}

### **Using `pi-gen` (Recommended for Beginners)**

```bash
# Clone pi-gen
git clone https://github.com/RPi-Distro/pi-gen
cd pi-gen

# Configure
cat > config << EOF
IMG_NAME=pidrive-smartos
RELEASE=bookworm
TARGET_HOSTNAME=pidrive
FIRST_USER_NAME=pidrive
FIRST_USER_PASS=raspberry
ENABLE_SSH=1
EOF

# Add custom stage
mkdir -p stage-pidrive/00-install-carui
cat > stage-pidrive/00-install-carui/00-run.sh << 'SCRIPT'
#!/bin/bash
# Install PiDriveSmartOS
apt-get install -y qt6-base-dev python3-dbus can-utils
git clone https://github.com/yourusername/PiDriveSmartOS.git /opt/pidrive
cd /opt/pidrive/src/carui && mkdir build && cd build && cmake .. && make install
systemctl enable carui
SCRIPT

# Build image
sudo ./build.sh
```

### **Using Yocto (Advanced, for Production)**

```bash
# Clone Yocto
git clone -b kirkstone git://git.yoctoproject.org/poky
cd poky
source oe-init-build-env

# Add meta-raspberrypi layer
git clone -b kirkstone https://github.com/agherzan/meta-raspberrypi
bitbake-layers add-layer ../meta-raspberrypi

# Add custom layer
mkdir -p ../meta-pidrive/recipes-carui
# ... (add recipes for Qt app, services, etc)

# Build
bitbake pidrive-image
```

---

## 🔄 **OTA Updates** {#ota}

### **Using RAUC (Robust Auto-Update Controller)**

#### **System Setup (A/B Partitions):**

```
/dev/mmcblk0p1  → /boot (shared)
/dev/mmcblk0p2  → rootfs.0 (Slot A)
/dev/mmcblk0p3  → rootfs.1 (Slot B)
/dev/mmcblk0p4  → /data (persistent)
```

#### **RAUC Configuration:**

```ini
# /etc/rauc/system.conf
[system]
compatible=pidrive-smartos
bootloader=u-boot

[keyring]
path=/etc/rauc/ca.cert.pem

[slot.rootfs.0]
device=/dev/mmcblk0p2
type=ext4
bootname=A

[slot.rootfs.1]
device=/dev/mmcblk0p3
type=ext4
bootname=B
```

#### **Create Update Bundle:**

```bash
# Create bundle manifest
cat > manifest.raucm << EOF
[update]
compatible=pidrive-smartos
version=0.9.1

[image.rootfs]
filename=rootfs.img
EOF

# Sign and bundle
rauc bundle \
  --cert=release.cert.pem \
  --key=release.key.pem \
  manifest.raucm \
  pidrive-smartos-0.9.1.raucb
```

#### **Install Update (Locally or Over-the-Air):**

```bash
# Local install
rauc install pidrive-smartos-0.9.1.raucb

# Remote install (via HTTP)
rauc install http://updates.pidrive.com/latest.raucb

# Check status
rauc status

# Rollback (if boot fails 3x, automatic)
# Or manual:
rauc status mark-bad && reboot
```

### **Using Mender (Alternative)**

```bash
# Install Mender client
wget https://downloads.mender.io/mender-client_latest_armhf.deb
sudo dpkg -i mender-client_latest_armhf.deb

# Configure
sudo nano /etc/mender/mender.conf
{
  "ServerURL": "https://hosted.mender.io",
  "TenantToken": "YOUR_TOKEN"
}

# Enable
sudo systemctl enable mender-client
sudo systemctl start mender-client
```

---

## 🛡️ **Security Hardening** {#security}

### **1. Developer Mode Toggle (GPIO 17)**

```bash
# /usr/local/bin/check_dev_mode.sh
#!/bin/bash
if [ $(cat /sys/class/gpio/gpio17/value) -eq 1 ]; then
    # Developer mode: Enable SSH, full OS
    systemctl start ssh
    mount -o remount,rw /
else
    # Car mode: Kiosk only, read-only root
    systemctl stop ssh
    mount -o remount,ro /
fi
```

### **2. Read-Only Root Filesystem**

```bash
# /etc/fstab
/dev/mmcblk0p2  /     ext4  ro,defaults  0  1
/dev/mmcblk0p4  /data ext4  rw,defaults  0  2
tmpfs           /tmp  tmpfs nodev,nosuid 0  0
tmpfs           /var/log tmpfs nodev,nosuid 0 0
```

### **3. CAN Bus Safety**

```python
# obd_daemon.py
SAFE_PIDS = [0x0C, 0x0D, 0x05, 0x0F]  # Read-only PIDs
BLOCKED_PIDS = [0x01, 0x02, 0x03]     # Actuator control (DANGEROUS)

def send_obd_command(pid):
    if pid in BLOCKED_PIDS:
        raise SecurityError("PID blocked for safety")
    # ... send command
```

### **4. OTA Update Signing**

```bash
# Generate key pair
openssl genrsa -out release.key.pem 4096
openssl req -new -x509 -key release.key.pem -out release.cert.pem

# Store private key securely (GitHub Secrets, AWS KMS, etc)
# Public key → /etc/rauc/ca.cert.pem on device
```

### **5. Firewall (UFW)**

```bash
sudo apt install ufw
sudo ufw default deny incoming
sudo ufw allow 22/tcp     # SSH (developer mode only)
sudo ufw allow 5555/tcp   # Waydroid (localhost only)
sudo ufw enable
```

---

## 🚀 **Production Deployment** {#production}

### **Pre-Production Checklist:**

- [ ] Remove default passwords (`pidrive:raspberry`)
- [ ] Disable SSH in car mode
- [ ] Enable read-only root
- [ ] Sign OTA updates
- [ ] Test A/B partition rollback
- [ ] Configure WiFi/LTE for OTA
- [ ] Set up monitoring (syslog → cloud)
- [ ] Backup `/data` partition strategy
- [ ] Test CAN bus isolation (no write PIDs)
- [ ] Validate GPS accuracy
- [ ] Test emergency shutdown (ignition off)

### **systemd Service (Auto-Start on Boot):**

```ini
# /etc/systemd/system/carui.service
[Unit]
Description=PiDriveSmartOS Car UI
After=network.target obdsvc.service

[Service]
Type=simple
User=pidrive
Environment="QT_QPA_PLATFORM=eglfs"
Environment="QT_QPA_EGLFS_KMS_CONFIG=/opt/pidrive/config/kms.json"
ExecStart=/opt/pidrive/bin/carui
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

### **Monitoring & Logging:**

```bash
# Centralized logging (syslog to cloud)
sudo apt install rsyslog
echo "*.* @@logs.pidrive.com:514" >> /etc/rsyslog.conf

# Systemd journal
journalctl -u carui -f

# CAN bus logging
candump -l can0
```

---

## 📞 **Support**

- **Issues**: [GitHub Issues](https://github.com/yourusername/PiDriveSmartOS/issues)
- **Security**: security@pidrive.com
- **Docs**: [Full Documentation](../README.md)

---

**Last Updated:** 2025-10-28 | **Version:** 2.0 (Consolidated)
