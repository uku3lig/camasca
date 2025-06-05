#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

# shellcheck shell=bash

set -euo pipefail

groups=("VirtualSinger" "leoneed" "MMJ" "VBS" "WxS" "N25")

for group in "${groups[@]}"; do
  tmpfile=$(mktemp)
  curl -o "$tmpfile" "https://www.colorfulstage.com/upload_images/media/Download/ani%20file-animation-${group}.zip"
  hash=$(nix-hash --sri --flat --type sha256 "$tmpfile")

  updatedContent=$(jq ".\"$group-ani\" = \"$hash\"" ./hashes.json)
  echo -E "$updatedContent" > ./hashes.json
done

for group in "${groups[@]}"; do
  tmpfile=$(mktemp)
  curl -o "$tmpfile" "https://www.colorfulstage.com/upload_images/media/Download/cur%20file-static-${group}.zip"
  hash=$(nix-hash --sri --flat --type sha256 "$tmpfile")

  updatedContent=$(jq ".\"$group-cur\" = \"$hash\"" ./hashes.json)
  echo -E "$updatedContent" > ./hashes.json
done
