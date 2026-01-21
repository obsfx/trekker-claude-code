---
name: trekker:start
description: Start working on a task
---

Begin working on a task by setting its status to in_progress.

**IMPORTANT**: `/trekker:start` is a skill (invoke via Skill tool), NOT a bash command. There is no `trekker start` CLI command. Use `trekker task update` as shown below.

## Arguments

- `$1`: Task ID (e.g., TREK-1) - optional

If no task ID provided:
1. Show current in_progress tasks
2. Show ready tasks (todo status)
3. Ask which task to start

## Execution

```bash
# Show task details first
trekker task show <task-id>

# Set status to in_progress
trekker task update <task-id> -s in_progress
```

## After Starting

Display the task details and any relevant comments for context.
