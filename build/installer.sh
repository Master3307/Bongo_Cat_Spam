#!/bin/bash

# Set up variables
GAME_ROOT="$HOME/.local/share/Steam/steamapps/common/BongoCat"
PLUGIN_DIR="$GAME_ROOT/BongoCat_Data/Plugins"
SPAM_SCRIPT="$PLUGIN_DIR/spam.sh"
WRAP_SCRIPT="$PLUGIN_DIR/bcat_wrapper.sh"
APP_ID="3419430"

# Create plugins directory if missing
mkdir -p "$PLUGIN_DIR"

# Save spam.sh (your automation script logic here)
cat >"$SPAM_SCRIPT" <<'__SPAM__'
#!/bin/bash
STEAM_CLASS="${1:-steam_app_3419430}"
window_ids=($(xdotool search --class "$STEAM_CLASS"))
if ! command -v kdialog &>/dev/null; then
  echo "kdialog is required for graphical prompts. Please install it: sudo apt install kdialog"
  exit 1
fi
msg="Available Bongo Cat window IDs (class: $STEAM_CLASS):\n"
for i in "${!window_ids[@]}"; do
  msg+="$i: ${window_ids[$i]}\n"
done
kdialog --msgbox "$msg"
spam_loop() {
  idx=$1
  kdialog --msgbox "Now spamming index $idx (ID: ${window_ids[$idx]}) forever! Close to continue."
  while true; do
    xdotool key --window "${window_ids[$idx]}" a
    sleep 0
  done
}
test_indices_cycle() {
  for idx in 16 15 17; do
    (
      while true; do
        xdotool key --window "${window_ids[$idx]}" a
        sleep 0
      done
    ) &
    spam_pid=$!
    kdialog --yesno "Was Bongo Cat VERY FAST for index $idx?\n(ID: ${window_ids[$idx]})" --title "Bongo Cat Speed Test"
    code=$?
    kill $spam_pid 2>/dev/null
    wait $spam_pid 2>/dev/null
    if [ "$code" -eq 0 ]; then
      spam_loop $idx
      exit 0
    fi
  done
}
while true; do
  test_indices_cycle
  kdialog --yesno "Try the default test again?\n(Yes = Test 16/15/17 again, No = Enter custom index)" --title "Cycle Again?"
  code=$?
  if [ "$code" -eq 0 ]; then
    continue
  fi
  idx=$(kdialog --inputbox "Enter a custom index (1–17) or press Cancel to exit:" "" --title "Manual Index")
  if [[ -z "$idx" ]]; then
    kdialog --msgbox "No index entered. Exiting program."
    exit 0
  fi
  if [[ "$idx" =~ ^[0-9]+$ ]] && [ "$idx" -ge 1 ] && [ "$idx" -le 17 ] && [ "$idx" -lt "${#window_ids[@]}" ]; then
    (
      while true; do
        xdotool key --window "${window_ids[$idx]}" a
        sleep 0
      done
    ) &
    spam_pid=$!
    kdialog --yesno "Was Bongo Cat VERY FAST for index $idx?\n(ID: ${window_ids[$idx]})" --title "Bongo Cat Speed Test"
    code=$?
    kill $spam_pid 2>/dev/null
    wait $spam_pid 2>/dev/null
    if [ "$code" -eq 0 ]; then
      spam_loop $idx
      exit 0
    fi
  else
    kdialog --error "Invalid index: $idx. Please enter a number from 1 to 17."
  fi
done
__SPAM__

# Save bcat_wrapper.sh (starts Bongo Cat, waits, then starts spam)
cat >"$WRAP_SCRIPT" <<__WRAP__
#!/bin/bash
DIR="\$(dirname "\$(readlink -f "\$0")")"
# Start Bongo Cat/game with whatever Steam gives us
"\$@" &
GAME_PID=\$!
sleep 7
"\$DIR/spam.sh" &
wait "\$GAME_PID"
__WRAP__

chmod +x "$SPAM_SCRIPT" "$WRAP_SCRIPT"
# ... (after creating spam.sh and bcat_wrapper.sh)

LAUNCH_CMD="/bin/bash \"$WRAP_SCRIPT\" %command%"

if command -v xclip >/dev/null 2>&1; then
  printf '%s\n' "$LAUNCH_CMD" | xclip -selection clipboard
  COPIED=" and has been copied to your clipboard"
else
  COPIED=""
fi

cat <<EOF

============
INSTALLATION COMPLETE!
============

1. In Steam, right-click **Bongo Cat** → Properties → **Launch Options**.
2. Paste the following command (copied below$COPIED):

$LAUNCH_CMD

3. Close Properties.
4. Just click PLAY in Steam as usual. The spam script will run from the Plugins folder
   *after* Bongo Cat starts.

To update/remove, just delete the spam.sh/bcat_wrapper.sh scripts from:
  $PLUGIN_DIR

If you ever want to uninstall, just remove this folder or clear the launch option.

============

EOF

