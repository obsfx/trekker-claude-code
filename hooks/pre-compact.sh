#!/bin/bash
# Pre-compact hook: Gather context about in-progress work before compaction

# Check if trekker is initialized
if [ ! -d ".trekker" ]; then
    echo "# Trekker Context (not initialized in this directory)"
    exit 0
fi

echo "# Trekker Pre-Compact Context"
echo ""
echo "## IMPORTANT: Before this context is compacted, save your progress!"
echo ""
echo "For each in-progress task below, add a checkpoint comment:"
echo "\`\`\`bash"
echo "trekker comment add <TASK-ID> -a \"claude\" -c \"Checkpoint: <what's done>, <what's next>, <files modified>\""
echo "\`\`\`"
echo ""

# Get in-progress tasks
echo "## In-Progress Tasks"
echo ""

trekker --toon task list --status in_progress 2>/dev/null || echo "No tasks in progress."

echo ""
echo "## Comments on In-Progress Tasks"
echo ""

# Get task IDs and fetch comments for each
for task_id in $(trekker --json task list --status in_progress 2>/dev/null | grep -o '"id":"[^"]*"' | cut -d'"' -f4); do
    echo "### $task_id"
    trekker --toon comment list "$task_id" 2>/dev/null | tail -5
    echo ""
done

# Show todo tasks as context for what's next
echo "## Ready Tasks (todo) - Top 5"
echo ""
trekker --toon task list --status todo 2>/dev/null | head -10 || echo "No todo tasks."

echo ""
echo "---"
echo "Remember to add checkpoint comments before context resets!"
