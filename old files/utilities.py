class ToDoAPI:
    def get_task_list():
    url = 'http://127.0.0.1:5000/list'
    response = requests.get(url)
    tasks = []
    for t in response.json():
        tasks.append(Task.tuple_to_task(t))

    return tasks