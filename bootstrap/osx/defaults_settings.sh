# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Disable automatic termination of inactive apps
# defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Set Help Viewer windows to non-floating mode
defaults write com.apple.helpviewer DevMode -bool true

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Enable the MacBook Air SuperDrive on any Mac
sudo nvram boot-args="mbasd=1"

# Show the $HOME/Library folder
chflags nohidden $HOME/Library

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool false

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
defaults write com.apple.dock persistent-apps -array

# Reset LaunchPad
defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock

# Animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool true

# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Enable the 2D Dock
#defaults write com.apple.dock no-glass -bool true


# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true





defaults write com.apple.finder QLEnableTextSelection -boolean YES;
defaults write com.apple.finder QLEnableXRayFolders -boolean YES

defaults write com.apple.finder AppleShowAllFiles -bool YES;

defaults write com.apple.finder _FXShowPosixPathInTitle -boolean YES;
defaults write com.apple.Finder FXPreferredViewStyle Nlsv;

defaults write com.apple.dock no-glass -bool YES
defaults write com.apple.dock showhidden -bool YES
defaults write com.apple.dock mouse-over-hilte-stack -boolean YES
defaults write com.apple.dock autohide-delay -bool NO
defaults write com.apple.dock use-new-list-stack -boolean YES

defaults write com.apple.dock mineffect SUCK
defaults write com.apple.dashboard mcx-disabled -bool YES

defaults write -g AppleEnableMenuBarTransparency -bool NO
defaults write com.apple.screencapture disable-shadow -bool YES

# '  -> Expand modal panels'
defaults write -g NSNavPanelExpandedStateForSaveMode -bool YES
defaults write -g PMPrintingExpandedStateForPrint -bool YES

# '  -> Remove annoying popups'
defaults write com.apple.frameworks.diskimages skip-verify -bool YES
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool YES
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool YES
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool NO
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool NO
defaults write com.apple.CrashReporter DialogType none
defaults write com.apple.LaunchServices LSQuarantine -bool NO
defaults write com.apple.finder FXEnableExtensionChangeWarning -boolean NO;

# '  -> Remove network .DS_Store'
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool YES

# 'Hidden utility lists'
defaults write com.apple.ScreenSharing ShowBonjourBrowser_Debug -boolean YES
defaults write com.apple.ScreenSharing debug -boolean YES

defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool YES


###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################


# SOURCE https://github.com/skryl/osx_bootstrap/

# Sources
#   http://secrets.blacktree.com
#   http://mths.be/osx
#   http://github.com/ptb/Mac-OS-X-Lion-Setup
#   $HOME/Library/Prefereces/*

# TODO
#  Keyboard Shortcuts

echo "Configuring System..."

###############################################################################
# General
###############################################################################
echo "  -> General"

### Pref Pane ###

# Appearance: Graphite
defaults write -g 'AppleAquaColorVariant' -int 6

# Highlight color: #CC99CC
defaults write -g 'AppleHighlightColor' -string '0.600000 0.800000 0.600000'

# Sidebar icon size: small
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

# Always show scroll bars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Close windows when quitting an application
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# FIXME Modify the number of items in the Open Recent menu
defaults write -g 'NSRecentDocumentsLimit' -int 0

# Text smoothing font limit
defaults write -g 'AppleAntiAliasingThreshold' -int 4


### Hidden ###

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Document autosave
# defaults write -g ApplePersistence -bool false

# <http://hints.macworld.com/article.php?story=20040423170608616>
# defaults write com.apple.dock 'pinning' -string 'start'

# <http://mattdanger.net/2008/12/common-mac-os-x-tweaks/>
defaults write com.apple.print.PrintingPrefs 'Quit When Finished' -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Set language and text formats
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en" "nl"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# smooth scrolling
defaults write NSGlobalDomain AppleScrollAnimationEnabled -bool true

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Disable opening and closing window animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Auto mount all disks before login
sudo defaults write /Library/Preferences/SystemConfiguration/ autodiskmount AutomountDisksWithoutUserLogin -bool true

# Number of recent items: Applications: None
osascript -e 'tell application "System Events" to tell appearance preferences to set recent applications limit to 0'

# Number of recent items: Documents: None
osascript -e 'tell application "System Events" to tell appearance preferences to set recent documents limit to 0'

# Number of recent items: Servers: None
osascript -e 'tell application "System Events" to tell appearance preferences to set recent servers limit to 0'


