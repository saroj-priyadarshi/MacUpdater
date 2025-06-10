# Installation Guide - Mac Software Updater

## Quick Start

### Option 1: Menu Bar Style App (Recommended)
```bash
cd MacUpdater
./mac_updater_app.sh
```

### Option 2: Simple Launcher
```bash
cd MacUpdater
./launch_updater.sh
```

### Option 3: Direct Script Usage
```bash
cd MacUpdater
./Scripts/mac_updater.sh
```

## What You Get

### 🖥️ Menu Bar Style Interface
- Beautiful terminal-based menu interface
- Easy navigation with numbered options
- Real-time update progress
- Built-in log viewer with color coding

### 📝 Interactive Script
- Step-by-step update process
- Full control over what gets updated
- Colored output for easy reading
- Comprehensive logging

### 🔧 Supported Software
- **Homebrew packages** (brew update, upgrade, cleanup)
- **Mac App Store apps** (via mas CLI)
- **Development tools** (npm, pip, git, docker, etc.)
- **Browsers** (Chrome, Firefox update checks)
- **macOS system updates**

## First Run Setup

The script will automatically:
1. Install Homebrew (if not present)
2. Install `mas` CLI tool (if not present)
3. Create log file at `~/.mac_updater.log`

## Usage Examples

### Quick Update Check
```bash
# Just check what needs updating
./launch_updater.sh
# Then choose "n" for most prompts to just see what's available
```

### Full System Update
```bash
# Update everything
./launch_updater.sh
# Then choose "y" for all categories you want to update
```

### Menu Bar Style App Usage
1. Run `./mac_updater_app.sh`
2. Choose from the menu options:
   - **1**: Run Full Update (Interactive)
   - **2**: Quick Check (See what needs updating)
   - **3**: View Update Log
   - **4**: Open Terminal Script
   - **5**: About
   - **6**: Quit

## Troubleshooting

### Script won't run
```bash
chmod +x MacUpdater/launch_updater.sh
chmod +x MacUpdater/Scripts/mac_updater.sh
```

### Menu app won't start
- Make sure scripts are executable: `chmod +x *.sh`
- Run from the MacUpdater directory
- Requires macOS with Terminal support

### Permission issues
- Some updates require admin privileges
- The script will prompt for sudo when needed
- Check System Preferences > Security & Privacy

## Customization

Edit `Scripts/mac_updater.sh` to:
- Add new package managers
- Modify update categories
- Change logging behavior
- Add custom update sources

## Files Created

- `~/.mac_updater.log` - Update activity log
- macOS UserDefaults - App preferences

No other files are created or modified on your system.
