#!/bin/sh
# Rebuilds assets/shots/ and assets/press/ from the app's offscreen renders, and the site's icons
# from the app's icon set. In the app repository, render both suites to a folder first:
#   TEST_RUNNER_ELFCLEAN_SNAPSHOT_DIR=<folder> tools/ios test-unit --only ElfCleanTests/ParitySnapshotTests
#   TEST_RUNNER_ELFCLEAN_SNAPSHOT_DIR=<folder> tools/ios test-unit --only ElfCleanTests/SettingsSnapshotTests
# Usage: tools/shots/import.sh <folder> [app repository, default ~/dev/elfclean-app]
set -eu

here=$(cd "$(dirname "$0")" && pwd)
site="$here/../.."
snaps=$1
app=${2:-"$HOME/dev/elfclean-app"}
icons="$app/App/ElfClean/Resources/Assets.xcassets/AppIcon.appiconset"

# Site screens: 1600 wide, as the pages' width and height attributes say.
for pair in clean:parity-clean-results projects:projects-dashboard ai:storage-agents storage-map:storage-map; do
  for mode in light dark; do
    cwebp -quiet -q 82 -resize 1600 0 "$snaps/${pair#*:}-$mode.png" -o "$site/assets/shots/${pair%%:*}-$mode.webp"
  done
done

# Press kit: full size JPEGs.
for pair in clean-light:parity-clean-results-light clean-dark:parity-clean-results-dark \
  projects-light:projects-dashboard-light ai-coding-light:storage-agents-light \
  review-light:parity-confirm-light storage-map-light:storage-map-light; do
  sips -s format jpeg -s formatOptions 88 "$snaps/${pair#*:}.png" --out "$site/assets/press/${pair%%:*}.jpg" >/dev/null
done

cp "$icons/icon_512x512@2x.png" "$site/assets/icon-1024.png"
cp "$icons/icon_512x512@2x.png" "$site/assets/press/icon-1024.png"
cp "$icons/icon_512x512.png" "$site/assets/icon-512.png"
cp "$icons/icon_32x32@2x.png" "$site/assets/favicon-64.png"
sips -z 180 180 "$icons/icon_512x512@2x.png" --out "$site/assets/apple-touch-icon.png" >/dev/null

echo "imported. The social card shows the icon too: run tools/og-card/render.sh"
