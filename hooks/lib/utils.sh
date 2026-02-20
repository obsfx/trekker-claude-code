#!/bin/bash
# Shared utilities for trekker hooks

# Extract count from toon format (first line shows [count])
get_toon_count() {
    head -1 | grep -o '^\[[0-9]*\]' | tr -d '[]'
}

# Extract task IDs from toon list format (CSV rows after header)
get_toon_task_ids() {
    tail -n +2 | cut -d',' -f1 | sed 's/^[[:space:]]*//' | grep -E '^TREK-[0-9]+$'
}

# Fetch task list and extract count, defaulting to 0
# Usage: count=$(fetch_task_count "in_progress")
fetch_task_count() {
    local status="$1"
    local output
    output=$(trekker --toon task list --status "$status" 2>/dev/null)
    local count
    count=$(echo "$output" | get_toon_count)
    echo "${count:-0}"
}

# Print task context (title, description, comments, deps)
# Usage: print_task_context "TREK-1"
print_task_context() {
    local task_id="$1"
    local task_output
    local task_title
    local task_desc

    echo "#### $task_id"
    echo ""

    task_output=$(trekker --toon task show "$task_id" 2>/dev/null)
    task_title=$(echo "$task_output" | grep '^title:' | cut -d' ' -f2-)
    task_desc=$(echo "$task_output" | grep '^description:' | cut -d' ' -f2-)

    if [ -n "$task_title" ]; then
        echo "**Title**: $task_title"
    fi

    if [ -n "$task_desc" ] && [ "$task_desc" != "null" ]; then
        echo "**Description**: $task_desc"
    fi
    echo ""

    echo "**Recent Comments:**"
    local comments
    comments=$(trekker --toon comment list "$task_id" 2>/dev/null | tail -6)
    if [ -n "$comments" ]; then
        echo "$comments"
    else
        echo "No comments yet."
    fi
    echo ""

    local dep_output
    local dep_count
    dep_output=$(trekker --toon dep list "$task_id" 2>/dev/null)
    dep_count=$(echo "$dep_output" | grep -c '^  - ')
    if [ "$dep_count" -gt 0 ]; then
        echo "**Dependencies ($dep_count):**"
        echo "$dep_output"
        echo ""
    fi
}

# Print checkpoint comment template for a task
# Usage: print_checkpoint_template "TREK-1"
print_checkpoint_template() {
    local task_id="$1"
    echo "\`\`\`bash"
    echo "trekker comment add $task_id -a \"claude\" -c \"Checkpoint: [what's done]. Next: [what's next]. Files: [modified files]. State: [current state]\""
    echo "\`\`\`"
    echo ""
}

# Print the search-first reminder section
print_search_reminder() {
    echo "---"
    echo ""
    echo "## MANDATORY: Search Before Any Action"
    echo ""
    echo "**Search before creating or starting work:**"
    echo "\`\`\`bash"
    echo "trekker search \"<single keyword>\""
    echo "\`\`\`"
    echo ""
    echo "**Why:** You don't remember previous sessions. Search restores context, reveals past decisions, and prevents duplicate work."
    echo ""
    echo "**Tip:** FTS5 is not semantic. Use single keywords for best recall. Multi-word queries use AND logic (fewer results). Try 2-3 separate keywords."
}

# Print workflow footer
print_workflow_footer() {
    echo ""
    echo "---"
    echo ""
    echo "**Workflow**: \`in_progress\` -> work -> summary comment -> \`completed\`"
    echo "**Full guide**: \`trekker quickstart\` | **Search**: \`trekker search \"<query>\"\`"
}

# Print Trekker priority reminder
print_trekker_priority() {
    echo ""
    echo "---"
    echo ""
    echo "## CRITICAL: Always Use Trekker for Task Tracking"
    echo ""
    echo "Trekker is the ONLY task tracker you should use. Do NOT use Claude's built-in task tools (TaskCreate, TaskUpdate, TaskList, TodoWrite)."
    echo ""
    echo "- **Create tasks**: \`trekker task create -t \"title\"\` (NOT TaskCreate)"
    echo "- **Update status**: \`trekker task update <id> -s in_progress\` (NOT TaskUpdate)"
    echo "- **Track progress**: \`trekker comment add <id> -a claude -c \"...\"\`"
    echo "- **Find ready work**: \`trekker ready\`"
    echo "- **Search context**: \`trekker search \"<keyword>\"\`"
    echo ""
    echo "Trekker persists across sessions and context resets. Claude's internal tools do not."
    echo ""
}
