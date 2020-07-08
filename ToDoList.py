from task_list import Task
from todo_api import ToDoAPI
import requests
import sys
from datetime import datetime



command = ""
while(command != "exit"):
    user_input = input(">>").split(" ")
    command = user_input[0]
    params = user_input[1:]
    if command == "add":
        if params[0] != "subtask":
            task_title = params[0]
            result = ToDoAPI.add_task(task_title)
            print(result)
        else:
            task_title = params[1]
            parent_title = params[2]
            found_tasks = []
            for t in ToDoAPI.get_task_list():
                if t.title == parent_title:
                    found_tasks.append(t)
            if len(found_tasks) == 0:
                print("No Task found titled \"" + parent_title + "\"")
            elif len(found_tasks) > 1:
                print("Multiple Tasks found titled \"" + parent_title + "\"")
                for i in range(len(found_tasks)):
                    print(str(i+1) + ".\t" \
                    + found_tasks[i].title \
                    + "\t" + found_tasks[i].creation_date)
                choice = input("Choose number of parent task:")
                if choice.isnumeric():
                    choice = int(choice)
                    result = ToDoAPI.add_task(task_title, is_child=True,parent_id=found_tasks[choice - 1].id)
            else:
                result = ToDoAPI.add_task(task_title, is_child=True,parent_id=found_tasks[0].id)
                print(result)

    if command == "list":
        tasks = ToDoAPI.get_task_list()      
        for i in range(len(tasks)):
                print(str(i+1) + ".\t" \
                + tasks[i].title \
                + "\t" + tasks[i].creation_date)

    if command == "complete":
        title = params[0]
        found_tasks = []
        for t in ToDoAPI.get_task_list():
            if t.title == title:
                found_tasks.append(t)
        if len(found_tasks) == 0:
            print("No Task found titled \"" + title + "\"")
        elif len(found_tasks) > 1:
            print("Multiple Tasks found titled \"" + title + "\"")
            for i in range(len(found_tasks)):
                print(str(i+1) + ".\t" \
                + found_tasks[i].title \
                + "\t" + found_tasks[i].creation_date)
            choice = input("Choose number of task to complete or \"ALL\" to" \
                "complete all tasks:")
            if choice == "ALL":
                for t in found_tasks:
                    ToDoAPI.complete_task(t.id)
            if choice.isnumeric():
                choice = int(choice)
                ToDoAPI.complete_task(found_tasks[choice - 1].id)
        else:
            ToDoAPI.complete_task(found_tasks[0].id)



