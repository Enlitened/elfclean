#!/bin/sh
# Renders tools/og-card/card.html to assets/og-card.png at 1200x630 with headless Chrome.
# A throwaway profile keeps it apart from any Chrome that's open.
set -eu

here=$(cd "$(dirname "$0")" && pwd)
out="$here/../../assets/og-card.png"
chrome=${CHROME:-"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"}
profile=$(mktemp -d)
trap 'rm -rf "$profile"' EXIT

"$chrome" --headless=new --disable-gpu --hide-scrollbars --no-first-run \
  --user-data-dir="$profile" --allow-file-access-from-files \
  --force-device-scale-factor=1 --force-color-profile=srgb --window-size=1200,630 \
  --virtual-time-budget=3000 --screenshot="$out" "file://$here/card.html" 2>/dev/null

size=$(sips -g pixelWidth -g pixelHeight "$out" | awk '/pixelWidth/ {w=$2} /pixelHeight/ {h=$2} END {print w "x" h}')
[ "$size" = "1200x630" ] || { echo "og-card.png came out $size, not 1200x630" >&2; exit 1; }
echo "wrote assets/og-card.png ($size)"
