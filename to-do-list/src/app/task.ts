export interface Task {
    id: number;
    title: string;
    completed: boolean;
    creation_date: string;
    is_child_task: boolean;
    parent_id: number;
    child_tasks: Task[];
  }