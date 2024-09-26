#!/bin/bash

#SETUP ## 
# 0.) Define the download webpage from anaconda
ANACONDA_REPO="https://repo.anaconda.com/archive/"

# 1.) Get os system to download the right Anaconda file
echo "----------------------------"
OS=$(uname -s)
if [[ "$OS" == "Linux" ]]; then
    echo "You are running Linux."
elif [[ "$OS" == "Darwin" ]]; then
    echo "You are running macOS."
elif [[ "$OS" == "CYGWIN"* || "$OS" == "MINGW"* ]]; then
    echo "You are running Git Bash on Windows."
else
    echo "Unknown Operating System: $OS"
    exit 1
fi

# 2.) Fetch the first .exe, .pkg, and .sh file from repo depending on operating system
if [[ "$OS" == "CYGWIN"* || "$OS" == "MINGW"* ]]; then
    INSTALLER=$(curl -s $ANACONDA_REPO | grep -oP '(?<=href=")[^"]+\.exe' | head -n 1)
elif [[ "$OS" == "Darwin" ]]; then
    INSTALLER=$(curl -s $ANACONDA_REPO | grep -oP '(?<=href=")[^"]+\.pkg' | head -n 1)
elif [[ "$OS" == "Linux" ]]; then
    INSTALLER=$(curl -s $ANACONDA_REPO| grep -oP '(?<=href=")[^"]+\.sh' | head -n 1)
fi

# 3.) conatenate repo and file for download
ANACONDA_URL=$ANACONDA_REPO$INSTALLER

echo "retrieving instalation file:"
echo ">> "$ANACONDA_URL
echo "----------------------------"

# 4.) Ask the user whether to install Anaconda for the current user, system-wide, or cancel
echo "Where would you like to install Anaconda?"
echo "1. Install for the current user (default)"
echo "2. Install to base directory (requires admin privileges)"
echo "3. Cancel installation"
read -p "Enter your choice (1, 2, or 3): " INSTALL_OPTION

# Handle the user input
if [[ "$INSTALL_OPTION" == "3" ]]; then
    echo "Installation canceled."
    exit 0  # Exit the script without any error
elif [[ "$INSTALL_OPTION" == "2" ]]; then
    INSTDIR="C:/Anaconda3" # Base directory installation
    echo "Anaconda will be installed to the base directory: $INSTDIR"
elif [[ "$INSTALL_OPTION" == "1" ]]; then
    INSTDIR="$HOME/Anaconda3" # Current user installation
    echo "Anaconda will be installed for the current user in: $INSTDIR"
else
    echo "Installation canceled."
    exit 0  # Exit the script without any error
fi

# 5.) Download the Anaconda installer using curl
echo "----------------------------"
echo "Downloading the latest version of Anaconda..."
curl -L $ANACONDA_URL -o $INSTALLER

echo ">> "$INSTALLER

# Verify if the download was successful
if [[ $? -ne 0 ]]; then
    echo "Failed to download Anaconda. Exiting."
    exit 1
fi

# Run the installer silently using the chosen installation directory
echo "Running the Anaconda installer silently..."
./$INSTALLER /S /InstallationType=JustMe /RegisterPython=0 /AddToPath=0 /D=$INSTDIR

# Check if the installation was successful
if [[ $? -ne 0 ]]; then
    echo "Installation failed. Exiting."
    exit 1
fi

# Add Anaconda to PATH in Git Bash by appending it to ~/.bashrc
echo "Adding Anaconda to PATH..."
echo "export PATH=\"$INSTDIR/Scripts:$INSTDIR:$INSTDIR/Library/bin:\$PATH\"" >> ~/.bashrc

# Reload the .bashrc to apply the changes to the current session
source ~/.bashrc

# Clean up the installer file after installation
echo "Cleaning up..."
rm $INSTALLER

echo "----------------------------"
echo "Anaconda installation complete. You can now use 'conda' command in Git Bash."
