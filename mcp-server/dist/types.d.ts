export type TaskStatus = 'todo' | 'in_progress' | 'completed' | 'wont_fix' | 'archived';
export type EpicStatus = 'todo' | 'in_progress' | 'completed' | 'archived';
export type Priority = 0 | 1 | 2 | 3 | 4 | 5;
export interface Task {
    id: string;
    projectId: string;
    epicId: string | null;
    parentTaskId: string | null;
    title: string;
    description: string | null;
    priority: Priority;
    status: TaskStatus;
    tags: string | null;
    createdAt: string;
    updatedAt: string;
}
export interface Epic {
    id: string;
    projectId: string;
    parentEpicId: string | null;
    title: string;
    description: string | null;
    priority: Priority;
    status: EpicStatus;
    createdAt: string;
    updatedAt: string;
}
export interface Comment {
    id: string;
    taskId: string;
    agent: string;
    content: string;
    createdAt: string;
    updatedAt: string;
}
export interface Dependency {
    taskId: string;
    dependsOnTaskId: string;
    createdAt: string;
}
export interface TrekkerResult<T> {
    success: boolean;
    data?: T;
    error?: string;
}
export interface CliRunnerOptions {
    cwd?: string;
    json?: boolean;
    toon?: boolean;
}
//# sourceMappingURL=types.d.ts.map