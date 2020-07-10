import { Injectable } from '@angular/core';
import {Task} from './task';
import {TASKS} from './mock-tasks';
import {Observable, of } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class TaskService {

  constructor(private http:HttpClient) { }

  private tasksUrl = 'api/heroes';  // URL to web api

  getTasks(): Observable<Task[]>{
    return of(TASKS);
  }
}
