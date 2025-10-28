#!/bin/bash
# Quick launcher for PiDriveSmartOS
# Place this in the project root for easy access
clear
echo "Running PiDriveSmartOS Car UI"
cd "$(dirname "$0")"
echo "Current directory: $(pwd)"
echo "Running carui script"
./scripts/run_carui.sh --windowed "$@"

