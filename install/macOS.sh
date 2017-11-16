#!/usr/bin/env sh

echo -e "\n\nSetting macOS settings"
echo "==============================="

# Close any open system preferences panes to prevent overwriting settings
osascript -e 'tell application "System Preferences" to quit'

# As for administrator password upfront and keep alive until done
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ---------------------------------------------------------------------
# General UI/UX
# ---------------------------------------------------------------------

# Disable sound effects on boot
sudo nvram SystemAudioVolume=" "

# Disable the "Are you sure you want to open this application" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false
