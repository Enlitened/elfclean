#!/bin/sh
# Replaces the site and press screens the App Store set covers with the window from those renders,
# which show a fuller demo home than the snapshot fixture. Run it after tools/shots/import.sh, which
# overwrites them. The set has no Projects or AI & coding screen and no dark storage map, so those
# stay as import.sh made them. In the app repository, render the set first: tools/screenshots/capture.sh
# Usage: tools/shots/import-appstore.sh [app repository, default ~/dev/elfclean-app]
set -eu

here=$(cd "$(dirname "$0")" && pwd)
site="$here/../.."
app=${1:-"$HOME/dev/elfclean-app"}
shots="$app/AppStore/assets/screenshots/mac/en-US"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# The frame draws a 1160 x 725 window at (140, 150) with a 1 pt stroke. This leaves out the caption,
# the backdrop and the stroke, since the pages draw their own border.
crop() { sips --cropOffset 151 141 -c 723 1158 "$shots/$1.png" --out "$tmp/$1.png" >/dev/null; }

for pair in clean-light:01-clean-light clean-dark:03-clean-AI-models-dark storage-map-light:04-storage-light; do
  crop "${pair#*:}"
  cwebp -quiet -q 82 "$tmp/${pair#*:}.png" -o "$site/assets/shots/${pair%%:*}.webp"
done

for pair in clean-light:01-clean-light clean-dark:03-clean-AI-models-dark \
  review-light:02-confirm-light storage-map-light:04-storage-light; do
  crop "${pair#*:}"
  sips -s format jpeg -s formatOptions 88 "$tmp/${pair#*:}.png" --out "$site/assets/press/${pair%%:*}.jpg" >/dev/null
done

echo "imported. The pages' width and height attributes for these screens say 1158 x 723."
