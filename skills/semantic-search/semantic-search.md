name: semantic-search
description: PRIMARY tool for gathering context. Find tasks by meaning, not keywords. Use BEFORE any action.

## CRITICAL: Use This First

**Semantic search is your PRIMARY tool for gathering context.**

Before starting ANY work:
```bash
trekker search "<what you're about to do>"
```

This finds related past work even when terminology differs. Search uses semantic mode by default.

## When to Use (ALWAYS)

- **Before creating tasks** - find existing work
- **Before starting work** - gather context
- **When investigating issues** - find related bugs
- **When user describes problem** - understand history
- **When resuming work** - recover context

## Examples

| User Says | Command | Finds |
|-----------|---------|-------|
| "login problems" | `trekker search "login problems"` | "authentication bug", "OAuth expired" |
| "app is slow" | `trekker search "performance issues"` | "latency", "optimization" |
| "fix the auth" | `trekker search "authentication"` | Related auth work |

## Commands

```bash
# Semantic search (default mode)
trekker search "user cannot access account"

# Filter by type
trekker search "deployment issues" --type task

# Filter by status
trekker search "memory leak" --status todo,in_progress

# Keyword search if needed
trekker search "exact error message" --mode keyword

# Hybrid (combines both)
trekker search "caching" --mode hybrid
```

## Workflow: Before ANY Task Operation

```
1. SEARCH: trekker search "<description>"
2. REVIEW: Check if similar work exists
3. DECIDE: Update existing OR create new
4. SYNC: Mirror to TodoWrite after Trekker
```

## Score Interpretation

| Score | Meaning | Action |
|-------|---------|--------|
| 0.90+ | Same issue | DO NOT create, update existing |
| 0.75-0.89 | Highly related | Review carefully, may link |
| 0.60-0.74 | Possibly related | Safe to create, reference existing |
| <0.60 | Different topic | Safe to create new |

## Trekker is Primary

Remember: Trekker is the source of truth.
- Search Trekker FIRST
- Create in Trekker FIRST
- Then mirror to TodoWrite
