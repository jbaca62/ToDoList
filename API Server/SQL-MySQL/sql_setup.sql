USE todolist;

DROP TABLE IF EXISTS tasks;

CREATE TABLE tasks (
    id int(11) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title varchar(128) NOT NULL,
    description varchar(512),
    completed BOOLEAN NOT NULL,
    creation_date varchar(32),
    due_date varchar(32),
    is_child_task BOOLEAN NOT NULL,
    parent_task INT UNSIGNED
);