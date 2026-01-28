name: find-duplicates
description: MANDATORY before creating any task. Use search to detect duplicates and prevent redundant work.

## CRITICAL: Search Before Creating ANY Task

**You MUST search before creating any task.**

```bash
trekker search "<task description you're about to create>"
```

Search uses semantic mode by default - it finds related work even when terminology differs.

## When to Use (MANDATORY)

- **BEFORE creating ANY new task** - non-negotiable
- **User reports issue** - check if already tracked
- **Grooming backlog** - find consolidation opportunities
- **Starting new feature** - find related past work

## Commands

```bash
# Search for similar tasks before creating
trekker search "fix authentication bug"

# Search with higher threshold for precision
trekker search "performance issue" --threshold 0.7

# Search specific type
trekker search "login timeout" --type task
```

## MANDATORY Workflow

```
1. SEARCH: trekker search "<what you're about to create>"
2. REVIEW results
3. DECIDE based on score:
   - 90%+ → DO NOT create, update existing task
   - 75-89% → Review carefully, likely related
   - <75% → Safe to create new
4. CREATE in Trekker FIRST (if no duplicate)
5. MIRROR to TodoWrite after
```

## Score Guide

| Score | Action |
|-------|--------|
| 95%+ | **STOP** - Update existing task instead |
| 85-94% | Review - likely the same issue |
| 75-84% | Related - consider linking |
| <75% | Different - safe to create |

## Anti-Patterns (DO NOT)

- Creating task without searching first
- Ignoring high similarity scores
- Creating in TodoWrite without checking Trekker first

## Trekker is Primary

Always:
1. Check Trekker for duplicates FIRST
2. Create in Trekker FIRST
3. Then mirror to TodoWrite
