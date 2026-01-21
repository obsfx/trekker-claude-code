---
name: trekker:list
description: List tasks with optional filters
---

List tasks in trekker with optional filtering.

**IMPORTANT**: `/trekker:list` is a skill (invoke via Skill tool), NOT a bash command. Use `trekker task list` CLI as shown below.

## Options

Ask the user what they want to filter by:
- Status: todo, in_progress, completed, wont_fix, archived
- Epic: specific epic ID
- No filter: show all tasks

## Execution

```bash
# List all tasks
trekker --toon task list

# Filter by status
trekker --toon task list --status <status>

# Filter by epic
trekker --toon task list --epic <epic-id>
```

## Output

Use `--toon` flag for token-efficient output when listing many tasks.
