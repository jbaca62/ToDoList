import { Injectable } from '@angular/core';
import {Task} from './task';
import {Observable, of } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class TaskService {

  constructor(private http:HttpClient) { }

  private tasksUrl = 'http://192.168.43.33:5000';  // URL to web api

  httpOptions = {
    headers: new HttpHeaders({ 'Content-Type': 'application/json' })
  };

  getTasks(): Observable<Task[]>{
    let resp = this.http.get<Task[]>(this.tasksUrl + "/list");
    return resp;
  }

  addTask(task: Task): Observable<Task>{
    return this.http.post<Task>(this.tasksUrl + "/add", task, this.httpOptions);
  }

  completeTask(task: Task): Observable<Task>{
    return this.http.post<Task>(this.tasksUrl + "/complete", task, this.httpOptions);
  }
}

/* getHeroes(): Observable<Hero[]> {
  return this.http.get<Hero[]>(this.heroesUrl)
    .pipe(
      tap(_ => this.log('fetched heroes')),
      catchError(this.handleError<Hero[]>('getHeroes', []))
    );
} */
