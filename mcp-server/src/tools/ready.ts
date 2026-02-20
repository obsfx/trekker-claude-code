import type { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { runTrekker } from '../cli-runner.js';
import type { ReadyTask } from '../types.js';

export function registerReadyTools(server: McpServer): void {
  server.registerTool(
    'trekker_task_ready',
    {
      title: 'Ready Tasks',
      description: 'Show tasks that are ready to work on (unblocked, todo) with their downstream dependents',
      inputSchema: {},
    },
    async () => {
      const result = await runTrekker<ReadyTask[]>(['ready']);
      return {
        content: [{ type: 'text', text: JSON.stringify(result, null, 2) }],
      };
    }
  );
}
