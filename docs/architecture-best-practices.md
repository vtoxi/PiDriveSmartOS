# PiDriveSmartOS - Architecture & Best Practices

**Version:** 2.0.0  
**Status:** Production Architecture  
**Principles:** SOLID, DRY, KISS, OOP, Clean Architecture

---

## 📋 Table of Contents

1. [Design Principles](#design-principles)
2. [Architecture Layers](#architecture-layers)
3. [Component Structure](#component-structure)
4. [State Management](#state-management)
5. [Data Flow](#data-flow)
6. [Testing Strategy](#testing-strategy)
7. [Refactoring Plan](#refactoring-plan)

---

## 🎯 Design Principles

### SOLID Principles in QML/C++

#### 1. **Single Responsibility Principle (SRP)**
> Each component should have one, and only one, reason to change.

**Current Implementation:**
- ✅ `VehicleData` - Only handles OBD data
- ✅ `GPSService` - Only handles GPS
- ✅ `MediaController` - Only handles media

**To Improve:**
- 📝 Separate UI logic from business logic
- 📝 Create view models for each page
- 📝 Extract data formatting into utilities

**Example Refactoring:**
```cpp
// BAD: Mixed responsibilities
class DashboardPage {
    void displaySpeed();
    void fetchOBDData();
    void formatSpeed();
    void saveSettings();
}

// GOOD: Single responsibility
class DashboardViewModel {
    Q_PROPERTY(QString formattedSpeed READ formattedSpeed NOTIFY speedChanged)
    QString formattedSpeed() const;
signals:
    void speedChanged();
};

class OBDDataService {
    void fetchSpeed();
};

class SpeedFormatter {
    static QString format(double speed, Unit unit);
};
```

---

#### 2. **Open/Closed Principle (OCP)**
> Open for extension, closed for modification.

**Implementation Strategy:**

```qml
// Base Gauge Component (closed for modification)
// GaugeBase.qml
Item {
    property real value
    property real minValue
    property real maxValue
    
    // Template method pattern
    signal dataChanged()
    
    function validate() {
        return value >= minValue && value <= maxValue
    }
}

// Extend without modifying base (open for extension)
// CircularGauge.qml
GaugeBase {
    // Add circular-specific visualization
    Canvas {
        onPaint: drawCircularGauge()
    }
}

// LinearGauge.qml
GaugeBase {
    // Add linear-specific visualization
    Rectangle {
        width: parent.width * valueRatio
    }
}
```

---

#### 3. **Liskov Substitution Principle (LSP)**
> Derived classes must be substitutable for their base classes.

```qml
// All gauges must work wherever GaugeBase is expected
Repeater {
    model: gaugeConfigs
    delegate: Loader {
        sourceComponent: modelData.type === "circular" ? 
                        circularGauge : linearGauge
        // Both work identically from parent's perspective
    }
}
```

---

#### 4. **Interface Segregation Principle (ISP)**
> No client should depend on methods it doesn't use.

```cpp
// BAD: Fat interface
class IVehicleService {
public:
    virtual double getSpeed() = 0;
    virtual double getRPM() = 0;
    virtual QList<QString> getDTCs() = 0;
    virtual QString getVIN() = 0;
    virtual void clearDTCs() = 0;
    virtual void performDiagnostic() = 0;
};

// GOOD: Segregated interfaces
class ISpeedProvider {
public:
    virtual double getSpeed() = 0;
};

class IRPMProvider {
public:
    virtual double getRPM() = 0;
};

class IDiagnosticProvider {
public:
    virtual QList<QString> getDTCs() = 0;
    virtual void clearDTCs() = 0;
};

// Services implement only what they need
class VehicleDataService : public ISpeedProvider, public IRPMProvider {
    double getSpeed() override;
    double getRPM() override;
};
```

---

#### 5. **Dependency Inversion Principle (DIP)**
> Depend on abstractions, not concretions.

```qml
// BAD: Direct dependency on concrete implementation
DashboardPage {
    property VehicleData vehicleData  // Concrete class
    Text { text: vehicleData.speed }
}

// GOOD: Depend on interface/abstraction
DashboardPage {
    property var dataProvider  // Abstract interface
    Text { text: dataProvider.speed }
}
```

---

## 🏗️ Architecture Layers

### Clean Architecture Applied to PiDriveSmartOS

```
┌─────────────────────────────────────────────────────────┐
│                    UI Layer (QML)                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐             │
│  │Dashboard │  │MediaPage │  │ Settings │             │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘             │
│       │             │              │                    │
└───────┼─────────────┼──────────────┼────────────────────┘
        │             │              │
┌───────┼─────────────┼──────────────┼────────────────────┐
│       │     Presentation Layer (ViewModels)            │
│  ┌────▼─────┐  ┌───▼──────┐  ┌───▼──────┐             │
│  │Dashboard │  │Media     │  │Settings  │             │
│  │ViewModel │  │ViewModel │  │ViewModel │             │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘             │
└───────┼─────────────┼──────────────┼────────────────────┘
        │             │              │
┌───────┼─────────────┼──────────────┼────────────────────┐
│       │      Business Logic Layer                       │
│  ┌────▼─────┐  ┌───▼──────┐  ┌───▼──────┐             │
│  │Vehicle   │  │Media     │  │Config    │             │
│  │Service   │  │Service   │  │Service   │             │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘             │
└───────┼─────────────┼──────────────┼────────────────────┘
        │             │              │
┌───────┼─────────────┼──────────────┼────────────────────┐
│       │         Data Layer                              │
│  ┌────▼─────┐  ┌───▼──────┐  ┌───▼──────┐             │
│  │OBD       │  │Media     │  │Settings  │             │
│  │Repository│  │Repository│  │Repository│             │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘             │
└───────┼─────────────┼──────────────┼────────────────────┘
        │             │              │
┌───────┼─────────────┼──────────────┼────────────────────┐
│       │    Infrastructure Layer                         │
│  ┌────▼─────┐  ┌───▼──────┐  ┌───▼──────┐             │
│  │SocketCAN │  │Qt        │  │QSettings │             │
│  │DBus      │  │Multimedia│  │SQLite    │             │
│  └──────────┘  └──────────┘  └──────────┘             │
└─────────────────────────────────────────────────────────┘
```

---

## 🧩 Component Structure

### Atomic Design Pattern

```
src/carui/qml/
├── Atoms/                  # Basic building blocks
│   ├── Text/
│   │   ├── HeadingText.qml
│   │   ├── BodyText.qml
│   │   └── CaptionText.qml
│   ├── Buttons/
│   │   ├── PrimaryButton.qml
│   │   ├── SecondaryButton.qml
│   │   └── IconButton.qml
│   └── Indicators/
│       ├── StatusLED.qml
│       └── LoadingSpinner.qml
│
├── Molecules/              # Simple combinations
│   ├── Gauges/
│   │   ├── CircularGauge.qml
│   │   └── LinearGauge.qml
│   ├── Cards/
│   │   ├── InfoCard.qml
│   │   └── StatCard.qml
│   └── Lists/
│       ├── ListItem.qml
│       └── ExpandableList.qml
│
├── Organisms/              # Complex combinations
│   ├── DashboardGaugeCluster.qml
│   ├── MediaPlayerControls.qml
│   ├── NavigationBar.qml
│   └── DiagnosticsPanel.qml
│
├── Templates/              # Page layouts
│   ├── StandardPage.qml
│   ├── ScrollablePage.qml
│   └── SplitViewPage.qml
│
└── Pages/                  # Complete pages
    ├── DashboardPage.qml
    ├── MediaPage.qml
    ├── VehiclePage.qml
    └── SettingsPage.qml
```

---

## 🔄 State Management

### Centralized State with Redux Pattern

```cpp
// State.h - Single source of truth
class AppState : public QObject {
    Q_OBJECT
    Q_PROPERTY(VehicleState* vehicle READ vehicle CONSTANT)
    Q_PROPERTY(MediaState* media READ media CONSTANT)
    Q_PROPERTY(UIState* ui READ ui CONSTANT)
    
public:
    VehicleState* vehicle() const { return m_vehicleState; }
    MediaState* media() const { return m_mediaState; }
    UIState* ui() const { return m_uiState; }
    
private:
    VehicleState* m_vehicleState;
    MediaState* m_mediaState;
    UIState* m_uiState;
};

// Actions.h - State modifications
class Action {
public:
    virtual ~Action() = default;
    virtual QString type() const = 0;
};

class UpdateSpeedAction : public Action {
public:
    explicit UpdateSpeedAction(double speed) : m_speed(speed) {}
    QString type() const override { return "UPDATE_SPEED"; }
    double speed() const { return m_speed; }
private:
    double m_speed;
};

// Store.h - State container
class Store : public QObject {
    Q_OBJECT
public:
    void dispatch(std::unique_ptr<Action> action);
    AppState* state() const { return m_state; }
    
signals:
    void stateChanged();
    
private:
    AppState* m_state;
    void reduce(Action* action);
};
```

**QML Usage:**
```qml
// DashboardPage.qml
Item {
    // No direct service dependencies!
    Text {
        text: AppStore.state.vehicle.speed
    }
    
    Button {
        onClicked: AppStore.dispatch(
            UpdateThemeAction.create("dark")
        )
    }
}
```

---

## 📊 Data Flow

### Unidirectional Data Flow

```
┌──────────────────────────────────────────────────┐
│                     View (QML)                   │
│                                                  │
│  ┌──────────┐                    ┌──────────┐  │
│  │Dashboard │  ◄────State────── │  Store   │  │
│  │  Page    │                    │          │  │
│  └────┬─────┘                    └────▲─────┘  │
│       │                                │        │
│       │ User Action                    │        │
│       │  (Click)                       │        │
│       ▼                                │        │
│  ┌──────────┐                          │        │
│  │ViewModel │ ────Action──────────────┘        │
│  └────┬─────┘                                   │
└───────┼──────────────────────────────────────────┘
        │
        │ Side Effect
        ▼
┌──────────────┐        ┌──────────────┐
│   Service    │◄──────►│  Repository  │
└──────────────┘        └──────────────┘
        │                       │
        │                       ▼
        │               ┌──────────────┐
        └──────────────►│Infrastructure│
                        │ (CAN, DBus)  │
                        └──────────────┘
```

---

## 🧪 Testing Strategy

### Test Pyramid

```
                    ┌──────┐
                    │  E2E │  (5%)
                    │Tests │
                ┌───┴──────┴───┐
                │ Integration  │  (15%)
                │    Tests     │
            ┌───┴──────────────┴───┐
            │   Component Tests    │  (30%)
        ┌───┴──────────────────────┴───┐
        │      Unit Tests              │  (50%)
        └──────────────────────────────┘
```

#### Unit Tests (C++)
```cpp
// test_vehicledata.cpp
TEST_F(VehicleDataTest, SpeedConversion) {
    VehicleData data;
    data.setSpeed(100); // km/h
    
    EXPECT_DOUBLE_EQ(data.speedInMph(), 62.137);
}

TEST_F(VehicleDataTest, InvalidSpeedHandling) {
    VehicleData data;
    data.setSpeed(-10);
    
    EXPECT_DOUBLE_EQ(data.speed(), 0.0);
    EXPECT_TRUE(data.hasError());
}
```

#### Component Tests (QML)
```qml
// tst_CircularGauge.qml
TestCase {
    name: "CircularGauge"
    
    function test_valueUpdate() {
        var gauge = createTemporaryObject(circularGauge, testCase)
        gauge.value = 50
        
        compare(gauge.value, 50)
        verify(gauge.valueRatio === 0.5)
    }
    
    function test_warningThreshold() {
        var gauge = createTemporaryObject(circularGauge, testCase)
        gauge.value = 85
        gauge.warningThreshold = 80
        
        verify(gauge.isWarning)
    }
}
```

---

## 🔨 Refactoring Plan

### Phase 1: Foundation (Week 1-2)

**Goals:**
- ✅ Fix all QML errors
- ✅ Establish Theme system
- ✅ Create base components

**Tasks:**
1. Create abstract base classes for services
2. Implement dependency injection container
3. Extract all hardcoded values to constants
4. Create utility classes for formatting

**Files to Create:**
```
src/carui/
├── core/
│   ├── ServiceLocator.h/cpp
│   ├── DependencyInjection.h/cpp
│   └── Constants.h
├── interfaces/
│   ├── IDataProvider.h
│   ├── IMediaController.h
│   └── IConfigService.h
└── utils/
    ├── Formatter.h/cpp
    ├── Validator.h/cpp
    └── Logger.h/cpp
```

---

### Phase 2: View Models (Week 3)

**Goals:**
- Separate presentation logic from UI
- Implement MVVM pattern properly
- Add computed properties

**Example ViewModel:**
```cpp
// DashboardViewModel.h
class DashboardViewModel : public QObject {
    Q_OBJECT
    
    // Computed properties (DRY principle)
    Q_PROPERTY(QString formattedSpeed READ formattedSpeed NOTIFY vehicleDataChanged)
    Q_PROPERTY(bool isSpeedDangerous READ isSpeedDangerous NOTIFY vehicleDataChanged)
    Q_PROPERTY(QColor speedColor READ speedColor NOTIFY vehicleDataChanged)
    
public:
    explicit DashboardViewModel(IVehicleDataService* service, QObject* parent = nullptr);
    
    QString formattedSpeed() const;
    bool isSpeedDangerous() const;
    QColor speedColor() const;
    
public slots:
    void refreshData();
    
signals:
    void vehicleDataChanged();
    
private:
    IVehicleDataService* m_vehicleService;
    double m_currentSpeed;
    
    // Business logic encapsulated
    bool validateSpeed(double speed) const;
    QString formatWithUnit(double value) const;
};
```

---

### Phase 3: State Management (Week 4)

**Goals:**
- Implement centralized state
- Add action/reducer pattern
- Enable time-travel debugging

**State Structure:**
```cpp
struct VehicleState {
    double speed;
    double rpm;
    double fuelLevel;
    double engineTemp;
    QList<QString> dtcCodes;
    QDateTime lastUpdate;
};

struct UIState {
    QString currentPage;
    bool isDarkMode;
    QString selectedUnit; // mph vs km/h
    bool isLoading;
};

struct MediaState {
    QString currentTrack;
    QString currentArtist;
    bool isPlaying;
    int volume;
    QList<QString> queue;
};
```

---

### Phase 4: Advanced Features (Week 5-6)

**Goals:**
- Add offline mode
- Implement caching
- Add analytics

**Features:**
```cpp
// Caching Strategy
class CacheManager {
public:
    void cache(const QString& key, const QVariant& value, int ttl = 300);
    QVariant get(const QString& key);
    bool has(const QString& key);
    void clear();
    
private:
    QHash<QString, CacheEntry> m_cache;
    void evictExpired();
};

// Analytics
class Analytics {
public:
    void trackEvent(const QString& event, const QVariantMap& properties);
    void trackScreen(const QString& screenName);
    void trackError(const QString& error);
    
private:
    void sendToBackend(const AnalyticsEvent& event);
};
```

---

## 📝 Code Quality Metrics

### Targets

| Metric | Target | Current |
|--------|--------|---------|
| Code Coverage | >80% | TBD |
| Cyclomatic Complexity | <10 | TBD |
| Lines per Function | <50 | TBD |
| Files per Directory | <20 | ✅ |
| Coupling | Low | Medium |
| Cohesion | High | Medium |

### Tools

```bash
# Static Analysis
clang-tidy src/**/*.cpp
cppcheck --enable=all src/

# Code Coverage
gcov carui
lcov --capture --directory . --output-file coverage.info

# QML Linting
qmllint src/carui/qml/**/*.qml
```

---

## 🎓 Best Practices Summary

### DO ✅

1. **Single Responsibility**: One class = one job
2. **Dependency Injection**: Pass dependencies, don't create them
3. **Interface-based**: Code to interfaces, not implementations
4. **Immutable State**: Don't mutate, create new state
5. **Pure Functions**: No side effects in logic functions
6. **Error Handling**: Always handle errors gracefully
7. **Documentation**: Document WHY, not WHAT
8. **Testing**: Write tests FIRST (TDD)

### DON'T ❌

1. **God Objects**: Don't create classes that do everything
2. **Global State**: Avoid global variables
3. **Tight Coupling**: Don't hardcode dependencies
4. **Magic Numbers**: Use named constants
5. **Deep Nesting**: Flatten with early returns
6. **Circular Dependencies**: Design to avoid cycles
7. **Copy-Paste**: Extract common code
8. **Premature Optimization**: Profile first

---

## 📚 Further Reading

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) - Robert C. Martin
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID) - Wikipedia
- [Qt Best Practices](https://doc.qt.io/qt-6/best-practices.html) - Qt Documentation
- [QML Coding Conventions](https://doc.qt.io/qt-6/qml-codingconventions.html) - Qt Documentation

---

**Next Steps:**
1. Review this architecture with the team
2. Create detailed technical specifications for each phase
3. Set up CI/CD pipeline with quality gates
4. Begin Phase 1 refactoring

**Maintainer:** PiDriveSmartOS Team  
**Last Updated:** October 2025  
**Version:** 2.0.0

