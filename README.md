# Trekker Claude Code Plugin

A Claude Code plugin for [trekker](https://github.com/obsfx/trekker), the AI-optimized issue tracker. Provides MCP tools, slash commands, agents, and skills for seamless task management in Claude Code.

## Prerequisites

- [trekker](https://github.com/obsfx/trekker) CLI installed globally
- Node.js 18+
- Claude Code CLI

## Installation

### 1. Install Trekker CLI

```bash
npm install -g @obsfx/trekker
```

### 2. Clone and Build the Plugin

```bash
git clone https://github.com/obsfx/trekker-claude-code.git
cd trekker-claude-code/mcp-server
pnpm install
pnpm build
```

### 3. Configure Claude Code

Add the MCP server to your Claude Code settings (`~/.claude/settings.json`):

```json
{
  "mcpServers": {
    "trekker": {
      "command": "node",
      "args": ["/path/to/trekker-claude-code/mcp-server/dist/index.js"]
    }
  }
}
```

### 4. Install the Plugin

Copy or symlink the plugin to your Claude plugins directory:

```bash
# Option 1: Symlink (recommended for development)
ln -s /path/to/trekker-claude-code ~/.claude/plugins/trekker

# Option 2: Copy
cp -r /path/to/trekker-claude-code ~/.claude/plugins/trekker
```

## Features

### MCP Tools (17 tools)

The MCP server exposes trekker functionality as tools:

| Tool | Description |
|------|-------------|
| `trekker_task_create` | Create a new task |
| `trekker_task_list` | List tasks with filters |
| `trekker_task_show` | Show task details |
| `trekker_task_update` | Update task fields |
| `trekker_task_delete` | Delete a task |
| `trekker_epic_create` | Create an epic |
| `trekker_epic_list` | List epics |
| `trekker_epic_show` | Show epic details |
| `trekker_epic_update` | Update an epic |
| `trekker_epic_delete` | Delete an epic |
| `trekker_subtask_create` | Create a subtask |
| `trekker_subtask_list` | List subtasks |
| `trekker_subtask_update` | Update a subtask |
| `trekker_subtask_delete` | Delete a subtask |
| `trekker_comment_add` | Add a comment |
| `trekker_comment_list` | List comments |
| `trekker_comment_update` | Update a comment |
| `trekker_comment_delete` | Delete a comment |
| `trekker_dep_add` | Add a dependency |
| `trekker_dep_remove` | Remove a dependency |
| `trekker_dep_list` | List dependencies |
| `trekker_init` | Initialize trekker |
| `trekker_quickstart` | Get workflow guide |
| `trekker_wipe` | Wipe database |

### Slash Commands (11 commands)

| Command | Description |
|---------|-------------|
| `/prime` | Load workflow context |
| `/create` | Interactive task creation |
| `/list` | List tasks with filters |
| `/show` | Show task details |
| `/ready` | Find unblocked work |
| `/start` | Begin working on a task |
| `/done` | Complete task with summary |
| `/blocked` | Mark task as blocked |
| `/epic` | Manage epics |
| `/comment` | Add comment to task |
| `/deps` | Manage dependencies |

### Task Agent

The `task-agent` provides autonomous task completion:

1. **Discovery** - Find ready tasks
2. **Engagement** - Select and start a task
3. **Execution** - Complete the work
4. **Documentation** - Track progress and discoveries
5. **Closure** - Add summary and mark complete
6. **Iteration** - Move to next task

### Hooks

The plugin automatically loads trekker workflow context:

- **SessionStart**: Runs `trekker --toon quickstart` when Claude Code starts
- **PreCompact**: Reloads context before conversation compaction

## Usage

### Initialize Trekker in Your Project

```bash
cd your-project
trekker init
```

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
/ready          # Find tasks to work on
/start TREK-1   # Start a task
/done TREK-1    # Complete with summary
```

## Project Structure

```
trekker-claude-code/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata and hooks
├── mcp-server/
│   ├── src/
│   │   ├── index.ts          # MCP server entry
│   │   ├── cli-runner.ts     # CLI execution utility
│   │   ├── types.ts          # TypeScript types
│   │   └── tools/            # MCP tool definitions
│   ├── package.json
│   └── tsconfig.json
├── commands/                 # Slash command definitions
├── agents/
│   └── task-agent.md         # Task completion agent
├── skills/
│   └── trekker/              # Trekker workflow skill
│       ├── SKILL.md
│       ├── README.md
│       └── CLAUDE.md
└── docs/
    └── plans/                # Design documents
```

## Development

```bash
# Watch mode for development
cd mcp-server
pnpm dev

# Build for production
pnpm build
```

## License

MIT
