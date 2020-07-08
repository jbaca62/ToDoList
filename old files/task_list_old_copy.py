from datetime import datetime
import mysql.connector

insert_task = "INSERT INTO tasks (title, completed, creation_date) VALUES (%s, %s, %s)"
get_incompleted_tasks = "SELECT * FROM tasks WHERE completed = 0"
get_all_tasks = "SELECT * FROM tasks"
set_task_to_complete_by_id = "UPDATE tasks SET completed = 1 WHERE id = %s"

class TaskList:
    def __init__(self):
        self.tasks = self.get_database_tasks()
    
    def add_task(self, title, completed=False, creation_date=datetime.now()):
        vals = (title, completed, creation_date)
        mydb = mysql.connector.connect(
            host="192.168.43.33",
            port="3306",
            user="todolist",
            password="todolist",
            database="todolist"
        )
        mycursor = mydb.cursor()
        mycursor.execute(insert_task, vals)
        mydb.commit()
        mycursor.close()
        self.sync_database()

    def list_tasks(self, tasks=None):
        if tasks == None:
            tasks = self.get_database_tasks()
        for t in tasks:
            print(t.title)

    def get_incompleted_tasks(self):
        mydb = mysql.connector.connect(
            host="192.168.43.33",
            port="3306",
            user="todolist",
            password="todolist",
            database="todolist"
        )
        mycursor = mydb.cursor()
        mycursor.execute(get_incompleted_tasks)
        result = mycursor.fetchall()
        incomplete_tasks = []
        for t in result:
            new_task = Task.tuple_to_task(t)
            incomplete_tasks.append(new_task)

        return incomplete_tasks

    def complete_task(self, title):
        found_tasks = []
        for t in self.get_incompleted_tasks():
            if t.title == title:
                found_tasks.append(t)
        if len(found_tasks) == 0:
            print("No Task found titled \"" + title + "\"")
        elif len(found_tasks) > 1:
            print("Multiple Tasks found titled \"" + title + "\"")
            for i in range(len(found_tasks)):
                print(str(i+1) + ".\t" \
                + found_tasks[i].title \
                + "\t" + t.creation_date.strftime("%m-%d-%y %I:%M%p"))
            choice = input("Choose number of task to complete or \"ALL\" to" \
                "complete all tasks:")
            if choice == "ALL":
                for t in found_tasks:
                    self.mark_task_as_complete(t.id)
            if choice.isnumeric():
                choice = int(choice)
                self.mark_task_as_complete(found_tasks[choice - 1].id)
        else:
            self.mark_task_as_complete(found_tasks[0].id)

    def mark_task_as_complete(self, task_id):
        if type(task_id) != str:
            task_id = str(task_id)
        
        mydb = mysql.connector.connect(
            host="192.168.43.33",
            port="3306",
            user="todolist",
            password="todolist",
            database="todolist"
        )
        mycursor = mydb.cursor()
        task_id = (task_id,)
        mycursor.execute(set_task_to_complete_by_id, task_id)
        mydb.commit()

    def sync_database(self):
        db_tasks = self.get_database_tasks()
        db_last_id = db_tasks[-1].id
        list_last_id = self.tasks[-1].id
        if db_last_id > list_last_id:
            for t in range(list_last_id, db_last_id):
                self.tasks.append(db_tasks[t])


    def get_database_tasks(self):
        mydb = mysql.connector.connect(
            host="192.168.43.33",
            port="3306",
            user="todolist",
            password="todolist",
            database="todolist"
        )
        mycursor = mydb.cursor()
        mycursor.execute(get_all_tasks)
        result = mycursor.fetchall()
        task_list = []
        for t in result:
            new_task = Task.tuple_to_task(t)
            task_list.append(new_task)
       
        mycursor.close()
        return task_list




class Task:
    def __init__(self, task_id, title, completed=False, creation_date=datetime.now()):
        self.id = task_id
        self.title = title
        self.completed = completed
        self.creation_date = creation_date

    def tuple_to_task(data):
        new_task = Task(data[0], data[1], data[2], data[3])
        return new_task



