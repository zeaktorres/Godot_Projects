#!/bin/sh
echo -ne '\033c\033]0;Spooky_Game\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/spookygame.x86_64" "$@"
