---
name: trekker:ready
description: Find tasks ready to work on
---

Find unblocked tasks that are ready to be worked on.

**IMPORTANT**: `/trekker:ready` is a skill (invoke via Skill tool), NOT a bash command. Use `trekker task list` CLI as shown below.

## Execution

```bash
trekker --toon task list --status todo
```

## Prioritization

Present tasks sorted by priority (0=critical first).

## After Listing

Ask if the user wants to start working on one of the ready tasks.
If yes, use `/trekker:start <task-id>` workflow.
