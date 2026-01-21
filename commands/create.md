---
name: trekker:create
description: Create a new task interactively
---

Create a new task in trekker.

**IMPORTANT**: `/trekker:create` is a skill (invoke via Skill tool), NOT a bash command. Use `trekker task create` CLI as shown below.

## Interactive Flow

1. Ask for the task title (required)
2. Ask for the task type context:
   - Is this part of an epic? If so, which one?
3. Ask for priority (0-5, default 2)
4. Ask for description (optional)
5. Ask for tags (optional, comma-separated)

## Execution

```bash
trekker task create -t "<title>" [-d "<description>"] [-p <priority>] [-e <epic-id>] [--tags "<tags>"]
```

## After Creation

Show the created task details and ask if the user wants to:
- Start working on it immediately (set to in_progress)
- Link it to another task as a dependency
- Create a subtask
