name: semantic-search
description: Find tasks, epics, and comments by meaning - not just keywords. Use when exact search terms are unknown.

## Critical Rule: Bidirectional Sync

**Trekker and Claude's TodoWrite MUST stay in sync:**
- Trekker change → Update TodoWrite
- TodoWrite change → Update Trekker
- NEVER let them get out of sync

## When to Use

- You don't know exact terminology in existing tasks
- Investigating bug/issue to find related past work
- User describes problem in natural language
- Checking if similar work was done before

## Examples

| User Says | Finds |
|-----------|-------|
| "login problems" | "authentication bug", "OAuth token expired" |
| "app is slow" | "performance optimization", "latency" |

## Commands

```bash
trekker semantic-search "user cannot access account"
trekker semantic-search "deployment issues" --type task
trekker semantic-search "memory leak" --status todo,in_progress
trekker semantic-search "caching" --threshold 0.7
```

## Workflow: Before Creating a Task

1. Search first: `trekker semantic-search "<description>"`
2. If similar found → Review, add comment to existing
3. If no duplicate → Create new task
4. SYNC: Update both Trekker AND TodoWrite

## Score Interpretation

| Score | Meaning |
|-------|---------|
| 0.90+ | Almost certainly same issue |
| 0.75-0.89 | Highly related |
| 0.60-0.74 | Possibly related |
| <0.60 | Tangentially related |
