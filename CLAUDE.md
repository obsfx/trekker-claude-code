# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Trekker Claude Code Plugin - An AI-optimized issue tracker plugin for Claude Code. Provides MCP tools, slash commands, agents, and skills for persistent task management across sessions. The core state is stored in SQLite (`.trekker/trekker.db`) which survives context resets.

**Prerequisites**: `trekker` CLI must be installed globally (`npm install -g @obsfx/trekker`).

## Search-First Philosophy

This plugin enforces a **search-first workflow**. The core principle:

> You don't remember previous sessions. `trekker search` restores that context.

**Before ANY action** (creating tasks, starting work, investigating issues):
```bash
trekker search "<keywords>"
```

This prevents duplicate work, reveals past decisions, and enables continuity across sessions.

## Development Commands

```bash
# From mcp-server/ directory
pnpm install          # Install dependencies
pnpm build            # Bundle with esbuild -> dist/index.js
pnpm build:tsc        # TypeScript compilation only
pnpm dev              # Watch mode (tsc --watch)
```

## Architecture

```
Plugin System (Claude Code)
    ↓
MCP Server (mcp-server/src/index.ts)
    ↓
Tool Registry (24 tools in mcp-server/src/tools/)
    ↓
CLI Runner (mcp-server/src/cli-runner.ts)
    ↓
External `trekker` CLI binary
    ↓
SQLite Database (.trekker/trekker.db)
```

**MCP Server** (`mcp-server/`): Thin wrapper that exposes trekker CLI as MCP tools. All business logic lives in the external `trekker` binary.

**Tool Modules** (`mcp-server/src/tools/`):
- `task.ts` - 5 task CRUD tools
- `epic.ts` - 5 epic CRUD tools
- `subtask.ts` - 4 subtask tools
- `comment.ts` - 4 comment tools
- `dependency.ts` - 3 dependency tools
- `system.ts` - 3 system tools (init, quickstart, wipe)

**Plugin Configuration** (`.claude-plugin/`):
- `plugin.json` - Metadata, MCP server config, hooks registration
- `marketplace.json` - GitHub distribution metadata

**Hooks** (`hooks/`):
- `session-start.sh` - Loads context on startup (shows in-progress/ready tasks)
- `pre-compact.sh` - Preserves state before context compaction

**Slash Commands** (`commands/`): 13 markdown files defining user-invocable commands.

**Skills** (`skills/trekker/`): Workflow patterns and essential commands guide.

## Key Patterns

**Tool Registration** (consistent across all tool modules):
```typescript
export function registerXxxTools(server: McpServer): void {
  server.registerTool('trekker_xxx_action', { inputSchema }, handler);
}
```

**CLI Execution** (`cli-runner.ts`):
- Executes `trekker` with args via `execFile`
- 30-second timeout
- Returns `TrekkerResult<T>` with success/data/error
- Supports `--toon` flag for token-efficient output

**Type Definitions** (`types.ts`):
- `TaskStatus`: `'todo' | 'in_progress' | 'completed' | 'wont_fix' | 'archived'`
- `EpicStatus`: `'todo' | 'in_progress' | 'completed' | 'archived'`
- `Priority`: `0` (critical) to `5` (someday)

## Bundling Strategy

The MCP server is bundled with esbuild to a single ESM file (`dist/index.js`) for zero-dependency installation. The dist file is NOT committed to git - it's built during plugin installation.
