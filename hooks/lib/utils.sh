#!/bin/bash
# Shared utilities for trekker hooks

# Extract count from toon format (first line: [count])
get_toon_count() {
    head -1 | grep -o '^\[[0-9]*\]' | tr -d '[]'
}

# Extract task IDs from toon list (CSV rows after header)
get_toon_task_ids() {
    tail -n +2 | cut -d',' -f1 | sed 's/^[[:space:]]*//' | grep -E '^TREK-[0-9]+$'
}

# Compact task context: id, title, desc, last 3 comment lines, deps
print_task_context() {
    local id="$1"
    local out=$(trekker --toon task show "$id" 2>/dev/null)
    local title=$(echo "$out" | grep '^title:' | cut -d' ' -f2-)
    local desc=$(echo "$out" | grep '^description:' | cut -d' ' -f2-)

    echo "- $id: $title"
    [ -n "$desc" ] && [ "$desc" != "null" ] && echo "  desc: $desc"

    local comments=$(trekker --toon comment list "$id" 2>/dev/null | tail -3)
    [ -n "$comments" ] && echo "  comments:" && echo "$comments" | sed 's/^/    /'

    local deps=$(trekker --toon dep list "$id" 2>/dev/null)
    local dc=$(echo "$deps" | grep -c '^  - ' 2>/dev/null || echo "0")
    [ "$dc" -gt 0 ] && echo "  deps:" && echo "$deps" | sed 's/^/    /'
}