###############################################################################
# Desktop & Screensaver
###############################################################################
echo "  -> Desktop"

### Pref Pane ###

# Solid Colors: black
rm "$HOME/Library/Preferences/com.apple.desktop.plist" > /dev/null 2>&1
/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.desktop.plist" -c 'Add Background:default:BackgroundColor array' > /dev/null 2>&1
/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.desktop.plist" -c 'Add Background:default:BackgroundColor:0 real 0'
/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.desktop.plist" -c 'Add Background:default:BackgroundColor:1 real 0'
/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.desktop.plist" -c 'Add Background:default:BackgroundColor:2 real 0'
/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.desktop.plist" -c 'Add Background:default:DrawBackgroundColor bool true'
/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.desktop.plist" -c 'Add Background:default:ImageFilePath string /System/Library/PreferencePanes/DesktopScreenEffectsPref.prefPane/Contents/Resources/DesktopPictures.prefPane/Contents/Resources/Transparent.png'
/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.desktop.plist" -c 'Add Background:default:NoImage bool true'

# Menu bar transparency
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool true

# Start screensaver: Never
defaults -currentHost write com.apple.screensaver '{ idleTime = 0; moduleDict = { moduleName = Spectrum; path = "/System/Library/Screen Savers/Spectrum.qtz"; type = 1; }; }';

### Hidden ###

# Menu bar: show remaining battery percentage; hide time
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
defaults write com.apple.menuextra.battery ShowTime -string "NO"

# Menu bar: hide useless icons
defaults -currentHost write com.apple.systemuiserver dontAutoLoad -array-add  "/System/Library/CoreServices/Menu Extras/TimeMachine.menu"
defaults -currentHost write com.apple.systemuiserver dontAutoLoad -array-add  "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"
defaults -currentHost write com.apple.systemuiserver dontAutoLoad -array-add  "/System/Library/CoreServices/Menu Extras/Volume.menu"
defaults -currentHost write com.apple.systemuiserver dontAutoLoad -array-add  "/System/Library/CoreServices/Menu Extras/User.menu"

# Customize menu bar
defaults write com.apple.systemuiserver 'menuExtras' -array '/Library/Application\ Support/iStat\ local/extras/MenuCracker.menu' '/System/Library/CoreServices/Menu Extras/TextInput.menu' '/System/Library/CoreServices/Menu Extras/AirPort.menu' '/System/Library/CoreServices/Menu Extras/Battery.menu' '/System/Library/CoreServices/Menu Extras/Clock.menu' 

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Dock
###############################################################################
echo "  -> Dock"

### Pref Pane ###

# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 32

# Magnification off
defaults write com.apple.dock magnification -bool false

# Magnification size
defaults write com.apple.dock 'largesize' -int 64

# dock position
defaults write com.apple.dock orientation -string "Bottom"

# minimize effect
defaults write com.apple.dock mineffect -string "Scale"

# Minimize window when titlebar is double clicked
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool true

# minimize to application icon
defaults write com.apple.dock minimize-to-application -bool true

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true


### Hidden ###

# Disable Drag to Spaces
defaults write com.apple.dock workspaces-edge-delay -float 60

# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilte-stack -bool true

# Enable the 2D Dock
defaults write com.apple.dock no-glass -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Enable iTunes track notifications in the Dock
defaults write com.apple.dock itunes-notifications -bool true

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Remote autohide animation
defaults write com.apple.dock autohide-time-modifier -int 0

# Remove autohide delay
defaults write com.apple.dock autohide-delay -float 0

# Reset Launchpad
find $HOME/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete

# Dock App Icons
defaults write com.apple.dock 'checked-for-launchpad' -bool true

/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.dock.plist" -c 'Delete :persistent-apps'
/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.dock.plist" -c 'Add :persistent-apps array'
defaults write com.apple.dock 'persistent-apps' -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/System Preferences.app/</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock 'persistent-apps' -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iTunes.app/</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock 'persistent-apps' -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Calendar.app/</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock 'persistent-apps' -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Mail.app/</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock 'persistent-apps' -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iTerm.app/</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'


###############################################################################
# Mission Control
###############################################################################
echo "  -> Mission Control"

### Pref Pane ###

# Show dashboard as a space
defaults write com.apple.dock dashboard-in-overlay -bool false

# Don't automatically rearrange spaces
defaults write com.apple.dock mru-spaces -bool false

# Switch to app space during activation
defaults write NSGlobalDomain AppleSpacesSwitchOnActivate -bool true

