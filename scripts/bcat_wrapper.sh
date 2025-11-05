#!/bin/bash

SPAM_SCRIPT="/media/master3307/Master_Driv/_3_Programming/_Random/BCat/spam.sh"

# Start the game in the background so it begins launching
"$@" &

# Give the game some time to start (adjust this if needed)
sleep 5

# Now run the spam script in background
"$SPAM_SCRIPT" &

# Wait for the game process to finish
wait
