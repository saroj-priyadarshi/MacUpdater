# Mac Software Updater

A comprehensive menu bar application and interactive script for keeping your Mac software up to date.

## Features

- **Menu Bar App**: Easy access from your Mac's menu bar
- **Interactive Script**: Step-by-step control over what gets updated
- **Comprehensive Updates**: Supports Homebrew, Mac App Store, browsers, and development tools
- **Update Logging**: Keeps track of all update activities
- **Quick Check**: Fast overview of available updates

## What Gets Updated

### Homebrew Packages
- Updates Homebrew itself
- Upgrades all installed packages
- Cleans up old versions and cache
- Runs Homebrew doctor for health checks

### Mac App Store Apps
- Uses `mas` CLI tool to update App Store applications
- Automatically installs `mas` if not present

### Browsers & Development Tools
- Chrome (auto-update reminder)
- Firefox (via Homebrew if installed)
- Node.js global packages (npm)
- Python packages (pip)
- Common development tools (git, docker, kubectl, etc.)

### System Updates
- macOS system updates
- Interactive prompts for restart-required updates

## Installation

### Option 1: Build from Source (Recommended)
1. Open `MacUpdater.xcodeproj` in Xcode
2. Build and run the project (⌘+R)
3. The app will appear in your menu bar

### Option 2: Use Script Only
1. Make the script executable:
   ```bash
   chmod +x Scripts/mac_updater.sh
   ```
2. Run the script:
   ```bash
   ./Scripts/mac_updater.sh
   ```

## Usage

### Menu Bar App
1. Click the update icon in your menu bar
2. Choose from the available options:
   - **Run Full Update**: Interactive update process
   - **Quick Check**: Fast check for available updates
   - **View Update Log**: See recent update activity
   - **Open Terminal Script**: Run the script in Terminal

### Interactive Script
The script will guide you through each update category:
1. Homebrew packages
2. Mac App Store apps
3. Browsers and development tools
4. macOS system updates

For each category, you can choose:
- Whether to proceed with updates
- Which specific updates to install
- Whether to perform cleanup operations

## Prerequisites

### Required
- macOS 13.0 or later
- Xcode 15.0 or later (for building the app)

### Optional (will be installed automatically if needed)
- **Homebrew**: Package manager for macOS
- **mas**: Mac App Store command line interface

## Configuration

The app stores preferences and logs in:
- **Log file**: `~/.mac_updater.log`
- **Preferences**: macOS UserDefaults

## Troubleshooting

### Common Issues

1. **"mas not found"**
   - The script will offer to install it via Homebrew
   - Or install manually: `brew install mas`

2. **"Homebrew not found"**
   - The script will offer to install Homebrew
   - Or install manually from: https://brew.sh

3. **Permission errors**
   - Some operations may require administrator privileges
   - The script will prompt for sudo when needed

4. **App doesn't appear in menu bar**
   - Check System Preferences > Security & Privacy
   - Allow the app to run if blocked

### Log Files

Check the update log for detailed information:
```bash
tail -f ~/.mac_updater.log
```

## Development

### Project Structure
```
MacUpdater/
├── MacUpdater/                 # SwiftUI app source
│   ├── MacUpdaterApp.swift    # Main app entry point
│   ├── MenuView.swift         # Menu bar interface
│   ├── UpdateWindowView.swift # Update process window
│   └── LogWindowView.swift    # Log viewer window
├── Scripts/
│   └── mac_updater.sh         # Interactive update script
└── MacUpdater.xcodeproj/      # Xcode project
```

### Building
1. Open `MacUpdater.xcodeproj` in Xcode
2. Select your development team in project settings
3. Build and run (⌘+R)

### Customization
You can modify the script to:
- Add support for additional package managers
- Customize update categories
- Change logging behavior
- Add new update sources

## Security

The app uses minimal permissions:
- **Network access**: For downloading updates
- **File system access**: For reading/writing log files
- **App sandbox**: Enabled for security

No personal data is collected or transmitted.

## License

Created by Saroj Priyadarshi. Free to use and modify.

## Contributing

Feel free to submit issues and enhancement requests!

## Version History

- **v1.0**: Initial release with menu bar app and interactive script
