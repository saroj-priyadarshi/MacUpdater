#!/bin/bash

# Mac Software Updater - Menu Bar Style Interface
# A terminal-based menu system that mimics a menu bar app experience

# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPDATER_SCRIPT="$SCRIPT_DIR/Scripts/mac_updater.sh"
LOG_FILE="$HOME/.mac_updater.log"

# Function to clear screen and show header
show_header() {
    clear
    echo -e "${BOLD}${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    🔄 Mac Software Updater                   ║"
    echo "║                     Menu Bar Style Interface                 ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo
}

# Function to show menu
show_menu() {
    echo -e "${BOLD}Choose an option:${NC}"
    echo
    echo -e "  ${BLUE}1.${NC} 🚀 Run Full Update (Interactive)"
    echo -e "  ${GREEN}2.${NC} 🔍 Quick Check (See what needs updating)"
    echo -e "  ${YELLOW}3.${NC} 📋 View Update Log"
    echo -e "  ${CYAN}4.${NC} 🛠️  Open Terminal Script"
    echo -e "  ${DIM}5.${NC} ℹ️  About"
    echo -e "  ${RED}6.${NC} ❌ Quit"
    echo
    echo -n "Enter your choice (1-6): "
}

# Function to show last update time
show_status() {
    if [ -f "$LOG_FILE" ]; then
        last_update=$(tail -1 "$LOG_FILE" 2>/dev/null | grep -o '^[^:]*' || echo "Never")
        echo -e "${DIM}Last update: $last_update${NC}"
    else
        echo -e "${DIM}Last update: Never${NC}"
    fi
    echo
}

# Function to run full update
run_full_update() {
    show_header
    echo -e "${BOLD}${GREEN}Starting Full Update Process...${NC}"
    echo
    
    if [ ! -f "$UPDATER_SCRIPT" ]; then
        echo -e "${RED}Error: Update script not found at $UPDATER_SCRIPT${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    chmod +x "$UPDATER_SCRIPT"
    "$UPDATER_SCRIPT"
    
    echo
    echo -e "${GREEN}Update process completed!${NC}"
    read -p "Press Enter to return to menu..."
}

# Function to run quick check
run_quick_check() {
    show_header
    echo -e "${BOLD}${YELLOW}Quick Update Check...${NC}"
    echo
    
    echo -e "${BLUE}Checking Homebrew packages...${NC}"
    if command -v brew >/dev/null 2>&1; then
        outdated_brew=$(brew outdated 2>/dev/null)
        if [ -n "$outdated_brew" ]; then
            echo -e "${YELLOW}Outdated Homebrew packages found:${NC}"
            echo "$outdated_brew"
        else
            echo -e "${GREEN}✅ All Homebrew packages are up to date${NC}"
        fi
    else
        echo -e "${DIM}Homebrew not installed${NC}"
    fi
    
    echo
    echo -e "${BLUE}Checking Mac App Store apps...${NC}"
    if command -v mas >/dev/null 2>&1; then
        outdated_mas=$(mas outdated 2>/dev/null)
        if [ -n "$outdated_mas" ]; then
            echo -e "${YELLOW}Outdated App Store apps found:${NC}"
            echo "$outdated_mas"
        else
            echo -e "${GREEN}✅ All App Store apps are up to date${NC}"
        fi
    else
        echo -e "${DIM}mas CLI not installed${NC}"
    fi
    
    echo
    echo -e "${BLUE}Checking system updates...${NC}"
    system_updates=$(softwareupdate -l 2>&1)
    if echo "$system_updates" | grep -q "No new software available"; then
        echo -e "${GREEN}✅ No system updates available${NC}"
    else
        echo -e "${YELLOW}System updates may be available${NC}"
    fi
    
    echo
    read -p "Press Enter to return to menu..."
}

# Function to view log
view_log() {
    show_header
    echo -e "${BOLD}${CYAN}Recent Update Log${NC}"
    echo
    
    if [ -f "$LOG_FILE" ]; then
        echo -e "${DIM}Showing last 20 entries from $LOG_FILE${NC}"
        echo
        tail -20 "$LOG_FILE" | while IFS= read -r line; do
            if [[ $line == *"[SUCCESS]"* ]]; then
                echo -e "${GREEN}$line${NC}"
            elif [[ $line == *"[WARNING]"* ]]; then
                echo -e "${YELLOW}$line${NC}"
            elif [[ $line == *"[ERROR]"* ]]; then
                echo -e "${RED}$line${NC}"
            else
                echo -e "${DIM}$line${NC}"
            fi
        done
    else
        echo -e "${DIM}No log file found. Run an update to create logs.${NC}"
    fi
    
    echo
    read -p "Press Enter to return to menu..."
}

# Function to open terminal script
open_terminal_script() {
    show_header
    echo -e "${BOLD}${CYAN}Opening Terminal Script...${NC}"
    echo
    
    if [ -f "$UPDATER_SCRIPT" ]; then
        osascript -e "tell application \"Terminal\" to do script \"cd '$SCRIPT_DIR' && ./Scripts/mac_updater.sh\""
        echo -e "${GREEN}Script opened in new Terminal window${NC}"
    else
        echo -e "${RED}Error: Script not found at $UPDATER_SCRIPT${NC}"
    fi
    
    echo
    read -p "Press Enter to return to menu..."
}

# Function to show about
show_about() {
    show_header
    echo -e "${BOLD}${CYAN}About Mac Software Updater${NC}"
    echo
    echo -e "${BOLD}Version:${NC} 1.0"
    echo -e "${BOLD}Author:${NC} Saroj Priyadarshi"
    echo -e "${BOLD}Description:${NC} A comprehensive tool to keep your Mac software up to date"
    echo
    echo -e "${BOLD}Features:${NC}"
    echo "• Interactive update process with full control"
    echo "• Support for Homebrew, Mac App Store, and system updates"
    echo "• Comprehensive logging and error handling"
    echo "• Menu bar style interface for easy access"
    echo
    echo -e "${BOLD}Supported Software:${NC}"
    echo "• Homebrew packages and casks"
    echo "• Mac App Store applications"
    echo "• Development tools (npm, pip, etc.)"
    echo "• Browser update checks"
    echo "• macOS system updates"
    echo
    read -p "Press Enter to return to menu..."
}

# Main loop
main() {
    while true; do
        show_header
        show_status
        show_menu
        
        read -r choice
        
        case $choice in
            1)
                run_full_update
                ;;
            2)
                run_quick_check
                ;;
            3)
                view_log
                ;;
            4)
                open_terminal_script
                ;;
            5)
                show_about
                ;;
            6)
                show_header
                echo -e "${GREEN}Thank you for using Mac Software Updater!${NC}"
                echo
                exit 0
                ;;
            *)
                show_header
                echo -e "${RED}Invalid option. Please choose 1-6.${NC}"
                sleep 2
                ;;
        esac
    done
}

# Check if script exists
if [ ! -f "$UPDATER_SCRIPT" ]; then
    echo -e "${RED}Error: mac_updater.sh not found at $UPDATER_SCRIPT${NC}"
    echo "Please make sure you're running this from the MacUpdater directory."
    exit 1
fi

# Run main function
main
