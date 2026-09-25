#!/usr/bin/env bash
# Bump every Windows package template to a new rl-lang version.
# Usage: ./bump.sh 2.3.0
set -euo pipefail
cd "$(dirname "$0")"

fail() { echo "bump: $*" >&2; exit 1; }

versions() {
  echo "choco $(grep -m1 '<version>' choco/rl-lang.nuspec | sed 's/.*<version>\(.*\)<\/version>.*/\1/')"
  echo "winget $(grep -m1 '^PackageVersion:' winget/rl-lang.rl.yaml | awk '{print $2}')"
  echo "winget-installer $(grep -m1 '^PackageVersion:' winget/rl-lang.rl.installer.yaml | awk '{print $2}')"
  echo "winget-locale $(grep -m1 '^PackageVersion:' winget/rl-lang.rl.locale.en-US.yaml | awk '{print $2}')"
  echo "winget-url $(grep -m1 'InstallerUrl:' winget/rl-lang.rl.installer.yaml | sed 's/.*\/v//;s/\/rl-windows.*//')"
}

if [ "${1:-}" = "--check" ]; then
  out="$(versions)"
  echo "$out"
  uniq="$(echo "$out" | awk '{print $2}' | sort -u | wc -l)"
  [ "$uniq" -eq 1 ] || fail "versions disagree"
  echo "bump: all targets agree"
  exit 0
fi

ver="${1:?usage: ./bump.sh <version> | --check}"
sed -i "s|<version>.*</version>|<version>$ver</version>|" choco/rl-lang.nuspec
sed -i "s/^PackageVersion:.*/PackageVersion: $ver/" winget/rl-lang.rl.yaml winget/rl-lang.rl.installer.yaml winget/rl-lang.rl.locale.en-US.yaml
sed -i "s|releases/download/v.*/rl-windows|releases/download/v$ver/rl-windows|" winget/rl-lang.rl.installer.yaml

echo "bump: updated to $ver"
echo "bump: checksums must come from the release page digests (see PUBLISHING.md)"
./bump.sh --check
