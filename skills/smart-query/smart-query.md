name: smart-query
description: Query tasks using natural language questions.

## Critical Rule: Bidirectional Sync

**Trekker and Claude's TodoWrite MUST stay in sync:**
- Trekker change → Update TodoWrite
- TodoWrite change → Update Trekker
- NEVER let them get out of sync

## When to Use

User asks questions like:
- "What's blocking the release?"
- "What did we work on last week?"
- "Are there urgent bugs?"
- "What tasks are stuck?"

## Query Translations

| Natural Language | Command |
|-----------------|---------|
| "What's in progress?" | `trekker task list --status in_progress` |
| "Anything stuck?" | `trekker search "blocked stuck"` |
| "Urgent bugs" | `trekker search "bug" --status todo` |
| "Everything about auth" | `trekker search "authentication"` |

## Query Patterns

```bash
# Status queries
trekker task list --status todo
trekker task list --status in_progress
trekker task list --status completed

# Priority queries
trekker task list --priority 0,1 --status todo

# Semantic queries (default mode)
trekker search "performance optimization"
trekker search "security vulnerability"

# Keyword mode for exact matches
trekker search "specific error message" --mode keyword

# Relationship queries
trekker dep list TREK-10
trekker task list --epic EPIC-2
```
