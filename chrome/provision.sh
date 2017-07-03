#!/usr/bin/env bash

# Adapted from https://github.com/Varying-Vagrant-Vagrants/vvv-utilities

### FUNCTIONS

network_detection() {
  # Network Detection
  #
  # Make an HTTP request to google.com to determine if outside access is available
  # to us. If 3 attempts with a timeout of 5 seconds are not successful, then we'll
  # skip a few things further in provisioning rather than create a bunch of errors.
  if [[ "$(wget --tries=3 --timeout=5 --spider --recursive --level=2 http://google.com 2>&1 | grep 'connected')" ]]; then
    echo "Network connection detected..."
    ping_result="Connected"
  else
    echo "Network connection not detected. Unable to reach google.com..."
    ping_result="Not Connected"
  fi
}

network_check() {
  network_detection
  if [[ ! "$ping_result" == "Connected" ]]; then
    echo -e "\nNo network connection available, skipping package installation"
    exit 0
  fi
}

network_check

wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
apt-get -y -f install
rm google-chrome-stable_current_amd64.deb
