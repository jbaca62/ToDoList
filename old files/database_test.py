import mysql.connector

mydb = mysql.connector.connect(
  host="192.168.43.33",
  port="3306",
  user="todolist",
  password="todolist"
)

mycursor = mydb.cursor()

mycursor.execute("SHOW DATABASES")

for x in mycursor:
  print(x)