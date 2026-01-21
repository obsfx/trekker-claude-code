#!/bin/bash
# Pre-compact hook: Gather and preserve Trekker state before context compaction
# This output will be included in the compacted context to help restore state

# Check if trekker is initialized
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

# ============================================================================
# Helper: Extract count from toon format (first line shows [count])
# ============================================================================
get_toon_count() {
    head -1 | grep -o '^\[[0-9]*\]' | tr -d '[]'
}

# Helper: Extract task IDs from toon list format (CSV rows after header)
get_toon_task_ids() {
    tail -n +2 | cut -d',' -f1 | sed 's/^[[:space:]]*//' | grep -E '^TREK-[0-9]+$'
}

# ============================================================================
# SECTION 1: Active Work (In-Progress Tasks)
# ============================================================================
echo "## Active Work (In-Progress)"
echo ""

IN_PROG_OUTPUT=$(trekker --toon task list --status in_progress 2>/dev/null)
IN_PROGRESS_COUNT=$(echo "$IN_PROG_OUTPUT" | get_toon_count)
IN_PROGRESS_COUNT=${IN_PROGRESS_COUNT:-0}

if [ "$IN_PROGRESS_COUNT" -gt 0 ]; then
    trekker --toon task list --status in_progress 2>/dev/null
    echo ""

    # Show task details with recent comments for each in-progress task
    echo "### Context for Active Tasks"
    echo ""

    for task_id in $(echo "$IN_PROG_OUTPUT" | get_toon_task_ids); do
        echo "#### $task_id"
        echo ""

        # Get task description from toon format
        TASK_OUTPUT=$(trekker --toon task show "$task_id" 2>/dev/null)
        TASK_DESC=$(echo "$TASK_OUTPUT" | grep '^description:' | cut -d' ' -f2-)
        if [ -n "$TASK_DESC" ] && [ "$TASK_DESC" != "null" ]; then
            echo "**Description**: $TASK_DESC"
            echo ""
        fi

        # Get last 3 comments
        echo "**Recent Comments:**"
        trekker --toon comment list "$task_id" 2>/dev/null | tail -6
        echo ""

        # Show dependencies
        DEP_OUTPUT=$(trekker --toon dep list "$task_id" 2>/dev/null)
        DEPS=$(echo "$DEP_OUTPUT" | grep -c '^  - ')
        if [ "$DEPS" -gt 0 ]; then
            echo "**Dependencies:**"
            trekker --toon dep list "$task_id" 2>/dev/null
            echo ""
        fi
    done

    # Checkpoint reminder with template
    echo "### Required: Add Checkpoint Comment"
    echo ""
    echo "Before compaction, add a checkpoint to each in-progress task:"
    echo ""
    for task_id in $(echo "$IN_PROG_OUTPUT" | get_toon_task_ids); do
        echo "\`\`\`bash"
        echo "trekker comment add $task_id -a \"claude\" -c \"Checkpoint: [what's done]. Next: [what's next]. Files: [modified files]. State: [current state]\""
        echo "\`\`\`"
        echo ""
    done
else
    echo "No tasks currently in progress."
    echo ""
fi

# ============================================================================
# SECTION 2: Ready Work (Todo Tasks)
# ============================================================================
echo "## Ready Work (Top 5 Todo)"
echo ""

TODO_OUTPUT=$(trekker --toon task list --status todo 2>/dev/null)
TODO_COUNT=$(echo "$TODO_OUTPUT" | get_toon_count)
TODO_COUNT=${TODO_COUNT:-0}

if [ "$TODO_COUNT" -gt 0 ]; then
    trekker --toon task list --status todo 2>/dev/null | head -10
else
    echo "No tasks in todo status."
fi
echo ""

# ============================================================================
# SECTION 3: Recent Activity (Last 5 Events)
# ============================================================================
echo "## Recent Activity"
echo ""

trekker --toon history --limit 5 2>/dev/null || echo "No recent history available."
echo ""

# ============================================================================
# SECTION 4: State Summary
# ============================================================================
echo "## State Summary"
echo ""

# Count by status
TODO=$(echo "$TODO_OUTPUT" | get_toon_count)
IN_PROG=$(echo "$IN_PROG_OUTPUT" | get_toon_count)
COMPLETED_OUTPUT=$(trekker --toon task list --status completed 2>/dev/null)
COMPLETED=$(echo "$COMPLETED_OUTPUT" | get_toon_count)
EPIC_OUTPUT=$(trekker --toon epic list 2>/dev/null)
EPIC_COUNT=$(echo "$EPIC_OUTPUT" | get_toon_count)

# Default to 0 if empty
TODO=${TODO:-0}
IN_PROG=${IN_PROG:-0}
COMPLETED=${COMPLETED:-0}
EPIC_COUNT=${EPIC_COUNT:-0}

echo "| Status | Count |"
echo "|--------|-------|"
echo "| In Progress | $IN_PROG |"
echo "| Todo | $TODO |"
echo "| Completed | $COMPLETED |"
echo "| Epics | $EPIC_COUNT |"
echo ""

# ============================================================================
# SECTION 5: Post-Compaction Recovery Instructions
# ============================================================================
echo "---"
echo ""
echo "## After Compaction"
echo ""
echo "To recover context in the new session:"
echo ""
echo "1. Check in-progress work: \`trekker --toon task list --status in_progress\`"
echo "2. Read task comments: \`trekker comment list <task-id>\`"
echo "3. Resume work or pick next task from backlog"
echo ""
echo "**Workflow**: Set \`in_progress\` when starting, add summary comment, then \`completed\`."
echo "**Full guide**: Run \`trekker quickstart\` for complete command reference."
