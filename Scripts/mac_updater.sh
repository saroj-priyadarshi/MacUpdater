#!/bin/bash

# Mac Software Updater Script
# Interactive script for updating Homebrew, Mac App Store, and other tools
# Author: Saroj Priyadarshi
# Date: $(date +%Y-%m-%d)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Log file
LOG_FILE="$HOME/.mac_updater.log"

# Function to print colored output
print_header() {
    echo -e "\n${BOLD}${CYAN}=== $1 ===${NC}\n"
}

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
    echo "$(date): [INFO] $1" >> "$LOG_FILE"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
    echo "$(date): [SUCCESS] $1" >> "$LOG_FILE"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
    echo "$(date): [WARNING] $1" >> "$LOG_FILE"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    echo "$(date): [ERROR] $1" >> "$LOG_FILE"
}

# Function to ask yes/no questions
ask_yes_no() {
    while true; do
        read -p "$1 (Y/n): " -n 1 -r
        echo
        case $REPLY in
            [Yy]* | "") return 0;;
            [Nn]*) return 1;;
            *) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to update Homebrew packages
update_homebrew() {
    print_header "HOMEBREW UPDATES"
    
    if ! command_exists brew; then
        print_warning "Homebrew not found."
        if ask_yes_no "Would you like to install Homebrew?"; then
            print_status "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            print_success "Homebrew installed!"
        else
            print_warning "Skipping Homebrew updates."
            return
        fi
    fi
    
    if ask_yes_no "Update Homebrew and all packages?"; then
        print_status "Updating Homebrew..."
        brew update
        
        print_status "Checking for outdated packages..."
        outdated=$(brew outdated)
        if [ -n "$outdated" ]; then
            echo -e "${YELLOW}Outdated packages:${NC}"
            echo "$outdated"
            echo
            
            if ask_yes_no "Upgrade all outdated packages?"; then
                print_status "Upgrading packages..."
                brew upgrade
                print_success "Packages upgraded!"
            else
                print_warning "Package upgrades skipped."
            fi
        else
            print_success "All Homebrew packages are up to date!"
        fi
        
        if ask_yes_no "Clean up old versions and cache?"; then
            print_status "Cleaning up Homebrew..."
            brew cleanup
            print_success "Cleanup completed!"
        fi
        
        print_status "Running Homebrew doctor..."
        brew doctor
    else
        print_warning "Homebrew updates skipped."
    fi
}

# Function to update Mac App Store apps
update_mas() {
    print_header "MAC APP STORE UPDATES"
    
    if ! command_exists mas; then
        print_warning "Mac App Store CLI (mas) not found."
        if command_exists brew; then
            if ask_yes_no "Install mas via Homebrew?"; then
                print_status "Installing mas..."
                brew install mas
                print_success "mas installed!"
            else
                print_warning "Skipping Mac App Store updates."
                return
            fi
        else
            print_warning "Please install Homebrew first or install mas manually."
            return
        fi
    fi
    
    if ask_yes_no "Update Mac App Store applications?"; then
        print_status "Checking for App Store updates..."
        outdated_apps=$(mas outdated)
        
        if [ -n "$outdated_apps" ]; then
            echo -e "${YELLOW}Outdated apps:${NC}"
            echo "$outdated_apps"
            echo
            
            if ask_yes_no "Update all App Store apps?"; then
                print_status "Updating App Store apps..."
                mas upgrade
                print_success "App Store apps updated!"
            else
                print_warning "App Store updates skipped."
            fi
        else
            print_success "All App Store apps are up to date!"
        fi
    else
        print_warning "Mac App Store updates skipped."
    fi
}

