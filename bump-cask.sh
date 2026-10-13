#!/usr/bin/env bash
#
# Bump the PingViewScan cask to a new release version.
#
# Usage:
#   ./bump-cask.sh 1.0.2        # or: ./bump-cask.sh v1.0.2
#
# Downloads the release asset for v<version> from bejuwt/pingviewscan, computes
# its sha256, rewrites Casks/pingviewscan.rb, audits it, and pushes.
set -euo pipefail

REPO="bejuwt/pingviewscan"
ASSET="PingViewScan-macOS.zip"
CASK="Casks/pingviewscan.rb"

cd "$(dirname "$0")"

version="${1:-}"
version="${version#v}"
if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "usage: $0 <version>   e.g. $0 1.0.2" >&2
    exit 1
fi

url="https://github.com/${REPO}/releases/download/v${version}/${ASSET}"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

echo "==> Downloading ${url}"
curl -fsSL -o "$tmp" "$url"
sha="$(shasum -a 256 "$tmp" | awk '{print $1}')"
echo "==> sha256 ${sha}"

sed -i '' -E "s|^(  version )\".*\"|\1\"${version}\"|" "$CASK"
sed -i '' -E "s|^(  sha256 )\".*\"|\1\"${sha}\"|" "$CASK"

echo "==> Auditing"
brew audit --cask "bejuwt/tap/pingviewscan"

if git diff --quiet -- "$CASK"; then
    echo "==> Cask already at ${version} (${sha}); nothing to commit."
    exit 0
fi

git add "$CASK"
git commit -m "Update pingviewscan to ${version}"
git push
echo "==> Done: pingviewscan ${version}"
