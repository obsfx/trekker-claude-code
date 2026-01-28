#!/bin/bash
# Pre-compact hook: Gather and preserve Trekker state before context compaction

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

# Early return if trekker not initialized
if [ ! -d ".trekker" ]; then
    echo "# Trekker Context (not initialized)"
    echo ""
    echo "Trekker is not initialized in this directory."
    echo "To initialize: \`trekker init\`"
    exit 0
fi

echo "# Trekker State Snapshot"
echo ""
echo "**IMPORTANT**: Save your progress before context compaction!"
echo ""

# Fetch all state upfront
IN_PROG_OUTPUT=$(trekker --toon task list --status in_progress 2>/dev/null)
TODO_OUTPUT=$(trekker --toon task list --status todo 2>/dev/null)
COMPLETED_OUTPUT=$(trekker --toon task list --status completed 2>/dev/null)
EPIC_OUTPUT=$(trekker --toon epic list 2>/dev/null)

IN_PROG=$(echo "$IN_PROG_OUTPUT" | get_toon_count)
TODO=$(echo "$TODO_OUTPUT" | get_toon_count)
COMPLETED=$(echo "$COMPLETED_OUTPUT" | get_toon_count)
EPIC_COUNT=$(echo "$EPIC_OUTPUT" | get_toon_count)

IN_PROG=${IN_PROG:-0}
TODO=${TODO:-0}
COMPLETED=${COMPLETED:-0}
EPIC_COUNT=${EPIC_COUNT:-0}

# Section: Active work
print_active_work_section() {
    echo "## Active Work (In-Progress)"
    echo ""

    if [ "$IN_PROG" -eq 0 ]; then
        echo "No tasks currently in progress."
        echo ""
        return
    fi

    trekker --toon task list --status in_progress 2>/dev/null
    echo ""

    echo "### Context for Active Tasks"
    echo ""

    for task_id in $(echo "$IN_PROG_OUTPUT" | get_toon_task_ids); do
        print_task_context "$task_id"
    done

    echo "### Required: Add Checkpoint Comment"
    echo ""
    echo "Before compaction, add a checkpoint to each in-progress task:"
    echo ""

    for task_id in $(echo "$IN_PROG_OUTPUT" | get_toon_task_ids); do
        print_checkpoint_template "$task_id"
    done
}

# Section: Ready work
print_ready_work_section() {
    echo "## Ready Work (Top 5 Todo)"
    echo ""

    if [ "$TODO" -eq 0 ]; then
        echo "No tasks in todo status."
        echo ""
        return
    fi

    trekker --toon task list --status todo 2>/dev/null | head -10
    echo ""
}

# Section: State summary table
print_state_summary() {
    echo "## State Summary"
    echo ""
    echo "| Status | Count |"
    echo "|--------|-------|"
    echo "| In Progress | $IN_PROG |"
    echo "| Todo | $TODO |"
    echo "| Completed | $COMPLETED |"
    echo "| Epics | $EPIC_COUNT |"
    echo ""
}

# Section: Recovery instructions
print_recovery_instructions() {
    echo "---"
    echo ""
    echo "## After Compaction - MANDATORY Recovery Steps"
    echo ""
    echo "**You will NOT remember this session. Use CLI to restore context:**"
    echo ""
    echo "1. **SEARCH FIRST**: \`trekker search \"<what you're working on>\"\`"
    echo "2. Check in-progress work: \`trekker --toon task list --status in_progress\`"
    echo "3. Review history: \`trekker history --limit 15\`"
    echo "4. Read task comments: \`trekker comment list <task-id>\`"
    echo "5. Resume work or pick next task from backlog"
    echo ""
    echo "**Rule**: If context is unclear → STOP → SEARCH → RESUME"
    echo ""
    echo "**Workflow**: Set \`in_progress\` when starting, add summary comment, then \`completed\`."
    echo "**Full guide**: Run \`trekker quickstart\` for complete command reference."
}

# Main flow
print_active_work_section
print_ready_work_section

echo "## Recent Activity"
echo ""
trekker --toon history --limit 5 2>/dev/null || echo "No recent history available."
echo ""

print_state_summary
print_recovery_instructions
