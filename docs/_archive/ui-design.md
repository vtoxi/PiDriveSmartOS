# UI Design Guidelines

> UX philosophy, design principles, and interface specifications for PiDriveSmartOS

---

## Table of Contents

- [Design Philosophy](#design-philosophy)
- [Safety-First Principles](#safety-first-principles)
- [Visual Design](#visual-design)
- [Screen Layouts](#screen-layouts)
- [Interaction Patterns](#interaction-patterns)
- [Typography](#typography)
- [Color System](#color-system)
- [Icons and Graphics](#icons-and-graphics)
- [Animations](#animations)
- [Accessibility](#accessibility)
- [Responsive Design](#responsive-design)

---

## Design Philosophy

### Core Principles

1. **Driver Safety First**
   - Glanceable information (read in <2 seconds)
   - Large, easy-to-tap controls
   - Minimal cognitive load
   - Voice feedback for critical actions

2. **Automotive Heritage**
   - Inspired by OEM dashboards (Audi, BMW, Tesla)
   - Familiar automotive metaphors (gauges, needles)
   - Professional, premium feel

3. **Simplicity and Clarity**
   - One primary action per screen
   - Clear visual hierarchy
   - Consistent navigation patterns
   - No clutter, no distractions

4. **Touch-First**
   - Designed for fingers, not mouse cursors
   - No hover states
   - Large touch targets (minimum 44x44px)
   - Gesture-based navigation

5. **Performance**
   - 60 FPS animations
   - Instant feedback (<100ms)
   - Smooth scrolling
   - No lag or stuttering

### Design Inspiration

**Automotive UIs**:
- Tesla Model 3 (simplicity, minimalism)
- Audi Virtual Cockpit (digital gauges)
- BMW iDrive 8 (widget system)
- Mercedes MBUX (voice assistant)

**Non-Automotive**:
- iOS (polish, fluidity)
- Material Design 3 (color system, depth)
- Fluent Design (acrylic effects)

---

## Safety-First Principles

### NHTSA Guidelines Compliance

Following **NHTSA Phase 1 Driver Distraction Guidelines** (2013):

1. **Task Completion Time**: <2 seconds per glance
2. **Complexity**: Max 6 manual sub-tasks
3. **Text Input**: Disabled while driving (speed > 5 mph)
4. **Video**: Blocked while moving
5. **Automatic Reversion**: Return to safe screen after inactivity

### Driving Mode Restrictions

**While Moving (Speed > 5 mph)**:
- ❌ Keyboard input disabled
- ❌ Long scrolling lists disabled
- ❌ Video playback blocked
- ❌ Complex settings disabled
- ✅ Pre-programmed destinations OK
- ✅ Voice control OK
- ✅ Large buttons OK

**When Parked (Speed = 0 mph)**:
- ✅ All features enabled
- ✅ Keyboard input
- ✅ Video playback
- ✅ Complex settings

### Glanceable Design

**Information Hierarchy**:

```
Priority 1 (Always Visible):
  - Current speed
  - Active navigation instruction
  - Warning lights

Priority 2 (One Glance):
  - RPM, fuel level, temperature
  - Media now playing
  - Time

Priority 3 (Secondary):
  - Trip computer stats
  - Weather
  - Notifications
```

### Distraction Mitigation

- **No auto-play ads**
- **No pop-ups** (except critical alerts)
- **No scrolling text** (marquee)
- **Minimal animations** (smooth, not flashy)
- **High contrast** (easy to read in sunlight)

---

## Visual Design

### Design Language: "AutomotiveFlat"

**Characteristics**:
- Flat design with subtle depth (2.5D)
- Card-based layouts
- Rounded corners (12px radius)
- Glassmorphism effects (optional, night mode)
- Shadow for depth (elevation)

### Elevation System

| Level | Use Case | Shadow |
|-------|----------|--------|
| **0** | Background | None |
| **1** | Cards, buttons | 0px 2px 4px rgba(0,0,0,0.1) |
| **2** | Navigation bar | 0px 4px 8px rgba(0,0,0,0.15) |
| **3** | Dialogs, modals | 0px 8px 16px rgba(0,0,0,0.2) |
| **4** | Pop-ups, tooltips | 0px 12px 24px rgba(0,0,0,0.25) |

### Spacing System

**8px Base Grid**:

```
4px   = 0.5 units (tight)
8px   = 1 unit (base)
16px  = 2 units (comfortable)
24px  = 3 units (spacious)
32px  = 4 units (section gap)
48px  = 6 units (major sections)
```

**Example Layout**:
```
┌────────────────────────────────────────────┐
│  [Padding: 24px]                           │
│                                            │
│  ┌──────────────────────────────────────┐ │
│  │  Card (margin-bottom: 16px)          │ │
│  │  [Content padding: 16px]             │ │
│  └──────────────────────────────────────┘ │
│                                            │
│  ┌──────────────────────────────────────┐ │
│  │  Card                                │ │
│  └──────────────────────────────────────┘ │
│                                            │
└────────────────────────────────────────────┘
```

---

## Screen Layouts

### Home Dashboard

**Primary Layout** (1024x600px default):

```
┌─────────────────────────────────────────────────────────────┐
│  [Status Bar: 10:45 AM | Wi-Fi | Bluetooth | 85°F]          │ 40px
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │              │  │              │  │              │     │
│  │  Speed       │  │  RPM         │  │  Fuel        │     │
│  │              │  │              │  │              │     │
│  │  65 mph      │  │  2500        │  │  78%         │     │
│  │              │  │              │  │              │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │ 300px
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  🎵 Now Playing: Song Title - Artist               │   │ 80px
│  │  [⏮] [⏸] [⏭]                                       │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  [🏠 Home] [🧭 Nav] [🎵 Media] [🚗 Vehicle] [⚙️ Settings]   │ 80px
└─────────────────────────────────────────────────────────────┘
```

**Component Breakdown**:
- **Status Bar**: 40px height, system info
- **Widget Area**: 300px height, customizable
- **Media Bar**: 80px height, collapsible
- **Navigation Bar**: 80px height, always visible

### Navigation Screen

```
┌─────────────────────────────────────────────────────────────┐
│  [< Back]  🧭 Navigation                          [Options] │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  In 500m, TURN LEFT onto Main Street                       │
│  ETA: 10:45 AM (12 min, 8.5 km)                           │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │                                                       │ │
│  │                                                       │ │
│  │                 MAP VIEW                              │ │
│  │                                                       │ │
│  │                                                       │ │
│  │                                                       │ │
│  │                    ↑ YOU                              │ │
│  │                                                       │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  [End Navigation]               [Mute Guidance]             │
├─────────────────────────────────────────────────────────────┤
│  [🏠] [🧭] [🎵] [🚗] [⚙️]                                   │
└─────────────────────────────────────────────────────────────┘
```

### Media Screen

```
┌─────────────────────────────────────────────────────────────┐
│  [< Back]  🎵 Media Player                        [Queue]   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│        ┌─────────────────────────────────┐                 │
│        │                                 │                 │
│        │                                 │                 │
│        │         ALBUM ART               │                 │
│        │         (300x300)               │                 │
│        │                                 │                 │
│        │                                 │                 │
│        └─────────────────────────────────┘                 │
│                                                             │
│              ♪ Song Title                                   │
│              Artist Name · Album Name                       │
│                                                             │
│        [━━━━━━━━●─────────────] 2:34 / 4:12               │
│                                                             │
│        [🔀] [⏮] [⏸] [⏭] [🔁]                              │
│                                                             │
│        Volume: ──────●────── 75%                            │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  [🏠] [🧭] [🎵] [🚗] [⚙️]                                   │
└─────────────────────────────────────────────────────────────┘
```

### Settings Screen

```
┌─────────────────────────────────────────────────────────────┐
│  [< Back]  ⚙️ Settings                                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  📡 Network                                    [>]  │   │
│  │  Wi-Fi, Bluetooth, Mobile Data                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  🎨 Display                                    [>]  │   │
│  │  Theme, Brightness, Widgets                        │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  🚗 Vehicle                                    [>]  │   │
│  │  Profile, Units, Calibration                       │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  🔐 Security                                   [>]  │   │
│  │  PIN, Developer Mode, Updates                      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  [🏠] [🧭] [🎵] [🚗] [⚙️]                                   │
└─────────────────────────────────────────────────────────────┘
```

---

## Interaction Patterns

### Touch Targets

**Minimum Sizes**:
- **Buttons**: 44x44px (11mm physical)
- **List items**: Full width x 60px height
- **Toggle switches**: 50x30px
- **Sliders**: 40px height (touch area)

**Spacing**:
- Minimum 8px gap between adjacent touch targets
- Recommended 16px for comfortable tapping

### Gestures

| Gesture | Action | Use Case |
|---------|--------|----------|
| **Tap** | Select, activate | Buttons, list items |
| **Long press** | Context menu | Advanced options |
| **Swipe left/right** | Navigate between screens | Dashboard pages |
| **Swipe up/down** | Scroll | Lists, settings |
| **Pinch** | Zoom | Maps |
| **Two-finger swipe down** | Quick settings | Volume, brightness |

**No Gestures** (safety):
- ❌ Complex multi-finger gestures
- ❌ Shake to undo
- ❌ Double-tap (too slow)

### Feedback

**Visual**:
- Button press: Scale 0.95x + darken
- State change: Smooth color transition
- Success: Green checkmark
- Error: Red shake animation

**Haptic** (if touchscreen supports):
- Light tap: Button press
- Medium tap: Toggle switch
- Heavy tap: Critical action (delete, clear)

**Audio**:
- Click sound: Button press (optional, user setting)
- Voice feedback: "Navigation started", "Call ended"
- Alert sound: Warning (DTC, low fuel)

---

## Typography

### Font Stack

**Primary**: **Inter** (Open Source, excellent readability)
**Fallback**: `system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif`

**Alternative**: **Roboto**, **SF Pro** (if licensing allows)

### Type Scale

| Style | Size | Weight | Use Case |
|-------|------|--------|----------|
| **Display** | 48px | Bold (700) | Speed, large numbers |
| **Heading 1** | 32px | Bold (700) | Screen titles |
| **Heading 2** | 24px | Semibold (600) | Section headers |
| **Heading 3** | 20px | Semibold (600) | Card titles |
| **Body Large** | 18px | Regular (400) | Primary text |
| **Body** | 16px | Regular (400) | Standard text |
| **Body Small** | 14px | Regular (400) | Secondary text |
| **Caption** | 12px | Regular (400) | Labels, hints |

### Text Styles

**Example CSS**:

```css
/* Display (Speed, RPM) */
.display {
    font-size: 48px;
    font-weight: 700;
    line-height: 1.2;
    letter-spacing: -0.02em;
}

/* Heading 1 (Screen Titles) */
.h1 {
    font-size: 32px;
    font-weight: 700;
    line-height: 1.3;
}

/* Body (Standard Text) */
.body {
    font-size: 16px;
    font-weight: 400;
    line-height: 1.5;
}
```

### Text Guidelines

- **Max line length**: 60 characters (optimal readability)
- **Line height**: 1.5x font size (body text)
- **Contrast ratio**: Minimum 4.5:1 (WCAG AA)
- **All caps**: Only for short labels (e.g., "PAUSE", "END")
- **Truncation**: Use ellipsis (...) for long text

---

## Color System

### Day Theme (Light Mode)

**Background**:
- Primary: `#F5F5F5` (light gray)
- Surface: `#FFFFFF` (white)
- Card: `#FFFFFF` with shadow

**Text**:
- Primary: `#212121` (near black)
- Secondary: `#757575` (gray)
- Disabled: `#BDBDBD` (light gray)

**Accent Colors**:
- Primary: `#1976D2` (blue) - Buttons, links
- Success: `#388E3C` (green) - Confirmations
- Warning: `#FFA726` (orange) - Caution
- Error: `#D32F2F` (red) - Alerts, errors

### Night Theme (Dark Mode)

**Background**:
- Primary: `#121212` (near black)
- Surface: `#1E1E1E` (dark gray)
- Card: `#2C2C2C` with glow

**Text**:
- Primary: `#FFFFFF` (white)
- Secondary: `#B0B0B0` (light gray)
- Disabled: `#6C6C6C` (gray)

**Accent Colors**:
- Primary: `#FF5252` (red) - Better for night vision
- Success: `#69F0AE` (green)
- Warning: `#FFD740` (yellow)
- Error: `#FF5252` (red)

### Semantic Colors

| Color | Hex (Day) | Hex (Night) | Use Case |
|-------|-----------|-------------|----------|
| **Speed OK** | `#4CAF50` | `#69F0AE` | Normal speed |
| **Speed Warning** | `#FFA726` | `#FFD740` | Near limit |
| **Speed Alert** | `#D32F2F` | `#FF5252` | Over limit |
| **Engine Temp Normal** | `#2196F3` | `#64B5F6` | Cold/normal |
| **Engine Temp Warm** | `#FFA726` | `#FFD740` | Warm |
| **Engine Temp Hot** | `#D32F2F` | `#FF5252` | Overheating |

### Gradient Gauges

**Speed Gradient** (0-140 mph):
```css
background: linear-gradient(90deg, 
    #4CAF50 0%,    /* 0-60: Green */
    #FFA726 60%,   /* 60-80: Yellow */
    #D32F2F 80%    /* 80+: Red */
);
```

---

## Icons and Graphics

### Icon Style

**Style**: **Material Design Icons** (line style, 2px stroke)

**Sizes**:
- Small: 20x20px (inline icons)
- Medium: 32x32px (buttons)
- Large: 48x48px (navigation bar)
- Extra Large: 64x64px (empty states)

### Icon Usage

| Icon | Unicode | Use Case |
|------|---------|----------|
| 🏠 | U+1F3E0 | Home |
| 🧭 | U+1F9ED | Navigation |
| 🎵 | U+1F3B5 | Media |
| 🚗 | U+1F697 | Vehicle |
| ⚙️ | U+2699 | Settings |
| ⏸ | U+23F8 | Pause |
| ⏭ | U+23ED | Next |
| 🔔 | U+1F514 | Notifications |

**Custom Icons** (SVG):
- Speedometer gauge
- Fuel pump
- Temperature thermometer
- Battery
- GPS signal

### Gauge Graphics

**Analog Speedometer** (QML Canvas):

```qml
Canvas {
    id: speedoCanvas
    width: 200; height: 200
    
    onPaint: {
        var ctx = getContext("2d");
        ctx.clearRect(0, 0, width, height);
        
        // Draw arc (gauge background)
        ctx.beginPath();
        ctx.arc(100, 100, 80, 0.75 * Math.PI, 2.25 * Math.PI);
        ctx.lineWidth = 10;
        ctx.strokeStyle = "#E0E0E0";
        ctx.stroke();
        
        // Draw needle
        var angle = 0.75 * Math.PI + (speed / 140) * 1.5 * Math.PI;
        ctx.beginPath();
        ctx.moveTo(100, 100);
        ctx.lineTo(100 + 70 * Math.cos(angle), 
                   100 + 70 * Math.sin(angle));
        ctx.lineWidth = 3;
        ctx.strokeStyle = "#D32F2F";
        ctx.stroke();
        
        // Draw center circle
        ctx.beginPath();
        ctx.arc(100, 100, 8, 0, 2 * Math.PI);
        ctx.fillStyle = "#D32F2F";
        ctx.fill();
    }
}
```

---

## Animations

### Animation Principles

1. **Purposeful**: Animations guide attention, don't distract
2. **Fast**: Duration 200-300ms (feels instant)
3. **Smooth**: 60 FPS, no dropped frames
4. **Interruptible**: User can cancel mid-animation

### Transition Timing

| Animation | Duration | Easing |
|-----------|----------|--------|
| **Button press** | 100ms | ease-out |
| **Screen transition** | 250ms | ease-in-out |
| **Modal open** | 300ms | ease-out |
| **Gauge needle** | 400ms | ease-out |
| **Scroll** | 200ms | ease-out |

### QML Animations

**Button Press**:

```qml
Button {
    id: myButton
    scale: pressed ? 0.95 : 1.0
    
    Behavior on scale {
        NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
    }
}
```

**Screen Slide**:

```qml
StackView {
    id: stackView
    
    pushEnter: Transition {
        PropertyAnimation {
            property: "x"
            from: stackView.width
            to: 0
            duration: 250
            easing.type: Easing.OutQuad
        }
    }
}
```

**Gauge Needle**:

```qml
Rotation {
    id: needleRotation
    origin.x: 100; origin.y: 100
    angle: (vehicleData.speed / 140) * 270 - 135
    
    Behavior on angle {
        NumberAnimation { duration: 400; easing.type: Easing.OutQuad }
    }
}
```

### Performance

- **Use GPU**: Enable hardware acceleration for Qt Quick
- **Limit layers**: Max 3 animated layers at once
- **Optimize images**: Use compressed PNGs or WebP
- **Profile**: Use QML Profiler to find bottlenecks

---

## Accessibility

### Vision

**Color Blindness**:
- Don't rely on color alone (use icons + text)
- Test with ColorOracle or Sim Daltonism
- Provide high-contrast mode

**Low Vision**:
- Support font scaling (1.0x - 2.0x)
- Minimum text size: 16px (body)
- High contrast mode: 7:1 ratio

### Hearing

**Audio Alerts**:
- Visual alternative for every sound
- Flashing indicator for alerts
- Subtitles for voice guidance

### Motor

**Touch Targets**:
- Large buttons (44x44px minimum)
- No precise gestures required
- Voice control as alternative

### Screen Reader Support

**Qt Accessibility**:

```qml
Button {
    text: "Play"
    Accessible.role: Accessible.Button
    Accessible.name: "Play media"
    Accessible.description: "Start playing the current song"
    Accessible.onPressAction: {
        clicked()
    }
}
```

---

## Responsive Design

### Screen Sizes

| Resolution | Ratio | Use Case |
|------------|-------|----------|
| **1024x600** | 16:9.5 | 7" touchscreen (default) |
| **1280x720** | 16:9 | 8-10" displays |
| **1920x1080** | 16:9 | 10" HD displays |
| **800x480** | 16:10 | 5" small displays |

### Breakpoints

```qml
// Responsive layout
Item {
    property bool isSmall: width < 800
    property bool isMedium: width >= 800 && width < 1280
    property bool isLarge: width >= 1280
    
    // Adjust layout based on size
    Row {
        spacing: isSmall ? 8 : 16
        
        Repeater {
            model: isSmall ? 2 : 3  // Fewer widgets on small screens
            // ...
        }
    }
}
```

### Orientation

**Landscape** (default): 1024x600, 1280x720, etc.
**Portrait** (optional): 600x1024 (for vertical tablets)

---

## Design Checklist

### Pre-Release

- [ ] All touch targets ≥ 44x44px
- [ ] Contrast ratio ≥ 4.5:1 (text)
- [ ] Tested in bright sunlight
- [ ] Tested at night (dark mode)
- [ ] No scrolling lists while driving
- [ ] Video blocked when moving
- [ ] Voice feedback for critical actions
- [ ] All icons have accessible labels
- [ ] Color-blind tested (Deuteranopia, Protanopia)
- [ ] Font scaling tested (1.0x - 2.0x)
- [ ] Animations ≤ 300ms
- [ ] 60 FPS on Raspberry Pi 5

---

## Design Resources

**Figma Files**: [PiDriveSmartOS UI Kit](https://figma.com/@pidriveos)
**Icon Pack**: [Material Design Icons](https://materialdesignicons.com/)
**Font**: [Inter Font](https://rsms.me/inter/)
**Color Picker**: [Coolors.co](https://coolors.co/)
**Contrast Checker**: [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)

---

## Conclusion

PiDriveSmartOS UI is designed with **safety, clarity, and usability** as top priorities. Every design decision is made with the driver in mind.

**Key Takeaways**:
- 🚗 Safety first (glanceable, minimal distraction)
- 👆 Touch-optimized (large targets, simple gestures)
- 🎨 Modern and premium (automotive-inspired design)
- ♿ Accessible (color-blind friendly, screen reader support)
- ⚡ Performant (60 FPS, smooth animations)

**Next Steps**:
- Review [features.md](features.md) for functionality details
- See [architecture.md](architecture.md) for technical implementation
- Check [roadmap.md](roadmap.md) for upcoming UI improvements

