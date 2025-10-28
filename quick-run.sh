#!/bin/bash
# Quick launcher WITHOUT rebuild (for testing only)
# Use ./run.sh for development (always rebuilds)

clear
echo "╔════════════════════════════════════════════════════════╗"
echo "║     PiDriveSmartOS - Quick Launch (No Rebuild)    ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

cd "$(dirname "$0")"

# Check if binary exists
if [ ! -f "src/carui/build/carui" ]; then
    echo "[ERROR] Binary not found! Please run ./run.sh first to build."
    exit 1
fi

echo "[INFO] Launching existing build..."
./scripts/run_carui.sh --windowed "$@"

