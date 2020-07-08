import requests
from task_list import Task

class ToDoAPI:

    def get_task_list():
        url = 'http://127.0.0.1:5000/list'
        response = requests.get(url)
        tasks = []
        for t in response.json():
            tasks.append(Task.tuple_to_task(t))
        return tasks

    def add_task(task_title, is_child=False, parent_id=0):
<<<<<<< Updated upstream
        url = 'http://127.0.0.1:5000/add'
=======
        url = 'http://192.168.43.33:5000/add'
>>>>>>> Stashed changes
        task = {'task_title': task_title,
                'is_child': is_child,
                'parent_id': parent_id}
        response = requests.post(url, json = task)

        return response.text

    def complete_task(task_id):
<<<<<<< Updated upstream
        url = 'http://127.0.0.1:5000/complete'
=======
        url = 'http://192.168.43.33:5000/complete'
>>>>>>> Stashed changes
        task = {'task_id': task_id}
        response = requests.post(url, json = task)

        return response.text
