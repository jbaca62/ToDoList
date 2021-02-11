task_as_tuple = (1, 2, 3, 4, 5)
vals = task_as_tuple[1:] + task_as_tuple[:1]
print(type(vals))
print(vals)