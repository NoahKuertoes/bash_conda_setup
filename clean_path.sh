#!/bin/bash

# SCRIPT INITIATION
echo "----------------------------"
echo "Checking directories in '\$PATH' variable:"
# Initialize variables to hold KEEP and REMOVE directories
KEEP=""
REMOVE=""

# CHECK PATH VARIABLES
IFS=':' read -ra dirs <<< "$PATH"
for dir in "${dirs[@]}"; do
  # Check if the directory exists
  if [ -d "$dir" ]; then
    # Append to KEEP variable
    KEEP="${KEEP}${dir}:"
  else
    # Append to REMOVE variable
    REMOVE="${REMOVE}${dir}:"
    # Remove the non-existent directory from PATH
    PATH=$(echo $PATH | sed -e "s|$dir:||" -e "s|:$dir||" -e "s|$dir||")
  fi
done

# REMOVE DUPLICATES FROM KEEP
# Convert KEEP to unique entries by splitting on `:`, then filtering duplicates
IFS=':' read -ra dirs <<< "$KEEP"
UNIQUE_KEEP=$(printf "%s\n" "${dirs[@]}" | awk '!seen[$0]++' | tr '\n' ':')

# Remove trailing colon from the UNIQUE_KEEP variable
UNIQUE_KEEP=$(echo "$UNIQUE_KEEP" | sed 's/:$//')

# OUTPUT
# Print all KEEP directories
IFS=':' read -ra dirs <<< "$UNIQUE_KEEP"
for dir in "${dirs[@]}"; do
  # echo individual KEEPs
  echo -e "KEEP\tdirectory present\t$dir"
done

## EXIT IF REMOVE is EMPTY!! ##
# Exit if there are no directories to remove
if [ -z "$REMOVE" ]; then
  echo "----------------------------"
  echo -e "PATH not updated\nAll directories present."
  exit 1
fi

echo "----------------------------"
# Print all REMOVE directories
IFS=':' read -ra dirs <<< "$REMOVE"
for dir in "${dirs[@]}"; do
  # echo individual REMOVE directories
  echo -e "REMOVE\tdirectory not found\t$dir"
done
echo "----------------------------"

# OVERWRITE PATH?
# Ask the user if they want to export the cleaned PATH
read -p "Do you want to export the cleaned PATH? [y/n]: " choice
echo "----------------------------"
# Check if the user input is 'y' or 'Y'
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
  # Export the cleaned and unique PATH
  export PATH="$UNIQUE_KEEP"
  echo "PATH has been updated:"
else
  echo "PATH was not updated:"
fi

# Print the cleaned PATH
echo "Cleaned PATH: $PATH"
echo "----------------------------"