# Group windows by app in expose
defaults write com.apple.dock expose-group-by-app -bool true

### Hidden ###

# Disable Dashboard
# defaults write com.apple.dashboard 'mcx-disabled' -bool true

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1


###############################################################################
# Language & Text
###############################################################################
echo "  -> Language"

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# FIXME Add Russian phonetic keyboard
defaults -currentHost write com.apple.HIToolbox AppleEnabledInputSources -array-add '{ InputSourceKind="Keyboard Layout"; "KeyboardLayout ID"=0; "KeyboardLayout Name"="US";}' '{ InputSourceKind="Keyboard Layout"; "KeyboardLayout ID"=19457; "KeyboardLayout Name"="Russian - Phonetic";}'


###############################################################################
# Security & Privacy
###############################################################################

# Ask for password 5 seconds after sleep
defaults write com.apple.screensaver 'askForPassword' -int 1
defaults write com.apple.screensaver 'askForPasswordDelay' -int 5

# Disable GakeKeeper
sudo spctl --master-disable

# Disable Firewall
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 0


###############################################################################
# Spotlight
###############################################################################
echo "  -> Spotlight"

### Hidden ###

# Spotlight menu keyboard shortcut: none
/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist" -c 'Delete AppleSymbolicHotKeys:64' > /dev/null 2>&1
/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist" -c 'Add AppleSymbolicHotKeys:64:enabled bool false'

# Spotlight window keyboard shortcut: none
/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist" -c 'Delete AppleSymbolicHotKeys:65' > /dev/null 2>&1
/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist" -c 'Add AppleSymbolicHotKeys:65:enabled bool false'

# Disable indexing
sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search

# Hide Spotlight icon
sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search

###############################################################################
# Displays
###############################################################################
echo "  -> Displays"

# Automatically adjust brightness: off
defaults write com.apple.BezelServices 'dAuto' -bool false

# sudo defaults write /Library/Preferences/com.apple.windowserver 'DisplayLayoutToRight' -bool true
# sudo defaults write /Library/Preferences/com.apple.windowserver 'DisplayMainOnInternal' -bool false

# Show all resolutions
sudo defaults delete /Library/Preferences/com.apple.windowserver 'DisplayResolutionDisabled' > /dev/null 2>&1
sudo defaults write /Library/Preferences/com.apple.windowserver 'DisplayResolutionEnabled' -bool true


###############################################################################
# Energy Saver
###############################################################################
echo "  -> Energy Saver"

# Battery

# Computer sleep: Never
sudo pmset -b sleep 30

# Display sleep: 10 min
sudo pmset -b displaysleep 10

# Put the hard disk(s) to sleep when possible: 10 min
sudo pmset -b disksleep 10

# Slightly dim the display when using this power source
sudo pmset -b lessbright 0

# Automatically reduce brightness before display goes to sleep
sudo pmset -b halfdim 0

# Restart automatically if the computer freezes
sudo pmset -b panicrestart 15

# Power Adapter

# Computer sleep: Never
sudo pmset -c sleep 0

# Display sleep: 10 min
sudo pmset -c displaysleep 10

# Put the hard disk(s) to sleep when possible: 10 min
sudo pmset -c disksleep 10

# Wake for network access
sudo pmset -c womp 1

# Automatically reduce brightness before display goes to sleep
sudo pmset -c halfdim 0

# Start up automatically after a power failure
sudo pmset -c autorestart 1

# Restart automatically if the computer freezes
sudo pmset -c panicrestart 15

# Show battery status in menu bar: off
# defaults -currentHost write com.apple.systemuiserver 'dontAutoLoad' -array-add '/System/Library/CoreServices/Menu Extras/Battery.menu'

###############################################################################
# Keyboard
###############################################################################
echo "  -> Keyboard"

### Pref Pane ###

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0
defaults write NSGlobalDomain InitialKeyRepeat -int 0

# Modifier Keys… > Apple Internal Keyboard / Trackpad > Caps Lock ( ⇪) Key: No Action
defaults -currentHost write -g 'com.apple.keyboard.modifiermapping.1452-566-0' -array '<dict><key>HIDKeyboardModifierMappingDst</key><integer>-1</integer><key>HIDKeyboardModifierMappingSrc</key><integer>0</integer></dict>'

# Modifier Keys… > Apple Keyboard [External] > Caps Lock ( ⇪) Key: No Action
defaults -currentHost write -g 'com.apple.keyboard.modifiermapping.1452-544-0' -array '<dict><key>HIDKeyboardModifierMappingDst</key><integer>-1</integer><key>HIDKeyboardModifierMappingSrc</key><integer>0</integer></dict>'

