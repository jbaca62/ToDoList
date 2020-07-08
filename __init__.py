from flask import Flask, render_template, request, jsonify
import sys
from task_list import Task


app = Flask(__name__)

@app.route('/')
def homepage():
    return render_template("index.html")
    
@app.route('/add', methods=['POST'])
def add_task():
    if request.method == 'POST':
        data = request.json
        task_title = data["task_title"]
        is_child = data["is_child"]
        if is_child:
            parent_id = data["parent_id"]
            Task.add_task(task_title, is_child=is_child, parent_id=parent_id)
        else:       
            Task.add_task(task_title)
        
        return "Added " + task_title + " to list"

@app.route('/list', methods=['GET'])
def list_tasks():
    if request.method == 'GET':
        tasks = Task.get_incompleted_tasks()
        return jsonify(tasks)

@app.route('/complete', methods=['POST'])
def complete_task():
    if request.method == 'POST':
        task_id = request.json["task_id"]
        Task.mark_task_as_complete(task_id)
        return "Completed test"

if __name__ == '__main__':
    app.run(host='0.0.0.0')