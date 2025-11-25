#!/usr/bin/env bash
# mac.sh — configure and inspect macOS defaults for a new machine.
#
# Commands:
#   ./mac.sh apply [--hostname NAME] [--dry-run]
#   ./mac.sh diff [--hostname NAME]
#   ./mac.sh status
#   ./mac.sh snapshot
#   ./mac.sh --help
#
# `apply` enforces the curated defaults, taking an APFS snapshot first.
# `diff` shows only the settings that would change, with before → after values.
# `status` lists current and desired values without modifying anything.
# `snapshot` only creates a rollback snapshot (no other changes).

set -euo pipefail

US=$'\x1f' # separator for array values

ACTION="apply"
HOSTNAME=""
DRY_RUN=false
SUDO_KEEPALIVE_PID=""

declare -a SETTINGS=()
declare -a ARRAY_SETTINGS=()
declare -a REVERT_COMMANDS=()
declare -a REVERT_NOTES=()

usage() {
  cat <<'EOF'
Usage:
  mac.sh apply [--hostname NAME] [--dry-run]
  mac.sh diff [--hostname NAME]
  mac.sh status
  mac.sh snapshot
  mac.sh --help

Commands:
  apply     Apply curated macOS settings (creates a snapshot before changing anything).
  diff      Show only the settings that would change (current → desired).
  status    Display current and desired values for all settings.
  snapshot  Create an APFS snapshot without changing settings.

Options:
  --hostname, -n NAME  Set ComputerName/HostName/LocalHostName/NetBIOSName to NAME during apply/diff.
  --dry-run            Print the commands that would run during apply without executing them.
  --help, -h           Show this help message.
EOF
}

log() {
  local level=$1
  shift
  printf '[%s] %s\n' "$level" "$*"
}

section() {
  printf '\n## %s\n' "$1"
}

cleanup() {
  if [[ -n "$SUDO_KEEPALIVE_PID" ]] && kill -0 "$SUDO_KEEPALIVE_PID" 2>/dev/null; then
    kill "$SUDO_KEEPALIVE_PID"
  fi
}
trap cleanup EXIT

ask_for_sudo() {
  [[ $EUID -eq 0 ]] && return
  log INFO "Requesting sudo privileges…"
  sudo -v
  (
    while true; do
      sudo -n true
      sleep 60
    done
  ) &
  SUDO_KEEPALIVE_PID=$!
}

run() {
  if $DRY_RUN; then
    log DRY "$*"
    return 0
  fi
  log RUN "$*"
  "$@"
}

normalize_value() {
  local type=$1 value=$2
  if [[ "$value" == "__absent__" ]]; then
    echo "absent"
    return
  fi
  case "$type" in
  bool)
    case "$value" in
    1 | true | TRUE | yes | YES) echo "true" ;;
    0 | false | FALSE | no | NO) echo "false" ;;
    *) echo "$value" ;;
    esac
    ;;
  string | int | float)
    echo "$value"
    ;;
  array)
    printf '%s' "$value" | tr -d '()",' | tr -s '[:space:]' ' ' | xargs
    ;;
  *)
    echo "$value"
    ;;
  esac
}

add_setting() {
  local scope=$1 domain=$2 key=$3 type=$4 desired=$5 description=$6 flags=${7:-}
  SETTINGS+=("$scope|$domain|$key|$type|$desired|$description|$flags")
}

add_array_setting() {
  local scope=$1 domain=$2 key=$3 description=$4
  shift 4
  local values
  values=$(printf '%s' "$*" | tr ' ' "$US")
  ARRAY_SETTINGS+=("$scope|$domain|$key|$description|$values")
}

read_default() {
  local scope=$1 domain=$2 key=$3
  local cmd=(defaults read "$domain" "$key")
  [[ "$scope" == "current" ]] && cmd=(defaults -currentHost read "$domain" "$key")
  "${cmd[@]}" 2>/dev/null || echo "__absent__"
}

