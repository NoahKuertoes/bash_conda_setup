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
echo "Where would you like to uninstall anaconda from?"
echo "1. Uninstall for the current user (default)"
echo "2. Uninstall from the base directory (requires admin privileges)"
echo "3. Cancel uninstallation"
read -p "Enter your choice (1, 2, or 3): " UNINSTALL_OPTION

# 3.) Define the paths based on the user's choice
case "$UNINSTALL_OPTION" in
    1)
        if [[ "$OS" == "Windows" ]]; then
            INSTDIR="$HOME/anaconda3"
        else
            INSTDIR="$HOME/anaconda3"
        fi
        echo "anaconda will be uninstalled for the current user from: $INSTDIR";;
    2)
        if [[ "$OS" == "Windows" ]]; then
            INSTDIR="C:/anaconda3"
        else
            INSTDIR="/opt/anaconda3"
        fi
        echo "anaconda will be uninstalled from the base directory: $INSTDIR";;
    3)
        echo "Uninstallation canceled."
        exit 0;;
    *)
        echo "Invalid option. Uninstallation canceled."
        exit 1;;
esac

# 4.) Confirm the uninstallation process
echo "----------------------------"
read -p "Are you sure you want to uninstall anaconda from $INSTDIR? (y/n): " CONFIRM_UNINSTALL

if [[ "$CONFIRM_UNINSTALL" != "y" ]]; then
    echo "Uninstallation canceled."
    exit 0
fi

# 5.) Uninstall anaconda
echo "----------------------------"
if [[ "$OS" == "Windows" ]]; then
    echo "Uninstalling anaconda on Windows..."
    #adapt INSTDIR to be powershell compatible
    INSTDIR_WIN=$(echo "$INSTDIR" | sed 's|/c/|C:\\|; s|/|\\|g')
    echo $INSTDIR_WIN
    # Remove anaconda directory
    powershell.exe -Command "& {if (Test-Path \"$INSTDIR_WIN\") {Remove-Item -Recurse -Force \"$INSTDIR_WIN\"} else {Write-Host 'Path does not exist: $INSTDIR_WIN ...nothing happened...'}}"

else
    echo "Uninstalling anaconda on macOS/Linux..."
    if [[ -d "$INSTDIR" ]]; then
        echo "Removing anaconda installation directory..."
        rm -rf "$INSTDIR"
        echo "anaconda uninstalled from $INSTDIR."
    else
        echo "anaconda directory not found at $INSTDIR. Uninstallation may have failed or was already completed."
        exit 1
    fi

    # Remove anaconda from PATH in .bashrc or .zshrc
    echo "Removing anaconda from PATH in .bashrc or .zshrc..."
    sed -i '/anaconda3/d' ~/.bashrc ~/.zshrc 2>/dev/null
    source ~/.bashrc ~/.zshrc
    echo "anaconda removed from PATH."
fi

echo "anaconda uninstallation complete."
