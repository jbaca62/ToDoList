import sys
from task_list import Task

command = ""
while(command != "exit"):
    user_input = input(">>").split(" ")
    command = user_input[0]
    params = user_input[1:]
    if command == "add":
        task_title = params[0]
        Task.add_task(task_title)
        print(task_title + " added to list")

    if command == "list":
        print("Tasks in list:")
        Task.list_tasks(Task.get_incompleted_tasks())

    if command == "complete":
        task_title = params[0]
        Task.complete_task(task_title)
        print(task_title + " marked as completed")
