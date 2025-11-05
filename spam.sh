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
    continue  # Recycle default tests
  fi

  # Custom index input (1–17)
  idx=$(kdialog --inputbox "Enter a custom index (1–17) or press Cancel to exit:" "" --title "Manual Index")
  if [[ -z "$idx" ]]; then
    kdialog --msgbox "No index entered. Exiting program."
    exit 0
  fi
  # Validate input
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
