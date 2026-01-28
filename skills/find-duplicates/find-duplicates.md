name: find-duplicates
description: Detect duplicate tasks before creating new ones. MUST use before creating any task.

## Critical Rule: Bidirectional Sync

**Trekker and Claude's TodoWrite MUST stay in sync:**
- Trekker change → Update TodoWrite
- TodoWrite change → Update Trekker
- NEVER let them get out of sync

## When to Use (MANDATORY)

- BEFORE creating ANY new task
- User reports issue that "sounds familiar"
- Grooming backlog to consolidate

## Commands

```bash
trekker similar TREK-45
trekker similar TREK-45 --threshold 0.6
trekker similar "fix authentication bug"
```

## Workflow

1. ALWAYS run: `trekker similar "<task description>"`
2. Review results
3. Score >= 90% → DO NOT create, update existing
4. Score 70-89% → Review carefully, may be related
5. Score < 70% → Safe to create new
6. SYNC both Trekker AND TodoWrite

## Score Guide

| Score | Action |
|-------|--------|
| 95%+ | DO NOT create. Update existing. |
| 85-94% | Review carefully |
| 70-84% | Probably different |
| <70% | Safe to create |
