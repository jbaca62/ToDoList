from datetime import datetime
import mysql.connector
import config

SQL_insert_task = "INSERT INTO tasks (title, completed, creation_date, is_child_task, parent_id) VALUES (%s, %s, %s, %s, %s)"
SQL_get_incomplete_tasks = "SELECT * FROM tasks WHERE completed = 0"
SQL_get_all_tasks = "SELECT * FROM tasks"
SQL_set_task_to_complete_by_id = "UPDATE tasks SET completed = 1 WHERE id = %s"
SQL_get_task_by_id = "SELECT * FROM tasks WHERE id = %s"
class Task:
    def __init__(self, id, title, completed=False, \
        creation_date=datetime.now(), is_child_task=0, \
        parent_id=0):
        self.id = id
        self.title = title
        self.completed = completed
        self.creation_date = creation_date
        self.is_child_task = is_child_task
        self.parent_id = parent_id

    def tuple_to_task(data):
        new_task = Task(data["id"], data['title'],\
            data["completed"], data['creation_date'],\
            data["is_child_task"], data["parent_id"])
        return new_task

    def tuple_to_dic(data):
        new_dict = {}
        new_dict["id"] = data[0]
        new_dict["title"] = data[1]
        new_dict["completed"] = data[2]
        new_dict["creation_date"] = data[3]
        new_dict["due_date"] = data[4]
        new_dict["is_child_task"] = data[5]
        new_dict["parent_id"] = data[6]
        return new_dict
        
    def add_task(title, completed=False, creation_date=datetime.now(), \
                    is_child=False, parent_id=0):
        vals = (title, completed, creation_date, is_child, parent_id)
        mydb = mysql.connector.connect(
            host=config.DB_CONFIG["host"],
            port=config.DB_CONFIG["port"],
            user=config.DB_CONFIG["user"],
            password=config.DB_CONFIG["password"],
            database=config.DB_CONFIG["database"]
        )
        mycursor = mydb.cursor()
        mycursor.execute(SQL_insert_task, vals)
        task_id = mycursor.lastrowid
        mydb.commit()
        mycursor.close()
        return task_id


    def list_tasks(tasks=None):
        if tasks == None:
            tasks = Task.get_database_tasks()
        for t in tasks:
            print(t.title)

    def get_incomplete_tasks():
        mydb = mysql.connector.connect(
            host=config.DB_CONFIG["host"],
            port=config.DB_CONFIG["port"],
            user=config.DB_CONFIG["user"],
            password=config.DB_CONFIG["password"],
            database=config.DB_CONFIG["database"]
        )
        mycursor = mydb.cursor()
        mycursor.execute(SQL_get_incomplete_tasks)
        result = mycursor.fetchall()
        incomplete_tasks = []
        for t in result:
            #new_task = Task.tuple_to_task(t)
            incomplete_tasks.append(t)
        
        mycursor.close()
        return incomplete_tasks

    def get_task_by_id(task_id):
        mydb = mysql.connector.connect(
            host=config.DB_CONFIG["host"],
            port=config.DB_CONFIG["port"],
            user=config.DB_CONFIG["user"],
            password=config.DB_CONFIG["password"],
            database=config.DB_CONFIG["database"]
        )
        mycursor = mydb.cursor()
        task_id = (task_id,)
        mycursor.execute(SQL_get_task_by_id, task_id)
        result = mycursor.fetchone()
        mycursor.close()
        print("in get_task_by_id() result:", result)
        return Task.tuple_to_dic(result)



    def complete_task(title):
        found_tasks = []
        for t in Task.get_incomplete_tasks():
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
                    Task.mark_task_as_complete(t.id)
            if choice.isnumeric():
                choice = int(choice)
                Task.mark_task_as_complete(found_tasks[choice - 1].id)
        else:
            Task.mark_task_as_complete(found_tasks[0].id)

    def mark_task_as_complete(task_id):
        if type(task_id) != str:
            task_id = str(task_id)
        
        mydb = mysql.connector.connect(
            host=config.DB_CONFIG["host"],
            port=config.DB_CONFIG["port"],
            user=config.DB_CONFIG["user"],
            password=config.DB_CONFIG["password"],
            database=config.DB_CONFIG["database"]
        )
        mycursor = mydb.cursor()
        task_id = (task_id,)
        mycursor.execute(SQL_set_task_to_complete_by_id, task_id)
        mydb.commit()
        task_id = mycursor.lastrowid
        mycursor.close()
        return task_id

    """ def sync_database(self):
        db_tasks = self.get_database_tasks()
        db_last_id = db_tasks[-1].id
        list_last_id = self.tasks[-1].id
        if db_last_id > list_last_id:
            for t in range(list_last_id, db_last_id):
                self.tasks.append(db_tasks[t]) """


    def get_database_tasks():
        mydb = mysql.connector.connect(
            host=config.DB_CONFIG["host"],
            port=config.DB_CONFIG["port"],
            user=config.DB_CONFIG["user"],
            password=config.DB_CONFIG["password"],
            database=config.DB_CONFIG["database"]
        )
        mycursor = mydb.cursor()
        mycursor.execute(SQL_get_all_tasks)
        result = mycursor.fetchall()
        task_list = []
        for t in result:
            new_task = Task.tuple_to_task(t)
            task_list.append(new_task)
       
        mycursor.close()
        return task_list



