#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

# shellcheck shell=bash

set -euo pipefail

groups=("VirtualSinger" "leoneed" "MMJ" "VBS" "WxS" "N25")
leaders=("Kanade" "Ichika" "Minori" "Tsukasa" "Kohane")
members=("Rin" "Len" "Luka" "MEIKO" "KAITO" "Saki" "Honami" "Shiho" "Haruka" "Airi" "Shizuku" "An" "Akito" "Toya" "Emu" "Nene" "Rui" "Mafuyu" "Ena" "Mizuki")

addToJson() {
  tmpfile=$(mktemp)
  url="https://www.colorfulstage.com/upload_images/media/Download/${2}.zip"
  echo "fetching $url"
  curl -o "$tmpfile" "$url"
  hash=$(nix-hash --sri --flat --type sha256 "$tmpfile")

  updatedContent=$(jq --arg key "$1" --arg url "$url" --arg hash "$hash" '.[$key].url = $url | .[$key].hash = $hash' ./hashes.json)
  echo -E "$updatedContent" > ./hashes.json
}

for format in cur ani; do
  group_suffix=$([ "$format" == "cur" ] && echo "static" || echo "animation")
  for group in "${groups[@]}"; do
    addToJson "$group Miku-$format" "$format%20file-$group_suffix-$group"
  done

  for leader in "${leaders[@]}"; do
    addToJson "$leader-$format" "$leader%20Cursor%20$group_suffix"
  done

  member_suffix=$([ "$format" == "cur" ] && echo "Static" || echo "Animated")
  for member in "${members[@]}"; do
    addToJson "$member-$format" "$member%20$member_suffix%20Cursor"
  done
done
