#!/usr/bin/env bash
set -euo pipefail

config_home=${XDG_CONFIG_HOME:-$HOME/.config}
zen_root=$config_home/zen
override=$config_home/noctalia/zen-browser/zen-base16-overrides.css
import="@import \"$override\";"

[[ -d $zen_root ]] || exit 0

while IFS= read -r -d '' prefs; do
  profile=${prefs%/prefs.js}
  chrome=$profile/chrome
  user_chrome=$chrome/userChrome.css

  mkdir -p "$chrome"
  touch "$user_chrome"
  grep -Fqx "$import" "$user_chrome" || printf '\n%s\n' "$import" >>"$user_chrome"
done < <(find "$zen_root" -mindepth 2 -maxdepth 2 -type f -name prefs.js -print0)
