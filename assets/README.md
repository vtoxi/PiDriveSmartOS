# PiDriveSmartOS Assets

This directory contains all visual assets, branding materials, and media files for the PiDriveSmartOS project.

## Directory Structure

```
assets/
├── branding/           # Brand identity assets
│   ├── logos/          # Logo files (SVG, PNG)
│   └── icons/          # Icon sets (system, nav, media, vehicle, status)
├── fonts/              # Custom fonts (Inter, Roboto Mono)
├── mockups/            # UI design mockups and screenshots
└── screenshots/        # Application screenshots for documentation
```

## Contents

### `/branding/logos/`
Logo files in various formats and variants:
- `logo-full-color.svg` - Primary full-color logo
- `logo-monochrome-black.svg` - Black logo for light backgrounds
- `logo-monochrome-white.svg` - White logo for dark backgrounds
- `logo-icon-only.svg` - Icon-only variant
- `logo-horizontal-lockup.svg` - Logo with wordmark (horizontal)
- `app-icon-512.png` - App launcher icon (512x512)
- `app-icon-1024.png` - High-res app icon (1024x1024)
- `favicon.ico` - Website favicon

### `/branding/icons/`
Icon sets organized by category:

#### System Icons (32x32px)
- Dashboard, Settings, Info, Warning, Error icons

#### Navigation Icons (48x48px)
- Home, Media, OBD, Map, Phone icons

#### Media Icons (24x24px)
- Play, Pause, Next, Previous, Volume, Shuffle icons

#### Vehicle Icons (32x32px)
- Speedometer, RPM, Fuel, Temperature, Tire, Engine icons

#### Status Icons (24x24px)
- WiFi, Bluetooth, GPS, LTE, Battery icons

**Format:** SVG (vector) with PNG exports at 1x, 2x, 3x for different screen densities.

### `/fonts/`
Custom typefaces for the UI:

- **Inter** (Variable font or separate weights: Regular 400, Medium 500, SemiBold 600, Bold 700)
  - `Inter-Regular.ttf`
  - `Inter-Medium.ttf`
  - `Inter-SemiBold.ttf`
  - `Inter-Bold.ttf`

- **Roboto Mono** (For data display: Regular 400, Medium 500)
  - `RobotoMono-Regular.ttf`
  - `RobotoMono-Medium.ttf`

**License:** Both Inter and Roboto Mono are open-source (SIL Open Font License).

**Download Sources:**
- Inter: https://fonts.google.com/specimen/Inter
- Roboto Mono: https://fonts.google.com/specimen/Roboto+Mono

### `/mockups/`
UI design mockups and concept art:

- `logo-concept1.svg` - Pi Drive Ring logo concept
- `logo-concept2.svg` - Smart Road logo concept
- `logo-concept3.svg` - Modular Hex logo concept
- `dashboard-light.png` - Dashboard in day mode
- `dashboard-dark.png` - Dashboard in night mode
- `media-player.png` - Media player interface
- `obd-diagnostics.png` - OBD diagnostics screen
- `hud-overlay.png` - HUD overlay demonstration
- `component-button.png` - Button component showcase
- `component-gauge.png` - Gauge component showcase
- `component-card.png` - Card component showcase

### `/screenshots/`
Actual application screenshots for documentation:

- `dashboard-preview.png` - Main dashboard screenshot
- `settings-screen.png` - Settings interface
- `vehicle-diagnostics.png` - Vehicle page
- `media-player-active.png` - Media player with content
- `github-social-preview.png` - Social media preview card (1280x640)
- `hardware-setup.jpg` - Physical hardware assembly photo

## Usage Guidelines

### In QML Applications

To use assets in QML, reference them via the Qt resource system:

```qml
Image {
    source: "qrc:/assets/branding/logos/logo-full-color.svg"
}
```

Make sure to add assets to `qml.qrc` or create a separate `assets.qrc`:

```xml
<RCC>
    <qresource prefix="/">
        <file>assets/branding/logos/logo-full-color.svg</file>
        <!-- ... more files ... -->
    </qresource>
</RCC>
```

### Font Loading

To load custom fonts in QML:

```qml
FontLoader {
    id: interFont
    source: "qrc:/assets/fonts/Inter-Regular.ttf"
}

Text {
    font.family: interFont.name
    text: "Hello PiDriveSmartOS"
}
```

Or use the Theme.qml singleton:

```qml
Text {
    font.family: Theme.fonts.primary  // "Inter"
}
```

### In Documentation

Reference screenshots in Markdown:

```markdown
![Dashboard Preview](../assets/screenshots/dashboard-preview.png)
```

## Asset Creation Guidelines

### Logo Files
- Always provide SVG (vector) for scalability
- Export PNG at multiple resolutions: 256, 512, 1024px
- Maintain transparent backgrounds for overlays
- Follow brand color guidelines (see `/docs/visual-branding.md`)

### Icons
- Use consistent stroke width (2px for 24px icons)
- 24x24px grid with 2px padding = 20px safe area
- Export as SVG with `fill="currentColor"` for easy theming
- Provide PNG fallbacks for older systems

### Screenshots
- Capture at 1920x1080 (Full HD) minimum
- Use realistic data, avoid placeholders
- Demonstrate both day and night modes
- Annotate if showing tutorial/guide content

### Fonts
- Only include fonts with open-source licenses
- Include full character sets (Latin, numbers, symbols)
- Provide WOFF/WOFF2 for web use if needed
- Document font licenses in `LICENSE_FONTS.md`

## Contributing Assets

When contributing new assets:

1. Follow the directory structure above
2. Use descriptive, lowercase, hyphenated filenames (e.g., `dashboard-night-mode.png`)
3. Optimize file sizes:
   - SVG: minify and remove unnecessary metadata
   - PNG: compress with tools like `pngquant` or `optipng`
   - JPG: use 80-90% quality, progressive encoding
4. Update this README with new asset descriptions
5. Ensure assets follow brand guidelines

## Asset Optimization Commands

```bash
# Optimize PNGs
optipng -o7 assets/**/*.png

# Optimize JPEGs
jpegoptim --max=85 assets/**/*.jpg

# Minify SVGs
svgo assets/**/*.svg

# Batch convert SVG to PNG at multiple sizes
for svg in assets/branding/logos/*.svg; do
    inkscape "$svg" --export-png="${svg%.svg}-512.png" -w 512 -h 512
done
```

## License

- **Code/Configuration Assets:** Apache 2.0 (see `/LICENSE`)
- **Design Assets (Logos, Mockups):** CC BY 4.0 (Attribution required)
- **Fonts:** SIL Open Font License (Inter, Roboto Mono)
- **Screenshots:** CC BY 4.0

---

For detailed brand guidelines, see `/docs/visual-branding.md`.

For UI design specifications, see `/docs/ui-design.md`.

