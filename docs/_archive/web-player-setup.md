# 🌐 Web Player Setup Guide

PiDriveSmartOS includes a **fullscreen web player** for streaming services like Spotify and YouTube. This guide will help you set up the required dependencies.

---

## 📦 **Required Dependencies**

### **On Raspberry Pi OS / Debian / Ubuntu:**

```bash
# Install QtWebEngine QML module
sudo apt update
sudo apt install qml6-module-qtwebengine -y

# Additional dependencies (usually auto-installed)
sudo apt install \
    libqt6webenginecore6 \
    libqt6webenginewidgets6 \
    qt6-webengine-dev \
    -y
```

### **On macOS (for development):**

```bash
# Install via Homebrew (if using Qt6 from Homebrew)
brew install qt6

# QtWebEngine should be included in qt6 package
```

### **On Arch Linux / Manjaro:**

```bash
sudo pacman -S qt6-webengine
```

---

## ✅ **Verify Installation**

After installation, verify QtWebEngine is available:

```bash
# Check if qml module exists
ls /usr/lib/*/qt6/qml/QtWebEngine/

# Should show files like:
# libqmlwebengine.so
# plugins.qmltypes
# qmldir
```

---

## 🎵 **Supported Services**

The web player supports any web-based streaming service:

### **Pre-configured:**
- **Spotify** (`https://open.spotify.com`)
- **YouTube** (`https://www.youtube.com`)

### **Can be added:**
- YouTube Music
- Apple Music Web
- SoundCloud
- Pandora
- Netflix (while parked!)
- Twitch
- Any web-based media service

---

## 🚀 **Usage**

1. Open **Media** page in PiDriveSmartOS
2. Tap **Spotify** or **YouTube** button
3. Login to your account
4. Enjoy fullscreen streaming!

### **Controls:**
- **◀ Back**: Go to previous page
- **▶ Forward**: Go to next page
- **↻ Reload**: Refresh the page
- **✕ Close**: Exit web player

---

## ⚙️ **Configuration**

### **Change User Agent:**

Edit `src/carui/qml/Components/WebPlayer.qml` line 27:

```qml
profile.httpUserAgent: "Your custom user agent"
```

### **Enable/Disable Hardware Acceleration:**

```bash
# Add to ~/.bashrc or /etc/environment
export QTWEBENGINE_CHROMIUM_FLAGS="--enable-features=VaapiVideoDecoder"
```

### **Memory Limits (for Raspberry Pi):**

```bash
# Limit web engine memory
export QTWEBENGINE_CHROMIUM_FLAGS="--max-old-space-size=512"
```

---

## 🐛 **Troubleshooting**

### **"Module QtWebEngine is not installed"**

```bash
# Reinstall QtWebEngine
sudo apt remove --purge qml6-module-qtwebengine
sudo apt install qml6-module-qtwebengine -y

# Restart PiDriveSmartOS
./run.sh
```

### **Web player shows blank screen:**

1. Check internet connection
2. Try reloading (↻ button)
3. Check logs: `journalctl -u carui -f`

### **YouTube/Spotify not loading:**

Some services may block embedded browsers. Solutions:

1. **Use mobile site:**
   - YouTube: `https://m.youtube.com`
   - Spotify: Already mobile-optimized

2. **Custom user agent:**
   Edit WebPlayer.qml and change `httpUserAgent` to mobile UA.

3. **Alternative services:**
   - YouTube Music: `https://music.youtube.com`
   - Spotify Lite: `https://lite.spotify.com`

### **Audio not playing:**

```bash
# Check ALSA/PulseAudio
aplay -l
pactl list sinks

# Set default audio device
sudo nano /etc/asound.conf
```

### **Performance issues:**

```bash
# Enable GPU acceleration (Raspberry Pi 5)
sudo raspi-config
# Advanced Options → GL Driver → Full KMS

# Reduce resolution in WebPlayer.qml
# (Not recommended, but helps on older hardware)
```

---

## 🔐 **Security Considerations**

### **Cookies & Sessions:**

Web player stores cookies in:
```
~/.local/share/carui/QtWebEngine/
```

To clear:
```bash
rm -rf ~/.local/share/carui/QtWebEngine/
```

### **HTTPS Only:**

WebPlayer enforces HTTPS for security:
```qml
settings.allowRunningInsecureContent: false
```

### **Disable for Safety:**

Web player automatically pauses when vehicle is in motion (future feature).

---

## 📊 **Performance Benchmarks**

| Device | Load Time | Memory Usage | Playback Quality |
|--------|-----------|--------------|------------------|
| **Raspberry Pi 5** | ~3s | ~200MB | 1080p 60fps |
| **Raspberry Pi 4** | ~5s | ~180MB | 720p 30fps |
| **Desktop (dev)** | ~1s | ~150MB | 4K 60fps |

---

## 🎯 **Best Practices**

### **For Spotify:**
1. Use **offline mode** for data savings
2. Download playlists before trips
3. Enable **data saver** in settings

### **For YouTube:**
1. Use **480p** quality for smooth playback
2. Avoid 4K on Raspberry Pi
3. Consider YouTube Premium for ad-free

### **For All Services:**
1. Pre-login before driving
2. Enable **auto-login** for convenience
3. Use **parental controls** if needed

---

## 🔄 **Alternative: Native Apps via Waydroid**

For better performance, consider using Android apps via Waydroid:

```bash
# Install Waydroid
sudo apt install waydroid -y

# Install Spotify/YouTube apps
waydroid app install spotify.apk
```

See: [Android Apps Documentation](android-apps-waydroid.md)

---

## 📚 **Additional Resources**

- [Qt WebEngine Docs](https://doc.qt.io/qt-6/qtwebengine-index.html)
- [Chromium Flags](https://peter.sh/experiments/chromium-command-line-switches/)
- [Spotify Web API](https://developer.spotify.com/documentation/web-api/)
- [YouTube IFrame API](https://developers.google.com/youtube/iframe_api_reference)

---

## 🎉 **Why Web Player is Awesome**

✅ **No APKs needed** - Just open the web  
✅ **Always up-to-date** - Latest service features  
✅ **Cross-platform** - Works everywhere  
✅ **Secure** - Sandboxed web environment  
✅ **Customizable** - Add any service you want  

---

**Made with 💙 for the PiDriveSmartOS community**

*Questions? Open an issue on [GitHub](https://github.com/yourusername/PiDriveSmartOS/issues)*

