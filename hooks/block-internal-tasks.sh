#!/bin/bash
# PreToolUse hook: Block Claude's internal task tools — enforce Trekker usage
cat > /dev/null
cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "BLOCKED: Do not use Claude's internal task tools. Use Trekker MCP tools instead (they persist across sessions). Equivalents: TaskCreate->trekker_task_create, TaskUpdate->trekker_task_update, TaskList->trekker_task_list, TaskGet->trekker_task_show, TodoWrite->trekker_task_create+trekker_task_update"
  }
}
EOF
