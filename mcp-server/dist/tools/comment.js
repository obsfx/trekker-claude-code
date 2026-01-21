import * as z from 'zod';
import { runTrekker } from '../cli-runner.js';
export function registerCommentTools(server) {
    server.registerTool('trekker_comment_add', {
        title: 'Add Comment',
        description: 'Add a comment to a task',
        inputSchema: {
            taskId: z.string().describe('Task ID (e.g., TREK-1)'),
            agent: z.string().describe('Agent name (who is adding the comment)'),
            content: z.string().describe('Comment content'),
        },
    }, async ({ taskId, agent, content }) => {
        const result = await runTrekker(['comment', 'add', taskId, '-a', agent, '-c', content]);
        return {
            content: [{ type: 'text', text: JSON.stringify(result, null, 2) }],
        };
    });
    server.registerTool('trekker_comment_list', {
        title: 'List Comments',
        description: 'List comments on a task',
        inputSchema: {
            taskId: z.string().describe('Task ID (e.g., TREK-1)'),
        },
    }, async ({ taskId }) => {
        const result = await runTrekker(['comment', 'list', taskId]);
        return {
            content: [{ type: 'text', text: JSON.stringify(result, null, 2) }],
        };
    });
    server.registerTool('trekker_comment_update', {
        title: 'Update Comment',
        description: 'Update a comment',
        inputSchema: {
            commentId: z.string().describe('Comment ID (e.g., CMT-1)'),
            content: z.string().describe('New comment content'),
        },
    }, async ({ commentId, content }) => {
        const result = await runTrekker(['comment', 'update', commentId, '-c', content]);
        return {
            content: [{ type: 'text', text: JSON.stringify(result, null, 2) }],
        };
    });
    server.registerTool('trekker_comment_delete', {
        title: 'Delete Comment',
        description: 'Delete a comment',
        inputSchema: {
            commentId: z.string().describe('Comment ID (e.g., CMT-1)'),
        },
    }, async ({ commentId }) => {
        const result = await runTrekker(['comment', 'delete', commentId]);
        return {
            content: [{ type: 'text', text: JSON.stringify(result, null, 2) }],
        };
    });
}
//# sourceMappingURL=comment.js.map