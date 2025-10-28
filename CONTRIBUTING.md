# Contributing to PiDriveSmartOS

Thank you for your interest in contributing to PiDriveSmartOS! This document provides guidelines and instructions for contributing.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Community](#community)

---

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors, regardless of experience level, gender, gender identity, sexual orientation, disability, appearance, race, ethnicity, age, religion, or nationality.

### Expected Behavior

- Use welcoming and inclusive language
- Be respectful of differing viewpoints
- Accept constructive criticism gracefully
- Focus on what's best for the community
- Show empathy towards other community members

### Unacceptable Behavior

- Harassment, trolling, or insulting comments
- Public or private harassment
- Publishing others' private information
- Any conduct inappropriate in a professional setting

---

## Getting Started

### Prerequisites

- Raspberry Pi 5 (recommended) or development machine
- Basic knowledge of:
  - C++/Qt 6 (for UI development)
  - Python 3 (for services)
  - Linux system administration
  - Automotive protocols (OBD-II, CAN bus)

### Development Setup

1. **Fork the repository**
   ```bash
   # Click "Fork" on GitHub, then clone your fork
   git clone https://github.com/YOUR_USERNAME/pidrivesmartos.git
   cd pidrivesmartos
   ```

2. **Install dependencies**
   ```bash
   sudo ./scripts/install_dependencies.sh
   ```

3. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Build the project**
   ```bash
   cd src/carui
   mkdir build && cd build
   qmake6 .. && make
   ```

---

## Development Workflow

### Branch Naming

- **Features**: `feature/description` (e.g., `feature/spotify-integration`)
- **Bugfixes**: `bugfix/issue-number` (e.g., `bugfix/123`)
- **Hotfixes**: `hotfix/description`
- **Documentation**: `docs/description`

### Commit Messages

Follow the **Conventional Commits** format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding/updating tests
- `chore`: Maintenance tasks

**Example**:
```
feat(obd): add support for diesel engine PIDs

- Implemented diesel-specific PIDs (0x63, 0x64)
- Added exhaust temperature monitoring
- Updated documentation

Closes #45
```

---

## Coding Standards

### C++ / Qt

- **Style**: Follow [Qt Coding Style](https://wiki.qt.io/Qt_Coding_Style)
- **Naming**:
  - Classes: `PascalCase` (e.g., `VehicleData`)
  - Functions: `camelCase` (e.g., `getSpeed()`)
  - Variables: `camelCase` with `m_` prefix for members (e.g., `m_speed`)
  - Constants: `UPPER_CASE` (e.g., `MAX_SPEED`)

- **Format with clang-format**:
  ```bash
  clang-format -i src/**/*.cpp src/**/*.h
  ```

### QML

- **Indentation**: 4 spaces
- **Naming**:
  - Components: `PascalCase` (e.g., `DashboardPage.qml`)
  - Properties: `camelCase` (e.g., `backgroundColor`)
  - IDs: `camelCase` (e.g., `speedGauge`)

### Python

- **Style**: Follow [PEP 8](https://pep8.org/)
- **Format with Black**:
  ```bash
  black src/obd_service/*.py
  ```

- **Type hints**: Use type annotations
  ```python
  def get_speed(self) -> float:
      return self.speed
  ```

- **Docstrings**: Use Google style
  ```python
  def calculate_rpm(a: int, b: int) -> int:
      """Calculate RPM from OBD response bytes.
      
      Args:
          a: First data byte
          b: Second data byte
          
      Returns:
          RPM value as integer
      """
      return ((a * 256) + b) / 4
  ```

---

## Testing

### Unit Tests (Qt/C++)

```bash
cd src/carui/tests
qmake6 && make check
```

### Unit Tests (Python)

```bash
pytest src/obd_service/tests/
```

### Integration Tests

```bash
# Start OBD simulator
python scripts/simulate_obd.py &

# Run CarUI in test mode
./build/carui --test

# Run integration tests
pytest tests/integration/
```

### Test Coverage

Aim for:
- **Unit tests**: 80%+ coverage
- **Critical paths**: 100% coverage

---

## Pull Request Process

### Before Submitting

- [ ] Code compiles without warnings
- [ ] All tests pass
- [ ] Code is formatted (clang-format, Black)
- [ ] Documentation is updated
- [ ] Commit messages follow conventions
- [ ] No merge conflicts with `main`

### Submitting

1. **Push your branch**
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Open a Pull Request** on GitHub
   - Use a descriptive title
   - Reference related issues (`Closes #123`)
   - Provide detailed description
   - Add screenshots/videos if UI changes

3. **PR Template**
   ```markdown
   ## Description
   Brief description of changes
   
   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Breaking change
   - [ ] Documentation update
   
   ## Testing
   How did you test this?
   
   ## Checklist
   - [ ] Code compiles
   - [ ] Tests pass
   - [ ] Documentation updated
   - [ ] No linter warnings
   ```

### Review Process

- **Maintainers** will review within 3-5 days
- Address review comments
- Once approved, a maintainer will merge

---

## Areas for Contribution

### High Priority

1. **Android Auto / Apple CarPlay integration**
2. **Offline map routing**
3. **Voice assistant (Mycroft/Rhasspy)**
4. **Lane detection (ADAS)**
5. **Performance optimization**

### Good First Issues

Look for issues labeled `good-first-issue`:
- Documentation improvements
- Bug fixes
- UI tweaks
- Test coverage improvements

### Feature Requests

See [GitHub Discussions](https://github.com/vtoxi/pidrivesmartos/discussions/categories/feature-requests) for community-requested features.

---

## Community

### Communication Channels

- **GitHub Discussions**: [Link](https://github.com/vtoxi/pidrivesmartos/discussions)
- **Discord**: [Join our server](https://discord.gg/pidrive)
- **Email**: dev@pidriveos.org

### Getting Help

- **Documentation**: Check `/docs` folder
- **FAQ**: See [GitHub Wiki](https://github.com/vtoxi/pidrivesmartos/wiki/FAQ)
- **Ask Questions**: Use GitHub Discussions Q&A

### Recognition

Contributors are recognized in:
- `README.md` contributors section
- Release notes
- Hall of Fame (for significant contributions)

---

## License

By contributing, you agree that your contributions will be licensed under the **Apache License 2.0**, same as the project.

---

**Thank you for making PiDriveSmartOS better! 🚗💨**

