#!/usr/bin/env bash
# Parses every GDScript file and reports the ones that fail.
#
# Files listed in tools/known-parse-failures.txt are expected to fail and are
# skipped, each with its reason written there. Anything else that fails makes
# this exit non-zero, so a newly broken file cannot slip in.
#
# Needs gdtoolkit:  pip install 'gdtoolkit==4.*'
#
# @author Ismael Sallami Moreno

set -uo pipefail

KNOWN="tools/known-parse-failures.txt"
failed=0
checked=0
skipped=0

# Strip comments and blank lines from the known-failures list.
known_list=$(grep -vE '^\s*(#|$)' "$KNOWN" 2>/dev/null || true)

is_known() {
    grep -qxF "$1" <<<"$known_list"
}

while IFS= read -r file; do
    if is_known "$file"; then
        skipped=$((skipped + 1))
        continue
    fi
    checked=$((checked + 1))
    if ! gdparse "$file" >/dev/null 2>&1; then
        echo "FAIL  $file"
        gdparse "$file" 2>&1 | grep -m1 'Unexpected token' | sed 's/^/      /'
        failed=$((failed + 1))
    fi
done < <(find src -name '*.gd' | sort)

echo
echo "parsed $checked file(s), $skipped known failure(s) skipped, $failed unexpected failure(s)"

# Every entry in the list must still exist, or it is stale.
while IFS= read -r file; do
    [[ -f "$file" ]] || { echo "stale entry in $KNOWN: $file"; failed=$((failed + 1)); }
done <<<"$known_list"

exit $((failed > 0 ? 1 : 0))
