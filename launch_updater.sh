#!/bin/bash

# Mac Software Updater Launcher
# Simple launcher script for the Mac Software Updater

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPDATER_SCRIPT="$SCRIPT_DIR/Scripts/mac_updater.sh"

echo "🚀 Mac Software Updater Launcher"
echo "================================="
echo

# Check if the main script exists
if [ ! -f "$UPDATER_SCRIPT" ]; then
    echo "❌ Error: mac_updater.sh not found at $UPDATER_SCRIPT"
    exit 1
fi

# Make sure the script is executable
chmod +x "$UPDATER_SCRIPT"

# Check if we're in a terminal
if [ -t 0 ]; then
    echo "✅ Running in terminal - starting interactive updater..."
    echo
    exec "$UPDATER_SCRIPT"
else
    echo "🖥️  Opening in new Terminal window..."
    osascript -e "tell application \"Terminal\" to do script \"cd '$SCRIPT_DIR' && ./Scripts/mac_updater.sh\""
fi
