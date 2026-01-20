#!/bin/bash
# Session start hook: Load trekker context and current work status

# Check if trekker is initialized
if [ ! -d ".trekker" ]; then
    echo "# Trekker (not initialized)"
    echo ""
    echo "Run \`trekker init\` to initialize issue tracking in this project."
    exit 0
fi

echo "# Trekker Session Context"
echo ""

# Check for in-progress work first
IN_PROGRESS_COUNT=$(trekker --json task list --status in_progress 2>/dev/null | grep -o '"id"' | wc -l | tr -d ' ')

if [ "$IN_PROGRESS_COUNT" -gt 0 ]; then
    echo "## Resume In-Progress Work"
    echo ""
    trekker --toon task list --status in_progress 2>/dev/null
    echo ""

    # Show recent comments for context
    echo "## Recent Context (last comments)"
    echo ""
    for task_id in $(trekker --json task list --status in_progress 2>/dev/null | grep -o '"id":"[^"]*"' | cut -d'"' -f4); do
        echo "### $task_id"
        trekker --toon comment list "$task_id" 2>/dev/null | tail -3
        echo ""
    done
else
    echo "## No Work In Progress"
    echo ""

    # Show ready tasks
    TODO_COUNT=$(trekker --json task list --status todo 2>/dev/null | grep -o '"id"' | wc -l | tr -d ' ')
    if [ "$TODO_COUNT" -gt 0 ]; then
        echo "### Ready Tasks (top 5)"
        echo ""
        trekker --toon task list --status todo 2>/dev/null | head -8
    else
        echo "No tasks pending. Create tasks with:"
        echo "\`\`\`bash"
        echo "trekker task create -t \"Task title\" [-d \"description\"] [-p 0-5]"
        echo "\`\`\`"
    fi
fi

echo ""
echo "---"
echo "**Workflow**: Set \`in_progress\` when starting, add summary comment, then \`completed\`."
echo "**Quick ref**: \`trekker quickstart\`"
