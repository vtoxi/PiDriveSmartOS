# 🎨 PiDriveSmartOS Visual Branding & Design System

**Version:** 1.0.0  
**Last Updated:** October 2025  
**Status:** Production Ready

---

## Table of Contents

1. [Brand Identity](#1-brand-identity)
2. [Color System](#2-color-system)
3. [Typography](#3-typography)
4. [Logo Design Directions](#4-logo-design-directions)
5. [UI Design Language](#5-ui-design-language)
6. [Brand Usage Guide](#6-brand-usage-guide)
7. [Exportable Assets](#7-exportable-assets)
8. [Implementation Checklist](#implementation-checklist)

---

## 1. Brand Identity

### Core Concept

**PiDriveSmartOS** represents the convergence of open-source innovation and automotive excellence. It bridges the gap between maker culture and professional-grade automotive systems, delivering a platform that is:

- **Accessible** to hobbyists and developers
- **Reliable** for real-world driving scenarios
- **Extensible** through modular architecture
- **Safe** with driver-centric UX design

### Brand Personality

| Attribute | Description |
|-----------|-------------|
| **Modern** | Cutting-edge technology with contemporary UI patterns |
| **Intelligent** | Data-driven, predictive, context-aware |
| **Connected** | Seamless integration across devices and services |
| **Safe** | Driver-first design, minimizing distraction |
| **Open** | Transparent, community-driven, hackable |
| **Reliable** | Automotive-grade stability and performance |

### Brand Voice & Tone

- **Technical yet approachable** — use clear language, avoid jargon when possible
- **Confident but not arrogant** — we're building something impressive, but stay humble
- **Encouraging** — empower makers and developers to extend the platform
- **Safety-conscious** — always emphasize safe driving practices

### Tagline

> **"Smart driving. Open technology."**

Alternative taglines:
- *"Your car, your code, your way."*
- *"Open-source meets the open road."*
- *"Automotive intelligence, Raspberry Pi power."*

---

## 2. Color System

### Design Philosophy

The PiDriveSmartOS color system is optimized for:
- **High contrast** for outdoor visibility and quick glance-ability
- **Night mode safety** with reduced blue light for nighttime driving
- **Accessibility** meeting WCAG AAA standards where possible
- **Automotive heritage** inspired by modern luxury car interfaces

### 2.1 Day Mode (Light Theme)

#### Primary Colors

```
Brand Primary (Electric Blue)
HEX: #0078D4
RGB: 0, 120, 212
Usage: Primary actions, highlights, active states
Contrast Ratio: 4.6:1 on white (AA compliant)
```

```
Brand Secondary (Deep Charcoal)
HEX: #1E1E1E
RGB: 30, 30, 30
Usage: Text, icons, borders
Contrast Ratio: 16.9:1 on white (AAA compliant)
```

#### Accent Colors

```
Accent Amber (Warning/Attention)
HEX: #FFA500
RGB: 255, 165, 0
Usage: Warnings, check engine light, fuel alerts
Contrast Ratio: 2.6:1 on white (suitable for large text)
```

```
Accent Green (Success/Eco)
HEX: #28A745
RGB: 40, 167, 69
Usage: Success states, eco mode, energy efficiency indicators
Contrast Ratio: 3.2:1 on white
```

```
Accent Red (Critical/Alerts)
HEX: #DC3545
RGB: 220, 53, 69
Usage: Critical warnings, brake warnings, system errors
Contrast Ratio: 4.4:1 on white (AA compliant)
```

#### Background & Surface Colors

```
Background Light
HEX: #F5F5F5
RGB: 245, 245, 245
Usage: Main background, behind cards
```

```
Surface White
HEX: #FFFFFF
RGB: 255, 255, 255
Usage: Cards, panels, modals
```

```
Divider Light
HEX: #E0E0E0
RGB: 224, 224, 224
Usage: Borders, dividers, separators
```

#### Text Colors (Day Mode)

```
Text Primary: #1E1E1E (Charcoal)
Text Secondary: #616161 (Gray)
Text Disabled: #9E9E9E (Light Gray)
Text Inverse: #FFFFFF (White on dark surfaces)
```

---

### 2.2 Night Mode (Dark Theme)

#### Primary Colors

```
Night Primary (Ice Blue)
HEX: #4DB8FF
RGB: 77, 184, 255
Usage: Primary actions, highlights (less intense than day mode)
Contrast Ratio: 7.2:1 on #121212 (AAA compliant)
```

```
Night Secondary (Soft White)
HEX: #E0E0E0
RGB: 224, 224, 224
Usage: Primary text on dark backgrounds
Contrast Ratio: 13.1:1 on #121212 (AAA compliant)
```

#### Accent Colors (Night Mode Variants)

```
Night Amber (Softer)
HEX: #FFB84D
RGB: 255, 184, 77
Usage: Warnings (reduced brightness for night safety)
```

```
Night Green
HEX: #4CAF50
RGB: 76, 175, 80
Usage: Success indicators
```

```
Night Red
HEX: #EF5350
RGB: 239, 83, 80
Usage: Critical alerts (slightly desaturated)
```

#### Background & Surface Colors (Night)

```
Background Dark
HEX: #121212
RGB: 18, 18, 18
Usage: Main background (true dark for OLED)
```

```
Surface Dark
HEX: #1E1E1E
RGB: 30, 30, 30
Usage: Elevated cards, panels
Elevation: +1dp appears as #1E1E1E
Elevation: +2dp appears as #242424
```

```
Divider Dark
HEX: #2C2C2C
RGB: 44, 44, 44
Usage: Subtle dividers
```

#### Text Colors (Night Mode)

```
Text Primary Night: #E0E0E0 (Soft White)
Text Secondary Night: #A0A0A0 (Medium Gray)
Text Disabled Night: #5C5C5C (Dark Gray)
Text Inverse Night: #121212 (Dark on light surfaces)
```

---

### 2.3 Semantic Colors (Both Modes)

| Semantic | Day Mode | Night Mode | Usage |
|----------|----------|------------|-------|
| **Success** | `#28A745` | `#4CAF50` | Operation completed, eco mode active |
| **Warning** | `#FFA500` | `#FFB84D` | Low fuel, tire pressure, service due |
| **Error** | `#DC3545` | `#EF5350` | Critical failure, check engine light |
| **Info** | `#17A2B8` | `#29B6F6` | Informational messages, tips |
| **Speed** | `#00E5FF` | `#00E5FF` | Speed indicators, HUD elements |
| **RPM** | `#FF6F00` | `#FF8F00` | RPM gauge, engine metrics |

---

## 3. Typography

### Design Principles

- **Legibility** at high speeds and various lighting conditions
- **Hierarchy** clear distinction between primary and secondary information
- **Accessibility** minimum 14px for body text, 18px for dashboard metrics
- **Performance** system fonts preferred for embedded systems

### 3.1 Typeface Recommendations

#### Primary Typeface: **Inter** (Open Source)

**Why Inter?**
- Designed specifically for screens
- Excellent legibility at small sizes
- Open source (SIL Open Font License)
- Wide character set and language support
- Works well for both UI and data display

**Download:** [https://fonts.google.com/specimen/Inter](https://fonts.google.com/specimen/Inter)

**Weights to include:**
- Inter Regular (400) — Body text, labels
- Inter Medium (500) — Subheadings, emphasis
- Inter SemiBold (600) — Buttons, tabs
- Inter Bold (700) — Headlines, dashboard metrics

#### Secondary Typeface: **Roboto Mono** (Monospace, for Data)

**Why Roboto Mono?**
- Tabular numbers (all digits same width)
- Perfect for OBD codes, VIN numbers, diagnostic data
- Clear distinction between similar characters (0 vs O, 1 vs l)

**Weights to include:**
- Roboto Mono Regular (400)
- Roboto Mono Medium (500)

#### Fallback System Fonts

For embedded Linux systems where custom fonts may not load:

```css
font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', 
             'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 
             'Droid Sans', 'Helvetica Neue', sans-serif;
```

For monospace/data:
```css
font-family: 'Roboto Mono', 'SF Mono', Monaco, 'Cascadia Code', 
             'Consolas', 'Courier New', monospace;
```

---

### 3.2 Typography Scale

#### Dashboard/HUD Text

| Element | Font | Size | Weight | Line Height | Usage |
|---------|------|------|--------|-------------|-------|
| **Hero Metric** | Inter | 72px | Bold (700) | 1.0 | Speed, RPM (primary) |
| **Secondary Metric** | Inter | 36px | SemiBold (600) | 1.1 | Fuel %, temp, gear |
| **Metric Label** | Inter | 14px | Medium (500) | 1.2 | "MPH", "°F", "RPM" |
| **HUD Overlay** | Inter | 48px | Bold (700) | 1.0 | Heads-up speed display |

#### UI Text

| Element | Font | Size | Weight | Line Height | Usage |
|---------|------|------|--------|-------------|-------|
| **Page Title** | Inter | 32px | Bold (700) | 1.2 | Main screen titles |
| **Section Heading** | Inter | 24px | SemiBold (600) | 1.3 | Settings sections |
| **Body Text** | Inter | 16px | Regular (400) | 1.5 | Descriptions, settings |
| **Button Text** | Inter | 16px | SemiBold (600) | 1.0 | All buttons |
| **Tab Label** | Inter | 18px | Medium (500) | 1.0 | Navigation tabs |
| **Caption** | Inter | 14px | Regular (400) | 1.4 | Timestamps, metadata |

#### Data/Code Text

| Element | Font | Size | Weight | Line Height | Usage |
|---------|------|------|--------|-------------|-------|
| **OBD Code** | Roboto Mono | 18px | Medium (500) | 1.4 | P0420, DTC codes |
| **VIN Display** | Roboto Mono | 14px | Regular (400) | 1.5 | Vehicle identification |
| **Diagnostic Data** | Roboto Mono | 14px | Regular (400) | 1.6 | Debug logs, PID data |

---

### 3.3 Accessibility Notes

- **Minimum contrast ratio:** 4.5:1 for body text (WCAG AA)
- **Large text (18px+):** 3:1 minimum contrast
- **Dashboard metrics:** Use AAA standard (7:1) when possible
- **Night mode:** Reduce blue light, avoid pure white (#FFFFFF)
- **Dynamic scaling:** Support 1.0x - 1.5x text scaling via settings

---

## 4. Logo Design Directions

### 4.1 Logo Concept #1: "Pi Drive Ring"

![PiDriveSmartOS Logo Concept 1](../assets/branding/logo-concept1.svg)

**Description:**
- **Geometric form:** Circular ring representing a steering wheel or drive shaft
- **Central element:** Stylized Raspberry Pi logo (four-square motif) in the center
- **Integration:** Road lines or circuit traces forming the outer ring
- **Symbolism:** Combines "Pi" (computing) + "Drive" (automotive) in unified form

**Color Usage:**
- Primary version: Electric Blue ring (#0078D4) + Dark Charcoal center (#1E1E1E)
- Monochrome: All black for light backgrounds, all white for dark
- Night mode variant: Ice Blue (#4DB8FF) with reduced glow

**Sizing:**
- **App icon:** 512x512px (minimum 192x192px for Android Auto)
- **Splash screen:** 1024x1024px centered
- **HUD watermark:** 64x64px semi-transparent
- **GitHub social preview:** 1280x640px with text lockup

---

### 4.2 Logo Concept #2: "Smart Road"

![PiDriveSmartOS Logo Concept 2](../assets/branding/logo-concept2.svg)

**Description:**
- **Form:** Stylized road vanishing into horizon (perspective view)
- **Tech integration:** Circuit board traces forming the road lines
- **Smart element:** Small glowing nodes representing sensors/data points
- **Typography:** "Pi" integrated into road marking

**Color Usage:**
- Gradient from Electric Blue to Ice Blue
- Road surface: Dark Charcoal with glowing blue center line
- Optional: Animated version with flowing data particles

**Best for:**
- Marketing materials
- Website header
- GitHub README hero image

---

### 4.3 Logo Concept #3: "Modular Hex"

![PiDriveSmartOS Logo Concept 3](../assets/branding/logo-concept3.svg)

**Description:**
- **Geometric form:** Hexagon (represents modularity, like hardware connectors)
- **Internal:** Simplified car silhouette + circuit pattern
- **Style:** Flat, minimal, works at any size
- **Technical aesthetic:** Feels like a hardware badge or chip logo

**Color Usage:**
- Outline: Electric Blue
- Interior: Charcoal with blue accent highlights
- Monochrome-friendly

**Best for:**
- App icon (very recognizable when small)
- Embroidered patches
- Laser-etched hardware cases

---

### Logo Usage Guidelines

| Context | Logo Variant | Size | Clear Space |
|---------|--------------|------|-------------|
| **App Icon** | Full color, square format | 512x512px | N/A (fills canvas) |
| **Splash Screen** | Full color + wordmark | Logo: 256px, Word: 64px | 40px minimum |
| **GitHub Banner** | Horizontal lockup | 1200x300px | 20% of logo height |
| **HUD Watermark** | Monochrome white, 30% opacity | 48x48px | Inset 16px from corner |
| **Documentation** | Any variant | Max width 200px | 16px all sides |

---

## 5. UI Design Language

### 5.1 Spacing System

PiDriveSmartOS uses an 8px base grid for consistent spacing:

```
Space XS:  4px   — Icon padding, tight spacing
Space S:   8px   — Between related elements
Space M:   16px  — Standard spacing, card padding
Space L:   24px  — Between sections
Space XL:  32px  — Page margins
Space XXL: 48px  — Major section breaks
```

**QML Implementation:**
```qml
// Theme.qml
readonly property int spaceXS: 4
readonly property int spaceS: 8
readonly property int spaceM: 16
readonly property int spaceL: 24
readonly property int spaceXL: 32
readonly property int spaceXXL: 48
```

---

### 5.2 Corner Radius

Rounded corners provide a modern, friendly aesthetic while maintaining professionalism:

```
Radius Small:  4px  — Buttons, small chips
Radius Medium: 8px  — Cards, input fields
Radius Large:  16px — Modals, panels
Radius XL:     24px — Dashboard gauges
Radius Full:   999px — Circular avatars, indicators
```

---

### 5.3 Shadows & Elevation

Use subtle shadows for depth perception (more pronounced in Day Mode):

#### Day Mode Shadows

```css
Elevation 1 (Cards):
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);

Elevation 2 (Buttons, Hover):
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);

Elevation 3 (Modals, Dialogs):
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);

Elevation 4 (Tooltips):
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.25);
```

#### Night Mode Shadows

```css
Elevation 1 (Cards):
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
  background: #1E1E1E;  /* Lighter than background */

Elevation 2:
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.6);
  background: #242424;
```

---

### 5.4 Motion & Animation

#### Principles
- **Quick & responsive:** Animations complete in 200-400ms
- **Easing:** Use ease-out for entrances, ease-in-out for transitions
- **Driver safety:** No sudden movements or distracting effects
- **Purposeful:** Every animation communicates state change

#### Standard Durations

```qml
property int durationFast: 150      // Hover effects, ripples
property int durationNormal: 250    // Page transitions, modals
property int durationSlow: 400      // Complex transitions, gauges
```

#### Easing Curves

```qml
Easing.OutQuad    // Default for most transitions
Easing.InOutQuad  // For position changes
Easing.OutElastic // For playful elements (media controls)
```

---

### 5.5 Component Examples

#### Button Component

**Visual Specifications:**

```
Primary Button (Day Mode):
━━━━━━━━━━━━━━━━━━━━━━
┃  ▶ Play Music  ┃
━━━━━━━━━━━━━━━━━━━━━━
Background: #0078D4 (Electric Blue)
Text: #FFFFFF (White)
Height: 48px
Padding: 16px horizontal
Border Radius: 8px
Font: Inter SemiBold 16px
Shadow: Elevation 2 on hover

States:
- Hover: Darken 10%
- Pressed: Darken 20%, Elevation 1
- Disabled: Opacity 0.5, no hover
```

**ASCII Preview (Day):**
```
┏━━━━━━━━━━━━━━━━━━━━━━┓
┃  ▶ PLAY MUSIC        ┃  ← Primary Button
┗━━━━━━━━━━━━━━━━━━━━━━┛

┌──────────────────────┐
│  ⚙ Settings          │  ← Secondary Button
└──────────────────────┘
```

![Button Component Mockup](../assets/mockups/component-button.png)

---

#### Gauge Component (Speedometer)

**Specifications:**
```
Circular Gauge:
- Diameter: 240px (dashboard), 120px (compact)
- Arc: 270° (start: -225°, end: 45°)
- Track: 16px thick, #E0E0E0 (day) / #2C2C2C (night)
- Fill: Gradient from Electric Blue to Ice Blue
- Needle: Not used (modern arc fill only)
- Center value: 72px Inter Bold
- Unit label: 14px Inter Medium, below value
```

**ASCII Preview:**
```
        ╭─────────╮
      ╱   ╭───╮   ╲
    ╱    │ 65 │    ╲     ← Current speed
   │     │MPH │     │
   │     ╰───╯     │
    ╲             ╱
      ╲         ╱
        ╰─────╯
   ━━━━━━━━━━━━━━━━━
   0    45    90   120   ← Scale markers
```

![Gauge Component Mockup](../assets/mockups/component-gauge.png)

---

#### Card Component

**Specifications:**
```
Card (Day Mode):
┏━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ Trip Statistics       ┃  ← Title (24px SemiBold)
┣━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                        ┃
┃  Distance: 127.3 mi   ┃  ← Body content
┃  Avg Speed: 58 MPH    ┃
┃  Fuel Used: 3.2 gal   ┃
┃                        ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━┛

Background: #FFFFFF (Surface White)
Border: None (use shadow instead)
Padding: 24px
Border Radius: 12px
Shadow: Elevation 1
```

![Card Component Mockup](../assets/mockups/component-card.png)

---

#### HUD Overlay Component

**Specifications:**
```
HUD (Transparent overlay, Night Mode optimized):

╔════════════════════════════╗
║                            ║
║    ┌──────┐                ║
║    │  68  │  MPH           ║  ← Large, bold, high contrast
║    └──────┘                ║
║                            ║
║    ⚠ Low Fuel              ║  ← Critical warning
║                            ║
║    🎵 Now Playing          ║  ← Optional media info
║    "Song Name"             ║
║                            ║
╚════════════════════════════╝

Background: Semi-transparent black (rgba(0,0,0,0.6))
Text: Ice Blue (#4DB8FF) or White
Blur: Backdrop blur 10px (if supported)
Position: Overlay on top of all content
Font: Inter Bold 48px (speed)
```

![HUD Overlay Mockup](../assets/mockups/hud-overlay.png)

---

### 5.6 Dashboard Widget Layouts

#### Speed + RPM Layout (Primary Dashboard)

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                                                ┃
┃    ╭─────────╮            ╭─────────╮        ┃
┃   ╱   ╭───╮  ╲          ╱   ╭───╮  ╲       ┃
┃  │   │ 65 │   │        │   │ 32 │   │      ┃
┃  │   │MPH │   │        │   │x100│   │      ┃
┃  │   ╰───╯   │        │   │RPM │   │      ┃
┃   ╲         ╱          ╲   ╰───╯  ╱       ┃
┃    ╰───────╯            ╰─────────╯        ┃
┃     SPEED                  ENGINE           ┃
┃                                              ┃
┃  ┌────────┐ ┌────────┐ ┌────────┐          ┃
┃  │  ⛽ 75% │ │ 🌡️ 195°│ │  ⚙ D   │          ┃
┃  │  FUEL   │ │  TEMP  │ │  GEAR  │          ┃
┃  └────────┘ └────────┘ └────────┘          ┃
┃                                              ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

![Dashboard Light Theme](../assets/mockups/dashboard-light.png)
![Dashboard Dark Theme](../assets/mockups/dashboard-dark.png)

---

#### Media Player Widget

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  ♫  NOW PLAYING                              ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                               ┃
┃         ┌─────────────┐                      ┃
┃         │   Album     │                      ┃
┃         │     Art     │   Song Title         ┃
┃         │   [300x300] │   Artist Name        ┃
┃         └─────────────┘   Album • 2024       ┃
┃                                               ┃
┃  ━━━━━━━━━━●━━━━━━━━━━━━━━  2:34 / 4:12     ┃
┃                                               ┃
┃      ⏮   ⏯   ⏭        🔀  🔁  ❤️          ┃
┃                                               ┃
┃   [Spotify] [YouTube Music] [Local Files]    ┃
┃                                               ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

![Media Player Mockup](../assets/mockups/media-player.png)

---

#### OBD Diagnostics Widget

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  🔧 VEHICLE DIAGNOSTICS                      ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                               ┃
┃  ✅ Engine: Normal     ⚠️  Tire Pressure Low  ┃
┃  ✅ Transmission: OK   ✅ Battery: 12.8V      ┃
┃  ✅ Brakes: Normal     ⚠️  Service Due: 500mi ┃
┃                                               ┃
┃  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ┃
┃                                               ┃
┃  Diagnostic Trouble Codes (DTCs)             ┃
┃                                               ┃
┃  ⚠️  P0420  Catalyst System Efficiency       ┃
┃            Below Threshold                    ┃
┃            Severity: Moderate                 ┃
┃            [View Details] [Clear Code]        ┃
┃                                               ┃
┃  ✅ No other codes                            ┃
┃                                               ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

![OBD Diagnostics Mockup](../assets/mockups/obd-diagnostics.png)

---

## 6. Brand Usage Guide

### 6.1 Color Usage Matrix

| Element | Day Mode | Night Mode | Notes |
|---------|----------|------------|-------|
| **Primary Actions** | Electric Blue #0078D4 | Ice Blue #4DB8FF | Buttons, links, active states |
| **Backgrounds** | Light Gray #F5F5F5 | True Black #121212 | Main app background |
| **Cards/Panels** | White #FFFFFF | Dark Surface #1E1E1E | Elevated surfaces |
| **Body Text** | Charcoal #1E1E1E | Soft White #E0E0E0 | Primary readable text |
| **Secondary Text** | Gray #616161 | Medium Gray #A0A0A0 | Labels, captions |
| **Borders** | Light Gray #E0E0E0 | Dark Gray #2C2C2C | Dividers, outlines |
| **Success** | Green #28A745 | Green #4CAF50 | Confirmations, eco mode |
| **Warning** | Amber #FFA500 | Amber #FFB84D | Alerts, low fuel |
| **Error** | Red #DC3545 | Red #EF5350 | Critical errors |
| **Gauges (Speed)** | Cyan #00E5FF | Cyan #00E5FF | Speed indicators |
| **Gauges (RPM)** | Deep Orange #FF6F00 | Orange #FF8F00 | RPM, engine temp |

---

### 6.2 Logo Usage Matrix

| Usage Context | Logo Variant | Color | Background | Format |
|---------------|--------------|-------|------------|--------|
| **App Launcher Icon** | Full logo, square | Full color | Transparent | PNG 512x512 |
| **GitHub Social Card** | Logo + wordmark | Full color | White | PNG 1280x640 |
| **README Header** | Horizontal lockup | Full color | Transparent | SVG |
| **HUD Watermark** | Icon only | White 30% opacity | N/A (overlay) | SVG 48x48 |
| **Documentation** | Any variant | Monochrome black | White | SVG preferred |
| **Dark Backgrounds** | Any variant | Monochrome white | Dark | SVG |
| **Physical Merch** | Icon or full logo | Monochrome | Any | Vector (SVG/AI) |

---

### 6.3 Typography Usage

| Content Type | Typeface | Weight | Size Range | Line Height |
|--------------|----------|--------|------------|-------------|
| **Hero Dashboard Metrics** | Inter | Bold 700 | 48-72px | 1.0 |
| **Page Titles** | Inter | Bold 700 | 28-32px | 1.2 |
| **Section Headings** | Inter | SemiBold 600 | 20-24px | 1.3 |
| **Body Copy** | Inter | Regular 400 | 14-16px | 1.5 |
| **Buttons & Tabs** | Inter | SemiBold 600 | 16-18px | 1.0 |
| **Captions & Labels** | Inter | Medium 500 | 12-14px | 1.4 |
| **OBD/DTC Codes** | Roboto Mono | Regular 400 | 14-18px | 1.5 |
| **Diagnostic Data** | Roboto Mono | Regular 400 | 12-14px | 1.6 |

---

### 6.4 Brand Messaging Examples

| Context | Example Copy | Tone |
|---------|-------------|------|
| **Hero Tagline** | "Smart driving. Open technology." | Confident, clear |
| **Feature Description** | "Real-time OBD-II diagnostics at your fingertips" | Informative, technical |
| **Call to Action** | "Get started in 3 commands" | Encouraging, simple |
| **Error Message** | "Unable to connect to OBD interface. Check wiring." | Helpful, not alarming |
| **Success Message** | "Developer mode activated. Full system access granted." | Clear, empowering |
| **Safety Warning** | "⚠️ Critical: Low tire pressure detected. Pull over safely." | Urgent but calm |

---

## 7. Exportable Assets

### 7.1 Logo Files

**Location:** `/assets/branding/logos/`

| File | Format | Size | Usage |
|------|--------|------|-------|
| `logo-full-color.svg` | SVG | Vector | Primary logo, all contexts |
| `logo-monochrome-black.svg` | SVG | Vector | Light backgrounds, print |
| `logo-monochrome-white.svg` | SVG | Vector | Dark backgrounds |
| `logo-icon-only.svg` | SVG | Vector | App icon, small spaces |
| `logo-horizontal-lockup.svg` | SVG | Vector | GitHub banner, headers |
| `app-icon-512.png` | PNG | 512x512 | Android Auto icon |
| `app-icon-1024.png` | PNG | 1024x1024 | iOS CarPlay icon |
| `favicon.ico` | ICO | 32x32 | Website favicon |

---

### 7.2 Icon Set

**Location:** `/assets/branding/icons/`

**Categories:**
- **System Icons** (32x32px): Dashboard, Settings, Info, Warning, Error
- **Navigation Icons** (48x48px): Home, Media, OBD, Map, Phone
- **Media Icons** (24x24px): Play, Pause, Next, Previous, Volume, Shuffle
- **Vehicle Icons** (32x32px): Speedometer, RPM, Fuel, Temperature, Tire, Engine
- **Status Icons** (24x24px): WiFi, Bluetooth, GPS, LTE, Battery

**Format:** SVG (vector) + PNG exports at 1x, 2x, 3x

---

### 7.3 UI Kit Components

**Location:** `/src/carui/qml/Components/`

**QML Files:**
- `Theme.qml` — Central theme system (colors, fonts, spacing)
- `AppButton.qml` — Styled button component
- `AppCard.qml` — Card container with shadow
- `CircularGauge.qml` — Custom gauge for speed/RPM
- `LinearGauge.qml` — Bar-style gauge for fuel/temp
- `TabBar.qml` — Bottom navigation bar
- `StatusIndicator.qml` — Status lights (green/amber/red)
- `AlertDialog.qml` — Modal alert/warning dialogs
- `HUDOverlay.qml` — Heads-up display overlay

---

### 7.4 Qt Stylesheets (QSS)

**Location:** `/src/carui/styles/`

**Files:**
- `day-mode.qss` — Day mode stylesheet for Qt widgets
- `night-mode.qss` — Night mode stylesheet
- `automotive.qss` — Automotive-specific widget styles (larger hit targets, high contrast)

**Example snippet:**
```css
/* day-mode.qss */
QPushButton {
    background-color: #0078D4;
    color: #FFFFFF;
    font-family: "Inter";
    font-weight: 600;
    font-size: 16px;
    border-radius: 8px;
    padding: 12px 24px;
}

QPushButton:hover {
    background-color: #005A9E;
}

QPushButton:pressed {
    background-color: #004578;
}
```

---

### 7.5 Marketing Assets

**Location:** `/assets/mockups/`

| File | Size | Usage |
|------|------|-------|
| `github-social-preview.png` | 1280x640 | GitHub repository social card |
| `dashboard-light.png` | 1920x1080 | README screenshot, light theme |
| `dashboard-dark.png` | 1920x1080 | README screenshot, dark theme |
| `media-player.png` | 1920x1080 | Media interface showcase |
| `obd-diagnostics.png` | 1920x1080 | OBD screen showcase |
| `hud-overlay.png` | 1920x1080 | HUD demonstration |
| `hardware-setup.jpg` | 2400x1600 | Physical hardware assembly photo |

---

## Implementation Checklist

Use this checklist to track branding implementation across the project:

### Design Assets
- [ ] Logo concepts finalized and exported as SVG
- [ ] App icon created in multiple sizes (512, 1024, favicon)
- [ ] Icon set designed and exported (system, nav, media, vehicle, status)
- [ ] Marketing mockups created (dashboard, media, OBD, HUD)
- [ ] GitHub social preview card designed

### Color System
- [ ] Day mode color palette defined in Theme.qml
- [ ] Night mode color palette defined in Theme.qml
- [ ] Semantic colors (success, warning, error) implemented
- [ ] Gauge colors (speed, RPM, fuel) implemented
- [ ] All colors tested for WCAG contrast compliance

### Typography
- [ ] Inter font family downloaded and added to project
- [ ] Roboto Mono font added for monospace/data display
- [ ] Font loading implemented in QML ResourceLoader
- [ ] Typography scale defined in Theme.qml (sizes, weights, line heights)
- [ ] Fallback system fonts configured

### UI Components
- [ ] Theme.qml created with central design system
- [ ] AppButton.qml component created and styled
- [ ] AppCard.qml component created with shadows
- [ ] CircularGauge.qml component created for speed/RPM
- [ ] LinearGauge.qml component created for fuel/temp
- [ ] TabBar.qml navigation component created
- [ ] StatusIndicator.qml component created
- [ ] AlertDialog.qml component created
- [ ] HUDOverlay.qml component created

### QML Pages (Apply Theme)
- [ ] main.qml updated to use Theme system
- [ ] DashboardPage.qml updated with styled components
- [ ] MediaPage.qml updated with styled components
- [ ] VehiclePage.qml updated with styled components
- [ ] SettingsPage.qml updated with styled components

### Qt Stylesheets
- [ ] day-mode.qss created for native Qt widgets
- [ ] night-mode.qss created for native Qt widgets
- [ ] Stylesheet loading implemented in main.cpp

### Documentation
- [ ] This visual-branding.md document reviewed and approved
- [ ] Brand guidelines added to CONTRIBUTING.md
- [ ] README.md updated with logo and branding
- [ ] UI screenshots added to documentation

### Repository Presentation
- [ ] GitHub repository description updated with tagline
- [ ] Repository topics/tags added (raspberry-pi, automotive, qt, obd2, etc.)
- [ ] Social preview image set in GitHub settings
- [ ] LICENSE badge added to README
- [ ] Build status badge added (when CI is set up)

---

## Appendix: Inspiration & References

### Automotive UI Inspiration
- **Tesla Model 3/Y Interface:** Minimal, touch-first, fast
- **Rivian R1T Dashboard:** Bold typography, clear data hierarchy
- **Polestar 2 Android Automotive:** Google Material Design adapted for cars
- **Audi Virtual Cockpit:** Customizable gauge cluster, high contrast

### Design System References
- **Material Design 3:** Color system, elevation, motion
- **IBM Carbon Design System:** Grid, spacing, typography scale
- **Apple Human Interface Guidelines (CarPlay):** Safety, glanceability

### Open Source Projects
- **KDE Plasma:** Automotive-grade Qt/QML interfaces
- **AGL (Automotive Grade Linux):** Reference UI designs
- **OpenAuto Pro:** Raspberry Pi-based car interface

---

**End of Visual Branding & Design System Documentation**

**For questions or contributions to the design system, please open an issue on GitHub.**

---

*Last updated: October 2025*  
*Version: 1.0.0*  
*License: CC BY 4.0 (Documentation) | Apache 2.0 (Code Assets)*

