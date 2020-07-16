import { Component, OnInit } from '@angular/core';
import { Task } from '../task';
import {TaskService} from '../task.service';

@Component({
  selector: 'app-tasks',
  templateUrl: './tasks.component.html',
  styleUrls: ['./tasks.component.css']
})
export class TasksComponent implements OnInit {

  tasks: Task[] = [];

  constructor(private taskService:TaskService) { }

  ngOnInit(): void {
    this.getTasks();
  }

  getTasks(): void{
    this.taskService.getTasks()
    .subscribe(tasks => this.sortTasks(tasks));
    
  }

  sortTasks(param: any): void{
    param.data.forEach(task => {
      if (task.is_child_task == false) {
        this.tasks.push(task)
        task.child_tasks = [];
      } else {
        this.tasks.forEach(p =>{
          if (p.id == task.parent_id){
            p.child_tasks.push(task);
          }
        });
      }
    });
  }

  addTask(title: string): void{
    title = title.trim();
    if (!title) { return; }
    var task = {"title": title, "is_child": false};
    this.taskService.addTask(task as unknown as Task)
      .subscribe(task => {
        this.tasks.push(task);
      });
  }

  completeTask(task: Task): void{
    this.tasks = this.tasks.filter(t => t !== task);
    this.taskService.completeTask(task)
      .subscribe(t => {
        this.tasks = this.tasks.filter(p => p !== t)
      });
  }



}
