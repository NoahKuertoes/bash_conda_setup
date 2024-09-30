#!/bin/bash

#DEBUGGING Variables:
RM_INST=1 #Set to "=1" if you want to toggle off the installer removal

# Setup ##
# 0.) Define the download webpage from anaconda
ANACONDA_REPO="https://repo.anaconda.com/archive/"

# 1.) Get the operating system to download the right anaconda file
echo "----------------------------"
OS=$(uname -s)
case "$OS" in
    Linux*) OS="Linux";;
    Darwin*) OS="macOS";;
    CYGWIN*|MINGW*) OS="Windows";;
    *) echo "Unsupported operating system: $OS"; exit 1;;
esac
echo "Detected OS: $OS"

# 2.) Fetch the correct installer based on the operating system
case "$OS" in
    Linux) 
        INSTALLER=$(curl -s $ANACONDA_REPO | grep -oP '(?<=href=")[^"]+\.sh' | head -n 1);;
    macOS) 
        INSTALLER=$(curl -s $ANACONDA_REPO | grep -oP '(?<=href=")[^"]+\.pkg' | head -n 1);;
    Windows) 
        INSTALLER=$(curl -s $ANACONDA_REPO | grep -oP '(?<=href=")[^"]+\.exe' | head -n 1);;
esac

# 3.) Concatenate repo and file for download
echo "----------------------------"
ANACONDA_URL="$ANACONDA_REPO$INSTALLER"
echo "anaconda installer URL: $ANACONDA_URL"

# 4.) Ask the user where to install anaconda
echo "----------------------------"
echo "Where would you like to install anaconda?"
echo "1. Install for the current user (default)"
echo "2. Install to base directory (requires admin privileges)"
echo "3. Cancel installation"
read -p "Enter your choice (1, 2, or 3): " INSTALL_OPTION

# Handle the user input
case "$INSTALL_OPTION" in
    1) 
        if [[ "$OS" == "Windows" ]]; then
            INSTDIR="$HOME/anaconda3"
            INSTMODE="JustMe"
        else
            INSTDIR="$HOME/anaconda3"
        fi
        echo "anaconda will be installed for the current user in: $INSTDIR";;
    2) 
        if [[ "$OS" == "Windows" ]]; then
            INSTDIR="C:/anaconda3"
            INSTMODE="AllUsers"
        else
            INSTDIR="/opt/anaconda3"
        fi
        echo "anaconda will be installed to the base directory: $INSTDIR";;
    3) 
        echo "Installation canceled."
        exit 0;;
    *) 
        echo "Invalid option. Installation canceled."
        exit 1;;
esac

# 5.) Check if the installer already exists, if not, download it
echo "----------------------------"
if [[ -f "$INSTALLER" ]]; then
    echo "Installer already present: $INSTALLER. Skipping download."
else
    echo "Downloading the latest version of anaconda..."
    curl -L $ANACONDA_URL -o $INSTALLER

    # Verify if the download was successful
    if [[ $? -ne 0 ]]; then
        echo "Failed to download anaconda. Exiting."
        exit 1
    fi
fi

# 6.) Install anaconda
echo "----------------------------"
if [[ "$OS" == "Windows" ]]; then
    # Use PowerShell for silent installation on Windows
    echo "Running the anaconda installer silently using PowerShell..."
    powershell.exe -Command "& {Start-Process -FilePath './$INSTALLER' -ArgumentList '/S', '/InstallationType=$INSTMODE', '/RegisterPython=0', '/AddToPath=0', '/D=$INSTDIR' -NoNewWindow -Wait}"
    
    # Check if installation was successful
    if [ -d "$INSTDIR" ]; then
        echo "anaconda installed successfully at $INSTDIR."
        
        # Modify the PATH environment variable in Windows (User level)
        echo "Adding anaconda to the Windows PATH using PowerShell..."
        #powershell.exe -Command "[System.Environment]::SetEnvironmentVariable('PATH', \$env:PATH + ';$INSTDIR\\Scripts;$INSTDIR\\', 'User')"
        powershell.exe -Command "[System.Environment]::SetEnvironmentVariable('PATH', [System.Environment]::GetEnvironmentVariable('PATH', 'User') + ';$INSTDIR\\Scripts;$INSTDIR\\', 'User')"
        echo "PATH updated successfully."

    else
        echo "Installation failed. Exiting."
        exit 1
    fi
else
    # For macOS and Linux, use the downloaded script or package
    echo "Running the anaconda installer..."
    if [[ "$OS" == "macOS" ]]; then
        sudo installer -pkg "$INSTALLER" -target /
    elif [[ "$OS" == "Linux" ]]; then
        bash "$INSTALLER" -b -p "$INSTDIR"
    fi
    
    # Check if installation was successful
    if [ -d "$INSTDIR" ]; then
        echo "anaconda installed successfully at $INSTDIR."
    else
        echo "Installation failed. Exiting."
        exit 1
    fi

    # Add anaconda to PATH in Git Bash by appending to ~/.bashrc for Linux/macOS
    echo "Adding anaconda to PATH in .bashrc..."
    echo "export PATH=\"$INSTDIR/bin:\$PATH\"" >> ~/.bashrc
    source ~/.bashrc
fi

# Clean up the installer file after installation
echo "----------------------------"
if [[ "RM_INST " == "0" ]]; then
    echo "Cleaning up..."
    rm "$INSTALLER"
fi

echo "anaconda installation complete. You can now use 'conda' command."