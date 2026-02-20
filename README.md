# Trekker Claude Code Plugin

A Claude Code plugin for [trekker](https://github.com/obsfx/trekker), the AI-optimized issue tracker. Provides MCP tools, slash commands, agents, and skills for seamless task management in Claude Code.

## Prerequisites

- [trekker](https://github.com/obsfx/trekker) CLI installed globally
- Node.js 18+
- Claude Code CLI

## Installation

### Step 1: Install Trekker CLI

```bash
npm install -g @obsfx/trekker
```

### Step 2: Install the Plugin

#### Option A: Via Plugin Marketplace (Recommended)

```bash
# Add the trekker marketplace
claude plugin marketplace add obsfx/trekker-claude-code

# Install the plugin
claude plugin install trekker
```

Or in Claude Code interactive mode:

```
/plugin marketplace add obsfx/trekker-claude-code
/plugin install trekker
```

The MCP server is bundled with the plugin and auto-configured.

#### Option B: Manual Installation

```bash
# Clone the repository
git clone https://github.com/obsfx/trekker-claude-code.git

# Symlink to Claude plugins directory
ln -s $(pwd)/trekker-claude-code ~/.claude/plugins/trekker
```

### Step 3: Initialize Trekker in Your Project

```bash
cd your-project
trekker init
```

## Features

### MCP Tools (25 tools)

The MCP server exposes trekker functionality as tools:

| Category | Tool | Description |
|----------|------|-------------|
| Task | `trekker_task_create` | Create a new task |
| Task | `trekker_task_list` | List tasks with filters |
| Task | `trekker_task_show` | Show task details |
| Task | `trekker_task_update` | Update task fields |
| Task | `trekker_task_delete` | Delete a task |
| Epic | `trekker_epic_create` | Create an epic |
| Epic | `trekker_epic_list` | List epics |
| Epic | `trekker_epic_show` | Show epic details |
| Epic | `trekker_epic_update` | Update an epic |
| Epic | `trekker_epic_delete` | Delete an epic |
| Subtask | `trekker_subtask_create` | Create a subtask |
| Subtask | `trekker_subtask_list` | List subtasks |
| Subtask | `trekker_subtask_update` | Update a subtask |
| Subtask | `trekker_subtask_delete` | Delete a subtask |
| Comment | `trekker_comment_add` | Add a comment |
| Comment | `trekker_comment_list` | List comments |
| Comment | `trekker_comment_update` | Update a comment |
| Comment | `trekker_comment_delete` | Delete a comment |
| Dependency | `trekker_dep_add` | Add a dependency |
| Dependency | `trekker_dep_remove` | Remove a dependency |
| Dependency | `trekker_dep_list` | List dependencies |
| Search | `trekker_search` | FTS5 full-text search |
| System | `trekker_init` | Initialize trekker |
| System | `trekker_quickstart` | Get workflow guide |
| System | `trekker_wipe` | Wipe database |

### Slash Commands (13 commands)

| Command | Description |
|---------|-------------|
| `/trekker:prime` | Load workflow context |
| `/trekker:create` | Interactive task creation |
| `/trekker:list` | List tasks with filters |
| `/trekker:show` | Show task details |
| `/trekker:ready` | Find unblocked work |
| `/trekker:start` | Begin working on a task |
| `/trekker:done` | Complete task with summary |
| `/trekker:blocked` | Mark task as blocked |
| `/trekker:epic` | Manage epics |
| `/trekker:comment` | Add comment to task |
| `/trekker:deps` | Manage dependencies |
| `/trekker:history` | View audit trail of changes |
| `/trekker:task-agent` | Run autonomous task agent |

### Task Agent

The task agent (`/trekker:task-agent`) provides autonomous task completion:

1. **Discovery** - Find ready tasks
2. **Engagement** - Select and start a task
3. **Execution** - Complete the work
4. **Documentation** - Track progress and discoveries
5. **Closure** - Add summary and mark complete
6. **Iteration** - Move to next task

Invoke with `/trekker:task-agent` to let Claude work through tasks autonomously.

### Hooks

The plugin includes smart hooks for context management:

**SessionStart** - When Claude Code starts:
- Shows in-progress tasks with recent comments (resume context)
- If no work in progress, shows ready tasks
- Provides workflow reminder

**PreCompact** - Before context compaction:
- Reminds to save checkpoint comments
- Lists all in-progress tasks with details
- Shows recent comments for context preservation
- Provides checkpoint comment template

## Usage

### Basic Workflow

```bash
# Create a task
trekker task create -t "Implement feature X" -p 1

# Start working
trekker task update TREK-1 -s in_progress

# Add progress notes
trekker comment add TREK-1 -a "claude" -c "Progress: completed step 1"

# Complete with summary
trekker comment add TREK-1 -a "claude" -c "Summary: implemented X in files A, B"
trekker task update TREK-1 -s completed
```

### Using Slash Commands

In Claude Code:

```
/trekker:ready          # Find tasks to work on
/trekker:start TREK-1   # Start a task
/trekker:done TREK-1    # Complete with summary
/trekker:history        # View recent changes
```

### Context Preservation

Before ending a session or when prompted by PreCompact hook:

```bash
trekker comment add TREK-1 -a "claude" -c "Checkpoint: done X. Next: Y. Files: a.ts, b.ts"
```

## Project Structure

```
trekker-claude-code/
├── .claude-plugin/
│   ├── plugin.json           # Plugin metadata and hooks
│   └── marketplace.json      # Marketplace distribution config
├── mcp-server/
│   ├── src/
│   │   ├── index.ts          # MCP server entry
│   │   ├── cli-runner.ts     # CLI execution utility
│   │   ├── types.ts          # TypeScript types
│   │   └── tools/            # MCP tool definitions
│   ├── package.json
│   └── tsconfig.json
├── commands/                 # Slash command definitions (13 commands)
├── agents/
│   └── task-agent.md         # Task completion agent
├── skills/
│   └── trekker/              # Trekker workflow skill
│       ├── SKILL.md
│       ├── README.md
│       └── CLAUDE.md
├── hooks/
│   ├── session-start.sh      # SessionStart hook script
│   └── pre-compact.sh        # PreCompact hook script
└── docs/
    ├── state-management.md   # SQLite persistence and conflict handling
    └── plans/                # Design documents
```

## Development

```bash
# Clone the repository
git clone https://github.com/obsfx/trekker-claude-code.git
cd trekker-claude-code

# Build MCP server
cd mcp-server
pnpm install
pnpm build

# Watch mode for development
pnpm dev
```

## Troubleshooting

### Plugin not loading

1. Verify trekker CLI is installed: `trekker --version`
2. Check plugin is in correct location: `ls ~/.claude/plugins/trekker`

### MCP tools not available

1. Verify plugin is installed: `ls ~/.claude/plugins/trekker`
2. Check MCP server exists: `ls ~/.claude/plugins/trekker/mcp-server/dist/index.js`
3. Restart Claude Code after installation

### Hooks not running

1. Ensure hook scripts are executable: `chmod +x hooks/*.sh`
2. Verify trekker is initialized in project: `ls .trekker`

## License

MIT
