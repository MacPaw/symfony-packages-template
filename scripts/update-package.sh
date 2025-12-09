#!/usr/bin/env bash

set -euo pipefail

# update-package.sh
# Quickly rebrand this template to a new Composer package and PHP namespace.
#
# Usage:
#   scripts/update-package.sh vendor/package [New\\Namespace] ["New description"]
#
# Examples:
#   scripts/update-package.sh acme/cool-bundle
#   scripts/update-package.sh acme/cool-bundle Acme\\CoolBundle "Cool Symfony bundle"
#
# Notes:
# - Requires PHP CLI.
# - Tested on macOS (BSD sed). On GNU/Linux sed, the -i option also works without quotes.

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if [[ ! -f composer.json ]]; then
  echo "[ERROR] composer.json not found. Run this script from the project root." >&2
  exit 1
fi

if [[ ${1:-} == "" ]]; then
  echo "Usage: scripts/update-package.sh vendor/package [New\\\Namespace] [\"New description\"]" >&2
  exit 1
fi

NEW_PACKAGE="$1"          # e.g. acme/cool-bundle
NEW_NAMESPACE="${2:-}"    # e.g. Acme\\CoolBundle
NEW_DESCRIPTION="${3:-}"  # optional

# Helper: read JSON safely using PHP (avoids jq dependency)
json_read() {
  local key="$1"
  php -r '
    $j=json_decode(file_get_contents("composer.json"), true);
    if ($j===null) { fwrite(STDERR, "Cannot parse composer.json\n"); exit(1);}
    $keys=explode(".", $argv[1]);
    $v=$j; foreach($keys as $k){ if(!array_key_exists($k,$v)){exit(2);} $v=$v[$k]; }
    if (is_array($v)) { echo array_key_first($v); } else { echo $v; }
  ' "$key" 2>/dev/null || true
}

OLD_PACKAGE="$(json_read name)"
OLD_NS_SRC="$(json_read autoload.psr-4)"     # first PSR-4 key
OLD_NS_TESTS="$(json_read autoload-dev.psr-4)" || true

if [[ -z "$OLD_PACKAGE" || -z "$OLD_NS_SRC" ]]; then
  echo "[ERROR] Failed to detect current package name or namespace from composer.json" >&2
  exit 1
fi

# If NEW_NAMESPACE not provided, derive from vendor/package -> Vendor\\Package (StudlyCase segments)
if [[ -z "$NEW_NAMESPACE" ]]; then
  php -r '
    [$vendor,$name] = array_pad(explode("/", $argv[1], 2), 2, "");
    if(!$vendor||!$name){fwrite(STDERR, "Bad package name. Use vendor/package\n"); exit(1);}
    $studly = function($s){
      $s = preg_replace("/[^a-zA-Z0-9]+/", " ", $s);
      $s = ucwords(strtolower($s));
      return str_replace(" ", "", $s);
    };
    echo $studly($vendor)."\\\\".$studly($name);
  ' "$NEW_PACKAGE" > .tmp.newns
  NEW_NAMESPACE="$(cat .tmp.newns)"
  rm -f .tmp.newns
fi

echo "Detected current values:"
echo "  Old package:   $OLD_PACKAGE"
echo "  Old namespace: $OLD_NS_SRC"
echo
echo "Updating to:"
echo "  New package:   $NEW_PACKAGE"
echo "  New namespace: $NEW_NAMESPACE"
if [[ -n "$NEW_DESCRIPTION" ]]; then
  echo "  New description: $NEW_DESCRIPTION"
fi

read -r -p "Proceed with the update? [y/N] " confirm
confirm=$(printf '%s' "$confirm" | tr '[:upper:]' '[:lower:]')
if [[ "$confirm" != "y" && "$confirm" != "yes" ]]; then
  echo "Aborted."
  exit 1
fi

# Update composer.json using PHP to avoid brittle sed on JSON
php -r '
  $file = "composer.json";
  $j = json_decode(file_get_contents($file), true);
  if ($j===null) { fwrite(STDERR, "Cannot parse composer.json\n"); exit(1);}
  $newName = $argv[1];
  $newNs = $argv[2];
  $newDesc = $argv[3] ?? "";

  $j["name"] = $newName;
  if ($newDesc !== "") { $j["description"] = $newDesc; }

  // Update PSR-4 for src
  if (isset($j["autoload"]["psr-4"]) && is_array($j["autoload"]["psr-4"])) {
    $keys = array_keys($j["autoload"]["psr-4"]);
    if ($keys) {
      $old = $keys[0];
      $path = $j["autoload"]["psr-4"][$old];
      unset($j["autoload"]["psr-4"][$old]);
      $j["autoload"]["psr-4"][rtrim($newNs, "\\")."\\\\"] = $path;
    }
  }
  // Update PSR-4 for tests
  if (isset($j["autoload-dev"]["psr-4"]) && is_array($j["autoload-dev"]["psr-4"])) {
    $keys = array_keys($j["autoload-dev"]["psr-4"]);
    if ($keys) {
      $old = $keys[0];
      $path = $j["autoload-dev"]["psr-4"][$old];
      unset($j["autoload-dev"]["psr-4"][$old]);
      $j["autoload-dev"]["psr-4"][rtrim($newNs, "\\")."\\\\Tests\\\\"] = $path;
    }
  }

  file_put_contents($file, json_encode($j, JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES) . "\n");
' "$NEW_PACKAGE" "$NEW_NAMESPACE" "$NEW_DESCRIPTION"

# Perform project-wide textual replacements for namespace and package name
ESC_OLD_NS=$(printf '%s' "$OLD_NS_SRC" | sed -e 's/[^^]/[&]/g; s/\^/\\^/g')
ESC_NEW_NS=$(printf '%s' "$NEW_NAMESPACE\\" | sed -e 's/[^^]/[&]/g; s/\^/\\^/g')

# macOS/BSD sed requires an argument for -i
find_paths=(src tests phpunit.xml.dist README.md SECURITY.md rector.php phpstan.neon.dist phpcs.xml.dist)
for p in "${find_paths[@]}"; do
  if [[ -e "$p" ]]; then
    # Replace namespace occurrences
    sed -i '' -e "s/${ESC_OLD_NS}/${ESC_NEW_NS}/g" "$p" || true
    # Replace package name occurrences
    sed -i '' -e "s/${OLD_PACKAGE//\//\/}/${NEW_PACKAGE//\//\/}/g" "$p" || true
  fi
done

# Replace across PHP files in src/ and tests/
grep -RIl --exclude-dir=vendor --include='*.php' "$OLD_NS_SRC" src tests 2>/dev/null | while read -r file; do
  sed -i '' -e "s/${ESC_OLD_NS}/${ESC_NEW_NS}/g" "$file" || true
done

# Replace package strings in common text/code files
grep -RIl --exclude-dir=vendor "$OLD_PACKAGE" . 2>/dev/null | while read -r file; do
  sed -i '' -e "s/${OLD_PACKAGE//\//\/}/${NEW_PACKAGE//\//\/}/g" "$file" || true
done

echo "Running composer dump-autoload..."
if command -v composer >/dev/null 2>&1; then
  composer dump-autoload >/dev/null 2>&1 || true
else
  echo "[WARN] Composer not found in PATH. Skipping dump-autoload."
fi

echo "Done. Review changes with 'git status' and run tests to verify."
