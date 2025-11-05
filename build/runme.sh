#!/bin/bash
# This will be the entry called by makeself as the install entrypoint.

echo "=== Installing requirements (system packages)..."
bash requirements.sh

echo "=== Running main installer ==="
bash installer.sh

echo "=== Done! See README.md for instructions. ==="
