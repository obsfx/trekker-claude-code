#!/bin/bash
# Session start hook: Load trekker context and restore state for new sessions

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

# Early return if trekker not initialized
if [ ! -d ".trekker" ]; then
    echo "# Trekker (not initialized)"
    echo ""
    echo "Run \`trekker init\` to initialize issue tracking in this project."
    exit 0
fi

echo "# Trekker Session Context"
echo ""

# Fetch state
TODO_OUTPUT=$(trekker --toon task list --status todo 2>/dev/null)
IN_PROG_OUTPUT=$(trekker --toon task list --status in_progress 2>/dev/null)
EPIC_OUTPUT=$(trekker --toon epic list 2>/dev/null)

TODO=$(echo "$TODO_OUTPUT" | get_toon_count)
IN_PROG=$(echo "$IN_PROG_OUTPUT" | get_toon_count)
EPIC_COUNT=$(echo "$EPIC_OUTPUT" | get_toon_count)

TODO=${TODO:-0}
IN_PROG=${IN_PROG:-0}
EPIC_COUNT=${EPIC_COUNT:-0}

echo "**State**: $IN_PROG in-progress | $TODO todo | $EPIC_COUNT epics"
echo ""

# Show in-progress work with context
print_in_progress_section() {
    echo "## Resume In-Progress Work"
    echo ""
    trekker --toon task list --status in_progress 2>/dev/null
    echo ""

    echo "### Task Context"
    echo ""

    for task_id in $(echo "$IN_PROG_OUTPUT" | get_toon_task_ids); do
        print_task_context "$task_id"
    done

    echo "### Next Steps"
    echo ""
    echo "1. Review the context above"
    echo "2. If resuming from compaction, check recent checkpoint comments for state"
    echo "3. Continue working on the task"
    echo "4. Add progress/checkpoint comments as needed"
    echo ""
}

# Show ready tasks when no work in progress
print_no_work_section() {
    echo "## No Work In Progress"
    echo ""

    if [ "$TODO" -eq 0 ]; then
        echo "No pending tasks."
        echo ""
        echo "### Create a Task"
        echo ""
        echo "\`\`\`bash"
        echo "trekker task create -t \"Task title\" [-d \"description\"] [-p 0-5] [-e EPIC-1]"
        echo "\`\`\`"
        echo ""
        return
    fi

    echo "### Ready Tasks (sorted by priority)"
    echo ""
    trekker --toon task list --status todo 2>/dev/null | head -12
    echo ""

    echo "### To Start Working"
    echo ""
    echo "1. Pick a task: \`trekker task show <id>\`"
    echo "2. Check dependencies: \`trekker dep list <id>\`"
    echo "3. Start work: \`trekker task update <id> -s in_progress\`"
    echo ""
}

# Main flow with early return pattern
if [ "$IN_PROG" -gt 0 ]; then
    print_in_progress_section
else
    print_no_work_section
fi

# Recent activity
echo "## Recent Activity (last 3)"
echo ""
trekker --toon history --limit 3 2>/dev/null || echo "No recent history."
echo ""

# Search reminder and footer
print_search_reminder
print_workflow_footer
