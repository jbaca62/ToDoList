import { Component, OnInit } from '@angular/core';
import { Task } from '../task';
import {TaskService} from '../task.service';

@Component({
  selector: 'app-tasks',
  templateUrl: './tasks.component.html',
  styleUrls: ['./tasks.component.css']
})
export class TasksComponent implements OnInit {

  tasks: Task[];

  constructor(private taskService:TaskService) { }

  ngOnInit(): void {
    this.getTasks();
  }

  getTasks(): void{
    this.taskService.getTasks()
    .subscribe(tasks => this.taskStuff(tasks));
    
  }

  taskStuff(param: Task[]): void{
    console.log(param)
    this.tasks = param;
  }

}