write_default() {
  local scope=$1 domain=$2 key=$3 type=$4 desired=$5
  local cmd=(defaults write "$domain" "$key")
  [[ "$scope" == "current" ]] && cmd=(defaults -currentHost write "$domain" "$key")
  case "$type" in
  bool) run "${cmd[@]}" -bool "$desired" ;;
  string) run "${cmd[@]}" -string "$desired" ;;
  int) run "${cmd[@]}" -int "$desired" ;;
  float) run "${cmd[@]}" -float "$desired" ;;
  *) run "${cmd[@]}" -"$type" "$desired" ;;
  esac
}

write_array() {
  local scope=$1 domain=$2 key=$3 values_str=$4
  IFS="$US" read -ra parts <<<"$values_str"
  local cmd=(defaults write "$domain" "$key" -array "${parts[@]}")
  [[ "$scope" == "current" ]] && cmd=(defaults -currentHost write "$domain" "$key" -array "${parts[@]}")
  if $DRY_RUN; then
    log DRY "${cmd[*]}"
  else
    log RUN "${cmd[*]}"
    "${cmd[@]}"
  fi
}

build_defaults_command() {
  local scope=$1 domain=$2 key=$3 type=$4 value=$5
  local prefix=(defaults)
  if [[ "$domain" == /* ]]; then
    prefix=(sudo defaults)
  fi
  if [[ "$scope" == "current" ]]; then
    prefix+=(-currentHost)
  fi
  local cmd
  case "$type" in
  bool)
    printf -v cmd '%s write %q %q -bool %s' "${prefix[*]}" "$domain" "$key" "$value"
    ;;
  int | float)
    printf -v cmd '%s write %q %q -%s %s' "${prefix[*]}" "$domain" "$key" "$type" "$value"
    ;;
  string)
    printf -v cmd '%s write %q %q -string %q' "${prefix[*]}" "$domain" "$key" "$value"
    ;;
  array)
    local normalized="$value"
    local cmd_prefix
    printf -v cmd_prefix '%s write %q %q -array' "${prefix[*]}" "$domain" "$key"
    local out="$cmd_prefix"
    if [[ -n "$normalized" ]]; then
      local item
      while read -r item; do
        out+=" $(printf '%q' "$item")"
      done < <(printf '%s\n' "$normalized" | tr ' ' '\n')
    fi
    cmd="$out"
    ;;
  delete)
    printf -v cmd '%s delete %q %q' "${prefix[*]}" "$domain" "$key"
    ;;
  *)
    printf -v cmd '# Unsupported revert for %s:%s' "$domain" "$key"
    ;;
  esac
  printf '%s' "$cmd"
}

record_revert() {
  local scope=$1 domain=$2 key=$3 type=$4 raw_value=$5 description=$6
  if $DRY_RUN; then
    return
  fi
  raw_value=$(printf '%s' "$raw_value")
  local cmd
  if [[ "$raw_value" == "__absent__" ]]; then
    cmd=$(build_defaults_command "$scope" "$domain" "$key" delete "")
  else
    case "$type" in
    bool)
      local normalized
      normalized=$(normalize_value bool "$raw_value")
      cmd=$(build_defaults_command "$scope" "$domain" "$key" bool "$normalized")
      ;;
    int)
      cmd=$(build_defaults_command "$scope" "$domain" "$key" int "$raw_value")
      ;;
    float)
      cmd=$(build_defaults_command "$scope" "$domain" "$key" float "$raw_value")
      ;;
    string)
      cmd=$(build_defaults_command "$scope" "$domain" "$key" string "$raw_value")
      ;;
    array)
      local normalized
      normalized=$(normalize_value array "$raw_value")
      if [[ -z "$normalized" ]]; then
        cmd=$(build_defaults_command "$scope" "$domain" "$key" delete "")
      else
        cmd=$(build_defaults_command "$scope" "$domain" "$key" array "$normalized")
      fi
      ;;
    *)
      cmd="# Unsupported revert for $domain:$key"
      ;;
    esac
  fi
  REVERT_COMMANDS+=("$cmd|$description")
}

process_setting() {
  local mode=$1 entry=$2
  IFS='|' read -r scope domain key type desired description flags <<<"$entry"
  local current raw_current desired_norm current_norm display_current
  raw_current=$(read_default "$scope" "$domain" "$key")
  current_norm=$(normalize_value "$type" "$raw_current")
  desired_norm=$(normalize_value "$type" "$desired")
  display_current="$current_norm"

  local treat_absent=false
  if [[ "$raw_current" == "__absent__" && "$flags" == *absent-ok* ]]; then
    treat_absent=true
    display_current="system-default"
    current_norm="$desired_norm"
  fi

  case "$mode" in
  status)
    printf '%-60s current=%-12s desired=%-8s %s\n' "${domain}:${key}" "$display_current" "$desired_norm" "$description"
    ;;
  diff)
    if [[ "$current_norm" != "$desired_norm" ]]; then
      printf '%-60s %s -> %s  %s\n' "${domain}:${key}" "$display_current" "$desired_norm" "$description"
    fi
    ;;
  apply)
    if [[ "$current_norm" == "$desired_norm" ]]; then
      if $treat_absent; then
        log SKIP "$description (uses system default matching desired)"
      else
        log SKIP "$description (already $desired_norm)"
      fi
    else
      log APPLY "$description ($display_current -> $desired_norm)"
      record_revert "$scope" "$domain" "$key" "$type" "$raw_current" "$description"
      write_default "$scope" "$domain" "$key" "$type" "$desired"
    fi
    ;;
  esac
}

process_array_setting() {
  local mode=$1 entry=$2
  IFS='|' read -r scope domain key description values <<<"$entry"
  local current raw_current current_norm desired_list desired_norm
  raw_current=$(read_default "$scope" "$domain" "$key")
  current_norm=$(normalize_value array "$raw_current")
  IFS="$US" read -ra desired_list <<<"$values"
  desired_norm=$(printf '%s\n' "${desired_list[@]}" | xargs)

  case "$mode" in
  status)
    printf '%-60s current=%s desired=%s %s\n' "${domain}:${key}" "$current_norm" "$desired_norm" "$description"
    ;;
  diff)
    if [[ "$current_norm" != "$desired_norm" ]]; then
      printf '%-60s %s -> %s  %s\n' "${domain}:${key}" "$current_norm" "$desired_norm" "$description"
    fi
    ;;
  apply)
    if [[ "$current_norm" == "$desired_norm" ]]; then
      log SKIP "$description (already ${desired_norm})"
    else
      log APPLY "$description (${current_norm:-absent} -> ${desired_norm})"
      record_revert "$scope" "$domain" "$key" "array" "$raw_current" "$description"
      write_array "$scope" "$domain" "$key" "$values"
    fi
    ;;
  esac
}

process_settings() {
  local mode=$1
  for entry in "${SETTINGS[@]}"; do
    process_setting "$mode" "$entry"
  done
  for entry in "${ARRAY_SETTINGS[@]}"; do
    process_array_setting "$mode" "$entry"
  done
}

get_scutil_value() {
  local key=$1 value rc=0
  value=$(scutil --get "$key" 2>&1) || rc=$?
  if [[ $rc -eq 0 ]]; then
    printf '%s' "$value"
  else
    printf 'unset'
  fi
}

get_defaults_value() {
  local domain=$1 key=$2 value rc=0
  value=$(defaults read "$domain" "$key" 2>/dev/null) || rc=$?
  if [[ $rc -eq 0 ]]; then
    printf '%s' "$value"
  else
    printf 'unset'
  fi
}

record_hostname_revert() {
  $DRY_RUN && return
  local label=$1 previous=$2
  local cmd
  if [[ -z "$previous" || "$previous" == "unset" ]]; then
    cmd="# Revert $label via System Settings if needed (was unset)"
  else
    printf -v cmd 'sudo scutil --set %s %q' "$label" "$previous"
  fi
  REVERT_COMMANDS+=("$cmd|$label")
}

report_hostname() {
  section "Computer identity"
  local computer host local_host netbios
  computer=$(get_scutil_value ComputerName)
  host=$(get_scutil_value HostName)
  local_host=$(get_scutil_value LocalHostName)
  netbios=$(get_defaults_value /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName)
  printf '  ComputerName   : %s\n' "$computer"
  printf '  HostName       : %s\n' "$host"
  printf '  LocalHostName  : %s\n' "$local_host"
  printf '  NetBIOSName    : %s\n' "$netbios"
}

set_hostname() {
  local new_name=$1
  [[ -z "$new_name" ]] && return
  local sanitized local_name netbios current
  sanitized=$(printf '%s' "$new_name" | sed 's/[^[:alnum:]-]/-/g')
  sanitized=${sanitized//--/-}
  sanitized=${sanitized#-}
  sanitized=${sanitized%-}
  [[ -z "$sanitized" ]] && sanitized=$new_name
  local_name=${sanitized%%.*}
  netbios=$(printf '%s' "$sanitized" | tr '[:lower:]' '[:upper:]' | cut -c1-15)

  section "Setting hostname"

  current=$(scutil --get ComputerName 2>/dev/null || echo "")
  if [[ "$current" != "$new_name" ]]; then
    log APPLY "ComputerName -> $new_name"
    record_hostname_revert ComputerName "$current"
    run sudo scutil --set ComputerName "$new_name"
  else
    log SKIP "ComputerName already $new_name"
  fi

  current=$(scutil --get HostName 2>/dev/null || echo "")
  if [[ "$current" != "$sanitized" ]]; then
    log APPLY "HostName -> $sanitized"
    record_hostname_revert HostName "$current"
    run sudo scutil --set HostName "$sanitized"
  else
    log SKIP "HostName already $sanitized"
  fi

  current=$(scutil --get LocalHostName 2>/dev/null || echo "")
  if [[ "$current" != "$local_name" ]]; then
    log APPLY "LocalHostName -> $local_name"
    record_hostname_revert LocalHostName "$current"
    run sudo scutil --set LocalHostName "$local_name"
  else
    log SKIP "LocalHostName already $local_name"
  fi

  current=$(defaults read /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName 2>/dev/null || echo "")
  if [[ "$current" != "$netbios" ]]; then
    log APPLY "NetBIOSName -> $netbios"
    if ! $DRY_RUN; then
      record_revert standard /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName string "$current" "NetBIOSName"
    fi
    run sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$netbios"
  else
    log SKIP "NetBIOSName already $netbios"
  fi
}

hostname_diff() {
  local new_name=$1
  [[ -z "$new_name" ]] && return
  local sanitized local_name netbios
  sanitized=$(printf '%s' "$new_name" | sed 's/[^[:alnum:]-]/-/g')
  sanitized=${sanitized//--/-}
  sanitized=${sanitized#-}
  sanitized=${sanitized%-}
  [[ -z "$sanitized" ]] && sanitized=$new_name
  local_name=${sanitized%%.*}
  netbios=$(printf '%s' "$sanitized" | tr '[:lower:]' '[:upper:]' | cut -c1-15)

  section "Hostname diff"
  printf '%-18s %s -> %s\n' "ComputerName" "$(scutil --get ComputerName 2>/dev/null || echo unset)" "$new_name"
  printf '%-18s %s -> %s\n' "HostName" "$(scutil --get HostName 2>/dev/null || echo unset)" "$sanitized"
  printf '%-18s %s -> %s\n' "LocalHostName" "$(scutil --get LocalHostName 2>/dev/null || echo unset)" "$local_name"
  printf '%-18s %s -> %s\n' "NetBIOSName" "$(defaults read /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName 2>/dev/null || echo unset)" "$netbios"
}

configure_settings_catalog() {
  # Locale & Measurement
  add_array_setting standard NSGlobalDomain AppleLanguages "Preferred languages" "en-US" "nb-NO"
  add_setting standard NSGlobalDomain AppleLocale string "en_NO" "Locale"
  add_setting standard NSGlobalDomain AppleInterfaceStyle string "Dark" "Default appearance"
  add_setting standard NSGlobalDomain AppleMeasurementUnits string "Centimeters" "Measurement units" "absent-ok"
  add_setting standard NSGlobalDomain AppleMetricUnits bool true "Use metric units" "absent-ok"
  add_setting standard NSGlobalDomain AppleTemperatureUnit string "Celsius" "Temperature unit" "absent-ok"

  # Control Center & Menu bar
  add_setting current com.apple.controlcenter Battery int 16 "Show battery in Control Center"
  add_setting current com.apple.controlcenter BatteryShowPercentage bool true "Show battery percentage"
  add_setting current com.apple.controlcenter Sound int 16 "Show sound control"
  add_setting current com.apple.controlcenter Bluetooth int 16 "Show Bluetooth in menu bar"
  add_setting current com.apple.controlcenter FocusModes int 2 "Display focus modes when active"
  add_setting current com.apple.controlcenter Siri int 8 "Keep Siri in Control Center"
  add_setting current com.apple.controlcenter Clock int 16 "Show Clock in menu bar"
  add_setting standard com.apple.menuextra.clock DateFormat string "EEE d MMM HH:mm:ss" "Menu bar clock format"
  add_setting standard com.apple.menuextra.clock Show24Hour bool true "24-hour clock"
  add_setting standard com.apple.menuextra.clock ShowDate bool true "Show date in menu bar"
  add_setting standard com.apple.menuextra.clock ShowDayOfWeek bool true "Show day of week"
  add_setting standard com.apple.menuextra.clock ShowSeconds bool true "Show seconds"

  # General UI
  add_setting standard com.apple.dock expose-group-apps bool true "Group Mission Control windows" # Aerospace fix for small windows
  add_setting standard com.apple.spaces spans-displays bool true "Don't use separate spaces on multiple monitors"
  add_setting standard NSGlobalDomain NSDocumentSaveNewDocumentsToCloud bool false "Save to disk by default"
  add_setting standard NSGlobalDomain NSNavPanelExpandedStateForSaveMode bool true "Expand save panel"
  add_setting standard NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 bool true "Expand save panel (2)"
  add_setting standard NSGlobalDomain PMPrintingExpandedStateForPrint bool true "Expand print dialog"
  add_setting standard NSGlobalDomain PMPrintingExpandedStateForPrint2 bool true "Expand print dialog (2)"
  add_setting standard com.apple.print.PrintingPrefs "Quit When Finished" bool true "Quit printer app post-job"
  add_setting standard com.apple.LaunchServices LSQuarantine bool false "Disable app quarantine prompts"
  add_setting standard com.apple.systempreferences NSQuitAlwaysKeepsWindows bool false "Disable resume system-wide"
  add_setting standard com.apple.CrashReporter DialogType string "none" "Disable crash reporter dialog"
  add_setting standard NSGlobalDomain com.apple.sound.beep.feedback bool false "Disable volume change sound"

  # Keyboard & Input
  add_setting standard NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled bool false "Disable smart quotes"
  add_setting standard NSGlobalDomain NSAutomaticDashSubstitutionEnabled bool false "Disable smart dashes"
  add_setting standard NSGlobalDomain AppleKeyboardUIMode int 3 "Enable full keyboard access"
  add_setting standard NSGlobalDomain ApplePressAndHoldEnabled bool false "Disable press-and-hold"
  add_setting standard NSGlobalDomain KeyRepeat int 1 "Key repeat speed"
  add_setting standard NSGlobalDomain InitialKeyRepeat int 10 "Key repeat delay"
  add_setting standard com.apple.BezelServices kDim bool true "Auto illuminate keyboard"
  add_setting standard com.apple.BezelServices kDimTime int 300 "Keyboard backlight timeout"
  add_setting standard NSGlobalDomain NSAutomaticSpellingCorrectionEnabled bool false "Disable autocorrect"

  # Trackpad & Mouse
  add_setting standard com.apple.AppleMultitouchTrackpad Clicking bool true "Tap to click (built-in)"
  add_setting standard com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking bool true "Tap to click (Bluetooth)"
  add_setting current NSGlobalDomain com.apple.mouse.tapBehavior int 1 "Tap to click at login window"
  add_setting standard NSGlobalDomain com.apple.mouse.tapBehavior int 1 "Tap to click (user)"
  add_setting standard com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick int 2 "Secondary click bottom-right"
  add_setting standard com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick bool true "Enable secondary click"
  add_setting current NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior int 1 "Corner click behaviour"
  add_setting current NSGlobalDomain com.apple.trackpad.enableSecondaryClick bool true "Secondary click (current host)"
  add_setting standard NSGlobalDomain AppleEnableSwipeNavigateWithScrolls bool true "Swipe to navigate"
  add_setting current NSGlobalDomain com.apple.trackpad.threeFingerHorizSwipeGesture int 1 "Three finger swipe (current host)"
  add_setting standard com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture int 1 "Three finger swipe"
  add_setting standard com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" int 40 "Improve Bluetooth audio"

  # Screen & screenshots
  add_setting standard com.apple.screensaver askForPassword int 1 "Require password after sleep"
  add_setting standard com.apple.screensaver askForPasswordDelay int 0 "Password immediately after sleep"
  add_setting standard com.apple.screencapture location string "${HOME}/Desktop" "Screenshot location"
  add_setting standard com.apple.screencapture type string "png" "Screenshot format"
  add_setting standard com.apple.screencapture disable-shadow bool true "Disable screenshot shadows"
  add_setting standard NSGlobalDomain AppleFontSmoothing int 2 "Font smoothing"

  # Finder
  add_setting standard com.apple.finder QuitMenuItem bool true "Enable Finder quit menu"
  add_setting standard com.apple.finder DisableAllAnimations bool true "Disable Finder animations"
  add_setting standard com.apple.finder NewWindowTarget string "PfDe" "New Finder windows on Desktop"
  add_setting standard com.apple.finder NewWindowTargetPath string "file://${HOME}/Desktop/" "Finder new window path"
  add_setting standard com.apple.finder ShowExternalHardDrivesOnDesktop bool true "Show external disks"
  add_setting standard com.apple.finder ShowHardDrivesOnDesktop bool true "Show internal disks"
  add_setting standard com.apple.finder ShowMountedServersOnDesktop bool true "Show mounted servers"
  add_setting standard com.apple.finder ShowRemovableMediaOnDesktop bool true "Show removable media"
  add_setting standard com.apple.finder AppleShowAllFiles bool true "Show hidden files"
  add_setting standard NSGlobalDomain AppleShowAllExtensions bool true "Show all file extensions"
  add_setting standard com.apple.finder ShowStatusBar bool true "Show status bar"
  add_setting standard com.apple.finder ShowPathbar bool true "Show path bar"
  add_setting standard com.apple.finder _FXShowPosixPathInTitle bool true "Show full POSIX path in title"
  add_setting standard com.apple.finder _FXSortFoldersFirst bool true "Keep folders on top"
  add_setting standard com.apple.finder FXDefaultSearchScope string "SCcf" "Search current folder by default"
  add_setting standard com.apple.finder FXEnableExtensionChangeWarning bool false "Disable extension change warning"
  add_setting standard NSGlobalDomain com.apple.springing.enabled bool true "Enable spring loading"
  add_setting standard NSGlobalDomain com.apple.springing.delay float 0 "Remove spring loading delay"
  add_setting standard com.apple.desktopservices DSDontWriteNetworkStores bool true "Avoid .DS_Store on network"
  add_setting standard com.apple.desktopservices DSDontWriteUSBStores bool true "Avoid .DS_Store on USB"
  add_setting standard com.apple.frameworks.diskimages skip-verify bool true "Skip DMG verification"
  add_setting standard com.apple.frameworks.diskimages skip-verify-locked bool true "Skip DMG verification (locked)"
  add_setting standard com.apple.frameworks.diskimages skip-verify-remote bool true "Skip DMG verification (remote)"
  add_setting standard com.apple.finder FXPreferredViewStyle string "Nlsv" "Use list view"
  add_setting standard com.apple.finder WarnOnEmptyTrash bool false "Disable trash warning"
  add_setting standard com.apple.NetworkBrowser BrowseAllInterfaces bool true "Enable AirDrop over Ethernet"

  # Dock
  add_setting standard com.apple.dock tilesize int 10 "Dock icon size"
  add_setting standard com.apple.dock static-only bool true "Show only open apps in Dock"
  add_setting standard com.apple.dock launchanim bool false "Disable Dock launch animation"
  add_setting standard com.apple.dock mru-spaces bool false "Don't rearrange Spaces"
  add_setting standard com.apple.dock autohide-delay float 0 "Remove Dock autohide delay"
  add_setting standard com.apple.dock autohide-time-modifier float 0 "Speed Dock autohide animation"
  add_setting standard com.apple.dock autohide bool true "Auto hide Dock"
  add_setting standard com.apple.dock showhidden bool true "Dim hidden app icons"
  add_setting standard com.apple.dock show-recents bool false "Hide recent apps in Dock"
  add_setting standard com.apple.dock wvous-tl-corner int 0 "Disable top-left hot corner"
  add_setting standard com.apple.dock wvous-tr-corner int 0 "Disable top-right hot corner"
  add_setting standard com.apple.dock wvous-bl-corner int 0 "Disable bottom-left hot corner"
  add_setting standard com.apple.dock wvous-br-corner int 0 "Disable bottom-right hot corner"

  # Calendar
  add_setting standard com.apple.iCal "Show Week Numbers" bool true "Show week numbers in Calendar"
  add_setting standard com.apple.iCal "first day of week" int 1 "Week starts on Monday"

  # Terminal
  add_array_setting standard com.apple.terminal StringEncodings "Terminal UTF-8 only" "4"
  add_setting standard com.apple.terminal "Default Window Settings" string "Pro" "Terminal default profile"
  add_setting standard com.apple.terminal "Startup Window Settings" string "Pro" "Terminal startup profile"
  add_setting standard com.apple.Terminal ShowLineMarks int 0 "Hide Terminal line marks"

  # Activity Monitor
  add_setting standard com.apple.ActivityMonitor OpenMainWindow bool true "Show Activity Monitor main window on launch"
  add_setting standard com.apple.ActivityMonitor IconType int 5 "Show CPU usage in Dock icon"
  add_setting standard com.apple.ActivityMonitor ShowCategory int 0 "Show all processes"
  add_setting standard com.apple.ActivityMonitor SortColumn string "CPUUsage" "Sort Activity Monitor by CPU"
  add_setting standard com.apple.ActivityMonitor SortDirection int 0 "Sort descending"

  # Software updates
  add_setting standard com.apple.SoftwareUpdate AutomaticCheckEnabled bool true "Enable automatic update checks"
  add_setting standard com.apple.SoftwareUpdate ScheduleFrequency int 1 "Check for updates daily"
  add_setting standard com.apple.SoftwareUpdate AutomaticDownload bool true "Download updates automatically"
  add_setting standard com.apple.SoftwareUpdate CriticalUpdateInstall bool true "Install system data files and security updates"
  add_setting standard com.apple.commerce AutoUpdate bool true "Automatically update apps"
}

energy_status() {
  section "Energy (pmset)"
  pmset -g custom 2>/dev/null || pmset -g 2>/dev/null || true
}

energy_apply() {
  section "Energy (pmset)"
  if ! $DRY_RUN; then
    local pmset_before
    pmset_before=$(pmset -g custom 2>/dev/null || pmset -g 2>/dev/null || true)
    REVERT_NOTES+=("pmset before apply:\n$pmset_before")
  fi
  run sudo pmset -a standbydelay 86400
  run sudo pmset -a sms 0
  run sudo pmset -a lidwake 1
  run sudo pmset -a autorestart 1
  run sudo pmset -a displaysleep 15
  run sudo pmset -c sleep 0
  run sudo pmset -b sleep 15
  run sudo pmset -a hibernatemode 0
}

hidpi_status() {
  local current
  current=$(defaults read /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled 2>/dev/null || echo "absent")
  printf '%-60s current=%s desired=true Enable HiDPI display modes\n' "com.apple.windowserver:DisplayResolutionEnabled" "$current"
}

hidpi_apply() {
  local current raw current_norm
  raw=$(defaults read /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled 2>/dev/null || echo "__absent__")
  current_norm=$(normalize_value bool "$raw")
  if [[ "$current_norm" == "true" ]]; then
    log SKIP "Enable HiDPI display modes (already true)"
    return
  fi
  log APPLY "Enable HiDPI display modes (${current_norm:-absent} -> true)"
  if ! $DRY_RUN; then
    record_revert standard /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled bool "$raw" "Enable HiDPI display modes"
  fi
  run sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true
}

restart_affected_apps() {
  local apps=(
    "Activity Monitor"
    "Calendar"
    "Contacts"
    "Dock"
    "Finder"
    "Mail"
    "Messages"
    "Photos"
    "Safari"
    "SystemUIServer"
    "Terminal"
  )

  section "Restarting affected apps"
  for app in "${apps[@]}"; do
    if $DRY_RUN; then
      log DRY "killall $app"
    elif killall "$app" >/dev/null 2>&1; then
      log INFO "Restarted $app"
    fi
  done
}

write_revert_script() {
  $DRY_RUN && return
  [[ ${#REVERT_COMMANDS[@]} -eq 0 && ${#REVERT_NOTES[@]} -eq 0 ]] && return
  local timestamp file
  timestamp=$(date +%Y%m%d-%H%M%S)
  file="$HOME/mac-defaults-revert-$timestamp.sh"
  {
    echo "#!/usr/bin/env bash"
    echo "# Generated by mac.sh on $(date)"
    echo "set -euo pipefail"
    echo
    for entry in "${REVERT_COMMANDS[@]}"; do
      IFS='|' read -r cmd desc <<<"$entry"
      echo "# $desc"
      echo "$cmd"
      echo
    done
    if [[ ${#REVERT_NOTES[@]} -gt 0 ]]; then
      echo "# Additional notes"
      for note in "${REVERT_NOTES[@]}"; do
        while IFS= read -r line; do
          echo "# $line"
        done <<<"$note"
      done
    fi
  } >"$file"
  chmod +x "$file"
  log INFO "Revert script saved to $file"
}

create_snapshot() {
  section "APFS snapshot"
  if $DRY_RUN; then
    log DRY "sudo tmutil localsnapshot"
    return
  fi
  if ! command -v tmutil >/dev/null 2>&1; then
    log WARN "tmutil not available; skipping snapshot"
    return
  fi
  if ! run sudo tmutil localsnapshot; then
    log WARN "Snapshot failed; continuing without one"
  fi
}

main_apply() {
  create_snapshot
  if [[ -n "$HOSTNAME" ]]; then
    set_hostname "$HOSTNAME"
  fi
  configure_settings_catalog
  process_settings apply
  hidpi_apply
  energy_apply
  restart_affected_apps
  write_revert_script
  log INFO "Done. Some changes may require logging out or restarting your Mac."
}

main_diff() {
  configure_settings_catalog
  [[ -n "$HOSTNAME" ]] && hostname_diff "$HOSTNAME"
  process_settings diff
  hidpi_status
  energy_status
}

main_status() {
  configure_settings_catalog
  process_settings status
  hidpi_status
  energy_status
}

main_snapshot() {
  create_snapshot
  log INFO "Snapshot complete."
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
    apply | diff | status | snapshot)
      ACTION="$1"
      shift
      ;;
    --hostname | -n)
      HOSTNAME="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --help | -h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
    esac
  done
}

parse_args "$@"

case "$ACTION" in
apply | snapshot)
  ask_for_sudo
  ;;
esac

report_hostname

case "$ACTION" in
apply)
  main_apply
  ;;
diff)
  main_diff
  ;;
status)
  main_status
  ;;
snapshot)
  main_snapshot
  ;;
*)
  usage
  exit 1
  ;;
esac
