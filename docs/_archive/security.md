# Security

> Security architecture, threat model, and hardening guidelines for PiDriveSmartOS

---

## Table of Contents

- [Security Overview](#security-overview)
- [Threat Model](#threat-model)
- [Developer Mode Security](#developer-mode-security)
- [Read-Only Root Filesystem](#read-only-root-filesystem)
- [CAN Bus Safety](#can-bus-safety)
- [OTA Update Security](#ota-update-security)
- [Network Security](#network-security)
- [User Privilege Separation](#user-privilege-separation)
- [Secure Boot](#secure-boot)
- [Hardening Checklist](#hardening-checklist)

---

## Security Overview

PiDriveSmartOS implements **defense-in-depth** security:

```
┌─────────────────────────────────────────────────┐
│  Layer 6: Application Security                  │
│  • Input validation                             │
│  • Sandboxed WebEngine                          │
├─────────────────────────────────────────────────┤
│  Layer 5: Access Control                        │
│  • Developer mode PIN                           │
│  • User privilege separation                    │
├─────────────────────────────────────────────────┤
│  Layer 4: Service Isolation                     │
│  • Systemd sandboxing                           │
│  • DBus permissions                             │
├─────────────────────────────────────────────────┤
│  Layer 3: Filesystem Protection                 │
│  • Read-only root (overlayfs)                   │
│  • Encrypted /home (LUKS)                       │
├─────────────────────────────────────────────────┤
│  Layer 2: Network Security                      │
│  • Firewall (nftables)                          │
│  • SSH key-only auth                            │
├─────────────────────────────────────────────────┤
│  Layer 1: Hardware Security                     │
│  • Secure Boot (U-Boot + verified kernel)       │
│  • CAN bus isolation                            │
└─────────────────────────────────────────────────┘
```

### Security Principles

1. **Least Privilege**: Services run with minimal permissions
2. **Fail-Safe Defaults**: Secure by default, requires explicit enabling
3. **Defense in Depth**: Multiple security layers
4. **Transparency**: Security features are documented and auditable

---

## Threat Model

### Threat Actors

| Actor | Capability | Motivation | Risk Level |
|-------|------------|------------|------------|
| **Opportunistic Attacker** | Network scan, exploit public vulnerabilities | Data theft, malware | 🟡 Medium |
| **Malicious Passenger** | Physical access, USB insertion | Tampering, data exfiltration | 🟠 High |
| **Advanced Attacker** | Reverse engineering, CAN bus injection | Vehicle control, espionage | 🔴 Critical |

### Attack Vectors

1. **Network Attacks**
   - Wi-Fi man-in-the-middle
   - Malicious OTA updates
   - Web exploit via browser

2. **Physical Access**
   - USB drive with malware
   - SD card replacement
   - Direct hardware tampering

3. **CAN Bus Attacks**
   - Message injection
   - Denial of service
   - Replay attacks

4. **Social Engineering**
   - Phishing for developer PIN
   - Malicious QR code scan

### Assets to Protect

- **Vehicle Control**: CAN bus must not allow unauthorized commands
- **User Data**: GPS history, media preferences, credentials
- **System Integrity**: No unauthorized code execution
- **Availability**: System must remain operational under attack

---

## Developer Mode Security

### Why Developer Mode Matters

In **Car Mode**:
- Read-only filesystem
- SSH disabled
- No root access
- Limited attack surface

In **Developer Mode**:
- Read-write filesystem
- SSH enabled
- Root access possible
- Full attack surface

**Key Risk**: Unauthorized developer mode activation = full system compromise

### PIN Protection

**Default PIN**: `1234` (must be changed on first boot)

**PIN Requirements**:
- 4-8 digits
- Stored as bcrypt hash
- 3 failed attempts → 30 minute lockout
- Logged to `/var/log/auth.log`

#### PIN Storage

```bash
# /etc/pidrive/devmode.pin
$2b$12$KIX8F9rF5vG.zZ8v5vG.zZ8v5vG.zZ8v5vG.zZ8v5vG.zZ8v5vG.z
```

#### PIN Verification Code

```python
# /opt/pidrive/bin/verify_pin.py
import bcrypt
import time

MAX_ATTEMPTS = 3
LOCKOUT_TIME = 1800  # 30 minutes

def verify_pin(input_pin):
    with open('/etc/pidrive/devmode.pin', 'rb') as f:
        stored_hash = f.read()
    
    if bcrypt.checkpw(input_pin.encode(), stored_hash):
        return True
    
    # Track failed attempts
    attempts = get_failed_attempts()
    if attempts >= MAX_ATTEMPTS:
        if time.time() - get_lockout_start() < LOCKOUT_TIME:
            raise Exception("Account locked. Try again later.")
        else:
            reset_failed_attempts()
    
    increment_failed_attempts()
    return False
```

### Toggle Methods

#### Method 1: UI Gesture (Recommended)

1. Tap and hold **Settings icon** for 10 seconds
2. Enter PIN
3. Confirm "Enable Developer Mode"
4. System reboots into Developer Mode

#### Method 2: Config File

```bash
# Boot partition is always writable (FAT32)
sudo mount /boot/firmware -o remount,rw
echo "car_mode=0" | sudo tee /boot/firmware/devmode.cfg
sudo reboot
```

#### Method 3: GPIO Switch (Physical)

```
GPIO 17 ───┐
           ├─── Toggle Switch
GND ───────┘

Switch CLOSED → Developer Mode
Switch OPEN → Car Mode
```

Python GPIO check:

```python
import RPi.GPIO as GPIO

DEV_MODE_PIN = 17
GPIO.setmode(GPIO.BCM)
GPIO.setup(DEV_MODE_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

if GPIO.input(DEV_MODE_PIN) == GPIO.LOW:
    enable_developer_mode()
else:
    enable_car_mode()
```

---

## Read-Only Root Filesystem

### Why Read-Only?

- **Malware Protection**: Cannot modify system files
- **SD Card Longevity**: Reduced wear from writes
- **Crash Resilience**: Power loss doesn't corrupt filesystem

### Implementation: overlayfs

```
┌──────────────────────────────────────────┐
│           User View: /                   │
├──────────────────────────────────────────┤
│          overlayfs (union mount)         │
├─────────────────┬────────────────────────┤
│  Upper Layer    │    Lower Layer         │
│  (tmpfs)        │    (read-only squashfs)│
│  Changes here   │    Base system         │
└─────────────────┴────────────────────────┘
```

**Configuration** (`/etc/fstab`):

```bash
# Read-only base
/dev/mmcblk0p2  /ro  squashfs  ro,noatime  0  0

# Writable overlay (tmpfs, lost on reboot)
tmpfs  /rw  tmpfs  nodev,nosuid  0  0

# Union mount
overlay  /  overlay  lowerdir=/ro,upperdir=/rw/upper,workdir=/rw/work  0  0
```

**Writable Directories** (bind mounts):

```bash
/var/log → /data/log
/var/lib/pidrive → /data/pidrive
/home/pidrive → /data/home
```

### Persistent Storage

Only `/data` partition is writable (ext4):

```
/dev/mmcblk0p1  /boot/firmware  vfat  ro  0  2
/dev/mmcblk0p2  /ro             squashfs  ro  0  0
/dev/mmcblk0p3  /data           ext4  rw,noatime  0  1
```

---

## CAN Bus Safety

### CAN Bus Threat Model

**Attack Scenarios**:
1. **Message Injection**: Send fake speed/RPM data → UI shows wrong info
2. **Command Injection**: Send brake/steering commands (if ECU allows)
3. **DoS**: Flood CAN bus with messages
4. **Replay Attack**: Record and replay valid messages

### Mitigation Strategies

#### 1. Read-Only CAN Interface (Default)

```python
# OBD service is READ-ONLY by design
# Only listens, never sends commands (except standard OBD queries)

bus = can.interface.Bus(channel='can0', bustype='socketcan', receive_own_messages=False)

for msg in bus:
    if msg.arbitration_id in ALLOWED_PID_IDS:
        process_message(msg)
    else:
        log_warning(f"Unexpected CAN ID: {msg.arbitration_id}")
```

#### 2. CAN Message Filtering

```bash
# SocketCAN filters (kernel-level)
sudo ip link set can0 type can bitrate 500000
sudo canbusload can0@500000 -r  # Read-only mode

# Filter only OBD-II PIDs (0x7E0-0x7EF)
sudo candump can0,7E0:7F0 -L  # Log only OBD range
```

#### 3. Isolated CAN Transceiver

Use **optocoupler-isolated** CAN module:
- Galvanic isolation between Pi and vehicle CAN bus
- Protects Pi from electrical faults
- Prevents Pi ground loops affecting vehicle

**Recommended Module**: Waveshare Isolated CAN HAT

#### 4. CAN IDS (Intrusion Detection)

```python
# Anomaly detection
from collections import defaultdict
import time

message_rates = defaultdict(list)
RATE_LIMIT = 100  # messages per second

def check_can_ids(msg):
    now = time.time()
    message_rates[msg.arbitration_id].append(now)
    
    # Remove old messages (>1 second ago)
    message_rates[msg.arbitration_id] = [
        t for t in message_rates[msg.arbitration_id] if now - t < 1.0
    ]
    
    if len(message_rates[msg.arbitration_id]) > RATE_LIMIT:
        raise SecurityException(f"CAN DoS detected on ID {msg.arbitration_id:X}")
```

#### 5. No Write Access in Car Mode

```bash
# systemd service isolation
[Service]
Type=simple
User=obduser
Group=can
ReadOnlyPaths=/dev/can0
ProtectSystem=strict
NoNewPrivileges=true
```

### Vehicle Command Restrictions

**NEVER IMPLEMENTED**:
- ❌ Steering control
- ❌ Brake control
- ❌ Throttle control
- ❌ Transmission control

**Allowed OBD-II Queries**:
- ✅ Read speed, RPM, temperature
- ✅ Read DTCs (diagnostic trouble codes)
- ✅ Clear DTCs (only with user confirmation)
- ✅ Read VIN, fuel level

---

## OTA Update Security

### Update Architecture

```
Update Server (HTTPS)
        │
        ├─── Signed bundle (.raucb)
        │    └─── X.509 certificate chain
        ↓
Raspberry Pi (RAUC client)
        │
        ├─── Verify signature
        ├─── Check version (no downgrades)
        ├─── Install to inactive partition
        ├─── Reboot and test
        └─── Rollback if failed
```

### Signing Updates

```bash
# Generate signing key (keep OFFLINE)
openssl genrsa -aes256 -out pidrive-signing-key.pem 4096

# Create certificate
openssl req -new -x509 -key pidrive-signing-key.pem -out pidrive-cert.pem -days 3650

# Sign update bundle
rauc bundle \
    --cert pidrive-cert.pem \
    --key pidrive-signing-key.pem \
    update/ \
    pidriveos-v1.2.raucb
```

### RAUC Configuration

**`/etc/rauc/system.conf`**:

```ini
[system]
compatible=pidriveos-rpi5
bootloader=uboot
mountprefix=/mnt/rauc

[keyring]
path=/etc/rauc/keyring.pem  # Public cert only

[slot.rootfs.0]
device=/dev/mmcblk0p2
type=ext4
bootname=A

[slot.rootfs.1]
device=/dev/mmcblk0p3
type=ext4
bootname=B
```

### Update Verification Steps

1. **Download**: HTTPS with certificate pinning
2. **Signature Check**: X.509 certificate chain validation
3. **Version Check**: Prevent downgrade attacks
4. **Partition Check**: Install to inactive partition
5. **Test Boot**: 5-minute watchdog (rollback if fail)
6. **Mark Good**: Only after successful operation

### Update Rollback

```bash
# If new version crashes, U-Boot automatically boots old partition

# Manual rollback
sudo rauc status mark-bad booted
sudo reboot
```

---

## Network Security

### Firewall Rules (nftables)

**Car Mode** (restrictive):

```bash
# /etc/nftables.conf
table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        
        # Allow loopback
        iif lo accept
        
        # Allow established connections
        ct state established,related accept
        
        # Allow DHCP, DNS
        udp dport { 67, 68, 53 } accept
        
        # Allow gpsd (localhost only)
        ip saddr 127.0.0.1 tcp dport 2947 accept
        
        # DENY SSH
        tcp dport 22 drop
        
        # Allow WebSocket API (authenticated)
        tcp dport 9000 accept
    }
    
    chain forward {
        type filter hook forward priority 0; policy drop;
    }
    
    chain output {
        type filter hook output priority 0; policy accept;
    }
}
```

**Developer Mode** (permissive):

```bash
# Allow SSH
tcp dport 22 accept

# Allow VNC (optional)
tcp dport 5900 accept
```

### SSH Hardening

**`/etc/ssh/sshd_config`** (Developer Mode only):

```bash
# Disable password auth (keys only)
PasswordAuthentication no
PubkeyAuthentication yes

# Disable root login
PermitRootLogin no

# Only allow specific user
AllowUsers pidrive

# Change port (optional)
Port 2222

# Use strong key exchange
KexAlgorithms curve25519-sha256@libssh.org
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com
```

### Wi-Fi Security

**Disable AP mode** (default):
- Only connect to known networks (WPA2/WPA3)
- Disable WPS
- Use MAC filtering (optional)

**Optional**: Create Wi-Fi hotspot for phone connection (secure password).

---

## User Privilege Separation

### User Accounts

| User | UID | Home | Shell | Purpose |
|------|-----|------|-------|---------|
| `root` | 0 | /root | /bin/bash | System admin (dev mode only) |
| `pidrive` | 1000 | /home/pidrive | /bin/bash | Primary user (carui) |
| `obduser` | 1001 | /var/lib/obd | /usr/sbin/nologin | OBD service |
| `gpsuser` | 1002 | /var/lib/gps | /usr/sbin/nologin | GPS daemon |

### Systemd Service Sandboxing

**`/etc/systemd/system/obdsvc.service`**:

```ini
[Service]
Type=simple
User=obduser
Group=can

# Filesystem isolation
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/var/log/pidrive /var/lib/pidrive
PrivateTmp=true

# Network isolation (only local DBus)
PrivateNetwork=false
RestrictAddressFamilies=AF_UNIX AF_INET

# Kernel isolation
NoNewPrivileges=true
ProtectKernelModules=true
ProtectKernelTunables=true
ProtectControlGroups=true

# Capabilities (minimal)
CapabilityBoundingSet=CAP_NET_RAW
AmbientCapabilities=CAP_NET_RAW

# Resource limits
MemoryLimit=256M
CPUQuota=50%
```

### File Permissions

```bash
# Application binaries (root-owned, executable by all)
/opt/pidrive/bin/carui                    root:root    755

# Configuration files (read-only for users)
/etc/pidrive/carui.conf                   root:pidrive 644

# Sensitive configs (root only)
/etc/pidrive/devmode.pin                  root:root    600
/boot/firmware/devmode.cfg                root:root    600

# Service data (owned by service user)
/var/lib/pidrive/obd/                     obduser:can  750

# Logs (append-only)
/var/log/pidrive/obd.log                  obduser:adm  640
```

---

## Secure Boot

### U-Boot Verified Boot

**Goal**: Ensure only signed kernels can boot

#### Generate Boot Keys

```bash
# Generate signing key
openssl genrsa -F4 -out keys/dev.key 2048
openssl req -batch -new -x509 -key keys/dev.key -out keys/dev.crt

# Create FIT image (Flattened Image Tree)
mkimage -f kernel.its kernel.itb

# Sign image
mkimage -F -k keys -K u-boot.dtb -r kernel.itb
```

**`kernel.its`** (FIT image description):

```its
/dts-v1/;

/ {
    description = "PiDriveSmartOS Kernel";
    #address-cells = <1>;
    
    images {
        kernel {
            data = /incbin/("./Image");
            type = "kernel";
            arch = "arm64";
            os = "linux";
            compression = "none";
            load = <0x80000>;
            entry = <0x80000>;
            hash {
                algo = "sha256";
            };
        };
        
        fdt {
            data = /incbin/("./bcm2712-rpi-5-b.dtb");
            type = "flat_dt";
            arch = "arm64";
            compression = "none";
            hash {
                algo = "sha256";
            };
        };
    };
    
    configurations {
        default = "config-1";
        config-1 {
            description = "Boot Config";
            kernel = "kernel";
            fdt = "fdt";
            signature {
                algo = "sha256,rsa2048";
                key-name-hint = "dev";
                sign-images = "fdt", "kernel";
            };
        };
    };
};
```

### TPM Integration (Optional)

For production systems, use **TPM 2.0** module:
- Store boot keys in TPM
- Measured boot (PCR extension)
- Sealed disk encryption keys

---

## Hardening Checklist

### Pre-Deployment

- [ ] Change default PIN from `1234`
- [ ] Disable unused services (`bluetooth.service` if not needed)
- [ ] Enable read-only root filesystem
- [ ] Configure firewall (nftables)
- [ ] Disable SSH in Car Mode
- [ ] Set up SSH key-based auth (disable passwords)
- [ ] Install signed kernel (secure boot)
- [ ] Configure RAUC for OTA updates
- [ ] Enable systemd service sandboxing
- [ ] Test CAN bus isolation
- [ ] Encrypt `/home` partition (LUKS)
- [ ] Set up audit logging (`auditd`)
- [ ] Disable unnecessary kernel modules
- [ ] Configure AppArmor/SELinux profiles (optional)

### Runtime Monitoring

```bash
# Check for failed login attempts
sudo journalctl -u ssh | grep "Failed password"

# Monitor CAN bus
candump can0 -L | tee /var/log/pidrive/can.log

# Check OTA update status
sudo rauc status

# View service restrictions
systemd-analyze security obdsvc.service
```

### Incident Response

1. **Suspected Compromise**:
   - Power off system immediately
   - Extract SD card for forensic analysis
   - Review logs: `/var/log/pidrive/`, `journalctl`
   - Check `/rw/upper` for unauthorized changes

2. **Factory Reset**:
   ```bash
   sudo rm -rf /data/*
   sudo reboot
   ```

3. **Emergency Recovery**:
   - Boot from USB recovery image
   - Mount SD card and inspect
   - Reflash OS if necessary

---

## Security Updates

### Update Policy

- **Critical**: Within 24 hours (CVE with active exploits)
- **High**: Within 7 days
- **Medium**: Within 30 days
- **Low**: Next regular release

### Vulnerability Reporting

**Email**: security@pidriveos.org
**PGP Key**: [keybase.io/pidriveos](https://keybase.io/pidriveos)

**Bug Bounty**:
- Critical (RCE, CAN injection): $500
- High (privilege escalation): $250
- Medium (info disclosure): $100

---

## Compliance and Standards

### Automotive Standards

- **ISO 26262**: Functional safety (ASIL-B recommended)
- **SAE J3061**: Cybersecurity guidebook for cyber-physical vehicles
- **UNECE WP.29**: UN regulation on cybersecurity

### Best Practices

- Follow **OWASP Embedded Application Security**
- Implement **NIST Cybersecurity Framework**
- Adhere to **CIS Benchmarks** for Linux hardening

---

## Conclusion

Security in automotive systems is **critical**. PiDriveSmartOS implements multiple layers of defense:

✅ **Developer mode protection** prevents unauthorized access  
✅ **Read-only filesystem** stops malware installation  
✅ **CAN bus isolation** prevents vehicle control exploits  
✅ **Signed OTA updates** ensure authentic software  
✅ **Network firewall** limits attack surface  

**Remember**: Security is a process, not a product. Regular updates and monitoring are essential.

**Next Steps**:
- Review [architecture.md](architecture.md) for system design
- See [roadmap.md](roadmap.md) for future security features
- Check [hardware.md](hardware.md) for isolated CAN setup

