#!/usr/bin/env bash
# Refresh Windows installer hashes from the GitHub release API.
# Usage: ./fetch-hashes.sh 2.3.0
# Run AFTER ./bump.sh <version>. Fills winget InstallerSha256 + choco checksums.
set -euo pipefail
cd "$(dirname "$0")"
ver="${1:?usage: ./fetch-hashes.sh <version>}"

map="$(curl -fsSL "https://api.github.com/repos/rl-lang/rl-lang/releases/tags/v$ver" \
  | python3 -c "import json,sys; [print(a['name'], a['digest'].split(':')[1]) for a in json.load(sys.stdin)['assets']]")"
x64="$(echo "$map" | awk '/^rl-windows-x86_64.zip /{print $2}')"
arm="$(echo "$map" | awk '/^rl-windows-aarch64.zip /{print $2}')"
[ -n "$x64" ] && [ -n "$arm" ] || { echo "fetch-hashes: assets missing for v$ver" >&2; exit 1; }

python3 - "$x64" "$arm" <<'EOF'
import re, sys
x64, arm = sys.argv[1].upper(), sys.argv[2].upper()
p = 'winget/rl-lang.rl.installer.yaml'
s = open(p).read()
# [0-9A-Za-z_]+ matches both real hashes and the REPLACE_WITH_ACTUAL_SHA256
# placeholders that bump.sh leaves behind.
s = re.sub(r'(- Architecture: x64\n    InstallerUrl: [^\n]*\n    InstallerSha256: )[0-9A-Za-z_]+', r'\g<1>' + x64, s)
s = re.sub(r'(- Architecture: arm64\n    InstallerUrl: [^\n]*\n    InstallerSha256: )[0-9A-Za-z_]+', r'\g<1>' + arm, s)
open(p, 'w').write(s)
EOF
# Both url and url64bit point at the x64 zip, so both checksums are the x64
# hash. (checksum64 has different alignment than checksum: match each line.)
sed -i -E "s|checksum64[[:space:]]*=[[:space:]]*\".*\"|checksum64     = \"$x64\"|" choco/tools/chocolateyinstall.ps1
sed -i -E "s|checksum[[:space:]]*=[[:space:]]*\".*\"|checksum       = \"$x64\"|" choco/tools/chocolateyinstall.ps1

echo "fetch-hashes: x64 $x64"
echo "fetch-hashes: arm $arm"
./bump.sh --check
