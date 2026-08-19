#!/usr/bin/env bash
# writerdeck install.sh - githugs.lol
# run me on a fresh Raspberry Pi OS Lite:
#   curl -sSL https://githugs.lol/scripts/writerdeck.sh | bash
#
# safe to re-run. won't touch your stories.

set -euo pipefail

STORIES="$HOME/stories"
STORY_FILE="$STORIES/current.md"
CONF="$HOME/.writerdeck.conf"
PROFILE="$HOME/.bash_profile"
MARK_A="# >>> writerdeck >>>"
MARK_B="# <<< writerdeck <<<"

say() { printf '\n\033[1m%s\033[0m\n' "$*"; }

# ---------- screen size ----------
# can't auto-detect this - cheap panels lie in their EDID (mine claims 720p, it's 3.5 inches).
# so I just ask. humans know what they bought.
SCALE="1.5"
if [ -e /dev/tty ]; then
  say "How big is your screen?"
  echo "  1) Small   (3.5 - 5 inch)"
  echo "  2) Medium  (7 inch)"
  echo "  3) Large   (monitor / TV)"
  printf 'Pick 1, 2, or 3 [2]: '
  read -r pick < /dev/tty || pick=""
  case "${pick:-2}" in
    1) SCALE="2"   ;;
    3) SCALE="1"   ;;
    *) SCALE="1.5" ;;
  esac
fi

# ---------- packages ----------
say "Installing FocusWriter..."
sudo apt-get update
if ! sudo apt-get install -y focuswriter cage hunspell-de-de; then
  say "Package hiccup - refreshing lists and retrying once..."
  sudo apt-get update
  sudo apt-get install -y focuswriter cage hunspell-de-de
fi

# ---------- the story file ----------
# never overwrite. re-running the installer must NOT eat somebody's novel.
mkdir -p "$STORIES"
if [ ! -f "$STORY_FILE" ]; then
  echo "Hello, writer! This is your story machine. Just start typing!" > "$STORY_FILE"
fi

# ---------- config ----------
# one file, one number. "text too big?" support answer = edit SCALE here, reboot.
cat > "$CONF" << EOF
# writerdeck config - edit and reboot
SCALE=$SCALE
EOF

# ---------- launch hook ----------
# strip any previous writerdeck block first so re-runs stay clean
if [ -f "$PROFILE" ]; then
  sed -i "/^$MARK_A\$/,/^$MARK_B\$/d" "$PROFILE"
fi

cat >> "$PROFILE" << EOF
$MARK_A
# tty1 only: the physical screen becomes the writing appliance, SSH stays a normal shell
if [ "\$(tty)" = "/dev/tty1" ]; then
  [ -f "\$HOME/.writerdeck.conf" ] && . "\$HOME/.writerdeck.conf"
  export QT_SCALE_FACTOR="\${SCALE:-1.5}"
  exec cage -- focuswriter "\$HOME/stories/current.md"
fi
$MARK_B
EOF

# ---------- autologin ----------
# nonint = no menu diving. B2 = boot to console, logged in.
sudo raspi-config nonint do_boot_behaviour B2

# ---------- done ----------
say "Done. Rebooting into your writerdeck in 5 seconds (Ctrl+C to skip)..."
sleep 5
sudo reboot