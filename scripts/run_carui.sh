#!/bin/bash

##############################################################################
# PiDriveSmartOS - Car UI Launcher Script
# 
# This script launches the PiDriveSmartOS Car UI application
# with proper environment setup and error handling.
#
# Usage:
#   ./run_carui.sh [options]
#
# Options:
#   --windowed    Run in windowed mode (for development/testing)
#   --fullscreen  Run in fullscreen/kiosk mode (default for car)
#   --debug       Enable debug output
#   --rebuild     Rebuild before running
#   --help        Show this help message
#
##############################################################################

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project directories (absolute paths)
PROJECT_ROOT="/Users/faisalsideline/Desktop/Data/repos/vtoxi/PiDriveSmartOS"
CARUI_SOURCE="${PROJECT_ROOT}/src/carui"
CARUI_BUILD="${CARUI_SOURCE}/build"
CARUI_BINARY="${CARUI_BUILD}/carui"

# Default options
WINDOWED=false
DEBUG=false
REBUILD=false

##############################################################################
# Functions
##############################################################################

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}           ${GREEN}PiDriveSmartOS Car UI Launcher${NC}           ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

show_help() {
    cat << EOF
PiDriveSmartOS Car UI Launcher

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --windowed      Run in windowed mode (for development)
    --fullscreen    Run in fullscreen/kiosk mode (default)
    --debug         Enable debug output and logging
    --rebuild       Rebuild the application before running
    --help          Show this help message

EXAMPLES:
    # Run in windowed mode for testing:
    $0 --windowed

    # Run with debug output:
    $0 --debug --windowed

    # Rebuild and run:
    $0 --rebuild --windowed

    # Run in fullscreen (car mode):
    $0 --fullscreen

ENVIRONMENT:
    Project Root:  ${PROJECT_ROOT}
    Source Dir:    ${CARUI_SOURCE}
    Build Dir:     ${CARUI_BUILD}
    Binary:        ${CARUI_BINARY}

EOF
}

check_dependencies() {
    print_info "Checking dependencies..."
    
    # Check if Qt is available
    if ! command -v qmake6 &> /dev/null && ! command -v qmake &> /dev/null; then
        print_error "Qt 6 not found! Please install Qt 6 first."
        exit 1
    fi
    
    # Check if cmake is available
    if ! command -v cmake &> /dev/null; then
        print_error "CMake not found! Please install CMake first."
        exit 1
    fi
    
    print_success "All dependencies found"
}

build_application() {
    print_info "Building PiDriveSmartOS Car UI..."
    
    # Create build directory if it doesn't exist
    if [ ! -d "${CARUI_BUILD}" ]; then
        print_info "Creating build directory..."
        mkdir -p "${CARUI_BUILD}"
    fi
    
    # Navigate to build directory
    cd "${CARUI_BUILD}" || exit 1
    
    # Run CMake
    print_info "Running CMake..."
    if ! cmake -DCMAKE_BUILD_TYPE=Debug "${CARUI_SOURCE}"; then
        print_error "CMake configuration failed!"
        exit 1
    fi
    
    # Build with make
    print_info "Compiling (this may take a minute)..."
    if ! make -j4; then
        print_error "Build failed!"
        exit 1
    fi
    
    print_success "Build completed successfully"
}

check_binary() {
    if [ ! -f "${CARUI_BINARY}" ]; then
        print_warning "Binary not found. Building application..."
        build_application
    else
        print_success "Binary found: ${CARUI_BINARY}"
    fi
}

launch_application() {
    print_info "Launching PiDriveSmartOS Car UI..."
    
    # Build command line arguments
    ARGS=""
    
    if [ "$WINDOWED" = true ]; then
        ARGS="$ARGS --windowed"
        print_info "Mode: Windowed (development)"
    else
        print_info "Mode: Fullscreen (car mode)"
    fi
    
    if [ "$DEBUG" = true ]; then
        ARGS="$ARGS --debug"
        print_info "Debug output: Enabled"
    fi
    
    echo ""
    print_success "Starting application..."
    echo -e "${YELLOW}═══════════════════════════════════════════════════════${NC}"
    
    # Launch the application
    cd "${CARUI_BUILD}" || exit 1
    
    if [ "$DEBUG" = true ]; then
        # Run in foreground with debug output
        "${CARUI_BINARY}" $ARGS
    else
        # Run in background
        "${CARUI_BINARY}" $ARGS &
        APP_PID=$!
        sleep 2
        
        # Check if process is still running
        if ps -p $APP_PID > /dev/null 2>&1; then
            print_success "Application launched successfully (PID: $APP_PID)"
            echo ""
            print_info "To stop the application, run: kill $APP_PID"
        else
            print_error "Application failed to start!"
            exit 1
        fi
    fi
}

##############################################################################
# Main Script
##############################################################################

# Print header
print_header

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --windowed)
            WINDOWED=true
            shift
            ;;
        --fullscreen)
            WINDOWED=false
            shift
            ;;
        --debug)
            DEBUG=true
            shift
            ;;
        --rebuild)
            REBUILD=true
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Check if we're running on the correct system
if [ ! -d "${PROJECT_ROOT}" ]; then
    print_error "Project directory not found: ${PROJECT_ROOT}"
    print_warning "Please update the PROJECT_ROOT variable in this script"
    exit 1
fi

# Check dependencies
check_dependencies

# Rebuild if requested
if [ "$REBUILD" = true ]; then
    build_application
else
    check_binary
fi

# Launch the application
launch_application

echo ""
print_success "PiDriveSmartOS Car UI is running!"
echo ""

