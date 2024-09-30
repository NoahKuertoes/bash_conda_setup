#!/bin/bash

# Check if a string is passed as an argument
if [ -z "$1" ]; then
  echo "Please provide a string as an argument."
  exit 1
fi

# Check if the string contains only ASCII characters (0-127) and has no spaces
if [[ $(echo "$1" | tr -d '[\x00-\x7F]') == "" && ! "$1" =~ [[:space:]] ]]; then
  echo -e "CONFIRM: \tASCII conform \tno spaces:"
  echo "ASCII"
else
  echo -e "ATTENTION: \tNOT ASCII conform \tOR contains space."
  echo "OTHER"
fi