### Hidden ###

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Require fn key for special functions
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Automatically illuminate keyboard in low light: on
defaults write com.apple.BezelServices 'kDim' -bool true

# Turn off when computer is not used for: 5 mins
defaults write com.apple.BezelServices 'kDimTime' -int 300


###############################################################################
# Mouse & Trackpad
###############################################################################
echo "  -> Mouse"

# Mouse speed
defaults write -g com.apple.mouse.scaling -float 5

# Scrolling speed
defaults write -g com.apple.scrollwheel.scaling -float 3

# Double click speed
defaults write -g doubleClickThreshold -float 1.4

# Trackpad auto orientation
defaults write com.apple.trackpad.orientation TrackpadOrientationMode 1 
sudo defaults write com.apple.MultitouchSupport ForceAutoOrientation YES

# Trackpad speed
defaults write -g com.apple.trackpad.scaling -float 1

# Trackpad scrolling speed
defaults write -g com.apple.trackpad.scrolling -float 0.6875

# Active Tab: Point & Click
# defaults write com.apple.systempreferences 'trackpad.lastselectedtab' -int 0

# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1

# Map bottom left corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadLeftClick -bool true
defaults -currentHost write -g com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -int 1

# 3 finger tap off
defaults -currentHost write -g com.apple.trackpad.threeFingerTapGesture -int 0

# 3 finger drag off
defaults -currentHost write -g com.apple.trackpad.threeFingerDragGesture -int 0

# Scroll direction: natural: no
defaults write -g com.apple.swipescrolldirection -bool false

# Pinch gesture on
defaults -currentHost write -g com.apple.trackpad.pinchGesture -int 1

# Smart Zoom
defaults -currentHost write -g com.apple.trackpad.twoFingerDoubleTapGesture -int 1

# Rotate Gesture on
defaults -currentHost write -g com.apple.trackpad.rotateGesture -int 1

# Two finger swipe between pages
defaults write -g AppleEnableSwipeNavigateWithScrolls -int 1

# Three finger swipe between spaces
defaults -currentHost write -g com.apple.trackpad.threeFingerHorizSwipeGesture -int 2

# Notification center gesture on
defaults -currentHost write -g com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture -int 3

# Three finger vertical for Mission Control
defaults write com.apple.dock showMissionControlGestureEnabled -int 1

# Expose
defaults write com.apple.dock showAppExposeGestureEnabled -int 1

# Launchpad
defaults write com.apple.dock showLaunchpadGestureEnabled -int 1

# Desktop
defaults write com.apple.dock showDesktopGestureEnabled -int 1

###############################################################################
# Sound
###############################################################################
echo "  -> Sound"

# Select an alert sound: Sosumi
defaults write com.apple.systemsound 'com.apple.sound.beep.sound' -string '/System/Library/Sounds/Sosumi.aiff'

# Don't play user interface sound effects
defaults write com.apple.systemsound 'com.apple.sound.uiaudio.enabled' -int 0

# Don't play feedback when volume is changed
defaults write -g 'com.apple.sound.beep.feedback' -bool false


###############################################################################
# Network
###############################################################################
echo "  -> Network"

# Ethernet > Advanced… > DNS
# EN0=$(/usr/sbin/networksetup -listnetworkserviceorder | awk -F'\\) ' '/Ethernet/ { printf $2 }')
# /usr/sbin/networksetup -setdnsservers "$EN0" 127.0.0.1

# Wi-Fi > Advanced… > DNS
# EN1=$(/usr/sbin/networksetup -listnetworkserviceorder | awk -F'\\) ' '/Wi-Fi/ { printf $2 }')
# /usr/sbin/networksetup -setdnsservers "$EN1" 127.0.0.1


###############################################################################
# Bluetooth
###############################################################################
echo "  -> Bluetooth"

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40


###############################################################################
# Sharing
###############################################################################
echo "  -> Sharing"

# Computer Name: $COMPUTERNAME
# if [ ! "$(/usr/sbin/networksetup -getcomputername)" = "$COMPUTERNAME" ]; then
#   sudo /usr/sbin/networksetup -setcomputername $COMPUTERNAME
# fi

