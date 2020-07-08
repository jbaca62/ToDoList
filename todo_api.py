import requests
from task_list import Task
import config

class ToDoAPI:

    def get_task_list():
        url = config.API_URL + '/list'
        response = requests.get(url)
        tasks = []
        for t in response.json():
            tasks.append(Task.tuple_to_task(t))
        return tasks

    def add_task(task_title, is_child=False, parent_id=0):
        url = config.API_URL + '/add'
        task = {'task_title': task_title,
                'is_child': is_child,
                'parent_id': parent_id}
        response = requests.post(url, json = task)

        return response.text

    def complete_task(task_id):
        url = config.API_URL + '/complete'
        task = {'task_id': task_id}
        response = requests.post(url, json = task)

        return response.text
