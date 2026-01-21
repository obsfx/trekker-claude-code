---
name: trekker:show
description: Show details of a specific task
---

Show detailed information about a task.

**IMPORTANT**: `/trekker:show` is a skill (invoke via Skill tool), NOT a bash command. Use `trekker task show` CLI as shown below.

## Arguments

- `$1`: Task ID (e.g., TREK-1) - required

If no task ID provided, ask the user which task to show.

## Execution

```bash
trekker task show <task-id>
```

## Also Show

After showing the task, also display:
- Comments: `trekker comment list <task-id>`
- Dependencies: `trekker dep list <task-id>`
