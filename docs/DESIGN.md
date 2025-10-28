# 🎨 Design Guide - PiDriveSmartOS

UX principles, visual branding, theme system, and component library.

---

## 📋 **Table of Contents**

1. [UX Philosophy](#ux-philosophy)
2. [Visual Branding](#branding)
3. [Theme System](#theme-system)
4. [Component Library](#components)
5. [Customization](#customization)

---

## 🚗 **UX Philosophy** {#ux-philosophy}

### **Drive-Friendly Design Principles:**

#### **1. Glance-ability (< 2 seconds)**
- Large text (min 18pt for body, 32pt+ for critical data)
- High contrast (WCAG AAA: 7:1+ ratio)
- Minimal text, maximum icons
- Color-coded status (red=danger, yellow=warning, green=ok)

#### **2. Touch-Optimized**
- Minimum touch target: 60x60dp (76mm²)
- Spaced buttons: 16dp minimum gap
- Large swipe areas for page navigation
- No double-tap (ambiguous timing)

#### **3. Minimal Distraction**
- Auto-hide non-critical UI
- Motion-triggered warnings only
- Voice feedback for actions
- Dark mode (night driving)

#### **4. Safety-First**
- Critical data always visible (speed, warnings)
- Non-blocking notifications (toasts, not modals)
- Voice control for hands-free operation
- Auto-dim at night

---

## 🎨 **Visual Branding** {#branding}

### **Brand Identity:**

- **Name**: PiDriveSmartOS
- **Tagline**: "Your Car, Your Code, Your Way"
- **Personality**: Tech-forward, approachable, maker-friendly
- **Audience**: DIYers, makers, open-source enthusiasts, students

### **Color System:**

#### **Day Mode (Default):**

| Color | HEX | RGB | Usage |
|-------|-----|-----|-------|
| **Primary** | `#2563EB` | `37, 99, 235` | Buttons, accents, active states |
| **Secondary** | `#10B981` | `16, 185, 129` | Success, ok status |
| **Accent** | `#F59E0B` | `245, 158, 11` | Warnings, highlights |
| **Danger** | `#EF4444` | `239, 68, 68` | Errors, critical warnings |
| **Background** | `#F9FAFB` | `249, 250, 251` | Main background |
| **Surface** | `#FFFFFF` | `255, 255, 255` | Cards, panels |
| **Text** | `#111827` | `17, 24, 39` | Primary text |
| **Text Muted** | `#6B7280` | `107, 114, 128` | Secondary text |

#### **Night Mode (Auto-enabled after sunset):**

| Color | HEX | RGB | Usage |
|-------|-----|-----|-------|
| **Primary** | `#60A5FA` | `96, 165, 250` | Buttons (dimmer blue) |
| **Secondary** | `#34D399` | `52, 211, 153` | Success (dimmer green) |
| **Accent** | `#FBBF24` | `251, 191, 36` | Warnings (dimmer amber) |
| **Danger** | `#F87171` | `248, 113, 113` | Errors (dimmer red) |
| **Background** | `#0F172A` | `15, 23, 42` | Main background (dark) |
| **Surface** | `#1E293B` | `30, 41, 59` | Cards, panels (dark) |
| **Text** | `#F1F5F9` | `241, 245, 249` | Primary text (light) |
| **Text Muted** | `#94A3B8` | `148, 163, 184` | Secondary text (light) |

### **Typography:**

| Element | Font | Size | Weight | Usage |
|---------|------|------|--------|-------|
| **Heading 1** | Inter | 32pt | Bold (700) | Page titles |
| **Heading 2** | Inter | 24pt | Semibold (600) | Section headers |
| **Body Large** | Inter | 18pt | Regular (400) | Button labels, key data |
| **Body** | Inter | 16pt | Regular (400) | Standard text |
| **Body Small** | Inter | 14pt | Regular (400) | Secondary info |
| **Caption** | Inter | 12pt | Medium (500) | Labels, timestamps |
| **Gauge Value** | Orbitron | 48pt | Bold (700) | Speed, RPM |

**Fallback Fonts**: `"Inter", "Roboto", "Helvetica Neue", sans-serif`

---

## 🛠️ **Theme System** {#theme-system}

### **Theme.qml (Singleton):**

```qml
pragma Singleton
import QtQuick 2.15

QtObject {
    id: theme
    
    // Current mode
    property bool isDarkMode: false
    
    // Colors (Day Mode)
    readonly property color primary: "#2563EB"
    readonly property color secondary: "#10B981"
    readonly property color accent: "#F59E0B"
    readonly property color danger: "#EF4444"
    readonly property color background: isDarkMode ? "#0F172A" : "#F9FAFB"
    readonly property color surface: isDarkMode ? "#1E293B" : "#FFFFFF"
    readonly property color text: isDarkMode ? "#F1F5F9" : "#111827"
    readonly property color textMuted: isDarkMode ? "#94A3B8" : "#6B7280"
    
    // Fonts
    readonly property QtObject fonts: QtObject {
        readonly property font h1: Qt.font({ family: "Inter", pixelSize: 32, weight: Font.Bold })
        readonly property font h2: Qt.font({ family: "Inter", pixelSize: 24, weight: Font.DemiBold })
        readonly property font body: Qt.font({ family: "Inter", pixelSize: 16, weight: Font.Normal })
        readonly property font small: Qt.font({ family: "Inter", pixelSize: 14 })
        readonly property font gauge: Qt.font({ family: "Orbitron", pixelSize: 48, weight: Font.Bold })
    }
    
    // Sizing
    readonly property QtObject sizing: QtObject {
        readonly property int statusBarHeight: 40
        readonly property int tabBarHeight: 80
        readonly property int buttonHeight: 60
        readonly property int cardPadding: 20
        readonly property int borderRadius: 12
    }
    
    // Spacing
    readonly property int spaceXS: 4
    readonly property int spaceS: 8
    readonly property int spaceM: 16
    readonly property int spaceL: 24
    readonly property int spaceXL: 32
    
    // Animation
    readonly property int animationFast: 150
    readonly property int animationMedium: 250
    readonly property int animationSlow: 400
}
```

### **Usage in QML:**

```qml
import "." as Local

Rectangle {
    color: Local.Theme.surface
    
    Text {
        text: "Dashboard"
        font: Local.Theme.fonts.h1
        color: Local.Theme.text
    }
}
```

---

## 🧩 **Component Library** {#components}

### **Atomic Design Structure:**

#### **Atoms** (Basic building blocks):

- **AppButton**: Primary, secondary, danger, text-only variants
- **StatusIndicator**: LED-style indicator with pulsing animation
- **IconButton**: Circular icon-only button

#### **Molecules** (Atoms + logic):

- **CircularGauge**: Speedometer, tachometer (arc + needle + value)
- **LinearGauge**: Fuel, temperature (bar + gradient + icon)
- **NavButton**: Tab bar navigation button

#### **Organisms** (Complex components):

- **VehicleInfoCard**: Speed, gear, fuel, temp in single card
- **MediaControls**: Play/pause, skip, volume, track info
- **ContactListItem**: Avatar, name, phone, call button

#### **Templates** (Layout structures):

- **ScrollablePage**: Auto-scroll, respects header/footer
- **PageLoader**: Lazy loading, memory management

### **Component API Example:**

```qml
// CircularGauge.qml
Components.CircularGauge {
    label: "Speed"
    unit: "MPH"
    value: 65
    minValue: 0
    maxValue: 140
    warningThreshold: 80
    dangerThreshold: 100
    gaugeColor: Local.Theme.primary
}

// AppButton.qml
Components.AppButton {
    text: "Start Engine"
    type: "primary"  // or "secondary", "danger", "text"
    icon: "🔑"
    onClicked: {
        console.log("Engine started!")
    }
}
```

---

## ⚙️ **Customization** {#customization}

### **1. Change Theme Colors:**

Edit `src/carui/qml/Theme.qml`:

```qml
readonly property color primary: "#FF5733"  // Your brand color
readonly property color secondary: "#33FF57"
```

### **2. Custom Fonts:**

```qml
// Load custom font
FontLoader {
    id: customFont
    source: "qrc:/assets/fonts/YourFont.ttf"
}

// Use in Theme.qml
readonly property font body: Qt.font({
    family: customFont.name,
    pixelSize: 16
})
```

### **3. Add New Component:**

```qml
// src/carui/qml/Components/MyComponent.qml
import QtQuick 2.15
import "." as Local

Rectangle {
    color: Local.Theme.surface
    radius: Local.Theme.sizing.borderRadius
    
    // Your custom logic
}
```

### **4. Override Default Styles:**

```qml
// In your page
Components.AppButton {
    // Override specific properties
    background.color: "#FF0000"
    contentItem.font.pixelSize: 24
}
```

---

## 🎯 **Design Best Practices**

### **DO:**
- ✅ Use Theme singleton for all colors/fonts
- ✅ Test on 7" touchscreen (1024x600)
- ✅ Test both day & night modes
- ✅ Use semantic color names (`primary`, not `blue`)
- ✅ Keep animations under 300ms
- ✅ Use `anchors` for responsive layouts

### **DON'T:**
- ❌ Hardcode colors/sizes in components
- ❌ Use tiny touch targets (< 60dp)
- ❌ Rely on hover states (no mouse!)
- ❌ Use low-contrast colors
- ❌ Animate while driving (distracting)
- ❌ Use modals for non-critical actions

---

## 📐 **Screen Layouts**

### **Dashboard (Primary View):**

```
┌────────────────────────────────────────┐
│  🌡️ 72°F   ☀️ Clear   🔋 12.8V  ⏰ 2:30 │ ← Status Bar (40px)
├────────────────────────────────────────┤
│                                        │
│   ╭───────╮   ╭───────╮   ╭───────╮  │
│   │  MPH  │   │  RPM  │   │ Fuel  │  │ ← Gauges
│   │  65   │   │ 2500  │   │  ●●●○ │  │
│   ╰───────╯   ╰───────╯   ╰───────╯  │
│                                        │
│  ┌────────────────────────────────┐   │
│  │ Trip: 15.2mi  MPG: 32.4       │   │ ← Trip Computer
│  └────────────────────────────────┘   │
│                                        │
│  ⚠️ Check Engine  🔧 Service Due      │ ← Warnings
│                                        │
├────────────────────────────────────────┤
│  🏠   📱   🎵   🚗   🗺️   📱   ⚙️     │ ← Nav Bar (80px)
└────────────────────────────────────────┘
```

---

## 📚 **Design Resources**

- **Icons**: Material Design Icons, Font Awesome
- **Mockups**: Figma template (coming soon)
- **Brand Assets**: `/assets/branding/`
- **Screenshots**: `/assets/screenshots/`

---

**Last Updated:** 2025-10-28 | **Version:** 2.0 (Consolidated)