# Local Hostname: $LOCALHOSTNAME
# if [ ! "$(/usr/sbin/systemsetup -getlocalsubnetname)" = "Local Subnet Name: $LOCALHOSTNAME" ]; then
#   sudo /usr/sbin/systemsetup -setlocalsubnetname $LOCALHOSTNAME > /dev/null 2>&1
# fi

# Turn Printer Sharing on
# cupsctl --share-printers

# Turn SSH on
# systemsetup -setremotelogin on
# sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist


###############################################################################
# Users & Groups
###############################################################################
echo "  -> Users"

### [Right Click] > Advanced Options… > Login shell: /bin/zsh
if [ ! $SHELL = '/bin/zsh' ]; then
  chsh -s /bin/zsh
  sudo chsh -s /bin/zsh
fi

# Login Options > Display login window as: Name and password
# sudo defaults write /Library/Preferences/com.apple.loginwindow 'SHOWFULLNAME' -bool true

# Start on login
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/Adium.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/Alfred.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/BetterSnapTool.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/BetterTouchTool.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/Boom.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/Bowtie.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/Caffeine.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/Calendar.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/CalendarBar.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/CheatSheet.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/CoBook.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/Coffee Break.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/Dash.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/Divvy.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/Dropbox.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/GeekTool.app/Contents/Plugins/GeekTool.prefPane/Contents/Resources/GeekTool Helper.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/Google Drive.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/Mail.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/Plex Media Server.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/uTorrent.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/QuickCursor.app" }' > /dev/null 2>&1
osascript -e 'tell application "System Events" to make new login item at end of login items with properties { path: "/Applications/Wallpaper Wizard.app" }' > /dev/null 2>&1


###############################################################################
# Date & Time
###############################################################################
echo "  -> Time"

# Date options: Show time am/pm
defaults write com.apple.menuextra.clock 'DateFormat' -string 'h:mm a'

###############################################################################
# Software Update
###############################################################################
echo "  -> Updates"

# Check for updates: off
# sudo /usr/sbin/softwareupdate --schedule off > /dev/null 2>&1
# sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate 'ScheduleFrequency' -int -1
# sudo defaults write /private/var/db/launchd.db/com.apple.launchd/overrides 'com.apple.softwareupdatecheck.initial' -dict 'Disabled' -bool true
# sudo defaults write /private/var/db/launchd.db/com.apple.launchd/overrides 'com.apple.softwareupdatecheck.periodic' -dict 'Disabled' -bool true
# sudo plutil -convert xml1 /private/var/db/launchd.db/com.apple.launchd/overrides.plist

# Download updates automatically
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate 'AutomaticDownload' -int 1
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate 'ConfigDataInstall' -int 1


###############################################################################
# Speech
###############################################################################
echo "  -> Speech"

# Speak selected text when the key is pressed: on
defaults write com.apple.speech.synthesis.general.prefs 'SpokenUIUseSpeakingHotKeyFlag' -bool true


###############################################################################
# Time Machine
###############################################################################
echo "  -> Time Machine"

# Time Machine: off
# defaults write com.apple.TimeMachine 'AutoBackup' -bool false

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
hash tmutil &> /dev/null && sudo tmutil disablelocal


###############################################################################
# Accessibility
###############################################################################
echo "  -> Accessibility"

# Enable access for assistive devices
# osascript -e 'tell application "System Events" to set UI elements enabled to true'
echo -n 'a' | sudo tee /private/var/db/.AccessibilityAPIEnabled > /dev/null 2>&1 
sudo chmod 444 /private/var/db/.AccessibilityAPIEnabled

# Zoom: Options… > Smooth images (Press ⌥ ⌘\ to turn smoothing on or off): off
defaults write com.apple.universalaccess 'closeViewSmoothImages' -bool false

# Zoom: Options… > Use scroll wheel with modifier keys to zoom: on
defaults write com.apple.universalaccess 'closeViewScrollWheelToggle' -bool true
# Zoom: Options… > Use scroll wheel with modifier keys to zoom: ^ [control]
defaults write com.apple.universalaccess 'HIDScrollZoomModifierMask' -int 262144

# For difficulties seeing the cursor > Cursor Size: 1.5x
# defaults write com.apple.universalaccess 'mouseDriverCursorSize' -float 1.5

# Enable trackpad scrolling
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadScroll -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadMomentumScroll -int 1

# Enable trackpad dragging
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock -int 1

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" $HOME/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" $HOME/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" $HOME/Library/Preferences/com.apple.finder.plist

