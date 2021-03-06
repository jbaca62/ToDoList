from flask import Flask, render_template, request, jsonify
import sys
from task_list import Task
from flask_cors import CORS


app = Flask(__name__)
CORS(app)


@app.route("/")
def homepage():
    return render_template("index.html")


## CLEANUP function contains unnecessary parts related to unimplemented child tasks
@app.route("/add", methods=["POST"])
def add_task():
    if request.method == "POST":
        data = request.json
        print(type(data))
        print(data)
        title = data["title"]
        is_child = data["is_child_task"]
        if is_child:
            parent_id = data["parent_id"]
            task_id = Task.add_task(title, is_child=is_child, parent_id=parent_id)
        else:
            task_id = Task.add_task(title, description=data["description"])

        task_dic = Task.get_task_by_id(task_id)
        print(task_dic)
        return jsonify(task_dic)


@app.route("/update", methods=["PUT"])
def update_task():
    if request.method == "PUT":
        data = request.json
        task_id = Task.update_task(
            data["id"], data["title"], data["description"], data["completed"]
        )
        print(task_id)
        task_dic = Task.get_task_by_id(task_id)
        return jsonify(task_dic)


@app.route("/delete", methods=["DELETE"])
def delete_task():
    if request.method == "DELETE":
        data = request.json
        task_id = data["id"]
        was_deleted = Task.delete_task(task_id)
        return "True"


""" 
    Returned Schema:
    {data:
        [{id: ,
        title: ,
        completed: ,
        creation_date: ,
        due_data: ,
        is_child_task: ,
        parent_id: 
        }]
    }
"""


@app.route("/list", methods=["GET"])
def list_tasks():
    if request.method == "GET":
        tasks = []
        for t in Task.get_incomplete_tasks():
            tasks.append(Task.DBtuple_to_dic(t))
        data = {"data": tasks}
        return jsonify(data)


@app.route("/complete", methods=["POST"])
def complete_task():
    if request.method == "POST":
        task_id = request.json["id"]
        Task.mark_task_as_complete(task_id)
        completed_task = Task.get_task_by_id(task_id)
        print(type(completed_task))
        print(completed_task)
        return jsonify(completed_task)


if __name__ == "__main__":
    app.run(host="0.0.0.0")
