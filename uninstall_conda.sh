#!/bin/bash

# 1.) Get the operating system
echo "----------------------------"
OS=$(uname -s)
case "$OS" in
    Linux*) OS="Linux";;
    Darwin*) OS="macOS";;
    CYGWIN*|MINGW*) OS="Windows";;
    *) echo "Unsupported operating system: $OS"; exit 1;;
esac
echo "Detected OS: $OS"

# 2.) Ask the user which installation to uninstall
echo "----------------------------"
echo "Where would you like to uninstall Anaconda from?"
echo "1. Uninstall for the current user (default)"
echo "2. Uninstall from the base directory (requires admin privileges)"
echo "3. Cancel uninstallation"
read -p "Enter your choice (1, 2, or 3): " UNINSTALL_OPTION

# 3.) Define the paths based on the user's choice
case "$UNINSTALL_OPTION" in
    1)
        if [[ "$OS" == "Windows" ]]; then
            INSTDIR="$HOME/Anaconda3"
        else
            INSTDIR="$HOME/Anaconda3"
        fi
        echo "Anaconda will be uninstalled for the current user from: $INSTDIR";;
    2)
        if [[ "$OS" == "Windows" ]]; then
            INSTDIR="C:/Anaconda3"
        else
            INSTDIR="/opt/Anaconda3"
        fi
        echo "Anaconda will be uninstalled from the base directory: $INSTDIR";;
    3)
        echo "Uninstallation canceled."
        exit 0;;
    *)
        echo "Invalid option. Uninstallation canceled."
        exit 1;;
esac

# 4.) Confirm the uninstallation process
echo "----------------------------"
read -p "Are you sure you want to uninstall Anaconda from $INSTDIR? (y/n): " CONFIRM_UNINSTALL

if [[ "$CONFIRM_UNINSTALL" != "y" ]]; then
    echo "Uninstallation canceled."
    exit 0
fi

# 5.) Uninstall Anaconda
echo "----------------------------"
if [[ "$OS" == "Windows" ]]; then
    echo "Uninstalling Anaconda on Windows..."
    #adapt INSTDIR to be powershell compatible
    INSTDIR_WIN=$(echo "$INSTDIR" | sed 's|/c/|C:\\|; s|/|\\|g')
    echo $INSTDIR_WIN
    # Remove Anaconda directory
    powershell.exe -Command "& {if (Test-Path \"$INSTDIR_WIN\") {Remove-Item -Recurse -Force \"$INSTDIR_WIN\"} else {Write-Host 'Path does not exist: $INSTDIR_WIN'}}"

else
    echo "Uninstalling Anaconda on macOS/Linux..."
    if [[ -d "$INSTDIR" ]]; then
        echo "Removing Anaconda installation directory..."
        rm -rf "$INSTDIR"
        echo "Anaconda uninstalled from $INSTDIR."
    else
        echo "Anaconda directory not found at $INSTDIR. Uninstallation may have failed or was already completed."
        exit 1
    fi

    # Remove Anaconda from PATH in .bashrc or .zshrc
    echo "Removing Anaconda from PATH in .bashrc or .zshrc..."
    sed -i '/Anaconda3/d' ~/.bashrc ~/.zshrc 2>/dev/null
    source ~/.bashrc ~/.zshrc
    echo "Anaconda removed from PATH."
fi

echo "Anaconda uninstallation complete."
