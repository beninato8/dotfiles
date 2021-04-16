#!/bin/sh
# https://github.com/atomantic/dotfiles/blob/master/install.sh#L275-L1038

# Always boot in verbose mode (show terminal instead of loading bar)
sudo nvram boot-args="-v"

# Charging chime
defaults write com.apple.PowerChime ChimeOnAllHardware -bool true; open /System/Library/CoreServices/PowerChime.app

# Always show scroll bars
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# # "Save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# # "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# # "Disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

# # "Disable the crash reporter"
defaults write com.apple.CrashReporter DialogType -string "none"

# # "Set Help Viewer windows to non-floating mode"
defaults write com.apple.helpviewer DevMode -bool true

# # "Restart automatically if the computer freezes"
sudo systemsetup -setrestartfreeze on

# # "Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# # "Disable smart quotes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# # "Disable smart dashes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# # "Increase sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# # "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# # "Disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# # "Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# # "Disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

# "Keep folders on top when sorting by name (Sierra only)"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# "Disable window animations and Get Info animations"
defaults write com.apple.finder DisableAllAnimations -bool true

# "Set Desktop as the default location for new Finder windows"
# For other paths, use 'PfLo' and 'file:///full/path/here/'
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# "Show hidden files by default"
defaults write com.apple.finder AppleShowAllFiles -bool true

# "Show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# "Show status bar"
defaults write com.apple.finder ShowStatusBar -bool true

# "Show path bar"
defaults write com.apple.finder ShowPathbar -bool true

# "Allow text selection in Quick Look"
defaults write com.apple.finder QLEnableTextSelection -bool true

# "Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# "When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# "Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# "Enable spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# "Remove the spring loading delay for directories"
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# "Avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# "Use list view in all Finder windows by default"
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# "Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# "Empty Trash securely by default"
defaults write com.apple.finder EmptyTrashSecurely -bool true

# expanding the correct sections of get info
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true \
  Comments -bool false \
  MetaData -bool true \

# Most the dock settings are old

# Group windows by application in Mission Control"
defaults write com.apple.dock expose-group-apps -bool true

# "Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

defaults write com.apple.dock autohide-time-modifier -int 0

killall Dock