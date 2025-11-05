#!/bin/bash
echo "Installing Bongo Cat Automation requirements..."
while IFS= read -r pkg; do
  if ! dpkg -s "$pkg" >/dev/null 2>&1; then
    sudo apt-get install -y "$pkg"
  else
    echo "$pkg is already installed"
  fi
done < requirements.txt
echo "All required packages are now installed."
