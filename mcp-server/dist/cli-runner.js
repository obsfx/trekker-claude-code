import { execFile } from 'node:child_process';
import { promisify } from 'node:util';
const execFileAsync = promisify(execFile);
export async function runTrekker(args, options = {}) {
    const { cwd = process.cwd(), json = true, toon = false } = options;
    const fullArgs = [];
    if (json)
        fullArgs.push('--json');
    if (toon)
        fullArgs.push('--toon');
    fullArgs.push(...args);
    try {
        const { stdout, stderr } = await execFileAsync('trekker', fullArgs, {
            cwd,
            timeout: 30000,
        });
        if (stderr && !json) {
            console.error('trekker stderr:', stderr);
        }
        if (json && stdout.trim()) {
            try {
                const data = JSON.parse(stdout);
                return { success: true, data };
            }
            catch {
                return { success: true, data: stdout };
            }
        }
        return { success: true, data: stdout };
    }
    catch (error) {
        const err = error;
        return {
            success: false,
            error: err.stderr || err.message || 'Unknown error',
        };
    }
}
export async function runTrekkerText(args, options = {}) {
    return runTrekker(args, { ...options, json: false });
}
//# sourceMappingURL=cli-runner.js.map