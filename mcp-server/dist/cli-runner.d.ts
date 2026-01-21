import type { CliRunnerOptions, TrekkerResult } from './types.js';
export declare function runTrekker<T = unknown>(args: string[], options?: CliRunnerOptions): Promise<TrekkerResult<T>>;
export declare function runTrekkerText(args: string[], options?: Omit<CliRunnerOptions, 'json'>): Promise<TrekkerResult<string>>;
//# sourceMappingURL=cli-runner.d.ts.map