# Function to update browsers and development tools
update_browsers_tools() {
    print_header "BROWSERS & DEVELOPMENT TOOLS"
    
    if ask_yes_no "Check and update browsers/development tools?"; then
        
        # Check for Chrome updates
        if [ -d "/Applications/Google Chrome.app" ]; then
            print_status "Google Chrome is installed."
            print_status "Chrome auto-updates in the background. Check Chrome > About Google Chrome to verify latest version."
        fi
        
        # Check for Firefox (if installed via Homebrew)
        if command_exists firefox; then
            print_status "Firefox detected (Homebrew version)."
            if ask_yes_no "Update Firefox via Homebrew?"; then
                brew upgrade firefox
            fi
        elif [ -d "/Applications/Firefox.app" ]; then
            print_status "Firefox is installed (manual installation)."
            print_status "Firefox auto-updates. Check Firefox > About Firefox to verify latest version."
        fi
        
        # Update Node.js packages if npm exists
        if command_exists npm; then
            if ask_yes_no "Update global npm packages?"; then
                print_status "Updating npm itself..."
                npm install -g npm@latest
                
                print_status "Checking for outdated global packages..."
                outdated_npm=$(npm outdated -g --depth=0)
                if [ -n "$outdated_npm" ]; then
                    echo -e "${YELLOW}Outdated npm packages:${NC}"
                    echo "$outdated_npm"
                    
                    if ask_yes_no "Update all global npm packages?"; then
                        print_status "Updating global npm packages..."
                        npm update -g
                        print_success "npm packages updated!"
                    fi
                else
                    print_success "All npm packages are up to date!"
                fi
            fi
        fi
        
        # Update Python packages if pip exists
        if command_exists pip3; then
            if ask_yes_no "Update pip and check for outdated packages?"; then
                print_status "Updating pip..."
                pip3 install --upgrade pip
                
                print_status "Checking for outdated pip packages..."
                outdated_pip=$(pip3 list --outdated --format=freeze 2>/dev/null | grep -v '^\-e' | cut -d = -f 1)
                if [ -n "$outdated_pip" ]; then
                    echo -e "${YELLOW}Outdated pip packages:${NC}"
                    echo "$outdated_pip"
                    
                    if ask_yes_no "Update all pip packages? (This may take a while)"; then
                        print_status "Updating pip packages..."
                        pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U
                        print_success "pip packages updated!"
                    fi
                else
                    print_success "All pip packages are up to date!"
                fi
            fi
        fi
        
        # Check for common development tools
        tools=("git" "docker" "kubectl" "terraform" "ansible")
        for tool in "${tools[@]}"; do
            if command_exists "$tool"; then
                print_status "$tool is installed. Check for updates via Homebrew if installed that way."
            fi
        done
        
    else
        print_warning "Browser and tool updates skipped."
    fi
}

# Function to check system updates
update_system() {
    print_header "MACOS SYSTEM UPDATES"
    
    if ask_yes_no "Check for macOS system updates?"; then
        print_status "Checking for system updates..."
        
        # Check for available updates
        available_updates=$(softwareupdate -l 2>&1)
        
        if echo "$available_updates" | grep -q "No new software available"; then
            print_success "No system updates available."
        else
            echo -e "${YELLOW}Available system updates:${NC}"
            echo "$available_updates"
            echo
            
            if ask_yes_no "Install system updates? (This may require a restart)"; then
                print_status "Installing system updates..."
                sudo softwareupdate -i -a
                print_success "System updates installed!"
                print_warning "A restart may be required to complete the installation."
            else
                print_warning "System updates skipped."
            fi
        fi
    else
        print_warning "System update check skipped."
    fi
}

# Function to show summary
show_summary() {
    print_header "UPDATE SUMMARY"
    
    print_status "Update session completed at $(date)"
    print_status "Check the log file for details: $LOG_FILE"
    
    if ask_yes_no "Would you like to view the recent log entries?"; then
        echo -e "\n${CYAN}Recent log entries:${NC}"
        tail -20 "$LOG_FILE"
    fi
}

# Main function
main() {
    clear
    print_header "MAC SOFTWARE UPDATER"
    
    echo -e "${BOLD}Welcome to the Mac Software Updater!${NC}"
    echo "This script will help you update:"
    echo "• Homebrew packages"
    echo "• Mac App Store applications"
    echo "• Browsers and development tools"
    echo "• macOS system updates"
    echo
    
    # Initialize log
    echo "$(date): Starting update session" >> "$LOG_FILE"
    
    if ask_yes_no "Do you want to proceed with the update process?"; then
        update_homebrew
        update_mas
        update_browsers_tools
        update_system
        show_summary
    else
        print_warning "Update process cancelled."
    fi
    
    echo -e "\n${BOLD}${GREEN}Thank you for using Mac Software Updater!${NC}"
    echo "Press any key to exit..."
    read -n 1 -s
}

# Run main function
main "$@"