# Show item info to the right of the icons on the desktop
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" $HOME/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" $HOME/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" $HOME/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" $HOME/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" $HOME/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" $HOME/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" $HOME/Library/Preferences/com.apple.finder.plist

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Enable the MacBook Air SuperDrive on any Mac
sudo nvram boot-args="mbasd=1"

# Show the $HOME/Library folder
chflags nohidden $HOME/Library

###############################################################################
# Finder                                                                      #
###############################################################################
echo "Configuring Applications..."
echo "  -> Finder"

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder AnimateInfoPanes -bool false
defaults write com.apple.finder AnimateWindowZoom -bool false

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show hidden files by default
# defaults write com.apple.Finder AppleShowAllFiles -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Use current directory as default search scope in Finder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show Path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# no finder sounds
defaults write com.apple.finder 'FinderSounds' -bool false

# group by type
defaults write com.apple.finder 'FXPreferredGroupBy' -string 'Kind'

/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.finder.plist" -c 'Delete "StandardViewSettings:ExtendedListViewSettings:calculateAllSizes" bool'
/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.finder.plist" -c 'Add "StandardViewSettings:ExtendedListViewSettings:calculateAllSizes" bool true'

/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.finder.plist" -c 'Delete "StandardViewSettings:ExtendedListViewSettings:useRelativeDates" bool'
/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.finder.plist" -c 'Add "StandardViewSettings:ExtendedListViewSettings:useRelativeDates" bool false'

/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.finder.plist" -c 'Delete "StandardViewSettings:ListViewSettings:calculateAllSizes" bool'
/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.finder.plist" -c 'Add "StandardViewSettings:ListViewSettings:calculateAllSizes" bool true'

/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.finder.plist" -c 'Delete "StandardViewSettings:ListViewSettings:useRelativeDates" bool'
/usr/libexec/PlistBuddy "$HOME/Library/Preferences/com.apple.finder.plist" -c 'Add "StandardViewSettings:ListViewSettings:useRelativeDates" bool false'

# Show item info below icons on the desktop and in other icon views
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" $HOME/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" $HOME/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" $HOME/Library/Preferences/com.apple.finder.plist

# FIXME Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 12" $HOME/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 12" $HOME/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 12" $HOME/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 32" $HOME/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 32" $HOME/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 32" $HOME/Library/Preferences/com.apple.finder.plist

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Empty Trash securely by default
# defaults write com.apple.finder EmptyTrashSecurely -bool true

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Show the $HOME/Library folder
chflags nohidden $HOME/Library

# Remove Dropbox’s green checkmark icons in Finder
file=/Applications/Dropbox.app/Contents/Resources/check.icns
[ -e "$file" ] && mv -f "$file" "$file.bak"

###############################################################################
# Safari & WebKit                                                             #
###############################################################################
echo "  -> Safari"

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

###############################################################################
# Address Book, Dashboard, iCal, iTunes, Mail, and Disk Utility               #
###############################################################################
echo "  -> OSX Apps"

# Enable the debug menu in Address Book
defaults write com.apple.addressbook ABShowDebugMenu -bool true

# Enable Dashboard dev mode (allows keeping widgets on the desktop)
defaults write com.apple.dashboard devmode -bool true

# Enable the debug menu in iCal
defaults write com.apple.iCal IncludeDebugMenu -bool true

# Make the iTunes arrow links go to your library instead of the iTunes Store
defaults write com.apple.iTunes invertStoreLinks -bool true

# Disable the iTunes arrow links completely
defaults write com.apple.iTunes show-store-arrow-links -bool false

# Disable the Ping sidebar in iTunes
defaults write com.apple.iTunes disablePingSidebar -bool true

# Disable all the other Ping stuff in iTunes
defaults write com.apple.iTunes disablePing -bool true

# Make ⌘ + F focus the search input in iTunes
defaults write com.apple.iTunes NSUserKeyEquivalents -dict-add "Target Search Field" "@F"

# Disable send and reply animations in Mail.app
defaults write com.apple.Mail DisableReplyAnimations -bool true
defaults write com.apple.Mail DisableSendAnimations -bool true

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true

###############################################################################
# Transmission.app                                                            #
###############################################################################

# Use `$HOME/Documents/Torrents` to store incomplete downloads
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"

# Don’t prompt for confirmation before downloading
defaults write org.m0k.transmission DownloadAsk -bool false

# Trash original torrent files
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Hide the donate message
defaults write org.m0k.transmission WarningDonate -bool false
# Hide the legal disclaimer
defaults write org.m0k.transmission WarningLegal -bool false
